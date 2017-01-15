package com.example.apptrycode2;

import java.io.IOException;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.media.MediaPlayer.OnVideoSizeChangedListener;
import android.net.Uri;
import android.os.Environment;
import android.provider.Settings;

/*Draft java code by "Lazarus Android Module Wizard"*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//http://www.javatpoint.com/playing-audio-in-android-example
//http://www.learn-android-easily.com/2013/09/android-mediaplayer-example.html
//https://software.intel.com/en-us/forums/topic/277068
//http://www.streamhead.com/android-tutorial-sd-card/

//public class jMediaPlayer implements OnPreparedListener, OnVideoSizeChangedListener, OnCompletionListener, OnTimedTextListener { //API 16!
public class jMediaPlayer implements OnPreparedListener, OnVideoSizeChangedListener, OnCompletionListener  {  

	  private long pascalObj = 0;           // Pascal Object
	  private Controls controls  = null;    // Control Class for events
	  private Context  context   = null;
		
	  private MediaPlayer mplayer;
	  
	  public jMediaPlayer (Controls _ctrls, long _Self) {	    	     
	     //super(_ctrls.activity);
	     pascalObj = _Self ;
		 controls  = _ctrls;
		 context   = _ctrls.activity;
		 
		 this.mplayer = new MediaPlayer();		 				 
		 this.mplayer.setOnPreparedListener(this);
		 this.mplayer.setOnVideoSizeChangedListener(this);		 
		 this.mplayer.setOnCompletionListener(this);
		 /*
		 //when MediaPlayer start player we need to release it when music complete....
		 this.mplayer.setOnCompletionListener(new OnCompletionListener() {
		        public void onCompletion(MediaPlayer mp) {
		            mp.release();
		        };
		    });
		 //this.mplayer.setOnTimedTextListener(this); //need API 16		   		
		  */
	  }  
	  
	  public void jFree() {
	    //free local objects...
		mplayer.release();
	  	mplayer = null;
	  }
	      
	  public void DeselectTrack(int _index){
	  	this.mplayer.deselectTrack(_index);
	  }
	  
	  /*
	   * call the release method on your Media Player object to free the resources associated with the MediaPlayer
	   */
	  public void Release(){ 
	  	this.mplayer.release();
	  }
	  
	  public void Reset(){
	  	this.mplayer.reset();
	  }
	      
	  public void SetDataSource(String _path,  String _filename){
		  
		  if (this.mplayer != null) {
			  this.mplayer.reset();  //the object is like being just created....			  
		  }
		  else {this.mplayer = new MediaPlayer();}
		  
		  try {
			 this.mplayer.setDataSource(_path + "/" + _filename);
	      }	            
	      catch (IOException e) {
	         e.printStackTrace();
	      }		
		 
	  }
	  	  
	  public void SetDataSource(String _path){
		 
		 if (this.mplayer != null) { 

			 this.mplayer.reset();  //the object is like being just created....
			 /*
			  * Resets the MediaPlayer to its uninitialized state. After calling this method, 
	            we will have to initialize it again by setting the data source and calling prepare(). 
			  */
		 } else {this.mplayer = new MediaPlayer();}
		  
		 if (_path.indexOf("://") > 0) {
			  Uri uri0 = Uri.parse(_path);                //ex. "http://site.com/audio/audio.mp3"
			  try{                                        //    "file:///sdcard/localfile.mp3" 
			     this.mplayer.setDataSource(context, uri0);
			  }catch (IOException e){
				 e.printStackTrace();	
			  }
		 }else if (_path.indexOf("DEFAULT_RINGTONE_URI") >= 0){			 
			 //Log.i("jMediaPlayer", "DEFAULT_RINGTONE_URI");			 
	         try{ 
	              this.mplayer.setDataSource(context, Settings.System.DEFAULT_RINGTONE_URI);
	         }catch (IOException e){
	        	  //Log.i("jMediaPlayer", "RINGTONE ERROR");
	  	          e.printStackTrace();  	         
	         }	         
		 }else if (_path.indexOf("sdcard") >= 0){ //Environment.getExternalStorageDirectory().getPath()		 
			 String sdPath =Environment.getExternalStorageDirectory().getPath();		 
			 String newPath;     
			 int p1 = _path.indexOf("sdcard/", 0);		 
			 if ( p1 >= 0) {		  	 		 		   		   		   
			   int p2 = p1+6;			 
			   newPath = sdPath +  _path.substring(p2);						  			   
	  		    try{                                
			       this.mplayer.setDataSource(newPath);  //    "/sdcard/music/tarck1.mp3"
			    }catch (IOException e){
		           e.printStackTrace();	
	            }	           		   	  		   	  		   
		      } else {	    	 
		    	 String initChar = _path.substring(0,1);	    	 
		    	 if (! initChar.equals("/")) {newPath = sdPath + '/'+ _path;}
		    	 else {
		    		 newPath = sdPath + _path;
		    	 }		    	 		    	 
	  		     try{                                
		               this.mplayer.setDataSource(newPath);  //    "/sdcard/music/tarck1.mp3"
		 		 }catch (IOException e){
		 	            e.printStackTrace();	
		         }
	     	 }		 	
		 }else {
			 //Log.i("jMediaPlayer", "loadFromAssets: "+ _path);
			 AssetFileDescriptor afd;
			 try {
			 	afd = controls.activity.getAssets().openFd(_path);
			 	this.mplayer.setDataSource(afd.getFileDescriptor(),afd.getStartOffset(),afd.getLength());  
			 } catch (IOException e1) {
				e1.printStackTrace();
			 }            	     
		 }	 
	  }	    	
	    
	  //for files, it is OK to call prepare(), which blocks until MediaPlayer is ready for playback...
	  public void Prepare(){	 //prepares the player for playback synchronously.
	  	try {
	  		   this.mplayer.prepare();		
			} catch (IOException e) {
				e.printStackTrace();		
		    }
	  }
	  
	  //TODO:  prepareAsync()  
	  
	  public void Start(){	 //it starts or resumes the playback.
	  	 this.mplayer.start();
	  }
	  
	  /*
	   * Once in the Stopped state, playback cannot be started
	   * until prepare() or prepareAsync() are called to set the MediaPlayer object to the Prepared state again.
	   */
	  public void Stop(){	 //it stops the playback.
	  	 this.mplayer.stop();
	  }
	  
	  public void Pause(){	 //it pauses the playback.
	  	 this.mplayer.pause();
	  }
	  
	  public boolean IsPlaying(){	 //checks if media player is playing.
	  	return this.mplayer.isPlaying();
	  }
	  
	  public void SeekTo(int _millis){	 //seeks to specified time in miliseconds.
	  	this.mplayer.seekTo(_millis);	
	  }
	  
	  public void SetLooping(boolean _looping){	 //sets the player for looping or non-looping.
	  	this.mplayer.setLooping(_looping);
	  }
	  
	  public boolean IsLooping(){	 //checks if the player is looping or non-looping.
	  	return this.mplayer.isLooping();
	  }
	  
	  public void SelectTrack(int _index){	 //it selects a track for the specified index.
		  this.mplayer.selectTrack(_index);
	  }
	  
	  public int GetCurrentPosition(){	 //returns the current playback position.
	  	return this.mplayer.getCurrentPosition();
	  }

	  public int GetDuration(){	 //returns duration of the file.
	  	return this.mplayer.getDuration();
	  }
	  
	  /*
	    setVolume takes a scalar float value between 0 and 1 for both the left and right channels (where 0 is silent and 1 is
	    maximum volume) ex. mediaPlayer.setVolume(1f, 0.5f);
	  */
	  
	  public void SetVolume(float _leftVolume,float _rightVolume){
	  	 this.mplayer.setVolume(_leftVolume, _rightVolume);
	  }
	 
	  
	 //called onsurfaceCreated!
	  public void SetDisplay(android.view.SurfaceHolder _surfaceHolder) {
		 this.mplayer.setAudioStreamType (AudioManager.STREAM_MUSIC);
		 this.mplayer.setDisplay(_surfaceHolder);		      		  				 
	  }
	  
	  //http://alvinalexander.com/java/jwarehouse/android-examples/samples/android-8/ApiDemos/src/com/example/android/apis/media/MediaPlayerDemo_Video.java.shtml
	 
	  @Override
	  /*.*/public void onPrepared(MediaPlayer mediaplayer) {		    
		    controls.pOnMediaPlayerPrepared(pascalObj, mplayer.getVideoWidth(), mplayer.getVideoHeight());
	   }
	  
	  @Override
	  /*.*/public void onVideoSizeChanged(MediaPlayer mp, int width, int height) { 		
			controls.pOnMediaPlayerVideoSizeChanged(pascalObj, width, height);
	  }
	  
	  @Override
	  /*.*/public void onCompletion(MediaPlayer arg0) {
		    controls.pOnMediaPlayerCompletion(pascalObj);
	  }
	  
	  /*
  	 @Override
	  public void onTimedText(MediaPlayer arg0, TimedText timedText) {	//need API 16
  		   controls.pOnMediaPlayerTimedText(pascalObj, timedText.getText());		
	  }	*/
  	 	  
	  public int GetVideoWidth() {
		   return mplayer.getVideoWidth();
	  }
	  
	  public int GetVideoHeight() {
		  return mplayer.getVideoHeight();
	  }
	  
  	  public void SetScreenOnWhilePlaying(boolean _value) {
		  mplayer.setScreenOnWhilePlaying(_value);
  	  }	  		   	    	  
  	    	
  	  public void SetAudioStreamType (int _audioStreamType) { 
  		  if (_audioStreamType < 6)
		     mplayer.setAudioStreamType(_audioStreamType);
  	  }	 
} 
