unit amw_ide_menu_items; //By Thierrydijoux!

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Dialogs, IDECommands, MenuIntf, Forms,
  uformsettingspaths{, lazandroidtoolsexpert}, ufrmEditor, ufrmCompCreate,
  uFormBuildFPCCross, {uFormGetFPCSource,} uimportjavastuff, uimportjavastuffchecked,
  uimportcstuff, process, Laz2_DOM, laz2_XMLRead, uformimportlamwstuff,
  unitformimportpicture, uformapksigner, unitFormExportProjectAsTemplate,  lamwexplorer, LamwToolKit;

procedure StartPathTool(Sender: TObject);
procedure StartLateTool(Sender: TObject);     //By Thierrydijoux!
procedure StartResEditor(Sender: TObject);    //By Thierrydijoux!
procedure StartComponentCreate(Sender: TObject);
procedure StartPathToBuildFPCCross(Sender: TObject);
//procedure StartFPCTrunkSource(Sender: TObject);
procedure StartEclipseToggleTooling(Sender: TObject);
procedure StartImportJavaStuff(Sender: TObject);
procedure StartImportCStuff(Sender: TObject);
procedure StartLogcatClear(Sender: TObject);
procedure StartLogcatDump(Sender: TObject);
//procedure StartLogcatRuntimeError(Sender: TObject);

procedure Register;

implementation

uses
  {$ifdef Unix}
  baseunix,
  {$endif}
  LazIDEIntf, LazFileUtils, CompOptsIntf, IDEMsgIntf, IDEExternToolIntf,
  ProjectIntf, MacroIntf, Controls, ApkBuild, IniFiles, LCLType, LCLVersion, PackageIntf{, IDEImagesIntf};

procedure SaveShellScript(script: TStringList; const AFileName: string);
begin
    script.SaveToFile(AFileName);
    {$ifdef Unix}
    FpChmod(AFileName, &751);
    {$endif}
end;

{
procedure StartFPCTrunkSource(Sender: TObject);
begin
  FormGetFPCSource:= TFormGetFPCSource.Create(Application);
  FormGetFPCSource.ShowModal;
end;
}

procedure RunLamwExplorer(Sender: TObject);
var
  Project: TLazProject;
begin
 Project := LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
  begin
      if LExplorer = nil then
      begin
        LExplorer := TLExplorer.Create(Application);
      end;
      LExplorer.Show;
  end
  else
    ShowMessage('The active project is not LAMW project!');
end;

procedure RunLamwToolKit(Sender: TObject);
var
  Project: TLazProject;
begin
   Project := LazarusIDE.ActiveProject;
   if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
   begin
     ToolKit := TToolKit.Create(Application);
     ToolKit.ShowModal;
   end
   else
     ShowMessage('The active project is not LAMW project!');
end;

procedure StartPathTool(Sender: TObject);
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
     aux:= Project.LazCompilerOptions.Libraries;  //C:\adt32\ndk10e\platforms\android-15\arch-arm\usr\lib\; .....
     p:= Pos(';', aux);
     if p > 0 then
     begin
        linkLibrariesPath:= Trim(Copy(aux, 1, p-1));
        chip:= 'arm';
        if Pos('-x86', linkLibrariesPath) > 0 then chip:= 'x86';
        if chip = 'arm' then
        begin
           libChip:= 'armeabi';       //armeabi-v7a arm64-v8a x86 x86_64	  		   
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
 {$IFDEF windows}
  FormBuildFPCCross:= TFormBuildFPCCross.Create(Application);
  FormBuildFPCCross.ShowModal;
  {$Endif}

  {$IFDEF linux}
     ShowMessage('Warning: this option [should] not work for linux' +sLineBreak +
     'you can get some help from LAMW documentation...')
  {$Endif}

  {$IFDEF darwin}
     ShowMessage('Warning: this option [should] not work for MacOS' +sLineBreak +
     'you can get some help from LAMW documentation...')
  {$Endif}

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

  if FormImportCStuff.AndroidmkComboBox.ItemIndex = 0 then
  auxList.SaveToFile(pathToProject+'jni'+DirectorySeparator+'Android.mk');  

  auxList.Clear;
  auxList.Add('APP_ABI := '+libChip);  //armeabi-v7a arm64-v8a x86 x86_64
  auxList.Add('APP_PLATFORM := '+ndkPlataform);  //android-13
  auxList.SaveToFile(pathToProject+'jni'+DirectorySeparator+'Application.mk');
  auxList.Clear;

  {$IFDEF Windows}
  auxList.Add('cd '+pathToProject);
  auxList.Add(pathToNdk+'ndk-build.cmd V=1 -B');
  auxList.SaveToFile(pathToProject+'lib'+libname+'-builder.bat');
  {$Endif}

  {$IFDEF Unix}
  auxList.Add('cd '+pathToProject);
  auxList.Add(pathToNdk+'ndk-build V=1 -B');
  SaveShellScript(auxList, pathToProject+'lib'+libname+'-builder.sh');
  //auxList.SaveToFile(pathToProject+'lib'+libname+'-builder.sh');
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
        16: Result:= 'android-29';
        17: Result:= 'android-30';
        18: Result:= 'android-31';
        19: Result:= 'android-32';
        20: Result:= 'android-33';
        21: Result:= 'android-34';
     end;
  end;
end;

//function add(a:longint; b:longint):longint;cdecl;
function GetMethodName(methodHeader: string): string;
var
  p: integer;
  aux : string;
begin
  p:= Pos('(', methodHeader);
  aux:= Copy(methodHeader, 1, p-1); //function add
  aux:= Trim(aux);
  SplitStr(aux, ' ');
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

  if FormImportCStuff.h2pasComboBox.ItemIndex <> 0 then
  Exit;


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
begin
  Project:= LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '' ) then
  begin
    pathToSdk:= Project.CustomData.Values['SdkPath'];
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

      {$IF LCL_FULLVERSION >= 2010000}
      Tool.Parsers.Add(SubToolDefault);
      {$ELSE}
      Tool.Scanners.Add(SubToolDefault);
      {$ENDIF}

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

function TryProduceGradleVersion(pathToGradle: string): string;
var
   AProcess: TProcess;
   AStringList: TStringList;
   gradle, ext, version: string;
   i, p: integer;
begin
  version:= '';
  ext:='.bat';
  {$IFDEF linux}
  ext:='';
  {$Endif}

  {$IFDEF darwin}
     ext:='';
  {$Endif}
  gradle:= 'gradle'  + ext;
  AStringList:= TStringList.Create;
  AProcess := TProcess.Create(nil);
  AProcess.Executable := pathToGradle + PathDelim + 'bin' + PathDelim + gradle;  //C:\android\gradle-6.8.3\bin\gradle.bat
  AProcess.Options:=AProcess.Options + [poWaitOnExit, poUsePipes, poNoConsole];
  AProcess.Parameters.Add('-version');
  AProcess.Parameters.Add('>');
  AProcess.Parameters.Add(pathToGradle + PathDelim + 'version.txt');
  AProcess.Execute;

  AStringList.LoadFromFile(pathToGradle + PathDelim + 'version.txt');
  i:= 0;
  while (version='') and (i < AStringList.Count) do
  begin
     p:= Pos('Gradle', AStringList.Strings[i] );
     if p > 0 then
     begin
        version:=  AStringList.Strings[i];
     end;
     i:= i +1;
  end;
  Result:= Trim(Copy(version, p+6, 10));
  AStringList.Text:= Result;
  AStringList.SaveToFile(pathToGradle + PathDelim + 'version.txt');  // This can be ommitted
  AProcess.Free;
  AStringList.Free;
end;

procedure ConvertToAppCompat(paramTheme: string);
var
   Project: TLazProject;
   p, p1: integer;
   packageName: string;
   pathToJavaTemplates: string;
   fileName: string;
   pathToProject: string;
   pathToJavaSrc: string;
   list, manifestList: TStringList;
   isOldTheme: boolean;
   targetApi, tmpStr, supportProvider: string;
   gradlePath, gradleVersion, tempStr, insertRef: string;
begin
  Project:= LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] = 'GUI' ) then
  begin

    if Project.CustomData.Values['Theme'] =  paramTheme then
    begin
       ShowMessage('Warning: this theme ['+paramTheme+'] is already being used...');
       Exit;
    end;

    isOldTheme:= True;
    if Pos('AppCompat', Project.CustomData.Values['Theme']) > 0 then
      isOldTheme:= False;

    Project.CustomData.Values['Theme']:= paramTheme;
    Project.CustomData.Values['BuildSystem']:= 'Gradle';
    Project.CustomData.Values['Support']:= 'TRUE';

    packageName:= Project.CustomData.Values['Package'];

    Project.Modified:= True;   // <-- need here!!

    p:= Pos(DirectorySeparator+'jni', Project.ProjectInfoFile);
    pathToProject:= Copy(Project.ProjectInfoFile, 1, p);

    fileName:= IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini';
    with TIniFile.Create(fileName) do
    try
      pathToJavaTemplates:= ReadString('NewProject','PathToJavaTemplates', '');
      if pathToJavaTemplates <> '' then
      begin
        pathToJavaSrc:= pathToProject+'src'+DirectorySeparator+StringReplace(packageName,'.',DirectorySeparator,[rfReplaceAll,rfIgnoreCase]);

        list:= TStringList.Create; //C:\laz4android2.0.0\components\androidmodulewizard\android_wizard\smartdesigner\java\support
        list.LoadFromFile(pathToJavaTemplates+DirectorySeparator+'support'+DirectorySeparator+'App.java');
        list.Strings[0]:= 'package '+packageName+';';
        list.SaveToFile(pathToJavaSrc+DirectorySeparator+'App.java');

        list.Clear;
        list.LoadFromFile(pathToJavaTemplates+DirectorySeparator+'support'+DirectorySeparator+'jCommons.java');
        list.Strings[0]:= 'package '+packageName+';';
        list.SaveToFile(pathToJavaSrc+DirectorySeparator+'jCommons.java');

        list.Clear;
        list.LoadFromFile(pathToJavaTemplates+DirectorySeparator+'support'+DirectorySeparator+'jSupported.java');
        list.Strings[0]:= 'package '+packageName+';';
        list.SaveToFile(pathToJavaSrc+DirectorySeparator+'jSupported.java');

        list.Clear;  //androidX
        ForceDirectories(pathToProject+ 'res' +DirectorySeparator+'xml');
        list.LoadFromFile(pathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'support_provider_paths.xml');
        list.SaveToFile(pathToProject +'res'+DirectorySeparator+'xml'+DirectorySeparator+'support_provider_paths.xml');

        list.Clear;
        list.LoadFromFile(pathToJavaTemplates +DirectorySeparator+'support'+DirectorySeparator+'manifest_support_provider.txt');
        supportProvider:= StringReplace(list.Text, 'dummyPackage',packageName, [rfReplaceAll, rfIgnoreCase]);

        manifestList:= TStringList.Create;
        manifestList.LoadFromFile(pathToProject + 'AndroidManifest.xml');
        tempStr:= manifestList.Text;  //manifest
        if Pos('androidx.core.content.FileProvider', tempStr) <= 0 then    //androidX
        begin
           insertRef:= '</activity>'; //insert reference point
           p1:= Pos(insertRef, tempStr);
           Insert(sLineBreak + supportProvider, tempStr, p1+Length(insertRef));
           manifestList.Clear;
           manifestList.Text:= tempStr;
           manifestList.SaveToFile(pathToProject + 'AndroidManifest.xml');
        end;
        manifestList.Free;

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
             DeleteFile(pathToProject+'res'+DirectorySeparator+'values-v21'+DirectorySeparator+'styles.xml');
             DeleteDirectory(pathToProject+'res'+DirectorySeparator+'values-v21', False);
          end;

          targetApi:= Trim(GetTargetFromManifest(pathToProject));
          gradlePath:= ReadString('NewProject','PathToGradle', '');
          if gradlePath <> '' then     // C:\adt32\gradle-4.4.1
          begin
            //p:= Pos('dle-', gradlePath);
            //gradleVersion:= Copy(gradlePath, p+4, MaxInt);
            if not FileExists(gradlePath + PathDelim + 'version.txt') then
            begin
               gradleVersion:=  TryProduceGradleVersion(gradlePath);
            end
            else
            begin
              list.Clear;
              list.LoadFromFile(gradlePath + PathDelim + 'version.txt');
              gradleVersion:= Trim(list.Text);
            end;
          end;

          list.Clear;
          list.LoadFromFile(pathToJavaTemplates+DirectorySeparator+'support'+DirectorySeparator+'buildgradle.txt');

          if StrToInt(targetApi) < 28 then targetApi:= '28';

          tmpStr:= StringReplace(list.Text,'#sdkapi', targetApi, [rfReplaceAll]);
          list.Text:= tmpStr;
          tmpStr:= StringReplace(list.Text,'#package', packageName, [rfReplaceAll]);
          list.Text:= tmpStr;
          tmpStr:= StringReplace(list.Text,'#localgradle', gradleVersion, [rfReplaceAll]);
          list.Text:= tmpStr;
          list.SaveToFile(pathToProject+'build.gradle');

          ShowMessage('Welcome to Material Design!!' +sLineBreak +
                      'Welcome to "Android Bridges AppCompat" components!!!'+sLineBreak+
                      'Please, "Save All" Now!!' +sLineBreak+ 'And "Re-Open" the Project!');
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
  //chip: string;
  libChip: string;
  pathToNewLib: string;
  aux: string;
  listBackup: TStringList;
  saveLibBackupTo: string;

  ini_int_result: integer;
  ini_bool_result: boolean;
  ini_string_result: string;
  
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
          linkLibrariesPath:= Trim(Copy(aux, 1, p-1)); //arch-arm :: arch-arm64 ::  arch-x86 :: arch-x86_64
		  
		// string values for searching were taken from file "smartdesigner.pas"
		if Pos('-CpARMV7', Project.LazCompilerOptions.CustomOptions) > 0 then //-Xd -CfVFPv3 -CpARMV7A -XParm-linux-androideabi- -FDC:\Users\username\AppData\Local\Android\Sdk\ndk\22.1.7171670\toolchains\arm-linux-androideabi-4.9\prebuilt\windows-x86_64\bin
           libChip:= 'armeabi-v7a'
		else if Pos('-XPaarch64', Project.LazCompilerOptions.CustomOptions) > 0 then //-Xd -XPaarch64-linux-android- -FDC:\Users\username\AppData\Local\Android\Sdk\ndk\22.1.7171670\toolchains\aarch64-linux-android-4.9\prebuilt\windows-x86_64\bin
		   libChip:= 'arm64-v8a'
		else if Pos('-XPi686', Project.LazCompilerOptions.CustomOptions) > 0 then //-Xd -XPi686-linux-android- -FDC:\Users\username\AppData\Local\Android\Sdk\ndk\22.1.7171670\toolchains\x86-4.9\prebuilt\windows-x86_64\bin
		   libChip:= 'x86'
		else if Pos('-XPx86_64', Project.LazCompilerOptions.CustomOptions) > 0 then //-Xd -XPx86_64-linux-android- -FDC:\Users\username\AppData\Local\Android\Sdk\ndk\22.1.7171670\toolchains\x86_64-4.9\prebuilt\windows-x86_64\bin
		   libChip:= 'x86_64'
		else   
		libChip:= 'arm'; //dummy
       end;

       pathToNdk:= Project.CustomData.Values['NdkPath'];  //<Item2 Name="NdkPath" Value="C:\adt32\ndk10e\"/>
       ndkPlatform:= Project.CustomData.Values['NdkApi'];  //<Item3 Name="NdkApi" Value="android-22"/>

       p:= Pos(DirectorySeparator+'jni', Project.ProjectInfoFile);
       pathToProject:= Copy(Project.ProjectInfoFile, 1, p);

      with TIniFile.Create(pathToProject+'jni'+DirectorySeparator + 'ImportCStuff.ini') do
      try
        ini_string_result := ReadString('ImportCStuff', 'EditImportC', '');
        if (CompareStr(FormImportCStuff.EditImportC.Text, ini_string_result) <> 0) then
        begin
           WriteString('ImportCStuff', 'EditImportC', FormImportCStuff.EditImportC.Text);
        end;				
		
        ini_bool_result := ReadBool('ImportCStuff', 'CheckBoxAllC', False);
        if (FormImportCStuff.CheckBoxAllC.Checked <> ini_bool_result) then
        begin
           WriteBool('ImportCStuff', 'CheckBoxAllC', FormImportCStuff.CheckBoxAllC.Checked);
        end;		
		
        ini_string_result := ReadString('ImportCStuff', 'EditImportH', '');
        if (CompareStr(FormImportCStuff.EditImportH.Text, ini_string_result) <> 0) then
        begin
           WriteString('ImportCStuff', 'EditImportH', FormImportCStuff.EditImportH.Text);
        end;			
				
        ini_bool_result := ReadBool('ImportCStuff', 'CheckBoxAllH', False);
        if (FormImportCStuff.CheckBoxAllH.Checked <> ini_bool_result) then
        begin
           WriteBool('ImportCStuff', 'CheckBoxAllH', FormImportCStuff.CheckBoxAllH.Checked);
        end;		

        ini_string_result := ReadString('ImportCStuff', 'EditLibName', '');
        if (CompareStr(FormImportCStuff.EditLibName.Text, ini_string_result) <> 0) then
        begin
           WriteString('ImportCStuff', 'EditLibName', FormImportCStuff.EditLibName.Text);
        end;			

        ini_int_result := ReadInteger('ImportCStuff', 'AndroidmkComboBox', 0);
        if (FormImportCStuff.AndroidmkComboBox.ItemIndex <> ini_int_result) then
        begin
           WriteInteger('ImportCStuff', 'AndroidmkComboBox', FormImportCStuff.AndroidmkComboBox.ItemIndex);
        end;	
		
		
        ini_int_result := ReadInteger('ImportCStuff', 'h2pasComboBox', 0);
        if (FormImportCStuff.h2pasComboBox.ItemIndex <> ini_int_result) then
        begin
           WriteInteger('ImportCStuff', 'h2pasComboBox', FormImportCStuff.h2pasComboBox.ItemIndex);
        end;		
		
      finally
        Free;
      end;

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

//StartApkSignerStuff
procedure StartApkSignerStuff(Sender: TObject);
var
  Project: TLazProject;
  PathToAndroidProject, SmallProjName, strTemp, strAux: string;
  p1: integer;
  auxList, tempList: TStringList;
  isUniversalApk: boolean;
  instructionChip, ks_pass, key_pass: string;
  AProcess: TProcess;
  buildSystem: string;
  linuxPathToAndroidProject, winPathToAndroidProject: string;
  keystoreExists: boolean;
begin
  Project := LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
  begin

    buildSystem:= Project.CustomData.Values['BuildSystem'];  //Gradle or Ant

    instructionChip:= ExtractFileDir(LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename);
    instructionChip:= ExtractFileName(instructionChip); //armeabi-v7a

    p1:= Pos(DirectorySeparator+'jni'+DirectorySeparator, Project.ProjectInfoFile);
    if p1 > 0 then
    begin
      PathToAndroidProject:= Trim(Copy(Project.ProjectInfoFile, 1, p1-1))
    end
    else
    begin
      PathToAndroidProject:= ExtractFilePath(Project.ProjectInfoFile);
      PathToAndroidProject:= Copy(PathToAndroidProject,1, Length(PathToAndroidProject)-1);
    end; //C:\android\workspace\AppLAMWProject10

    linuxPathToAndroidProject:= PathToAndroidProject;
    {$IFDEF Windows}
    strAux:= PathToAndroidProject;
    SplitStr(strAux, ':');
    linuxPathToAndroidProject:= StringReplace(strAux, '\', '/', [rfReplaceAll]);
    {$endif}

    winPathToAndroidProject:= PathToAndroidProject;
    {$IFDEF Linux}
    strAux:= PathToAndroidProject;
    winPathToAndroidProject:= 'C:'+ StringReplace(strAux, '/', '\', [rfReplaceAll]);
    {$endif}

    tempList:= TStringList.Create;

    auxList:= TStringList.Create;
    auxList.StrictDelimiter:= True;
    auxList.Delimiter:= DirectorySeparator;
    auxList.DelimitedText:= TrimChar(PathToAndroidProject, DirectorySeparator);
    smallProjName:=  auxList.Strings[auxList.Count-1];; //AppLAMWProject10

    auxList.LoadFromFile(PathToAndroidProject +  DirectorySeparator + 'keytool_input.txt');
    { keytool_input.txt
      123456           0
      123456           1
      MyFirstName MyLastName 2
      MyDevelopmentUnitName  3
      MyCompanyName          4
      MyCity                 5
      MT                     6
      BR                     7
      y                      8
      123456                 9
    }                                //firstPart:= SplitStr(aux, ' ');

    FormApksigner:=  TFormApksigner.Create(Application);
    FormApksigner.StatusBar1.SimplePanel:= True;
    FormApksigner.StatusBar1.SimpleText:= 'Build System: ' + buildSystem;

    FormApksigner.EditKeyStorePassword.Text:= auxList.Strings[0];   //123456

    strTemp:=auxList.Strings[2];
    FormApksigner.EditFirstName.Text:= SplitStr(strTemp, ' ');      //MyFirstName
    FormApksigner.EditLastName.Text:= strTemp;                      //MyLastName

    FormApksigner.EditOrgUnit.Text:= auxList.Strings[3];            //MyDevelopmentUnitName
    FormApksigner.EditOrgName.Text:= auxList.Strings[4];            //MyCompanyName
    FormApksigner.EditCity.Text:= auxList.Strings[5];               //MyCity
    FormApksigner.EditProvince.Text:= auxList.Strings[6];           //MT
    FormApksigner.EditCodeCountry.Text:= auxList.Strings[7];        //BR
    FormApksigner.EditKeyAliasPassword.Text:= auxList.Strings[9];   //123456

    //Const
    FormApksigner.EditApkKeyAlias.Text:= Lowercase(SmallProjName)+'.keyalias';
    FormApksigner.EditApkKeyAlias.ReadOnly:= True;

    isUniversalApk:= True;
    tempList.LoadFromFile(PathToAndroidProject  +  DirectorySeparator +  'build.gradle');
    if Pos('universalApk false', tempList.Text) > 0 then
    begin
      isUniversalApk:= False;
    end;

    if buildSystem = 'Gradle' then
    begin
      if isUniversalApk then
      begin
         if not FileExists(PathToAndroidProject + DirectorySeparator +
                                                   'build' +DirectorySeparator+
                                                   'outputs'+DirectorySeparator+
                                                   'apk'+DirectorySeparator+
                                                   'debug'+DirectorySeparator+
                                                   smallProjName+'-universal-debug.apk') then
         begin
           ShowMessage('[Gradle] Fail... You need first: '+sLineBreak+'"Run" --> "[LAMW] Build Android Apk and Run" to produce a debug version ...');
           Exit;
         end;
      end
      else
      begin                                               //AppLAMWProject5-armeabi-v7a-debug.apk
         if not FileExists(PathToAndroidProject + DirectorySeparator +
                                                   'build' +DirectorySeparator+
                                                   'outputs'+DirectorySeparator+
                                                   'apk'+DirectorySeparator+
                                                   'debug'+DirectorySeparator+
                                                   smallProjName+'-'+instructionChip+'-debug.apk') then
         begin
           ShowMessage('[Gradle] Fail... You need first: '+sLineBreak+ '"Run" --> "[LAMW] Build Android Apk and Run" '+sLineBreak+'to produce a debug version ...');
           Exit;
         end;
      end;
    end
    else // Ant
    begin
      If not FileExists(PathToAndroidProject + DirectorySeparator + 'bin'+ DirectorySeparator +
                        smallProjName+'-debug.apk') then
      begin
        ShowMessage('[Ant] Fail... You need first: '+sLineBreak + '"Run" --> "[LAMW] Build Android Apk and Run" '+sLineBreak+'to produce a debug version ...');
        Exit;
      end;
    end;

    keystoreExists:= False;
    if FileExists(PathToAndroidProject  +  DirectorySeparator +  SmallProjName+'-release.keystore') then
    begin
      ShowMessage('[ File "'+SmallProjName+'-release.keystore" Exists! ]'+sLineBreak+' Using existing "'+SmallProjName+'-release.keystore" ');
      keystoreExists:= True;

      tempList.Clear;
      tempList.Add('         Credentials Data');
      tempList.Add(    '"'+SmallProjName+'-release.keystore"');
      tempList.Add(' ');
      tempList.Add('[File] Key Store Password: ' + auxList.Strings[0]);
      strTemp:=auxList.Strings[2];
      tempList.Add('First Name: '+ SplitStr(strTemp, ' '));
      tempList.Add('Last Name: ' + strTemp);
      tempList.Add('Organizational Unit: ' + auxList.Strings[3]);
      tempList.Add('Organization Name: ' + auxList.Strings[4]);
      tempList.Add('City or Locality: ' + auxList.Strings[5]);
      tempList.Add('State or Province: ' + auxList.Strings[6]);
      tempList.Add('Country: ' + auxList.Strings[7]);

      tempList.Add('[Apk] Key Alias: '+Lowercase(SmallProjName)+'.keyalias');
      tempList.Add('[Apk] Key Alias Password: ' + auxList.Strings[9]);
      tempList.Add(' ');
      tempList.Add('                         Project Build System: ' + buildSystem);

      ShowMessage(tempList.Text);
    end;

    if not keystoreExists then
    begin
      if FormApksigner.ShowModal = mrOk then
      begin
        ShowMessage('"warning:'+SmallProjName+'-release.keystore" file created only once [per application]');

        ks_pass:= FormApksigner.EditKeyStorePassword.Text;
        key_pass:= FormApksigner.EditKeyAliasPassword.Text;

        auxList.Clear;
        auxList.Add(ks_pass);
        auxList.Add(ks_pass);  //confirm
        auxList.Add(FormApksigner.EditFirstName.Text+ ' '+ FormApksigner.EditLastName.Text);
        auxList.Add(FormApksigner.EditOrgUnit.Text);
        auxList.Add(FormApksigner.EditOrgName.Text);
        auxList.Add(FormApksigner.EditCity.Text);
        auxList.Add(FormApksigner.EditProvince.Text);
        auxList.Add(FormApksigner.EditCodeCountry.Text);
        auxList.Add('y');
        auxList.Add(key_pass);
        auxList.SaveToFile(PathToAndroidProject +  DirectorySeparator + 'keytool_input.txt');

        { ant.properties
        key.store=applamwproject9-release.keystore
        key.alias=applamwproject9.keyalias
        key.store.password=123456
        key.alias.password=123456
        }

        auxList.Clear;
        auxList.Add('key.store='+ Lowercase(SmallProjName)+'-release.keystore');
        auxList.Add('key.alias='+ Lowercase(SmallProjName)+'.keyalias');
        auxList.Add('key.store.password='+ks_pass);
        auxList.Add('key.alias.password='+key_pass);
        auxList.SaveToFile(PathToAndroidProject +  DirectorySeparator + 'ant.properties');

        (*
        auxList.Clear;
        auxList.LoadFromFile(PathToAndroidProject +  DirectorySeparator + 'gradle.properties');
        auxList.Add('RELEASE_STORE_FILE = '+ Lowercase(SmallProjName)+'-release.keystore');
        auxList.Add('RELEASE_KEY_ALIAS = '+ Lowercase(SmallProjName)+'.keyalias');
        auxList.Add('RELEASE_STORE_PASSWORD = '+ks_pass);
        auxList.Add('RELEASE_KEY_PASSWORD = '+key_pass);
        auxList.SaveToFile(PathToAndroidProject +  DirectorySeparator + 'gradle.properties');
        *)

        auxList.Clear;
        auxList.LoadFromFile(PathToAndroidProject +  DirectorySeparator + 'gradle-local-universal-apksigner.bat');
        {.bat
        set Path=%PATH%;C:\android\sdk\platform-tools;C:\android\sdk\build-tools\29.0.2
        set GRADLE_HOME=C:\android\gradle-6.6.1
        set PATH=%PATH%;%GRADLE_HOME%\bin
        zipalign -v -p 4 C:\android\workspace\AppLAMWProject10\build\outputs\apk\release\AppLAMWProject10-universal-release-unsigned.apk C:\android\workspace\AppLAMWProject10\build\outputs\apk\release\AppLAMWProject10-universal-release-unsigned-aligned.apk
        apksigner sign --ks C:\android\workspace\AppLAMWProject10\applamwproject10-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\android\workspace\AppLAMWProject10\build\outputs\apk\release\AppLAMWProject10-release.apk C:\android\workspace\AppLAMWProject10\build\outputs\apk\release\AppLAMWProject10-universal-release-unsigned-aligned.apk
        }
        strTemp:= 'apksigner sign --ks ' + winPathToAndroidProject + '\' +
                Lowercase(smallProjName) + '-release.keystore --ks-pass pass:' + ks_pass + ' --key-pass pass:'+key_pass+' --out ' +
                winPathToAndroidProject + '\build\outputs\apk\release\' +
                                       smallProjName + '-release.apk ' +
                winPathToAndroidProject + '\build\outputs\apk\release\'+
                                       smallProjName + '-universal-release-unsigned-aligned.apk';
        auxList.Strings[4]:= strTemp;
        auxList.SaveToFile(PathToAndroidProject + DirectorySeparator + 'gradle-local-universal-apksigner.bat');

        auxList.Clear;
        auxList.LoadFromFile(PathToAndroidProject +  DirectorySeparator + 'gradle-local-universal-apksigner.sh');
        {.sh
        export PATH=/android/sdk/platform-tools:$PATH
        export PATH=/android/sdk/build-tools/29.0.2:$PATH
        export GRADLE_HOME=/android/gradle-6.6.1
        export PATH=$PATH:$GRADLE_HOME/bin
        zipalign -v -p 4 /android/workspace/AppLAMWProject12/build/outputs/apk/release/AppLAMWProject12-universal-release-unsigned.apk /android/workspace/AppLAMWProject12/build/outputs/apk/release/AppLAMWProject12-universal-release-unsigned-aligned.apk
        apksigner sign --ks /android/workspace/AppLAMWProject12/applamwproject12-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /android/workspace/AppLAMWProject12/build/outputs/apk/release/AppLAMWProject12-release.apk /android/workspace/AppLAMWProject12/build/outputs/apk/release/AppLAMWProject12-universal-release-unsigned-aligned.apk
        }
        strTemp:='apksigner sign --ks ' + linuxPathToAndroidProject + '/' +
                Lowercase(smallProjName) + '-release.keystore --ks-pass pass:' + ks_pass + ' --key-pass pass:'+key_pass+' --out ' +
                linuxPathToAndroidProject + '/build/outputs/apk/release/' +
                                       smallProjName + '-release.apk ' +
                linuxPathToAndroidProject + '/build/outputs/apk/release/'+
                                       smallProjName + '-universal-release-unsigned-aligned.apk';
        auxList.Strings[5]:= strTemp;
        SaveShellScript(auxList, PathToAndroidProject+ DirectorySeparator + 'gradle-local-universal-apksigner.sh');

        auxList.Clear;
        auxList.LoadFromFile(PathToAndroidProject + DirectorySeparator + 'gradle-local-apksigner.bat');
        { .bat
        set Path=%PATH%;C:\android\sdk\platform-tools;C:\android\sdk\build-tools\29.0.2
        set GRADLE_HOME=C:\android\gradle-6.6.1
        set PATH=%PATH%;%GRADLE_HOME%\bin
        zipalign -v -p 4 C:\android\workspace\AppLAMWProject10\build\outputs\apk\release\AppLAMWProject10-armeabi-v7a-release-unsigned.apk C:\android\workspace\AppLAMWProject10\build\outputs\apk\release\AppLAMWProject10-armeabi-v7a-release-unsigned-aligned.apk
        apksigner sign --ks C:\android\workspace\AppLAMWProject10\applamwproject10-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out C:\android\workspace\AppLAMWProject10\build\outputs\apk\release\AppLAMWProject10-release.apk C:\android\workspace\AppLAMWProject10\build\outputs\apk\release\AppLAMWProject10-armeabi-v7a-release-unsigned-aligned.apk
        }
        strTemp:='apksigner sign --ks '+ winPathToAndroidProject + '\' +
                 Lowercase(smallProjName) + '-release.keystore --ks-pass pass:' + ks_pass + ' --key-pass pass:' + key_pass + ' --out ' +
                 winPathToAndroidProject + '\build\outputs\apk\release\' +
                                        SmallProjName + '-release.apk '+
                 winPathToAndroidProject + '\build\outputs\apk\release\' +
                                        SmallProjName+'-' + instructionChip + '-release-unsigned-aligned.apk';

        auxList.Strings[4]:= strTemp;
        auxList.SaveToFile(PathToAndroidProject + DirectorySeparator + 'gradle-local-apksigner.bat');

        auxList.Clear;
        auxList.LoadFromFile(PathToAndroidProject + DirectorySeparator + 'gradle-local-apksigner.sh');
        {.sh
        export PATH=/android/sdk/platform-tools:$PATH
        export PATH=/android/sdk/build-tools/29.0.2:$PATH
        export GRADLE_HOME=/android/gradle-6.6.1
        export PATH=$PATH:$GRADLE_HOME/bin
        zipalign -v -p 4 /android/workspace/AppLAMWProject12/build/outputs/apk/release/AppLAMWProject12-armeabi-v7a-release-unsigned.apk /android/workspace/AppLAMWProject12/build/outputs/apk/release/AppLAMWProject12-armeabi-v7a-release-unsigned-aligned.apk
        apksigner sign --ks /android/workspace/AppLAMWProject12/applamwproject12-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out /android/workspace/AppLAMWProject12/build/outputs/apk/release/AppLAMWProject12-release.apk /android/workspace/AppLAMWProject12/build/outputs/apk/release/AppLAMWProject12-armeabi-v7a-release-unsigned-aligned.apk
        }
        strTemp:='apksigner sign --ks '+ linuxPathToAndroidProject + '/' +
                 Lowercase(smallProjName) + '-release.keystore --ks-pass pass:' + ks_pass + ' --key-pass pass:' + key_pass + ' --out ' +
                 linuxPathToAndroidProject + '/build/outputs/apk/release/' +
                                        SmallProjName + '-release.apk '+
                 linuxPathToAndroidProject + '/build/outputs/apk/release/' +
                                        SmallProjName+'-' + instructionChip + '-release-unsigned-aligned.apk';
        auxList.Strings[5]:= strTemp;
        SaveShellScript(auxList, PathToAndroidProject + DirectorySeparator+'gradle-local-apksigner.sh');

        //release-keystore.bat
        try
          AProcess:= TProcess.Create(nil);
          AProcess.CurrentDirectory:= PathToAndroidProject;

          {$IFDEF Windows}
          AProcess.Executable := 'c:\windows\system32\cmd.exe';
          AProcess.Parameters.Add('/c');  //Executes the command(s) in command and then quits.
          AProcess.Parameters.Add('release-keystore.bat');
          {$ENDIF Windows}

          {$IFDEF Unix}
          AProcess.Executable := '/bin/sh';
          AProcess.Parameters.Add('-c');
          AProcess.Parameters.Add('release-keystore.sh');
          {$ENDIF Unix}

          AProcess.Options:= AProcess.Options + [poWaitOnExit];
          AProcess.Execute;
        finally
          AProcess.Free;
        end;

        keystoreExists:= True;

      end;//showModal
    end;

    if keystoreExists then
    begin
      //gradle apk signer
      if buildSystem = 'Gradle' then
      begin
        try
          AProcess:= TProcess.Create(nil);
          AProcess.CurrentDirectory:= PathToAndroidProject;
          if isUniversalApk then  //gradle-local-universal-apksigner.bat
          begin
            {$IFDEF Windows}
            AProcess.Executable := 'c:\windows\system32\cmd.exe';
            AProcess.Parameters.Add('/c');  //Executes the command(s) in command and then quits.
            AProcess.Parameters.Add('gradle-local-universal-apksigner.bat');
            {$ENDIF Windows}

            {$IFDEF Unix}
            AProcess.Executable := '/bin/sh';
            AProcess.Parameters.Add('-c');
            AProcess.Parameters.Add('gradle-local-universal-apksigner.sh');
            {$ENDIF Unix}
          end
          else  //gradle-local-apksigner.bat
          begin
            {$IFDEF Windows}
            AProcess.Executable := 'c:\windows\system32\cmd.exe';
            AProcess.Parameters.Add('/c');  //Executes the command(s) in command and then quits.
            AProcess.Parameters.Add('gradle-local-apksigner.bat');
            {$ENDIF Windows}

            {$IFDEF Unix}
            AProcess.Executable := '/bin/sh';
            AProcess.Parameters.Add('-c');
            AProcess.Parameters.Add('gradle-local-apksigner.sh');
            {$ENDIF Unix}
          end;
          AProcess.Options:= AProcess.Options + [poWaitOnExit];
          AProcess.Execute;
        finally
          AProcess.Free;
        end;

        ShowMessage('[Gradle] Success!! Look for your signed "'+SmallProjName+'-release.apk" '+sLineBreak+
                     'in [project] folder "...\build\outputs\apk\release"' );
      end
      else
      begin //Ant
        try
          AProcess:= TProcess.Create(nil);
          AProcess.CurrentDirectory:= PathToAndroidProject;

          {$IFDEF Windows}
          AProcess.Executable := 'c:\windows\system32\cmd.exe';
          AProcess.Parameters.Add('/c');  //Executes the command(s) in command and then quits.
          AProcess.Parameters.Add('ant-build-release.bat');
          {$ENDIF Windows}

          {$IFDEF Unix}
          AProcess.Executable := '/bin/sh';
          AProcess.Parameters.Add('-c');
          AProcess.Parameters.Add('ant-build-release.sh');
          {$ENDIF Unix}

          AProcess.Options:= AProcess.Options + [poWaitOnExit];
          AProcess.Execute;
        finally
          AProcess.Free;
        end;
        ShowMessage('[Ant] Success!! Look for your signed "'+SmallProjName+'-release.apk" '+sLineBreak+
                    'in [project] folder "...\bin"' );
      end;
    end;
    tempList.Free;
    auxList.Free;
  end
  else
    ShowMessage('The active project not is a LAMW project!');
end;

//StartBundleSignerStuff
procedure StartBundleSignerStuff(Sender: TObject);
var
  Project: TLazProject;
  PathToAndroidProject, smallProjName, strTemp: string;
  p1: integer;
  auxList, signList,  tempList: TStringList;
  bundleList: TStringList;
  instructionChip, ks_pass, key_pass: string;
  AProcess: TProcess;
  buildSystem: string;
  savedGradleProperties, savedBuildGradle: string;
  keystoreExists, isUniversalApk: boolean;
begin
  Project := LazarusIDE.ActiveProject;
  if Assigned(Project) and (Project.CustomData.Values['LAMW'] <> '') then
  begin

    buildSystem:= Project.CustomData.Values['BuildSystem'];  //Gradle or Ant

    if buildSystem <> 'Gradle' then
    begin
       ShowMessage('Fail...Signed Bundle need Gradle build system ...');
       Exit;
    end;

    instructionChip:= ExtractFileDir(LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename);
    instructionChip:= ExtractFileName(instructionChip);  //armeabi-v7a

    p1:= Pos(DirectorySeparator+'jni'+DirectorySeparator, Project.ProjectInfoFile);
    if p1 > 0 then
    begin
      PathToAndroidProject:= Trim(Copy(Project.ProjectInfoFile, 1, p1-1))
    end
    else
    begin
      PathToAndroidProject:= ExtractFilePath(Project.ProjectInfoFile);
      PathToAndroidProject:= Copy(PathToAndroidProject,1, Length(PathToAndroidProject)-1);
    end; //C:\android\workspace\AppLAMWProject10


    auxList:= TStringList.Create;
    auxList.StrictDelimiter:= True;
    auxList.Delimiter:= DirectorySeparator;
    auxList.DelimitedText:= TrimChar(PathToAndroidProject, DirectorySeparator);
    smallProjName:=  auxList.Strings[auxList.Count-1];; //AppLAMWProject10

    tempList:= TStringList.Create;
    tempList.LoadFromFile(PathToAndroidProject  +  DirectorySeparator +  'build.gradle');

    isUniversalApk:= True;
    if Pos('universalApk false', tempList.Text) > 0 then
    begin
      isUniversalApk:= False;
    end;

    if isUniversalApk then
    begin
       if not FileExists(PathToAndroidProject + DirectorySeparator +
                                                 'build' +DirectorySeparator+
                                                 'outputs'+DirectorySeparator+
                                                 'apk'+DirectorySeparator+
                                                 'debug'+DirectorySeparator+
                                                 smallProjName+'-universal-debug.apk') then
       begin
         ShowMessage('[Gradle] Fail... You need first: '+sLineBreak+'"Run" --> "[LAMW] Build Android Apk and Run" to produce a debug version ...');
         Exit;
       end;
    end
    else
    begin                                                ////AppLAMWProject5-armeabi-v7a-debug.apk
       if not FileExists(PathToAndroidProject + DirectorySeparator +
                                                 'build' +DirectorySeparator+
                                                 'outputs'+DirectorySeparator+
                                                 'apk'+DirectorySeparator+
                                                 'debug'+DirectorySeparator+
                                                 smallProjName+'-'+instructionChip+'-debug.apk') then

       begin
         ShowMessage('[Gradle] Fail... You need first: '+sLineBreak+ '"Run" --> "[LAMW] Build Android Apk and Run" '+sLineBreak+'to produce a debug version ...');
         Exit;
       end;
    end;

    auxList.Clear;
    auxList.LoadFromFile(PathToAndroidProject +  DirectorySeparator + 'keytool_input.txt');
    { keytool_input.txt
      123456           0
      123456           1
      MyFirstName MyLastName 2
      MyDevelopmentUnitName  3
      MyCompanyName          4
      MyCity                 5
      MT                     6
      BR                     7
      y                      8
      123456                 9
    }                                //firstPart:= SplitStr(aux, ' ');

    FormApksigner:=  TFormApksigner.Create(Application);
    FormApksigner.StatusBar1.SimplePanel:= True;
    FormApksigner.StatusBar1.SimpleText:= 'Build System: ' + buildSystem;

    FormApksigner.EditKeyStorePassword.Text:= auxList.Strings[0];   //123456

    strTemp:=auxList.Strings[2];
    FormApksigner.EditFirstName.Text:= SplitStr(strTemp, ' ');      //MyFirstName
    FormApksigner.EditLastName.Text:= strTemp;                      //MyLastName

    FormApksigner.EditOrgUnit.Text:= auxList.Strings[3];            //MyDevelopmentUnitName
    FormApksigner.EditOrgName.Text:=  auxList.Strings[4];            //MyCompanyName
    FormApksigner.EditCity.Text:= auxList.Strings[5];               //MyCity
    FormApksigner.EditProvince.Text:= auxList.Strings[6];           //MT
    FormApksigner.EditCodeCountry.Text:= auxList.Strings[7];        //BR
    FormApksigner.EditKeyAliasPassword.Text:= auxList.Strings[9];   //123456

    //Const
    FormApksigner.EditApkKeyAlias.Text:= Lowercase(SmallProjName)+'.keyalias';
    FormApksigner.EditApkKeyAlias.ReadOnly:= True;

    ks_pass:= auxList.Strings[0];
    key_pass:= auxList.Strings[9];

    keystoreExists:= False;
    if FileExists(PathToAndroidProject  +  DirectorySeparator +  SmallProjName+'-release.keystore') then
    begin
      ShowMessage('[ File "'+SmallProjName+'-release.keystore" Exists!'+sLineBreak+' Using existing "'+SmallProjName+'-release.keystore" ');

      keystoreExists:= True;

      tempList.Clear;
      tempList.Add('         Credentials Data');
      tempList.Add(    '"'+SmallProjName+'-release.keystore"');
      tempList.Add(' ');
      tempList.Add('[File] Key Store Password: ' + auxList.Strings[0]);
      strTemp:=auxList.Strings[2];
      tempList.Add('First Name: '+ SplitStr(strTemp, ' '));
      tempList.Add('Last Name: ' + strTemp);
      tempList.Add('Organizational Unit: ' + auxList.Strings[3]);
      tempList.Add('Organization Name: ' + auxList.Strings[4]);
      tempList.Add('City or Locality: ' + auxList.Strings[5]);
      tempList.Add('State or Province: ' + auxList.Strings[6]);
      tempList.Add('Country: ' + auxList.Strings[7]);

      tempList.Add('[Apk] Key Alias: '+Lowercase(SmallProjName)+'.keyalias');
      tempList.Add('[Apk] Key Alias Password: ' + auxList.Strings[9]);
      tempList.Add(' ');
      tempList.Add('                         Project Build System: ' + buildSystem);
      ShowMessage(tempList.Text);

    end;

    if not keystoreExists then
    begin
      if FormApksigner.ShowModal = mrOk then
      begin

          ShowMessage('warning: "'+smallProjName+'-release.keystore" file created only once [per application]');

          ks_pass:= FormApksigner.EditKeyStorePassword.Text;
          key_pass:= FormApksigner.EditKeyAliasPassword.Text;

          auxList.Clear;
          auxList.Add(ks_pass);
          auxList.Add(ks_pass);  //confirm
          auxList.Add(FormApksigner.EditFirstName.Text+ ' '+ FormApksigner.EditLastName.Text);
          auxList.Add(FormApksigner.EditOrgUnit.Text);
          auxList.Add(FormApksigner.EditOrgName.Text);
          auxList.Add(FormApksigner.EditCity.Text);
          auxList.Add(FormApksigner.EditProvince.Text);
          auxList.Add(FormApksigner.EditCodeCountry.Text);
          auxList.Add('y');
          auxList.Add(key_pass);
          auxList.SaveToFile(PathToAndroidProject +  DirectorySeparator + 'keytool_input.txt');

          { ant.properties
          key.store=applamwproject9-release.keystore
          key.alias=applamwproject9.keyalias
          key.store.password=123456
          key.alias.password=123456
          }

          auxList.Clear;
          auxList.Add('key.store='+ Lowercase(SmallProjName)+'-release.keystore');
          auxList.Add('key.alias='+ Lowercase(SmallProjName)+'.keyalias');
          auxList.Add('key.store.password='+ks_pass);
          auxList.Add('key.alias.password='+key_pass);
          auxList.SaveToFile(PathToAndroidProject +  DirectorySeparator + 'ant.properties');

          //release-keystore.bat
          try
            AProcess:= TProcess.Create(nil);
            AProcess.CurrentDirectory:= PathToAndroidProject;

            {$IFDEF Windows}
            AProcess.Executable := 'c:\windows\system32\cmd.exe';
            AProcess.Parameters.Add('/c');  //Executes the command(s) in command and then quits.
            AProcess.Parameters.Add('release-keystore.bat');
            {$ENDIF Windows}

            {$IFDEF Unix}
            AProcess.Executable := '/bin/sh';
            AProcess.Parameters.Add('-c');
            AProcess.Parameters.Add(PathToAndroidProject +'/release-keystore.sh');
            {$ENDIF Unix}

            AProcess.Options:= AProcess.Options + [poWaitOnExit];
            AProcess.Execute;
          finally
            AProcess.Free;
          end;

          keystoreExists:= True;
      end;//showForm
    end;

    if keystoreExists then
    begin

      //gradle.properties
      auxList.Clear;
      auxList.LoadFromFile(PathToAndroidProject +  DirectorySeparator + 'gradle.properties');
      savedGradleProperties:= auxList.Text;
      auxList.Clear;  
      auxList.Add('RELEASE_STORE_FILE = '+ Lowercase(SmallProjName)+'-release.keystore');
      auxList.Add('RELEASE_KEY_ALIAS = '+ Lowercase(SmallProjName)+'.keyalias');
      auxList.Add('RELEASE_STORE_PASSWORD = '+ks_pass);
      auxList.Add('RELEASE_KEY_PASSWORD = '+key_pass);
      auxList.Add(savedGradleProperties);
      auxList.SaveToFile(PathToAndroidProject +  DirectorySeparator + 'gradle.properties');
      
      tempList.Clear;
      tempList.LoadFromFile(PathToAndroidProject  +  DirectorySeparator +  'build.gradle');
      savedBuildGradle:= tempList.Text;

      if Pos('signingConfigs', tempList.Text) <= 0 then
      begin
        signList:= TStringList.Create;
        signList.Add('    signingConfigs {');
        signList.Add('        release {');
        signList.Add('            storeFile file(RELEASE_STORE_FILE)');
        signList.Add('            storePassword RELEASE_STORE_PASSWORD');
        signList.Add('            keyAlias RELEASE_KEY_ALIAS');
        signList.Add('            keyPassword RELEASE_KEY_PASSWORD');
        signList.Add('        }');
        signList.Add('    }');
        signList.Add('    buildTypes {');
        signList.Add('        release {');
        signList.Add('            signingConfig signingConfigs.release');
        signList.Add('        }');
        signList.Add('    }');
        strTemp:= tempList.Text;  //build.gradle
        p1:= Pos('sourceSets', tempList.Text);
        Insert(sLineBreak + signList.Text + sLineBreak, strTemp, p1-1);
        tempList.Clear;
        tempList.Text:= strTemp;
        tempList.SaveToFile(PathToAndroidProject  +  DirectorySeparator +  'build.gradle');
        signList.Free;
      end;

      //gradle-local-build-bundle.bat
      try
        bundleList:= TStringList.Create;
        bundleList.Add('@echo on');
        bundleList.Add('cmd.exe /c gradle-local-build-bundle.bat');
        bundleList.Add('jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore' + ' ' + Lowercase(SmallProjName)+ '-release.keystore' + ' ' +PathToAndroidProject+'\build\outputs\bundle\release\'+SmallProjName+'-release.aab'  + ' '  + Lowercase(SmallProjName)+'.keyalias' + ' < keytool_input.txt' );
        bundleList.Add('pause');
        bundleList.SaveToFile(PathToAndroidProject+PathDelim+'signer-bundle.bat');
        bundleList.Clear;
        bundleList.Add('#!/bin/bash');
        bundleList.Add('./gradle-local-build-bundle.sh');
        bundleList.Add('jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore' + ' ' + Lowercase(SmallProjName)+ '-release.keystore' + ' ' +PathToAndroidProject+'/build/outputs/bundle/release/'+SmallProjName+'-release.aab' + ' '+  Lowercase(SmallProjName)+'.keyalias' + ' < keytool_input.txt' );
        bundleList.Add('echo "Press ENTER to exit"');
        bundleList.Add('read');
        SaveShellScript(bundleList,PathToAndroidProject+PathDelim+'signer-bundle.sh');
          AProcess:= TProcess.Create(nil);
          AProcess.CurrentDirectory:= PathToAndroidProject;

          {$IFDEF Windows}
          AProcess.Executable := 'c:\windows\system32\cmd.exe';
          AProcess.Parameters.Add('/c');  //Executes the command(s) in command and then quits.
          AProcess.Parameters.Add('signer-bundle.bat');
          {$ENDIF Windows}

          {$IFDEF Unix}
          AProcess.Executable := '/bin/sh';
          AProcess.Parameters.Add('-c');
          AProcess.Parameters.Add(PathToAndroidProject+'/signer-bundle.sh');
          {$ENDIF Unix}

          AProcess.Options:= AProcess.Options + [poWaitOnExit {$IFDEF Unix} ,poUsePipes,poNewConsole {$ENDIF Unix} ];
          AProcess.Execute;
      finally
          AProcess.Free;
      end;

      ShowMessage('[Gradle] Success!! Look for your signed bundle "'+SmallProjName+'.aab" '+sLineBreak+
                    'in [project] folder "...\build\outputs\bundle\release"' );

      //restore
      tempList.Clear;
      tempList.Text:= savedBuildGradle;
      tempList.SaveToFile(PathToAndroidProject  +  DirectorySeparator +  'build.gradle');

      //restore
      auxList.Clear;
      auxList.Text:= savedGradleProperties;
      auxList.SaveToFile(PathToAndroidProject +  DirectorySeparator + 'gradle.properties');

    end;
    tempList.Free;
    auxList.Free;
    bundleList.Free;
  end
  else
    ShowMessage('The active project not is a LAMW project!');
end;

function GetResSourcePath(fullPathToProjectLFM: string): string;
var
  p: integer;
begin
  p:= Pos('jni', fullPathToProjectLFM);
  Result:= Copy(fullPathToProjectLFM, 1, p-1) + 'res';
end;

function GetPathToSmartDesigner(): string;
var
  Pkg: TIDEPackage;
begin
  Pkg:=PackageEditingInterface.FindPackageWithName('lazandroidwizardpack');
  if Pkg<>nil then
  begin
      Result:= ExtractFilePath(Pkg.Filename) + 'smartdesigner' ;
      //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
  end;
end;

function TryCleanUpThemeExtension(input: string): string;
var
  aux, aux2: string;
begin
   aux:= StringReplace(input,'.','',[rfReplaceAll,rfIgnoreCase]);
   aux2:= StringReplace(aux,' ','',[rfReplaceAll,rfIgnoreCase]);
   aux:= StringReplace(aux2,'-','',[rfReplaceAll,rfIgnoreCase]);
   aux2:= StringReplace(aux,'@','',[rfReplaceAll,rfIgnoreCase]);
   Result:= StringReplace(aux2,'_','',[rfReplaceAll,rfIgnoreCase]);
end;

procedure ExportAsAppTemplate(Sender: TObject);  //unitFormExportProjectAsTemplate
var
  Project: TLazProject;
  {package,} pathToProject, fileName, smallProjName: string;
  aux, pathToSmartDesigner, projectTheme, newTheme, pathToNewTemplate: string;
  FormExportProjectAsTemplate: TFormExportProjectAsTemplate;
  auxList: TStringList;
  templateFiles,  codeList: TStringList;
  i, count, p: integer;
begin
  Project:= LazarusIDE.ActiveProject;

  if not Assigned(Project) then Exit;

  if Project.CustomData.Values['LAMW'] = 'GUI' then
  begin

      projectTheme:= Project.CustomData['Theme'];
      //package:= Project.CustomData.Values['Package'];

      p:= Pos(DirectorySeparator+'jni', Project.ProjectInfoFile);
      pathToProject:= Copy(Project.ProjectInfoFile, 1, p-1);
      //pathToProjectJavaSrc:= pathToProject+DirectorySeparator+'src'+DirectorySeparator+StringReplace(package,'.',DirectorySeparator,[rfReplaceAll,rfIgnoreCase]);

      auxList:= TStringList.Create;
      auxList.StrictDelimiter:= True;
      auxList.Delimiter:= DirectorySeparator;
      auxList.DelimitedText:= TrimChar(pathToProject, DirectorySeparator);
      smallProjName:=  auxList.Strings[auxList.Count-1];; //AppLAMWProject10
      auxList.Free;

      pathToSmartDesigner:= GetPathToSmartDesigner();//C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner

      FormExportProjectAsTemplate:=  TFormExportProjectAsTemplate.Create(Application);
      FormExportProjectAsTemplate.StatusBar1.SimplePanel:= True;
      //FormExportProjectAsTemplate.StatusBar1.SimpleText:=
      FormExportProjectAsTemplate.EditTheme.Text:= projectTheme;
      FormExportProjectAsTemplate.EditTheme.Enabled:= False;
      FormExportProjectAsTemplate.EditThemeExt.Text:= smallProjName;
      FormExportProjectAsTemplate.PathToTemplateFolder:= pathToSmartDesigner + PathDelim + 'AppTemplates';
      if FormExportProjectAsTemplate.ShowModal = mrOk then
      begin
         if ForceDirectories(pathToSmartDesigner + PathDelim + 'AppTemplates') then
         begin
            aux:= TryCleanUpThemeExtension(FormExportProjectAsTemplate.EditThemeExt.Text);
            newTheme:= projectTheme + '.' +  aux;
            pathToNewTemplate:= pathToSmartDesigner + PathDelim + 'AppTemplates' + PathDelim +  newTheme;
            if ForceDirectories(pathToNewTemplate) then
            begin
               CopyFile(pathToProject+PathDelim+'AndroidManifest.xml', pathToNewTemplate+PathDelim+'AndroidManifest.xml');
               CopyFile(pathToProject+PathDelim+'build.gradle', pathToNewTemplate+PathDelim+'build.gradle');

               if ForceDirectories(pathToNewTemplate + PathDelim + 'jni') then
               begin
                 templateFiles:= TStringList.Create;
                 codeList:= TStringList.Create;
                 try
                   FindAllFiles(templateFiles, pathToProject + PathDelim + 'jni', '*.pas;*.lfm;*.lpi', False);
                   count:=  templateFiles.Count;
                   for i:= 0 to count-1 do
                   begin   //{Hint: save all files to location
                      fileName:= ExtractFileName(templateFiles.Strings[i]);
                      codeList.LoadFromFile(templateFiles.Strings[i]);

                      if Pos('.pas', fileName) > 0 then
                      begin
                        if Pos('UNIT ', Uppercase(codeList.Strings[0])) <= 0 then //cleanup
                          codeList.Delete(0);  //clean up ...
                      end;
                      codeList.SaveToFile(pathToNewTemplate + PathDelim + 'jni'+ PathDelim + fileName);
                      //CopyFile(templateFiles.Strings[i], pathToNewTemplate + PathDelim + 'jni'+ PathDelim + fileName);
                   end;
                 finally
                   codeList.Free;
                   templateFiles.Free;
                 end;
               end;

               if ForceDirectories(pathToNewTemplate+PathDelim + 'assets') then
               begin
                 templateFiles:= TStringList.Create;
                 try
                   FindAllFiles(templateFiles, pathToProject + PathDelim + 'assets', '*.*', False);
                   count:=  templateFiles.Count;
                   for i:= 0 to count-1 do
                   begin
                      fileName:= ExtractFileName(templateFiles.Strings[i]);
                      CopyFile(templateFiles.Strings[i], pathToProject + PathDelim + 'assets'+ PathDelim + fileName);
                   end;
                 finally
                   templateFiles.Free;
                 end;
               end;

               if ForceDirectories(pathToNewTemplate+PathDelim + 'res' + PathDelim + 'drawable') then
               begin
                 templateFiles:= TStringList.Create;
                 try
                   FindAllFiles(templateFiles, pathToProject + PathDelim + 'res' +PathDelim+'drawable', '*.*', False);
                   count:=  templateFiles.Count;
                   for i:= 0 to count-1 do
                   begin
                      fileName:= ExtractFileName(templateFiles.Strings[i]);
                      CopyFile(templateFiles.Strings[i], pathToNewTemplate+PathDelim + 'res' + PathDelim + 'drawable'+ PathDelim + fileName);
                   end;
                 finally
                   templateFiles.Free;
                 end;
               end;

               if ForceDirectories(pathToNewTemplate+PathDelim + 'res' + PathDelim + 'drawable-hdpi') then
               begin
                 templateFiles:= TStringList.Create;
                 try
                   FindAllFiles(templateFiles, pathToProject + PathDelim + 'res' +PathDelim+'drawable-hdpi', '*.*', False);
                   count:=  templateFiles.Count;
                   for i:= 0 to count-1 do
                   begin
                      fileName:= ExtractFileName(templateFiles.Strings[i]);
                      CopyFile(templateFiles.Strings[i], pathToNewTemplate+PathDelim + 'res' + PathDelim + 'drawable-hdpi'+ PathDelim + fileName);
                   end;
                 finally
                   templateFiles.Free;
                 end;
               end;

               if ForceDirectories(pathToNewTemplate+PathDelim + 'res' + PathDelim + 'drawable-mdpi') then
               begin
                 templateFiles:= TStringList.Create;
                 try
                   FindAllFiles(templateFiles, pathToProject + PathDelim + 'res' +PathDelim+'drawable-mdpi', '*.*', False);
                   count:=  templateFiles.Count;
                   for i:= 0 to count-1 do
                   begin
                      fileName:= ExtractFileName(templateFiles.Strings[i]);
                      CopyFile(templateFiles.Strings[i], pathToNewTemplate+PathDelim + 'res' + PathDelim + 'drawable-mdpi'+ PathDelim + fileName);
                   end;
                 finally
                   templateFiles.Free;
                 end;
               end;

               if ForceDirectories(pathToNewTemplate+PathDelim + 'res' + PathDelim + 'drawable-xhdpi') then
               begin
                 templateFiles:= TStringList.Create;
                 try
                   FindAllFiles(templateFiles, pathToProject + PathDelim + 'res' +PathDelim+'drawable-xhdpi', '*.*', False);
                   count:=  templateFiles.Count;
                   for i:= 0 to count-1 do
                   begin
                      fileName:= ExtractFileName(templateFiles.Strings[i]);
                      CopyFile(templateFiles.Strings[i], pathToNewTemplate+PathDelim + 'res' + PathDelim + 'drawable-xhdpi'+ PathDelim + fileName);
                   end;
                 finally
                   templateFiles.Free;
                 end;
               end;

               if ForceDirectories(pathToNewTemplate+PathDelim + 'res' + PathDelim + 'drawable-xxhdpi') then
               begin
                 templateFiles:= TStringList.Create;
                 try
                   FindAllFiles(templateFiles, pathToProject + PathDelim + 'res' +PathDelim+'drawable-xxhdpi', '*.*', False);
                   count:=  templateFiles.Count;
                   for i:= 0 to count-1 do
                   begin
                      fileName:= ExtractFileName(templateFiles.Strings[i]);
                      CopyFile(templateFiles.Strings[i], pathToNewTemplate+PathDelim + 'res' + PathDelim + 'drawable-xxhdpi'+ PathDelim + fileName);
                   end;
                 finally
                   templateFiles.Free;
                 end;
               end;

               if ForceDirectories(pathToNewTemplate+PathDelim + 'res' + PathDelim + 'raw') then
               begin
                 templateFiles:= TStringList.Create;
                 try
                   FindAllFiles(templateFiles, pathToProject + PathDelim + 'res' +PathDelim+'raw', '*.*', False);
                   count:=  templateFiles.Count;
                   for i:= 0 to count-1 do
                   begin
                      fileName:= ExtractFileName(templateFiles.Strings[i]);
                      CopyFile(templateFiles.Strings[i], pathToNewTemplate+PathDelim + 'res' + PathDelim + 'raw'+ PathDelim + fileName);
                   end;
                 finally
                   templateFiles.Free;
                 end;
               end;

               if ForceDirectories(pathToNewTemplate+PathDelim + 'res' + PathDelim + 'xml') then
               begin
                 templateFiles:= TStringList.Create;
                 try
                   FindAllFiles(templateFiles, pathToProject + PathDelim + 'res' +PathDelim+'xml', '*.*', False);
                   count:=  templateFiles.Count;
                   for i:= 0 to count-1 do
                   begin
                      fileName:= ExtractFileName(templateFiles.Strings[i]);
                      CopyFile(templateFiles.Strings[i], pathToNewTemplate+PathDelim + 'res' + PathDelim + 'xml'+ PathDelim + fileName);
                   end;
                 finally
                   templateFiles.Free;
                 end;
               end;

               {
               pathToNewTemplateJavaSrc:= pathToNewTemplate+PathDelim + 'src' + PathDelim + StringReplace(package,'.',PathDelim,[rfReplaceAll,rfIgnoreCase]);
               if ForceDirectories(pathToNewTemplateJavaSrc) then
               begin
                 templateFiles:= TStringList.Create;
                 try
                   FindAllFiles(templateFiles, pathToProjectJavaSrc,'*.java', False);
                   count:=  templateFiles.Count;
                   for i:= 0 to count-1 do
                   begin
                      fileName:= ExtractFileName(templateFiles.Strings[i]);
                      CopyFile(templateFiles.Strings[i], pathToNewTemplateJavaSrc + PathDelim + fileName);
                   end;
                 finally
                   templateFiles.Free;
                 end;
               end;  }
               ShowMessage('Success!! The ' +smallProjName+ sLineBreak + 'was exported as Template/Theme Project! ');

            end;
         end;
      end;
      FormExportProjectAsTemplate.Free;
  end
  else
    ShowMessage('Sorry, the active project is not a LAMW project!');
end;

procedure StartImportLAMWStuff(Sender: TObject);
var
  Project: TLazProject;
  listProject: TStringList;
  listUnit: TStringList;
  listComponent: TStringList;
  listTemp: TStringList;
  listProjComp, unitsList, imagesList: TStringList;
  fileName: string;
  pathToProject: string;
  p, i, k, count, j: integer;
  compName: string;
  pathToJavaTemplates: string;
  package, pathToJavasSrc: string;
  fullPathToUnitTarget, fullPathToUnitSourceLFM, fullPathToResSource, fullPathToResTarget: string;
  listIndex: integer;
  tempStr, targetFormName, sourceFormName: string;
  drawable_hdpi_checked, drawable_checked: boolean;
  fullImageFilename, shortImageFilename: string;
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

     //try import images from drawable....
     fullPathToResSource:= GetResSourcePath(FormImportLAMWStuff.EditSource.Text);
     fullPathToResTarget:= pathToProject + 'res';

     FormImportLAMWStuff.CheckGroupImages.Checked[0]:= True;   //drawable-hdpi
     if DirectoryExists(fullPathToResSource+DirectorySeparator+'drawable') then
       FormImportLAMWStuff.CheckGroupImages.Checked[1]:= True
     else
       FormImportLAMWStuff.CheckGroupImages.Checked[1]:= False;

     if FormImportLAMWStuff.ShowModal = mrOK then
     begin

         drawable_hdpi_checked:= FormImportLAMWStuff.CheckGroupImages.Checked[0];
         drawable_checked:= FormImportLAMWStuff.CheckGroupImages.Checked[1];

         listIndex:= FormImportLAMWStuff.ListBoxTarget.ItemIndex;
         fullPathToUnitSourceLFM:= FormImportLAMWStuff.EditSource.Text;

         if  (listIndex >= 0) and (fullPathToUnitSourceLFM <> '') then
         begin
            targetFormName:= listProjComp.Strings[listIndex]; //AndroidModule1 listIndex = selected unit to be replaced...
            fullPathToUnitTarget:=  unitsList.Strings[listIndex]; //.lfm
            fullPathToUnitTarget:= ChangeFileExt(fullPathToUnitTarget, '.pas');

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
                     if FileExists(pathToJavaTemplates+PathDelim+compName+'.java')  then
                     begin
                       listComponent.Add(compName);
                     end;
                  end;
                end;
              end;
            end else ShowMessage('Fail. None [target] LAMW Form were selected...');
         end else ShowMessage('Fail. None [candidate] Unit were selected...');
     end;
     if unitsList <> nil then unitsList.Free;
  end;

  if listComponent.Count > 0 then
  begin

    for i:= 0 to listComponent.Count-1 do
    begin
       if not FileExists(pathToJavasSrc+PathDelim+listComponent.Strings[i]+'.java') then
       begin
          listTemp.LoadFromFile(pathToJavaTemplates+PathDelim+listComponent.Strings[i]+'.java');
          listTemp.Strings[0]:= 'package '+ package +';';
          listTemp.SaveToFile(pathToJavasSrc+PathDelim+listComponent.Strings[i]+'.java');
       end;
    end;

    listTemp.Clear;
    listTemp.LoadFromFile(fullPathToUnitSourceLFM);
    tempStr:=StringReplace(listTemp.Text, sourceFormName, targetFormName, [rfReplaceAll, rfIgnoreCase]);
    listTemp.Text:= tempStr;
    //ShowMessage(fullPathToUnitTarget);
    listTemp.SaveToFile(ChangeFileExt(fullPathToUnitTarget, '.lfm'));

    listTemp.Clear;
    listTemp.LoadFromFile(ChangeFileExt(fullPathToUnitSourceLFM, '.pas'));
    tempStr:=StringReplace(listTemp.Text, sourceFormName, targetFormName, [rfReplaceAll, rfIgnoreCase]);
    listTemp.Text:= tempStr;
    listTemp.Strings[0]:= 'unit '+ChangeFileExt(ExtractFileName(fullPathToUnitTarget),'') +';';
    listTemp.Strings[1]:='//';
    listTemp.SaveToFile(fullPathToUnitTarget);

    //listComponent.Add('jForm');
    Project.Files[listIndex+1].CustomData['jControls']:= listComponent.DelimitedText;

    if drawable_hdpi_checked then
    begin
      imagesList:= FindAllFiles(fullPathToResSource+DirectorySeparator+'drawable-hdpi', '*.*', False);
      if imagesList <> nil then
      begin
         count:= imagesList.Count;
         for j:= 0 to count-1 do
         begin
           shortImageFilename:= ExtractFileName(imagesList.Strings[j]);
           fullImageFilename:= fullPathToResTarget + DirectorySeparator+'drawable-hdpi' + DirectorySeparator + shortImageFilename;
           if not FileExists(fullImageFilename) then
           begin
              CopyFile(imagesList.Strings[j],fullImageFilename);
           end;
         end;
         imagesList.Free;
      end;
    end;

    if drawable_checked then
    begin
      if DirectoryExists(fullPathToResSource+DirectorySeparator+'drawable') then
      begin
        imagesList:= FindAllFiles(fullPathToResSource+DirectorySeparator+'drawable', '*.*', False);
        if imagesList <> nil then
        begin
           count:= imagesList.Count;
           for j:= 0 to count-1 do
           begin
             shortImageFilename:= ExtractFileName(imagesList.Strings[j]);
             fullImageFilename:= fullPathToResTarget + DirectorySeparator+'drawable' + DirectorySeparator + shortImageFilename;
             if not FileExists(fullImageFilename) then
             begin
                CopyFile(imagesList.Strings[j],fullImageFilename);
             end;
           end;
           imagesList.Free;
        end;
      end;
    end;
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
     if fullPathToUnitSourceLFM <> '' then
     begin
       if FileExists(fullPathToUnitSourceLFM) then
       begin
         listTemp.LoadFromFile(fullPathToUnitSourceLFM);
         tempStr:=StringReplace(listTemp.Text, sourceFormName, targetFormName, [rfReplaceAll, rfIgnoreCase]);
         listTemp.Text:= tempStr;
         //ShowMessage(fullPathToUnitTarget);
         listTemp.SaveToFile(ChangeFileExt(fullPathToUnitTarget, '.lfm'));

         listTemp.Clear;
         listTemp.LoadFromFile(ChangeFileExt(fullPathToUnitSourceLFM, '.pas'));
         tempStr:=StringReplace(listTemp.Text, sourceFormName, targetFormName, [rfReplaceAll, rfIgnoreCase]);
         listTemp.Text:= tempStr;
         listTemp.Strings[0]:= 'unit '+ChangeFileExt(ExtractFileName(fullPathToUnitTarget),'') +';';
         listTemp.Strings[1]:='//';
         listTemp.SaveToFile(fullPathToUnitTarget);

         //import images from drawable....
         if drawable_hdpi_checked then
         begin
           imagesList:= FindAllFiles(fullPathToResSource+DirectorySeparator+'drawable-hdpi', '*.*', False);
           if imagesList <> nil then
           begin
              count:= imagesList.Count;
              for j:= 0 to count-1 do
              begin
                shortImageFilename:= ExtractFileName(imagesList.Strings[j]);
                fullImageFilename:= fullPathToResTarget + DirectorySeparator+'drawable-hdpi' + DirectorySeparator + shortImageFilename;
                if not FileExists(fullImageFilename) then
                begin
                   CopyFile(imagesList.Strings[j],fullImageFilename);
                end;
              end;
              imagesList.Free;
           end;
         end;

         if drawable_checked then
         begin
           if DirectoryExists(fullPathToResSource+DirectorySeparator+'drawable') then
           begin
               imagesList:= FindAllFiles(fullPathToResSource+DirectorySeparator+'drawable', '*.*', False);
               if imagesList <> nil then
               begin
                  count:= imagesList.Count;
                  for j:= 0 to count-1 do
                  begin
                    shortImageFilename:= ExtractFileName(imagesList.Strings[j]);
                    fullImageFilename:= fullPathToResTarget + DirectorySeparator+'drawable' + DirectorySeparator + shortImageFilename;
                    if not FileExists(fullImageFilename) then
                    begin
                       CopyFile(imagesList.Strings[j],fullImageFilename);
                    end;
                  end;
                  imagesList.Free;
               end;
           end;
         end;
         ShowMessage('Sucess!! Imported form LAMW Stuff !!' +sLineBreak +
                    'Hints:'+ sLineBreak +
                    '.For each import,  "Run --> Build" and accept "Reload checked files from disk" !' + sLineBreak +
                    '.(Re)"Open" the project to update the form display content ...' + sLineBreak +
                    '      Or close the form unit tab and reopen it [Project Inspector...]'+ sLineBreak +
                    '      to see the content changes...');
       end;
     end;
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

  ideMnuLAMWBuild: TIDEMenuCommand;
  ideMnuLAMWExplorer: TIDEMenuCommand;

  CmdMyTool: TIDECommand;
  CmdMyExplorer: TIDECommand;

  Key: TIDEShortCut;
  Cat: TIDECommandCategory;
  Pkg: TIDEPackage;
  pathToLamwIcon: string;   //IDEImagesIntf
begin
  pathToLamwIcon:= '';
  Pkg:=PackageEditingInterface.FindPackageWithName('amw_ide_tools');
  if Pkg<>nil then
  begin
      pathToLamwIcon:= ExtractFilePath(Pkg.Filename);
      pathToLamwIcon:= pathToLamwIcon + 'lemurgreen.bmp';
      if not FileExists(pathToLamwIcon) then pathToLamwIcon:= '';
      //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
  end;
  // Register main LAMW menu
  ideMnuAMW:= RegisterIDEMenuSection(mnuTools,'LAMW');

  // Register submenu
  ideSubMnuAMW:= RegisterIDESubMenu(ideMnuAMW, 'LAMW', '[LAMW] Android Module Wizard');
  if pathToLamwIcon <> '' then ideSubMnuAMW.Bitmap.LoadFromFile(pathToLamwIcon);

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
  //RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToFPCTrunkSource', 'Get FPC Source [Trunk]', nil, @StartFPCTrunkSource);
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

  //Adding 14a. entry
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToExportToTemplateForm', 'Export LAMW Project as Template/Theme...', nil, @ExportAsAppTemplate);

  //Register submenu AppCompat
  ideSubMnuAppCompat:= RegisterIDESubMenu(ideSubMnuAMW, 'ConvertToAppCompat', 'Convert the Project to AppCompat Theme');
  //Adding first entry
  RegisterIDEMenuCommand(ideSubMnuAppCompat, 'AppCompatDarkActionBar', 'AppCompatDarkActionBar', nil, @StartAppCompatDarkActionBar);
  RegisterIDEMenuCommand(ideSubMnuAppCompat, 'AppCompatNoActionBar', 'AppCompatNoActionBar', nil, @StartAppCompatNoActionBar);

  //Register submenu release apksigner
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToApksignerForm', 'Build Release Signed Apk ...', nil, @StartApkSignerStuff);
  RegisterIDEMenuCommand(ideSubMnuAMW, 'PathToBundlesignerForm', 'Build Release Signed Bundle ...', nil, @StartBundleSignerStuff);


  // Register submenu  Logcat
  ideSubMnuLog:= RegisterIDESubMenu(ideSubMnuAMW, 'Logcatch', 'ADB Logcat');

  RegisterIDEMenuCommand(ideSubMnuLog, 'PathToLogcatd', 'Logcat -d [dump]', nil, @StartLogcatDump);
  RegisterIDEMenuCommand(ideSubMnuLog, 'PathToLogcatc', 'Logcat -c [clear]', nil, @StartLogcatClear);


  //Build apk/Run
   Key := IDEShortCut(VK_F1,[ssCtrl],VK_UNKNOWN,[]);
   Cat:=IDECommandList.FindCategoryByName(CommandCategoryToolMenuName);
   CmdMyTool := RegisterIDECommand(Cat,'BuildApkAndRun', '[LAMW] Build Android Apk and Run', Key, nil, @BuildApkAndRun);
   ideMnuLAMWBuild:= RegisterIDEMenuCommand(itmRunBuilding, 'LAMW Build Apk And Run', '[LAMW] Build Android Apk and Run', nil, nil, CmdMyTool);

   RegisterIDEMenuCommand(itmRunBuilding, 'LamwToolKitRun', '[LAMW] Run Android Apk...', nil, @RunLamwToolKit);

   if pathToLamwIcon <> '' then ideMnuLAMWBuild.Bitmap.LoadFromFile(pathToLamwIcon);

  //LAMW Explore  by marcos-ebm
   Key := IDEShortCut(VK_E,[ssAlt],VK_UNKNOWN,[]);
   Cat:=IDECommandList.FindCategoryByName(CommandCategoryToolMenuName);
   CmdMyExplorer := RegisterIDECommand(Cat,'LAMWExplorer', '', Key, nil, @RunLamwExplorer);
   ideMnuLAMWExplorer:= RegisterIDEMenuCommand(itmFileDirectories, 'LAMW Explorer', '[LAMW] Explorer', nil, nil, CmdMyExplorer);
   if pathToLamwIcon <> '' then ideMnuLAMWExplorer.Bitmap.LoadFromFile(pathToLamwIcon);

   ApkBuild.RegisterExtToolParser;
end;

end.
