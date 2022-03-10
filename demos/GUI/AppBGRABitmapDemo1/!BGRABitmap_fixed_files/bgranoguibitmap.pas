// SPDX-License-Identifier: LGPL-3.0-linking-exception
unit BGRANoGUIBitmap;

{$mode objfpc}{$H+}

interface



uses
  SysUtils, BGRAClasses, BGRAGraphics, BGRABitmapTypes, BGRADefaultBitmap,
  BGRAFreeType,

  {$IF not Defined (ANDROID)} // Workaround fix for Android compilation
  EasyLazFreeType,
  LazFreeTypeFontCollection,
  {$ENDIF} // Workaround fix for Android compilation

  BGRACanvas;

type

  { TBGRANoGUIBitmap }

  TBGRANoGUIBitmap = class(TBGRADefaultBitmap)
  private
    FPseudoCanvas: TBGRACanvas;
    function GetPseudoCanvas: TBGRACanvas;
  protected
    procedure RebuildBitmap; override;
    function CreateDefaultFontRenderer: TBGRACustomFontRenderer; override;
    function LoadFromRawImage({%H-}ARawImage: TRawImage; {%H-}DefaultOpacity: byte;
      {%H-}AlwaysReplaceAlpha: boolean=False; {%H-}RaiseErrorOnInvalidPixelFormat: boolean
      =True): boolean; override;
    procedure Init; override;
    procedure FreeBitmap; override;
    procedure NotAvailable;
  public
    destructor Destroy; override;
    procedure AssignToBitmap(ADestination: TBitmap);
    class procedure AddFreeTypeFontFolder(ADirectory: string; AUTF8: boolean = false); static;
    class procedure AddFreeTypeFontFile(AFilename: string; AUTF8: boolean = false); static;
    procedure Draw(ACanvas: TCanvas; x, y: integer; {%H-}Opaque: boolean=True); override;
    procedure Draw(ACanvas: TCanvas; Rect: TRect; {%H-}Opaque: boolean=True); override;
    procedure GetImageFromCanvas({%H-}CanvasSource: TCanvas; {%H-}x, {%H-}y: integer); override; //not available
    procedure DataDrawTransparent({%H-}ACanvas: TCanvas; {%H-}Rect: TRect; {%H-}AData: Pointer;
      {%H-}ALineOrder: TRawImageLineOrder; {%H-}AWidth, {%H-}AHeight: integer); override;
    procedure DataDrawOpaque({%H-}ACanvas: TCanvas; {%H-}Rect: TRect; {%H-}AData: Pointer;
      {%H-}ALineOrder: TRawImageLineOrder; {%H-}AWidth, {%H-}AHeight: integer); override;
    procedure TakeScreenshot({%H-}ARect: TRect); override; //not available
    procedure TakeScreenshotOfPrimaryMonitor; override; //not available
    procedure LoadFromDevice({%H-}DC: HDC); override; //not available
    procedure LoadFromDevice({%H-}DC: HDC; {%H-}ARect: TRect); override; //not available
    property Canvas: TBGRACanvas read GetPseudoCanvas;
  end;



implementation




{ TBGRANoGUIBitmap }

function TBGRANoGUIBitmap.GetPseudoCanvas: TBGRACanvas;
begin
  if FPseudoCanvas = nil then
  begin
    FPseudoCanvas := TBGRACanvas.Create(self);
    FPseudoCanvas.AntialiasingMode := amOff;
  end;
  result := FPseudoCanvas;
end;

procedure TBGRANoGUIBitmap.RebuildBitmap;
begin
  //nothing
end;

function TBGRANoGUIBitmap.CreateDefaultFontRenderer: TBGRACustomFontRenderer;
begin
  {$IF not Defined (ANDROID)} // Workaround fix for Android compilation
  result := TBGRAFreeTypeFontRenderer.Create;
  {$ELSE}
  result := nil;
  {$ENDIF} // Workaround fix for Android compilation

end;

function TBGRANoGUIBitmap.LoadFromRawImage(ARawImage: TRawImage;
  DefaultOpacity: byte; AlwaysReplaceAlpha: boolean;
  RaiseErrorOnInvalidPixelFormat: boolean): boolean;
begin
  NotAvailable;
  result := false;
end;

procedure TBGRANoGUIBitmap.Init;
begin
  inherited Init;
  FontAntialias:= true;
end;

procedure TBGRANoGUIBitmap.FreeBitmap;
begin
  //nothing
end;

procedure TBGRANoGUIBitmap.NotAvailable;
begin
  raise exception.Create('Function not available without GUI');
end;

destructor TBGRANoGUIBitmap.Destroy;
begin
  FreeAndNil(FPseudoCanvas);
  inherited Destroy;
end;

procedure TBGRANoGUIBitmap.AssignToBitmap(ADestination: TBitmap);
begin
  ADestination.RawImage.Assign(self);
end;

class procedure TBGRANoGUIBitmap.AddFreeTypeFontFolder(ADirectory: string; AUTF8: boolean);
begin
  {$IF not Defined (ANDROID)} // Workaround fix for Android compilation
  if AUTF8 then ADirectory:= Utf8ToAnsi(ADirectory);
  EasyLazFreeType.FontCollection.AddFolder(ADirectory);
  {$ENDIF} // Workaround fix for Android compilation
end;

class procedure TBGRANoGUIBitmap.AddFreeTypeFontFile(AFilename: string; AUTF8: boolean);
begin
  {$IF not Defined (ANDROID)} // Workaround fix for Android compilation
  if AUTF8 then AFilename:= Utf8ToAnsi(AFilename);
  EasyLazFreeType.FontCollection.AddFile(AFilename);
  {$ENDIF} // Workaround fix for Android compilation
end;

procedure TBGRANoGUIBitmap.Draw(ACanvas: TCanvas; x, y: integer; Opaque: boolean);
begin
  ACanvas.GUICanvas.Draw(x,y,self);
end;

procedure TBGRANoGUIBitmap.Draw(ACanvas: TCanvas; Rect: TRect; Opaque: boolean);
begin
  ACanvas.GUICanvas.StretchDraw(Rect.Left,Rect.Top,Rect.Right-Rect.Left,Rect.Bottom-Rect.Top,self);
end;

procedure TBGRANoGUIBitmap.GetImageFromCanvas(CanvasSource: TCanvas; x,
  y: integer);
begin
  NotAvailable;
end;

procedure TBGRANoGUIBitmap.DataDrawTransparent(ACanvas: TCanvas; Rect: TRect;
  AData: Pointer; ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer);
begin
  NotAvailable;
end;

procedure TBGRANoGUIBitmap.DataDrawOpaque(ACanvas: TCanvas; Rect: TRect;
  AData: Pointer; ALineOrder: TRawImageLineOrder; AWidth, AHeight: integer);
begin
  NotAvailable;
end;

procedure TBGRANoGUIBitmap.TakeScreenshot(ARect: TRect);
begin
  NotAvailable;
end;

procedure TBGRANoGUIBitmap.TakeScreenshotOfPrimaryMonitor;
begin
  NotAvailable;
end;

procedure TBGRANoGUIBitmap.LoadFromDevice(DC: HDC);
begin
  NotAvailable;
end;

procedure TBGRANoGUIBitmap.LoadFromDevice(DC: HDC; ARect: TRect);
begin
  NotAvailable;
end;



end.

