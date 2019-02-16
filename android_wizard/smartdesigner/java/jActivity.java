package com.example.appactivitydemo1;

import java.util.ArrayList;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class jActivity  {
	  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    
    Intent mIntent;
       
    ArrayList<String> mComponentList = new ArrayList<String>();
    ArrayList<String> mComponentPropertiesList = new ArrayList<String>();    
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jActivity(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
    
    //Intent child = new Intent(getPackageName(), "com.something.myapp.ChildActivity");
    //params: "packagename whos activity u want to  launch","jClassname"
    private void SetComponent(String _packageName, String _javaClassName) {
 	   ComponentName cn = new ComponentName(_packageName, _packageName+"."+_javaClassName); 
 	   mIntent.setComponent(cn);
    }  

    private boolean SetClass(String _fullJavaclassName) {
    	boolean  r = false;
 	    Class cls = null;
 	    //String className = 'com.almondmendoza.library.openActivity';
 	    try {
 			cls = Class.forName(_fullJavaclassName);
 		} catch (ClassNotFoundException e) {
 			// TODO Auto-generated catch block
 			e.printStackTrace();
 		}
 	    if (cls != null) {
 		    mIntent.setClass(controls.activity, cls);
 		    r =  true;
 	    }    
 	    return r;
    }
//    //Intent child = new Intent(getPackageName(), "com.something.myapp.ChildActivity");        
    public void StartActivity(String _packageName, String _javaClassName) {  //String _javaClassName
    	mIntent = new Intent();
        if (SetClass(_packageName+"."+_javaClassName)) // com.example.appactivitydemo1.jActivityDraft
          controls.activity.startActivity(mIntent);                              	  
    }
    
    
    

    public void StartActivityForResult(String _packageName, String _javaClassName, int _requestCode) {
    	 mIntent = new Intent();
    	 if (SetClass(_packageName+"."+_javaClassName) )  // com.example.appactivitydemo1.jActivityDraft    	 
            controls.activity.startActivityForResult(mIntent, _requestCode);
    }   
    
    public void StartActivity(android.content.Intent _intent) {
    	if (_intent != null)
    	  controls.activity.startActivity(_intent);
    }
    
    public void StartActivityForResult(android.content.Intent _intent, int _requestCode) {
    	if (_intent != null)
    	  controls.activity.startActivityForResult(_intent, _requestCode);
    }
    
    public void AddComponent(String _componentName, String _componentProperties) {
    	mComponentList.add(_componentName);
    	mComponentPropertiesList.add(_componentProperties);
    	Log.i(_componentName, _componentProperties);
    }
    
}
