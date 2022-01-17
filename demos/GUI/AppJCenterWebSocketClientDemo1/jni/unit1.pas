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


     (*warning: We are using pascal "shortint" to simulate the [Signed] java byte ....
      however "shortint" works in the range "-127 to 128" equal to the byte in java ....
      So every time we assign a value outside this range, for example 192, we get
      the "range check" compile message...

      How to Fix:

      var
        bufferToSend: array of jbyte; //jbyte = shortint
      begin
        ...........
        bufferToSend[0] := ToSignedByte($C0);    //<-- fixed!
        ........
      end;
    *)   


procedure TAndroidModule1.WebSocketClient1Open(Sender: TObject);
begin
  WebSocketClient1.Send('Hello ws World!');
end;

end.
