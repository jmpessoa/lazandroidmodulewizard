unit uTCPSockets;

{$mode objfpc}{$H+}

interface

uses
  Classes,SysUtils, Math, Synsock, Blcksock, FileUtil;

const
  Timeout = 6000;
  TunnelTimeout = 60000;
  PingTimeoutClient = 30000;
  PingTimeoutServer = 300000;

type
  TProxyType = (ptNone, ptHTML, ptSocks4, ptSocks5);

  TProxy = record
    FProxyType: TProxyType;
    FProxyIP: String;
    FProxyPort: String;
    FProxyUser: String;
    FProxyPass: String;
  end;

  TExtendedInfo = record
    FLocalIP: String;
    FLocalPort: Integer;
    FRemoteIP: String;
    FRemotePort: Integer;
    FRemoteHost: String;
  end;

  TConnection = class
    FIP: String;
    FHost: String;
    FPort: String;
    FUser: String;
    FPass: String;
    FProxy: TProxy;
    FExtendedInfo: TExtendedInfo;
    FUniqueID: Integer;
    FDateTime: TDateTime;
    FData: Pointer;
  end;

  { TTask }  
  TTask = class(TObject)
    FName: String;
    FMsg: String;
    FileName: String;
    FParams: array of String;
    FMS: TMemoryStream;
    FSL: TStringList;
  end;

  { TTaskList } 
  TTaskList = class
    FTaskList: TList;
    FTaskCS: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function AddTask(AName: String; AMsg: String; AParams: array of String; AMS: TMemoryStream = nil; AFileName: String = ''): Integer;
    procedure DeleteTask(AIndex: Integer);
  public
    property TaskList: TList read FTaskList;
  end;

  { TTaskQueue }  
  TStreamingType = (stDownload, stUpload);
  TOnQueueRecv = procedure(AQueueType: Integer; AMsg: String; AParams: TStringArray; AMS: TMemoryStream; AFileName: String = '') of Object;
  TOnQueueProgress = procedure(AStreamingType: TStreamingType; ACnt, ATotCnt: Int64; ASpeed, ARemaining: LongInt) of Object;
  TTaskQueue = class(TObject)
  private
    FQueueType: Integer;
    FMsg: String;
    FParams: array of String;
    FMS: TMemoryStream;
    FFileName: String;
    FStreamingType: TStreamingType;
    FCnt: Int64;
    FTotCnt: Int64;
    FSpeed: LongInt;
    FRemaining: LongInt;
    FOnQueueRecv: TOnQueueRecv;
    FOnQueueProgress: TOnQueueProgress;
    procedure DoQueueRecv;
    procedure DoQueueProgress;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure QueueRecv;
    procedure QueueProgress;
  public
    property OnQueueRecv: TOnQueueRecv read FOnQueueRecv write FOnQueueRecv;
    property OnQueueProgress: TOnQueueProgress read FOnQueueProgress write FOnQueueProgress;
  end;

  TTCPBase = class;

  { TBaseThread }
  TBaseType = (btClient, btServer, btServer_AcceptedClient);
  TBaseThread = class(TThread)
  private
    FBaseType: TBaseType;
    FInternalMsg: String;
    FTCPBase: TTCPBase;
    FBlockSocket: TTCPBlockSocket;
    FUniqueID: Integer;
    FConnection: TConnection;
    FNeedToBreak: Boolean;
    FDisconnected: Boolean;
    function GetUniqueID: Integer;
    procedure CopyConnection(ASrc, ADst: TConnection);
    procedure SyncError;
    procedure SyncInternalMessage;
    procedure DoError(AErrMsg: String; AErrCode: Integer);
    procedure DoInternalMessage(AMsg: String);
  public
    constructor Create(ATCPBase: TTCPBase);
    destructor Destroy; override;
  end;

  { TClientThread }
  TClientType = (ctMain, ctWorker);
  TClientThread = class(TBaseThread)
  private
    FUseProxy: Boolean;
    FClientType: TClientType;
    FOldCnt: Int64;
    FTick: QWord;
    FTaskList: TTaskList;
    FBusy: Boolean;
    FLastPing: QWord;
    procedure SetupProxy;
    procedure SyncConnect;
    procedure SyncDisconnect;
    procedure QueueProgress(AStreamingType: TStreamingType; ACnt, ATotCnt: Int64; ASpeed, ARemaining: LongInt);
    procedure QueueRecv(AQueueType: Integer; AMsg: String; AParams: TStringArray; AMS: TMemoryStream; AFileName: String = '');
    procedure DoConnect;
    procedure DoDisconnect;
    procedure DoProgress(AStreamingType: TStreamingType; ACnt, ATotCnt: Int64);
    procedure DoRecv(AQueueType: Integer; AMsg: String; AParams: TStringArray; AMS: TMemoryStream; AFileName: String = '');
    procedure AcquireList(out AList: TList);
    procedure FreeList(AList: TList);
    function AddDirSeparator(const Path: String): String;
    function GetDownloadDir(const APath: String): String;
    function ProcessTask(ATask: TTask): Boolean;
    function GetExtendedConnectionInfo: Boolean;
    function SendMessage(AMsg: String; AParams: array of String): Boolean;
    function RecvMessage(ATimeOut: Integer; out AMsgTyp: Integer; out AMsg: String; out AParams: TStringArray): Boolean;
    function SendStream(AMS: TMemoryStream): Boolean;
    function RecvStream(AMS: TMemoryStream): Boolean;
     function SendFile(AFileName: String): Boolean;
    function RecvFile(AFileName: String; ASize: Int64): Boolean;
  protected
    procedure Execute; override;
  public

    constructor Create(ATCPBase: TTCPBase); overload;
    constructor Create(ATCPBase: TTCPBase; ASocket: TSocket); overload;
    destructor Destroy; override;
  end;


  { TServerThread }
  TServerThread = class(TBaseThread)
  private
    function DoLogin(ACT: TClientThread): Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(ATCPBase: TTCPBase);
    destructor Destroy; override;
  end;

  { TTCPBase }
  TOnConnect = procedure(Sender: TObject; AConnection: TConnection) of Object;
  TOnDisconnect = procedure(Sender: TObject; AConnection: TConnection; AByUser: Boolean) of Object;
  TOnError = procedure(Sender: TObject; AErrMsg: string; AErrCode: Integer; AConnection: TConnection) of Object;
  TOnInternalMessage = procedure(Sender: TObject; AMsg: string) of Object;
  TOnProgress = procedure(Sender: TObject; AStreamingType: TStreamingType; ACnt, ATotCnt: Int64; ASpeed, ARemaining: LongInt; AConnection: TConnection) of Object;
  TOnRecvMessage = procedure(Sender: TObject; AMsg: String; AParams: TStringArray; AConnection: TConnection) of Object;
  TOnRecvStream = procedure(Sender: TObject; AMsg: String; AParams: TStringArray; AMS: TMemoryStream; AConnection: TConnection) of Object;
  TOnRecvFile =  procedure(Sender: TObject; AMsg: String; AParams: TStringArray; AFileName: String; AConnection: TConnection) of Object;
  TTCPBaseType = (tcpClient, tcpServer);
  TTCPBase = class
  private
    FTCP_CS: TRTLCriticalSection;
    FThreadList: TThreadList;
    FTCPBaseType: TTCPBaseType;
    FUniqueID: Integer;
    FActiveOrConnected: Boolean;
    FErrMsg: String;
    FErrCode: Integer;
    FCompress: Boolean;
    FDownloadDirectory: String;
    FHideInternalMessages: Boolean;
    FHideErrorMessages: Boolean;
    FIgnoreMessage: Boolean;
    FOnConnect: TOnConnect;
    FOnDisconnect: TOnDisconnect;
    FOnError: TOnError;
    FOnInternalMessage: TOnInternalMessage;
    FOnProgress: TOnProgress;
    FOnRecvMessage: TOnRecvMessage;
    FOnRecvStream: TOnRecvStream;
    FOnRecvFile: TOnRecvFile;
    function FindThread(const AUniqueID: Integer): TBaseThread;
    function IsMessageInvalid(const AMsg: String): Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  public
    function SendMessage(AMsg: String; AParams: array of String; const AUniqueID: Integer = 0): Boolean;
    function SendStream(AMsg: String; AParams: array of String; AMS: TMemoryStream; const AUniqueID: Integer = 0): Boolean;
    function SendFile(AMsg: String; AParams: array of String; AFileName: String; const AUniqueID: Integer = 0): Boolean;
  public
    property ErrMsg: String read FErrMsg;
    property ErrCode: Integer read FErrCode;
    property OnConnect: TOnConnect read FOnConnect write FOnConnect;
    property OnDisconnect: TOnDisconnect read FOnDisconnect write FOnDisconnect;
    property OnError: TOnError read FOnError write FOnError;
    property OnInternalMessage: TOnInternalMessage read FOnInternalMessage write FOnInternalMessage;
    property OnProgress: TOnProgress read FOnProgress write FOnProgress;
    property OnRecvMessage: TOnRecvMessage read FOnRecvMessage write FOnRecvMessage;
    property OnRecvStream: TOnRecvStream read FOnRecvStream write FOnRecvStream;
    property OnRecvFile: TOnRecvFile read FOnRecvFile write FOnRecvFile;
  end;

  { TTCPClient }
   TTCPClient = class(TTCPBase)
   private
     FByUser: Boolean;
     procedure Cleanup;
     procedure Remove(AThread: TBaseThread);
     function DoConnect(ACT: TClientThread): Boolean;
     function DoLogin(ACT: TClientThread): Integer;
   public
     constructor Create; override;
     destructor Destroy; override;
     procedure Connect(const AConnection: TConnection);
     procedure Disconnect(const AByUser: Boolean);
   public
     property Connected: Boolean read FActiveOrConnected;
     property DownloadDirectory: String read FDownloadDirectory write FDownloadDirectory;
     property HideInternalMessages: Boolean read FHideInternalMessages write FHideInternalMessages;
     property HideErrorMessages: Boolean read FHideErrorMessages write FHideErrorMessages;
   end;

   { TTCPServer }
   TTCPServer = class(TTCPBase)
   private
     FUserList: TStringList;
     procedure Cleanup;
     procedure Remove(AThread: TBaseThread);
     function FindUser(AUserName: String): Integer;
   public
     constructor Create; override;
     destructor Destroy; override;
     procedure Start(ABindConnection: TConnection);
     procedure Stop;
     procedure DisconnectClient(AUniqueID: Integer);
     function IsClientConnected(AUniqueID: Integer): Boolean;
   public
     property Active: Boolean read FActiveOrConnected;
     property DownloadDirectory: String read FDownloadDirectory write FDownloadDirectory;
     property HideInternalMessages: Boolean read FHideInternalMessages write FHideInternalMessages;
     property HideErrorMessages: Boolean read FHideErrorMessages write FHideErrorMessages;
   end;


implementation

uses uTCPCryptoCompression, uTCPFunctions, uTCPConst;

constructor TTaskList.Create;
begin
  InitCriticalSection(FTaskCS);
  FTaskList := TList.Create;
end;

destructor TTaskList.Destroy;
var
  I: Integer;
begin
  for I := FTaskList.Count - 1 downto 0 do
    DeleteTask(I);
  FTaskList.Clear;
  FTaskList.Free;
 DoneCriticalsection(FTaskCS);
  inherited Destroy;
end;

function TTaskList.AddTask(AName: String; AMsg: String; AParams: array of String;
  AMS: TMemoryStream; AFileName: String = ''): Integer;
var
  Task: TTask;
  I: Integer;
begin
  Result := -1;
  Task := TTask.Create;
  Task.FName := AName;
  Task.FMsg := AMsg;
  if Length(AParams) > 0 then
  begin
    SetLength(Task.FParams, Length(AParams));
    for I := Low(AParams) to High(AParams) do
      Task.FParams[I] := AParams[I];
  end;
  if AMS <> nil then
    Task.FMS := AMS;
  Task.FileName := AFileName;
  Result := FTaskList.Add(Task);
end;

procedure TTaskList.DeleteTask(AIndex: Integer);
var
  Task: TTask;
begin
  Task := TTask(FTaskList.Items[AIndex]);
  if Task <> nil then
  begin
    Task.FParams := nil;
    if Assigned(Task.FMS) then
      Task.FMS.Free;
    if Assigned(Task.FSL) then
      Task.FSL.Free;
    Task.Free;
  end;
  FTaskList.Delete(AIndex);
end;

constructor TTaskQueue.Create;
begin
  inherited Create;
  FMS := TMemoryStream.Create;
end;

destructor TTaskQueue.Destroy;
begin
  FMS.Free;
  inherited Destroy;
end;

procedure TTaskQueue.DoQueueRecv;
begin
  try
    if Assigned(FOnQueueRecv) then
      FOnQueueRecv(FQueueType, FMsg, FParams, FMS, FFileName);
  finally
    Free;
  end;
end;

procedure TTaskQueue.DoQueueProgress;
begin
  try
    if Assigned(FOnQueueProgress) then
      FOnQueueProgress(FStreamingType, FCnt, FTotCnt, FSpeed, FRemaining);
  finally
    Free;
  end;
end;

procedure TTaskQueue.QueueRecv;
begin
  try
    TThread.Queue(nil, @DoQueueRecv);
  except
    Free;
  end;
end;

procedure TTaskQueue.QueueProgress;
begin
  try
    TThread.Queue(nil, @DoQueueProgress);
  except
    Free;
  end;
end;


constructor TBaseThread.Create(ATCPBase: TTCPBase);
begin
  inherited Create(True);
  FTCPBase := ATCPBase;
  FUniqueID := GetUniqueID;
  FConnection := TConnection.Create;
  FBlockSocket := TTCPBlockSocket.Create;
  FBlockSocket.Family := SF_Any;
  FBlockSocket.RaiseExcept := False;
end;

destructor TBaseThread.Destroy;
begin
  FBlockSocket.Free;
  FConnection.Free;
  inherited Destroy;
end;

function TBaseThread.GetUniqueID: Integer;
begin
  EnterCriticalSection(FTCPBase.FTCP_CS);
  try
    Inc(FTCPBase.FUniqueID);
    Result := FTCPBase.FUniqueID;
  finally
    LeaveCriticalSection(FTCPBase.FTCP_CS);
  end;
end;

procedure TBaseThread.CopyConnection(ASrc, ADst: TConnection);
begin
  with ADst do
  begin
    FIP := ASrc.FIP;
    FHost := ASrc.FHost;
    FPort := ASrc.FPort;
    FUser := ASrc.FUser;
    FPass := ASrc.FPass;
    FProxy.FProxyType := ASrc.FProxy.FProxyType;
    FProxy.FProxyIP := ASrc.FProxy.FProxyIP;
    FProxy.FProxyPort := ASrc.FProxy.FProxyPort;
    FProxy.FProxyUser := ASrc.FProxy.FProxyUser;
    FProxy.FProxyPass := ASrc.FProxy.FProxyPass;
  end;
end;

procedure TBaseThread.SyncError;
begin
  if Assigned(FTCPBase.FOnError) then
    FTCPBase.FOnError(Self, FTCPBase.FErrMsg, FTCPBase.FErrCode, FConnection);
end;

procedure TBaseThread.SyncInternalMessage;
begin

  if Assigned(FTCPBase.FOnInternalMessage) then
    FTCPBase.FOnInternalMessage(Self, FInternalMsg);
end;

procedure TBaseThread.DoInternalMessage(AMsg: String);
begin
  if (FTCPBase.FActiveOrConnected) and (not FTCPBase.FHideInternalMessages) and (not FTCPBase.FIgnoreMessage) and (not Terminated) then
  begin
    FInternalMsg := AMsg;
    Synchronize(@SyncInternalMessage);
  end;
end;

procedure TBaseThread.DoError(AErrMsg: String; AErrCode: Integer);
begin
  if (FTCPBase.FActiveOrConnected) and (not FTCPBase.FHideErrorMessages) and (not Terminated) then
  begin
    FTCPBase.FErrMsg := AErrMsg;
    FTCPBase.FErrCode := AErrCode;
    Synchronize(@SyncError);
  end;
end;

constructor TClientThread.Create(ATCPBase: TTCPBase);
begin
  inherited Create(ATCPBase);
  //meu
  FTaskList := TTaskList.Create;
  FBaseType := btClient;
  FDisconnected := False;
  FOldCnt := 0;
  FTick := GetTickCount64;
end;

constructor TClientThread.Create(ATCPBase: TTCPBase; ASocket: TSocket);
begin
  inherited Create(ATCPBase);
  FTaskList := TTaskList.Create;
  FBaseType := btServer_AcceptedClient;
  FBlockSocket.Socket := ASocket;
  FDisconnected := False;
  FOldCnt := 0;
  FTick := GetTickCount64;
end;

destructor TClientThread.Destroy;
begin
  inherited Destroy;
  FTaskList.Free;
end;

procedure TClientThread.SetupProxy;
begin
  with FConnection.FProxy do
  begin
    case FProxyType of
      ptHTML:
        begin
          FBlockSocket.HTTPTunnelIP := FProxyIP;
          FBlockSocket.HTTPTunnelPort := FProxyPort;
          FBlockSocket.HTTPTunnelUser := FProxyUser;
          FBlockSocket.HTTPTunnelPass := FProxyPass;
          FBlockSocket.HTTPTunnelTimeout := TunnelTimeout;
        end;
      ptSocks4, ptSocks5:
        begin
          if FProxyType = ptSocks4 then
            FBlockSocket.SocksType := ST_Socks4
          else
            FBlockSocket.SocksType := ST_Socks5;
          FBlockSocket.SocksIP:= FProxyIP;
          FBlockSocket.SocksPort := FProxyPort;
          FBlockSocket.SocksUsername := FProxyUser;
          FBlockSocket.SocksPassword := FProxyPass;
          FBlockSocket.SocksTimeout := TunnelTimeout;
        end;
      ptNone:
        begin
          FBlockSocket.HTTPTunnelIP := '';
          FBlockSocket.SocksIP := '';
        end;
    end;
  end;
end;

procedure TClientThread.SyncConnect;
begin
  if Assigned(FTCPBase.FOnConnect) then
    FTCPBase.FOnConnect(Self, FConnection);
end;

procedure TClientThread.SyncDisconnect;
begin
  case FBaseType of
    btClient:
      TTCPClient(FTCPBase).Remove(Self);
    btServer, btServer_AcceptedClient:
      TTCPServer(FTCPBase).Remove(Self);
  end;
end;

procedure TClientThread.QueueProgress(AStreamingType: TStreamingType; ACnt, ATotCnt: Int64; ASpeed, ARemaining: LongInt);
begin
  if Assigned(FTCPBase.FOnProgress) then
    FTCPBase.FOnProgress(Self, AStreamingType, ACnt, ATotCnt, ASpeed, ARemaining, FConnection);
end;

procedure TClientThread.DoConnect;
begin
  if (FTCPBase.FActiveOrConnected) and (not Terminated) then
    Synchronize(@SyncConnect);
end;

procedure TClientThread.DoDisconnect;
begin
  if (FTCPBase.FActiveOrConnected) and (not Terminated) then
    Queue(@SyncDisconnect)
end;

procedure TClientThread.QueueRecv(AQueueType: Integer; AMsg: String;
  AParams: TStringArray; AMS: TMemoryStream; AFileName: String = '');
begin
  if (FTCPBase.FActiveOrConnected) and (not Terminated) then
  case AQueueType of
    0: if Assigned(FTCPBase.FOnRecvMessage) then
         FTCPBase.FOnRecvMessage(Self, AMsg, AParams, FConnection);
    1: if Assigned(FTCPBase.FOnRecvStream) then
         FTCPBase.FOnRecvStream(Self, AMsg, AParams, AMS, FConnection);
    2: if Assigned(FTCPBase.FOnRecvFile) then
         FTCPBase.FOnRecvFile(Self, AMsg, AParams, AFileName, FConnection);
  end;
end;

procedure TClientThread.DoRecv(AQueueType: Integer; AMsg: String; AParams: TStringArray;
  AMS: TMemoryStream; AFileName: String = '');
var
  TaskQueue: TTaskQueue;
begin
  if (FTCPBase.FActiveOrConnected) and (not Terminated) and (not FNeedToBreak) then
  begin
    TaskQueue := TTaskQueue.Create;
    TaskQueue.FQueueType := AQueueType;
    TaskQueue.FMsg := AMsg;
    TaskQueue.FParams := AParams;
    SetLength(TaskQueue.FParams, Length(AParams));
    if AMS <> nil then
      TaskQueue.FMS.CopyFrom(AMS, AMS.Size);
    if AFileName <> '' then
      TaskQueue.FFileName := AFileName;
    TaskQueue.OnQueueRecv := @QueueRecv;
    TaskQueue.QueueRecv;
  end;
end;

procedure TClientThread.DoProgress(AStreamingType: TStreamingType; ACnt, ATotCnt: Int64);
var
  ElapsedSec: Single;
  Speed: LongInt;
  Remaining: LongInt;
  Tick: QWord;
  Diff: QWord;
  TaskQueue: TTaskQueue;
begin
  if (FTCPBase.FActiveOrConnected) and (not Terminated) then
  begin
    Tick := GetTickCount64;
    Diff  := Tick - FTick;
    ElapsedSec := Diff/1000;
    if (CompareValue(ElapsedSec, 0.50) = 1) or (ACnt >= ATotCnt) then
    begin
      Speed := Round((ACnt - FOldCnt)/ElapsedSec);
      if Speed < 0 then
        Speed := 0;
      FTick := Tick;
      FOldCnt := ACnt;
      if Speed > 0 then
        Remaining := Round((ATotCnt - ACnt)/Speed);

      TaskQueue := TTaskQueue.Create;
      TaskQueue.FStreamingType := AStreamingType;
      TaskQueue.FCnt := ACnt;
      TaskQueue.FTotCnt := ATotCnt;
      TaskQueue.FSpeed := Speed;
      TaskQueue.FRemaining := Remaining;
      TaskQueue.OnQueueProgress := @QueueProgress;
      TaskQueue.QueueProgress;
    end;
  end;
end;

function TClientThread.GetExtendedConnectionInfo: Boolean;
begin
  Result := True;
  FBlockSocket.GetSins;
  if FBlockSocket.LastError <> 0 then
  begin
    Result := False;
    DoError(FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
    Exit;
  end;
  with FConnection.FExtendedInfo do
  begin
    FLocalIP := FBlockSocket.GetLocalSinIP;
    FLocalPort := FBlockSocket.GetLocalSinPort;
    FRemoteIP := FBlockSocket.GetRemoteSinIP;
    FRemotePort := FBlockSocket.GetRemoteSinPort;
    FRemoteHost := FBlockSocket.ResolveIPToName(FRemoteIP);
  end;
end;

function TClientThread.SendMessage(AMsg: String; AParams: array of String): Boolean;
var
  I: Integer;
  Msg: String;
begin
  Result := False;
  if not FTCPBase.FActiveOrConnected then
    Exit;
  Msg := AMsg;
  if Length(AParams) > 0 then
  begin
    AMsg := AMsg + ':';
    for I := Low(AParams) to High(AParams) do
      AMsg := AMsg + AParams[I] + ',';
  end;
  AMsg := Encrypt(FConnection.FPort, AMsg);
  FBlockSocket.SendString(AMsg);
  Result := FBlockSocket.LastError = 0;
  Delete(Msg, 1, 1);
  FTCPBase.FIgnoreMessage := (Msg = 'BROADCASTSCREEN') or (Msg = 'PING');
  if Result then
    DoInternalMessage(Format(rsMessageSent, [Msg, FConnection.FExtendedInfo.FRemoteIP]))
  else
    DoError(Format(rsMessageSentError, [Msg]) + FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
end;

function TClientThread.RecvMessage(ATimeOut: Integer; out AMsgTyp: Integer;
  out AMsg: String; out AParams: TStringArray): Boolean;
var
  Str: String;
  P: Integer;
  Len: Integer;
begin
  Result := True;
  AMsg := '';
  AMsgTyp := -1;
  AParams := nil;
  Str := FBlockSocket.RecvPacket(ATimeOut);
  if (FBlockSocket.LastError > 0) and (FBlockSocket.LastError <> WSAETIMEDOUT) then
  begin
    Result := False;
    DoError(FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
    Exit;
  end;
  if Trim(Str) <> '' then
  begin
    Str := Decrypt(FConnection.FPort, Str);
    P := Pos(':', Str);
    if P > 0 then
    begin
      AMsg := Trim(System.Copy(Str, 1, P - 1));
      System.Delete(Str, 1, P);
      repeat
        P := Pos(',', Str);
        if P > 0 then
        begin
          Len := Length(AParams);
          SetLength(AParams, Len + 1);
          AParams[Len] := System.Copy(Str, 1, P - 1);
          System.Delete(Str, 1, P);
        end;
      until (P = 0) or (Str = '') ;
    end
    else
      AMsg := Trim(Str);
    AMsgTyp := StrToIntDef(AMsg[1], -1);
    if (not AMsgTyp in [0..3]) then
    begin
      DoError(rsInvalidMessage , 0);
      Result := False;
      Exit;
    end;
    Delete(AMsg, 1, 1);
    FTCPBase.FIgnoreMessage := (AMsg = 'BROADCASTSCREEN') or (AMsg = 'PING');
    DoInternalMessage(Format(rsMessageRecv, [AMsg, FConnection.FExtendedInfo.FRemoteIP]));
  end;
end;

function TClientThread.SendStream(AMS: TMemoryStream): Boolean;
var
  ReadCnt: LongInt;
  Cnt: Int64;
  Buffer: Pointer;
  Ms: TMemoryStream;
  MsComp: TMemoryStream;
  Msg: String;
  CompRate: Single;
begin
  Result := False;
  if not FTCPBase.FActiveOrConnected then
    Exit;
  if FBlockSocket.LastError > 0 then
  begin
    DoError(Format(rsStreamSentError, [FConnection.FExtendedInfo.FRemoteIP]) + FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
    Exit;
  end;
  FOldCnt := 0;
  MS := TMemoryStream.Create;
  try
    AMS.Position := 0;
    MSComp := TMemoryStream.Create;
    try
      GetMem(Buffer, FBlockSocket.SendMaxChunk);
      try
        Cnt := 0;
        repeat
           if FNeedToBreak then
             Break;
           Msg :=  FBlockSocket.RecvPacket(50000);
           if (FBlockSocket.LastError > 0) or (Msg = 'DONE') or (Msg <> 'NEXT') then
             Break;
           ReadCnt := AMS.Read(Buffer^, FBlockSocket.SendMaxChunk);
           if (ReadCnt > 0) then
           begin
             MS.Clear;
             MS.Write(Buffer^, ReadCnt);
             MS.Position := 0;
             if FTCPBase.FCompress and  CompressStream(Ms, MsComp, clBestCompression, CompRate) then
               FBlockSocket.SendStream(MSComp)
             else
               FBlockSocket.SendStream(MS);
             if (FBlockSocket.LastError > 0) and (FBlockSocket.LastError <> WSAETIMEDOUT) then
               Break;
             if (FBlockSocket.LastError = 0) and (FTCPBase.FActiveOrConnected) then
             begin
               Cnt := Cnt + MS.Size;
               DoProgress(stUpload, Cnt, AMS.Size);
             end;
           end;
        until (ReadCnt = 0) or (Cnt > AMS.Size);
        Result := FBlockSocket.LastError = 0;
        if Result then
          DoInternalMessage(Format(rsStreamSent, [FormatSize(AMS.Size), FConnection.FExtendedInfo.FRemoteIP]))
        else
          DoError(Format(rsStreamSentError, [FConnection.FExtendedInfo.FRemoteIP]) + FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
      finally
        FreeMem(Buffer);
      end;
    finally
      MsComp.Free;
    end;
  finally
    MS.Free;
  end;
end;

function TClientThread.RecvStream(AMS: TMemoryStream): Boolean;
var
  Cnt: Int64;
  MS: TMemoryStream;
  MSDecomp: TMemoryStream;
begin
  Result := False;
  if not FTCPBase.FActiveOrConnected then
    Exit;
  MS := TMemoryStream.Create;
  try
    Cnt := 0;
    MSDecomp := TMemoryStream.Create;
    try
      repeat
         if FNeedToBreak then
           Break;
         FBlockSocket.SendString('NEXT');
         MS.Clear;
         FBlockSocket.RecvStream(Ms, 5000);
         if (FBlockSocket.LastError > 0) and (FBlockSocket.LastError <> WSAETIMEDOUT) then
           Break;
         if (MS.Size > 0) and (FBlockSocket.LastError = 0) and (FTCPBase.FActiveOrConnected) then
         begin
           MS.Position := 0;
           if FTCPBase.FCompress and DecompressStream(MS, MSDecomp) then
           begin
             AMS.CopyFrom(MSDecomp, MSDecomp.Size);
             Cnt := Cnt + MSDecomp.Size;
             DoProgress(stDownload, Cnt, AMS.Size);
           end
           else
           begin
             AMS.CopyFrom(MS, MS.Size);
             Cnt := Cnt + MS.Size;
             DoProgress(stDownload, Cnt, AMS.Size);
           end;
         end;
      until (Cnt >= AMS.Size);
      FBlockSocket.SendString('DONE');
      Result := FBlockSocket.LastError = 0;
      if Result then
      begin
        DoInternalMessage(Format(rsStreamRecv, [FormatSize(AMS.Size), FConnection.FExtendedInfo.FRemoteIP]));
        AMS.Position := 0
      end
      else
        DoError(Format(rsStreamRecvError, [FConnection.FExtendedInfo.FRemoteIP]) + FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
    finally
      MSDecomp.Free;
    end;
  finally
    MS.Free;
  end
end;

function TClientThread.SendFile(AFileName: String): Boolean;
var
  ReadCnt: LongInt;
  Cnt: Int64;
  Buffer: Pointer;
  MS: TMemoryStream;
  MSComp: TMemoryStream;
  FS: TFileStream;
  Msg: String;
  CompRate: Single;
begin
  Result := False;
  if not FTCPBase.FActiveOrConnected then
    Exit;
  if FBlockSocket.LastError > 0 then
  begin
    DoError(Format(rsFileSentError, [FConnection.FExtendedInfo.FRemoteIP]) + FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
    Exit;
  end;
  try
    FS := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
    try
      FS.Position := 0;
      GetMem(Buffer, FBlockSocket.SendMaxChunk);
      try
        Cnt := 0;
        MS := TMemoryStream.Create;
        try
          MSComp := TMemoryStream.Create;
          try
            repeat
              if FNeedToBreak then
                Break;
              Msg := FBlockSocket.RecvPacket(50000);
              if (FBlockSocket.LastError > 0) or (Msg = 'DONE') or (Msg <> 'NEXT') then
                Break;
              ReadCnt := FS.Read(Buffer^, FBlockSocket.SendMaxChunk);
              if (ReadCnt > 0) then
              begin
                MS.Clear;
                MS.Write(Buffer^, ReadCnt);
                MS.Position := 0;
                if FTCPBase.FCompress and CompressStream(Ms, MsComp, clBestCompression, CompRate) then
                  FBlockSocket.SendStream(MSComp)
                else
                  FBlockSocket.SendStream(MS);
                if (FBlockSocket.LastError > 0) and (FBlockSocket.LastError <> WSAETIMEDOUT) then
                  Break;
                if (FBlockSocket.LastError = 0) and (FTCPBase.FActiveOrConnected) then
                begin
                  Cnt := Cnt + MS.Size;
                  DoProgress(stUpload, Cnt, FS.Size);
                end;
              end;
            until (ReadCnt = 0) or (Cnt > FS.Size);
            Result := FBlockSocket.LastError = 0;
            if Result then
              DoInternalMessage(Format(rsFileSent, [FormatSize(FS.Size), FConnection.FExtendedInfo.FRemoteIP]))
            else
              DoError(Format(rsFileSentError, [FConnection.FExtendedInfo.FRemoteIP]) + FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
          finally
            MSComp.Free;
          end;
        finally
          MS.Free;
        end;
      finally
        FreeMem(Buffer);
      end;
    finally
      FS.Free;
    end;
  except
    on E: Exception do
      DoError(Format(rsFileSentError, [FConnection.FExtendedInfo.FRemoteIP]) + E.Message, 0);
  end
end;

function TClientThread.RecvFile(AFileName: String; ASize: Int64): Boolean;
var
  Cnt: Int64;
  MS: TMemoryStream;
  MSDecomp: TMemoryStream;
  FS: TFileStream;
begin
  Result := False;
  if not FTCPBase.FActiveOrConnected then
    Exit;
  try
    FS := TFileStream.Create(AFileName, fmCreate or fmOpenReadWrite or fmShareDenyWrite);
    try
      MS := TMemoryStream.Create;
      try
        Cnt := 0;
        MSDecomp := TMemoryStream.Create;
        try
          repeat
             if FNeedToBreak then
               Break;
             FBlockSocket.SendString('NEXT');
             MS.Clear;
             FBlockSocket.RecvStream(MS, 5000);
             if (FBlockSocket.LastError > 0) and (FBlockSocket.LastError <> WSAETIMEDOUT) then
               Break;
             if (MS.Size > 0) and (FBlockSocket.LastError = 0) and (FTCPBase.FActiveOrConnected) then
             begin
               MS.Position := 0;
               if FTCPBase.FCompress and DecompressStream(MS, MSDecomp) then
               begin
                  FS.CopyFrom(MsDecomp, MSDecomp.Size);
                  Cnt := Cnt + MSDecomp.Size;
                  DoProgress(stDownload, Cnt, ASize);
               end
               else
               begin
                 FS.CopyFrom(MS, MS.Size);
                 Cnt := Cnt + MS.Size;
                 DoProgress(stDownload, Cnt, ASize);
               end;
             end;
          until (Cnt >= ASize);
          FBlockSocket.SendString('DONE');
          Result := FBlockSocket.LastError = 0;
          if Result then
            DoInternalMessage(Format(rsFileRecv, [FormatSize(ASize), FConnection.FExtendedInfo.FRemoteIP]))
          else
            DoError(Format(rsFileRecvError, [FConnection.FExtendedInfo.FRemoteIP]) + FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
        finally
          MSDecomp.Free;
        end;
      finally
        MS.Free;
      end
    finally
      FS.Free;
    end;
  except
    on E: Exception do
      DoError(Format(rsFileRecvError, [FConnection.FExtendedInfo.FRemoteIP]) + E.Message, 0);
  end
end;

function TClientThread.ProcessTask(ATask: TTask): Boolean;
begin
  case ATask.FName of
    'MESSAGE':
       begin
         ATask.FMsg := '0' + ATask.FMsg;
         Result := SendMessage(ATask.FMsg, ATask.FParams);
       end;
    'STREAM':
       begin
         ATask.FMsg := '1' + ATask.FMsg;
         SetLength(ATask.FParams, Length(ATask.FParams) + 1);
         ATask.FParams[Length(ATask.FParams) - 1] := IntToStr(ATask.FMS.Size);
         Result := SendMessage(ATask.FMsg, ATask.FParams);
         if Result then
           Result := SendStream(ATask.FMS);
      end;
    'FILE':
       begin
         ATask.FMsg := '2' + ATask.FMsg;
         SetLength(ATask.FParams, Length(ATask.FParams) + 2);
         ATask.FParams[Length(ATask.FParams) - 2] := IntToStr(FileSize(ATask.FileName));
         ATask.FParams[Length(ATask.FParams) - 1] := ExtractFileName(ATask.FileName);
         Result := SendMessage(ATask.FMsg, ATask.FParams);
         if Result then
           Result := SendFile(ATask.FileName);
       end;
  end;
end;

procedure TClientThread.AcquireList(out AList: TList);
var
  I: Integer;
begin
  AList := TList.Create;
  EnterCriticalSection(FTaskList.FTaskCS);
  try
    for I := FTaskList.TaskList.Count - 1  downto 0 do
    begin
      AList.Add(TTask(FTaskList.TaskList.Items[I]));
      FTaskList.TaskList.Delete(I);
    end;
  finally
    LeaveCriticalSection(FTaskList. FTaskCS);
  end;
end;

procedure TClientThread.FreeList(AList: TList);
var
  I: Integer;
  Task: TTask;
begin
  for I := AList.Count - 1 downto 0 do
  begin
    Task := TTask(AList.Items[I]);
    if Task <> nil then
    begin
      Task.FParams := nil;
      if Assigned(Task.FMS) then
        Task.FMS.Free;
      if Assigned(Task.FSL) then
        Task.FSL.Free;
      Task.Free;
    end;
    AList.Delete(I);
  end;
  AList.Free;
end;

function TClientThread.AddDirSeparator(const Path: String): String;
begin
  if (Trim(Path) <> '') and (not (Path[Length(Path)] in AllowDirectorySeparators)) then
    Result := Path + PathDelim
  else
    Result := Path;
end;

function TClientThread.GetDownloadDir(const APath: String): String;
begin
  if Trim(APath) = '' then
  begin
    Result := AddDirSeparator(GetUserDir) + 'Downloads';
    Exit;
  end;
  Result := AddDirSeparator(APath);
  if not DirectoryExists(Result) then
  begin
    if not CreateDir(Result) then
      Result := AddDirSeparator(GetUserDir) + 'Downloads';
  end
end;

procedure TClientThread.Execute;
var
  Msg: String;
  MsgTyp: Integer;
  Params: TStringArray;
  Size: Int64;
  MS: TMemoryStream;
  I: Integer;
  FileName: String;
  Path: String;
  TmpTaskList: TList;
  FCurPing: QWord;
begin
  FLastPing := GetTickCount64;
  while not Terminated do
  begin
    if (not FBusy) and (FTaskList.TaskList.Count > 0) and (not FNeedToBreak) then
    begin
      FBusy := True;
      try
        AcquireList(TmpTaskList);
        try
          for I := TmpTaskList.Count - 1 downto 0 do
          begin
            if FNeedToBreak then
              Break;
            if ProcessTask(TTask(TmpTaskList[I])) then
              FLastPing := GetTickCount64;
          end;
        finally
          FreeList(TmpTaskList);
        end;
      finally
        FBusy := False;
      end;
    end;

    if not RecvMessage(500, MsgTyp, Msg, Params) then
    begin
      DoDisconnect;
      Break;
    end;
    case MsgTyp of
      0: begin
           FLastPing := GetTickCount64;
           if not FTCPBase.FIgnoreMessage then
             DoRecv(0, Msg, Params, nil);
         end;
      1: begin
           FLastPing := GetTickCount64;
           Size := StrToInt64Def(Params[Length(Params) - 1], -1);
           if Size > 0 then
           begin
             SetLength(Params, Length(Params) - 1);
             MS := TMemoryStream.Create;
             try
               MS.SetSize(Size);
               MS.Position := 0;
               if RecvStream(MS) then
                 DoRecv(1, Msg, Params, MS);
             finally
               MS.Free;
             end;
           end
         end;
      2: begin
           FLastPing := GetTickCount64;
           Size := StrToInt64Def(Params[Length(Params) - 2], -1);
           FileName := Params[Length(Params) - 1];
           SetLength(Params, Length(Params) - 2);
           if Size > 0 then
           begin
             Path := AddDirSeparator(GetDownloadDir(FTCPBase.FDownloadDirectory));
             if DirectoryExists(Path) then
             begin
               Path := Path + FConnection.FUser  + '_'  + FileName;
               if RecvFile(Path, Size) then
                 DoRecv(2, Msg, Params, nil, Path)
             end
             else
               DoError(rsInvalidDirectory, 0);
           end
           else
             FileCreate(Params[0] + Params[1]);
         end;
    end;
    if (FTCPBase.FTCPBaseType = tcpServer) then
    begin
      FCurPing := GetTickCount64;
      if (FCurPing - FLastPing > PingTimeoutServer) then
      begin
        DoDisconnect;
        Break;
      end;
    end
    else if (FTCPBase.FTCPBaseType = tcpClient) then
    begin
      FCurPing := GetTickCount64;
      if (FTaskList.TaskList.Count = 0) and (FCurPing - FLastPing > PingTimeoutClient) then
        FTaskList.AddTask('MESSAGE', 'PING', [], nil, '');
    end;
  end;
  FDisconnected := True;
  while not Terminated do
    Sleep(100);
end;

constructor TServerThread.Create(ATCPBase: TTCPBase);
begin
  inherited Create(ATCPBase);
  FBaseType := btServer;
end;

destructor TServerThread.Destroy;
begin
  inherited Destroy;
end;

function TServerThread.DoLogin(ACT: TClientThread): Boolean;
var
  Msg: String;
  MsgTyp: Integer;
  Params: TStringArray;
  UserID: Integer;
begin
  Result := False;

  if ACT.RecvMessage(Timeout, MsgTyp, Msg, Params) then
  begin
    if Length(Params) < 3 then
      Exit;
    if (MsgTyp = 0) and (Msg = 'LOGIN') and (Length(Params) >= 2) and (Params[0] = ACT.FConnection.FPass) then
    begin
      if Trim(Params[1]) = '' then
        Params[1] := 'anonymous';
      UserID := TTCPServer(FTCPBase).FindUser(Params[1]);
      if UserID = -1 then
      begin
       Result := True;
       TTCPServer(FTCPBase).FUserList.Add(Params[1]);
       ACT.FConnection.FUser := Params[1];
       ACT.SendMessage('0LOGINREPLY', ['SUCCESS']);
       ACT.DoConnect;
      end
      else
      begin
        ACT.SendMessage('0LOGINREPLY', ['FAILEDDUPLICATE']);
        DoInternalMessage(Format(rsConnectionRejectedDuplicate, [ACT.FConnection.FExtendedInfo.FRemoteIP + '(' + ACT.FConnection.FExtendedInfo.FRemoteHost + ')']));
      end;
    end
    else
    begin
      ACT.SendMessage('0LOGINREPLY', ['FAILEDINVALID']);
      DoInternalMessage(Format(rsConnectionRejectedInvalid, [ACT.FConnection.FExtendedInfo.FRemoteIP + '(' + ACT.FConnection.FExtendedInfo.FRemoteHost + ')']));
    end;
  end;
end;

procedure TServerThread.Execute;
var
  CT: TClientThread;
  Socket: TSocket;
begin
  while not Terminated do
  begin
    if FTCPBase.FActiveOrConnected and FBlockSocket.CanRead(1000) then
    begin
      Socket := FBlockSocket.Accept;
      if FBlockSocket.LastError = 0 then
      begin
        CT := TClientThread.Create(FTCPBase, Socket);
        CT.CopyConnection(FConnection, CT.FConnection);
        CT.FConnection.FUniqueID := CT.FUniqueID;
        CT.FConnection.FDateTime := Now;
        if CT.GetExtendedConnectionInfo then
        begin
          if DoLogin(CT) then
          begin
            FTCPBase.FThreadList.Add(CT);
            CT.Start;
          end
          else
          begin
            CT.Free;
            CT := nil;
          end;
        end
        else
          DoError(FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
      end
      else
        DoError(FBlockSocket.LastErrorDesc, FBlockSocket.LastError);
    end;
  end;
end;

constructor TTCPBase.Create;
begin
  InitCriticalSection(FTCP_CS);
  FThreadList := TThreadList.Create;
  FUniqueID := -1;
end;

destructor TTCPBase.Destroy;
begin
  FThreadList.Free;
  DoneCriticalsection(FTCP_CS);
  inherited Destroy;
end;

function TTCPBase.FindThread(const AUniqueID: Integer): TBaseThread;
var
  List: TList;
  I: Integer;
begin
  Result := nil;
  List := FThreadList.LockList;
  try
    for I := 0 to List.Count - 1 do
    begin
      if (TBaseThread(List.Items[I]).FUniqueID = AUniqueID) then
      begin
        Result := TBaseThread(List.Items[I]);
        Break;
      end;
    end;
  finally
    FThreadList.UnlockList;
  end;
end;

function TTCPBase.IsMessageInvalid(const AMsg: String): Boolean;
begin
  Result := False;
  if Trim(AMsg) = '' then
    Exit;
  Result := AMsg[1] in ['0', '1', '2', '3'];
  if Result then
    raise Exception.Create('Messages cannot begin with "0", "1", "2" or "3"');
end;

function TTCPBase.SendMessage(AMsg: String; AParams: array of String;
  const AUniqueID: Integer = 0): Boolean;
var
  CT: TClientThread;
begin
  Result := False;
  if IsMessageInvalid(AMsg) then
    Exit;
  if FActiveOrConnected then
  begin
    case FTCPBaseType of
      tcpClient: CT := TClientThread(TTCPClient(Self).FindThread(AUniqueID));
      tcpServer: CT := TClientThread(TTCPServer(Self).FindThread(AUniqueID));
    end;
    if CT <> nil then
      Result := CT.FTaskList.AddTask('MESSAGE', AMsg, AParams) <> -1;
  end
end;

function TTCPBase.SendStream(AMsg: String; AParams: array of String;
  AMS: TMemoryStream; const AUniqueID: Integer = 0): Boolean;
var
  CT: TClientThread;
begin
  Result := False;
  if IsMessageInvalid(AMsg) then
    Exit;
  if FActiveOrConnected then
  begin
    case FTCPBaseType of
      tcpClient: CT := TClientThread(TTCPClient(Self).FindThread(AUniqueID));
      tcpServer: CT := TClientThread(TTCPServer(Self).FindThread(AUniqueID));
    end;
    if CT <> nil then
    begin
      if AMS.Size = 0 then
        CT.DoError('Stream size is zero.', 0)
      else
        Result := CT.FTaskList.AddTask('STREAM', AMsg, AParams, AMS) <> -1;
    end;
  end;
end;

function TTCPBase.SendFile(AMsg: String; AParams: array of String;
  AFileName: String; const AUniqueID: Integer): Boolean;
var
  CT: TClientThread;
begin
  if IsMessageInvalid(AMsg) then
    Exit;
  if FActiveOrConnected then
  begin
    case FTCPBaseType of
      tcpClient: CT := TClientThread(TTCPClient(Self).FindThread(AUniqueID));
      tcpServer: CT := TClientThread(TTCPServer(Self).FindThread(AUniqueID));
    end;
    if CT <> nil then
    begin
      if not FileExists(AFileName) then
        CT.DoError('File does not exists.', 0)
      else
        Result := CT.FTaskList.AddTask('FILE', AMsg, AParams, nil, AFileName) <> -1;
    end;
  end;
end;

constructor TTCPClient.Create;
begin
  inherited Create;
  FActiveOrConnected := False;
  FTCPBaseType := tcpClient;
end;

destructor TTCPClient.Destroy;
begin
  Disconnect(False);
  inherited Destroy;
end;

procedure TTCPClient.Remove(AThread: TBaseThread);
var
  List: TList;
begin
  case TClientThread(AThread).FClientType of
    ctWorker:
      begin
        List := FThreadList.LockList;
        try
          List.Remove(AThread);
          TClientThread(AThread).FNeedToBreak := True;
          TClientThread(AThread).FBlockSocket.CloseSocket;
          TClientThread(AThread).FDisconnected := True;
          TClientThread(AThread).Terminate;
          TClientThread(AThread).WaitFor;
          TClientThread(AThread).Free;
          AThread := nil;
        finally
          FThreadList.UnlockList;
        end;
      end;
    ctMain:
      Disconnect(False);
  end;
end;

function TTCPClient.DoConnect(ACT: TClientThread): Boolean;
begin
  Result := False;
  ACT.FBlockSocket.Connect(ACT.FConnection.FIP, ACT.FConnection.FPort);
  if ACT.FUseProxy then
  begin
    if (ACT.FConnection.FProxy.FProxyType = ptSocks5) or (ACT.FConnection.FProxy.FProxyType = ptSocks4) then
    begin
      if ACT.FBlockSocket.LastError = 0 then
      begin
        ACT.FBlockSocket.RecvPacket(TunnelTimeout);
        Result := (ACT.FBlockSocket.LastError = 0) or ((ACT.FBlockSocket.LastError > 0)  and (ACT.FBlockSocket.LastError = WSAETIMEDOUT));
      end;
    end
    else
      Result := (ACT.FBlockSocket.LastError = 0);
  end
  else
    Result := (ACT.FBlockSocket.LastError = 0);
  if Result then
    Result := ACT.GetExtendedConnectionInfo;
end;

function TTCPClient.DoLogin(ACT: TClientThread): Integer;
var
  Msg: String;
  MsgTyp: Integer;
  Params: TStringArray;
begin
  Result := 0;
  ACT.SendMessage('0LOGIN', [ACT.FConnection.FPass, ACT.FConnection.FUser, IntToStr(Ord(ACT.FClientType))]);
  if (ACT.FBlockSocket.LastError > 0) then
    Exit;
  if ACT.RecvMessage(TimeOut, MsgTyp, Msg, Params) then
  begin
    Result := 1;
    if (MsgTyp = 0) and (Msg = 'LOGINREPLY') then
    begin
      if (Params[0] = 'FAILEDINVALID') then
        Result := 1
      else if (Params[0] = 'FAILEDDUPLICATE') then
        Result := 2
      else if (Params[0] = 'SUCCESS') then
        Result := 3
    end;
  end;
end;

procedure TTCPClient.Connect(const AConnection: TConnection);
var
  Login: Integer;
    CT: TClientThread;
begin

CT := TClientThread.Create(self);
  CT.FClientType := ctMain;
 CT.CopyConnection(AConnection, CT.FConnection);
  CT.FUniqueID := 0;
  CT.FConnection.FUniqueID := 0;
  CT.FUseProxy := AConnection.FProxy.FProxyType <> ptNone;
  if CT.FUseProxy then
    CT.SetupProxy;
  if DoConnect(CT) then
  begin
    FActiveOrConnected := True;
    Login := DoLogin(CT);
    case Login of
      0: begin
           FErrMsg := CT.FBlockSocket.LastErrorDesc;
           FErrCode := CT.FBlockSocket.LastError;
           FActiveOrConnected := False;
         end;
      1: begin
           FErrMsg := rsInvalidUserNameOrPassword;
           FErrCode := 10013;
           FActiveOrConnected := False;
         end;
      2: begin
           FErrMsg := rsInvalidDuplicateUser;
           FErrCode := 10013;
           FActiveOrConnected := False;
         end;
      3: begin
           CT.DoConnect;
           FThreadList.Add(CT);
           CT.Start;
           Exit;
         end;
    end;
  end
  else
  begin
    FErrMsg := CT.FBlockSocket.LastErrorDesc;
    FErrCode := CT.FBlockSocket.LastError;
    FActiveOrConnected := False;
  end;

  if Assigned(FOnError) then
    FOnError(Self, FErrMsg, FErrCode, CT.FConnection);
  CT.FBlockSocket.CloseSocket;
  CT.Free;
  CT := nil;
end;

procedure TTCPClient.Cleanup;
var
  List: TList;
  I: Integer;
  Thread: TBaseThread;
begin
  List := FThreadList.LockList;
  try
    for I := List.Count - 1 downto 0 do
    begin
       Thread := TBaseThread(List.Items[I]);
       if Thread = nil then
         Continue;
       if (Thread.FBaseType = btClient) and (TClientThread(Thread).FClientType = ctMain) then
         if Assigned(FOnDisconnect) then
           FOnDisconnect(Self, TClientThread(Thread).FConnection, FByUser);
       Thread.FNeedToBreak := True;
       Thread.FBlockSocket.CloseSocket;
       Thread.FDisconnected := True;
       Thread.Terminate;
       Thread.WaitFor;
       Thread.Free;
       Thread := nil;
    end;
  finally
    FThreadList.UnlockList;
  end;
  FThreadList.Clear;
end;

procedure TTCPClient.Disconnect(const AByUser: Boolean);
begin
  FByUser := AByUser;
  FActiveOrConnected := False;
  Cleanup;
end;

constructor TTCPServer.Create;
begin
  inherited Create;
  FActiveOrConnected := False;
  FTCPBaseType := tcpServer;
  FUserList := TStringList.Create;
end;

destructor TTCPServer.Destroy;
begin
  FUserList.Clear;
  FUserList.Free;
  Stop;
  inherited Destroy;
end;

procedure TTCPServer.Remove(AThread: TBaseThread);
var
  List: TList;
  UserID: Integer;
begin
  case TBaseThread(AThread).FBaseType of
    btServer_AcceptedClient:
      begin
        if Assigned(FOnDisconnect) then
           FOnDisconnect(Self, TClientThread(AThread).FConnection, False);
        List := FThreadList.LockList;
        try
          List.Remove(AThread);
          UserID := FindUser(TClientThread(AThread).FConnection.FUser);
          if UserID <> -1 then
            FUserList.Delete(UserID);
          TClientThread(AThread).FNeedToBreak := True;
          TClientThread(AThread).FBlockSocket.CloseSocket;
          TClientThread(AThread).FDisconnected := True;
          TClientThread(AThread).Terminate;
          TClientThread(AThread).WaitFor;
          TClientThread(AThread).Free;
          AThread := nil;
        finally
          FThreadList.UnlockList;
        end;
      end;
    btServer:
      Stop;
    else
      Exit;
  end;
end;

function TTCPServer.FindUser(AUserName: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FUserList.Count - 1 do
  begin
    if UpperCase(FUserList.Strings[I]) = UpperCase(AUserName) then
    begin
      Result  := I;
      Break;
    end;
  end;
end;

procedure TTCPServer.DisconnectClient(AUniqueID: Integer);
var
  List: TList;
  I: Integer;
begin
  List := FThreadList.LockList;
  try
    for I := List.Count - 1 downto 0 do
      if TBaseThread(List.Items[I]).FUniqueID = AUniqueID then
      begin
        Remove(TBaseThread(List.Items[I]));
        Break;
      end;
  finally
    FThreadList.UnlockList;
  end;
end;

function TTCPServer.IsClientConnected(AUniqueID: Integer): Boolean;
var
  Thread: TBaseThread;
begin
  Thread := FindThread(AUniqueID);
  Result := (Thread <> nil) and (not Thread.FDisconnected);
end;

procedure TTCPServer.Start(ABindConnection: TConnection);
var
  ST: TServerThread;
begin
  ST := TServerThread.Create(Self);
  with ST.FBlockSocket do
  begin
    ST.CopyConnection(ABindConnection, ST.FConnection);
    ST.FUniqueID := 0;
    CreateSocket;
    SetLinger(True, 10000);
    Bind(ST.FConnection.FIP, ST.FConnection.FPort);
    Listen;
    FActiveOrConnected := True;
    if LastError = 0 then
    begin
      FThreadList.Add(ST);
      ST.Start;
    end
    else
    begin
      ST.DoError(ST.FBlockSocket.LastErrorDesc, ST.FBlockSocket.LastError);
      ST.Free;
      FActiveOrConnected := False;
    end;
  end;
end;

procedure TTCPServer.Cleanup;
var
  List: TList;
  I: Integer;
  Thread: TBaseThread;
begin
  List := FThreadList.LockList;
  try
    for I := List.Count - 1 downto 0 do
    begin
       Thread := TBaseThread(List.Items[I]);
       if Thread = nil then
         Continue;
       if (Thread.FBaseType = btServer_AcceptedClient) then
         if Assigned(FOnDisconnect) then
           FOnDisconnect(Self, TClientThread(Thread).FConnection, False);
       Thread.FNeedToBreak := True;
       Thread.FBlockSocket.CloseSocket;
       Thread.FDisconnected := True;
       Thread.Terminate;
       Thread.WaitFor;
       Thread.Free;
       Thread := nil;
    end;
  finally
    FThreadList.UnlockList;
  end;
  FThreadList.Clear;
end;

procedure TTCPServer.Stop;
begin
  if FActiveOrConnected then
  begin
    FActiveOrConnected := False;
    Cleanup;
  end;
end;

end.
