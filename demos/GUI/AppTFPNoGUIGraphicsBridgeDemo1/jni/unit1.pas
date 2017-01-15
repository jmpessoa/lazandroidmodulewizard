{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTFPNoGUIGraphicsBridgeDemo1\jni }
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
    procedure ViewPort1ChangeFontColor(Sender: TObject);
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

function GenericFunction1(x: real): real;
begin
 Result:= x*x*x;
end;

function GenericFunction2(x: real): real;
begin
 Result:= 4*x*x*x*x - 5*x*x*x - x*x + x -1;
end;

procedure TAndroidModule1.ViewPort1ChangeFontColor(Sender: TObject);
begin
   FPNoGUIGraphicsBridge1.SetFontColor(ViewPort1.FontColor);
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  jGraphicsBuffer: jObject;
  w, h: integer;
begin
  w:= jPanel2.Width;
  h:= jPanel2.Height;

  FPNoGUIGraphicsBridge1.SetSurfaceSize(w,h);
  FPNoGUIGraphicsBridge1.PathToFontFile:= '/system/fonts/Roboto-Regular.ttf'; //DroidSerif-Bold.ttf
  //FPNoGUIGraphicsBridge1.ActiveViewPort:= ViewPort1; //set in Object inspector!

  ViewPort1.SetSize(w,h);

  ViewPort1.DrawAxis:= True;
  ViewPort1.DrawGrid:= True;

  ViewPort1.SetScaleXY(-1.6 {xmin},1.6{xmax}, -2.0{ymin}, 6.0{ymax}); //real world!!

  FPNoGUIGraphicsBridge1.AddEntity('blue_layer','Circle',[Point(0.0,1.0){center},
                                                           Point(0.0+0.5,1.0){radio=Abs(x2-x1)}],'This is a Circle!','foo');

  FPNoGUIGraphicsBridge1.AddEntity('blue_layer','Line',[Point(0.0,1.5),Point(1.0, 3.6)],'','foo');
  FPNoGUIGraphicsBridge1.AddEntity('blue_layer','Polyline',[Point(0.0,1.5),Point(0.5,1),
                                                             Point(1.0,1.5), Point(0.5,2)],'','');

  FPNoGUIGraphicsBridge1.AddEntity('blue_layer','Text',[Point(0.0,0.5)],'Hello World!','');

  FPNoGUIGraphicsBridge1.AddFunction(@GenericFunction1,-1.6,1.6);
  FPNoGUIGraphicsBridge1.AddFunction(@GenericFunction2,-1.6,1.6);

  FPNoGUIGraphicsBridge1.PaintViewPort;
  FPNoGUIGraphicsBridge1.PaintGrid(True);

  ViewPort1.PenColor:= colbrBlue;
  FPNoGUIGraphicsBridge1.DrawEntities('blue_layer');

  ViewPort1.PenColor:= colbrRed;
  FPNoGUIGraphicsBridge1.DrawFunction(False, 0);
  FPNoGUIGraphicsBridge1.DrawFunction(False, 1);

  jGraphicsBuffer:= jBitmap1.GetByteBuffer(w,h);

  PGlobalDirectImagePixel:= jBitmap1.GetDirectBufferAddress(jGraphicsBuffer);

  FPNoGUIGraphicsBridge1.Surface.GetRGBAGraphics(PGlobalDirectImagePixel);

  jImageView1.SetImageBitmap(jBitmap1.GetBitmapFromByteBuffer(jGraphicsBuffer, w, h));
end;

{ Android:

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
