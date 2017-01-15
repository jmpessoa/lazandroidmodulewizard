{Hint: save all files to location: C:\adt32\eclipse\workspace\AppBluetoothClientSocketDemo2\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, bluetooth, bluetoothclientsocket, AndroidWidget,
  imagefilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jBluetooth1: jBluetooth;
      jBluetoothClientSocket1: jBluetoothClientSocket;
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jButton5: jButton;
      jButton6: jButton;
      jButton7: jButton;
      jDialogProgress1: jDialogProgress;
      jImageFileManager1: jImageFileManager;
      jImageView1: jImageView;
      jListView1: jListView;
      jTextView1: jTextView;
      jTextView2: jTextView;

      procedure jBluetooth1DeviceFound(Sender: TObject; deviceName: string; deviceAddress: string);
      procedure jBluetooth1Disabled(Sender: TObject);
      procedure jBluetooth1DiscoveryFinished(Sender: TObject; countFoundedDevices: integer; countPairedDevices: integer);
      procedure jBluetooth1DiscoveryStarted(Sender: TObject);
      procedure jBluetooth1Enabled(Sender: TObject);
      procedure jBluetoothClientSocket1Connected(Sender: TObject;
        deviceName: string; deviceAddress: string);
      procedure jBluetoothClientSocket1IncomingData(Sender: TObject;
        var dataContent: TDynArrayOfJByte; dataHeader: TDynArrayOfJByte);

      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
      procedure jButton5Click(Sender: TObject);
      procedure jButton6Click(Sender: TObject);
      procedure jButton7Click(Sender: TObject);

      procedure jListView1ClickItem(Sender: TObject; itemIndex: integer; itemCaption: string);
      procedure jListView1DrawItemTextColor(Sender: TObject;
        itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge
        );

    private
      {private declarations}
       FDeviceAddress: string;
       FDeviceName: string;
       FIsDiscovering: boolean;
       procedure ShowPairedDevices;
       procedure ShowNewDevices;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.ShowPairedDevices;
var
  listArray: TDynArrayOfString;
  i, size: integer;
begin
  listArray:= jBluetooth1.GetReachablePairedDevices();
  if listArray <> nil then
  begin
     size:=Length(listArray);
     if size = 0 then
        ShowMessage('Paired Devices Not Found ... [0]')
     else
     begin
       jListView1.Clear;
       jListView1.Add('      [Paired] Select a Bluetooch Server');
       for i:= 0 to size-1 do
       begin
         //ShowMessage(listArray[i]);
         jListView1.Add(listArray[i]);
       end;
       SetLength(listArray, 0); //free ...
     end;
  end
  else ShowMessage('Paired Devices Not Found ... [nil]');
end;

procedure TAndroidModule1.ShowNewDevices;
var
  listArray: TDynArrayOfString;
  i, size: integer;
begin
  listArray:= jBluetooth1.GetFoundedDevices();
  if listArray <> nil then
  begin
     size:=Length(listArray);
     if size = 0 then
        ShowMessage('News Devices Not Found ... [0]')
     else
     begin
       jListView1.Clear;
       jListView1.Add('      Select a Bluetooch Server');
       for i:= 0 to size-1 do
       begin
         //ShowMessage(listArray[i]);
          jListView1.Add(listArray[i]);
       end;
       SetLength(listArray, 0);
     end;
  end
  else ShowMessage('News Devices Not Found ... [nil]');
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jBluetooth1.Enabled();
end;

procedure TAndroidModule1.jBluetooth1DeviceFound(Sender: TObject;
  deviceName: string; deviceAddress: string);
begin
 // ShowMessage('deviceName: ' +deviceName +' : deviceAddress: '+deviceAddress);
 // jListView1.Add(deviceName + '|' + deviceAddress);
end;

procedure TAndroidModule1.jBluetooth1Disabled(Sender: TObject);
begin
  ShowMessage('Bluetooth Off');
end;

procedure TAndroidModule1.jBluetooth1DiscoveryFinished(Sender: TObject; countFoundedDevices: integer;
  countPairedDevices: integer);
begin
  //ShowMessage('***Discovery Finished! Founded Devices = '+IntToStr(countFoundedDevices));
  //ShowMessage('...Discovery Finished! Reachable Paired Devices = '+IntToStr(countPairedDevices));
  jDialogProgress1.Stop;
  FIsDiscovering:= False;
  ShowNewDevices();
end;

procedure TAndroidModule1.jBluetooth1DiscoveryStarted(Sender: TObject);
begin
  FIsDiscovering:= True;
  ShowMessage('Starting Discovering News Devices..');
end;

procedure TAndroidModule1.jBluetooth1Enabled(Sender: TObject);
begin
  ShowMessage('Bluetooth On');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jListView1.Clear;
   jBluetooth1.Discovery();
   jDialogProgress1.Show();
   //handled by: OnDiscoveryStarted, OnDeviceFound and OnDiscoveryFinished
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  jListView1.Clear;
  ShowPairedDevices();
  //ShowMessage('Paired Devices...');
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
   jBluetooth1.Disable();
end;

//http://kpbird.blogspot.com.br/2011/04/android-send-image-via-bluetooth.html
procedure TAndroidModule1.jButton5Click(Sender: TObject);
begin

  if jBluetoothClientSocket1.IsConnected() then
    jBluetoothClientSocket1.WriteMessage('Hi Server!', 'text/plain')
  else
    ShowMessage('Not Connected yet...');

end;

procedure TAndroidModule1.jButton6Click(Sender: TObject);
begin
   jBluetoothClientSocket1.Disconnect();
end;

procedure TAndroidModule1.jButton7Click(Sender: TObject);
var
  img: JObject;
  imgArray: TDynArrayOfJByte;
begin
   if jBluetoothClientSocket1.IsConnected() then
   begin
     img:= jImageFileManager1.LoadFromAssets('lemures.jpg');           //or lemur1.jpg
     imgArray:= jImageFileManager1.GetByteArrayFromBitmap(img,'JPEG'); //or PNG ...
     jBluetoothClientSocket1.Write(imgArray, 'image/jpg');
   end;
end;

procedure TAndroidModule1.jBluetoothClientSocket1Connected(Sender: TObject; deviceName:
  string; deviceAddress: string);
begin
   ShowMessage('Connected to server deviceName: ['+deviceName+'] ['+deviceAddress+']');
end;

procedure TAndroidModule1.jBluetoothClientSocket1IncomingData(Sender: TObject;
  var dataContent: TDynArrayOfJByte; dataHeader: TDynArrayOfJByte);
var
   matchHeader: string;
begin
  if jBluetoothClientSocket1.DataHeaderReceiveEnabled then
  begin
    if dataHeader <> nil then
    begin
      matchHeader:= jBluetoothClientSocket1.JByteArrayToString(dataHeader);

      if  Pos('text/plain', matchHeader) > 0 then
      begin
         ShowMessage('Reeceived ['+matchHeader+'] from Server: ' + jBluetoothClientSocket1.JByteArrayToString(dataContent));
      end
      else if  matchHeader = 'file/jpg' then
      begin
         jImageView1.SetImageFromJByteArray(dataContent);
         jBluetoothClientSocket1.SaveJByteArrayToFile(dataContent,
                                                      Self.GetEnvironmentDirectoryPath(dirDownloads),
                                                      'lemurbaby.jpg');

         ShowMessage('Received ['+matchHeader+'] from Server' +#10+ '[Saved to Download/lemurbaby.jpg]');
      end;
    end;
  end
  else  //not have header ... ]
  begin
     //try to guess about data ...!
  end;
end;

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject; itemIndex: integer; itemCaption: string);
var
  deviceName, deviceAddress: string;
begin

  if  itemIndex = 0 then  Exit;

  deviceAddress:= itemCaption; // format: name|address
  deviceName:= SplitStr(deviceAddress, '|');

  FDeviceAddress:= deviceAddress;
  FDeviceName:= deviceName;

  if Pos('null', deviceAddress) <= 0 then //not null!
  begin
    if jBluetooth1.IsReachablePairedDevice(deviceAddress) then
    begin
       jBluetoothClientSocket1.SetDevice(jBluetooth1.GetReachablePairedDeviceByAddress(deviceAddress));
       //well known SPP UUID
        jBluetoothClientSocket1.SetUUID('00001101-0000-1000-8000-00805F9B34FB'); //default
        jBluetoothClientSocket1.Connect();
    end else ShowMessage('Not Reachable Paired Device...');
  end;

end;

procedure TAndroidModule1.jListView1DrawItemTextColor(Sender: TObject;
  itemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge);
begin
  if itemIndex = 0 then textColor:= colbrBlue;
end;

end.
