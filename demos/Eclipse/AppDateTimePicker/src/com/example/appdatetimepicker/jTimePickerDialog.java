package com.example.appdatetimepicker;

import java.util.Calendar;

import android.app.TimePickerDialog;
import android.content.Context;
import android.widget.TimePicker;

/*Draft java code by "Lazarus Android Module Wizard" [2/3/2015 22:24:25]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jTimePickerDialog /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
 
   // Variable for storing current time
   private int mHour, mMinute;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jTimePickerDialog(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
 
   public void Show() {
	   
       // Process to get Current Time
       final Calendar c = Calendar.getInstance();
       mHour = c.get(Calendar.HOUR_OF_DAY);
       mMinute = c.get(Calendar.MINUTE);

       // Launch Time Picker Dialog
       TimePickerDialog tpd = new TimePickerDialog(controls.activity,new TimePickerDialog.OnTimeSetListener() {
                   @Override
                   /*.*/public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                       // Display Selected time in textbox
                       //Log.i("TimePicker", hourOfDay + ":" + minute);
                       controls.pOnTimePicker(pascalObj, hourOfDay, minute);
                   }
               }, mHour, mMinute, false);
       
       tpd.show();      
   }
   
  public void Show(int _hourOfDay24Based, int _minute) {
	   
       // Process to get Current Time
      // final Calendar c = Calendar.getInstance();
       mHour = _hourOfDay24Based; //24h FORMAT
       mMinute = _minute; 

       // Launch Time Picker Dialog
       TimePickerDialog tpd = new TimePickerDialog(controls.activity,new TimePickerDialog.OnTimeSetListener() {
                   @Override
                   /*.*/public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                       // Display Selected time in textbox
                       //Log.i("TimePicker", hourOfDay + ":" + minute);
                       controls.pOnTimePicker(pascalObj, hourOfDay, minute);
                   }
               }, mHour, mMinute, false);
       
       tpd.show();      
   }
   
   
}

