unit AndroidWizard_intf;

{$Mode Delphi}

interface

uses
 Classes, SysUtils, FileUtil, Controls, Forms, Dialogs,
 LazIDEIntf, ProjectIntf, FormEditingIntf, uFormAndroidProject, uformworkspace, Laz_And_Controls;

type

  TAndroidModule = class(jForm)
  end;

  TAndroidProjectDescriptor = class(TProjectDescriptor)
   private
     FPascalJNIIterfaceCode: string;
     FJavaClassName: string;
     FPathToClassName: string;
     FPathToJavaClass: string;
     FPathToJNIFolder: string;
     FPathToNdkPlataformsAndroidArcharmUsrLib: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
     FPathToNdkToolchains: string;
     {C:\adt32\ndk7\toolchains\arm-linux-androideabi-4.4.3\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.4.3}
     FInstructionSet: string;    {ArmV6}
     FFPUSet: string;            {Soft}
     FPathToJavaTemplates: string;
     FAndroidProjectName: string;
     FModuleType: integer;
     FSyntaxMode: TSyntaxMode;   {}

     FPathToJavaJDK: string;
     FPathToAndroidSDK: string;
     FPathToAntBin: string;
     FProjectModel: string; {"Eclipse Project"/"Ant Project"}
     FAntPackageName: string;
     FTargetApi: string;
     FTouchtestEnabled: string;
     FAntBuildMode: string;
     FMainActivity: string;
     FPathToJavaSrc: string;

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
    ModuleType: integer;
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
end;

{TAndroidProjectDescriptor}

function TAndroidProjectDescriptor.SettingsFilename: string;
begin
  Result := AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini'
end;

function TAndroidProjectDescriptor.GetPathToJNIFolder(fullPath: string): string;
var
  pathList: TStringList;
  i, j, k: integer;
begin
  pathList:= TStringList.Create;
  pathList.Delimiter:=DirectorySeparator;
  pathList.DelimitedText:= TrimChar(fullPath,DirectorySeparator);

  for i:=0 to pathList.Count-1 do
  begin
     if Pos('src', pathList.Strings[i])>0 then k:= i;
  end;
  Result:= '';
  for j:= 0 to k-1 do
  begin
      Result:= Result + pathList.Strings[j]+DirectorySeparator;
  end;
  Result:= TrimChar(Result, DirectorySeparator);;
  pathList.Free;
end;

function TAndroidProjectDescriptor.TryNewJNIAndroidInterfaceCode: boolean;
var
  frm: TFormAndroidProject;
  auxStr: string;
begin
  Result := False;
  frm:= TFormAndroidProject.Create(nil);
  frm.ShellTreeView1.Root:= FPathToJNIFolder;  //workspace...
  frm.PathToJavaTemplates:= FPathToJavaTemplates;
  frm.AndroidProjectName:= FAndroidProjectName;
  frm.ModuleType:= FModuleType;
  frm.MainActivity:= FMainActivity;
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
    ChDir(FPathToJNIFolder+DirectorySeparator+ 'jni');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'jni');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'obj');
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'obj');

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'obj'+DirectorySeparator+FJavaClassName);
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'obj'+DirectorySeparator+LowerCase(FJavaClassName));

    auxStr:='armeabi';
    if FInstructionSet = 'ArmV7' then auxStr:='armeabi-v7a';

    ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+auxStr);
    if IOResult <> 0 then MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+auxStr);

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

function TAndroidProjectDescriptor.GetIdFromApi(api: integer): string;
begin
  case api of
     17: result:= '1';
     18: result:= '2';
     19: result:= '3';
  end;
end;

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

    FPathToJNIFolder:= frm.PathToWorkspace;      {ex. C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
    FPathToNdkPlataformsAndroidArcharmUsrLib:= frm.PathToNdkPlataformsAndroidArcharmUsrLib;
    FPathToNdkToolchains:= frm.PathToNdkToolchains;

    FInstructionSet:= frm.InstructionSet;{ ex. ArmV6}
    FFPUSet:= frm.FPUSet; {ex. Soft}

    FPathToJavaTemplates:= frm.PathToJavaTemplates;
    FAndroidProjectName:= frm.AndroidProjectName;    //full project name

    FPathToJavaJDK:= frm.PathToJavaJDK;
    FPathToAndroidSDK:= frm.PathToAndroidSDK;
    FPathToAntBin:= frm.PathToAntBin;

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

      //ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');
      //if IOResult <> 0 then MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');
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
        strList.Add('android create avd -n avd_api_'+FTargetApi+' -t '+
                     GetIdFromApi(StrToInt(FTargetApi)) + ' -c 32M'); //avd -n avd17 -t 17
        strList.Add('cd '+FAndroidProjectName);
        strList.Add('pause');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'create_avd_'+FTargetApi+'.bat');

        //need to pause on double-click use...
        strList.Clear;
        strList.Add('cmd /K create_avd_'+FTargetApi+'.bat');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'paused_create_avd_'+FTargetApi+'.bat');

        strList.Clear;
        strList.Add('cd '+FPathToAndroidSDK+DirectorySeparator+'tools');
        if StrToInt(FTargetApi) >= 15 then
           strList.Add('emulator -avd avd_api_'+FTargetApi + ' -gpu on &')  //gpu: api >= 15,,,
        else
           strList.Add('tools emulator -avd avd_api_'+FTargetApi + ' &');
        strList.Add('cd '+FAndroidProjectName);
        //strList.Add('pause');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'launch_avd_api_'+FTargetApi+'.bat');

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
                    'build-tools'+DirectorySeparator+ GetFolderFromApi(StrToInt(FTargetApi))+
                    DirectorySeparator + 'aapt list '+projName+'-'+FAntBuildMode+'.apk');
        strList.Add('cd ..');
        strList.Add('pause');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'utils'+DirectorySeparator+'aapt.bat'); //Android Asset Packaging Tool

        strList.Clear;
        strList.Add('<?xml version="1.0" encoding="UTF-8"?>');
        strList.Add('<project name="'+projName+'" default="help">');
        strList.Add('<property name="sdk.dir" location="'+FPathToAndroidSDK+'"/>');
        strList.Add('<property name="target"  value="android-'+FTargetApi+'"/>');
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
        strList.Add('   2.2 look for the App '+projName+' on the Emulator and click it!');
        strList.Add(' ');
        strList.Add('3. If AVD/Emulator target Api['+FTargetApi+'] is NOT running:');
        strList.Add('   3.1 If AVD/Emulator target Api['+FTargetApi+'] NOT exist:');
        strList.Add('        3.1.1 double click "paused_create_avd*.bat" to create the AVD ['+DirectorySeparator+'utils folder]');
        strList.Add('   3.2 double click "launch_avd*.bat" to launch the Emulator ['+DirectorySeparator+'utils  folder]');
        strList.Add('   3.3 look for the App '+projName+' on  the Emulator and click it!');
        strList.Add(' ');
        strList.Add('4. Log/Debug');
        strList.Add('   4.1 double click "logcat*.bat" to read Emulator logs and bugs! ['+DirectorySeparator+'utils folder]');
        strList.Add(' ');
        strList.Add('5. Uninstall Apk');
        strList.Add('   5.1 double click "uninstall.bat" to remove Apk from the Emulator!');
        strList.Add(' ');
        strList.Add('6. Look for the Android '+projName+'-'+FAntBuildMode+'.apk in '+DirectorySeparator+'bin folder!');
        strList.Add(' ');
        strList.Add('7. Android Asset Packaging Tool: to know which files were packed in '+projName+'-'+FAntBuildMode+'.apk');
        strList.Add('   7.1 double click "aapt.bat" ['+DirectorySeparator+'utils folder]' );
        strList.Add(' ');
        strList.Add('8. To see all available Android targets Api ['+DirectorySeparator+'utils folder]');
        strList.Add('   8.1 double click "paused_list_target.bat" ');
        strList.Add(' ');
        strList.Add('9. Hint: you can edit "*.bat" to extend/modify some command or to fix some incorrect path!');
        strList.Add(' ');
        strList.Add('10. Warning: After Lazarus run->build do not forget to run again: "build.bat" and "install.bat" !');
        strList.Add(' ');
        strList.Add('....  Thank you!');
        strList.Add(' ');
        strList.Add('....  by jmpessoa_hotmail_com');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme.txt'); //Android Asset Packaging Tool

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
    sourceList.Add('  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;')
  else //generic module :  No GUI Controls
    sourceList.Add('  Classes, SysUtils, CustApp, And_jni;');

  sourceList.Add(' ');
  sourceList.Add('const');
  sourceList.Add('  curClassPathName: string='''';');
  sourceList.Add('  curClass: JClass=nil;');
  sourceList.Add('  curVM: PJavaVM=nil;');
  sourceList.Add('  curEnv: PJNIEnv=nil;');
  sourceList.Add(' ');
  if FModuleType = 1 then   //generic module: No GUI Controls
  begin
      sourceList.Add('type');
      sourceList.Add(' ');
      sourceList.Add('  TApp = class(TCustomApplication)');
      sourceList.Add('   public');
      sourceList.Add('     procedure CreateForm(InstanceClass: TComponentClass; out Reference);');
      sourceList.Add('     constructor Create(TheOwner: TComponent); override;');
      sourceList.Add('     destructor Destroy; override;');
      sourceList.Add('  end;');
      sourceList.Add(' ');
      sourceList.Add('procedure TApp.CreateForm(InstanceClass: TComponentClass; out Reference);');
      sourceList.Add('var');
      sourceList.Add('  Instance: TComponent;');
      sourceList.Add('begin');
      sourceList.Add('  Instance := TComponent(InstanceClass.NewInstance);');
      sourceList.Add('  TComponent(Reference):= Instance;');
      sourceList.Add('  Instance.Create(Self);');
      sourceList.Add('end;');
      sourceList.Add(' ');
      sourceList.Add('constructor TApp.Create(TheOwner: TComponent);');
      sourceList.Add('begin');
      sourceList.Add('  inherited Create(TheOwner);');
      sourceList.Add('  StopOnException:=True;');
      sourceList.Add('end;');
      sourceList.Add(' ');
      sourceList.Add('destructor TApp.Destroy;');
      sourceList.Add('begin');
      sourceList.Add('  inherited Destroy;');
      sourceList.Add('end;');
      sourceList.Add(' ');
      sourceList.Add('var');
      sourceList.Add('  App: TApp;');
      sourceList.Add(' ');
  end;
  sourceList.Add(Trim(FPascalJNIIterfaceCode));  {from form...}
  sourceList.Add(' ');
  sourceList.Add('begin');
  if FModuleType = 0 then  //GUI controls...
  begin
    sourceList.Add('  App:= jApp.Create(nil);{Laz_And_Controls}');
    sourceList.Add('  App.Title:= ''My Android GUI Library'';');
    sourceList.Add('  gjAppName:= '''+GetAppName(FPathToClassName)+''';{And_jni_Bridge}');
    sourceList.Add('  gjClassName:= '''+FPathToClassName+''';{And_jni_Bridge}');
    sourceList.Add('  App.AppName:=gjAppName;');
    sourceList.Add('  App.ClassName:=gjClassName;');
    sourceList.Add('  App.Initialize;');
    sourceList.Add('  App.CreateForm(TAndroidModule1, AndroidModule1);');
  end
  else
  begin
     sourceList.Add('  App:= TApp.Create(nil);');
     sourceList.Add('  App.Title:= ''My Android NoGUI Library'';');
     sourceList.Add('  App.Initialize;');
     sourceList.Add('  App.CreateForm(TAndroidModule1, AndroidModule1);');
  end;
  sourceList.Add('end.');

  AProject.MainFile.SetSourceText(sourceList.Text);
  AProject.Flags := AProject.Flags - [pfMainUnitHasCreateFormStatements,
                                      pfMainUnitHasTitleStatement,
                                      pfLRSFilesInOutputDirectory];
  AProject.UseManifest:= False;
  AProject.UseAppBundle:= False;

  {Set compiler options for Android requirements...}

  {Paths}
  AProject.LazCompilerOptions.Libraries:= FPathToNdkPlataformsAndroidArcharmUsrLib + ';' +
                                          FPathToNdkToolchains;
  auxStr:= 'armeabi';
  if FInstructionSet = 'ARMv7a' then auxStr:='armeabi-v7a';

  AProject.LazCompilerOptions.TargetFilename:=FPathToJNIFolder+'\libs\'+auxStr;{-o}

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
  AProject.LazCompilerOptions.TargetCPU:= 'arm';    {-P}
  AProject.LazCompilerOptions.OptimizationLevel:= 1;
  AProject.LazCompilerOptions.Win32GraphicApp:= False;
   {Link}
  AProject.LazCompilerOptions.StripSymbols:= True; {-Xs}
  AProject.LazCompilerOptions.LinkSmart:= True {-XX};
  AProject.LazCompilerOptions.GenerateDebugInfo:= False;
   {Verbose}
   {Others}
  AProject.LazCompilerOptions.CustomOptions:=
                        '-dANDROID -Xd -Cp'+FInstructionSet+ ' -Cf'+ FFPUSet+
                        ' -FL'+FPathToNdkPlataformsAndroidArcharmUsrLib+DirectorySeparator+'libdl.so' +  {as dynamic linker}
                        ' -FU'+FPathToJNIFolder+DirectorySeparator+'obj'+ DirectorySeparator+ FJavaClassName +
                        ' -o'+FPathToJNIFolder+DirectorySeparator+'libs'+DirectorySeparator+auxStr+DirectorySeparator+'lib'+ LowerCase(FJavaClassName)+'.so';  {-o}

                         //-o'+FPathToJNIFolder+'\libs\'+auxStr+'\'+'lib'+LowerCase(FJavaClassName)+'.so'

  sourceList.Free;
  Result := mrOK;
end;

function TAndroidProjectDescriptor.CreateStartFiles(AProject: TLazProject): TModalResult;
begin
  LazarusIDE.DoNewEditorFile(AndroidFileDescriptor, '', '',
                             [nfIsPartOfProject,nfOpenInEditor,nfCreateDefaultSrc]);
  Result := mrOK;
end;

{ TAndroidFileDescriptor}

constructor TAndroidFileDescPascalUnitWithResource.Create;
begin
  inherited Create;
  Name := 'Android DataModule';
  ResourceClass := TAndroidModule;
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
  if ModuleType = 1 then //generic module
    Result := 'Classes, SysUtils, And_jni;'
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
    strList.Add('  T' + ResourceName + ' = class(jForm)')
  else //generic module
    strList.Add('  T' + ResourceName + ' = class(TDataModule)');
  strList.Add('   private');
  strList.Add('     {private declarations}');
  strList.Add('   public');
  strList.Add('     {public declarations}');
  strList.Add('  end;');
  strList.Add(' ');
  strList.Add('var');
  strList.Add('  ' + ResourceName + ': T' + ResourceName + ';');
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

