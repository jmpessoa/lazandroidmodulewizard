{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTFPNoGUIGraphicsBridgeDemo8\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, FPNoGUIGraphicsBridge, ViewPort, FPImage;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    FPNoGUIGraphicsBridge1: TFPNoGUIGraphicsBridge;
    jBitmap1: jBitmap;
    jButton1: jButton;
    jImageView1: jImageView;
    jImageView2: jImageView;
    jImageView3: jImageView;
    jImageView4: jImageView;
    jTextView1: jTextView;
    ViewPort1: TViewPort;
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;
  PGlobalDirectImagePixel: PJByte;

implementation

{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  w, h: integer;
  jGraphicsBuffer: jObject;
  col, row: integer;
  auxColor: TFPColor;  // need: uses --> FPImage
begin

  w:= jImageView1.GetBitmapWidth;
  h:= jImageView1.GetBitmapHeight;

  FPNoGUIGraphicsBridge1.SetSurfaceSize(w,h);
  FPNoGUIGraphicsBridge1.PathToFontFile:= '/system/fonts/Roboto-Regular.ttf'; //DroidSerif-Bold.ttf
  //FPNoGUIGraphicsBridge1.ActiveViewPort:= ViewPort1; //set in Object inspector!

  ViewPort1.SetSize(w,h);

  ViewPort1.DrawAxis:= True;
  ViewPort1.DrawGrid:= True;

  jGraphicsBuffer:= jBitmap1.GetByteBufferFromBitmap(jImageView1.GetBitmapImage());
  PGlobalDirectImagePixel:= jBitmap1.GetDirectBufferAddress(jGraphicsBuffer); // rapid!

  FPNoGUIGraphicsBridge1.Surface.SetRGBAGraphics(PGlobalDirectImagePixel);  // Android --> Pascal

  FPNoGUIGraphicsBridge1.Surface.GetGrayscaleRGBAGraphics(PGlobalDirectImagePixel); //Pascal --> Android
  //NOTE: Get***RGBAGraphics: do not modify  the internal [Surface] image ...
  jImageView2.SetImageBitmap(jBitmap1.GetBitmapFromByteBuffer(jGraphicsBuffer, w, h));  //show ..

  FPNoGUIGraphicsBridge1.Surface.SetRGBAGraphics(PGlobalDirectImagePixel);  // Android --> Pascal [grayscale]

  //FPNoGUIGraphicsBridge1.Surface.GetInvertedscaleRGBAGraphics(PGlobalDirectImagePixel); //Pascal --> Android
  //FPNoGUIGraphicsBridge1.Surface.SetRGBAGraphics(PGlobalDirectImagePixel);  // Android --> Pascal

  FPNoGUIGraphicsBridge1.Surface.BinaryscaleGrayThreshold:= colGray;
  //colLtGray; //colGray //colDkGray --> // need: uses --> FPImage

  FPNoGUIGraphicsBridge1.Surface.GetBinaryscaleRGBAGraphics(PGlobalDirectImagePixel); //Pascal --> Android
  //NOTE: Get***RGBAGraphics: do not modify the internal [Surface] image ...
  jImageView3.SetImageBitmap(jBitmap1.GetBitmapFromByteBuffer(jGraphicsBuffer, w, h)); //show

  //direct pixels access : modifie internal [Surface] image:
  for col:= 0 to w-1 do
  begin
    for row:= 0 to h-1 do
    begin
      auxColor:= FPNoGUIGraphicsBridge1.Surface[col, row];
      auxColor.red:= 255 - auxColor.red;
      auxColor.green:= 255 - auxColor.green;
      auxColor.blue:= 255 - auxColor.blue;
      //auxColor.alpha:= auxColor.alpha;
      FPNoGUIGraphicsBridge1.Surface.Pixel[col, row]:= auxColor;
    end;
  end;

  FPNoGUIGraphicsBridge1.Surface.GetRGBAGraphics(PGlobalDirectImagePixel); //Pascal --> Android
  jImageView4.SetImageBitmap(jBitmap1.GetBitmapFromByteBuffer(jGraphicsBuffer, w, h));

end;

end.
