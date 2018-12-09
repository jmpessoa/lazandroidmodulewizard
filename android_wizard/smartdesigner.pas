unit SmartDesigner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Forms, AndroidWidget, process, math, SourceChanger;

// tk min and max API versions for build.xml
const
  cMinAPI = 10;
  cMaxAPI = 28;
// end tk

type

  { TLamwSmartDesigner }

  TLamwSmartDesigner = class
  private
    FProjFile: TLazProjectFile;
    FPackageName: string;
    FStartModuleVarName: string;
    // all Paths have trailing PathDelim
    FPathToJavaSource: string;
    FPathToAndroidProject: string;

    FPathToAndroidSDK: string;  //Included Path Delimiter!
    FPathToAndroidNDK: string;  //Included Path Delimiter!

    FInstructionSet: string;
    FFPUSet: string;
    FSmallProjName: string;
    FGradleVersion: string;
    FPrebuildOSYS: string;
    FCandidateSdkPlatform: integer;
    FCandidateSdkBuild: string;
    FPathToGradle: string;

    procedure CleanupAllJControlsSource;
    procedure GetAllJControlsFromForms(jControlsList: TStrings);
    function GetEventSignature(const nativeMethod: string): string;
    function GetPackageNameFromAndroidManifest(pathToAndroidManifest: string): string;
    function TryAddJControl(jclassname: string; out nativeAdded: boolean): boolean;
    procedure UpdateProjectLpr(oldModuleName: string; newModuleName: string);
    procedure InitSmartDesignerHelpers;
    procedure UpdateStartModuleVarName;
    procedure UpdateAllJControls(AProject: TLazProject);

    function IsDemoProject: boolean;
    procedure TryChangeDemoProjecPaths;
    procedure TryFindDemoPathsFromReadme(out pathToDemoNDK, pathToDemoSDK: string);

    function IsChipSetDefault(var projectChipSet: string): boolean;
    procedure TryChangeChipSetConfigs(projectChipSet: string);

    function GetTargetFromManifest(): string;
    function GetMaxNdkPlatform(): integer;

    function HasBuildTools(platform: integer; out outBuildTool: string): boolean;
    function GetMaxSdkPlatform(out outBuildTool: string): integer;
    procedure KeepBuildUpdated(targetApi: integer; buildTool: string);

    function GetBuildTool(sdkApi: integer): string;
    function GetPluginVersion(buildTool: string): string;
    function TryGradleCompatibility(plugin: string; gradleVers: string): string;
    function GetGradleVersion(path: string): string;
    function GetGradleVersionFromGradle(path: string): string;

    function GetLprStartModuleVarName: string;
    function TryChangePrebuildOSY(path: string): string;
    function TryChangeTo49x(path: string): string;
    function TryChangeTo49(path: string): string;
    function TryChangeNdkPlatformsApi(path: string; newNdkApi: integer): string;
    function IsSdkToolsAntEnable(path: string): boolean;
    procedure TryChangeDemoProjecAntBuildScripts();

  protected
    function OnProjectOpened(Sender: TObject; AProject: TLazProject): TModalResult;
    function OnProjectSavingAll(Sender: TObject): TModalResult;
  public
    destructor Destroy; override;
    procedure Init;
    procedure Init4Project(AProject: TLazProject);

    // called from Designer
    procedure UpdateJControls(ProjFile: TLazProjectFile; AndroidForm: TAndroidForm);
    procedure UpdateProjectStartModule(const NewName: string);

  end;

  // tk ReplaceChar made public
  function ReplaceChar(const query: string; oldchar, newchar: char): string;
  // end tk
  function IsAllCharNumber(pcString: PChar): Boolean;

var
  LamwSmartDesigner: TLamwSmartDesigner;

implementation

uses
  {$ifdef unix}BaseUnix,{$endif}
  Controls, Dialogs, {SrcEditorIntf,} LazIDEIntf, IDEMsgIntf, IDEExternToolIntf, CodeToolManager, CodeTree,
  CodeCache, {SourceChanger,} LinkScanner, Laz2_DOM, laz2_XMLRead, FileUtil,
  LazFileUtils, LamwSettings, uJavaParser, strutils;

procedure SaveShellScript(script: TStringList; const AFileName: string);
begin
  script.SaveToFile(AFileName);
  {$ifdef UNIX}
  FpChmod(AFileName, &751);
  {$endif}
end;

procedure TryRunProcessChmod(path: string);
var
  proc: TProcess;
begin
  {$ifdef UNIX}
  try
    proc := TProcess.Create(nil);
    proc.Parameters.Add('777');
    proc.Parameters.Add('-R');
    Proc.Parameters.Add(path);
    proc.Options:= proc.Options + [poWaitOnExit,poUsePipes];
    proc.Executable:='chmod';
    proc.Execute;
  finally
    Proc.Free;
  end;
  ShowMessage('Warning: Project files permissions changed to "R" and "W" !'+
                   sLineBreak+
                   'Maybe, You will need close and re-open the Lazurus IDE'+
                   sLineBreak+ 'to build/run your modified project [sorry...]'+
                   sLineBreak+ '[hint: when prompt to save project, choice "yes"]');
  {$endif}
end;

function ReplaceChar(const query: string; oldchar, newchar: char): string;
var
  i: Integer;
begin
  Result := query;
  for i := 1 to Length(Result) do
    if Result[i] = oldchar then Result[i] := newchar;
end;

function IsAllCharNumber(pcString: PChar): Boolean;
begin
  Result := False;
  while pcString^ <> #0 do // 0 indicates the end of a PChar string
  begin
    if not (pcString^ in ['0'..'9']) then Exit;
    Inc(pcString);
  end;
  Result := True;
end;

function GetPathToSDKFromBuildXML(fullPathToBuildXML: string): string;
var
  i, pk: integer;
  strAux: string;
  packList: TStringList;
begin
  Result:= '';
  if FileExists(fullPathToBuildXML) then
  begin
    packList:= TStringList.Create;
    packList.LoadFromFile(fullPathToBuildXML);
    pk:= Pos('location="',packList.Text);  //ex. location="C:\adt32\sdk"
    strAux:= Copy(packList.Text, pk+Length('location="'), MaxInt);
    i := PosEx('"', strAux, 2);
    Result:= Trim(Copy(strAux, 1, i-1));
    packList.Free;
  end;
end;


{ TLamwSmartDesigner }

function TLamwSmartDesigner.OnProjectOpened(Sender: TObject;
 AProject: TLazProject): TModalResult;
begin
  Init4Project(AProject);
  Result := mrOK;
end;

function TLamwSmartDesigner.GetPackageNameFromAndroidManifest(pathToAndroidManifest: string): string;
var
  str: string;
  xml: TXMLDocument;
begin
  str := pathToAndroidManifest + 'AndroidManifest.xml';
  if not FileExists(str) then Exit('');
  ReadXMLFile(xml, str);
  try
    Result := xml.DocumentElement.AttribStrings['package'];
  finally
    xml.Free
  end;
end;

function TLamwSmartDesigner.GetTargetFromManifest(): string;
var
  ManifestXML: TXMLDocument;
  n: TDOMNode;
begin
  Result := '';
  if not FileExists(FPathToAndroidProject + 'AndroidManifest.xml') then Exit;
  try
    ReadXMLFile(ManifestXML, FPathToAndroidProject + 'AndroidManifest.xml');
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

//C:\adt32\ndk10e\platforms\
function TLamwSmartDesigner.GetMaxNdkPlatform(): integer;
var
  lisDir: TStringList;
  auxStr: string;
  i, intAux: integer;
begin

  Result:= 0;

  lisDir:= TStringList.Create;

  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidNdk)+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= ExtractFileName(lisDir.Strings[i]);
       if auxStr <> '' then
       begin
         auxStr:= Copy(auxStr, LastDelimiter('-', auxStr) + 1, MaxInt);
         if IsAllCharNumber(PChar(auxStr))  then  //skip android-P
         begin
           intAux:= StrToInt(auxStr);
           if Result < intAux then
                Result:= intAux;
         end;
       end;
    end;
  end;
  lisDir.free;
end;

function TLamwSmartDesigner.GetMaxSdkPlatform(out outBuildTool: string): integer;
var
  lisDir: TStringList;
  strApi: string;
  i, intApi: integer;
  tempOutBuildTool: string;
begin

  Result:= 0;
  FCandidateSdkPlatform:= 0;

  lisDir:= TStringList.Create;
  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'platforms', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       strApi:= ExtractFileName(lisDir.Strings[i]);   //android-21
       if strApi <> '' then
       begin
         strApi:= Copy(strApi, LastDelimiter('-', strApi) + 1, MaxInt);
         if IsAllCharNumber(PChar(strApi))  then  //skip android-P
         begin
              intApi:= StrToInt(strApi);
              if FCandidateSdkPlatform < intApi then FCandidateSdkPlatform:= intApi;
              if Result < intApi then
              begin
                if HasBuildTools(intApi, tempOutBuildTool) then
                begin
                   Result:= intApi;
                   outBuildTool:= tempOutBuildTool;  //26.0.2
                end;
              end;
         end;
       end;
    end;
  end;
  lisDir.free;
end;

function TLamwSmartDesigner.HasBuildTools(platform: integer;  out outBuildTool: string): boolean;
var
  lisDir: TStringList;
  numberAsString, auxStr: string;
  i, builderNumber,  savedBuilder: integer;
begin
  Result:= False;
  savedBuilder:= 0;
  lisDir:= TStringList.Create;   //C:\adt32\sdk\build-tools\19.1.0

  FindAllDirectories(lisDir, IncludeTrailingPathDelimiter(FPathToAndroidSDK)+'build-tools', False);

  if lisDir.Count > 0 then
  begin
    for i:=0 to lisDir.Count-1 do
    begin
       auxStr:= ExtractFileName(lisDir.Strings[i]);
       if  auxStr <> '' then
       begin
         if Pos('rc2', auxStr) = 0 then   //escape some alien...
         begin
           numberAsString:= Copy(auxStr, 1 , 2);  //19
           builderNumber:=  StrToInt(numberAsString);

           if savedBuilder < builderNumber then
           begin
             savedBuilder:= builderNumber;
             if builderNumber > platform then FCandidateSdkBuild:= auxStr;
           end;

           if platform = builderNumber then
           begin
             outBuildTool:= auxStr; //19.1.0
             Result:= True;
           end

         end;
       end;
    end;
  end;
  lisDir.free;
end;


function TLamwSmartDesigner.GetBuildTool(sdkApi: integer): string;
var
  tempOutBuildTool: string;
begin
  Result:= '';
  if HasBuildTools(sdkApi, tempOutBuildTool) then
  begin
     Result:= tempOutBuildTool;  //26.0.2
  end;
end;

function TLamwSmartDesigner.GetPluginVersion(buildTool: string): string;
var
  maxBuilderNumber: integer;
  numberAsString: string;
begin
  Result:= '';

  if (buildTool = '') then Exit;

  numberAsString:= StringReplace(buildTool,'.', '', [rfReplaceAll]); //26.0.2
  maxBuilderNumber:= StrToInt(Trim(numberAsString));  //2602

  if (maxBuilderNumber >= 2111) and (maxBuilderNumber < 2112) then
  begin
    Result:= '2.0.0';
  end
  else if (maxBuilderNumber >= 2112) and (maxBuilderNumber < 2302) then
  begin
    Result:= '2.0.0';
  end
  else if (maxBuilderNumber >= 2302) and (maxBuilderNumber < 2500) then
  begin
      Result:= '2.2.0';
  end
  else if (maxBuilderNumber >= 2500) and (maxBuilderNumber < 2602) then   //<<---- good performance !!!
  begin
      Result:= '2.3.3';
      //gradleVer:= '3.3';
  end
  else if (maxBuilderNumber >= 2602) and (maxBuilderNumber < 2700)  then
  begin
      Result:= '3.0.1';
      //gradleVer:= '4.1';
  end
  else if maxBuilderNumber >= 2700  then
  begin
      Result:= '3.0.1';
      //gradleVer:= '4.1';
  end;

end;

function TLamwSmartDesigner.TryGradleCompatibility(plugin: string; gradleVers: string): string;
var
  pluginNumber: integer;
  numberAsString: string;
  tryGradleVer: string;
  tryGradleNumber, len: integer;
  gradleNumber: integer;
begin

  Result:= '';

 {200  < 220 ---  2.1
  220  < 233 ---  2.14.1
  233  < 301 ---  4.1
  301  >     ---  4.1}

  numberAsString:= StringReplace(plugin,'.', '', [rfReplaceAll]); //3.0.1
  pluginNumber:= StrToInt(numberAsString);  //301

  if (pluginNumber >=  200) and (pluginNumber <  220) then
  begin
     tryGradleVer:= '2.10';   //210  -> 2100
  end;

  if (pluginNumber >= 220) and (pluginNumber <  233) then
  begin
    tryGradleVer:= '2.14.1';  //        2141
  end;

  if (pluginNumber >= 233) and (pluginNumber <  301) then
  begin
     tryGradleVer:= '4.1';
  end;

  if pluginNumber >= 301 then
  begin
     tryGradleVer:= '4.1';
  end;

  numberAsString:= StringReplace(tryGradleVer,'.', '', [rfReplaceAll]); //4.1
  len:= Length(numberAsString);
  if len = 2 then numberAsString:= numberAsString + '00'; //4100
  if len = 3 then numberAsString:= numberAsString + '0';
  tryGradleNumber:= StrToInt(numberAsString);

  if gradleVers <> '' then
  begin
    numberAsString:= StringReplace(gradleVers,'.', '', [rfReplaceAll]); //41
    len:= Length(numberAsString);
    if len = 2 then numberAsString:= numberAsString + '00'; //4100
    if len = 3 then numberAsString:= numberAsString + '0';
    gradleNumber:= StrToInt(numberAsString);
    if gradleNumber >= tryGradleNumber then
    begin
      Result:= gradleVers;
    end
    else
    begin
       Result:= '4.1'; //tryGradleVer;
    end;
  end
  else
  begin
    Result:= '4.1';
  end;

end;

//https://community.oracle.com/blogs/schaefa/2005/01/20/how-do-conditional-compilation-java
procedure TLamwSmartDesigner.KeepBuildUpdated(targetApi: integer; buildTool: string);
var
  strList: TStringList;
  i: integer;
  strTargetApi, tempStr, sdkManifestTarqet: string;
  AndroidTheme: string;
  androidPluginStr: string;
  androidPluginNumber: integer;
  pluginVersion: string;
  gradleCompatible: string;
  linuxPathToAndroidSdk: string;
  linuxPathToGradle: string;
  linuxDirSeparator: string;
  buildToolApi: string;

  gradleCompatibleStr: string;
  gradleCompatibleNumber: integer;
  directive, compatVer, designVer, cardVer, recyclerVer, pathToSdk: string;
begin

  strList:= TStringList.Create;
  if FileExists(LamwGlobalSettings.PathToJavaTemplates+'values'+DirectorySeparator +'colors.xml') then
  begin
     strList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'values'+DirectorySeparator +'colors.xml');
     if not FileExists(FPathToAndroidProject +'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml') then
     strList.SaveToFile(FPathToAndroidProject +'res'+DirectorySeparator+'values'+DirectorySeparator+'colors.xml');
  end;

  sdkManifestTarqet:= GetTargetFromManifest();
  if sdkManifestTarqet <> '' then
  begin
       strList.Clear;
       strList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       tempStr:= strList.Text;
       tempStr:= StringReplace(tempStr, 'android:targetSdkVersion="'+sdkManifestTarqet+'"' , 'android:targetSdkVersion="'+IntToStr(targetApi)+'"', [rfReplaceAll,rfIgnoreCase]);
       strList.Text:= tempStr;
       strList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
  end;

  strTargetApi:= IntTostr(targetApi);

  strList.Clear;
  strList.Add('<?xml version="1.0" encoding="UTF-8"?>');
  strList.Add('<project name="'+FSmallProjName+'" default="help">');
  strList.Add('<property name="sdk.dir" location="'+FPathToAndroidSDK+'"/>');
  strList.Add('<property name="target" value="android-'+ strTargetApi+'"/>');
  strList.Add('<property file="ant.properties"/>');
  strList.Add('<fail message="sdk.dir is missing." unless="sdk.dir"/>');
  // tk Generate code to allow conditional compilation in our java sources
  strList.Add('');
  strList.Add('<!-- Tags required to enable conditional compilation in java sources -->');
  strList.Add('<property name="src.dir" location=".'+PathDelim+'src'+PathDelim+AppendPathDelim(ReplaceChar(FPackageName, '.', PathDelim))+'"/>');
  strList.Add('<property name="source.dir" value="${src.dir}/${target}" />');
  strList.Add('<import file="${sdk.dir}/tools/ant/build.xml"/>');

  strList.Add('');
  strList.Add('<!-- API version properties, modify according to your API level -->');
  for i := cMinAPI to cMaxAPI do
  begin
    if i <= targetApi then
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
  strList.SaveToFile(FPathToAndroidProject+'build.xml');

  strList.Clear;
  strList.Add('# This file is automatically generated by Android Tools.');
  strList.Add('# Do not modify this file -- YOUR CHANGES WILL BE ERASED!');
  strList.Add('#');
  strList.Add('# This file must be checked in Version Control Systems.');
  strList.Add('#');
  strList.Add('# To customize properties used by the Ant build system edit');
  strList.Add('# "ant.properties", and override values to adapt the script to your');
  strList.Add('# project structure.');
  strList.Add('#');
  strList.Add('# To enable ProGuard to shrink and obfuscate your code, uncomment this (available properties: sdk.dir, user.home):');
  strList.Add('#proguard.config=${sdk.dir}/tools/proguard/proguard-android.txt:proguard-project.txt');
  strList.Add(' ');
  strList.Add('# Project target.');
  strList.Add('target=android-'+strTargetApi);
  strList.SaveToFile(FPathToAndroidProject+'project.properties');

  strList.Clear;
  {$IFDEF UNIX}
  strList.Add('sdk.dir=' + FPathToAndroidSDK);
  {$ENDIF}

  {$IFDEF WINDOWS}
  tempStr:= ExcludeTrailingPathDelimiter(SetDirSeparators(FPathToAndroidSDK));
  tempStr:= StringReplace(tempStr, '\', '\\', [rfReplaceAll]);
  tempStr:= StringReplace(tempStr, ':', '\:', []);
  strList.Add('sdk.dir=' + tempStr) ;
  {$ENDIF}
  strList.SaveToFile(FPathToAndroidProject+'local.properties');

  //gradle.build
  AndroidTheme:= LazarusIDE.ActiveProject.CustomData.Values['Theme'];

  if targetApi >= 21 then
  begin
    if buildTool <> '' then
    begin

       buildToolApi:= Copy(buildTool,1,2);   //26.0.2  --> 26

       if StrToInt(buildToolApi) >= 25 then
         pluginVersion:= GetPluginVersion(buildTool)
       else
         pluginVersion:= '2.3.3';

       if pluginVersion <> '' then
       begin
         androidPluginStr:= StringReplace(pluginVersion,'.', '', [rfReplaceAll]);
         androidPluginNumber:= StrToInt(Trim(androidPluginStr));  //ex. 3.0.0 --> 300
         gradleCompatible:= TryGradleCompatibility(pluginVersion, FGradleVersion);

         gradleCompatibleStr:= StringReplace(gradleCompatible,'.', '', [rfReplaceAll]);
         gradleCompatibleNumber:= StrToInt(Trim(gradleCompatibleStr));

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
         strList.Add('        classpath ''com.android.tools.build:gradle:'+ pluginVersion+'''');
         strList.Add('    }');
         strList.Add('}');
         strList.Add('apply plugin: ''com.android.application''');
         strList.Add('android {');
         strList.Add('    lintOptions {');
         strList.Add('       abortOnError false');
         strList.Add('    }');

         if Pos('AppCompat', AndroidTheme) > 0 then
         begin
           pathToSdk:= GetPathToSDKFromBuildXML(FPathToAndroidProject+'build.xml');
           if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/appcompat-v7/26.1.0') then
           begin
             buildToolApi:= '26';
             compatVer:= '26.1.0';
           end
           else if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/appcompat-v7/26.0.0-beta1')  then
           begin
             buildToolApi:= '26';
             compatVer:= '26.0.0-beta1';
           end
           else if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/appcompat-v7/26.0.0-alpha1')  then
           begin
             buildToolApi:= '26';
             compatVer:= '26.0.0-alpha1';
           end
           else
           begin
             buildToolApi:= '25';
             compatVer:= '25.3.1';
           end;

           //designVer
           if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/design/26.1.0') then
             designVer:= '26.1.0'
           else if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/design/26.0.0-beta1')  then
             designVer:= '26.0.0-beta1'
           else if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/design/26.0.0-alpha1')  then
             designVer:= '26.0.0-alpha1'
           else
             designVer:= '25.3.1';

           //cardVer
           if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/cardview-v7/26.1.0') then
             cardVer:= '26.1.0'
           else if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/cardview-v7/26.0.0-beta1')  then
             cardVer:= '26.0.0-beta1'
           else if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/cardview-v7/26.0.0-alpha1')  then
             cardVer:= '26.0.0-alpha1'
           else
             cardVer:= '25.3.1';

           //recyclerVer
           if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/cardview-v7/26.1.0') then
             recyclerVer:= '26.1.0'
           else if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/cardview-v7/26.0.0-beta1')  then
             recyclerVer:= '26.0.0-beta1'
           else if DirectoryExists(pathToSdk+'/extras/android/m2repository/com/android/support/cardview-v7/26.0.0-alpha1')  then
             recyclerVer:= '26.0.0-alpha1'
           else
             recyclerVer:= '25.3.1';

           strList.Add('    compileSdkVersion '+ buildToolApi);

           if androidPluginNumber < 300 then
              strList.Add('    buildToolsVersion "26.0.2"'); //buildTool
           //else: each version of the Android Gradle Plugin now has a default version of the build tools

         end
         else
         begin
           strList.Add('    compileSdkVersion '+ buildToolApi);
           if androidPluginNumber < 300 then
              strList.Add('    buildToolsVersion "'+buildTool+'"');
           //else: each version of the Android Gradle Plugin now has a default version of the build tools
         end;

         strList.Add('    defaultConfig {');
         strList.Add('            minSdkVersion 14');

         if targetApi <= StrToInt(buildToolApi) then
            strList.Add('            targetSdkVersion '+IntToStr(targetApi))
         else
            strList.Add('            targetSdkVersion '+buildToolApi);

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
         if Pos('AppCompat', AndroidTheme) > 0 then
         begin   //compile fileTree(dir: 'libs', include: ['*.jar'])

            if androidPluginNumber < 300 then
              directive:='compile'
            else
              directive:='implementation';

            strList.Add('    '+directive+' ''com.android.support:appcompat-v7:'+compatVer+'''');
            strList.Add('    '+directive+' ''com.android.support:design:'+designVer+'''');
            strList.Add('    '+directive+' ''com.android.support:cardview-v7:'+cardVer+'''');
            strList.Add('    '+directive+' ''com.android.support:recyclerview-v7:'+recyclerVer+'''');
            strList.Add('    '+directive+' ''com.google.android.gms:play-services-ads:11.0.4''');

            {
            Extras
            Android Support Repository
            Android Support Library
            C:\adt32\sdk\extras\android\m2repository\com\android\support\appcompat-v7
            C:\adt32\sdk\extras\android\m2repository\com\android\support\design
            C:/adt32/sdk/extras/android/m2repository/com/android/support/design/26.0.0-alpha1/
            C:\adt32\sdk\extras\android\m2repository\com\android\support\cardview-v7
            C:\adt32\sdk\extras\android\m2repository\com\android\support\recyclerview-v7  //25.3.1
            C:\adt32\sdk\extras\google\m2repository\com\google\android\gms\play-services-ads   //11.0.4}

         end;
         strList.Add('}');

         strList.Add(' ');
         strList.Add('task run(type: Exec, dependsOn: '':installDebug'') {');
         strList.Add('	if (System.properties[''os.name''].toLowerCase().contains(''windows'')) {');
         strList.Add('	    commandLine ''cmd'', ''/c'', ''adb'', ''shell'', ''am'', ''start'', ''-n'', "'+FPackageName+'/.App"');
         strList.Add('	} else {');
         strList.Add('	    commandLine ''adb'', ''shell'', ''am'', ''start'', ''-n'', "'+FPackageName+'/.App"');
         strList.Add('	}');
         strList.Add('}');
         strList.Add(' ');
         strList.Add('task wrapper(type: Wrapper) {');
         strList.Add('    gradleVersion = '''+gradleCompatible+'''');
         strList.Add('}');
         strList.Add('//how to use: look for "gradle_readme.txt"');
         strList.SaveToFile(FPathToAndroidProject+'build.gradle');

       end;
    end;

    //gradle build scripts;

    strList.Clear;
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
    if FPathToGradle = '' then
      strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('set GRADLE_HOME='+ FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    strList.Add('gradle clean build --info');
    strList.SaveToFile(FPathToAndroidProject+'gradle-local-build.bat');

    strList.Clear;
    strList.Add('set Path=%PATH%;'+FPathToAndroidSDK+'platform-tools');
    if FPathToGradle = '' then
      strList.Add('set GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('set GRADLE_HOME='+ FPathToGradle);
    strList.Add('set PATH=%PATH%;%GRADLE_HOME%\bin');
    strList.Add('gradle run');
    strList.SaveToFile(FPathToAndroidProject+'gradle-local-run.bat');

    linuxDirSeparator:= DirectorySeparator;
    linuxPathToAndroidSdk:= FPathToAndroidSDK;
    linuxPathToGradle:= FPathToGradle;

    {$IFDEF WINDOWS}
       linuxDirSeparator:= '/';
       tempStr:= FPathToAndroidSDK;
       SplitStr(tempStr, ':');
       linuxPathToAndroidSdk:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

       tempStr:= FPathToGradle;
       SplitStr(tempStr, ':');
       linuxPathToGradle:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);
    {$ENDIF}

    strList.Clear;
    strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');

    if FPathToGradle = '' then
      strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('export GRADLE_HOME='+ linuxPathToGradle);

    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    strList.Add('source ~/.bashrc');
    //strList.Add('.\gradle clean build --info');
    strList.Add('gradle clean build --info');
    SaveShellScript(strList, FPathToAndroidProject+'gradle-local-build.sh');

    strList.Clear;
    strList.Add('export PATH='+linuxPathToAndroidSDK+'platform-tools'+':$PATH');

    if FPathToGradle = '' then
      strList.Add('export GRADLE_HOME=path_to_your_local_gradle')
    else
      strList.Add('export GRADLE_HOME='+ linuxPathToGradle);

    strList.Add('export PATH=$PATH:$GRADLE_HOME/bin');
    strList.Add('source ~/.bashrc');
    //strList.Add('.\gradle run');
    strList.Add('gradle run');
    SaveShellScript(strList, FPathToAndroidProject+'gradle-local-run.sh');

    if not FileExists(FPathToAndroidProject + 'gradle.properties') then
    begin
      strList.Clear;
      strList.SaveToFile(FPathToAndroidProject+'gradle.properties');
    end;

  end;

  strList.Free;
end;

//http://forum.lazarus.freepascal.org/index.php/topic,39535.0.html
//by Jurassic Pork
function TLamwSmartDesigner.GetGradleVersionFromGradle(path: string): string;
var
   Proc: TProcess;
   CharBuffer: array [0..511] of char;
   p, ReadCount: integer;
   strExt, strTemp: string;
begin
    Result:='';
    if path = '' then Exit;
    strExt:= '';
    {$IFDEF WINDOWS}
    strExt:= '.bat';
    {$ENDIF}

    //FillChar(CharBuffer,SizeOf(CharBuffer),#0);
    try
      Proc := TProcess.Create(nil);
      Proc.Options := [poUsePipes];
      //Proc.Options:= Proc.Options + [poWaitOnExit];
      Proc.Parameters.Add('-v');
      Proc.Executable:= path + 'bin' + pathDelim + 'gradle'+strExt;
      Proc.Execute();
      while (Proc.Running) or (Proc.Output.NumBytesAvailable > 0) or
        (Proc.Stderr.NumBytesAvailable > 0) do
      begin
        // read stdout and write to our stdout
        while Proc.Output.NumBytesAvailable > 0 do
        begin
          ReadCount := Min(512, Proc.Output.NumBytesAvailable); //Read up to buffer, not more
          Proc.Output.Read(CharBuffer, ReadCount);
          strTemp:= Copy(CharBuffer, 0, ReadCount);
          if Pos('Gradle', strTemp) > 0 then
          begin
             Result:= Trim(strTemp);
             break;
          end;
        end;
        {
        // read stderr and write to our stderr
        while Proc.Stderr.NumBytesAvailable > 0 do
        begin
          ReadCount := Min(512, Proc.Stderr.NumBytesAvailable); //Read up to buffer, not more
          Proc.Stderr.Read(CharBuffer, ReadCount);
          Lines2.Append(Copy(CharBuffer, 0, ReadCount));
        end;
        }
        application.ProcessMessages;
        //Sleep(200);
      end;
      ExitCode := Proc.ExitStatus;
    finally
      Proc.Free;

      if Result <> '' then
      begin
        p:= Pos(' ', Result);  //Gradle 3.3
        Result:= Copy(Result, p+1, MaxInt); //3.3
        IDEMessagesWindow.AddCustomMessage(mluVerbose, 'Success!! Found Gradle version: ' + Result);
      end
      else
        IDEMessagesWindow.AddCustomMessage(mluVerbose, 'Sorry... Fail to find Gradle version from Gradle path ...');

    end;
end;

function TLamwSmartDesigner.GetGradleVersion(path: string): string;
var
  p: integer;
  strAux: string;
  posLastDelim: integer;
begin
  Result:='';
  if path <> '' then
  begin
     path:= Copy(path,1, Length(path)-1);  //delete last pathDelimiter
     posLastDelim:= LastDelimiter(PathDelim, path);
     strAux:= Copy(path, posLastDelim+1, MaxInt);  //gradle-3.3

     p:= Pos('-', strAux);
     if p > 0 then
     begin
        Result:= Copy(strAux, p+1, MaxInt);  // 3.3
     end;

     if Result = '' then
     begin
       IDEMessagesWindow.AddCustomMessage(mluVerbose, 'Please, wait... trying find Gradle version from Gradle ['+path+']');
       Result:= GetGradleVersionFromGradle(path);
     end;
  end;
end;

procedure TLamwSmartDesigner.Init4Project(AProject: TLazProject);
var
  auxList: TStringList;
  projChipSet,  tempStr: string;
  p,  maxSdkApi: integer;
  outMaxBuildTool: string;
  androidTheme: string;
  isProjectImported: boolean;
  sdkManifestTargetApi, buildTool: string;
  manifestTargetApi: integer;
  queryValue : String;
begin

  if not AProject.CustomData.Contains('LAMW') then
  begin
    if not FileExists(AProject.ProjectInfoFile) then Exit;
    auxList:= TStringList.Create;
    try
      auxList.LoadFromFile(AProject.ProjectInfoFile); //full path to 'controls.lpi';
      if Pos('tfpandroidbridge_pack', auxList.Text) <= 0 then  Exit;
      AProject.CustomData['LAMW']:= 'GUI';
    finally
      auxList.Free;
    end;
  end;

  FProjFile := AProject.MainFile;

  with AProject do
  begin
    if CustomData['LamwVersion'] <> LamwGlobalSettings.Version then
    begin
      Modified := True;
      CustomData['LamwVersion'] := LamwGlobalSettings.Version;
      UpdateAllJControls(AProject);
    end;

    FPathToAndroidProject := ExtractFilePath(AProject.MainFile.Filename);
    FPathToAndroidProject := Copy(FPathToAndroidProject, 1, RPosEX(PathDelim, FPathToAndroidProject, Length(FPathToAndroidProject) - 1));

    tempStr:= Copy(FPathToAndroidProject, 1, Length(FPathToAndroidProject)-1);
    p:= LastDelimiter(PathDelim, tempStr) + 1;
    FSmallProjName:= Copy(tempStr,  p, Length(tempStr));

    FPackageName := CustomData['Package'];
    if FPackageName = '' then
    begin
      FPackageName := GetPackageNameFromAndroidManifest(FPathToAndroidProject);
      CustomData['Package'] := FPackageName;
    end;

    FPathToJavaSource:= FPathToAndroidProject + 'src' + PathDelim
      + AppendPathDelim(ReplaceChar(FPackageName, '.', PathDelim));

    androidTheme:= CustomData['Theme'];

  end;

   FPathToAndroidSDK := LamwGlobalSettings.PathToAndroidSDK; //Included Path Delimiter!
   FPathToAndroidNDK := LamwGlobalSettings.PathToAndroidNDK; //Included Path Delimiter!
   FPrebuildOSYS:= LamwGlobalSettings.PrebuildOSYS;

   //LAMW 0.8
  if  (androidTheme = '') or (Pos('AppCompat', androidTheme) <= 0) then
    LamwGlobalSettings.QueryPaths:= False;  //dont query Path to Gradle

  FPathToGradle:= LamwGlobalSettings.PathToGradle;  //C:\adt32\gradle-3.3\
  LamwGlobalSettings.QueryPaths:= True; // reset to default...

  if FPathToGradle <> '' then
     FGradleVersion:= GetGradleVersion(FPathToGradle);

  isProjectImported:= IsDemoProject();   //demo or imported project,  etc...

  if not DirectoryExists(FPathToAndroidProject + 'lamwdesigner') then
  begin
    if AProject.CustomData['LAMW'] = 'GUI' then InitSmartDesignerHelpers;
  end;

  // try fix/repair project paths [demos, etc..] in "Run" --> "build"  time ...
  if isProjectImported then
  begin
    TryChangeDemoProjecPaths();
    TryChangeDemoProjecAntBuildScripts();
  end
  else
  begin  // add/update custom
    LazarusIDE.ActiveProject.CustomData.Values['NdkPath']:= FPathToAndroidNDK;
    LazarusIDE.ActiveProject.CustomData.Values['SdkPath']:= FPathToAndroidSDK;
  end;

  //Try configure chipset
  FInstructionSet:= LamwGlobalSettings.InstructionSet;
  if FInstructionSet = '0' then
  begin
    FInstructionSet:= 'ARMV6';
    FFPUSet:= 'Soft';
  end
  else if FInstructionSet = '1' then
  begin
    FInstructionSet:= 'ARMV7A';
    FFPUSet:= 'Soft';
  end
  else if FInstructionSet = '2' then
  begin
    FInstructionSet:= 'ARMV7A';
    FFPUSet:= 'VFPV3';
  end
  else if FInstructionSet = '3' then
  begin
    FInstructionSet:= 'x86';
    FFPUSet:= '';
  end
  else if FInstructionSet = '4' then
  begin
    FInstructionSet:= 'Mipsel';
    FFPUSet:= '';
  end;

  if not IsChipSetDefault(projChipSet) then
  begin
    TryChangeChipSetConfigs(projChipSet);
  end;

  //LAMW 0.8
  maxSdkApi:= GetMaxSdkPlatform(outMaxBuildTool);

  if maxSdkApi =  0 then   // try fix "android-0"
  begin
     maxSdkApi:= FCandidateSdkPlatform;
     outMaxBuildTool:= FCandidateSdkBuild;
  end;

  if AProject.CustomData['BuildSystem'] = '' then
  begin
    if IsSdkToolsAntEnable(FPathToAndroidSDK) then
      AProject.CustomData['BuildSystem']:= 'Ant'
    else
      AProject.CustomData['BuildSystem']:= 'Gradle';
  end
  else
  begin
    if AProject.CustomData['BuildSystem'] = 'Ant' then
       if not IsSdkToolsAntEnable(FPathToAndroidSDK) then
           AProject.CustomData['BuildSystem']:= 'Gradle'
  end;

  sdkManifestTargetApi:= GetTargetFromManifest();
  manifestTargetApi:= StrToInt(sdkManifestTargetApi);
  buildTool:=  GetBuildTool(manifestTargetApi);

  if manifestTargetApi < 26 then
  begin
     queryValue:= '26';
     if InputQuery('Warning. Manifest Target Api ['+sdkManifestTargetApi+ '] < 26',
                   '[Suggestion] Change Target API to 26'+sLineBreak+'[minimum required by "Google Play Store"]:', queryValue) then
     begin
       manifestTargetApi:= StrToInt(queryValue);
       if manifestTargetApi < 26 then
       begin
          if not LamwGlobalSettings.KeepManifestTargetApi  then
             buildTool:= '26.0.2'
          else
             buildTool:= GetBuildTool(manifestTargetApi);
       end
       else buildTool:= GetBuildTool(manifestTargetApi);
     end;
  end
  else
  begin
     if not LamwGlobalSettings.KeepManifestTargetApi  then
       buildTool:= outMaxBuildTool
     else
       buildTool:= GetBuildTool(manifestTargetApi);
  end;

  KeepBuildUpdated(manifestTargetApi, buildTool)

end;

function TLamwSmartDesigner.IsSdkToolsAntEnable(path: string): boolean;
begin          //C:\adt32\sdk\tools\ant
  Result:= False;
  if DirectoryExists(path + 'tools' + PathDelim + 'ant') then
  begin
     Result:= True;
  end;
end;

procedure TLamwSmartDesigner.TryChangeChipSetConfigs(projectChipSet: string);
var
  customResult: string;
  libTarget: string;
begin

  customResult:= LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions;

  if Pos('ARMV6', FInstructionSet) > 0 then
  begin
    if Pos('ARMV7A',  projectChipSet) > 0 then //ARMV7A  ---> armv6
    begin
      customResult:= StringReplace(customResult, 'CpARMV7A' , 'CpARMV6', [rfReplaceAll,rfIgnoreCase]);
      customResult:= StringReplace(customResult, 'CfVFPV3', 'CfSoft', [rfReplaceAll,rfIgnoreCase]);
      LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= customResult;

      libTarget:= LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename;
      libTarget:= StringReplace(libTarget, 'armeabi-v7a', 'armeabi', [rfReplaceAll,rfIgnoreCase]);
      LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename:= libTarget;
    end;
  end;

  if Pos('ARMV7A', FInstructionSet) > 0 then
  begin
    if Pos('ARMV6',  projectChipSet ) > 0 then  //armv6  --> ARMV7A
    begin
      customResult:= StringReplace(customResult, 'CpARMV6' , 'CpARMV7A', [rfReplaceAll,rfIgnoreCase]);
      customResult:= StringReplace(customResult, 'CfSoft', 'Cf'+ FFPUSet, [rfReplaceAll,rfIgnoreCase]);
      LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= customResult;

      libTarget:= LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename;
      libTarget:= StringReplace(libTarget, 'armeabi', 'armeabi-v7a', [rfReplaceAll,rfIgnoreCase]);
      LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename:= libTarget;
    end;
  end;

end;

function TLamwSmartDesigner.IsChipSetDefault(var projectChipSet: string): boolean;
var
  projectTarger: string;
begin

  projectTarger:= LazarusIDE.ActiveProject.LazCompilerOptions.TargetFilename;

  if Pos('armeabi-v7a', projectTarger) > 0 then
  begin
     projectChipSet:= 'ARMV7A';
  end
  else if  Pos('armeabi', projectTarger) > 0 then
  begin
     projectChipSet:= 'ARMV6';
  end
  else if  Pos('x86', projectTarger) > 0 then
  begin
     projectChipSet:= 'x86';
  end
  else if  Pos('mips', projectTarger) > 0 then
  begin
     projectChipSet:= 'Mipsel';
  end;

  if LowerCase(FInstructionSet) =  LowerCase(projectChipSet) then
     Result:= True
  else
     Result:= False;
end;

procedure TLamwSmartDesigner.UpdateJControls(ProjFile: TLazProjectFile;
  AndroidForm: TAndroidForm);
var
  jControls: TStringList;
  i: Integer;
  c: TComponent;
begin
  if (ProjFile = nil) or (AndroidForm = nil) then Exit;
  jControls := TStringList.Create;
  jControls.Sorted := True;
  jControls.Duplicates := dupIgnore;
  jControls.Add('jForm');
  for i := 0 to AndroidForm.ComponentCount - 1 do
  begin
    c := AndroidForm.Components[i];
    if c is jControl then
      jControls.Add(c.ClassName)
    else if c.ClassName = 'TFPNoGUIGraphicsBridge' then
      jControls.Add(c.ClassName);
  end;
  jControls.Delimiter := ';';
  ProjFile.CustomData['jControls'] := jControls.DelimitedText;
  jControls.Free;
end;

procedure TLamwSmartDesigner.UpdateProjectStartModule(const NewName: string);
var
  cb: TCodeBuffer;
  IdentList: TStringList;
  OldName: string;
begin
  if not FProjFile.IsPartOfProject then Exit;

  OldName := LazarusIDE.ActiveProject.CustomData['StartModule'];
  if OldName = '' then OldName := 'AndroidModule1';
  if (NewName = '') or (OldName = NewName) then Exit;
  IdentList := TStringList.Create;
  try
    IdentList.Add(OldName);
    IdentList.Add(NewName);
    IdentList.Add('T' + OldName);
    IdentList.Add('T' + NewName);
    with CodeToolBoss do
    begin
      cb := FindFile(LazarusIDE.ActiveProject.MainFile.GetFullFilename);
      InitCurCodeTool(cb);
      SourceChangeCache.MainScanner := CurCodeTool.Scanner;
      CurCodeTool.ReplaceWords(IdentList, True, SourceChangeCache);
    end;
  finally
    IdentList.Free;
  end;
  FStartModuleVarName:= NewName; //LAMW 0.8
  LazarusIDE.ActiveProject.CustomData['StartModule'] := NewName;
end;


{ backup & remove all *.java from /src and all *.native from /lamwdesigner }
procedure TLamwSmartDesigner.CleanupAllJControlsSource;
var
  contentList: TStringList;
  i: integer;
  fileName: string;
begin
  ForceDirectory(FPathToJavaSource+'bak');
  contentList := FindAllFiles(FPathToJavaSource, '*.java', False);
  for i:= 0 to contentList.Count-1 do
  begin         //do backup
    CopyFile(contentList.Strings[i],
          FPathToJavaSource+'bak'+DirectorySeparator+ExtractFileName(contentList.Strings[i])+'.bak');

    fileName:= ExtractFileName(contentList.Strings[i]); //not delete custom java code [support to jActivityLauncher]
    if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator + fileName) then
      DeleteFile(contentList.Strings[i]);

  end;
  contentList.Free;

  ForceDirectory(FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+'bak');
  contentList := FindAllFiles(FPathToAndroidProject+'lamwdesigner', '*.native', False);
  for i:= 0 to contentList.Count-1 do
  begin     //do backup
    CopyFile(contentList.Strings[i],
         FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+'bak'+DirectorySeparator+ExtractFileName(contentList.Strings[i])+'.bak');

    DeleteFile(contentList.Strings[i]);
  end;
  contentList.Free;
end;

procedure TLamwSmartDesigner.GetAllJControlsFromForms(jControlsList: TStrings);
var
  list, contentList: TStringList;
  i, j, p1: integer;
  aux: string;
begin
  list := TStringList.Create;
  list.Delimiter := ';';
  with LazarusIDE.ActiveProject do
    for i := 0 to FileCount - 1 do
    begin
      list.DelimitedText := Files[i].CustomData['jControls'];
      jControlsList.AddStrings(list);
    end;
  list.Free;
  Exit;

  //No need to create the stringlist...
  if jControlsList <> nil then
  begin
    list:= TStringList.Create;
    contentList := FindAllFiles(FPathToAndroidProject+'jni', '*.lfm', False);
    for i:= 0 to contentList.Count-1 do
    begin
      list.LoadFromFile(contentList.Strings[i]);
      for j:= 1 to list.Count - 1 do  // "1" --> skip form
      begin
        aux:= list.Strings[j];
        if Pos('object ', aux) > 0 then  //object jTextView1: jTextView
        begin
           p1:= Pos(':', aux);
           aux:=  Copy(aux, p1+1, Length(aux));
           jControlsList.Add(Trim(aux));
        end;
      end;
    end;
    list.Free;
    contentList.Free;
  end;

end;

function TLamwSmartDesigner.TryAddJControl(jclassname: string;
  out nativeAdded: boolean): boolean;
var
  list, listRequirements, auxList, manifestList: TStringList;
  p1, p2, i: integer;
  aux, tempStr: string;
  insertRef: string;
  c: char;
begin
   nativeAdded:= False;
   Result:= False;

   if FPackageName = '' then Exit;

   if FileExists(FPathToJavaSource+jclassname+'.java') then
     Exit; //do not duplicated!

   list:= TStringList.Create;
   manifestList:= TStringList.Create;
   listRequirements:= TStringList.Create;  //android maninfest Requirements
   auxList:= TStringList.Create;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.java') then
   begin
     list.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.java');
     list.Strings[0]:= 'package '+FPackageName+';';
     list.SaveToFile(FPathToJavaSource+jclassname+'.java');
     //add class relational
     if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.relational') then
     begin
       list.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.relational');
       tempStr:= Copy(list.Strings[0], 3, 100);  //get file name...
       list.Strings[1]:= 'package '+FPackageName+';';
       list.SaveToFile(FPathToJavaSource + tempStr);
     end;
     Result:= True;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator+jclassname+'.native') then
   begin
       CopyFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator+jclassname+'.native',
                FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+jclassname+'.native');
        nativeAdded:= True;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.create') then
   begin
     list.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.create');
     if FileExists(FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+jclassname+'.native') then
     begin
       auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.native');
       for i:= 0 to auxList.Count-1 do
       begin
         list.Add(auxList.Strings[i]);
       end;
     end;
     aux:= list.Text;
     list.LoadFromFile(FPathToJavaSource+'Controls.java');
     list.Insert(list.Count-1, aux);
     list.SaveToFile(FPathToJavaSource+'Controls.java');
   end;

   //try insert reference required by the jControl in AndroidManifest ..
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.permission') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.permission');
     if auxList.Count > 0 then
     begin
       insertRef:= '<uses-sdk android:minSdkVersion'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;

       listRequirements.Add(Trim(auxList.Text));  //Add permissions
       list.Clear;
       for i:= 0 to auxList.Count-1 do
       begin
         if Pos(Trim(auxList.Strings[i]), aux) <= 0 then list.Add(Trim(auxList.Strings[i])); //not duplicate..
       end;

       if list.Count > 0 then
       begin
         p1:= Pos(insertRef, aux);
         p2:= p1 + Length(insertRef);
         c:= aux[p2];
         while c <> '>' do
         begin
            Inc(p2);
            c:= aux[p2];
         end;
         Inc(p2);
         insertRef:= Trim(Copy(aux, p1, p2-p1));
         p1:= Pos(insertRef, aux);
         if Length(list.Text) >  10 then  //dummy
         begin
           Insert(sLineBreak + Trim(list.Text), aux, p1+Length(insertRef) );
           manifestList.Text:= aux;
           manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
         end;
       end;
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.feature') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.feature');
     if auxList.Count > 0 then
     begin
       insertRef:= '<uses-sdk android:minSdkVersion'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;

       listRequirements.Add(Trim(auxList.Text));  //Add feature
       list.Clear;
       for i:= 0 to auxList.Count-1 do
       begin
         if Pos(Trim(auxList.Strings[i]), aux) <= 0 then
           list.Add(Trim(auxList.Strings[i])); //do not insert duplicate..
       end;

       if list.Count > 0 then
       begin
         p1:= Pos(insertRef, aux);
         p2:= p1 + Length(insertRef);
         c:= aux[p2];
         while c <> '>' do
         begin
            Inc(p2);
            c:= aux[p2];
         end;
         Inc(p2);
         insertRef:= Trim(Copy(aux, p1, p2-p1));
         p1:= Pos(insertRef, aux);
         if Length(list.Text) > 10 then  //dummy
         begin
           Insert(sLineBreak + Trim(list.Text), aux, p1+Length(insertRef) );
           manifestList.Text:= aux;
           manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
         end;
       end;
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.intentfilter') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.intentfilter');
     if auxList.Count > 0 then
     begin
       insertRef:= '<intent-filter>'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;

       listRequirements.Add(Trim(auxList.Text));  //Add intentfilters

       list.Clear;
       for i:= 0 to auxList.Count-1 do
       begin
         if Pos(Trim(auxList.Strings[i]), aux) <= 0 then list.Add(Trim(auxList.Strings[i])); //not duplicate..
       end;

       if list.Count > 0 then
       begin
         p1:= Pos(insertRef, aux);
         if Length(list.Text) > 10 then  //dummy
         begin
           Insert(sLineBreak + Trim(list.Text), aux, p1+Length(insertRef) );
           manifestList.Text:= aux;
           manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
         end;
       end;
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.service') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.service');
     if auxList.Text <> '' then
     begin
       tempStr:= Trim(auxList.Text);
       insertRef:= '</activity>'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;
       listRequirements.Add(tempStr);  //Add service
       if Pos(tempStr , aux) <= 0 then
       begin
         p1:= Pos(insertRef, aux);
         Insert(sLineBreak + tempStr, aux, p1+Length(insertRef) );
         manifestList.Text:= aux;
         manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
       end;
     end;
   end;
   //-----
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.provider') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.provider');
     if auxList.Text <> '' then
     begin
       tempStr:= Trim(auxList.Text);
       tempStr:= Trim( StringReplace(tempStr, 'org.lamw.provider', FPackageName, [rfReplaceAll,rfIgnoreCase]) );
       insertRef:= '</activity>'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;
       listRequirements.Add(tempStr);  //Add providers
       if Pos(tempStr , aux) <= 0 then
       begin
         p1:= Pos(insertRef, aux);
         Insert(sLineBreak + tempStr, aux, p1+Length(insertRef) );
         manifestList.Text:= aux;
         manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
       end;
     end;
   end;
   //-----
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.receiver') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.receiver');
     if auxList.Text <> '' then
     begin
       aux:= Trim(auxList.Text);
       tempStr:= StringReplace(aux,'WPACKAGENAME', FPackageName, [rfIgnoreCase]);
       insertRef:= '</activity>'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;
       listRequirements.Add(tempStr);  //Add receiver
       if Pos(tempStr , aux) <= 0 then
       begin
         p1:= Pos(insertRef, aux);
         Insert(sLineBreak + tempStr, aux, p1+Length(insertRef) );
         manifestList.Text:= aux;
         manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
       end;
     end;
   end;
   //-----
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.layout') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.layout');
     list.Clear;
     list.Delimiter:= DirectorySeparator;
     list.StrictDelimiter:= True;
     list.DelimitedText:= FPathToAndroidProject + 'dummy';
     aux:= StringReplace(auxList.Text,'WAPPNAME',  list.Strings[list.Count-2], [rfIgnoreCase]);
     auxList.Text:= aux;
     auxList.SaveToFile(FPathToAndroidProject+'res'+DirectorySeparator+'layout'+DirectorySeparator+LowerCase(jclassname)+'_layout.xml');
   end;
   //-----
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.info') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.info');
     ForceDirectories(FPathToAndroidProject+'res'+DirectorySeparator+'xml');
     auxList.SaveToFile(FPathToAndroidProject+'res'+DirectorySeparator+'xml'+DirectorySeparator+LowerCase(jclassname)+'_info.xml');
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator + jclassname+'.jpg') then
   begin
     CopyFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator + jclassname+'.jpg',
          FPathToAndroidProject+'res'+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+LowerCase(jclassname)+'_image.jpg');
   end;
   //-----
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator + jclassname+'.anim') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator + jclassname+'.anim');
     ForceDirectories(FPathToAndroidProject+'res'+DirectorySeparator+'anim');
     for i:= 0 to  auxList.Count-1 do
     begin
       CopyFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator + 'anim' + DirectorySeparator + auxList.Strings[i],
            FPathToAndroidProject+'res'+DirectorySeparator+'anim'+DirectorySeparator+auxList.Strings[i]);
     end;
   end;
   //-----
   //try fix "gradle.build"
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.dependencies') then
   begin
      auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jclassname+'.dependencies');
      if auxList.Text <> '' then
      begin
        manifestList.LoadFromFile(FPathToAndroidProject+'build.gradle'); //buildgradletList
        for i:= 0 to auxList.Count-1 do
        begin
           manifestList.Text:= StringReplace(manifestList.Text, '//'+auxList.Strings[i], auxList.Strings[i], [rfReplaceAll,rfIgnoreCase]);
        end;
        manifestList.SaveToFile(FPathToAndroidProject+'build.gradle'); //buildgradletList
      end;
   end;
   //-----
   if listRequirements.Count > 0 then
     listRequirements.SaveToFile(FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+jclassname+'.required');

   manifestList.Free;
   listRequirements.Free;
   list.Free;
   auxList.Free;

end;

function TLamwSmartDesigner.GetEventSignature(const nativeMethod: string): string;
var
  method: string;
  signature: string;
  params, paramName: string;
  i, d, p, p1, p2: integer;
  listParam: TStringList;
begin
  listParam:= TStringList.Create;
  method:= nativeMethod;

  p:= Pos('native', method);
  method:= Copy(method, p+Length('native'), MaxInt);
  p1:= Pos('(', method);
  p2:= PosEx(')', method, p1 + 1);
  d:=(p2-p1);

  params:= Copy(method, p1+1, d-1); //long pasobj, long elapsedTimeMillis
  method:= Copy(method, 1, p1-1);
  method:= Trim(method); //void pOnChronometerTick
  Delete(method, 1, Pos(' ', method));
  method:= Trim(method); //pOnChronometerTick

  signature:= '(PEnv,this';  //no param...

  if  Length(params) > 3 then
  begin
    listParam.Delimiter:= ',';
    listParam.StrictDelimiter:= True;
    listParam.DelimitedText:= params;

    for i:= 0 to listParam.Count-1 do
    begin
       paramName:= Trim(listParam.Strings[i]); //long pasobj
       Delete(paramName, 1, Pos(' ', paramName));
       listParam.Strings[i]:= Trim(paramName);
    end;

    for i:= 0 to listParam.Count-1 do
    begin
      if Pos('pasobj', listParam.Strings[i]) > 0 then
        signature:= signature + ',TObject(' + listParam.Strings[i]+')'
      else
        signature:= signature + ',' + listParam.Strings[i];
    end;
  end;

  Result:= method+'=Java_Event_'+method+signature+');';
  if method = 'pAppOnCreate' then
  begin
    Result := Result + FStartModuleVarName + '.Init(gApp);'
  end;

  listParam.Free;
end;


procedure TLamwSmartDesigner.UpdateProjectLpr(oldModuleName: string; newModuleName: string);
var
  tempList, importList, javaClassList, nativeMethodList: TStringList;
  i, k, FromPos, ToPos: Integer;
  n: TCodeTreeNode;
  cb: TCodeBuffer;
  PosFound: Boolean;
  str: string;
  Beauty: TBeautifyCodeOptions;
  IdentList : TStringList;
begin
  if not FProjFile.IsPartOfProject then Exit;
  if FPackageName = '' then Exit;

  nativeMethodList:= TStringList.Create;
  tempList:= TStringList.Create;
  importList:= TStringList.Create;
  importList.Sorted := True;
  importList.Duplicates := dupIgnore;
  javaClassList := FindAllFiles(FPathToAndroidProject+'lamwdesigner', '*.native', False);
  for k := 0 to javaClassList.Count - 1 do
  begin
    tempList.LoadFromFile(javaClassList.Strings[k]);
    for i := 0 to tempList.Count - 1 do
      nativeMethodList.Add(Trim(tempList.Strings[i]));
  end;
  javaClassList.Free;

  javaClassList := FindAllFiles(FPathToJavaSource, '*.java', False);
  for k := 0 to javaClassList.Count - 1 do
  begin
    tempList.LoadFromFile(javaClassList.Strings[k]);
    for i := 0 to tempList.Count - 1 do
    begin
      if Pos('import ', tempList.Strings[i]) > 0 then
        importList.Add(Trim(tempList.Strings[i]));
    end;
  end;

  tempList.Clear;
  for i:= 0 to nativeMethodList.Count-1 do
  begin
    tempList.Add(GetEventSignature(nativeMethodList.Strings[i]));
  end;

  javaClassList.Clear;
  javaClassList.Add('package ' + FPackageName + ';');
  javaClassList.Add('');
  javaClassList.AddStrings(importList);
  javaClassList.Add('public class Controls {');
  javaClassList.Add('');
  javaClassList.AddStrings(nativeMethodList);
  javaClassList.Add('}');

  if nativeMethodList.Count > 0 then
  begin
    with TJavaParser.Create(javaClassList) do
    try
      str := GetPascalJNIInterfaceCode(tempList);
    finally
      Free
    end;

    with CodeToolBoss do
    begin
      cb := FindFile(FProjFile.GetFullFilename);
      PosFound := False;
      InitCurCodeTool(cb);
      CurCodeTool.BuildTree(lsrEnd);
      // search first "{%region /fold ... }"
      i := PosEx('{%', CurCodeTool.Src);
      while i > 0 do
      begin
        if CurCodeTool.CompareSrcIdentifiers(i + 2, 'region') then
        begin
          FromPos := PosEx('}', CurCodeTool.Src, i) + 1;
          k := PosEx('/fold', CurCodeTool.Src, i);
          if (k = 0) or (k > FromPos) then
          begin
            i := PosEx('{%', CurCodeTool.Src, i);
            Continue;
          end;
          i := RPos('{%', CurCodeTool.Src);
          while (i > 0) and (i > FromPos) do
          begin
            if CurCodeTool.CompareSrcIdentifiers(i + 2, 'endregion') then
            begin
              ToPos := i - 1;
              PosFound := True;
              Break;
            end;
            i := RPosEx('{%', CurCodeTool.Src, i - 1);
          end;
          Break;
        end;
        i := PosEx('{%', CurCodeTool.Src, i + 1);
      end;

      if not PosFound then // fallback
      begin
        str := '{%region /fold ''LAMW generated code''}' + sLineBreak + sLineBreak
          + str + sLineBreak + '{%endregion}' + sLineBreak;
        n := CurCodeTool.Tree.Root;
        FromPos := n.FirstChild.EndPos; // should be the end of uses-clause
        ToPos := n.LastChild.StartPos;  // should be the start of begin..end section
      end;

      Beauty := SourceChangeCache.BeautifyCodeOptions;
      SourceChangeCache.MainScanner := CurCodeTool.Scanner;

      SourceChangeCache.Replace(gtEmptyLine, gtNewLine,
        FromPos, ToPos,
        Beauty.BeautifyStatement(str, Beauty.Indent, [bcfDoNotIndentFirstLine]));

      SourceChangeCache.Apply;

      //LAMW 0.8
      if (oldModuleName <> '') and (newModuleName <> '') then
      begin
        if oldModuleName <> newModuleName then
        begin
            IdentList := TStringList.Create;
            try
              IdentList.Add(oldModuleName);
              IdentList.Add(newModuleName);
              IdentList.Add('T' + oldModuleName);
              IdentList.Add('T' + newModuleName);
              cb := FindFile(FProjFile.GetFullFilename);
              InitCurCodeTool(cb);
              SourceChangeCache.MainScanner := CurCodeTool.Scanner;
              CurCodeTool.ReplaceWords(IdentList, True, SourceChangeCache);
            finally
              IdentList.Free;
            end;
        end;
      end;
      //LAMW 0.8

    end;
  end;

  importList.Free;
  nativeMethodList.Free;
  tempList.Free;
  javaClassList.Free;
end;

procedure TLamwSmartDesigner.InitSmartDesignerHelpers;
var
  dlgMessage: string;
begin
  // FProjFile = nil if it is a just created project
  if (FProjFile = nil) or not FProjFile.IsPartOfProject then Exit;

  if not DirectoryExists(FPathToAndroidProject+'lamwdesigner') then
  begin
    ForceDirectory(FPathToJavaSource + 'bak');

    dlgMessage:= 'Hello!'+sLineBreak+sLineBreak+'We need to do an important change/update in your project.'+sLineBreak+sLineBreak+
                 'Don''t worry.'+sLineBreak+sLineBreak+'The project''s backup files will be saved as *.bak.OLD'+sLineBreak+sLineBreak+
                 'Please, whenever a dialog prompt select "Reload from disk" ';

    if QuestionDlg ('\o/ \o/ \o/    ' +
         'Welcome to LAMW version ' + LamwGlobalSettings.Version + '!',
         dlgMessage,mtCustom,[mrYes,'OK'],'') = mrYes
    then  begin
      CopyFile(FPathToJavaSource+'Controls.java',
               FPathToJavaSource+'bak'+DirectorySeparator+'Controls.java.bak.OLD');

      CopyFile(FPathToJavaSource+'App.java',
               FPathToJavaSource+'bak'+DirectorySeparator+'App.java.bak.OLD');

      CopyFile(FPathToAndroidProject+'jni'+DirectorySeparator+'controls.lpr',
               FPathToAndroidProject+'jni'+DirectorySeparator+'controls.lpr.bak.OLD');
    end;
    ForceDirectory(FPathToAndroidProject+'lamwdesigner');
    // old [fat] *.lpr will be cleanup on project saving
  end;

end;


procedure TLamwSmartDesigner.UpdateStartModuleVarName;
var
  j: Integer;
begin
  with CodeToolBoss do
  begin
    InitCurCodeTool(FindFile(FProjFile.GetFullFilename));
    with CurCodeTool do
    begin
      BuildTree(lsrEnd);
      MoveCursorToCleanPos(CurCodeTool.SrcLen);
      ReadPriorAtom;
      j := Tree.Root.LastChild.StartPos;
      while CurPos.StartPos >= j do
      begin
        if UpAtomIs('CREATEFORM') then
        begin
          ReadNextAtom; // (
          ReadNextAtom; // StartModule Class Name
          ReadNextAtom; // ,
          ReadNextAtom; // StartModule Var Name
          FStartModuleVarName := GetAtom;
          Break;
        end;
        ReadPriorAtom;
      end;
    end;
    if FStartModuleVarName = '' then
      FStartModuleVarName := 'AndroidModule1';
  end;
end;

function TLamwSmartDesigner.GetLprStartModuleVarName: string;
var
  j: Integer;
begin
  with CodeToolBoss do
  begin
    InitCurCodeTool(FindFile(FProjFile.GetFullFilename));
    with CurCodeTool do
    begin
      BuildTree(lsrEnd);
      MoveCursorToCleanPos(CurCodeTool.SrcLen);
      ReadPriorAtom;
      j := Tree.Root.LastChild.StartPos;
      while CurPos.StartPos >= j do
      begin
        if UpAtomIs('CREATEFORM') then
        begin
          ReadNextAtom; // (
          ReadNextAtom; // StartModule Class Name
          ReadNextAtom; // ,
          ReadNextAtom; // StartModule Var Name
          Result := GetAtom;
          Break;
        end;
        ReadPriorAtom;
      end;
    end;
  end;
end;

procedure TLamwSmartDesigner.UpdateAllJControls(AProject: TLazProject);
var
  jControls, LFM: TStringList;
  lfmFileName, str: string;
  i, j, k: Integer;
begin
  jControls := TStringList.Create;
  jControls.Sorted := True;
  jControls.Duplicates := dupIgnore;
  jControls.Delimiter := ';';
  LFM := TStringList.Create;
  try
    for i := 0 to AProject.FileCount - 1 do
      with AProject.Files[i] do
      begin
        lfmFileName := ChangeFileExt(Filename, '.lfm');
        if FileExists(lfmFileName) then
        begin
          jControls.Clear;
          LFM.LoadFromFile(lfmFileName);
          for j := 0 to LFM.Count - 1 do
          begin
            str := LFM[j];
            k := Pos(':', str);
            if k > 0 then
            begin
              str := Trim(Copy(str, k + 1, MaxInt));
              if (str = 'TFPNoGUIGraphicsBridge')
              or FileExists(LamwGlobalSettings.PathToJavaTemplates + 'lamwdesigner' + PathDelim + str + '.java')
              then
                  jControls.Add(str);
            end;
          end;
          CustomData['jControls'] := jControls.DelimitedText;
        end;
      end;
  finally
    LFM.Free;
    jControls.Free;
  end;
end;

function TLamwSmartDesigner.OnProjectSavingAll(Sender: TObject): TModalResult;
var
  auxList, jcontrolsList, libList: TStringList;
  i, j, p: Integer;
  nativeExists: Boolean;
  aux, PathToJavaTemplates, chipArchitecture, LibPath: string;
  pathToNdkApiPlatforms, androidNdkApi, arch: string;
  AndroidTheme: string;
  compoundList: TStringList;
  lprModuleName: string;
begin
  Result := mrOk;
  if not LazarusIDE.ActiveProject.CustomData.Contains('LAMW') then Exit;
  if LazarusIDE.ActiveProject.CustomData.Values['LAMW'] <> 'GUI' then Exit;

  auxList:= TStringList.Create;

  AndroidTheme:= LazarusIDE.ActiveProject.CustomData.Values['Theme'];

  PathToJavaTemplates := LamwGlobalSettings.PathToJavaTemplates; //included path delimiter

  //LAMW 0.8
  lprModuleName:= GetLprStartModuleVarName();
  FStartModuleVarName:= LazarusIDE.ActiveProject.CustomData.Values['StartModule'];
  if FStartModuleVarName = '' then UpdateStartModuleVarName;
  //LAMW 0.8

  chipArchitecture:= 'x86';
  aux := LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions;
  if Pos('-CpARMV6', aux) > 0 then chipArchitecture:= 'armeabi'
  else if Pos('-CpARMV7A', aux) > 0 then chipArchitecture:= 'armeabi-v7a'
  else if Pos('-XPmipsel', aux) > 0 then chipArchitecture:= 'mips';

  if LamwGlobalSettings.CanUpdateJavaTemplate then
  begin
    CleanupAllJControlsSource;

    // tk Output some useful messages about libraries
    LibPath := FPathToAndroidProject + 'libs'+DirectorySeparator+chipArchitecture;
    IDEMessagesWindow.AddCustomMessage(mluVerbose, 'Selected chip architecture: ' + chipArchitecture);
    IDEMessagesWindow.AddCustomMessage(mluVerbose, 'Taking libraries from folder: ' + LibPath);
    // end tk

    //update all java code ...
    libList:= FindAllFiles(LibPath, '*.so', False);
    for j:= 0 to libList.Count-1 do
    begin
      aux:= ExtractFileName(libList.Strings[j]);

      // tk Show what library has been added
      IDEMessagesWindow.AddCustomMessage(mluVerbose, 'Found library: ' + aux);
      // end tk

      p:= Pos('.', aux);
      aux:= Trim(copy(aux,4, p-4));
      auxList.Add(aux);
    end;

    libList.Clear;
    for j:= 0 to auxList.Count-1 do
    begin
      libList.Add('try{System.loadLibrary("'+auxList.Strings[j]+'");} catch (UnsatisfiedLinkError e) {Log.e("JNI_Loading_lib'+auxList.Strings[j]+'", "exception", e);}');
    end;

    auxList.Clear;
    if FileExists(PathToJavaTemplates+'Controls.java') then
    begin
      auxList.LoadFromFile(PathToJavaTemplates+'Controls.java');
      auxList.Strings[0]:= 'package '+FPackageName+';';

      if libList.Count > 0 then
         aux:=  StringReplace(auxList.Text, '/*libsmartload*/' ,Trim(libList.Text), [rfReplaceAll,rfIgnoreCase])
      else
         aux:=  StringReplace(auxList.Text, '/*libsmartload*/' ,
                 'try{System.loadLibrary("controls");} catch (UnsatisfiedLinkError e) {Log.e("JNI_Loading_libcontrols", "exception", e);}',
                 [rfReplaceAll,rfIgnoreCase]);

      auxList.Text:= aux;
      auxList.SaveToFile(FPathToJavaSource+'Controls.java');
    end;

    auxList.Clear;
    if Pos('AppCompat', AndroidTheme) > 0 then
    begin
      if FileExists(PathToJavaTemplates + 'lamwdesigner'+DirectorySeparator+'support'+DirectorySeparator+'App.java') then
        auxList.LoadFromFile(PathToJavaTemplates  + 'lamwdesigner'+DirectorySeparator+'support'+DirectorySeparator+'App.java');
    end
    else
    begin
      if FileExists(PathToJavaTemplates + 'App.java') then
         auxList.LoadFromFile(PathToJavaTemplates + 'App.java');

    end;
    auxList.Strings[0]:= 'package '+FPackageName+';';
    auxList.SaveToFile(FPathToJavaSource+'App.java');
    auxList.Clear;
    if Pos('AppCompat', AndroidTheme) > 0 then
    begin
      if FileExists(LamwGlobalSettings.PathToJavaTemplates+
                    'lamwdesigner'+DirectorySeparator+'support'+DirectorySeparator+'jCommons.java') then
        auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates +'lamwdesigner'+DirectorySeparator+'support'+DirectorySeparator+'jCommons.java');
    end
    else
    begin
      if FileExists(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +'jCommons.java') then
        auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +'jCommons.java');
    end;
    auxList.Strings[0]:= 'package '+FPackageName+';';
    auxList.SaveToFile(FPathToJavaSource+'jCommons.java');

    libList.Free;

  end;  //CanUpdateJavaTemplate

  if FileExists(PathToJavaTemplates + 'Controls.native') then
  begin
    CopyFile(PathToJavaTemplates + 'Controls.native',
       FPathToAndroidProject+'lamwdesigner'+PathDelim+'Controls.native');
  end;

  jcontrolsList := TStringList.Create;
  jcontrolsList.Sorted := True;
  jcontrolsList.Duplicates := dupIgnore;
  GetAllJControlsFromForms(jcontrolsList);

  compoundList:= TStringList.Create;
  for i:= 0 to jcontrolsList.Count - 1 do       //Add component compound support
  begin
    if FileExists(PathToJavaTemplates+'lamwdesigner'+PathDelim+jcontrolsList.Strings[i]+'.compound') then
    begin
      compoundList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'lamwdesigner'+DirectorySeparator +jcontrolsList.Strings[i]+'.compound');
      for j:= 0 to compoundList.Count - 1 do
      begin
        if compoundList.Strings[j] <> '' then
           jcontrolsList.Add(compoundList.Strings[j]);
      end;
    end;
  end;
  compoundList.Free;

  //re-add all [updated] java code ...
  for j:= 0 to jcontrolsList.Count - 1 do
  begin
    if FileExists(PathToJavaTemplates+'lamwdesigner'+PathDelim+jcontrolsList.Strings[j]+'.java') then
       TryAddJControl(jcontrolsList.Strings[j], nativeExists);
  end;

  if jcontrolsList.IndexOf('TFPNoGUIGraphicsBridge') >= 0 then   //handle lib freetype need by TFPNoGUIGraphicsBridge
  begin                                                                         //lamwdesigner\libs\armeabi\libfreetype.so
    if FileExists(PathToJavaTemplates+'lamwdesigner'+PathDelim+'libs'+PathDelim+chipArchitecture+PathDelim+'libfreetype.so') then
    begin
      CopyFile(PathToJavaTemplates+'lamwdesigner'+PathDelim+'libs'+PathDelim+chipArchitecture+PathDelim+'libfreetype.so',
               FPathToAndroidProject+'libs'+PathDelim+
               chipArchitecture+PathDelim+'libfreetype.so');

      //Added support to TFPNoGUIGraphicsBridge ...
      androidNdkApi:= LazarusIDE.ActiveProject.CustomData.Values['NdkApi']; //android-13 or android-14 or ... etc
      if androidNdkApi <> '' then
      begin

        if Pos('armeabi', chipArchitecture) > 0 then
           arch:= 'arch-arm'
        else if Pos('x86', chipArchitecture) > 0 then arch:= 'arch-x86'
        else if Pos('mips', chipArchitecture) > 0 then arch:= 'arch-mips';

                                //C:\adt32\ndk10e\platforms\android-15\arch-arm\usr\lib
        pathToNdkApiPlatforms:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                                androidNdkApi +DirectorySeparator+arch+DirectorySeparator+
                                                'usr'+DirectorySeparator+'lib';

        //need by linker!
        CopyFile(PathToJavaTemplates+'lamwdesigner'+PathDelim+'libs'+PathDelim+chipArchitecture+PathDelim+'libfreetype.so',
               pathToNdkApiPlatforms+PathDelim+'libfreetype.so');

        (*
        //need by compiler
        CopyFile(PathToJavaTemplates+'lamwdesigner'+PathDelim+'libs'+PathDelim+'ftsrc'+PathDelim+'freetype.pp',
                 FPathToAndroidProject+'jni'+PathDelim+ 'freetype.pp');
        CopyFile(PathToJavaTemplates+'lamwdesigner'+PathDelim+'libs'+PathDelim+'ftsrc'+PathDelim+'freetypeh.pp',
                FPathToAndroidProject+'jni'+PathDelim+ 'freetypeh.pp');
        CopyFile(PathToJavaTemplates+'lamwdesigner'+PathDelim+'libs'+PathDelim+'ftsrc'+PathDelim+'ftfont.pp',
                 FPathToAndroidProject+'jni'+PathDelim+ 'ftfont.pp');
        *)

      end
      else
      begin
        pathToNdkApiPlatforms:='';
        aux:= LazarusIDE.ActiveProject.LazCompilerOptions.Libraries; //C:\adt32\ndk10e\platforms\android-15\arch-arm\usr\lib\; .....
        p:= Pos(';', aux);
        if p > 0 then
        begin
           pathToNdkApiPlatforms:= Trim(Copy(aux, 1, p-1));
           //need by linker!
           CopyFile(PathToJavaTemplates+'lamwdesigner'+PathDelim+'libs'+PathDelim+chipArchitecture+PathDelim+'libfreetype.so',
                    pathToNdkApiPlatforms+'libfreetype.so');
        end;
      end;

    end;
  end;

  jcontrolsList.Free;
  auxList.Free;

  UpdateProjectLpr(lprModuleName, FStartModuleVarName);
end;

destructor TLamwSmartDesigner.Destroy;
begin
  if LazarusIDE <> nil then
    LazarusIDE.RemoveAllHandlersOfObject(Self);
  inherited Destroy;
end;

procedure TLamwSmartDesigner.Init;
begin
  LazarusIDE.AddHandlerOnProjectOpened(@OnProjectOpened);
  LazarusIDE.AddHandlerOnSavingAll(@OnProjectSavingAll);
end;

//F
//C:\adt32\ndk10e\platforms\android-21\arch-arm\usr\lib\;
//C:\adt32\ndk10e\toolchains\arm-linux-androideabi-4.9\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.9\"/>

//custom
//C:\adt32\ndk10e\toolchains\arm-linux-androideabi-4.9\prebuilt\windows\bin

function TLamwSmartDesigner.TryChangeNdkPlatformsApi(path: string; newNdkApi: integer): string;
var
  projPlatformApi: string;
  newPlatformApi: string;
  p: integer;
  tail: string;
begin
  Result:= path;
  newPlatformApi:= PathDelim + 'android-'+IntToStr(newNdkApi) + PathDelim;
  p:= Pos('platforms', path);
  tail:= Copy(path, p+10, MaxInt);
  p:= Pos(PathDelim, tail);

  if p > 0 then
  begin
    projPlatformApi:=  Copy(tail, 1, p-1);
    projPlatformApi:=  PathDelim + projPlatformApi + PathDelim;
    if  projPlatformApi <>  newPlatformApi then
    begin
      Result:= StringReplace(path, projPlatformApi ,newPlatformApi,[rfReplaceAll,rfIgnoreCase]);
    end;
  end;

end;

function TLamwSmartDesigner.TryChangePrebuildOSY(path: string): string;
var
  projPrebuildOSYS: string;
  extPrebuildOSYS: string;
  p: integer;
  tail: string;
begin
  Result:= path;
  extPrebuildOSYS:= PathDelim + FPrebuildOSYS + PathDelim;
  p:= Pos('prebuilt', path);
  tail:= Copy(path, p+9, MaxInt);
  p:= Pos(PathDelim, tail);

  if p > 0 then
  begin
    projPrebuildOSYS:=  Copy(tail, 1, p-1);
    projPrebuildOSYS:=  PathDelim + projPrebuildOSYS + PathDelim;
    if  projPrebuildOSYS <>  extPrebuildOSYS then
    begin
      Result:= StringReplace(path, projPrebuildOSYS ,extPrebuildOSYS,[rfReplaceAll,rfIgnoreCase]);
    end;
  end;

end;

//C:\adt32\ndk10e\toolchains\arm-linux-androideabi-4.9\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.9\"/>
function TLamwSmartDesigner.TryChangeTo49x(path: string): string;
var
  proj49: string;
  p: integer;
  new49x: string;
begin
  Result:= path;
  new49x:= PathDelim + '4.9.x' + PathDelim;  //  /4.9.x/

  p:= Pos(PathDelim+'4.9', path);
  if p > 0 then
  begin
    proj49:= Copy(path, p, MaxInt); //  /4.9/
    if  proj49 <>  new49x then
    begin
      Result:= StringReplace(path, proj49, new49x,[rfReplaceAll,rfIgnoreCase]);
    end;
  end;

end;

function TLamwSmartDesigner.TryChangeTo49(path: string): string;
var
  proj49x: string;
  p: integer;
  new49: string;
begin
  Result:= path;
  new49:= PathDelim + '4.9' + PathDelim;  //  /4.9/

  p:= Pos(PathDelim+'4.9.x', path);
  if p > 0 then
  begin
    proj49x:= Copy(path, p, MaxInt); //  /4.9.x/
    if  proj49x <>  new49 then
    begin
      Result:= StringReplace(path, proj49x, new49,[rfReplaceAll,rfIgnoreCase]);
    end;
  end;

end;

procedure TLamwSmartDesigner.TryChangeDemoProjecAntBuildScripts();
var
  strList: TStringList;
  pathToAntBin, pathToJavaJDK, androidProjectName, antBuildMode: string;
  linuxDirSeparator: string;
  linuxPathToJavaJDK: string;
  linuxAndroidProjectName:  string;
  linuxPathToAntBin: string;
  linuxPathToAndroidSdk: string;
  tempStr, linuxPathToAdbBin, packageName: string;

begin

  pathToAntBin:= Copy(LamwGlobalSettings.PathToAntBin, 1, Length(LamwGlobalSettings.PathToAntBin)-1); //paths have trailing path
  if pathToAntBin = '' then Exit;

  antBuildMode:= 'debug';
  packageName:= LazarusIDE.ActiveProject.CustomData.Values['Package'];

  pathToJavaJDK:= Copy(LamwGlobalSettings.PathToJavaJDK, 1, Length(LamwGlobalSettings.PathToJavaJDK)-1); //paths have trailing path

  androidProjectName:= FPathToAndroidProject; //paths have trailing path

  strList:= TStringList.Create;

  strList.Add('set Path=%PATH%;'+pathToAntBin); //<--- thanks to andersonscinfo !  [set path=%path%;C:\and32\ant\bin]
  strList.Add('set JAVA_HOME='+pathToJavaJDK);  //set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.7.0_21
  strList.Add('cd '+androidProjectName);
  strList.Add('call ant clean -Dtouchtest.enabled=true debug');
  strList.Add('if errorlevel 1 pause');
  strList.SaveToFile(androidProjectName+'build-debug.bat');

  strList.Clear;
  strList.Add('set Path=%PATH%;'+pathToAntBin);
  strList.Add('set JAVA_HOME='+pathToJavaJDK);
  strList.Add('cd '+androidProjectName);
  strList.Add('call ant clean release');
  strList.Add('if errorlevel 1 pause');
  strList.SaveToFile(androidProjectName+'build-release.bat');

  strList.Clear;
  strList.Add('cd '+androidProjectName+'bin');
  strList.Add(FPathToAndroidSDK+'platform-tools'+
             DirectorySeparator+'adb install -r '+FSmallProjName+'-'+antBuildMode+'.apk');
  strList.Add('cd ..');
  strList.Add('pause');
  strList.SaveToFile(androidProjectName+'install.bat');

  linuxDirSeparator:= DirectorySeparator;
  linuxPathToJavaJDK:= pathToJavaJDK;
  linuxAndroidProjectName:= androidProjectName;
  linuxPathToAntBin:= pathToAntBin;
  linuxPathToAndroidSdk:= FPathToAndroidSDK;

  {$IFDEF WINDOWS}
     linuxDirSeparator:= '/';
     tempStr:= pathToJavaJDK;
     SplitStr(tempStr, ':');
     linuxPathToJavaJDK:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

     tempStr:= androidProjectName;
     SplitStr(tempStr, ':');
     linuxAndroidProjectName:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

     tempStr:= pathToAntBin;
     SplitStr(tempStr, ':');
     linuxPathToAntBin:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

     tempStr:= FPathToAndroidSDK;
     SplitStr(tempStr, ':');
     linuxPathToAndroidSdk:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);

     tempStr:= androidProjectName;
     SplitStr(tempStr, ':');
     linuxAndroidProjectName:= StringReplace(tempStr, '\', '/', [rfReplaceAll]);
  {$ENDIF}

  strList.Clear;
  if pathToAntBin <> '' then
    strList.Add('export PATH='+linuxPathToAntBin+':$PATH');

  strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);
  strList.Add('cd '+linuxAndroidProjectName);
  strList.Add('ant -Dtouchtest.enabled=true debug');
  SaveShellScript(strList, androidProjectName+'build-debug.sh');


  //MacOs
  strList.Clear;
  if pathToAntBin <> '' then
  begin
     strList.Add('export PATH='+linuxPathToAntBin+':$PATH');        //export PATH=/usr/bin/ant:PATH
     strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
     strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
     strList.Add('cd '+linuxAndroidProjectName);
     strList.Add('ant -Dtouchtest.enabled=true debug');
     SaveShellScript(strList, androidProjectName+'build-debug-macos.sh');
  end;

  strList.Clear;
  if pathToAntBin <> '' then
     strList.Add('export PATH='+linuxPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH

  strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
  strList.Add('cd '+linuxAndroidProjectName);
  strList.Add('ant clean release');
  SaveShellScript(strList, androidProjectName+'build-release.sh');

  linuxPathToAdbBin:= linuxPathToAndroidSdk+'platform-tools';

  //linux install - thanks to Stephano!
  strList.Clear;
  strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+packageName);
  strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb install -r bin'+linuxDirSeparator+FSmallProjName+'-'+antBuildMode+'.apk');
  strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat');
  SaveShellScript(strList, androidProjectName+'install.sh');

  strList.Clear;
  strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+packageName);
  SaveShellScript(strList, androidProjectName+'uninstall.sh');

  strList.Clear;
  strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat');
  SaveShellScript(strList, androidProjectName+'logcat.sh');

  strList.Free;
end;

procedure TLamwSmartDesigner.TryChangeDemoProjecPaths();
var
  strList: TStringList;
  strResult: string;
  lpiFileName: string;
  strTemp: string;
  strCustom,  strLibrary: string;
  pathToDemoNDK,  pathToDemoNDKConverted: string;
  pathToDemoSDK, FNDKIndex: string;
  localSys: string;
  maxNdk: integer;
  strMaxNdk: string;
begin

  strList:= TStringList.Create;
  pathToDemoSDK:= LazarusIDE.ActiveProject.CustomData.Values['SdkPath']; //included pathDelimiter

  if pathToDemoSDK = '' then
    pathToDemoSDK:= GetPathToSDKFromBuildXML(FPathToAndroidProject+'build.xml'); //included pathDelimiter

  pathToDemoNDK:= LazarusIDE.ActiveProject.CustomData.Values['NdkPath']; //included pathDelimiter

  if (FPathToAndroidNDK <> '') and (pathToDemoNDK <> '') then
  begin
    if Pos(':', FPathToAndroidNDK) > 0 then
    begin
      localSys:= 'win';
      pathToDemoNDKConverted:= StringReplace(pathToDemoNDK, '/', '\', [rfReplaceAll,rfIgnoreCase]);
    end
    else
    begin
      localSys:= 'unix';
      pathToDemoNDKConverted:= StringReplace(pathToDemoNDK, '\', '/', [rfReplaceAll,rfIgnoreCase]);
    end;
  end;

  if (FPathToAndroidSDK <> '') and (pathToDemoSDK <> '') then
  begin
    if FileExists(FPathToAndroidProject+'build.xml') then
    begin
      strList.LoadFromFile(FPathToAndroidProject+'build.xml');
      strList.SaveToFile(FPathToAndroidProject+'build.xml.bak2');
      strResult := StringReplace(strList.Text, pathToDemoSDK,
                                               FPathToAndroidSDK,
                                               [rfReplaceAll,rfIgnoreCase]);
      strList.Text := strResult;
      strList.SaveToFile(FPathToAndroidProject+'build.xml');
    end;
  end
  else
    ShowMessage('Sorry.. Project "build.xml" Path  to SDK not fixed... [Please, change it by hand!]');

  lpiFileName := LazarusIDE.ActiveProject.ProjectInfoFile; //full path to 'controls.lpi';
  CopyFile(lpiFileName, lpiFileName+'.bak2');

  FNDKIndex := LamwGlobalSettings.GetNDK;

  if (pathToDemoNDK <> '') and (FPathToAndroidNDK <> '') then
  begin

      //Libraries
      strTemp:= LazarusIDE.ActiveProject.LazCompilerOptions.Libraries;   //path already converted!!!

      strLibrary:= StringReplace(strTemp, pathToDemoNDKConverted,
                                         FPathToAndroidNDK,
                                         [rfReplaceAll,rfIgnoreCase]);
      //try
      strResult:= StringReplace(strLibrary, '4.6', '4.9', [rfReplaceAll,rfIgnoreCase]);

      maxNdk:= Self.GetMaxNdkPlatform(); //21
      strMaxNdk:= IntToStr(maxNdk);      //'21'

      strResult:= TryChangePrebuildOSY(strResult); //LAMW 0.8

      if StrToInt(FNDKIndex) > 4 then  //LAMW 0.8
         strResult:= TryChangeTo49x(strResult)
      else
         strResult:= TryChangeTo49(strResult);

      if maxNdk > 0 then
        strResult:= TryChangeNdkPlatformsApi(strResult, maxNdk);

      LazarusIDE.ActiveProject.LazCompilerOptions.Libraries:= strResult;

      LazarusIDE.ActiveProject.CustomData.Values['NdkApi']:='android-'+strMaxNdk; //android-13 or android-14 or ... etc

      //CustomOptions
      strTemp:= LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions;  //path not already converted!!

      if localSys = 'win' then
        strCustom:= StringReplace(strTemp, '/', '\', [rfReplaceAll,rfIgnoreCase])
      else   //unix
        strCustom:= StringReplace(strTemp, '\', '/', [rfReplaceAll,rfIgnoreCase]);

      strResult:= StringReplace(strCustom, pathToDemoNDKConverted,
                                         FPathToAndroidNDK,
                                         [rfReplaceAll,rfIgnoreCase]);
      //try
      strResult:= StringReplace(strResult, '4.6', '4.9', [rfReplaceAll,rfIgnoreCase]);

      strResult:= TryChangePrebuildOSY(strResult); //LAMW 0.8

      LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions:= strResult;

      //update custom ...
      LazarusIDE.ActiveProject.CustomData.Values['NdkPath']:= FPathToAndroidNDK;
      LazarusIDE.ActiveProject.CustomData.Values['SdkPath']:= FPathToAndroidSDK;

  end
  else
  begin
    ShowMessage('Sorry.. path to NDK not fixed ... [Please, change it by hand!]');
  end;

  strList.Free;
end;

procedure TLamwSmartDesigner.TryFindDemoPathsFromReadme(
  out pathToDemoNDK, pathToDemoSDK: string);
var
  strList: TStringList;
  p: integer;
  p2: integer;
begin

  strList:= TStringList.Create;
  if FileExists(FPathToAndroidProject + 'readme.txt') then
  begin
    strList.LoadFromFile(FPathToAndroidProject + 'readme.txt');

    p := Pos('System Path to Android SDK=', strList.Text);
    p := p+length('System Path to Android SDK=');

    p2 := Pos('System Path to Android NDK=', strList.Text);
    pathToDemoSDK := Trim(copy(strList.Text,p,p2-p));

    p := Pos('System Path to Android NDK=', strList.Text);
    p := p+length('System Path to Android NDK=');

    pathToDemoNDK := Trim(copy(strList.Text,p,strList.Count));
  end;

  strList.Free;
end;

function TLamwSmartDesigner.IsDemoProject(): boolean;
var
  pathToDemoNDK: string;
  pathToDemoSDK: string;
begin
  Result := False;

  pathToDemoNDK:= LazarusIDE.ActiveProject.CustomData.Values['NdkPath']; //included delimiter
  pathToDemoSDK:= LazarusIDE.ActiveProject.CustomData.Values['SdkPath']; //included delimiter

  if (pathToDemoNDK = '') and (pathToDemoSDK = '') then
  begin
    TryFindDemoPathsFromReadme(pathToDemoNDK, pathToDemoSDK);  // try "readme.txt"
    if (pathToDemoNDK = '') and (pathToDemoSDK = '') then Exit;
    //create custom data
    pathToDemoNDK:= IncludeTrailingPathDelimiter(pathToDemoNDK);
    pathToDemoSDK:= IncludeTrailingPathDelimiter(pathToDemoSDK);
    LazarusIDE.ActiveProject.CustomData.Values['NdkPath']:= pathToDemoNDK;
    LazarusIDE.ActiveProject.CustomData.Values['SdkPath']:= pathToDemoSDK;
  end;

  if (pathToDemoNDK = FPathToAndroidNDK) and (pathToDemoSDK = FPathToAndroidSDK) then Exit;

  if Pos(':', pathToDemoNDK) > 0 then //project imported from windows ...
    TryRunProcessChmod(FPathToAndroidProject); //need to convert win to Linux ...

  Result:= True;
end;


initialization
  LamwSmartDesigner := TLamwSmartDesigner.Create;

finalization
  LamwSmartDesigner.Free;

end.
