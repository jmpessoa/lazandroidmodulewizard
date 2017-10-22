package org.lamw.apptexttospeechdemo1;

import android.content.Context;
import android.media.MediaPlayer;
import android.net.Uri;
import android.speech.tts.TextToSpeech;
import android.util.Log;

import java.io.IOException;
import java.util.Locale;

/** TTSManager
 * Created by Nilanchala
 * http://www.stacktips.com
 * http://stacktips.com/tutorials/android/android-texttospeech-example
 */

class TTSManager {

    private TextToSpeech mTts = null;
    private boolean isLoaded = false;
    private Locale mLocale = Locale.getDefault();//Locale.US; 

    public void init(Context context) {
        try {
            mTts = new TextToSpeech(context, onInitListener);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private TextToSpeech.OnInitListener onInitListener = new TextToSpeech.OnInitListener() {
        @Override
        public void onInit(int status) {        	
                if (status == TextToSpeech.SUCCESS) {                	
                    int result = mTts.setLanguage(mLocale);
                    isLoaded = true;
                    if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                        Log.e("error", "This Language is not supported");
                    }                                        
                } else {
                    Log.e("error", "Initialization Failed!");
                }
        }
    };

    public void shutDown() {
        mTts.shutdown();
    }

    public void addQueue(String text) {
        if (isLoaded)
            mTts.speak(text, TextToSpeech.QUEUE_ADD, null);
        else
            Log.e("error", "TTS Not Initialized");
    }

    public void initQueue(String text) {

        if (isLoaded)
            mTts.speak(text, TextToSpeech.QUEUE_FLUSH, null);
        else
            Log.e("error", "TTS Not Initialized");
    }
    
    public void setLanguage(Locale localeLang) {
    	mLocale = localeLang;
    }
}

/*Draft java code by "Lazarus Android Module Wizard" [3/27/2017 22:48:22]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

public class jTextToSpeech /*extends ...*/ {
 
   private long pascalObj = 0;        //Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private Context  context   = null;
   
   TTSManager ttsManager = null;
 
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jTextToSpeech(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      
      ttsManager = new TTSManager();
      ttsManager.init(context);
      
   }
 
   public void jFree() {
     //free local objects...
	  ttsManager.shutDown();
	  ttsManager = null;
   }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   
   public void Speak(String _text) {
       ttsManager.initQueue(_text);
   }
 
   //adding it to queue
   public void SpeakAdd(String _text) {
       ttsManager.addQueue(_text);
   }
   
   public void SetLanguage(int _language) {
	   
	   switch(_language) {
	      case 0: ttsManager.setLanguage(Locale.getDefault()); break;
	      case 1: ttsManager.setLanguage(Locale.CANADA); break;
	      case 2: ttsManager.setLanguage(Locale.CANADA_FRENCH); break;
	      case 3: ttsManager.setLanguage(Locale.CHINESE); break;
	      case 4: ttsManager.setLanguage(Locale.ENGLISH); break;
	      case 5: ttsManager.setLanguage(Locale.FRENCH); break;
	      case 6: ttsManager.setLanguage(Locale.GERMAN); break;
	      case 7: ttsManager.setLanguage(Locale.ITALIAN); break;
	      case 8: ttsManager.setLanguage(Locale.JAPANESE); break;
	      case 9: ttsManager.setLanguage(Locale.KOREAN); break;	      
	      case 10: ttsManager.setLanguage(Locale.SIMPLIFIED_CHINESE); break;
	      case 11: ttsManager.setLanguage(Locale.TAIWAN); break;
	      case 12: ttsManager.setLanguage(Locale.TRADITIONAL_CHINESE); break;
	      case 13: ttsManager.setLanguage(Locale.UK); break;
	      case 14: ttsManager.setLanguage(Locale.US); break;	     
	   }
	     
   }
   
   //https://stackoverflow.com/questions/33118121/android-tts-for-multiple-languages
   public void SpeakOnline(String _text, String _language) {

	    final String text = _text;
	    final String lan = _language;
	    
	    new Thread(new Runnable() {
	        @Override
	        public void run() {
	            String Url = "https://translate.google.com/translate_tts?ie=UTF-8";
	            String pronouce = "&q=" + text.replaceAll(" ", "%20");
	            String language = "&tl=" + lan;
	            String web = "&client=tw-ob";

	            String fullUrl = Url + pronouce + language + web;

	            Uri uri = Uri.parse(fullUrl);
	            MediaPlayer mediaPlayer = new MediaPlayer();
	            try {
	                mediaPlayer.setDataSource(controls.activity,uri);
	                mediaPlayer.prepare();
	                mediaPlayer.start();
	            } catch (IOException e) {
	                e.printStackTrace();
	                //Log.i(TAG,"error");
	            }
	        }
	    }).start();
	}
   
}
