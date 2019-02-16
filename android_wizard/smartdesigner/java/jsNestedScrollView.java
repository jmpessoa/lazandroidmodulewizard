package org.lamw.appcompattablayoutdemo2;


import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.support.design.widget.AppBarLayout;
import android.support.design.widget.CoordinatorLayout;
import android.support.v4.view.ViewCompat;
import android.support.v4.widget.NestedScrollView;

/*Draft java code by "Lazarus Android Module Wizard" [1/17/2018 1:38:38]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
public class jsNestedScrollView extends NestedScrollView /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   private Boolean enabled  = true;           // click-touch enabled!

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsNestedScrollView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);

      this.setFillViewport(true);
      this.setNestedScrollingEnabled(true);    
      
  } //end constructor

   public void jFree() {
      //free local objects...
	 LAMWCommon.free();
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

   public void SetLGravity(int _gravity) {
  	 LAMWCommon.setLGravity(_gravity);
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
   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }

   public void SetAppBarLayoutScrollingViewBehavior() { //This attribute will trigger event in the Toolbar.
     CoordinatorLayout.LayoutParams params = (CoordinatorLayout.LayoutParams)this.getLayoutParams();
     params.setBehavior(new AppBarLayout.ScrollingViewBehavior(context, null));
     this.requestLayout();
   }

  public void SetFitsSystemWindows(boolean _value) {
	LAMWCommon.setFitsSystemWindows(_value);
  }
  
  
  public void SetNestedScrollingEnabled(View _view) {
	  ViewCompat.setNestedScrollingEnabled(_view, true);  //true   
  }


}
