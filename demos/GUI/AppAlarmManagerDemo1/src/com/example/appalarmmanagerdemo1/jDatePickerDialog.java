package com.example.appalarmmanagerdemo1;

import java.util.Calendar;

import android.app.DatePickerDialog;
import android.content.Context;
import android.widget.DatePicker;

/*Draft java code by "Lazarus Android Module Wizard" [2/3/2015 22:24:25]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jDatePickerDialog /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   // Variable for storing current date and time
   private int mYear, mMonth, mDay;
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jDatePickerDialog(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
	   
       // Process to get Current Date
       final Calendar c = Calendar.getInstance();
       mYear = c.get(Calendar.YEAR);
       mMonth = c.get(Calendar.MONTH);
       mDay = c.get(Calendar.DAY_OF_MONTH);

       // Launch Date Picker Dialog
       DatePickerDialog dpd = new DatePickerDialog(controls.activity, new DatePickerDialog.OnDateSetListener() {
                   @Override
                   /*.*/public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                       // Display Selected date in textbox
                       //Log.i("DatePicker",dayOfMonth + "-" + (monthOfYear + 1) + "-" + year);
                       controls.pOnDatePicker(pascalObj, year, monthOfYear+1, dayOfMonth);
                   }
               }, mYear, mMonth, mDay);
       dpd.show();
   }    
}

