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
    function GetMobileRxBytes():int64;
    function GetMobileTxBytes():int64;
    function IsNetworkRoaming(): boolean;
    function GetLine1Number(): string;
    function GetNetworkOperatorName(): string;
    function IsWifiEnabled(): boolean;

    procedure GenEvent_OnTelephonyCallStateChanged(Sender: TObject; state: TTelephonyCallState; phoneNumber: string);
 published
    property OnCallStateChanged: TOnCallStateChanged read FOnCallStateChanged write FOnCallStateChanged;
end;

function jTelephonyManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;

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
       jni_proc(FjEnv, FjObject, 'jFree');
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
  FjObject := jTelephonyManager_jCreate(FjEnv, int64(Self), FjThis);

  if FjObject = nil then exit;
  FInitialized:= True;
end;

procedure jTelephonyManager.Call(_phoneNumber: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'Call', _phoneNumber);
end;

procedure jTelephonyManager.SetSpeakerphoneOn(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(FjEnv, FjObject, 'SetSpeakerphoneOn', _value);
end;

function jTelephonyManager.GetIMEI(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetIMEI');
end;


function jTelephonyManager.GetNetworkCountryIso(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetNetworkCountryIso');
end;

function jTelephonyManager.GetSimCountryIso(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetSimCountryIso');
end;

function jTelephonyManager.GetDeviceSoftwareVersion(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetDeviceSoftwareVersion');
end;

function jTelephonyManager.GetVoiceMailNumber(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetVoiceMailNumber');
end;

function jTelephonyManager.GetPhoneType(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetPhoneType');
end;

function jTelephonyManager.GetNetworkType(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetNetworkType');
end;

function jTelephonyManager.GetTotalRxBytes(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_j(FjEnv, FjObject, 'GetTotalRxBytes');
end;

function jTelephonyManager.GetTotalTxBytes(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_j(FjEnv, FjObject, 'GetTotalTxBytes');
end;

function jTelephonyManager.GetMobileRxBytes(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_j(FjEnv, FjObject, 'GetMobileRxBytes');
end;

function jTelephonyManager.GetMobileTxBytes(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_j(FjEnv, FjObject, 'GetMobileTxBytes');
end;

function jTelephonyManager.IsNetworkRoaming(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'IsNetworkRoaming');
end;

function jTelephonyManager.GetLine1Number(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetLine1Number');
end;

function jTelephonyManager.GetNetworkOperatorName(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetNetworkOperatorName');
end;

function jTelephonyManager.IsWifiEnabled(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'IsWifiEnabled');
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
label
  _exceptionOcurred;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jTelephonyManager_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
