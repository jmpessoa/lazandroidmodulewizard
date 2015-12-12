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

  ViewPort1.SetScaleXY(0 {minx}, 15 {maxx}, -5 {miny}, 15 {maxy});

  FPNoGUIGraphicsBridge1.SetSurfaceSize(w,h);
  FPNoGUIGraphicsBridge1.PathToFontFile:= '/system/fonts/Roboto-Regular.ttf'; //or DroidSerif-Bold.ttf

  //FPNoGUIGraphicsBridge1.ActiveViewPort:= ViewPort1; //or in design time
  FPNoGUIGraphicsBridge1.PaintViewPort;
  FPNoGUIGraphicsBridge1.PaintGrid(True);

  FPNoGUIGraphicsBridge1.AddEntity('red','Line',[ToRealPoint(4,10),ToRealPoint(5,11) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('red','Circle',[ToRealPoint(4,10),ToRealPoint(4+0.1,10) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('red','Line',[ToRealPoint(5,11),ToRealPoint(6,11) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('red','Circle',[ToRealPoint(5,11),ToRealPoint(5+0.1,11) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('red','Line',[ToRealPoint(6,11),ToRealPoint(7,12) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('red','Circle',[ToRealPoint(6,11),ToRealPoint(6+0.1,11) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('red','Line',[ToRealPoint(7,12),ToRealPoint(8,12) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('red','Circle',[ToRealPoint(7,12),ToRealPoint(7+0.1,12) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('red','Line',[ToRealPoint(8,12),ToRealPoint(10,13) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('red','Circle',[ToRealPoint(8,12),ToRealPoint(8+0.1,12) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('red','Line',[ToRealPoint(10,13),ToRealPoint(11,14) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('red','Circle',[ToRealPoint(10,13),ToRealPoint(10+0.1,13) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('red','Line',[ToRealPoint(11,14),ToRealPoint(12,15) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('red','Circle',[ToRealPoint(11,14),ToRealPoint(11+0.1,14) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('red','Circle',[ToRealPoint(12,15),ToRealPoint(12+0.1,15) ],'','');

  //legend
  FPNoGUIGraphicsBridge1.AddEntity('red','Line',[ToRealPoint(14,5),ToRealPoint(15,5) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('red','Text',[ToRealPoint(15,5)],'Feb','');

  FPNoGUIGraphicsBridge1.AddEntity('blue','Line',[ToRealPoint(4,-5),ToRealPoint(5,0) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('blue','Circle',[ToRealPoint(4,-5),ToRealPoint(4+0.1,-5) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('blue','Line',[ToRealPoint(5,0),ToRealPoint(6,7) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('blue','Circle',[ToRealPoint(5,0),ToRealPoint(5+0.1,0) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('blue','Line',[ToRealPoint(6,7),ToRealPoint(7,10) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('blue','Circle',[ToRealPoint(6,7),ToRealPoint(6+0.1,7) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('blue','Line',[ToRealPoint(7,10),ToRealPoint(8,10) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('blue','Circle',[ToRealPoint(7,10),ToRealPoint(7+0.1,10) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('blue','Line',[ToRealPoint(8,10),ToRealPoint(10,11) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('blue','Circle',[ToRealPoint(8,10),ToRealPoint(8+0.1,10) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('blue','Line',[ToRealPoint(10,11),ToRealPoint(11,12) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('blue','Circle',[ToRealPoint(10,11),ToRealPoint(10+0.1,11) ],'','');

  FPNoGUIGraphicsBridge1.AddEntity('blue','Line',[ToRealPoint(11,12),ToRealPoint(12,14) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('blue','Circle',[ToRealPoint(11,12),ToRealPoint(11+0.1,12) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('blue','Circle',[ToRealPoint(12,14),ToRealPoint(12+0.1,14) ],'','');

  //legend
  FPNoGUIGraphicsBridge1.AddEntity('blue','Line',[ToRealPoint(14,4),ToRealPoint(15,4) ],'','');
  FPNoGUIGraphicsBridge1.AddEntity('blue','Text',[ToRealPoint(15,4)],'Jan','');

  //ViewPort1.PenColor:= colbrRed;  //default: design time
  FPNoGUIGraphicsBridge1.DrawEntities('red');

  ViewPort1.PenColor:= colbrBlue;
  FPNoGUIGraphicsBridge1.DrawEntities('blue');

     //or simply
   ViewPort1.PenColor:= colbrGreen;
   FPNoGUIGraphicsBridge1.DrawPath([ToRealPoint(3,3), ToRealPoint(4,4), ToRealPoint(5,5),ToRealPoint(6,6), ToRealPoint(7,7), ToRealPoint(8,8)]);
   FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(3,3){center},ToRealPoint(3+0.1,3) {rX}]);
   FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(4,4){center},ToRealPoint(4+0.1,4) {rX}]);
   FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(5,5){center},ToRealPoint(5+0.1,5) {rX}]);
   FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(6,6){center},ToRealPoint(6+0.1,6) {rX}]);
   FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(7,7){center},ToRealPoint(7+0.1,7) {rX}]);
   FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(8,8){center},ToRealPoint(8+0.1,8) {rX}]);
   FPNoGUIGraphicsBridge1.DrawFillRectangle([ToRealPoint(9.5,8.0),ToRealPoint(10,7)]); {left-top, right-bottom}
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(10.2,7), 'Mar', 22, colbrGreen);


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
