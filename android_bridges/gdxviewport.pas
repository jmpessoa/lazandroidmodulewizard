unit gdxviewport;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/22/2019 18:51:30]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jGdxViewport = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function FitViewport(_width: integer; _height: integer; _camera: jObject): jObject;
    procedure Apply();
    procedure Update(_width: integer; _height: integer);

 published

end;

function jGdxViewport_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGdxViewport_jFree(env: PJNIEnv; _jgdxviewport: JObject);
function jGdxViewport_FitViewport(env: PJNIEnv; _jgdxviewport: JObject; _width: integer; _height: integer; _camera: jObject): jObject;
procedure jGdxViewport_Apply(env: PJNIEnv; _jgdxviewport: JObject);
procedure jGdxViewport_Update(env: PJNIEnv; _jgdxviewport: JObject; _width: integer; _height: integer);

implementation

{---------  jGdxViewport  --------------}

constructor jGdxViewport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jGdxViewport.Destroy;
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

procedure jGdxViewport.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jGdxViewport.jCreate(): jObject;
begin
   Result:= jGdxViewport_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jGdxViewport.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxViewport_jFree(FjEnv, FjObject);
end;

function jGdxViewport.FitViewport(_width: integer; _height: integer; _camera: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxViewport_FitViewport(FjEnv, FjObject, _width ,_height ,_camera);
end;

procedure jGdxViewport.Apply();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxViewport_Apply(FjEnv, FjObject);
end;

procedure jGdxViewport.Update(_width: integer; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxViewport_Update(FjEnv, FjObject, _width ,_height);
end;

{-------- jGdxViewport_JNI_Bridge ----------}

function jGdxViewport_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGdxViewport_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jGdxViewport_jFree(env: PJNIEnv; _jgdxviewport: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgdxviewport);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgdxviewport, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxViewport_FitViewport(env: PJNIEnv; _jgdxviewport: JObject; _width: integer; _height: integer; _camera: jObject): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].i:= _width;
  jParams[1].i:= _height;
  jParams[2].l:= _camera;
  jCls:= env^.GetObjectClass(env, _jgdxviewport);
  jMethod:= env^.GetMethodID(env, jCls, 'FitViewport', '(IILcom/badlogic/gdx/graphics/OrthographicCamera;)Lcom/badlogic/gdx/utils/viewport/FitViewport;');
  Result:= env^.CallObjectMethodA(env, _jgdxviewport, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxViewport_Apply(env: PJNIEnv; _jgdxviewport: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxviewport);
  jMethod:= env^.GetMethodID(env, jCls, 'Apply', '()V');
  env^.CallVoidMethod(env, _jgdxviewport, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxViewport_Update(env: PJNIEnv; _jgdxviewport: JObject; _width: integer; _height: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].i:= _width;
  jParams[1].i:= _height;
  jCls:= env^.GetObjectClass(env, _jgdxviewport);
  jMethod:= env^.GetMethodID(env, jCls, 'Update', '(II)V');
  env^.CallVoidMethodA(env, _jgdxviewport, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
