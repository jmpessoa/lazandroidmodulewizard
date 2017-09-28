unit broadcastreceiver;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TIntentActionFiter = (afTimeTick,
                   afTimeChanged,
                   afTimeZoneChanged,
                   afBootCompleted,
                   afBatteryChanged,
                   afPowerConnected,
                   afPowerDisconnected,
                   afShutDown,
                   afSMSReceived,
                   afDownloadComplete,  //android.intent.action.DOWNLOAD_COMPLETE  or DownloadManager.ACTION_DOWNLOAD_COMPLETE
                   afPhoneState,
                   afNewOutgoingCall,      //android.intent.action.NEW_OUTGOING_CALL
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
    function jCreate(): jObject;
    procedure jFree();

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

function jBroadcastReceiver_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jBroadcastReceiver_jFree(env: PJNIEnv; _jbroadcastreceiver: JObject);
procedure jBroadcastReceiver_RegisterIntentActionFilter(env: PJNIEnv; _jbroadcastreceiver: JObject; _intentAction: string); overload;
procedure jBroadcastReceiver_RegisterIntentActionFilter(env: PJNIEnv; _jbroadcastreceiver: JObject; _intentAction: integer);  overload;
procedure jBroadcastReceiver_Unregister(env: PJNIEnv; _jbroadcastreceiver: JObject);

function jBroadcastReceiver_GetResultCode(env: PJNIEnv; _jbroadcastreceiver: JObject): integer;
function jBroadcastReceiver_GetResultData(env: PJNIEnv; _jbroadcastreceiver: JObject): string;
function jBroadcastReceiver_GetResultExtras(env: PJNIEnv; _jbroadcastreceiver: JObject): jObject;



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
       jFree();
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
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
  if FIntentActionFilter <> afNone then
  begin
     jBroadcastReceiver_RegisterIntentActionFilter(FjEnv, FjObject, Ord(FIntentActionFilter));
     FRegistered:= True;
  end;
end;


function jBroadcastReceiver.jCreate(): jObject;
begin
  Result:= jBroadcastReceiver_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jBroadcastReceiver.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBroadcastReceiver_jFree(FjEnv, FjObject);
end;

procedure jBroadcastReceiver.RegisterIntentActionFilter(_intentActionFilter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     FRegistered:= True;
     jBroadcastReceiver_RegisterIntentActionFilter(FjEnv, FjObject, _intentActionFilter);
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
       jBroadcastReceiver_Unregister(FjEnv, FjObject);
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
     Result:= TAndroidResult(jBroadcastReceiver_GetResultCode(FjEnv, FjObject));
  end;
end;

function jBroadcastReceiver.GetResultData(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBroadcastReceiver_GetResultData(FjEnv, FjObject);
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
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jBroadcastReceiver_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jBroadcastReceiver_jCreate(long _Self) {
      return (java.lang.Object)(new jBroadcastReceiver(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jBroadcastReceiver_jFree(env: PJNIEnv; _jbroadcastreceiver: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jbroadcastreceiver, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBroadcastReceiver_RegisterIntentActionFilter(env: PJNIEnv; _jbroadcastreceiver: JObject; _intentAction: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_intentAction));
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  jMethod:= env^.GetMethodID(env, jCls, 'RegisterIntentActionFilter', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbroadcastreceiver, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBroadcastReceiver_RegisterIntentActionFilter(env: PJNIEnv; _jbroadcastreceiver: JObject; _intentAction: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _intentAction;
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  jMethod:= env^.GetMethodID(env, jCls, 'RegisterIntentActionFilter', '(I)V');
  env^.CallVoidMethodA(env, _jbroadcastreceiver, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBroadcastReceiver_Unregister(env: PJNIEnv; _jbroadcastreceiver: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  jMethod:= env^.GetMethodID(env, jCls, 'Unregister', '()V');
  env^.CallVoidMethod(env, _jbroadcastreceiver, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBroadcastReceiver_GetResultCode(env: PJNIEnv; _jbroadcastreceiver: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  jMethod:= env^.GetMethodID(env, jCls, 'GetResultCode', '()I');
  Result:= env^.CallIntMethod(env, _jbroadcastreceiver, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jBroadcastReceiver_GetResultData(env: PJNIEnv; _jbroadcastreceiver: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  jMethod:= env^.GetMethodID(env, jCls, 'GetResultData', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jbroadcastreceiver, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jBroadcastReceiver_GetResultExtras(env: PJNIEnv; _jbroadcastreceiver: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  jMethod:= env^.GetMethodID(env, jCls, 'GetResultExtras', '()Landroid/os/Bundle;');
  Result:= env^.CallObjectMethod(env, _jbroadcastreceiver, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
