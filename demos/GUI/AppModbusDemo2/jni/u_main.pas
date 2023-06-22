{hint: Pascal files location: ...\modbus\jni }
unit u_main;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, tcpsocketclient, Laz_And_Controls,
  tcp_udpport, ModBusTCP;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jEditText1: jEditText;
    jTCPSocketClient1: jTCPSocketClient;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    ModBusTCPDriver1: TModBusTCPDriver;
    TCP_UDPPort1: TTCP_UDPPort;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jTCPSocketClient1BytesReceived(Sender: TObject;
      var jbytesReceived: TDynArrayOfJByte);
    procedure jTCPSocketClient1Connected(Sender: TObject);
    procedure jTCPSocketClient1MessagesReceived(Sender: TObject;
      messageReceived: string);
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

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jTCPSocketClient1.ConnectAsync('192.168.0.18',502);
  jTCPSocketClient1.SendMessage('tst');
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jButton1.SetFontFromAssets('materialdesignicons-webfont.ttf');
  jButton1.Text:='111'+self.ParseHtmlFontAwesome('f101');

  jTextView3.SetFontFromAssets('materialdesignicons-webfont.ttf');
  jTextView3.Text:=self.ParseHtmlFontAwesome('f101');
  jEditText1.SetRoundBorderColor(colbrdodgerblue);
  jEditText1.SetRoundBorderWidth(1);
  jEditText1.SetRoundRadiusCorner(20);
  jEditText1.SetRoundCorner();
end;

procedure TAndroidModule1.jTCPSocketClient1BytesReceived(Sender: TObject;
  var jbytesReceived: TDynArrayOfJByte);
begin
end;

procedure TAndroidModule1.jTCPSocketClient1Connected(Sender: TObject);
begin
  jtextview1.Text:='connected';
end;

procedure TAndroidModule1.jTCPSocketClient1MessagesReceived(Sender: TObject;
  messageReceived: string);
begin
  jtextview2.Text:=messageReceived;
end;

end.
