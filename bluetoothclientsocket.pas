unit bluetoothclientsocket;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/16/2014 14:36:32]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

TOnConnected = procedure(Sender: TObject; deviceName: string; deviceAddress: string) of Object;
TOnIncomingMessage = procedure(Sender: TObject; messageText: string) of Object;

{jControl template}

jBluetoothClientSocket = class(jControl)
 private
    FUUID: string;
    FOnConnected: TOnConnected;
    FOnIncomingMessage: TOnIncomingMessage;
    FOnWritingMessage: TOnNotify;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetDevice(_device: jObject);
    procedure SetUUID(_strUUID: string);
    procedure Connect();
    procedure Write(var _buffer: TDynArrayOfJByte);
    procedure WriteMessage(_message: string);
    function Read(): TDynArrayOfJByte;
    function IsConnected(): boolean;
    procedure Disconnect();

    procedure GenEvent_OnBluetoothClientSocketConnected(Obj: TObject; _deviceName: string; _deviceAddress: string);
    procedure GenEvent_OnBluetoothClientSocketIncomingMessage(Obj: TObject; _messageText: string);
    procedure GenEvent_OnBluetoothClientSocketWritingMessage(Obj: TObject);

 published
    property UUID: string read FUUID write SetUUID;
    property OnConnected: TOnConnected read FOnConnected write FOnConnected;
    property OnIncomingMessage: TOnIncomingMessage read FOnIncomingMessage write FOnIncomingMessage;
    property OnWritingMessage: TOnNotify read FOnWritingMessage write FOnWritingMessage;
end;

function jBluetoothClientSocket_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jBluetoothClientSocket_jFree(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject);
procedure jBluetoothClientSocket_SetDevice(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject; _device: jObject);
procedure jBluetoothClientSocket_SetUUID(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject; _strUUID: string);
procedure jBluetoothClientSocket_Connect(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject);
procedure jBluetoothClientSocket_Write(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject; var _buffer: TDynArrayOfJByte);
procedure jBluetoothClientSocket_WriteMessage(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject; _message: string);
function jBluetoothClientSocket_Read(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject): TDynArrayOfJByte;
function jBluetoothClientSocket_IsConnected(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject): boolean;
procedure jBluetoothClientSocket_Disconnect(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject);


implementation

{---------  jBluetoothClientSocket  --------------}

constructor jBluetoothClientSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....

  //Well known SPP UUID
  FUUID:= '00001101-0000-1000-8000-00805F9B34FB';
end;

destructor jBluetoothClientSocket.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jFree();
           FjObject:= nil;
        end;
      end;
    end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jBluetoothClientSocket.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
  if FUUID <> '' then Self.SetUUID(FUUID);
end;

function jBluetoothClientSocket.jCreate(): jObject;
begin
  Result:= jBluetoothClientSocket_jCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis , int64(Self));
end;

procedure jBluetoothClientSocket.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_jFree(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetoothClientSocket.SetDevice(_device: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_SetDevice(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _device);
end;

procedure jBluetoothClientSocket.SetUUID(_strUUID: string);
begin
  //in designing component state: set value here...
  FUUID:= _strUUID;
  if FInitialized then
     jBluetoothClientSocket_SetUUID(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _strUUID);
end;

function jBluetoothClientSocket.IsConnected(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothClientSocket_IsConnected(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetoothClientSocket.Connect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_Connect(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetoothClientSocket.Write(var _buffer: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_Write(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _buffer);
end;

procedure jBluetoothClientSocket.WriteMessage(_message: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_WriteMessage(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, _message);
end;

function jBluetoothClientSocket.Read(): TDynArrayOfJByte;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothClientSocket_Read(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jBluetoothClientSocket.GenEvent_OnBluetoothClientSocketConnected(Obj: TObject; _deviceName: string; _deviceAddress: string);
begin
  if Assigned(FOnConnected) then FOnConnected(Obj,_deviceName, _deviceAddress);
end;

procedure jBluetoothClientSocket.GenEvent_OnBluetoothClientSocketIncomingMessage(Obj: TObject; _messageText: string);
begin
  if Assigned(FOnIncomingMessage) then FOnIncomingMessage(Obj,_messageText);
end;

procedure jBluetoothClientSocket.GenEvent_OnBluetoothClientSocketWritingMessage(Obj: TObject);
begin
  if Assigned(FOnWritingMessage) then FOnWritingMessage(Obj);
end;

procedure jBluetoothClientSocket.Disconnect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_Disconnect(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

{-------- jBluetoothClientSocket_JNI_Bridge ----------}

function jBluetoothClientSocket_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jBluetoothClientSocket_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jBluetoothClientSocket_jCreate(long _Self) {
      return (java.lang.Object)(new jBluetoothClientSocket(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jBluetoothClientSocket_jFree(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jbluetoothclientsocket, jMethod);
end;


procedure jBluetoothClientSocket_SetDevice(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject; _device: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _device;
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDevice', '(Landroid/bluetooth/BluetoothDevice;)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
end;


procedure jBluetoothClientSocket_SetUUID(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject; _strUUID: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_strUUID));
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUUID', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;


procedure jBluetoothClientSocket_Connect(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '()V');
  env^.CallVoidMethod(env, _jbluetoothclientsocket, jMethod);
end;

procedure jBluetoothClientSocket_Write(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject; var _buffer: TDynArrayOfJByte);
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
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Write', '([B)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
end;


procedure jBluetoothClientSocket_WriteMessage(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject; _message: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_message));
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'WriteMessage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
end;

function jBluetoothClientSocket_Read(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject): TDynArrayOfJByte;
var
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Read', '()[B');
  jresultArray:= env^.CallObjectMethod(env, _jbluetoothclientsocket, jMethod);
  resultsize:= env^.GetArrayLength(env, jresultArray);
  SetLength(Result, resultsize);
  env^.GetByteArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
end;

function jBluetoothClientSocket_IsConnected(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'IsConnected', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetoothclientsocket, jMethod);
  Result:= boolean(jBoo);
end;


procedure jBluetoothClientSocket_Disconnect(env: PJNIEnv; this: JObject; _jbluetoothclientsocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Disconnect', '()V');
  env^.CallVoidMethod(env, _jbluetoothclientsocket, jMethod);
end;

end.
