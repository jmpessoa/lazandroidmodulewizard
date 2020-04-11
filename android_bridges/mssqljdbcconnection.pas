unit mssqljdbcconnection;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TOnMsSqlJDBCConnectionExecuteQueryAsync=procedure(Sender:TObject;messageStatus:string) of object;
TOnMsSqlJDBCConnectionOpenAsync=procedure(Sender:TObject;messageStatus:string) of object;
TOnMsSqlJDBCConnectionExecuteUpdateAsync=procedure(Sender:TObject;messageStatus:string) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [8/18/2019 14:55:06]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jMsSqlJDBCConnection = class(jControl)
 private
    FServerIP: string;
    FDatabaseName: string;
    FUserName: string;
    FPassword: string;
    FLanguage: TSpeechLanguage;

    FOnExecuteQueryAsync: TOnMsSqlJDBCConnectionExecuteQueryAsync;
    FOnOpenAsync: TOnMsSqlJDBCConnectionOpenAsync;
    FOnExecuteUpdateAsync: TOnMsSqlJDBCConnectionExecuteUpdateAsync;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    function Open(): boolean;
    function ExecuteQuery(_sqlQuery: string): string;
    function ExecuteUpdate(_sqlExecute: string): boolean;
    procedure SetServerIP(_ip: string);
    procedure SetUserName(_username: string);
    procedure SetPassword(_password: string);
    procedure SetDatabaseName(_databaseName: string);
    procedure Close();
    procedure SetLanguage(_language: TSpeechLanguage);

    procedure ExecuteQueryAsync(_sqlQuery: string);
    procedure OpenAsync();
    procedure ExecuteUpdateAsync(_sqlUpdate: string);

    procedure GenEvent_OnMsSqlJDBCConnectionExecuteQueryAsync(Sender:TObject;messageStatus:string);
    procedure GenEvent_OnMsSqlJDBCConnectionOpenAsync(Sender:TObject;messageStatus:string);
    procedure GenEvent_OnMsSqlJDBCConnectionExecuteUpdateAsync(Sender:TObject;messageStatus:string);

 published
    property ServerIP: string read FServerIP write SetServerIP;
    property DatabaseName: string  read FDatabaseName write SetDatabaseName;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property Language: TSpeechLanguage read FLanguage write SetLanguage;

    property OnExecuteQueryAsync: TOnMsSqlJDBCConnectionExecuteQueryAsync read FOnExecuteQueryAsync write FOnExecuteQueryAsync;
    property OnOpenAsync: TOnMsSqlJDBCConnectionOpenAsync read FOnOpenAsync write FOnOpenAsync;
    property OnExecuteUpdateAsync: TOnMsSqlJDBCConnectionExecuteUpdateAsync read FOnExecuteUpdateAsync write FOnExecuteUpdateAsync;

end;

function jMsSqlJDBCConnection_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jMsSqlJDBCConnection_jFree(env: PJNIEnv; _jmssqljdbcconnection: JObject);

function jMsSqlJDBCConnection_Open(env: PJNIEnv; _jmssqljdbcconnection: JObject): boolean;
function jMsSqlJDBCConnection_ExecuteQuery(env: PJNIEnv; _jmssqljdbcconnection: JObject; _sqlQuery: string): string;
function jMsSqlJDBCConnection_ExecuteUpdate(env: PJNIEnv; _jmssqljdbcconnection: JObject; _sqlExecute: string): boolean;
procedure jMsSqlJDBCConnection_SetServerIP(env: PJNIEnv; _jmssqljdbcconnection: JObject; _ip: string);
procedure jMsSqlJDBCConnection_SetUserName(env: PJNIEnv; _jmssqljdbcconnection: JObject; _username: string);
procedure jMsSqlJDBCConnection_SetPassword(env: PJNIEnv; _jmssqljdbcconnection: JObject; _password: string);
procedure jMsSqlJDBCConnection_SetDatabaseName(env: PJNIEnv; _jmssqljdbcconnection: JObject; _db: string);
procedure jMsSqlJDBCConnection_Close(env: PJNIEnv; _jmssqljdbcconnection: JObject);
procedure jMsSqlJDBCConnection_SetLanguage(env: PJNIEnv; _jmssqljdbcconnection: JObject; _language: integer);

procedure jMsSqlJDBCConnection_ExecuteQueryAsync(env: PJNIEnv; _jmssqljdbcconnection: JObject; _sqlQuery: string);
procedure jMsSqlJDBCConnection_OpenAsync(env: PJNIEnv; _jmssqljdbcconnection: JObject);
procedure jMsSqlJDBCConnection_ExecuteUpdateAsync(env: PJNIEnv; _jmssqljdbcconnection: JObject; _sqlUpdate: string);

implementation

{---------  jMsSqlJDBCConnection  --------------}

constructor jMsSqlJDBCConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
  FLanguage:= slEnglish;
end;

destructor jMsSqlJDBCConnection.Destroy;
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

procedure jMsSqlJDBCConnection.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;

  if FServerIP <> '' then
    jMsSqlJDBCConnection_SetServerIP(FjEnv, FjObject, FServerIP);

  if FUserName <> '' then
    jMsSqlJDBCConnection_SetUserName(FjEnv, FjObject, FUserName);

  if FPassword <> '' then
    jMsSqlJDBCConnection_SetPassword(FjEnv, FjObject, FPassword);

  if FDatabaseName <> '' then
    jMsSqlJDBCConnection_SetDatabaseName(FjEnv, FjObject, FDatabaseName);

  if FLanguage <> slEnglish then
     jMsSqlJDBCConnection_SetLanguage(FjEnv, FjObject, Ord(FLanguage));

  FInitialized:= True;
end;


function jMsSqlJDBCConnection.jCreate(): jObject;
begin
   Result:= jMsSqlJDBCConnection_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jMsSqlJDBCConnection.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMsSqlJDBCConnection_jFree(FjEnv, FjObject);
end;

function jMsSqlJDBCConnection.Open(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMsSqlJDBCConnection_Open(FjEnv, FjObject);
end;

function jMsSqlJDBCConnection.ExecuteQuery(_sqlQuery: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMsSqlJDBCConnection_ExecuteQuery(FjEnv, FjObject, _sqlQuery);
end;

function jMsSqlJDBCConnection.ExecuteUpdate(_sqlExecute: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMsSqlJDBCConnection_ExecuteUpdate(FjEnv, FjObject, _sqlExecute);
end;

procedure jMsSqlJDBCConnection.SetServerIP(_ip: string);
begin
  //in designing component state: set value here...
  FServerIP:= _ip;
  if FInitialized then
     jMsSqlJDBCConnection_SetServerIP(FjEnv, FjObject, _ip);
end;

procedure jMsSqlJDBCConnection.SetUserName(_username: string);
begin
  //in designing component state: set value here...
  FUserName:= _username;
  if FInitialized then
     jMsSqlJDBCConnection_SetUserName(FjEnv, FjObject, _username);
end;

procedure jMsSqlJDBCConnection.SetPassword(_password: string);
begin
  //in designing component state: set value here...
  FPassword:=_password;
  if FInitialized then
     jMsSqlJDBCConnection_SetPassword(FjEnv, FjObject, _password);
end;

procedure jMsSqlJDBCConnection.SetDatabaseName(_databaseName: string);
begin
  //in designing component state: set value here...
  FDatabaseName:= _databaseName;
  if FInitialized then
     jMsSqlJDBCConnection_SetDatabaseName(FjEnv, FjObject, _databaseName);
end;

procedure jMsSqlJDBCConnection.Close();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMsSqlJDBCConnection_Close(FjEnv, FjObject);
end;

procedure jMsSqlJDBCConnection.SetLanguage(_language: TSpeechLanguage);
begin
  //in designing component state: set value here...
  FLanguage:= _language;
  if FInitialized then
     jMsSqlJDBCConnection_SetLanguage(FjEnv, FjObject, Ord(_language));
end;

procedure jMsSqlJDBCConnection.ExecuteQueryAsync(_sqlQuery: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMsSqlJDBCConnection_ExecuteQueryAsync(FjEnv, FjObject, _sqlQuery);
end;

procedure jMsSqlJDBCConnection.OpenAsync();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMsSqlJDBCConnection_OpenAsync(FjEnv, FjObject);
end;

procedure jMsSqlJDBCConnection.ExecuteUpdateAsync(_sqlUpdate: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMsSqlJDBCConnection_ExecuteUpdateAsync(FjEnv, FjObject, _sqlUpdate);
end;

procedure jMsSqlJDBCConnection.GenEvent_OnMsSqlJDBCConnectionExecuteQueryAsync(Sender:TObject;messageStatus:string);
begin
  if Assigned(FOnExecuteQueryAsync) then FOnExecuteQueryAsync(Sender,messageStatus);
end;

procedure jMsSqlJDBCConnection.GenEvent_OnMsSqlJDBCConnectionOpenAsync(Sender:TObject;messageStatus:string);
begin
  if Assigned(FOnOpenAsync) then FOnOpenAsync(Sender,messageStatus);
end;

procedure jMsSqlJDBCConnection.GenEvent_OnMsSqlJDBCConnectionExecuteUpdateAsync(Sender:TObject;messageStatus:string);
begin
  if Assigned(FOnExecuteUpdateAsync) then FOnExecuteUpdateAsync(Sender,messageStatus);
end;

{-------- jMsSqlJDBCConnection_JNI_Bridge ----------}

function jMsSqlJDBCConnection_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMsSqlJDBCConnection_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jMsSqlJDBCConnection_jFree(env: PJNIEnv; _jmssqljdbcconnection: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmssqljdbcconnection, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jMsSqlJDBCConnection_Open(env: PJNIEnv; _jmssqljdbcconnection: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'Open', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jmssqljdbcconnection, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


function jMsSqlJDBCConnection_ExecuteQuery(env: PJNIEnv; _jmssqljdbcconnection: JObject; _sqlQuery: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sqlQuery));
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'ExecuteQuery', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jmssqljdbcconnection, jMethod, @jParams);
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


function jMsSqlJDBCConnection_ExecuteUpdate(env: PJNIEnv; _jmssqljdbcconnection: JObject; _sqlExecute: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sqlExecute));
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'ExecuteUpdate', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jmssqljdbcconnection, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMsSqlJDBCConnection_SetServerIP(env: PJNIEnv; _jmssqljdbcconnection: JObject; _ip: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_ip));
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'SetServerIP', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmssqljdbcconnection, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMsSqlJDBCConnection_SetUserName(env: PJNIEnv; _jmssqljdbcconnection: JObject; _username: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_username));
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUserName', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmssqljdbcconnection, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMsSqlJDBCConnection_SetPassword(env: PJNIEnv; _jmssqljdbcconnection: JObject; _password: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPassword', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmssqljdbcconnection, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMsSqlJDBCConnection_SetDatabaseName(env: PJNIEnv; _jmssqljdbcconnection: JObject; _db: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_db));
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDatabaseName', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmssqljdbcconnection, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMsSqlJDBCConnection_Close(env: PJNIEnv; _jmssqljdbcconnection: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'Close', '()V');
  env^.CallVoidMethod(env, _jmssqljdbcconnection, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMsSqlJDBCConnection_SetLanguage(env: PJNIEnv; _jmssqljdbcconnection: JObject; _language: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _language;
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLanguage', '(I)V');
  env^.CallVoidMethodA(env, _jmssqljdbcconnection, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMsSqlJDBCConnection_ExecuteQueryAsync(env: PJNIEnv; _jmssqljdbcconnection: JObject; _sqlQuery: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sqlQuery));
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'ExecuteQueryAsync', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmssqljdbcconnection, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMsSqlJDBCConnection_OpenAsync(env: PJNIEnv; _jmssqljdbcconnection: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'OpenAsync', '()V');
  env^.CallVoidMethod(env, _jmssqljdbcconnection, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMsSqlJDBCConnection_ExecuteUpdateAsync(env: PJNIEnv; _jmssqljdbcconnection: JObject; _sqlUpdate: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_sqlUpdate));
  jCls:= env^.GetObjectClass(env, _jmssqljdbcconnection);
  jMethod:= env^.GetMethodID(env, jCls, 'ExecuteUpdateAsync', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmssqljdbcconnection, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
