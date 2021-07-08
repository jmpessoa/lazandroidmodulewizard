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
    FGdbCop: boolean;
    FApkRun: boolean;
    FPackageName: string;
    FAdbShellOneLine: string;
    FScanPID: array[0..1] of cardinal;
    FScanName: array[0..1] of string;

    {$ifdef Emulator}
    procedure BringToFrontEmulator;
    {$endif}
    function CheckAvailableDevices: boolean;
    procedure CleanUp;
    function GetManifestSdkTarget(out SdkTarget: string): boolean;
    procedure LoadPaths;
    function RunAndGetOutput(const cmd, params: string; Aout: TStrings): integer;
    function TryFixPaths: TModalResult;

    function FixBuildSystemConfig(ForceFixPaths: boolean): TModalResult;
    function FixAntConfig(ForceFixPaths: boolean): TModalResult;
    function FixGradleConfig({%H-}ForceFixPaths: boolean): TModalResult;

    function BuildByAnt: boolean;
    function InstallByAnt: boolean;
    procedure RunByAdb;

    function BuildByGradle: boolean;
    procedure RunByGradle;

    procedure DoBeforeBuildApk;
    procedure DoAfterRunApk;

    function GetTargetCpuAbiList: boolean;
    function GetTargetBuildVersionSdk(var VerSdk: integer): boolean;
    function GetPackageName: string;
    function GetAdbExecutable: string;
    function GetGdbSolibSearchPath: string;
    function GetLibCtrlsFileName(var Name: string): boolean;

    function DoAdbCommand(Title: string;
      Command: string;
      Parser: string): boolean;

    function CheckAdbCommand(ChkCmd: string): boolean;

    function Call_PID_scan_pidof(Proj: string): boolean;

    function Call_PID_scan_ps(Proj: string;
      Server: string;
      NewPS: boolean): boolean;

    function AdbPull(PullName,
      DestPath: string): boolean;
    function PullAppsProc(PullNames: array of string;
      DestPath: string): boolean;
    function CopyLibCtrls(DestPath: string): boolean;
    function CopyGdbServerToLibsDir: boolean;

    function SetHostAppFileName(AppName: string): boolean;

    function SetAdbForward(SrvName: string;
      SrvPort: string): boolean;

    function KillLastGdbServer(Proj: string): boolean;
    procedure StartNewGdbServer(Proj, Port: string);

  public
    constructor Create(AProj: TLazProject);
    function BuildAPK: boolean;
    procedure RunAPK;
    property AdbExecutable: string read GetAdbExecutable;
    property PackageName: string read GetPackageName;
  end;

procedure RegisterExtToolParser;

implementation

uses
  IDEExternToolIntf, UTF8Process, Controls, StdCtrls,
  ButtonPanel, Dialogs, uFormStartEmulator, process, strutils,
  laz2_XMLRead, Laz2_DOM, laz2_XMLWrite, LazFileUtils, FileUtil,
  LazIDEIntf, GDBMIServerDebuggerLAMW;

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
    FFailureGot: boolean;
  public
    procedure InitReading; override;
    procedure ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean); override;
    class function DefaultSubTool: string; override;
  end;

function IsAllCharNumber(pcString: PChar): boolean;
begin
  Result := False;
  if StrLen(pcString) = 0 then
    exit;
  while pcString^ <> #0 do // 0 indicates the end of a PChar string
  begin
    if not (pcString^ in ['0'..'9']) then
      Exit;
    Inc(pcString);
  end;
  Result := True;
end;

function CollectDirs(const PathMask: string): TStringList;
var
  p: integer;
  dir: TSearchRec;
  collectSdkPlatforms: boolean;
  api: string;
begin

  collectSdkPlatforms := False;
  if Pos('platforms' + PathDelim + 'android-', PathMask) > 0 then
    collectSdkPlatforms := True;

  Result := TStringList.Create;
  if FindFirst(PathMask, faDirectory, dir) = 0 then
    repeat
      if dir.Name[1] <> '.' then
      begin
        if collectSdkPlatforms then
        begin
          p := Pos('-', dir.Name);
          if p > 0 then
          begin
            api := Copy(dir.Name, p + 1, MaxInt);
            if IsAllCharNumber(PChar(api)) then
            begin
              Result.Add(dir.Name);
            end;
          end;
        end
        else
        begin
          Result.Add(dir.Name);
        end;
      end;
    until (FindNext(dir) <> 0);
  FindClose(dir);
end;

function ChooseDlg(const Title, Prompt: string; sl: TStringList; var s: string): boolean;
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
    if f.ShowModal <> mrOk then
      Exit(False);
    s := lb.Items[lb.ItemIndex];
    Result := True;
  finally
    f.Free;
  end;
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
  msgLine.Msg := TrimRight(Line);
  msgLine.Urgency := mluNone;
  if msgLine.Msg <> '' then
  begin
    if (Pos('FAILURE', msgLine.Msg) > 0) then
    begin
      FFailureGot := True;
      msgLine.Urgency := mluFatal;
      Tool.ErrorMessage := Line;
    end
    else
    if (Pos('error: ', msgLine.Msg) > 0) then
    begin
      msgLine.Urgency := mluError;
      Tool.ErrorMessage := Line;
    end
    else
    if Pos('> Task', msgLine.Msg) > 0 then
    begin
      msgLine.Urgency := mluProgress;
    end
    else
    if FFailureGot then
      msgLine.Urgency := mluImportant;
    AddMsgLine(msgLine);
  end;
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
  end
  else
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
  Aout: TStrings): integer;
var
  i, t: integer;
  ms: TMemoryStream;
  buf: array [0..255] of byte;
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
            t := t - i;
          end
          else
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

function TApkBuilder.GetManifestSdkTarget(out SdkTarget: string): boolean;
var
  ManifestXML: TXMLDocument;
  n: TDOMNode;
begin
  Result := False;
  if not FileExists(FProjPath + 'AndroidManifest.xml') then
    Exit;
  try
    ReadXMLFile(ManifestXML, FProjPath + 'AndroidManifest.xml');
    try
      n := ManifestXML.DocumentElement.FindNode('uses-sdk');
      if not (n is TDOMElement) then
        Exit;
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
    i: integer;
    s, p: string;
    sl: TStringList;
  begin
    if DirectoryExists(path) then
      Exit;
    i := Pos('arm-linux-androideabi-', path);
    if i = 0 then
      Exit;
    p := Copy(path, 1, PosEx(PathDelim, path, i));
    if DirectoryExists(p) then
      Exit;
    Delete(p, 1, i + 21);
    p := Copy(p, 1, Pos(PathDelim, p) - 1);
    if p = '' then
      Exit;
    s := Copy(path, 1, i - 1);
    sl := CollectDirs(s + 'arm-linux-androideabi-*');
    try
      if sl.Count > 1 then
      begin
        sl.Sort;
        if not ChooseDlg('arm-linux-androideabi',
          'Choose arm-linux-androideabi version:', sl, s) then
          Exit;
      end
      else
        s := sl[0];
    finally
      sl.Free;
    end;
    Delete(s, 1, 22);
    if s = '' then
      Exit;
    path := StringReplace(path, p, s, [rfReplaceAll]);
  end;

  function PosIdent(const str, dest: string): integer;
  var
    i: integer;
  begin
    i := Pos(str, dest);
    repeat
      if ((i = 1) or not (dest[i - 1] in ['a'..'z', 'A'..'Z'])) and
        ((i + Length(str) > Length(dest)) or not
        (dest[i + Length(str)] in ['a'..'z', 'A'..'Z'])) then
        Break;
      i := PosEx(str, dest, i + 1);
    until i = 0;
    Result := i;
  end;

  function FixPath(var path: string; const truncBy, newPath: string): boolean;
  var
    i, j: integer;
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
          if i = 0 then
            Exit(True);
        end;
        dirs := CollectDirs(Copy(path, 1, j) + '*');
        try
          if dirs.Count <> 1 then
            Exit(False);
          Delete(path, j + 1, i - j - 1);
          Insert(dirs[0], path, j + 1);
          i := PosEx(PathDelim, path, j + 1);
        finally
          dirs.Free;
        end;
      end;
    end
    else
      Result := True;
  end;

var
  sl: TStringList;
  i: integer;
  ForceFixPaths: boolean;
  str, prev, pref: string;
begin
  Result := mrOk;
  ForceFixPaths := False;
  if not DirectoryExists(FNdkPath) then
    raise Exception.Create('NDK path (' + FNdkPath + ') does not exist! ' +
      'Fix NDK path by Path settings in Tools menu.');
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
        if not FixPath(str, 'ndk', FNdkPath) then
          Exit;
        if not ForceFixPaths then
        begin
          case MessageDlg('Path "' + sl[i] + '" does not exist.' +
              sLineBreak + 'Change it to "' + str + '"?',
              mtConfirmation, [mbYes, mbYesToAll, mbCancel], 0) of
            mrYesToAll: ForceFixPaths := True;
            mrYes:
            else
              Exit(mrAbort);
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
        if Pos(';', str) > 0 then
          Exit;
        if not DirectoryExists(str) then
        begin
          if not FixPath(str, 'ndk', FNdkPath) then
            Exit;
          if not ForceFixPaths then
          begin
            case MessageDlg('Path "' + prev + '" does not exist.' +
                sLineBreak + 'Change it to "' + str + '"?',
                mtConfirmation, [mbYes, mbYesToAll, mbCancel], 0) of
              mrYesToAll: ForceFixPaths := True;
              mrYes:
              else
                Exit(mrAbort);
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

function TApkBuilder.FixBuildSystemConfig(ForceFixPaths: boolean): TModalResult;
begin
  if FProj.CustomData['BuildSystem'] = 'Gradle' then
  begin
    if Pos('AppCompat', FProj.CustomData['Theme']) > 0 then
      Result := mrNo
    else
      Result := FixGradleConfig(ForceFixPaths);
  end
  else
  begin
    Result := FixAntConfig(ForceFixPaths);
  end;
end;

function TApkBuilder.FixAntConfig(ForceFixPaths: boolean): TModalResult;

  function SetManifestSdkTarget(SdkTarget: string): boolean;
  var
    ManifestXML: TXMLDocument;
    n: TDOMNode;
    fn: string;
  begin
    Result := False;
    fn := FProjPath + 'AndroidManifest.xml';
    if not FileExists(fn) then
      Exit;
    try
      ReadXMLFile(ManifestXML, fn);
      try
        n := ManifestXML.DocumentElement.FindNode('uses-sdk');
        if not (n is TDOMElement) then
          Exit;
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
  WasChanged: boolean;
  i: integer;
  str, sval, temp: string;
  sl: TStringList;
begin
  Result := mrOk;
  // build.xml
  ReadXMLFile(xml, FProjPath + 'build.xml');
  try
    WasChanged := False;
    with xml.DocumentElement.ChildNodes do
      for i := 0 to Count - 1 do
        if (Item[i] is TDOMElement) and
          (TDOMElement(Item[i]).TagName = 'property') then
        begin
          case TDOMElement(Item[i]).AttribStrings['name'] of
            'sdk.dir':
            begin
              str := TDOMElement(Item[i]).AttribStrings['location'];
              if not DirectoryExists(str) and DirectoryExists(FSdkPath) then
              begin
                if not ForceFixPaths and
                  (MessageDlg('build.xml', 'Path "' +
                  str + '" does not exist.' + sLineBreak +
                  'Change it to "' + FSdkPath + '"?',
                  mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
                  Exit(mrAbort);
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

              sl := CollectDirs(AppendPathDelim(FSdkPath) + 'platforms' +
                PathDelim + 'android-*');
              sl.Sorted := True;

              try
                if sl.Count = 0 then
                  Continue;
                if (sl.IndexOf(sval) < 0) and (sl.IndexOf(str) >= 0) then
                begin
                  if MessageDlg('build.xml',
                    'Change target to "' + str + '"?',
                    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
                    Continue;

                  temp := Copy(str, LastDelimiter('-', str) + 1, MaxInt);
                  if IsAllCharNumber(PChar(temp)) then
                  begin
                    TDOMElement(Item[i]).AttribStrings['value'] := str;
                    WasChanged := True;
                  end
                  else
                    ShowMessage(
                      'Sorry... Fail to change "build.xml" SDK TargetApi...');

                end
                else
                if (sl.IndexOf(sval) >= 0) and (sval <> str) then
                begin
                  if MessageDlg('Manifest.xml',
                    'SDK for "' + str + '" is not installed. Do you ' +
                    'want to use "' + sval + '"?',
                    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
                    Continue;
                  str := sval;
                  Delete(str, 1, 8);

                  if IsAllCharNumber(PChar(str)) then
                    SetManifestSdkTarget(str)
                  else
                    ShowMessage('Sorry... Fail to change Manifest SDK TargetApi...');

                end
                else
                if sl.IndexOf(sval) < 0 then
                begin
                  if sl.Count = 1 then
                  begin
                    if MessageDlg('Target SDK',
                      'You have only installed "' + sl[0] +
                      '" SDK. ' + 'Do you want to use it?',
                      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
                      Continue;

                    str := sl[0];
                  end
                  else
                  if not ChooseDlg('Target SDK', 'Choose target SDK:', sl, str) then
                    Continue;

                  temp := Copy(str, LastDelimiter('-', str) + 1, MaxInt);
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

function TApkBuilder.FixGradleConfig(ForceFixPaths: boolean): TModalResult;
var
  p: integer;
  WasChanged: boolean;
  strList: TStringList;
  target, tempStr, findString, oldCompileSdkVersion: string;
  aSupportLib: TSupportLib;
begin
  Result := mrOk;
  WasChanged := False;

  if GetManifestSdkTarget(target) then
  begin
    strList := TStringList.Create;
    try
      strList.LoadFromFile(FProjPath + 'build.gradle');

      p := Pos('compileSdkVersion ', strList.Text);
      tempStr := Trim(Copy(strList.Text, p, Length('compileSdkVersion ') + 2));
      p := Pos(' ', tempStr);
      oldCompileSdkVersion := Trim(Copy(tempStr, p + 1, 2));

      if (oldCompileSdkVersion <> target) and
        (MessageDlg('build.gradle',
        'Change compileSdkVersion to "' + target + '"?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      begin
        tempStr := strList.Text;

        findString := 'compileSdkVersion ';
        if (Pos(findString, tempStr) > 0) then
          tempStr := StringReplace(tempStr, findString + oldCompileSdkVersion,
            findString + target, [rfIgnoreCase]);

        for aSupportLib in SupportLibs do
        begin
          if (Pos(aSupportLib.Name, tempStr) > 0) then
            tempStr := StringReplace(tempStr, aSupportLib.Name + oldCompileSdkVersion,
              aSupportLib.Name + target, [rfIgnoreCase]);
        end;

        strList.Text := tempStr;
        WasChanged := True;
      end;
      if WasChanged then
        strList.SaveToFile(FProjPath + 'build.gradle');
    finally
      strList.Free;
    end;
  end;
end;

function TApkBuilder.BuildByAnt: boolean;
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
    Tool.Executable := IncludeTrailingPathDelimiter(FAntPath) + 'ant'
{$ifdef windows}+'.bat'{$endif}
    ;

    if not FileExists(Tool.Executable) then
      raise Exception.CreateFmt('Ant bin (%s) not found! Check path settings',
        [Tool.Executable]);

    Tool.CmdLineParams := 'clean -Dtouchtest.enabled=true debug';


    // tk Required for Lazarus >=1.7 to capture output correctly
{$if lcl_fullversion >= 1070000}
    Tool.ShowConsole := True;
{$endif}
    // end tk
    {$IF LCL_FULLVERSION >= 2010000}
    Tool.Parsers.Add(SubToolAnt);
    {$ELSE}
    Tool.Scanners.Add(SubToolAnt);
    {$ENDIF}

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
  i: integer;
  str: string;
begin
  if Pos('emulator-', FDevice) <> 1 then
    Exit;
  emul_win := TStringList.Create;
  try
    EnumWindows(@FindEmulatorWindows, LPARAM(emul_win));
    str := FDevice;
    Delete(str, 1, Pos('-', str));
    i := 1;
    while (i <= Length(str)) and (str[i] in ['0'..'9']) do
      Inc(i);
    str := Copy(str, 1, i - 1);
    for i := 0 to emul_win.Count - 1 do
      if (Pos(str + ':', emul_win[i]) = 1) or (Pos(':' + str, emul_win[i]) > 0) then
      begin
        SetForegroundWindow(HWND(emul_win.Objects[i]));
        Break;
      end;
  finally
    emul_win.Free;
  end;
end;

{$endif}

function TApkBuilder.CheckAvailableDevices: boolean;
var
  sl, devs: TStringList;
  i: integer;
  dev, NeedReget: boolean;
  str: string;
begin
  sl := TStringList.Create;
  devs := TStringList.Create;
  try
    repeat
      NeedReget := False;
      sl.Clear;
      RunAndGetOutput(IncludeTrailingPathDelimiter(FSdkPath) +
        'platform-tools' + PathDelim + 'adb', 'devices', sl);
      dev := False;
      for i := 0 to sl.Count - 1 do
      begin
        str := Trim(sl[i]);
        if str = '' then
          Continue;
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
      if NeedReget then
        Continue;
      if devs.Count = 0 then
        with TfrmStartEmulator.Create(FSdkPath, @RunAndGetOutput) do
          try
            if ShowModal = mrCancel then
              Exit(False);
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
    tempDir := FProjPath + 'src' + PathDelim +
      StringReplace(FProj.CustomData['Package'], '.', PathDelim, [rfReplaceAll]) +
      PathDelim + 'android-' + SdkTarget;
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

function TApkBuilder.BuildAPK: boolean;
begin
  CleanUp;
  DoBeforeBuildApk;
  if FProj.CustomData['BuildSystem'] = 'Gradle' then
    Result := BuildByGradle
  else
    Result := BuildByAnt;
end;

function TApkBuilder.InstallByAnt: boolean;
var
  Tool: TIDEExternalToolOptions;
  smallProjectName, auxPath: string;
  p: integer;
begin
  Result := False;
  if not CheckAvailableDevices then
    Exit;
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
    auxPath := Copy(FProjPath, 1, Length(FProjPath) - 1);
    p := LastDelimiter(PathDelim, auxPath);
    smallProjectName := Copy(auxPath, p + 1, MaxInt);

    //Tool.Executable := IncludeTrailingPathDelimiter(FAntPath) + 'ant'{$ifdef windows}+'.bat'{$endif};
    //Tool.CmdLineParams := 'installd';

    Tool.Executable := IncludeTrailingPathDelimiter(FSdkPath) +
      'platform-tools' + PathDelim + 'adb'
{$ifdef windows}+'.exe'{$endif}
    ;
    Tool.CmdLineParams := 'install -r ' + FProjPath + 'bin' + PathDelim +
      smallProjectName + '-debug.apk';

    // tk Required for Lazarus >=1.7 to capture output correctly
{$if lcl_fullversion >= 1070000}
    Tool.ShowConsole := True;
{$endif}
    // end tk
    {$IF LCL_FULLVERSION >= 2010000}
    Tool.Parsers.Add(SubToolAnt);
    {$ELSE}
    Tool.Scanners.Add(SubToolAnt);
    {$ENDIF}

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
  else
  begin
    if not InstallByAnt then
      raise Exception.Create('Cannot install APK');
    RunByAdb;
  end;
  {$ifdef Emulator}
  BringToFrontEmulator;
  {$endif}
  DoAfterRunApk;
end;

procedure TApkBuilder.RunByAdb;
var
  xml: TXMLDocument;
  f, proj: string;
  Tool: TIDEExternalToolOptions;
begin
  FApkRun := False;
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
    Tool.Executable := IncludeTrailingPathDelimiter(FSdkPath) +
      'platform-tools' + PathDelim + 'adb$(ExeExt)';
    Tool.CmdLineParams := 'shell am start -n ' + proj + '/.App';
    {$IF LCL_FULLVERSION >= 2010000}
    Tool.Parsers.Add(SubToolDefault);
    {$ELSE}
    Tool.Scanners.Add(SubToolDefault);
    {$ENDIF}

    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot run APK!');
    FApkRun := True;
  finally
    Tool.Free;
    //total clean up!
    CleanUp;
  end;
end;

function TApkBuilder.BuildByGradle: boolean;
var
  Tool: TIDEExternalToolOptions;
  manifestFileName: string;
  manifest: TXMLDocument;
  usesSdkElementList: TDOMNodeList;
begin
  Result := False;
  {07.07.2021. bogomolov-a-a Backup AndroidManifest.xml}
  manifestFileName := (IncludeTrailingPathDelimiter(FProjPath) + 'AndroidManifest.xml');
  CopyFile(manifestFileName, manifestFileName + '.bak');
  ReadXMLFile(manifest, manifestFileName, []);
  usesSdkElementList := manifest.DocumentElement.GetElementsByTagName('uses-sdk');
  if usesSdkElementList.Count > 0 then
  begin
    manifest.DocumentElement.RemoveChild(usesSdkElementList.Item[0]);
    WriteXMLFile(manifest, manifestFileName);

  end;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Building APK (Gradle)... ';
    Tool.EnvironmentOverrides.Add('GRADLE_HOME=' + FGradlePath);
    Tool.EnvironmentOverrides.Add('JAVA_HOME=' + FJdkPath);
    Tool.EnvironmentOverrides.Add('PATH=' + GetEnvironmentVariable('PATH') +
      PathSep + FSdkPath + 'platform-tools' + PathSep + FGradlePath + 'bin');
    Tool.WorkingDirectory := FProjPath;
    Tool.Executable := FGradlePath + 'bin' + PathDelim + 'gradle'
{$ifdef windows}+'.bat'{$endif}
    ;
    if not FileExists(Tool.Executable) then
      raise Exception.CreateFmt('Gradle (%s) not found! Check path settings',
        [Tool.Executable]);
    Tool.CmdLineParams := 'clean build --info';
    // tk Required for Lazarus >=1.7 to capture output correctly
{$if lcl_fullversion >= 1070000}
    Tool.ShowConsole := True;
{$endif}
    // end tk
    {$IF LCL_FULLVERSION >= 2010000}
    Tool.Parsers.Add(SubToolGradle);
    {$ELSE}
    Tool.Scanners.Add(SubToolGradle);
    {$ENDIF}

    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot build APK!');
    Result := True;
  finally
    CopyFile(manifestFileName + '.bak', manifestFileName);
    DeleteFile(manifestFileName + '.bak');
    Tool.Free;
  end;
end;

procedure TApkBuilder.RunByGradle;
var
  Tool: TIDEExternalToolOptions;
begin
  FApkRun := False;
  if not CheckAvailableDevices then
    Exit;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Starting APK (Gradle)... ';
    Tool.EnvironmentOverrides.Add('GRADLE_HOME=' + FGradlePath);
    Tool.EnvironmentOverrides.Add('JAVA_HOME=' + FJdkPath);
    Tool.EnvironmentOverrides.Add('PATH=' + GetEnvironmentVariable('PATH') +
      PathSep + FSdkPath + 'platform-tools' + PathSep + FGradlePath + 'bin');
    Tool.WorkingDirectory := FProjPath;
    Tool.Executable := FGradlePath + 'bin' + PathDelim + 'gradle'
{$ifdef windows}+'.bat'{$endif}
    ;
    if not FileExists(Tool.Executable) then
      raise Exception.CreateFmt('Gradle (%s) not found! Check path settings',
        [Tool.Executable]);
    Tool.CmdLineParams := 'run';
    // tk Required for Lazarus >=1.7 to capture output correctly
{$if lcl_fullversion >= 1070000}
    Tool.ShowConsole := True;
{$endif}
    // end tk
    {$IF LCL_FULLVERSION >= 2010000}
    Tool.Parsers.Add(SubToolGradle);
    {$ELSE}
    Tool.Scanners.Add(SubToolGradle);
    {$ENDIF}

    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot run APK!');
    FApkRun := True;
  finally
    Tool.Free;
    //total clean up!
    CleanUp;
  end;
end;

{ Local constants, types, classes & vars for gdb debugger from Lazarus IDE }
const
  SubToolPidOf = 'AdbPidOf';
  SubToolPs = 'AdbPs';
  SubToolPull = 'AdbPull';
  SubToolList = 'AdbList';
  GdbDirLAMW = 'gdb';
  JniDirLAMW = 'jni';

type
  TBigBuildMode = (bmNo, bmArmV6Soft, bmArmV7Soft, bmX86);

const
  bmLibsSubDir: array[TBigBuildMode] of string =
    ('No', 'armeabi', 'armeabi-v7a', 'x86');

const
  bmGdbSrvMask: array[TBigBuildMode] of string =
    ('No', 'android-arm', 'android-arm', 'android-x86');

var
  CurBigBuildMode: TBigBuildMode = bmNo;
  abApkBuilder: TApkBuilder = nil;

{ TAdbShellPidOfParser }

type
  TAdbShellPidOfParser = class(TExtToolParser)
  public
    procedure ReadPID(ALine: string; AmsgLine: TMessageLine;
      Idx: integer);
    procedure ReadLine(Line: string; OutputIndex: integer;
        {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean); override;
    class function DefaultSubTool: string; override;
  end;

  TAdbShellPsParser = class(TAdbShellPidOfParser)
  public
    procedure ReadLine(Line: string; OutputIndex: integer;
        {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean); override;
    class function DefaultSubTool: string; override;
  end;

  { TAdbPullParser }
  TAdbPullParser = class(TExtToolParser)
  public
    procedure ReadLine(Line: string; OutputIndex: integer;
        {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean); override;
    class function DefaultSubTool: string; override;
  end;

  { TAdbShellListParser }

  TAdbShellListParser = class(TExtToolParser)
  public
    procedure ReadLine(Line: string; OutputIndex: integer;
        {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean); override;
    class function DefaultSubTool: string; override;
  end;


{ TAdbShellPidOfParser }

procedure TAdbShellPidOfParser.ReadPID(ALine: string;
  AmsgLine: TMessageLine;
  Idx: integer);
var
  PID, Code: integer;
begin
  Val(ALine, PID, Code);
  if (Code <> 0) or (PID < 1) then
  begin
    AmsgLine.Urgency := mluError;
    Tool.ErrorMessage := AmsgLine.Msg;
    if Assigned(abApkBuilder) then
      abApkBuilder.FScanPID[Idx] := 0;
  end
  else
  begin
    AmsgLine.Urgency := mluProgress;
    if Assigned(abApkBuilder) then
      abApkBuilder.FScanPID[Idx] := PID;
  end;
end;

procedure TAdbShellPidOfParser.ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
  var Handled: boolean);
var
  msgLine: TMessageLine;
begin
  msgLine := CreateMsgLine(OutputIndex);
  msgLine.Msg := Line;
  if Line <> '' then
    ReadPID(Line, msgLine, 0);
  AddMsgLine(msgLine);
  Handled := True;
end;

class function TAdbShellPidOfParser.DefaultSubTool: string;
begin
  Result := SubToolPidOf;
end;


{ TAdbShellPsParser }

procedure TAdbShellPsParser.ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
  var Handled: boolean);
var
  msgLine: TMessageLine;
  I, J, K: integer;
  SList: TStringList;
begin
  msgLine := CreateMsgLine(OutputIndex);
  msgLine.Msg := Line;
  msgLine.Urgency := mluProgress;
  if Assigned(abApkBuilder) then
    for J := 0 to 1 do
      if (Pos(abApkBuilder.FScanName[J], Line) <> 0) then
      begin
        try
          SList := TStringList.Create;
          SList.Delimiter := ' ';
          SList.StrictDelimiter := True;
          SList.DelimitedText := Line;
          K := 0;
          for I := 0 to SList.Count - 1 do
            if SList.Strings[I] <> '' then
            begin
              if K = 1 then         //  <> '' SubSting[1] in Line = PID
              begin
                ReadPID(SList.Strings[I], msgLine, J);
                Break;
              end;
              Inc(K);
            end;
        finally
          SList.Free;
        end;
      end;
  AddMsgLine(msgLine);
  Handled := True;
end;

class function TAdbShellPsParser.DefaultSubTool: string;
begin
  Result := SubToolPs;
end;


{ TAdbPullParser }

procedure TAdbPullParser.ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
  var Handled: boolean);
var
  msgLine: TMessageLine;
begin
  msgLine := CreateMsgLine(OutputIndex);
  msgLine.Msg := Line;
  msgLine.Urgency := mluProgress;
  AddMsgLine(msgLine);
  Handled := True;
end;

class function TAdbPullParser.DefaultSubTool: string;
begin
  Result := SubToolPull;
end;


{ TAdbShellListParser }

procedure TAdbShellListParser.ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
  var Handled: boolean);
var
  msgLine: TMessageLine;
begin
  msgLine := CreateMsgLine(OutputIndex);
  msgLine.Msg := Line;
  msgLine.Urgency := mluProgress;
  AddMsgLine(msgLine);
  Handled := True;
  if (Line <> '') and Assigned(abApkBuilder) then
    abApkBuilder.FAdbShellOneLine := Line;
end;

class function TAdbShellListParser.DefaultSubTool: string;
begin
  Result := SubToolList;
end;


{ TApkBuilder (functions for gdb debugger from Lazarus IDE)}

function TApkBuilder.GetPackageName: string;
var
  xml: TXMLDocument;
begin
  if FPackageName <> '' then
  begin
    Result := FPackageName;
    Exit;
  end
  else
    Result := '';
  try
    ReadXMLFile(xml, FProjPath + PathDelim + 'AndroidManifest.xml');

    FPackageName := xml.DocumentElement.AttribStrings['package'];
    if FPackageName = '' then
      raise Exception.Create('Cannot determine package name!')
    else
      Result := FPackageName;
  finally
    xml.Free;
  end;
end;

function TApkBuilder.GetAdbExecutable: string;
begin
  Result := IncludeTrailingPathDelimiter(FSdkPath) + 'platform-tools' + PathDelim +
    'adb$(ExeExt)';
end;

function TApkBuilder.DoAdbCommand(Title: string;
  Command: string;
  Parser: string): boolean;
var
  Tool: TIDEExternalToolOptions;
begin
  Tool := TIDEExternalToolOptions.Create;
  Result := False;
  try
    Tool.Title := Title;
    Tool.ResolveMacros := True;
    Tool.Executable := AdbExecutable;
    Tool.CmdLineParams := Command;
    {$IF LCL_FULLVERSION >= 2010000}
    Tool.{%H-}Parsers.Add(Parser);
    {$ELSE}
    Tool.{%H-}Scanners.Add(Parser);
    {$ENDIF}

    Result := RunExternalTool(Tool);
  finally
    Tool.Free;
  end;
end;

function TApkBuilder.CheckAdbCommand(ChkCmd: string): boolean;
begin
  Result := DoAdbCommand('Check ' + ChkCmd,
    'shell ls ' + ChkCmd, SubToolList) and
    (FAdbShellOneLine <> '');
  if not Result then
    raise
    Exception.Create('Cannot check ' + ChkCmd + ' command')
  else
    Result := (Pos(ChkCmd, FAdbShellOneLine) <> 0) and
      (Pos('No such', FAdbShellOneLine) = 0);
end;

function TApkBuilder.Call_PID_scan_pidof
  (Proj: string): boolean;
begin
  Result := DoAdbCommand('Scan ' + Proj + ' PID...',
    'shell pidof ' + Proj, SubToolPidOf) and
    (FScanPID[0] <> 0);
  if not Result then
    raise
    Exception.Create('Cannot scan ' + Proj + ' PID!  ');
end;

function TApkBuilder.Call_PID_scan_ps
  (Proj: string;
  Server: string;
  NewPS: boolean): boolean;
var
  Param: string;
begin
  if NewPS then
    Param := ' -A'
  else
    Param := '';

  FScanName[0] := Proj;
  FScanName[1] := Server;
  FScanPID[0] := 0;
  FScanPID[1] := 0;

  Result := DoAdbCommand('Scan ' + Proj + ' PID...',
    'shell ps' + Param, SubToolPs) and
    (FScanPID[0] <> 0);
  if not Result then
    raise
    Exception.Create('Cannot scan ' + Proj + ' PID!  ');
end;

function TApkBuilder.KillLastGdbServer(Proj: string): boolean;
begin
  if 0 < FScanPID[1] then
    Result := DoAdbCommand('Kill last gdbserver',
      'shell run-as ' + Proj + ' kill -9 ' + IntToStr(FScanPID[1]),
      SubToolDefault)
  else
    Result := True;

  if not Result then
    raise
    Exception.Create('Cannot kill last gdbserver PID=' + IntToStr(FScanPID[1]));
end;

procedure TApkBuilder.StartNewGdbServer(Proj, Port: string);
var
  Run: boolean;
begin
  if GdbCfg.GdbServerRun = gsrRunAsPackageName then
  begin
    Run := DoAdbCommand('Start(run-as ' +
      Proj + ' lib/gdbserver --multi :' + Port + ')', 'shell run-as ' +
      Proj + ' lib/gdbserver --multi :' + Port,
      SubToolDefault);
    if Run then
    else
      raise Exception.Create('Cannot start(run-as ' + Proj +
        ' lib/gdbserver --multi :' + Port + ')');
  end
  else
  begin
    Run := DoAdbCommand('Start(/data/data/' +
      Proj + '/lib/gdbserver --multi :' + Port + ')', 'shell /data/data/' +
      Proj + '/lib/gdbserver --multi :' + Port,
      SubToolDefault);
    if Run then
    else
      raise Exception.Create('Cannot start(/data/data/' + Proj +
        '/lib/gdbserver --multi :' + Port + ')');
  end;
end;

function TApkBuilder.AdbPull(PullName, DestPath: string): boolean;
begin
  Result := DoAdbCommand(' Pull ' + PullName + ' to ' +
    DestPath, 'pull ' + PullName +
    ' ' + DestPath, SubToolPull);
  if not Result then
    raise
    Exception.Create('Cannot pull ' + PullName + ' to ' + DestPath);
end;

function TApkBuilder.GetTargetCpuAbiList: boolean;
begin
  FAdbShellOneLine := '';
  Result := DoAdbCommand(' Get CPU Abilist',
    'shell getprop ro.product.cpu.abilist',
    SubToolList) and (FAdbShellOneLine <> '');
  if not Result then
    raise
    Exception.Create('Cannot get CPU Abilist');
end;

function TApkBuilder.GetTargetBuildVersionSdk(var VerSdk: integer): boolean;
var
  Code: integer;
begin
  FAdbShellOneLine := '';
  Result := DoAdbCommand(' Get Build Version Sdk',
    'shell getprop ro.build.version.sdk',
    SubToolList) and (FAdbShellOneLine <> '');
  if Result then
  begin
    Val(FAdbShellOneLine, VerSdk, Code);
    Result := (Code = 0) and (1 < VerSdk);
  end;
  if not Result then
    raise
    Exception.Create('Cannot get Build Version Sdk');
end;

function TApkBuilder.GetGdbSolibSearchPath: string;
begin
  Result := FProjPath + GdbDirLAMW;
  if PathDelim <> '/' then
    Result := StringReplace(Result, PathDelim, '/', [rfReplaceAll]);
end;

function TApkBuilder.GetLibCtrlsFileName(var Name: string): boolean;
var
  Project: TXMLDocument;
  Child: TDOMNode;
begin
  Result := False;
  try
    ReadXMLFile(Project, FProjPath + JniDirLAMW + PathDelim + 'controls.lpi');
    Child := Project.DocumentElement.FindNode('CompilerOptions');
    if Assigned(Child) then
    begin
      with Child.FindNode('Target').FindNode('Filename') do
        Name := FProjPath + JniDirLAMW + PathDelim + Attributes.Item[0].NodeValue;
      Result := Name <> '';
    end;
  finally
    Project.Free;
  end;
end;

function TApkBuilder.PullAppsProc(PullNames: array of string;
  DestPath: string): boolean;
var
  I: integer;
begin
  Result := True;
  for I := Low(PullNames) to High(PullNames) do
    if Result then
      Result := AdbPull(PullNames[I], DestPath)
    else
      Exit;
end;

function TApkBuilder.CopyLibCtrls(DestPath: string): boolean;
var
  LibCtrlsName: string;
begin
  Result := GetLibCtrlsFileName(LibCtrlsName);
  if Result then
  begin
    Result := FileExists(LibCtrlsName + '.so') and
      CopyFile(LibCtrlsName + '.so',
      DestPath + ExtractFileName(LibCtrlsName) + '.so',
      [cffOverwriteFile], False);
    if Result then
      if FileExists(LibCtrlsName + '.dbg') then
        Result := CopyFile(LibCtrlsName + '.dbg',
          DestPath + ExtractFileName(LibCtrlsName) + '.dbg',
          [cffOverwriteFile], False);
  end;
end;

function GetBigBuildMode(LibCtrlsName: string): TBigBuildMode;
var
  I: TBigBuildMode;
begin
  for I := Low(TBigBuildMode) to High(TBigBuildMode) do
    if Pos(bmLibsSubDir[I], LibCtrlsName) <> 0 then
    begin
      Result := I;
      Exit;
    end
    else
      Result := bmNo;
end;

function FindFileMaskName(Folder, Mask, Name: string; var FileName: string): boolean;
var
  SrR: TSearchRec;
  DosError: integer;
begin
  Result := False;
  DosError := SysUtils.FindFirst(Folder + PathDelim + '*.*', faAnyFile, SrR);
  while DosError = 0 do
  begin
    if SrR.Attr and faDirectory <> 0 then
      if (SrR.Name <> '.') and (SrR.Name <> '..') then
        Result := FindFileMaskName(Folder + PathDelim + SrR.Name, Mask, Name, FileName)
      else
    else
    begin
      Result := (Pos(Mask, Folder) <> 0) and (Name = SrR.Name);
      if Result then
        FileName := Folder + PathDelim + SrR.Name;
    end;
    if Result then
      DosError := 10000
    else
      DosError := FindNext(SrR);
  end;
  SysUtils.FindClose(SrR);
end;

function TApkBuilder.CopyGdbServerToLibsDir: boolean;
var
  I: TBigBuildMode;
  LibCtrlsName, GdbServer: string;
begin
  Result := GetLibCtrlsFileName(LibCtrlsName);
  if Result then
  begin
    I := GetBigBuildMode(LibCtrlsName);
    Result := I <> bmNo;
    if Result then
    begin
      Result := FindFileMaskName(ExtractFileDir(FNdkPath),
        bmGdbSrvMask[I], 'gdbserver', GdbServer);
      if Result then
        Result := CopyFile(GdbServer, ExtractFilePath(LibCtrlsName) +
          ExtractFileName(GdbServer), [cffOverwriteFile], False);
      if Result then
        CurBigBuildMode := I;
    end;
  end;
end;

function TApkBuilder.SetHostAppFileName(AppName: string): boolean;
begin
  if FProj.RunParameters.Count > 0 then
  else
    FProj.RunParameters.Add('default');
  Result := FProj.RunParameters.Count > 0;
  if Result then
    FProj.RunParameters.Modes[0].HostApplicationFilename := AppName
  else
    MessageDlg(
      'Could not setup Host Application Filename to "' +
      AppName + '"' + sLineBreak + 'Setup it in Run/Parametrs',
      mtWarning, [mbYes, mbCancel], 0);
  // for android Gdb File command
end;

function TApkBuilder.SetAdbForward(SrvName: string;
  SrvPort: string): boolean;
begin
  Result := SrvName <> '';
  if Result then
  else
  begin
    Result := DoAdbCommand('Adb forward tcp:' + SrvPort + ' tcp:' + SrvPort,
      'forward tcp:' + SrvPort + ' tcp:' + SrvPort,
      SubToolDefault);
    if not Result then
      raise
      Exception.Create('Cannot Adb forward tcp:' + SrvPort + ' tcp:' + SrvPort);
  end;
end;

procedure TApkBuilder.DoBeforeBuildApk;
begin
  abApkBuilder := Self;// For parsers
  FPackageName := ''; // Reread from lpi file
  FGdbCop :=
    (FProj.LazBuildModes.Count > 0) and
    FProj.LazBuildModes.BuildModes[0].LazCompilerOptions.GenerateDebugInfo and
    // Check IDE genegation debug info
    CopyGdbServerToLibsDir;
  // Copy NDK gdbserver to Libs/ABI dir
  FApkRun := False;
  // Apk is not running
end;

procedure TApkBuilder.DoAfterRunApk;
var
  VerSdk: integer;
begin
  if FGdbCop and FApkRun then
  else
    Exit;
  // Check gdbserver in Apk & Apk is running
  if GetTargetCpuAbiList then
  else
    Exit;
  // adb shell getprop ro.product.cpu.abilist
  if Pos(bmLibsSubDir[CurBigBuildMode], FAdbShellOneLine) <> 0 then
  else
    // Check target ABI
  begin
    MessageDlg(
      'Current LAMW build chipset "' + bmLibsSubDir[CurBigBuildMode] + '"' + sLineBreak +
      'does not compatible with target ABI "' + FAdbShellOneLine + '"' + sLineBreak +
      'Change it to "' + FAdbShellOneLine + '"',
      mtWarning, [mbYes, mbCancel], 0);
    Exit;
  end;

  Sleep(2000);   // Wait 2 seconds for starting program

  if GetTargetBuildVersionSdk(VerSdk) and
    // Get Build Version SDK
    Call_PID_scan_ps(PackageName, 'gdbserver', 25 < VerSdk) then
    // Scan PID of LAMW proj
  begin
    GdbCfg.ProjName := PackageName;
    GdbCfg.ProjPID := FScanPID[0];
    // For PIDs List in GDBMIServerDebuggerLAMW.pas

    if DirectoryExists(FProjPath + GdbDirLAMW) then
    else
      MkDir(FProjPath + GdbDirLAMW);
    // Create Dir for GDB if it not Exists

    if PullAppsProc(['/system/bin/app_process32',
      '/system/bin/linker',
      '/system/lib/libc.so'],
      GetGdbSolibSearchPath) and
      // Pull app_process32 & linker & libc.so
      //   to GetGdbSolibSearchPath for 32 bits Target (!)
      CopyLibCtrls(FProjPath + GdbDirLAMW +
      PathDelim) and
      // Copy libcontrols.so & libcontrols.dbg
      //   to  GdbDirLAMW
      SetHostAppFileName(FProjPath + GdbDirLAMW
      + PathDelim + 'app_process32') and
      // Setup HostApplicationFilename=app_process32

      SetAdbForward(GdbCfg.GdbServerName, GdbCfg.GdbServerPort) and
      // If GdbServerName='' then
      //   Adb forward tcp:+GdbServerPort+' tcp:'+GdbServerPort

      KillLastGdbServer(PackageName)
    // Kill last gdbserver
    then
      StartNewGdbServer(PackageName, GdbCfg.GdbServerPort);
    // Start gdbserver in mode --multi GdbServerPort
  end;
  abApkBuilder := nil;
end;


procedure RegisterExtToolParser;
begin
  ExternalToolList.RegisterParser(TAntParser);
  ExternalToolList.RegisterParser(TGradleParser);
  ExternalToolList.RegisterParser(TAdbShellPidOfParser);
  ExternalToolList.RegisterParser(TAdbPullParser);
  ExternalToolList.RegisterParser(TAdbShellListParser);
  ExternalToolList.RegisterParser(TAdbShellPsParser);
end;


end.
