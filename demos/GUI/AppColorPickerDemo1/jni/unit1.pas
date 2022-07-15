{hint: Pascal files location: ...\AppColorPickerDemo1\jni }

// AppColorPickerDemo1 for LAMW (Lazarus Android Module Wizard)
// Author: neuro
// Date: July 16, 2022


unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  Graphics, FPimage, FPReadPNG, Math;


type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    Bitmap1: jBitmap;
    Canvas1: jCanvas;
    ImageView1: jImageView;
    Panel1: jPanel;
    TextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure ImageView1TouchDown(Sender: TObject; Touch: TMouch);
  private
    {private declarations}
    function ARGBtoCustomColor(conv_clr: TColorRGBA): DWORD;

  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

  screen_density_rescale: double;

  touched_pixel: TPoint;

  selected_tfpcolor_color: TFPColor;
  selected_tcolor_color: TColor;
  selected_RGBA_color: TColorRGBA;
  selected_tcolor_color_string: string;

  inverted_RGBA_color: TColorRGBA;

  image_array_of_jbyte: TDynArrayOfJByte;
  size_image_array_of_jbyte: integer;
  color_picker_width, color_picker_height: integer;
  n, n4: integer;
  colorpick_image_scale: double;


implementation

{$R *.lfm}


{ TAndroidModule1 }

function TAndroidModule1.ARGBtoCustomColor(conv_clr: TColorRGBA): DWORD;
begin
  Result := (conv_clr.A shl 24) + (conv_clr.R shl 16) + (conv_clr.G shl 8) + conv_clr.B;
end;


procedure TAndroidModule1.ImageView1TouchDown(Sender: TObject; Touch: TMouch);
begin

  touched_pixel := Point(Floor(Touch.Pt.x), Floor(Touch.Pt.y));

  n := Bitmap1.Width * Floor(Touch.Pt.y * colorpick_image_scale) + Floor(Touch.Pt.x * colorpick_image_scale);
  n4 := n * 4;

  selected_RGBA_color.A := $FF; // not transparent
  selected_RGBA_color.R := byte(image_array_of_jbyte[n4 + 0]);
  selected_RGBA_color.G := byte(image_array_of_jbyte[n4 + 1]);
  selected_RGBA_color.B := byte(image_array_of_jbyte[n4 + 2]);

  selected_tcolor_color := RGBToColor(selected_RGBA_color.R, selected_RGBA_color.G, selected_RGBA_color.B);

  Panel1.CustomColor := ARGBtoCustomColor(selected_RGBA_color);
  Panel1.BackgroundColor := colbrCustom;

  TextView1.Text := '#' + IntToHex(Red(selected_tcolor_color), 2) + IntToHex(Green(selected_tcolor_color), 2) + IntToHex(Blue(selected_tcolor_color), 2);

  inverted_RGBA_color.A := $FF; // not transparent
  inverted_RGBA_color.R := byte(256 - selected_RGBA_color.R);
  inverted_RGBA_color.G := byte(256 - selected_RGBA_color.G);
  inverted_RGBA_color.B := byte(256 - inverted_RGBA_color.B);

  Canvas1.DrawBitmap(Bitmap1.GetImage(), 0, 0, color_picker_width, color_picker_height);
  Canvas1.PaintStyle := psStroke;
  Canvas1.CustomColor := ARGBtoCustomColor(inverted_RGBA_color);
  Canvas1.PaintColor := colbrCustom;
  Canvas1.PaintStrokeWidth := 3;
  Canvas1.DrawCircle(touched_pixel.X, touched_pixel.Y, 10);
  ImageView1.SetImageBitmap(Canvas1.GetBitmap());

end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  Bitmap1.LoadFromAssets('color_pick.png');

  screen_density_rescale := (Self.GetScreenDpi() / 160.0);


  image_array_of_jbyte := nil;
  Bitmap1.BitmapToArrayOfJByte(image_array_of_jbyte);
  size_image_array_of_jbyte := Length(image_array_of_jbyte);

  if (size_image_array_of_jbyte = 0) then
  begin
    ShowMessage('Error: size of file color_pick.png is 0');
    Exit;
  end;

  color_picker_width := Bitmap1.Width;
  color_picker_height := Bitmap1.Height;

  selected_tcolor_color := StringToColor('$FFFFFF');
  selected_RGBA_color.A := $FF; // not transparent
  selected_RGBA_color.R := RED(selected_tcolor_color);
  selected_RGBA_color.G := GREEN(selected_tcolor_color);
  selected_RGBA_color.B := BLUE(selected_tcolor_color);

  Panel1.CustomColor := selected_tcolor_color;
  Panel1.BackgroundColor := colbrCustom;

  TextView1.Text := '#' + IntToHex(Red(selected_tcolor_color), 2) + IntToHex(Green(selected_tcolor_color), 2) + IntToHex(Blue(selected_tcolor_color), 2);

  color_picker_width := Floor(256.0 * (screen_density_rescale / 2.0));
  color_picker_height := color_picker_width;

  colorpick_image_scale := Bitmap1.Width / color_picker_width;

  ImageView1.Width := color_picker_width;
  ImageView1.Height := color_picker_height;

  Panel1.Width := color_picker_width div 2;
  Panel1.Height := color_picker_height div 2;

  Canvas1.CreateBitmap(color_picker_width, color_picker_height, colbrBlack);
  Canvas1.DrawBitmap(Bitmap1.GetImage(), 0, 0, color_picker_width, color_picker_height);
  ImageView1.SetImageBitmap(Canvas1.GetBitmap());

end;


end.
