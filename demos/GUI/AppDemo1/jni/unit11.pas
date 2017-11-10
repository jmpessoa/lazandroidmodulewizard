{Hint: save all files to location: \jni }
unit unit11;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_GLESv2_Canvas, Laz_And_GLESv2_Canvas_h, Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule11 }

  TAndroidModule11 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jCanvasES2_1: jCanvasES2;
      jImageList1: jImageList;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      jTimer1: jTimer;
      procedure AndroidModule11BackButton(Sender: TObject);
      procedure AndroidModule11Create(Sender: TObject);
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jCanvasES2_1GLChange(Sender: TObject; W, H: integer);
      procedure jCanvasES2_1GLCreate(Sender: TObject);
      procedure jCanvasES2_1GLDestroy(Sender: TObject);
      procedure jCanvasES2_1GLDown(Sender: TObject; Touch: TMouch);
      procedure jCanvasES2_1GLDraw(Sender: TObject);
      procedure jCanvasES2_1GLMove(Sender: TObject; Touch: TMouch);
      procedure jCanvasES2_1GLThread(Sender: TObject);
      procedure jCanvasES2_1GLUp(Sender: TObject; Touch: TMouch);
      procedure jTimer1Timer(Sender: TObject);
    private
      {private declarations}
    public
      {public declarations}
      gAngle    : Single;
      gSpeed    : Single;
      gWork     : Boolean;
      gX,gY     : Single;
      gZoom     : Single;
      gArcBall  : TxgArcBall;
      gW        : integer;
      gH        : integer;
    //  IsCreate : boolean;
      procedure DoDraw(Angle,Zoom : Single; scrW: integer; scrH: integer);
  end;
  
var
  AndroidModule11: TAndroidModule11;

implementation
  
{$R *.lfm}
  

{ TAndroidModule11 }

// Angle 0~360
procedure TAndroidModule11.DoDraw(Angle,Zoom : Single; scrW: integer; scrH: integer);
const
   VRXP1       : array[0..2*5-1] of GLFloat =
                 ( 0.00, 0.05,   // pt1 위
                  -0.43, 0.36,   // pt2 우상
                  -0.26, 0.86,   // pt3 우하
                   0.26, 0.86,   // pt4 좌하
                   0.43, 0.36);  // pt5 좌상

   VRXT1       : array[0..2*3-1] of GLfloat =
                 (-0.39,-0.28,
                   0.00,-0.95,
                   0.39,-0.28);
var
   ZDepth : Single;
   Layer  : Integer;
   i      : integer;
   XYs    : TXYs;
   XY4cw  : TXY4CW;
   MVPsav : TM4x4;
begin
  //dbg('d1');
  jCanvasES2_1.Screen_Setup (scrW, scrH, xp2D,cCull_Yes);
  jCanvasES2_1.Screen_Clear(1,1,1,1);
  //jCanvasES2_1.Screen_Clear(0.5,0.5,0.5,0.5);
  //dbg('d2');

  ZDepth := 0;
  //-------------------------------------------------------------------------
  // Draw BackGround
  //-------------------------------------------------------------------------
  jCanvasES2_1.MVP := cID4x4;
  jCanvasES2_1.Rotate(gArcBall.aRot.X,1,0,0);//  X
  jCanvasES2_1.Rotate(gArcBall.aRot.Y,0,1,0);//  Y
  jCanvasES2_1.Rotate(gArcBall.aRot.Z,0,0,1);//  Z
  jCanvasES2_1.Scale(Zoom,Zoom,Zoom);
  jCanvasES2_1.setMVP(jCanvasES2_1.MVP);
  MVPsav := jCanvasES2_1.MVP;

  jCanvasES2_1.DrawTexture(jCanvasES2_1.Textures[0],
                           _XY4cw( -1, 1,   1, 1,   1,-1,   -1,-1),
                           ZDepth,
                           cAlpha_1,
                           Shader_Texture);


  //dbg('d3');
  // Init Stencil Mode ------------------------------------------------------
  jCanvasES2_1.SetMask(0,mmOpen);
  //dbg('d4');
  //-------------------------------------------------------------------------
  // Obj 1.  1st Rotated Obj.
  //-------------------------------------------------------------------------
  Layer := 1;
  // Mask -------------------------------------------------------------------
  jCanvasES2_1.SetMask(Layer,mmMask);
  //
  jCanvasES2_1.setMVP(MVPsav);

  XYs.Cnt := 5;
  for i := 0 to 4 do
     XYs.Pt[i] := _XY(VRXP1[i*2+0],VRXP1[i*2+1]);

  jCanvasES2_1.DrawMask(XYs,ZDepth);
  //dbg('d5');

  // Mask Background --------------------------------------------------------
  jCanvasES2_1.SetMask(Layer,mmDraw);
  jCanvasES2_1.DrawTile(jCanvasES2_1.Textures[1],
                        _XY4cw( -1, 1,   1, 1,   1,-1,   -1,-1),
                        20,
                        ZDepth,
                        cAlpha_1,
                        Shader_Texture);

  //Image on Mask Layer ----------------------------------------------------
  jCanvasES2_1.MVP := MVPsav;
  jCanvasES2_1.Translate(0,0.5,ZDepth);
  jCanvasES2_1.Rotate(Angle,0,0,1);
  jCanvasES2_1.Scale(0.2+Angle/360,0.2+Angle/360,1);
  jCanvasES2_1.SetMVP(jCanvasES2_1.MVP);
  jCanvasES2_1.DrawTexture(jCanvasES2_1.Textures[2],
                           _XY4cw( -1, 1,   1, 1,   1,-1,   -1,-1),
                           ZDepth,
                           Angle/360, // Alpha
                           Shader_Texture);
  //dbg('d6');

  //-------------------------------------------------------------------------
  // Obj 2.  2nd Rotated Obj.
  //-------------------------------------------------------------------------

  Layer := 2;
  //  Mask ------------------------------------------------------------------
  jCanvasES2_1.SetMask(Layer,mmMask);
  jCanvasES2_1.SetMVP(MVPsav);
  //
  XYs.Cnt := 3;
  for i := 0 to 2 do
   XYs.Pt[i] := _XY(VRXT1[i*2+0],VRXT1[i*2+1]);

  jCanvasES2_1.DrawMask(XYs,ZDepth);
  //dbg('d7');

  // Mask Background --------------------------------------------------------
  jCanvasES2_1.SetMask(Layer,mmDraw);
  jCanvasES2_1.DrawTile(jCanvasES2_1.Textures[1],
                        _XY4cw( -1, 1,   1, 1,   1,-1,   -1,-1),
                        20,
                        ZDepth,
                        cAlpha_1,
                        Shader_Texture);

  // Image on Mask Layer ----------------------------------------------------
  jCanvasES2_1.MVP:= MVPsav;
  jCanvasES2_1.Translate(0,-0.5,ZDepth);
  jCanvasES2_1.Rotate(-Angle,0,0,1);
  jCanvasES2_1.Scale(0.2+Angle/360,0.2+Angle/360,1);
  jCanvasES2_1.SetMVP(jCanvasES2_1.MVP);
  jCanvasES2_1.DrawTexture(jCanvasES2_1.Textures[3],
                           _XY4cw( -1, 1,   1, 1,   1,-1,   -1,-1),
                           ZDepth,
                           cAlpha_1,
                           Shader_Texture);

  jCanvasES2_1.SetMask(0,mmClose);
  //dbg('d8');

  //-------------------------------------------------------------------------
  // Obj 3.  Floating Obj
  //-------------------------------------------------------------------------
  jCanvasES2_1.MVP:= MVPsav;
  jCanvasES2_1.Translate(0, 0,ZDepth-0.1);
  jCanvasES2_1.Rotate(Angle,0,0,1);
  jCanvasES2_1.Scale(Angle/720,Angle/720,Angle/720);
  jCanvasES2_1.SetMVP(jCanvasES2_1.MVP);
  jCanvasES2_1.DrawTexture(jCanvasES2_1.Textures[4],
                           _XY4cw( -1, 1,   1, 1,   1,-1,   -1,-1),
                           ZDepth-0.01,
                           cAlpha_1,
                           Shader_Texture);
  //jCanvasES2_1.Update;

end;

procedure TAndroidModule11.DataModuleJNIPrompt(Sender: TObject);
begin
    gAngle  := 0;
    gSpeed  := 1.0;
    gWork   := True;
    gZoom   := 1.0;
    ArcBall_Init(gArcBall);
end;

procedure TAndroidModule11.jButton1Click(Sender: TObject);
begin
   jTimer1.Enabled:= not jTimer1.Enabled;
   if jTimer1.Enabled then
   begin
     jTextView2.Text:= 'Auto: On';
     gWork:= True;
   end
   else
   begin
     gWork:= False;
     jTextView2.Text:= 'Auto: Off';
   end;
end;

procedure TAndroidModule11.jButton2Click(Sender: TObject);
begin
  gSpeed:= gSpeed + 0.3;
end;

procedure TAndroidModule11.jButton3Click(Sender: TObject);
begin
  ShowMessage('Hello World!');
end;

procedure TAndroidModule11.jCanvasES2_1GLChange(Sender: TObject; W, H: integer);
begin
   gW:= W;
   gH:= H;
end;

//https://stackoverflow.com/questions/16046918/glsurfaceview-renderer-how-to-force-surface-re-creation
procedure TAndroidModule11.jCanvasES2_1GLCreate(Sender: TObject);
begin
  jCanvasES2_1.Texture_Load_All;
  jCanvasES2_1.Shader_Compile('simon_Vert','simon_Frag');
  jCanvasES2_1.Shader_Link;
  jCanvasES2_1.Refresh; //dispatch Ondraw...
end;

procedure TAndroidModule11.jCanvasES2_1GLDestroy(Sender: TObject);
begin
  //
end;

procedure TAndroidModule11.jCanvasES2_1GLDown(Sender: TObject; Touch: TMouch);
begin
  ArcBall_Down(gArcBall, gW, gH, Touch.Pt.X, Touch.Pt.Y);
end;

procedure TAndroidModule11.jCanvasES2_1GLDraw(Sender: TObject);
begin
  DoDraw(gAngle*gSpeed, gZoom, gW, gH);
end;

procedure TAndroidModule11.jCanvasES2_1GLMove(Sender: TObject; Touch: TMouch);
begin
  gX:= Touch.Pt.x;
  gY:= Touch.Pt.y;
  gZoom:= Touch.Zoom;
  gAngle:= Touch.Angle;
  ArcBall_Move(gArcBall,gX,gY);
  jCanvasES2_1.Refresh;
end;

procedure TAndroidModule11.jCanvasES2_1GLThread(Sender: TObject);
begin
  //
end;

procedure TAndroidModule11.jCanvasES2_1GLUp(Sender: TObject; Touch: TMouch);
begin
  ArcBall_Up(gArcBall);
end;

procedure TAndroidModule11.jTimer1Timer(Sender: TObject);
begin
  gAngle := gAngle + 4;
  if gAngle > 360 then gAngle:= 0;
  if gWork then jCanvasES2_1.Refresh;
end;

procedure TAndroidModule11.DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  gWork:= false;
  jTimer1.Enabled := False;
  CanClose:= True;
end;

procedure TAndroidModule11.AndroidModule11Create(Sender: TObject);
begin
 // IsCreate:= False;
end;

procedure TAndroidModule11.AndroidModule11BackButton(Sender: TObject);
begin
 // IsCreate:= False;
end;

end.
