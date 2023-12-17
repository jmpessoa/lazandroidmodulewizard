package org.lamw.appcompatarduinoaflakserialdemo1;
 
import android.content.Context;
import android.hardware.usb.UsbDevice;
import android.os.Handler;
import me.aflak.arduino.Arduino;
import me.aflak.arduino.ArduinoListener;

/*Draft java code by "Lazarus Android Module Wizard" [12/15/2023 19:44:31]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref
//https://hingxyu.medium.com/arduino-android-serial-communication-b72b124142fb

public class jsArduinoAflakSerial implements ArduinoListener /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;

    private Arduino arduino;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jsArduinoAflakSerial(Controls _ctrls, long _self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _self;
        controls = _ctrls;
        arduino = new Arduino(_ctrls.activity);
        arduino.setArduinoListener(this);
    }

    public void jFree() {
        //free local objects...
        arduino.unsetArduinoListener();
        arduino.close();
    }

    @Override
    public void onArduinoAttached(UsbDevice device) {  //arduino plugged in. Here you should call arduino.open(device)
        display("arduino attached...");
        controls.pOnArduinoAflakSerialAttached(pascalObj, device);
    }

    @Override
    public void onArduinoDetached() {  //arduino plugged out
        display("arduino detached.");
        controls.pOnArduinoAflakSerialDetached(pascalObj);
    }

    @Override
    public void onArduinoMessage(byte[] bytes) {  //arduino sent a message through Serial.print()
        display(new String(bytes));
        controls.pOnArduinoAflakSerialMessageReceived(pascalObj, bytes);
    }

    @Override
    public void onArduinoOpened() {   // connection with arduino opened
        String str = "arduino opened...";
        display(str);
        //arduino.send(str.getBytes());
        controls.pOnArduinoAflakSerialOpened(pascalObj);
    }

    @Override
    public void onUsbPermissionDenied() {
        display("Permission denied. Attempting again in 3 sec...");
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                arduino.reopen();
            }
        }, 3000);
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    private void display(final String message) {
        controls.activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                // displayTextView.append(message);
                controls.pOnArduinoAflakSerialStatusChanged(pascalObj,message);
            }
        });
    }

    public void Send(String _stringMessage) { //"Hello Arduino! This is Android.";
        arduino.send(_stringMessage.getBytes());
        //editText.getText().clear();
    }

    public void Send(byte[] _jbyteMessage) { //"Hello Arduino! This is Android.";
        arduino.send(_jbyteMessage);
        //editText.getText().clear();
    }

    public void Open(UsbDevice _usb) {
        arduino.open(_usb);
    }

    public void Close() {
        arduino.close();
    }

    public String JBytesToString(byte[] _jbytes) {
        return new String(_jbytes);
    }
}
