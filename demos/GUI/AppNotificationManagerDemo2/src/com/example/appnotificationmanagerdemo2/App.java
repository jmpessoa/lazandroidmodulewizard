package com.example.appnotificationmanagerdemo2;

//Lamw: Lazarus Android Module Wizard - version 0.8.6 - 30 October - 2020
//Form Designer and Components development model!
//https://github.com/jmpessoa/lazandroidmodulewizard
//http://forum.lazarus.freepascal.org/index.php/topic,21919.270.html

//Android Java Interface for Pascal/Delphi XE5
//And LAZARUS by Jose Marques Pessoa [december 2013]

//Developers
//          Simon,Choi / Choi,Won-sik
//                       simonsayz@naver.com
//                       http://blog.naver.com/simonsayz
//
//          LoadMan    / Jang,Yang-Ho
//                       wkddidgh@naver.com
//                       http://blog.naver.com/wkddidgh

//	    Jose Marques Pessoa  /  josemarquespessoa@gmail.com


import java.lang.Override;
import java.lang.reflect.Method;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.pm.ActivityInfo;
import android.view.Window;
import android.widget.RelativeLayout;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.os.Bundle;
import android.os.StrictMode;
import android.util.Log;
import android.content.Context;
import android.graphics.Canvas;

public class App extends Activity {
    
    private Controls       controls;
    
    private int screenOrientation = 0; //For update screen orientation. [by TR3E]
    private boolean rlSizeChanged = false;
    
    //New "RelativeLayout" adapted to "Multiwindow" and automatic resizing. [by TR3E]
    public class RLAppLayout extends RelativeLayout {
    	
    	public RLAppLayout(Context context) {
            super(context);
        }             

        @Override
        protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        	super.onSizeChanged(w, h, oldw, oldh);
        	        	      
            if ((controls.screenWidth != w) || (controls.screenHeight != h)){            	
            	controls.screenWidth  = w;
            	controls.screenHeight = h;
            	rlSizeChanged = true;            	
            }
                        
        }
        
        @Override
        protected void onDraw(Canvas canvas) {
            super.onDraw(canvas);                                    
            
            // If change size call "jAppOnRotate" for update screen. [by TR3E]
            if( controls.formChangeSize || rlSizeChanged ){            	
            	controls.formChangeSize = false;
            	rlSizeChanged = false;
            	
            	controls.formNeedLayout = true;
            	
            	//ssPortrait  = 1, //Force Portrait
                //ssLandscape = 2, //Force LandScape
            	if( controls.screenWidth < controls.screenHeight ) screenOrientation = 1;
            	if( controls.screenWidth > controls.screenHeight ) screenOrientation = 2;
            	
            	controls.jAppOnRotate(screenOrientation);
            }
            
            // Call updatelayout automatically if necessary. [by TR3E]
            if( controls.formNeedLayout ){
            	controls.formNeedLayout = false;
                controls.jAppOnUpdateLayout();
            }
        }
    }
	   
    @Override
    public void onCreate(Bundle savedInstanceState) {
     super.onCreate(savedInstanceState);          
     
      //ref. http://stackoverflow.com/questions/8706464/defaulthttpclient-to-androidhttpclient 
     int systemVersion = android.os.Build.VERSION.SDK_INT; 
     if (systemVersion > 9) {
         StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
         StrictMode.setThreadPolicy(policy);
     }
     
      //Log.i("jApp","01.Activity.onCreate");
      controls             = new Controls();
      controls.activity    = this;
      
      controls.screenWidth  = getResources().getDisplayMetrics().widthPixels;
      controls.screenHeight = getResources().getDisplayMetrics().heightPixels;
      
      //New "RelativeLayout" adapted to "Multiwindows" and automatic resizing. [by TR3E]
      controls.appLayout   = new RLAppLayout(this);
      controls.appLayout.getRootView().setBackgroundColor (0x00FFFFFF);
      
      controls.screenStyle = controls.jAppOnScreenStyle();
      controls.systemVersion = systemVersion;
      
      switch( controls.screenStyle ) {
      	case 1  : this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT );  break;
      	case 2  : this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);  break;
      	default : ; // Device Default , Rotation by Device
      }
      
      this.setContentView(controls.appLayout);
      
      this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
      
      controls.jAppOnCreate(this, controls.appLayout, getIntent());
      
      // Force updating the screen would need for Android 8 or higher [by TR3E]
      controls.appLayout.requestLayout();                 
    }

   //[ifdef_api23up]
    @Override
    public void onRequestPermissionsResult(int permsRequestCode, String[] permissions, int[] grantResults){
    	super.onRequestPermissionsResult(permsRequestCode, permissions, grantResults);
    	
        if ( (permissions.length > 0) && (grantResults.length > 0) ) {
            for (int i = 0; i < permissions.length; i++) {
                controls.jAppOnRequestPermissionResult(permsRequestCode, permissions[i], grantResults[i]);
            }
        }
    } //[endif_api23up]

    @Override    
    protected void onNewIntent(Intent intent) {
    	super.onNewIntent(intent);
    	//Bundle extras = intent.getExtras();    	
    	//if (extras != null) Log.i("onNewIntent",  extras.getString("data"));
    	
    	controls.jAppOnNewIntent(intent);}
    
    @Override
    protected void onDestroy() { super.onDestroy(); controls.jAppOnDestroy();}
    
    @Override
    protected void onPause() {super.onPause(); controls.jAppOnPause();}
    
    @Override
    protected void onRestart() {super.onRestart(); controls.jAppOnRestart();}
                                    	                                        
    @Override
    protected void onResume() { super.onResume(); controls.jAppOnResume(); }
    	                                        
    @Override
    protected void onStart() { super.onStart(); controls.jAppOnStart(); }
                                                  	                                        
    @Override
    protected void onStop() { super.onStop(); controls.jAppOnStop();} 
    	                                        
    @Override
    public    void onBackPressed() { controls.jAppOnBackPressed();}
    
    @Override
    public    void onConfigurationChanged(Configuration newConfig) {
    	super.onConfigurationChanged(newConfig);    
    	
    	screenOrientation = newConfig.orientation;
    	
    	controls.appLayout.requestLayout();
    }	   	
 
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {    	
     controls.jAppOnActivityResult(requestCode,resultCode,data);                                     
    }

    // http://stackoverflow.com/questions/15686555/display-back-button-on-action-bar
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
	 switch (item.getItemId()) {
        case android.R.id.home:
            // app icon in action bar clicked; go home
	    controls.jAppOnBackPressed();
            return true;
        default:
		String caption = item.getTitle().toString();
		controls.jAppOnClickOptionMenuItem(item, item.getItemId(), caption, item.isChecked());
		return true; //renabor
     }
   }

   //by jmpessoa: context menu support -  Context menu items do not support icons!
   @Override    
   public void onCreateContextMenu(ContextMenu menu, View v, ContextMenuInfo menuInfo) {
      super.onCreateContextMenu(menu, v, menuInfo);
      //Log.i("App.Java_onCreateContextMenu", "long_pressed!");
      
      controls.jAppOnCreateContextMenu(menu);              
   }

   /*by jmpessoa: Handles menu item selections*/
   @Override    
   public boolean onContextItemSelected(MenuItem item) {
	   
   	  String caption = item.getTitle().toString();
   	  controls.jAppOnClickContextMenuItem(item, item.getItemId(), caption, item.isChecked());
      return true; // stop propagating event
   }

   //by jmpessoa: option menu support
   @Override
   public boolean onCreateOptionsMenu(Menu menu) {
	    
	    controls.jAppOnCreateOptionsMenu(menu);
        return true;
   }   
   
   /*by jmpessoa: TODO :Handles prepare menu item*/
   @Override
   public boolean onPrepareOptionsMenu(Menu menu) {
	           
	   boolean changeMenuItems = false;
	   boolean continueChangingItem = true;
	   	   
	   changeMenuItems =controls.jAppOnPrepareOptionsMenu(menu, menu.size());
	   	   
       if (changeMenuItems) {    	  
          for  (int  i = 0; i < menu.size(); i++) { 
             MenuItem item = menu.getItem(i); 
             continueChangingItem = controls.jAppOnPrepareOptionsItem(menu, item, i); 
             if (!continueChangingItem)  break;
          }         
       } 
       return super.onPrepareOptionsMenu(menu);
   }
   
   /*Handle opened menu */
  @Override     
   public boolean onMenuOpened(int featureId, Menu menu) {
	   //https://stackoverflow.com/questions/33820366/how-to-show-icon-with-menus-in-android
      if(featureId == Window.FEATURE_ACTION_BAR && menu != null){
          if(menu.getClass().getSimpleName().equals("MenuBuilder")){
              try{
                  Method m = menu.getClass().getDeclaredMethod(
                          "setOptionalIconsVisible", Boolean.TYPE);
                  m.setAccessible(true);
                  m.invoke(menu, true);
              }
              catch(NoSuchMethodException e){
                  //Log.e(TAG, "onMenuOpened", e);
              }
              catch(Exception e){
                  throw new RuntimeException(e);
              }
          }
      }
      return super.onMenuOpened(featureId, menu);
   }
   
   //https://abhik1987.wordpress.com/tag/android-disable-home-button/
   //http://code.tutsplus.com/tutorials/android-sdk-intercepting-physical-key-events--mobile-10379 //otimo!
   
   //Return true to prevent this event from being propagated further, 
   //or false to indicate that you have not handled this event and it should continue to be propagated.  
   
   @Override
   public boolean onKeyDown(int keyCode, KeyEvent event) {
	   
	  char c = event.getDisplayLabel();	        
	  boolean mute = false;
	  
      switch(keyCode) {
            
      case KeyEvent.KEYCODE_BACK:
    	 mute = controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));    	  
         if (!mute) { //continue ...
        	 onBackPressed();
             return true;
         } else {  // exit! 
        	 return false;  //caution!! the back_key will not close the App, no more!!
         }
         
      case KeyEvent.KEYCODE_MENU:     	     	      	          
    	 mute = controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
         break;
              
        case KeyEvent.KEYCODE_SEARCH:
          mute = controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
          break;
                    
        case KeyEvent.KEYCODE_VOLUME_UP:
          //event.startTracking();  //TODO
          mute = controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
          break;
          
        case KeyEvent.KEYCODE_VOLUME_DOWN:
          mute = controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
          break;
          
          /*commented! need SDK API >= 18 [Android 4.3] to compile!*/
          /*
        case KeyEvent.KEYCODE_BRIGHTNESS_DOWN:
            controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
            break;                   
        case KeyEvent.KEYCODE_BRIGHTNESS_UP:
            controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
            break;
         */
          
        case KeyEvent.KEYCODE_HEADSETHOOK:
            controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
            break;
            
        case KeyEvent.KEYCODE_DEL:
            controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
            break;
            
        case KeyEvent.KEYCODE_NUM:
            controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
            break;            
            
        case KeyEvent.KEYCODE_NUM_LOCK:
            controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
            break;            

        default:  mute = controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));         	
      }      

      if (mute) 
      {
        	 return true;
      } else {
        	 return super.onKeyDown(keyCode, event);        	 
      }       
   }        
}
