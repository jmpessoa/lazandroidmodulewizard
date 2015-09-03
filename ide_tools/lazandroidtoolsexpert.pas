unit lazandroidtoolsexpert;   //by Thierrydijoux!

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, IDEIntf, ProjectIntf, LazIDEIntf, MacroIntf, LCLIntf,
  Buttons, Menus, ExtCtrls, ThreadProcess;

type

  { TfrmLazAndroidToolsExpert }

  TBuildMode = (bmArmV6Soft, bmArmV6v2, bmArmV6v3, bmArmV7Soft, bmArmV7v2, bmArmV7v3, bmX86);

  TfrmLazAndroidToolsExpert = class(TForm)
    BitBtnBuild: TBitBtn;
    BitBtnClose: TBitBtn;
    BitBtnInstall: TBitBtn;
    ComboBoxSelectProject: TComboBox;
    ComboBoxTarget: TComboBox;
    EditPathToWorkspace: TEdit;
    LabelAndroidNDKPath: TLabel;
    LabelAndroidSDKPath: TLabel;
    BtnAndroidNDKPath: TButton;
    BtnAndroidSDKPath: TButton;
    BtnAntBinaryPath: TButton;
    BtnJDKPath: TButton;
    chkbxUseAntBuild: TCheckBox;
    EditAndroidNDKPath: TEdit;
    EditAndroidSDKPath: TEdit;
    EditAntBinaryPath: TEdit;
    EditJDKPath: TEdit;
    LabelAntBinaryPath: TLabel;
    LabelJDKPath: TLabel;
    LabelPathToWorkspace: TLabel;
    LabelSelectProject: TLabel;
    LabelTarget: TLabel;
    MemoLog: TMemo;
    MemoLogFilter: TMemo;
    MemoLogError: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PageControlLog: TPageControl;
    PageControlMain: TPageControl;
    Panel1: TPanel;
    PanelButtonsInstallClose: TPanel;
    PanelLogs: TPanel;
    PopupMenu1: TPopupMenu;
    SelDirDlgPath: TSelectDirectoryDialog;
    SpBPathToWorkspace: TSpeedButton;
    SpBSelectProject: TSpeedButton;
    StatusBarMain: TStatusBar;
    TabSheetBuildInstallLog: TTabSheet;
    TabSheetTAGFilterLog: TTabSheet;
    TabSheetRunTimeErrorLog: TTabSheet;
    TabSheetAction: TTabSheet;
    TabSheetAbout: TTabSheet;
    TabSheetSettings: TTabSheet;
    LabelAboutInfo: TLabel;
    procedure BitBtnBuildClick(Sender: TObject);
    procedure BitBtnInstallClick(Sender: TObject);
    procedure BitBtnCloseClick(Sender: TObject);

    procedure BtnAndroidNDKPathClick(Sender: TObject);
    procedure BtnAndroidSDKPathClick(Sender: TObject);
    procedure BtnAntBinaryPathClick(Sender: TObject);
    procedure BtnJDKPathClick(Sender: TObject);

    procedure ComboBoxTargetChange(Sender: TObject);
    procedure ComboBoxSelectProjectChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MemoLogDblClick(Sender: TObject);     //clear...

    procedure PageControlLogChange(Sender: TObject);
    procedure PopupMenu1Close(Sender: TObject);
    procedure SpBPathToWorkspaceClick(Sender: TObject);
    procedure SpBSelectProjectClick(Sender: TObject);

  private
    { private declarations }
    ProjectPath: string;
    JNIProjectPath: string;    //by jmpessoa
    PathToWorkspace: string;   //by jmpessoa

    //InstructionSet: string;    //by jmpessoa     //aka TBuildMode

    DefaultBuildModeIndex: integer; //by jmpessoa

    LatSettingFile: string;
    SdkPath: string;
    NdkPath: string;
    AntPath: string;
    JdkPath: string;
    UseAnt: boolean;

    APKProcess: TThreadProcess;

    function ApkProcessRunning: boolean;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure ShowProcOutput(AOutput: TStrings);

    procedure ShowProcOutputFilter(AOutput: TStrings); //by jmpessoa
    procedure ShowProcOutputError(AOutput: TStrings);  //by jmpessoa

    procedure ChangeBuildMode(ABuildMode: TBuildMode);

    procedure RebuildLibrary; //by jmpessoa
    function GetDefaultBuildModeIndex: integer; //by jmpessoa
    function GetDefaultBuildModeIndex2: integer;  //by jmpessoa

    procedure ExecuteTagQuery(strTAG: string); //by jmpessoa

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

uses IniFiles, laz2_Dom, laz2_XMLWrite, laz2_XMLRead, LazFileUtils;

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

  with TStringList.Create do
    try
      LoadFromFile(GetFile(ABuildMode));
      NewLib:= GetValue(Strings[0]);
      NewTargetCPU:= GetValue(Strings[1]);
      NewCustomOptions:= GetValue(Strings[2]);
    finally
      Free;
  end;

  ReadXMLFile(Project, JNIProjectPath + DirectorySeparator + 'controls.lpi');
  try
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
  finally
    Project.Free;
  end;
end;

procedure TfrmLazAndroidToolsExpert.LoadSettings;
begin
  With TIniFile.Create(LatSettingFile) do
  try
    SdkPath:= ReadString('PATH', 'SDK', '');
    NdkPath:= ReadString('PATH', 'NDK', '');
    JdkPath:= ReadString('PATH', 'JDK', '');
    AntPath:= ReadString('PATH', 'Ant', '');
    PathToWorkspace:= ReadString('PATH', 'PathToWorkspace', ''); //by jmpessoa

    UseAnt:= ReadBool('PATH', 'UseAnt', True);
    Self.Width:= ReadInteger('POS', 'w', Self.Width);
    Self.Height:= ReadInteger('POS', 'h', Self.Height);
    Self.Left:= ReadInteger('POS', 'l', Self.Left);
    Self.Top:= ReadInteger('POS', 't', Self.Top);
  finally
    Free;
  end;
end;

procedure TfrmLazAndroidToolsExpert.SaveSettings;
var
  AmwFile: string;
begin
  With TIniFile.Create(LatSettingFile) do
  try
    if Trim(SdkPath) <> '' then
      WriteString('PATH', 'SDK', SdkPath);
    if Trim(NdkPath) <> '' then
      WriteString('PATH', 'NDK', NdkPath);
    if Trim(JdkPath) <> '' then
      WriteString('PATH', 'JDK', JdkPath);
    if Trim(AntPath) <> '' then
      WriteString('PATH', 'Ant', AntPath);

    if Trim(PathToWorkspace) <> '' then     //by jmpessoa
      WriteString('PATH', 'PathToWorkspace', PathToWorkspace);

    WriteBool('PATH', 'UseAnt', UseAnt);
    WriteInteger('POS', 'w', Self.Width);
    WriteInteger('POS', 'h', Self.Height);
    WriteInteger('POS', 'l', Self.Left);
    WriteInteger('POS', 't', Self.Top);
  finally
    Free;
  end;

  //by jmpessoa
  AmwFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  with TInifile.Create(AmwFile) do
  try
      WriteString('NewProject', 'FullProjectName', ProjectPath);
      WriteString('NewProject', 'PathToWorkspace', PathToWorkspace);
  finally
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
  ReadXMLFile(Project, JNIProjectPath + DirectorySeparator + 'controls.lpi');
  try
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
  finally
    Project.Free;
  end;
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
      try
        SdkPath:= ReadString('NewProject', 'PathToAndroidSDK', '');
        NdkPath:= ReadString('NewProject', 'PathToAndroidNDK', '');
        JdkPath:= ReadString('NewProject', 'PathToJavaJDK', '');
        AntPath:= ReadString('NewProject', 'PathToAntBin', '');
        PathToWorkspace:=  ReadString('NewProject', 'PathToWorkspace', ''); //by jmpessoa

        ProjectPath:= ReadString('NewProject', 'FullProjectName', '');      //by jmpessoa

        EditAndroidNDKPath.Text:= NdkPath;
        EditAndroidSDKPath.Text:= SdkPath;
        EditJDKPath.Text:= JdkPath;
        EditAntBinaryPath.Text:= AntPath;

        SaveSettings;
      finally
        Free
      end;
  end
  else
  begin
     if FileExists(LatSettingFile) then LoadSettings;
  end;
end;

procedure TfrmLazAndroidToolsExpert.FormShow(Sender: TObject);
var
  SubDirs: TStringList;
begin

  Self.PageControlLog.ActivePage:= TabSheetBuildInstallLog; //by jmpessoa

  EditAndroidSDKPath.Text:= SdkPath;
  EditAndroidNDKPath.Text:= NdkPath;
  EditJDKPath.Text:= JdkPath;
  EditAntBinaryPath.Text:= AntPath;
  EditPathToWorkspace.Text:= PathToWorkspace; //by jmpessoa
  chkbxUseAntBuild.Checked:= UseAnt;
  PageControlMain.ActivePage:= TabSheetAction;

  ComboBoxSelectProject.Items.Clear;  //by jmpessoa
  if (PathToWorkspace <> '') and DirectoryExists(PathToWorkspace) then
  begin
    SubDirs := FindAllDirectories(PathToWorkspace,false);
    try
      ComboBoxSelectProject.Items.Assign(SubDirs);
    finally
      SubDirs.Free;
    end;
    //GetSubDirectories(PathToWorkspace, ComboBoxSelectProject.Items);
    if (ProjectPath <> '') and DirectoryExists(ProjectPath) then
    begin
      ComboBoxSelectProject.Text:= ProjectPath;
      StatusBarMain.SimpleText:= 'Recent: '+ ProjectPath; //path to most recent project ...   by jmpessoa
      JNIProjectPath:= ProjectPath + DirectorySeparator + 'jni';
      DefaultBuildModeIndex:= GetDefaultBuildModeIndex;   //by jmpessoa
      if DefaultBuildModeIndex = -1 then  DefaultBuildModeIndex:= GetDefaultBuildModeIndex2;
      ComboBoxTarget.ItemIndex:= Self.DefaultBuildModeIndex;
    end;
  end;
end;

procedure TfrmLazAndroidToolsExpert.MemoLogDblClick(Sender: TObject);
begin
  MemoLog.Clear;
end;

procedure TfrmLazAndroidToolsExpert.PageControlLogChange(Sender: TObject);    //by jmpessoa
begin
  if PageControlLog.ActivePage = TabSheetRunTimeErrorLog then
  begin
    begin
      if Assigned(APKProcess) then
      begin
         if not APKProcess.IsTerminated then APKProcess.Terminate;
      end;
      MemoLogError.Clear;
      APKProcess:= TThreadProcess.Create(True);
      With APKProcess do
      begin
        Dir:= ProjectPath + DirectorySeparator + 'bin';
        Executable:= IncludeTrailingBackslash(SdkPath) + 'platform-tools'
          + DirectorySeparator + 'adb';
        Parameters.Add('logcat');
        Parameters.Add('AndroidRuntime:E');
        Parameters.Add('*:S');
        OnDisplayOutput:= @ShowProcOutputError;
        Start;
      end;
    end;
  end;

  //adb logcat ActivityManager:I AppSqliteDemo2-debug.apk:D *:S

end;

procedure TfrmLazAndroidToolsExpert.ExecuteTagQuery(strTAG: string);
begin
  if Assigned(APKProcess) then
  begin
    if not APKProcess.IsTerminated then APKProcess.Terminate;
    APKProcess:= TThreadProcess.Create(True);
    MemoLogFilter.Clear;
    With APKProcess do
    begin
      //Dir:= ProjectPath + DirectorySeparator + 'bin';
      Executable:= IncludeTrailingBackslash(SdkPath) + 'platform-tools'
        + DirectorySeparator + 'adb';
      Parameters.Add('logcat');
      Parameters.Add('-s');
      Parameters.Add(strTAG);
      OnDisplayOutput:= @ShowProcOutputFilter;
      Start;
    end;
  end;
end;


procedure TfrmLazAndroidToolsExpert.PopupMenu1Close(Sender: TObject);
var
  strFilterTAG: string;
  strCaption: string;
begin
    strCaption:= (Sender as TMenuItem).Caption;
    if Pos('DalvikVM', strCaption) > 0then
       ExecuteTagQuery('dalvikvm')
    else if Pos('libC', strCaption) > 0then
          ExecuteTagQuery('libc')
    else if Pos('Enter TAG', strCaption) > 0 then
    begin
      strFilterTAG:= 'TAG_CLICK';  //demo Button click
      if InputQuery('Logcat Filter','Please, enter a "TAG"', strFilterTAG) then
         if strFilterTAG <> '' then ExecuteTagQuery(strFilterTAG)
    end
    else
    begin
       MemoLogFilter.Clear;
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('[Right Click to enter a filter TAG ...]');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('"How to"');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('1. Select System TAG [ex. "dalvikvm", "libc", etc...]');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('2. Use the java Log.(x) to output customized TAG:');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('Use the java Log.(x) to output:');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('Log.i(String TAG, String MESSAGE);');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('.the first string is an [easy for search]  TAG that will appear in the logcat output');
       MemoLogFilter.Lines.Add('.the second string is the message printed to log [output]');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('You can also change to:       [TODO: different color!]');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('Log.d (debug)');
       MemoLogFilter.Lines.Add('Log.i (Information)');
       MemoLogFilter.Lines.Add('Log.w (Warning)');
       MemoLogFilter.Lines.Add('Log.e (Error)');
       MemoLogFilter.Lines.Add('Log.v (verbose)');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('Example: [java code]');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('String TAG_NAME = "TAG_CLICK";');
       MemoLogFilter.Lines.Add('String MESSAGE= "jButton_Clicked!";');
       MemoLogFilter.Lines.Add('Log.i(TAG_NAME, MESSAGE);');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('PS.1: To get the string for an int, use Integer.toString(intValue).');
       MemoLogFilter.Lines.Add('PS.2: You should not use LogCat messages in release App a [bad performance!]');
       MemoLogFilter.Lines.Add(' ');
       MemoLogFilter.Lines.Add('ref.1: http://stackoverflow.com/questions/15425975/creating-a-simple-output-to-logcat');
       MemoLogFilter.Lines.Add('ref.2: http://www.101apps.co.za/articles/using-android-s-log-class-api-to-debug-android-application-code.html');
    end;
end;

procedure TfrmLazAndroidToolsExpert.SpBPathToWorkspaceClick(Sender: TObject);
begin
  SelDirDlgPath.Title:= 'Select Projects Workspace Path';
  if Trim(EditPathToWorkspace.Text) <> '' then
    if DirPathExists(EditPathToWorkspace.Text) then
      SelDirDlgPath.InitialDir:= EditPathToWorkspace.Text;
  if SelDirDlgPath.Execute then
  begin
     PathToWorkspace:= SelDirDlgPath.FileName;
     EditPathToWorkspace.Text:= PathToWorkspace;
     ComboBoxSelectProject.Items.Clear;
     GetSubDirectories(PathToWorkspace, ComboBoxSelectProject.Items);
     ComboBoxSelectProject.ItemIndex:= -1;
  end;
end;

procedure TfrmLazAndroidToolsExpert.SpBSelectProjectClick(Sender: TObject);
begin
  PathToWorkspace:= EditPathToWorkspace.Text;   //change Workspace...
  ComboBoxSelectProject.Items.Clear;
  GetSubDirectories(PathToWorkspace, ComboBoxSelectProject.Items);
  ComboBoxSelectProject.ItemIndex:= -1;
  ComboBoxTarget.ItemIndex:= -1;
  ComboBoxSelectProject.Text:='';
  ComboBoxTarget.Text:='';
  DefaultBuildModeIndex:= -1;
end;

procedure TfrmLazAndroidToolsExpert.BtnAndroidSDKPathClick(Sender: TObject);
begin
  SelDirDlgPath.Title:= 'Select Android Sdk path';
  if Trim(EditAndroidSDKPath.Text) <> '' then
    if DirPathExists(EditAndroidSDKPath.Text) then
      SelDirDlgPath.InitialDir:= EditAndroidSDKPath.Text;
  if SelDirDlgPath.Execute then
    EditAndroidSDKPath.Text:= SelDirDlgPath.FileName;
end;

procedure TfrmLazAndroidToolsExpert.BtnAndroidNDKPathClick(Sender: TObject);
begin
  SelDirDlgPath.Title:= 'Select Android Ndk path';
  if Trim(EditAndroidNDKPath.Text) <> '' then
    if DirPathExists(EditAndroidNDKPath.Text) then
      SelDirDlgPath.InitialDir:= EditAndroidNDKPath.Text;
  if SelDirDlgPath.Execute then
    EditAndroidNDKPath.Text:= SelDirDlgPath.FileName;
end;

procedure TfrmLazAndroidToolsExpert.BtnAntBinaryPathClick(Sender: TObject);
begin
  SelDirDlgPath.Title:= 'Select Ant bin path';
  if Trim(EditAntBinaryPath.Text) <> '' then
    if DirPathExists(EditAntBinaryPath.Text) then
      SelDirDlgPath.InitialDir:= EditAntBinaryPath.Text;
  if SelDirDlgPath.Execute then
    EditAntBinaryPath.Text:= SelDirDlgPath.FileName;
end;

procedure TfrmLazAndroidToolsExpert.BtnJDKPathClick(Sender: TObject);
begin
  SelDirDlgPath.Title:= 'Select JDK path';
  if Trim(EditJDKPath.Text) <> '' then
    if DirPathExists(EditJDKPath.Text) then
      SelDirDlgPath.InitialDir:= EditJDKPath.Text;
  if SelDirDlgPath.Execute then
    EditJDKPath.Text:= SelDirDlgPath.FileName;
end;


procedure TfrmLazAndroidToolsExpert.RebuildLibrary; //by jmpessoa
var s: string;
begin
  //if ApkProcessRunning then Exit;
  if Assigned(APKProcess) then
  begin
      if not APKProcess.IsTerminated then APKProcess.Terminate;
  end;

  MemoLog.Clear;
  APKProcess:= TThreadProcess.Create(True);
  with APKProcess do
  begin
    Dir:= Self.JNIProjectPath;  //controls.lpi

    s := '$MakeDir($(LazarusDir))lazbuild';
    IDEMacros.SubstituteMacros(s);
    Executable := s;
    Parameters.Add('controls.lpi');

    OnDisplayOutput:= @ShowProcOutput;
    Start;
  end;
end;


procedure TfrmLazAndroidToolsExpert.ComboBoxTargetChange(Sender: TObject);
Var
  Target: TBuildMode;
  strTarget: string;
begin

  if ComboBoxTarget.ItemIndex < 0 then Exit;

  case ComboBoxTarget.ItemIndex of
      0: begin Target:= bmArmV6Soft; strTarget:='ArmV6' end;
      1: begin Target:= bmArmV7Soft; strTarget:='ArmV7a' end;
      2: begin Target:= bmX86; strTarget:='x86' end;
  end;

  if ProjectPath  <> '' then
  begin
       DefaultBuildModeIndex:= ComboBoxTarget.ItemIndex;
       try
         ChangeBuildMode(Target);
         if MessageDlg('Build Mode Changed! ['+strTarget+']',
                       'Do you wish to (Re)Build Library [.so] for "'+strTarget+'"?',
                       mtConfirmation, [mbYes, mbNo],0) = mrYes then
            RebuildLibrary;  //by jmpessoa
       except
         on e: Exception do begin
           MessageDlg('Error',e.Message,mtError,[mbOK],0);
         end;
       end;
  end;

end;

function TfrmLazAndroidToolsExpert.GetDefaultBuildModeIndex: integer;  //by jmpessoa
Var
  Project: TXMLDocument;
  Child: TDOMNode;
  customOptions: string;
begin
  Result:= -1;
  ReadXMLFile(Project, JNIProjectPath + DirectorySeparator + 'controls.lpi');
  try
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
  finally
    Project.Free;
  end;
end;

procedure TfrmLazAndroidToolsExpert.ComboBoxSelectProjectChange(Sender: TObject);
begin
  if ComboBoxSelectProject.ItemIndex > -1 then
  begin
    ProjectPath:= ComboBoxSelectProject.Items.Strings[ComboBoxSelectProject.ItemIndex];
    JNIProjectPath:= ProjectPath + DirectorySeparator + 'jni';
    StatusBarMain.SimpleText:= ProjectPath;

    DefaultBuildModeIndex:= GetDefaultBuildModeIndex;
    if  DefaultBuildModeIndex = -1 then DefaultBuildModeIndex:= GetDefaultBuildModeIndex2;

    ComboBoxTarget.ItemIndex:= DefaultBuildModeIndex;
    ComboBoxTargetChange(nil);
  end;
end;

procedure TfrmLazAndroidToolsExpert.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  SaveSettings;
  if Assigned(APKProcess) then
    if not APKProcess.IsTerminated then
      APKProcess.Terminate;
  CloseAction := caFree
end;

procedure TfrmLazAndroidToolsExpert.ShowProcOutput(AOutput: TStrings);
begin
  MemoLog.Lines.Add(AOutput.Text);
end;

procedure TfrmLazAndroidToolsExpert.ShowProcOutputFilter(AOutput: TStrings);
begin
  MemoLogFilter.Lines.Add(AOutput.Text);
end;

procedure TfrmLazAndroidToolsExpert.ShowProcOutputError(AOutput: TStrings);
begin
  MemoLogError.Lines.Add(AOutput.Text);
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

procedure TfrmLazAndroidToolsExpert.BitBtnBuildClick(Sender: TObject);
begin
  if ProjectPath = '' then
  begin
     ShowMessage('Fail! Please, select a Project!');
     Exit;
  end;

  if AntPath = '' then
  begin
     ShowMessage('Fail! PathToAnt not found!' );
     Exit;
  end;

  if ApkProcessRunning then
    if Assigned(APKProcess) then
       if not APKProcess.IsTerminated then  APKProcess.Terminate;

  MemoLog.Clear;
  APKProcess:= TThreadProcess.Create(True);
  with APKProcess do
  begin

    {
    set path=C:\adt32\ant\bin
    set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
    cd C:\adt32\eclipse\workspace\AppSqliteDemo2
    ant -Dtouchtest.enabled=true debug
    }

    Env.Add('JAVA_HOME=' + JdkPath);
    Dir:= ProjectPath;
    Executable:= IncludeTrailingBackslash(AntPath) + 'ant'{$ifdef windows}+'.bat'{$endif};
    Parameters.Add('-Dtouchtest.enabled=true');
    Parameters.Add('debug');

    OnDisplayOutput:= @ShowProcOutput;
    Start;
  end;
end;

procedure TfrmLazAndroidToolsExpert.BitBtnInstallClick(Sender: TObject);
Var
  ApkName: string;
begin

  if ProjectPath = '' then
  begin
     ShowMessage('Fail! Please, select a Project!');
     Exit;
  end;

  if ApkProcessRunning then
    if Assigned(APKProcess) then
       if not APKProcess.IsTerminated then  APKProcess.Terminate;

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

    Executable:= IncludeTrailingBackslash(SdkPath) + 'platform-tools'
      + DirectorySeparator + 'adb';
    Parameters.Add('install');
    Parameters.Add('-r');
    Parameters.Add(ApkName);

    OnDisplayOutput:= @ShowProcOutput;
    Start;
  end;
end;

procedure TfrmLazAndroidToolsExpert.BitBtnCloseClick(Sender: TObject);
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
