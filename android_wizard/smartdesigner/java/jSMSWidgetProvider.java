package org.lamw.appsmswidgetproviderdemo1;


import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.SmsMessage;
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

public class jSMSWidgetProvider extends AppWidgetProvider  {
 
   private long pascalObj = 0;        //Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private Context  context   = null;
        
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jSMSWidgetProvider() { //Add more others news "_xxx" params if needed!
	   
   }
               //, String _actionfilter
   public jSMSWidgetProvider(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
    	
      if (intent.getAction().equals("android.provider.Telephony.SMS_RECEIVED")) {       	  
    	    
    	   int appNameId = GetStringRId(ctx, "app_name");    	   
    	   String appStr = (String) ctx.getResources().getText(appNameId);    	   
    	   //http://codetheory.in/android-sms/
    	   //https://www.sitepoint.com/how-to-handle-sms-in-android/
    	   Bundle bundle = intent.getExtras();
           SmsMessage[] recievedMsgs = null;                      
           String smsBody = "";
           if (bundle != null) {
              Object[] pdus = (Object[]) bundle.get("pdus");
              int len = pdus.length;
              recievedMsgs = new SmsMessage[len];
              
              for (int i=0; i < len; i++ ) {               	              	  
            	  //Convert Object array
            	  recievedMsgs[i] = SmsMessage.createFromPdu((byte[]) pdus[i]);
                  // Sender's phone number
            	  smsBody += appStr+"\n"+"[" + recievedMsgs[i].getOriginatingAddress() + "]"+"\n";
                  // Fetch the text message
            	  smsBody += recievedMsgs[i].getMessageBody().toString();
            	  smsBody += "\n";                  
              }               
            }
           
			RemoteViews remoteViews = new RemoteViews(ctx.getPackageName(), R.layout.jsmswidgetprovider_layout); //layoutId
			remoteViews.setTextViewText(R.id.smswidgettextview, smsBody);
			remoteViews.setOnClickPendingIntent(R.id.jsmswidgetprovider_layout, builActivityPendingIntent(ctx, smsBody, "App"));
			pushWidgetUpdate(ctx, remoteViews);								
      }
      
      
      if (intent.getAction().equals(ctx.getPackageName()+".LAMW_SMS_WIDGET_NOTIFY")) {       	  
  	    
   	     int appNameId = GetStringRId(ctx, "app_name");    	   
   	     String appStr = (String) ctx.getResources().getText(appNameId);    	   
   	     Bundle bundle = intent.getExtras();                              
         String smsBody = "";
         
         if (bundle != null) {
        	 smsBody = (String) bundle.getCharSequence("notify_message");      
         }
          
		 RemoteViews remoteViews = new RemoteViews(ctx.getPackageName(), R.layout.jsmswidgetprovider_layout); 
		 remoteViews.setTextViewText(R.id.smswidgettextview, smsBody);
		 remoteViews.setOnClickPendingIntent(R.id.jsmswidgetprovider_layout, builActivityPendingIntent(ctx, smsBody, "App"));
		 pushWidgetUpdate(ctx, remoteViews);								
     }
      
      
    }
        
	@Override
	public void onUpdate(Context ctx, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
		//
	    super.onUpdate(context, appWidgetManager, appWidgetIds);	    
	}
	
	
	public static PendingIntent builActivityPendingIntent(Context ctx, String smsMsg, String appJavaClassName) {
		
		  String packageName = ctx.getPackageName();
		  Intent intent = new Intent();		  
		  intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		  intent.putExtra("sms_body", smsMsg);
		  ComponentName cn = new ComponentName(packageName, packageName+"."+appJavaClassName); 
		  intent.setComponent(cn);
		  return PendingIntent.getActivity(ctx, 0, intent, PendingIntent.FLAG_CANCEL_CURRENT);
	}
	
	public static void pushWidgetUpdate(Context ctx, RemoteViews remoteViews) {
		ComponentName myWidget = new ComponentName(ctx, jSMSWidgetProvider.class);
		AppWidgetManager manager = AppWidgetManager.getInstance(ctx);
		manager.updateAppWidget(myWidget, remoteViews);
	}
	
}
