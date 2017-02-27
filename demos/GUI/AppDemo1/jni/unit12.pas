{Hint: save all files to location: \jni }
unit unit12;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_GLESv1_Canvas, Laz_And_GLESv1_Canvas_h, Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule12 }

  TAndroidModule12 = class(jForm)
      jButton1: jButton;
      jCanvasES1_1: jCanvasES1;
      jImageList1: jImageList;
      jTextView1: jTextView;
      jTextView2: jTextView;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jCanvasES1_1GLChange(Sender: TObject; W, H: integer);
      procedure jCanvasES1_1GLCreate(Sender: TObject);
      procedure jCanvasES1_1GLDown(Sender: TObject; Touch: TMouch);
      procedure jCanvasES1_1GLDraw(Sender: TObject);
      procedure jCanvasES1_1GLMove(Sender: TObject; Touch: TMouch);
      procedure jCanvasES1_1GLUp(Sender: TObject; Touch: TMouch);
    private
      {private declarations}
    public
      {public declarations}
      gX,gY,gZ   : Single;
      gZoom      : Single;
      gArcBall   : TglArcBall;
      gTextureID : GLuint;
      gW         : integer;
      gH         : integer;

      procedure DoDraw(TextureID: integer; scrW: integer; scrH: integer);
  end;
  
var
  AndroidModule12: TAndroidModule12;

implementation
  
{$R *.lfm}
  

{ TAndroidModule12 }

procedure TAndroidModule12.DoDraw(TextureID: integer; scrW: integer; scrH: integer);
const
  _cVertex: array[0..5, 0..6 * 3 - 1] of single =
    ((0.5000,  0.5000, -0.5000, -0.5000,  0.5000,  0.5000,  0.5000,  0.5000,  0.5000,
      0.5000,  0.5000, -0.5000, -0.5000,  0.5000, -0.5000, -0.5000,  0.5000,  0.5000),
     (0.5000,  0.5000,  0.5000, -0.5000, -0.5000,  0.5000,  0.5000, -0.5000,  0.5000,
     -0.5000, -0.5000,  0.5000,  0.5000,  0.5000,  0.5000, -0.5000,  0.5000,  0.5000),
    (-0.5000, -0.5000, -0.5000, -0.5000, -0.5000,  0.5000, -0.5000,  0.5000,  0.5000,
     -0.5000, -0.5000, -0.5000, -0.5000,  0.5000,  0.5000, -0.5000,  0.5000, -0.5000),
     (0.5000,  0.5000, -0.5000,  0.5000, -0.5000, -0.5000, -0.5000,  0.5000, -0.5000,
     -0.5000,  0.5000, -0.5000,  0.5000, -0.5000, -0.5000, -0.5000, -0.5000, -0.5000),
     (0.5000,  0.5000, -0.5000,  0.5000, -0.5000,  0.5000,  0.5000, -0.5000, -0.5000,
      0.5000,  0.5000, -0.5000,  0.5000,  0.5000,  0.5000,  0.5000, -0.5000,  0.5000),
     (0.5000, -0.5000,  0.5000, -0.5000, -0.5000,  0.5000, -0.5000, -0.5000, -0.5000,
      0.5000, -0.5000,  0.5000, -0.5000, -0.5000, -0.5000,  0.5000, -0.5000, -0.5000));
  _cNormal: array[0..5, 0..6 * 3 - 1] of single =
    ((0.0000,  1.0000,  0.0000,  0.0000,  1.0000,  0.0000,  0.0000,  1.0000,  0.0000,
      0.0000,  1.0000,  0.0000,  0.0000,  1.0000,  0.0000,  0.0000,  1.0000,  0.0000),
     (0.0000,  0.0000,  1.0000,  0.0000,  0.0000,  1.0000,  0.0000,  0.0000,  1.0000,
      0.0000,  0.0000,  1.0000,  0.0000,  0.0000,  1.0000,  0.0000,  0.0000,  1.0000),
    (-1.0000,  0.0000,  0.0000, -1.0000,  0.0000,  0.0000, -1.0000,  0.0000,  0.0000,
     -1.0000,  0.0000,  0.0000, -1.0000,  0.0000,  0.0000, -1.0000,  0.0000,  0.0000),
     (0.0000,  0.0000, -1.0000,  0.0000,  0.0000, -1.0000,  0.0000,  0.0000, -1.0000,
      0.0000,  0.0000, -1.0000,  0.0000,  0.0000, -1.0000,  0.0000,  0.0000, -1.0000),
     (1.0000,  0.0000,  0.0000,  1.0000,  0.0000,  0.0000,  1.0000,  0.0000,  0.0000,
      1.0000,  0.0000,  0.0000,  1.0000,  0.0000,  0.0000,  1.0000,  0.0000,  0.0000),
     (0.0000, -1.0000,  0.0000,  0.0000, -1.0000,  0.0000,  0.0000, -1.0000,  0.0000,
      0.0000, -1.0000,  0.0000,  0.0000, -1.0000,  0.0000,  0.0000, -1.0000,  0.0000));
  _cTexture: array[0..5, 0..6 * 2 - 1] of single =
    ((0.0000,  0.0000,  0.0000,  0.0000, 0.0000, 0.0000,   // Texture Off
      0.0000,  0.0000,  0.0000,  0.0000, 0.0000, 0.0000),
     (1.0000,  1.0000,  0.0000,  0.0000, 1.0000, 0.0000,   // Texture ON
      0.0000,  0.0000,  1.0000,  1.0000, 0.0000, 1.0000),
     (0.0000,  0.0000,  0.0000,  0.0000, 0.0000, 0.0000,   // Texture Off
      0.0000,  0.0000,  0.0000,  0.0000, 0.0000, 0.0000),
     (0.0000,  0.0000,  0.0000,  0.0000, 0.0000, 0.0000,   // Texture Off
      0.0000,  0.0000,  0.0000,  0.0000, 0.0000, 0.0000),
     (0.0000,  0.0000,  0.0000,  0.0000, 0.0000, 0.0000,   // Texture Off
      0.0000,  0.0000,  0.0000,  0.0000, 0.0000, 0.0000),
     (0.0000,  0.0000,  0.0000,  0.0000, 0.0000, 0.0000,   // Texture Off
      0.0000,  0.0000,  0.0000,  0.0000, 0.0000, 0.0000));
  Kads: array[0..5, 0..3 * 3 - 1] of single =
    //Ka                     Kd                    Ks
    ((0.9000, 0.9000, 0.9000, 1.0000, 0.8471, 0.3922, 0.3300, 0.3300, 0.3300),
     (0.9000, 0.9000, 0.9000, 0.5412, 0.4588, 0.4039, 0.3300, 0.3300, 0.3300),
     (0.9000, 0.9000, 0.9000, 0.4941, 1.0000, 0.0000, 0.3300, 0.3300, 0.3300),
     (0.9000, 0.9000, 0.9000, 0.6392, 0.4745, 0.8000, 0.3300, 0.3300, 0.3300),
     (0.9000, 0.9000, 0.9000, 1.0000, 0.3922, 0.1922, 0.3300, 0.3300, 0.3300),
     (0.9000, 0.9000, 0.9000, 1.0000, 0.1922, 0.1922, 0.3300, 0.3300, 0.3300));

  zNear       =    0.1;
  zFar        = 1000.0;
  fieldOfView =   60.0;

 var
  i       : integer;
  W1, H1: integer;
begin
  //dbg('D1');
  // Initialization

  W1:= scrW;
  H1:= scrH;

  glPushMatrix();
  // Drawing ------------------------------------------------------------------
  glShadeModel(GL_SMOOTH);              // Enables Smooth Color Shading
  glEnable(GL_DEPTH_TEST);          // Enable Depth Buffer
  glEnable(GL_CULL_FACE);
  glEnable(GL_Normalize);
  // Turn on OpenGL lighting
  _glLighting(True);
  //dbg('D2');

  // ViewPort -----------------------------------------------------------------
  glViewport(0, 0, W1, H1);
  glClearColor(0.3, 0.5, 0.9, 0);        // BackGround Color = Blue
  //dbg('D3');

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  //dbg('D4b'+ IntToStr(Round(W1)) + ','+ IntToStr(Round(H1)) );
  _gluPerspective(60, (W1 / H1), 0.1, 1000);
  //dbg('D4');

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  // Drawing ------------------------------------------------------------------
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_NORMAL_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  //dbg('D5');

  // Drawing
  glClear (GL_COLOR_BUFFER_BIT or
           GL_DEPTH_BUFFER_BIT or
           GL_STENCIL_BUFFER_BIT);

  glLoadIdentity();
  glTranslatef(0, 0, -1);
  //dbg('D6');

  glRotatef(gArcBall.aRot.X, 1, 0, 0); // X
  glRotatef(gArcBall.aRot.Y, 0, 1, 0); // X
  glRotatef(gArcBall.aRot.Z, 0, 0, 1); // X

  glScalef (0.5*gZoom,0.5*gZoom,0.5*gZoom);
  //glScalef (0.5, 0.5, 0.5);
  glColor4f(0.8, 0.8, 0.8, 0);
  //dbg('D7');

  For i := 0 to 5 do
   Begin
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT , @Kads[i, 0]);
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE , @Kads[i, 3]);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, @Kads[i, 6]);
    // Texture On,Off
    Case i = 1 of
     True  : begin
              glEnable(GL_Texture_2D);
              glBindTexture(GL_Texture_2D, TextureID);
              glTexCoordPointer (2,GL_FLOAT, 0, @_cTexture[i, 0]);
             end;
     False : glDisable(GL_Texture_2D);
    end;

    glVertexPointer   (3,GL_FLOAT, 0, @_cVertex [i, 0]);
    glNormalPointer   (  GL_FLOAT, 0, @_cNormal [i, 0]);
    glDrawArrays      (GL_TRIANGLES, 0, 6);
   End;

 // dbg('D8');
  glDisable(GL_Smooth    );
  glDisable(GL_Depth_Test);
  glDisable(GL_Cull_Face );
  glDisable(GL_Normalize );
  //
 // dbg('D9');
  glDisableClientState(GL_VERTEX_ARRAY       );
  glDisableClientState(GL_NORMAL_ARRAY       );
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  _glLighting(False);

 // dbg('D10');
  glPopMatrix();

end;

procedure TAndroidModule12.DataModuleCreate(Sender: TObject);
begin
  gZoom := 1.0;
  gTextureID:= 0;   //default picture ID
end;

procedure TAndroidModule12.DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:= True;
end;

procedure TAndroidModule12.DataModuleJNIPrompt(Sender: TObject);
begin
  _glArcBall_Init(gArcBall);
end;

procedure TAndroidModule12.jButton1Click(Sender: TObject);
begin
  case gTextureID = jCanvasES1_1.Textures[0].ID of
     True  : gTextureID := jCanvasES1_1.Textures[1].ID;
     False : gTextureID := jCanvasES1_1.Textures[0].ID;
  end;
  jCanvasES1_1.Refresh;
end;

procedure TAndroidModule12.jCanvasES1_1GLChange(Sender: TObject; W, H: integer);
begin
  gW:= W;
  gH:= H;
end;

procedure TAndroidModule12.jCanvasES1_1GLCreate(Sender: TObject);
begin
  jCanvasES1_1.Texture_Load_All;
  gTextureID:= jCanvasES1_1.Textures[0].ID;
end;

procedure TAndroidModule12.jCanvasES1_1GLDown(Sender: TObject; Touch: TMouch);
begin
  _glArcBall_Down(gArcBall, gW, gH, Touch.Pt.X, Touch.Pt.Y);
end;

procedure TAndroidModule12.jCanvasES1_1GLDraw(Sender: TObject);
begin
  DoDraw(gTextureID, gW, gH);
end;

procedure TAndroidModule12.jCanvasES1_1GLMove(Sender: TObject; Touch: TMouch);
begin
  gX := Touch.Pt.x;
  gY := Touch.Pt.y;
  gZoom:= Touch.Zoom;
  _glArcBall_Move(gArcBall,gX,gY);
  jCanvasES1_1.Refresh;
end;

procedure TAndroidModule12.jCanvasES1_1GLUp(Sender: TObject; Touch: TMouch);
begin
  _glArcBall_Up(gArcBall);
end;

end.
