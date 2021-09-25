package org.lamw.appussdservicedemo1;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;
import android.text.TextUtils;
//import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import java.util.Collections;
import java.util.List;

//import android.accessibilityservice.GestureDescription;
//import android.graphics.Path;
//import android.graphics.PixelFormat;
//import android.media.AudioManager;
//import android.view.Gravity;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.view.WindowManager;
//import android.widget.Button;
//import android.widget.FrameLayout;
//import java.util.ArrayDeque;
//import java.util.Deque;
 
/*Draft java code by "Lazarus Android Module Wizard" [7/14/2020 16:47:51]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
// ref. https://stackoverflow.com/questions/22057625/prevent-ussd-dialog-and-read-ussd-response
// ref. http://habrahabr.ru/post/234425/
 
public class jUSSDService extends AccessibilityService {
 
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;
    public static String TAG = jUSSDService.class.getSimpleName();
 
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    /*.*/public jUSSDService() {
        //super();
    }
 
    public jUSSDService(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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

    private String processUSSDText(List<CharSequence> eventText) {
        for (CharSequence s : eventText) {
            String text = String.valueOf(s);
            // Return text if text is the expected ussd response
            if( true ) {
                return text;
            }
        }
        return null;
    }

    public void logNodeHeirarchy(AccessibilityNodeInfo nodeInfo, int depth) {
                if (nodeInfo == null) return;
                String logString = "";
                for (int i = 0; i < depth; ++i) {
                     logString += " ";
                }
                logString += "Text: " + nodeInfo.getText() + " " + " Content-Description: " + nodeInfo.getContentDescription();
                // Log.v("Meu", logString)
                Intent intent = new Intent("org.lamw.action.USSDService");
                intent.putExtra("message",logString ); //text
                sendBroadcast(intent);

                for (int i = 0; i < nodeInfo.getChildCount(); ++i) {
                        logNodeHeirarchy(nodeInfo.getChild(i), depth + 1);
                }
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        //Log.d(TAG, "onAccessibilityEvent");
        AccessibilityNodeInfo source = event.getSource();
               
       if (source == null) {
        return;
       }

       if (source.getPackageName().equals("com.android.phone"))  {
           /* if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED && !event.getClassName().equals("android.app.AlertDialog")) { // android.app.AlertDialog is the standard but not for all phones  */
           if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED && !String.valueOf(event.getClassName()).contains("AlertDialog")) {
             return;
           }
           if(event.getEventType() == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED && (source == null || !source.getClassName().equals("android.widget.TextView"))) {
            return;
           }
           if(event.getEventType() == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED && TextUtils.isEmpty(source.getText())) {
             return;
           }
 
           List<CharSequence> eventText;
           if(event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
              eventText = event.getText();
            } else {
              eventText = Collections.singletonList(source.getText());
            }
 
            String text = processUSSDText(eventText);
 
           if (TextUtils.isEmpty(text) ) {
               return;
           }
 
            if(Build.VERSION.SDK_INT >= 16) { //need API >= 16!
              //[ifdef_api16up]
               performGlobalAction(GLOBAL_ACTION_BACK); //api >= 16  (android >= 4.1)
              //[endif_api16up]
           }
          //Log.d(TAG, text); //Handle USSD response here
           Intent intent = new Intent("org.lamw.action.USSDService");
           intent.putExtra("message", "USSD:"+text); //
           sendBroadcast(intent);
           //return;
        }

        if (event.getEventType()==AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED){
                Intent intent = new Intent("org.lamw.action.USSDService");
                intent.putExtra("message","Package:"+source.getPackageName() ); //text
                sendBroadcast(intent);
            AccessibilityNodeInfo currentNode= null;
            if (android.os.Build.VERSION.SDK_INT >= 16) {
                //[ifdef_api16up]
                currentNode = getRootInActiveWindow();
                //[endif_api16up]
            }
            if (currentNode!=null) {
                     logNodeHeirarchy(currentNode, 0);
            }
        }
    }
 
    @Override
    /*.*/public void onInterrupt() {
       //
    }
 
    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        AccessibilityServiceInfo info = new AccessibilityServiceInfo();
        info.flags = AccessibilityServiceInfo.DEFAULT;
        info.packageNames = null;
        info.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED | AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED;
        info.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
        setServiceInfo(info);
    }

    //Method to start the service
    public void Start() {
        //Explicit intents explicitly define the component which should be called by the Android system,
        //by using the Java class as identifier
        //Create an intent for a specific component.
       // Intent intent = new Intent(controls.activity, jUSSDService.class);
       // controls.activity.startService(intent);
        Intent intent  = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
        controls.activity.startActivity(intent);
    }

    public void Stop() {
        controls.activity.stopService(new Intent(controls.activity,jUSSDService.class));
    }
 
}
 
