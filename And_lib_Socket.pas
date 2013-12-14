//
// Just Test Socket
//
//
//
//
//
unit And_lib_Socket;

{$mode delphi}

interface

uses
  Classes, SysUtils,
  sockets, baseunix,errors,termio,
  And_jni,And_jni_Bridge, Laz_And_Controls,
  ComModule_,
  LogManage;

CONST
  HostIP = '123.140.106.87';                         // Data Center
  Port = 11002;

  StartMark = '____';


function socketSndRcv(sCMD, sData:String):String;

function WaitingData(Socket: TSocket) : cardinal;
function CanRead(Socket: TSocket; Timeout : Integer) : Boolean;


implementation

Const
  cBufMax  = 1024*100;

Type
  TRcvBuf  = Packed Record
              Len     : Integer;
              LenBody : Integer;
              Data    : Array[0..cBufMax-1] of Byte;
             end;

Var
 RcvBuf : TRcvBuf;

//
// Socket receive 대기
//
function WaitingData(Socket: TSocket) : cardinal;
var
  Tam : dword;
begin
  if fpIOCtl(Socket, FIONREAD, @Tam) <> 0 then Result := 0
                                          else Result := Tam;
end;

//
// Socket Data read
//
function CanRead(Socket: TSocket; Timeout : Integer) : Boolean;
var
  FDS: TFDSet;
  TimeV: TTimeVal;
begin
  fpFD_Zero(FDS);
  fpFD_Set(Socket, FDS);
  TimeV.tv_usec := (Timeout mod 1000) * 1000;
  TimeV.tv_sec := Timeout div 1000;

  Result := fpSelect(Socket + 1, @FDS, nil, nil, @TimeV) > 0;
end;

//
// Send :
//                  1         2         3
//        0123456789012345678901234567890
// Rcv  : ____xxxxxxxxxx2000_____
//        ^   ^         ^   ^
//        Stx DataLen   Cmd Data
//        <---------------->
//        Header : 18 Bytes
//
function socketSndRcv(sCMD, sData:String):String;

Var
  Addr       : TInetSockAddr;
  sHandle    : Longint;
  socketRead : Boolean;

  cmdID: String;
  sndData: String;

  rcvType: Integer;                                    // 0=Text DAta, 1=Stream Data
  rcvData: String;

  RcvLen   : Integer;
  DataSize : Integer;
  SocketID : String;
  //
  i        : Integer;
  tmpS     : String;

begin
  // Socket 접속정보
  Addr.sin_Family := AF_INET;
  Addr.sin_Addr   := StrToNetAddr( HostIP );           // Server IP
  Addr.sin_Port   := htons( Port );                    // Socket Port
  //
  sHandle         := fpSocket(AF_INET,SOCK_STREAM,0);  // Socket Handel 생성

  // 접속
  If fpConnect (sHandle, @ADDR, sizeof(ADDR)) < 0 Then
   begin
    rcvData := '-1@서버접속오류@'+strerror(SocketError)+'@';
    dbg(rcvData);
    exit;
   end;

  // DATA 전송자료 SET
  sndData := sCMD+Copy(IntToStr(Length(sData)+10000000000),2,10)+sData; // 4=명령어, 10=DATA길이
  sndData := StartMark+(sndData);
  cmdID   := Copy(sCMD,1,3)+'1';                              // 전송된 DATA에 대한 응답 ID
  // 전송
  fpSend(sHandle, @sndData[1], Length(sndData), 0);

  // Data Receive
  RcvBuf.Len     := 0;
  RcvBuf.LenBody := 0;
  Repeat
   RcvLen := WaitingData(sHandle); // Waiting for Incoming [Blocked]
   RcvLen := fpRecv(sHandle, @RcvBuf.Data[RcvBuf.Len], RcvLen, 0);
   Inc(RcvBuf.Len,RcvLen);
   If (RcvBuf.LenBody =  0) and
      (RcvBuf.Len     > 17) then
    begin
     tmpS := '';
     For i := 4 to 13 do
      tmpS := tmpS + Char(RcvBuf.Data[i]);
     RcvBuf.LenBody := StrToInt(tmpS);
     Dbg(tmpS);
    end;
  Until (RcvBuf.Len >= 18-4+RcvBuf.LenBody);

  Dbg('Rcv Len : ' + IntToStr(RcvLen) + ' ################################### ');
  //
  rcvData := '';
  For i := 18 to RcvBuf.Len-1 do
   rcvData := rcvData + Char ( RcvBuf.Data[i] );
  Dbg('Rcv:' + rcvData);

  //
  fpShutdown(sHandle, 2);                                             // Socket Close
  Result := rcvData;
end;

end.

