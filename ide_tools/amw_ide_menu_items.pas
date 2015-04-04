unit amw_ide_menu_items; //By Thierrydijoux!

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, IDECommands, MenuIntf, Forms,
  uformsettingspaths, lazandroidtoolsexpert, uformupdatecodetemplate, ufrmEditor, ufrmCompCreate;

procedure StartPathTool(Sender: TObject);
procedure StartLateTool(Sender: TObject);   //By Thierrydijoux!
procedure StartUpdateCodeTemplateTool(Sender: TObject);
procedure StartResEditor(Sender: TObject);   //By Thierrydijoux!
procedure StartComponentCreate(Sender: TObject);

procedure Register;

implementation

uses LazIDEIntf, CompOptsIntf, IDEMsgIntf, IDEExternToolIntf, ProjectIntf,
  Controls, ApkBuild;

procedure StartPathTool(Sender: TObject);  //by jmpessoa
begin
  // Call path tool Code
  FormSettingsPaths:=  TFormSettingsPaths.Create(Application);
  FormSettingsPaths.ShowModal;
end;

procedure StartLateTool(Sender: TObject);
begin
  // Call Late code
  frmLazAndroidToolsExpert:= TfrmLazAndroidToolsExpert.Create(Application);
  frmLazAndroidToolsExpert.ShowModal;
end;

procedure StartUpdateCodeTemplateTool(Sender: TObject);  //by jmpessoa
begin
  //Call Update code
  FormUpdateCodeTemplate:= TFormUpdateCodeTemplate.Create(Application);
  FormUpdateCodeTemplate.ShowModal;
end;

procedure StartResEditor(Sender: TObject);
begin
  // Call res editor
  frmEditor:= TfrmEditor.Create(etResString, nil);
  frmEditor.ShowModal;
end;

procedure StartComponentCreate(Sender: TObject);
begin
  // Call componente create expert
  FrmCompCreate:= TFrmCompCreate.Create(Application);
  FrmCompCreate.ShowModal;
     //ShowMessage('Component create assistencie...');	
end;

procedure BuildAPKandRun(Sender: TObject);
var
  Project: TLazProject;
begin
  Project := LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
  try
    IDEMessagesWindow.BringToFront;
    if LazarusIDE.DoBuildProject(crRun, [pbfOnlyIfNeeded]) <> mrOK then
      raise Exception.Create('Cannot build project');
    with TApkBuilder.Create(Project) do
    try
      if BuildAPK then
        if InstallAPK then
          RunAPK;
    finally
      Free;
    end;
  except
    on e: Exception do
      IDEMessagesWindow.AddCustomMessage(mluFatal, '[' + e.ClassName + '] Failed: ' + e.Message, '', 0);
  end else
    ShowMessage('The active project is not LAMW project!');
end;

procedure Register;
Var
  ideMnuAMW: TIDEMenuSection;
  ideSubMnuAMW: TIDEMenuSection;
begin
  // Register main menu
  ideMnuAMW:= RegisterIDEMenuSection(mnuTools,'AMW');
  // Register submenu
  ideSubMnuAMW:= RegisterIDESubMenu(ideMnuAMW, 'AMW', 'Android Module Wizard');


  // Adding first entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathLateCmd', 'LATE: "Apk" Expert Tools [Build, Install, ...]', nil,@StartLateTool);
  // Adding second entry
   RegisterIDEMenuCommand(ideSubMnuAMW, 'PathResEditorCmd', 'Resource Editor [strings.xml] ', nil,@StartResEditor);
   // Adding third entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathUpdateCmd','Upgrade Code Templates [*.lpr, *.java]', nil,@StartUpdateCodeTemplateTool);
  // Adding fourth entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToolCmd', 'Path Settings [Jdk, Sdk, Ndk, ...]', nil,@StartPathTool);
  //Adding 5a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathCompCreateCmd', 'New jComponent [Create]', nil,@StartComponentCreate);
  // And so on...

  RegisterIDEMenuCommand(itmRunBuilding, 'BuildAPKandRun', 'Build APK and Run',
    nil, @BuildAPKandRun);
end;

end.
