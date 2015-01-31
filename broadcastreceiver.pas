unit broadcastreceiver;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TOnReceiver = procedure(Sender: TObject;  intent: jObject) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [1/18/2015 2:13:27]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jBroadcastReceiver = class(jControl)
 private
    FIntentAction: string;
    FOnReceiver: TOnReceiver;
    FRegistered: boolean;

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure RegisterIntentAction(_intentAction: string);
    procedure Unregister();

    procedure GenEvent_OnBroadcastReceiver(Obj: TObject;  intent: jObject);

    property Registered: boolean read FRegistered write FRegistered;
 published
    property IntentAction: string read FIntentAction write FIntentAction;
    property OnReceiver: TOnReceiver read FOnReceiver write FOnReceiver;
end;

function jBroadcastReceiver_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jBroadcastReceiver_jFree(env: PJNIEnv; _jbroadcastreceiver: JObject);
procedure jBroadcastReceiver_RegisterIntentAction(env: PJNIEnv; _jbroadcastreceiver: JObject; _intentAction: string);
procedure jBroadcastReceiver_Unregister(env: PJNIEnv; _jbroadcastreceiver: JObject);


implementation


{---------  jBroadcastReceiver  --------------}

constructor jBroadcastReceiver.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
  FRegistered:= False;
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

procedure jBroadcastReceiver.RegisterIntentAction(_intentAction: string);
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     FRegistered:= True;
     jBroadcastReceiver_RegisterIntentAction(FjEnv, FjObject, _intentAction);
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
end;


procedure jBroadcastReceiver_RegisterIntentAction(env: PJNIEnv; _jbroadcastreceiver: JObject; _intentAction: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_intentAction));
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  jMethod:= env^.GetMethodID(env, jCls, 'RegisterIntentAction', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbroadcastreceiver, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;


procedure jBroadcastReceiver_Unregister(env: PJNIEnv; _jbroadcastreceiver: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbroadcastreceiver);
  jMethod:= env^.GetMethodID(env, jCls, 'Unregister', '()V');
  env^.CallVoidMethod(env, _jbroadcastreceiver, jMethod);
end;



end.
