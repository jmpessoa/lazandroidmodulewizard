unit tcpsocketclient;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TOnMessageReceived = procedure(Sender: TObject; messageReceived: string) of object;
TOnBytesReceived = procedure(Sender: TObject; var jbytesReceived: TDynArrayOfJByte) of object;
TOnSendFileProgress =  procedure(Sender: TObject; fileName: string; sendFileSize: integer; fileSize: integer) of object;
TOnSendFileFinished =  procedure(Sender: TObject; fileName: string; fileSize: integer) of object;
TOnGetFileProgress =  procedure(Sender: TObject; fileName: string; remainingFileSize: integer; fileSize: integer) of object;
TOnGetFileFinished =  procedure(Sender: TObject; fileName: string; fileSize: integer) of object;

TOnDisConnected=procedure(Sender:TObject) of object;


TDataTransferMode = (dtmText, dtmByte, dtmFileGet, dtmFileSend);

{Draft Component code by "Lazarus Android Module Wizard" [5/19/2015 18:49:35]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jTCPSocketClient = class(jControl)
  private
    FOnMessageReceived: TOnMessageReceived;
    FOnBytesReceived: TOnBytesReceived;
    FOnConnected: TOnNotify;
    FOnSendFileProgress: TOnSendFileProgress;
    FOnSendFileFinished: TOnSendFileFinished;
    FOnGetFileProgress: TOnGetFileProgress;
    FOnGetFileFinished: TOnGetFileFinished;
    FOnDisConnected: TOnDisConnected;
  public

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();

    function  SendMessage(message: string): boolean;
    function  SendFile(fullPath: string) : boolean;
    procedure SetSendFileProgressStep(_bytes: integer);

    function  SetGetFile(fullPath: string; fileSize: integer) : boolean;

    function  ConnectAsyncTimeOut(_serverIP: string; _serverPort: integer; _timeOut: integer): boolean;
    function  ConnectAsync(_serverIP: string; _serverPort: integer): boolean; overload;
    
    function  IsConnected(): boolean;

    procedure CloseConnection(); 

    procedure SetTimeOut(_millisecondsTimeOut: integer);

    function  SendBytes(var _jbyteArray: TDynArrayOfJByte; _writeLength: boolean): boolean;
    function  SetDataTransferMode(_dataTransferMode: TDataTransferMode) : boolean;

    procedure GenEvent_OnTCPSocketClientMessagesReceived(Sender: TObject; messageReceived: string);
    procedure GenEvent_OnTCPSocketClientBytesReceived(Sender: TObject; var jbytesReceived: TDynArrayOfJByte);
    procedure GenEvent_OnTCPSocketClientConnected(Sender: TObject);
    procedure GenEvent_OnTCPSocketClientFileSendProgress(Sender: TObject; filename: string; sendFileSize: integer; filesize: integer);
    procedure GenEvent_pOnTCPSocketClientFileSendFinished(Sender: TObject;  filename: string;  filesize: integer);
    procedure GenEvent_OnTCPSocketClientFileGetProgress(Sender: TObject; filename: string; remainingFileSize: integer; filesize: integer);
    procedure GenEvent_pOnTCPSocketClientFileGetFinished(Sender: TObject;  filename: string;  filesize: integer);
    procedure GenEvent_OnTCPSocketClientDisConnected(Sender:TObject);

 published
    property OnMessagesReceived: TOnMessageReceived read FOnMessageReceived write FOnMessageReceived;
    property OnBytesReceived: TOnBytesReceived read FOnBytesReceived write FOnBytesReceived;
    property OnConnected: TOnNotify read FOnConnected write FOnConnected;
    property OnSendFileProgress: TOnSendFileProgress read FOnSendFileProgress write FOnSendFileProgress;
    property OnSendFileFinished: TOnSendFileFinished read FOnSendFileFinished write FOnSendFileFinished;
    property OnGetFileProgress: TOnGetFileProgress read FOnGetFileProgress write FOnGetFileProgress;
    property OnGetFileFinished: TOnGetFileFinished read FOnGetFileFinished write FOnGetFileFinished;
    property OnDisConnected: TOnDisConnected read FOnDisConnected write FOnDisConnected;

end;

function  jTCPSocketClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;


implementation

{---------  jTCPSocketClient  --------------}

constructor jTCPSocketClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jTCPSocketClient.Destroy;
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

procedure jTCPSocketClient.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  FInitialized:= True;
end;


function jTCPSocketClient.jCreate(): jObject;
begin
   Result:= jTCPSocketClient_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jTCPSocketClient.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'jFree');
end;

function jTCPSocketClient.SendMessage(message: string) : boolean;
begin

  //in designing component state: set value here...
  if FInitialized then
   Result:= jni_func_t_out_z(FjEnv, FjObject, 'SendMessage', message);

end;

function jTCPSocketClient.SendFile(fullPath: string) : boolean;
begin
  //in designing component state: set value here...
  if FInitialized then
     Result := jni_func_t_out_z(FjEnv, FjObject, 'SendFile', fullPath);
end;

function jTCPSocketClient.SetGetFile(fullPath: string; fileSize: integer) : boolean;
begin
  //in designing component state: set value here...
  if FInitialized then
     Result := jni_func_ti_out_z(FjEnv, FjObject, 'SetGetFile', fullPath, fileSize);
end;

procedure jTCPSocketClient.CloseConnection();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'CloseConnection');
end;

function jTCPSocketClient.ConnectAsync(_serverIP: string; _serverPort: integer): boolean; overload;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_ti_out_z(FjEnv, FjObject, 'Connect', _serverIP ,_serverPort);
end;

function jTCPSocketClient.ConnectAsyncTimeOut(_serverIP: string; _serverPort: integer; _timeOut: integer): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_tii_out_z(FjEnv, FjObject, 'Connect', _serverIP ,_serverPort ,_timeOut);
end;

function jTCPSocketClient.IsConnected(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'isConnected');
end;

procedure jTCPSocketClient.SetSendFileProgressStep(_bytes: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetSendFileProgressStep', _bytes);
end;

procedure jTCPSocketClient.SetTimeOut(_millisecondsTimeOut: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetTimeOut', _millisecondsTimeOut);
end;

function jTCPSocketClient.SendBytes(var _jbyteArray: TDynArrayOfJByte; _writeLength: boolean): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_dab_z_out_z(FjEnv, FjObject, 'SendBytes', _jbyteArray ,_writeLength);
end;

function jTCPSocketClient.SetDataTransferMode(_dataTransferMode: TDataTransferMode) : boolean;
begin
  //in designing component state: set value here...
  if FInitialized then
     Result := jni_func_i_out_z(FjEnv, FjObject, 'SetDataTransferMode', Ord(_dataTransferMode));
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientMessagesReceived(Sender: TObject; messageReceived: string);
begin
  if Assigned(FOnMessageReceived) then  FOnMessageReceived(Sender, messageReceived);
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientBytesReceived(Sender: TObject;  var jbytesReceived: TDynArrayOfJByte);
begin
  if Assigned(FOnBytesReceived) then FOnBytesReceived(Sender, jbytesReceived);
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientConnected(Sender: TObject);
begin
  if Assigned(FOnConnected) then  FOnConnected(Sender);
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientFileSendProgress(Sender: TObject; filename: string; sendFileSize: integer; filesize: integer);
begin
  if Assigned(FOnSendFileProgress) then  FOnSendFileProgress(Sender, filename, sendFileSize, filesize);
end;

procedure jTCPSocketClient.GenEvent_pOnTCPSocketClientFileSendFinished(Sender: TObject;  filename: string;  filesize: integer);
begin
  if Assigned(FOnSendFileFinished) then FOnSendFileFinished(Sender, filename, filesize);
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientFileGetProgress(Sender: TObject; filename: string; remainingFileSize: integer; filesize: integer);
begin
  if Assigned(FOnGetFileProgress) then  FOnGetFileProgress(Sender, filename, remainingFileSize, filesize);
end;

procedure jTCPSocketClient.GenEvent_pOnTCPSocketClientFileGetFinished(Sender: TObject;  filename: string;  filesize: integer);
begin
  if Assigned(FOnGetFileFinished) then FOnGetFileFinished(Sender, filename, filesize);
end;

procedure jTCPSocketClient.GenEvent_OnTCPSocketClientDisConnected(Sender:TObject);
begin
  if Assigned(FOnDisConnected) then FOnDisConnected(Sender);
end;

{-------- jTCPSocketClient_JNI_Bridge ----------}

function jTCPSocketClient_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jTCPSocketClient_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

end.
