package org.lamw.appmapsdemo1;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;

/*Draft java code by "Lazarus Android Module Wizard" [2/25/2017 17:07:40]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/


public class jMaps {
 
   private long pascalObj = 0;        //Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private Context  context   = null;
   
   Intent mapIntent;
 
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jMaps(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      
   // Create an Intent from gmmIntentUri. Set the action to ACTION_VIEW
      mapIntent = new Intent(Intent.ACTION_VIEW);
      // Make the Intent explicit by setting the Google Maps package
      mapIntent.setPackage("com.google.android.apps.maps");
   }
 
   public void jFree() {
     //free local objects...
	   mapIntent = null;
   }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
      
   //https://developers.google.com/maps/documentation/android-api/intents#launch_turn-by-turn_navigation
   
   public void Show(String _uriString) {
	   Uri data = Uri.parse(Uri.encode(_uriString));	  	   	   
	   mapIntent.setData(data);
	   if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
	    	controls.activity.startActivity(mapIntent);
	   }	   
   }
   
   public void Show(String _latitude, String _longitude) {	   
     Uri data = Uri.parse("geo:"+_latitude+","+_longitude+"?q="+_latitude+","+_longitude);
     mapIntent.setData(data);
	 if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
	    	controls.activity.startActivity(mapIntent);
	 }
   }
    
   public void Show(String _latitude, String _longitude, int _zoom) {	//zoom: from 0 (the whole world) to 21    
	     Uri data = Uri.parse("geo:"+_latitude+","+_longitude+"?z="+_zoom+"&q="+_latitude+","+_longitude);
	     mapIntent.setData(data);
		 if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
		 }
   }
      
   public void Search(String _latitude, String _longitude,  String _address, String _label) {
	     Uri data = Uri.parse("geo:"+_latitude+","+_longitude+"?q="+Uri.encode(_address)+"("+Uri.encode(_label)+")" );
	     mapIntent.setData(data);
		 if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
		 }
   }
      
   public void Search(String _latitude, String _longitude, String _label) {
	     Uri data = Uri.parse("geo:0,0?q="+_latitude+","+_longitude+"("+Uri.encode(_label)+")" );
	     mapIntent.setData(data);
		 if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
		 }
   }
      
   public void Search(String _address, String _label) {
	     Uri data = Uri.parse("geo:0,0?q="+Uri.encode(_address)+"("+Uri.encode(_label)+")" );
	     mapIntent.setData(data);
		 if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
		 }
   }
      
   public void SearchCategory(String _category) {     
	     Uri data = Uri.parse("geo:0,0?q="+Uri.encode(_category));
	     mapIntent.setData(data);
		 if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
		 }
   }

   public void SearchCategory(String _latitude, String _longitude, String  _category) {
	     Uri data = Uri.parse("geo:"+_latitude+","+_longitude+"?q="+Uri.encode(_category));
	     mapIntent.setData(data);
		 if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
		 }
   }
      
   public void SearchCategory(String _latitude, String _longitude, int _zoom, String  _category) {
	     Uri data = Uri.parse("geo:"+_latitude+","+_longitude+"?z="+_zoom+"&q="+Uri.encode(_category));
	     mapIntent.setData(data);
		 if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
		 }
   }

   public void Navigation(String _address, int _mode) {
	   String m = "";	   
	   switch(_mode){
	   case 0: m="d";  //driving
	   case 1: m="w";  //walking
	   case 2: m="b";  //bicycling   
	   }	   		
	   
	   Uri data = Uri.parse("google.navigation:q="+Uri.encode(_address) + "&mode="+m);
	   mapIntent.setData(data);
	   if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
	   }
	   
   }
   
   public void NavigationTryAvoid(String _address, int _avoid) {
	   String m = "";	   
	   switch(_avoid){
	   case 0: m="t";  //tolls
	   case 1: m="h";  //highways
	   case 2: m="f";  //ferries   
	   }	   		
	   
	   Uri data = Uri.parse("google.navigation:q="+Uri.encode(_address) + "&avoid="+m);
	   mapIntent.setData(data);
	   if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
	   }	   
   }
   
   //google.navigation:q=-15.8739405,-52.3134635
   public void Navigation(String _latitude, String _longitude) {
	   Uri data = Uri.parse("google.navigation:q="+_latitude+","+_longitude);
	   mapIntent.setData(data);
	   if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
	   }	   
   }
    
   public void StreetView(String _latitude, String _longitude) {
	   Uri data = Uri.parse("google.streetview:cbll="+_latitude+","+_longitude);
	   mapIntent.setData(data);
	   if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
	   }	   
   }
      
   public void StreetView(String _latitude, String _longitude, int  _cameraBearingTowards, int _zoom, int _cameraTiltAngle) {
	   
	   String bearing = String.valueOf(_cameraBearingTowards);
	   String tilt = String.valueOf(_zoom);
	   String z = String.valueOf(_cameraTiltAngle);		  
       Uri data = Uri.parse("google.streetview:cbll="+_latitude+","+_longitude+"&cbp=0,"+bearing+",0,"+z+","+tilt);
	   mapIntent.setData(data);
	   if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
	   }	   
   }

   public void Show(String _latitude, String _longitude, int _zoom, String _label) {	//zoom: from 0 (the whole world) to 21    
	     Uri data = Uri.parse("geo:"+_latitude+","+_longitude+"?z="+_zoom+"&q="+_latitude+","+_longitude+"("+Uri.encode(_label)+")");
	     mapIntent.setData(data);
		 if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
		 }
   }
   
   public void Show(String _latitude, String _longitude,  String _label) {	//zoom: from 0 (the whole world) to 21    
	     Uri data = Uri.parse("geo:"+_latitude+","+_longitude+"?q="+_latitude+","+_longitude+"("+Uri.encode(_label)+")");
	     mapIntent.setData(data);
		 if (mapIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
		    	controls.activity.startActivity(mapIntent);
		 }
   }
   
   public boolean IsAppMapsInstalled() {
	    PackageManager pm = controls.activity.getPackageManager();
	    boolean installed = false;
	    try {
	        pm.getPackageInfo("com.google.android.apps.maps", PackageManager.GET_ACTIVITIES);
	        installed = true;
	    } catch (PackageManager.NameNotFoundException e) {
	        installed = false;
	    }
	    return installed;
	}
   
   public void TryDownloadAppMaps() {
	   Intent t = new Intent(Intent.ACTION_VIEW);
	   t.setData(Uri.parse("market://search?q=pname:com.google.android.apps.maps"));
	   controls.activity.startActivity(t);
   }
   
}
