unit AndroidWizard_intf;

{$Mode Delphi}

interface

uses
 Classes, SysUtils, FileUtil, Controls, Forms, Dialogs, Graphics,
 LCLProc, LCLType, LCLIntf, LazIDEIntf, ProjectIntf, FormEditingIntf, uFormAndroidProject,
 uformworkspace, FPimage, AndroidWidget;

type

  TAndroidModule = class(jForm)            //support to Adroid Bridges [components]
  end;

  TNoGUIAndroidModule = class(TDataModule) //raw ".so"
  end;

  { TAndroidProjectDescriptor }

  TAndroidProjectDescriptor = class(TProjectDescriptor)
   private
     FPascalJNIInterfaceCode: string;
     FJavaClassName: string;
     FPathToClassName: string;
     FPathToJavaClass: string;
     FPathToJNIFolder: string;
     FPathToNdkPlatforms: string; {C:\adt32\ndk\platforms\android-14\arch-arm\usr\lib}
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
     FProjectModel: string;
     FAntPackageName: string;
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

     function SettingsFilename: string;
     function TryNewJNIAndroidInterfaceCode(projectType: integer): boolean; //0: GUI  project --- 1:NoGUI project
     function GetPathToJNIFolder(fullPath: string): string;
     function GetWorkSpaceFromForm(projectType: integer): boolean;
     function GetAppName(className: string): string;
     function GetIdFromApi(api: integer): string;
     function GetFolderFromApi(api: integer): string;
     procedure ChDir(const Dir: String);
     procedure Mkdir(const Dir: String);
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


procedure Register;

function SplitStr(var theString: string; delimiter: string): string;

implementation

uses
   Laz_And_GLESv2_Canvas, uJavaParser, LamwDesigner;

procedure Register;
begin

  FormEditingHook.RegisterDesignerMediator(TAndroidWidgetMediator);
  AndroidFileDescriptor := TAndroidFileDescPascalUnitWithResource.Create;
  RegisterProjectFileDescriptor(AndroidFileDescriptor);

  AndroidProjectDescriptor:= TAndroidProjectDescriptor.Create;
  RegisterProjectDescriptor(AndroidProjectDescriptor);

  AndroidGUIProjectDescriptor:= TAndroidGUIProjectDescriptor.Create;
  //RegisterProjectDescriptor(TAndroidGUIProjectDescriptor.Create); //original
  RegisterProjectDescriptor(AndroidGUIProjectDescriptor);

  FormEditingHook.RegisterDesignerBaseClass(TAndroidModule);
  FormEditingHook.RegisterDesignerBaseClass(TNoGUIAndroidModule);

end;

{ TAndroidGUIProjectDescriptor }

constructor TAndroidGUIProjectDescriptor.Create;
begin
  inherited Create;
  Name := 'Create new [GUI] JNI Android Module (.so)';
end;

function TAndroidGUIProjectDescriptor.GetLocalizedName: string;
begin
  Result:= 'JNI Android Module [Lamw GUI]';
end;

function TAndroidGUIProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:= 'A [GUI] JNI Android loadable module (.so)'+ LineEnding +
            'based on Simonsayz''s templates'+ LineEnding +
            'with Form Designer and Android Components Bridges.'+ LineEnding +
            'The project and library file is maintained by Lazarus [Lamw].'
end;

function TAndroidGUIProjectDescriptor.DoInitDescriptor: TModalResult;
var
  projName, strAfterReplace, strPack, fullPathToJavaSrc: string;
  i: Integer;
begin
  try
    if GetWorkSpaceFromForm(0) then
    begin

      if FProjectModel = 'Eclipse' then
      begin
         if not TryNewJNIAndroidInterfaceCode(0) then Exit; //0: GUI project
         strPack:= FFullPackageName;
         FPathToJavaSrc:= FFullJavaSrcPath;
      end
      else //Ant project
      begin
        with TStringList.Create do
        try
          LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'Controls.java');
          projName := FAndroidProjectName;
          i := Pos(DirectorySeparator, projName);
          while i > 0 do
          begin
            System.Delete(projName, 1, i);
            i := Pos(DirectorySeparator, projName);
          end;
          strPack := FAntPackageName + '.' + LowerCase(projName);
          Strings[0] := 'package ' + strPack + ';';

          SaveToFile(FPathToJavaSrc + DirectorySeparator + 'Controls.java');

          LoadFromFile(FPathToJavaTemplates + DirectorySeparator + 'App.java');
          Strings[0] := 'package ' + strPack + ';';
          SaveToFile(FPathToJavaSrc + DirectorySeparator + 'App.java');

        finally
          Free;
        end;
      end;

      FModuleType := 0; //0: GUI --- 1:NoGUI
      FJavaClassName := 'Controls';
      if FProjectModel = 'Ant' then
      begin
         FPathToJNIFolder :=  GetPathToJNIFolder(FPathToJavaSrc);
         FPathToClassName := StringReplace(FAntPackageName, '.', '/', [rfReplaceAll])
           + '/' + LowerCase(projName) + '/' + FJavaClassName;
      end
      else
      begin  //Eclipse project
         FPathToJNIFolder := FAndroidProjectName;
      end;
      AndroidFileDescriptor.PathToJNIFolder:= FPathToJNIFolder;
      AndroidFileDescriptor.ModuleType:= 0;

      if FProjectModel =  'Ant' then
         fullPathToJavaSrc:= FPathToJavaSrc + DirectorySeparator+ 'Controls.java'
      else
         fullPathToJavaSrc:= FPathToJavaSrc +  'Controls.java';

      with TJavaParser.Create(fullPathToJavaSrc) do
      try
        FPascalJNIInterfaceCode := GetPascalJNIInterfaceCode(FPathToJavaTemplates + DirectorySeparator + 'ControlsEvents.txt');
      finally
        Free;
      end;

      CreateDirUTF8(FAndroidProjectName+DirectorySeparator+ 'jni');
      CreateDirUTF8(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
      CreateDirUTF8(FAndroidProjectName+DirectorySeparator+'libs');
      CreateDirUTF8(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi');
      CreateDirUTF8(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a');
      CreateDirUTF8(FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'x86');
      CreateDirUTF8(FAndroidProjectName+DirectorySeparator+'obj');
      CreateDirUTF8(FAndroidProjectName+DirectorySeparator+'obj'+DirectorySeparator+'controls');

      if FProjectModel = 'Ant' then
      begin
        if FSupportV4 = 'yes' then  //add android 4.0 support to olds devices ...
           CopyFile(FPathToJavaTemplates+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar',
                  FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar');
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
  Result := AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini'
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

  FModuleType:= projectType; //0:GUI -- 1:NoGUI

  frm:= TFormAndroidProject.Create(nil);

  frm.ShellTreeView1.ShowRoot:= False;
  frm.ShellTreeView1.Root:= FAndroidProjectName; {seleceted project}

  frm.PathToJavaTemplates:= FPathToJavaTemplates;
  frm.AndroidProjectName:= FAndroidProjectName;

  frm.MainActivity:= FMainActivity;
  frm.MinApi:= FMinApi;
  frm.TargetApi:= FTargetApi;

  frm.ProjectModel:= FProjectModel; //'Ant'  or 'Eclipse'

  if frm.ShowModal = mrOK then
  begin
    FSyntaxMode:= frm.SyntaxMode;

    FPathToJavaClass:= frm.PathToJavaClass;

    FPathToJNIFolder:= FAndroidProjectName;  //+DirectorySeparator+ 'jni';  //GetPathToJNIFolder(FPathToJavaClass);

    AndroidFileDescriptor.PathToJNIFolder:= FAndroidProjectName;//FPathToJNIFolder;
    AndroidFileDescriptor.ModuleType:= FModuleType;
    AndroidFileDescriptor.SyntaxMode:= FSyntaxMode;

    FJavaClassName:= frm.JavaClassName;
    FPathToClassName:= frm.PathToClassName;

    FPascalJNIInterfaceCode:= frm.PascalJNIInterfaceCode;

    FFullPackageName:= frm.FullPackageName;
    FFullJavaSrcPath:= frm.FullJavaSrcPath;


    try
      MkDir(FAndroidProjectName+ DirectorySeparator + 'jni');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'jni');

      MkDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'jni'+DirectorySeparator+'build-modes');

      MkDir(FAndroidProjectName+ DirectorySeparator + 'libs');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'libs');

      if FSupportV4 = 'yes' then  //add android 4.0 support to olds devices ...
            CopyFile(FPathToJavaTemplates+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar',
                 FAndroidProjectName+DirectorySeparator+'libs'+DirectorySeparator+'android-support-v4.jar');

      MkDir(FAndroidProjectName+ DirectorySeparator + 'obj');
      ChDir(FAndroidProjectName+DirectorySeparator+ 'obj');

      MkDir(FPathToJNIFolder+ DirectorySeparator + 'obj'+DirectorySeparator+LowerCase(FJavaClassName));
      ChDir(FPathToJNIFolder+DirectorySeparator+ 'obj'+DirectorySeparator+FJavaClassName);

      MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+'x86');
      ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+'x86');

      MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi');
      ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+'armeabi');

      MkDir(FPathToJNIFolder+ DirectorySeparator + 'libs'+DirectorySeparator+'armeabi-v7a');
      ChDir(FPathToJNIFolder+DirectorySeparator+ 'libs'+DirectorySeparator+'armeabi-v7a');

      Result := True;
    except
      on e: Exception do
        MessageDlg('Error',e.Message,mtError,[mbOK],0);
    end;
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
  Result := 'JNI Android Module [Lamw NoGUI]'; //fix thanks to Stephano!
end;

function TAndroidProjectDescriptor.GetLocalizedDescription: string;
begin
  Result := 'A [NoGUI] JNI Android loadable module (.so)'+ LineEnding +
            'using DataModule (NO Form Designer/Android Components Bridges!).'+ LineEnding +
            'The project and library file is maintained by Lazarus [Lamw].'
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

function TAndroidProjectDescriptor.GetWorkSpaceFromForm(projectType: integer): boolean;
var
  frm: TFormWorkspace;
  projName: string;
  strList: TStringList;
  i: integer;

  linuxDirSeparator: string;
  linuxPathToJavaJDK: string;
  linuxPathToAndroidSdk: string;

  linuxAndroidProjectName: string;
  tempStr: string;

  linuxPathToAdbBin: string;
  linuxPathToAntBin: string;

  dummy: string;
begin
  Result:= False;
  FModuleType:= projectType; //0:GUI  1:noGUI
  strList:= nil;
  frm:= TFormWorkspace.Create(nil);
  try
    frm.LoadSettings(SettingsFilename);

    if projectType = 1 then //No GUI
    begin
      frm.Color:= clWhite;
      frm.LabelModuleType.Caption:= 'Project Type: NoGUI';
    end;

    if frm.ShowModal = mrOK then
    begin
      frm.SaveSettings(SettingsFilename);
      strList:= TStringList.Create;

      FInstructionSet:= frm.InstructionSet;{ ex. ArmV6}
      FFPUSet:= frm.FPUSet; {ex. Soft}

      FAndroidProjectName:= frm.AndroidProjectName;    //warning: full project name = path + name !
      FPathToJavaSrc:= FAndroidProjectName+DirectorySeparator+ 'src';

      FPathToJavaTemplates:= frm.PathToJavaTemplates;
      FPathToJavaJDK:= frm.PathToJavaJDK;
      FPathToAndroidSDK:= frm.PathToAndroidSDK;
      FPathToAndroidNDK:= frm.PathToAndroidNDK;
      FPrebuildOSys:= frm.PrebuildOSys;

      FNDK:= frm.NDK;
      FAndroidPlatform:= frm.AndroidPlatform;
      FPathToAntBin:= frm.PathToAntBin;

      FMinApi:= frm.MinApi;
      FTargetApi:= frm.TargetApi;
      FSupportV4:= frm.SupportV4;

      FMainActivity:= frm.MainActivity;

      if  frm.TouchtestEnabled = 'True' then
         FTouchtestEnabled:= '-Dtouchtest.enabled=true'
      else
         FTouchtestEnabled:='';

      FAntBuildMode:= frm.AntBuildMode;

      FProjectModel:= frm.ProjectModel; //Eclipse Project or Ant Project

      strList.StrictDelimiter:= True;
      strList.Delimiter:= DirectorySeparator;
      strList.DelimitedText:= TrimChar(FAndroidProjectName, DirectorySeparator);
      projName:= strList.Strings[strList.Count-1]; //ex. AppTest1

      FAntPackageName:= frm.AntPackageName;

      try
        if  FProjectModel = 'Ant' then
        begin
          FAntPackageName:= frm.AntPackageName;   //ex.: org.lazarus
          strList.Clear;
          strList.StrictDelimiter:= True;
          strList.Delimiter:= '.';
          strList.DelimitedText:= FAntPackageName+'.'+LowerCase(projName);
          if strList.Count < 3 then strList.DelimitedText:= 'org.'+FAntPackageName+'.'+LowerCase(projName);

          //MkDir(FAndroidProjectName);
          ChDir(FAndroidProjectName);

          MkDir(FAndroidProjectName+ DirectorySeparator + 'src');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'src');

          FPathToJavaSrc:= FAndroidProjectName+DirectorySeparator+ 'src';
          for i:= 0 to strList.Count -1 do
          begin
             FPathToJavaSrc:= FPathToJavaSrc + DirectorySeparator + strList.Strings[i];
             MkDir(FPathToJavaSrc);
             ChDir(FPathToJavaSrc);
          end;

          MkDir(FAndroidProjectName+ DirectorySeparator + 'res');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'res');

          MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi');
          CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+'ic_launcher.png',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+'ic_launcher.png');

          MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi');
          CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-ldpi'+DirectorySeparator+'ic_launcher.png',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-ldpi'+DirectorySeparator+'ic_launcher.png');

          MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi');
          CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-mdpi'+DirectorySeparator+'ic_launcher.png',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-mdpi'+DirectorySeparator+'ic_launcher.png');

          MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi');
          CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-xhdpi'+DirectorySeparator+'ic_launcher.png',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xhdpi'+DirectorySeparator+'ic_launcher.png');

          MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi');
          CopyFile(FPathToJavaTemplates+DirectorySeparator+'drawable-xxhdpi'+DirectorySeparator+'ic_launcher.png',
                   FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'drawable-xxhdpi'+DirectorySeparator+'ic_launcher.png');

          MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values');

          strList.Clear;
          strList.Add('<?xml version="1.0" encoding="utf-8"?>');
          strList.Add('<resources>');
          strList.Add('   <string name="app_name">'+projName+'</string>');
          strList.Add('   <string name="hello_world">Hello world!</string>');
          strList.Add('</resources>');
          strList.SaveToFile(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'strings.xml');

          CopyFile(FPathToJavaTemplates+DirectorySeparator+'values'+DirectorySeparator+'styles.xml',
                       FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values'+DirectorySeparator+'styles.xml');


          MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v11');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v11');

          CopyFile(FPathToJavaTemplates+DirectorySeparator+'values-v11'+DirectorySeparator+'styles.xml',
                       FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v11'+DirectorySeparator+'styles.xml');


          MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14');
          CopyFile(FPathToJavaTemplates+DirectorySeparator+'values-v14'+DirectorySeparator+'styles.xml',
                       FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'values-v14'+DirectorySeparator+'styles.xml');


          MkDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout');
          CopyFile(FPathToJavaTemplates+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml',
                       FAndroidProjectName+DirectorySeparator+ 'res'+DirectorySeparator+'layout'+DirectorySeparator+'activity_app.xml');

          MkDir(FAndroidProjectName+ DirectorySeparator + 'assets');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'assets');

          MkDir(FAndroidProjectName+ DirectorySeparator + 'bin');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'bin');

          MkDir(FAndroidProjectName+ DirectorySeparator + 'gen');
          ChDir(FAndroidProjectName+DirectorySeparator+ 'gen');

          if FModuleType = 0 then     //Android Bridges Controls...
          begin
            if not FileExistsUTF8(FPathToJavaSrc+DirectorySeparator+'App.java') then
            begin
               strList.Clear;    //dummy App.java - will be replaced with simonsayz's "App.java" template!
               strList.Add('package '+FAntPackageName+'.'+LowerCase(projName)+';');
               strList.Add('public class App extends Activity {');
               strList.Add('     //dummy app');
               strList.Add('}');
               strList.SaveToFile(FPathToJavaSrc+DirectorySeparator+'App.java');
            end;
          end;

          if FModuleType = 1 then     //Not Android Bridges  Controls... [not GUI]
          begin
             if not FileExistsUTF8(FPathToJavaSrc+DirectorySeparator+'App.java') then
             begin
               strList.Clear;
               strList.Add('package '+FAntPackageName+'.'+LowerCase(projName)+';');
               strList.Add('');
               strList.Add('import android.os.Bundle;');
               strList.Add('import android.app.Activity;');
               strList.Add('import android.widget.Toast;');
               strList.Add('');
               strList.Add('public class App extends Activity {');
               strList.Add('  ');

               strList.Add('   j'+projName+' m'+projName+';  //just for demo...');
               strList.Add('  ');
               strList.Add('   @Override');
               strList.Add('   protected void onCreate(Bundle savedInstanceState) {');
               strList.Add('       super.onCreate(savedInstanceState);');
               strList.Add('       setContentView(R.layout.activity_app);');
               strList.Add('');

               strList.Add('       m'+projName+' = new j'+projName+'+(); //just for demo...');
               strList.Add('');
               strList.Add('       int sum = m'+projName+'.getSum(2,3); //just for demo...');
               strList.Add('');
               strList.Add('       String mens = m'+projName+'.getString(1); //just for demo...');
               strList.Add('');
               strList.Add('   }');
               strList.Add('}');
               strList.SaveToFile(FPathToJavaSrc+DirectorySeparator+'App.java');

               strList.Clear;
               strList.Add('package '+FAntPackageName+'.'+LowerCase(projName)+';');
               strList.Add('');
               strList.Add('public class j'+projName+' { //just for demo...');
               strList.Add('');
  	           strList.Add('  public native String getString(int flag);');
  	           strList.Add('  public native int getSum(int x, int y);');
               strList.Add('');
               strList.Add('  static {');
         	     strList.Add('	  try {');
       	       strList.Add('	      System.loadLibrary("j'+LowerCase(projName)+'");');
  	           strList.Add('	  } catch(UnsatisfiedLinkError ule) {');
   	           strList.Add('	      ule.printStackTrace();');
   	           strList.Add('	  }');
               strList.Add('  }');
               strList.Add('');
               strList.Add('}');
               strList.SaveToFile(FPathToJavaSrc+DirectorySeparator+'j'+projName+'.java');
             end;

             strList.Clear;

             if not FileExistsUTF8(FAndroidProjectName+DirectorySeparator+'AndroidManifest.xml') then
             begin
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

             strList.Clear;
             strList.Add(FAntPackageName+'.'+LowerCase(projName));
             strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'packagename.txt');

          end;
        end; //just Ant project

        strList.Clear;

        strList.Add('set Path=%PATH%;'+FPathToAntBin); //<--- thanks to andersonscinfo !  [set path=%path%;C:\and32\ant\bin]
        strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
        strList.Add('cd '+FAndroidProjectName);
        strList.Add('ant -Dtouchtest.enabled=true debug');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-debug.bat'); //build Apk using "Ant"

        strList.Clear;
        strList.Add('set Path=%PATH%;'+FPathToAntBin); //<--- thanks to andersonscinfo !
        strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
        strList.Add('cd '+FAndroidProjectName);
        strList.Add('ant clean release');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build-release.bat'); //build Apk using "Ant"

            //*.bat utils...
        MkDir(FAndroidProjectName+ DirectorySeparator + 'utils');
        ChDir(FAndroidProjectName+DirectorySeparator+ 'utils');

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
        strList.Add('cmd /k create_avd_default.bat');
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
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'uninstall.bat');

        strList.Clear;
        strList.Add('cd '+FAndroidProjectName+DirectorySeparator+'bin');
        strList.Add(FPathToAndroidSDK+DirectorySeparator+'platform-tools'+
                   DirectorySeparator+'adb logcat');
        strList.Add('cd ..');
        strList.Add('pause');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'logcat.bat');

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
        strList.Add('<property name="target"  value="android-'+Trim(FTargetApi)+'"/>');
        strList.Add('<property file="ant.properties"/>');
        strList.Add('<fail message="sdk.dir is missing." unless="sdk.dir"/>');
        strList.Add('<import file="${sdk.dir}/tools/ant/build.xml"/>');
        strList.Add('</project>');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'build.xml');

        strList.Clear;
        strList.Add('Tutorial: How to get your Android Application [Apk] using "Ant":');
        strList.Add('');
        strList.Add('1. Double click "build-debug.bat  [.sh]" to build Apk');
        strList.Add('');
        strList.Add('2. If Android Virtual Device[AVD]/Emulator [or real device] is running then:');
        strList.Add('   2.1 double click "install.bat" to install the Apk on the Emulator [or real device]');
        strList.Add('   2.2 look for the App "'+projName+'" in the Emulator [or real device] and click it!');
        strList.Add('');
        strList.Add('3. If AVD/Emulator is NOT running:');
        strList.Add('   3.1 If AVD/Emulator NOT exist:');
        strList.Add('        3.1.1 double click "paused_create_avd_default.bat" to create the AVD ['+DirectorySeparator+'utils folder]');
        strList.Add('   3.2 double click "launch_avd_default.bat" to launch the Emulator ['+DirectorySeparator+'utils  folder]');
        strList.Add('   3.3 look for the App "'+projName+'" in the Emulator and click it!');
        strList.Add('');
        strList.Add('4. Log/Debug');
        strList.Add('   4.1 double click "logcat*.bat" to read logs and bugs! ['+DirectorySeparator+'utils folder]');
        strList.Add('');
        strList.Add('5. Uninstall Apk');
        strList.Add('   5.1 double click "uninstall.bat" to remove Apk from the Emulator [or real device]!');
        strList.Add('');
        strList.Add('6. To find your Apk look for the "'+projName+'-'+FAntBuildMode+'.apk" in '+DirectorySeparator+'bin folder!');
        strList.Add('');
        strList.Add('7. Android Asset Packaging Tool: to know which files were packed in "'+projName+'-'+FAntBuildMode+'.apk"');
        strList.Add('   7.1 double click "aapt.bat" ['+DirectorySeparator+'utils folder]' );
        strList.Add('');
        strList.Add('8. To see all available Android targets in your system ['+DirectorySeparator+'utils folder]');
        strList.Add('   8.1 double click "paused_list_target.bat" ');
        strList.Add('');
        strList.Add('9. Hint 1: you can edit "*.bat" to extend/modify some command or to fix some incorrect info/path!');
        strList.Add('');
        strList.Add('10.Hint 2: you can edit "build.xml" to set another Android target. ex. "android-18" or "android-19" etc.');
        strList.Add('   WARNING: Yes, if after run  "build.*" the folder "...\bin" is still empty then try another target!' );
        strList.Add('   WARNING: If you changed the target in "build.xml" change it in "AndroidManifest.xml" too!' );
        strList.Add('');
        strList.Add('11.WARNING: After a new [Lazarus IDE]-> "run->build" do not forget to run again: "build.bat" and "install.bat" !');
        strList.Add('');
        strList.Add('12. Linux users: use "build.sh" , "install.sh" , "uninstall.sh" and "logcat.sh" [thanks to Stephano!]');
        strList.Add('    WARNING: All demos Apps was generate on my windows system! So, please,  edit its to correct paths...!');
        strList.Add('');
        strList.Add('13. WARNING, before to execute "build-release.bat [.sh]"  you need execute "release.keystore.bat [.sh]"!');
        strList.Add('    Please, read "readme-keytool-input.txt!"');
        strList.Add('');
        strList.Add('14. Please, for more info, look for "How to use the Demos" in "Laz Android Module Wizard" readme.txt!!');

        strList.Add('');
        strList.Add('....  Thank you!');
        strList.Add('');
        strList.Add('....  by jmpessoa_hotmail_com');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'readme.txt');

        dummy:= LowerCase(projName);
        strList.Clear;
        strList.Add('key.store='+dummy+'-release.keystore');
        strList.Add('key.alias='+dummy+'aliaskey');
        strList.Add('key.store.password='+dummy+'passw');
        strList.Add('key.alias.password='+dummy+'passw');
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
        strList.Add('cd '+FAndroidProjectName);
        strList.Add('keytool -genkey -v -keystore '+projName+'-release.keystore -alias '+dummy+'aliaskey -keyalg RSA -keysize 2048 -validity 10000 < '+
                    FAndroidProjectName+DirectorySeparator+'keytool_input.txt');
        strList.SaveToFile(FAndroidProjectName+DirectorySeparator+'release-keystore.bat');

        strList.Clear;
        strList.Add('set JAVA_HOME='+FPathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
        strList.Add('cd '+FAndroidProjectName);
        strList.Add('jarsigner -verify -verbose -certs '+FAndroidProjectName+DirectorySeparator+'bin'+DirectorySeparator+projName+'-release.apk');
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

        linuxDirSeparator:=  DirectorySeparator;    //  C:\adt32\eclipse\workspace\AppTest1
        linuxPathToJavaJDK:=  FPathToJavaJDK;       //  C:\adt32\sdk
        linuxAndroidProjectName:= FAndroidProjectName;
        linuxPathToAntBin:= FPathToAntBin;
        linuxPathToAndroidSdk:= FPathToAndroidSDK;

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
        {$ENDIF}

        //linux build Apk using "Ant"  ---- Thanks to Stephano!
        strList.Clear;
        if FPathToAntBin <> '' then //PATH=$PATH:/data/myscripts
          strList.Add('export PATH='+linuxPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH

        strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
        strList.Add('cd '+linuxAndroidProjectName);
        strList.Add('ant -Dtouchtest.enabled=true debug');
        strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'build-debug.sh');

        strList.Clear;
        if FPathToAntBin <> '' then
           strList.Add('export PATH='+linuxPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH

        strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
        strList.Add('cd '+linuxAndroidProjectName);
        strList.Add('ant clean release');
        strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'build-release.sh');

        linuxPathToAdbBin:= linuxPathToAndroidSdk+linuxDirSeparator+'platform-tools';

        //linux install - thanks to Stephano!
        strList.Clear;
        strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+FAntPackageName+'.'+LowerCase(projName));

        //strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb install -r '+linuxDirSeparator+'bin'+linuxDirSeparator+projName+'-'+FAntBuildMode+'.apk');
        //fix/sugestion by OsvaldoTCF - clear slash from /bin
        strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb install -r bin'+linuxDirSeparator+projName+'-'+FAntBuildMode+'.apk');

        strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat');
        strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'install.sh');

        //linux uninstall  - thanks to Stephano!
        strList.Clear;
        strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+FAntPackageName+'.'+LowerCase(projName));
        strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'uninstall.sh');

        //linux logcat  - thanks to Stephano!
        strList.Clear;
        strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat');
        strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'logcat.sh');

        strList.Clear;
        strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
        strList.Add('cd '+linuxAndroidProjectName);
        strList.Add('keytool -genkey -v -keystore '+projName+'-release.keystore -alias '+dummy+'aliaskey -keyalg RSA -keysize 2048 -validity 10000 < '+
                     linuxAndroidProjectName+linuxDirSeparator+dummy+'keytool_input.txt');
        strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'release-keystore.sh');

        strList.Clear;
        strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
        strList.Add('cd '+linuxAndroidProjectName);
        strList.Add('jarsigner -verify -verbose -certs '+linuxAndroidProjectName+linuxDirSeparator+'bin'+linuxDirSeparator+projName+'-release.apk');
        strList.SaveToFile(linuxAndroidProjectName+linuxDirSeparator+'jarsigner-verify.sh');

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


function TAndroidProjectDescriptor.DoInitDescriptor: TModalResult;
begin
   if GetWorkSpaceFromForm(1) then //1: noGUI project
   begin
      if TryNewJNIAndroidInterfaceCode(1) then //1: noGUI project
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

  customOptions_x86: string;
  customOptions_default: string;

  customOptions_armV6: string;

  customOptions_armV7a: string;

  PathToNdkPlatformsArm: string;
  PathToNdkPlatformsX86: string;

  pathToNdkToolchainsX86: string;
  pathToNdkToolchainsArm: string;

   //by Stephano
  pathToNdkToolchainsBinX86: string;
  pathToNdkToolchainsBinArm: string;

  osys: string;      {windows or linux-x86 or linux-x86_64}
begin

  inherited InitProject(AProject);

  sourceList:= TStringList.Create;

  projName:= LowerCase(FJavaClassName) + '.lpr';

  projDir := FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator;

  if FModuleType = 0 then
  begin
    AProject.CustomData.Values['LAMW'] := 'GUI';
    AProject.ProjectInfoFile := projDir + ChangeFileExt(projName, '.lpi');
    MainFile := AProject.CreateProjectFile(projDir + projName);
  end
  else
  begin
    AProject.CustomData.Values['LAMW'] := 'NoGUI';
    MainFile := AProject.CreateProjectFile(projName);
  end;

  MainFile.IsPartOfProject := True;
  AProject.AddFile(MainFile, False);
  AProject.MainFileID := 0;

  if FModuleType = 0 then
    AProject.AddPackageDependency('tfpandroidbridge_pack'); //GUI controls

  sourceList.Add('{hint: save all files to location: ' + projDir + ' }');
  sourceList.Add('library '+ LowerCase(FJavaClassName) +'; '+ ' //[by LazAndroidWizard: '+DateTimeToStr(Now)+']');
  sourceList.Add('');
  sourceList.Add('{$mode delphi}');
  sourceList.Add('');
  sourceList.Add('uses');
  if FModuleType = 0 then  //GUI controls
  begin
    sourceList.Add('  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls,');
    sourceList.Add('  Laz_And_Controls_Events;');
    sourceList.Add('');
  end
  else //generic module :  Not Android Bridges Controls
  begin
    sourceList.Add('  Classes, SysUtils, CustApp, jni;');
    sourceList.Add('');
    sourceList.Add('type');
    sourceList.Add('');
    sourceList.Add('  TNoGUIApp = class(TCustomApplication)');
    sourceList.Add('  public');
    sourceList.Add('     jClassName: string;');
    sourceList.Add('     jAppName: string;');
    sourceList.Add('     procedure CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('     constructor Create(TheOwner: TComponent); override;');
    sourceList.Add('     destructor Destroy; override;');
    sourceList.Add('  end;');
    sourceList.Add('');
    sourceList.Add('procedure TNoGUIApp.CreateForm(InstanceClass: TComponentClass; out Reference);');
    sourceList.Add('var');
    sourceList.Add('  Instance: TComponent;');
    sourceList.Add('begin');
    sourceList.Add('  Instance := TComponent(InstanceClass.NewInstance);');
    sourceList.Add('  TComponent(Reference):= Instance;');
    sourceList.Add('  Instance.Create(Self);');
    sourceList.Add('end;');
    sourceList.Add('');
    sourceList.Add('constructor TNoGUIApp.Create(TheOwner: TComponent);');
    sourceList.Add('begin');
    sourceList.Add('  inherited Create(TheOwner);');
    sourceList.Add('  StopOnException:=True;');
    sourceList.Add('end;');
    sourceList.Add('');
    sourceList.Add('destructor TNoGUIApp.Destroy;');
    sourceList.Add('begin');
    sourceList.Add('  inherited Destroy;');
    sourceList.Add('end;');
    sourceList.Add('');
    sourceList.Add('var');
    sourceList.Add('  gNoGUIApp: TNoGUIApp;');
    sourceList.Add('  gNoGUIjAppName: string;');
    sourceList.Add('  gNoGUIAppjClassName: string;');

    sourceList.Add('');
  end;

  sourceList.Add(Trim(FPascalJNIInterfaceCode));  {from form...}

  sourceList.Add('');
  sourceList.Add('begin');
  if FModuleType = 0 then  //Android Bridges controls...
  begin
    sourceList.Add('  gApp:= jApp.Create(nil);');
    sourceList.Add('  gApp.Title:= ''JNI Android Bridges Library'';');
    sourceList.Add('  gjAppName:= '''+GetAppName(FPathToClassName)+''';');
    sourceList.Add('  gjClassName:= '''+FPathToClassName+''';');
    sourceList.Add('  gApp.AppName:=gjAppName;');
    sourceList.Add('  gApp.ClassName:=gjClassName;');
    sourceList.Add('  gApp.Initialize;');
    sourceList.Add('  gApp.CreateForm(TAndroidModule1, AndroidModule1);');
  end
  else
  begin
     sourceList.Add('  gNoGUIApp:= TNoGUIApp.Create(nil);');
     sourceList.Add('  gNoGUIApp.Title:= ''My Android Pure Library'';');
     sourceList.Add('  gNoGUIjAppName:= '''+GetAppName(FPathToClassName)+''';');
     sourceList.Add('  gNoGUIAppjClassName:= '''+FPathToClassName+''';');

     sourceList.Add('  gNoGUIApp.jAppName:=gNoGUIjAppName;');
     sourceList.Add('  gNoGUIApp.jClassName:=gNoGUIAppjClassName;');

     sourceList.Add('  gNoGUIApp.Initialize;');
     sourceList.Add('  gNoGUIApp.CreateForm(TNoGUIAndroidModule1, NoGUIAndroidModule1);');
  end;

  sourceList.Add('end.');

  AProject.MainFile.SetSourceText(sourceList.Text, True);

  AProject.Flags := AProject.Flags - [pfMainUnitHasCreateFormStatements,
                                      pfMainUnitHasTitleStatement,
                                      pfLRSFilesInOutputDirectory];
  AProject.UseManifest:= False;
  AProject.UseAppBundle:= False;

  if (Pos('\', FPathToAndroidNDK) > 0) or (Pos(':', FPathToAndroidNDK) > 0) then
     osys:= 'windows'
  else if FPrebuildOSYS='linux-x86_64' then osys:= 'linux-x86_64'
  else osys:= 'linux-x86';

  {Set compiler options for Android requirements}

  PathToNdkPlatformsArm:= FPathToAndroidNDK+DirectorySeparator+'platforms'+DirectorySeparator+
                                                FAndroidPlatform +DirectorySeparator+'arch-arm'+DirectorySeparator+
                                                'usr'+DirectorySeparator+'lib';

  if FNDK = '7' then
      pathToNdkToolchainsArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.4.3';
  if (FNDK = '9') or (FNDK = '10') then
      pathToNdkToolchainsArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'arm-linux-androideabi'+DirectorySeparator+'4.6';

  if FNDK = '7' then
      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.4.3'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';
  if (FNDK = '9') or (FNDK = '10') then
      pathToNdkToolchainsBinArm:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'arm-linux-androideabi-4.6'+DirectorySeparator+
                                                 'prebuilt'+DirectorySeparator+osys+DirectorySeparator+
                                                 'bin';

  libraries_arm:= PathToNdkPlatformsArm+';'+pathToNdkToolchainsArm;

  PathToNdkPlatformsX86:= FPathToAndroidNDK+DirectorySeparator+'platforms'+DirectorySeparator+
                                             FAndroidPlatform+DirectorySeparator+'arch-x86'+DirectorySeparator+
                                             'usr'+DirectorySeparator+'lib';
  if FNdk = '7' then
      pathToNdkToolchainsX86:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+
                                                 'gcc'+DirectorySeparator+'i686-android-linux'+DirectorySeparator+'4.4.3';
  if (FNDK = '9') or (FNDK = '10') then
      pathToNdkToolchainsX86:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'lib'+DirectorySeparator+'gcc'+DirectorySeparator+
                                                 'i686-android-linux'+DirectorySeparator+'4.6';

  if FNDK = '7' then
      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'x86-4.4.3'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';
  if (FNDK = '9') or (FNDK = '10') then
      pathToNdkToolchainsBinX86:= FPathToAndroidNDK+DirectorySeparator+'toolchains'+DirectorySeparator+
                                                 'x86-4.6'+DirectorySeparator+'prebuilt'+DirectorySeparator+
                                                 osys+DirectorySeparator+'bin';

  libraries_x86:= PathToNdkPlatformsX86+';'+pathToNdkToolchainsX86;

  if Pos('x86', FInstructionSet) > 0 then
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

  {Verbose}
      //.....................

  auxList:= TStringList.Create;

  auxStr:= 'armeabi';  //ARMv6
  if FInstructionSet = 'ARMv7a' then auxStr:='armeabi-v7a';
  if FInstructionSet = 'x86' then auxStr:='x86';

  if FInstructionSet <> 'x86' then
  begin
     customOptions_default:='-Xd'+' -Cf'+ FFPUSet;
     customOptions_default:= customOptions_default + ' -Cp'+ UpperCase(FInstructionSet); //until laz bug fix for ARMV7A
  end
  else
  begin
     customOptions_default:='-Xd';
  end;

  customOptions_armV6:= '-Xd'+' -Cf'+ FFPUSet+ ' -CpARMV6';  //until laz bug fix for ARMV7A
  customOptions_armV7a:='-Xd'+' -Cf'+ FFPUSet+ ' -CpARMV7A'; //until laz bug fix for ARMV7A
  customOptions_x86:=   '-Xd';

  customOptions_default:=customOptions_default+' -XParm-linux-androideabi-';
  customOptions_armV6:=  customOptions_armV6  +' -XParm-linux-androideabi-';
  customOptions_armV7a:= customOptions_armV7a +' -XParm-linux-androideabi-';
  customOptions_x86:=    customOptions_x86    +' -XPi686-linux-android-';   //fix by jmpessoa

  if FInstructionSet <> 'x86' then
  begin
    customOptions_default:= customOptions_default+' -FD'+pathToNdkToolchainsBinArm;
  end
  else
  begin
    customOptions_default:= customOptions_default+' -FD'+pathToNdkToolchainsBinX86;
  end;

  customOptions_armV6:= customOptions_armV6+' -FD'+pathToNdkToolchainsBinArm;
  customOptions_armV7a:= customOptions_armV7a+' -FD'+pathToNdkToolchainsBinArm;
  customOptions_x86:= customOptions_x86+' -FD'+pathToNdkToolchainsBinX86;

  {$IFDEF WINDOWS}
     //to others :: just to [fix a bug]  lazarus  rev < 46598 .... //thanks to Stephano!
     // ThierryDijoux - change auxStr by value of the correct folder
     customOptions_default:= customOptions_default+' -o..'+DirectorySeparator+'libs'+DirectorySeparator+auxStr       +DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
     customOptions_armV6:=   customOptions_armV6  +' -o..'+DirectorySeparator+'libs'+DirectorySeparator+'armeabi'    +DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
     customOptions_armV7a:=  customOptions_armV7a +' -o..'+DirectorySeparator+'libs'+DirectorySeparator+'armeabi-v7a'+DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
     customOptions_x86:=     customOptions_x86    +' -o..'+DirectorySeparator+'libs'+DirectorySeparator+'x86'        +DirectorySeparator+'lib'+LowerCase(FJavaClassName)+'.so';
  {$ENDIF}

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_x86+'"/>');
  auxList.Add('<TargetCPU Value="i386"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_x86+'"/>');
  //auxList.Add('<TargetProcessor Value=""/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_x86.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV6+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV6"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV6.txt');

  auxList.Clear;
  auxList.Add('<Libraries Value="'+libraries_arm+'"/>');
  auxList.Add('<TargetCPU Value="arm"/>');
  auxList.Add('<CustomOptions Value="'+customOptions_armV7a+'"/>');
  //auxList.Add('<TargetProcessor Value="ARMV7A"/>');  //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'build_armV7a.txt');

  auxList.Clear;
  auxList.Add('How To Get More Builds:');
  auxList.Add('');
  auxList.Add('   :: Warning: Your system [Laz4Android ?] needs to be prepared for the various builds!');
  auxList.Add('');
  auxList.Add('1. Edit Lazarus project file "*.lpi": [use notepad like editor]');
  auxList.Add('');
  auxList.Add('   > Open the "*.lpi" project file');
  auxList.Add('');
  auxList.Add('       -If needed replace the line <Libraries ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <TargetCPU ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <CustomOptions ..... /> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('       -If needed replace the line <TargetProcessor...../> in the "*.lpi" by line from "build_*.txt"');
  auxList.Add('');
  auxList.Add('   > Save the modified "*.lpi" project file ');
  auxList.Add('');
  auxList.Add('2. From Laz4Android IDE');
  auxList.Add('');
  auxList.Add('   >Reopen the Project');
  auxList.Add('');
  auxList.Add('   > Run -> Build');
  auxList.Add('');
  auxList.Add('4. Repeat for others "build_*.txt" if needed...');
  auxList.Add('');

  if FProjectModel = 'Ant' then
    auxList.Add('4. Execute [double click] the "build.bat" file to get the Apk !')
  else
  begin
    auxList.Add('4. From Eclipse IDE:');
    auxList.Add('');
    auxList.Add('   -right click your  project: -> Refresh');
    auxList.Add('');
    auxList.Add('   -right click your  project: -> Run as -> Android Application');
  end;

  auxList.Add('');
  auxList.Add('');
  auxList.Add('');
  auxList.Add('      Thank you!');
  auxList.Add('      By  ___jmpessoa_hotmail.com_____');

  auxList.SaveToFile(FPathToJNIFolder+DirectorySeparator+'jni'+DirectorySeparator+'build-modes'+DirectorySeparator+'readme.txt');

  AProject.LazCompilerOptions.TargetFilename:=
          '..'+DirectorySeparator+'libs'+DirectorySeparator+auxStr+DirectorySeparator+'lib'+LowerCase(FJavaClassName){+'.so'};

  AProject.LazCompilerOptions.UnitOutputDirectory :=
         '..'+DirectorySeparator+'obj'+ DirectorySeparator+LowerCase(FJavaClassName); {-FU}

  {TargetProcessor}

  (* //commented until lazarus fix bug for missing ARMV7A  //again thanks to Stephano!
  if FInstructionSet <> 'x86' then
     AProject.LazCompilerOptions.TargetProcessor:= UpperCase(FInstructionSet); {-Cp}
  *)

  {Others}
  AProject.LazCompilerOptions.CustomOptions:= customOptions_default;

  auxList.Free;
  sourceList.Free;
  Result := mrOK;
end;

function TAndroidProjectDescriptor.CreateStartFiles(AProject: TLazProject): TModalResult;
begin
  if FModuleType = 0 then  //GUI Controls
  begin
    AndroidFileDescriptor.ResourceClass:= TAndroidModule;
  end
  else // =1 -> NoGUI Controls
  begin
    AndroidFileDescriptor.ResourceClass:= TNoGUIAndroidModule;
  end;

  LazarusIDE.DoNewEditorFile(AndroidFileDescriptor, '', '',
                             [nfIsPartOfProject,nfOpenInEditor,nfCreateDefaultSrc]);

  if FModuleType = 0 then  //GUI Controls
  begin
    LazarusIDE.DoSaveProject([]); // TODO: hardcoded "controls"
  end;

  Result := mrOK;
end;

procedure TAndroidProjectDescriptor.ChDir(const Dir: String);
begin
  try
    if DirectoryExists(Dir) then
      System.ChDir(Dir)
    else begin
      if FileExists(Dir) then raise Exception.Create('Path is a file, not directory');
      if not DirectoryExists(Dir) then raise Exception.Create('Directory not exists');
    end;
  except
    on e: Exception do begin
      e.Message := 'Cannot change directory to "' + Dir + '"' + LineEnding + e.Message;
      raise;
    end;
  end;
end;

procedure TAndroidProjectDescriptor.Mkdir(const Dir: String);
begin
  try
    //if FileExists(Dir) then raise Exception.Create('A file of the same name exists');
    if not DirectoryExists(Dir) then //raise Exception.Create('Directory already exists');
       System.MkDir(Dir);
  except
    on e: Exception do begin
      e.Message := 'Cannot create directory "' + Dir + '"' + LineEnding + e.Message;
      raise;
    end;
  end;
end;

{TAndroidFileDescPascalUnitWithResource}

constructor TAndroidFileDescPascalUnitWithResource.Create;
begin
  inherited Create;

  Name:= 'AndroidDataModule';

  if ModuleType = 0 then
    ResourceClass := TAndroidModule
  else
    ResourceClass := TNoGUIAndroidModule;

  UseCreateFormStatements:= True;

end;

function TAndroidFileDescPascalUnitWithResource.GetResourceType: TResourceType;
begin
   Result:= rtRes;
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedName: string;
begin
   Result := 'Android DataModule'
end;

function TAndroidFileDescPascalUnitWithResource.GetLocalizedDescription: string;
begin
   Result := 'Create a new Unit with a DataModule for JNI Android module (.so)';
   //Result:='Create a New AndroidForm [Not LCL AndroidWidgets ToolKit]';
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
   sourceList.Add('{Hint: save all files to location: ' +PathToJNIFolder+DirectorySeparator+'jni }');
   sourceList.Add('unit '+uName+';');
   sourceList.Add('');
   if SyntaxMode = smDelphi then
      sourceList.Add('{$mode delphi}');
   if SyntaxMode = smObjFpc then
     sourceList.Add('{$mode objfpc}{$H+}');
   sourceList.Add('');
   sourceList.Add('interface');
   sourceList.Add('');
   sourceList.Add('uses');
   sourceList.Add('  ' + GetInterfaceUsesSection);
   if ModuleType = 1 then //no GUI
   begin
    sourceList.Add('');
    sourceList.Add('const');
    sourceList.Add('  gNoGUIjClassPath: string='''';');
    sourceList.Add('  gNoGUIjClass: JClass=nil;');
    sourceList.Add('  gNoGUIPDalvikVM: PJavaVM=nil;');
   end;
   sourceList.Add(GetInterfaceSource(Filename, SourceName, ResourceName));
   sourceList.Add('implementation');
   sourceList.Add('');
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
    Result := 'Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget;';

   //Result:='Classes, SysUtils, AndroidWidget;';
end;

function TAndroidFileDescPascalUnitWithResource.GetInterfaceSource(const Filename     : string;
                                                             const SourceName   : string;
                                                           const ResourceName : string): string;
var
  strList: TStringList;
begin
  strList:= TStringList.Create;
  strList.Add('');
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
  strList.Add('  private');
  strList.Add('    { private declarations }');
  strList.Add('  public');
  strList.Add('    { public declarations }');
  strList.Add('  end;');
  strList.Add('');
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

