package com.example.apploadimagevideosoundfrominternet;

//LAMW: Lazarus Android Module Wizard  - version 0.7 - 04 July - 2016 
//RAD Android: Project Wizard, Form Designer and Components Development Model!

//https://github.com/jmpessoa/lazandroidmodulewizard
//http://forum.lazarus.freepascal.org/index.php/topic,21919.270.html

//Android Java Interface for LAZARUS [december/2013 by jmpessoa]

//Developers:
//          Simon,Choi / Choi,Won-sik
//                       simonsayz@naver.com
//                       http://blog.naver.com/simonsayz
//
//          LoadMan    / Jang,Yang-Ho
//                       wkddidgh@naver.com
//                       http://blog.naver.com/wkddidgh
//
//          Jose Marques Pessoa   / jmpessoa@hotmail.com
//
//Version
//History
//			2013.02.24 ver0.01 Started
//			2013.02.28 ver0.02 added Delphi Style
//			2013.03.01 ver0.03 added sysInfo
//			2013.03.05 ver0.04 added Java Loading Png
//			2013.03.08 ver0.05 Restructuring (Interlation #.02)
//			2013.07.13 ver0.06 added TForm
//			2013.07.22 ver0.07 added Back Event for Close
//			2013.07.26 ver0.08 Class,Method Cache (Single Thread,Class)
//			2013.07.30 ver0.09 added TEditText Keyboard,Focus
//			2013.08.02 ver0.10 added TextView - Enabled
//			2013.08.05 ver0.11 added Form Object
//			2013.08.11 ver0.12 added Canvas
//                              added Direct Bitmap access
//			2013.08.14 ver0.13 Fixed Memory Leak
//			2013.08.18 ver0.14 added OpenGL ES1 2D (Stencil)
//			2013.08.21 ver0.15 Fixed jImageBtn Memory Leak
//                              Fixed Socket Buffer
//			2013.08.23 ver0.16 Fixed Memory Leak for Form,Control
//                              added Form Stack
//			2013.08.24 ver0.17 added Thread
//			2013.08.26 ver0.18 added OpenGL ES2 2D/3D
//                              added Button Font Color/Height 
//			2013.08.31 ver0.19 added Unified OpenGL ES1,2 Canvas
//                              added OpenGL ES1,2 Simulator for Windows  
//			2013.09.01 ver0.20 added GLThread on Canvas
//                              Fixed OpenGL Crash
//                              rename example Name
//			12.2013 LAMW Started by jmpessoa

import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.app.Activity;
import android.app.Dialog;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.hardware.Sensor;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Environment;
import android.os.Vibrator;
import android.telephony.SmsManager;
import android.telephony.SmsMessage;
import android.telephony.TelephonyManager;
import android.provider.ContactsContract;
import android.provider.MediaStore;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.net.wifi.WifiManager;
import android.util.Log;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SurfaceHolder;
import android.view.View.OnClickListener;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.RelativeLayout;
import android.widget.Toast;
import java.io.*;
import java.lang.Class;
import java.nio.ByteBuffer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.lang.reflect.*;

//-------------------------------------------------------------------------
//Constants
//-------------------------------------------------------------------------
class Const {
  public static final int TouchDown                   =  0;
  public static final int TouchMove                   =  1;
  public static final int TouchUp                     =  2;
  public static final int Click_Default               =  0;
}

//-------------------------------------------------------------------------
//Form
//-------------------------------------------------------------------------
class jForm {
// Java-Pascal Interface
private long             PasObj   = 0;     // Pascal Obj
private Controls        controls = null;   // Control Class for Event
private RelativeLayout  layout   = null;
private LayoutParams    layparam = null;
private RelativeLayout  parent   = null;
private OnClickListener onClickListener;   // event
private OnClickListener onViewClickListener;   // generic delegate event
private OnItemClickListener onListItemClickListener; 
private Boolean         enabled  = true;   //
private Intent intent;
private int mCountTab = 0;

// Constructor
public  jForm(Controls ctrls, long pasobj) {
PasObj   = pasobj;
controls = ctrls;
layout   = new RelativeLayout(controls.activity);
layparam = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                            ViewGroup.LayoutParams.MATCH_PARENT);
layout.setLayoutParams(layparam);
// Init Event
onClickListener = new OnClickListener() {
  public  void onClick(View view) {
    if (enabled) {
      controls.pOnClick(PasObj,Const.Click_Default);
    }
  }; 
};

//geric list item click Event - experimental component model!
onListItemClickListener = new OnItemClickListener() {
@Override
public  void onItemClick(AdapterView<?> parent, View v, int position, long id) {	   
     controls.jAppOnListItemClick(parent, v, position, v.getId()); 
}
};

//Init Event
onViewClickListener = new OnClickListener() {
public  void onClick(View view) {
 if (enabled) {
   controls.jAppOnViewClick(view, view.getId());
 }
};
};

layout.setOnClickListener(onClickListener);

}

public  RelativeLayout GetLayout() {
  return layout;
}

public  RelativeLayout GetView() {
	  return layout;
}

public  void Show(int effect) {			
   controls.appLayout.addView(layout);
   parent = controls.appLayout;
}

public  void Close(int effect ) {
    controls.pOnClose(PasObj);
}

public  void Close2() {  	
  controls.appLayout.removeView(layout);
  controls.pOnClose(PasObj);
}

public boolean IsConnected(){ // by renabor
   boolean r = false;	
   ConnectivityManager cm =  (ConnectivityManager)controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
   if (cm == null) return r;   
   NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
   if (activeNetwork == null) return r;   
   return activeNetwork != null && activeNetwork.isConnectedOrConnecting();
}

public boolean IsConnectedWifi(){ // by renabor
   boolean r = false;
   ConnectivityManager cm =  (ConnectivityManager)controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
   if (cm == null) return r;   
   NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
   if (activeNetwork == null) return r;   
   return activeNetwork.getType() == ConnectivityManager.TYPE_WIFI;
}

public boolean IsConnectedTo(int _connectionType) {	   
	   int r = -1;
	   if (!IsConnected()) return false;	   
	   ConnectivityManager cm =  (ConnectivityManager)controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);	   
	   NetworkInfo activeNetwork = cm.getActiveNetworkInfo();	   
	   if (activeNetwork != null) {   	   
		  switch (activeNetwork.getType()){
		  case ConnectivityManager.TYPE_MOBILE: r = 0; break;  //0
		  case ConnectivityManager.TYPE_WIFI: r = 1; break;  //1
 		  case ConnectivityManager.TYPE_BLUETOOTH: r = 2; break; //7
		  case ConnectivityManager.TYPE_ETHERNET: r = 3; break; //9		  
		  }	      
	   }	   
	   if (r == _connectionType)  
		   return true;
	   else 
		  return false;
	   
}
//
public  void SetVisible ( boolean visible ) {	
if (visible) { if (layout.getParent() == null)
               { controls.appLayout.addView(layout); } }
else         { if (layout.getParent() != null)
               { controls.appLayout.removeView(layout); } };
}

//
public  void SetEnabled ( boolean enabled ) {	
for (int i = 0; i < layout.getChildCount(); i++) {
  View child = layout.getChildAt(i);
  child.setEnabled(enabled);
}

}

public void ShowMessage(String msg){
  Log.i("ShowMessage", msg);
  Toast.makeText(controls.activity, msg, Toast.LENGTH_SHORT).show();	
}

public String GetDateTime() {
  SimpleDateFormat formatter = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss", Locale.getDefault() );
  return( formatter.format ( new Date () ) );	
}

//Free object except Self, Pascal Code Free the class.
 public void Free() {	
   if (parent != null) { controls.appLayout.removeView(layout); }  
   onClickListener = null;
   layout.setOnClickListener(null);
   layparam = null;
   layout   = null;  
 }
  
 //http://startandroid.ru/en/lessons/complete-list/250-lesson-29-invoking-activity-and-getting-a-result-startactivityforresult-method.html
public String GetStringExtra(Intent data, String extraName) {
		String valueStr;
		valueStr= "";
	    if (data != null) { 
	    	valueStr = data.getStringExtra(extraName);
	    } 	    
	    return valueStr;	  
}

public int GetIntExtra(Intent data, String extraName, int defaultValue) {
	int value;
	value = defaultValue;
    if (data != null) { 
    	value = data.getIntExtra(extraName, defaultValue); 
    } 	    
    return value;  
}

public double GetDoubleExtra(Intent data, String extraName, double defaultValue) {
	double value;
	value = defaultValue;
    if (data != null) { 
    	value = data.getDoubleExtra(extraName, defaultValue); 
    } 	    
    return value;  
}
                        
public  OnClickListener GetOnViewClickListener () {   
	return this.onViewClickListener; 
}

public  OnItemClickListener  GetOnListItemClickListener  () {   
	return this.onListItemClickListener; 
}

public int getSystemVersion()
{	
	return controls.systemVersion;	
}

 public boolean SetWifiEnabled(boolean _status) {
    WifiManager wifiManager = (WifiManager)this.controls.activity.getSystemService(Context.WIFI_SERVICE);             
    return wifiManager.setWifiEnabled(_status);
 }

 public boolean IsWifiEnabled() {
    WifiManager wifiManager = (WifiManager)this.controls.activity.getSystemService(Context.WIFI_SERVICE);
    return  wifiManager.isWifiEnabled();	
 }
         
 public boolean IsMobileDataEnabled() {
   boolean mobileDataEnabled = false; // Assume disabled 
   ConnectivityManager cm = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
   try {
      final Class<?> cmClass = Class.forName(cm.getClass().getName());
      Method method = cmClass.getDeclaredMethod("getMobileDataEnabled");
      method.setAccessible(true); // Make the method callable
      // get the setting for "mobile data"
      mobileDataEnabled = (Boolean)method.invoke(cm);
   } catch (Exception e) {
     // Some problem accessible private API
     // TODO do whatever error handling you want here
   }
   return mobileDataEnabled;
 }
 
public String GetEnvironmentDirectoryPath(int _directory) {
	
	File filePath= null;
	String absPath="";   //fail!
	  
	//Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);break; //only Api 19!
	if (_directory != 8) {		  	   	 
	  switch(_directory) {	                       
	    case 0:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS); break;	   
	    case 1:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM); break;
	    case 2:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC); break;
	    case 3:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES); break;
	    case 4:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_NOTIFICATIONS); break;
	    case 5:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES); break;
	    case 6:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PODCASTS); break;
	    case 7:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RINGTONES); break;
	    
	    case 9: absPath  = this.controls.activity.getFilesDir().getAbsolutePath(); break;      //Result : /data/data/com/MyApp/files	    	    
	    case 10: absPath = this.controls.activity.getFilesDir().getPath();
	             absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/databases"; break;
	    case 11: absPath = this.controls.activity.getFilesDir().getPath();
                 absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/shared_prefs"; break;	             
	           
	  }
	  	  
	  //Make sure the directory exists.
      if (_directory < 8) { 
    	 filePath.mkdirs();
    	 absPath= filePath.getPath(); 
      }	        
      
	}else {  //== 8 
	    if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) == true) {
	    	filePath = Environment.getExternalStorageDirectory();  //sdcard!
	    	// Make sure the directory exists.
	    	filePath.mkdirs();
	   	    absPath= filePath.getPath();
	    }
	}    	
	    		  
	return absPath;
}

public String GetInternalAppStoragePath() { //GetAbsoluteDirectoryPath 
   String PathDat = this.controls.activity.getFilesDir().getAbsolutePath();       //Result : /data/data/com/MyApp/files
   return PathDat;
}

private void copyFileUsingFileStreams(File source, File dest)
		throws IOException {
	InputStream input = null;
	OutputStream output = null;
	try {
		input = new FileInputStream(source);
		output = new FileOutputStream(dest);
		byte[] buf = new byte[1024];
		int bytesRead;
		while ((bytesRead = input.read(buf)) > 0) {
			output.write(buf, 0, bytesRead);
		}
	} finally {
		input.close();
		output.close();
	}
}

public boolean CopyFile(String _scrFullFileName, String _destFullFileName) {
	File src= new File(_scrFullFileName);
	File dest= new File(_destFullFileName);
	try {
		copyFileUsingFileStreams(src, dest);
		return true;
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		return false;
	}
}

//ref. https://xjaphx.wordpress.com/2011/10/02/store-and-use-files-in-assets/
//result: path to new storage [Internal App Storage]
public String LoadFromAssets(String _filename){
	    
	    String pathRes="";
	    
		InputStream is = null;
		FileOutputStream fos = null;					    		           			
		String PathDat = controls.activity.getFilesDir().getAbsolutePath();		
		try {		   		     			
			File outfile = new File(PathDat, _filename);				
							
			fos = new FileOutputStream(outfile);  //save to data/data/your_package/files/your_file_name										
			is = controls.activity.getAssets().open(_filename);	     
			int size = is.available();	     
			byte[] buffer = new byte[size];
			
			for (int c = is.read(buffer); c != -1; c = is.read(buffer)){
		      fos.write(buffer, 0, c);
			}	     								
			is.close();								
			fos.close();
			pathRes= PathDat +"/"+ _filename;
			
		}catch (IOException e) {
		     e.printStackTrace();		     
		}
		
		return pathRes;
}

public boolean IsSdCardMounted() {		  
   return Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED); 
}

public void DeleteFile(String _filename) {
   this.controls.activity.deleteFile(_filename);
}

public void DeleteFile(String _fullPath, String _filename) {	
   File file;
   if ( _fullPath.equalsIgnoreCase("") ) {	
      file = new File(Environment.getExternalStorageDirectory()+"/"+ _filename); // root
   }
   else {
	  file = new File(_fullPath+"/"+ _filename);   
   }  
   file.delete();   
}

public void DeleteFile(int _environmentDir, String _filename) {		  
	String baseDir = GetEnvironmentDirectoryPath(_environmentDir);
	if (!baseDir.equalsIgnoreCase("")) {
   	    File file = new File(baseDir, _filename);    	    
	    file.delete();	   
	}
}

public String CreateDir(String _dirName) {
	this.controls.activity.getDir(_dirName, 0); //if not exist -->> CREATE!
    String absPath = this.controls.activity.getFilesDir().getPath();
    absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/"+_dirName; 
	return absPath;
}

public String CreateDir(int _environmentDir, String _dirName) {	
    String baseDir = GetEnvironmentDirectoryPath(_environmentDir);
    if (!baseDir.equalsIgnoreCase("")) {
       File file = new File(baseDir, _dirName);    
       file.mkdirs();        
  	  return file.getPath(); 
    }else return "";
}

public String CreateDir(String _fullPath, String _dirName) {	
    File file = new File(_fullPath, _dirName);    
    file.mkdirs();      
    return file.getPath();
}

/*
Added in API level 11
Returns whether the primary "external" storage device is emulated. If true, 
data stored on this device will be stored on a portion of the internal storage system.
*/
public boolean IsExternalStorageEmulated () {
  return  Environment.isExternalStorageEmulated();
}	

/*
Added in API level 9
Returns whether the primary "external" storage device is removable.
*/
public boolean IsExternalStorageRemovable() {
	return  Environment.isExternalStorageRemovable();
}	

//
public  String GetjFormVersionFeatures() { 
    String listVersionInfo = 
		   "6$5=SetWifiEnabled;" +  //[0.6-05]
		   "6$5=IsWifiEnabled;" +
		   "6$5=GetEnvironmentDirectoryPath;" +
		   "6$5=GetInternalAppStoragePath;" +
		   "6$5=CopyFile;" +
		   "6$5=LoadFromAssets;" +  		         
		   "6$5=IsSdCardMounted;" +
		   "6$5=DeleteFile;" +
		   "6$5=CreateDir;" +
		   "6$5=IsExternalStorageEmulated;" +
		   "6$5=IsExternalStorageRemovable";  
    return listVersionInfo;
}

/*
*Given that you can access R.java just fine normally in code.
*As long as you are retrieving data from your application's R.java - Use reflection!
*/
public int GetStringResourceId(String _resName) {
	  try {
	     Class<?> res = R.string.class;
	     Field field = res.getField(_resName); 
	     int strId = field.getInt(null);
	     return strId;
	   }
	   catch (Exception e) {
	     Log.e("jForm", "Failure to Get String  Resource", e);
	     return 0;
	   }   
}

public String GetStringResourceById(int _resID) {   	
   return (String)( this.controls.activity.getResources().getText(_resID));
}

public int GetDrawableResourceId(String _resName) {
	  try {
	     Class<?> res = R.drawable.class;
	     Field field = res.getField(_resName);  //"drawableName"
	     int drawableId = field.getInt(null);
	     return drawableId;
	  }
	  catch (Exception e) {
	     Log.e("jForm", "Failure to get drawable id.", e);
	     return 0;
	  }
}

public Drawable GetDrawableResourceById(int _resID) {
	return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
}

//by  thierrydijoux
public String GetQuantityStringByName(String _resName, int _quantity) {
	int id = this.controls.activity.getResources().getIdentifier(_resName, "plurals", this.controls.activity.getPackageName());
  String value = id == 0 ? "" : (String) this.controls.activity.getResources().getQuantityString(id, _quantity, _quantity);
	return value;
}

//by thierrydijoux
public String GetStringResourceByName(String _resName) {
	int id = this.controls.activity.getResources().getIdentifier(_resName, "string", this.controls.activity.getPackageName());
  String value = id == 0 ? "" : (String) this.controls.activity.getResources().getText(id);
	return value;
}   

public ActionBar GetActionBar() { 
    return this.controls.activity.getActionBar();
}

/*
 * To disableAction-bar Icon and Title, you must do two things:
 setDisplayShowHomeEnabled(false);  // hides action bar icon
 setDisplayShowTitleEnabled(false); // hides action bar title
 */

public void HideActionBar() {
 ActionBar actionBar = this.controls.activity.getActionBar(); 
 actionBar.hide();          
}

public void ShowActionBar() {	         
	ActionBar actionBar = this.controls.activity.getActionBar();
	actionBar.show();
}

//Hide the title label
public void ShowTitleActionBar(boolean _value) {
	ActionBar actionBar = this.controls.activity.getActionBar();
    actionBar.setDisplayShowTitleEnabled(_value);
}

//Hide the logo = false
public void ShowLogoActionBar(boolean _value) { 
   ActionBar actionBar = this.controls.activity.getActionBar();	    
   actionBar.setDisplayShowHomeEnabled(_value);
}

//set a title and subtitle to the Action bar as shown in the code snippet.
public void SetTitleActionBar(String _title) {
	ActionBar actionBar = this.controls.activity.getActionBar();   	
    actionBar.setTitle(_title);    
}

//set a title and subtitle to the Action bar as shown in the code snippet.
public void SetSubTitleActionBar(String _subtitle) {
   ActionBar actionBar = this.controls.activity.getActionBar();    
   actionBar.setSubtitle(_subtitle);
   //actionBar.setDisplayHomeAsUpEnabled(true);  
}

//forward [<] activity! // If your minSdkVersion is 11 or higher!
/*.*/public void SetDisplayHomeAsUpEnabledActionBar(boolean _value) {
   ActionBar actionBar = this.controls.activity.getActionBar();    
   actionBar.setDisplayHomeAsUpEnabled(_value);
}	

public void SetIconActionBar(String _iconIdentifier) {
	ActionBar actionBar = this.controls.activity.getActionBar();   	
    actionBar.setIcon(GetDrawableResourceById(GetDrawableResourceId(_iconIdentifier)));
}

public void SetTabNavigationModeActionBar(){
	ActionBar actionBar = this.controls.activity.getActionBar();
	actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);	//API 11
	actionBar.setSelectedNavigationItem(0);
}

//This method remove all tabs from the action bar and deselect the current tab
public void RemoveAllTabsActionBar() {
	ActionBar actionBar = this.controls.activity.getActionBar();
	actionBar.removeAllTabs();
        this.controls.activity.invalidateOptionsMenu(); // by renabor
	actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_STANDARD); //API 11 renabor
}

//Calculate ActionBar height
//ref http://stackoverflow.com/questions/12301510/how-to-get-the-actionbar-height
public int GetActionBarHeight() {
int actionBarHeight = 0;
TypedValue tv = new TypedValue();
if (controls.activity.getActionBar().isShowing()) {  
   if (controls.activity.getTheme().resolveAttribute(android.R.attr.actionBarSize, tv, true)) {
      actionBarHeight = TypedValue.complexToDimensionPixelSize(tv.data,controls.activity.getResources().getDisplayMetrics());
   }
}
return actionBarHeight;
}

public boolean ActionBarIsShowing() {
  return controls.activity.getActionBar().isShowing();
}

public boolean IsPackageInstalled(String _packagename) {
    PackageManager pm = controls.activity.getPackageManager();
    try {
        pm.getPackageInfo(_packagename, PackageManager.GET_ACTIVITIES);
        return true;
    } catch (NameNotFoundException e) {
        return false;
    }
}
   //android.view.View
public void ShowCustomMessage(View _layout,  int _gravity) {
    //controls.pOnShowCustomMessage(PasObj);
    Toast toast = new Toast(controls.activity);   
    toast.setGravity(_gravity, 0, 0);    
    toast.setDuration(Toast.LENGTH_LONG);    
    RelativeLayout par = (RelativeLayout)_layout.getParent();
	if (par != null) {
	    par.removeView(_layout);        	    
	}    
    _layout.setVisibility(0);
    toast.setView(_layout);
    toast.show();
}

private class MyCountDownTimer extends CountDownTimer {
	  Toast toast;
	  public MyCountDownTimer(long startTime, long interval, Toast toas) {
	     super(startTime, interval);
	     toast = toas;
	  }
	  @Override
	  public void onFinish() {
	   //text.setText("Time's up!");
		  toast.cancel();
	  }
	  @Override
	  public void onTick(long millisUntilFinished) {
	   //text.setText("" + millisUntilFinished / 1000);
		  toast.show();
	  }	 	  
}

public void ShowCustomMessage(View _layout,  int _gravity,  int _lenghTimeSecond) {
    Toast toast = new Toast(controls.activity);   
    toast.setGravity(_gravity, 0, 0);    
    //toast.setDuration(Toast.LENGTH_LONG);    
    RelativeLayout par = (RelativeLayout)_layout.getParent();
	if (par != null) {
	    par.removeView(_layout);        	    
	}    
    _layout.setVisibility(0);
    toast.setView(_layout);    				
    //it will show the toast for 20 seconds: 
    //(20000 milliseconds/1st argument) with interval of 1 second/2nd argument //--> (20 000, 1000)
    MyCountDownTimer countDownTimer = new MyCountDownTimer(_lenghTimeSecond*1000, 1000, toast);
    countDownTimer.start();
}

public void SetScreenOrientation(int _orientation) {
	//Log.i("Screen","Orientation "+ _orientation);
    switch(_orientation) {
      case 1: controls.activity.setRequestedOrientation (ActivityInfo.SCREEN_ORIENTATION_PORTRAIT); break;
      case 2: controls.activity.setRequestedOrientation (ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE); break;
      default:controls.activity.setRequestedOrientation (ActivityInfo.SCREEN_ORIENTATION_SENSOR); break;
    }            
}

public int GetScreenOrientation() {
	    int orientation = controls.activity.getResources().getConfiguration().orientation;
	    int r = 0;       	    
        switch(orientation) {
           case Configuration.ORIENTATION_PORTRAIT:
               r= 1;//setRequestedOrientation (ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
               break;
           case Configuration.ORIENTATION_LANDSCAPE:
               r = 2; //setRequestedOrientation (ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
               break;               
       }
       return r; 
}

public String GetScreenDensity() {
    String r= "";
    DisplayMetrics metrics = new DisplayMetrics();

    controls.activity.getWindowManager().getDefaultDisplay().getMetrics(metrics);

    int density = metrics.densityDpi;
        
    if (density==DisplayMetrics.DENSITY_XXHIGH) {    	    	
        r= "XXHIGH:" + String.valueOf(density);
    }
    else if (density==DisplayMetrics.DENSITY_XHIGH) {    	    	
        r= "XHIGH:" + String.valueOf(density);
    }
    else if (density==DisplayMetrics.DENSITY_HIGH) {    	    	
        r= "HIGH:" + String.valueOf(density);
    }
    else if (density==DisplayMetrics.DENSITY_MEDIUM) {
        r= "MEDIUM:" + String.valueOf(density);
    }
    else if (density==DisplayMetrics.DENSITY_LOW) {
        r= "LOW:" + String.valueOf(density);
    }
    return r;
}

public String GetScreenSize() {
	String r= "";
	
	if((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == Configuration.SCREENLAYOUT_SIZE_XLARGE) {     
        r = "XLARGE";
    }else if((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == Configuration.SCREENLAYOUT_SIZE_LARGE) {     
        r = "LARGE";
    }else if ((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == Configuration.SCREENLAYOUT_SIZE_NORMAL) {     
        r = "NORMAL";
    }else if ((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == Configuration.SCREENLAYOUT_SIZE_SMALL) {     
    	r = "SMALL";
    }
	return r;
}

public void LogDebug(String _tag, String  _msg) {
   Log.d(_tag, _msg);  //debug
}

public void Vibrate(int _milliseconds) {
	Vibrator vib = (Vibrator) controls.activity.getSystemService(Context.VIBRATOR_SERVICE);	
    if (vib.hasVibrator()) {
    	vib.vibrate(_milliseconds);
    }		
}

public void Vibrate(long[] _millisecondsPattern) {
	Vibrator vib = (Vibrator) controls.activity.getSystemService(Context.VIBRATOR_SERVICE);	
    if (vib.hasVibrator()) {
    	vib.vibrate(_millisecondsPattern, -1);
    }		
}
//http://stackoverflow.com/questions/2661536/how-to-programatically-take-a-screenshot-on-android
public void TakeScreenshot(String _savePath, String _saveFileNameJPG) {
	
	String myPath = _savePath + "/" +  _saveFileNameJPG;	
	Bitmap bitmap;	
	View v1 = controls.activity.getWindow().getDecorView().getRootView(); 
	v1.setDrawingCacheEnabled(true);		
	bitmap = Bitmap.createBitmap(v1.getDrawingCache());
	v1.setDrawingCacheEnabled(false);

	OutputStream fout = null;
	File imageFile = new File(myPath);

	try {
	    fout = new FileOutputStream(imageFile);
	    bitmap.compress(Bitmap.CompressFormat.JPEG, 90, fout);
	    fout.flush();
	    fout.close();

	} catch (FileNotFoundException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	} catch (IOException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	}
}

public String GetTitleActionBar() {
	ActionBar actionBar = this.controls.activity.getActionBar();   	
    return (String)actionBar.getTitle();    
}

public String GetSubTitleActionBar() {
	   ActionBar actionBar = this.controls.activity.getActionBar();    
	   return (String)actionBar.getSubtitle();  
}

//https://xjaphx.wordpress.com/2011/10/02/store-and-use-files-in-assets/
public void CopyFromAssetsToInternalAppStorage(String _filename){				    		   
		InputStream is = null;
		FileOutputStream fos = null;			
		String PathDat = controls.activity.getFilesDir().getAbsolutePath();			 			
		try {		   		     			
			File outfile = new File(PathDat+"/"+_filename);								
			// if file doesnt exists, then create it
			if (!outfile.exists()) {
				outfile.createNewFile();			
			}												
			fos = new FileOutputStream(outfile);  //save to data/data/your_package/files/your_file_name														
			is = controls.activity.getAssets().open(_filename);																				
			int size = is.available();	     
			byte[] buffer = new byte[size];												
			for (int c = is.read(buffer); c != -1; c = is.read(buffer)){
		      fos.write(buffer, 0, c);
			}																
			is.close();								
			fos.close();															
		}catch (IOException e) {
			// Log.i("ShareFromAssets","fail!!");
		     e.printStackTrace();			     
		}									
}	

public void CopyFromInternalAppStorageToEnvironmentDir(String _filename, String _environmentDir) {	 
    String srcPath = controls.activity.getFilesDir().getAbsolutePath()+"/"+ _filename;       //Result : /data/data/com/MyApp/files	 
    String destPath = _environmentDir + "/" + _filename;	  
    CopyFile(srcPath, destPath);	  	  	   
}
	

public void CopyFromAssetsToEnvironmentDir(String _filename, String _environmentDir) {
	CopyFromAssetsToInternalAppStorage(_filename);
	CopyFromInternalAppStorageToEnvironmentDir(_filename,_environmentDir);	
}

public void ToggleSoftInput() {
	  InputMethodManager imm =(InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
	  imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
}

//thanks to Mladen
public String GetDeviceModel() {
  return android.os.Build.MODEL;  
}

public String GetDeviceManufacturer() {
  return android.os.Build.MANUFACTURER;  
}

public void SetKeepScreenOn(boolean _value) {
  if (_value)
	   controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
  else
	  controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);		
}

public void SetTurnScreenOn(boolean _value) {
	if (_value)
	   controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
	else
		controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
}

public void SetAllowLockWhileScreenOn(boolean _value) {
	if (_value)
	   controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON);
	else
	   controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON);
}

public void SetShowWhenLocked(boolean _value) {
	if (_value)
	    controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
	else
		controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
}

public Uri ParseUri(String _uriAsString) {
  return Uri.parse(_uriAsString);
}

public String UriToString(Uri _uri) {
  return _uri.toString();
}

}
 
//**class entrypoint**//please, do not remove/change this line!

//Main Java/Pascal Interface Class
public class Controls {           
//
public Activity        activity;  // Activity
public RelativeLayout  appLayout; // Base Layout
public int screenStyle=0;         // Screen Style [Dev:0 , Portrait: 1, Landscape : 2]
public int systemVersion;

//Jave -> Pascal Function ( Pascal Side = Event )
public native void pAppOnCreate(Context context, RelativeLayout layout);
public native int  pAppOnScreenStyle();
public native void pAppOnNewIntent();
public native void pAppOnDestroy();
public native void pAppOnPause();
public native void pAppOnRestart();
public native void pAppOnResume();
public native void pAppOnStart();
public native void pAppOnStop();
public native void pAppOnBackPressed();
public native int pAppOnRotate(int rotate);
public native void pAppOnConfigurationChanged();
public native void pAppOnActivityResult(int requestCode, int resultCode, Intent data);
public native void pAppOnCreateOptionsMenu(Menu menu);
public native void pAppOnClickOptionMenuItem(MenuItem menuItem, int itemID, String itemCaption, boolean checked);
public native boolean pAppOnPrepareOptionsMenu(Menu menu, int menuSize);
public native boolean pAppOnPrepareOptionsMenuItem(Menu menu, MenuItem menuItem, int itemIndex);
public native void pAppOnCreateContextMenu(ContextMenu menu);
public native void pAppOnClickContextMenuItem(MenuItem menuItem, int itemID, String itemCaption, boolean checked);
public native void pOnDraw(long pasobj, Canvas canvas);
public native void pOnTouch(long pasobj, int act, int cnt, float x1, float y1, float x2, float y2);
public native void pOnClickGeneric(long pasobj, int value);
public native boolean pAppOnSpecialKeyDown(char keyChar, int keyCode, String keyCodeString);
public native void pOnClick(long pasobj, int value);
public native void pOnChange(long pasobj, String txt, int count);
public native void pOnChanged(long pasobj, String txt, int count);
public native void pOnEnter(long pasobj);
public native void pOnClose(long pasobj);
public native void pAppOnViewClick(View view, int id);
public native void pAppOnListItemClick(AdapterView adapter, View view, int position, int id);
public native void pOnFlingGestureDetected(long pasobj, int direction);
public native void pOnPinchZoomGestureDetected(long pasobj, float scaleFactor, int state);
 
//Load Pascal Library
static {
	/*
    try {
    	System.loadLibrary("freetype"); // need by TFPNoGUIGraphicsBridge [ref. www.github.com/jmpessoa/tfpnoguigraphicsbridge]
    } catch (UnsatisfiedLinkError e) {
         Log.e("JNI_Load_LibFreetype", "exception", e);
    }
    */	
    try {
    	System.loadLibrary("controls");
    } catch (UnsatisfiedLinkError e) {
         Log.e("JNI_Load_LibControls", "exception", e);
    }  
}

// -------------------------------------------------------------------------
//  Activity Event
// -------------------------------------------------------------------------
public  int  jAppOnScreenStyle()          { return(pAppOnScreenStyle());   }     
//
public  void jAppOnCreate(Context context,RelativeLayout layout )
                                          { pAppOnCreate(context,layout);  }

public  void jAppOnNewIntent()            { pAppOnNewIntent();             }     
public  void jAppOnDestroy()              { pAppOnDestroy();               }  
public  void jAppOnPause()                { pAppOnPause();                 }  
public  void jAppOnRestart()              { pAppOnRestart();               }    
public  void jAppOnResume()               { pAppOnResume();                }    
public  void jAppOnStart()                { pAppOnStart();                 }     //change by jmpessoa : old OnActive
public  void jAppOnStop()                 { pAppOnStop();                  }   
public  void jAppOnBackPressed()          { pAppOnBackPressed();           }   
public  int  jAppOnRotate(int rotate)     {  return(pAppOnRotate(rotate)); }

//rotate=1 --> device on vertical/default position ; 2 --> device on horizontal position      //tips by jmpessoa
public  void jAppOnConfigurationChanged() { pAppOnConfigurationChanged();  }

public  void jAppOnActivityResult(int requestCode, int resultCode, Intent data) 
                                          { pAppOnActivityResult(requestCode,resultCode,data); }

public  void jAppOnCreateOptionsMenu(Menu m) {pAppOnCreateOptionsMenu(m);}
public  void jAppOnClickOptionMenuItem(MenuItem item,int itemID, String itemCaption, boolean checked){pAppOnClickOptionMenuItem(item,itemID,itemCaption,checked);}

public boolean jAppOnPrepareOptionsMenu(Menu m, int size) {
	boolean r = pAppOnPrepareOptionsMenu(m, size);
	return r;
}

public boolean jAppOnPrepareOptionsItem(Menu m, MenuItem item, int index) {
	boolean r = pAppOnPrepareOptionsMenuItem(m, item, index);
	return r;
}

public  void jAppOnCreateContextMenu(ContextMenu m) {pAppOnCreateContextMenu(m);}
public  void jAppOnClickContextMenuItem(MenuItem item,int itemID, String itemCaption, boolean checked) {pAppOnClickContextMenuItem(item,itemID,itemCaption,checked);}
public void jAppOnViewClick(View view, int id){ pAppOnViewClick(view,id);}
public void jAppOnListItemClick(AdapterView adapter, View view, int position, int id){ pAppOnListItemClick(adapter, view,position,id);}
//public  void jAppOnHomePressed()          { pAppOnHomePressed();           }
public boolean jAppOnKeyDown(char keyChar , int keyCode, String keyCodeString) {return pAppOnSpecialKeyDown(keyChar, keyCode, keyCodeString);};

//// -------------------------------------------------------------------------
//  System, Class
// -------------------------------------------------------------------------
public  void systemGC() {
   System.gc();
}

public  void systemSetOrientation(int orientation) {
   this.activity.setRequestedOrientation(orientation);
}

//by jmpessoa
public  int  systemGetOrientation() {  
   return (this.activity.getResources().getConfiguration().orientation); 
}

public  void classSetNull (Class object) {
   object = null;
}
public  void classChkNull (Class object) {
   if (object == null) { Log.i("JAVA","checkNull-Null"); };
   if (object != null) { Log.i("JAVA","checkNull-Not Null"); };
}

public Context GetContext() {   
   return this.activity; 
}

//by  thierrydijoux
public String getQuantityStringByName(String _resName, int _quantity) {
	int id = this.activity.getResources().getIdentifier(_resName, "plurals", this.activity.getPackageName());
    String value = id == 0 ? "" : (String) this.activity.getResources().getQuantityString(id, _quantity, _quantity);
	return value;
}

//by thierrydijoux
public String getStringResourceByName(String _resName) {
	int id = this.activity.getResources().getIdentifier(_resName, "string", this.activity.getPackageName());
    String value = id == 0 ? "" : (String) this.activity.getResources().getText(id);
	return value;
}   
// -------------------------------------------------------------------------
//  App Related
// -------------------------------------------------------------------------
//
public  void appFinish () {
	   activity.finish();
	   System.exit(0); //<< ------- fix by jmpessoa
}

public  void appKillProcess() {
   this.activity.finish();
}
// -------------------------------------------------------------------------
//  Asset Related
// -------------------------------------------------------------------------
// src : codedata.txt
// tgt : /data/data/com.kredix.control/data/codedata.txt
public  boolean assetSaveToFile(String src, String tgt) {
  InputStream is = null;
  FileOutputStream fos = null;
  String path = '/' + tgt.substring(1,tgt.lastIndexOf("/"));
  File outDir = new File(path);
  outDir.mkdirs();
  try {
    is = this.activity.getAssets().open(src);
    int size = is.available();
    byte[] buffer = new byte[size];
    File outfile = new File(tgt);
    fos = new FileOutputStream(outfile);
    for (int c = is.read(buffer); c != -1; c = is.read(buffer)){
      fos.write(buffer, 0, c);
    }
    is.close();
    fos.close();
    return(true); }
  catch (IOException e) {
    e.printStackTrace();
    return(false);       }
}

// -------------------------------------------------------------------------
//  View Related - Generic! --> AndroidWidget.pas
// -------------------------------------------------------------------------

public  void view_SetVisible(View view, int state) {
  view.setVisibility(state);
}

public  void view_SetBackGroundColor(View view, int color) {
  view.setBackgroundColor(color);
}

public  void view_Invalidate(View view) {
  view.invalidate();
}

// -------------------------------------------------------------------------
//  Form Related
// -------------------------------------------------------------------------
//
public  java.lang.Object jForm_Create(long pasobj ) {
  return (java.lang.Object)( new jForm(this,pasobj));
}

// -------------------------------------------------------------------------
//  System Info
// -------------------------------------------------------------------------
// Result : Width(16bit) : Height (16bit)
public  int  getScreenWH(android.content.Context context) {
  DisplayMetrics metrics = new DisplayMetrics();

  int h = context.getResources().getDisplayMetrics().heightPixels;
  int w = context.getResources().getDisplayMetrics().widthPixels;
// proposed by renabor
/* 
 float density  = context.getResources().getDisplayMetrics().density;
 int dpHeight = Math.round ( h / density );
 int dpWidth  = Math.round ( w / density );
 return ( dpWidth << 16 | dpHeight ); // dp screen size  
*/
  return ( (w << 16)| h );
}

// LORDMAN - 2013-07-28
public  int getStrLength(String Txt) {  //fix by jmpessoa
  int len = 0;	
  if(Txt != null) {	
     len = Txt.length();
  }
  return ( len );
}

/*LORDMAN - 2013-07-30
public  String getStrDateTime() { 
  SimpleDateFormat formatter = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss", Locale.KOREA );
  return( formatter.format ( new Date () ) );
}
*/
//----------------------------------------------
//Controls Version Info
//-------------------------------------------
//GetControlsVersionFeatures ...  //Controls.java version-revision info! [0.6-04]
public  String getStrDateTime() {  //hacked by jmpessoa!! sorry, was for a good cause! please, use the  jForm_GetDateTime!!
  String listVersionInfo = 
		  "7$0=GetControlsVersionInfo;" +  //added ... etc..
  		  "7$0=getLocale;"; //added ... etc.. 
  return listVersionInfo;
}

//Fatih: Path = '' = Asset Root Folder 
//Path Example: gunlukler/2015/02/28/001 
public String[] getAssetContentList(String Path) throws IOException { 
	ArrayList<String> Folders = new ArrayList<String>(); 

	Resources r = this.activity.getResources();  
	AssetManager am = r.getAssets(); 
	String fileList[] = am.list(Path); 
	if (fileList != null) 
	{    
		for (int i = 0; i < fileList.length; i++) 
		{ 
			Folders.add(fileList[i]); 
		} 
	} 
	String sFolders[] = Folders.toArray(new String[Folders.size()]);    	   
	return sFolders; 
} 

//Fatih: gets system storage driver list
public String[] getDriverList() { 
	ArrayList<String> Drivers = new ArrayList<String>(); 

	String sDriver;
	sDriver = System.getenv("EXTERNAL_STORAGE");
	if(sDriver != null)
	{
		File fDriver = new File(sDriver);

		if (fDriver.exists() && fDriver.canWrite()) {
			Drivers.add(fDriver.getAbsolutePath());
		}
	}

	sDriver = System.getenv("SECONDARY_STORAGE");
	if(sDriver != null)
	{
		File fDriver = new File(sDriver);

		if (fDriver.exists() && fDriver.canWrite()) {
			Drivers.add(fDriver.getAbsolutePath());
		}
	}
	
	String sDrivers[] = Drivers.toArray(new String[Drivers.size()]);    	   
	return sDrivers; 
} 

//Fatih: get folders list 
//Path Example: /storage/emulated/legacy/ 
public String[] getFolderList(String Path) { 
	ArrayList<String> Folders = new ArrayList<String>(); 

	File f = new File(Path);
	File[] files = f.listFiles();
	for (File fFile : files) {
	    if (fFile.isDirectory()) {
			Folders.add(fFile.getName());
	    }
	}	
	String sFolders[] = Folders.toArray(new String[Folders.size()]);    	   
	return sFolders; 
} 

//Fatih: get files list 
//Path Example: /storage/emulated/legacy/ 
public String[] getFileList(String Path) { 
	ArrayList<String> Folders = new ArrayList<String>(); 

	File f = new File(Path);
	File[] files = f.listFiles();
	for (File fFile : files) {
	    if (fFile.isFile()) {
			Folders.add(fFile.getName());
	    }
	}	
	String sFolders[] = Folders.toArray(new String[Folders.size()]);    	   
	return sFolders; 
} 
//by jmpessoa:  Class controls version info
public String GetControlsVersionInfo() { 
  return "7$0";  //version$revision  [0.6$5]
}
public long getTick() {
  return ( System.currentTimeMillis() );
}
// -------------------------------------------------------------------------
//  Android path
// -------------------------------------------------------------------------
// Result : /data/app/com.kredix-1.apk
public  String getPathApp (android.content.Context context,String pkgName) {
  String PathApp = "";
  try {
   PathApp = context.getPackageManager().getApplicationInfo( pkgName, 0 ).sourceDir;
  }
  catch ( NameNotFoundException e ) {}
  return ( PathApp );
}

// Result : /data/data/com/kredix/files
public  String getPathDat (android.content.Context context) {
  //String version = Build.VERSION.RELEASE;
  String PathDat = context.getFilesDir().getAbsolutePath();  
  return ( PathDat );
}

// Result : /storage/emulated/0
public  String getPathExt() {
  File FileExt = Environment.getExternalStorageDirectory();
  return ( FileExt.getPath() );
}

// Result : /storage/emulated/0/DCIM
public  String getPathDCIM() {
  File FileDCIM =  Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM);  
  return ( FileDCIM.getPath() );
}

//by jmpessoa
public  String getPathDataBase(android.content.Context context) {
   String destPath = context.getFilesDir().getAbsolutePath();
   destPath = destPath.substring(0, destPath.lastIndexOf("/")) + "/databases";
   return destPath;
}

// -------------------------------------------------------------------------
//  Android Locale
// -------------------------------------------------------------------------
// thierrydijoux - get locale info
public String getLocale(int localeType) {
        Context context = this.activity;
  	String value = "";	
   	switch (localeType) {
   		case 0: value = context.getResources().getConfiguration().locale.getCountry();
				break;
		case 1: value = context.getResources().getConfiguration().locale.getDisplayCountry();
				break;
   		case 2: value = context.getResources().getConfiguration().locale.getDisplayLanguage();
				break;
   		case 3: value = context.getResources().getConfiguration().locale.getDisplayName();
				break;
   		case 4: value = context.getResources().getConfiguration().locale.getDisplayVariant();
				break;
   		case 5: value = context.getResources().getConfiguration().locale.getISO3Country();
				break;
   		case 6: value = context.getResources().getConfiguration().locale.getISO3Language();
				break;
   		case 7: value = context.getResources().getConfiguration().locale.getVariant();
				break;
   	}

   	return value;
}
// -------------------------------------------------------------------------
//  Android Device
// -------------------------------------------------------------------------
// Result: Phone Number - LORDMAN
public  String getDevPhoneNumber() {
  TelephonyManager telephony = (TelephonyManager) activity.getSystemService(Context.TELEPHONY_SERVICE);
  return ( telephony.getLine1Number() );
}

// Result: Device ID - LORDMAN
// Remarks : Nexus7 (no moblie device) -> Crash : fixed code - Simon
public  String getDevDeviceID() {
  TelephonyManager telephony = (TelephonyManager) activity.getSystemService(Context.TELEPHONY_SERVICE);
  return ( telephony.getDeviceId()    );
}
// -------------------------------------------------------------------------
//  Bitmap
// -------------------------------------------------------------------------
// Get Image Width,Height without Decoding
public  int Image_getWH (String filename ) {
  BitmapFactory.Options options = new BitmapFactory.Options();
  options.inJustDecodeBounds = true;
  BitmapFactory.decodeFile(filename, options);
  return ( (options.outWidth << 16) | (options.outHeight) );
}

//
public  Bitmap Image_resample(String infile,int size) {
  int iw,ih,im; // input image w,h, max
  int scale;    //
  int ow,oh;    // output image w,h

  // get input image w,h
  BitmapFactory.Options options = new BitmapFactory.Options();
  options.inJustDecodeBounds = true;
  BitmapFactory.decodeFile(infile, options);
  iw = options.outWidth;
  ih = options.outHeight;
  //
  im = Math.max(iw,ih);
  scale = 1;
  if                      (size <= (im/32))  { scale = 32; }
  if (((im/32) < size) && (size <= (im/16))) { scale = 16; }
  if (((im/16) < size) && (size <= (im/ 8))) { scale =  8; }
  if (((im/ 8) < size) && (size <= (im/ 4))) { scale =  4; }
  if (((im/ 4) < size) && (size <= (im/ 2))) { scale =  2; }
  //
  options.inJustDecodeBounds = false;
  options.inSampleSize       = scale;
  Bitmap src = BitmapFactory.decodeFile(infile, options);
  //
  if  (im == iw) { ow = size;
                   oh = Math.round((float)ow*((float)ih/(float)iw)); }
            else { oh = size;
                   ow = Math.round((float)oh*((float)iw/(float)ih)); }
  //
  return( Bitmap.createScaledBitmap(src, ow,oh, true) );
}

public  void Image_save(Bitmap bmp, String filename) {
  try { FileOutputStream out = new FileOutputStream(filename);
        bmp.compress(Bitmap.CompressFormat.PNG, 100, out); }
  catch (Exception e)
      { e.printStackTrace(); }
}

// -------------------------------------------------------------------------
//  Toast
// -------------------------------------------------------------------------
//
public  void jToast( String str ) {
   Toast.makeText(activity, str, Toast.LENGTH_SHORT).show();
}

//by jmpessoa
//you need a real android device (not emulator!)
//http://www.androidaspect.com/2013/09/how-to-send-email-from-android.html
public void jSend_Email(
                     String to, 
                     String cc, 
                     String bcc, 
                     String subject, 
                     String message)
{
    try {
	Intent email = new Intent(Intent.ACTION_SEND);
    email.putExtra(Intent.EXTRA_EMAIL, to);
    email.putExtra(Intent.EXTRA_CC, cc);
    email.putExtra(Intent.EXTRA_BCC, bcc);
    email.putExtra(Intent.EXTRA_SUBJECT, subject);
    email.putExtra(Intent.EXTRA_TEXT, message);
    // Use email client only
    email.setType("message/rfc822");
    this.activity.startActivity(Intent.createChooser(email, "Choose an email client"));
    //rst = 1; //ok	
  }catch (Exception e) {  
		//Log.i("Java","Send Email Error");
    e.printStackTrace();
  }		  
}

//http://codetheory.in/android-sms/
//http://www.developerfeed.com/java/tutorial/sending-sms-using-android
//http://www.techrepublic.com/blog/software-engineer/how-to-send-a-text-message-from-within-your-android-app/
public int jSend_SMS(String phoneNumber, String msg) {
	SmsManager sms = SmsManager.getDefault();	
	try {
	      //SmsManager.getDefault().sendTextMessage(phoneNumber, null, msg, null, null);	      
	      List<String> messages = sms.divideMessage(msg);    
	      for (String message : messages) {
	          sms.sendTextMessage(phoneNumber, null, message, null, null);
	      }	      
	      //Log.i("Send_SMS",phoneNumber+": "+ msg);
	      return 1; //ok	      
	  }catch (Exception e) {
		  //Log.i("Send_SMS Fail",e.toString());
	      return 0; //fail
	  }
}

public int jSend_SMS(String phoneNumber, String msg, String packageDeliveredAction) {	
	String SMS_DELIVERED = packageDeliveredAction;
	PendingIntent deliveredPendingIntent = PendingIntent.getBroadcast(this.GetContext(), 0, new Intent(SMS_DELIVERED), 0);
	SmsManager sms = SmsManager.getDefault();
	try {
	      //SmsManager.getDefault().sendTextMessage(phoneNumber, null, msg, null, deliveredPendingIntent);
	      //Log.i("Send_SMS",phoneNumber+": "+ msg);
	      List<String> messages = sms.divideMessage(msg);    
	      for (String message : messages) {
	          sms.sendTextMessage(phoneNumber, null, message, null, deliveredPendingIntent);
	      }	      
	      return 1; //ok	      
	}catch (Exception e) {
	      return 0; //fail
	}
}

public String jRead_SMS(Intent intent, String addressBodyDelimiter)  {
  //---get the SMS message passed in---	
  SmsMessage[] msgs = null;
  String str = "";	  
  if (intent.getAction().equals("android.provider.Telephony.SMS_RECEIVED")) {	  
    Bundle bundle = intent.getExtras();               
    if (bundle != null)
    {
        //---retrieve the SMS message received---
        Object[] pdus = (Object[]) bundle.get("pdus");
        msgs = new SmsMessage[pdus.length];            
        for (int i=0; i<msgs.length; i++){
            msgs[i] = SmsMessage.createFromPdu((byte[])pdus[i]);                
            str += msgs[i].getOriginatingAddress();                     
            str += addressBodyDelimiter;
            str += msgs[i].getMessageBody().toString();
            str += " ";        
        }         
    }    
  } 
  return str;                         
}

//by jmpessoa
//http://eagle.phys.utk.edu/guidry/android/readContacts.html
@SuppressLint("DefaultLocale")
public String jContact_getMobileNumberByDisplayName(String contactName){
	                                                        
	   String matchNumber = "";
	   String username;
	   
	   username = contactName;
	   
	   username = username.toLowerCase(); 
	   
	   Cursor phones = this.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	
	   while (phones.moveToNext())
	   {
	     String name=phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));
	     String phoneNumber = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
	     String phoneType = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
	     
	     name = name.toLowerCase();
	     
	     if(name.equals(username)) {
	    	 if ( phoneType.equals("2")) { //mobile
	    	    matchNumber = phoneNumber;
	    	    break;
	    	 }   
	     }		     
	   }
	   phones.close();
	   return matchNumber;
}

//by jmpessoa
//http://eagle.phys.utk.edu/guidry/android/readContacts.html
public String jContact_getDisplayNameList(char delimiter){	  
	   String nameList = "";
	   Cursor phones = this.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	   while (phones.moveToNext())
	   {
	     String name=phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));
	     String phoneType = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
	     if ( phoneType.equals("2")) { //mobile
	    	 nameList = nameList + delimiter  + name;
	     }
	   }
	   phones.close();
	   return nameList;
}
// -------------------------------------------------------------------------
//  Bitmap
// -------------------------------------------------------------------------
public  int[] getBmpArray(String file) {
  Bitmap bmp = BitmapFactory.decodeFile(file);
  int   length = bmp.getWidth()*bmp.getHeight();
  int[] pixels = new int[length+2];
  bmp.getPixels(pixels, 0, bmp.getWidth(), 0, 0, bmp.getWidth(), bmp.getHeight());
  pixels[length+0] = bmp.getWidth ();
  pixels[length+1] = bmp.getHeight();
  return ( pixels );
}
// -------------------------------------------------------------------------
//  Camera
// -------------------------------------------------------------------------
  public void takePhoto(String filename) {  //HINT: filename = App.Path.DCIM + '/test.jpg
	  Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);	
	  Uri mImageCaptureUri = Uri.fromFile(new File("", filename));	  
	  intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, mImageCaptureUri);
	  intent.putExtra("return-data", true);
	  activity.startActivityForResult(intent, 12345);
  }
  /*
   * NOTE: The DCIM folder on the microSD card in your Android device is where Android stores the photos and videos 
   * you take with the device's built-in camera. When you open the Android Gallery app, 
   * you are browsing the files saved in the DCIM folder....
   */
  //by jmpessoa  
public String jCamera_takePhoto(String path, String filename) {
 	  Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
	  Uri mImageCaptureUri = Uri.fromFile(new File(path, '/'+filename)); // get Android.Uri from file
	  intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, mImageCaptureUri);
	  intent.putExtra("return-data", true);
	  this.activity.startActivityForResult(intent, 12345); //12345 = requestCode
	  return (path+'/'+filename);	  
}

public String jCamera_takePhoto(String path, String filename, int requestCode) {
	  Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
	  Uri mImageCaptureUri = Uri.fromFile(new File(path, '/'+filename)); // get Android.Uri from file
	  intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, mImageCaptureUri);
	  intent.putExtra("return-data", true);
	  this.activity.startActivityForResult(intent, requestCode); //12345 = requestCode
	  return (path+'/'+filename);	  
}

//-------------------------------------------------------------------------------------------------------
//SMART LAMW DESIGNER
//-------------------------------------------------------------------------------------------------------

public  java.lang.Object jTextView_Create(long pasobj) {
  return (java.lang.Object)( new jTextView(this.activity,this,pasobj));
}

public  java.lang.Object jButton_Create(long pasobj ) {
  return (java.lang.Object)( new jButton(this.activity,this,pasobj));
}

public  java.lang.Object jImageView_Create(long pasobj ) {
  return (java.lang.Object)( new jImageView(this.activity,this,pasobj));
}

public java.lang.Object jSurfaceView_jCreate(long _Self) {
   return (java.lang.Object)(new jSurfaceView(this,_Self));
}
public native void pOnSurfaceViewCreated(long pasobj, SurfaceHolder surfaceHolder);
public native void pOnSurfaceViewDraw(long pasobj, Canvas canvas);
public native void pOnSurfaceViewChanged(long pasobj, int width, int height);
public native void pOnSurfaceViewTouch(long pasobj, int act, int cnt,float x1, float y1,float x2, float y2);
public native boolean pOnSurfaceViewDrawingInBackground(long pasobj, float progress);
public native void pOnSurfaceViewDrawingPostExecute(long pasobj, float progress);

public  java.lang.Object jCheckBox_Create(long pasobj ) {
  return (java.lang.Object)( new jCheckBox(this.activity,this,pasobj));
}

public  java.lang.Object jAsyncTask_Create(long pasobj ) {
   return (java.lang.Object)( new jAsyncTask(this,pasobj));
}
public native boolean pOnAsyncEventDoInBackground(long pasobj, int progress);
public native int pOnAsyncEventProgressUpdate(long pasobj, int progress);
public native int pOnAsyncEventPreExecute(long pasobj);
public native void pOnAsyncEventPostExecute(long pasobj, int progress);

public java.lang.Object jImageFileManager_jCreate(long _Self) {
   return (java.lang.Object)(new jImageFileManager(this,_Self));
}

public  java.lang.Object jDialogProgress_Create(long pasobj, String title, String msg) {
  return (jDialogProgress)(new jDialogProgress(activity,this,pasobj,title,msg ) );
}

public java.lang.Object jMediaPlayer_jCreate(long _Self) {
  return (java.lang.Object)(new jMediaPlayer(this,_Self));
}
public native void pOnMediaPlayerPrepared(long pasobj, int videoWidth, int videoHeigh);
public native void pOnMediaPlayerVideoSizeChanged(long pasobj, int videoWidth, int videoHeight);
public native void pOnMediaPlayerCompletion(long pasobj);
public native void pOnMediaPlayerTimedText(long pasobj, String timedText);

}
