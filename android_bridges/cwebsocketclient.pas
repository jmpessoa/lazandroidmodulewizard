unit cwebsocketclient;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TWebSocketClientOnOpen=procedure(Sender:TObject) of object;
TWebSocketClientOnTextReceived=procedure(Sender:TObject;msgContent:string) of object;
TWebSocketClientOnBinaryReceived=procedure(Sender:TObject;data:array of shortint) of object;
TWebSocketClientOnPingReceived=procedure(Sender:TObject;data:array of shortint) of object;
TWebSocketClientOnPongReceived=procedure(Sender:TObject;data:array of shortint) of object;
TWebSocketClientOnException=procedure(Sender:TObject;exceptionMessage:string) of object;
TWebSocketClientOnCloseReceived=procedure(Sender:TObject) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [12/22/2021 12:45:35]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

{ jcWebSocketClient }

jcWebSocketClient = class(jControl)
 private
     FUri: string;
     FOnOpen: TWebSocketClientOnOpen;
     FOnTextReceived: TWebSocketClientOnTextReceived;
     FOnBinaryReceived: TWebSocketClientOnBinaryReceived;
     FOnPingReceived: TWebSocketClientOnPingReceived;
     FOnPongReceived: TWebSocketClientOnPongReceived;
     FOnException: TWebSocketClientOnException;
     FOnCloseReceived: TWebSocketClientOnCloseReceived;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;

    function jCreate( _strUri: string): jObject; overload;
    procedure jFree();

    procedure SetUri(_strUri: string);
    procedure SetConnectTimeout(_millisecTimeout: integer);
    procedure SetReadTimeout(_millisecTimeout: integer);
    procedure EnableAutomaticReconnection(_millisecWaitTime: integer);
    procedure AddHeader(_name: string; _value: string);
    procedure Connect();
    procedure Close();

    procedure Send(_message: string);
    procedure SendPing(var _data: TDynArrayOfJByte);
    procedure SendPong(var _data: TDynArrayOfJByte);

    procedure GenEvent_WebSocketClientOnOpen(Sender:TObject);
    procedure GenEvent_WebSocketClientOnTextReceived(Sender:TObject;msgContent:string);
    procedure GenEvent_WebSocketClientOnBinaryReceived(Sender:TObject;data:array of shortint);
    procedure GenEvent_WebSocketClientOnPingReceived(Sender:TObject;data:array of shortint);
    procedure GenEvent_WebSocketClientOnPongReceived(Sender:TObject;data:array of shortint);
    procedure GenEvent_WebSocketClientOnException(Sender:TObject;exceptionMessage:string);
    procedure GenEvent_WebSocketClientOnCloseReceived(Sender:TObject);

 published
    property Uri: string read FUri write SetUri;
    property OnOpen: TWebSocketClientOnOpen read FOnOpen write FOnOpen;
    property OnTextReceived: TWebSocketClientOnTextReceived read FOnTextReceived write FOnTextReceived;
    property OnBinaryReceived: TWebSocketClientOnBinaryReceived read FOnBinaryReceived write FOnBinaryReceived;
    property OnPingReceived: TWebSocketClientOnPingReceived read FOnPingReceived write FOnPingReceived;
    property OnPongReceived: TWebSocketClientOnPongReceived read FOnPongReceived write FOnPongReceived;
    property OnException: TWebSocketClientOnException read FOnException write FOnException;
    property OnCloseReceived: TWebSocketClientOnCloseReceived read FOnCloseReceived write FOnCloseReceived;

end;

function jcWebSocketClient_jCreate(env: PJNIEnv;_Self: int64; _strUri: string; this: jObject): jObject; overload;

procedure jcWebSocketClient_SetUri(env: PJNIEnv; _jcwebsocketclient: JObject; _strUri: string);
procedure jcWebSocketClient_SetConnectTimeout(env: PJNIEnv; _jcwebsocketclient: JObject; _millisecTimeout: integer);
procedure jcWebSocketClient_SetReadTimeout(env: PJNIEnv; _jcwebsocketclient: JObject; _millisecTimeout: integer);
procedure jcWebSocketClient_EnableAutomaticReconnection(env: PJNIEnv; _jcwebsocketclient: JObject; _millisecWaitTime: integer);
procedure jcWebSocketClient_AddHeader(env: PJNIEnv; _jcwebsocketclient: JObject; _name: string; _value: string);
procedure jcWebSocketClient_Connect(env: PJNIEnv; _jcwebsocketclient: JObject);
procedure jcWebSocketClient_Close(env: PJNIEnv; _jcwebsocketclient: JObject);

procedure jcWebsocketClient_Send(env: PJNIEnv; _jcwebsocketclient: JObject; _message: string);
procedure jcWebSocketClient_SendPing(env: PJNIEnv; _jcwebsocketclient: JObject; var _data: TDynArrayOfJByte);
procedure jcWebSocketClient_SendPong(env: PJNIEnv; _jcwebsocketclient: JObject; var _data: TDynArrayOfJByte);

procedure jcWebSocketClient_jFree(env: PJNIEnv; _jcwebsocketclient: JObject);


implementation

{---------  jcWebsocketClient  --------------}

constructor jcWebSocketClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jcWebSocketClient.Destroy;
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

procedure jcWebSocketClient.Init;
begin

  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....

  if FUri <> '' then
    FjObject := jCreate(FUri) //jSelf !
  else
    FjObject := jCreate(''); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jcWebSocketClient.jCreate( _strUri: string): jObject;
begin
   Result:= jcWebSocketClient_jCreate(gApp.jni.jEnv, int64(Self) ,_strUri, gApp.jni.jThis);
end;

procedure jcWebSocketClient.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcWebsocketClient_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jcWebSocketClient.SetUri(_strUri: string);
begin
  //in designing component state: set value here...
  FUri:= _strUri;
  if FInitialized then
     jcWebSocketClient_SetUri(gApp.jni.jEnv, FjObject, _strUri);
end;

procedure jcWebSocketClient.SetConnectTimeout(_millisecTimeout: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcWebSocketClient_SetConnectTimeout(gApp.jni.jEnv, FjObject, _millisecTimeout);
end;

procedure jcWebSocketClient.SetReadTimeout(_millisecTimeout: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcWebSocketClient_SetReadTimeout(gApp.jni.jEnv, FjObject, _millisecTimeout);
end;

procedure jcWebSocketClient.EnableAutomaticReconnection(_millisecWaitTime: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcWebSocketClient_EnableAutomaticReconnection(gApp.jni.jEnv, FjObject, _millisecWaitTime);
end;

procedure jcWebSocketClient.AddHeader(_name: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcWebSocketClient_AddHeader(gApp.jni.jEnv, FjObject, _name ,_value);
end;

procedure jcWebSocketClient.Connect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcWebSocketClient_Connect(gApp.jni.jEnv, FjObject);
end;

procedure jcWebSocketClient.Close();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcWebSocketClient_Close(gApp.jni.jEnv, FjObject);
end;

procedure jcWebsocketClient.Send(_message: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcWebsocketClient_Send(gApp.jni.jEnv, FjObject, _message);
end;

procedure jcWebSocketClient.SendPing(var _data: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcWebSocketClient_SendPing(gApp.jni.jEnv, FjObject, _data);
end;

procedure jcWebSocketClient.SendPong(var _data: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcWebSocketClient_SendPong(gApp.jni.jEnv, FjObject, _data);
end;

procedure jcWebSocketClient.GenEvent_WebSocketClientOnOpen(Sender:TObject);
begin
  if Assigned(FOnOpen) then FOnOpen(Sender);
end;
procedure jcWebSocketClient.GenEvent_WebSocketClientOnTextReceived(Sender:TObject;msgContent:string);
begin
  if Assigned(FOnTextReceived) then FOnTextReceived(Sender,msgContent);
end;
procedure jcWebSocketClient.GenEvent_WebSocketClientOnBinaryReceived(Sender:TObject;data:array of shortint);
begin
  if Assigned(FOnBinaryReceived) then FOnBinaryReceived(Sender,data);
end;
procedure jcWebSocketClient.GenEvent_WebSocketClientOnPingReceived(Sender:TObject;data:array of shortint);
begin
  if Assigned(FOnPingReceived) then FOnPingReceived(Sender,data);
end;
procedure jcWebSocketClient.GenEvent_WebSocketClientOnPongReceived(Sender:TObject;data:array of shortint);
begin
  if Assigned(FOnPongReceived) then FOnPongReceived(Sender,data);
end;
procedure jcWebSocketClient.GenEvent_WebSocketClientOnException(Sender:TObject;exceptionMessage:string);
begin
  if Assigned(FOnException) then FOnException(Sender,exceptionMessage);
end;
procedure jcWebSocketClient.GenEvent_WebSocketClientOnCloseReceived(Sender:TObject);
begin
  if Assigned(FOnCloseReceived) then FOnCloseReceived(Sender);
end;

{-------- jcWebsocketClient_JNI_Bridge ----------}


function jcWebSocketClient_jCreate(env: PJNIEnv;_Self: int64; _strUri: string; this: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  Result := nil;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jcWebSocketClient_jCreate', '(JLjava/lang/String;)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_strUri));

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);
  env^.DeleteLocalRef(env,jParams[1].l);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

procedure jcWebSocketClient_jFree(env: PJNIEnv; _jcwebsocketclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jcwebsocketclient, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jcWebSocketClient_SetUri(env: PJNIEnv; _jcwebsocketclient: JObject; _strUri: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetUri', '(Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_strUri));

  env^.CallVoidMethodA(env, _jcwebsocketclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jcWebSocketClient_Close(env: PJNIEnv; _jcwebsocketclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Close', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jcwebsocketclient, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jcWebsocketClient_Send(env: PJNIEnv; _jcwebsocketclient: JObject; _message: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Send', '(Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_message));

  env^.CallVoidMethodA(env, _jcwebsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jcWebSocketClient_SendPing(env: PJNIEnv; _jcwebsocketclient: JObject; var _data: TDynArrayOfJByte);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SendPing', '([B)V');
  if jMethod = nil then goto _exceptionOcurred;

  newSize0:= Length(_data);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_data[0] {source});
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jcwebsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jcWebSocketClient_SendPong(env: PJNIEnv; _jcwebsocketclient: JObject; var _data: TDynArrayOfJByte);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SendPong', '([B)V');
  if jMethod = nil then goto _exceptionOcurred;

  newSize0:= Length(_data);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_data[0] {source});
  jParams[0].l:= jNewArray0;

  env^.CallVoidMethodA(env, _jcwebsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jcWebSocketClient_SetConnectTimeout(env: PJNIEnv; _jcwebsocketclient: JObject; _millisecTimeout: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetConnectTimeout', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _millisecTimeout;

  env^.CallVoidMethodA(env, _jcwebsocketclient, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jcWebSocketClient_SetReadTimeout(env: PJNIEnv; _jcwebsocketclient: JObject; _millisecTimeout: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetReadTimeout', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _millisecTimeout;

  env^.CallVoidMethodA(env, _jcwebsocketclient, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jcWebSocketClient_EnableAutomaticReconnection(env: PJNIEnv; _jcwebsocketclient: JObject; _millisecWaitTime: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'EnableAutomaticReconnection', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _millisecWaitTime;

  env^.CallVoidMethodA(env, _jcwebsocketclient, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jcWebSocketClient_AddHeader(env: PJNIEnv; _jcwebsocketclient: JObject; _name: string; _value: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddHeader', '(Ljava/lang/String;Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_name));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_value));

  env^.CallVoidMethodA(env, _jcwebsocketclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jcWebSocketClient_Connect(env: PJNIEnv; _jcwebsocketclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jcwebsocketclient);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jcwebsocketclient, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


end.
