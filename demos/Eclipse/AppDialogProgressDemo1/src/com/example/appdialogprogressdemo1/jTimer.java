package com.example.appdialogprogressdemo1;

import android.os.Handler;

//-------------------------------------------------------------------------
//Timer
//    Event : pOnTimer
//http://daddycat.blogspot.kr/2011/05/android-thread-ui.html
//http://lsit81.tistory.com/entry/ActivityrunOnUiThread%EC%99%80-post%EC%9D%98-%EC%B0%A8%EC%9D%B4%EC%A0%90
//-------------------------------------------------------------------------
public class jTimer {
//Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//Property
private boolean         Enabled = false;   // default : false
private int             Interval = 1000;   // 1000msec
//Java Object
private Runnable runnable;
private Handler  handler;

//Constructor 
public  jTimer(Controls ctrls, long pasobj) {
//Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//Init Class
handler  = new Handler();
runnable = new Runnable() {
@Override
public  final void run() {
   if (Enabled) {
        controls.pOnTimer(PasObj); // Pascal Event
        if (handler != null)
         handler.postDelayed(runnable,Interval);
   };
 }
};
}

public  void SetInterval(int interval) {
Interval = interval;
}

public  void SetEnabled(boolean enabled) {
if (Enabled == enabled) return;
Enabled = enabled;
if (Enabled) { handler.postDelayed(runnable,Interval); };
}

//Free object except Self, Pascal Code Free the class.
public  void Free() {
Enabled  = false;
handler  = null;
runnable = null;
}

};


