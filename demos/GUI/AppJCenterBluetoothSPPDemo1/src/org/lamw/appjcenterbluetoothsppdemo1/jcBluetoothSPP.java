package org.lamw.appjcenterbluetoothsppdemo1;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import app.akexorcist.bluetotohspp.library.BluetoothSPP;
import app.akexorcist.bluetotohspp.library.BluetoothState;
import app.akexorcist.bluetotohspp.library.DeviceList;

/*Draft java code by "Lazarus Android Module Wizard" [11/22/2019 1:14:26]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref.
//https://github.com/akexorcist/Android-BluetoothSPPLibrary
public class jcBluetoothSPP /*extends ...*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    BluetoothSPP bt;

    boolean mDeviceTarget = BluetoothState.DEVICE_ANDROID;
    int connectionState = 0;
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jcBluetoothSPP(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;

        bt = new BluetoothSPP(context);

        bt.setOnDataReceivedListener(new BluetoothSPP.OnDataReceivedListener() {
            public void onDataReceived(byte[] data, String message) {
                // Do something when data incoming
               // controls.pOnDataReceived(byte[] data, String message);
                connectionState = 5;
                controls.pOnBluetoothSPPDataReceived(pascalObj, data, message);
            }
        });

        bt.setBluetoothConnectionListener(new BluetoothSPP.BluetoothConnectionListener() {
            public void onDeviceConnected(String name, String address) {
                // Do something when successfully connected
                connectionState = 3;
                controls.pOnBluetoothSPPDeviceConnected(pascalObj,name,address);
            }

            public void onDeviceDisconnected() {
                // Do something when connection was disconnected
                connectionState = 0;
                controls.pOnBluetoothSPPDeviceDisconnected(pascalObj);
            }

            public void onDeviceConnectionFailed() {
                connectionState = 4;
                controls.pOnBluetoothSPPDeviceConnectionFailed(pascalObj);
            }
        });

        bt.setBluetoothStateListener(new BluetoothSPP.BluetoothStateListener() {
            public void onServiceStateChanged(int state) {
                if(state == BluetoothState.STATE_CONNECTED) {
                    // Do something when successfully connected
                    connectionState = 3;
                }
                else if(state == BluetoothState.STATE_CONNECTING) {
                    // Do something while connecting
                    connectionState = 2;
                }
                else if(state == BluetoothState.STATE_LISTEN) {
                    // Do something when device is waiting for connection
                    connectionState = 1;
                }
                else if(state == BluetoothState.STATE_NONE) {
                    // Do something when device don't have any connection
                    connectionState = 0;
                }
                controls.pOnBluetoothSPPServiceStateChanged(pascalObj, connectionState);
            }
        });


        bt.setAutoConnectionListener(new BluetoothSPP.AutoConnectionListener() {
            public void onNewConnection(String name, String address) {
                // Do something when earching for new connection device
                connectionState = 6;
                controls.pOnBluetoothSPPListeningNewAutoConnection(pascalObj, name, address);
            }

            public void onAutoConnectionStarted() {
                // Do something when auto connection has started
                connectionState = 7;
                controls.pOnBluetoothSPPAutoConnectionStarted(pascalObj);
            }
        });

    }
  
    public void jFree() {
      //free local objects...
        if (bt == null) return;
        bt.stopService();
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public boolean IsBluetoothEnabled() {
        if (bt == null) return false;
        return bt.isBluetoothEnabled();
    }

    public void Enable() {
        if (bt == null) return;
        bt.enable();
    }

    public boolean IsBluetoothAvailable() {
        if (bt == null) return false;
       return bt.isBluetoothAvailable();
    }

    public boolean IsServiceAvailable() {
        if (bt == null) return false;
        return bt.isServiceAvailable();
    }

    public void SetupService() {
        if (bt == null) return;
        bt.setupService();
    }

    public void StartService(boolean _isAndroid) {
        if (bt == null) return;
        SetupService();
        if (_isAndroid)
            bt.startService(BluetoothState.DEVICE_ANDROID);
        else
            bt.startService(BluetoothState.DEVICE_OTHER); //any microcontroller which communication with bluetooth serial port profile module
    }

    public void SetDeviceTarget(boolean _deviceTargetIsAndroid) {
            mDeviceTarget = _deviceTargetIsAndroid; //android
            bt.setDeviceTarget(_deviceTargetIsAndroid);
    }

    public void StopService() {
        if (bt == null) return;
        bt.stopService();
    }

    public void Connect(Intent _intentData) {
        if (bt == null) return;
        bt.connect(_intentData);
    }

    public void Connect(String _address) {
        if (bt == null) return;
        bt.connect(_address);
    }

    public String GetConnectedDeviceAddress() {
        if (bt == null) return "";
        return bt.getConnectedDeviceAddress();
    }

    public String GetConnectedDeviceName() {
        if (bt == null) return "";
        return bt.getConnectedDeviceName();
    }

    public String[] GetPairedDeviceAddress() {
        if (bt == null) return null;
        return bt.getPairedDeviceAddress();
    }

    public String[] GetPairedDeviceName() {
        if (bt == null) return null;
        return bt.getPairedDeviceName();
    }

    public void Disconnect() {
        if (bt == null) return;
        bt.disconnect();
    }

    public boolean IsAutoConnecting() {
        if (bt == null) return false;
        return bt.isAutoConnecting();
    }

    public void CancelDiscovery(){
        if (bt == null) return;
        bt.cancelDiscovery();
    }

    public boolean IsDiscovery() {
        if (bt == null) return false;
        return bt.isDiscovery();
    }

    //boolean parameter is mean that data will send with ending by LF and CR or not. If yes your data will added by LF & CR
    public void Send(String _messageData,  boolean _CrLf) {
        if (bt == null) return;
        bt.send(_messageData, _CrLf);
    }

    public void Send(byte[]  _jbyteArrayData,  boolean _CrLf) {
        if (bt == null) return;
        //bt.send(new byte[] { 0x30, 0x38, ....}, false);
        bt.send(_jbyteArrayData , false);
    }

    public void AutoConnect(String _keywordForFilterPairedDevice) {
        if (bt == null) return;
        //Using auto connection
        //bt.autoConnect("Keyword for filter paired device");
        bt.autoConnect(_keywordForFilterPairedDevice);
    }

    public String GetActivityDeviceListClass() {
        return "app.akexorcist.bluetotohspp.library.DeviceList";
    }

    // <activity android:name="app.akexorcist.bluetoothspp.DeviceList" />
    public void StartActivityDeviceListForResult() {
        if (bt == null) return;
           if (bt.getServiceState() == BluetoothState.STATE_CONNECTED) {
              bt.disconnect();
           } else {
              Intent intent = new Intent(controls.activity.getApplicationContext(), DeviceList.class);
              controls.activity.startActivityForResult(intent, BluetoothState.REQUEST_CONNECT_DEVICE);
           }
    }

    public String GetIntentActionEnableBluetooth() {
        return "android.bluetooth.adapter.action.REQUEST_ENABLE";
    }

    public void StartActivityEnableBluetoothForResult() {
            Intent intent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            controls.activity.startActivityForResult(intent, BluetoothState.REQUEST_ENABLE_BT);
    }

    public int GetConnectionState(){
        if (bt == null) return -1;
        return bt.getServiceState();
    }

    public int GetConnectionStateAutoExtra() {
        if (bt.getServiceState() == -1)
          return -1;
        else
          return connectionState;
    }

}

