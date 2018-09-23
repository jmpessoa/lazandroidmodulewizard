unit tcpsocketclient;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TOnMessagesReceived = procedure(Sender: TObject; messagesReceived: array of string) of object;
TOnBytesReceived = procedure(Sender: TObject; var jbytesReceived: TDynArrayOfJByte) of object;
TOnSendFileProgress =  procedure(Sender: TObject; fileName: string; count: integer; fileSize: integer) of object;
TOnSendFileFinished =  procedure(Sender: TObject; fileName: string; fileSize: integer) of object;

TDataTransferMode = (dtmText, dtmByte, dtmFile);

{Draft Component code by "Lazarus Android Module Wizard" [5/19/2015 18:49:35]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jTCPSocketClient = class(jControl)
  private
    FOnMessagesReceived: TOnMessagesReceived;
    FOnBytesReceived: TOnBytesReceived;
    FOnConnected: TOnNotify;
    FOnSendFileProgress: TOnSendFileProgress;
    FOnSendFileFinished: TOnSendFileFinished;
  public

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    function  SendMessage(message: string): boolean;
    procedure SendFile(fullPath: string);
    procedure SetSendFileProgressStep(_bytes: integer);

    function ConnectAsyncTimeOut(_serverIP: string; _serverPort: integer; _timeOut: integer): boolean;
    function ConnectAsync(_serverIP: string; _serverPort: integer): boolean; overload;
    function ConnectAsync(_serverIP: string; _serverPort: integer; _login: string): boolean; overload;

    procedure CloseConnection(); overload;
    procedure CloseConnection(_finalMessage: string); overload;
    procedure CloseConnection(_jbtyte: jByte); overload;

    procedure SetTimeOut(_millisecondsTimeOut: integer);

    function SendBytes(var _jbyteArray: TDynArrayOfJByte; _writeLength: boolean): boolean;
    procedure SetDataTransferMode(_dataTransferMode: TDataTransferMode);

    procedure GenEvent_OnTCPSocketClientMessagesReceived(Sender: TObject; messagesReceived: array of string);
    procedure GenEvent_OnTCPSocketClientBytesReceived(Sender: TObject; var jbytesReceived: TDynArrayOfJByte);
    procedure GenEvent_OnTCPSocketClientConnected(Sender: TObject);
    procedure GenEvent_OnTCPSocketClientFileSendProgress(Sender: TObject; filename: string; count: integer; filesize: integer);
    procedure GenEvent_pOnTCPSocketClientFileSendFinished(Sender: TObject;  filename: string;  filesize: integer);

 published
    property OnMessagesReceived: TOnMessagesReceived read FOnMessagesReceived write FOnMessagesReceived;
    property OnBytesReceived: TOnBytesReceived read FOnBytesReceived write FOnBytesReceived;
    property OnConnected: TOnNotify read FOnConnected write FOnConnected;
    property OnSendFileProgress: TOnSendFileProgress read FOnSendFileProgress write FOnSendFileProgress;
    property OnSendFileFinished: TOnSendFileFinished read FOnSendFileFinished write FOnSendFileFinished;

end;

function  jTCPSocketClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jTCPSocketClient_jFree(env: PJNIEnv; _jtcpsocketclient: JObject);

function jTCPSocketClient_SendMessage(env: PJNIEnv; _jtcpsocketclient: JObject; message: string): boolean;

function jTCPSocketClient_Connect(env: PJNIEnv; _jtcpsocketclient: JObject; _serverIP: string; _serverPort: integer): boolean; overload;
function jTCPSocketClient_Connect(env: PJNIEnv; _jtcpsocketclient: JObject; _serverIP: string; _serverPort: integer; _timeOut: integer): boolean; overload;
function jTCPSocketClient_Connect(env: PJNIEnv; _jtcpsocketclient: JObject; _serverIP: string; _serverPort: integer; _login: string): boolean; overload;

procedure jTCPSocketClient_CloseConnection(env: PJNIEnv; _jtcpsocketclient: JObject); overload;
procedure jTCPSocketClient_CloseConnection(env: PJNIEnv; _jtcpsocketclient: JObject; _finalMessage: string);  overload;

procedure jTCPSocketClient_SendFile(env: PJNIEnv; _jtcpsocketclient: JObject; fullPath: string);
procedure jTCPSocketClient_SetSendFileProgressStep(env: PJNIEnv; _jtcpsocketclient: JObject; _bytes: integer);

procedure jTCPSocketClient_SetTimeOut(env: PJNIEnv; _jtcpsocketclient: JObject; _millisecondsTimeOut: integer);
function jTCPSocketClient_SendBytes(env: PJNIEnv; _jtcpsocketclient: JObject; var _jbyteArray: TDynArrayOfJByte; _writeLength: boolean): boolean;
procedure jTCPSocketClient_SetDataTransferMode(env: PJNIEnv; _jtcpsocketclient: JObject; _dataType: integer);
procedure jTCPSocketClient_CloseConnection(env: PJNIEnv; _jtcpsocketclient: JObject; _jbtyte: jByte); overload;

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

function jTCPSocketClient.SendMessage(message: string) : boolean;
begin

  //in designing component state: set value here...
  if FInitialized then
   Result:= jTCPSocketClient_SendMessage(FjEnv, FjObject, message);

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

function jTCPSocketClient.ConnectAsync(_serverIP: string; _serverPort: integer; _login: string): boolean; overload;
begin
  //in designing component state: set value here...
  if FInitialized then
   Result:= jTCPSocketClient_Connect(FjEnv, FjObject, _serverIP ,_serverPort ,_login);

end;

function jTCPSocketClient.ConnectAsync(_serverIP: string; _serverPort: integer): boolean; overload;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTCPSocketClient_Connect(FjEnv, FjObject, _serverIP ,_serverPort);
end;

function jTCPSocketClient.ConnectAsyncTimeOut(_serverIP: string; _serverPort: integer; _timeOut: integer): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTCPSocketClient_Connect(FjEnv, FjObject, _serverIP ,_serverPort ,_timeOut);
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

procedure jTCPSocketClient.SetTimeOut(_millisecondsTimeOut: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_SetTimeOut(FjEnv, FjObject, _millisecondsTimeOut);
end;

function jTCPSocketClient.SendBytes(var _jbyteArray: TDynArrayOfJByte; _writeLength: boolean): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTCPSocketClient_SendBytes(FjEnv, FjObject, _jbyteArray ,_writeLength);
end;

procedure jTCPSocketClient.SetDataTransferMode(_dataTransferMode: TDataTransferMode);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_SetDataTransferMode(FjEnv, FjObject, Ord(_dataTransferMode));
end;

procedure jTCPSocketClient.CloseConnection(_jbtyte: jByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTCPSocketClient_CloseConnection(FjEnv, FjObject, _jbtyte);
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientMessagesReceived(Sender: TObject; messagesReceived: array of string);
begin
  if Assigned(FOnMessagesReceived) then  FOnMessagesReceived(Sender, messagesReceived);
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientBytesReceived(Sender: TObject;  var jbytesReceived: TDynArrayOfJByte);
begin
  if Assigned(FOnBytesReceived) then FOnBytesReceived(Sender, jbytesReceived);
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

function jTCPSocketClient_SendMessage(env: PJNIEnv; _jtcpsocketclient: JObject; message: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(message));
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SendMessage', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  Result:= boolean(jBoo);
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

function jTCPSocketClient_Connect(env: PJNIEnv; _jtcpsocketclient: JObject; _serverIP: string; _serverPort: integer; _login: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_serverIP));
  jParams[1].i:= _serverPort;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_login));
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;ILjava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  Result:= boolean(jBoo);
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

function jTCPSocketClient_Connect(env: PJNIEnv; _jtcpsocketclient: JObject; _serverIP: string; _serverPort: integer; _timeOut: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_serverIP));
  jParams[1].i:= _serverPort;
  jParams[2].i:= _timeOut;
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;II)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jTCPSocketClient_Connect(env: PJNIEnv; _jtcpsocketclient: JObject; _serverIP: string; _serverPort: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_serverIP));
  jParams[1].i:= _serverPort;
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  Result:= boolean(jBoo);
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

procedure jTCPSocketClient_SetTimeOut(env: PJNIEnv; _jtcpsocketclient: JObject; _millisecondsTimeOut: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _millisecondsTimeOut;
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTimeOut', '(I)V');
  env^.CallVoidMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jTCPSocketClient_SendBytes(env: PJNIEnv; _jtcpsocketclient: JObject; var _jbyteArray: TDynArrayOfJByte; _writeLength: boolean): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_jbyteArray);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_jbyteArray[0] {source});
  jParams[0].l:= jNewArray0;
  jParams[1].z:= JBool(_writeLength);
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SendBytes', '([BZ)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTCPSocketClient_SetDataTransferMode(env: PJNIEnv; _jtcpsocketclient: JObject; _dataType: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _dataType;
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDataTransferMode', '(I)V');
  env^.CallVoidMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jTCPSocketClient_CloseConnection(env: PJNIEnv; _jtcpsocketclient: JObject; _jbtyte: jByte);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].b:= _jbtyte;
  jCls:= env^.GetObjectClass(env, _jtcpsocketclient);
  jMethod:= env^.GetMethodID(env, jCls, 'CloseConnection', '(B)V');
  env^.CallVoidMethodA(env, _jtcpsocketclient, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
