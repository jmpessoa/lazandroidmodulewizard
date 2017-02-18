package com.example.appwindowmanagerdemo1;

import android.content.Context;
import android.graphics.PixelFormat;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;

/*Draft java code by "Lazarus Android Module Wizard" [2/7/2017 22:51:19]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

public class jWindowManager /*extends ...*/ {
 
   private long pascalObj = 0;        //Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private Context  context   = null;
 
   WindowManager.LayoutParams mParams = new WindowManager.LayoutParams(
           WindowManager.LayoutParams.WRAP_CONTENT,
           WindowManager.LayoutParams.WRAP_CONTENT,
           WindowManager.LayoutParams.TYPE_PHONE,
           WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,PixelFormat.TRANSLUCENT);

   
   private WindowManager mWindowManager;
   
   // owner of this instance
  	private View aOwnerView = null;
  	
	private ViewGroup parent = null;                     // parent view  	
  	private boolean mRemovedFromParent = false;  	
  	
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jWindowManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      
      //Specify the view position
      //Initially view will be added to top-left corner
      
      //[ifdef_api14up]
      mParams.gravity = Gravity.TOP | Gravity.START;
      //[endif_api14up]
      
      /* //[endif_api14up]
      params.gravity = Gravity.TOP | Gravity.LEFT;
      //[ifdef_api14up] */      
      
      mParams.x = 0;
      mParams.y = 100;
      
      mWindowManager = (WindowManager) controls.activity.getSystemService(Context.WINDOW_SERVICE);      
      
   }
 
   public void jFree() {
     //free local objects...
   }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ... 		
	private void removeFromViewParent() {
		if (!mRemovedFromParent) {
			if (aOwnerView != null)  {
				aOwnerView.setVisibility(android.view.View.INVISIBLE);
				if (parent != null) parent.removeView(aOwnerView);
			}
			mRemovedFromParent = true;
		}
	}
	
   //Add the view to the window
   public void AddView(View  _floatingView) {	   
	   if (aOwnerView != null) mWindowManager.removeView(aOwnerView);	   
		aOwnerView = _floatingView;       // set owner		
		removeFromViewParent();		        
        mWindowManager.addView(_floatingView, mParams);
   }
   
   public void RemoveView() {
       if (aOwnerView != null) mWindowManager.removeView(aOwnerView);
   }
   
}
