unit amw_ide_menu_items; //By Thierrydijoux!

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Dialogs, IDECommands, MenuIntf, Forms,
  uformsettingspaths{, lazandroidtoolsexpert}, ufrmEditor, ufrmCompCreate,
  uFormBuildFPCCross, uFormGetFPCSource, uimportjavastuff, uimportjavastuffchecked,
  uimportcstuff, process, Laz2_DOM, laz2_XMLRead, uformimportlamwstuff, unitformimportpicture;

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
  ProjectIntf, MacroIntf, Controls, ApkBuild, IniFiles, LCLType;

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

procedure StartExportLibToPath(Sender: TObject);
var
  Project: TLazProject;
  linkLibrariesPath, aux: string;
  chip, libChip: string;
  p: integer;
  pathToProject, pathToLib: string;
  pathToAndroidStudioJniLib: string;
begin
  Project:= LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '' ) then
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
     p:= Pos(DirectorySeparator+'jni', Project.ProjectInfoFile);
     pathToProject:= Copy(Project.ProjectInfoFile, 1, p);
     pathToLib:= pathToProject+'libs'+ DirectorySeparator + libChip;
     pathToAndroidStudioJniLib:= pathToProject+'build'+DirectorySeparator+
                                 'intermediates'+DirectorySeparator+
                                 'jniLibs'+DirectorySeparator+
                                 'debug'+DirectorySeparator+libChip;

     if ForceDirectories(pathToAndroidStudioJniLib) then
     begin
        if FileExists(pathToLib+DirectorySeparator+'libcontrols.so') then
        begin
          CopyFile(pathToLib+DirectorySeparator+'libcontrols.so',
                   pathToAndroidStudioJniLib+DirectorySeparator+'libcontrols.so');
          //IDEMessagesWindow.BringToFront;
          IDEMessagesWindow.SelectMsgLine(
                   IDEMessagesWindow.AddCustomMessage(mluVerbose,
                                                      'Exported "libcontrols.so" to: '+pathToAndroidStudioJniLib,
                                                      '', 0, 0, ''));
        end;
     end;

  end
  else
    ShowMessage('The active project is not a LAMW project!');
end;

procedure StartLateTool(Sender: TObject);
begin
  // Call Late code
 // frmLazAndroidToolsExpert:= TfrmLazAndroidToolsExpert.Create(Application);
  //frmLazAndroidToolsExpert.ShowModal;
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

  {$IFDEF unix}
  auxList.Add('cd '+pathToProject);
  auxList.Add(pathToNdk+'ndk-build V=1 -B');
  auxList.SaveToFile(pathToProject+'lib'+libname+'-builder.sh');
  {$Endif}

  auxList.Free;
  try
    AProcess:= TProcess.Create(nil);
    AProcess.CurrentDirectory:= pathToProject;
    AProcess.Executable:= pathToNdk+'ndk-build.cmd';

    {$IFDEF UNIX}
    AProcess.Executable:= pathToNdk+'ndk-build'; //need fix here ?
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
        14: Result:= 'android-27';
        15: Result:= 'android-28';
     end;
  end;
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
  i, p1: integer;
  mylib, strAux: string;
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

         if Pos('{$include ', auxList.Strings[i]) > 0 then
         begin
           strAux:= auxList.Strings[i];
           auxList.Strings[i]:= StringReplace(strAux, '{$include ' , '//include ', [rfIgnoreCase]);
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

procedure StartLogcatClear(Sender: TObject);
begin
   StartLogcat('logcat -c');  //clear
end;

procedure StartLogcatDump(Sender: TObject);
begin
   StartLogcat('logcat -d');  //dump
end;


function GetTargetFromManifest(pathToProject: string): string;
var
  ManifestXML: TXMLDocument;
  n: TDOMNode;
begin
  Result := '';
  if not FileExists(pathToProject + 'AndroidManifest.xml') then Exit;
  try
    ReadXMLFile(ManifestXML, pathToProject + 'AndroidManifest.xml');
    try
      n := ManifestXML.DocumentElement.FindNode('uses-sdk');
      if not (n is TDOMElement) then Exit;
      Result := TDOMElement(n).AttribStrings['android:targetSdkVersion'];
    finally
      ManifestXML.Free
    end;
  except
    Exit;
  end;
end;

procedure ConvertToAppCompat(paramTheme: string);
var
   Project: TLazProject;
   p: integer;
   packageName: string;
   pathToJavaTemplates: string;
   fileName: string;
   pathToProject: string;
   pathToJavaSrc: string;
   list: TStringList;
   isOldTheme: boolean;
   targetApi, tmpStr: string;
   gradlePath, gradleVersion: string;
begin
  Project:= LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] = 'GUI' ) then
  begin

    if  Project.CustomData.Values['Theme'] =  paramTheme then
    begin
       ShowMessage('Warning: this theme ['+paramTheme+'] is already being used...');
       Exit;
    end;

    isOldTheme:= True;
    if Pos('AppCompat', Project.CustomData.Values['Theme']) > 0 then
      isOldTheme:= False;

    Project.CustomData.Values['Theme']:= paramTheme;
    Project.CustomData.Values['BuildSystem']:= 'Gradle';
    //Project.CustomData.Values['LamwVersion']:= '0.8';

    packageName:= Project.CustomData.Values['Package'];

    p:= Pos(DirectorySeparator+'jni', Project.ProjectInfoFile);
    pathToProject:= Copy(Project.ProjectInfoFile, 1, p);

    fileName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini';
    with TIniFile.Create(fileName) do
    try
      pathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');
      if pathToJavaTemplates <> '' then
      begin
        pathToJavaSrc:= pathToProject+'src'+DirectorySeparator+StringReplace(packageName,'.',DirectorySeparator,[rfReplaceAll,rfIgnoreCase]);

        list:= TStringList.Create;
        list.LoadFromFile(pathToJavaTemplates+DirectorySeparator + 'lamwdesigner'+DirectorySeparator+'support'+DirectorySeparator+'App.java');
        list.Strings[0]:= 'package '+packageName+';';
        list.SaveToFile(pathToJavaSrc+DirectorySeparator+'App.java');

        list.Clear;
        list.LoadFromFile(pathToJavaTemplates+DirectorySeparator + 'lamwdesigner'+DirectorySeparator+'support'+DirectorySeparator+'jCommons.java');
        list.Strings[0]:= 'package '+packageName+';';
        list.SaveToFile(pathToJavaSrc+DirectorySeparator+'jCommons.java');

        list.Clear;
        list.LoadFromFile(pathToJavaTemplates+DirectorySeparator + 'values'+DirectorySeparator+paramTheme+'.xml');
        list.SaveToFile(pathToProject+'res'+DirectorySeparator+'values'+DirectorySeparator+'styles.xml');

        list.Clear;
        if not FileExists(pathToProject+'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml') then
        begin
          list.LoadFromFile(pathToJavaTemplates+DirectorySeparator + 'values'+DirectorySeparator+'colors.xml');
          list.SaveToFile(pathToProject+'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml');
        end;

        if isOldTheme then
        begin
          if FileExists(pathToProject+'res'+DirectorySeparator+'values-v21'+DirectorySeparator+'styles.xml') then
          begin
             DeleteFile(pathToProject+'res'+DirectorySeparator+'values-v21'+DirectorySeparator+'styles.xml')
          end;

          targetApi:= Trim(GetTargetFromManifest(pathToProject));
          gradlePath:= ReadString('NewProject','PathToGradle', '');
          if gradlePath <> '' then     // C:\adt32\gradle-4.4.1
          begin
             p:= Pos('dle-', gradlePath);
             gradleVersion:=  Copy(gradlePath, p+4, MaxInt);
          end;

          list.Clear;
          list.LoadFromFile(pathToJavaTemplates+DirectorySeparator + 'lamwdesigner'+DirectorySeparator+'support'+DirectorySeparator+'buildgradle.txt');

          if StrToInt(targetApi) < 25 then targetApi:= '25';
          //if StrToInt(targetApi) > 25 then targetApi:= '25';

          tmpStr:= StringReplace(list.Text,'#sdkapi', targetApi, [rfReplaceAll]);
          list.Text:= tmpStr;
          tmpStr:= StringReplace(list.Text,'#package', packageName, [rfReplaceAll]);
          list.Text:= tmpStr;
          tmpStr:= StringReplace(list.Text,'#localgradle', gradleVersion, [rfReplaceAll]);
          list.Text:= tmpStr;
          list.SaveToFile(pathToProject+'build.gradle');

          ShowMessage('Welcome to Material Design!!' +sLineBreak + 'Welcome to "Android Bridges Support" components!!!');
        end;
        list.Free;

      end;
    finally
      Free;
    end;

  end else
    ShowMessage('Sorry, the active Project is not a "GUI" LAMW Project!');
end;

procedure StartAppCompatDarkActionBar(Sender: TObject);
var
  userReturn, BoxStyle: Integer;
begin
  BoxStyle := MB_ICONQUESTION + MB_OKCANCEL; //MB_YESNO;   //MB_CANCELTRYCONTINUE
  userReturn := Application.MessageBox('Converting the Project [structure] to AppCompat'+sLineBreak+'Did you remember to make a copy/backup?', 'Warning: Backup it!', BoxStyle);
  if userReturn = IDOK then
    ConvertToAppCompat('AppCompat.Light.DarkActionBar');
end;

procedure StartAppCompatNoActionBar(Sender: TObject);
var
  userReturn, BoxStyle: Integer;
begin
  BoxStyle := MB_ICONQUESTION + MB_OKCANCEL;
  userReturn := Application.MessageBox('Converting the Project [structure] to AppCompat'+sLineBreak+'Did you remember to make a copy/backup?', 'Warning: Backup it!', BoxStyle);
  if userReturn = IDOK then
     ConvertToAppCompat('AppCompat.Light.NoActionBar');
end;

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
       ndkPlatform:= GetNdkPlatform(AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');

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
       pathToAssets:= FormImportJavaStuff.EditImportAssets.Text;
       pathToJarLibs:= FormImportJavaStuff.EditImportJarLibs.Text;;

       listSaveTo:= TStringList.Create;

       if pathTojavacode <> '' then
       begin
         list:= FindAllFiles(pathTojavacode, '*.java', False);

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

       ShowMessage('Sucess!! Java Stuff Imported !');
     end
     else
        ShowMessage('Cancel');

  end else
    ShowMessage('Sorry, the active project is not a LAMW project!');
end;

function ReplaceChar(const query: string; oldchar, newchar: char): string;
var
  i: Integer;
begin
  Result := query;
  for i := 1 to Length(Result) do
    if Result[i] = oldchar then Result[i] := newchar;
end;

procedure StartImportPictureStuff(Sender: TObject);
var
  Project: TLazProject;
  FormImportPicture: TFormImportPicture;
  i, count, p: integer;
  hasCopied: boolean;
  pathToProject, importedFile, checkedTarget, strTemp, imageExt: string;
begin
  Project:= LazarusIDE.ActiveProject;

  if not Assigned(Project) then Exit;

  if Project.CustomData.Values['LAMW'] = 'GUI' then
  begin
     FormImportPicture:= TFormImportPicture.Create(Application);
     if FormImportPicture.ShowModal = mrOK then
     begin
       importedFile:= ExtractFileName(FormImportPicture.PictureFile);
       if importedFile <> '' then
       begin
         p:= Pos(DirectorySeparator+'jni', Project.ProjectInfoFile);
         pathToProject:= Copy(Project.ProjectInfoFile, 1, p);  //C:\lamw\workspace\AppLAMWProject2\

         importedFile:= Lowercase(ReplaceChar(importedFile, '-', '_'));
         importedFile:= ReplaceChar(importedFile, ' ', '_');

         if not (importedFile[1] in ['a'..'z', 'A'..'Z']) then
         begin
           importedFile:= 'im_'+ importedFile;  //the file name can not be init by number...
         end;

         if Length(importedFile) > 25 then
         begin
           p:= LastDelimiter('.', importedFile);
           imageExt:= Copy(importedFile, p, MaxInt);
           strTemp:= Copy(importedFile, 1, p-1);
           importedFile:= Copy(strTemp, 1, 21) + imageExt;
         end;

         hasCopied:= False;
         if FormImportPicture.CheckGroupTarget.Checked[0] then  //assets
         begin
            CopyFile(FormImportPicture.PictureFile, pathToProject+'assets'+PathDelim+importedFile);
            hasCopied:= True;
         end;

         ForceDirectories(pathToProject+'res'+PathDelim+'drawable');

         count:= FormImportPicture.CheckGroupTarget.Items.Count;
         for i:= 1 to count-1 do
         begin
            if FormImportPicture.CheckGroupTarget.Checked[i] then
            begin
               checkedTarget:= FormImportPicture.CheckGroupTarget.Items.Strings[i];
               CopyFile(FormImportPicture.PictureFile, pathToProject+'res'+PathDelim+checkedTarget+PathDelim+importedFile);
               hasCopied:= True;
            end;
         end;

         if hasCopied then
           ShowMessage('Success! "'+importedFile+'" copied/imported to targets folders...')
         else
           ShowMessage('Fail! None target folder  checked...')

       end;
     end;
  end;
end;

procedure StartImportLAMWStuff(Sender: TObject);
var
  Project: TLazProject;
  listProject: TStringList;
  listUnit: TStringList;
  listComponent: TStringList;
  listTemp: TStringList;
  listProjComp, unitsList: TStringList;
  fileName: string;
  pathToProject: string;
  p, i, k: integer;
  compName: string;
  pathToJavaTemplates: string;
  package, pathToJavasSrc: string;
  fullPathToUnitTarget, fullPathToUnitSourceLFM: string;
  listIndex: integer;
  tempStr, targetFormName, sourceFormName: string;
begin
  listProject:= TStringList.Create;
  listUnit:= TStringList.Create;
  listComponent:= TStringList.Create;
  listTemp:= TStringList.Create;

  listProjComp:= TStringList.Create;
  listProjComp.Sorted:= True;;
  listProjComp.Duplicates:= dupIgnore;

  listComponent.Sorted:= True;;
  listComponent.Duplicates:= dupIgnore;
  listComponent.StrictDelimiter:= True;
  listComponent.Delimiter:= ';';

  Project:= LazarusIDE.ActiveProject;
  if not Assigned(Project) then Exit;

  if Project.CustomData.Values['LAMW'] = 'GUI' then
  begin

      package:= Project.CustomData.Values['Package'];

      p:= Pos(DirectorySeparator+'jni', Project.ProjectInfoFile);
      pathToProject:= Copy(Project.ProjectInfoFile, 1, p);
      pathToJavasSrc:= pathToProject+'src'+DirectorySeparator+StringReplace(package,'.',DirectorySeparator,[rfReplaceAll,rfIgnoreCase]);

      pathToProject:= Copy(Project.ProjectInfoFile, 1, p+3);

      fileName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini';
      with TIniFile.Create(fileName) do
      try
        pathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');
      finally
        Free;
      end;

     FormImportLAMWStuff:= TFormImportLAMWStuff.Create(Application);

     unitsList:= FindAllFiles(pathToProject, '*.lfm', False);
     listProjComp.Clear;
     for k:= 0 to unitsList.Count-1 do
     begin
       listTemp.LoadFromFile(unitsList.Strings[k]);
       p:= Pos(':', listTemp.Strings[0]);  //object AndroidModule1: TAndroidModule1
       listProjComp.Add(Trim(Copy(listTemp.Strings[0], p+3, MaxInt))); //AndroidModule1
       FormImportLAMWStuff.ListBoxTarget.Items.Add(ExtractFileName(ChangeFileExt(unitsList.Strings[k], '')));
     end;

     if FormImportLAMWStuff.ShowModal = mrOK then
     begin

         listIndex:= FormImportLAMWStuff.ListBoxTarget.ItemIndex;
         if  listIndex >= 0 then
         begin
            targetFormName:= listProjComp.Strings[listIndex]; //AndroidModule1 listIndex = selected unit to be replaced...
            fullPathToUnitTarget:=  unitsList.Strings[listIndex]; //.lfm
            fullPathToUnitTarget:= ChangeFileExt(fullPathToUnitTarget, '.pas');
            fullPathToUnitSourceLFM:= FormImportLAMWStuff.EditSource.Text;
            if fullPathToUnitSourceLFM <> '' then
            begin
              if FileExists(fullPathToUnitSourceLFM) then
              begin
                listUnit.LoadFromFile(fullPathToUnitSourceLFM);

                p:= Pos(':', listUnit.Strings[0]);   //object AndroidModule1: TAndroidModule1
                sourceFormName:=  Trim(Copy(listUnit.Strings[0], p+3, MaxInt)); //AndroidModule1
                for i:= 1 to listUnit.Count-1 do
                begin
                  if Pos('object ', listUnit.Strings[i]) > 0 then
                  begin
                     p:= Pos(':', listUnit.Strings[i]);
                     compName:= Trim(Copy(listUnit.Strings[i], p+2, MaxInt));
                     if FileExists(pathToJavaTemplates+PathDelim+'smartdesigner'+PathDelim+compName+'.java')  then
                     begin
                       listComponent.Add(compName);
                     end;
                  end;
                end;
              end;
            end else ShowMessage('Fail. None [target] LAMW Form were selected...');
         end else ShowMessage('Fail. None [candidate] Unit were selected...');

     end;
     unitsList.Free;

  end;

  if listComponent.Count > 0 then
  begin

    for i:= 0 to listComponent.Count-1 do
    begin
       if not FileExists(pathToJavasSrc+PathDelim+listComponent.Strings[i]+'.java') then
       begin
          listTemp.LoadFromFile(pathToJavaTemplates+PathDelim+'smartdesigner'+PathDelim+listComponent.Strings[i]+'.java');
          listTemp.Strings[0]:= 'package '+ package +';';
          listTemp.SaveToFile(pathToJavasSrc+PathDelim+listComponent.Strings[i]+'.java');
       end;
    end;

    listTemp.Clear;
    listTemp.LoadFromFile(fullPathToUnitSourceLFM);
    tempStr:=StringReplace(listTemp.Text, sourceFormName, targetFormName, [rfReplaceAll, rfIgnoreCase]);
    listTemp.Text:= tempStr;
    ShowMessage(fullPathToUnitTarget);
    listTemp.SaveToFile(ChangeFileExt(fullPathToUnitTarget, '.lfm'));

    listTemp.Clear;
    listTemp.LoadFromFile(ChangeFileExt(fullPathToUnitSourceLFM, '.pas'));
    tempStr:=StringReplace(listTemp.Text, sourceFormName, targetFormName, [rfReplaceAll, rfIgnoreCase]);
    listTemp.Text:= tempStr;
    listTemp.Strings[0]:= 'unit '+ChangeFileExt(ExtractFileName(fullPathToUnitTarget),'') +';';
    listTemp.Strings[1]:='//';
    listTemp.SaveToFile(fullPathToUnitTarget);

    listComponent.Add('jForm');
    Project.Files[listIndex+1].CustomData['jControls']:= listComponent.DelimitedText;

    ShowMessage('Sucess!! Imported form LAMW Stuff !!' +sLineBreak +
                'Hints:'+ sLineBreak +
                '.For each import,  "Run --> Build" and accept "Reload checked files from disk" !' + sLineBreak +
                '.(Re)"Open" the project to update the form display content ...' + sLineBreak +
                '      Or close the form unit tab and reopen it [Project Inspector...]'+ sLineBreak +
                '      to see the content changes...');
  end
  else
  begin
     listTemp.Clear;
     listTemp.LoadFromFile(fullPathToUnitSourceLFM);
     tempStr:=StringReplace(listTemp.Text, sourceFormName, targetFormName, [rfReplaceAll, rfIgnoreCase]);
     listTemp.Text:= tempStr;
     ShowMessage(fullPathToUnitTarget);
     listTemp.SaveToFile(ChangeFileExt(fullPathToUnitTarget, '.lfm'));

     listTemp.Clear;
     listTemp.LoadFromFile(ChangeFileExt(fullPathToUnitSourceLFM, '.pas'));
     tempStr:=StringReplace(listTemp.Text, sourceFormName, targetFormName, [rfReplaceAll, rfIgnoreCase]);
     listTemp.Text:= tempStr;
     listTemp.Strings[0]:= 'unit '+ChangeFileExt(ExtractFileName(fullPathToUnitTarget),'') +';';
     listTemp.Strings[1]:='//';
     listTemp.SaveToFile(fullPathToUnitTarget);

     ShowMessage('Sucess!! Imported form LAMW Stuff !!' +sLineBreak +
                'Hints:'+ sLineBreak +
                '.For each import,  "Run --> Build" and accept "Reload checked files from disk" !' + sLineBreak +
                '.(Re)"Open" the project to update the form display content ...' + sLineBreak +
                '      Or close the form unit tab and reopen it [Project Inspector...]'+ sLineBreak +
                '      to see the content changes...');
  end;

  listTemp.Free;
  listUnit.Free;
  listProject.Free;
  listComponent.Free;
  listProjComp.Free;
end;

procedure StartCanUpdateJavaTemplates(Sender: TObject);
var
  //Project: TLazProject;
  dlgMessage: string;
  canUpdate: string;
  setting: string;
  fileName: string;
begin
  //Project := LazarusIDE.ActiveProject;
  {if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
  begin}
    fileName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini';
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

  ideSubMnuAppCompat: TIDEMenuSection;

  Key: TIDEShortCut;
  Cat: TIDECommandCategory;
  CmdMyTool: TIDECommand;

begin
  // Register main menu
  ideMnuAMW:= RegisterIDEMenuSection(mnuTools,'AMW');
  // Register submenu
  ideSubMnuAMW:= RegisterIDESubMenu(ideMnuAMW, 'AMW', '[LAMW] Android Module Wizard');
  // Adding first entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToolCmd', 'Paths Settings [Jdk, Sdk, Ndk, ...]', nil,@StartPathTool);
  //Adding second entry
  // Adding third entry
  //RegisterIDEMenuCommand(ideSubMnuAMW, 'PathResEditorCmd', 'Resource Editor [strings.xml] ', nil,@StartResEditor);

  // Adding fourth entry
 //RegisterIDEMenuCommand(ideSubMnuAMW, 'PathUpdateCmd','Upgrade Code Templates [*.lpr, *.java]', nil,@StartUpdateCodeTemplateTool);

 // Adding 5a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathCompCreateCmd', 'New jComponent Create', nil,@StartComponentCreate);
  // Adding 6a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToFPCTrunkSource', 'Get FPC Source [Trunk]', nil, @StartFPCTrunkSource);
  // Adding 7a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToBuildFPCCross', 'Build FPC Cross Android', nil,@StartPathToBuildFPCCross);
  // Adding 8a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToEclipseToggleTooling', 'Eclipse Compatibility [ADT<->Andmore] ...', nil, @StartEclipseToggleTooling);

  //register IDE shortcut and menu item
  //Key := IDEShortCut(VK_F1,[ssCtrl],VK_UNKNOWN,[]);
  //Cat:=IDECommandList.FindCategoryByName(CommandCategoryToolMenuName);
  //CmdMyTool := RegisterIDECommand(Cat,'Export To Android Studio', 'Export .so to Android Studio', Key, nil, @StartExportLibToPath);
  //RegisterIDEMenuCommand(ideSubMnuAMW, 'ExportToAndroidStudio', 'Export .so to AndroidStudio', nil, nil, CmdMyTool);

  // Adding 9a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToCanUpdateJavaTemplates', '[Configure] CanUpdateJavaTemplates ...', nil, @StartCanUpdateJavaTemplates);

  // Adding 10a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToImportJava', 'Use/Import Java Stuff...', nil, @StartImportJavaStuff);

  // Adding 11a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToImportCCode', 'Use/Import C Stuff...', nil, @StartImportCStuff);

  //Adding 12a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToImportLAMWForm', 'Use/Import LAMW Stuff...', nil, @StartImportLAMWStuff);

  //Adding 13a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToImportPictureForm', 'Use/Import Image/Picture...', nil, @StartImportPictureStuff);

  // And so on...

  //Register submenu AppCompat
  ideSubMnuAppCompat:= RegisterIDESubMenu(ideSubMnuAMW, 'ConvertToAppCompat', 'Convert the Project to AppCompat Theme');
  //Adding first entry
  RegisterIDEMenuCommand(ideSubMnuAppCompat, 'AppCompatDarkActionBar', 'AppCompatDarkActionBar', nil, @StartAppCompatDarkActionBar);
  RegisterIDEMenuCommand(ideSubMnuAppCompat, 'AppCompatNoActionBar', 'AppCompatNoActionBar', nil, @StartAppCompatNoActionBar);

  // Register submenu  Logcat
  ideSubMnuLog:= RegisterIDESubMenu(ideSubMnuAMW, 'Logcatch', 'ADB Logcat');
  //Adding entry ...
  RegisterIDEMenuCommand(ideSubMnuLog, 'PathToLogcatd', 'Logcat -d [dump]', nil, @StartLogcatDump);
  RegisterIDEMenuCommand(ideSubMnuLog, 'PathToLogcatc', 'Logcat -c [clear]', nil, @StartLogcatClear);

  //Run
   Key := IDEShortCut(VK_F1,[ssCtrl],VK_UNKNOWN,[]);
   Cat:=IDECommandList.FindCategoryByName(CommandCategoryToolMenuName);
   CmdMyTool := RegisterIDECommand(Cat,'BuildApkAndRun', '[LAMW] Build Android Apk and Run', Key, nil, @BuildApkAndRun);
   RegisterIDEMenuCommand(itmRunBuilding, 'LAMW Build Apk And Run', '[LAMW] Build Android Apk and Run', nil, nil, CmdMyTool);
   //RegisterIDEMenuCommand(itmRunBuilding, 'BuildApkAndRun', '[LAMW] Build Android Apk and Run', nil, @BuildApkAndRun);

  ApkBuild.RegisterExtToolParser;
end;

end.
