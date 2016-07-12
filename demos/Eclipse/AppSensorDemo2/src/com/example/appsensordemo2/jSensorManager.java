package com.example.appsensordemo2;

import java.util.List;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

/*Draft java code by "Lazarus Android Module Wizard" [1/13/2015 22:20:02]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//refs.
//http://android-er.blogspot.com.br/2010/08/simple-compass-sensormanager-and.html
//http://www.coders-hub.com/2013/10/how-to-use-sensor-in-android.html#.VLWwqCvF_pA

public class jSensorManager /*extends ...*/ {
  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
        
    private static SensorManager mSensorManager;

    private SensorEventListener mSensorEventListener;

    private List<Sensor> mListSensors;
    
    private Sensor mCurrSensor;
    
    private int mSensorType;
        
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jSensorManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;

       mSensorType = 1;  //TYPE_ACCELEROMETER
        
       //get sensor service
       mSensorManager=(SensorManager)controls.activity.getSystemService(Context.SENSOR_SERVICE);
       
       mListSensors = mSensorManager.getSensorList(Sensor.TYPE_ALL);
            
       mSensorEventListener = new SensorEventListener(){
         @Override
         /*.*/public void onAccuracyChanged(Sensor sensor, int accuracy) {
           //---->>>pascal handle event
         }  
      
         //This method is called when your mobile moves any direction 
         @Override  //ref. http://developer.android.com/reference/android/hardware/SensorEvent.html
         /*.*/public void onSensorChanged(SensorEvent event) {
         	 
        	   //get x, y, z values
        	   // Always use the "length" of the values array while performing operations on it.        	           	                	  
          	  // int length = event.values.length;          	   
          	   //float x,y,z;
          	   float[] values;          	 
          	         	             	      
      	  switch ( event.sensor.getType() ) {     
      	  case 1: //Sensor.TYPE_ACCELEROMETER:   //1 - acceleration applied to the device  
        	     values = event.values;
        		/*All values are in SI units (m/s^2)
        		  x: Acceleration minus Gx on the x-axis
        		  y: Acceleration minus Gy on the y-axis
        		  z: Acceleration minus Gz on the z-axis
        	    */        		
        	    /* ref. http://code.tutsplus.com/tutorials/using-the-accelerometer-on-android--mobile-22125
        	    * the onSensorChanged method is invoked several times per second. 
        	    * We don't need all this data so we need to make sure we only sample 
        	    * a subset of the data we get from the device's accelerometer.
        	    */        	   
                controls.pOnChangedSensor(pascalObj, event.sensor, 1,values,event.timestamp); //nanosecond
            break;
        	
      	  case 2://Sensor.TYPE_MAGNETIC_FIELD: //2        	//SensorManager.SENSOR_DELAY_UI
     		    values = event.values;
        		//x - Geomagnetic field strength along the x axis. [nanoteslas]
        		//y - Geomagnetic field strength along the y axis. [nanoteslas]
        		//z - Geomagnetic field strength along the z axis. [nanoteslas]
        	    controls.pOnChangedSensor(pascalObj, event.sensor, 2,values,event.timestamp); 
          break;
        	
          case 3: //Sensor.TYPE_ORIENTATION: //3 This constant was deprecated in API level 8. use SensorManager.getOrientation() instead.
        	  values = event.values;         	    
      		  controls.pOnChangedSensor(pascalObj, event.sensor, 3,values,event.timestamp);
          break;
          
          case 4: //Sensor.TYPE_GYROSCOPE: //4 - The gyroscope measures the rate or rotation in rad/s around a device's x, y, and z axis.
        	     values = event.values;
        		//x - rad/s - Rate of rotation around the x axis.
        		//y- rad/s - Rate of rotation around the y axis.
        		//z- rad/s - Rate of rotation around the z axis.
        		controls.pOnChangedSensor(pascalObj, event.sensor, 4,values,event.timestamp);
          break;       	
        	
          case 5: //Sensor.TYPE_LIGHT://5
    		   values= new float[1];
         	   values[0] = event.values[0]; //x table plane       	       
        		//x - values[0]: Ambient light level in SI lux units
        	   controls.pOnChangedSensor(pascalObj, event.sensor, 5,values,event.timestamp);
          break;

          case 6: //Sensor.TYPE_PRESSURE://6
    		   values= new float[1];
         	   values[0] = event.values[0];        	       
        	   //x - values[0]: Atmospheric pressure in hPa (millibar)
        	   controls.pOnChangedSensor(pascalObj, event.sensor, 6,values,event.timestamp);
          break;         
          
          case 7: //Sensor.TYPE_TEMPERATURE: //7 This constant was deprecated in API level 14. use TYPE_AMBIENT_TEMPERATURE instead.
      		 //x - values[0]: Atmospheric pressure in hPa (millibar)
   		     values= new float[1];
     	     values[0] = event.values[0];
      		 controls.pOnChangedSensor(pascalObj, event.sensor, 7,values,event.timestamp);
          break;
          
          case 8: //Sensor.TYPE_PROXIMITY: //8        	   
        		//values[0]: Proximity sensor distance measured in centimeters
        	    //x Distance from object - cm  
        	    //Some proximity sensors provide only binary values representing near/0 and "other" far:  getMaximumRange() ]
   		        values= new float[1];
     	        values[0] = event.values[0];  //0 = near
        	    controls.pOnChangedSensor(pascalObj, event.sensor, 8,values,event.timestamp);
          break;
        	
          case 9: //Sensor.TYPE_GRAVITY://9        		
        		 /*   
        		 * A three dimensional vector indicating the direction and magnitude of gravity. Units are m/s^2. 
        		 * The coordinate system is the same as is used by the acceleration sensor.
                   Note: When the device is at rest, the output of the gravity sensor should be identical to that of the accelerometer.
        		 */        		
        	    values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 9,values,event.timestamp);
           break;

        	//ref http://developer.android.com/guide/topics/sensors/sensors_motion.html#sensors-motion-gyro
        	// you could use this sensor to see how fast your car is going
           case 10: //Sensor.TYPE_LINEAR_ACCELERATION: //10
        	   values = event.values;
        		//Conceptually, this sensor provides you with acceleration data according to the following relationship:
                //linear acceleration = acceleration - acceleration due to gravity
        		//The sensor coordinate system is the same as the one used by the acceleration sensor, as are the units of measure (m/s2).
        		controls.pOnChangedSensor(pascalObj, event.sensor, 10,values,event.timestamp);
        	break;
        	
            case 11: //Sensor.TYPE_ROTATION_VECTOR: //11
              values = event.values;
       		  controls.pOnChangedSensor(pascalObj, event.sensor, 11,values,event.timestamp);
       	    break;
         	
            case 12: //Sensor.TYPE_RELATIVE_HUMIDITY: //12
        		//values[0]: Relative ambient air humidity in percent
        		//When relative ambient air humidity and ambient temperature are measured 
        		//the dew point and absolute humidity can be calculated.        		
        		//Absolute Humidity
        		//The absolute humidity is the mass of water vapor in a particular volume of dry air. The unit is g/m3.        	
        		//x
       		    values = new float[1];
         	    values[0] = event.values[0];
        		controls.pOnChangedSensor(pascalObj, event.sensor, 12,values,event.timestamp);
        	break;

            case 13: //Sensor.TYPE_AMBIENT_TEMPERATURE: //13
        		//values[0]: ambient (room) temperature in degree Celsius.        		
        		//x
       		    values = new float[1];
         	    values[0] = event.values[0];
        		controls.pOnChangedSensor(pascalObj, event.sensor, 13,values,event.timestamp);        		 
            break;
            
            case 14: //Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED: //14
            	values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 14,values,event.timestamp);        		
            break;            
        	
            case 15: //Sensor.TYPE_GAME_ROTATION_VECTOR: //15
        		//x - Rotation vector component along the x axis (x * sin(Ang/2)).
        		//y - Rotation vector component along the y axis (y * sin(Ang/2)).
        		//z - Rotation vector component along the z axis (z * sin(Ang/2)).
            	values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 15,values,event.timestamp);
        	break;
        	
            case 16://Sensor.TYPE_GYROSCOPE_UNCALIBRATED: //16
            	values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 16,values,event.timestamp);        		
            break;        	
        	
            case 17: //Sensor.TYPE_SIGNIFICANT_MOTION: //17
            	values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 17,values,event.timestamp);        		
            break;
            
            case 18: //Sensor.TYPE_STEP_DETECTOR: //18
            	values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 18,values,event.timestamp);        		
            break;            
            
          
            case 19: //Sensor.TYPE_STEP_COUNTER://19  //is reset to zero only on a system reboot! -  
            	values = new float[1];
         	    values[0] = event.values[0];
         		//SensorEvent.values[0]
        		//Number of steps taken by the user since the last reboot while the sensor was activated.
        		         		
        	 	controls.pOnChangedSensor(pascalObj, event.sensor, 19,values,event.timestamp);
        	break;
        	            
            case 20: //Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR: //20
        		//x - Rotation vector component along the x axis (x * sin(Ang/2)).
        		//y - Rotation vector component along the y axis (y * sin(Ang/2)).
        		//z - Rotation vector component along the z axis (z * sin(Ang/2)).
       	        values = event.values;
        		controls.pOnChangedSensor(pascalObj, event.sensor, 20,values,event.timestamp);
        	break;        	        	        
        	
        	// Api >= 19;
            case 21: //Sensor.TYPE_HEART_RATE: //21
                values = event.values;         		
        		controls.pOnChangedSensor(pascalObj, event.sensor, 21,values,event.timestamp);
        	break;        	        	                	        	
        	
           // Api >= 19;
            case 22: //Sensor.TYPE_AUTO_ROTATION: //22        		
                values = event.values; 
        		controls.pOnChangedSensor(pascalObj, event.sensor, 22,values,event.timestamp);
        	break;
               	        	        	
      	  } //switch		
        }        
     };                
   }       
       
   public void jFree() {
      //free local objects...
      mSensorManager.unregisterListener(mSensorEventListener);
      mListSensors.clear();
      mListSensors = null;
	  mSensorEventListener = null;
	  mSensorManager = null;
	  mCurrSensor  = null;
   }
  
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
	 
   public int[] GetDeviceSensorsTypes() {	   
	 int[] intArray = new int[mListSensors.size()];	   	 	          
     for(int i=0; i < mListSensors.size(); i++){        
        intArray[i] = mListSensors.get(i).getType();
     }     
     return intArray;     
   }
      
   public String[] GetDeviceSensorsNames() {	   	 	   
	 String[] strArray = new String[mListSensors.size()];       
     for(int i=0; i < mListSensors.size(); i++){ 
    	strArray[i] = mListSensors.get(i).getName();        
     }     
     return strArray;  
   }
   
   public void RegisterListeningSensor(int _sensorType) {	   
       //Tell which sensor you are going to use
       //And declare delay of sensor    	     	  
	   if (SensorExists(_sensorType)) {		              
		   mCurrSensor = mSensorManager.getDefaultSensor(_sensorType);                      
           mSensorManager.registerListener(mSensorEventListener, mCurrSensor, SensorManager.SENSOR_DELAY_NORMAL);           
           controls.pOnListeningSensor(pascalObj, mCurrSensor, mCurrSensor.getType());           
	   }        
   }
      
   public void RegisterListeningSensor(int _sensorType, int _delayType) {	   
       //Tell which sensor you are going to use
       //And declare delay of sensor           	     	  
	   if (SensorExists(_sensorType)) { 
           mCurrSensor = mSensorManager.getDefaultSensor(_sensorType);
           mSensorManager.registerListener(mSensorEventListener, mCurrSensor, _delayType);
           controls.pOnListeningSensor(pascalObj, mCurrSensor , mCurrSensor.getType()); //fail....
	   } 
       
   }
   
   public void StopListeningAll() {
	   mSensorManager.unregisterListener(mSensorEventListener);
   }   
      
   public boolean SensorExists(int _sensorType) {
	   List<Sensor> listType =	mSensorManager.getSensorList(_sensorType);
	   if (listType.size() > 0) return true;
	   else return false;	      
   }
   
   public String[] GetSensorsNames(int _sensorType) {	 
       List<Sensor> listType =	mSensorManager.getSensorList(_sensorType);      
  	   String[] strArray = new String[listType.size()];       
       for(int i=0; i < listType.size(); i++){ 
    	 strArray[i] = listType.get(i).toString();        
       }       
       return strArray;   
      //Use this method to get the list of available sensors of a certain type.
   }
   
   public Sensor GetSensor(int _sensorType) {  //android.hardware.Sensor
	   return mSensorManager.getDefaultSensor(_sensorType);
   }
   
   public float GetSensorMaximumRange(Sensor _sensor) { //maximum range of the sensor in the sensor's unit.
        return 	_sensor.getMaximumRange();
   }
   
   public String GetSensorVendor (Sensor _sensor) {
	   return _sensor.getVendor();	   
   }
   
   public int GetSensorMinDelay(Sensor _sensor) {
	   return _sensor.getMinDelay(); 	   	   
   }
   
   public String GetSensorName(Sensor _sensor) {	    
	   return _sensor.getName();	   
   }
   
   public int GetSensorType(Sensor _sensor) {	    
	   return _sensor.getType();	   
   }
      
   public void UnregisterListenerSensor(Sensor _sensor) {
	   mSensorManager.unregisterListener (mSensorEventListener, _sensor);	   
	   controls.pOnUnregisterListeningSensor(pascalObj, _sensor.getType(), _sensor.getName());
   }   
   
   public float GetGravityEarth(){
	 return SensorManager.GRAVITY_EARTH;  	 
   }

   public float GetAltitude(float _localPressure) {
       //return mSensorManager.getAltitude(SensorManager.PRESSURE_STANDARD_ATMOSPHERE, _localPressure);
	   return SensorManager.getAltitude(SensorManager.PRESSURE_STANDARD_ATMOSPHERE, _localPressure);
   }
   
   public float GetAltitude(float _pressureAtSeaLevel, float _localPressure) {
	   //return mSensorManager.getAltitude(_pressureAtSeaLevel, _localPressure);
	   return SensorManager.getAltitude(_pressureAtSeaLevel, _localPressure);
   }
      
   public Sensor GetSensor(String _sensorName) {	   
     Sensor sensor = null;      
     for(int i=0; i < mListSensors.size(); i++){    	
     	if ((mListSensors.get(i).getName()).equals(_sensorName)){
    	   sensor= mListSensors.get(i); 	
    	}    		
     }            
     return sensor;
   }
    
   public float GetSensorPower(Sensor _sensor) {
      return _sensor.getPower();
   }
   
   public float GetSensorResolution(Sensor _sensor) {
     return _sensor.getResolution();
   }
   
   public void RegisterListeningSensor(Sensor _sensor) {	   
       //Tell which sensor you are going to use
       //And declare delay of sensor    	     	  
	   mSensorManager.registerListener(mSensorEventListener,_sensor, SensorManager.SENSOR_DELAY_NORMAL);
	   controls.pOnListeningSensor(pascalObj, _sensor, _sensor.getType());
   }
   
   public void RegisterListeningSensor(Sensor _sensor, int _delayType) {	   
       //Tell which sensor you are going to use
       //And declare delay of sensor    	     	  
	   mSensorManager.registerListener(mSensorEventListener,_sensor, _delayType);     
	   controls.pOnListeningSensor(pascalObj, _sensor, _sensor.getType());
   }

}


