unit gdxshaperenderer;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TGDXShapeType = (stFilled);

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/22/2019 18:55:32]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

{ jGdxShapeRenderer }

jGdxShapeRenderer = class(jControl)
 private
    FMinWorldX: single;
    FMaxWorldX: single;
    FMinWorldY: single;
    FMaxWorldY: single;
    FScaleX: single;
    FScaleY: single;

    FVPWidth:  integer;
    FVPHeight: integer;
    FVPX:  integer;
    FVPY: integer;

    FScreenHeight: integer;
    FScreenWidth: integer;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetProjectionMatrix(_matrix4: jObject);
    procedure BeginDraw(_shapeType: TGDXShapeType);
    procedure EndDraw();
    procedure SetColor(_red: integer; _green: integer; _blue: integer; _alpha: integer);
    procedure Rect(_x: single; _y: single; _width: integer; _height: integer);
    procedure Rect2(_x1: single; _y1: single; _x2: single; _y2: single);
    procedure Dispose();

    function GetViewportX(_worldX: single; _minWorldX: single; _maxWorldX: single; _viewportWidth: integer): integer; overload;
    function GetViewportY(_worldY: single; _minWorldY: single; _maxWorldY: single; _viewportHeight: integer): integer;  overload;

    procedure SetViewportSize(_width: single; _height: single);
    procedure SetViewportPosition(_x: single; _y: single);

    procedure SetViewportScaleXY(minX: single; maxX: single; minY: single; maxY: single);
    function GetViewportY(_worldY: single): integer; overload;
    function GetViewportX(_worldX: single): integer; overload;

    function GetWorldY(_viewportY:integer): single;
    function GetWorldX(_viewportX:integer): single;


    property ScreenHeight: integer read FScreenHeight write FScreenHeight;
    property ScreenWidth: integer read FScreenWidth write FScreenWidth;

 published

end;

function jGdxShapeRenderer_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGdxShapeRenderer_jFree(env: PJNIEnv; _jgdxshaperenderer: JObject);
procedure jGdxShapeRenderer_SetProjectionMatrix(env: PJNIEnv; _jgdxshaperenderer: JObject; _matrix4: jObject);
procedure jGdxShapeRenderer_BeginDraw(env: PJNIEnv; _jgdxshaperenderer: JObject; _shapeType: integer);
procedure jGdxShapeRenderer_EndDraw(env: PJNIEnv; _jgdxshaperenderer: JObject);
procedure jGdxShapeRenderer_SetColor(env: PJNIEnv; _jgdxshaperenderer: JObject; _red: integer; _green: integer; _blue: integer; _alpha: integer);
procedure jGdxShapeRenderer_Rect(env: PJNIEnv; _jgdxshaperenderer: JObject; _x: single; _y: single; _width: integer; _height: integer);
procedure jGdxShapeRenderer_Dispose(env: PJNIEnv; _jgdxshaperenderer: JObject);

implementation

{---------  jGdxShapeRenderer  --------------}

constructor jGdxShapeRenderer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jGdxShapeRenderer.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jFree();
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jGdxShapeRenderer.Init;
begin

  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jGdxShapeRenderer.jCreate(): jObject;
begin
   Result:= jGdxShapeRenderer_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jGdxShapeRenderer.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxShapeRenderer_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jGdxShapeRenderer.SetProjectionMatrix(_matrix4: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxShapeRenderer_SetProjectionMatrix(gApp.jni.jEnv, FjObject, _matrix4);
end;

procedure jGdxShapeRenderer.BeginDraw(_shapeType: TGDXShapeType);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxShapeRenderer_BeginDraw(gApp.jni.jEnv, FjObject, Ord(_shapeType));
end;

procedure jGdxShapeRenderer.EndDraw();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxShapeRenderer_EndDraw(gApp.jni.jEnv, FjObject);
end;

procedure jGdxShapeRenderer.SetColor(_red: integer; _green: integer; _blue: integer; _alpha: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxShapeRenderer_SetColor(gApp.jni.jEnv, FjObject, _red ,_green ,_blue ,_alpha);
end;

procedure jGdxShapeRenderer.Rect(_x: single; _y: single; _width: integer; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxShapeRenderer_Rect(gApp.jni.jEnv, FjObject, _x ,_y ,_width ,_height);
end;

procedure jGdxShapeRenderer.Rect2(_x1: single; _y1: single; _x2: single; _y2: single);
var
  w: integer;
  h: integer;
begin

  w:= Abs(Trunc(_x2 - _x1));
  h:= Abs(Trunc(_y2 - _y1));

  if FInitialized then
     jGdxShapeRenderer_Rect(gApp.jni.jEnv, FjObject, _x1,_y1, w, h);

end;

procedure jGdxShapeRenderer.Dispose();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxShapeRenderer_Dispose(gApp.jni.jEnv, FjObject);
end;

procedure jGdxShapeRenderer.SetViewportScaleXY(minX: single; maxX: single; minY: single; maxY: single);
begin
    FMinWorldX:= minX;
    FMaxWorldX:= maxX;
    FMinWorldY:= minY;
    FMaxWorldY:= maxY;
    FScaleX:= 0;
    if (maxX-minX) <> 0 then FScaleX:=  (FVPWidth)/(maxX-minX);

    FScaleY:= 0;
    if (maxY-minY) <> 0 then FScaleY:= -(FVPHeight-10)/(maxY-minY);
end;

function jGdxShapeRenderer.GetViewportX(_worldX: single): integer;
begin
  //in designing component state: result value here...
  Result:= round(FScaleX*(_worldX - FMinWorldX));
end;

function jGdxShapeRenderer.GetViewportY(_worldY: single): integer;
begin
  //in designing component state: result value here...
  Result:= FVPY - (10 + round(FScaleY*(_worldY - FMaxWorldY)));
end;

function jGdxShapeRenderer.GetWorldX(_viewportX:integer): single;
begin
   if FScaleX <> 0 then
     Result:=(_viewportX+FScaleX*FMinWorldX)/FScaleX
   else Result:= 0;
end;

function jGdxShapeRenderer.GetWorldY(_viewportY:integer): single;
begin
   if FScaleY <> 0 then
     Result:=(_viewportY+FScaleY*FMaxWorldY)/FScaleY
   else Result:= 0;
end;


function jGdxShapeRenderer.GetViewportX(_worldX: single; _minWorldX: single; _maxWorldX: single; _viewportWidth: integer): integer;
var
  escX:real;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
     escX:=(_viewportWidth/(_maxWorldX-_minWorldX));
     Result:=round(escX*(_worldX - _minWorldX));
  end;
end;

function jGdxShapeRenderer.GetViewportY(_worldY: single; _minWorldY: single; _maxWorldY: single; _viewportHeight: integer): integer;
var
  escY:real;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
     escY:= -(_viewportHeight-10)/(_maxWorldY-_minWorldY);
     Result:= 10+round(escY*(_worldY - _maxWorldY));
  end;
end;

procedure jGdxShapeRenderer.SetViewportSize(_width: single; _height: single);
begin
  FVPWidth:= Trunc(_width);
  FVPHeight:= Trunc(_height);
end;

procedure jGdxShapeRenderer.SetViewportPosition(_x: single; _y: single);
begin
  FVPX:=  Trunc(_x) ;
  FVPY:=  {FScreenHeight -} Trunc(_y);
end;

{-------- jGdxShapeRenderer_JNI_Bridge ----------}

function jGdxShapeRenderer_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGdxShapeRenderer_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jGdxShapeRenderer_jFree(env: PJNIEnv; _jgdxshaperenderer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgdxshaperenderer);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgdxshaperenderer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxShapeRenderer_SetProjectionMatrix(env: PJNIEnv; _jgdxshaperenderer: JObject; _matrix4: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].l:= _matrix4;
  jCls:= env^.GetObjectClass(env, _jgdxshaperenderer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetProjectionMatrix', '(Lcom/badlogic/gdx/math/Matrix4;)V');
  env^.CallVoidMethodA(env, _jgdxshaperenderer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGdxShapeRenderer_BeginDraw(env: PJNIEnv; _jgdxshaperenderer: JObject; _shapeType: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].i:= _shapeType;
  jCls:= env^.GetObjectClass(env, _jgdxshaperenderer);
  jMethod:= env^.GetMethodID(env, jCls, 'BeginDraw', '(I)V');
  env^.CallVoidMethodA(env, _jgdxshaperenderer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGdxShapeRenderer_EndDraw(env: PJNIEnv; _jgdxshaperenderer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxshaperenderer);
  jMethod:= env^.GetMethodID(env, jCls, 'EndDraw', '()V');
  env^.CallVoidMethod(env, _jgdxshaperenderer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGdxShapeRenderer_SetColor(env: PJNIEnv; _jgdxshaperenderer: JObject; _red: integer; _green: integer; _blue: integer; _alpha: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].i:= _red;
  jParams[1].i:= _green;
  jParams[2].i:= _blue;
  jParams[3].i:= _alpha;
  jCls:= env^.GetObjectClass(env, _jgdxshaperenderer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetColor', '(IIII)V');
  env^.CallVoidMethodA(env, _jgdxshaperenderer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxShapeRenderer_Rect(env: PJNIEnv; _jgdxshaperenderer: JObject; _x: single; _y: single; _width: integer; _height: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _x;
  jParams[1].f:= _y;
  jParams[2].i:= _width;
  jParams[3].i:= _height;
  jCls:= env^.GetObjectClass(env, _jgdxshaperenderer);
  jMethod:= env^.GetMethodID(env, jCls, 'Rect', '(FFII)V');
  env^.CallVoidMethodA(env, _jgdxshaperenderer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxShapeRenderer_Dispose(env: PJNIEnv; _jgdxshaperenderer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgdxshaperenderer);
  jMethod:= env^.GetMethodID(env, jCls, 'Dispose', '()V');
  env^.CallVoidMethod(env, _jgdxshaperenderer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
