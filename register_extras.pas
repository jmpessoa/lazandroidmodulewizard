unit register_extras;
  
{$mode objfpc}{$H+}
  
interface
  

//please, do not change this code format/layout!

uses 
  Classes,
  preferences,
  location,
  spinner,
  bluetoothclientsocket,
  bluetoothserversocket,
  bluetooth,
  menu,
  myhello,
  textfilemanager,
  dumpjavamethods,
  mediaplayer,
  SysUtils,
  LResources;
  
Procedure Register;
  
implementation

//please, do not change this code format/layout!
  
Procedure Register;
begin
  {$I jpreferences_icon.lrs}
  {$I jlocation_icon.lrs}
  {$I jspinner_icon.lrs}
  {$I jbluetoothclientsocket_icon.lrs}
  {$I jbluetoothserversocket_icon.lrs}
  {$I jbluetooth_icon.lrs}
  {$I jmenu_icon.lrs}
  {$I jmyhello_icon.lrs}
  {$I jtextfilemanager_icon.lrs}
  {$I jdumpjavamethods_icon.lrs}
  {$I jmediaplayer_icon.lrs}
  RegisterComponents('Android Bridges Extra',
    [
      jPreferences,
      jLocation,
      jSpinner,
      jBluetoothClientSocket,
      jBluetoothServerSocket,
      jBluetooth,
      jMenu,
      jMyHello,
      jTextFileManager,
      jDumpJavaMethods,
      jMediaPlayer
    ]
  );
end;
  
end.
