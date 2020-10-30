package org.lamw.appcompatnavigationdrawerdemo1;

import androidx.core.view.GravityCompat; 
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;

/*Draft java code by "Lazarus Android Module Wizard" [12/16/2017 0:26:36]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
public class jsDrawerLayout extends DrawerLayout /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   //private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   ActionBarDrawerToggle mDrawerToggle;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsDrawerLayout(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);
            
      if (Build.VERSION.SDK_INT >= 21) {
          this.setFitsSystemWindows(true);         
      }
           
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
   
 //http://abhiandroid.com/materialdesign/navigation-drawer
 
// This method is used to close all the currently open drawer views 
// by animating them out of view. We mainly use this method on click of any item of Navigation View
public void CloseDrawers() {
	this.closeDrawers();  
}

public void CloseDrawer() {			
	this.closeDrawer(Gravity.START, false);
}

 //This method is used to open the drawer view by animating it into view. We can open a Drawer by passing START gravity to this method
 public void OpenDrawer() {	 
    this.openDrawer(GravityCompat.START);
 }
   
 //http://www.technotalkative.com/part-4-playing-with-navigationview/
 //http://blog.xebia.com/android-design-support-navigationview/
 //http://androidahead.com/2017/01/12/navigation-drawer/
  //Here we create the ActionBarDrawerToogle listener ...  
  public void SetupDrawerToggle(Toolbar _toolbar) {         
	  mDrawerToggle = new ActionBarDrawerToggle(((AppCompatActivity) controls.activity), 
			  this, _toolbar, 
			  R.string.hello_world,   //R.string.drawer_open  
			  R.string.app_name) {   //R.string.drawer_close		  
                  /*.*/public void onDrawerClosed(View view) {            	   
                      super.onDrawerClosed(view);
                      //pascal handle event ....
                  }
                  /*.*/public void onDrawerOpened(View drawerView) {
                      super.onDrawerOpened(drawerView);
                  //pascal handle event ....
                  }
              };
              
     mDrawerToggle.setDrawerIndicatorEnabled(true);
     // Add drawer toggle to the drawer layout listener.
     this.addDrawerListener(mDrawerToggle);
     mDrawerToggle.syncState();
   }

   public void SetFitsSystemWindows(boolean _value) {
	LAMWCommon.setFitsSystemWindows(_value);
   }

  
}
