package com.example.appdownloadmanagerdemo1;

import android.app.Activity;
import android.app.DownloadManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;

/*Draft java code by "Lazarus Android Module Wizard" [1/18/2015 1:40:32]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jBroadcastReceiver extends BroadcastReceiver {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   
   private int mResultCode;
   private String mResultData;
   private Bundle mResultExtras; 
 
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jBroadcastReceiver(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
   }
 
   public void jFree() {
     //free local objects...
   }

   @Override
   /*.*/public void onReceive(Context arg0, Intent intent) { 
	   mResultCode = -1;
	   switch (this.getResultCode()) {
	        case Activity.RESULT_OK: mResultCode = 1; break;
	        case Activity.RESULT_CANCELED: mResultCode = 0; break;  
	   }	     	     	
	   
	   mResultData = this.getResultData();	    	      	    
	   mResultExtras = this.getResultExtras(true);	   
	   controls.pOnBroadcastReceiver(pascalObj,  intent);
   }
   
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
                
   public void RegisterIntentActionFilter(String _intentAction) { //android.provider.Telephony.SMS_RECEIVED
	   //intentFilter.addDataScheme("http");                      //com.example.appalarmmanagerdemo1.ALARM_RECEIVER
	   //intentFilter.addDataScheme("ftp"); 
	   //intentFilter.addAction(BluetoothDevice.ACTION_FOUND);	    	         	   
	   controls.activity.registerReceiver(this, new IntentFilter(_intentAction));
	   //Log.i("receiver","Register ....");
   }
         	   	  	         
   /*
    * This method disables the Broadcast receiver
    */
   public void Unregister() {   
	   controls.activity.unregisterReceiver(this);
	   //Log.i("receiver","UnRegister ...");
   }
   
   public void RegisterIntentActionFilter(int _intentAction) {
	   
	   switch(_intentAction) {
	     case 0: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_TIME_TICK));
	     case 1: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_TIME_CHANGED));
	     case 2: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_TIMEZONE_CHANGED));
	     case 3: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_BOOT_COMPLETED));
	     case 4: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
	     case 5: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_POWER_CONNECTED));
	     case 6: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_POWER_DISCONNECTED));
	     case 7: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_SHUTDOWN));
	     case 8: controls.activity.registerReceiver(this, new IntentFilter("android.provider.Telephony.SMS_RECEIVED"));
	     case 9: controls.activity.registerReceiver(this, new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));
	   }
   }
   
   public int GetResultCode() {     
      return mResultCode;
   }
   
   public String GetResultData() {
      return mResultData;
   }
   
   public Bundle GetResultExtras() { //true
      return mResultExtras;
   }   
}

/*Draft java code by "Lazarus Android Module Wizard" [1/18/2015 19:10:57]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jBundlerManager/*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
 
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jBundlerManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
   }
 
   public void jFree() {
     //free local objects...
   }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public Bundle CreateNew() {
	   return new Bundle();
   }
   
   public Bundle GetExtras(Intent _intent) {
      return  _intent.getExtras();
   }
   
}

