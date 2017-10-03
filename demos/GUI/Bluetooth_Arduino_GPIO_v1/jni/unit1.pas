{Hint: save all files to location: C:\lamw\projects\\Bluetooth_Arduino_GPIO_v1\jni }
{
 Subj:
 For Electronics Tinkerer - HC-05/06 + Arduino GPIO example

 Firmware (look at Arduino app subfolder):
 GPIO only auto/manual 3CH gpio (LED/relay) controller
 Builded for Sanguino(Atmega1284p-16Mhz) on Arduino 1.6.5 IDE
 (possible rebuild as I think for Arduino Mega/Uno etc.. with slight code corrections)


 Author:
 Ibragimov M. aka maxx
 Russia Togliatty 26/09/17
}

unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, actionbartab, And_jni, Laz_And_Controls,
  bluetooth, bluetoothclientsocket, switchbutton, menu, modaldialog;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jActionBarTab1: jActionBarTab;
    jBluetooth1: jBluetooth;
    jBluetoothClientSocket1: jBluetoothClientSocket;
    jBtn_BT_Disconnect: jButton;
    jBtn_BT_Paired: jButton;
    jBtn_BT_ON: jButton;
    jBtn_BT_OFF: jButton;
    jBtn_BT_Discovery: jButton;
    jBtn_UpdateSta: jButton;
    jButton_send: jButton;
    jCheckBox_BT_RX_Toast: jCheckBox;
    jCheckBox_UpdateSta_auto: jCheckBox;
    jDialogProgress_BT_Discovery: jDialogProgress;
    jEditText_Send: jEditText;
    jListView_BT_RX: jListView;
    jListView_BT_connect: jListView;
    jMenu1: jMenu;
    jModalDialog1: jModalDialog;
    jPanel_GPIO: jPanel;
    jPanel_TERMINAL: jPanel;
    jPanel_SETUP: jPanel;
    jSwBtn_LED1: jSwitchButton;
    jSwBtn_LED2: jSwitchButton;
    jSwBtn_LED3: jSwitchButton;
    jTimer_Device_Sta: jTimer;
    jTV_LED1: jTextView;
    jTV_LED2: jTextView;
    jTV_LED3: jTextView;
    jTextView_Send: jTextView;
    jTextView_Receive: jTextView;
    jTimer_Bluetooth_chk: jTimer;
    jTV_BT_Sta: jTextView;
    jTV_Connection_Sta: jTextView;
    jTV_BT_list: jTextView;
    jTV_BT_Mode: jTextView;
    procedure AndroidModule1ClickOptionMenuItem(Sender: TObject;
      jObjMenuItem: jObject; itemID: integer; itemCaption: string;
      checked: boolean);
    procedure AndroidModule1CloseQuery(Sender: TObject; var CanClose: boolean);
    procedure AndroidModule1CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jActionBarTab1TabSelected(Sender: TObject; view: jObject;
      title: string);
    procedure jActionBarTab1UnSelected(Sender: TObject; view: jObject;
      title: string);
    procedure jBluetooth1Disabled(Sender: TObject);
    procedure jBluetooth1DiscoveryFinished(Sender: TObject;
      countFoundedDevices: integer; countPairedDevices: integer);
    procedure jBluetooth1DiscoveryStarted(Sender: TObject);
    procedure jBluetooth1Enabled(Sender: TObject);
    procedure jBluetoothClientSocket1Connected(Sender: TObject;
      deviceName: string; deviceAddress: string);
    procedure jBluetoothClientSocket1Disconnected(Sender: TObject);
    procedure jBluetoothClientSocket1IncomingData(Sender: TObject;
      var dataContent: TDynArrayOfJByte; dataHeader: TDynArrayOfJByte);
    procedure jBtn_BT_DisconnectClick(Sender: TObject);
    procedure jBtn_BT_DiscoveryClick(Sender: TObject);
    procedure jBtn_BT_OFFClick(Sender: TObject);
    procedure jBtn_BT_ONClick(Sender: TObject);
    procedure jBtn_BT_PairedClick(Sender: TObject);
    procedure jBtn_UpdateStaClick(Sender: TObject);
    procedure jButton_sendClick(Sender: TObject);
    procedure jCheckBox_BT_RX_ToastClick(Sender: TObject);
    procedure jCheckBox_UpdateSta_autoClick(Sender: TObject);
    procedure jListView_BT_connectClickItem(Sender: TObject;
      ItemIndex: integer; itemCaption: string);
    procedure jListView_BT_connectDrawItemTextColor(Sender: TObject;
      ItemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge);
    procedure jListView_BT_RXLongClickItem(Sender: TObject; ItemIndex: integer;
      itemCaption: string);
    procedure jPanel_GPIOFlingGesture(Sender: TObject; flingGesture: TFlingGesture);
    procedure jPanel_TERMINALFlingGesture(Sender: TObject; flingGesture: TFlingGesture);
    procedure jPanel_SETUPFlingGesture(Sender: TObject; flingGesture: TFlingGesture);
    procedure jSwBtn_LED1Toggle(Sender: TObject; state: boolean);
    procedure jSwBtn_LED2Toggle(Sender: TObject; state: boolean);
    procedure jSwBtn_LED3Toggle(Sender: TObject; state: boolean);
    procedure jTimer_Bluetooth_chkTimer(Sender: TObject);
    procedure jTimer_Device_StaTimer(Sender: TObject);
  private
    {private declarations}
    FDeviceAddress: string;
    FDeviceName: string;
    FIsDiscovering: boolean;
    procedure ShowNewDevices;
    procedure ShowPairedDevices;
    procedure Discovery_BT;
    procedure ListPaired_BT;
    procedure Hide_BT_device_list;
    procedure Show_BT_device_list;
    procedure Parse_BT_RX_CMD(cmd: string);
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;
  receive_msg_str: string;
  jTimer_Bluetooth_chk_count: integer;
  toast_bt_rx_en: boolean;
  led1_skip_command: boolean;
  led2_skip_command: boolean;
  led3_skip_command: boolean;

  const
_prog: string = 'BT Arduno GPIO ';
_version: string = ' v1.0';
_author: string = 'Author Ibragimov M. aka maxx' + #$D + #$A + '26/09/17 Russia Togliatti';

implementation

{$R *.lfm}


{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  Self.SetScreenOrientationStyle(ssPortrait); //Portrait orientation only
  //toast_bt_rx_en := True; //Toast Bt RX enable by default
  toast_bt_rx_en := False; //Toast Bt RX disable by default
  jCheckBox_BT_RX_Toast.Checked := toast_bt_rx_en;

  //ActionBAR setup
  //ShowMessage('Bluetooth Arduino v1.0 tst');
  SetTitleActionBar(_prog + _version);
  jActionBarTab1.Add('GPIO', jPanel_GPIO.View);
  jActionBarTab1.Add('Terminal', jPanel_TERMINAL.View);
  jActionBarTab1.Add('Setup', jPanel_SETUP.View);
  Self.SetTabNavigationModeActionBar;  //this is needed!!!
  jActionBarTab1.SelectTabByIndex(2); // Set first Tab for setup


  //jSwBtn_LED1 custom image redraw
  if jSwBtn_LED1.State = tsOn then
  begin
    jSwBtn_LED1.SetThumbIcon('green_switch');
    jTV_LED1.Text := 'LED1 ON';
  end
  else
  begin
    jSwBtn_LED1.SetThumbIcon('grey_switch');
    jTV_LED1.Text := 'LED1 OFF';
  end;

  //jSwBtn_LED2 custom image redraw
  if jSwBtn_LED2.State = tsOn then
  begin
    jSwBtn_LED2.SetThumbIcon('green_switch');
    jTV_LED2.Text := 'LED2 ON';
  end
  else
  begin
    jSwBtn_LED2.SetThumbIcon('grey_switch');
    jTV_LED2.Text := 'LED2 OFF';
  end;

  //jSwBtn_LED3 custom image redraw
  if jSwBtn_LED3.State = tsOn then
  begin
    jSwBtn_LED3.SetThumbIcon('green_switch');
    jTV_LED3.Text := 'LED3 ON';
  end
  else
  begin
    jSwBtn_LED3.SetThumbIcon('grey_switch');
    jTV_LED3.Text := 'LED3 OFF';
  end;

  if (not jBluetooth1.IsEnable()) then
  begin
    jBluetooth1.Enabled();
    jTimer_Bluetooth_chk.Interval := 1000; // 30 sec wait to turn on Bluetooth module
    jTimer_Bluetooth_chk.Enabled := True;
    jTimer_Bluetooth_chk_count := 0;
  end
  else
  begin
    //Here when BT already enabled on startup app
    Discovery_BT;
    jTV_BT_Sta.Text := 'Bluetooth Status: ENABLED';
  end;

end;

procedure TAndroidModule1.AndroidModule1CloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if (jBluetoothClientSocket1.IsConnected()) then
    jBluetoothClientSocket1.Disconnect();
  CanClose := True;
end;

procedure TAndroidModule1.AndroidModule1ClickOptionMenuItem(Sender: TObject;
  jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean
  );
begin
  // Обработка <ClickOptionMenuItem> 1-го(10)/(About..) пункта меню
  if (itemID = 10) then
  begin
    jModalDialog1.Theme:=thHoloDialog;
    jModalDialog1.SetDialogTitle(_prog + _version  + #$D + #$A+ _author);
    jModalDialog1.SetHasWindowTitle(true);
    jModalDialog1.TitleFontSize:= 20;
    jModalDialog1.CaptionOK:= 'OK';
    jModalDialog1.ShowMessage(self.PackageName);   //OR gApp.AppName OR 'org.lamw.appmodaldialogdemo1'
    exit;
  end;
  // Second menu item
  {
  if (itemID = 11) then
  begin
    //Add your own handler
    exit;
  end;
  }
end;

procedure TAndroidModule1.AndroidModule1CreateOptionMenu(Sender: TObject;
  jObjMenu: jObject);
var
  i: integer;
begin
  // Create OptionMenu
  for i := 0 to jMenu1.Options.Count - 1 do
  begin
    //0:mitDefault; 1:misIfRoom
    //jMenu1.AddItem(jObjMenu, 10+i {itemID}, jMenu1.Options.Strings[i], jMenu1.IconIdentifiers.Strings[i] {..res/drawable-xxx}, mitDefault, misIfRoomWithText);
    jMenu1.AddItem(jObjMenu, 10 + i {itemID}, jMenu1.Options.Strings[i],
      'null', mitDefault, misNever);
  end;
end;

procedure TAndroidModule1.jActionBarTab1TabSelected(Sender: TObject;
  view: jObject; title: string);
begin
  //ShowMessage('Tab Selected: '+title);
end;

procedure TAndroidModule1.jActionBarTab1UnSelected(Sender: TObject;
  view: jObject; title: string);
begin
  //ShowMessage('Tab Un Selected: '+title);
end;

procedure TAndroidModule1.jBluetooth1Disabled(Sender: TObject);
begin
  ShowMessage('Bluetooth Off');
  jTV_BT_Sta.Text := 'Bluetooth Status: DISABLED';
  jTimer_Bluetooth_chk.Enabled := False;
end;

procedure TAndroidModule1.jBluetooth1DiscoveryFinished(Sender: TObject;
  countFoundedDevices: integer; countPairedDevices: integer);
begin
  jDialogProgress_BT_Discovery.Stop;
  FIsDiscovering := False;
  ShowNewDevices();
end;

procedure TAndroidModule1.jBluetooth1DiscoveryStarted(Sender: TObject);
begin
  FIsDiscovering := True;
  ShowMessage('Starting Discovering News Devices..');
end;

procedure TAndroidModule1.jBluetooth1Enabled(Sender: TObject);
begin
  if (jBluetooth1.IsEnable()) then
  begin
    ShowMessage('Bluetooth On');
    jTV_BT_Sta.Text := 'Bluetooth Status: ENABLED';
    jTimer_Bluetooth_chk.Enabled := False;
  end
  else
  begin
    jTV_BT_Sta.Text := 'Bluetooth Status: Trying to ENABLE';
    if (jTimer_Bluetooth_chk.Enabled = False) then
    begin
      jTimer_Bluetooth_chk.Interval := 1000; // 30 sec wait to turn on Bluetooth module
      jTimer_Bluetooth_chk.Enabled := True;
      jTimer_Bluetooth_chk_count := 0;
    end;
  end;
end;

procedure TAndroidModule1.jBluetoothClientSocket1Connected(Sender: TObject;
  deviceName: string; deviceAddress: string);
begin
  ShowMessage('Connected to server: [' + deviceName + '] [' + deviceAddress + ']');
  jTV_Connection_Sta.Text := 'Connected to: [' + deviceName + '] [' +
    deviceAddress + ']';
  Hide_BT_device_list;
  //Run BT Device Status timer if enabled
  if jCheckBox_UpdateSta_auto.Checked then
  begin
    jTimer_Device_Sta.Interval := 3000;
    jTimer_Device_Sta.Enabled := True;
  end;
  jTV_BT_Mode.Text := 'Connected device..';
end;

procedure TAndroidModule1.jBluetoothClientSocket1Disconnected(Sender: TObject);
begin
  ShowMessage('Disconnected...');
  jTV_Connection_Sta.Text := 'Disconnected';
  jTV_BT_list.Text := 'Bluetooth Device';
  jListView_BT_connect.Clear;
  Show_BT_device_list;
  //Stop BT Device Status timer
  jTimer_Device_Sta.Enabled := False;
  jTV_BT_Mode.Text := 'Disconnected device..';
end;

procedure TAndroidModule1.jBluetoothClientSocket1IncomingData(Sender: TObject;
  var dataContent: TDynArrayOfJByte; dataHeader: TDynArrayOfJByte);
var
  tmp_string: string;
  result_string: string;
  i, j: integer;
begin
  if jBluetoothClientSocket1.DataHeaderReceiveEnabled then //[Demo 1 ---> False]
  begin
    //if dataHeader <> nil then ...
  end
  else  //NO header ... DataHeaderReceiveEnabled = False
  begin
    //guess data format!
    //ShowMessage('Receveid from Server: "'+ jBluetoothClientSocket1.JByteArrayToString(dataContent)+'"');
    // Передается по несколько символов склеиваем до получения '\n' (0xA)
    result_string := '';
    tmp_string := jBluetoothClientSocket1.JByteArrayToString(dataContent);
    for i := 1 to Length(tmp_string) do
    begin
      //Check NewLine symbol
      if (tmp_string[i] <> #$A) then
      begin
        // Not end of line  - '\n' (0xA)
        receive_msg_str := receive_msg_str + tmp_string[i];
      end
      else
      begin
        // Catch New Line symbol - '\n' (0xA)
        receive_msg_str := receive_msg_str + tmp_string[i];
        // Now on <receive_mst_str> all string
        //If BT RX Toast enable show toast
        if toast_bt_rx_en then
        begin
          ShowMessage('Bluetooth RX: ' + #$D + #$A + '____________________' +
            #$D + #$A + #$D + #$A + receive_msg_str, gvBottom, slShort);
        end;
        // Strip from result string all none-printable symbols
        for j := 1 to Length(receive_msg_str) do
        begin
          if receive_msg_str[j] in [#3..#13] then
          begin
            // Do nothing
          end
          else
          begin
            result_string := result_string + receive_msg_str[j];
          end;
        end;
        //jEditText_Receive.Text:=result_string; // Show result string in EditText element
        if (jListView_BT_RX.Count > 100) then
          // Clear BT RX list after 100 strings received
        begin
          jListView_BT_RX.Clear;
        end;
        jListView_BT_RX.Add(result_string);
        jListView_BT_RX.SetSelection(jListView_BT_RX.Items.Count - 1);
        receive_msg_str := ''; // Clear string to prepare next receive
        Parse_BT_RX_CMD(result_string);
        Break;
      end;
    end;
  end;
end;

procedure TAndroidModule1.jBtn_BT_DisconnectClick(Sender: TObject);
begin
  //Disconnect BT
  if (jBluetoothClientSocket1.IsConnected()) then
    jBluetoothClientSocket1.Disconnect();
end;

procedure TAndroidModule1.jBtn_BT_DiscoveryClick(Sender: TObject);
begin
  Discovery_BT;
end;

procedure TAndroidModule1.jBtn_BT_OFFClick(Sender: TObject);
begin
  //Click on BT OFF, check BT is enabled..
  if jBluetooth1.IsEnable() then
  begin
    //ShowMessage('Bluetooth OFF');
    jBluetooth1.Disable();
  end;
end;

procedure TAndroidModule1.jBtn_BT_ONClick(Sender: TObject);
begin
  //Click on BT ON, check BT is disabled..
  if not (jBluetooth1.IsEnable()) then
  begin
    //ShowMessage('Bluetooth ON');
    jBluetooth1.Enabled();
  end;
end;

procedure TAndroidModule1.jBtn_BT_PairedClick(Sender: TObject);
begin
  ListPaired_BT;
end;

procedure TAndroidModule1.jBtn_UpdateStaClick(Sender: TObject);
begin
  if jBluetoothClientSocket1.IsConnected() then
  begin
    jBluetoothClientSocket1.WriteMessage('S' + #$D + #$A);  //Get BT device status
  end;
end;

procedure TAndroidModule1.jButton_sendClick(Sender: TObject);
begin
  if jBluetoothClientSocket1.IsConnected() then
  begin
    //jBluetoothClientSocket1.WriteMessage('Hi, Good Job! Message #' + IntToStr(test_send_msg_count) + #$D + #$A)  //NO header!
    jBluetoothClientSocket1.WriteMessage(jEditText_Send.Text + #$D + #$A);  //NO header!
  end
  else
  begin
    ShowMessage('Not Connected yet...');
  end;
end;

procedure TAndroidModule1.jCheckBox_BT_RX_ToastClick(Sender: TObject);
begin
  toast_bt_rx_en := jCheckBox_BT_RX_Toast.Checked;
end;

procedure TAndroidModule1.jCheckBox_UpdateSta_autoClick(Sender: TObject);
begin
  //Auto-Update Status device enable/disable
  if jCheckBox_UpdateSta_auto.Checked then
  begin
    if (jBluetooth1.IsEnable()) then
    begin
      if (jBluetoothClientSocket1.IsConnected()) then
      begin
        jTimer_Device_Sta.Enabled := True;
      end;
    end;
  end
  else
  begin
    jTimer_Device_Sta.Enabled := False;

  end;
end;

procedure TAndroidModule1.jListView_BT_connectClickItem(Sender: TObject;
  ItemIndex: integer; itemCaption: string);
var
  deviceName, deviceAddress: string;
begin

  //if ItemIndex = 0 then
  //  Exit;
  if jListView_BT_connect.Count = 0 then
    Exit;

  deviceAddress := itemCaption; // format: name|address
  deviceName := SplitStr(deviceAddress, '|');

  FDeviceAddress := deviceAddress;
  FDeviceName := deviceName;

  if Pos('null', deviceAddress) <= 0 then
  begin
    if jBluetooth1.IsReachablePairedDevice(deviceAddress) then
    begin
      jBluetoothClientSocket1.SetDevice(
        jBluetooth1.GetReachablePairedDeviceByAddress(deviceAddress));
      //well known SPP UUID
      jBluetoothClientSocket1.SetUUID('00001101-0000-1000-8000-00805F9B34FB');
      //default
      jBluetoothClientSocket1.Connect();

    end
    else
    begin
      ShowMessage('Try to pair device...');
      jBluetooth1.PairDeviceByAddress(deviceAddress);
      //ShowMessage('Not ReachablePairedDevice...');
    end;
  end;

end;

procedure TAndroidModule1.jListView_BT_connectDrawItemTextColor(Sender: TObject;
  ItemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge);
begin
  if ItemIndex = 0 then
    textColor := colbrPowderBlue;
end;

procedure TAndroidModule1.jListView_BT_RXLongClickItem(Sender: TObject;
  ItemIndex: integer; itemCaption: string);
begin
  jListView_BT_RX.Clear;
end;

procedure TAndroidModule1.jPanel_GPIOFlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
  case flingGesture of
    fliLeftToRight: jActionBarTab1.SelectTabByIndex(1);
    fliRightToLeft: jActionBarTab1.SelectTabByIndex(2);
  end;
end;

procedure TAndroidModule1.jPanel_TERMINALFlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
  case flingGesture of
    fliLeftToRight: jActionBarTab1.SelectTabByIndex(2);
    fliRightToLeft: jActionBarTab1.SelectTabByIndex(0);
  end;
end;

procedure TAndroidModule1.jPanel_SETUPFlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
  case flingGesture of
    fliLeftToRight: jActionBarTab1.SelectTabByIndex(0);
    fliRightToLeft: jActionBarTab1.SelectTabByIndex(1);
  end;
end;

procedure TAndroidModule1.jSwBtn_LED1Toggle(Sender: TObject; state: boolean);
begin
  //Check skip command flag
  if (led1_skip_command) then
  begin
    led1_skip_command := False;
  end
  else
  begin
    if jBluetoothClientSocket1.IsConnected() then
    begin
      if state then
      begin
        jBluetoothClientSocket1.WriteMessage('A' + #$D + #$A);  //CH#1 ON
      end
      else
      begin
        jBluetoothClientSocket1.WriteMessage('a' + #$D + #$A);  //CH#1 OFF
      end;
    end;
  end;
  //Redraw custom image for switch1
  if state = True then
  begin
    jSwBtn_LED1.SetThumbIcon('green_switch');
    jTV_LED1.Text := 'LED1 ON';
  end
  else
  begin
    jSwBtn_LED1.SetThumbIcon('grey_switch');
    jTV_LED1.Text := 'LED1 OFF';
  end;
end;

procedure TAndroidModule1.jSwBtn_LED2Toggle(Sender: TObject; state: boolean);
begin
  //Check skip command flag
  if (led2_skip_command) then
  begin
    led2_skip_command := False;
  end
  else
  begin
    if jBluetoothClientSocket1.IsConnected() then
    begin
      if state then
      begin
        jBluetoothClientSocket1.WriteMessage('B' + #$D + #$A);  //CH#2 ON
      end
      else
      begin
        jBluetoothClientSocket1.WriteMessage('b' + #$D + #$A);  //CH#2 OFF
      end;
    end;
  end;
  //Redraw custom image for switch2
  if state = True then
  begin
    jSwBtn_LED2.SetThumbIcon('green_switch');
    jTV_LED2.Text := 'LED2 ON';
  end
  else
  begin
    jSwBtn_LED2.SetThumbIcon('grey_switch');
    jTV_LED2.Text := 'LED2 OFF';
  end;
end;

procedure TAndroidModule1.jSwBtn_LED3Toggle(Sender: TObject; state: boolean);
begin
  //Check skip command flag
  if (led3_skip_command) then
  begin
    led3_skip_command := False;
  end
  else
  begin
    if jBluetoothClientSocket1.IsConnected() then
    begin
      if state then
      begin
        jBluetoothClientSocket1.WriteMessage('C' + #$D + #$A);  //CH#3 ON
      end
      else
      begin
        jBluetoothClientSocket1.WriteMessage('c' + #$D + #$A);  //CH#3 OFF
      end;
    end;
  end;
  //Redraw custom image for switch3
  if state = True then
  begin
    jSwBtn_LED3.SetThumbIcon('green_switch');
    jTV_LED3.Text := 'LED3 ON';
  end
  else
  begin
    jSwBtn_LED3.SetThumbIcon('grey_switch');
    jTV_LED3.Text := 'LED3 OFF';
  end;
end;

procedure TAndroidModule1.jTimer_Bluetooth_chkTimer(Sender: TObject);
begin
  //Check after 30 sec Android module Bluetooth is enabled, if not close app
  Inc(jTimer_Bluetooth_chk_count); // + 1 sec
  if (jTimer_Bluetooth_chk_count > 30) then
  begin
    jTimer_Bluetooth_chk.Enabled := False;
    //30 sec elapsed, check BT is enabled
    if (not jBluetooth1.IsEnable()) then
    begin
      AndroidModule1.Close;
    end
    else
    begin
      ShowMessage('Bluetooth On');
      jTV_BT_Sta.Text := 'Bluetooth Status: ENABLED';
      Discovery_BT;
    end;
  end
  else
  begin
    //30 sec not elapsed, check BT is enabled
    if (jBluetooth1.IsEnable()) then
    begin
      jTimer_Bluetooth_chk.Enabled := False;
      ShowMessage('Bluetooth On');
      jTV_BT_Sta.Text := 'Bluetooth Status: ENABLED';
      Discovery_BT;
    end;
  end;
end;

procedure TAndroidModule1.jTimer_Device_StaTimer(Sender: TObject);
begin
  if (jBluetooth1.IsEnable()) then
  begin
    if (jBluetoothClientSocket1.IsConnected()) then
    begin
      jBluetoothClientSocket1.WriteMessage('S' + #$D + #$A);  //Get BT device status
    end;
  end;
end;

procedure TAndroidModule1.ShowNewDevices;
var
  listArray: TDynArrayOfString;
  i, size: integer;
begin
  listArray := jBluetooth1.GetFoundedDevices();
  if listArray <> nil then
  begin
    size := Length(listArray);
    if size = 0 then
      ShowMessage('News Devices Not Found ... [0]')
    else
    begin
      if (listArray[0].Contains('null')) then
      begin
        ShowMessage('News Devices Not Found ... empty');
      end
      else
      begin
        jListView_BT_connect.Clear;
        //jListView_BT_connect.Add('      Select a Bluetooth Server:');
        jTV_BT_list.Text := 'Bluetooth Device: [Discovered]';
        for i := 0 to size - 1 do
        begin
          //ShowMessage(listArray[i]);
          jListView_BT_connect.Add(listArray[i]);
        end;
        SetLength(listArray, 0);
      end;
    end;
  end
  else
    ShowMessage('News Devices Not Found ... [nil]');
end;

procedure TAndroidModule1.ShowPairedDevices;
var
  listArray: TDynArrayOfString;
  i, size: integer;
begin
  listArray := jBluetooth1.GetReachablePairedDevices();
  if listArray <> nil then
  begin
    size := Length(listArray);
    if size = 0 then
      ShowMessage('Paired Devices Not Found ... [0]')
    else
    begin
      if (listArray[0].Contains('null')) then
      begin
        ShowMessage('Paired Devices Not Found ... empty');
      end
      else
      begin
        jListView_BT_connect.Clear;
        //jListView_BT_connect.Add('      [Paired] Select a Bluetooth Server');
        jTV_BT_list.Text := 'Bluetooth Device: [Paired]';
        for i := 0 to size - 1 do
        begin
          //ShowMessage(listArray[i]);
          jListView_BT_connect.Add(listArray[i]);
        end;
        SetLength(listArray, 0); //free ...
      end;
    end;
  end
  else
    ShowMessage('Paired Devices Not Found ... [nil]');
end;

procedure TAndroidModule1.Discovery_BT;
begin
  if (jBluetooth1.IsEnable() and (jBluetoothClientSocket1.IsConnected() = False)) then

  begin
    //Discovery BT devices
    jListView_BT_connect.Clear;
    jBluetooth1.Discovery();
    //handled by: OnDiscoveryStarted, OnDeviceFound and OnDiscoveryFinished
    jDialogProgress_BT_Discovery.Show();
  end;
end;

procedure TAndroidModule1.ListPaired_BT;
begin
  if (jBluetooth1.IsEnable()) then
  begin
    ShowMessage('Listing Only Paired Devices....');
    jListView_BT_connect.Clear;
    ShowPairedDevices();
  end;
end;

procedure TAndroidModule1.Hide_BT_device_list;
begin
  jListView_BT_connect.Visible := False;
  //jListView_BT_connect.UpdateLayout();
  jTV_BT_list.Visible := False;
  //jTV_BT_list.ResetAllRules();
  //jTV_BT_list.UpdateLayout;
end;

procedure TAndroidModule1.Show_BT_device_list;
begin
  jListView_BT_connect.Visible := True;
  //jListView_BT_connect.UpdateLayout();
  jTV_BT_list.Visible := True;
  //jTV_BT_list.ResetAllRules();
  //jTV_BT_list.UpdateLayout;
end;

procedure TAndroidModule1.Parse_BT_RX_CMD(cmd: string);
var
  i: integer;
  next_cmd: char;
begin
  //Parse received string(command) from BT device
  if (Length(cmd) > 0) then
  begin
    for i := 1 to Length(cmd) do
    begin
      next_cmd := cmd[i];
      case next_cmd of
        'M': //Auto mode received (Remote control device via BT)
        begin
          jTV_BT_Mode.Text := 'Bluetooth control';
        end;
        'm': //Manual mode received (Manual control device via local switches)
        begin
          jTV_BT_Mode.Text := 'Local control';
        end;
        'a': //CH#1 OFF
        begin
          jTV_LED1.Text := 'LED1 OFF';
          //SwBtn_Led1 toggle if needed
          if jSwBtn_LED1.State = tsOn then
          begin
            led1_skip_command := True; // Redraw only for SwBtn_Led1
            jSwBtn_LED1.Toggle();
          end;
        end;
        'A': //CH#1 ON
        begin
          jTV_LED1.Text := 'LED1 ON';
          //SwBtn_Led1 toggle if needed
          if jSwBtn_LED1.State = tsOff then
          begin
            led1_skip_command := True; // Redraw only for SwBtn_Led1
            jSwBtn_LED1.Toggle();
          end;
        end;
        'b': //CH#2 OFF
        begin
          jTV_LED2.Text := 'LED2 OFF';
          //SwBtn_Led2 toggle if needed
          if jSwBtn_LED2.State = tsOn then
          begin
            led2_skip_command := True; // Redraw only for SwBtn_Led2
            jSwBtn_LED2.Toggle();
          end;
        end;
        'B': //CH#2 ON
        begin
          jTV_LED2.Text := 'LED2 ON';
          //SwBtn_Led2 toggle if needed
          if jSwBtn_LED2.State = tsOff then
          begin
            led2_skip_command := True; // Redraw only for SwBtn_Led2
            jSwBtn_LED2.Toggle();
          end;
        end;
        'c': //CH#3 OFF
        begin
          jTV_LED3.Text := 'LED3 OFF';
          //SwBtn_Led3 toggle if needed
          if jSwBtn_LED3.State = tsOn then
          begin
            led3_skip_command := True; // Redraw only for SwBtn_Led3
            jSwBtn_LED3.Toggle();
          end;
        end;
        'C': //CH#3 ON
        begin
          jTV_LED3.Text := 'LED3 ON';
          //SwBtn_Led3 toggle if needed
          if jSwBtn_LED3.State = tsOff then
          begin
            led3_skip_command := True; // Redraw only for SwBtn_Led3
            jSwBtn_LED3.Toggle();
          end;
        end;
      end;
    end;
  end;
end;

end.
