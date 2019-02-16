package org.lamw.appwidgetproviderdemo1;


import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.RemoteViews;
import android.widget.TextView;

/*Draft java code by "Lazarus Android Module Wizard" [4/12/2017 21:37:51]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//http://stacktips.com/tutorials/android/app-widgets-example-in-android

public class jWidgetProvider extends AppWidgetProvider  {
 
   private long pascalObj = 0;        //Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private Context  context   = null;
        
   private String mActionFilter =  "android.provider.Telephony.SMS_RECEIVED";
   //public static String WIDGET_UPDATE_ACTION ="org.lamw.appwidgetproviderdemo1.UPDATE_WIDGET";
     
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jWidgetProvider() { //Add more others news "_xxx" params if needed!
	   
   }
               //, String _actionfilter
   public jWidgetProvider(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;		
     // mActionFilter = _actionfilter;
   }
 
   public void jFree() {
     //free local objects...
   }
 
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   
   //This is called when an instance of AppWidgetProvider is created.
    @Override
    public void onEnabled(Context context) {
   	   	
    }
      
    //https://www.javacodegeeks.com/2013/05/modal-dialog-popup-from-android-widget-example.html  OTIMO!
    @Override
    public void onReceive(final Context context, Intent intent) {
      // If the intent is the one that we've defined to launch the pop up dialog
      // then create and launch the PopUpActivity
      	
      //Log.i("jWidgetProvider", "onReceive");
      
      if (intent.getAction().equals(mActionFilter)) {   
    	  
     	 String  packageName = context.getPackageName();    	  
    	  
     	    //TextView t = new TextView(context);
     	         	    
     	    //t.setText("New SMS Message!");
			RemoteViews remoteViews = new RemoteViews(context.getPackageName(),R.layout.activity_app);
			
			//remoteViews.removeAllViews(R.id.textview1);
			
     	    RemoteViews remoteViews2 = new RemoteViews(context.getPackageName(),R.layout.widget1);     	         	         	        	   
     	    remoteViews2.setTextViewText(R.id.label1, "New SMS Message!");
		
			remoteViews.addView(R.id.linearlayout1, remoteViews2);
			
			//remoteViews.setTextViewText(R.id.textview1, "New SMS Message!");
			//remoteViews.setTextViewText(R.id.desc, getDesc());
			//register for button event
			remoteViews.setOnClickPendingIntent(R.id.textview1, builActivityPendingIntent(context, packageName, "App"));				
			// request for widget update
			pushWidgetUpdate(context, remoteViews);								
   	  
    	  
    	  /*

    	 Intent popUpIntent = new Intent();    	 
    	 ComponentName cn = new ComponentName(packageName, packageName+".App"); 
    	 popUpIntent.setComponent(cn);  	   
         popUpIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
         context.startActivity(popUpIntent);         
         */         
      }
      
      //callOnUpdate(context);
      
      
    }
    
    private void callOnUpdate(Context ctx) {
        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(ctx);
        ComponentName thisAppWidget = new ComponentName( ctx.getPackageName(), jWidgetProvider.class.getName());
        int[] appWidgetIds = appWidgetManager.getAppWidgetIds(thisAppWidget);
        onUpdate(ctx, appWidgetManager, appWidgetIds);
    }

    
   //https://github.com/javatechig/Advance-Android-Tutorials/tree/master/WidgetDemo
	@Override
	public void onUpdate(Context ctx, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
       			
		      
		        Log.i("jWidgetProvider", "onUpdate");
		        
		        /*
        		// initializing widget layout
				RemoteViews remoteViews = new RemoteViews(context.getPackageName(),R.layout.activity_app);
				// updating view with initial data
				//remoteViews.setTextViewText(R.id.title, getTitle());
				//remoteViews.setTextViewText(R.id.desc, getDesc());
				// register for button event
				remoteViews.setOnClickPendingIntent(R.id.textview1, buildBroadcastPendingIntent(context,mActionFilter));				
				// request for widget update
				pushWidgetUpdate(context, remoteViews);								
		        super.onUpdate(context, appWidgetManager, appWidgetIds);
		        */
		        
	            //super.onUpdate(context, appWidgetManager, appWidgetIds);
	            //buildUpdate(context, appWidgetManager, appWidgetIds);

	}
	
    private void buildUpdate(Context ctx, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        final int N = appWidgetIds.length;        
        for (int i = 0; i < N; i++) {
            int appWidgetId = appWidgetIds[i];

            //RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.widget);
             
            /*
            Intent intent = new Intent(TEST_ACTIVITY);            
            PendingIntent pendingIntent = PendingIntent.getActivity(context, INTENT_NO_REQUEST, intent, INTENT_NO_FLAGS);
            
            remoteViews.setOnClickPendingIntent(R.id.nmcButton, pendingIntent);
            remoteViews.setTextViewText(R.id.nmcButton, String.valueOf(count));

            //the code below works, but the button does not have nice styling
            //int color = (count >= 5) ? Color.GREEN : Color.RED;
            //remoteViews.setInt(R.id.nmcButton, "setBackgroundColor", color);

            // this code doesn't work, you get "problem loading widget"
            int color = (count >= 5) ? R.drawable.btn_green: R.drawable.btn_red;            
            remoteViews.setInt(R.id.nmcButton, "setBackground", color);
            */            
            //appWidgetManager.updateAppWidget(appWidgetId, remoteViews);
        }
    }
	
	public static PendingIntent builActivityPendingIntent(Context ctx, String packageName, String javaClassName) {
		  Intent intent = new Intent();
		  intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);		  
		  ComponentName cn = new ComponentName(packageName, packageName+"."+javaClassName); 
		  intent.setComponent(cn);
		  return PendingIntent.getActivity(ctx, 0, intent, 0);
	}

	
	public static PendingIntent buildBroadcastPendingIntent(Context ctx,  String _action) {
		// initiate widget update request
		Intent intent = new Intent();
		intent.setAction(_action);
		return PendingIntent.getBroadcast(ctx, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
	}

	public static void pushWidgetUpdate(Context ctx, RemoteViews remoteViews) {
		ComponentName myWidget = new ComponentName(ctx, jWidgetProvider.class);
		AppWidgetManager manager = AppWidgetManager.getInstance(ctx);
		manager.updateAppWidget(myWidget, remoteViews);
	}
	
	
	public ViewGroup GetViewLayout(Context ctx, RemoteViews _remoteViews) {	  
		  LayoutInflater inflater = (LayoutInflater) ctx.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		  ViewGroup localView = (ViewGroup) inflater.inflate(_remoteViews.getLayoutId(), null);	  
		  return localView;
	}
			
	public void Reapply(Context ctx, RemoteViews _remoteViews, ViewGroup _view) {
		_remoteViews.reapply(ctx, _view);
	}

			
}
