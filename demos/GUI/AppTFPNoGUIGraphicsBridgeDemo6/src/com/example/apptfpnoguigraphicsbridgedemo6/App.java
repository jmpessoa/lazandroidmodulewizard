package com.example.apptfpnoguigraphicsbridgedemo6;

//Lamw: Lazarus Android Module Wizard - Version 0.7 - 04 July - 2016
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



import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.pm.ActivityInfo; 
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

public class App extends Activity {
    
	private Controls       controls;
	   
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
      controls.appLayout   = new RelativeLayout(this);
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
               
      // Event : Java -> Pascal
      //Log.i("jApp","02.Controls.jAppOnCreate");
      controls.jAppOnCreate(this, controls.appLayout);
      
    }
       
    @Override    
    protected void onNewIntent(Intent intent) {super.onNewIntent(intent); controls.jAppOnNewIntent();}
    
    @Override
    protected void onDestroy() { super.onDestroy(); controls.jAppOnDestroy();}
    
    @Override
    protected void onPause() {super.onPause();  controls.jAppOnPause();}
    
    @Override
    protected void onRestart() {super.onRestart(); controls.jAppOnRestart();}
                                    	                                        
    @Override
    protected void onResume() { super.onResume(); controls.jAppOnResume();}  
    	                                        
    @Override
    protected void onStart() { super.onStart(); controls.jAppOnStart(); }
                                                  	                                        
    @Override
    protected void onStop() { super.onStop(); controls.jAppOnStop();} 
    	                                        
    @Override
    public    void onBackPressed() { controls.jAppOnBackPressed();}
    
    @Override
    public    void onConfigurationChanged(Configuration newConfig) {
    	super.onConfigurationChanged(newConfig);
    	controls.jAppOnRotate(newConfig.orientation);
    	//controls.jAppOnConfigurationChanged();
    }	   	
 
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
      controls.jAppOnActivityResult(requestCode,resultCode,data);                                     
    }

   /*by jmpessoa: Handles menu item selections */
/*	@Override
   public boolean onOptionsItemSelected(MenuItem item) {
      String caption = item.getTitle().toString();
      controls.jAppOnClickOptionMenuItem(item, item.getItemId(), caption, item.isChecked());
      return false;
   }
*/
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
		controls.jAppOnClickOptionMenuItem(item, item.getItemId(), caption,
				item.isChecked());
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
       //super.onPrepareOptionsMenu(menu);        
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
   
   /*by jmpessoa: TODO :Handles opened menu */
   @Override     
   public boolean onMenuOpened(int featureId, Menu menu) {
	   //TODO!!!!
     return super.onMenuOpened(featureId, menu);
   }
   
   //https://abhik1987.wordpress.com/tag/android-disable-home-button/
   //http://code.tutsplus.com/tutorials/android-sdk-intercepting-physical-key-events--mobile-10379 //otimo!
   
   //Return true to prevent this event from being propagated further, 
   //or false to indicate that you have not handled this event and it should continue to be propagated.  
   
   @Override
   public boolean onKeyDown(int keyCode, KeyEvent event) {	   
	  char c = event.getDisplayLabel();	        
	  //boolean mute = controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));  //TODO
      //if (mute) return false;	  
      switch(keyCode) {
            
      case KeyEvent.KEYCODE_BACK:
    	 boolean mute = controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));    	  
         if (!mute) { //continue ...
        	 onBackPressed();
             return true;
         } else {  // exit! 
        	 return false;  //caution!! the back_key will not close the App, no more!!
         }
         
      case KeyEvent.KEYCODE_MENU:     	     	      	          
    	 controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
         break;
              
        case KeyEvent.KEYCODE_SEARCH:
          controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
          break;
                    
        case KeyEvent.KEYCODE_VOLUME_UP:
          //event.startTracking();  //TODO
          controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
          break;
          
        case KeyEvent.KEYCODE_VOLUME_DOWN:
          controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));
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
            
        //default:  controls.jAppOnKeyDown(c,keyCode,KeyEvent.keyCodeToString(keyCode));         	
      }      
      return super.onKeyDown(keyCode, event);      
   }        
}
