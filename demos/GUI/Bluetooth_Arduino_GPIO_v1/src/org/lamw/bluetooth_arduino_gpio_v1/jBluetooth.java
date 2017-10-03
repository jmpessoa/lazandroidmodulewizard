package org.lamw.bluetooth_arduino_gpio_v1;

import java.io.File;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Set;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.widget.Toast;

/*Draft java code by "Lazarus Android Module Wizard" [5/10/2014 14:32:21]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//ref. http://www.tutorialspoint.com/android/android_bluetooth.htm
//ref. http://examples.javacodegeeks.com/android/core/bluetooth/bluetoothadapter/android-bluetooth-example/
//ref. http://www.javacodegeeks.com/2013/09/bluetooth-data-transfer-with-android.html
//ref. http://www.bravenewgeek.com/bluetooth-blues/
       
public class jBluetooth /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;

    private BluetoothAdapter mBA = null;
    
    private Intent intent = null;
    
    ArrayList<String> mListFoundedDevices = new ArrayList<String>();
    ArrayList<BluetoothDevice> mListReachablePairedDevices  = new ArrayList<BluetoothDevice>();
    
    ArrayList<BluetoothDevice> mListFoundedDevices2  = new ArrayList<BluetoothDevice>();
    
    ArrayList<String> mListBondedDevices = new ArrayList<String>();
    
    //jBluetoothClientSocket mBluetoothClientSocket;    

    final BroadcastReceiver mBroadcastReceiver = new BroadcastReceiver() {
	    @Override
   /*.*/public void onReceive(Context context, Intent intent){
	    	
	        String action = intent.getAction();
	        
	        if (BluetoothDevice.ACTION_FOUND.equals(action)){	          
	           BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);	           			        
	           if (mBA.getBondedDevices().contains(device)) {
	        	   mListReachablePairedDevices.add(device);	               
	           }
			   mListFoundedDevices.add( device.getName() + "|" + device.getAddress() );
			   mListFoundedDevices2.add(device);
			  // Log.i("jBluetooth_onReceive",device.getName() + "|" + device.getAddress());	        	   
	           	           
	           controls.pOnBluetoothDeviceFound(pascalObj,device.getName(),device.getAddress());
	           
	        }else if (BluetoothAdapter.ACTION_DISCOVERY_STARTED.equals(action)) {
	             controls.pOnBluetoothDiscoveryStarted(pascalObj);
	        }else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
	             controls.pOnBluetoothDiscoveryFinished(pascalObj, mListFoundedDevices.size(), mListReachablePairedDevices.size());
	        }else if (BluetoothDevice.ACTION_BOND_STATE_CHANGED.equals(action)) {
	            // Device pairing/unpairing occurred
	            BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);	            
	            int state = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, 0);
	            /*switch (state) {
	                case BluetoothDevice.BOND_BONDED: //12
	                    // Device was paired
	                	
	                    Log.i("BluetoothReceiver", "Paired with " + device.getName());
	                    break;
	                case BluetoothDevice.BOND_NONE:  //10
	                    // Device was unpaired
	                	
	                    Log.i("BluetoothReceiver", "Unpaired with " + device.getName());
	                    break;
	                case BluetoothDevice.BOND_BONDING:  //11
	                    // Device is in the process of pairing
	                	
	                    Log.i("BluetoothReceiver", "Pairing with " + device.getName());
	                    break;
	            }*/
	            
	            controls.pOnBluetoothDeviceBondStateChanged(pascalObj, state, device.getName(), device.getAddress());
	        } 	        
	    }
    };    
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jBluetooth(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       
	   mBA = BluetoothAdapter.getDefaultAdapter(); // Emulator -->> null!!!
	   
       intent = new Intent();
	   intent.setAction(Intent.ACTION_SEND);
	   
       controls.activity.registerReceiver(mBroadcastReceiver, new IntentFilter(BluetoothDevice.ACTION_FOUND));        
       controls.activity.registerReceiver(mBroadcastReceiver, new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_STARTED));      
       controls.activity.registerReceiver(mBroadcastReceiver, new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED));
       controls.activity.registerReceiver(mBroadcastReceiver, new IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED));

    }

    public void jFree() {
       //free local objects...
    	controls.activity.unregisterReceiver(mBroadcastReceiver);
    	if (mBA != null) {    		
    		mBA.cancelDiscovery();
    		mBA.disable();
    	}	    	
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
    public void Enabled(){
    	
    	if (mBA != null) {   //real device... 
    	   Toast.makeText(controls.activity.getApplicationContext(),"Adapter: "+mBA.getName() ,Toast.LENGTH_LONG).show();    	
           if (!mBA.isEnabled()) {
             controls.activity.startActivityForResult(new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), 999);
             //Toast.makeText(controls.activity.getApplicationContext(),"Bluetooth turned On" ,Toast.LENGTH_LONG).show();
             controls.pOnBluetoothEnabled(pascalObj);
           }          
    	}else { //Emulator...
    	   Toast.makeText(controls.activity.getApplicationContext(),"Warning: Try Real Device!",Toast.LENGTH_LONG).show();
    	}    	    	
    }
        
    public void Discovery() {
    	if (mBA != null && mBA.isEnabled()) {	
           if (mBA.isDiscovering())	mBA.cancelDiscovery();
           mListFoundedDevices.clear();  //new devices....
           mListReachablePairedDevices.clear();	
           mBA.startDiscovery();    	   
    	}
    }
        
    public void CancelDiscovery() {  //must Cancel to Connect socket!!!
    	if (mBA != null && mBA.isEnabled()) {	
            mBA.cancelDiscovery();
    	}
    }  
            
    public String[] GetPairedDevices(){  //list all paired devices...
    	
    	mListBondedDevices.clear();
    	
        mListBondedDevices.add("null|null");
        
        if (mBA != null && mBA.isEnabled()){            
           Set<BluetoothDevice> Devices = mBA.getBondedDevices();           
           //Toast.makeText(controls.activity.getApplicationContext(),"Devices Count = "+Devices.size(), Toast.LENGTH_SHORT).show();           
           
           if(Devices.size() > 0) {        	  
              mListBondedDevices.clear();              
              for(BluetoothDevice device : Devices) {        	
         	     mListBondedDevices.add(device.getName()+"|"+ device.getAddress());
           	     //Log.i("Bluetooch_devices",device.getName());  //device.getAddress()            
              }              
           }  
        }
        //strDevices = new String[mPairedDevices.size()];
        //strDevices = listDevices.toArray(strDevices);
        String strDevices[] = mListBondedDevices.toArray(new String[mListBondedDevices.size()]);    	  
        return strDevices;        
    }
          
    public String[] GetFoundedDevices(){  //list
    	if (mListFoundedDevices.size() == 0) {
            mListFoundedDevices.add("null|null");
    	}
        String strDevices[] = mListFoundedDevices.toArray(new String[mListFoundedDevices.size()]);    	  
        return strDevices;        
    }
    
    public String[] GetReachablePairedDevices(){  //list
    	String[] strRes;
    	int size = mListReachablePairedDevices.size();
    	if (size > 0) {
    		strRes = new String[size];
    		for (int i=0; i < size; i++) {
    			strRes[i] = mListReachablePairedDevices.get(i).getName() +"|" + mListReachablePairedDevices.get(i).getAddress();	
    		}
    	} else {
    		strRes = new String[1];
    		strRes[0] = "null|null";
    	}    	            	 
        return strRes;        
    }

    public void Disable(){
       if (mBA != null) {
    	   mBA.disable(); 
           controls.pOnBluetoothDisabled(pascalObj);          
       }
       //Toast.makeText(controls.activity.getApplicationContext(),"Bluetooth turned Off" ,Toast.LENGTH_LONG).show();
    }
    
    public boolean IsEnable() {
    	if (mBA.isEnabled()) {
    		return true;
    	} else {
    	  return false;
    	}
    }
    
    //This method returns the current state of the Bluetooth Adapter.
    public int GetState() {
      if (mBA != null) {
        return mBA.getState();  //STATE_OFF, STATE_TURNING_ON, STATE_ON, STATE_TURNING_OFF.
      } else { 
    	  return -1;
      }
    }       
                            
    public BluetoothDevice GetReachablePairedDeviceByName(String _deviceName) {
    	
    	int index = -1;
    	
        for (int i=0; i < mListReachablePairedDevices.size(); i++) {
        	if (mListReachablePairedDevices.get(i).getName().equals(_deviceName)) {
        		index = i;
        		break;
        	}
        }
        if (index > -1) { 
    	   return mListReachablePairedDevices.get(index);
        }	
        else return null;
    }
    
    public BluetoothDevice GetReachablePairedDeviceByAddress(String _deviceAddress) {
    	
    	int index = -1;
    	
        for (int i=0; i < mListReachablePairedDevices.size(); i++) {
        	if (mListReachablePairedDevices.get(i).getAddress().equals(_deviceAddress)) {
        		index = i;
        		break;
        	}
        }
        if (index > -1) { 
        	return mListReachablePairedDevices.get(index);
        }	
        else return null;
    }
        
    public boolean IsReachablePairedDevice(String _deviceAddress) {    	
    	int index = -1;    	
        for (int i=0; i < mListReachablePairedDevices.size(); i++) {
        	if (mListReachablePairedDevices.get(i).getAddress().equals(_deviceAddress)) {
        		index = i;
        		break;
        	}
        }
        if (index > -1) { 
    	   return true;
        }	
        else return false;    	    
    }
 
    public BluetoothDevice GetRemoteDeviceByAddress(String _deviceAddress){
    	
       if (IsReachablePairedDevice(_deviceAddress))	
          return mBA.getRemoteDevice(_deviceAddress);
       else
    	  return null; 
       
    }
    
    public String GetDeviceNameByAddress(String _deviceAddress){
    	
    	String device;
    	String devAddr = "";
    	
    	for(int i=0; i < mListFoundedDevices.size(); i++) {
    	    device = mListFoundedDevices.get(i);    	   
    	    devAddr = device.substring(device.indexOf("|")+1);
    	   // Log.i("devAddr",devAddr);
    	    if (devAddr.equals(_deviceAddress)) {
    	    	break;
    	    }    	       	    	    
    	}    	
    	return devAddr;    	    	
    }
    
    public String GetDeviceAddressByName(String _deviceName){
    	String device;
    	String devName = "";
    	
    	for(int i=0; i < mListFoundedDevices.size(); i++) {
    	    device = mListFoundedDevices.get(i);    	   
    	    devName = device.substring(0, device.indexOf("|")-1);
    	   // Log.i("devName",devName);
    	    if (devName.equals(_deviceName)) {
    	    	break;
    	    }    	       	    	    
    	}    	
    	return devName;
    }
        
    //http://stackoverflow.com/questions/15697601/automate-file-transfer-to-a-paired-device-in-android-using-bluetooth
    public void SendFile(String _filePath, String _fileName, String _mimeType){
      
        File file = new File(_filePath, "/" + _fileName);
        Uri uri = Uri.fromFile(file);
        String mtype = _mimeType; //"image/*";

        Intent sharingIntent = new Intent(android.content.Intent.ACTION_SEND);
        sharingIntent.setType(mtype);
        sharingIntent.setClassName("com.android.bluetooth", "com.android.bluetooth.opp.BluetoothOppLauncherActivity");
        sharingIntent.putExtra(Intent.EXTRA_STREAM, uri);
        controls.activity.startActivity(sharingIntent);       
    }
    
    public void UnpairDeviceByAddress(String _deviceAddress) {
  	   BluetoothDevice device =  GetReachablePairedDeviceByAddress(_deviceAddress);
      	try {
      		
      	  if (device != null) {	
      	     Method m = device.getClass()
      	        .getMethod("removeBond", (Class[]) null);
      	     m.invoke(device, (Object[]) null);
      	  }
      	} catch (Exception e) {
      	    //Log.e(TAG, e.getMessage());
      	}
      }  
         
    public BluetoothDevice GetFoundedDeviceByAddress(String _deviceAddress) {
     	
     	int index = -1;     	
         for (int i=0; i < mListFoundedDevices2.size(); i++) {
         	if (mListFoundedDevices2.get(i).getAddress().equals(_deviceAddress)) {
         		index = i;
         		break;
         	}
         }
         if (index > -1) { 
         	return mListFoundedDevices2.get(index);
         }	
         else return null;
     }

     public void PairDeviceByAddress(String _deviceAddress) {
     	BluetoothDevice device = GetFoundedDeviceByAddress(_deviceAddress);
     	try {
     	    if (device != null) {    	    	
     	    Method m = device.getClass()
     	               .getMethod("createBond", (Class[]) null);    	    
     	               m.invoke(device, (Object[]) null);
     	    } 	    	   
     	} catch (Exception e) {
     	    //Log.e(TAG, e.getMessage());
     	}
     }
      
}

