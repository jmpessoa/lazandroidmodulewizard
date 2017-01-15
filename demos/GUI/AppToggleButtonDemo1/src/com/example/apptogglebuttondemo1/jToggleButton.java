package com.example.apptogglebuttondemo1;

import java.lang.reflect.Field;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.ToggleButton;

/*Draft java code by "Lazarus Android Module Wizard" [1/6/2015 22:13:32]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jToggleButton extends ToggleButton /*dummy*/ { //please, fix what GUI object will be extended!

   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events

   private Context context = null;
   private ViewGroup parent   = null;         // parent view
   private LayoutParams lparams;              // layout XYWH
   private OnClickListener onClickListener;   // click event
   
   private Boolean enabled  = false;           // click-touch enabled!
   
   private int lparamsAnchorRule[] = new int[30];
   private int countAnchorRule = 0;
   private int lparamsParentRule[] = new int[30];
   private int countParentRule = 0;
   private int lparamH = 100;
   private int lparamW = 100;
   private int marginLeft = 0;
   private int marginTop = 0;
   private int marginRight = 0;
   private int marginBottom = 0;
   private boolean mRemovedFromParent = false;
   
   boolean mState = false;   

  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public jToggleButton(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      lparams = new LayoutParams(lparamW, lparamH);

      onClickListener = new OnClickListener(){
    	   
      /*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!
    	      mState = !mState;
              if (enabled) {
            	  controls.pOnClickToggleButton(pascalObj, mState);            	
              }
           };
      };
      setOnClickListener(onClickListener);
      
   } //end constructor

   public void jFree() {
      if (parent != null) { parent.removeView(this); }
      //free local objects...
      lparams = null;
      setOnClickListener(null);
   }

   public void SetViewParent(ViewGroup _viewgroup) {
      if (parent != null) { parent.removeView(this); }
      parent = _viewgroup;
      parent.addView(this,lparams);
      mRemovedFromParent = false;
   }

   public void RemoveFromViewParent() {
      if (!mRemovedFromParent) {
         this.setVisibility(android.view.View.INVISIBLE);
         if (parent != null)
    	       parent.removeView(this);
	   mRemovedFromParent = true;
	}
      
   }

   public View GetView() {
      return this;
   }

   public void SetLParamWidth(int _w) {
      lparamW = _w;
   }

   public void SetLParamHeight(int _h) {
      lparamH = _h;
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
      marginLeft = _left;
      marginTop = _top;
      marginRight = _right;
      marginBottom = _bottom;
      lparamH = _h;
      lparamW = _w;
   }

   public void AddLParamsAnchorRule(int _rule) {
      lparamsAnchorRule[countAnchorRule] = _rule;
      countAnchorRule = countAnchorRule + 1;
   }

   public void AddLParamsParentRule(int _rule) {
      lparamsParentRule[countParentRule] = _rule;
      countParentRule = countParentRule + 1;
   }

   public void SetLayoutAll(int _idAnchor) {
  	lparams.width  = lparamW;
	lparams.height = lparamH;
	lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
	if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
		lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	}
      for (int j=0; j < countParentRule; j++) {
         lparams.addRule(lparamsParentRule[j]);
      }
      this.setLayoutParams(lparams);
   }

   public void ClearLayoutAll() {
	for (int i=0; i < countAnchorRule; i++) {
  	   lparams.removeRule(lparamsAnchorRule[i]);
    	}

	for (int j=0; j < countParentRule; j++) {
   	   lparams.removeRule(lparamsParentRule[j]);
	}
	countAnchorRule = 0;
	countParentRule = 0;
   }

   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }

  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public void SetChecked(boolean _value) {
	 mState = _value;  
     this.setChecked(_value);
   }

   public void SetTextOn(String _caption) {
     this.setTextOn(_caption);
   }

   public void SetTextOff(String _caption) {
     this.setTextOff(_caption);
   }

   public void Toggle() { //reset toggle button value.
	 mState = !mState;  
     this.toggle();
   }
   
   public boolean IsChecked(){
	  return this.IsChecked();
  }
  
  private int GetDrawableResourceId(String _resName) {   //    ../res/drawable
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     Log.e("toglebutton", "Failure to get drawable id.", e);
		     return 0;
		  }
  }

  private Drawable GetDrawableResourceById(int _resID) {
		return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
  } 

  public void SetBackgroundDrawable(String _imageIdentifier) {	  
     this.setBackgroundDrawable(GetDrawableResourceById(GetDrawableResourceId(_imageIdentifier)));
  } 
  
  public void DispatchOnToggleEvent(boolean _value) {
	   enabled = _value;
  }

} //end class

