unit cbluetoothspp;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

const

    // Intent request codes
    REQUEST_CONNECT_DEVICE = 384;
    REQUEST_ENABLE_BT = 385;

      // Key names received from the BluetoothChatService Handler
    DEVICE_NAME = 'device_name';
    DEVICE_ADDRESS = 'device_address';
    TOAST = 'toast';

    // Return Intent extra from ListDevice
    EXTRA_DEVICE_ADDRESS = 'device_address';

    //
    DEVICE_ANDROID = True;
    DEVICE_OTHER = False; //any microcontroller which communication with bluetooth serial port profile module

type

//  current connection state
TBluetoothSPPConnectionState = (csNoService=-1,csNone=0, csListening=1, csConnecting=2, csConnected=3, csFailed=4,
                                dsDataReceiving=5, csListeningAutoConnection=6, csAutoConnectionStarted=7);

// Message types sent from the BluetoothChatService Handler
TBluetoothSPPMessageType = (mtStateChange=1, mtRead=2, mtWrite=3, mtDeviceName=4, mtToast=5);

//TBluetoothSPPTargetDevice = (tdAndroid, tdOther);

TOnBluetoothSPPDataReceived=procedure(Sender:TObject;jbyteArrayData:array of shortint;messageData:string) of object;
TOnBluetoothSPPDeviceConnected=procedure(Sender:TObject;deviceName:string;deviceAddress:string) of object;
TOnBluetoothSPPDeviceDisconnected=procedure(Sender:TObject) of object;
TOnBluetoothSPPDeviceConnectionFailed=procedure(Sender:TObject) of object;
TOnBluetoothSPPServiceStateChanged=procedure(Sender:TObject; state: TBluetoothSPPConnectionState) of object;
TOnBluetoothSPPListeningNewAutoConnection=procedure(Sender:TObject;deviceName:string;deviceAddress:string) of object;
TOnBluetoothSPPAutoConnectionStarted=procedure(Sender:TObject) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [11/22/2019 1:15:45]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

{ jcBluetoothSPP }

jcBluetoothSPP = class(jControl)
 private
    FOnDataReceived: TOnBluetoothSPPDataReceived;
    FOnDeviceConnected: TOnBluetoothSPPDeviceConnected;
    FOnDeviceDisconnected: TOnBluetoothSPPDeviceDisconnected;
    FOnDeviceConnectionFailed: TOnBluetoothSPPDeviceConnectionFailed;
    FOnConnectionStateChanged: TOnBluetoothSPPServiceStateChanged;
    FOnListeningNewAutoConnection: TOnBluetoothSPPListeningNewAutoConnection;
    FOnAutoConnectionStarted: TOnBluetoothSPPAutoConnectionStarted;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();

    function IsBluetoothEnabled(): boolean;
    procedure Enable();
    function IsBluetoothAvailable(): boolean;
    function IsServiceAvailable(): boolean;
    procedure SetupAndStartService(_isAndroid: boolean);
    procedure StopService();

    //Auto add LF (0x0A) and CR (0x0D) when send data to connection device
    procedure Send(_messageData: string; _CrLf: boolean); overload;
    procedure Send(var _jbyteArrayData: TDynArrayOfJByte; _CrLf: boolean);overload;
    { We are using pascal "shortint" to simulate the [Signed] java byte ....
      however "shortint" works in the range "-127 to 128" equal to the byte in java ....
      So every time we assign a value outside this range, for example 192 or $C0, we get
      the "range check" message...

      How to Fix:

      var
        bufferToSend: array of jbyte; //jbyte = shortint
      begin
        ...........
        bufferToSend[0] := ToSignedByte($C0);    //<-- fixed!
        ........
      end;}
    function ToSignedByte(b: byte): shortint;

    procedure AutoConnect(_keywordForFilterPairedDevice: string);

    procedure Connect(_intentData: jObject); overload;
    procedure Connect(_address: string); overload;
    function GetConnectedDeviceAddress(): string;
    function GetConnectedDeviceName(): string;
    function GetPairedDeviceAddress(): TDynArrayOfString;
    function GetPairedDeviceName(): TDynArrayOfString;
    procedure Disconnect();
    function IsAutoConnecting(): boolean;
    procedure CancelDiscovery();
    function IsDiscovering(): boolean;

    function GetActivityDeviceListClass(): string;
    procedure StartActivityDeviceListForResult();

    function GetIntentActionEnableBluetooth(): string;
    procedure StartActivityEnableBluetoothForResult();

    function GetConnectionState(): TBluetoothSPPConnectionState;
    function GetConnectionStateAutoExtra(): TBluetoothSPPConnectionState;
    procedure SetDeviceTarget(_deviceTargetIsAndroid: boolean);

    procedure GenEvent_OnBluetoothSPPDataReceived(Sender:TObject;jbyteArrayData:array of shortint;messageData:string);
    procedure GenEvent_OnBluetoothSPPDeviceConnected(Sender:TObject;deviceName:string;deviceAddress:string);
    procedure GenEvent_OnBluetoothSPPDeviceDisconnected(Sender:TObject);
    procedure GenEvent_OnBluetoothSPPDeviceConnectionFailed(Sender:TObject);
    procedure GenEvent_OnBluetoothSPPServiceStateChanged(Sender:TObject;serviceState:integer);
    procedure GenEvent_OnBluetoothSPPListeningNewAutoConnection(Sender:TObject;deviceName:string;deviceAddress:string);
    procedure GenEvent_OnBluetoothSPPAutoConnectionStarted(Sender:TObject);
 published
    property OnDataReceived: TOnBluetoothSPPDataReceived read FOnDataReceived write FOnDataReceived;
    property OnConnected: TOnBluetoothSPPDeviceConnected read FOnDeviceConnected write FOnDeviceConnected;
    property OnDisconnected: TOnBluetoothSPPDeviceDisconnected read FOnDeviceDisconnected write FOnDeviceDisconnected;
    property OnConnectionFailed: TOnBluetoothSPPDeviceConnectionFailed read FOnDeviceConnectionFailed write FOnDeviceConnectionFailed;
    property OnConnectionStateChanged: TOnBluetoothSPPServiceStateChanged read FOnConnectionStateChanged write FOnConnectionStateChanged;
    property OnAutoConnection: TOnBluetoothSPPListeningNewAutoConnection read FOnListeningNewAutoConnection write FOnListeningNewAutoConnection;
    property OnAutoConnectionStarted: TOnBluetoothSPPAutoConnectionStarted read FOnAutoConnectionStarted write FOnAutoConnectionStarted;

end;

function jcBluetoothSPP_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jcBluetoothSPP_jFree(env: PJNIEnv; _jcbluetoothspp: JObject);

function jcBluetoothSPP_IsBluetoothEnabled(env: PJNIEnv; _jcbluetoothspp: JObject): boolean;
procedure jcBluetoothSPP_Enable(env: PJNIEnv; _jcbluetoothspp: JObject);
function jcBluetoothSPP_IsBluetoothAvailable(env: PJNIEnv; _jcbluetoothspp: JObject): boolean;
function jcBluetoothSPP_IsServiceAvailable(env: PJNIEnv; _jcbluetoothspp: JObject): boolean;
procedure jcBluetoothSPP_StartService(env: PJNIEnv; _jcbluetoothspp: JObject; _isAndroidDevice: boolean);
procedure jcBluetoothSPP_StopService(env: PJNIEnv; _jcbluetoothspp: JObject);
procedure jcBluetoothSPP_Send(env: PJNIEnv; _jcbluetoothspp: JObject; _messageData: string; _CrLf: boolean);overload;
procedure jcBluetoothSPP_Send(env: PJNIEnv; _jcbluetoothspp: JObject; var _jbyteArrayData: TDynArrayOfJByte; _CrLf: boolean);overload;
procedure jcBluetoothSPP_AutoConnect(env: PJNIEnv; _jcbluetoothspp: JObject; _keywordForFilterPairedDevice: string);

procedure jcBluetoothSPP_Connect(env: PJNIEnv; _jcbluetoothspp: JObject; _intentData: jObject); overload;
procedure jcBluetoothSPP_Connect(env: PJNIEnv; _jcbluetoothspp: JObject; _address: string); overload;
function jcBluetoothSPP_GetConnectedDeviceAddress(env: PJNIEnv; _jcbluetoothspp: JObject): string;
function jcBluetoothSPP_GetConnectedDeviceName(env: PJNIEnv; _jcbluetoothspp: JObject): string;
function jcBluetoothSPP_GetPairedDeviceAddress(env: PJNIEnv; _jcbluetoothspp: JObject): TDynArrayOfString;
function jcBluetoothSPP_GetPairedDeviceName(env: PJNIEnv; _jcbluetoothspp: JObject): TDynArrayOfString;
procedure jcBluetoothSPP_Disconnect(env: PJNIEnv; _jcbluetoothspp: JObject);
function jcBluetoothSPP_IsAutoConnecting(env: PJNIEnv; _jcbluetoothspp: JObject): boolean;
procedure jcBluetoothSPP_CancelDiscovery(env: PJNIEnv; _jcbluetoothspp: JObject);
function jcBluetoothSPP_IsDiscovery(env: PJNIEnv; _jcbluetoothspp: JObject): boolean;

function jcBluetoothSPP_GetActivityDeviceListClass(env: PJNIEnv; _jcbluetoothspp: JObject): string;
procedure jcBluetoothSPP_StartActivityDeviceListForResult(env: PJNIEnv; _jcbluetoothspp: JObject);
function jcBluetoothSPP_GetIntentActionEnableBluetooth(env: PJNIEnv; _jcbluetoothspp: JObject): string;
procedure jcBluetoothSPP_StartActivityEnableBluetoothForResult(env: PJNIEnv; _jcbluetoothspp: JObject);

function jcBluetoothSPP_GetConnectionState(env: PJNIEnv; _jcbluetoothspp: JObject): integer;
function jcBluetoothSPP_GetConnectionStateAutoExtra(env: PJNIEnv; _jcbluetoothspp: JObject): integer;
procedure jcBluetoothSPP_SetDeviceTarget(env: PJNIEnv; _jcbluetoothspp: JObject; _deviceTargetIsAndroid: boolean);

implementation

{---------  jcBluetoothSPP  --------------}

constructor jcBluetoothSPP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jcBluetoothSPP.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jFree();
       FjObject:= nil;
     end;
  end;
  //you others free code here...
  inherited Destroy;
end;

procedure jcBluetoothSPP.Init;
begin

  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jcBluetoothSPP.jCreate(): jObject;
begin
   Result:= jcBluetoothSPP_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jcBluetoothSPP.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_jFree(gApp.jni.jEnv, FjObject);
end;

function jcBluetoothSPP.IsBluetoothEnabled(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_IsBluetoothEnabled(gApp.jni.jEnv, FjObject);
end;

procedure jcBluetoothSPP.Enable();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_Enable(gApp.jni.jEnv, FjObject);
end;

function jcBluetoothSPP.IsBluetoothAvailable(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_IsBluetoothAvailable(gApp.jni.jEnv, FjObject);
end;

function jcBluetoothSPP.IsServiceAvailable(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_IsServiceAvailable(gApp.jni.jEnv, FjObject);
end;

procedure jcBluetoothSPP.SetupAndStartService(_isAndroid: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_StartService(gApp.jni.jEnv, FjObject, _isAndroid);
end;

procedure jcBluetoothSPP.StopService();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_StopService(gApp.jni.jEnv, FjObject);
end;

procedure jcBluetoothSPP.Send(_messageData: string; _CrLf: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_Send(gApp.jni.jEnv, FjObject, _messageData ,_CrLf);
end;

procedure jcBluetoothSPP.Send(var _jbyteArrayData: TDynArrayOfJByte; _CrLf: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_Send(gApp.jni.jEnv, FjObject, _jbyteArrayData ,_CrLf);
end;

procedure jcBluetoothSPP.AutoConnect(_keywordForFilterPairedDevice: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_AutoConnect(gApp.jni.jEnv, FjObject, _keywordForFilterPairedDevice);
end;

function jcBluetoothSPP.GetActivityDeviceListClass(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_GetActivityDeviceListClass(gApp.jni.jEnv, FjObject);
end;

procedure jcBluetoothSPP.StartActivityDeviceListForResult();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_StartActivityDeviceListForResult(gApp.jni.jEnv, FjObject);
end;

procedure jcBluetoothSPP.Connect(_intentData: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_Connect(gApp.jni.jEnv, FjObject, _intentData);
end;

procedure jcBluetoothSPP.Connect(_address: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_Connect(gApp.jni.jEnv, FjObject, _address);
end;

function jcBluetoothSPP.GetConnectedDeviceAddress(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_GetConnectedDeviceAddress(gApp.jni.jEnv, FjObject);
end;

function jcBluetoothSPP.GetConnectedDeviceName(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_GetConnectedDeviceName(gApp.jni.jEnv, FjObject);
end;


function jcBluetoothSPP.GetPairedDeviceAddress(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_GetPairedDeviceAddress(gApp.jni.jEnv, FjObject);
end;

function jcBluetoothSPP.GetPairedDeviceName(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_GetPairedDeviceName(gApp.jni.jEnv, FjObject);
end;

procedure jcBluetoothSPP.Disconnect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_Disconnect(gApp.jni.jEnv, FjObject);
end;

function jcBluetoothSPP.IsAutoConnecting(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_IsAutoConnecting(gApp.jni.jEnv, FjObject);
end;

procedure jcBluetoothSPP.CancelDiscovery();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_CancelDiscovery(gApp.jni.jEnv, FjObject);
end;

function jcBluetoothSPP.IsDiscovering(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_IsDiscovery(gApp.jni.jEnv, FjObject);
end;

function jcBluetoothSPP.GetIntentActionEnableBluetooth(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcBluetoothSPP_GetIntentActionEnableBluetooth(gApp.jni.jEnv, FjObject);
end;

procedure jcBluetoothSPP.StartActivityEnableBluetoothForResult();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_StartActivityEnableBluetoothForResult(gApp.jni.jEnv, FjObject);
end;

function jcBluetoothSPP.GetConnectionState(): TBluetoothSPPConnectionState;
begin
  //in designing component state: result value here...
  if FInitialized then
     Result:= TBluetoothSPPConnectionState( jcBluetoothSPP_GetConnectionState(gApp.jni.jEnv, FjObject) );
end;

function jcBluetoothSPP.GetConnectionStateAutoExtra(): TBluetoothSPPConnectionState;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= TBluetoothSPPConnectionState(jcBluetoothSPP_GetConnectionStateAutoExtra(gApp.jni.jEnv, FjObject));
end;

procedure jcBluetoothSPP.SetDeviceTarget(_deviceTargetIsAndroid: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcBluetoothSPP_SetDeviceTarget(gApp.jni.jEnv, FjObject, _deviceTargetIsAndroid);
end;

function jcBluetoothSPP.ToSignedByte(b: byte): shortint;
begin
   Result:= shortint(b);
end;

procedure jcBluetoothSPP.GenEvent_OnBluetoothSPPDataReceived(Sender:TObject;jbyteArrayData:array of shortint;messageData:string);
begin
  if Assigned(FOnDataReceived) then FOnDataReceived(Sender,jbyteArrayData,messageData);
end;

procedure jcBluetoothSPP.GenEvent_OnBluetoothSPPDeviceConnected(Sender:TObject;deviceName:string;deviceAddress:string);
begin
  if Assigned(FOnDeviceConnected) then FOnDeviceConnected(Sender,deviceName,deviceAddress);
end;

procedure jcBluetoothSPP.GenEvent_OnBluetoothSPPDeviceDisconnected(Sender:TObject);
begin
  if Assigned(FOnDeviceDisconnected) then FOnDeviceDisconnected(Sender);
end;

procedure jcBluetoothSPP.GenEvent_OnBluetoothSPPDeviceConnectionFailed(Sender:TObject);
begin
  if Assigned(FOnDeviceConnectionFailed) then FOnDeviceConnectionFailed(Sender);
end;

procedure jcBluetoothSPP.GenEvent_OnBluetoothSPPServiceStateChanged(Sender:TObject; serviceState: integer);
begin
  if Assigned(FOnConnectionStateChanged) then FOnConnectionStateChanged(Sender,TBluetoothSPPConnectionState(serviceState));
end;

procedure jcBluetoothSPP.GenEvent_OnBluetoothSPPListeningNewAutoConnection(Sender:TObject;deviceName:string;deviceAddress:string);
begin
  if Assigned(FOnListeningNewAutoConnection) then FOnListeningNewAutoConnection(Sender,deviceName,deviceAddress);
end;

procedure jcBluetoothSPP.GenEvent_OnBluetoothSPPAutoConnectionStarted(Sender:TObject);
begin
  if Assigned(FOnAutoConnectionStarted) then FOnAutoConnectionStarted(Sender);
end;

{-------- jcBluetoothSPP_JNI_Bridge ----------}

function jcBluetoothSPP_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jcBluetoothSPP_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jcBluetoothSPP_jFree(env: PJNIEnv; _jcbluetoothspp: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcbluetoothspp, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcBluetoothSPP_IsBluetoothEnabled(env: PJNIEnv; _jcbluetoothspp: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'IsBluetoothEnabled', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jcbluetoothspp, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcBluetoothSPP_Enable(env: PJNIEnv; _jcbluetoothspp: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'Enable', '()V');
  env^.CallVoidMethod(env, _jcbluetoothspp, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcBluetoothSPP_IsBluetoothAvailable(env: PJNIEnv; _jcbluetoothspp: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'IsBluetoothAvailable', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jcbluetoothspp, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jcBluetoothSPP_IsServiceAvailable(env: PJNIEnv; _jcbluetoothspp: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'IsServiceAvailable', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jcbluetoothspp, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcBluetoothSPP_StartService(env: PJNIEnv; _jcbluetoothspp: JObject; _isAndroidDevice: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_isAndroidDevice);
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'StartService', '(Z)V');
  env^.CallVoidMethodA(env, _jcbluetoothspp, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcBluetoothSPP_StopService(env: PJNIEnv; _jcbluetoothspp: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'StopService', '()V');
  env^.CallVoidMethod(env, _jcbluetoothspp, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcBluetoothSPP_Send(env: PJNIEnv; _jcbluetoothspp: JObject; _messageData: string; _CrLf: boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_messageData));
  jParams[1].z:= JBool(_CrLf);
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'Send', '(Ljava/lang/String;Z)V');
  env^.CallVoidMethodA(env, _jcbluetoothspp, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcBluetoothSPP_Send(env: PJNIEnv; _jcbluetoothspp: JObject; var _jbyteArrayData: TDynArrayOfJByte; _CrLf: boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_jbyteArrayData);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_jbyteArrayData[0] {source});
  jParams[0].l:= jNewArray0;
  jParams[1].z:= JBool(_CrLf);
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'Send', '([BZ)V');
  env^.CallVoidMethodA(env, _jcbluetoothspp, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcBluetoothSPP_AutoConnect(env: PJNIEnv; _jcbluetoothspp: JObject; _keywordForFilterPairedDevice: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_keywordForFilterPairedDevice));
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'AutoConnect', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcbluetoothspp, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcBluetoothSPP_GetActivityDeviceListClass(env: PJNIEnv; _jcbluetoothspp: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'GetActivityDeviceListClass', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jcbluetoothspp, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcBluetoothSPP_StartActivityDeviceListForResult(env: PJNIEnv; _jcbluetoothspp: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'StartActivityDeviceListForResult', '()V');
  env^.CallVoidMethod(env, _jcbluetoothspp, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcBluetoothSPP_Connect(env: PJNIEnv; _jcbluetoothspp: JObject; _intentData: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _intentData;
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Landroid/content/Intent;)V');
  env^.CallVoidMethodA(env, _jcbluetoothspp, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcBluetoothSPP_Connect(env: PJNIEnv; _jcbluetoothspp: JObject; _address: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_address));
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcbluetoothspp, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcBluetoothSPP_GetConnectedDeviceAddress(env: PJNIEnv; _jcbluetoothspp: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'GetConnectedDeviceAddress', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jcbluetoothspp, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jcBluetoothSPP_GetPairedDeviceAddress(env: PJNIEnv; _jcbluetoothspp: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  Result := nil;
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPairedDeviceAddress', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jcbluetoothspp, jMethod);
  if jResultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      case jStr = nil of
         True : Result[i]:= '';
         False: begin
                  jBoo:= JNI_False;
                  Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
                 end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jcBluetoothSPP_GetPairedDeviceName(env: PJNIEnv; _jcbluetoothspp: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  Result := nil;
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPairedDeviceName', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jcbluetoothspp, jMethod);
  if jResultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      case jStr = nil of
         True : Result[i]:= '';
         False: begin
                  jBoo:= JNI_False;
                  Result[i]:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
                 end;
      end;
    end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcBluetoothSPP_Disconnect(env: PJNIEnv; _jcbluetoothspp: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'Disconnect', '()V');
  env^.CallVoidMethod(env, _jcbluetoothspp, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcBluetoothSPP_IsAutoConnecting(env: PJNIEnv; _jcbluetoothspp: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'IsAutoConnecting', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jcbluetoothspp, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcBluetoothSPP_CancelDiscovery(env: PJNIEnv; _jcbluetoothspp: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'CancelDiscovery', '()V');
  env^.CallVoidMethod(env, _jcbluetoothspp, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcBluetoothSPP_IsDiscovery(env: PJNIEnv; _jcbluetoothspp: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'IsDiscovery', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jcbluetoothspp, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jcBluetoothSPP_GetIntentActionEnableBluetooth(env: PJNIEnv; _jcbluetoothspp: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'GetIntentActionEnableBluetooth', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jcbluetoothspp, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcBluetoothSPP_StartActivityEnableBluetoothForResult(env: PJNIEnv; _jcbluetoothspp: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'StartActivityEnableBluetoothForResult', '()V');
  env^.CallVoidMethod(env, _jcbluetoothspp, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcBluetoothSPP_GetConnectionState(env: PJNIEnv; _jcbluetoothspp: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'GetConnectionState', '()I');
  Result:= env^.CallIntMethod(env, _jcbluetoothspp, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcBluetoothSPP_GetConnectedDeviceName(env: PJNIEnv; _jcbluetoothspp: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'GetConnectedDeviceName', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jcbluetoothspp, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcBluetoothSPP_SetDeviceTarget(env: PJNIEnv; _jcbluetoothspp: JObject; _deviceTargetIsAndroid: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_deviceTargetIsAndroid);
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDeviceTarget', '(Z)V');
  env^.CallVoidMethodA(env, _jcbluetoothspp, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcBluetoothSPP_GetConnectionStateAutoExtra(env: PJNIEnv; _jcbluetoothspp: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcbluetoothspp);
  jMethod:= env^.GetMethodID(env, jCls, 'GetConnectionStateAutoExtra', '()I');
  Result:= env^.CallIntMethod(env, _jcbluetoothspp, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
