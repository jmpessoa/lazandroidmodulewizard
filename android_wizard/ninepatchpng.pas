unit NinePatchPNG;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, IntfGraphics, LCLType;

type

  { T9PatchPNG }

  T9PatchPNG = class(TPortableNetworkGraphic)
  private
    FIs9Patch: Boolean;
    FPadding: TRect;
    FRealWidth, FRealHeight: Integer;
    FResizeBox: TRect;
    FBGMargin: TRect;
    procedure CalcResizeBox;
  public
    constructor Create(AFileName: string); reintroduce;
    procedure Draw(DestCanvas: TCanvas; const DestRect: TRect); override;
    property Padding: TRect read FPadding;
    property BackgroundMargin: TRect read FBGMargin;
  end;

implementation

uses FPimage, FPWritePNG, LCLIntf;

{ T9PatchPNG }

procedure T9PatchPNG.CalcResizeBox;
const
  black: TFPColor = (red:0;green:0;blue:0;alpha:alphaOpaque);
  red: TFPColor = (red:$ffff;green:0;blue:0;alpha:alphaOpaque);

  function ScanH(im: TLazIntfImage; y: Integer; out left, right: Integer): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 1 to Width - 2 do
      if im.Colors[i, y] = black then
      begin
        left := i;
        Result := True;
        Break;
      end;
    if not Result then Exit;
    for i := Width - 2 downto 1 do
      if im.Colors[i, y] = black then
      begin
        right := i;
        Break;
      end;
  end;

  function ScanV(im: TLazIntfImage; x: Integer; out top, bottom: Integer): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 1 to Height - 2 do
      if im.Colors[x, i] = black then
      begin
        top := i;
        Result := True;
        Break;
      end;
    if not Result then Exit;
    for i := Height - 2 downto 1 do
      if im.Colors[x, i] = black then
      begin
        bottom := i;
        Break;
      end;
  end;

  function Count(im: TLazIntfImage; x, y, dx, dy: Integer; c: TFPColor): Integer;
  begin
    Result := 0;
    while (x >= 0) and (x < im.Width)
      and (y >= 0) and (y < im.Height)
      and (im.Colors[x, y] = c) do
    begin
      Inc(Result);
      x := x + dx;
      y := y + dy;
    end;
  end;

var
  im: TLazIntfImage;
begin
  FRealWidth := Width - 2;
  FRealHeight := Height - 2;
  im := CreateIntfImage;
  ScanH(im, 0, FResizeBox.Left, FResizeBox.Right);
  ScanV(im, 0, FResizeBox.Top, FResizeBox.Bottom);
  if ScanH(im, im.Height - 1, FPadding.Left, FPadding.Right) then
  begin
    FPadding.Left := FPadding.Left - 1;
    FPadding.Right := FRealWidth - FPadding.Right;
    ScanV(im, im.Width - 1, FPadding.Top, FPadding.Bottom);
    FPadding.Top := FPadding.Top - 1;
    FPadding.Bottom := FRealHeight - FPadding.Bottom;
  end else begin
    FPadding.Left := FResizeBox.Left - 1;
    FPadding.Top := FResizeBox.Top - 1;
    FPadding.Right := FRealWidth - FResizeBox.Right;
    FPadding.Bottom := FRealHeight - FResizeBox.Bottom;
  end;
  if im.Colors[im.Width - 1, 1] = red then
  begin
    FBGMargin.Top := Count(im, im.Width - 1, 1, 0, 1, red);
    FBGMargin.Bottom := Count(im, im.Width - 1, im.Height - 2, 0, -1, red);
    FBGMargin.Left := Count(im, 1, im.Height - 1, 1, 0, red);
    FBGMargin.Right := Count(im, im.Width - 2, im.Height - 1, -1, 0, red);
  end;
  im.Free;
end;

constructor T9PatchPNG.Create(AFileName: string);
begin
  inherited Create;
  FIs9Patch := SameText('.9.png', Copy(AFileName, Length(AFileName) - 5, 6));
  LoadFromFile(AFileName);
  if FIs9Patch then
    CalcResizeBox;
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
  x0, x1, x2, x3: Integer;
  y0, y1, y2, y3: Integer;
  dx0, dx1, dx2, dx3: Integer;
  dy0, dy1, dy2, dy3: Integer;
  SrcDC, DestDC: HDC;
begin
  if FIs9Patch then
  begin
    x0 := 1;                 dx0 := DestRect.Left;
    x1 := FResizeBox.Left;   dx1 := DestRect.Left + x1 - x0;
    x2 := FResizeBox.Right;  dx3 := DestRect.Right;
    x3 := Width - 1;         dx2 := dx3 - x3 + x2;

    y0 := 1;                 dy0 := DestRect.Top;
    y1 := FResizeBox.Top;    dy1 := DestRect.Top + y1 - y0;
    y2 := FResizeBox.Bottom; dy3 := DestRect.Bottom;
    y3 := Height - 1;        dy2 := dy3 - y3 + y2;

    Crop(x1, x2, dx1, dx2);
    Crop(y1, y2, dy1, dy2);

    SrcDC := Canvas.GetUpdatedHandle([csHandleValid]);
    DestDC := DestCanvas.GetUpdatedHandle([csHandleValid]);

    StretchMaskBlt(DestDC, dx0,dy0, dx1-dx0,dy1-dy0,  // *++
                   SrcDC,  x0,y0, x1-x0,y1-y0,        // +++
                   0,0,0,DestCanvas.CopyMode);        // +++

    StretchMaskBlt(DestDC, dx1,dy0, dx2-dx1,dy1-dy0,  // +*+
                   SrcDC,  x1,y0, x2-x1,y1-y0,        // +++
                   0,0,0,DestCanvas.CopyMode);        // +++

    StretchMaskBlt(DestDC, dx2,dy0, dx3-dx2,dy1-dy0,  // ++*
                   SrcDC,  x2,y0, x3-x2,y1-y0,        // +++
                   0,0,0,DestCanvas.CopyMode);        // +++


    StretchMaskBlt(DestDC, dx0,dy1, dx1-dx0,dy2-dy1,  // +++
                   SrcDC,  x0,y1, x1-x0,y2-y1,        // *++
                   0,0,0,DestCanvas.CopyMode);        // +++

    StretchMaskBlt(DestDC, dx1,dy1, dx2-dx1,dy2-dy1,  // +++
                   SrcDC,  x1,y1, x2-x1,y2-y1,        // +*+
                   0,0,0,DestCanvas.CopyMode);        // +++

    StretchMaskBlt(DestDC, dx2,dy1, dx3-dx2,dy2-dy1,  // +++
                   SrcDC,  x2,y1, x3-x2,y2-y1,        // ++*
                   0,0,0,DestCanvas.CopyMode);        // +++

    StretchMaskBlt(DestDC, dx0,dy2, dx1-dx0,dy3-dy2,  // +++
                   SrcDC,  x0,y2, x1-x0,y3-y2,        // +++
                   0,0,0,DestCanvas.CopyMode);        // *++

    StretchMaskBlt(DestDC, dx1,dy2, dx2-dx1,dy3-dy2,  // +++
                   SrcDC,  x1,y2, x2-x1,y3-y2,        // +++
                   0,0,0,DestCanvas.CopyMode);        // +*+

    StretchMaskBlt(DestDC, dx2,dy2, dx3-dx2,dy3-dy2,  // +++
                   SrcDC,  x2,y2, x3-x2,y3-y2,        // +++
                   0,0,0,DestCanvas.CopyMode);        // ++*
  end else
    inherited Draw(DestCanvas, DestRect);
end;

end.

