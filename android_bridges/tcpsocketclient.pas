unit tcpsocketclient;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TOnMessagesReceived = procedure(Sender: TObject; messagesReceived: array of string) of object;
TOnSendFileProgress =  procedure(Sender: TObject; fileName: string; count: integer; fileSize: integer) of object;
TOnSendFileFinished =  procedure(Sender: TObject; fileName: string; fileSize: integer) of object;

{Draft Component code by "Lazarus Android Module Wizard" [5/19/2015 18:49:35]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jTCPSocketClient = class(jControl)
  private
    FOnMessagesReceived: TOnMessagesReceived;
    FOnConnected: TOnNotify;
    FOnSendFileProgress: TOnSendFileProgress;
    FOnSendFileFinished: TOnSendFileFinished;
  public

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SendMessage(message: string);
    procedure SendFile(fullPath: string);
    procedure SetSendFileProgressStep(_bytes: integer);

    procedure CloseConnection(); overload;
    procedure ConnectAsync(_serverIP: string; _serverPort: integer; _login: string); overload;
    procedure ConnectAsync(_serverIP: string; _serverPort: integer);  overload;
    procedure CloseConnection(_finalMessage: string); overload;

    procedure GenEvent_OnTCPSocketClientMessagesReceived(Sender: TObject; messagesReceived: array of string);
    procedure GenEvent_OnTCPSocketClientConnected(Sender: TObject);
    procedure GenEvent_OnTCPSocketClientFileSendProgress(Sender: TObject; filename: string; count: integer; filesize: integer);
    procedure GenEvent_pOnTCPSocketClientFileSendFinished(Sender: TObject;  filename: string;  filesize: integer);

 published
    property OnMessagesReceived: TOnMessagesReceived read FOnMessagesReceived write FOnMessagesReceived;
    property OnConnected: TOnNotify read FOnConnected write FOnConnected;
    property OnSendFileProgress: TOnSendFileProgress read FOnSendFileProgress write FOnSendFileProgress;
    property OnSendFileFinished: TOnSendFileFinished  read FOnSendFileFinished write FOnSendFileFinished;

end;

function jTCPSocketClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jTCPSocketClient_jFree(env: PJNIEnv; _jtcpsocketclient: JObject);
procedure jTCPSocketClient_SendMessage(env: PJNIEnv; _jtcpsocketclient: JObject; message: string);
procedure jTCPSocketClient_CloseConnection(env: PJNIEnv; _jtcpsocketclient: JObject); overload;
procedure jTCPSocketClient_Connect(env: PJNIEnv; _jtcpsocketclient: JObject; _serverIP: string; _serverPort: integer; _login: string); overload;

procedure jTCPSocketClient_Connect(env: PJNIEnv; _jtcpsocketclient: JObject; _serverIP: string; _serverPort: integer); overload;
procedure jTCPSocketClient_CloseConnection(env: PJNIEnv; _jtcpsocketclient: JObject; _finalMessage: string);  overload;
procedure jTCPSocketClient_SendFile(env: PJNIEnv; _jtcpsocketclient: JObject; fullPath: string);
procedure jTCPSocketClient_SetSendFileProgressStep(env: PJNIEnv; _jtcpsocketclient: JObject; _bytes: integer);


implementation

{---------  jTCPSocketClient  --------------}

constructor jTCPSocketClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jTCPSocketClient.Destroy;
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

procedure jTCPSocketClient.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jTCPSocketClient.jCreate(): jObject;
begin
   Result:= jTCPSocketClient_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jTCPSocketClient.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_jFree(FjEnv, FjObject);
end;

procedure jTCPSocketClient.SendMessage(message: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_SendMessage(FjEnv, FjObject, message);
end;

procedure jTCPSocketClient.SendFile(fullPath: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_SendFile(FjEnv, FjObject, fullPath);
end;

procedure jTCPSocketClient.CloseConnection();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_CloseConnection(FjEnv, FjObject);
end;

procedure jTCPSocketClient.ConnectAsync(_serverIP: string; _serverPort: integer; _login: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_Connect(FjEnv, FjObject, _serverIP ,_serverPort ,_login);
end;


procedure jTCPSocketClient.ConnectAsync(_serverIP: string; _serverPort: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_Connect(FjEnv, FjObject, _serverIP ,_serverPort);
end;

procedure jTCPSocketClient.CloseConnection(_finalMessage: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_CloseConnection(FjEnv, FjObject, _finalMessage);
end;

procedure jTCPSocketClient.SetSendFileProgressStep(_bytes: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_SetSendFileProgressStep(FjEnv, FjObject, _bytes);
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientMessagesReceived(Sender: TObject; messagesReceived: array of string);
begin
  if Assigned(FOnMessagesReceived) then  FOnMessagesReceived(Sender, messagesReceived);
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientConnected(Sender: TObject);
begin
  if Assigned(FOnConnected) then  FOnConnected(Sender);
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientFileSendProgress(Sender: TObject; filename: string; count: integer; filesize: integer);
begin
  if Assigned(FOnSendFileProgress) then  FOnSendFileProgress(Sender, filename, count, filesize);
end;

procedure jTCPSocketClient.GenEvent_pOnTCPSocketClientFileSendFinished(Sender: TObject;  filename: string;  filesize: integer);
begin
  if Assigned(FOnSendFileFinished) then FOnSendFileFinished(Sender, filename, filesize);
end;

{-------- jTCPSocketClient_JNI_Bridge ----------}

function jTCPSocketClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jTCPSocketClient_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jTCPSocketClient_jCreate(long _Self) {
      return (java.lang.Object)(new jTCPSocketClient(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jTCPSocketClient_jFree(env: PJNIEnv; _jtcpsocketclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jtcpsocketclient, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTCPSocketClient_SendMessage(env: PJNIEnv; _jtcpsocketclient: JObject; message: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(message));
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SendMessage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jTCPSocketClient_CloseConnection(env: PJNIEnv; _jtcpsocketclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'CloseConnection', '()V');
  env^.CallVoidMethod(env, _jtcpsocketclient, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTCPSocketClient_Connect(env: PJNIEnv; _jtcpsocketclient: JObject; _serverIP: string; _serverPort: integer; _login: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_serverIP));
  jParams[1].i:= _serverPort;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_login));
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTCPSocketClient_CloseConnection(env: PJNIEnv; _jtcpsocketclient: JObject; _finalMessage: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_finalMessage));
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'CloseConnection', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTCPSocketClient_Connect(env: PJNIEnv; _jtcpsocketclient: JObject; _serverIP: string; _serverPort: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_serverIP));
  jParams[1].i:= _serverPort;
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTCPSocketClient_SendFile(env: PJNIEnv; _jtcpsocketclient: JObject; fullPath: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(fullPath));
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SendFile', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTCPSocketClient_SetSendFileProgressStep(env: PJNIEnv; _jtcpsocketclient: JObject; _bytes: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _bytes;
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSendFileProgressStep', '(I)V');
  env^.CallVoidMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
