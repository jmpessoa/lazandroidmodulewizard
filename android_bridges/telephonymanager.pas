unit telephonymanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

  //CALL_STATE_IDLE CALL_STATE_RINGING CALL_STATE_OFFHOOK

TTelephonyCallState = (csIdle, csRinging, csOffHook);
TOnCallStateChanged = procedure(Sender: TObject; state: TTelephonyCallState; phoneNumber: string) of object;
TOnGetUidTotalMobileBytesFinished = procedure(Sender: TObject; totalbytes: int64; uid:integer) of Object;
TOnGetUidTotalWifiBytesFinished = procedure(Sender: TObject; totalbytes: int64; uid:integer) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [10/21/2018 14:02:44]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jTelephonyManager = class(jControl)
 private
    FOnCallStateChanged: TOnCallStateChanged;
    FOnGetUidTotalMobileBytesFinished: TOnGetUidTotalMobileBytesFinished;
    FOnGetUidTotalWifiBytesFinished: TOnGetUidTotalWifiBytesFinished;
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
    function GetUidRxBytes(_startTime, _endTime:int64; _uid: integer):int64;
    function GetUidTxBytes(_startTime, _endTime:int64; _uid: integer):int64;
    function GetUidTotalBytes(_startTime, _endTime:int64; _uid: integer):int64;
    function GetUidTotalMobileBytes(_startTime, _endTime:int64; _uid: integer):int64;
    function GetUidTotalWifiBytes(_startTime, _endTime:int64; _uid: integer):int64;
    function GetMobileRxBytes():int64;
    function GetMobileTxBytes():int64;
    function GetUidFromPackage(_package: string):integer;
    function IsNetworkRoaming(): boolean;
    function GetLine1Number(): string;
    function GetSubscriberId():string;
    function GetNetworkOperatorName(): string;
    function IsWifiEnabled(): boolean;
    procedure GetUidTotalMobileBytesAsync(_startTime, _endTime:int64; _uid: integer);
    procedure GetUidTotalWifiBytesAsync(_startTime, _endTime:int64; _uid: integer);
    function GetLocationAreaCode(): integer;
    function GetBaseStationId(): integer;
    function GetMobileNetworkCode(): integer;
    function GetMobileCountryCode(): integer;

    procedure GenEvent_OnTelephonyCallStateChanged(Sender: TObject; state: TTelephonyCallState; phoneNumber: string);
    procedure GenEvent_OnGetUidTotalMobileBytesFinished(Sender: TObject; totalbytes: int64 ; uid: integer);
    procedure GenEvent_OnGetUidTotalWifiBytesFinished(Sender: TObject; totalbytes: int64 ; uid: integer);
 published
    property OnCallStateChanged: TOnCallStateChanged read FOnCallStateChanged write FOnCallStateChanged;
    property OnGetUidTotalMobileBytesFinished: TOnGetUidTotalMobileBytesFinished read FOnGetUidTotalMobileBytesFinished write FOnGetUidTotalMobileBytesFinished;
    property OnGetUidTotalWifiBytesFinished: TOnGetUidTotalWifiBytesFinished read FOnGetUidTotalWifiBytesFinished write FOnGetUidTotalWifiBytesFinished;
end;

function jTelephonyManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jTelephonyManager_GetUidTotalMobileBytesAsync(env: PJNIEnv; _jtelephonymanager: JObject; _startTime, _endTime:int64; _uid: integer);
procedure jTelephonyManager_GetUidTotalWifiBytesAsync(env: PJNIEnv; _jtelephonymanager: JObject; _startTime, _endTime:int64; _uid: integer);

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
       jni_free(FjEnv, FjObject);
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

function jTelephonyManager.GetUidTxBytes(_startTime, _endTime:int64; _uid: integer): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_jji_out_j(FjEnv, FjObject, 'GetUidTxBytes', _startTime, _endTime, _uid);
end;

function jTelephonyManager.GetUidRxBytes(_startTime, _endTime:int64; _uid: integer): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_jji_out_j(FjEnv, FjObject, 'GetUidRxBytes', _startTime, _endTime, _uid);
end;

function jTelephonyManager.GetUidTotalBytes(_startTime, _endTime:int64; _uid:integer): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_jji_out_j(FjEnv, FjObject, 'GetUidTotalBytes', _startTime, _endTime, _uid);
end;

function jTelephonyManager.GetUidTotalMobileBytes(_startTime, _endTime:int64; _uid: integer): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_jji_out_j(FjEnv, FjObject, 'GetUidTotalMobileBytes', _startTime, _endTime, _uid);
end;

procedure jTelephonyManager.GetUidTotalMobileBytesAsync(_startTime, _endTime:int64; _uid: integer);
begin
  //in designing component state: result value here...
  if FInitialized then
    jTelephonyManager_GetUidTotalMobileBytesAsync(FjEnv, FjObject, _startTime, _endTime,  _uid);
end;

procedure jTelephonyManager.GetUidTotalWifiBytesAsync(_startTime, _endTime:int64; _uid: integer);
begin
  //in designing component state: result value here...
  if FInitialized then
    jTelephonyManager_GetUidTotalWifiBytesAsync(FjEnv, FjObject, _startTime, _endTime,  _uid);
end;

function jTelephonyManager.GetUidTotalWifiBytes(_startTime, _endTime:int64; _uid: integer): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_jji_out_j(FjEnv, FjObject, 'GetUidTotalWifiBytes', _startTime, _endTime, _uid);
end;

function jTelephonyManager.GetUidFromPackage(_package: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_i(FjEnv, FjObject, 'GetUidFromPackage', _package);
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

function jTelephonyManager.GetSubscriberId(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetSubscriberId');
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

procedure jTelephonyManager.GenEvent_OnGetUidTotalMobileBytesFinished(Sender: TObject; totalbytes: int64; uid:integer);
begin
  if Assigned(FOnGetUidTotalMobileBytesFinished) then  FOnGetUidTotalMobileBytesFinished(Sender, totalbytes, uid);
end;

procedure jTelephonyManager.GenEvent_OnGetUidTotalWifiBytesFinished(Sender: TObject; totalbytes: int64; uid:integer);
begin
  if Assigned(FOnGetUidTotalWifiBytesFinished) then  FOnGetUidTotalWifiBytesFinished(Sender, totalbytes, uid);
end;

function jTelephonyManager.GetLocationAreaCode(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetLocationAreaCode');
end;

function jTelephonyManager.GetBaseStationId(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetBaseStationId');
end;

function jTelephonyManager.GetMobileNetworkCode(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetMobileNetworkCode');
end;

function jTelephonyManager.GetMobileCountryCode(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetMobileCountryCode');
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
  result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jTelephonyManager_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jTelephonyManager_GetUidTotalMobileBytesAsync(env: PJNIEnv; _jtelephonymanager: JObject; _startTime, _endTime:int64; _uid: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jtelephonymanager = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetUidTotalMobileBytesAsync', '(JJI)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].j:= _startTime;
  jParams[1].j:= _endTime;
  jParams[2].i:= _uid;

  env^.CallVoidMethodA(env, _jtelephonymanager, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jTelephonyManager_GetUidTotalWifiBytesAsync(env: PJNIEnv; _jtelephonymanager: JObject; _startTime, _endTime:int64; _uid: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jtelephonymanager = nil) then exit;

  jCls:= env^.GetObjectClass(env, _jtelephonymanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetUidTotalWifiBytesAsync', '(JJI)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].j:= _startTime;
  jParams[1].j:= _endTime;
  jParams[2].i:= _uid;

  env^.CallVoidMethodA(env, _jtelephonymanager, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
