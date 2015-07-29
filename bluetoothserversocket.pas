unit bluetoothserversocket;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/16/2014 14:48:33]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

TOnConnected = procedure(Sender: TObject; deviceName: string; deviceAddress: string; out keepConnected: boolean) of Object;
TOnIncomingData= procedure(Sender: TObject; var dataContent: TDynArrayOfJByte; dataHeader: TDynArrayOfJByte; out keepConnected: boolean) of Object;
TOnListen = procedure(Sender: TObject; serverName: string; strUUID:string) of Object;

TOnAcceptTimeout= procedure(Sender: TObject) of Object;

{jControl template}

jBluetoothServerSocket = class(jControl)
 private
    FUUID: string;
    FOnConnected: TOnConnected;
    FOnIncomingData: TOnIncomingData;
    FOnListen: TOnListen;
    FOnTimeout:  TOnAcceptTimeout;
    FTimeout: integer;

    FReceiverBufferLength: integer;
    FDataHeaderReceiveEnabled: boolean;

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetUUID(_strUUID: string);
    procedure Listen();


    procedure WriteMessage(_message: string);  overload;
    procedure Write(var _dataContent: TDynArrayOfJByte); overload;

    procedure CancelListening();
    function IsClientConnected(): boolean;
    procedure DisconnectClient();

    procedure SetTimeout(_milliseconds: integer);
    function JByteArrayToString(var _byteArray: TDynArrayOfJByte): string;
    function JByteArrayToBitmap(var _byteArray: TDynArrayOfJByte): jObject;

    procedure SetReceiverBufferLength(_value: integer);
    function GetReceiverBufferLength(): integer;
    function GetDataHeaderReceiveEnabled(): boolean;
    procedure SetDataHeaderReceiveEnabled(_value: boolean);

    procedure SaveJByteArrayToFile(var _byteArray: TDynArrayOfJByte; _filePath: string; _fileName: string);

    procedure WriteMessage(_message: string; var _dataHeader: TDynArrayOfJByte); overload;
    procedure Write(var _dataContent: TDynArrayOfJByte; var _dataHeader: TDynArrayOfJByte); overload;
    procedure SendFile(_filePath: string; _fileName: string; var _dataHeader: TDynArrayOfJByte);  overload;
    procedure SendFile(_filePath: string; _fileName: string); overload;

    procedure WriteMessage(_message: string; _dataHeader: string);  overload;
    procedure Write(var _dataContent: TDynArrayOfJByte; _dataHeader: string); overload;
    procedure SendFile(_filePath: string; _fileName: string; _dataHeader: string); overload;

    procedure GenEvent_OnBluetoothServerSocketConnected(Obj: TObject; _deviceName: string; _deviceAddress: string; out keepConnected: boolean);
    procedure GenEvent_OnBluetoothServerSocketIncomingData(Obj: TObject; var _byteArrayContent: TDynArrayOfJByte; _byteArrayHeader: TDynArrayOfJByte; out _keepConnected: boolean);

    procedure GenEvent_OnBluetoothServerSocketListen(Obj: TObject; _serverName: string; _strUUID:string);
    procedure GenEvent_OnBluetoothServerSocketAcceptTimeout(Obj: TObject);

 published
    property UUID: string read FUUID write SetUUID;
    property Timeout: integer read FTimeout write SetTimeout;
    property ReceiverBufferLength: integer read FReceiverBufferLength write SetReceiverBufferLength;
    property DataHeaderReceiveEnabled: boolean read FDataHeaderReceiveEnabled write SetDataHeaderReceiveEnabled;
    property OnConnected: TOnConnected read FOnConnected write FOnConnected;
    property OnIncomingData: TOnIncomingData read FOnIncomingData write FOnIncomingData;
    property OnListening: TOnListen read FOnListen write FOnListen;
    property OnTimeout:  TOnAcceptTimeout read FOnTimeout write FOnTimeout;
end;

function jBluetoothServerSocket_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jBluetoothServerSocket_jFree(env: PJNIEnv; _jbluetoothserversocket: JObject);
procedure jBluetoothServerSocket_SetUUID(env: PJNIEnv; _jbluetoothserversocket: JObject; _strUUID: string);
procedure jBluetoothServerSocket_Listen(env: PJNIEnv; _jbluetoothserversocket: JObject);
procedure jBluetoothServerSocket_CancelListening(env: PJNIEnv; _jbluetoothserversocket: JObject);

procedure jBluetoothServerSocket_Disconnect(env: PJNIEnv; _jbluetoothserversocket: JObject);
function jBluetoothServerSocket_IsConnected(env: PJNIEnv; _jbluetoothserversocket: JObject): boolean;

procedure jBluetoothServerSocket_SetTimeout(env: PJNIEnv; _jbluetoothserversocket: JObject; _milliseconds: integer);
function jBluetoothServerSocket_ByteArrayToString(env: PJNIEnv; _jbluetoothserversocket: JObject; var _byteArray: TDynArrayOfJByte): string;
function jBluetoothServerSocket_ByteArrayToBitmap(env: PJNIEnv; _jbluetoothserversocket: JObject; var _byteArray: TDynArrayOfJByte): jObject;

procedure jBluetoothServerSocket_WriteMessage(env: PJNIEnv; _jbluetoothserversocket: JObject; _message: string); overload;
procedure jBluetoothServerSocket_Write(env: PJNIEnv; _jbluetoothserversocket: JObject; var _dataContent: TDynArrayOfJByte); overload;

procedure jBluetoothServerSocket_SetReceiverBufferLength(env: PJNIEnv; _jbluetoothserversocket: JObject; _value: integer);
function jBluetoothServerSocket_GetReceiverBufferLength(env: PJNIEnv; _jbluetoothserversocket: JObject): integer;

function jBluetoothServerSocket_GetDataHeaderReceiveEnabled(env: PJNIEnv; _jbluetoothserversocket: JObject): boolean;
procedure jBluetoothServerSocket_SetDataHeaderReceiveEnabled(env: PJNIEnv; _jbluetoothserversocket: JObject; _value: boolean);

procedure jBluetoothServerSocket_SaveByteArrayToFile(env: PJNIEnv; _jbluetoothserversocket: JObject; var _byteArray: TDynArrayOfJByte; _filePath: string; _fileName: string);

procedure jBluetoothServerSocket_WriteMessage(env: PJNIEnv; _jbluetoothserversocket: JObject; _message: string; var _dataHeader: TDynArrayOfJByte);overload;
procedure jBluetoothServerSocket_Write(env: PJNIEnv; _jbluetoothserversocket: JObject; var _dataContent: TDynArrayOfJByte; var _dataHeader: TDynArrayOfJByte);overload;
procedure jBluetoothServerSocket_SendFile(env: PJNIEnv; _jbluetoothserversocket: JObject; _filePath: string; _fileName: string; var _dataHeader: TDynArrayOfJByte);overload;
procedure jBluetoothServerSocket_SendFile(env: PJNIEnv; _jbluetoothserversocket: JObject; _filePath: string; _fileName: string); overload;

procedure jBluetoothServerSocket_WriteMessage(env: PJNIEnv; _jbluetoothserversocket: JObject; _message: string; _dataHeader: string); overload;
procedure jBluetoothServerSocket_Write(env: PJNIEnv; _jbluetoothserversocket: JObject; var _dataContent: TDynArrayOfJByte; _dataHeader: string); overload;
procedure jBluetoothServerSocket_SendFile(env: PJNIEnv; _jbluetoothserversocket: JObject; _filePath: string; _fileName: string; _dataHeader: string); overload;



implementation

{---------  jBluetoothServerSocket  --------------}

constructor jBluetoothServerSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FTimeout:= -1; //infinity
  FUUID:= '00001101-0000-1000-8000-00805F9B34FB';   //default
  FDataHeaderReceiveEnabled:= False;
  FReceiverBufferLength:= 1024;
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

  if FTimeout > 0 then
     jBluetoothServerSocket_SetTimeout(FjEnv, FjObject, FTimeout);

  if FUUID <> '00001101-0000-1000-8000-00805F9B34FB' then
     jBluetoothServerSocket_SetUUID(FjEnv, FjObject, FUUID);

  if FDataHeaderReceiveEnabled = True then
     jBluetoothServerSocket_SetDataHeaderReceiveEnabled(FjEnv, FjObject, FDataHeaderReceiveEnabled);

  if FReceiverBufferLength <> 1024 then
     jBluetoothServerSocket_SetReceiverBufferLength(FjEnv, FjObject, FReceiverBufferLength);
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

procedure jBluetoothServerSocket.CancelListening();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_CancelListening(FjEnv, FjObject);
end;

procedure jBluetoothServerSocket.DisconnectClient();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_Disconnect(FjEnv, FjObject);
end;

function jBluetoothServerSocket.IsClientConnected(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothServerSocket_IsConnected(FjEnv, FjObject);
end;

procedure jBluetoothServerSocket.SetTimeout(_milliseconds: integer);
begin
  //in designing component state: set value here...
  FTimeout:= _milliseconds;
  if FInitialized then
     jBluetoothServerSocket_SetTimeout(FjEnv, FjObject, _milliseconds);
end;


procedure jBluetoothServerSocket.GenEvent_OnBluetoothServerSocketConnected(Obj: TObject; _deviceName: string; _deviceAddress: string; out keepConnected: boolean);
begin
  if Assigned(FOnConnected) then FOnConnected(Obj,_deviceName, _deviceAddress, keepConnected);
end;

procedure jBluetoothServerSocket.GenEvent_OnBluetoothServerSocketIncomingData(Obj: TObject; var _byteArrayContent: TDynArrayOfJByte; _byteArrayHeader: TDynArrayOfJByte; out _keepConnected: boolean);
begin
  _keepConnected:= True;
  if Assigned(FOnIncomingData) then FOnIncomingData(Obj,_byteArrayContent, _byteArrayHeader, _keepConnected);
end;

procedure jBluetoothServerSocket.GenEvent_OnBluetoothServerSocketListen(Obj: TObject; _serverName: string; _strUUID:string);
begin
  if Assigned(FOnListen) then FOnListen(Obj, _serverName, _strUUID);
end;

procedure jBluetoothServerSocket.GenEvent_OnBluetoothServerSocketAcceptTimeout(Obj: TObject);
begin
  if Assigned(FOnTimeout) then FOnTimeout(Obj);
end;

function jBluetoothServerSocket.JByteArrayToString(var _byteArray: TDynArrayOfJByte): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothServerSocket_ByteArrayToString(FjEnv, FjObject, _byteArray);
end;

function jBluetoothServerSocket.JByteArrayToBitmap(var _byteArray: TDynArrayOfJByte): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothServerSocket_ByteArrayToBitmap(FjEnv, FjObject, _byteArray);
end;

procedure jBluetoothServerSocket.WriteMessage(_message: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_WriteMessage(FjEnv, FjObject, _message);
end;

procedure jBluetoothServerSocket.Write(var _dataContent: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_Write(FjEnv, FjObject, _dataContent);
end;

procedure jBluetoothServerSocket.SetReceiverBufferLength(_value: integer);
begin
  //in designing component state: set value here...
  FReceiverBufferLength:= _value;
  if FInitialized then
     jBluetoothServerSocket_SetReceiverBufferLength(FjEnv, FjObject, _value);
end;

function jBluetoothServerSocket.GetReceiverBufferLength(): integer;
begin
  //in designing component state: result value here...
  Result:= FReceiverBufferLength;
  //if FInitialized then
    //Result:= jBluetoothServerSocket_GetReceiverBufferLength(FjEnv, FjObject);
end;

function jBluetoothServerSocket.GetDataHeaderReceiveEnabled(): boolean;
begin
  //in designing component state: result value here...
  Result:= FDataHeaderReceiveEnabled;

  //commented for better performace!
  //if FInitialized then
    //Result:= jBluetoothServerSocket_GetDataHeaderReceiveEnabled(FjEnv, FjObject);
end;

procedure jBluetoothServerSocket.SetDataHeaderReceiveEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  FDataHeaderReceiveEnabled:= _value;
  if FInitialized then
     jBluetoothServerSocket_SetDataHeaderReceiveEnabled(FjEnv, FjObject, _value);
end;

procedure jBluetoothServerSocket.SaveJByteArrayToFile(var _byteArray: TDynArrayOfJByte; _filePath: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_SaveByteArrayToFile(FjEnv, FjObject, _byteArray ,_filePath ,_fileName);
end;

procedure jBluetoothServerSocket.WriteMessage(_message: string; var _dataHeader: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_WriteMessage(FjEnv, FjObject, _message ,_dataHeader);
end;

procedure jBluetoothServerSocket.Write(var _dataContent: TDynArrayOfJByte; var _dataHeader: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_Write(FjEnv, FjObject, _dataContent ,_dataHeader);
end;

procedure jBluetoothServerSocket.SendFile(_filePath: string; _fileName: string; var _dataHeader: TDynArrayOfJByte);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_SendFile(FjEnv, FjObject, _filePath ,_fileName ,_dataHeader);
end;

procedure jBluetoothServerSocket.SendFile(_filePath: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_SendFile(FjEnv, FjObject, _filePath ,_fileName);
end;

procedure jBluetoothServerSocket.WriteMessage(_message: string; _dataHeader: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_WriteMessage(FjEnv, FjObject, _message ,_dataHeader);
end;

procedure jBluetoothServerSocket.Write(var _dataContent: TDynArrayOfJByte; _dataHeader: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_Write(FjEnv, FjObject, _dataContent ,_dataHeader);
end;

procedure jBluetoothServerSocket.SendFile(_filePath: string; _fileName: string; _dataHeader: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothServerSocket_SendFile(FjEnv, FjObject, _filePath ,_fileName ,_dataHeader);
end;

{-------- jBluetoothServerSocket_JNI_Bridge ----------}


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
  env^.DeleteLocalRef(env, jCls);
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
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothServerSocket_Listen(env: PJNIEnv; _jbluetoothserversocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Listen', '()V');
  env^.CallVoidMethod(env, _jbluetoothserversocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothServerSocket_CancelListening(env: PJNIEnv; _jbluetoothserversocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'CancelListening', '()V');
  env^.CallVoidMethod(env, _jbluetoothserversocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothServerSocket_Disconnect(env: PJNIEnv; _jbluetoothserversocket: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'DisconnectClient', '()V');
  env^.CallVoidMethod(env, _jbluetoothserversocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetoothServerSocket_IsConnected(env: PJNIEnv; _jbluetoothserversocket: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'IsClientConnected', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetoothserversocket, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothServerSocket_SetTimeout(env: PJNIEnv; _jbluetoothserversocket: JObject; _milliseconds: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _milliseconds;
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTimeout', '(I)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jBluetoothServerSocket_ByteArrayToString(env: PJNIEnv; _jbluetoothserversocket: JObject; var _byteArray: TDynArrayOfJByte): string;
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
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'ByteArrayToString', '([B)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
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


function jBluetoothServerSocket_ByteArrayToBitmap(env: PJNIEnv; _jbluetoothserversocket: JObject; var _byteArray: TDynArrayOfJByte): jObject;
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
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'ByteArrayToBitmap', '([B)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
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
  env^.DeleteLocalRef(env, jCls);
end;



procedure jBluetoothServerSocket_Write(env: PJNIEnv; _jbluetoothserversocket: JObject; var _dataContent: TDynArrayOfJByte);
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
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Write', '([B)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothServerSocket_SetReceiverBufferLength(env: PJNIEnv; _jbluetoothserversocket: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetReceiverBufferLength', '(I)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jBluetoothServerSocket_GetReceiverBufferLength(env: PJNIEnv; _jbluetoothserversocket: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'GetReceiverBufferLength', '()I');
  Result:= env^.CallIntMethod(env, _jbluetoothserversocket, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetoothServerSocket_GetDataHeaderReceiveEnabled(env: PJNIEnv; _jbluetoothserversocket: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDataHeaderReceiveEnabled', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetoothserversocket, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothServerSocket_SetDataHeaderReceiveEnabled(env: PJNIEnv; _jbluetoothserversocket: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDataHeaderReceiveEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothServerSocket_SaveByteArrayToFile(env: PJNIEnv; _jbluetoothserversocket: JObject; var _byteArray: TDynArrayOfJByte; _filePath: string; _fileName: string);
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
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveByteArrayToFile', '([BLjava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothServerSocket_WriteMessage(env: PJNIEnv; _jbluetoothserversocket: JObject; _message: string; var _dataHeader: TDynArrayOfJByte);
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
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'WriteMessage', '(Ljava/lang/String;[B)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothServerSocket_Write(env: PJNIEnv; _jbluetoothserversocket: JObject; var _dataContent: TDynArrayOfJByte; var _dataHeader: TDynArrayOfJByte);
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
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Write', '([B[B)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothServerSocket_SendFile(env: PJNIEnv; _jbluetoothserversocket: JObject; _filePath: string; _fileName: string; var _dataHeader: TDynArrayOfJByte);
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
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SendFile', '(Ljava/lang/String;Ljava/lang/String;[B)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothServerSocket_SendFile(env: PJNIEnv; _jbluetoothserversocket: JObject; _filePath: string; _fileName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filePath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SendFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothServerSocket_WriteMessage(env: PJNIEnv; _jbluetoothserversocket: JObject; _message: string; _dataHeader: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_message));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_dataHeader));
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'WriteMessage', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothServerSocket_Write(env: PJNIEnv; _jbluetoothserversocket: JObject; var _dataContent: TDynArrayOfJByte; _dataHeader: string);
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
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'Write', '([BLjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothServerSocket_SendFile(env: PJNIEnv; _jbluetoothserversocket: JObject; _filePath: string; _fileName: string; _dataHeader: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filePath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_dataHeader));
  jCls:= env^.GetObjectClass(env, _jbluetoothserversocket);
  jMethod:= env^.GetMethodID(env, jCls, 'SendFile', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothserversocket, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;



end.
