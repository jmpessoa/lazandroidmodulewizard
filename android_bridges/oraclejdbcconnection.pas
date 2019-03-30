unit oraclejdbcconnection;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [3/29/2019 22:52:11]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jOracleJDBCConnection = class(jControl)
 private
    FDrive: string;
    FUrl: string;
    FUserName: string;
    FPassword: string;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    function Open(): boolean;
    function ExecuteQuery(_sqlQuery: string): string;
    function ExecuteUpdate(_sqlExecute: string): boolean;
    procedure Close();
    procedure SetDrive(_drive: string);
    procedure SetUrl(_url: string);
    procedure SetUserName(_username: string);
    procedure SetPassword(_password: string);

    property Drive: string read FDrive write SetDrive;
    property Url: string read FUrl write SetUrl;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;

 published

end;

function jOracleJDBCConnection_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jOracleJDBCConnection_jFree(env: PJNIEnv; _joraclejdbcconnection: JObject);
function jOracleJDBCConnection_Open(env: PJNIEnv; _joraclejdbcconnection: JObject): boolean;
function jOracleJDBCConnection_ExecuteQuery(env: PJNIEnv; _joraclejdbcconnection: JObject; _sqlQuery: string): string;
function jOracleJDBCConnection_ExecuteUpdate(env: PJNIEnv; _joraclejdbcconnection: JObject; _sqlExecute: string): boolean;
procedure jOracleJDBCConnection_Close(env: PJNIEnv; _joraclejdbcconnection: JObject);
procedure jOracleJDBCConnection_SetDrive(env: PJNIEnv; _joraclejdbcconnection: JObject; _drive: string);
procedure jOracleJDBCConnection_SetUrl(env: PJNIEnv; _joraclejdbcconnection: JObject; _url: string);
procedure jOracleJDBCConnection_SetUserName(env: PJNIEnv; _joraclejdbcconnection: JObject; _username: string);
procedure jOracleJDBCConnection_SetPassword(env: PJNIEnv; _joraclejdbcconnection: JObject; _password: string);


implementation

{---------  jOracleJDBCConnection  --------------}

constructor jOracleJDBCConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jOracleJDBCConnection.Destroy;
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

procedure jOracleJDBCConnection.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;


function jOracleJDBCConnection.jCreate(): jObject;
begin
   Result:= jOracleJDBCConnection_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jOracleJDBCConnection.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jOracleJDBCConnection_jFree(FjEnv, FjObject);
end;

function jOracleJDBCConnection.Open(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jOracleJDBCConnection_Open(FjEnv, FjObject);
end;

function jOracleJDBCConnection.ExecuteQuery(_sqlQuery: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jOracleJDBCConnection_ExecuteQuery(FjEnv, FjObject, _sqlQuery);
end;

function jOracleJDBCConnection.ExecuteUpdate(_sqlExecute: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jOracleJDBCConnection_ExecuteUpdate(FjEnv, FjObject, _sqlExecute);
end;

procedure jOracleJDBCConnection.Close();
begin
  //in designing component state: set value here...
  if FInitialized then
     jOracleJDBCConnection_Close(FjEnv, FjObject);
end;

procedure jOracleJDBCConnection.SetDrive(_drive: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jOracleJDBCConnection_SetDrive(FjEnv, FjObject, _drive);
end;

procedure jOracleJDBCConnection.SetUrl(_url: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jOracleJDBCConnection_SetUrl(FjEnv, FjObject, _url);
end;

procedure jOracleJDBCConnection.SetUserName(_username: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jOracleJDBCConnection_SetUserName(FjEnv, FjObject, _username);
end;

procedure jOracleJDBCConnection.SetPassword(_password: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jOracleJDBCConnection_SetPassword(FjEnv, FjObject, _password);
end;


{-------- jOracleJDBCConnection_JNI_Bridge ----------}

function jOracleJDBCConnection_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jOracleJDBCConnection_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jOracleJDBCConnection_jFree(env: PJNIEnv; _joraclejdbcconnection: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _joraclejdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _joraclejdbcconnection, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jOracleJDBCConnection_Open(env: PJNIEnv; _joraclejdbcconnection: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _joraclejdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'Open', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _joraclejdbcconnection, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jOracleJDBCConnection_ExecuteQuery(env: PJNIEnv; _joraclejdbcconnection: JObject; _sqlQuery: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sqlQuery));
  jCls:= env^.GetObjectClass(env, _joraclejdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'ExecuteQuery', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _joraclejdbcconnection, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jOracleJDBCConnection_ExecuteUpdate(env: PJNIEnv; _joraclejdbcconnection: JObject; _sqlExecute: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sqlExecute));
  jCls:= env^.GetObjectClass(env, _joraclejdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'ExecuteUpdate', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _joraclejdbcconnection, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jOracleJDBCConnection_Close(env: PJNIEnv; _joraclejdbcconnection: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _joraclejdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'Close', '()V');
  env^.CallVoidMethod(env, _joraclejdbcconnection, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jOracleJDBCConnection_SetDrive(env: PJNIEnv; _joraclejdbcconnection: JObject; _drive: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_drive));
  jCls:= env^.GetObjectClass(env, _joraclejdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDrive', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _joraclejdbcconnection, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jOracleJDBCConnection_SetUrl(env: PJNIEnv; _joraclejdbcconnection: JObject; _url: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_url));
  jCls:= env^.GetObjectClass(env, _joraclejdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUrl', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _joraclejdbcconnection, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jOracleJDBCConnection_SetUserName(env: PJNIEnv; _joraclejdbcconnection: JObject; _username: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_username));
  jCls:= env^.GetObjectClass(env, _joraclejdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUserName', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _joraclejdbcconnection, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jOracleJDBCConnection_SetPassword(env: PJNIEnv; _joraclejdbcconnection: JObject; _password: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _joraclejdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPassword', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _joraclejdbcconnection, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
