package org.lamw.applamwprojecttest1;

import android.content.Context;
import android.util.Log;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
//import com.google.firebase.FirebaseApp;
import com.google.firebase.messaging.FirebaseMessaging;

/*Draft java code by "Lazarus Android Module Wizard" [7/19/2021 1:15:39]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jsFirebasePushNotificationListener /*extends ...*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;
  
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jsFirebasePushNotificationListener(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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

public void GetFirebaseMessagingTokenAsync( ) {
        //FirebaseApp.initializeApp(controls.activity);
  FirebaseMessaging.getInstance().getToken().addOnCompleteListener(new OnCompleteListener<String>() {
      @Override
      public void onComplete(Task<String> task) {
          String statusMessage;
          if (task.isSuccessful()) {
              statusMessage = "Success!";
              Log.d("FirebaseMessagingToken", "Success!  token=" + task.getResult());
              controls.pOnGetTokenComplete(pascalObj, task.getResult(), task.isSuccessful(), statusMessage);
          }
          else {
              statusMessage = task.getException().toString();
              Log.w("FirebaseMessagingToken", "Fetching FCM registration token failed.", task.getException());
              controls.pOnGetTokenComplete(pascalObj, "", task.isSuccessful(), statusMessage);
          }

      }
  });
}

/*
public void GetFirebaseMessagingTokenAsyn( ) {
       FirebaseInstanceId.getInstance().getInstanceId().addOnCompleteListener(new OnCompleteListener<InstanceIdResult>() {
            @Override
            public void onComplete(@NonNull Task<InstanceIdResult> task) {
                if (!task.isSuccessful()) {
                    Log.w(TAG, "getInstanceId failed", task.getException());
                    return;
                }

                // Get new Instance ID token
                String token = task.getResult().getToken();

                // Log and toast
                String msg = token;
                Log.d(TAG, msg);
                sendNotificationId(msg);
            }
        });
}
*/
  
}
