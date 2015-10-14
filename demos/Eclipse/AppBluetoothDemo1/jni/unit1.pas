{Hint: save all files to location: C:\adt32\eclipse\workspace\AppBluetoothDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, bluetooth, imagefilemanager;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBluetooth1: jBluetooth;
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jButton4: jButton;
    jButton5: jButton;
    jDialogProgress1: jDialogProgress;
    jImageBtn1: jImageBtn;
    jImageFileManager1: jImageFileManager;
    jImageList1: jImageList;
    jListView1: jListView;
    jTextView1: jTextView;
    procedure jBluetooth1DeviceBondStateChanged(Sender: TObject;
      state: integer; deviceName: string; deviceAddress: string);
    procedure jBluetooth1DeviceFound(Sender: TObject; deviceName: string;
      deviceAddress: string);
    procedure jBluetooth1DiscoveryFinished(Sender: TObject;
      countFoundedDevices: integer; countPairedDevices: integer);
    procedure jBluetooth1DiscoveryStarted(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jButton4Click(Sender: TObject);
    procedure jButton5Click(Sender: TObject);
    procedure jImageBtn1Click(Sender: TObject);

  private
    {private declarations}
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
       jListView1.Add('      Select a [Paired] device:');
       for i:= 0 to size-1 do
       begin
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
       jListView1.Add('      Devices Found:');
       for i:= 0 to size-1 do
       begin
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

procedure TAndroidModule1.jBluetooth1DiscoveryStarted(Sender: TObject);
begin
  ShowMessage('Starting Discovering News Devices..');
end;

procedure TAndroidModule1.jBluetooth1DiscoveryFinished(Sender: TObject;
  countFoundedDevices: integer; countPairedDevices: integer);
begin
  jDialogProgress1.Stop;
  ShowNewDevices();
end;

procedure TAndroidModule1.jBluetooth1DeviceFound(Sender: TObject;
  deviceName: string; deviceAddress: string);
begin
   //ShowMessage('deviceName: ' +deviceName +' : deviceAddress: '+deviceAddress);
end;

procedure TAndroidModule1.jBluetooth1DeviceBondStateChanged(Sender: TObject;
  state: integer; deviceName: string; deviceAddress: string);
begin
  case jBluetooth1.GetBondState(state) of
    bsUnBonded: ShowMessage(deviceName+'|'+deviceAddress +' [Unpaired]');
    bsBonding:  ShowMessage(deviceName+'|'+deviceAddress +' [Pairing...]');
    bsBonded:   ShowMessage(deviceName+'|'+deviceAddress +' [Paired]');
  end;
end;

{
Note: to transfer via Bluetooth , you need to do some common user's tasks:
      activate bluetooth, detect [visibles] neighbors devices and pair neighbors devices....
}

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jListView1.Clear;
   jBluetooth1.Discovery(); //handled by: OnDiscoveryStarted, OnDeviceFound and OnDiscoveryFinished
   jDialogProgress1.Show();
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  ShowMessage('Listing Only Paired Devices....');
  jListView1.Clear;
  ShowPairedDevices();
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
var
  jImage: jObject;
  copyOk: boolean;
begin
  jImage:= jImageFileManager1.LoadFromAssets('lemur_background_black.png');

   //save to internal app storage...
  jImageFileManager1.SaveToFile(jImage, 'lemur_background_black.png');

  //copy from internal app storage  to /downloads [public directory!]
  copyOk:= Self.CopyFile(Self.GetEnvironmentDirectoryPath(dirInternalAppStorage)+'/lemur_background_black.png',
                        Self.GetEnvironmentDirectoryPath(dirDownloads)+'/lemur_background_black.png');

   //_mimetype [lowercase!]:  "image/jpeg" or "text/plain" or "image/*" or "*/*" etc...
   if copyOk then
      jBluetooth1.SendFile(Self.GetEnvironmentDirectoryPath(dirDownloads),'lemur_background_black.png', 'image/*');
end;


procedure TAndroidModule1.jButton5Click(Sender: TObject);
begin
   jBluetooth1.Disable();
end;

procedure TAndroidModule1.jImageBtn1Click(Sender: TObject);
begin
    ShowMessage('jImageBtn1 Clicked....');
end;

end.
