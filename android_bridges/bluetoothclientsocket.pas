unit bluetoothclientsocket;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/16/2014 14:36:32]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

TOnConnected = procedure(Sender: TObject; deviceName: string; deviceAddress: string) of Object;
TOnDisconnected = procedure(Sender: TObject) of Object;
TOnIncomingData= procedure(Sender: TObject; var dataContent: TDynArrayOfJByte; dataHeader: TDynArrayOfJByte) of Object;

{jControl template}

jBluetoothClientSocket = class(jControl)
 private
    FUUID: string;
    FOnConnected: TOnConnected;
    FOnIncomingData: TOnIncomingData;
    FReceiverBufferLength: integer;
    FDataHeaderReceiveEnabled: boolean;
    FOnDisconnected: TOnDisconnected;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetDevice(_device: jObject);
    procedure SetUUID(_strUUID: string);
    procedure Connect();  overload;


    procedure WriteMessage(_message: string); overload;
    procedure Write(var _dataContent: TDynArrayOfJByte); overload;

    function IsConnected(): boolean;
    procedure Disconnect();
    function JByteArrayToString(var _byteArray: TDynArrayOfJByte): string;
    function JByteArrayToBitmap(var _byteArray: TDynArrayOfJByte): jObject;

    function GetDataHeaderReceiveEnabled(): boolean;
    procedure SetDataHeaderReceiveEnabled(_value: boolean);
    procedure SetReceiverBufferLength(_value: integer);
    function GetReceiverBufferLength(): integer;
    procedure SaveJByteArrayToFile(var _byteArray: TDynArrayOfJByte; _filePath: string; _fileName: string);

    procedure WriteMessage(_message: string; var _dataHeader: TDynArrayOfJByte); overload;
    procedure Write(var _dataContent: TDynArrayOfJByte; var _dataHeader: TDynArrayOfJByte); overload;
    procedure SendFile(_filePath: string; _fileName: string; var _dataHeader: TDynArrayOfJByte); overload;
    procedure SendFile(_filePath: string; _fileName: string); overload;

    procedure WriteMessage(_message: string; _dataHeader: string); overload;
    procedure Write(var _dataContent: TDynArrayOfJByte; _dataHeader: string); overload;
    procedure SendFile(_filePath: string; _fileName: string; _dataHeader: string); overload;
    procedure Connect(_executeOnThreadPoolExecutor: boolean); overload;

    procedure GenEvent_OnBluetoothClientSocketConnected(Obj: TObject; _deviceName: string; _deviceAddress: string);
    procedure GenEvent_OnBluetoothClientSocketIncomingData(Obj: TObject; var _byteArrayContent: TDynArrayOfJByte; _byteArrayHeader: TDynArrayOfJByte);
    procedure GenEvent_OnBluetoothClientSocketDisconnected(Obj: TObject);

 published
    property UUID: string read FUUID write SetUUID;
    property ReceiverBufferLength: integer read FReceiverBufferLength write SetReceiverBufferLength;
    property DataHeaderReceiveEnabled: boolean read FDataHeaderReceiveEnabled write SetDataHeaderReceiveEnabled;
    property OnConnected: TOnConnected read FOnConnected write FOnConnected;
    property OnIncomingData: TOnIncomingData read  FOnIncomingData write FOnIncomingData;
    property OnDisconnected: TOnDisconnected read  FOnDisconnected write FOnDisconnected;

end;

function jBluetoothClientSocket_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jBluetoothClientSocket_jFree(env: PJNIEnv; _jbluetoothclientsocket: JObject);
procedure jBluetoothClientSocket_SetDevice(env: PJNIEnv; _jbluetoothclientsocket: JObject; _device: jObject);
procedure jBluetoothClientSocket_SetUUID(env: PJNIEnv; _jbluetoothclientsocket: JObject; _strUUID: string);
procedure jBluetoothClientSocket_Connect(env: PJNIEnv; _jbluetoothclientsocket: JObject); overload;

function jBluetoothClientSocket_IsConnected(env: PJNIEnv; _jbluetoothclientsocket: JObject): boolean;
procedure jBluetoothClientSocket_Disconnect(env: PJNIEnv; _jbluetoothclientsocket: JObject);
function jBluetoothClientSocket_ByteArrayToString(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _byteArray: TDynArrayOfJByte): string;
function jBluetoothClientSocket_ByteArrayToBitmap(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _byteArray: TDynArrayOfJByte): jObject;

procedure jBluetoothClientSocket_SetReadBufferLength(env: PJNIEnv; _jbluetoothclientsocket: JObject; _value: integer);
function jBluetoothClientSocket_GetReadBufferLength(env: PJNIEnv; _jbluetoothclientsocket: JObject): integer;

procedure jBluetoothClientSocket_WriteMessage(env: PJNIEnv; _jbluetoothclientsocket: JObject; _message: string); overload;
procedure jBluetoothClientSocket_Write(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _dataContent: TDynArrayOfJByte); overload;

procedure jBluetoothClientSocket_SetReceiverBufferLength(env: PJNIEnv; _jbluetoothclientsocket: JObject; _value: integer);
function jBluetoothClientSocket_GetReceiverBufferLength(env: PJNIEnv; _jbluetoothclientsocket: JObject): integer;

function jBluetoothClientSocket_GetDataHeaderReceiveEnabled(env: PJNIEnv; _jbluetoothclientsocket: JObject): boolean;
procedure jBluetoothClientSocket_SetDataHeaderReceiveEnabled(env: PJNIEnv; _jbluetoothclientsocket: JObject; _value: boolean);
procedure jBluetoothClientSocket_SaveByteArrayToFile(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _byteArray: TDynArrayOfJByte; _filePath: string; _fileName: string);

procedure jBluetoothClientSocket_WriteMessage(env: PJNIEnv; _jbluetoothclientsocket: JObject; _message: string; var _dataHeader: TDynArrayOfJByte); overload;
procedure jBluetoothClientSocket_Write(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _dataContent: TDynArrayOfJByte; var _dataHeader: TDynArrayOfJByte); overload;
procedure jBluetoothClientSocket_SendFile(env: PJNIEnv; _jbluetoothclientsocket: JObject; _filePath: string; _fileName: string; var _dataHeader: TDynArrayOfJByte); overload;
procedure jBluetoothClientSocket_SendFile(env: PJNIEnv; _jbluetoothclientsocket: JObject; _filePath: string; _fileName: string); overload;

procedure jBluetoothClientSocket_WriteMessage(env: PJNIEnv; _jbluetoothclientsocket: JObject; _message: string; _dataHeader: string); overload;
procedure jBluetoothClientSocket_Write(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _dataContent: TDynArrayOfJByte; _dataHeader: string); overload;
procedure jBluetoothClientSocket_SendFile(env: PJNIEnv; _jbluetoothclientsocket: JObject; _filePath: string; _fileName: string; _dataHeader: string); overload;
procedure jBluetoothClientSocket_Connect(env: PJNIEnv; _jbluetoothclientsocket: JObject; _executeOnThreadPoolExecutor: boolean); overload;

implementation

{---------  jBluetoothClientSocket  --------------}

constructor jBluetoothClientSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....

  //Well known SPP UUID
  FUUID:= '00001101-0000-1000-8000-00805F9B34FB';
  FDataHeaderReceiveEnabled:= False;
  FReceiverBufferLength:= 1024;
end;

destructor jBluetoothClientSocket.Destroy;
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

procedure jBluetoothClientSocket.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;

  if FUUID <> '00001101-0000-1000-8000-00805F9B34FB' then
     jBluetoothClientSocket_SetUUID(FjEnv, FjObject, FUUID);

  if FDataHeaderReceiveEnabled = True then
     jBluetoothClientSocket_SetDataHeaderReceiveEnabled(FjEnv, FjObject, FDataHeaderReceiveEnabled);


  if FReceiverBufferLength <> 1024 then
     jBluetoothClientSocket_SetReceiverBufferLength(FjEnv, FjObject, FReceiverBufferLength);

end;

function jBluetoothClientSocket.jCreate(): jObject;
begin
  Result:= jBluetoothClientSocket_jCreate(FjEnv, FjThis , int64(Self));
end;

procedure jBluetoothClientSocket.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_jFree(FjEnv, FjObject);
end;

procedure jBluetoothClientSocket.SetDevice(_device: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_SetDevice(FjEnv, FjObject, _device);
end;

procedure jBluetoothClientSocket.SetUUID(_strUUID: string);
begin
  //in designing component state: set value here...
  FUUID:= _strUUID;
  if FInitialized then
     jBluetoothClientSocket_SetUUID(FjEnv, FjObject, _strUUID);
end;

function jBluetoothClientSocket.IsConnected(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothClientSocket_IsConnected(FjEnv, FjObject);
end;

procedure jBluetoothClientSocket.Connect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_Connect(FjEnv, FjObject);
end;


procedure jBluetoothClientSocket.GenEvent_OnBluetoothClientSocketConnected(Obj: TObject; _deviceName: string; _deviceAddress: string);
begin
  if Assigned(FOnConnected) then FOnConnected(Obj,_deviceName, _deviceAddress);
end;


procedure jBluetoothClientSocket.GenEvent_OnBluetoothClientSocketIncomingData(Obj: TObject; var _byteArrayContent: TDynArrayOfJByte; _byteArrayHeader: TDynArrayOfJByte);
begin
  if Assigned(FOnIncomingData) then FOnIncomingData(Obj,_byteArrayContent, _byteArrayHeader);
end;

procedure jBluetoothClientSocket.GenEvent_OnBluetoothClientSocketDisconnected(Obj: TObject);
begin
  if Assigned(FOnDisconnected) then FOnDisconnected(Obj);
end;

procedure jBluetoothClientSocket.Disconnect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_Disconnect(FjEnv, FjObject);
end;

function jBluetoothClientSocket.JByteArrayToString(var _byteArray: TDynArrayOfJByte): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothClientSocket_ByteArrayToString(FjEnv, FjObject, _byteArray);
end;

function jBluetoothClientSocket.JByteArrayToBitmap(var _byteArray: TDynArrayOfJByte): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothClientSocket_ByteArrayToBitmap(FjEnv, FjObject, _byteArray);
end;

procedure jBluetoothClientSocket.WriteMessage(_message: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_WriteMessage(FjEnv, FjObject, _message);
end;

procedure jBluetoothClientSocket.Write(var _dataContent: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_Write(FjEnv, FjObject, _dataContent);
end;

procedure jBluetoothClientSocket.SetReceiverBufferLength(_value: integer);
begin
  //in designing component state: set value here...
  FReceiverBufferLength:= _value;
  if FInitialized then
     jBluetoothClientSocket_SetReceiverBufferLength(FjEnv, FjObject, _value);
end;

function jBluetoothClientSocket.GetReceiverBufferLength(): integer;
begin
  //in designing component state: result value here...
  Result:= FReceiverBufferLength;
 // if FInitialized then
 //  Result:= jBluetoothClientSocket_GetReceiverBufferLength(FjEnv, FjObject);
end;


function jBluetoothClientSocket.GetDataHeaderReceiveEnabled(): boolean;
begin
  //in designing component state: result value here...
  Result:= FDataHeaderReceiveEnabled;

  //if FInitialized then  //commented for better performace!
    //Result:= jBluetoothClientSocket_GetDataHeaderReceiveEnabled(FjEnv, FjObject);
end;

procedure jBluetoothClientSocket.SetDataHeaderReceiveEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  FDataHeaderReceiveEnabled:= _value;
  if FInitialized then
     jBluetoothClientSocket_SetDataHeaderReceiveEnabled(FjEnv, FjObject, _value);
end;

procedure jBluetoothClientSocket.SaveJByteArrayToFile(var _byteArray: TDynArrayOfJByte; _filePath: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_SaveByteArrayToFile(FjEnv, FjObject, _byteArray ,_filePath ,_fileName);
end;

procedure jBluetoothClientSocket.WriteMessage(_message: string; var _dataHeader: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_WriteMessage(FjEnv, FjObject, _message ,_dataHeader);
end;

procedure jBluetoothClientSocket.Write(var _dataContent: TDynArrayOfJByte; var _dataHeader: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_Write(FjEnv, FjObject, _dataContent ,_dataHeader);
end;

procedure jBluetoothClientSocket.SendFile(_filePath: string; _fileName: string; var _dataHeader: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_SendFile(FjEnv, FjObject, _filePath ,_fileName ,_dataHeader);
end;

procedure jBluetoothClientSocket.SendFile(_filePath: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_SendFile(FjEnv, FjObject, _filePath ,_fileName);
end;

procedure jBluetoothClientSocket.WriteMessage(_message: string; _dataHeader: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_WriteMessage(FjEnv, FjObject, _message ,_dataHeader);
end;

procedure jBluetoothClientSocket.Write(var _dataContent: TDynArrayOfJByte; _dataHeader: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_Write(FjEnv, FjObject, _dataContent ,_dataHeader);
end;

procedure jBluetoothClientSocket.SendFile(_filePath: string; _fileName: string; _dataHeader: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_SendFile(FjEnv, FjObject, _filePath ,_fileName ,_dataHeader);
end;

procedure jBluetoothClientSocket.Connect(_executeOnThreadPoolExecutor: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothClientSocket_Connect(FjEnv, FjObject, _executeOnThreadPoolExecutor);
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


procedure jBluetoothClientSocket_jFree(env: PJNIEnv; _jbluetoothclientsocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jbluetoothclientsocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_SetDevice(env: PJNIEnv; _jbluetoothclientsocket: JObject; _device: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _device;
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDevice', '(Landroid/bluetooth/BluetoothDevice;)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_SetUUID(env: PJNIEnv; _jbluetoothclientsocket: JObject; _strUUID: string);
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
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_Connect(env: PJNIEnv; _jbluetoothclientsocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '()V');
  env^.CallVoidMethod(env, _jbluetoothclientsocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jBluetoothClientSocket_IsConnected(env: PJNIEnv; _jbluetoothclientsocket: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'IsConnected', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetoothclientsocket, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_Disconnect(env: PJNIEnv; _jbluetoothclientsocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Disconnect', '()V');
  env^.CallVoidMethod(env, _jbluetoothclientsocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetoothClientSocket_ByteArrayToString(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _byteArray: TDynArrayOfJByte): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_byteArray);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_byteArray[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'ByteArrayToString', '([B)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jBluetoothClientSocket_ByteArrayToBitmap(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _byteArray: TDynArrayOfJByte): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_byteArray);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_byteArray[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'ByteArrayToBitmap', '([B)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_SetReadFirstByteAsHeader(env: PJNIEnv; _jbluetoothclientsocket: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetReadFirstByteAsHeader', '(Z)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetoothClientSocket_GetReadFirstByteAsHeader(env: PJNIEnv; _jbluetoothclientsocket: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'GetReadFirstByteAsHeader', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetoothclientsocket, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothClientSocket_SetReadBufferLength(env: PJNIEnv; _jbluetoothclientsocket: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetReadBufferLength', '(I)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jBluetoothClientSocket_GetReadBufferLength(env: PJNIEnv; _jbluetoothclientsocket: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'GetReadBufferLength', '()I');
  Result:= env^.CallIntMethod(env, _jbluetoothclientsocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_WriteMessage(env: PJNIEnv; _jbluetoothclientsocket: JObject; _message: string);
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
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_Write(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _dataContent: TDynArrayOfJByte);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_dataContent);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_dataContent[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Write', '([B)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothClientSocket_SetReceiverBufferLength(env: PJNIEnv; _jbluetoothclientsocket: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetReceiverBufferLength', '(I)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetoothClientSocket_GetReceiverBufferLength(env: PJNIEnv; _jbluetoothclientsocket: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'GetReceiverBufferLength', '()I');
  Result:= env^.CallIntMethod(env, _jbluetoothclientsocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetoothClientSocket_GetDataHeaderReceiveEnabled(env: PJNIEnv; _jbluetoothclientsocket: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDataHeaderReceiveEnabled', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetoothclientsocket, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_SetDataHeaderReceiveEnabled(env: PJNIEnv; _jbluetoothclientsocket: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDataHeaderReceiveEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_SaveByteArrayToFile(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _byteArray: TDynArrayOfJByte; _filePath: string; _fileName: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_byteArray);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_byteArray[0] {source});
  jParams[0].l:= jNewArray0;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filePath));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveByteArrayToFile', '([BLjava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_WriteMessage(env: PJNIEnv; _jbluetoothclientsocket: JObject; _message: string; var _dataHeader: TDynArrayOfJByte);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_message));
  newSize0:= Length(_dataHeader);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_dataHeader[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'WriteMessage', '(Ljava/lang/String;[B)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_Write(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _dataContent: TDynArrayOfJByte; var _dataHeader: TDynArrayOfJByte);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
begin
  newSize0:= Length(_dataContent);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_dataContent[0] {source});
  jParams[0].l:= jNewArray0;
  newSize1:= Length(_dataHeader);
  jNewArray1:= env^.NewByteArray(env, newSize1);  // allocate
  env^.SetByteArrayRegion(env, jNewArray1, 0 , newSize1, @_dataHeader[0] {source});
  jParams[1].l:= jNewArray1;
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Write', '([B[B)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_SendFile(env: PJNIEnv; _jbluetoothclientsocket: JObject; _filePath: string; _fileName: string; var _dataHeader: TDynArrayOfJByte);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filePath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  newSize0:= Length(_dataHeader);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_dataHeader[0] {source});
  jParams[2].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SendFile', '(Ljava/lang/String;Ljava/lang/String;[B)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_SendFile(env: PJNIEnv; _jbluetoothclientsocket: JObject; _filePath: string; _fileName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filePath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SendFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothClientSocket_WriteMessage(env: PJNIEnv; _jbluetoothclientsocket: JObject; _message: string; _dataHeader: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_message));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataHeader));
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'WriteMessage', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_Write(env: PJNIEnv; _jbluetoothclientsocket: JObject; var _dataContent: TDynArrayOfJByte; _dataHeader: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_dataContent);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_dataContent[0] {source});
  jParams[0].l:= jNewArray0;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataHeader));
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Write', '([BLjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothClientSocket_SendFile(env: PJNIEnv; _jbluetoothclientsocket: JObject; _filePath: string; _fileName: string; _dataHeader: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filePath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_dataHeader));
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SendFile', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothClientSocket_Connect(env: PJNIEnv; _jbluetoothclientsocket: JObject; _executeOnThreadPoolExecutor: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_executeOnThreadPoolExecutor);
  jCls:= env^.GetObjectClass(env, _jbluetoothclientsocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Z)V');
  env^.CallVoidMethodA(env, _jbluetoothclientsocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
