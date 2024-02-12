unit SmartDesigner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, ProjectIntf, Forms, AndroidWidget,
  process, SourceChanger, propedits, LCLClasses;

//tk min and max API versions for build.xml
const
  cMinAPI = 14;
  cMaxAPI = 35;
// end tk

type
  { TLamwSmartDesigner }

  TLamwSmartDesigner = class
  private
    FProjFile: TLazProjectFile;
    FPackageName: string;
    FStartModuleVarName: string;
    // all Paths have trailing PathDelim
    FPathToJavaSource: string;  //Included Path Delimiter!
    FPathToAndroidProject: string;  //Included Path Delimiter!

    FPathToAndroidSDK: string;  //Included Path Delimiter!
    FPathToAndroidNDK: string;  //Included Path Delimiter!

    FPathToJavaJDK: string;

    FSmallProjName: string;
    FGradleVersion: string;
    FPrebuildOSYS: string;
    FCandidateSdkPlatform: integer;
    FPathToGradle: string;
    FPathToSmartDesigner: string;
    FChipArchitecture: string;
    FNDKIndex: string;
    FMaxNdk: integer;
    FNDKVersion: integer;
    FMinSdkControl: integer;
    FNdkApi: string;
    FAndroidTheme: string;
    FIsKotlinSupported: boolean;
    FKeepMyBuildGradleWhenReopen: string;

    FJavaBigVersion: string;
    FJavaMainVersion: string;

    procedure CleanupAllJControlsSource;
    procedure GetAllJControlsFromForms(jControlsList: TStrings);
    procedure AddSupportToFCLControls(chipArch: string);
    function GetEventSignature(const nativeMethod: string): string;
    function GetPackageNameFromAndroidManifest(pathToAndroidManifest: string): string;
    function GetCorrectTemplateFileName(const Path, FileName: String): String; //by kordal
    function TryAddJControl(ControlsJava: TStringList; jclassname: string; out nativeAdded: boolean): boolean;
    procedure UpdateProjectLpr(oldModuleName: string; newModuleName: string);
    procedure InitSmartDesignerHelpers;
    procedure UpdateStartModuleVarName;
    procedure UpdateAllJControls(AProject: TLazProject);

    function IsDemoProject: boolean;
    procedure TryChangeDemoProjecPaths;
    procedure TryFindDemoPathsFromReadme(out pathToDemoNDK, pathToDemoSDK: string);

    function GetMaxNdkPlatform(ndkVer: integer): integer;

    function HasBuildTools(platform: integer; out outBuildTool: string): boolean;
    function GetMaxSdkPlatform(): integer;

    function GetVesionCodeFromBuilGradle(): string;
    function GetVesionNameFromBuilGradle(): string;

    procedure KeepBuildUpdated(targetApi: integer);

    function TryProduceGradleVersion(pathToGradle: string): string;
    function GetGradleVersion(pathToGradle: string): string;

    function GetLprStartModuleVarName: string;
    function TryChangePrebuildOSY(path: string): string;
    function TryChangeTo49x(path: string): string;
    function TryChangeTo49(path: string): string;
    function TryChangeNdkPlatformsApi(path: string; newNdkApi: integer): string;
    function IsSdkToolsAntEnable(path: string): boolean;
    procedure TryChangeDemoProjecAntBuildScripts();

    function GetPathToSmartDesigner(): string;
    procedure UpdateBuildModes();

    function TryGetNDKRelease(pathNDK: string): string;
    function GetNDKVersion(ndkRelease: string): integer;

    procedure TryUpdateMipmap();
    function GetVerAsString(aVers: integer): string;   //?? android

  protected
    function OnProjectOpened(Sender: TObject; AProject: TLazProject): TModalResult;
    function OnProjectSavingAll(Sender: TObject): TModalResult;

    function AddClicked(ADesigner: TIDesigner;
                 MouseDownComponent: TComponent; Button: TMouseButton;
                 Shift: TShiftState; X, Y: Integer;
                 var AComponentClass: TComponentClass;
                 var NewParent: TComponent): boolean;

  public
    destructor Destroy; override;
    procedure Init;
    procedure Init4Project(AProject: TLazProject);
    function IsLaz4Android(): boolean;

    // calleds from Designer/TAndroidWidgetMediator ::: TAndroidWidgetMediator.UpdateJControlsList;
    procedure UpdateJControls(ProjFile: TLazProjectFile; AndroidForm: TAndroidForm);

     //calleds from Designer/TAndroidWidgetMediator ::: TAndroidWidgetMediator.UpdateJControlsList;
    procedure UpdateFCLControls(ProjFile: TLazProjectFile; AndroidForm: TAndroidForm);
    procedure UpdateProjectStartModule(const NewName: string; moduleType: integer);
    procedure DoBuildGradle(minSdkApi: string; targetApi: string);

    function GetAndroidPluginVersion(gradleVersion: string; mainJavaVersion: string): string;  //new!
    function GetGradleVersionAsBigNumber(gradleVersionAsString: string): integer;
    function GetAndroidPluginVersionAsBigNumber(androidPluginVersionAsString: string): integer;


    procedure TryProduceJavaVersion(pathToJDK: string);

  end;

  function ReplaceChar(const query: string; oldchar, newchar: char): string;
  function IsAllCharNumber(pcString: PChar): Boolean;
  function TrimChar(query: string; delimiter: char): string;
  function NextPos(delimiter: char; initialPos: integer; str: string): integer;

var
  LamwSmartDesigner: TLamwSmartDesigner;

implementation

uses
  {$ifdef unix}BaseUnix,{$endif}
  {Controls,} Dialogs, {SrcEditorIntf,} LazIDEIntf, IDEMsgIntf, IDEExternToolIntf, CodeToolManager, CodeTree,
  CodeCache, {SourceChanger,} LinkScanner, Laz2_DOM, laz2_XMLRead, FileUtil,
  LazFileUtils, LamwSettings, uJavaParser, strutils, PackageIntf;

procedure SaveShellScript(script: TStringList; const AFileName: string);
begin
  script.SaveToFile(AFileName);
  {$ifdef UNIX}
  FpChmod(AFileName, &751);
  {$endif}
end;

procedure TryRunProcessChmod(path: string);
var
  proc: TProcess;  //don't delete it!
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
  if StrLen(pcString)=0 then exit;
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

//http://wiki.freepascal.org/Extending_the_IDE#Event_handlers
function TLamwSmartDesigner.AddClicked(ADesigner: TIDesigner;
             MouseDownComponent: TComponent; Button: TMouseButton;
             Shift: TShiftState; X, Y: Integer;
             var AComponentClass: TComponentClass;
             var NewParent: TComponent): boolean;
begin
  Result:= True;
  if LazarusIDE.ActiveProject.CustomData.Contains('LAMW') then
  begin
    if AComponentClass.InheritsFrom(TWinControl) then
    begin
      MessageDlg('Error: TWinControl Component',
                 '"'+AComponentClass.ClassName+'"'+sLineBreak+'not supported by LAMW project...',
                 mtError, [mbOK], 0);
      Exit;
    end;
    if AComponentClass.InheritsFrom(TLCLComponent) then
    begin
      case QuestionDlg ('Warning: LCL Component',
                        '"'+AComponentClass.ClassName+'"'+sLineBreak+'does not seem to be a LAMW component...',
                        mtCustom,[mrYes,'Continue', mrNo, 'Exit'],'') of
        mrNo:
        begin
          Result := False;
          Exit;
        end;
      end;
    end;

    if Pos('AppCompat.',LazarusIDE.ActiveProject.CustomData['Theme']) > 0 then
      Exit;

    if AComponentClass.ClassNameIs('jsFloatingButton') or
       AComponentClass.ClassNameIs('jsTextInput') or
       AComponentClass.ClassNameIs('jsRecyclerView') or
       AComponentClass.ClassNameIs('jsCardView') or
       AComponentClass.ClassNameIs('jsViewPager') or
       AComponentClass.ClassNameIs('jsDrawerLayout') or
       AComponentClass.ClassNameIs('jsNavigationView') or
       AComponentClass.ClassNameIs('jsAppBarLayout') or
       AComponentClass.ClassNameIs('jsTabLayout') or
       AComponentClass.ClassNameIs('jsToolBar') or
       AComponentClass.ClassNameIs('jsCoordenatorLayout') or
       AComponentClass.ClassNameIs('jsCollapsingToolbarLayout') or
       AComponentClass.ClassNameIs('jsNestedScrollView') or
       AComponentClass.ClassNameIs('jsBottomNavigationView') or
       AComponentClass.ClassNameIs('jsContinuousScrollableImageView') or
       AComponentClass.ClassNameIs('jsAdMod') or
       AComponentClass.ClassNameIs('jsFirebasePushNotificationListener') or
       AComponentClass.ClassNameIs('jsEscPosThermalPrinter') or
       AComponentClass.ClassNameIs('jsArduinoAflakSerial') or
       AComponentClass.ClassNameIs('KToyButton') then
     begin
       ShowMessage('[Undoing..] "'+AComponentClass.ClassName+'" need AppCompat theme...' +sLIneBreak+
                   'Hint:  You can convert the project to AppCompat theme:'  +sLIneBreak+
                   '       menu "Tools" --> "[LAMW]..." --> "Convert..."');
       Result:= False;
    end;
  end;
end;

function TLamwSmartDesigner.OnProjectOpened(Sender: TObject;
 AProject: TLazProject): TModalResult;
begin
  if AProject.CustomData.Contains('LAMW') then
  begin
     Init4Project(AProject);
  end;
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

function TLamwSmartDesigner.GetNDKVersion(ndkRelease: string): integer;
var
   strNdkVersion: string;
begin

    if Pos('.',ndkRelease) > 0 then //  //18.1.506304
    begin
      strNdkVersion:= SplitStr(ndkRelease, '.'); //strNdkVersion:='18'
      if strNdkVersion <> '' then
      begin
        Result:= StrToInt(Trim(strNdkVersion));
      end;
    end
    else Result:= 10; //r10e

end;

procedure TLamwSmartDesigner.TryUpdateMipmap();
var
  pathToJavaTemplates: string;
begin

  if DirectoryExists(FPathToAndroidProject +'res'+DirectorySeparator+'mipmap-mdpi')  then Exit;
  if LazarusIDE.ActiveProject.CustomData['CanCreateResMipmapFolder'] = 'NO' then Exit;

  if MessageDlg('Question', 'Do you wish to Create res/mipmap folders?',
                 mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      pathToJavaTemplates := LamwGlobalSettings.PathToJavaTemplates; //included path delimiter

      if ForceDirectories(FPathToAndroidProject +'res'+DirectorySeparator+'mipmap-xxxhdpi') then
      begin
        if ((not FileExists(FPathToAndroidProject + 'res' + DirectorySeparator + 'mipmap-xxxhdpi' +DirectorySeparator + 'ic_launcher.webp')) and
            (not FileExists(FPathToAndroidProject + 'res' + DirectorySeparator + 'mipmap-xxxhdpi' +DirectorySeparator + 'ic_launcher.png'))) then
        begin
          CopyFile(pathToJavaTemplates +'mipmap-xxxhdpi'+DirectorySeparator+'ic_launcher.webp',
                 FPathToAndroidProject + 'res'+DirectorySeparator+'mipmap-xxxhdpi'+DirectorySeparator+'ic_launcher.webp');
          CopyFile(pathToJavaTemplates +'mipmap-xxxhdpi'+DirectorySeparator+'ic_launcher_round.webp',
                 FPathToAndroidProject + 'res'+DirectorySeparator+'mipmap-xxxhdpi'+DirectorySeparator+'ic_launcher_round.webp');
        end;
      end;

      if ForceDirectories(FPathToAndroidProject +'res'+DirectorySeparator+'mipmap-xxhdpi') then
      begin
        if ((not FileExists(FPathToAndroidProject + 'res' + DirectorySeparator + 'mipmap-xxhdpi' +DirectorySeparator + 'ic_launcher.webp')) and
            (not FileExists(FPathToAndroidProject + 'res' + DirectorySeparator + 'mipmap-xxhdpi' +DirectorySeparator + 'ic_launcher.png'))) then
        begin
          CopyFile(pathToJavaTemplates +'mipmap-xxhdpi'+DirectorySeparator+'ic_launcher.webp',
                 FPathToAndroidProject + 'res'+DirectorySeparator+'mipmap-xxhdpi'+DirectorySeparator+'ic_launcher.webp');
          CopyFile(pathToJavaTemplates +'mipmap-xxhdpi'+DirectorySeparator+'ic_launcher_round.webp',
                 FPathToAndroidProject + 'res'+DirectorySeparator+'mipmap-xxhdpi'+DirectorySeparator+'ic_launcher_round.webp');
        end;
      end;

      if ForceDirectories(FPathToAndroidProject +'res'+DirectorySeparator+'mipmap-xhdpi') then
      begin
        if ((not FileExists(FPathToAndroidProject + 'res' + DirectorySeparator + 'mipmap-xhdpi' +DirectorySeparator + 'ic_launcher.webp')) and
            (not FileExists(FPathToAndroidProject + 'res' + DirectorySeparator + 'mipmap-xhdpi' +DirectorySeparator + 'ic_launcher.png'))) then
        begin
           CopyFile(pathToJavaTemplates +'mipmap-xhdpi'+DirectorySeparator+'ic_launcher.webp',
                 FPathToAndroidProject + 'res'+DirectorySeparator+'mipmap-xhdpi'+DirectorySeparator+'ic_launcher.webp');
           CopyFile(pathToJavaTemplates +'mipmap-xhdpi'+DirectorySeparator+'ic_launcher_round.webp',
                 FPathToAndroidProject + 'res'+DirectorySeparator+'mipmap-xhdpi'+DirectorySeparator+'ic_launcher_round.webp');
        end;
      end;

      if ForceDirectories(FPathToAndroidProject +'res'+DirectorySeparator+'mipmap-hdpi') then
      begin
        if ((not FileExists(FPathToAndroidProject + 'res' + DirectorySeparator + 'mipmap-hdpi' +DirectorySeparator + 'ic_launcher.webp')) and
            (not FileExists(FPathToAndroidProject + 'res' + DirectorySeparator + 'mipmap-hdpi' +DirectorySeparator + 'ic_launcher.png'))) then
        begin
            CopyFile(pathToJavaTemplates +'mipmap-hdpi'+DirectorySeparator+'ic_launcher.webp',
                     FPathToAndroidProject + 'res'+DirectorySeparator+'mipmap-hdpi'+DirectorySeparator+'ic_launcher.webp');
            CopyFile(pathToJavaTemplates +'mipmap-hdpi'+DirectorySeparator+'ic_launcher_round.webp',
                     FPathToAndroidProject + 'res'+DirectorySeparator+'mipmap-hdpi'+DirectorySeparator+'ic_launcher_round.webp');
        end;
      end;

      if ForceDirectories(FPathToAndroidProject +'res'+DirectorySeparator+'mipmap-mdpi') then
      begin
        if ((not FileExists(FPathToAndroidProject + 'res' + DirectorySeparator + 'mipmap-mdpi' +DirectorySeparator + 'ic_launcher.webp')) and
            (not FileExists(FPathToAndroidProject + 'res' + DirectorySeparator + 'mipmap-mdpi' +DirectorySeparator + 'ic_launcher.png'))) then
        begin
            CopyFile(pathToJavaTemplates +'mipmap-mdpi'+DirectorySeparator+'ic_launcher.webp',
                     FPathToAndroidProject + 'res'+DirectorySeparator+'mipmap-mdpi'+DirectorySeparator+'ic_launcher.webp');
            CopyFile(pathToJavaTemplates +'mipmap-mdpi'+DirectorySeparator+'ic_launcher_round.webp',
                     FPathToAndroidProject + 'res'+DirectorySeparator+'mipmap-mdpi'+DirectorySeparator+'ic_launcher_round.webp');
        end;
      end;

  end
  else LazarusIDE.ActiveProject.CustomData['CanCreateResMipmapFolder']:= 'NO';

end;

function TLamwSmartDesigner.TryGetNDKRelease(pathNDK: string): string;
var
   list: TStringList;
   aux, strNdkVersion: string;
begin
    list:= TStringList.Create;
    if FileExists(pathNDK+'source.properties') then
    begin
        list.LoadFromFile(pathNDK+'source.properties');
        {
           Pkg.Desc = Android NDK
           Pkg.Revision = 18.1.5063045
        }
        strNdkVersion:= list.Strings[1]; //Pkg.Revision = 18.1.5063045
        aux:= SplitStr(strNdkVersion, '='); //aux:= 'Pkg.Revision '   ...strNdkVersion:=' 18.1.506304'
        aux:=Trim(strNdkVersion); //18.1.506304
        Result:= aux;
    end
    else
    begin
       if FileExists(pathNDK+'RELEASE.TXT') then //r10e
       begin
         list.LoadFromFile(pathNDK+'RELEASE.TXT');
         if Trim(list.Strings[0]) = 'r10e' then
            Result:= 'r10e'
         else Result:= 'unknown';
       end;
    end;
    list.Free;
end;


function TLamwSmartDesigner.GetMaxNdkPlatform(ndkVer: integer): integer;
begin
   Result:= 22;
   case ndkVer of
      10: Result:= 21;
      11: Result:= 24;
      12: Result:= 24;
      13: Result:= 24;
      14: Result:= 24;
      15: Result:= 26;
      16: Result:= 27;
      17: Result:= 28;
      18: Result:= 28;
      19: Result:= 28;
      20: Result:= 29;
      21: Result:= 30;
      22: Result:= 30; //The deprecated "platforms" directories have been removed....
      23: Result:= 30;
   end;
end;

function TLamwSmartDesigner.GetMaxSdkPlatform(): integer;
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
                end;
              end;

         end;
       end;
    end;
  end;
  lisDir.free;
end;

function TLamwSmartDesigner.HasBuildTools(platform: integer;  out outBuildTool: string): boolean;
begin
  Result:= True;
  if  platform < 30 then
     outBuildTool:= '29.0.3'
  else
     outBuildTool:= '30.0.3';
end;

function TLamwSmartDesigner.GetVesionCodeFromBuilGradle(): string;
var
  list: TStringList;
  p: integer;
  aux: string;
begin
   Result:= '1';
   if FileExists(FPathToAndroidProject + 'build.gradle') then
   begin
     list:= TStringList.Create;
     list.LoadFromFile(FPathToAndroidProject + 'build.gradle');
     p:= Pos('versionCode', list.Text);
     aux:= Copy(list.Text, p + Length('versionCode') + 1, 10);
     aux:= Trim(aux);
     aux:= ReplaceChar(aux, #10, ' ');
     aux:= ReplaceChar(aux, #13, ' ');
     aux:= Trim(aux);
     Result:=aux;
   end;
end;

function TLamwSmartDesigner.GetVesionNameFromBuilGradle(): string;
var
  list: TStringList;
  p: integer;
  aux: string;
begin
   Result:= '"1.0"';

   if FileExists(FPathToAndroidProject + 'build.gradle') then
   begin
     list:= TStringList.Create;
     list.LoadFromFile(FPathToAndroidProject + 'build.gradle');
     p:= Pos('versionName', list.Text);
     aux:= Copy(list.Text, p + Length('versionName') + 1, 10);

     aux:= Trim(aux);
     aux:= ReplaceChar(aux, #10, ' ');
     aux:= ReplaceChar(aux, #13, ' ');
     aux:= Trim(aux);

     Result:=aux;
   end;
end;

function TLamwSmartDesigner.GetVerAsString(aVers: integer): string;
begin
  Result:= '';
  case aVers of
     34: Result:= 'android-UpsideDownCake';
  end;
end;

function TLamwSmartDesigner.GetAndroidPluginVersionAsBigNumber(androidPluginVersionAsString: string): integer;
var
  auxStr: string;
  lenAuxStr: integer;
begin
  auxStr:= StringReplace(androidPluginVersionAsString,'.', '', [rfReplaceAll]); //8.1.1
  lenAuxStr:=  Length(auxStr);
  if lenAuxStr < 3 then auxStr:= auxStr + '0';   //8.4 -> 840
  Result:= StrToInt(Trim(auxStr));  //811
end;

function TLamwSmartDesigner.GetGradleVersionAsBigNumber(gradleVersionAsString: string): integer;
var
  auxStr: string;
  lenAuxStr: integer;
begin
  auxStr:= StringReplace(gradleVersionAsString,'.', '', [rfReplaceAll]); //6.6.1
  lenAuxStr:=  Length(auxStr);
  if lenAuxStr < 3 then auxStr:= auxStr + '0';   //6.8 -> 680
  Result:= StrToInt(Trim(auxStr));  //661
end;

{
//https://developer.android.com/studio/releases/gradle-plugin?hl=pt-br
Android
plug-in
8.2.0  <--> Android Gradle plugin requiresJava 21   //Gradle versão 8.5
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
function TLamwSmartDesigner.GetAndroidPluginVersion(gradleVersion: string; mainJavaVersion: string): string;
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

procedure TLamwSmartDesigner.TryProduceJavaVersion(pathToJDK: string);
var
  list: TStringList;
  i, p, len: integer;
  version, aux, mainVersion: string;
begin
   list:= TStringList.Create;
   //list.LoadFromFile('C:\Program Files\Eclipse Adoptium\jdk-11.0.21.9-hotspot\release');
   //list.LoadFromFile('C:\Program Files\Java\jdk1.8.0_151\release');
   list.LoadFromFile(pathToJDK + PathDelim + 'release');
   aux:='';
   i:= 0;
   while (aux = '') and (i < list.Count) do
   begin
      p:= Pos('JAVA_VERSION=', list.Strings[i]);
      if p > 0 then
      begin
        aux:= list.Strings[i];
        i:= list.Count; //exit while
      end;
      i:= i + 1;
   end;
   if p > 0 then
   begin
     len:= Length('JAVA_VERSION=');
     version:= Trim(Copy(aux, p+len, 15));
     aux:= TrimChar(version, '"');
     FJavaBigVersion:= aux;  //11.0.21  or 1.8.0_151
     mainVersion:= SplitStr(aux, '.');  //main number: 11 or 17 or 21 or 1 (ex.: 1.8)
     FJavaMainVersion:=Trim(mainVersion);
   end;
   list.Free;
end;

procedure TLamwSmartDesigner.DoBuildGradle(minSdkApi: string; targetApi: string);
var
  strList, includeList: TStringList;
  directive, buildSystem, listInstructionChip: string;
  aAppCompatLib: TAppCompatLib;
  aSupportLib: TSupportLib;
  androidPluginVersion, targetBuildFileName: string;
  isAppCompatTheme, isGradleBuildSystem, isUniversalApk, isSignatureFound: boolean;
  versionCode, versionName: string;
  gradleVersionBigNumber: integer;
begin

  if FGradleVersion = '' then
  begin
    if FPathToGradle <> '' then
        FGradleVersion:= GetGradleVersion(FPathToGradle);
  end;

  gradleVersionBigNumber:= GetGradleVersionAsBigNumber(FGradleVersion);

  TryProduceJavaVersion(FPathToJavaJDK);
  androidPluginVersion:= GetAndroidPluginVersion(FGradleVersion, FJavaMainVersion); //'7.1.3';

  isAppCompatTheme:= False;
  if Pos('AppCompat', FAndroidTheme) > 0  then isAppCompatTheme:= True;

  buildSystem:= LazarusIDE.ActiveProject.CustomData['BuildSystem'];

  isGradleBuildSystem:= False;
  if Pos('Gradle',  buildSystem) > 0 then isGradleBuildSystem:= True;

  targetBuildFileName := ExtractFileName(LazarusIDE.ActiveProject.LazCompilerOptions.CreateTargetFilename);

  includeList:= TStringList.Create;
  includeList.Delimiter:= ',';
  includeList.StrictDelimiter:= True;
  includeList.Sorted:= True;
  includeList.Duplicates:= dupIgnore;

  if FileExists(FPathToAndroidProject + 'libs\armeabi\' + TargetBuildFileName ) then
  begin
    includeList.Add('''armeabi''');
  end;

  if FileExists(FPathToAndroidProject + 'libs\armeabi-v7a\' + TargetBuildFileName ) then
  begin
    includeList.Add('''armeabi-v7a''');
  end;

  if FileExists(FPathToAndroidProject + 'libs\arm64-v8a\' + TargetBuildFileName ) then
  begin
    includeList.Add('''arm64-v8a''');
  end;

  if FileExists(FPathToAndroidProject + 'libs\x86_64\' + TargetBuildFileName ) then
  begin
    includeList.Add('''x86_64''');
  end;

  if FileExists(FPathToAndroidProject + 'libs\x86\' + TargetBuildFileName ) then
  begin
    includeList.Add('''x86''');
  end;

  if FileExists(FPathToAndroidProject + 'libs\mips\' + TargetBuildFileName ) then
  begin
    includeList.Add('''mips''');
  end;

  listInstructionChip:= includeList.DelimitedText;

  isUniversalApk:= False;
  if includeList.Count > 1 then
    isUniversalApk:= True;

  versionCode := GetVesionCodeFromBuilGradle();
  versionName := GetVesionNameFromBuilGradle();

  strList:= TStringList.Create;
  isSignatureFound := false;
  if fileExists(FPathToAndroidProject+'gradle.properties') then
  begin
     strList.LoadFromFile(FPathToAndroidProject+'gradle.properties');
     if Pos('RELEASE_STORE_FILE', strList.Text) > 0 then
          isSignatureFound := True;
  end;

  //try update build.gradle
  strList.Clear;
  strList.Add('buildscript {');
  if FisKotlinSupported then
    strList.Add('    ext.kotlin_version = ''1.6.10''');
  strList.Add('    repositories {');
  strList.Add('        mavenCentral()');
  strList.Add('        google()');
  strList.Add('    }');
  strList.Add('    dependencies {');
  strList.Add('        classpath ''com.android.tools.build:gradle:'+androidPluginVersion+''' '); //7.1.3
  if FisKotlinSupported then
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

  if FisKotlinSupported then
   strList.Add('apply plugin: ''kotlin-android''');

  strList.Add('android {');

  if FJavaMainVersion <> '' then
  begin
    if StrToInt(FJavaMainVersion) >= 17 then
       if GetAndroidPluginVersionAsBigNumber(androidPluginVersion) >= 820 then
           strList.Add('    namespace "'+FPackageName+'"'); //org.lamw.applamwproject1
  end;
  strList.Add('    splits {');
  strList.Add('        abi {');
  strList.Add('            enable true');
  strList.Add('            reset()');
  strList.Add('            include '+listInstructionChip);
  if not isUniversalApk then
     strList.Add('            universalApk false')
  else
     strList.Add('            universalApk true');
  strList.Add('        }');
  strList.Add('    }');
  strList.Add('    compileOptions {');
  strList.Add('        sourceCompatibility 1.8');
  strList.Add('        targetCompatibility 1.8');
  strList.Add('    }');
  strList.Add('    compileSdk '+targetApi+'');

  strList.Add('    defaultConfig {');
  strList.Add('            minSdkVersion '+minSdkApi+'');
  strList.Add('            targetSdkVersion '+targetApi+'');
  strList.Add('            versionCode '+versionCode+'');
  strList.Add('            versionName '+versionName+''); //  " -> already included!
  strList.Add('            multiDexEnabled true');
  strList.Add('            ndk { debugSymbolLevel ''FULL'' }');
  strList.Add('    }');

  if isSignatureFound then
  begin
   strList.Add('    signingConfigs {');
   strList.Add('        release {');
   strList.Add('            storeFile file(RELEASE_STORE_FILE)');
   strList.Add('            storePassword RELEASE_STORE_PASSWORD');
   strList.Add('            keyAlias RELEASE_KEY_ALIAS');
   strList.Add('            keyPassword RELEASE_KEY_PASSWORD');
   strList.Add('        }');
   strList.Add('    }');
   strList.Add('    buildTypes {');
   strList.Add('        release {');
   strList.Add('            signingConfig signingConfigs.release');
   strList.Add('        }');
   strList.Add('    }');
  end;

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
  if isAppCompatTheme then
  begin
    for aAppCompatLib in AppCompatLibs do
    begin
       strList.Add('    '+directive+' '''+aAppCompatLib.Name+'''');
       if aAppCompatLib.MinAPI > StrToInt(targetApi) then
             ShowMessage('Warning: AppCompat theme need Android SDK >= ' + IntToStr(aAppCompatLib.MinAPI));
    end;
    if FisKotlinSupported then
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
       if aSupportLib.MinAPI > StrToInt(targetApi) then
             ShowMessage('Warning: Support library need Android SDK >= ' + IntToStr(aSupportLib.MinAPI));
    end;
  end;

  strList.Add('}');

  strList.Add('tasks.register(''run'', Exec) {');
  strList.Add(' dependsOn '':installDebug''');
  strList.Add('	if (System.properties[''os.name''].toLowerCase().contains(''windows'')) {');
  strList.Add('	    commandLine ''cmd'', ''/c'', ''adb'', ''shell'', ''am'', ''start'', ''-n'', "'+FPackageName+'/.App"');
  strList.Add('	} else {');
  strList.Add('	    commandLine ''adb'', ''shell'', ''am'', ''start'', ''-n'', "'+FPackageName+'/.App"');
  strList.Add('	}');
  strList.Add('}');
  strList.Add(' ');
  if gradleVersionBigNumber < 820 then
  begin
    strList.Add('wrapper {');
    strList.Add('    gradleVersion = '''+FGradleVersion+''' ');  //7.6.3
    strList.Add('}');
  end;
  strList.SaveToFile(FPathToAndroidProject+'build.gradle');
  strList.Free;
  includeList.Free;

  if MessageDlg('Question', '"build.gradle" success updated!'+sLineBreak+
                            '"Do you wish to update it again when re-open?',
                             mtConfirmation, [mbYes, mbNo],0) = mrNo then
  begin
     FKeepMyBuildGradleWhenReopen:= 'YES';
     LazarusIDE.ActiveProject.CustomData.Values['KeepMyBuildGradleWhenReopen']:= FKeepMyBuildGradleWhenReopen;
     LazarusIDE.ActiveProject.Modified:= True;
  end;

end;

//https://community.oracle.com/blogs/schaefa/2005/01/20/how-do-conditional-compilation-java
procedure TLamwSmartDesigner.KeepBuildUpdated(targetApi: integer);
var
  strList, providerList: TStringList;
  i, count, minSdkApi : integer;
  strTargetApi, auxStr, tempStr : string;
  linuxPathToAndroidSdk: string;
  linuxPathToGradle: string;
  linuxDirSeparator: string; //don't delete it!
  FSupport:boolean;
  sourcepath, targetpath:string;
  insertRef, supportProvider: string;
  p1 : integer;
begin

  strTargetApi:= IntTostr(targetApi);
  strList:= TStringList.Create;

  if not FileExists(FPathToAndroidProject + 'gradle.properties') then
  begin
    strList.SaveToFile(FPathToAndroidProject+'gradle.properties');
  end;
  strList.Clear;

  if FPathToGradle <> '' then
       FGradleVersion:= GetGradleVersion(FPathToGradle);

  //Android Studio compatiblity
  if not DirectoryExists(FPathToAndroidProject+'gradle') then
  begin
    CreateDir(FPathToAndroidProject+'gradle');
    ForceDirectories(FPathToAndroidProject+'gradle'+DirectorySeparator+'wrapper');
  end;
  StrList.Clear;
  strList.Add('distributionBase=GRADLE_USER_HOME');
  strList.Add('distributionPath=wrapper/dists');
  strList.Add('distributionUrl=https\://services.gradle.org/distributions/gradle-'+FGradleVersion+'-bin.zip');  //8.2.1
  strList.Add('networkTimeout=10000');
  strList.Add('zipStoreBase=GRADLE_USER_HOME');
  strList.Add('zipStorePath=wrapper/dists');
  strList.SaveToFile(FPathToAndroidProject+'gradle'+DirectorySeparator+'wrapper'+DirectorySeparator+'gradle-wrapper.properties');

  targetpath:=ConcatPaths([FPathToAndroidProject,'res','values']);
  ForceDirectories(targetpath);

  strList.Clear;
  sourcepath:=ConcatPaths([LamwGlobalSettings.PathToJavaTemplates,'values'])+DirectorySeparator +'colors.xml';
  if FileExists(sourcepath) then
  begin
     if not FileExists(targetpath+DirectorySeparator+'colors.xml') then
     begin
       strList.LoadFromFile(sourcepath);
       ForceDirectories(targetpath);
       strList.SaveToFile(targetpath+DirectorySeparator+'colors.xml');
     end;
  end;

  FSupport:= (LazarusIDE.ActiveProject.CustomData.Values['Support']='TRUE');

  if Pos('AppCompat', FAndroidTheme) > 0 then
  begin
     LazarusIDE.ActiveProject.CustomData.Values['Support']:='TRUE';
     FSupport:= True;
  end;


  if not FileExists(targetpath+DirectorySeparator+'styles.xml') then
  begin
    if Pos('AppCompat', FAndroidTheme) > 0 then
    begin
       if FileExists(LamwGlobalSettings.PathToJavaTemplates+'values'+DirectorySeparator+FAndroidTheme+'.xml') then
       begin
          CopyFile(LamwGlobalSettings.PathToJavaTemplates+'values'+DirectorySeparator+FAndroidTheme+'.xml',
                     targetpath+DirectorySeparator+'styles.xml');
       end;
    end
    else
    begin
       if FileExists(LamwGlobalSettings.PathToJavaTemplates+'values'+DirectorySeparator +'styles.xml') then
       begin
          strList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'values'+DirectorySeparator +'styles.xml');
          strList.SaveToFile(targetpath+DirectorySeparator+'styles.xml');
       end;
    end;

  end;

  if Pos('AppCompat',  FAndroidTheme) > 0 then
     minSdkApi:= 21
  else
     minSdkApi:= 14;

  auxStr:= LazarusIDE.ActiveProject.CustomData['MinSdk'];             //new

  if auxStr <> '' then
  begin
     FMinSdkControl:= StrToInt(auxStr);
  end
  else
  begin
    FMinSdkControl:= minsdkApi;
    LazarusIDE.ActiveProject.CustomData['MinSdk']:= IntToStr(FMinSdkControl);
    LazarusIDE.ActiveProject.Modified:= True;
  end;

  if  minsdkApi < FMinSdkControl then
      minsdkApi:= FMinSdkControl;

  sourcepath:=LamwGlobalSettings.PathToJavaTemplates+'androidmanifest.txt';
  targetpath:=FPathToAndroidProject+'AndroidManifest.xml';

  if not FileExists(targetpath) then
  begin
    if FileExists(sourcepath) then
    with strList do
    begin
      LoadFromFile(sourcepath);
      auxStr:=FPackageName + '.' + LowerCase(FSmallProjName);
      tempStr  := StringReplace(Text, 'dummyPackage',auxStr, [rfReplaceAll, rfIgnoreCase]);
      tempStr  := StringReplace(tempStr, 'dummyAppName','.App', [rfReplaceAll, rfIgnoreCase]);
      Clear;
      Text:= tempStr;
      SaveToFile(targetpath);
    end;
  end;

  strList.Clear;
  //***
  if FileExists(FPathToAndroidProject+'AndroidManifest.xml') then
  begin
    strList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
    if LazarusIDE.ActiveProject.CustomData['BuildSystem'] = 'Gradle' then  // Delete <uses-sdk
    begin
      if Pos('<uses-sdk', strList.Text) > 0 then
      begin
        for i := 0 to strList.Count - 1 do
        begin
          if Pos('<uses-sdk', strList.Strings[i]) > 0 then
          begin
            strList.Delete(i);
            strList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
            break;
          end;
        end;
      end;
    end
    else //Ant builder need it.....
    begin
      if Pos('<uses-sdk', strList.Text) <= 0 then
      begin
         for i := 0 to strList.Count - 1 do
         begin
           if Pos('<uses-permission', strList.Strings[i]) > 0 then
           begin
             strList.Insert(i, '    <uses-sdk android:minSdkVersion="'+IntToStr(minsdkApi)+'" android:targetSdkVersion="'+strTargetApi+'"/>');
             strList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
             break;
           end;
         end;
      end
    end;
  end;

  if (FSupport) or (Pos('AppCompat', FAndroidTheme) > 0) then
  begin
    strList.Clear;
    if FileExists(FPathToAndroidProject+'AndroidManifest.xml') then
    begin
      strList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
      if Pos('android.support.v4.content.FileProvider', strList.Text) > 0 then //update to androidX
      begin
         tempStr:= StringReplace(strList.Text, 'android.support.v4.content.FileProvider','androidx.core.content.FileProvider', [rfReplaceAll, rfIgnoreCase]);
         strList.Clear;
         strList.Text:= tempStr;
         strList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
      end
      else
      begin
         if FileExists(LamwGlobalSettings.PathToJavaTemplates +'support'+DirectorySeparator+'manifest_support_provider.txt') then
         begin
           providerList:= TStringList.Create;
           providerList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates +'support'+DirectorySeparator+'manifest_support_provider.txt');
           supportProvider  := StringReplace(providerList.Text, 'dummyPackage',FPackageName, [rfReplaceAll, rfIgnoreCase]);
           providerList.Free;
           if Pos('androidx.core.content.FileProvider', strList.Text) <= 0 then
           begin
             tempStr:= strList.Text;  //manifest
             insertRef:= '</activity>'; //insert reference point
             p1:= Pos(insertRef, tempStr);
             Insert(sLineBreak + supportProvider, tempStr, p1+Length(insertRef) );
             strList.Clear;
             strList.Text:= tempStr;
             strList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
           end;
         end;
      end;
    end;
  end;

  strList.Clear;
  if FileExists(FPathToAndroidProject+'AndroidManifest.xml') then
  begin
    strList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
    tempStr:= strList.Text;
    if Pos('android:exported="true"', tempStr) <= 0 then
    begin
     tempStr:= StringReplace(tempStr, 'android:enabled="true"' , 'android:enabled="true" android:exported="true"', [rfReplaceAll,rfIgnoreCase]);
     strList.Text:= tempStr;
     strList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
    end;
  end;

  strList.Clear;
  if FileExists(FPathToAndroidProject+'AndroidManifest.xml') then
  begin
    strList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
    if Pos('ScopedStorage', strList.Text) <= 0 then
    begin
      for i := 0 to strList.Count - 1 do
      begin
          if Pos('<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE', strList.Strings[i]) > 0 then
          begin
            strList.Strings[i]:= '    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" tools:remove="android:maxSdkVersion" tools:ignore="ScopedStorage"/>';

            if Pos('MANAGE_EXTERNAL_STORAGE', strList.Text) <= 0 then
            begin
              strList.Insert(i, '    <uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE"/>');
            end;

            strList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
            break;
          end;
      end;
    end;
  end;

  strList.Clear;
  if FileExists(FPathToAndroidProject+'AndroidManifest.xml') then
  begin
    strList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
    tempStr:= strList.Text;
    if Pos('xmlns:tools=', strList.Text) <= 0 then
    begin
      tempStr:= StringReplace(tempStr, 'xmlns:android="http://schemas.android.com/apk/res/android"', 'xmlns:android="http://schemas.android.com/apk/res/android" xmlns:tools="http://schemas.android.com/tools"', [rfReplaceAll,rfIgnoreCase]);
      strList.Text:= tempStr;
      strList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
    end;
  end;

  strList.Clear;
  if FileExists(FPathToAndroidProject+'AndroidManifest.xml') then
  begin
    strList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
    tempStr:= strList.Text;
    if Pos('QUERY_ALL_PACKAGES', strList.Text) > 0 then
    begin
      tempStr:= StringReplace(tempStr, '<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES"/>', '', [rfReplaceAll,rfIgnoreCase]);
      strList.Text:= tempStr;
      strList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
    end;
  end;

  //ant build.xml
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

  //project.properties
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
  strList.Add('sdk.dir=' + FPathToAndroidSDK);
  strList.Add('ndk.dir=' + FPathToAndroidNDK);

  //local.properties
  {$IFDEF WINDOWS}
  tempStr:= strList.Text;
  tempStr:= StringReplace(tempStr, '\', '\\', [rfReplaceAll]);
  tempStr:= StringReplace(tempStr, ':', '\:', [rfReplaceAll]);
  strList.Text:=tempStr;
  {$ENDIF}
  strList.SaveToFile(FPathToAndroidProject+'local.properties');

  //begin "build.grade" update
  FKeepMyBuildGradleWhenReopen:= LazarusIDE.ActiveProject.CustomData.Values['KeepMyBuildGradleWhenReopen'];

  if FKeepMyBuildGradleWhenReopen = 'NO' then
  begin
   DoBuildGradle(IntToStr(minSdkApi), strTargetApi);
  end;

  //Keep my "build.gradle" when re-open
  if FKeepMyBuildGradleWhenReopen = '' then //before LAMW 0.8.6.3
  begin
     if MessageDlg('Question', 'Do you wish update "build.gradle" automatically?',
         mtConfirmation, [mbYes, mbNo],0) = mrYes then
     begin
        DoBuildGradle(IntToStr(minSdkApi), strTargetApi);
        FKeepMyBuildGradleWhenReopen:= 'NO';
     end
     else FKeepMyBuildGradleWhenReopen:= 'YES';

     LazarusIDE.ActiveProject.CustomData.Values['KeepMyBuildGradleWhenReopen']:= FKeepMyBuildGradleWhenReopen ;
     LazarusIDE.ActiveProject.Modified:= True;
  end;

  //end "build.grade" update

   strList.Clear;
   if fileExists(FPathToAndroidProject+'gradle.properties') then
   begin
     strList.LoadFromFile(FPathToAndroidProject+'gradle.properties');

     //gradle.properties
      (*
        the ideal would be to use only AndroidX dependencies but you can do
        "android.enableJetifier=true"  in the gradle.properties file
        while you migrate your entire project and its dependencies to AndroidX
        (see https://developer.android.com/jetpack/androidx/migrate).
      *)
      if pos('android.enableJetifier=true', strList.text) = 0 then
        strList.Add('android.enableJetifier=true');

      if pos('android.useAndroidX', strList.text) = 0 then
        strList.Add('android.useAndroidX=true');

      //TODO
      {
      strList.Add('android.defaults.buildfeatures.buildconfig=true');
      strList.Add('android.nonFinalResIds=false');
      strList.Add('android.nonTransitiveRClass=false');
      }

     //apply change suggested by DonAlfred
     tempStr:=FPathToJavaJDK;
     {$ifdef MSWindows}
     tempStr:=StringReplace(tempStr,'\','\\',[rfReplaceAll]);
     tempStr:=StringReplace(tempStr,':','\:',[]);
     {$endif}
     if Pos('org.gradle.java.home=', strList.Text ) <= 0 then
     begin
         strList.Add('org.gradle.java.home='+tempStr);
     end
     else
     begin
       i:= 0;
       count:= strList.Count;
       while i < count do
       begin
          if Pos('org.gradle.java.home=', strList.Strings[i]) > 0 then
          begin
            strList.Strings[i]:= 'org.gradle.java.home='+tempStr;
            i:= count;
          end;
          i:= i + 1;
       end;
     end;

     strList.SaveToFile(FPathToAndroidProject+'gradle.properties');
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
   strList.Add('gradle clean bundle --info');
   strList.SaveToFile(FPathToAndroidProject+'gradle-local-build-bundle.bat');


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
   strList.Add('. ~/.bashrc');
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
   strList.Add('. ~/.bashrc');
   strList.Add('gradle clean bundle --info');
   SaveShellScript(strList, FPathToAndroidProject + 'gradle-local-build-bundle.sh');

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
   SaveShellScript(strList, FPathToAndroidProject+'gradle-local-run.sh');

   strList.Free;
end;


function TLamwSmartDesigner.TryProduceGradleVersion(pathToGradle: string): string;
var
   AProcess: TProcess;
   AStringList: TStringList;
   gradle, ext, version, aux: string;
   i, p, len, posFinal, count: integer;
begin
  ext:='';
  {$IFDEF windows}
    ext:='.bat';
  {$Endif}
  gradle:= 'gradle'  + ext;

  AStringList:= TStringList.Create;

  AProcess := TProcess.Create(nil);
  AProcess.Executable := pathToGradle + PathDelim + 'bin' + PathDelim + gradle;  //C:\android\gradle-6.8.3\bin\gradle.bat
  AProcess.Options:=AProcess.Options + [poWaitOnExit, poUsePipes, poNoConsole];
  AProcess.Parameters.Add('-version');


  Application.ProcessMessages;
  Screen.Cursor:= crHourGlass;
  try
    AProcess.Execute;
    AStringList.LoadFromStream(AProcess.Output);
  finally
    AProcess.Free;
    Screen.Cursor:= crDefault;
  end;

  if AStringList.Count > 0 then
  begin
    version:= '';
    i:= 0;
    while i < AStringList.Count do
    begin
       p:= Pos('Gradle', AStringList.Strings[i] );
       if p > 0 then
       begin
          version:=  AStringList.Strings[i];
          i:= AStringList.Count; //exit while
       end;
       i:= i +1;
    end;
    posFinal:= LastDelimiter('.', version) + 1; //posFinal
    len:= Length('Gradle');
    count:= posFinal - len;
    aux:= Copy(version, p+len, count);

    Result:= Trim(StringReplace(aux,'!', '', [rfReplaceAll])); //mess ??

    AStringList.Clear;
    AStringList.Text:= Result; //6.6.1    striped version!

    AStringList.SaveToFile(pathToGradle + PathDelim + 'version.txt');
  end;
  AStringList.Free;
end;

function TLamwSmartDesigner.GetGradleVersion(pathToGradle:string): string;
var
   list: TStringList;
begin
    if not FileExists(pathToGradle+PathDelim+'version.txt') then
    begin
      Result:= TryProduceGradleVersion(pathToGradle);
    end
    else
    begin
        list:=TStringList.Create;
        list.LoadFromFile(pathToGradle+PathDelim+'version.txt');
        Result:= Trim(list.Text);
        list.Free;
    end;
    if Result = '' then
    begin
        list:=TStringList.Create;
        list.Text:= Trim(InputBox('warning: Missing Gradle Version', 'Enter Gradle version [ex. 7.6.3]',''));
        if Pos('.', list.Text)  > 0 then
        begin
          Result:= list.Text;
          list.SaveToFile(pathToGradle+PathDelim+'version.txt');
        end;
        list.Free;
    end;
end;

function TLamwSmartDesigner.IsLaz4Android(): boolean;
var
  pathToConfig, pathToLaz: string;
  p: integer;
begin
 Result:= False;
 {$ifdef windows}
 pathToConfig:= LazarusIDE.GetPrimaryConfigPath();
 p:= Pos('config',pathToConfig);
 if p > 0 then
 begin
   pathToLaz:= Copy(pathToConfig,1,p-1);
   if FileExists(pathToLaz+'laz4android_readme.txt') then
     Result:= True;
 end;
 {$endif}
end;

procedure TLamwSmartDesigner.Init4Project(AProject: TLazProject);
var
  tempStr, auxFNdkApi: string;
  p: integer;
  isProjectImported: boolean;
  sdkTargetApi: string;
  intTargetApi : integer;
  isBrandNew: boolean;
  projectTarget, projectCustom, alertMsg: string;
  ndkRelease, aux: string;
  tryKotlin: string;
begin
  if AProject.CustomData.Contains('LAMW') then
  begin
    FPathToAndroidSDK := LamwGlobalSettings.PathToAndroidSDK; //Included Path Delimiter!
    FPathToAndroidNDK := LamwGlobalSettings.PathToAndroidNDK; //Included Path Delimiter!
    FPathToJavaJDK:=     LamwGlobalSettings.PathToJavaJDK;    //Included Path Delimiter!

    FPrebuildOSYS:= LamwGlobalSettings.PrebuildOSYS;
    FPathToSmartDesigner:= LamwGlobalSettings.PathToSmartDesigner;

    FAndroidTheme:= AProject.CustomData['Theme'];

    tryKotlin:= AProject.CustomData['TryKotlin'];

    FIsKotlinSupported:= False;
    if tryKotlin = 'TRUE' then
       FIsKotlinSupported:= True;

    ndkRelease:= LamwGlobalSettings.GetNDKRelease;
    if ndkRelease <> '' then
    begin
      FNDKVersion:= GetNDKVersion(ndkRelease);
    end
    else
    begin
      ndkRelease:= TryGetNDKRelease(FPathToAndroidNDK);
      FNDKVersion:= GetNDKVersion(ndkRelease); //18
    end;

    FChipArchitecture:= 'x86';
    aux := LowerCase(LazarusIDE.ActiveProject.LazCompilerOptions.CustomOptions);
    if Pos('-cparmv6', aux) > 0 then FChipArchitecture:= 'armeabi'
    else if Pos('-cparmv7a', aux) > 0 then FChipArchitecture:= 'armeabi-v7a'
    else if Pos('-xpaarch64', aux) > 0 then FChipArchitecture:= 'arm64-v8a'
    else if Pos('-xpx86_64', aux) > 0 then FChipArchitecture:= 'x86_64'
    else if Pos('-xpmipsel', aux) > 0 then FChipArchitecture:= 'mips';

    FProjFile := AProject.MainFile; //save ...

    FNdkApi:= AProject.CustomData['NdkApi']; //android-22
    auxFNdkApi:= FNdkApi;
    tempStr:= SplitStr(auxFNdkApi, '-');   //now  FNdkApi = 22 !

    isBrandNew:= False;

    if (AProject.CustomData['LamwVersion'] = '') and (FAndroidTheme <> '') then
      isBrandNew:= True;

    if AProject.CustomData['LamwVersion'] <> LamwGlobalSettings.Version then
    begin
      AProject.Modified := True;
      AProject.CustomData['LamwVersion'] := LamwGlobalSettings.Version;
      UpdateAllJControls(AProject);
    end;

    //warning: Lazarus 2.0.12 dont read anymore  *.lpi  from Lazarus 2.2!
    FPathToAndroidProject := ExtractFilePath(AProject.MainFile.Filename);
    FPathToAndroidProject := Copy(FPathToAndroidProject, 1, RPosEX(PathDelim, FPathToAndroidProject, Length(FPathToAndroidProject) - 1));

    tempStr:= Copy(FPathToAndroidProject, 1, Length(FPathToAndroidProject)-1);
    p:= LastDelimiter(PathDelim, tempStr) + 1;
    FSmallProjName:= Copy(tempStr,  p, Length(tempStr));
    FPackageName := AProject.CustomData['Package'];

    if FPackageName = '' then
    begin
      FPackageName := GetPackageNameFromAndroidManifest(FPathToAndroidProject);
      AProject.CustomData['Package'] := FPackageName;
    end;
    FPathToJavaSource:= FPathToAndroidProject + 'src' + PathDelim + AppendPathDelim(ReplaceChar(FPackageName, '.', PathDelim));

    if  (FAndroidTheme = '') or (Pos('AppCompat', FAndroidTheme) <= 0) then
      LamwGlobalSettings.QueryPaths:= False;  //dont query Path to Gradle

    FPathToGradle:= LamwGlobalSettings.PathToGradle;  //C:\adt32\gradle-3.3\
    LamwGlobalSettings.QueryPaths:= True; // reset to default...

    if not isBrandNew then
    begin
      isProjectImported:= IsDemoProject();   //demo or imported project,  etc...
      if not DirectoryExists(FPathToAndroidProject + 'lamwdesigner') then //very very old project
      begin
         InitSmartDesignerHelpers;
      end;
    end
    else isProjectImported:= False;

    //try fix/repair project paths [demos, etc..] in "Run" --> "build"  time ...
    if isProjectImported then
    begin
      TryChangeDemoProjecPaths();
      TryChangeDemoProjecAntBuildScripts();
    end;

    if AProject.CustomData['BuildSystem'] = 'Ant' then
    begin
      if not IsSdkToolsAntEnable(FPathToAndroidSDK) then
         AProject.CustomData['BuildSystem']:= 'Gradle';
    end;

    if not isBrandNew then
    begin

      TryUpdateMipmap();

      AProject.CustomData.Values['NdkPath']:= FPathToAndroidNDK;
      AProject.CustomData.Values['SdkPath']:= FPathToAndroidSDK;
      AProject.Modified:= True;

      if AProject.CustomData['BuildSystem'] = '' then
      begin
        if IsSdkToolsAntEnable(FPathToAndroidSDK) then
          AProject.CustomData['BuildSystem']:= 'Ant'
        else
          AProject.CustomData['BuildSystem']:= 'Gradle';

        AProject.Modified:= True;
      end
      else
      begin
        if AProject.CustomData['BuildSystem'] = 'Ant' then
           if not IsSdkToolsAntEnable(FPathToAndroidSDK) then
           begin
             AProject.CustomData['BuildSystem']:= 'Gradle';
             AProject.Modified:= True;
           end;
      end;

      if AProject.CustomData['Theme'] = '' then
      begin
        AProject.CustomData['Theme']:= 'DeviceDefault';
        AProject.Modified:= True;
      end;

      sdkTargetApi := AProject.CustomData['TargetSdk'];

      if length(sdkTargetApi) <= 0 then
      begin
       sdkTargetApi:= IntToStr( GetMaxSdkPlatform() );
       AProject.CustomData['TargetSdk']:= sdkTargetApi;
       AProject.Modified:= True;
      end;

      if IsAllCharNumber(PChar(sdkTargetApi))  then
          intTargetApi:= StrToInt(sdkTargetApi)
      else intTargetApi:= cMaxApi;

      if intTargetApi < 33 then
      begin
        ShowMessage('Warning. Minimum Target API required by "Google Play Store" = 33'+ sLineBreak +
                     'Please, update your android sdk/platforms folder!' + sLineBreak +
                     'How to:'+ sLineBreak +
                     '.open a command line terminal and go to folder "sdk/tools/bin"'+ sLineBreak +
                     '.run the command> sdkmanager --update'+ sLineBreak +
                     '.run the command> sdkmanager "build-tools;33.0.2" "platforms;android-33"');
      end;

      KeepBuildUpdated(intTargetApi);

      if Self.IsLaz4Android() then
      begin
         projectCustom:= UpperCase(AProject.LazCompilerOptions.CustomOptions);
         projectTarget:= AProject.LazCompilerOptions.TargetCPU;  //aarch64 or arm or i386 or mipsel
         alertMsg:= '';
         if Pos('aarch64', projectTarget) > 0  then
            alertMsg:= 'WARNING: Target CPU "aarch64" need "Laz4Android 2.0.12" or up..';

         if Pos('VFPV3', projectCustom) > 0  then
            alertMsg:= 'WARNING: Custom Option "-CfVFPV3" not supported '+sLineBreak+
                       '[out-of-box] by Laz4Android'+sLineBreak+ sLineBreak+
                       'Hint: "Project" --> "Project Option" -->'+sLineBreak+'"[LAMW] Android Project Options" --> "Build"'+sLineBreak+
                       'change -CfVFPV3 to -CfSoft'+sLineBreak+
                       sLineBreak+'[Ctrl+c to Copy to Clipboard]';

         if alertMsg <> '' then
            ShowMessage(alertMsg);

      end;
      UpdateBuildModes();
    end; //not is brandNews
  end;
end;

function TLamwSmartDesigner.IsSdkToolsAntEnable(path: string): boolean;
begin          //C:\adt32\sdk\tools\ant
  Result:= False;
  if DirectoryExists(path + 'tools' + PathDelim + 'ant') then
  begin
     Result:= True;
  end;
end;

// calleds from Designer/TAndroidWidgetMediator ::: TAndroidWidgetMediator.UpdateJControlsList;
procedure TLamwSmartDesigner.UpdateJControls(ProjFile: TLazProjectFile;
  AndroidForm: TAndroidForm);
var
  jControls: TStringList;
  i: Integer;
  c: TComponent;
  temp: string;
begin
  if (ProjFile = nil) or (AndroidForm = nil) then Exit;
  jControls := TStringList.Create;
  jControls.Sorted := True;
  jControls.Duplicates := dupIgnore;

  FAndroidTheme:= LazarusIDE.ActiveProject.CustomData['Theme'];

  jControls.Add('jForm');

  for i := 0 to AndroidForm.ComponentCount - 1 do
  begin
    c := AndroidForm.Components[i];
    if c is jControl then
    begin
       temp:= c.ClassName;  //Fixed JPaintShader.pas -->  jPaintShader.java
       if temp[1] = 'J' then temp[1]:= LowerCase(temp[1]);
       jControls.Add(temp);
    end;
    //else if Pos(c.ClassName, fclList.Text) > 0 then jControls.Add(c.ClassName); //else if c.ClassName = 'TFPNoGUIGraphicsBridge' then
  end;
  jControls.Delimiter := ';';
  ProjFile.CustomData['jControls'] := jControls.DelimitedText;
  jControls.Free;
end;


procedure TLamwSmartDesigner.UpdateFCLControls(ProjFile: TLazProjectFile;
  AndroidForm: TAndroidForm);
var
  fclControls: TStringList;
  fclList: TStringList;
  i: Integer;
  c: TComponent;
  pathToFclBridges: string;
begin
  if (ProjFile = nil) or (AndroidForm = nil) then Exit;

  FPathToSmartDesigner:=  GetPathToSmartDesigner();
  pathToFclBridges:= FPathToSmartDesigner + PathDelim +  'fcl' + pathDelim;

  fclList:=  TStringList.Create;

  if FileExists(pathToFclBridges+'fcl_bridges.txt') then
     fclList.LoadFromFile(pathToFclBridges+'fcl_bridges.txt');

  fclControls := TStringList.Create;
  fclControls.Sorted := True;
  fclControls.Duplicates := dupIgnore;
  fclControls.Delimiter := ';';
  for i:= 0 to AndroidForm.ComponentCount - 1 do
  begin
    c:= AndroidForm.Components[i];
    if Pos(c.ClassName, fclList.Text) > 0 then fclControls.Add(c.ClassName);
  end;
  ProjFile.CustomData['fclControls']:= fclControls.DelimitedText;
  fclControls.Free;
  fclList.Free;
end;

procedure TLamwSmartDesigner.UpdateProjectStartModule(const NewName: string; moduleType: integer);
var
  cb: TCodeBuffer;
  IdentList: TStringList;
  OldName: string;
begin
  if not FProjFile.IsPartOfProject then Exit;

  OldName := LazarusIDE.ActiveProject.CustomData['StartModule'];

  if OldName = '' then
  begin
     OldName := 'AndroidModule1'
  end;

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

  contentList:= FindAllFiles(FPathToJavaSource, '*.java', False);
  for i:= 0 to contentList.Count-1 do
  begin
    fileName:= ExtractFileName(contentList.Strings[i]); //not delete custom java code [support to jActivityLauncher]
    if FileExists(LamwGlobalSettings.PathToJavaTemplates + fileName) then
    begin
       DeleteFile(contentList.Strings[i]);
    end;
  end;
  contentList.Free;

  contentList:= FindAllFiles(FPathToJavaSource, '*.kt', False);
  for i:= 0 to contentList.Count-1 do
  begin
    fileName:= ExtractFileName(contentList.Strings[i]); //not delete custom java code [support to jActivityLauncher]
    if FileExists(LamwGlobalSettings.PathToJavaTemplates + fileName) then
    begin
       DeleteFile(contentList.Strings[i]);
    end;
  end;
  contentList.Free;

  contentList := FindAllFiles(FPathToAndroidProject+'lamwdesigner', '*.native', False);
  for i:= 0 to contentList.Count-1 do
  begin
    DeleteFile(contentList.Strings[i]);
  end;
  contentList.Free;

end;

procedure TLamwSmartDesigner.GetAllJControlsFromForms(jControlsList: TStrings);
var
  list: TStringList;
  i: integer;
  data: string;
begin
  list := TStringList.Create;
  list.Delimiter := ';';
  with LazarusIDE.ActiveProject do
    for i := 0 to FileCount - 1 do
    begin
      if Files[i].IsPartOfProject then
      begin
        data:=  Files[i].CustomData['jControls'];
        if data <> '' then
        begin
          list.DelimitedText := data;
          jControlsList.AddStrings(list);
        end;
      end;
    end;
  list.Free;
end;

procedure TLamwSmartDesigner.AddSupportToFCLControls(chipArch: string);
var
  fileList, controlsList, auxList, fclList: TStringList;
  i, j, p: integer;
  pathToNdkApiPlatforms, pathToFclBridges, androidNdkApi, arch, aux: string;
begin

  FPathToSmartDesigner:=  GetPathToSmartDesigner();
  pathToFclBridges:= FPathToSmartDesigner + PathDelim +  'fcl' + pathDelim;

  fclList:= TStringList.Create;
  if FileExists(pathToFclBridges + 'fcl_bridges.txt') then
    fclList.LoadFromFile(pathToFclBridges + 'fcl_bridges.txt');

  fileList:= TStringList.Create;
  fileList.Delimiter := ';';

  controlsList := TStringList.Create;
  controlsList.Sorted := True;
  controlsList.Duplicates := dupIgnore;

  with LazarusIDE.ActiveProject do
    for i := 0 to FileCount - 1 do
    begin
      fileList.DelimitedText := Files[i].CustomData['fclControls'];
      controlsList.AddStrings(fileList);
    end;

  auxList:= TStringList.Create;
  for j:= 0 to fclList.Count - 1 do
  begin
     if controlsList.IndexOf(fclList.Strings[j]) >= 0 then  //TFPNoGUIGraphicsBridge
     begin
         if FileExists(pathToFclBridges + fclList.Strings[j] + '.libso') then //TFPNoGUIGraphicsBridge.libso
         begin
            auxList.LoadFromFile(pathToFclBridges + fclList.Strings[j]+'.libso');

            CopyFile(pathToFclBridges+'libso'+PathDelim+chipArch+PathDelim+auxList.Strings[0],   //'libfreetype.so',
                     FPathToAndroidProject+'libs'+PathDelim+
                     chipArch+PathDelim+auxList.Strings[0]); //'libfreetype.so'

            //Added support to TFPNoGUIGraphicsBridge ... TMySQL57Bridge ... etc
            androidNdkApi:= LazarusIDE.ActiveProject.CustomData.Values['NdkApi']; //android-13 or android-14 or ...NDK- for NDK > 21

            if androidNdkApi <> '' then
            begin
              if FNDKVersion < 22 then
              begin
                    arch:= 'arch-x86';
                    if Pos('armeabi', chipArch) > 0 then arch:= 'arch-arm'
                    else if Pos('arm64', chipArch) > 0 then arch:= 'arch-arm64'
                    else if Pos('mips', chipArch) > 0 then arch:= 'arch-mips'
                    else if Pos('86_64', chipArch) > 0 then arch:= 'arch-x86_64';

                    pathToNdkApiPlatforms:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                                      androidNdkApi +DirectorySeparator+arch+DirectorySeparator+
                                                      'usr'+DirectorySeparator+'lib';

                    //need by linker!  //C:\adt32\ndk10e\platforms\android-21\arch-arm\usr\lib\libmysqlclient.so
                    CopyFile(pathToFclBridges+'libso'+PathDelim+chipArch+PathDelim+auxList.Strings[0],
                              pathToNdkApiPlatforms+PathDelim+auxList.Strings[0]);

              end
              else //NDK >= 22
              begin
                arch:= 'i686-linux-android';
                if Pos('armeabi', chipArch) > 0 then arch:= 'arm-linux-androideabi'
                else if Pos('arm64', chipArch) > 0 then arch:= 'aarch64-linux-android'
                else if Pos('86_64', chipArch) > 0 then arch:= 'x86_64-linux-android';

                aux:= SplitStr(androidNdkApi, '-');
                pathToNdkApiPlatforms:= ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib',arch, androidNdkApi]);
                //need by linker!  //C:\adt32\ndk10e\platforms\android-21\arch-arm\usr\lib\libmysqlclient.so
                CopyFile(pathToFclBridges+'libso'+PathDelim+chipArch+PathDelim+auxList.Strings[0],
                          pathToNdkApiPlatforms+PathDelim+auxList.Strings[0]);

              end;
            end
            else
            begin
              pathToNdkApiPlatforms:='';
              aux:= LazarusIDE.ActiveProject.LazCompilerOptions.Libraries; //C:\adt32\ndk10e\platforms\android-15\arch-arm\usr\lib\; .....
              p:= Pos(';', aux);
              pathToNdkApiPlatforms:= Trim(Copy(aux, 1, p-1));
              //need by linker!
              CopyFile(pathToFclBridges+'libso'+PathDelim+chipArch+PathDelim+auxList.Strings[0],
                          pathToNdkApiPlatforms+auxList.Strings[0]);
            end;
         end;
     end;
  end;
  controlsList.Free;
  auxList.Free;
  fclList.Free;
  fileList.Free;
end;

// returns the original file name from the JAVA template directory
// ex: JClass = class(JControl) -> jClass.java
//warning: On Linux, this should also work because TSearchRec is cross-platform, but I have not tested it.
function TLamwSmartDesigner.GetCorrectTemplateFileName(const Path, FileName: String): String; //by kordal
var
  SR: TSearchRec;
begin
  Result := FileName;
  if FindFirst(Path + FileName, faAnyFile, SR) = 0 then
    Result := SR.Name;
  FindClose(SR);
end;

function TLamwSmartDesigner.TryAddJControl(ControlsJava: TStringList; jclassname: string;
  out nativeAdded: boolean): boolean;
var
  list, auxList, manifestList, gradleList: TStringList;
  p, q, p1, p2, i,  minSdkManifest, count: integer;
  aux, tempStr, auxStr: string;
  insertRef, minSdkManifestStr, minSdkCtl: string;
  c: char;
  androidNdkApi, pathToNdkApiPlatforms,  arch: string;
  tempMinSdk: integer;
  isGradle : boolean;
  LenInsertRef, LenInsertRefVer: integer;
  strTrim, msgIdeHint: string;
begin
   nativeAdded:= False;
   Result:= False;

   if FPackageName = '' then Exit;

   if FileExists(FPathToJavaSource+jclassname+'.java') then Exit; //do not duplicated!
   if FileExists(FPathToJavaSource+jclassname+'.kt') then Exit; //do not duplicated!

   list:= TStringList.Create;
   manifestList:= TStringList.Create;
   auxList:= TStringList.Create;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.java') then
   begin
     list.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.java');
     list.Strings[0]:= 'package '+FPackageName+';';

     //Pascal classes can now be written case-insensitively :)
     list.SaveToFile(FPathToJavaSource + GetCorrectTemplateFileName(LamwGlobalSettings.PathToJavaTemplates, jclassname + '.java')); // by kordal

     //add relational class
     if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.relational') then
     begin
       list.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.relational');
       for i:= 0 to list.Count-1 do
       begin
          if FileExists(LamwGlobalSettings.PathToJavaTemplates + list.Strings[i]) then
          begin
            auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates + list.Strings[i]);
            auxList.Strings[0]:= 'package '+FPackageName+';';
            auxList.SaveToFile(FPathToJavaSource + list.Strings[i]);
          end;
       end;
     end;
     Result:= True;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.kt') then
   begin
     list.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.kt');
     list.Strings[0]:= 'package '+FPackageName+';';

     //Pascal classes can now be written case-insensitively :)
     list.SaveToFile(FPathToJavaSource + GetCorrectTemplateFileName(LamwGlobalSettings.PathToJavaTemplates, jclassname + '.kt')); // by kordal

     //add relational class
     if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.relational') then
     begin
       list.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.relational');
       for i:= 0 to list.Count-1 do
       begin
          if FileExists(LamwGlobalSettings.PathToJavaTemplates + list.Strings[i]) then
          begin
            auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates + list.Strings[i]);
            auxList.Strings[0]:= 'package '+FPackageName+';';
            auxList.SaveToFile(FPathToJavaSource + list.Strings[i]);
          end;
       end;
     end;
     Result:= True;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.native') then
   begin
       CopyFile(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.native',
                FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+jclassname+'.native');
        nativeAdded:= True;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.create') then
   begin
     list.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.create');
     if FileExists(FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+jclassname+'.native') then
     begin
       auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.native');
       for i:= 0 to auxList.Count-1 do
       begin
         list.Add(auxList.Strings[i]);
       end;
     end;

     aux:= list.Text;
     ControlsJava.Insert(ControlsJava.Count-1, aux);

   end;

    isGradle := (LazarusIDE.ActiveProject.CustomData['BuildSystem'] = 'Gradle');

   if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.buildsys') then   //JCenter component palette
   begin
      if not isGradle then
      begin
         ShowMessage(jclassname+' component require Gradle'+sLineBreak+'Build system...'+sLineBreak+'Changed to Gradle!');
         LazarusIDE.ActiveProject.CustomData['BuildSystem']:= 'Gradle';
         LazarusIDE.ActiveProject.Modified:= True;
      end;
   end;

   //updated manifest minAdkApi
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.minsdk') then
   begin

     minSdkManifestStr:= Trim(LazarusIDE.ActiveProject.CustomData['MinSdk']);

     if minSdkManifestStr <> '' then
     begin
         minSdkManifest:= StrToInt(minSdkManifestStr)
     end
     else
     begin
       if FileExists(FPathToAndroidProject+'build.gradle') then
       begin
         auxList.LoadFromFile(FPathToAndroidProject+'build.gradle');
         p:= Pos('minSdkVersion ', auxList.Text);
         q:= p + Length('minSdkVersion ');
         minSdkManifestStr:= auxList.Text[q] + auxList.Text[q+1];
         minSdkManifest:= StrToInt(minSdkManifestStr)
       end;
     end;

     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.minsdk');
     minSdkCtl:= Trim(auxList.Strings[0]);

     if minSdkCtl <> '' then
       tempMinSdk:= StrToInt(minSdkCtl)
     else
       tempMinSdk:= 14;

     if FMinSdkControl < tempMinSdk then
        FMinSdkControl:= tempMinSdk;

     if FMinSdkControl > minSdkManifest then
     begin
        if FileExists(FPathToAndroidProject+'build.gradle') then
        begin
          auxList.LoadFromFile(FPathToAndroidProject+'build.gradle');
          tempStr:= auxList.Text;
          tempStr:= StringReplace(tempStr, 'minSdkVersion '+minSdkManifestStr, 'minSdkVersion '+IntToStr(FMinSdkControl), [rfReplaceAll,rfIgnoreCase]);
          auxList.Text:= tempStr;
          auxList.SaveToFile(FPathToAndroidProject+'build.gradle');
        end;

        auxList.Clear;
        auxList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
        tempStr:= auxList.Text;
        if not isGradle then // Gradle not need minSdkVersion on manifest
        begin
           tempStr:= StringReplace(tempStr, 'android:minSdkVersion="'+minSdkManifestStr+'"' , 'android:minSdkVersion="'+IntToStr(FMinSdkControl)+'"', [rfReplaceAll,rfIgnoreCase]);
           auxList.Text:= tempStr;
           auxList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
        end;
        LazarusIDE.ActiveProject.CustomData['MinSdk']:= minSdkCtl; //FMinSdkControl
        LazarusIDE.ActiveProject.Modified:= True;
     end;
   end;

   //try insert reference required by the jControl in AndroidManifest ..
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.permission')then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.permission');
     if auxList.Count > 0 then
     begin
       insertRef:= '<uses-permission android';   //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;

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

   //try insert reference required by the jControl in AndroidManifest ..
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.dangerous')then  //dangerous permission
   begin
      auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.dangerous');
      if auxList.Count > 0 then
      begin
        insertRef:= '<uses-permission android';   //insert reference point
        manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
        aux:= manifestList.Text;

        list.Clear;
        for i:= 0 to auxList.Count-1 do
        begin
          strTrim:= Trim(auxList.Strings[i]);
          p1:= Pos('"',strTrim);
          p2:=NextPos('"', p1, strTrim);
          msgIdeHint:= Copy(strTrim, p1+1, p2-(p1+1));
          IDEMessagesWindow.AddCustomMessage(mluHint, 'Manifest dangerous permission: "' +
                                             msgIdeHint + '" needs to be handled in the code...');

          if Pos(strTrim, aux) <= 0 then  //not duplicate..
              list.Add(strTrim);
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

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.feature') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.feature');
     if auxList.Count > 0 then
     begin
       insertRef:= '<uses-feature android'; //<uses-sdk android:minSdkVersion'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;

       //listRequirements.Add(Trim(auxList.Text));  //Add feature
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

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.intentfilter') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.intentfilter');
     if auxList.Count > 0 then
     begin
       insertRef:= '<intent-filter>'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;

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

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.service') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.service');
     if auxList.Text <> '' then
     begin
       tempStr:= Trim(auxList.Text);
       p:= Pos('".',tempStr);
       auxStr:= Copy(tempStr, p, 10);
       insertRef:= '</activity>'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;
       if Pos(auxStr , aux) <= 0 then   //Add service
       begin
         p1:= Pos(insertRef, aux);
         Insert(sLineBreak + tempStr, aux, p1+Length(insertRef) );
         manifestList.Text:= aux;
         manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
       end;
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.activity') then  //jModalDialog
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.activity');
     if auxList.Text <> '' then
     begin
       tempStr:= Trim(auxList.Text);
       insertRef:= '</activity>'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;
       //listRequirements.Add(tempStr);  //Add service
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
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.provider') then
   begin
     manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');

     if Pos('org.lamw.fileprovider', manifestList.Text) > 0 then  //fix old projects [thanks to Manlio!]
     begin
       tempStr:= Trim(StringReplace(manifestList.Text, 'org.lamw.fileprovider', FPackageName, [rfReplaceAll,rfIgnoreCase]) );
       manifestList.Text:= tempStr;
       manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
     end;

     aux:= manifestList.Text;
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.provider');
     if auxList.Text <> '' then
     begin
       tempStr:= Trim(StringReplace(auxList.Text, 'org.lamw.fileprovider', FPackageName, [rfReplaceAll,rfIgnoreCase]) );
       insertRef:= '</activity>'; //insert reference point
       //listRequirements.Add(tempStr);  //Add providers
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
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.receiver') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.receiver');
     if auxList.Text <> '' then
     begin
       aux:= Trim(auxList.Text);
       tempStr:= StringReplace(aux,'WPACKAGENAME', FPackageName, [rfIgnoreCase]);
       p:= Pos('".',tempStr);
       auxStr:= Copy(tempStr, p, 10);
       insertRef:= '</activity>'; //insert reference point
       manifestList.LoadFromFile(FPathToAndroidProject+'AndroidManifest.xml');
       aux:= manifestList.Text;
       if Pos(auxStr , aux) <= 0 then
       begin
         p1:= Pos(insertRef, aux);
         Insert(sLineBreak + tempStr, aux, p1+Length(insertRef) );
         manifestList.Text:= aux;
         manifestList.SaveToFile(FPathToAndroidProject+'AndroidManifest.xml');
       end;
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.layout') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.layout');
     list.Clear;
     list.Delimiter:= DirectorySeparator;
     list.StrictDelimiter:= True;
     list.DelimitedText:= FPathToAndroidProject + 'dummy';
     aux:= StringReplace(auxList.Text,'WAPPNAME',  list.Strings[list.Count-2], [rfIgnoreCase]);
     auxList.Text:= aux;
     auxList.SaveToFile(FPathToAndroidProject+'res'+DirectorySeparator+'layout'+DirectorySeparator+LowerCase(jclassname)+'_layout.xml');
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.info') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.info');
     ForceDirectories(FPathToAndroidProject+'res'+DirectorySeparator+'xml');
     auxList.SaveToFile(FPathToAndroidProject+'res'+DirectorySeparator+'xml'+DirectorySeparator+LowerCase(jclassname)+'_info.xml');
   end;

   //<string name="lamw_ussd_service">LAMW USSD Service</string>
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.strings') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.strings');
     list.LoadFromFile(FPathToAndroidProject+'res'+DirectorySeparator+'values'+DirectorySeparator+'strings.xml');
     for i:= 0 to auxList.Count-1 do
     begin
       if auxList.Strings[i] <> '' then
       begin
         if Pos(auxList.Strings[i], list.Text) <= 0 then
         begin
            list.Strings[list.Count-1]:= auxList.Strings[i];  //replace </resources>  tag
            list.Add('</resources>'); //re-introduce tag
         end;
       end;
     end;
     list.SaveToFile(FPathToAndroidProject+'res'+DirectorySeparator+'values'+DirectorySeparator+'strings.xml');
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.jpg') then
   begin
     CopyFile(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.jpg',
          FPathToAndroidProject+'res'+DirectorySeparator+'drawable-hdpi'+DirectorySeparator+LowerCase(jclassname)+'_image.jpg');
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.anim') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.anim');
     ForceDirectories(FPathToAndroidProject+'res'+DirectorySeparator+'anim');
     for i:= 0 to  auxList.Count-1 do
     begin
       CopyFile(LamwGlobalSettings.PathToJavaTemplates + 'anim' + DirectorySeparator + auxList.Strings[i],
            FPathToAndroidProject+'res'+DirectorySeparator+'anim'+DirectorySeparator+auxList.Strings[i]);
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.drawable') then
   begin
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.drawable');
     ForceDirectories(FPathToAndroidProject+'res'+DirectorySeparator+'drawable');
     for i:= 0 to  auxList.Count-1 do
     begin
       CopyFile(LamwGlobalSettings.PathToJavaTemplates + 'drawable' + DirectorySeparator + auxList.Strings[i],
            FPathToAndroidProject+'res'+DirectorySeparator+'drawable'+DirectorySeparator+auxList.Strings[i]);
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.libjar') then
   begin
     if (not isGradle) or (not FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.dependencies')) then
     begin
       auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.libjar');
       //ForceDirectories(FPathToAndroidProject+'res'+DirectorySeparator+'anim');
       for i:= 0 to  auxList.Count-1 do
       begin
         CopyFile(LamwGlobalSettings.PathToJavaTemplates + 'libjar' + DirectorySeparator + auxList.Strings[i],
              FPathToAndroidProject+'libs'+DirectorySeparator+auxList.Strings[i]);
       end;
     end
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates + jclassname + '.libso') then //jBarcodeScannerView.libso
   begin
     //libiconv.so
     //libzbarjni.so
     auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates + jclassname+'.libso');

     for i:= 0 to  auxList.Count-1 do
     begin
        CopyFile(LamwGlobalSettings.PathToJavaTemplates + 'libso' + PathDelim+FChipArchitecture+PathDelim+auxList.Strings[i],
                FPathToAndroidProject+'libs'+PathDelim+FChipArchitecture+PathDelim+auxList.Strings[i]);
     end;

     androidNdkApi:= LazarusIDE.ActiveProject.CustomData.Values['NdkApi']; //android-21
     if androidNdkApi <> '' then
     begin
       if FNDKVersion < 22 then
       begin
           arch:= 'arch-x86';
           if Pos('armeabi', FChipArchitecture) > 0 then arch:= 'arch-arm'
           else if Pos('arm64', FChipArchitecture) > 0 then arch:= 'arch-arm64'
           else if Pos('86_64', FChipArchitecture) > 0 then arch:= 'arch-x86_64'
           else if Pos('mips', FChipArchitecture) > 0 then arch:= 'arch-mips';

           //C:\adt32\ndk10e\platforms\android-15\arch-arm\usr\lib
           pathToNdkApiPlatforms:= FPathToAndroidNDK+'platforms'+DirectorySeparator+
                                                   androidNdkApi +DirectorySeparator+arch+DirectorySeparator+
                                                   'usr'+DirectorySeparator+'lib';


           //need by linker!                       //C:\adt32\ndk10e\platforms\android-21\arch-arm\usr\lib\libmysqlclient.so
          for i:= 0 to  auxList.Count-1 do
          begin
             CopyFile(LamwGlobalSettings.PathToJavaTemplates + 'libso' + PathDelim+FChipArchitecture+PathDelim+auxList.Strings[i],
                      pathToNdkApiPlatforms+PathDelim+auxList.Strings[i]);
          end;
       end
       else
       begin   //NDK > 21

          arch:= 'i686-linux-android';
          if Pos('armeabi', FChipArchitecture) > 0 then arch:= 'arm-linux-androideabi'
          else if Pos('arm64', FChipArchitecture) > 0 then arch:= 'aarch64-linux-android'
          else if Pos('86_64', FChipArchitecture) > 0 then arch:= 'x86_64-linux-android';

          aux:= SplitStr(androidNdkApi, '-');
          pathToNdkApiPlatforms:= ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib',arch, androidNdkApi]);

          //need by linker!                       //C:\adt32\ndk10e\platforms\android-21\arch-arm\usr\lib\libmysqlclient.so
          for i:= 0 to  auxList.Count-1 do
          begin
             CopyFile(LamwGlobalSettings.PathToJavaTemplates + 'libso' + PathDelim+FChipArchitecture+PathDelim+auxList.Strings[i],
                      pathToNdkApiPlatforms+PathDelim+auxList.Strings[i]);
          end;

       end;
     end
     else
     begin
       pathToNdkApiPlatforms:='';
       aux:= LazarusIDE.ActiveProject.LazCompilerOptions.Libraries; //C:\adt32\ndk10e\platforms\android-15\arch-arm\usr\lib\; .....
       p:= Pos(';', aux);
       pathToNdkApiPlatforms:= Trim(Copy(aux, 1, p-1));
       //need by linker!
       for i:= 0 to  auxList.Count-1 do
       begin
          CopyFile(LamwGlobalSettings.PathToJavaTemplates + 'libso' + PathDelim+FChipArchitecture+PathDelim+auxList.Strings[i],
                   pathToNdkApiPlatforms+auxList.Strings[i]);
       end;
     end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.dependencies') then
   begin
      auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.dependencies');
      if auxList.Text <> '' then
      begin
        gradleList:=TStringList.Create;
        gradleList.LoadFromFile(FPathToAndroidProject+'build.gradle');
        aux:= gradleList.Text;
        insertRef:= 'fileTree(include: [''*.jar''], dir: ''libs'')';
        for i:= 0 to auxList.Count-1 do
        begin
           auxStr:=auxList.Strings[i];
           SplitStr(auxStr, ' ');

           count:= WordCount(auxStr, [':']);
           if count > 2 then //has version
              p:= LastDelimiter(':',auxStr)
           else
              p:= Length(auxStr);

           tempStr:= Copy(auxStr, 2, p - 2);
           if Pos(tempStr, aux) <= 0 then
           begin
             p1:= Pos(insertRef, aux);
             Insert(sLineBreak + '    '+auxList.Strings[i] , aux, p1+Length(insertRef) );
           end;
        end;
        gradleList.Text:= aux;
        gradleList.SaveToFile(FPathToAndroidProject+'build.gradle'); //buildgradletList
        gradleList.Free;
      end;
   end;
   //-----
   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.classpath') then
   begin                                                                                     //jsFirebasePushNotificationListener.classpath
      auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.classpath');  //classpath 'com.google.gms:google-services:4.3.8'
      if auxList.Text <> '' then
      begin

        gradleList:=TStringList.Create;
        gradleList.LoadFromFile(FPathToAndroidProject+'build.gradle');
        aux:= gradleList.Text;
        insertRef:= 'classpath ''com.android.tools.build:gradle:'; //4.1.3

        LenInsertRefVer:= 6; //4.1.3'
        LenInsertRef:=Length(insertRef) + LenInsertRefVer;

        for i:= 0 to auxList.Count-1 do
        begin
           auxStr:=auxList.Strings[i];
           SplitStr(auxStr, ' ');         //--> 'com.google.gms:google-services:4.3.8'
           p:= LastDelimiter(':',auxStr); //classpath 'com.google.gms:google-services:4.3.8'
           tempStr:= Copy(auxStr, 2, p - 2);
           if Pos(tempStr, aux) <= 0 then
           begin
             p1:= Pos(insertRef, aux);
             Insert(sLineBreak + '        ' + auxList.Strings[i] , aux, p1 + LenInsertRef);
           end;
        end;
        gradleList.Text:= aux;
        gradleList.SaveToFile(FPathToAndroidProject+'build.gradle');
        gradleList.Free;
      end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.plugin') then
   begin                                                                                  //jsFirebasePushNotificationListener.plugin
      auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.plugin');  //apply plugin: 'com.google.gms.google-services'
      if auxList.Text <> '' then
      begin
        gradleList:=TStringList.Create;
        gradleList.LoadFromFile(FPathToAndroidProject+'build.gradle');
        aux:= gradleList.Text;

        insertRef:= 'apply plugin: ''com.android.application''';

        for i:= 0 to auxList.Count-1 do
        begin
           auxStr:=auxList.Strings[i];
           SplitStr(auxStr, ' ');
           if Pos(auxStr, aux) <= 0 then
           begin
             p1:= Pos(insertRef, aux);
             Insert(sLineBreak+auxList.Strings[i] , aux, p1+Length(insertRef) );
           end;
        end;
        gradleList.Text:= aux;
        gradleList.SaveToFile(FPathToAndroidProject+'build.gradle'); //buildgradletList
        gradleList.Free;
      end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.repositories') then
   begin
      auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.repositories'); // jcenter()
      if auxList.Text <> '' then
      begin
        gradleList:=TStringList.Create;
        gradleList.LoadFromFile(FPathToAndroidProject+'build.gradle');
        aux:= gradleList.Text;

        insertRef:= 'maven {url ''https://jitpack.io''}';

        for i:= 0 to auxList.Count-1 do
        begin
           auxStr:=auxList.Strings[i];
           if Pos(auxStr, aux) <= 0 then
           begin
             p1:= Pos(insertRef, aux);
             Insert(sLineBreak+'       '+auxList.Strings[i] , aux, p1+Length(insertRef) );
           end;
        end;
        gradleList.Text:= aux;
        gradleList.SaveToFile(FPathToAndroidProject+'build.gradle'); //buildgradletList
        gradleList.Free;
      end;
   end;

   if FileExists(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.gradleproperties') then
   begin
      auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+jclassname+'.gradleproperties');
      if auxList.Text <> '' then
      begin
        gradleList:=TStringList.Create;
        gradleList.LoadFromFile(FPathToAndroidProject+'gradle.properties');
        aux:= gradleList.Text;

        insertRef:= 'android.useAndroidX=true';

        for i:= 0 to auxList.Count-1 do    //android.enableJetifier=true
        begin
           auxStr:=auxList.Strings[i];
           if Pos(auxStr, aux) <= 0 then
           begin
             p1:= Pos(insertRef, aux);
             Insert(sLineBreak+auxList.Strings[i] , aux, p1+Length(insertRef) );
           end;
        end;
        gradleList.Text:= aux;
        gradleList.SaveToFile(FPathToAndroidProject+'gradle.properties');
        gradleList.Free;
      end;
   end;

   manifestList.Free;
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
    //Result := Result + FStartModuleVarName + '.init;';
    Result := Result + FStartModuleVarName + '.Reinit;' //by tr3e
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
  javaClassList.Free;

  javaClassList := FindAllFiles(FPathToJavaSource, '*.kt', False);
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

function TLamwSmartDesigner.GetPathToSmartDesigner(): string;
var
  Pkg: TIDEPackage;
begin
  Result:= '';
  if FPathToSmartDesigner = '' then
  begin
    Pkg:=PackageEditingInterface.FindPackageWithName('lazandroidwizardpack');
    if Pkg<>nil then
    begin
        FPathToSmartDesigner:= ExtractFilePath(Pkg.Filename);
        FPathToSmartDesigner:= FPathToSmartDesigner + 'smartdesigner';
        Result:=FPathToSmartDesigner;
        //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
    end;
  end
  else Result:= FPathToSmartDesigner;
end;

procedure TLamwSmartDesigner.UpdateAllJControls(AProject: TLazProject);
var
  jControls, LFM, fclList: TStringList;
  lfmFileName, str: string;
  i, j, k: Integer;
  pathToFclBridges: string;
begin

  fclList:=  TStringList.Create;
  FPathToSmartDesigner:=  GetPathToSmartDesigner();

  pathToFclBridges:= FPathToSmartDesigner + PathDelim +  'fcl' + pathDelim;

  if FileExists(pathToFclBridges+'fcl_bridges.txt') then
     fclList.LoadFromFile(pathToFclBridges+'fcl_bridges.txt');

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
              str := Trim(Copy(str, k + 1, MaxInt)); //(str = 'TFPNoGUIGraphicsBridge')
              if  (Pos(str, fclList.Text) > 0) or
                  FileExists(LamwGlobalSettings.PathToJavaTemplates + str + '.java') or
                  FileExists(LamwGlobalSettings.PathToJavaTemplates + str + '.kt') then
              begin
                  jControls.Add(str);
              end;
            end;
          end;
          CustomData['jControls'] := jControls.DelimitedText;
        end;
      end;
  finally
    LFM.Free;
    jControls.Free;
    fclList.Free;
  end;
end;

function TLamwSmartDesigner.OnProjectSavingAll(Sender: TObject): TModalResult;
var
  ControlsJava, auxList, controlsList, libList: TStringList;
  i, j, p: Integer;
  nativeExists: Boolean;
  aux, PathToJavaTemplates, LibPath, linkLibrariesPath: string;
  AndroidTheme: string;
  compoundList: TStringList;
  lprModuleName: string;
  hasControls: boolean;
  nativeMethodList, tempList: TStringList;
  FSupport:boolean;
begin
  Result := mrOk;
  if not LazarusIDE.ActiveProject.CustomData.Contains('LAMW') then Exit;

  hasControls:= False;

  if LazarusIDE.ActiveProject.CustomData.Values['LAMW'] = 'GUI' then hasControls:= True;

  if not hasControls then Exit;  //no form basead

  FSupport:=(LazarusIDE.ActiveProject.CustomData.Values['Support']='TRUE');

  AndroidTheme:= LazarusIDE.ActiveProject.CustomData.Values['Theme'];

  PathToJavaTemplates := LamwGlobalSettings.PathToJavaTemplates; //included path delimiter
  // C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner\java\

  //LAMW 0.8
  lprModuleName:= GetLprStartModuleVarName();
  FStartModuleVarName:= LazarusIDE.ActiveProject.CustomData.Values['StartModule'];
  if FStartModuleVarName = '' then UpdateStartModuleVarName;
  //LAMW 0.8

  AddSupportToFCLControls(FChipArchitecture);

  if LamwGlobalSettings.CanUpdateJavaTemplate then
  begin
    CleanupAllJControlsSource;

    ControlsJava:= TStringList.Create;
    auxList:= TStringList.Create;
    controlsList := TStringList.Create;
    controlsList.Sorted := True;
    controlsList.Duplicates := dupIgnore;
    compoundList:= TStringList.Create;

    GetAllJControlsFromForms(controlsList);

    for i:= 0 to controlsList.Count - 1 do       //Add component compound support
    begin
      if FileExists(PathToJavaTemplates+controlsList.Strings[i]+'.compound') then
      begin
        compoundList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+controlsList.Strings[i]+'.compound');
        for j:= 0 to compoundList.Count - 1 do
        begin
          if compoundList.Strings[j] <> '' then
             controlsList.Add(compoundList.Strings[j]);
        end;
      end;
    end;

    //re-add all [updated] java code ...

    if (FSupport) or (Pos('AppCompat', AndroidTheme)>0) then  // refactored by jmpessoa: UNIQUE "Controls.java" !!!
    begin

       if FileExists(PathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'jSupported.java') then
       begin
         auxList.LoadFromFile(PathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'jSupported.java');
         auxList.Strings[0] := 'package ' + FPackageName + ';';  //replace dummy
         auxList.SaveToFile(FPathToJavaSource + 'jSupported.java');
       end;

       if FileExists(PathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'support_provider_paths.xml') and
          (not FileExists(FPathToAndroidProject +'res'+DirectorySeparator+'xml'+DirectorySeparator+'support_provider_paths.xml'))then
       begin
         ForceDirectories(FPathToAndroidProject+'res'+DirectorySeparator+'drawable');
         auxList.LoadFromFile(PathToJavaTemplates+DirectorySeparator +'support'+DirectorySeparator+'support_provider_paths.xml');
         ForceDirectories(FPathToAndroidProject+'res'+DirectorySeparator+'xml');
         auxList.SaveToFile(FPathToAndroidProject +'res'+DirectorySeparator+'xml'+DirectorySeparator+'support_provider_paths.xml');
       end;

    end
    else
    begin
       if FileExists(PathToJavaTemplates+DirectorySeparator+ 'jSupported.java') then
       begin
         auxList.LoadFromFile(PathToJavaTemplates+DirectorySeparator+ 'jSupported.java');
         auxList.Strings[0] := 'package ' + FPackageName + ';';  //replace dummy
         auxList.SaveToFile(FPathToJavaSource  + 'jSupported.java');
       end;
    end;

    auxList.Clear;

    //UNIQUE "Controls.java" !!!
    ControlsJava.LoadFromFile(PathToJavaTemplates + 'Controls.java');

    ControlsJava.Strings[0]:= 'package '+FPackageName+';';

    for j:= 0 to controlsList.Count - 1 do
    begin
      if FileExists(PathToJavaTemplates+controlsList.Strings[j]+'.java') then
           TryAddJControl(ControlsJava, controlsList.Strings[j], nativeExists)
      else if FileExists(PathToJavaTemplates+controlsList.Strings[j]+'.kt') then
           TryAddJControl(ControlsJava, controlsList.Strings[j], nativeExists);
    end;

    // tk Output some useful messages about libraries
    LibPath := FPathToAndroidProject + 'libs'+DirectorySeparator+FChipArchitecture;
    IDEMessagesWindow.AddCustomMessage(mluVerbose, 'Selected chip architecture: ' + FChipArchitecture);
    IDEMessagesWindow.AddCustomMessage(mluVerbose, 'Taking libraries from folder: ' + LibPath);
    // end tk

    linkLibrariesPath:='';
    aux:= LazarusIDE.ActiveProject.LazCompilerOptions.Libraries;  //C:\adt32\ndk10e\platforms\android-15\arch-arm\usr\lib\; .....
    p:= Pos(';', aux);
    if p > 0 then
    begin
      linkLibrariesPath:= Trim(Copy(aux, 1, p-1));
      libList:= FindAllFiles(LibPath, '*.so', False);
      for j:= 0 to libList.Count-1 do
      begin
        aux:= ExtractFileName(libList.Strings[j]);

        // tk Show what library has been added
        IDEMessagesWindow.AddCustomMessage(mluVerbose, 'Found library: ' + aux);
        // end tk

        if aux <> 'libcontrols.so' then
        begin
          if linkLibrariesPath <> '' then
          begin
          if not FileExists(linkLibrariesPath + aux) then  //prepare "exotic" library to Linker
             CopyFile(LibPath +PathDelim+ aux, linkLibrariesPath + aux);
          end;
        end;

        p:= Pos('.', aux);
        aux:= Trim(copy(aux,4, p-4));
        auxList.Add(aux);
      end;
    end;

    //update all java code ...
    libList.Clear;
    for j:= 0 to auxList.Count-1 do
    begin
      libList.Add('try{System.loadLibrary("'+auxList.Strings[j]+'");} catch (UnsatisfiedLinkError e) {Log.e("JNI_Loading_lib'+auxList.Strings[j]+'", "exception", e);}');
    end;

    if libList.Count > 0 then
       aux:=  StringReplace(ControlsJava.Text, '/*libsmartload*/' ,Trim(libList.Text), [rfReplaceAll,rfIgnoreCase])
    else
       aux:=  StringReplace(ControlsJava.Text, '/*libsmartload*/' ,
               'try{System.loadLibrary("controls");} catch (UnsatisfiedLinkError e) {Log.e("JNI_Loading_libcontrols", "exception", e);}',
               [rfReplaceAll,rfIgnoreCase]);

    ControlsJava.Text:= aux;
    ControlsJava.SaveToFile(FPathToJavaSource+'Controls.java');

    auxList.Clear;
    if LazarusIDE.ActiveProject.CustomData['LAMW'] = 'GUI' then
    begin
      if FileExists(PathToJavaTemplates+'jForm.java') then
      begin
          auxList.LoadFromFile(PathToJavaTemplates+'jForm.java');
          auxList.Strings[0]:= 'package '+FPackageName+';';
          auxList.SaveToFile(FPathToJavaSource+'jForm.java');
      end;
    end;

    auxList.Clear;
    if Pos('AppCompat', AndroidTheme) > 0 then
    begin
      if FileExists(PathToJavaTemplates +'support'+DirectorySeparator+'App.java') then
        auxList.LoadFromFile(PathToJavaTemplates + 'support'+DirectorySeparator+'App.java');
        auxList.Strings[0]:= 'package '+FPackageName+';';
        auxList.SaveToFile(FPathToJavaSource+'App.java');
    end
    else
    begin
      if FileExists(PathToJavaTemplates + 'App.java') then
      begin
         auxList.LoadFromFile(PathToJavaTemplates + 'App.java');
         auxList.Strings[0]:= 'package '+FPackageName+';';
         auxList.SaveToFile(FPathToJavaSource+'App.java');
      end
    end;

    auxList.Clear;

    if Pos('AppCompat', AndroidTheme) > 0  then
    begin
      if FileExists(LamwGlobalSettings.PathToJavaTemplates +'support'+DirectorySeparator+'jCommons.java') then
        auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'support'+DirectorySeparator+'jCommons.java');
    end
    else
    begin
      if FileExists(LamwGlobalSettings.PathToJavaTemplates+'jCommons.java') then
        auxList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'jCommons.java');
    end;
    auxList.Strings[0]:= 'package '+FPackageName+';';
    auxList.SaveToFile(FPathToJavaSource+'jCommons.java');

    compoundList.Free;
    controlsList.Free;
    libList.Free;
    auxList.Free;

    ControlsJava.Free;

  end;  //CanUpdateJavaTemplate

  if FileExists(LamwGlobalSettings.PathToJavaTemplates+'Controls.java') then
  begin
    nativeMethodList:= TStringList.Create;
    tempList:= TStringList.Create;
    tempList.LoadFromFile(LamwGlobalSettings.PathToJavaTemplates+'Controls.java');
    for i:= 0 to tempList.Count - 1 do
    begin
       if Pos(' native ', tempList.Strings[i]) > 0 then
          nativeMethodList.Add(Trim(tempList.Strings[i]));
    end;
    tempList.Clear;
    for i:= 0 to nativeMethodList.Count-1 do
    begin
      tempList.Add(GetEventSignature(nativeMethodList.Strings[i]));
    end;
    tempList.SaveToFile(LamwGlobalSettings.PathToJavaTemplates+'Controls.events');
    nativeMethodList.SaveToFile(LamwGlobalSettings.PathToJavaTemplates+'Controls.native');
    nativeMethodList.Free;
    tempList.Free;
  end;

  if FileExists(PathToJavaTemplates + 'Controls.native') then
  begin
    CopyFile(PathToJavaTemplates + 'Controls.native',
       FPathToAndroidProject+'lamwdesigner'+DirectorySeparator+'Controls.native');
  end;

  UpdateProjectLpr(lprModuleName, FStartModuleVarName);

end;

destructor TLamwSmartDesigner.Destroy;
begin
  if LazarusIDE <> nil then
  begin
    //LazarusIDE.RemoveAllHandlersOfObject(Self);
    LazarusIDE.RemoveHandlerOnProjectOpened(@OnProjectOpened);
    LazarusIDE.RemoveHandlerOnSavingAll(@OnProjectSavingAll);
  end;
  if  GlobalDesignHook <> nil then
     GlobalDesignHook.RemoveHandlerAddClicked(@AddClicked);
  inherited Destroy;
end;

procedure TLamwSmartDesigner.Init;
begin
  LazarusIDE.AddHandlerOnProjectOpened(@OnProjectOpened);
  LazarusIDE.AddHandlerOnSavingAll(@OnProjectSavingAll);
  GlobalDesignHook.AddHandlerAddClicked(@AddClicked);
end;

//F /libraries
//C:\adt32\ndk10e\platforms\android-21\arch-arm\usr\lib\;
//C:\adt32\ndk10e\toolchains\arm-linux-androideabi-4.9\prebuilt\windows\lib\gcc\arm-linux-androideabi\4.9\"/>

//custom
//C:\adt32\ndk10e\toolchains\arm-linux-androideabi-4.9\prebuilt\windows\bin

function TLamwSmartDesigner.TryChangeNdkPlatformsApi(path: string; newNdkApi: integer): string;
var
  tail, head: string;
  arch: string;
begin
  if FNDKVersion < 22 then
  begin
      tail:= path;
      head:= SplitStr(tail,';');
      arch:= 'arch-x86';
      if Pos('armeabi', FChipArchitecture) > 0 then arch:= 'arch-arm'
      else if Pos('arm64', FChipArchitecture) > 0 then arch:= 'arch-arm64'
      else if Pos('mips', FChipArchitecture) > 0 then arch:= 'arch-mips'
      else if Pos('86_64', FChipArchitecture) > 0 then arch:= 'arch-x86_64';
      head:= ConcatPaths([FPathToAndroidNDK,'platforms','android-'+IntToStr(newNdkApi), arch,'usr','lib']);
      Result:= head + PathDelim + ';' + tail;
  end
  else // NDK >= 22
  begin
      tail:= path;
      head:= SplitStr(tail,';');
      arch:= 'i686-linux-android';
      if Pos('armeabi', FChipArchitecture) > 0 then arch:= 'arm-linux-androideabi'
      else if Pos('arm64', FChipArchitecture) > 0 then arch:= 'aarch64-linux-android'
      else if Pos('86_64', FChipArchitecture) > 0 then arch:= 'x86_64-linux-android';
      head:= ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSYS, 'sysroot', 'usr', 'lib', arch]);
      Result:= head + PathDelim + IntToStr(newNdkApi) + PathDelim + ';' + tail;
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

procedure TLamwSmartDesigner.UpdateBuildModes();
var
 listBuildMode: TStringList;
 x,  ndkApi: string;
begin

   FMaxNdk := 22;  //android 4.x and 5.x compatibility....

   ndkApi:= IntToStr(FMaxNdk);

   if FNDKIndex = '' then
      FNDKIndex := LamwGlobalSettings.GetNDK;


   if FNDKIndex = '' then FNDKIndex:= '5';

   x:='';
   if StrToInt(FNDKIndex) > 4 then
     x:='.x';

   if (Length(FPrebuildOSYS)=0) then
   begin
     {$ifdef Windows}
     FPrebuildOSYS:='windows';
     {$endif}
     {$ifdef Linux}
     FPrebuildOSYS:='linux';
     {$endif}
     {$ifdef Darwin}
     FPrebuildOSYS:='darwin';
     {$endif}
   end;

   listBuildMode:= TStringList.Create;

   listBuildMode.Clear;
   if FNDKVersion < 22 then //arch-arm64
     listBuildMode.Add('<Libraries Value="'+FPathToAndroidNDK+'platforms'+PathDelim+'android-'+ndkApi+PathDelim+'arch-arm64'+PathDelim+'usr'+PathDelim+'lib;'+FPathToAndroidNDK+'toolchains'+PathDelim+'aarch64-linux-android-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'aarch64-linux-android'+PathDelim+'4.9'+x+'"/>')
   else
     listBuildMode.Add('<Libraries Value="'+ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','aarch64-linux-android', ndkApi])+';'+FPathToAndroidNDK+'toolchains'+PathDelim+'aarch64-linux-android-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'aarch64-linux-android'+PathDelim+'4.9'+x+'"/>');
   listBuildMode.Add('<TargetCPU Value="aarch64"/>');
   listBuildMode.Add('<CustomOptions Value="-Xd -XPaarch64-linux-android- -FD'+FPathToAndroidNDK+'toolchains'+PathDelim+'aarch64-linux-android-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'bin"/>');
   listBuildMode.SavetoFile(FPathToAndroidProject+'jni'+PathDelim+'build-modes'+PathDelim+'build_arm64.txt');

   listBuildMode.Clear;
   if FNDKVersion < 22 then  //arch-armV6
       listBuildMode.Add('<Libraries Value="'+FPathToAndroidNDK+'platforms'+PathDelim+'android-'+ndkApi+PathDelim+'arch-arm'+PathDelim+'usr'+PathDelim+'lib;'+FPathToAndroidNDK+'toolchains'+PathDelim+'arm-linux-androideabi-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'arm-linux-androideabi'+PathDelim+'4.9'+x+'"/>')
   else
       listBuildMode.Add('<Libraries Value="'+ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','arm-linux-androideabi', ndkApi])+';'+FPathToAndroidNDK+'toolchains'+PathDelim+'arm-linux-androideabi-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'arm-linux-androideabi'+PathDelim+'4.9'+x+'"/>');
   listBuildMode.Add('<TargetCPU Value="arm"/>');
   listBuildMode.Add('<CustomOptions Value="-Xd -CfSoft -CpARMV6 -XParm-linux-androideabi- -FD'+FPathToAndroidNDK+'toolchains'+PathDelim+'arm-linux-androideabi-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'bin"/>');
   listBuildMode.SavetoFile(FPathToAndroidProject+'jni'+PathDelim+'build-modes'+PathDelim+'build_armV6.txt');

   listBuildMode.Clear;
   if FNDKVersion < 22 then //arch-armV7
       listBuildMode.Add('<Libraries Value="'+FPathToAndroidNDK+'platforms'+PathDelim+'android-'+ndkApi+PathDelim+'arch-arm'+PathDelim+'usr'+PathDelim+'lib;'+FPathToAndroidNDK+'toolchains'+PathDelim+'arm-linux-androideabi-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'arm-linux-androideabi'+PathDelim+'4.9'+x+'"/>')
   else
     listBuildMode.Add('<Libraries Value="'+ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','arm-linux-androideabi', ndkApi])+';'+FPathToAndroidNDK+'toolchains'+PathDelim+'arm-linux-androideabi-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'arm-linux-androideabi'+PathDelim+'4.9'+x+'"/>');
   listBuildMode.Add('<TargetCPU Value="arm"/>');
   listBuildMode.Add('<CustomOptions Value="-Xd -CfSoft -CpARMV7A -XParm-linux-androideabi- -FD'+FPathToAndroidNDK+'toolchains'+PathDelim+'arm-linux-androideabi-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'bin"/>');
   listBuildMode.SavetoFile(FPathToAndroidProject+'jni'+PathDelim+'build-modes'+PathDelim+'build_armV7a.txt');

   listBuildMode.Clear;
   if FNDKVersion < 22 then //rmV7a_VFPv3
     listBuildMode.Add('<Libraries Value="'+FPathToAndroidNDK+'platforms'+PathDelim+'android-'+ndkApi+PathDelim+'arch-arm'+PathDelim+'usr'+PathDelim+'lib;'+FPathToAndroidNDK+'toolchains'+PathDelim+'arm-linux-androideabi-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'arm-linux-androideabi'+PathDelim+'4.9'+x+'"/>')
   else
     listBuildMode.Add('<Libraries Value="'+ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','arm-linux-androideabi', ndkApi])+';'+FPathToAndroidNDK+'toolchains'+PathDelim+'arm-linux-androideabi-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'arm-linux-androideabi'+PathDelim+'4.9'+x+'"/>');
   listBuildMode.Add('<TargetCPU Value="arm"/>');
   listBuildMode.Add('<CustomOptions Value="-Xd -CfVFPv3 -CpARMV7A -XParm-linux-androideabi- -FD'+FPathToAndroidNDK+'toolchains'+PathDelim+'arm-linux-androideabi-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'bin"/>');
   listBuildMode.SavetoFile(FPathToAndroidProject+'jni'+PathDelim+'build-modes'+PathDelim+'build_armV7a_VFPv3.txt');

   listBuildMode.Clear;
   if FNDKVersion < 22 then  //x86
      listBuildMode.Add('<Libraries Value="'+FPathToAndroidNDK+'platforms'+PathDelim+'android-'+ndkApi+PathDelim+'arch-x86'+PathDelim+'usr'+PathDelim+'lib;'+FPathToAndroidNDK+'toolchains'+PathDelim+'x86-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'x86-linux-android'+PathDelim+'4.9'+x+'"/>')
   else
      listBuildMode.Add('<Libraries Value="'+ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','i686-linux-android', ndkApi])+';'+FPathToAndroidNDK+'toolchains'+PathDelim+'x86-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'x86-linux-android'+PathDelim+'4.9'+x+'"/>');
   listBuildMode.Add('<TargetCPU Value="i386"/>');
   listBuildMode.Add('<CustomOptions Value="-Xd -XPi686-linux-android- -FD'+FPathToAndroidNDK+'toolchains'+PathDelim+'x86-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'bin"/>');
   listBuildMode.SavetoFile(FPathToAndroidProject+'jni'+PathDelim+'build-modes'+PathDelim+'build_x86.txt');

   listBuildMode.Clear;
   if FNDKVersion < 22 then  //x86_64
      listBuildMode.Add('<Libraries Value="'+FPathToAndroidNDK+'platforms'+PathDelim+'android-'+ndkApi+PathDelim+'arch-x86_64'+PathDelim+'usr'+PathDelim+'lib;'+FPathToAndroidNDK+'toolchains'+PathDelim+'x86_64-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'x86_64-linux-android'+PathDelim+'4.9'+x+'"/>')
   else
      listBuildMode.Add('<Libraries Value="'+ConcatPaths([FPathToAndroidNDK,'toolchains','llvm','prebuilt',FPrebuildOSys,'sysroot','usr','lib','x86_64-linux-android', ndkApi])+';'+FPathToAndroidNDK+'toolchains'+PathDelim+'x86_64-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'x86_64-linux-android'+PathDelim+'4.9'+x+'"/>');
   listBuildMode.Add('<TargetCPU Value="x86_64"/>');
   listBuildMode.Add('<CustomOptions Value="-Xd -XPx86_64-linux-android- -FD'+FPathToAndroidNDK+'toolchains'+PathDelim+'x86_64-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'bin"/>');
   listBuildMode.SavetoFile(FPathToAndroidProject+'jni'+PathDelim+'build-modes'+PathDelim+'build_x86_64.txt');

   listBuildMode.Clear;
   if FNDKVersion < 22 then
   begin
     listBuildMode.Add('<Libraries Value="'+FPathToAndroidNDK+'platforms'+PathDelim+'android-'+ndkApi+PathDelim+'arch-mips'+PathDelim+'usr'+PathDelim+'lib;'+FPathToAndroidNDK+'toolchains'+PathDelim+'mipsel-linux-android-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'lib'+PathDelim+'gcc'+PathDelim+'mipsel-linux-android'+PathDelim+'4.9'+x+'"/>');
     listBuildMode.Add('<TargetCPU Value="mipsel"/>');
     listBuildMode.Add('<CustomOptions Value="-Xd -XPmipsel-linux-android- -FD'+FPathToAndroidNDK+'toolchains'+PathDelim+'mipsel-linux-android-4.9'+PathDelim+'prebuilt'+PathDelim+FPrebuildOSYS+PathDelim+'bin"/>');
     listBuildMode.SavetoFile(FPathToAndroidProject+'jni'+PathDelim+'build-modes'+PathDelim+'build_mipsel.txt');
   end;

   listBuildMode.Clear;
   listBuildMode.Add('How to get more ".so" chipset builds:');
   listBuildMode.Add(' ');
   listBuildMode.Add('   :: Warning 1: Your Lazarus/Freepascal needs to be prepared [cross-compile] for the various chipset builds!');
   listBuildMode.Add('   :: Warning 2: Laz4Android [out-of-box] support only 32 Bits chipset: "armV6", "armV7a+Soft", "x86"!');
   listBuildMode.Add(' ');
   listBuildMode.Add('1. From LazarusIDE menu:');
   listBuildMode.Add(' ');
   listBuildMode.Add('   > Project -> Project Options -> Project Options -> [LAMW] Android Project Options -> "Build" -> Chipset [select!] -> [OK]');
   listBuildMode.Add(' ');
   listBuildMode.Add('2. From LazarusIDE  menu:');
   listBuildMode.Add(' ');
   listBuildMode.Add('   > Run -> Clean up and Build...');
   listBuildMode.Add(' ');
   listBuildMode.Add('3. From LazarusIDE menu:');
   listBuildMode.Add(' ');
   listBuildMode.Add('   > [LAMW] Build Android Apk and Run');
   listBuildMode.Add(' ');
   listBuildMode.SavetoFile(FPathToAndroidProject+'jni'+PathDelim+'build-modes'+PathDelim+'readme.txt');

   listBuildMode.Free;

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
  strList.SaveToFile(androidProjectName+'ant-build-debug.bat');

  strList.Clear;
  strList.Add('set Path=%PATH%;'+pathToAntBin);
  strList.Add('set JAVA_HOME='+pathToJavaJDK);
  strList.Add('cd '+androidProjectName);
  strList.Add('call ant clean release');
  strList.Add('if errorlevel 1 pause');
  strList.SaveToFile(androidProjectName+'ant-build-release.bat');

  strList.Clear;
  strList.Add('cd '+androidProjectName+'bin');
  strList.Add(FPathToAndroidSDK+'platform-tools'+
             DirectorySeparator+'adb install -r '+FSmallProjName+'-'+antBuildMode+'.apk');
  strList.Add('cd ..');
  strList.Add('pause');
  strList.SaveToFile(androidProjectName+'adb-install.bat');

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
  SaveShellScript(strList, androidProjectName+'ant-build-debug.sh');


  //MacOs
  strList.Clear;
  if pathToAntBin <> '' then
  begin
     strList.Add('export PATH='+linuxPathToAntBin+':$PATH');        //export PATH=/usr/bin/ant:PATH
     strList.Add('export JAVA_HOME=${/usr/libexec/java_home}');     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
     strList.Add('export PATH=${JAVA_HOME}/bin:$PATH');
     strList.Add('cd '+linuxAndroidProjectName);
     strList.Add('ant -Dtouchtest.enabled=true debug');
     SaveShellScript(strList, androidProjectName+'ant-build-debug-macos.sh');
  end;

  strList.Clear;
  if pathToAntBin <> '' then
     strList.Add('export PATH='+linuxPathToAntBin+':$PATH'); //export PATH=/usr/bin/ant:PATH

  strList.Add('export JAVA_HOME='+linuxPathToJavaJDK);     //export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
  strList.Add('cd '+linuxAndroidProjectName);
  strList.Add('ant clean release');
  SaveShellScript(strList, androidProjectName+'ant-build-release.sh');

  linuxPathToAdbBin:= linuxPathToAndroidSdk+'platform-tools';

  //linux install - thanks to Stephano!
  strList.Clear;
  strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+packageName);
  (*
  strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb install -r bin'+linuxDirSeparator+FSmallProjName+'-'+antBuildMode+'.apk');
  *)

  tempStr:= androidProjectName;
  {$ifdef windows}
  tempStr:= StringReplace(androidProjectName,PathDelim,linuxDirSeparator, [rfReplaceAll]);
  tempStr:= Copy(tempStr, 3, MaxInt); //drop C:
  {$endif}

  strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb install -r ' + tempStr + 'bin' + linuxDirSeparator+FSmallProjName+'-'+antBuildMode+'.apk');
  //strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat &');
  SaveShellScript(strList, androidProjectName+'adb-install.sh');

  strList.Clear;
  strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb uninstall '+packageName);
  SaveShellScript(strList, androidProjectName+'adb-uninstall.sh');

  strList.Clear;
  strList.Add(linuxPathToAdbBin+linuxDirSeparator+'adb logcat &');
  SaveShellScript(strList, androidProjectName+'logcat.sh');

  strList.Free;
end;

procedure TLamwSmartDesigner.TryChangeDemoProjecPaths;
var
  strList: TStringList;
  strResult: string;
  lpiFileName: string;
  strTemp: string;
  strCustom,  strLibrary: string;
  pathToDemoNDK,  pathToDemoNDKConverted: string;
  pathToDemoSDK: string;
  localSys: string;
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

  if FNDKIndex = '' then
    FNDKIndex := LamwGlobalSettings.GetNDK;

  if  FNDKIndex = '' then FNDKIndex:= '5';

  if (pathToDemoNDK <> '') and (FPathToAndroidNDK <> '') then
  begin

      LazarusIDE.ActiveProject.Modified:= True;

      //Libraries
      strTemp:= LazarusIDE.ActiveProject.LazCompilerOptions.Libraries;   //path already converted!!!

      strLibrary:= StringReplace(strTemp, pathToDemoNDKConverted,
                                         FPathToAndroidNDK,
                                         [rfReplaceAll,rfIgnoreCase]);

      //try
      strResult:= StringReplace(strLibrary, '4.6', '4.9', [rfReplaceAll,rfIgnoreCase]);


      FMaxNdk:= 22;  //android 4.x and 5.x compatibulty....

      strMaxNdk:= IntToStr(FMaxNdk);

      strResult:= TryChangePrebuildOSY(strResult); //LAMW 0.8
      if StrToInt(FNDKIndex) > 4 then  //LAMW 0.8
      begin
         strResult:= TryChangeTo49x(strResult)
      end
      else
         strResult:= TryChangeTo49(strResult);

      strResult:= TryChangeNdkPlatformsApi(strResult, FMaxNdk);

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

function TLamwSmartDesigner.IsDemoProject: boolean;
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

 function TrimChar(query: string; delimiter: char): string;
var
  auxStr: string;
  count: integer;
  newchar: char;
begin
  newchar:=' ';
  if query <> '' then
  begin
      auxStr:= Trim(query);
      count:= Length(auxStr);
      if count >= 2 then
      begin
         if auxStr[1] = delimiter then  auxStr[1] := newchar;
         if auxStr[count] = delimiter then  auxStr[count] := newchar;
      end;
      Result:= Trim(auxStr);
  end;
end;

function NextPos(delimiter: char; initialPos: integer; str: string): integer;
var
 i, count: integer;
begin
   i:= initialPos + 1;
   count:= Length(str);
   
   if not (str.IsEmpty) then
   begin
     while (str[i] <> delimiter) and (i <= count) do
     begin
       i:= i + 1;
     end;
     if str[i] = delimiter then
       Result:=i
     else
       Result:= initialPos;
   end;
end;

initialization
  LamwSmartDesigner := TLamwSmartDesigner.Create;

finalization
  LamwSmartDesigner.Free;

end.
