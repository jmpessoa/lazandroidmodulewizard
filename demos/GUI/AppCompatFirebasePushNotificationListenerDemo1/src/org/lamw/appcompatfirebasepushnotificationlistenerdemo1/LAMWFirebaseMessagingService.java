package org.lamw.appcompatfirebasepushnotificationlistenerdemo1;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.BitmapFactory;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;
import java.util.Map;

//https://trinitytuts.com/firebase-push-notification-android/
public class LAMWFirebaseMessagingService extends FirebaseMessagingService {

    private static final String TAG = "LAMW_FIREBASE";
    private NotificationManager notifManager;

    @Override
    public void onNewToken(String s) {
        super.onNewToken(s);
        Log.d("NEW_TOKEN", s);
    }

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        sendNotification(remoteMessage, this);
    }

    private Intent GetIntent(RemoteMessage remoteMessage) {

        Intent intent = new Intent(this, App.class);  //bind to LAMW "App" MainActivity class
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

        if (remoteMessage.getData().size() > 0) {
            //Log.e(TAG, "Message data payload: " + remoteMessage.getData());
            Map<String, String> map = remoteMessage.getData();
            for (String key : map.keySet()) {
                String value = map.get(key);
                intent.putExtra(key, value);
            }
        }
        return intent;
    }

    //String messageTitle, String messageBody, Context context
    private void sendNotification(RemoteMessage remoteMessage, Context context) {

        String title = "";
        String description = "";
        //String info ="";

        Intent intent = GetIntent(remoteMessage);

        if (remoteMessage.getData().size() > 0) {
            //Log.e(TAG, "Message data payload: " + remoteMessage.getData());
            Map<String, String> data = remoteMessage.getData();

            title = data.get("title");
            description = data.get("body");

            /*
            Map<String, String> map= remoteMessage.getData();
            for (String key : map.keySet()) {
                String value = map.get(key);
                info = key + ":" + value + "\n";
            }
            */
        }

        if (remoteMessage.getNotification() != null) {
            title = remoteMessage.getNotification().getTitle();
            description = remoteMessage.getNotification().getBody();
        }

        NotificationCompat.Builder builder;
        final int NOTIFY_ID = 0; // ID of notification
        String id = "lamwfmcchannel"; // default_channel_id

        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_ONE_SHOT | PendingIntent.FLAG_IMMUTABLE);
        //Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

        if (notifManager == null) {
            notifManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        }

        if (Build.VERSION.SDK_INT >= 26) {   //Build.VERSION_CODES.O
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel mChannel = notifManager.getNotificationChannel(id);
            if (mChannel == null) {
                mChannel = new NotificationChannel(id, title, importance);
                // mChannel.enableVibration(true);
                // mChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
                notifManager.createNotificationChannel(mChannel);
            }

            builder = new NotificationCompat.Builder(context, id)
                    .setContentTitle(title)
                    .setContentText(description)
                    .setContentIntent(pendingIntent)
                    //.setContentInfo(info)
                    //.setSound(defaultSoundUri)
                    //.setLargeIcon(BitmapFactory.decodeResource(getResources(), R.drawable.ic_launcher))
                    .setSmallIcon(R.drawable.ic_launcher)
                    .setOnlyAlertOnce(true) // so when data is updated don't make sound and alert in android 8.0+
                    .setOngoing(true)
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT);
        } else {
            builder = new NotificationCompat.Builder(context, id);
            intent = new Intent(context, App.class);
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            builder.setContentTitle(title)
                    .setContentText(description)
                    //.setContentInfo(info)
                    //.setSmallIcon(android.R.drawable.ic_popup_reminder)   // required
                    .setSmallIcon(R.drawable.ic_launcher)
                    .setDefaults(Notification.DEFAULT_ALL)
                    .setAutoCancel(true)
                    .setContentIntent(pendingIntent)
                    .setTicker("Accept your request")
                    //.setVibrate(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400})
                    .setOngoing(true)
                    .setPriority(Notification.PRIORITY_HIGH);
        }
        Notification notification = builder.build();
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);
        if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            Toast toast = Toast.makeText(this, "Sorry... android.Manifest.permission.POST_NOTIFICATIONS NOT GRANTED !!", Toast.LENGTH_SHORT);
            if (toast != null) {
                toast.show();
            }
            return;
        }
        notificationManager.notify(NOTIFY_ID, notification);
    }
}
