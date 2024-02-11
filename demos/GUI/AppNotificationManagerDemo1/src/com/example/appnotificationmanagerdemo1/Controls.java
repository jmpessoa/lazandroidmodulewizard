package com.example.appnotificationmanagerdemo1;

//LAMW: Lazarus Android Module Wizard - version 0.8.6.3 - 17 December - 2021
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

//IMPORTANT! Don't cleanup imports !!!
import android.hardware.usb.UsbDevice;
import android.provider.DocumentsContract;
import android.provider.Settings.Secure;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.annotation.SuppressLint;
import android.app.ActionBar;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.AppOpsManager;
import android.app.Dialog;
import android.app.PendingIntent;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
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
import android.os.Process;
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
import java.util.Iterator;

import java.util.List;
import java.util.Locale;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
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
import java.io.BufferedReader;
import java.net.URL;
import java.net.URLConnection;
import java.net.MalformedURLException;
import java.text.DateFormat;
import java.text.Normalizer;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Locale;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import android.view.animation.AccelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.TranslateAnimation;
import android.view.animation.RotateAnimation;

//import android.os.StrictMode; //by Guser979 [try fix "jCamera_takePhoto"

//**class entrypoint**//please, do not remove/change this line!

//Main Java/Pascal Interface Class
public class Controls {
  // -------------------------------------------------------------------------------------------
  //Load Pascal Library - Please, do not edit the static content commented in the template file
  // -------------------------------------------------------------------------------------------
  static {
     try{System.loadLibrary("controls");} catch (UnsatisfiedLinkError e) {Log.e("JNI_Loading_libcontrols", "exception", e);}
  }

  //
  public Activity activity;  // Activity
  public RelativeLayout appLayout; // Base Layout
  public int screenStyle = 0;         // Screen Style [Dev:0 , Portrait: 1, Landscape : 2]
  public int systemVersion;
  public int screenWidth = 0;
  public int screenHeight = 0;
  public boolean formChangeSize = false; // OnRotate if change size or show form with rotate [by ADiV]
  public boolean formNeedLayout = false; // Automatic updatelayout [by ADiV]
  public boolean isGDXGame = false; //prepare to LAMW GDXGame
  public Object GDXGame = null;  //prepare to LAMW GDXGame
  private int javaNewId = 100000;   // To assign java id from 100001 onwards [by ADiV]
  //Sets the density at which an asset image should be loaded.
//This is done so that the same image looks the same on different devices with different densities.
  private int densityForAssets = 0;      // (0 Not set)

  //Jave -> Pascal Function ( Pascal Side = Event )
  public native void pAppOnCreate(Context context, RelativeLayout layout, Intent intent);

  public native int pAppOnScreenStyle();

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
  
  public native void pOnDone(long pasobj);
  public native void pOnSearch(long pasobj);
  public native void pOnNext(long pasobj);
  public native void pOnGo(long pasobj);


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

  // -------------------------------------------------------------------------
//  Activity Event
// -------------------------------------------------------------------------
  public int jAppOnScreenStyle() {
    return (pAppOnScreenStyle());
  }

  public void jAppOnCreate(Context context, RelativeLayout layout, Intent intent) //android.os.Bundle;
  {
    pAppOnCreate(context, layout, intent);
  }

  public void jAppOnNewIntent(Intent intent) {
    pAppOnNewIntent(intent);
  }

  public void jAppOnDestroy() {
    pAppOnDestroy();
  }

  public void jAppOnPause() {
    pAppOnPause();
  }

  public void jAppOnRestart() {
    pAppOnRestart();
  }

  public void jAppOnResume() {
    pAppOnResume();
  }

  public void jAppOnStart() {
    pAppOnStart();
  }

  public void jAppOnStop() {
    pAppOnStop();
  }

  public void jAppOnBackPressed() {
    pAppOnBackPressed();
  }

  public int jAppOnRotate(int rotate) {
    return (pAppOnRotate(rotate));
  }

  public void jAppOnUpdateLayout() {
    pAppOnUpdateLayout();
  }

  //rotate=1 --> device on vertical/default position ; 2 --> device on horizontal position
  public void jAppOnConfigurationChanged() {
    pAppOnConfigurationChanged();
  }

  public void jAppOnActivityResult(int requestCode, int resultCode, Intent data) {
    pAppOnActivityResult(requestCode, resultCode, data);
  }

  public void jAppOnCreateOptionsMenu(Menu m) {
    pAppOnCreateOptionsMenu(m);
  }

  public void jAppOnClickOptionMenuItem(MenuItem item, int itemID, String itemCaption, boolean checked) {
    pAppOnClickOptionMenuItem(item, itemID, itemCaption, checked);
  }

  public boolean jAppOnPrepareOptionsMenu(Menu m, int size) {
    boolean r = pAppOnPrepareOptionsMenu(m, size);
    return r;
  }

  public boolean jAppOnPrepareOptionsItem(Menu m, MenuItem item, int index) {
    boolean r = pAppOnPrepareOptionsMenuItem(m, item, index);
    return r;
  }

  public void jAppOnCreateContextMenu(ContextMenu m) {
    pAppOnCreateContextMenu(m);
  }

  public void jAppOnClickContextMenuItem(MenuItem item, int itemID, String itemCaption, boolean checked) {
    pAppOnClickContextMenuItem(item, itemID, itemCaption, checked);
  }

  public void jAppOnViewClick(View view, int id) {
    pAppOnViewClick(view, id);
  }

  public void jAppOnListItemClick(AdapterView<?> adapter, View view, int position, int id) {
    pAppOnListItemClick(adapter, view, position, id);
  }

  //public  void jAppOnHomePressed()          { pAppOnHomePressed();           }
  public boolean jAppOnKeyDown(char keyChar, int keyCode, String keyCodeString) {
    return pAppOnSpecialKeyDown(keyChar, keyCode, keyCodeString);
  }

  ;

  public void jAppOnRequestPermissionResult(int requestCode, String permission, int grantResult) {
    pAppOnRequestPermissionResult(requestCode, permission, grantResult);
  }

// For internal id of componente 100000 or higher

  public int getJavaNewId() {
    javaNewId = javaNewId + 1;
    return javaNewId;
  }

  public int GetJavaLastId() {
    return javaNewId;
  }

// We assign the density for the correct scaling of assets images

  public void SetDensityAssets(int _density) {
    densityForAssets = _density;
  }

  public int GetDensityAssets() {
    return densityForAssets;
  }

// For reuse and avoid repeating errors

  public int GetDrawableResourceId(String _resName) {
    try {
      Class<?> res = R.drawable.class;
      Field field = res.getField(_resName);  //"drawableName"

      if (field != null) 
        return field.getInt(null);      
      
    } catch (Exception e) {
      //Log.e("GetDrawableResourceId", "Failure to get drawable id.", e);      
    }
    
    try {
        Class<?> res = R.mipmap.class;
        Field field = res.getField(_resName);  //"mipmapName"

        if (field != null) {
          return field.getInt(null);
        } else {
          return 0;
        }
      } catch (Exception e) {
        //Log.e("GetDrawableResourceId", "Failure to get drawable id.", e);
    	return 0;
      }
  }

  public Drawable GetDrawableResourceById(int _resID) {

    if ((_resID == 0) || (this.activity == null)) return null;

    Drawable res = null;

    if (android.os.Build.VERSION.SDK_INT < 22) {
      res = this.activity.getResources().getDrawable(_resID);
    }

    //https://developer.android.com/reference/android/content/res/Resources#getDrawable(int,%20android.content.res.Resources.Theme)
    //[ifdef_api22up]
    if (android.os.Build.VERSION.SDK_INT >= 22) {
      res = this.activity.getResources().getDrawable(_resID, null);
    }
    //[endif_api22up]

    return res;
  }

  //// -------------------------------------------------------------------------
//  System, Class
// -------------------------------------------------------------------------
  public void systemGC() {
    System.gc();
  }

  public int getAPILevel() {
    return android.os.Build.VERSION.SDK_INT;
  }

  //by jmpessoa
  public int systemGetOrientation() {
	if (this.activity == null) return 0;
	
    return (this.activity.getResources().getConfiguration().orientation);
  }

  public void classSetNull(Class<?> object) {
    object = null;
  }

  public void classChkNull(Class<?> object) {
	  
    if (object == null) Log.i("JAVA", "checkNull-Null");   
    if (object != null) Log.i("JAVA", "checkNull-Not Null");    
    
  }

  public Context GetContext() {
    return this.activity;
  }

  // -------------------------------------------------------------------------
//  App Related
// -------------------------------------------------------------------------
//
  public void appFinish() {
	if (this.activity != null)  
		this.activity.finish();
	
    System.exit(0); //<< ------- fix by jmpessoa
  }

  public void appRecreate() {
	if (this.activity != null)
		this.activity.recreate();
  }

  public void appKillProcess() {
	if (this.activity != null)
		this.activity.finish();
  }

  // -------------------------------------------------------------------------
//  Asset Related
// -------------------------------------------------------------------------
// src : codedata.txt
// tgt : /data/data/com.kredix.control/data/codedata.txt
  public boolean assetSaveToFile(String src, String tgt) {
	  
	if (this.activity == null) return false;
	
    InputStream is = null;
    FileOutputStream fos = null;
    String path = '/' + tgt.substring(1, tgt.lastIndexOf("/"));
    File outDir = new File(path);
    
    if (outDir == null) return false;
    
    outDir.mkdirs();
    try {
      is = this.activity.getAssets().open(src);
      int size = is.available();
      byte[] buffer = new byte[size];
      File outfile = new File(tgt);
      fos = new FileOutputStream(outfile);
      for (int c = is.read(buffer); c != -1; c = is.read(buffer)) {
        fos.write(buffer, 0, c);
      }
      is.close();
      fos.close();
      return true;
    } catch (IOException e) {
      e.printStackTrace();
      return false;
    }
  }

// -------------------------------------------------------------------------
//  View Related - Generic! --> AndroidWidget.pas
// -------------------------------------------------------------------------

  public void view_SetVisible(View view, int state) {
    if (view == null) return;
    
    view.setVisibility(state);
  }

  public void view_SetBackGroundColor(View view, int color) {
    if (view == null) return;
    
    view.setBackgroundColor(color);
  }

  public void view_Invalidate(View view) {
    if (view == null) return;
    
    view.invalidate();
  }

  // -------------------------------------------------------------------------
//  System Info
// -------------------------------------------------------------------------
// Result : Width(16bit) : Height (16bit)
  public int getScreenWH() {
    return ((screenWidth << 16) | screenHeight);
  }

  // LORDMAN - 2013-07-28
  public int getStrLength(String Txt) {  //fix by jmpessoa
    int len = 0;
    if (Txt != null) 
      len = Txt.length();
    
    return (len);
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
  public String GetControlsVersion() {
    String listVersionInfo =
        "7$0=GetControlsVersionInfo;" +  //added ... etc..
            "7$0=getLocale;"; //added ... etc..
    return listVersionInfo;
  }

  //Fatih: Path = '' = Asset Root Folder
//Path Example: gunlukler/2015/02/28/001
  public String[] getAssetContentList(String Path) throws IOException {
    ArrayList<String> Folders = new ArrayList<String>();

    AssetManager am = null;

    Resources r = this.activity.getResources();

    if (r != null) {
      am = r.getAssets();
    }

    if (am != null) {
      String fileList[] = am.list(Path);
      if (fileList != null) {
        for (int i = 0; i < fileList.length; i++) {
          Folders.add(fileList[i]);
        }
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
  public String[] getFolderList(String Path) {
    ArrayList<String> Folders = new ArrayList<String>();

    File f = new File(Path);

    if (f != null) {
      File[] files = f.listFiles();
      for (File fFile : files) {
        if (fFile.isDirectory()) {
          Folders.add(fFile.getName());
        }
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

    if (f != null) {
      File[] files = f.listFiles();
      for (File fFile : files) {
        if (fFile.isFile()) {
          Folders.add(fFile.getName());
        }
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
    return (System.currentTimeMillis());
  }

  // -------------------------------------------------------------------------
//  Android path
// -------------------------------------------------------------------------
// Result : /data/app/com.kredix-1.apk
  public String getPathApp(String pkgName) {
	if (this.activity == null) return "";    

	Context context = this.activity;	  
    
    String PathApp = "";

    try {
        PathApp = context.getPackageManager().getApplicationInfo(pkgName, 0).sourceDir;
    } catch (NameNotFoundException e) {
    	return "";
    }

    if (PathApp == null) return "";
    
    return PathApp;
  }

  // Result : /data/data/com/kredix/files
  public String getPathDat() {
    if (this.activity == null) return "";    

	Context context = this.activity;
    
    //String version = Build.VERSION.RELEASE;
    String PathDat = context.getFilesDir().getAbsolutePath();

    if (PathDat == null) return "";
    
    return (PathDat);
  }

  // Result : /storage/emulated/0
  public String getPathExt() {
    File FileExt = Environment.getExternalStorageDirectory();

    if (FileExt == null) return "";

    return (FileExt.getPath());
  }

  private File getMyEnvDir(String environmentDir) {
	  
	   if (this.activity == null) return null;
	   
       if (Build.VERSION.SDK_INT <=  29) 
           return Environment.getExternalStoragePublicDirectory(environmentDir);
       else 
           return this.activity.getExternalFilesDir(environmentDir);       
   }

  // Result : /storage/emulated/0/DCIM
  public String getPathDCIM() {
    File FileDCIM = getMyEnvDir(Environment.DIRECTORY_DCIM);

    if (FileDCIM == null) return "";

    return FileDCIM.getPath();
  }

  //by jmpessoa
  public String getPathDataBase() {
	if (this.activity == null) return "";    

	Context context = this.activity;    

    String destPath = context.getFilesDir().getAbsolutePath();

    if (destPath == null) return "";    

    destPath = destPath.substring(0, destPath.lastIndexOf("/")) + "/databases";
    return destPath;
  }

  // -------------------------------------------------------------------------
//  Android Locale
// -------------------------------------------------------------------------
// thierrydijoux - get locale info
  public String getLocale(int localeType) {
    if (this.activity == null) return "";    

    Context context = this.activity;

    String value = "";
    switch (localeType) {
      case 0:
        value = context.getResources().getConfiguration().locale.getCountry();
        break;
      case 1:
        value = context.getResources().getConfiguration().locale.getDisplayCountry();
        break;
      case 2:
        value = context.getResources().getConfiguration().locale.getDisplayLanguage();
        break;
      case 3:
        value = context.getResources().getConfiguration().locale.getDisplayName();
        break;
      case 4:
        value = context.getResources().getConfiguration().locale.getDisplayVariant();
        break;
      case 5:
        value = context.getResources().getConfiguration().locale.getISO3Country();
        break;
      case 6:
        value = context.getResources().getConfiguration().locale.getISO3Language();
        break;
      case 7:
        value = context.getResources().getConfiguration().locale.getVariant();
        break;
    }

    if (value == null) return "";

    return value;
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
  public Bitmap Image_resample(String infile, int size) {
    int iw, ih, im; // input image w,h, max
    int scale;    //
    int ow, oh;    // output image w,h

    // get input image w,h
    BitmapFactory.Options options = new BitmapFactory.Options();
    options.inJustDecodeBounds = true;
    BitmapFactory.decodeFile(infile, options);
    iw = options.outWidth;
    ih = options.outHeight;
    //
    im = Math.max(iw, ih);
    scale = 1;
    if (size <= (im / 32)) {
      scale = 32;
    }
    if (((im / 32) < size) && (size <= (im / 16))) {
      scale = 16;
    }
    if (((im / 16) < size) && (size <= (im / 8))) {
      scale = 8;
    }
    if (((im / 8) < size) && (size <= (im / 4))) {
      scale = 4;
    }
    if (((im / 4) < size) && (size <= (im / 2))) {
      scale = 2;
    }
    //
    options.inJustDecodeBounds = false;
    options.inSampleSize = scale;
    Bitmap src = BitmapFactory.decodeFile(infile, options);
    //
    if (im == iw) {
      ow = size;
      oh = Math.round((float) ow * ((float) ih / (float) iw));
    } else {
      oh = size;
      ow = Math.round((float) oh * ((float) iw / (float) ih));
    }
    //
    return (Bitmap.createScaledBitmap(src, ow, oh, true));
  }

  public void Image_save(Bitmap bmp, String filename) {
    try {
      FileOutputStream out = new FileOutputStream(filename);
      bmp.compress(Bitmap.CompressFormat.PNG, 100, out);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  // -------------------------------------------------------------------------
//  Toast
// -------------------------------------------------------------------------
//
  public void jToast(String str) {
	if (this.activity == null) return;
	
    Toast.makeText(this.activity, str, Toast.LENGTH_SHORT).show();
  }

  //by jmpessoa
//you need a real android device (not emulator!)
//http://www.androidaspect.com/2013/09/how-to-send-email-from-android.html
  public void jSend_Email(
      String to,
      String cc,
      String bcc,
      String subject,
      String message) {
	  
	if (this.activity == null) return;
	  
    try {
      Intent email = new Intent(Intent.ACTION_SEND);
      
      if (email == null) return;
      
      email.putExtra(Intent.EXTRA_EMAIL, new String[]{to});
      email.putExtra(Intent.EXTRA_CC, new String[]{cc});
      email.putExtra(Intent.EXTRA_BCC, new String[]{bcc});
      email.putExtra(Intent.EXTRA_SUBJECT, subject);
      email.putExtra(Intent.EXTRA_TEXT, message);
      // Use email client only
      email.setType("message/rfc822");
      this.activity.startActivity(Intent.createChooser(email, "Choose an email client"));
      //rst = 1; //ok
    } catch (Exception e) {
      //Log.i("Java","Send Email Error");
      e.printStackTrace();
    }
  }

//http://codetheory.in/android-sms/
//http://www.developerfeed.com/java/tutorial/sending-sms-using-android
//http://www.techrepublic.com/blog/software-engineer/how-to-send-a-text-message-from-within-your-android-app/

  public int jSend_SMS(String phoneNumber, String msg, boolean multipartMessage) {
    SmsManager sms = SmsManager.getDefault();
    
    if (sms == null) return 0;
    
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

  /*
  Apps targeting Android 12 and higher must specify either FLAG_IMMUTABLE or FLAG_MUTABLE
  when constructing a PendingIntent.
  FLAG_IMMUTABLE is available since target SDK 23,
   */
  //improved by CC
  //http://forum.lazarus-ide.org/index.php/topic,44775.msg315109/topicseen.html
  public int jSend_SMS(String phoneNumber, String msg, String packageDeliveredAction, boolean multipartMessage) {
    //String SMS_DELIVERED = packageDeliveredAction;
    PendingIntent deliveredPendingIntent = PendingIntent.getBroadcast(this.GetContext(), 0, new Intent(packageDeliveredAction), PendingIntent.FLAG_IMMUTABLE); //PendingIntent.FLAG_CANCEL_CURRENT
    SmsManager sms = SmsManager.getDefault();
    
    if (sms == null)  return 0;
    
    int partsCount = 1;
    try {
      if (multipartMessage) {
        ArrayList<String> messages = sms.divideMessage(msg);
        partsCount = messages.size();
        ArrayList<PendingIntent> deliveredPendingIntents = new ArrayList<PendingIntent>();
        for (int i = 0; i < messages.size(); i++) {
          deliveredPendingIntents.add(i, deliveredPendingIntent);
        }
        sms.sendMultipartTextMessage(phoneNumber, null, messages, deliveredPendingIntents, null);
      } else {
        List<String> messages = sms.divideMessage(msg);
        partsCount = messages.size();
        for (String message : messages) {
          sms.sendTextMessage(phoneNumber, null, message, deliveredPendingIntent, null);
        }
      }
      return partsCount;
    } catch (Exception e) {
      return 0; //fail
    }
  }

  public String jRead_SMS(Intent intent, String addressBodyDelimiter) {
    //---get the SMS message passed in---
    SmsMessage[] msgs = null;
    String str = "";
    if (intent.getAction().equals("android.provider.Telephony.SMS_RECEIVED")) {
      Bundle bundle = intent.getExtras();
      if (bundle != null) {
        //---retrieve the SMS message received---
        Object[] pdus = (Object[]) bundle.get("pdus");
        msgs = new SmsMessage[pdus.length];
        for (int i = 0; i < msgs.length; i++) {
          msgs[i] = SmsMessage.createFromPdu((byte[]) pdus[i]);
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
  public String jContact_getMobileNumberByDisplayName(String contactName) {
	  
	if (this.activity == null) return "";

    String matchNumber = "";
    String username;

    username = contactName;

    username = username.toLowerCase();

    Cursor phones = this.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, null, null, null);
    
    if (phones == null) return "";
    
    String name = "";
    String phoneNumber = "";
    String phoneType = "";
    int iColum = 0;

    while (phones.moveToNext()) {           
      name = "";
      phoneNumber = "";
      phoneType = "";
      
      iColum = phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME);
      if(iColum >= 0) name = phones.getString(iColum);
      
      iColum = phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER);
      if(iColum >= 0) phoneNumber = phones.getString(iColum);
      
      iColum = phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE);
      if(iColum >= 0) phoneType = phones.getString(iColum);
           
      name = name.toLowerCase();

      if (name.equals(username)) {
        if (phoneType.equals("2")) { //mobile
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
  public String jContact_getDisplayNameList(char delimiter) {
	if (this.activity == null) return "";
	
    String nameList = "";
    Cursor phones = this.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, null, null, null);
    
    if (phones == null) return "";
    
    String name = "";    
    String phoneType = "";
    int iColum = 0;
    
    while (phones.moveToNext()) {
    	name = "";        
        phoneType = "";
        
        iColum = phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME);
        if(iColum >= 0) name = phones.getString(iColum);                
        
        iColum = phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE);
        if(iColum >= 0) phoneType = phones.getString(iColum);

        if (phoneType.equals("2")) { //mobile
         nameList = nameList + delimiter + name;
      }
    }
    
    phones.close();
    
    return nameList;
  }

  // -------------------------------------------------------------------------
//  Bitmap
// -------------------------------------------------------------------------
  public int[] getBmpArray(String file) {
    Bitmap bmp = BitmapFactory.decodeFile(file);
    
    if (bmp == null) return null;
    
    int length = bmp.getWidth() * bmp.getHeight();
    int[] pixels = new int[length + 2];
    bmp.getPixels(pixels, 0, bmp.getWidth(), 0, 0, bmp.getWidth(), bmp.getHeight());
    pixels[length + 0] = bmp.getWidth();
    pixels[length + 1] = bmp.getHeight();
    return (pixels);
  }

  private String getRealPathFromURI(Uri contentURI) {
    String result = "";
    Cursor cursor = this.GetContext().getContentResolver().query(contentURI, null,
        null, null, null);
    
    if (cursor == null) { // Source is Dropbox or other similar local file path
      result = contentURI.getPath();
    } else {
      cursor.moveToFirst();
      try {
        int idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
        result = cursor.getString(idx);
      } catch (Exception e) {
        result = "";
      }
      cursor.close();
    }

    if (result == null) return "";    

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
	if (this.activity == null) return;
	  
    if (Build.VERSION.SDK_INT < 19) {
      this.activity.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(image_uri)));
    } else {
      MediaScannerConnection.scanFile(
          this.activity,
          new String[]{image_uri.getAbsolutePath()},
          new String[]{"image/jpg"},
          new MediaScannerConnection.OnScanCompletedListener() {
            @Override
            public void onScanCompleted(String path, Uri uri) {
              Log.e("Camera", "File " + path + " was scanned successfully: " + uri);
            }
          });
    }       
  }

  public String jCamera_takePhoto(String path, String filename, int requestCode, boolean addToGallery) {

    //StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder(); //by Guser97
    //StrictMode.setVmPolicy(builder.build()); //by Guser97
	  
	if (this.activity == null) return "";

    Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
    
    if (intent == null) return "";
    
    //String  image_path = (path+File.separator+filename);
    File newfile = new File(path, File.separator + filename);
    if (newfile == null) {
      return "";
    }
    File dirAsFile;

    if (newfile != null) {
      dirAsFile = newfile.getParentFile();
      if (dirAsFile != null) {
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

    if (newfile != null) {
      Uri uri = jSupported.FileProviderGetUriForFile(this.GetContext(), newfile);
      if (jSupported.IsAppSupportedProject()) {
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri); //outputFileUri
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
      } else {
        jSupported.SetStrictMode(); //by Guser97
        intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, uri); //mImageCaptureUri
        intent.putExtra("return-data", true);
      }

      if (intent.resolveActivity(this.GetContext().getPackageManager()) != null) {
        this.activity.startActivityForResult(intent, requestCode);
      }

      if (addToGallery) {
        galleryAddPic(newfile);
      }

      return newfile.toString();
    } else {
      return "";
    }
  }

  public String jCamera_takePhoto(String path, String filename, int requestCode) {
    return jCamera_takePhoto(path, filename, requestCode, true);
  }


  public String jCamera_takePhoto(String path, String filename) {
    return jCamera_takePhoto(path, filename, 12345);
  }

  public void takePhoto(String filename) {  //HINT: filename = App.Path.DCIM + '/test.jpg
    Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
    
    if (intent == null) return;
    
    Uri mImageCaptureUri = Uri.fromFile(new File("", filename));
    intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, mImageCaptureUri);
    intent.putExtra("return-data", true);
    activity.startActivityForResult(intent, 12345);
  }
  
  /// https://www.codexpedia.com/android/android-fade-in-and-fade-out-animation-programatically/
	public void fadeInAnimation(final View view, int duration) {
		
		if (view == null) return;
		
		Animation fadeIn = new AlphaAnimation(0, 1);
		
		if(fadeIn == null) return;
		
		fadeIn.setInterpolator(new DecelerateInterpolator());
		fadeIn.setDuration(duration);
		fadeIn.setFillAfter(true);
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

	public void fadeOutAnimation(final View view, int duration) {
		
		if (view == null) return;
		
		Animation fadeOut = new AlphaAnimation(1, 0);
		
		if(fadeOut == null) return;
		
		fadeOut.setInterpolator(new AccelerateInterpolator());
		fadeOut.setStartOffset(duration);
		fadeOut.setDuration(duration);
		fadeOut.setFillAfter(true);
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
	public void slidefromRightToLeftIn(View view, long duration) {
		
		if (view == null) return;
		
		TranslateAnimation animate;
		
		//animate = new TranslateAnimation(appLayout.getWidth(), 0, 0, 0); //(xFrom,xTo, yFrom,yTo)
		animate = new TranslateAnimation(appLayout.getWidth()-view.getX(),	0, 0, 0); //(xFrom,xTo, yFrom,yTo)
		
		if(animate == null) return;
		
		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}
	
	public void slidefromRightToLeftOut(View view, long duration) {
		
		if (view == null) return;
		
		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		
		//animate = new TranslateAnimation(0,-appLayout.getWidth(), 0, 0); //(xFrom,xTo, yFrom,yTo)
		animate = new TranslateAnimation(0,view.getWidth()-view.getX(), 0, 0); //(xFrom,xTo, yFrom,yTo)
		
		if(animate == null) return;
		
		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}

	public void slidefromLeftToRightOut(View view, long duration) {  //try
		
		if (view == null) return;

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		
		//animate = new TranslateAnimation(0, appLayout.getWidth(), 0, 0); //(xFrom,xTo, yFrom,yTo)
		animate = new TranslateAnimation(0, -appLayout.getWidth()-view.getX(), 0, 0); //(xFrom,xTo, yFrom,yTo)
		
		if(animate == null) return;

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}

	public void slidefromLeftToRightIn(View view, long duration) {  //try
		
		if (view == null) return;

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		
		//animate = new TranslateAnimation(-appLayout.getWidth(),	0, 0, 0); //(xFrom,xTo, yFrom,yTo)
		animate = new TranslateAnimation(-view.getWidth()-view.getX(),	0, 0, 0); //(xFrom,xTo, yFrom,yTo)
		
		if(animate == null) return;

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}
	
	public void slidefromTopToBottomOut(View view, long duration) {  //try
		
		if (view == null) return;

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		
		animate = new TranslateAnimation(0, 0, 0, -appLayout.getHeight()-view.getY()); //(xFrom,xTo, yFrom,yTo)
		
		if(animate == null) return;

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}

	public void slidefromTopToBottomIn(View view, long duration) {  //try
		
		if (view == null) return;

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		
		//animate = new TranslateAnimation(0,	0, -appLayout.getHeight(), 0); //(xFrom,xTo, yFrom,yTo)
		animate = new TranslateAnimation(0,	0, -view.getHeight()-view.getY(), 0); //(xFrom,xTo, yFrom,yTo)
		
		if(animate == null) return;

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}
	
	public void slidefromBottomToTopOut(View view, long duration) {  //try
		
		if (view == null) return;

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		
		//animate = new TranslateAnimation(0, 0, 0, -appLayout.getHeight()); //(xFrom,xTo, yFrom,yTo)
		animate = new TranslateAnimation(0,	0, 0, view.getHeight()-view.getY()); //(xFrom,xTo, yFrom,yTo)
		
		if(animate == null) return;

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}

	public void slidefromBottomToTopIn(View view, long duration) {  //try
		
		if (view == null) return;

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		
		//animate = new TranslateAnimation(0,	0, appLayout.getHeight(), 0); //(xFrom,xTo, yFrom,yTo)
		animate = new TranslateAnimation(0, 0, appLayout.getHeight()-view.getY(), 0); //(xFrom,xTo, yFrom,yTo)
		
		if(animate == null) return;

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}
	
	public void slidefromMoveCustomIn(View view, long duration, int _xFrom, int _yFrom) {  //try
		
		if (view == null) return;

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		
		animate = new TranslateAnimation(_xFrom, 0, _yFrom, 0); //(xFrom,xTo, yFrom,yTo)
		
		if(animate == null) return;

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}
	
	public void slidefromMoveCustomOut(View view, long duration, int _xTo, int _yTo) {  //try
		
		if (view == null) return;

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		
		animate = new TranslateAnimation(0, _xTo, 0, _yTo); //(xFrom,xTo, yFrom,yTo)
		
		if(animate == null) return;

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}
	
	public void animateRotate( View view, long duration, int _angleFrom, int _angleTo ){
		
		if (view == null) return;
		
		RotateAnimation animate; 
		
		animate = new RotateAnimation(_angleFrom, _angleTo, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
		
		if(animate == null) return;
		
		animate.setDuration(duration);
		animate.setFillAfter(true);
		
		view.startAnimation(animate);		
	}

  // -------------------------------------------------------------------------
  //  jForm Create - Please, Don't remove it!
  // -------------------------------------------------------------------------
  public java.lang.Object jForm_Create(long pasobj) {
    return (java.lang.Object) (new jForm(this, pasobj));
  }

//-------------------------------------------------------------------------------------------------------
//SMART LAMW DESIGNER
//-------------------------------------------------------------------------------------------------------

public  java.lang.Object jButton_Create(long pasobj ) {
  return (java.lang.Object)( new jButton(this.activity,this,pasobj));
}

public java.lang.Object jIntentManager_jCreate(long _Self) {
   return (java.lang.Object)(new jIntentManager(this,_Self));
}      

public java.lang.Object jNotificationManager_jCreate(long _Self) {
  return (java.lang.Object)(new jNotificationManager(this,_Self));
}   

public  java.lang.Object jTextView_Create(long pasobj) {
  return (java.lang.Object)( new jTextView(this.activity,this,pasobj));
}

}
