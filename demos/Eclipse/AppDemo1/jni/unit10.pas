{Hint: save all files to location: \jni }
unit unit10;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_GLESv1_Canvas, Laz_And_GLESv1_Canvas_h;
  
type

  { TAndroidModule10 }

  TAndroidModule10 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jCanvasES1_1: jCanvasES1;
      jImageList1: jImageList;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTimer1: jTimer;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer;
        var rstRotate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jCanvasES1_1GLChange(Sender: TObject; W, H: integer);
      procedure jCanvasES1_1GLCreate(Sender: TObject);
      procedure jCanvasES1_1GLDraw(Sender: TObject);
      procedure jCanvasES1_1GLMove(Sender: TObject; Touch: TMouch);
      procedure jCanvasES1_1GLThread(Sender: TObject);
      procedure jTimer1Timer(Sender: TObject);
    private
      {private declarations}
    public
      {public declarations}
      Timer_Cnt     : Integer;
      gAngle  : Single;
      gSpeed  : Single;
      gWork   : Boolean;
      gX      : Single;
      gY      : Single;
      gToggle : Boolean;
      gBusy   : Boolean;
      gH      : integer; //get scrW
      gW      : integer; //get scrH
      Procedure DoDraw(Angle : Single; scrW: integer; scrH: integer);
  end;
  
var
  AndroidModule10: TAndroidModule10;

implementation

{$R *.lfm}

{ TAndroidModule10 }

procedure TAndroidModule10.jTimer1Timer(Sender: TObject);
begin
  Inc(Timer_Cnt);
  gAngle := gAngle + 4;
  If gAngle > 360 then gAngle := 0;
  If gWork then jCanvasES1_1.Refresh;
end;

procedure TAndroidModule10.jButton1Click(Sender: TObject);
begin
   jTimer1.Enabled:= not (jTimer1.Enabled);
   if jTimer1.Enabled then
   begin
     gWork:= True;
     jTextView2.Text:= 'Auto: On'
   end
   else
   begin
     jTextView2.Text:= 'Auto: Off';
     gWork:= False;
   end;
end;
            //this was needed because the fail on the *.lfm parse...
procedure TAndroidModule10.DataModuleCreate(Sender: TObject);
begin
  Self.BackButton:= True;
  Self.BackgroundColor:= colbrBlack;
    //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
end;

procedure TAndroidModule10.DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
begin
   CanClose:= True;
   jTimer1.Enabled:= False;
end;

procedure TAndroidModule10.DataModuleJNIPrompt(Sender: TObject);
begin
  gAngle  := 0.1;
  gSpeed  := 1.0;
  gWork   := False;
  gToggle := False;
  gH:= 150; //just dummy (or not!)
  gW:= 300; //just dummy (or not!)
  Self.Show;
end;

procedure TAndroidModule10.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule10.jButton2Click(Sender: TObject);
begin
  gSpeed := gSpeed + 0.3;
  ShowMessage('Speed ++')
end;

procedure TAndroidModule10.jButton3Click(Sender: TObject);
begin
  jCanvasES1_1.Request_GLThread;
  gToggle := True;
  jCanvasEs1_1.Refresh;
end;
       //you will need handle this event for perfect layout!
procedure TAndroidModule10.jCanvasES1_1GLChange(Sender: TObject; W, H: integer);
begin
   gH:= H;
   gW:= W;
end;

procedure TAndroidModule10.jCanvasES1_1GLCreate(Sender: TObject);
begin
  jCanvasES1_1.Texture_Load_All;
end;

procedure TAndroidModule10.jCanvasES1_1GLMove(Sender: TObject; Touch: TMouch);
begin
  gX:= Touch.Pt.x;
  gY:= Touch.Pt.y;
  jCanvasES1_1.Refresh;
end;

procedure TAndroidModule10.jCanvasES1_1GLThread(Sender: TObject); // un/load texture
begin
  gWork:= False;
  case jCanvasES1_1.Textures[0].Active of
   True  : begin
             jCanvasES1_1.Texture_Unload_All;
           end;
   False : begin
             jCanvasES1_1.Texture_Load_All;
           end;
  end;
  gWork := True;
  jCanvasES1_1.Refresh;
end;

procedure TAndroidModule10.jCanvasES1_1GLDraw(Sender: TObject);
begin
   DoDraw(gAngle*gSpeed, gW, gH);
end;

// Angle 0~360
procedure TAndroidModule10.DoDraw(Angle: Single; scrW: integer; scrH: integer);
Const
   VRXQ1       : array[0..3*4-1] of GLfloat =
                 (    1,    1,   0,
                     -1,    1,   0,
                      1,   -1,   0,
                     -1,   -1,   0);
   TXRQ1       : array[0..2*4-1] of GLfloat =
                 (    1,    1,
                      0,    1,
                      1,    0,
                      0,    0);
   VRXC1       : array[0..4*5-1] of GLfloat =
                 (    1,    1,   1,   1,  // pt1 위
                      1,    1,   1,   1,  // pt5 좌상
                      1,    1,   1,   1,  // pt2 우상
                      1,    1,   1,   1,  // pt4 좌하
                      1,    1,   1,   1); // pt3 우하
   VRXP1       : array[0..3*5-1] of GLfloat =
                 ( 0.00, 0.05,   0,       // pt1 위
                   0.43, 0.36,   0,       // pt5 좌상
                  -0.43, 0.36,   0,       // pt2 우상
                   0.26, 0.86,   0,       // pt4 좌하
                  -0.26, 0.86,   0 );     // pt3 우하
   VRXT1       : array[0..3*3-1] of GLfloat =
                 (-0.39,-0.28,   0,
                   0.00,-0.95,   0,
                   0.39,-0.28,   0);
var
  ZDepth : Single;
  Layer  : Integer;
  i      : integer;
begin
  if Self.FFormState = fsFormClose then Exit;
  gAngle := gAngle + 4;
  if gAngle > 360 then gAngle := 0;

  jCanvasES1_1.Screen_Setup (scrW, scrH, xp2D , cCull_Yes);

  jCanvasES1_1.Screen_Clear(1,1,1,1);
  If gToggle then
  begin
    //
     case jCanvasES1_1.Textures[0].Active of
       True  : begin
                jCanvasES1_1.Texture_Unload_All;
               end;
       False : begin
                jCanvasES1_1.Texture_Load_All;
               end;
     end;
    //
     gToggle := False;
  end;

  ZDepth := 0;
  //-------------------------------------------------------------------------
  // Draw BackGround
  //-------------------------------------------------------------------------
  jCanvasES1_1.Alpha  := 1;
  glBlendFunc      (GL_ONE,GL_ZERO);
  jCanvasES1_1.idModelView;
  jCanvasES1_1.Translate(0,0,ZDepth);

  jCanvasES1_1.DrawArray(@VRXQ1,nil,@TXRQ1,@jCanvasES1_1.Textures[0],4);

  // Init Stencil Mode ------------------------------------------------------
  jCanvasES1_1.SetMask(0,mmOpen);
  //-------------------------------------------------------------------------
  // Obj 1.  Left Rotated Obj.
  //-------------------------------------------------------------------------
  Layer := 1;
  // Mask -------------------------------------------------------------------
  jCanvasES1_1.SetMask (Layer,mmMask);

  jCanvasES1_1.Alpha  := 1;
  jCanvasES1_1.idModelView;
  jCanvasES1_1.Translate(0,0,ZDepth);
  jCanvasES1_1.DrawArray(@VRXP1,nil,@VRXC1,nil,5);

  // Mask Background --------------------------------------------------------
  jCanvasES1_1.SetMask (Layer,mmDraw);

  jCanvasES1_1.Alpha  := 1;
  jCanvasES1_1.idModelView;
  jCanvasES1_1.DrawArray(@VRXQ1,nil,@TXRQ1,@jCanvasES1_1.Textures[1],4);

  // Image on Mask Layer ----------------------------------------------------
  jCanvasES1_1.Alpha  := Angle/360;
  glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
  jCanvasES1_1.idModelView;
  jCanvasES1_1.Translate(0,0.5,ZDepth);
  jCanvasES1_1.Rotate   (Angle,0,0,1);
  jCanvasES1_1.Scale    (0.2+Angle/360,0.2+Angle/360,1);
  jCanvasES1_1.DrawArray(@VRXQ1,nil,@TXRQ1,@jCanvasES1_1.Textures[2],4);

  //-------------------------------------------------------------------------
  // Obj 2.  Right Rotated Obj.
  //-------------------------------------------------------------------------
  glBlendFunc      (GL_ONE,GL_ZERO);
  Layer := 2;
  //  Mask ------------------------------------------------------------------
  jCanvasES1_1.SetMask (Layer,mmMask);

  jCanvasES1_1.Alpha  := 1;
  jCanvasES1_1.idModelView;
  jCanvasES1_1.Translate(0,0,ZDepth);
  jCanvasES1_1.DrawArray(@VRXT1,@VRXC1,nil,nil,3);

  // Mask Background --------------------------------------------------------
  jCanvasES1_1.SetMask (Layer,mmDraw);

  jCanvasES1_1.Alpha  := 1;
  jCanvasES1_1.idModelView;
  jCanvasES1_1.Translate(0,0,ZDepth);
  jCanvasES1_1.Scale    (1,1,1);
  jCanvasES1_1.DrawArray(@VRXQ1,nil,@TXRQ1,@jCanvasES1_1.Textures[1],4);

  // Image on Mask Layer ----------------------------------------------------
  jCanvasES1_1.Alpha  := 1;
  glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
  jCanvasES1_1.idModelView;
  jCanvasES1_1.Translate(0,-0.5,ZDepth);
  jCanvasES1_1.Rotate   (-Angle,0,0,1);
  jCanvasES1_1.Scale    (0.2+Angle/360,0.2+Angle/360,1);
  jCanvasES1_1.DrawArray(@VRXQ1,nil,@TXRQ1,@jCanvasES1_1.Textures[3],4);

  jCanvasES1_1.SetMask  (0,mmClose);

  //-------------------------------------------------------------------------
  // Obj 3.  Floating Obj
  //-------------------------------------------------------------------------
  jCanvasES1_1.Alpha  := 1;
  jCanvasES1_1.idModelView;
  jCanvasES1_1.Translate(0, 0,-1); //ZDepth);
  jCanvasES1_1.Rotate   (Angle,0,0,1);
  jCanvasES1_1.Scale    (0.3,0.3,0.3);
  jCanvasES1_1.DrawArray(@VRXQ1,nil,@TXRQ1,@jCanvasES1_1.Textures[4],4);
  jCanvasES1_1.Update;
end;

end.
