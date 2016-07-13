unit ApkBuild;

{ TODO:
    - implement TApkBuilder.BringToFrontEmulator for linux }

{$mode objfpc}{$H+}

interface

uses
  {$ifdef Windows}Windows,{$endif}
  Classes, SysUtils, ProjectIntf, Forms, LamwSettings;

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

procedure RegisterExtToolParser;

implementation

uses
  IDEExternToolIntf, UTF8Process, Controls, StdCtrls,
  ButtonPanel, Dialogs, uFormStartEmulator, process, strutils,
  laz2_XMLRead, Laz2_DOM, laz2_XMLWrite, LazFileUtils;

const
  SubToolAnt = 'ant';

type

  { TAntParser }

  TAntParser = class(TExtToolParser)
  public
    procedure ReadLine(Line: string; OutputIndex: integer; var Handled: boolean); override;
    class function DefaultSubTool: string; override;
  end;

{ TAntParser }

procedure TAntParser.ReadLine(Line: string; OutputIndex: integer;
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
  FAntPath := LamwGlobalSettings.PathToAntBin;
  FJdkPath := LamwGlobalSettings.PathToJavaJDK;
  FNdkPath := LamwGlobalSettings.PathToAndroidNDK;
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

function TApkBuilder.TryFixPaths: TModalResult;

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

  function CollectDirs(const PathMask: string): TStringList;
  var
    dir: TSearchRec;
  begin
    Result := TStringList.Create;
    if FindFirst(PathMask, faDirectory, dir) = 0 then
      repeat
        Result.Add(dir.Name);
      until (FindNext(dir) <> 0);
    FindClose(dir);
  end;

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

  procedure FixPrebuiltSys(var path: string);
  var
    i: Integer;
    p, s: string;
    dir: TSearchRec;
  begin
    if DirectoryExists(path) then Exit;
    i := Pos(PathDelim + 'prebuilt' + PathDelim, path);
    if i = 0 then Exit;
    p := path;
    Delete(p, 1, i + 9);
    p := Copy(p, 1, Pos(PathDelim, p) - 1);
    if p = '' then Exit;
    s := Copy(path, 1, i + 9);
    if FindFirst(s + '*', faDirectory, dir) = 0 then
    begin
      s := dir.Name;
      path := StringReplace(path, p, s, [rfReplaceAll]);
    end;
    FindClose(dir);
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
  begin
    if Pos(PathDelim, path) = 0 then
      if PathDelim <> '/' then
        {%H-}path := StringReplace(path, '/', PathDelim, [rfReplaceAll])
      else
        {%H-}path := StringReplace(path, '\', PathDelim, [rfReplaceAll]);
    Delete(path, 1, PosIdent(truncBy, path));
    Delete(path, 1, Pos(PathDelim, path));
    path := IncludeTrailingPathDelimiter(newPath) + path;
    FixArmLinuxAndroidEabiVersion(path);
    FixPrebuiltSys(path);
    Result := DirectoryExists(path);
  end;

  function GetManifestSdkTarget(out SdkTarget: string): Boolean;
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
        if not Assigned(n) then Exit;
        n := n.Attributes.GetNamedItem('android:targetSdkVersion');
        if not Assigned(n) then Exit;
        SdkTarget := n.TextContent;
        Result := True;
      finally
        ManifestXML.Free
      end;
    except
      Exit;
    end;
  end;

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
        if not Assigned(n) then Exit;
        n := n.Attributes.GetNamedItem('android:targetSdkVersion');
        if not Assigned(n) then Exit;
        n.TextContent := SdkTarget;
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
  sl: TStringList;
  i: Integer;
  ForceFixPaths: Boolean;
  str, prev, pref: string;
  xml: TXMLDocument;
  n: TDOMNode;
begin
  Result := mrAbort;
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
          if Assigned(n) then
          begin
            if n.TextContent = 'sdk.dir' then
            begin
              n := Item[i].Attributes.GetNamedItem('location');
              if not Assigned(n) then Continue;
              str := n.TextContent;
              if not DirectoryExists(str) and DirectoryExists(FSdkPath) then
              begin
                if not ForceFixPaths
                and (MessageDlg('build.xml',
                               'Path "' + str + '" does not exist.' + sLineBreak +
                               'Change it to "' + FSdkPath + '"?', mtConfirmation,
                               [mbYes, mbNo], 0) <> mrYes) then Exit;
                Item[i].Attributes.GetNamedItem('location').TextContent := FSdkPath;
                WriteXMLFile(xml, prev);
              end;
            end else
            if n.TextContent = 'target' then
            begin
              // fix "target" according to AndroidManifest
              n := Item[i].Attributes.GetNamedItem('value');
              if not Assigned(n) then Continue;
              if not GetManifestSdkTarget(str) then
                str := n.TextContent
              else
                str := 'android-' + str;
              sl := CollectDirs(AppendPathDelim(FSdkPath) + 'platforms' + PathDelim + 'android-*');
              try
                if sl.Count = 0 then Continue;
                sl.Sorted := True;
                if (sl.IndexOf(n.TextContent) < 0) and (sl.IndexOf(str) >= 0) then
                begin
                  if MessageDlg('build.xml',
                                'Change target to "' + str + '"?',
                                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Continue;
                  n.TextContent := str;
                  WriteXMLFile(xml, prev);
                end else
                if (sl.IndexOf(n.TextContent) >= 0) and (n.TextContent <> str) then
                begin
                  if MessageDlg('Manifest.xml',
                                'SDK for "' + str + '" is not installed. Do you ' +
                                'want to use "' + n.TextContent + '"?',
                                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Continue;
                  str := n.TextContent;
                  Delete(str, 1, 8);
                  SetManifestSdkTarget(str);
                end else
                if sl.IndexOf(n.TextContent) < 0 then
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
                  n.TextContent := str;
                  WriteXMLFile(xml, prev);
                  Delete(str, 1, 8);
                  SetManifestSdkTarget(str);
                end;
              finally
                sl.Free
              end;
            end;
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
    Tool.Executable := IncludeTrailingPathDelimiter(FAntPath) + 'ant'{$ifdef windows}+'.bat'{$endif};
    if not FileExists(Tool.Executable) then
      raise Exception.CreateFmt('Ant bin (%s) not found! Check path settings', [Tool.Executable]);
    Tool.CmdLineParams := 'clean -Dtouchtest.enabled=true debug';
    if Install then
      Tool.CmdLineParams := Tool.CmdLineParams + ' install';
    Tool.Scanners.Add(SubToolAnt);
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
    Tool.Executable := IncludeTrailingPathDelimiter(FAntPath) + 'ant'{$ifdef windows}+'.bat'{$endif};
    Tool.CmdLineParams := 'installd';
    Tool.Scanners.Add(SubToolAnt);
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
    Tool.Executable := IncludeTrailingPathDelimiter(FSdkPath) + 'platform-tools' + PathDelim + 'adb$(ExeExt)';
    Tool.CmdLineParams := 'shell am start -n ' + proj + '/.App';
    Tool.Scanners.Add(SubToolDefault);
    if not RunExternalTool(Tool) then
      raise Exception.Create('Cannot run APK!');
    BringToFrontEmulator;
  finally
    Tool.Free;
  end;
end;

procedure RegisterExtToolParser;
begin
  ExternalToolList.RegisterParser(TAntParser);
end;

end.

