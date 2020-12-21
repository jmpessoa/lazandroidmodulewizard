unit bluetoothlowenergy;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TBLEScanMode = (smLowPower, smLowLantency);
TBLEBondState = (bsNone=10, bsBonding=11, bsBonded=12);

TBLECharacteristicProperty = (cpUnknown=0, cpRead=2, cpNotify=16, cpIndicate=32);

TOnBluetoothLEScanCompleted=procedure(Sender:TObject;deviceNameArray:array of string;deviceAddressArray:array of string) of object;
TOnBluetoothLEConnected=procedure(Sender:TObject;deviceName:string;deviceAddress:string;bondState:TBLEBondState) of object;
TOnBluetoothLEServiceDiscovered=procedure(Sender:TObject;serviceIndex:integer;serviceUUID:string;characteristicUUIDArray:array of string) of object;
TOnBluetoothLECharacteristicChanged=procedure(Sender:TObject;strValue:string;strCharacteristic:string) of object;
TOnBluetoothLECharacteristicRead=procedure(Sender:TObject;strValue:string;strCharacteristic:string) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [11/22/2020 14:46:01]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jBluetoothLowEnergy = class(jControl)
 private
    FScanMode: TBLEScanMode;
    FScanPeriod: int64;
    FOnScanCompleted: TOnBluetoothLEScanCompleted;
    FOnConnected: TOnBluetoothLEConnected;
    FOnServiceDiscovered: TOnBluetoothLEServiceDiscovered;
    FOnCharacteristicChanged: TOnBluetoothLECharacteristicChanged;
    FOnCharacteristicRead: TOnBluetoothLECharacteristicRead;
 public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    function HasSystemFeature(): boolean;
    procedure DisconnectGattServer();

    procedure SetScanPeriod(_milliSeconds: int64);
    procedure SetScanMode(_mode: TBLEScanMode);

    procedure StartScan(); overload;
    procedure StartScan(_filterServiceUUID: string);  overload;

    procedure StopScan();

    procedure ConnectDevice(_deviceAddress: string);
    procedure DiscoverServices();

    function GetCharacteristics(_serviceIndex: integer): TDynArrayOfString;
    function GetCharacteristicProperties(_serviceIndex: integer; _characteristicIndex: integer): TBLECharacteristicProperty;
    function GetDescriptors(_serviceIndex: integer; _characteristicIndex: integer): TDynArrayOfString;

    procedure ReadCharacteristic(_serviceIndex: integer; _characteristicIndex: integer);

    procedure GenEvent_OnBluetoothLEScanCompleted(Sender:TObject;deviceName:array of string;deviceAddress:array of string);
    procedure GenEvent_OnBluetoothLEConnected(Sender:TObject;deviceName:string;deviceAddress:string;bondState:integer);
    procedure GenEvent_OnBluetoothLEServiceDiscovered(Sender:TObject;serviceIndex:integer;serviceUUID:string;characteristicUUIDArray:array of string);
    procedure GenEvent_OnBluetoothLECharacteristicChanged(Sender:TObject;strValue:string;strCharacteristic:string);
    procedure GenEvent_OnBluetoothLECharacteristicRead(Sender:TObject;strValue:string;strCharacteristic:string);

 published
    property ScanMode: TBLEScanMode read FScanMode write SetScanMode;
    property ScanPeriod: int64 read FScanPeriod write SetScanPeriod;

    property OnScanCompleted: TOnBluetoothLEScanCompleted read FOnScanCompleted write FOnScanCompleted;
    property OnConnected: TOnBluetoothLEConnected read FOnConnected write FOnConnected;
    property OnServiceDiscovered: TOnBluetoothLEServiceDiscovered read FOnServiceDiscovered write FOnServiceDiscovered;
    property OnCharacteristicChanged: TOnBluetoothLECharacteristicChanged read FOnCharacteristicChanged write FOnCharacteristicChanged;
    property OnCharacteristicRead: TOnBluetoothLECharacteristicRead read FOnCharacteristicRead write FOnCharacteristicRead;
end;

function jBluetoothLowEnergy_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jBluetoothLowEnergy_jFree(env: PJNIEnv; _jbluetoothlowenergy: JObject);

function jBluetoothLowEnergy_HasSystemFeature(env: PJNIEnv; _jbluetoothlowenergy: JObject): boolean;
procedure jBluetoothLowEnergy_disconnectGattServer(env: PJNIEnv; _jbluetoothlowenergy: JObject);
procedure jBluetoothLowEnergy_StartScan(env: PJNIEnv; _jbluetoothlowenergy: JObject);  overload;
procedure jBluetoothLowEnergy_StartScan(env: PJNIEnv; _jbluetoothlowenergy: JObject; _filterServiceUUID: string); overload;
procedure jBluetoothLowEnergy_SetScanPeriod(env: PJNIEnv; _jbluetoothlowenergy: JObject; _milliSeconds: int64);
procedure jBluetoothLowEnergy_SetScanMode(env: PJNIEnv; _jbluetoothlowenergy: JObject; _mode: integer);
procedure jBluetoothLowEnergy_StopScan(env: PJNIEnv; _jbluetoothlowenergy: JObject);
procedure jBluetoothLowEnergy_ConnectDevice(env: PJNIEnv; _jbluetoothlowenergy: JObject; _deviceAddress: string);
procedure jBluetoothLowEnergy_DiscoverServices(env: PJNIEnv; _jbluetoothlowenergy: JObject);

function jBluetoothLowEnergy_GetCharacteristics(env: PJNIEnv; _jbluetoothlowenergy: JObject; _serviceIndex: integer): TDynArrayOfString;
function jBluetoothLowEnergy_GetCharacteristicProperties(env: PJNIEnv; _jbluetoothlowenergy: JObject; _serviceIndex: integer; _characteristicIndex: integer): integer;
function jBluetoothLowEnergy_GetDescriptors(env: PJNIEnv; _jbluetoothlowenergy: JObject; _serviceIndex: integer; _characteristicIndex: integer): TDynArrayOfString;

procedure jBluetoothLowEnergy_ReadCharacteristic(env: PJNIEnv; _jbluetoothlowenergy: JObject; _serviceIndex: integer; _characteristicIndex: integer);

implementation

{---------  jBluetoothLowEnergy  --------------}

constructor jBluetoothLowEnergy.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
  FScanPeriod:= 5000;
  FScanMode:= smLowPower;
end;

destructor jBluetoothLowEnergy.Destroy;
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

procedure jBluetoothLowEnergy.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  if FScanMode <> smLowPower then
    jBluetoothLowEnergy_SetScanMode(FjEnv, FjObject, ord(FScanMode));

  if FScanPeriod <> 5000 then
     jBluetoothLowEnergy_SetScanPeriod(FjEnv, FjObject, FScanPeriod);

  FInitialized:= True;
end;


function jBluetoothLowEnergy.jCreate(): jObject;
begin
   Result:= jBluetoothLowEnergy_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jBluetoothLowEnergy.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothLowEnergy_jFree(FjEnv, FjObject);
end;

function jBluetoothLowEnergy.HasSystemFeature(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothLowEnergy_HasSystemFeature(FjEnv, FjObject);
end;

procedure jBluetoothLowEnergy.DisconnectGattServer();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothLowEnergy_disconnectGattServer(FjEnv, FjObject);
end;

procedure jBluetoothLowEnergy.StartScan();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothLowEnergy_StartScan(FjEnv, FjObject);
end;

procedure jBluetoothLowEnergy.StopScan();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothLowEnergy_StopScan(FjEnv, FjObject);
end;

procedure jBluetoothLowEnergy.ConnectDevice(_deviceAddress: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothLowEnergy_ConnectDevice(FjEnv, FjObject, _deviceAddress);
end;

procedure jBluetoothLowEnergy.StartScan(_filterServiceUUID: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothLowEnergy_StartScan(FjEnv, FjObject, _filterServiceUUID);
end;

procedure jBluetoothLowEnergy.SetScanPeriod(_milliSeconds: int64);
begin
  //in designing component state: set value here...
  FScanPeriod:= _milliSeconds;
  if FInitialized then
     jBluetoothLowEnergy_SetScanPeriod(FjEnv, FjObject, _milliSeconds);
end;

procedure jBluetoothLowEnergy.SetScanMode(_mode: TBLEScanMode);
begin
  //in designing component state: set value here...
  FScanMode:= _mode;
  if FInitialized then
     jBluetoothLowEnergy_SetScanMode(FjEnv, FjObject, ord(_mode));
end;

procedure jBluetoothLowEnergy.DiscoverServices();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothLowEnergy_DiscoverServices(FjEnv, FjObject);
end;

function jBluetoothLowEnergy.GetCharacteristics(_serviceIndex: integer): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothLowEnergy_GetCharacteristics(FjEnv, FjObject, _serviceIndex);
end;

function jBluetoothLowEnergy.GetCharacteristicProperties(_serviceIndex: integer; _characteristicIndex: integer): TBLECharacteristicProperty;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= TBLECharacteristicProperty(jBluetoothLowEnergy_GetCharacteristicProperties(FjEnv, FjObject, _serviceIndex ,_characteristicIndex));
end;

function jBluetoothLowEnergy.GetDescriptors(_serviceIndex: integer; _characteristicIndex: integer): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetoothLowEnergy_GetDescriptors(FjEnv, FjObject, _serviceIndex ,_characteristicIndex);
end;

procedure jBluetoothLowEnergy.ReadCharacteristic(_serviceIndex: integer; _characteristicIndex: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetoothLowEnergy_ReadCharacteristic(FjEnv, FjObject, _serviceIndex ,_characteristicIndex);
end;

procedure jBluetoothLowEnergy.GenEvent_OnBluetoothLEConnected(Sender:TObject;deviceName:string;deviceAddress:string;bondState: integer);
begin
  if Assigned(FOnConnected) then FOnConnected(Sender,deviceName,deviceAddress,TBLEBondState(bondState));
end;

procedure jBluetoothLowEnergy.GenEvent_OnBluetoothLEScanCompleted(Sender:TObject;deviceName:array of string;deviceAddress:array of string);
begin
  if Assigned(FOnScanCompleted) then FOnScanCompleted(Sender,deviceName,deviceAddress);
end;

procedure jBluetoothLowEnergy.GenEvent_OnBluetoothLEServiceDiscovered(Sender:TObject;serviceIndex:integer;serviceUUID:string;characteristicUUIDArray:array of string);
begin
  if Assigned(FOnServiceDiscovered) then FOnServiceDiscovered(Sender,serviceIndex,serviceUUID,characteristicUUIDArray);
end;

procedure jBluetoothLowEnergy.GenEvent_OnBluetoothLECharacteristicChanged(Sender:TObject;strValue:string;strCharacteristic:string);
begin
  if Assigned(FOnCharacteristicChanged) then FOnCharacteristicChanged(Sender,strValue,strCharacteristic);
end;
procedure jBluetoothLowEnergy.GenEvent_OnBluetoothLECharacteristicRead(Sender:TObject;strValue:string;strCharacteristic:string);
begin
  if Assigned(FOnCharacteristicRead) then FOnCharacteristicRead(Sender,strValue,strCharacteristic);
end;

{-------- jBluetoothLowEnergy_JNI_Bridge ----------}

function jBluetoothLowEnergy_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jBluetoothLowEnergy_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jBluetoothLowEnergy_jFree(env: PJNIEnv; _jbluetoothlowenergy: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jbluetoothlowenergy, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetoothLowEnergy_HasSystemFeature(env: PJNIEnv; _jbluetoothlowenergy: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'HasSystemFeature', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetoothlowenergy, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothLowEnergy_disconnectGattServer(env: PJNIEnv; _jbluetoothlowenergy: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'disconnectGattServer', '()V');
  env^.CallVoidMethod(env, _jbluetoothlowenergy, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothLowEnergy_StartScan(env: PJNIEnv; _jbluetoothlowenergy: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'StartScan', '()V');
  env^.CallVoidMethod(env, _jbluetoothlowenergy, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothLowEnergy_StopScan(env: PJNIEnv; _jbluetoothlowenergy: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'StopScan', '()V');
  env^.CallVoidMethod(env, _jbluetoothlowenergy, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothLowEnergy_ConnectDevice(env: PJNIEnv; _jbluetoothlowenergy: JObject; _deviceAddress: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_deviceAddress));
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'ConnectDevice', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothlowenergy, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothLowEnergy_StartScan(env: PJNIEnv; _jbluetoothlowenergy: JObject; _filterServiceUUID: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filterServiceUUID));
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'StartScan', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetoothlowenergy, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothLowEnergy_SetScanPeriod(env: PJNIEnv; _jbluetoothlowenergy: JObject; _milliSeconds: int64);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _milliSeconds;
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScanPeriod', '(J)V');
  env^.CallVoidMethodA(env, _jbluetoothlowenergy, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetoothLowEnergy_SetScanMode(env: PJNIEnv; _jbluetoothlowenergy: JObject; _mode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _mode;
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScanMode', '(I)V');
  env^.CallVoidMethodA(env, _jbluetoothlowenergy, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetoothLowEnergy_DiscoverServices(env: PJNIEnv; _jbluetoothlowenergy: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'DiscoverServices', '()V');
  env^.CallVoidMethod(env, _jbluetoothlowenergy, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetoothLowEnergy_GetCharacteristics(env: PJNIEnv; _jbluetoothlowenergy: JObject; _serviceIndex: integer): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jParams[0].i:= _serviceIndex;
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'GetCharacteristics', '(I)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jbluetoothlowenergy, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
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


function jBluetoothLowEnergy_GetCharacteristicProperties(env: PJNIEnv; _jbluetoothlowenergy: JObject; _serviceIndex: integer; _characteristicIndex: integer): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _serviceIndex;
  jParams[1].i:= _characteristicIndex;
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'GetCharacteristicProperties', '(II)I');
  Result:= env^.CallIntMethodA(env, _jbluetoothlowenergy, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jBluetoothLowEnergy_GetDescriptors(env: PJNIEnv; _jbluetoothlowenergy: JObject; _serviceIndex: integer; _characteristicIndex: integer): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jParams[0].i:= _serviceIndex;
  jParams[1].i:= _characteristicIndex;
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDescriptors', '(II)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jbluetoothlowenergy, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
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

procedure jBluetoothLowEnergy_ReadCharacteristic(env: PJNIEnv; _jbluetoothlowenergy: JObject; _serviceIndex: integer; _characteristicIndex: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _serviceIndex;
  jParams[1].i:= _characteristicIndex;
  jCls:= env^.GetObjectClass(env, _jbluetoothlowenergy);
  jMethod:= env^.GetMethodID(env, jCls, 'ReadCharacteristic', '(II)V');
  env^.CallVoidMethodA(env, _jbluetoothlowenergy, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
