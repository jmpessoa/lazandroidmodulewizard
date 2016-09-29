{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppUDPSocketDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, udpsocket;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    jUDPSocket1: jUDPSocket;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jUDPSocket1Received(Sender: TObject; content: string;
      remoteIP: string; remotePort: integer; out listening: boolean);

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
    jUDPSocket1.Send(Self.GetWifiBroadcastIPAddress(), 1611, 'Hello World Broadcasted...!');
end;

procedure TAndroidModule1.jUDPSocket1Received(Sender: TObject; content: string;
  remoteIP: string; remotePort: integer; out listening: boolean);
begin
   //listening: False;  //stop listen ...  <<-------------
   ShowMessage(content + ' * remoteIP: '+ remoteIP);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  netStatus: TNetworkStatus;
begin
   netStatus:= Self.GetNetworkStatus();
   if netStatus = nsOff then
   begin
    ShowMessage('Network is Off');
    Exit;
   end;
   if netStatus = nsMobileDataOn then
   begin
     ShowMessage(Self.GetDeviceDataMobileIPAddress() );
     ShowMessage('Please, connect to wifi to broadcast a message');
     Exit;
   end;

   if netStatus = nsWifiOn then
   begin
     jTextView2.Text:= 'Wifi Device IP: ' + Self.GetDeviceWifiIPAddress();
     jTextView3.Text:= 'Listening on Port: 1611';
     jTextView4.Text:= 'Wifi Broadcast IP: '  + Self.GetWifiBroadcastIPAddress();

     jUDPSocket1.Listen(1611 {port}, 2048 {buffer len});   //don't bind to ports lower than 1024!!!

     ShowMessage('Listening on port 1611 ..');
   end;

end;

end.
