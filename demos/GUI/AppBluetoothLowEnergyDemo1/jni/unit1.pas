{Hint: save all files to location: C:\android\workspace\AppBluetoothLowEnergyDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, bluetoothlowenergy;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBluetoothLowEnergy1: jBluetoothLowEnergy;
    jButton1: jButton;
    jListView1: jListView;
    jListView2: jListView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jBluetoothLowEnergy1CharacteristicRead(Sender: TObject;
      strValue: string; strCharacteristic: string);
    procedure jBluetoothLowEnergy1Connected(Sender: TObject;
      deviceName: string; deviceAddress: string; bondState: TBLEBondState);
    procedure jBluetoothLowEnergy1ScanCompleted(Sender: TObject; deviceNameArray: array of string; deviceAddressArray: array of string);
    procedure jBluetoothLowEnergy1ServiceDiscovered(Sender: TObject;
      serviceIndex: integer; serviceUUID: string;
      characteristicUUIDArray: array of string);
    procedure jButton1Click(Sender: TObject);
    procedure jListView1LongClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
    procedure jListView2ClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
  private
    {private declarations}
    FConnected: boolean;
    //FserviceIndex: integer;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

//https://code.tutsplus.com/tutorials/how-to-advertise-android-as-a-bluetooth-le-peripheral--cms-25426
//https://www.allaboutcircuits.com/projects/how-to-communicate-with-a-custom-ble-using-an-android-app/
//https://android.jlelse.eu/android-bluetooth-low-energy-communication-simplified-d4fc67d3d26e
//https://medium.com/@shahar_avigezer/bluetooth-low-energy-on-android-22bc7310387a

//https://www.allaboutcircuits.com/projects/how-to-communicate-with-a-custom-ble-using-an-android-app/
//https://code.tutsplus.com/tutorials/how-to-advertise-android-as-a-bluetooth-le-peripheral--cms-25426

//https://github.com/weliem/blessed-android    OTIMO!!!
//https://developer.android.com/guide/topics/connectivity/bluetooth-le
//https://medium.com/@martijn.van.welie/making-android-ble-work-part-3-117d3a8aee23

//https://punchthrough.com/android-ble-guide/    good ref!

{ TAndroidModule1 }

procedure TAndroidModule1.jBluetoothLowEnergy1ScanCompleted(Sender: TObject;
  deviceNameArray: array of string; deviceAddressArray: array of string);
var
  count, i: integer;
begin
   count:= Length(deviceNameArray);

   jListView1.Clear;
   for i:= 0 to count-1 do
   begin
     jListView1.Add(deviceNameArray[i]+ '|' + deviceAddressArray[i]);
     jListView1.SetItemTagString(deviceAddressArray[i], i); //save/hidden deviceAddress for future use...
   end;
end;

procedure TAndroidModule1.jBluetoothLowEnergy1Connected(Sender: TObject;
  deviceName: string; deviceAddress: string; bondState: TBLEBondState);
begin
  FConnected:= True;
  ShowMessage('Success! Connected to "'+deviceName+'"');
  //ShowMessage('Success! Connected Address "'+deviceAddress+'"');

  //https://medium.com/@martijn.van.welie/making-android-ble-work-part-2-47a3cdaade07
  if (bondState = bsNone) or (bondState = bsBonded) then
  begin
     ShowMessage('Discovering Services in progress...');
     jBluetoothLowEnergy1.DiscoverServices();
  end  //bsBonding
  else ShowMessage('[bsBonding] waiting for bonding to complete..');

end;

procedure TAndroidModule1.jBluetoothLowEnergy1CharacteristicRead(
  Sender: TObject; strValue: string; strCharacteristic: string);
begin
  ShowMessage('Characteristic:' + strCharacteristic);
  ShowMessage('Characteristic Value:' + strValue);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if IsRuntimePermissionNeed() then   // that is, if target API >= 23
  begin
    ShowMessage('Requesting Runtime Permission....');
    Self.RequestRuntimePermission(['android.permission.ACCESS_FINE_LOCATION'], 1018);   //handled by OnRequestPermissionResult
  end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
   case requestCode of
    1018:begin
           if grantResult = PERMISSION_GRANTED  then
           begin
              if manifestPermission = 'android.permission.ACCESS_FINE_LOCATION' then ShowMessage('"'+manifestPermission+'"  granted!')
           end
          else//PERMISSION_DENIED
          begin
              ShowMessage('Sorry... "['+manifestPermission+']" not granted... ' );
          end;
       end;
  end;
end;

procedure TAndroidModule1.jBluetoothLowEnergy1ServiceDiscovered(
  Sender: TObject; serviceIndex: integer; serviceUUID: string;
  characteristicUUIDArray: array of string);
var
  i, count: integer;
begin
  if serviceUUID = '7D2EA28A-F7BD-485A-BD9D-92AD6ECFE93E' then  //change here!!! put your data here!!
  begin
    jListView2.Clear;
    jListView2.Add('['+serviceUUID+']');
    jListView2.SetItemTagString(IntToStr(serviceIndex), 0); //save/hidden serviceIndex  for future use...

    count:= Length(characteristicUUIDArray);
    for i:= 0 to count-1 do
    begin
      jListView2.Add(characteristicUUIDArray[i]);
      jListView2.SetItemTagString(IntToStr(i), i); //save/hidden characteristic index for future use...
    end;
  end;
end;

//ConnectDevice
procedure TAndroidModule1.jListView1LongClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
var
  deviceAddress: string;
begin
  FConnected:= False;
  deviceAddress:= jListView1.GetItemTagString(itemIndex); //retrieve itemtag address
  jBluetoothLowEnergy1.ConnectDevice(deviceAddress);
end;

procedure TAndroidModule1.jListView2ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
var
  serviceTag, characteristicTag: string;

  serviceIndex, characteristicIndex: integer;

  charactProperty: TBLECharacteristicProperty;

  descriptorsArray: TDynArrayOfString;
  characteristicsArray: TDynArrayOfString;

  i, count: integer;
begin

   serviceTag:= jListView2.GetItemTagString(0); //retrieve item tag (serviceIndex)

   characteristicTag:= jListView1.GetItemTagString(itemIndex); //retrieve item tag (characteristicIndex)

   serviceIndex:= StrToInt(serviceTag);
   characteristicIndex:= StrToInt(characteristicTag);

   descriptorsArray:= jBluetoothLowEnergy1.GetDescriptors(serviceIndex, characteristicIndex);

   count:= Length(descriptorsArray);
   for i:= 0 to count-1 do
   begin
     showMessage(descriptorsArray[i]);
   end;

   characteristicsArray:= jBluetoothLowEnergy1.GetCharacteristics(serviceIndex);
   count:= Length(descriptorsArray);
   for i:= 0 to count-1 do
   begin
     showMessage(characteristicsArray[i]);
   end;

   charactProperty:= jBluetoothLowEnergy1.GetCharacteristicProperties(serviceIndex, characteristicIndex);
   if charactProperty = cpRead then
   begin
     //handled by "OnCharacteristicRead"
      jBluetoothLowEnergy1.ReadCharacteristic(serviceIndex, characteristicIndex);
   end;

end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin

    if not IsRuntimePermissionGranted('android.permission.ACCESS_FINE_LOCATION') then
    begin
      ShowMessage('Sorry... "ACCESS_FINE_LOCATION permission DENIED ...');
      Exit;
    end;

    jBluetoothLowEnergy1.StartScan();
end;

end.
