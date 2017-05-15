package org.lamw.appspeechtotextdemo1;

import java.util.ArrayList;
import java.util.Locale;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.speech.RecognizerIntent;

/*Draft java code by "Lazarus Android Module Wizard" [5/12/2017 22:18:42]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref. https://stacktips.com/tutorials/android/speech-to-text-in-android
public class jSpeechToText /*extends ...*/ {
 
   private long pascalObj = 0;        //Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private Context  context   = null;
   
   private int SPEECH_T0_TEXT_REQUEST_CODE = 1234;
   
   private String mExtraPrompt= "Speech a message to write...";
   
   private Locale mLocale = Locale.getDefault();//Locale.US; 
 
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jSpeechToText(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
 
   public void SetPromptMessage(String _promptMessage) {
	   mExtraPrompt = _promptMessage;
   }
   
   public void SpeakIn() {	   
       Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
       intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
       intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, mLocale );
       intent.putExtra(RecognizerIntent.EXTRA_PROMPT, mExtraPrompt);
       try {
    	   controls.activity.startActivityForResult(intent, SPEECH_T0_TEXT_REQUEST_CODE);
       } catch (ActivityNotFoundException a) {
          //
       }
   }
         
   public void SpeakIn(String _promptMessage) {	   
	   mExtraPrompt = _promptMessage;	
	   SpeakIn();
   }

   public void SetRequestCode(int _requestCode) {
	   SPEECH_T0_TEXT_REQUEST_CODE = _requestCode;
   }
   
   public int GetRequestCode() {
	   return SPEECH_T0_TEXT_REQUEST_CODE;
   }
   
   public String SpeakOut(Intent _intentData) {	   
	   ArrayList<String> result = _intentData.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
	   return  result.get(0);
   }
   
   
   public void SetLanguage(int _language) {	   
	   switch(_language) {
	      case 0: mLocale = Locale.getDefault(); break;
	      case 1: mLocale = Locale.CANADA; break;
	      case 2: mLocale = Locale.CANADA_FRENCH; break;
	      case 3: mLocale = Locale.CHINESE; break;
	      case 4: mLocale = Locale.ENGLISH; break;
	      case 5: mLocale = Locale.FRENCH; break;
	      case 6: mLocale = Locale.GERMAN; break;
	      case 7: mLocale = Locale.ITALIAN; break;
	      case 8: mLocale = Locale.JAPANESE; break;
	      case 9: mLocale = Locale.KOREAN; break;	      
	      case 10: mLocale = Locale.SIMPLIFIED_CHINESE; break;
	      case 11: mLocale = Locale.TAIWAN; break;
	      case 12:mLocale = Locale.TRADITIONAL_CHINESE; break;
	      case 13: mLocale = Locale.UK; break;
	      case 14: mLocale = Locale.US; break;	      
	   }	     
   }
   
}
