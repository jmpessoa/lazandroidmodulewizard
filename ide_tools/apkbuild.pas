unit ApkBuild;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef Windows}Windows,{$endif}
  Classes, SysUtils, ProjectIntf;

type

  { TApkBuilder }

  TApkBuilder = class
  private
    FProj: TLazProject;
    FSdkPath, FAntPath, FJdkPath: string;
    FProjPath: string;
    FDevice: string;
    procedure BringToFrontEmulator;
    function CheckAvailableDevices: Boolean;
    procedure LoadPaths;
    function RunAndGetOutput(const cmd, params: string; Aout: TStrings): Integer;
  public
    constructor Create(AProj: TLazProject);
    function BuildAPK(Install: Boolean = False): Boolean;
    function InstallAPK: Boolean;
    procedure RunAPK;
  end;

implementation

uses IDEExternToolIntf, LazIDEIntf, LazFileUtils, UTF8Process, Controls,
  EditBtn, Forms, StdCtrls, ButtonPanel, uFormStartEmulator, IniFiles, process,
  laz2_XMLRead, Laz2_DOM;

function QueryPath(APrompt: string; out Path: string;
  ACaption: string = 'Android Wizard: Path Missing!'): Boolean;
var
  f: TForm;
  l: TLabel;
  de: TDirectoryEdit;
begin
  Result := False;
  f := TForm.Create(nil);
  with f do
  try
    Caption := ACaption;
    Position := poScreenCenter;
    AutoSize := True;
    Constraints.MinWidth := 440;
    BorderStyle := bsSingle;
    BorderIcons := [biSystemMenu];
    l := TLabel.Create(f);
    with l do
    begin
      Parent := f;
      Caption := APrompt;
      AnchorSideLeft.Control := f;
      AnchorSideTop.Control := f;
      BorderSpacing.Around := 8;
    end;
    de := TDirectoryEdit.Create(f);
    with de do
    begin
      Parent := f;
      if Pos(':', APrompt) > 0 then
        DialogTitle := Copy(APrompt, 1, Pos(':', APrompt) - 1)
      else
        DialogTitle := APrompt;
      AnchorSideLeft.Control := f;
      AnchorSideTop.Control := l;
      AnchorSideTop.Side := asrBottom;
      AnchorSideRight.Control := f;
      AnchorSideRight.Side := asrRight;
      Anchors := [akTop, akLeft, akRight];
      BorderSpacing.Around := 8;
    end;
    with TButtonPanel.Create(f) do
    begin
      Parent := f;
      ShowButtons := [pbOK, pbCancel];
      AnchorSideTop.Control := de;
      AnchorSideTop.Side := asrBottom;
      Anchors := [akTop, akLeft, akRight];
      ShowBevel := False;
    end;
    if ShowModal = mrOK then
    begin
      Path := de.Directory;
      Result := True;
    end;
  finally
    Free;
  end;
end;

{ TApkBuilder }

procedure TApkBuilder.LoadPaths;
begin
  with TIniFile.Create(AppendPathDelim(LazarusIDE.GetPrimaryConfigPath)
    + 'late.ini') do
  try
    FSdkPath := ReadString('PATH', 'SDK', '');
    FAntPath := ReadString('PATH', 'Ant', '');
    FJdkPath := ReadString('PATH', 'JDK', '');
  finally
    Free;
  end;
  with TIniFile.Create(AppendPathDelim(LazarusIDE.GetPrimaryConfigPath)
    + 'JNIAndroidProject.ini') do
  try
    if FSdkPath = '' then
      FSdkPath := ReadString('NewProject', 'PathToAndroidSDK', '');
    if FAntPath = '' then
      FAntPath := ReadString('NewProject', 'PathToAntBin', '');
    if FJdkPath = '' then
      FJdkPath := ReadString('NewProject', 'PathToJavaJDK', '');
  finally
    Free
  end;
  if FAntPath = '' then
    if not QueryPath('Path to Ant bin: [ex. C:\adt32\Ant\bin]', FAntPath) then
      Exit;
  if FSdkPath = '' then
    if not QueryPath('Path to Android SDK: [ex. C:\adt32\sdk]', FSdkPath) then
      Exit;
  if FJdkPath = '' then
    if not QueryPath('Path to Java JDK: [ex. C:\Program Files (x86)\Java\jdk1.7.0_21]', FJdkPath) then
      Exit;
end;

function TApkBuilder.RunAndGetOutput(const cmd, params: string;
  Aout: TStrings): Integer;
var
  i: Integer;
  ms: TMemoryStream;
begin
  with TProcessUTF8.Create(nil) do
  try
    Options := [poUsePipes, poStderrToOutPut];
    Executable := cmd;
    Parameters.Text := params;
    ShowWindow := swoHIDE;
    Execute;
    Sleep(100);
    ms := TMemoryStream.Create;
    try
      repeat
        i := Output.NumBytesAvailable;
        while i > 0 do
        begin
          if i > 0 then
            ms.CopyFrom(Output, i);
          i := Output.NumBytesAvailable;
        end;
      until not Running;
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

procedure TApkBuilder.BringToFrontEmulator;
var
  emul_win: TStringList;
  i: Integer;
  str: string;
begin
  if Pos('emulator-', FDevice) <> 1 then Exit;
  emul_win := TStringList.Create;
  try
    {$ifdef Windows}
    EnumWindows(@FindEmulatorWindows, LPARAM(emul_win));
    {$endif}
    str := FDevice;
    Delete(str, 1, Pos('-', str));
    i := 1;
    while (i <= Length(str)) and (str[i] in ['0'..'9']) do Inc(i);
    str := Copy(str, 1, i - 1) + ':';
    for i := 0 to emul_win.Count - 1 do
      if Pos(str, emul_win[i]) = 1 then
      begin
        {$ifdef Windows}
        SetForegroundWindow(HWND(emul_win.Objects[i]));
        {$endif}
        Break;
      end;
  finally
    emul_win.Free;
  end;
end;

function TApkBuilder.CheckAvailableDevices: Boolean;
var
  sl, devs: TStringList;
  i: Integer;
  dev: Boolean;
  str: string;
begin
  sl := TStringList.Create;
  devs := TStringList.Create;
  try
    repeat
      sl.Clear;
      RunAndGetOutput(AppendPathDelim(FSdkPath) + 'platform-tools'
        + PathDelim + 'adb', 'devices', sl);
      dev := False;
      for i := 0 to sl.Count - 1 do
        if dev then
        begin
          str := Trim(sl[i]);
          if str <> '' then devs.Add(str);
        end else
        if Pos('List ', sl[i]) = 1 then
          dev := True;
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

constructor TApkBuilder.Create(AProj: TLazProject);
begin
  FProj := AProj;
  FProjPath := ExtractFilePath(ChompPathDelim(ExtractFilePath(FProj.MainFile.Filename)));
  LoadPaths;
end;

function TApkBuilder.BuildAPK(Install: Boolean): Boolean;
var
  Tool: TIDEExternalToolOptions;
begin
  Result := False;
  if Install then
    if not CheckAvailableDevices then Exit;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Building APK... ';
    Tool.EnvironmentOverrides.Add('JAVA_HOME=' + FJdkPath);
    Tool.WorkingDirectory := FProjPath;
    Tool.Executable := AppendPathDelim(FAntPath) + 'ant'{$ifdef windows}+'.bat'{$endif};
    Tool.CmdLineParams := '-Dtouchtest.enabled=true debug';
    if Install then
      Tool.CmdLineParams :=  Tool.CmdLineParams + ' install';
    Tool.Scanners.Add(SubToolDefault);
    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot build APK!');
    Result := True;
  finally
    Tool.Free;
  end;
end;

function TApkBuilder.InstallAPK: Boolean;
var
  Tool: TIDEExternalToolOptions;
begin
  Result := False;
  if not CheckAvailableDevices then Exit;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Installing APK... ';
    Tool.EnvironmentOverrides.Add('JAVA_HOME=' + FJdkPath);
    Tool.WorkingDirectory := FProjPath;
    Tool.Executable := AppendPathDelim(FAntPath) + 'ant'{$ifdef windows}+'.bat'{$endif};
    Tool.CmdLineParams := 'installd';
    Tool.Scanners.Add(SubToolDefault);
    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot install APK!');
    Result := True;
  finally
    Tool.Free;
  end;
end;

procedure TApkBuilder.RunAPK;
var
  xml: TXMLDocument;
  f, proj: string;
  n: TDOMNode;
  Tool: TIDEExternalToolOptions;
begin
  f := FProjPath + PathDelim + 'AndroidManifest.xml';
  ReadXMLFile(xml, f);
  try
    n := xml.ChildNodes[0].Attributes.GetNamedItem('package');
    if n is TDOMAttr then
      proj := UTF8Encode(TDOMAttr(n).Value)
    else
      raise Exception.Create('Cannot determine package name!');
  finally
    xml.Free;
  end;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Starting APK... ';
    Tool.ResolveMacros := True;
    Tool.Executable := AppendPathDelim(FSdkPath) + 'platform-tools' + PathDelim + 'adb$(ExeExt)';
    Tool.CmdLineParams := 'shell am start -n ' + proj + '/.App';
    Tool.Scanners.Add(SubToolDefault);
    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot run APK!');
    BringToFrontEmulator;
  finally
    Tool.Free;
  end;
end;

end.

