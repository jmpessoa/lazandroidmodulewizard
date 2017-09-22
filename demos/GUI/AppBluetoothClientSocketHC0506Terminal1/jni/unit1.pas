{Hint: save all files to location: C:\adt32\eclipse\workspace\AppBluetoothClientSocketHC0506Terminal\jni }
{
 Subj:
 A little bit "polished" - lamw:AppBluetoothClientSocketDemo1 (Author jmpessoa)
 For Electronics Tinkerer - HC-05/06 - BT Terminal

 Author:
 Ibragimov M. aka maxx
 Russia Togliatty 22/09/17
}
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, bluetooth, bluetoothclientsocket, AndroidWidget, menu;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBluetooth1: jBluetooth;
    jBluetoothClientSocket1: jBluetoothClientSocket;
    jButton_send: jButton;
    jDialogProgress_BT_Discovery: jDialogProgress;
    jEditText_Send: jEditText;
    jListView_BT_connect: jListView;
    jListView_BT_RX: jListView;
    jMenu1: jMenu;
    jPanel_BT_connect: jPanel;
    jTextView_BT_list: jTextView;
    jTextView_Send: jTextView;
    jTextView_Receive: jTextView;
    jTimer_Bluetooth_chk: jTimer;

    procedure AndroidModule1ClickOptionMenuItem(Sender: TObject;
      jObjMenuItem: jObject; itemID: integer; itemCaption: string;
      Checked: boolean);
    procedure AndroidModule1CloseQuery(Sender: TObject; var CanClose: boolean);
    procedure AndroidModule1CreateOptionMenu(Sender: TObject; jObjMenu: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jBluetooth1DeviceFound(Sender: TObject; deviceName: string;
      deviceAddress: string);
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

    procedure jButton_sendClick(Sender: TObject);
    procedure jButton6Click(Sender: TObject);

    procedure jListView_BT_connectClickItem(Sender: TObject;
      ItemIndex: integer; itemCaption: string);
    procedure jListView_BT_connectDrawItemTextColor(Sender: TObject;
      ItemIndex: integer; itemCaption: string; out textColor: TARGBColorBridge);
    procedure jListView_BT_RXLongClickItem(Sender: TObject; ItemIndex: integer;
      itemCaption: string);
    procedure jTimer_Bluetooth_chkTimer(Sender: TObject);

  private
    {private declarations}
    FDeviceAddress: string;
    FDeviceName: string;

    FIsDiscovering: boolean;
    procedure ShowPairedDevices;
    procedure ShowNewDevices;
    procedure Discovery_BT;
    procedure ListPaired_BT;
    procedure Hide_BT_panel;
    procedure Show_BT_panel;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;
  test_send_msg_count: integer;
  receive_msg_str: string;
  jTimer_Bluetooth_chk_count: integer;
  toast_bt_rx_en: boolean;



implementation

{$R *.lfm}

{ TAndroidModule1 }

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
        jTextView_BT_list.Text := 'Bluetooth Device: [Paired]';
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
        jTextView_BT_list.Text := 'Bluetooth Device: [Discovered]';
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

procedure TAndroidModule1.Discovery_BT;
begin
  if (jBluetooth1.IsEnable()) then
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

procedure TAndroidModule1.Hide_BT_panel;
begin
  jPanel_BT_connect.Visible := False;
  jPanel_BT_connect.ResetAllRules;
  jPanel_BT_connect.UpdateLayout();
  jTextView_Send.Anchor := nil;
  jTextView_Send.PosRelativeToParent := [rpTop, rpLeft];
  jTextView_Send.PosRelativeToAnchor := [];
  jTextView_Send.ResetAllRules();
  jTextView_Send.UpdateLayout;
end;

procedure TAndroidModule1.Show_BT_panel;
begin
  jPanel_BT_connect.Visible := True;
  jPanel_BT_connect.ResetAllRules;
  jPanel_BT_connect.UpdateLayout();
  jTextView_Send.Anchor := jPanel_BT_connect;
  jTextView_Send.PosRelativeToParent := [rpLeft];
  jTextView_Send.PosRelativeToAnchor := [raAlignBottom];
  jTextView_Send.ResetAllRules();
  jTextView_Send.UpdateLayout;
end;

procedure TAndroidModule1.jBluetooth1DeviceFound(Sender: TObject;
  deviceName: string; deviceAddress: string);
begin
  //ShowMessage('deviceName: ' +deviceName +' : deviceAddress: '+deviceAddress);
  //jListView_BT_connect.Add(deviceName + '|' + deviceAddress);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  BT_device: string;
begin
  Self.SetScreenOrientationStyle(ssPortrait); //Portrait orientation only
  toast_bt_rx_en := True; //Toast Bt RX enable by default
  if (not jBluetooth1.IsEnable()) then
  begin
    jBluetooth1.Enabled();
    jTimer_Bluetooth_chk.Interval := 1000; // 15 sec wait to turn on Bluetooth module
    jTimer_Bluetooth_chk.Enabled := True;
    jTimer_Bluetooth_chk_count := 0;
  end
  else
  begin
    //Here when BT already enabled on startup app
    Discovery_BT;
  end;
end;

procedure TAndroidModule1.AndroidModule1CreateOptionMenu(Sender: TObject;
  jObjMenu: jObject);
var
  i: integer;
begin
  // Create OptionMenu
  for i := 0 to jMenu1.Options.Count - 1 do
  begin
    if (i = 6) then // <BT RX toast> - checkable item
    begin
      jMenu1.AddItem(jObjMenu, 10 + i {itemID}, jMenu1.Options.Strings[i],
        'null', mitCheckable, misNever); // Chackable menu item
      if (toast_bt_rx_en) then
        jMenu1.CheckItem(jMenu1.GetMenuItemByIndex(i))
      else
        jMenu1.UnCheckItem(jMenu1.GetMenuItemByIndex(i));
    end
    else
    begin
      //0:mitDefault; 1:misIfRoom
      //jMenu1.AddItem(jObjMenu, 10+i {itemID}, jMenu1.Options.Strings[i], jMenu1.IconIdentifiers.Strings[i] {..res/drawable-xxx}, mitDefault, misIfRoomWithText);
      jMenu1.AddItem(jObjMenu, 10 + i {itemID}, jMenu1.Options.Strings[i],
        'null', mitDefault, misNever);
    end;
  end;
end;

procedure TAndroidModule1.AndroidModule1ClickOptionMenuItem(Sender: TObject;
  jObjMenuItem: jObject; itemID: integer; itemCaption: string; Checked: boolean);
begin
  // Обработка <ClickOptionMenuItem> 1-го(10)/(Bluetooth ON), 2-го(11)/(Bluetooth OFF) пунктов меню
  if (itemID = 10) then
  begin
    //Click on BT ON, check BT is disabled..
    if not (jBluetooth1.IsEnable()) then
    begin
      ShowMessage('Bluetooth ON');
      jBluetooth1.Enabled();
    end;
    exit;
  end;
  if (itemID = 11) then
  begin
    //Click on BT OFF, check BT is enabled..
    if jBluetooth1.IsEnable() then
    begin
      ShowMessage('Bluetooth OFF');
      jBluetooth1.Disable();
    end;
    exit;
  end;
  if (itemID = 12) then
  begin
    //Discovery BT
    Discovery_BT;
    exit;
  end;
  if (itemID = 13) then
  begin
    //ListPaired BT
    ListPaired_BT;
    exit;
  end;
  if (itemID = 14) then
  begin
    //Disconnect BT
    if (jBluetoothClientSocket1.IsConnected()) then
      jBluetoothClientSocket1.Disconnect();
    exit;
  end;
  if (itemID = 15) then
  begin
    //AndroidModule1.Restart(1000);
    jListView_BT_RX.Clear;
    exit;
  end;
  //Check/Uncheck BT RX Toast enable
  if (itemID = 16) then
  begin
    if (toast_bt_rx_en) then
    begin
      jMenu1.UnCheckItem(jObjMenuItem);
    end
    else
    begin
      jMenu1.CheckItem(jObjMenuItem);
    end;
    toast_bt_rx_en := not toast_bt_rx_en;
  end;
end;

procedure TAndroidModule1.AndroidModule1CloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  if (jBluetoothClientSocket1.IsConnected()) then
    jBluetoothClientSocket1.Disconnect();
  CanClose := True;

end;

procedure TAndroidModule1.jBluetooth1Disabled(Sender: TObject);
begin
  ShowMessage('Bluetooth Off');
end;

procedure TAndroidModule1.jBluetooth1DiscoveryFinished(Sender: TObject;
  countFoundedDevices: integer; countPairedDevices: integer);
begin
  //ShowMessage('***Discovery Finished! Founded Devices = '+IntToStr(countFoundedDevices));
  //ShowMessage('...Discovery Finished! Reachable Paired Devices = '+IntToStr(countPairedDevices));
  //ShowMessage('Discovery Finished!');
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
    jTimer_Bluetooth_chk.Enabled := False;
  end;
end;

//http://kpbird.blogspot.com.br/2011/04/android-send-image-via-bluetooth.html
procedure TAndroidModule1.jButton_sendClick(Sender: TObject);
begin
  Inc(test_send_msg_count);
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

procedure TAndroidModule1.jButton6Click(Sender: TObject);
begin
  jBluetoothClientSocket1.Disconnect();
end;

procedure TAndroidModule1.jBluetoothClientSocket1Connected(Sender: TObject;
  deviceName: string; deviceAddress: string);
begin
  ShowMessage('Connected to server: [' + deviceName + '] [' + deviceAddress + ']');
  Hide_BT_panel;
end;

procedure TAndroidModule1.jBluetoothClientSocket1Disconnected(Sender: TObject);
begin
  ShowMessage('Disconnected...');
  jTextView_BT_list.Text := 'Bluetooth Device';
  jListView_BT_connect.Clear;
  Show_BT_panel;
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
        jListView_BT_RX.Add(result_string);
        jListView_BT_RX.SetSelection(jListView_BT_RX.Items.Count - 1);
        receive_msg_str := ''; // Clear string to prepare next receive
        Break;
      end;
    end;
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
      Discovery_BT;
    end;
  end;
end;

end.
