unit AndroidProjOptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, laz2_XMLRead, Laz2_DOM, AvgLvlTree,
  IDEOptionsIntf, ProjectIntf, Forms, Controls, Dialogs, Grids, StdCtrls,
  LResources, ExtCtrls, Spin, ComCtrls, Buttons;

type

  { TLamwAndroidManifestOptions }

  TLamwAndroidManifestOptions = class
  private
    xml: TXMLDocument; // AndroidManifest.xml
    FFileName: string;
    FPermissions: TStringList;
    FPermNames: TStringToStringTree;
    FUsesSDKNode: TDOMElement;
    FApplicationNode: TDOMElement;
    FMinSdkVersion, FTargetSdkVersion: Integer;
    FVersionCode: Integer;
    FVersionName: string;
    FLabelAvailable: Boolean;
    FLabel, FRealLabel: string;
    FIconFileName: string;
    function GetString(const XMLPath, Ref: string; out Res: string): Boolean;
    procedure SetString(const XMLPath, Ref, NewValue: string);
    procedure Clear;
    procedure UpdateBuildXML;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load(AFileName: string);
    procedure Save;

    property Permissions: TStringList read FPermissions;
    property PermNames: TStringToStringTree read FPermNames;
    property MinSDKVersion: Integer read FMinSdkVersion write FMinSdkVersion;
    property TargetSDKVersion: Integer read FTargetSdkVersion write FTargetSdkVersion;
    property VersionCode: Integer read FVersionCode write FVersionCode;
    property VersionName: string read FVersionName write FVersionName;
    property AppLabel: string read FRealLabel write FRealLabel;
    property IconFileName: string read FIconFileName;
  end;

  { TLamwProjectOptions }

  TLamwProjectOptions = class(TAbstractIDEOptionsEditor)
    cbTheme: TComboBox;
    cbLaunchIconSize: TComboBox;
    edLabel: TEdit;
    edVersionName: TEdit;
    ErrorPanel: TPanel;
    gbVersion: TGroupBox;
    GroupBox1: TGroupBox;
    imLauncherIcon: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblErrorMessage: TLabel;
    PageControl1: TPageControl;
    PermissonGrid: TStringGrid;
    seMinSdkVersion: TSpinEdit;
    seTargetSdkVersion: TSpinEdit;
    seVersionCode: TSpinEdit;
    SpeedButton1: TSpeedButton;
    SpeedButtonHintTheme: TSpeedButton;
    tsAppl: TTabSheet;
    tsManifest: TTabSheet;
    procedure cbLaunchIconSizeSelect(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
    const
      Drawable: array [0..4] of record
        Size: Integer;
        Suffix: string;
      end = ((Size:36;  Suffix:'ldpi'),
             (Size:48;  Suffix:'mdpi'),
             (Size:72;  Suffix:'hdpi'),
             (Size:96;  Suffix:'xhdpi'),
             (Size:144; Suffix:'xxhdpi'));
  private
    FManifest: TLamwAndroidManifestOptions;
    FIconsPath: string; // ".../res/drawable-"
    procedure ErrorMessage(const msg: string);
    procedure FillPermissionGrid(Permissions: TStringList; PermNames: TStringToStringTree);
    procedure SetControlsEnabled(ts: TTabSheet; en: Boolean);
    procedure ShowLauncherIcon;
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

uses LazIDEIntf, laz2_XMLWrite, FileUtil, Graphics, ExtDlgs, FPCanvas, FPimage,
  FPReadPNG, FPWritePNG, strutils;

{$R *.lfm}

type

  { TMyCanvas }

  TMyCanvas = class(TFPCustomCanvas)
  private
    FImage: TFPMemoryImage;
  protected
    procedure SetColor(x, y: integer; const Value: TFPColor); override;
  public
    constructor Create;
    destructor Destroy; override;
    property Image: TFPMemoryImage read FImage;
  end;

procedure ResizePNG(p: TPortableNetworkGraphic; NeedSize: Integer);
var
  ms: TMemoryStream;
  r: TFPReaderPNG;
  mi: TFPMemoryImage;
  c: TMyCanvas;
begin
  ms := TMemoryStream.Create;
  p.SaveToStream(ms);
  ms.Position := 0;
  mi := TFPMemoryImage.Create(0,0);
  r := TFPReaderPNG.Create;
  mi.LoadFromStream(ms, r);
  r.Free;
  ms.Free;
  {$Push}{$Warnings off}
  c := TMyCanvas.Create;
  {$Pop}
  c.Image.SetSize(NeedSize, NeedSize);
  c.StretchDraw(0, 0, NeedSize, NeedSize, mi);
  mi.Free;
  p.Assign(c.Image);
  c.Free;
end;

{ TMyCanvas }

procedure TMyCanvas.SetColor(x, y: integer; const Value: TFPColor);
begin
  FImage.Colors[x, y] := Value;
end;

constructor TMyCanvas.Create;
begin
  FImage := TFPMemoryImage.create(0,0);
end;

destructor TMyCanvas.Destroy;
begin
  FImage.Free;
end;

{ TLamwAndroidManifestOptions }

function TLamwAndroidManifestOptions.GetString(const XMLPath, Ref: string;
  out Res: string): Boolean;
var
  x: TXMLDocument;
  tag, name: string;
  n: TDOMNode;
begin
  Result := False;
  tag := Copy(Ref, 2, Pos('/', Ref) - 2);
  name := Copy(Ref, Pos('/', Ref) + 1, MaxInt);
  if not FileExists(XMLPath) then Exit;
  ReadXMLFile(x, XMLPath);
  try
    n := x.DocumentElement.FirstChild;
    while n <> nil do
    begin
      if (n is TDOMElement) then
        with TDOMElement(n) do
          if (TagName = tag) and (AttribStrings['name'] = name) then
          begin
            Res := TextContent;
            Result := True;
            Exit;
          end;
      n := n.NextSibling
    end;
  finally
    x.Free
  end;
end;

procedure TLamwAndroidManifestOptions.SetString(const XMLPath, Ref, NewValue: string);
var
  x: TXMLDocument;
  n: TDOMNode;
  tag, name: string;
  Changed: Boolean;
begin
  tag := Copy(Ref, 2, Pos('/', Ref) - 2);
  name := Copy(Ref, Pos('/', Ref) + 1, MaxInt);
  ReadXMLFile(x, XMLPath);
  try
    n := x.DocumentElement.FirstChild;
    Changed := False;
    while n <> nil do
    begin
      if n is TDOMElement then
        with TDOMElement(n) do
          if (TagName = tag) and (AttribStrings['name'] = name) then
          begin
            TextContent := NewValue;
            Changed := True;
            Break;
          end;
      n := n.NextSibling;
    end;
    if not Changed then
    begin
      n := x.CreateElement(tag);
      with TDOMElement(n) do
      begin
        AttribStrings['name'] := name;
        TextContent := NewValue;
      end;
      x.DocumentElement.AppendChild(n);
    end;
    WriteXMLFile(x, XMLPath);
  finally
    x.Free
  end;
end;

procedure TLamwAndroidManifestOptions.Clear;
begin
  xml.Free;
  FUsesSDKNode := nil;
  FMinSdkVersion := 11;
  FTargetSdkVersion := 19;
  FPermissions.Clear;
end;

procedure TLamwAndroidManifestOptions.UpdateBuildXML;
var
  fn: string;
  build: TXMLDocument;
  n: TDOMNode;
begin
  fn := ExtractFilePath(FFileName) + 'build.xml';
  if not FileExists(fn) then Exit;
  ReadXMLFile(build, fn);
  try
    n := build.DocumentElement.FirstChild;
    while n <> nil do
    begin
      if n is TDOMElement then
        with TDOMElement(n) do
          if (TagName = 'property') and (AttribStrings['name'] = 'target') then
          begin
            AttribStrings['value'] := 'android-' + IntToStr(FTargetSdkVersion);
            WriteXMLFile(build, fn);
            Break;
          end;
      n := n.NextSibling;
    end;
  finally
    build.Free
  end;
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
  FIconFileName := 'ic_launcher'; // ".png"
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
  AddPerm('Receive SMS');
  AddPerm('Restart packages');
  AddPerm('Send SMS');
  AddPerm('Vibrate');
  AddPerm('Write contacts');
  AddPerm('Write external storage');
  AddPerm('Write owner data');
  AddPerm('Write user dictionary');
  AddPerm('Wake lock');
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
  Write calendar
  Write call log
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
  with xml.DocumentElement do
  begin
    FVersionCode := StrToIntDef(AttribStrings['android:versionCode'], 1);
    FVersionName := AttribStrings['android:versionName'];
  end;
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
  n := xml.DocumentElement.FindNode('application');
  if n is TDOMElement then
  begin
    FApplicationNode := TDOMElement(n);
    FLabelAvailable := True;
    FLabel := TDOMElement(n).AttribStrings['android:label'];
    if (FLabel <> '') and (FLabel[1] = '@') then
    begin
      // @string/app_name
      // <string name="app_name">LamwGUIProject1</string>
      if not GetString(ExtractFilePath(FFileName) + PathDelim
        + 'res' + PathDelim + 'values' + PathDelim + 'strings.xml', FLabel, FRealLabel)
      then begin
        FRealLabel := '<null>';
        FLabelAvailable := False;
      end;
    end else
      FRealLabel := FLabel;
  end;
end;

procedure TLamwAndroidManifestOptions.Save;
var
  i: Integer;
  r: TDOMNode;
  n: TDOMElement;
  fn: string;
begin
  // writing manifest
  if not Assigned(xml) then Exit;

  xml.DocumentElement.AttribStrings['android:versionCode'] := IntToStr(FVersionCode);
  xml.DocumentElement.AttribStrings['android:versionName'] := FVersionName;

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
  begin
    n := xml.CreateElement('uses-permission');
    n.AttribStrings['android:name'] := FPermissions[i];
    if Assigned(r) then
      xml.ChildNodes[0].InsertBefore(n, r)
    else
      xml.ChildNodes[0].AppendChild(n);
  end;
  UpdateBuildXML;

  if FLabelAvailable and (FLabel <> '') and (FLabel[1] <> '@')
  and (FApplicationNode <> nil) then
    FApplicationNode.AttribStrings['android:label'] := FLabel;
  WriteXMLFile(xml, FFileName);

  if FLabelAvailable and (FLabel <> '') and (FLabel[1] = '@') then
  begin
    fn := ExtractFilePath(FFileName) + PathDelim + 'res' + PathDelim;
    fn := fn + 'values' + PathDelim + 'strings.xml';
    if FileExists(fn) then
      SetString(fn, FLabel, FRealLabel)
  end;
end;

{ TLamwProjectOptions }

procedure TLamwProjectOptions.SetControlsEnabled(ts: TTabSheet;
  en: Boolean);
var
  i: Integer;
begin
  with ts do
    for i := 0 to ControlCount - 1 do
      Controls[i].Enabled := en;
  ErrorPanel.Enabled := True;
end;

procedure TLamwProjectOptions.ShowLauncherIcon;
var
  p: TPortableNetworkGraphic;
  fn: string;
begin
  with cbLaunchIconSize do
    p := TPortableNetworkGraphic(Items.Objects[ItemIndex]);
  if p <> nil then
  begin
    imLauncherIcon.Picture.Assign(p);
    Exit;
  end;
  fn := FIconsPath + Drawable[cbLaunchIconSize.ItemIndex].Suffix + PathDelim
    + FManifest.IconFileName + '.png';
  if FileExists(fn) then
    imLauncherIcon.Picture.LoadFromFile(fn)
  else
    imLauncherIcon.Picture.Clear;
end;

constructor TLamwProjectOptions.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FManifest := TLamwAndroidManifestOptions.Create;
  PageControl1.ActivePageIndex := 0;
end;

destructor TLamwProjectOptions.Destroy;
var
  i: Integer;
begin
  with cbLaunchIconSize.Items do
    for i := 0 to Count - 1 do
      TObject(Objects[i]).Free;
  FManifest.Free;
  inherited Destroy;
end;

procedure TLamwProjectOptions.cbLaunchIconSizeSelect(Sender: TObject);
begin
  ShowLauncherIcon;
end;

procedure TLamwProjectOptions.SpeedButton1Click(Sender: TObject);

  function CreateAllIcons(p: TPortableNetworkGraphic; fname: string): Boolean;
  var
    i: Integer;
    p1: TPortableNetworkGraphic;
  begin
    Result := MessageDlg(
      Format('Do you want to prepare all other icons by resizing "%s"?',
        [ExtractFileName(fname)]),
      mtConfirmation, mbYesNo, 0) = mrYes;
    if Result then
      with cbLaunchIconSize.Items do
      begin
        for i := 0 to Count - 1 do
        begin
          p1 := TPortableNetworkGraphic.Create;
          p1.Assign(p);
          if p1.Width <> Drawable[i].Size then
            ResizePNG(p1, Drawable[i].Size);
          Objects[i] := p1;
        end;
        p.Free;
      end;
  end;

var
  p: TPortableNetworkGraphic;
begin
  with TOpenPictureDialog.Create(nil) do
  try
    Title := Format('%s (%s)', [GroupBox1.Caption, cbLaunchIconSize.Text]);
    Filter := 'PNG|*.png';
    if Execute then
    begin
      p := TPortableNetworkGraphic.Create;
      p.LoadFromFile(FileName);
      with Drawable[cbLaunchIconSize.ItemIndex] do
        if (p.Width <> Size) or (p.Height <> Size) then
          case MessageDlg(
            Format('The size of "%s" is %dx%d but should be %dx%d. Do you want to resize?',
              [ExtractFileName(FileName), p.Width, p.Height, Size, Size]),
            mtConfirmation, mbYesNoCancel, 0) of
          mrYes:
            begin
              if (p.Width = p.Height) and (p.Height > 90) then
                if CreateAllIcons(p, FileName) then Exit;
              ResizePNG(p, Size);
            end
          else
            p.Free;
            Exit;
          end
        else
          if (Size > 90) then
            if CreateAllIcons(p, FileName) then Exit;
      with cbLaunchIconSize do
        Items.Objects[ItemIndex] := p;
    end;
  finally
    Free;
    ShowLauncherIcon;
  end;
end;

procedure TLamwProjectOptions.ErrorMessage(const msg: string);
begin
  lblErrorMessage.Caption := msg;
  ErrorPanel.Visible := True;
  ErrorPanel.Enabled := True;
end;

procedure TLamwProjectOptions.FillPermissionGrid(Permissions: TStringList;
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

class function TLamwProjectOptions.SupportedOptionsClass: TAbstractIDEOptionsClass;
begin
  Result := nil;
end;

function TLamwProjectOptions.GetTitle: string;
begin
  Result := '[Lamw] Android Project Options';
end;

procedure TLamwProjectOptions.Setup(ADialog: TAbstractOptionsEditorDialog);
begin
  // localization
end;

procedure TLamwProjectOptions.ReadSettings(AOptions: TAbstractIDEOptions);
var
  proj: TLazProject;
  fn: string;
begin
  // reading manifest
  SetControlsEnabled(tsManifest, False);
  proj := LazarusIDE.ActiveProject;
  if (proj = nil) or (proj.IsVirtual) then Exit;
  fn := proj.MainFile.Filename;
  fn := Copy(fn, 1, Pos(PathDelim + 'jni' + PathDelim, fn));
  fn := fn + 'AndroidManifest.xml';
  if not FileExists(fn) then
  begin
    ErrorMessage('"' + fn + '" not found!');
    tsAppl.Enabled := False;
    Exit;
  end;
  try
    FIconsPath := ExtractFilePath(fn) + 'res' + PathDelim + 'drawable-';
    ShowLauncherIcon;
    with FManifest do
    begin
      Load(fn);
      FillPermissionGrid(Permissions, PermNames);
      seMinSdkVersion.Value := MinSDKVersion;
      seTargetSdkVersion.Value := TargetSDKVersion;
      seVersionCode.Value := VersionCode;
      edVersionName.Text := VersionName;
      edLabel.Text := AppLabel;
    end;
  except
    on e: Exception do
    begin
      ErrorMessage(e.Message);
      Exit;
    end
  end;
  SetControlsEnabled(tsManifest, True);
end;

procedure TLamwProjectOptions.WriteSettings(AOptions: TAbstractIDEOptions);
var
  i: Integer;
begin
  with FManifest do
  begin
    for i := PermissonGrid.RowCount - 1 downto 1 do
      if PermissonGrid.Cells[1, i] <> '1' then
        Permissions.Delete(i - 1);
    MinSDKVersion := seMinSdkVersion.Value;
    TargetSDKVersion := seTargetSdkVersion.Value;
    VersionCode := seVersionCode.Value;
    VersionName := edVersionName.Text;
    AppLabel := edLabel.Text;
    Save;
  end;
  with cbLaunchIconSize.Items do
    for i := 0 to Count - 1 do
      if Assigned(Objects[i]) then
        TPortableNetworkGraphic(Objects[i]).SaveToFile(FIconsPath
          + Drawable[i].Suffix + PathDelim + FManifest.IconFileName + '.png');
end;

initialization
  RegisterIDEOptionsEditor(GroupProject, TLamwProjectOptions, 1000);

end.

