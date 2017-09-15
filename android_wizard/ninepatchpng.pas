unit NinePatchPNG;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, IntfGraphics;

type

  { T9PatchPNG }

  T9PatchPNG = class(TPortableNetworkGraphic)
  private
    FIs9Patch: Boolean;
    FPadding: TRect;
    FRealWidth, FRealHeight: Integer;
    FResizeBox: TRect;
    FBGMargin: TRect;
    FOrigCanvas: TCanvas;
    FResizedPNG: TPortableNetworkGraphic;
    procedure CalcResizeBox;
  public
    constructor Create(AFileName: string); reintroduce;
    destructor Destroy; override;
    procedure Draw(DestCanvas: TCanvas; const DestRect: TRect); override;
    property Padding: TRect read FPadding;
    property BackgroundMargin: TRect read FBGMargin;
  end;

implementation

uses FPimage, FPWritePNG, FPCanvas, FPReadPNG;

type

   { TMyCanvas }

   TMyCanvas = class(TCanvas)
   private
     FImage: TFPMemoryImage;
   protected
     function GetHeight: integer; override;
     function GetWidth: integer; override;
     procedure SetColor(x, y: integer; const Value: TFPColor); override;
     function GetColor(x, y: integer): TFPColor; override;
     procedure SetHeight(AValue: integer); override;
     procedure SetWidth(AValue: integer); override;
   public
     constructor Create;
     constructor Create(png: TPortableNetworkGraphic);
     destructor Destroy; override;
     procedure AssignTo(Dest: TPersistent); override;
     property Image: TFPMemoryImage read FImage;
   end;

{ TMyCanvas }

function TMyCanvas.GetHeight: integer;
begin
  Result := FImage.Height
end;

function TMyCanvas.GetWidth: integer;
begin
  Result := FImage.Width
end;

procedure TMyCanvas.SetColor(x, y: integer; const Value: TFPColor);
begin
  FImage.Colors[x, y] := Value;
end;

function TMyCanvas.GetColor(x, y: integer): TFPColor;
begin
  Result := FImage.Colors[x, y];
end;

procedure TMyCanvas.SetHeight(AValue: integer);
begin
  FImage.SetSize(Width, AValue);
end;

procedure TMyCanvas.SetWidth(AValue: integer);
begin
  FImage.SetSize(AValue, Height);
end;

constructor TMyCanvas.Create;
begin
  inherited;
  FImage := TFPMemoryImage.Create(0,0);
end;

constructor TMyCanvas.Create(png: TPortableNetworkGraphic);
var
  ms: TMemoryStream;
  r: TFPReaderPNG;
begin
  Create;
  ms := TMemoryStream.Create;
  png.SaveToStream(ms);
  ms.Position := 0;
  r := TFPReaderPNG.Create;
  FImage.LoadFromStream(ms, r);
  r.Free;
  ms.Free;
end;

destructor TMyCanvas.Destroy;
begin
  FImage.Free;
  inherited;
end;

procedure TMyCanvas.AssignTo(Dest: TPersistent);
var
  ms: TMemoryStream;
  w: TFPWriterPNG;
begin
  if Dest is TPortableNetworkGraphic then
  begin
    ms := TMemoryStream.Create;
    w := TFPWriterPNG.Create;
    w.UseAlpha := True;
    FImage.SaveToStream(ms, w);
    w.Free;
    ms.Position := 0;
    TPortableNetworkGraphic(Dest).LoadFromStream(ms);
    ms.Free;
  end else
    inherited AssignTo(Dest);
end;

{ T9PatchPNG }

procedure T9PatchPNG.CalcResizeBox;
const
  black: TFPColor = (red:0;green:0;blue:0;alpha:alphaOpaque);
  red: TFPColor = (red:$ffff;green:0;blue:0;alpha:alphaOpaque);

  function ScanH(y: Integer; out left, right: Integer): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 1 to Width - 2 do
      if FOrigCanvas.Colors[i, y] = black then
      begin
        left := i;
        Result := True;
        Break;
      end;
    if not Result then Exit;
    for i := Width - 2 downto 1 do
      if FOrigCanvas.Colors[i, y] = black then
      begin
        right := i;
        Break;
      end;
  end;

  function ScanV(x: Integer; out top, bottom: Integer): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 1 to Height - 2 do
      if FOrigCanvas.Colors[x, i] = black then
      begin
        top := i;
        Result := True;
        Break;
      end;
    if not Result then Exit;
    for i := Height - 2 downto 1 do
      if FOrigCanvas.Colors[x, i] = black then
      begin
        bottom := i;
        Break;
      end;
  end;

  function Count(x, y, dx, dy: Integer; cl: TFPColor): Integer;
  begin
    Result := 0;
    while (x >= 0) and (x < FOrigCanvas.Width)
      and (y >= 0) and (y < FOrigCanvas.Height)
      and (FOrigCanvas.Colors[x, y] = cl) do
    begin
      Inc(Result);
      x := x + dx;
      y := y + dy;
    end;
  end;

begin
  FRealWidth := Width - 2;
  FRealHeight := Height - 2;
  FOrigCanvas := TMyCanvas.Create(Self);
  ScanH(0, FResizeBox.Left, FResizeBox.Right);
  ScanV(0, FResizeBox.Top, FResizeBox.Bottom);
  if ScanH(FOrigCanvas.Height - 1, FPadding.Left, FPadding.Right) then
  begin
    FPadding.Left := FPadding.Left - 1;
    FPadding.Right := FRealWidth - FPadding.Right;
    ScanV(FOrigCanvas.Width - 1, FPadding.Top, FPadding.Bottom);
    FPadding.Top := FPadding.Top - 1;
    FPadding.Bottom := FRealHeight - FPadding.Bottom;
  end else begin
    FPadding.Left := FResizeBox.Left - 1;
    FPadding.Top := FResizeBox.Top - 1;
    FPadding.Right := FRealWidth - FResizeBox.Right;
    FPadding.Bottom := FRealHeight - FResizeBox.Bottom;
  end;
  if FOrigCanvas.Colors[FOrigCanvas.Width - 1, 1] = red then
  begin
    FBGMargin.Top := Count(FOrigCanvas.Width - 1, 1, 0, 1, red);
    FBGMargin.Bottom := Count(FOrigCanvas.Width - 1, FOrigCanvas.Height - 2, 0, -1, red);
    FBGMargin.Left := Count(1, FOrigCanvas.Height - 1, 1, 0, red);
    FBGMargin.Right := Count(FOrigCanvas.Width - 2, FOrigCanvas.Height - 1, -1, 0, red);
  end;
end;

constructor T9PatchPNG.Create(AFileName: string);
begin
  inherited Create;
  FIs9Patch := SameText('.9.png', Copy(AFileName, Length(AFileName) - 5, 6));
  LoadFromFile(AFileName);
  if FIs9Patch then
    CalcResizeBox;
end;

destructor T9PatchPNG.Destroy;
begin
  FOrigCanvas.Free;
  FResizedPNG.Free;
  inherited Destroy;
end;

procedure T9PatchPNG.Draw(DestCanvas: TCanvas; const DestRect: TRect);

  procedure Crop(var x1, x2, dx1, dx2: Integer);
  var
    b: Boolean;
  begin
    b := True;
    while dx1 > dx2 do
    begin
      if b then begin
        Dec(dx1); Dec(x1)
      end else begin
        Inc(dx2); Inc(x2)
      end;
      b := not b;
    end;
  end;

var
  c1: TMyCanvas;

  procedure StretchDraw(r1, r2: TRect); { FOrigCanvas.r1 -> c2 -> c1.r2 }
  var
    c2: TMyCanvas;
  begin
    Dec(r1.Right);
    Dec(r1.Bottom);
    Dec(r2.Right);
    Dec(r2.Bottom);

    c2 := TMyCanvas.Create;
    with r1 do
      c2.Image.SetSize(Right - Left + 1, Bottom - Top + 1);

    TFPCustomCanvas(c2).CopyRect(0, 0, FOrigCanvas, r1);
    with r2 do
      TFPCustomCanvas(c1).StretchDraw(Left, Top, Right - Left + 1, Bottom - Top + 1, c2.Image);
    c2.Free;
  end;

var
  x0, x1, x2, x3: Integer;
  y0, y1, y2, y3: Integer;
  dx0, dx1, dx2, dx3: Integer;
  dy0, dy1, dy2, dy3: Integer;
begin
  if FIs9Patch then
  begin
    if (FResizedPNG <> nil)
    and (DestRect.Right - DestRect.Left = FResizedPNG.Width)
    and (DestRect.Bottom - DestRect.Top = FResizedPNG.Height) then
    begin
      DestCanvas.Draw(DestRect.Left, DestRect.Top, FResizedPNG);
      Exit;
    end;

    c1 := TMyCanvas.Create{%H-};
    with DestRect do
      c1.Image.SetSize(Right - Left, Bottom - Top);

    x0 := 1;                 dx0 := 0{DestRect.Left};
    x1 := FResizeBox.Left;   dx1 := {DestRect.Left} + x1 - x0;
    x2 := FResizeBox.Right;  dx3 := DestRect.Right-DestRect.Left;
    x3 := Width - 1;         dx2 := dx3 - x3 + x2;

    y0 := 1;                 dy0 := 0{DestRect.Top};
    y1 := FResizeBox.Top;    dy1 := {DestRect.Top} + y1 - y0;
    y2 := FResizeBox.Bottom; dy3 := DestRect.Bottom-DestRect.Top;
    y3 := Height - 1;        dy2 := dy3 - y3 + y2;

    Crop(x1, x2, dx1, dx2);
    Crop(y1, y2, dy1, dy2);

    StretchDraw(Rect(x0,y0, x1,y1), Rect(dx0,dy0, dx1,dy1));
    StretchDraw(Rect(x1,y0, x2,y1), Rect(dx1,dy0, dx2,dy1));
    StretchDraw(Rect(x2,y0, x3,y1), Rect(dx2,dy0, dx3,dy1));

    StretchDraw(Rect(x0,y1, x1,y2), Rect(dx0,dy1, dx1,dy2));
    StretchDraw(Rect(x1,y1, x2,y2), Rect(dx1,dy1, dx2,dy2));
    StretchDraw(Rect(x2,y1, x3,y2), Rect(dx2,dy1, dx3,dy2));

    StretchDraw(Rect(x0,y2, x1,y3), Rect(dx0,dy2, dx1,dy3));
    StretchDraw(Rect(x1,y2, x2,y3), Rect(dx1,dy2, dx2,dy3));
    StretchDraw(Rect(x2,y2, x3,y3), Rect(dx2,dy2, dx3,dy3));

    FResizedPNG.Free;
    FResizedPNG := TPortableNetworkGraphic.Create;
    c1.AssignTo(FResizedPNG);
    DestCanvas.Draw(DestRect.Left, DestRect.Top, FResizedPNG);

    c1.Free;
  end else
    inherited Draw(DestCanvas, DestRect);
end;

end.

