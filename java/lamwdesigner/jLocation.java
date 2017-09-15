package com.example.applocationdemo1;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import android.content.Context;
import android.content.Intent;
import android.location.Address;
import android.location.Criteria;
import android.location.Geocoder;
import android.location.GpsSatellite;
import android.location.GpsStatus;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.location.LocationProvider;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.provider.Settings;


/*Draft java code by "Lazarus Android Module Wizard" [8/9/2014 20:25:55]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//ref. 1:  http://examples.javacodegeeks.com/android/core/location/android-location-based-services-example/
//ref. 2   http://examples.javacodegeeks.com/android/core/location/proximity-alerts-example/
//ref. 3:  http://www.wingnity.com/blog/android-gps-location-address-using-location-manager/
//ref. 4:  http://www.techrepublic.com/blog/software-engineer/take-advantage-of-androids-gps-api/
//ref. 5:  http://androidexample.com/GPS_Basic__-__Android_Example/index.php?view=article_discription&aid=68&aaid=93
//ref. 6:  http://hejp.co.uk/android/android-gps-example/
//ref. 7:  http://www.slideshare.net/androidstream/android-gps-tutorial

public class jLocation /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;

    private MyLocationListener mlistener;    
    private LocationManager mLocationManager;
    private Criteria mCriteria;
    private String mProvider;
        
    private String mAddress;
    private String mStatus;
    
    //The minimum distance to change Updates in meters
    private long mDistanceForUpdates;
    // The minimum time between updates in milliseconds
    private long mTimeForUpdates;
    
    private double mLat; 
    private double mLng;
    private double mAlt;
    
    private int mCriteriaAccuracy;
  
    private String mMapType;
    private int mMapZoom;
    private int mMapSizeW;
    private int mMapSizeH;
    private Location location;
    
    private String mMarkerHighlightColor = "blue";
    
    private GpsStatus mGpsStatus = null;
    private int mSatCount = 0;
    ArrayList<String> mylist = new ArrayList<String>();
    
    GpsStatus.Listener gpsListener;
    
    private String hasAlmanac;
    private String hasEphemeris;
    private float mTimeToFirstFix = 0;
         
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jLocation(Controls _ctrls, long _Self, long _TimeForUpdates, long _DistanceForUpdates, int _CriteriaAccuracy, int _MapType) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       
       //Get the location manager
       mLocationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
       
       //Define the criteria how to select the location provider
       mCriteria = new Criteria();
       
       if (_CriteriaAccuracy == 0) {
          mCriteriaAccuracy = Criteria.ACCURACY_COARSE; //default::Network-based/wi-fi
       }else {
    	  mCriteriaAccuracy = Criteria.ACCURACY_FINE;  
       }
       
       switch(_MapType) { //mt, mt, mtHybrid
         case 0: mMapType = "roadmap"; break;
         case 1: mMapType = "satellite"; break;
         case 2: mMapType = "terrain"; break;
         case 3: mMapType = "hybrid"; break;
         default: mMapType = "roadmap";
       }
       
       /*
        * the Android Location Services periodically checks on your location using GPS, Cell-ID, 
        * and Wi-Fi to locate your device. When it does this,
        *  your Android phone will send back publicly broadcast Wi-Fi access points' Service set identifier (SSID) 
        *  and Media Access Control (MAC) data.
        *  ref: http://www.zdnet.com/blog/networking/how-google-and-everyone-else-gets-wi-fi-location-data/1664
        */       
       mlistener = new MyLocationListener();     
       mLat = 0.0; 
       mLng = 0.0;       
       mTimeForUpdates = _TimeForUpdates;           //(long) (1000 * 60 * 1)/4; // 1 minute
       mDistanceForUpdates = _DistanceForUpdates;  //1; //meters
       
       mMapZoom = 14;
       mMapSizeW = 512;
       mMapSizeH = 512;

	   //get the best provider depending on the criteria
       mProvider = mLocationManager.getBestProvider(mCriteria, false); //fixed by Damian [if true then only a provider that is currently enabled is returned]     
       //Register the listener with the Location Manager to receive location updates
       mLocationManager.requestLocationUpdates(mProvider, mTimeForUpdates, mDistanceForUpdates, mlistener);
       
       
       gpsListener = new GpsStatus.Listener() {
    	    public void onGpsStatusChanged(int event) {    	    	
 		        	switch( event) {
 		        	
		        	   case GpsStatus.GPS_EVENT_STARTED: controls.pOnGpsStatusChanged(pascalObj, 0, 1); break;
		        	   case GpsStatus.GPS_EVENT_STOPPED: controls.pOnGpsStatusChanged(pascalObj, mSatCount, 2); break;
		        	  
		        	   case GpsStatus.GPS_EVENT_FIRST_FIX: {		        		  
		        		   
		        		  if ( TrySatellitesInfo() ) { 
		        			 mTimeToFirstFix = mGpsStatus.getTimeToFirstFix();   
		        		     controls.pOnGpsStatusChanged(pascalObj, mSatCount, 3); break;
		        		  }   
		        		  
		        	   }
		        	  
		        	   case GpsStatus.GPS_EVENT_SATELLITE_STATUS: {			        	  
			        	  if ( TrySatellitesInfo() ) {		        		   
		        		     controls.pOnGpsStatusChanged(pascalObj, mSatCount, 4);
			        	  }   
		        	   }	
		        	   
 		        	} 
 		    }     			        			            	    
    	};
    	mLocationManager.addGpsStatusListener(gpsListener);    	              
    }

    private boolean TrySatellitesInfo() {  
    	mSatCount = 0;
        mGpsStatus = mLocationManager.getGpsStatus( mGpsStatus ); 			      
        if (mGpsStatus!=null) {  			         			                    
          mylist.clear();
          if ( mGpsStatus != null ) { 
            for ( GpsSatellite sat : mGpsStatus.getSatellites() ) { 
               if ( sat.usedInFix() ) {             	   
            	   mSatCount++;		            	   
            	   hasAlmanac = "false";
            	   if ( sat.hasAlmanac() )  hasAlmanac = "true";
            	   hasEphemeris = "false";
            	   if ( sat.hasEphemeris() )  hasEphemeris = "false";            	   
                   mylist.add( "SNR=" + sat.getSnr() + ";" +
                		       "Elevation=" + sat.getElevation()+ ";" +
                		       "Azimuth=" + sat.getAzimuth()+ ";" +
                		       "PRN=" + sat.getPrn()+ ";" +
                		       "hasAlmanac=" + hasAlmanac + ";" +
                		       "hasEphemeris=" + hasEphemeris 
                		      );
               } 
            }
            
          }        			           			           			           
        }
        
        if (mSatCount > 0) return true;
        else return false;
        
    }

    public void jFree() {
      //free local objects...
      //mLocationManager.removeGpsStatusListener(gpsListener);	//depr api 24
      //mLocationManager.unregisterGnssStatusCallback(GpssStatus.Callback);    	
      mLocationManager = null;
      mCriteria = null;
      mlistener = null;
      location = null;
    }
    
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
  public boolean StartTracker() {
        boolean res= false;        
	    mCriteria.setAccuracy(mCriteriaAccuracy);	    
	    //mCriteria.setCostAllowed(false);	                                 		 		            
        if (location != null) {
          mlistener.onLocationChanged(location);
          res = true;
        }            
        return res;
   }
  
  public double[] GetLatitudeLongitude(String _fullAddress) {  //double _latitude, double _longitude
	  	 
      Geocoder geocoder = new Geocoder(context, Locale.getDefault());      
      double[] d;
      d = new double[]{0, 0};     
      // Create a list to contain the result address      
      List<Address> addresses = null;            
      try {
          /* Return 1 address. */
          addresses = geocoder.getFromLocationName(_fullAddress, 1);   
         
      } catch (IOException e1) {
          e1.printStackTrace();          
      } catch (IllegalArgumentException e2) {          
          e2.printStackTrace();
          return d;
      }
      // If the reverse geocode returned an address
      if (addresses != null && addresses.size() > 0) {
          // Get the first address
          Address address = addresses.get(0);                   
          d[0] = address.getLatitude();                         
          d[1] = address.getLongitude(); 
      }
      return d;
      
  }
    
  public boolean StartTracker(String _locationName) {	  
      boolean res = false;
      double[] d;      
	  mCriteria.setAccuracy(mCriteriaAccuracy);                     
	  //mCriteria.setCostAllowed(false);	    	                 
      if (location != null) {    	  
    	d = this.GetLatitudeLongitude(_locationName);    	
        location.reset();
        location.setLatitude(d[0]);
        location.setLongitude(d[1]);
        mlistener.onLocationChanged(location); //force
        res = true;
      }                           
      return res;
   }  
  
   public void ShowLocationSouceSettings() {
	  Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
      context.startActivity(intent); 
   }   
   
   public void RequestLocationUpdates() {          	      
      mLocationManager.requestLocationUpdates(mProvider, mTimeForUpdates, mDistanceForUpdates, mlistener);            
   }
      
   public void RequestLocationUpdates(int _provider) {          	      
	  if (_provider == 0) 
	    mLocationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER,mTimeForUpdates, mDistanceForUpdates, mlistener);
	  else
	    mLocationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,mTimeForUpdates, mDistanceForUpdates, mlistener);	      
   }
       
   public void StopTracker() {  // finalize ....
      mlistener.RemoveUpdates(mLocationManager);
   }
    
   public void SetCriteriaAccuracy(int _accuracy) {
       if(_accuracy == 0){  //default...     	            
          mCriteria.setAccuracy(Criteria.ACCURACY_COARSE);   //less accuracy      
       }else { 
    	  mCriteria.setAccuracy(Criteria.ACCURACY_FINE); //high accuracy         
       }          
    }       
        
    public boolean IsGPSProvider() {    	
    	if (mLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) { 
          //the last known location of this provider        
          location = mLocationManager.getLastKnownLocation(mProvider);
          return true;
    	}
    	else return false;    	              
    }
    
    public boolean IsNetProvider() {    	
    	if ( mLocationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER) ) { 
          //the last known location of this provider        
          location = mLocationManager.getLastKnownLocation(mProvider);
          return true;
    	}
    	else return false;    	       
    }
    
    public void SetTimeForUpdates(long _time) { // millsecs 
      mTimeForUpdates = _time;
    }
    
    public void SetDistanceForUpdates(long _distance) { //meters
      mDistanceForUpdates = _distance;
    }
    
    public double GetLatitude() { 
      return mLat;
    }   
    
    public double GetLongitude() {
      return mLng;
    }   

    public double GetAltitude() {
      return mAlt;
    }   
        
    public boolean IsWifiEnabled() {
       WifiManager wifiManager = (WifiManager)this.context.getSystemService(Context.WIFI_SERVICE);
       return  wifiManager.isWifiEnabled();	
    }
    
    public void SetWifiEnabled(boolean _status) {
       WifiManager wifiManager = (WifiManager)this.context.getSystemService(Context.WIFI_SERVICE);             
       wifiManager.setWifiEnabled(_status);
    }
        
    //https://developers.google.com/maps/documentation/staticmaps
    public String GetGoogleMapsUrl(double _latitude, double _longitude) {   //sensor=false ??        
      String url = "http://maps.googleapis.com/maps/api/staticmap?sensor=false&center="+_latitude + "," + _longitude+
                    "&zoom="+mMapZoom+"&size="+mMapSizeW+"x"+mMapSizeH+"&maptype="+mMapType+"&markers="+_latitude + "," + _longitude;          		                         
      return url;
    }
    
    //http://maps.google.com/maps?f=d&daddr=" + fullAddress
    public String GetGoogleMapsUrl(String _fullAddress) {         //sensor=false ??
        String url = "http://maps.googleapis.com/maps/api/staticmap?f=d&daddr="+ _fullAddress +
                      "&zoom="+mMapZoom+"&size="+mMapSizeW+"x"+mMapSizeH+"&maptype="+mMapType+"&markers="+ _fullAddress;          		                         
        return url;
    }
           
    //http://maps.googleapis.com/maps/api/staticmap?size=400x400&path=40.737102,-73.990318|40.749825,-73.987963|40.752946,-73.987384|40.755823,-73.986397
    public String GetGoogleMapsUrl(double[] _latitude, double[] _longitude) {
    	String path ="";
    	int count = _latitude.length;
   
    	path = String.valueOf(_latitude[0]) +","+ String.valueOf(_longitude[0]);    	
    	for (int i = 1; i < count; i++) {
    		path = path + "|" + String.valueOf(_latitude[i]) +","+ String.valueOf(_longitude[i]); 	
    	}
    	
        String url = "http://maps.googleapis.com/maps/api/staticmap?f=d&sensor=false&path="+ path +
                      "&zoom="+mMapZoom+"&size="+mMapSizeW+"x"+mMapSizeH+"&maptype="+mMapType+"&markers="+path;                        
        return url;
    }
     
    
    public String GetGoogleMapsUrl(double[] _latitude, double[] _longitude, int _pathFlag) {
    	String path ="";
    	int count = _latitude.length;
    	String url="";
   
    	path = String.valueOf(_latitude[0]) +","+ String.valueOf(_longitude[0]);    	
    	for (int i = 1; i < count; i++) {
    		path = path + "|" + String.valueOf(_latitude[i]) +","+ String.valueOf(_longitude[i]); 	
    	}
    	
    	switch(_pathFlag) {
    	case 0: url = "http://maps.googleapis.com/maps/api/staticmap?f=d&sensor=false&path=" + path +
                "&zoom="+mMapZoom+"&size="+mMapSizeW+"x"+mMapSizeH+"&maptype="+mMapType+"&markers=" +path; break;
                
    	case 1: url = "http://maps.googleapis.com/maps/api/staticmap?f=d&sensor=false"+
                "&zoom="+mMapZoom+"&size="+mMapSizeW+"x"+mMapSizeH+"&maptype="+mMapType+"&markers="+path; break;
    	
    	case 2: url = "http://maps.googleapis.com/maps/api/staticmap?f=d&sensor=false&path="+ path +
                "&zoom="+mMapZoom+"&size="+mMapSizeW+"x"+mMapSizeH+"&maptype="+mMapType; break;   	
                
    	}
    	
        return url;
    }
    
    
    public String GetGoogleMapsUrl(double[] _latitude, double[] _longitude, int _pathFlag, int _markerHighlightIndex) {
    	String path ="";
    	int count = _latitude.length;
    	String url="";
        int index = _markerHighlightIndex;
                       
        int flag = _pathFlag;             
        if (flag > 1) flag = 1;
        
        
        
        if (index >= count) index = count-1;        
        String markerHighlight = String.valueOf(_latitude[index]) +","+ String.valueOf(_longitude[index]);
        
    	
    	path = String.valueOf(_latitude[0]) +","+ String.valueOf(_longitude[0]);    	
    	for (int i = 1; i < count; i++) {    		
    	   path = path + "|" + String.valueOf(_latitude[i]) +","+ String.valueOf(_longitude[i]);    		
    	}
    	
    	if (flag == 0)  {    
    	   url = "http://maps.googleapis.com/maps/api/staticmap?f=d&sensor=false&path=" + path +
                "&zoom="+mMapZoom+"&size="+mMapSizeW+"x"+mMapSizeH+"&maptype="+mMapType+
                "&markers=color:"+mMarkerHighlightColor+"|"+markerHighlight+"&markers=" +path;
    	}        
                
    	if (flag == 1)  {
    	  url = "http://maps.googleapis.com/maps/api/staticmap?f=d&sensor=false"+
                "&zoom="+mMapZoom+"&size="+mMapSizeW+"x"+mMapSizeH+"&maptype="+mMapType+
                "&markers=color:"+mMarkerHighlightColor+"|"+markerHighlight+"&markers="+path;
    	}
    	
        return url;
    }    
    
    //black, brown, green, purple, yellow, blue, gray, orange, red, white
    public void SetMarkerHighlightColor(int _color) {
    	switch (_color) {
    	case 0: mMarkerHighlightColor = "black"; break;
    	case 1: mMarkerHighlightColor = "brown"; break;
    	case 2: mMarkerHighlightColor = "green"; break;
    	case 3: mMarkerHighlightColor = "purple"; break;
    	case 4: mMarkerHighlightColor = "yellow"; break;
    	case 5: mMarkerHighlightColor = "blue"; break;
    	case 6: mMarkerHighlightColor = "gray"; break;    	
    	case 7: mMarkerHighlightColor = "orange"; break;
    	case 8: mMarkerHighlightColor = "red"; break;
    	case 9: mMarkerHighlightColor = "white"; break;  
    	default: mMarkerHighlightColor = "blue";;
    	}            
    }
    
    public void SetMapWidth(int _mapwidth) {
	   mMapSizeW = _mapwidth;    	
    }
    
    public void SetMapHeight(int _mapheight) {
	  mMapSizeH= _mapheight;    	
    }
    
    public void SetMapZoom(int _mapzoom) {
      if (_mapzoom < 14) {	
	     mMapZoom = _mapzoom;
      }
      else {
    	 mMapZoom = 14;
      }      
    }
    
   public void SetMapType(int _maptype) {
	  switch(_maptype) {
		 case 0: mMapType= "roadmap"; break;
		 case 1: mMapType= "satellite"; break;
		 case 2: mMapType= "terrain"; break;
		 case 3: mMapType= "hybrid"; break;
		 default: mMapType= "roadmap";
	  }   		
    }

   public String GetAddress() {
	     return mAddress;
   }

   public String GetAddress(double _latitude, double _longitude) {
  	 
           Geocoder geocoder = new Geocoder(context, Locale.getDefault());
           // Create a list to contain the result address
           List<Address> addresses = null;
           try {
               /*
                * Return 1 address.
                */
               addresses = geocoder.getFromLocation(_latitude, _longitude, 1);
           } catch (IOException e1) {
               e1.printStackTrace();
               return ("IO Exception trying to get address:" + e1);
           } catch (IllegalArgumentException e2) {
               // Error message to post in the log
               String errorString = "Illegal arguments passed to address service";
               e2.printStackTrace();
               return errorString;
           }
           
           // If the reverse geocode returned an address
           if (addresses != null && addresses.size() > 0) {
               // Get the first address
               Address address = addresses.get(0);
               /*
                * Format the first line of address (if available), city, and
                * country name.
                */
               String addressText = String.format(
                       "%s, %s, %s",
                       // If there's a street address, add it
                       address.getMaxAddressLineIndex() > 0 ? address
                               .getAddressLine(0) : "",
                       // Locality is usually a city
                       address.getLocality(),
                       // The country of the address
                       address.getCountryName());
               // Return the text
               return addressText;
           } else {
               return "No address found by the service: Note to the developers, If no address is found by google itself, there is nothing you can do about it. :(";
           }
    }
   
   public float GetDistanceBetween(double _startLatitude, double _startLongitude, double _endLatitude, double _endLongitude) {
	 float[] result=new float[1];
	 result[0] = 0;
	 if (location != null)   
        Location.distanceBetween(_startLatitude, _startLongitude, _endLatitude, _endLongitude, result);	 
	 return result[0];  // it's output is a WGS84 ellipsoid !!
   }

   public float GetDistanceTo(double _latitude, double _longitude) {
	 float r = 0;  
	 if (location != null) {
	   Location loc = new Location(location); //or new Location(String provider)   
	   loc.reset();
	   loc.setLatitude(_latitude);
	   loc.setLongitude(_longitude);	   
       r = location.distanceTo(loc);   // meters   
	 }
	 return r;
   }
   
   private class MyLocationListener implements LocationListener {    	    	
    	
        @Override
        /*.*/public void onLocationChanged(Location _location) {
                                           	 
             mLat = _location.getLatitude();
             mLng = _location.getLongitude();
             mAlt = _location.getAltitude();                                   
             mAddress = GetAddress(mLat, mLng);
             
            // mLastLocationMillis = SystemClock.elapsedRealtime();
             
        	 controls.pOnLocationChanged(pascalObj,mLat,mLng,mAlt,mAddress);        		
        }

        @Override
        /*.*/public void onStatusChanged(String provider, int status, Bundle extras) {
           
        	switch (status) {
    		  case LocationProvider.OUT_OF_SERVICE:
    			 mStatus="Out of Service";
    		  break;
    		  case LocationProvider.TEMPORARILY_UNAVAILABLE:
    			  mStatus="Temporarily Unavailable";    			
    	      break;
    		  case LocationProvider.AVAILABLE:
    			 mStatus="Available";    		         		       
              break;
    		}        	        	
        	controls.pOnLocationStatusChanged(pascalObj, status, provider, mStatus);
        }

        @Override
        /*.*/public void onProviderEnabled(String provider) {  // "Gps is turned on!!
         	//Log.i("jLocation", "Enabled: "+provider);  
         	controls.pOnLocationProviderEnabled(pascalObj, provider);
        }
        
        @Override
        /*.*/public void onProviderDisabled(String provider) {   // "Gps is turned off!!     
        	///* this is called if/when the GPS is disabled in settings */
        	//Log.i("jLocation", "Disabled: "+provider);
        	controls.pOnLocationProviderDisabled(pascalObj, provider);        	
        }
                
        /*.*/public void RemoveUpdates(LocationManager lm) {
        	lm.removeUpdates(this);
        }
        
    }   
       
    public int GetSatelliteCount() { 
        return mSatCount;
    }
    
    public String GetSatelliteInfo(int _index) {    	
    	if (mSatCount == 0) return "";
    	if (_index > (mSatCount-1)) return "";
    	if (_index < 0) return "";    	
    	return mylist.get(_index);
    }        
    
    public float GetTimeToFirstFix() {
    	return mTimeToFirstFix;
    }
    
}

