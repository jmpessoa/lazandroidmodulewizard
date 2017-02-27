package com.example.appgooglemapsdemo1;

import java.lang.reflect.Field;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ToggleButton;

/*Draft java code by "Lazarus Android Module Wizard" [1/6/2015 22:13:32]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jToggleButton extends ToggleButton /*dummy*/ { //please, fix what GUI object will be extended!

   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events
   private jCommons LAMWCommon;

   private Context context = null;
   private OnClickListener onClickListener;   // click event

   private Boolean enabled  = false;           // click-touch enabled!
   boolean mState = false;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public jToggleButton(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;

      pascalObj = _Self;
      controls  = _ctrls;
	  LAMWCommon = new jCommons(this,context,pascalObj);

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
      //free local objects...      
      setOnClickListener(null);
  	  LAMWCommon.free();
   }

   public void SetViewParent(ViewGroup _viewgroup) {
	   LAMWCommon.setParent(_viewgroup);
   }

   public void RemoveFromViewParent() {
	   LAMWCommon.removeFromViewParent();
   }

   public View GetView() {
      return this;
   }

   public void SetLParamWidth(int _w) {
		LAMWCommon.setLParamWidth(_w);
   }

   public void SetLParamHeight(int _h) {
	   LAMWCommon.setLParamHeight(_h);
   }

   public void setLGravity(int _g) {
	   LAMWCommon.setLGravity(_g);
   }

   public void setLWeight(float _w) {
	   LAMWCommon.setLWeight(_w);
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
   }

   public void AddLParamsAnchorRule(int _rule) {
	   LAMWCommon.addLParamsAnchorRule(_rule);
   }

   public void AddLParamsParentRule(int _rule) {
	   LAMWCommon.addLParamsParentRule(_rule);
   }

   public void SetLayoutAll(int _idAnchor) {
	   LAMWCommon.setLayoutAll(_idAnchor);
   }

   public void ClearLayoutAll() {
	   LAMWCommon.clearLayoutAll();
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

