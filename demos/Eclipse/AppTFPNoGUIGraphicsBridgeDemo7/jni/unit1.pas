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
    jImageView3: jImageView;
    jTextView1: jTextView;
    ViewPort1: TViewPort;
    procedure FPNoGUIGraphicsBridge1DrawFunction(x: real; out y: real; out
      skip: boolean);
    procedure jButton1Click(Sender: TObject);
    procedure jImageView1Click(Sender: TObject);
    procedure jImageView2Click(Sender: TObject);
    procedure jImageView3Click(Sender: TObject);
  private
    {private declarations}

  public
    {public declarations}
    Fw, Fh: integer;
   // Flines3D: Array of TLine3D;
  end;


var
  AndroidModule1: TAndroidModule1;
  PGlobalDirectImagePixel: PJByte;
  jGraphicsBuffer: jObject;

implementation

{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  Fw:= jBitmap1.Width;
  Fh:= jBitmap1.Height;

  FPNoGUIGraphicsBridge1.SetSurfaceSize(Fw,Fh);
  FPNoGUIGraphicsBridge1.PathToFontFile:= '/system/fonts/Roboto-Regular.ttf'; //DroidSerif-Bold.ttf
  //FPNoGUIGraphicsBridge1.ActiveViewPort:= ViewPort1; //set in Object inspector!

  ViewPort1.SetSize(Fw,Fh);

  ViewPort1.DrawAxis:= True;
  ViewPort1.DrawGrid:= True;

  ViewPort1.SetScaleXY(-240 {xmin}, 240{xmax}, -240{ymin}, 240{ymax}); //real world!!
  jGraphicsBuffer:= jBitmap1.GetByteBufferFromBitmap(jBitmap1.GetImage());
  jGraphicsBuffer:= Get_jObjGlobalRef(jGraphicsBuffer);

  PGlobalDirectImagePixel:= jBitmap1.GetDirectBufferAddress(jGraphicsBuffer); // rapid!
  FPNoGUIGraphicsBridge1.Surface.SetRGBAGraphics(PGlobalDirectImagePixel);  // Android --> Pascal

  //FPNoGUIGraphicsBridge1.PaintGrid(False); // false: grid background not painted!
  //FPNoGUIGraphicsBridge1.DrawFunction(False);

  (*
  Flines3D[0]:= ToLine3D(-70,70,-70,70,70,-70);{Base of cube}
  Flines3D[1]:= ToLine3D(70,70,-70,70,-70,-70);
  Flines3D[2]:= ToLine3D(70,-70,-70,-70,-70,-70);
  Flines3D[3]:= ToLine3D(-70,-70,-70,-70,70,-70);
  Flines3D[4]:= ToLine3D(-70,70,70,70,70,70); {Top of cube}
  Flines3D[5]:= ToLine3D(70,70,70,70,-70,70);
  Flines3D[6]:= ToLine3D(70,-70,70,-70,-70,70);
  Flines3D[7]:= ToLine3D(-70,-70,70,-70,70,70);
  Flines3D[8]:= ToLine3D(-70,70,-70,-70,70,70); {Side of cube}
  Flines3D[9]:= ToLine3D(70,70,-70,70,70,70);
  Flines3D[10]:= ToLine3D(70,-70,-70,70,-70,70);
  Flines3D[11]:= ToLine3D(-70,-70,-70,-70,-70,70);
  FPNoGUIGraphicsBridge1.Draw3D(Flines3D);
  *)

  { https://tianjara.net/blog/tags/projections/
    3D axis map:
         x\  |z /y
  }

  FPNoGUIGraphicsBridge1.AddLine3D(-70,70,-70,70,70,-70);{Base of cube}
  FPNoGUIGraphicsBridge1.AddLine3D(70,70,-70,70,-70,-70);
  FPNoGUIGraphicsBridge1.AddLine3D(70,-70,-70,-70,-70,-70);
  FPNoGUIGraphicsBridge1.AddLine3D(-70,-70,-70,-70,70,-70);

  FPNoGUIGraphicsBridge1.AddLine3D(-70,70,70,70,70,70); {Top of cube}
  FPNoGUIGraphicsBridge1.AddLine3D(70,70,70,70,-70,70);
  FPNoGUIGraphicsBridge1.AddLine3D(70,-70,70,-70,-70,70);
  FPNoGUIGraphicsBridge1.AddLine3D(-70,-70,70,-70,70,70);

  FPNoGUIGraphicsBridge1.AddLine3D(-70,70,70,70,-70,70);  //cross Top line

  FPNoGUIGraphicsBridge1.AddLine3D(-70,70,-70,-70,70,70); {Side of cube}
  FPNoGUIGraphicsBridge1.AddLine3D(70,70,-70,70,70,70);
  FPNoGUIGraphicsBridge1.AddLine3D(70,-70,-70,70,-70,70);
  FPNoGUIGraphicsBridge1.AddLine3D(-70,-70,-70,-70,-70,70);

  FPNoGUIGraphicsBridge1.Draw3D();


  FPNoGUIGraphicsBridge1.Surface.GetRGBAGraphics(PGlobalDirectImagePixel);  //Pascal --> Android
  jImageView1.SetImageBitmap(jBitmap1.GetBitmapFromByteBuffer(jGraphicsBuffer, Fw, Fh ) );

end;

procedure TAndroidModule1.jImageView1Click(Sender: TObject);
begin
  //FPNoGUIGraphicsBridge1.Rotate3Dy(Flines3D, 30);
  //FPNoGUIGraphicsBridge1.Draw3D(Flines3D);

  FPNoGUIGraphicsBridge1.Rotate3Dy(30);
  FPNoGUIGraphicsBridge1.ClearSurface;
  FPNoGUIGraphicsBridge1.Draw3D();

  FPNoGUIGraphicsBridge1.Surface.GetRGBAGraphics(PGlobalDirectImagePixel);  //Pascal --> Android
  jImageView2.SetImageBitmap( jBitmap1.GetBitmapFromByteBuffer( jGraphicsBuffer, Fw, Fh ) );
end;

procedure TAndroidModule1.jImageView2Click(Sender: TObject);
begin
  //FPNoGUIGraphicsBridge1.Rotate3Dz(Flines3D, 30);
  //FPNoGUIGraphicsBridge1.Draw3D(Flines3D);

  FPNoGUIGraphicsBridge1.Rotate3Dz(30);
  FPNoGUIGraphicsBridge1.ClearSurface;
  FPNoGUIGraphicsBridge1.Draw3D();

  FPNoGUIGraphicsBridge1.Surface.GetRGBAGraphics(PGlobalDirectImagePixel);  //Pascal --> Android
  jImageView3.SetImageBitmap( jBitmap1.GetBitmapFromByteBuffer( jGraphicsBuffer, Fw, Fh ) );
end;

procedure TAndroidModule1.jImageView3Click(Sender: TObject);
begin
   //
end;

procedure TAndroidModule1.FPNoGUIGraphicsBridge1DrawFunction(x: real; out
  y: real; out skip: boolean);
begin
   y:= 4*x*x*x*x - 5*x*x*x - x*x + x -1;
end;


end.

