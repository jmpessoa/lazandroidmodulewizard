unit ftpclient;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TOnFTPClientTryConnect=procedure(Sender:TObject;success:boolean) of object;
TOnFTPClientDownloadFinished=procedure(Sender:TObject;localPath:string;success:boolean) of object;
TOnFTPClientUploadFinished=procedure(Sender:TObject;remotePath:string;success:boolean) of object;
TOnFTPClientListing=procedure(Sender:TObject;remotePath:string;fileName:string;fileSize:integer) of object;
TOnFTPClientListed=procedure(Sender:TObject;count:integer) of object;


{Draft Component code by "LAMW: Lazarus Android Module Wizard" [10/10/2019 19:45:36]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jFTPClient = class(jControl)
 private

    FHost: string;
    FPort: integer;
    FIdentityCertificateKey: string;
    FPassword: string;
    FUsername: string;
    FWorkingDirectory: string;

    FOnFTPClientTryConnect: TOnFTPClientTryConnect;
    FOnFTPClientDownloadFinished: TOnFTPClientDownloadFinished;
    FOnFTPClientUploadFinished: TOnFTPClientUploadFinished;
    FOnFTPClientListing: TOnFTPClientListing;
    FOnFTPClientListed: TOnFTPClientListed;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure Disconnect();
    function GetWorkingDirectory(): string;
    procedure SetWorkingDirectory(_remotePath: string);
    procedure SetHost(_host: string);
    procedure SetPort(_port: integer);
    procedure SetPassword(_password: string);
    procedure SetUsername(_username: string);
    procedure Connect();
    procedure Download(_url: string; _saveToLocal: string);
    procedure Upload(_fromLocal: string; _url: string);
    procedure ListFiles(_remotePath: string);
    procedure CountFiles(_remotePath: string);

    procedure GenEvent_OnFTPClientTryConnect(Sender:TObject;success:boolean);
    procedure GenEvent_OnFTPClientDownloadFinished(Sender:TObject;destination:string;success:boolean);
    procedure GenEvent_OnFTPClientUploadFinished(Sender:TObject;destination:string;success:boolean);
    procedure GenEvent_OnFTPClientListing(Sender:TObject;url:string;fileName:string;fileSize:integer);
    procedure GenEvent_OnFTPClientListed(Sender:TObject;count:integer);

    property Host: string read FHost write SetHost;
    property Port: integer read FPort write SetPort;
    property Password: string read FPassword write setPassword;
    property Username: string read FUsername write SetUsername;
    property WorkingDirectory: string read GetWorkingDirectory write SetWorkingDirectory;
 published
    property OnConnect: TOnFTPClientTryConnect read FOnFTPClientTryConnect write FOnFTPClientTryConnect;
    property OnDownload: TOnFTPClientDownloadFinished read FOnFTPClientDownloadFinished write FOnFTPClientDownloadFinished;
    property OnUpload: TOnFTPClientUploadFinished read FOnFTPClientUploadFinished write FOnFTPClientUploadFinished;
    property OnListing: TOnFTPClientListing read FOnFTPClientListing write FOnFTPClientListing;
    property OnListed: TOnFTPClientListed read FOnFTPClientListed write FOnFTPClientListed;
end;

function jFTPClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jFTPClient_jFree(env: PJNIEnv; _jftpclient: JObject);
procedure jFTPClient_Disconnect(env: PJNIEnv; _jftpclient: JObject);
function jFTPClient_GetWorkingDirectory(env: PJNIEnv; _jftpclient: JObject): string;
procedure jFTPClient_SetWorkingDirectory(env: PJNIEnv; _jftpclient: JObject; _remotePath: string);
procedure jFTPClient_SetHost(env: PJNIEnv; _jftpclient: JObject; _host: string);
procedure jFTPClient_SetPort(env: PJNIEnv; _jftpclient: JObject; _port: integer);
procedure jFTPClient_SetPassword(env: PJNIEnv; _jftpclient: JObject; _password: string);
procedure jFTPClient_SetUsername(env: PJNIEnv; _jftpclient: JObject; _username: string);
procedure jFTPClient_Connect(env: PJNIEnv; _jftpclient: JObject);
procedure jFTPClient_Download(env: PJNIEnv; _jftpclient: JObject; _url: string; _saveToLocal: string);
procedure jFTPClient_Upload(env: PJNIEnv; _jftpclient: JObject; _fromLocal: string; _url: string);
procedure jFTPClient_ListFiles(env: PJNIEnv; _jftpclient: JObject; _remotePath: string);
procedure jFTPClient_CountFiles(env: PJNIEnv; _jftpclient: JObject; _remotePath: string);

implementation

{---------  jFTPClient  --------------}

constructor jFTPClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jFTPClient.Destroy;
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

procedure jFTPClient.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;


function jFTPClient.jCreate(): jObject;
begin
   Result:= jFTPClient_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jFTPClient.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_jFree(FjEnv, FjObject);
end;

procedure jFTPClient.Disconnect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_Disconnect(FjEnv, FjObject);
end;

function jFTPClient.GetWorkingDirectory(): string;
begin
  //in designing component state: result value here...
  Result:= FWorkingDirectory;
  if FInitialized then
   Result:= jFTPClient_GetWorkingDirectory(FjEnv, FjObject);
end;

procedure jFTPClient.SetWorkingDirectory(_remotePath: string);
begin
  //in designing component state: result value here...
  FWorkingDirectory:= _remotePath;
  if FInitialized then
    jFTPClient_SetWorkingDirectory(FjEnv, FjObject, _remotePath);
end;

procedure jFTPClient.SetHost(_host: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_SetHost(FjEnv, FjObject, _host);
end;

procedure jFTPClient.SetPort(_port: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_SetPort(FjEnv, FjObject, _port);
end;

procedure jFTPClient.SetPassword(_password: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_SetPassword(FjEnv, FjObject, _password);
end;

procedure jFTPClient.SetUsername(_username: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_SetUsername(FjEnv, FjObject, _username);
end;

procedure jFTPClient.Connect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_Connect(FjEnv, FjObject);
end;

procedure jFTPClient.Download(_url: string; _saveToLocal: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_Download(FjEnv, FjObject, _url ,_saveToLocal);
end;

procedure jFTPClient.Upload(_fromLocal: string; _url: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_Upload(FjEnv, FjObject, _fromLocal ,_url);
end;

procedure jFTPClient.ListFiles(_remotePath: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_ListFiles(FjEnv, FjObject, _remotePath);
end;

procedure jFTPClient.CountFiles(_remotePath: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFTPClient_CountFiles(FjEnv, FjObject, _remotePath);
end;

procedure jFTPClient.GenEvent_OnFTPClientTryConnect(Sender:TObject;success:boolean);
begin
  if Assigned(FOnFTPClientTryConnect) then FOnFTPClientTryConnect(Sender,success);
end;

procedure jFTPClient.GenEvent_OnFTPClientUploadFinished(Sender:TObject;destination:string;success:boolean);
begin
  if Assigned(FOnFTPClientUploadFinished) then FOnFTPClientUploadFinished(Sender,destination,success);
end;

procedure jFTPClient.GenEvent_OnFTPClientDownloadFinished(Sender:TObject;destination:string;success:boolean);
begin
  if Assigned(FOnFTPClientDownloadFinished) then FOnFTPClientDownloadFinished(Sender,destination,success);
end;

procedure jFTPClient.GenEvent_OnFTPClientListing(Sender:TObject;url:string;fileName:string;fileSize:integer);
begin
  if Assigned(FOnFTPClientListing) then FOnFTPClientListing(Sender,url,fileName,fileSize);
end;

procedure jFTPClient.GenEvent_OnFTPClientListed(Sender:TObject;count:integer);
begin
  if Assigned(FOnFTPClientListed) then FOnFTPClientListed(Sender,count);
end;

{-------- jFTPClient_JNI_Bridge ----------}

function jFTPClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jFTPClient_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jFTPClient_jFree(env: PJNIEnv; _jftpclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jftpclient, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jFTPClient_Disconnect(env: PJNIEnv; _jftpclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Disconnect', '()V');
  env^.CallVoidMethod(env, _jftpclient, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jFTPClient_GetWorkingDirectory(env: PJNIEnv; _jftpclient: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'GetWorkingDirectory', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jftpclient, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFTPClient_SetWorkingDirectory(env: PJNIEnv; _jftpclient: JObject; _remotePath: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_remotePath));
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetWorkingDirectory', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jftpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFTPClient_SetHost(env: PJNIEnv; _jftpclient: JObject; _host: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_host));
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHost', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jftpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFTPClient_SetPort(env: PJNIEnv; _jftpclient: JObject; _port: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _port;
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPort', '(I)V');
  env^.CallVoidMethodA(env, _jftpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFTPClient_SetPassword(env: PJNIEnv; _jftpclient: JObject; _password: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPassword', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jftpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFTPClient_SetUsername(env: PJNIEnv; _jftpclient: JObject; _username: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_username));
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUsername', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jftpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFTPClient_Connect(env: PJNIEnv; _jftpclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '()V');
  env^.CallVoidMethod(env, _jftpclient, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFTPClient_Download(env: PJNIEnv; _jftpclient: JObject; _url: string; _saveToLocal: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_url));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_saveToLocal));
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Download', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jftpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFTPClient_Upload(env: PJNIEnv; _jftpclient: JObject; _fromLocal: string; _url: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fromLocal));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_url));
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Upload', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jftpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFTPClient_ListFiles(env: PJNIEnv; _jftpclient: JObject; _remotePath: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_remotePath));
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'ListFiles', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jftpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFTPClient_CountFiles(env: PJNIEnv; _jftpclient: JObject; _remotePath: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_remotePath));
  jCls:= env^.GetObjectClass(env, _jftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'CountFiles', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jftpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
