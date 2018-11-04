package org.lamw.apptelephonymanagerdemo1;

/*Draft java code by "Lazarus Android Module Wizard" [10/21/2018 2:43:41]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Build;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.Log;

//http://danielthat.blogspot.com/2013/06/android-make-phone-call-with-speaker-on.html
//https://www.mkyong.com/android/how-to-make-a-phone-call-in-android/
public class jTelephonyManager /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context context   = null;

    TelephonyManager mTelephonyManager;

    StatePhoneReceiver myPhoneStateListener;
    AudioManager audioManager;

    boolean callFromApp=false; // To control the call has been made from the application
    boolean callFromOffHook=false; // To control the change to idle state is from the app call
    boolean isPhoneCalling=false;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jTelephonyManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;

        //To be notified of changes of the phone state create an instance
        //of the TelephonyManager class and the StatePhoneReceiver class
        myPhoneStateListener = new StatePhoneReceiver();
    }

    public void jFree() {
        //free local objects...
        audioManager = null;
        mTelephonyManager = null;
        myPhoneStateListener = null;
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    /*
    As far as android's telephony manager is concerned u cannot detect programmatically whether the call has been answered or not.
    This is to say that u do not have the option to know when the user picked the phone at other end.
     */
    // Monitor for changes to the state of the phone//
    class StatePhoneReceiver extends PhoneStateListener {

    public StatePhoneReceiver() {
       //
    }

    @Override
    public void onCallStateChanged(int state, String incomingNumber) {

        super.onCallStateChanged(state, incomingNumber);

        isPhoneCalling = false;

        switch (state) {

            case TelephonyManager.CALL_STATE_OFFHOOK: //Call is established  -The phone is off the hook
            if (callFromApp) {
                //Once you receive call, phone is busy
                //Log.i("PHONE RECEIVER", "Telephone is now busy");
              callFromApp=false;
              callFromOffHook=true;
              isPhoneCalling = true;
              controls.pOnTelephonyCallStateChanged(pascalObj, 2, incomingNumber);
            }break;

           case TelephonyManager.CALL_STATE_IDLE: //Call is finished
             if (callFromOffHook) {
                 callFromOffHook=false;
                 //Once the call ends, phone will become idle
                 //Log.i("PHONE RECEIVER", "Telephone is now idle");

                 if (isPhoneCalling) {
                    // Log.i(LOG_TAG, "restart app");
                     // restart app
                     Intent i = controls.activity.getBaseContext().getPackageManager().getLaunchIntentForPackage(
                             controls.activity.getBaseContext().getPackageName());
                     i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                     controls.activity.startActivity(i);
                     isPhoneCalling = false;
                     controls.pOnTelephonyCallStateChanged(pascalObj, 0, incomingNumber);
                 }
             }break;

           case TelephonyManager.CALL_STATE_RINGING:  //Call is RINGING --(when incoming call coming)
               if (callFromOffHook) {
                   //read the incoming call number
                   //String phoneNumber = bundle.getString(TelephonyManager.EXTRA_INCOMING_NUMBER);
                   //Log.i("PHONE RECEIVER", "Telephone is now ringing " + phoneNumber);
                   controls.pOnTelephonyCallStateChanged(pascalObj, 1, incomingNumber);
               }break;
        }
    }

    }

    public void Call(String _phoneNumber) {

        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }

        callFromApp=true;

        Intent i = new Intent(android.content.Intent.ACTION_CALL, Uri.parse("tel:" + _phoneNumber)); // Make the call
        try {
            controls.activity.startActivity(i);
        }
        catch (SecurityException securityException) {
            callFromApp=false;
            Log.d("jTelephonyMgr_Call", "Sorry... Not Permission granted!!");
        }
    }

    public void SetSpeakerphoneOn(boolean _value) {
        if (! _value) {
            audioManager = (AudioManager) controls.activity.getSystemService(Context.AUDIO_SERVICE);
            audioManager.setMode(AudioManager.MODE_NORMAL); //Deactivate loudspeaker
            audioManager.setSpeakerphoneOn(false);
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_NONE); // Remove listener
        }
        else {
            try {
                Thread.sleep(500); // Delay 0,5 seconds to handle better turning on loudspeaker
            } catch (InterruptedException e) { }
            //Activate loudspeaker
            audioManager = (AudioManager) controls.activity.getSystemService(Context.AUDIO_SERVICE);
            audioManager.setMode(AudioManager.MODE_IN_CALL);
            audioManager.setSpeakerphoneOn(true);
        }
    }

    public String GetIMEI() {
        String sImei = "";
        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }
        try {
            if (Build.VERSION.SDK_INT < 26) sImei = mTelephonyManager.getDeviceId();
            //[ifdef_api26up]
            if (Build.VERSION.SDK_INT >=  26) sImei =  mTelephonyManager.getImei();
            //[endif_api26up]
        } catch (SecurityException securityException) {
                Log.d("jTelephonyMgr_IMEI", "Sorry... Not Permission granted!!");
        }
        return sImei;
    }

    public String GetNetworkCountryIso() {
        String data = "";
        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }
        try {
            data = mTelephonyManager.getNetworkCountryIso();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_NetCIso", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetSimCountryIso() {
        String data = "";
        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }
        try {
            data = mTelephonyManager.getSimCountryIso();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_SimCIso", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetDeviceSoftwareVersion() {
        String data = "";
        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }
        try {
            data = mTelephonyManager.getDeviceSoftwareVersion();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_SoftVer", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetVoiceMailNumber() {
        String data = "";
        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }
        try {
            data = mTelephonyManager.getVoiceMailNumber();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_VoiceMail", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetPhoneType() {
        int phoneType = -1;
        String data = "";
        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }
        try {
            phoneType = mTelephonyManager.getPhoneType();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_PhoneType", "Sorry... Not Permission granted!!");
        }

        switch (phoneType) {
            case (TelephonyManager.PHONE_TYPE_CDMA):
                data="CDMA";
                break;
            case (TelephonyManager.PHONE_TYPE_GSM):
                data="GSM";
                break;
            case (TelephonyManager.PHONE_TYPE_NONE):
                data="NONE";
                break;
        }

        return data;
    }

    public boolean IsNetworkRoaming() {
        boolean isRoaming = false;
        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }
        try {
            isRoaming = mTelephonyManager.isNetworkRoaming();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_Roaming", "Sorry... Not Permission granted!!");
        }
        return isRoaming;
    }


    public String GetLine1Number() {
        String data = "";
        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }
        try {
            data = mTelephonyManager.getLine1Number();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_Line1", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetNetworkOperatorName() {
        String data = "";
        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }
        try {
            data = mTelephonyManager.getNetworkOperatorName();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_OperName", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public boolean IsWifiEnabled() {

        if (mTelephonyManager == null) {
            mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
            mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        }
        ConnectivityManager mgrConn = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
        return (mgrConn.getActiveNetworkInfo() != null &&
                mgrConn.getActiveNetworkInfo().getState() == NetworkInfo.State.CONNECTED) ||
                mTelephonyManager.getNetworkType() == 3;
    }

}
