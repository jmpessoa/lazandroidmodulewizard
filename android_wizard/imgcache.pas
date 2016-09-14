unit ImgCache;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, AvgLvlTree, Graphics, FPimage;

type

  { TImageCacheItem }

  TImageCacheItem = class
  private
    FFileName: string;
    FImg: TFPCustomImage;
    FBmp: TBitmap;
    FImgFileSize: QWord;
    FImgFileTime: LongInt;
    function GetImage: TFPCustomImage;
    function CheckAttribs: Boolean;
    function GetBMP: TBitmap;
    procedure LoadImage;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    property Img: TFPCustomImage read GetImage;
    property BMP: TBitmap read GetBMP;
  end;

  TImageCache = class
  private
    FItems: TAvgLvlTree; // list of TImageCacheItem
    function GetImageCacheItem(const FileName: string): TImageCacheItem;
  public
    constructor Create;
    destructor Destroy; override;
    function GetImage(const FileName: string): TFPCustomImage;
    function GetImageAsBMP(const FileName: string): TBitmap;
  end;

implementation

uses FPWriteBMP;

function CmpImgCacheItems(p1, p2: Pointer): Integer;
begin
  Result := CompareText(TImageCacheItem(p1).FFileName, TImageCacheItem(p2).FFileName)
end;

function FindImgCacheItem(p1, p2: Pointer): Integer;
begin
  Result := CompareText(PString(p1)^, TImageCacheItem(p2).FFileName)
end;

{ TImageCache }

function TImageCache.GetImageCacheItem(const FileName: string): TImageCacheItem;
var
  n: TAvgLvlTreeNode;
begin
  n := FItems.FindKey(@FileName, @FindImgCacheItem);
  if Assigned(n) then
    Result := TImageCacheItem(n.Data)
  else begin
    Result := TImageCacheItem.Create(FileName);
    FItems.Add(Result);
  end;
end;

constructor TImageCache.Create;
begin
  FItems := TAvgLvlTree.Create(@CmpImgCacheItems);
end;

destructor TImageCache.Destroy;
begin
  FItems.FreeAndClear;
  FItems.Free;
  inherited Destroy;
end;

function TImageCache.GetImage(const FileName: string): TFPCustomImage;
begin
  with GetImageCacheItem(FileName) do
    Result := Img;
end;

function TImageCache.GetImageAsBMP(const FileName: string): TBitmap;
begin
  with GetImageCacheItem(FileName) do
    Result := BMP;
end;

{ TImageCacheItem }

function TImageCacheItem.GetImage: TFPCustomImage;
begin
  if not FileExists(FFileName) and Assigned(Fimg) then
  begin
    FreeAndNil(FImg);
    FreeAndNil(FBmp);
  end else
  if not CheckAttribs then LoadImage;
  Result := FImg
end;

function TImageCacheItem.CheckAttribs: Boolean;
var
  sr: TRawByteSearchRec;
begin
  FindFirst(FFileName, faAnyFile, sr);
  Result := (FImgFileSize = sr.Size) and (FImgFileTime = sr.Time);
  FindClose(sr);
end;

function TImageCacheItem.GetBMP: TBitmap;
var
  im: TFPCustomImage;
  bmpW: TFPWriterBMP;
  ms: TMemoryStream;
begin
  im := GetImage;
  if Assigned(FBmp) then Exit(FBmp);
  if Assigned(im) then
  begin
    bmpW := TFPWriterBMP.Create;
    ms := TMemoryStream.Create;
    im.SaveToStream(ms, bmpW);
    bmpW.Free;
    ms.Position := 0;
    FBmp := TBitmap.Create;
    FBmp.LoadFromStream(ms);
    ms.Free;
  end;
  Result := FBmp;
end;

procedure TImageCacheItem.LoadImage;
var
  sr: TRawByteSearchRec;
begin
  if Assigned(FImg) then
  begin
    FreeAndNil(FImg);
    FreeAndNil(FBmp);
  end;
  Fimg := TFPMemoryImage.Create(0, 0);
  try
    FImg.LoadFromFile(FFileName);
    FindFirst(FFileName, faAnyFile, sr);
    FImgFileSize := sr.Size;
    FImgFileTime := sr.Time;
    FindClose(sr);
  except
    FreeAndNil(FImg)
  end;
end;

constructor TImageCacheItem.Create(const AFileName: string);
begin
  FFileName := AFileName;
  if FileExists(FFileName) then
    LoadImage;
end;

destructor TImageCacheItem.Destroy;
begin
  FImg.Free;
  FBmp.Free;
  inherited Destroy;
end;

end.

