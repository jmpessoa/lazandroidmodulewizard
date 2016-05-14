{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTFPNoGUIGraphicsBridgeDemo7\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, ViewPort, FPNoGUIGraphicsBridge, FPImage;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    FPNoGUIGraphicsBridge1: TFPNoGUIGraphicsBridge;
    jBitmap1: jBitmap;
    jButton1: jButton;
    jImageView1: jImageView;
    jImageView2: jImageView;
    jTextView1: jTextView;
    ViewPort1: TViewPort;
    procedure FPNoGUIGraphicsBridge1DrawFunction(x: real; out y: real; out
      skip: boolean);
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
begin
  w:= jImageView1.GetBitmapWidth;
  h:= jImageView1.GetBitmapHeight;

  FPNoGUIGraphicsBridge1.SetSurfaceSize(w,h);
  FPNoGUIGraphicsBridge1.PathToFontFile:= '/system/fonts/Roboto-Regular.ttf'; //DroidSerif-Bold.ttf
  //FPNoGUIGraphicsBridge1.ActiveViewPort:= ViewPort1; //set in Object inspector!

  ViewPort1.SetSize(w,h);

  ViewPort1.DrawAxis:= True;
  ViewPort1.DrawGrid:= True;

  ViewPort1.SetScaleXY(-1.6 {xmin},1.6{xmax}, -2.0{ymin}, 6.0{ymax}); //real world!!

  jGraphicsBuffer:= jBitmap1.GetByteBufferFromBitmap(jImageView1.GetBitmapImage());

  PGlobalDirectImagePixel:= jBitmap1.GetDirectBufferAddress(jGraphicsBuffer); // rapid!

  FPNoGUIGraphicsBridge1.Surface.SetRGBAGraphics(PGlobalDirectImagePixel);  // Android --> Pascal

  FPNoGUIGraphicsBridge1.PaintGrid(False); // false: grid background not painted!
  FPNoGUIGraphicsBridge1.DrawFunction(False);

  FPNoGUIGraphicsBridge1.Surface.GetRGBAGraphics(PGlobalDirectImagePixel);  //Pascal --> Android

  jImageView2.SetImageBitmap(jBitmap1.GetBitmapFromByteBuffer(jGraphicsBuffer, w, h));

end;

procedure TAndroidModule1.FPNoGUIGraphicsBridge1DrawFunction(x: real; out
  y: real; out skip: boolean);
begin
   y:= 4*x*x*x*x - 5*x*x*x - x*x + x -1;
end;


end.

