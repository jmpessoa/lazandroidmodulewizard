{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTFPNoGUIGraphicsBridgeDemo2\jni }
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

  ViewPort1.SetScaleXY(0 {minx}, 14 {maxx}, -5 {miny}, 15 {maxy});

  FPNoGUIGraphicsBridge1.SetSurfaceSize(w,h);
  FPNoGUIGraphicsBridge1.PathToFontFile:= '/system/fonts/Roboto-Regular.ttf'; //or DroidSerif-Bold.ttf

  //FPNoGUIGraphicsBridge1.ActiveViewPort:= ViewPort1; //or in design time
  FPNoGUIGraphicsBridge1.PaintViewPort;
  FPNoGUIGraphicsBridge1.PaintGrid(True);

  ViewPort1.PenColor:= colbrRed;
  FPNoGUIGraphicsBridge1.DrawPath([ToRealPoint(4,10),
                                   ToRealPoint(5,11),
                                   ToRealPoint(6,11),
                                   ToRealPoint(7,12),
                                   ToRealPoint(8,12),
                                   ToRealPoint(10,13),
                                   ToRealPoint(11,14),
                                   ToRealPoint(12,15)]);
  //circle radius = 0.1
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(4,10),ToRealPoint(4+0.1,10) ]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(5,11),ToRealPoint(5+0.1,11) ]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(6,11),ToRealPoint(6+0.1,11) ]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(7,12),ToRealPoint(7+0.1,12) ]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(8,12),ToRealPoint(8+0.1,12) ]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(10,13),ToRealPoint(10+0.1,13)]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(11,14),ToRealPoint(11+0.1,14)]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(12,15),ToRealPoint(12+0.1,15)]);

  ViewPort1.PenColor:= colbrBlue;
  FPNoGUIGraphicsBridge1.DrawPath([ToRealPoint(4,-5),
                                   ToRealPoint(5,0),
                                   ToRealPoint(6,7),
                                   ToRealPoint(7,10),
                                   ToRealPoint(8,10),
                                   ToRealPoint(10,11),
                                   ToRealPoint(11,12),
                                   ToRealPoint(12,14)]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(4,-5),ToRealPoint(4+0.1,-5) ]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(5,0),ToRealPoint(5+0.1,0) ]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(6,7),ToRealPoint(6+0.1,7) ]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(7,10),ToRealPoint(7+0.1,10)]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(8,10),ToRealPoint(8+0.1,10)]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(10,11),ToRealPoint(10+0.1,11)]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(11,12),ToRealPoint(11+0.1,12)]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(12,14),ToRealPoint(12+0.1,14)]);

  ViewPort1.PenColor:= colbrIndigo;
  FPNoGUIGraphicsBridge1.DrawPath([ToRealPoint(4,0),
                                   ToRealPoint(5,6),
                                   ToRealPoint(6,9),
                                   ToRealPoint(7,11),
                                   ToRealPoint(8,11),
                                   ToRealPoint(10,12),
                                   ToRealPoint(11,13),
                                   ToRealPoint(12,13)]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(4,0){center},ToRealPoint(4+0.1,0) {rX}]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(5,6){center},ToRealPoint(5+0.1,6) {rX}]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(6,9){center},ToRealPoint(6+0.1,9) {rX}]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(7,11){center},ToRealPoint(7+0.1,11) {rX}]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(8,11){center},ToRealPoint(8+0.1,11) {rX}]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(10,12){center},ToRealPoint(10+0.1,12) {rX}]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(11,13){center},ToRealPoint(11+0.1,13) {rX}]);
  FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(12,13){center},ToRealPoint(12+0.1,13) {rX}]);

  //legends
  ViewPort1.PenColor:= colbrRed;
  FPNoGUIGraphicsBridge1.DrawFillRectangle([ToRealPoint(14,9),ToRealPoint(14.5,8)]); {left-top, right-bottom}
  FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(14.7,8), 'Jan', 18, colbrRed);

  ViewPort1.PenColor:= colbrBlue;
  FPNoGUIGraphicsBridge1.DrawFillRectangle([ToRealPoint(14,7),ToRealPoint(14.5,6)]); {left-top, right-bottom}
  FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(14.7,6), 'Fev', 18, colbrBlue);

  ViewPort1.PenColor:= colbrIndigo;
  FPNoGUIGraphicsBridge1.DrawFillRectangle([ToRealPoint(14,5),ToRealPoint(14.5,4)]); {left-top, right-bottom}
  FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(14.7,4), 'Mar', 18, colbrIndigo);

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
