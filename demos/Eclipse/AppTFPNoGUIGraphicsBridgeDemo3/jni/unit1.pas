{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTFPNoGUIGraphicsBridgeDemo3\jni }
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
  FPColorBridge, GeometryUtilsBridge;

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  jGraphicsBuffer: jObject;
  w, h: integer;
begin
  w:= jPanel2.Width;
  h:= jPanel2.Height;

  ViewPort1.Height:= h;
  ViewPort1.Width:= w;

  ViewPort1.SetScaleXY(0 {minx}, 12 {maxx}, 0 {miny}, 12 {maxy});

  FPNoGUIGraphicsBridge1.SetSurfaceSize(w,h);
  FPNoGUIGraphicsBridge1.PathToFontFile:= '/system/fonts/Roboto-Regular.ttf'; //or DroidSerif-Bold.ttf

  //FPNoGUIGraphicsBridge1.ActiveViewPort:= ViewPort1; //or in design time
  FPNoGUIGraphicsBridge1.PaintViewPort;
  FPNoGUIGraphicsBridge1.PaintGrid(True);

   ViewPort1.PenColor:= colbrRed;
   FPNoGUIGraphicsBridge1.DrawFillRectangle([ToRealPoint(0,2), ToRealPoint(2,1)]); {left-top, right-bottom}

   ViewPort1.PenColor:= colbrGreen;
   FPNoGUIGraphicsBridge1.DrawFillRectangle([ToRealPoint(2,4), ToRealPoint(4,3)]); {left-top, right-bottom}

   ViewPort1.PenColor:= colbrBlue;
   FPNoGUIGraphicsBridge1.DrawFillRectangle([ToRealPoint(4,6), ToRealPoint(6,5)]); {left-top, right-bottom}

   ViewPort1.PenColor:= colbrYellow;
   FPNoGUIGraphicsBridge1.DrawFillRectangle([ToRealPoint(6,8), ToRealPoint(8,7)]); {left-top, right-bottom}

   ViewPort1.PenColor:= colbrOrange;
   FPNoGUIGraphicsBridge1.DrawFillRectangle([ToRealPoint(8,10), ToRealPoint(10,9)]); {left-top, right-bottom}

   ViewPort1.PenColor:= colbrLime;
   FPNoGUIGraphicsBridge1.DrawFillRectangle([ToRealPoint(10,12), ToRealPoint(12,11)]); {left-top, right-bottom}

   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(-0.2,-0.5),'Jan',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(0.8,-0.5),'Fev',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(1.8,-0.5),'Mar',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(2.8,-0.5),'Abr',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(3.8,-0.5),'Mai',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(4.8,-0.5),'Jun',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(5.8,-0.5),'Jul',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(6.8,-0.5),'Ago',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(7.8,-0.5),'Set',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(8.8,-0.5),'Out',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(9.8,-0.5),'Nov',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(10.8,-0.5),'Dez',22);

   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(-0.4,1), 'A1',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(-0.4,3), 'A2',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(-0.4,5), 'A3',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(-0.4,7), 'A4',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(-0.4,9),'A5',22);
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(-0.4,11),'A6',22);

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
