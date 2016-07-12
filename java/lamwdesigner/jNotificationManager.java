package com.example.appchronometerdemo1;

import java.lang.reflect.Field;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;
import android.util.Log;

/*Draft java code by "Lazarus Android Module Wizard" [2/3/2015 16:12:53]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/
 
public class jNotificationManager /*extends ...*/ {
  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;

    NotificationManager mNotificationManager;
    String one,two,three;    
    Notification.Builder mNotificationBuilder;
    
    int mLightOn=  1000;
	int mLightOff= 1000;
	int mColor;
	int mId;
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jNotificationManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }
  
    public void jFree() {
      //free local objects...
    	mNotificationManager = null;
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

  //by jmpessoa
    public int GetDrawableResourceId(String _resName) {
    	  try {
    	     Class<?> res = R.drawable.class;
    	     Field field = res.getField(_resName);  //"drawableName"
    	     int drawableId = field.getInt(null);
    	     return drawableId;
    	  }
    	  catch (Exception e) {
    	     Log.e("jNotificationManager", "Failure to get drawable id.", e);
    	     return 0;
    	  }
    }
            
    public void Notify(int _id, String _title, String _subject, String _body, String _iconIdentifier, int _color){
    	
    	int icon;
    	
    	if (_iconIdentifier.equals("")) 
    	   icon = android.R.drawable.ic_dialog_info;    	
    	else
    	   icon = GetDrawableResourceId(_iconIdentifier) ;
    	
       mNotificationManager=(NotificationManager)controls.activity.getSystemService(Context.NOTIFICATION_SERVICE);       
       mNotificationBuilder = new Notification.Builder(controls.activity);  //need API >= 11 !!         
       mNotificationBuilder.setContentTitle(_title);        
       mNotificationBuilder.setContentText(_subject);
       mNotificationBuilder.setContentInfo(_body);       
       mNotificationBuilder.setSmallIcon(icon);   
       mNotificationBuilder.setLights(_color, mLightOn, mLightOff); //thanks to freris       
       mColor = _color;
       mId =  _id;  
       //Solution by freris 
       if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
          mNotificationManager.notify(_id, mNotificationBuilder.build());
       }
       else {
          mNotificationManager.notify(_id, mNotificationBuilder.getNotification());    	  
       }  
       
    }
    //thanks to freris
    public void SetLightsColorAndTime(int _color, int _onMills, int _offMills) {
    	if (mNotificationBuilder != null) {
    	   mColor = _color;	      	   
      	      	   
    	   if ( _onMills  > 0 ) mLightOn=  _onMills;    	       	       	
    	   if ( _offMills > 0)  mLightOff= _offMills;
    	   
    	   mNotificationBuilder.setLights(_color, mLightOn, mLightOff);
    	   
           //Solution by freris     	   
           if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
              mNotificationManager.notify(mId, mNotificationBuilder.build());
           }
           else {
              mNotificationManager.notify(mId, mNotificationBuilder.getNotification());    	  
           }    	              
    	}
    }
    
    //thanks to freris
    public void SetLightsEnable(boolean _enable) {
    	if (mNotificationBuilder != null) {
    	    if (!_enable)     	
       	      mNotificationBuilder.setLights(mColor, 0, 0);    	   
    	    else
         	  mNotificationBuilder.setLights(mColor, mLightOn, mLightOff);
    	    
            //Solution by freris     	   
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
               mNotificationManager.notify(mId, mNotificationBuilder.build());
            }
            else {
               mNotificationManager.notify(mId, mNotificationBuilder.getNotification());    	  
            }    	    
    	}
    }    
    
    //This method cancel a previously shown notification.
    public void Cancel(int _id) {
      mNotificationManager.cancel(_id);    
    }
    
    public void CancelAll() {
      mNotificationManager.cancelAll();    
    }    
}

