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
       jni_proc(FjEnv, FjObject, 'jFree');
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
  FjObject := jcMail_jCreate(FjEnv, int64(Self), FjThis);
  if FjObject = nil then exit;
  FInitialized:= True;

  if FProtocol <> mpImap then
     SetProtocol(FProtocol);

  if FHostName <> '' then
     SetHostName(FHostName);

  if FHostPort <> 0 then
     SetHostPort(FHostPort);

  if FUserName <>  '' then
     SetUserName(FUserName);

  if FPassword <> '' then
     SetPassword(FPassword);

end;

procedure jcMail.SetProtocol(_protocol: TMailProtocol);
begin
  //in designing component state: set value here...
  FProtocol:= _protocol;
  if FjObject = nil then exit;

  jni_proc_i(FjEnv, FjObject, 'SetProtocol', Ord(_protocol));
end;

procedure jcMail.SetHostName(_host: string);
begin
  //in designing component state: set value here...
  FHostName:= _host;
  if FjObject = nil then exit;

  jni_proc_t(FjEnv, FjObject, 'SetHostName', _host);
end;

procedure jcMail.SetHostPort(_port: integer);
begin
  //in designing component state: set value here...
  FHostPort:= _port;
  if FjObject = nil then exit;

  jni_proc_i(FjEnv, FjObject, 'SetHostPort', _port);
end;

procedure jcMail.SetUserName(_user: string);
begin
  //in designing component state: set value here...
  FUserName:= _user;
  if FjObject = nil then exit;

  jni_proc_t(FjEnv, FjObject, 'SetUserName', _user);
end;

procedure jcMail.SetPassword(_password: string);
begin
  //in designing component state: set value here...
  FPassword:= _password;
  if FjObject = nil then exit;

  jni_proc_t(FjEnv, FjObject, 'SetPassword', _password);
end;

procedure jcMail.SetAttachmentsSaveDirectory(_envDirectory: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'SetAttachmentsSaveDirectory', _envDirectory);
end;

function jcMail.GetInBoxCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetInBoxCount');
end;

function jcMail.GetInBoxMessage(_index: integer; _partsDelimiter: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_it_out_t(FjEnv, FjObject, 'GetInBoxMessage', _index ,_partsDelimiter);
end;

procedure jcMail.GetInBoxCountAsync();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'GetInBoxCountAsync');
end;

procedure jcMail.GetInBoxMessageAsync(_index: integer; _partsDelimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_it(FjEnv, FjObject, 'GetInBoxMessageAsync', _index ,_partsDelimiter);
end;

procedure jcMail.GetInBoxMessagesAsync(_startIndex: integer; _count: integer; _partsDelimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_iit(FjEnv, FjObject, 'GetInBoxMessagesAsync', _startIndex ,_count ,_partsDelimiter);
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
label
  _exceptionOcurred;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jcMail_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


end.
