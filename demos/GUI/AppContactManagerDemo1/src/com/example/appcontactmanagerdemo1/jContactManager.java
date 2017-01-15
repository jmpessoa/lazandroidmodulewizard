package com.example.appcontactmanagerdemo1;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.StringTokenizer;

import android.content.ContentProviderOperation;
import android.content.ContentProviderOperation.Builder;
import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.provider.ContactsContract;
import android.provider.ContactsContract.RawContacts;
import android.util.Log;

//http://androidsurya.blogspot.com.br/2011/12/android-adding-contacts.html
//http://www.higherpass.com/android/tutorials/working-with-android-contacts/
//http://www.androidhub4you.com/2013/06/get-phone-contacts-details-in-android_6.html
//http://stackoverflow.com/questions/9907751/android-update-a-contact   - image
//ref   http://wptrafficanalyzer.in/blog/programatically-adding-contacts-with-photo-using-contacts-provider-in-android-example/
//http://stackoverflow.com/questions/4744187/how-to-add-new-contacts-in-android
//http://techblogon.com/read-multiple-phone-numbers-from-android-contacts-list-programmatically/
//http://email-addresses-in-android-contacts.blogspot.com.br/2011/04/how-to-insert-and-update-email.html

/*Draft java code by "Lazarus Android Module Wizard" [6/16/2015 22:00:31]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jContactManager /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jContactManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
   public String GetMobilePhoneNumber(String _displayName){
       
	   String matchNumber = "";
	   String username = _displayName;	   
	   username = username.toLowerCase(); 	   
	   Cursor phones = controls.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	
	   while (phones.moveToNext()) {
	     String name = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));
	     String phoneNumber = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
	     String phoneType = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));	     	     
	     name = name.toLowerCase();	   
	     if(name.equals(username)) {
	    	 if (phoneType.equals("2")) { //mobile
	    	    matchNumber = phoneNumber;
	    	    break;
	    	 }   
	     }		    
	   }	   
	   phones.close();	   
	   return matchNumber;
}
      
//ref http://www.higherpass.com/android/tutorials/working-with-android-contacts/
//http://android-contact-id-vs-raw-contact-id.blogspot.de/
//It's worth to note that there is a 1-to-1 relationship between the CONTACT_ID and the DISPLAY_NAME.   
public String GetContactID(String _displayName){
    
	   String matchID = "";	  
	   String username = _displayName;;	   
	   username = username.toLowerCase(); 
	   
	   Cursor phones = controls.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	      							
		while(phones.moveToNext()) {											
			String name=phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));			
			name = name.toLowerCase();			
		     if(name.equals(username)) {			    	  
	    		matchID = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.CONTACT_ID));	    		
	    	    break;	       
	         }	         		     		    
		}				
	   phones.close();	   
	   return matchID;	   
}


public String GetDisplayName(String _contactID){
	
	   String matchName = "";	  
	   String userID = _contactID;;	   
	  	   
	   Cursor phones = controls.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	      							
	   while(phones.moveToNext()) {											
			 String contact_id=phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.CONTACT_ID));									
		     if(contact_id.equals(userID)) {			    	  
		    	 matchName = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));	    		
	    	    break;	       
	         }	         		     		    
	   }
		
	   phones.close();	   
	   return matchName;
}

/*
public String GetRawContactIDByContactID(String _contactID){
	
	   String raw_contact_id = "";	   
	   String userID = _contactID;;	   
	   
	   Cursor cur = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, null, null, null);

	   if ( (null == cur) || (!cur.moveToFirst()) ) return "";
	      							
	   while(cur.moveToNext()) {											
			String contact_id=cur.getString(cur.getColumnIndex(ContactsContract.Data.CONTACT_ID));									
		     if(contact_id.equals(userID)) {			    	  
	            raw_contact_id = cur.getString(cur.getColumnIndex(ContactsContract.Data.RAW_CONTACT_ID));
	    	    break;	       
	         }	         		     		    
	   }
	   
	   cur.close();	   
	   return raw_contact_id;
}
*/

private String GetRawContactID(String _displayName){
    
	   String raw_contact_id = "";
	   
	   String username = _displayName;;	   
	   username = username.toLowerCase(); 
	   
	   Cursor cur = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, null, null, null);

	   if ( (null == cur) || (!cur.moveToFirst()) ) return "";
	      							
	   while(cur.moveToNext()) {											
			String name=cur.getString(cur.getColumnIndex(ContactsContract.Data.DISPLAY_NAME));			
			name = name.toLowerCase();			
		     if(name.equals(username)) {			    	  
	            raw_contact_id = cur.getString(cur.getColumnIndex(ContactsContract.Data.RAW_CONTACT_ID));
	    	    break;	       
	         }	         		     		    
	    }	
		
		cur.close();	   
	    return raw_contact_id;	   
}

public void UpdateDisplayName(String _displayName, String _newDisplayName) {
	
    try {
        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
        
        String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?"; 
        String[] queryParams = new String[]{_displayName, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE};
        
        Builder builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
        builder.withSelection(queryWhere, queryParams);
        
        builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE);        
        builder.withValue(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME, _newDisplayName);
        
        ops.add(builder.build());	        
                	        	        
        try {
            controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
        }
        catch (Exception e) {
              e.printStackTrace();
        }        
    } catch (Exception e) {
        //	        
    }	
}

public void UpdateMobilePhoneNumber(String _displayName, String _newMobileNumber) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE)}; 

	        Cursor numberPhone = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        
	        //if not found Insert... 	        
	        if ( (null == numberPhone) || (!numberPhone.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newMobileNumber);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE);	            
	        }	        
	        else {	        	        	        
	          String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?"; 

	          String[] queryParams = new String[]{_displayName, 
	        		ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE)}; 	        	        	       
	          builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	          builder.withSelection(queryWhere, queryParams);
	        
	          builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	          builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE);	        
	          builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newMobileNumber);
	        }
	        
	        numberPhone.close();
	        ops.add(builder.build());	        
	                	        	        
	        try {
	          controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	        }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}



public void UpdateWorkPhoneNumber(String _displayName, String _newWorkNumber) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
	        	  
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_WORK)}; 

	        Cursor numberPhone = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        
	        //if not found Insert... 	        
	        if ( (null == numberPhone) || (!numberPhone.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newWorkNumber);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_WORK);	            
	        }	        
	        else {	        
	          String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?"; 

	          String[] queryParams = new String[]{_displayName, 
	        		ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_WORK)}; 	        	        	       
	          builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	          builder.withSelection(queryWhere, queryParams);
	        
	          builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	          builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_WORK);	        
	          builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newWorkNumber);
	        }
	        
	        numberPhone.close();	        
	        ops.add(builder.build());	        
	                	        	        
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	        }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}

public void UpdateHomePhoneNumber(String _displayName, String _newHomeNumber) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
	       	      
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_HOME)}; 

	        Cursor numberPhone = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        
	        // If not found Insert ... 	        
	        if ( (null == numberPhone) || (!numberPhone.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newHomeNumber);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_HOME);	            
	        }	        
	        else {	        
	           String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE) + " = ?"; 

	           String[] queryParams = new String[]{_displayName, 
	        		ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Phone.TYPE_HOME)}; 	        
	        	        
	           builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	           builder.withSelection(queryWhere, queryParams);
	        
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_HOME);	        
	           builder.withValue(ContactsContract.CommonDataKinds.Phone.DATA, _newHomeNumber);
	        }	                
	        
	        numberPhone.close();
	        ops.add(builder.build());	        
	                	        	        
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	          }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}

public void UpdateHomeEmail(String _displayName, String _newHomeEmail) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE_HOME)}; 

	        Cursor emailCur = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        
	        //If not found Insert... 	        
	        if ( (null == emailCur) || (!emailCur.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Email.DATA, _newHomeEmail);
	           builder.withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_HOME);	            
	        }	        
	        else {
	        
	          String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE) + " = ?"; 

	          String[] queryParams = new String[]{_displayName, 
	                                             ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE,
	                                             String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE_HOME)}; 	        
	         	           
	          builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	          builder.withSelection(queryWhere, queryParams);	        
	        
	          builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE);
	          builder.withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_HOME);	        
	          builder.withValue(ContactsContract.CommonDataKinds.Email.DATA, _newHomeEmail);
	        }
	        
	        emailCur.close();
	        ops.add(builder.build());	        
	                	        	        
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	          }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}

public void UpdateWorkEmail(String _displayName, String _newWorkEmail) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();	        
	        
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE_HOME)}; 

	        Cursor emailCur = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        
	        //If not found Insert.... 	        
	        if ( (null == emailCur) || (!emailCur.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Email.DATA, _newWorkEmail);
	           builder.withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_HOME);	            
	        }	        
	        else {
	        String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE) + " = ?"; 

	        String[] queryParams = new String[]{_displayName, 
	                                             ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE,
	                                             String.valueOf(ContactsContract.CommonDataKinds.Email.TYPE_WORK)}; 	        
	         	           
	        builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	        builder.withSelection(queryWhere, queryParams);	        
	        
	        builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE);
	        builder.withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_WORK);	        
	        builder.withValue(ContactsContract.CommonDataKinds.Email.DATA, _newWorkEmail);	        
	        }
	        
	        emailCur.close();
	        ops.add(builder.build());	        
	                	        	        
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	          }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}

public void UpdateOrganization(String _displayName, String _newCompany, String _newJobTitle) {
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = ContactsContract.Data.RAW_CONTACT_ID + " = ? AND " + 
	                   ContactsContract.Data.MIMETYPE + " = ? AND " + 
	                   String.valueOf(ContactsContract.CommonDataKinds.Organization.TYPE) + " = ?";
	        
	        String[] params = new String[]{raw_contact_id, 
	                                   ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE,
	                                   String.valueOf(ContactsContract.CommonDataKinds.Organization.TYPE_WORK)}; 

	        Cursor orgCur = controls.activity.getContentResolver().query(ContactsContract.Data.CONTENT_URI, null, where, params, null);
	        	        	        
	        // If not found Insert... 	        
	        if ( (null == orgCur) || (!orgCur.moveToFirst()) ) {	        	
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
	           builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);
	           builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE);
	           builder.withValue(ContactsContract.CommonDataKinds.Organization.DATA, _newCompany);
	           builder.withValue(ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK);
			   builder.withValue(ContactsContract.CommonDataKinds.Organization.TITLE, _newJobTitle);
			   builder.withValue(ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK);
	        }	        
	        else {	        	        
	          String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?"; 
	          String[] queryParams = new String[]{_displayName, ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE};	              
	        	        
	          builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
	          builder.withSelection(queryWhere, queryParams);	        
	          builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE);
		      builder.withValue(ContactsContract.CommonDataKinds.Organization.COMPANY, _newCompany);
		      builder.withValue( ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK);
		      builder.withValue(ContactsContract.CommonDataKinds.Organization.TITLE, _newJobTitle);
		      builder.withValue(ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK);
	        }
	        
	        orgCur.close();
	        ops.add(builder.build());	        
	                	        	        
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	          }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }	
}

public void UpdatePhoto(String _displayName, Bitmap _bitmapImage) {
	
  if(_bitmapImage!=null) {
	  
     ByteArrayOutputStream stream = new ByteArrayOutputStream();
     _bitmapImage.compress(Bitmap.CompressFormat.PNG , 75, stream);	
	
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();

	        Builder builder = null;
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String qwhere = RawContacts.Data._ID + "=?";
	        String[] qparam = new String[] {String.valueOf(raw_contact_id)};
	        	       	        	        	        	        
	        Cursor cursorPhoto = controls.activity.getContentResolver().query(RawContacts.CONTENT_URI, null,qwhere,qparam, null);	             
	        		                                                             	        		                                                            	               	        
	        //If not found Insert... 	        
	        if ( (null == cursorPhoto) || (!cursorPhoto.moveToFirst()) ) {	           
	           builder = ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI);	        		        	        		          
			   builder.withValue(ContactsContract.Data.RAW_CONTACT_ID, raw_contact_id);			           			    	   			    	   				       
			   builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE);
			   builder.withValue(ContactsContract.CommonDataKinds.Photo.PHOTO,stream.toByteArray());			   
	        }	        
	        else {	        		      	        	  
	         // Log.i("found update...", _displayName);	
	          String queryWhere = ContactsContract.Data.DISPLAY_NAME + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?"; 
	          String[] queryParams = new String[]{_displayName, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE};			           			    	   			    	   				       	
		      builder = ContentProviderOperation.newUpdate(ContactsContract.Data.CONTENT_URI);	        
			  builder.withSelection(queryWhere, queryParams);
			  builder.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE);
			  builder.withValue(ContactsContract.CommonDataKinds.Photo.PHOTO,stream.toByteArray());
	        }	        	        	        	        
   		    ops.add(builder.build());
   		    
			try {
			   controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
			}
			catch (Exception e) {
			    e.printStackTrace();
		    }
			
			cursorPhoto.close();
			
			try {
			       stream.flush();
			}catch (IOException e) {
			       e.printStackTrace();
			}
			
	    } 
	    catch (Exception e) {
	        //	        
	    }
  }	 
}

public Bitmap GetPhoto(String _displayName){
	   
	   Bitmap photoImage= null;
	   String photoURI = null;	   
	   String username;	   
	   username = _displayName;	   
	   username = username.toLowerCase();
	   	          	   
	   Cursor phones = controls.activity.getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null,null,null, null);
	   	    
	   while (phones.moveToNext()) {
	     String name = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));	     	     	     	    
	     name = name.toLowerCase();	     
	     if(name.equals(username)) {
	    	    photoURI = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_URI));
	    	    break;	    	   
	     }		    
	   }
	   	   
	   phones.close();	   
	   	   
	   if (photoURI != null) {		   	   
	     Uri imageUri =  Uri.parse(photoURI);
         InputStream imageStream;       
	     try {
		  imageStream = controls.activity.getContentResolver().openInputStream(imageUri);
		  photoImage = BitmapFactory.decodeStream(imageStream);
		 } catch (FileNotFoundException e) {
		  // TODO Auto-generated catch block
		   e.printStackTrace();
	     }
	   }	   	   
       return photoImage;       	  	 
}


public Bitmap GetPhotoByUriAsString(String _uriAsString){
	   
	Bitmap photoImage= null;
			   	   
	if (!_uriAsString.equals("")) {		   	   
	     Uri imageUri =  Uri.parse(_uriAsString);
         InputStream imageStream;       
	     try {
		  imageStream = controls.activity.getContentResolver().openInputStream(imageUri);
		  photoImage = BitmapFactory.decodeStream(imageStream);
		 } catch (FileNotFoundException e) {
		  // TODO Auto-generated catch block
		   e.printStackTrace();
	     }
	}	   	   
    return photoImage;       	  	 
}

//ref. http://android-contact-id-vs-raw-contact-id.blogspot.de/
public void DeleteContact(String _displayName) {
	 try {
	        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();	        	        
	        Builder builder = null; 		   	        
	        String raw_contact_id = GetRawContactID(_displayName);
	        
	        String where = RawContacts._ID + " = ?";	        
	        String[] params = new String[]{String.valueOf(raw_contact_id)};	        
	        builder = ContentProviderOperation.newDelete(RawContacts.CONTENT_URI);	        		        	        		          
			builder.withSelection(where,params);			           					
			
			ops.add(builder.build());	    
			
	        try {
	        	  controls.activity.getContentResolver().applyBatch(ContactsContract.AUTHORITY,ops);
	          }
	        catch (Exception e) {
	              e.printStackTrace();
	        }	          	          
	    } catch (Exception e) {
	        //	        
	    }
}

/*TODO
//ref. http://stackoverflow.com/questions/27781285/how-to-delete-sim-card-contact-in-android
public void DeleteContactFromSIMCard(String _displayName) {
	
	String username = _displayName;
	username = username.toLowerCase();
	
	Log.i("username...", username);
	
	Uri simUri = Uri.parse("content://icc/adn/");
	
	ContentResolver mContentResolver = controls.activity.getContentResolver();
	
	Cursor c = mContentResolver.query(simUri, null, null, null, null);
	
	if (c.getCount() > 0) {		
		while ( c.moveToNext() ) {
		     String name = c.getString(c.getColumnIndex("name"));			     		     		     
		     name = name.toLowerCase();		     
		     Log.i("do...", name);
		     if(name.equals(username)) {
		    	 Log.i("equals...", name);		    	 		  		    	 		    	 
		    	 //String where = "tag=? AND number=?";
		    	 //String[] args = new String[] { c.getString(c.getColumnIndex("name")) ,  c.getString(c.getColumnIndex("number"))};		         		    	 
		    	 int i = mContentResolver.delete(
		                 simUri,
		                 "tag='" + c.getString(c.getColumnIndex("name")) +
		                 "' AND " +
		                 "number='" + c.getString(c.getColumnIndex("number")) + "'", null);		                		    	 
		    	 //int i = mContentResolver.delete(simUri,where,args);		        
		         Log.i("return"," i= "+ i);
			     break;	    	   
		     }
		}     
		    		
	}		   
	c.close();	 
}

*/
//ref. http://stackoverflow.com/questions/10412634/fetch-local-phonebook-contacts-from-sim-card-only-android/10412757#10412757
public String[] GetContactsFromSIMCard(String _delimiter) {
	
	ArrayList<String> list = new ArrayList<String>();
	
    try
    {
        String  simPhonename = null; 
        String  simphoneNo = null;

        Uri simUri = Uri.parse("content://icc/adn"); 
        Cursor cursorSim = controls.activity.getContentResolver().query(simUri,null,null,null,null);

        //Log.i("PhoneContact", "total: "+cursorSim.getCount());
        if (cursorSim.getCount() > 0) {        
           while (cursorSim.moveToNext()) {      
        	   simPhonename = cursorSim.getString(cursorSim.getColumnIndex("name"));
        	   simphoneNo = cursorSim.getString(cursorSim.getColumnIndex("number"));
        	   simphoneNo.replaceAll("\\D","");
        	   simphoneNo.replaceAll("&", "");
               simPhonename=simPhonename.replace("|","");
               //Log.i("PhoneContact", "name: "+simPhonename+" phone: "+simphoneNo);               
               list.add(simPhonename+ _delimiter + simphoneNo);
           }  
       }         
       cursorSim.close();
    }
    catch(Exception e) {
        e.printStackTrace();
    }
    
    return list.toArray(new String[list.size()]);
}

public void AddContact(String _displayName, String _mobileNumber, String _homeNumber, String _workNumber, 
		               String _homeEmail, String _workEmail, String _companyName, String _jobTitle, Bitmap _bitmapImage) {

		 String displayName = _displayName;		 		 
		 if (displayName.equals(""))  displayName = "New Contact";
		
		 String homeNumber = _homeNumber;
		 if (homeNumber.equals(""))  homeNumber =  "000000000000";
		 
		 String mobileNumber = _mobileNumber;
		 if (mobileNumber.equals(""))  mobileNumber = "000000000000";
		  
		 String workNumber = _workNumber;
		 if (workNumber.equals(""))  workNumber = "000000000000";
		 
		 String homeEmail = _homeEmail;
		 if (homeEmail.equals(""))  homeEmail = "email@home";
		 
		 String workEmail = _workEmail;
		 if (workEmail.equals(""))  workEmail = "email@work";
		 
		 String company = _companyName;
		 if (company.equals(""))  company = "Company Name";
		 
		 String jobTitle = _jobTitle;
		 if (jobTitle.equals(""))  jobTitle = "Job Title";
		 
		 Context ctx = controls.activity;

		 ArrayList<ContentProviderOperation> contentProviderOperation = new ArrayList<ContentProviderOperation>();

		 int rawContactID = contentProviderOperation.size();

		    // Adding insert operation to operations list 
		    // to insert a new raw contact in the table ContactsContract.RawContacts
		 contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.RawContacts.CONTENT_URI)
		   .withValue(ContactsContract.RawContacts.ACCOUNT_TYPE, null)
		   .withValue(ContactsContract.RawContacts.ACCOUNT_NAME, null)
		   .build());

		 // ------------------------------------------------------ Names
	     // Adding insert operation to operations list
	     // to insert display name in the table ContactsContract.Data
		 
		  contentProviderOperation.add(ContentProviderOperation
		    .newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME, displayName)
		    .build());
		  
		 // ------------------------------------------------------ Mobile Number
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Phone.NUMBER, mobileNumber)
		    .withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE)
		    .build());
		  
		 // ------------------------------------------------------ Home Numbers		  
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Phone.NUMBER, homeNumber)
		    .withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_HOME)
		    .build());
		 
		 // ------------------------------------------------------ Work Numbers		  
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Phone.NUMBER, workNumber)
		    .withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_WORK)
		    .build());		 
		 
		 // ------------------------------------------------------ homeEmail
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference( ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue( ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Email.DATA, homeEmail)
		    .withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_HOME)
		    .build());
		  
			 // ------------------------------------------------------ workEmail		  
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Email.DATA, workEmail)
		    .withValue(ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.TYPE_WORK)
		    .build());		  
		 
		 // ------------------------------------------------------ Organization
		  contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		    .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
		    .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE)
		    .withValue(ContactsContract.CommonDataKinds.Organization.COMPANY, company)
		    .withValue( ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK)
		    .withValue(ContactsContract.CommonDataKinds.Organization.TITLE, jobTitle)
		    .withValue(ContactsContract.CommonDataKinds.Organization.TYPE, ContactsContract.CommonDataKinds.Organization.TYPE_WORK)
		    .build());		 		 
		  
		 //------------------------------------------------------------------ photo
	     if(_bitmapImage!=null) { 
	    	    ByteArrayOutputStream stream = new ByteArrayOutputStream();
	    	    _bitmapImage.compress(Bitmap.CompressFormat.PNG,75,stream);
	    	   
	           // Adding insert operation to operations list
	           // to insert Photo in the table ContactsContract.Data
	    	   contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
	                .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
	                .withValue(ContactsContract.Data.IS_SUPER_PRIMARY, 1)
	                .withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE)
	                .withValue(ContactsContract.CommonDataKinds.Photo.PHOTO,stream.toByteArray())
	                .build());
	           try {
	               stream.flush();
	           }catch (IOException e) {
	               e.printStackTrace();
	           }
	       }
	      
		 // Asking the Contact provider to create a new contact
		 try {
		    ctx.getContentResolver().applyBatch(ContactsContract.AUTHORITY, contentProviderOperation);
		 } catch (Exception e) {
		  e.printStackTrace();
		     //show exception in toast
		     //Toast.makeText(ctx, "Exception: " + e.getMessage(), Toast.LENGTH_SHORT).show();
		 }
}

public void AddContact(String _displayName, String _mobileNumber) {

	String displayName = _displayName;		 		 	
	if (displayName.equals(""))  displayName = "New Contact";

	String mobileNumber = _mobileNumber;
	if (mobileNumber.equals(""))  mobileNumber = "000000000000";

	Context ctx = controls.activity;

	ArrayList<ContentProviderOperation> contentProviderOperation = new ArrayList<ContentProviderOperation>();

	int rawContactID = contentProviderOperation.size();

// Adding insert operation to operations list 
// to insert a new raw contact in the table ContactsContract.RawContacts
	contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.RawContacts.CONTENT_URI)
			.withValue(ContactsContract.RawContacts.ACCOUNT_TYPE, null)
			.withValue(ContactsContract.RawContacts.ACCOUNT_NAME, null)	
			.build());

// ------------------------------------------------------ Names
// Adding insert operation to operations list
// to insert display name in the table ContactsContract.Data

	contentProviderOperation.add(ContentProviderOperation
			.newInsert(ContactsContract.Data.CONTENT_URI)
			.withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
			.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE)
			.withValue(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME, displayName)
			.build());

// ------------------------------------------------------ Mobile Number
	contentProviderOperation.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
			.withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactID)
			.withValue(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE)
			.withValue(ContactsContract.CommonDataKinds.Phone.NUMBER, mobileNumber)
			.withValue(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE)
			.build());

    //Asking the Contact provider to create a new contact
	try {
		ctx.getContentResolver().applyBatch(ContactsContract.AUTHORITY, contentProviderOperation);
	} catch (Exception e) {
		e.printStackTrace();
    }
}

public void GetContactsAsync(String _delimiter) {
	new ATask().execute(_delimiter);
}
                             //param, progr, result  
class ATask extends AsyncTask<String, String, String[]> {
	   
	//ArrayList<String> list = new ArrayList<String>();
	boolean mListing = true;
	int mCount = 0;
	String _delimiter = null;
	//String mName = "";
	Bitmap mPhoto = null;
	String photoURI = null;	   
	
    @Override
    protected String[] doInBackground(String... message) {
    	
       _delimiter = message[0];   	   	
   	   String line = "";
       
   	   ContentResolver cr = controls.activity.getContentResolver();       
       Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI,null, null, null, null);
                         	              	                         	   
       if (cur.getCount() > 0) {
    	   while (cur.moveToNext() && mListing) {
 	          if (Integer.parseInt(cur.getString(cur.getColumnIndex(ContactsContract.Contacts.HAS_PHONE_NUMBER))) > 0) {    	        	
    	            String id = cur.getString(cur.getColumnIndex(ContactsContract.Contacts._ID));    	                	        	                	            
    	            String name = cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));    	            
    	            line = name + _delimiter;
    	            
    	            // get the phone number
    	            Cursor pCur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,null,
    	                                       ContactsContract.CommonDataKinds.Phone.CONTACT_ID +" = ?",
    	                                       new String[]{id}, null);
    	            while (pCur.moveToNext()) {
    	                      String phone = pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
    	                      String phoneType = pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
    	                    //1:home 2:mobile 3:Work 
    	                      if (phoneType.equals("1"))  
    	                    	  line = line + phone +" [Home]"+ _delimiter;
    	                      else if (phoneType.equals("3"))  
    	                    	  line = line + phone +" [Work]"+ _delimiter;
    	                      else line = line + phone + _delimiter;    	                          	                                             	                     
    	            }
    	            pCur.close();
    	               
    	            // get email and type
    	            Cursor emailCur = cr.query(ContactsContract.CommonDataKinds.Email.CONTENT_URI,null, 
    	            		                   ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = ?",
    	                                        new String[]{id}, null);
    	               
    	            while (emailCur.moveToNext()) {
    	                    // This would allow you get several email addresses
    	                    // if the email addresses were stored in an array
    	                    String email = emailCur.getString(
    	                                  emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));
    	                    
    	                    String emailType = emailCur.getString(
    	                                  emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.TYPE));
                                  	                    
    	                    line = line + email + _delimiter;
    	            }
    	            emailCur.close();

    	            //Get note.......
    	            //Get Postal Address....
    	            //Get Organizations.........
    	            String orgWhere = ContactsContract.Data.CONTACT_ID + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?";
    	            String[] orgWhereParams = new String[]{id,ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE};
    	            Cursor orgCur = cr.query(ContactsContract.Data.CONTENT_URI, null, orgWhere, orgWhereParams, null);
    	            if (orgCur.moveToFirst()) {
    	                    String orgName = orgCur.getString(orgCur.getColumnIndex(ContactsContract.CommonDataKinds.Organization.DATA));
    	                    String title = orgCur.getString(orgCur.getColumnIndex(ContactsContract.CommonDataKinds.Organization.TITLE));
    	                    //System.out.println("orgName " + orgName + " Job title : " + title);
    	                    line = line + orgName + _delimiter + title + _delimiter;
    	            }
    	            
    	            orgCur.close();           	                	            
    	            
    	            //list.add(line);    	            
    	            //line = line + id + _delimiter;    	   
    	            
    	            //Get photo Uri
    	            Cursor phCur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,null,
                                            ContactsContract.CommonDataKinds.Phone.CONTACT_ID +" = ?",
                                            new String[]{id}, null);
    	            
    	            photoURI = null;
    	            if (phCur.moveToFirst()) {    	                 
    	               photoURI = phCur.getString(phCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_URI));   
    	         	   if (photoURI == null) {
    	         		  photoURI = ":)";
    	               }	       	                   	         	   
    	            }
    	            
    	            phCur.close();   
    	            
    	            line = line + photoURI;
    	            
    	            publishProgress(line);    	            
    	      }    	            	     
    	   }       
    	   cur.close();    	             	   
       }    	       	       	    
       return  null; //list.toArray(new String[list.size()]);
    }

    @Override
    protected void onProgressUpdate(String... contact) {    	   
        super.onProgressUpdate(contact[0]);
        
        StringTokenizer stToken = new StringTokenizer(contact[0], _delimiter);                                
        int count = stToken.countTokens();
        final String[] splitStr = new String[count];
        int index = 0;
        while(stToken.hasMoreElements()) {        	
           splitStr[index] = stToken.nextToken();                     
           index = index + 1;
        }
        
        String contactInfo = splitStr[0] ;         
        for (int i=1; i < count-1 ; i++) {
        	contactInfo = contactInfo + _delimiter + splitStr[i];
        }		
                         	
        mPhoto = null;
        
        if (! splitStr[count-1].equals(":)") ) {        	
          mPhoto = GetPhotoByUriAsString(splitStr[count-1]); 
        }
        
        String shortInfo = splitStr[0] + _delimiter + splitStr[1];
                     
        mCount = mCount + 1;
        mListing = controls.pOnContactManagerContactsProgress(pascalObj, contactInfo , shortInfo, splitStr[count-1], mPhoto, mCount);
    }
    
    @Override
    protected void onPostExecute(String[] contactsResult) {    	  
      super.onPostExecute(contactsResult);           
      controls.pOnContactManagerContactsExecuted(pascalObj, mCount);
    }      
    
}
  
public String GetContactInfo(String _displayName, String _delimiter) {
	   
	  //ArrayList<String> list = new ArrayList<String>();
	  boolean mListing = true;
	  int mCount = 0;
	
	  //String mName = "";
	  Bitmap mPhoto = null;
	  String photoURI = null;
	  
	   String username = _displayName;;	   
	   username = username.toLowerCase(); 
	
       
   	   String line = "";
       
   	   ContentResolver cr = controls.activity.getContentResolver();       
       Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI,null, null, null, null);
                                          
       if (cur.getCount() > 0) {    	       	   
    	   while(cur.moveToNext()) {											
    		 String name=cur.getString(cur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME));			
    		 String name1 = name.toLowerCase();			
    		 if(name1.equals(username)) {    		    	     		     
 	            if (Integer.parseInt(cur.getString(cur.getColumnIndex(ContactsContract.Contacts.HAS_PHONE_NUMBER))) > 0) {    	        	
    	            String id = cur.getString(cur.getColumnIndex(ContactsContract.Contacts._ID));    	                	        	                	            
    	            //String name = cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));    	            
    	            line = name + _delimiter;;    	                	             	                       	               
    	            // get the phone number
    	            Cursor pCur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,null,
    	                                       ContactsContract.CommonDataKinds.Phone.CONTACT_ID +" = ?",
    	                                       new String[]{id}, null);
    	            while (pCur.moveToNext()) {
    	                      String phone = pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
    	                      String phoneType = pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE));
    	                    //1:home 2:mobile 3:Work 
    	                      if (phoneType.equals("1"))  
    	                    	  line = line + phone +" [Home]"+ _delimiter;
    	                      else if (phoneType.equals("3"))  
    	                    	  line = line + phone +" [Work]"+ _delimiter;
    	                      else line = line + phone + _delimiter;    	                          	                                             	                     
    	            }
    	            pCur.close();
    	               
    	            // get email and type
    	            Cursor emailCur = cr.query(ContactsContract.CommonDataKinds.Email.CONTENT_URI,null, 
    	            		                   ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = ?",
    	                                        new String[]{id}, null);
    	               
    	            while (emailCur.moveToNext()) {
    	                    // This would allow you get several email addresses
    	                    // if the email addresses were stored in an array
    	                    String email = emailCur.getString(
    	                                  emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA));
    	                    
    	                    String emailType = emailCur.getString(
    	                                  emailCur.getColumnIndex(ContactsContract.CommonDataKinds.Email.TYPE));
                                  	                    
    	                    line = line + email + _delimiter;
    	            }
    	            emailCur.close();

    	            //Get note.......
    	            //Get Postal Address....
    	            //Get Organizations.........
    	            String orgWhere = ContactsContract.Data.CONTACT_ID + " = ? AND " + ContactsContract.Data.MIMETYPE + " = ?";
    	            String[] orgWhereParams = new String[]{id,ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE};
    	            Cursor orgCur = cr.query(ContactsContract.Data.CONTENT_URI, null, orgWhere, orgWhereParams, null);
    	            if (orgCur.moveToFirst()) {
    	                    String orgName = orgCur.getString(orgCur.getColumnIndex(ContactsContract.CommonDataKinds.Organization.DATA));
    	                    String title = orgCur.getString(orgCur.getColumnIndex(ContactsContract.CommonDataKinds.Organization.TITLE));
    	                    //System.out.println("orgName " + orgName + " Job title : " + title);
    	                    line = line + orgName + _delimiter + title + _delimiter;
    	            }
    	            
    	            orgCur.close();           	                	            
    	            
    	            //list.add(line);    	            
    	            line = line + id + _delimiter;    	   
    	            
    	            //Get photo Uri
    	            Cursor phCur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI,null,
                                            ContactsContract.CommonDataKinds.Phone.CONTACT_ID +" = ?",
                                            new String[]{id}, null);
    	            
    	            photoURI = null;
    	            if (phCur.moveToFirst()) {    	                 
    	               photoURI = phCur.getString(phCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_URI));   
    	         	   if (photoURI == null) {
    	         		  photoURI = ":)";
    	               }	       	                   	         	   
    	            }
    	            
    	            phCur.close();   
    	            
    	            line = line + photoURI;    	            
    	        }
 	            break; 
    		 } 
    	   }       
    	   cur.close();    	             	   
    }
    return line;   
}

}

