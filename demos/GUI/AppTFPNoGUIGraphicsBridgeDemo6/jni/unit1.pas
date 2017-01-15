{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTFPNoGUIGraphicsBridgeDemo6\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, FPNoGUIGraphicsBridge,
  ViewPort;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    FPNoGUIGraphicsBridge1: TFPNoGUIGraphicsBridge;
    jBitmap1: jBitmap;
    jButton1: jButton;
    jCheckBox1: jCheckBox;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jPanel2: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    ViewPort1: TViewPort;
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1Rotate(Sender: TObject;
      rotate: TScreenStyle);

    procedure FPNoGUIGraphicsBridge1DrawParameterizedFunction(t: real; out
      x: real; out y: real; out skip: boolean);
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
    ActionBarHeight: integer;

    Velocity, AngleDegree, Gravity, AngleRadian: real;

  public
    {public declarations}
    procedure DrawMotionGraphics(w, h: integer);
  end;

var
  AndroidModule1: TAndroidModule1;
  PGlobalDirectImagePixel: PJByte;

implementation

{$R *.lfm}

uses
  GeometryUtilsBridge, fpcolorbridge;

{ TAndroidModule1 }

//km/h --->> m/s [ divide by 3,6]

procedure TAndroidModule1.DrawMotionGraphics(w, h: integer);
var
  jGraphicsBuffer: jObject;
  tmin, tmax: real;
  Ymax, Xmax: real;
  t1, x1, y1, t2, x2, y2: real;
  i: integer;
  rx, dy: real;
  auxText: string;

begin

   FPNoGUIGraphicsBridge1.SetSurfaceSize(w,h);

   ViewPort1.SetSize(w,h);
   FPNoGUIGraphicsBridge1.ActiveViewPort:= ViewPort1; //or in design time

   AngleDegree:= StrToFloat(jEditText1.Text);
   Velocity:= StrToFloat(jEditText2.Text);   {m/s}
   AngleRadian:= (AngleDegree*3.1416)/180;
   Gravity:= 9.81; //StrToFloat(Edit3.Text); {9.81 m/s2}
   tmin:= 0;
   tmax:= 2*Velocity*sin(AngleRadian)/Gravity;

   Xmax:= Velocity*cos(AngleRadian)*tmax;
   Ymax:= Velocity*Velocity*sin(AngleRadian)*sin(AngleRadian)/(2*Gravity);

   ViewPort1.SetScaleXY(0 {minx}, XMax {maxx}, 0 {miny}, Ymax {maxy});

   FPNoGUIGraphicsBridge1.PaintViewPort;
   FPNoGUIGraphicsBridge1.PaintGrid(True);

   //-------hanldle by OnDrawParameterizedFunction--------
   FPNoGUIGraphicsBridge1.DrawParameterizedFunction(True{clear the surface}, tmin, tmax);

   for i:= 0 to 8 do
   begin
     t1:= (i/8)*tmax;
     x1:=  (Velocity*cos(AngleRadian))*t1;
     y1:=  (Velocity*sin(AngleRadian))*t1 - 1/2*t1*t1*Gravity;
     rx:= Xmax/110; //circle radius
     FPNoGUIGraphicsBridge1.DrawFillCircle([ToRealPoint(x1, y1), ToRealPoint(x1 + rx, y1)]);
   end;

   FPNoGUIGraphicsBridge1.SetPenColor(colbrLime); //Light    //colbrGreenYellow
   for i:= 0 to 7 do
   begin
     t1:= (i/8)*tmax;
     x1:=  (Velocity*cos(AngleRadian))*t1;
     y1:=  (Velocity*sin(AngleRadian))*t1 - 1/2*t1*t1*Gravity;

     t2:= ((i+1)/8)*tmax;
     x2:=  (Velocity*cos(AngleRadian))*t2;
     y2:=  (Velocity*sin(AngleRadian))*t2 - 1/2*t2*t2*Gravity;

     FPNoGUIGraphicsBridge1.DrawLineArrow(x1, y1, (x1+x2)/2 , (y1+y2)/2, 2);
     FPNoGUIGraphicsBridge1.DrawLineArrow(x1, y1, (x1+x2)/2 , y1, 2);
     FPNoGUIGraphicsBridge1.DrawLineArrow(x1, y1, x1 , (y1+y2)/2, 2);
   end;

   auxText:= '                 Time: ' + FloatToStrF(tmax, ffFixed, 0,2) + 's' +
                           '      Height: ' +  FloatToStrF(Ymax, ffFixed, 0,2) + 'm' +
                           '      Distance: '+ FloatToStrF(Xmax, ffFixed, 0,2) +'m';

   dy:= Ymax/FPNoGUIGraphicsBridge1.ActiveViewPort.GridData.YInterval;
   FPNoGUIGraphicsBridge1.TextOut(ToRealPoint(0.1, -dy) , auxText);

   jGraphicsBuffer:= jBitmap1.GetByteBuffer(w,h);

   PGlobalDirectImagePixel:= jBitmap1.GetDirectBufferAddress(jGraphicsBuffer);

   FPNoGUIGraphicsBridge1.Surface.GetRGBAGraphics(PGlobalDirectImagePixel);

   jImageView1.SetImageBitmap(jBitmap1.GetBitmapFromByteBuffer(jGraphicsBuffer, w, h));

end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if Self.ScreenStyle = ssLandscape then   //horizontal
     DrawMotionGraphics(jImageView1.Width, jImageView1.Height - Trunc(1.2*Self.ActionBarHeight))
   else //default --- vertical
     DrawMotionGraphics(jImageView1.Width, jImageView1.Height);
end;

procedure TAndroidModule1.FPNoGUIGraphicsBridge1DrawParameterizedFunction(
  t: real; out x: real; out y: real; out skip: boolean);
begin                //hint: do "skip:= True;" to not draw some point!
  x:= (Velocity*cos(AngleRadian))*t;
  y:= (Velocity*sin(AngleRadian))*t - 1/2*t*t*Gravity;
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  ActionBarHeight:= 0; //default: not showing action bar ...
  FPNoGUIGraphicsBridge1.PathToFontFile:= '/system/fonts/Roboto-Regular.ttf'; //or DroidSerif-Bold.ttf
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  if  Self.ActionBarIsShowing() then ActionBarHeight:= Self.GetActionBarHeight();

  if jCheckBox1.Checked then // smart rotate
  begin
    if Self.ScreenStyleAtStart = ssLandscape {2} then   // device is on horizontal...
    begin                          //reconfigure....
       jPanel1.LayoutParamHeight:= lpMatchParent;
       jPanel1.LayoutParamWidth:= lpOneThirdOfParent;

       jPanel2.LayoutParamHeight:= lpMatchParent;
       jPanel2.LayoutParamWidth:= lpTwoThirdOfParent;
       jPanel2.PosRelativeToAnchor:= [raToRightOf];

       jPanel1.ResetAllRules;
       jPanel2.ResetAllRules;

       Self.UpdateLayout;
    end;
  end;

  jButton1.PerformClick();

  jEditText1.SetFocus;

end;

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
begin

 if jCheckBox1.Checked then   // smart rotate
 begin
    if rotate = ssLandscape then   // device is on horizontal...
    begin               //reconfigure....
      jPanel1.LayoutParamHeight:= lpMatchParent;
      jPanel1.LayoutParamWidth:= lpOneThirdOfParent;

      jPanel2.LayoutParamHeight:= lpMatchParent;
      jPanel2.LayoutParamWidth:= lpTwoThirdOfParent;
      jPanel2.PosRelativeToAnchor:= [raToRightOf];

      jPanel1.ResetAllRules;
      jPanel2.ResetAllRules;

    end
    else if rotate = ssPortrait  then //device is on Verical
    begin      //after rotation device is in vertical :: default
      jPanel1.LayoutParamHeight:= lpWrapContent;
      jPanel1.LayoutParamWidth:= lpMatchParent;

      jPanel2.LayoutParamHeight:= lpHalfOfParent;
      jPanel2.LayoutParamWidth:= lpMatchParent;
      jPanel2.PosRelativeToAnchor:= [raBelow];

      jPanel1.ResetAllRules;
      jPanel2.ResetAllRules;
    end;
 end;

 Self.UpdateLayout;  // <--- Must have!

 JButton1.PerformClick();

end;


end.

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


