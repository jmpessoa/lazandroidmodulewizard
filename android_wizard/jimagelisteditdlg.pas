unit jImageListEditDlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ButtonPanel, Grids, ActnList, FPimage, ImgCache;

type

  { TjImagesEditorDlg }

  TjImagesEditorDlg = class(TForm)
    acMoveUp: TAction;
    acMoveDown: TAction;
    acAdd: TAction;
    acRemove: TAction;
    ActionList1: TActionList;
    ButtonAdd: TButton;
    ButtonRemove: TButton;
    ButtonUp: TButton;
    ButtonDown: TButton;
    ButtonPanel1: TButtonPanel;
    Image1: TImage;
    ImagesGrid: TDrawGrid;
    ScrollBox1: TScrollBox;
    Splitter1: TSplitter;
    procedure acAddExecute(Sender: TObject);
    procedure acMoveDownExecute(Sender: TObject);
    procedure acMoveDownUpdate(Sender: TObject);
    procedure acMoveUpExecute(Sender: TObject);
    procedure acMoveUpUpdate(Sender: TObject);
    procedure acRemoveExecute(Sender: TObject);
    procedure acRemoveUpdate(Sender: TObject);
    procedure ImagesGridDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure ImagesGridSelection(Sender: TObject; {%H-}aCol, aRow: Integer);
  private
    FImageList: TStrings;
    FImgCache: TImageCache;
    FImages: TFPList; // list of TImageListItem
    FAssetsDir: string;
    procedure Clear;
    function GetImageList: TStrings;
    procedure MoveToRightPlace(what: Integer);
    procedure ScanForImages;
    function ImageExists(const fname: string): Boolean;
    procedure PrepareGrid;
    procedure ShowImage;
    procedure ShowImage(Index: Integer);
  public
    constructor Create(AOwner: TComponent; AImages: TStrings;
      const AAssetsDir: string; AImgCache: TImageCache); reintroduce;
    destructor Destroy; override;
    procedure Init(AImages: TStrings; const AAssetsDir: string;
      AImgCache: TImageCache);
    property ImageList: TStrings read GetImageList;
  end;

implementation

uses FileUtil, ExtDlgs;

{$R *.lfm}

type

  { TImageListItem }

  TImageListItem = class
  private
    FFullFileName: string;
    FFileName: string;     // file name only
    FInUse: Boolean;
  public
    constructor Create(const FullFileName: string);
    function Exists: Boolean;
    property FileName: string read FFileName;
    property FullFileName: string read FFullFileName;
    property InUse: Boolean read FInUse;
  end;

{ TImageListItem }

constructor TImageListItem.Create(const FullFileName: string);
begin
  FFileName := ExtractFileName(FullFileName);
  FFullFileName := FullFileName;
end;

function TImageListItem.Exists: Boolean;
begin
  Result := FileExists(FFullFileName);
end;

{ TjImagesEditorDlg }

procedure TjImagesEditorDlg.ImagesGridDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);

  function InsertRect(w, h: Integer; Into: TRect): TRect;
  var
    w1, h1: Integer;
    x: Double;
  begin
    w1 := Into.Right - Into.Left;
    h1 := Into.Bottom - Into.Top;
    if (w <= w1) and (h <= h1) then
    begin
      w1 := (Into.Left + Into.Right - w) div 2;
      Result.Left := w1;
      Result.Right := w1 + w;
      h1 := (Into.Top + Into.Bottom - h) div 2;
      Result.Top := h1;
      Result.Bottom := h1 + h;
    end else begin
      x := w1 / w;
      if h1 / h < x then x := h1 / h;
      Result := InsertRect(Trunc(w * x), Trunc(h * x), Into);
    end;
  end;

var
  li: TImageListItem;
  bmp: TBitmap;
  s: string;
begin
  if aRow >= FImages.Count then Exit;
  with ImagesGrid.Canvas do
  begin
    if gdRowHighlight in aState then
    begin
      Brush.Color := clHighlight;
      Font.Color := clHighlightText;
    end;
    FillRect(aRect)
  end;
  li := TImageListItem(FImages[aRow]);
  case aCol of
  0:
    begin
      bmp := FImgCache.GetImageAsBMP(li.FullFileName);
      if bmp <> nil then
        ImagesGrid.Canvas.StretchDraw(InsertRect(bmp.Width, bmp.Height, aRect), bmp);
    end;
  1:
    if li.InUse then
      with ImagesGrid.Canvas do
      begin
        s := '[' + IntToStr(aRow) + ']';
        Font.StrikeThrough := False;
        TextOut(aRect.Right - 2 - TextWidth(s),
          (aRect.Top + aRect.Bottom - TextHeight(s)) div 2, s);
      end;
  2:
    with ImagesGrid.Canvas do
    begin
      if not li.InUse then Font.Color := clGrayText;
      Font.StrikeThrough := not li.Exists;
      TextOut(aRect.Left + 2, (aRect.Top + aRect.Bottom - TextHeight(' ')) div 2,
        li.FileName);
    end;
  end;
  if not li.InUse then
    if (aRow = 0) or (aRow > 0) and TImageListItem(FImages[aRow - 1]).InUse then
      with ImagesGrid.Canvas do
      begin
        Pen.Color := clBlack;
        Pen.Width := 2;
        MoveTo(aRect.TopLeft);
        LineTo(aRect.Right, aRect.Top);
      end;
end;

procedure TjImagesEditorDlg.acMoveUpUpdate(Sender: TObject);
var
  i: Integer;
begin
  i := ImagesGrid.Row;
  TAction(Sender).Enabled := (FImages.Count > 0)
    and (i > 0)
    and (i < FImages.Count)
    and TImageListItem(FImages[i]).InUse;
end;

procedure TjImagesEditorDlg.acRemoveExecute(Sender: TObject);
var
  i: Integer;
  li: TImageListItem;
begin
  i := ImagesGrid.Row;
  if (i < 0) or (i >= FImages.Count) then Exit;
  li := TImageListItem(FImages[i]);
  if not li.Exists then
  begin
    FImages.Delete(i);
    li.Free;
    PrepareGrid;
    ShowImage;
  end else
  if li.InUse then
  begin
    li.FInUse := False;
    MoveToRightPlace(i);
  end else
  if MessageDlg(Format('Delete file "%s"?', [li.FileName]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FImages.Delete(i);
    DeleteFile(li.FullFileName);
    li.Free;
    PrepareGrid;
    ShowImage;
  end;
  ImagesGrid.Invalidate;
end;

procedure TjImagesEditorDlg.acRemoveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FImages.Count > 0;
end;

procedure TjImagesEditorDlg.acMoveUpExecute(Sender: TObject);
var
  i: Integer;
begin
  i := ImagesGrid.Row;
  FImages.Exchange(i, i - 1);
  ImagesGrid.Row := i - 1;
  ImagesGrid.Invalidate;
end;

procedure TjImagesEditorDlg.acMoveDownUpdate(Sender: TObject);
var
  i: Integer;
begin
  i := ImagesGrid.Row;
  TAction(Sender).Enabled := (FImages.Count > 0)
    and (i >= 0)
    and (i < FImages.Count - 1)
    and TImageListItem(FImages[i]).InUse
    and TImageListItem(FImages[i + 1]).InUse;
end;

procedure TjImagesEditorDlg.acMoveDownExecute(Sender: TObject);
var
  i: Integer;
begin
  i := ImagesGrid.Row;
  FImages.Exchange(i, i + 1);
  ImagesGrid.Row := i + 1;
  ImagesGrid.Invalidate;
end;

procedure TjImagesEditorDlg.MoveToRightPlace(what: Integer);
var
  li: TImageListItem;
  j, i: Integer;
  f: Boolean;
  s1: string;
begin
  li := TImageListItem(FImages[what]);
  FImages.Delete(what);
  j := FImages.Count;
  while (j > 0) do
  begin
    f := (TImageListItem(FImages[j - 1]).InUse < li.InUse);
    if not f and not TImageListItem(FImages[j - 1]).InUse then
    begin
      s1 := TImageListItem(FImages[j - 1]).FileName;
      i := CompareText(s1, li.FileName);
      f := i >= 0;
    end;
    if not f then Break
    else Dec(j)
  end;
  FImages.Insert(j, li);
  ImagesGrid.Row := j;
  ImagesGrid.Invalidate;
  ShowImage(j);
end;

procedure TjImagesEditorDlg.acAddExecute(Sender: TObject);
var
  i: Integer;
  li: TImageListItem;
begin
  i := ImagesGrid.Row;
  if (i >= 0) and (i < FImages.Count)
  and not TImageListItem(FImages[i]).InUse then
  begin
    TImageListItem(FImages[i]).FInUse := True;
    MoveToRightPlace(i);
  end else
    with TOpenPictureDialog.Create(nil) do
    try
      Filter := 'Images (*.jpg; *.png)|*.jpg;*.png';
      if Execute then
      begin
        if ExtractFilePath(FileName) = FAssetsDir then
        begin
          for i := 0 to FImages.Count - 1 do
            with TImageListItem(FImages[i]) do
              if FullFileName = FileName then
              begin
                ImagesGrid.Row := i;
                FInUse := True;
                MoveToRightPlace(i);
                Break;
              end;
          Exit;
        end;
        if ImageExists(ExtractFileName(FileName)) then
        begin
          MessageDlg(Format('File "%s" already exists in %s',
            [ExtractFileName(FileName), FAssetsDir]), mtError, [mbOK], 0);
          Exit;
        end;
        if not CopyFile(FileName, FAssetsDir + ExtractFileName(FileName)) then
        begin
          MessageDlg(Format('Cannot copy file "%s" to %s',
            [FileName, FAssetsDir]), mtError, [mbOK], 0);
          Exit;
        end;
        li := TImageListItem.Create(FAssetsDir + ExtractFileName(FileName));
        li.FInUse := True;
        i := FImages.Add(li);
        PrepareGrid;
        MoveToRightPlace(i);
      end;
    finally
      Free
    end;
end;

procedure TjImagesEditorDlg.ImagesGridSelection(Sender: TObject; aCol,
  aRow: Integer);
begin
  ShowImage(aRow);
end;

procedure TjImagesEditorDlg.Clear;
var
  i: Integer;
begin
  for i := 0 to FImages.Count - 1 do
    TObject(FImages[i]).Free;
  FImages.Clear;
end;

function TjImagesEditorDlg.GetImageList: TStrings;
var
  i: Integer;
begin
  FImageList.Clear;
  for i := 0 to FImages.Count - 1 do
  begin
    with TImageListItem(FImages[i]) do
      if InUse then
        FImageList.Add(FileName);
  end;
  Result := FImageList;
end;

procedure TjImagesEditorDlg.ScanForImages;
var
  found: TStringList;
  li: TImageListItem;
  i: Integer;
begin
  found := FindAllFiles(FAssetsDir, '*.png;*.jpg', False);
  try
    found.Sort;
    for i := 0 to found.Count - 1 do
      if not ImageExists(ExtractFileName(found[i])) then
      begin
        li := TImageListItem.Create(found[i]);
        FImages.Add(li);
      end;
  finally
    found.Free;
  end;
end;

function TjImagesEditorDlg.ImageExists(const fname: string): Boolean;
var
  i: Integer;
begin
  for i := 0 to FImages.Count - 1 do
    if TImageListItem(FImages[i]).FileName = fname then
      Exit(True);
  Result := False;
end;

procedure TjImagesEditorDlg.PrepareGrid;
begin
  ImagesGrid.RowCount := FImages.Count;
  ImagesGrid.Columns[1].Width :=
    ImagesGrid.Canvas.TextWidth(' [' + IntToStr(FImages.Count - 1) + ']') + 2;
end;

procedure TjImagesEditorDlg.ShowImage;
begin
  ShowImage(ImagesGrid.Row);
end;

procedure TjImagesEditorDlg.ShowImage(Index: Integer);
begin
  if Index < FImages.Count then
    Image1.Picture.Bitmap :=
      FImgCache.GetImageAsBMP(TImageListItem(FImages[Index]).FullFileName)
  else
    Image1.Picture.Clear;
end;

constructor TjImagesEditorDlg.Create(AOwner: TComponent; AImages: TStrings;
  const AAssetsDir: string; AImgCache: TImageCache);
begin
  inherited Create(AOwner);
  FImageList := TStringList.Create;
  FImages := TFPList.Create;
  Init(AImages, AAssetsDir, AImgCache);
  //ImagesGrid.DoubleBuffered := True;
end;

destructor TjImagesEditorDlg.Destroy;
begin
  Clear;
  FImages.Free;
  FImageList.Free;
  inherited Destroy;
end;

procedure TjImagesEditorDlg.Init(AImages: TStrings; const AAssetsDir: string;
  AImgCache: TImageCache);
var
  li: TImageListItem;
  i: Integer;
begin
  Clear;
  FImgCache := AImgCache;
  FAssetsDir := AAssetsDir;
  for i := 0 to AImages.Count - 1 do
  begin
    li := TImageListItem.Create(FAssetsDir + AImages[i]);
    li.FInUse := True;
    FImages.Add(li);
  end;
  if not DirectoryExists(FAssetsDir) then
    CreateDir(FAssetsDir);
  ScanForImages;
  for i := 0 to FImages.Count - 1 do
    FImgCache.GetImageAsBMP(TImageListItem(FImages[i]).FullFileName);
  PrepareGrid;
  ShowImage;
end;

end.

