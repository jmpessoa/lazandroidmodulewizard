package com.example.appnotificationmanagerdemo1;

import java.lang.reflect.Field;
import java.util.Random;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.util.Log;

/*Draft java code by "Lazarus Android Module Wizard" [2/3/2015 16:12:53]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/
 
public class jNotificationManager /*extends ...*/ {
  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    
    String one,two,three;
    NotificationManager mNotificationManager;        
    Notification.Builder mNotificationBuilder;
    Notification mNotification;    //https://www.laurivan.com/android-notifications-with-custom-layout/

    int mPendingFlag = PendingIntent.FLAG_CANCEL_CURRENT;  //FLAG_UPDATE_CURRENT
        
    int mLightOn=  1000;
	int mLightOff= 1000;
	int mColor;
	int mId;
	int mIconIdentifier = android.R.drawable.ic_dialog_info;
	
	String mTitle = "LAMW";        
	String mSubject = "Hello";
	String mBody = "LAMW: Hello World!";
	boolean mAutoCancel = true;
	boolean mOngoing = false;
	
	private int mPriority = Notification.PRIORITY_HIGH; //Notification.PRIORITY_DEFAULT;   //Notification.PRIORITY_LOW; //Notification.PRIORITY_HIGH;
	private int mVisibility = 0;

    int NOTIFICATION_ID = 234;

    String cannal_id = "my_lamw_channel_01";
    CharSequence name = "my_lamw_channel";
    //String Description = "This is my lamw channel";
    int importance = NotificationManager.IMPORTANCE_HIGH;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jNotificationManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;

        Random random = new Random();
        int randomInteger = random.nextInt(11000);
        cannal_id =  "cannal_" + String.valueOf(randomInteger);

        String packageName = this.controls.activity.getPackageName();
        name = cannal_id + "_" + packageName;

        mNotificationManager = (NotificationManager)controls.activity.getSystemService(Context.NOTIFICATION_SERVICE);

        //https://stackoverflow.com/questions/45711925/failed-to-post-notification-on-channel-null-target-api-is-26
        //[ifdef_api26up]
        if(Build.VERSION.SDK_INT >= 26) {
            NotificationChannel mChannel = new NotificationChannel(cannal_id, name, importance);
            mChannel.enableLights(true);
            mNotificationManager.createNotificationChannel(mChannel);
            mNotificationBuilder = new Notification.Builder(controls.activity, cannal_id);
        }//[endif_api26up]

        if(Build.VERSION.SDK_INT < 26)
           mNotificationBuilder = new Notification.Builder(controls.activity);  //need API >= 11 !!

    }
  
    public void jFree() {
      //free local objects...
    	mNotificationManager = null;
    	mNotificationBuilder = null;
    	mNotification =  null;
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
    	    
    	     if (Build.VERSION.SDK_INT < Build.VERSION_CODES.JELLY_BEAN ) {
    	   	     mNotification =   mNotificationBuilder.getNotification(); 	    	   
    	        //mNotificationManager.notify(mId, mNotification);    	            
    	     }

    	     if ( (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) && (Build.VERSION.SDK_INT < 21) ) {
                 //[ifdef_api16up]
                 if(Build.VERSION.SDK_INT >= 16)
                     mNotification =  mNotificationBuilder.build();
                 //[endif_api16up]
    	     }  //https://www.laurivan.com/android-make-your-notification-sticky/
    	       
    	   //[ifdef_api21up]
    	     if (Build.VERSION.SDK_INT >= 21) {  //Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP
    	      	 mNotification =  mNotificationBuilder.build();
    	      	 if (mPriority == Notification.PRIORITY_HIGH) { //to make Heads-up work.    		 
    	      		//mNotificationBuilder.setDefaults(Notification.DEFAULT_ALL); // must requires VIBRATE permission    		 
    	      	    mNotificationBuilder.setVibrate(new long[0]); 
    	      	    //mNotificationBuilder.setVibrate(new long[] {1, 1, 1});
    	      	 }       	      	
    	     }	 
    	     //[endif_api21up]
    	     
    	     mNotificationManager.notify(mId, mNotification);    	    
            
    	}
    }    
    
    //This method cancel a previously shown notification.
    public void Cancel(int _id) {
      mNotificationManager.cancel(_id);    
    }
    
    public void CancelAll() {
      mNotificationManager.cancelAll();    
    }  

    //TODO Pascal
    public void SetDeleteIntent(String _packageName, String _activityClassName) {    	//the activity to be triggered
        Intent intent = new Intent();
        Class<?> cls = null;        
	    try {
			cls = Class.forName(_packageName+'.'+_activityClassName);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    if (cls != null)
	    	intent.setClass(controls.activity, cls);	 	    	   	    
        PendingIntent pendingIntent = PendingIntent.getActivity(context, mId, intent, PendingIntent.FLAG_CANCEL_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        mNotificationBuilder.setDeleteIntent(pendingIntent);    	
   } 
    
    //https://www.laurivan.com/android-display-a-notification/
    
    public void SetContentIntent(Intent _intent) {        	              
    	  _intent.putExtra("content", mTitle + ";" + mSubject+ ";" + mBody);
    	  PendingIntent pendingIntent = PendingIntent.getActivity(context, mId, _intent, mPendingFlag);    	     	 
    	  mNotificationBuilder.setContentIntent(pendingIntent);    	  
    }
        
    //http://www.coderzheaven.com/2016/02/20/adding-notifications-reading-notifications-getting-number-of-notifications-in-android-m/
    public void SetContentIntent(Intent _intent, int _broadcastRequestCode) {   //.FLAG_UPDATE_CURRENT
    	_intent.putExtra("content", mTitle + ";" + mSubject+ ";" + mBody);
    	PendingIntent pendingIntent = PendingIntent.getBroadcast(context, _broadcastRequestCode, _intent, mPendingFlag);    	
  	    mNotificationBuilder.setContentIntent(pendingIntent);  	    
    }
    
    //https://www.laurivan.com/android-notifications-with-custom-layout/
    //mNotificationBuilder.setOnlyAlertOnce
    //mNotificationBuilder.setSound (Uri sound)    
    //mNotificationBuilder.setStyle (Notification.Style style)   // API level 16
        
    public void SetContentIntent(String _packageName, String _activityClassName) {    	//the activity to be triggered
        Intent intent = new Intent();
        Class<?> cls = null;        
	    try {
			cls = Class.forName(_packageName+'.'+_activityClassName);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    if (cls != null)
	    	intent.setClass(controls.activity, cls);
	    
		intent.putExtra("content", mTitle + ";" + mSubject+ ";" + mBody);
		
        PendingIntent pendingIntent = PendingIntent.getActivity(context, mId, intent, mPendingFlag);  	  
        mNotificationBuilder.setContentIntent(pendingIntent);
        
    }
        
    public void SetContentIntent(String _packageName, String _activityClassName, String dataName, String dataValue) {    	//the activity to be triggered
        Intent intent = new Intent();
        Class<?> cls = null;        
	    try {
			cls = Class.forName(_packageName+'.'+_activityClassName);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    if (cls != null)
	    	intent.setClass(controls.activity, cls);	 	    	   	 
	    
	    intent.putExtra("content", mTitle + ";" + mSubject+ ";" + mBody);	    
	    intent.putExtra(dataName, dataValue);	    
	    
        PendingIntent pendingIntent = PendingIntent.getActivity(context, mId, intent, mPendingFlag);  	  
        mNotificationBuilder.setContentIntent(pendingIntent);    	
   }    
           
   public void SetIconIdentifier(String _iconIdentifier) { 
    //int icon =android.R.drawable.ic_dialog_info;    	
	   mIconIdentifier = controls.GetDrawableResourceId(_iconIdentifier) ;
   }
 	
   public void SetTitle(String _title) {
     mTitle = _title;
   }
   
   public void SetSubject(String _subject) {
	   mSubject = _subject;
   }
    
   public void SetBody(String  _body) {
	   mBody = _body;
   }
      
   public void SetId(int _id) {
	   	mId = _id;
   }
   
   public void SetAutoCancel(boolean _value) {
	   mAutoCancel = _value;
   }
   
   //n.flags |= Notification.FLAG_NO_CLEAR | Notification.FLAG_ONGOING_EVENT;    
   public void SetOngoing(boolean _value) {
       mOngoing = _value;
   }
   
   public void Notify() {
	      	
     mNotificationBuilder.setContentTitle(mTitle);        
     mNotificationBuilder.setContentText(mSubject);
     mNotificationBuilder.setContentInfo(mBody);       
     mNotificationBuilder.setSmallIcon(mIconIdentifier);   
     mNotificationBuilder.setLights(mColor, mLightOn, mLightOff); //thanks to freris
     mNotificationBuilder.setAutoCancel(mAutoCancel);
     mNotificationBuilder.setOngoing(mOngoing);

       //[ifdef_api26up]
       if(Build.VERSION.SDK_INT >= 26)
           mNotificationBuilder.setChannelId(cannal_id);
       //[endif_api26up]

           //[ifdef_api16up]
       if(Build.VERSION.SDK_INT >= 16)
          mNotificationBuilder.setPriority(mPriority);//https://stackoverflow.com/questions/26451893/heads-up-notification-android-lollipop
       //[endif_api16up]

     if (Build.VERSION.SDK_INT < Build.VERSION_CODES.JELLY_BEAN ) {
 	   mNotification =   mNotificationBuilder.getNotification(); 	    	   
       //mNotificationManager.notify(mId, mNotification);    	            
     }

     if ( (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) && (Build.VERSION.SDK_INT < 21) ) {
         //[ifdef_api16up]
         if(Build.VERSION.SDK_INT >= 16)
            mNotification =  mNotificationBuilder.build();
         //[endif_api16up]
     }  //https://www.laurivan.com/android-make-your-notification-sticky/
     
   //[ifdef_api21up]
     if (Build.VERSION.SDK_INT >= 21) {  //Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP
    	 mNotification =  mNotificationBuilder.build();
    	 if (mPriority == Notification.PRIORITY_HIGH) { //to make Heads-up work.    		 
    		//mNotificationBuilder.setDefaults(Notification.DEFAULT_ALL); // must requires VIBRATE permission    		 
    	    mNotificationBuilder.setVibrate(new long[0]); 
    	    //mNotificationBuilder.setVibrate(new long[] {1, 1, 1});
    	 }       	
     }	 
   //[endif_api21up]
     
     mNotificationManager.notify(mId, mNotification);
   }
   
   public void SetPendingFlag(int _flag) {
	   mPendingFlag = _flag;
   }
               
   public void SetPriority(int _priority) {
	   mPriority = _priority;
	   //Notification.PRIORITY_DEFAULT;   //Notification.PRIORITY_LOW; //Notification.PRIORITY_HIGH;
   }
   
   public void SetVisibility(int _visibility) {
	   mVisibility = _visibility;  //VISIBILITY_SECRET, VISIBILITY_PRIVATE, VISIBILITY_PUBLIC
   }
}

