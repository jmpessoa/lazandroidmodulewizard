package com.example.appintentdemo1;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.provider.ContactsContract.CommonDataKinds.Email;
import android.provider.ContactsContract.CommonDataKinds.Phone;
import android.provider.MediaStore;
import android.provider.Settings;

/*Draft java code by "Lazarus Android Module Wizard" [1/18/2015 3:49:46]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jIntentManager  {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   
   private Intent mIntent;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jIntentManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;      
      mIntent = new Intent();
   }
 
   public void jFree() {
     //free local objects...
	  mIntent = null;
   }
 
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
         
   public Intent GetIntent() {	 
	 return mIntent;
   }
   
   public Intent GetActivityStartedIntent() {
     return controls.activity.getIntent();   //Return the intent that started this activity. 
   }
   
/*http://courses.coreservlets.com/Course-Materials/pdf/android/Android-Intents-2.pdf
   Java (original Activity)
   String address ="loan://coreservlets.com/calc?loanAmount=xxx";
   Uri uri = Uri.parse(address);
   Intent intent = new Intent(Intent.ACTION_VIEW, uri);
   startActivity(activityIntent);
  Java (new Activity - can be different project)
  Uri uri = getIntent().getData();
  String loanAmountString = uri.getQueryParameter("loanAmount");
  //Convert String to double, handle bad data   
 */
     
/*
 * Intents Starting a new Activity Dial a number 
 *    Intent intent = new Intent (Intent.ACTION_DIAL, Uri.parse("tel:93675359")); 
 *    startActivity(intent);       
 * Launch a website 
 * Intent intent = new Intent (Intent.ACTION_VIEW, Uri.parse("http://codeandroid.org")); 
 *   startActivity(intent);   
 */
      
   public void SetAction(String _intentAction) {	                                              
	  mIntent.setAction(_intentAction); //
   }
      
   //This method automatically clears any data that was previously set (for example by setData(Uri)). 
   public void SetMimeType(String _mimeType) {
	  mIntent.setType(_mimeType);  //"image/*";
   }

/*http://courses.coreservlets.com/Course-Materials/pdf/android/Android-Intents-2.pdf
Sending Data: Extras vs. URI Parameters
>>Extras Bundle
.Pros
    Can send data of different types.
    No parsing required in Activity that receives the data.
.Cons
   More complex for originating Activity
   Requires parsing in originating Activity if values come from EditText

>>URI parameters
.Pros
   Simpler for originating Activity, especially if EditText used
   More consistent with URI usage
.Cons
   Can send Strings only
   Requires parsing in receiving Activity
*/  
  
   /*
   If the action is performed on some data, then one more Intent-attribute is specified - data. 
   Inside it we can specify any object we need: user in the address book, map coordinates, phone number etc. 
   That is action specifies what to do and data - with what to do it.
   */
     
   /*
    * Set the data this intent is operating on. 
    * This method automatically clears any type that was previously set by setType(String) 
    * or setTypeAndNormalize(String). Note: scheme matching in the Android framework is case-sensitive, 
    * unlike the formal RFC. As a result, you should always write your Uri with a lower case scheme, 
    * or use normalizeScheme() or setDataAndNormalize(Uri) to ensure that the scheme is converted to lower case.
    */
   
   public void SetDataUriAsString(String _uriAsString) { //Uri.parse(fileUrl) - just Strings!
	   
	   mIntent.setData(Uri.parse(_uriAsString));  //just Strings!
	   /*
	    * Parameters
             data  The Uri of the data this intent is now targeting. 
          Returns
             Returns the same Intent object, for chaining multiple calls into a single statement.
	    */
   }
   
   public void StartActivityForResult(int _requestCode) {
	   controls.activity.startActivityForResult(mIntent,_requestCode);
	   // //startActivityForResult(photoPickerIntent, SELECT_PHOTO);
   }
      
   /*
    * String url = "http://www.vogella.com";
      Intent i = new Intent(Intent.ACTION_VIEW);
      i.setData(Uri.parse(url));
      startActivity(i); 
   */
      
   public void StartActivity() {
	   //intent.putExtras .... etc
	  controls.activity.startActivity(mIntent);
   }
   
   public void StartActivity(String _chooserTitle) {	  
	   controls.activity.startActivity(Intent.createChooser(mIntent, _chooserTitle));
   }
   
   public void StartActivityForResult(int _requestCode, String _chooserTitle) {	  
	   controls.activity.startActivityForResult(Intent.createChooser(mIntent, _chooserTitle),_requestCode);
   }
            
   /*
    * The _dataName must include a package prefix, 
    * for example the app com.android.contacts 
    * would use names like "com.android.contacts.ShowAll".
    */
   
   /*
    * Intents Broadcast Intents 
    * Intent intent = new Intent("org.codeandroid.intentstest.TestBroadcastReceiver"); 
    * sendBroadcast(intent);
    */
   
   public void SendBroadcast(){    //This call is asynchronous; it returns immediately    	               
      controls.activity.sendBroadcast(mIntent); //The Intent to broadcast; all receivers matching this Intent will receive the broadcast.       
   }
   
   public String GetAction(Intent _intent) {	 
      return _intent.getAction();
   }
      
   public boolean HasExtra(Intent _intent, String _dataName) {
	  return _intent.hasExtra(_dataName);
   }
   
   public void PutExtraBundle(Bundle _bundleExtra) {
	  mIntent.putExtras(_bundleExtra);
   }
   
   public Bundle GetExtraBundle(Intent _intent) {  //the map of all extras previously added with putExtra(), or null if none have been added. 
	   return _intent.getExtras();
   }
     
   public double[] GetExtraDoubleArray(Intent _intent, String _dataName) {
       return _intent.getDoubleArrayExtra(_dataName);
   }
      
   /*
    * The _dataName must include a package prefix, 
    * for example the app com.android.contacts 
    * would use names like "com.android.contacts.ShowAll".
    */
   
   public void PutExtraDoubleArray(String _dataName, double[] _values) {
	  mIntent.putExtra(_dataName, _values);
   }
   
   public double GetExtraDouble(Intent _intent, String _dataName) {
	  return _intent.getDoubleExtra(_dataName, 0);//defaultValue
   }
   
   public void PutExtraDouble(String _dataName, double _value) {
	   mIntent.putExtra(_dataName, _value);
   }
   
   public float[] GetExtraFloatArray(Intent _intent, String _dataName) {
	   return _intent.getFloatArrayExtra(_dataName);
   }
   
   public void PutExtraFloatArray(String _dataName, float[] _values) {
	   mIntent.putExtra(_dataName, _values);
   }
   
   public float GetExtraFloat(Intent _intent, String _dataName) { 
	   return _intent.getFloatExtra(_dataName, 0);
   }
   
   public void PutExtraFloat(String _dataName, float _value) {
	   mIntent.putExtra(_dataName, _value);
   }
   
   public int[] GetExtraIntArray(Intent _intent, String _dataName) {
	   return _intent.getIntArrayExtra(_dataName);
   }
   
   public void PutExtraIntArray(String _dataName, int[] _values) {
	  mIntent.putExtra(_dataName, _values);
   }
   
   public int GetExtraInt(Intent _intent, String _dataName) {
	  return _intent.getIntExtra(_dataName, 0);
   }
  
   public void PutExtraInt(String _dataName, int _value) {
	  mIntent.putExtra(_dataName, _value);
   }
   
   public String[] GetExtraStringArray(Intent _intent, String _dataName) {	  
	  return _intent.getStringArrayExtra(_dataName);
   }
         
   public void PutExtraStringArray(String _dataName, String[] _values) {
	  mIntent.putExtra(_dataName, _values);
   }
   
   public String GetExtraString(Intent _intent, String _dataName) {
	  return _intent.getStringExtra(_dataName);
   }
   
   public void PutExtraString(String _dataName, String _value) {
	  mIntent.putExtra(_dataName, _value);
   }
            
   public void SetDataUri(Uri _dataUri) { //Uri.parse(fileUrl) - just Strings!
		  //final Uri uriContact = ContactsContract.Contacts.CONTENT_URI;
		  //android.provider.ContactsContract.Contacts.CONTENT_URI
		   mIntent.setData(_dataUri);  //just Strings!
   }
	   
   public Uri GetDataUri(Intent _intent) {
	  return _intent.getData(); //name of data ...
   }
 
   public String GetDataUriAsString(Intent _intent) { //The same as getData(), but returns the URI as an encoded String.	   
 	  return _intent.getDataString();               //inverse: Uri.parse(...) creates a Uri which parses the given encoded URI string.
   }

   /*OnResult ...
    * Uri contactUri = intent.getData();
      You can also fetch the selected Contact name from intent extras.
      String contactName = intent.getStringExtra("android.intent.extra.shortcut.NAME");
   */ 
          
   /*
    * For example: you have a share picture option in your application.
      You define an intent like this:
      Intent picMessageIntent = new Intent(android.content.Intent.ACTION_SEND);
      picMessageIntent.setType("image/jpeg");

    File downloadedPic =  new File(
    Environment.getExternalStoragePublicDirectory(
    Environment.DIRECTORY_DOWNLOADS),
    "q.jpeg");
    picMessageIntent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(downloadedPic));
    Than when you call:
    startActivity(picMessageIntent);  
    all applications on your phone capable of getting this picture will be listed.    
    */
      
   public void PutExtraFile(String _environmentDirectoryPath, String _fileName) { //Environment.DIRECTORY_DOWNLOADS
      mIntent.putExtra(Intent.EXTRA_STREAM, Uri.parse("file://"+_environmentDirectoryPath+"/"+ _fileName)); //android.intent.extra.STREAM
   }
      
   public void PutExtraMailSubject(String  _mailSubject) {
	   mIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, _mailSubject);
   }
   
   public void PutExtraMailBody(String _mailBody) {	  
	   mIntent.putExtra(android.content.Intent.EXTRA_TEXT, _mailBody);
   }
      
   public void PutExtraMailCCs(String[] _mailCCs) {	  
	   mIntent.putExtra(android.content.Intent.EXTRA_CC, _mailCCs);
   }
       
   public void PutExtraMailBCCs(String[] _mailBCCs) {	  
	   mIntent.putExtra(android.content.Intent.EXTRA_BCC, _mailBCCs);
   }
   
   public void PutExtraMailTos(String[]  _mailTos) {	  
	   mIntent.putExtra(android.content.Intent.EXTRA_EMAIL, _mailTos);
   }
   
   public void PutExtraPhoneNumbers(String[]  _callPhoneNumbers) {	  
	   mIntent.putExtra(android.content.Intent.EXTRA_PHONE_NUMBER, _callPhoneNumbers); //used with Action_Call	   	   
   }
   
   
   public Uri GetContactsContentUri(){
	  return ContactsContract.Contacts.CONTENT_URI;
	  /*
	   * * This will display a list of all the contacts in the device to pick from.
      In onActivityResult, you can fetch the selected Contact URI from the intent.
	   */
   }

   /*
	final Uri uriContact = ContactsContract.Contacts.CONTENT_URI;
	Intent intentPickContact = new Intent(Intent.ACTION_PICK, uriContact);
   */
   
   public Uri GetContactsPhoneUri(){
      return ContactsContract.CommonDataKinds.Phone.CONTENT_URI;
      //If you need to pick from only contacts with a phone number,
   }
   
   public Uri GetAudioExternContentUri(){
      return android.provider.MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
   }
   
   public Uri GetVideoExternContentUri(){
	  return android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
   }
   
   public Uri ParseUri(String _uriAsString) {	   	   
	  return Uri.parse(_uriAsString);
   }
   
   /*
    * The caller may pass an extra EXTRA_OUTPUT to control where this image will be written. 
    * If the EXTRA_OUTPUT is not present, then a small sized image is returned as a 
    * Bitmap object in the extra field. This is useful for applications that only need a small image. 
    */
   public String GetActionViewAsString(){  
     return "android.intent.action.VIEW";
   }	   
      
   public String GetActionPickAsString() {
	   return "android.intent.action.PICK";
   }  	   
   
   public String GetActionSendtoAsString() {
      return "android.intent.action.SENDTO";
   }	   
   
   public String GetActionSendAsString() {
	   return "android.intent.action.SEND";
   }
   
   public String GetActionEditAsString() {
      return "android.intent.action.EDIT";
   }
   
   public String GetActionDialAsString() {
      return "android.intent.action.DIAL";
   }	   
   
   public String GetActionCallButtonAsString() {
	  //String s =  Intent.ACTION_CALL_BUTTON; 
      return "android.intent.action.CALL_BUTTON";
   }	   
   
      
   public void SetAction(int  _intentAction) {	 
	  switch(_intentAction) { 
	    case 0: mIntent.setAction("android.intent.action.VIEW"); //
	    case 1: mIntent.setAction("android.intent.action.PICK"); //
	    case 2: mIntent.setAction("android.intent.action.SENDTO"); //
	    case 3: mIntent.setAction("android.intent.action.DIAL"); //
	    case 4: mIntent.setAction("android.intent.action.CALL_BUTTON"); //
	    case 5: mIntent.setAction( "android.intent.action.CALL");
	    case 6: mIntent.setAction("android.media.action.IMAGE_CAPTURE"); //
	    case 7: mIntent.setAction(Settings.ACTION_DATA_ROAMING_SETTINGS);
	    case 8: mIntent.setAction(Settings.ACTION_QUICK_LAUNCH_SETTINGS);
	    case 9: mIntent.setAction(Settings.ACTION_DATE_SETTINGS);
	    case 10: mIntent.setAction(Settings.ACTION_SETTINGS);  //system settings
	    case 11: mIntent.setAction(Settings.ACTION_WIRELESS_SETTINGS);	    
	    case 12: mIntent.setAction(Settings.ACTION_DEVICE_INFO_SETTINGS);
	    
	  }
	  
   }
     
   public boolean ResolveActivity() {
      if (mIntent.resolveActivity(controls.activity.getPackageManager()) != null) {
    	  return true;
      } else return false;
   }
   
   public Uri GetMailtoUri(){		  	      
      return Uri.parse("mailto:");
   }
	   
   public Uri GetMailtoUri(String _email){		  	      
	  return Uri.parse("mailto:"+_email);
   }
     
   public Uri GetTelUri(){		  	      
	  return Uri.parse("tel:");
   }
		   
   public Uri GetTelUri(String _telNumber){		  	      
	  return Uri.parse("tel:"+_telNumber);
   }
   
   /* Pick image from Gallery
    Intent intent = new Intent();  
    intent.setAction(Intent.ACTION_GET_CONTENT);
    intent.setType("image/*");
    intent.putExtra("return-data", true);
    
 
    ACTION_GET_CONTENT with MIME type vnd.android.cursor.item/phone 
    Display the list of people's phone numbers,
    allowing the user to browse through them and pick one and return it to the parent activity.
    
    */
   
   public String GetActionGetContentUri(){	      //generic pick!    
	  return "android.intent.action.GET_CONTENT";
   }
   
   public void PutExtraFile(Uri _uri) { 
	   mIntent.putExtra(Intent.EXTRA_STREAM, _uri); //android.intent.extra.STREAM
   }
   
   
   /* String s =Intent.ACTION_CALL;
    * Activity Action: Perform a call to someone specified by the data. 
      Input: If nothing, an empty dialer is started; 
             else getData() is URI of a phone number to be dialed  or a tel: URI of an explicit phone number. 
             Note: there will be restrictions on which applications can initiate a call; 
             most applications should use the ACTION_DIAL. 
    */
   
   public String GetActionCallAsString() {
	   //String s = Intent.ACTION_CALL;
	   return "android.intent.action.CALL";
   }
   
   public String GetContactNumber(Uri _contactUri) { 
      String[] projection = {Phone.NUMBER};
      Cursor cursor = controls.activity.getContentResolver().query(_contactUri, projection, null, null, null);
      cursor.moveToFirst();
      // Retrieve the phone number from the NUMBER column
       int column = cursor.getColumnIndex(Phone.NUMBER);
       String number = cursor.getString(column);
       cursor.close();
       return number;
   }
   
   
   public String GetContactEmail(Uri _contactUri) { 
	      String[] projection = {Email.DATA};
	      Cursor cursor = controls.activity.getContentResolver().query(_contactUri, projection, null, null, null);
	      cursor.moveToFirst();
	      // Retrieve the phone number from the DATA column
	       int column = cursor.getColumnIndex(Email.DATA);
	       String email = cursor.getString(column);
	       cursor.close();
	       return email;
   }
      
   //ref. http://code.tutsplus.com/tutorials/android-essentials-using-the-contact-picker--mobile-2017
   public String[] GetBundleContent(Intent _intent) {
	 		
     Bundle extras = _intent.getExtras();
     
     if (extras != null) {
    	 int i;
    	 Set keys = extras.keySet();
         String[] strKeys = new String[keys.size()];
         Iterator iterate = keys.iterator();
         i = 0;
         while (iterate.hasNext()) {
           String key = (String) iterate.next();
           strKeys[i] = key + "[" + extras.get(key) + "]";
           i++;		   
         }    
         return strKeys;
         
     } else return null;   
     
   }
   
   public String GetActionImageCaptureAsString() {
	     return "android.media.action.IMAGE_CAPTURE";
   }
      
   //http://www.coderanch.com/t/492490/Android/Mobile/Check-application-installed
   public boolean IsCallable(Intent _intent) {  
       List<ResolveInfo> list = controls.activity.getPackageManager().queryIntentActivities(_intent, PackageManager.MATCH_DEFAULT_ONLY);  
       if(list.size() > 0)
          return true ;  
       else
          return false;
    }
     
   public boolean IsActionEqual(Intent _intent, String _intentAction) { //'android.provider.Telephony.SMS_RECEIVED'
	   return _intent.getAction().equals(_intentAction);
   }
   
   public void PutExtraMediaStoreOutput(String _environmentDirectoryPath, String _fileName) {
	   mIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.parse("file://"+_environmentDirectoryPath+"/"+ _fileName));
   }
   
   public String GetActionCameraCropAsString() {
	  return "com.android.camera.action.CROP"; //http://shaikhhamadali.blogspot.com.br/2013/09/capture-images-and-crop-images-using.html
   }
   
   public void AddCategory(int  _intentCategory) {	   
	  switch(_intentCategory) {
	  
	    case 0: mIntent.addCategory(Intent.CATEGORY_DEFAULT);	  
	   	case 1: mIntent.addCategory(Intent.CATEGORY_LAUNCHER);
	   	case 2: mIntent.addCategory(Intent.CATEGORY_HOME);
	   	case 3: mIntent.addCategory(Intent.CATEGORY_INFO);
	   	case 4: mIntent.addCategory(Intent.CATEGORY_PREFERENCE);	   		   	
	   	case 5: mIntent.addCategory(Intent.CATEGORY_APP_BROWSER);
	   	case 6: mIntent.addCategory(Intent.CATEGORY_APP_CALCULATOR);
	   	case 7: mIntent.addCategory(Intent.CATEGORY_APP_CALENDAR);
	   	case 8: mIntent.addCategory(Intent.CATEGORY_APP_CONTACTS);
	   	case 9: mIntent.addCategory(Intent.CATEGORY_APP_EMAIL);	   	
	   	case 10: mIntent.addCategory(Intent.CATEGORY_APP_GALLERY);	   		   	
	   	case 11: mIntent.addCategory(Intent.CATEGORY_APP_MAPS);	   	
	   	case 12: mIntent.addCategory(Intent.CATEGORY_APP_MESSAGING);
	   	case 13: mIntent.addCategory(Intent.CATEGORY_APP_MUSIC);

	  }		
   }
   
   public void SetFlag(int _intentFlag) {	   
	   switch(_intentFlag) {
	   	 case 0: mIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	   	 case 1: mIntent.setFlags(Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT);
	   	 case 2: mIntent.setFlags(Intent.FLAG_ACTIVITY_TASK_ON_HOME);
	   	 case 3: mIntent.setFlags(Intent.FLAG_ACTIVITY_FORWARD_RESULT);
	  	 case 4: mIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET);
	  }
   }
   
   //params: "packagename whos activity u want to  launch","jClassname"
   public void SetComponent(String _packageName, String _className) {
	   ComponentName cn = new ComponentName(_packageName, _packageName+"."+_className); //"full class name" ??? 
	   mIntent.setComponent(cn);
   }  
   
   public void SetClassName(String _packageName, String _className) {
		mIntent.setClassName(_packageName, _packageName+"."+_className);
   }
   
   public void SetClass(String _className) {	   
	    Class cls = null;
	    //String className = 'com.almondmendoza.library.openActivity';
	    try {
			cls = Class.forName(_className);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    if (cls != null)
		    mIntent.setClass(controls.activity, cls);
   }
   
   public void StartService() { 
	   controls.activity.startService(mIntent);
   }
   
}

