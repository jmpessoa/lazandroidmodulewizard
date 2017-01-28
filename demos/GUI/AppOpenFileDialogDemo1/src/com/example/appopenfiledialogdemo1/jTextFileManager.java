package com.example.appopenfiledialogdemo1;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Environment;

/*Draft java code by "Lazarus Android Module Wizard"*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jTextFileManager /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    
    private ClipboardManager mClipBoard = null;
    private ClipData mClipData = null;
    
    private Intent intent = null;
    
    //Warning: please, preferentially init your news params names with "_", ex: int _flag, String _hello ...

    public jTextFileManager(Controls _ctrls, long _Self) { //Add more here new "_xxx" params if needed!
       //super(contrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;      
       mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);       
       intent = new Intent();
       intent.setAction(Intent.ACTION_SEND);
       intent.setType("text/plain");      
    }

    public void jFree() {
      //free local objects...
    	mClipBoard = null;
    	intent = null;
    }
    
    
    public void CopyToClipboard(String _text) {
    	mClipData = ClipData.newPlainText("text", _text);
        mClipBoard.setPrimaryClip(mClipData);
    }
       
    public String PasteFromClipboard() {
        ClipData cdata = mClipBoard.getPrimaryClip();
        ClipData.Item item = cdata.getItemAt(0);
        String txt = item.getText().toString();
        return txt;
    }    

   //write others [public] methods code here......
   //Warning: please, preferentially init your news params names with "_", ex: int _flag, String _hello ...
    
   //http://thedevelopersinfo.com/2009/11/26/using-filesystem-in-android/
   //http://tausiq.wordpress.com/2012/06/16/readwrite-text-filedata-in-android-example-code/
   //if you want to save/preserve the old data then you need to open the file in MODE_APPEND, not MODE_PRIVATE
    
   //***if you want to get your file you should look at: data/data/your_package/files/your_file_name !!!!
   public void SaveToFile(String _txtContent, String _filename) {	  	 
     try {
         OutputStreamWriter outputStreamWriter = new OutputStreamWriter(context.openFileOutput(_filename, Context.MODE_PRIVATE));
         //outputStreamWriter.write("_header");
         outputStreamWriter.write(_txtContent);
         //outputStreamWriter.write("_footer");
         outputStreamWriter.close();
     }
     catch (IOException e) {
        // Log.i("jTextFileManager", "SaveToFile failed: " + e.toString());
     }
   }

   public void SaveToFile(String _txtContent, String _path, String _filename){
	     FileWriter fWriter;     
	     try{ // Environment.getExternalStorageDirectory().getPath()
	          fWriter = new FileWriter(_path +"/"+ _filename);
	          fWriter.write(_txtContent);
	          fWriter.flush();
	          fWriter.close();
	      }catch(Exception e){
	          e.printStackTrace();
	      }
	   }   
   public String LoadFromFile(String _filename) {

     String retStr = "";

     try {
         InputStream inputStream = context.openFileInput(_filename);

         if ( inputStream != null ) {
             InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
             BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
             String receiveString = "";
             StringBuilder stringBuilder = new StringBuilder();

             while ( (receiveString = bufferedReader.readLine()) != null ) {
                 stringBuilder.append(receiveString);
             }

             inputStream.close();
             retStr = stringBuilder.toString();
         }
     }
     catch (IOException e) {
        // Log.i("jTextFileManager", "LoadFromFile error: " + e.toString());
     }

     return retStr;
   }
     
   public String LoadFromFile(String _path, String _filename) {
	     char buf[] = new char[512];
	     FileReader rdr;
	     String contents = "";  //new File(Environment.getExternalStorageDirectory(), "alert.txt");
	     try {                  // Environment.getExternalStorageDirectory().getPath() --> /sdcard
	         rdr = new FileReader(_path+"/"+_filename);
	         int s = rdr.read(buf);
	         for(int k = 0; k < s; k++){
	             contents+=buf[k];
	         }
	         
	         rdr.close();
	     } catch (Exception e) {
	         e.printStackTrace();
	     }
	     return contents;
	   }
   
   //http://manojprasaddevelopers.blogspot.com.br/search/label/Write%20and%20ReadFile
      
   //http://www.coderzheaven.com/2012/01/29/saving-textfile-to-sdcard-in-android/
   public void SaveToSdCard(String _txtContent, String _filename){
     FileWriter fWriter;     
     try{ // Environment.getExternalStorageDirectory().getPath()
          fWriter = new FileWriter(Environment.getExternalStorageDirectory().getPath() +"/"+ _filename);
          fWriter.write(_txtContent);
          fWriter.flush();
          fWriter.close();
      }catch(Exception e){
          e.printStackTrace();
      }
   }
   
   public String LoadFromSdCard(String _filename){
     char buf[] = new char[512];
     FileReader rdr;
     String contents = "";  //new File(Environment.getExternalStorageDirectory(), "alert.txt");
     try {  // Environment.getExternalStorageDirectory().getPath() --> /sdcard
         rdr = new FileReader(Environment.getExternalStorageDirectory().getPath()+"/"+_filename);
         int s = rdr.read(buf);
         for(int k = 0; k < s; k++){
             contents+=buf[k];
         }
         
         rdr.close();
     } catch (Exception e) {
         e.printStackTrace();
     }
     return contents;
   }
   
   //https://xjaphx.wordpress.com/2011/10/02/store-and-use-files-in-assets/    
   public String LoadFromAssets(String _filename) {
	   String str;
       // load text
       try {
    	   //Log.i("loadFromAssets", "name: "+_filename);
           // get input stream for text
           InputStream is = controls.activity.getAssets().open(_filename);
           // check size
           int size = is.available();
           // create buffer for IO
           byte[] buffer = new byte[size];
           // get data to buffer
           is.read(buffer);
           // close stream
           is.close();
           // set result to TextView
           str = new String(buffer);
           //Log.i("loadFromAssets", ":: "+ str);
           return str.toString();
       }
       catch (IOException ex) {
    	   //Log.i("loadFromAssets", "error!");
           return "";
       }       
   }
   
   public void CopyContentToClipboard(String _filename) {
   	 String txt = LoadFromFile(_filename);
   	 mClipData = ClipData.newPlainText("text", txt);
     mClipBoard.setPrimaryClip(mClipData);
   }
   
   public void PasteContentFromClipboard(String _filename) {
      ClipData cdata = mClipBoard.getPrimaryClip();
      ClipData.Item item = cdata.getItemAt(0);
      String txt = item.getText().toString();
      SaveToFile(txt, _filename);
   }
   
   public String LoadFromByteArray(byte[] _byteArray) {  //TODO Pascal
	   return (new String(_byteArray));   
   }      
}

