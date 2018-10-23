unit telephonymanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

  //CALL_STATE_IDLE CALL_STATE_RINGING CALL_STATE_OFFHOOK

TTelephonyCallState = (csIdle, csRinging, csOffHook);
TOnCallStateChanged = procedure(Sender: TObject; state: TTelephonyCallState; phoneNumber: string) of object;

{Draft Component code by "Lazarus Android Module Wizard" [10/21/2018 14:02:44]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jTelephonyManager = class(jControl)
 private
    FOnCallStateChanged: TOnCallStateChanged;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Call(_phoneNumber: string);
    procedure SetSpeakerphoneOn(_value: boolean);

    procedure GenEvent_OnTelephonyCallStateChanged(Sender: TObject; state: TTelephonyCallState; phoneNumber: string);
 published
    property OnCallStateChanged: TOnCallStateChanged read FOnCallStateChanged write FOnCallStateChanged;
end;

function jTelephonyManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jTelephonyManager_jFree(env: PJNIEnv; _jtelephonymanager: JObject);
procedure jTelephonyManager_Call(env: PJNIEnv; _jtelephonymanager: JObject; _phoneNumber: string);
procedure jTelephonyManager_SetSpeakerphoneOn(env: PJNIEnv; _jtelephonymanager: JObject; _value: boolean);



implementation


{---------  jTelephonyManager  --------------}

constructor jTelephonyManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jTelephonyManager.Destroy;
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

procedure jTelephonyManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jTelephonyManager.jCreate(): jObject;
begin
   Result:= jTelephonyManager_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jTelephonyManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTelephonyManager_jFree(FjEnv, FjObject);
end;

procedure jTelephonyManager.Call(_phoneNumber: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTelephonyManager_Call(FjEnv, FjObject, _phoneNumber);
end;

procedure jTelephonyManager.SetSpeakerphoneOn(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTelephonyManager_SetSpeakerphoneOn(FjEnv, FjObject, _value);
end;

procedure jTelephonyManager.GenEvent_OnTelephonyCallStateChanged(Sender: TObject; state: TTelephonyCallState; phoneNumber: string);
begin
  if Assigned(FOnCallStateChanged) then  FOnCallStateChanged(Sender, state, phoneNumber);
end;

{-------- jTelephonyManager_JNI_Bridge ----------}

function jTelephonyManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jTelephonyManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jTelephonyManager_jFree(env: PJNIEnv; _jtelephonymanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jtelephonymanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTelephonyManager_Call(env: PJNIEnv; _jtelephonymanager: JObject; _phoneNumber: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_phoneNumber));
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Call', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtelephonymanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTelephonyManager_SetSpeakerphoneOn(env: PJNIEnv; _jtelephonymanager: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSpeakerphoneOn', '(Z)V');
  env^.CallVoidMethodA(env, _jtelephonymanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
