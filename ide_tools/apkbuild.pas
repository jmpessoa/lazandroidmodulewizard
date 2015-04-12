unit ApkBuild;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef Windows}Windows,{$endif}
  Classes, SysUtils, ProjectIntf, Forms;

type

  { TApkBuilder }

  TApkBuilder = class
  private
    FProj: TLazProject;
    FSdkPath, FAntPath, FJdkPath, FNdkPath: string;
    FProjPath: string;
    FDevice: string;
    procedure BringToFrontEmulator;
    function CheckAvailableDevices: Boolean;
    procedure LoadPaths;
    function RunAndGetOutput(const cmd, params: string; Aout: TStrings): Integer;
    function TryFixPaths: TModalResult;
  public
    constructor Create(AProj: TLazProject);
    function BuildAPK(Install: Boolean = False): Boolean;
    function InstallAPK: Boolean;
    procedure RunAPK;
  end;

implementation

uses IDEExternToolIntf, LazIDEIntf, LazFileUtils, UTF8Process, Controls,
  EditBtn, StdCtrls, ButtonPanel, Dialogs, uFormStartEmulator, IniFiles,
  process, laz2_XMLRead, Laz2_DOM, FileUtil, laz2_XMLWrite;

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
    FNdkPath := ReadString('PATH', 'NDK', '');
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
    if FNdkPath = '' then
      FNdkPath := ReadString('NewProject', 'PathToAndroidNDK', '');
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
  if FNdkPath = '' then
    if not QueryPath('Path to Android NDK: [ex. C:\adt32\ndk10]', FNdkPath) then
      Exit;
end;

function TApkBuilder.RunAndGetOutput(const cmd, params: string;
  Aout: TStrings): Integer;
var
  i: Integer;
  ms: TMemoryStream;
  buf: array [0..255] of Byte;
begin
  with TProcessUTF8.Create(nil) do
  try
    Options := [poUsePipes, poStderrToOutPut];
    Executable := cmd;
    Parameters.Text := params;
    ShowWindow := swoHIDE;
    Execute;
    ms := TMemoryStream.Create;
    try
      repeat
        i := Output.Read(buf, SizeOf(buf));
        if i > 0 then ms.Write(buf, i);
      until not Running and (i <= 0);
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

function TApkBuilder.TryFixPaths: TModalResult;

  function FixPath(var path: string; const truncBy, newPath: string): Boolean;
  var
    s, p: string;
    i: Integer;
    dir: TSearchRec;
  begin
    if Pos(PathDelim, path) = 0 then
      if PathDelim <> '/' then
        path := StringReplace(path, '/', PathDelim, [rfReplaceAll])
      else
        path := StringReplace(path, '\', PathDelim, [rfReplaceAll]);
    Delete(path, 1, Pos(PathDelim + truncBy, path));
    Delete(path, 1, Pos(PathDelim, path));
    path := AppendPathDelim(newPath) + path;
    Result := DirectoryExistsUTF8(path);
    if not Result then
    begin
      i := Pos('arm-linux-androideabi-', path);
      if i = 0 then Exit;
      p := path;
      Delete(p, 1, i + 21);
      p := Copy(p, 1, Pos(PathDelim, p) - 1);
      if p = '' then Exit;
      s := Copy(path, 1, i - 1);
      if FindFirstUTF8(s + 'arm-linux-androideabi-*', faDirectory, dir) = 0 then
      begin
        s := dir.Name;
        Delete(s, 1, 22);
        path := StringReplace(path, p, s, [rfReplaceAll]);
        Result := DirectoryExistsUTF8(path);
      end;
      FindCloseUTF8(dir);
    end;
  end;

var
  sl: TStringList;
  i: Integer;
  ForceFixPaths: Boolean;
  str, prev, pref: string;
  xml: TXMLDocument;
  n: TDOMNode;
begin
  Result := mrAbort;
  ForceFixPaths := False;
  if not DirectoryExistsUTF8(FNdkPath) then Exit;
  sl := TStringList.Create;
  try
    // Libraries
    sl.Delimiter := ';';
    sl.DelimitedText := FProj.LazCompilerOptions.Libraries;
    for i := 0 to sl.Count - 1 do
    begin
      if not DirectoryExistsUTF8(sl[i]) then
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
            else Exit;
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
        if not DirectoryExistsUTF8(str) then
        begin
          if not FixPath(str, 'ndk', FNdkPath) then Exit;
          if not ForceFixPaths then
          begin
            case MessageDlg('Path "' + prev + '" does not exist.' + sLineBreak +
                          'Change it to "' + str + '"?',
                          mtConfirmation, [mbYes, mbYesToAll, mbCancel], 0) of
              mrYesToAll: ForceFixPaths := True;
              mrYes:
              else Exit;
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

  // build.xml
  prev := FProjPath + 'build.xml';
  ReadXMLFile(xml, prev);
  try
    with xml.DocumentElement.ChildNodes do
      for i := 0 to Count - 1 do
        if Item[i].NodeName = 'property' then
        begin
          n := Item[i].Attributes.GetNamedItem('name');
          if Assigned(n) and (n.TextContent = 'sdk.dir') then
          begin
            n := Item[i].Attributes.GetNamedItem('location');
            if not assigned(n) then Continue;
            str := n.TextContent;
            if not DirectoryExistsUTF8(str) and DirectoryExistsUTF8(FSdkPath) then
            begin
              if not ForceFixPaths
              and (MessageDlg('build.xml',
                             'Path "' + str + '" does not exist.' + sLineBreak +
                             'Change it to "' + FSdkPath + '"?', mtConfirmation,
                             [mbYes, mbNo], 0) <> mrYes) then Exit;
              Item[i].Attributes.GetNamedItem('location').TextContent := FSdkPath;
              WriteXMLFile(xml, prev);
            end;
            Break;
          end;
        end;
  finally
    xml.Free;
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
  TryFixPaths;
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

