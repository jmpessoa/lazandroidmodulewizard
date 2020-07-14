package org.lamw.appcustomspeechtotextdemo1;

import java.util.ArrayList;
import java.util.Locale;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;

/*Draft java code by "Lazarus Android Module Wizard" [7/13/2020 15:22:49]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref. https://stacktips.com/tutorials/android/speech-to-text-in-android
//ref. https://www.simplifiedcoding.net/android-speech-to-text-tutorial/

public class jCustomSpeechToText /*extends ...*/ {
 
   private long pascalObj = 0;        //Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private Context  context   = null;

   private Locale mLocale = Locale.getDefault();//Locale.US;

    SpeechRecognizer mSpeechRecognizer;
    Intent mSpeechRecognizerIntent;
    boolean mListening = false;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public jCustomSpeechToText (Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
           //super(_ctrls.activity);
           context   = _ctrls.activity;
           pascalObj = _Self;
           controls  = _ctrls;

           mSpeechRecognizerIntent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
           mSpeechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
           mSpeechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, mLocale);

           mSpeechRecognizer = SpeechRecognizer.createSpeechRecognizer(controls.activity);
           mSpeechRecognizer.setRecognitionListener(new RecognitionListener() {
               @Override
               public void onReadyForSpeech(Bundle bundle) {

               }

               @Override
               public void onBeginningOfSpeech() {
                   controls.pOnBeginOfSpeech(pascalObj);
               }

               @Override
               public void onRmsChanged(float v) {

               }

               @Override
               public void onBufferReceived(byte[] bytes) {
                   controls.pOnSpeechBufferReceived(pascalObj, bytes);
               }

               @Override
               public void onEndOfSpeech() {
                   controls.pOnEndOfSpeech(pascalObj);
               }

               @Override
               public void onError(int i) {

               }

               @Override
               public void onResults(Bundle bundle) {
                   //getting all the matches
                   ArrayList<String> matches = bundle
                           .getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION);
                   //displaying the first match
                   if (matches != null) {
                       String s = matches.get(0);
                       controls.pOnSpeechResults(pascalObj, s);
                   }
                   else
                       controls.pOnSpeechResults(pascalObj, "Sorry.. Fail to Recognizer!");

               }

               @Override
               public void onPartialResults(Bundle bundle) {

               }

               @Override
               public void onEvent(int i, Bundle bundle) {

               }
           });
   }

   public void jFree() {
      //free local objects...
       if (mSpeechRecognizer != null)
           mSpeechRecognizer.stopListening();
       //mSpeechRecognizer = null;
       //mSpeechRecognizerIntent = null;
   }

 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

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
	      case 12: mLocale = Locale.TRADITIONAL_CHINESE; break;
	      case 13: mLocale = Locale.UK; break;
	      case 14: mLocale = Locale.US; break;	      
	   }	     
   }

   public void StartListening() {

       if(mListening)  return;

       if (mSpeechRecognizer != null) {
           mListening = true;
           mSpeechRecognizer.stopListening();
           mSpeechRecognizer.startListening(mSpeechRecognizerIntent);
       }

   }

   public void StopListening() {
       mSpeechRecognizer.stopListening();
       mListening = false;
   }

}

