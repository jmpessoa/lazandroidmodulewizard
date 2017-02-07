unit sensormanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

//Hint ref: http://developer.android.com/reference/android/hardware/SensorEvent.html
TSensorType = (
   stNone= 0,         //  stAll = -1!
   stAccelerometer, // = 1	A constant describing an accelerometer sensor type.
   stMagneticField, // = 2 	A constant describing a magnetic field sensor type.
   stOrientation, // = 3	This constant was deprecated in API level 8. use SensorManager.getOrientation() instead.
   stGyroscope, // = 4	A constant describing a gyroscope sensor type.
   stLight, // = 5	A constant describing a light sensor type.
   stPressure, // = 6	A constant describing a pressure sensor type.
   stTemperature, // = 7 	This constant was deprecated in API level 14. use Sensor.stAMBIENT_TEMPERATURE instead.
   stProximity, // = 8	A constant describing a proximity sensor type.
   stGravity, // = 9	A constant describing a gravity sensor type.
   stLinearAcceleration, // = 10	A constant describing a linear acceleration sensor type.
   stRotationVector, // = 11	A constant describing a rotation vector sensor type.
   stRelativeHumidity, // = 12	A constant describing a relative humidity sensor type.
   stAmbientTemperature, // = 13	A constant describing an ambient temperature sensor type.
   stMagneticFieldUncalibrated, // = 14	A constant describing an uncalibrated magnetic field sensor type.
   stGameRotationVector, // = 15	A constant describing an uncalibrated rotation vector sensor type.
   stGyroscopeUncalibrated,  //= 16  A constant describing an uncalibrated gyroscope sensor type.
   stSignificantMotion, // = 17	  A constant describing a significant motion trigger sensor.
   stStepDector, // = 18 	A constant describing a step detector sensor.
   stStepCounter, // = 19	A constant describing a step counter sensor.
   stGeomagneticRotationVector, // = 20	A constant describing a geo-magnetic rotation vector.
   stHeartRate, // = 21	A constant describing a heart rate monitor.
   stAutoRotation); // = 22

TSensorDelay = (sdDelayFastest, sdDelayGame, sdDelayUI, sdDelayNormal);

(*SENSOR_DELAY_FASTEST=0
SENSOR_DELAY_GAME=1
SENSOR_DELAY_UI=2
SENSOR_DELAY_NORMAL=3*)

TOnChangedSensor = procedure(Sender: TObject; sensor: jObject; sensorType: TSensorType;  values: array of single; timestamp: int64) of Object;
TOnListeningSensor = procedure(Sender: TObject; sensor: jObject;  sensorType: TSensorType) of Object;
TOnStopedListeningSensors = procedure(Sender: TObject) of Object;
TOnUnListeningSensor = procedure(Sender: TObject; sensorType: TSensorType; sensorName: string) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [1/15/2015 3:13:47]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jSensorManager = class(jControl)
 private
    FOnChangedSensor: TOnChangedSensor;
    FOnListeningSensor: TOnListeningSensor;
    FOnUnListeningSensor: TOnUnListeningSensor;

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    function GetDeviceSensorsTypes(): TDynArrayOfInteger;
    function GetDeviceSensorsNames(): TDynArrayOfString;
    procedure RegisterListeningSensor(_sensorType: TSensorType); overload;
    procedure RegisterListeningSensor(_sensorType: TSensorType; _delayType: TSensorDelay); overload;
    procedure StopListeningAll();
    function SensorExists(_sensorType: TSensorType): boolean;
    function GetSensorsNames(_sensorType: TSensorType): TDynArrayOfString;
    function GetSensor(_sensorType: TSensorType): jObject;  overload;
    function GetSensorMaximumRange(_sensor: jObject): single;
    function GetSensorVendor(_sensor: jObject): string;
    function GetSensorMinDelay(_sensor: jObject): integer;
    function GetSensorName(_sensor: jObject): string;
    function GetSensorType(_sensor: jObject): TSensorType;
    procedure UnregisterListenerSensor(_sensor: jObject);
    function GetGravityEarth(): single;

    function GetAltitude(_localPressure: single): single; overload;
    function GetAltitude(_pressureAtSeaLevel: single; _localPressure: single): single; overload;

    function GetSensorPower(_sensor: jObject): single;
    function GetSensorResolution(_sensor: jObject): single;

    procedure RegisterListeningSensor(_sensor: jObject); overload;
    procedure RegisterListeningSensor(_sensor: jObject; _delayType: TSensorDelay); overload;

    function GetSensor(_sensorName: string): jObject; overload;

    procedure GenEvent_OnChangedSensor(Obj: TObject; sensor: JObject; sensorType: integer;  values: array of single; timestamp: int64);
    procedure GenEvent_OnListeningSensor(Obj: TObject; sensor: jObject; sensorType: integer);
    procedure GenEvent_OnUnregisterListeningSensor(Obj: TObject; sensorType: integer; sensorName: string);

 published
    property OnChanged: TOnChangedSensor  read FOnChangedSensor write FOnChangedSensor;
    property OnListening: TOnListeningSensor read FOnListeningSensor write FOnListeningSensor;
    property OnUnListening: TOnUnListeningSensor read FOnUnListeningSensor write FOnUnListeningSensor;
end;

function jSensorManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jSensorManager_jFree(env: PJNIEnv; _jsensormanager: JObject);

function jSensorManager_GetDeviceSensorsTypes(env: PJNIEnv; _jsensormanager: JObject): TDynArrayOfInteger;
function jSensorManager_GetDeviceSensorsNames(env: PJNIEnv; _jsensormanager: JObject): TDynArrayOfString;

procedure jSensorManager_RegisterListeningSensor(env: PJNIEnv; _jsensormanager: JObject; _sensorType: integer); overload;
procedure jSensorManager_RegisterListeningSensor(env: PJNIEnv; _jsensormanager: JObject; _sensorType: integer; _delayType: integer); overload;
procedure jSensorManager_StopListeningAll(env: PJNIEnv; _jsensormanager: JObject);
function jSensorManager_SensorExists(env: PJNIEnv; _jsensormanager: JObject; _sensorType: integer): boolean;
function jSensorManager_GetSensorsNames(env: PJNIEnv; _jsensormanager: JObject; _sensorType: integer): TDynArrayOfString;
function jSensorManager_GetSensor(env: PJNIEnv; _jsensormanager: JObject; _sensorType: integer): jObject;  overload;
function jSensorManager_GetSensorMaximumRange(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): single;
function jSensorManager_GetSensorVendor(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): string;
function jSensorManager_GetSensorMinDelay(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): integer;
function jSensorManager_GetSensorName(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): string;
function jSensorManager_GetSensorType(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): integer;
procedure jSensorManager_UnregisterListenerSensor(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject);
function jSensorManager_GetGravityEarth(env: PJNIEnv; _jsensormanager: JObject): single;

function jSensorManager_GetAltitude(env: PJNIEnv; _jsensormanager: JObject; _localPressure: single): single; overload;
function jSensorManager_GetAltitude(env: PJNIEnv; _jsensormanager: JObject; _pressureAtSeaLevel: single; _localPressure: single): single; overload;

function jSensorManager_GetSensorPower(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): single;
function jSensorManager_GetSensorResolution(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): single;

procedure jSensorManager_RegisterListeningSensor(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject); overload;
procedure jSensorManager_RegisterListeningSensor(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject; _delayType: integer); overload;

function jSensorManager_GetSensor(env: PJNIEnv; _jsensormanager: JObject; _sensorName: string): jObject;  overload;

implementation

{---------  jSensorManager  --------------}

constructor jSensorManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jSensorManager.Destroy;
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

procedure jSensorManager.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jSensorManager.jCreate(): jObject;
begin
   Result:= jSensorManager_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jSensorManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSensorManager_jFree(FjEnv, FjObject);
end;

function jSensorManager.GetDeviceSensorsTypes(): TDynArrayOfInteger;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetDeviceSensorsTypes(FjEnv, FjObject);
end;

function jSensorManager.GetDeviceSensorsNames(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetDeviceSensorsNames(FjEnv, FjObject);
end;

procedure jSensorManager.RegisterListeningSensor(_sensorType: TSensorType);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSensorManager_RegisterListeningSensor(FjEnv, FjObject, Ord(_sensorType));
end;

procedure jSensorManager.RegisterListeningSensor(_sensorType: TSensorType; _delayType: TSensorDelay);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSensorManager_RegisterListeningSensor(FjEnv, FjObject, Ord(_sensorType) ,Ord(_delayType));
end;

procedure jSensorManager.StopListeningAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSensorManager_StopListeningAll(FjEnv, FjObject);
end;

function jSensorManager.SensorExists(_sensorType: TSensorType): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_SensorExists(FjEnv, FjObject, Ord(_sensorType));
end;

function jSensorManager.GetSensorsNames(_sensorType: TSensorType): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetSensorsNames(FjEnv, FjObject, Ord(_sensorType));
end;

function jSensorManager.GetSensor(_sensorType: TSensorType): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetSensor(FjEnv, FjObject, Ord(_sensorType));
end;

function jSensorManager.GetSensorMaximumRange(_sensor: jObject): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetSensorMaximumRange(FjEnv, FjObject, _sensor);
end;

function jSensorManager.GetSensorVendor(_sensor: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetSensorVendor(FjEnv, FjObject, _sensor);
end;

function jSensorManager.GetSensorMinDelay(_sensor: jObject): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetSensorMinDelay(FjEnv, FjObject, _sensor);
end;

function jSensorManager.GetSensorName(_sensor: jObject): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetSensorName(FjEnv, FjObject, _sensor);
end;

function jSensorManager.GetSensorType(_sensor: jObject): TSensorType;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= TSensorType(jSensorManager_GetSensorType(FjEnv, FjObject, _sensor));
end;

procedure jSensorManager.UnregisterListenerSensor(_sensor: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSensorManager_UnregisterListenerSensor(FjEnv, FjObject, _sensor);
end;

function jSensorManager.GetGravityEarth(): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetGravityEarth(FjEnv, FjObject);
end;

procedure jSensorManager.GenEvent_OnChangedSensor(Obj: TObject; sensor: JObject;  sensorType: integer;  values: array of single; timestamp: int64);
begin
  if Assigned(FOnChangedSensor) then FOnChangedSensor(Obj, sensor, TSensorType(sensorType), values, timestamp);
end;

procedure jSensorManager.GenEvent_OnListeningSensor(Obj: TObject; sensor: jObject; sensorType: integer);
begin
  if Assigned(FOnListeningSensor) then FOnListeningSensor(Obj, sensor, TSensorType(sensorType) );
end;

procedure jSensorManager.GenEvent_OnUnregisterListeningSensor(Obj: TObject; sensorType: integer; sensorName: string);
begin
  if Assigned(FOnUnListeningSensor) then FOnUnListeningSensor(Obj, TSensorType(sensorType), sensorName);
end;

function jSensorManager.GetAltitude(_localPressure: single): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetAltitude(FjEnv, FjObject, _localPressure);
end;

function jSensorManager.GetAltitude(_pressureAtSeaLevel: single; _localPressure: single): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetAltitude(FjEnv, FjObject, _pressureAtSeaLevel ,_localPressure);
end;

function jSensorManager.GetSensorPower(_sensor: jObject): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetSensorPower(FjEnv, FjObject, _sensor);
end;

function jSensorManager.GetSensorResolution(_sensor: jObject): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetSensorResolution(FjEnv, FjObject, _sensor);
end;

procedure jSensorManager.RegisterListeningSensor(_sensor: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSensorManager_RegisterListeningSensor(FjEnv, FjObject, _sensor);
end;

procedure jSensorManager.RegisterListeningSensor(_sensor: jObject; _delayType: TSensorDelay);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSensorManager_RegisterListeningSensor(FjEnv, FjObject, _sensor ,Ord(_delayType));
end;

function jSensorManager.GetSensor(_sensorName: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSensorManager_GetSensor(FjEnv, FjObject, _sensorName);
end;

{-------- jSensorManager_JNI_Bridge ----------}

function jSensorManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSensorManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jSensorManager_jCreate(long _Self) {
      return (java.lang.Object)(new jSensorManager(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jSensorManager_jFree(env: PJNIEnv; _jsensormanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsensormanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSensorManager_GetDeviceSensorsTypes(env: PJNIEnv; _jsensormanager: JObject): TDynArrayOfInteger;
var
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDeviceSensorsTypes', '()[I');
  jresultArray:= env^.CallObjectMethod(env, _jsensormanager, jMethod);
  if jresultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    env^.GetIntArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jSensorManager_GetDeviceSensorsNames(env: PJNIEnv; _jsensormanager: JObject): TDynArrayOfString;
var
  jStr: JString;
  jBoo: JBoolean;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
begin
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDeviceSensorsNames', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jsensormanager, jMethod);
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


procedure jSensorManager_RegisterListeningSensor(env: PJNIEnv; _jsensormanager: JObject; _sensorType: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _sensorType;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RegisterListeningSensor', '(I)V');
  env^.CallVoidMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSensorManager_RegisterListeningSensor(env: PJNIEnv; _jsensormanager: JObject; _sensorType: integer; _delayType: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _sensorType;
  jParams[1].i:= _delayType;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RegisterListeningSensor', '(II)V');
  env^.CallVoidMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSensorManager_StopListeningAll(env: PJNIEnv; _jsensormanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'StopListeningAll', '()V');
  env^.CallVoidMethod(env, _jsensormanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSensorManager_SensorExists(env: PJNIEnv; _jsensormanager: JObject; _sensorType: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _sensorType;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SensorExists', '(I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jsensormanager, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jSensorManager_GetSensorsNames(env: PJNIEnv; _jsensormanager: JObject; _sensorType: integer): TDynArrayOfString;
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
  jParams[0].i:= _sensorType;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSensorsNames', '(I)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jsensormanager, jMethod,  @jParams);
  if jresultArray <> nil then
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


function jSensorManager_GetSensor(env: PJNIEnv; _jsensormanager: JObject; _sensorType: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _sensorType;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSensor', '(I)Landroid/hardware/Sensor;');
  Result:= env^.CallObjectMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSensorManager_GetSensorMaximumRange(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _sensor;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSensorMaximumRange', '(Landroid/hardware/Sensor;)F');
  Result:= env^.CallFloatMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSensorManager_GetSensorVendor(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _sensor;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSensorVendor', '(Landroid/hardware/Sensor;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jsensormanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jSensorManager_GetSensorMinDelay(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _sensor;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSensorMinDelay', '(Landroid/hardware/Sensor;)I');
  Result:= env^.CallIntMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSensorManager_GetSensorName(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _sensor;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSensorName', '(Landroid/hardware/Sensor;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jsensormanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jSensorManager_GetSensorType(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _sensor;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSensorType', '(Landroid/hardware/Sensor;)I');
  Result:= env^.CallIntMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSensorManager_UnregisterListenerSensor(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _sensor;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'UnregisterListenerSensor', '(Landroid/hardware/Sensor;)V');
  env^.CallVoidMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jSensorManager_GetGravityEarth(env: PJNIEnv; _jsensormanager: JObject): single;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGravityEarth', '()F');
  Result:= env^.CallFloatMethod(env, _jsensormanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jSensorManager_GetAltitude(env: PJNIEnv; _jsensormanager: JObject; _localPressure: single): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _localPressure;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetAltitude', '(F)F');
  Result:= env^.CallFloatMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSensorManager_GetAltitude(env: PJNIEnv; _jsensormanager: JObject; _pressureAtSeaLevel: single; _localPressure: single): single;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _pressureAtSeaLevel;
  jParams[1].f:= _localPressure;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetAltitude', '(FF)F');
  Result:= env^.CallFloatMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jSensorManager_GetSensorPower(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _sensor;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSensorPower', '(Landroid/hardware/Sensor;)F');
  Result:= env^.CallFloatMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jSensorManager_GetSensorResolution(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _sensor;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSensorResolution', '(Landroid/hardware/Sensor;)F');
  Result:= env^.CallFloatMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSensorManager_RegisterListeningSensor(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _sensor;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RegisterListeningSensor', '(Landroid/hardware/Sensor;)V');
  env^.CallVoidMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSensorManager_RegisterListeningSensor(env: PJNIEnv; _jsensormanager: JObject; _sensor: jObject; _delayType: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _sensor;
  jParams[1].i:= _delayType;
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RegisterListeningSensor', '(Landroid/hardware/Sensor;I)V');
  env^.CallVoidMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jSensorManager_GetSensor(env: PJNIEnv; _jsensormanager: JObject; _sensorName: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sensorName));
  jCls:= env^.GetObjectClass(env, _jsensormanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSensor', '(Ljava/lang/String;)Landroid/hardware/Sensor;');
  Result:= env^.CallObjectMethodA(env, _jsensormanager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
