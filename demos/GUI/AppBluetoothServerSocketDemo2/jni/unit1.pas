{Hint: save all files to location: C:\adt32\eclipse\workspace\AppBluetoothServerSocketDemo2\jni }
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
      jButton5: jButton;
      jImageView1: jImageView;
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
      procedure jButton5Click(Sender: TObject);
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
   //ShowMessage('Click Listen....');
   jBluetoothServerSocket1.Listen();
   jButton1.Text:= 'Listing...';
end;

procedure TAndroidModule1.jBluetoothServerSocket1Listening(Sender: TObject;
  serverName: string; strUUID: string);
begin
  ShowMessage('Listening ... ['+serverName+'] ['+strUUID+']');
end;

procedure TAndroidModule1.jBluetoothServerSocket1Timeout(Sender: TObject);
begin
  ShowMessage('Timeout/Closed ...[The End!]');
  jButton1.Text:= 'Listen';
end;

procedure TAndroidModule1.jBluetoothServerSocket1Connected(Sender: TObject;
  deviceName: string; deviceAddress: string; out keepConnected: boolean);
begin
    ShowMessage('Connected to: ['+deviceName+'] ['+deviceAddress+']');
    //if any "unwelcome"  then  keepConnected:= False
end;

procedure TAndroidModule1.jBluetoothServerSocket1IncomingData(Sender: TObject;
  var dataContent: TDynArrayOfJByte; dataHeader: TDynArrayOfJByte; out
  keepConnected: boolean);
var
  matchHeader: String;
begin
   if jBluetoothServerSocket1.DataHeaderReceiveEnabled then
   begin
      if dataHeader <> nil then
      begin
        matchHeader:= jBluetoothServerSocket1.JByteArrayToString(dataHeader);
        if matchHeader = 'text/plain' then
        begin
          ShowMessage('Received ['+matchHeader+'] from Client: ' +
                       jBluetoothServerSocket1.JByteArrayToString(dataContent)
                      );
        end
        else if  matchHeader =  'image/jpg' then
        begin //image
          jImageView1.SetImageFromJByteArray(dataContent);
          ShowMessage('Received ['+matchHeader+'] from Client ...');
        end;
      end;
   end
   else  //not have header ...
   begin
     //try to guess data format .. and manager Incoming dataContent lenght!
   end;
end;


procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
    dataHeader: string;
begin
   dataHeader:= 'text/plain ::Lamw: Lazarus Android Module Wizard  - version 0.6 - revision 35 - 27 July - 2015  Android Java Interface for Pascal/Delphi XE5 and FreePacal/LAZARUS[december 2013] Lamw: Lazarus Android Module Wizard';
  if jBluetoothServerSocket1.IsClientConnected() then
     jBluetoothServerSocket1.WriteMessage('Hello My Client!', dataHeader)
  else
     ShowMessage('Sorry, Not Connected yet!');
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
var
    fileName: string;
begin
   ShowMessage('Sending file from Assets to client...');

   fileName:= 'lemurbaby.jpg';

   //needed pit stop!
   Self.CopyFromAssetsToEnvironmentDir(fileName, Self.GetEnvironmentDirectoryPath(dirDownloads));

   //from a enviromment direcotory ...
   jBluetoothServerSocket1.SendFile( Self.GetEnvironmentDirectoryPath(dirDownloads),
                                     fileName,
                                     'file/jpg');
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
   jBluetoothServerSocket1.CancelListening();
   jButton1.Text:= 'Listen';
   //jBluetoothServerSocket1.Listen();  //need to continue Listening!
end;

procedure TAndroidModule1.jButton5Click(Sender: TObject);
begin
    jBluetoothServerSocket1.DisconnectClient();
    jButton1.Text:= 'Listen';
    //jBluetoothServerSocket1.Listen();  //need to continue Listening!
end;

end.
