//
// OpenGL ES v1.0 Canvas for Pascal
//
//   Compiler        
//   ---------------------------------------------------------------------------
//                   Free Pascal Compiler FPC 2.7.1
//                   Delphi 7~XE4 / XE5 in near future 
//
//   Developer
//   ---------------------------------------------------------------------------
//                   Simon,Choi / Choi,Won-sik , 최원식옹
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
//                   http://www.gisdeveloper.co.kr/category/프로그래밍/OpenGL
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
//    Engine       : http://gfx.sio2interactive.com/
//    Book         : OpenGL ES 2 for Android / Kevin Brothaler
//
unit Laz_And_GLESv1_Canvas; {start: 2013-10-26: the simonsayz's "And_GLESv1_Canvas.pas" modified by jmpessoa}
                            {ver0.2_from_0.22 * 11-october-2013}

{$mode delphi}

interface

uses ctypes,SysUtils,Classes,Math,
     And_jni,And_jni_Bridge, Laz_And_Controls, AndroidWidget,
     And_lib_Image, Laz_And_GLESv1_Canvas_h;

// GL_OES_point_sprite
const
  GL_OES_point_sprite = 1;

Type
 TM4x4       = Array[0..3,0..3] of Single;
 TgfRGBA     = Record
                R,G,B,A : Single;
               End;
 TgfXYZW     = record
                X : Single;
                Y : Single;
                Z : Single;
                W : Single;
               end;
 TgfXYZ      = record
                X : Single;
                Y : Single;
                Z : Single;
               end;
 TglArcBall  = Record
                Width,Height   : Single;
                v3sav          : TgfXYZ;
                mRot,  mRotSav : TM4x4;
                qRot,  qRotSav : TgfXYZW;
                aRot           : TgfXYZ;
                Downed         : Boolean;
               End;

Const
 cIM4   : TM4x4 = ( (1,0,0,0),
                    (0,1,0,0),
                    (0,0,1,0),
                    (0,0,0,1) );

// OpenGL ES v1.1 Helper Function
Function  _glRGBA              ( R,G,B,A : Single  ) : TgfRGBA;
Procedure _glLighting          ( Active : Boolean );
Procedure _gluPerspective      ( fovy,aspect,zNear,zFar : Single);
Function  _glTexture_Load_wPas (ImgName : String; Var Img : GLuint) : Boolean;

//Function  _glTexture_Load_wJava(env:PJNIEnv; this:jobject; ImgName : String; Var Img : GLuint) : Boolean;
function _glTexture_Load_wJava(env: PJNIEnv; _jcanvases2: JObject;_fullFilename: string; var Img : GLuint): boolean;

Function  _glTexture_Free      (Var Img : GLuint) : Boolean;
//
Function  mulM4x4  (const A,B : TM4x4 ) : TM4x4;
Function  TranM4x4 (const M   : TM4x4 ) : TM4x4;
//
Procedure _glArcBall_Init(var ArcBall : TglArcBall);
Procedure _glArcBall_Down(var ArcBall : TglArcBall; Width,Height,X,Y : Single);
Procedure _glArcBall_Move(var ArcBall : TglArcBall; X,Y : Single);
Procedure _glArcBall_Up  (var ArcBall : TglArcBall);

//------------------------------------------------------------------------------
//
//  GLCanvas for Cross platform
//
//------------------------------------------------------------------------------

Const
 cTextureMax     = 100;
 cCull_YES       = True;
 cCull_NO        = False;

Type
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
 TxgProjection = (xp2D,xp3D);
 TxgTextures   = Array[0..cTextureMax-1] of TxgElement;

//
jCanvasES1 = class(jGLViewEvent)
 private
  FAutoRefresh: boolean;        // 60Frame/s Refresh

  FImageList : jImageList;      //by jmpessoa
  //
  FAlpha      : Single;

  procedure SetImages(Value: jImageList);   //by jmpessoa


  Procedure SetVisible    (Value : Boolean);
  function GetVisible: Boolean;

  Procedure SetAutoRefresh(Value : boolean);

  Procedure Texture_Load  ( var Texture : TxgElement; filename : String; lang : TLanguage = tJava);
  Procedure Texture_UnLoad( var Texture : TxgElement );
  procedure UpdateLParamHeight;
  procedure UpdateLParamWidth;
 protected
  Procedure SetAlpha      ( alpha : Single      );
  Procedure SetVertex     ( ptr : Pointer       );
  Procedure SetColor      ( ptr : Pointer       );
  Procedure SetTexture    ( ptr : Pointer       );
  //
  Procedure BindTexture   ( const Texture : TxgElement );
  procedure Notification(AComponent: TComponent; Operation: TOperation); override; //by jmpessoa

 public
  Textures : TxgTextures; // Texture
  TexturesCount: integer; //by jmpessoa
  //
  Constructor Create(AOwner: TComponent); override;
  Destructor  Destroy; override;
  procedure Init(refApp: jApp); override;
  Procedure UpdateLayout; override;

  function GetWidth: integer; override;
  function GetHeight: integer; override;

  //
  Procedure Screen_Setup(w,h        : Integer;
                         Projection : TxgProjection = xp2D;
                         CullFace   : Boolean = True);

  Procedure Screen_Clear(r,g,b,a : Single);
  //
  Procedure idModelView;
  Procedure Translate   (const X,Y,Z : Single);
  Procedure Rotate      (const Angle,X,Y,Z : Single);
  Procedure Scale       (const X,Y,Z : single);
  //
  Procedure SetMask     (Layer : Integer; MaskMode : TxgMaskMode );
  //
  Procedure DrawArray   (aVertex    : Pointer;
                         aColor     : Pointer;
                         aTexture   : Pointer;
                         tTexture   : pxgElement;
                         Count      : Integer);
  //
  Procedure Texture_Load_All(lang : TLanguage = tJava);
  Procedure Texture_UnLoad_All;
  Procedure Texture_Clear;
  //
  Procedure Request_GLThread;
  //
  Procedure Update;
  Procedure Refresh;
  // Property
  Property Alpha       : Single        read FAlpha       write SetAlpha;
  //
  published
   property AutoRefresh : boolean       read FAutoRefresh write SetAutoRefresh;
   property Visible     : Boolean       read GetVisible     write SetVisible;
   property Images      : jImageList read FImageList write SetImages;  //by jmpessoa
 end;


implementation

const
  CrLf = #13#10;

Function _glRGBA ( R,G,B,A : Single  ) : TgfRGBA;
 begin
  Result.R := R;
  Result.G := G;
  Result.B := B;
  Result.A := A;
 end;

// linklib libc
//function _tan(_para1:double):double;cdecl;external 'libc.so' name 'tan';

function _tan(x : float) : float;
  var
    _sin,_cos : float;
  begin
    sincos(x,_sin,_cos);
    _tan:=_sin/_cos;
  end;

//
Procedure _gluPerspective( fovy,aspect,zNear,zFar : Single);
 Var
  xmin,xmax,ymin,ymax : GLFloat;
 begin
  // Start in projection mode.
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  ymax := zNear * tan(fovy * PI / 360.0);
  ymin := -ymax;
  xmin :=  ymin * aspect;
  xmax :=  ymax * aspect;
  glFrustumf(xmin, xmax, ymin, ymax, zNear, zFar);
 end;

Procedure _glLighting( Active : Boolean );
 Const
  LightSpc : Array [0..3] of glFloat = ( 0.1, 0.1, 0.1, 1.0 ); //
  LightAmb : Array [0..3] of GLfloat = ( 0.5, 0.5, 0.5, 1.0 ); //
  LightDif : Array [0..3] of GLfloat = ( 1.0, 1.0, 1.0, 1.0 ); //
  LightPos : Array [0..3] of GLfloat = ( 0.0, 0.0, 2.0, 1.0 ); //

 begin
  Case Active of
   True  : begin
            glLightfv(GL_LIGHT1, GL_POSITION, @LightPos);   // Set Light1 Position
            glLightfv(GL_LIGHT1, GL_AMBIENT , @LightAmb);   // Set Light1 Ambience
            glLightfv(GL_LIGHT1, GL_DIFFUSE , @LightDif);   // Set Light1 Diffuse
            glLightfv(GL_LIGHT1, GL_SPECULAR, @LightSpc);   // Set Light1 Specular
            glEnable (GL_LIGHT1);                           // Enable Light1
            glEnable (GL_LIGHTING);                         // Enable Lighting
           end;
   False : begin
            glDisable(GL_LIGHT1);
            glDisable(GL_LIGHTING);
           end;
  End;
 end;
  
// jpg, png Only
Function _glTexture_Load_wPas(ImgName : String; Var Img : GLuint) : Boolean;
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
  //
  glGenTextures  (1,Img);
  glBindTexture  (GL_Texture_2D,Img);
  glTexparameteri(GL_Texture_2D,GL_Texture_Min_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Mag_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S    , GL_Clamp_To_Edge);
  glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T    , GL_Clamp_To_Edge);
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

function _glTexture_Load_wJava(env: PJNIEnv; _jcanvases2: JObject;_fullFilename: string; var Img : GLuint): boolean;
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

  glGenTextures  (1,Img);
  glBindTexture (GL_Texture_2D,Img);
  glTexparameteri(GL_Texture_2D,GL_Texture_Min_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Mag_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S    , GL_Clamp_To_Edge);
  glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T    , GL_Clamp_To_Edge);
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
//
Function _glTexture_Load_wJava(env:PJNIEnv;this:jobject;ImgName : String; Var Img : GLuint) : Boolean;
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

  PixelFormat := GL_RGBA;
  //
  glGenTextures (1,Img);
  glBindTexture (GL_Texture_2D,Img);
  glTexparameteri(GL_Texture_2D,GL_Texture_Min_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Mag_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S    , GL_Clamp_To_Edge);
  glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T    , GL_Clamp_To_Edge);
  glTexImage2D  (GL_Texture_2D,
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
//
// Math & ArcBall
//
//-----------------------------------------------------------------------------

//
Function  MulM4x4( const A,B : TM4x4 ) : TM4x4;
 Var
  i,j : Integer;
 begin
  For i := 0 to 3 do
   For j := 0 to 3 do
    Result[i,j] := A[i,0]*B[0,j]+ A[i,1]*B[1,j]+ A[i,2]*B[2,j]+  A[i,3]*B[3,j];
 end;

// Transpose
Function  TranM4x4 (const M : TM4x4) : TM4x4;
 Var
  i,j : Integer;
 begin
  For i := 0 to 2 do
   For j := 0 to 2 do
    Result[i,j] := M[j,i];
 end;

//
Function mRadToDeg(const XYZ : TgfXYZ) : TgfXYZ;
 begin
  Result.X := XYZ.X * (180/pi);
  Result.Y := XYZ.Y * (180/pi);
  Result.Z := XYZ.Z * (180/pi);
 end;

//
Function mXY2Sphere(W,H,X,Y : Single): TgfXYZ;
 var
  lmag, lScale: Single;
  XYZ : TgfXYZ;
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
function mXYZ2Quaternion(const XYZFrom, XYZTo: TgfXYZ): TgfXYZW;
 begin
  Result.X := XYZFrom.Y * XYZTo.Z - XYZFrom.Z * XYZTo.Y;
  Result.Y := XYZFrom.Z * XYZTo.X - XYZFrom.X * XYZTo.Z;
  Result.Z := XYZFrom.X * XYZTo.Y - XYZFrom.Y * XYZTo.X;
  Result.W := XYZFrom.X * XYZTo.X + XYZFrom.Y * XYZTo.Y + XYZFrom.Z * XYZTo.Z;
 end;

//
function mQuaternionMul(const Ql,Qr: TgfXYZW): TgfXYZW;
 begin
  Result.x := qL.w * qR.x + qL.x * qR.w + qL.y * qR.z - qL.z * qR.y;
  Result.y := qL.w * qR.y + qL.y * qR.w + qL.z * qR.x - qL.x * qR.z;
  Result.z := qL.w * qR.z + qL.z * qR.w + qL.x * qR.y - qL.y * qR.x;
  Result.w := qL.w * qR.w - qL.x * qR.x - qL.y * qR.y - qL.z * qR.z;
 end;

function  mQuaternionConjugate(const Q: TgfXYZW): TgfXYZW;
 begin
  Result.X := -Q.X;
  Result.Y := -Q.Y;
  Result.Z := -Q.Z;
  Result.W :=  Q.W;
 end;

//
function mQuaternion2Mat(const Q: TgfXYZW): TM4x4;
 var
  M : TgfXYZW;
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
Function mMatToEulerXYZ(const M : TM4x4) : TgfXYZ;
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
function  mQuaternionToEulerXYZ(const Q : TgfXYZW) : TgfXYZ;
 begin
  Result := mMatToEulerXYZ(mQuaternion2Mat(Q));
 end;

Procedure _glArcBall_Init (var ArcBall : TglArcBall);
 begin
  FillChar(ArcBall.V3sav ,SizeOf(ArcBall.V3sav),#0);
  FillChar(ArcBall.aRot  ,SizeOf(ArcBall.aRot ),#0);
  ArcBall.mRot    := cIM4;
  ArcBall.mRotSav := cIM4;
  FillChar(ArcBall.qRot   ,SizeOf(ArcBall.qRot   ),#0);
  ArcBall.qRot.W    := 1;
  FillChar(ArcBall.qRotSav,SizeOf(ArcBall.qRotSav),#0);
  ArcBall.qRotSav.W := 1;
 end;

procedure _glArcBall_Down (var ArcBall: TglArcBall; Width,Height,X,Y: Single);
begin
  ArcBall.Downed  := True;
  ArcBall.Width   := Width;
  ArcBall.Height  := Height;
  ArcBall.v3sav   := mXY2Sphere(Width,Height,X,Y);
  ArcBall.mRotSav := ArcBall.mRot;
  ArcBall.qRotSav := ArcBall.qRot;
end;

procedure _glArcBall_Move(var ArcBall : TglArcBall; X,Y : Single);
var
  XYZ  : TgfXYZ;
  XYZW : TgfXYZW;
begin
  if not ArcBall.Downed then Exit;
  //  Mat-> Euler | glRotate(AngleX,1,0,0) ...
  XYZ          := mXY2Sphere       (ArcBall.Width,ArcBall.Height,X ,Y );
  XYZW         := mXYZ2Quaternion  (XYZ,ArcBall.v3sav);
  ArcBall.mRot := mQuaternion2Mat  (XYZW);
  ArcBall.mRot := mulM4x4          (ArcBall.mRotSav,ArcBall.mRot);
  //
  XYZ          := mMatToEulerXYZ   (ArcBall.mRot);
  XYZ          := mRadToDeg        (XYZ);
  ArcBall.aRot := XYZ;
end;

Procedure _glArcBall_Up(var ArcBall : TglArcBall);
begin
  ArcBall.Downed := False;
end;

//-----------------------------------------------------------------------------
//
//
//
//-----------------------------------------------------------------------------

Const
 cShaderHelp     = '//';
 cShaderVertex   = '[Vertex:';
 cShaderFragment = '[Fragment:';
 cCrLf           = #13#10;
 czNear          =    0.1;
 czFar           = 1000.0;
 cfieldOfView    =   60.0;

//------------------------------------------------------------------------------
// jCanvasES1
//------------------------------------------------------------------------------

Constructor jCanvasES1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Init
  FAutoRefresh := False;
  FillChar( Textures, SizeOf(Textures), #0);
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

Destructor jCanvasES1.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
        if FjObject  <> nil then
        begin
          jGLSurfaceView_Free(FjEnv, FjObject );
          FjObject := nil;
        end;
  end;
  //FillChar(Textures, SizeOf(Textures), #0);
  inherited Destroy;
end;

Procedure jCanvasES1.Init(refApp: jApp);
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  FjObject  := jGLSurfaceView_Create1(FjEnv, FjThis, Self, cjOpenGLESv1);
  jGLSurfaceView_setParent(FjEnv, FjObject , FjPRLayout);
  jGLSurfaceView_setId(FjEnv, FjObject , Self.Id);

  jGLSurfaceView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
  FInitialized:= True;
end;

Procedure jCanvasES1.SetVisible  (Value : Boolean);
 begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject , FVisible);
 end;

function jCanvasES1.GetVisible: Boolean;
begin
  Result:= FVisible;
end;

procedure jCanvasES1.Refresh;
begin
   if FInitialized then
      jGLSurfaceView_Refresh(FjEnv, FjObject );
end;

Procedure jCanvasES1.SetAutoRefresh(Value: boolean);
begin
  FAutoRefresh := Value;
  if FInitialized then
     jGLSurfaceView_SetAutoRefresh(FjEnv, FjObject , FAutoRefresh);
end;

//
Procedure jCanvasES1.SetAlpha ( alpha : Single );
begin
  if not FInitialized then Exit;
  glColor4f(alpha,alpha,alpha,alpha);
end;

//
Procedure jCanvasES1.SetVertex ( ptr : Pointer );
begin
  if not FInitialized then Exit;
  case ptr = nil of
   True  : glDisableClientState(GL_VERTEX_ARRAY);
   False : begin
            glEnableClientState(GL_VERTEX_ARRAY);
            glVertexPointer    (3, GL_FLOAT, 0, ptr);
           end;
  end;
end;

//
Procedure jCanvasES1.SetColor ( ptr : Pointer );
begin
  if not FInitialized then Exit;
  case ptr = nil of
   True  : glDisableClientState(GL_COLOR_ARRAY);
   False : begin
             glEnableClientState(GL_COLOR_ARRAY);
             glColorPointer     (4, GL_FLOAT, 0, ptr);
           end;
  end;
end;

//
Procedure jCanvasES1.SetTexture ( ptr : Pointer );
begin
  if not FInitialized then Exit;
  case ptr = nil of
   True  : glDisableClientState(GL_TEXTURE_COORD_ARRAY);
   False : begin
            glEnableClientState(GL_TEXTURE_COORD_ARRAY);
            glTexCoordPointer  (2, GL_FLOAT, 0, ptr);
           end;
  end;
end;

// Ref. NPOT
//      http://blog.naver.com/PostView.nhn?blogId=sadiles&logNo=10085169403
Procedure jCanvasES1.BindTexture( const Texture : TxgElement );
begin
  if not FInitialized then Exit;
  // glActiveTexture(TextureID);
  If not(Texture.Active) then Exit;
  glBindTexture(GL_TEXTURE_2D,Texture.ID);

  glTexparameteri(GL_Texture_2D,GL_Texture_Min_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Mag_Filter, GL_Linear);
  glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_S    , GL_Clamp_To_Edge);
  glTexparameteri(GL_Texture_2D,GL_Texture_Wrap_T    , GL_Clamp_To_Edge);
end;

//
Procedure jCanvasES1.Screen_Setup(w,h : Integer;
                                  Projection : TxgProjection = xp2D;
                                  CullFace   : Boolean = True);
begin
  if not FInitialized then Exit;
  glViewPort (0,0,w,h);
  //
  Case Projection of
   xp2D : begin
           glMatrixMode  (GL_PROJECTION);
           glLoadIdentity();
          end;
   xp3D : _gluPerspective(cfieldOfView,w/h,czNear,czFar);
  End;
  //
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  //
  Case CullFace of
   True : glEnable  (GL_CULL_FACE);
   False: glDisable (GL_CULL_FACE);
  End;
  //
  glShadeModel(GL_SMOOTH);
  glEnable    (GL_TEXTURE_2D);        // Enable 2D Texture Mapping
  glEnable    (GL_BLEND);             // Enable Blending
  glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
end;

//
Procedure jCanvasES1.Screen_Clear(r,g,b,a : Single);
 begin
  if not FInitialized then Exit;
  //
  glClearColor(r, g, b, a); // BackGround Color
  glClear     (GL_COLOR_BUFFER_BIT or
               GL_DEPTH_BUFFER_BIT or
               GL_STENCIL_BUFFER_BIT);
 end;

//
Procedure jCanvasES1.idModelView;
begin
  if not FInitialized then Exit;
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
end;

//
Procedure jCanvasES1.Translate (const X,Y,Z : Single);
begin
  if not FInitialized then Exit;
  glTranslatef (X,Y,Z);
end;

//
Procedure jCanvasES1.Rotate(const Angle,X,Y,Z : Single);
begin
  if not FInitialized then Exit;
  glRotatef (Angle,X,Y,Z);
end;

//
Procedure jCanvasES1.Scale (const X,Y,Z : Single);
begin
  if not FInitialized then Exit;
  glScalef (X,Y,Z);
end;

//
Procedure jCanvasES1.SetMask (Layer : Integer; MaskMode : TxgMaskMode );
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
Procedure jCanvasES1.DrawArray( aVertex    : Pointer;
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

//
Procedure jCanvasES1.Texture_Load(var Texture : TxgElement; filename: string; lang: TLanguage = tJava);
begin
  if not FInitialized then Exit;
  case lang of
     tJava : begin
                //Texture.Active :=        _glTexture_Load_wJava(gApp.Jni.jEnv, gApp.Jni.jThis, gApp.Path.Dat+'/'+filename, Texture.ID);
                  Texture.Active :=        _glTexture_Load_wJava(FjEnv, FjObject, gApp.Path.Dat+'/'+filename, Texture.ID);
             end;
     tPascal : Texture.Active := _glTexture_Load_wPas(filename, Texture.ID);
  end;
end;

Procedure jCanvasES1.Texture_Load_All(lang: TLanguage = tJava);
var
  i: integer;
begin
  if not FInitialized then Exit;
  if TexturesCount > 0 then Texture_Clear;
  if FImageList <> nil then FImageList.Init(gApp);  //***
  for i:= 0 to FImageList.Images.Count - 1 do
  begin
     if (FImageList.Images.Strings[i] <> '') and (FImageList.Images.Strings[i] <> 'null') then
     begin
       Texture_Load(Textures[i], FImageList.GetImageByIndex(i), lang); //Texture_Load(Textures[i], FImageList.Images.Strings[i], lang);
       Inc(TexturesCount);
     end;
  end;
end;

Procedure jCanvasES1.Texture_UnLoad( var Texture : TxgElement );
begin
  if not FInitialized then Exit;
  case Texture.Active of
   True : begin
             glDeleteTextures(1, @Texture.ID );
             //jGLSurfaceView_deleteTexture(gApp.Jni.jEnv, FjObject ,Texture.Id);
          end;
   False:  ; //dbg('Delete Texture Skip ' + IntToStr(Texture.ID) );
  end;
  Texture.Active := False;
end;

Procedure jCanvasES1.Texture_UnLoad_All;
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
Procedure jCanvasES1.Texture_Clear;
var
  i: Integer;
begin
  if not FInitialized then Exit;
  for i := 0 to TexturesCount -1 do
  begin
    //if Textures[i].Active then
    //begin
     //dbg('DeleteTextures' + IntToStr(i) + ' ' + IntToStr( Textures[i].ID ) );
      glDeleteTextures(1,@Textures[i].ID);
      Textures[i].Active := False;
    //end;
  end;
  TexturesCount:= 0;
end;

//
Procedure jCanvasES1.Request_GLThread;
begin
 if FInitialized then
    jGLSurfaceView_requestGLThread(FjEnv, FjObject);
end;

//
Procedure jCanvasES1.Update;
begin
  //eglSwapBuffers(EGLInfo.Display,EGLInfo.Surface);
end;

procedure jCanvasES1.Notification(AComponent: TComponent; Operation: TOperation);
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

procedure jCanvasES1.SetImages(Value: jImageList);
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

procedure jCanvasES1.UpdateLParamWidth;
var
   side: TSide;
begin
    if jForm(Owner).ScreenStyle = gApp.Orientation then
      side:= sdW
   else
      side:= sdH;
   jGLSurfaceView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jCanvasES1.UpdateLParamHeight;
var
   side: TSide;
begin
   if jForm(Owner).ScreenStyle = gApp.Orientation then
      side:= sdH
   else
      side:= sdW;
  jGLSurfaceView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, side));
end;

function jCanvasES1.GetWidth: integer;
begin
   Result:= FWidth;
   if FInitialized then
   begin
      Result:= jGLSurfaceView_getLParamWidth(FjEnv, FjObject )
   end;
end;

function jCanvasES1.GetHeight: integer;
begin
   Result:= FHeight;
   if FInitialized then
      Result:= jGLSurfaceView_getLParamHeight(FjEnv, FjObject );
end;

procedure jCanvasES1.UpdateLayout;
begin
   inherited UpdateLayout;
   UpdateLParamWidth;
   UpdateLParamHeight;
   jGLSurfaceView_setLayoutAll(FjEnv, FjObject , Self.AnchorId);
end;

end.

