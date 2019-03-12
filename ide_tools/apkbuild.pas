unit ApkBuild;

{$mode objfpc}{$H+}

interface

uses
  {$if defined(Windows)}
    {$define Emulator}
    Windows,
  {$elseif not defined(Darwin)}
    {$define Emulator}
    XWindow,
  {$endif}
  Classes, SysUtils, ProjectIntf, Forms, LamwSettings, LCLVersion;

type

  { TApkBuilder }

  TApkBuilder = class
  private
    FProj: TLazProject;
    FSdkPath, FJdkPath, FNdkPath: string;
    FAntPath, FGradlePath: string;
    FProjPath: string;
    FDevice: string;
    {$ifdef Emulator}
    procedure BringToFrontEmulator;
    {$endif}
    function CheckAvailableDevices: Boolean;
    procedure CleanUp;
    function GetManifestSdkTarget(out SdkTarget: string): Boolean;
    procedure LoadPaths;
    function RunAndGetOutput(const cmd, params: string; Aout: TStrings): Integer;
    function TryFixPaths: TModalResult;

    function FixBuildSystemConfig(ForceFixPaths: Boolean): TModalResult;
    function FixAntConfig(ForceFixPaths: Boolean): TModalResult;
    function FixGradleConfig({%H-}ForceFixPaths: Boolean): TModalResult;

    function BuildByAnt: Boolean;
    function InstallByAnt: Boolean;
    procedure RunByAdb;

    function BuildByGradle: Boolean;
    procedure RunByGradle;
  public
    constructor Create(AProj: TLazProject);
    function BuildAPK: Boolean;
    procedure RunAPK;
  end;

procedure RegisterExtToolParser;

implementation

uses
  IDEExternToolIntf, UTF8Process, Controls, StdCtrls,
  ButtonPanel, Dialogs, uFormStartEmulator, process, strutils,
  laz2_XMLRead, Laz2_DOM, laz2_XMLWrite, LazFileUtils, FileUtil;

const
  SubToolAnt = 'ant';
  SubToolGradle = 'gradle';

type

  { TAntParser }

  TAntParser = class(TExtToolParser)
  public
    procedure ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean); override;
    class function DefaultSubTool: string; override;
  end;

  { TGradleParser }

  TGradleParser = class(TExtToolParser)
  private
    FFailureGot: Boolean;
  public
    procedure InitReading; override;
    procedure ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean); override;
    class function DefaultSubTool: string; override;
  end;

function CollectDirs(const PathMask: string): TStringList;
var
  dir: TSearchRec;
begin
  Result := TStringList.Create;
  if FindFirst(PathMask, faDirectory, dir) = 0 then
    repeat
      if dir.Name[1] <> '.' then
      begin
        Result.Add(dir.Name);
      end;
    until (FindNext(dir) <> 0);
  FindClose(dir);
end;

function ChooseDlg(const Title, Prompt: string; sl: TStringList; var s: string): Boolean;
var
  lb: TListBox;
  f: TForm;
begin
  f := TForm.Create(nil);
  try
    f.Position := poScreenCenter;
    f.Caption := Title;
    f.AutoSize := True;
    f.BorderIcons := [biSystemMenu];
    with TLabel.Create(f) do
    begin
      Parent := f;
      Align := alTop;
      BorderSpacing.Around := 6;
      Caption := Prompt;
    end;
    lb := TListBox.Create(f);
    lb.Parent := f;
    lb.Align := alClient;
    lb.Items.Assign(sl);
    lb.BorderSpacing.Around := 6;
    lb.Constraints.MinHeight := 200;
    lb.ItemIndex := 0;
    with TButtonPanel.Create(f) do
    begin
      Parent := f;
      ShowButtons := [pbOK, pbCancel];
      ShowBevel := False;
    end;
    if f.ShowModal <> mrOk then Exit(False);
    s := lb.Items[lb.ItemIndex];
    Result := True;
  finally
    f.Free;
  end;
end;

function IsAllCharNumber(pcString: PChar): Boolean;
begin
  Result := False;
  while pcString^ <> #0 do // 0 indicates the end of a PChar string
  begin
    if not (pcString^ in ['0'..'9']) then Exit;
    Inc(pcString);
  end;
  Result := True;
end;

{ TGradleParser }

procedure TGradleParser.InitReading;
begin
  inherited InitReading;
  FFailureGot := False;
end;

procedure TGradleParser.ReadLine(Line: string; OutputIndex: integer;
  {$if lcl_fullversion>=2010000}IsStdErr: boolean;{$endif}
  var Handled: boolean);
var
  msgLine: TMessageLine;
begin
  msgLine := CreateMsgLine(OutputIndex);
  msgLine.Msg := Line;
  msgLine.Urgency := mluProgress;
  if Trim(Line) <> '' then
  begin
    if Pos('FAILURE', Line) > 0 then
    begin
      FFailureGot := True;
      msgLine.Urgency := mluFatal;
      Tool.ErrorMessage := Line;
    end else
    if FFailureGot then
      msgLine.Urgency := mluImportant;
  end;
  AddMsgLine(msgLine);
  Handled := True;
end;

class function TGradleParser.DefaultSubTool: string;
begin
  Result := SubToolGradle;
end;

{ TAntParser }

procedure TAntParser.ReadLine(Line: string; OutputIndex: integer;
  {$if lcl_fullversion>=2010000}IsStdErr: boolean;{$endif}
  var Handled: boolean);
var
  msgLine: TMessageLine;
begin
  msgLine := CreateMsgLine(OutputIndex);
  msgLine.Msg := Line;
  if Pos('[exec] Failure', Line) > 0 then
  begin
    msgLine.Urgency := mluError;
    Tool.ErrorMessage := Line;
  end else
    msgLine.Urgency := mluProgress;
  AddMsgLine(msgLine);
  Handled := True;
end;

class function TAntParser.DefaultSubTool: string;
begin
  Result := SubToolAnt;
end;

{ TApkBuilder }

procedure TApkBuilder.LoadPaths;
begin
  LamwGlobalSettings.QueryPaths := True;
  FSdkPath := LamwGlobalSettings.PathToAndroidSDK;
  FJdkPath := LamwGlobalSettings.PathToJavaJDK;
  FNdkPath := LamwGlobalSettings.PathToAndroidNDK;
  if FProj.CustomData['BuildSystem'] = 'Gradle' then
    FGradlePath := LamwGlobalSettings.PathToGradle
  else
    FAntPath := LamwGlobalSettings.PathToAntBin;
end;

function TApkBuilder.RunAndGetOutput(const cmd, params: string;
  Aout: TStrings): Integer;
var
  i, t: Integer;
  ms: TMemoryStream;
  buf: array [0..255] of Byte;
begin
  with TProcessUTF8.Create(nil) do
  try
    Options := [poUsePipes, poStderrToOutPut, poWaitOnExit];
    Executable := cmd;
    Parameters.Text := params;
    ShowWindow := swoHIDE;
    Execute;
    ms := TMemoryStream.Create;
    try
      t := Output.NumBytesAvailable;
      while t > 0 do
      begin
        i := Output.Read(buf{%H-}, SizeOf(buf));
        if i > 0 then
        begin
          ms.Write(buf, i);
          t := t - i
        end else
          Break;
      end;
      ms.Position := 0;
      Aout.LoadFromStream(ms);
    finally
      ms.Free;
    end;
    Result := ExitCode;
  finally
    Free;
  end;
end;

function TApkBuilder.GetManifestSdkTarget(out SdkTarget: string): Boolean;
var
  ManifestXML: TXMLDocument;
  n: TDOMNode;
begin
  Result := False;
  if not FileExists(FProjPath + 'AndroidManifest.xml') then Exit;
  try
    ReadXMLFile(ManifestXML, FProjPath + 'AndroidManifest.xml');
    try
      n := ManifestXML.DocumentElement.FindNode('uses-sdk');
      if not (n is TDOMElement) then Exit;
      SdkTarget := TDOMElement(n).AttribStrings['android:targetSdkVersion'];
      Result := True;
    finally
      ManifestXML.Free
    end;
  except
    Exit;
  end;
end;

function TApkBuilder.TryFixPaths: TModalResult;

  procedure FixArmLinuxAndroidEabiVersion(var path: string);
  var
    i: Integer;
    s, p: string;
    sl: TStringList;
  begin
    if DirectoryExists(path) then Exit;
    i := Pos('arm-linux-androideabi-', path);
    if i = 0 then Exit;
    p := Copy(path, 1, PosEx(PathDelim, path, i));
    if DirectoryExists(p) then Exit;
    Delete(p, 1, i + 21);
    p := Copy(p, 1, Pos(PathDelim, p) - 1);
    if p = '' then Exit;
    s := Copy(path, 1, i - 1);
    sl := CollectDirs(s + 'arm-linux-androideabi-*');
    try
      if sl.Count > 1 then
      begin
        sl.Sort;
        if not ChooseDlg('arm-linux-androideabi',
          'Choose arm-linux-androideabi version:', sl, s) then Exit;
      end else
        s := sl[0];
    finally
      sl.Free;
    end;
    Delete(s, 1, 22);
    if s = '' then Exit;
    path := StringReplace(path, p, s, [rfReplaceAll]);
  end;

  function PosIdent(const str, dest: string): Integer;
  var i: Integer;
  begin
    i := Pos(str, dest);
    repeat
      if ((i = 1) or not (dest[i - 1] in ['a'..'z', 'A'..'Z']))
      and ((i + Length(str) > Length(dest))
           or not (dest[i + Length(str)] in ['a'..'z', 'A'..'Z'])) then Break;
      i := PosEx(str, dest, i + 1);
    until i = 0;
    Result := i;
  end;

  function FixPath(var path: string; const truncBy, newPath: string): Boolean;
  var
    i, j: Integer;
    dirs: TStringList;
  begin
    DoDirSeparators(path);
    Delete(path, 1, PosIdent(truncBy, path));
    Delete(path, 1, Pos(PathDelim, path));
    path := IncludeTrailingPathDelimiter(newPath) + path;
    FixArmLinuxAndroidEabiVersion(path);
    if not DirectoryExists(path) then
    begin
      i := Pos(PathDelim, path);
      while i > 0 do
      begin
        while DirectoryExists(Copy(path, 1, i)) do
        begin
          j := i;
          i := PosEx(PathDelim, path, i + 1);
          if i = 0 then Exit(True);
        end;
        dirs := CollectDirs(Copy(path, 1, j) + '*');
        try
          if dirs.Count <> 1 then Exit(False);
          Delete(path, j + 1, i - j - 1);
          Insert(dirs[0], path, j + 1);
          i := PosEx(PathDelim, path, j + 1);
        finally
          dirs.Free;
        end;
      end;
    end else
      Result := True;
  end;

var
  sl: TStringList;
  i: Integer;
  ForceFixPaths: Boolean;
  str, prev, pref: string;
begin
  Result := mrOK;
  ForceFixPaths := False;
  if not DirectoryExists(FNdkPath) then
    raise Exception.Create('NDK path (' + FNdkPath + ') does not exist! '
      + 'Fix NDK path by Path settings in Tools menu.');
  sl := TStringList.Create;
  try
    // Libraries
    sl.Delimiter := ';';
    sl.DelimitedText := FProj.LazCompilerOptions.Libraries;
    for i := 0 to sl.Count - 1 do
    begin
      if not DirectoryExists(sl[i]) then
      begin
        str := sl[i];
        if not FixPath(str, 'ndk', FNdkPath) then Exit;
        if not ForceFixPaths then
        begin
          case MessageDlg('Path "' + sl[i] + '" does not exist.' + sLineBreak +
                        'Change it to "' + str + '"?',
                        mtConfirmation, [mbYes, mbYesToAll, mbCancel], 0) of
            mrYesToAll: ForceFixPaths := True;
            mrYes:
            else Exit(mrAbort);
          end;
        end;
        sl[i] := str;
      end;
    end;
    FProj.LazCompilerOptions.Libraries := sl.DelimitedText;

    // Custom options:
    sl.Delimiter := ' ';
    sl.DelimitedText := FProj.LazCompilerOptions.CustomOptions;
    for i := 0 to sl.Count - 1 do
    begin
      str := sl[i];
      pref := Copy(str, 1, 3);
      if pref = '-FD' then
      begin
        Delete(str, 1, 3);
        prev := str;
        if Pos(';', str) > 0 then Exit;
        if not DirectoryExists(str) then
        begin
          if not FixPath(str, 'ndk', FNdkPath) then Exit;
          if not ForceFixPaths then
          begin
            case MessageDlg('Path "' + prev + '" does not exist.' + sLineBreak +
                          'Change it to "' + str + '"?',
                          mtConfirmation, [mbYes, mbYesToAll, mbCancel], 0) of
              mrYesToAll: ForceFixPaths := True;
              mrYes:
              else Exit(mrAbort);
            end;
          end;
          sl[i] := pref + str;
        end;
      end;
    end;
    FProj.LazCompilerOptions.CustomOptions := sl.DelimitedText;
  finally
    sl.Free;
  end;

  Result := FixBuildSystemConfig(ForceFixPaths);
end;

function TApkBuilder.FixBuildSystemConfig(ForceFixPaths: Boolean): TModalResult;
begin
  if FProj.CustomData['BuildSystem'] = 'Gradle' then
  begin
    if Pos('AppCompat', FProj.CustomData['Theme']) > 0 then
       Result:= mrNo
    else
       Result := FixGradleConfig(ForceFixPaths);
  end
  else
  begin
    Result := FixAntConfig(ForceFixPaths);
  end;
end;

function TApkBuilder.FixAntConfig(ForceFixPaths: Boolean): TModalResult;

  function SetManifestSdkTarget(SdkTarget: string): Boolean;
  var
    ManifestXML: TXMLDocument;
    n: TDOMNode;
    fn: string;
  begin
    Result := False;
    fn := FProjPath + 'AndroidManifest.xml';
    if not FileExists(fn) then Exit;
    try
      ReadXMLFile(ManifestXML, fn);
      try
        n := ManifestXML.DocumentElement.FindNode('uses-sdk');
        if not (n is TDOMElement) then Exit;
        TDOMElement(n).AttribStrings['android:targetSdkVersion'] := SdkTarget;
        WriteXML(ManifestXML, fn);
        Result := True;
      finally
        ManifestXML.Free
      end;
    except
      Exit;
    end;
  end;

var
  xml: TXMLDocument;
  WasChanged: Boolean;
  i: Integer;
  str, sval, temp: string;
  sl: TStringList;
  outIndex: integer;
begin
  Result := mrOk;
  // build.xml
  ReadXMLFile(xml, FProjPath + 'build.xml');
  try
    WasChanged := False;
    with xml.DocumentElement.ChildNodes do
      for i := 0 to Count - 1 do
        if (Item[i] is TDOMElement)
        and (TDOMElement(Item[i]).TagName = 'property') then
        begin
          case TDOMElement(Item[i]).AttribStrings['name'] of
          'sdk.dir':
            begin
              str := TDOMElement(Item[i]).AttribStrings['location'];
              if not DirectoryExists(str) and DirectoryExists(FSdkPath) then
              begin
                if not ForceFixPaths
                and (MessageDlg('build.xml',
                               'Path "' + str + '" does not exist.' + sLineBreak +
                               'Change it to "' + FSdkPath + '"?', mtConfirmation,
                               [mbYes, mbNo], 0) <> mrYes) then Exit(mrAbort);
                TDOMElement(Item[i]).AttribStrings['location'] := FSdkPath;
                WasChanged := True;
              end;
            end;
          'target':
            begin
              // fix "target" according to AndroidManifest
              sval := TDOMElement(Item[i]).AttribStrings['value'];
              if not GetManifestSdkTarget(str) then
                str := sval
              else
                str := 'android-' + str;

              sl := CollectDirs(AppendPathDelim(FSdkPath) + 'platforms' + PathDelim + 'android-*');
              sl.Sorted := True;

                //try remove "android-P"
              if sl.Find('android-P', outIndex) then
                sl.Delete(outIndex);

              //try remove "android-W"
              if sl.Find('android-4.4W.2', outIndex) then
                sl.Delete(outIndex);

              try
                if sl.Count = 0 then Continue;
                if (sl.IndexOf(sval) < 0) and (sl.IndexOf(str) >= 0) then
                begin
                  if MessageDlg('build.xml',
                                'Change target to "' + str + '"?',
                                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Continue;

                  temp:= Copy(str, LastDelimiter('-', str) + 1, MaxInt);
                  if IsAllCharNumber(PChar(temp)) then
                  begin
                      TDOMElement(Item[i]).AttribStrings['value'] := str;
                      WasChanged := True;
                  end
                  else
                      ShowMessage('Sorry... Fail to change "build.xml" SDK TargetApi...');


                end else
                if (sl.IndexOf(sval) >= 0) and (sval <> str) then
                begin
                  if MessageDlg('Manifest.xml',
                                'SDK for "' + str + '" is not installed. Do you ' +
                                'want to use "' + sval + '"?',
                                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Continue;
                  str := sval;
                  Delete(str, 1, 8);

                  if IsAllCharNumber(PChar(str)) then
                      SetManifestSdkTarget(str)
                  else
                      ShowMessage('Sorry... Fail to change Manifest SDK TargetApi...');

                end else
                if sl.IndexOf(sval) < 0 then
                begin
                  if sl.Count = 1 then
                  begin
                    if MessageDlg('Target SDK',
                                  'You have only installed "' + sl[0] + '" SDK. ' +
                                  'Do you want to use it?',
                                  mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Continue;

                    str := sl[0];
                  end else
                    if not ChooseDlg('Target SDK', 'Choose target SDK:', sl, str) then Continue;

                  temp:= Copy(str, LastDelimiter('-', str) + 1, MaxInt);
                  if IsAllCharNumber(PChar(temp)) then
                  begin
                    TDOMElement(Item[i]).AttribStrings['value'] := str;
                    WasChanged := True;
                    Delete(str, 1, 8);
                    SetManifestSdkTarget(str);
                  end
                  else
                      ShowMessage('Sorry... Fail to change Manifest SDK TargetApi...');

                end;
              finally
                sl.Free
              end;
            end;
          end;
        end;
    if WasChanged then
      WriteXMLFile(xml, FProjPath + 'build.xml');
  finally
    xml.Free;
  end;
end;

function TApkBuilder.FixGradleConfig(ForceFixPaths: Boolean): TModalResult;
var
  i, j: Integer;
  s, target, indent: string;
  WasChanged: Boolean;
begin
  Result := mrOk;
  WasChanged := False;
  if GetManifestSdkTarget(target) then
    with TStringList.Create do
    try
      LoadFromFile(FProjPath + 'build.gradle');
      for i := 0 to Count - 1 do
        if Pos('compileSdkVersion', Strings[i]) > 0 then
        begin
          s := Strings[i];
          j := 1;
          while s[j] in [' ', #9] do Inc(j);
          indent := Copy(s, 1, j - 1);
          System.Delete(s, 1, j);
          System.Delete(s, 1, Pos(' ', s));
          s := Trim(s);
          if (s <> target) and
             (MessageDlg('build.gradle',
                         'Change compileSdkVersion to "' + target + '"?',
                         mtConfirmation, [mbYes, mbNo], 0) = mrYes)
          then begin
            Strings[i] := indent + 'compileSdkVersion ' + target;
            WasChanged := True;
          end;
          Break;
        end;
      if WasChanged then
        SaveToFile(FProjPath + 'build.gradle');
    finally
      Free;
    end;
end;

function TApkBuilder.BuildByAnt: Boolean;
var
  Tool: TIDEExternalToolOptions;
begin
  Result := False;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Building APK (Ant)... ';

    {$ifdef darwin}
    Tool.EnvironmentOverrides.Add('JAVA_HOME=${/usr/libexec/java_home}');
    {$else}
    Tool.EnvironmentOverrides.Add('JAVA_HOME=' + FJdkPath);
    {$endif}

    Tool.WorkingDirectory := FProjPath;
    Tool.Executable := IncludeTrailingPathDelimiter(FAntPath) + 'ant'{$ifdef windows}+'.bat'{$endif};

    if not FileExists(Tool.Executable) then
      raise Exception.CreateFmt('Ant bin (%s) not found! Check path settings', [Tool.Executable]);

    Tool.CmdLineParams := 'clean -Dtouchtest.enabled=true debug';


    // tk Required for Lazarus >=1.7 to capture output correctly
{$if lcl_fullversion >= 1070000}
    Tool.ShowConsole := True;
{$endif}
    // end tk
    Tool.Scanners.Add(SubToolAnt);
    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot build APK!');
    Result := True;
  finally
    Tool.Free;
  end;
end;

{$ifdef Emulator}
procedure TApkBuilder.BringToFrontEmulator;
var
  emul_win: TStringList;
  i: Integer;
  str: string;
begin
  if Pos('emulator-', FDevice) <> 1 then Exit;
  emul_win := TStringList.Create;
  try
    EnumWindows(@FindEmulatorWindows, LPARAM(emul_win));
    str := FDevice;
    Delete(str, 1, Pos('-', str));
    i := 1;
    while (i <= Length(str)) and (str[i] in ['0'..'9']) do Inc(i);
    str := Copy(str, 1, i - 1);
    for i := 0 to emul_win.Count - 1 do
      if (Pos(str + ':', emul_win[i]) = 1)
      or (Pos(':' + str, emul_win[i]) > 0) then
      begin
        SetForegroundWindow(HWND(emul_win.Objects[i]));
        Break;
      end;
  finally
    emul_win.Free;
  end;
end;
{$endif}

function TApkBuilder.CheckAvailableDevices: Boolean;
var
  sl, devs: TStringList;
  i: Integer;
  dev, NeedReget: Boolean;
  str: string;
begin
  sl := TStringList.Create;
  devs := TStringList.Create;
  try
    repeat
      NeedReget := False;
      sl.Clear;
      RunAndGetOutput(IncludeTrailingPathDelimiter(FSdkPath) + 'platform-tools'
        + PathDelim + 'adb', 'devices', sl);
      dev := False;
      for i := 0 to sl.Count - 1 do
      begin
        str := Trim(sl[i]);
        if str = '' then Continue;
        if str[1] = '*' then
        begin
          NeedReget := True;
          Break;
        end;
        if dev then
          devs.Add(str)
        else
        if Pos('List ', str) = 1 then
          dev := True;
      end;
      if NeedReget then Continue;
      if devs.Count = 0 then
        with TfrmStartEmulator.Create(FSdkPath, @RunAndGetOutput) do
        try
          if ShowModal = mrCancel then Exit(False);
        finally
          Free;
        end
      else
      if devs.Count > 1 then
        break;//todo: ChooseDevice(devs);
    until devs.Count = 1;
    FDevice := devs[0];
    Result := True;
  finally
    devs.Free;
    sl.Free;
  end;
end;

procedure TApkBuilder.CleanUp;
var
  tempDir: string;
  SdkTarget: string;
begin
  if GetManifestSdkTarget(SdkTarget) then
  begin
    tempDir := FProjPath + 'src' + PathDelim
      +
        StringReplace(FProj.CustomData['Package'], '.', PathDelim, [rfReplaceAll])
      + PathDelim + 'android-' + SdkTarget;
    if DirectoryExists(tempDir) then
       DeleteDirectory(tempDir, False);
  end;
end;

constructor TApkBuilder.Create(AProj: TLazProject);
begin
  FProj := AProj;
  FProjPath := ExtractFilePath(ChompPathDelim(ExtractFilePath(FProj.MainFile.Filename)));
  LoadPaths;
  if TryFixPaths = mrAbort then
    Abort;
end;

function TApkBuilder.BuildAPK: Boolean;
begin
  CleanUp;
  if FProj.CustomData['BuildSystem'] = 'Gradle' then
    Result := BuildByGradle
  else
    Result := BuildByAnt;
end;

function TApkBuilder.InstallByAnt: Boolean;
var
  Tool: TIDEExternalToolOptions;
  smallProjectName, auxPath: string;
  p: integer;
begin
  Result := False;
  if not CheckAvailableDevices then Exit;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Installing APK (Ant)... ';

    {$ifdef windows}
    Tool.EnvironmentOverrides.Add('JAVA_HOME=' + FJdkPath);
    {$endif}
    {$ifdef linux}
    Tool.EnvironmentOverrides.Add('JAVA_HOME=' + FJdkPath);
    {$endif}
    {$ifdef darwin}
    Tool.EnvironmentOverrides.Add('JAVA_HOME=${/usr/libexec/java_home}');
    {$endif}

    Tool.WorkingDirectory := FProjPath;
    auxPath:= Copy(FProjPath, 1, Length(FProjPath)-1);
    p:= LastDelimiter(PathDelim,auxPath);
    smallProjectName:= Copy(auxPath, p+1 , MaxInt);

    //Tool.Executable := IncludeTrailingPathDelimiter(FAntPath) + 'ant'{$ifdef windows}+'.bat'{$endif};
    //Tool.CmdLineParams := 'installd';

    Tool.Executable := IncludeTrailingPathDelimiter(FSdkPath) +'platform-tools'+PathDelim+'adb'{$ifdef windows}+'.exe'{$endif};
    Tool.CmdLineParams := 'install -r '+ FProjPath + 'bin'+ PathDelim + smallProjectName+'-debug.apk';

    // tk Required for Lazarus >=1.7 to capture output correctly
{$if lcl_fullversion >= 1070000}
    Tool.ShowConsole := True;
{$endif}
    // end tk
    Tool.Scanners.Add(SubToolAnt);
    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot install APK!');
    Result := True;
  finally
    Tool.Free;
  end;
end;

procedure TApkBuilder.RunAPK;
begin
  if FProj.CustomData['BuildSystem'] = 'Gradle' then
    RunByGradle
  else begin
    if not InstallByAnt then
      raise Exception.Create('Cannot install APK');
    RunByAdb;
  end;
  {$ifdef Emulator}
  BringToFrontEmulator;
  {$endif}
end;

procedure TApkBuilder.RunByAdb;
var
  xml: TXMLDocument;
  f, proj: string;
  Tool: TIDEExternalToolOptions;
begin
  f := FProjPath + PathDelim + 'AndroidManifest.xml';
  ReadXMLFile(xml, f);
  try
    proj := xml.DocumentElement.AttribStrings['package'];
    if proj = '' then
      raise Exception.Create('Cannot determine package name!');
  finally
    xml.Free;
  end;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Starting APK... ';
    Tool.ResolveMacros := True;
    Tool.Executable := IncludeTrailingPathDelimiter(FSdkPath) + 'platform-tools' + PathDelim + 'adb$(ExeExt)';
    Tool.CmdLineParams := 'shell am start -n ' + proj + '/.App';
    Tool.Scanners.Add(SubToolDefault);
    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot run APK!');
  finally
    Tool.Free;
    //total clean up!
    CleanUp;
  end;
end;

function TApkBuilder.BuildByGradle: Boolean;
var
  Tool: TIDEExternalToolOptions;
begin
  Result := False;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Building APK (Gradle)... ';
    Tool.EnvironmentOverrides.Add('GRADLE_HOME=' + FGradlePath);
    Tool.EnvironmentOverrides.Add('PATH=' + GetEnvironmentVariable('PATH')
      + PathSep + FSdkPath + 'platform-tools'
      + PathSep + FGradlePath + 'bin');
    Tool.WorkingDirectory := FProjPath;
    Tool.Executable := FGradlePath + 'bin' + PathDelim + 'gradle'{$ifdef windows}+'.bat'{$endif};
    if not FileExists(Tool.Executable) then
      raise Exception.CreateFmt('Gradle (%s) not found! Check path settings', [Tool.Executable]);
    Tool.CmdLineParams := 'clean build --info';
    // tk Required for Lazarus >=1.7 to capture output correctly
{$if lcl_fullversion >= 1070000}
    Tool.ShowConsole := True;
{$endif}
    // end tk
    Tool.Scanners.Add(SubToolGradle);
    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot build APK!');
    Result := True;
  finally
    Tool.Free;
  end;
end;

procedure TApkBuilder.RunByGradle;
var
  Tool: TIDEExternalToolOptions;
begin
  if not CheckAvailableDevices then Exit;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Starting APK (Gradle)... ';
    Tool.EnvironmentOverrides.Add('GRADLE_HOME=' + FGradlePath);
    Tool.EnvironmentOverrides.Add('PATH=' + GetEnvironmentVariable('PATH')
      + PathSep + FSdkPath + 'platform-tools'
      + PathSep + FGradlePath + 'bin');
    Tool.WorkingDirectory := FProjPath;
    Tool.Executable := FGradlePath + 'bin' + PathDelim + 'gradle'{$ifdef windows}+'.bat'{$endif};
    if not FileExists(Tool.Executable) then
      raise Exception.CreateFmt('Gradle (%s) not found! Check path settings', [Tool.Executable]);
    Tool.CmdLineParams := 'run';
    // tk Required for Lazarus >=1.7 to capture output correctly
{$if lcl_fullversion >= 1070000}
    Tool.ShowConsole := True;
{$endif}
    // end tk
    Tool.Scanners.Add(SubToolGradle);
    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot run APK!');
  finally
    Tool.Free;
    //total clean up!
    CleanUp;
  end;
end;

procedure RegisterExtToolParser;
begin
  ExternalToolList.RegisterParser(TAntParser);
  ExternalToolList.RegisterParser(TGradleParser);
end;

end.


