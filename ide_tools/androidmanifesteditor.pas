unit AndroidManifestEditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, laz2_XMLRead, Laz2_DOM, AvgLvlTree,
  IDEOptionsIntf, ProjectIntf, Forms, Controls, Dialogs, Grids, StdCtrls,
  LResources, ExtCtrls, Spin;

type

  { TLamwAndroidManifestOptions }

  TLamwAndroidManifestOptions = class
  private
    xml: TXMLDocument; // AndroidManifest.xml
    FFileName: string;
    FPermissions: TStringList;
    FPermNames: TStringToStringTree;
    FUsesSDKNode: TDOMElement;
    FMinSdkVersion, FTargetSdkVersion: Integer;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load(AFileName: string);
    procedure Save;

    property Permissions: TStringList read FPermissions;
    property PermNames: TStringToStringTree read FPermNames;
    property MinSDKVersion: Integer read FMinSdkVersion write FMinSdkVersion;
    property TargetSDKVersion: Integer read FTargetSdkVersion write FTargetSdkVersion;
  end;

  { TLamwAndroidManifestEditor }

  TLamwAndroidManifestEditor = class(TAbstractIDEOptionsEditor)
    Label1: TLabel;
    Label2: TLabel;
    lblErrorMessage: TLabel;
    ErrorPanel: TPanel;
    seMinSdkVersion: TSpinEdit;
    seTargetSdkVersion: TSpinEdit;
    PermissonGrid: TStringGrid;
    procedure PermissonGridResize(Sender: TObject);
  private
    { private declarations }
    FOptions: TLamwAndroidManifestOptions;
    procedure ErrorMessage(const msg: string);
    procedure FillPermissionGrid(Permissions: TStringList; PermNames: TStringToStringTree);
    procedure SetControlsEnabled(en: Boolean);
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function SupportedOptionsClass: TAbstractIDEOptionsClass; override;
    function GetTitle: String; override;
    procedure Setup({%H-}ADialog: TAbstractOptionsEditorDialog); override;
    procedure ReadSettings({%H-}AOptions: TAbstractIDEOptions); override;
    procedure WriteSettings({%H-}AOptions: TAbstractIDEOptions); override;
  end;

implementation

uses LazIDEIntf, laz2_XMLWrite, Graphics, strutils;

{$R *.lfm}

{ TLamwAndroidManifestOptions }

procedure TLamwAndroidManifestOptions.Clear;
begin
  xml.Free;
  FUsesSDKNode := nil;
  FMinSdkVersion := 11;
  FTargetSdkVersion := 19;
  FPermissions.Clear;
end;

constructor TLamwAndroidManifestOptions.Create;

  procedure AddPerm(PermVisibleName: string; android_name: string = '');
  begin
    if android_name = '' then
      android_name := 'android.permission.'
        + StringReplace(UpperCase(PermVisibleName), ' ', '_', [rfReplaceAll]);
    FPermNames[android_name] := PermVisibleName;
  end;

begin
  FPermissions := TStringList.Create;
  FPermNames := TStringToStringTree.Create(True);
  AddPerm('Bluetooth');
  AddPerm('Access bluetooth share');
  AddPerm('Access coarse location');
  AddPerm('Access fine location');
  AddPerm('Access network state');
  AddPerm('Access wifi state');
  AddPerm('Bluetooth admin');
  AddPerm('Call phone');
  AddPerm('Camera');
  AddPerm('Change wifi state');
  AddPerm('Internet');
  AddPerm('NFC');
  AddPerm('Read contacts');
  AddPerm('Read external storage');
  AddPerm('Read owner data');
  AddPerm('Read phone state');
  AddPerm('Restart packages');
  AddPerm('Send SMS');
  AddPerm('Write external storage');
  AddPerm('Write owner data');
  AddPerm('Write user dictionary');
  { todo:
  Access location extra commands
  Access mock location
  Add voicemail
  Authenticate accounts
  Battery stats
  Bind accessibility service
  Bind device admin
  Bind input method
  Bind remoteviews
  Bind text service
  Bind vpn service
  Bind wallpaper
  Broadcast sticky
  Change configuration
  Change network state
  Change wifi multicast state
  Clear app cache
  Disable keyguard
  Expand status bar
  Flashlight
  Get accounts
  Get package size
  Get tasks
  Global search
  Kill background processes
  Manage accounts
  Modify audio settings
  Process outgoing calls
  Read calendar
  Read call log
  Read history bookmarks
  Read profile
  Read SMS
  Read social stream
  Read sync settings
  Read sync stats
  Read user dictionary
  Receive boot completed
  Receive MMS
  Receive SMS
  Receive WAP push
  Record audio
  Reorder tasks
  Set alarm
  Set time zone
  Set wallpaper
  Subscribed feeds read
  Subscribed feeds write
  System alert window
  Use credentials
  Use SIP
  Vending billing (In-app Billing)
  Vibrate
  Wake lock
  Write calendar
  Write call log
  Write contacts
  Write history bookmarks
  Write profile
  Write settings
  Write SMS
  Write social stream
  Write sync settings
  Write user dictionary
  + Advanced...
  }
  FPermissions.Sorted := True;
end;

destructor TLamwAndroidManifestOptions.Destroy;
begin
  FPermNames.Free;
  FPermissions.Free;
  xml.Free;
  inherited Destroy;
end;

procedure TLamwAndroidManifestOptions.Load(AFileName: string);
var
  i, j: Integer;
  s, v: string;
  n: TDOMNode;
begin
  Clear;
  ReadXMLFile(xml, AFileName);
  FFileName := AFileName;
  if (xml = nil) or (xml.DocumentElement = nil) then Exit;
  with xml.DocumentElement.ChildNodes do
  begin
    FPermNames.GetNames(FPermissions);
    for i := Count - 1 downto 0 do
      if Item[i].NodeName = 'uses-permission' then
      begin
        s := Item[i].Attributes.GetNamedItem('android:name').TextContent;
        j := FPermissions.IndexOf(s);
        if j >= 0 then
          FPermissions.Objects[j] := TObject(PtrUInt(1))
        else begin
          v := Copy(s, RPos('.', s) + 1, MaxInt);
          FPermNames[s] := v;
          FPermissions.AddObject(s, TObject(PtrUInt(1)));
        end;
        xml.ChildNodes[0].DetachChild(Item[i]).Free;
      end else
      if Item[i].NodeName = 'uses-sdk' then
      begin
        FUsesSDKNode := Item[i] as TDOMElement;
        n := FUsesSDKNode.Attributes.GetNamedItem('android:minSdkVersion');
        if Assigned(n) then
          FMinSdkVersion := StrToIntDef(n.TextContent, FMinSdkVersion);
        n := FUsesSDKNode.Attributes.GetNamedItem('android:targetSdkVersion');
        if Assigned(n) then
          FTargetSdkVersion := StrToIntDef(n.TextContent, FTargetSdkVersion);
      end;
  end;
end;

procedure TLamwAndroidManifestOptions.Save;
var
  i: Integer;
  r: TDOMNode;
  n: TDOMElement;
begin
  // writing manifest
  if not Assigned(xml) then Exit;

  if not Assigned(FUsesSDKNode) then
  begin
    FUsesSDKNode := xml.CreateElement('uses-sdk');
    with xml.DocumentElement do
      if ChildNodes.Count = 0 then
        AppendChild(FUsesSDKNode)
      else
        InsertBefore(FUsesSDKNode, ChildNodes[0]);
  end;
  with FUsesSDKNode do
  begin
    AttribStrings['android:minSdkVersion'] := IntToStr(FMinSdkVersion);
    AttribStrings['android:targetSdkVersion'] := IntToStr(FTargetSdkVersion);
  end;

  // permissions
  r := FUsesSDKNode.NextSibling;
  for i := 0 to FPermissions.Count - 1 do
    if FPermissions.Objects[i] <> nil then
    begin
      n := xml.CreateElement('uses-permission');
      n.AttribStrings['android:name'] := FPermissions[i];
      if Assigned(r) then
        xml.ChildNodes[0].InsertBefore(n, r)
      else
        xml.ChildNodes[0].AppendChild(n);
    end;
  WriteXMLFile(xml, FFileName);
end;

{ TLamwAndroidManifestEditor }

procedure TLamwAndroidManifestEditor.PermissonGridResize(Sender: TObject);
begin
  with PermissonGrid do
    ColWidths[0] := ClientWidth - ColWidths[1];
end;

procedure TLamwAndroidManifestEditor.SetControlsEnabled(en: Boolean);
var
  i: Integer;
begin
  for i := 0 to ControlCount - 1 do
    Controls[i].Enabled := en;
end;

constructor TLamwAndroidManifestEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOptions := TLamwAndroidManifestOptions.Create;
end;

destructor TLamwAndroidManifestEditor.Destroy;
begin
  FOptions.Free;
  inherited Destroy;
end;

procedure TLamwAndroidManifestEditor.ErrorMessage(const msg: string);
begin
  lblErrorMessage.Caption := msg;
  ErrorPanel.Visible := True;
  ErrorPanel.Enabled := True;
end;

procedure TLamwAndroidManifestEditor.FillPermissionGrid(Permissions: TStringList;
  PermNames: TStringToStringTree);
var
  i: Integer;
  n: string;
begin
  PermissonGrid.BeginUpdate;
  try
    PermissonGrid.RowCount := Permissions.Count + 1;
    with PermissonGrid do
      for i := 0 to Permissions.Count - 1 do
      begin
        n := PermNames[Permissions[i]];
        if n = '' then
          n := Permissions[i];
        Cells[0, i + 1] := n;
        if Permissions.Objects[i] = nil then
          Cells[1, i + 1] := '0'
        else
          Cells[1, i + 1] := '1'
      end;
  finally
    PermissonGrid.EndUpdate;
  end;
end;

class function TLamwAndroidManifestEditor.SupportedOptionsClass: TAbstractIDEOptionsClass;
begin
  Result := nil;
end;

function TLamwAndroidManifestEditor.GetTitle: string;
begin
  Result := '[Lamw] Android Manifest';
end;

procedure TLamwAndroidManifestEditor.Setup(ADialog: TAbstractOptionsEditorDialog);
begin
  // localization
end;

procedure TLamwAndroidManifestEditor.ReadSettings(AOptions: TAbstractIDEOptions);
var
  proj: TLazProject;
  fn: string;
begin
  // reading manifest
  SetControlsEnabled(False);
  proj := LazarusIDE.ActiveProject;
  if (proj = nil) or (proj.IsVirtual) then Exit;
  fn := proj.MainFile.Filename;
  fn := Copy(fn, 1, Pos(PathDelim + 'jni' + PathDelim, fn));
  fn := fn + 'AndroidManifest.xml';
  if not FileExistsUTF8(fn) then
  begin
    ErrorMessage('"' + fn + '" not found!');
    Exit;
  end;
  try
    with FOptions do
    begin
      Load(fn);
      FillPermissionGrid(Permissions, PermNames);
      seMinSdkVersion.Value := MinSDKVersion;
      seTargetSdkVersion.Value := TargetSDKVersion;
    end;
  except
    on e: Exception do
    begin
      ErrorMessage(e.Message);
      Exit;
    end
  end;
  SetControlsEnabled(True);
end;

procedure TLamwAndroidManifestEditor.WriteSettings(AOptions: TAbstractIDEOptions);
var
  i: Integer;
begin
  with FOptions do
  begin
    for i := PermissonGrid.RowCount - 1 downto 1 do
      if PermissonGrid.Cells[1, i] <> '1' then
        Permissions.Delete(i - 1);
    MinSDKVersion := seMinSdkVersion.Value;
    TargetSDKVersion := seTargetSdkVersion.Value;
    Save;
  end;
end;

initialization
  RegisterIDEOptionsEditor(GroupProject, TLamwAndroidManifestEditor, 1000);

end.

