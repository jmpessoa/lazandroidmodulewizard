package com.example.appnotificationmanagerdemo2;


//LAMW: Lazarus Android Module Wizard - version 0.8.6.2 - 15 July - 2021 [jForm.java]
//RAD Android: Project Wizard, Form Designer and Components Development Model!

//https://github.com/jmpessoa/lazandroidmodulewizard
//http://forum.lazarus.freepascal.org/index.php/topic,21919.270.html

import android.content.ContentValues;
import android.os.ParcelFileDescriptor;
import android.provider.DocumentsContract;
import android.provider.OpenableColumns;
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
import android.webkit.MimeTypeMap;
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
import java.lang.Math;
import java.net.URI;
import java.nio.ByteBuffer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;
import java.util.Iterator;

import java.util.List;
import java.util.Locale;
import java.util.Objects;
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
//import javax.microedition.khronos.opengles.GL10;
//import javax.microedition.khronos.egl.EGL10;
//import javax.microedition.khronos.egl.EGLContext;
//import javax.microedition.khronos.egl.EGLDisplay;
//import javax.microedition.khronos.egl.EGLSurface;

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

import android.content.ClipData;
import android.content.ClipboardManager;

//import android.os.StrictMode; //by Guser979 [try fix "jCamera_takePhoto"

//-------------------------------------------------------------------------
//Constants
//-------------------------------------------------------------------------
class Const {

    public static final int TouchDown = 0;
    public static final int TouchMove = 1;
    public static final int TouchUp = 2;
    public static final int Click = 3; // new
    public static final int DoubleClick = 4;  // new
    public static final int Click_Default = 0;
}

//-------------------------------------------------------------------------
//Form
//-------------------------------------------------------------------------
public class jForm {

    public Toast mCustomToast = null;
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

    private ClipboardManager mClipBoard = null;
    private ClipData mClipData = null;

    // Constructor
    public jForm(Controls ctrls, long pasobj) {
        PasObj = pasobj;
        controls = ctrls;
        parent = controls.appLayout;

        layout = new RelativeLayout(controls.activity);

        if (layout == null) {
            return;
        }

        layparam = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);
        layout.setLayoutParams(layparam);

        mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);

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

    //https://stackoverflow.com/questions/3035692/how-to-convert-a-drawable-to-a-bitmap
    public static Bitmap drawableToBitmap(Drawable drawable) {
        Bitmap bitmap = null;

        if (drawable instanceof BitmapDrawable) {
            BitmapDrawable bitmapDrawable = (BitmapDrawable) drawable;
            if (bitmapDrawable.getBitmap() != null) {
                return bitmapDrawable.getBitmap();
            }
        }

        if (drawable.getIntrinsicWidth() <= 0 || drawable.getIntrinsicHeight() <= 0) {
            bitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888); // Single color bitmap will be created of 1x1 pixel
        } else {
            bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        }

        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bitmap;
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
            if (child != null) {
                child.setEnabled(enabled);
            }
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
                if (parent != null) {
                    parent.removeView(layout);
                }
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

    public void Show(int effect) {

        //fadeOutAnimation(layout, 2000);
        //fadeInAnimation(layout, 2000);

        if (animationDurationIn > 0)
        	Animate( true, 0, 0 );

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
        if (animationDurationOut > 0)
        	Animate( false, 0, 0 );
        
        parent.removeView(layout);
        controls.pOnClose(PasObj);
    }
    
    // by ADiV
    public void Animate( boolean animateIn, int _xFromTo, int _yFromTo ){
	    if ( animationMode == 0 ) return;
	    
	    if( animateIn && (animationDurationIn > 0) )
	    	switch (animationMode) {
	    	 case 1: controls.fadeInAnimation(layout, animationDurationIn); break; // Fade
	    	 case 2: controls.slidefromRightToLeftIn(layout, animationDurationIn); break; //RightToLeft
	    	 case 3: controls.slidefromLeftToRightIn(layout, animationDurationIn); break; //LeftToRight
	    	 case 4: controls.slidefromTopToBottomIn(layout, animationDurationIn); break; //TopToBottom
	    	 case 5: controls.slidefromBottomToTopIn(layout, animationDurationIn); break; //BottomToTop
	    	 case 6: controls.slidefromMoveCustomIn(layout, animationDurationIn, _xFromTo, _yFromTo); break; //MoveCustom
	    	}
	    
	    if( !animateIn && (animationDurationOut > 0) )
	    	switch (animationMode) {
	    	 case 1: controls.fadeOutAnimation(layout, animationDurationOut); break; // Fade
	    	 case 2: controls.slidefromRightToLeftOut(layout, animationDurationOut); break; //RightToLeft
	    	 case 3: controls.slidefromLeftToRightOut(layout, animationDurationOut); break; //LeftToRight
	    	 case 4: controls.slidefromTopToBottomOut(layout, animationDurationOut); break; //TopToBottom
	    	 case 5: controls.slidefromBottomToTopOut(layout, animationDurationOut); break; //BottomToTop
	    	 case 6: controls.slidefromMoveCustomOut(layout, animationDurationOut, _xFromTo, _yFromTo); break; //MoveCustom
	    	}			
    }

    //by ADiV
    public boolean IsScreenLocked() {
        KeyguardManager myKM = (KeyguardManager) controls.activity.getSystemService(Context.KEYGUARD_SERVICE);

        if (myKM == null) {
            return false;
        }

        return myKM.inKeyguardRestrictedInputMode();
    }

    //by ADiV
    public boolean IsSleepMode() {
        PowerManager powerManager = (PowerManager) controls.activity.getSystemService(Context.POWER_SERVICE);

        if (powerManager == null) {
            return false;
        }

        boolean isScreenAwake = (Build.VERSION.SDK_INT < 20 ? powerManager.isScreenOn() : powerManager.isInteractive());

        return !isScreenAwake;
    }

    public boolean IsConnected() { //by ADiV

        ConnectivityManager cm = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);

        if (cm != null) {
            NetworkInfo activeNetwork = cm.getActiveNetworkInfo();

            if (activeNetwork != null) {
                return (activeNetwork.isAvailable() && activeNetwork.isConnected());
            }
        }

        return false;
    }

    public boolean IsConnectedWifi() { // by ADiV

        ConnectivityManager cm = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);

        if (cm != null) {
            NetworkInfo activeNetwork = cm.getActiveNetworkInfo();

            if (activeNetwork != null) {
                return (activeNetwork.getType() == ConnectivityManager.TYPE_WIFI);
            }
        }

        return false;
    }

    public boolean IsConnectedTo(int _connectionType) { // by ADiV

        ConnectivityManager cm = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);

        if (cm != null) {
            NetworkInfo activeNetwork = cm.getActiveNetworkInfo();

            int result = -1;

            if (activeNetwork != null) {
                if (activeNetwork.isAvailable() && activeNetwork.isConnected()) {
                    ;
                }
            }
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
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
        
        if (formatter == null) return "";        

        String r = formatter.format(new Date());

        if (r == null) return "";
        
        return r;
    }


      // by ADiV
      public String GetDateTime(long millisDateTime) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
        
        if (formatter == null) return "";        

        String r = formatter.format(millisDateTime);

        if (r == null) return "";
        
        return r;
      }

    // by ADiV
    public long GetTimeInMilliseconds() {
        return controls.getTick();
    }

  //by ADiV
  public String GetTimeHHssSS(long millisTime) {
    SimpleDateFormat formatter = new SimpleDateFormat("mm:ss:SS", Locale.US);
    
    if (formatter == null) return "";
    
    String r = formatter.format(new Date(millisTime));

    if (r == null) return "";
    
    return r;
  }



  //by ADiV
  public long GetDateTimeToMillis(String _dateTime, boolean _zone) {
    String sPattern = "yyyy-MM-dd HH:mm:ss";

    long offset = 0;

    if (_zone) {
      Calendar calendar = Calendar.getInstance(Locale.getDefault());

      if (calendar != null) {
        offset = -(calendar.get(Calendar.ZONE_OFFSET) + calendar.get(Calendar.DST_OFFSET));// / (60 * 1000);
      }
    }

    DateFormat formatter = new SimpleDateFormat(sPattern, Locale.US);

    if (formatter == null) {
      return 0;
    }

    long lnsTime = 0;

    try {

      Date dateObject = formatter.parse(_dateTime);

      if (dateObject != null) {
        lnsTime = dateObject.getTime();
      }

    } catch (java.text.ParseException e) {
      e.printStackTrace();
      return 0;
    }

    return (lnsTime - offset);
  }

      public String GetDateTimeUTC(String _dateTime) {
        String sPattern = "yyyy-MM-dd HH:mm:ss";

        SimpleDateFormat formatter = new SimpleDateFormat(sPattern, Locale.US);

        if (formatter == null) return "";

        Date dateObject;

        try {

          dateObject = formatter.parse(_dateTime);

        } catch (java.text.ParseException e) {
          e.printStackTrace();
          return "";
        }
        
        formatter.setTimeZone(TimeZone.getTimeZone("UTC"));

        String r = formatter.format(dateObject);

        if (r == null) return "";
        
        return r;
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
        String valueStr = "";

        if (data != null) 
            valueStr = data.getStringExtra(extraName);
        
        if (valueStr == null) return "";
        
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
        if (wifiManager == null) {
            return (false);
        }

        return wifiManager.setWifiEnabled(_status);
    }

    public boolean IsWifiEnabled() {
        //WifiManager wifiManager = (WifiManager)this.controls.activity.getSystemService(Context.WIFI_SERVICE);
        WifiManager wifiManager = (WifiManager) this.controls.activity.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        if (wifiManager == null) {
            return (false);
        }

        return wifiManager.isWifiEnabled();
    }

    public boolean IsMobileDataEnabled() {
        boolean mobileDataEnabled = false; // Assume disabled
        ConnectivityManager cm = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (cm == null) {
            return (false);
        }

        try {
            final Class<?> cmClass = Class.forName(cm.getClass().getName());
            Method method = cmClass.getDeclaredMethod("getMobileDataEnabled");
            if (method == null) {
                return (false);
            }
            method.setAccessible(true); // Make the method callable
            // get the setting for "mobile data"
            mobileDataEnabled = (Boolean) method.invoke(cm);
        } catch (Exception e) {
            // Some problem accessible private API
            // TODO do whatever error handling you want here
        }
        return mobileDataEnabled;
    }

   private File getMyEnvDir(String environmentDir) {
       if (Build.VERSION.SDK_INT <=  29) {
           return Environment.getExternalStoragePublicDirectory(environmentDir);
       }
       else {
           return controls.activity.getExternalFilesDir(environmentDir);
       }
   }

    public String GetEnvironmentDirectoryPath(int _directory) {

        File filePath = null;
        String absPath = "";   //fail!

        //getMyEnvDir(Environment.DIRECTORY_DOCUMENTS);break; //only Api 19!
        if (_directory != 8) {
            switch (_directory) {
                case 0:
                    filePath = getMyEnvDir(Environment.DIRECTORY_DOWNLOADS);
                    break;
                case 1:
                    filePath = getMyEnvDir(Environment.DIRECTORY_DCIM);
                    break;
                case 2:
                    filePath = getMyEnvDir(Environment.DIRECTORY_MUSIC);
                    break;
                case 3:
                    filePath = getMyEnvDir(Environment.DIRECTORY_PICTURES);
                    break;
                case 4:
                    filePath = getMyEnvDir(Environment.DIRECTORY_NOTIFICATIONS);
                    break;
                case 5:
                    filePath = getMyEnvDir(Environment.DIRECTORY_MOVIES);
                    break;
                case 6:
                    filePath = getMyEnvDir(Environment.DIRECTORY_PODCASTS);
                    break;
                case 7:
                    filePath = getMyEnvDir(Environment.DIRECTORY_RINGTONES);
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

                case 13:
                    if (Build.VERSION.SDK_INT < 19)
                        filePath = getMyEnvDir(Environment.DIRECTORY_DOWNLOADS);
                    else
                        filePath = getMyEnvDir(Environment.DIRECTORY_DOCUMENTS);
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

        if (absPath == null) return "";        

        return absPath;
    }

    public String GetInternalAppStoragePath() { //GetAbsoluteDirectoryPath
        String PathDat = this.controls.activity.getFilesDir().getAbsolutePath();       //Result : /data/data/com/MyApp/files

        if (PathDat == null) return "";        

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
            if (input != null) {
                input.close();
            }
            if (output != null) {
                output.close();
            }
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

        try {
            InputStream is = null;
            FileOutputStream fos = null;
            String PathDat = controls.activity.getFilesDir().getAbsolutePath();

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

        if (file != null) {
            if (file.isFile()) {
                file.delete();
            }
        }
    }

    public void DeleteFile(String _fullPath, String _filename) {
        File file;
        if (_fullPath.equalsIgnoreCase("")) {
            file = new File(Environment.getExternalStorageDirectory() + "/" + _filename); // root
        } else {
            file = new File(_fullPath + "/" + _filename);
        }

        if (file != null) {
            if (file.isFile()) {
                file.delete();
            }
        }
    }

    public void DeleteFile(int _environmentDir, String _filename) {
        String baseDir = GetEnvironmentDirectoryPath(_environmentDir);
        if (!baseDir.equalsIgnoreCase("")) {
            File file = new File(baseDir, _filename);

            if (file != null) {
                if (file.isFile()) {
                    file.delete();
                }
            }
        }
    }

    // Android SDK >=29 need <application android:requestLegacyExternalStorage="true" ... >
    public String CreateDir(String _dirName) {
        this.controls.activity.getDir(_dirName, 0); //if not exist -->> CREATE!
        String absPath = this.controls.activity.getFilesDir().getPath();
        
        if (absPath == null) return "";
        
        absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/" + _dirName;
        return absPath;
    }

    // Android SDK >=29 need <application android:requestLegacyExternalStorage="true" ... >
    public String CreateDir(int _environmentDir, String _dirName) {
    	
        String baseDir = GetEnvironmentDirectoryPath(_environmentDir);
        
        if (!baseDir.equalsIgnoreCase("")) {
            File file = new File(baseDir, _dirName);
            
            if (file != null)                            
             if( file.mkdirs() ) 
              return file.getPath();
        } 
        
        return "";        
    }

    // Android SDK >=29 need <application android:requestLegacyExternalStorage="true" ... >
    public String CreateDir(String _fullPath, String _dirName) {
        File file = new File(_fullPath, _dirName);
        
        if (file != null)                     
         if( file.mkdirs() )
          return file.getPath();
        
        return "";
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

    public int GetDrawableResourceId(String _resName) {
        return controls.GetDrawableResourceId(_resName);
    }

    public Drawable GetDrawableResourceById(int _resID) {
        return controls.GetDrawableResourceById(_resID);
    }

    //BY ADiV
    public void SetBackgroundImage(String _imageIdentifier, int _scaleType) {

        if (mImageBackground == null) {
            return;
        }

        Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(_imageIdentifier));

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

        if (mImageBackground == null) {
            return;
        }

        if (mImageBackground.getScaleType() != ImageView.ScaleType.MATRIX) {
            mImageBackground.setScaleType(ImageView.ScaleType.MATRIX);
        }

        Matrix matrix = new Matrix();

        if (matrix == null) {
            return;
        }

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
        
        if (id == 0) return "";
        
        String value = this.controls.activity.getResources().getQuantityString(id, _quantity, _quantity);

        if (value == null) return "";        

        return value;
    }

    //by thierrydijoux
    public String GetStringResourceByName(String _resName) {
        int id = this.controls.activity.getResources().getIdentifier(_resName, "string", this.controls.activity.getPackageName());
        
        if (id == 0) return "";        

        String value = "" + this.controls.activity.getResources().getText(id);
        
        return value;
    }

    public ActionBar GetActionBar() {
        if (!jCommons.IsAppCompatProject(controls)) {
            return (controls.activity).getActionBar();
        } else {
            return null;
        }
    }
    
    // By ADiV
    public String GetStringReplace(String _strIn, String _strFind, String _strReplace){
    	if(_strIn == null) return "";
    	if( (_strIn.length() <= 0) || (_strIn.length() < _strFind.length()) ) return "";
    	
    	return _strIn.replace(_strFind, _strReplace);
    }
    
    public int GetStringPos( String _strFind, String _strData ){
    	if((_strFind == null) || (_strData == null)) return -1;
    	
    	return _strData.indexOf(_strFind); 
    }
    
    public int GetStringPosUpperCase( String _strFind, String _strData ){
    	if((_strFind == null) || (_strData == null)) return -1;
    	
    	return _strData.toUpperCase(Locale.US).indexOf(_strFind.toUpperCase(Locale.US)); 
    }
    
    public String GetStringCopy( String _strData, int _startIndex, int _endIndex ){
    	if(_strData == null) return "";
    	if(_startIndex > _endIndex) return "";
    	
    	return _strData.substring(_startIndex, _endIndex);
    }
    
    public int GetStringLength( String _strData ){
        if(_strData == null) return 0;
    	
    	return _strData.length();
    }
    
    public String GetStringCapitalize(String _strIn) {
        String retStr = _strIn;
        
        try { // We can face index out of bound exception if the string is null
            retStr = _strIn.substring(0, 1).toUpperCase(Locale.getDefault()) + _strIn.substring(1);
        }catch (Exception e){
        	return _strIn;
        }
        
        return retStr;
    }
    
    public String GetStringUpperCase(String _strIn) {
    	return _strIn.toUpperCase(Locale.getDefault());
    }
    
    //by ADiV
    public String GetStripAccents(String _str) {
        _str = Normalizer.normalize(_str, Normalizer.Form.NFD);
        
        if (_str == null) return "";
        
        _str = _str.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
        return _str;
    }
    
    //by ADiV
    public String GetStripAccentsUpperCase(String _str) {
        _str = Normalizer.normalize(_str, Normalizer.Form.NFD);
        
        if (_str == null) return "";
        
        _str = _str.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
        return _str.toUpperCase(Locale.getDefault());
    }

    // BY ADiV
    public int GetBatteryPercent() {

        int ret = -1;

        if (Build.VERSION.SDK_INT >= 21) {
            //[ifdef_api21up]
            BatteryManager bm = (BatteryManager) this.controls.activity.getSystemService(this.controls.activity.BATTERY_SERVICE);
            if (bm != null) {
                ret = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
            }
            //[endif_api21up]

        } else {

            IntentFilter iFilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
            if (iFilter == null) {
                return ret;
            }
            Intent batteryStatus = this.controls.activity.registerReceiver(null, iFilter);

            int level = batteryStatus != null ? batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) : -1;
            int scale = batteryStatus != null ? batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1) : -1;

            double batteryPct = level / (double) scale;

            ret = (int) (batteryPct * 100);
        }

        return ret;
    }

    //by  ADiV
    public int GetStatusBarHeight() {

        int resourceId = this.controls.activity.getResources().getIdentifier("status_bar_height", "dimen", "android");

        if (resourceId > 0) {
            return this.controls.activity.getResources().getDimensionPixelSize(resourceId);
        } else {
            return 0;
        }

    }

    //by  ADiV
    public int GetNavigationHeight() {

        int resourceId = this.controls.activity.getResources().getIdentifier("navigation_bar_height", "dimen", "android");

        if (resourceId > 0) {
            return this.controls.activity.getResources().getDimensionPixelSize(resourceId);
        } else {
            return 0;
        }
    }

    //by ADiV Software
    public int GetContextTop() {
        ViewGroup view = ((ViewGroup) this.controls.activity.findViewById(android.R.id.content));

        if (view != null) {
            return view.getTop();
        } else {
            return 0;
        }

    }

    // We assign the density for the correct scaling of assets images

    public int GetJavaLastId() {
        return this.controls.GetJavaLastId();
    }

    public void SetDensityAssets(int _density) {
        this.controls.SetDensityAssets(_density);
    }

    // -------------------------------------------------------------------------
//  Android Device
// -------------------------------------------------------------------------
// Result: Phone Number - LORDMAN
    public String GetDevPhoneNumber() {
        String f = "";

        TelephonyManager telephony = (TelephonyManager) this.controls.activity.getSystemService(Context.TELEPHONY_SERVICE);
        if (telephony != null) {
            try {
                f = telephony.getLine1Number();
            } catch (SecurityException ex) {
                Log.e("getDevPhoneNumber", ex.getMessage());
            }
        }

        if (f == null) return "";        

        return f;
    }

/*
 * To disableAction-bar Icon and Title, you must do two things:
 setDisplayShowHomeEnabled(false);  // hides action bar icon
 setDisplayShowTitleEnabled(false); // hides action bar title
 */

    //Result: Device ID - LORDMAN
//Remarks : Nexus7 (no moblie device) -> Crash : fixed code - Simon
//ANDROID_ID - Added by Tomash
    @SuppressLint("NewApi")
    public String GetDevDeviceID() {
        String devid = "";
        try {
            TelephonyManager telephony = (TelephonyManager) this.controls.activity.getSystemService(Context.TELEPHONY_SERVICE);

            if (telephony == null) return "";            

            // Need system app - android.permission.READ_PRIVILIGED_PHONE_STATE
            //devid = telephony.getDeviceId();

            if (devid == "") return "";            

            if (devid == "")             
        	 devid = Secure.getString(this.controls.activity.getContentResolver(), Secure.ANDROID_ID);            

        } catch (SecurityException e) //ExceptionExceptionException
        {
            e.printStackTrace();
        }        

        return devid;
    }

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
        Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier));

        if (d != null) // by ADiV
        {
            jCommons.ActionBarSetIcon(controls, d);
        }
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
        if (pm == null) {
            return false;
        }
        try {
            pm.getPackageInfo(_packagename, PackageManager.GET_ACTIVITIES);
            return true;
        } catch (NameNotFoundException e) {
            return false;
        }
    }

    // By ADiV
    public int GetVersionCode() {
        PackageManager pm = controls.activity.getPackageManager();
        if (pm == null) {
            return 0;
        }
        try {
            PackageInfo pinfo = pm.getPackageInfo(controls.activity.getPackageName(), 0);
            return pinfo.versionCode;
        } catch (NameNotFoundException e) {
            return 0;
        }
    }

    //By ADiV
    public String GetVersionName() {
        PackageManager pm = controls.activity.getPackageManager();
        
        if (pm == null) return "";
        
        try {
            PackageInfo pinfo = pm.getPackageInfo(controls.activity.getPackageName(), 0);
            return pinfo.versionName;
        } catch (NameNotFoundException e) {
            return "";
        }
    }

    // by ADiV
    private String GetAppVersion(String patternString, String inputString) {
        try {
            //Create a pattern
            Pattern pattern = Pattern.compile(patternString);
            
            if (null == pattern) return "";            

            //Match the pattern string in provided string
            Matcher matcher = pattern.matcher(inputString);
            if (null != matcher && matcher.find()) {
                String r = matcher.group(1);

                if (r == null) return "";                

                return r;
            }

        } catch (PatternSyntaxException ex) {

            ex.printStackTrace();
        }

        return "";
    }

    // by ADiV
    public String GetVersionPlayStore(String appUrlString) {
        final String currentVersion_PatternSeq = "<div[^>]*?>Current\\sVersion</div><span[^>]*?>(.*?)><div[^>]*?>(.*?)><span[^>]*?>(.*?)</span>";
        final String appVersion_PatternSeq = "htlgb\">([^<]*)</s";

        BufferedReader inReader = null;
        URLConnection uc = null;
        StringBuilder urlData = new StringBuilder();

        URL url;

        try {
            url = new URL(appUrlString);
        } catch (MalformedURLException e) {
            return "";
        }

        if (url == null) return "";
        
        try {
            uc = url.openConnection();
            
            if (uc == null) 
                return "";
            
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

        if (versionString == "") return "";        

        // get version from "htlgb">X.X.X</span>
        versionString = GetAppVersion(appVersion_PatternSeq, versionString);
        
        if (versionString == "") return "";
        
        return versionString;
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
        if (mCustomToast == null) {
            return;
        }
        mCustomToast.setGravity(_gravity, 0, 0);
        mCustomToast.setDuration(Toast.LENGTH_LONG);
        _layout.setVisibility(View.VISIBLE);
        mCustomToast.setView(_layout);
        mCustomToast.show();

    }

    public void ShowCustomMessage(View _layout, int _gravity, int _lenghTimeSecond) {

        mCustomToast = new Toast(controls.activity);
        if (mCustomToast == null) {
            return;
        }
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

        if (controls.screenWidth <= controls.screenHeight) {
            r = 1; // Portrait
        }
        if (controls.screenWidth > controls.screenHeight) {
            r = 2; // LandScape
        }

        return r;
    }

    public int GetScreenDpi() {
        String r = "";
        DisplayMetrics metrics = new DisplayMetrics();
        if (metrics == null) {
            return 0;
        }
        controls.activity.getWindowManager().getDefaultDisplay().getMetrics(metrics);
        return metrics.densityDpi;
    }
    
    public double GetScreenRealXdpi() {
        double r = 0.0;
        DisplayMetrics metrics = new DisplayMetrics();
        if (metrics == null) {
            return 0;
        }
        controls.activity.getWindowManager().getDefaultDisplay().getMetrics(metrics);
        return metrics.xdpi;
    }
    
    public double GetScreenRealYdpi() {
        double r = 0.0;
        DisplayMetrics metrics = new DisplayMetrics();
        if (metrics == null) {
            return 0;
        }
        controls.activity.getWindowManager().getDefaultDisplay().getMetrics(metrics);
        return metrics.ydpi;
    }  	
	
    public String GetScreenDensity() {
        String r = "";
        DisplayMetrics metrics = new DisplayMetrics();
        
        if (metrics == null) return "";
        
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
            } else {
                r = "CUSTOM:" + String.valueOf(density);
            }
        return r;
    }

    public String GetScreenSize() {
        String r = "";

        if ((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK) == Configuration.SCREENLAYOUT_SIZE_XLARGE) {
            r = "XLARGE";
        } else if ((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK)
                == Configuration.SCREENLAYOUT_SIZE_LARGE) {
            r = "LARGE";
        } else if ((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK)
                == Configuration.SCREENLAYOUT_SIZE_NORMAL) {
            r = "NORMAL";
        } else if ((controls.activity.getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK)
                == Configuration.SCREENLAYOUT_SIZE_SMALL) {
            r = "SMALL";
        }
        return r;
    }

    public void LogDebug(String _tag, String _msg) {
        Log.d(_tag, _msg);  //debug
    }

    public void Vibrate(int _milliseconds) {
        Vibrator vib = (Vibrator) controls.activity.getSystemService(Context.VIBRATOR_SERVICE);
        if (vib == null) {
            return;
        }
        if (vib.hasVibrator()) {
            vib.vibrate(_milliseconds);
        }
    }

    public void Vibrate(long[] _millisecondsPattern) {
        Vibrator vib = (Vibrator) controls.activity.getSystemService(Context.VIBRATOR_SERVICE);
        if (vib == null) {
            return;
        }
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
        
        if (actionBar == null) 
            return "";
        
        return (String) actionBar.getTitle();
    }

    public String GetSubTitleActionBar() {
        ActionBar actionBar = this.controls.activity.getActionBar();
        
        if (actionBar == null) 
            return "";
        
        return (String) actionBar.getSubtitle();
    }

    //https://xjaphx.wordpress.com/2011/10/02/store-and-use-files-in-assets/
    public String CopyFromAssetsToInternalAppStorage(String _filename) {
        InputStream is = null;
        FileOutputStream fos = null;
        String PathDat = controls.activity.getFilesDir().getAbsolutePath();
        String _filename2 = "";

        try {
            _filename2 = _filename.substring(_filename.lastIndexOf("/") + 1); //by Tomash - add support for folders in assets

            File outfile = new File(PathDat + "/" + _filename2);
            // if file doesnt exists, then create it
            if (!outfile.exists()) {
                outfile.createNewFile();
            }
            fos = new FileOutputStream(outfile);  //save to data/data/your_package/files/your_file_name
            is = controls.activity.getAssets().open(_filename);
            int size = is.available();
            byte[] buffer = new byte[size];
            for (int c = is.read(buffer); c != -1; c = is.read(buffer)) {
                fos.write(buffer, 0, c);
            }
            is.close();
            fos.close();
        } catch (IOException e) {
            // Log.i("ShareFromAssets","fail!!");
            e.printStackTrace();
        }

        if (PathDat == null) return "";        

        return PathDat + "/" + _filename2;
    }

    public String GetPathFromAssetsFile(String _assetsFileName) {
        String r = LoadFromAssets(_assetsFileName);
        
        if (r == null) return "";
        
        return r;
    }

    public Bitmap GetImageFromAssetsFile(String _assetsImageFileName) {
        String path = LoadFromAssets(_assetsImageFileName);
        BitmapFactory.Options bo = new BitmapFactory.Options();
        if (bo == null) {
            return null;
        }
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
        String _filename2 = _filename.substring(_filename.lastIndexOf("/") + 1); //by Tomash - add support for folders in assets
        CopyFromInternalAppStorageToEnvironmentDir(_filename2, _environmentDir);
    }

    public void ToggleSoftInput() {
        InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm == null) {
            return;
        }
        imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
    }

    public void HideSoftInput() {
        InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm == null) {
            return;
        }
        imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
        /*
        if (controls.activity.getCurrentFocus() != null) {
            imm.hideSoftInputFromWindow(controls.activity.getCurrentFocus().getWindowToken(), 0);
            imm.hideSoftInputFromInputMethod(controls.activity.getCurrentFocus().getWindowToken(), 0);
        }*/
    }

    public void HideSoftInput(View _view) {
        InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm == null) {
            return;
        }
        imm.hideSoftInputFromWindow(_view.getWindowToken(), 0);
    }


    public void ShowSoftInput() {
        InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm == null) {
            return;
        }
        imm.toggleSoftInput(InputMethodManager.SHOW_IMPLICIT,0);
        //imm.toggleSoftInput(InputMethodManager.RESULT_SHOWN, 0);;
    }

    public void SetSoftInputMode(int _inputMode) {

        switch (_inputMode) {
            case 0:
                controls.activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING);
                break;
            case 1:
                controls.activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
                break;
            case 2:
                controls.activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
                break;
        }

    }

    //thanks to Mladen
    public String GetDeviceModel() {
        return android.os.Build.MODEL;
    }

    public String GetDeviceManufacturer() {
        return android.os.Build.MANUFACTURER;
    }

    public void SetKeepScreenOn(boolean _value) {
        if (_value) {
            controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        } else {
            controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        }
    }

    public void SetTurnScreenOn(boolean _value) {

        if (Build.VERSION.SDK_INT >= 27) {
            //[ifdef_api27up]
            controls.activity.setTurnScreenOn(_value);
            //[endif_api27up]
        } else {
            if (_value) {
                controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
            } else {
                controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
            }
        }

    }

    public void SetAllowLockWhileScreenOn(boolean _value) {
        if (_value) {
            controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON);
        } else {
            controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_ALLOW_LOCK_WHILE_SCREEN_ON);
        }
    }

    public void SetShowWhenLocked(boolean _value) {

        if (Build.VERSION.SDK_INT >= 27) {
            //[ifdef_api27up]
            controls.activity.setShowWhenLocked(_value);
            //[endif_api27up]
        } else {
            if (_value) {
                controls.activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
            } else {
                controls.activity.getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
            }
        }
    }

    public Uri ParseUri(String _uriAsString) {
        return Uri.parse(_uriAsString);
    }

    public String UriToString(Uri _uri) {
        if (_uri == null) return "";        

        String r = _uri.toString();

        if (r == null) return "";
        
        return r;
    }

    // ref. http://www.android-examples.com/get-display-ip-address-of-android-phone-device-programmatically/
    public int GetNetworkStatus() {
        boolean WIFI = false;
        boolean MOBILE = false;
        int r = 0; //NOT_CONNECTED
        ConnectivityManager CM = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (CM == null) {
            return 0;
        }
        NetworkInfo[] networkInfo = CM.getAllNetworkInfo();
        for (NetworkInfo netInfo : networkInfo) {
            if (netInfo.getTypeName().equalsIgnoreCase("WIFI")) {
                if (netInfo.isConnected()) {
                    WIFI = true;
                }
            }
            if (netInfo.getTypeName().equalsIgnoreCase("MOBILE")) {
                if (netInfo.isConnected()) {
                    MOBILE = true;
                }
            }
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
        String strIp = "";
        String r = "";
        try {
            for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces();
                 en.hasMoreElements(); ) {
                NetworkInterface networkinterface = en.nextElement();
                for (Enumeration<InetAddress> enumIpAddr = networkinterface.getInetAddresses(); enumIpAddr.hasMoreElements(); ) {
                    InetAddress inetAddress = enumIpAddr.nextElement();
                    if (!inetAddress.isLoopbackAddress()) {
                        strIp = inetAddress.getHostAddress();

                        if (strIp == null) {
                            return "";
                        }

                        boolean isIPv4 = strIp.indexOf(':') < 0;
                        if (isIPv4) {
                            return strIp;
                        }
                        if (!isIPv4) {
                            int delim = strIp.indexOf('%'); // drop ip6 zone suffix

                            if (delim < 0) {
                                r = strIp.toUpperCase(Locale.ROOT);
                            } else {
                                r = strIp.substring(0, delim).toUpperCase(Locale.ROOT);
                            }
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
        
        if (mWifi == null) return "";
        
        //String ip = Formatter.formatIpAddress(
        int ipAddress = mWifi.getConnectionInfo().getIpAddress();
        String sIP = String.format(Locale.ROOT, "%d.%d.%d.%d",
                (ipAddress & 0xff),
                (ipAddress >> 8 & 0xff),
                (ipAddress >> 16 & 0xff),
                (ipAddress >> 24 & 0xff));

        if (sIP == null) return "";
        
        return sIP;
    }

    /**
     * Calculate the broadcast IP we need to send the packet along. ref. http://www.ece.ncsu.edu/wireless/MadeInWALAN/AndroidTutorial/
     */
    public String GetWifiBroadcastIPAddress() throws IOException {
        String r = "";
        //WifiManager mWifi = (WifiManager) controls.activity.getSystemService(Context.WIFI_SERVICE);
        WifiManager mWifi = (WifiManager) this.controls.activity.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        
        if (mWifi == null) return "";
        
        // DhcpInfo  is a simple object for retrieving the results of a DHCP request
        DhcpInfo dhcp = mWifi.getDhcpInfo();

        if (dhcp == null) return "";        

        int broadcast = (dhcp.ipAddress & dhcp.netmask) | ~dhcp.netmask;
        byte[] quads = new byte[4];
        for (int k = 0; k < 4; k++) {
            quads[k] = (byte) ((broadcast >> k * 8) & 0xFF);
        }
        // Returns the InetAddress corresponding to the array of bytes.
        // The high order byte is quads[0].
        r = InetAddress.getByAddress(quads).getHostAddress();

        if (r == null)  return "";        

        return r;
    }

    //https://xjaphx.wordpress.com/2011/10/02/store-and-use-files-in-assets/
    public String LoadFromAssetsTextContent(String _filename) {
        String str = "";
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
            if (str == null) return "";            

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
    public String[] GetFileList(String _envPath) {
        ArrayList<String> Folders = new ArrayList<String>();

        File f = new File(_envPath);

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

    public boolean FileExists(String _fullFileName) {
        File f = new File(_fullFileName);

        if (f == null) {
            return false;
        }

        return f.isFile();
    }

    public boolean DirectoryExists(String _fullDirectoryName) {
        File f = new File(_fullDirectoryName);

        if (f == null) {
            return false;
        }

        return f.isDirectory();
    }


    //http://blog.scriptico.com/category/dev/java/android/
    public void Minimize() {
        Intent main = new Intent(Intent.ACTION_MAIN);
        if (main == null) {
            return;
        }
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

    public void MoveTaskToFront() {
        ActivityManager am = (ActivityManager) controls.activity.getSystemService(Context.ACTIVITY_SERVICE);
        if (am == null) {
            return;
        }
        //List<RunningTaskInfo> recentTasks = am.getRunningTasks(Integer.MAX_VALUE);

        //for (int i = 0; i < recentTasks.size(); i++){

        //if (recentTask.get(i).baseActivity.toShortString().indexOf(this.controls.activity.getPackageName()) > -1) {

        // Need system app - android.permission.REORDER_TASKS
        //am.moveTaskToFront(controls.activity.getTaskId(), 0);

        //}
        //}
    }

    public String GetTaskInFront() {
        String taskid = "";
        if (android.os.Build.VERSION.SDK_INT >= 22) {
            // intentionally using string value as Context.USAGE_STATS_SERVICE was
            // strangely only added in API 22 (LOLLIPOP_MR1)
            @SuppressWarnings("WrongConstant")
            UsageStatsManager usm = (UsageStatsManager) controls.activity.getSystemService(Context.USAGE_STATS_SERVICE);
            long time = System.currentTimeMillis();
            List<UsageStats> appList = usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY,
                    time - 1000 * 1000, time);
            if (appList != null && appList.size() > 0) {
                SortedMap<Long, UsageStats> mySortedMap = new TreeMap<Long, UsageStats>();
                for (UsageStats usageStats : appList) {
                    mySortedMap.put(usageStats.getLastTimeUsed(),
                            usageStats);
                }
                if (mySortedMap != null && !mySortedMap.isEmpty()) {
                    taskid = mySortedMap.get(mySortedMap.lastKey()).getPackageName();
                }
            }
        } else {
            ActivityManager am = (ActivityManager) controls.activity.getSystemService(Context.ACTIVITY_SERVICE);
            List<ActivityManager.RunningTaskInfo> taskInfo = am.getRunningTasks(1);

            taskid = taskInfo.get(0).topActivity.getPackageName();
        }

        if (taskid == null) return "";
        
        return taskid;
    }

    public Bitmap GetApplicationIcon(String packageName) {
        Bitmap dw = null;
        
        try {
            dw = drawableToBitmap(this.controls.activity.getPackageManager().getApplicationIcon(packageName));
        } catch (PackageManager.NameNotFoundException e) {
            Log.i("GetApplicationIcon", "NameNotFoundException");            
        }
        
        if( dw != null ) return dw;
        
        try {
            dw = drawableToBitmap(this.controls.activity.getPackageManager().getApplicationIcon(this.controls.activity.getPackageName()));
        } catch (PackageManager.NameNotFoundException e) {
            Log.i("GetApplicationIcon", "DefaultNameNotFoundException");            
        }
        
        return dw;
    }

    public String GetApplicationName(String packageName) {
        String appname = "";
        ApplicationInfo ai;
        try {
            PackageManager pm = this.controls.activity.getPackageManager();
            ai = pm.getApplicationInfo(packageName, 0);
            appname = (String) pm.getApplicationLabel(ai);
        } catch (PackageManager.NameNotFoundException e) {
            Log.i("GetApplicationIcon", "NameNotFoundException");
            return "";
        }
        return appname;
    }

    public String[] GetInstalledAppList() {
        ArrayList<String> Packages = new ArrayList<String>();
        //PackageManager pm = this.controls.activity.getPackageManager();
        List<PackageInfo> packs = this.controls.activity.getPackageManager().getInstalledPackages(0);
        for (int i = 0; i < packs.size(); i++) {
            PackageInfo p = packs.get(i);
            Packages.add(p.applicationInfo.packageName);
        }
        String sPackages[] = Packages.toArray(new String[Packages.size()]);
        return sPackages;
    }

    //RequestRuntimePermission
    public void RequestUsageStatsPermission() {
        if (Build.VERSION.SDK_INT >= 23 ) {  //Build.VERSION_CODES.M
            Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
            if (intent == null) {
                return;
            }
            controls.activity.startActivity(intent);
        }
    }

    //Check USAGE_STATS permission
    public boolean isUsageStatsAllowed() {
        if (Build.VERSION.SDK_INT < 23 ) {  //Build.VERSION_CODES.M
            return true;
        } else {
            AppOpsManager appOps = (AppOpsManager) controls.activity.getSystemService(Context.APP_OPS_SERVICE);
            int mode = appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), this.controls.activity.getPackageName());
            if (mode == AppOpsManager.MODE_ALLOWED) {
                return true;
            } else {
                return false;
            }
        }
    }

    public void Restart(int _delay) {
        PendingIntent intent = PendingIntent.getActivity(controls.activity.getBaseContext(), 0,
                                new Intent(controls.activity.getIntent()), PendingIntent.FLAG_CANCEL_CURRENT);
        
        if (intent == null)   return;
        
        AlarmManager manager = (AlarmManager) controls.activity.getSystemService(Context.ALARM_SERVICE);
        
        if (manager == null) return;
        
        manager.set(AlarmManager.RTC, System.currentTimeMillis() + _delay, intent);
        System.exit(2);
    }

    public String UriEncode(String _message) {
        String r = Uri.encode(_message);
        
        if (r == null) return "";
        
        return r;
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

    public int GetSettingsSystemInt(String _strKey) {
        try {
            return android.provider.Settings.System.getInt(controls.activity.getContentResolver(), _strKey);
        } catch (android.provider.Settings.SettingNotFoundException e) {
            return -1;
        }
    }

//https://developer.android.com/reference/android/provider/Settings.System

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
    public int GetScreenWidth() {
        int w = controls.appLayout.getWidth();

        if (w <= 0) {
            w = controls.screenWidth;
        }

        return w;
    }

    //by ADiV
    public int GetScreenHeight() {
        int h = controls.appLayout.getHeight();

        if (h <= 0) {
            h = controls.screenHeight;
        }

        return h;
    }

    //by ADiV
    public boolean IsInMultiWindowMode() {
        boolean r = false;
        if (Build.VERSION.SDK_INT >= 24) {
            //[ifdef_api24up]
            if (((Activity) controls.activity).isInMultiWindowMode()) {
                r = true;
            }
            //[endif_api24up]
        }
        return r;
    }

    //by ADiV
    public int GetRealScreenWidth() {
        DisplayMetrics displaymetrics = new DisplayMetrics();

        if (displaymetrics == null) {
            return 0;
        }

        if (Build.VERSION.SDK_INT >= 17) {
            //[ifdef_api17up]
            controls.activity.getWindowManager().getDefaultDisplay().getRealMetrics(displaymetrics); //need min Api  17
            //[endif_api17up]
        }

        return displaymetrics.widthPixels;
    }

    //by ADiV
    public int GetRealScreenHeight() {
        DisplayMetrics displaymetrics = new DisplayMetrics();

        if (displaymetrics == null) {
            return 0;
        }

        if (Build.VERSION.SDK_INT >= 17) {
            //[ifdef_api17up]
            controls.activity.getWindowManager().getDefaultDisplay().getRealMetrics(displaymetrics);
            //[endif_api17up]
        }

        return displaymetrics.heightPixels;
    }

    public double GetScreenRealSizeInInches() {
        double r = 0.0;
        double screen_width = 0.0;
        double screen_height = 0.0;

        if(GetScreenRealXdpi() != 0)
        {screen_width = GetRealScreenWidth() / GetScreenRealXdpi();}
		
        if(GetScreenRealYdpi() != 0)
        screen_height = GetRealScreenHeight() / GetScreenRealYdpi();		
		
        r = Math.sqrt(screen_width*screen_width + screen_height*screen_height);	
		
        return r;
    } 	
	
    //by ADiV
    public String GetSystemVersionString() {
        return android.os.Build.VERSION.RELEASE;
    }

    public ByteBuffer GetJByteBuffer(int _width, int _height) {
        return ByteBuffer.allocateDirect(_width * _height * 4);
    }

    public ByteBuffer GetByteBufferFromImage(Bitmap _bitmap) {
        if (_bitmap == null) {
            return null;
        }
        int w = _bitmap.getWidth();
        int h = _bitmap.getHeight();
        ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(w * h * 4);
        _bitmap.copyPixelsToBuffer(graphicBuffer);
        graphicBuffer.rewind();  //reset position
        return graphicBuffer;
    }

    private String getRealPathFromURI(Uri contentUri) {
        if (contentUri == null) {
            return "";
        }

        String path;
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

        if (path == null) {
            return "";
        }

        return path;
    }

    private String getRealPathFromURI_API19(Uri uri) {
        if (uri == null) {
            return "";
        }

        String filePath = "";
        String wholeID = "";

        //[ifdef_api19up]
        if (Build.VERSION.SDK_INT >= 19) {
            wholeID = DocumentsContract.getDocumentId(uri);
        }
        //[endif_api19up]

        if (wholeID == null) {
            return "";
        }
        if (wholeID.equals("")) {
            return "";
        }

        String id = wholeID.split(":")[1];
        String[] column = {MediaStore.Images.Media.DATA};
        // where id is equal to
        String sel = MediaStore.Images.Media._ID + "=?";
        Cursor cursor = controls.activity.getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                column, sel, new String[]{id}, null);
        if (cursor == null) {
            return "";
        }
        int columnIndex = cursor.getColumnIndex(column[0]);
        if (cursor.moveToFirst()) {
            filePath = cursor.getString(columnIndex);
        }
        cursor.close();

        if (filePath == null) {
            return "";
        }

        return filePath;
    }

    public String GetRealPathFromURI(Uri _Uri) {
        if (_Uri == null) return "";        

        String path;

        if (Build.VERSION.SDK_INT < 19) {
            path = getRealPathFromURI(_Uri);
        } else {
            path = getRealPathFromURI_API19(_Uri);
        }

        if (path == null) return "";
        
        return path;
    }

    //by Tomash
    //refactored by jmpessoa
    public void StartDefaultActivityForFile(String _filePath, String _mimeType) {
        File file = new File(_filePath);
        if (file == null) {
            return;
        }
        Intent intent = new Intent(Intent.ACTION_VIEW);
        if (intent == null) {
            return;
        }
        Uri newUri = jSupported.FileProviderGetUriForFile(controls, file);
        if (jSupported.IsAppSupportedProject()) {
            intent.setDataAndType(newUri, _mimeType);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK |
                    Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET |
                    Intent.FLAG_GRANT_READ_URI_PERMISSION);
        } else {
            intent.setDataAndType(Uri.parse("file://" + file), _mimeType);
        }
        controls.activity.startActivity(intent);
    }

    public String CopyFileFromUri(Uri _srcUri, String _outputDir) {
        if (_srcUri == null) return "";
        
        String fileName = "";
        ContentResolver cr = controls.activity.getContentResolver();

        if (cr == null) return "";
        
        String[] projection = {MediaStore.MediaColumns.DISPLAY_NAME};
        Cursor metaCursor = cr.query(_srcUri, projection, null, null, null);

        if (metaCursor == null) return "";
        
        try {
            if (metaCursor.moveToFirst()) {
                fileName = metaCursor.getString(0);
            }
        } finally {
            metaCursor.close();
        }

        if (fileName.equals("")) //fixed
            return "";        

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

    }

    public void RunOnUiThread(final int _tag) {
        controls.activity.runOnUiThread(new Runnable() {
            public void run() {
                controls.pOnRunOnUiThread(PasObj, _tag);
            }
        });
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

    public void CopyStringToClipboard(String _txt) {
        ClipData cdata = ClipData.newPlainText("text", _txt);
        
        if(cdata == null) return;
        
        mClipBoard.setPrimaryClip(cdata);
    }

    public String PasteStringFromClipboard() {
        ClipData cdata = mClipBoard.getPrimaryClip();
        
        if(cdata == null) return "";
        
        ClipData.Item item = cdata.getItemAt(0);
        
        if(item == null) return "";
        
        return item.getText().toString();
    }

    //Android 11: creating a document.
    public void RequestCreateFile(String _uriAsString, String _fileMimeType, String _fileName, int _requestCode) {
    	
    	// Requires API level 19
    	if( android.os.Build.VERSION.SDK_INT < 19 ) return;

        Uri pickerInitialUri = Uri.parse(_uriAsString);
        
        // Requires API level 19
        Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType(_fileMimeType); //"application/pdf"

        //For use with ACTION_CREATE_DOCUMENT to specify an initial file name.
        intent.putExtra(Intent.EXTRA_TITLE, _fileName); //"invoice.pdf"

        // Optionally, specify a URI for the directory that should be opened in
        // the system file picker when your app creates the document.
        if (Build.VERSION.SDK_INT >= 26) {
            //[ifdef_api26up]
            intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, pickerInitialUri);
            //[endif_api26up]
        }
        controls.activity.startActivityForResult(intent, _requestCode);
    }

    //Android 11:  Request code for selecting  document.
    public void RequestOpenFile(String _uriAsString, String _fileMimeType, int _requestCode) {
    	
    	// Requires API level 19
    	if( android.os.Build.VERSION.SDK_INT < 19 ) return;

        Uri pickerInitialUri = Uri.parse(_uriAsString);

        //Requires API level 19
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType(_fileMimeType); //"application/pdf"

        //For use with ACTION_CREATE_DOCUMENT to specify an initial file name.
        //intent.putExtra(Intent.EXTRA_TITLE, _fileName); //"invoice.pdf"

        if (Build.VERSION.SDK_INT >= 18) {
            intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, false);
        }

        // Optionally, specify a URI for the file that should appear in the
        // system file picker when it loads.
        if (Build.VERSION.SDK_INT >= 26) {
            //[ifdef_api26up]
            intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, pickerInitialUri);
            //[endif_api26up]
        }

        //final Intent chooserIntent = Intent.createChooser(intent, "Open File");

        controls.activity.startActivityForResult(intent, _requestCode);
    }

    //Android 11:
    public void RequestOpenDirectory(String _uriAsString, int _requestCode) {

    	// Requires API level 21
    	if( android.os.Build.VERSION.SDK_INT < 21 ) return;
    	
        Uri uriToLoad = Uri.parse(_uriAsString);

        // Choose a directory using the system's file picker. Requires API level 21
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);

        // Provide read access to files and sub-directories in the user-selected
        // directory.
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

        // Optionally, specify a URI for the directory that should be opened in
        // the system file picker when it loads.
        if (Build.VERSION.SDK_INT >= 26) {
            //[ifdef_api26up]
            intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI, uriToLoad);
            //[endif_api26up]
        }
        controls.activity.startActivityForResult(intent, _requestCode);
    }


    //https://developer.android.com/training/data-storage/shared/documents-files#java
    public String[] GetUriMetaData(Uri _treeUri) {

        //listFiles(_treeUri);

        Cursor cursor= null;

        Uri uri = _treeUri;

        ArrayList<String> data = new ArrayList<String>();
        // The query, because it only applies to a single document, returns only
        // one row. There's no need to filter, sort, or select fields,
        // because we want all fields for one document.
        if (Build.VERSION.SDK_INT >= 16) {   //android 4.1

            if (Build.VERSION.SDK_INT >= 21) {
                //[ifdef_api21up]
                uri = DocumentsContract.buildDocumentUriUsingTree(_treeUri, DocumentsContract.getTreeDocumentId(_treeUri));
                //[ifdef_api21up]
            }

            try {
                cursor = controls.activity.getContentResolver().query(_treeUri, null, null, null, null, null);
                    // moveToFirst() returns false if the cursor has 0 rows. Very handy for
                    // "if there's anything to look at, look at it" conditionals.
                if (cursor != null && cursor.moveToFirst()) {

                        cursor.moveToFirst();
                        while (!cursor.isAfterLast()) {
                            //your code to implement

                           // Note it's called "Display Name". This is
                           // provider-specific, and might not necessarily be the file name.
                           String displayName = "";
                           
                           int iColum = cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME);
                           if(iColum >= 0) displayName = cursor.getString(iColum);

                           int sizeIndex = cursor.getColumnIndex(OpenableColumns.SIZE);
                            // If the size is unknown, the value stored is null. But because an
                           // int can't be null, the behavior is implementation-specific,
                           // and unpredictable. So as
                           // a rule, check if it's null before assigning to an int. This will
                            // happen often: The storage API allows for remote files, whose
                            // size might not be locally known.
                            String size = null;
                            if (!cursor.isNull(sizeIndex)) {
                                // Technically the column stores an int, but cursor.getString()
                                // will do the conversion automatically.
                                 size = cursor.getString(sizeIndex);
                            } else {
                                 size = "Unknown";
                            }

                            data.add(displayName);
                            Log.i("LAMW", "displayName = " + displayName);
                            cursor.moveToNext();
                        }

                    }
            } finally {
                    if (cursor != null) cursor.close();
            }
        }
        return data.toArray(new String[data.size()]);
    }

    //Android 11:
    public Bitmap GetBitmapFromUri(Uri _treeUri){
       
        Bitmap image=null;
        ParcelFileDescriptor parcelFileDescriptor=null;
        try {

            parcelFileDescriptor = controls.activity.getContentResolver().openFileDescriptor(_treeUri, "r");

            FileDescriptor fileDescriptor = parcelFileDescriptor.getFileDescriptor();

            image = BitmapFactory.decodeFileDescriptor(fileDescriptor);

            parcelFileDescriptor.close();

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return image;
        
    }
    
    
    //Android 11:
    public byte[] LoadBytesFromUri(Uri _toTreeUri) {

        byte[] bytes = new byte[1];

        try {

            ParcelFileDescriptor pfd = controls.activity.getContentResolver().openFileDescriptor(_toTreeUri, "r");
            
            if(pfd == null) return null;            
            if(pfd.getStatSize() > Integer.MAX_VALUE) return null;
            
            FileDescriptor fd = pfd.getFileDescriptor();
            FileInputStream input_file_stream = new FileInputStream(fd);
            bytes = new byte[input_file_stream.available()];
            input_file_stream.read(bytes);
            input_file_stream.close();

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return bytes;
    }    
    
    

    //Android 11:
    public String GetTextFromUri(Uri _treeUri) {
        StringBuilder stringBuilder = new StringBuilder();
        
        if(stringBuilder == null) return "";
        
        InputStream inputStream = null;
        BufferedReader reader = null;

        try {
             inputStream = controls.activity.getContentResolver().openInputStream(_treeUri);
             reader = new BufferedReader(new InputStreamReader(Objects.requireNonNull(inputStream)));
             String line;
             while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
             }
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
        
        return stringBuilder.toString();
    }

    //Android 11:
    public String GetTextFromUriAsString(String _treeUriAsString) {
        StringBuilder stringBuilder = new StringBuilder();
        
        if(stringBuilder == null) return "";
        
        InputStream inputStream = null;
        BufferedReader reader = null;

        Uri _treeUri = Uri.parse(_treeUriAsString);

        try {
            inputStream = controls.activity.getContentResolver().openInputStream(_treeUri);
            reader = new BufferedReader(new InputStreamReader(Objects.requireNonNull(inputStream)));
            String line;
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
        return stringBuilder.toString();
    }

    //Android 11:
    public void TakePersistableUriPermission(Uri _treeUri) {
        final int takeFlags = Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_WRITE_URI_PERMISSION;

        // Check for the freshest data.
        if (Build.VERSION.SDK_INT >= 19) {
            //[ifdef_api19up]
            controls.activity.getContentResolver().takePersistableUriPermission(_treeUri, takeFlags);
            //[endif_api19up]
        }
    }

    //Android 11:
    public void CopyFile(Uri _fromTreeUri, Uri _toTreeUri)  {
        InputStream in=null;
        OutputStream out=null;
        try {
            in  = controls.activity.getContentResolver().openInputStream(_fromTreeUri);
            out = controls.activity.getContentResolver().openOutputStream(_toTreeUri);
                byte[] buf = new byte[1024];
                int len;
                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //Android 11:
    public void SaveImageToUri(Bitmap _bitmap, Uri _toTreeUri) {
        OutputStream out;
        try {
            out = controls.activity.getContentResolver().openOutputStream(_toTreeUri, "w");
            _bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);
            out.close();
            out.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

	
    //Android 11:
    public void SaveImageTypeToUri(Bitmap _bitmap, Uri _toTreeUri, int _type) {
        OutputStream out;
        try {
            out = controls.activity.getContentResolver().openOutputStream(_toTreeUri, "w");


			if(_type == 1)
            {_bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);}
			else if(_type == 2)		
            {	_bitmap.compress(Bitmap.CompressFormat.PNG, 90, out);}
			else if(_type == 3)		
            {
                //_bitmap.compress(Bitmap.CompressFormat.WEBP_LOSSY, 90, out);
                if (android.os.Build.VERSION.SDK_INT < 30)
                {
                   _bitmap.compress(Bitmap.CompressFormat.WEBP, 90, out); // Added in API level 14, Deprecated in API level 30
                }
                else // needs targetSdkVersion API 30
                {
                    _bitmap.compress(Bitmap.CompressFormat.WEBP, 90, out);        // comment here for targetSdkVersion API >= 30!

                    //[ifdef_api30up]

                    // _bitmap.compress(Bitmap.CompressFormat.WEBP_LOSSLESS, 90, out);   //uncomment only here for targetSdkVersion API >= 30!

                     //[endif_api30up]
                }
            } 
				
            out.close();
            out.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }	
	
	
    //Android 11:
    public void SaveBytesToUri(byte[] _bytes, Uri _toTreeUri) {
        OutputStream out=null;
        try {
            out = controls.activity.getContentResolver().openOutputStream(_toTreeUri, "w");
            out.write(_bytes);
            out.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }	
	
    //Android 11:
    public void SaveTextToUri(String _text, Uri _toTreeUri) {
        OutputStream out=null;
        try {
            out = controls.activity.getContentResolver().openOutputStream(_toTreeUri, "w");
            byte[] bytes = _text.getBytes();
            out.write(bytes);
            out.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //Android 11:
    public Uri CreateDirectory(Uri _treeUri, String _directoryName) {
        ContentResolver contentResolver = controls.activity.getContentResolver();
        Uri directoryUri = null;
        try {
            Uri docUri = null;
            if (android.os.Build.VERSION.SDK_INT >= 21) {
                //[ifdef_api21up]
                docUri = DocumentsContract.buildDocumentUriUsingTree(_treeUri, DocumentsContract.getTreeDocumentId(_treeUri));
                directoryUri = DocumentsContract.createDocument(contentResolver, docUri, DocumentsContract.Document.MIME_TYPE_DIR, _directoryName);
                //[endif_api21up]
            }
        } catch (IOException e) {
            //Log.w(TAG, "IOException", e);
        }
        if (directoryUri != null) {

        }
        return directoryUri;
    }

    //Android 11:
    public String[] GetFileList(Uri _treeUri) {

        final ContentResolver resolver = controls.activity.getContentResolver();
        final ArrayList<String> results = new ArrayList<String>();

        if (android.os.Build.VERSION.SDK_INT >= 21) {
            Uri childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(_treeUri, DocumentsContract.getTreeDocumentId(_treeUri));

            Cursor c = null;
            try {
                c = resolver.query(childrenUri, new String[]{DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                                DocumentsContract.Document.COLUMN_MIME_TYPE,
                                DocumentsContract.Document.COLUMN_DISPLAY_NAME},
                        null, null, null);
                while (c.moveToNext()) {
                    final String documentId = c.getString(0);
                    final String mimeType = c.getString(1);
                    final String displayName = c.getString(2);
                    final Uri documentUri = DocumentsContract.buildDocumentUriUsingTree(childrenUri, documentId);
                    if (!DocumentsContract.Document.MIME_TYPE_DIR.equals(mimeType)) {
                        results.add(displayName+"="+documentUri.toString());
                    }
                }
            } catch (Exception e) {
                // Log.w(TAG, "Failed query: " + e);
            } finally {
                // closeQuietly(c);
            	c.close();
            }
        }
        return results.toArray(new String[results.size()]);
    }

    public String[] GetFileList(Uri _treeUri, String _fileExtension) {

        final ContentResolver resolver = controls.activity.getContentResolver();
        final ArrayList<String> results = new ArrayList<String>();

        if (android.os.Build.VERSION.SDK_INT >= 21) {
            Uri childrenUri = DocumentsContract.buildChildDocumentsUriUsingTree(_treeUri, DocumentsContract.getTreeDocumentId(_treeUri));

            Cursor c = null;
            try {
                c = resolver.query(childrenUri, new String[]{DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                                DocumentsContract.Document.COLUMN_MIME_TYPE,
                                DocumentsContract.Document.COLUMN_DISPLAY_NAME},
                        null, null, null);
                while (c.moveToNext()) {
                    final String documentId = c.getString(0);
                    final String mimeType = c.getString(1);
                    final String displayName = c.getString(2);

                    String ext = displayName.substring(displayName.lastIndexOf("."));

                    String fixedExtension = _fileExtension;
                    int lastIndex = _fileExtension.lastIndexOf(".");
                    if (lastIndex < 0) fixedExtension = "." + fixedExtension;

                    final Uri documentUri = DocumentsContract.buildDocumentUriUsingTree(childrenUri, documentId);
                    if (!DocumentsContract.Document.MIME_TYPE_DIR.equals(mimeType)) {
                        if (ext.equals(fixedExtension)) {
                            results.add(displayName + "=" + documentUri.toString());
                        }
                    }
                }
            } catch (Exception e) {
                // Log.w(TAG, "Failed query: " + e);
            } finally {
                // closeQuietly(c);
            	c.close();
            }
        }
        return results.toArray(new String[results.size()]);
    }

    //Android 11:
    public boolean IsTreeUri(Uri _uri) {
        boolean r = false;
        if (Build.VERSION.SDK_INT >= 24) {
            r = DocumentsContract.isTreeUri(_uri);
        }
        return r;
    }

    public String GetMimeTypeFromExtension(String _fileExtension) {
        MimeTypeMap myMime = MimeTypeMap.getSingleton();
        
        if(myMime == null) return "";
        
        String r = myMime.getMimeTypeFromExtension(_fileExtension);
        
        if(r == null) return "";
        
        return r;
    }

    //Android 11:
    public String GetFileNameByUri(Uri uri) {
        String result = "";
        
        final ContentResolver resolver = controls.activity.getContentResolver();
        
        if(resolver == null) return "";
        
        if (uri.getScheme().equals("content")) {
            Cursor cursor = resolver.query(uri, null, null, null, null);
            try {
                if (cursor != null && cursor.moveToFirst()) {
                	int iColum = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
                    if(iColum >= 0) result = cursor.getString(iColum);                    
                }
            } finally {
                if (cursor != null) {
                    cursor.close();
                }
            }
        }
        
        if (result == null) 
            result = uri.getLastPathSegment();
        
        if (result == null) return "";
        	
        return result;
    }

    public Uri GetUriFromFile(String _fullFileName) {
        Uri r = null;
        try {
            r = Uri.fromFile(new File(_fullFileName));
        } catch (Exception e) {
            Toast.makeText(controls.activity,"[GetUriFromFile] File Not found...",Toast.LENGTH_SHORT).show();
        }
        return r;
    }

    public boolean IsAirPlaneModeOn() {
        boolean  r = false;
        try {
            if( android.provider.Settings.System.getInt(controls.activity.getContentResolver(), Settings.Global.AIRPLANE_MODE_ON) == 1 ) {
                r = true;
            }
        } catch(android.provider.Settings.SettingNotFoundException e) {
            r = false;
        }
        return r;
    }

    public boolean IsBluetoothOn() {
        boolean  r = false;
        try {
            if(android.provider.Settings.System.getInt(controls.activity.getContentResolver(), Settings.Global.BLUETOOTH_ON) == 1 ) {
                r = true;
            }
        } catch(android.provider.Settings.SettingNotFoundException e) {
            r = false;
        }
        return r;
    }

    public int GetDeviceBuildVersionApi() {
      return android.os.Build.VERSION.SDK_INT;   //android.os.Build.VERSION.PREVIEW_SDK_INT
    }

    public String GetDeviceBuildVersionRelease() {
        return android.os.Build.VERSION.RELEASE;
    }

}
