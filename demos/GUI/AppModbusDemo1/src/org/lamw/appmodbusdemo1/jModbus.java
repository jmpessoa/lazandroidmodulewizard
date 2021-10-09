package org.lamw.appmodbusdemo1;

import android.content.Context;

import android.util.Log;
import android.widget.Toast;
import com.zgkxzx.modbus4And.requset.ModbusParam;
import com.zgkxzx.modbus4And.requset.ModbusReq;
import com.zgkxzx.modbus4And.requset.OnRequestBack;

import java.util.Arrays;

/*Draft java code by "Lazarus Android Module Wizard" [10/9/2021 0:08:00]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//https://github.com/zgkxzx/Modbus4Android

public class jModbus /*extends ...*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    private final static String TAG = "LAMW";

    String mHost = "192.168.0.105";
    int mPort = 502;
    boolean mEncapsulated = false;
    boolean mKeepAlive = true;
    int mTimeout = 2000;
    int mRetries = 0;

    boolean mModbusInitialized = false;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jModbus(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }
  
    public void jFree() {
      //free local objects...
        ModbusReq.getInstance().destory();
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void ShowToast(String msg) {
        Log.i("ShowMessage", msg);
        Toast toast = Toast.makeText(controls.activity, msg, Toast.LENGTH_SHORT);

        if (toast != null) {
            //toast.setGravity(Gravity.BOTTOM, 0, 0);
            toast.show();
        }
    }

    public void Connect(String _hostIP, int _portNumber) {
        mHost = _hostIP;
        mPort = _portNumber;

        mModbusInitialized = false;

        ModbusReq.getInstance().setParam(new ModbusParam()
                .setHost(mHost)
                .setPort(mPort)
                .setEncapsulated(mEncapsulated)
                .setKeepAlive(mKeepAlive)
                .setTimeout(mTimeout)
                .setRetries(mRetries))
                .init(new OnRequestBack<String>() {
                    @Override
                    public void onSuccess(String s) {
                        mModbusInitialized = true;

                        ShowToast("InitModbus: Success!! " + s);
                        Log.d(TAG, "onSuccess " + s);
                    }
                    @Override
                    public void onFailed(String msg) {
                        ShowToast("InitModbus: Failed... " + msg);
                        Log.d(TAG, "onFailed " + msg);
                    }
                });
    }

    public void ReadCoil(int _slaveId, int _start, int _len) { //View view
        if (!mModbusInitialized) {
            ShowToast("Sorry ... Modbus not initialized...");
            return;
        }
        ModbusReq.getInstance().readCoil(new OnRequestBack<boolean[]>() {
            @Override
            public void onSuccess(boolean[] booleen) {
                ShowToast("ReadCoil: Success!!  " + Arrays.toString(booleen));
                Log.d(TAG, "readCoil onSuccess " + Arrays.toString(booleen));
            }

            @Override
            public void onFailed(String msg) {
                ShowToast("ReadCoil: Failed...  " + msg);
                Log.e(TAG, "readCoil onFailed " + msg);
            }
        }, _slaveId, _start, _len); //1, 1, 2
    }

    public void ReadDiscreteInput(int _slaveId, int _start, int _len) { //View view
        if (!mModbusInitialized) {
            ShowToast("Sorry ... Modbus not initialized...");
            return;
        }
        ModbusReq.getInstance().readDiscreteInput(new OnRequestBack<boolean[]>() {
            @Override
            public void onSuccess(boolean[] booleen) {
                ShowToast("ReadDiscreteInput: Success!!  " +Arrays.toString(booleen));
                Log.d(TAG, "readDiscreteInput onSuccess " + Arrays.toString(booleen));
            }

            @Override
            public void onFailed(String msg) {
                ShowToast("ReadDiscreteInput: Failed...  " +msg);
                Log.e(TAG, "readDiscreteInput onFailed " + msg);
            }
        }, _slaveId, _start, _len); //1, 1, 5
    }

    public void ReadHoldingRegisters(int _slaveId, int _start, int _len) {  //View view
        if (!mModbusInitialized) {
            ShowToast("Sorry ... Modbus not initialized...");
            return;
        }
        //readHoldingRegisters
        ModbusReq.getInstance().readHoldingRegisters(new OnRequestBack<short[]>() {
            @Override
            public void onSuccess(short[] data) {
                ShowToast("ReadHoldingRegisters: Success!!  " +Arrays.toString(data));
                Log.d(TAG, "readHoldingRegisters onSuccess " + Arrays.toString(data));
            }

            @Override
            public void onFailed(String msg) {
                ShowToast("ReadHoldingRegisters: Failed...  " +msg);
                Log.e(TAG, "readHoldingRegisters onFailed " + msg);
            }
        }, _slaveId, _start, _len); //1, 2, 8


    }

    public void ReadInputRegisters(int _slaveId, int _start, int _len) { //View view
        if (!mModbusInitialized) {
            ShowToast("Sorry ... Modbus not initialized...");
            return;
        }
        ModbusReq.getInstance().readInputRegisters(new OnRequestBack<short[]>() {
            @Override
            public void onSuccess(short[] data) {
                ShowToast("ReadInputRegisters: Success!!  " +Arrays.toString(data));
                Log.d(TAG, "readInputRegisters onSuccess " + Arrays.toString(data));
            }

            @Override
            public void onFailed(String msg) {
                ShowToast("ReadInputRegisters: Failed...  " +msg);
                Log.e(TAG, "readInputRegisters onFailed " + msg);
            }
        }, _slaveId, _start, _len); //1, 2, 8
    }

    public void WriteCoil(int _slaveId, int _offset, boolean _value) { //View view
        if (!mModbusInitialized) {
            ShowToast("Sorry ... Modbus not initialized...");
            return;
        }
        ModbusReq.getInstance().writeCoil(new OnRequestBack<String>() {
            @Override
            public void onSuccess(String s) {
                ShowToast("WriteCoil: Success!!  " +s);
                Log.e(TAG, "writeCoil onSuccess " + s);
            }

            @Override
            public void onFailed(String msg) {
                ShowToast("WriteCoil: Failed...  " +msg);
                Log.e(TAG, "writeCoil onFailed " + msg);
            }
        }, _slaveId, _offset, _value); //1, 1, true
    }

    public void WriteRegister(int _slaveId, int _offset, int _value) {  //View view
        if (!mModbusInitialized) {
            ShowToast("Sorry ... Modbus not initialized...");
            return;
        }
        ModbusReq.getInstance().writeRegister(new OnRequestBack<String>() {
            @Override
            public void onSuccess(String s) {
                ShowToast("WriteRegister: Success!!  " +s);
                Log.e(TAG, "writeRegister onSuccess " + s);
            }

            @Override
            public void onFailed(String msg) {
                ShowToast("WriteRegister: Failed...  " +msg);
                Log.e(TAG, "writeRegister onFailed " + msg);
            }
        }, _slaveId, _offset, _value); //1, 1, 234
    }

    public void WriteRegisters(int _slaveId, int _start, short[] _shortArrayValues) {  //View view

        if (!mModbusInitialized) {
            ShowToast("Sorry ... Modbus not initialized...");
            return;
        }

        ModbusReq.getInstance().writeRegisters(new OnRequestBack<String>() {
            @Override
            public void onSuccess(String s) {
                ShowToast("WriteRegisters: Success!!  " +s);
                Log.e(TAG, "writeRegisters onSuccess " + s);
            }

            @Override
            public void onFailed(String msg) {
                ShowToast("WriteRegisters: Failed...  " +msg);
                Log.e(TAG, "writeRegisters onFailed " + msg);
            }
        }, _slaveId, _start, _shortArrayValues); //1, 2, new short[]{211, 52, 34}
    }

    public  boolean IsConnected() {
        return mModbusInitialized;
    }

}
