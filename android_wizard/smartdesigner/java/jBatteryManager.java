package org.lamw.appbatterymanagerdemo1;

import android.content.Context;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;

/*Draft java code by "Lazarus Android Module Wizard" [8/7/2021 16:33:18]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//https://developer.android.com/training/monitoring-device-state/battery-monitoring#MonitorChargeState
//https://java2blog.com/get-battery-level-and-state-in-android-programmatically/
//

public class jBatteryManager /*extends ...*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    IntentFilter intentfilter;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jBatteryManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;

       intentfilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);

       controls.activity.registerReceiver(broadcastreceiver,intentfilter);
    }
  
    public void jFree() {
      //free local objects...
        controls.activity.unregisterReceiver(broadcastreceiver);
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    private BroadcastReceiver broadcastreceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {

            int deviceStatus = intent.getIntExtra(BatteryManager.EXTRA_STATUS,-1);

            int batteryLevel = GetBatteryPercent(intent);

            if(deviceStatus == BatteryManager.BATTERY_STATUS_CHARGING){
                // How are we charging?
                int chargePlug = intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1);
                //BatteryManager.BATTERY_PLUGGED_USB) //2
                //BatteryManager.BATTERY_PLUGGED_AC) //1
                int plug;

                switch(chargePlug) {
                    case 1: plug = 1; break;
                    case 2: plug = 2; break;
                    default: plug = 0;
                }

                controls.pOnBatteryCharging(pascalObj,batteryLevel, plug);
            }

            if(deviceStatus == BatteryManager.BATTERY_STATUS_DISCHARGING){
                controls.pOnBatteryDisCharging(pascalObj,batteryLevel);
            }

            if (deviceStatus == BatteryManager.BATTERY_STATUS_FULL){
                controls.pOnBatteryFull(pascalObj,batteryLevel);
            }

            if(deviceStatus == BatteryManager.BATTERY_STATUS_UNKNOWN){
                controls.pOnBatteryUnknown(pascalObj,batteryLevel);
            }

            if (deviceStatus == BatteryManager.BATTERY_STATUS_NOT_CHARGING){
                controls.pOnBatteryNotCharging(pascalObj,batteryLevel);
            }
        }
    };

    private int GetBatteryPercent(Intent intent) {
        int ret = -1;
        if (Build.VERSION.SDK_INT >= 21) {
            //[ifdef_api21up]
            BatteryManager bm = (BatteryManager) this.controls.activity.getSystemService(this.controls.activity.BATTERY_SERVICE);
            if (bm != null) {
                ret = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
            }
            //[endif_api21up]
        } else {
            int level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
            int scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
            ret = (int)(((float)level / (float)scale) * 100.0f);
        }
        return ret;
    }

    // BY ADiV
    public int GetBatteryPercent() {
        int ret = -1;
        if (Build.VERSION.SDK_INT >= 21) {
            //[ifdef_api21up]
            BatteryManager bm = (BatteryManager) this.controls.activity.getSystemService(this.controls.activity.BATTERY_SERVICE);
            if (bm != null) {
                ret = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
            }
            //[endif_api21up]
        } else {
            IntentFilter iFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
            if (iFilter == null) {
                return ret;
            }
            Intent batteryStatus = this.controls.activity.registerReceiver(null, iFilter);

            int level = batteryStatus != null ? batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) : -1;
            int scale = batteryStatus != null ? batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1) : -1;

            double batteryPct = level / (double) scale;

            ret = (int) (batteryPct * 100);
        }
        return ret;
    }


}
