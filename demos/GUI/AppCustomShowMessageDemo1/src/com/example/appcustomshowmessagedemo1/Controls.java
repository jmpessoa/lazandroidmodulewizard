package com.example.appcustomshowmessagedemo1;

//LAMW: Lazarus Android Module Wizard - version 0.8.6.1 [AndroidX!!] - 11 November - 2020 
//RAD Android: Project Wizard, Form Designer and Components Development Model!

//https://github.com/jmpessoa/lazandroidmodulewizard
//http://forum.lazarus.freepascal.org/index.php/topic,21919.270.html

//Android Java Interface for LAZARUS [december/2013 by jmpessoa]

//Developers:
//          Simon,Choi / Choi,Won-sik
//                       simonsayz@naver.com
//                       http://blog.naver.com/simonsayz
//
//         LoadMan    / Jang,Yang-Ho
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

import android.provider.DocumentsContract;
import android.provider.Settings.Secure;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.animation.LayoutTransition;
import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.app.Activity;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.PackageInfo;
import android.content.res.AssetManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.content.ContentResolver;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.SurfaceTexture;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.Matrix;
import android.hardware.Sensor;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Environment;
import android.os.Vibrator;
import android.telephony.SmsManager;
import android.telephony.SmsMessage;
import android.telephony.TelephonyManager;
import android.provider.ContactsContract;
import android.provider.MediaStore;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.net.ConnectivityManager;
import android.net.DhcpInfo;
import android.net.NetworkInfo;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.util.Log;
import android.view.ContextMenu;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SurfaceHolder;
import android.view.View.OnClickListener;
import android.view.ViewGroup.MarginLayoutParams;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.TranslateAnimation;
import android.view.inputmethod.InputMethodManager;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.RemoteViews;
import android.widget.RelativeLayout;
import android.widget.Toast;
import java.io.*;
import java.lang.Class;
import java.nio.ByteBuffer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;

import java.util.List;
import java.util.Locale;
import java.lang.reflect.*;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.lang.Object;

//need by GDXGme framework...
import javax.microedition.khronos.opengles.GL10;
import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.egl.EGLSurface;

import android.provider.Settings;
import android.provider.Settings.SettingNotFoundException;
import android.app.KeyguardManager;
import android.os.PowerManager;
import android.os.BatteryManager;
import android.content.IntentFilter;
import android.media.MediaScannerConnection;
import java.text.Normalizer;

import java.net.URL;
import java.net.URLConnection;
import java.net.MalformedURLException;
import java.io.BufferedReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import java.text.ParseException;
import java.text.DateFormat;
import java.util.Calendar; 

//import android.os.StrictMode; //by Guser979 [try fix "jCamera_takePhoto"

//-------------------------------------------------------------------------
//Constants
//-------------------------------------------------------------------------
class Const {
  public static final int TouchDown                   =  0;
  public static final int TouchMove                   =  1;
  public static final int TouchUp                     =  2;
  public static final int Click                 	  =  3; // new
  public static final int DoubleClick                 =  4;  // new
  public static final int Click_Default               =  0;
}

//-------------------------------------------------------------------------
//Form
//-------------------------------------------------------------------------
class jForm {
	//Java-Pascal Interface
	private long PasObj = 0;     // Pascal Obj
	private Controls controls = null;   // Control Class for Event
	private RelativeLayout layout = null;
	private LayoutParams layparam = null;
	private RelativeLayout parent = null;   //activity appLayout
	private OnClickListener onClickListener;   // event
	private OnClickListener onViewClickListener;   // generic delegate event
	private OnItemClickListener onListItemClickListener;
	private Boolean enabled = true;   //
	private Intent intent;
	private int mCountTab = 0;
	private ImageView mImageBackground = null;

	private boolean mRemovedFromParent = false;

	private int animationDurationIn = 1500;
	private int animationDurationOut = 1500;
	private int animationMode = 0; //none, fade, LeftToRight, RightToLeft

	public Toast mCustomToast = null;

	// Constructor
	public jForm(Controls ctrls, long pasobj) {
		PasObj = pasobj;
		controls = ctrls;
		parent = controls.appLayout;

		layout = new RelativeLayout(controls.activity);

		if (layout == null) return;

		layparam = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
				ViewGroup.LayoutParams.MATCH_PARENT);
		layout.setLayoutParams(layparam);

		// Init Event
		onClickListener = new OnClickListener() {
			public void onClick(View view) {
				if (enabled) {
					controls.pOnClick(PasObj, Const.Click_Default);
				}
			}

			;
		};

		//geric list item click Event - experimental component model!
		onListItemClickListener = new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View v, int position, long id) {
				controls.jAppOnListItemClick(parent, v, position, v.getId());
			}
		};

		//Init Event
		onViewClickListener = new OnClickListener() {
			public void onClick(View view) {
				if (enabled) {
					controls.jAppOnViewClick(view, view.getId());
				}
			}

			;
		};

		layout.setOnClickListener(onClickListener);

		// To ensure that the image is always in the background by ADiV
		mImageBackground = new ImageView(controls.activity);

		if (mImageBackground != null) {
			mImageBackground.setScaleType(ImageView.ScaleType.FIT_XY);

			LayoutParams param = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);

			mImageBackground.setLayoutParams(param);
			mImageBackground.setImageResource(android.R.color.transparent);

			//mImageBackground.invalidate();
			layout.addView(mImageBackground);
		}
	}

	public void FormChangeSize() {
		controls.formChangeSize = true;
		controls.appLayout.requestLayout();
	}

	public RelativeLayout GetLayout() {
		return layout;
	}

	public RelativeLayout GetView() {
		return layout;
	}

	public void SetEnabled(boolean enabled) {
		for (int i = 0; i < layout.getChildCount(); i++) {
			View child = layout.getChildAt(i);
			child.setEnabled(enabled);
		}
	}

	public void SetLayoutVisibility(boolean _value) {
		if (!_value) {
			layout.setVisibility(android.view.View.INVISIBLE);
		} else {
			layout.setVisibility(android.view.View.VISIBLE);
		}
	}

	public void SetVisible(boolean visible) {
		if (visible) {
			if (layout.getParent() == null) {
				parent.addView(layout);
				layout.setVisibility(android.view.View.VISIBLE);
				mRemovedFromParent = false;
			}
		} else {
			if (layout.getParent() != null) {
				layout.setVisibility(android.view.View.INVISIBLE);
				parent.removeView(layout);
				mRemovedFromParent = true;
			}
		}
	}

	public void RemoveFromViewParent() {   //TODO Pascal
		if (!mRemovedFromParent) {
			if (layout != null) {
				layout.setVisibility(android.view.View.INVISIBLE);
				if (parent != null) parent.removeView(layout);
			}
			mRemovedFromParent = true;
		}
	}

	public void SetViewParent(android.view.ViewGroup _viewgroup) {
		if ((parent != null) && (layout != null)) {
			parent.removeView(layout);
		}
		parent = (RelativeLayout) _viewgroup;
		if ((parent != null) && (layout != null)) {
			parent.addView(layout, layparam);
			layout.setVisibility(android.view.View.VISIBLE);
		}
		mRemovedFromParent = false;
	}


	public void SetAnimationDurationIn(int _animationDurationIn) {
		animationDurationIn = _animationDurationIn;
	}

	public void SetAnimationDurationOut(int _animationDurationOut) {
		animationDurationOut = _animationDurationOut;
	}

	public void SetAnimationMode(int _animationMode) {
		animationMode = _animationMode;
	}

	/// https://www.codexpedia.com/android/android-fade-in-and-fade-out-animation-programatically/
	private void fadeInAnimation(final View view, int duration) {
		Animation fadeIn = new AlphaAnimation(0, 1);
		fadeIn.setInterpolator(new DecelerateInterpolator());
		fadeIn.setDuration(duration);
		fadeIn.setAnimationListener(new Animation.AnimationListener() {
			@Override
			public void onAnimationStart(Animation animation) {
			}

			@Override
			public void onAnimationEnd(Animation animation) {
				view.setVisibility(View.VISIBLE);
			}

			@Override
			public void onAnimationRepeat(Animation animation) {
			}
		});

		view.startAnimation(fadeIn);
	}

	private void fadeOutAnimation(final View view, int duration) {
		Animation fadeOut = new AlphaAnimation(1, 0);
		fadeOut.setInterpolator(new AccelerateInterpolator());
		fadeOut.setStartOffset(duration);
		fadeOut.setDuration(duration);
		fadeOut.setAnimationListener(new Animation.AnimationListener() {
			@Override
			public void onAnimationStart(Animation animation) {
			}

			@Override
			public void onAnimationEnd(Animation animation) {
				view.setVisibility(View.INVISIBLE);
			}

			@Override
			public void onAnimationRepeat(Animation animation) {
			}
		});
		view.startAnimation(fadeOut);
	}

	//https://stackoverflow.com/questions/20696801/how-to-make-a-right-to-left-animation-in-a-layout/20696822
	private void slidefromRightToLeft(View view, long duration) {
		TranslateAnimation animate;
		if (view.getHeight() == 0) {
			//parent.getHeight(); // parent layout
			animate = new TranslateAnimation(parent.getWidth(),
					0, 0, 0); //(xFrom,xTo, yFrom,yTo)
		} else {
			animate = new TranslateAnimation(view.getWidth(), 0, 0, 0); // View for animation
		}
		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}

	private void slidefromLeftToRight(View view, long duration) {  //try

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		if (view.getHeight() == 0) {
			//parent.getHeight(); // parent layout
			animate = new TranslateAnimation(0,
					parent.getWidth(), 0, 0); //(xFrom,xTo, yFrom,yTo)
		} else {
			animate = new TranslateAnimation(0, view.getWidth(), 0, 0); // View for animation
		}

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}


	private void slidefromRightToLeft3(View view, long duration) {
		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		if (view.getHeight() == 0) {
			//parent.getHeight(); // parent layout
			animate = new TranslateAnimation(0, -parent.getWidth(),
					0, 0); //(xFrom,xTo, yFrom,yTo)
		} else {
			animate = new TranslateAnimation(0, -parent.getWidth(),
					0, 0); // View for animation
		}

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}

	private void slidefromLeftToRight3(View view, long duration) {  //try

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		if (view.getHeight() == 0) {
			//parent.getHeight(); // parent layout
			animate = new TranslateAnimation(-parent.getWidth(),
					0, 0, 0); //(xFrom,xTo, yFrom,yTo)
		} else {
			animate = new TranslateAnimation(-parent.getWidth(), 0, 0, 0); // View for animation
		}

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}


	public void Show(int effect) {

		//fadeOutAnimation(layout, 2000);
		//fadeInAnimation(layout, 2000);

		if (animationDurationIn > 0) {
			switch (animationMode) {
				case 1: {
					fadeInAnimation(layout, animationDurationIn);
					break;
				}
				case 2: {  //RightToLeft
					slidefromRightToLeft(layout, animationDurationIn);
					break;
				}
				case 3: {  //RightToLeft
					slidefromLeftToRight3(layout, animationDurationIn);
					break;
				}
			}
		}

		//controls.appLayout.addView(layout);
		//parent = controls.appLayout;
		parent.addView(layout);

	}

	public ViewGroup GetParent() {
		return parent; //parent;
	}

	public void Close(int effect) {
		controls.pOnClose(PasObj);
	}

	public void Close2() {
		//fadeOutAnimation(layout, 2000);
		// slidefromLeftToRight(layout, 2000);
		if (animationDurationOut > 0) {
			switch (animationMode) {
				case 1: {
					fadeOutAnimation(layout, animationDurationOut);
					break;
				}
				case 2: {
					slidefromLeftToRight(layout, animationDurationOut);
					break;
				}
				case 3: {
					slidefromRightToLeft3(layout, animationDurationOut);
					break;
				}
			}
		}
		parent.removeView(layout);
		controls.pOnClose(PasObj);
	}

	//by ADiV
	public boolean IsScreenLocked() {
		KeyguardManager myKM = (KeyguardManager) controls.activity.getSystemService(Context.KEYGUARD_SERVICE);

		if (myKM == null) return false;

		return myKM.inKeyguardRestrictedInputMode();
	}

	//by ADiV
	public boolean IsSleepMode() {
		PowerManager powerManager = (PowerManager) controls.activity.getSystemService(Context.POWER_SERVICE);

		if (powerManager == null) return false;

		boolean isScreenAwake = (Build.VERSION.SDK_INT < 20 ? powerManager.isScreenOn() : powerManager.isInteractive());

		return !isScreenAwake;
	}

	public boolean IsConnected() { //by ADiV

		ConnectivityManager cm = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);

		if (cm != null) {
			NetworkInfo activeNetwork = cm.getActiveNetworkInfo();

			if (activeNetwork != null)
				return (activeNetwork.isAvailable() && activeNetwork.isConnected());
		}

		return false;
	}

	public boolean IsConnectedWifi() { // by ADiV

		ConnectivityManager cm = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);

		if (cm != null) {
			NetworkInfo activeNetwork = cm.getActiveNetworkInfo();

			if (activeNetwork != null)
				return (activeNetwork.getType() == ConnectivityManager.TYPE_WIFI);
		}

		return false;
	}

	public boolean IsConnectedTo(int _connectionType) { // by ADiV

		ConnectivityManager cm = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);

		if (cm != null) {
			NetworkInfo activeNetwork = cm.getActiveNetworkInfo();

			int result = -1;

			if (activeNetwork != null)
				if (activeNetwork.isAvailable() && activeNetwork.isConnected()) ;
			{
				switch (activeNetwork.getType()) {
					case ConnectivityManager.TYPE_MOBILE:
						result = 0;
						break; //0
					case ConnectivityManager.TYPE_WIFI:
						result = 1;
						break; //1
					case ConnectivityManager.TYPE_BLUETOOTH:
						result = 2;
						break; //7
					case ConnectivityManager.TYPE_ETHERNET:
						result = 3;
						break; //9
				}
			}

			return (result == _connectionType);
		}

		return false;
	}

	public void ShowMessage(String msg) {
		Log.i("ShowMessage", msg);
		Toast toast = Toast.makeText(controls.activity, msg, Toast.LENGTH_SHORT);

		if (toast != null) {
			//toast.setGravity(Gravity.BOTTOM, 0, 0);
			toast.show();
		}
	}

	public void ShowMessage(String _msg, int _gravity, int _timeLength) {
		Log.i("ShowMessage", _msg);

		Toast toast = Toast.makeText(controls.activity, _msg, _timeLength);

		int posGravity = Gravity.BOTTOM;

		switch (_gravity) {
			case 1:
				posGravity = Gravity.CENTER;
				break;
			case 8:
				posGravity = Gravity.TOP;
				break;
		}

		if (toast != null) {
			toast.setGravity(posGravity, 0, 0);
			toast.show();
		}
	}

	public String GetDateTime() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault());
		return (formatter.format(new Date()));
	}
	
	// by ADiV
	public String GetDateTime(long millisDateTime) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return (formatter.format(millisDateTime));
	}
	
	// by ADiV
	public long GetTimeInMilliseconds(){
		return controls.getTick();
	}

	//by ADiV
	public String GetTimeHHssSS( long millisTime ) {
		  SimpleDateFormat formatter = new SimpleDateFormat ( "mm:ss:SS" );
		  return( formatter.format ( new Date (millisTime) ) );	
	}
	
	//by ADiV
	public long GetDateTimeToMillis( String _dateTime, boolean _zone ){
		String     sPattern  = "yyyy-MM-dd HH:mm:ss";
	    
	    long offset = 0;
	    
	    if(_zone){
	     Calendar calendar = Calendar.getInstance(Locale.getDefault());
	     
	     if( calendar != null )
	      offset = -(calendar.get(Calendar.ZONE_OFFSET) + calendar.get(Calendar.DST_OFFSET));// / (60 * 1000);
	    }
	    
	    DateFormat formatter = new SimpleDateFormat(sPattern);
	        
	    if( formatter == null ) return 0;
			
		long lnsTime = 0;
		
	    try{
	    
	     Date dateObject = formatter.parse(_dateTime);

	     if( dateObject != null )
	      lnsTime = dateObject.getTime();
	    
	    }catch (java.text.ParseException e){        
	            e.printStackTrace();            
	    }
	    
	    return (lnsTime - offset);
	}

	//Free object except Self, Pascal Code Free the class.
	public void Free() {
		if (parent != null) {
			parent.removeView(layout);
		}
		onClickListener = null;
		layout.setOnClickListener(null);
		layparam = null;
		layout = null;
	}

	//http://startandroid.ru/en/lessons/complete-list/250-lesson-29-invoking-activity-and-getting-a-result-startactivityforresult-method.html
	public String GetStringExtra(Intent data, String extraName) {
		String valueStr;
		valueStr = "";
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

	public OnClickListener GetOnViewClickListener() {
		return this.onViewClickListener;
	}

	public OnItemClickListener GetOnListItemClickListener() {
		return this.onListItemClickListener;
	}

	public int GetSystemVersion() {
		return controls.systemVersion;
	}

	public boolean SetWifiEnabled(boolean _status) {
		//WifiManager wifiManager = (WifiManager)this.controls.activity.getSystemService(Context.WIFI_SERVICE);
		WifiManager wifiManager = (WifiManager) this.controls.activity.getApplicationContext().getSystemService(Context.WIFI_SERVICE);

		return wifiManager.setWifiEnabled(_status);
	}

	public boolean IsWifiEnabled() {
		//WifiManager wifiManager = (WifiManager)this.controls.activity.getSystemService(Context.WIFI_SERVICE);
		WifiManager wifiManager = (WifiManager) this.controls.activity.getApplicationContext().getSystemService(Context.WIFI_SERVICE);

		return wifiManager.isWifiEnabled();
	}

	public boolean IsMobileDataEnabled() {
		boolean mobileDataEnabled = false; // Assume disabled
		ConnectivityManager cm = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
		try {
			final Class<?> cmClass = Class.forName(cm.getClass().getName());
			Method method = cmClass.getDeclaredMethod("getMobileDataEnabled");
			method.setAccessible(true); // Make the method callable
			// get the setting for "mobile data"
			mobileDataEnabled = (Boolean) method.invoke(cm);
		} catch (Exception e) {
			// Some problem accessible private API
			// TODO do whatever error handling you want here
		}
		return mobileDataEnabled;
	}

	public String GetEnvironmentDirectoryPath(int _directory) {

		File filePath = null;
		String absPath = "";   //fail!

		//Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);break; //only Api 19!
		if (_directory != 8) {
			switch (_directory) {
				case 0:
					filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
					break;
				case 1:
					filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM);
					break;
				case 2:
					filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC);
					break;
				case 3:
					filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
					break;
				case 4:
					filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_NOTIFICATIONS);
					break;
				case 5:
					filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES);
					break;
				case 6:
					filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PODCASTS);
					break;
				case 7:
					filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RINGTONES);
					break;

				case 9:
					absPath = this.controls.activity.getFilesDir().getAbsolutePath();
					break;      //Result : /data/data/com/MyApp/files
				case 10:
					absPath = this.controls.activity.getFilesDir().getPath();
					absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/databases";
					break;
				case 11:
					absPath = this.controls.activity.getFilesDir().getPath();
					absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/shared_prefs";
					break;

				case 12:
					absPath = this.controls.activity.getFilesDir().getPath();
					absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/cache";
					break;

			}

			//Make sure the directory exists.
			if (_directory < 8) {
				filePath.mkdirs();
				absPath = filePath.getPath();
			}

		} else {  //== 8
			if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) == true) {
				filePath = Environment.getExternalStorageDirectory();  //sdcard!
				// Make sure the directory exists.
				filePath.mkdirs();
				absPath = filePath.getPath();
			}
		}

		return absPath;
	}
	
	public String GetInternalAppStoragePath() { //GetAbsoluteDirectoryPath
		String PathDat = this.controls.activity.getFilesDir().getAbsolutePath();       //Result : /data/data/com/MyApp/files
		return PathDat;
	}

    //checks if external storage is available for read and write
    public boolean IsExternalStorageReadWriteAvailable() {
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state)) {
            return true;
        }
        return false;
    }

    //checks if external storage is available for read
    public boolean IsExternalStorageReadable() {
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED_READ_ONLY.equals(state)) {
            return true;
        }
        return false;
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
			if (input != null) input.close();
			if (output != null) output.close();
		}
	}

	public boolean CopyFile(String _scrFullFileName, String _destFullFileName) {
		File src = new File(_scrFullFileName);
		File dest = new File(_destFullFileName);
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
	public String LoadFromAssets(String _filename) {

		String pathRes = "";

		InputStream is = null;
		FileOutputStream fos = null;
		String PathDat = controls.activity.getFilesDir().getAbsolutePath();
		try {
			File outfile = new File(PathDat, _filename);

			fos = new FileOutputStream(outfile);  //save to data/data/your_package/files/your_file_name										
			is = controls.activity.getAssets().open(_filename);
			int size = is.available();
			byte[] buffer = new byte[size];

			for (int c = is.read(buffer); c != -1; c = is.read(buffer)) {
				fos.write(buffer, 0, c);
			}

			is.close();
			fos.close();
			pathRes = PathDat + "/" + _filename;

		} catch (IOException e) {
			e.printStackTrace();
		}

		return pathRes;
	}

	public boolean IsSdCardMounted() {
		return Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED);
	}

	public void DeleteFile(String _fileFull) {
		   File file = new File(_fileFull);
		   
		   if( file.isFile() )
		    file.delete();
	}

	public void DeleteFile(String _fullPath, String _filename) {
		File file;
		if (_fullPath.equalsIgnoreCase("")) {
			file = new File(Environment.getExternalStorageDirectory() + "/" + _filename); // root
		} else {
			file = new File(_fullPath + "/" + _filename);
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
		absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/" + _dirName;
		return absPath;
	}

	public String CreateDir(int _environmentDir, String _dirName) {
		String baseDir = GetEnvironmentDirectoryPath(_environmentDir);
		if (!baseDir.equalsIgnoreCase("")) {
			File file = new File(baseDir, _dirName);
			file.mkdirs();
			return file.getPath();
		} else return "";
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
	public boolean IsExternalStorageEmulated() {
		return Environment.isExternalStorageEmulated();
	}

	/*
    Added in API level 9
    Returns whether the primary "external" storage device is removable.
    */
	public boolean IsExternalStorageRemovable() {
		return Environment.isExternalStorageRemovable();
	}

	//
	public String GetjFormVersionFeatures() {
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
		} catch (Exception e) {
			Log.e("jForm", "Failure to Get String  Resource", e);
			return 0;
		}
	}

	public String GetStringResourceById(int _resID) {
		return (String) (this.controls.activity.getResources().getText(_resID));
	}

	public int GetDrawableResourceId(String _resName) {
		try {
			Class<?> res = R.drawable.class;
			Field field = res.getField(_resName);  //"drawableName"
			int drawableId = field.getInt(null);
			return drawableId;
		} catch (Exception e) {
			Log.e("jForm", "Failure to get drawable id.", e);
			return 0;
		}
	}

	public Drawable GetDrawableResourceById(int _resID) {
		if (_resID == 0) return null; // by ADiV

		Drawable res = null;

		if (Build.VERSION.SDK_INT < 21) {    //for old device < 21
			res = this.controls.activity.getResources().getDrawable(_resID);
		}

		//[ifdef_api21up]
		if (Build.VERSION.SDK_INT >= 21) {
			res = this.controls.activity.getResources().getDrawable(_resID, null);
		}//[endif_api21up]

		return res;
	}

	//BY ADiV
	public void SetBackgroundImage(String _imageIdentifier, int _scaleType) {

		if (mImageBackground == null) return;

		Drawable d = GetDrawableResourceById(GetDrawableResourceId(_imageIdentifier));

		switch (_scaleType) {
			case 0:
				mImageBackground.setScaleType(ImageView.ScaleType.CENTER);
				break;
			case 1:
				mImageBackground.setScaleType(ImageView.ScaleType.CENTER_CROP);
				break;
			case 2:
				mImageBackground.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
				break;
			case 3:
				mImageBackground.setScaleType(ImageView.ScaleType.FIT_CENTER);
				break;
			case 4:
				mImageBackground.setScaleType(ImageView.ScaleType.FIT_END);
				break;
			case 5:
				mImageBackground.setScaleType(ImageView.ScaleType.FIT_START);
				break;
			case 6:
				mImageBackground.setScaleType(ImageView.ScaleType.FIT_XY);
				break;
			case 7:
				mImageBackground.setScaleType(ImageView.ScaleType.MATRIX);
				break;
		}

		mImageBackground.setImageDrawable(d);
	}

	//BY ADiV
	public void SetBackgroundImageMatrix(float _scaleX, float _scaleY, float _degress, float _dx, float _dy, float _centerX, float _centerY) {

		if (mImageBackground == null) return;

		if (mImageBackground.getScaleType() != ImageView.ScaleType.MATRIX)
			mImageBackground.setScaleType(ImageView.ScaleType.MATRIX);

		Matrix matrix = new Matrix();

		matrix.setRotate(_degress, _centerX, _centerY);
		matrix.postScale(_scaleX, _scaleY, _centerX * _scaleX, _centerY * _scaleY);
		matrix.postTranslate(_dx, _dy);

		mImageBackground.setImageMatrix(matrix);
		//mImageBackground.invalidate();
	}

	// BY ADiV
	public void SetBackgroundImage(String _imageIdentifier) {
		SetBackgroundImage(_imageIdentifier, 6); // FIT_XY for default
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
		if (!jCommons.IsAppCompatProject(controls)) {
			return (controls.activity).getActionBar();
		} else return null;
	}
	
	// BY ADiV
	public int GetBatteryPercent() {
		
		int ret = -1;

	    if (Build.VERSION.SDK_INT >= 21) {
             //[ifdef_api21up]
	         BatteryManager bm = (BatteryManager) this.controls.activity.getSystemService(this.controls.activity.BATTERY_SERVICE);
	         if( bm != null ) ret = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
			//[endif_api21up]

	    } else {

	         IntentFilter iFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
	         Intent batteryStatus = this.controls.activity.registerReceiver(null, iFilter);

	         int level = batteryStatus != null ? batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) : -1;
	         int scale = batteryStatus != null ? batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1) : -1;

	         double batteryPct = level / (double) scale;

	         ret = (int) (batteryPct * 100);
	   }
	   
	   return ret;
	}

/*
 * To disableAction-bar Icon and Title, you must do two things:
 setDisplayShowHomeEnabled(false);  // hides action bar icon
 setDisplayShowTitleEnabled(false); // hides action bar title
 */

	public void HideActionBar() {
		jCommons.ActionBarHide(controls);
	}

	public void ShowActionBar() {
		jCommons.ActionBarShow(controls);
	}

	//Hide the title label
	public void ShowTitleActionBar(boolean _value) {
		jCommons.ActionBarShowTitle(controls, _value);
	}

	//Hide the logo = false
	public void ShowLogoActionBar(boolean _value) {
		jCommons.ActionBarShowLogo(controls, _value);
	}

	//set a title and subtitle to the Action bar as shown in the code snippet.
	public void SetTitleActionBar(String _title) {
		jCommons.SetActionBarTitle(controls, _title);
	}

	//set a title and subtitle to the Action bar as shown in the code snippet.
	public void SetSubTitleActionBar(String _subtitle) {
		jCommons.SetActionBarSubTitle(controls, _subtitle);
	}

	//forward [<] activity! // If your minSdkVersion is 11 or higher!
	/*.*/
	public void SetDisplayHomeAsUpEnabledActionBar(boolean _value) {
		jCommons.ActionBarDisplayHomeAsUpEnabled(controls, _value);
	}

	public void SetIconActionBar(String _iconIdentifier) {
//[ifdef_api14up]
		Drawable d = GetDrawableResourceById(GetDrawableResourceId(_iconIdentifier));

		if (d != null) // by ADiV
			jCommons.ActionBarSetIcon(controls, d);
//[endif_api14up]
	}
	
	//By ADiV
	public void SetActionBarShowHome(boolean showHome) {
			   jCommons.ActionBarShowHome(controls, showHome);
	}

	//By ADiV
	public void SetActionBarColor(int color) {
		   jCommons.ActionBarSetColor(controls, color);
	}

	//By ADiV
	public void SetNavigationColor(int color) {
		   jCommons.NavigationSetColor(controls, color);
	}

	//By ADiV
	public void SetStatusColor(int color) {
			   jCommons.StatusSetColor(controls, color);
	}

	public void SetTabNavigationModeActionBar() {
		jCommons.ActionBarSetTabNavigationMode(controls);
	}

	//This method remove all tabs from the action bar and deselect the current tab
	public void RemoveAllTabsActionBar() {
		jCommons.ActionBarRemoveAllTabs(controls);
	}

	//Calculate ActionBar height
//ref http://stackoverflow.com/questions/12301510/how-to-get-the-actionbar-height
	public int GetActionBarHeight() {
		return jCommons.ActionGetBarBarHeight(controls);
	}

	public boolean ActionBarIsShowing() {
		return jCommons.ActionBarIsShowing(controls);
	}

	public boolean HasActionBar() {
		return jCommons.HasActionBar(controls);
	}

	public boolean IsAppCompatProject() {
		return jCommons.IsAppCompatProject(controls);
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
	
	// By ADiV
	public int GetVersionCode(){
		PackageManager pm = controls.activity.getPackageManager();
		
	    try {
	    	PackageInfo pinfo = pm.getPackageInfo(controls.activity.getPackageName(), 0);
	        return pinfo.versionCode;
	    } catch (NameNotFoundException e) {
	        return 0;
	    }
	}

	//By ADiV
	public String GetVersionName(){
		PackageManager pm = controls.activity.getPackageManager();
		
	    try {
	    	PackageInfo pinfo = pm.getPackageInfo(controls.activity.getPackageName(), 0);
	        return pinfo.versionName;
	    } catch (NameNotFoundException e) {
	        return "";
	    }
	}
	
	// by ADiV
	private String GetAppVersion(String patternString, String inputString) {
	    try{
	        //Create a pattern
	        Pattern pattern = Pattern.compile(patternString);
	        if (null == pattern) {
	            return "";
	        }

	        //Match the pattern string in provided string
	        Matcher matcher = pattern.matcher(inputString);
	        if (null != matcher && matcher.find()) {
	            return matcher.group(1);
	        }

	    }catch (PatternSyntaxException ex) {

	        ex.printStackTrace();
	    }

	    return "";
	}

	// by ADiV
	public String GetVersionPlayStore(String appUrlString) {
	    final String currentVersion_PatternSeq = "<div[^>]*?>Current\\sVersion</div><span[^>]*?>(.*?)><div[^>]*?>(.*?)><span[^>]*?>(.*?)</span>";
	    final String appVersion_PatternSeq = "htlgb\">([^<]*)</s";
	    String playStoreAppVersion = "";

	    BufferedReader inReader = null;
	    URLConnection uc = null;
	    StringBuilder urlData = new StringBuilder();
	    
	    URL url;
	   
	    try{
	     url = new URL(appUrlString);
	    } catch (MalformedURLException e) {
	     return "";
	    }
	    
	    try{
	     uc = url.openConnection();
	     if(uc == null) {
	       return "";
	     }
	     uc.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows; U; WindowsNT 5.1; en-US; rv1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
	     inReader = new BufferedReader(new InputStreamReader(uc.getInputStream()));
	     if (null != inReader) {
	        String str = "";
	        while ((str = inReader.readLine()) != null) {
	                       urlData.append(str);
	        }
	     }
	    
	    } catch (IOException e) {
	     return "";	
	    }

	    // Get the current version pattern sequence
	    String versionString = GetAppVersion(currentVersion_PatternSeq, urlData.toString());
	    if(null == versionString){
	        return "";
	    }else{
	        // get version from "htlgb">X.X.X</span>
	        playStoreAppVersion = GetAppVersion(appVersion_PatternSeq, versionString);
	    }

	    return playStoreAppVersion;
	}

	public void CancelShowCustomMessage() {
		if (mCustomToast != null) {
			mCustomToast.cancel();
			mCustomToast = null;
		}
	}

	//android.view.View
	public void ShowCustomMessage(View _layout, int _gravity) {
		//controls.pOnShowCustomMessage(PasObj);

		//android.view.ViewGroup
		if (_layout.getParent() instanceof android.widget.RelativeLayout) {
			android.widget.RelativeLayout par = (android.widget.RelativeLayout) _layout.getParent();
			if (par != null) {
				par.removeView(_layout);
			}
		}

		mCustomToast = new Toast(controls.activity);
		mCustomToast.setGravity(_gravity, 0, 0);
		mCustomToast.setDuration(Toast.LENGTH_LONG);
		_layout.setVisibility(View.VISIBLE);
		mCustomToast.setView(_layout);
		mCustomToast.show();

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

	public void ShowCustomMessage(View _layout, int _gravity, int _lenghTimeSecond) {

		mCustomToast = new Toast(controls.activity);
		mCustomToast.setGravity(_gravity, 0, 0);
		//toast.setDuration(Toast.LENGTH_LONG);
		android.widget.RelativeLayout par = (android.widget.RelativeLayout) _layout.getParent();
		if (par != null) {
			par.removeView(_layout);
		}
		_layout.setVisibility(View.VISIBLE);//0
		mCustomToast.setView(_layout);
		//it will show the toast for 20 seconds:
		//(20000 milliseconds/1st argument) with interval of 1 second/2nd argument //--> (20 000, 1000)
		MyCountDownTimer countDownTimer = new MyCountDownTimer(_lenghTimeSecond * 1000, 1000, mCustomToast);
		countDownTimer.start();

	}

	public void SetScreenOrientation(int _orientation) {
		//Log.i("Screen","Orientation "+ _orientation);
		switch (_orientation) {
			case 1:
				controls.activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
				break;
			case 2:
				controls.activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
				break;
			default:
				controls.activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR);
				break;
		}
	}

	// ssPortrait  = 1, //Portrait
	// ssLandscape = 2, //LandScape
	// ssUnknown   = 3

	public int GetScreenOrientation() {
		    
		   int r = 3; // ssUnknown
		    
		   if( controls.screenWidth <= controls.screenHeight ) r = 1; // Portrait
		   if( controls.screenWidth >  controls.screenHeight ) r = 2; // LandScape
		  
	       return r; 
	}

	public int GetScreenDpi() {
		String r= "";
		DisplayMetrics metrics = new DisplayMetrics();
		controls.activity.getWindowManager().getDefaultDisplay().getMetrics(metrics);
		return metrics.densityDpi;
	}

	public String GetScreenDensity() {
		String r = "";
		DisplayMetrics metrics = new DisplayMetrics();
		controls.activity.getWindowManager().getDefaultDisplay().getMetrics(metrics);
		int density = metrics.densityDpi;
//[ifdef_api16up]
		if (density == DisplayMetrics.DENSITY_XXHIGH) {
			r = "XXHIGH:" + String.valueOf(density);
		} else
//[endif_api16up]
			if (density == DisplayMetrics.DENSITY_XHIGH) {
				r = "XHIGH:" + String.valueOf(density);
			} else if (density == DisplayMetrics.DENSITY_HIGH) {
				r = "HIGH:" + String.valueOf(density);
			} else if (density == DisplayMetrics.DENSITY_MEDIUM) {
				r = "MEDIUM:" + String.valueOf(density);
			} else if (density == DisplayMetrics.DENSITY_LOW) {
				r = "LOW:" + String.valueOf(density);
			} else
	    	   r= "CUSTOM:" + String.valueOf(density);
		return r;
	}

	public String GetScreenSize() {
		String r = "";

		if ((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == Configuration.SCREENLAYOUT_SIZE_XLARGE) {
			r = "XLARGE";
		} else if ((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == Configuration.SCREENLAYOUT_SIZE_LARGE) {
			r = "LARGE";
		} else if ((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == Configuration.SCREENLAYOUT_SIZE_NORMAL) {
			r = "NORMAL";
		} else if ((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == Configuration.SCREENLAYOUT_SIZE_SMALL) {
			r = "SMALL";
		}
		return r;
	}

	public void LogDebug(String _tag, String _msg) {
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

		String myPath = _savePath + "/" + _saveFileNameJPG;
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
		return (String) actionBar.getTitle();
	}

	public String GetSubTitleActionBar() {
		ActionBar actionBar = this.controls.activity.getActionBar();
		return (String) actionBar.getSubtitle();
	}

	//https://xjaphx.wordpress.com/2011/10/02/store-and-use-files-in-assets/
	public String CopyFromAssetsToInternalAppStorage(String _filename) {
		InputStream is = null;
		FileOutputStream fos = null;			
		String PathDat = controls.activity.getFilesDir().getAbsolutePath();
		String _filename2 = _filename.substring(_filename.lastIndexOf("/")+1); //by Tomash - add support for folders in assets
		try {		   		     			
			File outfile = new File(PathDat+"/"+_filename2);								
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
		return PathDat + "/" +_filename2;
	}

	//by ADiV
	public String GetStripAccents(String _str) {
		_str = Normalizer.normalize(_str, Normalizer.Form.NFD);
		_str = _str.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
		return _str;
	}

	public String GetPathFromAssetsFile(String _assetsFileName) {
		return LoadFromAssets(_assetsFileName);
	}

	public Bitmap GetImageFromAssetsFile(String _assetsImageFileName) {
		String path = LoadFromAssets(_assetsImageFileName);
		BitmapFactory.Options bo = new BitmapFactory.Options();
		bo.inScaled = false;
		return BitmapFactory.decodeFile(path, bo);
	}

	public void CopyFromInternalAppStorageToEnvironmentDir(String _filename, String _environmentDir) {
		String srcPath = controls.activity.getFilesDir().getAbsolutePath() + "/" + _filename;       //Result : /data/data/com/MyApp/files
		String destPath = _environmentDir + "/" + _filename;
		CopyFile(srcPath, destPath);
	}


	public void CopyFromAssetsToEnvironmentDir(String _filename, String _environmentDir) {
		CopyFromAssetsToInternalAppStorage(_filename);
		String _filename2 = _filename.substring(_filename.lastIndexOf("/")+1); //by Tomash - add support for folders in assets
		CopyFromInternalAppStorageToEnvironmentDir(_filename2,_environmentDir);
	}

	public void ToggleSoftInput() {
		InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
	}

	public void HideSoftInput() {
		InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.toggleSoftInput(InputMethodManager.RESULT_HIDDEN, 0);
	}

	public void HideSoftInput(View _view) {
		InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(_view.getWindowToken(), 0);
	}

	public void ShowSoftInput() {
		InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.toggleSoftInput(InputMethodManager.RESULT_SHOWN, 0);
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
		
		if (Build.VERSION.SDK_INT >= 27) {
			//[ifdef_api27up]
			controls.activity.setTurnScreenOn(_value);
			//[endif_api27up]
	    } else {
		 if (_value)
		   controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
		 else
			controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
	    }
		
	}

	public void SetAllowLockWhileScreenOn(boolean _value) {
		if (_value)
			controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON);
		else
			controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON);
	}

	public void SetShowWhenLocked(boolean _value) {
		
		if (Build.VERSION.SDK_INT >= 27) {
			//[ifdef_api27up]
			controls.activity.setShowWhenLocked(_value);
			//[endif_api27up]
	    } else {
		 if (_value)
		    controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
		 else
			controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
	    }
	}

	public Uri ParseUri(String _uriAsString) {
		return Uri.parse(_uriAsString);
	}

	public String UriToString(Uri _uri) {
		return _uri.toString();
	}

	// ref. http://www.android-examples.com/get-display-ip-address-of-android-phone-device-programmatically/
	public int GetNetworkStatus() {
		boolean WIFI = false;
		boolean MOBILE = false;
		int r = 0; //NOT_CONNECTED
		ConnectivityManager CM = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo[] networkInfo = CM.getAllNetworkInfo();
		for (NetworkInfo netInfo : networkInfo) {
			if (netInfo.getTypeName().equalsIgnoreCase("WIFI"))
				if (netInfo.isConnected()) WIFI = true;
			if (netInfo.getTypeName().equalsIgnoreCase("MOBILE"))
				if (netInfo.isConnected())
					MOBILE = true;
		}

		if (WIFI == true) {
			r = 1; //WIFI_CONNECTED
		}

		if (MOBILE == true) {
			r = 2; //MOBILE_DATA_CONNECTED
		}

		return r;
	}

	public String GetDeviceDataMobileIPAddress() {
		String r = "";
		try {
			for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces();
				 en.hasMoreElements(); ) {
				NetworkInterface networkinterface = en.nextElement();
				for (Enumeration<InetAddress> enumIpAddr = networkinterface.getInetAddresses(); enumIpAddr.hasMoreElements(); ) {
					InetAddress inetAddress = enumIpAddr.nextElement();
					if (!inetAddress.isLoopbackAddress()) {
						boolean isIPv4 = inetAddress.getHostAddress().indexOf(':') < 0;
						if (isIPv4) return r = inetAddress.getHostAddress();
						if (!isIPv4) {
							int delim = inetAddress.getHostAddress().indexOf('%'); // drop ip6 zone suffix
							r = delim < 0 ? inetAddress.getHostAddress().toUpperCase() : inetAddress.getHostAddress().substring(0, delim).toUpperCase();
						}
					}
				}
			}
		} catch (Exception ex) {
			Log.e("Current IP", ex.toString());
		}
		return r;
	}

	//ref. http://www.devlper.com/2010/07/getting-ip-address-of-the-device-in-android/
	public String GetDeviceWifiIPAddress() {
		//WifiManager mWifi = (WifiManager) controls.activity.getSystemService(Context.WIFI_SERVICE);
		WifiManager mWifi = (WifiManager) this.controls.activity.getApplicationContext().getSystemService(Context.WIFI_SERVICE);

		//String ip = Formatter.formatIpAddress(
		int ipAddress = mWifi.getConnectionInfo().getIpAddress();
		String sIP = String.format("%d.%d.%d.%d",
				(ipAddress & 0xff),
				(ipAddress >> 8 & 0xff),
				(ipAddress >> 16 & 0xff),
				(ipAddress >> 24 & 0xff));
		return sIP;
	}

	/**
	 * Calculate the broadcast IP we need to send the packet along.
	 * ref. http://www.ece.ncsu.edu/wireless/MadeInWALAN/AndroidTutorial/
	 */
	public String GetWifiBroadcastIPAddress() throws IOException {
		String r = null;
		//WifiManager mWifi = (WifiManager) controls.activity.getSystemService(Context.WIFI_SERVICE);
		WifiManager mWifi = (WifiManager) this.controls.activity.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
		// DhcpInfo  is a simple object for retrieving the results of a DHCP request
		DhcpInfo dhcp = mWifi.getDhcpInfo();
		if (dhcp == null) {
			return "";
		}
		int broadcast = (dhcp.ipAddress & dhcp.netmask) | ~dhcp.netmask;
		byte[] quads = new byte[4];
		for (int k = 0; k < 4; k++)
			quads[k] = (byte) ((broadcast >> k * 8) & 0xFF);
		// Returns the InetAddress corresponding to the array of bytes.
		// The high order byte is quads[0].
		r = InetAddress.getByAddress(quads).getHostAddress();
		if (r == null) r = "";
		return r;
	}

	//https://xjaphx.wordpress.com/2011/10/02/store-and-use-files-in-assets/
	public String LoadFromAssetsTextContent(String _filename) {
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
		} catch (IOException ex) {
			//Log.i("loadFromAssets", "error!");
			return "";
		}
	}


//Fatih: Path = '' = Asset Root Folder 
//Path Example: gunlukler/2015/02/28/001

	public String[] GetAssetContentList(String _path) throws IOException {
		ArrayList<String> Folders = new ArrayList<String>();

		Resources r = this.controls.activity.getResources();
		AssetManager am = r.getAssets();
		String fileList[] = am.list(_path);
		if (fileList != null) {
			for (int i = 0; i < fileList.length; i++) {
				Folders.add(fileList[i]);
			}
		}
		String sFolders[] = Folders.toArray(new String[Folders.size()]);
		return sFolders;
	}

	//Fatih: gets system storage driver list
	public String[] GetDriverList() {
		ArrayList<String> Drivers = new ArrayList<String>();

		String sDriver;
		sDriver = System.getenv("EXTERNAL_STORAGE");
		if (sDriver != null) {
			File fDriver = new File(sDriver);

			if (fDriver.exists() && fDriver.canWrite()) {
				Drivers.add(fDriver.getAbsolutePath());
			}
		}

		sDriver = System.getenv("SECONDARY_STORAGE");
		if (sDriver != null) {
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
	public String[] GetFolderList(String _envPath) {
		ArrayList<String> Folders = new ArrayList<String>();

		File f = new File(_envPath);
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
	public String[] GetFileList(String _envPath) {
		ArrayList<String> Folders = new ArrayList<String>();

		File f = new File(_envPath);
		File[] files = f.listFiles();
		for (File fFile : files) {
			if (fFile.isFile()) {
				Folders.add(fFile.getName());
			}
		}
		String sFolders[] = Folders.toArray(new String[Folders.size()]);
		return sFolders;
	}

	public boolean FileExists(String _fullFileName) {
		return new File(_fullFileName).isFile();
	}

	public boolean DirectoryExists(String _fullDirectoryName) {
		return new File(_fullDirectoryName).isDirectory();
	}


	//http://blog.scriptico.com/category/dev/java/android/
	public void Minimize() {
		Intent main = new Intent(Intent.ACTION_MAIN);
		main.addCategory(Intent.CATEGORY_HOME);
		main.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		controls.activity.startActivity(main);

	}

        public void MoveToBack() {
               controls.activity.moveTaskToBack(true);
        }

	public void MoveTaskToBack(boolean _nonRoot) {   //the "guide line' is try to mimic java Api ...
		controls.activity.moveTaskToBack(_nonRoot);
	}

	public void Restart(int _delay) {
		PendingIntent intent = PendingIntent.getActivity(controls.activity.getBaseContext(), 0,
				new Intent(controls.activity.getIntent()),
				controls.activity.getIntent().getFlags());
		AlarmManager manager = (AlarmManager) controls.activity.getSystemService(Context.ALARM_SERVICE);
		manager.set(AlarmManager.RTC, System.currentTimeMillis() + _delay, intent);
		System.exit(2);
	}

	public String UriEncode(String _message) {
		return Uri.encode(_message);
	}

	//http://www.viralandroid.com/2015/12/how-to-use-font-awesome-icon-in-android-application.html
//http://fontawesome.io/cheatsheet/	
	public String ParseHtmlFontAwesome(String _htmlString) {
		String iconHeart = _htmlString; //"&#xf004;";
		String valHexStr = iconHeart.replace("&#x", "").replace(";", "");
		long valLong = Long.parseLong(valHexStr, 16);
		//button.setText(getString((char)valLong+"");
		return (char) valLong + "";
	}

//https://developer.android.com/reference/android/provider/Settings.System

	public int GetSettingsSystemInt(String _strKey) {
		try {
			return android.provider.Settings.System.getInt(controls.activity.getContentResolver(), _strKey);
		} catch (android.provider.Settings.SettingNotFoundException e) {
			return -1;
		}
	}

	//https://developer.android.com/reference/android/provider/Settings.System
	public String GetSettingsSystemString(String _strKey) {
		String r = android.provider.Settings.System.getString(controls.activity.getContentResolver(), _strKey);
		if (r == null) r = "";
		return r;
	}

	public float GetSettingsSystemFloat(String _strKey) {
		try {
			return android.provider.Settings.System.getFloat(controls.activity.getContentResolver(), _strKey);
		} catch (android.provider.Settings.SettingNotFoundException e) {
			return -1;
		}
	}

	public long GetSettingsSystemLong(String _strKey) {
		try {
			return android.provider.Settings.System.getLong(controls.activity.getContentResolver(), _strKey);
		} catch (android.provider.Settings.SettingNotFoundException e) {
			return -1;
		}
	}

	public boolean PutSettingsSystemInt(String _strKey, int _value) {
		return android.provider.Settings.System.putInt(controls.activity.getContentResolver(), _strKey, _value);
	}

	public boolean PutSettingsSystemLong(String _strKey, long _value) {
		return android.provider.Settings.System.putLong(controls.activity.getContentResolver(), _strKey, _value);
	}

	public boolean PutSettingsSystemFloat(String _strKey, float _value) {
		return android.provider.Settings.System.putFloat(controls.activity.getContentResolver(), _strKey, _value);
	}

	public boolean PutSettingsSystemString(String _strKey, String _strValue) {
		return android.provider.Settings.System.putString(controls.activity.getContentResolver(), _strKey, _strValue);
	}

	public boolean IsRuntimePermissionNeed() {
		return Build.VERSION.SDK_INT >= 23;  //Build.VERSION_CODES.M
	}

	public boolean IsRuntimePermissionGranted(String _androidPermission) {  //"android.permission.CAMERA"
		return jCommons.IsRuntimePermissionGranted(controls, _androidPermission);
	}

	public void RequestRuntimePermission(String _androidPermission, int _requestCode) {  //"android.permission.CAMERA"
		jCommons.RequestRuntimePermission(controls, _androidPermission, _requestCode);
	}

	public void RequestRuntimePermission(String[] _androidPermissions, int _requestCode) {  //"android.permission.CAMERA"
		jCommons.RequestRuntimePermission(controls, _androidPermissions, _requestCode);
	}

	//by ADiV
	public int GetScreenWidth( ){
			int w = controls.appLayout.getWidth();
			
			if( w <= 0 )
				w = controls.screenWidth;
			
			return w;
	}
		
	//by ADiV
	public int GetScreenHeight( ){
			int h = controls.appLayout.getHeight();
			
			if( h <= 0 )
				h = controls.screenHeight;
					
			return h;
	}
	
	//by ADiV
	public boolean IsInMultiWindowMode(){
		boolean r = false;
		if (Build.VERSION.SDK_INT >= 24) {
			//[ifdef_api24up]
			if (((Activity) controls.activity).isInMultiWindowMode()) r = true;
			//[endif_api24up]
		}
		return r;
	}
	
	//by ADiV
	public int GetRealScreenWidth(){
		DisplayMetrics displaymetrics = new DisplayMetrics();
		
		if(displaymetrics == null) return 0;

		if (Build.VERSION.SDK_INT >= 17) {
			//[ifdef_api17up]
			controls.activity.getWindowManager().getDefaultDisplay().getRealMetrics(displaymetrics); //need min Api  17
			//[endif_api17up]
		}

        return displaymetrics.widthPixels;
	}
	
	//by ADiV
	public int GetRealScreenHeight(){
		DisplayMetrics displaymetrics = new DisplayMetrics();
		
		if(displaymetrics == null) return 0;

		if (Build.VERSION.SDK_INT >= 17) {
			//[ifdef_api17up]
		     controls.activity.getWindowManager().getDefaultDisplay().getRealMetrics(displaymetrics);
			//[endif_api17up]
		}

		return displaymetrics.heightPixels;
	}

	//by ADiV
	public String GetSystemVersionString() {
		return android.os.Build.VERSION.RELEASE;
	}

	public ByteBuffer GetJByteBuffer(int _width, int _height) {
		ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(_width * _height * 4);
		return graphicBuffer;
	}

	public ByteBuffer GetByteBufferFromImage(Bitmap _bitmap) {
		if (_bitmap == null) return null;
		int w = _bitmap.getWidth();
		int h = _bitmap.getHeight();
		ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(w * h * 4);
		_bitmap.copyPixelsToBuffer(graphicBuffer);
		graphicBuffer.rewind();  //reset position
		return graphicBuffer;
	}

	private String getRealPathFromURI(Uri contentUri) {
		String path = "";
		Cursor cursor = null;
		try {
			String[] proj = {MediaStore.Images.Media.DATA};
			cursor = controls.activity.getContentResolver().query(contentUri, proj, null, null, null);
			cursor.moveToFirst();
			int column_index = cursor.getColumnIndex(proj[0]);
			path = cursor.getString(column_index);
		} finally {
			if (cursor != null) {
				cursor.close();
			}
		}
		return path;
	}

	private String getRealPathFromURI_API19(Uri uri){
		String filePath = "";
		String wholeID ="";

		//[ifdef_api19up]
		if(Build.VERSION.SDK_INT >= 19)
			wholeID = DocumentsContract.getDocumentId(uri);
		//[endif_api19up]

		if (wholeID.equals("")) return "";

		String id = wholeID.split(":")[1];
		String[] column = { MediaStore.Images.Media.DATA };
		// where id is equal to
		String sel = MediaStore.Images.Media._ID + "=?";
		Cursor cursor = controls.activity.getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
				column, sel, new String[]{ id }, null);
		int columnIndex = cursor.getColumnIndex(column[0]);
		if (cursor.moveToFirst()) {
			filePath = cursor.getString(columnIndex);
		}
		cursor.close();
		return filePath;
	}

	public String GetRealPathFromURI(Uri _Uri) {
		   String path = "";

           if (Build.VERSION.SDK_INT < 19)
           	 path = getRealPathFromURI(_Uri);
		   else
		     path = getRealPathFromURI_API19(_Uri);

		   return path;
	}

   //by Tomash
   //refactored by jmpessoa
   public void StartDefaultActivityForFile(String _filePath, String _mimeType) {
	   File file = new File(_filePath);
	   Intent intent = new Intent(Intent.ACTION_VIEW);
	   Uri newUri = jSupported.FileProviderGetUriForFile(controls, file);
	   if  (jSupported.IsAppSupportedProject()) {
		   intent.setDataAndType(newUri, _mimeType);
		   intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK |
				   Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET |
				   Intent.FLAG_GRANT_READ_URI_PERMISSION);
	   }
	   else {
		   intent.setDataAndType(Uri.parse("file://" + file),_mimeType);
	   }
	   controls.activity.startActivity(intent);
   }

	public String CopyFileFromUri(Uri _srcUri, String _outputDir) {
	
		String fileName = "";
		ContentResolver cr = controls.activity.getContentResolver();
    	String[] projection = {MediaStore.MediaColumns.DISPLAY_NAME};
    	Cursor metaCursor = cr.query(_srcUri, projection, null, null, null);
    	if (metaCursor != null) {
            try {
                if (metaCursor.moveToFirst()) {
                    fileName = metaCursor.getString(0);
                }
            } finally {
                metaCursor.close();
            }
    	}	
	
		if (fileName != "") {
		 try {	
 			InputStream input = cr.openInputStream(_srcUri);
 			OutputStream output = new FileOutputStream(new File(_outputDir + "/" + fileName));
			byte[] buf = new byte[1024];
			int bytesRead;
			while ((bytesRead = input.read(buf)) > 0) {
				output.write(buf, 0, bytesRead);
				}
  	    	input.close();
   	    	output.close();
	        return fileName;
		 } catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "";
		 }
		} else {
		 return "";	
		}	
	}

	public void RunOnUiThread(final int _tag) {
        controls.activity.runOnUiThread(new Runnable() {
            public void run() {
                controls.pOnRunOnUiThread(PasObj, _tag);
            };
        });
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

public int screenWidth = 0;
public int screenHeight = 0;

public boolean formChangeSize = false; // OnRotate if change size or show form with rotate [by ADiV]
public boolean formNeedLayout = false; // Automatic updatelayout [by ADiV]

private int javaNewId = 100000;   // To assign java id from 100001 onwards [by ADiV]

public boolean isGDXGame = false; //prepare to LAMW GDXGame		
public Object GDXGame = null;	//prepare to LAMW GDXGame

//Sets the density at which an asset image should be loaded.
//This is done so that the same image looks the same on different devices with different densities.
private int densityForAssets = 0;      // (0 Not set)

//Jave -> Pascal Function ( Pascal Side = Event )
public native void pAppOnCreate(Context context, RelativeLayout layout, Intent intent);
public native int  pAppOnScreenStyle();
public native void pAppOnNewIntent(Intent intent);
public native void pAppOnDestroy();
public native void pAppOnPause();
public native void pAppOnRestart();
public native void pAppOnResume();
public native void pAppOnStart();
public native void pAppOnStop();
public native void pAppOnBackPressed();
public native int pAppOnRotate(int rotate);
public native void pAppOnUpdateLayout();
public native void pAppOnConfigurationChanged();
public native void pAppOnActivityResult(int requestCode, int resultCode, Intent data);
public native void pAppOnCreateOptionsMenu(Menu menu);
public native void pAppOnClickOptionMenuItem(MenuItem menuItem, int itemID, String itemCaption, boolean checked);
public native boolean pAppOnPrepareOptionsMenu(Menu menu, int menuSize);
public native boolean pAppOnPrepareOptionsMenuItem(Menu menu, MenuItem menuItem, int itemIndex);
public native void pAppOnCreateContextMenu(ContextMenu menu);
public native void pAppOnClickContextMenuItem(MenuItem menuItem, int itemID, String itemCaption, boolean checked);
public native void pOnDraw(long pasobj);
public native void pOnTouch(long pasobj, int act, int cnt, float x1, float y1, float x2, float y2);
public native void pOnClickGeneric(long pasobj);
public native boolean pAppOnSpecialKeyDown(char keyChar, int keyCode, String keyCodeString);
public native void pOnDown(long pasobj);
public native void pOnUp(long pasobj);
public native void pOnClick(long pasobj, int value);
public native void pOnLongClick(long pasobj);
public native void pOnDoubleClick(long pasobj);
public native void pOnChange(long pasobj, String txt, int count);
public native void pOnChanged(long pasobj, String txt, int count);
public native void pOnEnter(long pasobj);
public native void pOnBackPressed(long pasobj);
public native void pOnClose(long pasobj);
public native void pAppOnViewClick(View view, int id);
public native void pAppOnListItemClick(AdapterView adapter, View view, int position, int id);
public native void pOnFlingGestureDetected(long pasobj, int direction);
public native void pOnPinchZoomGestureDetected(long pasobj, float scaleFactor, int state);
public native void pOnLostFocus(long pasobj, String text);
public native void pOnFocus(long pasobj, String text);
public native void pOnBeforeDispatchDraw(long pasobj, Canvas canvas, int tag);
public native void pOnAfterDispatchDraw(long pasobj, Canvas canvas, int tag);
public native void pOnLayouting(long pasobj, boolean changed);
public native void pAppOnRequestPermissionResult(int requestCode, String permission, int grantResult);
public native void pOnRunOnUiThread(long pasobj, int tag);
// -------------------------------------------------------------------------------------------
//Load Pascal Library - Please, do not edit the static content commented in the template file
// -------------------------------------------------------------------------------------------
static {
try{System.loadLibrary("controls");} catch (UnsatisfiedLinkError e) {Log.e("JNI_Loading_libcontrols", "exception", e);}
}
// -------------------------------------------------------------------------
//  Activity Event
// -------------------------------------------------------------------------
public  int  jAppOnScreenStyle()          { return(pAppOnScreenStyle());   } 

public  void jAppOnCreate(Context context,RelativeLayout layout, Intent intent) //android.os.Bundle;
                                          { pAppOnCreate(context,layout,intent); }

public  void jAppOnNewIntent(Intent intent)            { pAppOnNewIntent(intent); } 
public  void jAppOnDestroy()              { pAppOnDestroy();               }  
public  void jAppOnPause()                { pAppOnPause();                 }  
public  void jAppOnRestart()              { pAppOnRestart();               }    
public  void jAppOnResume()               { pAppOnResume();                }    
public  void jAppOnStart()                { pAppOnStart();                 }    
public  void jAppOnStop()                 { pAppOnStop();                  }   
public  void jAppOnBackPressed()          { pAppOnBackPressed();           }   
public  int  jAppOnRotate(int rotate)     {  return(pAppOnRotate(rotate)); }
public  void jAppOnUpdateLayout()         { pAppOnUpdateLayout();          }

//rotate=1 --> device on vertical/default position ; 2 --> device on horizontal position 
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
public void jAppOnListItemClick(AdapterView<?> adapter, View view, int position, int id){ pAppOnListItemClick(adapter, view,position,id);}
//public  void jAppOnHomePressed()          { pAppOnHomePressed();           }
public boolean jAppOnKeyDown(char keyChar , int keyCode, String keyCodeString) {return pAppOnSpecialKeyDown(keyChar, keyCode, keyCodeString);};

public  void jAppOnRequestPermissionResult(int requestCode, String permission, int grantResult) {
	pAppOnRequestPermissionResult(requestCode, permission ,grantResult);
}

// For internal id of componente 100000 or higher

public int getJavaNewId(){
	javaNewId = javaNewId + 1;
	return javaNewId;
}

public int GetJavaLastId(){
	return javaNewId;
}

// We assign the density for the correct scaling of assets images

public void SetDensityAssets( int _density ){
	densityForAssets = _density;
}

public int GetDensityAssets( ){
	return densityForAssets;
}

// For reuse and avoid repeating errors

public int GetDrawableResourceId(String _resName) {
	  try {
	     Class<?> res = R.drawable.class;
	     Field field = res.getField(_resName);  //"drawableName"
	     
	     if( field != null ){
	    	int drawableId = field.getInt(null);
	      	return drawableId;
	     } else
	    	 return 0;
	  }
	  catch (Exception e) {
	     //Log.e("GetDrawableResourceId", "Failure to get drawable id.", e);
	     return 0;
	  }
}

public Drawable GetDrawableResourceById(int _resID) {
			
	if( _resID == 0 ) return null;
	
	Drawable res = null;
	
	if (android.os.Build.VERSION.SDK_INT < 21 ) {
		res = activity.getResources().getDrawable(_resID);
	}
	
	//[ifdef_api21up]
	if(android.os.Build.VERSION.SDK_INT >= 21)
		res = activity.getResources().getDrawable(_resID, null);
    //[endif_api21up]
					
	return res;
}

//// -------------------------------------------------------------------------
//  System, Class
// -------------------------------------------------------------------------
public  void systemGC() {
   System.gc();
}


public void ShowAlert(String _title, String _message, String _btnText) {
	
	AlertDialog dialog = null;
	AlertDialog.Builder builder = new AlertDialog.Builder(this.activity);
	builder.setMessage       (_message)
	       .setCancelable    (false)	       
	       .setNeutralButton(_btnText, null);
	       	      
	dialog = builder.create();
	dialog.setTitle(_title);
	dialog.show();
}


public  void systemSetOrientation(int orientation) {
   this.activity.setRequestedOrientation(orientation);
}

public int getAPILevel() {
  return android.os.Build.VERSION.SDK_INT;  
}

//by jmpessoa
public  int  systemGetOrientation() {  
   return (this.activity.getResources().getConfiguration().orientation); 
}

public  void classSetNull (Class<?> object) {
   object = null;
}

public  void classChkNull (Class<?> object) {
   if (object == null) { Log.i("JAVA","checkNull-Null"); };
   if (object != null) { Log.i("JAVA","checkNull-Not Null"); };
}

public Context GetContext() {
   return this.activity; 
}

//by ADiV Software
public int getContextTop(){
 ViewGroup view = ((ViewGroup) this.activity.findViewById(android.R.id.content));
 
 if( view != null)
 	return view.getTop();
 else
 	return 0;
	
}

//by  ADiV
public int getStatusBarHeight() {
	int resourceId = this.activity.getResources().getIdentifier("status_bar_height", "dimen", "android");
	
	if ( resourceId > 0 )
		return this.activity.getResources().getDimensionPixelSize(resourceId);
	else
		return 0;
}

//by  ADiV
public int GetNavigationHeight() {
	int resourceId = this.activity.getResources().getIdentifier("navigation_bar_height", "dimen", "android");
	
	if ( resourceId > 0 )
		return this.activity.getResources().getDimensionPixelSize(resourceId);
	else
		return 0;
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
public  void appFinish() {
	   activity.finish();
	   System.exit(0); //<< ------- fix by jmpessoa
}

public void appRecreate() {
	activity.recreate();
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
  return ( (screenWidth << 16)| screenHeight );
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
public  String GetControlsVersion() {  
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
	String f = "";

  TelephonyManager telephony = (TelephonyManager) activity.getSystemService(Context.TELEPHONY_SERVICE);
  if (telephony!=null) {
	  try {
		  f = telephony.getLine1Number();
	  } catch (SecurityException ex) {
		  Log.e("getDevPhoneNumber", ex.getMessage());
	  }
  }
  return f;
}

// Result: Device ID - LORDMAN
// Remarks : Nexus7 (no moblie device) -> Crash : fixed code - Simon
// ANDROID_ID - Added by Tomash
@SuppressLint("NewApi")
public String getDevDeviceID() {
  String devid = "";
  try {
    TelephonyManager telephony = (TelephonyManager) activity.getSystemService(Context.TELEPHONY_SERVICE);
    if (telephony != null) {
        devid = telephony.getDeviceId();
    	
    	if (devid==null) {   //tk+
    		devid="";    		
    	}
    } else {
    	devid="";
    }
    if (devid=="") {	
        devid = Secure.getString(activity.getContentResolver(),Secure.ANDROID_ID);
    }    	
  }
  catch (SecurityException e) //ExceptionExceptionException
      { e.printStackTrace(); }
  return devid;
}
// -------------------------------------------------------------------------
//  Bitmap
// -------------------------------------------------------------------------
// Get Image Width,Height without Decoding
/* Tomash: unused? See jBitmap.java GetBitmapSizeFromFile
public  int Image_getWH (String filename ) {
  BitmapFactory.Options options = new BitmapFactory.Options();
  options.inJustDecodeBounds = true;
  BitmapFactory.decodeFile(filename, options);
  return ( (options.outWidth << 16) | (options.outHeight) );
}
*/

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

boolean IsEmailValid(String email) {
	if(email == null) return false;
	
	return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches();
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

	public int jSend_SMS(String phoneNumber, String msg, boolean multipartMessage) {
	SmsManager sms = SmsManager.getDefault();	
	try {
		//SmsManager.getDefault().sendTextMessage(phoneNumber, null, msg, null, null);
		if (multipartMessage) {
			ArrayList<String> messages = sms.divideMessage(msg);    
			sms.sendMultipartTextMessage(phoneNumber, null, messages, null, null);			  
		} else {
			List<String> messages = sms.divideMessage(msg);    
			for (String message : messages) {
				sms.sendTextMessage(phoneNumber, null, message, null, null);
			}			    
		}
		//Log.i("Send_SMS",phoneNumber+": "+ msg);
		return 1; //ok	      
	} catch (Exception e) {
		//Log.i("Send_SMS Fail",e.toString());
		return 0; //fail
	}
}
        //improved by CC
        //http://forum.lazarus-ide.org/index.php/topic,44775.msg315109/topicseen.html
	public int jSend_SMS(String phoneNumber, String msg, String packageDeliveredAction, boolean multipartMessage) {
		String SMS_DELIVERED = packageDeliveredAction;
		PendingIntent deliveredPendingIntent = PendingIntent.getBroadcast(this.GetContext(), 0, new Intent(SMS_DELIVERED), 0);
		SmsManager sms = SmsManager.getDefault();
		int partsCount = 1;
		try {
			if (multipartMessage)
			{
				ArrayList<String> messages = sms.divideMessage(msg);
				partsCount = messages.size();
				ArrayList<PendingIntent> deliveredPendingIntents = new ArrayList<PendingIntent>();
				for (int i = 0; i < messages.size(); i++)
				{
					deliveredPendingIntents.add(i, deliveredPendingIntent);
				}
				sms.sendMultipartTextMessage(phoneNumber, null, messages, deliveredPendingIntents, null  );
			}
			else
			{
				List<String> messages = sms.divideMessage(msg);
				partsCount = messages.size();
				for (String message : messages)
				{
					sms.sendTextMessage(phoneNumber, null, message, deliveredPendingIntent, null );
				}
			}
			return partsCount;
		} catch (Exception e) {
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

private String getRealPathFromURI(Uri contentURI) {
        String result;
        Cursor cursor = this.GetContext().getContentResolver().query(contentURI, null,
                null, null, null);
        if (cursor == null) { // Source is Dropbox or other similar local file path
            result = contentURI.getPath();
        } else {
            cursor.moveToFirst();
            try {
                int idx = cursor
                        .getColumnIndex(MediaStore.Images.ImageColumns.DATA);
                result = cursor.getString(idx);
            } catch (Exception e) {
                result = "";
            }
            cursor.close();
        }
        return result;
}

// -------------------------------------------------------------------------
//  Camera
// -------------------------------------------------------------------------
  /*
   * NOTE: The DCIM folder on the microSD card in your Android device is where Android stores the photos and videos 
   * you take with the device's built-in camera. When you open the Android Gallery app, 
   * you are browsing the files saved in the DCIM folder....
   */
private void galleryAddPic(File image_uri) {
          if (Build.VERSION.SDK_INT < 19) {
             this.activity.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(image_uri)));
          }
          else
          {
             MediaScannerConnection.scanFile(
               this.activity,
               new String[] {image_uri.getAbsolutePath()},
               new String[] {"image/jpg"},
               new MediaScannerConnection.OnScanCompletedListener() {
                   @Override
                        public void onScanCompleted(String path, Uri uri) {
                              Log.e("Camera","File " + path + " was scanned successfully: " + uri);
                        }
               });
          }
}

public String jCamera_takePhoto(String path, String filename, int requestCode, boolean addToGallery) {

	      //StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder(); //by Guser97
	      //StrictMode.setVmPolicy(builder.build()); //by Guser97

          Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
          //String  image_path = (path+File.separator+filename);
          File newfile = new File(path, File.separator+filename);
	      File dirAsFile;

          if (newfile!=null) {
			  dirAsFile = newfile.getParentFile();
			  if (dirAsFile!= null) {
				  if (!dirAsFile.exists()) {
					  dirAsFile.mkdirs();
				  }
				  try {
					  newfile.createNewFile();
				  } catch (IOException e) {
					  Log.e("File creation error", newfile.getPath());
				  }
			  }
		  }

          if (newfile!=null) {
		     Uri uri = jSupported.FileProviderGetUriForFile(this.GetContext(), newfile);
             if (jSupported.IsAppSupportedProject()) {
               intent.putExtra(MediaStore.EXTRA_OUTPUT, uri); //outputFileUri
               intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
             }
             else {
                   jSupported.SetStrictMode(); //by Guser97
	           intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, uri); //mImageCaptureUri
	           intent.putExtra("return-data", true);
             }

             if (intent.resolveActivity(this.GetContext().getPackageManager()) != null) {
               this.activity.startActivityForResult(intent, requestCode);
             }

             if (addToGallery) galleryAddPic(newfile);

             return newfile.toString();
          }
          else return "";
}

public String jCamera_takePhoto(String path, String filename, int requestCode) {
       return jCamera_takePhoto(path, filename, requestCode, true);
}


	public String jCamera_takePhoto(String path, String filename) {
		return jCamera_takePhoto(path, filename, 12345);
	}

	public void takePhoto(String filename) {  //HINT: filename = App.Path.DCIM + '/test.jpg
		Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
		Uri mImageCaptureUri = Uri.fromFile(new File("", filename));
		intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, mImageCaptureUri);
		intent.putExtra("return-data", true);
		activity.startActivityForResult(intent, 12345);
	}

//-------------------------------------------------------------------------------------------------------
//SMART LAMW DESIGNER
//-------------------------------------------------------------------------------------------------------

public  java.lang.Object jButton_Create(long pasobj ) {
  return (java.lang.Object)( new jButton(this.activity,this,pasobj));
}

public  java.lang.Object jCheckBox_Create(long pasobj ) {
  return (java.lang.Object)( new jCheckBox(this.activity,this,pasobj));
}

public java.lang.Object jDigitalClock_jCreate(long _Self) {
   return (java.lang.Object)(new jDigitalClock(this,_Self));
}

public  java.lang.Object jImageView_Create(long pasobj ) {
  return (java.lang.Object)( new jImageView(this.activity,this,pasobj));
}
public native void pOnImageViewPopupItemSelected(long pasobj, String caption);

public  java.lang.Object jPanel_Create(long pasobj ) {
  return (java.lang.Object)(new jPanel(this.activity,this,pasobj));
}

public  java.lang.Object jTextView_Create(long pasobj) {
  return (java.lang.Object)( new jTextView(this.activity,this,pasobj));
}

}
