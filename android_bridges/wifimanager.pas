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
    function jCreate(): jObject;
    procedure jFree();
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
procedure jWifiManager_jFree(env: PJNIEnv; _jwifimanager: JObject);
procedure jWifiManager_SetWifiEnabled(env: PJNIEnv; _jwifimanager: JObject; _value: boolean);
function jWifiManager_Scan(env: PJNIEnv; _jwifimanager: JObject): TDynArrayOfString;
function jWifiManager_Connect(env: PJNIEnv; _jwifimanager: JObject; _networkSSID: string; _password: string): boolean;
function jWifiManager_ConnectWEP(env: PJNIEnv; _jwifimanager: JObject; _networkSSID: string; _password: string): boolean;
function jWifiManager_ConnectWPA(env: PJNIEnv; _jwifimanager: JObject; _networkSSID: string; _password: string): boolean;
function jWifiManager_GetSSID(env: PJNIEnv; _jwifimanager: JObject; _scanResultIndex: integer): string;
function jWifiManager_GetCapabilities(env: PJNIEnv; _jwifimanager: JObject; _scanResultIndex: integer): string;
procedure jWifiManager_RequestLocationServices(env: PJNIEnv; _jwifimanager: JObject);
function jWifiManager_IsLocationServicesON(env: PJNIEnv; _jwifimanager: JObject): boolean;
function jWifiManager_IsLocationServicesNeed(env: PJNIEnv; _jwifimanager: JObject): boolean;
function jWifiManager_RequestLocationServicesDenied(env: PJNIEnv; _jwifimanager: JObject): boolean;

function jWifiManager_NeedWriteSettingsPermission(env: PJNIEnv; _jwifimanager: JObject): boolean;
procedure jWifiManager_RequestWriteSettingsPermission(env: PJNIEnv; _jwifimanager: JObject);
procedure jWifiManager_SetWifiHotspotOn(env: PJNIEnv; _jwifimanager: JObject);
procedure jWifiManager_SetWifiHotspotOff(env: PJNIEnv; _jwifimanager: JObject);
function jWifiManager_IsWifiHotspotEnable(env: PJNIEnv; _jwifimanager: JObject): boolean;
function jWifiManager_CreateNewWifiNetwork(env: PJNIEnv; _jwifimanager: JObject): boolean; overload;
function jWifiManager_CreateNewWifiNetwork(env: PJNIEnv; _jwifimanager: JObject; _ssid: string; _password: string): boolean; overload;
function jWifiManager_GetCurrentHotspotSSID(env: PJNIEnv; _jwifimanager: JObject): string;
function jWifiManager_GetCurrentHotspotPassword(env: PJNIEnv; _jwifimanager: JObject): string;


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
       jFree();
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
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;


function jWifiManager.jCreate(): jObject;
begin
   Result:= jWifiManager_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jWifiManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jWifiManager_jFree(FjEnv, FjObject);
end;

procedure jWifiManager.SetWifiEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jWifiManager_SetWifiEnabled(FjEnv, FjObject, _value);
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
   Result:= jWifiManager_Connect(FjEnv, FjObject, _networkSSID ,_password);
end;

function jWifiManager.ConnectWEP(_networkSSID: string; _password: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_ConnectWEP(FjEnv, FjObject, _networkSSID ,_password);
end;

function jWifiManager.ConnectWPA(_networkSSID: string; _password: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_ConnectWPA(FjEnv, FjObject, _networkSSID ,_password);
end;

function jWifiManager.GetSSID(_scanResultIndex: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_GetSSID(FjEnv, FjObject, _scanResultIndex);
end;

function jWifiManager.GetCapabilities(_scanResultIndex: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_GetCapabilities(FjEnv, FjObject, _scanResultIndex);
end;

procedure jWifiManager.RequestLocationServices();
begin
  //in designing component state: set value here...
  if FInitialized then
     jWifiManager_RequestLocationServices(FjEnv, FjObject);
end;

function jWifiManager.IsLocationServicesON(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_IsLocationServicesON(FjEnv, FjObject);
end;

function jWifiManager.IsLocationServicesNeed(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_IsLocationServicesNeed(FjEnv, FjObject);
end;

function jWifiManager.RequestLocationServicesDenied(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_RequestLocationServicesDenied(FjEnv, FjObject);
end;

function jWifiManager.NeedWriteSettingsPermission(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_NeedWriteSettingsPermission(FjEnv, FjObject);
end;

procedure jWifiManager.RequestWriteSettingsPermission();
begin
  //in designing component state: set value here...
  if FInitialized then
     jWifiManager_RequestWriteSettingsPermission(FjEnv, FjObject);
end;

procedure jWifiManager.SetWifiHotspotOn();
begin
  //in designing component state: set value here...
  if FInitialized then
     jWifiManager_SetWifiHotspotOn(FjEnv, FjObject);
end;

procedure jWifiManager.SetWifiHotspotOff();
begin
  //in designing component state: set value here...
  if FInitialized then
     jWifiManager_SetWifiHotspotOff(FjEnv, FjObject);
end;

function jWifiManager.IsWifiHotspotEnable(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_IsWifiHotspotEnable(FjEnv, FjObject);
end;

function jWifiManager.CreateNewWifiNetwork(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_CreateNewWifiNetwork(FjEnv, FjObject);
end;

function jWifiManager.CreateNewWifiNetwork(_ssid: string; _password: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_CreateNewWifiNetwork(FjEnv, FjObject, _ssid ,_password);
end;

function jWifiManager.GetCurrentHotspotSSID(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_GetCurrentHotspotSSID(FjEnv, FjObject);
end;

function jWifiManager.GetCurrentHotspotPassword(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jWifiManager_GetCurrentHotspotPassword(FjEnv, FjObject);
end;

{-------- jWifiManager_JNI_Bridge ----------}

function jWifiManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jWifiManager_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jWifiManager_jFree(env: PJNIEnv; _jwifimanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jwifimanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jWifiManager_SetWifiEnabled(env: PJNIEnv; _jwifimanager: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetWifiEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jwifimanager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jWifiManager_Scan(env: PJNIEnv; _jwifimanager: JObject): TDynArrayOfString;
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
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Scan', '()[Ljava/lang/String;');
  jresultArray:= env^.CallObjectMethod(env, _jwifimanager, jMethod);
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

function jWifiManager_Connect(env: PJNIEnv; _jwifimanager: JObject; _networkSSID: string; _password: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_networkSSID));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jwifimanager, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jWifiManager_ConnectWEP(env: PJNIEnv; _jwifimanager: JObject; _networkSSID: string; _password: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_networkSSID));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'ConnectWEP', '(Ljava/lang/String;Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jwifimanager, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jWifiManager_ConnectWPA(env: PJNIEnv; _jwifimanager: JObject; _networkSSID: string; _password: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_networkSSID));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'ConnectWPA', '(Ljava/lang/String;Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jwifimanager, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jWifiManager_GetSSID(env: PJNIEnv; _jwifimanager: JObject; _scanResultIndex: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _scanResultIndex;
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSSID', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jwifimanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jWifiManager_GetCapabilities(env: PJNIEnv; _jwifimanager: JObject; _scanResultIndex: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _scanResultIndex;
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetCapabilities', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jwifimanager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jWifiManager_RequestLocationServices(env: PJNIEnv; _jwifimanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestLocationServices', '()V');
  env^.CallVoidMethod(env, _jwifimanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jWifiManager_IsLocationServicesON(env: PJNIEnv; _jwifimanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IsLocationServicesON', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jwifimanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jWifiManager_IsLocationServicesNeed(env: PJNIEnv; _jwifimanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IsLocationServicesNeed', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jwifimanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jWifiManager_RequestLocationServicesDenied(env: PJNIEnv; _jwifimanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestLocationServicesDenied', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jwifimanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jWifiManager_NeedWriteSettingsPermission(env: PJNIEnv; _jwifimanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'NeedWriteSettingsPermission', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jwifimanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jWifiManager_RequestWriteSettingsPermission(env: PJNIEnv; _jwifimanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestWriteSettingsPermission', '()V');
  env^.CallVoidMethod(env, _jwifimanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jWifiManager_SetWifiHotspotOn(env: PJNIEnv; _jwifimanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetWifiHotspotOn', '()V');
  env^.CallVoidMethod(env, _jwifimanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jWifiManager_SetWifiHotspotOff(env: PJNIEnv; _jwifimanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetWifiHotspotOff', '()V');
  env^.CallVoidMethod(env, _jwifimanager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jWifiManager_IsWifiHotspotEnable(env: PJNIEnv; _jwifimanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'IsWifiHotspotEnable', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jwifimanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jWifiManager_CreateNewWifiNetwork(env: PJNIEnv; _jwifimanager: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'CreateNewWifiNetwork', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jwifimanager, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jWifiManager_CreateNewWifiNetwork(env: PJNIEnv; _jwifimanager: JObject; _ssid: string; _password: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_ssid));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'CreateNewWifiNetwork', '(Ljava/lang/String;Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jwifimanager, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jWifiManager_GetCurrentHotspotSSID(env: PJNIEnv; _jwifimanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetCurrentHotspotSSID', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jwifimanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jWifiManager_GetCurrentHotspotPassword(env: PJNIEnv; _jwifimanager: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jwifimanager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetCurrentHotspotPassword', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jwifimanager, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


end.
