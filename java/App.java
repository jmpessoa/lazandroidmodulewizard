package com.template.appdummy; //warning for TEMPLATE: by jmpessoa: please do not edit ou change the place of this line!!! 


//Android Java Interface for Pascal/Delphi XE5 (and Lazarus by jmpessoa)

//Developers
//          Simon,Choi / Choi,Won-sik
//                       simonsayz@naver.com
//                       http://blog.naver.com/simonsayz
//
//          LoadMan    / Jang,Yang-Ho
//                       wkddidgh@naver.com
//                       http://blog.naver.com/wkddidgh


import java.lang.Override;
import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.pm.ActivityInfo; 
import android.widget.RelativeLayout;
import android.view.WindowManager;
//import android.view.View;
import android.os.Bundle;
import android.os.StrictMode;
import android.util.Log;

// http://stackoverflow.com/questions/16282294/show-title-bar-from-code
public class App extends Activity {
    private Controls       controls;

    @Override
    public void onCreate(Bundle savedInstanceState) {
     super.onCreate(savedInstanceState);                            
     
      //by jmpessoa --- fix http get    
      //ref. http://stackoverflow.com/questions/8706464/defaulthttpclient-to-androidhttpclient 
     if (android.os.Build.VERSION.SDK_INT > 9) {
         StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
         StrictMode.setThreadPolicy(policy);
     }
     
  
      Log.i("jApp","01.Activity.onCreate");
      controls             = new Controls();
      controls.activity    = this; 
      controls.appLayout   = new RelativeLayout(this);
      controls.appLayout.getRootView().setBackgroundColor (0x00FFFFFF);
      controls.screenStyle = controls.jAppOnScreenStyle();
      switch( controls.screenStyle ) {
      	case 1  : this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT );  break;
      	case 2  : this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);  break;
      	default : ; // Device Default , Rotation by Device
      } 	
      this.setContentView(controls.appLayout);
      this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
      // Event : Java -> Pascal
      controls.jAppOnCreate(this, controls.appLayout);
      Log.i("jApp","02.Controls.jAppOnCreate");
      
    }
    
    @Override
    protected void onNewIntent(Intent intent) { super.onNewIntent(intent);
    	                                          controls.jAppOnNewIntent();     }
    
    @Override
    protected void onDestroy()                { super.onDestroy(); 
    	                                          controls.jAppOnDestroy();       }
    
    @Override
    protected void onPause()                  { super.onPause(); 
    	                                          controls.jAppOnPause();         }    
    
    @Override
    protected void onRestart()                { super.onRestart(); 
    	                                          controls.jAppOnRestart();       }

    @Override
    protected void onResume()                 { super.onResume();  
    	                                          controls.jAppOnResume();        }

    @Override
    protected void onStart()                  { super.onStart();   
    	                                          controls.jAppOnActive();        }

    @Override
    protected void onStop()                   { super.onStop(); 
    	                                          controls.jAppOnStop();          }

    @Override
    public    void onBackPressed()            { controls.jAppOnBackPressed();   }
    
    @Override
    public    void onConfigurationChanged(Configuration newConfig)
    {
    	super.onConfigurationChanged(newConfig);
    	controls.jAppOnRotate(newConfig.orientation);
    	controls.jAppOnConfigurationChanged();
    }	   	
 
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
      controls.jAppOnActivityResult(requestCode,resultCode,data);                                       
    }

}
