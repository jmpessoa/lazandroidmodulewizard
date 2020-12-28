unit telephonymanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

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
    function GetIMEI(): string;
    function GetNetworkCountryIso(): string;
    function GetSimCountryIso(): string;
    function GetDeviceSoftwareVersion(): string;
    function GetVoiceMailNumber(): string;
    function GetPhoneType(): string;
    function GetNetworkType(): string;
    function GetTotalRxBytes():int64;
    function GetTotalTxBytes():int64;
    function IsNetworkRoaming(): boolean;
    function GetLine1Number(): string;
    function GetNetworkOperatorName(): string;
    function IsWifiEnabled(): boolean;

    procedure GenEvent_OnTelephonyCallStateChanged(Sender: TObject; state: TTelephonyCallState; phoneNumber: string);
 published
    property OnCallStateChanged: TOnCallStateChanged read FOnCallStateChanged write FOnCallStateChanged;
end;

function jTelephonyManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jTelephonyManager_jFree(env: PJNIEnv; _jtelephonymanager: JObject);
procedure jTelephonyManager_Call(env: PJNIEnv; _jtelephonymanager: JObject; _phoneNumber: string);
procedure jTelephonyManager_SetSpeakerphoneOn(env: PJNIEnv; _jtelephonymanager: JObject; _value: boolean);
function jTelephonyManager_GetIMEI(env: PJNIEnv; _jtelephonymanager: JObject): string;
function jTelephonyManager_GetNetworkCountryIso(env: PJNIEnv; _jtelephonymanager: JObject): string;
function jTelephonyManager_GetSimCountryIso(env: PJNIEnv; _jtelephonymanager: JObject): string;
function jTelephonyManager_GetDeviceSoftwareVersion(env: PJNIEnv; _jtelephonymanager: JObject): string;
function jTelephonyManager_GetVoiceMailNumber(env: PJNIEnv; _jtelephonymanager: JObject): string;
function jTelephonyManager_GetPhoneType(env: PJNIEnv; _jtelephonymanager: JObject): string;
function jTelephonyManager_GetNetworkType(env: PJNIEnv; _jtelephonymanager: JObject): string;
function jTelephonyManager_GetTotalRxBytes(env: PJNIEnv; _jtelephonymanager: JObject): int64;
function jTelephonyManager_GetTotalTxBytes(env: PJNIEnv; _jtelephonymanager: JObject): int64;
function jTelephonyManager_IsNetworkRoaming(env: PJNIEnv; _jtelephonymanager: JObject): boolean;
function jTelephonyManager_GetLine1Number(env: PJNIEnv; _jtelephonymanager: JObject): string;
function jTelephonyManager_GetNetworkOperatorName(env: PJNIEnv; _jtelephonymanager: JObject): string;
function jTelephonyManager_IsWifiEnabled(env: PJNIEnv; _jtelephonymanager: JObject): boolean;


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
  FjObject := jCreate(); if FjObject = nil then exit;
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

function jTelephonyManager.GetIMEI(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetIMEI(FjEnv, FjObject);
end;


function jTelephonyManager.GetNetworkCountryIso(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetNetworkCountryIso(FjEnv, FjObject);
end;

function jTelephonyManager.GetSimCountryIso(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetSimCountryIso(FjEnv, FjObject);
end;

function jTelephonyManager.GetDeviceSoftwareVersion(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetDeviceSoftwareVersion(FjEnv, FjObject);
end;

function jTelephonyManager.GetVoiceMailNumber(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetVoiceMailNumber(FjEnv, FjObject);
end;

function jTelephonyManager.GetPhoneType(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetPhoneType(FjEnv, FjObject);
end;

function jTelephonyManager.GetNetworkType(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetNetworkType(FjEnv, FjObject);
end;

function jTelephonyManager.GetTotalRxBytes(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetTotalRxBytes(FjEnv, FjObject);
end;

function jTelephonyManager.GetTotalTxBytes(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetTotalTxBytes(FjEnv, FjObject);
end;

function jTelephonyManager.IsNetworkRoaming(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_IsNetworkRoaming(FjEnv, FjObject);
end;

function jTelephonyManager.GetLine1Number(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetLine1Number(FjEnv, FjObject);
end;

function jTelephonyManager.GetNetworkOperatorName(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_GetNetworkOperatorName(FjEnv, FjObject);
end;

function jTelephonyManager.IsWifiEnabled(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTelephonyManager_IsWifiEnabled(FjEnv, FjObject);
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

function jTelephonyManager_GetIMEI(env: PJNIEnv; _jtelephonymanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetIMEI', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jtelephonymanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jTelephonyManager_GetNetworkCountryIso(env: PJNIEnv; _jtelephonymanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNetworkCountryIso', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jtelephonymanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jTelephonyManager_GetSimCountryIso(env: PJNIEnv; _jtelephonymanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSimCountryIso', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jtelephonymanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jTelephonyManager_GetDeviceSoftwareVersion(env: PJNIEnv; _jtelephonymanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDeviceSoftwareVersion', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jtelephonymanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jTelephonyManager_GetVoiceMailNumber(env: PJNIEnv; _jtelephonymanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetVoiceMailNumber', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jtelephonymanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jTelephonyManager_GetPhoneType(env: PJNIEnv; _jtelephonymanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPhoneType', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jtelephonymanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jTelephonyManager_GetNetworkType(env: PJNIEnv; _jtelephonymanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNetworkType', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jtelephonymanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jTelephonyManager_GetTotalRxBytes(env: PJNIEnv; _jtelephonymanager: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTotalRxBytes', '()J');
  Result:= env^.CallLongMethod(env, _jtelephonymanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jTelephonyManager_GetTotalTxBytes(env: PJNIEnv; _jtelephonymanager: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTotalTxBytes', '()J');
  Result:= env^.CallLongMethod(env, _jtelephonymanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jTelephonyManager_IsNetworkRoaming(env: PJNIEnv; _jtelephonymanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IsNetworkRoaming', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jtelephonymanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jTelephonyManager_GetLine1Number(env: PJNIEnv; _jtelephonymanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLine1Number', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jtelephonymanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jTelephonyManager_GetNetworkOperatorName(env: PJNIEnv; _jtelephonymanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNetworkOperatorName', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jtelephonymanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jTelephonyManager_IsWifiEnabled(env: PJNIEnv; _jtelephonymanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IsWifiEnabled', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jtelephonymanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


end.
