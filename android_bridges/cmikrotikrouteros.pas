unit cmikrotikrouteros;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TOnAsyncReceive = procedure(Sender: TObject; delimitedContent: string; delimiter: String) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [4/21/2019 2:28:33]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jcMikrotikRouterOS = class(jControl)
 private
    FUsername: string;
    FPassword: string;
    FOnAsyncReceive: TOnAsyncReceive;

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
    function Login(): boolean;  overload;
    function Login(_username: string; _password: string): boolean;  overload;
    function IsLogged(): boolean;
    procedure Disconnect();
    function Execute(_cmd: string): boolean;
    function ExecuteForResult(_cmd: string): TDynArrayOfString;
    function ExecuteAsync(_cmd: string): boolean;

    procedure GenEvent_OnMikrotikAsyncReceive(Obj: TObject; delimitedContent: string; delimiter: string);

    property Username: string read FUsername write SetUsername;
    property Password: string read FPassword write SetPassword;

 published
    property OnAsyncReceive: TOnAsyncReceive read FOnAsyncReceive write FOnAsyncReceive;

end;

function jcMikrotikRouterOS_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jcMikrotikRouterOS_jFree(env: PJNIEnv; _jcmikrotikrouteros: JObject);
procedure jcMikrotikRouterOS_SetUsername(env: PJNIEnv; _jcmikrotikrouteros: JObject; _Username: string);
procedure jcMikrotikRouterOS_SetPassword(env: PJNIEnv; _jcmikrotikrouteros: JObject; _password: string);
function jcMikrotikRouterOS_Connect(env: PJNIEnv; _jcmikrotikrouteros: JObject; _host: string): boolean; overload;
function jcMikrotikRouterOS_IsConnected(env: PJNIEnv; _jcmikrotikrouteros: JObject): boolean;
function jcMikrotikRouterOS_Connect(env: PJNIEnv; _jcmikrotikrouteros: JObject; _host: string; _port: integer; _timeout: integer): boolean; overload;
function jcMikrotikRouterOS_Login(env: PJNIEnv; _jcmikrotikrouteros: JObject): boolean;  overload;
function jcMikrotikRouterOS_Login(env: PJNIEnv; _jcmikrotikrouteros: JObject; _username: string; _password: string): boolean; overload;
function jcMikrotikRouterOS_IsLogged(env: PJNIEnv; _jcmikrotikrouteros: JObject): boolean;
procedure jcMikrotikRouterOS_Disconnect(env: PJNIEnv; _jcmikrotikrouteros: JObject);
function jcMikrotikRouterOS_Execute(env: PJNIEnv; _jcmikrotikrouteros: JObject; _cmd: string): boolean;
function jcMikrotikRouterOS_ExecuteForResult(env: PJNIEnv; _jcmikrotikrouteros: JObject; _cmd: string): TDynArrayOfString;
function jcMikrotikRouterOS_ExecuteAsync(env: PJNIEnv; _jcmikrotikrouteros: JObject; _cmd: string): boolean;


implementation

{---------  jcMikrotikRouterOS  --------------}

constructor jcMikrotikRouterOS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jcMikrotikRouterOS.Destroy;
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

procedure jcMikrotikRouterOS.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;


function jcMikrotikRouterOS.jCreate(): jObject;
begin
   Result:= jcMikrotikRouterOS_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jcMikrotikRouterOS.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcMikrotikRouterOS_jFree(FjEnv, FjObject);
end;

procedure jcMikrotikRouterOS.SetUsername(_Username: string);
begin
  //in designing component state: set value here...
  FUsername:= _Username;
  if FInitialized then
     jcMikrotikRouterOS_SetUsername(FjEnv, FjObject, _Username);
end;

procedure jcMikrotikRouterOS.SetPassword(_password: string);
begin
  //in designing component state: set value here...
  FPassword:= _password;
  if FInitialized then
     jcMikrotikRouterOS_SetPassword(FjEnv, FjObject, _password);
end;

function jcMikrotikRouterOS.Connect(_host: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMikrotikRouterOS_Connect(FjEnv, FjObject, _host);
end;

function jcMikrotikRouterOS.IsConnected(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMikrotikRouterOS_IsConnected(FjEnv, FjObject);
end;

function jcMikrotikRouterOS.Connect(_host: string; _port: integer; _timeout: integer): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMikrotikRouterOS_Connect(FjEnv, FjObject, _host ,_port ,_timeout);
end;

function jcMikrotikRouterOS.Login(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMikrotikRouterOS_Login(FjEnv, FjObject);
end;

function jcMikrotikRouterOS.Login(_username: string; _password: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMikrotikRouterOS_Login(FjEnv, FjObject, _username ,_password);
end;

function jcMikrotikRouterOS.IsLogged(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMikrotikRouterOS_IsLogged(FjEnv, FjObject);
end;

procedure jcMikrotikRouterOS.Disconnect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcMikrotikRouterOS_Disconnect(FjEnv, FjObject);
end;

function jcMikrotikRouterOS.Execute(_cmd: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMikrotikRouterOS_Execute(FjEnv, FjObject, _cmd);
end;

function jcMikrotikRouterOS.ExecuteForResult(_cmd: string): TDynArrayOfString;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMikrotikRouterOS_ExecuteForResult(FjEnv, FjObject, _cmd);
end;

function jcMikrotikRouterOS.ExecuteAsync(_cmd: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMikrotikRouterOS_ExecuteAsync(FjEnv, FjObject, _cmd);
end;

procedure jcMikrotikRouterOS.GenEvent_OnMikrotikAsyncReceive(Obj: TObject; delimitedContent: string; delimiter: string);
begin
  if Assigned(FOnAsyncReceive) then FOnAsyncReceive(Obj, delimitedContent, delimiter);
end;

{-------- jcMikrotikRouterOS_JNI_Bridge ----------}

function jcMikrotikRouterOS_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jcMikrotikRouterOS_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jcMikrotikRouterOS_jFree(env: PJNIEnv; _jcmikrotikrouteros: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcmikrotikrouteros, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcMikrotikRouterOS_SetUsername(env: PJNIEnv; _jcmikrotikrouteros: JObject; _Username: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_Username));
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUsername', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcmikrotikrouteros, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcMikrotikRouterOS_SetPassword(env: PJNIEnv; _jcmikrotikrouteros: JObject; _password: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPassword', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcmikrotikrouteros, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcMikrotikRouterOS_Connect(env: PJNIEnv; _jcmikrotikrouteros: JObject; _host: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_host));
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jcmikrotikrouteros, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcMikrotikRouterOS_IsConnected(env: PJNIEnv; _jcmikrotikrouteros: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'IsConnected', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jcmikrotikrouteros, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jcMikrotikRouterOS_Connect(env: PJNIEnv; _jcmikrotikrouteros: JObject; _host: string; _port: integer; _timeout: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_host));
  jParams[1].i:= _port;
  jParams[2].i:= _timeout;
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '(Ljava/lang/String;II)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jcmikrotikrouteros, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcMikrotikRouterOS_Login(env: PJNIEnv; _jcmikrotikrouteros: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'Login', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jcmikrotikrouteros, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jcMikrotikRouterOS_Login(env: PJNIEnv; _jcmikrotikrouteros: JObject; _username: string; _password: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_username));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'Login', '(Ljava/lang/String;Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jcmikrotikrouteros, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcMikrotikRouterOS_IsLogged(env: PJNIEnv; _jcmikrotikrouteros: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'IsLogged', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jcmikrotikrouteros, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcMikrotikRouterOS_Disconnect(env: PJNIEnv; _jcmikrotikrouteros: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'Disconnect', '()V');
  env^.CallVoidMethod(env, _jcmikrotikrouteros, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcMikrotikRouterOS_Execute(env: PJNIEnv; _jcmikrotikrouteros: JObject; _cmd: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_cmd));
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'Execute', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jcmikrotikrouteros, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcMikrotikRouterOS_ExecuteForResult(env: PJNIEnv; _jcmikrotikrouteros: JObject; _cmd: string): TDynArrayOfString;
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
  Result := nil;
  jParams[0].l:= env^.NewStringUTF(env, PChar(_cmd));
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'ExecuteForResult', '(Ljava/lang/String;)[Ljava/lang/String;');
  jResultArray:= env^.CallObjectMethodA(env, _jcmikrotikrouteros, jMethod,  @jParams);
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


function jcMikrotikRouterOS_ExecuteAsync(env: PJNIEnv; _jcmikrotikrouteros: JObject; _cmd: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_cmd));
  jCls:= env^.GetObjectClass(env, _jcmikrotikrouteros);
  jMethod:= env^.GetMethodID(env, jCls, 'ExecuteAsync', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jcmikrotikrouteros, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
