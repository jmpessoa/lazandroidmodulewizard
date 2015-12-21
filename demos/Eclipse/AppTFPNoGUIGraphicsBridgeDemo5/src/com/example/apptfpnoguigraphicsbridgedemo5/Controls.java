package com.example.apptfpnoguigraphicsbridgedemo5;

//Lamw: Lazarus Android Module Wizard  - version 0.6 - revision 36.4 - 02 November - 2015 
//Form Designer and Components development model!
//
//https://github.com/jmpessoa/lazandroidmodulewizard
//http://forum.lazarus.freepascal.org/index.php/topic,21919.270.html
//
//Android Java Interface for Pascal/Delphi XE5 and FreePacal/LAZARUS[december 2013]
//
//Developers:
//          Simon,Choi / Choi,Won-sik
//                       simonsayz@naver.com
//                       http://blog.naver.com/simonsayz
//
//          LoadMan    / Jang,Yang-Ho
//                       wkddidgh@naver.com
//                       http://blog.naver.com/wkddidgh
//
//          Jose Marques Pessoa   / josemarquespessoa@gmail.com
//
//Version
//History
//           2013.02.24 ver0.01 Started
//           2013.02.28 ver0.02 added Delphi Style
//           2013.03.01 ver0.03 added sysInfo
//           2013.03.05 ver0.04 added Java Loading Png
//           2013.03.08 ver0.05 Restructuring (Interlation #.02)
//           2013.07.13 ver0.06 added TForm
//           2013.07.22 ver0.07 added Back Event for Close
//           2013.07.26 ver0.08 Class,Method Cache (Single Thread,Class)
//           2013.07.30 ver0.09 added TEditText Keyboard,Focus
//           2013.08.02 ver0.10 added TextView - Enabled
//           2013.08.05 ver0.11 added Form Object
//           2013.08.11 ver0.12 added Canvas
//                              added Direct Bitmap access
//           2013.08.14 ver0.13 Fixed Memory Leak
//           2013.08.18 ver0.14 added OpenGL ES1 2D (Stencil)
//           2013.08.21 ver0.15 Fixed jImageBtn Memory Leak
//                              Fixed Socket Buffer
//           2013.08.23 ver0.16 Fixed Memory Leak for Form,Control
//                              added Form Stack
//           2013.08.24 ver0.17 added Thread
//           2013.08.26 ver0.18 added OpenGL ES2 2D/3D
//                              added Button Font Color/Height 
//           2013.08.31 ver0.19 added Unified OpenGL ES1,2 Canvas
//                              added OpenGL ES1,2 Simulator for Windows  
//           2013.09.01 ver0.20 added GLThread on Canvas
//                              Fixed OpenGL Crash
//                              rename example Name
//
//Known Issues.
//1. http://distress.tistory.com/48
//
//

import android.annotation.SuppressLint;

import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.app.TimePickerDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ContentProviderOperation;
import android.content.ContentProviderOperation.Builder;
import android.content.ContentProviderResult;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.OperationApplicationException;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.ResolveInfo;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.database.Cursor;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.BitmapDrawable;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.opengl.GLSurfaceView;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.os.RemoteException;
import android.os.Vibrator;
import android.telephony.SmsManager;
import android.telephony.SmsMessage;
import android.telephony.TelephonyManager;
import android.preference.PreferenceManager;
import android.provider.BaseColumns;

import android.provider.ContactsContract;
import android.provider.ContactsContract.CommonDataKinds;
import android.provider.ContactsContract.CommonDataKinds.Email;
import android.provider.ContactsContract.CommonDataKinds.Phone;
import android.provider.ContactsContract.CommonDataKinds.Photo;
import android.provider.ContactsContract.CommonDataKinds.StructuredName;
import android.provider.ContactsContract.Contacts;
import android.provider.ContactsContract.Data;
import android.provider.ContactsContract.RawContacts;   //**
import android.provider.MediaStore;
import android.provider.Settings;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.Layout;
import android.text.TextUtils;
import android.text.TextUtils.TruncateAt;
import android.text.TextWatcher;
import android.text.method.NumberKeyListener;
import android.text.method.ScrollingMovementMethod;
import android.util.Base64;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.location.Address;
import android.location.Criteria;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.LocationProvider;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.media.MediaPlayer.OnTimedTextListener;
import android.media.MediaPlayer.OnVideoSizeChangedListener;
import android.media.TimedText;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.net.wifi.WifiManager;
import android.util.Log;
import android.view.ContextMenu;
import android.view.Display;
import android.view.GestureDetector;
import android.view.Menu;
import android.view.MenuItem;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.SubMenu;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.View.OnClickListener;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.Window;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.AnimationUtils;
import android.view.animation.TranslateAnimation;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.view.WindowManager;
import android.webkit.HttpAuthHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AnalogClock;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.DatePicker;
import android.widget.DigitalClock;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.SeekBar;
import android.widget.Spinner;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.Switch;
import android.widget.TimePicker;
import android.widget.ToggleButton;
//import android.view.ViewGroup.LayoutParams;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.HorizontalScrollView;
import android.widget.Scroller;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewFlipper;


import java.io.*;

import java.lang.*;

import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.Socket;
//import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.text.ParseException;
//import java.nio.ByteBuffer;
//import java.nio.ByteOrder;
//import java.nio.IntBuffer;
//import java.nio.FloatBuffer;
//import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;
//import java.util.Map;
//import java.util.Random;
import java.util.Set;
//import java.util.StringTokenizer;
import java.util.UUID;
import java.util.regex.Pattern;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGL10;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.StatusLine;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.protocol.ClientContext;
import org.apache.http.cookie.Cookie;
import org.apache.http.impl.client.BasicCookieStore;
//import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.cookie.BasicClientCookie;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.ByteArrayBuffer;
import org.apache.http.util.EntityUtils;

//import com.example.appmenudemo.R.drawable;

import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
//import android.database.sqlite.SQLiteOpenHelper;
import android.database.SQLException;
import android.database.sqlite.SQLiteException;
import java.lang.reflect.*;

//-------------------------------------------------------------------------
//Constants

//-------------------------------------------------------------------------
class Const {
public static final int TouchDown                   =  0;
public static final int TouchMove                   =  1;
public static final int TouchUp                     =  2;
//
public static final int Renderer_onSurfaceCreated   =  0;
public static final int Renderer_onSurfaceChanged   =  1;
public static final int Renderer_onDrawFrame        =  2;
public static final int Renderer_onSurfaceDestroyed =  3;
public static final int Renderer_onSurfaceThread    =  4;
//
public static final int Click_Default               =  0;
public static final int Click_Yes                   = -1;
public static final int Click_No                    = -2;
//
public static final int WebView_Act_Continue        =  0;
public static final int WebView_Act_Break           =  1;

public static final int WebView_OnUnknown           =  0;
public static final int WebView_OnBefore            =  1;
public static final int WebView_OnFinish            =  2;
public static final int WebView_OnError             =  3;

public static final int Eft_None                    = 0x00000000;
public static final int Eft_iR2L                    = 0x00000001;
public static final int Eft_oR2L                    = 0x00000002;
public static final int Eft_iL2R                    = 0x00000004;
public static final int Eft_oL2R                    = 0x00000008;
public static final int Eft_FadeIn                  = 0x00000010;
public static final int Eft_FadeOut                 = 0x00000020;

public static final int Paint_Style_Fill            =  0;
public static final int Paint_Style_Fill_And_Stroke =  1;
public static final int Paint_Style_Stroke          =  2;

public static final int CompressFormat_PNG          =  0;
public static final int CompressFormat_JPEG         =  1;

public static final int Task_Before                 =  0;
public static final int Task_Progress               =  1;
public static final int Task_Post                   =  2;
public static final int Task_BackGround             =  3;
}

//-------------------------------------------------------------------------
//Timer
//      Event : pOnTimer
//http://daddycat.blogspot.kr/2011/05/android-thread-ui.html
//http://lsit81.tistory.com/entry/ActivityrunOnUiThread%EC%99%80-post%EC%9D%98-%EC%B0%A8%EC%9D%B4%EC%A0%90
//-------------------------------------------------------------------------
class jTimer {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
// Property
private boolean         Enabled = false;   // default : false
private int             Interval = 1000;   // 1000msec
// Java Object
private Runnable runnable;
private Handler  handler;

// Constructor 
public  jTimer(Controls ctrls, long pasobj) {
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
handler  = new Handler();
runnable = new Runnable() {
 @Override
 public  final void run() {
     if (Enabled) {
          controls.pOnTimer(PasObj); // Pascal Event
          if (handler != null)
           handler.postDelayed(runnable,Interval);
     };
   }
};
}


public  void SetInterval(int interval) {
  Interval = interval;
}

public  void SetEnabled(boolean enabled) {
if (Enabled == enabled) return;
Enabled = enabled;
if (Enabled) { handler.postDelayed(runnable,Interval); };
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
  Enabled  = false;
  handler  = null;
  runnable = null;
}

};

//-------------------------------------------------------------------------
//Form
//      Event : pOnClick
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
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;

//
layout   = new RelativeLayout(controls.activity);

//layout.setOrientation(LinearLayout.VERTICAL);

layparam = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                            ViewGroup.LayoutParams.MATCH_PARENT);

layout.setLayoutParams(layparam);
 
// Init Event
onClickListener = new OnClickListener() {
  public  void onClick(View view) {
    if (enabled) {
	  //Log.i("Form_listener","Click!");
      controls.pOnClick(PasObj,Const.Click_Default);
    }
  }; 
};

//geric list item click Event - New Model
onListItemClickListener = new OnItemClickListener() {
@Override
public  void onItemClick(AdapterView<?> parent, View v, int position, long id) {	   
	 //Log.i("Form_App_ItemListClicklistener","ItemClick!");
     controls.jAppOnListItemClick(parent, v, position, v.getId()); 
}
};


//Init Event
onViewClickListener = new OnClickListener() {
public  void onClick(View view) {
 if (enabled) {
   //Log.i("Form_App_Clicklistener","Click!");
   controls.jAppOnViewClick(view, view.getId());
 }
};
};

layout.setOnClickListener(onClickListener);

}

//
public  RelativeLayout GetLayout() {
  //Log.i("Form:", "getLayout");
  return layout;
}

public  RelativeLayout GetView() {
	  //Log.i("Form:", "getLayout");
	  return layout;
}

//
public  void Show(int effect) {			
   controls.appLayout.addView( layout );
   parent = controls.appLayout;
   //
   if (effect != Const.Eft_None) {
     layout.startAnimation(controls.Ani_Effect(effect,250));
   };
   //Log.i("Form:","Show --> OnJNIPrompt");
}

//
public  void Close(int effect ) {
switch ( effect ) {
    case Const.Eft_None  : { controls.appLayout.removeView(layout);
             controls.pOnClose(PasObj);
             break; }
    default : { Animation animation = controls.Ani_Effect(effect,250);
             animation.setAnimationListener(new AnimationListener() {
               @Override
               public  void onAnimationEnd   (Animation animation) {
                 controls.appLayout.removeView(layout);
                 parent = null;
                 controls.pOnClose(PasObj);         };
               @Override
               public  void onAnimationRepeat(Animation animation) {}
               @Override
               public  void onAnimationStart(Animation animation)  {}
             });
             layout.startAnimation(animation);
           };
    };
 }

//by jmpessoa
public  void Close2() {  	
  controls.appLayout.removeView(layout);
  controls.pOnClose(PasObj);
}
public boolean IsConnected(){ // by renabor
   ConnectivityManager cm =  (ConnectivityManager)controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
   NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
   return activeNetwork != null && activeNetwork.isConnectedOrConnecting();
}

public boolean IsConnectedWifi(){ // by renabor
   ConnectivityManager cm =  (ConnectivityManager)controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
   NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
   return activeNetwork.getType() == ConnectivityManager.TYPE_WIFI;
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
  //Log.i("Form:","Parent Form Enabled "+ Integer.toString(layout.getChildCount()));	
for (int i = 0; i < layout.getChildCount(); i++) {
  View child = layout.getChildAt(i);
  child.setEnabled(enabled);
}

}

//by jmpessoa
public void ShowMessage(String msg){
  Log.i("ShowMessage", msg);
  Toast.makeText(controls.activity, msg, Toast.LENGTH_SHORT).show();	
}

//by jmpessoa
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
   //Log.i("jForm:", "Free");
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

public void SetWifiEnabled(boolean _status) {
    WifiManager wifiManager = (WifiManager)this.controls.activity.getSystemService(Context.WIFI_SERVICE);             
    wifiManager.setWifiEnabled(_status);
 }

 public boolean IsWifiEnabled() {
    WifiManager wifiManager = (WifiManager)this.controls.activity.getSystemService(Context.WIFI_SERVICE);
    return  wifiManager.isWifiEnabled();	
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


//http://daniel-codes.blogspot.com.br/2009/12/dynamically-retrieving-resources-in.html

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

//by jmpessoa
public String GetStringResourceById(int _resID) {   	
   return (String)( this.controls.activity.getResources().getText(_resID));
}

//by jmpessoa
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

//by jmpessoa
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

//Hide the logo
public void HideLogoActionBar(boolean _value) { 
   ActionBar actionBar = this.controls.activity.getActionBar();	    
   actionBar.setDisplayShowHomeEnabled(_value);
}

//set a title and subtitle to the Action bar as shown in the code snippet.
public void SetTitleActionBar(String _title) {
	ActionBar actionBar = this.controls.activity.getActionBar();   	
    actionBar.setTitle(_title);    
}


//set a title and subtitle to the Action bar as shown in the code snippet.

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


public boolean IsPackageInstalled(String _packagename) {
    PackageManager pm = controls.activity.getPackageManager();
    try {
        pm.getPackageInfo(_packagename, PackageManager.GET_ACTIVITIES);
        return true;
    } catch (NameNotFoundException e) {
        return false;
    }
}

public void ShowCustomMessage(RelativeLayout _layout,  int _gravity) {
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

public void ShowCustomMessage(RelativeLayout _layout,  int _gravity,  int _lenghTimeSecond) {
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
	    int r = 0;
        Display display = ((WindowManager) controls.activity.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();   
        int orientation = display.getOrientation();  //getOrientation();
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

}

//-------------------------------------------------------------------------
//TextView
//      Event : pOnClick
//-------------------------------------------------------------------------

class jTextView extends TextView {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private LayoutParams    lparams;           // layout XYWH
private OnClickListener onClickListener;   // event
private Boolean         enabled  = true;   //

//by jmpessoa
int wrapContent = RelativeLayout.LayoutParams.WRAP_CONTENT; //h
int matchParent = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

float mTextSize = 0; //default
int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

// Constructor
public  jTextView(android.content.Context context,
                 Controls ctrls,long pasobj ) {                    
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new LayoutParams(100,100);     // W,H
lparams.setMargins(5,5,5,5); // L,T,
// Init Event
onClickListener = new OnClickListener() {
  public  void onClick(View view) {
    if (enabled) {
      controls.pOnClick(PasObj,Const.Click_Default);
    }
  };
};
setOnClickListener(onClickListener);
}

//by jmpessoa
public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);
	if (idAnchor > 0) {    	
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
    }
	//
	this.setLayoutParams(lparams);
}

//by jmpessoa
public void setLParamWidth(int w) {
  lpW = w;
}

//by jmpessoa
public void setLParamHeight(int h) {
  lpH = h;
}

//by jmpessoa
public void addLParamsAnchorRule(int rule) {
	lparamsAnchorRule[countAnchorRule] = rule;
	countAnchorRule = countAnchorRule + 1;
}

//by jmpessoa
public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

// LORDMAN 2013-08-13
public  void setTextAlignment( int align ) {
  switch ( align ) {
     case 0 : { setGravity( Gravity.LEFT              ); }; break;
     case 1 : { setGravity( Gravity.RIGHT             ); }; break;
     case 2 : { setGravity( Gravity.TOP               ); }; break;
     case 3 : { setGravity( Gravity.BOTTOM            ); }; break;
     case 4 : { setGravity( Gravity.CENTER            ); }; break;
     case 5 : { setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
     case 6 : { setGravity( Gravity.CENTER_VERTICAL   ); }; break;
     default : { setGravity( Gravity.LEFT              ); }; break;
  };
}
             
public void setParent3( android.view.ViewGroup viewgroup ) {  //deprec...
if (parent != null) { parent.removeView(this); }
   parent = viewgroup;
   viewgroup.addView(this,lparams);
}

public void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
   parent = viewgroup;
   viewgroup.addView(this,lparams);
}

public  void setEnabled( boolean value ) {
  enabled = value;
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
   if (parent != null) { parent.removeView(this); }
   setText("");
   lparams = null;
   setOnClickListener(null);
}

/*
 * 	this.setTypeface(null, Typeface.BOLD_ITALIC);
	this.setTypeface(null, Typeface.BOLD);
    this.setTypeface(null, Typeface.ITALIC);
    this.setTypeface(null, Typeface.NORMAL);
 */

public void SetTextTypeFace(int _typeface) {
  this.setTypeface(null, _typeface);
}

public void Append(String _txt) {
  this.append( _txt);
}

public void AppendLn(String _txt) {
	  this.append( _txt+ "\n");
}

public void AppendTab() {
	  this.append("\t");
}

public void setFontAndTextTypeFace(int fontFace, int fontStyle) { 
  Typeface t = null; 
  switch (fontFace) { 
    case 0: t = Typeface.DEFAULT; break; 
    case 1: t = Typeface.SANS_SERIF; break; 
    case 2: t = Typeface.SERIF; break; 
    case 3: t = Typeface.MONOSPACE; break; 
  } 
  this.setTypeface(t, fontStyle); 		
} 

public void SetTextSize(float size) {
   mTextSize = size;	
   String t = this.getText().toString();   
   this.setTextSize(mTextSizeTypedValue, mTextSize);
   this.setText(t);
}     

//TTextSizeTypedValue =(tsDefault, tsPixels, tsDIP, tsInches, tsMillimeters, tsPoints, tsScaledPixel);
public void SetFontSizeUnit(int _unit) {	
   switch (_unit) {
      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; //default
      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break; //default
      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; //default
      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; //default
      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; //default
      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
   }   
	String t = this.getText().toString();
	this.setTextSize(mTextSizeTypedValue, mTextSize);
	this.setText(t);
}

}
//-------------------------------------------------------------------------
//EditText
//      Event : pOnClick( , )
//-------------------------------------------------------------------------

class jEditText extends EditText {
// Pascal Interface
private long           PasObj   = 0;      // Pascal Obj
private Controls      controls = null;   // Control Class for Event
//
private ViewGroup     parent   = null;   // parent view
private RelativeLayout.LayoutParams lparams;           // layout XYWH
private OnKeyListener onKeyListener;     //  thanks to @renabor
private TextWatcher   textwatcher;       // OnChange

private OnClickListener onClickListener;   // event 

//by jmpessoa
int wrapContent = RelativeLayout.LayoutParams.WRAP_CONTENT; //h
int matchParent = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

//by jmpessoa
int MarginLeft = 5;
int MarginTop = 5;

int marginRight = 5;
int marginBottom = 5;

String bufStr;
private boolean canDispatchChangeEvent = false;
private boolean canDispatchChangedEvent = false;
private boolean mFlagSuggestion = false;

private ClipboardManager mClipBoard = null;
private ClipData mClipData = null;

float mTextSize = 0; //default
int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

// Constructor
public  jEditText(android.content.Context context,
               Controls ctrls,long pasobj ) {
super(context);
canDispatchChangeEvent = false;
canDispatchChangedEvent = false;
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new RelativeLayout.LayoutParams(100,100);
lparams.setMargins(5, 5,5,5);
this.setHintTextColor(Color.LTGRAY);

mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);
 
// Event
onClickListener = new OnClickListener() {
   public  void onClick(View view) {
    //if (enabled) {
      controls.pOnClick(PasObj,Const.Click_Default);
    //}
   };
};

setOnClickListener(onClickListener);


// Init Event : http://socome.tistory.com/15
onKeyListener = new OnKeyListener() {	
  public  boolean onKey(View v, int keyCode, KeyEvent event) { //Called when a hardware key is dispatched to a view	
     if (event.getAction() == KeyEvent.ACTION_UP) {	
    	if (keyCode == KeyEvent.KEYCODE_ENTER) {
            InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(getWindowToken(), 0);       
            //Log.i("OnKeyListener","OnEnter, Hide KeyBoard");
            // LoadMan
            controls.pOnEnter(PasObj);  //just Enter/Done/Next/backbutton ....!      
            return true;    		
    	}    
     }   
     return false;
   }  
  };

setOnKeyListener(onKeyListener);
// Event
textwatcher = new TextWatcher() {
  @Override
  public  void beforeTextChanged(CharSequence s, int start, int count, int after) {	  
	  if (canDispatchChangeEvent) {
		controls.pOnChange(PasObj, s.toString(), (s.toString()).length());
	  }	 
  }
  @Override
  public  void onTextChanged(CharSequence s, int start, int before, int count) {
	  if (canDispatchChangedEvent) {		 
		controls.pOnChanged(PasObj,s.toString(), (s.toString()).length());
	  }   		  	  
  }
  @Override
  public  void afterTextChanged(Editable s) {	  
    //
  }
};

addTextChangedListener(textwatcher);
  
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

public void setLParamWidth(int w) {
  lpW = w;
}

public void setLParamHeight(int h) {
  lpH = h;
}


public void addLParamsAnchorRule(int rule) {
   lparamsAnchorRule[countAnchorRule] = rule;
   countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);
	if (idAnchor > 0) {    	
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
    }
	setLayoutParams(lparams);
}
      //CURRENCY 
public  void setInputTypeEx(String str) {
	  bufStr = new String(str.toString());
	  if(str.equals("NUMBER")) {  		   
		  this.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);	     
	  }
	  else if(str.equals("CURRENCY")) {  		    //thanks to @renabor		 
		  this.setInputType(InputType.TYPE_CLASS_NUMBER|InputType.TYPE_NUMBER_FLAG_DECIMAL|InputType.TYPE_NUMBER_FLAG_SIGNED);
	  }
      else if (str.equals("CAPCHARACTERS")) {
    	  if (!mFlagSuggestion) 
            this.setInputType(android.text.InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS|InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
    	  else
            this.setInputType(android.text.InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
      }
	  else if (str.equals("TEXT")) { 
		  if (!mFlagSuggestion) 
		      this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
		  else
			  this.setInputType(android.text.InputType.TYPE_CLASS_TEXT);
	  }
	  else if (str.equals("PHONE"))       {this.setInputType(android.text.InputType.TYPE_CLASS_PHONE); }
	  else if (str.equals("PASSNUMBER"))  {this.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
	                                       this.setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }
	  else if (str.equals("PASSTEXT"))    {this.setInputType(android.text.InputType.TYPE_CLASS_TEXT);
	                                       this.setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }
	  
	  else if (str.equals("TEXTMULTILINE")){
		  if (!mFlagSuggestion)
		      this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|android.text.InputType.TYPE_TEXT_FLAG_MULTI_LINE|InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
		   else  
		      this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|android.text.InputType.TYPE_TEXT_FLAG_MULTI_LINE);
		  }
	                                    	  
	  else {this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);};
	    
	}

// LORDMAN 2013-08-13
public  void setTextAlignment( int align ) {
switch ( align ) {
 case 0 : { setGravity( Gravity.LEFT              ); }; break;
 case 1 : { setGravity( Gravity.RIGHT             ); }; break;
 case 2 : { setGravity( Gravity.TOP               ); }; break;
 case 3 : { setGravity( Gravity.BOTTOM            ); }; break;
 case 4 : { setGravity( Gravity.CENTER            ); }; break;
 case 5 : { setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
 case 6 : { setGravity( Gravity.CENTER_VERTICAL   ); }; break;
default : { setGravity( Gravity.LEFT              ); }; break;
};
}

//
public  void setParent( android.view.ViewGroup viewgroup ) {
  if (parent != null) { parent.removeView(this); }
    parent = viewgroup;
    viewgroup.addView(this,lparams);
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
removeTextChangedListener(textwatcher);
textwatcher = null;
setOnKeyListener(null);
setText("");
lparams = null;
}

//by jmpessoa
public void setScrollerEx() {
	this.setScroller(new Scroller(controls.activity)); 
}

public void setFocus2() {
	this.requestFocus();  
}

public  void immShow2() {
	  InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
	  imm.toggleSoftInput(0, InputMethodManager.SHOW_IMPLICIT);
}


public  void immHide2() {
	  InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
	  imm.hideSoftInputFromWindow(this.getWindowToken(), 0);
}

public  int[] getCursorPos() {
	  int[] vals = new int[2];
	  vals[0] = this.getSelectionStart();
	  vals[1] = this.getSelectionEnd();
	  return vals;
}

public  void setCursorPos(int startPos, int endPos) {
	  if (endPos == 0) { endPos = startPos; };
	  this.setSelection(startPos,endPos);
}

//LORDMAN - 2013-07-26
public  void maxLength(int mLength) { //not make the length of the text greater than the specified length		
  if (mLength >= 0) { 
    InputFilter[] FilterArray = new InputFilter[1];
    FilterArray[0] = new InputFilter.LengthFilter(mLength);
    this.setFilters(FilterArray);
  }
  else { 
	  this.setFilters(new InputFilter[] {});  //reset to default!!!
  }	  
}

//LORDMAN 2013-08-27
public  void SetEnabled(boolean enabled ) {
 this.setClickable            (enabled);
 this.setEnabled              (enabled);
 this.setFocusable            (enabled);
 this.setFocusableInTouchMode (enabled);
}

//LORDMAN 2013-08-27
public  void SetEditable(boolean enabled ) {
    this.setClickable(enabled);
    
    if (enabled) {this.setEnabled(enabled); }
    
    this.setFocusable(enabled);
    this.setFocusableInTouchMode (enabled);
}

//by jmpessoa  :: bug! why?
public  void SetMovementMethod() {
    this.setMovementMethod(new ScrollingMovementMethod());//ScrollingMovementMethod.getInstance()
}
 //by jmpessoa
public String GetText() {
	return this.getText().toString();	
}

//by jmpessoa
public  void AllCaps() {
	InputFilter[] FilterArray = new InputFilter[1];
	FilterArray[0] = new InputFilter.AllCaps();
	this.setFilters(FilterArray);
}

public void DispatchOnChangeEvent(boolean value) {
	canDispatchChangeEvent = value;
}

public void DispatchOnChangedEvent(boolean value) {
	canDispatchChangedEvent = value;
}


public void SetInputType(int ipt){  //TODO!
	this.setInputType(0);
}

public void Append(String _txt) {
	this.append(_txt);
}

public void AppendLn(String _txt) {
	this.append(_txt+"\n");
}

public void AppendTab() {
	  this.append("\t");
}

public void SetImeOptions(int _imeOption) {
  switch(_imeOption ) {
	 case 0: this.setImeOptions(EditorInfo.IME_FLAG_NO_FULLSCREEN); break;
	 case 1: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_NONE); break;
	 case 2: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_GO); break;
	 case 3: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_SEARCH); break;
	 case 4: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_SEND); break;
	 case 5: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_NEXT); break;		
	 case 6: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_DONE); break;		 
	 case 7: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_PREVIOUS ); break;  
	 case 8: this.setImeOptions(EditorInfo.IME_FLAG_FORCE_ASCII); break;
  }   
}

public void setFontAndTextTypeFace(int fontFace, int fontStyle) { 
  Typeface t = null; 
  switch (fontFace) { 
    case 0: t = Typeface.DEFAULT; break; 
    case 1: t = Typeface.SANS_SERIF; break; 
    case 2: t = Typeface.SERIF; break; 
    case 3: t = Typeface.MONOSPACE; break; 
  } 
  this.setTypeface(t, fontStyle); 		
} 

public void SetAcceptSuggestion(boolean _value) { 
    mFlagSuggestion = _value;
}

public void CopyToClipboard() {
	mClipData = ClipData.newPlainText("text", this.getText().toString());
    mClipBoard.setPrimaryClip(mClipData);
}
   
public void PasteFromClipboard() {
    ClipData cdata = mClipBoard.getPrimaryClip();
    ClipData.Item item = cdata.getItemAt(0);
    this.setText(item.getText().toString());
}

public void Clear() {
	this.setText("");
}

public void SetTextSize(float size) {
	   mTextSize = size;	
	   String t = this.getText().toString();   
	   this.setTextSize(mTextSizeTypedValue, mTextSize);
	   this.setText(t);
}     

//TTextSizeTyped =(tsDefault, tsUnitPixels, tsUnitDIP, tsUnitInches, tsUnitMillimeters, tsUnitPoints, tsUnitScaledPixel);
public void SetFontSizeUnit(int _unit) {	
	   switch (_unit) {
	      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; //default
	      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break; //default
	      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; //default
	      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; //default
	      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; //default
	      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	   }   
		String t = this.getText().toString();
		this.setTextSize(mTextSizeTypedValue, mTextSize);
		this.setText(t);
}
	
}

//-------------------------------------------------------------------------
//Button
//      Event : pOnClick
//-------------------------------------------------------------------------

class jButton extends Button {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private LayoutParams    lparams;           // layout XYWH
private OnClickListener onClickListener;   // event

private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;
int textColor;

boolean mChangeFontSizeByComplexUnitPixel = false;
float mTextSize = 0; //default
int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

// Constructor
public  jButton(android.content.Context context,
             Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
controls   = ctrls;
PasObj = pasobj;
// Init Class
lparams = new LayoutParams(100,100);     // W,H
lparams.setMargins(5,5,5,5); // L,T,
// Init Event
onClickListener = new OnClickListener() {
  public  void onClick(View view) {	  
	//Log.i("TAG_CLICK", "jButton_Clicked!"); //just demo for LATE logcat filter!
    controls.pOnClick(PasObj,Const.Click_Default); 
  }
};
setOnClickListener(onClickListener);
//Log.i("jButton","created!");
}

//
public  void setParent( android.view.ViewGroup viewgroup ) {
   if (parent != null) { parent.removeView(this); }
   parent = viewgroup;
   viewgroup.addView(this,lparams);
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
setOnKeyListener(null);
setText("");
lparams = null;
}

public void setLParamWidth(int w) {
	  lpW = w;
}

public void setLParamHeight(int h) {
	  lpH = h;
}

//by jmpessoa
public void addLParamsAnchorRule(int rule) {
	 lparamsAnchorRule[countAnchorRule] = rule;
	 countAnchorRule = countAnchorRule + 1;
}
//by jmpessoa
public void addLParamsParentRule(int rule) {
		lparamsParentRule[countParentRule] = rule;
		countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
		lparams.width  = lpW; //matchParent; 
		lparams.height = lpH; //wrapContent;
		lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

		if (idAnchor > 0) {    	
			//lparams.addRule(RelativeLayout.BELOW, id); 
			//lparams.addRule(RelativeLayout.ALIGN_BASELINE, id)
		    //lparams.addRule(RelativeLayout.LEFT_OF, id); //lparams.addRule(RelativeLayout.RIGHT_OF, id)
			for (int i=0; i < countAnchorRule; i++) {  
				lparams.addRule(lparamsAnchorRule[i], idAnchor);		
		    }
			
		} 
		for (int j=0; j < countParentRule; j++) {  
			lparams.addRule(lparamsParentRule[j]);			
	    }
		//
		this.setLayoutParams(lparams);
	}

/*
 * If i set android:focusable="true" then button is highlighted and focused, 
 * but then at the same time, 
 * i need to click twice on the button to perform the actual click event.
 */
//by jmpessoa
public  void SetFocusable(boolean enabled ) {	
  this.setClickable            (enabled);
  this.setEnabled              (enabled);
  this.setFocusable            (enabled);//*
  this.setFocusableInTouchMode (enabled);//*
  //obj.requestFocus(); 
}

public void SetTextSize(float size) {
	   mTextSize = size;	
	   String t = this.getText().toString();   
	   this.setTextSize(mTextSizeTypedValue, mTextSize);
	   this.setText(t);
}     

public void SetChangeFontSizeByComplexUnitPixel(boolean _value) {
	    mChangeFontSizeByComplexUnitPixel = _value;    
	    mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
	    if (_value) { 
	       mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX;
	    }    
		String t = this.getText().toString();
		setTextSize(mTextSizeTypedValue, mTextSize);
		this.setText(t);
}

//TTextSizeTyped =(tsDefault, tsUnitPixels, tsUnitDIP, tsUnitInches, tsUnitMillimeters, tsUnitPoints, tsUnitScaledPixel);
public void SetFontSizeUnit(int _unit) {	
	   switch (_unit) {
	      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; //default
	      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break; //default
	      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; //default
	      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; //default
	      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; //default
	      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	   }   
		String t = this.getText().toString();
		this.setTextSize(mTextSizeTypedValue, mTextSize);
		this.setText(t);
}


}

//-------------------------------------------------------------------------
//CheckBox
//      Event : pOnClick
//-------------------------------------------------------------------------

class jCheckBox extends CheckBox {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private LayoutParams    lparams;           // layout XYWH
private OnClickListener onClickListener;   // event

private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

float mTextSize = 0; //default
int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

//by jmpessoa
public void setMarginRight(int x) {
	marginRight = x;
}

//by jmpessoa
public void setMarginBottom(int y) {
	marginBottom = y;
}
//by jmpessoa
public void setMarginLeft(int x) {
	MarginLeft = x;
}

//by jmpessoa
public void setMarginTop(int y) {
	MarginTop = y;
}

// Constructor
public  jCheckBox(android.content.Context context,
               Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new LayoutParams(100,100);     // W,H
lparams.setMargins        (50, 50,0,0); // L,T,
// Init Event
onClickListener = new OnClickListener() {
  public  void onClick(View view) {
    controls.pOnClick(PasObj,Const.Click_Default);
  }
};
setOnClickListener(onClickListener);
}

//
public  void setXYWH ( int x, int y, int w, int h ) {
lparams.width  = w;
lparams.height = h;
lparams.setMargins(x,y,0,0);
//
setLayoutParams(lparams);
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}
//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
  parent = viewgroup;
  viewgroup.addView(this,lparams);
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
  if (parent != null) { parent.removeView(this); }
  this.setText("");
  lparams = null;
}

//by jmpessoa
public void setLParamWidth(int w) {
	  lpW = w;
}

public void setLParamHeight(int h) {
	  lpH = h;
}

public void addLParamsAnchorRule(int rule) {
	 lparamsAnchorRule[countAnchorRule] = rule;
	 countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
		lparamsParentRule[countParentRule] = rule;
		countParentRule = countParentRule + 1;
}

	//by jmpessoa
public void setLayoutAll(int idAnchor) {
		lparams.width  = lpW; //matchParent; 
		lparams.height = lpH; //wrapContent;
		lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

		if (idAnchor > 0) {    	
			//lparams.addRule(RelativeLayout.BELOW, id); 
			//lparams.addRule(RelativeLayout.ALIGN_BASELINE, id)
		    //lparams.addRule(RelativeLayout.LEFT_OF, id); //lparams.addRule(RelativeLayout.RIGHT_OF, id)
			for (int i=0; i < countAnchorRule; i++) {  
				lparams.addRule(lparamsAnchorRule[i], idAnchor);		
		    }
			
		} 
		for (int j=0; j < countParentRule; j++) {  
			lparams.addRule(lparamsParentRule[j]);		
	    }
		//
		setLayoutParams(lparams);
}

//by jmpessoa
public void setIdEx(int id) {
	  setId(id);	
}

public void setTextColor2(int value) {
	this.setTextColor(value);  
}

public  boolean isChecked2() {
   return this.isChecked();
}

public  void setChecked2(boolean value) {
   this.setChecked(value);
}


public void SetText(String txt) {
	this.setText(txt);
}

public String GetText() {
	return this.getText().toString();
}

public void SetTextSize(float size) {
	   mTextSize = size;	
	   String t = this.getText().toString();   
	   this.setTextSize(mTextSizeTypedValue, mTextSize);
	   this.setText(t);
}     

//TTextSizeTyped =(tsDefault, tsUnitPixels, tsUnitDIP, tsUnitInches, tsUnitMillimeters, tsUnitPoints, tsUnitScaledPixel);
public void SetFontSizeUnit(int _unit) {	
	   switch (_unit) {
	      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; //default
	      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break; //default
	      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; //default
	      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; //default
	      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; //default
	      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	   }   
		String t = this.getText().toString();
		this.setTextSize(mTextSizeTypedValue, mTextSize);
		this.setText(t);
}

}

//-------------------------------------------------------------------------
//RadioButton
//      Event : pOnClick
//-------------------------------------------------------------------------

class jRadioButton extends RadioButton {
// Java-Pascal Interface
private long           PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private LayoutParams    lparams;           // layout XYWH
private OnClickListener onClickListener;   // event

private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

float mTextSize = 0; //default
int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

// Constructor
public  jRadioButton(android.content.Context context,
                  Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
controls   = ctrls;
PasObj = pasobj;
// Init Class
lparams = new LayoutParams  (100,100);
lparams.setMargins( 50, 50,0,0);
// Init Event
onClickListener = new OnClickListener() {
  public  void onClick(View view) {
    controls.pOnClick(PasObj,Const.Click_Default);
  }
};
setOnClickListener(onClickListener);
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
parent = viewgroup;
viewgroup.addView(this,lparams);
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
setText("");
lparams = null;
}

//by jmpessoa
public void setLParamWidth(int w) {
	  lpW = w;
}

public void setLParamHeight(int h) {
	  lpH = h;
}

public void addLParamsAnchorRule(int rule) {
	 lparamsAnchorRule[countAnchorRule] = rule;
	 countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
		lparamsParentRule[countParentRule] = rule;
		countParentRule = countParentRule + 1;
}

	//by jmpessoa
public void setLayoutAll(int idAnchor) {
		lparams.width  = lpW; //matchParent; 
		lparams.height = lpH; //wrapContent;
		lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

		if (idAnchor > 0) {    	
			//lparams.addRule(RelativeLayout.BELOW, id); 
			//lparams.addRule(RelativeLayout.ALIGN_BASELINE, id)
		    //lparams.addRule(RelativeLayout.LEFT_OF, id); //lparams.addRule(RelativeLayout.RIGHT_OF, id)
			for (int i=0; i < countAnchorRule; i++) {  
				lparams.addRule(lparamsAnchorRule[i], idAnchor);		
		    }
			
		} 
		for (int j=0; j < countParentRule; j++) {  
			lparams.addRule(lparamsParentRule[j]);		
	    }
		//
		setLayoutParams(lparams);
}

public void SetTextSize(float size) {
	   mTextSize = size;	
	   String t = this.getText().toString();   
	   this.setTextSize(mTextSizeTypedValue, mTextSize);
	   this.setText(t);
}     


//TTextSizeTyped =(tsDefault, tsUnitPixels, tsUnitDIP, tsUnitInches, tsUnitMillimeters, tsUnitPoints, tsUnitScaledPixel);
public void SetFontSizeUnit(int _unit) {	
	   switch (_unit) {
	      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; //default
	      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break; //default
	      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; //default
	      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; //default
	      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; //default
	      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	   }   
		String t = this.getText().toString();
		this.setTextSize(mTextSizeTypedValue, mTextSize);
		this.setText(t);
}

}

//-------------------------------------------------------------------------
//ProgressBar
//      Event -
//
//Ref.
//  Style : http://developer.android.com/reference/android/R.attr.html
//            android.R.attr
//            ------------------------------------------------
//            progressBarStyle              0x01010077 Default
//            progressBarStyleHorizontal    0x01010078
//            progressBarStyleInverse       0x01010287
//            progressBarStyleLarge         0x0101007a
//            progressBarStyleLargeInverse  0x01010289
//            progressBarStyleSmall         0x01010079
//            progressBarStyleSmallTitle    0x0101020f
//            progressDrawable              0x0101013c
//
//-------------------------------------------------------------------------

class jProgressBar extends ProgressBar {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private LayoutParams    lparams;           // layout XYWH

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

// Constructor
public  jProgressBar(android.content.Context context,
                  Controls ctrls,long pasobj,int style ) {
//super(context,null,progressBarStyleHorizontal);
super(context,null,style);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new LayoutParams(100,100);     // W,H
lparams.setMargins        ( 50, 50,0,0); // L,T,
setMax(100);
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
parent = viewgroup;
viewgroup.addView(this,lparams);
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
lparams = null;
}

//by jmpessoa
public void setLParamWidth(int w) {
lpW = w;
}

public void setLParamHeight(int h) {
lpH = h;
}

public void addLParamsAnchorRule(int rule) {
lparamsAnchorRule[countAnchorRule] = rule;
countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		//lparams.addRule(RelativeLayout.BELOW, id); 
		//lparams.addRule(RelativeLayout.ALIGN_BASELINE, id)
	    //lparams.addRule(RelativeLayout.LEFT_OF, id); //lparams.addRule(RelativeLayout.RIGHT_OF, id)
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }
		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
  }
	//
	setLayoutParams(lparams);
}

}

//-------------------------------------------------------------------------
//ImageView
//Event : pOnClick
//-------------------------------------------------------------------------

class jImageView extends ImageView {
// Pascal Interface
private long           PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Cass for Event
//
private ViewGroup       parent   = null;   // parent view
private LayoutParams    lparams;           // layout XYWH
private OnClickListener onClickListener;   //
public  Bitmap          bmp      = null;   //

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT; //h
int lpW = RelativeLayout.LayoutParams.WRAP_CONTENT; //w
int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

Matrix mMatrix;	

//by jmpessoa
public void setMarginRight(int x) {
	marginRight = x;
}

//by jmpessoa
public void setMarginBottom(int y) {
	marginBottom = y;
}
// Constructor
public  jImageView(android.content.Context context,
                Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new LayoutParams(100,100);
lparams.setMargins( 50, 50,0,0);
//
//setAdjustViewBounds(false);
setScaleType(ImageView.ScaleType.CENTER);
mMatrix = new Matrix();
// Init Event
onClickListener = new OnClickListener() {
  public  void onClick(View view) {
    controls.pOnClick(PasObj,Const.Click_Default);
  }
};
setOnClickListener(onClickListener);
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
   parent = viewgroup;
   viewgroup.addView(this,lparams);
}

//Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
   if (bmp    != null) { bmp.recycle(); }
   bmp     = null;
   setImageBitmap(null);
   lparams = null;
   setImageResource(0); //android.R.color.transparent;
   onClickListener = null;
   setOnClickListener(null);
   mMatrix = null;
}

//by jmpessoa
public void setBitmapImage(Bitmap bm) {
	//if (bmp    != null) { bmp.recycle(); }
	bmp = bm;
	this.setImageBitmap(bm);
}

public  void setImage(String fullPath) {
	  //if (bmp != null)        { bmp.recycle(); }
	  if (fullPath.equals("null")) { this.setImageBitmap(null); return; };
	  bmp = BitmapFactory.decodeFile( fullPath );
	  this.setImageBitmap(bmp);
}

//by jmpessoa
public int GetDrawableResourceId(String _resName) {
	  try {
	     Class<?> res = R.drawable.class;
	     Field field = res.getField(_resName);  //"drawableName"
	     int drawableId = field.getInt(null);
	     return drawableId;
	  }
	  catch (Exception e) {
	     //Log.e("jImageView", "Failure to get drawable id.", e);
	     return 0;
	  }
}

//by jmpessoa
public Drawable GetDrawableResourceById(int _resID) {
	return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
}
        
public void SetImageByResIdentifier(String _imageResIdentifier) {
	Drawable d = GetDrawableResourceById(GetDrawableResourceId(_imageResIdentifier));
	bmp = ((BitmapDrawable)d).getBitmap();
	this.setImageDrawable(d);
}

//by jmpessoa
public void setLParamWidth(int w) {
  lpW = w;
}

public void setLParamHeight(int h) {
  lpH = h;
}

//by jmpessoa
public int getLParamHeight() {	
  return  this.getHeight();
  
}  

//by jmpessoa
public int getLParamWidth() {
  return this.getWidth();  
}

//by jmpessoa
public int GetBitmapHeight() {		
  if (bmp != null) {
     return this.bmp.getHeight();   
  } else return 0;
}  

//by jmpessoa
public int GetBitmapWidth() {
  if (bmp != null) {
	 return this.bmp.getWidth();  
  } else return 0;
}

public void addLParamsAnchorRule(int rule) {
  lparamsAnchorRule[countAnchorRule] = rule;
  countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
    }
	//
	setLayoutParams(lparams);
}


/*
 * TScaleType = (scaleCenter, scaleCenterCrop, scaleCenterInside, scaleFitCenter,
                scaleFitEnd, scaleFitStart, scaleFitXY, scaleMatrix);
  ref. http://www.peachpit.com/articles/article.aspx?p=1846580&seqNum=2
       hint: If you are creating a photo-viewing application, 
             you will probably want to use the center or fitCenter scale types.                  
 */
public void SetScaleType(int _scaleType) { //TODO! 	
	switch(_scaleType) {
  	   case 0: setScaleType(ImageView.ScaleType.CENTER); break;
  	   case 1: setScaleType(ImageView.ScaleType.CENTER_CROP); break;
  	   case 2: setScaleType(ImageView.ScaleType.CENTER_INSIDE); break;
  	   case 3: setScaleType(ImageView.ScaleType.FIT_CENTER); break;
  	   case 4: setScaleType(ImageView.ScaleType.FIT_END); break;
  	   case 5: setScaleType(ImageView.ScaleType.FIT_START); break;
  	   case 6: setScaleType(ImageView.ScaleType.FIT_XY); break;
  	   case 7: setScaleType(ImageView.ScaleType.MATRIX); break;
	}
}

public void SetImageMatrixScale(float _scaleX, float _scaleY ) {        
    if ( this.getScaleType() != ImageView.ScaleType.MATRIX)  this.setScaleType(ImageView.ScaleType.MATRIX);        
    //Log.i("scaleX=" + _scaleX, "    scaleY= " + _scaleY);
    mMatrix.setScale(_scaleX, _scaleY);        
    //mMatrix.postScale(_scaleX, _scaleX);
    this.setImageMatrix(mMatrix);
}

public Bitmap GetBitmapImage() {		
   return bmp; 	
}


public void SetImageFromIntentResult(Intent _intentData) {						
	Uri selectedImage = _intentData.getData();
	String[] filePathColumn = { MediaStore.Images.Media.DATA };	 
    Cursor cursor = controls.activity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
    cursor.moveToFirst();
    int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
    String picturePath = cursor.getString(columnIndex);
    cursor.close();
    bmp = BitmapFactory.decodeFile(picturePath);
    this.setImageBitmap(bmp);        
}

public void SetImageThumbnailFromCamera(Intent _intentData) {
	Bundle extras = _intentData.getExtras();
    bmp = (Bitmap) extras.get("data");
    this.setImageBitmap(bmp);    
}


//TODO Pascal
public void SetImageFromURI(Uri _uri) {	
	InputStream imageStream = null;
	try {
		imageStream = controls.activity.getContentResolver().openInputStream(_uri);
	} catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	bmp = BitmapFactory.decodeStream(imageStream);	        
  this.setImageBitmap(bmp);
}

public void SetImageFromByteArray(byte[] _image) {
	bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length);
	this.setImageBitmap(bmp);
}


}
 

//-------------------------------------------------------------------------
//ListView
//Event :
//
//
//-------------------------------------------------------------------------
//by jmpessoa : custom row!
//by jmpessoa : custom row!

class jListItemRow{
	String label = "";
	int    id; 
	int widget = 0;
	View jWidget; //needed to fix  the RadioButton Group default behavior: thanks to Leledumbo.
	String widgetText;
	String delimiter;
	boolean checked;
	int textSize;
	int textColor;
	int textDecorated;
	int textSizeDecorated;
	int itemLayout;
	int textAlign;
	Context ctx;
	Bitmap bmp;
	public  jListItemRow(Context context) {
		ctx = context;
		label = "";
	}
}

//http://stackoverflow.com/questions/7361135/how-to-change-color-and-font-on-listview
class jArrayAdapter extends ArrayAdapter {
//
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event	
private Context       ctx;
private int           id;
private List <jListItemRow> items ;
private ArrayAdapter thisAdapter;
private boolean mDispatchOnDrawItemTextColor;
private boolean mDispatchOnDrawItemBitmap;

boolean mChangeFontSizeByComplexUnitPixel;
int mTextSizeTypedValue;

public  jArrayAdapter(Context context, Controls ctrls,long pasobj, int textViewResourceId, 
		               List<jListItemRow> list) {
   super(context, textViewResourceId, list);
   PasObj = pasobj;
   controls = ctrls;
   ctx   = context;
   id    = textViewResourceId;
   items = list;
   thisAdapter = this;
   mDispatchOnDrawItemTextColor = true;
   mDispatchOnDrawItemBitmap = true;
   mChangeFontSizeByComplexUnitPixel = true;
   mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
		   
}

public void SetChangeFontSizeByComplexUnitPixel(boolean _value) {
    mChangeFontSizeByComplexUnitPixel = _value;
}

public void SetFontSizeUnit(int _unit) {	
	   switch (_unit) {
	      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; 
	      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
	      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; 
	      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; 
	      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; 
	      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 	      
        }   
		//String t = this.getText().toString();
		//this.setTextSize(mTextSizeTypedValue, mTextSize);
		//this.setText(t);
}

public void SetDispatchOnDrawItemTextColor(boolean _value) {
	mDispatchOnDrawItemTextColor = _value;
}

public void SetDispatchOnDrawItemBitmap(boolean _value) {
	mDispatchOnDrawItemBitmap = _value;
}

@Override
public  View getView(int position, View v, ViewGroup parent) {
 	
 //new code: by jmpessoa: custom row!	
 if (position >= 0 && ( !items.get(position).label.equals("") ) ) {
		  
   LinearLayout listLayout = new LinearLayout(ctx);
   
   listLayout.setOrientation(LinearLayout.HORIZONTAL);  
   AbsListView.LayoutParams lparam =new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 
		                                                         AbsListView.LayoutParams.WRAP_CONTENT); //w, h
   listLayout.setLayoutParams(lparam);
   
   LayoutParams imgParam = null;      
   ImageView itemImage = null;
   	
   if (items.get(position).bmp !=  null) {  
	   imgParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
	   itemImage = new ImageView(ctx); 
	   itemImage.setId(position);
	   itemImage.setImageBitmap(items.get(position).bmp);  
	   itemImage.setFocusable(false);
	   itemImage.setFocusableInTouchMode(false);
	   itemImage.setPadding(6, 6, 0, 0);
	   itemImage.setOnClickListener(getOnCheckItem(itemImage, position));       
   }
   
   
   if (mDispatchOnDrawItemBitmap)  {        	
       Bitmap  imageBmp = (Bitmap)controls.pOnListViewDrawItemBitmap(PasObj, (int)position , items.get(position).label);
   	   if (imageBmp != null) {        		      	        	      
		  imgParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
		  itemImage = new ImageView(ctx); 
		  itemImage.setId(position);
		  itemImage.setImageBitmap(imageBmp);  
		  itemImage.setFocusable(false);
		  itemImage.setFocusableInTouchMode(false);
		  itemImage.setPadding(6, 6, 0, 0);
		  itemImage.setOnClickListener(getOnCheckItem(itemImage, position));   	      
     	}
   	    else {
   		   if (items.get(position).bmp !=  null) {       			
   		  	   imgParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
   		  	   itemImage = new ImageView(ctx); 
   		  	   itemImage.setId(position);
   		  	   itemImage.setImageBitmap(items.get(position).bmp);  
   		  	   itemImage.setFocusable(false);
   		  	   itemImage.setFocusableInTouchMode(false);
   		  	   itemImage.setPadding(6, 6, 0, 0);
   		  	   itemImage.setOnClickListener(getOnCheckItem(itemImage, position));
   		    }  
        }	        	
   } 
   else {
   	 if (items.get(position).bmp !=  null) {	
  	   imgParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
  	   itemImage = new ImageView(ctx); 
  	   itemImage.setId(position);
  	   itemImage.setImageBitmap(items.get(position).bmp);  
  	   itemImage.setFocusable(false);
  	   itemImage.setFocusableInTouchMode(false);
  	   itemImage.setPadding(6, 6, 0, 0);
  	   itemImage.setOnClickListener(getOnCheckItem(itemImage, position));
   	  }   
    }   
   
   
   RelativeLayout itemLayout = new RelativeLayout(ctx);
       
   String line = items.get(position).label;   
   String[] lines = line.split(Pattern.quote(items.get(position).delimiter));
   
   TextView[] itemText = new TextView[lines.length];
   
   LinearLayout txtLayout = new LinearLayout(ctx);
   txtLayout.setOrientation(LinearLayout.VERTICAL);
     
   int faceTitle;
   int faceBody;
   switch (items.get(position).textDecorated) {
     case 0:  faceTitle = Typeface.NORMAL; faceBody = Typeface.NORMAL; break;
     case 1:  faceTitle = Typeface.NORMAL; faceBody = Typeface.ITALIC; break;
     case 2:  faceTitle = Typeface.NORMAL; faceBody = Typeface.BOLD; break;
     
     case 3:  faceTitle = Typeface.BOLD; faceBody = Typeface.BOLD; break;
     case 4:  faceTitle = Typeface.BOLD;   faceBody = Typeface.NORMAL; break;
     case 5:  faceTitle = Typeface.BOLD;   faceBody = Typeface.ITALIC; break;
     
     case 6:  faceTitle = Typeface.ITALIC; faceBody = Typeface.ITALIC; break;
     case 7:  faceTitle = Typeface.ITALIC;   faceBody = Typeface.NORMAL; break;
     case 8:  faceTitle = Typeface.ITALIC;   faceBody = Typeface.ITALIC; break;
     
     default: faceTitle = Typeface.NORMAL; faceBody = Typeface.NORMAL; break;
   }

   LayoutParams txtParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
  
   //txtParam.alignWithParent = true;
        
   for (int i=0; i < lines.length; i++) {
	   
	   TextView textViewnew = new TextView(ctx);	   
	   float auxf = textViewnew.getTextSize();	   	  	  
	   itemText[i] = textViewnew;
	   	   
	   if (i == 0) {
		    if (items.get(position).textSize != 0){
		    	auxf = items.get(position).textSize;
		    	
		    	if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP) 
			       itemText[i].setTextSize(mTextSizeTypedValue, auxf);
		    	else
		    		itemText[i].setTextSize(auxf);
		    	
		    }
		    itemText[i].setPadding(10, 15, 10, 15);
		    itemText[i].setTypeface(null,faceTitle);
		    
		}
		else{			
		   itemText[i].setTypeface(null,faceBody);
		   itemText[i].setPadding(10, 0, 10, 15);
		   
		   if (items.get(position).textSizeDecorated == 1) {
			   
		       if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP) 				    
			       itemText[i].setTextSize(mTextSizeTypedValue, auxf - 5*i);  // sdDeCecreasing
			   else 
				   itemText[i].setTextSize(auxf - 5*i);  // sdDeCecreasing
		   }
		   
		   if (items.get(position).textSizeDecorated == 2) {
			   
			   if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
			     itemText[i].setTextSize(mTextSizeTypedValue, auxf + 5*i);  // sdInCecreasing
			   else
				   itemText[i].setTextSize(auxf + 5*i);  // sdInCecreasing  
			     
		   }
		}
	   
	    itemText[i].setText(lines[i]);
	    	    	    
        if (mDispatchOnDrawItemTextColor)  {            	             	
          	 int drawItemTxtColor = controls.pOnListViewDrawItemCaptionColor(PasObj, (int)position, lines[i]);
          	 if (drawItemTxtColor != 0) {
          		itemText[i].setTextColor(drawItemTxtColor); 
          	 }
          	 else {
          		 if (items.get(position).textColor != 0) {	
          			itemText[i].setTextColor(items.get(position).textColor);
                 }	 
          	 }
          } 
          else {
          	if (items.get(position).textColor != 0) {	
          		itemText[i].setTextColor(items.get(position).textColor);
          	}   
          }
	    
	      txtLayout.addView(itemText[i]);   
   }
   
   View itemWidget = null;
   
   switch(items.get(position).widget) {
     case 1:  itemWidget = new CheckBox(ctx);  ((CheckBox)itemWidget).setText(items.get(position).widgetText);                                                    
                           ((CheckBox)itemWidget).setText(items.get(position).widgetText);                           
                           items.get(position).jWidget = itemWidget; //                           
                           ((CheckBox)itemWidget).setChecked(items.get(position).checked);                                                      
     break;
     case 2:  itemWidget = new RadioButton(ctx); 
                           ((RadioButton)itemWidget).setText(items.get(position).widgetText);                           
                           items.get(position).jWidget = itemWidget; //                           
                           ((RadioButton)itemWidget).setChecked(items.get(position).checked);                          
     break;
     case 3:  itemWidget = new Button(ctx);  ((Button)itemWidget).setText(items.get(position).widgetText);
                           items.get(position).jWidget = itemWidget;
     break;
     case 4:  itemWidget = new TextView(ctx); 
                           ((TextView)itemWidget).setText(" "+items.get(position).widgetText+" ");
                           items.get(position).jWidget = itemWidget;
     break;
     //default: ;
   }
           
   LayoutParams widgetParam = null;

   if (itemWidget != null) {
	  widgetParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h	   
	  itemWidget.setFocusable(false);
      itemWidget.setFocusableInTouchMode(false);
      itemWidget.setOnClickListener(getOnCheckItem(itemWidget, position));       
   }
                          
   if (items.get(position).itemLayout == 0) {	//default...   
	   if (itemImage != null) {
		  listLayout.addView(itemImage, imgParam);
	   }
	   
	   txtParam.leftMargin = 10;
	   txtParam.rightMargin = 10;
	   
	   switch(items.get(position).textAlign) {
	     case 0: txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);  break;
	     case 1: txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);  break;
	     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT); break;
	     default: ;
	   }
	   
	   itemLayout.addView(txtLayout, txtParam);
	   
	   if (itemWidget != null) {
		  widgetParam.rightMargin = 10;
		  if (items.get(position).textAlign != 2) {
		    widgetParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
		  }else {widgetParam.addRule(RelativeLayout.CENTER_HORIZONTAL);}
		  itemLayout.addView(itemWidget, widgetParam);			  			  			  		  
	   }	   
	   
   } else {
	   
	   if (itemWidget != null) {
		  listLayout.addView(itemWidget, widgetParam);
	   }   
	   
	   txtParam.leftMargin = 10;
	   txtParam.rightMargin = 10;
	   switch(items.get(position).textAlign) {
	     case 0: txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);break;
	     case 1: txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL); break;
	     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT); break;
	     default: ;
	   }
	   
	   itemLayout.addView(txtLayout, txtParam);
	   
	   if (itemImage != null) {
		  imgParam.rightMargin = 10;
		  
		  if (items.get(position).textAlign != 2) {
		  imgParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);}
		  else{imgParam.addRule(RelativeLayout.CENTER_HORIZONTAL);}
		  
		  itemLayout.addView(itemImage, imgParam);
	   }	   	   	   
   }
   
   listLayout.addView(itemLayout);
   return listLayout;   
 } else return v;
 
}
  //by jmpessoa 
View.OnClickListener getOnCheckItem(final View cb, final int position) { 
    return new View.OnClickListener() { 
	            public void onClick(View v) {
	               if (cb.getClass().getName().equals("android.widget.ImageView")) {
	            	   controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
	               }	 
	               else if (cb.getClass().getName().equals("android.widget.CheckBox")) {	 
	                  items.get(position).checked = ((CheckBox)cb).isChecked();	                 	                  
	                  controls.pOnClickWidgetItem(PasObj, position, ((CheckBox)cb).isChecked());
	               }
	               else if (cb.getClass().getName().equals("android.widget.RadioButton")) {
	            	   
	            	     //new code: fix to RadioButton Group  default behavior: thanks to Leledumbo.
	            	      boolean doCheck = ((RadioButton)cb).isChecked(); //new code
	            	      
	            	      for (int i=0; i < items.size(); i++) {
	            	    	  ((RadioButton)items.get(i).jWidget).setChecked(false);
	            	    	  items.get(i).checked = false;	 	            	    	 
	            	    	  thisAdapter.notifyDataSetChanged(); //fix 16-febr-2015 
	            	      }	            	
	            	      
		                  items.get(position).checked = doCheck;
		                   
		                  ((RadioButton)items.get(position).jWidget).setChecked(doCheck);
		                  
		                  controls.pOnClickWidgetItem(PasObj, position, doCheck);
		                  
		           }
	               else if (cb.getClass().getName().equals("android.widget.Button")) { //button	            	      	            	        
			             controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked); 		                  
		           }
	               else if (cb.getClass().getName().equals("android.widget.TextView")) { //textview  
			             controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked); 		                  
		           }	               
                } 
	}; 
}

}

//-------------------
// jListView
//------------------------

class jListView extends ListView {
// Java-Pascal Interface
private long            PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event

private Bitmap          genericBmp;
private int             widgetItem;
private String          widgetText;
private int             textColor; 
private int             textSize;

//by Renabor
private float mDownX = -1;
private float mDownY = -1;
private final float SCROLL_THRESHOLD = 10;
private boolean isOnClick;
private boolean canClick;

int textDecorated;
int itemLayout;
int textSizeDecorated;
int textAlign;

String delimiter;

private ViewGroup       parent    = null;       // parent view
private RelativeLayout.LayoutParams lparams;  // Control xywh

private ArrayList<jListItemRow>    alist;

private jArrayAdapter        aadapter;

private OnItemClickListener  onItemClickListener;
private OnTouchListener onTouchListener;

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

boolean highLightSelectedItem = false;
int highLightColor = Color.RED;

int lastSelectedItem = -1;
String selectedItemCaption = "";

//Constructor
public  jListView(android.content.Context context,
              Controls ctrls,long pasobj, int widget, String widgetTxt,  Bitmap bmp,
              int txtDecorated,
              int itemLay,
              int txtSizeDecorated,  int txtAlign) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;

textColor = 0; //dummy: default
textSize  = 0; //dummy: default       

widgetItem = widget;
widgetText = widgetTxt; 
genericBmp = bmp;
textDecorated = txtDecorated;
itemLayout =itemLay;
textSizeDecorated = txtSizeDecorated;
textAlign = txtAlign;

// Init Class
lparams = new RelativeLayout.LayoutParams (100,100);
lparams.setMargins (50,50,0,0);
setBackgroundColor (0x00000000);
setCacheColorHint  (0);

alist = new ArrayList<jListItemRow>();
//simple_list_item_1
aadapter = new jArrayAdapter(context, controls, PasObj, android.R.layout.simple_list_item_1, alist);

setAdapter(aadapter);

setChoiceMode(ListView.CHOICE_MODE_SINGLE);

//Init Event

// renabor gesture
onTouchListener = new OnTouchListener() {	
	@Override
	public boolean onTouch(View v, MotionEvent event) {
		int action = event.getAction() & MotionEvent.ACTION_MASK;
		switch (action) {
			case MotionEvent.ACTION_DOWN:
				canClick = false;
				// Log.i("ACTION", "DOWN");
				mDownX = event.getX();
				mDownY = event.getY();
				isOnClick = true; // blocco la propagazione
				break;
			case MotionEvent.ACTION_CANCEL:
			case MotionEvent.ACTION_UP:
				if (isOnClick) {
					// Log.i("ACTION", "UP");
					canClick = true;
				} else { Log.i("ACTION","UP NOT PROCESSED"); }
				//return false; // passa oltre, ma potrebbe diventare true
				//mDownX = -1;
				return false;
				
    
			case MotionEvent.ACTION_MOVE:
				if (isOnClick && (Math.abs(mDownX - event.getX()) > SCROLL_THRESHOLD || Math.abs(mDownY - event.getY()) > SCROLL_THRESHOLD)) {
					// Log.i("ACTION", "MOVE");
					isOnClick = false;
				};			
				return false;					
		};
	return false;
	};
};

setOnTouchListener(onTouchListener);


//fixed! thanks to @renabor
onItemClickListener = new OnItemClickListener() {@Override
	public void onItemClick(AdapterView <? > parent, View v, int position, long id) {
	  if (canClick) { 
	    	lastSelectedItem = (int) position;
			if (!isEmpty(alist)) { // this test is necessary !  //  <----- thanks to @renabor
				if (highLightSelectedItem) {
					if (lastSelectedItem > -1) {
						DoHighlight(lastSelectedItem, textColor);
					}
					DoHighlight((int) id, highLightColor);
				}
				if (alist.get((int) id).widget == 2  ) { //radio fix 16-febr-2015
					for (int i = 0; i < alist.size(); i++) {
						alist.get(i).checked = false;
					}
					alist.get((int) id).checked = true;
					aadapter.notifyDataSetChanged();
				}
				controls.pOnClickCaptionItem(PasObj, (int) id, alist.get((int) id).label);
			} else {
				controls.pOnClickCaptionItem(PasObj, lastSelectedItem, ""); // avoid passing possibly undefined Caption
			}
		}
	} 
};
setOnItemClickListener(onItemClickListener);

this.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {@Override
	public boolean onItemLongClick(AdapterView <?> parent, View view, int position, long id) {
		lastSelectedItem = (int)position;
		if (canClick) {
			if (!isEmpty(alist)) {  //  <----- thanks to @renabor
				selectedItemCaption = alist.get((int) id).label;
				controls.pOnListViewLongClickCaptionItem(PasObj, (int)id, alist.get((int)id).label);
				return false;
				};
		};
		return false;
	}
});

}

//thanks to @renabor
public static boolean isEmpty(ArrayList<?> coll) {
	return (coll == null || coll.isEmpty());
}

//by jmpessoa
public boolean isItemChecked(int index) {
  return alist.get(index).checked;	  
}

//by jmpessoa
public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
   parent = viewgroup;
   viewgroup.addView(this,lparams);
}

public  void setTextColor( int textcolor) {
   this.textColor =textcolor;
}

public void setTextSize (int textsize) {
   this.textSize = textsize;
}

// LORDMAN - 2013-08-07
public void setItemPosition ( int position, int y ) {
  setSelectionFromTop(position, y);
}

//
public  void clear() {
  alist.clear();
  aadapter.notifyDataSetChanged();
}

//
public  void delete( int index ) {
  alist.remove( index );
  aadapter.notifyDataSetChanged();
}

public  String  getItemText(int index) {
  return alist.get(index).label;
  //aadapter.notifyDataSetChanged();
}


public int GetSize() {
  return alist.size();
  //aadapter.notifyDataSetChanged();
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
  if (parent != null) { parent.removeView(this); }
  alist.clear();
  genericBmp = null;
  alist    = null;
  setAdapter(null);
 
  aadapter = null;
  lparams  = null;
  setOnItemClickListener(null);
  setOnItemLongClickListener(null); //thanks @renabor
}

//by jmpessoa
public void setLParamWidth(int w) {
  lpW = w;
}

public void setLParamHeight(int h) {
  lpH = h;
}

//by jmpessoa
public void addLParamsAnchorRule(int rule) {
  lparamsAnchorRule[countAnchorRule] = rule;
  countAnchorRule = countAnchorRule + 1;
}

//by jmpessoa
public void addLParamsParentRule(int rule) {
  lparamsParentRule[countParentRule] = rule;
  countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		//lparams.addRule(RelativeLayout.BELOW, id); 
		//lparams.addRule(RelativeLayout.ALIGN_BASELINE, id)
	    //lparams.addRule(RelativeLayout.LEFT_OF, id); //lparams.addRule(RelativeLayout.RIGHT_OF, id)
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }
		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
    }
    setLayoutParams(lparams);
}

//by jmpessoa
public  void add2(String item, String delimiter) {
jListItemRow info = new jListItemRow(controls.activity);
info.label = item;
info.delimiter=  delimiter;
info.id = alist.size();
info.checked = false;
info.widget = widgetItem;
info.widgetText= widgetText;
info.checked = false;
info.textSize= textSize;
info.textColor= textColor;
info.bmp = genericBmp;

info.textDecorated = textDecorated;
info.itemLayout =itemLayout;
info.textSizeDecorated = textSizeDecorated;
info.textAlign = textAlign;

alist.add(info);
aadapter.notifyDataSetChanged();
}


//by jmpessoa
public  void add22(String item, String delimiter, Bitmap bm) {
jListItemRow info = new jListItemRow(controls.activity);
info.label = item;
info.delimiter=  delimiter;
info.id = alist.size();
info.checked = false;
info.widget = widgetItem;
info.widgetText= widgetText;
info.checked = false;
info.textSize= textSize;
info.textColor= textColor;
info.bmp = bm;

info.textDecorated = textDecorated;
info.itemLayout =itemLayout;
info.textSizeDecorated = textSizeDecorated;
info.textAlign = textAlign;

alist.add(info);
aadapter.notifyDataSetChanged();
}

//by jmpessoa
public  void add3(String item, String delimiter, int fontColor, int fontSize, int widgetItem, String wgtText, Bitmap img) {
	  jListItemRow info = new jListItemRow(controls.activity);
	  info.label = item;
	  info.id = alist.size();
	  info.checked = false;
	  info.widget = widgetItem;
	  info.widgetText= wgtText;
	  info.checked = false;
	  info.delimiter=  delimiter;
	  info.textSize= fontSize;
	  info.textColor= fontColor;	
	  info.bmp = img;

	  info.textDecorated = textDecorated;
	  info.itemLayout =itemLayout;
	  info.textSizeDecorated = textSizeDecorated;
	  info.textAlign = textAlign;

	  alist.add(info);
	  aadapter.notifyDataSetChanged();
}

//by jmpessoa 
public  void add4(String item, String delimiter, int fontColor, int fontSize, int widgetItem, String wgtText) {
	  jListItemRow info = new jListItemRow(controls.activity);
	  info.label = item;
	  info.id = alist.size();
	  info.checked = false;
	  info.widget = widgetItem;
	  info.widgetText= wgtText;
	  info.checked = false;
	  info.delimiter=  delimiter;
	  info.textSize= fontSize;
	  info.textColor= fontColor;	
	  info.bmp = null;

	  info.textDecorated = textDecorated;
	  info.itemLayout =itemLayout;
	  info.textSizeDecorated = textSizeDecorated;
	  info.textAlign = textAlign;
	  
	  alist.add(info);
	  aadapter.notifyDataSetChanged();
}

//by jmpessoa
public void setTextColor2(int value, int index) {
	if (value != 0) {
    	alist.get(index).textColor = value;
	    aadapter.notifyDataSetChanged();
	}
}

//by jmpessoa
public  void setTextSize2(int textsize, int index) {
	if (textsize != 0) { 
	  alist.get(index).textSize = textsize;
	  aadapter.notifyDataSetChanged();
	}
}

//by jmpessoa
public  void setImageItem(Bitmap bm, int index) {
	alist.get(index).bmp = bm;
	aadapter.notifyDataSetChanged();
}


//by jmpessoa
private int GetDrawableResourceId(String _resName) {
	  try {
	     Class<?> res = R.drawable.class;
	     Field field = res.getField(_resName);  //"drawableName"
	     int drawableId = field.getInt(null);
	     return drawableId;
	  }
	  catch (Exception e) {
	     Log.e("ListView", "Failure to get drawable id.", e);
	     return 0;
	  }
}

//by jmpessoa
private Drawable GetDrawableResourceById(int _resID) {
	return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
}
//by jmpessoa
public  void setImageItem(String imgResIdentifier, int index) {	   // ..res/drawable
	Drawable d = GetDrawableResourceById(GetDrawableResourceId(imgResIdentifier));        	
	alist.get(index).bmp = ((BitmapDrawable)d).getBitmap();
	aadapter.notifyDataSetChanged();	
}

//by jmpessoa
public void setTextDecorated(int value, int index){
	alist.get(index).textDecorated = value;
	aadapter.notifyDataSetChanged();
}

public void setTextSizeDecorated(int value, int index) {
	alist.get(index).textSizeDecorated = value;
	aadapter.notifyDataSetChanged();
}

//by jmpessoa
public void setItemLayout(int value, int index){
	alist.get(index).itemLayout = value; //0: image-text-widget; 1 = widget-text-image
	aadapter.notifyDataSetChanged();
}

//by jmpessoa
public void setWidgetItem(int value, int index){
	alist.get(index).widget = value;
	aadapter.notifyDataSetChanged();
}

//by jmpessoa
public void setTextAlign(int value, int index){
	alist.get(index).textAlign = value;
	aadapter.notifyDataSetChanged();
}


//by jmpessoa
public void setWidgetItem(int value, String txt, int index){
	alist.get(index).widget = value;
	alist.get(index).widgetText = txt;
	aadapter.notifyDataSetChanged();
}

//by jmpessoa
public void setWidgetText(String value, int index){
	alist.get(index).widgetText = value;
	aadapter.notifyDataSetChanged();
}

//by jmpessoa
public void setWidgetCheck(boolean value, int index){
	alist.get(index).checked = value;	
	aadapter.notifyDataSetChanged();
}

private void DoHighlight(int position, int _color) {
   	alist.get(position).textColor = _color;
    aadapter.notifyDataSetChanged();		
}

public void SetHighLightSelectedItem(boolean _value)  {
	highLightSelectedItem = _value;
}

public void SetHighLightSelectedItemColor(int _color)  {
	highLightColor = _color;
}

public int GetItemIndex() { 
  return lastSelectedItem;
}

public String GetItemCaption() {
 return selectedItemCaption;
}


public void DispatchOnDrawItemTextColor(boolean _value) {
	aadapter.SetDispatchOnDrawItemTextColor(_value);
}

public void DispatchOnDrawItemBitmap(boolean _value) {
	aadapter.SetDispatchOnDrawItemBitmap(_value);
}

public void SetChangeFontSizeByComplexUnitPixel(boolean _value) {    
    aadapter.SetChangeFontSizeByComplexUnitPixel(_value);
}

public void SetFontSizeUnit(int _unit) {    
    aadapter.SetFontSizeUnit(_unit);
}


}
//-------------------------------------------------------------------------
//ScrollView
//      Event pOnClick
//-------------------------------------------------------------------------

class jScrollView extends ScrollView {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private RelativeLayout.LayoutParams lparams;           // layout XYWH

private RelativeLayout  scrollview;        // Scroll View
private LayoutParams    scrollxywh;        // Scroll Area

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

// Constructor
public  jScrollView(android.content.Context context,
                 Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new RelativeLayout.LayoutParams(100,100);     // W,H
lparams.setMargins(50,50,0,0); // L,T,
//
//this.setBackgroundColor (0xFF0000FF);
// Scroll Size
scrollview = new RelativeLayout(context);
//scrollview.setBackgroundColor (0xFFFF0000);
scrollxywh = new LayoutParams(100,100);
scrollxywh.setMargins(0,0,0,0);
scrollview.setLayoutParams(scrollxywh);
this.addView(scrollview);
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	
//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
   parent = viewgroup;
   viewgroup.addView(this,lparams);
}

public  void setScrollSize(int size) {
scrollxywh.height = size;
scrollxywh.width  = lparams.width;
scrollview.setLayoutParams(scrollxywh);
}

public  RelativeLayout getView() {
  return (scrollview);
}

public  void setEnabled(boolean enabled) {
 //setEnabled(enabled);
 scrollview.setEnabled  (enabled);
 scrollview.setFocusable(enabled);
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
scrollxywh = null;
this.removeView(scrollview);
scrollview = null;
lparams = null;
}

@Override
public  boolean onInterceptTouchEvent(MotionEvent event) {
 if (!isEnabled()) { return(false); }
 else return super.onInterceptTouchEvent(event);
}

//by jmpessoa
public void setLParamWidth(int w) {
  lpW = w;
}

public void setLParamHeight(int h) {
  lpH = h;
}

public void addLParamsAnchorRule(int rule) {
  lparamsAnchorRule[countAnchorRule] = rule;
  countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }
		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
  }
	//
	setLayoutParams(lparams);
	//
	scrollxywh.width = lpW;
	scrollview.setLayoutParams(scrollxywh);
	
}

}

//-----------------------------------------
//----- jPanel by jmpessoa
//-----------------------------------------
class jPanel extends RelativeLayout {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private ViewGroup       parent   = null;

	private RelativeLayout.LayoutParams lparams;           // layout XYWH
		
	private int lparamsAnchorRule[] = new int[40]; 
	int countAnchorRule = 0;

	private int lparamsParentRule[] = new int[40]; 
	int countParentRule = 0;
	
	int lpH = RelativeLayout.LayoutParams.MATCH_PARENT;
	int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

	int MarginLeft   = 0;
	int MarginTop    = 0;
	int marginRight  = 0;
	int marginBottom = 0;
	
	boolean mRemovedFromParent = false;
	
    private GestureDetector gDetect;
    private ScaleGestureDetector scaleGestureDetector;
    
    private float mScaleFactor = 1.0f;
    private float MIN_ZOOM = 0.25f;	  
	private float MAX_ZOOM = 4.0f;	 	 
	    	
	//Constructor
	public  jPanel(android.content.Context context, Controls ctrls,long pasobj ) {
	   super(context);	
	   // Connect Pascal I/F
       PasObj   = pasobj;
	   controls = ctrls;
       lparams = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);		
	   //
       gDetect = new GestureDetector(controls.activity, new GestureListener());
       
       scaleGestureDetector = new ScaleGestureDetector(controls.activity, new simpleOnScaleGestureListener());
	}
		
	public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		MarginLeft = left;
		MarginTop = top;
		marginRight = right;
		marginBottom = bottom;
		lpH = h;
		lpW = w;
		lparams.width  = lpW;
		lparams.height = lpH;
	}	
	
	public void setLParamWidth(int w) {
	  lpW = w;
	  lparams.width  = lpW; 
	}

	public void setLParamHeight(int h) {
	  lpH = h;  
	  lparams.height = lpH; 
	}

	public int getLParamHeight() {	
	  return lpH; //getHeight();
	}  

	public int getLParamWidth() {
	 return lpW; //getWidth();
	}

	public void resetLParamsRules() {
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.removeRule(lparamsAnchorRule[i]);		
		}
				
		for (int j=0; j < countParentRule; j++) {  
			lparams.removeRule(lparamsParentRule[j]);		
	    }
		
		countAnchorRule = 0;
	    countParentRule = 0;
	}
	
	public void addLParamsAnchorRule(int rule) {
	  lparamsAnchorRule[countAnchorRule] = rule;
	  countAnchorRule = countAnchorRule + 1;
	}

	public void addLParamsParentRule(int rule) {
	  lparamsParentRule[countParentRule] = rule;
	  countParentRule = countParentRule + 1;
	}

	//by jmpessoa
	public void setLayoutAll(int idAnchor) {		
		lparams.width  = lpW; 
		lparams.height = lpH; 
		lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);		
		if (idAnchor > 0) {    	
			for (int i=0; i < countAnchorRule; i++) {  
				lparams.addRule(lparamsAnchorRule[i], idAnchor);		
		    }			
		} 		
		for (int j=0; j < countParentRule; j++) {  
			lparams.addRule(lparamsParentRule[j]);		
	    }
		setLayoutParams(lparams); 		
 	}
	
	//GetView!-android.widget.RelativeLayout
	public  RelativeLayout getView() {
	   return this;
	}
	
	public  void setParent( android.view.ViewGroup viewgroup ) {
    	if (parent != null) { parent.removeView(this); }
	    parent = viewgroup;
	    parent.addView(this,lparams);
	    mRemovedFromParent=false;
	}	
	
	// Free object except Self, Pascal Code Free the class.
	public  void Free() {
		if (parent != null) { parent.removeView(this); }
		lparams = null;   
	}
	
	public void RemoveParent() {
	   if (!mRemovedFromParent) {
		  	 parent.removeView(this);
		  	mRemovedFromParent = true;
	   } 		   
	}		 
	
    @Override
	public boolean onTouchEvent(MotionEvent event) {
	    return super.onTouchEvent(event);
	}
    
    @Override
	public boolean dispatchTouchEvent(MotionEvent e) {
	        super.dispatchTouchEvent(e);
	        this.gDetect.onTouchEvent(e);
	        this.scaleGestureDetector.onTouchEvent(e);
	        return true;
	}
    
    //ref1. http://code.tutsplus.com/tutorials/android-sdk-detecting-gestures--mobile-21161
    //ref2. http://stackoverflow.com/questions/9313607/simpleongesturelistener-never-goes-in-to-the-onfling-method
    //ref3. http://x-tutorials.blogspot.com.br/2011/11/detect-pinch-zoom-using.html
    private class GestureListener extends GestureDetector.SimpleOnGestureListener {

       private static final int SWIPE_MIN_DISTANCE = 60;
       private static final int SWIPE_THRESHOLD_VELOCITY = 100;
      
 	   @Override
 	   public boolean onDown(MotionEvent event) {
 		  //Log.i("Down", "------------");
 	      return true;
 	   }
 	   
 	   @Override
 	   public boolean onFling(MotionEvent event1, MotionEvent event2, float velocityX, float velocityY) { 
 		   
 	      if(event1.getX() - event2.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
               controls.pOnFlingGestureDetected(PasObj, 0);                //onRightToLeft;
               return  true;
           } else if (event2.getX() - event1.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
        	   controls.pOnFlingGestureDetected(PasObj, 1);//onLeftToRight();
        	   return true;
           }
           if(event1.getY() - event2.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
        	   controls.pOnFlingGestureDetected(PasObj, 2);//onBottomToTop();
        	   return false;
           } else if (event2.getY() - event1.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
        	   controls.pOnFlingGestureDetected(PasObj, 3); //onTopToBottom();
        	   return false;
           } 		   
 		   return false;
 	   }
    }
    
    
   //ref. http://vivin.net/2011/12/04/implementing-pinch-zoom-and-pandrag-in-an-android-view-on-the-canvas/ 
   private class simpleOnScaleGestureListener extends SimpleOnScaleGestureListener {
	  
      @Override
      public boolean onScale(ScaleGestureDetector detector) {         
    	  mScaleFactor *= detector.getScaleFactor();    
    	  mScaleFactor = Math.max(MIN_ZOOM, Math.min(mScaleFactor, MAX_ZOOM));    	    	  
    	// Log.i("tag", "onScale = "+ mScaleFactor);    	 
    	 controls.pOnPinchZoomGestureDetected(PasObj, mScaleFactor, 1); //scalefactor->float    	
         return true;
      }

      @Override
      public boolean onScaleBegin(ScaleGestureDetector detector) {                
    	controls.pOnPinchZoomGestureDetected(PasObj, detector.getScaleFactor(), 0); //scalefactor->float
     	//Log.i("tag", "onScaleBegin");
        return true;
      }

      @Override
      public void onScaleEnd(ScaleGestureDetector detector) {
         controls.pOnPinchZoomGestureDetected(PasObj, detector.getScaleFactor(), 2); //scalefactor->float
     	//Log.i("tag", "onScaleEnd");
        super.onScaleEnd(detector);	  
      }

  }
   
   public void SetMinZoomFactor(float _minZoomFactor) {
        MIN_ZOOM = _minZoomFactor;	
   }
   
   public void SetMaxZoomFactor(float _maxZoomFactor) {
	   MAX_ZOOM = _maxZoomFactor;
   }
   
   public void CenterInParent() {
		lparams.addRule(CENTER_IN_PARENT);  //android.widget.RelativeLayout.CENTER_VERTICAL = 15
		countParentRule = countParentRule+1;	 		
   }
      
   public void MatchParent() {		
		lpH = RelativeLayout.LayoutParams.MATCH_PARENT;
		lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w
		lparams.height = lpH;
		lparams.width =  lpW;			
	}
   
   public void WrapParent() {		
		lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
		lpW = RelativeLayout.LayoutParams.WRAP_CONTENT; //w
		lparams.height = lpH;
		lparams.width =  lpW;			
	}
}



//-------------------------------------------------------------------------
//LORDMAN 2013-09-03
//Horizontal ScrollView
//      Event pOnClick
//-------------------------------------------------------------------------

class jHorizontalScrollView extends HorizontalScrollView {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private RelativeLayout.LayoutParams lparams;           // layout XYWH
private RelativeLayout  scrollview;        // Scroll View
private LayoutParams    scrollxywh;        // Scroll Area

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;


// Constructor
public  jHorizontalScrollView(android.content.Context context,
                 Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new RelativeLayout.LayoutParams(100,100);     // W,H
lparams.setMargins        (50,50,0,0); // L,T,
//
//this.setBackgroundColor (0xFF0000FF);
// Scroll Size
scrollview = new RelativeLayout(context);
//scrollview.setBackgroundColor (0xFFFF0000);

scrollxywh = new LayoutParams(100,100);
scrollxywh.setMargins(0,0,0,0);
scrollview.setLayoutParams(scrollxywh);
this.addView(scrollview);
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
parent = viewgroup;
viewgroup.addView(this,lparams);
}

public  void setScrollSize(int size) {
scrollxywh.height = lparams.height;
scrollxywh.width  = size;
scrollview.setLayoutParams(scrollxywh);
}

public  RelativeLayout getView() {
return ( scrollview );
}

public  void setEnabled(boolean enabled) {
//setEnabled(enabled);
scrollview.setEnabled  (enabled);
scrollview.setFocusable(enabled);
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
scrollxywh = null;
this.removeView(scrollview);
scrollview = null;
lparams = null;
}

@Override
public  boolean onInterceptTouchEvent(MotionEvent event) {
 if (!isEnabled()) { return(false); }
 else return super.onInterceptTouchEvent(event);
}

//by jmpessoa
public void setLParamWidth(int w) {
lpW = w;
}

public void setLParamHeight(int h) {
lpH = h;
}

public void addLParamsAnchorRule(int rule) {
lparamsAnchorRule[countAnchorRule] = rule;
countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		//lparams.addRule(RelativeLayout.BELOW, id); 
		//lparams.addRule(RelativeLayout.ALIGN_BASELINE, id)
	    //lparams.addRule(RelativeLayout.LEFT_OF, id); //lparams.addRule(RelativeLayout.RIGHT_OF, id)
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }		
	}
	
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
  }
	//
	setLayoutParams(lparams);
   //
	scrollxywh.width = lpW;
	scrollview.setLayoutParams(scrollxywh);
}

}

//-------------------------------------------------------------------------
//ViewFlipper
//      Event :
//Ref. http://learneasyandroid.blogspot.kr/2013/03/viewflipper-example.html
//    http://promobile.tistory.com/129
//    http://neoroid.tistory.com/86
//-------------------------------------------------------------------------

class jViewFlipper extends ViewFlipper {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private RelativeLayout.LayoutParams    lparams;           // layout XYWH --fix by jmpessoa
private OnTouchListener onTouchListener;   // event
//
private float           Xdn;               // Down Position
private float           Xup;               // Up Position
private int             inxcur;            // 0
private int             inxmax;            // 3
//
private Animation       iL2R;
private Animation       oL2R;
private Animation       iR2L;
private Animation       oR2L;
//
private jImageBtn       imagebtn;

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;


// Constructor
public  jViewFlipper(android.content.Context context,
                  Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new RelativeLayout.LayoutParams(100,100);     // W,H
lparams.setMargins        ( 50, 50,0,0); // L,T,
// Animation
iL2R = controls.Ani_iL2R(250); // In  (Left  to Right)
oL2R = controls.Ani_oL2R(250); // Out (Left  to Right)
iR2L = controls.Ani_iR2L(250); // In  (Right to Left )
oR2L = controls.Ani_oR2L(250); // Out (Right to Left )
// Sample Code
TextView tView1 = new TextView(context);
                  tView1.setText     ("View #1");
                  tView1.setTextColor(0xFF0000FF);
                  tView1.setTextSize (128);
                  addView(tView1);
TextView tView2 = new TextView(context);
                  tView2.setText     ("View #2");
                  tView2.setTextColor(0xFF0000FF);
                  tView2.setTextSize (128);
                  addView(tView2);
TextView tView3 = new TextView(context);
                  tView3.setText     ("View #3");
                  tView3.setTextColor(0xFF0000FF);
                  tView3.setTextSize (128);
                  addView(tView3);
//
int obj = 112321321;
imagebtn = new jImageBtn(context,ctrls,obj);

/*
imagebtn.setButton("/data/data/com.kredix/files/btn1_1.png",
                   "/data/data/com.kredix/files/btn1_2.png");
*/

//tView2.View.addView(imagebtn);
addView(imagebtn);
//
inxcur = 0;
inxmax = 4;
//
setBackgroundColor(0x80FFFFFF);
// Init Event
onTouchListener = new OnTouchListener() {
  public  boolean onTouch(final View view, final MotionEvent event) {
    //Log.i("ViewFlipper","ViewFlipper OnTouch");
    switch(event.getAction())  {
      case MotionEvent.ACTION_DOWN :
           { Xdn = event.getX();
             break; }
      case MotionEvent.ACTION_UP   :
           { Xup   = event.getX();
             if(Xup < Xdn) { // Right Direction
                            // Log.i("ViewFlipper","Right Dir.");
                             setInAnimation (iR2L);
                             setOutAnimation(oR2L);
                             showNext();
                           //  if (inxcur < (inxmax-1)){ showNext();
                           //                            inxcur++;  }
                           }
             else if (Xup > Xdn) { // Left Direction
                                  // Log.i("ViewFlipper","Left Dir.");
                             setInAnimation (iL2R);
                             setOutAnimation(oL2R);
                             showPrevious();
                             //      if (inxcur > 0) { showPrevious();
                             //                        inxcur--;          }
                                 }
           }
    }
    controls.pOnClick(PasObj,Const.Click_Default);
    return true;
  }
};
setOnTouchListener(onTouchListener);
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	


//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
parent = viewgroup;
viewgroup.addView(this,lparams);
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
iL2R    = null;
oL2R    = null;
iR2L    = null;
oR2L    = null;
lparams = null;
setOnTouchListener(null);
}

//by jmpessoa
public void setLParamWidth(int w) {
lpW = w;
}

public void setLParamHeight(int h) {
lpH = h;
}

public void addLParamsAnchorRule(int rule) {
lparamsAnchorRule[countAnchorRule] = rule;
countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);	
			
	    }
		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
  }
	//
	setLayoutParams(lparams);
}

}

//-------------------------------------------------------------------------
//WebView
//-------------------------------------------------------------------------

//http://developer.android.com/reference/android/webkit/WebViewClient.html
class jWebClient extends WebViewClient {
// Java-Pascal Interface
public  long            PasObj   = 0;      // Pascal Obj
public  Controls        controls = null;   // Control Class for Event

public String mUsername = ""; 
public String mPassword = "";

public jWebClient(){
	//
}


@Override
public void onReceivedHttpAuthRequest(WebView view, HttpAuthHandler handler, String host, String realm) {
	handler.proceed(mUsername, mPassword);
}

@Override
public  boolean shouldOverrideUrlLoading(WebView view, String url) {
int rtn = controls.pOnWebViewStatus(PasObj,Const.WebView_OnBefore,url);
if (rtn == Const.WebView_Act_Continue)
     { view.loadUrl(url);
       return true; }
else { return true; }
}

@Override
public  void onLoadResource(WebView view, String url) {
	//
}

@Override
public  void onPageFinished(WebView view, String url) {
   controls.pOnWebViewStatus(PasObj,Const.WebView_OnFinish,url);
}

@Override
public  void onReceivedError(WebView view, int errorCode, String description, String failingUrl)  {
super.onReceivedError(view, errorCode, description, failingUrl);      
   if (errorCode == 401) {
       // alert to username and password
       // set it through the setHttpAuthUsernamePassword(...) 
	   controls.pOnWebViewStatus(PasObj, 401 , "login/password");
   }
   else{
       controls.pOnWebViewStatus(PasObj,Const.WebView_OnError, description);
   }
   
}

}

class jWebView extends WebView {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private RelativeLayout.LayoutParams lparams;
private jWebClient      webclient;

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w
int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

// Constructor
public  jWebView(android.content.Context context,
              Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
webclient = new jWebClient();

webclient.PasObj   = pasobj;
webclient.controls = ctrls;
//
setWebViewClient(webclient); // Prevent to run External Browser
//
this.getSettings().setJavaScriptEnabled(true);
//
lparams = new RelativeLayout.LayoutParams  (300,300);
lparams.setMargins( 50, 50,0,0);
 
//
}


public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
parent = viewgroup;
viewgroup.addView(this,lparams);
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
setWebViewClient(null);
webclient = null;
lparams = null;
}

//by jmpessoa
public void setLParamWidth(int w) {
lpW = w;
}

public void setLParamHeight(int h) {
lpH = h;
}

public void addLParamsAnchorRule(int rule) {
lparamsAnchorRule[countAnchorRule] = rule;
countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }
		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
  }
	//
	setLayoutParams(lparams);
}

public  void setJavaScript(boolean javascript) {
	  this.getSettings().setJavaScriptEnabled(javascript);
}

	// Fatih - ZoomControl
	public  void setZoomControl(boolean zoomControl) {		
		this.getSettings().setBuiltInZoomControls(zoomControl);
	}

	//TODO: http://www.learn2crack.com/2014/01/android-oauth2-webview.html
	//Stores HTTP authentication credentials for a given host and realm. This method is intended to be used with
	public void SetHttpAuthUsernamePassword(String _hostName, String  _hostDomain, String _username, String _password) {
	   this.setHttpAuthUsernamePassword(_hostName, _hostDomain, _username, _password);
	   webclient.mUsername = _username; 
	   webclient.mPassword = _password;
	}
}

//-------------------------------------------------------------------------
//Custom Canvas
//
//Ref.
//   http://developer.android.com/reference/android/graphics/Canvas.html
//   http://developer.android.com/reference/android/graphics/Paint.html
//-------------------------------------------------------------------------

class jCanvas {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private Canvas          canvas = null;
private Paint           paint  = null;


// Constructor
public  jCanvas(Controls ctrls,long pasobj ) {
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
paint   = new Paint();
}

public  void setCanvas(Canvas scanvas) {
  canvas = scanvas;
}

public  void setStrokeWidth(float width) {
  paint.setStrokeWidth(width);
}

public  void setStyle(int style) {
switch (style) {
  case 0  : { paint.setStyle(Paint.Style.FILL           ); break; }
  case 1  : { paint.setStyle(Paint.Style.FILL_AND_STROKE); break; }
  case 2  : { paint.setStyle(Paint.Style.STROKE);          break; }
  default : { paint.setStyle(Paint.Style.FILL           ); break; }
};
}

public  void setColor(int color) {
  paint.setColor(color);
}

public  void setTextSize(float textsize) {
  paint.setTextSize(textsize);
}

public  void drawLine(float x1, float y1, float x2, float y2) {
  canvas.drawLine(x1,y1,x2,y2,paint);
}

public  void drawText(String text, float x, float y ) {
  canvas.drawText(text,x,y,paint);
}

public  void drawBitmap(Bitmap bitmap, int b, int l, int r, int t) {
  Rect rect = new Rect(b,l,r,t);
  canvas.drawBitmap(bitmap,null,rect,paint);
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
   paint = null;
}

}

//-------------------------------------------------------------------------
//Custom View
//ref. http://iserveandroid.blogspot.kr/2010/12/button-press-button-states-images.html
//-------------------------------------------------------------------------

class jView extends View {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private RelativeLayout.LayoutParams    lparams; //fix by jmpessoa
private jCanvas         jcanvas  = null;   //

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.MATCH_PARENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;


// Constructor
public  jView(android.content.Context context,
            Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new LayoutParams(300,300);
lparams.setMargins( 50, 50,0,0);
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
  parent = viewgroup;
  viewgroup.addView(this,lparams);
}

//
public  void setjCanvas(java.lang.Object canvas) {   
   jcanvas = (jCanvas)canvas;
}

//
@Override
public  boolean onTouchEvent( MotionEvent event) {
int act     = event.getAction() & MotionEvent.ACTION_MASK;
/*
switch(act) {
  case MotionEvent.ACTION_DOWN: {
        int count = event.getPointerCount();
        for ( int i = 0; i < count; i++ ) {
          int ptID = event.getPointerId(i);
          controls.pOnTouch (PasObj,ptID,Const.TouchDown,event.getX(i), event.getY(i) );
        }
        break; }
  case MotionEvent.ACTION_MOVE: {
        int count = event.getPointerCount();
        for ( int i = 0; i < count; i++ ) {
          int ptID = event.getPointerId(i);
          controls.pOnTouch (PasObj,ptID,Const.TouchMove,event.getX(i), event.getY(i) );
        }
        break; }
  case MotionEvent.ACTION_UP: {
        int count = event.getPointerCount();
        for ( int i = 0; i < count; i++ ) {
          int ptID = event.getPointerId(i);
          controls.pOnTouch (PasObj,ptID,Const.TouchUp  ,event.getX(i), event.getY(i) );
        }
        break; }
} */
switch(act) {
  case MotionEvent.ACTION_DOWN: {
        switch (event.getPointerCount()) {
        	case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
        		                            event.getX(0),event.getY(0),0,0); break; }
        	default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
        		                            event.getX(0),event.getY(0),
        		                            event.getX(1),event.getY(1));     break; }
        }
       break;}
  case MotionEvent.ACTION_MOVE: {
        switch (event.getPointerCount()) {
        	case 1 : { controls.pOnTouch (PasObj,Const.TouchMove,1,
        		                            event.getX(0),event.getY(0),0,0); break; }
        	default: { controls.pOnTouch (PasObj,Const.TouchMove,2,
        		                            event.getX(0),event.getY(0),
        		                            event.getX(1),event.getY(1));     break; }
        }
       break;}
  case MotionEvent.ACTION_UP: {
        switch (event.getPointerCount()) {
        	case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
        		                            event.getX(0),event.getY(0),0,0); break; }
        	default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
        		                            event.getX(0),event.getY(0),
        		                            event.getX(1),event.getY(1));     break; }
        }
       break;}
  case MotionEvent.ACTION_POINTER_DOWN: {
        switch (event.getPointerCount()) {
        	case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
        		                            event.getX(0),event.getY(0),0,0); break; }
        	default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
        		                            event.getX(0),event.getY(0),
        		                            event.getX(1),event.getY(1));     break; }
        }
       break;}
  case MotionEvent.ACTION_POINTER_UP  : {
  	   // Log.i("Java","PUp");
        switch (event.getPointerCount()) {
        	case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
        		                            event.getX(0),event.getY(0),0,0); break; }
        	default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
        		                            event.getX(0),event.getY(0),
        		                            event.getX(1),event.getY(1));     break; }
        }
       break;}
} 
return true;
}

//
@Override
public  void onDraw( Canvas canvas) {
  jcanvas.setCanvas(canvas);
  controls.pOnDraw(PasObj,canvas); // improvement required
}

public void saveView( String sFileName ) {
  Bitmap b = Bitmap.createBitmap( getWidth(), getHeight(), Bitmap.Config.ARGB_8888);
  Canvas c = new Canvas( b );
  draw( c );
  FileOutputStream fos = null;
  try {
     fos = new FileOutputStream( sFileName );
     if (fos != null) {
       b.compress(Bitmap.CompressFormat.PNG, 100, fos );
       fos.close(); 
     }  
   }
   catch ( Exception e) {
    Log.e("jView_SaveView", "Exception: "+ e.toString() ); 
   }
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this);   }
lparams = null;
}

//by jmpessoa
public void setLParamWidth(int w) {
  lpW = w;
}

public void setLParamHeight(int h) {
  lpH = h;
}

public int getLParamHeight() {	
  return getHeight();
}  

public int getLParamWidth() {
	return getWidth();
}

public void addLParamsAnchorRule(int rule) {
  lparamsAnchorRule[countAnchorRule] = rule;
  countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
  lparamsParentRule[countParentRule] = rule;
  countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; 
	lparams.height = lpH; 
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }
		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
  }
	//
   setLayoutParams(lparams);
}

}

//-------------------------------------------------------------------------
//GLView
//      Event : pOnTouch
//-------------------------------------------------------------------------
//http://developer.android.com/reference/android/opengl/GLSurfaceView.EGLContextFactory.html
//http://stackoverflow.com/questions/8932732/android-ndk-opengl-gldeletetextures-causes-error-call-to-opengl-es-api-with-no
//http://stackoverflow.com/questions/2034272/do-i-have-to-use-gldeletetextures-in-the-end-of-the-program
//http://stackoverflow.com/questions/8168014/opengl-screenshot-android
//http://cafe.naver.com/mcbugi/250562
//http://cafe.naver.com/cocos2dxusers/405
class jGLSurfaceView extends GLSurfaceView {
// Java-Pascal Interface
private long            PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private RelativeLayout.LayoutParams    lparams;           // layout XYWH -fix by jmpessoa
private jRenderer       renderer;
private GL10            savGL;

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

//
class jRenderer implements GLSurfaceView.Renderer {
  public  void onSurfaceCreated(GL10 gl, EGLConfig config) {
             controls.pOnGLRenderer(PasObj,Const.Renderer_onSurfaceCreated,0,0); }
  public  void onSurfaceChanged(GL10 gl, int w, int h) {
             controls.pOnGLRenderer(PasObj,Const.Renderer_onSurfaceChanged,w,h); }
  public  void onDrawFrame     (GL10 gl) {
	             //Log.i("Java","Draw before");
             controls.pOnGLRenderer(PasObj,Const.Renderer_onDrawFrame,0,0);    
             //Log.i("Java","Draw after");  
             }
}

// Constructor
public  jGLSurfaceView (android.content.Context context,
                      Controls ctrls,long pasobj, int version ) {
  super(context);
  // Connect Pascal I/F
  PasObj   = pasobj;
  controls = ctrls;
  // Init Class
  lparams = new LayoutParams(100,100);     // W,H
  lparams.setMargins(10, 10,10,10); // L,T,

  // OpenGL ES Version
  if (version != 1) {setEGLContextClientVersion(2); };
 
  renderer = new jRenderer();
 
  setEGLConfigChooser(8,8,8,8,16,8);       // RGBA,Depath,Stencil
  
  setRenderer  ( renderer );
  
  setRenderMode( GLSurfaceView.RENDERMODE_WHEN_DIRTY );

}


public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

//
public  void setParent( android.view.ViewGroup viewgroup ) {
  if (parent != null) { parent.removeView(this); }
  parent = viewgroup;
  viewgroup.addView(this,lparams);
}

//
@Override
public  boolean onTouchEvent( MotionEvent event) {
int act     = event.getAction() & MotionEvent.ACTION_MASK;
switch(act) {
  case MotionEvent.ACTION_DOWN: {
        switch (event.getPointerCount()) {
        	case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
        		                            event.getX(0),event.getY(0),0,0);
        	          // Log.i("touch down1:","x="+event.getX(0)+"  y="+event.getY(0));
        	           break; 
        		     }
        	default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
        		                            event.getX(0),event.getY(0),
        		                            event.getX(1),event.getY(1));
                       //Log.i("touch down2:","x="+event.getX(0)+"  y="+event.getY(0));
        	           break; 
        	         }
        }
       break;}
  case MotionEvent.ACTION_MOVE: {
        switch (event.getPointerCount()) {
        	case 1 : { controls.pOnTouch (PasObj,Const.TouchMove,1,
        		                            event.getX(0),event.getY(0),0,0); break; }
        	default: { controls.pOnTouch (PasObj,Const.TouchMove,2,
        		                            event.getX(0),event.getY(0),
        		                            event.getX(1),event.getY(1));     break; }
        }
       break;}
  case MotionEvent.ACTION_UP: {
        switch (event.getPointerCount()) {
        	case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
        		                            event.getX(0),event.getY(0),0,0);
                	//Log.i("touch up1:","x="+event.getX(0)+"  y="+event.getY(0));
        	         break; }
        	default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
        		                            event.getX(0),event.getY(0),
        		                            event.getX(1),event.getY(1));  
        	         //Log.i("touch up2:","x="+event.getX(0)+"  y="+event.getY(0));
        	         break; }
        }
       break;}
  case MotionEvent.ACTION_POINTER_DOWN: {
        switch (event.getPointerCount()) {
        	case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
        		                            event.getX(0),event.getY(0),0,0); break; }
        	default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
        		                            event.getX(0),event.getY(0),
        		                            event.getX(1),event.getY(1));     break; }
        }
       break;}
  case MotionEvent.ACTION_POINTER_UP  : {
  	    //Log.i("Java","PUp");
        switch (event.getPointerCount()) {
        	case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
        		                            event.getX(0),event.getY(0),0,0); break; }
        	default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
        		                            event.getX(0),event.getY(0),
        		                            event.getX(1),event.getY(1));     break; }
        }
       break;}
} 
return true;
}

//
@Override
public void surfaceDestroyed(SurfaceHolder holder) {
	//Log.i("Java","surfaceDestroyed");
	queueEvent(new Runnable() {
    	@Override
	    public void run() {
           controls.pOnGLRenderer(PasObj, Const.Renderer_onSurfaceDestroyed,0,0); 
        }
    });    
    super.surfaceDestroyed(holder);
}

//
public  void genRender() {
	queueEvent(new Runnable() {
		@Override
		public void run() {
			try{
				  requestRender();
	       }
	   	catch ( Exception e) {
        Log.e("deleteTexture", "Exception: "+ e.toString() ); }
  }
  });    
}	

//
public  void deleteTexture( int id ) {
    final int idx = id;
	queueEvent(new Runnable() {
		@Override
		public void run() {
		try{
            int[] ids = new int[1];
	        ids[0] = idx;
            EGL10 egl = (EGL10)EGLContext.getEGL(); 
            GL10   gl = (GL10)egl.eglGetCurrentContext().getGL();  
          //gl.glBindTexture(GL10.GL_TEXTURE_2D, idx);
	        gl.glDeleteTextures(1,ids,0);
	    }
	   	catch ( Exception e) {
           Log.e("deleteTexture", "Exception: "+ e.toString() ); }
        }
  });    
}	

//
public  void glThread() {
	queueEvent(new Runnable() {
		@Override
		public void run() {
			controls.pOnGLRenderer(PasObj,Const.Renderer_onSurfaceThread,0,0); }
     });    
}	

//Free object except Self, Pascal Code Free the class.
public  void Free() {
  if (parent != null) { parent.removeView(this); }
  renderer = null;
  lparams  = null;
}

//by jmpessoa
public void setLParamWidth(int w) {
  lpW = w;
}
//by jmpessoa
public void setLParamHeight(int h) {
  lpH = h;
}
//by jmpessoa
public int getLParamHeight() {	
	return getHeight(); 
}  
//by jmpessoa        
public int getLParamWidth() {
  return getWidth();
}
//by jmpessoa
public void addLParamsAnchorRule(int rule) {
  lparamsAnchorRule[countAnchorRule] = rule;
  countAnchorRule = countAnchorRule + 1;
}
//by jmpessoa
public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}
//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; 
	lparams.height = lpH; 
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
    }
	//
	setLayoutParams(lparams);
}


//by jmpessoa
public void Refresh() {
   this.requestRender();
}

//by jmpessoa
public  void SetAutoRefresh(boolean active ) {
	  if (active) {setRenderMode( GLSurfaceView.RENDERMODE_CONTINUOUSLY ); }
	  else  {setRenderMode( GLSurfaceView.RENDERMODE_WHEN_DIRTY   ); }
}

}

//-------------------------------------------------------------------------
//Dialog
//      Event pOnClick
//-------------------------------------------------------------------------

class jDialogYN {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private String          dlgTitle;
private String          dlgMsg;
private String          dlgY;
private String          dlgN;
//
private DialogInterface.OnClickListener onClickListener = null;
private AlertDialog dialog = null;

// Constructor
public  jDialogYN(android.content.Context context,
                Controls ctrls, long pasobj,
                String title, String msg, String y, String n ) {
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//
dlgTitle = title;
dlgMsg   = msg;
dlgY     = y;
dlgN     = n;

// Init Event
onClickListener = new DialogInterface.OnClickListener() {
  public  void onClick(DialogInterface dialog, int id) {
    if  ( id == Const.Click_Yes) { controls.pOnClick(PasObj,Const.Click_Yes);}
                            else { controls.pOnClick(PasObj,Const.Click_No );}
  };
};
// Init Class
if (dlgY.equals("")) dlgY ="Yes";
if (dlgN.equals("")) dlgN ="No";

AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
builder.setMessage       (dlgMsg  )
       .setCancelable    (false)
       .setPositiveButton(dlgY,onClickListener)
       .setNegativeButton(dlgN,onClickListener);
dialog = builder.create();
//
dialog.setTitle(dlgTitle);
//dialog.setIcon(R.drawable.icon);  //my comment here!!

}

public  void show() {
   //Log.i("java","DlgYN_Show");
   dialog.show();
}

public  void show(String titleText, String msgText, String yesText, String noText) {
	   //Log.i("java","DlgYN_Show");
	dlgTitle = titleText;
	dlgMsg   = msgText;
	dlgY     = yesText;
	dlgN     = noText;

	if (dlgY.equals("")) dlgY ="Yes";
	if (dlgN.equals("")) dlgN ="No";
	
	AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
	builder.setMessage       (dlgMsg  )
	       .setCancelable    (false)
	       .setPositiveButton(dlgY,onClickListener)
	       .setNegativeButton(dlgN,onClickListener);
	dialog = builder.create();
	//
	dialog.setTitle(dlgTitle);

	dialog.show();
}

public void show(String titleText, String msgText) {
	   //Log.i("java","DlgYN_Show");
	dlgTitle = titleText;
	dlgMsg   = msgText;

	if (dlgY.equals("")) dlgY ="Yes";
	if (dlgN.equals("")) dlgN ="No";
	
	AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
	builder.setMessage       (dlgMsg  )
	       .setCancelable    (false)
	       .setPositiveButton(dlgY,onClickListener)
	       .setNegativeButton(dlgN,onClickListener);
	dialog = builder.create();
	//
	dialog.setTitle(dlgTitle);
	dialog.show();
}

public  void Free() {
  onClickListener = null;
  dialog.setTitle("");
  dialog.setIcon(null);
  dialog = null;
}
}

//-------------------------------------------------------------------------
//ProgressDialog
//-------------------------------------------------------------------------

class jDialogProgress {
  // Java-Pascal Interface
  private long  PasObj = 0;      // Pascal Obj
  private Controls controls = null;   // Control Class for Event
  
  String mTitle = "";
  String mMsg = "";
  int mFlag = 0;  
  private ProgressDialog  dialog = null;  
  private AlertDialog  customDialog = null;  
  
  public jDialogProgress(android.content.Context context,
                     Controls ctrls, long pasobj, String title, String msg) {
    //Connect Pascal I/F
    PasObj = pasobj;
    controls = ctrls;
    mTitle= title;
    mMsg = msg; 
    mFlag = 0;
  }

  public  void Free() {
	if (dialog != null) dialog.dismiss();
	if (customDialog != null) customDialog.dismiss();		
    dialog = null;
    customDialog = null;
  }
  
  
  public void Show() {
	if (dialog != null) dialog.dismiss();
	dialog = null;	  
	dialog = new ProgressDialog(controls.activity);
	
	if (!mMsg.equals("")) dialog.setMessage(mMsg);		 
	if (!mTitle.equals("")) 
		dialog.setTitle(mTitle);	
	 else 
		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
	
    dialog.setCancelable(true);         
    dialog.show();
  }
	  
  public void Show(String _title, String _msg) {
	  if (dialog != null) dialog.dismiss();
	  dialog = null;	 
	  mMsg = _msg;
	  mTitle= _title;
	  dialog = new ProgressDialog(controls.activity);
	  	  
	  if (!mMsg.equals("")) dialog.setMessage(mMsg);		 
	  if (!mTitle.equals("")) 
		 dialog.setTitle(mTitle);	
	  else 
		 dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
	  
      dialog.setCancelable(true); //back key            
      dialog.show();
  }
  
  public void Show(RelativeLayout _layout) {	
	if (dialog != null) dialog.dismiss();
	dialog = null;		
    if(_layout.getVisibility()==0) { //visible   
	  _layout.setVisibility(android.view.View.INVISIBLE); //4
    }                  
    if ( _layout.getParent().getClass().getName().equals("android.widget.RelativeLayout") ) {    	
    	RelativeLayout par = (RelativeLayout)_layout.getParent();
    	if (par != null) par.removeView(_layout);
    } 			
    else {
    	FrameLayout par = (FrameLayout)_layout.getParent();
    	if (par != null) par.removeView(_layout);
    }
    
	_layout.setVisibility(0);	
    AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);    
    builder.setView(_layout);
    builder.setCancelable(true); //back key    
    customDialog = builder.create();   
    		 
	if (!mTitle.equals("")) 
	  customDialog.setTitle(mTitle);	
	else 
	  customDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
    
    customDialog.show();    
  }
  
  public void SetMessage(String _msg) {
    mMsg = _msg;
    if (dialog != null) {
    	if (dialog.isShowing()) {dialog.setMessage(_msg);}
    }	
  }
 
  public void SetTitle(String _title) {
	mTitle = _title;
	if (dialog != null) dialog.setTitle(_title);
	if (customDialog != null) customDialog.setTitle(_title);
  }
  
  public void SetCancelable(boolean _value) {
	if (dialog != null) dialog.setCancelable(_value);
	if (customDialog != null) customDialog.setCancelable(_value);
  }
      
  public void Stop() {
	  if (customDialog != null) {
		  customDialog.dismiss();		  
	  }
	  if (dialog != null) {
		  dialog.dismiss();		  
	  }
  }
  
  //TODO
  public void ShowAsync() {  //Async
	  new ATask().execute(null, null, null); 
  }
  
  //TODO                        //params, progress, result
  class ATask extends AsyncTask<String, Integer, Integer>{
       int count;
       
    // Step #1. 
       @Override
       protected void onPreExecute(){ 
         super.onPreExecute();
         
         count = 1;         
  		 if (dialog != null) dialog.dismiss();
  		 dialog = null;
  		 
  		 dialog = new ProgressDialog(controls.activity);
  		
  		 if (!mMsg.equals("")) dialog.setMessage(mMsg);
  		 
  		 if (!mTitle.equals("")) 
  			dialog.setTitle(mTitle);	
  		 else 
  			dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
  		
  	     dialog.setCancelable(true);         
  	     dialog.show();
       }
       
    // Step #2. 
	   @Override
	   protected Integer doInBackground(String... params) {
		   int result = 0;		   
	       while( count > 0 ) {	 //controls.pOnShowDialogProgressAsync(PasObj, count)
	    	  result = count;
	    	  publishProgress(count);
	       }	       
	       return result;	      
	    }

	    // Step #3. Progress
	    @Override
	    protected void onProgressUpdate(Integer... params) {
	       super.onProgressUpdate(params);	       
	       count = count + 1;	       
	       if ( count == 1000) { //just test !
	    	   count = -1;
	       }
	    }

	    //Step #4. After Process
	    @Override
	    protected void onPostExecute(Integer result) {
	      super.onPostExecute(result);
	      if (dialog != null) dialog.dismiss();
	      //Log.i("onPostExecute = ", "result = "+ result.intValue());	      
	    }        	    
	  }
}


//-------------------------------------------------------------------------
//jImageBtn
//-------------------------------------------------------------------------

class jImageBtn extends View {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private RelativeLayout.LayoutParams    lparams; //fix by jmpessoa
 //
private Paint           mPaint   = null;
private Bitmap          bmpUp    = null;
private Bitmap          bmpDn    = null;
private Rect            rect;
private int             btnState = 0;      // Normal/Up = 0 , Pressed = 1
private Boolean         enabled  = true;   //

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.WRAP_CONTENT; //w

int MarginLeft = 0;
int MarginTop = 0;
int marginRight = 0;
int marginBottom = 0;

// Constructor
public  jImageBtn(android.content.Context context,
                Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new LayoutParams  (100,100);
lparams.setMargins(0, 0,0,0);
// BackGroundColor
//setBackgroundColor(0xFF0000FF);
//
mPaint = new Paint();
rect   = new Rect(0,0,200,200);
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
parent = viewgroup;
viewgroup.addView(this,lparams);
}

public  void setButton( String fileup , String filedn ) {
if (bmpUp  != null) { bmpUp.recycle();         }
bmpUp = BitmapFactory.decodeFile(fileup);
rect   = new Rect(0,0,bmpUp.getWidth(),bmpUp.getHeight());

if (bmpDn  != null) { bmpDn.recycle();         }
bmpDn = BitmapFactory.decodeFile(filedn);
rect   = new Rect(0,0,bmpDn.getWidth(),bmpDn.getHeight());
invalidate();
}

public  void setButtonUp( String fileup) {
if (bmpUp  != null) { bmpUp.recycle(); }
bmpUp = BitmapFactory.decodeFile(fileup);
rect   = new Rect(0,0,bmpUp.getWidth(),bmpUp.getHeight());
invalidate();
}

public  void setButtonDown( String filedn ) {
if (bmpDn  != null) { bmpDn.recycle();         }
bmpDn = BitmapFactory.decodeFile(filedn);
rect   = new Rect(0,0,bmpDn.getWidth(),bmpDn.getHeight());
invalidate();
}


//by jmpessoa
private int GetDrawableResourceId(String _resName) {
	  try {
	     Class<?> res = R.drawable.class;
	     Field field = res.getField(_resName);  //"drawableName"
	     int drawableId = field.getInt(null);
	     return drawableId;
	  }
	  catch (Exception e) {
	     Log.e("jImageBtn", "Failure to get drawable id.", e);
	     return 0;
	  }
}

//by jmpessoa
private Drawable GetDrawableResourceById(int _resID) {
	return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
}

public  void setButtonUpByRes(String resup) {   // ..res/drawable
  if (bmpUp  != null) { bmpUp.recycle(); }
  Drawable d = GetDrawableResourceById(GetDrawableResourceId(resup));
  bmpUp = ((BitmapDrawable)d).getBitmap();
  rect   = new Rect(0,0,bmpUp.getWidth(),bmpUp.getHeight());
  invalidate();
}

public  void setButtonDownByRes(String resdn) {   // ..res/drawable
  if (bmpDn  != null) { bmpDn.recycle(); }
   Drawable d = GetDrawableResourceById(GetDrawableResourceId(resdn));
   bmpDn = ((BitmapDrawable)d).getBitmap();
   rect   = new Rect(0,0,bmpDn.getWidth(),bmpDn.getHeight());	 
   invalidate();
}

//
@Override
public  boolean onTouchEvent( MotionEvent event) {
// LORDMAN 2013-08-16

if (enabled == false) { return false; }

int actType = event.getAction()&MotionEvent.ACTION_MASK;

switch(actType) {
  case MotionEvent.ACTION_DOWN: {  btnState = 1; 
                                   invalidate(); 
                                   //Log.i("Java","jImageBtn Here"); 
                                   break; 
                                 }
  case MotionEvent.ACTION_MOVE: { break; }
  case MotionEvent.ACTION_UP  : {  btnState = 0; 
                                   invalidate();
                                   controls.pOnClick(PasObj,Const.Click_Default);                                  
                                   break; 
                                  }
}

return true;

}

//
@Override
public  void onDraw( Canvas canvas) {
//
  if (btnState == 0) { 
	if (bmpUp != null) { 
		//Log.i("onDraw","UP");		
		canvas.drawBitmap(bmpUp,null,rect,null); //mPaint 
	} 
  }
  else  { 
	 if (bmpDn != null) { 
		//Log.i("onDraw","Dow");
		canvas.drawBitmap(bmpDn,null,rect,null); //mPaint 
	 }
  }	
  
}



public  void setEnabled(boolean value) {
enabled = value;
}

// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
if (bmpUp  != null) { bmpUp.recycle();         }
if (bmpDn  != null) { bmpDn.recycle();         }
bmpUp   = null;
bmpDn   = null;
lparams = null;
mPaint  = null;
rect    = null;
}

//by jmpessoa
public void setLParamWidth(int w) {
  lpW = w;
}

public void setLParamHeight(int h) {
  lpH = h;
}

public void addLParamsAnchorRule(int rule) {
lparamsAnchorRule[countAnchorRule] = rule;
countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //wrapContent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }
		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
  }
	//
  rect.right     = lpW;
  rect.bottom    = lpH;
  setLayoutParams(lparams);
}

}

/*
//
abstract class AniListener implements Animation.AnimationListener {
//
public  RelativeLayout playout;
public  RelativeLayout clayout;

// Constructor
public  void set ( RelativeLayout parent, RelativeLayout child ) {
playout = parent;
clayout = child;
}

@Override
public  void onAnimationEnd(Animation animation) {
     playout.removeView(clayout);}
}
*/

//------------------------------------------------------------------------------
//jHttp_Down
//
//jHttp_DownLoad http_down = new jHttp_DownLoad(context,ctrls);
//http_down.execute("http://app.pixo.kr/maxpaper/test.jpg");
//
//ref. http://developer.android.com/reference/android/os/AsyncTask.html
//  http://blog.naver.com/giyoung_it?Redirect=Log&logNo=100177415835
//  http://blog.daum.net/yohocosama/274
//  http://jangjeonghun.tistory.com/303
//------------------------------------------------------------------------------

//Params , Progress , Result
class jHttp_DownLoad extends AsyncTask<String, Integer, File>{
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private String          urlfile   = "";    // url File
private String          localfile = "";    // Local File

// Constructor
public  jHttp_DownLoad(Controls ctrls,long pasobj, String url, String local ) {
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//
urlfile   = url;
localfile = local;
}

//
public  void run() {
execute(urlfile);
}

// Step #1. Before Process
@Override
protected void onPreExecute() {
super.onPreExecute();
//Log.i("Java","Before Download");
//progress.show();
}

// Step #3. Progress
@Override
protected void onProgressUpdate(Integer... progress) {
super.onProgressUpdate();
//setProgressPercent(progress[0]);
//Log.i("Java","onProgressUpdate");
}

// Step #4. After Process
@Override
protected void onPostExecute(File result) {
super.onPostExecute(result);
//Log.i("Java","Finish");
}

// Step #2. Downloading
@Override
protected File doInBackground(String... urls) {
try {
     //
     URL url                 = new URL(urls[0]);
     URLConnection ucon      = url.openConnection();
     //
     String fileName         = localfile;

     // Create Folder
     //File dir                = new File ( System.IO.Path.GetDirectoryName(localfile) );
     //if(!dir.exists()) { dir.mkdirs(); }
     //File file               = new File(dir,System.IO.Path.GetFileName(localfile) );
     File file               = new File(localfile);

     long startTime          = System.currentTimeMillis();
     InputStream is          = ucon.getInputStream();
     BufferedInputStream bis = new BufferedInputStream(is);

     ByteArrayBuffer baf = new ByteArrayBuffer(5);
     int total = 0;
     int count = 0;
     while ((count = bis.read()) != -1) {
       total += count;
       publishProgress(total);
       baf.append((byte) count);
     }
     //if (isCancelled()) break;

     // Save File
     FileOutputStream fos = new FileOutputStream(file);
     fos.write(baf.toByteArray());
     fos.flush();
     fos.close();
     //
     //Log.d("Java", "Downloaded " + ((System.currentTimeMillis() - startTime) / 1000) + "s");
     // return -> onPostExecute
     return file;  }
catch (IOException e) {
     e.printStackTrace(); }
return null;
}

}

//------------------------------------------------------------------------------
//jAsyncTask
//
//------------------------------------------------------------------------------

//                             Params , Progress , Result
class jAsyncTask {
	
   //Java-Pascal Interface
   private long             PasObj   = 0;      // Pascal Obj
   private Controls        controls = null;   // Control Class for Event
   boolean autoPublishProgress = false;  

// Constructor
   public  jAsyncTask(Controls ctrls,long pasobj) {
   //Connect Pascal I/F
    PasObj   = pasobj;
    controls = ctrls;
   }

   public void setProgress(int progress ) {  //update UI
	   //Log.i("jAsyncTask","setProgress "+progress );
	   //publishProgress(progress);
	   //count = count + progress;
   }

	//by jmpessoa
	public void SetAutoPublishProgress(boolean value){		
	   //autoPublishProgress = value;
	}

    public void Execute(){
      //Log.i("Execute","Execute...");	
	  new ATask().execute();
    }

	//Free object except Self, Pascal Code Free the class.
    public  void Free() {
	  	//
    }

  class ATask extends AsyncTask<String, Integer, Integer>{
    int count = 0;
    int progressUpdate = 0;
    //Step #1. Before Process    
   @Override
   protected void onPreExecute() {	   
     super.onPreExecute();
     progressUpdate = controls.pOnAsyncEventPreExecute(PasObj); // Pascal Event
     if ( progressUpdate != 0) count = progressUpdate;
   }

   //Step #2. Task/Process
   @Override
   protected Integer doInBackground(String... params) {	   
       while(controls.pOnAsyncEventDoInBackground(PasObj, count) ) {    	  
    	   publishProgress(count);
       }     	    
       return null; //count;      
    }

    //Step #3. Progress
    @Override
    protected void onProgressUpdate(Integer... params) {
       super.onProgressUpdate(params);
       progressUpdate = controls.pOnAsyncEventProgressUpdate(PasObj, count); // Pascal Event
       if (progressUpdate != count)  count = progressUpdate;       
    }

    //Step #4. After Process
    @Override
    protected void onPostExecute(Integer result) {  
      super.onPostExecute(result);
      controls.pOnAsyncEventPostExecute(PasObj, count); //result.intValue()      
    }        
    
  }

}

//------------------------------------------------------------------------------
//Graphic API
//------------------------------------------------------------------------------
//http://forum.lazarus.freepascal.org/index.php?topic=21568.0
//https://github.com/alrieckert/lazarus/blob/master/lcl/interfaces/customdrawn/android/bitmap.pas

class jBitmap {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event

//
public  Bitmap bmp    = null;



// Constructor
public  jBitmap(Controls ctrls, long pasobj ) {
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;

}

public  void loadFile(String filename) {  //full file name!
  //if (bmp != null) { bmp.recycle(); }
  bmp = BitmapFactory.decodeFile(filename);
}


//by jmpessoa
private int GetDrawableResourceId(String _resName) {
	  try {
	     Class<?> res = R.drawable.class;
	     Field field = res.getField(_resName);  //"drawableName"
	     int drawableId = field.getInt(null);
	     return drawableId;
	  }
	  catch (Exception e) {
	     Log.e("jBitmap", "Failure to get drawable id.", e);
	     return 0;
	  }
}

//by jmpessoa
private Drawable GetDrawableResourceById(int _resID) {
	return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
}

//by jmpessoa
public  void loadRes(String imgResIdentifier) {  //full file name!
	  //if (bmp != null) { bmp.recycle(); }
	  Drawable d = GetDrawableResourceById(GetDrawableResourceId(imgResIdentifier));
	  bmp =	  ((BitmapDrawable)d).getBitmap();
}


//by jmpessoa
//BitmapFactory.Options options = new BitmapFactory.Options();
//options.inSampleSize = 4;
public  void loadFileEx(String filename) {
 //if (bmp != null) { bmp.recycle(); }
  BitmapFactory.Options options = new BitmapFactory.Options();
  options.inSampleSize = 4; // --> 1/4
  bmp = BitmapFactory.decodeFile(filename, options);
}


public  void createBitmap(int w, int h) {
   //if (bmp != null) { bmp.recycle(); }
   bmp = Bitmap.createBitmap( w,h, Bitmap.Config.ARGB_8888 );
}

public  int[] getWH() {
 int[] wh = new int[2];
 wh[0] = 0; // width
 wh[1] = 0; // height
if ( bmp != null ) {
  wh[0] = bmp.getWidth();
  wh[1] = bmp.getHeight();
}
 return ( wh );
}

public  int GetWidth() {
	 
	if ( bmp != null ) {
	   return bmp.getWidth();
	  
	} else return 0;
	 
}

public  int GetHeight() {
	 
	if ( bmp != null ) {
	   return bmp.getHeight();
	  
	} else return 0;
	 
}

public  void Free() {
 //bmp.recycle();
 bmp = null;
}

//by jmpessoa
public  Bitmap jInstance() {
	  return this.bmp;
}

//by jmpessoa
public byte[] GetByteArrayFromBitmap() {
    ByteArrayOutputStream stream = new ByteArrayOutputStream();
    this.bmp.compress(CompressFormat.PNG, 0, stream); //O: PNG will ignore the quality setting...
    //Log.i("GetByteArrayFromBitmap","size="+ stream.size());
    return stream.toByteArray();
}

//by jmpessoa
public void SetByteArrayToBitmap(byte[] image) {
	this.bmp = BitmapFactory.decodeByteArray(image, 0, image.length);
	//Log.i("SetByteArrayToBitmap","size="+ image.length);
}

//http://androidtrainningcenter.blogspot.com.br/2012/05/bitmap-operations-like-re-sizing.html
public Bitmap ClockWise(Bitmap _bmp, ImageView _imageView){
    Matrix mMatrix = new Matrix();
    Matrix mat= _imageView.getImageMatrix();    
    mMatrix.set(mat);
    mMatrix.setRotate(90);
    return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), mMatrix, false);    
} 

public Bitmap AntiClockWise(Bitmap _bmp, ImageView _imageView){
    Matrix mMatrix = new Matrix();
    Matrix mat= _imageView.getImageMatrix();    
    mMatrix.set(mat);
    mMatrix.setRotate(-90);
    return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), mMatrix, false);    
}

public Bitmap SetScale(Bitmap _bmp, ImageView _imageView, float _scaleX, float _scaleY ) {  
    Matrix mMatrix = new Matrix();
    Matrix mat= _imageView.getImageMatrix();    
    mMatrix.set(mat);        
	mMatrix.setScale(_scaleX, _scaleY);
	return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), mMatrix, false);	   
}

public Bitmap SetScale(ImageView _imageView, float _scaleX, float _scaleY ) {      
	/*Matrix mMatrix = new Matrix();
    Matrix mat= _imageView.getImageMatrix();    
    mMatrix.set(mat);        
	mMatrix.setScale(_scaleX, _scaleY);		
	bmp = Bitmap.createBitmap(bmp , 0, 0, bmp.getWidth(), bmp.getHeight(), mMatrix, false);
	return bmp;*/
	// CREATE A MATRIX FOR THE MANIPULATION	 
	Matrix matrix = new Matrix();
	// RESIZE THE BIT MAP
	matrix.postScale(_scaleX, _scaleY);
	// RECREATE THE NEW BITMAP
	Bitmap resizedBitmap = Bitmap.createBitmap(bmp, 0, 0, bmp.getWidth(), bmp.getHeight(), matrix, false);
	return resizedBitmap;
}

public Bitmap LoadFromAssets(String strName)
{
    AssetManager assetManager = controls.activity.getAssets();
    InputStream istr = null;
    try {
        istr = assetManager.open(strName);
    } catch (IOException e) {
        e.printStackTrace();
    }
    bmp = BitmapFactory.decodeStream(istr);    
    return bmp;
}

// ref http://sunil-android.blogspot.com.br/2013/03/resize-bitmap-bitmapcreatescaledbitmap.html
public Bitmap GetResizedBitmap(Bitmap _bmp, int _newWidth, int _newHeight){
   float factorH = _newHeight / (float)_bmp.getHeight();
   float factorW = _newWidth / (float)_bmp.getWidth();
   float factorToUse = (factorH > factorW) ? factorW : factorH;
   Bitmap bm = Bitmap.createScaledBitmap(_bmp,
     (int) (_bmp.getWidth() * factorToUse),
     (int) (_bmp.getHeight() * factorToUse),false);     
   return bm;
}

public Bitmap GetResizedBitmap(int _newWidth, int _newHeight){
   float factorH = _newHeight / (float)bmp.getHeight();
   float factorW = _newWidth / (float)bmp.getWidth();
   float factorToUse = (factorH > factorW) ? factorW : factorH;
   Bitmap bm = Bitmap.createScaledBitmap(bmp,
     (int) (bmp.getWidth() * factorToUse),
     (int) (bmp.getHeight() * factorToUse),false);     
   return bm;
}

 public Bitmap GetResizedBitmap(float _factorScaleX, float _factorScaleY ){
   float factorToUse = (_factorScaleY > _factorScaleX) ? _factorScaleX : _factorScaleY;
   Bitmap bm = Bitmap.createScaledBitmap(bmp,
     (int) (bmp.getWidth() * factorToUse),
     (int) (bmp.getHeight() * factorToUse),false);     
   return bm;
 }

  public ByteBuffer GetByteBuffer(int _width, int _height) {	  
	ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(_width*_height*4);    
    return graphicBuffer;    
  }

  public Bitmap GetBitmapFromByteBuffer(ByteBuffer _byteBuffer, int _width, int _height) {	  
	  Bitmap bm = Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888);					 
      bm.copyPixelsFromBuffer(_byteBuffer);  	
      return bm;
  }
  
  //by jmpessoa
  public Bitmap GetBitmapFromByteArray(byte[] _image) {
	Bitmap bm = BitmapFactory.decodeByteArray(_image, 0, _image.length);
	return bm;
	//Log.i("SetByteArrayToBitmap","size="+ image.length);
  }

}

/**
 * 
 * jSqliteCursor
 *
 * by jmpessoa
 *
 */
//http://android-codes-examples.blogspot.com.br/2011/09/using-sqlite-to-populate-listview-in.html <<----------
//http://www.coderzheaven.com/2012/12/23/store-image-android-sqlite-retrieve-it/  <<---------------
	
//http://www.coderzheaven.com/2011/04/17/using-sqlite-in-android-a-really-simple-example/
//http://www.androidhive.info/2011/11/android-sqlite-database-tutorial/
//http://androidexample.com/SQLite_Database_Manipulation_Class_-_Android_Example/index.php?view=article_discription&aid=51
//http://javapapers.com/android/android-sqlite-database/  <<------------------- 
//http://chintankhetiya.wordpress.com/2013/06/01/sqlite-database-example/
//http://androidituts.com/android-sqlite-database-insert-example/
//http://www.codeproject.com/Articles/119293/Using-SQLite-Database-with-Android   <<---------------
//http://stackoverflow.com/questions/5742101/how-using-sqliteopenhelper-with-database-on-sd-card

class jSqliteCursor {

	private long       PasObj  = 0;      // Pascal Obj
	private Controls   controls = null;   // Control Class for Event

	public Cursor cursor = null;
	
	public Bitmap bufBmp = null;
	
	//Constructor
	public  jSqliteCursor(Controls ctrls, long pasobj ) {
	   //Connect Pascal I/F
	   PasObj   = pasobj;
	   controls = ctrls;
	}
	
	public  void SetCursor(Cursor curs) {
		this.cursor = curs;
	}
	
    public  Cursor GetCursor() {
  	    return this.cursor;
    }
	
	public int GetRowCount() {
		if (this.cursor != null) {
    		return this.cursor.getCount();    		
    	}
    	else{
    		return 0;
    	}
    }
      
    public void MoveToFirst() {
    	if (cursor != null) cursor.moveToFirst();
    }
    
    public void MoveToNext() {
    	if (cursor != null) cursor.moveToNext();
    }
    
    public void MoveToLast() {
    	if (cursor != null) cursor.moveToLast();
    }
              
    public void MoveToPosition(int position) {
    	if (cursor != null) cursor.moveToPosition(position);
    }
  
    public int GetColumnIndex(String colName) {
    	if (cursor != null) return cursor.getColumnIndex(colName);
    	else  return -1;
    }
     
    public String GetValueAsString(int columnIndex) {
    	if (cursor != null) return cursor.getString(columnIndex);
    	else return "";			
    }

    //Cursor.FIELD_TYPE_BLOB; //4
	//Cursor.FIELD_TYPE_FLOAT//2
	//Cursor.FIELD_TYPE_INTEGER//1
	//Cursor.FIELD_TYPE_STRING//3
	//Cursor.FIELD_TYPE_NULL //0
    public int GetColType(int columnIndex) {
    	if (cursor != null) return cursor.getType(columnIndex);
    	else return Cursor.FIELD_TYPE_NULL ;			
    }
    
    public byte[] GetValueAsBlod(int columnIndex) {
    	if (cursor != null) return cursor.getBlob(columnIndex);
    	else return null;			
    }
    
    public Bitmap GetValueAsBitmap(int columnIndex) {
    	bufBmp = null;
    	byte[] image = GetValueAsBlod(columnIndex);
    	if (image != null) {
    	     this.bufBmp = BitmapFactory.decodeByteArray(image, 0, image.length);
    	}     
    	return bufBmp;
    }
    
    public int GetValueAsInteger(int columnIndex) {
    	int index = 0;
    	
    	if (cursor != null){ 
    	    if	(columnIndex < 0) {index = 0;}
    	    if  (columnIndex >= cursor.getColumnCount() ) {index = cursor.getColumnCount()-1;} 
    		return cursor.getInt(index);
    	}	
    	else return -1;			
    }
    
    public short GetValueAsShort(int columnIndex) {
    	if (cursor != null) return cursor.getShort(columnIndex);
    	else return -1;			
    }

    public long GetValueAsLong(int columnIndex) {
    	if (cursor != null) return cursor.getLong(columnIndex);
    	else return -1;			
    }

    public float GetValueAsFloat(int columnIndex) {
    	if (cursor != null) return cursor.getFloat(columnIndex);
    	else return -1;			
    }
     
    public double GetValueAsDouble(int columnIndex) {
    	if (cursor != null) return cursor.getDouble(columnIndex);
    	else return -1;			
    }
       
    public int GetColumnCount() {
    	if (cursor != null) {return cursor.getColumnCount();}
    	else {return 0;}
    }
    
    public String GetColumName(int columnIndex) {
    	if (cursor != null) return cursor.getColumnName(columnIndex);
    	else return "";			
    }
         
    //Cursor.FIELD_TYPE_BLOB; //4
	//Cursor.FIELD_TYPE_FLOAT//2
	//Cursor.FIELD_TYPE_INTEGER//1
	//Cursor.FIELD_TYPE_STRING//3
	//Cursor.FIELD_TYPE_NULL //0           
    public String GetValueAsString(int position, String columnName) {
    	String colValue = "";
        if (this.cursor != null) {
        	
        	if (position == -1)  cursor.moveToLast();
        	else cursor.moveToPosition(position);
        	
            int index = this.cursor.getColumnIndex(columnName);                      
            switch (cursor.getType(index)) {                
     	      case Cursor.FIELD_TYPE_INTEGER: colValue = Integer.toString(cursor.getInt(index));           break;
     	      case Cursor.FIELD_TYPE_STRING : colValue =  cursor.getString(index);                         break;
     	      case Cursor.FIELD_TYPE_FLOAT  : colValue =  String.format("%.3f", cursor.getFloat(index));   break;
     	      case Cursor.FIELD_TYPE_BLOB   : colValue = "BLOB";                                       break;
     	      case Cursor.FIELD_TYPE_NULL   : colValue = "NULL";                                       break;
     	      default:                        colValue = "UNKNOW";                              
    	   }                                                                       
        }
        return colValue;        
    }
    
    public void Free() {
      cursor = null;	
      bufBmp = null;
    }    
}

/**
 * 
 * jSqliteDataAccess
 * 
 * by jmpessoa
 *
 */
class jSqliteDataAccess {

        private long PasObj   = 0;           // Pascal Obj
        private Controls controls = null;   // Control Class for Event
        
        private String[] storeTableCreateQuery = new String[30]; //max (30) create tables scripts
        private String[] storeTableName = new String[30];       //max (30)  tables name
       
        private int countTableName = 0;
        private int countTableQuery = 0;
       
        private SQLiteDatabase mydb = null;
        
        public Cursor cursor = null;
        
        public Bitmap bufBmp = null;
        
        private static String DATABASE_NAME;                         
        private static final int DATABASE_VERSION = 1;
       
        char selectColDelimiter;  
        char selectRowDelimiter;
	   
        public void SetSelectDelimiters(char coldelim, char rowdelim){
    	   selectColDelimiter = coldelim;
    	   selectRowDelimiter = rowdelim;
        }
        
        public void AddTableName(String tabName) {
    	   storeTableName[countTableName] = tabName;
    	   countTableName++;
	    }
	   
        public void AddCreateTableQuery(String queryCreateTable) {
    	   storeTableCreateQuery[countTableQuery] = queryCreateTable; 
    	   countTableQuery++;
	    }
	          
	    public void CreateAllTables() {
		   for(int i=0; i < countTableQuery-1; i++) {
			   this.ExecSQL(storeTableCreateQuery[i]);  
		   }
	    }
	   	   	   
        public void DropAllTables(boolean recreate) {
		   //drop All tables
    	   for(int i=0; i < countTableName-1; i++) {
    		  this.ExecSQL("DROP TABLE IF EXISTS "+storeTableName[i]);
    	   }
    	   
    	   if (recreate = true) { CreateAllTables(); }
	    }
       
        //constructor ...
	    public jSqliteDataAccess (Controls ctrls, long pasobj, String dbName, char colDelim, char rowDelim) {	    
		   PasObj   = pasobj;
		   controls = ctrls;
		   selectColDelimiter = colDelim;  
	       selectRowDelimiter = rowDelim;
	       DATABASE_NAME = dbName;
	    }

        // Open/Create database for insert,update,delete in syncronized manner
        private synchronized SQLiteDatabase Open() throws SQLException {
    	   return controls.activity.openOrCreateDatabase(DATABASE_NAME, Context.MODE_PRIVATE, null);
        }
       
	    public void OpenOrCreate(String dataBaseName) {
		   DATABASE_NAME = dataBaseName;
		   mydb = this.Open();
	    }
	    public void SetVersion(int version) {
	    	if (mydb!= null) {
	    		mydb.setVersion(version);
	    	}
	    }
	    public int GetVersion() {
	    	if (mydb!= null) {
	    		return mydb.getVersion();
	    	}
	    	return 0;
	    }
        public void ExecSQL(String execQuery){
	        try{ 	
	           if (mydb!= null) {
	        	   if (!mydb.isOpen()) {
	        	      mydb = this.Open();
	        	   }
	           }	           	           
	           mydb.beginTransaction();
	           try {
	            	mydb.execSQL(execQuery); //Execute a single SQL statement that is NOT a SELECT or any other SQL statement that returns data.
	                //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
	                mydb.setTransactionSuccessful();
	           } catch (Exception e) {
	                e.printStackTrace();
	           } finally {
	                // transaction over
	            	mydb.endTransaction();
	            	mydb.close();
	           }	           	           	            	           
	        }catch(SQLiteException se){
	        	Log.e(getClass().getSimpleName(), "Could not execute: "+ execQuery);
	        	
	        }
	    }
        
      //by jmpessoa
        private int GetDrawableResourceId(String _resName) {
        	  try {
        	     Class<?> res = R.drawable.class;
        	     Field field = res.getField(_resName);  //"drawableName"
        	     int drawableId = field.getInt(null);
        	     return drawableId;
        	  }
        	  catch (Exception e) {
        	     Log.e("jSqliteDataAccess", "Failure to get drawable id.", e);
        	     return 0;
        	  }
        }

        //by jmpessoa
        private Drawable GetDrawableResourceById(int _resID) {
          return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
        }        
                
        public void UpdateImage(String tabName, String imageFieldName, String keyFieldName, Bitmap imageValue, int keyValue) {
        	ByteArrayOutputStream stream = new ByteArrayOutputStream();
        	bufBmp = imageValue;
        	bufBmp.compress(CompressFormat.PNG, 0, stream);            
            byte[] image_byte = stream.toByteArray();
            //Log.i("UpdateImage","UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?");
	        if (mydb!= null) {
	          if (!mydb.isOpen()) {
	             mydb = this.Open();
	          }
	        }
	        
            mydb.beginTransaction();
            try {
            	mydb.execSQL("UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?", new Object[] {image_byte, keyValue} );
                //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
                mydb.setTransactionSuccessful();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                // transaction over
            	mydb.endTransaction();
            	mydb.close();
            }	                	        	
        	//mydb.close();
        	//Log.i("UpdateImage", "Ok. Image Updated!");
        	bufBmp = null;
        }
        
        public void UpdateImage(String tabName, String imageFieldName, String keyFieldName, byte[] imageValue, int keyValue) {
	        if (mydb!= null) {
	           if (!mydb.isOpen()) {
	               mydb = this.Open();
	           }
	        }
	        
            mydb.beginTransaction();
            try {
            	mydb.execSQL("UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?", new Object[] {imageValue, keyValue} );
                //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
                mydb.setTransactionSuccessful();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                // transaction over
            	mydb.endTransaction();
            	mydb.close();
            }	        	        	               	
        }
                
	    public String Select(String selectQuery) {	 //return String
	    	
		     String row = "";
		     String rows = "";
		     String colValue;		     
		     String headerRow;
		     int colCount;	    	
		     int i;
		     String allRows = null;
		      		     		     
		     try{
		    	   this.cursor = null; //[by renabor] without this a second query will find the Cursor randomly positioned!!!
		           if (mydb!= null) {
		               if (!mydb.isOpen()) {
		                  mydb = this.Open();
		               }
		            }
		            cursor  = mydb.rawQuery(selectQuery, null);		       
		        	
		            colCount = cursor.getColumnCount();
		        
		            headerRow = "";
		            for (i = 0; i < colCount; i++) {
		            	headerRow = headerRow + cursor.getColumnName(i) + selectColDelimiter;
		            } 
		            headerRow = headerRow.substring(0, headerRow.length() - 1);
		            if(cursor.moveToFirst()){
		                do{
		                	 row ="";	   
		                	 colValue = "";		                	 		                	
		                     for (i = 0; i < colCount; i++) {		                    	 	 
		                    	 switch (cursor.getType(i)) {                
		                    	   case Cursor.FIELD_TYPE_INTEGER: colValue = Integer.toString(cursor.getInt(i));           break;
		                    	   case Cursor.FIELD_TYPE_STRING : colValue =  cursor.getString(i);                         break;
		                    	   case Cursor.FIELD_TYPE_FLOAT  : colValue =  String.format("%.3f", cursor.getFloat(i));  break;
		                    	   case Cursor.FIELD_TYPE_BLOB   : colValue = "BLOB";                                       break;
		                    	   case Cursor.FIELD_TYPE_NULL   : colValue = "NULL";                                       break;
		                    	   default:                        colValue = "UNKNOW";                              
		                     	 }
		                    	 row = row + colValue + selectColDelimiter ;
		                      }
		                      row = row.substring(0, row.length() - 1); 
		                      rows = rows + row + selectRowDelimiter;
		                      
		                }
		                while(cursor.moveToNext());
		            }		            		           
		            mydb.close();
		            cursor.moveToFirst();		            
		            allRows = headerRow + selectRowDelimiter + rows;
		          		      
		     }catch(SQLiteException se){
		         Log.e(getClass().getSimpleName(), "Could not select:" + selectQuery);
		     }	    		      
		     return allRows; 
	    }
	    	    
	    public boolean Select(String selectQuery,  boolean moveToLast) {   //just set the cursor! return void..
	    	    boolean result = true;
	    	    this.cursor = null;
		        try{  		        	
			        if (mydb!= null) {
			           if (!mydb.isOpen()) {
			              mydb = this.Open(); //controls.activity.openOrCreateDatabase(DATABASE_NAME, Context.MODE_PRIVATE, null); 
			           }
			        }		        			        				     	         
			     	this.cursor  = mydb.rawQuery(selectQuery, null);
			     	       this.cursor.moveToFirst(); 	
			        mydb.close();			       
			     }catch(SQLiteException se){
			         Log.e(getClass().getSimpleName(), "Could not select:" + selectQuery);
			     }	     				        
		         return true;
		}

	    public Cursor GetCursor() {
    	    return this.cursor;
	    }
	    
        //ex. "CREATE TABLE IF NOT EXISTS TABLE1  (_ID INTEGER PRIMARY KEY, NAME TEXT, PLACE TEXT);"
	    public void CreateTable(String query){
	       this.ExecSQL(query);	      
	    }

	    //ex: "INSERT INTO TABLE1 (NAME, PLACE) VALUES('CODERZHEAVEN','GREAT INDIA')"
	    public void InsertIntoTable(String query){
	       this.ExecSQL(query);	            
	    }
	    
	    //ex: "UPDATE TABLE1 SET NAME = 'MAX' WHERE PLACE = 'USA'"
	    public void UpdateTable(String query){
	        this.ExecSQL(query);	        
	    }
	    
	    //ex: "DELETE FROM TABLE1  WHERE PLACE = 'USA'";
	    public void DeleteFromTable(String query){
	       this.ExecSQL(query);	       
	    }
	    
	    //ex:  "TABLE1" 
	    public void DropTable(String tbName){
	       this.ExecSQL("DROP TABLE " + tbName);	           
	    }
	    
		//Check if the database exist... 
		public boolean CheckDataBaseExists(String dbPath) {   
		      SQLiteDatabase checkDB = null; 
		      try {
		          String myPath = dbPath; //"data/data/com.example.appsqlitedemo1/databases/" + dbName;
		          checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
		      } catch (SQLiteException e) {
		    	  Log.e("SQLiteDatabase","database does't exist yet.");
		      } 
		      if (checkDB != null) {
	             checkDB.close();
		      }      	         
		      return checkDB != null ? true : false;
		}
	     
		public void Close() {
		   if (mydb != null)  { 	
		       if (mydb.isOpen()) { mydb.close();}
		   }
		}
		   
		public void Free() {
		   if (mydb != null) {	
		      if (mydb.isOpen()) { mydb.close();}
		      mydb = null;
		   }
		}		
						
		//news! version 06 rev. 08 15 december 2014.........................
		
		public void SetForeignKeyConstraintsEnabled(boolean _value) {
			if (mydb!=null)
		  	  mydb.setForeignKeyConstraintsEnabled(_value);			
		}
		
		public void SetDefaultLocale() {
			if (mydb!=null)
			   mydb.setLocale(Locale.getDefault());			
		}
						
		public void DeleteDatabase(String _dbName) {
		   controls.activity.deleteDatabase(_dbName);
		}
		
		/*
		 * ref, http://www.informit.com/articles/article.aspx?p=1928230
           Because SQLite is a single file, it makes little sense to try to store binary data in the database. 
           Instead store the location of data, as a file path or a URI in the database, and access it appropriately.           
		 */
        public void UpdateImage(String _tabName, String _imageFieldName, String _keyFieldName, String _imageResIdentifier, int _keyValue) {
        	ByteArrayOutputStream stream = new ByteArrayOutputStream();
        	Drawable d = GetDrawableResourceById(GetDrawableResourceId(_imageResIdentifier));        	
        	bufBmp = ((BitmapDrawable)d).getBitmap();       	        	       
        	bufBmp.compress(CompressFormat.PNG, 0, stream); 
        	//bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream);        	
            byte[] image_byte = stream.toByteArray();
            //Log.i("UpdateImage","UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?");                       
	        if (mydb!= null) {
		         if (!mydb.isOpen()) {
		              mydb = this.Open();
		         }
		     }
            mydb.beginTransaction();
            try {
            	mydb.execSQL("UPDATE " + _tabName + " SET "+_imageFieldName+" = ? WHERE "+_keyFieldName+" = ?", new Object[] {image_byte, _keyValue} );
                //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
                mydb.setTransactionSuccessful();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                // transaction over
            	mydb.endTransaction();
            	mydb.close();
            }	                	       
        	//Log.i("UpdateImage", "Ok. Image Updated!");
        	bufBmp = null;
        }	
                 
        public void InsertIntoTableBatch(String[] _insertQueries) {
        	int i; 
        	int len = _insertQueries.length;               
        	for (i=0; i < len; i++) {
                	this.ExecSQL(_insertQueries[i]);
            }
        }
        
        public void UpdateTableBatch(String[] _updateQueries) {
        	int i; 
        	int len = _updateQueries.length;               
        	for (i=0; i < len; i++) {
               	this.ExecSQL(_updateQueries[i]);
            }
        }
        
		//Check if the database exist... 
		public boolean CheckDataBaseExistsByName(String _dbName) {   
		      SQLiteDatabase checkDB = null; 
		      try {
		    	  String absPath = this.controls.activity.getFilesDir().getPath();
	              absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/databases/"+_dbName;		         
		          checkDB = SQLiteDatabase.openDatabase(absPath, null, SQLiteDatabase.OPEN_READONLY);
		      } catch (SQLiteException e) {
		    	  Log.e("jSqliteDataAccess","database does't exist yet!");
		      } 
		      if (checkDB != null) {
	             checkDB.close();
		      }      	         
		      return checkDB != null ? true : false;
		}
		
		//ex. 'tablebook|FIGURE|_ID|ic_t1|1'
        private void SplitUpdateImageData(String _imageResIdentifierData, String _delimiter) {
        	String[] tokens = _imageResIdentifierData.split("\\"+_delimiter);  //ex. "|"        	        
        	String _tabName = tokens[0];
        	String _imageFieldName = tokens[1]; 
        	String _keyFieldName = tokens[2];
        	String _imageResIdentifier = tokens[3];         	        
        	int _keyValue = Integer.parseInt(tokens[4]);
        	UpdateImage(_tabName, _imageFieldName, _keyFieldName, _imageResIdentifier, _keyValue) ;
        }
        
        public void UpdateImageBatch(String[] _imageResIdentifierDataArray, String _delimiter) {
        	int i; 
        	int len = _imageResIdentifierDataArray.length;        	
        	for (i=0; i < len; i++) {
               	this.SplitUpdateImageData(_imageResIdentifierDataArray[i], _delimiter);
            }
        }		
}


/*Draft java code by "Lazarus Android Module Wizard"*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jMyHello /*extends ...*/ {         

        private long     pascalObj = 0;      // Pascal Object
        private Controls controls  = null;   // Control Class for events
        private Context  context   = null;

        private int    mFlag = 0;          // <<----- custom property
        private String mMsgHello = ""; // <<----- custom property 
        private int[]  mBufArray;      // <<----- custom property

        public jMyHello(Controls _ctrls, long _Self, int _flag, String _hello) { //Add more '_xxx' params if needed!

          //super(_ctrls.activity);
          context   = _ctrls.activity;
          pascalObj = _Self;
          controls  = _ctrls;

          mFlag = _flag;
          mMsgHello = _hello;
          mBufArray = null;
          //Log.i("jMyHello", "Create!");          
        }

        public void jFree() {
          //free local objects...
           mBufArray = null;
        }

       //write others [public] methods code here......  <<----- customs methods

        public void SetFlag(int _flag) {  
           mFlag =  _flag;   
        }

        public int GetFlag() {
           return mFlag;   
        }

        public void SetHello(String _hello) {
        	mMsgHello =  _hello;   
        }

        public String GetHello() {
           return mMsgHello;   
        }
        
        public String[] GetStringArray() { 
        	String[] strArray = {"Helo", "Pascal", "World"};
            return strArray;   
        }
        
        
        public String[] ToUpperStringArray(String[] _msgArray) { 
        	int size = _msgArray.length;
        	String[] resStr = new String[size];
        	for (int i = 0; i < size; i++) {
        		resStr[i]= _msgArray[i].toUpperCase();
        	}
            return resStr;   
        }
      
        public String[] ConcatStringArray(String[]  _strArrayA, String[]  _strArrayB) {
        	
        	int size1 = _strArrayA.length;
        	int size2 = _strArrayB.length;
        	
        	String[] resStr = new String[size1+size2];
        	
        	for (int i = 0; i < size1; i++) {
        	  resStr[i]= _strArrayA[i];
        	}
        	
        	int j = size1;
        	for (int i = 0; i < size2; i++) {
        	  resStr[j]= _strArrayB[i];
        	  j++;
        	}
        	
            return resStr;
        }
        
        public int[] GetIntArray() {
        	int[] mIntArray = {1, 2, 3};
            return mIntArray;
        }

        public int[] GetSumIntArray(int[] _vA, int[] _vB, int _size) {

           mBufArray = new int[_size];

           for (int i=0; i < _size; i++) {
              mBufArray[i] = _vA[i] + _vB[i];
           }
           return mBufArray;
        }
                
        public void ShowHello() {
           Toast.makeText(controls.activity, mMsgHello, Toast.LENGTH_SHORT).show();  	      
        }        
}

/*Draft java code by "Lazarus Android Module Wizard"*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jDumpJavaMethods /*extends ...*/ {         

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class Java/Pascal Interface ...
    private Context  context   = null;

    private boolean mStripFullTypeName;                           
    private String  mFullJavaClassName= "";   //ex: "android.media.MediaPlayer", "java.util.List" etc..    
    private String  mMethodFullSignature= "";
    private String  mMethodImplementation= "";
    private String  mObjReferenceName= ""; //now it is not null!!!
    private String  mDelimiter= "";
    private String  mMethodHeader= "";
    
    ArrayList<String> mListMethodHeader = new ArrayList<String>();                         
    ArrayList<String> mListNoMaskedMethodImplementation = new ArrayList<String>();    
       
    String mNoMaskedMethodImplementation="";
        
    public jDumpJavaMethods(Controls _ctrls, long _Self, String _fullJavaClassName) { //Add more '_xxx' params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;      
      controls  = _ctrls;
      
      mFullJavaClassName = _fullJavaClassName;     
      mDelimiter =  "|";
      
      mObjReferenceName = "this";
      mStripFullTypeName = true;
      
      //Log.i("jDumpJavaMethods", "Created!");                
    }

    public void jFree() {
      //free local objects...
    	mListMethodHeader = null;
    	mListNoMaskedMethodImplementation = null;
    }

   //write others [public] methods code here...... 
    
   public String GetMethodFullSignatureList() {
	      return mMethodFullSignature;
   }

   public String GetMethodImplementationList() {
	   return mMethodImplementation;
   }
   
    public void SetStripFullTypeName(boolean _stripFullTypeName) {  
    	mStripFullTypeName =  _stripFullTypeName;   
    }

    public boolean GetStripFullTypeName() {
       return mStripFullTypeName;   
    }

    public void SetFullJavaClassName(String _fullJavaClassName) {
    	mFullJavaClassName =  _fullJavaClassName;   
    }

    public String GetFullJavaClassName() {
       return mFullJavaClassName;   
    }
   
    public void SetObjReferenceName(String _objReferenceName) {
       mObjReferenceName = _objReferenceName;
    }

    public String GetObjReferenceName() {
        return mObjReferenceName;
    }

    public void SetDelimiter(String _delimiter) {
        mDelimiter = _delimiter;
     }

     public String GetDelimiter() {
         return mDelimiter;
     }

     public String GetMethodHeaderList() {
        return mMethodHeader;
     }
     
     public int GetMethodHeaderListSize(){
        	return mListMethodHeader.size();
     }     
  
     public String GetMethodHeaderByIndex(int _index){
      	return mListMethodHeader.get(_index);
     }
              
     public void MaskMethodHeaderByIndex(int _index){
    	String strSave = mListMethodHeader.get(_index); 
    	mListMethodHeader.set(_index, mDelimiter+strSave);
     }

     public void UnMaskMethodHeaderByIndex(int _index){
    	String strSave = (mListMethodHeader.get(_index)).substring(1); 
    	mListMethodHeader.set(_index, strSave);
     }
                                          
     public String GetNoMaskedMethodHeaderList() {
    	 String strRet= "";
    	 for(int i=0; i < mListMethodHeader.size(); i++) {
    		 if (mListMethodHeader.get(i).charAt(i) != '|') {
    			 if (i != (mListMethodHeader.size()-1) ) {  
    		        strRet = strRet + mListMethodHeader.get(i) + mDelimiter;
    			 }else {
    				strRet = strRet + mListMethodHeader.get(i); 
    			 }
    		     //Log.i("Dump_List_Header", mListMethodHeader.get(i));
    		 }
    	 }
    	 if ( strRet.length() == 0 ) {strRet = mDelimiter;}
    	 return strRet; 
     }
                               
     public String Extract() {
     	return Extract(mFullJavaClassName, mDelimiter);
     } 
      
     public String Extract(String _fullJavaClassName, String _delimiter) {
	      String str; 
	      String newStr1;
	      String newStr2;
	      String newStr3;
	      String finalStr1;
	      String finalStr2;
	      String params;
	      String auxParams;
	      String newParams;
	      String newItem;
	      String localRef;
	      String mainParam;
	      String mainItem;
	      String simpleParams="";
	      
	      int firstPos1;
	      int lastPos1;	      
	      
	      int lastPos2;	      
	      int countParams;
         //Toast.makeText(controls.activity, mMsgHello, Toast.LENGTH_SHORT).show();	      
	  try {		  
		 //String eol = System.getProperty("line.separator");		 
		 StringBuilder sbSignature = new StringBuilder();
		 StringBuilder sbImplementation = new StringBuilder();
		 StringBuilder sbHeader = new StringBuilder();
		 
         Class cls = Class.forName(_fullJavaClassName); 
         Method mth[] = cls.getDeclaredMethods();       //c.getMethods()
         
         for (int i = 0; i < mth.length; i++) {
             str= mth[i].toString(); 
        	 if (str.indexOf("private") < 0 && str.indexOf("static") < 0 &&
        		 str.indexOf("protected") < 0 && str.indexOf("$") < 0)       {
        		
        		newStr1 = str.replace(_fullJavaClassName+".", "");
        		newStr2 = newStr1.replace("native ", "");
        		                                
        		firstPos1= newStr2.lastIndexOf("(");
        		lastPos1 = newStr2.lastIndexOf(")");
        		
        		countParams = 0;            		
        		params = "";
        		auxParams= "";            		       
        		newParams= "";
        		simpleParams = "";
        		
        		if (lastPos1 > firstPos1+2) {
        			params = newStr2.substring(firstPos1+1, lastPos1);
        			countParams = 1;        		
        			int index = params.indexOf(",");        			
        			if (index > 0) {        			   
        		        String[] items = params.split(",");
        		        countParams = items.length;
        		        newItem = items[0];        	        		        
        		        mainItem = newItem;  
        		        lastPos2 = mainItem.lastIndexOf(".");        		        
        		        if (lastPos2 > 0) {
        		           mainItem = newItem.substring(lastPos2+1);
        		        }        		     
        		        if (mStripFullTypeName) {
        		        	newItem = mainItem;        		        
        		        }
        		        auxParams = "_"+mainItem.charAt(0)+"0";
        				newParams = newItem + " _"+mainItem.charAt(0)+"0";
        				simpleParams = mainItem;
        				
        		        for (int k = 1; k < items.length; k++) {        		                    		        
        		            newItem = items[k];  
        		            lastPos2 = newItem.lastIndexOf(".");        		           
        		            mainItem = newItem;
        		            
        		            if (lastPos2 > 0) {
             		           mainItem = newItem.substring(lastPos2+1);
             		        }
        		            
            		        auxParams = auxParams + ",_"+mainItem.charAt(0)+k;
        		            if (mStripFullTypeName) {
            		        	newItem = mainItem;            		        	
        		            }     
        		            newParams = newParams + ","+newItem+" _"+mainItem.charAt(0)+k;
        		            simpleParams =  simpleParams + "," + mainItem;
        		        }        		        
        			}
        			else {                			    
        				mainParam = params;
        				lastPos2 = params.lastIndexOf(".");    		        
    		        	if (lastPos2 > 0) {
    		        		mainParam = params.substring(lastPos2+1);                                                        
    		        	}
    		        	auxParams = "_"+mainParam.charAt(0)+"0";   		        	
        				newParams = params + " " + auxParams;
        				        				        				
        				if (mStripFullTypeName) {        				        					
       		        		newParams = mainParam + " " + auxParams; 
        				}
        				simpleParams =  mainParam;
        			}
        		}
        		            		
        		newStr3 = newStr2.substring(0,lastPos1+1);        		        	
        		String[] splitedStr = newStr3.split("\\s+");
        		String input = splitedStr[splitedStr.length-1];        		
        		String output = Character.toUpperCase(input.charAt(0)) + input.substring(1);
        		
        		finalStr1 = "";
        		for (int j= 0; j < splitedStr.length-1; j++) {
        		   finalStr1 = finalStr1 + " " + splitedStr[j];        		
        		}        		        		        		                		
        		if (mObjReferenceName.equals("this")) {        		   
        		   localRef = "this.";  
        	    }else{
        	    	localRef = mObjReferenceName+".";  
        	    }        		        		        		
        		
        		String innerStr0 = splitedStr[splitedStr.length-1];
        		String innerStr1 = innerStr0;
        		if (countParams > 0) {
           			int p= innerStr0.indexOf("(");       			
           			innerStr1 = innerStr0.substring(0, p)+"(" + auxParams + ")"; 
           		}	
           		
           		String newOutput= output;
           		if ( countParams > 0 ) {        			
           			int p1 = output.indexOf("(");       			
           			newOutput = output.substring(0, p1)+"(" + newParams + ")";       			
           		}
           		           		
           		if (finalStr1.contains(" void")) {  //TODO: test! add public?         		        		   
        		   finalStr2 = "public"+finalStr1 + " " + newOutput + "{"+ localRef +innerStr1+ ";}";
           		}else{
           		   finalStr2 = "public"+finalStr1 + " " + newOutput + "{return "+ localRef +innerStr1+ ";}";
           		}
           		
        		sbSignature.append(params);               		
        		sbSignature.append(_delimiter);
        		//Log.i("Dump_Sign",params);
        		
        		sbImplementation.append(finalStr2);        		
        		sbImplementation.append(_delimiter);
        		//Log.i("Dump_Impl", finalStr2);
        		
         		//----Methods Signature Resume --------
        		
        		String head0 = splitedStr[1];        		
        		String head = head0;        		
        		if ( head0.indexOf(".") > 0) {
         			String[] listHead = head0.split("\\.");         			
         			head = listHead[listHead.length-1];         			
        		}        		      		
        		String tail0 = splitedStr[splitedStr.length-1];
        		String tail1 = tail0;
        		if (countParams > 0) {
        			int p2 = tail0.indexOf("(");
        			tail1 = tail0.substring(0,p2) + "(" + simpleParams + ")";
        					//tail0.replace(params, simpleParams);
        		}	

    		  	sbHeader.append(head+" "+tail1);            		  	
            	sbHeader.append(_delimiter);
            	//Log.i("Dump_Header::", head+" "+tail1);
            	mListMethodHeader.add(head+" "+tail1);
        	 }        	 
         }  
         
         mMethodFullSignature = sbSignature.toString();                  
         mMethodImplementation = sbImplementation.toString();        
         lastPos2 = (sbHeader.toString()).lastIndexOf(_delimiter);         
         mMethodHeader = (sbHeader.toString()).substring(0, lastPos2);          
    
         /* Test...
          MaskListMethodHeader(5);
          MaskListMethodHeader(10);
       	  Log.i("Dump_Lit_4", mListMethodHeader.get(4));
       	  Log.i("Dump_Lit_5", mListMethodHeader.get(5));
       	  Log.i("Dump_Lit_9", mListMethodHeader.get(9));
       	  Log.i("Dump_Lit_10", mListMethodHeader.get(10));
       	  Log.i("Dump_Lit_11", mListMethodHeader.get(11));
       	 */         
       	 
         GetNoMaskedMethodImplementationList();            
      }
      catch (Throwable e) {
         //System.err.println(e);
    	  //Log.i("Dump_error", e.toString());
      }
	  
	  return mMethodImplementation;
    }
    
    public String GetNoMaskedMethodImplementationByIndex(int _index){
       	return mListNoMaskedMethodImplementation.get(_index);
    }
      
    public int GetNoMaskedMethodImplementationListSize(){
        	return mListNoMaskedMethodImplementation.size();
    }     
    public String GetNoMaskedMethodImplementationList() {
	      String str; 	     
	      String newStr2;
	      String newStr3;
	      String finalStr1;
	      String finalStr2;
	      String params;
	      String auxParams;
	      String newParams;
	      String newItem;
	      String localRef;
	      
	      String mainParam;
	      String mainItem;	     
	      
	      int firstPos1;
	      int lastPos1;	      
	      	          
	      int countParams;
	      
	  try {		  
	    StringBuilder sbImplementation = new StringBuilder();	    
        String mth[] = mListMethodHeader.toArray(new String[mListMethodHeader.size()]);
        for (int i = 0; i < mth.length; i++) {
          str= mth[i].toString(); 
       	  if (str.indexOf(mDelimiter)< 0)       {       		
       		newStr2 = str;       		
       		firstPos1= newStr2.lastIndexOf("(");
       		lastPos1 = newStr2.lastIndexOf(")");
       		countParams = 0;            		
       		params = "";
       		auxParams= "";            		       
       		newParams= "";
       		
       		if (lastPos1 > firstPos1+2) {
       			params = newStr2.substring(firstPos1+1, lastPos1);
       			countParams = 1;        		
       			int index = params.indexOf(",");        			
       			if (index > 0) {        			   
       		        String[] items = params.split(",");
       		        countParams = items.length;
       		        newItem = items[0];        	        		        
       		        mainItem = newItem;  
       		        
       		        auxParams = "_"+mainItem.charAt(0)+"0";
       				newParams = newItem + " _"+mainItem.charAt(0)+"0";
       				       			
       		        for (int k = 1; k < items.length; k++) {        		                    		        
       		            newItem = items[k];  
       		            mainItem = newItem;       		                   		            
           		        auxParams = auxParams + ",_"+mainItem.charAt(0)+k;       		             
       		            newParams = newParams + ","+newItem+" _"+mainItem.charAt(0)+k;       		            
       		        }        		        
       			}
       			else {                			    
       				mainParam = params;       				
   		        	auxParams = "_"+mainParam.charAt(0)+"0";   		        	
       				newParams = params + " " + auxParams;
       			}
       		}
       		
       		newStr3 = newStr2.substring(0,lastPos1+1);        		        	
       		String[] splitedStr = newStr3.split("\\s+");
       		
       		String input = splitedStr[splitedStr.length-1];        		
       		String output = Character.toUpperCase(input.charAt(0)) + input.substring(1);
       		
       		finalStr1 = "";
       		for (int j= 0; j < splitedStr.length-1; j++) {
       		   finalStr1 = finalStr1 + " " + splitedStr[j];
       		   
       		} 
       		       	
       		if (mObjReferenceName.equals("this")) {       		  
       		  localRef = "this."; 
       	    }else{
       	      localRef = mObjReferenceName+"."; 
       	    }
       		
       		String innerStr0 = splitedStr[splitedStr.length-1];
       		
       		String innerStr1 = innerStr0;       		       		
       		if (countParams > 0) {
       			int p= innerStr0.indexOf("(");       			
       			innerStr1 = innerStr0.substring(0, p)+"(" + auxParams + ")"; 
       		}	
       		
       		String newOutput= output;
       		if ( countParams > 0 ) {        			
       			int p1 = output.indexOf("(");       			
       			newOutput = output.substring(0, p1)+"(" + newParams + ")";       			
       		}	       		
       		
       		
       		if (finalStr1.contains(" void")) {           		
       			finalStr2 = "public"+finalStr1 + " " + newOutput + "{"+ localRef +innerStr1+ ";}";
       		}else{
       			finalStr2 = "public"+finalStr1 + " " + newOutput + "{return "+ localRef +innerStr1+ ";}";
       		}
       		
       		//finalStr2 = "public"+finalStr1 + " " + newOutput + "{"+ localRef +innerStr1+ ";}";
       		
       		sbImplementation.append(finalStr2);        		
       		sbImplementation.append(mDelimiter);
       		//Log.i("Dump_Produce", finalStr2);
       		
       		mListNoMaskedMethodImplementation.add(finalStr2);
       	 }        	 
        }
        mNoMaskedMethodImplementation = sbImplementation.toString();;
     }
     catch (Throwable e) {
        //System.err.println(e);
   	  //Log.i("Dump_NoMaskedImpl_error", e.toString());
     }
	 return mNoMaskedMethodImplementation;
   }
           
}

/*Draft java code by "Lazarus Android Module Wizard"*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jTextFileManager /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    
    private ClipboardManager mClipBoard = null;
    private ClipData mClipData = null;
    
    private Intent intent = null;
    
    //Warning: please, preferentially init your news params names with "_", ex: int _flag, String _hello ...

    public jTextFileManager(Controls _ctrls, long _Self) { //Add more here new "_xxx" params if needed!
       //super(contrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;      
       mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);       
       intent = new Intent();
       intent.setAction(Intent.ACTION_SEND);
       intent.setType("text/plain");      
    }

    public void jFree() {
      //free local objects...
    	mClipBoard = null;
    	intent = null;
    }
    
    
    public void CopyToClipboard(String _text) {
    	mClipData = ClipData.newPlainText("text", _text);
        mClipBoard.setPrimaryClip(mClipData);
    }
       
    public String PasteFromClipboard() {
        ClipData cdata = mClipBoard.getPrimaryClip();
        ClipData.Item item = cdata.getItemAt(0);
        String txt = item.getText().toString();
        return txt;
    }    

   //write others [public] methods code here......
   //Warning: please, preferentially init your news params names with "_", ex: int _flag, String _hello ...
    
   //http://thedevelopersinfo.com/2009/11/26/using-filesystem-in-android/
   //http://tausiq.wordpress.com/2012/06/16/readwrite-text-filedata-in-android-example-code/
   //if you want to save/preserve the old data then you need to open the file in MODE_APPEND, not MODE_PRIVATE
    
   //***if you want to get your file you should look at: data/data/your_package/files/your_file_name !!!!
   public void SaveToFile(String _txtContent, String _filename) {	  	 
     try {
         OutputStreamWriter outputStreamWriter = new OutputStreamWriter(context.openFileOutput(_filename, Context.MODE_PRIVATE));
         //outputStreamWriter.write("_header");
         outputStreamWriter.write(_txtContent);
         //outputStreamWriter.write("_footer");
         outputStreamWriter.close();
     }
     catch (IOException e) {
        // Log.i("jTextFileManager", "SaveToFile failed: " + e.toString());
     }
   }

   public void SaveToFile(String _txtContent, String _path, String _filename){
	     FileWriter fWriter;     
	     try{ // Environment.getExternalStorageDirectory().getPath()
	          fWriter = new FileWriter(_path +"/"+ _filename);
	          fWriter.write(_txtContent);
	          fWriter.flush();
	          fWriter.close();
	      }catch(Exception e){
	          e.printStackTrace();
	      }
	   }   
   public String LoadFromFile(String _filename) {

     String retStr = "";

     try {
         InputStream inputStream = context.openFileInput(_filename);

         if ( inputStream != null ) {
             InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
             BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
             String receiveString = "";
             StringBuilder stringBuilder = new StringBuilder();

             while ( (receiveString = bufferedReader.readLine()) != null ) {
                 stringBuilder.append(receiveString);
             }

             inputStream.close();
             retStr = stringBuilder.toString();
         }
     }
     catch (IOException e) {
        // Log.i("jTextFileManager", "LoadFromFile error: " + e.toString());
     }

     return retStr;
   }
     
   public String LoadFromFile(String _path, String _filename) {
	     char buf[] = new char[512];
	     FileReader rdr;
	     String contents = "";  //new File(Environment.getExternalStorageDirectory(), "alert.txt");
	     try {                  // Environment.getExternalStorageDirectory().getPath() --> /sdcard
	         rdr = new FileReader(_path+"/"+_filename);
	         int s = rdr.read(buf);
	         for(int k = 0; k < s; k++){
	             contents+=buf[k];
	         }
	         
	         rdr.close();
	     } catch (Exception e) {
	         e.printStackTrace();
	     }
	     return contents;
	   }
   
   //http://manojprasaddevelopers.blogspot.com.br/search/label/Write%20and%20ReadFile
      
   //http://www.coderzheaven.com/2012/01/29/saving-textfile-to-sdcard-in-android/
   public void SaveToSdCard(String _txtContent, String _filename){
     FileWriter fWriter;     
     try{ // Environment.getExternalStorageDirectory().getPath()
          fWriter = new FileWriter(Environment.getExternalStorageDirectory().getPath() +"/"+ _filename);
          fWriter.write(_txtContent);
          fWriter.flush();
          fWriter.close();
      }catch(Exception e){
          e.printStackTrace();
      }
   }
   
   public String LoadFromSdCard(String _filename){
     char buf[] = new char[512];
     FileReader rdr;
     String contents = "";  //new File(Environment.getExternalStorageDirectory(), "alert.txt");
     try {  // Environment.getExternalStorageDirectory().getPath() --> /sdcard
         rdr = new FileReader(Environment.getExternalStorageDirectory().getPath()+"/"+_filename);
         int s = rdr.read(buf);
         for(int k = 0; k < s; k++){
             contents+=buf[k];
         }
         
         rdr.close();
     } catch (Exception e) {
         e.printStackTrace();
     }
     return contents;
   }
   
   //https://xjaphx.wordpress.com/2011/10/02/store-and-use-files-in-assets/    
   public String LoadFromAssets(String _filename) {
	   String str;
       // load text
       try {
    	   //Log.i("loadFromAssets", "name: "+_filename);
           // get input stream for text
           InputStream is = controls.activity.getAssets().open(_filename);
           // check size
           int size = is.available();
           // create buffer for IO
           byte[] buffer = new byte[size];
           // get data to buffer
           is.read(buffer);
           // close stream
           is.close();
           // set result to TextView
           str = new String(buffer);
           //Log.i("loadFromAssets", ":: "+ str);
           return str.toString();
       }
       catch (IOException ex) {
    	   //Log.i("loadFromAssets", "error!");
           return "";
       }       
   }
   
   public void CopyContentToClipboard(String _filename) {
   	 String txt = LoadFromFile(_filename);
   	 mClipData = ClipData.newPlainText("text", txt);
     mClipBoard.setPrimaryClip(mClipData);
   }
   
   public void PasteContentFromClipboard(String _filename) {
      ClipData cdata = mClipBoard.getPrimaryClip();
      ClipData.Item item = cdata.getItemAt(0);
      String txt = item.getText().toString();
      SaveToFile(txt, _filename);
   }
   
   public String LoadFromByteArray(byte[] _byteArray) {  //TODO Pascal
	   return (new String(_byteArray));   
   }
      

}




/*Draft java code by "Lazarus Android Module Wizard"*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//http://www.javatpoint.com/playing-audio-in-android-example
//http://www.learn-android-easily.com/2013/09/android-mediaplayer-example.html
//https://software.intel.com/en-us/forums/topic/277068
//http://www.streamhead.com/android-tutorial-sd-card/
	

class jMediaPlayer implements OnPreparedListener, OnVideoSizeChangedListener, OnCompletionListener, OnTimedTextListener {

	  private long pascalObj = 0;           // Pascal Object
	  private Controls controls  = null;    // Control Class for events
	  private Context  context   = null;
		
	  private MediaPlayer mplayer;
	  
	  public jMediaPlayer (Controls _ctrls, long _Self) {	    	     
	     //super(_ctrls.activity);
	     pascalObj = _Self ;
		 controls  = _ctrls;
		 context   = _ctrls.activity;		   
		 this.mplayer = new MediaPlayer();		 
		 this.mplayer.setOnPreparedListener(this);
		 this.mplayer.setOnVideoSizeChangedListener(this);
		 this.mplayer.setOnCompletionListener(this);
		 this.mplayer.setOnTimedTextListener(this);		
	  }
	  
	  public void jFree() {
	    //free local objects...
		mplayer.release();
	  	mplayer = null;
	  }
	      
	  public void DeselectTrack(int _index){
	  	this.mplayer.deselectTrack(_index);
	  }
	  
	  /*
	   * call the release method on your Media Player object to free the resources associated with the MediaPlayer
	   */
	  public void Release(){ 
	  	this.mplayer.release();
	  }
	  
	  public void Reset(){
	  	this.mplayer.reset();
	  }
	      
	  public void SetDataSource(String _path){
		 
		 if (this.mplayer != null) { 
			 this.mplayer.stop();
			 this.mplayer.reset();  //the object is like being just created....
			 /*
			  * Resets the MediaPlayer to its uninitialized state. After calling this method, 
	            we will have to initialize it again by setting the data source and calling prepare(). 
			  */
		 } else {this.mplayer = new MediaPlayer();}
		  
		 if (_path.indexOf("://") > 0) {
			  Uri uri0 = Uri.parse(_path);                //ex. "http://site.com/audio/audio.mp3"
			  try{                                        //    "file:///sdcard/localfile.mp3" 
			     this.mplayer.setDataSource(context, uri0);
			  }catch (IOException e){
				 e.printStackTrace();	
			  }
		 }else if (_path.indexOf("DEFAULT_RINGTONE_URI") >= 0){			 
			 //Log.i("jMediaPlayer", "DEFAULT_RINGTONE_URI");			 
	         try{ 
	              this.mplayer.setDataSource(context, Settings.System.DEFAULT_RINGTONE_URI);
	         }catch (IOException e){
	        	  //Log.i("jMediaPlayer", "RINGTONE ERROR");
	  	          e.printStackTrace();  	         
	         }	         
		 }else if (_path.indexOf("sdcard") >= 0){ //Environment.getExternalStorageDirectory().getPath()		 
			 String sdPath =Environment.getExternalStorageDirectory().getPath();		 
			 String newPath;     
			 int p1 = _path.indexOf("sdcard/", 0);		 
			 if ( p1 >= 0) {		  	 		 		   		   		   
			   int p2 = p1+6;			 
			   newPath = sdPath +  _path.substring(p2);						  			   
	  		    try{                                
			       this.mplayer.setDataSource(newPath);  //    "/sdcard/music/tarck1.mp3"
			    }catch (IOException e){
		           e.printStackTrace();	
	            }	           		   	  		   	  		   
		      } else {	    	 
		    	 String initChar = _path.substring(0,1);	    	 
		    	 if (! initChar.equals("/")) {newPath = sdPath + '/'+ _path;}
		    	 else {
		    		 newPath = sdPath + _path;
		    	 }		    	 		    	 
	  		     try{                                
		               this.mplayer.setDataSource(newPath);  //    "/sdcard/music/tarck1.mp3"
		 		 }catch (IOException e){
		 	            e.printStackTrace();	
		         }
	     	 }		 	
		 }else {
			 //Log.i("jMediaPlayer", "loadFromAssets: "+ _path);
			 AssetFileDescriptor afd;
			 try {
			 	afd = controls.activity.getAssets().openFd(_path);
			 	this.mplayer.setDataSource(afd.getFileDescriptor(),afd.getStartOffset(),afd.getLength());  
			 } catch (IOException e1) {
				e1.printStackTrace();
			 }            	     
		 }	 
	  }	    	
	    
	  //for files, it is OK to call prepare(), which blocks until MediaPlayer is ready for playback...
	  public void Prepare(){	 //prepares the player for playback synchronously.
	  	try {
	  		   this.mplayer.prepare();		
			} catch (IOException e) {
				e.printStackTrace();		
		    }
	  }
	  
	  //TODO:  prepareAsync()  
	  
	  public void Start(){	 //it starts or resumes the playback.
	  	 this.mplayer.start();
	  }
	  
	  /*
	   * Once in the Stopped state, playback cannot be started
	   * until prepare() or prepareAsync() are called to set the MediaPlayer object to the Prepared state again.
	   */
	  public void Stop(){	 //it stops the playback.
	  	 this.mplayer.stop();
	  }
	  
	  public void Pause(){	 //it pauses the playback.
	  	 this.mplayer.pause();
	  }
	  
	  public boolean IsPlaying(){	 //checks if media player is playing.
	  	return this.mplayer.isPlaying();
	  }
	  
	  public void SeekTo(int _millis){	 //seeks to specified time in miliseconds.
	  	this.mplayer.seekTo(_millis);	
	  }
	  
	  public void SetLooping(boolean _looping){	 //sets the player for looping or non-looping.
	  	this.mplayer.setLooping(_looping);
	  }
	  
	  public boolean IsLooping(){	 //checks if the player is looping or non-looping.
	  	return this.mplayer.isLooping();
	  }
	  
	  public void SelectTrack(int _index){	 //it selects a track for the specified index.
		  this.mplayer.selectTrack(_index);
	  }
	  
	  public int GetCurrentPosition(){	 //returns the current playback position.
	  	return this.mplayer.getCurrentPosition();
	  }

	  public int GetDuration(){	 //returns duration of the file.
	  	return this.mplayer.getDuration();
	  }
	  
	  /*
	    setVolume takes a scalar float value between 0 and 1 for both the left and right channels (where 0 is silent and 1 is
	    maximum volume) ex. mediaPlayer.setVolume(1f, 0.5f);
	  */
	  
	  public void SetVolume(float _leftVolume,float _rightVolume){
	  	 this.mplayer.setVolume(_leftVolume, _rightVolume);
	  }
	 
	  
	 //called onsurfaceCreated!
	  public void SetDisplay(android.view.SurfaceHolder _surfaceHolder) {
		 this.mplayer.setAudioStreamType (AudioManager.STREAM_MUSIC);
		 this.mplayer.setDisplay(_surfaceHolder);		      		  				 
	  }
	  
	  //http://alvinalexander.com/java/jwarehouse/android-examples/samples/android-8/ApiDemos/src/com/example/android/apis/media/MediaPlayerDemo_Video.java.shtml
	 
	  @Override
	  /*.*/public void onPrepared(MediaPlayer mediaplayer) {		    
		    controls.pOnMediaPlayerPrepared(pascalObj, mplayer.getVideoWidth(), mplayer.getVideoHeight());
	   }
	  
	  @Override
	  /*.*/public void onVideoSizeChanged(MediaPlayer mp, int width, int height) { 		
			controls.pOnMediaPlayerVideoSizeChanged(pascalObj, width, height);
	  }
	  
	  @Override
	  /*.*/public void onCompletion(MediaPlayer arg0) {
		    controls.pOnMediaPlayerCompletion(pascalObj);
	  }
	  	  
	  /* (non-Javadoc)
	 * @see android.media.MediaPlayer.OnTimedTextListener#onTimedText(android.media.MediaPlayer, android.media.TimedText)
	 */
  	 @Override
	  /*.*/public void onTimedText(MediaPlayer arg0, TimedText timedText) {	
  		   controls.pOnMediaPlayerTimedText(pascalObj, timedText.getText());		
	  }	
  	 	  
	  public int GetVideoWidth() {
		   return mplayer.getVideoWidth();
	  }
	  
	  public int GetVideoHeight() {
		  return mplayer.getVideoHeight();
	  }
	  
  	  public void SetScreenOnWhilePlaying(boolean _value) {
		  mplayer.setScreenOnWhilePlaying(_value);
  	  }	  		   	    	  
  	    	
  	  public void SetAudioStreamType (int _audioStreamType) { 
  		  if (_audioStreamType < 6)
		     mplayer.setAudioStreamType(_audioStreamType);
  	  }	 
} 

/*Draft java code by "Lazarus Android Module Wizard" [4-5-14 20:46:56]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jMenu /*extends ...*/ {
  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    private Menu     mMenu     = null;
    private SubMenu[] mSubMenus;
    private int mCountSubMenu = 0;
  
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jMenu (Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       mMenu     = null;
       mSubMenus = new SubMenu[19]; //max sub menus number = 20!
       mCountSubMenu = 0;
    }
  
    public void jFree() {
        //free local objects...
        if (mMenu != null){	
        	  for(int i=0; i < mCountSubMenu; i++){
        		 mSubMenus[i] = null;
        	  }    
        	  mCountSubMenu = 0;
        	  mMenu.clear();
        }
        
    }
  
    
    //http://android-developers.blogspot.com.br/2012/01/say-goodbye-to-menu-button.html 
    /*
     * ... if you do not want an action bar: set targetSdkVersi to 13 or below ....!! 
     */
    
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ... 
    
    /*
     * The overflow icon [...] only appears on phones that have no menu hardware keys. 
     * Phones with menu keys display the action overflow when the user presses the key.
     */
    
    public void Add(Menu _menu, int _itemID, String _caption){
      if (_menu != null) {
    	  mMenu = _menu;
          _menu.add(0,_itemID,0 ,(CharSequence)_caption); //return MenuItem          
      }
    }
        
    //TODO: ic_launcher.png just for test!
    public void AddDrawable(Menu _menu, int _itemID, String _caption){
       if (_menu != null) {	
    	  mMenu = _menu;
          String _resName = "ic_launcher"; //ok       
          MenuItem item = _menu.add(0,_itemID,0 ,(CharSequence)_caption);       
          item.setIcon(GetDrawableResourceId(_resName));          
       }
    }
    
    public void AddCheckable(Menu _menu, int _itemID, String _caption){
    	if (_menu != null) {
    	  mMenu = _menu;	
          _menu.add(0,_itemID,0 ,(CharSequence)_caption).setCheckable(true);          
    	}
     }
    
    public void CheckItemCommute(MenuItem _item){
    	int flag = 0;
    	if (_item.isChecked()) flag = 1;
    	switch (flag) {
    	  case 0: _item.setChecked(false); 
    	  case 1: _item.setChecked(true);
        }
  	    //Log.i("jMenu_CheckItemCommute", _item.getTitle().toString());
    }
    
    public void CheckItem(MenuItem _item){
       _item.setChecked(true);
       //Log.i("jMenu_CheckItem", _item.getTitle().toString());
    }
    
    public void UnCheckItem(MenuItem _item){
       _item.setChecked(false);       
   	   //Log.i("jMenu_UnCheckItem", _item.getTitle().toString());
    }    
    
    public void AddSubMenu(Menu _menu, int _startItemID, String[] _captions){    	
    	int size = _captions.length;
    	if (_menu != null) {      	   	
     	  if (size > 1) {
     		 mMenu = _menu;
    	     mSubMenus[mCountSubMenu] = _menu.addSubMenu((CharSequence)_captions[0]); //main title      	  
     	     mSubMenus[mCountSubMenu].setHeaderIcon(R.drawable.ic_launcher);      	       	   
    	     for(int i=1; i < size; i++) {    	
    		   MenuItem item = mSubMenus[mCountSubMenu].add(0,_startItemID+(i-1),0,(CharSequence)_captions[i]); //sub titles...    		       	    
    	     }    	   
    	     mCountSubMenu++;    	           	
    	  }   
    	}
    }

   //TODO: ic_launcher.png just for test!
    public void AddCheckableSubMenu(Menu _menu, int _startItemID, String[] _captions){
      if (_menu != null) {	    	
    	int size = _captions.length;
    	if (size > 1) {    	
    	   mMenu = _menu;	
    	   mSubMenus[mCountSubMenu] = _menu.addSubMenu((CharSequence)_captions[0]); //main title
    	   mSubMenus[mCountSubMenu].setHeaderIcon(R.drawable.ic_launcher);       	   
    	   //Log.i("jMenu_AddCheckableSubMenu", _captions[0]);
    	   for(int i=1; i < size; i++) {    	
    		  mSubMenus[mCountSubMenu].add(0,_startItemID+(i-1),0,(CharSequence)_captions[i]).setCheckable(true); //sub titles...
    	   }    	   
    	   mCountSubMenu++;    	   
    	}
      }
    }
    
    public int Size(){
    	if (mMenu != null)
    	   return mMenu.size();
    	else 
    	  return 0;   			
    }
    
    public MenuItem FindMenuItemByID(int _itemID){
    	if (mMenu != null) return mMenu.findItem(_itemID);
    	else return null;
    }

    public MenuItem GetMenuItemByIndex(int _index){
    	if (mMenu != null)
    	   return mMenu.getItem(_index);
    	else return null;
    }
    
    public void UnCheckAllMenuItem(){
      if (mMenu != null){	
    	 for(int index=0; index < mMenu.size(); index++){
    		mMenu.getItem(index).setChecked(false);
    	 }    	 
      } 	
    }
    
    public int CountSubMenus(){
       return mCountSubMenu; 	
    } 
    
    public void UnCheckAllSubMenuItemByIndex(int _subMenuIndex){
       if (mMenu != null){	
    	  if  (_subMenuIndex < mCountSubMenu) {    		      	  
      	    for(int i=0; i < mSubMenus[_subMenuIndex].size(); i++){
      		   mSubMenus[_subMenuIndex].getItem(i).setChecked(false);
      	    }
    	 }
       } 	
    }
    
    public void RegisterForContextMenu(View _view){
       controls.activity.registerForContextMenu(_view);
    }
        
    public void UnRegisterForContextMenu(View _view){ 
      controls.activity.unregisterForContextMenu(_view); 
    }  
    
//http://daniel-codes.blogspot.com.br/2009/12/dynamically-retrieving-resources-in.html
   //Just note that in case you want to retrieve Views (Buttons, TextViews, etc.) 
    //you must implement R.id.class instead of R.drawable.
    private int GetDrawableResourceId(String _resName) {
    	  try {
    	     Class<?> res = R.drawable.class;
    	     Field field = res.getField(_resName);  //"drawableName"
    	     int drawableId = field.getInt(null);
    	     return drawableId;
    	  }
    	  catch (Exception e) {
    	     Log.e("MyTag", "Failure to get drawable id.", e);
    	     return 0;
    	  }
    }
    
    private Drawable GetDrawableResourceById(int _resID) {   	    	 
    	 return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));
    }
    
    //_itemType --> 0:Default, 1:Checkable
    public void AddItem(Menu _menu, int _itemID, String _caption, String _iconIdentifier, int _itemType, int _showAsAction){
      if (_menu != null) {
    	 mMenu = _menu;
    	 MenuItem item = _menu.add(0,_itemID,0 ,(CharSequence)_caption);    			
    	 switch  (_itemType) {
    	    case 1:  item.setCheckable(true); break;    	
    	 }    	
         if (!_iconIdentifier.equals("")) {
           item.setIcon(GetDrawableResourceId(_iconIdentifier)); 
         }                     
         switch (_showAsAction) {
           case 0: item.setShowAsAction(MenuItem.SHOW_AS_ACTION_NEVER); break;
           case 1: item.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM); break;
           case 2: item.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS); break;
           case 4: item.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM|MenuItem.SHOW_AS_ACTION_WITH_TEXT); 
                  item.setTitleCondensed("."); break;                    
           case 5: item.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS|MenuItem.SHOW_AS_ACTION_WITH_TEXT);
                  item.setTitleCondensed(".");break;
         } 	                	     
      } 
     }
    
    ////Sub menus Items: Do not support item icons, or nested sub menus.    
    public void AddItem(SubMenu _subMenu, int _itemID, String _caption, int _itemType){    	     	        
        MenuItem item = _subMenu.add(0,_itemID,0 ,(CharSequence)_caption);        
    	switch  (_itemType) {
    	  case 1:  item.setCheckable(true); break;    	
    	}                            
     }
    
    public SubMenu AddSubMenu(Menu _menu, String _title, String _headerIconIdentifier){
    	SubMenu sm = null;
    	if (_menu != null) {
    	   mMenu = _menu;	
     	   sm =_menu.addSubMenu((CharSequence)_title); //main title     	        	       	  
     	   sm.setHeaderIcon(GetDrawableResourceId(_headerIconIdentifier));
    	   mSubMenus[mCountSubMenu] = sm;      	       	     	       	       	   
    	   mCountSubMenu++; 
    	}   
    	return sm;  	    	
    }  
    
    //Request a call to onPrepareOptionsMenu so we can change the items   
    public void InvalidateOptionsMenu() {
    	controls.activity.invalidateOptionsMenu(); 
    }
    
    
    public void SetItemVisible(MenuItem _item, boolean _value){
        _item.setVisible( _value);        
    }
    
    public void SetItemVisible(Menu _menu, int _index, boolean _value){
    	if (_menu != null) {
      	  if ( _index < _menu.size() ) {
      	    MenuItem item = _menu.getItem(_index);
    	    item.setVisible( _value);    
    	  }
    	}
    }
            
    public void Clear(Menu _menu){
  	    for(int i=0; i < mCountSubMenu; i++){
    		 mSubMenus[i] = null;       	 
    	}
  	    mCountSubMenu = 0;
    	if (_menu != null) {    		    		  
        	  _menu.clear();
        	  if (mMenu != null) mMenu.clear();        
    	}	    	
    }
    
    public void Clear(){                
   	    for(int i=0; i < mCountSubMenu; i++){
   		   mSubMenus[i] = null;
   	    }
   	    mCountSubMenu = 0;
    	if (mMenu != null)  {    		      	        	        	  
    	  mMenu.clear();    	  
    	}		
    }
    
    public void SetItemTitle(MenuItem _item, String _title) {
    	_item.setTitle((CharSequence)_title);
    }
     
    public void SetItemTitle(Menu _menu, int _index,  String _title){
    	if (_menu != null)  {
    	  if ( _index < _menu.size() ) {
    	    MenuItem item = _menu.getItem(_index);
    	    item.setTitle((CharSequence)_title);
    	  }
    	}
    }
     
    public void SetItemIcon(MenuItem _item, int _iconIdentifier) {
    	_item.setIcon(_iconIdentifier);
    }
     
    public void SetItemIcon(Menu _menu, int _index,  int _iconIdentifier){
    	if (_menu != null)  {
    	  if ( _index < _menu.size() ) {
      	    MenuItem item = _menu.getItem(_index);
    	    item.setIcon(_iconIdentifier);
    	  }
    	}
    }
    
    public void SetItemChecked(MenuItem _item, boolean _value) {
    	_item.setChecked(_value);
    }
    
    public void SetItemCheckable(MenuItem _item, boolean _value) {
    	_item.setCheckable(_value);
    }   
      
    
    public int GetItemIdByIndex(Menu _menu, int _index) {
    	if ( _index < _menu.size() ) {
    	  MenuItem i = _menu.getItem(_index);    	
    	  return i.getItemId();
    	} else return -1;
    	
    }
    
    public int GetItemIndexById(Menu _menu, int _id) {
    	int r = -1;
    	if (_menu != null)  {
    	  for(int i=0; i < _menu.size(); i++)  {
    		 MenuItem item = _menu.getItem(i);    		
    	     if ( item.getItemId() == _id ) {
    	    	r = i;
    	    	break;
    	     }
    	  }
    	}
    	return r;
    }
    
    public void RemoveItemById(Menu _menu, int _id){
    	int id = GetItemIndexById(_menu, _id);
    	if (id > -1) _menu.removeItem(id);
    }
    
    public void RemoveItemByIndex(Menu _menu, int _index){
    	if (_menu != null)  {	
    	  if ( _index < _menu.size() ) {
      	    MenuItem item = _menu.getItem(_index);
    	    int id = item.getItemId();  	
    	    _menu.removeItem(id);
    	  }
    	}
    }
    
    public void SetMenu(Menu _menu) {
        if (_menu != null) {	
    	   mMenu = _menu;
        }
    }
}


/*Draft java code by "Lazarus Android Module Wizard" [4-5-14 20:46:56]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jContextMenu /*extends ...*/ {
  
    private long pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    private ContextMenu  mMenu = null;
    private ArrayList<String>    mItemList;
    
    private String mHeaderTitle;
    private String mHeaderIconIdentifier;
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jContextMenu(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       mMenu     = null;
       mItemList = new ArrayList<String>();
    }
  
    public void jFree() {
        //free local objects...
    	mMenu = null;
    	mItemList.clear();
    	mItemList = null;    	    	
    }
      
    public int CheckItemCommute(MenuItem _item){
    	int flag = 0;
    	
    	int id = _item.getItemId();
    	if (_item.isChecked()) flag = 1;
    	switch (flag) {
    	  case 0: _item.setChecked(false);
    	           mItemList.remove(Integer.toString(id));                   
    	  break; 
    	  case 1: _item.setChecked(true);
    	          mItemList.remove(Integer.toString(id));
    	          mItemList.add(Integer.toString(id)); 
    	  break;
        }
  	   return id;
    }
    
    public int CheckItem(MenuItem _item){
       _item.setChecked(true);
       int id = _item.getItemId();
       mItemList.remove(Integer.toString(id));
       mItemList.add(Integer.toString(id));
       return  id;
    }
    
    public int UnCheckItem(MenuItem _item){
      _item.setChecked(false);       
      int id =_item.getItemId();
      mItemList.remove(Integer.toString(id));
      return id;
    }    
        
    public int Size(){
    	if (mMenu != null)
    	   return mMenu.size();
    	else 
    	  return 0;   			
    }
    
    public MenuItem FindMenuItemByID(int _itemID){
    	if (mMenu != null) return mMenu.findItem(_itemID);
    	else return null;
    }

    public MenuItem GetMenuItemByIndex(int _index){
    	if (mMenu != null)
    	   return mMenu.getItem(_index);
    	else return null;
    }
    
    public void UnCheckAllMenuItem(){
      if (mMenu != null){	
    	 for(int index=0; index < mMenu.size(); index++){
    		mMenu.getItem(index).setChecked(false);
    	 }    	 
    	 mItemList.clear();
      } 	
    }
        
    public void RegisterForContextMenu(View _view){
       controls.activity.registerForContextMenu(_view);
    }   
    
    public void UnRegisterForContextMenu(View _view){ 
      controls.activity.unregisterForContextMenu(_view); 
   }        
 
    //_itemType --> 0:Default, 1:Checkable
    public MenuItem AddItem(ContextMenu _menu, int _itemID, String _caption, int _itemType){    	     	
    	MenuItem item = _menu.add(0,_itemID,0 ,(CharSequence)_caption);

    	switch  (_itemType) {
    	case 1:  item.setCheckable(true); break;    	
    	}
    	                      
  	    if (mMenu == null) mMenu = _menu;
  	   
  	    return item;
    }
    
    private int GetDrawableResourceId(String _resName) {
  	  try {
  	     Class<?> res = R.drawable.class;
  	     Field field = res.getField(_resName);  //"drawableName"
  	     int drawableId = field.getInt(null);
  	     return drawableId;
  	  }
  	  catch (Exception e) {
  	     Log.e("jContextMenu_error", "Failure to get drawable id.", e);
  	     return 0;
  	  }
    }
    
    public void SetHeader(ContextMenu _menu, String _title, String _iconIdentifier){
    	mHeaderTitle = _title;
    	mHeaderIconIdentifier = _iconIdentifier;
  	   _menu.setHeaderTitle((CharSequence)_title);
  	   _menu.setHeaderIcon(GetDrawableResourceId(_iconIdentifier));
  	   if (mMenu == null) mMenu = _menu;
    }
    
    public void SetHeaderTitle(String _title){    	     	  
   	   mHeaderTitle = _title;
   	   if (mMenu != null) {
   		   mMenu.setHeaderTitle((CharSequence)_title);
   	   }   	   
     }
    
    public void SetHeaderIconByIdentifier(String _iconIdentifier){    	     	  
   	   mHeaderIconIdentifier = _iconIdentifier;
   	   if (mMenu != null) {
   		  mMenu.setHeaderIcon(GetDrawableResourceId(_iconIdentifier));
   	   }
     }    
    
    public boolean IsItemChecked(int _itemID) {
    	boolean res = false; 
    	if (mItemList.size() > 0)  {
    		if ( mItemList.indexOf( Integer.toString(_itemID)) >= 0  ) res = true; 	
    	}    	
    	return res;
    }
           
}



//ref. http://stackoverflow.com/questions/19395970/android-bluetooth-background-listner?rq=1
//ref. http://androidcookbook.com/Recipe.seam;jsessionid=6C1411AB8CCAFBA9384A5EC295B44525?recipeId=1991
class jBluetoothServerSocket {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;

    private BluetoothAdapter mBAdapter;
    private String mServerName = "LamwBluetoothServer";
    private BluetoothServerSocket mServerSocket;
    private BluetoothSocket mConnectedSocket;
    
    private boolean mConnected;
    private boolean mIsListing = false;
    
    BufferedInputStream mBufferInput;
	BufferedOutputStream mBufferOutput;

    String mStrUUID = "00001101-0000-1000-8000-00805F9B34FB";   //Well known SPP UUID - Serial Port Profile
    int mTimeout = -1; //infinity
        
    int mBuffer = 1024;
    
    boolean IsFirstsByteHeader = false;
                 
    public jBluetoothServerSocket(Controls _ctrls, long _Self) {
        context   = _ctrls.activity;
	    pascalObj = _Self;
	    controls  = _ctrls;	    
	    mConnected= false;	   	    
	    mBAdapter = BluetoothAdapter.getDefaultAdapter(); // Emulator -->> null!!!
    }
    
	public void jFree() {
        //free local objects...
		mConnectedSocket = null;
	    mBufferInput = null;		
		mBufferOutput = null;						
		mServerSocket = null;
		mBAdapter = null;		
	}

	public void SetUUID(String _strUUID) {
		if (!_strUUID.equals("")) {
			mStrUUID = _strUUID;	
		}   
	}
		
	   public void CancelListening() {
		    DisconnectClient();
	        try {
	        	if (mServerSocket != null) 
	        		mServerSocket.close();        
	        }
	        catch (IOException ex) {
	            //Log.e(TAG+":cancel", "error while closing server socket");
	        }
	    }
		 
	public void DisconnectClient() {
		   mConnected = false;
		   try {
		      if (mConnectedSocket != null && mConnectedSocket.isConnected()) 	    	   
		    	  mConnectedSocket.close();
		   } catch (IOException e) {
	          //
		   }	   
    }
		   

	public boolean IsClientConnected() {	
		if (mConnectedSocket != null)
	    	return mConnectedSocket.isConnected();
		else return false;
    }
			
	/* System.arraycopy
	 * src  the source array to copy the content. 
       srcPos  the starting index of the content in src. 
       dst  the destination array to copy the data into. 
       dstPos  the starting index for the copied content in dst. 
       length  the number of elements to be copied.  
	 */	
	
	//talk to client	
	public void Write(byte[] _dataContent, byte[] _dataHeader) {		 		
	       try {    	   
	           if (mBufferOutput != null) {	        	           	   	        	    
	        	    int sizeContent = _dataContent.length;	        	    
	        	    int tempsizeHeader = _dataHeader.length;
	        	    
	        	    if (tempsizeHeader > 32767) tempsizeHeader = 32767; 
	        	    
	        	    short sizeHeader = (short)tempsizeHeader;
	        	    
	        	    byte[] extendedArray = new byte[sizeContent+4+sizeHeader+2];	        	     	   
	        	    byte[] sizeContentBuff = intToByteArray(sizeContent, ByteOrder.LITTLE_ENDIAN);
	        	    byte[] sizeHeaderBuff = shortToByteArray(sizeHeader, ByteOrder.LITTLE_ENDIAN);
	        	    
	        	    System.arraycopy(sizeHeaderBuff, 0,  extendedArray, 0, 2);
	        	    System.arraycopy(sizeContentBuff, 0,  extendedArray, 2, 4);	        	    
	        	    System.arraycopy(_dataHeader, 0,  extendedArray, 2+4, _dataHeader.length);	        	    	        	           	   		           	   
	       	        System.arraycopy(_dataContent, 0,  extendedArray, 2+4+_dataHeader.length, _dataContent.length);		
	       	        mBufferOutput.write(extendedArray, 0, extendedArray.length);              
	       	        mBufferOutput.flush();          
	           }
	           
	        } catch (IOException e) { }       	       
	}	

	public void WriteMessage(String _message, byte[] _dataHeader) {		 		
		Write(_message.getBytes(), _dataHeader);       	      
	}
			
	public void WriteMessage(String _message) {						
	    try {	    	   
	       if (mBufferOutput != null) {
	       	    byte[] _byteArray = _message.getBytes();	        	   	       	        	       	        		
	       	    mBufferOutput.write(_byteArray, 0, _byteArray.length);              
	       	    mBufferOutput.flush();          
	        }	           
	    } catch (IOException e) { }       	       
	}
			
    //talk to client	
	public void Write(byte[] _dataContent) {	
		
     try {
        if (mBufferOutput != null) {	        	 
     	   mBufferOutput.write(_dataContent, 0, _dataContent.length);              
     	   mBufferOutput.flush();
         }    
      }  catch (IOException e) { }    
     
 }
	
	
public void SendFile(String _filePath, String _fileName, byte[] _dataHeader) throws IOException {
		
		  if (mBufferOutput != null) {	
		    File F = new File( _filePath + "/" + _fileName);		    	    	    	    	    
		    int sizeContent = (int)F.length();	    
		        	    	        	    
    	    int tempsizeHeader = _dataHeader.length;	        	    	        	    
    	    if (tempsizeHeader > 32767) tempsizeHeader = 32767; 	        	    	        	   	        	    	        	    
    	    short sizeHeader = (short)tempsizeHeader; 		        	    	        	      	       	        	    
    	    byte[] extendedArray = new byte[sizeContent+4+sizeHeader+2];	        	     	   
    	    byte[] sizeContentBuff = intToByteArray(sizeContent, ByteOrder.LITTLE_ENDIAN);
    	    byte[] sizeHeaderBuff = shortToByteArray(sizeHeader, ByteOrder.LITTLE_ENDIAN);	        	    	        	    	        	    
    	    
    	    System.arraycopy(sizeHeaderBuff, 0,  extendedArray, 0, 2);
    	    System.arraycopy(sizeContentBuff, 0,  extendedArray, 2, 4);	        	    
    	    System.arraycopy(_dataHeader, 0,  extendedArray, 2+4, _dataHeader.length);	 
    	    
		    BufferedInputStream bis = new BufferedInputStream(new FileInputStream(F));			    
		    if (bis.read(extendedArray, 2+4+_dataHeader.length, sizeContent) > 0) {  
	          try {	        	  
	        	mBufferOutput.write(extendedArray, 0, extendedArray.length);
	            mBufferOutput.flush();
	          }  
	          finally {
	            bis.close();   
	          }        
		    }
		  }   
	}
		
	public void SendFile(String _filePath, String _fileName) throws IOException {
		
	 if ( mBufferOutput != null) {			 
		    File F = new File( _filePath + "/" + _fileName);		    	    	    	    	    
		    int size = (int)F.length();	    
		    byte[] buffer = new byte[size];  	    	  	  	    	    	    	    
		    BufferedInputStream bis = new BufferedInputStream(new FileInputStream(F));	    	  	    
		    if (bis.read(buffer, 0, size) > 0) {		    
		      try {             		    	  
		    	mBufferOutput.write(buffer, 0, buffer.length);
		        mBufferOutput.flush();
		      }  
		      finally {
		        bis.close();   
		      }        
		    }
	   }  		 
     }
	
	public void WriteMessage(String _message, String _dataHeader) {		 	
		WriteMessage(_message, _dataHeader.getBytes());
	}
	
	public void Write(byte[] _dataContent,  String _dataHeader) {			 
		Write(_dataContent,_dataHeader.getBytes());		   
	}
	
	public void SendFile(String _filePath, String _fileName, String _dataHeader) throws IOException {
		SendFile(_filePath,_fileName, _dataHeader.getBytes());		
	}
	
	public void SaveByteArrayToFile(byte[] _byteArray, String _filePath,  String _fileName) {
		
		File F = new File( _filePath + "/" + _fileName);
	    FileOutputStream fos;
		try {
			fos = new FileOutputStream(F);						
		    try {
				fos.write(_byteArray, 0, _byteArray.length);
				fos.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
		    try {
				fos.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		        
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
    	
private byte[] intToByteArray(int value, ByteOrder order) {
        ByteBuffer buffer = ByteBuffer.allocate(4); // in java, int takes 4 bytes.
        buffer.order(order);	        	       	        
        return buffer.putInt(value).array();
}
 	  
private int byteArrayToInt(byte[] byteArray, ByteOrder order) {
        ByteBuffer buffer = ByteBuffer.wrap(byteArray);
        buffer.order(order);
        return buffer.getInt();
}

private byte[] shortToByteArray(short value, ByteOrder order) {
    ByteBuffer buffer = ByteBuffer.allocate(2); // in java, shortint takes 2 bytes.
    buffer.order(order);	        	       	        
    return buffer.putShort(value).array();
}
	  
private int byteArrayToShort(byte[] byteArray, ByteOrder order) {
    ByteBuffer buffer = ByteBuffer.wrap(byteArray);
    buffer.order(order);
    return buffer.getShort();
}
	
public void SetTimeout(int _milliseconds) {
	   mTimeout= _milliseconds;			
}	
	
	public String ByteArrayToString(byte[] _byteArray) {  
		   return (new String(_byteArray));   
	}
	
    public Bitmap ByteArrayToBitmap(byte[] _byteArray) {
    	return BitmapFactory.decodeByteArray(_byteArray, 0, _byteArray.length);    	
    }
        
    public boolean GetDataHeaderReceiveEnabled() {
        return IsFirstsByteHeader;
    }
    
      
    public void SetDataHeaderReceiveEnabled(boolean _value)  {
    	IsFirstsByteHeader = _value;
    }
    
           
    public void SetReceiverBufferLength(int _value)  {
    	mBuffer = _value;
    }
    
    public int GetReceiverBufferLength()  {
    	return mBuffer; 
    }
    
    public void SetServerName() { //TODO Pascal 
       mServerName = "LamwBluetoothServer";
    }
    
	public void Listen() {
				  		  		 
		  DisconnectClient();
		  
		  mConnected = false; 	
	      if ( !mStrUUID.equals("") && mBAdapter != null) {		    	  
	        try {        	        	        	               		
	        	  if (!mBAdapter.isEnabled()) {
	                  controls.activity.startActivityForResult(new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), 1001);
	              }         	                  	    
				  mServerSocket = mBAdapter.listenUsingRfcommWithServiceRecord(mServerName, UUID.fromString(mStrUUID));		
				  				  
				  if (mServerSocket != null) {	
					  controls.pOnBluetoothServerSocketListen(pascalObj, mServerName, mStrUUID);
	                  new ASocketServerTask().execute();							  	 								
				  }        	  
			 } catch (IOException e1) {
				//	
			 }                 
		  }              
	}
	
    class ASocketServerTask extends AsyncTask<String,ByteArrayOutputStream,String> {
      	boolean flagAceept = false;
    	    	
    	int bytes_read = 0;
    	int count = 0;
    	
    	int lenContent = 0;
    	int lenHeader = 0;
    	
    	byte[] inputBuffer = new byte[mBuffer];    
    	
    	ByteArrayOutputStream bufferOutput;
    	ByteArrayOutputStream bufferOutputHeader;
    	
    	byte[] headerBuffer;
    	    	    	
        @Override
        protected String doInBackground(String... message) {    
          mConnected = false;          	
          try {            	            	            
            	if (mTimeout > 0) { 
            	  mIsListing = true;
     			  mConnectedSocket = mServerSocket.accept(mTimeout); //locking...
     			  mIsListing = false;
            	}  
            	else {           		
            	  mIsListing = true;
            	  mConnectedSocket = mServerSocket.accept();
            	  mIsListing = false;
            	}  
            	            	            	        	    
				if (mConnectedSocket != null) { 			        					
					mConnected = true;
	        	    mBufferInput = new BufferedInputStream(mConnectedSocket.getInputStream());
	        		mBufferOutput = new  BufferedOutputStream(mConnectedSocket.getOutputStream());	
	        		try {
	            	   mServerSocket.close();
	            	   mServerSocket = null;
	        		}
	        		catch (IOException e3) {		
	        			mServerSocket = null;	
	    		    }
				}				
		  } 
            catch (IOException e2) {		
				//e2.printStackTrace();		
		  }
          while (mConnected) {                          	
             try {
               bufferOutput = new ByteArrayOutputStream();
               bytes_read =  -1;
               if (mBufferInput != null)
    		       bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length); //blocking ...
    		   if (bytes_read == -1) { 
    			  mConnected = false;    			 
    		   }	    				
    		 } catch (IOException e) {
    			//
    			 mConnected = false;
    		 } 
                
             if (IsFirstsByteHeader) {
                if(bytes_read > 6) {
              	   bufferOutputHeader = new ByteArrayOutputStream();   
                   byte[] lenHeaderBuffer = new byte[2];  //header lenght [short]
                   byte[] lenContentBuffer = new byte[4];  //content lenght [int]
                                     
                   if (inputBuffer!=null) {
                	 System.arraycopy(inputBuffer, 0,lenHeaderBuffer, 0, 2); //copy first 2 bytes -->header lenght
                     System.arraycopy(inputBuffer, 2,lenContentBuffer, 0, 4); //copy more 4 bytes --> content lenght
                     
                     lenContent = byteArrayToInt(lenContentBuffer, ByteOrder.LITTLE_ENDIAN); //get number
                     lenHeader = byteArrayToShort(lenHeaderBuffer, ByteOrder.LITTLE_ENDIAN); //get number
                            
                     //---headerBuffer = new byte[lenHeader]; //get header info ...
                     
                     //----------------------------------------------------------------------                                                                                      
                     int index = 2+4;  
                     int r = bytes_read;                    
                     while ( r < (lenHeader+index)) {
                      if (bytes_read > 0) { 
                   	    bufferOutputHeader.write(inputBuffer,index, bytes_read-index);
                   	    if (mBufferInput!=null) {
                   	       try {                    		  
							   bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length);
							   if (bytes_read < 0) {
	                   	        	mConnected = false;	                  			    
	                   	       }
					 	    } catch (IOException e) {
							// TODO Auto-generated catch block
					 	      mConnected = false;	
							  e.printStackTrace();
						    }                    	  
                   	        index = 0;
                   	        if (bytes_read > 0)
                   	           r = r + bytes_read;                   	       
                   	    }
                      } 
                     }                        
                     if (bytes_read > 0)
               	       r = r - bytes_read;  //backtraking..
               	  
                     //-----------------------------------------------------------------------------                      
                     if (bufferOutput!=null) {       
                    	if ( (lenHeader-r) > 0) {
                   	      bufferOutputHeader.write(inputBuffer,index,lenHeader-r); //dx                    	 
                   	      headerBuffer = bufferOutputHeader.toByteArray();  
                   	      if ((bytes_read-index-(lenHeader-r)) > 0) {
                   	        bufferOutput.write(inputBuffer, index+(lenHeader-r), bytes_read-index-(lenHeader-r));                     
                   	        count = count + bytes_read-index-(lenHeader-r);
                            publishProgress(bufferOutput);
                   	      }
                    	}
                     }                                                               
                     
                     //---------------------------------------------------------------------
                     
                     /*                                                          
                     if (inputBuffer!=null &&  bufferOutput!=null) {                       
                    	  System.arraycopy(inputBuffer, 2+4 ,headerBuffer, 0, lenHeader); //get header info ..                       
                          bufferOutput.write(inputBuffer, 2+4+lenHeader, bytes_read-2-4-lenHeader);  //get content info                
                          count = count + bytes_read-2-4-lenHeader;                   
                          publishProgress(bufferOutput);
                     }
                     */ 
                     
                   }
                   
                   while ( count < lenContent) {                	  
                 	    try {
                 	    	bytes_read = -1;
                 	    	if (mBufferInput!=null) {
   						       bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length);                 	    	
                 	    	   if (bytes_read < 0) {
                   	        	 mConnected = false;
                  			     //return null;
                 	    	   }  
                   	        }
                 	    	
   					    } catch (IOException e) {
   						// TODO Auto-generated catch block
   					    	mConnected = false;	
   						    e.printStackTrace();
   				 	    } 
                 	    if(bytes_read > 0) {
                 	       if (bufferOutput!=null) {
                 	    	 if (bytes_read > 0)  { 
                 	           bufferOutput.write(inputBuffer, 0, bytes_read);     	                  	                                         
                               count = count + bytes_read;
                               publishProgress(bufferOutput);
                 	    	 }  
                 	       }
                        }
                   }    
                } 
                else {
                  mConnected = false;                 
                }
            }  
            else{
            	if (bufferOutput!=null) {	
            	  if (bytes_read > 0) {	
                    bufferOutput.write(inputBuffer, 0, bytes_read);
                    publishProgress(bufferOutput);
            	  }
            	}
            }
                                    	                         
          }// main loop            
          return null;
        }
        
		@Override
		protected void onPreExecute() {			
		   super.onPreExecute();		   				   
		}
				
		//http://examples.javacodegeeks.com/core-java/nio/bytebuffer/convert-between-bytebuffer-and-byte-array/
        @Override
        protected void onProgressUpdate(ByteArrayOutputStream...buffers) {
           super.onProgressUpdate(buffers[0]);            
 		   if (!flagAceept) {
			   flagAceept = true;
		       boolean keep = controls.pOnBluetoothServerSocketConnected(pascalObj,mConnectedSocket.getRemoteDevice().getName(),mConnectedSocket.getRemoteDevice().getAddress());
		       if (!keep) {
		    	    mConnected = false;
		    	    
		    	    mBufferInput = null;
					mBufferOutput = null;
		  			mConnectedSocket = null;
		  			
		    		while (mConnectedSocket.isConnected()) {
		    			try {
						  mConnectedSocket.close();
					     } catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					    }   
		    		}		    																	              		
		       }	
		   }  	
 		   
 		   if (IsFirstsByteHeader) { 			   
 		      if (buffers[0].toByteArray().length == lenContent) { 		    	  
                 mConnected = controls.pOnBluetoothServerSocketIncomingData(pascalObj, buffers[0].toByteArray(), headerBuffer);
                 try {
                	 if (bufferOutput != null) 
                	   bufferOutput.close();                	   
				 } catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				 }                 
 		      }  
              //TODO
              /*
              else controls.pOnBluetoothServerSocketProgress(pascalObj, values[0].toByteArray().length);
              */
 		   }        
           else {
        	  mConnected = controls.pOnBluetoothServerSocketIncomingData(pascalObj, buffers[0].toByteArray(), headerBuffer);
              try {
            	  if (bufferOutput != null)
            	      bufferOutput.close();	
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
			  }              
           } 		    		   
        }
        
        @Override
        protected void onPostExecute(String values) {    	  
          super.onPostExecute(values);
        	controls.pOnBluetoothServerSocketAcceptTimeout(pascalObj);
		    mBufferInput = null;
			mBufferOutput = null;

        }        
      }	
}

//ref. http://androidcookbook.com/Recipe.seam;jsessionid=9B476BA317AA36E2CB0D6517ABE60A5E?recipeId=1665
//ref. http://javarevisited.blogspot.com.br/2012/08/convert-inputstream-to-string-java-example-tutorial.html
class jBluetoothClientSocket {
	
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;

	private  BluetoothSocket mmSocket;	
	private BluetoothDevice mmDevice;
	
	boolean mmConnected;
	
    BufferedInputStream mBufferInput;
	BufferedOutputStream mBufferOutput;
	
	BluetoothAdapter mmBAdapter;
	
    int mBuffer = 1024;
    
    boolean IsFirstsByteHeader = false;
    	
	//Unique UUID for this application.....
	//private UUID mmUUID = UUID.fromString("fa87c0d0-afac-11de-8a39-0800200c9a66");
	
	//Well known SPP UUID
	private String mmUUIDString = "00001101-0000-1000-8000-00805F9B34FB";
	
	String mMimeType = "text";
		
	public jBluetoothClientSocket(Controls _ctrls, long _Self) {
	       context   = _ctrls.activity;
	       pascalObj = _Self;
	       controls  = _ctrls;
	       mmBAdapter = BluetoothAdapter.getDefaultAdapter(); // Emulator -->> null!!!
	}
	
	public void jFree() {
         //free local objects...
		mmDevice = null;
	    mBufferInput = null;
		mBufferOutput = null;
		mmSocket = null;
		mmBAdapter = null;
	}
	
	public void SetDevice(BluetoothDevice _device) {		
		mmDevice = _device;
	}
	
	public void SetUUID(String _strUUID) {
		if (!_strUUID.equals("")) {
			mmUUIDString = _strUUID;
		}   
	}
				         
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
        
	public boolean IsConnected() {
		if (mmSocket != null)
		   return mmSocket.isConnected();
		else return false; 
	}
		
	public void Disconnect() {
		mmConnected = false;
		try {
			if (mmSocket != null)
				while (mmSocket.isConnected()) {
					mmSocket.close();	
				}
			    
		} catch (IOException e2) {			

		}	
	}
		
	//talk to server
	/* System.arraycopy
	 * src  the source array to copy the content. 
       srcPos  the starting index of the content in src. 
       dst  the destination array to copy the data into. 
       dstPos  the starting index for the copied content in dst. 
       length  the number of elements to be copied.  
	 */	
	
	//talk to client	
	public void Write(byte[] _dataContent, byte[] _dataHeader) {		 		
	       try {    	   
	           if (mBufferOutput != null) {	        	           	   	        	    
	        	    int sizeContent = _dataContent.length;	        	    
	        	    int tempsizeHeader = _dataHeader.length;	        	    	        	    
	        	    if (tempsizeHeader > 32767) tempsizeHeader = 32767; 	        	    	        	   	        	    	        	    
	        	    short sizeHeader = (short)tempsizeHeader; 		        	    	        	      	       	        	    
	        	    byte[] extendedArray = new byte[sizeContent+4+sizeHeader+2];	        	     	   
	        	    byte[] sizeContentBuff = intToByteArray(sizeContent, ByteOrder.LITTLE_ENDIAN);
	        	    byte[] sizeHeaderBuff = shortToByteArray(sizeHeader, ByteOrder.LITTLE_ENDIAN);	        	    	        	    	        	    
	        	    System.arraycopy(sizeHeaderBuff, 0,  extendedArray, 0, 2);
	        	    System.arraycopy(sizeContentBuff, 0,  extendedArray, 2, 4);	        	    
	        	    System.arraycopy(_dataHeader, 0,  extendedArray, 2+4, _dataHeader.length);	        	    	        	           	   		           	   
	       	        System.arraycopy(_dataContent, 0,  extendedArray, 2+4+_dataHeader.length, _dataContent.length);		
	       	        mBufferOutput.write(extendedArray, 0, extendedArray.length);              
	       	        mBufferOutput.flush();          
	           }
	           
	        } catch (IOException e) { }       	       
	}	

	public void WriteMessage(String _message, byte[] _dataHeader) {		 		
		Write(_message.getBytes(), _dataHeader);       	      
	}
			
	public void WriteMessage(String _message) {						
	    try {	    	   
	       if (mBufferOutput != null) {
	       	    byte[] _byteArray = _message.getBytes();	        	   	       	        	       	        		
	       	    mBufferOutput.write(_byteArray, 0, _byteArray.length);              
	       	    mBufferOutput.flush();          
	        }	           
	    } catch (IOException e) { }       	       
	}
			
    //talk to client	
	public void Write(byte[] _dataContent) {	
		
     try {
        if (mBufferOutput != null) {	        	 
     	   mBufferOutput.write(_dataContent, 0, _dataContent.length);              
     	   mBufferOutput.flush();
         }    
      }  catch (IOException e) { }    
     
 }
	
	
public void SendFile(String _filePath, String _fileName, byte[] _dataHeader) throws IOException {
		
		  if (mBufferOutput != null) {	
		    File F = new File( _filePath + "/" + _fileName);		    	    	    	    	    
		    int sizeContent = (int)F.length();	    
		        	    	        	    
    	    int tempsizeHeader = _dataHeader.length;	        	    	        	    
    	    if (tempsizeHeader > 32767) tempsizeHeader = 32767; 	        	    	        	   	        	    	        	    
    	    short sizeHeader = (short)tempsizeHeader; 		        	    	        	      	       	        	    
    	    byte[] extendedArray = new byte[sizeContent+4+sizeHeader+2];	        	     	   
    	    byte[] sizeContentBuff = intToByteArray(sizeContent, ByteOrder.LITTLE_ENDIAN);
    	    byte[] sizeHeaderBuff = shortToByteArray(sizeHeader, ByteOrder.LITTLE_ENDIAN);	        	    	        	    	        	    
    	    
    	    System.arraycopy(sizeHeaderBuff, 0,  extendedArray, 0, 2);
    	    System.arraycopy(sizeContentBuff, 0,  extendedArray, 2, 4);	        	    
    	    System.arraycopy(_dataHeader, 0,  extendedArray, 2+4, _dataHeader.length);	 
    	    
		    BufferedInputStream bis = new BufferedInputStream(new FileInputStream(F));			    
		    if (bis.read(extendedArray, 2+4+_dataHeader.length, sizeContent) > 0) {  
	          try {         	        
	        	mBufferOutput.write(extendedArray, 0, extendedArray.length);
	            mBufferOutput.flush();
	          }  
	          finally {
	            bis.close();   
	          }        
		    }
		  }   
	}
		
	public void SendFile(String _filePath, String _fileName) throws IOException {
		
	 if ( mBufferOutput != null) {			 
		    File F = new File( _filePath + "/" + _fileName);		    	    	    	    	    
		    int size = (int)F.length();	    
		    byte[] buffer = new byte[size];  	    	  	  	    	    	    	    
		    BufferedInputStream bis = new BufferedInputStream(new FileInputStream(F));	    	  	    
		    if (bis.read(buffer, 0, size) > 0) {		    
		      try {             		    	  
		    	mBufferOutput.write(buffer, 0, buffer.length);
		        mBufferOutput.flush();
		      }  
		      finally {
		        bis.close();   
		      }        
		    }
	   }  		 
    }
	
	public void WriteMessage(String _message, String _dataHeader) {		 	
		WriteMessage(_message, _dataHeader.getBytes());
	}
	
	public void Write(byte[] _dataContent,  String _dataHeader) {			 
		Write(_dataContent,_dataHeader.getBytes());		   
	}
	
	public void SendFile(String _filePath, String _fileName, String _dataHeader) throws IOException {
		SendFile(_filePath,_fileName, _dataHeader.getBytes());		
	}

	
    public boolean GetDataHeaderReceiveEnabled() {
        return IsFirstsByteHeader;
    }
          
    public void SetDataHeaderReceiveEnabled(boolean _value)  {
    	IsFirstsByteHeader = _value;
    }
    
           
    public void SetReceiverBufferLength(int _value)  {
    	mBuffer = _value;
    }
    
    public int GetReceiverBufferLength()  {
    	return mBuffer; 
    }
    
	public void SaveByteArrayToFile(byte[] _byteArray, String _filePath,  String _fileName) {
			  	
		File F = new File( _filePath + "/" + _fileName);
	    FileOutputStream fos;
		try {
			fos = new FileOutputStream(F);						
		    try {
				fos.write(_byteArray, 0, _byteArray.length);
				fos.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
		    try {
				fos.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		        
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	  	
	}
    	
	private byte[] intToByteArray(int value, ByteOrder order) {
	        ByteBuffer buffer = ByteBuffer.allocate(4); // in java, int takes 4 bytes.
	        buffer.order(order);	        	       	        
	        return buffer.putInt(value).array();
	}
	 	  
	private int byteArrayToInt(byte[] byteArray, ByteOrder order) {
	        ByteBuffer buffer = ByteBuffer.wrap(byteArray);
	        buffer.order(order);
	        return buffer.getInt();
	}
	
	
	private byte[] shortToByteArray(short value, ByteOrder order) {
        ByteBuffer buffer = ByteBuffer.allocate(2); // in java, shortint takes 2 bytes.
        buffer.order(order);	        	       	        
        return buffer.putShort(value).array();
    }
 	  
    private int byteArrayToShort(byte[] byteArray, ByteOrder order) {
        ByteBuffer buffer = ByteBuffer.wrap(byteArray);
        buffer.order(order);
        return buffer.getShort();
    }
			
	public void Connect() {
  	  
  	    if (!mmBAdapter.isEnabled()) {
            controls.activity.startActivityForResult(new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), 1000);
        }  	    
  	    
  	    if (mmBAdapter.isDiscovering()) mmBAdapter.cancelDiscovery(); //must cancel to connect!
  	    
        if (mmSocket != null) {
        	  try {        		  
				mmSocket.close();
				mmSocket = null;
			  } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			  }
        }
          
        try {
        	  mmConnected = false;
			  mmSocket = mmDevice.createRfcommSocketToServiceRecord(UUID.fromString(mmUUIDString));
			  
			  // This is a blocking call and will only return on a successful connection or an exception			  
		      mmSocket.connect();
		      
		} catch (IOException e) {
				 mmConnected = false;									
				mmSocket = null;				
		}          	
         
        if (mmSocket != null) {
    		try {
    			mBufferInput = new BufferedInputStream(mmSocket.getInputStream());
				mBufferOutput = new  BufferedOutputStream(mmSocket.getOutputStream());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				mBufferInput = null;
				mBufferOutput = null;
				e.printStackTrace();
			}        	
            new ASocketClientTask().execute();
        }  
    }	

	public String ByteArrayToString(byte[] _byteArray) { 
		 return (new String(_byteArray));   
	}
	
    public Bitmap ByteArrayToBitmap(byte[] _byteArray) {
    	return BitmapFactory.decodeByteArray(_byteArray, 0, _byteArray.length);    	
    }
    
    class ASocketClientTask extends AsyncTask<String, ByteArrayOutputStream, String> {
    	
    	int bytes_read = 0;
    	int count = 0;
    	int lenContent = 0;    
    	int lenHeader = 0;    
    	    	
    	byte[] inputBuffer = new byte[mBuffer];    	     	
    	
    	ByteArrayOutputStream bufferOutput;
    	ByteArrayOutputStream bufferOutputHeader;
    	
        byte[] headerBuffer;
    	
    	
        @Override
        protected String doInBackground(String... message) {
          while (mmConnected) {                                                                     	
            try {            	
            	bytes_read = -1;
            	bufferOutput = new ByteArrayOutputStream();
            	
            	if (mBufferInput!=null)
				    bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length);   //blocking ...
				if (bytes_read < 0) { 
					mmConnected = false;				
				}	
			} catch (IOException e) {
				mmConnected = false;
				e.printStackTrace();				
			} 

            if (IsFirstsByteHeader) {
               if(bytes_read > 6) {            	
            	  bufferOutputHeader = new ByteArrayOutputStream();   
                  byte[] lenHeaderBuffer = new byte[2];  //package lenght [int]
                  byte[] lenContentBuffer = new byte[4];  //package lenght [int]
                  
                  if (inputBuffer!=null) {
                	  System.arraycopy(inputBuffer, 0,lenHeaderBuffer, 0, 2);                	    
                      System.arraycopy(inputBuffer, 2,lenContentBuffer, 0, 4);
                                            
                      lenHeader = byteArrayToShort(lenHeaderBuffer, ByteOrder.LITTLE_ENDIAN);
                      lenContent = byteArrayToInt(lenContentBuffer, ByteOrder.LITTLE_ENDIAN);                                                                             
                      
                      //----------------------------------------------------------------------                                                                                      
                      int index = 2+4;  // [header+content len] 
                      int r = bytes_read;                    
                      while ( r < (lenHeader+index)) {
                    	if (bytes_read > 0) {  
                    	  bufferOutputHeader.write(inputBuffer,index, bytes_read-index);
                    	  if (mBufferInput!=null) {
                    	    try {                    		  
							   bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length);
							   if (bytes_read < 0) {
								   mmConnected = false;
								   //return null;
							   }
					 	    } catch (IOException e) {
							// TODO Auto-generated catch block
					 	      mmConnected = false;	
							  e.printStackTrace();
						    }                    	  
                    	    index = 0;
                    	    if (bytes_read > 0)
                    	       r = r + bytes_read;      
                    	  }
                    	}  
                      } 
                      if (bytes_read > 0)
                	    r = r - bytes_read;  //backtraking..
                	  
                      //-----------------------------------------------------------------------------                      
                      if (bufferOutput!=null) {                    	                      	                        	                        	                     	                     	                     	  
                    	if ( (lenHeader-r) > 0 ) {
                    	   //---System.arraycopy(inputBuffer, 2+4 ,headerBuffer, 0, lenHeader);
                    	   bufferOutputHeader.write(inputBuffer,index,lenHeader-r); //dx                    	 
                    	   headerBuffer = bufferOutputHeader.toByteArray();                    	  
                           //---bufferOutput.write(inputBuffer, 2+4+lenHeader, bytes_read-2-4-lenHeader);
                    	   if ((bytes_read-index-(lenHeader-r)) > 0 ) {
                    	      bufferOutput.write(inputBuffer, index+(lenHeader-r), bytes_read-index-(lenHeader-r));
                              //--count = count + bytes_read-2-4-lenHeader;
                    	      count = count + bytes_read-index-(lenHeader-r);
                              publishProgress(bufferOutput);
                    	   }
                    	}   
                      }                      
                  }
                                    
                  while ( count < lenContent) {                	  
              	    try {
              	    	bytes_read = -1;
              	    	if (mBufferInput != null)
					   	   bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length); //blocking ...
						   if (bytes_read < 0) {
							   mmConnected = false;							
						   }
					} catch (IOException e) {
						// TODO Auto-generated catch block
						mmConnected = false;
						e.printStackTrace();
					} 
              	                  	    
              	    if (bufferOutput!=null) { 	
              	    	if  (bytes_read > 0) { 
              	          bufferOutput.write(inputBuffer, 0, bytes_read);     	                  	                                         
                          count = count + bytes_read;
                          publishProgress(bufferOutput);
              	    	}
              	    }                    
                  }                  
                                    
               }               
               else {
                   mmConnected = false;
               }
            }   
            else{
            	if (bufferOutput!=null) {
                  if  (bytes_read > 0) {            		
                     bufferOutput.write(inputBuffer, 0, bytes_read);
                     publishProgress(bufferOutput);
                  }
            	}
            }
                                                   	                                								                         	                      			                                                      
          } //main loop           
          return null;
        }
        
		@Override
		protected void onPreExecute() {			
			super.onPreExecute();
			mmConnected = true;												
			controls.pOnBluetoothClientSocketConnected(pascalObj,mmSocket.getRemoteDevice().getName(),mmSocket.getRemoteDevice().getAddress());
		}
		
        @Override
        protected void onProgressUpdate(ByteArrayOutputStream... values) {
           super.onProgressUpdate(values);
           if (IsFirstsByteHeader) {
              if (values[0].toByteArray().length == lenContent ) {
                 controls.pOnBluetoothClientSocketIncomingData(pascalObj, values[0].toByteArray(), headerBuffer);
                 try {                	 
                	if (bufferOutput != null) 
                	   bufferOutput.close();    		
                	if (bufferOutputHeader!= null)
                	   bufferOutputHeader.close();                	
    			  } catch (IOException e) {
    					// TODO Auto-generated catch block
    					e.printStackTrace();
    			 }
                 //TODO
                 /*
                 else controls.pOnBluetoothClientSocketProgress(pascalObj, values[0].toByteArray().length);
                 */
              }  
              
           }
           else {
        	  controls.pOnBluetoothClientSocketIncomingData(pascalObj, values[0].toByteArray(), headerBuffer);
              try {
            	  if (bufferOutput != null)
            	       bufferOutput.close();
			  } catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
			  }
           }
        }
        
        @Override
        protected void onPostExecute(String values) {    	  
          super.onPostExecute(values);          
          controls.pOnBluetoothClientSocketDisconnected(pascalObj);
          try {
        	 mmConnected = false;
        	 mBufferOutput = null;         	 
        	 if (mmSocket != null) mmSocket.close();   	  	        	  	
   	       } catch (IOException e) {
   		    
   	       }          
        }
        
      }	
}

/*Draft java code by "Lazarus Android Module Wizard" [5/10/2014 14:32:21]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//ref. http://www.tutorialspoint.com/android/android_bluetooth.htm
//ref. http://examples.javacodegeeks.com/android/core/bluetooth/bluetoothadapter/android-bluetooth-example/
//ref. http://www.javacodegeeks.com/2013/09/bluetooth-data-transfer-with-android.html
//ref. http://www.bravenewgeek.com/bluetooth-blues/
       
class jBluetooth /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;

    private BluetoothAdapter mBA = null;
    
    private Intent intent = null;
    
    ArrayList<String> mListFoundedDevices = new ArrayList<String>();
    ArrayList<BluetoothDevice> mListReachablePairedDevices  = new ArrayList<BluetoothDevice>();
    
    ArrayList<BluetoothDevice> mListFoundedDevices2  = new ArrayList<BluetoothDevice>();
    
    ArrayList<String> mListBondedDevices = new ArrayList<String>();
    
    //jBluetoothClientSocket mBluetoothClientSocket;    

    final BroadcastReceiver mBroadcastReceiver = new BroadcastReceiver() {
	    @Override
   /*.*/public void onReceive(Context context, Intent intent){
	    	
	        String action = intent.getAction();
	        
	        if (BluetoothDevice.ACTION_FOUND.equals(action)){	          
	           BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);	           			        
	           if (mBA.getBondedDevices().contains(device)) {
	        	   mListReachablePairedDevices.add(device);	               
	           }
			   mListFoundedDevices.add( device.getName() + "|" + device.getAddress() );
			   mListFoundedDevices2.add(device);
			  // Log.i("jBluetooth_onReceive",device.getName() + "|" + device.getAddress());	        	   
	           	           
	           controls.pOnBluetoothDeviceFound(pascalObj,device.getName(),device.getAddress());
	           
	        }else if (BluetoothAdapter.ACTION_DISCOVERY_STARTED.equals(action)) {
	             controls.pOnBluetoothDiscoveryStarted(pascalObj);
	        }else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
	             controls.pOnBluetoothDiscoveryFinished(pascalObj, mListFoundedDevices.size(), mListReachablePairedDevices.size());
	        }else if (BluetoothDevice.ACTION_BOND_STATE_CHANGED.equals(action)) {
	            // Device pairing/unpairing occurred
	            BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);	            
	            int state = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, 0);
	            /*switch (state) {
	                case BluetoothDevice.BOND_BONDED: //12
	                    // Device was paired
	                	
	                    Log.i("BluetoothReceiver", "Paired with " + device.getName());
	                    break;
	                case BluetoothDevice.BOND_NONE:  //10
	                    // Device was unpaired
	                	
	                    Log.i("BluetoothReceiver", "Unpaired with " + device.getName());
	                    break;
	                case BluetoothDevice.BOND_BONDING:  //11
	                    // Device is in the process of pairing
	                	
	                    Log.i("BluetoothReceiver", "Pairing with " + device.getName());
	                    break;
	            }*/
	            
	            controls.pOnBluetoothDeviceBondStateChanged(pascalObj, state, device.getName(), device.getAddress());
	        } 	        
	    }
    };    
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jBluetooth(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       
	   mBA = BluetoothAdapter.getDefaultAdapter(); // Emulator -->> null!!!
	   
       intent = new Intent();
	   intent.setAction(Intent.ACTION_SEND);
	   
       controls.activity.registerReceiver(mBroadcastReceiver, new IntentFilter(BluetoothDevice.ACTION_FOUND));        
       controls.activity.registerReceiver(mBroadcastReceiver, new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_STARTED));      
       controls.activity.registerReceiver(mBroadcastReceiver, new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED));
       controls.activity.registerReceiver(mBroadcastReceiver, new IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED));

    }

    public void jFree() {
       //free local objects...
    	controls.activity.unregisterReceiver(mBroadcastReceiver);
    	if (mBA != null) {    		
    		mBA.cancelDiscovery();
    		mBA.disable();
    	}	    	
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
    public void Enabled(){
    	
    	if (mBA != null) {   //real device... 
    	   Toast.makeText(controls.activity.getApplicationContext(),"Adapter: "+mBA.getName() ,Toast.LENGTH_LONG).show();    	
           if (!mBA.isEnabled()) {
             controls.activity.startActivityForResult(new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), 999);
             //Toast.makeText(controls.activity.getApplicationContext(),"Bluetooth turned On" ,Toast.LENGTH_LONG).show();
             controls.pOnBluetoothEnabled(pascalObj);
           }          
    	}else { //Emulator...
    	   Toast.makeText(controls.activity.getApplicationContext(),"Warning: Try Real Device!",Toast.LENGTH_LONG).show();
    	}    	    	
    }
        
    public void Discovery() {
    	if (mBA != null && mBA.isEnabled()) {	
           if (mBA.isDiscovering())	mBA.cancelDiscovery();
           mListFoundedDevices.clear();  //new devices....
           mListReachablePairedDevices.clear();	
           mBA.startDiscovery();    	   
    	}
    }
        
    public void CancelDiscovery() {  //must Cancel to Connect socket!!!
    	if (mBA != null && mBA.isEnabled()) {	
            mBA.cancelDiscovery();
    	}
    }  
            
    public String[] GetPairedDevices(){  //list all paired devices...
    	
    	mListBondedDevices.clear();
    	
        mListBondedDevices.add("null|null");
        
        if (mBA != null && mBA.isEnabled()){            
           Set<BluetoothDevice> Devices = mBA.getBondedDevices();           
           //Toast.makeText(controls.activity.getApplicationContext(),"Devices Count = "+Devices.size(), Toast.LENGTH_SHORT).show();           
           
           if(Devices.size() > 0) {        	  
              mListBondedDevices.clear();              
              for(BluetoothDevice device : Devices) {        	
         	     mListBondedDevices.add(device.getName()+"|"+ device.getAddress());
           	     //Log.i("Bluetooch_devices",device.getName());  //device.getAddress()            
              }              
           }  
        }
        //strDevices = new String[mPairedDevices.size()];
        //strDevices = listDevices.toArray(strDevices);
        String strDevices[] = mListBondedDevices.toArray(new String[mListBondedDevices.size()]);    	  
        return strDevices;        
    }
          
    public String[] GetFoundedDevices(){  //list
    	if (mListFoundedDevices.size() == 0) {
            mListFoundedDevices.add("null|null");
    	}
        String strDevices[] = mListFoundedDevices.toArray(new String[mListFoundedDevices.size()]);    	  
        return strDevices;        
    }
    
    public String[] GetReachablePairedDevices(){  //list
    	String[] strRes;
    	int size = mListReachablePairedDevices.size();
    	if (size > 0) {
    		strRes = new String[size];
    		for (int i=0; i < size; i++) {
    			strRes[i] = mListReachablePairedDevices.get(i).getName() +"|" + mListReachablePairedDevices.get(i).getAddress();	
    		}
    	} else {
    		strRes = new String[1];
    		strRes[0] = "null|null";
    	}    	            	 
        return strRes;        
    }

    public void Disable(){
       if (mBA != null) {
    	   mBA.disable(); 
           controls.pOnBluetoothDisabled(pascalObj);          
       }
       //Toast.makeText(controls.activity.getApplicationContext(),"Bluetooth turned Off" ,Toast.LENGTH_LONG).show();
    }
    
    public boolean IsEnable() {
    	if (mBA.isEnabled()) {
    		return true;
    	} else {
    	  return false;
    	}
    }
    
    //This method returns the current state of the Bluetooth Adapter.
    public int GetState() {
      if (mBA != null) {
        return mBA.getState();  //STATE_OFF, STATE_TURNING_ON, STATE_ON, STATE_TURNING_OFF.
      } else { 
    	  return -1;
      }
    }       
                            
    public BluetoothDevice GetReachablePairedDeviceByName(String _deviceName) {
    	
    	int index = -1;
    	
        for (int i=0; i < mListReachablePairedDevices.size(); i++) {
        	if (mListReachablePairedDevices.get(i).getName().equals(_deviceName)) {
        		index = i;
        		break;
        	}
        }
        if (index > -1) { 
    	   return mListReachablePairedDevices.get(index);
        }	
        else return null;
    }
    
    public BluetoothDevice GetReachablePairedDeviceByAddress(String _deviceAddress) {
    	
    	int index = -1;
    	
        for (int i=0; i < mListReachablePairedDevices.size(); i++) {
        	if (mListReachablePairedDevices.get(i).getAddress().equals(_deviceAddress)) {
        		index = i;
        		break;
        	}
        }
        if (index > -1) { 
        	return mListReachablePairedDevices.get(index);
        }	
        else return null;
    }
        
    public boolean IsReachablePairedDevice(String _deviceAddress) {    	
    	int index = -1;    	
        for (int i=0; i < mListReachablePairedDevices.size(); i++) {
        	if (mListReachablePairedDevices.get(i).getAddress().equals(_deviceAddress)) {
        		index = i;
        		break;
        	}
        }
        if (index > -1) { 
    	   return true;
        }	
        else return false;    	    
    }
 
    public BluetoothDevice GetRemoteDeviceByAddress(String _deviceAddress){
    	
       if (IsReachablePairedDevice(_deviceAddress))	
          return mBA.getRemoteDevice(_deviceAddress);
       else
    	  return null; 
       
    }
    
    public String GetDeviceNameByAddress(String _deviceAddress){
    	
    	String device;
    	String devAddr = "";
    	
    	for(int i=0; i < mListFoundedDevices.size(); i++) {
    	    device = mListFoundedDevices.get(i);    	   
    	    devAddr = device.substring(device.indexOf("|")+1);
    	   // Log.i("devAddr",devAddr);
    	    if (devAddr.equals(_deviceAddress)) {
    	    	break;
    	    }    	       	    	    
    	}    	
    	return devAddr;    	    	
    }
    
    public String GetDeviceAddressByName(String _deviceName){
    	String device;
    	String devName = "";
    	
    	for(int i=0; i < mListFoundedDevices.size(); i++) {
    	    device = mListFoundedDevices.get(i);    	   
    	    devName = device.substring(0, device.indexOf("|")-1);
    	   // Log.i("devName",devName);
    	    if (devName.equals(_deviceName)) {
    	    	break;
    	    }    	       	    	    
    	}    	
    	return devName;
    }
        
    //http://stackoverflow.com/questions/15697601/automate-file-transfer-to-a-paired-device-in-android-using-bluetooth
    public void SendFile(String _filePath, String _fileName, String _mimeType){
      
        File file = new File(_filePath, "/" + _fileName);
        Uri uri = Uri.fromFile(file);
        String mtype = _mimeType; //"image/*";

        Intent sharingIntent = new Intent(android.content.Intent.ACTION_SEND);
        sharingIntent.setType(mtype);
        sharingIntent.setClassName("com.android.bluetooth", "com.android.bluetooth.opp.BluetoothOppLauncherActivity");
        sharingIntent.putExtra(Intent.EXTRA_STREAM, uri);
        controls.activity.startActivity(sharingIntent);       
    }
    
    public void UnpairDeviceByAddress(String _deviceAddress) {
  	   BluetoothDevice device =  GetReachablePairedDeviceByAddress(_deviceAddress);
      	try {
      		
      	  if (device != null) {	
      	     Method m = device.getClass()
      	        .getMethod("removeBond", (Class[]) null);
      	     m.invoke(device, (Object[]) null);
      	  }
      	} catch (Exception e) {
      	    //Log.e(TAG, e.getMessage());
      	}
      }  
         
    public BluetoothDevice GetFoundedDeviceByAddress(String _deviceAddress) {
     	
     	int index = -1;     	
         for (int i=0; i < mListFoundedDevices2.size(); i++) {
         	if (mListFoundedDevices2.get(i).getAddress().equals(_deviceAddress)) {
         		index = i;
         		break;
         	}
         }
         if (index > -1) { 
         	return mListFoundedDevices2.get(index);
         }	
         else return null;
     }

     public void PairDeviceByAddress(String _deviceAddress) {
     	BluetoothDevice device = GetFoundedDeviceByAddress(_deviceAddress);
     	try {
     	    if (device != null) {    	    	
     	    Method m = device.getClass()
     	               .getMethod("createBond", (Class[]) null);    	    
     	               m.invoke(device, (Object[]) null);
     	    } 	    	   
     	} catch (Exception e) {
     	    //Log.e(TAG, e.getMessage());
     	}
     }
      
}

//by jmpessoa
class jShareFile /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    private String mTransitoryEnvironmentDirectoryPath;
    
    private Intent intent = null;
        	        
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jShareFile(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       
       mTransitoryEnvironmentDirectoryPath = GetEnvironmentDirectoryPath(1); //download!
       
       intent = new Intent();
	   intent.setAction(Intent.ACTION_SEND);
       //intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
  	   intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

    }

    public void jFree() {
      //free local objects...
      intent = null;      
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    private static void copyFileUsingFileStreams(File source, File dest)
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

    private boolean CopyFile(String _scrFullFileName, String _destFullFileName) {
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
    
	public void ShareFromSdCard(String _filename, String _mimetype){			 		 
		intent.setType(_mimetype);		
	    File file = new File(Environment.getExternalStorageDirectory().getPath() +"/"+ _filename);
	    intent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(file)); /* "/sdcard/test.txt" result : "file:///sdcard/test.txt" */			 	         		 		 			 				
		controls.activity.startActivity(Intent.createChooser(intent, "Share ["+_filename+"] by:"));
	}
	
	//https://xjaphx.wordpress.com/2011/10/02/store-and-use-files-in-assets/
	public void ShareFromAssets(String _filename, String _mimetype){				    		   
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
				ShareFromInternalAppStorage(_filename,_mimetype);				
			}catch (IOException e) {
				// Log.i("ShareFromAssets","fail!!");
			     e.printStackTrace();			     
			}									
	}	
	
	public void ShareFromInternalAppStorage(String _filename, String _mimetype) {	 
	  String srcPath = controls.activity.getFilesDir().getAbsolutePath()+"/"+ _filename;       //Result : /data/data/com/MyApp/files	 
	  String destPath = mTransitoryEnvironmentDirectoryPath + "/" + _filename;	  
	  CopyFile(srcPath, destPath);	  
	  ShareFrom(destPath, _mimetype);	  	   
	}
		
	public void ShareFrom(String _fullFilename, String _mimetype) {
		   int p1 = _fullFilename.lastIndexOf("/");
		   String filename = _fullFilename.substring(p1+1, _fullFilename.length());		   		   
		   File file = new File(_fullFilename);	        	 
		   intent.setType(_mimetype);
		   intent.putExtra(Intent.EXTRA_STREAM,Uri.fromFile(file));    		       		 	     
		   controls.activity.startActivity(Intent.createChooser(intent, "Share ["+filename+"] by:")); 		   
	}	
		
	private String GetEnvironmentDirectoryPath(int _directory) {
		
		File filePath= null;
		String absPath="";   //fail!
		  
		//Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);break; //API 19!
		if (_directory != 8) {		  	   	 
		  switch(_directory) {	                       
		    
		    case 0:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS); break; //hack		    
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
	
    public void SetTransitoryEnvironmentDirectory(int _index) {   
    	mTransitoryEnvironmentDirectoryPath = GetEnvironmentDirectoryPath(_index);
    }
	
}

//by jmpessoa
class CustomSpinnerArrayAdapter<T> extends ArrayAdapter<String>{
	
	Context ctx; 
	private int mTextColor = Color.BLACK;
	private int mTexBackgroundtColor = Color.TRANSPARENT; 
	private int mSelectedTextColor = Color.LTGRAY; 
	private int flag = 0;
	private boolean mLastItemAsPrompt = false;
	private int mTextFontSize = 0;
	int mTextSizeTypedValue;
	
  public CustomSpinnerArrayAdapter(Context context, int simpleSpinnerItem, ArrayList<String> alist) {
     super(context, simpleSpinnerItem, alist);
     ctx = context;
     mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
  }
  
 
 public void SetFontSizeUnit(int _unit) {	
	   switch (_unit) {
	      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; 
	      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
	      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; 
	      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; 
	      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; 
	      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 	      
       }   
}
  //This method is used to display the dropdown popup that contains data.
	@Override
  public View getDropDownView(int position, View convertView, ViewGroup parent)
  {
      View view = super.getView(position, convertView, parent);        
      //we know that simple_spinner_item has android.R.id.text1 TextView:         
      TextView text = (TextView)view.findViewById(android.R.id.text1);
      
      text.setPadding(10, 15, 10, 15);      
      text.setTextColor(mTextColor);
                 
      if (mTextFontSize != 0) {
    	  
    	  if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
            text.setTextSize(mTextSizeTypedValue, mTextFontSize);
    	  else
    		 text.setTextSize(mTextFontSize);  
      }    
      
      text.setBackgroundColor(mTexBackgroundtColor);
      return view;        
  }
		
	//This method is used to return the customized view at specified position in list.
	@Override
	public View getView(int pos, View cnvtView, ViewGroup prnt) {
		
	  View view = super.getView(pos, cnvtView, prnt);	    
	  TextView text = (TextView)view.findViewById(android.R.id.text1);
	       
	  text.setPadding(10, 15, 10, 15); //improve here.... 17-jan-2015	  
      text.setTextColor(mSelectedTextColor);      
      
      if (mTextFontSize != 0) {
    	  
    	  if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
             text.setTextSize(mTextSizeTypedValue, mTextFontSize);
    	  else
     		 text.setTextSize(mTextFontSize);
      }    
      
      if (mLastItemAsPrompt) flag = 1;
      return view; 
    }
	
    @Override
    public int getCount() {
	  if (flag == 1) 
        return super.getCount() - 1; //do not show last item
	   else return super.getCount();
    }
				
	public void SetTextColor(int txtColor){
		mTextColor = txtColor;
	}
	
	public void SetBackgroundColor(int txtColor){
		mTexBackgroundtColor = txtColor;
	}
	
	public void SetSelectedTextColor(int txtColor){
		mSelectedTextColor = txtColor;
	}
	
	 public void SetLastItemAsPrompt(boolean _hasPrompt) {
	    mLastItemAsPrompt = _hasPrompt;	   
	 }
	 
	    public void SetTextFontSize(int txtFontSize) {
	    	mTextFontSize = txtFontSize;	
	    }
	
}

/*Draft java code by "Lazarus Android Module Wizard" [6/11/2014 22:00:44]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

class jSpinner extends Spinner /*dummy*/ { //please, fix what GUI object will be extended!

   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events

   private Context context = null;
   private ViewGroup parent  = null;         // parent view
   private RelativeLayout.LayoutParams lparams;              // layout XYWH
   private Boolean enabled  = true;           // click-touch enabled!
   private int lparamsAnchorRule[] = new int[30];
   private int countAnchorRule = 0;
   private int lparamsParentRule[] = new int[30];
   private int countParentRule = 0;
   private int lparamH = 100; 
   private int lparamW = 100;
   private int marginLeft = 0;
   private int marginTop = 0;
   private int marginRight = 0;
   private int marginBottom = 0;

   private ArrayList<String>  mStrList;
   private CustomSpinnerArrayAdapter<String> mSpAdapter;
   private boolean mLastItemAsPrompt = false;
   
   //implement action listener type of OnItemSelectedListener
   private OnItemSelectedListener spinnerListener =new OnItemSelectedListener() {
	   
        @Override   
   /*.*/public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {        	
    	     String caption = mStrList.get(position).toString();
	         setSelection(position);	          		            		          		            
    	     controls.pOnSpinnerItemSeleceted(pascalObj,position,caption);              
        }
        
        @Override
   /*.*/public void onNothingSelected(AdapterView<?> parent) {}    
        
   };
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jSpinner(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      
      lparams = new RelativeLayout.LayoutParams(100,100); //lparamW, lparamH
     
      mStrList = new ArrayList<String>();
                  
      mSpAdapter = new CustomSpinnerArrayAdapter<String>(context, android.R.layout.simple_spinner_item,mStrList);
      mSpAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
      setAdapter(mSpAdapter);                  
      setOnItemSelectedListener(spinnerListener);      
   } //end constructor
   
   public void jFree() {
      if (parent != null) { parent.removeView(this); }
      //free local objects...
      mStrList = null; 
      mSpAdapter = null;    
      lparams = null;
      setOnClickListener(null);
   }

   public void SetjParent(ViewGroup _viewgroup) {
      if (parent != null) { parent.removeView(this); }
      parent = _viewgroup;
      _viewgroup.addView(this,lparams);
   }

   public void SetLParamWidth(int _w) {
      lparamW = _w;
   }

   public void SetLParamHeight(int _h) {
      lparamH = _h;
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
      marginLeft = _left;
      marginTop = _top;
      marginRight = _right;
      marginBottom = _bottom;
      lparamH = _h;
      lparamW = _w;
   }

   public void AddLParamsAnchorRule(int _rule) {
      lparamsAnchorRule[countAnchorRule] = _rule;
      countAnchorRule = countAnchorRule + 1;
   }

   public void AddLParamsParentRule(int _rule) {
      lparamsParentRule[countParentRule] = _rule;
      countParentRule = countParentRule + 1;
   }

   public void SetLayoutAll(int _idAnchor) {
  	 lparams.width  = lparamW;
	 lparams.height = lparamH;
    
	 lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
	
	 if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
	  	    lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	 }
     for (int j=0; j < countParentRule; j++) {
         lparams.addRule(lparamsParentRule[j]);
     }
    this.setLayoutParams(lparams);
   }

   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }
   
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ..
   
   public int GetSelectedItemPosition() {
      return this.getSelectedItemPosition();
   }
   
   public String GetSelectedItem() {	   
 	 return this.getSelectedItem().toString();	  
   }
  
   public void Add(String _item) {	  	 
	 mStrList.add(_item);    
	 //Log.i("Spinner_Add: ",_item);
     mSpAdapter.notifyDataSetChanged();
   }
   
   //ELERA_04032015 
   public void Clear() { 
     mStrList.clear(); 
     mSpAdapter.notifyDataSetChanged(); 
   } 

   public void SetSelectedTextColor(int _color) {
	  mSpAdapter.SetSelectedTextColor(_color);
   }
   
   public void SetDropListTextColor(int _color) {
	  mSpAdapter.SetTextColor(_color);
   }
   
   public void SetDropListBackgroundColor(int _color) {
	  mSpAdapter.SetBackgroundColor(_color);
   }
   
   public void SetLastItemAsPrompt(boolean _hasPrompt) {
	   mLastItemAsPrompt = _hasPrompt;
	   mSpAdapter.SetLastItemAsPrompt(_hasPrompt);
	   if (mLastItemAsPrompt) {
		 if (mStrList.size() > 0) setSelection(mStrList.size()-1);
	   }	   
   }
   
   public int GetSize() {
	  return mStrList.size();
   }
   
   public void Delete(int _index) {	     
	   if (_index < 0) mStrList.remove(0);
	   else if (_index > (mStrList.size()-1)) mStrList.remove(mStrList.size()-1);
	   else mStrList.remove(_index);	   	   		 		 
	   mSpAdapter.notifyDataSetChanged();
   }      
   
   public void SetSelection(int _index) {
	   if (_index < 0) setSelection(0);
	   else if (_index > (mStrList.size()-1)) setSelection(mStrList.size()-1);
	   else setSelection(_index);	   
   }
   
   public void SetItem(int _index, String _item) {	   
	   if (_index < 0) mStrList.set(0,_item);
	   else if (_index > (mStrList.size()-1)) mStrList.set(mStrList.size()-1,_item);
	   else mStrList.set(_index,_item);	 
	   mSpAdapter.notifyDataSetChanged();
   }
   
   public void SetTextFontSize(int _txtFontSize) {
	  mSpAdapter.SetTextFontSize(_txtFontSize);
   }
   
   /*
   public void SetChangeFontSizeByComplexUnitPixel(boolean _value) {
	   mSpAdapter.SetChangeFontSizeByComplexUnitPixel(_value);
	}
   */
   
   public void SetFontSizeUnit(int _unit) {
	   mSpAdapter.SetFontSizeUnit(_unit);   
   }
   
}  //end class


/*Draft java code by "Lazarus Android Module Wizard" [8/9/2014 20:25:55]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//ref. 1:  http://examples.javacodegeeks.com/android/core/location/android-location-based-services-example/
//ref. 2   http://examples.javacodegeeks.com/android/core/location/proximity-alerts-example/
//ref. 3:  http://www.wingnity.com/blog/android-gps-location-address-using-location-manager/
//ref. 4:  http://www.techrepublic.com/blog/software-engineer/take-advantage-of-androids-gps-api/
//ref. 5:  http://androidexample.com/GPS_Basic__-__Android_Example/index.php?view=article_discription&aid=68&aaid=93
//ref. 6:  http://hejp.co.uk/android/android-gps-example/
//ref. 7:  http://www.slideshare.net/androidstream/android-gps-tutorial

class jLocation /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;

    private MyLocationListener mlistener;    
    private LocationManager mLocationManager;
    private Criteria mCriteria;
    private String mProvider;
    private String mLatitude;
    private String mLongitude;
    private String mAltitude;
        
    private String mAddress;
    private String mStatus;
    
    //The minimum distance to change Updates in meters
    private long mDistanceForUpdates;
    // The minimum time between updates in milliseconds
    private long mTimeForUpdates;
    
    private double mLat; 
    private double mLng;
    private double mAlt;
    
    private int mCriteriaAccuracy;
  
    private String mMapType;
    private int mMapZoom;
    private int mMapSizeW;
    private int mMapSizeH;
    
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jLocation(Controls _ctrls, long _Self, long _TimeForUpdates, long _DistanceForUpdates, int _CriteriaAccuracy, int _MapType) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       
       //Get the location manager
       mLocationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
       //Define the criteria how to select the location provider
       mCriteria = new Criteria();
       
       if (_CriteriaAccuracy == 0) {
          mCriteriaAccuracy = Criteria.ACCURACY_COARSE; //default::Network-based/wi-fi
       }else {
    	  mCriteriaAccuracy = Criteria.ACCURACY_FINE;  
       }
       
       switch(_MapType) { //mt, mt, mtHybrid
         case 0: mMapType = "roadmap"; break;
         case 1: mMapType = "satellite"; break;
         case 2: mMapType = "terrain"; break;
         case 3: mMapType = "hybrid"; break;
         default: mMapType = "roadmap";
       }
       
       /*
        * the Android Location Services periodically checks on your location using GPS, Cell-ID, 
        * and Wi-Fi to locate your device. When it does this,
        *  your Android phone will send back publicly broadcast Wi-Fi access points' Service set identifier (SSID) 
        *  and Media Access Control (MAC) data.
        *  ref: http://www.zdnet.com/blog/networking/how-google-and-everyone-else-gets-wi-fi-location-data/1664
        */
       
       mlistener = new MyLocationListener();
       
       mLat = 0.0; 
       mLng = 0.0;
       
       mTimeForUpdates = _TimeForUpdates;           //(long) (1000 * 60 * 1)/4; // 1 minute
       mDistanceForUpdates = _DistanceForUpdates;  //1; //meters
       
       mMapZoom = 14;
       mMapSizeW = 512;
       mMapSizeH = 512;
       
    }

    public void jFree() {
      //free local objects...
      mLocationManager = null;
      mCriteria = null;
      mlistener = null;    	
    }
    
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
  public boolean StartTracker() {
        boolean result;
        
	    mCriteria.setAccuracy(mCriteriaAccuracy);                     
	    mCriteria.setCostAllowed(false);
	                                 
	    //get the best provider depending on the criteria
        mProvider = mLocationManager.getBestProvider(mCriteria, false);       

        //the last known location of this provider		 		 
        Location location = mLocationManager.getLastKnownLocation(mProvider);                    
                
        if (location != null) {
          mLat = location.getLatitude(); 
          mLng = location.getLongitude();
          mAlt = location.getAltitude();
          mAddress = GetAddress(mLat, mLng);          
          mlistener.onLocationChanged(location);
          result = true;
        }            
        else {
        	// Log.i("jLocation", "Wait... No Location Yet!!");                	        
        	 result = false;
        }    
        
        mLocationManager.requestLocationUpdates(mProvider, mTimeForUpdates, mDistanceForUpdates, mlistener);
        
        return result;
   }

   public void ShowLocationSouceSettings() {
	  Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
      context.startActivity(intent); 
   }   
   
   public void RequestLocationUpdates() {          	      
      mLocationManager.requestLocationUpdates(mProvider, mTimeForUpdates, mDistanceForUpdates, mlistener);
   } 	
       
   public void StopTracker() {  // finalize ....
      mlistener.RemoveUpdates(mLocationManager);
   }
    
   public void SetCriteriaAccuracy(int _accuracy) {
       if(_accuracy == 0){  //default...     	            
          mCriteria.setAccuracy(Criteria.ACCURACY_COARSE);   //less accuracy      
       }else { 
    	  mCriteria.setAccuracy(Criteria.ACCURACY_FINE); //high accuracy         
       }          
    }       
        
    public boolean IsGPSProvider() {
       return mLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
    }
    
    public boolean IsNetProvider() {
       return mLocationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
    }
    
    public void SetTimeForUpdates(long _time) { // millsecs 
      mTimeForUpdates = _time;
    }
    
    public void SetDistanceForUpdates(long _distance) { //meters
      mDistanceForUpdates = _distance;
    }
    
    public double GetLatitude() { 
      return mLat;
    }   
    
    public double GetLongitude() {
      return mLng;
    }   

    public double GetAltitude() {
      return mAlt;
    }   
        
    public boolean IsWifiEnabled() {
       WifiManager wifiManager = (WifiManager)this.context.getSystemService(Context.WIFI_SERVICE);
       return  wifiManager.isWifiEnabled();	
    }
    
    public void SetWifiEnabled(boolean _status) {
       WifiManager wifiManager = (WifiManager)this.context.getSystemService(Context.WIFI_SERVICE);             
       wifiManager.setWifiEnabled(_status);
    }
        
    //https://developers.google.com/maps/documentation/staticmaps
    public String GetGoogleMapsUrl(double _latitude, double _longitude) {        
      String url = "http://maps.googleapis.com/maps/api/staticmap?center="+_latitude + "," + _longitude+
                    "&zoom="+mMapZoom+"&size="+mMapSizeW+"x"+mMapSizeH+"&maptype="+mMapType+"&markers="+_latitude + "," + _longitude;          		                         
      return url;
    }
    
    public void SetMapWidth(int _mapwidth) {
	   mMapSizeW = _mapwidth;    	
    }
    
    public void SetMapHeight(int _mapheight) {
	  mMapSizeH= _mapheight;    	
    }
    
    public void SetMapZoom(int _mapzoom) {
      if (_mapzoom < 15) {	
	     mMapZoom = _mapzoom;
      }
      else {
    	 mMapZoom = 14;
      }      
    }
    
   public void SetMapType(int _maptype) {
	  switch(_maptype) {
		 case 0: mMapType= "roadmap"; break;
		 case 1: mMapType= "satellite"; break;
		 case 2: mMapType= "terrain"; break;
		 case 3: mMapType= "hybrid"; break;
		 default: mMapType= "roadmap";
	  }   		
    }

   public String GetAddress() {
	     return mAddress;
   }

    public String GetAddress(double _latitude, double _longitude) {
  	 
           Geocoder geocoder = new Geocoder(context, Locale.getDefault());
           // Get the current location from the input parameter list
           // Create a list to contain the result address
           List<Address> addresses = null;
           try {
               /*
                * Return 1 address.
                */
               addresses = geocoder.getFromLocation(_latitude, _longitude, 1);
           } catch (IOException e1) {
               e1.printStackTrace();
               return ("IO Exception trying to get address:" + e1);
           } catch (IllegalArgumentException e2) {
               // Error message to post in the log
               String errorString = "Illegal arguments passed to address service";
               e2.printStackTrace();
               return errorString;
           }
           // If the reverse geocode returned an address
           if (addresses != null && addresses.size() > 0) {
               // Get the first address
               Address address = addresses.get(0);
               /*
                * Format the first line of address (if available), city, and
                * country name.
                */
               String addressText = String.format(
                       "%s, %s, %s",
                       // If there's a street address, add it
                       address.getMaxAddressLineIndex() > 0 ? address
                               .getAddressLine(0) : "",
                       // Locality is usually a city
                       address.getLocality(),
                       // The country of the address
                       address.getCountryName());
               // Return the text
               return addressText;
           } else {
               return "No address found by the service: Note to the developers, If no address is found by google itself, there is nothing you can do about it. :(";
           }
    }
       
    private class MyLocationListener implements LocationListener {    	    	
    	
        @Override
        /*.*/public void onLocationChanged(Location location) {
             //Initialize the location fields
                          
             mLat = location.getLatitude();
             mLng = location.getLongitude();
             mAlt= location.getAltitude();
                         
             mLatitude= String.valueOf(mLat);
             mLongitude= String.valueOf(mLng);
             mAltitude= String.valueOf(mAlt);
             
             mAddress = GetAddress(mLat, mLng);
             
            // Log.i("jLocation", "Latitude: "+ mLatitude+ " ... Longitude: "+mLongitude+" ... Altitude: " + mAltitude);
                          
        	 controls.pOnLocationChanged(pascalObj,mLat,mLng,mAlt,mAddress);        		
        }

        @Override
        /*.*/public void onStatusChanged(String provider, int status, Bundle extras) {
           
        	switch (status) {
    		  case LocationProvider.OUT_OF_SERVICE:
    			 mStatus="Out of Service";
    		  break;
    		  case LocationProvider.TEMPORARILY_UNAVAILABLE:
    			  mStatus="Temporarily Unavailable";    			
    	      break;
    		  case LocationProvider.AVAILABLE:
    			 mStatus="Available";    		
              break;
    		}        	        	
        	//Log.i("jLocation", "mStatus: "+mStatus);
        	
        	controls.pOnLocationStatusChanged(pascalObj, status, provider, mStatus);
        }

        @Override
        /*.*/public void onProviderEnabled(String provider) {
        	//Log.i("jLocation", "Enabled: "+provider);
        	controls.pOnLocationProviderEnabled(pascalObj, provider);
        }
        
        @Override
        /*.*/public void onProviderDisabled(String provider) {        
        	///* this is called if/when the GPS is disabled in settings */
        	//Log.i("jLocation", "Disabled: "+provider);
        	controls.pOnLocationProviderDisabled(pascalObj, provider);        	
        }
                
        /*.*/public void RemoveUpdates(LocationManager lm) {
        	lm.removeUpdates(this);
        } 
    }
}


/*Draft java code by "Lazarus Android Module Wizard" [8/13/2014 1:43:12]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jPreferences /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    
    private SharedPreferences mPreferences;
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jPreferences(Controls _ctrls, long _Self, boolean _IsShared) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       
       if (_IsShared) { 
          mPreferences = PreferenceManager.getDefaultSharedPreferences(context);
       }
       else {
          mPreferences = _ctrls.activity.getPreferences(Context.MODE_PRIVATE);
       }
       
    }

    public void jFree() {
      //free local objects...
    	mPreferences = null;
    }

  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
   public int GetIntData(String _key, int _defaultValue) {
		return mPreferences.getInt(_key, _defaultValue);
	}

	public void SetIntData(String _key, int _value) {
		SharedPreferences.Editor edt = mPreferences.edit();
		edt.putInt(_key, _value);
		edt.commit();
	}

	public String GetStringData(String _key, String _defaultValue) {
		return mPreferences.getString(_key, _defaultValue);
	}

	public void SetStringData(String _key, String _value) {
		SharedPreferences.Editor edt = mPreferences.edit();
		edt.putString(_key, _value);
		edt.commit();
	}

	public boolean GetBoolData(String _key, boolean _defaultValue) {
		return mPreferences.getBoolean(_key, _defaultValue);
	}

	public void SetBoolData(String _key, boolean _value) {
		SharedPreferences.Editor edt = mPreferences.edit();
		edt.putBoolean(_key, _value);
		edt.commit();
	}
}

//by jmpessoa
class jImageFileManager /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    
    //Warning: please, preferentially init your news params names with "_", ex: int _flag, String _hello ...
    public jImageFileManager(Controls _ctrls, long _Self) { //Add more here new "_xxx" params if needed!
       //super(contrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;                   
    }

    public void jFree() {
      //free local objects...        	
    }

   public void SaveToSdCard(Bitmap _image, String _filename) {	
	   	  	   
	    File file;
	    String root = Environment.getExternalStorageDirectory().toString();
	    
	    file = new File (root+"/"+_filename);	
	    
	    if (file.exists ()) file.delete (); 
	    try {
	       FileOutputStream out = new FileOutputStream(file);	           	           	         
	     
           if ( _filename.toLowerCase().contains(".jpg") ) _image.compress(Bitmap.CompressFormat.JPEG, 90, out);
	       if ( _filename.toLowerCase().contains(".png") ) _image.compress(Bitmap.CompressFormat.PNG, 100, out);	       
	       
	       out.flush();
	       out.close();
	    } catch (Exception e) {
           e.printStackTrace();
	    }
	    
   }
   
   // By using this line you can able to see saved images in the gallery view.
   public void ShowImagesFromGallery () {	   
	   controls.activity.sendBroadcast(new Intent(
		   Intent.ACTION_MEDIA_MOUNTED,
		   Uri.parse("file://" + Environment.getExternalStorageDirectory())));
   }
   
   public Bitmap LoadFromSdCard(String _filename) {	   
	      String imageInSD = Environment.getExternalStorageDirectory().getPath()+"/"+_filename;	      
	      Bitmap bitmap = BitmapFactory.decodeFile(imageInSD);	      
	      return bitmap; 
   }
      
   //http://android-er.blogspot.com.br/2010/07/save-file-to-sd-card.html
   private InputStream OpenHttpConnection(String strURL) throws IOException{
	   InputStream inputStream = null;
	   URL url = new URL(strURL);
	   URLConnection conn = url.openConnection();

	   try{
	    HttpURLConnection httpConn = (HttpURLConnection)conn;
	    httpConn.setRequestMethod("GET");
	    httpConn.connect();

	    if (httpConn.getResponseCode() == HttpURLConnection.HTTP_OK) {
	     inputStream = httpConn.getInputStream();
	    }
	   }
	   catch (Exception ex)
	   {
	   }
	   return inputStream;
   }
   
   public Bitmap LoadFromURL(String _imageURL) {
	   
    BitmapFactory.Options bmOptions;
	bmOptions = new BitmapFactory.Options();
	bmOptions.inSampleSize = 1;
	   
    Bitmap bitmap = null;
    InputStream in = null;      
       try {
           in = OpenHttpConnection(_imageURL);
           bitmap = BitmapFactory.decodeStream(in, null, bmOptions);
           in.close();
       } catch (IOException e1) {
       }
       return bitmap;              
       
   }
                   
   public Bitmap LoadFromAssets(String strName)
   {
       AssetManager assetManager = controls.activity.getAssets();
       InputStream istr = null;
       try {
           istr = assetManager.open(strName);
       } catch (IOException e) {
           e.printStackTrace();
       }
       Bitmap bitmap = BitmapFactory.decodeStream(istr);
       return bitmap;
   }
  
   private int GetDrawableResourceId(String _resName) {
   	  try {
   	     Class<?> res = R.drawable.class;
   	     Field field = res.getField(_resName);  //"drawableName"
   	     int drawableId = field.getInt(null);
   	     return drawableId;
   	  }
   	  catch (Exception e) {
   	     Log.e("jImageFileManager", "Failure to get drawable id.", e);
   	     return 0;
   	  }
   }

   private Drawable GetDrawableResourceById(int _resID) {
   	  return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
   }
             
   public Bitmap LoadFromResources(String _imageResIdentifier)
   {
	  Drawable d = GetDrawableResourceById(GetDrawableResourceId(_imageResIdentifier));
	  Bitmap bmap = ((BitmapDrawable)d).getBitmap();
      return bmap;
   }
   
   public Bitmap LoadFromFile(String _filename) {	   
	   Bitmap bmap=null;	  
	   File fDir = this.controls.activity.getFilesDir();  //Result : /data/data/com/MyApp/files
	   File file = new File(fDir, _filename);	   
	   InputStream fileInputStream = null;	   
  	   try {
		 fileInputStream = new FileInputStream(file);
		 BitmapFactory.Options bitmapOptions = new BitmapFactory.Options();
		 bitmapOptions.inSampleSize = 1; //original image size :: 4 --> size 1/4!
		 bitmapOptions.inJustDecodeBounds = false; //If set to true, the decoder will return null (no bitmap), 
		 bmap = BitmapFactory.decodeStream(fileInputStream, null, bitmapOptions);		 
	   } catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		 e.printStackTrace();
	   }  	   
  	   return bmap;  	   
   }
   
   public Bitmap LoadFromFile(String _path, String _filename) {	   
	   String imageIn = _path+"/"+_filename;	      
	   Bitmap bitmap = BitmapFactory.decodeFile(imageIn);	      
	   return bitmap; 
   }
   
   public void SaveToFile(Bitmap _image, String _filename) {	   	    
	    String root = this.controls.activity.getFilesDir().getAbsolutePath();	      	    	    
	    File file = new File (root +"/"+ _filename);	    
	    if (file.exists ()) file.delete (); 
	    try {
	        FileOutputStream out = new FileOutputStream(file);	  
	        
	        if ( _filename.toLowerCase().contains(".jpg") ) _image.compress(Bitmap.CompressFormat.JPEG, 90, out);
	        if ( _filename.toLowerCase().contains(".png") ) _image.compress(Bitmap.CompressFormat.PNG, 100, out);
	        
	         out.flush();
	         out.close();
	    } catch (Exception e) {
	         e.printStackTrace();
	    }  	     	   
   }
      
   public void SaveToFile(Bitmap _image,String _path, String _filename) {	   	    
	       	    	    
	    File file = new File (_path +"/"+ _filename);	    
	    if (file.exists ()) file.delete (); 
	    try {
	        FileOutputStream out = new FileOutputStream(file);	  
	        
	        if ( _filename.toLowerCase().contains(".jpg") ) _image.compress(Bitmap.CompressFormat.JPEG, 90, out);
	        if ( _filename.toLowerCase().contains(".png") ) _image.compress(Bitmap.CompressFormat.PNG, 100, out);
	        
	         out.flush();
	         out.close();
	    } catch (Exception e) {
	         e.printStackTrace();
	    }  	     	   
  }
  
   public Bitmap LoadFromUri(Uri _imageUri) {
        InputStream imageStream;
        Bitmap selectedImage= null;
		try {
			imageStream = controls.activity.getContentResolver().openInputStream(_imageUri);
			selectedImage = BitmapFactory.decodeStream(imageStream);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}        
        return selectedImage;
   }
         
   public  Bitmap LoadFromFile(String _filename, int _scale) {
	   BitmapFactory.Options options = new BitmapFactory.Options();
	   options.inSampleSize = _scale; // --> 1/4
	   return BitmapFactory.decodeFile(_filename, options);
   }

   public Bitmap CreateBitmap(int _width, int _height) {
	    return Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888 );
   }
   
   public int GetBitmapWidth(Bitmap _bitmap) {	 	 
	 	if ( _bitmap != null ) {
	 	   return _bitmap.getWidth();	 	  
	 	} else return 0;	 	 
    }

    public  int GetBitmapHeight(Bitmap _bitmap) {	 
	 	if ( _bitmap != null ) {
	 	   return _bitmap.getHeight();	  
	 	} else return 0;	 
    }
	 
	public byte[] GetByteArrayFromBitmap(Bitmap _bitmap, String _compressFormat) {
	     
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		String strUpper = _compressFormat.toUpperCase();		
	     
	     if (  strUpper.equals("WEBP") ) { 
	        _bitmap.compress(CompressFormat.WEBP, 0, stream); //O: PNG will ignore the quality setting...
	     } else if (  strUpper.equals("JPEG") ){
	    	 _bitmap.compress(CompressFormat.JPEG, 0, stream); //O: PNG will ignore the quality setting... 
	     } else {
	    	 _bitmap.compress(CompressFormat.PNG, 0, stream); //O: PNG will ignore the quality setting... 
	     }
	     return stream.toByteArray();
	 }

	public Bitmap SetByteArrayToBitmap(byte[] _imageArray) {
	    return BitmapFactory.decodeByteArray(_imageArray, 0, _imageArray.length);
	}

	 //http://androidtrainningcenter.blogspot.com.br/2012/05/bitmap-operations-like-re-sizing.html
	public Bitmap ClockWise(Bitmap _bitmap, ImageView _imageView){
	     Matrix mMatrix = new Matrix();
	     Matrix mat= _imageView.getImageMatrix();    
	     mMatrix.set(mat);
	     mMatrix.setRotate(90);
	     return Bitmap.createBitmap(_bitmap , 0, 0, _bitmap.getWidth(), _bitmap.getHeight(), mMatrix, false);    
	} 

	public Bitmap AntiClockWise(Bitmap _bitmap, ImageView _imageView){
	     Matrix mMatrix = new Matrix();
	     Matrix mat= _imageView.getImageMatrix();    
	     mMatrix.set(mat);
	     mMatrix.setRotate(-90);
	     return Bitmap.createBitmap(_bitmap, 0, 0, _bitmap.getWidth(), _bitmap.getHeight(), mMatrix, false);    
	}
	
	public Bitmap SetScale(Bitmap _bmp, ImageView _imageView, float _scaleX, float _scaleY ) {  
	    Matrix mMatrix = new Matrix();
	    Matrix mat= _imageView.getImageMatrix();    
	    mMatrix.set(mat);        
		mMatrix.setScale(_scaleX, _scaleY);
		return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), mMatrix, false);	   
	}

	public Bitmap GetBitmapFromDecodedFile(String _imagePath) {
	   return BitmapFactory.decodeFile(_imagePath);
	}
	
	
	public Bitmap GetBitmapFromIntentResult(Intent _intentData) {						
		Uri selectedImage = _intentData.getData();
		String[] filePathColumn = { MediaStore.Images.Media.DATA };	 
	    Cursor cursor = controls.activity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
	    cursor.moveToFirst();
	    int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
	    String picturePath = cursor.getString(columnIndex);
	    cursor.close();
	    return BitmapFactory.decodeFile(picturePath);    
	}
	
	
	public Bitmap GetBitmapThumbnailFromCamera(Intent _intentData) {
		Bundle extras = _intentData.getExtras();
	    return (Bitmap) extras.get("data");    
	}
	
	//TODO Pascal
	public String GetImageFilePath(Intent _intentData) {
		   //Uri selectedImage = data.getData();
	  Uri selectedImage = _intentData.getData();	
	  String[] filePathColumn = { MediaStore.Images.Media.DATA };	   
	  Cursor cursor = controls.activity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
	  cursor.moveToFirst();
	  int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
	  String path = cursor.getString(columnIndex);
	  cursor.close();               
	  return path;
	  // String path contains the path of selected Image  
	}

	public Bitmap LoadFromUri(String _uriAsString) {
		   Uri imageUri =  Uri.parse(_uriAsString);
	       InputStream imageStream;
	       Bitmap selectedImage= null;
			try {
				imageStream = controls.activity.getContentResolver().openInputStream(imageUri);
				selectedImage = BitmapFactory.decodeStream(imageStream);
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}        
	       return selectedImage;
	}
}

//by jmpessoa
class jActionBarTab {
		
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    private int mCountTab = 0;
    
    //Warning: please, preferentially init your news params names with "_", ex: int _flag, String _hello ...
    public jActionBarTab(Controls _ctrls, long _Self) { //Add more here new "_xxx" params if needed!
       //super(contrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;                   
    }

    public void jFree() {
      //free local objects...        	
    }

	public ActionBar GetActionBar() { 
	    return this.controls.activity.getActionBar();
	}

	/*
	 * To disableAction-bar Icon and Title, you must do two things:
	 setDisplayShowHomeEnabled(false);  // hides action bar icon
	 setDisplayShowTitleEnabled(false); // hides action bar title
	 */

	private class TabListener implements ActionBar.TabListener {
		
		TabContentFragment mFragment;
		
		/*.*/public TabListener(TabContentFragment v) {
			mFragment = v;
		}
		//http://www.grokkingandroid.com/adding-action-items-from-within-fragments/
		//http://www.j2eebrain.com/java-J2ee-android-menus-and-action-bar.html
		//http://www.thesparkmen.com/2013/2/15/dynamic-action-bar-buttons.aspx
		//https://github.com/codepath/android_guides/wiki/Creating-and-Using-Fragments  otimo!
		//http://www.lucazanini.eu/2012/android/tab-layout-in-android-with-actionbar-and-fragment/?lang=en
	    @Override
	    /*.*/public void onTabSelected(ActionBar.Tab tab, FragmentTransaction ft) {    	  
	    	mFragment.getView().setVisibility(View.VISIBLE);	    	
	    	controls.pOnActionBarTabSelected(pascalObj, mFragment.getView(), mFragment.getText());    	    	
	    	if(mFragment.isAdded()){
	    	    ft.show(mFragment);
	    	}  
	    	else {
	    		ft.add(0, mFragment, mFragment.getText()); //0=null container!
	    	}     	   	
	    }
	 
	    @Override
	    /*.*/public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction ft) {	    	
	    	//mFragment.getView().setVisibility(View.GONE);	    	
	    	controls.pOnActionBarTabUnSelected(pascalObj, mFragment.getView(), mFragment.getText());	    		    
	    	if (mFragment != null) {
	             ft.hide(mFragment);
	         }	    	
	    }
	 
	    @Override
	    /*.*/public void onTabReselected(ActionBar.Tab tab, FragmentTransaction ft) {
	    }
	}

	private class TabContentFragment extends Fragment {
	    private View mView;
	    private String mText;
	    /*.*/public TabContentFragment(View v, String tag) {	    	
	        mView = v;	       
	        mText = tag;
	    }

	    /*.*/public String getText() {
	        return mText;
	    }
	    
	    /*.*/public View getView() {
	        return mView;
	    }
	        
	    @Override
	    /*.*/public void onActivityCreated(Bundle savedInstanceState) {
	       super.onActivityCreated(savedInstanceState);   
	    }
	    
	    @Override
	    /*.*/public View onCreateView(LayoutInflater inflater, ViewGroup container,
	            Bundle savedInstanceState) {    	    	     	 
	    	    /*
	    	     * You can access the container's id by calling
	               ((ViewGroup)getView().getParent()).getId();
	    	     */
	    	 LayoutParams lparams = new LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
	    	 lparams.addRule(RelativeLayout.CENTER_IN_PARENT);
	    	 mView.setLayoutParams(lparams);
	         return mView;
	    }
	}

	private ActionBar.Tab CreateTab(String title, View v) {	  	
	  ActionBar actionBar = this.controls.activity.getActionBar();
	  ActionBar.Tab tab = actionBar.newTab();           
	  tab.setText(title); //
	  if (mCountTab != 0) {
	     v.setVisibility(View.INVISIBLE);
	  }   
	  TabContentFragment content = new TabContentFragment(v, title);
	  tab.setTabListener(new TabListener(content)); // All tabs must have a TabListener set before being added to the ActionBar.
	  mCountTab= mCountTab + 1;
	  return tab; 
	}

	//This method adds a tab for use in tabbed navigation mode
	public void Add(String _title, View _panel, String _iconIdentifier){
		  ActionBar.Tab tab = CreateTab(_title, _panel);  
		  if (!_iconIdentifier.equals("")) {
		      tab.setIcon(GetDrawableResourceById(GetDrawableResourceId(_iconIdentifier))); //_iconIdentifier
		  }
		  ActionBar actionBar = this.controls.activity.getActionBar();
		  actionBar.addTab(tab, false);		  
	}

	public void Add(String _title, View _panel){
		  ActionBar.Tab tab = CreateTab(_title, _panel);  	 
		  ActionBar actionBar = this.controls.activity.getActionBar();	
	  	  actionBar.addTab(tab, false);  	    	 
	}

	public void Add(String _title, View _panel, View _customTabView){
		  ActionBar.Tab tab = CreateTab(_title, _panel);
		  _customTabView.setVisibility(View.VISIBLE); 
		  tab.setCustomView(_customTabView);	//This overrides values set by setText(CharSequence) and setIcon(Drawable).	  
		  ActionBar actionBar = this.controls.activity.getActionBar();
		  actionBar.addTab(tab, false);	  
	}

	public void SetTabNavigationMode(){
		ActionBar actionBar = this.controls.activity.getActionBar();
		actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);	//API 11
		actionBar.setSelectedNavigationItem(0);
	}

	//This method remove all tabs from the action bar and deselect the current tab
	public void RemoveAllTabs() {
		ActionBar actionBar = this.controls.activity.getActionBar();
		actionBar.removeAllTabs();
	}

			
	//http://daniel-codes.blogspot.com.br/2009/12/dynamically-retrieving-resources-in.html
	/*
	*Given that you can access R.java just fine normally in code.
	*As long as you are retrieving data from your application's R.java - Use reflection!
	*/

	//by jmpessoa
	private int GetDrawableResourceId(String _resName) {
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     Log.e("jActionBarTab", "Failure to get drawable id.", e);
		     return 0;
		  }
	}
	
	//by jmpessoa
	private Drawable GetDrawableResourceById(int _resID) {
		return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
	}
	

	//This method returns the currently selected tab if in tabbed navigation mode and there is at least one tab present
	public Tab GetSelectedTab() {
		ActionBar actionBar = this.controls.activity.getActionBar();
		ActionBar.Tab tab = actionBar.getSelectedTab();
		return tab;
	}

	//This method select the specified tab
	public void SelectTab(ActionBar.Tab tab){
		ActionBar actionBar = this.controls.activity.getActionBar();
		actionBar.selectTab(tab);
	}	
	
	public Tab GetTabAtIndex(int _index){
		ActionBar actionBar = this.controls.activity.getActionBar();
		actionBar.setSelectedNavigationItem(_index);
		return actionBar.getTabAt(_index); 
	}
	
	
	public void SelectTabByIndex(int _index){
		ActionBar actionBar = this.controls.activity.getActionBar();
		actionBar.setSelectedNavigationItem(_index);		 
	}
	
}


/*Draft java code by "Lazarus Android Module Wizard" [12/4/2014 23:21:31]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

class jCustomDialog extends RelativeLayout {

   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events

   private Context context = null;
   private ViewGroup parent   = null;         // parent view
   private LayoutParams lparams;              // layout XYWH
   //private OnClickListener onClickListener;   // click event
   //private Boolean enabled  = true;           // click-touch enabled!
   private int lparamsAnchorRule[] = new int[30];
   private int countAnchorRule = 0;
   private int lparamsParentRule[] = new int[30];
   private int countParentRule = 0;
   private int lparamH = 100;
   private int lparamW = 100;
   private int marginLeft = 0;
   private int marginTop = 0;
   private int marginRight = 0;
   private int marginBottom = 0;

   Dialog mDialog = null;
   private String mIconIdentifier = "ic_launcher";   //default icon  ../res/drawable
   private String mTitle = "Information";
   boolean mRemovedFromParent = false; //no parent!   

  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public jCustomDialog(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      lparams = new LayoutParams(lparamW, lparamH);
      //lparams = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);		
   } //end constructor

   public void jFree() {
      if (parent != null) { parent.removeView(this); }
      //free local objects...      
  	  if (mDialog != null) mDialog.dismiss();
	  mDialog = null;		
      lparams = null;
      //parent = null;  //?!
      //setOnClickListener(null);
   }

   public void SetViewParent(ViewGroup _viewgroup) {
      if (parent != null) { parent.removeView(this); }
      parent = _viewgroup;
      parent.addView(this,lparams);
      mRemovedFromParent = false; //now there is a parent!    	
   }

   public void RemoveFromViewParent() {
      if (!mRemovedFromParent) {
    	 this.setVisibility(android.view.View.INVISIBLE);
    	 if (parent != null) {
            parent.removeView(this);
            mRemovedFromParent = true; //no more parent!
            //Log.i("jCustomDialog", "...RemoveFromViewParent...");
    	 }          
       }
   }
   
   public View GetView() {
      return this;
   }
   

   public void SetLParamWidth(int _w) {
      lparamW = _w;
   }

   public void SetLParamHeight(int _h) {
      lparamH = _h;
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
      marginLeft = _left;
      marginTop = _top;
      marginRight = _right;
      marginBottom = _bottom;
      lparamH = _h;
      lparamW = _w;
   }

   public void AddLParamsAnchorRule(int _rule) {
      lparamsAnchorRule[countAnchorRule] = _rule;
      countAnchorRule = countAnchorRule + 1;
   }

   public void AddLParamsParentRule(int _rule) {
      lparamsParentRule[countParentRule] = _rule;
      countParentRule = countParentRule + 1;
   }

   public void SetLayoutAll(int _idAnchor) {
  	lparams.width  = lparamW;
	lparams.height = lparamH;
	lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
	if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
		lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	}
      for (int j=0; j < countParentRule; j++) {
         lparams.addRule(lparamsParentRule[j]);
      }
      this.setLayoutParams(lparams);
   }

   public void ClearLayoutAll() {
	 for (int i=0; i < countAnchorRule; i++) {
  	   lparams.removeRule(lparamsAnchorRule[i]);
     }

	 for (int j=0; j < countParentRule; j++) {
   	   lparams.removeRule(lparamsParentRule[j]);
	 }
	 countAnchorRule = 0;
	 countParentRule = 0;
   }

   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }
   
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...   
	private int GetDrawableResourceId(String _resName) {   //    ../res/drawable
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     Log.e("jCustomDialog", "Failure to get drawable id.", e);
		     return 0;
		  }
	}
	
	public void Show() {	//0: vis; 4: inv; 8: gone
		Show(mTitle, mIconIdentifier);
	}
	
	public void Show(String _title) {	//0: vis; 4: inv; 8: gone
		Show(_title, mIconIdentifier);
	}
		
	public void Show(String _title, String _iconIdentifier) {	//0: vis; 4: inv; 8: gone
		mTitle = _title;
		mIconIdentifier = _iconIdentifier;
		if (mDialog != null) {
			mDialog.setTitle(mTitle);
		    controls.pOnCustomDialogShow(pascalObj, mDialog, _title);
			mDialog.show();
		}	
		else {			
		  if (this.getVisibility()==0) { //visible   
			this.setVisibility(android.view.View.INVISIBLE); //4
		  }	  		   
		  if (!mRemovedFromParent) {
		  	 parent.removeView(this);
		     mRemovedFromParent = true;
		  }					   
	      mDialog = new Dialog(this.controls.activity);	      
	      mDialog.requestWindowFeature(Window.FEATURE_LEFT_ICON);	     	     
	      mDialog.setContentView(this);	      
	      mDialog.setFeatureDrawableResource(Window.FEATURE_LEFT_ICON, GetDrawableResourceId(mIconIdentifier));	      
	      mDialog.setTitle(mTitle);
	      
	       //fix by @renabor	      	      	      	      
	      mDialog.setOnKeyListener(new Dialog.OnKeyListener() {
	    	  @Override
	    	    public  boolean onKey(DialogInterface arg0, int keyCode, KeyEvent event) {
	    	       if (event.getAction() == KeyEvent.ACTION_UP) {
	    	          if (keyCode == KeyEvent.KEYCODE_BACK) {
	    	               controls.pOnCustomDialogBackKeyPressed(pascalObj, mTitle);
	    	               if (mDialog != null) mDialog.dismiss();
	    	               return false; 
	    	          } else if (keyCode == KeyEvent.KEYCODE_ENTER) {
	    	              InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
	    	              imm.hideSoftInputFromWindow(getWindowToken(), 0);
	    	              controls.pOnEnter(pascalObj);
	    	              return true;
	    	          }
	    	       }
	    	       return false;
	    	     }
	    	  });
	      	      	      
	      this.setVisibility(android.view.View.VISIBLE);
	 	  controls.pOnCustomDialogShow(pascalObj, mDialog, mTitle);	      
	      mDialog.show();							
		}		   
	}
	
	public void SetTitle(String _title) { 
	   mTitle = _title;
	   mDialog.setTitle(mTitle);
	}
	
	public void SetIconIdentifier(String _iconIdentifier) {   // ../res/drawable
		mIconIdentifier = _iconIdentifier;
		mDialog.requestWindowFeature(Window.FEATURE_LEFT_ICON);
		mDialog.setFeatureDrawableResource(Window.FEATURE_LEFT_ICON, GetDrawableResourceId(mIconIdentifier));
	}
	
	public void Close() { 
		if (mDialog != null) mDialog.dismiss();    
	}	
} //end class


/*Draft java code by "Lazarus Android Module Wizard" [1/6/2015 22:13:32]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

class jToggleButton extends ToggleButton /*dummy*/ { //please, fix what GUI object will be extended!

   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events

   private Context context = null;
   private ViewGroup parent   = null;         // parent view
   private LayoutParams lparams;              // layout XYWH
   private OnClickListener onClickListener;   // click event
   
   private Boolean enabled  = false;           // click-touch enabled!
   
   private int lparamsAnchorRule[] = new int[30];
   private int countAnchorRule = 0;
   private int lparamsParentRule[] = new int[30];
   private int countParentRule = 0;
   private int lparamH = 100;
   private int lparamW = 100;
   private int marginLeft = 0;
   private int marginTop = 0;
   private int marginRight = 0;
   private int marginBottom = 0;
   private boolean mRemovedFromParent = false;
   
   boolean mState = false;   

  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public jToggleButton(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      lparams = new LayoutParams(lparamW, lparamH);

      onClickListener = new OnClickListener(){
    	   
      /*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!
    	      mState = !mState;
              if (enabled) {
            	  controls.pOnClickToggleButton(pascalObj, mState);            	
              }
           };
      };
      setOnClickListener(onClickListener);
      
   } //end constructor

   public void jFree() {
      if (parent != null) { parent.removeView(this); }
      //free local objects...
      lparams = null;
      setOnClickListener(null);
   }

   public void SetViewParent(ViewGroup _viewgroup) {
      if (parent != null) { parent.removeView(this); }
      parent = _viewgroup;
      parent.addView(this,lparams);
      mRemovedFromParent = false;
   }

   public void RemoveFromViewParent() {
      if (!mRemovedFromParent) {
         this.setVisibility(android.view.View.INVISIBLE);
         if (parent != null)
    	       parent.removeView(this);
	   mRemovedFromParent = true;
	}
      
   }

   public View GetView() {
      return this;
   }

   public void SetLParamWidth(int _w) {
      lparamW = _w;
   }

   public void SetLParamHeight(int _h) {
      lparamH = _h;
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
      marginLeft = _left;
      marginTop = _top;
      marginRight = _right;
      marginBottom = _bottom;
      lparamH = _h;
      lparamW = _w;
   }

   public void AddLParamsAnchorRule(int _rule) {
      lparamsAnchorRule[countAnchorRule] = _rule;
      countAnchorRule = countAnchorRule + 1;
   }

   public void AddLParamsParentRule(int _rule) {
      lparamsParentRule[countParentRule] = _rule;
      countParentRule = countParentRule + 1;
   }

   public void SetLayoutAll(int _idAnchor) {
  	lparams.width  = lparamW;
	lparams.height = lparamH;
	lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
	if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
		lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	}
      for (int j=0; j < countParentRule; j++) {
         lparams.addRule(lparamsParentRule[j]);
      }
      this.setLayoutParams(lparams);
   }

   public void ClearLayoutAll() {
	for (int i=0; i < countAnchorRule; i++) {
  	   lparams.removeRule(lparamsAnchorRule[i]);
    	}

	for (int j=0; j < countParentRule; j++) {
   	   lparams.removeRule(lparamsParentRule[j]);
	}
	countAnchorRule = 0;
	countParentRule = 0;
   }

   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }

  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public void SetChecked(boolean _value) {
	 mState = _value;  
     this.setChecked(_value);
   }

   public void SetTextOn(String _caption) {
     this.setTextOn(_caption);
   }

   public void SetTextOff(String _caption) {
     this.setTextOff(_caption);
   }

   public void Toggle() { //reset toggle button value.
	 mState = !mState;  
     this.toggle();
   }
   
   public boolean IsChecked(){
	  return this.IsChecked();
  }
  
  private int GetDrawableResourceId(String _resName) {   //    ../res/drawable
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     Log.e("toglebutton", "Failure to get drawable id.", e);
		     return 0;
		  }
  }

  private Drawable GetDrawableResourceById(int _resID) {
		return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
  } 

  public void SetBackgroundDrawable(String _imageIdentifier) {	  
     this.setBackgroundDrawable(GetDrawableResourceById(GetDrawableResourceId(_imageIdentifier)));
  } 
  
  public void DispatchOnToggleEvent(boolean _value) {
	   enabled = _value;
  }

} //end class

/*Draft java code by "Lazarus Android Module Wizard" [1/8/2015 22:10:35]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

class jSwitchButton extends Switch /*API 14*/ { //please, fix what GUI object will be extended!

   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events

   private Context context = null;
   private ViewGroup parent   = null;         // parent view
   private LayoutParams lparams;              // layout XYWH
   
   private OnCheckedChangeListener onClickListener ;   // click event
   
   private Boolean enabled  = false;           // click-touch not enabled!
   
   private int lparamsAnchorRule[] = new int[30];
   private int countAnchorRule = 0;
   private int lparamsParentRule[] = new int[30];
   private int countParentRule = 0;
   private int lparamH = 100;
   private int lparamW = 100;
   private int marginLeft = 0;
   private int marginTop = 0;
   private int marginRight = 0;
   private int marginBottom = 0;
   private boolean mRemovedFromParent = false;

  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public jSwitchButton(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      lparams = new LayoutParams(lparamW, lparamH);

      onClickListener = new OnCheckedChangeListener(){
      /*.*/public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {  //please, do not remove /*.*/ mask for parse invisibility!
              if (enabled) {
                 controls.pOnChangeSwitchButton(pascalObj, isChecked); //JNI event onClick!
              }
           };
      };
      setOnCheckedChangeListener(onClickListener);
   } //end constructor

   public void jFree() {
      if (parent != null) { parent.removeView(this); }
      //free local objects...
      lparams = null;
      setOnClickListener(null);
   }

   public void SetViewParent(ViewGroup _viewgroup) {
      if (parent != null) { parent.removeView(this); }
      parent = _viewgroup;
      parent.addView(this,lparams);
      mRemovedFromParent = false;
   }

   public void RemoveFromViewParent() {
      if (!mRemovedFromParent) {
         this.setVisibility(android.view.View.INVISIBLE);
         if (parent != null)
    	       parent.removeView(this);
	   mRemovedFromParent = true;
	}
   }

   public View GetView() {
      return this;
   }

   public void SetLParamWidth(int _w) {
      lparamW = _w;
   }

   public void SetLParamHeight(int _h) {
      lparamH = _h;
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
      marginLeft = _left;
      marginTop = _top;
      marginRight = _right;
      marginBottom = _bottom;
      lparamH = _h;
      lparamW = _w;
   }

   public void AddLParamsAnchorRule(int _rule) {
      lparamsAnchorRule[countAnchorRule] = _rule;
      countAnchorRule = countAnchorRule + 1;
   }

   public void AddLParamsParentRule(int _rule) {
      lparamsParentRule[countParentRule] = _rule;
      countParentRule = countParentRule + 1;
   }

   public void SetLayoutAll(int _idAnchor) {
  	lparams.width  = lparamW;
	lparams.height = lparamH;
	lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
	if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
		lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	}
      for (int j=0; j < countParentRule; j++) {
         lparams.addRule(lparamsParentRule[j]);
      }
      this.setLayoutParams(lparams);
   }

   public void ClearLayoutAll() {
	for (int i=0; i < countAnchorRule; i++) {
  	   lparams.removeRule(lparamsAnchorRule[i]);
    	}

	for (int j=0; j < countParentRule; j++) {
   	   lparams.removeRule(lparamsParentRule[j]);
	}
	countAnchorRule = 0;
	countParentRule = 0;
   }

   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }	   
   
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public void SetTextOff(String _caption) {
      this.setTextOff(_caption);
   }	   

   public void SetTextOn(String _caption) {
	   this.setTextOn(_caption);
   }
   
   public void SetChecked(boolean _state) { 
      this.setChecked(_state);
   }
   
   public void Toggle() {
	   this.toggle();
   }
   
   public boolean IsChecked(){
	  return this.IsChecked();
   }
   
   /*
   private Drawable GetDrawableResourceById(int _resID) {
		return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
   }
   */
   
   private int GetDrawableResourceId(String _resName) {   //    ../res/drawable
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     Log.e("toglebutton", "Failure to get drawable id.", e);
		     return 0;
		  }
   }
   
   public void SetThumbIcon(String _thumbIconIdentifier) {	   //Api  16
	   this.setThumbResource(GetDrawableResourceId(_thumbIconIdentifier));
   }
   
   public void DispatchOnToggleEvent(boolean _value) {
	   enabled = _value;
   }
   
   /*
   public void SetShowText(boolean _state) {  //Api 21
	  this.setShowText(_state);
   }
   */
   
} //end class


class jGridItem{
	
	Context ctx;
	String label;
	int itemTextColor;
	int itemTextSize;
	int id;
	String drawableIdentifier;
	
	public  jGridItem(Context context) {
		ctx = context;
		itemTextColor = 0; //default
	}
}

class jGridViewCustomAdapter extends ArrayAdapter {
     Context context;
     
     Controls contrls;
     
     long pascalObj;
     
     boolean mDispatchOnDrawItemTextColor;
     boolean mDispatchOnDrawItemBitmap;
     
     int mTextSizeTypedValue;
          
     private int itemsLayout; 
     private List <jGridItem> items ;
     
     public jGridViewCustomAdapter(Context context, Controls ctrls,long pasobj, int ResourceId, int itemslayout, List<jGridItem> list) {
        super(context, ResourceId, list);  //ResourceId/0 or android.R.layout.simple_list_item_1;
        this.context=context;
        
        contrls = ctrls;
        pascalObj = pasobj;
        items = list;
        itemsLayout = itemslayout;
        mDispatchOnDrawItemTextColor = true;
        mDispatchOnDrawItemBitmap = true;
     
        mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
     }

     public void SetFontSizeUnit(int _unit) {	
  	   switch (_unit) {
  	      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
  	      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; 
  	      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
  	      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; 
  	      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; 
  	      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; 
  	      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 	      
         }   
     }
     
     public void SetDispatchOnDrawItemTextColor(boolean _value) {
    	 mDispatchOnDrawItemTextColor= _value;
     }
     
     public void SetDispatchOnDrawItemBitmap(boolean _value) {
    	 mDispatchOnDrawItemBitmap= _value;
     }
     
     @Override
     public int getCount() {
    	//Log.i("count",": "+items.size()); 
        return items.size();
     }
      
    @Override
 	public Object getItem(int position) {
 		return null;
 	}
  
 	@Override
 	public long getItemId(int position) {
 		return 0;
 	}
     
     @Override
     public View getView(int position, View convertView, ViewGroup parent) {
    	    	     	
    	LinearLayout listLayout = new LinearLayout(context);    	
    	listLayout.setLayoutParams(new GridView.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
    	      	   
        RelativeLayout itemLayout = new RelativeLayout(context);            
        itemLayout.setLayoutParams(new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
                        
        TextView textViewTitle = new TextView(context);
        
        textViewTitle.setPadding(10, 10, 10, 10); //try improve here ... 17-jan-2015
        
        ImageView imageViewItem = new ImageView(context);
        LayoutParams imgParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
        
        LayoutParams txtParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h        
        txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);
        if ( this.itemsLayout == 0 ) {
           imageViewItem.setPadding(25,20,25,40);               	
           txtParam.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);           
        }
        else {
           imageViewItem.setPadding(25,45,25,20);              
           txtParam.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        } 	
        
        
        if (mDispatchOnDrawItemBitmap)  {        	
           Bitmap  imageBmp = (Bitmap)contrls.pOnGridDrawItemBitmap(pascalObj, (int)position , items.get(position).label);
       	   if (imageBmp != null) {        		   
       	      imageViewItem.setImageBitmap(imageBmp);
       	      itemLayout.addView(imageViewItem, imgParam);
         	}
       	    else {
       		   if (! items.get(position).drawableIdentifier.equals("")) {       			
       		    	imageViewItem.setImageResource(GetDrawableResourceId( items.get(position).drawableIdentifier ));        	 
               	    itemLayout.addView(imageViewItem, imgParam);
       		    }  
            }	        	
       } 
       else {
       	 if (! items.get(position).drawableIdentifier.equals("")) {	
       		imageViewItem.setImageResource(GetDrawableResourceId( items.get(position).drawableIdentifier ));        	 
       	    itemLayout.addView(imageViewItem, imgParam);
       	  }   
        }
                    
        
        if (!items.get(position).label.equals("")) {
            textViewTitle.setText( items.get(position).label ); //+""+ items.get(position).id
            
            
            if (items.get(position).itemTextSize != 0) {              	
            	if ((mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP) )
            	   textViewTitle.setTextSize(mTextSizeTypedValue, items.get(position).itemTextSize);     
            	else 
            	  textViewTitle.setTextSize(items.get(position).itemTextSize);            	
            }
                                    
            if (mDispatchOnDrawItemTextColor)  {            	   
            	 int drawItemCaptionColor = contrls.pOnGridDrawItemCaptionColor(pascalObj, (int)position , items.get(position).label);
            	 if (drawItemCaptionColor != 0) {
            	     textViewTitle.setTextColor(drawItemCaptionColor); 
            	 }
            	 else {
            		 if (items.get(position).itemTextColor != 0) {	
                         textViewTitle.setTextColor(items.get(position).itemTextColor);
                  	}	 
            	 }
            } 
            else {
            	if (items.get(position).itemTextColor != 0) {	
                   textViewTitle.setTextColor(items.get(position).itemTextColor);
            	}   
            }       
                                                 
            itemLayout.addView(textViewTitle, txtParam);            
        }
        
        listLayout.addView(itemLayout);
        
        return listLayout;        
     }
     
     private int GetDrawableResourceId(String _resName) {   //    ../res/drawable
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     Log.e("gridViewItem", "Failure to get drawable id.", e);
		     return 0;
		  }
     }
     
     public void SetItemsLayout(int value) {
    	 itemsLayout = value;
     }

}
 
/*Draft java code by "Lazarus Android Module Wizard" [1/9/2015 18:20:04]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

class jGridView extends GridView /*dummy*/ { //please, fix what GUI object will be extended!

   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events

   private Context context = null;
   private ViewGroup parent   = null;         // parent view
   
   private RelativeLayout.LayoutParams lparams;              // layout XYWH
   
   private  OnItemClickListener onItemClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   private int lparamsAnchorRule[] = new int[30];
   private int countAnchorRule = 0;
   private int lparamsParentRule[] = new int[30];
   private int countParentRule = 0;
   private int lparamH = 100;
   private int lparamW = 100;
   private int marginLeft = 0;
   private int marginTop = 0;
   private int marginRight = 0;
   private int marginBottom = 0;
   private boolean mRemovedFromParent = false;
   private int lastSelectedItem = -1;
   String lastSelectedItemCaption = "";
   
   int mItemTextColor = 0;
   int mItemTextSize = 0;
   
   private jGridViewCustomAdapter gridViewCustomeAdapter;
   private ArrayList<jGridItem>  alist;
  
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jGridView(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      lparams = new RelativeLayout.LayoutParams(lparamW, lparamH);            
      alist = new ArrayList<jGridItem>();
            
      //Create the Custom Adapter Object      
      gridViewCustomeAdapter = new jGridViewCustomAdapter(this.controls.activity, controls, pascalObj, android.R.layout.simple_list_item_1, 0, alist);
      
      // Set the Adapter to GridView
      this.setAdapter(gridViewCustomeAdapter);

      onItemClickListener = new  OnItemClickListener(){
    	  
      /*.*/public void onItemClick(AdapterView<?> parent, View v, int position, long id){  //please, do not remove /*.*/ mask for parse invisibility!
              if (enabled) {            	  
            	 lastSelectedItem = (int)position;
        	     lastSelectedItemCaption = alist.get((int)position).label;
                 controls.pOnClickGridItem(pascalObj, (int)position , alist.get((int)position).label);
              }
           };
      };      
      
      this.setOnItemClickListener(onItemClickListener);
            
      this.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
    	    @Override
    	    public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
    	    	if (enabled) {	
    	    	  //Log.i("OnItemLongClickListener", "position = "+position);    	
    	      	   lastSelectedItem = (int)position;
    	    	   lastSelectedItemCaption = alist.get((int)position).label;
    	    	   controls.pOnLongClickGridItem(pascalObj, (int)position, lastSelectedItemCaption);    	        
    	    	}
    	    	return false;
    	    }
    	});
      
      this.setNumColumns(android.widget.GridView.AUTO_FIT);  //android.widget.GridView.AUTO_FIT --> -1
     
   } //end constructor
   
   public void jFree() {
      if (parent != null) { parent.removeView(this); }
      //free local objects...
      lparams = null;      
      alist.clear();      
      alist    = null;
      setAdapter(null);     
      gridViewCustomeAdapter = null;
      setOnItemClickListener(null);
	  setOnItemLongClickListener(null); // renabor
   }

   public void SetViewParent(ViewGroup _viewgroup) {
      if (parent != null) { parent.removeView(this); }
      parent = _viewgroup;
      parent.addView(this,lparams);
      mRemovedFromParent = false;
   }

   public void RemoveFromViewParent() {
      if (!mRemovedFromParent) {
         this.setVisibility(android.view.View.INVISIBLE);
         if (parent != null)
    	       parent.removeView(this);
	   mRemovedFromParent = true;
	}
   }

   public View GetView() {
      return this;
   }

   public void SetLParamWidth(int _w) {
      lparamW = _w;
   }

   public void SetLParamHeight(int _h) {
      lparamH = _h;
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
      marginLeft = _left;
      marginTop = _top;
      marginRight = _right;
      marginBottom = _bottom;
      lparamH = _h;
      lparamW = _w;
   }

   public void AddLParamsAnchorRule(int _rule) {
      lparamsAnchorRule[countAnchorRule] = _rule;
      countAnchorRule = countAnchorRule + 1;
   }

   public void AddLParamsParentRule(int _rule) {
      lparamsParentRule[countParentRule] = _rule;
      countParentRule = countParentRule + 1;
   }

   public void SetLayoutAll(int _idAnchor) {
  	 lparams.width  = lparamW;
	 lparams.height = lparamH;
	 lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
	 if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
		lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	 }
     for (int j=0; j < countParentRule; j++) {
         lparams.addRule(lparamsParentRule[j]);
     }
     this.setLayoutParams(lparams);
   }

   public void ClearLayoutAll() {
	   
	 for (int i=0; i < countAnchorRule; i++) {
  	   lparams.removeRule(lparamsAnchorRule[i]);
     }

	 for (int j=0; j < countParentRule; j++) {
   	   lparams.removeRule(lparamsParentRule[j]);
	 }
	
	 countAnchorRule = 0;
	 countParentRule = 0;
   }

   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }

  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
      
 //by jmpessoa
   public  void Add(String _item, String _imgIdentifier) {
   	  jGridItem info = new jGridItem(controls.activity);
   	  info.label = _item;
   	  info.drawableIdentifier = _imgIdentifier;
   	  info.id = alist.size();
   	  info.itemTextColor = mItemTextColor;
   	  info.itemTextSize = mItemTextSize;
   	  alist.add(info);
   	  gridViewCustomeAdapter.notifyDataSetChanged();
   }
   
   public void SetNumColumns(int _value) {
	   if (_value <= 0) 
          this.setNumColumns(android.widget.GridView.AUTO_FIT);
	   else
		   this.setNumColumns(_value);  
   }
   
   public void SetColumnWidth(int _value) {
	   if (_value > 0) 
          this.setColumnWidth(_value);
	   else
		   this.setNumColumns(40);  
   }
      
   public  void Clear() {
	   alist.clear();
	   gridViewCustomeAdapter.notifyDataSetChanged();
   }
  
   public  void Delete(int _index) {
	   alist.remove(_index);
	   gridViewCustomeAdapter.notifyDataSetChanged();
   }

   public void SetItemsLayout(int _value){
	     //0: image-text  ; 1: text-image
	   gridViewCustomeAdapter.SetItemsLayout(_value);
   }
   
   public int  GetItemIndex() {
	   return lastSelectedItem;
   }
   
   public String GetItemCaption() {
	   return lastSelectedItemCaption;
   }
   
   public void DispatchOnDrawItemTextColor(boolean _value) {
	   gridViewCustomeAdapter.SetDispatchOnDrawItemTextColor(_value);
	}
   
   
   public void DispatchOnDrawItemBitmap(boolean _value) {
	   gridViewCustomeAdapter.SetDispatchOnDrawItemBitmap(_value);
	}
   
   public void SetFontSize(int _size) {	   	   
	   mItemTextSize = _size;
   }
   
   public void SetFontColor(int _color) {	  
	   mItemTextColor = _color;	
   }
   
   
   public void UpdateItemTitle(int _index, String _title) {
	   jGridItem info = alist.get(_index);
	   info.label = _title;
	   gridViewCustomeAdapter.notifyDataSetChanged();    
   }
   
   
} //end class


/*Draft java code by "Lazarus Android Module Wizard" [1/13/2015 22:20:02]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//refs.
//http://android-er.blogspot.com.br/2010/08/simple-compass-sensormanager-and.html
//http://www.coders-hub.com/2013/10/how-to-use-sensor-in-android.html#.VLWwqCvF_pA

class jSensorManager /*extends ...*/ {
  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
        
    private static SensorManager mSensorManager;

    private SensorEventListener mSensorEventListener;

    private List<Sensor> mListSensors;
    
    private Sensor mCurrSensor;
    
    private int mSensorType;
        
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jSensorManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;

       mSensorType = 1;  //TYPE_ACCELEROMETER
        
       //get sensor service
       mSensorManager=(SensorManager)controls.activity.getSystemService(Context.SENSOR_SERVICE);
       
       mListSensors = mSensorManager.getSensorList(Sensor.TYPE_ALL);
            
       mSensorEventListener = new SensorEventListener(){
         @Override
         /*.*/public void onAccuracyChanged(Sensor sensor, int accuracy) {
           //---->>>pascal handle event
         }  
      
         //This method is called when your mobile moves any direction 
         @Override  //ref. http://developer.android.com/reference/android/hardware/SensorEvent.html
         /*.*/public void onSensorChanged(SensorEvent event) {
         	 
        	   //get x, y, z values
        	   // Always use the "length" of the values array while performing operations on it.        	           	                	  
          	   int length = event.values.length;          	   
          	   float x,y,z;
          	   float[] values;          	 
          	         	             	      
      	  switch ( event.sensor.getType() ) {     
      	  case 1: //Sensor.TYPE_ACCELEROMETER:   //1 - acceleration applied to the device  
        	     values = event.values;
        		/*All values are in SI units (m/s^2)
        		  x: Acceleration minus Gx on the x-axis
        		  y: Acceleration minus Gy on the y-axis
        		  z: Acceleration minus Gz on the z-axis
        	    */        		
        	    /* ref. http://code.tutsplus.com/tutorials/using-the-accelerometer-on-android--mobile-22125
        	    * the onSensorChanged method is invoked several times per second. 
        	    * We don't need all this data so we need to make sure we only sample 
        	    * a subset of the data we get from the device's accelerometer.
        	    */        	   
                controls.pOnChangedSensor(pascalObj, event.sensor, 1,values,event.timestamp); //nanosecond
            break;
        	
      	  case 2://Sensor.TYPE_MAGNETIC_FIELD: //2        	//SensorManager.SENSOR_DELAY_UI
     		    values = event.values;
        		//x - Geomagnetic field strength along the x axis. [nanoteslas]
        		//y - Geomagnetic field strength along the y axis. [nanoteslas]
        		//z - Geomagnetic field strength along the z axis. [nanoteslas]
        	    controls.pOnChangedSensor(pascalObj, event.sensor, 2,values,event.timestamp); 
          break;
        	
          case 3: //Sensor.TYPE_ORIENTATION: //3 This constant was deprecated in API level 8. use SensorManager.getOrientation() instead.
        	  values = event.values;         	    
      		  controls.pOnChangedSensor(pascalObj, event.sensor, 3,values,event.timestamp);
          break;
          
          case 4: //Sensor.TYPE_GYROSCOPE: //4 - The gyroscope measures the rate or rotation in rad/s around a device's x, y, and z axis.
        	     values = event.values;
        		//x - rad/s - Rate of rotation around the x axis.
        		//y- rad/s - Rate of rotation around the y axis.
        		//z- rad/s - Rate of rotation around the z axis.
        		controls.pOnChangedSensor(pascalObj, event.sensor, 4,values,event.timestamp);
          break;       	
        	
          case 5: //Sensor.TYPE_LIGHT://5
    		   values= new float[1];
         	   values[0] = event.values[0]; //x table plane       	       
        		//x - values[0]: Ambient light level in SI lux units
        	   controls.pOnChangedSensor(pascalObj, event.sensor, 5,values,event.timestamp);
          break;

          case 6: //Sensor.TYPE_PRESSURE://6
    		   values= new float[1];
         	   values[0] = event.values[0];        	       
        	   //x - values[0]: Atmospheric pressure in hPa (millibar)
        	   controls.pOnChangedSensor(pascalObj, event.sensor, 6,values,event.timestamp);
          break;         
          
          case 7: //Sensor.TYPE_TEMPERATURE: //7 This constant was deprecated in API level 14. use TYPE_AMBIENT_TEMPERATURE instead.
      		 //x - values[0]: Atmospheric pressure in hPa (millibar)
   		     values= new float[1];
     	     values[0] = event.values[0];
      		 controls.pOnChangedSensor(pascalObj, event.sensor, 7,values,event.timestamp);
          break;
          
          case 8: //Sensor.TYPE_PROXIMITY: //8        	   
        		//values[0]: Proximity sensor distance measured in centimeters
        	    //x Distance from object - cm  
        	    //Some proximity sensors provide only binary values representing near/0 and "other" far:  getMaximumRange() ]
   		        values= new float[1];
     	        values[0] = event.values[0];  //0 = near
        	    controls.pOnChangedSensor(pascalObj, event.sensor, 8,values,event.timestamp);
          break;
        	
          case 9: //Sensor.TYPE_GRAVITY://9        		
        		 /*   
        		 * A three dimensional vector indicating the direction and magnitude of gravity. Units are m/s^2. 
        		 * The coordinate system is the same as is used by the acceleration sensor.
                   Note: When the device is at rest, the output of the gravity sensor should be identical to that of the accelerometer.
        		 */        		
        	    values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 9,values,event.timestamp);
           break;

        	//ref http://developer.android.com/guide/topics/sensors/sensors_motion.html#sensors-motion-gyro
        	// you could use this sensor to see how fast your car is going
           case 10: //Sensor.TYPE_LINEAR_ACCELERATION: //10
        	   values = event.values;
        		//Conceptually, this sensor provides you with acceleration data according to the following relationship:
                //linear acceleration = acceleration - acceleration due to gravity
        		//The sensor coordinate system is the same as the one used by the acceleration sensor, as are the units of measure (m/s2).
        		controls.pOnChangedSensor(pascalObj, event.sensor, 10,values,event.timestamp);
        	break;
        	
            case 11: //Sensor.TYPE_ROTATION_VECTOR: //11
              values = event.values;
       		  controls.pOnChangedSensor(pascalObj, event.sensor, 11,values,event.timestamp);
       	    break;
         	
            case 12: //Sensor.TYPE_RELATIVE_HUMIDITY: //12
        		//values[0]: Relative ambient air humidity in percent
        		//When relative ambient air humidity and ambient temperature are measured 
        		//the dew point and absolute humidity can be calculated.        		
        		//Absolute Humidity
        		//The absolute humidity is the mass of water vapor in a particular volume of dry air. The unit is g/m3.        	
        		//x
       		    values = new float[1];
         	    values[0] = event.values[0];
        		controls.pOnChangedSensor(pascalObj, event.sensor, 12,values,event.timestamp);
        	break;

            case 13: //Sensor.TYPE_AMBIENT_TEMPERATURE: //13
        		//values[0]: ambient (room) temperature in degree Celsius.        		
        		//x
       		    values = new float[1];
         	    values[0] = event.values[0];
        		controls.pOnChangedSensor(pascalObj, event.sensor, 13,values,event.timestamp);        		 
            break;
            
            case 14: //Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED: //14
            	values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 14,values,event.timestamp);        		
            break;            
        	
            case 15: //Sensor.TYPE_GAME_ROTATION_VECTOR: //15
        		//x - Rotation vector component along the x axis (x * sin(Ang/2)).
        		//y - Rotation vector component along the y axis (y * sin(Ang/2)).
        		//z - Rotation vector component along the z axis (z * sin(Ang/2)).
            	values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 15,values,event.timestamp);
        	break;
        	
            case 16://Sensor.TYPE_GYROSCOPE_UNCALIBRATED: //16
            	values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 16,values,event.timestamp);        		
            break;        	
        	
            case 17: //Sensor.TYPE_SIGNIFICANT_MOTION: //17
            	values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 17,values,event.timestamp);        		
            break;
            
            case 18: //Sensor.TYPE_STEP_DETECTOR: //18
            	values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 18,values,event.timestamp);        		
            break;            
            
          
            case 19: //Sensor.TYPE_STEP_COUNTER://19  //is reset to zero only on a system reboot! -  
            	values = new float[1];
         	    values[0] = event.values[0];
         		//SensorEvent.values[0]
        		//Number of steps taken by the user since the last reboot while the sensor was activated.
        		         		
        	 	controls.pOnChangedSensor(pascalObj, event.sensor, 19,values,event.timestamp);
        	break;
        	            
            case 20: //Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR: //20
        		//x - Rotation vector component along the x axis (x * sin(Ang/2)).
        		//y - Rotation vector component along the y axis (y * sin(Ang/2)).
        		//z - Rotation vector component along the z axis (z * sin(Ang/2)).
       	        values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 20,values,event.timestamp);
        	break;        	        	        
        	
        	// Api >= 19;
            case 21: //Sensor.TYPE_HEART_RATE: //21
                values = event.values;         		
        		controls.pOnChangedSensor(pascalObj, event.sensor, 21,values,event.timestamp);
        	break;        	        	                	        	
        	
           // Api >= 19;
            case 22: //Sensor.TYPE_AUTO_ROTATION: //22        		
                values = event.values; 
        		controls.pOnChangedSensor(pascalObj, event.sensor, 22,values,event.timestamp);
        	break;
               	        	        	
      	  } //switch		
        }        
     };                
   }       
       
   public void jFree() {
      //free local objects...
      mSensorManager.unregisterListener(mSensorEventListener);
      mListSensors.clear();
      mListSensors = null;
	  mSensorEventListener = null;
	  mSensorManager = null;
	  mCurrSensor  = null;
   }
  
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
	 
   public int[] GetDeviceSensorsTypes() {	   
	 int[] intArray = new int[mListSensors.size()];	   	 	          
     for(int i=0; i < mListSensors.size(); i++){        
        intArray[i] = mListSensors.get(i).getType();
     }     
     return intArray;     
   }
      
   public String[] GetDeviceSensorsNames() {	   	 	   
	 String[] strArray = new String[mListSensors.size()];       
     for(int i=0; i < mListSensors.size(); i++){ 
    	strArray[i] = mListSensors.get(i).getName();        
     }     
     return strArray;  
   }
   
   public void RegisterListeningSensor(int _sensorType) {	   
       //Tell which sensor you are going to use
       //And declare delay of sensor    	     	  
	   if (SensorExists(_sensorType)) {		              
		   mCurrSensor = mSensorManager.getDefaultSensor(_sensorType);                      
           mSensorManager.registerListener(mSensorEventListener, mCurrSensor, SensorManager.SENSOR_DELAY_NORMAL);           
           controls.pOnListeningSensor(pascalObj, mCurrSensor, mCurrSensor.getType());           
	   }        
   }
      
   public void RegisterListeningSensor(int _sensorType, int _delayType) {	   
       //Tell which sensor you are going to use
       //And declare delay of sensor           	     	  
	   if (SensorExists(_sensorType)) { 
           mCurrSensor = mSensorManager.getDefaultSensor(_sensorType);
           mSensorManager.registerListener(mSensorEventListener, mCurrSensor, _delayType);
           controls.pOnListeningSensor(pascalObj, mCurrSensor , mCurrSensor.getType()); //fail....
	   } 
       
   }
   
   public void StopListeningAll() {
	   mSensorManager.unregisterListener(mSensorEventListener);
   }   
      
   public boolean SensorExists(int _sensorType) {
	   List<Sensor> listType =	mSensorManager.getSensorList(_sensorType);
	   if (listType.size() > 0) return true;
	   else return false;	      
   }
   
   public String[] GetSensorsNames(int _sensorType) {	 
       List<Sensor> listType =	mSensorManager.getSensorList(_sensorType);      
  	   String[] strArray = new String[listType.size()];       
       for(int i=0; i < listType.size(); i++){ 
    	 strArray[i] = listType.get(i).toString();        
       }       
       return strArray;   
      //Use this method to get the list of available sensors of a certain type.
   }
   
   public Sensor GetSensor(int _sensorType) {  //android.hardware.Sensor
	   return mSensorManager.getDefaultSensor(_sensorType);
   }
   
   public float GetSensorMaximumRange(Sensor _sensor) { //maximum range of the sensor in the sensor's unit.
        return 	_sensor.getMaximumRange();
   }
   
   public String GetSensorVendor (Sensor _sensor) {
	   return _sensor.getVendor();	   
   }
   
   public int GetSensorMinDelay(Sensor _sensor) {
	   return _sensor.getMinDelay(); 	   	   
   }
   
   public String GetSensorName(Sensor _sensor) {	    
	   return _sensor.getName();	   
   }
   
   public int GetSensorType(Sensor _sensor) {	    
	   return _sensor.getType();	   
   }
      
   public void UnregisterListenerSensor(Sensor _sensor) {
	   mSensorManager.unregisterListener (mSensorEventListener, _sensor);	   
	   controls.pOnUnregisterListeningSensor(pascalObj, _sensor.getType(), _sensor.getName());
   }   
   
   public float GetGravityEarth(){
	 return SensorManager.GRAVITY_EARTH;  	 
   }

   public float GetAltitude(float _localPressure) {
       return mSensorManager.getAltitude(SensorManager.PRESSURE_STANDARD_ATMOSPHERE, _localPressure);
   }
   
   public float GetAltitude(float _pressureAtSeaLevel, float _localPressure) {
	   return mSensorManager.getAltitude(_pressureAtSeaLevel, _localPressure);
   }
      
   public Sensor GetSensor(String _sensorName) {	   
     Sensor sensor = null;      
     for(int i=0; i < mListSensors.size(); i++){    	
     	if ((mListSensors.get(i).getName()).equals(_sensorName)){
    	   sensor= mListSensors.get(i); 	
    	}    		
     }            
     return sensor;
   }
    
   public float GetSensorPower(Sensor _sensor) {
      return _sensor.getPower();
   }
   
   public float GetSensorResolution(Sensor _sensor) {
     return _sensor.getResolution();
   }
   
   public void RegisterListeningSensor(Sensor _sensor) {	   
       //Tell which sensor you are going to use
       //And declare delay of sensor    	     	  
	   mSensorManager.registerListener(mSensorEventListener,_sensor, SensorManager.SENSOR_DELAY_NORMAL);
	   controls.pOnListeningSensor(pascalObj, _sensor, _sensor.getType());
   }
   
   public void RegisterListeningSensor(Sensor _sensor, int _delayType) {	   
       //Tell which sensor you are going to use
       //And declare delay of sensor    	     	  
	   mSensorManager.registerListener(mSensorEventListener,_sensor, _delayType);     
	   controls.pOnListeningSensor(pascalObj, _sensor, _sensor.getType());
   }

}


/*Draft java code by "Lazarus Android Module Wizard" [1/18/2015 1:40:32]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jBroadcastReceiver extends BroadcastReceiver {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   
   private int mResultCode;
   private String mResultData;
   private Bundle mResultExtras; 
 
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jBroadcastReceiver(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
   }
 
   public void jFree() {
     //free local objects...
   }

   @Override
   /*.*/public void onReceive(Context arg0, Intent intent) { 
	   mResultCode = -1;
	   switch (this.getResultCode()) {
	        case Activity.RESULT_OK: mResultCode = 1; break;
	        case Activity.RESULT_CANCELED: mResultCode = 0; break;  
	   }	     	     	     
	   mResultData = this.getResultData();	    	      	    
	   mResultExtras = this.getResultExtras(true);	   
	   controls.pOnBroadcastReceiver(pascalObj,  intent);
   }
   
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   
   public void RegisterIntentActionFilter(String _intentAction) { //android.provider.Telephony.SMS_RECEIVED
	   //intentFilter.addDataScheme("http"); 
	   //intentFilter.addDataScheme("ftp"); 
	   //intentFilter.addAction(BluetoothDevice.ACTION_FOUND);	    	         	   
	   controls.activity.registerReceiver(this, new IntentFilter(_intentAction));
	   //Log.i("receiver","Register ....");
   }
         	   	  	         
   /*
    * This method disables the Broadcast receiver
    */
   public void Unregister() {   
	   controls.activity.unregisterReceiver(this);
	   //Log.i("receiver","UnRegister ...");
   }
   
   public void RegisterIntentActionFilter(int _intentAction) {
	   switch(_intentAction) {
	     case 0: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_TIME_TICK));
	     case 1: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_TIME_CHANGED));
	     case 2: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_TIMEZONE_CHANGED));
	     case 3: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_BOOT_COMPLETED));
	     case 4: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
	     case 5: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_POWER_CONNECTED));
	     case 6: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_POWER_DISCONNECTED));
	     case 7: controls.activity.registerReceiver(this, new IntentFilter(Intent.ACTION_SHUTDOWN));
	     case 8: controls.activity.registerReceiver(this, new IntentFilter("android.provider.Telephony.SMS_RECEIVED"));
	   }
   }
   
   public int GetResultCode() {     
      return mResultCode;
   }
   
   public String GetResultData() {
      return mResultData;
   }
   
   public Bundle GetResultExtras() { //true
      return mResultExtras;
   }   
}

/*Draft java code by "Lazarus Android Module Wizard" [1/18/2015 19:10:57]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jBundlerManager/*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
 
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jBundlerManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
   public Bundle CreateNew() {
	   return new Bundle();
   }
   
   public Bundle GetExtras(Intent _intent) {
      return  _intent.getExtras();
   }
   
}

/*Draft java code by "Lazarus Android Module Wizard" [1/18/2015 3:49:46]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jIntentManager  {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   
   private Intent mIntent;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jIntentManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;      
      mIntent = new Intent();
   }
 
   public void jFree() {
     //free local objects...
	  mIntent = null;
   }
 
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
         
   public Intent GetIntent() {	 
	 return mIntent;
   }
   
   public Intent GetActivityStartedIntent() {
     return controls.activity.getIntent();   //Return the intent that started this activity. 
   }
   
/*http://courses.coreservlets.com/Course-Materials/pdf/android/Android-Intents-2.pdf
   Java (original Activity)
   String address ="loan://coreservlets.com/calc?loanAmount=xxx";
   Uri uri = Uri.parse(address);
   Intent intent = new Intent(Intent.ACTION_VIEW, uri);
   startActivity(activityIntent);
  Java (new Activity - can be different project)
  Uri uri = getIntent().getData();
  String loanAmountString = uri.getQueryParameter("loanAmount");
  //Convert String to double, handle bad data   
 */
     
/*
 * Intents Starting a new Activity Dial a number 
 *    Intent intent = new Intent (Intent.ACTION_DIAL, Uri.parse("tel:93675359")); 
 *    startActivity(intent);       
 * Launch a website 
 * Intent intent = new Intent (Intent.ACTION_VIEW, Uri.parse("http://codeandroid.org")); 
 *   startActivity(intent);   
 */
      
   public void SetAction(String _intentAction) {	                                              
	  mIntent.setAction(_intentAction); //
   }
      
   //This method automatically clears any data that was previously set (for example by setData(Uri)). 
   public void SetMimeType(String _mimeType) {
	  mIntent.setType(_mimeType);  //"image/*";
   }

/*http://courses.coreservlets.com/Course-Materials/pdf/android/Android-Intents-2.pdf
Sending Data: Extras vs. URI Parameters
>>Extras Bundle
.Pros
    Can send data of different types.
    No parsing required in Activity that receives the data.
.Cons
   More complex for originating Activity
   Requires parsing in originating Activity if values come from EditText

>>URI parameters
.Pros
   Simpler for originating Activity, especially if EditText used
   More consistent with URI usage
.Cons
   Can send Strings only
   Requires parsing in receiving Activity
*/  
  
   /*
   If the action is performed on some data, then one more Intent-attribute is specified - data. 
   Inside it we can specify any object we need: user in the address book, map coordinates, phone number etc. 
   That is action specifies what to do and data - with what to do it.
   */
     
   /*
    * Set the data this intent is operating on. 
    * This method automatically clears any type that was previously set by setType(String) 
    * or setTypeAndNormalize(String). Note: scheme matching in the Android framework is case-sensitive, 
    * unlike the formal RFC. As a result, you should always write your Uri with a lower case scheme, 
    * or use normalizeScheme() or setDataAndNormalize(Uri) to ensure that the scheme is converted to lower case.
    */
   
   public void SetDataUriAsString(String _uriAsString) { //Uri.parse(fileUrl) - just Strings!
	   
	   mIntent.setData(Uri.parse(_uriAsString));  //just Strings!
	   /*
	    * Parameters
             data  The Uri of the data this intent is now targeting. 
          Returns
             Returns the same Intent object, for chaining multiple calls into a single statement.
	    */
   }
   
   public void StartActivityForResult(int _requestCode) {
	   controls.activity.startActivityForResult(mIntent,_requestCode);
	   // //startActivityForResult(photoPickerIntent, SELECT_PHOTO);
   }
      
   /*
    * String url = "http://www.vogella.com";
      Intent i = new Intent(Intent.ACTION_VIEW);
      i.setData(Uri.parse(url));
      startActivity(i); 
   */
      
   public void StartActivity() {
	   //intent.putExtras .... etc
	  controls.activity.startActivity(mIntent);
   }
   
   public void StartActivity(String _chooserTitle) {	  
	   controls.activity.startActivity(Intent.createChooser(mIntent, _chooserTitle));
   }
   
   public void StartActivityForResult(int _requestCode, String _chooserTitle) {	  
	   controls.activity.startActivityForResult(Intent.createChooser(mIntent, _chooserTitle),_requestCode);
   }
         
   /*
    * The _dataName must include a package prefix, 
    * for example the app com.android.contacts 
    * would use names like "com.android.contacts.ShowAll".
    */
   
   /*
    * Intents Broadcast Intents 
    * Intent intent = new Intent("org.codeandroid.intentstest.TestBroadcastReceiver"); 
    * sendBroadcast(intent);
    */
   
   public void SendBroadcast(){    //This call is asynchronous; it returns immediately    	               
      controls.activity.sendBroadcast(mIntent); //The Intent to broadcast; all receivers matching this Intent will receive the broadcast.       
   }
   
   public String GetAction(Intent _intent) {	 
      return _intent.getAction();
   }
      
   public boolean HasExtra(Intent _intent, String _dataName) {
	  return _intent.hasExtra(_dataName);
   }
   
   public void PutExtraBundle(Bundle _bundleExtra) {
	  mIntent.putExtras(_bundleExtra);
   }
   
   public Bundle GetExtraBundle(Intent _intent) {  //the map of all extras previously added with putExtra(), or null if none have been added. 
	   return _intent.getExtras();
   }
     
   public double[] GetExtraDoubleArray(Intent _intent, String _dataName) {
       return _intent.getDoubleArrayExtra(_dataName);
   }
      
   /*
    * The _dataName must include a package prefix, 
    * for example the app com.android.contacts 
    * would use names like "com.android.contacts.ShowAll".
    */
   
   public void PutExtraDoubleArray(String _dataName, double[] _values) {
	  mIntent.putExtra(_dataName, _values);
   }
   
   public double GetExtraDouble(Intent _intent, String _dataName) {
	  return _intent.getDoubleExtra(_dataName, 0);//defaultValue
   }
   
   public void PutExtraDouble(String _dataName, double _value) {
	   mIntent.putExtra(_dataName, _value);
   }
   
   public float[] GetExtraFloatArray(Intent _intent, String _dataName) {
	   return _intent.getFloatArrayExtra(_dataName);
   }
   
   public void PutExtraFloatArray(String _dataName, float[] _values) {
	   mIntent.putExtra(_dataName, _values);
   }
   
   public float GetExtraFloat(Intent _intent, String _dataName) { 
	   return _intent.getFloatExtra(_dataName, 0);
   }
   
   public void PutExtraFloat(String _dataName, float _value) {
	   mIntent.putExtra(_dataName, _value);
   }
   
   public int[] GetExtraIntArray(Intent _intent, String _dataName) {
	   return _intent.getIntArrayExtra(_dataName);
   }
   
   public void PutExtraIntArray(String _dataName, int[] _values) {
	  mIntent.putExtra(_dataName, _values);
   }
   
   public int GetExtraInt(Intent _intent, String _dataName) {
	  return _intent.getIntExtra(_dataName, 0);
   }
  
   public void PutExtraInt(String _dataName, int _value) {
	  mIntent.putExtra(_dataName, _value);
   }
   
   public String[] GetExtraStringArray(Intent _intent, String _dataName) {	  
	  return _intent.getStringArrayExtra(_dataName);
   }
         
   public void PutExtraStringArray(String _dataName, String[] _values) {
	  mIntent.putExtra(_dataName, _values);
   }
   
   public String GetExtraString(Intent _intent, String _dataName) {
	  return _intent.getStringExtra(_dataName);
   }
   
   public void PutExtraString(String _dataName, String _value) {
	  mIntent.putExtra(_dataName, _value);
   }
            
   public void SetDataUri(Uri _dataUri) { //Uri.parse(fileUrl) - just Strings!
		  //final Uri uriContact = ContactsContract.Contacts.CONTENT_URI;
		  //android.provider.ContactsContract.Contacts.CONTENT_URI
		   mIntent.setData(_dataUri);  //just Strings!
   }
	   
   public Uri GetDataUri(Intent _intent) {
	  return _intent.getData(); //name of data ...
   }
 
   public String GetDataUriAsString(Intent _intent) { //The same as getData(), but returns the URI as an encoded String.	   
 	  return _intent.getDataString();               //inverse: Uri.parse(...) creates a Uri which parses the given encoded URI string.
   }

   /*OnResult ...
    * Uri contactUri = intent.getData();
      You can also fetch the selected Contact name from intent extras.
      String contactName = intent.getStringExtra("android.intent.extra.shortcut.NAME");
   */ 
          
   /*
    * For example: you have a share picture option in your application.
      You define an intent like this:
      Intent picMessageIntent = new Intent(android.content.Intent.ACTION_SEND);
      picMessageIntent.setType("image/jpeg");

    File downloadedPic =  new File(
    Environment.getExternalStoragePublicDirectory(
    Environment.DIRECTORY_DOWNLOADS),
    "q.jpeg");
    picMessageIntent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(downloadedPic));
    Than when you call:
    startActivity(picMessageIntent);  
    all applications on your phone capable of getting this picture will be listed.    
    */
      
   public void PutExtraFile(String _environmentDirectoryPath, String _fileName) { //Environment.DIRECTORY_DOWNLOADS
      mIntent.putExtra(Intent.EXTRA_STREAM, Uri.parse("file://"+_environmentDirectoryPath+"/"+ _fileName)); //android.intent.extra.STREAM
   }
      
   public void PutExtraMailSubject(String  _mailSubject) {
	   mIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, _mailSubject);
   }
   
   public void PutExtraMailBody(String _mailBody) {	  
	   mIntent.putExtra(android.content.Intent.EXTRA_TEXT, _mailBody);
   }
      
   public void PutExtraMailCCs(String[] _mailCCs) {	  
	   mIntent.putExtra(android.content.Intent.EXTRA_CC, _mailCCs);
   }
       
   public void PutExtraMailBCCs(String[] _mailBCCs) {	  
	   mIntent.putExtra(android.content.Intent.EXTRA_BCC, _mailBCCs);
   }
   
   public void PutExtraMailTos(String[]  _mailTos) {	  
	   mIntent.putExtra(android.content.Intent.EXTRA_EMAIL, _mailTos);
   }
   
   public void PutExtraPhoneNumbers(String[]  _callPhoneNumbers) {	  
	   mIntent.putExtra(android.content.Intent.EXTRA_PHONE_NUMBER, _callPhoneNumbers); //used with Action_Call	   	   
   }
   
   
   public Uri GetContactsContentUri(){
	  return ContactsContract.Contacts.CONTENT_URI;
	  /*
	   * * This will display a list of all the contacts in the device to pick from.
      In onActivityResult, you can fetch the selected Contact URI from the intent.
	   */
   }

   /*
	final Uri uriContact = ContactsContract.Contacts.CONTENT_URI;
	Intent intentPickContact = new Intent(Intent.ACTION_PICK, uriContact);
   */
   
   public Uri GetContactsPhoneUri(){
      return ContactsContract.CommonDataKinds.Phone.CONTENT_URI;
      //If you need to pick from only contacts with a phone number,
   }
   
   public Uri GetAudioExternContentUri(){
      return android.provider.MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
   }
   
   public Uri GetVideoExternContentUri(){
	  return android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
   }
   
   public Uri ParseUri(String _uriAsString) {	   	   
	  return Uri.parse(_uriAsString);
   }
   
   /*
    * The caller may pass an extra EXTRA_OUTPUT to control where this image will be written. 
    * If the EXTRA_OUTPUT is not present, then a small sized image is returned as a 
    * Bitmap object in the extra field. This is useful for applications that only need a small image. 
    */
   public String GetActionViewAsString(){  
     return "android.intent.action.VIEW";
   }	   
      
   public String GetActionPickAsString() {
	   return "android.intent.action.PICK";
   }  	   
   
   public String GetActionSendtoAsString() {
      return "android.intent.action.SENDTO";
   }	   
   
   public String GetActionSendAsString() {
	   return "android.intent.action.SEND";
   }
   
   public String GetActionEditAsString() {
      return "android.intent.action.EDIT";
   }
   
   public String GetActionDialAsString() {
      return "android.intent.action.DIAL";
   }	   
   
   public String GetActionCallButtonAsString() {
	  //String s =  Intent.ACTION_CALL_BUTTON; 
      return "android.intent.action.CALL_BUTTON";
   }	   
   
      
   public void SetAction(int  _intentAction) {	 
	  switch(_intentAction) { 
	    case 0: mIntent.setAction("android.intent.action.VIEW"); //
	    case 1: mIntent.setAction("android.intent.action.PICK"); //
	    case 2: mIntent.setAction("android.intent.action.SENDTO"); //
	    case 3: mIntent.setAction("android.intent.action.DIAL"); //
	    case 4: mIntent.setAction("android.intent.action.CALL_BUTTON"); //
	    case 5: mIntent.setAction( "android.intent.action.CALL");
	    case 6: mIntent.setAction("android.media.action.IMAGE_CAPTURE"); //
	  }
   }
   
   public boolean ResolveActivity() {
      if (mIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
    	  return true;
      } else return false;
   }
   
   public Uri GetMailtoUri(){		  	      
      return Uri.parse("mailto:");
   }
	   
   public Uri GetMailtoUri(String _email){		  	      
	  return Uri.parse("mailto:"+_email);
   }
   
   
   public Uri GetTelUri(){		  	      
	  return Uri.parse("tel:");
   }
		   
   public Uri GetTelUri(String _telNumber){		  	      
	  return Uri.parse("tel:"+_telNumber);
   }
   
   /* Pick image from Gallery
    Intent intent = new Intent();  
    intent.setAction(Intent.ACTION_GET_CONTENT);
    intent.setType("image/*");
    intent.putExtra("return-data", true);
    
 
    ACTION_GET_CONTENT with MIME type vnd.android.cursor.item/phone 
    Display the list of people's phone numbers,
    allowing the user to browse through them and pick one and return it to the parent activity.
    
    */
   
   public String GetActionGetContentUri(){	      //generic pick!    
	  return "android.intent.action.GET_CONTENT";
   }
   
   public void PutExtraFile(Uri _uri) { 
	   mIntent.putExtra(Intent.EXTRA_STREAM, _uri); //android.intent.extra.STREAM
   }
   
   
   /* String s =Intent.ACTION_CALL;
    * Activity Action: Perform a call to someone specified by the data. 
      Input: If nothing, an empty dialer is started; 
             else getData() is URI of a phone number to be dialed  or a tel: URI of an explicit phone number. 
             Note: there will be restrictions on which applications can initiate a call; 
             most applications should use the ACTION_DIAL. 
    */
   
   public String GetActionCallAsString() {
	   //String s = Intent.ACTION_CALL;
	   return "android.intent.action.CALL";
   }
   
   public String GetContactNumber(Uri _contactUri) { 
      String[] projection = {Phone.NUMBER};
      Cursor cursor = controls.activity.getContentResolver().query(_contactUri, projection, null, null, null);
      cursor.moveToFirst();
      // Retrieve the phone number from the NUMBER column
       int column = cursor.getColumnIndex(Phone.NUMBER);
       String number = cursor.getString(column);
       cursor.close();
       return number;
   }
   
   
   public String GetContactEmail(Uri _contactUri) { 
	      String[] projection = {Email.DATA};
	      Cursor cursor = controls.activity.getContentResolver().query(_contactUri, projection, null, null, null);
	      cursor.moveToFirst();
	      // Retrieve the phone number from the DATA column
	       int column = cursor.getColumnIndex(Email.DATA);
	       String email = cursor.getString(column);
	       cursor.close();
	       return email;
   }
      
   //ref. http://code.tutsplus.com/tutorials/android-essentials-using-the-contact-picker--mobile-2017
   public String[] GetBundleContent(Intent _intent) {
	 		
     Bundle extras = _intent.getExtras();
     
     if (extras != null) {
    	 int i;
    	 Set keys = extras.keySet();
         String[] strKeys = new String[keys.size()];
         Iterator iterate = keys.iterator();
         i = 0;
         while (iterate.hasNext()) {
           String key = (String) iterate.next();
           strKeys[i] = key + "[" + extras.get(key) + "]";
           i++;		   
         }    
         return strKeys;
         
     } else return null;   
     
   }
   
   public String GetActionImageCaptureAsString() {
	     return "android.media.action.IMAGE_CAPTURE";
   }
      
   //http://www.coderanch.com/t/492490/Android/Mobile/Check-application-installed
   public boolean IsCallable(Intent _intent) {  
       List<ResolveInfo> list = controls.activity.getPackageManager().queryIntentActivities(_intent, PackageManager.MATCH_DEFAULT_ONLY);  
       if(list.size() > 0)
          return true ;  
       else
          return false;
    }
     
   public boolean IsActionEqual(Intent _intent, String _intentAction) { //'android.provider.Telephony.SMS_RECEIVED'
	   return _intent.getAction().equals(_intentAction);
   }
   
   //TODO Pascal
   public void PutExtraMediaStoreOutput(String _environmentDirectoryPath, String _fileName) {
	   mIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.parse("file://"+_environmentDirectoryPath+"/"+ _fileName));
   }
   
 //TODO Pascal
   public String GetActionCameraCropAsString() {
	  return "com.android.camera.action.CROP"; //http://shaikhhamadali.blogspot.com.br/2013/09/capture-images-and-crop-images-using.html
   }
          
}

/*Draft java code by "Lazarus Android Module Wizard" [2/3/2015 16:12:53]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/
 
class jNotificationManager /*extends ...*/ {
  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;

    NotificationManager mNotificationManager;
    String one,two,three;
  
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
    
    public void Notify(int _id, String _title, String _subject, String _body, String _iconIdentifier){
    	
    	int icon;
    	
    	if (_iconIdentifier.equals("")) 
    	   icon = android.R.drawable.ic_dialog_info;    	
    	else
    	   icon = GetDrawableResourceId(_iconIdentifier) ;
    	
    	mNotificationManager=(NotificationManager)controls.activity.getSystemService(Context.NOTIFICATION_SERVICE);    	
       Notification notif = new Notification.Builder(controls.activity)         
       .setContentTitle(_title)        
       .setContentText(_subject)
       .setContentInfo(_body)
       .setSmallIcon(icon)         
       .build();       
       mNotificationManager.notify(_id, notif);
    }
    
    //This method cancel a previously shown notification.
    public void Cancel(int _id) {
      mNotificationManager.cancel(_id);    
    }
    
    public void CancelAll() {
      mNotificationManager.cancelAll();    
    }    
}



/*Draft java code by "Lazarus Android Module Wizard" [2/3/2015 22:24:25]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jTimePickerDialog /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
 
   // Variable for storing current time
   private int mHour, mMinute;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jTimePickerDialog(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
 
   public void Show() {
	   
       // Process to get Current Time
       final Calendar c = Calendar.getInstance();
       mHour = c.get(Calendar.HOUR_OF_DAY);
       mMinute = c.get(Calendar.MINUTE);

       // Launch Time Picker Dialog
       TimePickerDialog tpd = new TimePickerDialog(controls.activity,new TimePickerDialog.OnTimeSetListener() {
                   @Override
                   /*.*/public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                       // Display Selected time in textbox
                       //Log.i("TimePicker", hourOfDay + ":" + minute);
                       controls.pOnTimePicker(pascalObj, hourOfDay, minute);
                   }
               }, mHour, mMinute, false);
       
       tpd.show();      
   }
   
}

/*Draft java code by "Lazarus Android Module Wizard" [2/3/2015 22:24:25]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

class jDatePickerDialog /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
 
   // Variable for storing current date and time
   private int mYear, mMonth, mDay;
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jDatePickerDialog(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
   public void Show() {
	   
       // Process to get Current Date
       final Calendar c = Calendar.getInstance();
       mYear = c.get(Calendar.YEAR);
       mMonth = c.get(Calendar.MONTH);
       mDay = c.get(Calendar.DAY_OF_MONTH);

       // Launch Date Picker Dialog
       DatePickerDialog dpd = new DatePickerDialog(controls.activity, new DatePickerDialog.OnDateSetListener() {
                   @Override
                   /*.*/public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                       // Display Selected date in textbox
                       //Log.i("DatePicker",dayOfMonth + "-" + (monthOfYear + 1) + "-" + year);
                       controls.pOnDatePicker(pascalObj, year, monthOfYear+1, dayOfMonth);
                   }
               }, mYear, mMonth, mDay);
       dpd.show();
   }    
}


/*Draft java code by "Lazarus Android Module Wizard" [2/16/2015 20:17:59]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//ref. http://www.javacodegeeks.com/2013/06/android-http-client-get-post-download-upload-multipart-request.html
//ref http://lethargicpanda.tumblr.com/post/14784695735/oauth-login-on-your-android-app-the-github
class jHttpClient /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   
   private String mUSERNAME = "USERNAME";
   private String mPASSWORD = "PASSWORD";
   private int mAuthenticationMode = 0; //0: none. 1: basic; 2= OAuth
   private String mHOSTNAME = AuthScope.ANY_HOST; // null; 
   private int mPORT = AuthScope.ANY_PORT; //-1;
   
   private List<NameValuePair> ValuesForPost2 = new ArrayList<NameValuePair>();
   DefaultHttpClient client2;
   String httpCharSet = "UTF-8";	// default UTF-8
   
	//List<Cookie> cookies;		 		 
    CookieStore cookieStore; 	     
    HttpContext localContext;    
        
    ArrayList<String> listHeaderName = new ArrayList<String>();
    ArrayList<String> listHeaderValue = new ArrayList<String>();
    
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jHttpClient(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      
      client2 = new DefaultHttpClient();
      
      cookieStore= new BasicCookieStore();      
      localContext= new BasicHttpContext();      
      localContext.setAttribute(ClientContext.COOKIE_STORE,cookieStore);
      
      //client2.setCookieStore(cookieStore);            
   }
 
   public void jFree() {
     //free local objects...
	   client2.getConnectionManager().shutdown();
   }
 
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   
   //ref. http://blog.leocad.io/basic-http-authentication-on-android/
   //ref. http://simpleprogrammer.com/2011/05/25/oauth-and-rest-in-android-part-1/
   //ref. http://jan.horneck.info/blog/androidhttpclientwithbasicauthentication
   
      
   public void GetAsync(String _stringUrl) {
	   new AsyncHttpClientGet().execute(_stringUrl);	   
   }
   
   public void SetCharSet(String _charSet) {	   
	   httpCharSet = _charSet;
	   //Log.i("CharSet", _charSet);
   }  
                      
   public String Get2(String _stringUrl) throws Exception {  //Pascal: Get  
	   	   	   	   
	   HttpGet httpGet = new HttpGet(_stringUrl);	   
	   HttpResponse response = client2.execute(httpGet);
	      	  	   
	   BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), httpCharSet));
	   StringBuffer sb = new StringBuffer();
	   
	   String line = "";
	   while ((line = rd.readLine()) != null) {
		  sb.append(line);		   
	   }
	   
	   return sb.toString();	   
   } 
   
      
   public void AddValueForPost2(String Name, String Value) {  //Pascal: AddPostNameValueData		
       ValuesForPost2.add(new BasicNameValuePair(Name, Value));	
   }

   public void ClearPost2Values() { // Pascal: ClearPostNameValueData
      ValuesForPost2.clear();	
   }   

   public String Post2(String Link) throws Exception {	// Pascal: Post			
		
		// Create a new HttpClient and Post Header
		int statusCode = 0;						
		HttpParams httpParams = new BasicHttpParams();
		int connection_Timeout = 5000;
		HttpConnectionParams.setConnectionTimeout(httpParams, connection_Timeout);
		HttpConnectionParams.setSoTimeout(httpParams, connection_Timeout);
		
        if (mAuthenticationMode != 0) {    		   
        	client2.getCredentialsProvider().setCredentials(
                        new AuthScope(mHOSTNAME,mPORT),  // 
                        new UsernamePasswordCredentials(mUSERNAME, mPASSWORD));
	    }
        			   
	    HttpPost httpPost = new HttpPost(Link);
	    
	  //thanks to @renabor
	    if (mAuthenticationMode != 0) {
            String _credentials = mUSERNAME + ":" + mPASSWORD;
            String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
            httpPost.addHeader("Authorization", "Basic " + _base64EncodedCredentials);
        }	   
	        
	    httpPost.setEntity(new UrlEncodedFormEntity(ValuesForPost2));
	    	
		HttpResponse response = client2.execute(httpPost);
			
		BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), httpCharSet));
		StringBuffer sb = new StringBuffer();
		String line;		
		while ((line = rd.readLine()) != null) {
			sb.append(line);
		}		
		return sb.toString();	   
  }
   
   public void SetAuthenticationUser(String _userName, String _password) {       	 
	   mUSERNAME = _userName;
	   mPASSWORD =_password;
   }
     
   public void SetAuthenticationHost(String _hostName, int _port) {
    	 if ( _hostName.equals("") ) {
    		 mHOSTNAME = null;
    	 } 
    	 else {
    		 mHOSTNAME = _hostName;
    	 }
    	 mPORT = _port;	 
   }
               
   public void SetAuthenticationMode(int _authenticationMode) {    	 
        mAuthenticationMode = _authenticationMode; //0: none. 1: basic; 2= OAuth	 	                
   }
     
	/*
	 * AsyncTask has three generic types:
      Params: An array of parameters you want to pass in to the class you create when you subclass AsyncTask.
      Progress: If you override onProgressUpdate, this is the type that method returns.
      Result: This is the type that doInBackground returns.
	 */
   
     //ref. http://mobiledevtuts.com/android/android-http-with-asynctask-example/
   
   public void PostNameValueDataAsync(String _stringUrl, String _name, String _value) {
	  new AsyncHttpClientPostNameValueData().execute(_stringUrl, _name, _value);	  
   }
  
	
	public void PostNameValueDataAsync(String _stringUrl, String _listNameValue) {
	   new AsyncHttpClientPostListNameValueData().execute(_stringUrl, _listNameValue);     
    }
	
	public void PostNameValueDataAsync(String _stringUrl) {
		new AsyncHttpClientPostNameValueData().execute(_stringUrl, "", "");
	}
	
	//-----------------------
	//Cookies
	//-----------------------
	    
	public String[] GetCookies(String _nameValueSeparator) {		
		ArrayList<String> list = new ArrayList<String>();
	    List<Cookie> cookies = cookieStore.getCookies();	     
        
	    if (!cookies.isEmpty()) {
		      for (Cookie cookie : cookies){
		    	  list.add(cookie.getName() + _nameValueSeparator + cookie.getValue());	         
		      }		  
	    }
	    return list.toArray(new String[list.size()]);
	}
	
	
	public String[] GetCookies(String _url, String _nameValueSeparator) {  //Cookies		   
	    ArrayList<String> list = new ArrayList<String>();   
	    HttpGet httpget=new HttpGet(_url);  	    
		try {				
			  HttpResponse response = client2.execute(httpget, localContext);	 
			  List<Cookie> cookies = cookieStore.getCookies();
			  if( !cookies.isEmpty() ){
			      for (Cookie cookie : cookies){
			    	  list.add(cookie.getName() + _nameValueSeparator + cookie.getValue());	         
			      }
			  }
			  
		} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
		}			
		return list.toArray(new String[list.size()]);			
    }
		   
	public int GetCookiesCount() {	  	
	  return cookieStore.getCookies().size();
	}	 
		   
	public Cookie GetCookieByIndex(int _index) {
		if (_index <  cookieStore.getCookies().size()) 
	       return cookieStore.getCookies().get(_index);
		else return  null;
	}
		      
    public String GetCookieAttributeValue(Cookie _cookie, String _attribute) {
			  String r = ""; 
			  if (_attribute.equals("name"))  r = _cookie.getName();
			  else if (_attribute.equals("value")) r = _cookie.getValue();
			  else if (_attribute.equals("domain")) r = _cookie.getDomain();
			  else if (_attribute.equals("version")) r = String.valueOf(_cookie.getVersion());
			  else if (_attribute.equals("expirydate")) r = _cookie.getExpiryDate().toString();//DateFormat.format("yyyyMMdd  kk:mm",  _cookie.getExpiryDate()).toString();
			  else if (_attribute.equals("path")) r = _cookie.getPath();
			  else if (_attribute.equals("comment")) r = _cookie.getComment();			  
			  else if (_attribute.equals("ports")) r = String.valueOf(_cookie.getPorts());
			  return r;
    }
		   
		   
    public void ClearCookieStore() {
	    cookieStore.clear(); 			  
    }
		   
    public Cookie AddCookie(String _name, String _value)  {        
			   BasicClientCookie cookie = new BasicClientCookie(_name, _value);
		       //cookie.setDomain("your domain");cookie.setPath("/");
		       cookieStore.addCookie(cookie); 
		       return cookie;
    }
	
    private Date StringToDate(String dateString) {
      //String dateString = "03/26/2012 11:49:00 AM";
      SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss aa");
      Date convertedDate = new Date();
      try {
         convertedDate = dateFormat.parse(dateString);
      } catch (ParseException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }      
      return convertedDate;
    }
    
    public void SetCookieAttributeValue(Cookie _cookie, String _attribute,  String _value) {
		   
    	  BasicClientCookie stdCookie = (BasicClientCookie)_cookie;	
    	  
		  if (_attribute.equals("value")) stdCookie.setValue(_value);
		  else if (_attribute.equals("domain")) stdCookie.setDomain(_value);
		  else if (_attribute.equals("version")) stdCookie.setVersion(Integer.parseInt(_value));
		  
		  else if (_attribute.equals("expirydate")) {  
			  stdCookie.setExpiryDate(StringToDate(_value));
		  }	  
		  
		  else if (_attribute.equals("path")) stdCookie.setPath(_value);
		  else if (_attribute.equals("comment"))  stdCookie.setComment(_value);
		  else if (_attribute.equals("ports"))  stdCookie.setSecure(false);	
		  
		  //stdCookie.setPorts(new int[] {80,8080});
    }    
    
    public String GetCookieValue(Cookie _cookie) {    
        return _cookie.getValue();        
    }

    public String GetCookieName(Cookie _cookie) {    
        return _cookie.getName();        
    }
    
    public void SetCookieValue(Cookie _cookie, String _value) {    
       ((BasicClientCookie)_cookie).setValue(_value);
       cookieStore.addCookie(_cookie);
    }
        
    public Cookie GetCookieByName(String _cookieName) {
        Cookie ret = null;
        List<Cookie> l = cookieStore.getCookies();
        for (Cookie c : l) {
            if (c.getName().equals(_cookieName)) {
                ret = c;
                break;
            }
        }
        return ret;
    }
        
    public boolean IsExpired(Cookie _cookie) { 
	   return _cookie.isExpired(new Date()); //true if the cookie has expired. 
	}
	    
    public boolean IsCookiePersistent(Cookie _cookie) { 
 	   return _cookie.isPersistent(); //true if the cookie is Persistent 
 	}

    //-----------------------------------    
    
    /*Overwrites the first header with the same name. 
     * The new header will be appended to the end of the list, 
     * if no header with the given name can be found.
     * httpget.setHeader("Cookie",  "JSESSIONID=1"); //Here i am sending the Cookie session ID
    */
    
    public void AddClientHeader (String _name, String _value ) {    	
    	listHeaderName.add(_name);
    	listHeaderValue.add(_value);    	    	
    }
    
    public void ClearClientHeader (String _name, String _value ) {    	
    	listHeaderName.clear();
    	listHeaderValue.clear();    	    	
    }
    
    public String GetStateful(String _url) {
 	   
 		String strResult = ""; 		  		
 	    HttpGet httpget=new HttpGet(_url);
 	    
 	    for (int i = 0; i < listHeaderName.size(); i++ ) { 	    
 	    	httpget.setHeader(listHeaderName.get(i), listHeaderValue.get(i));
 	    }	
 	     	     	    
 		try {			 
 			//cookieStore.clear();
 			 HttpResponse response = client2.execute(httpget, localContext);			 
 		     HttpEntity entity= response.getEntity();
 		     
 		     StatusLine statusLine = response.getStatusLine();
 	         int statusCode = statusLine.getStatusCode();
 	          	                  
 	         if (statusCode == 200) {    //OK       
 	            entity = response.getEntity();	                
 		        if (entity != null) {
 			    	 strResult = EntityUtils.toString(entity);
 			    }
 	         }			 	 	         
	 	       
 	         return strResult;
 		}
 		 
 		catch (IOException e) {
 			// TODO Auto-generated catch block
 			e.printStackTrace();
 		}		 				 
 		return strResult; //sb.toString(); 		
    }
      
    public String PostStateful(String _url) throws Exception {	// Pascal: Post			
		
 		int statusCode = 0;		
 		String strResult = "";
 		
 		HttpParams httpParams = new BasicHttpParams();
 		int connection_Timeout = 5000;
 		HttpConnectionParams.setConnectionTimeout(httpParams, connection_Timeout);
 		HttpConnectionParams.setSoTimeout(httpParams, connection_Timeout);
 		
        if (mAuthenticationMode != 0) {    		   
         	client2.getCredentialsProvider().setCredentials(
                         new AuthScope(mHOSTNAME,mPORT),  // 
                         new UsernamePasswordCredentials(mUSERNAME, mPASSWORD));
 	    }
         			   
 	    HttpPost httpPost = new HttpPost(_url);
 	    
 	    for (int i = 0; i < listHeaderName.size(); i++ ) {
 	    	Log.i(listHeaderName.get(i), listHeaderValue.get(i));
 	    	httpPost.setHeader(listHeaderName.get(i), listHeaderValue.get(i));
 	    }
 	    
 	    //thanks to @renabor
 	    if (mAuthenticationMode != 0) {
             String _credentials = mUSERNAME + ":" + mPASSWORD;
             String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
             httpPost.addHeader("Authorization", "Basic " + _base64EncodedCredentials);
         }	   
 	        
 	    httpPost.setEntity(new UrlEncodedFormEntity(ValuesForPost2));
 	    
 	    //cookieStore.clear();
 	   
 		HttpResponse response = client2.execute(httpPost, localContext);
 		HttpEntity entity= response.getEntity();
 		
	     StatusLine statusLine = response.getStatusLine();
	     statusCode = statusLine.getStatusCode();
 		
         if (statusCode == 200) {    //OK       
	            entity = response.getEntity();	                
		        if (entity != null) {
			    	 strResult = EntityUtils.toString(entity);
			    }
	     }
 			 		
 		return strResult; 
   }
    
  //thanks to @renabor
    public String DeleteStateful(String _url, String _value) throws Exception { 			

    	int statusCode = 0;
    	String strResult = "";

    	HttpParams httpParams = new BasicHttpParams();
    	int connection_Timeout = 5000;
    	HttpConnectionParams.setConnectionTimeout(httpParams, connection_Timeout);
    	HttpConnectionParams.setSoTimeout(httpParams, connection_Timeout);

    	HttpDelete httpDelete = new HttpDelete(_url + "/" + _value);

    	if (mAuthenticationMode != 0) {
    		String _credentials = mUSERNAME + ":" + mPASSWORD;
    		String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
    		httpDelete.addHeader("Authorization", "Basic " + _base64EncodedCredentials);
    	}

    	HttpResponse response = client2.execute(httpDelete, localContext);
    	HttpEntity entity = response.getEntity();

    	StatusLine statusLine = response.getStatusLine();
    	statusCode = statusLine.getStatusCode();

    	if (statusCode == 200) { //OK       
    		entity = response.getEntity();
    		if (entity != null) {
    			strResult = EntityUtils.toString(entity);
    		}
    	}
    	return strResult;
    }    
    
	/*
	 * AsyncTask has three generic types:
       Params: An array of parameters you want to pass in to the class you create when you subclass AsyncTask.
       Progress: If you override onProgressUpdate, this is the type that method returns.
       Result: This is the type that doInBackground returns.
	 */
	
	class AsyncHttpClientPostNameValueData extends AsyncTask<String, Integer, String> {	
		  
	    @Override
	    protected String doInBackground(String... stringUrl) {
	    	
	    	String _stringUrl = stringUrl[0]; 
	    	String _name  = stringUrl[1]; 
	    	String _value  = stringUrl[2];
	    	
			String strResult = "";
			HttpEntity entity = null;
	    	
			// Create a new HttpClient and Post Header
			int statusCode = 0;						
			HttpParams httpParams = new BasicHttpParams();
			int connection_Timeout = 5000;
			HttpConnectionParams.setConnectionTimeout(httpParams, connection_Timeout);
			HttpConnectionParams.setSoTimeout(httpParams, connection_Timeout);
			
			DefaultHttpClient httpclient = new DefaultHttpClient();					 	   
		    //AuthScope:
		    //host  the host the credentials apply to. May be set to null if credenticals are applicable to any host. 
		    //port  the port the credentials apply to. May be set to negative value if credenticals are applicable to any port.
			try {				
    	        if (mAuthenticationMode != 0) {    		   
                  httpclient.getCredentialsProvider().setCredentials(
                               new AuthScope(mHOSTNAME,mPORT),  // 
                               new UsernamePasswordCredentials(mUSERNAME, mPASSWORD));
    	        }
    	        
			    HttpPost httppost = new HttpPost(_stringUrl);
			    
			    //thanks to @renabor
			    if (mAuthenticationMode != 0) {
                    String _credentials = mUSERNAME + ":" + mPASSWORD;
                    String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
                    httppost.addHeader("Authorization", "Basic " + _base64EncodedCredentials);
               }
			    			    			    
				// Add your data				
			    if (!_name.equals("")) { 
			         List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();				
				     nameValuePairs.add(new BasicNameValuePair(_name, _value));
				     httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
			    }
			    else {			    	
			       httppost.setEntity(new UrlEncodedFormEntity(ValuesForPost2));
			    }				
				// Execute HTTP Post Request
				HttpResponse response = httpclient.execute(httppost);
				StatusLine statusLine = response.getStatusLine();  
				statusCode = statusLine.getStatusCode();
				
				this.publishProgress(statusCode);	            	            
	            strResult= "";	            
	            if (statusCode == 200) {    //OK       
	                entity = response.getEntity();	                
		            if (entity != null) {
			         	   strResult = EntityUtils.toString(entity);
			         }
	            }
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
			} 
			return strResult;	
	    }	    	
	           	    
	    @Override
	    protected void onPostExecute(String content) {
	      controls.pOnHttpClientContentResult(pascalObj, content);
	    }
	    	    
	    @Override
	    protected void onProgressUpdate(Integer... params) {
	       super.onProgressUpdate(params);	       
	       controls.pOnHttpClientCodeResult(pascalObj, params[0].intValue());	  	     
	    }
	}
		
	class AsyncHttpClientPostListNameValueData extends AsyncTask<String, Integer, String> {	
		  
	    @Override
	    protected String doInBackground(String... stringParams) {
			// Create a new HttpClient and Post Header
			int statusCode = 0;
			String strResult = "";
			HttpEntity entity = null;	 	   
			
			HttpParams httpParams = new BasicHttpParams();
			int connection_Timeout = 5000;
			HttpConnectionParams.setConnectionTimeout(httpParams, connection_Timeout);
			HttpConnectionParams.setSoTimeout(httpParams, connection_Timeout);
			
			DefaultHttpClient httpclient = new DefaultHttpClient();			 	   
		    //AuthScope:
		    //host  the host the credentials apply to. May be set to null if credenticals are applicable to any host. 
		    //port  the port the credentials apply to. May be set to negative value if credenticals are applicable to any port.
			try {
				
		        if (mAuthenticationMode != 0) {    		   
	              httpclient.getCredentialsProvider().setCredentials(
	                           new AuthScope(mHOSTNAME,mPORT),  // 
	                           new UsernamePasswordCredentials(mUSERNAME, mPASSWORD));
		        }
						
			    HttpPost httppost = new HttpPost(stringParams[0]);

			    //thanks to @renabor
			    if (mAuthenticationMode != 0) {
                    String _credentials = mUSERNAME + ":" + mPASSWORD;
                    String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
                    httppost.addHeader("Authorization", "Basic " + _base64EncodedCredentials);
                }
			    
				// Add your data
				List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();						
				StringTokenizer st = new StringTokenizer(stringParams[1], "=&"); //name1=value1&name2=value2&name3=value3 ...		
				
				while(st.hasMoreTokens()) { 
				  String key = st.nextToken(); 
				  String val = st.nextToken(); 
				  //Log.i("name ->", key);
				  //Log.i("value ->", val);
				  nameValuePairs.add(new BasicNameValuePair(key, val));
				}					
				httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
				// Execute HTTP Post Request
				HttpResponse response = httpclient.execute(httppost);
				StatusLine statusLine = response.getStatusLine();  
				statusCode = statusLine.getStatusCode();
				
				this.publishProgress(statusCode);	            	            
	            strResult= "";	            
	            if (statusCode == 200) {    //OK       
	                entity = response.getEntity();	                
		            if (entity != null) {
			         	   strResult = EntityUtils.toString(entity);
			         }
	            }
	            
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
			}		 
			return strResult;	    		
	    }	    	
	     
	    @Override
	    protected void onPostExecute(String content) {
	      controls.pOnHttpClientContentResult(pascalObj, content);
	    }
	    	    
	    @Override
	    protected void onProgressUpdate(Integer... params) {
	       super.onProgressUpdate(params);	       
	       controls.pOnHttpClientCodeResult(pascalObj, params[0].intValue());	  	     
	    }	    	    
	    
	}
	
	class AsyncHttpClientGet extends AsyncTask<String,Integer,String> {	
		  	    
	    @Override
	    protected String doInBackground(String... stringUrl) {
	    	
	        //ref. http://jan.horneck.info/blog/androidhttpclientwithbasicauthentication
	 	   HttpEntity entity = null;	 	   
	 	   HttpParams httpParams = new BasicHttpParams();
	 	   int connection_Timeout = 5000;
	 	   HttpConnectionParams.setConnectionTimeout(httpParams, connection_Timeout);
	 	   HttpConnectionParams.setSoTimeout(httpParams, connection_Timeout);
	 	    
	 	    /*ref. http://blog.leocad.io/basic-http-authentication-on-android/
	 	    String credentials = mUSERNAME + ":" + mPASSWORD;  
	 	    String base64EncodedCredentials = Base64.encodeToString(credentials.getBytes(), Base64.NO_WRAP);  
	 	    request.addHeader("Authorization", "Basic " + base64EncodedCredentials);
	 	    client = new DefaultHttpClient();
	 	   */
	 	   
	 	    DefaultHttpClient httpclient = new DefaultHttpClient(httpParams);
	        String strResult="";
	        
	        try {
	     	   
	 		    //AuthScope:
	 		    //host  the host the credentials apply to. May be set to null if credenticals are applicable to any host. 
	 		    //port  the port the credentials apply to. May be set to negative value if credenticals are applicable to any port.
	     	   if (mAuthenticationMode != 0) {    		   
	               httpclient.getCredentialsProvider().setCredentials(
	                                new AuthScope(mHOSTNAME,mPORT),  // 
	                                new UsernamePasswordCredentials(mUSERNAME, mPASSWORD));
	     	   }
	     	   
	            HttpGet httpget = new HttpGet(stringUrl[0]);
	            
	            //thanks to @renabor
	            if (mAuthenticationMode != 0) {
                    String _credentials = mUSERNAME + ":" + mPASSWORD;
                    String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
                    httpget.addHeader("Authorization", "Basic " + _base64EncodedCredentials);
                }

	            //System.out.println("executing request" + httpget.getRequestLine());
	            HttpResponse response = httpclient.execute(httpget);
	            
	            StatusLine statusLine = response.getStatusLine();
	            int statusCode = statusLine.getStatusCode();
	            this.publishProgress(statusCode);	            	            
	            strResult= "";	            
	            if (statusCode == 200) {    //OK       
	                entity = response.getEntity();	                
		            if (entity != null) {
			         	   strResult = EntityUtils.toString(entity);
			         }
	            }    
	            	            	          	            
	        } catch(Exception e){
	        	    e.printStackTrace();
	        }finally {
	            // When HttpClient instance is no longer needed,
	            // shut down the connection manager to ensure
	            // immediate deallocation of all system resources
	            httpclient.getConnectionManager().shutdown();
	        }
	        return strResult;
	    }	    	
	           	            
	    @Override
	    protected void onPostExecute(String content) {
	      controls.pOnHttpClientContentResult(pascalObj, content);
	    }
	    	    
	    @Override
	    protected void onProgressUpdate(Integer... params) {
	       super.onProgressUpdate(params);	       
	       controls.pOnHttpClientCodeResult(pascalObj, params[0].intValue());	  	     
	    }	    	    	    
	}
}


/*Draft java code by "Lazarus Android Module Wizard" [5/8/2015 20:24:14]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//ref. http://tech-papers.org/executing-shell-command-android-application/
class jShellCommand {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
 
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jShellCommand(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      //Log.i("jShellCommand", "create");
   }
 
   public void jFree() {
     //free local objects...
   }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 public void Execute(String _shellCmd) {
	 //Log.i("exec", "0");
	 new AsyncShellCmd().execute(_shellCmd);
	// Log.i("exec", "1");
 }  
   

 class AsyncShellCmd extends AsyncTask<String, String, String>  {	     
    
     @Override
     protected String doInBackground(String... params) {
       Process p;
       StringBuffer output = new StringBuffer();
       try {
         p = Runtime.getRuntime().exec(params[0]);
         BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
         String line = "";
         while ((line = reader.readLine()) != null) {
            output.append(line + "\n");
            p.waitFor();
          //publishProgress(response); TODO       
         }         
        } catch (IOException e) {
         e.printStackTrace();
        } catch (InterruptedException e) {
         e.printStackTrace();
       }
       String response = output.toString();       
       return response;
     }
        
     /*
     @Override
     protected void onProgressUpdate(String... values) {
         super.onProgressUpdate(values);
         //TODO        
     }   
     */
     
     @Override
     protected void onPostExecute(String values) {    	  
       super.onPostExecute(values);       
       controls.pOnShellCommandExecuted(pascalObj, values);
     }          
  } //AsyncTask
 
}

/*Draft java code by "Lazarus Android Module Wizard" [5/9/2015 3:06:34]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/
  
class jAnalogClock extends AnalogClock /*dummy*/ { //please, fix what GUI object will be extended!
   
   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events
   
   private Context context = null;
   private ViewGroup parent   = null;         // parent view
   private RelativeLayout.LayoutParams lparams;              // layout XYWH 
   private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   private int lparamsAnchorRule[] = new int[30];
   private int countAnchorRule = 0;
   private int lparamsParentRule[] = new int[30];
   private int countParentRule = 0;
   private int lparamH = 100;
   private int lparamW = 100;
   private int marginLeft = 0;
   private int marginTop = 0;
   private int marginRight = 0;
   private int marginBottom = 0;
   private boolean mRemovedFromParent = false;
  
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
   public jAnalogClock(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
   
      lparams = new RelativeLayout.LayoutParams(lparamW, lparamH);
   
      onClickListener = new OnClickListener(){
      /*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!
              if (enabled) {
                 controls.pOnClick(pascalObj, Const.Click_Default); //JNI event onClick!
              }
           };
      };
      setOnClickListener(onClickListener);
   } //end constructor
   
   public void jFree() {
      if (parent != null) { parent.removeView(this); }
      //free local objects...
      lparams = null;
      setOnClickListener(null);
   }
  
   public void SetViewParent(ViewGroup _viewgroup) {
      if (parent != null) { parent.removeView(this); }
      parent = _viewgroup;
      parent.addView(this,lparams);
      mRemovedFromParent = false;
   }
   
   public void RemoveFromViewParent() {
      if (!mRemovedFromParent) {
         this.setVisibility(android.view.View.INVISIBLE);
         if (parent != null)
    	       parent.removeView(this);
	   mRemovedFromParent = true;
	}
   }
  
   public View GetView() {
      return this;
   }
  
   public void SetLParamWidth(int _w) {
      lparamW = _w;
   }
  
   public void SetLParamHeight(int _h) {
      lparamH = _h;
   }
  
   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
      marginLeft = _left;
      marginTop = _top;
      marginRight = _right;
      marginBottom = _bottom;
      lparamH = _h;
      lparamW = _w;
   }
  
   public void AddLParamsAnchorRule(int _rule) {
      lparamsAnchorRule[countAnchorRule] = _rule;
      countAnchorRule = countAnchorRule + 1;
   }
  
   public void AddLParamsParentRule(int _rule) {
      lparamsParentRule[countParentRule] = _rule;
      countParentRule = countParentRule + 1;
   }
  
   public void SetLayoutAll(int _idAnchor) {
  	lparams.width  = lparamW;
	lparams.height = lparamH;
	lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
	if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
		lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	}
      for (int j=0; j < countParentRule; j++) {
         lparams.addRule(lparamsParentRule[j]);
      }
      this.setLayoutParams(lparams);
   }
  
   public void ClearLayoutAll() {
	for (int i=0; i < countAnchorRule; i++) {
  	   lparams.removeRule(lparamsAnchorRule[i]);
    	}
  
	for (int j=0; j < countParentRule; j++) {
   	   lparams.removeRule(lparamsParentRule[j]);
	}
	countAnchorRule = 0;
	countParentRule = 0;
   }
 
   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }
     
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
} //end class

class jDigitalClock extends DigitalClock /*TextClock*/ { //please, fix what GUI object will be extended!
	   
	   private long       pascalObj = 0;    // Pascal Object
	   private Controls   controls  = null; // Control Class for events
	   
	   private Context context = null;
	   private ViewGroup parent   = null;         // parent view
	   private RelativeLayout.LayoutParams lparams;              // layout XYWH 
	   private OnClickListener onClickListener;   // click event
	   private Boolean enabled  = true;           // click-touch enabled!
	   private int lparamsAnchorRule[] = new int[30];
	   private int countAnchorRule = 0;
	   private int lparamsParentRule[] = new int[30];
	   private int countParentRule = 0;
	   private int lparamH = 100;
	   private int lparamW = 100;
	   private int marginLeft = 0;
	   private int marginTop = 0;
	   private int marginRight = 0;
	   private int marginBottom = 0;
	   private boolean mRemovedFromParent = false;
	   
	   float mTextSize = 0; //default
	   int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default
	  
	  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
	  
	   public jDigitalClock(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
	      super(_ctrls.activity);
	      context   = _ctrls.activity;
	      pascalObj = _Self;
	      controls  = _ctrls;
	   
	      lparams = new RelativeLayout.LayoutParams(lparamW, lparamH);
	   
	      onClickListener = new OnClickListener(){
	      /*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!
	              if (enabled) {
	                 controls.pOnClick(pascalObj, Const.Click_Default); //JNI event onClick!
	              }
	           };
	      };
	      setOnClickListener(onClickListener);
	   } //end constructor
	   
	   public void jFree() {
	      if (parent != null) { parent.removeView(this); }
	      //free local objects...
	      lparams = null;
	      setOnClickListener(null);
	   }
	  
	   public void SetViewParent(ViewGroup _viewgroup) {
	      if (parent != null) { parent.removeView(this); }
	      parent = _viewgroup;
	      parent.addView(this,lparams);
	      mRemovedFromParent = false;
	   }
	   
	   public void RemoveFromViewParent() {
	      if (!mRemovedFromParent) {
	         this.setVisibility(android.view.View.INVISIBLE);
	         if (parent != null)
	    	       parent.removeView(this);
		   mRemovedFromParent = true;
		}
	   }
	  
	   public View GetView() {
	      return this;
	   }
	  
	   public void SetLParamWidth(int _w) {
	      lparamW = _w;
	   }
	  
	   public void SetLParamHeight(int _h) {
	      lparamH = _h;
	   }
	  
	   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
	      marginLeft = _left;
	      marginTop = _top;
	      marginRight = _right;
	      marginBottom = _bottom;
	      lparamH = _h;
	      lparamW = _w;
	   }
	  
	   public void AddLParamsAnchorRule(int _rule) {
	      lparamsAnchorRule[countAnchorRule] = _rule;
	      countAnchorRule = countAnchorRule + 1;
	   }
	  
	   public void AddLParamsParentRule(int _rule) {
	      lparamsParentRule[countParentRule] = _rule;
	      countParentRule = countParentRule + 1;
	   }
	  
	   public void SetLayoutAll(int _idAnchor) {
	  	lparams.width  = lparamW;
		lparams.height = lparamH;
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
		if (_idAnchor > 0) {
		    for (int i=0; i < countAnchorRule; i++) {
			lparams.addRule(lparamsAnchorRule[i], _idAnchor);
		    }
		}
	      for (int j=0; j < countParentRule; j++) {
	         lparams.addRule(lparamsParentRule[j]);
	      }
	      this.setLayoutParams(lparams);
	   }
	  
	   public void ClearLayoutAll() {
		for (int i=0; i < countAnchorRule; i++) {
	  	   lparams.removeRule(lparamsAnchorRule[i]);
	    	}
	  
		for (int j=0; j < countParentRule; j++) {
	   	   lparams.removeRule(lparamsParentRule[j]);
		}
		countAnchorRule = 0;
		countParentRule = 0;
	   }
	 
	   public void SetId(int _id) { //wrapper method pattern ...
	      this.setId(_id);
	   }
	  
	  //write others [public] methods code here......
	  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
	   
	   public void SetTextSize(float size) {
		   mTextSize = size;	
		   CharSequence t = this.getText();  
		   this.setTextSize(mTextSizeTypedValue, mTextSize);
		   this.setText(t);
		}     

		//TTextSizeTypedValue =(tsDefault, tsPixels, tsDIP, tsInches, tsMillimeters, tsPoints, tsScaledPixel);
		public void SetFontSizeUnit(int _unit) {	
		   switch (_unit) {
		      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
		      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; //default
		      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break; //default
		      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; //default
		      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; //default
		      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; //default
		      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
		   }   
			String t = this.getText().toString();
			this.setTextSize(mTextSizeTypedValue, mTextSize);
			this.setText(t);
		}
		
} //end class

/**
 *         ref. http://www.myandroidsolutions.com/2013/03/31/android-tcp-connection-enhanced/
 *         ref. http://www.darksleep.com/player/SocketExample/
 */

class jTCPSocketClient {

    private long  pascalObj = 0;      // Pascal Object
    Controls controls;    
    private Context  context   = null;
    
    private String SERVER_IP = "" ;//"192.168.0.100"   
    private int SERVER_PORT;
       
    // message to send to the server
    private String mServerMessage;
    
    private boolean mRun = false;
    // used to send messages
    private PrintWriter mBufferOut;
    // used to read messages from the server
    private BufferedReader mBufferIn;
    private Socket mSocket;
    
    //TCPSocketClientTask task;
           	
    public jTCPSocketClient(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
    	   //super(_ctrls.activity);
 	       context   = _ctrls.activity;
    	   pascalObj = _Self;
    	   controls  = _ctrls; 	
    }

    public void jFree() {
       //free local objects...
        mBufferOut= null;;
        mBufferIn= null;
        mSocket= null;    	
    }
   
    /**
     * Sends the message entered by client to the server
     */
    
    public void SendMessage(String message) {
    	
        if (mBufferOut != null && !mBufferOut.checkError()) {
            mBufferOut.println(message);
            mBufferOut.flush();
        }
    }
     
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
         
    public void Connect(String _serverIP, int _serverPort) {
    	  
          SERVER_IP = _serverIP;          //IP address
          SERVER_PORT = _serverPort;       //port number;
          if (mSocket != null) {
        	  try {
				mSocket.close();
				mSocket = null;
			  } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			  }
          }
          
          try {
              InetAddress serverAddr = InetAddress.getByName(SERVER_IP);
			  mSocket = new Socket(serverAddr, SERVER_PORT);
		  } catch (IOException e) {
			  // TODO Auto-generated catch block
		      e.printStackTrace();
		  }
          
          controls.pOnTCPSocketClientConnected(pascalObj);         
          new TCPSocketClientTask().execute();                                    	  
      }
            
     public void Connect(String _serverIP, int _serverPort, String _login) {    	  
    	 Connect(_serverIP,_serverPort);
    	 SendMessage(_login);       	  
      }
     
      public void CloseConnection(String _finalMessage) {                
          mRun = false;        
                        
          if (mBufferOut != null) {
               mBufferOut.flush();
          }
          if (_finalMessage.equals("")) 
              SendMessage("client_closed");
          else SendMessage(_finalMessage);
      }
      
      public void CloseConnection() {
      	CloseConnection("client_closed");
      }
                  
      class TCPSocketClientTask extends AsyncTask<String, String, String> {
      	
          @Override
          protected String doInBackground(String... message) {               
              mRun = true;
              while (mRun) {
                    if ( mSocket!= null && !mSocket.isClosed()) {             		
                        try {                    	
    						mBufferOut = new PrintWriter(new BufferedWriter(new OutputStreamWriter(mSocket.getOutputStream())), true);
    	                    mBufferIn = new BufferedReader(new InputStreamReader(mSocket.getInputStream()));              
    	                    //in this while the client listens for the messages sent by the server
    	                    if (mBufferIn != null)
    	                           mServerMessage = mBufferIn.readLine();
    	                    if (mServerMessage != null )                     	
    	                       	 publishProgress(mServerMessage);
    					} catch (IOException e) {
    						// TODO Auto-generated catch block
    						Log.e("jTCPSocketClient", "Error_doInBackground", e);
    						e.printStackTrace();
    					}                                 	                                         
               	    }        	        	             
              }
              return null;
          }

          @Override
          protected void onProgressUpdate(String... values) {
              super.onProgressUpdate(values);
              controls.pOnTCPSocketClientMessageReceived(pascalObj ,values);
          }
          
          @Override
          protected void onPostExecute(String values) {    	  
            super.onPostExecute(values);   	  
            try {                	         	   
     			mSocket.close();
     	    } catch (IOException e) {
     			// TODO Auto-generated catch block
     			e.printStackTrace();
     	    }            
          }
        }            
}


/*Draft java code by "Lazarus Android Module Wizard" [6/3/2015 0:43:27]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/
 
class jSurfaceView  extends SurfaceView  /*dummy*/ { //please, fix what GUI object will be extended!
  
  private long       pascalObj = 0;    // Pascal Object
  private Controls   controls  = null; // Control Class for events
  
  private Context context = null;
  private ViewGroup parent   = null;         // parent view
  private RelativeLayout.LayoutParams lparams;              // layout XYWH 
  private OnClickListener onClickListener;   // click event
  private Boolean enabled  = true;           // click-touch enabled!
  private int lparamsAnchorRule[] = new int[30];
  private int countAnchorRule = 0;
  private int lparamsParentRule[] = new int[30];
  private int countParentRule = 0;
  private int lparamH = RelativeLayout.LayoutParams.MATCH_PARENT;
  private int lparamW = RelativeLayout.LayoutParams.MATCH_PARENT;
  private int marginLeft = 0;
  private int marginTop = 0;
  private int marginRight = 0;
  private int marginBottom = 0;
  private boolean mRemovedFromParent = false;
  
  private SurfaceHolder surfaceHolder;

  Paint paint;
  
  boolean mRun = false;
  long mSleeptime = 10;
  float mStartProgress = 0;
  float mStepProgress = 1;
  boolean mDrawing = false;
 
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
  public jSurfaceView(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
     super(_ctrls.activity);
     context   = _ctrls.activity;
     pascalObj = _Self;
     controls  = _ctrls;
           
     controls.activity.getWindow().setFormat(PixelFormat.UNKNOWN);
     lparams = new RelativeLayout.LayoutParams(lparamW, lparamH);
       
     surfaceHolder = this.getHolder();
     surfaceHolder.addCallback(new Callback() {     	           
         
         @Override  
         public void surfaceCreated(SurfaceHolder holder) {           	        	
     		controls.pOnSurfaceViewCreated(pascalObj, holder);     		     		
     		//setWillNotDraw(true); //false = Allows us to use invalidate() to call onDraw()     		      		      		     		                        
         }          
         
         @Override           
         public void surfaceChanged(SurfaceHolder holder, int format, int width,  int height) {  
        	 controls.pOnSurfaceViewChanged(pascalObj,width,height);
         }
         
         @Override  
         public void surfaceDestroyed(SurfaceHolder holder) {
        	 mRun = false;        	              
         }
         
     });
     
     /*
     onClickListener = new OnClickListener(){
         public void onClick(View view){  //please, do not remove mask for parse invisibility!
                 if (enabled) {
                    controls.pOnClick(pascalObj, Const.Click_Default); //JNI event onClick!
                 }
              };
     };     
     setOnClickListener(onClickListener);     
     */
     
     paint = new Paint();
                   
  } //end constructor
    
   public void jFree() {
     if (parent != null) { parent.removeView(this); }
     //free local objects...
     lparams = null;
     //setOnClickListener(null);     
     surfaceHolder  = null;
     paint = null;
   }
 
   public void SetViewParent(ViewGroup _viewgroup) {
     if (parent != null) { parent.removeView(this); }
     parent = _viewgroup;
     parent.addView(this,lparams);
     mRemovedFromParent = false;
   }
  
   public void RemoveFromViewParent() {
     if (!mRemovedFromParent) {
        this.setVisibility(android.view.View.INVISIBLE);
        if (parent != null)
   	        parent.removeView(this);
	    mRemovedFromParent = true;
	 }
   }
 
   public View GetView() {
     return this;
   }
 
   public void SetLParamWidth(int _w) {
     lparamW = _w;
   }
 
   public void SetLParamHeight(int _h) {
     lparamH = _h;
   }
 
   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
     marginLeft = _left;
     marginTop = _top;
     marginRight = _right;
     marginBottom = _bottom;
     lparamH = _h;
     lparamW = _w;
   }
 
   public void AddLParamsAnchorRule(int _rule) {
     lparamsAnchorRule[countAnchorRule] = _rule;
     countAnchorRule = countAnchorRule + 1;
   }
 
   public void AddLParamsParentRule(int _rule) {
     lparamsParentRule[countParentRule] = _rule;
     countParentRule = countParentRule + 1;
   }
 
   public void SetLayoutAll(int _idAnchor) {
 	 lparams.width  = lparamW;
	 lparams.height = lparamH;
	 lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
	 if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
		lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	 }
     for (int j=0; j < countParentRule; j++) {
        lparams.addRule(lparamsParentRule[j]);
     }
     this.setLayoutParams(lparams);
   }
 
   public void ClearLayoutAll() {
	 for (int i=0; i < countAnchorRule; i++) {
 	   lparams.removeRule(lparamsAnchorRule[i]);
     }
 
	 for (int j=0; j < countParentRule; j++) {
  	   lparams.removeRule(lparamsParentRule[j]);
	 }
	 countAnchorRule = 0;
	 countParentRule = 0;
   }

   public void SetId(int _id) { //wrapper method pattern ...
     this.setId(_id);
   }
 
   @Override
   protected void onDraw(Canvas canvas) {	
	 if (mDrawing)  controls.pOnSurfaceViewDraw(pascalObj, canvas);	   
   }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...  
         
   public void DrawLine(Canvas _canvas, float _x1, float _y1, float _x2, float _y2) {	       
	  _canvas.drawLine(_x1,_y1,_x2,_y2, paint );
   }

   public void DrawLine(Canvas _canvas, float[] _points) {	 
	   _canvas.drawLines(_points, paint);        	     
   }
      
	public  void DrawText(Canvas _canvas, String _text, float _x, float _y ) {
		_canvas.drawText(_text,_x,_y,paint);
	}

	public  void DrawBitmap(Canvas _canvas, Bitmap _bitmap, int _b, int _l, int _r, int _t) {
	    Rect rect = new Rect(_b,_l,_r,_t); //bello, left, right, top
	   _canvas.drawBitmap(_bitmap,null,rect,null/*paint*/);
    }
	
	public void DrawBitmap(Canvas _canvas, Bitmap _bitmap , float _left, float _top) {
	   _canvas.drawBitmap(_bitmap, _left, _top, null/*paint*/);
	}

   public void DrawPoint(Canvas _canvas, float _x1, float _y1) {	   
	   _canvas.drawPoint(_x1,_y1,paint);		   
   }
   
   public void DrawCircle(Canvas _canvas, float _cx, float _cy, float _radius) {	   
	   _canvas.drawCircle(_cx, _cy, _radius, paint);		   
   }
      
   public void DrawBackground(Canvas _canvas, int _color) {
        _canvas.drawColor(_color);
   }
      
  public void DrawRect(Canvas _canvas, float _left, float _top, float _right, float _bottom) { 
     _canvas.drawRect(_left, _top, _right, _bottom, paint);
  }
   
  public  void SetPaintStrokeWidth(float _width) {
	 paint.setStrokeWidth(_width);
  }

   public  void SetPaintStyle(int _style) {
		switch (_style) {
		  case 0  : { paint.setStyle(Paint.Style.FILL           ); break; }
		  case 1  : { paint.setStyle(Paint.Style.FILL_AND_STROKE); break; }
		  case 2  : { paint.setStyle(Paint.Style.STROKE);          break; }
		  default : { paint.setStyle(Paint.Style.FILL           ); break; }
		}
	}

	public  void SetPaintColor(int _color) {
		paint.setColor(_color);
	}

	public  void SetPaintTextSize(float _textsize) {
		paint.setTextSize(_textsize);
	}
	
	public void DispatchOnDraw(boolean _value) {
	   mDrawing = _value;	
	   setWillNotDraw(!_value); //false = Allows us to use invalidate() to call onDraw()
	}
		
	public void SaveToFile(String _path, String _filename) {	 
		
		    Bitmap image = Bitmap.createBitmap(this.getWidth(), this.getHeight(), Bitmap.Config.ARGB_8888);
		    Canvas c = new Canvas(image);
		    this.draw(c);		  
		    File file = new File (_path +"/"+ _filename);	    
		    if (file.exists ()) file.delete (); 
		    try {
		        FileOutputStream out = new FileOutputStream(file);	  
		        
		        if ( _filename.toLowerCase().contains(".jpg") ) image.compress(Bitmap.CompressFormat.JPEG, 90, out);
		        if ( _filename.toLowerCase().contains(".png") ) image.compress(Bitmap.CompressFormat.PNG, 100, out);
		        
		         out.flush();
		         out.close();
		         
		    } catch (Exception e) {
		         e.printStackTrace();
		    }  	     	   
	}	
	
	@Override
	public  boolean onTouchEvent( MotionEvent event) {
	int act     = event.getAction() & MotionEvent.ACTION_MASK;
	switch(act) {
	  case MotionEvent.ACTION_DOWN: {
	        switch (event.getPointerCount()) {
	        	case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,1,
	        		                            event.getX(0),event.getY(0),0,0); break; }
	        	default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,2,
	        		                            event.getX(0),event.getY(0),
	        		                            event.getX(1),event.getY(1));     break; }
	        }
	       break;}
	  case MotionEvent.ACTION_MOVE: {
	        switch (event.getPointerCount()) {
	        	case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchMove,1,
	        		                            event.getX(0),event.getY(0),0,0); break; }
	        	default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchMove,2,
	        		                            event.getX(0),event.getY(0),
	        		                            event.getX(1),event.getY(1));     break; }
	        }
	       break;}
	  case MotionEvent.ACTION_UP: {
	        switch (event.getPointerCount()) {
	        	case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,1,
	        		                            event.getX(0),event.getY(0),0,0); break; }
	        	default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,2,
	        		                            event.getX(0),event.getY(0),
	        		                            event.getX(1),event.getY(1));     break; }
	        }
	       break;}
	  case MotionEvent.ACTION_POINTER_DOWN: {
	        switch (event.getPointerCount()) {
	        	case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,1,
	        		                            event.getX(0),event.getY(0),0,0); break; }
	        	default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,2,
	        		                            event.getX(0),event.getY(0),
	        		                            event.getX(1),event.getY(1));     break; }
	        }
	       break;}
	  case MotionEvent.ACTION_POINTER_UP  : {
	  	   // Log.i("Java","PUp");
	        switch (event.getPointerCount()) {
	        	case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,1,
	        		                            event.getX(0),event.getY(0),0,0); break; }
	        	default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,2,
	        		                            event.getX(0),event.getY(0),
	        		                            event.getX(1),event.getY(1));     break; }
	        }
	       break;}
	} 
	return true;
	}

	public void SetHolderFixedSize(int _width, int _height) {	     		 
	   surfaceHolder.setFixedSize(_width, _height);
	}
	 				
	public Canvas GetLockedCanvas() {		  		  
		return surfaceHolder.lockCanvas();  
	}
    
	public void UnLockCanvas(Canvas _canvas) {
		if(_canvas != null) {   
	          surfaceHolder.unlockCanvasAndPost(_canvas);
		}
	}
	
    //invalidate(): This must be called from a UI thread. 
    //To call from a non-UI thread, call  postInvalidate(). 
      
	//http://blog-en.openalfa.com/how-to-draw-graphics-in-android
    //http://blog.danielnadeau.io/2012/01/android-canvas-beginners-tutorial.html	  
    //http://www.edu4java.com/en/androidgame/androidgame3.html
   
    public void DoDrawingInBackground(boolean _value) {    	       
	   if (!mRun) { 	      	      
	      new DrawTask().execute();   
	   }
       mRun = _value;
       mDrawing = _value;
	   setWillNotDraw(!_value); //false = Allows us to use invalidate() to call onDraw()
    }
               
   public void SetDrawingInBackgroundSleeptime(long _sleepTime) { //long mSleeptime = 20;	   
	   mSleeptime = _sleepTime;   
   }
   
   public void PostInvalidate() {
      this.postInvalidate();
   }
   
   public void Invalidate() {
	  this.invalidate();
   }
   
   public void SetKeepScreenOn(boolean _value) { 
       surfaceHolder.setKeepScreenOn(_value);
   }
  
   //Set whether this view can receive the focus. 
   //Setting this to false will also ensure that this view is not focusable in touch mode.  
   public void SetFocusable(boolean _value) { 
       this.setFocusable(_value); // make sure we get key events
   }
      
   public void SetProgress(float _startValue, float _step) {
       mStartProgress = _startValue; 
       mStepProgress =  _step;
   }
   
   class DrawTask extends AsyncTask<String, Float, String> {
	   Canvas canvas;
	   float count;	   	   
       @Override
       protected String doInBackground(String... message) {               
    	  count = mStartProgress;    	  
          while (controls.pOnSurfaceViewDrawingInBackground(pascalObj, count)) {        	  
            canvas = null;  
            try {  
              canvas = surfaceHolder.lockCanvas(null);                        				 
              try {
                 Thread.sleep(mSleeptime);
              } catch (InterruptedException iE) {
            	  //
              }        	  			              
              synchronized (surfaceHolder) {            
            	  if (canvas != null) {
            	     //Invalidate(); 
                	 PostInvalidate(); 
            	  }	 
              }
              publishProgress(count);
           }
           finally {        	           	   
               if (canvas != null) {                	   
                   surfaceHolder.unlockCanvasAndPost(canvas);     
               }        	                      
           }
           
          }
          mDrawing = false;
          mRun = false;
          return null;
       }

       @Override
       protected void onProgressUpdate(Float... values) {    	   
           super.onProgressUpdate(values);           
           count = count + mStepProgress;           
       }
       
       @Override
       protected void onPostExecute(String values) {    	  
         super.onPostExecute(values);   	             
         controls.pOnSurfaceViewDrawingPostExecute(pascalObj, count);
       }            
   }
   
} //end class



/*Draft java code by "Lazarus Android Module Wizard" [6/16/2015 22:00:31]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//http://androidsurya.blogspot.com.br/2011/12/android-adding-contacts.html
//http://www.higherpass.com/android/tutorials/working-with-android-contacts/
//http://www.androidhub4you.com/2013/06/get-phone-contacts-details-in-android_6.html
//http://stackoverflow.com/questions/9907751/android-update-a-contact   - image
//ref   http://wptrafficanalyzer.in/blog/programatically-adding-contacts-with-photo-using-contacts-provider-in-android-example/
//http://stackoverflow.com/questions/4744187/how-to-add-new-contacts-in-android
//http://techblogon.com/read-multiple-phone-numbers-from-android-contacts-list-programmatically/
//http://email-addresses-in-android-contacts.blogspot.com.br/2011/04/how-to-insert-and-update-email.html

class jContactManager /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jContactManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
   public String GetMobilePhoneNumber(String _displayName){
       
	   String matchNumber = "";
	   String username = _displayName;	   
	   username = username.toLowerCase(); 	   
	   Cursor phones = controls.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	
	   while (phones.moveToNext()) {
	     String name = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));
	     String phoneNumber = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
	     String phoneType = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));	     	     
	     name = name.toLowerCase();	   
	     if(name.equals(username)) {
	    	 if (phoneType.equals("2")) { //mobile
	    	    matchNumber = phoneNumber;
	    	    break;
	    	 }   
	     }		    
	   }	   
	   phones.close();	   
	   return matchNumber;
}
      
//ref http://www.higherpass.com/android/tutorials/working-with-android-contacts/
//http://android-contact-id-vs-raw-contact-id.blogspot.de/
//It's worth to note that there is a 1-to-1 relationship between the CONTACT_ID and the DISPLAY_NAME.   
public String GetContactID(String _displayName){
    
	   String matchID = "";	  
	   String username = _displayName;;	   
	   username = username.toLowerCase(); 
	   
	   Cursor phones = controls.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	      							
		while(phones.moveToNext()) {											
			String name=phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));			
			name = name.toLowerCase();			
		     if(name.equals(username)) {			    	  
	    		matchID = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.CONTACT_ID));	    		
	    	    break;	       
	         }	         		     		    
		}				
	   phones.close();	   
	   return matchID;	   
}


public String GetDisplayName(String _contactID){
	
	   String matchName = "";	  
	   String userID = _contactID;;	   
	  	   
	   Cursor phones = controls.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	      							
	   while(phones.moveToNext()) {											
			 String contact_id=phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.CONTACT_ID));									
		     if(contact_id.equals(userID)) {			    	  
		    	 matchName = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));	    		
	    	    break;	       
	         }	         		     		    
	   }
		
	   phones.close();	   
	   return matchName;
}

/*
public String GetRawContactIDByContactID(String _contactID){
	
	   String raw_contact_id = "";	   
	   String userID = _contactID;;	   
	   
	   Cursor cur = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, null, null, null);

	   if ( (null == cur) || (!cur.moveToFirst()) ) return "";
	      							
	   while(cur.moveToNext()) {											
			String contact_id=cur.getString(cur.getColumnIndex(ContactsContract.Data.CONTACT_ID));									
		     if(contact_id.equals(userID)) {			    	  
	            raw_contact_id = cur.getString(cur.getColumnIndex(ContactsContract.Data.RAW_CONTACT_ID));
	    	    break;	       
	         }	         		     		    
	   }
	   
	   cur.close();	   
	   return raw_contact_id;
}
*/

private String GetRawContactID(String _displayName){
    
	   String raw_contact_id = "";
	   
	   String username = _displayName;;	   
	   username = username.toLowerCase(); 
	   
	   Cursor cur = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, null, null, null);

	   if ( (null == cur) || (!cur.moveToFirst()) ) return "";
	      							
	   while(cur.moveToNext()) {											
			String name=cur.getString(cur.getColumnIndex(ContactsContract.Data.DISPLAY_NAME));			
			name = name.toLowerCase();			
		     if(name.equals(username)) {			    	  
	            raw_contact_id = cur.getString(cur.getColumnIndex(ContactsContract.Data.RAW_CONTACT_ID));
	    	    break;	       
	         }	         		     		    
	    }	
		
		cur.close();	   
	    return raw_contact_id;	   
}

public void UpdateDisplayName(String _displayName, String _newDisplayName) {
	
    try {
        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
        
        String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?"; 
        String[] queryParams = new String[]{_displayName, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE};
        
        Builder builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
        builder.withSelection(queryWhere, queryParams);
        
        builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE);        
        builder.withValue(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME, _newDisplayName);
        
        ops.add(builder.build());	        
                	        	        
        try {
            controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
        }
        catch (Exception e) {
              e.printStackTrace();
        }        
    } catch (Exception e) {
        //	        
    }	
}

public void UpdateMobilePhoneNumber(String _displayName, String _newMobileNumber) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE)}; 

	        Cursor numberPhone = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        
	        //if not found Insert... 	        
	        if ( (null == numberPhone) || (!numberPhone.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newMobileNumber);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE);	            
	        }	        
	        else {	        	        	        
	          String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?"; 

	          String[] queryParams = new String[]{_displayName, 
	        		ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE)}; 	        	        	       
	          builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	          builder.withSelection(queryWhere, queryParams);
	        
	          builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	          builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE);	        
	          builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newMobileNumber);
	        }
	        
	        numberPhone.close();
	        ops.add(builder.build());	        
	                	        	        
	        try {
	          controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	        }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}



public void UpdateWorkPhoneNumber(String _displayName, String _newWorkNumber) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
	        	  
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_WORK)}; 

	        Cursor numberPhone = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        
	        //if not found Insert... 	        
	        if ( (null == numberPhone) || (!numberPhone.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newWorkNumber);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_WORK);	            
	        }	        
	        else {	        
	          String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?"; 

	          String[] queryParams = new String[]{_displayName, 
	        		ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_WORK)}; 	        	        	       
	          builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	          builder.withSelection(queryWhere, queryParams);
	        
	          builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	          builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_WORK);	        
	          builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newWorkNumber);
	        }
	        
	        numberPhone.close();	        
	        ops.add(builder.build());	        
	                	        	        
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	        }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}

public void UpdateHomePhoneNumber(String _displayName, String _newHomeNumber) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
	       	      
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_HOME)}; 

	        Cursor numberPhone = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        
	        // If not found Insert ... 	        
	        if ( (null == numberPhone) || (!numberPhone.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newHomeNumber);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_HOME);	            
	        }	        
	        else {	        
	           String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?"; 

	           String[] queryParams = new String[]{_displayName, 
	        		ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_HOME)}; 	        
	        	        
	           builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	           builder.withSelection(queryWhere, queryParams);
	        
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_HOME);	        
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newHomeNumber);
	        }	                
	        
	        numberPhone.close();
	        ops.add(builder.build());	        
	                	        	        
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	          }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}

public void UpdateHomeEmail(String _displayName, String _newHomeEmail) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE_HOME)}; 

	        Cursor emailCur = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        
	        //If not found Insert... 	        
	        if ( (null == emailCur) || (!emailCur.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Email.DATA, _newHomeEmail);
	           builder.withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_HOME);	            
	        }	        
	        else {
	        
	          String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE) + " = ?"; 

	          String[] queryParams = new String[]{_displayName, 
	                                             ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE,
	                                             String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE_HOME)}; 	        
	         	           
	          builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	          builder.withSelection(queryWhere, queryParams);	        
	        
	          builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE);
	          builder.withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_HOME);	        
	          builder.withValue(ContactsContract.CommonDataKinds.Email.DATA, _newHomeEmail);
	        }
	        
	        emailCur.close();
	        ops.add(builder.build());	        
	                	        	        
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	          }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}

public void UpdateWorkEmail(String _displayName, String _newWorkEmail) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();	        
	        
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE_HOME)}; 

	        Cursor emailCur = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        
	        //If not found Insert.... 	        
	        if ( (null == emailCur) || (!emailCur.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Email.DATA, _newWorkEmail);
	           builder.withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_HOME);	            
	        }	        
	        else {
	        String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE) + " = ?"; 

	        String[] queryParams = new String[]{_displayName, 
	                                             ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE,
	                                             String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE_WORK)}; 	        
	         	           
	        builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	        builder.withSelection(queryWhere, queryParams);	        
	        
	        builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE);
	        builder.withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_WORK);	        
	        builder.withValue(ContactsContract.CommonDataKinds.Email.DATA, _newWorkEmail);	        
	        }
	        
	        emailCur.close();
	        ops.add(builder.build());	        
	                	        	        
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	          }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}

public void UpdateOrganization(String _displayName, String _newCompany, String _newJobTitle) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Organization.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Organization.TYPE_WORK)}; 

	        Cursor orgCur = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        	        
	        // If not found Insert... 	        
	        if ( (null == orgCur) || (!orgCur.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Organization.DATA, _newCompany);
	           builder.withValue(ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK);
			   builder.withValue(ContactsContract.CommonDataKinds.Organization.TITLE, _newJobTitle);
			   builder.withValue(ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK);
	        }	        
	        else {	        	        
	          String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?"; 
	          String[] queryParams = new String[]{_displayName, ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE};	              
	        	        
	          builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	          builder.withSelection(queryWhere, queryParams);	        
	          builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE);
		      builder.withValue(ContactsContract.CommonDataKinds.Organization.COMPANY, _newCompany);
		      builder.withValue( ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK);
		      builder.withValue(ContactsContract.CommonDataKinds.Organization.TITLE, _newJobTitle);
		      builder.withValue(ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK);
	        }
	        
	        orgCur.close();
	        ops.add(builder.build());	        
	                	        	        
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	          }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}

public void UpdatePhoto(String _displayName, Bitmap _bitmapImage) {
	
  if(_bitmapImage!=null) {
	  
     ByteArrayOutputStream stream = new ByteArrayOutputStream();
     _bitmapImage.compress(Bitmap.CompressFormat.PNG , 75, stream);	
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();

	        Builder builder = null;
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String qwhere = RawContacts.Data._ID + "=?";
	        String[] qparam = new String[] {String.valueOf(raw_contact_id)};
	        	       	        	        	        	        
	        Cursor cursorPhoto = controls.activity.getContentResolver().query(RawContacts.CONTENT_URI, null,qwhere,qparam, null);	             
	        		                                                             	        		                                                            	               	        
	        //If not found Insert... 	        
	        if ( (null == cursorPhoto) || (!cursorPhoto.moveToFirst()) ) {	           
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
			   builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);			           			    	   			    	   				       
			   builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE);
			   builder.withValue(ContactsContract.CommonDataKinds.Photo.PHOTO,stream.toByteArray());			   
	        }	        
	        else {	        		      	        	  
	          Log.i("found update...", _displayName);	
	          String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?"; 
	          String[] queryParams = new String[]{_displayName, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE};			           			    	   			    	   				       	
		      builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
			  builder.withSelection(queryWhere, queryParams);
			  builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE);
			  builder.withValue(ContactsContract.CommonDataKinds.Photo.PHOTO,stream.toByteArray());
	        }	        	        	        	        
   		    ops.add(builder.build());
   		    
			try {
			   controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
			}
			catch (Exception e) {
			    e.printStackTrace();
		    }
			
			cursorPhoto.close();
			
			try {
			       stream.flush();
			}catch (IOException e) {
			       e.printStackTrace();
			}
			
	    } 
	    catch (Exception e) {
	        //	        
	    }
  }	 
}

public Bitmap GetPhoto(String _displayName){
	   
	   Bitmap photoImage= null;
	   String photoURI = null;	   
	   String username;	   
	   username = _displayName;	   
	   username = username.toLowerCase();
	   	          	   
	   Cursor phones = controls.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	   	    
	   while (phones.moveToNext()) {
	     String name = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));	     	     	     	    
	     name = name.toLowerCase();	     
	     if(name.equals(username)) {
	    	    photoURI = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_URI));
	    	    break;	    	   
	     }		    
	   }
	   	   
	   phones.close();	   
	   	   
	   if (photoURI != null) {		   	   
	     Uri imageUri =  Uri.parse(photoURI);
         InputStream imageStream;       
	     try {
		  imageStream = controls.activity.getContentResolver().openInputStream(imageUri);
		  photoImage = BitmapFactory.decodeStream(imageStream);
		 } catch (FileNotFoundException e) {
		  // TODO Auto-generated catch block
		   e.printStackTrace();
	     }
	   }	   	   
       return photoImage;       	  	 
}


public Bitmap GetPhotoByUriAsString(String _uriAsString){
	   
	Bitmap photoImage= null;
			   	   
	if (!_uriAsString.equals("")) {		   	   
	     Uri imageUri =  Uri.parse(_uriAsString);
         InputStream imageStream;       
	     try {
		  imageStream = controls.activity.getContentResolver().openInputStream(imageUri);
		  photoImage = BitmapFactory.decodeStream(imageStream);
		 } catch (FileNotFoundException e) {
		  // TODO Auto-generated catch block
		   e.printStackTrace();
	     }
	}	   	   
    return photoImage;       	  	 
}

//ref. http://android-contact-id-vs-raw-contact-id.blogspot.de/
public void DeleteContact(String _displayName) {
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();	        	        
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = RawContacts._ID + " = ?";	        
	        String[] params = new String[]{String.valueOf(raw_contact_id)};	        
	        builder = ContentProviderOperation.newDelete(RawContacts.CONTENT_URI);	        		        	        		          
			builder.withSelection(where,params);			           					
			
			ops.add(builder.build());	    
			
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	          }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }
}

/*TODO
//ref. http://stackoverflow.com/questions/27781285/how-to-delete-sim-card-contact-in-android
public void DeleteContactFromSIMCard(String _displayName) {
	
	String username = _displayName;
	username = username.toLowerCase();
	
	Log.i("username...", username);
	
	Uri simUri = Uri.parse("content://icc/adn/");
	
	ContentResolver mContentResolver = controls.activity.getContentResolver();
	
	Cursor c = mContentResolver.query(simUri, null, null, null, null);
	
	if (c.getCount() > 0) {		
		while ( c.moveToNext() ) {
		     String name = c.getString(c.getColumnIndex("name"));			     		     		     
		     name = name.toLowerCase();		     
		     Log.i("do...", name);
		     if(name.equals(username)) {
		    	 Log.i("equals...", name);		    	 		  		    	 		    	 
		    	 //String where = "tag=? AND number=?";
		    	 //String[] args = new String[] { c.getString(c.getColumnIndex("name")) ,  c.getString(c.getColumnIndex("number"))};		         		    	 
		    	 int i = mContentResolver.delete(
		                 simUri,
		                 "tag='" + c.getString(c.getColumnIndex("name")) +
		                 "' AND " +
		                 "number='" + c.getString(c.getColumnIndex("number")) + "'", null);		                		    	 
		    	 //int i = mContentResolver.delete(simUri,where,args);		        
		         Log.i("return"," i= "+ i);
			     break;	    	   
		     }
		}     
		    		
	}		   
	c.close();	 
}

*/
//ref. http://stackoverflow.com/questions/10412634/fetch-local-phonebook-contacts-from-sim-card-only-android/10412757#10412757
public String[] GetContactsFromSIMCard(String _delimiter) {
	
	ArrayList<String> list = new ArrayList<String>();
	
    try
    {
        String  simPhonename = null; 
        String  simphoneNo = null;

        Uri simUri = Uri.parse("content://icc/adn"); 
        Cursor cursorSim = controls.activity.getContentResolver().query(simUri,null,null,null,null);

        //Log.i("PhoneContact", "total: "+cursorSim.getCount());
        if (cursorSim.getCount() > 0) {        
           while (cursorSim.moveToNext()) {      
        	   simPhonename = cursorSim.getString(cursorSim.getColumnIndex("name"));
        	   simphoneNo = cursorSim.getString(cursorSim.getColumnIndex("number"));
        	   simphoneNo.replaceAll("\\D","");
        	   simphoneNo.replaceAll("&", "");
               simPhonename=simPhonename.replace("|","");
               //Log.i("PhoneContact", "name: "+simPhonename+" phone: "+simphoneNo);               
               list.add(simPhonename+ _delimiter + simphoneNo);
           }  
       }         
       cursorSim.close();
    }
    catch(Exception e) {
        e.printStackTrace();
    }
    
    return list.toArray(new String[list.size()]);
}

public void AddContact(String _displayName, String _mobileNumber, String _homeNumber, String _workNumber, 
		               String _homeEmail, String _workEmail, String _companyName, String _jobTitle, Bitmap _bitmapImage) {

		 String displayName = _displayName;		 		 
		 if (displayName.equals(""))  displayName = "New Contact";
		
		 String homeNumber = _homeNumber;
		 if (homeNumber.equals(""))  homeNumber =  "000000000000";
		 
		 String mobileNumber = _mobileNumber;
		 if (mobileNumber.equals(""))  mobileNumber = "000000000000";
		  
		 String workNumber = _workNumber;
		 if (workNumber.equals(""))  workNumber = "000000000000";
		 
		 String homeEmail = _homeEmail;
		 if (homeEmail.equals(""))  homeEmail = "email@home";
		 
		 String workEmail = _workEmail;
		 if (workEmail.equals(""))  workEmail = "email@work";
		 
		 String company = _companyName;
		 if (company.equals(""))  company = "Company Name";
		 
		 String jobTitle = _jobTitle;
		 if (jobTitle.equals(""))  jobTitle = "Job Title";
		 
		 Context ctx = controls.activity;

		 ArrayList<ContentProviderOperation> contentProviderOperation = new ArrayList<ContentProviderOperation>();

		 int rawContactID = contentProviderOperation.size();

		    // Adding insert operation to operations list 
		    // to insert a new raw contact in the table ContactsContract.RawContacts
		 contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.RawContacts.CONTENT_URI)
		   .withValue(ContactsContract.RawContacts.ACCOUNT_TYPE, null)
		   .withValue(ContactsContract.RawContacts.ACCOUNT_NAME, null)
		   .build());

		 // ------------------------------------------------------ Names
	     // Adding insert operation to operations list
	     // to insert display name in the table ContactsContract.Data
		 
		  contentProviderOperation.add(ContentProviderOperation
		    .newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME, displayName)
		    .build());
		  
		 // ------------------------------------------------------ Mobile Number
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Phone.NUMBER, mobileNumber)
		    .withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE)
		    .build());
		  
		 // ------------------------------------------------------ Home Numbers		  
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Phone.NUMBER, homeNumber)
		    .withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_HOME)
		    .build());
		 
		 // ------------------------------------------------------ Work Numbers		  
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Phone.NUMBER, workNumber)
		    .withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_WORK)
		    .build());		 
		 
		 // ------------------------------------------------------ homeEmail
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference( ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue( ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Email.DATA, homeEmail)
		    .withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_HOME)
		    .build());
		  
			 // ------------------------------------------------------ workEmail		  
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Email.DATA, workEmail)
		    .withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_WORK)
		    .build());		  
		 
		 // ------------------------------------------------------ Organization
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Organization.COMPANY, company)
		    .withValue( ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK)
		    .withValue(ContactsContract.CommonDataKinds.Organization.TITLE, jobTitle)
		    .withValue(ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK)
		    .build());		 		 
		  
		 //------------------------------------------------------------------ photo
	     if(_bitmapImage!=null) { 
	    	    ByteArrayOutputStream stream = new ByteArrayOutputStream();
	    	    _bitmapImage.compress(Bitmap.CompressFormat.PNG,75,stream);
	    	   
	           // Adding insert operation to operations list
	           // to insert Photo in the table ContactsContract.Data
	    	   contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
	                .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
	                .withValue(ContactsContract.Data.IS_SUPER_PRIMARY, 1)
	                .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE)
	                .withValue(ContactsContract.CommonDataKinds.Photo.PHOTO,stream.toByteArray())
	                .build());
	           try {
	               stream.flush();
	           }catch (IOException e) {
	               e.printStackTrace();
	           }
	       }
	      
		 // Asking the Contact provider to create a new contact
		 try {
		    ctx.getContentResolver().applyBatch(ContactsContract.AUTHORITY, contentProviderOperation);
		 } catch (Exception e) {
		  e.printStackTrace();
		     //show exception in toast
		     //Toast.makeText(ctx, "Exception: " + e.getMessage(), Toast.LENGTH_SHORT).show();
		 }
}

public void AddContact(String _displayName, String _mobileNumber) {

	String displayName = _displayName;		 		 	
	if (displayName.equals(""))  displayName = "New Contact";

	String mobileNumber = _mobileNumber;
	if (mobileNumber.equals(""))  mobileNumber = "000000000000";

	Context ctx = controls.activity;

	ArrayList<ContentProviderOperation> contentProviderOperation = new ArrayList<ContentProviderOperation>();

	int rawContactID = contentProviderOperation.size();

// Adding insert operation to operations list 
// to insert a new raw contact in the table ContactsContract.RawContacts
	contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.RawContacts.CONTENT_URI)
			.withValue(ContactsContract.RawContacts.ACCOUNT_TYPE, null)
			.withValue(ContactsContract.RawContacts.ACCOUNT_NAME, null)	
			.build());

// ------------------------------------------------------ Names
// Adding insert operation to operations list
// to insert display name in the table ContactsContract.Data

	contentProviderOperation.add(ContentProviderOperation
			.newInsert(ContactsContract.Data.CONTENT_URI)
			.withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
			.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE)
			.withValue(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME, displayName)
			.build());

// ------------------------------------------------------ Mobile Number
	contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
			.withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
			.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE)
			.withValue(ContactsContract.CommonDataKinds.Phone.NUMBER, mobileNumber)
			.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE)
			.build());

    //Asking the Contact provider to create a new contact
	try {
		ctx.getContentResolver().applyBatch(ContactsContract.AUTHORITY, contentProviderOperation);
	} catch (Exception e) {
		e.printStackTrace();
    }
}

public void GetContactsAsync(String _delimiter) {
	new ATask().execute(_delimiter);
}
                             //param, progr, result  
class ATask extends AsyncTask<String, String, String[]> {
	   
	//ArrayList<String> list = new ArrayList<String>();
	boolean mListing = true;
	int mCount = 0;
	String _delimiter = null;
	//String mName = "";
	Bitmap mPhoto = null;
	String photoURI = null;	   
	
    @Override
    protected String[] doInBackground(String... message) {
    	
       _delimiter = message[0];   	   	
   	   String line = "";
       
   	   ContentResolver cr = controls.activity.getContentResolver();       
       Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI,null, null, null, null);
                         	              	                         	   
       if (cur.getCount() > 0) {
    	   while (cur.moveToNext() && mListing) {
 	          if (Integer.parseInt(cur.getString(cur.getColumnIndex(ContactsContract.Contacts.HAS_PHONE_NUMBER))) > 0) {    	        	
    	            String id = cur.getString(cur.getColumnIndex(ContactsContract.Contacts._ID));    	                	        	                	            
    	            String name = cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));    	            
    	            line = name + _delimiter;
    	            
    	            // get the phone number
    	            Cursor pCur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,null,
    	                                       ContactsContract.CommonDataKinds.Phone.CONTACT_ID +" = ?",
    	                                       new String[]{id}, null);
    	            while (pCur.moveToNext()) {
    	                      String phone = pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
    	                      String phoneType = pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
    	                    //1:home 2:mobile 3:Work 
    	                      if (phoneType.equals("1"))  
    	                    	  line = line + phone +" [Home]"+ _delimiter;
    	                      else if (phoneType.equals("3"))  
    	                    	  line = line + phone +" [Work]"+ _delimiter;
    	                      else line = line + phone + _delimiter;    	                          	                                             	                     
    	            }
    	            pCur.close();
    	               
    	            // get email and type
    	            Cursor emailCur = cr.query(ContactsContract.CommonDataKinds.Email.CONTENT_URI,null, 
    	            		                   ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = ?",
    	                                        new String[]{id}, null);
    	               
    	            while (emailCur.moveToNext()) {
    	                    // This would allow you get several email addresses
    	                    // if the email addresses were stored in an array
    	                    String email = emailCur.getString(
    	                                  emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));
    	                    
    	                    String emailType = emailCur.getString(
    	                                  emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.TYPE));
                                  	                    
    	                    line = line + email + _delimiter;
    	            }
    	            emailCur.close();

    	            //Get note.......
    	            //Get Postal Address....
    	            //Get Organizations.........
    	            String orgWhere = ContactsContract.Data.CONTACT_ID + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?";
    	            String[] orgWhereParams = new String[]{id,ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE};
    	            Cursor orgCur = cr.query(ContactsContract.Data.CONTENT_URI, null, orgWhere, orgWhereParams, null);
    	            if (orgCur.moveToFirst()) {
    	                    String orgName = orgCur.getString(orgCur.getColumnIndex(ContactsContract.CommonDataKinds.Organization.DATA));
    	                    String title = orgCur.getString(orgCur.getColumnIndex(ContactsContract.CommonDataKinds.Organization.TITLE));
    	                    //System.out.println("orgName " + orgName + " Job title : " + title);
    	                    line = line + orgName + _delimiter + title + _delimiter;
    	            }
    	            
    	            orgCur.close();           	                	            
    	            
    	            //list.add(line);    	            
    	            //line = line + id + _delimiter;    	   
    	            
    	            //Get photo Uri
    	            Cursor phCur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,null,
                                            ContactsContract.CommonDataKinds.Phone.CONTACT_ID +" = ?",
                                            new String[]{id}, null);
    	            
    	            photoURI = null;
    	            if (phCur.moveToFirst()) {    	                 
    	               photoURI = phCur.getString(phCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_URI));   
    	         	   if (photoURI == null) {
    	         		  photoURI = ":)";
    	               }	       	                   	         	   
    	            }
    	            
    	            phCur.close();   
    	            
    	            line = line + photoURI;
    	            
    	            publishProgress(line);    	            
    	      }    	            	     
    	   }       
    	   cur.close();    	             	   
       }    	       	       	    
       return  null; //list.toArray(new String[list.size()]);
    }

    @Override
    protected void onProgressUpdate(String... contact) {    	   
        super.onProgressUpdate(contact[0]);
        
        StringTokenizer stToken = new StringTokenizer(contact[0], _delimiter);                                
        int count = stToken.countTokens();
        final String[] splitStr = new String[count];
        int index = 0;
        while(stToken.hasMoreElements()) {        	
           splitStr[index] = stToken.nextToken();                     
           index = index + 1;
        }
        
        String contactInfo = splitStr[0] ;         
        for (int i=1; i < count-1 ; i++) {
        	contactInfo = contactInfo + _delimiter + splitStr[i];
        }		
                         	
        mPhoto = null;
        
        if (! splitStr[count-1].equals(":)") ) {        	
          mPhoto = GetPhotoByUriAsString(splitStr[count-1]); 
        }
        
        String shortInfo = splitStr[0] + _delimiter + splitStr[1];
                     
        mCount = mCount + 1;
        mListing = controls.pOnContactManagerContactsProgress(pascalObj, contactInfo , shortInfo, splitStr[count-1], mPhoto, mCount);
    }
    
    @Override
    protected void onPostExecute(String[] contactsResult) {    	  
      super.onPostExecute(contactsResult);           
      controls.pOnContactManagerContactsExecuted(pascalObj, mCount);
    }      
    
}
  
public String GetContactInfo(String _displayName, String _delimiter) {
	   
	  //ArrayList<String> list = new ArrayList<String>();
	  boolean mListing = true;
	  int mCount = 0;
	
	  //String mName = "";
	  Bitmap mPhoto = null;
	  String photoURI = null;
	  
	   String username = _displayName;;	   
	   username = username.toLowerCase(); 
	
       
   	   String line = "";
       
   	   ContentResolver cr = controls.activity.getContentResolver();       
       Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI,null, null, null, null);
                                          
       if (cur.getCount() > 0) {    	       	   
    	   while(cur.moveToNext()) {											
    		 String name=cur.getString(cur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));			
    		 String name1 = name.toLowerCase();			
    		 if(name1.equals(username)) {    		    	     		     
 	            if (Integer.parseInt(cur.getString(cur.getColumnIndex(ContactsContract.Contacts.HAS_PHONE_NUMBER))) > 0) {    	        	
    	            String id = cur.getString(cur.getColumnIndex(ContactsContract.Contacts._ID));    	                	        	                	            
    	            //String name = cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));    	            
    	            line = name + _delimiter;;    	                	             	                       	               
    	            // get the phone number
    	            Cursor pCur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,null,
    	                                       ContactsContract.CommonDataKinds.Phone.CONTACT_ID +" = ?",
    	                                       new String[]{id}, null);
    	            while (pCur.moveToNext()) {
    	                      String phone = pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
    	                      String phoneType = pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
    	                    //1:home 2:mobile 3:Work 
    	                      if (phoneType.equals("1"))  
    	                    	  line = line + phone +" [Home]"+ _delimiter;
    	                      else if (phoneType.equals("3"))  
    	                    	  line = line + phone +" [Work]"+ _delimiter;
    	                      else line = line + phone + _delimiter;    	                          	                                             	                     
    	            }
    	            pCur.close();
    	               
    	            // get email and type
    	            Cursor emailCur = cr.query(ContactsContract.CommonDataKinds.Email.CONTENT_URI,null, 
    	            		                   ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = ?",
    	                                        new String[]{id}, null);
    	               
    	            while (emailCur.moveToNext()) {
    	                    // This would allow you get several email addresses
    	                    // if the email addresses were stored in an array
    	                    String email = emailCur.getString(
    	                                  emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));
    	                    
    	                    String emailType = emailCur.getString(
    	                                  emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.TYPE));
                                  	                    
    	                    line = line + email + _delimiter;
    	            }
    	            emailCur.close();

    	            //Get note.......
    	            //Get Postal Address....
    	            //Get Organizations.........
    	            String orgWhere = ContactsContract.Data.CONTACT_ID + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?";
    	            String[] orgWhereParams = new String[]{id,ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE};
    	            Cursor orgCur = cr.query(ContactsContract.Data.CONTENT_URI, null, orgWhere, orgWhereParams, null);
    	            if (orgCur.moveToFirst()) {
    	                    String orgName = orgCur.getString(orgCur.getColumnIndex(ContactsContract.CommonDataKinds.Organization.DATA));
    	                    String title = orgCur.getString(orgCur.getColumnIndex(ContactsContract.CommonDataKinds.Organization.TITLE));
    	                    //System.out.println("orgName " + orgName + " Job title : " + title);
    	                    line = line + orgName + _delimiter + title + _delimiter;
    	            }
    	            
    	            orgCur.close();           	                	            
    	            
    	            //list.add(line);    	            
    	            line = line + id + _delimiter;    	   
    	            
    	            //Get photo Uri
    	            Cursor phCur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,null,
                                            ContactsContract.CommonDataKinds.Phone.CONTACT_ID +" = ?",
                                            new String[]{id}, null);
    	            
    	            photoURI = null;
    	            if (phCur.moveToFirst()) {    	                 
    	               photoURI = phCur.getString(phCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_URI));   
    	         	   if (photoURI == null) {
    	         		  photoURI = ":)";
    	               }	       	                   	         	   
    	            }
    	            
    	            phCur.close();   
    	            
    	            line = line + photoURI;    	            
    	        }
 	            break; 
    		 } 
    	   }       
    	   cur.close();    	             	   
    }
    return line;   
}


}


/*Draft java code by "Lazarus Android Module Wizard" [7/8/2015 22:55:27]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/
 
class jSeekBar extends SeekBar /*dummy*/ { //please, fix what GUI object will be extended!
  
  private long       pascalObj = 0;    // Pascal Object
  private Controls   controls  = null; // Control Class for events
  
  private Context context = null;
  private ViewGroup parent   = null;         // parent view
  private RelativeLayout.LayoutParams lparams;              // layout XYWH 
  private OnClickListener onClickListener;   // click event
  
  private OnSeekBarChangeListener onSeekBarChangeListener;
  
  private Boolean enabled  = true;           // click-touch enabled!
  private int lparamsAnchorRule[] = new int[30];
  private int countAnchorRule = 0;
  private int lparamsParentRule[] = new int[30];
  private int countParentRule = 0;
  private int lparamH = 100;
  private int lparamW = 100;
  private int marginLeft = 0;
  private int marginTop = 0;
  private int marginRight = 0;
  private int marginBottom = 0;
  private boolean mRemovedFromParent = false;
  
  int mProgress = 0;
 
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...    
  public jSeekBar(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
     super(_ctrls.activity);
     context   = _ctrls.activity;
     pascalObj = _Self;
     controls  = _ctrls;
  
     lparams = new RelativeLayout.LayoutParams(lparamW, lparamH);
  
     onClickListener = new OnClickListener(){
     /*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!
             if (enabled) {
                //controls.pOnClick(pascalObj, Const.Click_Default); //JNI event onClick!
             }
          };
     };
     
     setOnClickListener(onClickListener);
     
     onSeekBarChangeListener = new OnSeekBarChangeListener() {                 
         @Override
         /*.*/public void onProgressChanged(SeekBar seekBar, int progresValue, boolean fromUser) {
        	 mProgress = progresValue;
             controls.pOnSeekBarProgressChanged(pascalObj, mProgress, fromUser); 
         }        
         
         @Override
         /*.*/public void onStartTrackingTouch(SeekBar seekBar) {
        	  controls.pOnSeekBarStartTrackingTouch(pascalObj, seekBar.getProgress());
         }

         @Override
         /*.*/public void onStopTrackingTouch(SeekBar seekBar) {
        	 controls.pOnSeekBarStopTrackingTouch(pascalObj, seekBar.getProgress());   
         }
     };

     setOnSeekBarChangeListener(onSeekBarChangeListener);
  } //end constructor
 
  public void jFree() {
     if (parent != null) { parent.removeView(this); }
     //free local objects...
     lparams = null;
     setOnClickListener(null);
  }
 
  public void SetViewParent(ViewGroup _viewgroup) {
     if (parent != null) { parent.removeView(this); }
     parent = _viewgroup;
     parent.addView(this,lparams);
     mRemovedFromParent = false;
  }
  
  public void RemoveFromViewParent() {
     if (!mRemovedFromParent) {
        this.setVisibility(android.view.View.INVISIBLE);
        if (parent != null)
   	       parent.removeView(this);
	   mRemovedFromParent = true;
	}
  }
 
  public View GetView() {
     return this;
  }
 
  public void SetLParamWidth(int _w) {
     lparamW = _w;
  }
 
  public void SetLParamHeight(int _h) {
     lparamH = _h;
  }
 
  public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
     marginLeft = _left;
     marginTop = _top;
     marginRight = _right;
     marginBottom = _bottom;
     lparamH = _h;
     lparamW = _w;
  }
 
  public void AddLParamsAnchorRule(int _rule) {
     lparamsAnchorRule[countAnchorRule] = _rule;
     countAnchorRule = countAnchorRule + 1;
  }
 
  public void AddLParamsParentRule(int _rule) {
     lparamsParentRule[countParentRule] = _rule;
     countParentRule = countParentRule + 1;
  }
 
  public void SetLayoutAll(int _idAnchor) {
 	lparams.width  = lparamW;
	lparams.height = lparamH;
	lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
	if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
		lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	}
     for (int j=0; j < countParentRule; j++) {
        lparams.addRule(lparamsParentRule[j]);
     }
     this.setLayoutParams(lparams);
  }
 
  public void ClearLayoutAll() {
	for (int i=0; i < countAnchorRule; i++) {
 	   lparams.removeRule(lparamsAnchorRule[i]);
   	}
 
	for (int j=0; j < countParentRule; j++) {
  	   lparams.removeRule(lparamsParentRule[j]);
	}
	countAnchorRule = 0;
	countParentRule = 0;
  }

  public void SetId(int _id) { //wrapper method pattern ...
     this.setId(_id);
  }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
  public void SetMax(int _maxProgress) {
     this.setMax(_maxProgress);
  }

  public void SetProgress(int _progress) {
	 if (_progress <  this.getMax())   
	    this.setProgress(_progress);	 	 
  }
  
  public int GetProgress() {		   
		return this.getProgress();  
  }
  
  public void SetRotation(float _rotation) {  //  API level 11 270 = vertical
      this.setRotation(_rotation);
  }
  
   
} //end class

//**new jComponent class entrypoint**//please, do not remove/change this line!

//Javas/Pascal Interface Class 

public class Controls {          // <<--------- 
//
public Activity        activity;  // Activity
public RelativeLayout  appLayout; // Base Layout
public int screenStyle=0;         // Screen Style [Dev:0 , Portrait: 1, Landscape : 2]

// Jave -> Pascal Function ( Pascal Side = Event )
public  native int  pAppOnScreenStyle(); 
public  native void pAppOnCreate     (Context context,RelativeLayout layout);
public  native void pAppOnNewIntent  ();    
public  native void pAppOnDestroy    ();    
public  native void pAppOnPause      ();   
public  native void pAppOnRestart    ();    
public  native void pAppOnResume     (); 
public  native void pAppOnStart      ();   //change by jmpessoa : old OnActive
public  native void pAppOnStop       (); 
public  native void pAppOnBackPressed(); 
public  native int  pAppOnRotate     (int rotate); 
public  native void pAppOnConfigurationChanged(); 
public  native void pAppOnActivityResult(int requestCode,int resultCode,Intent data); 

//by jmpessoa: support Option Menu
public  native void pAppOnCreateOptionsMenu(Menu menu);
public  native void pAppOnClickOptionMenuItem(MenuItem menuItem,int itemID,String itemCaption,boolean checked);
public native boolean pAppOnPrepareOptionsMenu(Menu menu, int menuSize);
public native boolean pAppOnPrepareOptionsMenuItem(Menu menu, MenuItem menuItem, int itemIndex);

//by jmpessoa: support Context Menu
public  native void pAppOnCreateContextMenu(ContextMenu menu);
public  native void pAppOnClickContextMenuItem(MenuItem menuItem,int itemID,String itemCaption,boolean checked);

public  native void pOnClick     (long pasobj, int value);

public  native void pOnChange    (long pasobj, String txt, int count);
public  native void pOnChanged   (long pasobj, String txt, int count);
public  native void pOnEnter     (long pasobj);                    

public  native void pOnTimer     (long pasobj);

public  native void pOnDraw      (long pasobj, Canvas canvas);

public  native void pOnTouch     (long pasobj, int act, int cnt,float x1, float y1,float x2, float y2);
public  native void pOnGLRenderer(long pasobj, int EventType, int w, int h);

public  native void pOnClose     (long pasobj);    

public  native int  pOnWebViewStatus (long pasobj, int EventType, String url);
public  native boolean pOnAsyncEventDoInBackground(long pasobj, int progress);
public  native int  pOnAsyncEventProgressUpdate(long pasobj, int progress);
public  native int  pOnAsyncEventPreExecute(long pasobj);
public  native void pOnAsyncEventPostExecute(long pasobj, int progress);

//new by jmpessoa: support for jListView custom row
public  native void pOnClickWidgetItem(long pasobj, int position, boolean checked); 
public  native void pOnClickCaptionItem(long pasobj, int position, String caption);
public  native void pOnListViewLongClickCaptionItem(long pasobj, int position, String caption);
public  native int pOnListViewDrawItemCaptionColor(long pasobj, int position, String caption);
public  native Bitmap pOnListViewDrawItemBitmap(long pasobj, int position, String caption);

//new by jmpessoa: support for Bluetooth
public  native void pOnBluetoothEnabled(long pasobj);
public  native void pOnBluetoothDisabled(long pasobj);
public  native void pOnBluetoothDeviceFound(long pasobj,String deviceName,String deviceAddress);
public  native void pOnBluetoothDiscoveryStarted(long pasobj);
public  native void pOnBluetoothDiscoveryFinished(long pasobj,int countFoundedDevices,int countPairedDevices);
public  native void pOnBluetoothDeviceBondStateChanged(long pasobj, int state, String deviceName, String deviceAddress);

public  native void pOnBluetoothClientSocketConnected(long pasobj, String deviceName, String deviceAddress);
public  native void pOnBluetoothClientSocketIncomingData(long pasobj, byte[] byteArrayContent, byte[] byteArrayHeader);
public  native void pOnBluetoothClientSocketDisconnected(long pasobj);

public  native boolean pOnBluetoothServerSocketConnected(long pasobj, String deviceName, String deviceAddress);
public  native boolean pOnBluetoothServerSocketIncomingData(long pasobj, byte[] byteArrayContent, byte[] byteArrayHeader);

public  native void pOnBluetoothServerSocketListen(long pasobj, String serverName, String strUUID);
public native void pOnBluetoothServerSocketAcceptTimeout(long pasobj);

public  native void pOnSpinnerItemSeleceted(long pasobj, int position, String caption);
//gps - location
public  native void pOnLocationChanged(long pasobj, double latitude,  double longitude, double altitude, String address);
public  native void pOnLocationStatusChanged(long pasobj, int status, String provider, String msgStatus);
public  native void pOnLocationProviderEnabled(long pasobj, String provider);
public  native void pOnLocationProviderDisabled(long pasobj, String provider);

public  native void pAppOnViewClick(View view, int id);
public  native void pAppOnListItemClick(AdapterView adapter, View view, int position, int id);

public native void pOnActionBarTabSelected(long pasobj, View view, String title);
public native void pOnActionBarTabUnSelected(long pasobj, View view, String title);
public native void pOnCustomDialogShow(long pasobj, Dialog dialog, String title);

public native void pOnCustomDialogBackKeyPressed(long pasobj, String title);

public native void pOnClickToggleButton(long pasobj, boolean state);
public native void pOnChangeSwitchButton(long pasobj, boolean state);

public native void pOnClickGridItem(long pasobj, int position, String caption);
public native void pOnLongClickGridItem(long pasobj, int position, String caption);
public  native int pOnGridDrawItemCaptionColor(long pasobj, int position, String caption);
public  native Bitmap pOnGridDrawItemBitmap(long pasobj, int position, String caption);
 
public native void pOnChangedSensor(long pasobj, Sensor sensor, int sensorType, float[] values, long timestamp);
public native void pOnListeningSensor(long pasobj, Sensor sensor, int sensorType);

public native void pOnUnregisterListeningSensor(long pasobj, int sensorType, String sensorName);
public native void pOnBroadcastReceiver(long pasobj, Intent intent);

public native void pOnTimePicker(long pasobj, int hourOfDay, int minute);
public native void pOnDatePicker(long pasobj, int year, int monthOfYear, int dayOfMonth);

public native void pOnFlingGestureDetected(long pasobj, int direction);
public native void pOnPinchZoomGestureDetected(long pasobj, float scaleFactor, int state); 

public native void pOnShellCommandExecuted(long pasobj, String cmdResult);

public native void pOnTCPSocketClientMessageReceived(long pasobj, String[] messagesReceived);
public native void pOnTCPSocketClientConnected(long pasobj);

public native void pOnHttpClientContentResult(long pasobj, String content);
public native void pOnHttpClientCodeResult(long pasobj, int code);
public native void pOnSurfaceViewCreated(long pasobj, SurfaceHolder surfaceHolder);
public native void pOnSurfaceViewDraw(long pasobj, Canvas canvas);
public native void pOnSurfaceViewChanged(long pasobj, int width, int height);

public native void pOnMediaPlayerPrepared(long pasobj, int videoWidth, int videoHeigh);
public native void pOnMediaPlayerVideoSizeChanged(long pasobj, int videoWidth, int videoHeight);
public native void pOnMediaPlayerCompletion(long pasobj);
public native void pOnMediaPlayerTimedText(long pasobj, String timedText);

public native void pOnSurfaceViewTouch(long pasobj, int act, int cnt,float x1, float y1,float x2, float y2);
                       
public native boolean pOnSurfaceViewDrawingInBackground(long pasobj, float progress);
public native void pOnSurfaceViewDrawingPostExecute(long pasobj, float progress);

public native void pOnContactManagerContactsExecuted(long pasobj,  int count);
public native boolean pOnContactManagerContactsProgress(long pasobj, String contactInfo, String contactShortInfo, String contactPhotoUriAsString, Bitmap contactPhoto, int progress);

public native void pOnSeekBarProgressChanged(long pasobj,  int progress, boolean fromUser); 
public native void pOnSeekBarStartTrackingTouch(long pasobj, int progress);
public native void pOnSeekBarStopTrackingTouch(long pasobj, int progress);


//Load Pascal Library
static {
    //Log.i("JNI_Load_LibControls", "1. try load libcontrols.so");

	
    try {
    	System.loadLibrary("freetype"); // need by TFPNoGUIGraphicsBridge [ref. www.github.com/jmpessoa/tfpnoguigraphicsbridge]
    } catch (UnsatisfiedLinkError e) {
         Log.e("JNI_Load_LibFreetype", "exception", e);
    }
    
	
    try {
    	System.loadLibrary("controls");
    } catch (UnsatisfiedLinkError e) {
         Log.e("JNI_Load_LibControls", "exception", e);
    }

    //Log.i("JNI_Load_LibControls", "2.load libcontrols.so OK!");  
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

//By jmpessoa: support Option Menu
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

//By jmpessoa: supportContextMenu
public  void jAppOnCreateContextMenu(ContextMenu m) {pAppOnCreateContextMenu(m);}
public  void jAppOnClickContextMenuItem(MenuItem item,int itemID, String itemCaption, boolean checked) {pAppOnClickContextMenuItem(item,itemID,itemCaption,checked);}

public void jAppOnViewClick(View view, int id){ pAppOnViewClick(view,id);}
public void jAppOnListItemClick(AdapterView adapter, View view, int position, int id){ pAppOnListItemClick(adapter, view,position,id);}

//// -------------------------------------------------------------------------
//  System, Class
// -------------------------------------------------------------------------

//
public  void systemGC() {
   System.gc();
}

//
public  void systemSetOrientation(int orientation) {
   this.activity.setRequestedOrientation(orientation);
}

//by jmpessoa
public  int  systemGetOrientation() {  
   return (this.activity.getResources().getConfiguration().orientation); 
}

//
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

//
public  void appKillProcess() {
//  android.os.Process.killProcess(android.os.Process.myPid());
   this.activity.finish();
 //my comm: ActivityManager am = (ActivityManager)activity.getSystemService(activity.ACTIVITY_SERVICE);
 //my com: am.restartPackage(activity.getPackageName());
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
//  Animation Related
//
//   android.view.animation.AlphaAnimation
//   android.view.animation.RotateAnimation
//   android.view.animation.ScaleAnimation
//   android.view.animation.TranslateAnimation
//
//   android.view.animation.AnimationSet
//
//   Ref.
//    http://sripatim.wordpress.com/2011/03/18/viewflipper-on-button-click-in-android/
//    http://stackoverflow.com/questions/7432375/how-to-animate-an-adding-of-a-view-in-android
//    http://stackoverflow.com/questions/10909865/setanimation-vs-startanimation-in-android
//    http://stackoverflow.com/questions/10695022/how-remove-view-in-android
//
//    AnimationUtils.loadAnimation(controls.activity, R.anim.slide_right_in);
// -------------------------------------------------------------------------

public  Animation Ani_iR2L(int duration) {
  Animation iR2L = new TranslateAnimation(
    Animation.RELATIVE_TO_PARENT,  1.0f, Animation.RELATIVE_TO_PARENT,  0.0f,
    Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,  0.0f);
    iR2L.setDuration(duration);
    iR2L.setInterpolator(new AccelerateInterpolator());
    iR2L.setStartOffset(0);
    return iR2L; }

public  Animation Ani_oR2L(int duration) {
  Animation oR2L = new TranslateAnimation(
    Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT, -1.0f,
    Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,  0.0f);
    oR2L.setDuration(duration);
    oR2L.setInterpolator(new AccelerateInterpolator());
    oR2L.setStartOffset(0);
    return oR2L;  }

public  Animation Ani_iL2R(int duration) {
  Animation iL2R = new TranslateAnimation(
    Animation.RELATIVE_TO_PARENT, -1.0f, Animation.RELATIVE_TO_PARENT,  0.0f,
    Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,  0.0f);
    iL2R.setDuration(duration);
    iL2R.setInterpolator(new AccelerateInterpolator());
    iL2R.setStartOffset(0);
    return iL2R;   }

public  Animation Ani_oL2R(int duration) {
  Animation oL2R = new TranslateAnimation(
    Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,  1.0f,
    Animation.RELATIVE_TO_PARENT,  0.0f, Animation.RELATIVE_TO_PARENT,  0.0f);
    oL2R.setDuration(duration);
    oL2R.setInterpolator(new AccelerateInterpolator());
    oL2R.setStartOffset(0);
    return oL2R;   }

public  Animation Ani_FadeIn(int duration) {
  Animation Alpha = new AlphaAnimation(0f,1f);
    Alpha.setDuration(duration);
    Alpha.setStartOffset(0);
    Alpha.setFillAfter (false);
    Alpha.setFillBefore(false);
    return Alpha;   }

public  Animation Ani_FadeOut(int duration) {
  Animation Alpha = new AlphaAnimation(1f,0f);
    Alpha.setDuration(duration);
    Alpha.setStartOffset(0);
    Alpha.setFillAfter (false);
    Alpha.setFillBefore(false);
    return Alpha;   
}

// https://coderwall.com/p/jpijag
public  AnimationSet Ani_iR2LFadeIn(int duration) {
  AnimationSet aniset = new AnimationSet(true);
  aniset.addAnimation(Ani_iR2L  (duration));
  aniset.addAnimation(Ani_FadeIn(duration));
  aniset.setFillAfter(true);
  return aniset;
}

public  AnimationSet Ani_Effect(int effect, int duration) {
  //
  AnimationSet aset = new AnimationSet(true);
  if ((effect & Const.Eft_iR2L   ) == Const.Eft_iR2L   ) { aset.addAnimation(Ani_iR2L   (duration)); };
  if ((effect & Const.Eft_iL2R   ) == Const.Eft_iL2R   ) { aset.addAnimation(Ani_iL2R   (duration)); };
  if ((effect & Const.Eft_oR2L   ) == Const.Eft_oR2L   ) { aset.addAnimation(Ani_oR2L   (duration)); };
  if ((effect & Const.Eft_oL2R   ) == Const.Eft_oL2R   ) { aset.addAnimation(Ani_oL2R   (duration)); };
  if ((effect & Const.Eft_FadeIn ) == Const.Eft_FadeIn ) { aset.addAnimation(Ani_FadeIn (duration)); };
  if ((effect & Const.Eft_FadeOut) == Const.Eft_FadeOut) { aset.addAnimation(Ani_FadeOut(duration)); };
  aset.setFillAfter(true);
  return aset;
}

// -------------------------------------------------------------------------
//  View Related - Generic! --> AndroidWidget.pas
// -------------------------------------------------------------------------

//
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

//----------------------------------------------
// Controls Version Info
//-------------------------------------------

/*LORDMAN - 2013-07-30
public  String getStrDateTime() { 
  SimpleDateFormat formatter = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss", Locale.KOREA );
  return( formatter.format ( new Date () ) );
}
*/

//GetControlsVersionFeatures ...  //Controls.java version-revision info! [0.6-04]
public  String getStrDateTime() {  //hacked by jmpessoa!! sorry, was for a good cause! please, use the  jForm_GetDateTime!!
  String listVersionInfo = "6$4=GetControlsVersionInfo;" +
  		   "6$4=getLocale;";  
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

//by jmpessoa:  Class controls version info
public String GetControlsVersionInfo() { 
  return "6$5";  //version$revision  [0.6$5]
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
  //http://developer.android.com/reference/android/os/Build.html
  String version = Build.VERSION.RELEASE;
  //Log.i("JAVA:",version);
  //
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
  //Log.i("JNI_Java", "wh:" + Integer.toString(options.outWidth ) +
  //                    "x" + Integer.toString(options.outHeight) );
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

//
public  void Image_save(Bitmap bmp, String filename) {
  try { FileOutputStream out = new FileOutputStream(filename);
        bmp.compress(Bitmap.CompressFormat.PNG, 100, out); }
  catch (Exception e)
      { e.printStackTrace(); }
}

// -------------------------------------------------------------------------
//  TextView: Create
// -------------------------------------------------------------------------
public  java.lang.Object jTextView_Create(long pasobj) {
  return (java.lang.Object)( new jTextView(this.activity,this,pasobj));
}

//-------------------------------------------------------------------------
//EditText: Create
//-------------------------------------------------------------------------
public  java.lang.Object jEditText_Create(long pasobj ) {
   return (java.lang.Object)( new jEditText(this.activity,this,pasobj));
}

// -------------------------------------------------------------------------
//  Button: Create
// -------------------------------------------------------------------------
public  java.lang.Object jButton_Create(long pasobj ) {
   return (java.lang.Object)( new jButton(this.activity,this,pasobj));
}

// -------------------------------------------------------------------------
//  CheckBox: Create
// -------------------------------------------------------------------------
public  java.lang.Object jCheckBox_Create(long pasobj ) {
   return (java.lang.Object)( new jCheckBox(this.activity,this,pasobj));
}

// -------------------------------------------------------------------------
//  RadioButton: Create
// -------------------------------------------------------------------------
public  java.lang.Object jRadioButton_Create(long pasobj ) {
   return (java.lang.Object)( new jRadioButton(this.activity,this,pasobj));
}

// -------------------------------------------------------------------------
//  ProgressBar: Create
// -------------------------------------------------------------------------
public  java.lang.Object jProgressBar_Create(long pasobj, int style ) {
  return (java.lang.Object)( new jProgressBar(this.activity,this,pasobj,style));
}

// -------------------------------------------------------------------------
//  ImageView: Create
// -------------------------------------------------------------------------
public  java.lang.Object jImageView_Create(long pasobj ) {
  return (java.lang.Object)( new jImageView(this.activity,this,pasobj));
}

// -------------------------------------------------------------------------
//  ListView: Create
// -------------------------------------------------------------------------
public  java.lang.Object jListView_Create2(long pasobj,  int widget, String widgetTxt, Bitmap bmp, 
		int txtDecorated, int itemLay, int textSizeDecorated, int textAlign) {
   return (java.lang.Object)(new jListView(this.activity,this,pasobj,widget,widgetTxt,bmp,
		   txtDecorated,itemLay,textSizeDecorated, textAlign));
}

public  java.lang.Object jListView_Create3(long pasobj,  int widget, String widgetTxt,
		int txtDecorated, int itemLay, int textSizeDecorated, int textAlign) {
	   return (java.lang.Object)(new jListView(this.activity,this,pasobj,widget,widgetTxt, null,
			   txtDecorated,itemLay,textSizeDecorated, textAlign));
}

// -------------------------------------------------------------------------
//  ScrollView: Create
// -------------------------------------------------------------------------
public  java.lang.Object jScrollView_Create(long pasobj ) {
   return (java.lang.Object)( new jScrollView(this.activity,this,pasobj));
}

//-------------------------------------------------------------------------
//HorizontalScrollView: Create
//-------------------------------------------------------------------------
public  java.lang.Object jHorizontalScrollView_Create(long pasobj ) {
	return (java.lang.Object)( new jHorizontalScrollView(this.activity,this,pasobj));
}
//-------------------------------------------------------------------------
//Panel: Create - new by jmpessoa
//-------------------------------------------------------------------------
public  java.lang.Object jPanel_Create(long pasobj ) {
   return (java.lang.Object)(new jPanel(this.activity,this,pasobj));
}
// -------------------------------------------------------------------------
//  ViewFlipper
// -------------------------------------------------------------------------

public  java.lang.Object jViewFlipper_Create(long pasobj ) {
   return (java.lang.Object)( new jViewFlipper(this.activity,this,pasobj));
}


// -------------------------------------------------------------------------
//  WebView
// -------------------------------------------------------------------------
public  java.lang.Object jWebView_Create(long pasobj ) {
  return (java.lang.Object)( new jWebView(this.activity,this,pasobj));
}

// -------------------------------------------------------------------------
//  Canvas : canvas + paint
// -------------------------------------------------------------------------

public  java.lang.Object jCanvas_Create( long pasobj) {
  return (java.lang.Object)( new jCanvas(this,pasobj));
}

// -------------------------------------------------------------------------
//  Bitmap
// -------------------------------------------------------------------------

public  java.lang.Object jBitmap_Create( long pasobj ) {
  return (java.lang.Object)( new jBitmap(this,pasobj));
}

// -------------------------------------------------------------------------
//  View
// -------------------------------------------------------------------------
//by jmpessoa
public  java.lang.Object jView_Create(long pasobj ) {
  return (java.lang.Object)( new jView(this.activity,this,pasobj));
}

// -------------------------------------------------------------------------
//  GLView
// -------------------------------------------------------------------------

public  java.lang.Object jGLSurfaceView_Create(long pasobj, int version ) {
  return (java.lang.Object)( new jGLSurfaceView(this.activity,this,pasobj,version));
}
// -------------------------------------------------------------------------
//  Timer
// -------------------------------------------------------------------------
public  java.lang.Object jTimer_Create(long pasobj) {
  return (jTimer)(new jTimer(this,pasobj) );
}
// -------------------------------------------------------------------------
//  Dialog YN
// -------------------------------------------------------------------------

//jDialogYN DialogYNSav;
Object DialogYNSav;

public  java.lang.Object jDialogYN_Create(long pasobj,
                                          String title, String msg, String y, String n ) {
  return (jDialogYN)(new jDialogYN(activity,this,pasobj,title,msg,y,n) );
  //DialogYNSav = (jDialogYN)(new jDialogYN(activity,this,pasobj,title,msg,y,n) );
  //return DialogYNSav;
}

// -------------------------------------------------------------------------
//  Dialog Progress
// -------------------------------------------------------------------------

public  java.lang.Object jDialogProgress_Create(long pasobj,
                                               String title, String msg) {
  return (jDialogProgress)(new jDialogProgress(activity,this,pasobj,title,msg ) );
}

// -------------------------------------------------------------------------
//  Toast
// -------------------------------------------------------------------------

//
public  void jToast( String str ) {
   Toast.makeText(activity, str, Toast.LENGTH_SHORT).show();
}

// -------------------------------------------------------------------------
//  jImageBtn
// -------------------------------------------------------------------------

//by jmpessoa
public  java.lang.Object jImageBtn_Create(long pasobj ) {
	return (java.lang.Object)( new jImageBtn(this.activity,this,pasobj));
}

// -------------------------------------------------------------------------
//  jAsyncTask
// -------------------------------------------------------------------------

public  java.lang.Object jAsyncTask_Create(long pasobj ) {
  return (java.lang.Object)( new jAsyncTask(this,pasobj));
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
	//int rst;
	
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
		Log.i("Java","Send Email Error");
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
		  //Log.i("Send_SMS Fail",e.toString());
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
        //Log.i("Read_SMS", str);
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
	   //String content;
	
	   Cursor phones = this.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	
	   while (phones.moveToNext())
	   {
	     String name=phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));
	     //String phoneNumber = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
	     String phoneType = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
	     //content = name +":"+ phoneNumber +":" + phoneType;
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
	
	  //Environment.getExternalStorageDirectory()
	  //Environment.getExternalStorageDirectory().getAbsoluteFile()
	  
 	  Uri mImageCaptureUri = Uri.fromFile(new File(path, '/'+filename)); // get Android.Uri from file
	  
	  intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, mImageCaptureUri);
	  intent.putExtra("return-data", true);
	  
	  this.activity.startActivityForResult(intent, 12345); //12345 = requestCode
	    
	  return (path+'/'+filename);	  
}

public String jCamera_takePhoto(String path, String filename, int requestCode) {
	  Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
	
	  //Environment.getExternalStorageDirectory()
	  //Environment.getExternalStorageDirectory().getAbsoluteFile()
	  
	  Uri mImageCaptureUri = Uri.fromFile(new File(path, '/'+filename)); // get Android.Uri from file
	  
	  intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, mImageCaptureUri);
	  intent.putExtra("return-data", true);
	  
	  this.activity.startActivityForResult(intent, requestCode); //12345 = requestCode
	    
	  return (path+'/'+filename);	  
}

// -------------------------------------------------------------------------
//  BenchMark [Java/Pascal]
// -------------------------------------------------------------------------

public float[] benchMark1 () {
  long start_time;
  long end_time;
  start_time = System.currentTimeMillis();
  //
  float value = 30;
  int i = 0;
  for ( i = 0; i < 100000000; i++) {
    value = value * 2/ 3 + 5 - 1;
  };
  end_time = System.currentTimeMillis();
  Log.e("BenchMark1","Java : " + (end_time - start_time) + ", result" + value);
  //
  float[] vals = new float[2];
  vals[0] = end_time - start_time;
  vals[1] = value;
  return ( vals );
}

//-------------------------------------------------------------------------------------------------------
//NEWS by jmpessoa
//-------------------------------------------------------------------------------------------------------

   public  java.lang.Object jSqliteCursor_Create( long pasobj ) {
	 return (java.lang.Object)( new jSqliteCursor(this,pasobj) );
   }

   public  java.lang.Object jSqliteDataAccess_Create(long pasobj, String databaseName, char colDelim, char rowDelim) {
	 return (java.lang.Object)( new jSqliteDataAccess(this,pasobj,databaseName,colDelim,rowDelim) );
   }
   
   public java.lang.Object jMyHello_jCreate(long _Self, int _flag, String _hello) {
      return (java.lang.Object)(new jMyHello(this,_Self,_flag,_hello));
   }
  
   public java.lang.Object jMediaPlayer_jCreate(long _Self) {
      return (java.lang.Object)(new jMediaPlayer(this,_Self));
   }
                           
   public java.lang.Object jDumpJavaMethods_jCreate(long _Self, String _fullJavaClassName) {	   
      return (java.lang.Object)(new jDumpJavaMethods(this,_Self,_fullJavaClassName));
   }
  
   public java.lang.Object jTextFileManager_jCreate(long _Self) {
      return (java.lang.Object)(new jTextFileManager(this,_Self));
   }
  
   public java.lang.Object jMenu_jCreate(long _Self) {
      return (java.lang.Object)(new jMenu(this,_Self));
   }
  
   public java.lang.Object jBluetooth_jCreate(long _Self) {
      return (java.lang.Object)(new jBluetooth(this,_Self));
   }
  
   public java.lang.Object jBluetoothServerSocket_jCreate(long _Self) {
      return (java.lang.Object)(new jBluetoothServerSocket(this,_Self));
   }
    
   public java.lang.Object jBluetoothClientSocket_jCreate(long _Self) {
      return (java.lang.Object)(new jBluetoothClientSocket(this,_Self));
   }
   
   public java.lang.Object jSpinner_jCreate(long _Self) {
	      return (java.lang.Object)(new jSpinner(this,_Self));
   }    

   public java.lang.Object jLocation_jCreate(long _Self, long _TimeForUpdates, long _DistanceForUpdates, int _CriteriaAccuracy, int _MapType) {
      return (java.lang.Object)(new jLocation(this,_Self,_TimeForUpdates,_DistanceForUpdates,_CriteriaAccuracy, _MapType));
   }

   public java.lang.Object jPreferences_jCreate(long _Self, boolean _IsShared) {
      return (java.lang.Object)(new jPreferences(this,_Self,_IsShared));
   }
  
   public java.lang.Object jShareFile_jCreate(long _Self) {
      return (java.lang.Object)(new jShareFile(this,_Self));
   }
  
   public java.lang.Object jImageFileManager_jCreate(long _Self) {
      return (java.lang.Object)(new jImageFileManager(this,_Self));
   }
  
   public java.lang.Object jContextMenu_jCreate(long _Self) {
      return (java.lang.Object)(new jContextMenu(this,_Self));
   }
  
   public java.lang.Object jActionBarTab_jCreate(long _Self) {
      return (java.lang.Object)(new jActionBarTab(this,_Self));
   }
  
   public java.lang.Object jCustomDialog_jCreate(long _Self) {
      return (java.lang.Object)(new jCustomDialog(this,_Self));
   }
  
  
   public java.lang.Object jToggleButton_jCreate(long _Self) {
      return (java.lang.Object)(new jToggleButton(this,_Self));
   }
  
   public java.lang.Object jSwitchButton_jCreate(long _Self) {
      return (java.lang.Object)(new jSwitchButton(this,_Self));
   }
  
  
   public java.lang.Object jGridView_jCreate(long _Self) {
      return (java.lang.Object)(new jGridView(this,_Self));      
   }
   
   public java.lang.Object jSensorManager_jCreate(long _Self) {
	      return (java.lang.Object)(new jSensorManager(this,_Self));
   }      
   
   public java.lang.Object jBroadcastReceiver_jCreate(long _Self) {
	      return (java.lang.Object)(new jBroadcastReceiver(this,_Self));
   }   
   
   public java.lang.Object jIntentManager_jCreate(long _Self) {
	      return (java.lang.Object)(new jIntentManager(this,_Self));
	   }      
  
   public java.lang.Object jNotificationManager_jCreate(long _Self) {
	      return (java.lang.Object)(new jNotificationManager(this,_Self));
   }   
   
   public java.lang.Object jTimePickerDialog_jCreate(long _Self) {
	      return (java.lang.Object)(new jTimePickerDialog(this,_Self));
   }
   
   public java.lang.Object jDatePickerDialog_jCreate(long _Self) {
	      return (java.lang.Object)(new jDatePickerDialog(this,_Self));
   }
   
   public java.lang.Object jHttpClient_jCreate(long _Self) {
	      return (java.lang.Object)(new jHttpClient(this,_Self));
   }
  
   public java.lang.Object jShellCommand_jCreate(long _Self) {
	      return (java.lang.Object)(new jShellCommand(this,_Self));
   }
   
   public java.lang.Object jAnalogClock_jCreate(long _Self) {
	      return (java.lang.Object)(new jAnalogClock(this,_Self));
   }   
   
   public java.lang.Object jDigitalClock_jCreate(long _Self) {
	      return (java.lang.Object)(new jDigitalClock(this,_Self));
   }
   
   public java.lang.Object jTCPSocketClient_jCreate(long _Self) {
	      return (java.lang.Object)(new jTCPSocketClient(this,_Self));
   }
   
   public java.lang.Object jSurfaceView_jCreate(long _Self) {
	      return (java.lang.Object)(new jSurfaceView(this,_Self));
   }
   
   public java.lang.Object jContactManager_jCreate(long _Self) {
	      return (java.lang.Object)(new jContactManager(this,_Self));
   }   
   
   public java.lang.Object jSeekBar_jCreate(long _Self) {
	      return (java.lang.Object)(new jSeekBar(this,_Self));
   }
   
}
