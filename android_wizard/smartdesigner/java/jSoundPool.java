
import java.io.IOException;

import android.app.Activity;
import android.content.Context;
import android.media.AudioManager;
import android.media.AudioAttributes;
import android.media.SoundPool;
import android.media.SoundPool.OnLoadCompleteListener;
import android.os.Environment;
import android.content.res.AssetFileDescriptor;

/*Draft java code by "Lazarus Android Module Wizard"*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

/* --- Created by ADiV Software 08/09/2020 --- */

/* The SoundPool class manages and plays audio resources for applications.
 * 
 * https://developer.android.com/reference/android/media/SoundPool
 * */

public class jSoundPool implements SoundPool.OnLoadCompleteListener {
	
	private long pascalObj = 0;           // Pascal Object
	private Controls controls  = null;    // Control Class for events
	private Context  context   = null;
	
    private SoundPool soundPool;
    
    public jSoundPool(Controls _ctrls, long _Self, int maxStreams) {
    	//super(_ctrls.activity);
	    pascalObj = _Self ;
		controls  = _ctrls;
		context   = _ctrls.activity;
		
		if (android.os.Build.VERSION.SDK_INT < 21) {
			soundPool = new SoundPool(maxStreams, AudioManager.STREAM_MUSIC, 0);
		} else  {
		  //[ifdef_api21up]
			AudioAttributes attributes = new AudioAttributes.Builder()
					.setUsage(AudioAttributes.USAGE_MEDIA)  //USAGE_ASSISTANCE_SONIFICATION
					.setContentType(AudioAttributes.CONTENT_TYPE_MUSIC) //CONTENT_TYPE_SPEECH  CONTENT_TYPE_SONIFICATION
					.build();
			
			soundPool = new SoundPool.Builder()
			    .setMaxStreams(maxStreams)
				.setAudioAttributes(attributes)
				.build();
	      //[endif_api21up]
		}						
		
        soundPool.setOnLoadCompleteListener(this);        
    }
    
    public int SoundLoad(String _path,  String _filename){
    	
    	  if( soundPool == null ) return 0;
		  
    	  // Priority not effect, set 1 for compatibility
    	  return soundPool.load(_path + "/" + _filename, 1);    	 
	}
    
    public int SoundLoad(String _path){
		 
		 if (soundPool == null) return 0;
		 
		 int soundId = 0;
		  
		 if (_path.indexOf("sdcard") >= 0){ //Environment.getExternalStorageDirectory().getPath()		 
			 String sdPath =Environment.getExternalStorageDirectory().getPath();		 
			 String newPath;     
			 int p1 = _path.indexOf("sdcard/", 0);
			 
			 if ( p1 >= 0) {
				 
			    int p2 = p1+6;			 
			    newPath = sdPath +  _path.substring(p2);
			    	  		                                    			      			    			       			              		   	  		   	  		  
		     } else {	    	 
		    	 String initChar = _path.substring(0,1);
		    	 
		    	 if (! initChar.equals("/")) 
		    		 newPath = sdPath + '/'+ _path;
		    	 else
		    		 newPath = sdPath + _path;		    	 		    	 		    	 	  		     
	     	 }
			 
			 // Priority not effect, set 1 for compatibility                              
			 soundId = soundPool.load(newPath, 1); //    "/sdcard/music/tarck1.mp3	               		              
	 		 
		 }else {
			 //Log.i("jMediaPlayer", "loadFromAssets: "+ _path);
			 AssetFileDescriptor afd;
			 
			 try {
			  afd = controls.activity.getAssets().openFd(_path);			 			  			 
			 } catch (IOException e1) {				 
				e1.printStackTrace();
				return 0;
			 }
			 
			 if( afd != null )
				 // Priority not effect, set 1 for compatibility
				 soundId = soundPool.load(afd, 1); //    "/sdcard/music/tarck1.mp3*/
		 }
		 		 		 
		 return soundId;
	  }
    
    public void SoundUnload(int soundId){
    	
    	if(soundPool == null) return;
    	                
        soundPool.unload(soundId);               
    }
    
    /* 
     * priority : Example: 1 has less priority than 10, 
     *            it will stop those with lower priority. 
     *            If you reach the maximum number of sounds allowed
     *            
     * loop     : -1 Infinite loop should call the soundStop function to stop the sound.
     *          : 0  Without loop
     *          : Any other non-zero value will cause the sound to repeat the specified 
     *            number of times, e.g. a value of 3 causes the sound to play a total of 4 times
     *            
     * rate     : The playback rate can also be changed
     *          :  1.0 causes the sound to play at its original
     *          :  The playback rate range is 0.5 to 2.0
     *          
     * return streamId of sound;
     * */
    public int SoundPlay(int soundId, float _leftVolume, float _rightVolume, int _priority, int _loop, float _rate){
    	
    	if(soundPool == null) return 0;
    	
    	float leftVolume = _leftVolume;
    	float rightVolume = _rightVolume;
    	float rate = _rate;
    	
    	if( leftVolume > 1) leftVolume = 1;
    	if( leftVolume < 0) leftVolume = 0;
    	
    	if( rightVolume > 1) rightVolume = 1;
    	if( rightVolume < 0) rightVolume = 0;
    	
    	if( rate > 2) rate = 2;
    	if( rate < 0.5f) rate = 0.5f;
    	    	    
    	return soundPool.play(soundId, leftVolume, rightVolume, _priority, _loop, rate);
    	
    }
    
    public void StreamSetVolume(int streamId, float _leftVolume, float _rightVolume){
    	if(soundPool == null) return;
    	
    	float leftVolume = _leftVolume;
    	float rightVolume = _rightVolume;
    	
    	if( leftVolume > 1) leftVolume = 1;
    	if( leftVolume < 0) leftVolume = 0;
    	
    	if( rightVolume > 1) rightVolume = 1;
    	if( rightVolume < 0) rightVolume = 0;
    	
    	soundPool.setVolume(streamId, leftVolume, rightVolume);    	
    }
    
    public void StreamSetPriority(int streamId, int _priority){
    	if(soundPool == null) return;
    	
    	soundPool.setPriority(streamId, _priority);    	
    }
    
    public void StreamSetLoop(int streamId, int _loop){
    	if(soundPool == null) return;
    	
    	soundPool.setLoop(streamId, _loop);    	
    }
    
    public void StreamSetRate(int streamId, float _rate){
    	if(soundPool == null) return;
    	
    	float rate = _rate;
    	    	
    	if( rate > 2) rate = 2;
    	if( rate < 0.5f) rate = 0.5f;
    	
    	soundPool.setRate(streamId, rate);    	
    }
    
    public void StreamPause(int streamId){
    	
    	if(soundPool == null) return;
    	
        soundPool.pause(streamId);
        
    }
    
    public void StreamResume(int streamId){
    	
    	if(soundPool == null) return;
    	
        soundPool.resume(streamId);
        
    }
    
    public void StreamStop(int streamId){
    	
    	if(soundPool == null) return;
    	
        soundPool.stop(streamId);
        
    }
    
    public void PauseAll(){
    	
    	if(soundPool == null) return;
    	
    	soundPool.autoPause();    	
    }
    
    public void ResumeAll(){
    	
    	if(soundPool == null) return;
    	
    	soundPool.autoResume();    	
    }

    @Override
    public void onLoadComplete(SoundPool sp, int soundId, int status) {
    	    	
    	controls.pOnSoundPoolLoadComplete(pascalObj, soundId, status);

    }
    
    public void jFree() {
	    //free local objects...
		if (soundPool != null)
			soundPool.release();
		
		soundPool = null;
    }

}