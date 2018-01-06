unit LamwSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Forms, IniFiles;

type

  { TLamwGlobalSettings }

  TLamwGlobalSettings = class
  public const
    Version = '0.7';
  private const
    IniFileName = 'JNIAndroidProject.ini';
    IniFileSection = 'NewProject';
  private
    FIniFile: TIniFile;
    FQueryPaths: Boolean; // prompt dialog if path is empty
    FPathToJavaTemplates: string;
    FPathToAndroidNDK: string;
    FPathToAndroidSDK: string;
    FPathToJavaJDK: string;
    FPathToAntBin: string;
    FPathToGradle: string;
    FFPUSet: string;
    FInstructionSet: string;
    FDefaultBuildSystem: string;

    function GetDefaultBuildSystem: string;
    procedure ReloadIni;

    function ReadIniString(const Key: string; const Def: string = ''): string; inline;
    procedure SetDefaultBuildSystem(AValue: string);
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
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReloadPaths; // loading paths from INI
    function GetNDK: string;

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
    property DefaultBuildSystem: string read GetDefaultBuildSystem write SetDefaultBuildSystem;
  end;

var
  LamwGlobalSettings: TLamwGlobalSettings;

implementation

uses LazIDEIntf, StdCtrls, EditBtn, Controls, ButtonPanel;

function QueryPath(APrompt: string; out Path: string;
  ACaption: string = 'Android Wizard: Path Missing!'): Boolean;
var
  f: TForm;
  l: TLabel;
  de: TDirectoryEdit;
begin
  Result := False;
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
    'Path to Java templates: [ex. ..\LazAndroidWizard\java]');
end;

function TLamwGlobalSettings.GetPath(var APath: string; const IniIdent, QueryPrompt: string): string;
begin
  if APath = '' then ReloadPaths;
  if (APath = '') and FQueryPaths then
  begin
    if QueryPath(QueryPrompt, APath) then
      WriteIniString(IniIdent, APath);
  end;
  Result := IncludeTrailingPathDelimiter(APath);
end;

procedure TLamwGlobalSettings.ReloadIni;
begin
  FIniFile.Free;
  FIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + IniFileName);
  FIniFile.CacheUpdates := False;
end;

function TLamwGlobalSettings.GetDefaultBuildSystem: string;
begin
  Result := ReadIniString('DefaultBuildSystem', 'Ant');
end;

function TLamwGlobalSettings.GetPathToGradle: string;
begin
  Result := GetPath(FPathToGradle, 'PathToGradle',
    'Path to Gradle: [ex. C:\adt32\gradle-2.10]');
end;

function TLamwGlobalSettings.ReadIniString(const Key: string;
  const Def: string): string;
begin
  if FIniFile = nil then ReloadIni;
  Result := FIniFile.ReadString(IniFileSection, Key, Def);
end;

procedure TLamwGlobalSettings.SetDefaultBuildSystem(AValue: string);
begin
  WriteIniString('DefaultBuildSystem', AValue);
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
    'Path to Android NDK:  [ex. C:\adt32\ndk10]');
end;

function TLamwGlobalSettings.GetPathToAndroidSDK: string;
begin
  Result := GetPath(FPathToAndroidSDK, 'PathToAndroidSDK',
    'Path to Android SDK: [ex. C:\adt32\sdk]');
end;

function TLamwGlobalSettings.GetPathToAntBin: string;
begin
  Result := GetPath(FPathToAntBin, 'PathToAntBin',
    'Path to Ant bin: [ex. C:\adt32\ant\bin]');
end;

function TLamwGlobalSettings.GetPathToJavaJDK: string;
begin
  Result := GetPath(FPathToJavaJDK, 'PathToJavaJDK',
    'Path to Java JDK: [ex. C:\Program Files (x86)\Java\jdk1.7.0_21]');
end;

function TLamwGlobalSettings.GetInstructionSet: string;
begin
  FInstructionSet:= ReadIniString('InstructionSet');
  Result:= FInstructionSet;
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

procedure TLamwGlobalSettings.ReloadPaths;
begin
  ReloadIni;
  FPathToJavaTemplates := ReadIniString('PathToJavaTemplates');
  FPathToAndroidSDK    := ReadIniString('PathToAndroidSDK');
  FPathToJavaJDK       := ReadIniString('PathToJavaJDK');
  FPathToAndroidNDK    := ReadIniString('PathToAndroidNDK');
  FPathToAntBin        := ReadIniString('PathToAntBin');
  FPathToGradle        := ReadIniString('PathToGradle');
end;

function TLamwGlobalSettings.GetNDK: string;
begin
  Result := ReadIniString('NDK');
end;

initialization
  LamwGlobalSettings := TLamwGlobalSettings.Create;

finalization
  LamwGlobalSettings.Free;
end.

