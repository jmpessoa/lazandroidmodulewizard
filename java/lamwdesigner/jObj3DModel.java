package com.example.appopenglsurfaceviewdemo1;

import android.content.Context;

/*Draft java code by "Lazarus Android Module Wizard" [12/31/2016 16:47:25]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/
 
public class jObj3DModel /*extends ...*/ {
  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
  
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jObj3DModel(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }
  
    public void jFree() {
      //free local objects...
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
}
