unit sfirebasepushnotificationlistener;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [7/19/2021 1:47:56]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

TOnGetTokenComplete=procedure(Sender:TObject;token:string;isSuccessful:boolean;statusMessage:string) of object;

{jControl template}

jsFirebasePushNotificationListener = class(jControl)
 private
    FOnGetTokenComplete: TOnGetTokenComplete;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure GetFirebaseMessagingTokenAsync();

    procedure GenEvent_OnGetTokenComplete(Sender:TObject;token:string;isSuccessful:boolean;statusMessage:string);
 published
    property OnGetTokenComplete: TOnGetTokenComplete read FOnGetTokenComplete write FOnGetTokenComplete;
end;

function jsFirebasePushNotificationListener_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsFirebasePushNotificationListener_jFree(env: PJNIEnv; _jsfirebasepushnotificationlistener: JObject);
procedure jsFirebasePushNotificationListener_GetFirebaseMessagingTokenAsync(env: PJNIEnv; _jsfirebasepushnotificationlistener: JObject);


implementation

{---------  jsFMCPushNotification  --------------}

constructor jsFirebasePushNotificationListener.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jsFirebasePushNotificationListener.Destroy;
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

procedure jsFirebasePushNotificationListener.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jsFirebasePushNotificationListener.jCreate(): jObject;
begin
   Result:= jsFirebasePushNotificationListener_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsFirebasePushNotificationListener.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFirebasePushNotificationListener_jFree(FjEnv, FjObject);
end;

procedure jsFirebasePushNotificationListener.GetFirebaseMessagingTokenAsync();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFirebasePushNotificationListener_GetFirebaseMessagingTokenAsync(FjEnv, FjObject);
end;

procedure jsFirebasePushNotificationListener.GenEvent_OnGetTokenComplete(Sender:TObject;token:string;isSuccessful:boolean;statusMessage:string);
begin
  if Assigned(FOnGetTokenComplete) then FOnGetTokenComplete(Sender,token,isSuccessful,statusMessage);
end;

{-------- jsFMCPushNotification_JNI_Bridge ----------}

function jsFirebasePushNotificationListener_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  Result := nil;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jsFirebasePushNotificationListener_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure jsFirebasePushNotificationListener_jFree(env: PJNIEnv; _jsfirebasepushnotificationlistener: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jsfirebasepushnotificationlistener);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jsfirebasepushnotificationlistener, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jsFirebasePushNotificationListener_GetFirebaseMessagingTokenAsync(env: PJNIEnv; _jsfirebasepushnotificationlistener: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jsfirebasepushnotificationlistener);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetFirebaseMessagingTokenAsync', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jsfirebasepushnotificationlistener, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
