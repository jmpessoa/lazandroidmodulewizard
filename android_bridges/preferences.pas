unit preferences;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "Lazarus Android Module Wizard" [8/13/2014 2:20:51]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jPreferences = class(jControl)
 private
    FIsShared: boolean;

 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;

    procedure Clear();
    procedure Remove(_key: string);

    function  GetIntData(_key: string; _defaultValue: integer): integer;
    function  GetLongData(_key: string; _defaultValue: int64): int64;
    function  GetFloatData(_key: string; _defaultValue: single): single;
    function  GetStringData(_key: string; _defaultValue: string): string;
    function  GetBoolData(_key: string; _defaultValue: boolean): boolean;

    procedure SetIntData(_key: string; _value: integer);
    procedure SetLongData(_key: string; _value: int64);
    procedure SetFloatData(_key: string; _value: single);
    procedure SetStringData(_key: string; _value: string);
    procedure SetBoolData(_key: string; _value: boolean);

 published
    property IsShared: boolean read FIsShared write FIsShared;

end;

function jPreferences_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _IsShared: boolean): jObject;


implementation

{---------  jPreferences  --------------}

constructor jPreferences.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FIsShared:= False; //preferences is App Private!
end;

destructor jPreferences.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
        if FjObject  <> nil then
        begin
           jni_free(gApp.jni.jEnv, FjObject);
           FjObject := nil;
        end;
  end;
  //you others free code here...
  inherited Destroy;
end;

procedure jPreferences.Init;
begin
  if FInitialized  then Exit;
  inherited Init;
  //your code here: set/initialize create params....
  FjObject := jPreferences_jCreate(gApp.jni.jEnv, gApp.jni.jThis , int64(Self), FIsShared);

  if FjObject = nil then exit;
  
  FInitialized:= True;
end;

function jPreferences.GetIntData(_key: string; _defaultValue: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_ti_out_i(gApp.jni.jEnv, FjObject, 'GetIntData', _key ,_defaultValue);
end;

procedure jPreferences.SetIntData(_key: string; _value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ti(gApp.jni.jEnv, FjObject, 'SetIntData', _key ,_value);
end;

function jPreferences.GetStringData(_key: string; _defaultValue: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result := jni_func_tt_out_t(gApp.jni.jEnv, FjObject, 'GetStringData', _key ,_defaultValue);
end;

procedure jPreferences.SetStringData(_key: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
   jni_proc_tt(gApp.jni.jEnv, FjObject, 'SetStringData', _key ,_value);
end;

function jPreferences.GetBoolData(_key: string; _defaultValue: boolean): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tz_out_z(gApp.jni.jEnv, FjObject, 'GetBoolData', _key ,_defaultValue);
end;

procedure jPreferences.SetBoolData(_key: string; _value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
   jni_proc_tz(gApp.jni.jEnv, FjObject, 'SetBoolData', _key ,_value);
end;

function jPreferences.GetLongData(_key: string; _defaultValue: int64): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tj_out_j(gApp.jni.jEnv, FjObject, 'GetLongData', _key ,_defaultValue);
end;

procedure jPreferences.SetLongData(_key: string; _value: int64);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tj(gApp.jni.jEnv, FjObject, 'SetLongData', _key ,_value);
end;

function jPreferences.GetFloatData(_key: string; _defaultValue: single): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tf_out_f(gApp.jni.jEnv, FjObject, 'GetFloatData', _key ,_defaultValue);
end;

procedure jPreferences.SetFloatData(_key: string; _value: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_tf(gApp.jni.jEnv, FjObject, 'SetFloatData', _key ,_value);
end;

procedure jPreferences.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'Clear');
end;

procedure jPreferences.Remove(_key: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(gApp.jni.jEnv, FjObject, 'Remove', _key);
end;

{-------- jPreferences_JNI_Bridge ----------}

function jPreferences_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _IsShared: boolean): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jPreferences_jCreate', '(JZ)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;
  jParams[1].z:= JBool(_IsShared);

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;

end.
