package com.example.appbluetoothclientsocketdemo2;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

import android.content.Context;
import android.content.Intent;
import android.content.res.AssetManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.widget.ImageView;

/*Draft java code by "Lazarus Android Module Wizard" [8/13/2014 1:43:12]*/    //********
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jImageFileManager /*extends ...*/ {

  private long     pascalObj = 0;      // Pascal Object
  private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
  private Context  context   = null;
  
  //Warning: please, preferentially init your news params names with "_", ex: int _flag, String _hello ...
  public jImageFileManager(Controls _ctrls, long _Self) { //Add more here new "_xxx" params if needed!
     //super(contrls.activity);
     context   = _ctrls.activity;
     pascalObj = _Self;
     controls  = _ctrls;                   
  }

  public void jFree() {
    //free local objects...        	
  }

 public void SaveToSdCard(Bitmap _image, String _filename) {	
	   	  	   
	    File file;
	    String root = Environment.getExternalStorageDirectory().toString();
	    
	    file = new File (root+"/"+_filename);	
	    
	    if (file.exists ()) file.delete (); 
	    try {
	       FileOutputStream out = new FileOutputStream(file);	           	           	         
	     
         if ( _filename.toLowerCase().contains(".jpg") ) _image.compress(Bitmap.CompressFormat.JPEG, 90, out);
	       if ( _filename.toLowerCase().contains(".png") ) _image.compress(Bitmap.CompressFormat.PNG, 100, out);	       
	       
	       out.flush();
	       out.close();
	    } catch (Exception e) {
         e.printStackTrace();
	    }
	    
 }
 
 // By using this line you can able to see saved images in the gallery view.
 public void ShowImagesFromGallery () {	   
	   controls.activity.sendBroadcast(new Intent(
		   Intent.ACTION_MEDIA_MOUNTED,
		   Uri.parse("file://" + Environment.getExternalStorageDirectory())));
 }
 
 public Bitmap LoadFromSdCard(String _filename) {	   
	      String imageInSD = Environment.getExternalStorageDirectory().getPath()+"/"+_filename;	      
	      Bitmap bitmap = BitmapFactory.decodeFile(imageInSD);	      
	      return bitmap; 
 }
    
 //http://android-er.blogspot.com.br/2010/07/save-file-to-sd-card.html
 private InputStream OpenHttpConnection(String strURL) throws IOException{
	   InputStream inputStream = null;
	   URL url = new URL(strURL);
	   URLConnection conn = url.openConnection();

	   try{
	    HttpURLConnection httpConn = (HttpURLConnection)conn;
	    httpConn.setRequestMethod("GET");
	    httpConn.connect();

	    if (httpConn.getResponseCode() == HttpURLConnection.HTTP_OK) {
	     inputStream = httpConn.getInputStream();
	    }
	    
	   }
	   catch (Exception ex)
	   {
	   }
	   
	   return inputStream;
 }
 
 public Bitmap LoadFromURL(String _imageURL) {
	   
  BitmapFactory.Options bmOptions;
	bmOptions = new BitmapFactory.Options();
	bmOptions.inSampleSize = 1;
	   
  Bitmap bitmap = null;
  InputStream in = null;      
     try {
         in = OpenHttpConnection(_imageURL);
         bitmap = BitmapFactory.decodeStream(in, null, bmOptions);
         in.close();
     } catch (IOException e1) {
     }
     return bitmap;              
     
 }
                 
 public Bitmap LoadFromAssets(String strName)
 {
     AssetManager assetManager = controls.activity.getAssets();
     InputStream istr = null;
     try {
         istr = assetManager.open(strName);
     } catch (IOException e) {
         e.printStackTrace();
     }
     Bitmap bitmap = BitmapFactory.decodeStream(istr);
     return bitmap;
 }

 private int GetDrawableResourceId(String _resName) {
 	  try {
 	     Class<?> res = R.drawable.class;
 	     Field field = res.getField(_resName);  //"drawableName"
 	     int drawableId = field.getInt(null);
 	     return drawableId;
 	  }
 	  catch (Exception e) {
 	     Log.e("jImageFileManager", "Failure to get drawable id.", e);
 	     return 0;
 	  }
 }

 private Drawable GetDrawableResourceById(int _resID) {
 	  return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
 }
           
 public Bitmap LoadFromResources(String _imageResIdentifier)
 {
	Drawable d = GetDrawableResourceById(GetDrawableResourceId(_imageResIdentifier));	
	Bitmap bmap = ((BitmapDrawable)d).getBitmap();
    return bmap;
 }
 
 public Bitmap LoadFromFile(String _filename) {  //InternalAppStorage  !!!	   
	   Bitmap bmap=null;	  
	   File fDir = this.controls.activity.getFilesDir();  //Result : /data/data/com/MyApp/files
	   File file = new File(fDir, _filename);	   
	   InputStream fileInputStream = null;	   
	   try {
		 fileInputStream = new FileInputStream(file);
		 BitmapFactory.Options bitmapOptions = new BitmapFactory.Options();
		 bitmapOptions.inSampleSize = 1; //original image size :: 4 --> size 1/4!
		 bitmapOptions.inJustDecodeBounds = false; //If set to true, the decoder will return null (no bitmap), 
		 bmap = BitmapFactory.decodeStream(fileInputStream, null, bitmapOptions);		 
	   } catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		 e.printStackTrace();
	   }  	   
	   return bmap;  	   
 }
 
 public Bitmap LoadFromFile(String _path, String _filename) { //EnvironmentDirectoryPath  !!	   
	   String imageIn = _path+"/"+_filename;	      
	   Bitmap bitmap = BitmapFactory.decodeFile(imageIn);	      
	   return bitmap; 
 }
 
 public void SaveToFile(Bitmap _image, String _filename) {	   	    
	    String root = this.controls.activity.getFilesDir().getAbsolutePath();	      	    	    
	    File file = new File (root +"/"+ _filename);	    
	    if (file.exists ()) file.delete (); 
	    try {
	        FileOutputStream out = new FileOutputStream(file);	  
	        
	        if ( _filename.toLowerCase().contains(".jpg") ) _image.compress(Bitmap.CompressFormat.JPEG, 90, out);
	        if ( _filename.toLowerCase().contains(".png") ) _image.compress(Bitmap.CompressFormat.PNG, 100, out);
	        
	         out.flush();
	         out.close();
	    } catch (Exception e) {
	         e.printStackTrace();
	    }  	     	   
 }
    
 public void SaveToFile(Bitmap _image,String _path, String _filename) {	   	    
	       	    	    
	    File file = new File (_path +"/"+ _filename);	    
	    if (file.exists ()) file.delete (); 
	    try {
	        FileOutputStream out = new FileOutputStream(file);	  
	        
	        if ( _filename.toLowerCase().contains(".jpg") ) _image.compress(Bitmap.CompressFormat.JPEG, 90, out);
	        if ( _filename.toLowerCase().contains(".png") ) _image.compress(Bitmap.CompressFormat.PNG, 100, out);
	        
	         out.flush();
	         out.close();
	    } catch (Exception e) {
	         e.printStackTrace();
	    }  	     	   
}

 public Bitmap LoadFromUri(Uri _imageUri) {
      InputStream imageStream;
      Bitmap selectedImage= null;
		try {
			imageStream = controls.activity.getContentResolver().openInputStream(_imageUri);
			selectedImage = BitmapFactory.decodeStream(imageStream);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}        
      return selectedImage;
 }
       
 public  Bitmap LoadFromFile(String _filename, int _scale) {
	   BitmapFactory.Options options = new BitmapFactory.Options();
	   options.inSampleSize = _scale; // --> 1/4
	   return BitmapFactory.decodeFile(_filename, options);
 }

 public Bitmap CreateBitmap(int _width, int _height) {
	    return Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888 );
 }
 
 public int GetBitmapWidth(Bitmap _bitmap) {	 	 
	 	if ( _bitmap != null ) {
	 	   return _bitmap.getWidth();	 	  
	 	} else return 0;	 	 
  }

  public  int GetBitmapHeight(Bitmap _bitmap) {	 
	 	if ( _bitmap != null ) {
	 	   return _bitmap.getHeight();	  
	 	} else return 0;	 
  }
	 
	public byte[] GetByteArrayFromBitmap(Bitmap _bitmap, String _compressFormat) {
	     
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		String strUpper = _compressFormat.toUpperCase();		
	     
	     if (  strUpper.equals("WEBP") ) { 
	        _bitmap.compress(CompressFormat.WEBP, 0, stream); //O: PNG will ignore the quality setting...
	     } else if (  strUpper.equals("JPEG") ){
	    	 _bitmap.compress(CompressFormat.JPEG, 0, stream); //O: PNG will ignore the quality setting... 
	     } else {
	    	 _bitmap.compress(CompressFormat.PNG, 0, stream); //O: PNG will ignore the quality setting... 
	     }
	     return stream.toByteArray();
	 }

	public Bitmap SetByteArrayToBitmap(byte[] _imageArray) {
	    return BitmapFactory.decodeByteArray(_imageArray, 0, _imageArray.length);
	}

	 //http://androidtrainningcenter.blogspot.com.br/2012/05/bitmap-operations-like-re-sizing.html
	public Bitmap ClockWise(Bitmap _bitmap, ImageView _imageView){
	     Matrix mMatrix = new Matrix();
	     Matrix mat= _imageView.getImageMatrix();    
	     mMatrix.set(mat);
	     mMatrix.setRotate(90);
	     return Bitmap.createBitmap(_bitmap , 0, 0, _bitmap.getWidth(), _bitmap.getHeight(), mMatrix, false);    
	} 

	public Bitmap AntiClockWise(Bitmap _bitmap, ImageView _imageView){
	     Matrix mMatrix = new Matrix();
	     Matrix mat= _imageView.getImageMatrix();    
	     mMatrix.set(mat);
	     mMatrix.setRotate(-90);
	     return Bitmap.createBitmap(_bitmap, 0, 0, _bitmap.getWidth(), _bitmap.getHeight(), mMatrix, false);    
	}
	
	public Bitmap SetScale(Bitmap _bmp, ImageView _imageView, float _scaleX, float _scaleY ) {  
	    Matrix mMatrix = new Matrix();
	    Matrix mat= _imageView.getImageMatrix();    
	    mMatrix.set(mat);        
		mMatrix.setScale(_scaleX, _scaleY);
		return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), mMatrix, false);	   
	}

	public Bitmap GetBitmapFromDecodedFile(String _imagePath) {
	   return BitmapFactory.decodeFile(_imagePath);
	}
	
	
	public Bitmap GetBitmapFromIntentResult(Intent _intentData) {						
		Uri selectedImage = _intentData.getData();
		String[] filePathColumn = { MediaStore.Images.Media.DATA };	 
	    Cursor cursor = controls.activity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
	    cursor.moveToFirst();
	    int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
	    String picturePath = cursor.getString(columnIndex);
	    cursor.close();
	    return BitmapFactory.decodeFile(picturePath);    
	}
	
	
	public Bitmap GetBitmapThumbnailFromCamera(Intent _intentData) {
		Bundle extras = _intentData.getExtras();
	    return (Bitmap) extras.get("data");    
	}
	
	//TODO Pascal
	public String GetImageFilePath(Intent _intentData) {
		   //Uri selectedImage = data.getData();
	  Uri selectedImage = _intentData.getData();	
	  String[] filePathColumn = { MediaStore.Images.Media.DATA };	   
	  Cursor cursor = controls.activity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
	  cursor.moveToFirst();
	  int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
	  String path = cursor.getString(columnIndex);
	  cursor.close();               
	  return path;
	  // String path contains the path of selected Image  
	}

	public Bitmap LoadFromUri(String _uriAsString) {
		   Uri imageUri =  Uri.parse(_uriAsString);
	       InputStream imageStream;
	       Bitmap selectedImage= null;
			try {
				imageStream = controls.activity.getContentResolver().openInputStream(imageUri);
				selectedImage = BitmapFactory.decodeStream(imageStream);
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}        
	       return selectedImage;
	}
}

