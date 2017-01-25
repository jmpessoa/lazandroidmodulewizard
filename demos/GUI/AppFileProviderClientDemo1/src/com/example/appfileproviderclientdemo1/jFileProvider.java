package com.example.appfileproviderclientdemo1;

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
public class jFileProvider extends ContentProvider {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   private String mAuthorities = "com.example.appfileproviderdemo1";
   String mFileSource = "raw";
      
   public jFileProvider() { 
	  //
   }
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
   public jFileProvider(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
   public ParcelFileDescriptor openFile(Uri uri,String mode) throws FileNotFoundException {
	   
       Context context1=getContext();
       int resID = 0;    		   
       String auxname = uri.getLastPathSegment();  // hello.txt_raw or hello.txt_internla or hello.txt_assets        
       mFileSource= auxname.split(":")[1];  //raw              
       String identifier = auxname.split("\\:")[0];  //hello.txt       
       String path = context1.getFilesDir()+"/"+ identifier;
       
       try {
    	                         
           if (mFileSource.equals("raw")) {
        	   identifier = identifier.split("\\.")[0];  //hello
               resID=context1.getResources().getIdentifier(identifier,"raw",context1.getPackageName());
               in2file(context1.getResources().openRawResource(resID),path);               
           }else if (mFileSource.equals("drawable")) { 
        	   identifier = identifier.split("\\.")[0];  //hello
               resID=context1.getResources().getIdentifier(identifier,"drawable",context1.getPackageName());
               in2file(context1.getResources().openRawResource(resID),path);
           }else if (mFileSource.equals("assets")) {
        	   in2file(context1.getAssets().open(identifier),path);
           }
                               
           return ParcelFileDescriptor.open(new File(path), ParcelFileDescriptor.MODE_READ_ONLY);
           
       } catch (Exception e) {
       }
       return null;
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
   
   //Input stream --> file
   private static void in2file(InputStream in,String path) 
       throws Exception { 
       byte[] w=new byte[1024]; 
       FileOutputStream out=null;
       try {
           out=new FileOutputStream(path);
           while (true) { 
               int size=in.read(w); 
               if (size<=0) break; 
               out.write(w,0,size); 
           };
           out.close();
           in.close();
       } catch (Exception e) {
           try {
               if (in !=null) in.close();
               if (out!=null) out.close();
           } catch (Exception e2) {
           }
           throw e;
       }
   }   
   
//-------------------------------------------------
   //Input stream --> data
   public static byte[] in2data(InputStream in) 
	        throws Exception { 
	        byte[] w=new byte[1024]; 
	        ByteArrayOutputStream out=new ByteArrayOutputStream();
	        try {
	            while (true) { 
	                int size=in.read(w);
	                if (size<=0) break; 
	                out.write(w,0,size); 
	            };
	            out.close();
	            in.close();
	            return out.toByteArray();
	        } catch (Exception e) {
	            try {
	                if (in !=null) in.close();
	                if (out!=null) out.close();
	            } catch (Exception e2) {
	            }
	            throw e;
	        }
	    }   
   
   
   public void SetAuthorities(String _authorities) {
	   mAuthorities = _authorities;  //com.example.appfileproviderdemo1
   }
   
   
   public void SetFileSource(int  _filesource) {
	   
	   switch(_filesource) {
	     case 0:  mFileSource = "raw"; break;
	     case 1:  mFileSource = "drawable"; break;
	     case 2:  mFileSource = "internal"; break;
	     case 3:  mFileSource = "assets"; break;
	   }
	   
   }
        
   public String GetTextContent(String _textfilename) {	   
	 try {
	    ContentResolver r = controls.activity.getContentResolver();  
	    InputStream in = r.openInputStream(Uri.parse("content://"+mAuthorities+"/"+ _textfilename+":"+mFileSource));
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

   //http://stackoverflow.com/questions/29477209/android-sending-image-from-assets-folder-using-content-provider   
   //http://www.xinotes.net/notes/note/1294/   
   
   public Bitmap GetImageContent(String _imagefilename) {
	    ContentResolver r = controls.activity.getContentResolver();  
	    InputStream in;
		try {
			in = r.openInputStream(Uri.parse("content://"+mAuthorities+"/"+ _imagefilename+":"+mFileSource));
		    BufferedInputStream bufferedInputStream = new BufferedInputStream(in);
	        return  BitmapFactory.decodeStream(bufferedInputStream);			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	 
   }
      
   public byte[] GetContent(String _filename) {	   
	 try {
	    ContentResolver r = controls.activity.getContentResolver();  
	    InputStream in = r.openInputStream(Uri.parse("content://"+mAuthorities+"/"+ _filename+":"+mFileSource));
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
   
}
