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
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;

    private final static String TAG = "LAMW";

    String mHost = "192.168.0.105";
    int mPort = 502;
    boolean mEncapsulated = false;
    boolean mKeepAlive = true;
    int mTimeout = 2000;
    int mRetries = 0;

    boolean mModbusInitialized = false;

    public String data_;
    //ObservableField<String> data_;
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jModbus(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
    }

    public void jFree() {
        //free local objects...
        ModbusReq.getInstance().destory();
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void ShowToast(String msg) {
        //data_ = "";
        Log.i("ShowMessage", msg);
        Toast toast = Toast.makeText(controls.activity, msg, Toast.LENGTH_SHORT);

        if (toast != null) {
            //toast.setGravity(Gravity.BOTTOM, 0, 0);
            //toast.show();
            //return msg;
            //data_ = msg;
            //msg_();
        }

    }


    public String msg_() {
        return data_;
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
                        data_ = "modbus_success_initiated";
                    }

                    @Override
                    public void onFailed(String msg) {
                        data_ = "modbus_failed_initiated";
                    }
                });
    }

    public void ReadCoil(int _slaveId, int _start, int _len) { //View view
        if (!mModbusInitialized) {
            data_ = "modbus_not_yet_initiated";
        }
        ModbusReq.getInstance().readCoil(new OnRequestBack<boolean[]>() {
            @Override
            public void onSuccess(boolean[] booleen) {
                data_ = Arrays.toString(booleen);
            }

            @Override
            public void onFailed(String msg) {
                data_ = msg;
            }
        }, _slaveId, _start, _len); //1, 1, 2
    }

    public void ReadDiscreteInput(int _slaveId, int _start, int _len) { //View view
        if (!mModbusInitialized) {
            data_ = "modbus_not_yet_initiated";
        }
        ModbusReq.getInstance().readDiscreteInput(new OnRequestBack<boolean[]>() {
            @Override
            public void onSuccess(boolean[] booleen) {
                data_ = Arrays.toString(booleen);
            }

            @Override
            public void onFailed(String msg) {
                data_ = msg;
            }
        }, _slaveId, _start, _len); //1, 1, 5
    }

    public void ReadHoldingRegisters(int _slaveId, int _start, int _len) {  //View view
        if (!mModbusInitialized) {
            data_ = "modbus_not_yet_initiated";
        }
        //readHoldingRegisters
        ModbusReq.getInstance().readHoldingRegisters(new OnRequestBack<short[]>() {
            @Override
            public void onSuccess(short[] data) {
                data_ = Arrays.toString(data);
            }

            @Override
            public void onFailed(String msg) {
                data_ = "failed_read_holding_registers";
            }
        }, _slaveId, _start, _len); //1, 2, 8
    }

    public void ReadInputRegisters(int _slaveId, int _start, int _len) { //View view
        if (!mModbusInitialized) {
            data_ = "modbus_not_yet_initiated";
            msg_();
        }
        ModbusReq.getInstance().readInputRegisters(new OnRequestBack<short[]>() {
            @Override
            public void onSuccess(short[] data) {
                data_ = Arrays.toString(data);
                msg_();
            }

            @Override
            public void onFailed(String msg) {
                data_ = msg;
                msg_();
            }
        }, _slaveId, _start, _len); //1, 2, 8
    }

    public void WriteCoil(int _slaveId, int _offset, boolean _value) { //View view
        if (!mModbusInitialized) {
            data_ = "modbus_not_yet_initiated";
            msg_();
        }
        ModbusReq.getInstance().writeCoil(new OnRequestBack<String>() {
            @Override
            public void onSuccess(String s) {
                data_ = "write_coil_ok:" + s;
                msg_();
            }

            @Override
            public void onFailed(String msg) {
                data_ = "write_coil_failed:" + msg;
                msg_();
            }
        }, _slaveId, _offset, _value); //1, 1, true
    }

    public void WriteRegister(int _slaveId, int _offset, int _value) {  //View view
        if (!mModbusInitialized) {
            data_ = "modbus_not_yet_initiated";
            msg_();
        }
        ModbusReq.getInstance().writeRegister(new OnRequestBack<String>() {
            @Override
            public void onSuccess(String s) {
                data_ = "write_register_ok:" + s;
                msg_();
            }

            @Override
            public void onFailed(String msg) {
                data_ = "write_coil_failed:" + msg;
                msg_();
            }
        }, _slaveId, _offset, _value); //1, 1, 234
    }

    public void WriteRegisters(int _slaveId, int _start, short[] _shortArrayValues) {  //View view

        if (!mModbusInitialized) {
            data_ = "modbus_not_yet_initiated";
            msg_();
        }

        ModbusReq.getInstance().writeRegisters(new OnRequestBack<String>() {
            @Override
            public void onSuccess(String s) {
                data_ = "write_register_ok:" + s;
                msg_();
            }

            @Override
            public void onFailed(String msg) {
                data_ = "write_coil_failed:" + msg;
                msg_();
            }
        }, _slaveId, _start, _shortArrayValues); //1, 2, new short[]{211, 52, 34}
    }

    public boolean IsConnected() {
        return mModbusInitialized;
    }

}
