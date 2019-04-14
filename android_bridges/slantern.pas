unit slantern;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [4/13/2019 19:04:48]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jsLantern = class(jControl)
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
    //function InitTorch(): boolean;

 published

end;

function jsLantern_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsLantern_jFree(env: PJNIEnv; _jslantern: JObject);
procedure jsLantern_LightOn(env: PJNIEnv; _jslantern: JObject); overload;
procedure jsLantern_LightOn(env: PJNIEnv; _jslantern: JObject; _pulse: boolean); overload;
procedure jsLantern_LightOff(env: PJNIEnv; _jslantern: JObject);
//function jsLantern_InitTorch(env: PJNIEnv; _jslantern: JObject): boolean;


implementation

{---------  jsLantern  --------------}

constructor jsLantern.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jsLantern.Destroy;
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

procedure jsLantern.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jsLantern.jCreate(): jObject;
begin
   Result:= jsLantern_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsLantern.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsLantern_jFree(FjEnv, FjObject);
end;

procedure jsLantern.LightOn();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsLantern_LightOn(FjEnv, FjObject);
end;

procedure jsLantern.LightOn(_pulse: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsLantern_LightOn(FjEnv, FjObject, _pulse);
end;

procedure jsLantern.LightOff();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsLantern_LightOff(FjEnv, FjObject);
end;

{
function jsLantern.InitTorch(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsLantern_InitTorch(FjEnv, FjObject);
end;
}

{-------- jsLantern_JNI_Bridge ----------}

function jsLantern_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsLantern_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsLantern_jFree(env: PJNIEnv; _jslantern: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jslantern);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jslantern, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsLantern_LightOn(env: PJNIEnv; _jslantern: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jslantern);
  jMethod:= env^.GetMethodID(env, jCls, 'LightOn', '()V');
  env^.CallVoidMethod(env, _jslantern, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsLantern_LightOn(env: PJNIEnv; _jslantern: JObject; _pulse: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_pulse);
  jCls:= env^.GetObjectClass(env, _jslantern);
  jMethod:= env^.GetMethodID(env, jCls, 'LightOn', '(Z)V');
  env^.CallVoidMethodA(env, _jslantern, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsLantern_LightOff(env: PJNIEnv; _jslantern: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jslantern);
  jMethod:= env^.GetMethodID(env, jCls, 'LightOff', '()V');
  env^.CallVoidMethod(env, _jslantern, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

{
function jsLantern_InitTorch(env: PJNIEnv; _jslantern: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jslantern);
  jMethod:= env^.GetMethodID(env, jCls, 'InitTorch', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jslantern, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;
}


end.
