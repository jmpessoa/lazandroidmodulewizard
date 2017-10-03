{Hint: save all files to location: C:\lamw\projects\\ColorPicker\jni }

{
 Subj:
 ColorPicker example for LAMW:Android

 Author:
 Ibragimov M. aka maxx
 Russia Togliatty 03/10/17
}

unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, drawingview,
  FPimage, FPReadPNG, Graphics;

type

  { TAndroidModule_ColorPick }

  TAndroidModule_ColorPick = class(jForm)
    jBitmap_ColorPick: jBitmap;
    jDrawingView_ColorPick: jDrawingView;
    jPanel_Current_ColorPick: jPanel;
    jTextView_ColorPick: jTextView;
    procedure AndroidModule_ColorPickJNIPrompt(Sender: TObject);
    procedure jDrawingView_ColorPickDraw(Sender: TObject; countXY: integer;
      X: array of single; Y: array of single; flingGesture: TFlingGesture;
      pinchZoomScaleState: TPinchZoomScaleState; zoomScale: single);
    procedure jDrawingView_ColorPickTouchDown(Sender: TObject;
      countXY: integer; X: array of single; Y: array of single;
      flingGesture: TFlingGesture; pinchZoomScaleState: TPinchZoomScaleState;
      zoomScale: single);
  private
    {private declarations}
    function ARGBtoCustomColor(conv_clr: TColorRGBA): DWORD;
  public
    {public declarations}
  end;

var
  AndroidModule_ColorPick: TAndroidModule_ColorPick;
  Img: TFPCustomImage;
  Reader: TFPCustomImageReader;
  init_images: boolean;

const
  _color_pick_fn: string = 'color_pick2017.png';


implementation

{$R *.lfm}


{ TAndroidModule_ColorPick }

function TAndroidModule_ColorPick.ARGBtoCustomColor(conv_clr: TColorRGBA): DWORD;
begin
  Result := (conv_clr.A shl 24) + (conv_clr.R shl 16) + (conv_clr.G shl 8) + conv_clr.B;
end;

procedure TAndroidModule_ColorPick.AndroidModule_ColorPickJNIPrompt(Sender: TObject);
var
  my_color: TColorRGBA;
begin
  Self.SetScreenOrientationStyle(ssPortrait); //Portrait orientation only
  Self.SetTitleActionBar('Color Picker for LAMW:Android');

  //jPanel_Current_ColorPick.CustomColor:=$FFFF0000; //ARGB scheme - RED not transparent
  //jPanel_Current_ColorPick.CustomColor:=$FF00FF00; //ARGB scheme - GREEN not transparent
  //jPanel_Current_ColorPick.CustomColor:=$FF0000FF; //ARGB scheme - Blue not transparent

  my_color.A := $FF; //Not transparent
  //Custom color Yellow (as example)
  //my_color.R := $FF;
  //my_color.G := $FF;
  //my_color.B := $00;
  //Custom color dark Grey (as example)
  my_color.R := $11;
  my_color.G := $11;
  my_color.B := $11;

  jPanel_Current_ColorPick.CustomColor := ARGBtoCustomColor(my_color);

  jPanel_Current_ColorPick.BackgroundColor := colbrCustom;

  jBitmap_ColorPick.LoadFromAssets('color_pick.png');
  //ShowMessage(Self.GetEnvironmentDirectoryPath(dirInternalAppStorage));
  //ShowMessage(Self.GetEnvironmentDirectoryPath(dirDownloads));
end;

procedure TAndroidModule_ColorPick.jDrawingView_ColorPickDraw(Sender: TObject;
  countXY: integer; X: array of single; Y: array of single;
  flingGesture: TFlingGesture; pinchZoomScaleState: TPinchZoomScaleState;
  zoomScale: single);
begin
  jDrawingView_ColorPick.DrawBitmap(jBitmap_ColorPick.GetImage(),
    jDrawingView_ColorPick.Width, jDrawingView_ColorPick.Height);

  if (init_images = False) then
  begin
    init_images := True;
    if (Self.FileExists(Self.GetEnvironmentDirectoryPath(dirInternalAppStorage) +
      '/' + _color_pick_fn)) then
    begin
      //ShowMessage('Delete old resource: ' + _color_pick_fn);
      Self.DeleteFile(Self.GetEnvironmentDirectoryPath(dirInternalAppStorage),
        _color_pick_fn);
    end;
    jDrawingView_ColorPick.SaveToFile(Self.GetEnvironmentDirectoryPath(
      dirInternalAppStorage), _color_pick_fn);
    Img := TFPMemoryImage.Create(jDrawingView_ColorPick.Width,
      jDrawingView_ColorPick.Height);
    Reader := TFPReaderPNG.Create;
    Img.LoadFromFile(Self.GetEnvironmentDirectoryPath(dirDownloads) +
      '/' + _color_pick_fn, Reader);
  end;
end;

procedure TAndroidModule_ColorPick.jDrawingView_ColorPickTouchDown(Sender: TObject;
  countXY: integer; X: array of single; Y: array of single;
  flingGesture: TFlingGesture; pinchZoomScaleState: TPinchZoomScaleState;
  zoomScale: single);
var
  P: TPoint;
  my_tfpcolor_color: TFPColor;
  my_tcolor_color: TColor;
  my_RGBA_color: TColorRGBA;
begin
  P := Point(Round(X[0]), Round(Y[0]));
  if (init_images) then
  begin
    my_tfpcolor_color := Img.colors[P.X, P.Y];//get touched pixel in TFPCOLOR
    my_tcolor_color := FPColorToTColor(my_tfpcolor_color);
    // convert color to  TColor (regular FPC color) - to show via
    // convet TColor to  TColorRGBA (used on LAMW:Android)
    my_RGBA_color.A := $FF; // not transparent
    my_RGBA_color.R := RED(my_tcolor_color);
    my_RGBA_color.G := GREEN(my_tcolor_color);
    my_RGBA_color.B := BLUE(my_tcolor_color);

    //Redraw jPanel_Current_ColorPick in touched color
    jPanel_Current_ColorPick.CustomColor := ARGBtoCustomColor(my_RGBA_color);
    jPanel_Current_ColorPick.BackgroundColor := colbrCustom;

    //Debug out touched color like #DF3456
    //ShowMessage('#' + IntToHex(Red(my_tcolor_color), 2) +
    //  IntToHex(Green(my_tcolor_color), 2) + IntToHex(Blue(my_tcolor_color), 2));
    jTextView_ColorPick.Text := '#' + IntToHex(Red(my_tcolor_color), 2) +
      IntToHex(Green(my_tcolor_color), 2) + IntToHex(Blue(my_tcolor_color), 2);
  end;
end;


end.
