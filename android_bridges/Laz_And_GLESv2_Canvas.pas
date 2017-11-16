//
// OpenGL ES v2.0 Canvas for Pascal
//
//   Compiler
//   ---------------------------------------------------------------------------
//                   Free Pascal Compiler FPC 2.7.1
//                   Delphi 7~XE5
//
//   Developer
//   ---------------------------------------------------------------------------
//                   Simon,Choi / Choi,Won-sik , ????
//                           simonsayz@naver.com
//                           http://blog.naver.com/simonsayz
//
//   History
//   ---------------------------------------------------------------------------
//                   2013.03.03 added GLSurfaceView
//                   2013.08.27 Restructuring (Iteration #01) -----------
//                   2013.08.28 added xg class (cross gl)
//                   2013.08.29 added PC Emulator
//                   2013.08.30 added CanvasV1,V2
//                   2013.09.02 added ArcBall
//                   2013.09.07 renaming API
//
//   Known Bugs
//   ---------------------------------------------------------------------------
//                   2013.08.30 Crash when remove program,texture
//
//   Related Source
//   ---------------------------------------------------------------------------
//    PC/Emulator  : VCL_CanvasES1.pas
//                   VCL_CanvasES2.pas
//    Android      : And_GLESv1_Canvas.pas
//                   And_GLESv2_Canvas.pas
//    iOS          : iOS_Library_GLCanvas.pas
//
//   Reference Sites
//   ---------------------------------------------------------------------------
//    Quick Ref    : http://www.khronos.org/opengles/sdk/docs/reference_cards/OpenGL-ES-2_0-Reference-card.pdf
//    Basic        : https://wiki.engr.illinois.edu/download/attachments/98402319/2.pdf?version=2&modificationDate=1296076618000
//                   http://www.gisdeveloper.co.kr/category/?????/OpenGL
//    Alpha        : http://stackoverflow.com/questions/1572175/how-to-programmatically-alpha-fade-a-textured-object-in-opengl-es-1-1-iphone
//    Matrix       : http://www.songho.ca/opengl/gl_matrix.html
//                   http://developer.android.com/reference/android/opengl/Matrix.html
//    NPOT         : http://sadiles.blog.me/10085169403
//                   Texture.setEnforcePotImages(false);
//    Rotate       : http://www.learnopengles.com/rotating-an-object-with-touch-events/
//                   http://www.opengl.org/discussion_boards/showthread.php/171651-Rotation-Matrix
//                   http://en.wikibooks.org/wiki/OpenGL_Programming/Modern_OpenGL_Tutorial_Arcball
//                   http://braintrekking.wordpress.com/tag/arcball/
//                   http://www.ncbi.nlm.nih.gov/IEB/ToolBox/CPP_DOC/lxr/source/src/gui/opengl/glarcball.cpp#L146
//    Mesh         : http://en.wikipedia.org/wiki/Polygon_triangulation
//                   http://stackoverflow.com/questions/5915753/generate-a-plane-with-triangle-strips
//                   http://stackoverflow.com/questions/8980379/polygon-triangulation-into-triangle-strips-for-opengl-es
//    Optimization : http://www.geeks3d.com/20111028/how-to-compute-the-position-in-a-glsl-vertex-shader-opengl-matrix-gpu-shaderanalyzer-part-2/
//    3D Engine    : http://gfx.sio2interactive.com/
//    Book         : OpenGL ES 2 for Android / Kevin Brothaler
//    GPUImage     : iOS     :  https://github.com/BradLarson/GPUImage
//                   Android :  https://github.com/CyberAgent/android-gpuimage
//    Filter       : http://littlecheesecake.me/blog/13804556/instagram-filter-opengl
//    Circle       : http://www.geeks3d.com/20130705/shader-library-circle-disc-fake-sphere-in-glsl-opengl-glslhacker/
//    Text         : http://stackoverflow.com/questions/15370748/displaying-text-like-score-which-changes-on-each-frame
//    Picking      : http://blog.naver.com/PostView.nhn?blogId=jadefan&logNo=70088416075
//    Plane        : http://stackoverflow.com/questions/5915753/generate-a-plane-with-triangle-strips
//
unit Laz_And_GLESv2_Canvas; {start: 2013-10-26: the simonsayz's "And_GLESv2_Canvas.pas" modified by jmpessoa}
                            {ver0.2_from_0.22 * 11-october-2013}

{$mode delphi}

interface

uses ctypes,SysUtils,Classes,Math,
     And_jni,And_jni_Bridge, Laz_And_Controls, AndroidWidget,
     And_lib_Image, Laz_And_GLESv2_Canvas_h;

//-----------------------------------------------------------------------------
//
//  OpenGL Helper & Basic Math
//
//  Prefix xg : Cross platform GL
//
//-----------------------------------------------------------------------------

Const
 _cMaxPtCnt       =     20;
 _cAlpha_MaskOn   =   True;
 _cAlpha_MaskOff  =  False;
 _cTile_On        =   True;
 _cTile_Off       =  False;

Type
 TM4x4         = Array[0..3,0..3] of Single;
 TRGBA         = Record
                  R,G,B,A : Single;
                 End;
 TXY           = Record
                  X : Single;
                  Y : Single;
                 End;
 TXYZ          = Record
                  X : Single;
                  Y : Single;
                  Z : Single;
                 End;
 TXYZW         = record
                  X : Single;
                  Y : Single;
                  Z : Single;
                  W : Single;
                 end;
 TXY4CW        = Array[0..3] of TXY; // CW (Clock Wise )
 TXYs          = Record
                  Cnt      : Integer;
                  Pt       : Array[0.._cMaxPtCnt] of TXY;
                 end;
 TXYZs         = Record
                  Cnt      : Integer;
                  Pt       : Array[0.._cMaxPtCnt] of TXY;
                 end;
 TxyTriangle   = Array[0..2] of TXY;
 TxyzTriangle  = Array[0..2] of TXYZ;
 TrgbaTriangle = Array[0..2] of TRGBA;
 TxyTriangles  = Record
                  Cnt      : Integer;
                  Tri      : Array[0.._cMaxPtCnt*2] of TxyTriangle;
                 End;
 TxyzTriangles = Record
                  Cnt      : Integer;
                  Tri      : Array[0.._cMaxPtCnt*2] of TxyzTriangle;
                  Color    : Array[0.._cMaxPtCnt*2] of TrgbaTriangle;
                 end;
 TxgArcBall    = Record
                  Width,Height   : Single;
                  v3sav          : TXYZ;
                  mRot,  mRotSav : TM4x4;
                  qRot,  qRotSav : TXYZW;
                  aRot           : TXYZ;
                  Downed         : Boolean;
                 End;

Const
 cID4x4 : TM4x4 = ( (1,0,0,0),
                    (0,1,0,0),
                    (0,0,1,0),
                    (0,0,0,1) );

// Base Utility
Function  _RGBA           ( R,G,B,A : Single ) : TRGBA;
Function  _XY             ( X,Y     : Single ) : TXY;
Function  _XYZ            ( X,Y,Z   : Single ) : TXYZ;
Function  _XY_Z           ( const XY : TXY; Z : Single ) : TXYZ;
Function  _xy4CW          ( x1,y1, x2,y2, x3,y3, x4,y4 : Single ) : Txy4CW;
Procedure _XYs            (Var XYs : TXYs;x1,y1, x2,y2, x3,y3, x4,y4 : Single );
Function  _mM4x4          (const A,B : TM4x4 ) : TM4x4;
Function  _tM4x4          (const M   : TM4x4 ) : TM4x4;
Function  xyTriangulation (XYs : TXYs; var output: TxyTriangles): Boolean;
//
Procedure ArcBall_Init    (var ArcBall : TxgArcBall);
Procedure ArcBall_Down    (var ArcBall : TxgArcBall; Width,Height,X,Y : Single);
Procedure ArcBall_Move    (var ArcBall : TxgArcBall; X,Y : Single);
Procedure ArcBall_Up      (var ArcBall : TxgArcBall);

// OpenGL ES v2.0 Helper Function
Procedure _glFrustum      (Var Mat : TM4x4; l,r,b,t,n,f : Single);
Procedure _glOrtho        (Var Mat : TM4x4; left,right,bottom,top,znear,zfar : Single);
Procedure _glPerspective  (Var Mat : TM4x4; fovy,aspect,zNear,zFar : Single);
Procedure _glTranslatef   (Var Mat : TM4x4; x,y,z : Single );
Procedure _glScalef       (Var Mat : TM4x4; x,y,z : Single );
Procedure _glRotatef      (Var Mat : TM4x4; angle,x,y,z : Single);
//
Function  _glTexture_Load_wPas (ImgName   : String; Var Img : GLuint;
                                AlphaMask : Boolean = True;
                                TileMode  : Boolean = False) : Boolean;
{
Function  _glTexture_Load_wJava(env:PJNIEnv;this:jobject;
                                ImgName   : String; Var Img : GLuint;
                                AlphaMask : Boolean = True;
                                TileMode  : Boolean = False) : Boolean;
 }
function _glTexture_Load_wJava(env: PJNIEnv; _jcanvases2: JObject;
                               _fullFilename: string;
                               var Img : GLuint;
                               AlphaMask: Boolean = True;
                               TileMode : Boolean = False): boolean;

Function  _glTexture_Free (Var Img : GLuint) : Boolean;

//------------------------------------------------------------------------------
//
//  GLCanvas for Cross platform
//
//------------------------------------------------------------------------------

Const
 cTextureMax     = 100;
 cCull_YES       = True;
 cCull_NO        = False;
 cDepth_0        = 0;
 cAlpha_0        = 0;
 cAlpha_05       = 0.5;
 cAlpha_1        = 1;
 cCircle         : Array[0..72*2-1] of Single =
                   (0.00, 1.00,   0.09, 1.00,   0.17, 0.98,   0.26, 0.97,   0.34, 0.94,   0.42, 0.91,
                    0.50, 0.87,   0.57, 0.82,   0.64, 0.77,   0.71, 0.71,   0.77, 0.64,   0.82, 0.57,
                    0.87, 0.50,   0.91, 0.42,   0.94, 0.34,   0.97, 0.26,   0.98, 0.17,   1.00, 0.09,
                    1.00, 0.00,   1.00,-0.09,   0.98,-0.17,   0.97,-0.26,   0.94,-0.34,   0.91,-0.42,
                    0.87,-0.50,   0.82,-0.57,   0.77,-0.64,   0.71,-0.71,   0.64,-0.77,   0.57,-0.82,
                    0.50,-0.87,   0.42,-0.91,   0.34,-0.94,   0.26,-0.97,   0.17,-0.98,   0.09,-1.00,
                    0.00,-1.00,  -0.09,-1.00,  -0.17,-0.98,  -0.26,-0.97,  -0.34,-0.94,  -0.42,-0.91,
                   -0.50,-0.87,  -0.57,-0.82,  -0.64,-0.77,  -0.71,-0.71,  -0.77,-0.64,  -0.82,-0.57,
                   -0.87,-0.50,  -0.91,-0.42,  -0.94,-0.34,  -0.97,-0.26,  -0.98,-0.17,  -1.00,-0.09,
                   -1.00, 0.00,  -1.00, 0.09,  -0.98, 0.17,  -0.97, 0.26,  -0.94, 0.34,  -0.91, 0.42,
                   -0.87, 0.50,  -0.82, 0.57,  -0.77, 0.64,  -0.71, 0.71,  -0.64, 0.77,  -0.57, 0.82,
                   -0.50, 0.87,  -0.42, 0.91,  -0.34, 0.94,  -0.26, 0.97,  -0.17, 0.98,  -0.09, 1.00);

Type
 //
 TxgShaderType = (xsVert,   // Vertex   Shader
                  xsFrag);  // Fragment Shader
 //
 TxgMaskMode   = (mmOpen,
                  mmMask,
                  mmDraw,
                  mmClose);
 //
 TxgElement    = Record
                  Active    : Boolean;
                  ID        : GLuint;
                 End;
 PxgElement    = ^TxgElement;
 //
 TxgProg       = Record
                  Active    : Boolean;    // Program Used ?
                  ID        : GLuint;     // Program ID
                  Vertex    : TxgElement; // Vertex Shader ID
                  Fragment  : TxgElement; // Fragment Shader ID
                 End;
 // Shader Interface Variable
 TxgShader     = (Shader_Color,
                  Shader_Texture,
                  Shader_Sepia,
                  Shader_Gray);
 TxgShaderVars = Record
                  hShader   : GLuint; // Shader Type
                  hMVP      : GLuint; // Model-View-Projection
                  hVertex   : GLuint; // Vertex  XYZ Array
                  hColor    : GLuint; // RGBA
                  hTexture  : GLuint; // Texture XY Array
                  hAlpha    : GLuint; // Alpha
                 End;
 //
 TxgProjection = (xp2D,xp3D);
 TxgTextures   = Array[0..cTextureMax-1] of TxgElement;
 //

 // ------------------------------------------------------------------
 jCanvasES2 = class(jGLViewEvent)
 private
   FAutoRefresh: boolean;  // 60Frame/s Refresh

   FImageLIst  : jImageList;    //by jmpessoa
   //
   FScript     : TStrings;      // Shader Script
   FProg       : TxgProg;       // Shader Program
   FShaderVars : TxgShaderVars; // Shader Interface Variable
   FShader     : TxgShader;     //
   FAlpha      : Single;
   FMVP        : TM4x4;         // ModelView , Projection

   procedure SetImages(Value: jImageList);   //by jmpessoa

   Procedure SetVisible    (Value : Boolean);
   function GetVisible: Boolean;
   Procedure SetAutoRefresh(Value : boolean);

   Procedure Texture_Load  ( var Texture : TxgElement; filename : String; TileMode : Boolean = False);
   Procedure Texture_UnLoad( var Texture : TxgElement);
   procedure UpdateLParamHeight;
   procedure UpdateLParamWidth;

 protected
   Function  Shader_Build  ( sType : TxgShaderType; Name : String ) : GLuint;
   //
   Procedure SetShader  ( value : TxgShader );
   Procedure SetAlpha   ( alpha : Single    );
   Procedure SetVertex  ( ptr : Pointer     );
   Procedure SetColor   ( ptr : Pointer     );
   Procedure SetTexture ( ptr : Pointer     );
   //
   Procedure BindTexture( const Texture : TxgElement );
   procedure Notification(AComponent: TComponent; Operation: TOperation); override;

 public
   Textures : TxgTextures; // Texture
   MVP      : TM4x4;       // MVP Matrix
   TexturesCount: integer; //by jmpessoa

   Constructor Create(AOwner: TComponent); override;
   Destructor  Destroy; override;
   procedure Init(refApp: jApp); override;
   Procedure UpdateLayout; override;

   function GetWidth: integer;  override;
   function GetHeight: integer;  override;
   //
   Function  IntToShader   ( shader : integer ) : TxgShader;
   //
   Function  Shader_Compile( Vertex,Fragment : String ) : Boolean;
   Function  Shader_Link : Boolean;
   //
   Procedure Screen_Setup(w,h        : Integer;
                          Projection : TxgProjection = xp2D;
                          CullFace   : Boolean = True);

   Procedure Screen_Clear(r,g,b,a : Single);
   //
   Procedure SetMVP     (const M4x4 : TM4x4);
   Procedure Translate  (const X,Y,Z : Single);
   Procedure Rotate     (const Angle,X,Y,Z : Single);
   Procedure Scale      (const X,Y,Z : single);
   //
   Procedure SetMask    (Layer : Integer; MaskMode : TxgMaskMode );
   //
   Procedure DrawArray  ( aVertex    : Pointer;
                          aColor     : Pointer;
                          aTexture   : Pointer;
                          tTexture   : pxgElement;
                          Count      : Integer);
   //
   Procedure DrawLine      (P1,P2 : TXYZ; Color : TRGBA;
                            Width : Single = 0.3; AA : Boolean = True);
   Procedure DrawRect      (const Pt4 : Txy4CW; Z : Single; Color : TRGBA; Width : Single = 0.3);
   procedure DrawRectFill  (const Pt4 : Txy4CW; Z : Single; Color : TRGBA; LColor : TRGBA; LWidth : Single = 0.3);
   Procedure DrawPoly      (const Pts : TXYs  ; Z : Single; Color : TRGBA; Width : Single = 0.3);
   Procedure DrawPolyFill  (const Pts : TXYs  ; Z : Single; Color : TRGBA; LColor : TRGBA; LWidth : Single = 0.3);
   Procedure DrawMask      (const Pts : TXYs  ; Z : Single);
   Procedure DrawTexture   (const Texture : TxgElement; const Pt4 : Txy4CW; Z : Single; Alpha : Single; Effect : TxgShader = Shader_Texture);
   Procedure DrawTile      (const Texture : TxgElement; const Pt4 : Txy4CW; N ,Z : Single; Alpha : Single; Effect : TxgShader = Shader_Texture);
   Procedure DrawCircle    (XY : TXY; Z, L : Single; Color : TRGBA; Width : Single = 0.3);
   //
   Procedure Texture_Load_All(TileMode : Boolean = False);
   Procedure Texture_UnLoad_All;
   Procedure Texture_Clear;
   //
   Procedure Request_GLThread;
   //
   Procedure Update;
   Procedure Refresh;

   // Property
   Property Shader      : TxgShader     read FShader      write SetShader;
   Property Alpha       : Single        read FAlpha       write SetAlpha;
 published
    property AutoRefresh : boolean       read FAutoRefresh write SetAutoRefresh;
    property Visible     : Boolean       read GetVisible     write SetVisible;
    property Images   : jImageList read FImageList write SetImages;   //by jmpessoa
 end;

implementation

const
  CrLf = #13#10;

//-----------------------------------------------------------------------------
//
// OpenGL ES v2.0 Utility Function
//
//-----------------------------------------------------------------------------

//
Function _RGBA ( R,G,B,A : Single  ) : TRGBA;
 begin
  Result.R := R;
  Result.G := G;
  Result.B := B;
  Result.A := A;
 end;

//
Function  _XY           ( X,Y     : Single ) : TXY;
 begin
  Result.X := X;
  Result.Y := Y;
 end;

//
Function  _XYZ          ( X,Y,Z   : Single ) : TXYZ;
 begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
 end;

//
Function  _XY_Z         ( const XY : TXY; Z : Single ) : TXYZ;
 begin
  Result.X := XY.X;
  Result.Y := XY.Y;
  Result.Z := Z;
 end;

//
Function  _xy4CW        ( x1,y1, x2,y2, x3,y3, x4,y4 : Single ) : Txy4CW;
 begin
  Result[0].X := x1;   Result[0].Y := y1;
  Result[1].X := x2;   Result[1].Y := y2;
  Result[2].X := x3;   Result[2].Y := y3;
  Result[3].X := x4;   Result[3].Y := y4;
 end;

//
Procedure _XYs         ( Var XYs : TXYs;x1,y1, x2,y2, x3,y3, x4,y4 : Single );
 begin
  XYs.Cnt := 4;
  XYs.Pt[0] := _XY(x1,y1);
  XYs.Pt[1] := _XY(x2,y2);
  XYs.Pt[2] := _XY(x3,y3);
  XYs.Pt[3] := _XY(x4,y4);
 end;

//
Function  _mM4x4( const A,B : TM4x4 ) : TM4x4;
 Var
  i,j : Integer;
 begin
  For i := 0 to 3 do
   For j := 0 to 3 do
    Result[i,j] := A[i,0]*B[0,j]+ A[i,1]*B[1,j]+ A[i,2]*B[2,j]+  A[i,3]*B[3,j];
 end;

// Transpose
Function  _tM4x4 (const M : TM4x4) : TM4x4;
 Var
  i,j : Integer;
 begin
  For i := 0 to 2 do
   For j := 0 to 2 do
    Result[i,j] := M[j,i];
 end;

//-----------------------------------------------------------------------------
// Triangulation
//  Ref. http://www.flipcode.com/archives/Efficient_Polygon_Triangulation.shtml
//       http://code.google.com/p/box2d-delphi/source/browse/trunk/Physics2D/
//-----------------------------------------------------------------------------

Procedure xyTriangleCCW(var Tri : TxyTriangle);
 var
  dx1,dx2 : Single;
  dy1,dy2 : Single;
  XYsav   : Txy;
 begin
  dx1 := Tri[1].x - Tri[0].x;
  dx2 := Tri[2].x - Tri[0].x;
  dy1 := Tri[1].y - Tri[0].y;
  dy2 := Tri[2].y - Tri[0].y;
  // CW -> CCW
  If (dx1*dy2)-(dx2*dy1) < 0 then
   begin
    XYsav  := Tri[0];
    Tri[0] := Tri[1];
    Tri[1] := XYsav;
   end;
 end;

Function IsInside(const tri: TxyTriangle; x,y : Single): Boolean;
 Var
  vx0, vx1, vx2: Single;
  vy0, vy1, vy2: Single;
  dot00, dot01, dot02, dot11, dot12: Single;
  invDenom: Single;
  u, v: Single;
 begin
  if ((x < tri[0].x) and (x < tri[1].x) and (x < tri[2].x)) or
     ((x > tri[0].x) and (x > tri[1].x) and (x > tri[2].x)) or
     ((y < tri[0].y) and (y < tri[1].y) and (y < tri[2].y)) or
     ((y > tri[0].y) and (y > tri[1].y) and (y > tri[2].y)) then
   begin
    Result := False;
    Exit;
   end;

  vx2 := x - tri[0].x;
  vy2 := y - tri[0].y;
  vx1 := tri[1].x - tri[0].x;
  vy1 := tri[1].y - tri[0].y;
  vx0 := tri[2].x - tri[0].x;
  vy0 := tri[2].y - tri[0].y;
  dot00 := vx0 * vx0 + vy0 * vy0;
  dot01 := vx0 * vx1 + vy0 * vy1;
  dot02 := vx0 * vx2 + vy0 * vy2;
  dot11 := vx1 * vx1 + vy1 * vy1;
  dot12 := vx1 * vx2 + vy1 * vy2;
  if Abs(dot00 * dot11 - dot01 * dot01) < 0.001 then
   invDenom := 0.00
  else
   invDenom := 1.0 / (dot00 * dot11 - dot01 * dot01);
  u := (dot11 * dot02 - dot01 * dot12) * invDenom;
  v := (dot00 * dot12 - dot01 * dot02) * invDenom;
  Result := ((u > 0) and (v > 0) and (u + v < 1));
 end;

//
Function IsEar(i: Integer; const XYs : TXYs): Boolean;
 Var
  dx0, dy0     : Single;
  dx1, dy1     : Single;
  upper, lower : Integer;
  cross        : Single;
  myTri        : TxyTriangle;
  j            : Integer;
 begin
  if (i >= XYs.Cnt) or (i < 0) or (XYs.Cnt < 3) then
   begin
    Result := False;
    Exit;
   end;

  upper := i + 1;
  lower := i - 1;

  Case (i = 0) of
   True : begin
           dx0 := XYs.Pt[0].x - XYs.Pt[XYs.Cnt - 1].x;
           dy0 := XYs.Pt[0].y - XYs.Pt[XYs.Cnt - 1].y;
           dx1 := XYs.Pt[1].x - XYs.Pt[0].X;
           dy1 := XYs.Pt[1].y - XYs.Pt[0].Y;
           lower := XYs.Cnt - 1;
          end;
   False: Case (i = XYs.Cnt - 1) of
           True : begin
                   dx0 := XYs.Pt[i].x - XYs.Pt[i - 1].x;
                   dy0 := XYs.Pt[i].y - XYs.Pt[i - 1].y;
                   dx1 := XYs.Pt[0].x - XYs.Pt[i].x;
                   dy1 := XYs.Pt[0].y - XYs.Pt[i].y;
                   upper := 0;
                  end;
           False: begin
                   dx0 := XYs.Pt[i].x - XYs.Pt[i - 1].x;
                   dy0 := XYs.Pt[i].y - XYs.Pt[i - 1].y;
                   dx1 := XYs.Pt[i + 1].x - XYs.Pt[i].x;
                   dy1 := XYs.Pt[i + 1].y - XYs.Pt[i].y;
                  end;
          End;
   End;

  cross := (dx0 * dy1) - (dx1 * dy0);
  If cross > 0 then
   begin
    Result := False;
    Exit;
   end;

  //
  myTri[0] := XYs.Pt[i];
  myTri[1] := XYs.Pt[upper];
  myTri[2] := XYs.Pt[lower];

  For j := 0 to XYs.Cnt - 1 do
   if not ((j = i) or (j = lower) or (j = upper)) then
    if IsInside(myTri, XYs.Pt[j].x, XYs.Pt[j].y) then
     begin
      Result := False;
      Exit;
     end;
  //
  Result := True;
 end;

Function xyTriangulation(XYs : TXYs; var output: TxyTriangles): Boolean;
 Var
  i                : Integer;
  buffer           : TxyTriangles;
  bufferSize       : Integer;
  itemCount        : Integer;
  earIndex         : Integer;
  newxy            : TXYs;
  currDest         : Integer;
  under, over      : Integer;
  toAdd, toAddMore : TxyTriangle;
  vNum             : Integer;
 begin
  Result := False;
  if XYs.Cnt < 3 then Exit;

  itemCount  := 0;
  bufferSize := 0;
  vNum := XYs.Cnt;

  While vNum > 3 do
   begin
    earindex := -1;
    For i := 0 to vNum - 1 do
     if IsEar(i, XYs) then
      begin
       earIndex := i;
       Break;
      end;

    If earIndex = -1 then Exit;

    Dec(vNum);
    currDest := 0;
    newxy.Cnt := vNum;

    For i := 0 to vNum - 1 do
     begin
      if currDest = earIndex then
       Inc(currDest);
      newxy.Pt[i] := XYs.Pt[currDest];
      Inc(currDest);
     end;

    if earIndex = 0          then under := XYs.Cnt - 1 //a
                             else under := earIndex - 1;
    if earindex = XYs.Cnt- 1 then over := 0
                             else over := earIndex + 1;

    toAdd[0] := XYs.Pt[earIndex];
    toAdd[1] := XYs.Pt[over    ];
    toAdd[2] := XYs.Pt[under   ];
    xyTriangleCCW(toAdd);

    Inc(itemCount);
    buffer.cnt := itemCount;
    buffer.Tri[itemCount - 1] := toAdd;

    XYs := newXY;
   end;

  toAddMore[0] := XYs.Pt[1];
  toAddMore[1] := XYs.Pt[2];
  toAddMore[2] := XYs.Pt[0];
  xyTriangleCCW(toAddMore);

  if output.Cnt < itemCount + 1 then
   output.Cnt := itemCount + 1; // else do not change output size
  for i := 0 to itemCount - 1 do
   output.Tri[i] := buffer.Tri[i];
  output.Tri[itemCount] := toAddMore;

  output.cnt := itemcount+1;
  Result := output.Cnt >= 1;
 end;

//-----------------------------------------------------------------------------
//
// ArcBall
//
//-----------------------------------------------------------------------------


//
Function mRadToDeg(const XYZ : TXYZ) : TXYZ;
 begin
  Result.X := XYZ.X * (180/pi);
  Result.Y := XYZ.Y * (180/pi);
  Result.Z := XYZ.Z * (180/pi);
 end;

//
Function mXY2Sphere(W,H,X,Y : Single): TXYZ;
 var
  lmag   : Single;
  lScale : Single;
  XYZ    : TXYZ;
 begin
  XYZ.X := (2*X-W)/W;
  XYZ.Y := (H-2*Y)/H;
  lMag := sqr(XYZ.X) + sqr(XYZ.Y);
  Case lMag > 1 of
   True  : begin
            lScale := 1.0 / sqrt(lMag);
            XYZ.X := XYZ.X * lScale;
            XYZ.Y := XYZ.Y * lScale;
            XYZ.Z := 0;
           end;
   False : XYZ.Z := sqrt(1 - lMag);
  End;
  Result := XYZ;
 end;

//
function mXYZ2Quaternion(const XYZFrom, XYZTo: TXYZ): TXYZW;
 begin
  Result.X := XYZFrom.Y * XYZTo.Z - XYZFrom.Z * XYZTo.Y;
  Result.Y := XYZFrom.Z * XYZTo.X - XYZFrom.X * XYZTo.Z;
  Result.Z := XYZFrom.X * XYZTo.Y - XYZFrom.Y * XYZTo.X;
  Result.W := XYZFrom.X * XYZTo.X + XYZFrom.Y * XYZTo.Y + XYZFrom.Z * XYZTo.Z;
 end;

//
function mQuaternionMul(const Ql,Qr: TXYZW): TXYZW;
 begin
  Result.x := qL.w * qR.x + qL.x * qR.w + qL.y * qR.z - qL.z * qR.y;
  Result.y := qL.w * qR.y + qL.y * qR.w + qL.z * qR.x - qL.x * qR.z;
  Result.z := qL.w * qR.z + qL.z * qR.w + qL.x * qR.y - qL.y * qR.x;
  Result.w := qL.w * qR.w - qL.x * qR.x - qL.y * qR.y - qL.z * qR.z;
 end;

function  mQuaternionConjugate(const Q: TXYZW): TXYZW;
 begin
  Result.X := -Q.X;
  Result.Y := -Q.Y;
  Result.Z := -Q.Z;
  Result.W :=  Q.W;
 end;

//
function mQuaternion2Mat(const Q: TXYZW): TM4x4;
 var
  M : TXYZW;
  Nq, s,
  xs, wx, xx, yy, ys,
  wy, xy, yz, zs, wz, xz, zz: Single;
 begin
  //
  M := mQuaternionConjugate(Q);
  //
  Nq := sqr(q.X) + sqr(q.y) + sqr(q.z) + sqr(q.W);
  if Nq > 0 then s := 2 / Nq
  else s := 0;
  xs := M.X * s;   ys := M.Y * s;   zs := M.Z * s;
  wx := M.W * xs;  wy := M.W * ys;  wz := M.W * zs;
  xx := M.X * xs;  xy := M.X * ys;  xz := M.X * zs;
  yy := M.Y * ys;  yz := M.Y * zs;  zz := M.Z * zs;

  Result[0, 0] := 1 - (yy + zz);
  Result[0, 1] := xy + wz;
  Result[0, 2] := xz - wy;

  Result[1, 0] := xy - wz;
  Result[1, 1] := 1.0 - (xx + zz);
  Result[1, 2] := yz + wx;

  Result[2, 0] := xz + wy;
  Result[2, 1] := yz - wx;
  Result[2, 2] := 1.0 - (xx + yy);

  Result[3, 0] := 0;
  Result[3, 1] := 0;
  Result[3, 2] := 0;

  Result[0, 3] := 0;
  Result[1, 3] := 0;
  Result[2, 3] := 0.0;
  Result[3, 3] := 1.0;
end;

//
// http://www.geometrictools.com/Documentation/EulerAngles.pdf p4
// http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToEuler/index.htm
//
// # Warning #
//   1. Matrix must be transposed if OpenGL Array used
//   2. Rotation Sequence is important !!
//        glRotate(RInfo.aRot.X,1,0,0);//  X   Bank
//        glRotate(RInfo.aRot.Y,0,1,0);//  Y   Heading
//        glRotate(RInfo.aRot.Z,0,0,1);//  Z   Attitude
//   3. Angle is Radian
//
Function mMatToEulerXYZ(const M : TM4x4) : TXYZ;
 begin
  Case (M[2,0] < +1) of
   True  : Case (M[2,0] > -1) of
            True : begin
                    Result.Y := arcsin ( M[2,0]);
                    Result.X := arctan2(-M[2,1],M[2,2]);
                    Result.Z := arctan2(-M[1,0],M[0,0]);
                   end;
            False: begin // r02 = -1
                    // Not a unique solution: thetaX - thetaZ = atan2(-r12,r11)
                    Result.Y := -pi/2;
                    Result.X := -arctan2(-M[0,1],M[1,1]);
                    Result.Z := 0;
                   end;
            End;
   False : begin // r02 = +1
            // Not a unique solution: thetaX + thetaZ = atan2(-r12,r11)
            Result.Y := +pi/2;
            Result.X := arctan2(M[0,1],M[1,1]);
            Result.Z := 0;
           end;
  End;
 End;

// http://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
// Future Works : XYZ order
function  mQuaternionToEulerXYZ(const Q : TXYZW) : TXYZ;
 begin
  Result := mMatToEulerXYZ(mQuaternion2Mat(Q));
 end;

Procedure ArcBall_Init (Var ArcBall : TxgArcBall);
 begin
  FillChar(ArcBall.V3sav ,SizeOf(ArcBall.V3sav),#0);
  FillChar(ArcBall.aRot  ,SizeOf(ArcBall.aRot ),#0);
  ArcBall.mRot    := cID4x4;
  ArcBall.mRotSav := cID4x4;
  FillChar(ArcBall.qRot   ,SizeOf(ArcBall.qRot   ),#0);
  ArcBall.qRot.W    := 1;
  FillChar(ArcBall.qRotSav,SizeOf(ArcBall.qRotSav),#0);
  ArcBall.qRotSav.W := 1;
 end;

Procedure ArcBall_Down (Var ArcBall : TxgArcBall; Width,Height,X,Y : Single);
 begin
  ArcBall.Downed  := TRUE;
  ArcBall.Width   := Width;
  ArcBall.Height  := Height;
  ArcBall.v3sav   := mXY2Sphere(Width,Height,X,Y);
  ArcBall.mRotSav := ArcBall.mRot;
  ArcBall.qRotSav := ArcBall.qRot;
 end;

Procedure ArcBall_Move(var ArcBall : TxgArcBall; X,Y : Single);
 Var
  XYZ  : TXYZ;
  XYZW : TXYZW;
 begin
  If Not(ArcBall.Downed) then Exit;
  //  Mat-> Euler | glRotate(AngleX,1,0,0) ...
  XYZ          := mXY2Sphere       (ArcBall.Width,ArcBall.Height,X ,Y );
  XYZW         := mXYZ2Quaternion  (XYZ,ArcBall.v3sav);
  ArcBall.mRot := mQuaternion2Mat  (XYZW);
  ArcBall.mRot := _mM4x4           (ArcBall.mRotSav,ArcBall.mRot);
  //
  XYZ          := mMatToEulerXYZ   (ArcBall.mRot);
  XYZ          := mRadToDeg        (XYZ);
  ArcBall.aRot := XYZ;
 end;

Procedure ArcBall_Up(var ArcBall : TxgArcBall);
 begin
  ArcBall.Downed := False;
 end;

//------------------------------------------------------------------------------
//
//  OpenGL ES v2.0 Helper Function
//
//------------------------------------------------------------------------------

//
Procedure _glFrustum(Var Mat : TM4x4; l,r,b,t,n,f : Single);
 begin
  FillChar(Mat,SizeOf(Mat),#0);
  //
  Mat[0,0] := 2 * n / (r - l);
  Mat[2,0] := (r + l) / (r - l);
  Mat[1,1] := 2 * n / (t - b);
  Mat[2,1] := (t + b) / (t - b);
  Mat[2,2] := -(f + n) / (f - n);
  Mat[3,2] := -(2 * f * n) / (f - n);
  Mat[2,3] := -1;
  Mat[3,3] :=  0;
 end;

//
Procedure _glOrtho(Var Mat : TM4x4; left,right,bottom,top,znear,zfar : Single);
 begin
  FillChar(Mat,SizeOf(Mat),#0);
  //
  Mat[0,0] := 2 / (right-left);
  Mat[3,0] := -(right+left) / (right-left);
  Mat[1,1] := 2 / (top  - bottom);
  Mat[3,1] := -(top + bottom) / (top - bottom );
  Mat[2,2] := -2 / ( zfar - znear);
  Mat[3,2] := -(zfar+znear) / (zfar -znear);
 end;

//
Procedure _glPerspective(Var Mat : TM4x4; fovy,aspect,zNear,zFar : Single);
 Var
  t   : Single;
  h,w : Single;
 begin
  //t := tan(fovy/2* (pi/180));
  t := 1/1.4141;
  h := zNear * t;
  w := h * aspect;
  //
  _glFrustum(Mat,-w,w,-h,h,zNear,zFar);
 end;

//
Procedure _glTranslatef(Var Mat : TM4x4; x,y,z : Single );
 begin
  Move(cID4x4,Mat,SizeOf(cID4x4));
  Mat[3][0] := x;
  Mat[3][1] := y;
  Mat[3][2] := z;
 end;

//
Procedure _glScalef(Var Mat : TM4x4; x,y,z : Single );
 begin
  Move(cID4x4,Mat,SizeOf(cID4x4));
  Mat[0][0] := x;
  Mat[1][1] := y;
  Mat[2][2] := z;
 end;

//  http://www.songho.ca/opengl/gl_matrix.html
Procedure _glRotatef(Var Mat : TM4x4; angle,x,y,z : Single);
 Var
  rad : Single;
  c,s : Single;
  oneMinusCos : Single;
 begin
  //
  rad := angle * (pi/180);
  c   := cos(rad);
  s   := sin(rad);
  oneMinusCos := 1 - c;
  //
  Move(cID4x4,Mat,SizeOf(cID4x4));
  //
  If (x=1)and(y=0)and(z=0) then
   begin
    Mat[0][0] := oneMinusCos + c;
    Mat[1][1] :=  c;    Mat[2][1] := -s;    Mat[1][2] :=  s;    Mat[2][2] :=  c;
    Exit;
   end;
  If (x=0)and(y=1)and(z=0) then
   begin
    Mat[1][1] := oneMinusCos + c;
    Mat[0][0] :=  c;    Mat[2][0] :=  s;    Mat[0][2] := -s;    Mat[2][2] :=  c;
    Exit;
   end;
  If (x=0)and(y=0)and(z=1) then
   begin
    Mat[2][2] := oneMinusCos + c;
    Mat[0][0] :=  c;    Mat[1][0] := -s;    Mat[0][1] :=  s;    Mat[1][1] :=  c;
    Exit;
   end;
  //
  Mat[0][0] := x*x * oneMinusCos + c;
  Mat[1][0] := x*y * oneMinusCos - z*s;
  Mat[2][0] := x*z * oneMinusCos + y*s;

  Mat[0][1] := x*y * oneMinusCos + z*s;
  Mat[1][1] := y*y * oneMinusCos + c;
  Mat[2][1] := z*y * oneMinusCos - x*s;

  Mat[0][2] := x*z * oneMinusCos - y*s;
  Mat[1][2] := y*z * oneMinusCos + x*s;
  Mat[2][2] := z*z * oneMinusCos + c;
 end;

// jpg, png Only
Function _glTexture_Load_wPas(ImgName   : String; Var Img : GLuint;
                              AlphaMask : Boolean = True;
                              TileMode  : Boolean = False) : Boolean;

 Var
  ImgDecoder : TImgDecoder;
  Rst        : Boolean;
  PixelFormat: DWord;
  Str        : String;
 begin
  //
  ImgDecoder := TImgDecoder.Create;
  Rst := ImgDecoder.LoadFromFile(ImgName);
  If Not(Rst) then
   begin
    ImgDecoder.Free;
    Dbg('LoadImage : Fail');
    Exit;
   end;
  //
  Case ImgDecoder.PixFormat of
   pfRGB  : begin PixelFormat := GL_RGB;   str := 'RGB';     end;
   pfRGBA : begin PixelFormat := GL_RGBA;  str := 'RGBA';    end;
   else     begin                          str := 'Unknown'; end;
  end;
  // Alpha Mask ---------------------------------------------------------------
  {
  If AlphaMask then
   begin
    RGBA := Bmp.ScanLine[0];
    For X := 0 to Bmp.Width-1 do RGBA[X] := RGBA[X] and $00FFFFFF;
    RGBA := Bmp.ScanLine[Bmp.Height-1];
    For X := 0 to Bmp.Width-1 do RGBA[X] := RGBA[X] and $00FFFFFF;
    //
    For Y := 0 to Bmp.Height-1 do
     begin
      RGBA := Bmp.ScanLine[Y];
      RGBA[0          ] := RGBA[0] and $00FFFFFF;
      RGBA[Bmp.Width-1] := RGBA[0] and $00FFFFFF;
     end;
   end;
  }
  //
  glGenTextures  (1,@Img);
  glBindTexture  (GL_Texture_2D,Img);
  glTexparameteri(GL_Texture_2D,GL_Texture_Min_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Mag_Filter, GL_Linear);
  Case TileMode of
   True : begin
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S, GL_Repeat);
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T, GL_Repeat);
          end;
   False: begin
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S, GL_Clamp_To_Edge);
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T, GL_Clamp_To_Edge);
          end;
  End;
  glTexImage2D   (GL_Texture_2D,
                  0,
                  PixelFormat,
                  ImgDecoder.ImgWidth,
                  ImgDecoder.ImgHeight,
                  0,
                  PixelFormat,
                  GL_UNSIGNED_BYTE,
                  ImgDecoder.FImgPtr);
  //
  dbg('Load Texture Pascal #'+ IntToStr(Img) + Str + ' wh: '  +
      IntToStr(ImgDecoder.ImgWidth )  + 'x' +
      IntToStr(ImgDecoder.ImgHeight) );
  ImgDecoder.Free;
  Result := True;
 end;

// https://github.com/zagayevskiy/Pacman/blob/master/jni/managers/Art.cpp
// http://blog.livedoor.jp/itahidamito/archives/51661332.html
//

function _glTexture_Load_wJava(env: PJNIEnv; _jcanvases2: JObject;
                               _fullFilename: string;
                               var Img : GLuint;
                               AlphaMask: Boolean = True;
                               TileMode : Boolean = False): boolean;
var
  Size: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  PInt : PInteger;
  i    : Integer;
  w,h  : Integer;
  Pixel : DWord;
  PixelFormat: DWord;
  _jBoolean  : jBoolean;
begin

  gVM^.AttachCurrentThread(gVm,@env,nil);

  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullFilename));
  jCls:= env^.GetObjectClass(env, _jcanvases2);
  jMethod:= env^.GetMethodID(env, jCls, 'GetBmpIntArray', '(Ljava/lang/String;)[I');
  jResultArray:= env^.CallObjectMethodA(env, _jcanvases2, jMethod,  @jParams);

  Size:= env^.GetArrayLength(env, jResultArray);
  _jBoolean  := JNI_False;
  PInt := env^.GetIntArrayElements(env,jResultArray,_jBoolean);

  Inc(PInt,Size-2);
  w := Pint^; Inc(Pint);
  h := Pint^; Inc(Pint);
  Dec(PInt,Size);
  // BGRA -> RGBA
  i := w*h-1;
  repeat
   Pixel := PInt^;
   Pixel :=  (Pixel and $FF00FF00) or
            ((Pixel and $00FF0000) shr 16) or
            ((Pixel and $000000FF) shl 16);

   PInt^ := Pixel;
   Inc(PInt);
   dec(i);
  until(i = 0);

  Dec(PInt,w*h-1);
  PixelFormat := GL_RGBA;
  //
  glGenTextures  (1,@Img);
  glBindTexture  (GL_Texture_2D,Img);
  glTexparameteri(GL_Texture_2D,GL_Texture_Min_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Mag_Filter, GL_Linear);

  Case TileMode of
   True : begin
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S, GL_Repeat);
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T, GL_Repeat);
          end;
   False: begin
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S, GL_Clamp_To_Edge);
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T, GL_Clamp_To_Edge);
          end;
  End;

  glTexImage2D   (GL_Texture_2D,
                  0,
                  PixelFormat,
                  w,
                  h,
                  0,
                  PixelFormat,
                  GL_UNSIGNED_BYTE,
                  Pointer(PInt));

  env^.DeleteLocalRef(env,jParams[0].l);
  env^.ReleaseIntArrayElements(env,jResultArray,PInt,0);
  env^.DeleteLocalRef(env, jCls);

  Result := True;

end;

(*
Function _glTexture_Load_wJava(env:PJNIEnv;
                               this:jobject;
                               ImgName  : String;
                               Var Img : GLuint;
                               AlphaMask: Boolean = True;
                               TileMode : Boolean = False) : Boolean;
Const
 _cFuncName = 'getBmpArray';
 _cFuncSig  = '(Ljava/lang/String;)[I';
Var
 _jClass    : jClass;
 _jMethod   : jMethodID;
 _jParam    : jValue;
 _jIntArray : jintArray;
 _jBoolean  : jBoolean;
 //
 Size : Integer;
 PInt : PInteger;
// PIntS: PInteger;
 i    : Integer;
 w,h  : Integer;
 //
 Pixel : DWord;
 PixelFormat: DWord;
 //
 begin
  //
  gVM^.AttachCurrentThread(gVm,@env,nil);
  //
  _jClass    := env^.FindClass   ( env, gjClassName );
  _jMethod   := env^.GetMethodID ( env, _jClass, _cFuncName, _cFuncSig);
  _jParam.l  := env^.NewStringUTF( env, pchar(ImgName));
  _jIntArray := env^.CallObjectMethodA(env,this,_jMethod,@_jParam);
  //
  Size := env^.GetArrayLength(env,_jIntArray);
  _jBoolean  := JNI_False;
  PInt := env^.GetIntArrayElements(env,_jIntArray,_jBoolean);

  Inc(PInt,Size-2);
  w := Pint^; Inc(Pint);
  h := Pint^; Inc(Pint);
  //
  Dec(PInt,Size);
  // BGRA -> RGBA
  i := w*h-1;
  repeat
   Pixel := PInt^;
   Pixel :=  (Pixel and $FF00FF00) or
            ((Pixel and $00FF0000) shr 16) or
            ((Pixel and $000000FF) shl 16);

   PInt^ := Pixel;
   Inc(PInt);
   dec(i);
  until(i = 0);
  Dec(PInt,w*h-1);
  // Alpha Mask ---------------------------------------------------------------
  {
  If AlphaMask then
   begin
    RGBA := Bmp.ScanLine[0];
    For X := 0 to Bmp.Width-1 do RGBA[X] := RGBA[X] and $00FFFFFF;
    RGBA := Bmp.ScanLine[Bmp.Height-1];
    For X := 0 to Bmp.Width-1 do RGBA[X] := RGBA[X] and $00FFFFFF;
    //
    For Y := 0 to Bmp.Height-1 do
     begin
      RGBA := Bmp.ScanLine[Y];
      RGBA[0          ] := RGBA[0] and $00FFFFFF;
      RGBA[Bmp.Width-1] := RGBA[0] and $00FFFFFF;
     end;
   end;
  }
  PixelFormat := GL_RGBA;
  //
  glGenTextures  (1,@Img);
  glBindTexture  (GL_Texture_2D,Img);
  glTexparameteri(GL_Texture_2D,GL_Texture_Min_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Mag_Filter, GL_Linear);

  Case TileMode of
   True : begin
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S, GL_Repeat);
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T, GL_Repeat);
          end;
   False: begin
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S, GL_Clamp_To_Edge);
           glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T, GL_Clamp_To_Edge);
          end;
  End;

  glTexImage2D   (GL_Texture_2D,
                  0,
                  PixelFormat,
                  w,
                  h,
                  0,
                  PixelFormat,
                  GL_UNSIGNED_BYTE,
                  Pointer(PInt));
  //
  env^.DeleteLocalRef(env,_jParam.l);
  env^.ReleaseIntArrayElements(env,_jIntArray,PInt,0);
  dbg('Load Texture Java #'+ IntToStr(Img) + ' wh: '  + IntToStr(w) + 'x' + IntToStr(h) );
  Result := True;
 end;
*)

Function _glTexture_Free(Var Img : GLuint) : Boolean;
 begin
  glDeleteTextures (1,@Img);
  Result := True;
 end;

//-----------------------------------------------------------------------------

Const
 cShaderHelp     = '//';
 cShaderVertex   = '[Vertex:';
 cShaderFragment = '[Fragment:';
 cCrLf           = #13#10;
 czNear          =    0.1;
 czFar           = 1000.0;
 cfieldOfView    =   60.0;
 cShaderMax      = 59;
 cShader : Array[0..cShaderMax-1] of String =
     ('[Vertex:simon_Vert]                                                          ',
      'uniform   mat4 umMVPMatrix;                                                  ',
      'attribute vec4 avPosition;                                                   ',
      'attribute vec4 avColor;                                                      ',
      'varying   vec4 vvColor;                                                      ',
      'attribute vec2 avTexture;                                                    ',
      'varying   vec2 vvTexture;                                                    ',
      'void main()                                                                  ',
      '{                                                                            ',
      '  gl_Position = umMVPMatrix * avPosition;                                    ',
      '  vvTexture   = avTexture;                                                   ',
      '  vvColor     = avColor;                                                     ',
      '}                                                                            ',
      '                                                                             ',
      '[Fragment:simon_Frag]                                                        ',
      'precision mediump   float;                                                   ',
      'varying   vec2      vvTexture;                                               ',
      'varying   vec4      vvColor;                                                 ',
      'uniform   sampler2D usTexture;                                               ',
      'uniform   float     calpha;                                                  ',
      'uniform   int       shader;                                                  ',
      'void main()                                                                  ',
      '{                                                                            ',
      '  // Color : Default                                                         ',
      '  if ( shader == 0)                                                          ',
      '  {                                                                          ',
      '    gl_FragColor    = vvColor;                                               ',
      '    gl_FragColor.a *= calpha;                                                ',
      '  }                                                                          ',
      '                                                                             ',
      '  // Texture                                                                 ',
      '  if ( shader == 1)                                                          ',
      '  {                                                                          ',
      '    gl_FragColor    = texture2D( usTexture, vvTexture );                     ',
      '    gl_FragColor.a *= calpha;                                                ',
      '  }                                                                          ',
      '                                                                             ',
      '  // Sepia                                                                   ',
      '  if ( shader == 2)                                                          ',
      '  {                                                                          ',
      '    lowp vec4 tColor = texture2D( usTexture, vvTexture );                    ',
      '    lowp vec4 oColor;                                                        ',
      '    oColor.r = (tColor.r * 0.393) + (tColor.g * 0.769) + (tColor.b * 0.189); ',
      '    oColor.g = (tColor.r * 0.349) + (tColor.g * 0.686) + (tColor.b * 0.168); ',
      '    oColor.b = (tColor.r * 0.272) + (tColor.g * 0.534) + (tColor.b * 0.131); ',
      '    oColor.a =  tColor.a;                                                    ',
      '    gl_FragColor    = oColor;                                                ',
      '    gl_FragColor.a *= calpha;                                                ',
      '  }                                                                          ',
      '                                                                             ',
      '  // Gray Scale                                                              ',
      '  if ( shader == 3)                                                          ',
      '  {                                                                          ',
      '    lowp vec4 tColor = texture2D( usTexture, vvTexture );                    ',
      '    lowp float gray = dot(tColor, vec4(0.299,0.587,0.114,0.0));              ',
      '    gl_FragColor    = vec4(vec3(gray),tColor.a);                             ',
      '    gl_FragColor.a *= calpha;                                                ',
      '  }                                                                          ',
      '}                                                                            ');


//------------------------------------------------------------------------------
// jCanvasES2
//------------------------------------------------------------------------------

Constructor jCanvasES2.Create(AOwner: TComponent);
var
  i: integer;
begin
  inherited Create(AOwner);
  // Init
  FAutoRefresh := False;

  // Load Shader Script
  FScript := TStringList.Create;
  for i := 0 to cShaderMax-1 do FScript.Add(cShader[i]);

  // Init
  FillChar( FProg       , SizeOf(FProg      ), #0);
  FillChar( FShaderVars , SizeOf(FShaderVars), #0);
  FillChar( Textures    , SizeOf(Textures   ), #0);

  TexturesCount:= 0;
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 96;
  FWidth        := 96;
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent

end;

Destructor jCanvasES2.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
        if FjObject  <> nil then
        begin
          jGLSurfaceView_Free(FjEnv, FjObject );
          FjObject := nil;
        end;
  end;
  // --------------------------------------------------------------------------
  //  Tip. Android do not require Delete Program & Texture
  //       Ref.
  // --------------------------------------------------------------------------

  // Program Variable ---------------------------------------------------------
  If FProg.Active then
   begin
    // If FProg.Fragment.Active then glDeleteShader(FProg.Fragment.ID);
    // If FProg.Vertex.Active   then glDeleteShader(FProg.Vertex.ID  );
    // glDeleteProgram(FProg.ID);
    // FillChar(FProg,SizeOf(FProg),#0);
   end;

  //FillChar(Textures, SizeOf( Textures ), #0);

  // Shader Interface Variable ------------------------------------------------
  FillChar(FShaderVars, SizeOf(FShaderVars), #0);

  // Texture ------------------------------------------------------------------
  // Texture_Clear;
  FillChar(Textures, SizeOf( Textures ), #0);
  FScript.Free;
  inherited Destroy;
end;

Procedure jCanvasES2.Init(refApp: jApp);
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;

  inherited Init(refApp);

  FjObject:= jGLSurfaceView_Create2(FjEnv, FjThis, Self,cjOpenGLESv2);

  FInitialized:= True;

  jGLSurfaceView_setParent(FjEnv, FjObject , FjPRLayout);
  jGLSurfaceView_setId(FjEnv, FjObject , Self.Id);

  jGLSurfaceView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                                 FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                                 GetLayoutParams(gApp, FLParamWidth, sdW),
                                                 GetLayoutParams(gApp, FLParamHeight, sdH));
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jGLSurfaceView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
     if rToP in FPositionRelativeToParent then
     begin
       jGLSurfaceView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
     end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id;
  jGLSurfaceView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);

  jGLSurfaceView_SetAutoRefresh(FjEnv, FjObject , FAutoRefresh);
  View_SetVisible(FjEnv, FjThis, FjObject , FVisible);

 // IsFirstInit:= True;
end;

Procedure jCanvasES2.SetVisible  (Value : Boolean);
begin
  FVisible := Value;
  if FInitialized then
     View_SetVisible(FjEnv, FjObject , FVisible);
end;

function jCanvasES2.GetVisible: Boolean;
begin
  Result:= FVisible;
end;

Procedure jCanvasES2.Refresh;
begin
  if FInitialized then
    jGLSurfaceView_Refresh(FjEnv, FjObject );
end;

Procedure jCanvasES2.SetAutoRefresh(Value: boolean);
begin
  FAutoRefresh := Value;
  if FInitialized then
     jGLSurfaceView_SetAutoRefresh(FjEnv, FjObject , FAutoRefresh);
end;

//
Function jCanvasES2.Shader_Build( sType : TxgShaderType; Name : String ) : GLuint;
var
  ShaderName    : String;
  ShaderStr     : String;
  ShaderStarted : Boolean;
  //
  ShaderType    : LongWord;
  ShaderStrP    : PChar;
  ShaderRst     : GLuint;
  Shader        : GLuint;
  //
  i             : Integer;
  Str           : String;

Label
  GoHere;

begin
  //
  Result := 0;
  if not FInitialized then Exit;
  Case sType of
   xsVert : ShaderName := UpperCase( cShaderVertex   + Name);
   xsFrag : ShaderName := UpperCase( cShaderFragment + Name);
  End;
  ShaderStarted := False;
  ShaderStr     := '';
  //
  For i := 0 to FScript.Count-1 do
   begin
    Str    := Trim(FScript[i]);
    If Pos(cShaderHelp,Str) > 0 then Str := '';
    If Str <> '' then
     begin
      If ShaderStarted then
       begin
        If Pos('[',Str) = 1 then Goto GoHere;
        ShaderStr := ShaderStr + Str + cCrLf;
       end;
      //
      If Pos(ShaderName,UpperCase(Str)) > 0 then
       ShaderStarted := True;
     end;
   end;

  GoHere:
  If Trim(Str) = '' then Exit;

  // Create Shader ------------------------------------------------------------
  Case sType of
   xsVert : ShaderType := GL_VERTEX_SHADER;
   xsFrag : ShaderType := GL_FRAGMENT_SHADER;
  End;
  Shader := glCreateShader( ShaderType );
  If Shader = gl_False then Exit;
  //Load
  ShaderStrP := PChar(ShaderStr);
  glShaderSource(Shader, 1, @ShaderStrP, nil);
  //Compile
  glCompileShader(Shader);
  glGetShaderiv(Shader, GL_COMPILE_STATUS, @ShaderRst);
  If ShaderRst = GL_True then Result:= Shader;
end;

//
Procedure jCanvasES2.SetShader  ( value : TxgShader );
begin
  if not FInitialized then Exit;
  case value of
   Shader_Color   : glUniform1i (FShaderVars.hShader, 0);
   Shader_Texture : glUniform1i (FShaderVars.hShader, 1);
   Shader_Sepia   : glUniform1i (FShaderVars.hShader, 2);
   Shader_Gray    : glUniform1i (FShaderVars.hShader, 3);
  end;
end;

//
Procedure jCanvasES2.SetMVP( const M4x4 : TM4x4);
begin
  if FInitialized then
     glUniformMatrix4fv( FShaderVars.hMVP, 1, GL_FALSE, @M4x4);
end;

//
Procedure jCanvasES2.SetAlpha ( alpha : Single );
begin
  if FInitialized then
     glUniform1f ( FShaderVars.hAlpha, alpha ); // Texture
end;

//
Procedure jCanvasES2.SetVertex ( ptr : Pointer );
begin
  if not FInitialized then Exit;
  case ptr = nil of
   True  : glDisableVertexAttribArray(FShaderVars.hVertex);
   False : begin
            glEnableVertexAttribArray(FShaderVars.hVertex);
            glVertexAttribPointer    (FShaderVars.hVertex, 3, GL_FLOAT, GL_FALSE, 0,ptr);
           end;
  end;
end;

//
Procedure jCanvasES2.SetColor ( ptr : Pointer );
begin
  if not FInitialized then Exit;
  case ptr = nil of
   True  : glDisableVertexAttribArray(FShaderVars.hColor);
   False : begin
            glEnableVertexAttribArray(FShaderVars.hColor);
            glVertexAttribPointer    (FShaderVars.hColor, 4, GL_FLOAT, GL_FALSE, 0,ptr);
           end;
  end;
end;

//
Procedure jCanvasES2.SetTexture ( ptr : Pointer );
begin
  if not FInitialized then Exit;
  case ptr = nil of
   True  : glDisableVertexAttribArray(FShaderVars.hTexture);
   False : begin
             glEnableVertexAttribArray(FShaderVars.hTexture);
             glVertexAttribPointer    (FShaderVars.hTexture, 2, GL_FLOAT, GL_FALSE, 0,ptr);
           end;
  end;
end;

//
Procedure jCanvasES2.BindTexture( const Texture : TxgElement );
begin
  if not FInitialized then Exit;
  //glActiveTexture(TextureID);
  if not(Texture.Active) then Exit;
  glBindTexture(GL_TEXTURE_2D,Texture.ID);
end;

//
Function jCanvasES2.IntToShader ( shader : integer ) : TxgShader;
begin
  if not FInitialized then Exit;
  Shader := Shader mod 4;
  case shader of
   0 : Result := Shader_Color;
   1 : Result := Shader_Texture;
   2 : Result := Shader_Sepia;
   3 : Result := Shader_Gray;
  end;
end;

Function jCanvasES2.Shader_Compile ( Vertex,Fragment : String ) : Boolean;
var
  ProgRst : GLuint;
begin
  Result := False;
  if not FInitialized then Exit;
  //
 // If FProg.Active then Exit;
  // Loade Shader & Compile ---------------------------------------------------
  FProg.Vertex.ID       := Shader_Build(xsVert,Vertex  );
  FProg.Vertex.Active   := True;
  //
  FProg.Fragment.ID     := Shader_Build(xsFrag,Fragment);
  FProg.Fragment.Active := True;

  // Shader Program -----------------------------------------------------------
  FProg.ID := glCreateProgram();

  // Attach vertex & fragment
  glAttachShader(FProg.ID, FProg.Vertex.ID  );
  glAttachShader(FProg.ID, FProg.Fragment.ID);

  // Link the program
  glLinkProgram (FProg.ID);
  glGetProgramiv(FProg.ID, GL_LINK_STATUS, @ProgRst);
  If ProgRst = GL_False then Exit;

  // Use Program
  glUseProgram(FProg.ID);

  //
  FProg.Active := True;
  Result := True;
end;

//
Function jCanvasES2.Shader_Link : Boolean;
begin
  Result := False;
  if not FInitialized then Exit;
  If not FProg.Active then Exit;
  // Handle
  FShaderVars.hMVP        := glGetUniformLocation(FProg.ID, 'umMVPMatrix');
  FShaderVars.hVertex     := glGetAttribLocation (FProg.ID, 'avPosition' );
  FShaderVars.hColor      := glGetAttribLocation (FProg.ID, 'avColor'    );
  //
  FShaderVars.hTexture    := glGetAttribLocation (FProg.ID, 'avTexture'  );
  FShaderVars.hAlpha      := glGetUniformLocation(FProg.ID, 'calpha'     );
  FShaderVars.hShader     := glGetUniformLocation(FProg.ID, 'shader'     );
  //
  SetAlpha(1.0);
  //
  Result := True;
end;

//
Procedure jCanvasES2.Screen_Setup(w,h : Integer;
                                  Projection : TxgProjection = xp2D;
                                  CullFace   : Boolean = True);
begin
  if not FInitialized then Exit;
  glViewPort (0,0,w,h);
  //
  Case Projection of
   xp2D : MVP := cID4x4;
   xp3D : _glPerspective (MVP,cfieldOfView,w/h,czNear,czFar);
  End;
  //
  Case CullFace of
   True : glEnable  (GL_CULL_FACE);
   False: glDisable (GL_CULL_FACE);
  End;
  //
  glEnable    (GL_BLEND);             // Enable Blending
  glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
end;

//
Procedure jCanvasES2.Screen_Clear(r,g,b,a : Single);
begin
  //
  if not FInitialized then Exit;
  glClearColor(r, g, b, a); // BackGround Color
  glClear     (GL_COLOR_BUFFER_BIT or
               GL_DEPTH_BUFFER_BIT or
               GL_STENCIL_BUFFER_BIT);
 end;

//
Procedure jCanvasES2.Translate (const X,Y,Z : Single);
var
  T : TM4x4;
begin
  if FInitialized then
     _glTranslatef (T,X,Y,Z);     MVP := _mM4x4(T,MVP);
end;

//
Procedure jCanvasES2.Rotate    (const Angle,X,Y,Z : Single);
var
  R : TM4x4;
begin
  if FInitialized then
     _glRotatef (R,Angle,X,Y,Z);  MVP := _mM4x4(R,MVP);
end;

//
Procedure jCanvasES2.Scale (const X,Y,Z : Single);
var
  S : TM4x4;
begin
  if FInitialized then
     _glScalef (S,X,Y,Z);         MVP := _mM4x4(S,MVP);
end;

//
Procedure jCanvasES2.SetMask (Layer : Integer; MaskMode : TxgMaskMode );
begin
  if not FInitialized then Exit;
  Case MaskMode of
   mmOpen : begin
             glEnable (GL_STENCIL_TEST);  // Stencil ON
             glDisable(GL_Depth_TEST);
            end;
   mmMask : begin
             glStencilFunc(GL_ALWAYS,Layer,$FFFFFFFF);       //
             glColorMask  (GL_False,  GL_False  ,GL_False, GL_False);
             Case Layer of
               1 :  glStencilOp  (GL_Replace,GL_Replace,GL_Replace);
               else glStencilOp  (GL_Keep   ,GL_Keep   ,GL_Replace);
             End;
            end;
   mmDraw : begin
             glStencilFunc     (GL_EQUAL,Layer,$FFFFFFFF);
             glStencilOp       (GL_Keep,GL_Keep,GL_KEEP);
             glColorMask       (GL_True,GL_True,GL_True,GL_True);
            end;
   mmClose: begin
             glDisable(GL_STENCIL_TEST);  // Stencil ON
             glEnable (GL_Depth_TEST);
            end;
  End;
end;

//
Procedure jCanvasES2.DrawArray( aVertex    : Pointer;
                                aColor     : Pointer;
                                aTexture   : Pointer;
                                tTexture   : pxgElement;
                                Count      : Integer );
begin
  if not FInitialized then Exit;
  //
  SetVertex (aVertex );
  SetColor  (aColor  );
  If tTexture <> nil then
   If tTexture^.Active then
    BindTexture(tTexture^);
  SetTexture(aTexture);
  //
  glDrawArrays(GL_TRIANGLE_STRIP,0,Count);
end;

Procedure jCanvasES2.DrawLine (P1,P2 : TXYZ; Color : TRGBA;
                               Width : Single = 0.3; AA : Boolean = True);
var
  v       : TXY;
  l       : Single;
  P       : Array[0..7] of TXYZ;
  C       : Array[0..7] of TRGBA;
  i       : Integer;
  W2x,W2y : Single;
  W4x,W4y : Single;
begin
  if not FInitialized then Exit;
  Case AA of
   True : begin // Anti-Alias Line
           For i := 0 to 7 do C[i] := Color;
           C[0].A := 0;
           C[1].A := 0;
           C[6].A := 0;
           C[7].A := 0;
           //
           v   := _XY(P2.X-P1.X,P2.Y-P1.Y);
           l   :=  Sqrt( (P2.X-P1.X)*(P2.X-P1.X) + (P2.Y-P1.Y)*(P2.Y-P1.Y) );
           v   := _XY( -v.Y/l,v.X/l );
           W2x := v.X*(Width/2);
           W2y := v.Y*(Width/2);
           W4x := v.X*(Width/4);
           W4y := v.Y*(Width/4);
           //
           P[0] := _XYZ(p1.X-W2x, p1.Y-W2y, p1.Z);
           P[1] := _XYZ(p2.X-W2x, p2.Y-W2y, p2.Z);
           P[2] := _XYZ(p1.X-W4x, p1.Y-W4y, p1.Z);
           P[3] := _XYZ(p2.X-W4x, p2.Y-W4y, p2.Z);
           P[4] := _XYZ(p1.X+W4x, p1.Y+W4y, p1.Z);
           P[5] := _XYZ(p2.X+W4x, p2.Y+W4y, p2.Z);
           P[6] := _XYZ(p1.X+W2x, p1.Y+W2y, p1.Z);
           P[7] := _XYZ(p2.X+W2x, p2.Y+W2y, p2.Z);
           //
           Shader := Shader_Color;
           SetVertex (@P);
           SetColor  (@C);
           SetTexture(nil);
           //
           glDrawArrays(GL_TRIANGLE_STRIP,0,8);
          end;
   False: begin
           P[0] := P1;
           P[1] := P2;
           C[0] := Color;
           C[1] := Color;
           //
           glLineWidth(Width);
           //
           SetVertex (@P);
           SetColor  (@C);
           SetTexture(nil);
           //
           glDrawArrays(GL_Lines,0,2);
          end;
  End;
end;

//
Procedure jCanvasES2.DrawRect(const Pt4 : Txy4CW; Z : Single; Color : TRGBA; Width : Single = 0.3);
var
  i : Integer;
begin
  if not FInitialized then Exit;
  For i := 0 to 2 do
   DrawLine( _XY_Z(Pt4[i],Z) , _XY_Z(Pt4[i+1],Z) , Color, Width);

   DrawLine( _XY_Z(Pt4[3],Z) , _XY_Z(Pt4[0],Z) , Color, Width);
end;

//
procedure jCanvasES2.DrawRectFill(const Pt4 : Txy4CW; Z : Single; Color : TRGBA; LColor : TRGBA; LWidth : Single = 0.3);
var
  P : Array[0..3] of TXYZ;
  C : Array[0..3] of TRGBA;
  i : Integer;
begin
  if not FInitialized then Exit;
  //
  P[0] := _XY_Z(Pt4[2],Z);
  P[1] := _XY_Z(Pt4[1],Z);
  P[2] := _XY_Z(Pt4[3],Z);
  P[3] := _XY_Z(Pt4[0],Z);
  //
  C[0] := Color;
  C[1] := Color;
  C[2] := Color;
  C[3] := Color;
  //
  SetVertex (@P);
  SetColor  (@C);
  SetTexture(nil);
  //
  glDrawArrays(GL_TRIANGLE_STRIP,0,4);
  // OutLine
  For i := 0 to 2 do
   DrawLine( _XY_Z(Pt4[i],Z) , _XY_Z(Pt4[i+1],Z) , LColor, LWidth);

  DrawLine( _XY_Z(Pt4[3],Z) , _XY_Z(Pt4[0],Z) , LColor, LWidth);
end;

//
Procedure jCanvasES2.DrawPoly (const Pts : TXYs; Z: Single; Color : TRGBA; Width : Single = 0.3);
var
  i : Integer;
begin
  if not FInitialized then Exit;
  For i := 0 to Pts.Cnt-2 do
   DrawLine ( _XYZ(Pts.Pt[i        ].X,Pts.Pt[i        ].Y,Z),
              _XYZ(Pts.Pt[i+1      ].X,Pts.Pt[i+1      ].Y,Z),
              Color,Width);
  DrawLine  ( _XYZ(Pts.Pt[Pts.Cnt-1].X,Pts.Pt[Pts.Cnt-1].Y,Z),
              _XYZ(Pts.Pt[0        ].X,Pts.Pt[0        ].Y,Z),
              Color,Width);
end;

//
Procedure jCanvasES2.DrawPolyFill(const Pts : TXYs; Z : Single;Color : TRGBA;
                                  LColor : TRGBA; LWidth : Single = 0.3);
var
  xyTris   : TxyTriangles;
  xyzTris  : TxyzTriangles;
  i,j      : Integer;
begin
  if not FInitialized then Exit;
  //
  If Not(xyTriangulation(Pts,xyTris)) then Exit;
  xyzTris.Cnt := xyTris.Cnt;
  For i := 0 to xyTris.Cnt-1 do
   For j := 0 to 2 do
    begin
     xyzTris.Tri[i][j].X := xyTris.Tri[i][j].X;
     xyzTris.Tri[i][j].Y := xyTris.Tri[i][j].Y;
     xyzTris.Tri[i][j].Z := Z;
     xyzTris.Color[i][j] := Color;
    end;
  //
  SetShader (Shader_Color  );
  SetVertex (@xyzTris.Tri  );
  SetColor  (@xyzTris.Color);
  SetTexture(nil);
  glDrawArrays(GL_TRIANGLES,0,xyzTris.Cnt*3);
  // OutLine
  If LWidth > 0 then
   DrawPoly(Pts,Z,LColor,LWidth);
end;

//
Procedure jCanvasES2.DrawMask (const Pts : TXYs; Z : Single );
var
  xyTris   : TxyTriangles;
  xyzTris  : TxyzTriangles;
  Color    : TRGBA;
 // TriColor : Array[0..2] of TRGBA;
  i,j      : Integer;
begin
  //
  if not FInitialized then Exit;
  If Not(xyTriangulation(Pts,xyTris)) then Exit;
  Color := _RGBA(1,1,1,1);
  xyzTris.Cnt := xyTris.Cnt;
  For i := 0 to xyTris.Cnt-1 do
   For j := 0 to 2 do
    begin
     xyzTris.Tri[i][j].X := xyTris.Tri[i][j].X;
     xyzTris.Tri[i][j].Y := xyTris.Tri[i][j].Y;
     xyzTris.Tri[i][j].Z := Z;
     xyzTris.Color[i][j] := Color;
    end;
  //
  SetShader (Shader_Color  );
  SetVertex (@xyzTris.Tri  );
  SetColor  (@xyzTris.Color);
  SetTexture(nil);
  glDrawArrays(GL_TRIANGLES,0,xyzTris.Cnt*3);
end;

//bug: texture flipped horizontally. [FIXED] by Handoko
Procedure jCanvasES2.DrawTexture(const Texture : TxgElement; const Pt4 : Txy4CW; Z : Single;
                                 Alpha : Single; Effect : TxgShader = Shader_Texture);
var
  T : Array[0..3] of TXY;
  P : Array[0..3] of TXYZ;
begin
  //
  if not FInitialized then Exit;
  P[0] := _XY_Z(Pt4[2],Z);
  P[1] := _XY_Z(Pt4[1],Z);
  P[2] := _XY_Z(Pt4[3],Z);
  P[3] := _XY_Z(Pt4[0],Z);
  //
  T[0] := _XY(0,0);
  T[1] := _XY(0,1);
  T[2] := _XY(1,0);
  T[3] := _XY(1,1);
  //
  SetShader  (Effect);
  SetAlpha   (Alpha );
  //
  SetVertex  (@P );
  SetColor   (nil);
  SetTexture (@T );
  BindTexture(Texture);
  //
  glDrawArrays(GL_TRIANGLE_STRIP,0,4);
end;
//
Procedure jCanvasES2.DrawTile(const Texture : TxgElement; const Pt4 : Txy4CW; n,Z : Single;
                              Alpha : Single; Effect : TxgShader = Shader_Texture);
var
  T : Array[0..3] of TXY;
  P : Array[0..3] of TXYZ;
  //i : Integer;
begin
  //
  if not FInitialized then Exit;
  P[0] := _XY_Z(Pt4[2],Z);
  P[1] := _XY_Z(Pt4[1],Z);
  P[2] := _XY_Z(Pt4[3],Z);
  P[3] := _XY_Z(Pt4[0],Z);
  //
  T[0] := _XY(1*n,0*n);
  T[1] := _XY(1*n,1*n);
  T[2] := _XY(0*n,0*n);
  T[3] := _XY(0*n,1*n);
  //
  SetShader  (Effect);
  SetAlpha   (Alpha );
  //
  SetVertex  (@P );
  SetColor   (nil);
  SetTexture (@T );
  BindTexture(Texture);
              glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S, GL_Repeat);
              glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T, GL_Repeat);

  //
  glDrawArrays(GL_TRIANGLE_STRIP,0,4);
end;

//
Procedure jCanvasES2.DrawCircle  (XY : TXY; Z, L : Single; Color : TRGBA; Width : Single = 0.3);
var
  i : Integer;
begin
  if not FInitialized then Exit;
  For i := 0 to 71 do
   DrawLine ( _XYZ(cCircle[(i+0)*2+0]*L+XY.X, cCircle[(i+0)*2+1]*L+XY.Y, Z),
              _XYZ(cCircle[(i+0)*2+2]*L+XY.X, cCircle[(i+0)*2+3]*L+XY.Y, Z),
              Color,Width);
end;

//
Procedure jCanvasES2.Texture_Load( var Texture : TxgElement; filename : String;
                                   TileMode : Boolean = False);
begin
  if not FInitialized then Exit;

  Case TileMode of

   //True : Texture.Active := _glTexture_Load_wJava(FjEnv, gApp.jni.jThis, gApp.Path.Dat+'/'+filename, Texture.ID,_cAlpha_MaskOff, _cTile_On );
   True : Texture.Active := _glTexture_Load_wJava(FjEnv, FjObject, gApp.Path.Dat+'/'+filename, Texture.ID,_cAlpha_MaskOff, _cTile_On );


   //False: Texture.Active := _glTexture_Load_wJava(FjEnv, gApp.jni.jThis, gApp.Path.Dat+'/'+filename,Texture.ID,_cAlpha_MaskOn ,_cTile_Off);
   False: Texture.Active := _glTexture_Load_wJava(FjEnv, FjObject, gApp.Path.Dat+'/'+filename,Texture.ID,_cAlpha_MaskOn ,_cTile_Off);

  End;


  {
  Case TileMode of
   True : Texture.Active := _glTexture_Load_wPascal(
                                filename,Texture.ID,_cAlpha_MaskOff,_cTile_On );
   False: Texture.Active := _glTexture_Load_wPascal(FjEnv,gApp.jni.jThis,
                                filename,Texture.ID,_cAlpha_MaskOn ,_cTile_Off);
  End;
  }
end;

Procedure jCanvasES2.Texture_Load_All(TileMode : Boolean = False);
var
  i: integer;
begin
  if not FInitialized then Exit;

  if FImageList = nil then
     Exit;
    //FImageList.Init(gApp)
//else
    //Exit;

  Texture_Clear;

  for i:= 0 to FImageList.Images.Count - 1 do
  begin
     if (FImageList.Images.Strings[i] <> '') and (FImageList.Images.Strings[i] <> 'null') then
     begin
       Texture_Load(Textures[i], FImageList.GetImageByIndex(i), TileMode);
       Inc(TexturesCount);
     end;
  end;

end;

Procedure jCanvasES2.Texture_UnLoad( var Texture : TxgElement );
begin
  if not FInitialized then Exit;
  Case Texture.Active of
   True : begin
           glDeleteTextures(1, @Texture.ID );
           //jGLSurfaceView_deleteTexture(FjEnv, FjObject ,Texture.Id);
          end;
   False:  ; //dbg('Delete Texture Skip ' + IntToStr(Texture.ID) );
  end;
  Texture.Active := False;
end;


Procedure jCanvasES2.Texture_UnLoad_All;
var
  i: integer;
begin
  if not FInitialized then Exit;
  for i:= 0 to TexturesCount - 1 do
  begin
    Texture_UnLoad(Textures[i]);
  end;
end;

//
Procedure jCanvasES2.Texture_Clear;
var
  i : Integer;
begin
  if not FInitialized then Exit;
  for i := 0 to TexturesCount-1 do
  begin
    //if Textures[i].Active then
    //begin
      Textures[i].Active := False;
      glDeleteTextures(1,@Textures[i].ID);
      //jGLSurfaceView_deleteTexture(FjEnv, FjObject ,Textures[i].ID);
    //end;
  end;
  TexturesCount:= 0;
end;

//
Procedure jCanvasES2.Request_GLThread;
begin
  if FInitialized then
     jGLSurfaceView_requestGLThread(FjEnv, FjObject);
end;

//
Procedure jCanvasES2.Update;
begin
  //eglSwapBuffers(EGLInfo.Display,EGLInfo.Surface);
end;

procedure jCanvasES2.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
      if AComponent = FImageList then
      begin
         FImageList:= nil;
      end;
  end;
end;

procedure jCanvasES2.SetImages(Value: jImageList);
begin
  if Value <> FImageList then
   begin
      if Assigned(FImageList) then
      begin
         FImageList.RemoveFreeNotification(Self); //remove free notification...
      end;
      FImageList:= Value;
      if Value <> nil then  //re- add free notification...
      begin
         Value.FreeNotification(self);
      end;
   end;
end;

procedure jCanvasES2.UpdateLParamWidth;
var
   side: TSide;
begin
  if jForm(Owner).ScreenStyle = gApp.Orientation then
      side:= sdW
  else
      side:= sdH;

  jGLSurfaceView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jCanvasES2.UpdateLParamHeight;
var
   side: TSide;
begin
  if jForm(Owner).ScreenStyle = gApp.Orientation then
    side:= sdH
  else
    side:= sdW;
  jGLSurfaceView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;

function jCanvasES2.GetWidth: integer;
begin
   Result:= FWidth;
   if FInitialized then
      Result:= jGLSurfaceView_getLParamWidth(FjEnv, FjObject )
end;

function jCanvasES2.GetHeight: integer;
begin
   Result:= FHeight;
   if FInitialized then
      Result:= jGLSurfaceView_getLParamHeight(FjEnv, FjObject );
end;

procedure jCanvasES2.UpdateLayout;
begin
   inherited UpdateLayout;
   UpdateLParamWidth;
   UpdateLParamHeight;
   jGLSurfaceView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
end;

end.

