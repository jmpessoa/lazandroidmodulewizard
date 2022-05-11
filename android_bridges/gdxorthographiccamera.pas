unit gdxorthographiccamera;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/5/2019 12:21:58]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jGdxOrthographicCamera = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetToOrtho(_yDown: boolean; _viewportWidth: single; _viewportHeight: single);
    function GetMatrix4Combined(): jObject;
    procedure Rotate(_angle: single);
    procedure Translate(_x: single; _y: single);
    procedure Update();
    function GetJInstance(): jObject;

 published

end;

function jGdxOrthographicCamera_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGdxOrthographicCamera_jFree(env: PJNIEnv; _jgdxorthographiccamera: JObject);

procedure jGdxOrthographicCamera_SetToOrtho(env: PJNIEnv; _jgdxorthographiccamera: JObject; _yDown: boolean; _viewportWidth: single; _viewportHeight: single);
function jGdxOrthographicCamera_GetMatrix4Combined(env: PJNIEnv; _jgdxorthographiccamera: JObject): jObject;

procedure jGdxOrthographicCamera_Rotate(env: PJNIEnv; _jgdxorthographiccamera: JObject; _angle: single);
procedure jGdxOrthographicCamera_Translate(env: PJNIEnv; _jgdxorthographiccamera: JObject; _x: single; _y: single);
procedure jGdxOrthographicCamera_Update(env: PJNIEnv; _jgdxorthographiccamera: JObject);

function jGdxOrthographicCamera_GetJInstance(env: PJNIEnv; _jgdxorthographiccamera: JObject): jObject;

implementation

{---------  jGdxOrthographicCamera  --------------}

constructor jGdxOrthographicCamera.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jGdxOrthographicCamera.Destroy;
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

procedure jGdxOrthographicCamera.Init;
begin
  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jGdxOrthographicCamera.jCreate(): jObject;
begin
   Result:= jGdxOrthographicCamera_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jGdxOrthographicCamera.jFree();
begin
  //in designing component state: set value here...
  if FInitialized and (FjObject <> nil) then
     jGdxOrthographicCamera_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jGdxOrthographicCamera.SetToOrtho(_yDown: boolean; _viewportWidth: single; _viewportHeight: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxOrthographicCamera_SetToOrtho(gApp.jni.jEnv, FjObject, _yDown ,_viewportWidth ,_viewportHeight);
end;

function jGdxOrthographicCamera.GetMatrix4Combined(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxOrthographicCamera_GetMatrix4Combined(gApp.jni.jEnv, FjObject);
end;

procedure jGdxOrthographicCamera.Rotate(_angle: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxOrthographicCamera_Rotate(gApp.jni.jEnv, FjObject, _angle);
end;

procedure jGdxOrthographicCamera.Translate(_x: single; _y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxOrthographicCamera_Translate(gApp.jni.jEnv, FjObject, _x ,_y);
end;

procedure jGdxOrthographicCamera.Update();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGdxOrthographicCamera_Update(gApp.jni.jEnv, FjObject);
end;

function jGdxOrthographicCamera.GetJInstance(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGdxOrthographicCamera_GetJInstance(gApp.jni.jEnv, FjObject);
end;

{-------- jGdxOrthographicCamera_JNI_Bridge ----------}

function jGdxOrthographicCamera_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGdxOrthographicCamera_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jGdxOrthographicCamera_jFree(env: PJNIEnv; _jgdxorthographiccamera: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgdxorthographiccamera);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgdxorthographiccamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGdxOrthographicCamera_SetToOrtho(env: PJNIEnv; _jgdxorthographiccamera: JObject; _yDown: boolean; _viewportWidth: single; _viewportHeight: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].z:= JBool(_yDown);
  jParams[1].f:= _viewportWidth;
  jParams[2].f:= _viewportHeight;
  jCls:= env^.GetObjectClass(env, _jgdxorthographiccamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetToOrtho', '(ZFF)V');
  env^.CallVoidMethodA(env, _jgdxorthographiccamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jGdxOrthographicCamera_GetMatrix4Combined(env: PJNIEnv; _jgdxorthographiccamera: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxorthographiccamera);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMatrix4Combined', '()Lcom/badlogic/gdx/math/Matrix4;');
  Result:= env^.CallObjectMethod(env, _jgdxorthographiccamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxOrthographicCamera_Rotate(env: PJNIEnv; _jgdxorthographiccamera: JObject; _angle: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _angle;
  jCls:= env^.GetObjectClass(env, _jgdxorthographiccamera);
  jMethod:= env^.GetMethodID(env, jCls, 'Rotate', '(F)V');
  env^.CallVoidMethodA(env, _jgdxorthographiccamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGdxOrthographicCamera_Translate(env: PJNIEnv; _jgdxorthographiccamera: JObject; _x: single; _y: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jParams[0].f:= _x;
  jParams[1].f:= _y;
  jCls:= env^.GetObjectClass(env, _jgdxorthographiccamera);
  jMethod:= env^.GetMethodID(env, jCls, 'Translate', '(FF)V');
  env^.CallVoidMethodA(env, _jgdxorthographiccamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGdxOrthographicCamera_Update(env: PJNIEnv; _jgdxorthographiccamera: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxorthographiccamera);
  jMethod:= env^.GetMethodID(env, jCls, 'Update', '()V');
  env^.CallVoidMethod(env, _jgdxorthographiccamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jGdxOrthographicCamera_GetJInstance(env: PJNIEnv; _jgdxorthographiccamera: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //gVM^.AttachCurrentThread(gVm,@env,nil);
  jCls:= env^.GetObjectClass(env, _jgdxorthographiccamera);
  jMethod:= env^.GetMethodID(env, jCls, 'GetJInstance', '()Lcom/badlogic/gdx/graphics/OrthographicCamera;');
  Result:= env^.CallObjectMethod(env, _jgdxorthographiccamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
