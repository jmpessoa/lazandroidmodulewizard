{Hint: save all files to location: C:\adt32\eclipse\workspace\AppBluetoothServerSocketDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, bluetoothserversocket;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jBluetoothServerSocket1: jBluetoothServerSocket;
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jTextView1: jTextView;
      jTextView2: jTextView;

      procedure jBluetoothServerSocket1Connected(Sender: TObject;
        deviceName: string; deviceAddress: string; out keepConnected: boolean);
      procedure jBluetoothServerSocket1IncomingData(Sender: TObject;
        var dataContent: TDynArrayOfJByte; dataHeader: TDynArrayOfJByte; out
        keepConnected: boolean);

      procedure jBluetoothServerSocket1Listening(Sender: TObject; serverName: string; strUUID: string);
      procedure jBluetoothServerSocket1Timeout(Sender: TObject);

      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
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
   jBluetoothServerSocket1.Listen();
   jButton1.Text:= 'Listening ...';
end;

procedure TAndroidModule1.jBluetoothServerSocket1Listening(Sender: TObject;
  serverName: string; strUUID: string);
begin
   ShowMessage('Listening ... [serverName='+serverName+'] [UUID='+strUUID+']');
end;

procedure TAndroidModule1.jBluetoothServerSocket1Timeout(Sender: TObject);
begin
   ShowMessage('Timeout/Closed ...[The End!]');
   jButton1.Text:= 'Listen';
end;

procedure TAndroidModule1.jBluetoothServerSocket1Connected(Sender: TObject;
  deviceName: string; deviceAddress: string; out keepConnected: boolean);
begin
   ShowMessage('Connected to: ['+deviceName+'] '+ ' ['+deviceAddress+']');
   //if any "unwelcome" then keepConnected:= False!
end;

procedure TAndroidModule1.jBluetoothServerSocket1IncomingData(Sender: TObject;
  var dataContent: TDynArrayOfJByte; dataHeader: TDynArrayOfJByte; out
  keepConnected: boolean);
var
  matchHeader: string;
  strEcho: string;
begin
   if jBluetoothServerSocket1.DataHeaderReceiveEnabled then
   begin
      matchHeader:= jBluetoothServerSocket1.JByteArrayToString(dataHeader);
      //handle  matchHeader .... [Demo 2!]
   end
   else  //NO header ...  DataHeaderReceiveEnabled = False]
   begin
       if (dataContent <> nil) then
       begin
         strEcho:= jBluetoothServerSocket1.JByteArrayToString(dataContent);
         ShowMessage('Received from Client: "'+strEcho+'"');
         jBluetoothServerSocket1.WriteMessage(UpperCase(strEcho));
       end
       else   ShowMessage('NULL content ..');
   end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if jBluetoothServerSocket1.IsClientConnected() then
    jBluetoothServerSocket1.WriteMessage('Hello My Client!') //NO header!
  else
     ShowMessage('Please, Wait... Not Connected yet!');
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
   jBluetoothServerSocket1.CancelListening();
   jButton1.Text:= 'Listen';
   //jBluetoothServerSocket1.Listen();  //need to continue Listening!
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
    jBluetoothServerSocket1.DisconnectClient();
    jButton1.Text:= 'Listen';
    //jBluetoothServerSocket1.Listen();  //need to continue Listening!

end;

end.
