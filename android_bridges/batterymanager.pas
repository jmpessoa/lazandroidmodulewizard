unit batterymanager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [8/7/2021 16:33:49]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

TChargePlug = (cpUnknown, cpAC,  cpUSB);

TOnBatteryCharging=procedure(Sender:TObject;batteryAtPercentLevel:integer;pluggedBy:TChargePlug) of object;
TOnBatteryDisCharging=procedure(Sender:TObject;batteryAtPercentLevel:integer) of object;
TOnBatteryFull=procedure(Sender:TObject;batteryAtPercentLevel:integer) of object;
TOnBatteryUnknown=procedure(Sender:TObject;batteryAtPercentLevel:integer) of object;
TOnBatteryNotCharging=procedure(Sender:TObject;batteryAtPercentLevel:integer) of object;

{jControl template}

jBatteryManager = class(jControl)
 private
    FOnCharging: TOnBatteryCharging;
    FOnDisCharging: TOnBatteryDisCharging;
    FOnFull: TOnBatteryFull;
    FOnUnknown: TOnBatteryUnknown;
    FOnNotCharging: TOnBatteryNotCharging;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    function jCreate(): jObject;
    procedure jFree();
    function GetBatteryPercent(): integer;

    procedure GenEvent_OnBatteryCharging(Sender:TObject;batteryAtPercentLevel:integer;pluggedBy:integer);
    procedure GenEvent_OnBatteryDisCharging(Sender:TObject;batteryAtPercentLevel:integer);
    procedure GenEvent_OnBatteryFull(Sender:TObject;batteryAtPercentLevel:integer);
    procedure GenEvent_OnBatteryUnknown(Sender:TObject;batteryAtPercentLevel:integer);
    procedure GenEvent_OnBatteryNotCharging(Sender:TObject;batteryAtPercentLevel:integer);

 published
    property OnCharging: TOnBatteryCharging read FOnCharging write FOnCharging;
    property OnDisCharging: TOnBatteryDisCharging read FOnDisCharging write FOnDisCharging;
    property OnFull: TOnBatteryFull read FOnFull write FOnFull;
    property OnUnknown: TOnBatteryUnknown read FOnUnknown write FOnUnknown;
    property OnNotCharging: TOnBatteryNotCharging read FOnNotCharging write FOnNotCharging;
end;

function jBatteryManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jBatteryManager_jFree(env: PJNIEnv; _jbatterymanager: JObject);
function jBatteryManager_GetBatteryPercent(env: PJNIEnv; _jbatterymanager: JObject): integer;


implementation

{---------  jBatteryManager  --------------}

constructor jBatteryManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jBatteryManager.Destroy;
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

procedure jBatteryManager.Init;
begin

  if FInitialized  then Exit;
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  FInitialized:= True;
end;


function jBatteryManager.jCreate(): jObject;
begin
   Result:= jBatteryManager_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jBatteryManager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jBatteryManager_jFree(gApp.jni.jEnv, FjObject);
end;

function jBatteryManager.GetBatteryPercent(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jBatteryManager_GetBatteryPercent(gApp.jni.jEnv, FjObject);
end;

procedure jBatteryManager.GenEvent_OnBatteryCharging(Sender:TObject;batteryAtPercentLevel:integer;pluggedBy:integer);
begin
  if Assigned(FOnCharging) then FOnCharging(Sender,batteryAtPercentLevel,TChargePlug(pluggedBy));
end;
procedure jBatteryManager.GenEvent_OnBatteryDisCharging(Sender:TObject;batteryAtPercentLevel:integer);
begin
  if Assigned(FOnDisCharging) then FOnDisCharging(Sender,batteryAtPercentLevel);
end;
procedure jBatteryManager.GenEvent_OnBatteryFull(Sender:TObject;batteryAtPercentLevel:integer);
begin
  if Assigned(FOnFull) then FOnFull(Sender,batteryAtPercentLevel);
end;
procedure jBatteryManager.GenEvent_OnBatteryUnknown(Sender:TObject;batteryAtPercentLevel:integer);
begin
  if Assigned(FOnUnknown) then FOnUnknown(Sender,batteryAtPercentLevel);
end;
procedure jBatteryManager.GenEvent_OnBatteryNotCharging(Sender:TObject;batteryAtPercentLevel:integer);
begin
  if Assigned(FOnNotCharging) then FOnNotCharging(Sender,batteryAtPercentLevel);
end;

{-------- jBatteryManager_JNI_Bridge ----------}

function jBatteryManager_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  Result := nil;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jBatteryManager_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure jBatteryManager_jFree(env: PJNIEnv; _jbatterymanager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jbatterymanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jbatterymanager, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

function jBatteryManager_GetBatteryPercent(env: PJNIEnv; _jbatterymanager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jbatterymanager);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetBatteryPercent', '()I');
  if jMethod = nil then goto _exceptionOcurred;

  Result:= env^.CallIntMethod(env, _jbatterymanager, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
