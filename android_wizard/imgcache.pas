unit ImgCache;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, AvgLvlTree, FPimage;

type

  { TImageCacheItem }

  TImageCacheItem = class
  private
    FFileName: string;
    FImg: TFPCustomImage;
    FImgFileSize: QWord;
    FImgFileTime: LongInt;
    function GetImage: TFPCustomImage;
    function CheckAttribs: Boolean;
    procedure LoadImage;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    property Img: TFPCustomImage read GetImage;
  end;

  TImageCache = class
  private
    FItems: TAvgLvlTree; // list of TImageCacheItem
  public
    constructor Create;
    destructor Destroy; override;
    function GetImage(const FileName: string): TFPCustomImage;
  end;

implementation

function CmpImgCacheItems(p1, p2: Pointer): Integer;
begin
  Result := CompareText(TImageCacheItem(p1).FFileName, TImageCacheItem(p2).FFileName)
end;

function FindImgCacheItem(p1, p2: Pointer): Integer;
begin
  Result := CompareText(PString(p1)^, TImageCacheItem(p2).FFileName)
end;

{ TImageCache }

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
var
  n: TAvgLvlTreeNode;
  ci: TImageCacheItem;
begin
  n := FItems.FindKey(@FileName, @FindImgCacheItem);
  if Assigned(n) then
    ci := TImageCacheItem(n.Data)
  else
    ci := TImageCacheItem.Create(FileName);
  Result := ci.Img
end;

{ TImageCacheItem }

function TImageCacheItem.GetImage: TFPCustomImage;
begin
  if not FileExists(FFileName) and Assigned(Fimg) then
    FreeAndNil(FImg)
  else
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

procedure TImageCacheItem.LoadImage;
var
  sr: TRawByteSearchRec;
begin
  if Assigned(FImg) then FreeAndNil(FImg);
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
  inherited Destroy;
end;

end.

