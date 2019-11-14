package org.lamw.appcompatcollapsingtoolbardemo1;

import java.lang.reflect.Field;
import android.content.Context;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.view.Gravity;

/*Draft java code by "Lazarus Android Module Wizard" [1/8/2015 22:10:35]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jSwitchButton extends Switch /*API 14*/ { //please, fix what GUI object will be extended!

   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events
   private jCommons LAMWCommon;

   private Context context = null;
   private OnCheckedChangeListener onClickListener ;   // click event
   private Boolean enabled  = false;           // click-touch not enabled!

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public jSwitchButton(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      LAMWCommon = new jCommons(this,context,pascalObj);

      onClickListener = new OnCheckedChangeListener(){
         /*.*/public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {  //please, do not remove /*.*/ mask for parse invisibility!
            if (enabled) {
               controls.pOnChangeSwitchButton(pascalObj, isChecked); //JNI event onClick!
            }
         };
      };
      setOnCheckedChangeListener(onClickListener);
   } //end constructor

   public void jFree() {
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

   public void SetLGravity(int _g) {
	   LAMWCommon.setLGravity(_g);
   }

   public void setLWeight(float _w) {
	   LAMWCommon.setLWeight(_w);
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
       String tag = ""+_left+"|"+_top+"|"+_right+"|"+_bottom;
       this.setTag(tag);  //nedd by jsRecyclerView.java
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

   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public void SetTextOff(String _caption) {
      this.setTextOff(_caption);
   }

   public void SetTextOn(String _caption) {
      this.setTextOn(_caption);
   }

   public void SetChecked(boolean _state) {
      this.setChecked(_state);
   }

   public void Toggle() {
      this.toggle();
   }

   public boolean IsChecked(){
      return this.isChecked();
   }

   public void SetThumbIcon(String _thumbIconIdentifier) {	   //Api  16
      //[ifdef_api16up]
      if (Build.VERSION.SDK_INT >= 16) {
         this.setThumbResource(controls.GetDrawableResourceId(_thumbIconIdentifier));
      }
      //[endif_api14up]
   }

   public void DispatchOnToggleEvent(boolean _value) {
      enabled = _value;
   }
   
   /*
   public void SetShowText(boolean _state) {  //Api 21
     //[ifdef_api21up]
	  if (Build.VERSION.SDK_INT >= 21) {
	    this.setShowText(_state);
      }//[endif_api21up]
    }
   */

} //end class

