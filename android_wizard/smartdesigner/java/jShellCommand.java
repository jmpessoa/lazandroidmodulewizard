package com.example.appchronometerdemo1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import android.content.Context;
import android.os.AsyncTask;

/*Draft java code by "Lazarus Android Module Wizard" [5/8/2015 20:24:14]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//ref. http://tech-papers.org/executing-shell-command-android-application/
public class jShellCommand {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
 
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jShellCommand(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      //Log.i("jShellCommand", "create");
   }
 
   public void jFree() {
     //free local objects...
   }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 public void Execute(String _shellCmd) {
	 //Log.i("exec", "0");
	 new AsyncShellCmd().execute(_shellCmd);
	// Log.i("exec", "1");
 }  
   

 class AsyncShellCmd extends AsyncTask<String, String, String>  {	     
    
     @Override
     protected String doInBackground(String... params) {
       Process p;
       StringBuffer output = new StringBuffer();
       try {
         p = Runtime.getRuntime().exec(params[0]);
         BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
         String line = "";
         while ((line = reader.readLine()) != null) {
            output.append(line + "\n");
            p.waitFor();
          //publishProgress(response); TODO       
         }         
        } catch (IOException e) {
         e.printStackTrace();
        } catch (InterruptedException e) {
         e.printStackTrace();
       }
       String response = output.toString();       
       return response;
     }
        
     /*
     @Override
     protected void onProgressUpdate(String... values) {
         super.onProgressUpdate(values);
         //TODO        
     }   
     */
     
     @Override
     protected void onPostExecute(String values) {    	  
       super.onPostExecute(values);       
       controls.pOnShellCommandExecuted(pascalObj, values);
     }          
  } //AsyncTask
 
}

