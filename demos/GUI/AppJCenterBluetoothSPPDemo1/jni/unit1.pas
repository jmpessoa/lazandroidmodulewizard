{Hint: save all files to location: C:\android\workspace\AppJCenterBluetoothSPPDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, cbluetoothspp,
  intentmanager, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jButton4: jButton;
    jcBluetoothSPP1: jcBluetoothSPP;
    jIntentManager1: jIntentManager;
    jTextView1: jTextView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jButton4Click(Sender: TObject);
    procedure jcBluetoothSPP1Connected(Sender: TObject; deviceName: string;
      deviceAddress: string);
    procedure jcBluetoothSPP1ConnectionFailed(Sender: TObject);
    procedure jcBluetoothSPP1ConnectionStateChanged(Sender: TObject;
      state: TBluetoothSPPConnectionState);
    procedure jcBluetoothSPP1DataReceived(Sender: TObject;
      jbyteArrayData: array of shortint; messageData: string);
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

//ref.
//https://github.com/akexorcist/Android-BluetoothSPPLibrary
procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin

   if not jcBluetoothSPP1.IsBluetoothEnabled() then Exit;

   if jcBluetoothSPP1.GetConnectionState() = csConnected then
   begin
     jcBluetoothSPP1.Disconnect();
   end;

   (*
   jIntentManager1.SetClass(jcBluetoothSPP1.GetActivityDeviceListClass());
   //ref. https://github.com/akexorcist/Android-BluetoothSPPLibrary
   //jIntentManager1.PutExtraString('bluetooth_devices', 'Bluetooth devices'); //bar
   //jIntentManager1.PutExtraString('no_devices_found', 'No device found');    //list result message
   //jIntentManager1.PutExtraString('scanning', 'Scanning...');                //bar
   //jIntentManager1.PutExtraString('scan_for_devices', 'Scan for Devices'); //bottom button
   //jIntentManager1.PutExtraString('select_device', 'Select a device to Connect'); //bar
   jIntentManager1.StartActivityForResult(REQUEST_CONNECT_DEVICE));
   *)

   //or simply
   jcBluetoothSPP1.StartActivityDeviceListForResult();

 end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   if jcBluetoothSPP1.GetConnectionState() = csConnected then
   begin
      //ShowMessage(jcBluetoothSPP1.GetConnectedDeviceName());
      jcBluetoothSPP1.Send('Hello World!',  True) //True = Auto add LF (0x0A) and CR (0x0D) when send data to connection device
   end
   else
      ShowMessage('Sorry... not connected...');
end;

{ We are using pascal "shortint" to simulate the [Signed] java byte ....
  however "shortint" works in the range "-127 to 128" equal to the byte in java ....
  So every time we assign a value outside this range, for example 192 or $C0, we get
  the "range check" message...
}
procedure TAndroidModule1.jButton3Click(Sender: TObject);
var
  data: array of jbyte;  //or array of shortint
begin
   if jcBluetoothSPP1.GetConnectionState() = csConnected then
   begin
      SetLength(data, 4);

      data[0]:= $64;                      //100
      data[1]:= Self.ToSignedByte($C0);   //192   "range check" fixed!
      data[2]:= $78;                      //120
      data[3]:= Self.ToSignedByte($f0);   //240    "range check" fixed!

      jcBluetoothSPP1.Send(data,  False); //TRUE = Auto add LF (0x0A) and CR (0x0D) when send data to connection device

      SetLength(data, 0);
   end
   else
      ShowMessage('Sorry... not connected...');
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
   if jcBluetoothSPP1.GetConnectionState() = csConnected then
   begin
      jcBluetoothSPP1.Disconnect();
   end;
end;

procedure TAndroidModule1.jcBluetoothSPP1Connected(Sender: TObject;
  deviceName: string; deviceAddress: string);
begin
  ShowMessage('Connected to: "'+deviceName+'"  :: Address: ' +deviceAddress);
end;

procedure TAndroidModule1.jcBluetoothSPP1ConnectionFailed(Sender: TObject);
begin
  ShowMessage('Sorry... Connection Failed....');
end;

procedure TAndroidModule1.jcBluetoothSPP1ConnectionStateChanged(
  Sender: TObject; state: TBluetoothSPPConnectionState);
begin
  ShowMessage('Connection State Changed...');
end;

procedure TAndroidModule1.jcBluetoothSPP1DataReceived(Sender: TObject;
  jbyteArrayData: array of shortint; messageData: string);
begin
 //
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

   //jcBluetoothSPP1.SetDeviceTarget(DEVICE_ANDROID); //paired device is a android ... ??

   if not jcBluetoothSPP1.IsBluetoothEnabled() then
   begin
       (*
       jIntentManager1.SetAction(jcBluetoothSPP1.GetIntentActionEnableBluetooth());
       jIntentManager1.StartActivityForResult(REQUEST_ENABLE_BT);
       *)
      //or simply
      jcBluetoothSPP1.StartActivityEnableBluetoothForResult();
   end
   else
   begin
     if not jcBluetoothSPP1.IsServiceAvailable() then
     begin

       //For connection with android device
       jcBluetoothSPP1.SetupAndStartService(DEVICE_ANDROID);

       //For connection with any microcontroller which communication with bluetooth serial port profile module
       //jcBluetoothSPP1.SetupAndStartService(DEVICE_OTHER);

       //jcBluetoothSPP1.Send('Hi!', True);
     end else ShowMessage('Sorry... Service is not Available...')
   end;

end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
   requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
var
  macAddress: string;
begin

  if resultCode = RESULT_CANCELED then Exit; // device Pressed back ...

  if requestCode = REQUEST_CONNECT_DEVICE then
  begin

    macAddress:= jIntentManager1.GetExtraString(intentData, EXTRA_DEVICE_ADDRESS);
    ShowMessage('Device MAC = ' + macAddress);

    //jcBluetoothSPP1.Connect(intentData);

    //or
    jcBluetoothSPP1.Connect(macAddress);

  end
  else if requestCode = REQUEST_ENABLE_BT then
  begin
     if not jcBluetoothSPP1.IsServiceAvailable() then
     begin

       //For connection with android device
       jcBluetoothSPP1.SetupAndStartService(DEVICE_ANDROID); //DEVICE_OTHER(False) = any microcontroller which communication with bluetooth serial port profile module

       //For connection with any microcontroller which communication with bluetooth serial port profile module
       //jcBluetoothSPP1.SetupAndStartService(DEVICE_OTHER);

       //jcBluetoothSPP1.Send('Hi!', True);
     end;
  end;
end;

end.
