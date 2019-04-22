unit mikrotikrouteros;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [4/16/2019 19:36:17]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jMikrotikRouterOS = class(jControl)
 private
    FUsername: string;
    FPassword: string;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetUsername(_Username: string);
    procedure SetPassword(_password: string);
    function Connect(_host: string): boolean; overload;
    function Connect(_host: string; _port: integer; _timeout: integer): boolean; overload;
    function IsConnected(): boolean;
    function Execute(_cmd: string): boolean;
    function ExecuteForResult(_cmd: string): TDynArrayOfString;

    procedure Disconnect();

    property Username: string read FUsername write SetUsername;
    property Password: string read FPassword write SetPassword;

 published

end;

function jMikrotikRouterOS_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jMikrotikRouterOS_jFree(env: PJNIEnv; _jmikrotikrouteros: JObject);
procedure jMikrotikRouterOS_SetUsername(env: PJNIEnv; _jmikrotikrouteros: JObject; _Username: string);
procedure jMikrotikRouterOS_SetPassword(env: PJNIEnv; _jmikrotikrouteros: JObject; _password: string);
 function jMikrotikRouterOS_Connect(env: PJNIEnv; _jmikrotikrouteros: JObject; _host: string): boolean; overload;
function jMikrotikRouterOS_Execute(env: PJNIEnv; _jmikrotikrouteros: JObject; _cmd: string): boolean;
procedure jMikrotikRouterOS_Disconnect(env: PJNIEnv; _jmikrotikrouteros: JObject);
function jMikrotikRouterOS_ExecuteForResult(env: PJNIEnv; _jmikrotikrouteros: JObject; _cmd: string): TDynArrayOfString;
function jMikrotikRouterOS_IsConnected(env: PJNIEnv; _jmikrotikrouteros: JObject): boolean;
function jMikrotikRouterOS_Connect(env: PJNIEnv; _jmikrotikrouteros: JObject; _host: string; _port: integer; _timeout: integer): boolean; overload;


implementation

{---------  jMikrotikRouterOS  --------------}

constructor jMikrotikRouterOS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jMikrotikRouterOS.Destroy;
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

procedure jMikrotikRouterOS.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jMikrotikRouterOS.jCreate(): jObject;
begin
   Result:= jMikrotikRouterOS_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jMikrotikRouterOS.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMikrotikRouterOS_jFree(FjEnv, FjObject);
end;

procedure jMikrotikRouterOS.SetUsername(_Username: string);
begin
  //in designing component state: set value here...
  FUsername:= _Username;
  if FInitialized then
     jMikrotikRouterOS_SetUsername(FjEnv, FjObject, _Username);
end;

procedure jMikrotikRouterOS.SetPassword(_password: string);
begin
  //in designing component state: set value here...
  FPassword:= _password;
  if FInitialized then
     jMikrotikRouterOS_SetPassword(FjEnv, FjObject, _password);
end;

function jMikrotikRouterOS.Connect(_host: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMikrotikRouterOS_Connect(FjEnv, FjObject, _host);
end;

function jMikrotikRouterOS.Execute(_cmd: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMikrotikRouterOS_Execute(FjEnv, FjObject, _cmd);
end;

procedure jMikrotikRouterOS.Disconnect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMikrotikRouterOS_Disconnect(FjEnv, FjObject);
end;

function jMikrotikRouterOS.ExecuteForResult(_cmd: string): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMikrotikRouterOS_ExecuteForResult(FjEnv, FjObject, _cmd);
end;

function jMikrotikRouterOS.IsConnected(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMikrotikRouterOS_IsConnected(FjEnv, FjObject);
end;

function jMikrotikRouterOS.Connect(_host: string; _port: integer; _timeout: integer): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMikrotikRouterOS_Connect(FjEnv, FjObject, _host ,_port ,_timeout);
end;

{-------- jMikrotikRouterOS_JNI_Bridge ----------}

function jMikrotikRouterOS_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMikrotikRouterOS_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jMikrotikRouterOS_jFree(env: PJNIEnv; _jmikrotikrouteros: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmikrotikrouteros, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMikrotikRouterOS_SetUsername(env: PJNIEnv; _jmikrotikrouteros: JObject; _Username: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_Username));
  jCls:= env^.GetObjectClass(env, _jmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUsername', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmikrotikrouteros, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMikrotikRouterOS_SetPassword(env: PJNIEnv; _jmikrotikrouteros: JObject; _password: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPassword', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmikrotikrouteros, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jMikrotikRouterOS_Connect(env: PJNIEnv; _jmikrotikrouteros: JObject; _host: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_host));
  jCls:= env^.GetObjectClass(env, _jmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jmikrotikrouteros, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jMikrotikRouterOS_Execute(env: PJNIEnv; _jmikrotikrouteros: JObject; _cmd: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_cmd));
  jCls:= env^.GetObjectClass(env, _jmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'Execute', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jmikrotikrouteros, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMikrotikRouterOS_Disconnect(env: PJNIEnv; _jmikrotikrouteros: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'Disconnect', '()V');
  env^.CallVoidMethod(env, _jmikrotikrouteros, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jMikrotikRouterOS_ExecuteForResult(env: PJNIEnv; _jmikrotikrouteros: JObject; _cmd: string): TDynArrayOfString;
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
  jParams[0].l:= env^.NewStringUTF(env, PChar(_cmd));
  jCls:= env^.GetObjectClass(env, _jmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'ExecuteForResult', '(Ljava/lang/String;)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jmikrotikrouteros, jMethod,  @jParams);
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
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jMikrotikRouterOS_IsConnected(env: PJNIEnv; _jmikrotikrouteros: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'IsConnected', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jmikrotikrouteros, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jMikrotikRouterOS_Connect(env: PJNIEnv; _jmikrotikrouteros: JObject; _host: string; _port: integer; _timeout: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_host));
  jParams[1].i:= _port;
  jParams[2].i:= _timeout;
  jCls:= env^.GetObjectClass(env, _jmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;II)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jmikrotikrouteros, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
