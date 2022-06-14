package org.lamw.apptelephonymanagerdemo1;

/*Draft java code by "Lazarus Android Module Wizard" [10/21/2018 2:43:41]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

import android.Manifest;
import android.app.usage.NetworkStats;
import android.app.usage.NetworkStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.media.AudioManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.TrafficStats;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.telephony.CellIdentityCdma;
import android.telephony.CellIdentityGsm;
import android.telephony.CellIdentityLte;
import android.telephony.CellIdentityWcdma;
import android.telephony.CellInfo;
import android.telephony.CellInfoCdma;
import android.telephony.CellInfoGsm;
import android.telephony.CellInfoLte;
import android.telephony.CellInfoWcdma;
import android.telephony.CellSignalStrengthGsm;
import android.telephony.CellSignalStrengthLte;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.telephony.cdma.CdmaCellLocation;
import android.telephony.gsm.GsmCellLocation;
import android.util.Log;
import android.provider.Settings.Secure;

import org.json.JSONArray;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Objects;
import java.util.List;

import static android.net.NetworkCapabilities.TRANSPORT_CELLULAR;
import static android.net.NetworkCapabilities.TRANSPORT_WIFI;

//http://danielthat.blogspot.com/2013/06/android-make-phone-call-with-speaker-on.html
//https://www.mkyong.com/android/how-to-make-a-phone-call-in-android/
public class jTelephonyManager /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;

    TelephonyManager mTelephonyManager;
    NetworkStatsManager networkStatsManager;

    StatePhoneReceiver myPhoneStateListener;
    AudioManager audioManager;

    boolean callFromApp = false; // To control the call has been made from the application
    boolean callFromOffHook = false; // To control the change to idle state is from the app call
    boolean isPhoneCalling = false;
    boolean isListenerRemoved = false;

    Long mGuidToalMobileBytesStartTime = 0L;
    Long mGuidTotalMobileBytesEndTime = 0L;
    Long mGuidToalWifiBytesStartTime = 0L;
    Long mGuidTotalWifiBytesEndTime = 0L;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jTelephonyManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;

        //To be notified of changes of the phone state create an instance
        //of the TelephonyManager class and the StatePhoneReceiver class
        myPhoneStateListener = new StatePhoneReceiver();
        mTelephonyManager = ((TelephonyManager) controls.activity.getSystemService(Context.TELEPHONY_SERVICE));
        
        try{
         mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
        } catch (SecurityException securityException) {         
         Log.d("jTelephonyManager", "SecurityException: listen");
        }

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
    // This listener only works when the app is in foreground. To  Listen for call states when in background use BroadcastReceiver !!!]
    class StatePhoneReceiver extends PhoneStateListener {

        public StatePhoneReceiver() {
            //
        }

        /*https://www.codeproject.com/Articles/548416/Detecting-Incoming-and-Outgoing-Phone-Calls-on-And     --service!!!
          //Incoming call-  goes from IDLE to RINGING when it rings, to OFFHOOK when it's answered, to IDLE when its hung up
         //Outgoing call-  goes from IDLE to OFFHOOK when it dials out, to IDLE when hung up
         */
        @Override
        public void onCallStateChanged(int state, String incomingNumber) {
            isPhoneCalling = false;
            switch (state) {

                case TelephonyManager.CALL_STATE_OFFHOOK: //Call is established  -The phone is off the hook
                    //if (callFromApp) {
                    //Once you receive call, phone is busy/active
                    //Log.i("PHONE RECEIVER", "Telephone is now busy");
                    //callFromApp=false;
                    //callFromOffHook=true;
                    controls.pOnTelephonyCallStateChanged(pascalObj, 2, incomingNumber);
                    isPhoneCalling = true;   //<<-----
                    //}
                    break;

                case TelephonyManager.CALL_STATE_IDLE: //Call is finished
                    //if (callFromOffHook) {
                    //callFromOffHook=false;
                    //Once the call ends, phone will become idle
                    //Log.i("PHONE RECEIVER", "Telephone is now idle");
                    if (isPhoneCalling) {
                        // Log.i(LOG_TAG, "restart app");
                        // restart app
                        Intent i = controls.activity.getBaseContext().getPackageManager().getLaunchIntentForPackage(controls.activity.getBaseContext().getPackageName());
                        i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                        controls.activity.startActivity(i);
                        controls.pOnTelephonyCallStateChanged(pascalObj, 0, incomingNumber);
                        isPhoneCalling = false;
                    }
                    //}
                    break;

                case TelephonyManager.CALL_STATE_RINGING:  //Call is RINGING --(when incoming call coming)
                    // // phone ringing
                    //if (callFromOffHook) {
                    //read the incoming call number
                    //String phoneNumber = bundle.getString(TelephonyManager.EXTRA_INCOMING_NUMBER);
                    //Log.i("PHONE RECEIVER", "Telephone is now ringing " + phoneNumber);
                    controls.pOnTelephonyCallStateChanged(pascalObj, 1, incomingNumber);
                    //}
                    break;
            }
            super.onCallStateChanged(state, incomingNumber);
        }

    }

    public void Call(String _phoneNumber) {
        
        callFromApp = true;

        Intent i = new Intent(android.content.Intent.ACTION_CALL, Uri.parse("tel:" + _phoneNumber)); // Make the call
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes

            controls.activity.startActivity(i);
        } catch (SecurityException securityException) {
            callFromApp = false;
            Log.d("jTelephonyMgr_Call", "Sorry... Not Permission granted!!");
        }
    }

    public void SetSpeakerphoneOn(boolean _value) {
        if (!_value) {
            audioManager = (AudioManager) controls.activity.getSystemService(Context.AUDIO_SERVICE);
            audioManager.setMode(AudioManager.MODE_NORMAL); //Deactivate loudspeaker
            audioManager.setSpeakerphoneOn(false);
            try{
             mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_NONE); // Remove listener
            } catch (SecurityException securityException) {             
             Log.d("SetSpeakerphoneOn", "SecurityException: listen");
            }
            isListenerRemoved = true;
        } else {
            try {
                Thread.sleep(500); // Delay 0,5 seconds to handle better turning on loudspeaker
            } catch (InterruptedException e) {
            }
            //Activate loudspeaker
            audioManager = (AudioManager) controls.activity.getSystemService(Context.AUDIO_SERVICE);
            audioManager.setMode(AudioManager.MODE_IN_CALL);
            audioManager.setSpeakerphoneOn(true);
        }
    }

    public String GetIMEI() {
        String sImei = "";
        
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
            /*
            //[ifdef_api26up]
            if (Build.VERSION.SDK_INT >=  26) {
                sImei = mTelephonyManager.getImei();
            }else //[endif_api26up]   */
        	// Need system app - android.permission.READ_PRIVILIGED_PHONE_STATE
            //sImei = mTelephonyManager.getDeviceId();
        	sImei = Secure.getString(this.controls.activity.getContentResolver(), Secure.ANDROID_ID); 
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_IMEI", "Sorry... Not Permission granted!!");
        }
        return sImei;
    }

    public String GetNetworkCountryIso() {
        String data = "";
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes            
        	
            data = mTelephonyManager.getNetworkCountryIso();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_NetCIso", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetSimCountryIso() {
        String data = "";
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
            
            data = mTelephonyManager.getSimCountryIso();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_SimCIso", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetDeviceSoftwareVersion() {
        String data = "";
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
            
            data = mTelephonyManager.getDeviceSoftwareVersion();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_SoftVer", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetVoiceMailNumber() {
        String data = "";
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
            
            data = mTelephonyManager.getVoiceMailNumber();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_VoiceMail", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetPhoneType() {
        int phoneType = -1;
        String data = "";
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
            
            phoneType = mTelephonyManager.getPhoneType();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_PhoneType", "Sorry... Not Permission granted!!");
        }

        switch (phoneType) {
            case (TelephonyManager.PHONE_TYPE_CDMA):
                data = "CDMA";
                break;
            case (TelephonyManager.PHONE_TYPE_GSM):
                data = "GSM";
                break;
            case (TelephonyManager.PHONE_TYPE_NONE):
                data = "NONE";
                break;
        }

        return data;
    }

    //By Segator
    public String GetNetworkType() {
                
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes            
        	
            int networkType = mTelephonyManager.getNetworkType();
           
            if(networkType == TelephonyManager.NETWORK_TYPE_GPRS)   return "GPRS";
            if(networkType == TelephonyManager.NETWORK_TYPE_EDGE)   return "EDGE";
            if(networkType == TelephonyManager.NETWORK_TYPE_CDMA)   return "CDMA";
            if(networkType == TelephonyManager.NETWORK_TYPE_1xRTT)  return "1xRTT";
            if(networkType == TelephonyManager.NETWORK_TYPE_IDEN)   return "IDEN";
            // "2G"
            if(networkType == TelephonyManager.NETWORK_TYPE_UMTS)   return "UMTS";
            if(networkType == TelephonyManager.NETWORK_TYPE_EVDO_0) return "EVDO_0";
            if(networkType == TelephonyManager.NETWORK_TYPE_EVDO_A) return "EVDO_A";
            if(networkType == TelephonyManager.NETWORK_TYPE_HSDPA)  return "HSDPA";
            if(networkType == TelephonyManager.NETWORK_TYPE_HSUPA)  return "HSUPA";
            if(networkType == TelephonyManager.NETWORK_TYPE_HSPA)   return "HSPA";
            if(networkType == TelephonyManager.NETWORK_TYPE_EVDO_B) return "EVDO_B";
            if(networkType == TelephonyManager.NETWORK_TYPE_EHRPD)  return "EHRPD";            
            if(networkType == TelephonyManager.NETWORK_TYPE_HSPAP)  return "HSPAP";
            // "3G";
            if(networkType == TelephonyManager.NETWORK_TYPE_LTE)    return "LTE";
            // "4G"
            if(networkType == TelephonyManager.NETWORK_TYPE_NR)     return "NR";
            // "5G"
            return "";
           
        } catch (SecurityException securityException) {
            Log.d("jTelephonyManager", "Sorry... Not Permission granted!!");
            return "";
        }
                
    }

    public long GetTotalRxBytes() {
        return TrafficStats.getTotalRxBytes();
    }

    public long GetTotalTxBytes() {
        return TrafficStats.getTotalTxBytes();
    }

    public int GetUidFromPackage(String _package) {
        int puid = 0;

        try {
            puid = controls.activity.getPackageManager().getApplicationInfo(_package, 0).uid;
        } catch (PackageManager.NameNotFoundException ex) {
            return -2;
        }
        return puid;
    }

    //https://github.com/MuntashirAkon/AppManager/
    public long GetUidRxBytes(long _startTime, long _endTime, int _uid) {
        long totalRx = 0;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            NetworkStatsManager networkStatsManager = (NetworkStatsManager) context.getSystemService(Context.NETWORK_STATS_SERVICE);
            //UsageUtils.TimeInterval range = UsageUtils.getTimeInterval(intervalType);
            try {
                if (networkStatsManager != null) {
                    for (int networkId = 0; networkId < 2; ++networkId) {
                        NetworkStats networkStats = networkStatsManager.querySummary(networkId, null,
                                _startTime, _endTime);
                        if (networkStats != null) {
                            while (networkStats.hasNextBucket()) {
                                NetworkStats.Bucket bucket = new NetworkStats.Bucket();
                                networkStats.getNextBucket(bucket);
                                if (bucket.getUid() == _uid) {
                                    totalRx += bucket.getRxBytes();
                                }
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                return -1;
            }
            return totalRx;
        } else {

            return TrafficStats.getUidRxBytes(_uid);
        }
    }

    public long GetUidTxBytes(long _startTime, long _endTime, int _uid) {
        long totalTx = 0;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            NetworkStatsManager networkStatsManager = (NetworkStatsManager) context.getSystemService(Context.NETWORK_STATS_SERVICE);
            try {
                if (networkStatsManager != null) {
                    for (int networkId = 0; networkId < 2; ++networkId) {
                        NetworkStats networkStats = networkStatsManager.querySummary(networkId, null,
                                _startTime, _endTime);
                        if (networkStats != null) {
                            while (networkStats.hasNextBucket()) {
                                NetworkStats.Bucket bucket = new NetworkStats.Bucket();
                                networkStats.getNextBucket(bucket);
                                if (bucket.getUid() == _uid) {
                                    totalTx += bucket.getTxBytes();
                                }
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                return -1;
            }
            return totalTx;
        } else {

            return TrafficStats.getUidTxBytes(_uid);
        }
    }

    public long GetUidTotalBytes(long _startTime, long _endTime, int _uid) {
        long total = 0;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            NetworkStatsManager networkStatsManager = (NetworkStatsManager) context.getSystemService(Context.NETWORK_STATS_SERVICE);
            try {
                if (networkStatsManager != null) {
                    for (int networkId = 0; networkId < 2; ++networkId) {
                        NetworkStats networkStats = networkStatsManager.querySummary(networkId, null,
                                _startTime, _endTime);
                        if (networkStats != null) {
                            while (networkStats.hasNextBucket()) {
                                NetworkStats.Bucket bucket = new NetworkStats.Bucket();
                                networkStats.getNextBucket(bucket);
                                if (bucket.getUid() == _uid) {
                                    total += bucket.getTxBytes() + bucket.getRxBytes();
                                }
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                return -1;
            }
            return total;
        } else {

            return TrafficStats.getUidTxBytes(_uid) + TrafficStats.getUidRxBytes(_uid);
        }
    }

    public long GetUidTotalMobileBytes(long _startTime, long _endTime, int _uid) {
        long total = 0L;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            NetworkStats networkStats;
            List<String> subscriberIds;
            NetworkStatsManager networkStatsManager = (NetworkStatsManager) controls.activity.getSystemService(Context.NETWORK_STATS_SERVICE);
            try {
                if (Build.VERSION.SDK_INT < 26)
                    subscriberIds = getSubscriberIds(controls.activity, TRANSPORT_CELLULAR);
                else
                    subscriberIds = Collections.singletonList(null);
                for (String subscriberId : subscriberIds) {
                    networkStats = networkStatsManager.querySummary(TRANSPORT_CELLULAR, subscriberId, _startTime, _endTime);
                    while (networkStats.hasNextBucket()) {
                        NetworkStats.Bucket bucket = new NetworkStats.Bucket();
                        networkStats.getNextBucket(bucket);
                        if (bucket.getUid() == _uid) {
                            total += bucket.getTxBytes() + bucket.getRxBytes();
                        }
                    }
                }

            } catch (Exception ex) {
                return 0L;
            }
            return total;
        } else {

            return TrafficStats.getUidTxBytes(_uid) + TrafficStats.getUidRxBytes(_uid);
        }
    }

    public long GetUidTotalWifiBytes(long _startTime, long _endTime, int _uid) {
        long total = 0;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            NetworkStatsManager networkStatsManager = (NetworkStatsManager) context.getSystemService(Context.NETWORK_STATS_SERVICE);
            try {
                if (networkStatsManager != null) {
                    NetworkStats networkStats = networkStatsManager.querySummary(ConnectivityManager.TYPE_WIFI, null,
                            _startTime, _endTime);
                    if (networkStats != null) {
                        while (networkStats.hasNextBucket()) {
                            NetworkStats.Bucket bucket = new NetworkStats.Bucket();
                            networkStats.getNextBucket(bucket);
                            if (bucket.getUid() == _uid) {
                                total += bucket.getTxBytes() + bucket.getRxBytes();
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                return -1;
            }
            return total;
        } else {

            return TrafficStats.getUidTxBytes(_uid) + TrafficStats.getUidRxBytes(_uid);
        }
    }

    public long GetMobileRxBytes() {
        return TrafficStats.getMobileRxBytes();
    }

    public long GetMobileTxBytes() {
        return TrafficStats.getMobileTxBytes();
    }

    public void GetUidTotalMobileBytesAsync(long _startTime, long _endTime, int _uid) {
        mGuidToalMobileBytesStartTime = _startTime;
        mGuidTotalMobileBytesEndTime = _endTime;
        new AsyncGetUidTM().execute(_uid);
    }

    public void GetUidTotalWifiBytesAsync(long _startTime, long _endTime, int _uid) {
        mGuidToalWifiBytesStartTime = _startTime;
        mGuidTotalWifiBytesEndTime = _endTime;
        new AsyncGetUidTW().execute(_uid);
    }

    private class AsyncGetUidTM extends AsyncTask<Integer, Long, Long> {
        long _startTime = 0L;
        long _endTime = 0L;
        int _uid = 0;
        long bytesResult = 0L;

        @Override
        protected Long doInBackground(Integer... uid) {
            _startTime = mGuidToalMobileBytesStartTime;
            _endTime = mGuidTotalMobileBytesEndTime;
            _uid = uid[0];
            bytesResult = GetUidTotalMobileBytes(_startTime, _endTime, _uid);
            return bytesResult;
        }

        @Override
        protected void onPostExecute(Long bytesResult) {
            controls.pOnGetUidTotalMobileBytesFinished(pascalObj, bytesResult, _uid);
            super.onPostExecute(bytesResult);
        }
    }

    private class AsyncGetUidTW extends AsyncTask<Integer, Long, Long> {
        long _startTime = 0L;
        long _endTime = 0L;
        int _uid = 0;
        long bytesResult = 0L;

        @Override
        protected Long doInBackground(Integer... uid) {
            _startTime = mGuidToalWifiBytesStartTime;
            _endTime = mGuidTotalWifiBytesEndTime;
            _uid = uid[0];
            bytesResult = GetUidTotalWifiBytes(_startTime, _endTime, _uid);
            return bytesResult;
        }

        @Override
        protected void onPostExecute(Long bytesResult) {
            controls.pOnGetUidTotalWifiBytesFinished(pascalObj, bytesResult, _uid);
            super.onPostExecute(bytesResult);
        }
    }

    public boolean IsNetworkRoaming() {
        boolean isRoaming = false;
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
            
            isRoaming = mTelephonyManager.isNetworkRoaming();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_Roaming", "Sorry... Not Permission granted!!");
        }
        return isRoaming;
    }

    public String GetLine1Number() {
        String data = "";
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
            
            data = mTelephonyManager.getLine1Number();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_Line1", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetNetworkOperatorName() {
        String data = "";
        try {
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
            
            data = mTelephonyManager.getNetworkOperatorName();
        } catch (SecurityException securityException) {
            Log.d("jTelephonyMgr_OperName", "Sorry... Not Permission granted!!");
        }
        return data;
    }

    public String GetSubscriberId() {
    	// Requires API level 21
        if( android.os.Build.VERSION.SDK_INT < 21 ) return "";
        	
        String data = "";
        List<String> subscriberIds;
        subscriberIds = getSubscriberIds(controls.activity, TRANSPORT_CELLULAR);
        for (String subscriberId : subscriberIds) {
            if (subscriberId != "")
                data = subscriberId;
        }
        return data;
    }

    public boolean IsWifiEnabled() {
        
        try{
        	if (isListenerRemoved)
                mTelephonyManager.listen(myPhoneStateListener, PhoneStateListener.LISTEN_CALL_STATE); // start listening to the phone changes
            
        	int iType = mTelephonyManager.getNetworkType();
            if ((iType == TelephonyManager.NETWORK_TYPE_GSM) || // 2G
            	(iType == TelephonyManager.NETWORK_TYPE_TD_SCDMA) || // 3G
            	(iType == TelephonyManager.NETWORK_TYPE_IWLAN) || // 4G
            	(iType == TelephonyManager.NETWORK_TYPE_NR)) return true; // 5G
        }catch (SecurityException e) {
        	e.printStackTrace();
        }
        
        ConnectivityManager mgrConn = (ConnectivityManager) controls.activity.getSystemService(Context.CONNECTIVITY_SERVICE);
        
        if(mgrConn == null) return false;
        
        return (mgrConn.getActiveNetworkInfo() != null &&
                mgrConn.getActiveNetworkInfo().getState() == NetworkInfo.State.CONNECTED);
    }

    //https://github.com/MuntashirAkon/AppManager
    private static List<String> getSubscriberIds(Context context, int networkType) {

        List<String> subscriberIds = new ArrayList<>();

        if (networkType != TRANSPORT_CELLULAR) {
            return Collections.singletonList(null);
        }

        if (Build.VERSION.SDK_INT >= 22) {
            try {
                SubscriptionManager sm = (SubscriptionManager) context.getSystemService(Context
                        .TELEPHONY_SUBSCRIPTION_SERVICE);
                TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);

                List<SubscriptionInfo> subscriptionInfoList = sm.getActiveSubscriptionInfoList();

                for (SubscriptionInfo info : subscriptionInfoList) {
                    int subscriptionId = info.getSubscriptionId();
                    try {
                        @SuppressWarnings("JavaReflectionMemberAccess")
                        Method getSubscriberId = TelephonyManager.class.getMethod("getSubscriberId", int.class);
                        String subscriberId = (String) getSubscriberId.invoke(tm, subscriptionId);
                        subscriberIds.add(subscriberId);
                    } catch (Exception e) {
                        /*try {
                            if (Build.VERSION.SDK_INT >= 24) {
                                subscriberIds.add(tm.createForSubscriptionId(subscriptionId).getSubscriberId());
                            }
                        } catch (Exception e2) {
                            subscriberIds.add(tm.getSubscriberId());
                        }*/
                    }
                }

            } catch (SecurityException e) {
                return Collections.singletonList(null);
            }
        }
        return subscriberIds;
    }

    private int getLocationAreaCode_Old() {
            int lac = 0;
            try {
                String phoneType = GetPhoneType();
                if (phoneType.equals("GSM")) {
                    GsmCellLocation gsmCellLocation = (GsmCellLocation) mTelephonyManager.getCellLocation();
                    if (gsmCellLocation != null) {
                       lac = gsmCellLocation.getLac();
                    }
                }
                else if (phoneType.equals("CDMA")) {
                    CdmaCellLocation cdmaCellLocation = (CdmaCellLocation) mTelephonyManager.getCellLocation();
                    if (cdmaCellLocation != null) {
                        lac = cdmaCellLocation.getNetworkId();
                    }
                }
            } catch (SecurityException securityException) {
                Log.d("jTelephonyManager", "Sorry... Not Permission granted!!");
            }
            return lac;
    }

    private String getMobileNetworkCode_Old() {
        String mnc = "";
        try {
            mnc = (mTelephonyManager.getSimOperator() != null && mTelephonyManager
                    .getSimOperator().length() >= 5) ? mTelephonyManager
                    .getSimOperator().substring(3, 5) : "";
        } catch (SecurityException securityException) {
            Log.d("jTelephonyManager", "Sorry... Not Permission granted!!");
        }
        return mnc;
    }

    private String getMobileCountryCode_Old() {
        String mcc = "";
        try {
            mcc = (mTelephonyManager.getSimOperator() != null && mTelephonyManager
                    .getSimOperator().length() >= 3) ? mTelephonyManager
                    .getSimOperator().substring(0, 3) : "";
        } catch (SecurityException securityException) {
            Log.d("jTelephonyManager", "Sorry... Not Permission granted!!");
        }
        return mcc;
    }

    private int getBaseStationId_Old() {
        int baseId = 0;
            try {

                String phoneType = GetPhoneType();

                if (phoneType.equals("GSM")) {
                    GsmCellLocation gsmCellLocation = (GsmCellLocation) mTelephonyManager.getCellLocation();
                    if (gsmCellLocation != null) {
                        baseId = gsmCellLocation.getCid();
                    }
                }
                else if (phoneType.equals("CDMA")) {
                    CdmaCellLocation cdmaCellLocation = (CdmaCellLocation) mTelephonyManager.getCellLocation();
                    if (cdmaCellLocation != null) {
                        baseId = cdmaCellLocation.getBaseStationId();
                    }
                }

            } catch (SecurityException securityException) {
                Log.d("jTelephonyManager", "Sorry... Not Permission granted!!");
            }
            return baseId;
    }

    //https://www.programcreek.com/java-api-examples/?class=android.telephony.TelephonyManager&method=getAllCellInfo

    //need "android.permission.ACCESS_COARSE_LOCATION"  granted by the user!
    public int GetLocationAreaCode() {
        int lac = 0;
        if (Build.VERSION.SDK_INT >= 17) {
            try {
                List<CellInfo> infos = null;
                infos = mTelephonyManager.getAllCellInfo();
                for (final CellInfo info : infos)
                    try {
                        if (info instanceof CellInfoGsm) {
                            CellIdentityGsm identityGsm = ((CellInfoGsm) info).getCellIdentity();
                            lac = identityGsm.getLac();
                        } else if (info instanceof CellInfoCdma) {
                            final CellIdentityCdma identityCdma = ((CellInfoCdma) info).getCellIdentity();
                            lac = identityCdma.getNetworkId();
                        } else if (Build.VERSION.SDK_INT >= 18  && info instanceof CellInfoWcdma) {
                                final CellIdentityWcdma identityWcdma = ((CellInfoWcdma) info).getCellIdentity();
                                lac =identityWcdma.getLac();
                        } else if (info instanceof CellInfoLte) {
                            final CellIdentityLte identityLte = ((CellInfoLte) info).getCellIdentity();
                            lac = 0; //identityLte.getTac();  //???
                        }
                    } catch (Exception ex) {
                         //
                    }
            } catch (SecurityException securityException) {
                Log.d("jTelephonyManager", "Sorry... [ACCESS_COARSE_LOCATION] Not Permission granted!!");
            }
        }
        else {
            lac =  getLocationAreaCode_Old();
        }
        return lac;
    }

    //need "android.permission.ACCESS_COARSE_LOCATION"  granted by the user!
    public int GetBaseStationId() {
        int baseId = 0;
        if (Build.VERSION.SDK_INT >= 17) {
            try {
                List<CellInfo> infos = null;
                infos = mTelephonyManager.getAllCellInfo();
                for (final CellInfo info : infos)
                    try {
                        if (info instanceof CellInfoGsm) {
                            CellIdentityGsm identityGsm = ((CellInfoGsm) info).getCellIdentity();
                            baseId = identityGsm.getCid();
                        } else if (info instanceof CellInfoCdma) {
                            final CellIdentityCdma identityCdma = ((CellInfoCdma) info).getCellIdentity();
                            baseId = identityCdma.getBasestationId();
                        } else if (Build.VERSION.SDK_INT >= 18 && info instanceof CellInfoWcdma) {
                                final CellIdentityWcdma identityWcdma = ((CellInfoWcdma) info).getCellIdentity();
                                baseId =identityWcdma.getCid();
                        } else if(info instanceof CellInfoLte) {
                            final CellIdentityLte identityLte = ((CellInfoLte) info).getCellIdentity();
                            baseId = identityLte.getCi();
                        }
                    } catch (Exception ex) {
                        //
                    }
            } catch (SecurityException securityException) {
                Log.d("jTelephonyManager", "Sorry... [ACCESS_COARSE_LOCATION] Not Permission granted!!");
            }
        }
        else {
            baseId =  getBaseStationId_Old();
        }
        return baseId;
    }

    //need "android.permission.ACCESS_COARSE_LOCATION"  granted by the user!
    public int GetMobileNetworkCode() {
        int mnc = 0;
        if (Build.VERSION.SDK_INT >= 17) {
            try {
                List<CellInfo> infos = null;
                infos = mTelephonyManager.getAllCellInfo();
                for (final CellInfo info : infos)
                    try {
                        if (info instanceof CellInfoGsm) {
                            CellIdentityGsm identityGsm = ((CellInfoGsm) info).getCellIdentity();
                            mnc = identityGsm.getMnc();
                        } else if (info instanceof CellInfoCdma) {
                            final CellIdentityCdma identityCdma = ((CellInfoCdma) info).getCellIdentity();
                            mnc = identityCdma.getSystemId();
                        } else if (Build.VERSION.SDK_INT >= 18 && info instanceof CellInfoWcdma) {
                            final CellIdentityWcdma identityWcdma = ((CellInfoWcdma) info).getCellIdentity();
                            mnc =identityWcdma.getMnc();
                        } else if(info instanceof CellInfoLte) {
                            final CellIdentityLte identityLte = ((CellInfoLte) info).getCellIdentity();
                            mnc = identityLte.getMnc();
                        }
                    } catch (Exception ex) {
                        //
                    }
            } catch (SecurityException securityException) {
                Log.d("jTelephonyManager", "Sorry... [ACCESS_COARSE_LOCATION] Not Permission granted!!");
            }
        }
        else {
            mnc = Integer.parseInt(getMobileNetworkCode_Old());
        }
        return mnc;
    }

    //need "android.permission.ACCESS_COARSE_LOCATION"  granted by the user!
    public int GetMobileCountryCode() {
        int mcc = 0;
        if (Build.VERSION.SDK_INT >= 17) {
            try {
                List<CellInfo> infos = null;
                infos = mTelephonyManager.getAllCellInfo();
                for (final CellInfo info : infos)
                    try {
                        if (info instanceof CellInfoGsm) {
                            CellIdentityGsm identityGsm = ((CellInfoGsm) info).getCellIdentity();
                            mcc = identityGsm.getMcc();
                        } else if (info instanceof CellInfoCdma) {
                            //final CellIdentityCdma identityCdma = ((CellInfoCdma) info).getCellIdentity();
                            mcc = 0;
                        } else if (Build.VERSION.SDK_INT >= 18 && info instanceof CellInfoWcdma) {
                            final CellIdentityWcdma identityWcdma = ((CellInfoWcdma) info).getCellIdentity();
                            mcc =identityWcdma.getMcc();
                        } else if(info instanceof CellInfoLte) {
                            final CellIdentityLte identityLte = ((CellInfoLte) info).getCellIdentity();
                            mcc = identityLte.getMcc();
                        }
                    } catch (Exception ex) {
                        //
                    }
            } catch (SecurityException securityException) {
                Log.d("jTelephonyManager", "Sorry... [ACCESS_COARSE_LOCATION] Not Permission granted!!");
            }
        }
        else {
            mcc = Integer.parseInt(getMobileCountryCode_Old());
        }
        return mcc;
    }

}
