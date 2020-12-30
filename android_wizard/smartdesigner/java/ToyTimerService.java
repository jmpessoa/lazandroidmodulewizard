package org.lamw.appjcentertoytimerservicedemo1;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.service.notification.StatusBarNotification;
import android.util.Log;
import androidx.core.app.NotificationCompat;

/* Timer service tracks the start and end time of timer;
 *service can be placed into the foreground to prevent it being killed when the activity goes away
 *
 * ref.
 * https://gist.github.com/mjohnsullivan/403149218ecb480e7759
 */
public class ToyTimerService extends Service {
 
        private static final String TAG = ToyTimerService.class.getSimpleName();
 
        // Start and end times in milliseconds
        private long startTime, endTime;
 
        // Is the service tracking time?
        private boolean isTimerRunning;
 
        // Foreground notification id
        private static final int NOTIFICATION_ID = 1;

    // Service binder
        private final IBinder serviceBinder = new RunServiceBinder();

        private  boolean isForegroundNotificationVisible = false;

        final private Handler h = new Handler();
        private Runnable r;

        public ToyTimerService() {

        }

        public class RunServiceBinder extends Binder {
            ToyTimerService getService() {
                return ToyTimerService.this;
            }
        }
 
        @Override
        public void onCreate() {
            if (Log.isLoggable(TAG, Log.VERBOSE)) {
                Log.v(TAG, "Creating pull timer service");
            }
            startTime = 0;
            endTime = 0;
            isTimerRunning = false;
        }
 
        @Override
        public int onStartCommand(Intent intent, int flags, int startId) {
            if (Log.isLoggable(TAG, Log.VERBOSE)) {
                Log.v(TAG, "Starting [onStartCommand] pull tiner service");
            }

            //do some heavy job here if you need...

            return Service.START_STICKY;
        }
 
        @Override
        public IBinder onBind(Intent intent) {  // client/server model ..
            if (Log.isLoggable(TAG, Log.VERBOSE)) {
                Log.v(TAG, "Binding [onBind]  toy timer service");
            }
            return serviceBinder;  //handle by "onServiceConnected"  in "jcToyTimerService.java"
        }
 
        @Override
        public void onDestroy() {
            super.onDestroy();
            if (Log.isLoggable(TAG, Log.VERBOSE)) {
                Log.v(TAG, "Destroying toy timer service");
            }
        }

         /**
         * Starts the timer
         */
        public void startTimer() {
            if (!isTimerRunning) {
                startTime = System.currentTimeMillis();
                isTimerRunning = true;
            }
            else {
                Log.e(TAG, "startTimer request for an already running pull timer");
            }
        }
 
        /**
         * Stops the timer
         */
        public void stopTimer() {
            if (isTimerRunning) {
                endTime = System.currentTimeMillis();
                isTimerRunning = false;
            }
            else {
                Log.e(TAG, "stopTimer request for a toy timer that isn't running");
            }
        }
 
        /**
         * @return whether the timer is running
         */
        public boolean isTimerRunning() {
            return isTimerRunning;
        }


        /**
         * Returns the  elapsed time [this is the main service job!]
         *
         * @return the elapsed time in seconds
         */
        public long getElapsedTime() {  //pull here!
            // If the timer is running, the end time will be zero
            return endTime > startTime ?
                    (endTime - startTime) / 1000 :
                    (System.currentTimeMillis() - startTime) / 1000;
        }


    public PendingIntent getPendingAction(Context context, String action) {

        // Prepare intent which is triggered if the
        // notification is selected

        Intent i = new Intent(context, App.class);  //resume app
        i.putExtra("NOTIFICATION_ID", NOTIFICATION_ID);
        i.setAction(action);

        //PendingIntent stopPendingIntent = PendingIntent.getService(context, 0, i, PendingIntent.FLAG_ONE_SHOT);
        PendingIntent pIntent = PendingIntent.getBroadcast(this, NOTIFICATION_ID, i, PendingIntent.FLAG_CANCEL_CURRENT);

        return pIntent;
    }
        /**
         * Place the service into the foreground
         * creates a notification for the service to interact with the "outside" world
         */

        public Notification getNotification(long elapsedTimeMilliSec) {

            String contentTitle = "Toy Timer Service";
            String contentText = "Elapsed Time";

            Notification notification;

            Intent resultIntent = new Intent(this, App.class);
            PendingIntent resultPendingIntent = PendingIntent.getActivity(this,
                    0, resultIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT);

            if (Build.VERSION.SDK_INT >= 26) {
                //[ifdef_api26up]
                notification = new NotificationCompat.Builder(this, "ToyPullTimerService_Channel")
                        .setContentTitle(contentTitle)
                        .setContentText(contentText +": " + String.valueOf(elapsedTimeMilliSec))
                        .setSmallIcon(R.drawable.ic_launcher)
                        .setOnlyAlertOnce(true) // so when data is updated don't make sound and alert in android 8.0+
                        .setOngoing(true)
                        //.addAction(R.drawable.ic_lemur32, "STOP SERVICE", getPendingAction(this,"STOP_SERVICE")) //TODO
                        .setContentIntent(resultPendingIntent)
                        .build();
                //[endif_api26up]
            }
            else {
                notification = new Notification.Builder(this)
                        .setContentTitle(contentTitle)
                        .setContentText(contentText + ": " + elapsedTimeMilliSec) //String.valueOf(
                        .setSmallIcon(R.drawable.ic_launcher)
                        .setOngoing(true)
                        //.addAction(R.drawable.ic_lemur32, "STOP SERVICE", getPendingAction(this,"STOP_SERVICE")) //TODO
                        .setContentIntent(resultPendingIntent)
                        .build();   //need minSdk Api 16
            }
             return notification;
        }


        public void runForeground() {
                ////https://gist.github.com/sunmeat/c7e824f9c1e83c85e987c70e1ef8bb35
                r = new Runnable() {    //loop
                    @Override
                    public void run() {
                        updateNotification(); //force push notification
                        h.postDelayed(this, 5*1000);  //// do the service push update magic!!!
                    }
                };
                h.post(r);
        }

        private boolean isNotificationVisible() { // minSdk Api  >= 23
            boolean r = false;
            NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            StatusBarNotification[] notifications;
            if (Build.VERSION.SDK_INT >= 23) {
                //[ifdef_api23up]
                notifications = mNotificationManager.getActiveNotifications();
                for (StatusBarNotification notific : notifications) {
                    if (notific.getId() == NOTIFICATION_ID) {
                        r = true;
                        break;
                    }
                }
                //[endif_api23up]
            }
            return r;
        }

    /**
     * This is the method that can be called to update the Notification
     * https://stackoverflow.com/questions/5528288/how-do-i-update-the-notification-text-for-a-foreground-service-in-android
     */
       private void updateNotification() {

           Notification notification = getNotification(getElapsedTime());
           NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

           if (foregroundNotificationVisible()){
               mNotificationManager.notify(NOTIFICATION_ID, notification);  // notify:: update notification
           } else {
               isForegroundNotificationVisible = true;
               startForeground(NOTIFICATION_ID, notification);  //startForeground:: create new notification
           }
        }

        /**
         * Return the service to the background
         * The status bar notification displayed can be removed by passing true
         */
        public void runBackground() {
            isForegroundNotificationVisible = false;
            stopForeground(true);
        }

    public void StopSelf() {
        isForegroundNotificationVisible = false;

        if (h != null) {
            if (r != null) {
                h.removeCallbacks(r);
            }
        }

        stopForeground(true);
        stopSelf();
    }

    public boolean foregroundNotificationVisible() {
        if (Build.VERSION.SDK_INT >= 23) {
            //[ifdef_api23up]
            isForegroundNotificationVisible = isNotificationVisible(); //confirm ...
            //[endif_api23up]
        }
        return isForegroundNotificationVisible;
    }
}
 
