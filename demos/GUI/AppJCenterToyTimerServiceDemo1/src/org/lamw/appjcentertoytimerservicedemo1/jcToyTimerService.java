package org.lamw.appjcentertoytimerservicedemo1;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.util.Log;

import java.lang.ref.WeakReference;

import androidx.core.app.NotificationCompat;

/*Draft java code by "Lazarus Android Module Wizard" [11/3/2020 1:04:07]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

public class jcToyTimerService implements ServiceConnection {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    public static final String CHANNEL_ID = "ToyTimerService_Channel";

    private static final String TAG = "ToyTimerService";

    private boolean serviceBound = false;
    //private boolean serviceStarted = false;

    private ToyTimerService toyTimerService;  // a service reference!!!

    // Handler to update the UI every X second when the timer is running
    private final Handler mUpdateTimeHandler = new UIUpdateHandler();;

    // Message type for the handler
    private final static int MSG_UPDATE_TIME = 0;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jcToyTimerService(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;

        if (Build.VERSION.SDK_INT >= 26) { //Build.VERSION_CODES.O
            createNotificationChannel();
        }
    }

    public void jFree() {
      //free local objects...
      //  Stop();
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= 26) { //Build.VERSION_CODES.O
            NotificationChannel serviceChannel = new NotificationChannel(
                    CHANNEL_ID,
                    "LAMW Toy Timer Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = controls.activity.getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }

    //implements the interface  ServiceConnection

    /**
     * Callback for service binding, passed to bindService()
     */
    @Override
    public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
        Log.i(TAG, "Toy timer Service bound");
        ToyTimerService.RunServiceBinder binder = (ToyTimerService.RunServiceBinder) iBinder;
        toyTimerService = binder.getService();
        serviceBound = true;

        // Ensure the service is not in the foreground when bound
        toyTimerService.runBackground();

        // Update the UI if the service is already running the timer
        if (toyTimerService.isTimerRunning()) {
            //Updates the UI when a run starts
            mUpdateTimeHandler.sendEmptyMessage(MSG_UPDATE_TIME);
        }

    }

    //implements the interface  ServiceConnection
    @Override
    public void onServiceDisconnected(ComponentName componentName) {
        Log.i(TAG, "Toy timer Service disconnect");
        serviceBound = false;
    }

    //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void Stop() {
        Log.i(TAG, "Stopping Toy timer service");

        //Remove pull message
        Message msg = mUpdateTimeHandler.obtainMessage();
        msg.what = MSG_UPDATE_TIME;
        mUpdateTimeHandler.removeMessages(MSG_UPDATE_TIME); //remove: don't pull update UI...

        if (serviceBound) {
            // If a timer is active, foreground the service, otherwise kill the service
            if (toyTimerService.isTimerRunning()) {
                Log.i(TAG, "Not Stoped Toy timer service. Just Put it in runForeground!");
                toyTimerService.runForeground();
            }
            else {
                // Unbind the service
                controls.activity.unbindService(this);
                serviceBound = false;
                //stop the service
                controls.activity.stopService(new Intent(controls.activity, ToyTimerService.class));
            }
        }
    }

    public void TimerOff() {
        Log.i(TAG, "[Off] Stopping the timer");
        if (serviceBound && toyTimerService.isTimerRunning()) {
            toyTimerService.stopTimer();

            //Remove pull message
            Message msg = mUpdateTimeHandler.obtainMessage();
            msg.what = MSG_UPDATE_TIME;
            mUpdateTimeHandler.removeMessages(MSG_UPDATE_TIME); //remove: don't pull update UI...

        }
    }

    public void TimerOn() {
        Log.i(TAG, " [On] Starting the timer");
        if (serviceBound && !toyTimerService.isTimerRunning()) {
            toyTimerService.startTimer();
            mUpdateTimeHandler.sendEmptyMessage(MSG_UPDATE_TIME);
        }
    }

    //Started Service : Used for long running task where intermediate updates are not required.
    //The started part of the service will play the task in the background
    public void Start() {
        Log.i(TAG, "Starting Toy Timer service");
        Intent intent = new Intent(controls.activity, ToyTimerService.class);

        if (Build.VERSION.SDK_INT >= 26) {
            //[ifdef_api26up]
            controls.activity.startForegroundService(intent);
            //[endif_api26up]
        }
        else {
            controls.activity.startService(intent);
        }
    }

   //Used for long running task where there is a client/server relationship between the invoker (in this case the app) and the service.
   //The bound part of the service will provide updates of the current position of the task being played.
    public void Bind() {
        Log.i(TAG, "Binding Toy timer service");
        Intent intent = new Intent(controls.activity, ToyTimerService.class);
        if (!serviceBound) {
            controls.activity.bindService(intent, this, 0); //Context.BIND_AUTO_CREATE ???
        }
    }

    //https://stackoverflow.com/questions/8341667/bind-unbind-service-example-android
    public void UnBind() {
        Log.i(TAG, "UnBinding Toy timer service");
        if (serviceBound) {
            controls.activity.unbindService(this);
            serviceBound =false;
        }
    }

    public boolean IsTimerRunning() {
        boolean r = false;
        if (serviceBound) {
            r = toyTimerService.isTimerRunning();
        }
        return r;
    }

    /**
     * Updates the timer readout in the UI [publish time info];
     * the service must be bounded
     */
    private void pullUpdateTimer() {
        if (serviceBound) {
            long elepsed = toyTimerService.getElapsedTime(); //get info from service..
            Log.i(TAG,  elepsed + " seconds");
            controls.pOnToyTimerServicePullElapsedTime(pascalObj, elepsed); //pascal side event "OnPullElapsedTime"
        }
    }

    /** Pull the service timer update every 5 seconds
     * When the timer is running, use this handler to update
     * the UI every 5 second to show timer progress
     */
    class UIUpdateHandler extends Handler {
        private final static int UPDATE_RATE_MS = 5 * 1000; //5 second

        @Override
        public void handleMessage(Message message) {
            if (MSG_UPDATE_TIME == message.what) {

                pullUpdateTimer();  // the pull service magic !!!

                /*
                sendEmptyMessageDelayed doesn't block. The message is put into a queue,
                then picked up by the Handler after the delay has expired.
                 */
                sendEmptyMessageDelayed(MSG_UPDATE_TIME, UPDATE_RATE_MS); //force loop
            }
        }
    }

    public void RunForeground() {  // now you can receive notification update  by pushing data
        if (serviceBound) {

            //Remove pull message
            Message msg = mUpdateTimeHandler.obtainMessage();
            msg.what = MSG_UPDATE_TIME;
            mUpdateTimeHandler.removeMessages(MSG_UPDATE_TIME); //remove: don't pull update UI...

            //put service in Foreground
            toyTimerService.runForeground();
        }
    }


    public void StopForeground() {
        if (serviceBound) {

            //put service in background
            // Update the UI if the service is already running the timer

            if (toyTimerService.isTimerRunning()) {
                //[pull] updates the UI when a run starts
                mUpdateTimeHandler.sendEmptyMessage(MSG_UPDATE_TIME);
            }
            toyTimerService.runBackground();
        }
    }

}
