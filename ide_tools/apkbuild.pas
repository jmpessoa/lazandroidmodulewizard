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
    FSaveDevice: TStringList;
    FProj: TLazProject;
    FSdkPath, FJdkPath, FNdkPath: string;
    FAntPath, FGradlePath: string;
    FProjPath: string;
    FDevice: string;
    FGdbCop: Boolean;
    FApkRun: Boolean;
    FPackageName: String;
    FAdbShellOneLine: String;
    FScanPID: Array[0..1] of Cardinal;
    FScanName: Array[0..1] of String;

    {$ifdef Emulator}
    procedure BringToFrontEmulator;
    {$endif}
    procedure CleanUp;
    procedure LoadPaths;
    procedure RunByAdb;
    procedure RunByGradle;
    procedure DoBeforeBuildApk;
    procedure DoAfterRunApk;
    procedure StartNewGdbServer(Proj, Port : String);

    function GetAdbPath: String;
    function CheckAvailableDevices: Boolean;
    function RunCommandAdb(deviceNumber: String): Boolean;
    function GetManifestSdkTarget(out SdkTarget: string): Boolean;
    function RunAndGetOutput(const cmd, params: string; Aout: TStrings): Integer;
    function GetModel(numberDevice: String): String;

    function GetManufacturer(manufacturerDevice: String): String;
    function TryFixPaths: TModalResult;
    function FixBuildSystemConfig(ForceFixPaths: Boolean): TModalResult;
    function FixAntConfig(ForceFixPaths: Boolean): TModalResult;
    function BuildByAnt: Boolean;
    function InstallByAnt: Boolean;
    function BuildByGradle: Boolean;

    function  GetTargetCpuAbiList: Boolean;
    function  GetTargetBuildVersionSdk(var VerSdk: Integer) : Boolean;
    function  GetPackageName: String;
    function  GetAdbExecutable: String;
    function  GetGdbSolibSearchPath: String;
    function  GetLibCtrlsFileName(var Name: String): Boolean;
    function  DoAdbCommand(Title: String;Command: String; Parser: String): Boolean;

    function  CheckAdbCommand(ChkCmd: String): Boolean;
    function  Call_PID_scan_pidof(Proj: String): Boolean;
    function  Call_PID_scan_ps(Proj: String; Server: String; NewPS: Boolean): Boolean;
    function  AdbPull(PullName, DestPath: String): Boolean;
    function  PullAppsProc(PullNames: Array of String; DestPath: String): Boolean;
    function  CopyLibCtrls(DestPath: String): Boolean;
    function  CopyGdbServerToLibsDir: Boolean;
    function  SetHostAppFileName(AppName: String): Boolean;
    function  SetAdbForward(SrvName: String; SrvPort: String): Boolean;
    function  KillLastGdbServer(Proj: String): Boolean;
  public
    constructor Create(AProj: TLazProject);
    function BuildAPK: Boolean;
    procedure RunAPK;
    property  AdbExecutable: String read GetAdbExecutable;
    property  PackageName: String read GetPackageName;
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
    FFailureGot: Boolean;
  public
    procedure InitReading; override;
    procedure ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean); override;
    class function DefaultSubTool: string; override;
  end;

function IsAllCharNumber(pcString: PChar): Boolean;
begin
  Result := False;
  if StrLen(pcString)=0 then exit;
  while pcString^ <> #0 do // 0 indicates the end of a PChar string
  begin
    if not (pcString^ in ['0'..'9']) then Exit;
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
  collectSdkPlatforms:= False;
  if Pos('platforms'+PathDelim+'android-',PathMask) > 0 then collectSdkPlatforms:= True;

  Result := TStringList.Create;
  if FindFirst(PathMask, faDirectory, dir) = 0 then
    repeat
      if dir.Name[1] <> '.' then
      begin
          if collectSdkPlatforms then
          begin
            p:= Pos('-', dir.Name);
            if p > 0 then
            begin
              api:= Copy(dir.Name, p+1, MaxInt);
              if IsAllCharNumber(PChar(api))  then
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
       Result:= mrNo;
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

function TApkBuilder.GetAdbPath: String;
begin
  Result := IncludeTrailingPathDelimiter(FSdkPath) + 'platform-tools'
      + PathDelim + 'adb';
end;

function TApkBuilder.RunAndGetOutput(const cmd, params: string;
  Aout: TStrings): Integer;
var
  i: Integer;
  adb: TProcessUTF8;
  devicesString: TStringList;
begin
  adb := TProcessUTF8.Create(nil);
  try
    adb.Options := [poUsePipes, poStderrToOutPut, poWaitOnExit];
    adb.Executable := cmd;
    adb.Parameters.Text := params;
    adb.ShowWindow := swoHIDE;
    adb.Execute;

    Aout.LoadFromStream(adb.Output);
    Aout.Delete(Aout.Count-1);

    i := 0;
    while (i < Aout.Count) do
    begin
      if Aout[i].Contains('*') or Aout[i].Contains('List') then
      begin
        Aout.Delete(i);
        Continue;
      end;
      i := i + 1;
    end;

    for i:=0 to Aout.Count-1 do
    begin
      Aout[i] := StringReplace(Aout[i], 'device', '', [rfReplaceAll]);
      Aout[i] := Trim(Aout[i]);
    end;

  finally
    adb.Free;
  end;
end;

function TApkBuilder.GetManufacturer(manufacturerDevice: String): String;
var
  adb: TProcessUTF8;
  manufacturer: TStringList;
begin
  adb := TProcessUTF8.Create(nil);
  try
    adb.Options := [poUsePipes, poStderrToOutPut, poWaitOnExit];
    adb.Executable := GetAdbPath;
    adb.Parameters.Add('-s');
    adb.Parameters.Add(manufacturerDevice);
    adb.Parameters.Add('shell');
    adb.Parameters.Add('getprop');
    adb.Parameters.Add('ro.product.manufacturer');
    adb.ShowWindow := swoHIDE;
    adb.Execute;

    manufacturer := TStringList.Create;
    manufacturer.LoadFromStream(adb.Output);
    Result := manufacturer[0];
  finally
    adb.Free;
    manufacturer.Free;
  end;
end;

function TApkBuilder.GetModel(numberDevice: String): String;
var
  adb: TProcessUTF8;
  model: TStringList;
begin
  adb := TProcessUTF8.Create(nil);
  try
    adb.Options := [poUsePipes, poStderrToOutPut, poWaitOnExit];
    adb.Executable := GetAdbPath;
    adb.Parameters.Add('-s');
    adb.Parameters.Add(numberDevice);
    adb.Parameters.Add('shell');
    adb.Parameters.Add('getprop');
    adb.Parameters.Add('ro.product.model');
    adb.ShowWindow := swoHIDE;
    adb.Execute;

    model := TStringList.Create;
    model.LoadFromStream(adb.Output);
    Result := model[0];
  finally
    adb.Free;
    model.Free;
  end;
end;

function TApkBuilder.RunCommandAdb(deviceNumber: String): Boolean;
var
  s, smallProjectName, auxPath, apkPath: String;
  p: integer;
  instructionChip: String;
begin
  auxPath:= Copy(FProjPath, 1, Length(FProjPath)-1);
  p:= LastDelimiter(PathDelim,auxPath);
  smallProjectName:= Copy(auxPath, p+1 , MaxInt);

  instructionChip:= ExtractFileDir(LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename);
  instructionChip:= ExtractFileName(instructionChip);  //armeabi-v7a

  apkPath := FProjPath + 'build'+ PathDelim + 'outputs' + PathDelim + 'apk'
  + PathDelim + 'debug' + PathDelim + smallProjectName + '-' + instructionChip + '-debug.apk';

  RunCommand(GetAdbPath, ['-s', deviceNumber, 'uninstall', GetPackageName],
  s, [poUsePipes, poNoConsole]);

  if RunCommand(GetAdbPath, ['-s', deviceNumber, 'install', apkPath],
  s, [poUsePipes, poNoConsole]) then
  begin
    RunCommand(GetAdbPath, ['-s', deviceNumber, 'shell', 'monkey', '-p',
    GetPackageName, '-c', 'android.intent.category.LAUNCHER', '1'], s,
    [poUsePipes, poNoConsole]);
  end;

end;

function TApkBuilder.CheckAvailableDevices: Boolean;
var
  devices: TStringList;
  deviceNumber: String;
  i, index: Integer;
  choiceDevice: TTaskDialog;
begin
  devices := TStringList.Create;
  try
    RunAndGetOutput(GetAdbPath, 'devices', devices);

    if devices.Count > 1 then
    begin
      choiceDevice := TTaskDialog.Create(nil);
      FSaveDevice := TStringList.Create;

      choiceDevice.Caption := 'LAMW';
      choiceDevice.Title := 'Which smartphone do you want to install on?';
      try
        for i:=0 to devices.Count -1 do
        begin
          FSaveDevice.AddPair(i.ToString, devices[i]);
          choiceDevice.RadioButtons.Add.Caption := format('%s - %s', [GetManufacturer(devices[i]) ,GetModel(devices[i])]);
        end;

        FSaveDevice.AddPair((i+1).ToString, 'emulator');
        choiceDevice.RadioButtons.Add.Caption := 'Emulator';

        FSaveDevice.AddPair((i+1).ToString, 'all');
        choiceDevice.RadioButtons.Add.Caption := 'All Devices';

        choiceDevice.ModalResult := mrOk;
        while choiceDevice.ModalResult <> mrCancel do
        begin
          if choiceDevice.Execute then
          begin
            if choiceDevice.ModalResult = mrOK then
            begin
              index := choiceDevice.RadioButton.Index;
              deviceNumber := FSaveDevice.ValueFromIndex[index];

              if deviceNumber = 'all' then
              begin
                for i:=0 to devices.Count-1 do
                begin
                  if FSaveDevice.ValueFromIndex[i] = 'emulator' then
                  begin
                    Continue;
                  end;
                  RunCommandAdb(FSaveDevice.ValueFromIndex[i]);
                end;
              end;

              if deviceNumber = 'emulator' then
              begin
                with TfrmStartEmulator.Create(FSdkPath, @RunAndGetOutput) do
                try
                  if ShowModal = mrCancel then
                  begin
                  end;
                finally
                  Free;
                end
              end else
              begin
                RunCommandAdb(deviceNumber);
              end;
            end;

            if choiceDevice.ModalResult = mrCancel then
            begin
              Result := True;
              Exit;
            end;
          end;
        end;
      finally
        FSaveDevice.Free;
        choiceDevice.Free;
      end;
    end;
    Result := False;
  finally
    devices.Free;
  end;
end;


procedure TApkBuilder.RunByGradle;
var
  Tool: TIDEExternalToolOptions;
begin
  if CheckAvailableDevices then
  begin
    FApkRun := True;
    Exit;
  end;

  FApkRun := False;
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
    {$IF LCL_FULLVERSION >= 2010000}
    Tool.Parsers.Add(SubToolGradle);
    {$ELSE}
    Tool.Scanners.Add(SubToolGradle);
    {$ENDIF}

    If Not RunExternalTool(Tool) then raise Exception.Create('Cannot run APK!');
    FApkRun := True;
  finally
    Tool.Free;
    //total clean up!
    CleanUp;
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
  DoBeforeBuildApk;
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
  begin
    RunByGradle
  end else
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
    Tool.Executable := IncludeTrailingPathDelimiter(FSdkPath) + 'platform-tools' + PathDelim + 'adb$(ExeExt)';
    Tool.CmdLineParams := 'shell am start -n ' + proj + '/.App';
    {$IF LCL_FULLVERSION >= 2010000}
    Tool.Parsers.Add(SubToolDefault);
    {$ELSE}
    Tool.Scanners.Add(SubToolDefault);
    {$ENDIF}

    If Not RunExternalTool(Tool) then raise Exception.Create('Cannot run APK!');
    FApkRun := True;
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
    {$IF LCL_FULLVERSION >= 2010000}
    Tool.Parsers.Add(SubToolGradle);
    {$ELSE}
    Tool.Scanners.Add(SubToolGradle);
    {$ENDIF}

    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot build APK!');
    Result := True;
  finally
    Tool.Free;
  end;
end;

  { Local constants, types, classes & vars for gdb debugger from Lazarus IDE }
const
  SubToolPidOf      = 'AdbPidOf';
  SubToolPs         = 'AdbPs';
  SubToolPull       = 'AdbPull';
  SubToolList       = 'AdbList';
  GdbDirLAMW        = 'gdb';
  JniDirLAMW        = 'jni';

type  TBigBuildMode = (bmNo,    bmArmV6Soft,   bmArmV7Soft,   bmX86);

const bmLibsSubDir  : Array[TBigBuildMode] of String =
                      ('No',   'armeabi',     'armeabi-v7a', 'x86');

const bmGdbSrvMask  : Array[TBigBuildMode] of String =
                      ('No',   'android-arm', 'android-arm', 'android-x86');

var CurBigBuildMode : TBigBuildMode = bmNo;
    abApkBuilder    : TApkBuilder   =  Nil;

  { TAdbShellPidOfParser }

type
  TAdbShellPidOfParser = class(TExtToolParser)
  public
    procedure ReadPID (ALine   : String;
                       AmsgLine: TMessageLine;
                       Idx     : Integer);
    procedure ReadLine(Line: String; OutputIndex: integer;
        {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
        var Handled: Boolean);                                         override;
      class function DefaultSubTool: String;                           override;
  end;

  TAdbShellPsParser = class(TAdbShellPidOfParser)
  public
    procedure ReadLine(Line: String; OutputIndex: integer;
        {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
        var Handled: Boolean);                                         override;
      class function DefaultSubTool: String;                           override;
  end;

  { TAdbPullParser }
  TAdbPullParser= class(TExtToolParser)
  public
    procedure ReadLine(Line: string; OutputIndex: integer;
        {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
        var Handled: Boolean);                                         override;
      class function DefaultSubTool: String;                           override;
  end;

  { TAdbShellListParser }

  TAdbShellListParser = class(TExtToolParser)
  public
    procedure ReadLine(Line: String; OutputIndex: integer;
        {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
        var Handled: Boolean);                                         override;
      class function DefaultSubTool: String;                           override;
  end;


{ TAdbShellPidOfParser }

procedure  TAdbShellPidOfParser.ReadPID (ALine   : String;
                                         AmsgLine: TMessageLine;
                                         Idx     : Integer);
var          PID, Code:Integer;
begin
  Val(ALine, PID, Code);
  If (Code <> 0) or (PID < 1) then
    begin
      AmsgLine.Urgency  := mluError;
      Tool.ErrorMessage := AmsgLine.Msg;
      If Assigned(abApkBuilder) then abApkBuilder.FScanPID[Idx] :=   0;
    end                       else
    begin
      AmsgLine.Urgency  := mluProgress;
      If Assigned(abApkBuilder) then abApkBuilder.FScanPID[Idx] := PID;
    end;
end;

procedure  TAdbShellPidOfParser.ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean);
var
  msgLine: TMessageLine;
begin
  msgLine     := CreateMsgLine(OutputIndex);
  msgLine.Msg := Line;
  If Line <> '' then ReadPID(Line, msgLine, 0);
  AddMsgLine(msgLine);
  Handled     := True;
end;

class function TAdbShellPidOfParser.DefaultSubTool: string;
begin
  Result := SubToolPidOf;
end;


{ TAdbShellPsParser }

procedure  TAdbShellPsParser.ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean);
var
  msgLine:TMessageLine; I,J,K:Integer; SList:TStringList;
begin
  msgLine          := CreateMsgLine(OutputIndex);
  msgLine.Msg      := Line;
  msgLine.Urgency  := mluProgress;
  If Assigned(abApkBuilder) then
    For J:=0 to 1 do
      If (Pos(abApkBuilder.FScanName[J], Line) <> 0) then
        begin
          try
            SList                 := TStringList.Create;
            SList.Delimiter       := ' ';
            SList.StrictDelimiter := True;
            SList.DelimitedText   := Line;
                      K           := 0;
            For I:=0 to   SList.Count-1 do
              If          SList.Strings[I] <> '' then
                begin
                  If  K=1 then         //  <> '' SubSting[1] in Line = PID
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
  Handled     := True;
end;

class function TAdbShellPsParser.DefaultSubTool: string;
begin
  Result := SubToolPs;
end;


{ TAdbPullParser }

procedure  TAdbPullParser.ReadLine(Line: string; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: boolean);
var
  msgLine:TMessageLine;
begin
  msgLine         := CreateMsgLine(OutputIndex);
  msgLine.Msg     := Line;
  msgLine.Urgency := mluProgress;
  AddMsgLine(msgLine);
  Handled         := True;
end;

class function TAdbPullParser.DefaultSubTool: string;
begin
  Result := SubToolPull;
end;


{ TAdbShellListParser }

procedure TAdbShellListParser.ReadLine(Line: String; OutputIndex: integer;
      {$if lcl_fullversion >= 2010000}IsStdErr: boolean;{$endif}
      var Handled: Boolean);
var
  msgLine         : TMessageLine;
begin
  msgLine         := CreateMsgLine(OutputIndex);
  msgLine.Msg     := Line;
  msgLine.Urgency := mluProgress;
  AddMsgLine(msgLine);
  Handled         := True;
  If (Line<>'') and Assigned(abApkBuilder) then
                             abApkBuilder.FAdbShellOneLine:= Line;
end;

class function TAdbShellListParser.DefaultSubTool: String;
begin
  Result := SubToolList;
end;


{ TApkBuilder (functions for gdb debugger from Lazarus IDE)}

function   TApkBuilder.GetPackageName        : String;
var                    xml:TXMLDocument;
begin
  If FPackageName <> '' then begin Result := FPackageName; Exit; end
                        else       Result := '';
  try
       ReadXMLFile    (xml, FProjPath + PathDelim + 'AndroidManifest.xml');

       FPackageName := xml.DocumentElement.AttribStrings['package'];
    If FPackageName = '' then
      raise Exception.Create('Cannot determine package name!')
                         else      Result := FPackageName;
  finally
                       xml.Free;
  end;
end;

function   TApkBuilder.GetAdbExecutable : String;
begin
  Result:= IncludeTrailingPathDelimiter(FSdkPath)+'platform-tools'+PathDelim+
                                                                 'adb$(ExeExt)';
end;

function  TApkBuilder.DoAdbCommand(Title   : String;
                                   Command : String;
                                   Parser  : String) : Boolean;
var Tool :  TIDEExternalToolOptions;
begin
    Tool := TIDEExternalToolOptions.Create;
    Result             :=  False;
  try
    Tool.Title         :=  Title;
    Tool.ResolveMacros :=  True;
    Tool.Executable    :=  AdbExecutable;
    Tool.CmdLineParams :=  Command;
    {$IF LCL_FULLVERSION >= 2010000}
    Tool.{%H-}Parsers.Add(Parser);
    {$ELSE}
    Tool.{%H-}Scanners.Add(Parser);
    {$ENDIF}

    Result             := RunExternalTool(Tool);
  finally
    Tool.Free;
  end;
end;

function   TApkBuilder.CheckAdbCommand(ChkCmd : String) : Boolean;
begin
         Result    := DoAdbCommand   ('Check '    + ChkCmd,
                                      'shell ls ' + ChkCmd, SubToolList   ) and
                                     (              FAdbShellOneLine <> '');
  If Not Result then raise
                     Exception.Create('Cannot check ' + ChkCmd + ' command')
                else
         Result    :=                (Pos(ChkCmd,   FAdbShellOneLine) <> 0) and
                                     (Pos('No such',FAdbShellOneLine) =  0);
end;

function   TApkBuilder.Call_PID_scan_pidof
                                     (Proj    : String):Boolean;
begin
         Result   := DoAdbCommand    ('Scan '        + Proj + ' PID...',
                                      'shell pidof ' + Proj, SubToolPidOf) and
                                     (FScanPID[0] <> 0);
  If Not Result then raise
                     Exception.Create('Cannot scan ' + Proj + ' PID!  ');
end;

function  TApkBuilder.Call_PID_scan_ps
                                     (Proj    : String;
                                      Server  : String;
                                      NewPS   : Boolean) : Boolean;
var             Param:String;
begin
  If NewPS then Param:=' -A' else Param:='';

  FScanName[0] := Proj; FScanName[1] := Server;
  FScanPID [0] := 0;    FScanPID [1] := 0;

         Result   := DoAdbCommand    ('Scan '        + Proj + ' PID...',
                                      'shell ps'+Param,         SubToolPs) and
                                     (FScanPID[0] <> 0);
  If Not Result then raise
                     Exception.Create('Cannot scan ' + Proj + ' PID!  ')
end;

function  TApkBuilder.KillLastGdbServer(Proj  : String) : Boolean;
begin
  If 0<FScanPID[1] then
         Result := DoAdbCommand
                ('Kill last gdbserver',
                 'shell run-as ' + Proj + ' kill -9 '+IntTostr(FScanPID[1]),
                                                                SubToolDefault)
                   else
         Result := True;

  If Not Result then raise
        Exception.Create('Cannot kill last gdbserver PID='+IntTostr(FScanPID[1]));
end;

procedure TApkBuilder.StartNewGdbServer(Proj, Port:String);
var      Run : Boolean;
begin
  If GdbCfg.GdbServerRun = gsrRunAsPackageName then
    begin
         Run := DoAdbCommand
                ('Start(run-as '     + Proj + ' lib/gdbserver --multi :' + Port +')',
                 'shell run-as '     + Proj + ' lib/gdbserver --multi :' + Port,
                                                                SubToolDefault);
      If Run then else raise Exception.Create
         ('Cannot start(run-as '     + Proj + ' lib/gdbserver --multi :' + Port +')');
    end                                 else
    begin
         Run := DoAdbCommand
                ('Start(/data/data/' + Proj + '/lib/gdbserver --multi :' + Port +')',
                 'shell /data/data/' + Proj + '/lib/gdbserver --multi :' + Port,
                                                                SubToolDefault);
      If Run then else raise Exception.Create
         ('Cannot start(/data/data/' + Proj + '/lib/gdbserver --multi :' + Port +')');
    end;
end;

function  TApkBuilder.AdbPull(PullName,DestPath:String):Boolean;
begin
         Result   := DoAdbCommand   (' Pull '  + PullName + ' to ' + DestPath,
                                      'pull '  + PullName +  ' '   + DestPath,
                                      SubToolPull);
  If Not Result then raise
              Exception.Create('Cannot pull '  + PullName + ' to ' + DestPath);
end;

function TApkBuilder.GetTargetCpuAbiList : Boolean;
begin
  FAdbShellOneLine:='';

  Result   := DoAdbCommand   (' Get CPU Abilist',
                                     'shell getprop ro.product.cpu.abilist',
                                      SubToolList) and (FAdbShellOneLine<>'');
  If Not Result then raise
              Exception.Create('Cannot get CPU Abilist');
end;

function  TApkBuilder.GetTargetBuildVersionSdk(var VerSdk : Integer) : Boolean;
var             Code:Integer;
begin

  FAdbShellOneLine:='';

  Result   := DoAdbCommand    (' Get Build Version Sdk',
                                    'shell getprop ro.build.version.sdk',
                                     SubToolList) and (FAdbShellOneLine<>'');
  If    Result then
    begin
         Val(FAdbShellOneLine,      VerSdk, Code);
         Result:= (Code = 0)and(1 < VerSdk);
    end;
  If Not Result then raise
              Exception.Create('Cannot get Build Version Sdk');
end;

function TApkBuilder.GetGdbSolibSearchPath:String;
begin
     Result := FProjPath+GdbDirLAMW;
  If PathDelim <> '/' then
     Result := StringReplace(Result, PathDelim, '/', [rfReplaceAll]);
end;

function  TApkBuilder.GetLibCtrlsFileName (var Name : String):Boolean;
var              Project:TXMLDocument; Child:TDOMNode;
begin
        Result:=False;
  try
    ReadXMLFile (Project, FProjPath + JniDirLAMW + PathDelim + 'controls.lpi');
         Child:= Project.DocumentElement.FindNode('CompilerOptions');
    If Assigned(Child) then
      begin
        With Child.FindNode('Target').FindNode('Filename') do
          Name:=FProjPath + JniDirLAMW + PathDelim + Attributes.Item[0].NodeValue;
        Result:=Name<>'';
      end;
  finally
                 Project.Free;
  end;
end;

function TApkBuilder.PullAppsProc(PullNames: array of String; DestPath: String
  ): Boolean;
var   I:Integer;
begin
       Result := True;
  For I:=Low(PullNames) to High(PullNames) do
    If Result then Result:=AdbPull(PullNames[I], DestPath) else Exit;
end;

function  TApkBuilder.CopyLibCtrls(DestPath:String) : Boolean;
var LibCtrlsName:String;
begin
  LibCtrlsName := '';

  Result := GetLibCtrlsFileName(LibCtrlsName);

  If       Result then
    begin
           Result := FileExists(LibCtrlsName+'.so')  and
                       CopyFile(LibCtrlsName+'.so',
                           DestPath+ExtractFileName(LibCtrlsName)+'.so',
                             [cffOverwriteFile], False);
      If   Result then
        If           FileExists(LibCtrlsName+'.dbg') then
           Result :=   CopyFile(LibCtrlsName+'.dbg',
                           DestPath+ExtractFileName(LibCtrlsName)+'.dbg',
                             [cffOverwriteFile], False);
    end;
end;

function  GetBigBuildMode(LibCtrlsName:String):TBigBuildMode;
var I:TBigBuildMode;
begin

  For I:=Low(TBigBuildMode) to High(TBigBuildMode) do
    If Pos(bmLibsSubDir[I],LibCtrlsName)<>0 then begin Result:=I; Exit; end
                                            else       Result:=bmNo
end;

function  FindFileMaskName(Folder,Mask,Name:String; var FileName:String):Boolean;
var SrR:TSearchRec; DosError:Integer;
begin
          Result:=False;
        DosError:=SysUtils.FindFirst(Folder+PathDelim+'*.*', faAnyFile, SrR);
  While DosError=0 do
    begin
      If SrR.Attr and faDirectory <> 0 then
        If (SrR.Name<>'.') and (SrR.Name<>'..') then
          Result:=FindFileMaskName  (Folder+PathDelim+SrR.Name, Mask, Name, FileName)
                                                else
                                       else
              begin
                   Result:=(Pos(Mask,Folder)<>0)and(Name =SrR.Name);
                If Result then FileName:=Folder+PathDelim+SrR.Name;
              end;
       If Result then DosError:=10000
                 else DosError:=FindNext(SrR);
    end;
  SysUtils.FindClose(SrR);
end;

function  TApkBuilder.CopyGdbServerToLibsDir : Boolean;
var  I:TBigBuildMode;
     LibCtrlsName,GdbServer:String;
begin
  GdbServer    := '';
  LibCtrlsName := '';

  Result := GetLibCtrlsFileName(LibCtrlsName);

  If       Result then
     begin
                   I := GetBigBuildMode (LibCtrlsName);
           Result:=I<>bmNo;
       If  Result then
         begin
              Result := FindFileMaskName
                (ExtractFileDir (FNdkPath), bmGdbSrvMask[I], 'gdbserver', GdbServer);
           If Result then
              Result := CopyFile(GdbServer, ExtractFilePath(LibCtrlsName)+
                 ExtractFileName(GdbServer), [cffOverwriteFile], False);
           If Result then CurBigBuildMode:=I;
         end;
     end;
end;

function  TApkBuilder.SetHostAppFileName(AppName : String) : Boolean;
begin
  If             FProj.RunParameters.Count>0 then else
                 FProj.RunParameters.Add('default');
     Result :=   FProj.RunParameters.Count>0;
  If Result then FProj.RunParameters.Modes[0].HostApplicationFilename := AppName
            else MessageDlg(
                   'Could not setup Host Application Filename to "'+AppName+'"'+sLineBreak+
                    'Setup it in Run/Parametrs',
                    mtWarning, [mbYes, mbCancel], 0);
                                 // for android Gdb File command
end;

function  TApkBuilder.SetAdbForward(SrvName : String;
                                    SrvPort : String) : Boolean;
begin
       Result   := SrvName <> '';
  If   Result then else
    begin
       Result   := DoAdbCommand    ('Adb forward tcp:'+SrvPort+' tcp:'+SrvPort,
                                        'forward tcp:'+SrvPort+' tcp:'+SrvPort,
                                     SubToolDefault);
       If Not Result then raise
            Exception.Create('Cannot Adb forward tcp:'+SrvPort+' tcp:'+SrvPort);
    end;
end;

procedure TApkBuilder.DoBeforeBuildApk;
begin
     abApkBuilder         := Self;// For parsers
     FPackageName         := ''; // Reread from lpi file
     FGdbCop              :=
       (FProj.LazBuildModes.Count    > 0)                                      and
        FProj.LazBuildModes.BuildModes[0].LazCompilerOptions.GenerateDebugInfo and
                                 // Check IDE genegation debug info
                            CopyGdbServerToLibsDir;
                                 // Copy NDK gdbserver to Libs/ABI dir
                 FApkRun  := False;
                                 // Apk is not running
end;

procedure TApkBuilder.DoAfterRunApk;
var VerSdk : Integer;
begin
  VerSdk := 0;

  If FGdbCop and FApkRun then else Exit;
                                 // Check gdbserver in Apk & Apk is running
  If GetTargetCpuAbiList then else Exit;
                                 // adb shell getprop ro.product.cpu.abilist
  If Pos(bmLibsSubDir[CurBigBuildMode], FAdbShellOneLine) <> 0 then else
                                 // Check target ABI
    begin
      MessageDlg(
        'Current LAMW build chipset "'+bmLibsSubDir[CurBigBuildMode]+'"'+sLineBreak+
        'does not compatible with target ABI "'+FAdbShellOneLine+'"'    +sLineBreak+
        'Change it to "' + FAdbShellOneLine + '"',
        mtWarning, [mbYes, mbCancel], 0);  Exit;
    end;

     Sleep             (2000);   // Wait 2 seconds for starting program

  If GetTargetBuildVersionSdk                       (VerSdk) and
                                 // Get Build Version SDK
     Call_PID_scan_ps  (PackageName, 'gdbserver', 25<VerSdk) then
                                 // Scan PID of LAMW proj
    begin
      GdbCfg.ProjName   := PackageName;
      GdbCfg.ProjPID    := FScanPID[0];
                                 // For PIDs List in GDBMIServerDebuggerLAMW.pas

      If DirectoryExists(FProjPath+GdbDirLAMW) then else
                   MkDir(FProjPath+GdbDirLAMW);
                                 // Create Dir for GDB if it not Exists

      If PullAppsProc(['/system/bin/app_process32',
                       '/system/bin/linker',
                       '/system/lib/libc.so'], GetGdbSolibSearchPath) and
                                 // Pull app_process32 & linker & libc.so
                                 //   to GetGdbSolibSearchPath for 32 bits Target (!)
         CopyLibCtrls(FProjPath+
                      GdbDirLAMW   +PathDelim)                        and
                                 // Copy libcontrols.so & libcontrols.dbg
                                 //   to  GdbDirLAMW
         SetHostAppFileName(FProjPath+
                      GdbDirLAMW   +PathDelim +'app_process32')       and
                                 // Setup HostApplicationFilename=app_process32

         SetAdbForward(GdbCfg.GdbServerName, GdbCfg.GdbServerPort)    and
                                 // If GdbServerName='' then
                                 //   Adb forward tcp:+GdbServerPort+' tcp:'+GdbServerPort

         KillLastGdbServer(PackageName)
                                 // Kill last gdbserver
                                                                      then
         StartNewGdbServer(PackageName, GdbCfg.GdbServerPort);
                                 // Start gdbserver in mode --multi GdbServerPort
    end;
     abApkBuilder         := Nil;
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


