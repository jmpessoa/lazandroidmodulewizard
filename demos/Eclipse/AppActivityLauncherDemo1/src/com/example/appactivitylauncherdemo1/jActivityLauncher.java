package com.example.appactivitylauncherdemo1;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class jActivityLauncher  {
	  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    
    Intent mIntent;
       
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jActivityLauncher(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;             
    }
  
    public void jFree() {
      //free local objects...
    	mIntent = null;
    }
      
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
    private Class GetClass(String _fullJavaclassName) {    	
 	    Class cls = null;
 	    //String className = 'com.almondmendoza.library.openActivity';
 	    try {
 			cls = Class.forName(_fullJavaclassName);
 		} catch (ClassNotFoundException e) {
 			// TODO Auto-generated catch block
 			e.printStackTrace();
 		}
 	    return cls; 		    	        	    
    }
    
    //Intent child = new Intent(getPackageName(), "com.something.myapp.ChildActivity");        
    public void StartActivity(String _packageName, String _javaClassName) {  //String _javaClassName
    	Class cls = GetClass(_packageName+"."+_javaClassName);    	
    	if  (cls != null) {
    	  mIntent = new Intent();		
          mIntent.setClass(controls.activity, cls);
          controls.activity.startActivity(mIntent);
    	}
    }
    
    public void StartActivityForResult(String _packageName, String _javaClassName, int _requestCode) {
     	Class cls = GetClass(_packageName+"."+_javaClassName);    	
     	if  (cls != null) {
     	  mIntent = new Intent();		
           mIntent.setClass(controls.activity, cls);
           controls.activity.startActivityForResult(mIntent, _requestCode);
     	}    	 
    }   
    
    public void StartActivity(android.content.Intent _intent) {
    	if (_intent != null)
    	  controls.activity.startActivity(_intent);
    }
    
    public void StartActivityForResult(android.content.Intent _intent, int _requestCode) {
    	if (_intent != null)
    	  controls.activity.startActivityForResult(_intent, _requestCode);
    }
        
}
