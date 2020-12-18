package org.lamw.appcompatcollapsingtoolbardemo1;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.os.Build;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import com.google.android.material.appbar.AppBarLayout;
import com.google.android.material.appbar.CollapsingToolbarLayout;

/*Draft java code by "Lazarus Android Module Wizard" [1/3/2018 19:05:56]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
public class jsCollapsingToolbarLayout extends CollapsingToolbarLayout /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   //private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsCollapsingToolbarLayout(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);
      
     // if (Build.VERSION.SDK_INT >= 21) {
        //this.setFitsSystemWindows(true);
     // }
      
      /*
      onClickListener = new OnClickListener(){
      public void onClick(View view){     // *.* is a mask to future parse...;
              if (enabled) {
                 controls.pOnClickGeneric(pascalObj); //JNI event onClick!
              }
           };
      };
      setOnClickListener(onClickListener);
      */
      
   } //end constructor

   public void jFree() {
      //free local objects...
  	 //setOnClickListener(null);
	 LAMWCommon.free();
   }
   
   @Override
   protected void onSizeChanged(int w, int h, int oldw, int oldh) {
   	super.onSizeChanged(w, h, oldw, oldh);
   	
   	// Change the size and update the layout               
    controls.formNeedLayout = true;
    controls.appLayout.requestLayout();
   }
 
   public void SetViewParent(ViewGroup _viewgroup) {
	 LAMWCommon.setParent(_viewgroup);
   }

   public ViewGroup GetParent() {
      return LAMWCommon.getParent();
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

   public int GetLParamWidth() {
      return LAMWCommon.getLParamWidth();
   }

   public int GetLParamHeight() {
	 return  LAMWCommon.getLParamHeight();
   }

   public void SetLGravity(int _g) {
  	 LAMWCommon.setLGravity(_g);
   }

   public void SetLWeight(float _w) {
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

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void SetCollapseMode(int _mode) {  //called on JNIPrompt
        LAMWCommon.setCollapseMode(_mode);
    }

    public void SetScrollFlag(int _collapsingScrollFlag) {   //called in OnJNIPrompt
        LAMWCommon.setScrollFlag(_collapsingScrollFlag);
    }

    public void SetExpandedTitleColorTransparent() {
      this.setExpandedTitleColor(Color.TRANSPARENT);
   }   
   
   public void SetExpandedTitleColor(int _color) {
	      this.setExpandedTitleColor(_color);	      	      
   }      
   
   public void SetExpandedTitleGravity(int _gravity) {
       this.setExpandedTitleGravity(_gravity);       
   }
   
   public void SetCollapsedTitleTextColor(int _color) {
      this.setCollapsedTitleTextColor(_color);      
   }   
   
   public void SetCollapsedTitleGravity(int _gravity) {
	   this.setCollapsedTitleGravity(_gravity);   
   }
   
   public void SetContentScrimColor(int _color) {
	     this.setContentScrimColor(_color);
   }
  
   
   public void	SetFitsSystemWindows(boolean _value) {
		LAMWCommon.setFitsSystemWindows(_value);
   }
	   
}
