{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTFPNoGUIGraphicsBridgeDemo5\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, FPNoGUIGraphicsBridge, ViewPort;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    FPNoGUIGraphicsBridge1: TFPNoGUIGraphicsBridge;
    jBitmap1: jBitmap;
    jButton1: jButton;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jTextView1: jTextView;
    ViewPort1: TViewPort;
    ViewPort2: TViewPort;
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

uses
  GeometryUtilsBridge, fpcolorbridge;

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  jGraphicsBuffer: jObject;
  w, h: integer;
begin
  w:= jPanel2.Width;
  h:= jPanel2.Height;

  ViewPort1.Height:= Trunc(h/2);
  ViewPort1.Width:= w;
  ViewPort1.SetScaleXY(0 {minx}, 23 {maxx}, 0 {miny}, 100 {maxy});

  ViewPort2.YTop:= Trunc(h/2);
  ViewPort2.Height:= Trunc(h/2);
  ViewPort2.Width:= w;
  ViewPort2.SetScaleXY(0 {minx}, 2.5*6 {maxx = range*6}, 0 {miny}, 100 {maxy});

  FPNoGUIGraphicsBridge1.SetSurfaceSize(w,h);
  FPNoGUIGraphicsBridge1.PathToFontFile:= '/system/fonts/Roboto-Regular.ttf'; //or DroidSerif-Bold.ttf

  FPNoGUIGraphicsBridge1.ActiveViewPort:= ViewPort1; //or in design time
  FPNoGUIGraphicsBridge1.PaintViewPort;
  FPNoGUIGraphicsBridge1.PaintGrid(True);

  FPNoGUIGraphicsBridge1.DrawDataBars([ToBar(15,'Jan', colbrBlue),
                                           ToBar(30,'Fev', colbrYellow),
                                           ToBar(70,'Mar', colbrRed),
                                           ToBar(25,'Abr', colbrLightBlue),
                                           ToBar(40,'Mai', colbrLime),
                                           ToBar(60,'Jun', colbrLightSalmon),
                                           ToBar(15,'Jul', colbrGold),
                                           ToBar(30,'Ago', colbrMagenta),
                                           ToBar(70,'Set', colbrGreen),
                                           ToBar(25,'Out', colbrLightSlateBlue),
                                           ToBar(40,'Nov', colbrOrange),
                                           ToBar(60,'Dez', colbrSalmon)]);


  FPNoGUIGraphicsBridge1.ActiveViewPort:= ViewPort2;
  FPNoGUIGraphicsBridge1.PaintViewPort;
  FPNoGUIGraphicsBridge1.PaintGrid(True);

  FPNoGUIGraphicsBridge1.DrawDataHistograms(
                                              [ToHistogram(30, colbrGreen),
                                              ToHistogram(45, colbrGold),
                                              ToHistogram(65, colbrTomato),
                                              ToHistogram(25, colbrLightSlateBlue),
                                              ToHistogram(40, colbrRed),
                                              ToHistogram(50, colbrBlue)],  2.5 {range});


  jGraphicsBuffer:= jBitmap1.GetByteBuffer(w,h);

  PGlobalDirectImagePixel:= jBitmap1.GetDirectBufferAddress(jGraphicsBuffer);

  FPNoGUIGraphicsBridge1.Surface.GetRGBAGraphics(PGlobalDirectImagePixel);

  jImageView1.SetImageBitmap(jBitmap1.GetBitmapFromByteBuffer(jGraphicsBuffer, w, h));
end;

{ Android fonts:

system/fonts/Roboto-Regular.ttf
system/fonts/Roboto-Bold.ttf
system/fonts/Roboto-BoldItalic.ttf
system/fonts/Roboto-Italic.ttf
system/fonts/Roboto-BlackItalic.ttf
system/fonts/Roboto-LightItalic.ttf
system/fonts/Roboto-ThinItalic.ttf
system/fonts/Roboto-Light.ttf

system/fonts/DroidSansFallback.ttf
system/fonts/DroidSansGeorgian.ttf
system/fonts/DroidSansHebrew-Bold.ttf
system/fonts/DroidSansHebrew-Regular.ttf
system/fonts/DroidSansMono.ttf
system/fonts/DroidSansThai.ttf
system/fonts/DroidSerif-Bold.ttf
system/fonts/DroidSerif-BoldItalic.ttf
system/fonts/DroidSerif-Italic.ttf
system/fonts/DroidSerif-Regular.ttf
}

end.
