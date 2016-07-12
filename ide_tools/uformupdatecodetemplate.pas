unit uformupdatecodetemplate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Buttons, IDEIntf, ProjectIntf, LazIDEIntf, MacroIntf, LCLIntf,
  ExtCtrls, IniFiles, ThreadProcess, uJavaParser, Clipbrd;

type

  { TFormUpdateCodeTemplate }

  TFormUpdateCodeTemplate = class(TForm)
    BitBtnOK: TBitBtn;
    BitBtnClose: TBitBtn;
    CheckGroupUpgradeTemplates: TCheckGroup;
    ComboBoxSelectProject: TComboBox;
    EditPathToWorkspace: TEdit;
    LabelPathToWorkspace: TLabel;
    LabelSelectProject: TLabel;
    sddPath: TSelectDirectoryDialog;
    SpBPathToWorkspace: TSpeedButton;
    SpBSelectProject: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure BitBtnOKClick(Sender: TObject);
    procedure ComboBoxSelectProjectChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpBPathToWorkspaceClick(Sender: TObject);
    procedure SpBSelectProjectClick(Sender: TObject);
  private
    { private declarations }
    MemoLog: TStringList;
    SynMemo1: TStringList;
    SynMemo2: TStringList;

    ProjectPath: string;
    JNIProjectPath: string;
    PathToWorkspace: string;
    PathToJavaTemplates: string;
    PathToJavaClass: string;

    PackageName: string;
    JavaClassName: string;  //"Controls"

    APKProcess: TThreadProcess;

    procedure RebuildLibrary; //by jmpessoa
    procedure ShowProcOutput(AOutput: TStrings);
    function ApkProcessRunning: boolean;
    procedure DoTerminated(Sender: TObject);
  public
    { public declarations }
  end;


procedure GetSubDirectories(const directory: string; list: TStrings);
function ReplaceChar(query: string; oldchar, newchar: char): string;

var
  FormUpdateCodeTemplate: TFormUpdateCodeTemplate;

implementation

{$R *.lfm}

uses LazFileUtils, CompOptsIntf, IDEExternToolIntf;

{ TFormUpdateCodeTemplate }

procedure TFormUpdateCodeTemplate.DoTerminated(Sender: TObject);
begin
  Clipboard.AsText:=(MemoLog.Text);
  ShowMessage('The Upgrade was Done! Please, Get the Log from Clipboard!');
end;

procedure TFormUpdateCodeTemplate.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
var
  AmwFile: string;
begin
  AmwFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  with TInifile.Create(AmwFile) do
  try
    WriteString('NewProject', 'FullProjectName', ProjectPath);
    WriteString('NewProject', 'PathToWorkspace', PathToWorkspace);
  finally
    Free;
  end;

  if Assigned(APKProcess) then
    if not APKProcess.IsTerminated then APKProcess.Terminate;

  CloseAction := caFree;
end;

procedure TFormUpdateCodeTemplate.ShowProcOutput(AOutput: TStrings);
begin
   MemoLog.Add(AOutput.Text);
end;

function TFormUpdateCodeTemplate.ApkProcessRunning: boolean;
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

procedure TFormUpdateCodeTemplate.RebuildLibrary;
var
  Tool: TIDEExternalToolOptions;
begin
  if JNIProjectPath = '' then
  begin
    ShowMessage('Fail! JNI project path not found!' );
    Exit;
  end;
  Tool := TIDEExternalToolOptions.Create;
  try
    Tool.Title := 'Rebuilding ".so" library';
    Tool.ResolveMacros := True;
    Tool.Executable := '$MakeDir($(LazarusDir))lazbuild$(ExeExt)';
    Tool.CmdLineParams := 'controls.lpi';
    Tool.WorkingDirectory := JNIProjectPath;
    Tool.Scanners.Add(SubToolFPC);
    RunExternalTool(Tool)
  finally
    Tool.Free
  end;
end;

procedure TFormUpdateCodeTemplate.BitBtnOKClick(Sender: TObject);
var
  packList: TstringList;
  fileList: TStringList;
  pk, i: integer;
  strAux: string;
begin
  MemoLog.Clear;

  if (ProjectPath = '') or (JNIProjectPath = '') then
  begin
     ShowMessage('Fail! Please, select a Project!');
     ModalResult := mrNone;
     Exit;
  end;

  if not FileExistsUTF8(PathToJavaTemplates + PathDelim + 'App.java')
  or not FileExistsUTF8(PathToJavaTemplates + PathDelim + 'Controls.java')
  or not FileExistsUTF8(PathToJavaTemplates + PathDelim + 'ControlsEvents.txt')
  then begin
    MessageDlg('Fail! Incorrect path to Java templates!' + sLineBreak
      + 'Can not find "App.java" or "Controls.java" or "ControlsEvents.txt" in "' + PathToJavaTemplates + '"',
      mtError, [mbOk], 0);
    Exit;
  end;

  packList:= TstringList.Create;
  fileList:= TStringList.Create;

  if FileExistsUTF8(ComboBoxSelectProject.Text+DirectorySeparator+'packagename.txt') then //for release >= 0.6/05
  begin
    packList.LoadFromFile(ComboBoxSelectProject.Text+DirectorySeparator+'packagename.txt');
    PackageName:= Trim(packList.Strings[0]);  //ex. com.example.appbuttondemo1
    PathToJavaClass:= ComboBoxSelectProject.Text+DirectorySeparator+'src'+
                 DirectorySeparator+ReplaceChar(PackageName, '.',DirectorySeparator);
  end
  else  //try get PackageName from 'AndroidManifest.xml'
  begin
     packList.LoadFromFile(ComboBoxSelectProject.Text+DirectorySeparator+'AndroidManifest.xml');
     pk:= Pos('package="',packList.Text);  //ex. package="com.example.appbuttondemo1"
     strAux:= Copy(packList.Text, pk+Length('package="'), 200);

     i:= 2; //scape first[ " ]
     while strAux[i]<>'"' do
     begin
        i:= i+1;
     end;
     PackageName:= Trim(Copy(strAux, 1, i-1));

     PathToJavaClass:= ComboBoxSelectProject.Text+DirectorySeparator+'src'+
                 DirectorySeparator+ReplaceChar(PackageName, '.',DirectorySeparator);
  end;

  //upgrade "App.java"
  if  CheckGroupUpgradeTemplates.Checked[0] then
  begin
    if FileExistsUTF8(PathToJavaClass+DirectorySeparator+'App.java') then
    begin
      fileList.LoadFromFile(PathToJavaClass+DirectorySeparator+'App.java');
      fileList.SaveToFile(PathToJavaClass+DirectorySeparator+'App.java'+'.bak');
    end;
    packList.LoadFromFile(PathToJavaTemplates+DirectorySeparator+'App.java');
    packList.Strings[0]:= 'package '+ PackageName+';'; //ex. package com.example.appbuttondemo1;
    packList.SaveToFile(PathToJavaClass+DirectorySeparator+'App.java');
    MemoLog.Add('["App.java"  :: updated!]');
    ShowMessage('"App.java"  :: updated!');
  end;

  //upgrade "Controls.java"
  if  CheckGroupUpgradeTemplates.Checked[1] then
  begin
    if FileExistsUTF8(PathToJavaClass+DirectorySeparator+'Controls.java') then
    begin
      fileList.LoadFromFile(PathToJavaClass+DirectorySeparator+'Controls.java');
      fileList.SaveToFile(PathToJavaClass+DirectorySeparator+'Controls.java'+'.bak');
    end;
    packList.LoadFromFile(PathToJavaTemplates+DirectorySeparator+'Controls.java');
    packList.Strings[0]:= 'package '+ PackageName+';'; //ex. package com.example.appbuttondemo1;
    packList.SaveToFile(PathToJavaClass+DirectorySeparator+'Controls.java');

    if FileExistsUTF8(ProjectPath+DirectorySeparator+'lamwdesigner'+DirectorySeparator+'jForm.content') then
    begin
      packList.LoadFromFile(ProjectPath+DirectorySeparator+'lamwdesigner'+DirectorySeparator+'jForm.content');
      for i:= 0 to packList.Count-1 do
      begin
        if FileExistsUTF8(PathToJavaTemplates+DirectorySeparator+'lamwdesigner'+DirectorySeparator +packList.Strings[i]+'.create') then
        begin
          fileList.LoadFromFile(PathToJavaTemplates+DirectorySeparator+'lamwdesigner'+DirectorySeparator +packList.Strings[i]+'.create');
          strAux:= fileList.Text; //saved
          fileList.LoadFromFile(PathToJavaClass+DirectorySeparator+'Controls.java');
          fileList.Insert(fileList.Count-1, strAux);
          fileList.SaveToFile(PathToJavaClass+DirectorySeparator+'Controls.java');
        end;
      end;
    end;

    MemoLog.Add('["Controls.java"  :: updated!]');
    ShowMessage('"Controls.java"  :: updated!');
  end;
  packList.Free;
  fileList.Free;

  //upgrade [library] controls.lpr
  if  CheckGroupUpgradeTemplates.Checked[2] then
  begin
    SynMemo1.Clear;
    SynMemo2.Clear;
    if FileExistsUTF8(JNIProjectPath+PathDelim+'controls.lpr') then
    begin
      // from old "controls.lpr"
      SynMemo1.LoadFromFile(JNIProjectPath+PathDelim+'controls.lpr');
      i := 0;
      while i < SynMemo1.Count do
      begin
        if Copy(Trim(SynMemo1[i]) + ' ', 1, 5) = 'uses ' then
        begin
          repeat
            SynMemo2.Add(SynMemo1[i]);
            Inc(i);
          until (i >= SynMemo1.Count) or (Pos(';', SynMemo1[i - 1]) > 0);
          SynMemo2.Add('');
          Break;
        end else
          SynMemo2.Add(SynMemo1[i]);
        Inc(i);
      end;
    end else begin
      SynMemo2.Add('{hint: save all files to location: '+ProjectPath+DirectorySeparator+'jni}');
      SynMemo2.Add('library controls;  //by Lamw: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']');
      SynMemo2.Add(' ');
      SynMemo2.Add('{$mode delphi}');
      SynMemo2.Add(' ');
      SynMemo2.Add('uses');
      SynMemo2.Add('  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,');
      SynMemo2.Add('  Laz_And_Controls_Events, unit1;');
      SynMemo2.Add(' ');
    end;

    with TJavaParser.Create(PathToJavaClass+PathDelim+JavaClassName+'.java') do
    try
      SynMemo2.Add(GetPascalJNIInterfaceCode(PathToJavaTemplates+PathDelim+'ControlsEvents.txt'));
    finally
      Free
    end;

    // TODO: should be taken from old "controls.lpr" (SynMemo1)
    SynMemo2.Add('begin');
    SynMemo2.Add('  gApp:= jApp.Create(nil);{AndroidWidget.pas}');
    SynMemo2.Add('  gApp.Title:= ''My Android Bridges Library'';');
    SynMemo2.Add('  gjAppName:= '''+PackageName+''';{AndroidWidget.pas}');
    SynMemo2.Add('  gjClassName:= '''+ReplaceChar(PackageName, '.','/')+'/Controls'';{AndroidWidget.pas}');
    SynMemo2.Add('  gApp.AppName:=gjAppName;');
    SynMemo2.Add('  gApp.ClassName:=gjClassName;');
    SynMemo2.Add('  gApp.Initialize;');
    SynMemo2.Add('  gApp.CreateForm(TAndroidModule1, AndroidModule1);');
    SynMemo2.Add('end.');
    SynMemo2.Add('(*last [template] upgrade: '+DateTimeToStr(Now)+'*)');

    if FileExistsUTF8(JNIProjectPath+DirectorySeparator+'controls.lpr') then
    begin
      CopyFile(JNIProjectPath+PathDelim+'controls.lpr',
               JNIProjectPath+PathDelim+'controls.lpr.bak');
    end;
    SynMemo2.SaveToFile(JNIProjectPath+DirectorySeparator+'controls.lpr');

    if MessageDlg('Question', 'Do you wish to re-build ".so" library?', mtConfirmation,[mbYes, mbNo],0) = mrYes then
    begin
      MemoLog.Add('["controls.lpr"  :: update!--> ".so" :: rebuilding!]');
      RebuildLibrary;
    end;

  end;
end;

procedure TFormUpdateCodeTemplate.ComboBoxSelectProjectChange(Sender: TObject);
begin
  if ComboBoxSelectProject.ItemIndex > -1 then
  begin
    ProjectPath:= ComboBoxSelectProject.Text;
    JNIProjectPath:= ProjectPath + DirectorySeparator + 'jni';
    StatusBar1.SimpleText:= ProjectPath;
  end;
end;


procedure TFormUpdateCodeTemplate.FormCreate(Sender: TObject);
var
  AmwFile: string;
begin
  MemoLog:= TStringList.Create;

  JavaClassName:= 'Controls';

  SynMemo1:= TStringList.Create;
  SynMemo2:= TStringList.Create;

  AmwFile:= AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
  if FileExistsUTF8(AmwFile) then
  begin
      with TIniFile.Create(AmwFile) do  // Try to use settings from Android module wizard
      try
        ProjectPath:= ReadString('NewProject', 'FullProjectName', '');
        PathToWorkspace:=  ReadString('NewProject', 'PathToWorkspace', '');
        PathToJavaTemplates:= ReadString('NewProject', 'PathToJavaTemplates', '');
      finally
        Free
      end;
  end
end;

procedure TFormUpdateCodeTemplate.FormDestroy(Sender: TObject);
begin
  MemoLog.Free;
  SynMemo1.Free;
  SynMemo2.Free;
end;

procedure TFormUpdateCodeTemplate.FormShow(Sender: TObject);
var
  IDEProjectName: string;
  p: integer;
begin
  EditPathToWorkspace.Text:= PathToWorkspace; //by jmpessoa
  ComboBoxSelectProject.Items.Clear;  //by jmpessoa
  if PathToWorkspace <> '' then
  begin
     GetSubDirectories(PathToWorkspace, ComboBoxSelectProject.Items);
  end;

  IDEProjectName:='';
  p:= Pos(DirectorySeparator+'jni', LazarusIDE.ActiveProject.MainFile.Filename);
  if p > 0 then
    IDEProjectName:= Copy(LazarusIDE.ActiveProject.MainFile.Filename,1,p-1);


  if IDEProjectName <> '' then
  begin
      ComboBoxSelectProject.Text:= IDEProjectName;
      ProjectPath:= IDEProjectName;
      StatusBar1.SimpleText:= 'Recent: '+ IDEProjectName; //path to most recent project ...   by jmpessoa
      JNIProjectPath:= IDEProjectName + DirectorySeparator + 'jni';
  end;

  CheckGroupUpgradeTemplates.Checked[0]:= True;
  CheckGroupUpgradeTemplates.Checked[1]:= True;
  CheckGroupUpgradeTemplates.Checked[2]:= True;
end;

procedure TFormUpdateCodeTemplate.SpBPathToWorkspaceClick(Sender: TObject);
begin
    sddPath.Title:= 'Select Projects Workspace Path';
  if Trim(EditPathToWorkspace.Text) <> '' then
    if DirPathExists(EditPathToWorkspace.Text) then
      sddPath.InitialDir:= EditPathToWorkspace.Text;
  if sddPath.Execute then
  begin
     PathToWorkspace:= sddPath.FileName;
     EditPathToWorkspace.Text:= PathToWorkspace;
     ComboBoxSelectProject.Items.Clear;
     GetSubDirectories(PathToWorkspace, ComboBoxSelectProject.Items);
  end;
end;

procedure TFormUpdateCodeTemplate.SpBSelectProjectClick(Sender: TObject);
begin
  PathToWorkspace:= EditPathToWorkspace.Text;   //change Workspace...
  ComboBoxSelectProject.Items.Clear;
  GetSubDirectories(PathToWorkspace, ComboBoxSelectProject.Items);
  ComboBoxSelectProject.ItemIndex:= -1;
  ComboBoxSelectProject.Text:='';
end;

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

function ReplaceChar(query: string; oldchar, newchar: char):string;
begin
  if query <> '' then
  begin
     while Pos(oldchar,query) > 0 do query[pos(oldchar,query)]:= newchar;
     Result:= query;
  end;
end;

end.

