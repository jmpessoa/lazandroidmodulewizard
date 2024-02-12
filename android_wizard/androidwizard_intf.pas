unit AndroidWizard_intf;

{$Mode Delphi}

interface

uses
  Classes, SysUtils, FileUtil, Controls, Forms, Dialogs, Graphics, laz2_XMLRead, Laz2_DOM,
  LCLProc, LCLType, LCLIntf, LazIDEIntf, ProjectIntf, FormEditingIntf,
  uFormAndroidProject, uformworkspace, FPimage, AndroidWidget;

type

  TAndroidModule = class(jForm)            //support to Android Bridges [components]
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
     //FPathToNdkPlatforms: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
     //FPathToNdkToolchains: string;
     {C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3}
     FInstructionSet: string;    {ArmV6}
     FFPUSet: string;            {Soft}

     FPathToJavaTemplates: string;
     FPathToSmartDesigner: string;
     FAndroidProjectName: string;
     FModuleType: integer;     {-1: Gdx 0: GUI; 1: NoGUI; 2: NoGUI EXE Console; }
     FSyntaxMode: TSyntaxMode;   {}

     FPieChecked: boolean;
     FRawLibraryChecked: boolean; //raw .so
     FIsKotlinSupported: boolean;

     FPathToJavaJDK: string;
     FPathToAndroidSDK: string;  //Included TrailingPathDelimiter
     FPathToAndroidNDK: string;   //Included TrailingPathDelimiter
     FNDK: string; //alias  '>11'etc..
     FNDKIndex: integer; {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
     FNDKVersion: integer; //18

     FPathToAntBin: string;
     FPathToGradle: string;

     FProjectModel: string; //NEW or SAVED (that is, project already  exists!)
     FPackagePrefaceName: string;
     FMinApi: string;
     FTargetApi: string;

     FSupport: boolean;

     FTouchtestEnabled: string;
     FAntBuildMode: string;
     FMainActivity: string;
     FPathToJavaSrc: string;
     FNdkApi: string;

     FPrebuildOSys: string;

     FFullPackageName: string;
     FFullJavaSrcPath: string;
     FSmallProjName:  string; //ex. 'AppDemo1'
     FGradleVersion: string;
     FJavaMainVersion: string;

     FAndroidTheme: string;
     FAndroidThemeColor: string;       //new
     FAndroidTemplateTheme: string;  //new

     FBuildSystem: string;
     FMaxSdkPlatform: integer;
     FIniFileName: string;
     FIniFileSection: string;
     FKeepMyBuildGradleWhenReopen: boolean;

     function SettingsFilename: string;
     function TryNewJNIAndroidInterfaceCode(projectType: integer): boolean; //0: GUI  project --- 1:NoGUI project
     function GetPathToJNIFolder(fullPath: string): string;
     function GetWorkSpaceFromForm(projectType: integer; out outTag: integer): boolean;
     procedure DoReadme();
     procedure DoHowToGetsignedReleaseApk;
     procedure DoBuildGradle(strPack: string; androidPluginVersion: string;
                             gradleVersion: string; isKotlinSupported: boolean;
                             minSdkVersion: string; compileSdkVersion: string;
                             instructionChip: string; isAppCompTheme: boolean; isGradleBuildSystem: boolean);

     function GetAppName(className: string): string;

     function GetFolderFromApi(api: integer): string;

     function GetBuildTool(sdkApi: integer): string;
     function HasBuildTools(platform: integer;  out outBuildTool: string): boolean;

     function DoNewPathToJavaTemplate(): string;
     function GetPathToSmartDesigner(): string;
     procedure WriteIniString(Key, Value: string);
     function IsTemplateProject(tryTheme: string; out outAndroidTheme: string): boolean;

     function GetVerAsString(aVers: integer): string;

     function GetAndroidPluginVersion(gradleVersion: string; mainJavaVersion: string): string;
     function GetGradleVersionAsBigNumber(gradleVersionAsString: string): integer;
     function GetAndroidPluginVersionAsBigNumber(androidPluginVersionAsString: string): integer;

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

  {TAndroidNoGUIExeProjectDescriptor}

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
    ModuleType: integer;   //-1:gdx 0: GUI; 1: No GUI ; 2: console executable App; 3: generic library

    AndroidTheme: string;

    SmallProjName: string;

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

  function IsAllCharNumber(pcString: PChar): Boolean;

var
  AndroidProjectDescriptor: TAndroidProjectDescriptor;

  AndroidFileDescriptor: TAndroidFileDescPascalUnitWithResource;  //GUI

  AndroidGUIProjectDescriptor: TAndroidGUIProjectDescriptor;

  AndroidNoGUIExeProjectDescriptor: TAndroidNoGUIExeProjectDescriptor;


procedure Register;

function SplitStr(var theString: string; delimiter: string): string;

implementation

uses
   {$ifdef unix}BaseUnix,{$endif}
   LazFileUtils, uJavaParser, LamwSettings, LamwDesigner, SmartDesigner, IniFiles, PackageIntf;

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
  Name := 'Create a new LAMW [NoGUI] Android Console/Executable App';
end;

function TAndroidNoGUIExeProjectDescriptor.GetLocalizedName: string;
begin
  Result:= 'LAMW Android Console App';
end;

function TAndroidNoGUIExeProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:=  'LAMW [NoGUI] Android Console Application'+ LineEnding +
            '[Native Executable]'+ LineEnding +
            'using datamodule like form.'+ LineEnding +
            'The project is maintained by Lazarus.'
end;

function TAndroidNoGUIExeProjectDescriptor.DoInitDescriptor: TModalResult;    //NoGUI Exe
var
  list: TStringList;
  outTag: integer;
begin
  try
    FModuleType := 2; //-1: gdx 0: GUI --- 1:NoGUI --- 2: NoGUI EXE Console  3: generic library
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
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'arm64-v8a');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86_64');
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
        list.Add('Hello LAMW''s World!');
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
        list.Add('Hello LAMW''s World!');
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
  Name := 'Create a new LAMW [GUI] Android Module (.so)';
end;

function TAndroidGUIProjectDescriptor.GetLocalizedName: string;
begin
  Result:= 'LAMW [GUI] Android Module';
end;

function TAndroidGUIProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:=  'LAMW [GUI] Android loadable module (.so)'+ LineEnding +
            'based on Simonsayz''s templates'+ LineEnding +
            'with Form Designer and Android Components Bridges.'+ LineEnding +
            'The project and library file are maintained by Lazarus.';
  ActivityModeDesign:= actMain;  //main jForm
end;

function TAndroidGUIProjectDescriptor.DoInitDescriptor: TModalResult;    //GUI
var
  strAfterReplace, strPackName, aux, strMainActivity: string;
  auxList, providerList: TStringList;
  outTag: integer;
  supportProvider, tempStr, insertRef: string;
  p1: integer;
begin
  try
    FModuleType := 0; //0: GUI --- 1:NoGUI --- 2: NoGUI EXE Console
    FJavaClassName := 'Controls';
    FPathToClassName := '';

    if GetWorkSpaceFromForm(0, outTag) then //GUI
    begin
      strPackName:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);

      with TStringList.Create do
        try
          if FSupport then  // refactored by jmpessoa: UNIQUE "Controls.java" !!!
          begin

            if FileExists(FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'jSupported.java') then
            begin
              LoadFromFile(FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'jSupported.java');
              Strings[0] := 'package ' + strPackName + ';';  //replace dummy
              SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'jSupported.java');
            end;

            ForceDirectories(FAndroidProjectName + DirectorySeparator +'res'+DirectorySeparator+'xml');
            if FileExists(FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'support_provider_paths.xml') and
               (not FileExists(FAndroidProjectName + DirectorySeparator +'res'+DirectorySeparator+'xml'+DirectorySeparator+'support_provider_paths.xml'))then
            begin
              LoadFromFile(FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'support_provider_paths.xml');
              SaveToFile(FAndroidProjectName + DirectorySeparator +'res'+DirectorySeparator+'xml'+DirectorySeparator+'support_provider_paths.xml');
            end;

          end
          else
          begin
            if FileExists(FPathToJavaTemplates+DirectorySeparator+ 'jSupported.java') then
            begin
              LoadFromFile(FPathToJavaTemplates+DirectorySeparator+ 'jSupported.java');
              Strings[0] := 'package ' + strPackName + ';';  //replace dummy
              SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'jSupported.java');
            end;
          end;

          //UNIQUE and now Refactored "Controls.java" !!!
          LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'Controls.java');
          Strings[0] := 'package ' + strPackName + ';';  //replace dummy - Controls.java
          aux:=  StringReplace(Text, '/*libsmartload*/' ,
                 'try{System.loadLibrary("controls");} catch (UnsatisfiedLinkError e) {Log.e("JNI_Loading_libcontrols", "exception", e);}',
                 [rfReplaceAll,rfIgnoreCase]);
          Text:= aux;
          SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'Controls.java');

          //NEW GUI jForm Refactored from "Controls.java"
          Clear;
          if fileExists(FPathToJavaTemplates + DirectorySeparator + 'jForm.java') then
          begin
            LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'jForm.java');
            Strings[0] := 'package ' + strPackName + ';';  //replace dummy
            SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'jForm.java');
          end;

          Clear;
          if (Pos('AppCompat', FAndroidTheme) > 0) then
          begin
             if FileExists(FPathToJavaTemplates + DirectorySeparator + 'support'+DirectorySeparator+'App.java') then
               LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'support'+DirectorySeparator+'App.java');
          end
          else
          begin
             if FileExists(FPathToJavaTemplates + DirectorySeparator + 'App.java') then
               LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'App.java');
          end;

          Strings[0] := 'package ' + strPackName + ';'; //replace dummy App.java
          SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'App.java');

          CreateDir(FAndroidProjectName+DirectorySeparator+'lamwdesigner');
          if FileExists(FPathToJavaTemplates+DirectorySeparator + 'Controls.native') then
          begin
            CopyFile(FPathToJavaTemplates+DirectorySeparator + 'Controls.native',
              FAndroidProjectName+DirectorySeparator+'lamwdesigner'+DirectorySeparator+'Controls.native');
          end;

          if Pos('AppCompat', FAndroidTheme) > 0 then
          begin
            if FileExists(FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'jCommons.java') then
            begin
              LoadFromFile(FPathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'jCommons.java');
              Strings[0] := 'package ' + strPackName + ';';  //replace dummy
              SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'jCommons.java');
            end;
          end
          else
          begin
            if FileExists(FPathToJavaTemplates+DirectorySeparator+ 'jCommons.java') then
            begin
              LoadFromFile(FPathToJavaTemplates+DirectorySeparator+ 'jCommons.java');
              Strings[0] := 'package ' + strPackName + ';';  //replace dummy
              SaveToFile(FFullJavaSrcPath + DirectorySeparator + 'jCommons.java');
            end;
          end;
      finally
          Free;
      end;

      FPathToJNIFolder := FAndroidProjectName;
      AndroidFileDescriptor.PathToJNIFolder:= FPathToJNIFolder;
      AndroidFileDescriptor.SmallProjName:=  FSmallProjName;
      AndroidFileDescriptor.ModuleType:= 0;

      with TJavaParser.Create(FFullJavaSrcPath + DirectorySeparator+  'Controls.java') do
      try         //produce helper file [old] "ControlsEvents.txt"
        FPascalJNIInterfaceCode := GetPascalJNIInterfaceCode(FPathToJavaTemplates + DirectorySeparator + 'Controls.events');
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
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'arm64-v8a');
      CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86_64');
      CreateDir(FAndroidProjectName+DirectorySeparator+'obj');

      if  FModuleType < 2 then
        CreateDir(FAndroidProjectName+DirectorySeparator+'obj'+DirectorySeparator+'controls');

      auxList:= TStringList.Create;

      if FProjectModel = 'NEW' then   //new project (Ant)
      begin
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

        if Pos('AppCompat', FAndroidTheme) > 0 then
        begin
           if StrToInt(FTargetApi) >= 26 then  //
             auxList.Add('target=android-'+ FTargetApi)
           else
             auxList.Add('target=android-26');  //
        end
        else
        begin
           auxList.Add('target=android-'+FTargetApi);
        end;
        auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'project.properties');
      end;

      auxList.Clear;

      //AndroidManifest.xml setup....
      if FileExists(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml') then
        auxList.LoadFromFile(FAndroidProjectName + DirectorySeparator + 'AndroidManifest.xml')
      else
        auxList.LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'androidmanifest.txt');

      strAfterReplace  := StringReplace(auxList.Text, 'dummyPackage',strPackName, [rfReplaceAll, rfIgnoreCase]);

      strMainActivity:= strPackName+'.'+FMainActivity; {gApp}

      strAfterReplace  := StringReplace(strAfterReplace, 'dummyAppName',strMainActivity, [rfReplaceAll, rfIgnoreCase]);

      //    <!-- This is a comment -->
      strAfterReplace  := StringReplace(strAfterReplace, 'dummySdkApi', FMinApi, [rfReplaceAll, rfIgnoreCase]);
      strAfterReplace  := StringReplace(strAfterReplace, 'dummyTargetApi', FTargetApi, [rfReplaceAll, rfIgnoreCase]);

      if FBuildSystem  = 'Ant' then
      begin
         strAfterReplace  := StringReplace(strAfterReplace, '<!--', '', [rfReplaceAll, rfIgnoreCase]);
         strAfterReplace  := StringReplace(strAfterReplace, '-->', '', [rfReplaceAll, rfIgnoreCase]);
         strAfterReplace  := StringReplace(strAfterReplace, 'dummyMULTIDEX', '', [rfReplaceAll, rfIgnoreCase])
      end
      else //gradle
      begin
         strAfterReplace  := StringReplace(strAfterReplace, 'dummyMULTIDEX', 'android:name="androidx.multidex.MultiDexApplication"', [rfReplaceAll, rfIgnoreCase]);
      end;

      auxList.Clear;
      auxList.Text:= strAfterReplace;

      if FSupport then
      begin
         if FileExists(FPathToJavaTemplates +DirectorySeparator +'support'+DirectorySeparator+'manifest_support_provider.txt') then
         begin
           providerList:= TStringList.Create;
           providerList.LoadFromFile(FPathToJavaTemplates +DirectorySeparator+'support'+DirectorySeparator+'manifest_support_provider.txt');
           supportProvider:= StringReplace(providerList.Text, 'dummyPackage',strPackName, [rfReplaceAll, rfIgnoreCase]);
           tempStr:= auxList.Text;  //manifest
           if Pos('androidx.core.content.FileProvider', tempStr) <= 0 then    //androidX
           begin
             insertRef:= '</activity>'; //insert reference point
             p1:= Pos(insertRef, tempStr);
             Insert(sLineBreak + supportProvider, tempStr, p1+Length(insertRef));
             auxList.Clear;
             auxList.Text:= tempStr;
           end;
           providerList.Free;
         end;
      end;
      auxList.SaveToFile(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml');

      auxList.Free;
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

function TAndroidProjectDescriptor.GetPathToSmartDesigner(): string;
var
  Pkg: TIDEPackage;
begin
  if FPathToSmartDesigner = '' then
  begin
    Pkg:=PackageEditingInterface.FindPackageWithName('lazandroidwizardpack');
    if Pkg <> nil then
    begin
        FPathToSmartDesigner:= ExtractFilePath(Pkg.Filename) + 'smartdesigner';
        //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
    end;
  end;
  Result:=FPathToSmartDesigner;
end;

function TAndroidProjectDescriptor.DoNewPathToJavaTemplate(): string;
begin
   FPathToJavaTemplates:= GetPathToSmartDesigner() + pathDelim + 'java';
   Result:=FPathToJavaTemplates;
    //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner\java
end;

procedure TAndroidProjectDescriptor.WriteIniString(Key, Value: string);
var
  FIniFile: TIniFile;
begin
  FIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + FIniFileName);
  if FIniFile <> nil then
  begin
    FIniFile.WriteString(FIniFileSection, Key, Value);
    FIniFile.Free;
  end;
end;


function TAndroidProjectDescriptor.SettingsFilename: string;
var
    flag: boolean;
begin

    flag:= false;
    if not FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini') then
    begin
      if FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini') then
      begin
         FIniFileName:= 'LAMW.ini';
         FIniFileSection:= 'NewProject';
         CopyFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini',
                  IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
         //DeleteFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');
         FPathToJavaTemplates:= DoNewPathToJavaTemplate();
         FPathToSmartDesigner:= GetPathToSmartDesigner();
         flag:= True;
      end;
    end;

    if flag then
    begin
      WriteIniString('PathToJavaTemplates', FPathToJavaTemplates);
      WriteIniString('PathToSmartDesigner', FPathToSmartDesigner);
    end;

    Result := IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini';

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
  FModuleType:= projectType; //-1:gdx 0:GUI <--> 1:NoGUI <--> 2:NoGUI console Exe
  frm:= TFormAndroidProject.Create(nil);  //Create Form

  frm.PathToJavaTemplates:= FPathToJavaTemplates;
  frm.AndroidProjectName:= FAndroidProjectName;
  frm.MainActivity:= FMainActivity;
  frm.MinApi:= FMinApi;
  frm.TargetApi:= FTargetApi;
  frm.Support:=FSupport;

  frm.ProjectModel:= FProjectModel; //'NEW-> "new project"  or SAVED -> "project exists"

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

    //ShowMessage('try new jni FAndroidTheme = ' + FAndroidTheme);

    AndroidFileDescriptor.AndroidTheme:= FAndroidTheme;

    FPascalJNIInterfaceCode:= frm.PascalJNIInterfaceCode;

    FFullPackageName:= frm.FullPackageName;
    Result := True;
  end;
  frm.Free;
end;

constructor TAndroidProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create a new LAMW [NoGUI] Android Module (.so)';
end;

function TAndroidProjectDescriptor.GetLocalizedName: string;
begin
  Result := 'LAMW [NoGUI] Android Module'; //fix thanks to Stephano!
end;

function TAndroidProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := 'LAMW [NoGUI] Android loadable module (.so)'+ LineEnding +
            'using datamodule like form.'+ LineEnding +
            'No[!] Form Designer/Android and no Components Bridges!'+ LineEnding +
            'The project and library are maintained by Lazarus.'
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
     23: Result:= 'Marshmallow-6.0';
     24: Result:= 'Nougat-7.0';
     25: Result:= 'Nougat-7.1';
     26: Result:= 'Oreo-8.0';
     27: Result:= 'Oreo-8.1';
     28: Result:= 'Pie';
     29: Result:= 'Android-10.0';
     30: Result:= 'Android-11.0';
     31: Result:= 'Android-12.0';
     32: Result:= 'Android-13.0';
     33: Result:= 'Android-14.0';
  end;
end;

function TAndroidProjectDescriptor.HasBuildTools(platform: integer;  out outBuildTool: string): boolean;
begin
  Result:= True;
  if  platform < 30 then
     outBuildTool:= '29.0.3'
  else
     outBuildTool:= '30.0.3';
end;

function TAndroidProjectDescriptor.GetBuildTool(sdkApi: integer): string;
var
  tempOutBuildTool: string;
begin
  Result:= '';
  if HasBuildTools(sdkApi, tempOutBuildTool) then
  begin
     Result:= tempOutBuildTool;  //25.0.3    //***
  end;
end;

function TAndroidProjectDescriptor.GetVerAsString(aVers: integer): string;
begin
  Result:= '';
  case aVers of
     34: Result:= 'android-UpsideDownCake';
  end;
end;

procedure TAndroidProjectDescriptor.DoReadme();
var
    strList: TStringList;
begin
  strList:= TStringList.Create;
  strList.Add('Tutorial: How to get your Android Application [Apk] using "Ant":');
  strList.Add(' ');
  strList.Add('   NEW! Go to Lazarus IDE menu "Run--> [LAMW] Build and Run"! Thanks to Anton!!!');
  strList.Add(' ');
  strList.Add('1. Double click "ant-build-debug.bat [.sh]" to build Apk');
  strList.Add(' ');
  strList.Add('2. If Android Virtual Device[AVD]/Emulator [or real device] is running then:');
  strList.Add('   2.1 double click "install-'+FAntBuildMode+'.bat" to install the Apk on the Emulator [or real device]');
  strList.Add('   2.2 look for the App "'+FSmallProjName+'" in the Emulator [or real device] and click it!');
  strList.Add(' ');
  strList.Add('3. If AVD/Emulator is NOT running:');
  strList.Add('   3.1 If AVD/Emulator NOT exist:');
  strList.Add('        3.1.1 double click "paused_create-avd-default.bat" to create the AVD ['+DirectorySeparator+'utils folder]');
  strList.Add('   3.2 double click "launch-avd-default.bat" to launch the Emulator ['+DirectorySeparator+'utils  folder]');
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
  strList.Add('   WARNING: Yes, if after run  "ant-build-debug.*" the folder "...\bin" is still empty then try another target!' );
  strList.Add('   WARNING: If you changed the target in "build.xml" change it in "AndroidManifest.xml" too!' );
  strList.Add(' ');
  strList.Add('11.WARNING: After a new [Lazarus IDE]-> "run->build" do not forget to run again: "ant-build-debug.bat" and "install.bat" !');
  strList.Add(' ');
  strList.Add('12. Linux users: use "ant-build-debug.sh" , "install-'+FAntBuildMode+'.sh" , "uninstall.sh" and "logcat.sh" [thanks to Stephano!]');
  strList.Add('    WARNING: All demos Apps was generate on my windows system! So, please,  edit its to correct paths...!');
  strList.Add(' ');
  strList.Add('13. WARNING, before to execute "ant-build-release.bat" [.sh]  you need execute "release-keystore.bat" [.sh] !');
  strList.Add('    Please, read "How_To_Get_Your_Signed_Release_Apk.txt"');
  strList.Add(' ');
  strList.Add('14. Please, for more info, look for "How to use the Demos" in "LAMW: Lazarus Android Module Wizard" readme.txt!!');
  strList.Add(' ');
  strList.Add('....  Thank you!');
  strList.Add(' ');
  strList.Add('....  by jmpessoa_hotmail_com');
  strList.Add(' ');
  strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme.txt');
  strList.Free;
end;

procedure TAndroidProjectDescriptor.DoHowToGetsignedReleaseApk;
var
    strList: TStringList;
begin
    strList:= TStringList.Create;
    strList.Add('       Tutorial: How to get your "signed" release Apk ['+ FSmallProjName +']');
    strList.Add(' ');
    strList.Add('    NEW! ');
    strList.Add('    "Tools"  --> "[LAMW] ..." --> "Build Release Signed Apk  ..."');
    strList.Add('    "Tools"  --> "[LAMW] ..." --> "Build Release Signed Bundle ..."');
    strList.Add(' ');
    strList.Add(' ');
    strList.Add(' OR: ');
    strList.Add(' ');
    strList.Add('1)Edit/change the project file "keytool_input.txt" to more representative informations:"');
    strList.Add('');
    strList.Add('.Your keystore password [--ks-pass pass] : 123456');
    strList.Add('.Re-enter/confirm the keystore password: 123456');
    strList.Add(' ');
    strList.Add('.Your first and last name: MyFirstName MyLastName');
    strList.Add('');
    strList.Add('.Your Organizational unit: MyDevelopmentUnit');
    strList.Add('');
    strList.Add('.Your Organization name: MyCompany');
    strList.Add('');
    strList.Add('.Your City or Locality: MyCity');
    strList.Add('');
    strList.Add('.Your State or Province: MT' );
    strList.Add('');
    strList.Add('.The two-letter country code: BR');
    strList.Add('');
    strList.Add('.All correct: y');
    strList.Add('');
    strList.Add('.Your key password for this Apk alias [--key-pass pass]: 123456 ');
    strList.Add('');
    strList.Add('');
    strList.Add('2)If you are using "Ant" then edit/change "ant.properties" according, too!');
    strList.Add('');
    strList.Add('');
    strList.Add('3) Execute the [project] command "release-keystore.bat" or "release-keystore.sh" or "release-keystore-macos.sh" to get the "'+Lowercase(FSmallProjName)+'-release.keystore"');
    strList.Add('           warning: the file "'+Lowercase(FSmallProjName)+'-release.keystore" should be created only once [per application] otherwise it will fail [and NEVER delete it!]');
    strList.Add(' ');
    strList.Add('4) [Gradle]: Edit/change the values [123456] "--ks-pass pass:" and "--key-pass pass:" in project file "gradle-local-apksigner.bat" [or .sh]  according "keytool_input.txt" file');
    strList.Add('             Edit/change the values [123456] "--ks-pass pass:" and "--key-pass pass:" in project file "gradle-local-universal-apksigner.bat" [or .sh]  according "keytool_input.txt" file');
    strList.Add('');
    strList.Add('5) [Gradle]: Execute the [project] command "gradle-local-apksigner.bat" [.sh] to get the [release] signed Apk!');
    strList.Add('             OR execute "gradle-local-universal-apksigner.bat" [.sh] if your are supporting multi-architecture (ex.: armeabi-v7a + arm64-v8a + ...) ');
    strList.Add('             hint: look for your generated "'+FSmallProjName+'-release.apk" in [project] folder "...\build\outputs\apk\release"');
    strList.Add(' ');
    strList.Add('');
    strList.Add('6) [Ant]: Execute the [project] command "ant-build-release.bat" [.sh] to get the [release] signed Apk!"');
    strList.Add('          hint: look for your generated "'+FSmallProjName+'-release.apk" in [project] folder "...\bin"');
    strList.Add('');
    strList.Add('');
    strList.Add('Success! You can now upload your nice "'+FSmallProjName+'-release.apk" to "Google Play" [or others stores...]!');
    strList.Add('');
    strList.Add('....  Thanks to All!');
    strList.Add('....  Special thanks to ADiV/TR3E!');
    strList.Add('');
    strList.Add('....  by jmpessoa_hotmail_com');
    strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'How_To_Get_Your_Signed_Release_Apk.txt');
    strList.Free;
end;

function TAndroidProjectDescriptor.GetGradleVersionAsBigNumber(gradleVersionAsString: string): integer;
var
  auxStr: string;
  lenAuxStr: integer;
begin
  auxStr:= StringReplace(gradleVersionAsString,'.', '', [rfReplaceAll]); //6.6.1
  lenAuxStr:=  Length(auxStr);
  if lenAuxStr < 3 then auxStr:= auxStr + '0';   //6.8 -> 680
  Result:= StrToInt(Trim(auxStr));  //661
end;

procedure TAndroidProjectDescriptor.DoBuildGradle(strPack: string;
                                 androidPluginVersion: string; gradleVersion: string;
                                 isKotlinSupported: boolean; minSdkVersion: string; compileSdkVersion: string;
                                 instructionChip: string; isAppCompTheme: boolean; isGradleBuildSystem: boolean);
var
  strList: TStringList;
  directive: string;
  aAppCompatLib: TAppCompatLib;
  aSupportLib: TSupportLib;
  gradleVersionBigNumber: integer;
begin
  gradleVersionBigNumber:= GetGradleVersionAsBigNumber(gradleVersion);

  strList:= TStringList.Create;


  strList.Add('buildscript {');
  if isKotlinSupported then
    strList.Add('    ext.kotlin_version = ''1.6.10''');

  strList.Add('    repositories {');
  strList.Add('        mavenCentral()');
  strList.Add('        google()');
  strList.Add('    }');
  strList.Add('    dependencies {');
  strList.Add('        classpath ''com.android.tools.build:gradle:'+androidPluginVersion+''' '); //7.1.3
  if isKotlinSupported then
    strList.Add('        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"');

  strList.Add('    }');
  strList.Add('}');
  strList.Add('allprojects {');
  strList.Add('    repositories {');
  strList.Add('       jcenter()');
  strList.Add('       google()');
  strList.Add('       mavenCentral()');
  strList.Add('       maven {url ''https://jitpack.io''}');
  strList.Add('    }');
  strList.Add('}');
  strList.Add('apply plugin: ''com.android.application''');

  if isKotlinSupported then
   strList.Add('apply plugin: ''kotlin-android''');

  strList.Add('android {');

  if FJavaMainVersion <> '' then
  begin
    if StrToInt(FJavaMainVersion) >= 17  then
        if GetAndroidPluginVersionAsBigNumber(androidPluginVersion) >= 820 then
            strList.Add('    namespace "'+strPack+'"'); //org.lamw.applamwproject1
  end;
  strList.Add('    splits {');
  strList.Add('        abi {');
  strList.Add('            enable true');
  strList.Add('            reset()');
  strList.Add('            include '''+instructionChip+'''');
  strList.Add('            universalApk false');
  strList.Add('        }');
  strList.Add('    }');
  strList.Add('    compileOptions {');
  strList.Add('        sourceCompatibility 1.8');
  strList.Add('        targetCompatibility 1.8');
  strList.Add('    }');
  strList.Add('    compileSdk '+compileSdkVersion+'');

  strList.Add('    defaultConfig {');
  strList.Add('            minSdkVersion '+minSdkVersion+'');
  strList.Add('            targetSdkVersion '+compileSdkVersion+'');
  strList.Add('            versionCode 6682784');
  strList.Add('            versionName "1.0"');
  strList.Add('            multiDexEnabled true');
  strList.Add('            ndk { debugSymbolLevel ''FULL'' }');
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
  strList.Add('            jniLibs.srcDirs = [''libs'']');
  strList.Add('        }');
  strList.Add('        debug.setRoot(''build-types/debug'')');
  strList.Add('        release.setRoot(''build-types/release'')');
  strList.Add('    }');
  strList.Add('    buildTypes {');
  strList.Add('        debug {');
  strList.Add('            minifyEnabled false');
  strList.Add('            debuggable true');
  strList.Add('            jniDebuggable true');
  strList.Add('        }');
  strList.Add('        release {');
  strList.Add('            minifyEnabled false');
  strList.Add('            debuggable false');
  strList.Add('            jniDebuggable false');
  strList.Add('        }');
  strList.Add('    }');
  if gradleVersionBigNumber >= 820 then
  begin
    strList.Add('    buildFeatures {');
    strList.Add('        aidl true');
    strList.Add('    }');
    strList.Add('    lint {');
    strList.Add('        abortOnError false');
    strList.Add('    }');
  end
  else
  begin
    strList.Add('    lintOptions {');
    strList.Add('       abortOnError false');
    strList.Add('    }');
  end;
  strList.Add('}');

  strList.Add('dependencies {');
  strList.Add('    implementation  fileTree(include: [''*.jar''], dir: ''libs'')');

  directive:= 'implementation';
  if isAppCompTheme then
  begin
    for aAppCompatLib in AppCompatLibs do
    begin
       strList.Add('    '+directive+' '''+aAppCompatLib.Name+'''');
       if aAppCompatLib.MinAPI > StrToInt(compileSdkVersion) then
             ShowMessage('Warning: AppCompat theme need Android SDK >= ' + IntToStr(aAppCompatLib.MinAPI));
    end;
    if isKotlinSupported then
    begin
       strList.Add('    '+directive+'("androidx.core:core-ktx:1.3.2")');
       strList.Add('    '+directive+'("org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version")');
    end;
  end
  else if isGradleBuildSystem then//only gradle not AppCompat
  begin
    for aSupportLib in SupportLibs do
    begin
       strList.Add('    '+directive+' '''+aSupportLib.Name+'''');
       if aSupportLib.MinAPI > StrToInt(compileSdkVersion) then
             ShowMessage('Warning: Support library need Android SDK >= ' + IntToStr(aSupportLib.MinAPI));
    end;
  end;

  strList.Add('}');

  strList.Add('tasks.register(''run'', Exec) {');
  strList.Add(' dependsOn '':installDebug''');
  strList.Add('	if (System.properties[''os.name''].toLowerCase().contains(''windows'')) {');
  strList.Add('	    commandLine ''cmd'', ''/c'', ''adb'', ''shell'', ''am'', ''start'', ''-n'', "'+strPack+'/.App"');
  strList.Add('	} else {');
  strList.Add('	    commandLine ''adb'', ''shell'', ''am'', ''start'', ''-n'', "'+strPack+'/.App"');
  strList.Add('	}');
  strList.Add('}');
  strList.Add(' ');
  if gradleVersionBigNumber < 820 then
  begin
    strList.Add('wrapper {');
    strList.Add('    gradleVersion = '''+gradleVersion+''' ');  //8.2.1
    strList.Add('}');
  end;
  strList.SaveToFile(FAndroidProjectName+PathDelim+'build.gradle');
  strList.Free;

end;

function TAndroidProjectDescriptor.GetAndroidPluginVersionAsBigNumber(androidPluginVersionAsString: string): integer;
var
  auxStr: string;
  lenAuxStr: integer;
begin
  auxStr:= StringReplace(androidPluginVersionAsString,'.', '', [rfReplaceAll]); //8.1.1
  lenAuxStr:=  Length(auxStr);
  if lenAuxStr < 3 then auxStr:= auxStr + '0';   //8.4 -> 840
  Result:= StrToInt(Trim(auxStr));  //811
end;

{
//https://developer.android.com/studio/releases/gradle-plugin?hl=pt-br

Android
plug-in

8.2.0  <--> Android Gradle plugin requiresJava 17 ... 21   //Gradle versão 8.5
8.1.4  <--> Android Gradle plugin requiresJava 17   //Gradle versão 8.4
8.0.2  <--> Android Gradle plugin requires Java 17. //Gradle versão 8.3
8.0.0  <--> Android Gradle plugin requires Java 17. //Gradle versão 8.3

7.4.2  <--> Android Gradle plugin requires Java 11  //Gradle versão 8.1.1

7.3.1  <--> Gradle versão 8.1.1   //https://docs.gradle.org/8.1.1/userguide/compatibility.html
7.2.2  <--> Gradle versão 7.6.3
7.1.3  <--> Gradle versão 7.6.3  //https://docs.gradle.org/7.6.3/userguide/compatibility.html
7.0.4  <--> Gradle versão 7.6.2  //7.0, 7.1, 7.2, 7.3 and 7.4
4.2.2  <--> Gradle versão 6.9.4
4.1.3  <--> Gradle versão 6.6.1    //3.4, 3.5, 3.6 and 4.0
}

(*About Android Studio "Hedgehog")
JDK 17
Nível da API 34
Versão mínima do "Android Plugin" 8.1.1 (requiresJava 17)
*)
//https://docs.gradle.org/8.4/userguide/compatibility.html#java
function TAndroidProjectDescriptor.GetAndroidPluginVersion(gradleVersion: string; mainJavaVersion: string): string;
var
  strGV, auxGrVer: string;
  intGV: integer;
  bigNumber: integer;
begin

  bigNumber:= GetGradleVersionAsBigNumber(gradleVersion);
  auxGrVer:= gradleVersion;
  strGV:= SplitStr(auxGrVer,  '.');
  intGV:= StrToInt(strGV);

  if intGV = 8 then  //JDK 11 - need Gradle version >=  6.7.1 -- targetApi 33
  begin              //JDK 17 - need Gradle version >=  8.2 -- targetApi 34
     if mainJavaVersion = '11' then //targetApi 33
       Result:= '7.4.2'   //JDK 11
     else
       Result:= '8.2.0';   //targetApi 34
  end;

  if intGV = 7 then   //JDK 11
  begin
     Result:= '7.2.2'; //Tested Gradle 7.6.3
  end;

  if intGV = 6 then     //JDK 1.8 need Gradle version <=  6.7 .... and JDK 11 >= 6.7.1
  begin
     if  bigNumber >= 671 then //JDK 11   //Tested Gradle 6.7.1
     begin
        Result:= '4.2.2';
     end
     else                      //JDK 1.8
     begin
        Result:= '4.1.3'
     end;
  end;

  if intGV < 6 then             //JDK 1.8
  begin
     Result:= '3.4.1';
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
    {$ifdef unix}
    FpChmod(AFileName, &751);
    {$endif}
  end;

var
  frm: TFormWorkspace;
  strList: TStringList;
  i, count, intTargetApi, intMinApi: integer;
  linuxDirSeparator: string;
  linuxPathToJavaJDK: string;
  linuxPathToAndroidSdk: string;
  linuxAndroidProjectName: string;
  linuxPathToGradle: string;
  tempStr: string;
  instructionChip, apkName: string;
  linuxPathToAdbBin: string;
  linuxPathToAntBin: string;
  apk_aliaskey, strText: string;
  strPack: string;
  sdkBuildTools, androidPluginVersion: string;
  outTheme: string;
  isAppCompatTheme, isGradleBuildSystem: boolean;
begin
  Result:= False;
  FModuleType:= projectType; //-1:gdx 0:GUI  1:NoGUI 2: NoGUI EXE Console 3: generic library

  AndroidFileDescriptor.ModuleType:= projectType;
  strList:= nil;
  frm:= TFormWorkspace.Create(nil);
  try
    strList:= TStringList.Create;

    frm.ModuleType:= projectType;

    frm.LoadSettings(SettingsFilename);

    frm.ComboSelectProjectName.Text:= MakeUniqueName('AppLAMWProject', frm.ComboSelectProjectName.Items);

    frm.LabelTheme.Caption:= 'Android Theme:';
    frm.ComboBoxTheme.Visible:= True;
    frm.SpeedButtonHintTheme.Visible:= True;

    frm.CheckBoxPIE.Visible:= False;
    frm.CheckBoxGeneric.Visible:= False; //support to Kotlin need "AppCompat" theme and Gradle
    if FModuleType = 0 then //GUI
    begin
      frm.CheckBoxGeneric.Caption:= 'Add support to Kotlin'; //bad reuse ... sorry
    end;

    if FModuleType = 1 then //No GUI
    begin
      frm.Color:= clWhite;
      frm.PanelButtons.Color:= clWhite;

      frm.ComboSelectProjectName.Text:= MakeUniqueName('AppLAMWNoGUIProject', frm.ComboSelectProjectName.Items);

      frm.LabelTheme.Caption:= 'App LAMW [NoGUI] Project';
      frm.ComboBoxTheme.Visible:= False;
      frm.SpeedButtonHintTheme.Visible:= False;
    end;

    if FModuleType = 2 then //No GUI console executable or generic library [.so]
    begin
      frm.GroupBox1.Visible:= False;
      frm.GroupBox5.Visible:= False;

      frm.Color:= clGradientInactiveCaption;
      frm.PanelButtons.Color:= clGradientInactiveCaption;

      frm.ComboSelectProjectName.Text:= MakeUniqueName('LamwConsoleApp', frm.ComboSelectProjectName.Items);

      frm.LabelTheme.Caption:= 'App LAMW [NoGUI] Android Console/Executable Project';
      frm.EditPackagePrefaceName.Visible:= False;

      frm.EditPackagePrefaceName.Text:= '';
      frm.EditPackagePrefaceName.Enabled:= False;

      frm.ComboBoxTheme.Visible:= False;
      frm.SpeedButtonHintTheme.Visible:= False;

      frm.CheckBoxPIE.Visible:= True;
      frm.CheckBoxGeneric.Visible:= True;  //support to raw [not jni] .so library

    end;

    if frm.ShowModal = mrOK then
    begin
      frm.SaveSettings(SettingsFilename); //LAMW.ini

      FBuildSystem:= frm.BuildSystem;
      FAndroidTheme:= frm.AndroidTheme;

      FKeepMyBuildGradleWhenReopen:= frm.KeepMyBuildGradleWhenReopen;
      FIsKotlinSupported:= frm.IsKotlinSupported;

      FAndroidThemeColor:= frm.AndroidThemeColor;
      FAndroidTemplateTheme:= '';

      if IsTemplateProject(FAndroidTheme, outTheme) then
      begin
        FAndroidTemplateTheme:= FAndroidTheme;
        FAndroidTheme:= outTheme;
      end;

      FJavaClassName:= frm.JavaClassName;
      FSmallProjName:= frm.SmallProjName;
      FInstructionSet:= frm.InstructionSet;{ ex. ArmV6, ArmV7a, ArmV8}
      FFPUSet:= frm.FPUSet; {ex. Soft}
      FAndroidProjectName:= frm.AndroidProjectName;    //warning: full project name = path + name !
      FPathToJavaSrc:= FAndroidProjectName+DirectorySeparator+ 'src';

      FPathToJavaTemplates:= frm.PathToJavaTemplates;
      FPathToSmartDesigner:= frm.PathToSmartDesigner;
      FPathToJavaJDK:= frm.PathToJavaJDK;

      FPathToAndroidSDK:= frm.PathToAndroidSDK;
      FPathToAndroidNDK:= frm.PathToAndroidNDK;
      //prepare to LamwSettings model ...
      FPathToAndroidNDK:= IncludeTrailingPathDelimiter(FPathToAndroidNDK);
      FPathToAndroidSDK:= IncludeTrailingPathDelimiter(FPathToAndroidSDK);

      FPrebuildOSys:= frm.PrebuildOSys;

      FNDK:= frm.NDK; //alias '>11',  etc...
      FNDKIndex:= frm.NDKIndex;  {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
      FNDKVersion:=frm.NDKVersion; //ex 18

      //FAndroidPlatform:= frm.AndroidPlatform; //"android-15" model was deprecated/droped after NDK 21
      FNdkApi:= frm.NdkApi; //just 14 or 22 etc...

      FPathToAntBin:= frm.PathToAntBin;
      FPathToGradle:= frm.PathToGradle;

      FMinApi:= frm.MinApi;
      FTargetApi:= frm.TargetApi;

      //FSupport:= (LazarusIDE.ActiveProject.CustomData.Values['Support']='TRUE');
      FSupport:=frm.Support;

      FPieChecked:= frm.PieChecked;
      FRawLibraryChecked:= frm.RawLibraryChecked;

      FMaxSdkPlatform:= frm.MaxSdkPlatform;

      FGradleVersion:= frm.GradleVersion;
      FJavaMainVersion:= frm.JavaMainVersion;

      strList.Clear;
      if frm.ManifestData <> nil then
      begin
        count:= frm.ManifestData.Count;  //custom manifest permissions...
        if count > 0 then
        begin
          strList.Add('<?xml version="1.0" encoding="utf-8"?>');
          strList.Add('<manifest xmlns:android="http://schemas.android.com/apk/res/android" xmlns:tools="http://schemas.android.com/tools" package="dummyPackage" android:versionCode="1" android:versionName="1.0">');
          strList.Add('<!-- <uses-sdk android:minSdkVersion="dummySdkApi" android:targetSdkVersion="dummyTargetApi"/> -->');

          for i:= 0 to count-1 do
          begin
            if Pos('BATTERY_STATS', frm.ManifestData.Strings[i]) > 0 then
               strList.Add('<uses-permission android:name="'+frm.ManifestData.Strings[i]+'" tools:ignore="ProtectedPermissions"/>')
            else if Pos('CHANGE_CONFIGURATION', frm.ManifestData.Strings[i]) > 0 then
               strList.Add('<uses-permission android:name="'+frm.ManifestData.Strings[i]+'" tools:ignore="ProtectedPermissions"/>')
            else
               strList.Add('<uses-permission android:name="'+frm.ManifestData.Strings[i]+'"/>');
          end;
          frm.ManifestData.Clear;

          strList.Add('<uses-feature android:name="android.hardware.camera" android:required="false"/>');
          strList.Add('<uses-feature android:name="android.hardware.camera.flash" android:required="false"/>');
          strList.Add('<uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>');
          strList.Add('<uses-feature android:glEsVersion="0x00020000" android:required="true"/>');
          strList.Add('<uses-feature android:name="android.hardware.telephony" android:required="false"/>');
          strList.Add('<uses-feature android:name="android.hardware.sensor.stepcounter" android:required="false"/>');
          strList.Add('<uses-feature android:name="android.hardware.sensor.stepdetector" android:required="false"/>');
          strList.Add('<supports-screens');
          strList.Add('    android:smallScreens="true"');
          strList.Add('    android:normalScreens="true"');
          strList.Add('    android:largeScreens="true"');
          strList.Add('    android:xlargeScreens="true"');
          strList.Add('    android:anyDensity="true"/>');
          strList.Add('<application');
          strList.Add('    android:requestLegacyExternalStorage="true"');
          strList.Add('	   android:usesCleartextTraffic="true"');
          strList.Add('    android:allowBackup="true"');
          strList.Add('    android:icon="@mipmap/ic_launcher"');
          strList.Add('    android:label="@string/app_name"');
          strList.Add('    android:theme="@style/AppTheme"');
          strList.Add('    dummyMULTIDEX>');
          strList.Add('    <activity');
          strList.Add('        android:name="dummyAppName"');
          strList.Add('        android:configChanges="orientation|keyboardHidden|screenSize|screenLayout|fontScale"');
          strList.Add('        android:launchMode="standard" android:enabled="true" android:exported="true">');
          strList.Add('        <intent-filter>');
          strList.Add('            <action android:name="android.intent.action.MAIN"/>');
          strList.Add('            <category android:name="android.intent.category.LAUNCHER"/>');
          strList.Add('        </intent-filter>');
          strList.Add('    </activity>');
          strList.Add('</application>');
          strList.Add('</manifest> ');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml');
          strList.Clear;
        end;
      end;

      if Pos('Library', frm.CheckBoxGeneric.Caption) >= 0 then  //bad CheckBox reuse... sorry!
      begin
        if FRawLibraryChecked then
        begin
          outTag:= 3;
          FModuleType:= 3;  //build raw .so library
        end;
      end;

      FMainActivity:= frm.MainActivity;  //App
      FJavaClassName:= frm.JavaClassName;

      FProjectModel:= frm.ProjectModel;   //<-- NEW or SAVED

      if FProjectModel = 'SAVED' then     //please, read as "project exists!"
          FFullJavaSrcPath:= frm.FullJavaSrcPath;


      if  frm.TouchtestEnabled = 'True' then
         FTouchtestEnabled:= '-Dtouchtest.enabled=true'
      else
         FTouchtestEnabled:='';

      FAntBuildMode:= frm.AntBuildMode;
      FPackagePrefaceName:= frm.PackagePrefaceName; // ex.: org.lamw  or  example.com
      AndroidFileDescriptor.PathToJNIFolder:= FAndroidProjectName;

      tempStr:= LowerCase(FInstructionSet);
      if Length(tempStr)>0 then
      begin
      if tempStr = 'armv6'  then instructionChip:='armeabi';
      if tempStr = 'armv7a' then instructionChip:='armeabi-v7a';
      if tempStr = 'x86'    then instructionChip:='x86';
      if tempStr = 'x86_64' then instructionChip:='x86_64';
      if tempStr = 'mipsel' then instructionChip:='mips';
      if tempStr = 'armv8'  then instructionChip:='arm64-v8a';
      end
      else
      begin
        instructionChip:= ExtractFileDir(LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename);
        instructionChip:= ExtractFileName(instructionChip);
      end;

      try
        if FProjectModel = 'NEW' then   //please read as "new project"...
        begin
          if FModuleType < 2 then   //-1:gdx 0: GUI project   1: NoGui project   2: NoGUI Exe
          begin
            ForceDirectories(FAndroidProjectName + DirectorySeparator + 'src');

            FPathToJavaSrc:= FAndroidProjectName+DirectorySeparator+ 'src';

            FFullJavaSrcPath:= FPathToJavaSrc;  //initialize

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

            ForceDirectories(FAndroidProjectName+DirectorySeparator+'res'+DirectorySeparator+'drawable');
            ForceDirectories(FAndroidProjectName+DirectorySeparator+'res'+DirectorySeparator+'xml');

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

            //Android Studio compatibility
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable'+DirectorySeparator+'ic_launcher_background.xml',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable'+DirectorySeparator+'ic_launcher_background.xml');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-v24');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-v24'+DirectorySeparator+'ic_launcher_foreground.xml',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-v24'+DirectorySeparator+'ic_launcher_foreground.xml');


            //mipmap support
            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-xxxhdpi');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'mipmap-xxxhdpi'+DirectorySeparator+'ic_launcher.webp',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-xxxhdpi'+DirectorySeparator+'ic_launcher.webp');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'mipmap-xxxhdpi'+DirectorySeparator+'ic_launcher_round.webp',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-xxxhdpi'+DirectorySeparator+'ic_launcher_round.webp');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-xxhdpi');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'mipmap-xxhdpi'+DirectorySeparator+'ic_launcher.webp',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-xxhdpi'+DirectorySeparator+'ic_launcher.webp');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'mipmap-xxhdpi'+DirectorySeparator+'ic_launcher_round.webp',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-xxhdpi'+DirectorySeparator+'ic_launcher_round.webp');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-xhdpi');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'mipmap-xhdpi'+DirectorySeparator+'ic_launcher.webp',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-xhdpi'+DirectorySeparator+'ic_launcher.webp');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'mipmap-xhdpi'+DirectorySeparator+'ic_launcher_round.webp',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-xhdpi'+DirectorySeparator+'ic_launcher_round.webp');


            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-hdpi');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'mipmap-hdpi'+DirectorySeparator+'ic_launcher.webp',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-hdpi'+DirectorySeparator+'ic_launcher.webp');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'mipmap-hdpi'+DirectorySeparator+'ic_launcher_round.webp',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-hdpi'+DirectorySeparator+'ic_launcher_round.webp');


            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-anydpi-v26');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'mipmap-anydpi-v26'+DirectorySeparator+'ic_launcher.xml',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-anydpi-v26'+DirectorySeparator+'ic_launcher.xml');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'mipmap-anydpi-v26'+DirectorySeparator+'ic_launcher_round.xml',
                     FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'mipmap-anydpi-v26'+DirectorySeparator+'ic_launcher_round.xml');

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');

            if DirectoryExists(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'colors'+DirectorySeparator+FAndroidThemeColor) then
               CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'colors'+DirectorySeparator+FAndroidThemeColor+DirectorySeparator+'colors.xml',
                  FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml')
            else
              CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'colors.xml',
                  FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml');

            //Android Studio compatiblity
            CreateDir(FAndroidProjectName+DirectorySeparator+'gradle');
            ForceDirectories(FAndroidProjectName+DirectorySeparator+'gradle'+DirectorySeparator+'wrapper');
            StrList.Clear;
            strList.Add('distributionBase=GRADLE_USER_HOME');
            strList.Add('distributionPath=wrapper/dists');
            strList.Add('distributionUrl=https\://services.gradle.org/distributions/gradle-'+FGradleVersion+'-bin.zip');  //8.2.1
            strList.Add('networkTimeout=10000');
            strList.Add('zipStoreBase=GRADLE_USER_HOME');
            strList.Add('zipStorePath=wrapper/dists');
            strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'gradle'+DirectorySeparator+'wrapper'+DirectorySeparator+'gradle-wrapper.properties');

            if Pos('AppCompat', FAndroidTheme) > 0 then
            begin
                CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+FAndroidTheme+'.xml',
                          FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'styles.xml');
            end
            else
            begin
               CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'styles.xml',
                         FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'styles.xml');
            end;

            strList.Clear;
            strList.Add('<?xml version="1.0" encoding="utf-8"?>');
            strList.Add('<resources>');
            strList.Add('   <string name="app_name">'+FSmallProjName+'</string>');
            strList.Add('   <string name="hello_world">Hello world!</string>');
            strList.Add('</resources>');
            strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'strings.xml');

            {
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'colors.xml',
                         FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml');
            }

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v11');

            intTargetApi:= StrToInt(FTargetApi);
            if intTargetApi < 14 then   intTargetApi:= 14;
            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14');
            //replace "dummyTheme" ..res\values-v14
            strList.Clear;
            strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values-v14'+DirectorySeparator+'styles.xml');

            if (intTargetApi >= 14) and (intTargetApi < 21) then
               strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.'+FAndroidTheme, [rfReplaceAll])
            else
               strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.DeviceDefault', [rfReplaceAll]);

            strList.Text:= strText;
            strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14'+DirectorySeparator+'styles.xml');

            intMinApi:= StrToInt(FMinApi);

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v21');

            //replace "dummyTheme" ..res\values-v21
            strList.Clear;
            if Pos('AppCompat', FAndroidTheme) <= 0  then  //not AppCompat
            begin
              CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v21');
              //replace "dummyTheme" ..res\values-v21
              if intMinApi >= 21 then
              begin
                strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values-v21'+DirectorySeparator+'styles.xml')
              end
              else
                strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values-v21'+DirectorySeparator+'styles-empty.xml');

              if (intTargetApi >= 21) then
              begin
                strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.'+FAndroidTheme, [rfReplaceAll])
              end
              else
              begin
                strText:= StringReplace(strList.Text,'dummyTheme', 'android:Theme.DeviceDefault', [rfReplaceAll]);
              end;

              strList.Text:= strText;
              strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v21'+DirectorySeparator+'styles.xml');
            end;

            CreateDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout');
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml',
                         FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml');

            CreateDir(FAndroidProjectName+ DirectorySeparator + 'assets');
            CreateDir(FAndroidProjectName+ DirectorySeparator + 'bin');
            CreateDir(FAndroidProjectName+ DirectorySeparator + 'gen');

          end;

          if FModuleType <= 0  then  //Android Bridges Controls... [GUI]
          begin
            if not FileExists(FFullJavaSrcPath+DirectorySeparator+'App.java') then
            begin
               strList.Clear; //dummy App.java - will be replaced with simonsayz's "App.java" template!
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
               strList.Add('    <application');
               strList.Add('        android:allowBackup="true"');
               strList.Add('        android:icon="@drawable/ic_launcher"');
               strList.Add('        android:label="@string/app_name"');
               strList.Add('        android:theme="@style/AppTheme" >');
               strList.Add('        <activity');
               strList.Add('            android:name="'+FPackagePrefaceName+'.'+LowerCase(FSmallProjName)+'.App">');
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

        if FModuleType < 2 then    {0: GUI; 1: NoGUI; 2: NoGUI EXE Console}
        begin
          strList.Clear;
          //begin_cmd_tools
          strList.Add('set Path=%PATH%;'+FPathToAntBin); //<--- thanks to andersonscinfo !  [set path=%path%;C:\and32\ant\bin]
          strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('call ant clean -Dtouchtest.enabled=true debug');
          strList.Add('if errorlevel 1 pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'ant-build-debug.bat'); //build Apk using "Ant"

          strList.Clear;
          strList.Add('set Path=%PATH%;'+FPathToAntBin); //<--- thanks to andersonscinfo !
          strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('call ant clean release');
          strList.Add('if errorlevel 1 pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'ant-build-release.bat'); //build Apk using "Ant"

          strList.Clear;
          strList.Add('cd '+FPathToAndroidSDK+'tools');
          if StrToInt(FMinApi) >= 15 then
            strList.Add('emulator -avd avd_default +  -gpu on &')  //gpu: api >= 15,,,
          else
            strList.Add('tools emulator -avd avd_api_'+FMinApi + ' &');
          strList.Add('cd '+FAndroidProjectName);
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'launch-avd-default.bat');

          strList.Clear;
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb install -r '+FAndroidProjectName+DirectorySeparator+'bin'+DirectorySeparator+FSmallProjName+'-debug.apk');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'ant-adb-install-debug.bat');

          strList.Clear;
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb install -r '+FAndroidProjectName+DirectorySeparator+'build'+DirectorySeparator+'outputs'+DirectorySeparator+'apk'+DirectorySeparator+'debug'+DirectorySeparator+FSmallProjName+'-'+instructionChip+'-debug.apk');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'gradle-adb-install-debug.bat');

          strList.Clear;
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'adb-uninstall.bat');

          strList.Clear;
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb logcat &');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'logcat.bat');

          //utils
          CreateDir(FAndroidProjectName+ DirectorySeparator + 'utils');

          {"android list targets" to see the available targets...}
          strList.Clear;
          strList.Add('cd '+FPathToAndroidSDK+'tools');
          strList.Add('android list targets');
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'list-target.bat');

          //need to pause on double-click use...
          strList.Clear;
          strList.Add('cmd /K list-target.bat');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused-list-target.bat');

          strList.Clear;
          strList.Add('cd '+FPathToAndroidSDK+'tools');
          strList.Add('android create avd -n avd_default -t 1 -c 32M');
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'create-avd-default.bat');

          //need to pause on double-click use...
          strList.Clear;
          strList.Add('cmd /k create-avd-default.bat');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused-create-avd-default.bat');

          strList.Clear;
          strList.Add(FPathToAndroidSDK+'platform-tools'+
                     DirectorySeparator+'adb logcat AndroidRuntime:E *:S');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'logcat-error.bat');

          strList.Clear;
          strList.Add(FPathToAndroidSDK+'platform-tools'+DirectorySeparator+
                     'adb logcat ActivityManager:I '+FSmallProjName+'-'+FAntBuildMode+'.apk:D *:S');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'logcat-app-perform.bat');

          //end_utils

          //build.xml
          strList.Clear;
          strList.Add('<?xml version="1.0" encoding="UTF-8"?>');
          strList.Add('<project name="'+FSmallProjName+'" default="help">');
          strList.Add('<property name="sdk.dir" location="'+FPathToAndroidSDK+'"/>');

          if (Pos('AppCompat', FAndroidTheme) > 0) and (intTargetApi < 21) then
            strList.Add('<property name="target" value="android-21"/>')
          else
            strList.Add('<property name="target" value="android-'+Trim(FTargetApi)+'"/>');

          strList.Add('<property file="ant.properties"/>');
          strList.Add('<fail message="sdk.dir is missing." unless="sdk.dir"/>');

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
            if i <= intTargetApi then
              strList.Add('<property name="api'+IntToStr(i)+'" value="true"/>') //does the magic!!!!
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

          //end_build.xml

          DoReadme;

          apk_aliaskey:= LowerCase(FSmallProjName)+'.keyalias';

          strList.Clear;
          strList.Add('java.source=1.8');
          strList.Add('java.target=1.8');
          strList.Add('key.store='+LowerCase(FSmallProjName)+'-release.keystore');
          strList.Add('key.alias='+apk_aliaskey);
          strList.Add('key.store.password=123456');
          strList.Add('key.alias.password=123456');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'ant.properties');

          strList.Clear;  //if need, hiden info in "build.grade" source

          //strList.Add('RELEASE_STORE_FILE='+LowerCase(FSmallProjName)+'-release.keystore');
          //strList.Add('RELEASE_KEY_ALIAS='+apk_aliaskey);
          //strList.Add('RELEASE_STORE_PASSWORD=123456');
          //strList.Add('RELEASE_KEY_PASSWORD=123456');


          //gradle.properties
          (*
            the ideal would be to use only AndroidX dependencies but you can do
            "android.enableJetifier=true"  in the gradle.properties file
            while you migrate your entire project and its dependencies to AndroidX
            (see https://developer.android.com/jetpack/androidx/migrate).
          *)

          //TODO
          {
          strList.Add('android.defaults.buildfeatures.buildconfig=true');
          strList.Add('android.nonFinalResIds=false');
          strList.Add('android.nonTransitiveRClass=false');
          }
          strList.Add('android.enableJetifier=true'); //temporary...
          strList.Add('android.useAndroidX=true');

          if DirectoryExists(FPathToJavaJDK) then
          begin
            tempStr:=FPathToJavaJDK;
            {$ifdef MSWindows}
            tempStr:=StringReplace(tempStr,'\','\\',[rfReplaceAll]);
            tempStr:=StringReplace(tempStr,':','\:',[]);
            {$endif}
            strList.Add('org.gradle.java.home='+tempStr);
          end;
          strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle.properties');  //if need configure proxy here, too

          //keytool input [dammy] data!
          strList.Clear;
          strList.Add('123456');             //Enter keystore password:
          strList.Add('123456');             //Re-enter new password:
          strList.Add('MyFirstName MyLastName'); //What is your first and last name?
          strList.Add('MyDevelopmentUnitName');        //What is the name of your organizational unit?
          strList.Add('MyCompanyName');   //What is the name of your organization?
          strList.Add('MyCity');             //What is the name of your City or Locality?
          strList.Add('MT');                 //What is the name of your State or Province?
          strList.Add('BR');                 //What is the two-letter country code for this unit?
          strList.Add('y');  //Is <CN=FirstName LastName, OU=Development, O=MyExampleCompany, L=MyCity, ST=AK, C=WZ> correct?[no]:  y
          strList.Add('123456'); //Enter key password for the Apk <aliasKey> <RETURN if same as keystore password>:
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'keytool_input.txt');

          strList.Clear;

          strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
          strList.Add('set PATH=%JAVA_HOME%'+PathDelim+'bin;%PATH%');
          strList.Add('set JAVA_TOOL_OPTIONS=-Duser.language=en');
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('keytool -genkey -v -keystore '+Lowercase(FSmallProjName)+'-release.keystore -alias '+apk_aliaskey+' -keyalg RSA -keysize 2048 -validity 10000 < '+
                      FAndroidProjectName+DirectorySeparator+'keytool_input.txt');
          strList.Add(':Error');
          strList.Add('echo off');
          strList.Add('cls');
          strList.Add('echo.');
          strList.Add('echo Signature file created previously, remember that if you delete this file and it was uploaded to Google Play, you will not be able to upload another app without this signature.');
          strList.Add('echo.');
          strList.Add('pause');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'release-keystore.bat');


          strList.Clear;
          strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
          strList.Add('path %JAVA_HOME%'+PathDelim+'bin;%path%');
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('jarsigner -verify -verbose -certs '+FAndroidProjectName+DirectorySeparator+'bin'+DirectorySeparator+FSmallProjName+'-release.apk');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'ant-jarsigner-verify.bat');

          strList.Clear;
          strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
          strList.Add('path %JAVA_HOME%'+PathDelim+'bin;%path%');
          strList.Add('cd '+FAndroidProjectName);
          strList.Add('jarsigner -verify -verbose -certs '+FAndroidProjectName+DirectorySeparator+'build'+DirectorySeparator+'outputs'+DirectorySeparator+'apk'+DirectorySeparator+'release'+DirectorySeparator+FSmallProjName+'-release.apk');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'gradle-jarsigner-verify.bat');

          DoHowToGetSignedReleaseApk;

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
          begin
             strList.Add('export PATH='+linuxPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH
             strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
             strList.Add('cd '+linuxAndroidProjectName);
             strList.Add('ant -Dtouchtest.enabled=true debug');
             SaveShellScript(strList, FAndroidProjectName+PathDelim+'ant-build-debug.sh');
          end;

          //MacOs
          strList.Clear;
          if FPathToAntBin <> '' then //PATH=$PATH:/data/myscripts
          begin
            strList.Add('export PATH='+linuxPathToAntBin+':$PATH');        //export PATH=/usr/bin/ant:PATH
            strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
            strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
            strList.Add('cd '+linuxAndroidProjectName);
            strList.Add('ant -Dtouchtest.enabled=true debug');
            SaveShellScript(strList, FAndroidProjectName+PathDelim+'ant-build-debug-macos.sh');
          end;

          strList.Clear;
          if FPathToAntBin <> '' then
          begin
             strList.Add('export PATH='+linuxPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH
             strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
             strList.Add('cd '+linuxAndroidProjectName);
             strList.Add('ant clean release');
             SaveShellScript(strList, FAndroidProjectName+PathDelim+'ant-build-release.sh');
          end;

          //MacOs
          strList.Clear;
          if FPathToAntBin <> '' then //PATH=$PATH:/data/myscripts
          begin
            strList.Add('export PATH='+linuxPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH
            strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
            strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
            strList.Add('cd '+linuxAndroidProjectName);
            strList.Add('ant clean release');
            SaveShellScript(strList, FAndroidProjectName+PathDelim+'ant-build-release-macos.sh');
          end;

          linuxPathToAdbBin:= linuxPathToAndroidSdk+'platform-tools';
          //linux install - thanks to Stephano!
          strList.Clear;
          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));

          tempStr:= FAndroidProjectName;
          {$ifdef windows}
          tempStr:= StringReplace(FAndroidProjectName,PathDelim,linuxDirSeparator, [rfReplaceAll]);
          tempStr:= Copy(tempStr, 3, MaxInt); //drop C:
          {$endif}

          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb install -r ' + tempStr +
                                  linuxDirSeparator+ 'bin' + linuxDirSeparator+FSmallProjName+'-debug.apk');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'ant-adb-install-debug.sh');

          strList.Clear;
          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
          tempStr:= FAndroidProjectName;
          {$ifdef windows}
          tempStr:= StringReplace(FAndroidProjectName,PathDelim,linuxDirSeparator, [rfReplaceAll]);
          tempStr:= Copy(tempStr, 3, MaxInt); //drop C:
          {$endif}
          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb install -r ' + tempStr +
                                  linuxDirSeparator+ 'build'+linuxDirSeparator+'outputs'+linuxDirSeparator+'apk'+linuxDirSeparator+'debug' + linuxDirSeparator+FSmallProjName+'-'+instructionChip+'-debug.apk');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradle-adb-install-debug.sh');


          //linux uninstall  - thanks to Stephano!
          strList.Clear;
          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+FPackagePrefaceName+'.'+LowerCase(FSmallProjName));
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'adb-uninstall.sh');

          //linux logcat  - thanks to Stephano!
          strList.Clear;
          strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat &');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'logcat.sh');

          strList.Clear;
          strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
          strList.Add('cd '+linuxAndroidProjectName);

          ////https://forum.lazarus.freepascal.org/index.php/topic,57735.0.html
          strList.Add('LC_ALL=C keytool -genkey -v -keystore '+Lowercase(FSmallProjName)+'-release.keystore -alias '+apk_aliaskey+' -keyalg RSA -keysize 2048 -validity 10000 < '+
                       linuxAndroidProjectName+'/keytool_input.txt');

          SaveShellScript(strList, FAndroidProjectName+PathDelim+'release-keystore.sh');

          //MacOs
          strList.Clear;
          strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');
          strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
          strList.Add('cd '+linuxAndroidProjectName);
          strList.Add('keytool -genkey -v -keystore '+Lowercase(FSmallProjName)+'-release.keystore -alias '+apk_aliaskey+' -keyalg RSA -keysize 2048 -validity 10000 < '+
                       linuxAndroidProjectName+'/keytool_input.txt');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'release-keystore-macos.sh');

          strList.Clear;
          strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
          strList.Add('cd '+linuxAndroidProjectName);
          strList.Add('jarsigner -verify -verbose -certs '+linuxAndroidProjectName+linuxDirSeparator+'bin'+linuxDirSeparator+FSmallProjName+'-release.apk');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'ant-jarsigner-verify.sh');

          strList.Clear;
          strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
          strList.Add('cd '+linuxAndroidProjectName);
          strList.Add('jarsigner -verify -verbose -certs '+linuxAndroidProjectName+linuxDirSeparator+'build'+linuxDirSeparator+'outputs'+linuxDirSeparator+'apk'+linuxDirSeparator+'release'+linuxDirSeparator+FSmallProjName+'-release.apk');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradle-jarsigner-verify.sh');

          //MacOs
          strList.Clear;
          strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
          strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
          strList.Add('cd '+linuxAndroidProjectName);
          strList.Add('jarsigner -verify -verbose -certs '+linuxAndroidProjectName+linuxDirSeparator+'bin'+linuxDirSeparator+FSmallProjName+'-release.apk');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'ant-jarsigner-verify-macos.sh');

          strList.Clear;
          strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
          strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
          strList.Add('cd '+linuxAndroidProjectName);
          strList.Add('jarsigner -verify -verbose -certs '+linuxAndroidProjectName+linuxDirSeparator+'build'+linuxDirSeparator+'outputs'+linuxDirSeparator+'apk'+linuxDirSeparator+'release'+linuxDirSeparator+FSmallProjName+'-release.apk');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradle-jarsigner-verify-macos.sh');

          strList.Clear;
          strList.Add('sdk.dir=' + FPathToAndroidSDK);
          strList.Add('ndk.dir=' + FPathToAndroidNDK);

          {$IFDEF WINDOWS}
          tempStr:= strList.Text;
          tempStr:= StringReplace(tempStr, '\', '\\', [rfReplaceAll]);
          tempStr:= StringReplace(tempStr, ':', '\:', [rfReplaceAll]);
          strList.Text:=tempStr;
          {$ENDIF}
          strList.SaveToFile(FAndroidProjectName+PathDelim+'local.properties');

          //Add GRADLE support ... [... initial code ...]
          //Building "build.gradle" file    -- for gradle we need "sdk/build-tools" >= 21.1.1

          //FGradleVersion:='7.6.3'  --> plugin '7.1.3';
          androidPluginVersion:= GetAndroidPluginVersion(FGradleVersion, FJavaMainVersion); //'7.1.3';

          isAppCompatTheme:= False;
          if Pos('AppCompat', FAndroidTheme) > 0  then isAppCompatTheme:= True;

          isGradleBuildSystem:= False;
          if Pos('Gradle',  FBuildSystem) > 0 then isGradleBuildSystem:= True;
          DoBuildGradle(strPack, androidPluginVersion, FGradleVersion,
                        FisKotlinSupported, FMinApi, IntToStr(FMaxSdkPlatform),
                        instructionChip, isAppCompatTheme, isGradleBuildSystem);

          //Drafts Making gradlew (= gradle warapper)
          strList.Clear;
          strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
          if FPathToGradle = '' then
            strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
          else
            strList.Add('set GRADLE_HOME='+FPathToGradle);

          strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
          strList.Add('gradle wrapper');
          strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle-making-wrapper.bat');

          strList.Clear;
          strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
          if FPathToGradle = '' then
            strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
          else
            strList.Add('export GRADLE_HOME='+ linuxPathToGradle);

          strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
          strList.Add('. ~/.bashrc');
          //strList.Add('./gradle wrapper');
          strList.Add('gradle wrapper');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradle-making-wrapper.sh');

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
          strList.SaveToFile(FAndroidProjectName+PathDelim+'gradlew-build.bat');

          strList.Clear;
          strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
          if FPathToGradle = '' then
             strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
          else
             strList.Add('export GRADLE_HOME='+linuxPathToGradle);
          strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
          strList.Add('. ~/.bashrc');
          //strList.Add('./gradlew build');
          strList.Add('gradlew build');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradlew-build.sh');

          //run
          strList.Clear;
          strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
          if FPathToGradle = '' then
            strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
          else
            strList.Add('set GRADLE_HOME='+ FPathToGradle);
          strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
          strList.Add('gradlew run');
          strList.SaveToFile(FAndroidProjectName+PathDelim+'gradlew-run.bat');

          strList.Clear;
          strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
          if FPathToGradle = '' then
             strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
          else
             strList.Add('export GRADLE_HOME='+linuxPathToGradle);
          strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
          strList.Add('. ~/.bashrc');
          //strList.Add('./gradlew run');
          strList.Add('gradlew run');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradlew-run.sh');

          //Drafts Method I

          strList.Clear;
          strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
          if FPathToGradle = '' then
            strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
          else
            strList.Add('set GRADLE_HOME='+ FPathToGradle);
          strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
          strList.Add('gradle clean build --info');
          strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle-local-build.bat');

          strList.Clear;
          strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
          if FPathToGradle = '' then
            strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
          else
            strList.Add('set GRADLE_HOME='+ FPathToGradle);
          strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
          strList.Add('gradle clean bundle --info');
          strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle-local-build-bundle.bat');

          //thanks to TR3E!
          strList.Clear;
          sdkBuildTools:= GetBuildTool(FMaxSdkPlatform);
          strList.Clear;
          strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools;'+FPathToAndroidSDK+'build-tools\'+sdkBuildTools);
          strList.Add('set GRADLE_HOME='+FPathToGradle);
          strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');

          //fixed! thanks do @pasquale!
          apkName:= FSmallProjName+ '-' + instructionChip;

          strList.Add('zipalign -v -p 4 '+FAndroidProjectName+'\build\outputs\apk\release\'+apkName+'-release-unsigned.apk '+FAndroidProjectName+'\build\outputs\apk\release\'+apkName+'-release-unsigned-aligned.apk');
          strList.Add('apksigner sign --ks '+FAndroidProjectName+'\'+Lowercase(FSmallProjName)+'-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out '+FAndroidProjectName+'\build\outputs\apk\release\'+FSmallProjName+'-release.apk '+FAndroidProjectName+'\build\outputs\apk\release\'+apkName+'-release-unsigned-aligned.apk');
          strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle-local-apksigner.bat');

          strList.Clear;  //multi-arch :: armeabi-v7a + arm64-v8a + ...
          strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools;'+FPathToAndroidSDK+'build-tools\'+sdkBuildTools);
          strList.Add('set GRADLE_HOME='+FPathToGradle);
          strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
          strList.Add('zipalign -v -p 4 '+FAndroidProjectName+'\build\outputs\apk\release\'+FSmallProjName+'-universal-release-unsigned.apk '+FAndroidProjectName+'\build\outputs\apk\release\'+FSmallProjName+'-universal-release-unsigned-aligned.apk');
          strList.Add('apksigner sign --ks '+FAndroidProjectName+'\'+Lowercase(FSmallProjName)+'-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out '+FAndroidProjectName+'\build\outputs\apk\release\'+FSmallProjName+'-release.apk '+FAndroidProjectName+'\build\outputs\apk\release\'+FSmallProjName+'-universal-release-unsigned-aligned.apk');
          strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle-local-universal-apksigner.bat');

          strList.Clear;
          strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
          if FPathToGradle = '' then
            strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
          else
            strList.Add('set GRADLE_HOME='+ FPathToGradle);
          strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
          strList.Add('gradle run');
          strList.SaveToFile(FAndroidProjectName+PathDelim+'gradle-local-run.bat');

          strList.Clear;
          strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
          if FPathToGradle = '' then
            strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
          else
            strList.Add('export GRADLE_HOME='+ linuxPathToGradle);
          strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
          strList.Add('. ~/.bashrc');
          strList.Add('gradle clean build --info');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradle-local-build.sh');

          strList.Clear;
          strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
          if FPathToGradle = '' then
            strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
          else
            strList.Add('export GRADLE_HOME='+ linuxPathToGradle);
          strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
          strList.Add('. ~/.bashrc');
          strList.Add('gradle clean bundle --info');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradle-local-build-bundle.sh');

          strList.Clear;
          strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
          strList.Add('export PATH='+linuxPathToAndroidSDK+'build-tools/'+sdkBuildTools+':$PATH');
          strList.Add('export GRADLE_HOME='+ linuxPathToGradle);
          strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
          strList.Add('zipalign -v -p 4 '+linuxAndroidProjectName+'/build/outputs/apk/release/'+apkName+'-release-unsigned.apk '+linuxAndroidProjectName+'/build/outputs/apk/release/'+apkName+'-release-unsigned-aligned.apk');
          strList.Add('apksigner sign --ks '+linuxAndroidProjectName+'/'+Lowercase(FSmallProjName)+'-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out '+linuxAndroidProjectName+'/build/outputs/apk/release/'+FSmallProjName+'-release.apk '+linuxAndroidProjectName+'/build/outputs/apk/release/'+apkName+'-release-unsigned-aligned.apk');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradle-local-apksigner.sh');

          strList.Clear;  //multi-arch :: armeabi-v7a + arm64-v8a + ...
          strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');
          strList.Add('export PATH='+linuxPathToAndroidSDK+'build-tools/'+sdkBuildTools+':$PATH');
          strList.Add('export GRADLE_HOME='+ linuxPathToGradle);
          strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
          strList.Add('zipalign -v -p 4 '+linuxAndroidProjectName+'/build/outputs/apk/release/'+FSmallProjName+'-universal-release-unsigned.apk '+linuxAndroidProjectName+'/build/outputs/apk/release/'+FSmallProjName+'-universal-release-unsigned-aligned.apk');
          strList.Add('apksigner sign --ks '+linuxAndroidProjectName+'/'+Lowercase(FSmallProjName)+'-release.keystore --ks-pass pass:123456 --key-pass pass:123456 --out '+linuxAndroidProjectName+'/build/outputs/apk/release/'+FSmallProjName+'-release.apk '+linuxAndroidProjectName+'/build/outputs/apk/release/'+FSmallProjName+'-universal-release-unsigned-aligned.apk');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradle-local-universal-apksigner.sh');

          strList.Clear;
          strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');

          if FPathToGradle = '' then
            strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
          else
            strList.Add('export GRADLE_HOME='+ linuxPathToGradle);

          strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
          strList.Add('. ~/.bashrc');
          //strList.Add('.\gradle run');
          strList.Add('gradle run');
          SaveShellScript(strList, FAndroidProjectName+PathDelim+'gradle-local-run.sh');
        end; //FModuleType < 2       //0: GUI; 1: NoGUI; 2: NoGUI EXE Console
        Result := True;
      except
        on e: Exception do
          MessageDlg('Error',e.Message,mtError,[mbOK],0);
      end;
    end; //frm.ShowModal = mrOK
  finally
    strList.Free;
    frm.Free;
  end;
end;

function TAndroidProjectDescriptor.DoInitDescriptor: TModalResult;
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
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'arm64-v8a');
        CreateDir(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86_64');
        CreateDir(FAndroidProjectName+DirectorySeparator+'obj');
        CreateDir(FAndroidProjectName+DirectorySeparator+'lamwdesigner');

        if FModuleType < 2 then
           CreateDir(FAndroidProjectName+DirectorySeparator+'obj'+DirectorySeparator+'controls');

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
  projName, projDir, auxStr, auxInstr: string;
  sourceList: TStringList;
  auxList: TStringList;

  libraries_x86: string;
  libraries_x86_64: string;
  libraries_arm: string;
  libraries_mips: string;
  libraries_aarch64: string;

  customOptions_default: string;
  customOptions_x86: string;
  customOptions_x86_64: string;
  customOptions_mips: string;
  customOptions_armV6: string;
  customOptions_armV7a: string;
  customOptions_armV7a_VFPv3: string;
  customOptions_armV8: string;

  androidPlatformApi: string;
  PathToNdkPlatformsArm: string;
  PathToNdkPlatformsX86: string;
  PathToNdkPlatformsX86_64: string;
  PathToNdkPlatformsMips: string;
  PathToNdkPlatformsAarch64: string;

  pathToNdkToolchainsX86: string;
  pathToNdkToolchainsX86_64: string;
  pathToNdkToolchainsArm: string;
  pathToNdkToolchainsMips: string;
  pathToNdkToolchainsAarch64: string;

  pathToNdkToolchainsBinX86: string;
  pathToNdkToolchainsBinX86_64: string;
  pathToNdkToolchainsBinArm: string;
  pathToNdkToolchainsBinMips: string;
  pathToNdkToolchainsBinAarch64: string;

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

  if FModuleType = 0 then    {0: GUI; 1: NoGUI; 2: NoGUI EXE Console}
  begin
    AProject.CustomData.Values['LAMW'] := 'GUI';
    AProject.CustomData.Values['BuildSystem'] := FBuildSystem;
    AProject.CustomData.Values['Theme']:= FAndroidTheme;
    AProject.CustomData['StartModule'] := 'AndroidModule1';

    if FKeepMyBuildGradleWhenReopen then
       AProject.CustomData.Values['KeepMyBuildGradleWhenReopen']:= 'YES'
    else
       AProject.CustomData.Values['KeepMyBuildGradleWhenReopen']:= 'NO';

    if FIsKotlinSupported then
       AProject.CustomData.Values['TryKotlin']:= 'TRUE'
    else
       AProject.CustomData.Values['TryKotlin']:= 'FALSE';

    if FSupport then
      AProject.CustomData.Values['Support'] := 'TRUE'
    else
      AProject.CustomData.Values['Support'] := 'FALSE';
  end
  else if  FModuleType = 1 then
    AProject.CustomData.Values['LAMW'] := 'NoGUI'
  else if FModuleType = 2 then
    AProject.CustomData.Values['LAMW'] := 'NoGUIConsoleApp'    // FModuleType =2
  else
    AProject.CustomData.Values['LAMW'] := 'NoGUIGenericLibrary';    // FModuleType = 3

  if FModuleType < 2 then    {-1:gdx 0: GUI; 1: NoGUI; 2: NoGUI EXE Console}
    AProject.CustomData.Values['Package']:= FPackagePrefaceName + '.' + LowerCase(FSmallProjName);

  AProject.CustomData.Values['NdkPath']:= FPathToAndroidNDK;
  AProject.CustomData.Values['SdkPath']:= FPathToAndroidSDK;

  AProject.CustomData.Values['NdkApi']:= 'android-'+FNdkApi; //legacy

  AProject.ProjectInfoFile := projDir + ChangeFileExt(projName, '.lpi');

  MainFile := AProject.CreateProjectFile(projDir + projName);

  MainFile.IsPartOfProject := True;
  AProject.AddFile(MainFile, False);
  AProject.MainFileID := 0;

  if FModuleType <= 0 then  //GUI
    AProject.AddPackageDependency('tfpandroidbridge_pack'); //GUI or gdx  controls

  sourceList:= TStringList.Create;              //FSmallProjName
  //sourceList.Add('{hint: save all files to location: ' + projDir + ' }');
  sourceList.Add('{hint: Pascal files location: ...'+DirectorySeparator+FSmallProjName+DirectorySeparator+'jni }');

  if FModuleType = 2 then  //console executavel
    sourceList.Add('program '+ LowerCase(FSmallProjName) +'; '+ ' //[by LAMW: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']')
  else if  FModuleType = 3 then
    sourceList.Add('library '+ LowerCase(FSmallProjName) +'; '+ ' //[by LAMW: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']')
  else
    sourceList.Add('library '+ LowerCase(FJavaClassName) +'; '+ ' //[by LAMW: Lazarus Android Module Wizard: '+DateTimeToStr(Now)+']');

  sourceList.Add(' ');
  sourceList.Add('{$mode delphi}');
  sourceList.Add(' ');

  sourceList.Add('uses');

  if FModuleType <= 1 then  //-1:gdx    0:GUI or   1:noGUI controls
  begin
    //https://forum.lazarus.freepascal.org/index.php/topic,45715.msg386317
    sourceList.Add('  {$IFDEF UNIX}{$IFDEF UseCThreads}');
    sourceList.Add('  cthreads,');
    sourceList.Add('  {$ENDIF}{$ENDIF}');
  end;

  if FModuleType <= 0 then  //-1:gdx    0:GUI or   1:noGUI controls
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
  else //generic .so library // FModuleType = 3
  begin
    sourceList.Add('  Unit1;');  //ok
  end;

  if FModuleType <= 1 then //0:GUI    1:NoGUI    -1:gdx
  begin
    sourceList.Add('{%region /fold ''LAMW generated code''}');
    sourceList.Add('');
    sourceList.Add(FPascalJNIInterfaceCode);
    sourceList.Add('{%endregion}');
  end;

  sourceList.Add(' ');

  if FModuleType < 3 then sourceList.Add('begin');

  if FModuleType = 0 then  //GUI Android Bridges controls...
  begin
    sourceList.Add('  gApp:= jApp.Create(nil);');
    sourceList.Add('  gApp.Title:= ''LAMW JNI Android Bridges Library'';');
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
  begin  //generic library     // FModuleType = 3
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

  if (Length(FPrebuildOSYS)=0) then
  begin
    {$ifdef Windows}
    FPrebuildOSYS:='windows-x86_64';
    {$endif}
    {$ifdef Linux}
    FPrebuildOSYS:='linux';
    {$endif}
    {$ifdef Darwin}
    FPrebuildOSYS:='darwin';
    {$endif}
  end;

  osys:= FPrebuildOSys;

  {Set compiler options for Android requirements}
  if FNDKIndex < 6 then   //NDK < 22
  begin
    androidPlatformApi:= 'android-'+FNdkApi;
    PathToNdkPlatformsArm:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                                  androidPlatformApi +DirectorySeparator+'arch-arm'+DirectorySeparator+
                                                  'usr'+DirectorySeparator+'lib';

    PathToNdkPlatformsAarch64:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                                  androidPlatformApi +DirectorySeparator+'arch-arm64'+DirectorySeparator+
                                                  'usr'+DirectorySeparator+'lib';

    PathToNdkPlatformsX86:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                               androidPlatformApi+DirectorySeparator+'arch-x86'+DirectorySeparator+
                                               'usr'+DirectorySeparator+'lib';

    PathToNdkPlatformsX86_64:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                               androidPlatformApi+DirectorySeparator+'arch-x86_64'+DirectorySeparator+
                                               'usr'+DirectorySeparator+'lib';

    PathToNdkPlatformsMips:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                               androidPlatformApi+DirectorySeparator+'arch-mips'+DirectorySeparator+
                                               'usr'+DirectorySeparator+'lib';
  end
  else //NDK >= 22
  begin
   //C:\android\android-ndk-r22b\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\arm-linux-androideabi\22
   PathToNdkPlatformsArm:=ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','arm-linux-androideabi', FNdkApi]);

   //C:\android\android-ndk-r22b\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\aarch64-linux-android\22
   PathToNdkPlatformsAarch64:= ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','aarch64-linux-android', FNdkApi]);

   //C:\android\android-ndk-r22b\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\i686-linux-android\22
   PathToNdkPlatformsX86:= ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','i686-linux-android', FNdkApi]);

   //C:\android\android-ndk-r22b\toolchains\llvm\prebuilt\windows-x86_64\sysroot\usr\lib\x86_64-linux-android\22
    PathToNdkPlatformsX86_64:= ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','x86_64-linux-android', FNdkApi]);

    PathToNdkPlatformsMips:= ''; //note supported since NDK 18 ...
  end;

  {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
  if {FNDK = '7'} FNDKIndex = 0 then
  begin
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.4.3';

      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                  'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                  'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                  'bin';

      pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+
                                                 'gcc'+DirectorySeparator+'i686-android-linux'+DirectorySeparator+'4.4.3';

      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

  end else if {(FNDK = '9') or (FNDK = '10') or (FNDK = '10c')} (FNDKIndex > 0) and (FNDKIndex < 3) then          //arm-linux-androideabi-4.9
  begin
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.6';
      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

      pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'i686-android-linux'+DirectorySeparator+'4.6';

      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      {index 3/r10e , index  4/11x, index 5/12...21, index 6/22....}
  end else if {FNDK = '10e'} {FNDK = '11c'} (FNDKIndex >=3) and (FNDKIndex < 5) then          //arm-linux-androideabi-4.9
  begin
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.9';


      pathToNdkToolchainsAarch64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'aarch64-linux-android-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'aarch64-linux-android'+DirectorySeparator+'4.9';

      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

      pathToNdkToolchainsBinAarch64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'aarch64-linux-android-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

      pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'i686-android-linux'+DirectorySeparator+'4.9';

      pathToNdkToolchainsX86_64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86_64-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'x86_64-android-linux'+DirectorySeparator+'4.9';

      pathToNdkToolchainsMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                  'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                  osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                  'mipsel-linux-android'+DirectorySeparator+'4.9';

      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';


      pathToNdkToolchainsBinX86_64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86_64-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      pathToNdkToolchainsBinMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

  end else if {FNDK = '>11'} FNDKIndex >= 5 then          //arm-linux-androideabi-4.9
  begin
      pathToNdkToolchainsArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.9.x';

      pathToNdkToolchainsAarch64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'aarch64-linux-android-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'aarch64-linux-android'+DirectorySeparator+'4.9.x';

      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      pathToNdkToolchainsBinX86_64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'x86_64-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      pathToNdkToolchainsBinMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

      pathToNdkToolchainsBinAarch64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                 'aarch64-linux-android-4.9'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

      pathToNdkToolchainsX86:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                   'x86-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                   osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                   'i686-android-linux'+DirectorySeparator+'4.9.x';

      pathToNdkToolchainsX86_64:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                   'x86_64-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                   osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                   'x86_64-android-linux'+DirectorySeparator+'4.9.x';

      pathToNdkToolchainsMips:= FPathToAndroidNDK+'toolchains'+DirectorySeparator+
                                                    'mipsel-linux-android-4.9'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                    osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+                                                   'mipsel-linux-android'+DirectorySeparator+'4.9.x';
  end;

  if PathToNdkPlatformsArm <> '' then
    libraries_arm:= PathToNdkPlatformsArm+';'+pathToNdkToolchainsArm
  else  libraries_arm:= pathToNdkToolchainsArm;

  if PathToNdkPlatformsAarch64 <>'' then
      libraries_aarch64:= PathToNdkPlatformsAarch64+';'+pathToNdkToolchainsAarch64
  else libraries_aarch64:= pathToNdkToolchainsAarch64;

  if PathToNdkPlatformsX86 <>'' then
     libraries_x86:= PathToNdkPlatformsX86+';'+pathToNdkToolchainsX86
  else libraries_x86:= pathToNdkToolchainsX86;

  if PathToNdkPlatformsX86_64 <>'' then
    libraries_x86_64:= PathToNdkPlatformsX86_64+';'+pathToNdkToolchainsX86_64
  else libraries_x86_64:= pathToNdkToolchainsX86_64;

  if PathToNdkPlatformsMips <>'' then
     libraries_mips:= PathToNdkPlatformsMips+';'+pathToNdkToolchainsMips
  else libraries_mips:= pathToNdkToolchainsMips;


  //https://developer.android.com/ndk/guides/abis
  auxStr:='armeabi'; //ARMv6
  auxInstr:= LowerCase(FInstructionSet);
  if auxInstr = 'armv7a' then auxStr:='armeabi-v7a';
  if auxInstr = 'x86'    then auxStr:='x86';
  if auxInstr = 'x86_64' then auxStr:='x86_64';
  if auxInstr = 'mipsel' then auxStr:='mips';
  if auxInstr = 'armv8'  then auxStr:='arm64-v8a';

  AProject.LazCompilerOptions.TargetCPU:= 'arm';    {-P}
  AProject.LazCompilerOptions.Libraries:= libraries_arm;  { -Fl}

  if Pos('mips', auxStr) > 0 then
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'mipsel';    {-P}
     AProject.LazCompilerOptions.Libraries:= libraries_mips;  { -Fl}
  end
  else if Pos('x86_64', auxStr) > 0 then
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'x86_64';    {-P}
     AProject.LazCompilerOptions.Libraries:= libraries_x86_64;  { -Fl}
  end
  else if Pos('x86', auxStr) > 0 then
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'i386';    {-P}
     AProject.LazCompilerOptions.Libraries:= libraries_x86;  { -Fl}
  end
  else if Pos('arm64', auxStr) > 0 then
  begin
    AProject.LazCompilerOptions.TargetCPU:= 'aarch64';    {-P}
    AProject.LazCompilerOptions.Libraries:= libraries_aarch64; { -Fl}
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

  AProject.LazCompilerOptions.OptimizationLevel:= 3;
  AProject.LazCompilerOptions.Win32GraphicApp:= False;

  {Link}
  AProject.LazCompilerOptions.StripSymbols:= True; {-Xs}
  AProject.LazCompilerOptions.LinkSmart:= True {-XX};
  AProject.LazCompilerOptions.GenerateDebugInfo:= False;
  AProject.LazCompilerOptions.SmallerCode:= True;
  AProject.LazCompilerOptions.SmartLinkUnit:= True;

  if FModuleType = 2 then
  begin
    if FPieChecked then  //here PIE support .. ok sorry... :(  ...bad code reuse!
    begin
      AProject.LazCompilerOptions.PassLinkerOptions:= True;
      AProject.LazCompilerOptions.LinkerOptions:='-pie'
    end;
  end;

  customOptions_default:='-Xd'; //x86   aarch64   mips
  if Pos('armeabi', auxStr) > 0 then
  begin
     customOptions_default:='-Xd'+' -Cf'+ FFPUSet;
     customOptions_default:= customOptions_default + ' -Cp'+ UpperCase(FInstructionSet);
  end;

  customOptions_armV6 := '-Xd'+' -Cf'+ FFPUSet+ ' -CpARMV6';
  customOptions_armV7a:= '-Xd'+' -CfSoft -CpARMV7A';
  customOptions_armV7a_VFPv3:= '-Xd'+' -CfVFPv3 -CpARMV7A';
  customOptions_x86   := '-Xd';
  customOptions_x86_64:= '-Xd';
  customOptions_mips  := '-Xd';
  customOptions_armv8 := '-Xd';

  customOptions_armV6 := customOptions_armV6  +' -XParm-linux-androideabi-';
  customOptions_armV7a:= customOptions_armV7a +' -XParm-linux-androideabi-';
  customOptions_armV7a_VFPv3:= customOptions_armV7a_VFPv3 + ' -XParm-linux-androideabi-';
  customOptions_x86   := customOptions_x86    +' -XPi686-linux-android-';
  customOptions_x86_64:= customOptions_x86_64 +' -XPx86_64-linux-android-';
  customOptions_mips  := customOptions_mips   +' -XPmipsel-linux-android-';
  customOptions_armv8:= customOptions_armv8   +' -XPaarch64-linux-android-';

  if Pos('armeabi', auxStr) > 0 then
    customOptions_default:= customOptions_default+' -XParm-linux-androideabi-'+' -FD'+pathToNdkToolchainsBinArm
  else if Pos('arm64', auxStr) > 0 then
      customOptions_default:= customOptions_default+' -XPaarch64-linux-android-'+' -FD'+pathToNdkToolchainsBinAarch64
  else if Pos('x86_64', auxStr) > 0 then
      customOptions_default:= customOptions_default+' -XPx86_64-linux-android-'+' -FD'+pathToNdkToolchainsBinX86_64
  else if Pos('x86', auxStr) > 0 then
    customOptions_default:= customOptions_default+' -XPi686-linux-android-'+' -FD'+pathToNdkToolchainsBinX86
  else if Pos('mips', auxStr) > 0 then
    customOptions_default:= customOptions_default+' -XPmipsel-linux-android-'+' -FD'+pathToNdkToolchainsBinMips;

  customOptions_armV6 := customOptions_armV6 +' -FD' + pathToNdkToolchainsBinArm;
  customOptions_armV7a:= customOptions_armV7a+' -FD' + pathToNdkToolchainsBinArm;
  customOptions_armv8:= customOptions_armv8  +' -FD' + pathToNdkToolchainsBinAarch64;
  customOptions_x86   := customOptions_x86   +' -FD' + pathToNdkToolchainsBinX86;
  customOptions_x86_64:= customOptions_x86_64+' -FD' + pathToNdkToolchainsBinX86_64;
  customOptions_mips  := customOptions_mips  +' -FD' + pathToNdkToolchainsBinMips;

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
  auxList.Add('<Libraries Value="'+libraries_x86_64+'"/>');
  auxList.Add('<TargetCPU Value="x86_64"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_x86_64+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType < 2 then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86_64.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86_64.txt');

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
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a_VFPv3+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV7A"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FModuleType < 2 then
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a_VFPv3.txt')
  else
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a_VFPv3.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_aarch64+'"/>');
  auxList.Add('<TargetCPU Value="aarch64"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armv8+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMv8"/>');  //commented until lazarus fix bug for missing ARMv8  //again thanks to Stephano!
  if FModuleType < 2 then
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_arm64.txt')
  else
     auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'build_arm64.txt');

  auxList.Clear;
  auxList.Add('How to get more ".so" chipset builds:');
  auxList.Add(' ');
  auxList.Add('   :: Note 1: Your Lazarus/Freepascal needs to be prepared [cross-compile] for the various chipset builds!');
  auxList.Add('   :: Note 2: Laz4Android support 32 Bits chipset: "armV6", "armV7a+Soft", "x86" and 64 Bits chipset "arm64-v8a", "x86_64" !');
  auxList.Add(' ');
  auxList.Add('1. From LazarusIDE menu:');
  auxList.Add(' ');
  auxList.Add('   > Project -> Project Options -> Project Options -> [LAMW] Android Project Options -> "Build" -> Chipset [select!] -> [OK]');
  auxList.Add(' ');
  auxList.Add('2. From LazarusIDE  menu:');
  auxList.Add(' ');
  auxList.Add('   > Run -> Clean up and Build...');
  auxList.Add(' ');
  auxList.Add('3. [Optional] From LazarusIDE menu:');
  auxList.Add(' ');
  auxList.Add('   > [LAMW] Build Android Apk and Run');
  auxList.Add(' ');

  if FModuleType < 2 then
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'readme.txt')
  else
    auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'build-modes'+DirectorySeparator+'readme.txt');

  if FModuleType < 2 then
  begin
    AProject.LazCompilerOptions.OtherUnitFiles := '$(ProjOutDir)';

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

  AProject.Modified:= True;

  auxList.Free;
  sourceList.Free;
  Result := mrOK;

end;

//C:\laz4android2.0.0\components\androidmodulewizard\android_wizard\smartdesigner\AppTemplates
function TAndroidProjectDescriptor.IsTemplateProject(tryTheme: string; out outAndroidTheme: string): boolean;
var
  p: integer;
begin
  if DirectoryExists(GetPathToSmartDesigner() + PathDelim + 'AppTemplates' +PathDelim + tryTheme) then
  begin
    p:= LastDelimiter('.', tryTheme);
    outAndroidTheme:= Copy(tryTheme, 1, p-1);  //extract real android theme ....
    Result:= True;
  end
  else
  begin
     Result:= False;
     outAndroidTheme:= tryTheme;
  end;
end;

function TAndroidProjectDescriptor.CreateStartFiles(AProject: TLazProject): TModalResult;
var
  d: TIDesigner;
  c: TComponent;
  s: TLazProjectFile;
  templateFiles: TStringList;
  i, count: integer;
  fileName, pathToTemplate: string;
  unitFile: TLazProjectFile;
begin

  if FAndroidTemplateTheme <> '' then //Template/Theme project
  begin

    pathToTemplate:= GetPathToSmartDesigner() + PathDelim + 'AppTemplates' +PathDelim + FAndroidTemplateTheme;

    //assets
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'assets', '*.*', False);
      count:=  templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'assets'+PathDelim+fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate + PathDelim + 'res' + PathDelim + 'drawable', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
           CopyFile(templateFiles.Strings[i], FPathToJNIFolder + PathDelim + 'res' + PathDelim + 'drawable' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable-hdpi
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-hdpi', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-hdpi' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable-mdpi
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-mdpi', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-mdpi' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable-xhdpi
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-xhdpi', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-xhdpi' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable-xxhdpi
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-xxhdpi', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-xxhdpi' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/drawable-ldpi
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-ldpi', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-ldpi' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;


    // res/drawable-v24   ***
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'drawable-v24', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         if Pos('ic_launcher',fileName) <= 0 then
            CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'drawable-v24' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/raw
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'raw', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'raw' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    // res/xml
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'res'+ PathDelim + 'xml', '*.*', False);
      count:= templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         CopyFile(templateFiles.Strings[i], FPathToJNIFolder+PathDelim+'res'+ PathDelim+'xml' + PathDelim + fileName);
      end;
    finally
      templateFiles.Free;
    end;

    //jni
    templateFiles:= TStringList.Create;
    try
      FindAllFiles(templateFiles, pathToTemplate+PathDelim+'jni', '*.pas;*.lfm', False);
      count:=  templateFiles.Count;
      for i:= 0 to count-1 do
      begin
         fileName:= ExtractFileName(templateFiles.Strings[i]);
         CopyFile(templateFiles.Strings[i], FPathToJNIFolder + PathDelim+'jni' + PathDelim + fileName);
         if Pos('.pas', fileName) > 0 then
         begin
           unitFile := LazarusIDE.ActiveProject.CreateProjectFile(FPathToJNIFolder+PathDelim+'jni' + PathDelim + fileName);
           unitFile.IsPartOfProject:= True;
           LazarusIDE.ActiveProject.AddFile(unitFile, True);
           LazarusIDE.ActiveProject.Modified:= True;
         end;

      end;
    finally
      templateFiles.Free;
    end;

     LazarusIDE.DoSaveProject([]); // TODO: change hardcoded "controls"

     Exit;
  end; //Template project

  case FModuleType of
   0: // GUI Controls
    AndroidFileDescriptor.ResourceClass:= TAndroidModule;  //GUI
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
   Result := 'LAMW [GUI] Android jForm';
end;


function TAndroidFileDescPascalUnitWithResource.GetLocalizedDescription: string;
begin
    Result := 'Create a new LAMW [GUI] Android jForm';
    ActivityModeDesign:= actRecyclable;  //secondary GUI jForm
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
     //sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder+DirectorySeparator+'jni }')
     sourceList.Add('{hint: Pascal files location: ...'+DirectorySeparator+SmallProjName+DirectorySeparator+'jni }')
   else
     //sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder +'}');
     sourceList.Add('{hint: Pascal files location: ...'+DirectorySeparator+SmallProjName+DirectorySeparator +'}');

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

   //https://forum.lazarus.freepascal.org/index.php/topic,45715.msg386317
   //TODO: need drop this IFDEF from here?
   sourceList.Add('  {$IFDEF UNIX}{$IFDEF UseCThreads}');
   sourceList.Add('  cthreads,');
   sourceList.Add('  {$ENDIF}{$ENDIF}');

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

  if ModuleType = 0 then // GUI controls module
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
       strList.Add('  TAndroidModuleXX = class(jForm)'); //dummy
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

function IsAllCharNumber(pcString: PChar): Boolean;
begin
  Result := False;
  if StrLen(pcString)=0 then exit;
  while pcString^ <> #0 do // 0 indicates the end of a PChar string
  begin
    if not (pcString^ in ['0'..'9']) then Exit;
    Inc(pcString);
  end;
  Result := True;
end;

end.
