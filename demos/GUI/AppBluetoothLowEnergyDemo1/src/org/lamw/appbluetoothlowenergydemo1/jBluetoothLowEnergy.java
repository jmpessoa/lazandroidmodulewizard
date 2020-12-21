package org.lamw.appbluetoothlowenergydemo1;


/*Draft java code by "Lazarus Android Module Wizard" [3/31/2019 17:16:44]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

import android.bluetooth.BluetoothGattDescriptor;
import android.content.Context;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanFilter;
import android.bluetooth.le.ScanResult;
import android.bluetooth.le.ScanSettings;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.ParcelUuid;
import android.util.Log;
import android.view.LayoutInflater;
import android.widget.Toast;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static android.content.Context.BLUETOOTH_SERVICE;
import java.util.UUID;

//https://www.bignerdranch.com/blog/bluetooth-low-energy-on-android-part-1/                MAIN REF
//https://www.bignerdranch.com/blog/bluetooth-low-energy-on-android-part-2/     MAIN REF

/*
class Constants {
 //   public static String SERVICE_STRING = "7D2EA28A-F7BD-485A-BD9D-92AD6ECFE93E";
   // public static UUID SERVICE_UUID = UUID.fromString(SERVICE_STRING);

    public static String CHARACTERISTIC_ECHO_STRING = "7D2EBAAD-F7BD-485A-BD9D-92AD6ECFE93E";
    public static UUID CHARACTERISTIC_ECHO_UUID = UUID.fromString(CHARACTERISTIC_ECHO_STRING);

    public static String CHARACTERISTIC_TIME_STRING = "7D2EDEAD-F7BD-485A-BD9D-92AD6ECFE93E";
    public static UUID CHARACTERISTIC_TIME_UUID = UUID.fromString(CHARACTERISTIC_TIME_STRING);
    public static String CLIENT_CONFIGURATION_DESCRIPTOR_STRING = "00002902-0000-1000-8000-00805f9b34fb";
    public static UUID CLIENT_CONFIGURATION_DESCRIPTOR_UUID = UUID.fromString(CLIENT_CONFIGURATION_DESCRIPTOR_STRING);
    public static final String CLIENT_CONFIGURATION_DESCRIPTOR_SHORT_ID = "2902";
//    public static final long SCAN_PERIOD = 5000;
}
*/

//https://www.truiton.com/2015/04/android-bluetooth-low-energy-ble-example/

public class jBluetoothLowEnergy /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context context   = null;

    private static final String TAG = "ClientActivity";

    private static final int REQUEST_ENABLE_BT = 1;
    private static final int REQUEST_FINE_LOCATION = 2;

    //private ActivityClientBinding mBinding;

    private boolean mScanning;
    private Handler mHandler;
    private Handler mLogHandler;
    private Map<String, BluetoothDevice> mScanResults;

    private boolean mConnected;
    private BluetoothAdapter mBluetoothAdapter;
    private BluetoothLeScanner mBluetoothLeScanner;
    private ScanCallback mScanCallback;
    private BluetoothGatt mGatt;
    private boolean mDiscoverResult;

//    private String SERVICE_STRING = "7D2EA28A-F7BD-485A-BD9D-92AD6ECFE93E";

    //private static UUID SERVICE_UUID = UUID.fromString(SERVICE_STRING);

    private long SCAN_PERIOD = 5000;

    List<BluetoothGattService> mServicesDiscovered;

    public int mScanMode = ScanSettings.SCAN_MODE_LOW_POWER;


    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jBluetoothLowEnergy(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;

        mLogHandler = new Handler(Looper.getMainLooper());
        BluetoothManager bluetoothManager = (BluetoothManager) controls.activity.getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetoothAdapter = bluetoothManager.getAdapter();
        /*
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_client);
        @SuppressLint("HardwareIds")
        String deviceInfo = "Device Info"
                + "\nName: " + mBluetoothAdapter.getName()
                + "\nAddress: " + mBluetoothAdapter.getAddress();
        mBinding.clientDeviceInfoTextView.setText(deviceInfo);
        mBinding.startScanningButton.setOnClickListener(v -> startScan());
        mBinding.stopScanningButton.setOnClickListener(v -> stopScan());
        mBinding.disconnectButton.setOnClickListener(v -> disconnectGattServer());
        mBinding.viewClientLog.clearLogButton.setOnClickListener(v -> clearLogs());
        */

    }

    public void jFree() {
        //free local objects...
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

// Scanning
    public void StartScan(String _filterServiceUUID) {
        if (mScanning) {
            return;
        }

        disconnectGattServer();
        //mBinding.serverListContainer.removeAllViews();
        if (mScanResults == null)
            mScanResults = new HashMap<>();
        else mScanResults.clear();

        if (mScanCallback == null)
           mScanCallback = new BtleScanCallback();

        if (mBluetoothLeScanner == null)
           mBluetoothLeScanner = mBluetoothAdapter.getBluetoothLeScanner();

        // Note: Filtering does not work the same (or at all) on most devices. It also is unable to
        // search for a mask or anything less than a full UUID.
        // Unless the full UUID of the server is known, manual filtering may be necessary.
        // For example, when looking for a brand of device that contains a char sequence in the UUID

        ScanFilter scanFilter = new ScanFilter.Builder()
                .setServiceUuid(new ParcelUuid(UUID.fromString(_filterServiceUUID)))  //Constants.SERVICE_UUID
                .build();

        final List<ScanFilter> filters = new ArrayList<>();
        filters.add(scanFilter);

        //SCAN_MODE_LOW_LATENCY is recommended if the app will only be scanning for a brief period of time,
        // typically to find a very specific type of device.
        final ScanSettings settings = new ScanSettings.Builder()
                .setScanMode(mScanMode)   //ScanSettings.SCAN_MODE_LOW_POWER
                .build();

        AsyncTask.execute(new Runnable() {
            @Override
            public void run() {
                mBluetoothLeScanner.startScan(filters, settings, mScanCallback);
            }
        });


        mHandler = new Handler();
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                StopScan();
            }
        }, SCAN_PERIOD);

        mScanning = true;
        log("Started scanning.");
    }


    public void StartScan() {
        if (mScanning) {
            return;
        }

        disconnectGattServer();
        //mBinding.serverListContainer.removeAllViews();
        mScanResults = new HashMap<>();
        mScanCallback = new BtleScanCallback();
        mBluetoothLeScanner = mBluetoothAdapter.getBluetoothLeScanner();

        //https://punchthrough.com/android-ble-guide/
        //SCAN_MODE_LOW_LATENCY is recommended if the app will only be scanning for a brief period of time,
        // typically to find a very specific type of device.

        final ScanSettings settings = new ScanSettings.Builder()
                .setScanMode(ScanSettings.SCAN_MODE_LOW_POWER)
                .build();

        AsyncTask.execute(new Runnable() {
            @Override
            public void run() {
                mBluetoothLeScanner.startScan(null, settings, mScanCallback);
            }
        });

        mHandler = new Handler();
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                StopScan();
            }
        }, SCAN_PERIOD);

        mScanning = true;
        log("Started scanning.");
    }

    public void StopScan() {

        /*
        AsyncTask.execute(new Runnable() {
            @Override
            public void run() {
                btScanner.stopScan(leScanCallback);
            }
        });
         */

        if (mScanning && mBluetoothAdapter != null && mBluetoothAdapter.isEnabled() && mBluetoothLeScanner != null) {
            mBluetoothLeScanner.stopScan(mScanCallback);
            scanComplete();
        }

        mScanCallback = null;
        mScanning = false;
        mHandler = null;
        log("Stopped scanning.");
        //Pascal event ??
    }

    private void scanComplete() {
        if (mScanResults.isEmpty()) {
            return;
        }

        List<String> adressList = new ArrayList<String>();
        List<String> nameList = new ArrayList<String>();

        for (String deviceAddress : mScanResults.keySet()) {
            BluetoothDevice device = mScanResults.get(deviceAddress);
            /*
            GattServerViewModel viewModel = new GattServerViewModel(device);
            ViewGattServerBinding binding = DataBindingUtil.inflate(LayoutInflater.from(this),
                    R.layout.view_gatt_server,
                    mBinding.serverListContainer,
                    true);
            binding.setViewModel(viewModel);
            binding.connectGattServerButton.setOnClickListener(v -> connectDevice(device));
            */
            nameList.add(device.getName());
            adressList.add(deviceAddress);
        }

        if (!adressList.isEmpty()) {

            int count = adressList.size();
            String[] addressArray = new String[count];
            String[] namesArray = new String[count];

            for (int i = 0; i < count; i++) {
                addressArray[i] = adressList.get(i);
                namesArray[i] = nameList.get(i);
            }
            controls.pOnBluetoothLEScanCompleted(pascalObj, namesArray, addressArray);
        }
    }

    // Logging
    private void clearLogs() {
        //mLogHandler.post(() -> mBinding.viewClientLog.logTextView.setText(""));
    }

    // Gat Client Actions
    public void log(String msg) {
        Log.d(TAG, msg);
        /*
        mLogHandler.post(() -> {
            mBinding.viewClientLog.logTextView.append(msg + "\n");
            mBinding.viewClientLog.logScrollView.post(() -> mBinding.viewClientLog.logScrollView.fullScroll(View.FOCUS_DOWN));
        });
        */
    }

    public void logError(String msg) {
        log("Error: " + msg);
    }

    public void setConnected(boolean connected) {
        mConnected = connected;
    }

    public void disconnectGattServer() {
        log("Closing Gatt connection");
        clearLogs();
        mConnected = false;
        if (mGatt != null) {
            mGatt.disconnect();
            mGatt.close();
        }
    }

    // Gatt connection
    private void connectDevice(BluetoothDevice device) {
        log("Connecting to " + device.getAddress());
        GattClientCallback gattClientCallback = new GattClientCallback();
        mGatt = device.connectGatt(controls.activity, false, gattClientCallback);
    }

    // Gatt connection
    public void ConnectDevice(String _deviceAddress) {

        if (mScanResults.isEmpty()) return;

        if (mBluetoothAdapter == null) return;
        if (!mBluetoothAdapter.isEnabled()) return;
        BluetoothDevice device= mBluetoothAdapter.getRemoteDevice(_deviceAddress);

        if (device == null) return;
        log("Connecting to " + device.getAddress());
        GattClientCallback gattClientCallback = new GattClientCallback();
        mGatt = device.connectGatt(controls.activity, false, gattClientCallback);
    }


    public void ConnectByDeviceAddress(String _deviceAddress) {
        /*
        if (mBluetoothAdapter == null) return;
        if (!mBluetoothAdapter.isEnabled()) return;
        BluetoothDevice device= mBluetoothAdapter.getRemoteDevice(_deviceAddress);
         */
        if (mScanResults.isEmpty()) {
            return;
        }

        BluetoothDevice device = mScanResults.get(_deviceAddress);
        if (device != null) {
            log("Connecting to " + _deviceAddress);
            GattClientCallback gattClientCallback = new GattClientCallback();
            mGatt = device.connectGatt(controls.activity, false, gattClientCallback);
        }
    }


    // Callbacks
    private class BtleScanCallback extends ScanCallback {

        BtleScanCallback() {

        }

        @Override
        public void onScanResult(int callbackType, ScanResult result) {
            addScanResult(result);
        }

        @Override
        public void onBatchScanResults(List<ScanResult> results) {
            for (ScanResult result : results) {
                addScanResult(result);
            }
        }

        @Override
        public void onScanFailed(int errorCode) {
            logError("BLE Scan Failed with code " + errorCode);
        }

        private void addScanResult(ScanResult result) {
            //stopScan();
            BluetoothDevice device = result.getDevice();
            String deviceAddress = device.getAddress();

            if (mScanResults != null)
               mScanResults.put(deviceAddress, device);
            //connectDevice(device);
        }
    }

    public static boolean isCharacteristicWriteable(BluetoothGattCharacteristic pChar) {
        return (pChar.getProperties() & (BluetoothGattCharacteristic.PROPERTY_WRITE | BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE)) != 0;
    }

    private boolean isCharacteristicNotifiable(BluetoothGattCharacteristic characteristic) {
        return (characteristic.getProperties() & BluetoothGattCharacteristic.PROPERTY_NOTIFY) != 0;
    }

    private boolean isCharacteristicIndictable(BluetoothGattCharacteristic characteristic) {
        return (characteristic.getProperties() & BluetoothGattCharacteristic.PROPERTY_INDICATE) != 0;
    }

    private boolean isCharacteristicReadable(BluetoothGattCharacteristic characteristic) {
        return ((characteristic.getProperties() & BluetoothGattCharacteristic.PROPERTY_READ) != 0);
    }

    private class GattClientCallback extends BluetoothGattCallback {
        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            super.onConnectionStateChange(gatt, status, newState);

            mGatt = gatt;

            log("onConnectionStateChange newState: " + newState);

            if (status == BluetoothGatt.GATT_FAILURE) {
                logError("Connection Gatt failure status " + status);
                disconnectGattServer();
                return;
            } else if (status != BluetoothGatt.GATT_SUCCESS) {
                // handle anything not SUCCESS as failure
                logError("Connection not GATT sucess status " + status);
                disconnectGattServer();
                return;
            }

            if (newState == BluetoothProfile.STATE_CONNECTED) {
                log("Connected to device " + gatt.getDevice().getAddress());
                setConnected(true);

                //int bondstate = gatt.getDevice().getBondState();
                //BluetoothDevice.BOND_BONDING  //waiting for bonding to complete
                //BluetoothDevice.BOND_NONE
                // BluetoothDevice.BOND_BONDED)

                controls.pOnBluetoothLEConnected(pascalObj,gatt.getDevice().getName(), gatt.getDevice().getAddress(), gatt.getDevice().getBondState());

            } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                log("Disconnected from device");
                disconnectGattServer();
            }
        }

        @Override
        public void onServicesDiscovered(BluetoothGatt gatt, int status) {
            int serviceIndex;
            mServicesDiscovered = gatt.getServices();
            mGatt = gatt;

            Log.i("onServicesDiscovered", mServicesDiscovered.toString());
           // Loops through available GATT Services.
            serviceIndex = -1;  //dummy
            for (BluetoothGattService service : mServicesDiscovered) {
                List<BluetoothGattCharacteristic> gattCharacteristics = service.getCharacteristics();
                List<String> serviceCharacteristicList = new ArrayList<String>();
                // Loops through available Characteristics.
                for (BluetoothGattCharacteristic gattCharacteristic : gattCharacteristics) {
                    serviceCharacteristicList.add(gattCharacteristic.getUuid().toString());
                }
                int count = serviceCharacteristicList.size();
                String[] characteristicUUIDArray = new String[count];
                for (int k = 0; k < count; k++) {
                    characteristicUUIDArray[k] = serviceCharacteristicList.get(k);
                }
                serviceIndex++;
                controls.pOnBluetoothLEServiceDiscovered(pascalObj,  serviceIndex, service.getUuid().toString(), characteristicUUIDArray);
            }
        }

        @Override
        public void onCharacteristicRead(BluetoothGatt gatt,
                                         BluetoothGattCharacteristic
                                                 characteristic, int status) {

            mGatt = gatt;
            String strValue = "";
            Log.i("onCharacteristicRead", characteristic.toString());

            //  https://developer.android.com/guide/topics/connectivity/bluetooth-le

             // This is special handling for the Heart Rate Measurement profile. Data
            // parsing is carried out as per profile specifications.
            /*
            if (UUID_HEART_RATE_MEASUREMENT.equals(characteristic.getUuid())) {
                int flag = characteristic.getProperties();
                int format = -1;
                if ((flag & 0x01) != 0) {
                    format = BluetoothGattCharacteristic.FORMAT_UINT16;
                    Log.d(TAG, "Heart rate format UINT16.");
                } else {
                    format = BluetoothGattCharacteristic.FORMAT_UINT8;
                    Log.d(TAG, "Heart rate format UINT8.");
                }
                final int heartRate = characteristic.getIntValue(format, 1);
                strValue = String.format("d", heartRate);

                //Log.d(TAG, String.format("Received heart rate: %d", heartRate));
                //intent.putExtra(EXTRA_DATA, String.valueOf(heartRate));

            } else {*/
               final byte[] data = characteristic.getValue();
               if (data != null && data.length > 0) {
                 final StringBuilder stringBuilder = new StringBuilder(data.length);

                 for (byte byteChar : data) stringBuilder.append(String.format("%02X ", byteChar));

                 //intent.putExtra(EXTRA_DATA, new String(data) + "\n" + stringBuilder.toString());
                 strValue = stringBuilder.toString();
               }
            //}

            controls.pOnBluetoothLECharacteristicRead(pascalObj, strValue, characteristic.toString());
            //characteristic.getStringValue(0);
            //characteristic.getValue()
            //pascal event here
            //gatt.disconnect();
        }

        @Override
        public void onCharacteristicChanged(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic) {
            super.onCharacteristicChanged(gatt, characteristic);

            mGatt = gatt;
            String strValue = "";

            Log.i("onCharacteristicChanged", characteristic.toString());
            //  https://developer.android.com/guide/topics/connectivity/bluetooth-le

            // This is special handling for the Heart Rate Measurement profile. Data
            // parsing is carried out as per profile specifications.
            /*
            if (UUID_HEART_RATE_MEASUREMENT.equals(characteristic.getUuid())) {
                int flag = characteristic.getProperties();
                int format = -1;
                if ((flag & 0x01) != 0) {
                    format = BluetoothGattCharacteristic.FORMAT_UINT16;
                    Log.d(TAG, "Heart rate format UINT16.");
                } else {
                    format = BluetoothGattCharacteristic.FORMAT_UINT8;
                    Log.d(TAG, "Heart rate format UINT8.");
                }
                final int heartRate = characteristic.getIntValue(format, 1);
                strValue = String.format("d", heartRate);

                //Log.d(TAG, String.format("Received heart rate: %d", heartRate));
                //intent.putExtra(EXTRA_DATA, String.valueOf(heartRate));

            } else {*/
            final byte[] data = characteristic.getValue();
            if (data != null && data.length > 0) {
                final StringBuilder stringBuilder = new StringBuilder(data.length);

                for (byte byteChar : data) stringBuilder.append(String.format("%02X ", byteChar));

                //intent.putExtra(EXTRA_DATA, new String(data) + "\n" + stringBuilder.toString());
                strValue = stringBuilder.toString();
            }
            //}

            controls.pOnBluetoothLECharacteristicChanged(pascalObj, strValue, characteristic.toString());
             //characteristic.getStringValue(0)
            //characteristic.getValue()
            //pascal event here
            //gatt.disconnect();

        }

        @Override
        public void onDescriptorRead(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
            super.onDescriptorRead(gatt, descriptor, status);

            mGatt = gatt;

            BluetoothGattCharacteristic car = descriptor.getCharacteristic();
            if ( gatt.setCharacteristicNotification(car, true) ) {
                BluetoothGattDescriptor clientConfig = car.getDescriptor(descriptor.getUuid());
                if (isCharacteristicNotifiable(car)) {
                    clientConfig.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
                }
                else if (isCharacteristicIndictable(car)) {
                    clientConfig.setValue(BluetoothGattDescriptor.ENABLE_INDICATION_VALUE);
                }
                mGatt.writeDescriptor(clientConfig);
            }

        }
    }

    /*
    // Ensures Bluetooth is available on the device and it is enabled. If not,
// displays a dialog requesting user permission to enable Bluetooth.
if (bluetoothAdapter == null || !bluetoothAdapter.isEnabled()) {
    Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
    startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
}
     */

    public boolean HasSystemFeature() {
        if (!controls.activity.getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
            return false;
        }
        else return true;
    }

    /*

    public void SetServiceUUIDString(String _strUUID) {
        SERVICE_STRING = _strUUID; //"7D2EA28A-F7BD-485A-BD9D-92AD6ECFE93E";
    }

    */

    public void SetScanPeriod(long _milliSeconds) {
        SCAN_PERIOD = _milliSeconds; //5000;
    }

    public void SetScanMode(int _mode) {
        switch (_mode) {
            case 0: {
                mScanMode = ScanSettings.SCAN_MODE_LOW_POWER;
                break;
            }
            case 1: {
                mScanMode = ScanSettings.SCAN_MODE_LOW_LATENCY;
                break;
            }
        }
    }


    //https://medium.com/@martijn.van.welie/making-android-ble-work-part-2-47a3cdaade07
    public void DiscoverServices() {
        if( mGatt == null) return;
        Handler h = new Handler();
        h.postDelayed(new Runnable() {
            public void run() {
                mGatt.discoverServices();
            }
        }, 1500);
        /*
        AsyncTask.execute(new Runnable() {
            @Override
            public void run() {
                mGatt.discoverServices();
            }
        });
         */

    }


    /*
    BluetoothGattCharacteristic.PROPERTY_READ = 2;
    BluetoothGattCharacteristic.PROPERTY_NOTIFY = 16;
    BluetoothGattCharacteristic.PROPERTY_INDICATE = 32;
     */

    //https://stackoverflow.com/questions/25865587/android-4-3-bluetooth-ble-dont-called-oncharacteristicread
    public int GetCharacteristicProperties(int _serviceIndex, int _characteristicIndex) {
        if (mServicesDiscovered == null) return 0;
        BluetoothGattCharacteristic car = mServicesDiscovered.get(_serviceIndex).getCharacteristics().get(_characteristicIndex);
        return  car.getProperties();
    }

    public void ReadCharacteristic(int _serviceIndex, int _characteristicIndex) {
        if (mGatt == null) return;
        if (mServicesDiscovered == null) return;

        BluetoothGattCharacteristic car = mServicesDiscovered.get(_serviceIndex).getCharacteristics().get(_characteristicIndex);

        //https://stackoverflow.com/questions/25865587/android-4-3-bluetooth-ble-dont-called-oncharacteristicread
        if (isCharacteristicReadable(car)) {
            mGatt.readCharacteristic(car);
        }
        else if (isCharacteristicNotifiable(car)){
            mGatt.readDescriptor(GetDescriptor(_serviceIndex, _characteristicIndex));
        }
        else if (isCharacteristicIndictable(car)){
            mGatt.readDescriptor(GetDescriptor(_serviceIndex, _characteristicIndex));
        }

    }

    public String[] GetCharacteristics(int _serviceIndex) {
        List<String> characteristicUUIDList = new ArrayList<String>();

        List<BluetoothGattCharacteristic> serviceCharacteristics = mServicesDiscovered.get(_serviceIndex).getCharacteristics();
        int count = serviceCharacteristics.size();
        for (int i = 0; i < count; i++) {
            BluetoothGattCharacteristic car = serviceCharacteristics.get(i);
            characteristicUUIDList.add(car.getUuid().toString());
        }

        int count2 = characteristicUUIDList.size();
        String[] characteristicUUIDArray = new String[count2];
        for (int k = 0; k < count2; k++) {
            characteristicUUIDArray[k] = characteristicUUIDList.get(k);
        }
        return characteristicUUIDArray;
    }

    public String[] GetDescriptors(int _serviceIndex, int _characteristicIndex){
        if (mServicesDiscovered == null) return null;
        List<BluetoothGattCharacteristic> serviceCharacteristics = mServicesDiscovered.get(_serviceIndex).getCharacteristics();
        BluetoothGattCharacteristic car = serviceCharacteristics.get(_characteristicIndex);
        List<BluetoothGattDescriptor> descriptorsList = car.getDescriptors();
        int count = descriptorsList.size();
        String[] descriptorsArray = new String[count];
        for (int k = 0; k < count; k++) {
            descriptorsArray[k] = descriptorsList.get(k).toString();
        }
        return descriptorsArray;
    }

    private BluetoothGattDescriptor GetDescriptor(int _serviceIndex, int _characteristicIndex){
        if (mServicesDiscovered == null) return null;
        List<BluetoothGattCharacteristic> serviceCharacteristics = mServicesDiscovered.get(_serviceIndex).getCharacteristics();
        BluetoothGattCharacteristic car = serviceCharacteristics.get(_characteristicIndex);
        return car.getDescriptor(car.getUuid());
    }

    // Ensures Bluetooth is available on the device and it is enabled. If not,
// displays a dialog requesting user permission to enable Bluetooth.
    public void RequestBluetoothEnable(int _requestCod) {
        //log("Requested user enables Bluetooth. Try starting the scan again.");
        if (mBluetoothAdapter == null || !mBluetoothAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            controls.activity.startActivityForResult(enableBtIntent, _requestCod);
        }
    }

    public UUID GetUUIDFromInteger(int i) {
        final long MSB = 0x0000000000001000L;
        final long LSB = 0x800000805f9b34fbL;
        long value = i & 0xFFFFFFFF;
        return new UUID(MSB | (value << 32), LSB);
    }



    /*
    if(device.address == HR_SENSOR_ADDRESS){
        myDevice = device;
   }
     */
}
