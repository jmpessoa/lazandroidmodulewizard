unit LamwSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ProjectIntf, Forms;

type

  { TLamwGlobalSettings }

  TLamwGlobalSettings = class
  public const
    Version = '0.7';
  private const
    IniFileName = 'JNIAndroidProject.ini';
    IniFileSection = 'NewProject';
  private
    FQueryPaths: Boolean; // prompt dialog if path is empty
    FPathToJavaTemplates: string;
    FPathToAndroidNDK: string;
    FPathToAndroidSDK: string;
    FPathToJavaJDK: string;
    FPathToAntBin: string;
    FFPUSet: string;
    FInstructionSet: string;
    function GetCanUpdateJavaTemplate: Boolean;
    function GetPath(var APath: string; const IniIdent, QueryPrompt: string): string;
    function GetPathToAndroidNDK: string;
    function GetPathToAndroidSDK: string;
    function GetPathToAntBin: string;
    function GetPathToJavaJDK: string;
    function GetPathToJavaTemplates: string;
    function GetInstructionSet: string;
  public
    constructor Create;
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

    property InstructionSet: string read GetInstructionSet;
  end;

var
  LamwGlobalSettings: TLamwGlobalSettings;

implementation

uses LazIDEIntf, {SrcEditorIntf,} StdCtrls, EditBtn, Controls,
  ButtonPanel, IniFiles;

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
      with TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath)
        + IniFileName) do
      try
        WriteString(IniFileSection, IniIdent, APath);
      finally
        Free;
      end;
  end;
  Result := IncludeTrailingPathDelimiter(APath);
end;

function TLamwGlobalSettings.GetCanUpdateJavaTemplate: Boolean;
var
  str: string;
begin
  Result:= True;
  with TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath)
    + IniFileName) do
  try
    str := ReadString(IniFileSection, 'CanUpdateJavaTemplate', '');
    if str = 'f' then Result:= False;
  finally
    Free;
  end;
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
  with TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + IniFileName) do
    try
      FInstructionSet:= ReadString(IniFileSection, 'InstructionSet', '');
    finally
      Free;
  end;
  Result:= FInstructionSet;
end;

constructor TLamwGlobalSettings.Create;
begin
  FQueryPaths := True;
end;

procedure TLamwGlobalSettings.ReloadPaths;
var
  fname: string;
begin
  fname := IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath) + IniFileName;
  if not FileExists(fname) then Exit;
  with TIniFile.Create(fname) do
  try
    FPathToJavaTemplates := ReadString(IniFileSection, 'PathToJavaTemplates', '');
    FPathToAndroidSDK    := ReadString(IniFileSection, 'PathToAndroidSDK',    '');
    FPathToAntBin        := ReadString(IniFileSection, 'PathToAntBin',        '');
    FPathToJavaJDK       := ReadString(IniFileSection, 'PathToJavaJDK',       '');
    FPathToAndroidNDK    := ReadString(IniFileSection, 'PathToAndroidNDK',    '');
  finally
    Free
  end;
end;

function TLamwGlobalSettings.GetNDK: string;
begin
  with TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath)
    + IniFileName) do
  try
    Result := ReadString(IniFileSection, 'NDK', '');
  finally
    Free
  end;
end;

initialization
  LamwGlobalSettings := TLamwGlobalSettings.Create;

finalization
  LamwGlobalSettings.Free;
end.

