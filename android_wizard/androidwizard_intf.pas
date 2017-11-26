unit AndroidWizard_intf;

{$Mode Delphi}

interface

uses
  Classes, SysUtils, FileUtil, Controls, Forms, Dialogs, Graphics,
  LCLProc, LCLType, LCLIntf, LazIDEIntf, ProjectIntf, FormEditingIntf,
  uFormAndroidProject, uformworkspace, FPimage, AndroidWidget;

type

  TAndroidModule = class(jForm)            //support to Adroid Bridges [components]
  end;

  TNoGUIAndroidModule = class(TDataModule) //raw JNI ".so"
  end;


  TAndroidConsoleDataForm = class(TDataModule) // executable console app
  end;

  { TAndroidProjectDescriptor }

  TAndroidProjectDescriptor = class(TProjectDescriptor)
   private
     FPascalJNIInterfaceCode: string;
     FJavaClassName: string;
     FPathToClassName: string;
     FPathToJNIFolder: string;
     FPathToNdkPlatforms: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
     FPathToNdkToolchains: string;
     {C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3}
     FInstructionSet: string;    {ArmV6}
     FFPUSet: string;            {Soft}
     //FDeviceType: string;
     FPathToJavaTemplates: string;
     FAndroidProjectName: string;
     FModuleType: integer;     {0: GUI; 1: NoGUI; 2: NoGUI EXE Console}
     FSyntaxMode: TSyntaxMode;   {}

     FPieChecked: boolean;
     FLibraryChecked: boolean;

     FPathToJavaJDK: string;
     FPathToAndroidSDK: string;
     FPathToAndroidNDK: string;
     FNDK: string;

     FPathToAntBin: string;
     FPathToGradle: string;

     FProjectModel: string;
     FPackagePrefaceName: string;
     FMinApi: string;
     FTargetApi: string;
     FSupportV4: string;
     FTouchtestEnabled: string;
     FAntBuildMode: string;
     FMainActivity: string;
     FPathToJavaSrc: string;
     FAndroidPlatform: string;

     FPrebuildOSys: string;

     FFullPackageName: string;
     FFullJavaSrcPath: string;
     FSmallProjName:  string; //ex. 'AppDemo1'

     FAndroidTheme: string;

     //FEclipseTooling: TEclipseTooling;

     function SettingsFilename: string;
     function TryNewJNIAndroidInterfaceCode(projectType: integer): boolean; //0: GUI  project --- 1:NoGUI project
     function GetPathToJNIFolder(fullPath: string): string;
     function GetWorkSpaceFromForm(projectType: integer; out outTag: integer): boolean;
     function GetAppName(className: string): string;

     function GetFolderFromApi(api: integer): string;
     function GetSdkBuildTools(var gradleVersion: string; var pluginVersion: string; var compileSdkVersion: string): string;

   public
     constructor Create; override;
     function GetLocalizedName: string; override;
     function GetLocalizedDescription: string; override;
     function DoInitDescriptor: TModalResult; override;
     function InitProject(AProject: TLazProject): TModalResult; override;
     function CreateStartFiles(AProject: TLazProject): TModalResult; override;
  end;

  { TAndroidGUIProjectDescriptor }

  TAndroidGUIProjectDescriptor = class(TAndroidProjectDescriptor)
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function DoInitDescriptor: TModalResult; override;
  end;

  TAndroidNoGUIExeProjectDescriptor = class(TAndroidProjectDescriptor)   //console executable App
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function DoInitDescriptor: TModalResult; override;
  end;

  TAndroidFileDescPascalUnitWithResource = class(TFileDescPascalUnitWithResource)
  private
    //
  public
    SyntaxMode: TSyntaxMode; {mdDelphi, mdObjFpc}
    PathToJNIFolder: string;
    ModuleType: integer;   //0: GUI; 1: No GUI ; 2: console executable App; 3: generic library

    constructor Create; override;

    function CreateSource(const Filename     : string;
                          const SourceName   : string;
                          const ResourceName : string): string; override;

    function GetInterfaceUsesSection: string; override;

    function GetInterfaceSource(const Filename     : string;
                                const SourceName   : string;
                                const ResourceName : string): string; override;

    function GetResourceType: TResourceType; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function GetImplementationSource(const Filename     : string;
                                     const SourceName   : string;
                                     const ResourceName : string): string; override;
  end;

var
  AndroidProjectDescriptor: TAndroidProjectDescriptor;
  AndroidFileDescriptor: TAndroidFileDescPascalUnitWithResource;

  AndroidGUIProjectDescriptor: TAndroidGUIProjectDescriptor;
  AndroidNoGUIExeProjectDescriptor: TAndroidNoGUIExeProjectDescriptor;


procedure Register;

function SplitStr(var theString: string; delimiter: string): string;

implementation

uses
   {$ifdef unix}BaseUnix,{$endif}
   LazFileUtils, uJavaParser, LamwDesigner, SmartDesigner;

procedure Register;
begin
  FormEditingHook.RegisterDesignerMediator(TAndroidWidgetMediator);
  AndroidFileDescriptor := TAndroidFileDescPascalUnitWithResource.Create;

  RegisterProjectFileDescriptor(AndroidFileDescriptor);

  AndroidProjectDescriptor:= TAndroidProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidProjectDescriptor);

  AndroidGUIProjectDescriptor:= TAndroidGUIProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidGUIProjectDescriptor);

  AndroidNoGUIExeProjectDescriptor:= TAndroidNoGUIExeProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidNoGUIExeProjectDescriptor);

  FormEditingHook.RegisterDesignerBaseClass(TAndroidModule);
  FormEditingHook.RegisterDesignerBaseClass(TNoGUIAndroidModule);
  FormEditingHook.RegisterDesignerBaseClass(TAndroidConsoleDataForm);

  LamwSmartDesigner.Init;
end;

{TAndroidNoGUIExeProjectDescriptor}

constructor TAndroidNoGUIExeProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create new [NoGUI] Android Exec Console App';
end;

function TAndroidNoGUIExeProjectDescriptor.GetLocalizedName: string;
begin
  Result:= 'Android Console App [Lamw]';
end;

function TAndroidNoGUIExeProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:=  'Android [NoGUI] Console Application'+ LineEnding +
            '[Native Executable]'+ LineEnding +
            'using datamodule like form.'+ LineEnding +
            'The project is maintained by Lazarus [Lamw].'
end;

function TAndroidNoGUIExeProjectDescriptor.DoInitDescriptor: TModalResult;    //NoGUI Exe
var
  list: TStringList;
  outTag: integer;
begin
  try
    FModuleType := 2; //0: GUI --- 1:NoGUI --- 2: NoGUI EXE Console  3: generic library
    FPathToClassName := '';
    if GetWorkSpaceFromForm(2, outTag) then
    begin

      FPathToJNIFolder := FAndroidProjectName;
      AndroidFileDescriptor.PathToJNIFolder:= FPathToJNIFolder;
      AndroidFileDescriptor.ModuleType:= 2; //Console

      if outTag = 3 then
      begin
        FModuleType:= 3;
        AndroidFileDescriptor.ModuleType:= 3; // generic/custom library
      end;

      CreateDir(FAndroidProjectName+DirectorySeparator+'build-modes');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'mips');
      CreateDir(FAndroidProjectName+DirectorySeparator+'obj');

      if FModuleType = 2 then //default
      begin
        list:= TStringList.Create;

        list.Add('How to Run your native console App in "AVD/Emulator"');
        list.Add(' ');
        list.Add('		NOTE 1: To get the executable app, go to Lazarus menu  ---> "Run" --> "Build"' );
        list.Add(' ');
        if FPieChecked then
        list.Add('		NOTE 2: Project settings: Target Api = '+FTargetApi+ ' and PIE enabled!' )
        else
        list.Add('		NOTE 2: Project settings: Targeg Api = '+FTargetApi+ ' and PIE  not enabled!' );

        list.Add(' ');
        list.Add('		NOTE 3: To run in a real device, please, "readme_How_To_Run_Real_Device.txt" [ref. http://kevinboone.net/android_native.html] ');
        list.Add(' ');
        list.Add('		NOTE 4: Android >=5.0 [Target API >= 21] need to enable PIE [Position Independent Executables]: ');
        list.Add(' ');
        list.Add('			"Project" --->> "Project Options" -->> "Compile Options" --->> "Compilation and Linking" ');
        list.Add('			--->> "Pas options to linker"  [check it !] and enter: -pie into edit below ');
        list.Add(' ');
        list.Add('		NOTE 5: Handle the form OnCreate event to start the program''s tasks!');
        list.Add(' ');
        list.Add('1. Execute the AVD/Emulator ');
        list.Add(' ');
        list.Add('2. Execute the  "cmd"  terminal [windows] ');
        list.Add(' ');
        list.Add('3. Go to folder  ".../skd/platform-tools"  and run the adb shell  [note: "-e" ---> emulator ... and "-d" ---> device] ');
        list.Add(' ');
        list.Add('adb -e shell ');
        list.Add(' ');
        list.Add('4. Create a new dir/folder "tmp" in  "/sdcard" ');
        list.Add(' ');
        list.Add('cd /sdcard ');
        list.Add(' ');
        list.Add('mkdir tmp ');
        list.Add(' ');
        list.Add('exit ');
        list.Add(' ');
        list.Add('5. Copy your program file  "'+LowerCase(FSmallProjName)+'" from project folder "...\libs\armeabi\" to Emulator "/sdcard/tmp" ');
        list.Add(' ');
        list.Add('adb push C:\adt32\workspace\'+FSmallProjName+'\libs\armeabi\'+LowerCase(FSmallProjName)+'  /sdcard/tmp/'+LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('6. go to "adb shell" again ');
        list.Add(' ');
        list.Add('adb -e shell. ');
        list.Add(' ');
        list.Add('7. Go to folder "/sdcard/tmp" ');
        list.Add(' ');
        list.Add('root@android:/ # cd /sdcard/tmp ');
        list.Add(' ');
        list.Add('8. Now copy your programa file "' + LowerCase(FSmallProjName)+'" to an executable place ');
        list.Add(' ');
        list.Add('root@android:/sdcard/tmp # cp ' + LowerCase(FSmallProjName)+' /data/local/tmp/'+LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('9. Go to folder /data/local/tmp and Change permission to run executable ');
        list.Add(' ');
        list.Add('root@android:/ # cd /data/local/tmp');
        list.Add('root@android:/data/local/tmp # chmod 755 ' + LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('10. Execute your program! ');
        list.Add(' ');
        list.Add('root@android:/data/local/tmp # ./' + LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('Hello Lamw''s World!');
        list.Add(' ');
        list.Add('11. Congratulations !!!! ');
        list.Add(' ');
        list.Add('    by jmpessoa_hotmail_com');
        list.Add(' ');
        list.Add('    Thanks to @gtyhn,  @engkin and Prof. Claudio Z. M. [Suggestion/Motivation] ');
        list.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme_How_To_Run_AVD_Emulator.txt');

        list.Clear;
        list.Add('How to run your native console app in "Real Device" [ref. http://kevinboone.net/android_native.html] ');
        list.Add(' ');
        list.Add('		NOTE 1: To get the executable app, go to Lazarus menu  ---> "Run" --> "Build"' );
        list.Add(' ');
        if FPieChecked then
        list.Add('		NOTE 2: Project settings: Target Api = '+FTargetApi+ ' and PIE enabled!' )
        else
        list.Add('		NOTE 2: Project settings: Targeg Api = '+FTargetApi+ ' and PIE  not enabled!' );

        list.Add(' ');
        list.Add('		NOTE 3: To run in AVD/Emulator, please, "readme_How_To_Run_AVD_Emulator.txt"');
        list.Add(' ');
        list.Add('		NOTE 4: Android >=5.0 [Target API >= 21] need to enable PIE [Position Independent Executables] enabled: ');
        list.Add(' ');
        list.Add('			"Project" --->> "Project Options" -->> "Compile Options" --->> "Compilation and Linking"');
        list.Add('			--->> "Pas options to linker"  [check it !] and enter: -pie into edit below');
        list.Add(' ');
        list.Add('		NOTE 5: Handle the form OnCreate event to start the program''s tasks!');
        list.Add(' ');
        list.Add('1. Go to Google Play Store and get "Terminal Emulador" by Jack Palevich [thanks to jack!]');
        list.Add(' ');
        list.Add('2. Connect PC <---> Device via an USB cable  and  copy your program file  "'+LowerCase(FSmallProjName)+'" from project folder "...\libs\armeabi\" to Device folder "Download"');
        list.Add(' ');
        list.Add('3. Go to your Device and run  the app "Terminal Emulador"  and go to internal "Terminal Emulador" storage folder');
        list.Add(' ');
        list.Add('$ cd /data/data/jackpal.androidterm/shared_prefs');
        list.Add(' ');
        list.Add('5. Copy [cat] your program file  "'+LowerCase(FSmallProjName)+'" from Device folder "Download" to internal "Terminal Emulador" storage folder');
        list.Add(' ');
        list.Add('$ cat /sdcard/Download/'+LowerCase(FSmallProjName)+' > '+LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('6. Change your program file  "'+LowerCase(FSmallProjName)+'" permission to "executable" mode');
        list.Add(' ');
        list.Add('$ chmod 755 '+LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('7. Execute your program!');
        list.Add(' ');
        list.Add('$ ./'+LowerCase(FSmallProjName));
        list.Add(' ');
        list.Add('Hello Lamw''s World!');
        list.Add(' ');
        list.Add('8. Congratulations !!!!');
        list.Add(' ');
        list.Add('    by jmpessoa_hotmail_com');
        list.Add(' ');
        list.Add('    Thanks to @gtyhn,  @engkin and Prof. Claudio Z. M. [Suggestion/Motivation]');

        list.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme_How_To_Run_Real_Device.txt');
        list.Free;
      end;

      Result := mrOK
    end else
      Result := mrAbort;
  except
    on e: Exception do
    begin
      MessageDlg('Error', e.Message, mtError, [mbOk], 0);
      Result := mrAbort;
    end;
  end;
end;

{ TAndroidGUIProjectDescriptor }

constructor TAndroidGUIProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create new [GUI] JNI Android Module (.so)';
end;

function TAndroidGUIProjectDescriptor.GetLocalizedName: string;
begin
  Result:= 'Android [GUI] JNI Module [Lamw]';
end;

function TAndroidGUIProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:=  'Android [GUI] JNI loadable module (.so)'+ LineEnding +
            'based on Simonsayz''s templates'+ LineEnding +
            'with Form Designer and Android Components Bridges.'+ LineEnding +
            'The project and library file are maintained by Lazarus [Lamw].';
  ActivityModeDesign:= actMain;  //main jForm
end;

function TAndroidGUIProjectDescriptor.DoInitDescriptor: TModalResult;    //GUI
var
  strAfterReplace, strPack, aux: string;
  auxList: TStringList;
  outTag: integer;
begin
  try
    FModuleType := 0; //0: GUI --- 1:NoGUI --- 2: NoGUI EXE Console
    FJavaClassName := 'Controls';
    FPathToClassName := '';
    if GetWorkSpaceFromForm(0, outTag) then //GUI
    begin
      with TStringList.Create do
        try
          strPack := FPackagePrefaceName + '.' + LowerCase(FSmallProjName);

          LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'Controls.java');
          Strings[0] := 'package ' + strPack + ';';  //replace dummy - Controls.java
          aux:=  StringReplace(Text, '/*libsmartload*/' ,
                 'try{System.loadLibrary("controls");} catch (UnsatisfiedLinkError e) {Log.e("JNI_Loading_libcontrols", "exception", e);}',
                 [rfReplaceAll,rfIgnoreCase]);
          Text:= aux;
          SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'Controls.java');

          Clear;
          LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'App.java');
          Strings[0] := 'package ' + strPack + ';'; //replace dummy App.java

          SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'App.java');

          CreateDir(FAndroidProjectName+DirectorySeparator+'lamwdesigner');

          if FileExists(FPathToJavaTemplates+DirectorySeparator + 'Controls.native') then
          begin
            CopyFile(FPathToJavaTemplates+DirectorySeparator + 'Controls.native',
              FAndroidProjectName+DirectorySeparator+'lamwdesigner'+DirectorySeparator+'Controls.native');
          end;

          if FileExists(FPathToJavaTemplates+DirectorySeparator +'lamwdesigner'+DirectorySeparator+ 'jCommons.java') then
          begin
            Clear;
            LoadFromFile(FPathToJavaTemplates+DirectorySeparator +'lamwdesigner'+DirectorySeparator+ 'jCommons.java');
            Strings[0] := 'package ' + strPack + ';';  //replace dummy
            SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'jCommons.java');
          end;

      finally
          Free;
      end;

      FPathToJNIFolder := FAndroidProjectName;
      AndroidFileDescriptor.PathToJNIFolder:= FPathToJNIFolder;
      AndroidFileDescriptor.ModuleType:= 0;

      with TJavaParser.Create(FFullJavaSrcPath + DirectorySeparator+  'Controls.java') do
      try
        FPascalJNIInterfaceCode := GetPascalJNIInterfaceCode(FPathToJavaTemplates + DirectorySeparator + 'ControlsEvents.txt');
      finally
        Free;
      end;

      CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni');
      CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'mips');
      CreateDir(FAndroidProjectName+DirectorySeparator+'obj');

      if  FModuleType < 2 then
        CreateDir(FAndroidProjectName+DirectorySeparator+'obj'+DirectorySeparator+'controls');

      if FSupportV4 = 'yes' then  //add android 4.0 support to olds devices ...
      begin
         if not FileExists(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar') then
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar',
                FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar');
      end;

      if FProjectModel = 'Ant' then
      begin
        auxList:= TStringList.Create;
        //eclipe compatibility [Neon!]
        CreateDir(FAndroidProjectName+DirectorySeparator+'.settings');
        auxList.Add('eclipse.preferences.version=1');
        auxList.Add('org.eclipse.jdt.core.compiler.codegen.targetPlatform=1.7');
        auxList.Add('org.eclipse.jdt.core.compiler.compliance=1.7');
        auxList.Add('org.eclipse.jdt.core.compiler.source=1.7');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.settings'+DirectorySeparator+'org.eclipse.jdt.core.prefs');
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
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.classpath');

        auxList.Clear;
        auxList.Add('<projectDescription>');
        auxList.Add('	<name>'+FSmallProjName+'</name>');
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
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.project');

        auxList.Clear;
        auxList.Add('# To enable ProGuard in your project, edit project.properties');
        auxList.Add('# to define the proguard.config property as described in that file.');
        auxList.Add('#');
        auxList.Add('# Add project specific ProGuard rules here.');
        auxList.Add('# By default, the flags in this file are appended to flags specified');
        auxList.Add('# in ${sdk.dir}/tools/proguard/proguard-android.txt');
        auxList.Add('# You can edit the include path and order by changing the ProGuard');
        auxList.Add('# include property in project.properties.');
        auxList.Add('#');
        auxList.Add('# For more details, see');
        auxList.Add('#   http://developer.android.com/guide/developing/tools/proguard.html');
        auxList.Add(' ');
        auxList.Add('# Add any project specific keep options here:');
        auxList.Add(' ');
        auxList.Add('# If your project uses WebView with JS, uncomment the following');
        auxList.Add('# and specify the fully qualified class name to the JavaScript interface');
        auxList.Add('# class:');
        auxList.Add('#-keepclassmembers class fqcn.of.javascript.interface.for.webview {');
        auxList.Add('#   public *;');
        auxList.Add('#}');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'proguard-project.txt');

        auxList.Clear;
        auxList.Add('# This file is automatically generated by Android Tools.');
        auxList.Add('# Do not modify this file -- YOUR CHANGES WILL BE ERASED!');
        auxList.Add('#');
        auxList.Add('# This file must be checked in Version Control Systems.');
        auxList.Add('#');
        auxList.Add('# To customize properties used by the Ant build system edit');
        auxList.Add('# "ant.properties", and override values to adapt the script to your');
        auxList.Add('# project structure.');
        auxList.Add('#');
        auxList.Add('# To enable ProGuard to shrink and obfuscate your code, uncomment this (available properties: sdk.dir, user.home):');
        auxList.Add('#proguard.config=${sdk.dir}/tools/proguard/proguard-android.txt:proguard-project.txt');
        auxList.Add(' ');
        auxList.Add('# Project target.');
        auxList.Add('target='+FTargetApi);
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'project.properties');
        auxList.Free;
      end;

      //AndroidManifest.xml creation:
      with TStringList.Create do
      try
        LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'AndroidManifest.txt');
        strAfterReplace  := StringReplace(Text, 'dummyPackage',strPack, [rfReplaceAll, rfIgnoreCase]);

        strPack:= strPack+'.'+FMainActivity; {gApp}
        strAfterReplace  := StringReplace(strAfterReplace, 'dummyAppName',strPack, [rfReplaceAll, rfIgnoreCase]);

        {fix bug  - 04 jan 2014}
        strAfterReplace  := StringReplace(strAfterReplace, 'dummySdkApi', FMinApi, [rfReplaceAll, rfIgnoreCase]);
        strAfterReplace  := StringReplace(strAfterReplace, 'dummyTargetApi', FTargetApi, [rfReplaceAll, rfIgnoreCase]);

        Clear;
        Text:= strAfterReplace;
        SaveToFile(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml');
      finally
        Free;
      end;

      Result := mrOK
    end else
      Result := mrAbort;
  except
    on e: Exception do
    begin
      MessageDlg('Error', e.Message, mtError, [mbOk], 0);
      Result := mrAbort;
    end;
  end;
end;

{TAndroidProjectDescriptor}

function TAndroidProjectDescriptor.SettingsFilename: string;
begin
  Result := IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini'
end;

function TAndroidProjectDescriptor.GetPathToJNIFolder(fullPath: string): string;
var
  i: integer;
begin
  //fix by Leledumbo - for linux compatility
  i:= Pos('src'+DirectorySeparator,fullPath);
  if i > 2 then
    Result:= Copy(fullPath,1,i - 2)// we don't need the trailing slash
  else raise Exception.Create('src folder not found...');
end;

function TAndroidProjectDescriptor.TryNewJNIAndroidInterfaceCode(projectType: integer): boolean;
var
  frm: TFormAndroidProject;
begin

  Result := False;
  FModuleType:= projectType; //0:GUI <--> 1:NoGUI <--> 2:NoGUI console Exe
  frm:= TFormAndroidProject.Create(nil);  //Create Form

  frm.PathToJavaTemplates:= FPathToJavaTemplates;
  frm.AndroidProjectName:= FAndroidProjectName;
  frm.MainActivity:= FMainActivity;
  frm.MinApi:= FMinApi;
  frm.TargetApi:= FTargetApi;
  frm.ProjectModel:= FProjectModel; //'Ant'  or 'Eclipse'
  frm.FullJavaSrcPath:= FFullJavaSrcPath;
  frm.ModuleType:= projectType;
  frm.SmallProjName := FSmallProjName;

  if frm.ShowModal = mrOK then
  begin

    FSyntaxMode:= frm.SyntaxMode;

    FPathToJNIFolder:= FAndroidProjectName;

    AndroidFileDescriptor.PathToJNIFolder:= FAndroidProjectName;
    AndroidFileDescriptor.ModuleType:= FModuleType;
    AndroidFileDescriptor.SyntaxMode:= FSyntaxMode;

    FPascalJNIInterfaceCode:= frm.PascalJNIInterfaceCode;
    FFullPackageName:= frm.FullPackageName;
    Result := True;
  end;
  frm.Free;
end;

constructor TAndroidProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create new [NoGUI] JNI Android Module (.so)';
end;

function TAndroidProjectDescriptor.GetLocalizedName: string;
begin
  Result := 'Android [NoGUI] JNI Module [Lamw]'; //fix thanks to Stephano!
end;

function TAndroidProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := 'Android [NoGUI] JNI loadable module (.so)'+ LineEnding +
            'using datamodule like form.'+ LineEnding +
            'No Form Designer/Android and no Components Bridges!'+ LineEnding +
            'The project and library are maintained by Lazarus [Lamw].'
end;

     //just for test!  not realistic!
function TAndroidProjectDescriptor.GetFolderFromApi(api: integer): string;
begin
  Result:= 'android-x.y';
  case api of
     17: Result:= 'android-4.2.2';
     18: Result:= 'android-4.3';
     19: Result:= 'android-4.4';
     20: Result:= 'android-4.4W';
     21: Result:= 'Lollipop-5.0';
     22: Result:= 'Lollipop-5.1';
  end;
end;

function TAndroidProjectDescriptor.GetSdkBuildTools(var gradleVersion: string; var pluginVersion: string; var compileSdkVersion: string): string;
var
  lisDir: TStringList;
  i, p: integer;
  auxStr1, numberAsString: string;
  builderNumber: integer;
  maxBuilderNumber: integer;
  pluginNumber: integer;
begin
  lisDir:= TStringList.Create;
  FindAllDirectories(lisDir, FPathToAndroidSDK + 'build-tools', False);

  if lisDir.Count > 0 then
  begin
    maxBuilderNumber:= 0;
    for i:= 0 to lisDir.Count-1 do
    begin
       auxStr1:= lisDir.Strings[i];
       if Pos('W', auxStr1) = 0 then   //drop 'android-4.4W'
       begin
         auxStr1 := Copy(auxStr1, LastDelimiter(PathDelim, auxStr1) + 1, MaxInt);

         p:=  Pos('.', auxStr1);
         compileSdkVersion:= Copy(auxStr1, 1, p-1);

         numberAsString:= StringReplace(auxStr1,'.', '', [rfReplaceAll]);
         builderNumber:=  StrToInt(Trim(numberAsString));
         if builderNumber > maxBuilderNumber then
         begin
            maxBuilderNumber:= builderNumber;
            Result:= auxStr1;
         end;
       end;
    end;
  end;

  pluginVersion:= '';
  gradleVersion:= '';
  if maxBuilderNumber < 2111 then
  begin
     Result:= '0';
     Exit;
  end;

  if (maxBuilderNumber >= 2111) and (maxBuilderNumber < 2112) then
  begin
    pluginVersion:= '2.0.0';
    gradleVersion:= '2.10';
  end
  else if (maxBuilderNumber >= 2112) and (maxBuilderNumber < 2302) then
  begin
      pluginVersion:= '2.0.0';
      gradleVersion:= '2.10';
  end
  else if (maxBuilderNumber >= 2302) and (maxBuilderNumber < 2500) then
  begin
      pluginVersion:= '2.2.0';
      gradleVersion:= '2.14.1';
  end
  else if (maxBuilderNumber >= 2500) and (maxBuilderNumber < 2602) then   //<<---- good performance !!!
  begin
      pluginVersion:= '2.3.3';
      gradleVersion:= '3.3';
  end
  else if maxBuilderNumber >= 2602 then
  begin
      pluginVersion:= '3.0.0';
      gradleVersion:= '4.1';
  end;

end;

function TAndroidProjectDescriptor.GetWorkSpaceFromForm(projectType: integer; out outTag: integer): boolean;

  function MakeUniqueName(const Orig: string; sl: TStrings): string;
  var
    i: Integer;
  begin
    if sl.Count = 0 then
      Result := Orig + '1'
    else begin
      Result := ExtractFilePath(sl[0]) + Orig;
      i := 1;
      while sl.IndexOf(Result + IntToStr(i)) >= 0 do Inc(i);
      Result := Orig + IntToStr(i);
    end;
  end;

  procedure SaveShellScript(script: TStringList; const AFileName: string);
  begin
    script.SaveToFile(AFileName);
    {$ifdef UNIX}
    FpChmod(AFileName, &751);
    {$endif}
  end;

var
  frm: TFormWorkspace;
  strList: TStringList;
  i, j, intApi, intMinApi: integer;
  linuxDirSeparator: string;
  linuxPathToJavaJDK: string;
  linuxPathToAndroidSdk: string;
  linuxAndroidProjectName: string;
  linuxPathToGradle: string;
  tempStr: string;
  linuxPathToAdbBin: string;
  linuxPathToAntBin: string;
  dummy, strText: string;
  strPack: string;
  sdkBuildTools, gradleVersion, pluginVersion: string;
  compileSdkVersion: string;
  tempList: TStringList;
  androidPluginStr: string;
  androidPluginNumber: integer;

begin
  //outTag:= 0;
  Result:= False;
  FModuleType:= projectType; //0:GUI  1:NoGUI 2: NoGUI EXE Console 3: generic library

  AndroidFileDescriptor.ModuleType:= projectType;
  strList:= nil;
  frm:= TFormWorkspace.Create(nil);

  try

    strList:= TStringList.Create;
    frm.LoadSettings(SettingsFilename);

    frm.ComboSelectProjectName.Text:= MakeUniqueName('LamwGUIProject', frm.ComboSelectProjectName.Items);

    frm.LabelTheme.Caption:= 'Android Theme:';
    frm.ComboBoxTheme.Visible:= True;
    frm.SpeedButtonHintTheme.Visible:= True;

    frm.CheckBoxPIE.Visible:= False;
    frm.CheckBoxLibrary.Visible:= False;

    //frm.RGDeviceType.ItemIndex:= 0;  //phone

    if projectType = 1 then //No GUI
    begin
      frm.Color:= clWhite;
      frm.PanelButtons.Color:= clWhite;

      frm.ComboSelectProjectName.Text:= MakeUniqueName('LamwNoGUIProject', frm.ComboSelectProjectName.Items);

      frm.LabelTheme.Caption:= 'Lamw NoGUI Project';
      frm.ComboBoxTheme.Visible:= False;
      frm.SpeedButtonHintTheme.Visible:= False;
    end;

    if projectType = 2 then //No GUI console executable or generic library [.so]
    begin
      frm.GroupBox1.Visible:= False;

      frm.Color:= clGradientInactiveCaption;
      frm.PanelButtons.Color:= clGradientInactiveCaption;

      frm.ComboSelectProjectName.Text:= MakeUniqueName('LamwConsoleApp', frm.ComboSelectProjectName.Items);

      frm.LabelTheme.Caption:= 'Lamw NoGUI Console/Executable Project';
      frm.EditPackagePrefaceName.Visible:= False;

      frm.EditPackagePrefaceName.Text:= '';
      frm.EditPackagePrefaceName.Enabled:= False;

      frm.ComboBoxTheme.Visible:= False;
      frm.SpeedButtonHintTheme.Visible:= False;

      frm.CheckBoxPIE.Visible:= True;
      frm.CheckBoxLibrary.Visible:= True;  //support to generic [not jni] .so library

    end;

    frm.ModuleType:= projectType;  //<-- input to form

    if frm.ShowModal = mrOK then
    begin
      frm.SaveSettings(SettingsFilename);

      FAndroidTheme:= frm.AndroidTheme;

      FJavaClassName:= frm.JavaClassName;

      FSmallProjName:= frm.SmallProjName;

      FInstructionSet:= frm.InstructionSet;{ ex. ArmV6}
      FFPUSet:= frm.FPUSet; {ex. Soft}

      //FDeviceType:= frm.DeviceType;   //'phone' or 'watch' or ...
      //if FDeviceType = 'watch' then ActionBarTitleDesign:= abtNone;

      FAndroidProjectName:= frm.AndroidProjectName;    //warning: full project name = path + name !
      FPathToJavaSrc:= FAndroidProjectName+DirectorySeparator+ 'src';

      FPathToJavaTemplates:= frm.PathToJavaTemplates;
      FPathToJavaJDK:= frm.PathToJavaJDK;
      FPathToAndroidSDK:= frm.PathToAndroidSDK;
      FPathToAndroidNDK:= frm.PathToAndroidNDK;

      //prepare to LamwSettings model ...
      FPathToAndroidNDK:= IncludeTrailingPathDelimiter(FPathToAndroidNDK);
      FPathToAndroidSDK:= IncludeTrailingPathDelimiter(FPathToAndroidSDK);

      FPrebuildOSys:= frm.PrebuildOSys;

      FNDK:= frm.NDK;
      FAndroidPlatform:= frm.AndroidPlatform;

      FPathToAntBin:= frm.PathToAntBin;
      FPathToGradle:= frm.PathToGradle;

      FMinApi:= frm.MinApi;
      FTargetApi:= frm.TargetApi;
      FSupportV4:= frm.SupportV4;
      FPieChecked:= frm.PieChecked;
      FLibraryChecked:= frm.LibraryChecked;

      if FLibraryChecked then
      begin
        outTag:= 3;
        FModuleType:= 3;
      end;

      FMainActivity:= frm.MainActivity;
      FJavaClassName:= frm.JavaClassName;

      FProjectModel:= frm.ProjectModel;   //<-- output from [Eclipse or Ant Project]
      if FProjectModel = 'Eclipse' then
           FFullJavaSrcPath:= frm.FullJavaSrcPath;

      if  frm.TouchtestEnabled = 'True' then
         FTouchtestEnabled:= '-Dtouchtest.enabled=true'
      else
         FTouchtestEnabled:='';

      FAntBuildMode:= frm.AntBuildMode;
      FPackagePrefaceName:= frm.PackagePrefaceName; // ex.: org.lamw  or  example.com
      AndroidFileDescriptor.PathToJNIFolder:= FAndroidProjectName;

      try
        if  FProjectModel = 'Ant' then
        begin
          if FModuleType < 2 then
          begin
            ForceDirectories(FAndroidProjectName + DirectorySeparator + 'src');

            FPathToJavaSrc:= FAndroidProjectName+DirectorySeparator+ 'src';
            FFullJavaSrcPath:= FPathToJavaSrc;

            strList.Clear;
            strList.StrictDelimiter:= True;
            strList.Delimiter:= '.';
            strList.DelimitedText:= FPackagePrefaceName+'.'+LowerCase(FSmallProjName);
            for i:= 0 to strList.Count -1 do
            begin
               FFullJavaSrcPath:= FFullJavaSrcPath + DirectorySeparator + strList.Strings[i];
               CreateDir(FFullJavaSrcPath);
            end;

            CreateDir(FAndroidProjectName+DirectorySeparator+'res');

            ForceDirectories(FAndroidProjectName+DirectorySeparator+'res'+DirectorySeparator+'drawable-hdpi');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+'ic_launcher.png',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+'ic_launcher.png');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-ldpi'+DirectorySeparator+'ic_launcher.png',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi'+DirectorySeparator+'ic_launcher.png');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-mdpi'+DirectorySeparator+'ic_launcher.png',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi'+DirectorySeparator+'ic_launcher.png');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-xhdpi'+DirectorySeparator+'ic_launcher.png',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi'+DirectorySeparator+'ic_launcher.png');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-xxhdpi'+DirectorySeparator+'ic_launcher.png',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi'+DirectorySeparator+'ic_launcher.png');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');

            strList.Clear;
            strList.Add('<?xml version="1.0" encoding="utf-8"?>');
            strList.Add('<resources>');
            strList.Add('   <string name="app_name">'+FSmallProjName+'</string>');
            strList.Add('   <string name="hello_world">Hello world!</string>');
            strList.Add('</resources>');
            strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'strings.xml');

            CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'styles.xml',
                         FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'styles.xml');

            CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'colors.xml',
                         FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v11');

            //replace "dummyTheme" ..res\values-v11
            strList.Clear;
            strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values-v11'+DirectorySeparator+'styles.xml');

            intApi:= StrToInt(FTargetApi);

            if (intApi >= 11) and (intApi < 14) then
              strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.'+FAndroidTheme, [rfReplaceAll])
            else
              strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.Holo.Light', [rfReplaceAll]); //default

            strList.Text:= strText;
            strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v11'+DirectorySeparator+'styles.xml');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14');

            //replace "dummyTheme" ..res\values-v14
            strList.Clear;

            strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values-v14'+DirectorySeparator+'styles.xml');

            if (intApi >= 14) and (intApi < 21) then
               strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.'+FAndroidTheme, [rfReplaceAll])
            else
               strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.DeviceDefault', [rfReplaceAll]);

            strList.Text:= strText;
            strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14'+DirectorySeparator+'styles.xml');

            intMinApi:= StrToInt(FMinApi);

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v21');
            //replace "dummyTheme" ..res\values-v21

            strList.Clear;

            if intMinApi >= 21 then
              strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values-v21'+DirectorySeparator+'styles.xml')
            else
              strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values-v21'+DirectorySeparator+'styles-empty.xml');

            if (intApi >= 21) then
            begin
              strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.'+FAndroidTheme, [rfReplaceAll])
            end
            else
            begin
              strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.DeviceDefault', [rfReplaceAll]);
            end;

            strList.Text:= strText;
            strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v21'+DirectorySeparator+'styles.xml');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml',
                         FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml');

            CreateDir(FAndroidProjectName+ DirectorySeparator + 'assets');

            CreateDir(FAndroidProjectName+ DirectorySeparator + 'bin');

            CreateDir(FAndroidProjectName+ DirectorySeparator + 'gen');

          end;

          if FModuleType = 0 then     //Android Bridges Controls... [GUI]
          begin
            if not FileExists(FFullJavaSrcPath+DirectorySeparator+'App.java') then
            begin
               strList.Clear;    //dummy App.java - will be replaced with simonsayz's "App.java" template!
               strList.Add('package '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+';');
               strList.Add('public class App extends Activity {');
               strList.Add('     //dummy app');
               strList.Add('}');
               strList.SaveToFile(FFullJavaSrcPath+DirectorySeparator+'App.java');
            end;
          end;

          if FModuleType = 1 then     //[No GUI]
          begin
             if not FileExists(FFullJavaSrcPath+DirectorySeparator+'App.java') then
             begin
               strList.Clear;
               strList.Add('package '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+';');
               strList.Add('');
               strList.Add('import android.os.Bundle;');
               strList.Add('import android.app.Activity;');
               strList.Add('import android.widget.Toast;');
               strList.Add('import android.util.Log;');
               strList.Add(' ');
               strList.Add('//HINT: You can change/edit "App.java" and "'+FSmallProjName+'.java" ');
               strList.Add('//to accomplish/fill  yours requirements...');
               strList.Add(' ');
               strList.Add('public class App extends Activity {');
               strList.Add('  ');

               strList.Add('   '+FSmallProjName+' m'+FSmallProjName+';  //just for demo...');
               strList.Add('  ');
               strList.Add('   @Override');
               strList.Add('   protected void onCreate(Bundle savedInstanceState) {');
               strList.Add('       super.onCreate(savedInstanceState);');
               strList.Add('       setContentView(R.layout.activity_app);');
               strList.Add('');

               strList.Add('       m'+FSmallProjName+' = new '+FSmallProjName+'(); //just for demo...');
               strList.Add('');
               strList.Add('       int sum = m'+FSmallProjName+'.getSum(2,3); //just for demo...');
               strList.Add('       Toast.makeText(getApplicationContext(), "m'+FSmallProjName+'.getSum(2,3) = "+ sum,Toast.LENGTH_LONG).show();');
               strList.Add(' ');
               strList.Add('       String mens = m'+FSmallProjName+'.getString(1); //just for demo...');
               strList.Add('       Toast.makeText(getApplicationContext(), "m'+FSmallProjName+'.getString(1) = "+ mens,Toast.LENGTH_LONG).show();');
               strList.Add(' ');
               strList.Add('   }');
               strList.Add('}');
               strList.SaveToFile(FFullJavaSrcPath+DirectorySeparator+'App.java');
             end;

             if not FileExists(FFullJavaSrcPath+DirectorySeparator+FSmallProjName+'.java') then
             begin
               strList.Clear;
               strList.Add('package '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+';');
               strList.Add('');
               strList.Add('//HINT: You can change/edit "App.java" and "'+FSmallProjName+'.java"');
               strList.Add('//to accomplish/fill  yours requirements...');
               strList.Add('');
               strList.Add('public class '+FSmallProjName+' {');
               strList.Add('');
  	           strList.Add('  public native String getString(int flag);  //just for demo...');
  	           strList.Add('  public native int getSum(int x, int y);    //just for demo...');
               strList.Add('');
               strList.Add('  static {');
         	     strList.Add('	  try {');
       	       strList.Add('	      System.loadLibrary("'+LowerCase(FSmallProjName)+'");');
  	           strList.Add('	  } catch(UnsatisfiedLinkError ule) {');
   	           strList.Add('	      ule.printStackTrace();');
   	           strList.Add('	  }');
               strList.Add('  }');
               strList.Add('');
               strList.Add('}');
               strList.SaveToFile(FFullJavaSrcPath+DirectorySeparator+FSmallProjName+'.java');
             end;

             strList.Clear;

             if not FileExists(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml') then
             begin
               strList.Add('<?xml version="1.0" encoding="utf-8"?>');
               strList.Add('<manifest xmlns:android="http://schemas.android.com/apk/res/android"');
               strList.Add('    package="'+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+'"');
               strList.Add('    android:versionCode="1"');
               strList.Add('    android:versionName="1.0" >');
               strList.Add('    <uses-sdk android:minSdkVersion="10"/>');
               strList.Add('    <application');
               strList.Add('        android:allowBackup="true"');
               strList.Add('        android:icon="@drawable/ic_launcher"');
               strList.Add('        android:label="@string/app_name"');
               strList.Add('        android:theme="@style/AppTheme" >');
               strList.Add('        <activity');
               strList.Add('            android:name="'+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+'.App"');
               strList.Add('            android:label="@string/app_name" >');
               strList.Add('            <intent-filter>');
               strList.Add('                <action android:name="android.intent.action.MAIN" />');
               strList.Add('                <category android:name="android.intent.category.LAUNCHER" />');
               strList.Add('            </intent-filter>');
               strList.Add('        </activity>');
               strList.Add('    </application>');
               strList.Add('</manifest>');
               strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml');
             end;

             strList.Clear;
             strList.Add(FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
             strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'packagename.txt');

          end; //just Ant NoGUI project

        end; // Ant

        if FModuleType < 2 then
        begin
          strList.Clear;

          strList.Add('set Path=%PATH%;'+FPathToAntBin); //<--- thanks to andersonscinfo !  [set path=%path%;C:\and32\ant\bin]
          strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('call ant clean -Dtouchtest.enabled=true debug');
          strList.Add('if errorlevel 1 pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-debug.bat'); //build Apk using "Ant"

          strList.Clear;
          strList.Add('set Path=%PATH%;'+FPathToAntBin); //<--- thanks to andersonscinfo !
          strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('call ant clean release');
          strList.Add('if errorlevel 1 pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-release.bat'); //build Apk using "Ant"

              //*.bat utils...
          CreateDir(FAndroidProjectName+ DirectorySeparator + 'utils');

          {"android list targets" to see the available targets...}
          strList.Clear;
          strList.Add('cd '+FPathToAndroidSDK+'tools');
          strList.Add('android list targets');
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'list_target.bat');

          //need to pause on double-click use...
          strList.Clear;
          strList.Add('cmd /K list_target.bat');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused_list_target.bat');

          strList.Clear;
          strList.Add('cd '+FPathToAndroidSDK+'tools');
          strList.Add('android create avd -n avd_default -t 1 -c 32M');
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'create_avd_default.bat');

          //need to pause on double-click use...
          strList.Clear;
          strList.Add('cmd /k create_avd_default.bat');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused_create_avd_default.bat');

          strList.Clear;
          strList.Add('cd '+FPathToAndroidSDK+'tools');
          if StrToInt(FMinApi) >= 15 then
            strList.Add('emulator -avd avd_default +  -gpu on &')  //gpu: api >= 15,,,
          else
            strList.Add('tools emulator -avd avd_api_'+FMinApi + ' &');
          strList.Add('cd '+FAndroidProjectName);
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'launch_avd_default.bat');

          strList.Clear;
          strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb install -r '+FSmallProjName+'-'+FAntBuildMode+'.apk');
          strList.Add('cd ..');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'install.bat');

          strList.Clear;
          strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'uninstall.bat');

          strList.Clear;
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb logcat');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'logcat.bat');

          strList.Clear;
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb logcat AndroidRuntime:E *:S');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'logcat_error.bat');

          strList.Clear;
          strList.Add(FPathToAndroidSDK+'platform-tools'+DirectorySeparator+
                     'adb logcat ActivityManager:I '+FSmallProjName+'-'+FAntBuildMode+'.apk:D *:S');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'logcat_app_perform.bat');

          (*//causes instability in the simulator! why ?
          strList.Clear;
          strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
          strList.Add(FPathToAndroidSDK+'platform-tools'+DirectorySeparator+
                     'adb shell am start -a android.intent.action.MAIN -n '+
                      FAntPackageName+'.'+LowerCase(projName)+'/.'+FMainActivity);
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'launch_apk.bat');
          *)

          strList.Clear;
          strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
          strList.Add(FPathToAndroidSDK+
                     'build-tools'+DirectorySeparator+ GetFolderFromApi(StrToInt(FMinApi))+
                     DirectorySeparator + 'aapt list '+FSmallProjName+'-'+FAntBuildMode+'.apk');
          strList.Add('cd ..');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'aapt.bat'); //Android Asset Packaging Tool

          strList.Clear;
          strList.Add('<?xml version="1.0" encoding="UTF-8"?>');
          strList.Add('<project name="'+FSmallProjName+'" default="help">');
          strList.Add('<property name="sdk.dir" location="'+FPathToAndroidSDK+'"/>');
          strList.Add('<property name="target"  value="android-'+Trim(FTargetApi)+'"/>');
          strList.Add('<property file="ant.properties"/>');
          strList.Add('<fail message="sdk.dir is missing." unless="sdk.dir"/>');
          //strList.Add('<import file="${sdk.dir}/tools/ant/build.xml"/>'); tk: moved below as it uses source.dir property

          // tk Generate code to allow conditional compilation in our java sources
          strPack := FPackagePrefaceName + '.' + LowerCase(FSmallProjName);
          strList.Add('');
          strList.Add('<!-- Tags required to enable conditional compilation in java sources -->');
          strList.Add('<property name="src.dir" location=".'+PathDelim+'src'+PathDelim+AppendPathDelim(ReplaceChar(strPack, '.', PathDelim))+'"/>');
          strList.Add('<property name="source.dir" value="${src.dir}/${target}" />');
          strList.Add('<import file="${sdk.dir}/tools/ant/build.xml"/>');

          strList.Add('');
          strList.Add('<!-- API version properties, modify according to your API level -->');
          for i := cMinAPI to cMaxAPI do
          begin
            if i <= intAPI then
              strList.Add('<property name="api'+IntToStr(i)+'" value="true"/>')
            else
              strList.Add('<property name="api'+IntToStr(i)+'" value="false"/>');
          end;

          strList.Add('');
          strList.Add('<!-- API conditions, do not modify -->');
          for i := cMinAPI to cMaxAPI do
          begin
            strList.Add('<condition property="ifdef_api'+IntToStr(i)+'up" value="/*">');
            strList.Add('  <equals arg1="${api'+IntToStr(i)+'}" arg2="false"/>');
            strList.Add('</condition>');
            strList.Add('<condition property="endif_api'+IntToStr(i)+'up" value="*/">');
            strList.Add('  <equals arg1="${api'+IntToStr(i)+'}" arg2="false"/>');
            strList.Add('</condition>');
            strList.Add('<property name="ifdef_api'+IntToStr(i)+'up" value=""/>');
            strList.Add('<property name="endif_api'+IntToStr(i)+'up" value=""/>');
          end;

          strList.Add('');
          strList.Add('<!-- Copy & filter java sources for defined Android target, do not modify -->');
          strList.Add('<copy todir="${src.dir}/${target}">');
          strList.Add('  <fileset dir="${src.dir}">');
          strList.Add('    <include name="*.java"/>');
          strList.Add('  </fileset>');
          strList.Add('  <filterset begintoken="//[" endtoken="]">');
          for i := cMinAPI to cMaxAPI do
          begin
            strList.Add('    <filter token="ifdef_api'+IntToStr(i)+'up" value="${ifdef_api'+IntToStr(i)+'up}"/>');
            strList.Add('    <filter token="endif_api'+IntToStr(i)+'up" value="${endif_api'+IntToStr(i)+'up}"/>');
          end;
          strList.Add('  </filterset>');
          strList.Add('</copy>');
          // end tk
          strList.Add('</project>');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build.xml');

          strList.Clear;
          strList.Add('Tutorial: How to get your Android Application [Apk] using "Ant":');
          strList.Add(' ');
          strList.Add('   NEW! Go to Lazarus IDE menu "Run--> [Lamw] Build and Run"! Thanks to Anton!!!');
          strList.Add(' ');
          strList.Add('1. Double click "build-debug.bat [.sh]" to build Apk');
          strList.Add(' ');
          strList.Add('2. If Android Virtual Device[AVD]/Emulator [or real device] is running then:');
          strList.Add('   2.1 double click "install.bat" to install the Apk on the Emulator [or real device]');
          strList.Add('   2.2 look for the App "'+FSmallProjName+'" in the Emulator [or real device] and click it!');
          strList.Add(' ');
          strList.Add('3. If AVD/Emulator is NOT running:');
          strList.Add('   3.1 If AVD/Emulator NOT exist:');
          strList.Add('        3.1.1 double click "paused_create_avd_default.bat" to create the AVD ['+DirectorySeparator+'utils folder]');
          strList.Add('   3.2 double click "launch_avd_default.bat" to launch the Emulator ['+DirectorySeparator+'utils  folder]');
          strList.Add('   3.3 look for the App "'+FSmallProjName+'" in the Emulator and click it!');
          strList.Add(' ');
          strList.Add('4. Log/Debug');
          strList.Add('   4.1 double click "logcat*.bat" to read logs and bugs! ['+DirectorySeparator+'utils folder]');
          strList.Add(' ');
          strList.Add('5. Uninstall Apk');
          strList.Add('   5.1 double click "uninstall.bat" to remove Apk from the Emulator [or real device]!');
          strList.Add(' ');
          strList.Add('6. To find your Apk look for the "'+FSmallProjName+'-'+FAntBuildMode+'.apk" in '+DirectorySeparator+'bin folder!');
          strList.Add(' ');
          strList.Add('7. Android Asset Packaging Tool: to know which files were packed in "'+FSmallProjName+'-'+FAntBuildMode+'.apk"');
          strList.Add('   7.1 double click "aapt.bat" ['+DirectorySeparator+'utils folder]' );
          strList.Add(' ');
          strList.Add('8. To see all available Android targets in your system ['+DirectorySeparator+'utils folder]');
          strList.Add('   8.1 double click "paused_list_target.bat" ');
          strList.Add(' ');
          strList.Add('9. Hint 1: you can edit "*.bat" to extend/modify some command or to fix some incorrect info/path!');
          strList.Add(' ');
          strList.Add('10.Hint 2: you can edit "build.xml" to set another Android target. ex. "android-18" or "android-19" etc.');
          strList.Add('   WARNING: Yes, if after run  "build.*" the folder "...\bin" is still empty then try another target!' );
          strList.Add('   WARNING: If you changed the target in "build.xml" change it in "AndroidManifest.xml" too!' );
          strList.Add(' ');
          strList.Add('11.WARNING: After a new [Lazarus IDE]-> "run->build" do not forget to run again: "build.bat" and "install.bat" !');
          strList.Add(' ');
          strList.Add('12. Linux users: use "build.sh" , "install.sh" , "uninstall.sh" and "logcat.sh" [thanks to Stephano!]');
          strList.Add('    WARNING: All demos Apps was generate on my windows system! So, please,  edit its to correct paths...!');
          strList.Add(' ');
          strList.Add('13. WARNING, before to execute "build-release.bat [.sh]"  you need execute "release.keystore.bat [.sh]"!');
          strList.Add('    Please, read "readme-keytool-input.txt!"');
          strList.Add(' ');
          strList.Add('14. Please, for more info, look for "How to use the Demos" in "Lamw: Lazarus Android Module Wizard" readme.txt!!');
          strList.Add(' ');
          strList.Add('....  Thank you!');
          strList.Add(' ');
          strList.Add('....  by jmpessoa_hotmail_com');
          strList.Add(' ');
          //strList.Add('System Path to Android SDK='+FPathToAndroidSDK);
          //strList.Add('System Path to Android NDK='+FPathToAndroidNDK);
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme.txt');

          dummy:= LowerCase(FSmallProjName);
          strList.Clear;
          strList.Add('key.store='+dummy+'-release.keystore');
          strList.Add('key.alias='+dummy+'aliaskey');
          strList.Add('key.store.password=123456');
          strList.Add('key.alias.password=123456');

          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'ant.properties');

          //keytool input [dammy] data!
          strList.Clear;
          strList.Add('123456');             //Enter keystore password:
          strList.Add('123456');             //Re-enter new password:
          strList.Add('MyFirstName MyLastName'); //What is your first and last name?
          strList.Add('MyDevelopmentUnit');        //What is the name of your organizational unit?
          strList.Add('MyExampleCompany');   //What is the name of your organization?
          strList.Add('MyCity');             //What is the name of your City or Locality?
          strList.Add('AA');                 //What is the name of your State or Province?
          strList.Add('BB');                 //What is the two-letter country code for this unit?
          strList.Add('y');  //Is <CN=FirstName LastName, OU=Development, O=MyExampleCompany, L=MyCity, ST=AK, C=WZ> correct?[no]:  y
          strList.Add('123456'); //Enter key password for <aliasKey> <RETURN if same as keystore password>:
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'keytool_input.txt');

          strList.Clear;

          strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
          strList.Add('set PATH=%JAVA_HOME%'+PathDelim+'bin;%PATH%');
          strList.Add('set JAVA_TOOL_OPTIONS=-Duser.language=en');
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('keytool -genkey -v -keystore '+FSmallProjName+'-release.keystore -alias '+dummy+'aliaskey -keyalg RSA -keysize 2048 -validity 10000 < '+
                      FAndroidProjectName+DirectorySeparator+'keytool_input.txt');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'release-keystore.bat');

          strList.Clear;
          strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
          strList.Add('path %JAVA_HOME%'+PathDelim+'bin;%path%');
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('jarsigner -verify -verbose -certs '+FAndroidProjectName+DirectorySeparator+'bin'+DirectorySeparator+FSmallProjName+'-release.apk');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'jarsigner-verify.bat');

          strList.Clear;

          strList.Add('Tutorial: How to get your keystore to Apk release:');
          strList.Add('');
          strList.Add('1. Edit "keytool_input.txt" to more representative information!"');
          strList.Add('2. You need answer the prompts:');
          strList.Add('');
          strList.Add('Enter keystore password: 123456');
          strList.Add('Re-enter new password: 123456');
          strList.Add('What is your first and last name?');
          strList.Add('  [Unknown]:  MyFirstName MyLastName');
          strList.Add('What is the name of your organizational unit?');
          strList.Add('  [Unknown]:  MyDevelopmentUnit');
          strList.Add('What is the name of your organization?');
          strList.Add('  [Unknown]:  MyExampleCompany');
          strList.Add('What is the name of your City or Locality?');
          strList.Add('  [Unknown]:  MyCity');
          strList.Add('What is the name of your State or Province?');
          strList.Add('  [Unknown]:  AA');
          strList.Add('What is the two-letter country code for this unit?');
          strList.Add('  [Unknown]:  BB');
          strList.Add('Is <CN=MyFirstName MyLastName, OU=MyDevelopmentUnit, O=MyExampleCompany,');
          strList.Add('    L=MyCity, ST=AA, C=BB> correct?');
          strList.Add('  [no]:  y');
          strList.Add('Enter key password for <'+dummy+'aliaskey> <RETURN if same as keystore password>: 123456');
          strList.Add('');
          strList.Add('3. Execute "release-keystore.bat" [.sh]');
          strList.Add('            warning: well, before execute, you can change/edit the [param] -alias '+dummy+'aliaskey');
          strList.Add('              ex.  -alias www.mycompany.com ');
          strList.Add('              Please, change/edit/Sync [key.alias='+dummy+'aliaskey] "ant.properties" too!');
          strList.Add('');
          strList.Add('4. Edit [notepad like] "ant.properties" to more representative information!"');
          strList.Add('        warning: "key.alias='+dummy+'aliaskey" need be the same as in "release-keystore.bat [.sh]"');
          strList.Add('');

          strList.Add('Yes, you got his [renowned] keystore!');
          strList.Add('');
          strList.Add('....  Thank you!');
          strList.Add('');
          strList.Add('....  by jmpessoa_hotmail_com');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme-keytool-input.txt');

          linuxDirSeparator:= DirectorySeparator;
          linuxPathToJavaJDK:= FPathToJavaJDK;
          linuxAndroidProjectName:= FAndroidProjectName;
          linuxPathToAntBin:= FPathToAntBin;
          linuxPathToAndroidSdk:= FPathToAndroidSDK;
          linuxPathToGradle:= FPathToGradle;

          {$IFDEF WINDOWS}
             linuxDirSeparator:= '/';
             tempStr:= FPathToJavaJDK;
             SplitStr(tempStr, ':');
             linuxPathToJavaJDK:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

             tempStr:= FAndroidProjectName;
             SplitStr(tempStr, ':');
             linuxAndroidProjectName:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

             tempStr:= FPathToAntBin;
             SplitStr(tempStr, ':');
             linuxPathToAntBin:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

             tempStr:= FPathToAndroidSDK;
             SplitStr(tempStr, ':');
             linuxPathToAndroidSdk:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

             tempStr:= FPathToGradle;
             SplitStr(tempStr, ':');
             linuxPathToGradle:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

             tempStr:= FAndroidProjectName;
             SplitStr(tempStr, ':');
             linuxAndroidProjectName:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

          {$ENDIF}

          //linux build Apk using "Ant"  ---- Thanks to Stephano!
          strList.Clear;
          if FPathToAntBin <> '' then //PATH=$PATH:/data/myscripts
            strList.Add('export PATH='+linuxPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH

          strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
          strList.Add('cd '+linuxAndroidProjectName);
          strList.Add('ant -Dtouchtest.enabled=true debug');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'build-debug.sh');

          strList.Clear;
          if FPathToAntBin <> '' then
             strList.Add('export PATH='+linuxPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH

          strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
          strList.Add('cd '+linuxAndroidProjectName);
          strList.Add('ant clean release');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'build-release.sh');

          linuxPathToAdbBin:= linuxPathToAndroidSdk+'platform-tools';

          //linux install - thanks to Stephano!
          strList.Clear;
          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));

          //strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb install -r '+linuxDirSeparator+'bin'+linuxDirSeparator+projName+'-'+FAntBuildMode+'.apk');
          //fix/sugestion by OsvaldoTCF - clear slash from /bin
          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb install -r bin'+linuxDirSeparator+FSmallProjName+'-'+FAntBuildMode+'.apk');

          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'install.sh');

          //linux uninstall  - thanks to Stephano!
          strList.Clear;
          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'uninstall.sh');

          //linux logcat  - thanks to Stephano!
          strList.Clear;
          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'logcat.sh');

          strList.Clear;
          strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
          strList.Add('cd '+linuxAndroidProjectName);
          strList.Add('keytool -genkey -v -keystore '+FSmallProjName+'-release.keystore -alias '+dummy+'aliaskey -keyalg RSA -keysize 2048 -validity 10000 < '+
                       linuxAndroidProjectName+linuxDirSeparator+dummy+'keytool_input.txt');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'release-keystore.sh');

          strList.Clear;
          strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
          strList.Add('cd '+linuxAndroidProjectName);
          strList.Add('jarsigner -verify -verbose -certs '+linuxAndroidProjectName+linuxDirSeparator+'bin'+linuxDirSeparator+FSmallProjName+'-release.apk');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'jarsigner-verify.sh');

          //Add GRADLE support ... [... initial code ...]

          strList.Clear;
          {$IFDEF LINUX}
          strList.Add('sdk.dir=' + FPathToAndroidSDK);
          {$ENDIF}

          {$IFDEF WINDOWS}
          tempStr:= FPathToAndroidSDK;
          SplitStr(tempStr, ':');
          tempList:= TStringList.Create;
          tempList.Delimiter:= '\';
          tempList.StrictDelimiter:= True;
          tempList.DelimitedText:= Trim(tempStr);
          tempStr:= 'sdk.dir=C\:\\';
          for j:= 0 to tempList.Count-1 do
          begin
            if tempList.Strings[j] <> '' then
               tempStr:= tempStr + tempList.Strings[j] + '\\';
          end;
          strList.Add( Copy(tempStr,1, Length(tempStr)-2) ) ;
          tempList.Free;
          {$ENDIF}
          strList.SaveToFile(FAndroidProjectName+PathDelim+'local.properties');

          //Building "build.gradle" file    -- for gradle we need "sdk/build-tools" >= 21.1.1
          sdkBuildTools:= GetSdkBuildTools({var} gradleVersion, {var} pluginVersion, {var} compileSdkVersion);
          if sdkBuildTools  <>  '0' then  //0 --> "sdk/build-tools" < 21.1.1
          begin
            androidPluginStr:= StringReplace(pluginVersion,'.', '', [rfReplaceAll]);
            androidPluginNumber:= StrToInt(Trim(androidPluginStr));  //ex. 3.0.0 --> 300

            strList.Clear;
            strList.Add('buildscript {');
            strList.Add('    repositories {');
            strList.Add('        jcenter()');
            strList.Add('        //android plugin version >= 3.0.0 [in classpath] need gradle version >= 4.1 and google() method');
            if androidPluginNumber >= 300 then
               strList.Add('        google()')
            else
               strList.Add('        //google()');
            strList.Add('    }');
            strList.Add('    dependencies {');
            strList.Add('        classpath ''com.android.tools.build:gradle:'+pluginVersion+'''');
            strList.Add('    }');
            strList.Add('}');
            strList.Add('apply plugin: ''com.android.application''');
            strList.Add('android {');
            strList.Add('    lintOptions {');
            strList.Add('       abortOnError false');
            strList.Add('    }');
            strList.Add('    compileSdkVersion '+compileSdkVersion);
            strList.Add('    buildToolsVersion "'+sdkBuildTools+'"');
            strList.Add('    defaultConfig {');
            strList.Add('            minSdkVersion '+FMinApi);
            strList.Add('            targetSdkVersion '+FTargetApi);
            strList.Add('            versionCode 1');
            strList.Add('            versionName "1.0"');
            strList.Add('    }');
            strList.Add('    sourceSets {');
            strList.Add('        main {');
            strList.Add('            manifest.srcFile ''AndroidManifest.xml''');
            strList.Add('            java.srcDirs = [''src'']');
            strList.Add('            resources.srcDirs = [''src'']');
            strList.Add('            aidl.srcDirs = [''src'']');
            strList.Add('            renderscript.srcDirs = [''src'']');
            strList.Add('            res.srcDirs = [''res'']');
            strList.Add('            assets.srcDirs = [''assets'']');
            strList.Add('            jni.srcDirs = []');
            strList.Add('            jniLibs.srcDirs = [''libs'']');
            strList.Add('        }');
            strList.Add('        debug.setRoot(''build-types/debug'')');
            strList.Add('        release.setRoot(''build-types/release'')');
            strList.Add('    }');
            strList.Add('}');
            strList.Add('dependencies {');
            strList.Add('    //compile fileTree(dir: ''libs'', include: ''*.jar'')');
            strList.Add('}');
            strList.Add(' ');
            strList.Add('task run(type: Exec, dependsOn: '':installDebug'') {');
            strList.Add('	if (System.properties[''os.name''].toLowerCase().contains(''windows'')) {');
            strList.Add('	    commandLine ''cmd'', ''/c'', ''adb'', ''shell'', ''am'', ''start'', ''-n'', "'+strPack+'/.App"');
            strList.Add('	} else {');
            strList.Add('	    commandLine ''adb'', ''shell'', ''am'', ''start'', ''-n'', "'+strPack+'/.App"');
            strList.Add('	}');
            strList.Add('}');
            strList.Add(' ');
            strList.Add('task wrapper(type: Wrapper) {');
            strList.Add('    gradleVersion = '''+gradleVersion+'''');
            strList.Add('}');
            strList.Add('//how to use: look for "gradle_readme.txt"');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'build.gradle');

            strList.Clear;
            strList.Add(' ');
            strList.Add(' ');
            strList.Add('HOW TO use "gradle.build" file');
            strList.Add(' ');
            strList.Add('       ::by jmpessoa');
            strList.Add(' ');
            strList.Add('references:');
            strList.Add('   http://spring.io/guides/gs/gradle-android/');
            strList.Add('   https://paulemtz.blogspot.com.br/2013/04/automating-android-builds-with-gradle.html');
            strList.Add(' ');
            strList.Add('   WARNING: you will need INTERNET CONNECTION!!');
            strList.Add(' ');
            strList.Add('***SYSTEM INFRASTRUCTURE');
            strList.Add(' ');
            strList.Add('(1) Look for the highest "...\sdk\build-tools" version');
            strList.Add('        The table point out gradle and "sdk\build-tools" versions compatibility');
            strList.Add(' ');
            strList.Add('        plugin [in classpath]           gradle        sdk\build-tools');
            strList.Add('                   2.0.0                2.10          21.1.2');
            strList.Add('                   2.2.0                2.14.1        23.0.2');
            strList.Add('                   2.3.3                3.3           25.0.0');
            strList.Add('                   3.0.0                4.1           26.0.2');
            strList.Add(' ');
            strList.Add('        Note 1. You can interpolate to some value other than these.');
            strList.Add('        Ex. In my system the highest "sdk\build-tools" is "22.0.1", so I downloaded/Installed gradle 2.1.0');
            strList.Add(' ');
            strList.Add('        Note 2. In "build.gradle" file, the gradle version is set to be compatible with the highest "sdk\build-tools" found in your system');
            strList.Add('        as a consequence, it is this version of gradle that you must download/install.');
            strList.Add(' ');
            strList.Add('        reference:');
            strList.Add('           https://developer.android.com/studio/releases/gradle-plugin.html#2-3-0');
            strList.Add('           https://gradle.org/releases/');
            strList.Add('           Hint: downloading just "binary-only" is OK!');
            strList.Add(' ');
            strList.Add('        Note 3. You should set the gradle path in Lazarus menu "Tools --> LAMW --> Paths Settings..."');
            strList.Add(' ');
            strList.Add('***SETTING ENVIRONMENT VARIABLES...');
            strList.Add(' ');
            strList.Add('[windows] cmd line prompt:');
            strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
            if FPathToGradle = '' then
               strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
            else
               strList.Add('set GRADLE_HOME='+FPathToGradle);
            strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
            strList.Add(' ');

            strList.Add('[linux] cmd line prompt:');
            strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
            if FPathToGradle = '' then
               strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('export GRADLE_HOME='+ linuxPathToGradle);
            strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
            strList.Add('source ~/.bashrc');
            strList.Add(' ');
            strList.Add('WARNING: The following tasks assume that you have:');
            strList.Add('         .Internet connection;');
            strList.Add('         .Set the environment variables;');
            strList.Add('         .Install gradle version compatible with your highest "sdk\build-tools"');
            strList.Add(' ');
            strList.Add('***BUILDING AND RUNNING APK ....');
            strList.Add(' ');
            strList.Add('.METHOD - I.');
            strList.Add('    Running installed local version of gradle');
            strList.Add(' ');
            strList.Add('    ::Go to your project folder....');
            strList.Add(' ');
            strList.Add('[windows] cmd line prompt:');
            strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools'); //
            if FPathToGradle = '' then
               strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('set GRADLE_HOME='+FPathToGradle);
            strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
            strList.Add(' ');
            strList.Add('[windows] cmd line prompt:');
            strList.Add('gradle clean build --info');
            strList.Add('gradle run');
            strList.Add(' ');
            strList.Add(' ');
            strList.Add('[linux] cmd line prompt:');
            strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
            if FPathToGradle = '' then
              strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('export GRADLE_HOME='+linuxPathToGradle);

            strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
            strList.Add('source ~/.bashrc');
            strList.Add(' ');
            strList.Add('[linux] cmd line prompt:');
            strList.Add('.\gradle clean build --info');
            strList.Add('.\gradle run');
            strList.Add(' ');
            strList.Add('Congratulation!');
            strList.Add(' ');
            strList.Add('    :: Where is my Apk? here: "'+FAndroidProjectName+'\build\outputs\apk"!');
            strList.Add(' ');
            strList.Add('hint: you can try edit and run:');
            strList.Add('[windows] "gradle_local_build.bat"');
            strList.Add('[linux] "gradle_local_build.sh"');

            strList.Add('[windows] "gradle_local_run.bat"');
            strList.Add('[linux] "gradle_local__run.sh"');

            strList.Add(' ');
            strList.Add(' ');
            strList.Add('.METHOD - II.');
            strList.Add(' ');
            strList.Add('(1) Making "gradlew" (gradle wrapper) available for building your project');
            strList.Add('    ::Go to your project folder....');
            strList.Add(' ');
            strList.Add('[windows] cmd line prompt:');
            strList.Add('gradle wrapper');
            strList.Add(' ');
            strList.Add('[linux] cmd line prompt:');
            strList.Add('./gradle wrapper');
            strList.Add(' ');
            strList.Add('hint: you can try edit and run:');
            strList.Add('[windows] "gradle_making_wrapper.bat"');
            strList.Add('[linux] "gradle_making_wrapper.sh"');

            strList.Add(' ');
            strList.Add('(2) Building your project with "gradlew"');
            strList.Add(' ');
            strList.Add('[windows] cmd line prompt:');
            strList.Add('gradlew build');
            strList.Add(' ');
            strList.Add('[linux] cmd line prompt:');
            strList.Add('./gradlew build');
            strList.Add(' ');
            strList.Add('hint: you can try edit and "build" with gradle wrapper:');
            strList.Add('[windows] "gradle_w_build.bat"');
            strList.Add('[linux] "gradle_w_build.sh"');
            strList.Add(' ');
            strList.Add('(3) Installing and Runing Apk');
            strList.Add(' ');
            strList.Add('[windows] cmd line prompt:');
            strList.Add('gradlew install');
            strList.Add(' ');
            strList.Add('[linux] cmd line prompt:');
            strList.Add('./gradlew run');
            strList.Add(' ');
            strList.Add('Congratulation!');
            strList.Add(' ');
            strList.Add('    :: Where is my Apk? here: "'+FAndroidProjectName+'\build\outputs\apk"!');
            strList.Add(' ');
            strList.Add('hint: you can try edit and "run" with gradle wrapper:');
            strList.Add('[windows] "gradle_w_run.bat"');
            strList.Add('[linux] "gradle_w_run.sh"');
            strList.Add(' ');
            strList.Add(' ');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_readme.txt');

            //Drafts Making gradlew (= gradle warapper)
            strList.Clear;
            strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
            if FPathToGradle = '' then
              strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('set GRADLE_HOME='+FPathToGradle);
            strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
            strList.Add('gradle wrapper');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_making_wrapper.bat');

            strList.Clear;
            strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
            if FPathToGradle = '' then
              strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('export GRADLE_HOME='+ linuxPathToGradle);
            strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
            strList.Add('source ~/.bashrc');
            strList.Add('./gradle wrapper');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_making_wrapper.sh');

            //Drafts Method II

            //build
            strList.Clear;
            strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
            if FPathToGradle = '' then
              strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('set GRADLE_HOME='+ FPathToGradle);
            strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
            strList.Add('gradlew build');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_w_build.bat');

            strList.Clear;
            strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
            if FPathToGradle = '' then
               strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
            else
               strList.Add('export GRADLE_HOME='+linuxPathToGradle);
            strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
            strList.Add('source ~/.bashrc');
            strList.Add('./gradlew build');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_w_build.sh');

            //run
            strList.Clear;
            strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
            if FPathToGradle = '' then
              strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('set GRADLE_HOME='+ FPathToGradle);
            strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
            strList.Add('gradlew run');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_w_run.bat');

            strList.Clear;
            strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
            if FPathToGradle = '' then
               strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
            else
               strList.Add('export GRADLE_HOME='+linuxPathToGradle);
            strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
            strList.Add('source ~/.bashrc');
            strList.Add('./gradlew run');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_w_run.sh');

            //Drafts Method I

            strList.Clear;
            strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
            if FPathToGradle = '' then
              strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('set GRADLE_HOME='+ FPathToGradle);
            strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
            strList.Add('gradle clean build --info');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_local_build.bat');

            strList.Clear;
            strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
            if FPathToGradle = '' then
              strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('set GRADLE_HOME='+ FPathToGradle);
            strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
            strList.Add('gradle run');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_local_run.bat');

            strList.Clear;
            strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
            if FPathToGradle = '' then
              strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('export GRADLE_HOME='+ linuxPathToGradle);
            strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
            strList.Add('source ~/.bashrc');
            strList.Add('.\gradle clean build --info');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_local_build.sh');

            strList.Clear;
            strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
            if FPathToGradle = '' then
              strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
            else
              strList.Add('export GRADLE_HOME='+ linuxPathToGradle);
            strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
            strList.Add('source ~/.bashrc');
            strList.Add('.\gradle run');
            strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle_local_run.sh');
          end;  //gradle support ...

        end;
        Result := True;
      except
        on e: Exception do
          MessageDlg('Error',e.Message,mtError,[mbOK],0);
      end;
    end;
  finally
    strList.Free;
    frm.Free;
  end;
end;


function TAndroidProjectDescriptor.DoInitDescriptor: TModalResult;  //No GUI
var
   auxList: TStringList;
   outTag: integer;
begin
   FModuleType := 1;
   if GetWorkSpaceFromForm(1, outTag) then //1: noGUI project
   begin
      if TryNewJNIAndroidInterfaceCode(1) then //1: noGUI project
      begin
        CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni');
        CreateDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'mips');
        CreateDir(FAndroidProjectName+DirectorySeparator+'obj');
        CreateDir(FAndroidProjectName+DirectorySeparator+'lamwdesigner');

        if FModuleType < 2 then
           CreateDir(FAndroidProjectName+DirectorySeparator+'obj'+DirectorySeparator+'controls');

        if FSupportV4 = 'yes' then  //add android 4.0 support to olds devices ...
        begin
             if not FileExists(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar') then
                CopyFile(FPathToJavaTemplates+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar',
                    FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar');
        end;

        //eclispe compatibility!
        CreateDir(FAndroidProjectName+DirectorySeparator+'.settings');

        auxList:= TStringList.Create;
        auxList.Add('eclipse.preferences.version=1');
        auxList.Add('org.eclipse.jdt.core.compiler.codegen.targetPlatform=1.6');
        auxList.Add('org.eclipse.jdt.core.compiler.compliance=1.6');
        auxList.Add('org.eclipse.jdt.core.compiler.source=1.6');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.settings'+DirectorySeparator+'org.eclipse.jdt.core.prefs');

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
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.classpath');

        auxList.Clear;
        auxList.Add('<projectDescription>');
        auxList.Add('	<name>'+FSmallProjName+'</name>');
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
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'.project');

        auxList.Clear;
        auxList.Add('# To enable ProGuard in your project, edit project.properties');
        auxList.Add('# to define the proguard.config property as described in that file.');
        auxList.Add('#');
        auxList.Add('# Add project specific ProGuard rules here.');
        auxList.Add('# By default, the flags in this file are appended to flags specified');
        auxList.Add('# in ${sdk.dir}/tools/proguard/proguard-android.txt');
        auxList.Add('# You can edit the include path and order by changing the ProGuard');
        auxList.Add('# include property in project.properties.');
        auxList.Add('#');
        auxList.Add('# For more details, see');
        auxList.Add('#   http://developer.android.com/guide/developing/tools/proguard.html');
        auxList.Add(' ');
        auxList.Add('# Add any project specific keep options here:');
        auxList.Add(' ');
        auxList.Add('# If your project uses WebView with JS, uncomment the following');
        auxList.Add('# and specify the fully qualified class name to the JavaScript interface');
        auxList.Add('# class:');
        auxList.Add('#-keepclassmembers class fqcn.of.javascript.interface.for.webview {');
        auxList.Add('#   public *;');
        auxList.Add('#}');
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'proguard-project.txt');

        auxList.Clear;
        auxList.Add('# This file is automatically generated by Android Tools.');
        auxList.Add('# Do not modify this file -- YOUR CHANGES WILL BE ERASED!');
        auxList.Add('#');
        auxList.Add('# This file must be checked in Version Control Systems.');
        auxList.Add('#');
        auxList.Add('# To customize properties used by the Ant build system edit');
        auxList.Add('# "ant.properties", and override values to adapt the script to your');
        auxList.Add('# project structure.');
        auxList.Add('#');
        auxList.Add('# To enable ProGuard to shrink and obfuscate your code, uncomment this (available properties: sdk.dir, user.home):');
        auxList.Add('#proguard.config=${sdk.dir}/tools/proguard/proguard-android.txt:proguard-project.txt');
        auxList.Add(' ');
        auxList.Add('# Project target.');
        auxList.Add('target=android-'+Trim(FTargetApi));
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'project.properties');

        auxList.Clear;
        auxList.Add(FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator + 'packagename.txt');

        auxList.Free;

        Result := mrOK
      end
      else
        Result := mrAbort;
   end
   else Result := mrAbort;
end;


function TAndroidProjectDescriptor.GetAppName(className: string): string;
var
  listAux: TStringList;
  lastIndex: integer;
begin
  listAux:= TStringList.Create;
  listAux.StrictDelimiter:= True;
  listAux.Delimiter:= '.';
  listAux.DelimitedText:= StringReplace(className,'/','.',[rfReplaceAll]);
  lastIndex:= listAux.Count-1;
  listAux.Delete(lastIndex);
  Result:= listAux.DelimitedText;
  listAux.Free;
end;

function TAndroidProjectDescriptor.InitProject(AProject: TLazProject): TModalResult;
var
  MainFile: TLazProjectFile;
  projName, projDir, auxStr: string;
  sourceList: TStringList;
  auxList: TStringList;

  libraries_x86: string;
  libraries_arm: string;
  libraries_mips: string;

  customOptions_x86: string;
  customOptions_mips: string;

  customOptions_default: string;

  customOptions_armV6: string;
  customOptions_armV7a: string;

  PathToNdkPlatformsArm: string;
  PathToNdkPlatformsX86: string;
  PathToNdkPlatformsMips: string;

  pathToNdkToolchainsX86: string;
  pathToNdkToolchainsArm: string;
  pathToNdkToolchainsMips: string;

   //by Stephano
  pathToNdkToolchainsBinX86: string;
  pathToNdkToolchainsBinArm: string;
  pathToNdkToolchainsBinMips: string;

  osys: string;      {windows or linux-x86 or linux-x86_64}
  headerList: TStringList;
begin

  inherited InitProject(AProject);

  if  FModuleType < 2 then
    projName:= LowerCase(FJavaClassName) + '.lpr'
  else
    projName:= LowerCase(FSmallProjName) + '.lpr';

  if   FPathToClassName = '' then
      FPathToClassName:= StringReplace(FPackagePrefaceName, '.', '/', [rfReplaceAll])+'/'+LowerCase(FSmallProjName)+'/'+ FJavaClassName; //ex. 'com/example/appasynctaskdemo1/Controls'

  if  FModuleType < 2 then
     projDir:= FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator
  else
     projDir:= FPathToJNIFolder+DirectorySeparator;

  if FModuleType = 0 then
    AProject.CustomData.Values['LAMW'] := 'GUI'
  else if  FModuleType = 1 then
    AProject.CustomData.Values['LAMW'] := 'NoGUI'
  else if FModuleType = 2 then
    AProject.CustomData.Values['LAMW'] := 'NoGUIConsoleApp'    // FModuleType =2
  else
    AProject.CustomData.Values['LAMW'] := 'NoGUIGenericLibrary';    // FModuleType = 3

  if FModuleType < 2 then
    AProject.CustomData.Values['Package']:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);

  AProject.CustomData.Values['NdkPath']:= FPathToAndroidNDK;
  AProject.CustomData.Values['SdkPath']:= FPathToAndroidSDK;
  AProject.CustomData.Values['NdkApi']:= FAndroidPlatform;  // androd-13, android-14,  android-15 etc...

  AProject.ProjectInfoFile := projDir + ChangeFileExt(projName, '.lpi');

  MainFile := AProject.CreateProjectFile(projDir + projName);

  MainFile.IsPartOfProject := True;
  AProject.AddFile(MainFile, False);
  AProject.MainFileID := 0;

  if FModuleType = 0 then  //GUI
    AProject.AddPackageDependency('tfpandroidbridge_pack'); //GUI controls

  sourceList:= TStringList.Create;
  sourceList.Add('{hint: save all files to location: ' + projDir + ' }');

  if FModuleType = 2 then  //console executavel
    sourceList.Add('program '+ LowerCase(FSmallProjName) +'; '+ ' //[by Lamw: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']')
  else if  FModuleType = 3 then
    sourceList.Add('library '+ LowerCase(FSmallProjName) +'; '+ ' //[by Lamw: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']')
  else
    sourceList.Add('library '+ LowerCase(FJavaClassName) +'; '+ ' //[by Lamw: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']');

  sourceList.Add(' ');
  sourceList.Add('{$mode delphi}');
  sourceList.Add(' ');

  sourceList.Add('uses');

  if FModuleType = 0 then  //GUI controls
  begin
    sourceList.Add('  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,');
    sourceList.Add('  Laz_And_Controls_Events;');
    sourceList.Add(' ');
  end
  else if FModuleType = 1 then //NoGUI ---  Not Android Bridges Controls
  begin
    sourceList.Add('  Classes, SysUtils, CustApp, jni;');
    sourceList.Add(' ');
    sourceList.Add('type');
    sourceList.Add(' ');
    sourceList.Add('  TNoGUIApp = class(TCustomApplication)');
    sourceList.Add('  public');
    sourceList.Add('     jClassName: string;');
    sourceList.Add('     jAppName: string;');
    sourceList.Add('     procedure CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('     constructor Create(TheOwner: TComponent); override;');
    sourceList.Add('     destructor Destroy; override;');
    sourceList.Add('  end;');
    sourceList.Add(' ');
    sourceList.Add('procedure TNoGUIApp.CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('var');
    sourceList.Add('  Instance: TComponent;');
    sourceList.Add('begin');
    sourceList.Add('  Instance := TComponent(InstanceClass.NewInstance);');
    sourceList.Add('  TComponent(Reference):= Instance;');
    sourceList.Add('  Instance.Create(Self);');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('constructor TNoGUIApp.Create(TheOwner: TComponent);');
    sourceList.Add('begin');
    sourceList.Add('  inherited Create(TheOwner);');
    sourceList.Add('  StopOnException:=True;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('destructor TNoGUIApp.Destroy;');
    sourceList.Add('begin');
    sourceList.Add('  inherited Destroy;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('var');
    sourceList.Add('  gNoGUIApp: TNoGUIApp;');
    sourceList.Add('  gNoGUIjAppName: string;');
    sourceList.Add('  gNoGUIAppjClassName: string;');

    sourceList.Add('');
  end
  else if FModuleType = 2 then// 2 - NoGUI console executable
  begin
    sourceList.Add('  Classes, SysUtils, CustApp;');
    sourceList.Add(' ');
    sourceList.Add('type');
    sourceList.Add(' ');
    sourceList.Add('  TAndroidConsoleApp = class(TCustomApplication)');
    sourceList.Add('  public');
    sourceList.Add('     procedure CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('     constructor Create(TheOwner: TComponent); override;');
    sourceList.Add('     destructor Destroy; override;');
    sourceList.Add('  end;');
    sourceList.Add(' ');
    sourceList.Add('procedure TAndroidConsoleApp.CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('var');
    sourceList.Add('  Instance: TComponent;');
    sourceList.Add('begin');
    sourceList.Add('  Instance := TComponent(InstanceClass.NewInstance);');
    sourceList.Add('  TComponent(Reference):= Instance;');
    sourceList.Add('  Instance.Create(Self);');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('constructor TAndroidConsoleApp.Create(TheOwner: TComponent);');
    sourceList.Add('begin');
    sourceList.Add('  inherited Create(TheOwner);');
    sourceList.Add('  StopOnException:=True;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('destructor TAndroidConsoleApp.Destroy;');
    sourceList.Add('begin');
    sourceList.Add('  inherited Destroy;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('var');
    sourceList.Add('  AndroidConsoleApp: TAndroidConsoleApp;');
    sourceList.Add('');
  end
  else //generic .so library
  begin
    sourceList.Add('  Unit1;');  //ok
  end;

  if FModuleType = 0 then //GUI
  begin
    sourceList.Add('{%region /fold ''LAMW generated code''}');
    sourceList.Add('');
    sourceList.Add(FPascalJNIInterfaceCode);
    sourceList.Add('{%endregion}');
  end;

  sourceList.Add(' ');

  if FModuleType < 3 then sourceList.Add('begin');

  if FModuleType = 0 then  //Android Bridges controls...
  begin
    sourceList.Add('  gApp:= jApp.Create(nil);');
    sourceList.Add('  gApp.Title:= ''JNI Android Bridges Library'';');
    sourceList.Add('  gjAppName:= '''+GetAppName(FPathToClassName)+''';'); //com.example.appasynctaskdemo1
    sourceList.Add('  gjClassName:= '''+FPathToClassName+''';');           //com/example/appasynctaskdemo1/Controls
    sourceList.Add('  gApp.AppName:=gjAppName;');
    sourceList.Add('  gApp.ClassName:=gjClassName;');
    sourceList.Add('  gApp.Initialize;');
    sourceList.Add('  gApp.CreateForm(TAndroidModule1, AndroidModule1);');
  end
  else if FModuleType = 1 then
  begin
     sourceList.Add('  gNoGUIApp:= TNoGUIApp.Create(nil);');
     sourceList.Add('  gNoGUIApp.Title:= ''My Android Pure Library'';');
     sourceList.Add('  gNoGUIjAppName:= '''+GetAppName(FPathToClassName)+''';');
     sourceList.Add('  gNoGUIAppjClassName:= '''+FPathToClassName+''';');

     sourceList.Add('  gNoGUIApp.jAppName:=gNoGUIjAppName;');
     sourceList.Add('  gNoGUIApp.jClassName:=gNoGUIAppjClassName;');

     sourceList.Add('  gNoGUIApp.Initialize;');
     sourceList.Add('  gNoGUIApp.CreateForm(TNoGUIAndroidModule1, NoGUIAndroidModule1);');
  end
  else if FModuleType = 2 then // 2  - console executable
  begin
     sourceList.Add('  AndroidConsoleApp:= TAndroidConsoleApp.Create(nil);');
     sourceList.Add('  AndroidConsoleApp.Title:= ''Android Executable Console App'';');
     sourceList.Add('  AndroidConsoleApp.Initialize;');
     sourceList.Add('  AndroidConsoleApp.CreateForm(TAndroidConsoleDataForm1,AndroidConsoleDataForm1);');
  end
  else
  begin  //generic library
    sourceList.Add(' ');
    sourceList.Add('function Sum(a: longint; b: longint): longint; cdecl;');
    sourceList.Add('begin');
    sourceList.Add('  Result:= SumAB(a, b);');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('exports');
    sourceList.Add('  Sum;');
    sourceList.Add(' ');

    headerList:= TStringList.Create;
    headerList.Add('unit '+LowerCase(FSmallProjName)+'_h');
    headerList.Add(' ');
    headerList.Add('interface');
    headerList.Add(' ');
    headerList.Add('  function Sum(a: longint; b: longint): longint; cdecl; external ''lib'+LowerCase(FSmallProjName)+'.so'' name ''Sum'';');
    headerList.Add(' ');
    headerList.Add('implementation');
    headerList.Add(' ');
    headerList.Add('end.');
    headerList.SaveToFile(projDir+'libs'+DirectorySeparator+LowerCase(FSmallProjName)+'_h.pas');
    headerList.Free;

  end;

  sourceList.Add('end.');
  AProject.MainFile.SetSourceText(sourceList.Text, True);

  AProject.Flags := AProject.Flags - [pfMainUnitHasCreateFormStatements,
                                      pfMainUnitHasTitleStatement,
                                      pfLRSFilesInOutputDirectory];
  AProject.UseManifest:= False;
  AProject.UseAppBundle:= False;

  osys:= FPrebuildOSYS;

  {Set compiler options for Android requirements}

  PathToNdkPlatformsArm:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                                FAndroidPlatform +DirectorySeparator+'arch-arm'+DirectorySeparator+
                                                'usr'+DirectorySeparator+'lib';

  if FNDK = '7' then
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.4.3';

  if (FNDK = '9') or (FNDK = '10') or (FNDK = '10c') then          //arm-linux-androideabi-4.9
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.6';

  if FNDK = '10e' then          //arm-linux-androideabi-4.9
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.9';

  if FNDK = '11c' then          //arm-linux-androideabi-4.9
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.9';
  if FNDK = '7' then
      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

  if (FNDK = '9') or (FNDK = '10') or (FNDK = '10c') then
      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

  if FNDK = '10e' then
      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

  if FNDK = '11c' then
      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

  libraries_arm:= PathToNdkPlatformsArm+';'+pathToNdkToolchainsArm;

  PathToNdkPlatformsX86:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                             FAndroidPlatform+DirectorySeparator+'arch-x86'+DirectorySeparator+
                                             'usr'+DirectorySeparator+'lib';

  PathToNdkPlatformsMips:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                             FAndroidPlatform+DirectorySeparator+'arch-mips'+DirectorySeparator+
                                             'usr'+DirectorySeparator+'lib';

  if FNdk = '7' then
      pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+
                                                 'gcc'+DirectorySeparator+'i686-android-linux'+DirectorySeparator+'4.4.3';

  if (FNDK = '9') or (FNDK = '10') or (FNDK = '10c') then
      pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'i686-android-linux'+DirectorySeparator+'4.6';

  if FNDK = '10e' then
  begin
    pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'i686-android-linux'+DirectorySeparator+'4.9';
    pathToNdkToolchainsMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                  'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                  osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                  'mipsel-linux-android'+DirectorySeparator+'4.9';
  end;

  if FNDK = '11c' then
  begin
    pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'i686-android-linux'+DirectorySeparator+'4.9';

    pathToNdkToolchainsMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                  'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                  osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                  'mipsel-linux-android'+DirectorySeparator+'4.9';
  end;

  if FNDK = '7' then
      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';


  if (FNDK = '9') or (FNDK = '10') or (FNDK = '10c') then
      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

  if FNDK = '10e' then
  begin
      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      pathToNdkToolchainsBinMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';
  end;

  if FNDK = '11c' then
  begin
      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      pathToNdkToolchainsBinMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';
  end;


  libraries_x86:= PathToNdkPlatformsX86+';'+pathToNdkToolchainsX86;
  libraries_mips:= PathToNdkPlatformsMips+';'+pathToNdkToolchainsMips;

  if Pos('Mipsel', FInstructionSet) > 0 then
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'mipsel';    {-P}
     AProject.LazCompilerOptions.Libraries:= libraries_mips;
     FPathToNdkPlatforms:= PathToNdkPlatformsMips;
     FPathToNdkToolchains:= pathToNdkToolchainsMips;
  end
  else if Pos('x86', FInstructionSet) > 0 then
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'i386';    {-P}
     AProject.LazCompilerOptions.Libraries:= libraries_x86;
     FPathToNdkPlatforms:= PathToNdkPlatformsX86;
     FPathToNdkToolchains:= pathToNdkToolchainsX86;
  end
  else
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'arm';    {-P}
     AProject.LazCompilerOptions.Libraries:= libraries_arm;
     FPathToNdkPlatforms:= PathToNdkPlatformsArm;
     FPathToNdkToolchains:= pathToNdkToolchainsArm
  end;

  {Parsing}
  AProject.LazCompilerOptions.SyntaxMode:= 'delphi';  {-M}
  AProject.LazCompilerOptions.CStyleOperators:= True;
  AProject.LazCompilerOptions.AllowLabel:= True;
  AProject.LazCompilerOptions.CPPInline:= True;
  AProject.LazCompilerOptions.CStyleMacros:= True;
  AProject.LazCompilerOptions.UseAnsiStrings:= True;
  AProject.LazCompilerOptions.UseLineInfoUnit:= True;

  {Code Generation}
  AProject.LazCompilerOptions.TargetOS:= 'android'; {-T}

  AProject.LazCompilerOptions.OptimizationLevel:= 3; //1;  //changed 21-december-2014
  AProject.LazCompilerOptions.Win32GraphicApp:= False;

  {Link}
  AProject.LazCompilerOptions.StripSymbols:= True; {-Xs}
  AProject.LazCompilerOptions.LinkSmart:= True {-XX};
  AProject.LazCompilerOptions.GenerateDebugInfo:= False;
  AProject.LazCompilerOptions.SmallerCode:= True;    //added 21-december-2014
  AProject.LazCompilerOptions.SmartLinkUnit:= True;  //added 21-december-2014

  if FModuleType = 2 then
  begin
    if FPieChecked then  //here PIE support .. ok sorry... :(  ...bad code reuse!
    begin
      AProject.LazCompilerOptions.PassLinkerOptions:= True;
      AProject.LazCompilerOptions.LinkerOptions:='-pie'
    end;
  end;

  {Verbose}
      //.....................

  auxStr:= 'armeabi';  //ARMv6
  if FInstructionSet = 'ARMv7a' then auxStr:='armeabi-v7a';
  if FInstructionSet = 'x86' then auxStr:='x86';
  if FInstructionSet = 'Mipsel' then auxStr:='mips';

  //if FInstructionSet <> 'x86' then
  if Pos('ARM', FInstructionSet) > 0 then
  begin
     customOptions_default:='-Xd'+' -Cf'+ FFPUSet;
     customOptions_default:= customOptions_default + ' -Cp'+ UpperCase(FInstructionSet);
  end
  else
  begin
     customOptions_default:='-Xd';
  end;

  customOptions_armV6:= '-Xd'+' -Cf'+ FFPUSet+ ' -CpARMV6';
  customOptions_armV7a:='-Xd'+' -Cf'+ FFPUSet+ ' -CpARMV7A';
  customOptions_x86:=   '-Xd';
  customOptions_mips:=  '-Xd';

  customOptions_armV6:=  customOptions_armV6  +' -XParm-linux-androideabi-';
  customOptions_armV7a:= customOptions_armV7a +' -XParm-linux-androideabi-';
  customOptions_x86:=    customOptions_x86    +' -XPi686-linux-android-';   //fix by jmpessoa
  customOptions_mips:=   customOptions_mips   +' -XPmipsel-linux-android-';

  // Takeda Patch - "customOptions_default" now would really aware about compilation for x86 Target
  //if FInstructionSet <> 'x86' then
  if Pos('ARM', FInstructionSet) > 0 then
  begin
    customOptions_default:= customOptions_default+' -XParm-linux-androideabi-'+' -FD'+pathToNdkToolchainsBinArm;
  end
  else if Pos('x86', FInstructionSet) > 0 then
  begin
    customOptions_default:= customOptions_default+' -XPi686-linux-android-'+' -FD'+pathToNdkToolchainsBinX86;
  end
  else if Pos('Mipsel', FInstructionSet) > 0 then
    customOptions_default:= customOptions_default+' -XPmipsel-linux-android-'+' -FD'+pathToNdkToolchainsBinMips;

  customOptions_armV6:= customOptions_armV6+' -FD'+pathToNdkToolchainsBinArm;
  customOptions_armV7a:= customOptions_armV7a+' -FD'+pathToNdkToolchainsBinArm;
  customOptions_x86:= customOptions_x86+' -FD'+pathToNdkToolchainsBinX86;
  customOptions_mips:= customOptions_mips+' -FD'+pathToNdkToolchainsBinMips;

  (*FIXED !!!   lazarus  rev  >> 46598  !!!
  {$IFDEF WINDOWS}
     //to others :: just to [fix a bug]  lazarus  rev < 46598 .... //thanks to Stephano!
     // ThierryDijoux - change auxStr by value of the correct folder
     customOptions_default:= customOptions_default+' -o..'+DirectorySeparator+'libs'+DirectorySeparator+auxStr       +DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
     customOptions_armV6:=   customOptions_armV6  +' -o..'+DirectorySeparator+'libs'+DirectorySeparator+'armeabi'    +DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
     customOptions_armV7a:=  customOptions_armV7a +' -o..'+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a'+DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
     customOptions_x86:=     customOptions_x86    +' -o..'+DirectorySeparator+'libs'+DirectorySeparator+'x86'        +DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
  {$ENDIF}
  *)

  {Others}
  AProject.LazCompilerOptions.CustomOptions:= customOptions_default;

  auxList:= TStringList.Create;
  auxList.Add('<Libraries Value="'+libraries_x86+'"/>');
  auxList.Add('<TargetCPU Value="i386"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_x86+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType < 2 then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_mips+'"/>');
  auxList.Add('<TargetCPU Value="mipsel"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_mips+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType < 2 then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_mipsel.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_mipsel.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV6+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV6"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType < 2 then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV7A"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType < 2 then
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a.txt')
  else
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a.txt');

  auxList.Clear;
  auxList.Add('How To Get More Builds:');
  auxList.Add(' ');
  auxList.Add('   :: Warning: Your system [Laz4Android ?] needs to be prepared [cross-compile] for the various builds!');
  auxList.Add(' ');
  auxList.Add('1. Edit Lazarus project file "*.lpi": [use notepad like editor]');
  auxList.Add(' ');
  auxList.Add('   > Open the "*.lpi" project file');
  auxList.Add(' ');
  auxList.Add('       -If needed replace the line <Libraries ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <TargetCPU ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <CustomOptions ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <TargetProcessor...../> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add(' ');
  auxList.Add('   > Save the modified "*.lpi" project file ');
  auxList.Add(' ');
  auxList.Add('2. From Lazarus/Laz4Android IDE');
  auxList.Add(' ');
  auxList.Add('   >Reopen the Project');
  auxList.Add(' ');
  auxList.Add('   > Run -> Build');
  auxList.Add(' ');
  auxList.Add('3. Repeat for others "build_*.txt" if needed...');
  auxList.Add(' ');
  auxList.Add('4. Execute [double click] the "build.bat" [or .sh] file to get the Apk !');

  if FProjectModel = 'Eclipse' then
  begin
    auxList.Add(' or [Eclipse IDE]');
    auxList.Add(' ');
    auxList.Add('   -right click your  project: -> Refresh [F5]');
    auxList.Add(' ');
    auxList.Add('   -right click your  project: -> Run as -> Android Application');
  end;

  auxList.Add(' ');
  auxList.Add(' ');
  auxList.Add('      Thank you!');
  auxList.Add('      By  ___jmpessoa_hotmail.com_____');

  if FModuleType < 2 then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'readme.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'readme.txt');

  if FModuleType < 2 then
  begin
    AProject.LazCompilerOptions.TargetFilename:=
          '..'+DirectorySeparator+'libs'+DirectorySeparator+auxStr+DirectorySeparator+'lib'+LowerCase(FJavaClassName){+'.so'};

    AProject.LazCompilerOptions.UnitOutputDirectory :=
         '..'+DirectorySeparator+'obj'+ DirectorySeparator+LowerCase(FJavaClassName); {-FU}

  end
  else  //2 -- noGUI console executable
  begin
    AProject.LazCompilerOptions.TargetFilename:=
            'libs'+DirectorySeparator+auxStr+DirectorySeparator+LowerCase(FSmallProjName);

    AProject.LazCompilerOptions.UnitOutputDirectory :='obj'; {-FU}

  end;

  {TargetProcessor}

  (* //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FInstructionSet <> 'x86' then
     AProject.LazCompilerOptions.TargetProcessor:= UpperCase(FInstructionSet); {-Cp}
  *)

  auxList.Free;
  sourceList.Free;
  Result := mrOK;

end;

function TAndroidProjectDescriptor.CreateStartFiles(AProject: TLazProject): TModalResult;
var
  d: TIDesigner;
  c: TComponent;
  s: TLazProjectFile;
begin
  case FModuleType of
  0: // GUI Controls
    AndroidFileDescriptor.ResourceClass:= TAndroidModule;
  1: // NoGUI Controls
    AndroidFileDescriptor.ResourceClass:= TNoGUIAndroidModule;
  2: // NoGUI Exe
    AndroidFileDescriptor.ResourceClass:= TAndroidConsoleDataForm;
  3: // NoGUI generic library
    AndroidFileDescriptor.ResourceClass:= nil;
  end;

  LazarusIDE.DoSaveProject([]); // TODO: change hardcoded "controls"

  LazarusIDE.DoNewEditorFile(AndroidFileDescriptor, '', '',
                             [nfIsPartOfProject,nfOpenInEditor,nfCreateDefaultSrc]);

  if FModuleType = 0 then // GUI
  begin
    // refresh theme
    with LazarusIDE do
      if ActiveProject.FileCount > 1 then
      begin
        s := ActiveProject.Files[1];
        d := GetDesignerWithProjectFile(s, True);
        c := d.LookupRoot;
        (TAndroidModule(c).Designer as TAndroidWidgetMediator).UpdateTheme;
      end;
  end;

  LazarusIDE.DoSaveProject([]); // save prompt for unit1

  Result := mrOK;
end;

{TAndroidFileDescPascalUnitWithResource}

constructor TAndroidFileDescPascalUnitWithResource.Create;
begin
  inherited Create;

  if  ModuleType < 3 then
  begin
    Name:= 'AndroidDataModule';
    if ModuleType = 0 then
    begin
      Name:= 'AndroidDataModule';
      ResourceClass := TAndroidModule
    end
    else if ModuleType = 1 then
    begin
       Name:= 'NoGUIAndroidDataModule';
       ResourceClass := TNoGUIAndroidModule
    end
    else  if ModuleType = 2 then
    begin
       Name:= 'AndroidConsoleDataForm';
       ResourceClass:= TAndroidConsoleDataForm;
    end;
    UseCreateFormStatements:= True;
  end;
end;

function TAndroidFileDescPascalUnitWithResource.GetResourceType: TResourceType;
begin
   Result:= rtRes;
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedName: string;
begin
   Result := 'LAMW Android GUI Module [jForm]';
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedDescription: string;
begin
   Result := 'Create a new GUI jForm Android Module [Lamw]';
   ActivityModeDesign:= actRecyclable;  //secondary jForm
end;

function TAndroidFileDescPascalUnitWithResource.CreateSource(const Filename     : string;
                                                       const SourceName   : string;
                                                       const ResourceName : string): string;
var
   sourceList: TStringList;
   uName:  string;
begin
   uName:= FileName;
   uName:= SplitStr(uName,'.');
   sourceList:= TStringList.Create;

   if ModuleType < 2 then
     sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder+DirectorySeparator+'jni }')
   else
     sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder +'}');

   sourceList.Add('unit '+uName+';');
   sourceList.Add('');
   if SyntaxMode = smDelphi then
      sourceList.Add('{$mode delphi}');
   if SyntaxMode = smObjFpc then
     sourceList.Add('{$mode objfpc}{$H+}');
   sourceList.Add('');
   sourceList.Add('interface');
   sourceList.Add('');

   if ModuleType = 3 then    sourceList.Add('{');

   sourceList.Add('uses');
   sourceList.Add('  ' + GetInterfaceUsesSection);

   if ModuleType = 3 then    sourceList.Add('}');

   if ModuleType = 1 then //no GUI
   begin
    sourceList.Add('');
    sourceList.Add('const');
    sourceList.Add('  gNoGUIjClassPath: string='''';');
    sourceList.Add('  gNoGUIjClass: JClass=nil;');
    sourceList.Add('  gNoGUIPDalvikVM: PJavaVM=nil;');
   end;

   if ModuleType < 3 then
   begin
     sourceList.Add(GetInterfaceSource(Filename, SourceName, ResourceName));
   end
   else
   begin
      sourceList.Add(' ');
     sourceList.Add('function SumAB(A: longint; B: longint): longint;');
     sourceList.Add(' ');
   end;

   sourceList.Add('implementation');
   sourceList.Add(' ');

   if ModuleType < 3 then
   begin
      sourceList.Add(GetImplementationSource(Filename, SourceName, ResourceName));
   end
   else
   begin
      sourceList.Add('function SumAB(A: longint; B: longint): longint;');
      sourceList.Add('begin');
      sourceList.Add('  Result:= A + B;');
      sourceList.Add('end;');
      sourceList.Add(' ');
   end;

   sourceList.Add('end.');

   Result:= sourceList.Text;

   sourceList.Free;
end;

function TAndroidFileDescPascalUnitWithResource.GetInterfaceUsesSection: string;
begin
  if ModuleType = 0 then //GUI controls module
     Result := 'Classes, SysUtils, AndroidWidget;'
  else if ModuleType = 1  then  //generic module: No GUI Controls
     Result := 'Classes, SysUtils, jni;'
  else // console app or generic library
     Result := 'Classes, SysUtils;'
end;

function TAndroidFileDescPascalUnitWithResource.GetInterfaceSource(const Filename     : string;
                                                             const SourceName   : string;
                                                           const ResourceName : string): string;
var
  strList: TStringList;
begin
  strList:= TStringList.Create;

  strList.Add(' ');
  strList.Add('type');
  if ModuleType = 0 then //GUI controls module
  begin
    if ResourceName <> '' then
       strList.Add('  T' + ResourceName + ' = class(jForm)')
    else
       strList.Add('  TAndroidModuleXX = class(jForm)');
  end
  else if ModuleType = 1 then//generic module
  begin
    if ResourceName <> '' then
      strList.Add('  T' + ResourceName + ' = class(TDataModule)')
    else
      strList.Add('  TNoGUIAndroidModuleXX  = class(TDataModule)');
  end
  else if ModuleType = 2 then //  console
  begin
    if ResourceName <> '' then
      strList.Add('  T' + ResourceName + ' = class(TDataModule)')
    else
      strList.Add('  TAndroidConsoleDataFormXX  = class(TDataModule)');
  end;

  strList.Add('  private');
  strList.Add('    {private declarations}');
  strList.Add('  public');
  strList.Add('    {public declarations}');
  strList.Add('  end;');
  strList.Add('');
  strList.Add('var');

  if ModuleType = 0 then //GUI controls module
  begin
    if ResourceName <> '' then
       strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
       strList.Add('  AndroidModuleXX: TDataMoule');
  end
  else if ModuleType = 1 then //generic module
  begin
    if ResourceName <> '' then
      strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
      strList.Add('  NoGUIAndroidModuleXX: TNoGUIDataMoule');
  end
  else if ModuleType = 2 then//2  console
  begin
    if ResourceName <> '' then
     strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
      strList.Add('  AndroidConsoleDataFormXX: TAndroidConsoleDataForm');
  end;

  if ModuleType < 3 then
    Result := strList.Text
  else
    Result:= '';

  strList.Free;
end;

function TAndroidFileDescPascalUnitWithResource.GetImplementationSource(
                                           const Filename     : string;
                                           const SourceName   : string;
                                           const ResourceName : string): string;
var
  sttList: TStringList;
begin
  sttList:= TStringList.Create;
  sttList.Add('{$R *.lfm}');

  sttList.Add(' ');

  Result:= sttList.Text;
  sttList.Free;
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

end.

