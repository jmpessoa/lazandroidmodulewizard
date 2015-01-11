unit register_extras;
  
{$mode objfpc}{$H+}
  
interface

//please, do not change this code format/layout!

uses 
  Classes,
  gridview,
  switchbutton,
  togglebutton,
  customdialog,
  actionbartab,
  menu,
  contextmenu,
  spinner,
  location,
  preferences,
  textfilemanager,
  imagefilemanager,
  bluetooth,
  bluetoothclientsocket,
  bluetoothserversocket,
  sharefile,
  mediaplayer,
  dumpjavamethods,
  myhello,
  SysUtils,
  LResources;
  
Procedure Register;
  
implementation

//please, do not change this code format/layout!
  
Procedure Register;
begin
  {$I jgridview_icon.lrs}
  {$I jswitchbutton_icon.lrs}
  {$I jtogglebutton_icon.lrs}
  {$I jcustomdialog_icon.lrs}
  {$I jactionbartab_icon.lrs}
  {$I jmenu_icon.lrs}
  {$I jcontextmenu_icon.lrs}
  {$I jspinner_icon.lrs}
  {$I jlocation_icon.lrs}
  {$I jpreferences_icon.lrs}
  {$I jtextfilemanager_icon.lrs}
  {$I jimagefilemanager_icon.lrs}
  {$I jbluetooth_icon.lrs}
  {$I jbluetoothclientsocket_icon.lrs}
  {$I jbluetoothserversocket_icon.lrs}
  {$I jsharefile_icon.lrs}
  {$I jmediaplayer_icon.lrs}
  {$I jdumpjavamethods_icon.lrs}
  {$I jmyhello_icon.lrs}
  RegisterComponents('Android Bridges Extra',
    [
      jGridView,
      jSwitchButton,
      jToggleButton,
      jCustomDialog,
      jActionBarTab,
      jMenu,
      jContextMenu,    
      jSpinner,     
      jLocation,
      jPreferences,
      jTextFileManager,
      jImageFileManager,
      jBluetooth,
      jBluetoothClientSocket,
      jBluetoothServerSocket,
      jSharefile,
      jMediaPlayer,
      jDumpJavaMethods,
      jMyHello
    ]
  );
end;
  
end.
