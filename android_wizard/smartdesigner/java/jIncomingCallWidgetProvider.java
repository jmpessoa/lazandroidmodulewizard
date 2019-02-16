package org.lamw.appincomingcallwidgetproviderdemo1;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RemoteViews;
import android.widget.TextView;

/*Draft java code by "Lazarus Android Module Wizard" [4/22/2017 20:54:19]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//http://stacktips.com/tutorials/android/app-widgets-example-in-android

public class jIncomingCallWidgetProvider extends AppWidgetProvider  {
 
   private long pascalObj = 0;        //Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private Context  context   = null;
        
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jIncomingCallWidgetProvider() { //Add more others news "_xxx" params if needed!
	   
   }
               //, String _actionfilter
   public jIncomingCallWidgetProvider(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
   
   //This is called when an instance of AppWidgetProvider is created.
    @Override
    public void onEnabled(Context context) {
    	//Log.i(" onEnabled", " :: ");
    }

	private int GetStringRId(Context ctx, String _stringIdentifier) {
		int id = ctx.getResources().getIdentifier(_stringIdentifier, "string", ctx.getPackageName());
		return id; 
	}   
    
	private int GetLayoutRId(Context ctx, String _layoutIdentifier) {
		int id = ctx.getResources().getIdentifier(_layoutIdentifier, "layout", ctx.getPackageName());
		return id; 
	}   
		  
	
	private int GetViewRId(Context ctx, String _viewIdentifier) {
		int id = ctx.getResources().getIdentifier(_viewIdentifier, "id", ctx.getPackageName());
		return id; 
	}   
        
    //https://www.javacodegeeks.com/2013/05/modal-dialog-popup-from-android-widget-example.html  OTIMO!
    @Override
    public void onReceive(final Context ctx, Intent intent) {
    	
      if (intent.getAction().equals("android.intent.action.PHONE_STATE")) {       	  
    	    
    	   int appNameId = GetStringRId(ctx, "app_name");    	   
    	   String appStr = (String) ctx.getResources().getText(appNameId);    	   
    	   String incomingNumber = "?????";
    	   
    	   //http://codetheory.in/android-sms/
    	   //https://www.sitepoint.com/how-to-handle-sms-in-android/
    	   String state = intent.getStringExtra("state"); 
           
    	   if ( state.equals("RINGING") ) {
    		   incomingNumber = intent.getStringExtra("incoming_number");
    		   RemoteViews remoteViews = new RemoteViews(ctx.getPackageName(), R.layout.jincomingcallwidgetprovider_layout); //layoutId
    		   remoteViews.setTextViewText(R.id.incomingcallwidgettextview, /*state*/ "Incoming call" + ": " + incomingNumber);
    		   remoteViews.setOnClickPendingIntent(R.id.jincomingcallwidgetprovider_layout, builActivityPendingIntent(ctx, state, incomingNumber, "App"));
    		   pushWidgetUpdate(ctx, remoteViews);    		   
    	   }
    	   								
      }
      
      
      if (intent.getAction().equals(ctx.getPackageName()+".LAMW_IC_WIDGET_NOTIFY")) {       	  
  	    
   	     int appNameId = GetStringRId(ctx, "app_name");    	   
   	     String appStr = (String) ctx.getResources().getText(appNameId);    	   
   	     Bundle bundle = intent.getExtras();                              
         String body = "";
         String state = ":";
         if (bundle != null) {
        	 body = (String) bundle.getCharSequence("notify_message");
    		 RemoteViews remoteViews = new RemoteViews(ctx.getPackageName(), R.layout.jincomingcallwidgetprovider_layout); 
    		 remoteViews.setTextViewText(R.id.incomingcallwidgettextview, body);		                                          
    		 remoteViews.setOnClickPendingIntent(R.id.jincomingcallwidgetprovider_layout, builActivityPendingIntent(ctx, state, body, "App"));
    		 pushWidgetUpdate(ctx, remoteViews);        	 
         }          								
     }
            
    }
        
	@Override
	public void onUpdate(Context ctx, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
		//
	    super.onUpdate(context, appWidgetManager, appWidgetIds);	    
	}
	
	
	public static PendingIntent builActivityPendingIntent(Context ctx, String state, String incomingNumber, String appJavaClassName) {
		
		  String packageName = ctx.getPackageName();
		  Intent intent = new Intent();		  
		  intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		  intent.putExtra("state", state);
		  intent.putExtra("incoming_number", incomingNumber);
		  ComponentName cn = new ComponentName(packageName, packageName+"."+appJavaClassName); 
		  intent.setComponent(cn);
		  return PendingIntent.getActivity(ctx, 0, intent, PendingIntent.FLAG_CANCEL_CURRENT);
	}
	
	public static void pushWidgetUpdate(Context ctx, RemoteViews remoteViews) {
		ComponentName myWidget = new ComponentName(ctx, jIncomingCallWidgetProvider.class);
		AppWidgetManager manager = AppWidgetManager.getInstance(ctx);
		manager.updateAppWidget(myWidget, remoteViews);
	}
	
}
