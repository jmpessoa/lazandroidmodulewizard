package com.example.appdemo2;
//
//
//[LazAndroidModuleWizard - ver.0.4_r.05 :02-Mar-2014]
//[https://github.com/jmpessoa/lazandroidmodulewizard]

//Android Java Interface for Pascal/Delphi XE5  - 
//[And LAZARUS by jmpessoa@hotmail.com - december 2013]

//
//Developer
//          Simon,Choi / Choi,Won-sik
//                       simonsayz@naver.com
//                       http://blog.naver.com/simonsayz
//
//          LoadMan    / Jang,Yang-Ho
//                       wkddidgh@naver.com
//                       http://blog.naver.com/wkddidgh
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
import android.app.Activity;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.app.ActivityManager.RunningServiceInfo;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.opengl.GLES10;
import android.opengl.GLES20;
import android.opengl.GLSurfaceView.Renderer;
import android.opengl.GLSurfaceView;
import android.opengl.GLU;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.telephony.SmsManager;
import android.telephony.TelephonyManager;
import android.provider.ContactsContract;
import android.provider.MediaStore;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextWatcher;
import android.text.method.ScrollingMovementMethod;
import android.util.DisplayMetrics;
import android.media.MediaPlayer;
import android.net.Uri;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.View.OnClickListener;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.AnimationUtils;
import android.view.animation.TranslateAnimation;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.HorizontalScrollView;
import android.widget.Scroller;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewFlipper;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.IntBuffer;
import java.nio.FloatBuffer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGL10;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.ByteArrayBuffer;
import org.apache.http.util.EntityUtils;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
//import android.database.sqlite.SQLiteOpenHelper;
import android.database.SQLException;
import android.database.sqlite.SQLiteException;
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
private Boolean         enabled  = true;   //

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
      controls.pOnClick(PasObj,Const.Click_Default);
    }
  };
};
layout.setOnClickListener(onClickListener);
//Log.i("Form:","Create");
};

//
public  RelativeLayout GetLayout() {
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
   controls.pOnActive(PasObj); //by jmpessoa
   Log.i("Form:","Show --> OnActive");
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

//
public  void SetVisible ( boolean visible ) {
if (visible) { if (layout.getParent() == null)
               { controls.appLayout.addView(layout); } }
else         { if (layout.getParent() != null)
               { controls.appLayout.removeView(layout); } };
}

//
public  void SetEnabled ( boolean enabled ) {
Log.i("Form:","Parent Form Enabled "+ Integer.toString(layout.getChildCount()));
for (int i = 0; i < layout.getChildCount(); i++) {
  View child = layout.getChildAt(i);
  child.setEnabled(enabled);
}

}

//by jmpessoa
public void ShowMessage(String msg){
	Log.i("ShowMessage:", msg);
   	Toast.makeText(controls.activity, msg, Toast.LENGTH_SHORT).show();	
}

//by jmpessoa
public String GetDateTime() {
  SimpleDateFormat formatter = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss", Locale.getDefault() );
  return( formatter.format ( new Date () ) );	
}

//Free object except Self, Pascal Code Free the class.
 public  void Free() {	
   if (parent != null) { controls.appLayout.removeView(layout); }  
   onClickListener = null;
   layout.setOnClickListener(null);
   layparam = null;
   layout   = null;
   Log.i("jForm:", "Free");
 }

};

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

//
public  void setXYWH ( int x, int y, int w, int h ) {
lparams.width  = w;
lparams.height = h;
lparams.setMargins(x,y,10,10);
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

//by jmpessoa
public void setIdEx(int id) {
	setId(id);   
}

public void setText2(String txt) {
	   this.setText(txt);
}

public String getText2() {
	return this.getText().toString();
}

public void setTextColor2(int value) {
	this.setTextColor(value);  
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

//by jmpessoa
public  void setParent3( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
   parent = viewgroup;
   viewgroup.addView(this,lparams);
}

//
public  void setParent2( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
parent = viewgroup;
viewgroup.addView(this,lparams);
//
Animation animation;
animation = controls.Ani_iR2L(250); // In  (Left  to Right)
startAnimation(animation);
Log.i("Java","animation###############################");
}

//
public  void setEnabled( boolean value ) {
  enabled = value;
}

//by jmpessoa
public  void SetVisible( int value ) {
	  this.setVisibility(value);
}
// Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
setText("");
lparams = null;
setOnClickListener(null);
}

//by jmpessoa
public void setTextSize2(int value) {
	this.setTextSize(value);
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
private OnKeyListener onKeyListener;     //
private TextWatcher   textwatcher;       // OnChange

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

boolean changeFlag;
String bufStr;

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
public  jEditText(android.content.Context context,
               Controls ctrls,long pasobj ) {

super(context);

// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new RelativeLayout.LayoutParams(100,100);
lparams.setMargins(5, 5,5,5);

changeFlag = false;

// 1 Line
 //this.setSingleLine(); //commented by jmpessoa
 
// Init Event : http://socome.tistory.com/15

onKeyListener = new OnKeyListener() {
  public  boolean onKey(View v, int keyCode, KeyEvent event) {
    if ((keyCode           == KeyEvent.KEYCODE_ENTER) &&
        (event.getAction() == KeyEvent.ACTION_UP    )    ) {
        InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(getWindowToken(), 0);
        //
        Log.i("JNI_Java","OnEnter, Hide KeyBoard");
        // LoadMan
        controls.pOnEnter(PasObj);
        return true;
    }
    return false;
  }
  
};
setOnKeyListener(onKeyListener);
// Event
textwatcher = new TextWatcher() {
  @Override
  public  void beforeTextChanged(CharSequence s, int start, int count, int after) {
	  if (changeFlag) {
         controls.pOnChange(PasObj,0);
	  }
  }

  @Override
  public  void onTextChanged(CharSequence s, int start, int before, int count) {
	  if (changeFlag) { 
        controls.pOnChange(PasObj,1);
	 }		  
  }

  @Override
  public  void afterTextChanged(Editable s) {
	if (changeFlag) { 
        controls.pOnChange(PasObj,2);
    }
  }
};

addTextChangedListener(textwatcher);
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

//by jmpessoa
public void setIdEx(int id) {
  this.setId(id);	
}

public void setTextEx(String txt) {
   changeFlag = false;
   this.setText(txt);
   changeFlag = true; 
}

public String getTextEx() {
  return this.getText().toString();
}
            
public void setSingleLineEx(boolean value) {
  this.setSingleLine(value);
}

/*
public void setInputTypeEx(int value) {
	this.setInputType(value);
}
*/

public  void setInputTypeEx(String str) {
	  bufStr = new String(str.toString());
	  if(str.equals("NUMBER")) {
		  this.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
	  }
	  else if (str.equals("TEXT")) { 
		  this.setInputType(android.text.InputType.TYPE_CLASS_TEXT);
	  }
	  else if (str.equals("PHONE"))       {this.setInputType(android.text.InputType.TYPE_CLASS_PHONE); }
	  else if (str.equals("PASSNUMBER"))  {this.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
	                                       this.setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }
	  else if (str.equals("PASSTEXT"))    {this.setInputType(android.text.InputType.TYPE_CLASS_TEXT);
	                                       this.setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }
	  
	  else if (str.equals("TEXTMULTILINE")){this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|android.text.InputType.TYPE_TEXT_FLAG_MULTI_LINE);}
	                                    
	  
	  else                                 {this.setInputType(android.text.InputType.TYPE_CLASS_TEXT);};
	    
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
public void setScrollerEx(android.content.Context context) {
	setScroller(new Scroller(controls.activity)); 
}

public void setTextColor2(int value) {
	this.setTextColor(value);  
}

public void setTextSize2(int value) {
	this.setTextSize(value);  
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


public void setHint2(String hint) {
   this.setHint(hint);
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
    controls.pOnClick(PasObj,Const.Click_Default); 
  }
};
setOnClickListener(onClickListener);
Log.i("jButton","created!");
}

//
public  void setXYWH ( int x, int y, int w, int h ) {
lparams.width  = w;
lparams.height = h;
lparams.setMargins(x,y,0,0);
//
setLayoutParams(lparams);
}

//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
parent = viewgroup;
viewgroup.addView(this,lparams);
Log.i("jButton","setParent!");
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
		setLayoutParams(lparams);
	}

//by jmpessoa
public void setIdEx(int id) {
	  setId(id);
}

//by jmpessoa
public void setTextEx(String txt) {
	this.setText(txt);	
}

public void setTextColor2(int value) {
	this.setTextColor(value);  
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

	//by jmpessoa
public void setIdEx(int id) {
	  setId(id);	
}

public void setTextColor2(int value) {
	this.setTextColor(value);  
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

//by jmpessoa
public void setProgressEx(int value) {
	Log.i("jProgressBar Value","=" + value);
	this.setProgress(value);
}

//by jmpessoa
public int getProgress2() {
	return this.getProgress();
}

//by jmpessoa
public void setMax2(int value) {
	this.setMax(value);
}

//by jmpessoa
public int getMax2() {
	return this.getMax();
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
setScaleType(ImageView.ScaleType.FIT_XY);
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
   if (bmp    != null) { bmp.recycle(); }
   bmp     = null;
   setImageBitmap(null);
   lparams = null;
   setImageResource(0); //android.R.color.transparent;
   onClickListener = null;
   setOnClickListener(null);
}

//by jmpessoa
public void setBitmapImage(Bitmap bm) {
	this.setImageBitmap(bm);
}

public  void setImage(String str) {
	  Bitmap bmp;
	  bmp = this.bmp;
	  if (bmp != null)        { bmp.recycle(); }
	  if (str.equals("null")) { this.setImageBitmap(null);
	                            return; };
	  bmp = BitmapFactory.decodeFile( str );
	  this.setImageBitmap(bmp);
}

//by jmpessoa
public void setMarginLeft(int x) {
	MarginLeft = x;
}

public void setMarginTop(int y) {
	MarginTop = y;
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
	
    return this.getHeight();
}  

//by jmpessoa
public int getLParamWidth() {

	return this.getWidth();
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

//by jmpessoa
public void setIdEx(int id) {
   setId(id);	
}

}
 

//-------------------------------------------------------------------------
//ListView
//Event :
//
//
//-------------------------------------------------------------------------
//by jmpessoa : custom row!
class jListItemRow{
	String label;
	int    id; 
	int widget = 0;
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

public  jArrayAdapter(Context context, Controls ctrls,long pasobj, int textViewResourceId , 
		               List<jListItemRow> list) {
   super(context, textViewResourceId, list);
   PasObj = pasobj;
   controls = ctrls;
   ctx   = context;
   id    = textViewResourceId;
   items = list;
}

@Override
public  View getView(int position, View v, ViewGroup parent) {
 
   //old code: commented by jmpessoa
   /*  
    View mView = v;
   
    if(mView == null){
       LayoutInflater vi = (LayoutInflater)ctx.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
       mView = vi.inflate(id, null);
    }
   
	
   TextView tv = (TextView)mView;
   tv.setTextColor (textColor);
   tv.setTextSize  (TypedValue.COMPLEX_UNIT_PX,textSize );
   tv.setText      (items.get(position));   // position [0 ~ n-1]       
   return mView;
   */	
	
 //new code: by jmpessoa: custom row!	
 if (items.get(position).label != "") {
		  
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
	   itemText[i] = new TextView(ctx);
	   
	   if (items.get(position).textSize != 0){
		   itemText[i].setTextSize(TypedValue.COMPLEX_UNIT_PX,items.get(position).textSize);
	   }
	   
	   if (i == 0) {		   
		    itemText[i].setTypeface(null,faceTitle);
		}
		else{			
		   itemText[i].setTypeface(null,faceBody);
		   if (items.get(position).textSizeDecorated == 1) {
			     itemText[i].setTextSize(TypedValue.COMPLEX_UNIT_PX, itemText[i].getTextSize() - 2*i);
		   }		   
		}
	   
	    itemText[i].setText(lines[i]);
	    
	    if (items.get(position).textColor != 0) {
	       itemText[i].setTextColor(items.get(position).textColor);
	    }
	    
	    txtLayout.addView(itemText[i]);   
   }
   
   View itemWidget = null;
   
   switch(items.get(position).widget) {
     case 1:  itemWidget = new CheckBox(ctx);  ((CheckBox)itemWidget).setText(items.get(position).widgetText);  break;
     case 2:  itemWidget = new RadioButton(ctx); ((RadioButton)itemWidget).setText(items.get(position).widgetText); break;
     case 3:  itemWidget = new Button(ctx);  ((Button)itemWidget).setText(items.get(position).widgetText);    break;
     case 4:  itemWidget = new TextView(ctx); ((TextView)itemWidget).setText(" "+items.get(position).widgetText+" ");   break;
     default: ;
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
 } 
 else return v;
 
}
  //by jmpessoa 
View.OnClickListener getOnCheckItem(final View cb, final int position) { 
    return new View.OnClickListener() { 
	            public void onClick(View v) {
	               if (cb.getClass().getName().equals("android.widget.ImageView")) {
	            	   controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
	               }	 
	               if (cb.getClass().getName().equals("android.widget.CheckBox")) {	 
	                  items.get(position).checked = ((CheckBox)cb).isChecked();	                 	                  
	                  controls.pOnClickWidgetItem(PasObj, position, ((CheckBox)cb).isChecked());
	               }
	               if (cb.getClass().getName().equals("android.widget.RadioButton")) {
	            	      if ( items.get(position).checked ) {((RadioButton)cb).setChecked(false);}
		                  items.get(position).checked = ((RadioButton)cb).isChecked();
		                  controls.pOnClickWidgetItem(PasObj, position, ((RadioButton)cb).isChecked());
		           }
	               if (cb.getClass().getName().equals("android.widget.Button")) { //button	            	      	            	        
			             controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked); 		                  
		           }
	               if (cb.getClass().getName().equals("android.widget.TextView")) { //textview  
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
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event

private Bitmap          genericBmp;
private int             widgetItem;
private String          widgetText;
private int             textColor; 
private int             textSize;     
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
   
aadapter = new jArrayAdapter(context, controls, PasObj, android.R.layout.simple_list_item_1,  alist);

setAdapter(aadapter);

setChoiceMode(ListView.CHOICE_MODE_SINGLE);
//Init Event
onItemClickListener = new OnItemClickListener() {
   @Override
   public  void onItemClick(AdapterView<?> parent, View v, int position, long id) {
     controls.pOnClick(PasObj, (int)id );
   }
};

setOnItemClickListener(onItemClickListener);
}

//by jmpessoa
public boolean isItemChecked(int index) {
  return alist.get(index).checked;		
}
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

//
public  void setXYWH ( int x, int y, int w, int h ) {
  lparams.width  = w;
  lparams.height = h;
  lparams.setMargins(x,y,0,0);
  //
  setLayoutParams(lparams);
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

public  void setTextSize (int textsize) {
   this.textSize =textsize ;
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
  //
  setLayoutParams(lparams);
}

//by jmpessoa
public void setIdEx(int id) {
   setId(id);	
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

//
public  void setXYWH ( int x, int y, int w, int h ) {
Log.i("java","setXYWH-> jScrollView1");
lparams.width  = w;
lparams.height = h;
lparams.setMargins(x,y,0,0);
//
setLayoutParams(lparams);
//
scrollxywh.width = w;
scrollview.setLayoutParams(scrollxywh);
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

//by jmpessoa
public void setIdEx(int id) {
setId(id);	
}

}

//-----------------------------------------
//----- jPanel by jmpessoa
//-----------------------------------------
class jPanel  extends RelativeLayout {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private ViewGroup       parent   = null;

	private RelativeLayout.LayoutParams lparams;           // layout XYWH
	
	private RelativeLayout  layout   = null;
	private LayoutParams    layparam = null;
	
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
    	
	public void setMarginRight(int x) {
		marginRight = x;
	}

	public void setMarginBottom(int y) {
		marginBottom = y;
	}

	public void setMarginLeft(int x) {
		MarginLeft = x;
	}

	public void setMarginTop(int y) {
		MarginTop = y;
	}

	//Constructor
	public  jPanel(android.content.Context context, Controls ctrls,long pasobj ) {
	   super(context);	
	   // Connect Pascal I/F
       PasObj   = pasobj;
	   controls = ctrls;
       lparams = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);		
	   //
	   layout   = new RelativeLayout(context);
	   layparam = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
	   layout.setLayoutParams(layparam);
	}
	
	public  void setXYWH ( int x, int y, int w, int h ) {
		
		lparams.width  = w;
		lparams.height = h;
		lparams.setMargins(x,y,0,0);
		//
		setLayoutParams(lparams);
		
		layparam.setMargins(x,y,0,0);
		layparam.width = w;
		layparam.height = h;
	    layout.setLayoutParams(layparam);
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

	public int getLParamHeight() {	
	  return getHeight();
	}  

	public int getLParamWidth() {
		return getWidth();
	}

	public void resetLParamsRules() {
		for (int i=0; i < countAnchorRule; i++) {  
				layparam.removeRule(lparamsAnchorRule[i]);
				lparams.removeRule(lparamsAnchorRule[i]);		
		}
				
		for (int j=0; j < countParentRule; j++) {  
			layparam.removeRule(lparamsParentRule[j]);		
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

		
		layparam.height = lpH;
	 	layparam.width =  lpW;
	 	layparam.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);
	 	
		if (idAnchor > 0) {    	
			for (int i=0; i < countAnchorRule; i++) {  
				layparam.addRule(lparamsAnchorRule[i], idAnchor);
				lparams.addRule(lparamsAnchorRule[i], idAnchor);		
		    }
			
		} 
		
		for (int j=0; j < countParentRule; j++) {  
			layparam.addRule(lparamsParentRule[j]);		
			lparams.addRule(lparamsParentRule[j]);		
	    }
		//
		setLayoutParams(lparams);
		layout.setLayoutParams(layparam); 		
 	}

	public void setIdEx(int id) {
	   setId(id);	
	}
	
	public  android.widget.RelativeLayout getView() {
	   return layout;
	}

	public  void setParent( android.view.ViewGroup viewgroup ) {
    	if (parent != null) { parent.removeView(this); }
	    parent = viewgroup;
	    parent.addView(this,lparams);
	    parent.addView(layout);
	}
	
	// Free object except Self, Pascal Code Free the class.
	public  void Free() {
		if (parent != null) { parent.removeView(this); }
		layparam = null;
		this.removeView(layout);
		layout = null;
		layparam = null;
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

//
public  void setXYWH ( int x, int y, int w, int h ) {
Log.i("java","setXYWH-> jHorizontalScrollView");
lparams.width  = w;
lparams.height = h;

lparams.setMargins(x,y,0,0);
//
setLayoutParams(lparams);
//
scrollxywh.width = w;
scrollview.setLayoutParams(scrollxywh);
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

//by jmpessoa
public void setIdEx(int id) {
setId(id);	
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
    Log.i("ViewFlipper","ViewFlipper OnTouch");
    switch(event.getAction())  {
      case MotionEvent.ACTION_DOWN :
           { Xdn = event.getX();
             break; }
      case MotionEvent.ACTION_UP   :
           { Xup   = event.getX();
             if(Xup < Xdn) { // Right Direction
                             Log.i("ViewFlipper","Right Dir.");
                             setInAnimation (iR2L);
                             setOutAnimation(oR2L);
                             showNext();
                           //  if (inxcur < (inxmax-1)){ showNext();
                           //                            inxcur++;  }
                           }
             else if (Xup > Xdn) { // Left Direction
                                   Log.i("ViewFlipper","Left Dir.");
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

//by jmpessoa
public void setIdEx(int id) {
setId(id);	
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
}

@Override
public  void onPageFinished(WebView view, String url) {
controls.pOnWebViewStatus(PasObj,Const.WebView_OnFinish,url);
}

@Override
public  void onReceivedError(WebView view, int errorCode, String description, String failingUrl)  {
super.onReceivedError(view, errorCode, description, failingUrl);
controls.pOnWebViewStatus(PasObj,Const.WebView_OnError, description);
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
public  jWebView(android.content.Context context,
              Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
webclient          = new jWebClient();
webclient.PasObj   = pasobj;
webclient.controls = ctrls;
//
setWebViewClient(webclient); // Prevent to run External Browser
//
getSettings().setJavaScriptEnabled(true);
//
lparams = new RelativeLayout.LayoutParams  (300,300);
lparams.setMargins( 50, 50,0,0);
//
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
webclient = null;
setWebViewClient(null);
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


public  void setJavaScript(boolean javascript) {
	  this.getSettings().setJavaScriptEnabled(javascript);
}

public  void loadURL2(String str) {
	  this.loadUrl("about:blank");
	  this.loadUrl(str);
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

//
public  void setjCanvas( jCanvas canvas ) {
  jcanvas = canvas;
}

public  void saveView2(String filename) {
	  this.saveView(filename);
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
  	    Log.i("Java","PUp");
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
   fos.close(); }  }
catch ( Exception e) {
  Log.e("SaveView", "Exception: "+ e.toString() ); }
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

//
class jRenderer implements GLSurfaceView.Renderer {
  public  void onSurfaceCreated(GL10 gl, EGLConfig config) {
             controls.pOnGLRenderer(PasObj,Const.Renderer_onSurfaceCreated,0,0); }
  public  void onSurfaceChanged(GL10 gl, int w, int h) {
             controls.pOnGLRenderer(PasObj,Const.Renderer_onSurfaceChanged,w,h); }
  public  void onDrawFrame     (GL10 gl) {
	             Log.i("Java","Draw before");
             controls.pOnGLRenderer(PasObj,Const.Renderer_onDrawFrame,0,0);    
             Log.i("Java","Draw after");  }
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

//
public  void setXYWH ( int x, int y, int w, int h ) {
  lparams.width  = w;
  lparams.height = h;
  lparams.setMargins(x,y,0,0);
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
	Log.i("Java","surfaceDestroyed");
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
public void setIdEx(int id) {
  setId(id);	
}

//by jmpessoa
public void Refresh() {
   requestRender();
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
private long            PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ProgressDialog  dialog;

// Constructor
public  jDialogProgress(android.content.Context context,
                     Controls ctrls, long pasobj, String title,String msg ) {
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init & Run
dialog = ProgressDialog.show(context,title,msg,true);
}

public  void Free() {
dialog.dismiss();
dialog = null;
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
private int             btnState = 0;      // Normal = 0 , Pressed = 1
private Boolean         enabled  = true;   //

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.WRAP_CONTENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

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
public  jImageBtn(android.content.Context context,
                Controls ctrls,long pasobj ) {
super(context);
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
// Init Class
lparams = new LayoutParams  (100,100);
lparams.setMargins( 50, 50,0,0);
// BackGroundColor
//setBackgroundColor(0xFF0000FF);
//
mPaint = new Paint();
rect   = new Rect(0,0,100,100);
}

//
public  void setXYWH ( int x, int y, int w, int h ) {
lparams.width  = w;
lparams.height = h;
lparams.setMargins(x,y,0,0);
rect.right     = w;
rect.bottom    = h;
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

public  void setButton( String fileup , String filedn ) {
if (bmpUp  != null) { bmpUp.recycle();         }
bmpUp = BitmapFactory.decodeFile(fileup);
if (bmpDn  != null) { bmpDn.recycle();         }
bmpDn = BitmapFactory.decodeFile(filedn);
invalidate();
}

public  void setButtonUp( String fileup) {
if (bmpUp  != null) { bmpUp.recycle(); }
bmpUp = BitmapFactory.decodeFile(fileup);
invalidate();
}

public  void setButtonDown( String filedn ) {
if (bmpDn  != null) { bmpDn.recycle();         }
bmpDn = BitmapFactory.decodeFile(filedn);
invalidate();
}

//
@Override
public  boolean onTouchEvent( MotionEvent event) {
// LORDMAN 2013-08-16
if (enabled == false) { return(false); }

int actType = event.getAction() &MotionEvent.ACTION_MASK;
switch(actType) {
  case MotionEvent.ACTION_DOWN: { btnState = 1; invalidate(); Log.i("Java","jImageBtn Here"); break; }
  case MotionEvent.ACTION_MOVE: {                             break; }
  case MotionEvent.ACTION_UP  : { btnState = 0; invalidate();
                                  controls.pOnClick(PasObj,Const.Click_Default);
                                  break; }
}
return true;
}

//
@Override
public  void onDraw( Canvas canvas) {
//
if (btnState == 0) { if (bmpUp != null) { canvas.drawBitmap(bmpUp,null,rect,mPaint); }; }
else               { if (bmpDn != null) { canvas.drawBitmap(bmpDn,null,rect,mPaint); }; };
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

//by jmpessoa
public void setIdEx(int id) {
setId(id);	
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
Log.i("Java","Before Download");
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
Log.i("Java","Finish");
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
     Log.d("Java", "Downloaded " + ((System.currentTimeMillis() - startTime) / 1000) + "s");
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
class jAsyncTask extends AsyncTask<Void   , Integer  , Void>{
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
boolean autoPublishProgress = false;

// Constructor
public  jAsyncTask(Controls ctrls,long pasobj) {
   //Connect Pascal I/F
   PasObj   = pasobj;
   controls = ctrls;
}

// Step #1. Before Process
@Override
protected void onPreExecute() {
   super.onPreExecute();
   controls.pOnAsyncEvent(PasObj,Const.Task_Before,0); // Pascal Event
}

//Step #2. Task
@Override
protected Void doInBackground(Void... params) {
   int i;
   
   if (autoPublishProgress) {
      for (i = 0; i < 25; i++) {
         publishProgress(i);	
      }
   }
   
   controls.pOnAsyncEvent(PasObj, Const.Task_BackGround, 100); // Pascal Event
   
   if (autoPublishProgress) {
      for (i = 25; i < 100; i++) {
	     publishProgress(i);	
      }
   }  
   return null;
};

// Step #3. Progress
@Override
protected void onProgressUpdate(Integer... params) {
   super.onProgressUpdate(params);
   controls.pOnAsyncEvent(PasObj,Const.Task_Progress,params[0]); // Pascal Event
}

// Step #4. After Process
@Override
protected void onPostExecute(Void result) {
    super.onPostExecute(result);
    controls.pOnAsyncEvent(PasObj,Const.Task_Post,100); // Pascal Event
}

public void setProgress(int progress ) {
   Log.i("jAsyncTask","setProgress "+progress );
   publishProgress(progress);
}

//by jmpessoa
public void SetAutoPublishProgress(boolean value){
    autoPublishProgress = value;
}

//by jmpessoa
public void Execute2(){
  execute();
}

//Free object except Self, Pascal Code Free the class.
public  void Free() {
}

}

//
class jTask {
// Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
public  jAsyncTask      asynctask = null;  //

// Constructor
public  jTask(Controls ctrls,long pasobj) {
// Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//
asynctask = new jAsyncTask(ctrls,pasobj);
}

public void setProgress(int progress ) {
Log.i("jTask","setProgress " );

}

}

//------------------------------------------------------------------------------
//
//Graphic API
//
//
//------------------------------------------------------------------------------
//http://forum.lazarus.freepascal.org/index.php?topic=21568.0
//https://github.com/alrieckert/lazarus/blob/master/lcl/interfaces/customdrawn/android/bitmap.pas
class jBitmap  {
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

public  void loadFile(String filename) {
  //if (bmp != null) { bmp.recycle(); }
  bmp = BitmapFactory.decodeFile(filename);
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
    this.bmp.compress(CompressFormat.PNG, 0, stream);
    Log.i("GetByteArrayFromBitmap","size="+ stream.size());
    return stream.toByteArray();
}

//by jmpessoa
public void SetByteArrayToBitmap(byte[] image) {
	this.bmp = BitmapFactory.decodeByteArray(image, 0, image.length);
	Log.i("SetByteArrayToBitmap","size="+ image.length);
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
        
        private String[] storeTableCreateQuery = new String[10]; //max 10 create tables scripts
        private String[] storeTableName = new String[10];       //max 10  tables name
       
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
	           
        public void ExecSQL(String execQuery){
	        try{ 	
	           mydb = this.Open();	
	           mydb.execSQL(execQuery);
	           mydb.close();
	        }catch(SQLiteException se){
	        	Log.e(getClass().getSimpleName(), "Could not execute: "+ execQuery);
	        	
	        }
	    }
        
        public void UpdateImage(String tabName, String imageFieldName, String keyFieldName, Bitmap imageValue, int keyValue) {
        	ByteArrayOutputStream stream = new ByteArrayOutputStream();
        	bufBmp = imageValue;
        	bufBmp.compress(CompressFormat.PNG, 0, stream);            
            byte[] image_byte = stream.toByteArray();
            Log.i("UpdateImage","UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?");
            mydb = this.Open();
        	mydb.execSQL("UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?", new Object[] {image_byte, keyValue} );
        	mydb.close();
        	Log.i("UpdateImage", "Ok. Image Updated!");
        	bufBmp = null;
        }
        
        public void UpdateImage(String tabName, String imageFieldName, String keyFieldName, byte[] imageValue, int keyValue) {
        	mydb.execSQL("UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?", new Object[] {imageValue, keyValue} );
        }
                
	    public String SelectS(String selectQuery) {	 
	    	
		     String row = "";
		     String rows = "";
		     String colValue;		     
		     String headerRow;
		     int colCount;	    	
		     int i;
		     String allRows = null;
		      		     		     
		     try{
		       mydb = this.Open();	            
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
	    	    
	    public void SelectV(String selectQuery) {
	    	    this.cursor = null;
		        try{  //controls.activity.openOrCreateDatabase(DATABASE_NAME, Context.MODE_PRIVATE, null); //
			     	mydb = this.Open();	            
			     	this.cursor  = mydb.rawQuery(selectQuery, null);			    			        
			        mydb.close();			       
			     }catch(SQLiteException se){
			         Log.e(getClass().getSimpleName(), "Could not select:" + selectQuery);
			     }	     		         			     
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
		   if (mydb.isOpen()) { mydb.close();}			  
		}
		   
		public void Free() {
		   if (mydb.isOpen()) { mydb.close();}
		   mydb = null;
		}		
}


 /**
  * TODO
  * jMediaPlayer
  * 
  * by jmpessoa
  *
  */
//http://www.javatpoint.com/playing-audio-in-android-example
class jMediaPlayer{
	
    private long PasObj   = 0;           // Pascal Obj
    private Controls controls = null;   // Control Class for Event
    private MediaPlayer mplayer = null;
    private String FILE_NAME; 
    
    public jMediaPlayer (Controls ctrls, long pasobj, String pathToFileName) {	    
	   PasObj   = pasobj;
	   controls = ctrls;
	   FILE_NAME = pathToFileName;
	   this.mplayer = new MediaPlayer();
    }
    
    public void SetDataSource(String path){	 //sets the data source (file path or http url) to use.
    	FILE_NAME = path;
    	try {
			this.mplayer.setDataSource(FILE_NAME);
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
    
    public void Prepare(){	 //prepares the player for playback synchronously.
    	try {
			this.mplayer.prepare();
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
    public void Start(){	 //it starts or resumes the playback.
    	this.mplayer.start();
    }
    public void Stop(){	 //it stops the playback.
    	this.mplayer.stop();
    }
    public void Pause(){	 //it pauses the playback.
    	this.mplayer.pause();
    }
    public boolean IsPlaying(){	 //checks if media player is playing.
    	return this.mplayer.isPlaying();
    }
    public void SeekTo(int millis){	 //seeks to specified time in miliseconds.
    	this.mplayer.seekTo(millis);	
    }
    public void SetLooping(boolean looping){	 //sets the player for looping or non-looping.
    	this.mplayer.setLooping(looping);
    }
    public boolean IsLooping(){	 //checks if the player is looping or non-looping.
    	return this.mplayer.isLooping();
    }
    public void SelectTrack(int index){	 //it selects a track for the specified index.
    	
    }
    public int GetCurrentPosition(){	 //returns the current playback position.
    	return this.mplayer.getCurrentPosition();
    }
    public int GetDuration(){	 //returns duration of the file.
    	return this.mplayer.getDuration();
    }
    public void SetVolume(float leftVolume,float rightVolume){
    	this.mplayer.setVolume(leftVolume, rightVolume);
    }
}

//------------------------------------------------------------------------------
//
//Javas/Pascal Interface Class
//
//------------------------------------------------------------------------------
//!!!! class controls  
//
public  class Controls {
//
public   Activity       activity;            // Activity
public   RelativeLayout appLayout;           // Base Layout
public   int            screenStyle = 0;     // Screen Style [Dev:0 , Portrait: 1, Landscape : 2]

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
public  native void pAppOnActivityResult(int requestCode, int resultCode, Intent data); 
//
public  native void pOnClick     (long pasobj, int value);
public  native void pOnChange    (long pasobj, int EventType);
public  native void pOnEnter     (long pasobj);
public  native void pOnTimer     (long pasobj);
//
public  native void pOnDraw      (long pasobj, Canvas canvas);
public  native void pOnTouch     (long pasobj, int act, int cnt,float x1, float y1,float x2, float y2);
public  native void pOnGLRenderer(long pasobj, int EventType, int w, int h);
//
public  native void pOnClose     (long pasobj);     //Add "context" by jmpessoa

public  native void pOnActive     (long pasobj);     //new by jmpessoa
//
public  native int  pOnWebViewStatus (long pasobj, int EventType, String url);
public  native void pOnAsyncEvent    (long pasobj, int EventType, int progress);

//new by jmpessoa: support for jListView custom row
public  native void pOnClickWidgetItem(long pasobj, int position, boolean checked); 

// Load Pascal Library
static {
    Log.i("JNI_Java", "1.load libcontrols.so");
    System.loadLibrary("controls");
    Log.i("JNI_Java", "2.load libcontrols.so");
    
}

// -------------------------------------------------------------------------
//  Activity Event
// -------------------------------------------------------------------------
public  int  jAppOnScreenStyle()          { return(pAppOnScreenStyle());   }     
//
public  void jAppOnCreate(Context context,RelativeLayout layout )
                                         { pAppOnCreate(context,layout);   }
public  void jAppOnNewIntent()            { pAppOnNewIntent();             }     
public  void jAppOnDestroy()              { pAppOnDestroy();               }  
public  void jAppOnPause()                { pAppOnPause();                 }  
public  void jAppOnRestart()              { pAppOnRestart();               }    
public  void jAppOnResume()               { pAppOnResume();                }    
public  void jAppOnStart()                { pAppOnStart();                }     //change by jmpessoa : old OnActive
public  void jAppOnStop()                 { pAppOnStop();                  }   
public  void jAppOnBackPressed()          { pAppOnBackPressed();           }   
public  int  jAppOnRotate(int rotate)     { return(pAppOnRotate(rotate));  }
public  void jAppOnConfigurationChanged() { pAppOnConfigurationChanged();  }
public  void jAppOnActivityResult(int requestCode, int resultCode, Intent data) 
                                          { pAppOnActivityResult(requestCode,resultCode,data); } 

//rotate=1 --> device on vertical/default position ; 2 --> device on horizontal position      //tips by jmpessoa

// -------------------------------------------------------------------------
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
//  View Related
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

public  void jForm_Free(java.lang.Object form) {
 jForm obj = (jForm)form;
 obj.Free();
 //obj = null;
}

public  RelativeLayout jForm_GetLayout(java.lang.Object form) {
  return ((jForm)form).GetLayout();
}

public  void jForm_Show (java.lang.Object form, int effect) {
  ((jForm)form).Show(effect);
}

public  void jForm_Close(java.lang.Object form, int effect) {
  ((jForm)form).Close(effect);
}


public  void jForm_SetEnabled (java.lang.Object form, boolean enabled) {
  ((jForm)form).SetEnabled(enabled);
}

// -------------------------------------------------------------------------
//  System Info
// -------------------------------------------------------------------------
// Result : Width(16bit) : Height (16bit)
public  int  getScreenWH(android.content.Context context) {
  DisplayMetrics metrics = new DisplayMetrics();

  int h = context.getResources().getDisplayMetrics().heightPixels;
  int w = context.getResources().getDisplayMetrics().widthPixels;
  return ( (w << 16)| h );
}

// LORDMAN - 2013-07-28
public  int getStrLength(String Txt) {
  int len = Txt.length();
  return ( len );
}

// LORDMAN - 2013-07-30
public  String getStrDateTime() {
  SimpleDateFormat formatter = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss", Locale.KOREA );
  return( formatter.format ( new Date () ) );
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
  Log.i("JAVA:",version);
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
  Log.i("JNI_Java", "wh:" + Integer.toString(options.outWidth ) +
                      "x" + Integer.toString(options.outHeight) );
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
//  TextView
// -------------------------------------------------------------------------

public  java.lang.Object jTextView_Create(android.content.Context context, long pasobj) {
  return (java.lang.Object)( new jTextView(context,this,pasobj));
}

//by jmpessoa
public  java.lang.Object jTextView_Create2(long pasobj) {
  return (java.lang.Object)( new jTextView(this.activity,this,pasobj));
}

public  void jTextView_Free(java.lang.Object textview) {
  jTextView obj = (jTextView)textview;
  obj.Free();
  //obj = null;
}

public  void jTextView_setXYWH (java.lang.Object textview,
                               int x, int y, int w, int h ) {
  ((jTextView)textview).setXYWH(x,y,w,h);
}

public void jTextView_setLeftTopRightBottomWidthHeight(java.lang.Object textview,
        int left, int top, int right, int bottom, int w, int h) {
((jTextView)textview).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}


public  void jTextView_setParent(java.lang.Object textview,
                                android.view.ViewGroup viewgroup) {
  ((jTextView)textview).setParent3(viewgroup);
}

public  void jTextView_setParent2(java.lang.Object textview,
                                 android.view.ViewGroup viewgroup) {
  ((jTextView)textview).setParent2(viewgroup);
}

public  void jTextView_setEnabled(java.lang.Object textview, boolean enabled) {
  ((jTextView)textview).setEnabled(enabled);
}

public  void jTextView_setText(java.lang.Object textview, String str) {
  ((jTextView)textview).setText(str);
}

public  void jTextView_setTextColor(java.lang.Object textview, int color) {
  ((jTextView)textview).setTextColor(color);
}

public  void jTextView_setTextSize(java.lang.Object textview, int pxSize) {
  ((jTextView)textview).setTextSize(TypedValue.COMPLEX_UNIT_PX,pxSize);
}

public  String jTextView_getText(java.lang.Object textview) {
  return ((jTextView)textview).getText().toString();
}

// LORDMAN 2013-08-12
public  void jTextView_setTextAlignment(java.lang.Object textview, int align) {
  ((jTextView)textview).setTextAlignment(align);
}


//by jmpessoa
public  void jTextView_setId(java.lang.Object textview, int id) {
	  ((jTextView)textview).setIdEx(id);
}

//by jmpessoa
public void jTextView_setLParamWidth(java.lang.Object textview, int w) {
	((jTextView)textview).setLParamWidth(w);
}

//by jmpessoa
public void jTextView_setLParamHeight(java.lang.Object textview, int h) {
	((jTextView)textview).setLParamHeight(h);
}

//by jmpessoa
public void jTextView_addLParamsParentRule(java.lang.Object textview, int rule) {
	((jTextView)textview).addLParamsParentRule(rule);
}

public void jTextView_addLParamsAnchorRule(java.lang.Object textview, int rule) {
	((jTextView)textview).addLParamsAnchorRule(rule);
}
//by jmpessoa
public  void jTextView_setLayoutAll(java.lang.Object textview, int idAnchor) {
	  ((jTextView)textview).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jTextView_setMarginLeft(java.lang.Object textview, int x) {
	((jTextView)textview).setMarginLeft(x);
}

//by jmpessoa
public void jTextView_setMarginTop(java.lang.Object textview, int y) {
	((jTextView)textview).setMarginTop(y);
}

//by jmpessoa
public void jTextView_setMarginRight(java.lang.Object textview, int x) {
	((jTextView)textview).setMarginRight(x);
}

//by jmpessoa
public void jTextView_setMarginBottom(java.lang.Object textview, int y) {
	((jTextView)textview).setMarginBottom(y);
}

//-------------------------------------------------------------------------
//EditText
//-------------------------------------------------------------------------

// LORDMAN 2013-08-27
public  void jEditText_setEnabled(java.lang.Object edittext, boolean enabled ) {
  jEditText obj = (jEditText)edittext;
  obj.setClickable            (enabled);
  obj.setEnabled              (enabled);
  obj.setFocusable            (enabled);
  obj.setFocusableInTouchMode (enabled);
}

// LORDMAN 2013-08-27
public  void jEditText_setEditable(java.lang.Object edittext, boolean enabled ) {
  jEditText obj = (jEditText)edittext;
  obj.setClickable            (enabled);
  if (enabled) {
    obj.setEnabled              (enabled); } //<--- ReadOnly
  obj.setFocusable            (enabled);
  obj.setFocusableInTouchMode (enabled);
}


public  java.lang.Object jEditText_Create(android.content.Context context,
                                         long pasobj ) {
  return (java.lang.Object)( new jEditText(context,this,pasobj));
}

//by jmpessoa
public  java.lang.Object jEditText_Create2(long pasobj ) {
   return (java.lang.Object)( new jEditText(this.activity,this,pasobj));
}

public  void jEditText_Free(java.lang.Object edittext) {
  jEditText obj = (jEditText)edittext;
  obj.Free();
  //obj = null;
}

public  void jEditText_setXYWH (java.lang.Object edittext,
                               int x, int y, int w, int h ) {
  ((jEditText)edittext).setXYWH(x,y,w,h);
}

public void jEditText_setLeftTopRightBottomWidthHeight(java.lang.Object edittext,
        int left, int top, int right, int bottom, int w, int h) {
((jEditText)edittext).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}


public  void jEditText_setParent(java.lang.Object edittext,
                                android.view.ViewGroup viewgroup) {
  ((jEditText)edittext).setParent(viewgroup);
}

public  void jEditText_setText(java.lang.Object edittext, String str) {
  ((jEditText)edittext).setText(str);
}

public  String jEditText_getText(java.lang.Object edittext) {
  return ((jEditText)edittext).getText().toString();
}

public  void jEditText_setTextColor(java.lang.Object edittext, int color) {
  ((jEditText)edittext).setTextColor(color);
}

public  void jEditText_setTextSize(java.lang.Object edittext, int pxSize) {
  ((jEditText)edittext).setTextSize(TypedValue.COMPLEX_UNIT_PX,pxSize);
}

public  void jEditText_setHint(java.lang.Object edittext, String hint) {
  ((jEditText)edittext).setHint(hint);
}

// LORDMAN - 2013-07-26
public  void jEditText_SetFocus(java.lang.Object edittext) {
  ((jEditText)edittext).requestFocus();
}

// LORDMAN - 2013-07-26
public  void jEditText_immShow(java.lang.Object edittext) {
  InputMethodManager imm = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(0, InputMethodManager.SHOW_IMPLICIT);
}

// LORDMAN - 2013-07-26
public  void jEditText_immHide(java.lang.Object edittext) {
  InputMethodManager imm = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
  imm.hideSoftInputFromWindow(((jEditText)edittext).getWindowToken(), 0);
}

// LORDMAN - 2013-07-26
public  void jEditText_InputType(java.lang.Object edittext, String str) {
	
  if      (str.equals("NUMBER"))     { ((jEditText)edittext).setInputType(android.text.InputType.TYPE_CLASS_NUMBER);}
  else if (str.equals("TEXT"))       { 
	  Log.i("EditText","1.setInputType..1");  
	  ((jEditText)edittext).setInputType(android.text.InputType.TYPE_CLASS_TEXT);  
	  Log.i("EditText","2.setInputType..2");  
      }
  else if (str.equals("PHONE"))      { ((jEditText)edittext).setInputType(android.text.InputType.TYPE_CLASS_PHONE); }
  else if (str.equals("PASSNUMBER")) { ((jEditText)edittext).setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
                                       ((jEditText)edittext).setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }
  else if (str.equals("PASSTEXT"))   { ((jEditText)edittext).setInputType(android.text.InputType.TYPE_CLASS_TEXT);
                                       ((jEditText)edittext).setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }
  
  else if (str.equals("TEXTMULTILINE")){((jEditText)edittext).setInputType(android.text.InputType.TYPE_CLASS_TEXT|android.text.InputType.TYPE_TEXT_FLAG_MULTI_LINE);}
                                    
  
  else                               { ((jEditText)edittext).setInputType(android.text.InputType.TYPE_CLASS_TEXT); };
    
}

//by jmpessoa
public  void jEditText_InputTypeEx(java.lang.Object edittext, int inputType) {
	Log.i("EditText","1.setInputTypeEx");
	   ((jEditText)edittext).setInputType(inputType);
	Log.i("EditText","2.setInputTypeEx");
}

public  void jEditText_setMaxLines(java.lang.Object edittext, int maxlines) {
	Log.i("EditText","1.setMaxLines");
	  ((jEditText)edittext).setMaxLines(maxlines);
	Log.i("EditText","2.setMaxLines");
}

//by jmpessoa
public  void jEditText_setSingleLine(java.lang.Object edittext, boolean isSingLine) {
	Log.i("EditText","1.setSingleLine");
	  ((jEditText)edittext).setSingleLine(isSingLine);	
	Log.i("EditText","2.setSingleLine");
}

//by jmpessoa
public  void jEditText_setVerticalScrollBarEnabled(java.lang.Object edittext, boolean Value) {
	  ((jEditText)edittext).setVerticalScrollBarEnabled(Value);
}

//by jmpessoa
public  void jEditText_setHorizontalScrollBarEnabled(java.lang.Object edittext, boolean Value) {
	  ((jEditText)edittext).setHorizontalScrollBarEnabled(Value);
}


//by jmpessoa
public  void jEditText_setScrollbarFadingEnabled(java.lang.Object edittext, boolean Value) {
	  ((jEditText)edittext).setScrollbarFadingEnabled(Value);
}

//by jmpessoa
public  void jEditText_setScrollBarStyle(java.lang.Object edittext, int Value) {
	  ((jEditText)edittext).setScrollBarStyle(Value);
}

//by jmpessoa
public  void jEditText_setMovementMethod(java.lang.Object edittext) {
	  ((jEditText)edittext).setMovementMethod(new ScrollingMovementMethod());//ScrollingMovementMethod.getInstance()
}

//by jmpessoa
public  void jEditText_setScroller(android.content.Context context, java.lang.Object edittext) {
	((jEditText)edittext).setScrollerEx(context); 
}

//by jmpessoa
public  void jEditText_setScroller2(java.lang.Object edittext) {	  
	((jEditText)edittext).setScrollerEx(this.activity);	  
}

//by jmpessoa
public  void jEditText_setId(java.lang.Object edittext, int id) {
	  ((jEditText)edittext).setIdEx(id);
}

//by jmpessoa
public void jEditText_setLParamWidth(java.lang.Object edittext, int w) {
	((jEditText)edittext).setLParamWidth(w);
}

//by jmpessoa
public void jEditText_setLParamHeight(java.lang.Object edittext, int h) {
	((jEditText)edittext).setLParamHeight(h);
}

//by jmpessoa
public void jEditText_addLParamsAnchorRule(java.lang.Object edittext, int rule) {
	((jEditText)edittext).addLParamsAnchorRule(rule);
}

public void jEditText_addLParamsParentRule(java.lang.Object edittext, int rule) {
	((jEditText)edittext).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jEditText_setLayoutAll(java.lang.Object edittext, int idAnchor) {
	  ((jEditText)edittext).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jEditText_setMarginLeft(java.lang.Object edittext, int x) {
	((jEditText)edittext).setMarginLeft(x);
}

//by jmpessoa
public void jEditText_setMarginTop(java.lang.Object edittext, int y) {
	((jEditText)edittext).setMarginTop(y);
}

//by jmpessoa
public void jEditText_setMarginRight(java.lang.Object edittext, int x) {
	((jEditText)edittext).setMarginRight(x);
}

//by jmpessoa
public void jEditText_setMarginBottom(java.lang.Object edittext, int y) {
	((jEditText)edittext).setMarginBottom(y);
}

// LORDMAN - 2013-07-26
public  void jEditText_maxLength(java.lang.Object edittext, int mLength) {
  InputFilter[] FilterArray = new InputFilter[1];
  FilterArray[0] = new InputFilter.LengthFilter(mLength);
  ((jEditText)edittext).setFilters(FilterArray);
  Log.i("EditText","SetMaxLen");
}

// LORDMAN - 2013-07-26 , 2013-08-05
public  int[] jEditText_GetCursorPos(java.lang.Object edittext) {

  int[] vals = new int[2];

  vals[0] = ((jEditText)edittext).getSelectionStart();
  vals[1] = ((jEditText)edittext).getSelectionEnd();

  return vals;
}

// LORDMAN - 2013-07-26, 2013-08-05
public  void jEditText_SetCursorPos(java.lang.Object edittext, int startPos, int endPos) {
  if (endPos == 0) { endPos = startPos; };
  ((jEditText)edittext).setSelection(startPos,endPos);
}

// LORDMAN 2013-08-12
public  void jEditText_setTextAlignment(java.lang.Object edittext, int align) {
((jEditText)edittext).setTextAlignment(align);
}

//by jmpessoa   ... for wrapping text --> True
public  void jEditText_setHorizontallyScrolling(java.lang.Object edittext, boolean value) {
 ((jEditText)edittext).setHorizontallyScrolling(value);;
}


// -------------------------------------------------------------------------
//  Button
// -------------------------------------------------------------------------

public  java.lang.Object jButton_Create(android.content.Context context,
                                       long pasobj ) {
  return (java.lang.Object)( new jButton(context,this,pasobj));
}

//by jmpessoa
public  java.lang.Object jButton_Create2(long pasobj ) {
    return (java.lang.Object)( new jButton(this.activity,this,pasobj));
}

public  void jButton_Free(java.lang.Object button) {
  jButton obj = (jButton)button;
  obj.Free();
  //obj = null;
}

public  void jButton_setXYWH  (java.lang.Object button,
                              int x, int y, int w, int h ) {
  ((jButton)button).setXYWH(x,y,w,h);
}

public void jButton_setLeftTopRightBottomWidthHeight(java.lang.Object button,
        int left, int top, int right, int bottom, int w, int h) {
((jButton)button).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}


public  void jButton_setParent(java.lang.Object button,
                              android.view.ViewGroup viewgroup) {
  ((jButton)button).setParent(viewgroup);
}

public  void jButton_setText(java.lang.Object button, String str) {
  ((jButton)button).setText(str);
}

public  String jButton_getText(java.lang.Object button) {
  return ((jButton)button).getText().toString();
}

public  void jButton_setTextColor(java.lang.Object button, int color) {
  ((jButton)button).setTextColor(color);
}

public  void jButton_setTextSize(java.lang.Object button, int pxSize) {
  ((jButton)button).setTextSize(TypedValue.COMPLEX_UNIT_PX,pxSize);
}

//by jmpessoa
public  void jButton_setId(java.lang.Object button, int id) {
	  ((jButton)button).setIdEx(id);
}

//by jmpessoa
public void jButton_setLParamWidth(java.lang.Object button, int w) {
	((jButton)button).setLParamWidth(w);
}

//by jmpessoa
public void jButton_setLParamHeight(java.lang.Object button, int h) {
	((jButton)button).setLParamHeight(h);
}

//by jmpessoa
public void jButton_addLParamsAnchorRule(java.lang.Object button, int rule) {
	((jButton)button).addLParamsAnchorRule(rule);
}

public void jButton_addLParamsParentRule(java.lang.Object button, int rule) {
	((jButton)button).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jButton_setLayoutAll(java.lang.Object button, int idAnchor) {
	  ((jButton)button).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jButton_setMarginLeft(java.lang.Object button, int x) {
	((jButton)button).setMarginLeft(x);
}

//by jmpessoa
public void jButton_setMarginTop(java.lang.Object button, int y) {
	((jButton)button).setMarginTop(y);
}

//by jmpessoa
public void jButton_setMarginRight(java.lang.Object button, int x) {
	((jButton)button).setMarginRight(x);
}

//by jmpessoa
public void jButton_setMarginBottom(java.lang.Object button, int y) {
	((jButton)button).setMarginBottom(y);
}

/*
 * If i set android:focusable="true" then button is highlighted and focused, 
 * but then at the same time, 
 * i need to click twice on the button to perform the actual click event.
 */
//by jmpessoa
public  void jButton_setFocusable(java.lang.Object button, boolean enabled ) {
	jButton obj = (jButton)button;
obj.setClickable            (enabled);
obj.setEnabled              (enabled);
obj.setFocusable            (enabled);//*
obj.setFocusableInTouchMode (enabled);//*
//obj.requestFocus(); //*
}

// -------------------------------------------------------------------------
//  CheckBox
// -------------------------------------------------------------------------

public  java.lang.Object jCheckBox_Create(android.content.Context context,
                                         long pasobj ) {
  return (java.lang.Object)( new jCheckBox(context,this,pasobj));
}

//by jmpessoa
public  java.lang.Object jCheckBox_Create2(long pasobj ) {
return (java.lang.Object)( new jCheckBox(this.activity,this,pasobj));
}

public  void jCheckBox_Free(java.lang.Object checkbox) {
  jCheckBox obj = (jCheckBox)checkbox;
  obj.Free();
  //obj = null;
}

public  void jCheckBox_setXYWH (java.lang.Object checkbox,
                               int x, int y, int w, int h ) {
  ((jCheckBox)checkbox).setXYWH(x,y,w,h);
}

public void jCheckBox_setLeftTopRightBottomWidthHeight(java.lang.Object checkbox,
        int left, int top, int right, int bottom, int w, int h) {
((jCheckBox)checkbox).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}

public  void jCheckBox_setParent(java.lang.Object checkbox,
                                android.view.ViewGroup viewgroup) {
  ((jCheckBox)checkbox).setParent(viewgroup);
}

public  void jCheckBox_setText(java.lang.Object checkbox, String str) {
  ((jCheckBox)checkbox).setText(str);
}

public  void jCheckBox_setTextColor(java.lang.Object checkbox, int color) {
  ((jCheckBox)checkbox).setTextColor(color);
}

public  void jCheckBox_setTextSize(java.lang.Object checkbox, int pxSize) {
  ((jCheckBox)checkbox).setTextSize(TypedValue.COMPLEX_UNIT_PX,pxSize);
}

public  String jCheckBox_getText(java.lang.Object checkbox) {
  return ((jCheckBox)checkbox).getText().toString();
}

public  boolean jCheckBox_isChecked( java.lang.Object checkbox) {
  return ((jCheckBox)checkbox).isChecked();
}

public  void jCheckBox_setChecked( java.lang.Object checkbox, boolean value) {
  ((jCheckBox)checkbox).setChecked(value);
}

//by jmpessoa
public  void jCheckBox_setId(java.lang.Object checkbox, int id) {
	  ((jCheckBox)checkbox).setIdEx(id);
}

//by jmpessoa
public void jCheckBox_setLParamWidth(java.lang.Object checkbox, int w) {
	((jCheckBox)checkbox).setLParamWidth(w);
}

//by jmpessoa
public void jCheckBox_setLParamHeight(java.lang.Object checkbox, int h) {
	((jCheckBox)checkbox).setLParamHeight(h);
}

//by jmpessoa
public void jCheckBox_addLParamsAnchorRule(java.lang.Object checkbox, int rule) {
	((jCheckBox)checkbox).addLParamsAnchorRule(rule);
}

public void jCheckBox_addLParamsParentRule(java.lang.Object checkbox, int rule) {
	((jCheckBox)checkbox).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jCheckBox_setLayoutAll(java.lang.Object checkbox, int idAnchor) {
	  ((jCheckBox)checkbox).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jCheckBox_setMarginLeft(java.lang.Object checkbox, int x) {
	((jCheckBox)checkbox).setMarginLeft(x);
}

//by jmpessoa
public void jCheckBox_setMarginTop(java.lang.Object checkbox, int y) {
	((jCheckBox)checkbox).setMarginTop(y);
}

//by jmpessoa
public void jCheckBox_setMarginRight(java.lang.Object checkbox, int x) {
	((jCheckBox)checkbox).setMarginRight(x);
}

//by jmpessoa
public void jCheckBox_setMarginBottom(java.lang.Object checkbox, int y) {
	((jCheckBox)checkbox).setMarginBottom(y);
}

// -------------------------------------------------------------------------
//  RadioButton
// -------------------------------------------------------------------------

public  java.lang.Object jRadioButton_Create(android.content.Context context,
                                            long pasobj ) {
  return (java.lang.Object)( new jRadioButton(context,this,pasobj));
}

//by jmpessoa
public  java.lang.Object jRadioButton_Create2(long pasobj ) {
   return (java.lang.Object)( new jRadioButton(this.activity,this,pasobj));
}

public  void jRadioButton_Free(java.lang.Object radiobutton) {
  jRadioButton obj = (jRadioButton)radiobutton;
  obj.Free();
  //obj = null;
}

public  void jRadioButton_setXYWH (java.lang.Object radiobutton,
                               int x, int y, int w, int h ) {
  ((jRadioButton)radiobutton).setXYWH(x,y,w,h);
}

public void jRadioButton_setLeftTopRightBottomWidthHeight(java.lang.Object radiobutton,
        int left, int top, int right, int bottom, int w, int h) {
((jRadioButton)radiobutton).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}

public  void jRadioButton_setParent(java.lang.Object radiobutton,
                                android.view.ViewGroup viewgroup) {
  ((jRadioButton)radiobutton).setParent(viewgroup);
}

public  void jRadioButton_setText(java.lang.Object radiobutton, String str) {
  ((jRadioButton)radiobutton).setText(str);
}

public  void jRadioButton_setTextColor(java.lang.Object radiobutton, int color) {
  ((jRadioButton)radiobutton).setTextColor(color);
}

public  void jRadioButton_setTextSize(java.lang.Object radiobutton, int pxSize) {
  ((jRadioButton)radiobutton).setTextSize(TypedValue.COMPLEX_UNIT_PX,pxSize);
}

public  String jRadioButton_getText(java.lang.Object radiobutton) {
  return ((jRadioButton)radiobutton).getText().toString();
}

public  boolean jRadioButton_isChecked( java.lang.Object radiobutton) {
  return ((jRadioButton)radiobutton).isChecked();
}

public  void jRadioButton_setChecked( java.lang.Object radiobutton, boolean value) {
  ((jRadioButton)radiobutton).setChecked(value);
}

//by jmpessoa
public  void jRadioButton_setId(java.lang.Object radiobutton, int id) {
	  ((jRadioButton)radiobutton).setIdEx(id);
}

//by jmpessoa
public void jRadioButton_setLParamWidth(java.lang.Object radiobutton, int w) {
	((jRadioButton)radiobutton).setLParamWidth(w);
}

//by jmpessoa
public void jRadioButton_setLParamHeight(java.lang.Object radiobutton, int h) {
	((jRadioButton)radiobutton).setLParamHeight(h);
}

//by jmpessoa
public void jRadioButton_addLParamsAnchorRule(java.lang.Object radiobutton, int rule) {
	((jRadioButton)radiobutton).addLParamsAnchorRule(rule);
}

public void jRadioButton_addLParamsParentRule(java.lang.Object radiobutton, int rule) {
	((jEditText)radiobutton).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jRadioButton_setLayoutAll(java.lang.Object radiobutton, int idAnchor) {
	  ((jRadioButton)radiobutton).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jRadioButton_setMarginLeft(java.lang.Object radiobutton, int x) {
	((jRadioButton)radiobutton).setMarginLeft(x);
}

//by jmpessoa
public void jRadioButton_setMarginTop(java.lang.Object radiobutton, int y) {
	((jRadioButton)radiobutton).setMarginTop(y);
}

//by jmpessoa
public void jRadioButton_setMarginRight(java.lang.Object radiobutton, int x) {
	((jRadioButton)radiobutton).setMarginRight(x);
}

//by jmpessoa
public void jRadioButton_setMarginBottom(java.lang.Object radiobutton, int y) {
	((jRadioButton)radiobutton).setMarginBottom(y);
}
// -------------------------------------------------------------------------
//  ProgressBar
// -------------------------------------------------------------------------

public  java.lang.Object jProgressBar_Create(android.content.Context context,
                                            long pasobj, int style ) {
  return (java.lang.Object)( new jProgressBar(context,this,pasobj,style));
}


//by jmpessoa
public  java.lang.Object jProgressBar_Create2(long pasobj, int style ) {
  return (java.lang.Object)( new jProgressBar(this.activity,this,pasobj,style));
}

public  void jProgressBar_Free(java.lang.Object progressbar) {
  jProgressBar obj = (jProgressBar)progressbar;
  obj.Free();
  //obj = null;
}

public  void jProgressBar_setXYWH (java.lang.Object progressbar,
                               int x, int y, int w, int h ) {
  ((jProgressBar)progressbar).setXYWH(x,y,w,h);
}

public void jProgressBar_setLeftTopRightBottomWidthHeight(java.lang.Object progressbar,
        int left, int top, int right, int bottom, int w, int h) {
((jProgressBar)progressbar).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}

public  void jProgressBar_setParent(java.lang.Object progressbar,
                                android.view.ViewGroup viewgroup) {
  ((jProgressBar)progressbar).setParent(viewgroup);
}

public  int jProgressBar_getProgress(java.lang.Object progressbar) {
  return ( ((jProgressBar)progressbar).getProgress() );
}

public  void jProgressBar_setProgress(java.lang.Object progressbar, int progress) {
  ((jProgressBar)progressbar).setProgress(progress);
}

//by jmpessoa
public  void jProgressBar_setMax(java.lang.Object progressbar, int progress) {
  ((jProgressBar)progressbar).setMax(progress);
}

//by jmpessoa
public  int jProgressBar_getMax(java.lang.Object progressbar) {
  return ( ((jProgressBar)progressbar).getMax() ); 
}

//by jmpessoa
public  void jProgressBar_setId(java.lang.Object progressbar, int id) {
	  ((jProgressBar)progressbar).setIdEx(id);
}

//by jmpessoa
public void jProgressBar_setLParamWidth(java.lang.Object progressbar, int w) {
	((jProgressBar)progressbar).setLParamWidth(w);
}

//by jmpessoa
public void jProgressBar_setLParamHeight(java.lang.Object progressbar, int h) {
	((jProgressBar)progressbar).setLParamHeight(h);
}

//by jmpessoa
public void jProgressBar_addLParamsAnchorRule(java.lang.Object progressbar, int rule) {
	((jProgressBar)progressbar).addLParamsAnchorRule(rule);
}

public void jProgressBar_addLParamsParentRule(java.lang.Object progressbar, int rule) {
	((jProgressBar)progressbar).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jProgressBar_setLayoutAll(java.lang.Object progressbar, int idAnchor) {
	  ((jProgressBar)progressbar).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jProgressBar_setMarginLeft(java.lang.Object progressbar, int x) {
	((jProgressBar)progressbar).setMarginLeft(x);
}

//by jmpessoa
public void jProgressBar_setMarginTop(java.lang.Object progressbar, int y) {
	((jProgressBar)progressbar).setMarginTop(y);
}

//by jmpessoa
public void jProgressBar_setMarginRight(java.lang.Object progressbar, int x) {
	((jProgressBar)progressbar).setMarginRight(x);
}

//by jmpessoa
public void jProgressBar_setMarginBottom(java.lang.Object progressbar, int y) {
	((jProgressBar)progressbar).setMarginBottom(y);
}

// -------------------------------------------------------------------------
//  ImageView
// -------------------------------------------------------------------------

public  java.lang.Object jImageView_Create(android.content.Context context,
                                          long pasobj ) {
  return (java.lang.Object)( new jImageView(context,this,pasobj));
}

//by jmpessoa
public  java.lang.Object jImageView_Create2(long pasobj ) {
  return (java.lang.Object)( new jImageView(this.activity,this,pasobj));
}

public  void jImageView_Free(java.lang.Object imageview) {
 jImageView obj = (jImageView)imageview;
 obj.Free();
 //obj = null;
}

public  void jImageView_setXYWH  (java.lang.Object imageview,
                                 int x, int y, int w, int h ) {
  ((jImageView)imageview).setXYWH(x,y,w,h);
}

public void jImageView_setLeftTopRightBottomWidthHeight(java.lang.Object imageview,
        int left, int top, int right, int bottom, int w, int h) {
((jImageView)imageview).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}

public  void jImageView_setParent(java.lang.Object imageview,
                                 android.view.ViewGroup viewgroup) {
  ((jImageView)imageview).setParent(viewgroup);
}

public  void jImageView_setImage(java.lang.Object imageview, String str) {
  Bitmap bmp;
  bmp = ((jImageView)imageview).bmp;
  if (bmp != null)        { bmp.recycle(); }
  if (str.equals("null")) { ((jImageView)imageview).setImageBitmap(null);
                            return; };
  bmp = BitmapFactory.decodeFile( str );
  ((jImageView)imageview).setImageBitmap(bmp);
}

//by jmpessoa
public  void jImageView_setId(java.lang.Object imageview, int id) {
	  ((jImageView)imageview).setIdEx(id);
}

//by jmpessoa
//http://www.techrepublic.com/blog/software-engineer/androids-camera-intent-makes-taking-pics-a-snap/
public void jImageView_setBitmapImage(java.lang.Object imageview,  android.graphics.Bitmap bm) {
	((jImageView)imageview).setBitmapImage(bm);
}

//by jmpessoa
public void jImageView_setMarginLeft(java.lang.Object imageview, int x) {
	((jImageView)imageview).setMarginLeft(x);
}

//by jmpessoa
public void jImageView_setMarginTop(java.lang.Object imageview, int y) {
	((jImageView)imageview).setMarginTop(y);
}

//by jmpessoa
public void jImageView_setMarginRight(java.lang.Object imageview, int x) {
	((jImageView)imageview).setMarginRight(x);
}

//by jmpessoa
public void jImageView_setMarginBottom(java.lang.Object imageview, int y) {
	((jImageView)imageview).setMarginBottom(y);
}

//by jmpessoa
public void jImageView_setLParamWidth(java.lang.Object imageview, int w) {
	((jImageView)imageview).setLParamWidth(w);
}

//by jmpessoa
public void jImageView_setLParamHeight(java.lang.Object imageview, int h) {
	((jImageView)imageview).setLParamHeight(h);
}

//by jmpessoa
public void jImageView_addLParamsAnchorRule(java.lang.Object imageview, int rule) {
	((jImageView)imageview).addLParamsAnchorRule(rule);
}

public void jImageView_addLParamsParentRule(java.lang.Object imageview, int rule) {
	((jImageView)imageview).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jImageView_setLayoutAll(java.lang.Object imageview, int idAnchor) {
	  ((jImageView)imageview).setLayoutAll(idAnchor);
}

//by jmpessoa
public int jImageView_getLParamHeight(java.lang.Object imageview) {
	  return ((jImageView)imageview).getLParamHeight();
}

//by jmpessoa           
public int jImageView_getLParamWidth(java.lang.Object imageview) {
	return ((jImageView)imageview).getLParamWidth();	
}

// -------------------------------------------------------------------------
//  ListView
// -------------------------------------------------------------------------

/*
public  java.lang.Object jListView_Create(android.content.Context context,
                                         long pasobj, int hasWidget, String delim) {
  return (java.lang.Object)( new jListView(context,this,pasobj, hasWidget, delim));
}
*/

//by jmpessoa
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

public  void jListView_Free(java.lang.Object listview) {
  jListView obj = (jListView)listview;
  obj.Free();
  //obj = null;
}

public  void jListView_setXYWH  (java.lang.Object listview,
                                  int x, int y, int w, int h ) {
  ((jListView)listview).setXYWH(x,y,w,h);
}

public void jListView_setLeftTopRightBottomWidthHeight(java.lang.Object listview,
        int left, int top, int right, int bottom, int w, int h) {
((jListView)listview).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}

public  void jListView_setParent(java.lang.Object listview,
                                android.view.ViewGroup viewgroup) {
  ((jListView)listview).setParent(viewgroup);
}

public  void jListView_setTextColor(java.lang.Object listview, int color) {
  ((jListView)listview).setTextColor(color);
}

public  void jListView_setTextSize(java.lang.Object listview, int pxSize) {
  ((jListView)listview).setTextSize(pxSize);
}

// LORDMAN - 2013-08-07
public void jListView_setItemPosition (java.lang.Object listview, int position, int y)  {
  ((jListView)listview).setItemPosition(position, y);
}

/*
public  void jListView_add(java.lang.Object listview, String item) {
  ((jListView)listview).add(item);
}*/

// Item.delete
public  void jListView_delete   (java.lang.Object listview, int index)  {
  ((jListView)listview).delete(index);
}

// Item.clear
public  void jListView_clear    (java.lang.Object listview) {
  ((jListView)listview).clear();
}

//by jmpessoa
public  void jListView_setId(java.lang.Object listview, int id) {
	  ((jListView)listview).setIdEx(id);
}

//by jmpessoa
public void jListView_setLParamWidth(java.lang.Object listview, int w) {
	((jListView)listview).setLParamWidth(w);
}

//by jmpessoa
public void jListView_setLParamHeight(java.lang.Object listview, int h) {
	((jListView)listview).setLParamHeight(h);
}

//by jmpessoa
public void jListView_addLParamsAnchorRule(java.lang.Object listview, int rule) {
	((jListView)listview).addLParamsAnchorRule(rule);
}

public void jListView_addLParamsParentRule(java.lang.Object listview, int rule) {
	((jListView)listview).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jListView_setLayoutAll(java.lang.Object listview, int idAnchor) {
	  ((jListView)listview).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jListView_setMarginLeft(java.lang.Object listview, int x) {
	((jListView)listview).setMarginLeft(x);
}

//by jmpessoa
public void jListView_setMarginTop(java.lang.Object listview, int y) {
	((jListView)listview).setMarginTop(y);
}

//by jmpessoa
public void jListView_setMarginRight(java.lang.Object listview, int x) {
	((jListView)listview).setMarginRight(x);
}

//by jmpessoa
public void jListView_setMarginBottom(java.lang.Object listview, int y) {
	((jListView)listview).setMarginBottom(y);
}
// -------------------------------------------------------------------------
//  ScrollView
// -------------------------------------------------------------------------

public  java.lang.Object jScrollView_Create(android.content.Context context,
                                           long pasobj ) {
  return (java.lang.Object)( new jScrollView(context,this,pasobj));
}


//by jmpessoa
public  java.lang.Object jScrollView_Create2(long pasobj ) {
   return (java.lang.Object)( new jScrollView(this.activity,this,pasobj));
}

public  void jScrollView_Free(java.lang.Object scrollview) {
  jScrollView obj = (jScrollView)scrollview;
  obj.Free();
  //obj = null;
}

public  void jScrollView_setXYWH  (java.lang.Object scrollview,
                                  int x, int y, int w, int h ) {
  ((jScrollView)scrollview).setXYWH(x,y,w,h);
}

public void jScrollView_setLeftTopRightBottomWidthHeight(java.lang.Object scrollview,
        int left, int top, int right, int bottom, int w, int h) {
((jScrollView)scrollview).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}

public  void jScrollView_setParent(java.lang.Object scrollview,
                                  android.view.ViewGroup viewgroup) {
  ((jScrollView)scrollview).setParent(viewgroup);
}

public  void jScrollView_setScrollSize(java.lang.Object scrollview, int size) {
  ((jScrollView)scrollview).setScrollSize(size);
}

public  android.view.ViewGroup jScrollView_getView(java.lang.Object scrollview) {
  return (android.view.ViewGroup)( ((jScrollView)scrollview).getView() );
}

//by jmpessoa
public  void jScrollView_setId(java.lang.Object scrollview, int id) {
	  ((jScrollView)scrollview).setIdEx(id);
}

//by jmpessoa
public void jScrollView_setLParamWidth(java.lang.Object scrollview, int w) {
	((jScrollView)scrollview).setLParamWidth(w);
}

//by jmpessoa
public void jScrollView_setLParamHeight(java.lang.Object scrollview, int h) {
	((jScrollView)scrollview).setLParamHeight(h);
}

//by jmpessoa
public void jScrollView_addLParamsAnchorRule(java.lang.Object scrollview, int rule) {
	((jScrollView)scrollview).addLParamsAnchorRule(rule);
}

public void jScrollView_addLParamsParentRule(java.lang.Object scrollview, int rule) {
	((jScrollView)scrollview).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jScrollView_setLayoutAll(java.lang.Object scrollview, int idAnchor) {
	  ((jScrollView)scrollview).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jScrollView_setMarginLeft(java.lang.Object scrollview, int x) {
	((jScrollView)scrollview).setMarginLeft(x);
}

//by jmpessoa
public void jScrollView_setMarginTop(java.lang.Object scrollview, int y) {
	((jScrollView)scrollview).setMarginTop(y);
}

//by jmpessoa
public void jScrollView_setMarginRight(java.lang.Object scrollview, int x) {
	((jScrollView)scrollview).setMarginRight(x);
}

//by jmpessoa
public void jScrollView_setMarginBottom(java.lang.Object scrollview, int y) {
	((jScrollView)scrollview).setMarginBottom(y);
}


//-------------------------------------------------------------------------
//jPanel - new by jmpessoa
//-------------------------------------------------------------------------

public  java.lang.Object jPanel_Create(android.content.Context context,
                                       long pasobj ) {
return (java.lang.Object)(new jPanel(context,this,pasobj));
}


public  java.lang.Object jPanel_Create2(long pasobj ) {
   return (java.lang.Object)(new jPanel(this.activity,this,pasobj));
}

public  void jPanel_Free(java.lang.Object panel) {
	jPanel obj = (jPanel)panel;
    obj.Free();
//obj = null;
}

public  void jPanel_setXYWH  (java.lang.Object panel,
                              int x, int y, int w, int h ) {
((jPanel)panel).setXYWH(x,y,w,h);
}

public void jPanel_setLeftTopRightBottomWidthHeight(java.lang.Object panel,
        int left, int top, int right, int bottom, int w, int h) {
((jPanel)panel).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}


public  void jPanel_setParent(java.lang.Object panel,
                              android.view.ViewGroup viewgroup) {
((jPanel)panel).setParent(viewgroup);
}

public  android.widget.RelativeLayout jPanel_getView(java.lang.Object panel) {
   return (android.widget.RelativeLayout)(((jPanel)panel).getView());
}

//by jmpessoa
public  void jPanel_setId(java.lang.Object panel, int id) {
  ((jPanel)panel).setIdEx(id);
}

//by jmpessoa
public void jPanel_setLParamWidth(java.lang.Object panel, int w) {
((jPanel)panel).setLParamWidth(w);
}

//by jmpessoa
public void jPanel_setLParamHeight(java.lang.Object panel, int h) {
((jPanel)panel).setLParamHeight(h);
}

//by jmpessoa
public int jPanel_getLParamHeight(java.lang.Object panel) {
	  return ((jPanel)panel).getLParamHeight();
}

//by jmpessoa           
public int jPanel_getLParamWidth(java.lang.Object panel) {
	return ((jPanel)panel).getLParamWidth();	
}

//by jmpessoa
public void jPanel_resetLParamsRules(java.lang.Object panel) {
((jPanel)panel).resetLParamsRules();
}

//by jmpessoa
public void jPanel_addLParamsAnchorRule(java.lang.Object panel, int rule) {
((jPanel)panel).addLParamsAnchorRule(rule);
}

public void jPanel_addLParamsParentRule(java.lang.Object panel, int rule) {
((jPanel)panel).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jPanel_setLayoutAll(java.lang.Object panel, int idAnchor) {
  ((jPanel)panel).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jPanel_setMarginLeft(java.lang.Object panel, int x) {
((jPanel)panel).setMarginLeft(x);
}

//by jmpessoa
public void jPanel_setMarginTop(java.lang.Object panel, int y) {
((jPanel)panel).setMarginTop(y);
}

//by jmpessoa
public void jPanel_setMarginRight(java.lang.Object panel, int x) {
((jPanel)panel).setMarginRight(x);
}

//by jmpessoa
public void jPanel_setMarginBottom(java.lang.Object panel, int y) {
((jPanel)panel).setMarginBottom(y);
}

// -------------------------------------------------------------------------
//  ViewFlipper
// -------------------------------------------------------------------------

public  java.lang.Object jViewFlipper_Create(android.content.Context context,
                                            long pasobj ) {
  return (java.lang.Object)( new jViewFlipper(context,this,pasobj));
}

public  java.lang.Object jViewFlipper_Create2(long pasobj ) {
   return (java.lang.Object)( new jViewFlipper(this.activity,this,pasobj));
}

public  void jViewFlipper_Free(java.lang.Object viewflipper) {
  jViewFlipper obj = (jViewFlipper)viewflipper;
  obj.Free();
  //obj = null;
}

public  void jViewFlipper_setXYWH  (java.lang.Object viewflipper,
                                  int x, int y, int w, int h ) {
  ((jViewFlipper)viewflipper).setXYWH(x,y,w,h);
}

public void jViewFlipper_setLeftTopRightBottomWidthHeight(java.lang.Object viewflipper,
        int left, int top, int right, int bottom, int w, int h) {
((jViewFlipper)viewflipper).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}


public  void jViewFlipper_setParent(java.lang.Object viewflipper,
                                  android.view.ViewGroup viewgroup) {
  ((jViewFlipper)viewflipper).setParent(viewgroup);
}

//by jmpessoa
public  void jViewFlipper_setId(java.lang.Object viewflipper, int id) {
	  ((jViewFlipper)viewflipper).setIdEx(id);
}

//by jmpessoa
public void jViewFlipper_setLParamWidth(java.lang.Object viewflipper, int w) {
	((jViewFlipper)viewflipper).setLParamWidth(w);
}

//by jmpessoa
public void jViewFlipper_setLParamHeight(java.lang.Object viewflipper, int h) {
	((jViewFlipper)viewflipper).setLParamHeight(h);
}

//by jmpessoa
public void jViewFlipper_addLParamsAnchorRule(java.lang.Object viewflipper, int rule) {
	((jViewFlipper)viewflipper).addLParamsAnchorRule(rule);
}

public void jViewFlipper_addLParamsParentRule(java.lang.Object viewflipper, int rule) {
	((jViewFlipper)viewflipper).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jViewFlipper_setLayoutAll(java.lang.Object viewflipper, int idAnchor) {
	  ((jViewFlipper)viewflipper).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jViewFlipper_setMarginLeft(java.lang.Object viewflipper, int x) {
	((jViewFlipper)viewflipper).setMarginLeft(x);
}

//by jmpessoa
public void jViewFlipper_setMarginTop(java.lang.Object viewflipper, int y) {
	((jViewFlipper)viewflipper).setMarginTop(y);
}

//by jmpessoa
public void jViewFlipper_setMarginRight(java.lang.Object viewflipper, int x) {
	((jViewFlipper)viewflipper).setMarginRight(x);
}

//by jmpessoa
public void jViewFlipper_setMarginBottom(java.lang.Object viewflipper, int y) {
	((jViewFlipper)viewflipper).setMarginBottom(y);
}
// -------------------------------------------------------------------------
//  WebView
// -------------------------------------------------------------------------

public  java.lang.Object jWebView_Create(android.content.Context context,
                                           long pasobj ) {
  return (java.lang.Object)( new jWebView(context,this,pasobj));
}

//by jmpessoa
public  java.lang.Object jWebView_Create2(long pasobj ) {
  return (java.lang.Object)( new jWebView(this.activity,this,pasobj));
}

public  void jWebView_Free(java.lang.Object webview) {
  jWebView obj = (jWebView)webview;
  obj.Free();
  //obj = null;
}

public  void jWebView_setXYWH  (java.lang.Object webview,
                                  int x, int y, int w, int h ) {
  ((jWebView)webview).setXYWH(x,y,w,h);
}

public void jWebView_setLeftTopRightBottomWidthHeight(java.lang.Object webview,
        int left, int top, int right, int bottom, int w, int h) {
((jWebView)webview).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}


public  void jWebView_setParent(java.lang.Object webview,
                                  android.view.ViewGroup viewgroup) {
  ((jWebView)webview).setParent(viewgroup);
}

public  void jWebView_setJavaScript(java.lang.Object webview,boolean javascript) {
  Log.i("Java","Here");
  ((jWebView)webview).getSettings().setJavaScriptEnabled(javascript);
}

public  void jWebView_loadURL(java.lang.Object webview, String str) {
  ((jWebView)webview).loadUrl("about:blank");
  ((jWebView)webview).loadUrl(str);
}

//by jmpessoa
public  void jWebView_setId(java.lang.Object webview, int id) {
	  ((jWebView)webview).setIdEx(id);
}

//by jmpessoa
public void jWebView_setLParamWidth(java.lang.Object webview, int w) {
	((jWebView)webview).setLParamWidth(w);
}

//by jmpessoa
public void jWebView_setLParamHeight(java.lang.Object webview, int h) {
	((jWebView)webview).setLParamHeight(h);
}

//by jmpessoa
public void jWebView_addLParamsAnchorRule(java.lang.Object webview, int rule) {
	((jWebView)webview).addLParamsAnchorRule(rule);
}

public void jWebView_addLParamsParentRule(java.lang.Object webview, int rule) {
	((jWebView)webview).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jWebView_setLayoutAll(java.lang.Object webview, int idAnchor) {
	  ((jWebView)webview).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jWebView_setMarginLeft(java.lang.Object webview, int x) {
	((jWebView)webview).setMarginLeft(x);
}

//by jmpessoa
public void jWebView_setMarginTop(java.lang.Object webview, int y) {
	((jWebView)webview).setMarginTop(y);
}

//by jmpessoa
public void jWebView_setMarginRight(java.lang.Object webview, int x) {
	((jWebView)webview).setMarginRight(x);
}

//by jmpessoa
public void jWebView_setMarginBottom(java.lang.Object webview, int y) {
	((jWebView)webview).setMarginBottom(y);
}
// -------------------------------------------------------------------------
//  Canvas : canvas + paint
// -------------------------------------------------------------------------

public  java.lang.Object jCanvas_Create( long pasobj) {
  return (java.lang.Object)( new jCanvas(this,pasobj));
}

public  void jCanvas_Free(java.lang.Object canvas) {
  jCanvas obj = (jCanvas)canvas;
  obj.Free();
  //obj = null;
}

public  void jCanvas_setStrokeWidth (java.lang.Object canvas,float width ) {
  ((jCanvas)canvas).setStrokeWidth(width);
}

public  void jCanvas_setStyle(java.lang.Object canvas, int style ) {
  ((jCanvas)canvas).setStyle(style);
}

public  void jCanvas_setColor(java.lang.Object canvas, int color) {
  ((jCanvas)canvas).setColor(color);
}

public  void jCanvas_setTextSize(java.lang.Object canvas, float textsize) {
  ((jCanvas)canvas).setTextSize(textsize);
}

public  void jCanvas_drawLine(java.lang.Object canvas, float x1, float y1, float x2, float y2) {
  ((jCanvas)canvas).drawLine(x1,y1,x2,y2);
}

public  void jCanvas_drawText(java.lang.Object canvas, String text, float x, float y) {
  ((jCanvas)canvas).drawText(text,x,y);
}

public  void jCanvas_drawBitmap(java.lang.Object canvas, Bitmap bmp, int b, int l, int r, int t) {
  ((jCanvas)canvas).drawBitmap(bmp,b,l,r,t);
}

// -------------------------------------------------------------------------
//  Bitmap
// -------------------------------------------------------------------------

public  java.lang.Object jBitmap_Create( long pasobj ) {
  return (java.lang.Object)( new jBitmap(this,pasobj));
}

public  void jBitmap_Free(java.lang.Object bitmap) {
  jBitmap obj = (jBitmap)bitmap;
  obj.Free();
  //obj = null;
}

public  void jBitmap_loadFile(java.lang.Object bitmap, String filename) {
  ((jBitmap)bitmap).loadFile(filename);
}

public  void jBitmap_saveFile(java.lang.Object bitmap, String filename, int format) {
  try{
    File file = new File(filename);
    FileOutputStream fos = activity.openFileOutput(filename , Context.MODE_PRIVATE);
    //
    if (format == Const.CompressFormat_PNG)
         { ((jBitmap)bitmap).bmp.compress(CompressFormat.PNG, 100 , fos); }
    else { ((jBitmap)bitmap).bmp.compress(CompressFormat.JPEG, 95 , fos); };
    fos.flush();
    fos.close(); }
  catch(Exception e)
    { };
}

public  void jBitmap_createBitmap (java.lang.Object bitmap,int w, int h) {
  ((jBitmap)bitmap).createBitmap(w,h);
}

public  int[] jBitmap_getWH( java.lang.Object bitmap) {
  return ( ((jBitmap)bitmap).getWH() );
}

public  Bitmap jBitmap_jInstance( java.lang.Object bitmap) {
  return ( ((jBitmap)bitmap).bmp );
}

// -------------------------------------------------------------------------
//  View
// -------------------------------------------------------------------------

public  java.lang.Object jView_Create(android.content.Context context, long pasobj ) {
  return (java.lang.Object)( new jView(context,this,pasobj));
}

//by jmpessoa
public  java.lang.Object jView_Create2(long pasobj ) {
  return (java.lang.Object)( new jView(this.activity,this,pasobj));
}

public  void jView_Free(java.lang.Object view) {
  jView obj = (jView)view;
  obj.Free();
  //obj = null;
}

public  void jView_setXYWH  (java.lang.Object view,int x, int y, int w, int h ) {
  ((jView)view).setXYWH(x,y,w,h);
}

public void jView_setLeftTopRightBottomWidthHeight(java.lang.Object view,
        int left, int top, int right, int bottom, int w, int h) {
((jView)view).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}


public  void jView_setParent(java.lang.Object view, android.view.ViewGroup viewgroup) {
  ((jView)view).setParent(viewgroup);
}

public  void jView_setjCanvas(java.lang.Object view, java.lang.Object canvas) {
  ((jView)view).setjCanvas( (jCanvas)canvas );
}

public  void jView_saveView(java.lang.Object view, String filename) {
  ((jView)view).saveView(filename);
}

//by jmpessoa
public  void jView_setId(java.lang.Object view, int id) {
	  ((jView)view).setIdEx(id);
}

//by jmpessoa
public void jView_setLParamWidth(java.lang.Object view, int w) {
	((jView)view).setLParamWidth(w);
}

//by jmpessoa
public void jView_setLParamHeight(java.lang.Object view, int h) {
	((jView)view).setLParamHeight(h);
}

//by jmpessoa
public void jView_addLParamsAnchorRule(java.lang.Object view, int rule) {
	((jView)view).addLParamsAnchorRule(rule);
}

public void jView_addLParamsParentRule(java.lang.Object view, int rule) {
	((jView)view).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jView_setLayoutAll(java.lang.Object view, int idAnchor) {
	  ((jView)view).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jView_setMarginLeft(java.lang.Object view, int x) {
	((jView)view).setMarginLeft(x);
}

//by jmpessoa
public void jView_setMarginTop(java.lang.Object view, int y) {
	((jView)view).setMarginTop(y);
}

//by jmpessoa
public void jView_setMarginRight(java.lang.Object view, int x) {
	((jView)view).setMarginRight(x);
}

//by jmpessoa
public void jView_setMarginBottom(java.lang.Object view, int y) {
	((jView)view).setMarginBottom(y);
}

//by jmpessoa
public int jView_getLParamHeight(java.lang.Object view) {
	  return ((jView)view).getLParamHeight();
}

//by jmpessoa           
public int jView_getLParamWidth(java.lang.Object view) {
	return ((jView)view).getLParamWidth();	
}

// -------------------------------------------------------------------------
//  GLView
// -------------------------------------------------------------------------

public  java.lang.Object jGLSurfaceView_Create(android.content.Context context,
                                              long pasobj, int version ) {
  return (java.lang.Object)( new jGLSurfaceView(context,this,pasobj,version));
}

//by jmpessoa
public  java.lang.Object jGLSurfaceView_Create2(long pasobj, int version ) {
  return (java.lang.Object)( new jGLSurfaceView(this.activity,this,pasobj,version));
}

public  void jGLSurfaceView_Free(java.lang.Object surfaceview) {
  jGLSurfaceView obj = (jGLSurfaceView)surfaceview;
  obj.Free();
  //obj = null;
}

public  void jGLSurfaceView_setXYWH  (java.lang.Object surfaceview,
                                     int x, int y, int w, int h ) {
  ((jGLSurfaceView)surfaceview).setXYWH(x,y,w,h);
}

public void jGLSurfaceView_setLeftTopRightBottomWidthHeight(java.lang.Object surfaceview,
        int left, int top, int right, int bottom, int w, int h) {
((jGLSurfaceView)surfaceview).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}


public  void jGLSurfaceView_setParent(java.lang.Object surfaceview,
                                     android.view.ViewGroup viewgroup) {
  ((jGLSurfaceView)surfaceview).setParent(viewgroup);
}


public  void jGLSurfaceView_SetAutoRefresh(java.lang.Object glView, boolean active ) {
  if (active) { ((jGLSurfaceView)glView).setRenderMode( GLSurfaceView.RENDERMODE_CONTINUOUSLY ); }
        else  { ((jGLSurfaceView)glView).setRenderMode( GLSurfaceView.RENDERMODE_WHEN_DIRTY   ); }
}

public  void jGLSurfaceView_Refresh(java.lang.Object glView) {
  ((GLSurfaceView)glView).requestRender();
}

// public  void jGLSurfaceView_Refresh(java.lang.Object surfaceview) {
//   ((jGLSurfaceView)surfaceview).genRender(); //requestRender();
// }

public  void jGLSurfaceView_deleteTexture(java.lang.Object surfaceview, int id) {
  ((jGLSurfaceView)surfaceview).deleteTexture(id);
}

public  void jGLSurfaceView_glThread(java.lang.Object surfaceview) {
  ((jGLSurfaceView)surfaceview).glThread();
}

//by jmpessoa
public  void jGLSurfaceView_setId(java.lang.Object surfaceview, int id) {
	  ((jGLSurfaceView)surfaceview).setIdEx(id);
}

//by jmpessoa
public void jGLSurfaceView_setLParamWidth(java.lang.Object surfaceview, int w) {
	((jGLSurfaceView)surfaceview).setLParamWidth(w);
}

//by jmpessoa
public void jGLSurfaceView_setLParamHeight(java.lang.Object surfaceview, int h) {
	((jGLSurfaceView)surfaceview).setLParamHeight(h);
}

//by jmpessoa
public int jGLSurfaceView_getLParamHeight(java.lang.Object surfaceview) {
	  return ((jGLSurfaceView)surfaceview).getLParamHeight();
}

//by jmpessoa           
public int jGLSurfaceView_getLParamWidth(java.lang.Object surfaceview) {
	return ((jGLSurfaceView)surfaceview).getLParamWidth();	
}


//by jmpessoa
public void jGLSurfaceView_addLParamsAnchorRule(java.lang.Object surfaceview, int rule) {
	((jGLSurfaceView)surfaceview).addLParamsAnchorRule(rule);
}

public void jGLSurfaceView_addLParamsParentRule(java.lang.Object surfaceview, int rule) {
	((jGLSurfaceView)surfaceview).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jGLSurfaceView_setLayoutAll(java.lang.Object surfaceview, int idAnchor) {
	  ((jGLSurfaceView)surfaceview).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jGLSurfaceView_setMarginLeft(java.lang.Object surfaceview, int x) {
	((jGLSurfaceView)surfaceview).setMarginLeft(x);
}

//by jmpessoa
public void jGLSurfaceView_setMarginTop(java.lang.Object surfaceview, int y) {
	((jGLSurfaceView)surfaceview).setMarginTop(y);
}

//by jmpessoa
public void jGLSurfaceView_setMarginRight(java.lang.Object surfaceview, int x) {
	((jGLSurfaceView)surfaceview).setMarginRight(x);
}

//by jmpessoa
public void jGLSurfaceView_setMarginBottom(java.lang.Object surfaceview, int y) {
	((jGLSurfaceView)surfaceview).setMarginBottom(y);
}

// -------------------------------------------------------------------------
//  Timer
// -------------------------------------------------------------------------
public  java.lang.Object jTimer_Create(long pasobj) {
  return (jTimer)(new jTimer(this,pasobj) );
}

public  void jTimer_Free(java.lang.Object timer) {
  jTimer obj = (jTimer)timer;
  obj.Free();
  //obj = null;
}

public  void jTimer_SetInterval(java.lang.Object timer, int interval ) {
  ((jTimer)timer).SetInterval(interval);
}

public  void jTimer_SetEnabled(java.lang.Object timer, boolean active ) {
  ((jTimer)timer).SetEnabled(active);
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

public  void jDialogYN_Free(java.lang.Object dialog) {
  jDialogYN obj = (jDialogYN)dialog;
  obj.Free();
  //obj = null;
}

public  void jDialogYN_Show(java.lang.Object dialog ) {
  Log.i("Java","jDialogYN_Show");
  if ( dialog instanceof jDialogYN ) { Log.i("Java","jDialogYN -> YES"); }
  else                               { Log.i("Java","jDialogYN -> No" ); }
  ((jDialogYN)dialog).show();
}

// -------------------------------------------------------------------------
//  Dialog Progress
// -------------------------------------------------------------------------

public  java.lang.Object jDialogProgress_Create(long pasobj,
                                               String title, String msg) {
  return (jDialogProgress)(new jDialogProgress(activity,this,pasobj,title,msg ) );
}

public  void jDialogProgress_Free(java.lang.Object dialog) {
  jDialogProgress obj = (jDialogProgress)dialog;
  obj.Free();
  //obj = null;
}

// -------------------------------------------------------------------------
//  Toast
// -------------------------------------------------------------------------

//
public  void jToast( String str ) {
  Toast.makeText(activity, str, Toast.LENGTH_SHORT).show();
}

//by jmpessoa
public  void jToast2(android.content.Context context,  String str ) {
	  Toast.makeText(context, str, Toast.LENGTH_SHORT).show();
}

// -------------------------------------------------------------------------
//  jImageBtn
// -------------------------------------------------------------------------

public  java.lang.Object jImageBtn_Create(android.content.Context context, long pasobj ) {
  return (java.lang.Object)( new jImageBtn(context,this,pasobj));
}

//by jmpessoa
public  java.lang.Object jImageBtn_Create2(long pasobj ) {
	return (java.lang.Object)( new jImageBtn(this.activity,this,pasobj));
}

public  void jImageBtn_Free(java.lang.Object imagebtn) {
  jImageBtn obj = (jImageBtn)imagebtn;
  obj.Free();
  //obj = null;
}

public  void jImageBtn_setXYWH  (java.lang.Object imagebtn,int x, int y, int w, int h ) {
  ((jImageBtn)imagebtn).setXYWH(x,y,w,h);
}

public void jImageBtn_setLeftTopRightBottomWidthHeight(java.lang.Object imagebtn,
        int left, int top, int right, int bottom, int w, int h) {
((jImageBtn)imagebtn).setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);	
}

public  void jImageBtn_setParent(java.lang.Object imagebtn, android.view.ViewGroup viewgroup) {
  ((jImageBtn)imagebtn).setParent(viewgroup);
}

public  void jImageBtn_setButton(java.lang.Object imagebtn, String bmpup, String bmpdn ) {
  ((jImageBtn)imagebtn).setButton(bmpup,bmpdn);
}

//by jmpessoa
public  void jImageBtn_setButtonUp(java.lang.Object imagebtn, String bmpup) {
	  ((jImageBtn)imagebtn).setButtonUp(bmpup);
}

//by jmpessoa
public  void jImageBtn_setButtonDown(java.lang.Object imagebtn, String bmpdn ) {
	  ((jImageBtn)imagebtn).setButtonDown(bmpdn);
}

// LORDMAN 2013-08-16
public  void jImageBtn_setEnabled(java.lang.Object imagebtn, boolean enabled ) {
  ((jImageBtn)imagebtn).setEnabled(enabled);
}

//by jmpessoa
public  void jImageBtn_setId(java.lang.Object imagebtn, int id) {
	  ((jImageBtn)imagebtn).setIdEx(id);
}

//by jmpessoa
public void jImageBtn_setLParamWidth(java.lang.Object imagebtn, int w) {
	((jImageBtn)imagebtn).setLParamWidth(w);
}

//by jmpessoa
public void jImageBtn_setLParamHeight(java.lang.Object imagebtn, int h) {
	((jImageBtn)imagebtn).setLParamHeight(h);
}

//by jmpessoa
public void jImageBtn_addLParamsAnchorRule(java.lang.Object imagebtn, int rule) {
	((jImageBtn)imagebtn).addLParamsAnchorRule(rule);
}

public void jImageBtn_addLParamsParentRule(java.lang.Object imagebtn, int rule) {
	((jImageBtn)imagebtn).addLParamsParentRule(rule);
}

//by jmpessoa
public  void jImageBtn_setLayoutAll(java.lang.Object imagebtn, int idAnchor) {
	  ((jImageBtn)imagebtn).setLayoutAll(idAnchor);
}

//by jmpessoa
public void jImageBtn_setMarginLeft(java.lang.Object imagebtn, int x) {
	((jImageBtn)imagebtn).setMarginLeft(x);
}

//by jmpessoa
public void jImageBtn_setMarginTop(java.lang.Object imagebtn, int y) {
	((jImageBtn)imagebtn).setMarginTop(y);
}

//by jmpessoa
public void jImageBtn_setMarginRight(java.lang.Object imagebtn, int x) {
	((jImageBtn)imagebtn).setMarginRight(x);
}

//by jmpessoa
public void jImageBtn_setMarginBottom(java.lang.Object imagebtn, int y) {
	((jImageBtn)imagebtn).setMarginBottom(y);
}
// -------------------------------------------------------------------------
//  jAsyncTask
// -------------------------------------------------------------------------

public  java.lang.Object jAsyncTask_Create(long pasobj ) {
  return (java.lang.Object)( new jAsyncTask(this,pasobj));
}

public  void jAsyncTask_Free(java.lang.Object asynctask) {
  jAsyncTask obj = (jAsyncTask)asynctask;
  obj.Free();
}

public  void jAsyncTask_Execute(java.lang.Object asynctask) {
  ((jAsyncTask)asynctask).execute();
}


public  void jAsyncTask_setProgress(java.lang.Object asynctask, int progress) {
  ((jAsyncTask)asynctask).setProgress(progress);
}

// -------------------------------------------------------------------------
//  Http API
//  Why ?
//        android:minSdkVersion       = "9"   ---> OK
//        android:minSdkVersion       = "10"  ---> Not OK
//
//  Ref. http://theeye.pe.kr/entry/how-to-get-and-multipart-post-on-android-platform
//       http://cafe.naver.com/securitycommunity/56
//       http://stackoverflow.com/questions/8179658/urlconnection-getcontent-return-null
//       http://blog.naver.com/since201109?Redirect=Log&logNo=150169407558
//       http://www.java-samples.com/showtutorial.php?tutorialid=1521
//
//
//
// -------------------------------------------------------------------------


public  String jHttp_get(String url) {
  String rst = "";
  try {
    HttpClient client = new DefaultHttpClient();
    HttpGet    get    = new HttpGet(url);
    HttpResponse resp = client.execute(get);
    /*
    BufferedReader br = new BufferedReader(new InputStreamReader(resp.getEntity().getContent()));
    String str = null;
    StringBuilder sb = new StringBuilder();
    while ((rst = br.readLine()) != null) {
      sb.append(str).append("\n"); }
    br.close();
    rst = sb.toString();
    */
    HttpEntity resEntityGet = resp.getEntity();
    if (resp != null) {
      rst = EntityUtils.toString(resEntityGet);  }

    Log.i("RESPONSE", rst);  }
  catch (Exception e) {
    Log.i("Java","Error");
    e.printStackTrace();
  };
  return(rst);
};

//by jmpessoa
//http://blog.dahanne.net/2009/08/16/how-to-access-http-resources-from-android/
public String jHttp_get2(String location) throws Throwable {
	HttpURLConnection con = null;
	URL url;
	InputStream is=null;
		url = new URL(location);
		con = (HttpURLConnection) url.openConnection();
		//con.setReadTimeout(10000 /* milliseconds */);
		//con.setConnectTimeout(15000 /* milliseconds */);
		con.setRequestMethod("GET");
		con.setDoInput(true);
		//con.addRequestProperty("Referer", location);
		// Start the query
		con.connect();
		is = con.getInputStream();
	
    BufferedReader rd = new BufferedReader(new InputStreamReader(is), 4096);
    String line;
    StringBuilder sb =  new StringBuilder();
	while ((line = rd.readLine()) != null) {
		    sb.append(line);
	}
	rd.close();
    return  sb.toString();
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

//http://www.developerfeed.com/java/tutorial/sending-sms-using-android
//http://www.techrepublic.com/blog/software-engineer/how-to-send-a-text-message-from-within-your-android-app/
public int jSend_SMS(String phoneNumber, String msg) {
	  try {
	      SmsManager.getDefault().sendTextMessage(phoneNumber, null, msg, null, null);
	      return 1; //ok
	  }catch (Exception e) {
	      return 0; //fail
	  }
}

//by jmpessoa
//http://eagle.phys.utk.edu/guidry/android/readContacts.html
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

//by jmpessoa
public  java.lang.Object jSqliteCursor_Create( long pasobj ) {
	return (java.lang.Object)( new jSqliteCursor(this,pasobj) );
}

//by jmpessoa
public  java.lang.Object jSqliteDataAccess_Create(long pasobj, String databaseName, char colDelim, char rowDelim) {
	return (java.lang.Object)( new jSqliteDataAccess(this,pasobj,databaseName,colDelim,rowDelim) );
}

/* TODO: by jmpessoa
public  java.lang.Object jMediaPlayer_Create(long pasobj, String pathToFileName) {
	return (java.lang.Object)( new jMediaPlayer(this,pasobj,pathToFileName) );
} */


} //END - class Controls


