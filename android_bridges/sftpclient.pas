unit sftpclient;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TOnSFTPClientTryConnect=procedure(Sender:TObject;success:boolean) of object;
TOnSFTPClientDownloadFinished=procedure(Sender:TObject;localPath:string;success:boolean) of object;
TOnSFTPClientUploadFinished=procedure(Sender:TObject;remotePath:string;success:boolean) of object;
TOnSFTPClientListing=procedure(Sender:TObject;remotePath:string;fileName:string;fileSize:integer) of object;
TOnSFTPClientListed=procedure(Sender:TObject;count:integer) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/23/2019 19:05:38]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jSFTPClient = class(jControl)
 private
    FHost: string;
    FPort: integer;
    FIdentityCertificateKey: string;
    FPassword: string;
    FUsername: string;

    FOnSFTPClientTryConnect: TOnSFTPClientTryConnect;
    FOnSFTPClientDownloadFinished: TOnSFTPClientDownloadFinished;
    FOnSFTPClientUploadFinished: TOnSFTPClientUploadFinished;
    FOnSFTPClientListing: TOnSFTPClientListing;
    FOnSFTPClientListed: TOnSFTPClientListed;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure Disconnect();
    procedure SetHost(_host: string);
    procedure SetPort(_port: integer);
    procedure SetIdentityCertificateKey(_certificateKey: string);
    procedure SetPassword(_password: string);
    procedure SetUsername(_username: string);
    procedure Connect();
    procedure Download(_fromRemote: string; _toLocal: string);
    procedure Upload(_fromLocal: string; _toRemote: string);
    procedure ListFiles(_remotePath: string);

    procedure GenEvent_OnSFTPClientTryConnect(Sender:TObject;success:boolean);
    procedure GenEvent_OnSFTPClientDownloadFinished(Sender:TObject;destination:string;success:boolean);
    procedure GenEvent_OnSFTPClientUploadFinished(Sender:TObject;destination:string;success:boolean);
    procedure GenEvent_OnSFTPClientListing(Sender:TObject;url:string;fileName:string;fileSize:integer);
    procedure GenEvent_OnSFTPClientListed(Sender:TObject;count:integer);

    property Host: string read FHost write SetHost;
    property Port: integer read FPort write SetPort;
    property IdentityKey: string read FIdentityCertificateKey write SetIdentityCertificateKey;
    property Password: string read FPassword write setPassword;
    property Username: string read FUsername write SetUsername;

 published
    property OnConnect: TOnSFTPClientTryConnect read FOnSFTPClientTryConnect write FOnSFTPClientTryConnect;
    property OnDownload: TOnSFTPClientDownloadFinished read FOnSFTPClientDownloadFinished write FOnSFTPClientDownloadFinished;
    property OnUpload: TOnSFTPClientUploadFinished read FOnSFTPClientUploadFinished write FOnSFTPClientUploadFinished;
    property OnListing: TOnSFTPClientListing read FOnSFTPClientListing write FOnSFTPClientListing;
    property OnListed: TOnSFTPClientListed read FOnSFTPClientListed write FOnSFTPClientListed;

end;

function jSFTPClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jSFTPClient_jFree(env: PJNIEnv; _jsftpclient: JObject);

procedure jSFTPClient_Disconnect(env: PJNIEnv; _jsftpclient: JObject);
procedure jSFTPClient_SetHost(env: PJNIEnv; _jsftpclient: JObject; _host: string);
procedure jSFTPClient_SetPort(env: PJNIEnv; _jsftpclient: JObject; _port: integer);
procedure jSFTPClient_SetIdentityCertificateKey(env: PJNIEnv; _jsftpclient: JObject; _certificateKey: string);
procedure jSFTPClient_SetPassword(env: PJNIEnv; _jsftpclient: JObject; _password: string);
procedure jSFTPClient_SetUsername(env: PJNIEnv; _jsftpclient: JObject; _username: string);
procedure jSFTPClient_Connect(env: PJNIEnv; _jsftpclient: JObject);
procedure jSFTPClient_Download(env: PJNIEnv; _jsftpclient: JObject; _source: string; _destination: string);
procedure jSFTPClient_Upload(env: PJNIEnv; _jsftpclient: JObject; _source: string; _destination: string);
procedure jSFTPClient_ListFiles(env: PJNIEnv; _jsftpclient: JObject; _remotePath: string);


implementation

{---------  jSFTPClient  --------------}

constructor jSFTPClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jSFTPClient.Destroy;
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

procedure jSFTPClient.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;


function jSFTPClient.jCreate(): jObject;
begin
   Result:= jSFTPClient_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jSFTPClient.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_jFree(FjEnv, FjObject);
end;

procedure jSFTPClient.Disconnect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_Disconnect(FjEnv, FjObject);
end;

procedure jSFTPClient.SetHost(_host: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_SetHost(FjEnv, FjObject, _host);
end;

procedure jSFTPClient.SetPort(_port: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_SetPort(FjEnv, FjObject, _port);
end;

procedure jSFTPClient.SetIdentityCertificateKey(_certificateKey: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_SetIdentityCertificateKey(FjEnv, FjObject, _certificateKey);
end;

procedure jSFTPClient.SetPassword(_password: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_SetPassword(FjEnv, FjObject, _password);
end;

procedure jSFTPClient.SetUsername(_username: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_SetUsername(FjEnv, FjObject, _username);
end;

procedure jSFTPClient.Connect();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_Connect(FjEnv, FjObject);
end;

procedure jSFTPClient.Download(_fromRemote: string; _toLocal: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_Download(FjEnv, FjObject, _fromRemote ,_toLocal);
end;

procedure jSFTPClient.Upload(_fromLocal: string; _toRemote: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_Upload(FjEnv, FjObject, _fromLocal ,_toRemote);
end;

procedure jSFTPClient.ListFiles(_remotePath: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSFTPClient_ListFiles(FjEnv, FjObject, _remotePath);
end;

procedure jSFTPClient.GenEvent_OnSFTPClientTryConnect(Sender:TObject;success:boolean);
begin
  if Assigned(FOnSFTPClientTryConnect) then FOnSFTPClientTryConnect(Sender,success);
end;

procedure jSFTPClient.GenEvent_OnSFTPClientUploadFinished(Sender:TObject;destination:string;success:boolean);
begin
  if Assigned(FOnSFTPClientUploadFinished) then FOnSFTPClientUploadFinished(Sender,destination,success);
end;

procedure jSFTPClient.GenEvent_OnSFTPClientDownloadFinished(Sender:TObject;destination:string;success:boolean);
begin
  if Assigned(FOnSFTPClientDownloadFinished) then FOnSFTPClientDownloadFinished(Sender,destination,success);
end;

procedure jSFTPClient.GenEvent_OnSFTPClientListing(Sender:TObject;url:string;fileName:string;fileSize:integer);
begin
  if Assigned(FOnSFTPClientListing) then FOnSFTPClientListing(Sender,url,fileName,fileSize);
end;

procedure jSFTPClient.GenEvent_OnSFTPClientListed(Sender:TObject;count:integer);
begin
  if Assigned(FOnSFTPClientListed) then FOnSFTPClientListed(Sender,count);
end;

{-------- jSFTPClient_JNI_Bridge ----------}

function jSFTPClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSFTPClient_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jSFTPClient_jFree(env: PJNIEnv; _jsftpclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsftpclient, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSFTPClient_Disconnect(env: PJNIEnv; _jsftpclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Disconnect', '()V');
  env^.CallVoidMethod(env, _jsftpclient, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSFTPClient_SetHost(env: PJNIEnv; _jsftpclient: JObject; _host: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_host));
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHost', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsftpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSFTPClient_SetPort(env: PJNIEnv; _jsftpclient: JObject; _port: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _port;
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPort', '(I)V');
  env^.CallVoidMethodA(env, _jsftpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSFTPClient_SetIdentityCertificateKey(env: PJNIEnv; _jsftpclient: JObject; _certificateKey: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_certificateKey));
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIdentityCertificateKey', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsftpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSFTPClient_SetPassword(env: PJNIEnv; _jsftpclient: JObject; _password: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPassword', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsftpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSFTPClient_SetUsername(env: PJNIEnv; _jsftpclient: JObject; _username: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_username));
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUsername', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsftpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSFTPClient_Connect(env: PJNIEnv; _jsftpclient: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Connect', '()V');
  env^.CallVoidMethod(env, _jsftpclient, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSFTPClient_Download(env: PJNIEnv; _jsftpclient: JObject; _source: string; _destination: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_source));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_destination));
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Download', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsftpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSFTPClient_Upload(env: PJNIEnv; _jsftpclient: JObject; _source: string; _destination: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_source));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_destination));
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'Upload', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsftpclient, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSFTPClient_ListFiles(env: PJNIEnv; _jsftpclient: JObject; _remotePath: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_remotePath));
  jCls:= env^.GetObjectClass(env, _jsftpclient);
  jMethod:= env^.GetMethodID(env, jCls, 'ListFiles', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsftpclient, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
