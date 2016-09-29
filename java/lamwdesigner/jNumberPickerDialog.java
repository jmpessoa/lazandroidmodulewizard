package com.example.appnumberpickerdemo1;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.NumberPicker;
import android.widget.RelativeLayout;

/*Draft java code by "Lazarus Android Module Wizard" [9/16/2016 22:10:36]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jNumberPickerDialog /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
 
   final Dialog mDial;
   
   private String mTitle= "NumberPicker";
   private int mMinValue = 0;
   private int mMaxValue = 10;   
   
   private boolean mWrapSelectorWheel = true;
   
   private int mOldValue = 0;
   private int mNewValue = 0;
   private String[] mDisplayedValues;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jNumberPickerDialog(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      mDial = new Dialog(controls.activity);
   }
 
   public void jFree() {
     //free local objects...
	   if (mDial!= null) 
		   mDial.dismiss();
   }
 
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   
  public void Show() {
	   
	   android.widget.RelativeLayout mLayout = new android.widget.RelativeLayout(controls.activity);     		 
	   DisplayMetrics displaymetrics = new DisplayMetrics();
	   controls.activity.getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
	   int width = displaymetrics.widthPixels;	   
	   int halfParentW = width/2-42;
	   	   
	   NumberPicker np = new NumberPicker(controls.activity);	   
	   np.setId(1);
	   	   	   
       android.widget.RelativeLayout.LayoutParams lparams1 = new android.widget.RelativeLayout.LayoutParams(
       		RelativeLayout.LayoutParams.WRAP_CONTENT,RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H
       
       lparams1.addRule(RelativeLayout.CENTER_HORIZONTAL);
       lparams1.addRule(RelativeLayout.ALIGN_TOP);        
       np.setLayoutParams(lparams1);
       
       mLayout.addView(np);        
	   	   
	   Button cancel = new Button(controls.activity);
	   cancel.setText("Cancel");
	   cancel.setId(2);
	   cancel.setBackgroundColor(Color.TRANSPARENT);
	   	   
       android.widget.RelativeLayout.LayoutParams lparams2 = new android.widget.RelativeLayout.LayoutParams(halfParentW,
               RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H        
       lparams2.addRule(RelativeLayout.ALIGN_PARENT_LEFT); //parent       
       lparams2.addRule(RelativeLayout.BELOW, np.getId());   //anchor
       
       cancel.setLayoutParams(lparams2);        

       mLayout.addView(cancel);      
	   
	   Button OK = new Button(controls.activity);
	   OK.setText("OK");
	   OK.setBackgroundColor(Color.TRANSPARENT);
	   
       android.widget.RelativeLayout.LayoutParams lparams3 = new android.widget.RelativeLayout.LayoutParams(halfParentW,
               RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H
       
       //lparams3.addRule(RelativeLayout.ALIGN_PARENT_RIGHT); //parent       
       lparams3.addRule(RelativeLayout.ALIGN_BASELINE, cancel.getId());   //anchor
       lparams3.addRule(RelativeLayout.RIGHT_OF, cancel.getId());   //anchor       
       OK.setLayoutParams(lparams3);        
		
       mLayout.addView(OK);      
       
       mDial.setTitle(mTitle);             
       mDial.setContentView(mLayout); //np
        
       np.setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);
       np.setMinValue(mMinValue);       
       np.setMaxValue(mMaxValue);
       np.setValue(mNewValue);       
       np.setWrapSelectorWheel(mWrapSelectorWheel);
       
       if (mDisplayedValues != null) np.setDisplayedValues(mDisplayedValues);  
       
       np.setOnValueChangedListener(new NumberPicker.OnValueChangeListener() {
           @Override
           public void onValueChange(NumberPicker picker, int oldVal, int newVal){
        	   //controls.pOnNumberPickerValueChange(pascalObj, oldVal, newVal);
        	   mOldValue = oldVal; 
        	   mNewValue = newVal;
           }           
       });
             
       cancel.setOnClickListener( new OnClickListener() {
                   @Override
                   public void onClick(View v) {
                	  mDial.dismiss();                       
                   }
               });
       
       OK.setOnClickListener( new OnClickListener() {
           @Override
           public void onClick(View v) {
               // TODO Auto-generated method stub
        	  controls.pOnNumberPicker(pascalObj, mOldValue, mNewValue);
          	  mDial.dismiss();
           }
       });
       
       mDial.show();
       
   }
   
   public void Cancel() {
	   mDial.dismiss();
   }
   
   public void SetMinValue(int _minValue) {
	   mMinValue=_minValue;
   }
   
   public void SetMaxValue(int _maxValue) {
	   mMaxValue=_maxValue;
   }
   
   public void SetValue(int _value) {
	   mOldValue = _value;
	   mNewValue = _value;	   
   }
   
   public void SetTitle (String _title) {
	   mTitle = _title;
   }

   public void SetWrapSelectorWheel(boolean _value) {
	   mWrapSelectorWheel = _value ;
   }
   
   public void Show(String _title) {
	   mTitle = _title;
	   Show();
   }
      
   public void SetDisplayedValues(String[] _values){
	 int size = _values.length;
	 mDisplayedValues = new String[size];
  	 for (int i = 0; i < size; i++) {
  		mDisplayedValues[i]= _values[i];
  	 }
	 mMinValue= 0;
	 mMaxValue= size-1;	 
   }
   
   public void ClearDisplayedValues() {	 
	 int size = 0;  
	 if (mDisplayedValues != null) {   
	     size = mDisplayedValues.length;
		 mMinValue= 0;
		 mMaxValue= size-1;
		 mOldValue = 0;
		 mNewValue = 0;	   	    
		 mDisplayedValues = null;
	 }   	 
   }   
   
}
