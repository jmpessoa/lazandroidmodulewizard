package org.lamw.appwifimanagerdemo2;

import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;
import android.net.Uri;
import android.net.wifi.ScanResult;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.provider.Settings;
//import android.util.Log;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
//import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/*Draft java code by "Lazarus Android Module Wizard" [7/26/2019 1:29:49]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

public class jWifiManager /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;
    private WifiManager wifiManager;

    private String[] wifisResults = null;
    private String delimiter = "|";

    private boolean locationServicesRequested;

    private boolean hotSpotEnable;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jWifiManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;

        locationServicesRequested = false;

        wifiManager = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        //wifiManager = (WifiManager)Context.getSystemService(Context.WIFI_SERVICE);
        
        // Better to start the app with the wifi deactivated to be able to use it for more purposes.
        /*if (wifiManager!= null) {
            if (!wifiManager.isWifiEnabled()) {
                //Toast.makeText(getApplicationContext(), "Turning WiFi ON...", Toast.LENGTH_LONG).show();
                wifiManager.setWifiEnabled(true);
            }
        }*/
    }

    public void jFree() {
        //free local objects...
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void SetWifiEnabled(boolean _value) {
        if (wifiManager!= null) {
            wifiManager.setWifiEnabled(_value);
        }
    }

    public String[] Scan() {
        if (wifiManager == null) return null;
        if (!IsLocationServicesNeed()) {
            List<ScanResult> scanResults = wifiManager.getScanResults();
            if (scanResults.size() > 0) {
                wifisResults = new String[scanResults.size()];
                // Get Each network detail
                for (int i = 0; i < scanResults.size(); i++) {
                    ScanResult scanResult = scanResults.get(i);
                    //wifis[i] = scanResults.get(i).toString();
                    wifisResults[i] = scanResult.SSID + delimiter + scanResult.capabilities;
                }
            }
        }
        else {
           if (IsLocationServicesON()) {
               List<ScanResult> scanResults = wifiManager.getScanResults();
               if (scanResults.size() > 0) {
                   wifisResults = new String[scanResults.size()];
                   // Get Each network detail
                   for (int i = 0; i < scanResults.size(); i++) {
                       ScanResult scanResult = scanResults.get(i);
                       //wifis[i] = scanResults.get(i).toString();
                       wifisResults[i] = scanResult.SSID + delimiter + scanResult.capabilities;
                   }
               }
           } else {
               //LocationServices
           }
        }
        return wifisResults;
    }

    public String GetSSID(int _scanResultIndex){
      String s = wifisResults[_scanResultIndex];
      return s.split(Pattern.quote(delimiter))[0];
    }

    public String GetCapabilities(int _scanResultIndex){
        String s = wifisResults[_scanResultIndex];
        return s.split(Pattern.quote(delimiter))[1];
    }

    /**
     * https://gist.github.com/JosiasSena/100de74192ca3024da8494c1ca428294?source=post_page---------------------------
     *
     * @NonNull
    public static IntentFilter getIntentFilterForWifiConnectionReceiver() {
    final IntentFilter randomIntentFilter = new IntentFilter(ACTION_WIFI_ON);
    randomIntentFilter.addAction(ACTION_WIFI_OFF);
    randomIntentFilter.addAction(ACTION_CONNECT_TO_WIFI);
    return randomIntentFilter;
    }

    public void onReceive(Context c, Intent intent) {
    Log.d(TAG, "onReceive() called with: intent = [" + intent + "]");

    wifiManager = (WifiManager) c.getSystemService(Context.WIFI_SERVICE);

    final String action = intent.getAction();

    if (!isTextNullOrEmpty(action)) {
    switch (action) {
    case ACTION_WIFI_ON:
    // Turns wifi on
    wifiManager.setWifiEnabled(true);
    break;
    case ACTION_WIFI_OFF:
    // Turns wifi off
    wifiManager.setWifiEnabled(false);
    break;
    case ACTION_CONNECT_TO_WIFI:
    // Connects to a specific wifi network
    final String networkSSID = intent.getStringExtra("ssid");
    final String networkPassword = intent.getStringExtra("password");

    if (!isTextNullOrEmpty(networkSSID) && !isTextNullOrEmpty(networkPassword)) {
    connectToWifi(networkSSID, networkPassword);
    } else {
    Log.e(TAG, "onReceive: cannot use " + ACTION_CONNECT_TO_WIFI +
    "without passing in a proper wifi SSID and password.");
    }
    break;
    }
    }
     * Notifies the receiver to turn wifi on
     */
    private static final String ACTION_WIFI_ON = "android.intent.action.WIFI_ON";

    /**
     * Notifies the receiver to turn wifi off
     */
    private static final String ACTION_WIFI_OFF = "android.intent.action.WIFI_OFF";

    /**
     * Notifies the receiver to connect to a specified wifi
     */
    private static final String ACTION_CONNECT_TO_WIFI = "android.intent.action.CONNECT_TO_WIFI";


    public boolean Connect(String _networkSSID, String _password) {
        if (!wifiManager.isWifiEnabled()) {
            wifiManager.setWifiEnabled(true);
        }
        try {
           WifiConfiguration conf = new WifiConfiguration();
           conf.SSID = String.format("\"%s\"", _networkSSID);
           conf.preSharedKey = String.format("\"%s\"", _password);
           int netId = wifiManager.addNetwork(conf);
           wifiManager.disconnect();
           wifiManager.enableNetwork(netId, true);
           wifiManager.reconnect();
           return true;
        } catch (Exception ex) {
            //System.out.println(Arrays.toString(ex.getStackTrace()));
            return false;
        }
    }

    //https://stackoverflow.com/questions/29574730/how-to-connect-to-wifi-programmatically
    public boolean ConnectWEP( String _networkSSID, String _password ) {
        if (!wifiManager.isWifiEnabled()) {
            wifiManager.setWifiEnabled(true);
        }
        try {
            WifiConfiguration conf = new WifiConfiguration();
            conf.SSID = "\"" + _networkSSID + "\"";   // Please note the quotes. String should contain SSID in quotes
            //conf.wepKeys[0] = "\"" + password + "\""; //Try it with quotes first
            conf.preSharedKey = "\"" + _password + "\"";
            conf.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE);
            conf.allowedGroupCiphers.set(WifiConfiguration.AuthAlgorithm.OPEN);
            //conf.allowedGroupCiphers.set(WifiConfiguration.AuthAlgorithm.SHARED);
           // WifiManager wifiManager = (WifiManager) this.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
            int networkId = wifiManager.addNetwork(conf);
            List<WifiConfiguration> list = wifiManager.getConfiguredNetworks();
            for( WifiConfiguration i : list ) {
                if(i.SSID != null && i.SSID.equals("\"" + _networkSSID + "\"")) {
                    wifiManager.disconnect();
                    wifiManager.enableNetwork(i.networkId, true);
                    wifiManager.reconnect();
                    break;
                }
            }
            //WiFi Connection success, return true
            return true;
        } catch (Exception ex) {
            //System.out.println(Arrays.toString(ex.getStackTrace()));
            return false;
        }
    }

    public boolean ConnectWPA( String _networkSSID, String _password ) {
        if (!wifiManager.isWifiEnabled()) {
            wifiManager.setWifiEnabled(true);
        }
        try {
            WifiConfiguration conf = new WifiConfiguration();
            conf.SSID = "\"" + _networkSSID + "\"";   // Please note the quotes. String should contain SSID in quotes
            conf.preSharedKey = "\"" + _password + "\"";
            conf.status = WifiConfiguration.Status.ENABLED;
            conf.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.TKIP);
            conf.allowedGroupCiphers.set(WifiConfiguration.GroupCipher.CCMP);
            conf.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.WPA_PSK);
            //conf.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.TKIP);
            conf.allowedPairwiseCiphers.set(WifiConfiguration.PairwiseCipher.CCMP);
            //Log.d("connecting", conf.SSID + " " + conf.preSharedKey);
            //WifiManager wifiManager = (WifiManager) this.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
            wifiManager.addNetwork(conf);
            //Log.d("after connecting", conf.SSID + " " + conf.preSharedKey);
            List<WifiConfiguration> list = wifiManager.getConfiguredNetworks();
            for( WifiConfiguration i : list ) {
                if(i.SSID != null && i.SSID.equals("\"" + _networkSSID + "\"")) {
                    wifiManager.disconnect();
                    wifiManager.enableNetwork(i.networkId, true);
                    wifiManager.reconnect();
                    //Log.d("re connecting", i.SSID + " " + conf.preSharedKey);
                    break;
                }
            }
            //WiFi Connection success, return true
            return true;
        } catch (Exception ex) {
            //System.out.println(Arrays.toString(ex.getStackTrace()));
            return false;
        }
    }

    //https://medium.com/@droidbyme/android-turn-on-gps-programmatically-d585cf29c1ef
    public void RequestLocationServices() {
        if (!IsLocationServicesNeed()) return;
        //String provider = Settings.Secure.getString(controls.activity.getContentResolver(),
                //Settings.Secure.LOCATION_PROVIDERS_ALLOWED);
        //if null ou length == 0  then GPS is disabled...
        //if ( (provider == null) || (provider.length() == 0) ) {
        if (! IsGPSEnabled()) {
            Intent myIntent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
            myIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            controls.activity.startActivity(myIntent);
        }

        locationServicesRequested = true;
    }

    //https://www.android-examples.com/enable-disable-gps-location-service-programmatically-android/
    private boolean IsGPSEnabled(){
        LocationManager locationManager = (LocationManager)context.getSystemService(Context.LOCATION_SERVICE);
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
    }

    public boolean IsLocationServicesON() {
        /*
        boolean r = false;
        String provider = Settings.Secure.getString(controls.activity.getContentResolver(),
                Settings.Secure.LOCATION_PROVIDERS_ALLOWED);
        if ( (provider != null) && (provider.length() != 0) ) r = true;
        return r;
        */
        return IsGPSEnabled();
    }

    public boolean IsLocationServicesNeed() {
        boolean r = false;
        //[ifdef_api23up]
        if (Build.VERSION.SDK_INT >= 23) {
           r = true;
        } //[endif_api23up]
        return r;
    }

    public boolean RequestLocationServicesDenied() {
        boolean r = false;
        if ( (locationServicesRequested) && (!IsLocationServicesON())  ) r = true;
        return r;
    }


//https://developer.android.com/reference/android/Manifest.permission#WRITE_SETTINGS
    public boolean NeedWriteSettingsPermission() { //by software_developer
        boolean r = false;
        if (Build.VERSION.SDK_INT >= 23) {
            //[ifdef_api23up]
            r  = Settings.System.canWrite(controls.activity.getApplicationContext());
            //[endif_api23up]
        }
        return r;
    }

    //https://developer.android.com/reference/android/Manifest.permission#WRITE_SETTINGS
    public void RequestWriteSettingsPermission() { //by software_developer

        if (!NeedWriteSettingsPermission()) return;

        Intent intent = new Intent(android.provider.Settings.ACTION_MANAGE_WRITE_SETTINGS);
        intent.setData(Uri.parse("package:" + this.context.getPackageName()));
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        this.context.startActivity(intent);

    }

    // Turn wifiAp hotspot on
    public void SetWifiHotspotOn() {
        if (wifiManager == null) return;
        WifiConfiguration wificonfiguration = null;
        try {
            Method method = wifiManager.getClass().getMethod("setWifiApEnabled", WifiConfiguration.class, boolean.class);
            method.invoke(wifiManager, wificonfiguration, true);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Turn wifiAp hotspot off
    public void SetWifiHotspotOff() { //by software_developer
        if (wifiManager == null) return;
        WifiConfiguration wificonfiguration = null;
        try {
            Method method = wifiManager.getClass().getMethod("setWifiApEnabled", WifiConfiguration.class, boolean.class);
            method.invoke(wifiManager, wificonfiguration, false);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean IsWifiHotspotEnable() {   //by software_developer

        if (wifiManager == null) return false;
        try {
            Method method = wifiManager.getClass().getDeclaredMethod("isWifiApEnabled");
            method.setAccessible(true);
            return (Boolean) method.invoke(wifiManager);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean CreateNewWifiNetwork() { //by software_developer
       String ssid = null;
       String password = null;
       boolean result = false;

       if (wifiManager == null) return false;

        wifiManager.setWifiEnabled(false); // turn off Wifi

       Method[] methods = wifiManager.getClass().getDeclaredMethods();

       for (Method m: methods) {
           if (m.getName().equals("getWifiApConfiguration")) {
               WifiConfiguration config = null;
               try {
                   config = (WifiConfiguration) m.invoke(wifiManager);
               } catch (IllegalAccessException e) {
                   e.printStackTrace();
               } catch (InvocationTargetException e) {
                   e.printStackTrace();
               }
               ssid = config.SSID;
               password = config.preSharedKey;
               //or other info about the current hotspot, accessible through config
           }
       }

       if (ssid == null) return false;
       if (password == null) return false;

       // creating new wifi configuration
       WifiConfiguration myConfig = new WifiConfiguration();
       myConfig.SSID = ssid; // SSID name of netwok
       myConfig.preSharedKey = password; // password for network
       myConfig.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE); // 4 is for KeyMgmt.WPA2_PSK which is not exposed by android KeyMgmt class
       myConfig.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.OPEN); // Set Auth Algorithms to open
       try {
           Method method = wifiManager.getClass().getMethod("setWifiApEnabled", WifiConfiguration.class, boolean.class);
           result = (Boolean) method.invoke(wifiManager, myConfig, true);  // setting and turing on android wifiap with new configrations
       } catch (Exception e) {
           e.printStackTrace();
       }
       return result;
   }

    public boolean CreateNewWifiNetwork(String _ssid, String _password) {

        boolean result = false;
        // creating new wifi configuration

        if (wifiManager == null) return false;

        wifiManager.setWifiEnabled(false); // turn off Wifi

        WifiConfiguration myConfig = new WifiConfiguration();
        myConfig.SSID = _ssid; // SSID name of netwok
        myConfig.preSharedKey = _password; // password for network
        myConfig.allowedKeyManagement.set(WifiConfiguration.KeyMgmt.NONE); // 4 is for KeyMgmt.WPA2_PSK which is not exposed by android KeyMgmt class
        myConfig.allowedAuthAlgorithms.set(WifiConfiguration.AuthAlgorithm.OPEN); // Set Auth Algorithms to open
        try {
            Method method = wifiManager.getClass().getMethod("setWifiApEnabled", WifiConfiguration.class, boolean.class);
            result = (Boolean) method.invoke(wifiManager, myConfig, true);  // setting and turing on android wifiap with new configrations
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;

    }

    public String GetCurrentHotspotSSID() throws InvocationTargetException, IllegalAccessException {
        String strSSID= "";

        if (wifiManager == null) return "";

        Method[] methods = wifiManager.getClass().getDeclaredMethods();
        for (Method m: methods) {
            if (m.getName().equals("getWifiApConfiguration")) {
                WifiConfiguration config = (WifiConfiguration) m.invoke(wifiManager);
                strSSID = config.SSID;
            }
        }
        return strSSID;
    }

    public String GetCurrentHotspotPassword() throws InvocationTargetException, IllegalAccessException {
        String strPassword= "";

        if (wifiManager == null) return "";

        Method[] methods = wifiManager.getClass().getDeclaredMethods();
        for (Method m: methods) {
            if (m.getName().equals("getWifiApConfiguration")) {
                WifiConfiguration config = (WifiConfiguration) m.invoke(wifiManager);
                strPassword=config.preSharedKey;
            }
        }
        return strPassword;
    }

}

