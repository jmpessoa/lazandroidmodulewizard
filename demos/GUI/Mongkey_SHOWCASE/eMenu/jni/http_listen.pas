unit http_listen;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
    cthreads,
    {$ENDIF}{$ENDIF}
  Classes, SysUtils, blcksock,
  Synautil;

type
  TPassMessage = procedure(AMsg: string) of object;

  TLightWeb = class(TThread)
  private
    _Port: word;
    _PassMessage: TPassMessage;
    procedure AttendConnection(ASocket: TTCPBlockSocket);
    procedure TriggerMessage(AMsg: string);
  protected
    procedure Execute; override;
  public
    constructor Create(APort: word);
    destructor Destroy; override;
    property OnPassMessage: TPassMessage read _PassMessage write _PassMessage;
  end;

implementation

constructor TLightWeb.Create(APort: word);
begin
  inherited Create(False);
  _Port := Aport;
end;

procedure TLightWeb.Execute;
var
  ListenerSocket, ConnectionSocket: TTCPBlockSocket;

begin
  try
    ListenerSocket := TTCPBlockSocket.Create;
    ConnectionSocket := TTCPBlockSocket.Create;

    ListenerSocket.CreateSocket;
    ListenerSocket.setLinger(True, 10);
    ListenerSocket.bind('0.0.0.0', IntToStr(_Port));
    ListenerSocket.listen;

    repeat
      if ListenerSocket.canread(1000) then
      begin
        ConnectionSocket.Socket := ListenerSocket.accept;
        WriteLn('Attending Connection. Error code (0=Success): ', ConnectionSocket.lasterror);
        AttendConnection(ConnectionSocket);
        ConnectionSocket.CloseSocket;
      end;
    until Terminated;

  finally
    FreeAndNil(ListenerSocket);
    FreeAndNil(ConnectionSocket);
  end;
end;

procedure TLightWeb.AttendConnection(ASocket: TTCPBlockSocket);
var
  timeout: integer;
  s: string;
  OutputDataString: string;

begin
  timeout := 120000;

  try
    try
      WriteLn('Received headers+document from browser:');
      s := ASocket.RecvString(timeout);
      WriteLn(s);


      //read request headers
      repeat
        s := ASocket.RecvString(Timeout);
        WriteLn(s);
        TriggerMessage(s);
      until s = '';

      // Write the output document to the stream
      OutputDataString := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"' + ' "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' +
        CRLF + '<html><h1>Test</h1></html>' + CRLF;

      // Write the headers back to the client
      ASocket.SendString('HTTP/1.0 200' + CRLF);
      ASocket.SendString('Content-type: Text/Html' + CRLF);
      ASocket.SendString('Content-length: ' + IntToStr(Length(OutputDataString)) + CRLF);
      ASocket.SendString('Connection: close' + CRLF);
      ASocket.SendString('Date: ' + Rfc822DateTime(now) + CRLF);
      ASocket.SendString('Server: Lazarus Synapse' + CRLF);
      ASocket.SendString('' + CRLF);

      //if ASocket.lasterror <> 0 then HandleError;
      ASocket.SendString(OutputDataString);
    except
      on E: Exception do
      begin

      end;
    end;
  finally
  end;
end;

procedure TLightWeb.TriggerMessage(AMsg: string);
begin
  if Assigned(_PassMessage) then
    _PassMessage(AMsg);
end;

destructor TLightWeb.Destroy();
begin
  inherited Destroy;
end;

end.
