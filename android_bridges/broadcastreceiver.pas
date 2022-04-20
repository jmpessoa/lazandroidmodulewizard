unit broadcastreceiver;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TIntentActionFiter = (afTimeTick,  //Intent.ACTION_TIME_TICK
                   afTimeChanged,    //Intent.ACTION_TIME_CHANGED
                   afTimeZoneChanged, //Intent.ACTION_TIMEZONE_CHANGED
                   afBootCompleted,   //Intent.ACTION_BOOT_COMPLETED
                   afBatteryChanged,   //Intent.ACTION_BATTERY_CHANGED
                   afPowerConnected,    //Intent.ACTION_POWER_CONNECTED
                   afPowerDisconnected,  //Intent.ACTION_POWER_DISCONNECTED
                   afShutDown,           //Intent.ACTION_SHUTDOWN
                   afSMSReceived,       //android.provider.Telephony.SMS_RECEIVED
                   afDownloadComplete,  //android.intent.action.DOWNLOAD_COMPLETE  or DownloadManager.ACTION_DOWNLOAD_COMPLETE
                   afPhoneState,        //android.intent.action.PHONE_STATE
                   afNewOutgoingCall,   //android.intent.action.NEW_OUTGOING_CALL
                   afScreenOn,          //Intent.ACTION_SCREEN_ON
                   afScreenOff,         //Intent.ACTION_SCREEN_OFF
                   afNone);


TOnReceiver = procedure(Sender: TObject;  intent: jObject) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [1/18/2015 2:13:27]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jBroadcastReceiver = class(jControl)
 private
    FIntentActionFilter: TIntentActionFiter;
    FOnReceiver: TOnReceiver;
    FRegistered: boolean;

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;

    procedure RegisterIntentActionFilter(_intentActionFilter: string); overload;
    procedure RegisterIntentActionFilter(_intentActionFilter: TIntentActionFiter); overload;

    procedure SetIntentActionFilter(_intentActionFilter: TIntentActionFiter);

    procedure Unregister();

    function GetResultCode(): TAndroidResult;
    function GetResultData(): string;
    function GetResultExtras(): jObject;

    procedure GenEvent_OnBroadcastReceiver(Obj: TObject;  intent: jObject);

    property Registered: boolean read FRegistered write FRegistered;

 published
    property IntentActionFilter: TIntentActionFiter read FIntentActionFilter write SetIntentActionFilter;
    property OnReceiver: TOnReceiver read FOnReceiver write FOnReceiver;
end;

function  jBroadcastReceiver_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jBroadcastReceiver_RegisterIntentActionFilter(env: PJNIEnv; _jbroadcastreceiver: JObject; _intentAction: integer);

function  jBroadcastReceiver_GetResultExtras(env: PJNIEnv; _jbroadcastreceiver: JObject): jObject;



implementation


{---------  jBroadcastReceiver  --------------}

constructor jBroadcastReceiver.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
  FRegistered:= False;
  FIntentActionFilter:= afNone;
end;

destructor jBroadcastReceiver.Destroy;
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

procedure jBroadcastReceiver.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jBroadcastReceiver_jCreate(FjEnv, int64(Self), FjThis);

  if FjObject = nil then exit;

  FInitialized:= True;
  if FIntentActionFilter <> afNone then
  begin
     jBroadcastReceiver_RegisterIntentActionFilter(FjEnv, FjObject, Ord(FIntentActionFilter));
     FRegistered:= True;
  end;
end;

procedure jBroadcastReceiver.RegisterIntentActionFilter(_intentActionFilter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     FRegistered:= True;
     jni_proc_t(FjEnv, FjObject, 'RegisterIntentActionFilter', _intentActionFilter);
  end;
end;

procedure jBroadcastReceiver.RegisterIntentActionFilter(_intentActionFilter: TIntentActionFiter);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     FRegistered:= True;
     jBroadcastReceiver_RegisterIntentActionFilter(FjEnv, FjObject, Ord(_intentActionFilter));
  end;
end;

procedure jBroadcastReceiver.SetIntentActionFilter(_intentActionFilter: TIntentActionFiter);
begin
  //in designing component state: set value here...
  FIntentActionFilter:= _intentActionFilter;
  if FInitialized then
  begin
     FRegistered:= True;
     jBroadcastReceiver_RegisterIntentActionFilter(FjEnv, FjObject, Ord(_intentActionFilter));
  end;
end;

procedure jBroadcastReceiver.Unregister();
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     if FRegistered then
     begin
       jni_proc(FjEnv, FjObject, 'Unregister');
       FRegistered:= False;
     end;
  end;
end;

procedure jBroadcastReceiver.GenEvent_OnBroadcastReceiver(Obj: TObject;  intent: jObject);
begin
  if Assigned(FOnReceiver) then FOnReceiver(Obj, intent);
end;

function jBroadcastReceiver.GetResultCode(): TAndroidResult;
begin
  //in designing component state: result value here...
  Result:= RESULT_CANCELED;
  if FInitialized then
  begin
     Result:= TAndroidResult(jni_func_out_i(FjEnv, FjObject, 'GetResultCode'));
  end;
end;

function jBroadcastReceiver.GetResultData(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetResultData');
end;

function jBroadcastReceiver.GetResultExtras(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBroadcastReceiver_GetResultExtras(FjEnv, FjObject);
end;

{-------- jBroadcastReceiver_JNI_Bridge ----------}

function jBroadcastReceiver_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
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
  jMethod:= env^.GetMethodID(env, jCls, 'jBroadcastReceiver_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);  

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jBroadcastReceiver_RegisterIntentActionFilter(env: PJNIEnv; _jbroadcastreceiver: JObject; _intentAction: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  if (env = nil) or (_jbroadcastreceiver = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'RegisterIntentActionFilter', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _intentAction;

  env^.CallVoidMethodA(env, _jbroadcastreceiver, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jBroadcastReceiver_GetResultExtras(env: PJNIEnv; _jbroadcastreceiver: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  Result := nil;

  if (env = nil) or (_jbroadcastreceiver = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetResultExtras', '()Landroid/os/Bundle;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jbroadcastreceiver, jMethod);

  env^.DeleteLocalRef(env, jCls);  

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
