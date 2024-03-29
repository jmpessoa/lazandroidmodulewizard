unit brightness;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [28/06/2018 18:34:01]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jBrightness = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function getBrightness(): single;
    function isBrightnessManual(): boolean;
    procedure setBrightness(_brightness: single);

 published

end;

function jBrightness_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;


implementation


{---------  jBrightness  --------------}

constructor jBrightness.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jBrightness.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jni_free(gApp.jni.jEnv, FjObject);
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jBrightness.Init;
begin
  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jBrightness_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
  if FjObject = nil then exit;
  FInitialized:= True;
end;

function jBrightness.getBrightness(): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_f(gApp.jni.jEnv, FjObject, 'getBrightness');
end;

function jBrightness.isBrightnessManual(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(gApp.jni.jEnv, FjObject, 'isBrightnessManual');
end;

procedure jBrightness.setBrightness(_brightness: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_f(gApp.jni.jEnv, FjObject, 'setBrightness', _brightness);
end;

{-------- jBrightness_JNI_Bridge ----------}

function jBrightness_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;   
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jBrightness_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);    

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


end.
