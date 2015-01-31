unit bluetoothserversocket;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/16/2014 14:48:33]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

TOnConnected = procedure(Sender: TObject; deviceName: string; deviceAddress: string) of Object;
TOnIncomingMessage = procedure(Sender: TObject; messageText: string) of Object;
TOnListen = procedure(Sender: TObject; deviceName: string; deviceAddress: string) of Object;
TOnAccept = procedure(Sender: TObject; deviceName: string; deviceAddress: string; var accept: boolean) of Object;

{jControl template}

jBluetoothServerSocket = class(jControl)
 private
    FUUID: string;
    FOnConnected: TOnConnected;
    FOnIncomingMessage: TOnIncomingMessage;
    FOnWritingMessage: TOnNotify;
    FOnListen: TOnListen;
    FOnAccept: TOnAccept;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetUUID(_strUUID: string);
    procedure Listen();
    procedure WriteMessage(_message: string);
    procedure Write(var _buffer: TDynArrayOfJByte);
    procedure CloseServerSocket();
    function IsConnected(): boolean;
    procedure Disconnect();
    procedure StopListen();
    function IsListen(): boolean;
    procedure SetAccept(_accept: boolean);
    function Read(): TDynArrayOfJByte;

    procedure GenEvent_OnBluetoothServerSocketConnected(Obj: TObject; _deviceName: string; _deviceAddress: string);
    procedure GenEvent_OnBluetoothServerSocketIncomingMessage(Obj: TObject; _messageText: string);
    procedure GenEvent_OnBluetoothServerSocketWritingMessage(Obj: TObject);
    procedure GenEvent_OnBluetoothServerSocketListen(Obj: TObject; _deviceName: string; _deviceAddress: string);
    procedure GenEvent_OnBluetoothServerSocketAccept(Obj: TObject; _deviceName: string; _deviceAddress: string);

 published
    property UUID: string read FUUID write SetUUID;
    property OnConnected: TOnConnected read FOnConnected write FOnConnected;
    property OnIncomingMessage: TOnIncomingMessage read FOnIncomingMessage write FOnIncomingMessage;
    property OnWritingMessage: TOnNotify read FOnWritingMessage write FOnWritingMessage;
    property OnListen: TOnListen read FOnListen write FOnListen;
    property OnAccept: TOnAccept read FOnAccept write FOnAccept;
end;

procedure jBluetoothServerSocket_handleMessage(env: PJNIEnv; _jbluetoothserversocket: JObject; msg: jObject);
function jBluetoothServerSocket_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jBluetoothServerSocket_jFree(env: PJNIEnv; _jbluetoothserversocket: JObject);
procedure jBluetoothServerSocket_SetUUID(env: PJNIEnv; _jbluetoothserversocket: JObject; _strUUID: string);
procedure jBluetoothServerSocket_Listen(env: PJNIEnv; _jbluetoothserversocket: JObject);
procedure jBluetoothServerSocket_WriteMessage(env: PJNIEnv; _jbluetoothserversocket: JObject; _message: string);
procedure jBluetoothServerSocket_Write(env: PJNIEnv; _jbluetoothserversocket: JObject; var _buffer: TDynArrayOfJByte);
procedure jBluetoothServerSocket_CloseServerSocket(env: PJNIEnv; _jbluetoothserversocket: JObject);

procedure jBluetoothServerSocket_Disconnect(env: PJNIEnv; _jbluetoothserversocket: JObject);
function jBluetoothServerSocket_IsConnected(env: PJNIEnv; _jbluetoothserversocket: JObject): boolean;
procedure jBluetoothServerSocket_StopListen(env: PJNIEnv; _jbluetoothserversocket: JObject);
function jBluetoothServerSocket_IsListen(env: PJNIEnv; _jbluetoothserversocket: JObject): boolean;
procedure jBluetoothServerSocket_SetAccept(env: PJNIEnv; _jbluetoothserversocket: JObject; _accept: boolean);
function jBluetoothServerSocket_Read(env: PJNIEnv; _jbluetoothserversocket: JObject): TDynArrayOfJByte;


implementation

{---------  jBluetoothServerSocket  --------------}

constructor jBluetoothServerSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;

destructor jBluetoothServerSocket.Destroy;
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

procedure jBluetoothServerSocket.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
  if FUUID <> '' then Self.SetUUID(FUUID);
end;


function jBluetoothServerSocket.jCreate(): jObject;
begin
   Result:= jBluetoothServerSocket_jCreate(FjEnv, FjThis , int64(Self));
end;

procedure jBluetoothServerSocket.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_jFree(FjEnv, FjObject);
end;

procedure jBluetoothServerSocket.SetUUID(_strUUID: string);
begin
  //in designing component state: set value here...
  FUUID:=  _strUUID;
  if FInitialized then
     jBluetoothServerSocket_SetUUID(FjEnv, FjObject, _strUUID);
end;

procedure jBluetoothServerSocket.Listen();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_Listen(FjEnv, FjObject);
end;

procedure jBluetoothServerSocket.WriteMessage(_message: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_WriteMessage(FjEnv, FjObject, _message);
end;

procedure jBluetoothServerSocket.Write(var _buffer: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_Write(FjEnv, FjObject, _buffer);
end;

procedure jBluetoothServerSocket.CloseServerSocket();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_CloseServerSocket(FjEnv, FjObject);
end;

procedure jBluetoothServerSocket.Disconnect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_Disconnect(FjEnv, FjObject);
end;

function jBluetoothServerSocket.IsConnected(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothServerSocket_IsConnected(FjEnv, FjObject);
end;

procedure jBluetoothServerSocket.StopListen();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_StopListen(FjEnv, FjObject);
end;

function jBluetoothServerSocket.IsListen(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothServerSocket_IsListen(FjEnv, FjObject);
end;

procedure jBluetoothServerSocket.SetAccept(_accept: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_SetAccept(FjEnv, FjObject, _accept);
end;


function jBluetoothServerSocket.Read(): TDynArrayOfJByte;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothServerSocket_Read(FjEnv, FjObject);
end;

procedure jBluetoothServerSocket.GenEvent_OnBluetoothServerSocketConnected(Obj: TObject; _deviceName: string; _deviceAddress: string);
begin
  if Assigned(FOnConnected) then FOnConnected(Obj,_deviceName, _deviceAddress);
end;

procedure jBluetoothServerSocket.GenEvent_OnBluetoothServerSocketIncomingMessage(Obj: TObject; _messageText: string);
begin
  if Assigned(FOnIncomingMessage) then FOnIncomingMessage(Obj,_messageText);
end;

procedure jBluetoothServerSocket.GenEvent_OnBluetoothServerSocketWritingMessage(Obj: TObject);
begin
  if Assigned(FOnWritingMessage) then FOnWritingMessage(Obj);
end;

procedure jBluetoothServerSocket.GenEvent_OnBluetoothServerSocketListen(Obj: TObject; _deviceName: string; _deviceAddress: string);
begin
  if Assigned(FOnListen) then FOnListen(Obj, _deviceName, _deviceAddress);
end;

procedure jBluetoothServerSocket.GenEvent_OnBluetoothServerSocketAccept(Obj: TObject; _deviceName: string; _deviceAddress: string);
var
  accept: boolean;
begin
  accept:= True;
  if Assigned(FOnAccept) then FOnAccept(Obj, _deviceName, _deviceAddress, accept);
  if not accept then  Self.SetAccept(False);
end;

{-------- jBluetoothServerSocket_JNI_Bridge ----------}

procedure jBluetoothServerSocket_handleMessage(env: PJNIEnv; _jbluetoothserversocket: JObject; msg: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= msg;
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'handleMessage', '(Landroid/os/Message;)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
end;


function jBluetoothServerSocket_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jBluetoothServerSocket_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jBluetoothServerSocket_jCreate(long _Self) {
      return (java.lang.Object)(new jBluetoothServerSocket(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jBluetoothServerSocket_jFree(env: PJNIEnv; _jbluetoothserversocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jbluetoothserversocket, jMethod);
end;


procedure jBluetoothServerSocket_SetUUID(env: PJNIEnv; _jbluetoothserversocket: JObject; _strUUID: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_strUUID));
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUUID', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jBluetoothServerSocket_Listen(env: PJNIEnv; _jbluetoothserversocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Listen', '()V');
  env^.CallVoidMethod(env, _jbluetoothserversocket, jMethod);
end;

procedure jBluetoothServerSocket_WriteMessage(env: PJNIEnv; _jbluetoothserversocket: JObject; _message: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_message));
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'WriteMessage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jBluetoothServerSocket_Write(env: PJNIEnv; _jbluetoothserversocket: JObject; var _buffer: TDynArrayOfJByte);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_buffer);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_buffer[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Write', '([B)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;

procedure jBluetoothServerSocket_CloseServerSocket(env: PJNIEnv; _jbluetoothserversocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'CloseServerSocket', '()V');
  env^.CallVoidMethod(env, _jbluetoothserversocket, jMethod);
end;

procedure jBluetoothServerSocket_Disconnect(env: PJNIEnv; _jbluetoothserversocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Disconnect', '()V');
  env^.CallVoidMethod(env, _jbluetoothserversocket, jMethod);
end;

function jBluetoothServerSocket_IsConnected(env: PJNIEnv; _jbluetoothserversocket: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'IsConnected', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetoothserversocket, jMethod);
  Result:= boolean(jBoo);
end;

procedure jBluetoothServerSocket_StopListen(env: PJNIEnv; _jbluetoothserversocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'StopListen', '()V');
  env^.CallVoidMethod(env, _jbluetoothserversocket, jMethod);
end;


function jBluetoothServerSocket_IsListen(env: PJNIEnv; _jbluetoothserversocket: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'IsListen', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetoothserversocket, jMethod);
  Result:= boolean(jBoo);
end;

procedure jBluetoothServerSocket_SetAccept(env: PJNIEnv; _jbluetoothserversocket: JObject; _accept: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_accept);
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAccept', '(Z)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
end;

function jBluetoothServerSocket_Read(env: PJNIEnv; _jbluetoothserversocket: JObject): TDynArrayOfJByte;
var
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Read', '()[B');
  jresultArray:= env^.CallObjectMethod(env, _jbluetoothserversocket, jMethod);
  if jresultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    env^.GetByteArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
end;


end.
