package com.example.appmediarecorderdemo1;

import java.io.IOException;

import android.content.Context;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.util.Log;

/*Draft java code by "Lazarus Android Module Wizard" [6/29/2016 0:25:13]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//requeriments:
//<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
//<uses-permission android:name="android.permission.RECORD_AUDIO" /> 

//ref. http://www.tutorialspoint.com/android/android_audio_capture.htm
public class jMediaRecorder /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
 
   private MediaRecorder myAudioRecorder;
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jMediaRecorder(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;      
      myAudioRecorder = new MediaRecorder(); 
   }
 
   public void jFree() {
     //free local objects...	 
	 myAudioRecorder.release(); //This method should be called when the recorder instance is needed.	   
	 myAudioRecorder  = null;
   }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   
   //This method specifies the source of audio to be recorded   
   public void SetAudioSource(int _audioSource) {	  
		  if (this.myAudioRecorder != null) {		
			  this.myAudioRecorder.reset();  //the object is like being just created....			  
		  }
		  else {this.myAudioRecorder = new MediaRecorder();}	   	     
          myAudioRecorder.setAudioSource(_audioSource); //MediaRecorder.AudioSource.MIC       
       /*
       MediaRecorder.AudioSource.DEFAULT; //0
       MediaRecorder.AudioSource.MIC; //1
       MediaRecorder.AudioSource.VOICE_UPLINK; //2
       MediaRecorder.AudioSource.VOICE_DOWNLINK; //3
       MediaRecorder.AudioSource.VOICE_CALL; //4                      
       MediaRecorder.AudioSource.VOICE_RECOGNITION; //6       
       MediaRecorder.AudioSource.CAMCORDER; //5
       MediaRecorder.AudioSource.VOICE_COMMUNICATION; //7       
       */       
   }
   
   //This method specifies the source of video to be recorded
   public void SetVideoSource(int  _videoSource){
	   
		  if (this.myAudioRecorder != null) {
			  this.myAudioRecorder.stop();
			  this.myAudioRecorder.reset();  //the object is like being just created....			  
		  }
		  else {this.myAudioRecorder = new MediaRecorder();}
		  
	      myAudioRecorder.setVideoSource(_videoSource); //MediaRecorder.AudioSource.CAMCORDER
   }
  
   //This method specifies the audio format in which audio to be stored
   public void SetOutputFormat(int  _outputFormat) { 
        myAudioRecorder.setOutputFormat(_outputFormat); //MediaRecorder.OutputFormat.THREE_GPP       
        /*
        MediaRecorder.OutputFormat.DEFAULT; // 0
        MediaRecorder.OutputFormat.THREE_GPP; //1
        MediaRecorder.OutputFormat.MPEG_4; //2        
        MediaRecorder.OutputFormat.AMR_NB; //3
        MediaRecorder.OutputFormat.AMR_WB; //4
        MediaRecorder.OutputFormat.AAC_ADTS; //6       
        */
   }
 
   //This method specifies the audio encoder to be used   
   public void SetAudioEncoder(int _outputEncoderFormat) {
      myAudioRecorder.setAudioEncoder(_outputEncoderFormat); //MediaRecorder.OutputFormat.AMR_NB
   }

   //This method configures the path to the file into which the recorded audio is to be stored
   //outputFile = Environment.getExternalStorageDirectory().getAbsolutePath() + "/recording.3gp";
   public void SetOutputFile(String _fullPathOutputFilename) {
       myAudioRecorder.setOutputFile(_fullPathOutputFilename);
   }
   
   public void SetOutputFile(String _path, String _outputFilename) {
       myAudioRecorder.setOutputFile(_path+"/" +_outputFilename);
   }
   
   //for files, it is OK to call prepare() ...   
    public void Prepare(){
      try {
		myAudioRecorder.prepare();
	} catch (IllegalStateException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
   }
   
   public void Start() {
	  //this.Prepare(); 
      myAudioRecorder.start();
   }
   
   //This method stops the recording process.
   public void Stop() {
     myAudioRecorder.stop();
   }
           
}
