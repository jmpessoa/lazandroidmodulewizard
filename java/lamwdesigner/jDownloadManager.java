package com.example.appdownloadmanagerdemo1;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import android.app.DownloadManager;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;

//ref. http://www.vogella.com/tutorials/AndroidServices/article.html  
//http://www.tutorialspoint.com/android/android_services.htm

/*Draft java code by "Lazarus Android Module Wizard" [5/27/2016 14:25:29]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jDownloadManager /*extends ...*/ {

 private long     pascalObj = 0;      // Pascal Object
 private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
 private Context  context   = null;

 DownloadManager mManager;
 DownloadManager.Request mRequest;
 String notifyTitle= "Downloading...";
 String notifyDescription = "Please, wait...";
 
 String mUrl = "//http://www.freemediagoo.com/free-media/wildlife/o_o_bird-med.jpg";
 String mFilename = "o_o_bird-med.jpg"; 
 String mPath = Environment.DIRECTORY_DOWNLOADS; // default ...
 
 String mLocalFileName= "";
 String mMediaType= "";
 String mSizeBytes= "";
 String mLocalUriString= "";
 long mStartTime = 0;
 Uri mFileUri = null;
 boolean mExtrasExists = false;
    
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 public jDownloadManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
 
 private String GetEnvironmentDirectory(int _directory) {
	 
     	  File filePath= null;
     	  
		  String Path= Environment.DIRECTORY_DOWNLOADS;				  
		  
		  switch(_directory) {	                       
		    case 0:  Path = Environment.DIRECTORY_DOWNLOADS; break;	   
		    case 1:  Path = Environment.DIRECTORY_DCIM; break;
		    case 2:  Path = Environment.DIRECTORY_MUSIC; break;
		    case 3:  Path = Environment.DIRECTORY_PICTURES; break;
		    case 4:  Path = Environment.DIRECTORY_NOTIFICATIONS; break;
		    case 5:  Path = Environment.DIRECTORY_MOVIES; break;
		    case 6:  Path = Environment.DIRECTORY_PODCASTS; break;
		    case 7:  Path = Environment.DIRECTORY_RINGTONES; break;
		    
		    /*    //do not save to internal app storage ... sorry 
		    case 8: {
		    	if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) == true) {
		    	  filePath = Environment.getExternalStorageDirectory();  //sdcard!
		    	   // Make sure the directory exists.
		    	  filePath.mkdirs();
		   	      Path= filePath.getPath();
		   	      break;
		        }
		    }		    		   
		    case 9: Path  = this.controls.activity.getFilesDir().getAbsolutePath(); break;      //Result : /data/data/com/MyApp/files		    
		    case 10: { 
		    	       Path = this.controls.activity.getFilesDir().getPath();
		               Path = Path.substring(0, Path.lastIndexOf("/")) + "/databases"; break;
		    }		            
		    case 11: {  
		    	        Path = this.controls.activity.getFilesDir().getPath();
	                    Path = Path.substring(0, Path.lastIndexOf("/")) + "/shared_prefs"; break;
		    }
		  	*/		    		   
		  }		  
		  return Path;
 }
 
 public void SetNotification(String _title, String _description) {
     notifyTitle= _title;
     notifyDescription = _description;
 }
 
 private boolean SetUrl(String _urlString) {	   
      if (! _urlString.equals("") ) {
	 mUrl = _urlString;	   
      }           
     // in order for this if to run, you must use the android 3.2 to compile your app [API Level: 13]      
     if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
         mRequest = new DownloadManager.Request( Uri.parse(mUrl) );   
         mRequest.setDescription(notifyDescription);
         mRequest.setTitle(notifyTitle + " [" + mFilename + "]" );           	   
  	     mRequest.allowScanningByMediaScanner();
  	     mRequest.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
  	   return true;
     }           
     else return false;
 }
       
 public void SaveToFile(int _environmentPath,  String _filname) {	   
	   mPath = GetEnvironmentDirectory(_environmentPath);
	   mFilename = _filname;	  
 }
 
 public void SaveToFile(String _filname) {	   
	   mFilename = _filname;	  
 }
 
 public int Start(String _urlString) {
	   int r = -1; //ok
	   mExtrasExists = false;
	   if (SetUrl(_urlString)) {		   
		   /*mPath: /storage/emulated/0/Download    --> Fail!
		     mPath: Download  --> OK! [Environment.DIRECTORY_DOWNLOADS] 
		   */
		  mRequest.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_WIFI|DownloadManager.Request.NETWORK_MOBILE);
	      mRequest.setDestinationInExternalPublicDir(mPath, mFilename); //"name-of-the-file.ext"
	      mManager = (DownloadManager)controls.activity.getSystemService(Context.DOWNLOAD_SERVICE);
		   //go to download service and enqueue file...
		  mStartTime = System.currentTimeMillis();
	      mManager.enqueue(mRequest);	      
	   }
	   else r = 0; //fail ..	   
	   return r;
 }   
 
 public String GetActionDownloadComplete() {  //DownloadManager.ACTION_DOWNLOAD_COMPLETE
   return "android.intent.action.DOWNLOAD_COMPLETE";
 }
 
 public String GetExtras(Intent _intent,  String _delimiter) {
	  
	   Bundle extras = _intent.getExtras();
	   DownloadManager.Query q = new DownloadManager.Query();
	   q.setFilterById(extras.getLong(DownloadManager.EXTRA_DOWNLOAD_ID));
	   Cursor c = mManager.query(q);
	   if (c.moveToFirst()) {
	       int status = c.getInt(c.getColumnIndex(DownloadManager.COLUMN_STATUS));
	       if (status == DownloadManager.STATUS_SUCCESSFUL) {
	           // process download
	    	  // mTitle = c.getString(c.getColumnIndex(DownloadManager.COLUMN_TITLE));	           
	    	   mLocalFileName = c.getString(c.getColumnIndex(DownloadManager.COLUMN_LOCAL_FILENAME));
	    	   mMediaType = c.getString(c.getColumnIndex(DownloadManager.COLUMN_MEDIA_TYPE ));
	    	   mSizeBytes = c.getString(c.getColumnIndex(DownloadManager.COLUMN_TOTAL_SIZE_BYTES ));
	    	   mLocalUriString = c.getString(c.getColumnIndex(DownloadManager.COLUMN_LOCAL_URI ));	    	   
	    	   mFileUri =  Uri.parse(mLocalUriString);
	    	   mExtrasExists = true;
	       }
	       return mLocalFileName + _delimiter + mMediaType + _delimiter+ mSizeBytes + _delimiter + mLocalUriString;
	   } else return "";	   
 }
 
 public String GetLocalUriAsString() {
	  return mLocalUriString;
 }
 
 public String GetLocalFileName() {
	  return mLocalFileName;
 }
 
 public String GetMediaType() {
	  return mMediaType;
 }
 
 public int GetFileSizeBytes() {
	  return Integer.parseInt(mSizeBytes);
 }
                  
 public int GetElapsedTimeInSeconds() {
   return (int)(System.currentTimeMillis() - mStartTime)/1000;
 }
 
public Uri GetFileUri() {	 
	return mFileUri;
}
 
}
