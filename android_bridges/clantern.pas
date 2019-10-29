unit clantern;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [4/21/2019 12:44:23]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jcLantern = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure LightOn(); overload;
    procedure LightOn(_pulse: boolean); overload;
    procedure LightOff();
    function InitTorch(): boolean;

 published

end;

function jcLantern_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jcLantern_jFree(env: PJNIEnv; _jclantern: JObject);
procedure jcLantern_LightOn(env: PJNIEnv; _jclantern: JObject); overload;
procedure jcLantern_LightOn(env: PJNIEnv; _jclantern: JObject; _pulse: boolean);  overload;
procedure jcLantern_LightOff(env: PJNIEnv; _jclantern: JObject);
function jcLantern_InitTorch(env: PJNIEnv; _jclantern: JObject): boolean;


implementation

{---------  jcLantern  --------------}

constructor jcLantern.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jcLantern.Destroy;
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

procedure jcLantern.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;


function jcLantern.jCreate(): jObject;
begin
   Result:= jcLantern_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jcLantern.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcLantern_jFree(FjEnv, FjObject);
end;

procedure jcLantern.LightOn();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcLantern_LightOn(FjEnv, FjObject);
end;

procedure jcLantern.LightOn(_pulse: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcLantern_LightOn(FjEnv, FjObject, _pulse);
end;

procedure jcLantern.LightOff();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcLantern_LightOff(FjEnv, FjObject);
end;

function jcLantern.InitTorch(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcLantern_InitTorch(FjEnv, FjObject);
end;

{-------- jcLantern_JNI_Bridge ----------}

function jcLantern_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jcLantern_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jcLantern_jFree(env: PJNIEnv; _jclantern: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jclantern);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jclantern, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcLantern_LightOn(env: PJNIEnv; _jclantern: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jclantern);
  jMethod:= env^.GetMethodID(env, jCls, 'LightOn', '()V');
  env^.CallVoidMethod(env, _jclantern, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcLantern_LightOn(env: PJNIEnv; _jclantern: JObject; _pulse: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_pulse);
  jCls:= env^.GetObjectClass(env, _jclantern);
  jMethod:= env^.GetMethodID(env, jCls, 'LightOn', '(Z)V');
  env^.CallVoidMethodA(env, _jclantern, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcLantern_LightOff(env: PJNIEnv; _jclantern: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jclantern);
  jMethod:= env^.GetMethodID(env, jCls, 'LightOff', '()V');
  env^.CallVoidMethod(env, _jclantern, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcLantern_InitTorch(env: PJNIEnv; _jclantern: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jclantern);
  jMethod:= env^.GetMethodID(env, jCls, 'InitTorch', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jclantern, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;



end.
