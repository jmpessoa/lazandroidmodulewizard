unit cmail;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget;

type

TMailProtocol = (mpImap, mpPop3);
TOnMailMessageRead=procedure(Sender:TObject;position:integer;Header:string;Date:string;Subject:string;ContentType:string;ContentText:string;Attachments:string) of object;
TOnMailMessagesCount=procedure(Sender:TObject;count:integer) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/14/2019 14:45:05]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jcMail = class(jControl)
 private
    FProtocol: TMailProtocol;
    FHostName: string;
    FHostPort: integer;
    FUserName: string;
    FPassword: string;
    FAttachmentsSaveDirectory: string;
    FOnMailMessageRead: TOnMailMessageRead;
    FOnMailMessagesCount: TOnMailMessagesCount;

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    procedure SetProtocol(_protocol: TMailProtocol);
    procedure SetHostName(_host: string);
    procedure SetHostPort(_port: integer);
    procedure SetUserName(_user: string);
    procedure SetPassword(_password: string);

    procedure SetAttachmentsSaveDirectory(_envDirectory: string);
    function GetInBoxCount(): integer;
    function GetInBoxMessage(_index: integer; _partsDelimiter: string): string;

    procedure GetInBoxCountAsync();
    procedure GetInBoxMessageAsync(_index: integer; _partsDelimiter: string);
    procedure GetInBoxMessagesAsync(_startIndex: integer; _count: integer; _partsDelimiter: string);

    procedure GenEvent_OnMailMessagesCount(Sender:TObject;count:integer);
    procedure GenEvent_OnMailMessageRead(Sender:TObject;position:integer;Header:string;Date:string;Subject:string;ContentType:string;ContentText:string;Attachments:string);

    property AttachmentsDir: string read FAttachmentsSaveDirectory write SetAttachmentsSaveDirectory;
 published
    property Protocol: TMailProtocol read FProtocol write SetProtocol;
    property HostName: string read FHostName write SetHostName;
    property HostPort: integer read FHostPort write SetHostPort;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property OnMessageRead: TOnMailMessageRead read FOnMailMessageRead write FOnMailMessageRead;
    property OnMessagesCount: TOnMailMessagesCount read FOnMailMessagesCount write FOnMailMessagesCount;

end;

function jcMail_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jcMail_jFree(env: PJNIEnv; _jcmail: JObject);

procedure jcMail_SetProtocol(env: PJNIEnv; _jcmail: JObject; _protocol: integer);
procedure jcMail_SetHostName(env: PJNIEnv; _jcmail: JObject; _host: string);
procedure jcMail_SetHostPort(env: PJNIEnv; _jcmail: JObject; _port: integer);
procedure jcMail_SetUserName(env: PJNIEnv; _jcmail: JObject; _user: string);
procedure jcMail_SetPassword(env: PJNIEnv; _jcmail: JObject; _password: string);

procedure jcMail_SetAttachmentsSaveDirectory(env: PJNIEnv; _jcmail: JObject; _envDirectory: string);
function jcMail_GetInBoxCount(env: PJNIEnv; _jcmail: JObject): integer;
function jcMail_GetInBoxMessage(env: PJNIEnv; _jcmail: JObject; _index: integer; _partsDelimiter: string): string;

procedure jcMail_GetInBoxCountAsync(env: PJNIEnv; _jcmail: JObject);
procedure jcMail_GetInBoxMessageAsync(env: PJNIEnv; _jcmail: JObject; _index: integer; _partsDelimiter: string);
procedure jcMail_GetInBoxMessagesAsync(env: PJNIEnv; _jcmail: JObject; _startIndex: integer; _count: integer; _partsDelimiter: string);

implementation

{---------  jcMail  --------------}

constructor jcMail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jcMail.Destroy;
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

procedure jcMail.Init(refApp: jApp);
begin

  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;

  if FProtocol <> mpImap then
     jcMail_SetProtocol(FjEnv, FjObject, Ord(FProtocol));

  if FHostName <> '' then
     jcMail_SetHostName(FjEnv, FjObject, FHostName);

  if FHostPort <> 0 then
     jcMail_SetHostPort(FjEnv, FjObject, FHostPort);

  if FUserName <>  '' then
     jcMail_SetUserName(FjEnv, FjObject, FUserName);

  if FPassword <> '' then
     jcMail_SetPassword(FjEnv, FjObject, FPassword);

end;


function jcMail.jCreate(): jObject;
begin
   Result:= jcMail_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jcMail.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcMail_jFree(FjEnv, FjObject);
end;

procedure jcMail.SetProtocol(_protocol: TMailProtocol);
begin
  //in designing component state: set value here...
  FProtocol:= _protocol;
  if FInitialized then
     jcMail_SetProtocol(FjEnv, FjObject, Ord(_protocol));
end;

procedure jcMail.SetHostName(_host: string);
begin
  //in designing component state: set value here...
  FHostName:= _host;
  if FInitialized then
     jcMail_SetHostName(FjEnv, FjObject, _host);
end;

procedure jcMail.SetHostPort(_port: integer);
begin
  //in designing component state: set value here...
  FHostPort:= _port;
  if FInitialized then
     jcMail_SetHostPort(FjEnv, FjObject, _port);
end;

procedure jcMail.SetUserName(_user: string);
begin
  //in designing component state: set value here...
  FUserName:= _user;
  if FInitialized then
     jcMail_SetUserName(FjEnv, FjObject, _user);
end;

procedure jcMail.SetPassword(_password: string);
begin
  //in designing component state: set value here...
  FPassword:= _password;
  if FInitialized then
     jcMail_SetPassword(FjEnv, FjObject, _password);
end;

procedure jcMail.SetAttachmentsSaveDirectory(_envDirectory: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcMail_SetAttachmentsSaveDirectory(FjEnv, FjObject, _envDirectory);
end;

function jcMail.GetInBoxCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMail_GetInBoxCount(FjEnv, FjObject);
end;

function jcMail.GetInBoxMessage(_index: integer; _partsDelimiter: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcMail_GetInBoxMessage(FjEnv, FjObject, _index ,_partsDelimiter);
end;

procedure jcMail.GetInBoxCountAsync();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcMail_GetInBoxCountAsync(FjEnv, FjObject);
end;

procedure jcMail.GetInBoxMessageAsync(_index: integer; _partsDelimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcMail_GetInBoxMessageAsync(FjEnv, FjObject, _index ,_partsDelimiter);
end;

procedure jcMail.GetInBoxMessagesAsync(_startIndex: integer; _count: integer; _partsDelimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcMail_GetInBoxMessagesAsync(FjEnv, FjObject, _startIndex ,_count ,_partsDelimiter);
end;

procedure jcMail.GenEvent_OnMailMessagesCount(Sender:TObject;count:integer);
begin
  if Assigned(FOnMailMessagesCount) then FOnMailMessagesCount(Sender,count);
end;

procedure jcMail.GenEvent_OnMailMessageRead(Sender:TObject;position:integer;Header:string;Date:string;Subject:string;ContentType:string;ContentText:string;Attachments:string);
begin
  if Assigned(FOnMailMessageRead) then FOnMailMessageRead(Sender,position,Header,Date,Subject,ContentType,ContentText,Attachments);
end;

{-------- jcMail_JNI_Bridge ----------}

function jcMail_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jcMail_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jcMail_jFree(env: PJNIEnv; _jcmail: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcmail, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcMail_SetProtocol(env: PJNIEnv; _jcmail: JObject; _protocol: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _protocol;
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'SetProtocol', '(I)V');
  env^.CallVoidMethodA(env, _jcmail, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcMail_SetHostName(env: PJNIEnv; _jcmail: JObject; _host: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_host));
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHostName', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcmail, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcMail_SetHostPort(env: PJNIEnv; _jcmail: JObject; _port: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _port;
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHostPort', '(I)V');
  env^.CallVoidMethodA(env, _jcmail, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcMail_SetUserName(env: PJNIEnv; _jcmail: JObject; _user: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_user));
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUserName', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcmail, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcMail_SetPassword(env: PJNIEnv; _jcmail: JObject; _password: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_password));
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPassword', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcmail, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jcMail_GetInBoxCount(env: PJNIEnv; _jcmail: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'GetInBoxCount', '()I');
  Result:= env^.CallIntMethod(env, _jcmail, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcMail_GetInBoxMessage(env: PJNIEnv; _jcmail: JObject; _index: integer; _partsDelimiter: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_partsDelimiter));
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'GetInBoxMessage', '(ILjava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jcmail, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcMail_SetAttachmentsSaveDirectory(env: PJNIEnv; _jcmail: JObject; _envDirectory: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_envDirectory));
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAttachmentsSaveDirectory', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcmail, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcMail_GetInBoxCountAsync(env: PJNIEnv; _jcmail: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'GetInBoxCountAsync', '()V');
  env^.CallVoidMethod(env, _jcmail, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcMail_GetInBoxMessageAsync(env: PJNIEnv; _jcmail: JObject; _index: integer; _partsDelimiter: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_partsDelimiter));
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'GetInBoxMessageAsync', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcmail, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcMail_GetInBoxMessagesAsync(env: PJNIEnv; _jcmail: JObject; _startIndex: integer; _count: integer; _partsDelimiter: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _startIndex;
  jParams[1].i:= _count;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_partsDelimiter));
  jCls:= env^.GetObjectClass(env, _jcmail);
  jMethod:= env^.GetMethodID(env, jCls, 'GetInBoxMessagesAsync', '(IILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcmail, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
