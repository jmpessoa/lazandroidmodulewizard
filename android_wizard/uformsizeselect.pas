unit uFormSizeSelect;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, zipper, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Spin, Grids, ButtonPanel;

type

  { TfrmFormSizeSelect }

  TfrmFormSizeSelect = class(TForm)
    ButtonPanel1: TButtonPanel;
    DrawGrid1: TDrawGrid;
    Label1: TLabel;
    Label2: TLabel;
    seWidth: TSpinEdit;
    seHeight: TSpinEdit;
    procedure DrawGrid1ColRowExchanged(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure DrawGrid1CompareCells(Sender: TObject;
      ACol, ARow, BCol, BRow: Integer; var Result: integer);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure DrawGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
    FTable: TFPList; // list of TDeviceSize
    procedure DoLoadFromDevices(XmlStream: TStream);
    function GetSdkPath: string;
    procedure TryLoadFromDevices;
    procedure ZipCreateStream(Sender: TObject; var AStream: TStream;
      AItem: TFullZipFileEntry);
    procedure ZipDoneStream(Sender: TObject; var AStream: TStream;
      AItem: TFullZipFileEntry);
  public
    { public declarations }
    procedure SetInitSize(AWidth, AHeight: Integer);
  end;

var
  frmFormSizeSelect: TfrmFormSizeSelect;

implementation

uses IniFiles, FormPathMissing, LazIDEIntf, laz2_XMLRead, Laz2_DOM, LazUTF8;

{$R *.lfm}

type

  { TDeviceSize }

  TDeviceSize = class
  public
    Name: string;
    Width, Height: Integer;
    constructor Create(AName: string; AWidth, AHeight: Integer);
  end;

{ TDeviceSize }

constructor TDeviceSize.Create(AName: string; AWidth, AHeight: Integer);
begin
  Name := AName;
  Width := AWidth;
  Height := AHeight;
end;

{ TfrmFormSizeSelect }

procedure TfrmFormSizeSelect.FormCreate(Sender: TObject);
begin
  FTable := TFPList.Create;
  TryLoadFromDevices;
  if FTable.Count = 0 then
  begin
    FTable.Add(TDeviceSize.Create('Default1', 240, 400));
    FTable.Add(TDeviceSize.Create('Default2', 300, 600));
  end;
  DrawGrid1.RowCount := 1 + FTable.Count;
end;

procedure TfrmFormSizeSelect.DrawGrid1SelectCell(Sender: TObject;
  aCol, aRow: Integer; var CanSelect: Boolean);
begin
  if aRow > 0 then
    with TDeviceSize(FTable[aRow - 1]) do
    begin
      seWidth.Value := Width;
      seHeight.Value := Height;
    end;
end;

procedure TfrmFormSizeSelect.DrawGrid1DrawCell(Sender: TObject;
  aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
var
  s: string;
begin
  if aRow = 0  then Exit;
  with TDeviceSize(FTable[aRow - 1]) do
    case aCol of
    0: s := Name;
    1: s := IntToStr(Width);
    2: s := IntToStr(Height);
    end;
  with DrawGrid1.Canvas do
    TextOut(aRect.Left + 2, aRect.Top + 2, s);
end;

procedure TfrmFormSizeSelect.DrawGrid1DblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfrmFormSizeSelect.DrawGrid1ColRowExchanged(Sender: TObject;
  IsColumn: Boolean; sIndex, tIndex: Integer);
begin
  if not IsColumn then
    FTable.Exchange(sIndex - 1, tIndex - 1);
end;

procedure TfrmFormSizeSelect.DrawGrid1CompareCells(Sender: TObject;
  ACol, ARow, BCol, BRow: Integer; var Result: integer);
begin
  case ACol of
  0: Result := UTF8CompareText(TDeviceSize(FTable[ARow - 1]).Name,
                               TDeviceSize(FTable[BRow - 1]).Name);
  1: Result := TDeviceSize(FTable[ARow - 1]).Width
             - TDeviceSize(FTable[BRow - 1]).Width;
  2: Result := TDeviceSize(FTable[ARow - 1]).Height
             - TDeviceSize(FTable[BRow - 1]).Height;
  end;
  if DrawGrid1.SortOrder = soDescending then
    Result := -Result;
end;

procedure TfrmFormSizeSelect.FormDestroy(Sender: TObject);
var i: Integer;
begin
  for i := 0 to FTable.Count - 1 do
    TObject(FTable[i]).Free;
  FTable.Free;
end;

procedure TfrmFormSizeSelect.ZipDoneStream(Sender: TObject;
  var AStream: TStream; AItem: TFullZipFileEntry);
begin
  DoLoadFromDevices(AStream);
end;

procedure TfrmFormSizeSelect.ZipCreateStream(Sender: TObject;
  var AStream: TStream; AItem: TFullZipFileEntry);
begin
  AStream := TMemoryStream.Create;
  AItem.Stream := AStream;
end;

procedure TfrmFormSizeSelect.TryLoadFromDevices;
var
  SDKPath, f: string;
  fs: TStringList;
  ms: TMemoryStream;
begin
  SDKPath := GetSdkPath;
  // "sdk\tools\lib\sdklib.jar" -> "\com\android\sdklib\devices\devices.xml"
  f := IncludeTrailingPathDelimiter(SDKPath) + 'tools' + PathDelim + 'lib' + PathDelim
       + 'sdklib.jar';
  if FileExists(f) then
  begin
    with TUnZipper.Create do
    try
      OnCreateStream := @ZipCreateStream;
      OnDoneStream := @ZipDoneStream;
      FileName := f;
      Examine;
      fs := TStringList.Create;
      try
        fs.Add('com/android/sdklib/devices/devices.xml');
        UnZipFiles(fs); // -> ZipDoneStream
      finally
        fs.Free;
      end;
    finally
      Free;
    end;
  end;

  f := IncludeTrailingPathDelimiter(SDKPath) + 'tools' + PathDelim + 'lib' + PathDelim
       + 'devices.xml';
  if FileExists(f) then
  begin
    ms := TMemoryStream.Create;
    ms.LoadFromFile(f);
    DoLoadFromDevices(ms);
  end;
end;

function TfrmFormSizeSelect.GetSdkPath: string;
begin
  with TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath)
    + 'JNIAndroidProject.ini') do
  try
    Result := ReadString('NewProject', 'PathToAndroidSDK', '');
  finally
    Free
  end;
  if Result = '' then
    with TFormPathMissing.Create(Self) do
    try
      LabelPathTo.Caption := 'Path to Android SDK: [ex. C:\adt32\sdk]';
      if ShowModal = mrOk then
      begin
        Result := PathMissing;
        with TIniFile.Create(IncludeTrailingPathDelimiter(LazarusIDE.GetPrimaryConfigPath)
          + 'JNIAndroidProject.ini') do
        try
          WriteString('NewProject', 'PathToAndroidSDK', Result);
        finally
          Free
        end;
      end;
    finally
      Free;
    end;
end;

procedure TfrmFormSizeSelect.DoLoadFromDevices(XmlStream: TStream);
var
  xml: TXMLDocument;
  DeviceNode, NameNode, WNode, HNode, n: TDOMNode;
begin
  XmlStream.Position := 0;
  ReadXMLFile(xml, XmlStream);
  try
    DeviceNode := xml.DocumentElement.FindNode('d:device');
    while Assigned(DeviceNode) do
    begin
      NameNode := DeviceNode.FindNode('d:name');
      n := DeviceNode.FindNode('d:hardware');
      if n <> nil then
        n := n.FindNode('d:screen');
      if n <> nil then
        n := n.FindNode('d:dimensions');
      if n <> nil then
      begin
        WNode := n.FindNode('d:x-dimension');
        HNode := n.FindNode('d:y-dimension');
      end;
      if Assigned(NameNode) and Assigned(WNode) and Assigned(HNode) then
        FTable.Add(TDeviceSize.Create(NameNode.TextContent,
                                      StrToIntDef(WNode.TextContent, 0),
                                      StrToIntDef(HNode.TextContent, 0)));
      DeviceNode := DeviceNode.NextSibling;
    end;
  finally
    XmlStream.Free;
    xml.Free;
  end;
end;

procedure TfrmFormSizeSelect.SetInitSize(AWidth, AHeight: Integer);
var i: Integer;
begin
  for i := 0 to FTable.Count - 1 do
    with TDeviceSize(FTable[i]) do
      if (Width = AWidth) and (Height = AHeight) then
      begin
        DrawGrid1.Row := i + 1;
        Exit;
      end;
  seWidth.Value := AWidth;
  seHeight.Value := AHeight;
end;

end.

