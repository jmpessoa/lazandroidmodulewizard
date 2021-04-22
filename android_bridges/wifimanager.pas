unit wifimanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [7/26/2019 1:30:53]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jWifiManager = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure SetWifiEnabled(_value: boolean);
    function Scan(): TDynArrayOfString;
    function Connect(_networkSSID: string; _password: string): boolean;
    function ConnectWEP(_networkSSID: string; _password: string): boolean;
    function ConnectWPA(_networkSSID: string; _password: string): boolean;
    function GetSSID(_scanResultIndex: integer): string;
    function GetCapabilities(_scanResultIndex: integer): string;
    procedure RequestLocationServices();
    function IsLocationServicesON(): boolean;
    function IsLocationServicesNeed(): boolean;
    function RequestLocationServicesDenied(): boolean;

    //by software_developer
    function NeedWriteSettingsPermission(): boolean;
    procedure RequestWriteSettingsPermission();
    procedure SetWifiHotspotOn();
    procedure SetWifiHotspotOff();
    function IsWifiHotspotEnable(): boolean;
    function CreateNewWifiNetwork(): boolean; overload;
    function CreateNewWifiNetwork(_ssid: string; _password: string): boolean; overload;
    function GetCurrentHotspotSSID(): string;
    function GetCurrentHotspotPassword(): string;

 published

end;

function jWifiManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
function jWifiManager_Scan(env: PJNIEnv; _jwifimanager: JObject): TDynArrayOfString;


implementation

{---------  jWifiManager  --------------}

constructor jWifiManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jWifiManager.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jni_proc(FjEnv, FjObject, 'jFree');
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jWifiManager.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jWifiManager_jCreate(FjEnv, int64(Self), FjThis);

  if FjObject = nil then exit;
  FInitialized:= True;
end;

procedure jWifiManager.SetWifiEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(FjEnv, FjObject, 'SetWifiEnabled', _value);
end;

function jWifiManager.Scan(): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_Scan(FjEnv, FjObject);
end;

function jWifiManager.Connect(_networkSSID: string; _password: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tt_out_z(FjEnv, FjObject, 'Connect', _networkSSID ,_password);
end;

function jWifiManager.ConnectWEP(_networkSSID: string; _password: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tt_out_z(FjEnv, FjObject, 'ConnectWEP', _networkSSID ,_password);
end;

function jWifiManager.ConnectWPA(_networkSSID: string; _password: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tt_out_z(FjEnv, FjObject, 'ConnectWPA', _networkSSID ,_password);
end;

function jWifiManager.GetSSID(_scanResultIndex: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_i_out_t(FjEnv, FjObject, 'GetSSID', _scanResultIndex);
end;

function jWifiManager.GetCapabilities(_scanResultIndex: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_i_out_t(FjEnv, FjObject, 'GetCapabilities', _scanResultIndex);
end;

procedure jWifiManager.RequestLocationServices();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'RequestLocationServices');
end;

function jWifiManager.IsLocationServicesON(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'IsLocationServicesON');
end;

function jWifiManager.IsLocationServicesNeed(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'IsLocationServicesNeed');
end;

function jWifiManager.RequestLocationServicesDenied(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'RequestLocationServicesDenied');
end;

function jWifiManager.NeedWriteSettingsPermission(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'NeedWriteSettingsPermission');
end;

procedure jWifiManager.RequestWriteSettingsPermission();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'RequestWriteSettingsPermission');
end;

procedure jWifiManager.SetWifiHotspotOn();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'SetWifiHotspotOn');
end;

procedure jWifiManager.SetWifiHotspotOff();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'SetWifiHotspotOff');
end;

function jWifiManager.IsWifiHotspotEnable(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'IsWifiHotspotEnable');
end;

function jWifiManager.CreateNewWifiNetwork(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'CreateNewWifiNetwork');
end;

function jWifiManager.CreateNewWifiNetwork(_ssid: string; _password: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tt_out_z(FjEnv, FjObject, 'CreateNewWifiNetwork', _ssid ,_password);
end;

function jWifiManager.GetCurrentHotspotSSID(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetCurrentHotspotSSID');
end;

function jWifiManager.GetCurrentHotspotPassword(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'GetCurrentHotspotPassword');
end;

{-------- jWifiManager_JNI_Bridge ----------}

function jWifiManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := nil;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jWifiManager_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);    

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

function jWifiManager_Scan(env: PJNIEnv; _jwifimanager: JObject): TDynArrayOfString;
var
  jStr: JString;
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  i: integer;
label
  _exceptionOcurred;
begin
  Result := nil;
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'Scan', '()[Ljava/lang/String;');
  if jMethod = nil then goto _exceptionOcurred;

  jresultArray:= env^.CallObjectMethod(env, _jwifimanager, jMethod);

  if jResultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    for i:= 0 to resultsize - 1 do
    begin
      jStr:= env^.GetObjectArrayElement(env, jresultArray, i);
      Result[i]:= GetPStringAndDeleteLocalRef(env, jStr);
    end;
  end;

  env^.DeleteLocalRef(env, jCls);   

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


end.
