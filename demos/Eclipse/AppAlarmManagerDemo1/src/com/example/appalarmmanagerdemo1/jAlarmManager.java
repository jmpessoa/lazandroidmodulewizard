package com.example.appalarmmanagerdemo1;

import java.util.ArrayList;
import java.util.Calendar;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.SystemClock;

/*
* http://hmkcode.com/android-sending-receiving-custom-broadcasts/
* http://clearosapps.blogspot.com.br/p/android.html
*/

/*Draft java code by "Lazarus Android Module Wizard" [5/21/2016 16:05:10]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jAlarmManager  /*extends ...*/ {

  private long     pascalObj = 0;      // Pascal Object
  private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
  private Context  context   = null;
  
  private AlarmManager mAlarmManager;   
  
  private Calendar targetCal;
  private Calendar currentCal;
     
  int mYear;
  int mMonth;
  int mDay;
  int mHour;
  int mMinute;
  
  String mExtraValue = "ExtraName";
  String mExtraName  = "ExtraName";
  int mRepeatingInterval = 0; //minutes  ( 0 = no repeat!)
  
  ArrayList<PendingIntent> mPendingIntentArray = new ArrayList<PendingIntent>();
       
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  public jAlarmManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
     //super(_ctrls.activity);
     context   = _ctrls.activity;
     pascalObj = _Self;
     controls  = _ctrls;            
     targetCal = Calendar.getInstance();
  }

  public void jFree() {
    //free local objects...
	   Clear();
	   mAlarmManager = null;   	   
	   targetCal = null;
	   currentCal = null;	   
  }

//write others [public] methods code here......
//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
  private PendingIntent createPendingIntent(int id, String _intentAction, String _extraName, String _extraValue) {	 
	   Intent intent = new Intent(_intentAction);	   
	   //extras don't affect matching
	   intent.putExtra(_extraName, _extraValue);	//http://stackoverflow.com/questions/11681095/cancel-an-alarmmanager-pendingintent-in-another-pendingintent?rq=1   
	   return PendingIntent.getBroadcast(controls.activity, id , intent,  PendingIntent.FLAG_UPDATE_CURRENT); //	   
	   //about PendingIntent.FLAG_UPDATE_CURRENT:
	   //there will be always a object available to so new object will not be created and the previous one will be assigned to this object
  }
     
  public void Clear(){
      if(mPendingIntentArray.size() > 0){
         for(int i=0; i < mPendingIntentArray.size(); i++){
       	  PendingIntent p = mPendingIntentArray.get(i);
       	  p.cancel();
     	      mAlarmManager.cancel(p);
         }
         mPendingIntentArray.clear();
      }
  }
  
  //http://stackoverflow.com/questions/4556670/how-to-check-if-alarmmanager-already-has-an-alarm-set?rq=1
  public boolean Exists(int _id, String _intentAction) { //"com.my.package.MY_UNIQUE_ACTION"
	 if (_id < mPendingIntentArray.size() ) {   
       boolean alarmUp = (PendingIntent.getBroadcast(context, _id, new Intent(_intentAction), PendingIntent.FLAG_NO_CREATE) != null );
	    if (alarmUp){
	      //Log.i("AlarmExists", "Yes, alarm is already active...");
	      return true;
	    }
	    else {
	    	return false;
	    }
	 }
	 else {
	  return false;
	 }	 
  }
    
  //adb shell dumpsys alarm > dump1.txt      
  public int Stop(int _id) {
	   if (_id < mPendingIntentArray.size() ) {
	      PendingIntent p = mPendingIntentArray.get(_id);
         p.cancel();
     	  mAlarmManager.cancel(p);
     	  //Log.i("stop","stop");
     	  return _id;
	   } else return -1;
  }
  
  public int Stop() {
	      int count = mPendingIntentArray.size();
	      if (count > 0) { 
	        PendingIntent p = mPendingIntentArray.get(count-1);
           p.cancel();
     	    mAlarmManager.cancel(p);
     	    //Log.i("stop","stop");      	    
	      }
	     return (count-1);      	  
  }
  
  public int Start(String _intentAction) {
	   
	   //calendar Month value is 0-based. e.g., 0 for January.    
	   //http://javatutorialhq.com/java/util/calendar-class-tutorial/set-method-example/
	   
	   targetCal.set(mYear, mMonth-1, mDay, mHour, mMinute, 0);	      	      	 	     
	   currentCal = Calendar.getInstance();	      	      	   	   
	   mAlarmManager = (AlarmManager) controls.activity.getSystemService(Context.ALARM_SERVICE);
	   
	   int id = mPendingIntentArray.size();
	   
	   if ( targetCal.compareTo(currentCal)  <=  0 ) {
		   String extraValue =  "Sorry.. the alarm date/time already passed...";
		   mPendingIntentArray.add(createPendingIntent(id, _intentAction, mExtraName, extraValue));
		   if (mRepeatingInterval <= 0)//no repeat	        	 
		   	  mAlarmManager.set(AlarmManager.ELAPSED_REALTIME_WAKEUP, SystemClock.elapsedRealtime() + 1*(10)*1000,mPendingIntentArray.get(id));	              
		   else  // the alarm will execute n time after (1/6) minute --> (10)
		      mAlarmManager.setInexactRepeating(AlarmManager.ELAPSED_REALTIME_WAKEUP, SystemClock.elapsedRealtime() + 1*(10)*1000, 1*(10)*1000, mPendingIntentArray.get(id));	           		
	   }	  
	   else { //ok
		   mPendingIntentArray.add(createPendingIntent(id, _intentAction, mExtraName, mExtraValue));
		   if (mRepeatingInterval <= 0)  //no repeat ...  
	           mAlarmManager.set(AlarmManager.RTC_WAKEUP, targetCal.getTimeInMillis(),mPendingIntentArray.get(id));
	       else  //the alarm will execute n time after "mRepeatingInterval" minute 
	          mAlarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, targetCal.getTimeInMillis(), mRepeatingInterval*60*1000,mPendingIntentArray.get(id));         	      
		   
	   }		   	 	   	          
      return id;
  }
  
  public int Count() {
	  return mPendingIntentArray.size();
  }
  
  public void SetYearMonthDay(int _year, int _month, int _day) {
	   mYear = _year;
	   mMonth = _month;
	   mDay = _day;
  }
  
  public void SetHourMinute(int _hour, int _minute) {
	   mHour = _hour;
	   mMinute =  _minute;
  }
     
  public void SetRepeatInterval(int _RepeatIntervalMinute) {
	   mRepeatingInterval = _RepeatIntervalMinute; 
  }
       
  public void SetIntentExtraString(String _extraName,  String _extraValue){	   
	   mExtraValue = _extraValue;
	   mExtraName  = _extraName;
  }
  
}

