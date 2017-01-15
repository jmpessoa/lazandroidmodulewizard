package com.example.appdownloadservicedemo1;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

import org.apache.http.util.ByteArrayBuffer;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.os.Environment;
//import android.util.Log;


/*Draft java code by "Lazarus Android Module Wizard" [5/26/2016 20:15:41]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jDownloadService extends IntentService {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   
   private int result = 0; //0 = fail;  -1 = ok!
   
   private String mURL = "http://www.freemediagoo.com/surreal-backgrounds/boat6-med.jpg";
   private String mFileSaveAs = "boat6-med.jpg";
   
   private File filePath;   
   private String mFILEPATH;   
   
   private String mIntentAction;   
   /**
    * A constructor is required, and must call the super IntentService(String)
    * constructor with a name for the worker thread.
    */
   public jDownloadService() {
       super("jDownloadService");
   }
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jDownloadService(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      super("jDownloadService");
	  //super(_ctrls.activity); 
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);   
      mFILEPATH = filePath.getPath();      
      
   }
 
   public void jFree() {
     //free local objects...
   }
 
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   
   @Override
   protected void onHandleIntent(Intent intent) {   // will be called asynchronously by Android
   	    //TODO Auto-generated method stub	   
	    String urlPath = intent.getStringExtra("URL");
	    String fileName = intent.getStringExtra("FILENAME");
	    String filePath = intent.getStringExtra("PATH");
	    String iaction = intent.getStringExtra("ACTION");
	    File output = new File(filePath,fileName);
	    
	    if (output.exists()) {
	      output.delete();
	    }

	    InputStream stream = null;
	    FileOutputStream fos = null;
	    
	    long startTime = System.currentTimeMillis();
	    
	    try {

	      URL url = new URL(urlPath);
	      
	      startTime = System.currentTimeMillis();
	      
	      URLConnection con = url.openConnection();
	      
	      stream = con.getInputStream();
	      
	     //InputStreamReader reader = new InputStreamReader(stream);   FAIL !!! FAIL!!!
	      BufferedInputStream reader = new BufferedInputStream(stream);	      
	       	      
	      ByteArrayBuffer baf = new ByteArrayBuffer(50);
	      
          int current = 0;
          while ((current = reader.read()) != -1) {
             baf.append((byte) current);
          }          
          
          fos = new FileOutputStream(output.getPath());
          fos.write(baf.toByteArray());
          fos.flush();
	      // successfully finished
	      result = -1; //Activity.RESULT_OK;
	    } catch (Exception e) {
	      e.printStackTrace();
	    } finally {
	    	try {
				fos.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	try {
				stream.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }	    	    		   
	    publishResults(output.getAbsolutePath(), result, iaction, (System.currentTimeMillis() - startTime));   	
   }
   
   private void publishResults(String outputPath, int result, String _action, long time) {

	   //Implicit intents specify the action which should be performed and optionally data which 
	   //provides content for the action.

	    Intent intent = new Intent(_action);
	    intent.putExtra("FilePath", outputPath);
	    if  (result == -1)
	       intent.putExtra("Result", "RESULT_OK"); 
	    else
	       intent.putExtra("Result", "RESULT_CANCELED"); 
	    intent.putExtra("ElapsedTimeInSeconds", (int)time/1000); //long
	    sendBroadcast(intent);
   }    
      
   //Method to start the service
   public void Start(String _urlString, String _intentActionNotification) {
	     mURL = _urlString;	  		        		
	     mIntentAction = _intentActionNotification;
	     	     
	     //Explicit intents explicitly define the component which should be called by the Android system,
	     //by using the Java class as identifier

	     //Create an intent for a specific component.	   
	     Intent intent = new Intent(controls.activity, jDownloadService.class);
	     intent.putExtra("FILENAME", mFileSaveAs); //
	     intent.putExtra("URL", mURL);	
	     intent.putExtra("PATH", mFILEPATH);
	     intent.putExtra("ACTION", mIntentAction);
  	     controls.activity.startService(intent);	   	     	     
   }
   
   public void SaveToFile(String _filepath, String _filename) {
	   mFILEPATH = _filepath;
	   mFileSaveAs =  _filename;	   
   }
   
   public void SaveToFile(String _filename) {
	   mFileSaveAs =  _filename;	   
   }  
   
}

