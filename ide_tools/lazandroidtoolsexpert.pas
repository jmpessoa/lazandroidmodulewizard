unit lazandroidtoolsexpert;   //by Thierrydijoux!

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, IDEIntf, ProjectIntf, LazIDEIntf, LCLIntf,
  Buttons, Menus, ExtCtrls, ThreadProcess;

type

  { TfrmLazAndroidToolsExpert }

  TBuildMode = (bmArmV6Soft, bmArmV6v2, bmArmV6v3, bmArmV7Soft, bmArmV7v2, bmArmV7v3, bmX86);

  TfrmLazAndroidToolsExpert = class(TForm)
    AndroidNdkPath: TLabel;
    AndroidSdkPath: TLabel;
    bbBuild: TBitBtn;
    bbInstall: TBitBtn;
    BitBtn1: TBitBtn;
    btnBrowseAndroidNdkPath: TButton;
    btnBrowseAndroidSDKPath: TButton;
    btnBrowseAntPath: TButton;
    btnBrowseJdkPath: TButton;
    chkbxUseAntBuild: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    edtWorkpspacePath: TEdit;
    edtLazbuildPath: TEdit;
    edtAndroidNdkPath: TEdit;
    edtAndroidSdkPath: TEdit;
    edtAntPath: TEdit;
    edtJdkPath: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblAntPath: TLabel;
    lblJdkPath: TLabel;
    MemoLog: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    pcMain: TPageControl;
    sddPath: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StatusBar1: TStatusBar;
    tsAction: TTabSheet;
    tsAbout: TTabSheet;
    tsSettings: TTabSheet;
    procedure bbBuildClick(Sender: TObject);
    procedure bbInstallClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);

    procedure btnBrowseAndroidNdkPathClick(Sender: TObject);
    procedure btnBrowseAndroidSDKPathClick(Sender: TObject);
    procedure btnBrowseAntPathClick(Sender: TObject);
    procedure btnBrowseJdkPathClick(Sender: TObject);

    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MemoLogDblClick(Sender: TObject);     //clear...
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { private declarations }
    ProjectPath: string;
    JNIProjectPath: string;    //by jmpessoa
    PathToWorkspace: string;   //by jmpessoa
    PathToLazbuild: string;    //by jmpessoa

    //InstructionSet: string;    //by jmpessoa     //aka TBuildMode

    DefaultBuildModeIndex: integer; //by jmpessoa

    LatSettingFile: string;
    CmdShell: string;
    SdkPath: string;
    NdkPath: string;
    AntPath: string;
    JdkPath: string;
    UseAnt: boolean;

    APKProcess: TThreadProcess;

    procedure LoadSettings;
    procedure SaveSettings;
    procedure ShowProcOutput(AOutput: TStrings);
    function ApkProcessRunning: boolean;
    procedure ChangeBuildMode(ABuildMode: TBuildMode);

    procedure RebuildLibrary; //by jmpessoa
    function GetDefaultBuildModeIndex: integer; //by jmpessoa
    function GetDefaultBuildModeIndex2: integer;  //by jmpessoa

  public
    { public declarations }
  end;

  procedure GetSubDirectories(const directory : string; list : TStrings);
  function ReplaceChar(query: string; oldchar, newchar: char):string;
  function SplitStr(var theString: string; delimiter: string): string;
  function DeleteLineBreaks(const S: string): string;
  function TrimChar(query: string; delimiter: char): string;

var
  frmLazAndroidToolsExpert: TfrmLazAndroidToolsExpert;

resourcestring
  LateMenuCaption = 'Lazarus Android Tools Expert';
  LatCaption = 'LATE';

implementation

uses IniFiles, laz2_Dom, laz2_XMLWrite, laz2_XMLRead;

{$R *.lfm}

procedure TfrmLazAndroidToolsExpert.ChangeBuildMode(ABuildMode: TBuildMode);

  function GetValue(AString: string): string;
  begin
    Result:= Copy(AString, pos('"', AString) + 1, Length(AString));
    Result:= Copy(Result, 0, pos('"', Result) - 1);
  end;

  function GetFile(ABuildMode: TBuildMode): string;
  var
    fileName: string;
  begin
    Result:= JNIProjectPath + DirectorySeparator + 'build-modes' + DirectorySeparator;
    case ABuildMode of
       bmArmV6Soft: begin
                      fileName:= 'build_armV6.txt';
                      if not FileExists(Result+fileName) then fileName:= 'build_armV6_soft.txt';
                      Result+=fileName;
                    end;
       bmArmV7Soft:begin
                      fileName:= 'build_armV7a.txt';
                      if not FileExists(Result+fileName) then fileName:= 'build_armV7a_soft.txt';
                      Result+=fileName;
                  end;
       bmX86: Result+= 'build_x86.txt';
    end;
  end;

  function GetOutput(ABuildMode: TBuildMode): string;
  begin
    Result:= '..' + DirectorySeparator + 'libs' + DirectorySeparator;
    case ABuildMode of
      bmArmV6Soft: Result+= 'armeabi';
      bmArmV7Soft: Result+= 'armeabi-v7a';
      bmX86: Result+= 'x86';
    end;
    Result+= DirectorySeparator + 'libcontrols.so';
  end;

Var
  Project: TXMLDocument;
  Child: TDOMNode;
  NewLib, NewTargetCPU, NewCustomOptions: string;
begin

  With TStringList.Create do
  begin
    LoadFromFile(GetFile(ABuildMode));
    NewLib:= GetValue(Strings[0]);
    NewTargetCPU:= GetValue(Strings[1]);
    NewCustomOptions:= GetValue(Strings[2]);
    Free;
  end;

  Project:= TXMLDocument.Create;

  ReadXMLFile(Project, JNIProjectPath + DirectorySeparator + 'controls.lpi');

  Child:= Project.DocumentElement.FindNode('CompilerOptions');
  if Assigned(Child) then
  begin
    with Child.FindNode('CodeGeneration').FindNode('TargetCPU') do
      Attributes.Item[0].NodeValue:= NewTargetCPU;
    with Child.FindNode('SearchPaths').FindNode('Libraries') do
      Attributes.Item[0].NodeValue:= NewLib;
    with Child.FindNode('Other').FindNode('CustomOptions') do
      Attributes.Item[0].NodeValue:= NewCustomOptions;
    with Child.FindNode('Target').FindNode('Filename') do
      Attributes.Item[0].NodeValue:= GetOutput(ABuildMode);
  end;

  WriteXMLFile(Project, JNIProjectPath + DirectorySeparator + 'controls.lpi');

  Project.Free;
end;

procedure TfrmLazAndroidToolsExpert.LoadSettings;
begin
  With TIniFile.Create(LatSettingFile) do
  begin
    SdkPath:= ReadString('PATH', 'SDK', '');
    NdkPath:= ReadString('PATH', 'NDK', '');
    JdkPath:= ReadString('PATH', 'JDK', '');
    AntPath:= ReadString('PATH', 'Ant', '');
    PathToLazbuild:= ReadString('PATH', 'PathToLazbuild', ''); //by jmpessoa
    PathToWorkspace:= ReadString('PATH', 'PathToWorkspace', ''); //by jmpessoa

    UseAnt:= ReadBool('PATH', 'UseAnt', True);
    Self.Width:= ReadInteger('POS', 'w', Self.Width);
    Self.Height:= ReadInteger('POS', 'h', Self.Height);
    Self.Left:= ReadInteger('POS', 'l', Self.Left);
    Self.Top:= ReadInteger('POS', 't', Self.Top);
    Free;
  end;
end;

procedure TfrmLazAndroidToolsExpert.SaveSettings;
var
  AmwFile: string;
begin
  With TIniFile.Create(LatSettingFile) do
  begin
    if Trim(SdkPath) <> '' then
      WriteString('PATH', 'SDK', SdkPath);
    if Trim(NdkPath) <> '' then
      WriteString('PATH', 'NDK', NdkPath);
    if Trim(JdkPath) <> '' then
      WriteString('PATH', 'JDK', JdkPath);
    if Trim(AntPath) <> '' then
      WriteString('PATH', 'Ant', AntPath);

    if Trim(PathToLazbuild) <> '' then     //by jmpessoa
      WriteString('PATH', 'PathToLazbuild', PathToLazbuild);

    if Trim(PathToWorkspace) <> '' then     //by jmpessoa
      WriteString('PATH', 'PathToWorkspace', PathToWorkspace);

    WriteBool('PATH', 'UseAnt', UseAnt);
    WriteInteger('POS', 'w', Self.Width);
    WriteInteger('POS', 'h', Self.Height);
    WriteInteger('POS', 'l', Self.Left);
    WriteInteger('POS', 't', Self.Top);
    Free;
  end;

  //by jmpessoa
  AmwFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  with TInifile.Create(AmwFile) do
  begin
      WriteString('NewProject', 'FullProjectName', ProjectPath);
      WriteString('NewProject', 'PathToWorkspace', PathToWorkspace);
      Free;
  end;

end;

function TfrmLazAndroidToolsExpert.GetDefaultBuildModeIndex2: integer;
Var
  Project: TXMLDocument;
  Child: TDOMNode;
  strBuildMode: string;
begin
  Result:= 0;
  Project:= TXMLDocument.Create;
  ReadXMLFile(Project, JNIProjectPath + DirectorySeparator + 'controls.lpi');
  Child:= Project.DocumentElement.FindNode('CompilerOptions');
  if Assigned(Child) then
  begin
    with Child.FindNode('Target').FindNode('Filename') do
      strBuildMode:= Attributes.Item[0].NodeValue;
  end;
  if strBuildMode <> '' then
  begin
    if  Pos('armeabi-v7a',strBuildMode) > 0 then Result:= 1
    else if  Pos('armeabi',strBuildMode) > 0 then Result:= 0
    else if  Pos('x86',strBuildMode) > 0 then Result:= 2;
  end;
  Project.Free;
end;

procedure TfrmLazAndroidToolsExpert.FormCreate(Sender: TObject);
Var
  AmwFile: string;
begin
 {
  SynMemo1:= TStringList.Create;
  SynMemo2:= TStringList.Create;
  ImportsList:= TStringList.Create;
  ListJNIBridge:= TStringList.Create;
  }

  SdkPath:= '';
  NdkPath:= '';
  JdkPath:= '';
  AntPath:= '';

  UseAnt:= True;
  LatSettingFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'late.ini';

  AmwFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if FileExists(AmwFile) then
  begin
      with TIniFile.Create(AmwFile) do  // Try to use settings from Android module wizard
      begin

        SdkPath:= ReadString('NewProject', 'PathToAndroidSDK', '');
        NdkPath:= ReadString('NewProject', 'PathToAndroidNDK', '');
        JdkPath:= ReadString('NewProject', 'PathToJavaJDK', '');
        AntPath:= ReadString('NewProject', 'PathToAntBin', '');
        PathToWorkspace:=  ReadString('NewProject', 'PathToWorkspace', ''); //by jmpessoa
        PathToLazbuild:= ReadString('NewProject', 'PathToLazbuild', '');    //by jmpessoa

        ProjectPath:= ReadString('NewProject', 'FullProjectName', '');      //by jmpessoa

        edtAndroidNdkPath.Text:= NdkPath;
        edtAndroidNdkPath.Text:= SdkPath;
        edtJdkPath.Text:= JdkPath;
        edtAntPath.Text:= AntPath;
        edtWorkpspacePath.Text:= PathToLazbuild;

        SaveSettings;
      end;
  end
  else
  begin
     if FileExists(LatSettingFile) then LoadSettings;
  end;

  {$IFDEF WINDOWS}
    CmdShell:= 'cmd /c ';
  {$ENDIF}
  {$IFDEF LINUX}
    CmdShell:= 'sh -c ';
  {$ENDIF}

end;

procedure TfrmLazAndroidToolsExpert.FormShow(Sender: TObject);
begin

  edtAndroidSdkPath.Text:= SdkPath;
  edtAndroidNdkPath.Text:= NdkPath;
  edtJdkPath.Text:= JdkPath;
  edtAntPath.Text:= AntPath;
  edtWorkpspacePath.Text:= PathToWorkspace; //by jmpessoa
  edtLazbuildPath.Text:= PathToLazbuild;  //by jmpessoa
  chkbxUseAntBuild.Checked:= UseAnt;
  pcMain.ActivePage:= tsAction;

  ComboBox2.Items.Clear;  //by jmpessoa
  if PathToWorkspace <> '' then
  begin
    GetSubDirectories(PathToWorkspace, ComboBox2.Items);
    if ProjectPath <> '' then
    begin
      ComboBox2.Text:= ProjectPath;
      StatusBar1.SimpleText:= 'Recent: '+ ProjectPath; //path to most recent project ...   by jmpessoa
      JNIProjectPath:= ProjectPath + DirectorySeparator + 'jni';
      DefaultBuildModeIndex:= GetDefaultBuildModeIndex;   //by jmpessoa
      if DefaultBuildModeIndex = -1 then  DefaultBuildModeIndex:= GetDefaultBuildModeIndex2;
      ComboBox1.ItemIndex:= Self.DefaultBuildModeIndex;
    end;
  end;
end;

procedure TfrmLazAndroidToolsExpert.MemoLogDblClick(Sender: TObject);
begin
  MemoLog.Clear;
end;

procedure TfrmLazAndroidToolsExpert.SpeedButton1Click(Sender: TObject);
begin
  sddPath.Title:= 'Select Projects Workspace Path';
  if Trim(edtWorkpspacePath.Text) <> '' then
    if DirPathExists(edtWorkpspacePath.Text) then
      sddPath.InitialDir:= edtWorkpspacePath.Text;
  if sddPath.Execute then
  begin
     PathToWorkspace:= sddPath.FileName;
     edtWorkpspacePath.Text:= PathToWorkspace;
     ComboBox2.Items.Clear;
     GetSubDirectories(PathToWorkspace, ComboBox2.Items);
     ComboBox2.ItemIndex:= -1;
  end;
end;

procedure TfrmLazAndroidToolsExpert.SpeedButton2Click(Sender: TObject);
begin
  sddPath.Title:= 'Select Lazbuild path';
  if Trim(edtLazbuildPath.Text) <> '' then
    if DirPathExists(edtLazbuildPath.Text) then
      sddPath.InitialDir:= edtLazbuildPath.Text;
  if sddPath.Execute then
  begin
    PathToLazbuild:= sddPath.FileName;    //by jmpessoa
    edtLazbuildPath.Text:= PathToLazbuild;
  end;
end;

procedure TfrmLazAndroidToolsExpert.SpeedButton3Click(Sender: TObject);
begin
  PathToWorkspace:= edtWorkpspacePath.Text;   //change Workspace...
  ComboBox2.Items.Clear;
  GetSubDirectories(PathToWorkspace, ComboBox2.Items);
  ComboBox2.ItemIndex:= -1;
  ComboBox1.ItemIndex:= -1;
  ComboBox2.Text:='';
  ComboBox1.Text:='';
  DefaultBuildModeIndex:= -1;
end;

procedure TfrmLazAndroidToolsExpert.btnBrowseAndroidSDKPathClick(Sender: TObject);
begin
  sddPath.Title:= 'Select Android Sdk path';
  if Trim(edtAndroidSdkPath.Text) <> '' then
    if DirPathExists(edtAndroidSdkPath.Text) then
      sddPath.InitialDir:= edtAndroidSdkPath.Text;
  if sddPath.Execute then
    edtAndroidSdkPath.Text:= sddPath.FileName;
end;

procedure TfrmLazAndroidToolsExpert.btnBrowseAndroidNdkPathClick(Sender: TObject);
begin
  sddPath.Title:= 'Select Android Ndk path';
  if Trim(edtAndroidNdkPath.Text) <> '' then
    if DirPathExists(edtAndroidNdkPath.Text) then
      sddPath.InitialDir:= edtAndroidNdkPath.Text;
  if sddPath.Execute then
    edtAndroidNdkPath.Text:= sddPath.FileName;
end;

procedure TfrmLazAndroidToolsExpert.btnBrowseAntPathClick(Sender: TObject);
begin
  sddPath.Title:= 'Select Ant bin path';
  if Trim(edtAntPath.Text) <> '' then
    if DirPathExists(edtAntPath.Text) then
      sddPath.InitialDir:= edtAntPath.Text;
  if sddPath.Execute then
    edtAntPath.Text:= sddPath.FileName;
end;

procedure TfrmLazAndroidToolsExpert.btnBrowseJdkPathClick(Sender: TObject);
begin
  sddPath.Title:= 'Select JDK path';
  if Trim(edtJdkPath.Text) <> '' then
    if DirPathExists(edtJdkPath.Text) then
      sddPath.InitialDir:= edtJdkPath.Text;
  if sddPath.Execute then
    edtJdkPath.Text:= sddPath.FileName;
end;

procedure TfrmLazAndroidToolsExpert.RebuildLibrary; //by jmpessoa
begin

  if PathToLazbuild = '' then
  begin
     ShowMessage('Fail! PathToLazbuild not found!' );
     Exit;
  end;

  if ApkProcessRunning then Exit;
  MemoLog.Clear;
  APKProcess:= TThreadProcess.Create(True);
  With APKProcess do
  begin
    Dir:= Self.JNIProjectPath;
    Env.Add('path=' + PathToLazbuild);
    CommandLine:= CmdShell + IncludeTrailingBackslash(PathToLazbuild)+
                  DirectorySeparator + 'lazbuild controls.lpi';  //TODO: : [by jmpessoa] need fix: deprecated!
    (* TODO: [by jmpessoa]  test it!
     Executable:= 'lazbuild'
     Parameters.Add('controls.lpi');
    *)
    OnDisplayOutput:= @ShowProcOutput;
    Start;
  end;
end;


procedure TfrmLazAndroidToolsExpert.ComboBox1Change(Sender: TObject);
Var
  Target: TBuildMode;
  strTarget: string;
begin

  if ComboBox1.ItemIndex < 0 then Exit;

  case ComboBox1.ItemIndex of
      0: begin Target:= bmArmV6Soft; strTarget:='ArmV6' end;
      1: begin Target:= bmArmV7Soft; strTarget:='ArmV7a' end;
      2: begin Target:= bmX86; strTarget:='x86' end;
  end;

  if ProjectPath  <> '' then
  begin
       DefaultBuildModeIndex:= ComboBox1.ItemIndex;
       ChangeBuildMode(Target);
       if MessageDlg('Build Mode Changed! ['+strTarget+']',
                     'Do you wish to (Re)Build Library [.so] for "'+strTarget+'"?',
                     mtConfirmation, [mbYes, mbNo],0) = mrYes then
          RebuildLibrary;  //by jmpessoa
  end;

end;

function TfrmLazAndroidToolsExpert.GetDefaultBuildModeIndex: integer;  //by jmpessoa
Var
  Project: TXMLDocument;
  Child: TDOMNode;
  customOptions: string;
begin
  Result:= -1;
  Project:= TXMLDocument.Create;
  ReadXMLFile(Project, JNIProjectPath + DirectorySeparator + 'controls.lpi');
  Child:= Project.DocumentElement.FindNode('CompilerOptions');
  if Assigned(Child) then
  begin
     with Child.FindNode('Other').FindNode('CustomOptions') do
       customOptions:= UpperCase(Attributes.Item[0].NodeValue);
  end;
  if customOptions <> '' then
  begin
    if Pos('ARMV6', customOptions) > 0 then Result:= 0
    else if Pos('ARMV7A', customOptions) > 0 then Result:= 1
    else if Pos('I686', customOptions) > 0 then Result:= 2;
  end;
  Project.Free;

end;

procedure TfrmLazAndroidToolsExpert.ComboBox2Change(Sender: TObject);
begin
  if ComboBox2.ItemIndex > -1 then
  begin
    ProjectPath:= ComboBox2.Items.Strings[ComboBox2.ItemIndex];
    JNIProjectPath:= ProjectPath + DirectorySeparator + 'jni';
    StatusBar1.SimpleText:= ProjectPath;

    DefaultBuildModeIndex:= GetDefaultBuildModeIndex;
    if  DefaultBuildModeIndex = -1 then DefaultBuildModeIndex:= GetDefaultBuildModeIndex2;

    ComboBox1.ItemIndex:= DefaultBuildModeIndex;
    ComboBox1Change(nil);
  end;
end;

procedure TfrmLazAndroidToolsExpert.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  SaveSettings;
  if Assigned(APKProcess) then
  begin
    if not APKProcess.IsTerminated then
    begin
      APKProcess.ForceStop:= True;
      APKProcess.Terminate;
    end;
  end;
end;

procedure TfrmLazAndroidToolsExpert.ShowProcOutput(AOutput: TStrings);
begin
  MemoLog.Lines.Add(AOutput.Text);
end;

function TfrmLazAndroidToolsExpert.ApkProcessRunning: boolean;
begin
  Result:= False;
  if Assigned(APKProcess) then
    if not APKProcess.IsTerminated then
      Result:= True
    else
    begin
      APKProcess:= nil;
      Result:= False;
    end;
end;


procedure TfrmLazAndroidToolsExpert.bbBuildClick(Sender: TObject);
begin

  if ProjectPath = '' then
  begin
     ShowMessage('Fail! Please, select a Project!');
     Exit;
  end;

  if ApkProcessRunning then Exit;
  MemoLog.Clear;
  APKProcess:= TThreadProcess.Create(True);
  with APKProcess do
  begin
    Dir:= ProjectPath;
    Env.Add('path=' + AntPath);
    Env.Add('JAVA_HOME=' + JdkPath);

    CommandLine:= CmdShell + ' ant -Dtouchtest.enabled=true debug';    //TODO: : [by jmpessoa] need fix: deprecated!

    (* TODO: [by jmpessoa]  test it!
     Executable:= 'ant'
     Parameters.Add('-Dtouchtest.enabled=true');
     Parameters.Add('debug');
    *)

    OnDisplayOutput:= @ShowProcOutput;
    Start;
  end;
end;

procedure TfrmLazAndroidToolsExpert.bbInstallClick(Sender: TObject);
Var
  ApkName: string;
begin

  if ProjectPath = '' then
  begin
     ShowMessage('Fail! Please, select a Project!');
     Exit;
  end;

  if ApkProcessRunning then Exit;
  MemoLog.Clear;
  With TStringList.Create do
  begin
    Delimiter:= DirectorySeparator;
    DelimitedText:= ProjectPath;
    ApkName:= Strings[Count-1] + '-debug.apk';
    Free;
  end;
  APKProcess:= TThreadProcess.Create(True);
  With APKProcess do
  begin
    Dir:= ProjectPath + DirectorySeparator + 'bin';
    CommandLine:= CmdShell + IncludeTrailingBackslash(SdkPath) + 'platform-tools' +
                  DirectorySeparator + 'adb install -r ' + ApkName;     //TODO: : [by jmpessoa] need fix: deprecated!

   (* TODO: [by jmpessoa]  test it!
     Executable:= 'adb'
     Parameters.Add('install');
     Parameters.Add('-r');
     Parameters.Add(ApkName);
    *)

    OnDisplayOutput:= @ShowProcOutput;
    Start;
  end;
end;

procedure TfrmLazAndroidToolsExpert.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

//helper... by jmpessoa

//http://delphi.about.com/od/delphitips2008/qt/subdirectories.htm
//fils the "list" TStrings with the subdirectories of the "directory" directory
//Warning: if not  subdirectories was found return empty list [list.count = 0]!
procedure GetSubDirectories(const directory : string; list : TStrings);
var
   sr : TSearchRec;
begin
   try
     if FindFirst(IncludeTrailingPathDelimiter(directory) + '*.*', faDirectory, sr) < 0 then Exit
     else
     repeat
       if ((sr.Attr and faDirectory <> 0) and (sr.Name <> '.') and (sr.Name <> '..')) then
       begin
           List.Add(IncludeTrailingPathDelimiter(directory) + sr.Name);
       end;
     until FindNext(sr) <> 0;
   finally
     SysUtils.FindClose(sr) ;
   end;
end;

//helper... by jmpessoa
function ReplaceChar(query: string; oldchar, newchar: char):string;
begin
  if query <> '' then
  begin
     while Pos(oldchar,query) > 0 do query[pos(oldchar,query)]:= newchar;
     Result:= query;
  end;
end;

function SplitStr(var theString: string; delimiter: string): string;
var
  i: integer;
begin
  Result:= '';
  if theString <> '' then
  begin
    i:= Pos(delimiter, theString);
    if i > 0 then
    begin
       Result:= Copy(theString, 1, i-1);
       theString:= Copy(theString, i+Length(delimiter), maxLongInt);
    end
    else
    begin
       Result:= theString;
       theString:= '';
    end;
  end;
end;

function DeleteLineBreaks(const S: string): string;
var
   Source, SourceEnd: PChar;
begin
   Source := Pointer(S) ;
   SourceEnd := Source + Length(S) ;
   while Source < SourceEnd do
   begin
      case Source^ of
        #10: Source^ := #32;
        #13: Source^ := #32;
      end;
      Inc(Source) ;
   end;
   Result := S;
end;

function TrimChar(query: string; delimiter: char): string;
var
  auxStr: string;
  count: integer;
  newchar: char;
begin
  newchar:=' ';
  if query <> '' then
  begin
      auxStr:= Trim(query);
      count:= Length(auxStr);
      if count >= 2 then
      begin
         if auxStr[1] = delimiter then  auxStr[1] := newchar;
         if auxStr[count] = delimiter then  auxStr[count] := newchar;
      end;
      Result:= Trim(auxStr);
  end;
end;


end.
