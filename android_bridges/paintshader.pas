(*
    Unit       : PaintShader

    Author     : Kordal <A.V.Krivoshein>
    E-mail     : av@unimods.club
    Homepage   : http://unimods.club
    Version    : 0.01

    Description: PaintShader.pas is part of the JPaintShader graphics component
                 that  works  with the  JCanvas and  JDrawingView components to
                 expand  their  capabilities.  The component  includes a set of
                 functions that work with java classes:

                 BitmapShader,
                 ComposeShader,
                 LinearGradient,
                 RadialGradient,
                 SweepGradient.

    History    : 08.11.2019 - First public release.
*)

unit paintshader;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type
  TTileMode = (tmCLAMP, tmMIRROR, tmREPEAT);
  // https://developer.android.com/reference/android/graphics/PorterDuff.Mode.html
  TPorterDuff = (pdADD, pdDARKEN, pdDST, pdDST_ATOP, pdDST_IN, pdDST_OUT, pdDST_OVER, pdLIGHTEN,
                 pdMULTIPLY, pdOVERLAY, pdSCREEN, pdSRC, pdSRC_ATOP, pdSRC_IN, pdSRC_OUT, pdSRC_OVER, pdXOR);

  TGradientColors = array of TAlphaColor;
  TGradientPositions = array of Single;

  JPaintShader = class(JControl)
  private
    FShaderCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(Paint: JObject); reintroduce;
    procedure Bind(const ID: Integer);
    procedure Clear();
    procedure Combine(shdrA, shdrB: Integer; Mode: TPorterDuff; dstID: Integer);
    procedure Disable();
    function  GetColor(): Integer;
    procedure SetCount(Value: Integer);
    procedure SetIndex(Value: Integer);
    procedure SetPaint(Value: JObject);
    procedure SetIdentity(ID: Integer);
    procedure SetZeroCoords(ID: Integer);
    procedure SetMatrix(X, Y, scaleX, scaleY, Rotate: Single; ID: Integer);
    procedure SetRotate(Degree: Single; ID: Integer); overload;
    procedure SetRotate(Degree, PointX, PointY: Single; ID: Integer); overload;
    procedure SetScale(X, Y: Single; ID: Integer);
    procedure SetTranslate(X, Y: Single; ID: Integer);
    function NewBitmapShader(Bitmap: JOBject; tileX, tileY: TTileMode; ID: Integer=-1): Integer; overload;
    function NewBitmapShader(Bitmap: JOBject; tileX, tileY: TTileMode; scaleX, scaleY, Rotate: Single; ID: Integer=-1): Integer; overload;
    function NewLinearGradient(X0, Y0, X1, Y1: Single; Color0, Color1: TAlphaColor; tMode: TTileMode; ID: Integer=-1): Integer; overload;
    function NewLinearGradient(X0, Y0, X1, Y1: Single; Colors: TGradientColors; Positions: TGradientPositions; tMode: TTileMode; ID: Integer=-1): Integer; overload;
    function NewLinearGradient(X, Y, Wh, Ht, Rotate: Single; Color0, Color1: TAlphaColor; tMode: TTileMode; ID: Integer=-1): Integer; overload;
    function NewLinearGradient(X, Y, Wh, Ht, Rotate: Single; Colors: TGradientColors; Positions: TGradientPositions; tMode: TTileMode; ID: Integer=-1): Integer; overload;
    function NewRadialGradient(cX, cY, Radius: Single; cColor, eColor: TAlphaColor; tMode: TTileMode; ID: Integer=-1): Integer; overload;
    function NewRadialGradient(cX, cY, Radius: Single; Colors: TGradientColors; Stops: TGradientPositions; tMode: TTileMode; ID: Integer=-1): Integer; overload;
    function NewSweepGradient(cX, cY: Single; Color0, Color1: TAlphaColor; ID: Integer=-1): Integer; overload;
    function NewSweepGradient(cX, cY: Single; Colors: TGradientColors; Positions: TGradientPositions; ID: Integer=-1): Integer; overload;
  published
    property ShaderCount: Integer read FShaderCount write SetCount;
  end;

  function  jPaintShader_jCreate (env: PJNIEnv;_Self: int64; _Paint, this: jObject): jObject;
  procedure jPaintShader_SetPaint(env: PJNIEnv; _jpaintshader, _Paint: JObject);
  procedure jPaintShader_Combine (env: PJNIEnv; _jpaintshader: JObject; _shdrA, _shdrB: Integer; _Mode: JByte; _dstID: Integer);
  // gradients, bitmap shaders
  function  jPaintShader_NewBitmapShader  (env: PJNIEnv; _jpaintshader: JObject; _Bitmap: JOBject; _tileX, _tileY: JByte; _ID: Integer): Integer; overload;
  function  jPaintShader_NewBitmapShader  (env: PJNIEnv; _jpaintshader: JObject; _Bitmap: JOBject; _tileX, _tileY: JByte; _scaleX, _scaleY, _Rotate: Single; _ID: Integer): Integer; overload;
  function  jPaintShader_NewLinearGradient(env: PJNIEnv; _jpaintshader: JObject; _X0, _Y0, _X1, _Y1: Single; _Color0, _Color1: Integer; _tMode: JByte; _ID: Integer): Integer; overload;
  function  jPaintShader_NewLinearGradient(env: PJNIEnv; _jpaintshader: JObject; _X0, _Y0, _X1, _Y1: Single; _Colors: TGradientColors; _Positions: TGradientPositions; _tMode: JByte; _ID: Integer): Integer; overload;
  function  jPaintShader_NewLinearGradient(env: PJNIEnv; _jpaintshader: JObject; _X, _Y, _Wh, _Ht, _Rotate: Single; _Color0, _Color1: Integer; _tMode: JByte; _ID: Integer): Integer; overload;
  function  jPaintShader_NewLinearGradient(env: PJNIEnv; _jpaintshader: JObject; _X, _Y, _Wh, _Ht, _Rotate: Single; _Colors: TGradientColors; _Positions: TGradientPositions; _tMode: JByte; _ID: Integer): Integer; overload;
  function  jPaintShader_NewRadialGradient(env: PJNIEnv; _jpaintshader: JObject; _cX, _cY, _Radius: Single; _cColor, _eColor: Integer; _tMode: JByte; _ID: Integer): Integer; overload;
  function  jPaintShader_NewRadialGradient(env: PJNIEnv; _jpaintshader: JObject; _cX, _cY, _Radius: Single; _Colors: TGradientColors; _Stops: TGradientPositions; _tMode: JByte; _ID: Integer): Integer; overload;
  function  jPaintShader_NewSweepGradient (env: PJNIEnv; _jpaintshader: JObject; _cX, _cY: Single; _Color0, _Color1, _ID: Integer): Integer; overload;
  function  jPaintShader_NewSweepGradient (env: PJNIEnv; _jpaintshader: JObject; _cX, _cY: Single; _Colors: TGradientColors; _Positions: TGradientPositions; _ID: Integer): Integer; overload;
  // transformation
  procedure jPaintShader_SetMatrix    (env: PJNIEnv; _jpaintshader: JObject; _X, _Y, _scaleX, _scaleY, _Rotate: Single; _ID: Integer);
  procedure jPaintShader_SetRotate    (env: PJNIEnv; _jpaintshader: JObject; _Degree: Single; _ID: Integer); overload;
  procedure jPaintShader_SetRotate    (env: PJNIEnv; _jpaintshader: JObject; _Degree, _PointX, _PointY: Single; _ID: Integer); overload;
  procedure jPaintShader_SetScale     (env: PJNIEnv; _jpaintshader: JObject; _X, _Y: Single; _ID: Integer);
  procedure jPaintShader_SetTranslate (env: PJNIEnv; _jpaintshader: JObject; _X, _Y: Single; _ID: Integer);

const
  PorterDuff: record
    ADD, DARKEN, DST, DST_ATOP, DST_IN, DST_OUT, DST_OVER, LIGHTEN, MULTIPLY,
    OVERLAY, SCREEN, SRC, SRC_ATOP, SRC_IN, SRC_OUT, SRC_OVER, mXOR: TPorterDuff;
  end = (
    ADD: pdADD; DARKEN: pdDARKEN; DST: pdDST; DST_ATOP: pdDST_ATOP; DST_IN: pdDST_IN;
    DST_OUT: pdDST_OUT; DST_OVER: pdDST_OVER; LIGHTEN: pdLIGHTEN; MULTIPLY: pdMULTIPLY;
    OVERLAY: pdOVERLAY; SCREEN: pdSCREEN; SRC: pdSRC; SRC_ATOP: pdSRC_ATOP;
    SRC_IN: pdSRC_IN; SRC_OUT: pdSRC_OUT; SRC_OVER: pdSRC_OVER; mXOR: pdXOR;
  );

implementation

// -------------  jPaintShader  --------------
// -------------------------------------------
constructor JPaintShader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShaderCount := 6;
end;

destructor JPaintShader.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jni_free(gApp.jni.jEnv, FjObject);
       FjObject:= nil;
     end;
  end;
  // you others free code here...'
  inherited Destroy;
end;

procedure JPaintShader.Init(Paint: JObject);
begin
  if FInitialized then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  FjObject := jPaintShader_jCreate(gApp.jni.jEnv, Int64(Self), Paint, gApp.jni.jThis); //jSelf !
  FInitialized := True;
end;

procedure JPaintShader.SetPaint(Value: JObject);
begin
  if FInitialized then
    jPaintShader_SetPaint(gApp.jni.jEnv, FjObject, Value);
end;

procedure JPaintShader.SetCount(Value: Integer);
begin
  if FInitialized then
  begin
    FShaderCount := Value;
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetCount', Value);
  end;
end;

procedure JPaintShader.SetIndex(Value: Integer);
begin
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetIndex', Value);
end;

function JPaintShader.GetColor(): Integer;
begin
  if FInitialized then
    Result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetColor');
end;

procedure JPaintShader.Clear();
begin
  if FInitialized then
  //
end;

procedure JPaintShader.Combine(shdrA, shdrB: Integer; Mode: TPorterDuff; dstID: Integer);
begin
  if FInitialized then
    jPaintShader_Combine(gApp.jni.jEnv, FjObject, shdrA, shdrB, Byte(Mode), dstID);
end;

procedure JPaintShader.Bind(const ID: Integer);
begin
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'Bind', ID);
end;

procedure jPaintShader.Disable();
begin
  Bind(-1);
end;

procedure JPaintShader.SetIdentity(ID: Integer);
begin
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetIdentity', ID);
end;

procedure JPaintShader.SetZeroCoords(ID: Integer);
begin
  if FInitialized then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetZeroCoords', ID);
end;

procedure JPaintShader.SetMatrix(X, Y, scaleX, scaleY, Rotate: Single; ID: Integer);
begin
  if FInitialized then
    jPaintShader_SetMatrix(gApp.jni.jEnv, FjObject, X, Y, scaleX, scaleY, Rotate, ID);
end;

procedure JPaintShader.SetRotate(Degree: Single; ID: Integer);
begin
  if FInitialized then
    jPaintShader_SetRotate(gApp.jni.jEnv, FjObject, Degree, ID);
end;

procedure JPaintShader.SetRotate(Degree, PointX, PointY: Single; ID: Integer);
begin
  if FInitialized then
    jPaintShader_SetRotate(gApp.jni.jEnv, FjObject, Degree, PointX, PointY, ID);
end;

procedure JPaintShader.SetScale(X, Y: Single; ID: Integer);
begin
  if FInitialized then
    jPaintShader_SetScale(gApp.jni.jEnv, FjObject, X, Y, ID);
end;

procedure JPaintShader.SetTranslate(X, Y: Single; ID: Integer);
begin
  if FInitialized then
    jPaintShader_SetTranslate(gApp.jni.jEnv, FjObject, X, Y, ID);
end;

function JPaintShader.NewBitmapShader(Bitmap: JOBject; tileX, tileY: TTileMode; ID: Integer): Integer;
begin
  if FInitialized then
    Result := jPaintShader_NewBitmapShader(gApp.jni.jEnv, FjObject, Bitmap, Byte(tileX), Byte(tileY), ID);
end;

function JPaintShader.NewBitmapShader(Bitmap: JOBject; tileX, tileY: TTileMode; scaleX, scaleY, Rotate: Single; ID: Integer): Integer;
begin
  if FInitialized then
    Result := jPaintShader_NewBitmapShader(gApp.jni.jEnv, FjObject, Bitmap, Byte(tileX), Byte(tileY), scaleX, scaleY, Rotate, ID);
end;

function JPaintShader.NewLinearGradient(X0, Y0, X1, Y1: Single; Color0, Color1: TAlphaColor; tMode: TTileMode; ID: Integer): Integer;
begin
  if FInitialized then
    Result := jPaintShader_NewLinearGradient(gApp.jni.jEnv, FjObject, X0, Y0, X1, Y1, Color0, Color1, Byte(tMode), ID);
end;

function JPaintShader.NewLinearGradient(X0, Y0, X1, Y1: Single; Colors: TGradientColors; Positions: TGradientPositions; tMode: TTileMode; ID: Integer=-1): Integer;
begin
  if FInitialized then
    Result := jPaintShader_NewLinearGradient(gApp.jni.jEnv, FjObject, X0, Y0, X1, Y1, Colors, Positions, Byte(tMode), ID);
end;

function JPaintShader.NewLinearGradient(X, Y, Wh, Ht, Rotate: Single; Color0, Color1: TAlphaColor; tMode: TTileMode; ID: Integer): Integer;
begin
  if FInitialized then
    Result := jPaintShader_NewLinearGradient(gApp.jni.jEnv, FjObject, X, Y, Wh, Ht, Rotate, Color0, Color1, Byte(tMode), ID);
end;

function JPaintShader.NewLinearGradient(X, Y, Wh, Ht, Rotate: Single; Colors: TGradientColors; Positions: TGradientPositions; tMode: TTileMode; ID: Integer): Integer;
begin
  if FInitialized then
    Result := jPaintShader_NewLinearGradient(gApp.jni.jEnv, FjObject, X, Y, Wh, Ht, Rotate, Colors, Positions, Byte(tMode), ID);
end;

function JPaintShader.NewRadialGradient(cX, cY, Radius: Single; cColor, eColor: TAlphaColor; tMode: TTileMode; ID: Integer): Integer;
begin
  if FInitialized then
    Result := jPaintShader_NewRadialGradient(gApp.jni.jEnv, FjObject, cX, cY, Radius, cColor, eColor, Byte(tMode), ID);
end;

function JPaintShader.NewRadialGradient(cX, cY, Radius: Single; Colors: TGradientColors; Stops: TGradientPositions; tMode: TTileMode; ID: Integer): Integer;
begin
  if FInitialized then
    Result := jPaintShader_NewRadialGradient(gApp.jni.jEnv, FjObject, cX, cY, Radius, Colors, Stops, Byte(tMode), ID);
end;

function JPaintShader.NewSweepGradient(cX, cY: Single; Color0, Color1: TAlphaColor; ID: Integer): Integer;
begin
  if FInitialized then
    Result := jPaintShader_NewSweepGradient(gApp.jni.jEnv, FjObject, cX, cY, Color0, Color1, ID);
end;

function JPaintShader.NewSweepGradient(cX, cY: Single; Colors: TGradientColors; Positions: TGradientPositions; ID: Integer): Integer;
begin
  if FInitialized then
    Result := jPaintShader_NewSweepGradient(gApp.jni.jEnv, FjObject, cX, cY, Colors, Positions, ID);
end;

// -------- jPaintShader_JNI_Bridge ----------
// -------------------------------------------
function jPaintShader_jCreate(env: PJNIEnv; _Self: Int64; _Paint, this: JObject): jObject;
var
  jParams: array[0..1] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil;
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls := Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'jPaintShader_jCreate', '(JLjava/lang/Object;)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j := _Self;
  jParams[1].l := _Paint;

  Result := env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result := env^.NewGlobalRef(env, Result);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jPaintShader_SetPaint(env: PJNIEnv; _jpaintshader, _Paint: JObject);
var
  jParams: array[0..0] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass    = nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) or (_Paint = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'SetPaint', '(Landroid/graphics/Paint;)V'); // '(Ljava/lang/Object;)V'
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l := _Paint;

  env^.CallVoidMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jPaintShader_Combine(env: PJNIEnv; _jpaintshader: JObject; _shdrA, _shdrB: Integer; _Mode: JByte; _dstID: Integer);
var
  jParams: array[0..3] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'Combine', '(IIBI)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i := _shdrA;
  jParams[1].i := _shdrB;
  jParams[2].b := _Mode;
  jParams[3].i := _dstID;

  env^.CallVoidMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jPaintShader_NewBitmapShader(env: PJNIEnv; _jpaintshader: JObject; _Bitmap: JOBject; _tileX, _tileY: JByte; _ID: Integer): Integer;
var
  jParams: array[0..3] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil; 
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'NewBitmapShader', '(Landroid/graphics/Bitmap;BBI)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l := _Bitmap;
  jParams[1].b := _tileX;
  jParams[2].b := _tileY;
  jParams[3].i := _ID;

  Result := env^.CallIntMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jPaintShader_NewBitmapShader(env: PJNIEnv; _jpaintshader: JObject; _Bitmap: JOBject; _tileX, _tileY: JByte; _scaleX, _scaleY, _Rotate: Single; _ID: Integer): Integer;
var
  jParams: array[0..6] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil; 
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'NewBitmapShader', '(Landroid/graphics/Bitmap;BBFFFI)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l := _Bitmap;
  jParams[1].b := _tileX;
  jParams[2].b := _tileY;
  jParams[3].f := _scaleX;
  jParams[4].f := _scaleY;
  jParams[5].f := _Rotate;
  jParams[6].i := _ID;

  Result := env^.CallIntMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jPaintShader_NewLinearGradient(env: PJNIEnv; _jpaintshader: JObject; _X0, _Y0, _X1, _Y1: Single; _Color0, _Color1: Integer; _tMode: JByte; _ID: Integer): Integer;
var
  jParams: array[0..7] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil; 
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'NewLinearGradient', '(FFFFIIBI)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f := _X0;
  jParams[1].f := _Y0;
  jParams[2].f := _X1;
  jParams[3].f := _Y1;
  jParams[4].i := _Color0;
  jParams[5].i := _Color1;
  jParams[6].b := _tMode;
  jParams[7].i := _ID;

  Result := env^.CallIntMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jPaintShader_NewLinearGradient(env: PJNIEnv; _jpaintshader: JObject; _X0, _Y0, _X1, _Y1: Single; _Colors: TGradientColors; _Positions: TGradientPositions; _tMode: JByte; _ID: Integer): Integer;
var
  jParams : array[0..7] of JValue;
  jMethod : JMethodID = nil;
  jCls    : JClass = nil;
  clrArray: JByteArray;
  posArray: JByteArray;  
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'NewLinearGradient', '(FFFF[I[FBI)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  // gradient colors
  clrArray := env^.NewIntArray(env, Length(_Colors));  // allocate
  if clrArray = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  env^.SetIntArrayRegion(env, clrArray, 0, Length(_Colors), @_Colors[0]);
  // gradient positions
  posArray := env^.NewFloatArray(env, Length(_Positions));  // allocate
  if posArray = nil then begin env^.DeleteLocalRef(env, clrArray); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  env^.SetFloatArrayRegion(env, posArray, 0, Length(_Positions), @_Positions[0]);

  jParams[0].f := _X0;
  jParams[1].f := _Y0;
  jParams[2].f := _X1;
  jParams[3].f := _Y1;
  jParams[4].l := clrArray;
  jParams[5].l := posArray;
  jParams[6].b := _tMode;
  jParams[7].i := _ID;

  Result := env^.CallIntMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jParams[4].l);
  env^.DeleteLocalRef(env, jParams[5].l);
  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jPaintShader_NewLinearGradient(env: PJNIEnv; _jpaintshader: JObject; _X, _Y, _Wh, _Ht, _Rotate: Single; _Color0, _Color1: Integer; _tMode: JByte; _ID: Integer): Integer;
var
  jParams: array[0..8] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil;  
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'NewLinearGradient', '(FFFFFIIBI)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f := _X;
  jParams[1].f := _Y;
  jParams[2].f := _Wh;
  jParams[3].f := _Ht;
  jParams[4].f := _Rotate;
  jParams[5].i := _Color0;
  jParams[6].i := _Color1;
  jParams[7].b := _tMode;
  jParams[8].i := _ID;

  Result := env^.CallIntMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jPaintShader_NewLinearGradient(env: PJNIEnv; _jpaintshader: JObject; _X, _Y, _Wh, _Ht, _Rotate: Single; _Colors: TGradientColors; _Positions: TGradientPositions; _tMode: JByte; _ID: Integer): Integer;
var
  jParams : array[0..8] of JValue;
  jMethod : JMethodID = nil;
  jCls    : JClass = nil;
  clrArray: JByteArray;
  posArray: JByteArray;   
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'NewLinearGradient', '(FFFFF[I[FBI)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  // gradient colors
  clrArray := env^.NewIntArray(env, Length(_Colors));  // allocate
  if clrArray = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  env^.SetIntArrayRegion(env, clrArray, 0, Length(_Colors), @_Colors[0]);
  // gradient positions
  posArray := env^.NewFloatArray(env, Length(_Positions));  // allocate
  if posArray = nil then begin env^.DeleteLocalRef(env, clrArray); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  env^.SetFloatArrayRegion(env, posArray, 0, Length(_Positions), @_Positions[0]);

  jParams[0].f := _X;
  jParams[1].f := _Y;
  jParams[2].f := _Wh;
  jParams[3].f := _Ht;
  jParams[4].f := _Rotate;
  jParams[5].l := clrArray;
  jParams[6].l := posArray;
  jParams[7].b := _tMode;
  jParams[8].i := _ID;

  Result := env^.CallIntMethodA(env, _jpaintshader, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[5].l);
  env^.DeleteLocalRef(env, jParams[6].l);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jPaintShader_NewRadialGradient(env: PJNIEnv; _jpaintshader: JObject; _cX, _cY, _Radius: Single; _cColor, _eColor: Integer; _tMode: JByte; _ID: Integer): Integer;
var
  jParams: array[0..6] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil; 
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'NewRadialGradient', '(FFFIIBI)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _cX;
  jParams[1].f:= _cY;
  jParams[2].f:= _Radius;
  jParams[3].i:= _cColor;
  jParams[4].i:= _eColor;
  jParams[5].b:= _tMode;
  jParams[6].i:= _ID;

  Result := env^.CallIntMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);    

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jPaintShader_NewRadialGradient(env: PJNIEnv; _jpaintshader: JObject; _cX, _cY, _Radius: Single; _Colors: TGradientColors; _Stops: TGradientPositions; _tMode: JByte; _ID: Integer): Integer;
var
  jParams : array[0..6] of JValue;
  jMethod : JMethodID = nil;
  jCls    : JClass = nil;
  clrArray: JByteArray;
  posArray: JByteArray;   
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'NewRadialGradient', '(FFF[I[FBI)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  // gradient colors
  clrArray := env^.NewIntArray(env, Length(_Colors));  // allocate
  if clrArray = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  env^.SetIntArrayRegion(env, clrArray, 0, Length(_Colors), @_Colors[0]);
  // gradient positions
  posArray := env^.NewFloatArray(env, Length(_Stops));  // allocate
  if posArray = nil then begin env^.DeleteLocalRef(env, clrArray); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  env^.SetFloatArrayRegion(env, posArray, 0, Length(_Stops), @_Stops[0]);

  jParams[0].f:= _cX;
  jParams[1].f:= _cY;
  jParams[2].f:= _Radius;
  jParams[3].l:= clrArray;
  jParams[4].l:= posArray;
  jParams[5].b:= _tMode;
  jParams[6].i:= _ID;

  Result := env^.CallIntMethodA(env, _jpaintshader, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[3].l);
  env^.DeleteLocalRef(env, jParams[4].l);
  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jPaintShader_NewSweepGradient(env: PJNIEnv; _jpaintshader: JObject; _cX, _cY: Single; _Color0, _Color1, _ID: Integer): Integer;
var
  jParams: array[0..4] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil;  
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'NewSweepGradient', '(FFIII)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f := _cX;
  jParams[1].f := _cY;
  jParams[2].i := _Color0;
  jParams[3].i := _Color1;
  jParams[4].i := _ID;

  Result := env^.CallIntMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jPaintShader_NewSweepGradient(env: PJNIEnv; _jpaintshader: JObject; _cX, _cY: Single; _Colors: TGradientColors; _Positions: TGradientPositions; _ID: Integer): Integer;
var
  jParams : array[0..4] of JValue;
  jMethod : JMethodID = nil;
  jCls    : JClass = nil;
  clrArray: JByteArray;
  posArray: JByteArray; 
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'NewSweepGradient', '(FF[I[FI)I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  // gradient colors
  clrArray := env^.NewIntArray(env, Length(_Colors));  // allocate
  if clrArray = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  env^.SetIntArrayRegion(env, clrArray, 0, Length(_Colors), @_Colors[0]);
  // gradient positions
  posArray := env^.NewFloatArray(env, Length(_Positions));  // allocate
  if posArray = nil then begin env^.DeleteLocalRef(env, clrArray); env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;
  env^.SetFloatArrayRegion(env, posArray, 0, Length(_Positions), @_Positions[0]);

  jParams[0].f:= _cX;
  jParams[1].f:= _cY;
  jParams[2].l := clrArray;
  jParams[3].l := posArray;
  jParams[4].i := _ID;

  Result := env^.CallIntMethodA(env, _jpaintshader, jMethod, @jParams);

  env^.DeleteLocalRef(env, jParams[2].l);
  env^.DeleteLocalRef(env, jParams[3].l);
  env^.DeleteLocalRef(env, jCls);     

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jPaintShader_SetMatrix(env: PJNIEnv; _jpaintshader: JObject; _X, _Y, _scaleX, _scaleY, _Rotate: Single; _ID: Integer);
var
  jParams: array[0..5] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil; 
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'SetMatrix', '(FFFFFI)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f := _X;
  jParams[0].f := _Y;
  jParams[0].f := _scaleX;
  jParams[0].f := _scaleY;
  jParams[0].f := _Rotate;
  jParams[0].i := _ID;

  env^.CallVoidMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jPaintShader_SetRotate(env: PJNIEnv; _jpaintshader: JObject; _Degree: Single; _ID: Integer);
var
  jParams: array[0..1] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil; 
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'SetRotate', '(FI)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f := _Degree;
  jParams[1].i := _ID;

  env^.CallVoidMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jPaintShader_SetRotate(env: PJNIEnv; _jpaintshader: JObject; _Degree, _PointX, _PointY: Single; _ID: Integer);
var
  jParams: array[0..3] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil; 
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'SetRotate', '(FFFI)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f := _Degree;
  jParams[1].f := _PointX;
  jParams[2].f := _PointY;
  jParams[3].i := _ID;

  env^.CallVoidMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jPaintShader_SetScale(env: PJNIEnv; _jpaintshader: JObject; _X, _Y: Single; _ID: Integer);
var
  jParams: array[0..2] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil; 
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'SetScale', '(FFI)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f := _X;
  jParams[1].f := _Y;
  jParams[2].i := _ID;

  env^.CallVoidMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jPaintShader_SetTranslate(env: PJNIEnv; _jpaintshader: JObject; _X, _Y: Single; _ID: Integer);
var
  jParams: array[0..4] of JValue;
  jMethod: JMethodID = nil;
  jCls   : JClass = nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jpaintshader = nil) then exit;
  jCls := env^.GetObjectClass(env, _jpaintshader);
  if jCls = nil then goto _exceptionOcurred;
  jMethod := env^.GetMethodID(env, jCls, 'SetTranslate', '(FFI)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f := _X;
  jParams[1].f := _Y;
  jParams[2].i := _ID;

  env^.CallVoidMethodA(env, _jpaintshader, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
