unit amw_ide_menu_items; //By Thierrydijoux!

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Dialogs, IDECommands, MenuIntf, Forms,
  uformsettingspaths, lazandroidtoolsexpert, ufrmEditor, ufrmCompCreate,
  uFormBuildFPCCross, uFormGetFPCSource, uimportjavastuff, uimportjavastuffchecked, uimportcstuff, process;

procedure StartPathTool(Sender: TObject);
procedure StartLateTool(Sender: TObject);   //By Thierrydijoux!
procedure StartResEditor(Sender: TObject);   //By Thierrydijoux!
procedure StartComponentCreate(Sender: TObject);
procedure StartPathToBuildFPCCross(Sender: TObject);
procedure StartFPCTrunkSource(Sender: TObject);
procedure StartEclipseToggleTooling(Sender: TObject);
procedure StartImportJavaStuff(Sender: TObject);
procedure StartImportCStuff(Sender: TObject);
procedure StartLogcatClear(Sender: TObject);
procedure StartLogcatDump(Sender: TObject);
//procedure StartLogcatRuntimeError(Sender: TObject);

procedure Register;

implementation

uses LazIDEIntf, LazFileUtils, CompOptsIntf, IDEMsgIntf, IDEExternToolIntf,
  ProjectIntf, MacroIntf, Controls, ApkBuild, IniFiles;


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


procedure BuildApkAndRun(Sender: TObject);
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

procedure SaveAndroidMK(pathToNdk: string; ndkPlataform: string; libChip: string; pathToProject: string; libname: string; listCFile: string);
var
  auxList: TStringList;
  AProcess: TProcess;
begin
  auxList:= TStringList.Create;
  auxList.Add('LOCAL_PATH:= $(call my-dir)');
  auxList.Add('');
  auxList.Add('include $(CLEAR_VARS)');
  auxList.Add('');
  auxList.Add('LOCAL_CFLAGS := -DANDROID_NDK \');
  auxList.Add('	-DFT2_BUILD_LIBRARY=1');
  auxList.Add('');
  auxList.Add('C_SRC_PATH:= ../');
  auxList.Add('');
  auxList.Add('LOCAL_SRC_FILES:= \');
  auxList.Add(listCFile);
  auxList.Add('LOCAL_MODULE:= '+libname);
  auxList.Add('');
  auxList.Add('include $(BUILD_SHARED_LIBRARY)');
  auxList.SaveToFile(pathToProject+'jni'+DirectorySeparator+'Android.mk');

  auxList.Clear;
  auxList.Add('APP_ABI := '+libChip);  //armeabi armeabi-v7a x86
  auxList.Add('APP_PLATFORM := '+ndkPlataform);  //android-13
  auxList.SaveToFile(pathToProject+'jni'+DirectorySeparator+'Application.mk');

  auxList.Clear;

  {$IFDEF Windows}
  auxList.Add('cd '+pathToProject);
  auxList.Add(pathToNdk+'ndk-build.cmd V=1 -B');
  auxList.SaveToFile(pathToProject+'lib'+libname+'-builder.bat');
  {$Endif}

  {$IFDEF Linux}
  auxList.Add('cd '+pathToProject);
  auxList.Add(pathToNdk+'ndk-build.cmd V=1 -B');
  auxList.SaveToFile(pathToProject+'lib'+libname+'-builder.sh');
  {$Endif}

  auxList.Free;
  try
    AProcess:= TProcess.Create(nil);
    AProcess.CurrentDirectory:= pathToProject;
    AProcess.Executable:= pathToNdk+'ndk-build.cmd';
    {$IFDEF Linux}
    AProcess.Executable:= pathToNdk+'ndk-build.cmd'; //need fix here ?
    {$Endif}
    {$IFDEF Darwin}
    AProcess.Executable:= pathToNdk+'ndk-build.cmd'; //need fix here ?
    {$Endif}
    (*
    ndk-build clean       --> clean all generated binaries.
    ndk-build NDK_DEBUG=1 --> generate debuggable native code.
    ndk-build NDK_DEBUG=0 --> force a release build
    ndk-build V=1 --> launch build, displaying build commands.
    ndk-build -B --> force a complete rebuild.
    ndk-build -B V=1 --> force a complete rebuild and display build commands.
    *)
    //AProcess.Parameters.Add('V=1');
    //AProcess.Parameters.Add('-B');
    AProcess.Parameters.Add('NDK_DEBUG=0');
    AProcess.Options:= AProcess.Options + [poWaitOnExit];
    AProcess.Execute;
  finally
    AProcess.Free;
  end;

end;

function GetNdkPlatform(const fileName: string): string;
var
  indexStr: string;
  index: integer;
begin
  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
      indexStr:= ReadString('NewProject','AndroidPlatform', '');
    finally
      Free;
    end;
  end;
  if indexStr <> '' then
  begin
     index:= StrToInt(indexStr);
     case index of
        0: Result:= 'android-13';
        1: Result:= 'android-14';
        2: Result:= 'android-15';
        3: Result:= 'android-16';
        4: Result:= 'android-17';
        5: Result:= 'android-18';
        6: Result:= 'android-19';
        7: Result:= 'android-20';
        8: Result:= 'android-21';
        9: Result:= 'android-22';
        10: Result:= 'android-23';
        11: Result:= 'android-24';
        12: Result:= 'android-25';
        13: Result:= 'android-26';
     end;
  end;
end;

function GetPathToLamwWizard(const fileName: string): string;
var
  k: integer;
  PathToJavaTemplates: string;
begin
  if FileExists(fileName) then
  begin
    with TIniFile.Create(fileName) do
    try
       PathToJavaTemplates := ReadString('NewProject','PathToJavaTemplates', '');
    finally
      Free;
    end;
  end;
  k:= LastPos(DirectorySeparator, PathToJavaTemplates);
  Result:= Copy(PathToJavaTemplates, 1, k-1);
end;

//function add(a:longint; b:longint):longint;cdecl;
function GetMethodName(methodHeader: string): string;
var
  p: integer;
  aux, firstPart: string;
begin
  p:= Pos('(', methodHeader);
  aux:= Copy(methodHeader, 1, p-1); //function add
  aux:= Trim(aux);
  firstPart:= SplitStr(aux, ' ');
  Result:= Trim(aux);
end;

procedure MakePascalInterface(pathToProject: string; fileName_h: string; libName: string);
var
  fileName_pp: string;
  pathToHFile, pathToH2PAS: string;
  AProcess: TProcess;
  auxList: TStringList;
  flag: boolean;
  i, p1, p2: integer;
  mylib: string;
  methodName: string;
  auxSignature: string;
  foundResult: string;
  fixedResult: string;
  len: integer;
  index_TYPE_line: integer;
  index_IFDEF_line: integer;

  new_TYPE: string;
begin
  mylib:= 'lib'+libName+'.so';

  pathToHFile:= pathToProject+libName;
  pathToH2PAS := '$Path($(CompPath))h2pas$(ExeExt)';
  IDEMacros.SubstituteMacros(pathToH2PAS);
  if not FileExists(pathToH2PAS) then
  begin
    ShowMessage(pathToH2PAS + ' not found!');
    Exit;
  end;
  try
    flag:= False;
    AProcess:= TProcess.Create(nil);
    AProcess.CurrentDirectory:= pathToHFile;
    AProcess.Executable:= pathToH2PAS;
    AProcess.Parameters.Add(fileName_h); // .h
    AProcess.Options:= AProcess.Options + [poWaitOnExit];
    AProcess.Execute;      //produce .pp
    flag:= True;
  finally
    AProcess.Free;
    if flag then
    begin
      fileName_pp:=StringReplace(fileName_h, '.h', '.pp', [rfIgnoreCase]);
      CopyFile(pathToHFile+DirectorySeparator+fileName_pp, pathToProject+'jni'+DirectorySeparator + fileName_pp);
      auxList:= TStringList.Create;
      auxList.LoadFromFile(pathToProject+'jni' + DirectorySeparator + fileName_pp);
      index_TYPE_line:= -1; //dummy
      index_IFDEF_line:= -1; //dummy;
      for i:= 2 to auxList.Count - 1 do  //escape 2 initial lines
      begin

         if Pos('Type', auxList.Strings[i]) > 0 then index_TYPE_line:= i;
         if Pos('{$IFDEF FPC}', auxList.Strings[i]) > 0 then index_IFDEF_line:= i;

         p1:= Pos('):^', auxList.Strings[i]);
         if  p1 > 0 then //try fix Function result ...
         begin
           if Pos('^^', auxList.Strings[i]) = 0 then  //try fix Function result only for one '^'
           begin
             foundResult:= Copy(auxList.Strings[i], p1+2, Length(auxList.Strings[i]));
             len:= 1;
             while foundResult[len] <> ';' do
             begin
               inc(len);
             end;
             foundResult:= Copy(foundResult, 1, len-1);   //ex. ^longint
             fixedResult:=  StringReplace(foundResult, '^' , 'P', [rfIgnoreCase]);  //ex. Plongint
             auxSignature:= auxList.Strings[i];
             auxSignature:= StringReplace(auxSignature, foundResult , fixedResult, [rfIgnoreCase]);
             auxList.Strings[i]:= auxSignature;

             new_TYPE:= fixedResult + ' = ' + foundResult+';';  //try add new type ...
             if Pos(new_TYPE, auxList.Text) = 0 then
             begin
                if (index_TYPE_line > 0) and (index_TYPE_line < auxList.Count) then
                begin
                   auxList.Strings[index_TYPE_line]:= auxList.Strings[index_TYPE_line]+' '+new_TYPE
                end
                else if ((index_IFDEF_line-1) > 0) and ((index_IFDEF_line-1) < auxList.Count) then
                begin
                   auxList.Strings[index_IFDEF_line-1]:= 'Type ' + new_TYPE;
                   index_TYPE_line:= index_IFDEF_line-1;
                end;
             end;

           end;
         end;

         if Pos('cdecl', auxList.Strings[i]) > 0 then
         begin
           methodName:= GetMethodName(auxList.Strings[i]);
           auxList.Strings[i]:= auxList.Strings[i]+ ' external '''+mylib+''' name '''+methodName+''';';
         end;

      end;
      auxList.SaveToFile(pathToProject+'jni'+DirectorySeparator + fileName_pp);
      auxList.Free;
    end;
  end;
end;

procedure StartLogcat(paramText: string);
var
   Project: TLazProject;
   Tool:TIDEExternalToolOptions;
   pathToADB: string;
   strExt: string;
   pathToSdk: string;
   packageName: string;
begin
  Project:= LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '' ) then
  begin
    pathToSdk:= Project.CustomData.Values['SdkPath'];
    packageName:= Project.CustomData.Values['Package'];
    pathToADB:= pathToSdk+'platform-tools';

    strExt:= '';
    {$IFDEF Windows}
      strExt:= '.exe';
    {$Endif}

    Tool := TIDEExternalToolOptions.Create;
    try
      Tool.Title := 'Running Extern [adb] Tool ... ';
      Tool.WorkingDirectory := pathToADB;
      Tool.Executable := pathToADB + DirectorySeparator+ 'adb'+strExt;
      Tool.CmdLineParams := paramText;
      Tool.Scanners.Add(SubToolDefault);
      if not RunExternalTool(Tool) then
        raise Exception.Create('Cannot Run Extern [adb] Tool!');
    finally
      Tool.Free;
    end;

  end else
    ShowMessage('Sorry, the active project is not a LAMW project!');

end;

(*
procedure StartLogcatSync(Sender: TObject);
begin
   StartLogcat('logcat');  //dump
end;
*)

procedure StartLogcatClear(Sender: TObject);
begin
   StartLogcat('logcat -c');  //clear
end;

procedure StartLogcatDump(Sender: TObject);
begin
   StartLogcat('logcat -d');  //dump
end;

(*
procedure StartLogcatRuntimeError(Sender: TObject);
begin
   StartLogcat('logcat AndroidRuntime:E *:S');  //error
end;
*)

procedure StartImportCStuff(Sender: TObject);
var
  Project: TLazProject;
  pathToImportCcode: string;
  pathToImportHCode: string;
  pathToProject: string;
  list, listSaveTo: TStringList;
  p, i, k: integer;
  saveCStuffTo: string;
  srcFile: string;
  SRC_FILES: TStringList;
  pathToNdk, ndkPlatform: string;
  myLibName: string;
  linkLibrariesPath: string;
  chip: string;
  libChip: string;
  pathToNewLib: string;
  aux: string;
  listBackup: TStringList;
  saveLibBackupTo: string;
begin
  Project:= LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '' ) then
  begin
     FormImportCStuff:= TFormImportCStuff.Create(Application);

     if FormImportCStuff.ShowModal = mrOK then
     begin
       linkLibrariesPath:='';                       //C:\adt32\ndk10e\platforms\android-15\arch-x86\usr\lib\
       aux:= Project.LazCompilerOptions.Libraries; //C:\adt32\ndk10e\platforms\android-15\arch-arm\usr\lib\; .....
       p:= Pos(';', aux);
       if p > 0 then
       begin
          linkLibrariesPath:= Trim(Copy(aux, 1, p-1));
          chip:= 'arm';
          if Pos('-x86', linkLibrariesPath) > 0 then chip:= 'x86';
          if chip = 'arm' then
          begin
             libChip:= 'armeabi';       //armeabi armeabi-v7a x86
             if Pos('-CpARMV7', Project.LazCompilerOptions.CustomOptions) > 0 then
               libChip:= 'armeabi-v7a'; //-Xd -CfSoft -CpARMV6 -XParm-linux-androideabi-
          end
          else
            libChip:= 'x86';
       end;

       pathToNdk:= Project.CustomData.Values['NdkPath'];  //<Item2 Name="NdkPath" Value="C:\adt32\ndk10e\"/>
       ndkPlatform:= GetNdkPlatform(AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');

       p:= Pos(DirectorySeparator+'jni', Project.ProjectInfoFile);
       pathToProject:= Copy(Project.ProjectInfoFile, 1, p);

       pathToImportCcode:= Trim(FormImportCStuff.EditImportC.Text);
       pathToImportHCode:= Trim(FormImportCStuff.EditImportH.Text);

       myLibName:=  LowerCase(Trim(FormImportCStuff.EditLibName.Text));
       if myLibName = '' then myLibName:= 'mycstuff1';

       saveCStuffTo:= pathToProject + myLibName;
       CreateDir(saveCStuffTo);

       saveLibBackupTo:= saveCStuffTo + DirectorySeparator + 'libsaved';
       CreateDir(saveLibBackupTo);

       pathToNewLib:= pathToProject+'libs'+ DirectorySeparator + libChip;
       listBackup:= FindAllFiles(pathToNewLib, '*.so', False);

       listSaveTo:= TStringList.Create;
       //------------------
       if pathToImportHcode <> '' then
       begin
          list:= FindAllFiles(pathToImportHcode, '*.h', False);
          if not FormImportCStuff.CheckBoxAllH.Checked then
          begin
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
                   srcFile:= FormImportJavaStuffChecked.CheckGroupImport.Items.Strings[i];
                   listSaveTo.SaveToFile(saveCStuffTo + DirectorySeparator+ srcFile);
                   MakePascalInterface(pathToProject , srcFile,  myLibName);
                 end;
              end;
            end
            else
            begin
              //ShowMessage('Cancel');
            end;
          end
          else
          begin
             for i:=0 to list.Count-1 do
             begin
               listSaveTo.LoadFromFile(list.Strings[i]);
               srcFile:= ExtractFileName(list.Strings[i]);
               listSaveTo.SaveToFile(saveCStuffTo + DirectorySeparator+ srcFile);
               MakePascalInterface(pathToProject, srcFile, myLibName);
             end;
          end;
          list.Free;
       end;
       //--------------------------
       if pathToImportCcode <> '' then
       begin
         list:= FindAllFiles(pathToImportCcode, '*.c', False);
         if not FormImportCStuff.CheckBoxAllC.Checked then
         begin   //ok, a bad code reuse ....
           FormImportJavaStuffChecked:= TFormImportJavaStuffChecked.Create(Application);

           for i:=0 to list.Count-1 do
           begin
             FormImportJavaStuffChecked.CheckGroupImport.Items.Add(ExtractFileName(list.Strings[i]));
           end;

           if FormImportJavaStuffChecked.ShowModal = mrOK then
           begin
             SRC_FILES:= TStringList.Create;
             for i:=0 to list.Count-1 do
             begin
                if FormImportJavaStuffChecked.CheckGroupImport.Checked[i] then
                begin
                  listSaveTo.LoadFromFile(list.Strings[i]);
                  srcFile:= FormImportJavaStuffChecked.CheckGroupImport.Items.Strings[i];
                  listSaveTo.SaveToFile(saveCStuffTo + DirectorySeparator+ srcFile);
                  SRC_FILES.Add('$(C_SRC_PATH)'+myLibName+'/'+srcFile+' \');
                end;
             end;
             if SRC_FILES.Count > 0 then
             begin
                SRC_FILES.Strings[SRC_FILES.Count-1]:= '$(C_SRC_PATH)'+myLibName+'/'+srcFile;
                if listBackup.Count > 0 then
                begin
                  //save
                  for k:= 0 to listBackup.Count-1 do
                  begin
                     aux:= ExtractFileName(listBackup.Strings[k]);
                     CopyFile(listBackup.Strings[k], saveLibBackupTo + DirectorySeparator + aux);
                  end;
                  SaveAndroidMK(pathToNdk, ndkPlatform, libChip, pathToProject, myLibName, SRC_FILES.Text);
                  //restore
                  for k:= 0 to listBackup.Count-1 do
                  begin
                     aux:= ExtractFileName(listBackup.Strings[k]);
                     if aux <> ('lib'+myLibName+'.so') then
                        CopyFile(saveLibBackupTo+DirectorySeparator+aux, pathToNewLib+DirectorySeparator+aux);
                  end;
                end;
             end;
             SRC_FILES.Free;
           end
           else
           begin
             //ShowMessage('Cancel');
           end;
         end
         else
         begin
            SRC_FILES:= TStringList.Create;
            for i:=0 to list.Count-1 do
            begin
              listSaveTo.LoadFromFile(list.Strings[i]);
              srcFile:= ExtractFileName(list.Strings[i]);
              listSaveTo.SaveToFile(saveCStuffTo + DirectorySeparator+ srcFile);
              if i = list.Count-1 then
                 SRC_FILES.Add('$(C_SRC_PATH)'+myLibName+'/'+srcFile)
              else
                 SRC_FILES.Add('$(C_SRC_PATH)'+myLibName+'/'+srcFile+' \');
            end;
            if SRC_FILES.Count > 0 then
            begin
              //save
              for k:= 0 to listBackup.Count-1 do
              begin
                 aux:= ExtractFileName(listBackup.Strings[k]);
                 CopyFile(listBackup.Strings[k], saveLibBackupTo + DirectorySeparator + aux);
              end;
              SaveAndroidMK(pathToNdk, ndkPlatform, libChip, pathToProject, myLibName, SRC_FILES.Text);
              //restore
              for k:= 0 to listBackup.Count-1 do
              begin
                 aux:= ExtractFileName(listBackup.Strings[k]);
                 if aux <> ('lib'+myLibName+'.so') then
                    CopyFile(saveLibBackupTo+DirectorySeparator+aux, pathToNewLib+DirectorySeparator+aux);
              end;
            end;
            SRC_FILES.Free;
         end;
         ShowMessage('C Stuff Imported ! (lib'+myLibName+'.so)');
         if FileExists(pathToNewLib + DirectorySeparator + 'lib'+myLibName+'.so') then
         begin
            if linkLibrariesPath <> '' then
               CopyFile(pathToNewLib + DirectorySeparator + 'lib'+myLibName+'.so',linkLibrariesPath+'lib'+myLibName+'.so');
         end;
         list.Free;
       end;
       listSaveTo.Free;
       listBackup.Free;
     end
     else
       ShowMessage('Cancel');
  end else
    ShowMessage('Sorry, the active project is not a LAMW project!');
end;

procedure StartImportJavaStuff(Sender: TObject);
var
  Project: TLazProject;
  pathTojavacode: string;
  pathToDrawable: string;
  pathToLayout: string;
  pathToAssets: string;
  pathToJarLibs: string;
  pathToProject: string;
  package: string;
  list, listSaveTo: TStringList;
  p, i: integer;
  drawable_xx: string;
  saveCodeTo, saveLayoutTo: string;
  saveDrawableTo, saveAssetsTo, saveJarLibsTo: string;
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
       pathToJarLibs:=  FormImportJavaStuff.EditImportJarLibs.Text;;

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

       if pathToJarLibs <> '' then
       begin
         list:= FindAllFiles(pathToJarLibs, '*.*', False);

         saveJarLibsTo:=  pathToProject+'libs'+DirectorySeparator;

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
                CopyFile(list.Strings[i], saveJarLIbsTo + DirectorySeparator+FormImportJavaStuffChecked.CheckGroupImport.Items.Strings[i]);
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

    CreateDir(PathToAndroidProject+DirectorySeparator+'.settings');

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
  ideSubMnuLog: TIDEMenuSection;
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

  // Adding 11a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToImportCCode', 'Use/Import C Stuff...', nil, @StartImportCStuff);

  // And so on...

  // Register submenu    StartLogcatRuntimeError
  ideSubMnuLog:= RegisterIDESubMenu(ideSubMnuAMW, 'Logcatch', 'ADB Logcat');
  // Adding first entry

  RegisterIDEMenuCommand(ideSubMnuLog, 'PathToLogcat', 'Logcat -d [dump]', nil, @StartLogcatDump);
  //RegisterIDEMenuCommand(ideSubMnuLog, 'PathToLogcat', 'Logcat Runtime:E [error]', nil, @StartLogcatRuntimeError);
  //RegisterIDEMenuCommand(ideSubMnuLog, 'PathToLogcat', 'Logcat [sync]', nil, @StartLogcatSync);
  RegisterIDEMenuCommand(ideSubMnuLog, 'PathToLogcat', 'Logcat -c [clear]', nil, @StartLogcatClear);
  //Run
  RegisterIDEMenuCommand(itmRunBuilding, 'BuildApkAndRun', '[Lamw] Build Android Apk and Run', nil, @BuildApkAndRun);

  ApkBuild.RegisterExtToolParser;
end;

end.
