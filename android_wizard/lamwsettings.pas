unit LamwSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ProjectIntf, Forms, IniFiles;

type
  TSupportLib = record
    MinAPI:integer;
    Name:string;
  end;

  TAppCompatLib = record
    MinAPI:integer;
    Name:string;
  end;

  TSupportLibs = array[0..1] of TSupportLib;
  TAppCompatLibs = array[0..2] of TAppCompatLib;

  { TLamwGlobalSettings }

  TLamwGlobalSettings = class
  public const
    Version = '0.8.6.4';
  private const
    IniFileName = 'LAMW.ini';
    IniFileSection = 'NewProject';
  private
    FIniFile: TIniFile;
    FQueryPaths: Boolean; // prompt dialog if path is empty
    FPathToJavaTemplates: string;
    FPathToSmartDesigner: string; //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
    FPathToAndroidNDK: string;
    FPathToAndroidSDK: string;
    FPathToJavaJDK: string;
    FPathToAntBin: string;
    FPathToGradle: string;
    FInstructionSet: string;
    FPrebuildOSYS: string;
    FNDK: string;
    FNDKRelease: string;

    //function GetDefaultBuildSystem: string;
    procedure ReloadIni;

    function ReadIniString(const Key: string; const Def: string = ''): string; inline;
    //procedure SetDefaultBuildSystem(AValue: string);
    procedure SetGradleVersion(AValue: string);
    procedure WriteIniString(const Key, Value: string);

    function GetPath(var APath: string; const IniIdent, QueryPrompt: string): string;
    function GetPathToAndroidNDK: string;
    function GetPathToAndroidSDK: string;
    function GetPathToJavaJDK: string;
    function GetPathToJavaTemplates: string;
    function GetPathToAntBin: string;
    function GetPathToGradle: string;

    function GetCanUpdateJavaTemplate: Boolean;
    function GetInstructionSet: string;
    function GetPrebuildOSYS: string;
    function GetKeepManifestTargetApi: boolean;

    function DoPathToSmartDesigner(): string;
    function GetPathToSmartDesigner(): string;

  public
    constructor Create;
    destructor Destroy; override;
    procedure ReloadPaths; // loading paths from INI
    function GetNDK: string;
    function GetNDKRelease: string;
    // if QueryPaths=True then retreiving paths through PathToXXX properties
    // will invoke a path prompt dialog when FPathToXXX is empty
    property QueryPaths: Boolean read FQueryPaths write FQueryPaths;

    // volatile :: <> 'f'
    property CanUpdateJavaTemplate: Boolean read GetCanUpdateJavaTemplate;

    // all paths have trailing path delim
    property PathToJavaTemplates: string read GetPathToJavaTemplates;
    property PathToAndroidNDK: string read GetPathToAndroidNDK;
    property PathToAndroidSDK: string read GetPathToAndroidSDK;
    property PathToJavaJDK: string read GetPathToJavaJDK;
    property PathToAntBin: string read GetPathToAntBin;
    property PathToGradle: string read GetPathToGradle;
    property InstructionSet: string read GetInstructionSet;
    property PrebuildOSYS: string read  GetPrebuildOSYS;

    // volatile :: = 't'
    property KeepManifestTargetApi: boolean read GetKeepManifestTargetApi;
    property PathToSmartDesigner: string read GetPathToSmartDesigner;
  end;

const
  //ref.   https://androidx.tech/artifacts/appcompat/appcompat/1.6.1
  //androidx.appcompat:appcompat than 1.3.1 is available: 1.6.1

  //ref https://github.com/material-components/material-components-android/releases
  //com.google.android.material:material than 1.2.1 is available: 1.11.0

  //ref https://android-developers.googleblog.com/2023/10/androidx-minsdkversion-19.html

  AppCompatLibs: TAppCompatLibs = (
    (MinAPI:28;Name:'androidx.appcompat:appcompat:1.7.0'),  //1.3.1
    (MinAPI:28;Name:'androidx.multidex:multidex:2.0.1'),
    (MinAPI:28;Name:'com.google.android.material:material:1.12.0')  //1.2.1
  );

  SupportLibs: TSupportLibs = (
    (MinAPI:28;Name:'androidx.core:core:1.9.0'),   //1.2.0
    (MinAPI:28;Name:'androidx.multidex:multidex:2.0.1')
  );

var
  LamwGlobalSettings: TLamwGlobalSettings;

implementation

uses PackageIntf, LazIDEIntf, StdCtrls, EditBtn, Controls, ButtonPanel;

function QueryPath(APrompt: string; out Path: string;
  ACaption: string = 'Android Wizard [LamwSettings]: Path Missing!'): Boolean;
var
  f: TForm;
  l: TLabel;
  de: TDirectoryEdit;
begin
  Result := False;

  if LazarusIDE.ActiveProject.CustomData.Values['LAMW']= '' then Exit;

  f := TForm.Create(nil);
  with f do
  try
    Caption := ACaption;
    Position := poScreenCenter;
    AutoSize := True;
    Constraints.MinWidth := 440;
    BorderStyle := bsSingle;
    BorderIcons := [biSystemMenu];
    l := TLabel.Create(f);
    with l do
    begin
      Parent := f;
      Caption := APrompt;
      AnchorSideLeft.Control := f;
      AnchorSideTop.Control := f;
      BorderSpacing.Around := 8;
    end;
    de := TDirectoryEdit.Create(f);
    with de do
    begin
      Parent := f;
      if Pos(':', APrompt) > 0 then
        DialogTitle := Copy(APrompt, 1, Pos(':', APrompt) - 1)
      else
        DialogTitle := APrompt;
      AnchorSideLeft.Control := f;
      AnchorSideTop.Control := l;
      AnchorSideTop.Side := asrBottom;
      AnchorSideRight.Control := f;
      AnchorSideRight.Side := asrRight;
      Anchors := [akTop, akLeft, akRight];
      BorderSpacing.Around := 8;
    end;
    with TButtonPanel.Create(f) do
    begin
      Parent := f;
      ShowButtons := [pbOK, pbCancel];
      AnchorSideTop.Control := de;
      AnchorSideTop.Side := asrBottom;
      Anchors := [akTop, akLeft, akRight];
      ShowBevel := False;
    end;
    if ShowModal = mrOK then
    begin
      Path := de.Directory;
      Result := True;
    end;
  finally
    Free;
  end;
end;

{ TLamwGlobalSettings }

function TLamwGlobalSettings.GetPathToJavaTemplates: string;
begin
  Result := GetPath(FPathToJavaTemplates, 'PathToJavaTemplates',
    'Path to Java templates: [ex. ..\LazAndroidWizard\android_wizard\smartdesigner\java]');
end;

function TLamwGlobalSettings.GetPath(var APath: string; const IniIdent, QueryPrompt: string): string;
begin
  Result:= '';
  if APath = '' then ReloadPaths;
  if (APath = '') and FQueryPaths then
  begin
    QueryPath(QueryPrompt, APath);
  end;
  if APath <> '' then
  begin
    Result := IncludeTrailingPathDelimiter(APath);
    WriteIniString(IniIdent, APath);
  end
end;

function TLamwGlobalSettings.GetPathToSmartDesigner(): string;
begin
  Result:= IncludeTrailingPathDelimiter(FPathToSmartDesigner);
end;

function TLamwGlobalSettings.DoPathToSmartDesigner(): string;
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
        Result := FPathToSmartDesigner; //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
    end;
  end
  else Result:= FPathToSmartDesigner;
end;

procedure TLamwGlobalSettings.ReloadIni;
var
  flag: boolean;
begin

  flag:= False;
  if not FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini') then
  begin
    if FileExists(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini') then
    begin
       CopyFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini',
                IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'LAMW.ini');
       //DeleteFile(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + 'JNIAndroidProject.ini');


       //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner
       FPathToSmartDesigner:= DoPathToSmartDesigner();

       //C:\laz4android18FPC304\components\androidmodulewizard\android_wizard\smartdesigner\java
       FPathToJavaTemplates:= FPathToSmartDesigner + pathDelim +'java';
       flag:= True;
    end;
  end;

  FIniFile.Free;
  FIniFile:= TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + IniFileName);
  FIniFile.CacheUpdates:= False;

  if flag then
  begin
    WriteIniString('PathToSmartDesigner', FPathToSmartDesigner);
    WriteIniString('PathToJavaTemplates', FPathToJavaTemplates);
  end;

end;

{
function TLamwGlobalSettings.GetDefaultBuildSystem: string;
begin
  Result := ReadIniString('DefaultBuildSystem', 'Ant');
end;
}

function TLamwGlobalSettings.GetPathToGradle: string;
begin
  Result := GetPath(FPathToGradle, 'PathToGradle',
    'Path to Gradle: [ex. C:\lamw\gradle-7.6.3]');
end;

function TLamwGlobalSettings.ReadIniString(const Key: string;
  const Def: string): string;
begin
  if FIniFile = nil then ReloadIni;
  Result := FIniFile.ReadString(IniFileSection, Key, Def);
end;

procedure TLamwGlobalSettings.SetGradleVersion(AValue: string);
begin
  WriteIniString('GradleVersion', AValue);
end;

procedure TLamwGlobalSettings.WriteIniString(const Key, Value: string);
begin
  if FIniFile <> nil then
    FIniFile.WriteString(IniFileSection, Key, Value);
end;

function TLamwGlobalSettings.GetCanUpdateJavaTemplate: Boolean;
var
  str: string;
begin
  Result:= True;
  ReloadIni;
  str := ReadIniString('CanUpdateJavaTemplate');
  if str = 'f' then Result:= False;
end;

function TLamwGlobalSettings.GetPathToAndroidNDK: string;
begin
  Result := GetPath(FPathToAndroidNDK, 'PathToAndroidNDK',
    'Path to Android NDK:  [ex. C:\lamw\ndk]');
end;

function TLamwGlobalSettings.GetPathToAndroidSDK: string;
begin
  Result := GetPath(FPathToAndroidSDK, 'PathToAndroidSDK',
    'Path to Android SDK: [ex. C:\lamw\sdk]');
end;

function TLamwGlobalSettings.GetPathToAntBin: string;
begin
  Result := GetPath(FPathToAntBin, 'PathToAntBin',
    'Path to Ant bin: [ex. C:\lamw\ant\bin]');
end;

function TLamwGlobalSettings.GetPathToJavaJDK: string;
begin
  Result := GetPath(FPathToJavaJDK, 'PathToJavaJDK',
    'Path to Java JDK: [ex. C:\Program Files (x86)\Java\jdk1.8.xx]');
end;

function TLamwGlobalSettings.GetInstructionSet: string;
begin
  Self.ReloadPaths;
  FInstructionSet:= ReadIniString('InstructionSet');
  Result:= FInstructionSet;
end;

function TLamwGlobalSettings.GetPrebuildOSYS: string;
begin
  FPrebuildOSYS:= ReadIniString('PrebuildOSYS');
  Result:= FPrebuildOSYS;
end;

function TLamwGlobalSettings.GetKeepManifestTargetApi: boolean;
var
  keepManifestApi: string;
begin
  Result:= False;
  ReloadIni;
  keepManifestApi:= ReadIniString('KeepManifestTargetApi');
  if keepManifestApi = 't' then Result:= True;
end;

constructor TLamwGlobalSettings.Create;
begin
  FQueryPaths := True;
end;

destructor TLamwGlobalSettings.Destroy;
begin
  FIniFile.Free;
  inherited Destroy;
end;

{
NDK=5
PrebuildOSYS=

}
procedure TLamwGlobalSettings.ReloadPaths;
begin
  ReloadIni;
  FPathToJavaTemplates := ReadIniString('PathToJavaTemplates');
  FPathToAndroidSDK    := ReadIniString('PathToAndroidSDK');
  FPathToJavaJDK       := ReadIniString('PathToJavaJDK');
  FPathToAndroidNDK    := ReadIniString('PathToAndroidNDK');
  FPathToAntBin        := ReadIniString('PathToAntBin');
  FPathToGradle        := ReadIniString('PathToGradle');
  FPathToSmartDesigner := ReadIniString('PathToSmartDesigner');
  FNDK                 := ReadIniString('NDK');
  FPrebuildOSYS        := ReadIniString('PrebuildOSYS');
  FInstructionSet      := ReadIniString('InstructionSet');
  FNDKRelease          := ReadIniString('NDKRelease');
end;

function TLamwGlobalSettings.GetNDK: string;
begin
  Result := ReadIniString('NDK'); {index 3/r10e , index  4/11x, index 5/12...18, index 6/19....}
end;

function TLamwGlobalSettings.GetNDKRelease: string;
begin
  Result := ReadIniString('NDKRelease'); //18.1.506304
end;

initialization
  LamwGlobalSettings := TLamwGlobalSettings.Create;

finalization
  LamwGlobalSettings.Free;
end.

