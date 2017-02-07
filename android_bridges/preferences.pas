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
    procedure Init(refApp: jApp); override;
    function jCreate( _IsShared: boolean): jObject;
    procedure jFree();
    function GetIntData(_key: string; _defaultValue: integer): integer;
    procedure SetIntData(_key: string; _value: integer);
    function GetStringData(_key: string; _defaultValue: string): string;
    procedure SetStringData(_key: string; _value: string);
    function GetBoolData(_key: string; _defaultValue: boolean): boolean;
    procedure SetBoolData(_key: string; _value: boolean);

 published
    property IsShared: boolean read FIsShared write FIsShared;

end;

function jPreferences_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _IsShared: boolean): jObject;
procedure jPreferences_jFree(env: PJNIEnv; _jPreferences: JObject);
function jPreferences_GetIntData(env: PJNIEnv; _jPreferences: JObject; _key: string; _defaultValue: integer): integer;
procedure jPreferences_SetIntData(env: PJNIEnv; _jPreferences: JObject; _key: string; _value: integer);
function jPreferences_GetStringData(env: PJNIEnv; _jPreferences: JObject; _key: string; _defaultValue: string): string;
procedure jPreferences_SetStringData(env: PJNIEnv; _jPreferences: JObject; _key: string; _value: string);
function jPreferences_GetBoolData(env: PJNIEnv; _jPreferences: JObject; _key: string; _defaultValue: boolean): boolean;
procedure jPreferences_SetBoolData(env: PJNIEnv; _jPreferences: JObject; _key: string; _value: boolean);


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
           jFree();
           FjObject := nil;
        end;
  end;
  //you others free code here...
  inherited Destroy;
end;

procedure jPreferences.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject := jCreate(FIsShared);
  FInitialized:= True;
end;


function jPreferences.jCreate( _IsShared: boolean): jObject;
begin
   Result:= jPreferences_jCreate(FjEnv, FjThis , int64(Self) ,_IsShared);
end;

procedure jPreferences.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jPreferences_jFree(FjEnv, FjObject );
end;

function jPreferences.GetIntData(_key: string; _defaultValue: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jPreferences_GetIntData(FjEnv, FjObject , _key ,_defaultValue);
end;

procedure jPreferences.SetIntData(_key: string; _value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jPreferences_SetIntData(FjEnv, FjObject , _key ,_value);
end;

function jPreferences.GetStringData(_key: string; _defaultValue: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jPreferences_GetStringData(FjEnv, FjObject , _key ,_defaultValue);
end;

procedure jPreferences.SetStringData(_key: string; _value: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jPreferences_SetStringData(FjEnv, FjObject , _key ,_value);
end;

function jPreferences.GetBoolData(_key: string; _defaultValue: boolean): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jPreferences_GetBoolData(FjEnv, FjObject , _key ,_defaultValue);
end;

procedure jPreferences.SetBoolData(_key: string; _value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jPreferences_SetBoolData(FjEnv, FjObject , _key ,_value);
end;

{-------- jPreferences_JNI_Bridge ----------}

function jPreferences_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _IsShared: boolean): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].z:= JBool(_IsShared);
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jPreferences_jCreate', '(JZ)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jPreferences_jCreate(long _Self, boolean _IsShared) {
      return (java.lang.Object)(new jPreferences(this,_Self,_IsShared));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jPreferences_jFree(env: PJNIEnv; _jPreferences: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jPreferences);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jPreferences, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jPreferences_GetIntData(env: PJNIEnv; _jPreferences: JObject; _key: string; _defaultValue: integer): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_key));
  jParams[1].i:= _defaultValue;
  jCls:= env^.GetObjectClass(env, _jPreferences);
  jMethod:= env^.GetMethodID(env, jCls, 'GetIntData', '(Ljava/lang/String;I)I');
  Result:= env^.CallIntMethodA(env, _jPreferences, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jPreferences_SetIntData(env: PJNIEnv; _jPreferences: JObject; _key: string; _value: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_key));
  jParams[1].i:= _value;
  jCls:= env^.GetObjectClass(env, _jPreferences);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIntData', '(Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jPreferences, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jPreferences_GetStringData(env: PJNIEnv; _jPreferences: JObject; _key: string; _defaultValue: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_key));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_defaultValue));
  jCls:= env^.GetObjectClass(env, _jPreferences);
  jMethod:= env^.GetMethodID(env, jCls, 'GetStringData', '(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jPreferences, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jPreferences_SetStringData(env: PJNIEnv; _jPreferences: JObject; _key: string; _value: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_key));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_value));
  jCls:= env^.GetObjectClass(env, _jPreferences);
  jMethod:= env^.GetMethodID(env, jCls, 'SetStringData', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jPreferences, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jPreferences_GetBoolData(env: PJNIEnv; _jPreferences: JObject; _key: string; _defaultValue: boolean): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_key));
  jParams[1].z:= JBool(_defaultValue);
  jCls:= env^.GetObjectClass(env, _jPreferences);
  jMethod:= env^.GetMethodID(env, jCls, 'GetBoolData', '(Ljava/lang/String;Z)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jPreferences, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jPreferences_SetBoolData(env: PJNIEnv; _jPreferences: JObject; _key: string; _value: boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_key));
  jParams[1].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jPreferences);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBoolData', '(Ljava/lang/String;Z)V');
  env^.CallVoidMethodA(env, _jPreferences, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;



end.
