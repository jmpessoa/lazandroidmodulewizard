unit amw_ide_menu_items; //By Thierrydijoux!

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Dialogs, IDECommands, MenuIntf, Forms,
  uformsettingspaths, lazandroidtoolsexpert, ufrmEditor, ufrmCompCreate,
  uFormBuildFPCCross, uFormGetFPCSource, uimportjavastuff, uimportjavastuffchecked;

procedure StartPathTool(Sender: TObject);
procedure StartLateTool(Sender: TObject);   //By Thierrydijoux!
procedure StartResEditor(Sender: TObject);   //By Thierrydijoux!
procedure StartComponentCreate(Sender: TObject);
procedure StartPathToBuildFPCCross(Sender: TObject);
procedure StartFPCTrunkSource(Sender: TObject);
procedure StartEclipseToggleTooling(Sender: TObject);
procedure StartImportJavaStuff(Sender: TObject);

procedure Register;

implementation

uses LazIDEIntf, CompOptsIntf, IDEMsgIntf, IDEExternToolIntf, ProjectIntf,
  Controls, ApkBuild, IniFiles;


procedure StartFPCTrunkSource(Sender: TObject);
begin
  FormGetFPCSource:= TFormGetFPCSource.Create(Application);
  FormGetFPCSource.ShowModal;
end;

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

procedure StartResEditor(Sender: TObject);
var
  Project: TLazProject;
begin
  Project := LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
  begin
    // Call res editor
    frmEditor:= TfrmEditor.Create(etResString, nil);
    frmEditor.ShowModal;
  end
  else
    ShowMessage('The active project is not LAMW project!');
end;

procedure StartComponentCreate(Sender: TObject);
begin
  // Call componente create expert
  FrmCompCreate:= TFrmCompCreate.Create(Application);
  FrmCompCreate.Show;
end;

procedure StartPathToBuildFPCCross(Sender: TObject);
begin
  FormBuildFPCCross:= TFormBuildFPCCross.Create(Application);
  FormBuildFPCCross.ShowModal;
end;


procedure BuildAPKandRun(Sender: TObject);
var
  Project: TLazProject;
begin
  Project := LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
  try
    IDEMessagesWindow.BringToFront;
    with TApkBuilder.Create(Project) do
    try
      if LazarusIDE.DoBuildProject(crRun, []) <> mrOK then
        raise Exception.Create('Cannot build project');
      if BuildAPK then
        if InstallAPK then
          RunAPK;
    finally
      Free;
    end;
  except
    on e: Exception do
      IDEMessagesWindow.SelectMsgLine(
        IDEMessagesWindow.AddCustomMessage(mluFatal,
          '[' + e.ClassName + '] Failed: ' + e.Message, '', 0, 0, 'Exception'));
  end else
    ShowMessage('The active project is not LAMW project!');
end;

procedure StartImportJavaStuff(Sender: TObject);
var
  Project: TLazProject;
  pathTojavacode: string;
  pathToDrawable: string;
  pathToLayout: string;
  pathToAssets: string;
  pathToProject: string;
  package: string;
  list, listSaveTo: TStringList;
  p, i: integer;
  drawable_xx: string;
  saveCodeTo, saveLayoutTo: string;
  saveDrawableTo, saveAssetsTo: string;
begin
  Project := LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
  begin
     FormImportJavaStuff:= TFormImportJavaStuff.Create(Application);
     if FormImportJavaStuff.ShowModal = mrOK then
     begin

       package:= Project.CustomData.Values['Package'];
       p:= Pos(DirectorySeparator+'jni', Project.ProjectInfoFile);
       pathToProject:= Copy(Project.ProjectInfoFile, 1, p);

       pathTojavacode:= FormImportJavaStuff.EditImportCode.Text;
       pathToLayout:= FormImportJavaStuff.EditImportLayout.Text;
       pathToDrawable:= FormImportJavaStuff.EditImportResource.Text;
       pathToAssets:=  FormImportJavaStuff.EditImportAssets.Text;

       listSaveTo:= TStringList.Create;

       if pathTojavacode <> '' then
       begin
         list:= FindAllFiles(pathTojavacode, '*.java', False); //***

         saveCodeTo:= pathToProject+'src'+DirectorySeparator+StringReplace(package,'.',DirectorySeparator,[rfReplaceAll,rfIgnoreCase]);

         FormImportJavaStuffChecked:= TFormImportJavaStuffChecked.Create(Application);
         for i:=0 to list.Count-1 do
         begin
           FormImportJavaStuffChecked.CheckGroupImport.Items.Add(ExtractFileName(list.Strings[i]));
         end;

         if FormImportJavaStuffChecked.ShowModal = mrOK then
         begin
           for i:=0 to list.Count-1 do
           begin
              if FormImportJavaStuffChecked.CheckGroupImport.Checked[i] then
              begin
                listSaveTo.LoadFromFile(list.Strings[i]);
                listSaveTo.Strings[0]:= 'package '+package+';';
                listSaveTo.SaveToFile(saveCodeTo + DirectorySeparator+FormImportJavaStuffChecked.CheckGroupImport.Items.Strings[i]);
              end;
           end;
         end;
         list.Free;
       end;

       if pathToLayout <> '' then
       begin
         list:= FindAllFiles(pathToLayout, '*.xml', False);

         saveLayoutTo:=  pathToProject+'res'+DirectorySeparator+'layout';

         FormImportJavaStuffChecked:= TFormImportJavaStuffChecked.Create(Application);
         for i:=0 to list.Count-1 do
         begin
           FormImportJavaStuffChecked.CheckGroupImport.Items.Add(ExtractFileName(list.Strings[i]));
         end;

         if FormImportJavaStuffChecked.ShowModal = mrOK then
         begin
           for i:=0 to list.Count-1 do
           begin
              if FormImportJavaStuffChecked.CheckGroupImport.Checked[i] then
              begin
                listSaveTo.LoadFromFile(list.Strings[i]);
                listSaveTo.SaveToFile(saveLayoutTo + DirectorySeparator+FormImportJavaStuffChecked.CheckGroupImport.Items.Strings[i]);
              end;
           end;
         end;
         list.Free;
       end;

       listSaveTo.Free;

       if pathToDrawable <> '' then
       begin
         list:= FindAllFiles(pathToDrawable, '*.*', False);

         p:= Pos('drawable', pathToDrawable);
         drawable_xx:= Copy(pathToDrawable, p, Length(pathToDrawable));

         saveDrawableTo:=  pathToProject+'res'+DirectorySeparator+drawable_xx;

         FormImportJavaStuffChecked:= TFormImportJavaStuffChecked.Create(Application);
         for i:=0 to list.Count-1 do
         begin
           FormImportJavaStuffChecked.CheckGroupImport.Items.Add(ExtractFileName(list.Strings[i]));
         end;

         if FormImportJavaStuffChecked.ShowModal = mrOK then
         begin
           for i:=0 to list.Count-1 do
           begin
              if FormImportJavaStuffChecked.CheckGroupImport.Checked[i] then
              begin
                CopyFile(list.Strings[i], saveDrawableTo + DirectorySeparator+FormImportJavaStuffChecked.CheckGroupImport.Items.Strings[i]);
              end;
           end;
         end;
         list.Free;
       end;

       if pathToAssets <> '' then
       begin
         list:= FindAllFiles(pathToAssets, '*.*', False);

         saveAssetsTo:=  pathToProject+'assets'+DirectorySeparator;

         FormImportJavaStuffChecked:= TFormImportJavaStuffChecked.Create(Application);
         for i:=0 to list.Count-1 do
         begin
           FormImportJavaStuffChecked.CheckGroupImport.Items.Add(ExtractFileName(list.Strings[i]));
         end;

         if FormImportJavaStuffChecked.ShowModal = mrOK then
         begin
           for i:= 0 to list.Count-1 do
           begin
              if FormImportJavaStuffChecked.CheckGroupImport.Checked[i] then
              begin
                CopyFile(list.Strings[i], saveAssetsTo + DirectorySeparator+FormImportJavaStuffChecked.CheckGroupImport.Items.Strings[i]);
              end;
           end;
         end;
         list.Free;
       end;
       ShowMessage('Java Stuff Imported !');
     end
     else
        ShowMessage('Cancel');

  end else
    ShowMessage('Sorry, the active project is not a LAMW project!');
end;

procedure StartCanUpdateJavaTemplates(Sender: TObject);
var
  Project: TLazProject;
  dlgMessage: string;
  canUpdate: string;
  setting: string;
  fileName: string;
begin
  Project := LazarusIDE.ActiveProject;
  {if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
  begin}
    fileName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini';
    with TIniFile.Create(fileName) do
    try
      setting:= ReadString('NewProject','CanUpdateJavaTemplate', '');

      if setting = 'f' then
      begin
        canUpdate:='t';
        dlgMessage:= '[CanUpdateJavaTemplate]'+sLineBreak+'CanUpdateJavaTemplate = "False". Change it to "True" ?';
      end
      else
      begin
         canUpdate:='f';
         dlgMessage:= '[CanUpdateJavaTemplate]'+sLineBreak+'CanUpdateJavaTemplate = "True". Change it to "False" ?';
      end;

      case QuestionDlg ('CanUpdateJavaTemplate [Toogle]',dlgMessage,mtCustom,[mrYes,'Yes', mrNo,'No'],'') of
         mrNo: canUpdate:='';
      end;

      if canUpdate = 't' then
      begin
         WriteString('NewProject','CanUpdateJavaTemplate', 't');
      end;

      if canUpdate = 'f' then
      begin
         WriteString('NewProject','CanUpdateJavaTemplate', 'f');
      end;

    finally
       Free;
    end;
  {end else
    ShowMessage('Sorry, the active project is not a LAMW project!');}
end;

procedure StartEclipseToggleTooling(Sender: TObject);
var
  Project: TLazProject;
  p1: integer;
  PathToAndroidProject: string;
  SmallProjName: string;
  auxList: TStringList;
  eclipseTooling: string;
  dlgMessage: string;
begin
  Project := LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
  begin
    p1:= Pos(DirectorySeparator+'jni'+DirectorySeparator, Project.ProjectInfoFile);
    if p1 > 0 then
      PathToAndroidProject:= Trim(Copy(Project.ProjectInfoFile, 1, p1-1))
    else
    begin
      PathToAndroidProject:= ExtractFilePath(Project.ProjectInfoFile);
      PathToAndroidProject:= Copy(PathToAndroidProject,1, Length(PathToAndroidProject)-1);
    end;

    auxList:= TStringList.Create;
    auxList.StrictDelimiter:= True;
    auxList.Delimiter:= DirectorySeparator;
    auxList.DelimitedText:= TrimChar(PathToAndroidProject, DirectorySeparator);
    SmallProjName:=  auxList.Strings[auxList.Count-1];; //ex. "AppTest1"

    if FileExists(PathToAndroidProject+DirectorySeparator+'.classpath') then
      auxList.LoadFromFile(PathToAndroidProject+DirectorySeparator+'.classpath');

    eclipseTooling:='';

    if Pos('.adt.', auxList.Text) > 0 then
    begin
      eclipseTooling:='GoogleADT';
      dlgMessage:= '[Eclipse Compatibility]'+sLineBreak+'Converted project from "ADT/Google" to "Andmore/Neon" ?';
    end
    else
    begin
       eclipseTooling:='EclipseAndmore';
       dlgMessage:= '[Eclipse Compatibility]'+sLineBreak+'Convert project from "Andmore/Neon" to "ADT/Google" ?';
    end;

    case QuestionDlg ('Eclipse Project Compatibility [Toogle]',dlgMessage,mtCustom,[mrYes,'Yes', mrNo,'No'],'') of
       mrNo: eclipseTooling:='';
    end;

    ForceDirectory(PathToAndroidProject+DirectorySeparator+'.settings');

    auxList.Clear;
    if eclipseTooling = 'EclipseAndmore' then  //toggle to ADT
    begin
      auxList.Add('eclipse.preferences.version=1');
      auxList.Add('org.eclipse.jdt.core.compiler.codegen.targetPlatform=1.6');
      auxList.Add('org.eclipse.jdt.core.compiler.compliance=1.6');
      auxList.Add('org.eclipse.jdt.core.compiler.source=1.6');
      auxList.SaveToFile(PathToAndroidProject+DirectorySeparator+'.settings'+DirectorySeparator+'org.eclipse.jdt.core.prefs');
      auxList.Clear;
      auxList.Add('<?xml version="1.0" encoding="UTF-8"?>');
      auxList.Add('<classpath>');
      auxList.Add('<classpathentry kind="src" path="src"/>');
      auxList.Add('<classpathentry kind="src" path="gen"/>');
      auxList.Add('<classpathentry kind="con" path="com.android.ide.eclipse.adt.ANDROID_FRAMEWORK"/>');
      auxList.Add('<classpathentry exported="true" kind="con" path="com.android.ide.eclipse.adt.LIBRARIES"/>');
      auxList.Add('<classpathentry exported="true" kind="con" path="com.android.ide.eclipse.adt.DEPENDENCIES"/>');
      auxList.Add('<classpathentry kind="output" path="bin/classes"/>');
      auxList.Add('</classpath>');
      auxList.SaveToFile(PathToAndroidProject+DirectorySeparator+'.classpath');

      auxList.Clear;
      auxList.Add('<projectDescription>');
      auxList.Add('	<name>'+SmallProjName+'</name>');
      auxList.Add('	<comment></comment>');
      auxList.Add('	<projects>');
      auxList.Add('	</projects>');
      auxList.Add('	<buildSpec>');
      auxList.Add('		<buildCommand>');
      auxList.Add('			<name>com.android.ide.eclipse.adt.ResourceManagerBuilder</name>');
      auxList.Add('			<arguments>');
      auxList.Add('			</arguments>');
      auxList.Add('		</buildCommand>');
      auxList.Add('		<buildCommand>');
      auxList.Add('			<name>com.android.ide.eclipse.adt.PreCompilerBuilder</name>');
      auxList.Add('			<arguments>');
      auxList.Add('			</arguments>');
      auxList.Add('		</buildCommand>');
      auxList.Add('		<buildCommand>');
      auxList.Add('			<name>org.eclipse.jdt.core.javabuilder</name>');
      auxList.Add('			<arguments>');
      auxList.Add('			</arguments>');
      auxList.Add('		</buildCommand>');
      auxList.Add('		<buildCommand>');
      auxList.Add('			<name>com.android.ide.eclipse.adt.ApkBuilder</name>');
      auxList.Add('			<arguments>');
      auxList.Add('			</arguments>');
      auxList.Add(' 		</buildCommand>');
      auxList.Add('	</buildSpec>');
      auxList.Add('	<natures>');
      auxList.Add('		<nature>com.android.ide.eclipse.adt.AndroidNature</nature>');
      auxList.Add('		<nature>org.eclipse.jdt.core.javanature</nature>');
      auxList.Add('	</natures>');
      auxList.Add('</projectDescription>');
      auxList.SaveToFile(PathToAndroidProject+DirectorySeparator+'.project');
    end;

    //Eclipse Neon!
    if eclipseTooling = 'GoogleADT' then  //toggle to Andmore
    begin
      auxList.Add('eclipse.preferences.version=1');
      auxList.Add('org.eclipse.jdt.core.compiler.codegen.targetPlatform=1.7');
      auxList.Add('org.eclipse.jdt.core.compiler.compliance=1.7');
      auxList.Add('org.eclipse.jdt.core.compiler.source=1.7');
      auxList.SaveToFile(PathToAndroidProject+DirectorySeparator+'.settings'+DirectorySeparator+'org.eclipse.jdt.core.prefs');
      auxList.Clear;
      auxList.Add('<?xml version="1.0" encoding="UTF-8"?>');
      auxList.Add('<classpath>');
      auxList.Add('<classpathentry kind="src" path="src"/>');
      auxList.Add('<classpathentry kind="src" path="gen"/>');
      auxList.Add('<classpathentry kind="con" path="org.eclipse.andmore.ANDROID_FRAMEWORK"/>');
      auxList.Add('<classpathentry exported="true" kind="con" path="org.eclipse.andmore.LIBRARIES"/>');
      auxList.Add('<classpathentry exported="true" kind="con" path="org.eclipse.andmore.DEPENDENCIES"/>');
      auxList.Add('<classpathentry kind="output" path="bin/classes"/>');
      auxList.Add('</classpath>');
      auxList.SaveToFile(PathToAndroidProject+DirectorySeparator+'.classpath');

      auxList.Clear;
      auxList.Add('<projectDescription>');
      auxList.Add('	<name>'+SmallProjName+'</name>');
      auxList.Add('	<comment></comment>');
      auxList.Add('	<projects>');
      auxList.Add('	</projects>');
      auxList.Add('	<buildSpec>');
      auxList.Add('		<buildCommand>');
      auxList.Add('			<name>org.eclipse.andmore.ResourceManagerBuilder</name>');
      auxList.Add('			<arguments>');
      auxList.Add('			</arguments>');
      auxList.Add('		</buildCommand>');
      auxList.Add('		<buildCommand>');
      auxList.Add('			<name>org.eclipse.andmore.PreCompilerBuilder</name>');
      auxList.Add('			<arguments>');
      auxList.Add('			</arguments>');
      auxList.Add('		</buildCommand>');
      auxList.Add('		<buildCommand>');
      auxList.Add('			<name>org.eclipse.jdt.core.javabuilder</name>');
      auxList.Add('			<arguments>');
      auxList.Add('			</arguments>');
      auxList.Add('		</buildCommand>');
      auxList.Add('		<buildCommand>');
      auxList.Add('			<name>org.eclipse.andmore.ApkBuilder</name>');
      auxList.Add('			<arguments>');
      auxList.Add('			</arguments>');
      auxList.Add(' 		</buildCommand>');
      auxList.Add('	</buildSpec>');
      auxList.Add('	<natures>');
      auxList.Add('		<nature>org.eclipse.andmore.AndroidNature</nature>');
      auxList.Add('		<nature>org.eclipse.jdt.core.javanature</nature>');
      auxList.Add('	</natures>');
      auxList.Add('</projectDescription>');
      auxList.SaveToFile(PathToAndroidProject+DirectorySeparator+'.project');
    end;
    auxList.Free;

  end else
    ShowMessage('Sorry, the active project is not a LAMW project!');
end;

procedure Register;
Var
  ideMnuAMW: TIDEMenuSection;
  ideSubMnuAMW: TIDEMenuSection;
begin
  // Register main menu
  ideMnuAMW:= RegisterIDEMenuSection(mnuTools,'AMW');
  // Register submenu
  ideSubMnuAMW:= RegisterIDESubMenu(ideMnuAMW, 'AMW', '[Lamw] Android Module Wizard');
  // Adding first entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToolCmd', 'Paths Settings [Jdk, Sdk, Ndk, ...]', nil,@StartPathTool);
  // Adding second entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathLateCmd', 'LATE: Apk Expert Tools [Build, Install, ...]', nil,@StartLateTool);
  // Adding third entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathResEditorCmd', 'Resource Editor [strings.xml] ', nil,@StartResEditor);
   // Adding fourth entry
 //RegisterIDEMenuCommand(ideSubMnuAMW, 'PathUpdateCmd','Upgrade Code Templates [*.lpr, *.java]', nil,@StartUpdateCodeTemplateTool);
  // Adding 5a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathCompCreateCmd', 'New jComponent Create', nil,@StartComponentCreate);
  // Adding 6a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToBuildFPCCross', 'Build FPC Cross Android', nil,@StartPathToBuildFPCCross);
  // Adding 7a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToFPCTrunkSource', 'Get FPC Source [Trunk]', nil, @StartFPCTrunkSource);
  // Adding 8a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToEclipseToggleTooling', 'Eclipse Compatibility [ADT<->Andmore] ...', nil, @StartEclipseToggleTooling);
  // Adding 9a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToCanUpdateJavaTemplates', '[Configure] CanUpdateJavaTemplates ...', nil, @StartCanUpdateJavaTemplates);

  // Adding 10a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToImportJava', 'Use/Import Java Stuff...', nil, @StartImportJavaStuff);

  // And so on...
  RegisterIDEMenuCommand(itmRunBuilding, 'BuildAPKandRun', '[Lamw] Build Android Apk and Run',nil, @BuildAPKandRun);

  ApkBuild.RegisterExtToolParser;
end;

end.
