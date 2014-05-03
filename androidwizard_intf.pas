unit AndroidWizard_intf;

{$Mode Delphi}

interface

uses
 Classes, SysUtils, FileUtil, Controls, Forms, Dialogs,
 LazIDEIntf, ProjectIntf, FormEditingIntf, uFormAndroidProject, uformworkspace, Laz_And_Controls;

type

  TAndroidModule = class(jForm)  //GUI Module
  end;

  TNoGUIAndroidModule = class(TDataModule)
  end;

  TAndroidProjectDescriptor = class(TProjectDescriptor)
   private
     FPascalJNIIterfaceCode: string;
     FJavaClassName: string;
     FPathToClassName: string;
     FPathToJavaClass: string;
     FPathToJNIFolder: string;
     FPathToNdkPlataforms: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
     FPathToNdkToolchains: string;
     {C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3}
     FInstructionSet: string;    {ArmV6}
     FFPUSet: string;            {Soft}
     FPathToJavaTemplates: string;
     FAndroidProjectName: string;
     FModuleType: integer;     {0: GUI; 1: NoGUI}
     FSyntaxMode: TSyntaxMode;   {}

     FPathToJavaJDK: string;
     FPathToAndroidSDK: string;
     FPathToAndroidNDK: string;
     FNDK: string;

     FPathToAntBin: string;
     FProjectModel: string; {"Eclipse Project"/"Ant Project"}
     FAntPackageName: string;
     FMinApi: string;
     FTargetApi: string;
     FTouchtestEnabled: string;
     FAntBuildMode: string;
     FMainActivity: string;
     FPathToJavaSrc: string;
     FAndroidPlatform: string;

     function SettingsFilename: string;
     function TryNewJNIAndroidInterfaceCode: boolean;
     function GetPathToJNIFolder(fullPath: string): string;
     function GetWorkSpaceFromForm: boolean;
     function GetAppName(className: string): string;
     function GetIdFromApi(api: integer): string;
     function GetFolderFromApi(api: integer): string;
   public
     constructor Create; override;
     function GetLocalizedName: string; override;
     function GetLocalizedDescription: string; override;
     function DoInitDescriptor: TModalResult; override;
     function InitProject(AProject: TLazProject): TModalResult; override;
     function CreateStartFiles(AProject: TLazProject): TModalResult; override;
  end;

  TAndroidFileDescPascalUnitWithResource = class(TFileDescPascalUnitWithResource)
  private
    //
  public
    SyntaxMode: TSyntaxMode; {mdDelphi, mdObjFpc}
    PathToJNIFolder: string;
    ModuleType: integer;   //0: GUI; 1: No GUI
    constructor Create; override;

    function CreateSource(const Filename     : string;
                          const SourceName   : string;
                          const ResourceName : string): string; override;

    function GetInterfaceUsesSection: string; override;

    function GetInterfaceSource(const Filename     : string;
                                const SourceName   : string;
                                const ResourceName : string): string; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function GetImplementationSource(const Filename     : string;
                                     const SourceName   : string;
                                     const ResourceName : string): string; override;
  end;

var
  AndroidProjectDescriptor: TAndroidProjectDescriptor;
  AndroidFileDescriptor: TAndroidFileDescPascalUnitWithResource;

procedure Register;

function ReplaceChar(query: string; oldchar, newchar: char):string;
function SplitStr(var theString: string; delimiter: string): string;

implementation

procedure Register;
begin
  AndroidFileDescriptor := TAndroidFileDescPascalUnitWithResource.Create;
  RegisterProjectFileDescriptor(AndroidFileDescriptor);

  AndroidProjectDescriptor:= TAndroidProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidProjectDescriptor);

  FormEditingHook.RegisterDesignerBaseClass(TAndroidModule);
  FormEditingHook.RegisterDesignerBaseClass(TNoGUIAndroidModule);
end;

{TAndroidProjectDescriptor}

function TAndroidProjectDescriptor.SettingsFilename: string;
begin
  Result := AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini'
end;

function TAndroidProjectDescriptor.GetPathToJNIFolder(fullPath: string): string;
var
  //pathList: TStringList;
  i: integer;
begin
 { pathList:= TStringList.Create;
  pathList.Delimiter:=DirectorySeparator;
  pathList.DelimitedText:= TrimChar(fullPath,DirectorySeparator);

  for i:=0 to pathList.Count-1 do
  begin
     if Pos('src', pathList.Strings[i]) > 0 then k:= i;
  end;
  }


  //fix by Leledumbo - for linux compatility
  i := Pos('src',fullPath);
  if i > 2 then
  begin
    Result := Copy(fullPath,1,i - 2); // we don't need the trailing slash
  end else
    raise Exception.Create('src folder not found');


  {
  Result:= '';
  for j:= 0 to k-1 do
  begin
      Result:= Result + pathList.Strings[j]+DirectorySeparator;
  end;

  Result:= TrimChar(Result, DirectorySeparator);
  pathList.Free;}
end;

function TAndroidProjectDescriptor.TryNewJNIAndroidInterfaceCode: boolean;
var
  frm: TFormAndroidProject;
begin
  Result := False;
  frm:= TFormAndroidProject.Create(nil);
  frm.ShellTreeView1.Root:= FPathToJNIFolder;  //workspace...
  frm.PathToJavaTemplates:= FPathToJavaTemplates;
  frm.AndroidProjectName:= FAndroidProjectName;
  frm.ModuleType:= FModuleType;
  frm.MainActivity:= FMainActivity;
  frm.MinApi:= FMinApi;
  frm.TargetApi:= FTargetApi;
  if frm.ShowModal = mrOK then
  begin
    Result := True;

    FSyntaxMode:= frm.SyntaxMode;
    FPathToJavaClass:= frm.PathToJavaClass;

    FPathToJNIFolder:=GetPathToJNIFolder(FPathToJavaClass);

    AndroidFileDescriptor.PathToJNIFolder:= FPathToJNIFolder;
    AndroidFileDescriptor.ModuleType:= FModuleType;
    AndroidFileDescriptor.SyntaxMode:= FSyntaxMode;

    FJavaClassName:= frm.JavaClassName;
    FPathToClassName:= frm.PathToClassName;
    FPascalJNIIterfaceCode:= frm.PascalJNIInterfaceCode;

    {$I-}
    ChDir(FAndroidProjectName+DirectorySeparator+ 'jni');
    if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'jni');

    ChDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
    if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');

    ChDir(FAndroidProjectName+DirectorySeparator+ 'libs');
    if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'libs');

    ChDir(FAndroidProjectName+DirectorySeparator+ 'obj');
    if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'obj');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'obj'+DirectorySeparator+FJavaClassName);
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'obj'+DirectorySeparator+LowerCase(FJavaClassName));

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+'x86');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+'x86');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+'armeabi');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+'armeabi-v7a');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi-v7a');

  end;

  frm.Free;
end;

constructor TAndroidProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create new JNI Android Module (.so)';
end;

function TAndroidProjectDescriptor.GetLocalizedName: string;
begin
  Result := 'JNI Android Module'+ LineEnding;
end;

function TAndroidProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := 'A JNI Android loadable module (.so)'+ LineEnding +
            'in Free Pascal using DataModules.'+ LineEnding +
            'The library file is maintained by Lazarus.'
end;

     //just for test! not realistic!
function TAndroidProjectDescriptor.GetIdFromApi(api: integer): string;
begin
  {
  case api of
     17: result:= '1';
     18: result:= '2';
     19: result:= '3';
  end;
  }
  Result:= '1';
end;
     //just for test!  not realistic!
function TAndroidProjectDescriptor.GetFolderFromApi(api: integer): string;
begin
  case api of
     17: result:= 'android-4.2.2';
     18: result:= 'android-4.3';
     19: result:= 'android-4.4';
  end;
end;

function TAndroidProjectDescriptor.GetWorkSpaceFromForm: boolean;
var
  frm: TFormWorkspace;
  projName: string;
  strList: TStringList;
  i: integer;
begin
  Result:= False;
  frm:= TFormWorkspace.Create(nil);
  frm.LoadSettings(SettingsFilename);
  if frm.ShowModal = mrOK then
  begin
    frm.SaveSettings(SettingsFilename);

    FPathToJNIFolder:= frm.PathToWorkspace;
    FPathToNdkPlataforms:= frm.PathToNdkPlataforms;

    FInstructionSet:= frm.InstructionSet;{ ex. ArmV6}
    FFPUSet:= frm.FPUSet; {ex. Soft}

    FPathToJavaTemplates:= frm.PathToJavaTemplates;
    FAndroidProjectName:= frm.AndroidProjectName;    //warning: full project name = path + name !

    FPathToJavaJDK:= frm.PathToJavaJDK;

    FPathToAndroidSDK:= frm.PathToAndroidSDK;
    FPathToAndroidNDK:= frm.PathToAndroidNDK;
    FNDK:= frm.NDK;
    FAndroidPlatform:= frm.AndroidPlatform;

    FPathToAntBin:= frm.PathToAntBin;

    FMinApi:= frm.MinApi;
    FTargetApi:= frm.TargetApi;

    FMainActivity:= frm.MainActivity;

    if  frm.TouchtestEnabled = 'True' then
        FTouchtestEnabled:= '-Dtouchtest.enabled=true'
    else
       FTouchtestEnabled:='';

    FAntBuildMode:= frm.AntBuildMode;

    if frm.GUIControls = 'Yes' then
      FModuleType:= 0  {Yes: GUI / No: NoGUI}
    else
      FModuleType:= 1;

    FProjectModel:= frm.ProjectModel; //"Eclipse Project"/"Ant Project"

    if  FProjectModel = 'Ant' then
    begin
      strList:= TStringList.Create;

      FAntPackageName:= frm.AntPackageName;   //ex. just org.lazarus

      strList.Delimiter:= DirectorySeparator;
      strList.DelimitedText:= TrimChar(FAndroidProjectName, DirectorySeparator);
      projName:= strList.Strings[strList.Count-1]; //'AppTest1';

      strList.Clear;
      strList.Delimiter:= '.';
      strList.DelimitedText:= FAntPackageName+'.'+LowerCase(projName);
      if strList.Count < 3 then strList.DelimitedText:= 'org.'+FAntPackageName+'.'+LowerCase(projName);

      ChDir(FAndroidProjectName+DirectorySeparator+ 'src');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'src');

      FPathToJavaSrc:= FAndroidProjectName+DirectorySeparator+ 'src';
      for i:= 0 to strList.Count -1 do
      begin
         FPathToJavaSrc:= FPathToJavaSrc + DirectorySeparator + strList.Strings[i];
         ChDir(FPathToJavaSrc);
         if IOResult <> 0 then MkDir(FPathToJavaSrc);
      end;

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'res');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+'ic_launcher.png',
               FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+'ic_launcher.png');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-ldpi'+DirectorySeparator+'ic_launcher.png',
               FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi'+DirectorySeparator+'ic_launcher.png');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-mdpi'+DirectorySeparator+'ic_launcher.png',
               FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi'+DirectorySeparator+'ic_launcher.png');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-xhdpi'+DirectorySeparator+'ic_launcher.png',
               FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi'+DirectorySeparator+'ic_launcher.png');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-xxhdpi'+DirectorySeparator+'ic_launcher.png',
               FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi'+DirectorySeparator+'ic_launcher.png');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');

      strList.LoadFromFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'strings.xml');
      strList.Strings[2]:='<string name="app_name">'+projName+'</string>';
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'strings.xml');

      CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'styles.xml',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'styles.xml');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout');
      if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout');
      CopyFile(FPathToJavaTemplates+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'assets');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'assets');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'bin');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'bin');

      ChDir(FAndroidProjectName+DirectorySeparator+ 'gen');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'gen');

      //*.bat utils...
      ChDir(FAndroidProjectName+DirectorySeparator+ 'utils');
      if IOResult <> 0 then MkDir(FAndroidProjectName+ DirectorySeparator + 'utils');

      if FModuleType = 0 then     //GUI Android Controls...
      begin
        strList.Clear;    //dummy App.java - will be replaced with simonsayz's "App.java" template!
        strList.Add('package '+FAntPackageName+'.'+LowerCase(projName)+';');
        strList.Add('public class App extends Activity {');
        strList.Add('     //dummy app');
        strList.Add('}');
        strList.SaveToFile(FPathToJavaSrc+DirectorySeparator+'App.java');
      end;

      strList.Clear;
      strList.Add('set path='+FPathToAntBin);        //set path=C:\adt32\ant\bin
      strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
      strList.Add('cd '+FAndroidProjectName);
      if FAntBuildMode = 'debug' then
      begin
         if FTouchtestEnabled='' then
            strList.Add('ant debug')
         else
           strList.Add('ant -Dtouchtest.enabled=true debug');
      end
      else
      begin
        strList.Add('ant release');
      end;
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build.bat');

      {"android list targets" to see the available targets...}
      strList.Clear;
      strList.Add('cd '+FPathToAndroidSDK+DirectorySeparator+'tools');
      strList.Add('android list targets');
      strList.Add('cd '+FAndroidProjectName);
      strList.Add('pause');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'list_target.bat');

      //need to pause on double-click use...
      strList.Clear;
      strList.Add('cmd /K list_target.bat');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused_list_target.bat');

      strList.Clear;
      strList.Add('cd '+FPathToAndroidSDK+DirectorySeparator+'tools');
      strList.Add('android create avd -n avd_default -t 1 -c 32M');
      strList.Add('cd '+FAndroidProjectName);
      strList.Add('pause');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'create_avd_default.bat');

      //need to pause on double-click use...
      strList.Clear;
      strList.Add('cmd /K create_avd_default.bat');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused_create_avd_default.bat');

      strList.Clear;
      strList.Add('cd '+FPathToAndroidSDK+DirectorySeparator+'tools');
      if StrToInt(FMinApi) >= 15 then
         strList.Add('emulator -avd avd_default +  -gpu on &')  //gpu: api >= 15,,,
      else
         strList.Add('tools emulator -avd avd_api_'+FMinApi + ' &');
      strList.Add('cd '+FAndroidProjectName);
      //strList.Add('pause');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'launch_avd_default.bat');

      strList.Clear;
      strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
      strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+
                  DirectorySeparator+'adb install -r '+projName+'-'+FAntBuildMode+'.apk');
      strList.Add('cd ..');
      strList.Add('pause');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'install.bat');

      strList.Clear;
      strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
      strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+
                  DirectorySeparator+'adb uninstall '+FAntPackageName+'.'+LowerCase(projName));
      strList.Add('cd ..');
      strList.Add('pause');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'uninstall.bat');

      strList.Clear;
      strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
      strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+
                  DirectorySeparator+'adb logcat');
      strList.Add('cd ..');
      strList.Add('pause');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'logcat.bat');

      strList.Clear;
      strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
      strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+
                  DirectorySeparator+'adb logcat AndroidRuntime:E *:S');
      strList.Add('cd ..');
      strList.Add('pause');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'logcat_error.bat');

      strList.Clear;
      strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
      strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+DirectorySeparator+
                  'adb logcat ActivityManager:I '+projName+'-'+FAntBuildMode+'.apk:D *:S');
      strList.Add('cd ..');
      strList.Add('pause');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'logcat_app_perform.bat');

      (* //causes instability in the simulator! why ?
      strList.Clear;
      strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
      strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+DirectorySeparator+
                  'adb shell am start -a android.intent.action.MAIN -n '+
                   FAntPackageName+'.'+LowerCase(projName)+'/.'+FMainActivity);
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'launch_apk.bat');
      *)

      strList.Clear;
      strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
      strList.Add(FPathToAndroidSDK+DirectorySeparator+
                  'build-tools'+DirectorySeparator+ GetFolderFromApi(StrToInt(FMinApi))+
                  DirectorySeparator + 'aapt list '+projName+'-'+FAntBuildMode+'.apk');
      strList.Add('cd ..');
      strList.Add('pause');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'aapt.bat'); //Android Asset Packaging Tool

      strList.Clear;
      strList.Add('<?xml version="1.0" encoding="UTF-8"?>');
      strList.Add('<project name="'+projName+'" default="help">');
      strList.Add('<property name="sdk.dir" location="'+FPathToAndroidSDK+'"/>');
      strList.Add('<property name="target"  value="android-17"/>');
      strList.Add('<property file="ant.properties"/>');
      strList.Add('<fail message="sdk.dir is missing." unless="sdk.dir"/>');
      strList.Add('<import file="${sdk.dir}/tools/ant/build.xml"/>');
      strList.Add('</project>');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build.xml');

      strList.Clear;
      strList.Add('Tutorial: How to get your Android Application [Apk]:');
      strList.Add(' ');
      strList.Add('1. Double click "build.bat" to build Apk');
      strList.Add(' ');
      strList.Add('2. If Android Virtual Device[AVD]/Emulator is running then:');
      strList.Add('   2.1 double click "install.bat" to install the Apk on the Emulator');
      strList.Add('   2.2 look for the App "'+projName+'" in the Emulator and click it!');
      strList.Add(' ');
      strList.Add('3. If AVD/Emulator is NOT running:');
      strList.Add('   3.1 If AVD/Emulator NOT exist:');
      strList.Add('        3.1.1 double click "paused_create_avd_default.bat" to create the AVD ['+DirectorySeparator+'utils folder]');
      strList.Add('   3.2 double click "launch_avd_default.bat" to launch the Emulator ['+DirectorySeparator+'utils  folder]');
      strList.Add('   3.3 look for the App "'+projName+'" in the Emulator and click it!');
      strList.Add(' ');
      strList.Add('4. Log/Debug');
      strList.Add('   4.1 double click "logcat*.bat" to read Emulator logs and bugs! ['+DirectorySeparator+'utils folder]');
      strList.Add(' ');
      strList.Add('5. Uninstall Apk');
      strList.Add('   5.1 double click "uninstall.bat" to remove Apk from the Emulator!');
      strList.Add(' ');
      strList.Add('6. To find your app Look for the "'+projName+'-'+FAntBuildMode+'.apk" in '+DirectorySeparator+'bin folder!');
      strList.Add(' ');
      strList.Add('7. Android Asset Packaging Tool: to know which files were packed in "'+projName+'-'+FAntBuildMode+'.apk"');
      strList.Add('   7.1 double click "aapt.bat" ['+DirectorySeparator+'utils folder]' );
      strList.Add(' ');
      strList.Add('8. To see all available Android targets in your system ['+DirectorySeparator+'utils folder]');
      strList.Add('   8.1 double click "paused_list_target.bat" ');
      strList.Add(' ');
      strList.Add('9. Hint 1: you can edit "*.bat" to extend/modify some command or to fix some incorrect info/path!');
      strList.Add(' ');
      strList.Add('10.Hint 2: you can edit "build.xml" to set another Android target ex. "android-18" or "android-19" etc.');
      strList.Add(' ');
      strList.Add('11.Warning: After a new [Lazarus IDE]-> "run->build" do not forget to run again: "build.bat" and "install.bat" !');
      strList.Add(' ');
      strList.Add('....  Thank you!');
      strList.Add(' ');
      strList.Add('....  by jmpessoa_hotmail_com');
      strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme.txt');

      if FModuleType = 1 then     //No GUI Android Controls...
      begin
         strList.Clear;    //dummy App.java - will be replaced with simonsayz's "App.java" template!
         strList.Add('package '+FAntPackageName+'.'+LowerCase(projName)+';');
         strList.Add(' ');
         strList.Add('import android.os.Bundle;');
         strList.Add('import android.app.Activity;');
         strList.Add('import android.widget.Toast;');
         strList.Add(' ');
         strList.Add('public class App extends Activity {');
         strList.Add('  ');
         strList.Add('   JNIHello myHello;  //just for demo...');
         strList.Add('  ');
         strList.Add('   @Override');
         strList.Add('   protected void onCreate(Bundle savedInstanceState) {');
         strList.Add('       super.onCreate(savedInstanceState);');
         strList.Add('       setContentView(R.layout.activity_app);');
         strList.Add(' ');
         strList.Add('       myHello = new JNIHello(); //just for demo...');
         strList.Add(' ');
         strList.Add('       int sum = myHello.getSum(2,3); //just for demo...');
         strList.Add(' ');
         strList.Add('       String mens = myHello.getString(1); //just for demo...');
         strList.Add(' ');
         strList.Add('       Toast.makeText(getApplicationContext(), mens, Toast.LENGTH_SHORT).show();');
         strList.Add('       Toast.makeText(getApplicationContext(), "Total = " + sum, Toast.LENGTH_SHORT).show();');
         strList.Add('   }');
         strList.Add('}');
         strList.SaveToFile(FPathToJavaSrc+DirectorySeparator+'App.java');

         strList.Clear;
         strList.Add('package '+FAntPackageName+'.'+LowerCase(projName)+';');
         strList.Add(' ');
         strList.Add('public class JNIHello { //just for demo...');
         strList.Add(' ');
	 strList.Add('  public native String getString(int flag);');
	 strList.Add('  public native int getSum(int x, int y);');
         strList.Add(' ');
         strList.Add('  static {');
	 strList.Add('	  try {');
     	 strList.Add('	      System.loadLibrary("jnihello");');
	 strList.Add('	  } catch(UnsatisfiedLinkError ule) {');
 	 strList.Add('	      ule.printStackTrace();');
 	 strList.Add('	  }');
         strList.Add('  }');
         strList.Add(' ');
         strList.Add('}');
         strList.SaveToFile(FPathToJavaSrc+DirectorySeparator+'JNIHello.java');

         strList.Clear;
         strList.Add('<?xml version="1.0" encoding="utf-8"?>');
         strList.Add('<manifest xmlns:android="http://schemas.android.com/apk/res/android"');
         strList.Add('    package="'+FAntPackageName+'.'+LowerCase(projName)+'"');
         strList.Add('    android:versionCode="1"');
         strList.Add('    android:versionName="1.0" >');
         strList.Add('    <uses-sdk android:minSdkVersion="10"/>');
         strList.Add('    <application');
         strList.Add('        android:allowBackup="true"');
         strList.Add('        android:icon="@drawable/ic_launcher"');
         strList.Add('        android:label="@string/app_name"');
         strList.Add('        android:theme="@style/AppTheme" >');
         strList.Add('        <activity');
         strList.Add('            android:name="'+FAntPackageName+'.'+LowerCase(projName)+'.App"');
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
      strList.Free;
    end;
    //MessageDlg('Welcome to: *'+FProjectModel+'*',mtInformation, [mbOK], 0);
    Result := True;
  end;
  frm.Free;
end;

function TAndroidProjectDescriptor.DoInitDescriptor: TModalResult;
begin
   //MessageDlg('Welcome to Lazarus JNI Android module Wizard!',mtInformation, [mbOK], 0);
   if GetWorkSpaceFromForm then
   begin
      if TryNewJNIAndroidInterfaceCode then
        Result := mrOK
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
  listAux.Delimiter:= '.';
  listAux.StrictDelimiter:= True;
  listAux.DelimitedText:= ReplaceChar(className,'/','.');
  lastIndex:= listAux.Count-1;
  listAux.Delete(lastIndex);
  Result:= listAux.DelimitedText;
end;

function TAndroidProjectDescriptor.InitProject(AProject: TLazProject): TModalResult;
var
  MainFile: TLazProjectFile;
  projName, auxStr: string;
  sourceList: TStringList;
  auxList: TStringList;
  extInstructionSet: string;

  libraries_x86: string;
  libraries_arm: string;

  customOptions_x86: string;

  customOptions_armV6_soft: string;
  customOptions_armV6_vfpv2: string;
  customOptions_armV6_vfpv3: string;

  customOptions_armV7a_soft: string;
  customOptions_armV7a_vfpv2: string;
  customOptions_armV7a_vfpv3: string;

  pathToNdkPlataformsArm: string;
  pathToNdkPlataformsX86: string;
  pathToNdkToolchainsX86: string;
  pathToNdkToolchainsArm: string;
  osys: string;      {windows or linux-x86}
begin

  inherited InitProject(AProject);

  sourceList:= TStringList.Create;
  projName:= LowerCase(FJavaClassName) + '.lpr';
  MainFile := AProject.CreateProjectFile(projName);
  MainFile.IsPartOfProject := True;
  AProject.AddFile(MainFile, False);
  AProject.MainFileID := 0;

  if FModuleType = 0 then  //GUI controls
     AProject.AddPackageDependency('tfpandroidbridge_pack');

  sourceList.Add('{hint: save all files to location: ' +FPathToJNIFolder+DirectorySeparator+'jni }');
  sourceList.Add('library '+ LowerCase(FJavaClassName) +';');
  sourceList.Add(' ');
  sourceList.Add('{$mode delphi}');
  sourceList.Add(' ');
  sourceList.Add('uses');
  if FModuleType = 0 then  //GUI controls
  begin
    sourceList.Add('  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;');
    sourceList.Add(' ');
  end
  else //generic module :  No GUI Controls
  begin
    sourceList.Add('  Classes, SysUtils, CustApp, jni;');
    sourceList.Add(' ');
    sourceList.Add('type');
    sourceList.Add(' ');
    sourceList.Add('  jApp = class(TCustomApplication)');
    sourceList.Add('  public');
    sourceList.Add('     procedure CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('     constructor Create(TheOwner: TComponent); override;');
    sourceList.Add('     destructor Destroy; override;');
    sourceList.Add('  end;');
    sourceList.Add(' ');
    sourceList.Add('procedure jApp.CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('var');
    sourceList.Add('  Instance: TComponent;');
    sourceList.Add('begin');
    sourceList.Add('  Instance := TComponent(InstanceClass.NewInstance);');
    sourceList.Add('  TComponent(Reference):= Instance;');
    sourceList.Add('  Instance.Create(Self);');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('constructor jApp.Create(TheOwner: TComponent);');
    sourceList.Add('begin');
    sourceList.Add('  inherited Create(TheOwner);');
    sourceList.Add('  StopOnException:=True;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('destructor jApp.Destroy;');
    sourceList.Add('begin');
    sourceList.Add('  inherited Destroy;');
    sourceList.Add('end;');
    sourceList.Add(' ');
    sourceList.Add('var');
    sourceList.Add('  gApp: jApp;');
    sourceList.Add(' ');
  end;
  sourceList.Add(Trim(FPascalJNIIterfaceCode));  {from form...}
  sourceList.Add(' ');
  sourceList.Add('begin');
  if FModuleType = 0 then  //GUI controls...
  begin
    sourceList.Add('  gApp:= jApp.Create(nil);{Laz_And_Controls}');
    sourceList.Add('  gApp.Title:= ''My Android GUI Library'';');
    sourceList.Add('  gjAppName:= '''+GetAppName(FPathToClassName)+''';{And_jni_Bridge}');
    sourceList.Add('  gjClassName:= '''+FPathToClassName+''';{And_jni_Bridge}');
    sourceList.Add('  gApp.AppName:=gjAppName;');
    sourceList.Add('  gApp.ClassName:=gjClassName;');
    sourceList.Add('  gApp.Initialize;');
    sourceList.Add('  gApp.CreateForm(TAndroidModule1, AndroidModule1);');
  end
  else
  begin
     sourceList.Add('  gApp:= jApp.Create(nil);');
     sourceList.Add('  gApp.Title:= ''My Android NoGUI Library'';');
     sourceList.Add('  gApp.Initialize;');
     sourceList.Add('  gApp.CreateForm(TNoGUIAndroidModule1, NoGUIAndroidModule1);');
  end;
  sourceList.Add('end.');

  AProject.MainFile.SetSourceText(sourceList.Text);
  AProject.Flags := AProject.Flags - [pfMainUnitHasCreateFormStatements,
                                      pfMainUnitHasTitleStatement,
                                      pfLRSFilesInOutputDirectory];
  AProject.UseManifest:= False;
  AProject.UseAppBundle:= False;

  if (Pos('\', FPathToAndroidNDK) > 0) or (Pos(':', FPathToAndroidNDK) > 0) then osys:= 'windows'
  else osys:= 'linux-x86';

   {Set compiler options for Android requirements}
  pathToNdkPlataformsArm:= FPathToAndroidNDK+DirectorySeparator+'platforms'+DirectorySeparator+
                                                FAndroidPlatform +DirectorySeparator+'arch-arm'+DirectorySeparator+
                                                'usr'+DirectorySeparator+'lib';

  if FNdk = '7' then
      pathToNdkToolchainsArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.4.3';
  if FNDK = '9' then
      pathToNdkToolchainsArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.6';

  libraries_arm:= pathToNdkPlataformsArm+';'+pathToNdkToolchainsArm;

  pathToNdkPlataformsX86:= FPathToAndroidNDK+DirectorySeparator+'platforms'+DirectorySeparator+
                                             FAndroidPlatform+DirectorySeparator+'arch-x86'+DirectorySeparator+
                                             'usr'+DirectorySeparator+'lib';
  if FNdk = '7' then
      pathToNdkToolchainsX86:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+
                                                 'gcc'+DirectorySeparator+'i686-android-linux'+DirectorySeparator+'4.4.3';
  if FNDK = '9' then
      pathToNdkToolchainsX86:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'i686-android-linux'+DirectorySeparator+'4.6';

  libraries_x86:= pathToNdkPlataformsX86+';'+pathToNdkToolchainsX86;

  if Pos('x86', FInstructionSet) > 0 then
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'i386';    {-P}
     AProject.LazCompilerOptions.Libraries:= libraries_x86;
     FPathToNdkPlataforms:= pathToNdkPlataformsX86;
     FPathToNdkToolchains:= pathToNdkToolchainsX86;
  end
  else
  begin
     AProject.LazCompilerOptions.TargetCPU:= 'arm';    {-P}
     AProject.LazCompilerOptions.Libraries:= libraries_arm;
     FPathToNdkPlataforms:= pathToNdkPlataformsArm;
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

  AProject.LazCompilerOptions.OptimizationLevel:= 1;
  AProject.LazCompilerOptions.Win32GraphicApp:= False;

  {Link}
  AProject.LazCompilerOptions.StripSymbols:= True; {-Xs}
  AProject.LazCompilerOptions.LinkSmart:= True {-XX};
  AProject.LazCompilerOptions.GenerateDebugInfo:= False;

  {Verbose}
      //.....................
  auxList:= TStringList.Create;
  customOptions_x86:= '-dANDROID -Xd'+
                      ' -FL'+pathToNdkPlataformsX86+DirectorySeparator+'libdl.so' +  {as dynamic linker}
                      ' -FU'+FPathToJNIFolder+DirectorySeparator+'obj'+ DirectorySeparator+ FJavaClassName +
                      ' -o'+FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+'x86'+DirectorySeparator+'lib'+ LowerCase(FJavaClassName)+'.so';  {-o}

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_x86+'"/>');
  auxList.Add('<TargetCPU Value="i386"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_x86+'"/>');
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86.txt');

  customOptions_armV6_soft:= '-dANDROID -Xd -CpArmV6 -CfSoft'+
                             ' -FL'+pathToNdkPlataformsArm+DirectorySeparator+'libdl.so' +  {as dynamic linker}
                             ' -FU'+FPathToJNIFolder+DirectorySeparator+'obj'+ DirectorySeparator+ FJavaClassName +
                             ' -o'+FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+'armeabi'+DirectorySeparator+'lib'+ LowerCase(FJavaClassName)+'.so';  {-o}
  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV6_soft+'"/>');
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6_soft.txt');

  customOptions_armV6_vfpV2:= '-dANDROID -Xd -CpArmV6 -CfVfpV2'+
                              ' -FL'+pathToNdkPlataformsArm+DirectorySeparator+'libdl.so' +  {as dynamic linker}
                              ' -FU'+FPathToJNIFolder+DirectorySeparator+'obj'+ DirectorySeparator+ FJavaClassName +
                              ' -o'+FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+'armeabi'+DirectorySeparator+'lib'+ LowerCase(FJavaClassName)+'.so';  {-o}
  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV6_vfpV2+'"/>');
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6_vfpV2.txt');

  customOptions_armV6_vfpV3:= '-dANDROID -Xd -CpArmV6 -CfVfpV3'+
                              ' -FL'+pathToNdkPlataformsArm+DirectorySeparator+'libdl.so' +  {as dynamic linker}
                              ' -FU'+FPathToJNIFolder+DirectorySeparator+'obj'+ DirectorySeparator+ FJavaClassName +
                              ' -o'+FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+'armeabi'+DirectorySeparator+'lib'+ LowerCase(FJavaClassName)+'.so';  {-o}
  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV6_vfpV3+'"/>');
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6_vfpV3.txt');

  customOptions_armV7a_soft:= '-dANDROID -Xd -CpArmV7a -CfSoft'+
                              ' -FL'+pathToNdkPlataformsArm+DirectorySeparator+'libdl.so' +  {as dynamic linker}
                              ' -FU'+FPathToJNIFolder+DirectorySeparator+'obj'+ DirectorySeparator+ FJavaClassName +
                              ' -o'+FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a'+DirectorySeparator+'lib'+ LowerCase(FJavaClassName)+'.so';  {-o}
  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a_soft+'"/>');
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a_soft.txt');

  customOptions_armV7a_vfpV2:= '-dANDROID -Xd -CpArmV7a -CfVfpV2'+
                               ' -FL'+pathToNdkPlataformsArm+DirectorySeparator+'libdl.so' +  {as dynamic linker}
                               ' -FU'+FPathToJNIFolder+DirectorySeparator+'obj'+ DirectorySeparator+ FJavaClassName +
                               ' -o'+FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a'+DirectorySeparator+'lib'+ LowerCase(FJavaClassName)+'.so';  {-o}
  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a_vfpV2+'"/>');
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a_vfpV2.txt');

  customOptions_armV7a_vfpV3:= '-dANDROID -Xd -CpArmV7a -CfVfpV3'+
                               ' -FL'+pathToNdkPlataformsArm+DirectorySeparator+'libdl.so' +  {as dynamic linker}
                               ' -FU'+FPathToJNIFolder+DirectorySeparator+'obj'+ DirectorySeparator+ FJavaClassName +
                               ' -o'+FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a'+DirectorySeparator+'lib'+ LowerCase(FJavaClassName)+'.so';  {-o}
  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a_vfpV3+'"/>');
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a_vfpV3.txt');

  auxList.Clear;
  auxList.Add('How To Get More Builds:');
  auxList.Add(' ');
  auxList.Add('   :: Warning: Your system [Laz4Android ?] needs to be prepared for the various builds!');
  auxList.Add(' ');
  auxList.Add('1. Edit Lazarus project file "*.lpi": [use notepad like editor]');
  auxList.Add(' ');
  auxList.Add('   > Open the "*.lpi" project file');
  auxList.Add(' ');
  auxList.Add('       -If needed replace the line <Libraries ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <TargetCPU ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <CustomOptions ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add(' ');
  auxList.Add('   > Save the "*.lpi" project file ');
  auxList.Add(' ');
  auxList.Add('2. From Laz4Android IDE');
  auxList.Add(' ');
  auxList.Add('   >Reopen the Project');
  auxList.Add(' ');
  auxList.Add('   > Run -> Build');
  auxList.Add(' ');
  auxList.Add('4. Repeat for others "build_*.txt" if needed...');
  auxList.Add(' ');
  if FProjectModel = 'Ant' then
    auxList.Add('4. Execute [double click] the "build.bat" file to get the Apk !')
  else
  begin
    auxList.Add('4. From Eclipse IDE:');
    auxList.Add(' ');
    auxList.Add('   -right click your  project: -> Refresh');
    auxList.Add(' ');
    auxList.Add('   -right click your  project: -> Run as -> Android Application');
  end;
  auxList.Add(' ');
  auxList.Add(' ');
  auxList.Add(' ');
  auxList.Add('      Thank you!');
  auxList.Add('      By  ___jmpessoa_hotmail.com_____');
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'readme.txt');

  auxList.Free;
  extInstructionSet:='';
  if FInstructionSet <> 'x86' then extInstructionSet:= ' -Cp'+FInstructionSet + ' -Cf'+ FFPUSet;

  auxStr:= 'armeabi';
  if FInstructionSet = 'ARMv7a' then auxStr:='armeabi-v7a';
  if FInstructionSet = 'x86' then auxStr:='x86';

  AProject.LazCompilerOptions.TargetFilename:=
                              FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+auxStr+DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';{-o}

  {Others}
  AProject.LazCompilerOptions.CustomOptions:=
                        '-dANDROID -Xd'+extInstructionSet+
                        ' -FL'+FPathToNdkPlataforms+DirectorySeparator+'libdl.so' +  {as dynamic linker}
                        ' -FU'+FPathToJNIFolder+DirectorySeparator+'obj'+ DirectorySeparator+ FJavaClassName +
                        ' -o'+FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+auxStr+DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';  {-o}
  sourceList.Free;
  Result := mrOK;
end;

function TAndroidProjectDescriptor.CreateStartFiles(AProject: TLazProject): TModalResult;
begin
  if FModuleType = 0 then  //GUI Controls
  begin
    AndroidFileDescriptor.ResourceClass:= TAndroidModule;
  end
  else // =1 -> No GUI Controls
  begin
    AndroidFileDescriptor.ResourceClass:= TNoGUIAndroidModule;
  end;
  LazarusIDE.DoNewEditorFile(AndroidFileDescriptor, '', '',
                             [nfIsPartOfProject,nfOpenInEditor,nfCreateDefaultSrc]);
  Result := mrOK;
end;

{ TAndroidFileDescriptor}

constructor TAndroidFileDescPascalUnitWithResource.Create;
begin
  inherited Create;
  Name := 'Android DataModule';
  if ModuleType = 0 then
    ResourceClass := TAndroidModule
  else
    ResourceClass := TNoGUIAndroidModule
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedName: string;
begin
   Result := 'Android DataModule'
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedDescription: string;
begin
   Result := 'Create a new Unit with a DataModule for JNI Android module (.so)';
end;

function TAndroidFileDescPascalUnitWithResource.CreateSource(const Filename     : string;
                                                       const SourceName   : string;
                                                       const ResourceName : string): string;
var
   sourceList: TStringList;
   unitName:  string;
begin
   unitName:= FileName;
   unitName:= SplitStr(unitName,'.');
   sourceList:= TStringList.Create;
   sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder+DirectorySeparator+'jni }');
   sourceList.Add('unit '+unitName+';');
   sourceList.Add(' ');
   if SyntaxMode = smDelphi then
      sourceList.Add('{$mode delphi}');
   if SyntaxMode = smObjFpc then
     sourceList.Add('{$mode objfpc}{$H+}');
   sourceList.Add(' ');
   sourceList.Add('interface');
   sourceList.Add(' ');
   sourceList.Add('uses');
   sourceList.Add('  ' + GetInterfaceUsesSection);
   if ModuleType = 1 then //no GUI
   begin
    sourceList.Add(' ');
    sourceList.Add('const');
    sourceList.Add('  gjClassPath: string='''';');
    sourceList.Add('  gjClass: JClass=nil;');
    sourceList.Add('  gPDalvikVM: PJavaVM=nil;');
   end;
   sourceList.Add(GetInterfaceSource(Filename, SourceName, ResourceName));
   sourceList.Add('implementation');
   sourceList.Add(' ');
   sourceList.Add(GetImplementationSource(Filename, SourceName, ResourceName));
   sourceList.Add('end.');
   Result:= sourceList.Text;
   //sourceList.SaveToFile(BasePathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'u'+ResourceName+'.pas');
   sourceList.Free;
end;

function TAndroidFileDescPascalUnitWithResource.GetInterfaceUsesSection: string;
begin
  if ModuleType = 1 then //generic module: No GUI Controls
    Result := 'Classes, SysUtils, jni;'
  else  //GUI controls module
    Result := 'Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;';
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
  else //generic module
  begin
    if ResourceName <> '' then
      strList.Add('  T' + ResourceName + ' = class(TDataModule)')
    else
      strList.Add('  TNoGUIAndroidModuleXX  = class(TDataModule)');
  end;
  strList.Add('   private');
  strList.Add('     {private declarations}');
  strList.Add('   public');
  strList.Add('     {public declarations}');
  strList.Add('  end;');
  strList.Add(' ');
  strList.Add('var');
  //strList.Add('  ' + ResourceName + ': T' + ResourceName + ';');
  if ModuleType = 0 then //GUI controls module
  begin
    if ResourceName <> '' then
       strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
       strList.Add('  AndroidModuleXX: TDataMoule');
  end
  else //generic module
  begin
    if ResourceName <> '' then
      strList.Add('  ' + ResourceName + ': T' + ResourceName + ';')
    else
      strList.Add('  NoGUIAndroidModuleXX: TNoGUIDataMoule');
  end;
  Result := strList.Text;
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
 // sttList.Add(' ');
  Result:= sttList.Text;
  sttList.Free;
end;

//helper...
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

end.

