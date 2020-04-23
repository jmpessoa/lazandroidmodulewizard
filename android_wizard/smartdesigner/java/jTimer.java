package com.example.appchronometerdemo1;

import android.os.Handler;

//-------------------------------------------------------------------------
//Timer
//    Event : pOnTimer
//http://daddycat.blogspot.kr/2011/05/android-thread-ui.html
//http://lsit81.tistory.com/entry/ActivityrunOnUiThread%EC%99%80-post%EC%9D%98-%EC%B0%A8%EC%9D%B4%EC%A0%90
//
// 2020/04/16
// TR3E Software https://sites.google.com/view/tr3esoftware/start
// Fix the error of could start 2 timers, if the deactivated one was still on time, 
// when activating the same one again.
//-------------------------------------------------------------------------

public class jTimer {
 
	//Java-Pascal Interface
 private long            PasObj   = 0;      // Pascal Obj
 private Controls        controls = null;   // Control Class for Event
 
 //Property
 private boolean         mEnabled  = false;  // default : false
 private int             mInterval = 1000;   // 1000msec
 
 //Java Object 
 private Handler      mHandler  = null;
 private RunnableStop mRunnable = null;

 public class RunnableStop implements Runnable {

    boolean isEnabled;

    public RunnableStop() {
    	isEnabled = true;
    }

    @Override
    public void run() {
    	
    	if( !isEnabled ) return;
        
    	controls.pOnTimer(PasObj); // Pascal Event
    	
        if ((mHandler != null) && isEnabled)
        	mHandler.postDelayed(mRunnable, mInterval);
           
    }

    public void disable() {
        isEnabled = false;
    }
 }

 //Constructor 
 public  jTimer(Controls ctrls, long pasobj) {
  //Connect Pascal I/F
  PasObj   = pasobj;
  controls = ctrls;
  //Init Class
  mHandler  = new Handler();
 }
 
 public  void SetInterval(int interval) {
  mInterval = interval;
 }

 public  void SetEnabled(boolean _enabled) {
  if (mEnabled == _enabled) return;
  
  mEnabled = _enabled;
  
  if (mEnabled) {
	  if( mRunnable == null ){
		mRunnable = new RunnableStop();  	  
	    mHandler.postDelayed(mRunnable, mInterval);
	  }
  } else{
	  	  
	  if( mRunnable != null ){
		  mRunnable.disable();		  		 
		  mRunnable = null;
		  mHandler.removeCallbacksAndMessages(null);
	  }
  }
	 
 }

 //Free object except Self, Pascal Code Free the class.
 public  void Free() {
	 
  if( mRunnable != null ){
	mRunnable.disable();
	mHandler.removeCallbacksAndMessages(null);		
	mRunnable = null;
  }
	 
  mEnabled = false;
  mHandler = null;
 }

}


