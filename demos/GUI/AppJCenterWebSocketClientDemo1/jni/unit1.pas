{hint: Pascal files location: ...\AppJCenterWebSocketClientDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, cwebsocketclient;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    Button1: jButton;
    TextView1: jTextView;
    WebSocketClient1: jcWebSocketClient;
    procedure Button1Click(Sender: TObject);
    procedure WebSocketClient1Open(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

//for more info:
//https://github.com/gusavila92/java-android-websocket-client
procedure TAndroidModule1.Button1Click(Sender: TObject);
begin
  WebSocketClient1.SetUri('ws://myhost:8080/test'); //dummy
  WebSocketClient1.Connect();
end;

procedure TAndroidModule1.WebSocketClient1Open(Sender: TObject);
begin
  WebSocketClient1.Send('Hello ws World!');
end;

end.
