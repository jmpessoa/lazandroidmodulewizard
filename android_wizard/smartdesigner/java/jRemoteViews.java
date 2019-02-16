package org.lamw.appwidgetproviderdemo1;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.RemoteViews;

/*Draft java code by "Lazarus Android Module Wizard" [4/18/2017 22:23:35]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

 public class jRemoteViews {
 
   private long pascalObj = 0;        //Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private Context  context   = null;
 
   RemoteViews mRemoteViews;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jRemoteViews(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
   	
	public void SetMainViewLayout(String _layoutIdentifier) {  //widget1
	   int _layoutId = GetLayoutRId(_layoutIdentifier);  
	   mRemoteViews = new RemoteViews(controls.activity.getPackageName(), _layoutId); //dummy R.layout.widget1
	}	
		
	public void SetTextViewText(String _viewIdentifier,  String _text) {		
		int _resIndenfier = GetViewRId(_viewIdentifier);   //	//R.id.label1		
		if (mRemoteViews != null) 
		  mRemoteViews.setTextViewText(_resIndenfier, _text);
	} 

	public void SetOnClickBroadcastdPendingIntent(String _viewIdentifier, Intent _intent) {
		int _resIndentifier = GetViewRId(_viewIdentifier);  //register for button event  //R.id.button1					
		mRemoteViews.setOnClickPendingIntent(_resIndentifier, 				                              
				                              PendingIntent.getBroadcast(context, 0, _intent, 
				                              PendingIntent.FLAG_UPDATE_CURRENT));			   
	}	
		
	public void SetOnClickActivityPendingIntent(String _viewIdentifier, Intent _intent) {
		int _resIndentifier = GetViewRId(_viewIdentifier);  //register for button event  //R.id.button1	
		mRemoteViews.setOnClickPendingIntent(_resIndentifier, 
				                             PendingIntent.getActivity(context, 0, _intent, 0)); 	   
	}	
		
	//request for widget update
	public void PushWidgetUpdate() {
	   //ComponentName myWidget = new ComponentName(controls.activity, jWidgetProvider.class);		
	   //AppWidgetManager manager = AppWidgetManager.getInstance(controls.activity);		
	   //manager.updateAppWidget(myWidget, mRemoteViews);		
		jWidgetProvider.pushWidgetUpdate(controls.activity, mRemoteViews);
	}	
	
	private int GetLayoutRId(String _layoutIdentifier) {
		int id = controls.activity.getResources().getIdentifier(_layoutIdentifier, "layout", controls.activity.getPackageName());
		return id; 
	}   
		  
	
	private int GetViewRId(String _viewIdentifier) {
		int id = controls.activity.getResources().getIdentifier(_viewIdentifier, "id", controls.activity.getPackageName());
		return id; 
	}   

	
	private int GetLayoutRId(String _packageName, String _layoutIdentifier) {
		int id = controls.activity.getResources().getIdentifier(_layoutIdentifier, "layout", _packageName);
		return id; 
	}   
		  
	
	private int GetViewRId(String _packageName, String _viewIdentifier) {
		int id = controls.activity.getResources().getIdentifier(_viewIdentifier, "id", _packageName);
		return id; 
	}   
	
	public int GetMainViewLayoutRId() {
		   int r = -1;			  
		   if (mRemoteViews != null) {	
		      r =  mRemoteViews.getLayoutId();
		   }   	   
		   return r;
	}
	
	
	public void AddViewLayout(String _containerLayoutIdentifier,  String _newLayoutIdentifier) {
		
	   int newlayoutId = GetLayoutRId(_newLayoutIdentifier);	//widget1
 	   RemoteViews newRemoteViews = new RemoteViews(controls.activity.getPackageName(), newlayoutId);  //R.layout.widget1
 	    
 	   int layoutContainertId = GetLayoutRId(_containerLayoutIdentifier);  //R.id.linearlayout1 
 	   if (mRemoteViews != null)
		   mRemoteViews.addView(layoutContainertId, newRemoteViews); 

	}
	
	
	public void AddViewLayout(String _packageName, String _containerLayoutIdentifier,  String _newLayoutIdentifier) {
		
		   int newlayoutId = GetLayoutRId(_packageName, _newLayoutIdentifier);	//widget1
	 	   RemoteViews newRemoteViews = new RemoteViews(_packageName, newlayoutId);  //R.layout.widget1
	 	    
	 	   int layoutContainertId = GetLayoutRId(_containerLayoutIdentifier);  //R.id.linearlayout1 
	 	   if (mRemoteViews != null)
			   mRemoteViews.addView(layoutContainertId, newRemoteViews); 

	}
	
	public void SetMainViewLayout(String _packageName, String _layoutIdentifier) {  //widget1
		   int _layoutId = GetLayoutRId(_packageName, _layoutIdentifier);  
		   mRemoteViews = new RemoteViews(_packageName, _layoutId); //dummy R.layout.widget1
	}	
	
	
	public void Reapply() {
	  /* Re-create a 'local' view group from the info contained in the remote view */
	  LayoutInflater inflater = (LayoutInflater) controls.activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	  ViewGroup localView = (ViewGroup) inflater.inflate(mRemoteViews.getLayoutId(), null);
	  mRemoteViews.reapply(controls.activity, localView);
	}
	

	public ViewGroup GetMainViewLayout() {	  
	  LayoutInflater inflater = (LayoutInflater) controls.activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
	  ViewGroup localView = (ViewGroup) inflater.inflate(mRemoteViews.getLayoutId(), null);	  
	  return localView;
	}
		
	public void Reapply(ViewGroup _view) {
      	mRemoteViews.reapply(controls.activity, _view);
	}
	
        //https://prativas.wordpress.com/category/appwidgets-in-android/part-1-creating-a-simple-app-widget-with-configuration-actvitiy-appwidgets-in-android/	
        //http://stackoverflow.com/questions/13694186/how-to-create-an-app-widget-with-a-configuration-activity-and-update-it-for-the
        /*
          Intent intent = new Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE, null, this, ChecksWidgetProvider.class);
          intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, new int[] {mAppWidgetId});
          sendBroadcast(intent);
        */
}
 
 
