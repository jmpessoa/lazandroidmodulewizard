unit ctoytimerservice;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TOnToyTimerServicePullElapsedTime=procedure(Sender:TObject;elapsedTime:int64) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [11/11/2020 15:48:12]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jcToyTimerService = class(jControl)
 private
    FOnPullElapsedTime: TOnToyTimerServicePullElapsedTime;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Stop();
    procedure TimerOff();
    procedure TimerOn();
    procedure Start();
    procedure Bind();
    procedure UnBind();
    procedure RunForeground();
    function IsTimerRunning(): boolean;

    procedure GenEvent_OnToyTimerServicePullElapsedTime(Sender:TObject;elapsedTime:int64);

 published
      property OnPullElapsedTime: TOnToyTimerServicePullElapsedTime read FOnPullElapsedTime write FOnPullElapsedTime;

end;

function jcToyTimerService_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jcToyTimerService_jFree(env: PJNIEnv; _jctoytimerservice: JObject);
procedure jcToyTimerService_Stop(env: PJNIEnv; _jctoytimerservice: JObject);
procedure jcToyTimerService_TimerOff(env: PJNIEnv; _jctoytimerservice: JObject);
procedure jcToyTimerService_TimerOn(env: PJNIEnv; _jctoytimerservice: JObject);
procedure jcToyTimerService_Start(env: PJNIEnv; _jctoytimerservice: JObject);
procedure jcToyTimerService_Bind(env: PJNIEnv; _jctoytimerservice: JObject);
procedure jcToyTimerService_UnBind(env: PJNIEnv; _jctoytimerservice: JObject);
procedure jcToyTimerService_RunForeground(env: PJNIEnv; _jctoytimerservice: JObject);
function jcToyTimerService_IsTimerRunning(env: PJNIEnv; _jctoytimerservice: JObject): boolean;


implementation

{---------  jcToyTimerService  --------------}

constructor jcToyTimerService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jcToyTimerService.Destroy;
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

procedure jcToyTimerService.Init;
begin

  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jcToyTimerService.jCreate(): jObject;
begin
   Result:= jcToyTimerService_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jcToyTimerService.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcToyTimerService_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jcToyTimerService.Stop();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcToyTimerService_Stop(gApp.jni.jEnv, FjObject);
end;

procedure jcToyTimerService.TimerOff();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcToyTimerService_TimerOff(gApp.jni.jEnv, FjObject);
end;

procedure jcToyTimerService.TimerOn();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcToyTimerService_TimerOn(gApp.jni.jEnv, FjObject);
end;

procedure jcToyTimerService.Start();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcToyTimerService_Start(gApp.jni.jEnv, FjObject);
end;

procedure jcToyTimerService.Bind();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcToyTimerService_Bind(gApp.jni.jEnv, FjObject);
end;

procedure jcToyTimerService.UnBind();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcToyTimerService_UnBind(gApp.jni.jEnv, FjObject);
end;

procedure jcToyTimerService.RunForeground();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcToyTimerService_RunForeground(gApp.jni.jEnv, FjObject);
end;

function jcToyTimerService.IsTimerRunning(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcToyTimerService_IsTimerRunning(gApp.jni.jEnv, FjObject);
end;

procedure jcToyTimerService.GenEvent_OnToyTimerServicePullElapsedTime(Sender:TObject;elapsedTime:int64);
begin
  if Assigned(FOnPullElapsedTime) then FOnPullElapsedTime(Sender,elapsedTime);
end;

{-------- jcToyTimerService_JNI_Bridge ----------}

function jcToyTimerService_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jcToyTimerService_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jcToyTimerService_jFree(env: PJNIEnv; _jctoytimerservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jctoytimerservice);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jctoytimerservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcToyTimerService_Stop(env: PJNIEnv; _jctoytimerservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jctoytimerservice);
  jMethod:= env^.GetMethodID(env, jCls, 'Stop', '()V');
  env^.CallVoidMethod(env, _jctoytimerservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcToyTimerService_TimerOff(env: PJNIEnv; _jctoytimerservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jctoytimerservice);
  jMethod:= env^.GetMethodID(env, jCls, 'TimerOff', '()V');
  env^.CallVoidMethod(env, _jctoytimerservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcToyTimerService_TimerOn(env: PJNIEnv; _jctoytimerservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jctoytimerservice);
  jMethod:= env^.GetMethodID(env, jCls, 'TimerOn', '()V');
  env^.CallVoidMethod(env, _jctoytimerservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcToyTimerService_Start(env: PJNIEnv; _jctoytimerservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jctoytimerservice);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '()V');
  env^.CallVoidMethod(env, _jctoytimerservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcToyTimerService_Bind(env: PJNIEnv; _jctoytimerservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jctoytimerservice);
  jMethod:= env^.GetMethodID(env, jCls, 'Bind', '()V');
  env^.CallVoidMethod(env, _jctoytimerservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcToyTimerService_UnBind(env: PJNIEnv; _jctoytimerservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jctoytimerservice);
  jMethod:= env^.GetMethodID(env, jCls, 'UnBind', '()V');
  env^.CallVoidMethod(env, _jctoytimerservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcToyTimerService_RunForeground(env: PJNIEnv; _jctoytimerservice: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jctoytimerservice);
  jMethod:= env^.GetMethodID(env, jCls, 'RunForeground', '()V');
  env^.CallVoidMethod(env, _jctoytimerservice, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcToyTimerService_IsTimerRunning(env: PJNIEnv; _jctoytimerservice: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jctoytimerservice);
  jMethod:= env^.GetMethodID(env, jCls, 'IsTimerRunning', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jctoytimerservice, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;



end.
