{Hint: save all files to location: \jni }
unit unit13;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_GLESv2_Canvas, Laz_And_GLESv2_Canvas_h, Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule13 }

  TAndroidModule13 = class(jForm)
      jButton1: jButton;
      jCanvasES2_1: jCanvasES2;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      jTimer1: jTimer;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jCanvasES2_1GLChange(Sender: TObject; W, H: integer);
      procedure jCanvasES2_1GLCreate(Sender: TObject);
      procedure jCanvasES2_1GLDown(Sender: TObject; Touch: TMouch);
      procedure jCanvasES2_1GLDraw(Sender: TObject);
      procedure jCanvasES2_1GLMove(Sender: TObject; Touch: TMouch);
      procedure jCanvasES2_1GLUp(Sender: TObject; Touch: TMouch);
      procedure jTimer1Timer(Sender: TObject);
    private
      {private declarations}
    public
      {public declarations}
      gSpeed  : Single;
      gWorking: Boolean;
      gX,gY   : Single;
      gZoom   : Single;
      gArcBall: TxgArcBall;
      gW      : integer;
      gH      : integer;
      //
      procedure DoDraw(Zoom : Single; scrW: integer; scrH: integer);
  end;
  
var
  AndroidModule13: TAndroidModule13;

implementation
  
{$R *.lfm}
  

{ TAndroidModule13 }

procedure TAndroidModule13.DoDraw(Zoom: Single; scrW: integer; scrH: integer);
const
   cVertex : array[0..3*4*6-1] of Single =                 // Triangle Strip
            (  -1, 1, 1,  -1,-1, 1,   1, 1, 1,  1,-1, 1,   // Top
               -1,-1,-1,  -1, 1,-1,   1,-1,-1,  1, 1,-1,   // Bottom
               -1,-1, 1,  -1, 1, 1,  -1,-1,-1, -1, 1,-1,   // Left
                1, 1, 1,   1,-1, 1,   1, 1,-1,  1,-1,-1,   // Right
                1,-1, 1,  -1,-1, 1,   1,-1,-1, -1,-1,-1,   // Front
               -1, 1, 1,   1, 1, 1,  -1, 1,-1,  1, 1,-1);  // Back
   cColor  : array[0..4*4*6-1] of Single =
            (   0,1,0,1,  0,1,1,1,  1,1,0,1,  1,1,1,1,     // Top
                0,0,1,1,  0,0,0,1,  1,0,1,1,  1,0,0,1,     // Bottom
                0,1,1,1,  0,1,0,1,  0,0,1,1,  0,0,0,1,     // Left
                1,1,0,1,  1,1,1,1,  1,0,0,1,  1,0,1,1,     // Right
                1,1,1,1,  0,1,1,1,  1,0,1,1,  0,0,1,1,     // Front
                0,1,0,1,  1,1,0,1,  0,0,0,1,  1,0,0,1   ); // Back
var
   i: Integer;
begin
   // Drawing ------------------------------------------------------------------
   jCanvasES2_1.Screen_Setup(scrW, scrH, xp3D,False);
   jCanvasES2_1.Screen_Clear(0.9,0.9,0.9,1);

   jCanvasES2_1.Shader:= Shader_Color;
   jCanvasES2_1.Alpha:= 0.8;

   jCanvasES2_1.MVP:= cID4x4;
   jCanvasES2_1.Translate(0,0,0);
   jCanvasES2_1.Rotate(gArcBall.aRot.X,1,0,0);//  X
   jCanvasES2_1.Rotate(gArcBall.aRot.Y,0,1,0);//  Y
   jCanvasES2_1.Rotate(gArcBall.aRot.Z,0,0,1);//  Z
   jCanvasES2_1.Scale (Zoom*0.4,Zoom*0.4,Zoom*0.4);
   jCanvasES2_1.SetMVP(jCanvasES2_1.MVP);

   for i:= 0 to 5 do
     jCanvasES2_1.DrawArray(@cVertex[i*3*4],@cColor[i*4*4],nil,nil,4);

   // Update -------------------------------------------------------------------
   // jCanvasES2_1.Update;
end;

procedure TAndroidModule13.DataModuleCreate(Sender: TObject);
begin
  gZoom  := 1.0;
  gSpeed := 1.0;
  gW     := 300; //just dammy
  gH     := 150; //just dammy
  gWorking:= False;
end;

procedure TAndroidModule13.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
   gWorking:= False;
   jTimer1.Enabled:= False;
   CanClose:= True;
end;

procedure TAndroidModule13.DataModuleJNIPrompt(Sender: TObject);
begin
  gWorking:= True;
  jTimer1.Enabled:= False;
  ArcBall_Init(gArcBall);
end;

procedure TAndroidModule13.jButton1Click(Sender: TObject);
begin
   jTimer1.Enabled:= not jTimer1.Enabled;
   if jTimer1.Enabled then
   begin
     gWorking:= True;
     jTextView2.Text:= 'Auto Zoom: On'
   end
   else
   begin
     jTextView2.Text:= 'Auto Zomm: Off';
     gWorking:= False;
   end;
end;

procedure TAndroidModule13.jCanvasES2_1GLChange(Sender: TObject; W, H: integer);
begin
   gW:= W;
   gH:= H;
end;

procedure TAndroidModule13.jCanvasES2_1GLCreate(Sender: TObject);
begin
  jCanvasES2_1.Shader_Compile('simon_Vert','simon_Frag');
  jCanvasES2_1.Shader_Link;
  //gWorking := True;
end;

procedure TAndroidModule13.jCanvasES2_1GLDown(Sender: TObject; Touch: TMouch);
begin
  ArcBall_Down(gArcBall, gW, gH, Touch.Pt.X, Touch.Pt.Y);
end;

procedure TAndroidModule13.jCanvasES2_1GLDraw(Sender: TObject);
begin
  DoDraw(gZoom, gW, gH);
end;

procedure TAndroidModule13.jCanvasES2_1GLMove(Sender: TObject; Touch: TMouch);
begin
  gX:= Touch.Pt.x;
  gY:= Touch.Pt.y;
  gZoom:= Touch.Zoom;
  ArcBall_Move(gArcBall,gX,gY);
  jCanvasES2_1.Refresh;
end;

procedure TAndroidModule13.jCanvasES2_1GLUp(Sender: TObject; Touch: TMouch);
begin
  ArcBall_Up(gArcBall);
end;

procedure TAndroidModule13.jTimer1Timer(Sender: TObject);
begin
  gZoom  := gZoom + 0.01;
  if  gZoom > 1.5 then gZoom:= 1.0;
  if gWorking then
  begin
    ArcBall_Move(gArcBall,gX,gY);
    jCanvasES2_1.Refresh;
  end;
end;

end.
