unit bluetooth;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, bluetoothclientsocket, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/15/2014 12:37:34]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

TOnDeviceFound = procedure(Sender: TObject; deviceName: string; deviceAddress: string) of Object;
TOnDiscoveryFinished = procedure(Sender: TObject; countFoundedDevices: integer; countPairedDevices: integer) of Object;

TOnDeviceBondStateChanged= procedure(Sender: TObject; state: integer; deviceName: string; deviceAddress: string) of Object;

TBondState = ( bsUnBonded {10/Unpaired}, bsBonding {11/Pairing}, bsBonded{12/Paired});

{
PairingWith ///11
PairedWith  //12
UnpairedWith //10
}


{jControl template}

jBluetooth = class(jControl)
 private

    FOnEnabled: TOnNotify;
    FOnDisabled: TOnNotify;
    FOnDeviceFound: TOnDeviceFound;
    FOnDiscoveryStarted: TOnNotify;
    FOnDiscoveryFinished: TOnDiscoveryFinished;
    FOnDeviceBondStateChanged: TOnDeviceBondStateChanged;
 protected
    //
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure Enabled();
    procedure Discovery();
    procedure CancelDiscovery();
    function GetPairedDevices(): TDynArrayOfString;
    function GetFoundedDevices(): TDynArrayOfString;
    function GetReachablePairedDevices(): TDynArrayOfString;
    procedure Disable();
    function IsEnable(): boolean;
    function GetState(): integer;

    function GetReachablePairedDeviceByName(_deviceName: string): jObject;
    function GetReachablePairedDeviceByAddress(_deviceAddress: string): jObject;

    function IsReachablePairedDevice(_macAddress: string): boolean;
    function GetRemoteDevice(_macAddress: string): jObject;

    procedure UnpairDeviceByAddress(_deviceAddress: string);
    function GetFoundedDeviceByAddress(_deviceAddress: string): jObject;
    procedure PairDeviceByAddress(_deviceAddress: string);

    procedure GenEvent_OnBluetoothEnabled(Obj: TObject);
    procedure GenEvent_OnBluetoothDisabled(Obj: TObject);
    procedure GenEvent_OnBluetoothDeviceFound(Obj: TObject; _deviceName: string; _deviceAddress: string);
    procedure GenEvent_OnBluetoothDiscoveryStarted(Obj: TObject);
    procedure GenEvent_OnBluetoothDiscoveryFinished(Obj: TObject; countFoundedDevices: integer; countPairedDevices: integer);
    procedure GenEvent_OnBluetoothDeviceBondStateChanged(Obj: TObject; state: integer; _deviceName: string; _deviceAddress: string);

    function GetBondState(state: integer):TBondState;
    procedure SendFile(_filePath: string; _fileName: string; _mimeType: string);

 published
    property OnEnabled: TOnNotify read FOnEnabled write FOnEnabled;
    property OnDisabled: TOnNotify read FOnDisabled write FOnDisabled;

    property OnDeviceFound: TOnDeviceFound read FOnDeviceFound write FOnDeviceFound;
    property OnDiscoveryStarted: TOnNotify read FOnDiscoveryStarted write FOnDiscoveryStarted;
    property OnDiscoveryFinished: TOnDiscoveryFinished read FOnDiscoveryFinished write FOnDiscoveryFinished;
    property OnDeviceBondStateChanged: TOnDeviceBondStateChanged read FOnDeviceBondStateChanged write FOnDeviceBondStateChanged;

end;

function jBluetooth_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
procedure jBluetooth_jFree(env: PJNIEnv; _jbluetooth: JObject);
procedure jBluetooth_Enabled(env: PJNIEnv; _jbluetooth: JObject);
procedure jBluetooth_Discovery(env: PJNIEnv; _jbluetooth: JObject);
procedure jBluetooth_CancelDiscovery(env: PJNIEnv; _jbluetooth: JObject);
function jBluetooth_GetPairedDevices(env: PJNIEnv; _jbluetooth: JObject): TDynArrayOfString;
function jBluetooth_GetFoundedDevices(env: PJNIEnv; _jbluetooth: JObject): TDynArrayOfString;
function jBluetooth_GetReachablePairedDevices(env: PJNIEnv; _jbluetooth: JObject): TDynArrayOfString;
procedure jBluetooth_Disable(env: PJNIEnv; _jbluetooth: JObject);
function jBluetooth_IsEnable(env: PJNIEnv; _jbluetooth: JObject): boolean;
function jBluetooth_GetState(env: PJNIEnv; _jbluetooth: JObject): integer;
function jBluetooth_GetReachablePairedDeviceByName(env: PJNIEnv; _jbluetooth: JObject; _deviceName: string): jObject;
function jBluetooth_GetReachablePairedDeviceByAddress(env: PJNIEnv; _jbluetooth: JObject; _deviceAddress: string): jObject;
function jBluetooth_IsReachablePairedDevice(env: PJNIEnv; _jbluetooth: JObject; _macAddress: string): boolean;
function jBluetooth_GetRemoteDevice(env: PJNIEnv; _jbluetooth: JObject; _macAddress: string): jObject;
procedure jBluetooth_SendFile(env: PJNIEnv; _jbluetooth: JObject; _filePath: string; _fileName: string; _mimeType: string);

procedure jBluetooth_UnpairDeviceByAddress(env: PJNIEnv; _jbluetooth: JObject; _deviceAddress: string);
function jBluetooth_GetFoundedDeviceByAddress(env: PJNIEnv; _jbluetooth: JObject; _deviceAddress: string): jObject;
procedure jBluetooth_PairDeviceByAddress(env: PJNIEnv; _jbluetooth: JObject; _deviceAddress: string);



implementation

{---------  jBluetooth  --------------}

constructor jBluetooth.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
end;

destructor jBluetooth.Destroy;
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

procedure jBluetooth.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject:= jCreate();
  FInitialized:= True;
end;


function jBluetooth.jCreate(): jObject;
begin
   Result:= jBluetooth_jCreate(FjEnv, FjThis, int64(Self));
end;

procedure jBluetooth.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_jFree(FjEnv, FjObject);
end;

procedure jBluetooth.Enabled();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_Enabled(FjEnv, FjObject);
end;

procedure jBluetooth.Discovery();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_Discovery(FjEnv, FjObject);
end;

procedure jBluetooth.CancelDiscovery();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_CancelDiscovery(FjEnv, FjObject);
end;

function jBluetooth.GetPairedDevices(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetPairedDevices(FjEnv, FjObject);
end;

function jBluetooth.GetFoundedDevices(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetFoundedDevices(FjEnv, FjObject);
end;

function jBluetooth.GetReachablePairedDevices(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetReachablePairedDevices(FjEnv, FjObject);
end;

procedure jBluetooth.Disable();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_Disable(FjEnv, FjObject);
end;

function jBluetooth.IsEnable(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_IsEnable(FjEnv, FjObject);
end;

function jBluetooth.GetState(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetState(FjEnv, FjObject);
end;

function jBluetooth.GetReachablePairedDeviceByName(_deviceName: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
    Result:= jBluetooth_GetReachablePairedDeviceByName(FjEnv, FjObject, _deviceName);
end;

function jBluetooth.GetReachablePairedDeviceByAddress(_deviceAddress: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetReachablePairedDeviceByAddress(FjEnv, FjObject, _deviceAddress);
end;


function jBluetooth.IsReachablePairedDevice(_macAddress: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_IsReachablePairedDevice(FjEnv, FjObject, _macAddress);
end;

function jBluetooth.GetRemoteDevice(_macAddress: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetRemoteDevice(FjEnv, FjObject, _macAddress);
end;

procedure jBluetooth.GenEvent_OnBluetoothEnabled(Obj: TObject);
begin
   if Assigned(FOnEnabled) then FOnEnabled(Obj);
end;

procedure jBluetooth.GenEvent_OnBluetoothDisabled(Obj: TObject);
begin
   if Assigned(FOnDisabled) then FOnDisabled(Obj);
end;

procedure jBluetooth.GenEvent_OnBluetoothDeviceFound(Obj: TObject; _deviceName: string; _deviceAddress: string);
begin
   if Assigned(FOnDeviceFound) then FOnDeviceFound(Obj,_deviceName, _deviceAddress);
end;

procedure jBluetooth.GenEvent_OnBluetoothDiscoveryStarted(Obj: TObject);
begin
   if Assigned(FOnDiscoveryStarted) then FOnDiscoveryStarted(Obj);
end;

procedure jBluetooth.GenEvent_OnBluetoothDiscoveryFinished(Obj: TObject; countFoundedDevices: integer; countPairedDevices: integer);
begin
   if Assigned(FOnDiscoveryFinished) then FOnDiscoveryFinished(Obj, countFoundedDevices, countPairedDevices);
end;

procedure jBluetooth.GenEvent_OnBluetoothDeviceBondStateChanged(Obj: TObject; state: integer; _deviceName: string; _deviceAddress: string);
begin
   if Assigned(FOnDeviceBondStateChanged) then FOnDeviceBondStateChanged(Obj, state, _deviceName, _deviceAddress);
end;

//TBondState = ( bsNone {10/Unpaired}, bsBonding {11/Pairing}, bsBonded{12/Paired});
function jBluetooth.GetBondState(state: integer):TBondState;
begin
  Result:= bsUnBonded; //10  Unpaired With
  case state of
     11: Result:= bsBonding; //Pairing With
     12: Result:= bsBonded;  //PairedWith
  end;
end;

procedure jBluetooth.SendFile(_filePath: string; _fileName: string; _mimeType: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_SendFile(FjEnv, FjObject, _filePath ,_fileName ,LowerCase(_mimeType));
end;


procedure jBluetooth.UnpairDeviceByAddress(_deviceAddress: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_UnpairDeviceByAddress(FjEnv, FjObject, _deviceAddress);
end;

function jBluetooth.GetFoundedDeviceByAddress(_deviceAddress: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBluetooth_GetFoundedDeviceByAddress(FjEnv, FjObject, _deviceAddress);
end;

procedure jBluetooth.PairDeviceByAddress(_deviceAddress: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jBluetooth_PairDeviceByAddress(FjEnv, FjObject, _deviceAddress);
end;

{-------- jBluetooth_JNI_Bridge ----------}

function jBluetooth_jCreate(env: PJNIEnv; this: JObject;_Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jBluetooth_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jBluetooth_jCreate(long _Self) {
      return (java.lang.Object)(new jBluetooth(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jBluetooth_jFree(env: PJNIEnv; _jbluetooth: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jbluetooth, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetooth_Enabled(env: PJNIEnv; _jbluetooth: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'Enabled', '()V');
  env^.CallVoidMethod(env, _jbluetooth, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetooth_Discovery(env: PJNIEnv; _jbluetooth: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'Discovery', '()V');
  env^.CallVoidMethod(env, _jbluetooth, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetooth_CancelDiscovery(env: PJNIEnv; _jbluetooth: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'CancelDiscovery', '()V');
  env^.CallVoidMethod(env, _jbluetooth, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetooth_GetPairedDevices(env: PJNIEnv; _jbluetooth: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPairedDevices', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jbluetooth, jMethod);
  if jresultArray <> nil then
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

function jBluetooth_GetFoundedDevices(env: PJNIEnv; _jbluetooth: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFoundedDevices', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jbluetooth, jMethod);
  if jresultArray <> nil then
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

function jBluetooth_GetReachablePairedDevices(env: PJNIEnv; _jbluetooth: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetReachablePairedDevices', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jbluetooth, jMethod);
  if jresultArray <> nil then
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

procedure jBluetooth_Disable(env: PJNIEnv; _jbluetooth: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'Disable', '()V');
  env^.CallVoidMethod(env, _jbluetooth, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetooth_IsEnable(env: PJNIEnv; _jbluetooth: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'IsEnable', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jbluetooth, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetooth_GetState(env: PJNIEnv; _jbluetooth: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetState', '()I');
  Result:= env^.CallIntMethod(env, _jbluetooth, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetooth_GetReachablePairedDeviceByName(env: PJNIEnv; _jbluetooth: JObject; _deviceName: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_deviceName));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetReachablePairedDeviceByName', '(Ljava/lang/String;)Landroid/bluetooth/BluetoothDevice;');
  Result:= env^.CallObjectMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetooth_GetReachablePairedDeviceByAddress(env: PJNIEnv; _jbluetooth: JObject; _deviceAddress: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_deviceAddress));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetReachablePairedDeviceByAddress', '(Ljava/lang/String;)Landroid/bluetooth/BluetoothDevice;');
  Result:= env^.CallObjectMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jBluetooth_IsReachablePairedDevice(env: PJNIEnv; _jbluetooth: JObject; _macAddress: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_macAddress));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'IsReachablePairedDevice', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jbluetooth, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jBluetooth_GetRemoteDevice(env: PJNIEnv; _jbluetooth: JObject; _macAddress: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_macAddress));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetRemoteDevice', '(Ljava/lang/String;)Landroid/bluetooth/BluetoothDevice;');
  Result:= env^.CallObjectMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetooth_SendFile(env: PJNIEnv; _jbluetooth: JObject; _filePath: string; _fileName: string; _mimeType: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filePath));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_mimeType));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'SendFile', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jBluetooth_UnpairDeviceByAddress(env: PJNIEnv; _jbluetooth: JObject; _deviceAddress: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_deviceAddress));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'UnpairDeviceByAddress', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetooth, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jBluetooth_GetFoundedDeviceByAddress(env: PJNIEnv; _jbluetooth: JObject; _deviceAddress: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_deviceAddress));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFoundedDeviceByAddress', '(Ljava/lang/String;)Landroid/bluetooth/BluetoothDevice;');
  Result:= env^.CallObjectMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jBluetooth_PairDeviceByAddress(env: PJNIEnv; _jbluetooth: JObject; _deviceAddress: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_deviceAddress));
  jCls:= env^.GetObjectClass(env, _jbluetooth);
  jMethod:= env^.GetMethodID(env, jCls, 'PairDeviceByAddress', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jbluetooth, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
