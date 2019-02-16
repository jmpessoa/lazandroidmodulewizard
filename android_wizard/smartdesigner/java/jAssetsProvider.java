package com.example.appassetsproviderclientdemo1;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import android.content.ContentProvider;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import android.util.Log;

/*Draft java code by "Lazarus Android Module Wizard" [1/15/2017 22:50:21]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//ref.: 
//http://www.saturn.dti.ne.jp/~npaka/android/FileProviderEx/index.html
public class jAssetsProvider extends ContentProvider {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   private String mAuthorities = "org.lamw.jfileprovider";
   
   public jAssetsProvider() { 
	  //
   }
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jAssetsProvider(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
 
   @Override
   public boolean onCreate() {
       return true;
   }
   
   
   @Override
   public AssetFileDescriptor openAssetFile(Uri uri, String mode) throws FileNotFoundException {
	String file_name = uri.getLastPathSegment();
	try {
	    return getContext().getAssets().openFd(file_name); //"demo.xml"
	}
	catch (IOException e) {
	    e.printStackTrace();
	    throw new FileNotFoundException(e.getMessage());
	}	
   }
      
   @Override
   public Cursor query(Uri uri,String[] projection,String selection, String[] selectionArgs,String sortOrder) {
       return null;
   }
   
   @Override
   public Uri insert(Uri uri,ContentValues values) {
       return null;
   }
   
   @Override
   public int update(Uri uri,ContentValues values, String selection,String[] selectionArgs) {
       return 0;
   }
   
   @Override
   public int delete(Uri uri,String selection, String[] selectionArgs) {
       return 0;
   }
   
   @Override
   public String getType(Uri uri) {
       return null;
   }
      
   public void SetAuthorities(String _authorities) {
	   mAuthorities = _authorities;
   }
   
   //http://stackoverflow.com/questions/29477209/android-sending-image-from-assets-folder-using-content-provider   
   //http://www.xinotes.net/notes/note/1294/

   public String GetTextContent(String _textfilename) {	   
	 try {
	    ContentResolver r = controls.activity.getContentResolver();  //_
	    InputStream in = r.openInputStream(Uri.parse("content://"+mAuthorities+"/"+ _textfilename));
	    ByteArrayOutputStream out = new ByteArrayOutputStream();
	    byte[] buffer = new byte[4096];
	    int n = in.read(buffer);
	    while (n >= 0) {
		out.write(buffer, 0, n);
		n = in.read(buffer);
	    }
	    in.close();

	    return out.toString();
	  }
	  catch (Exception e) {
	    e.printStackTrace();
	  }
	  return null; 	 
   }

   public Bitmap GetImageContent(String _imagefilename) {
	    ContentResolver r = controls.activity.getContentResolver();  
	    InputStream in;
		try {
			in = r.openInputStream(Uri.parse("content://"+mAuthorities+"/"+ _imagefilename));
		    BufferedInputStream bufferedInputStream = new BufferedInputStream(in);
	        return  BitmapFactory.decodeStream(bufferedInputStream);			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	 
   }
      
   public byte[] GetContent(String _textfilename) {	   
	 try {
	    ContentResolver r = controls.activity.getContentResolver();  //_
	    InputStream in = r.openInputStream(Uri.parse("content://"+mAuthorities+"/"+ _textfilename));
	    ByteArrayOutputStream out = new ByteArrayOutputStream();
	    byte[] buffer = new byte[4096];
	    int n = in.read(buffer);
	    while (n >= 0) {
		out.write(buffer, 0, n);
		n = in.read(buffer);
	    }
	    in.close();
	    return out.toByteArray();
	  }
	  catch (Exception e) {
	    e.printStackTrace();
	  }
	  return null; 	 
   }
      
   public String[] GetAssetsFiles(String _subdir) {	   
	   String[] filelist = null;  
       try {
    	  filelist = controls.activity.getAssets().list(_subdir);
    	  if (filelist.length > 0 ) return  filelist;	 
	   } catch (IOException e) {
		  e.printStackTrace();
	   }       
       return filelist;
    }   
   
}
