package com.example.appwindowmanagerdemo1;

import android.content.Context;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.graphics.PorterDuff.Mode;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PaintDrawable;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.RelativeLayout;

/*Draft java code by "Lazarus Android Module Wizard" [2/7/2017 22:51:19]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

// ref1 http://www.androidhive.info/2016/11/android-floating-widget-like-facebook-chat-head/
// ref2 https://android--examples.blogspot.com.br/2015/11/android-color-filter-and-different.html
// ref3 http://android-er.blogspot.com.br/2015/02/colorize-imageview-using-setcolorfilter.html 
         
public class jWindowManager /*extends ...*/ {
 
   private long pascalObj = 0;        //Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private Context  context   = null;
   
   RelativeLayout mLayout;   
   RelativeLayout.LayoutParams mLyoutParams;
   
   WindowManager.LayoutParams mParams = new WindowManager.LayoutParams(
           WindowManager.LayoutParams.WRAP_CONTENT,
           WindowManager.LayoutParams.WRAP_CONTENT,
           WindowManager.LayoutParams.TYPE_PHONE,   
           WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
           PixelFormat.TRANSLUCENT);

   private WindowManager mWindowManager;   
   private View mFloatingView = null;
   
   private ViewGroup parent = null;                     // parent view  	
   private boolean mRemovedFromParent = false;
   
   int initialX = 0;
   int initialY = 0;
   float initialTouchX = 0;
   float initialTouchY = 0;
   int mRadius = 20;
     	  
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jWindowManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      
      //Specify the view position
      //Initially view will be added to top-left corner
      mParams.x = 0;
      mParams.y = 100;      
      
      //[ifdef_api14up]
      mParams.gravity = Gravity.TOP | Gravity.START;
      //[endif_api14up]
      
      /* //[endif_api14up]
      params.gravity = Gravity.TOP | Gravity.LEFT;
      //[ifdef_api14up] */
      
      mWindowManager = (WindowManager) controls.activity.getSystemService(Context.WINDOW_SERVICE);
      
      mLyoutParams = new RelativeLayout.LayoutParams(android.widget.RelativeLayout.LayoutParams.WRAP_CONTENT, 
    		                                         android.widget.RelativeLayout.LayoutParams.WRAP_CONTENT);
            
   }
 
   public void jFree() {
     //free local objects...
	   RemoveView();
	   mLyoutParams = null;	   
   }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ... 		
	private void removeFromViewParent(View _floatingView) {
		if (!mRemovedFromParent) {
			if (_floatingView != null)  {
				parent = (ViewGroup) _floatingView.getParent();
				_floatingView.setVisibility(android.view.View.INVISIBLE);
				if (parent != null) parent.removeView(_floatingView);
			}
			mRemovedFromParent = true;
		}
	}
	
   //Add the view to the window
   public void AddView(View  _floatingView) {
	   
	   if (_floatingView == null) {
		   return;   
	   }
	   
	   if (mLayout != null)  {		   
		   RemoveView(); 		   		   
	   }
	   
	   mFloatingView = _floatingView;	   	   	   
	   removeFromViewParent(mFloatingView);
	   
	   mFloatingView.setVisibility(View.VISIBLE);

	   mLayout = new RelativeLayout(controls.activity){
		   
	          @Override
	          public boolean onInterceptTouchEvent(MotionEvent ev) {
	        	  onTouchEvent(ev);
	              return false;   // go to childrens !!!
	          }     
	          
	          @Override
	          public boolean onTouchEvent(MotionEvent event) {
	        	  	        	  
	                 switch (event.getAction()) {
	                 
                     case MotionEvent.ACTION_DOWN:                     
                         //remember the initial position.
                         initialX = mParams.x;
                         initialY = mParams.y;                     
                         //get the touch location
                         initialTouchX = event.getRawX();
                         initialTouchY = event.getRawY();                        
                         break;                         
                     case MotionEvent.ACTION_MOVE:
                         //Calculate the X and Y coordinates of the view.
                   	  mParams.x = initialX + (int) (event.getRawX() - initialTouchX);
                   	  mParams.y = initialY + (int) (event.getRawY() - initialTouchY);                    
                      //Update the layout with new X & Y coordinate
                      mWindowManager.updateViewLayout(mLayout, mParams);                                                                
                 }
	                 
	          return true;   
	          }	  
	   };

	   mLayout.addView(mFloatingView, mLyoutParams);	                        
       mWindowManager.addView(mLayout, mParams);                                                                                   	     	   
   }
   
   public void RemoveView() {	   
      if (mLayout!= null) {  
    	mLayout.removeAllViews();    	
    	mWindowManager.removeView(mLayout);
    	mLayout = null;    	   
      }
   }
   
   public void SetViewPosition(int _x, int _y) {
      mParams.x = _x;
      mParams.y = _y;
      if (mLayout != null) 
         mWindowManager.updateViewLayout(mLayout, mParams); 
   }
   
   public int GetViewPositionX() {
	   return mParams.x;
   }
    
   public int GetViewPositionY() {
	   return mParams.y;
   } 
   	
   public void SetViewFocusable(boolean _value) {
	   
	   if (!_value) 
          mParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE  | WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH; 
       else
          mParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH; 
	   
	   if (mLayout != null) 
	          mWindowManager.updateViewLayout(mLayout, mParams);	   
   }
   
   public void SetViewRoundCorner() {
	 if (mLayout != null) {  		
        PaintDrawable  shape =  new PaintDrawable();
        shape.setCornerRadius(mRadius);                
        int color = Color.TRANSPARENT;
        Drawable background = mFloatingView.getBackground();        
        if (background instanceof ColorDrawable) {
          color = ((ColorDrawable)mFloatingView.getBackground()).getColor();          
        }                
        shape.setColorFilter(color, Mode.SRC_ATOP);        
        mFloatingView.setBackground(shape);    
	 }
   }
 
   public void SetRadiusRoundCorner(int _radius) {
		mRadius =  _radius;
   }
   
}
