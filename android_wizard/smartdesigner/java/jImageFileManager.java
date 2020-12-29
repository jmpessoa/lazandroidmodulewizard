package org.lamw.appsharefiledemo2;

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

import android.graphics.ColorMatrixColorFilter;
import android.graphics.ColorMatrix;
import android.graphics.Paint;
import android.graphics.Canvas;

import android.content.ContentValues;
import android.media.MediaScannerConnection;
import android.content.ContentResolver;
import java.io.OutputStream;

//-------------------------------------------------------------------------
// jImageFileManager
// Reviewed by TR3E on 10/10/2019
//-------------------------------------------------------------------------

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

 public boolean SaveToSdCard(Bitmap _image, String _filename) {
	    if( _image == null ) return false;
	   	  	   
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
         return false;
	    }
	    
	    return true;
 }
 
 // By using this line you can able to see saved images in the gallery view.
 public void ShowImagesFromGallery () {	   	   	   
	   Intent intent = new Intent();  
	   intent.setAction(android.content.Intent.ACTION_VIEW);  
	   intent.setType("image/*");
	   intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	   controls.activity.startActivity(intent);
 }
 
 public Bitmap LoadFromSdCard(String _filename) {	   
	      String imageInSD = Environment.getExternalStorageDirectory().getPath()+"/"+_filename;
	      
	      BitmapFactory.Options bo = new BitmapFactory.Options();		
			
		  if( bo == null ) return null;
		    
		  if( controls.GetDensityAssets() > 0 )
		   bo.inDensity = controls.GetDensityAssets();
	      	      
	      return BitmapFactory.decodeFile(imageInSD, bo); 
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
		   return null; // Fix by tr3e
	   }
	   
	   return inputStream;
 }
 
 public Bitmap LoadFromURL(String _imageURL) {
	   
  BitmapFactory.Options bo = new BitmapFactory.Options();
  
  if( bo == null ) return null;
  
  if( controls.GetDensityAssets() > 0 )
   bo.inDensity = controls.GetDensityAssets();
  
  bo.inSampleSize = 1;
	   
  Bitmap bitmap = null;
  InputStream in = null;
  
  try {
      in = OpenHttpConnection(_imageURL);
      bitmap = BitmapFactory.decodeStream(in, null, bo);
      in.close();
  } catch (IOException e1) {
	  return null;
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
         return null; // Fix by tr3e
     }
     
     BitmapFactory.Options bo = new BitmapFactory.Options();
     
     if( bo == null ) return null;
     
     if( controls.GetDensityAssets() > 0 )
      bo.inDensity = controls.GetDensityAssets();
     
     return BitmapFactory.decodeStream(istr, null, bo);
 }
 
	public Bitmap LoadFromRawFolder(String pictureName)
	{
		Bitmap bitmap = null;
		
		BitmapFactory.Options bo = new BitmapFactory.Options();
	     
	    if( bo == null ) return null;
	     
	    if( controls.GetDensityAssets() > 0 )
	      bo.inDensity = controls.GetDensityAssets();

		int rID = controls.activity.getResources().getIdentifier(pictureName, "raw", controls.activity.getPackageName());
		
		if(rID != 0) 
		{
		 InputStream is = controls.activity.getResources().openRawResource(rID);
		 if (is != null) bitmap = BitmapFactory.decodeStream(is, null, bo);
		}
		
		return bitmap;
	}
           
 public Bitmap LoadFromResources(String _imageResIdentifier)
 {
	Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(_imageResIdentifier));
	
	if( d == null ) return null; // fix by tr3e
	
    return ((BitmapDrawable)d).getBitmap();
 }
 
 // by TR3E
 public Bitmap GetBitmapToGrayscale(Bitmap _bitmapImage)
 {   
		
	 if( _bitmapImage == null ) return null;
     
     int height = _bitmapImage.getHeight();
     int width  = _bitmapImage.getWidth();    

     Bitmap bmpGrayscale = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
     bmpGrayscale.setDensity( _bitmapImage.getDensity() );
     
     if(bmpGrayscale == null) return null;
     
     Canvas c = new Canvas(bmpGrayscale);
     Paint paint = new Paint();
     ColorMatrix cm = new ColorMatrix();
     
     if( (c == null) || (paint == null) || (cm == null) ) return null;
     
     cm.setSaturation(0);
     ColorMatrixColorFilter f = new ColorMatrixColorFilter(cm);
     paint.setColorFilter(f);
     
     c.drawBitmap(_bitmapImage, 0, 0, paint);
     
     return bmpGrayscale;
 }

 
 public Bitmap LoadFromFile(String _filename) {  //InternalAppStorage  !!!	   
	   Bitmap bmap=null;
	   
	   File fDir = this.controls.activity.getFilesDir();  //Result : /data/data/com/MyApp/files
	   File file = new File(fDir, _filename);
	   
	   InputStream fileInputStream = null;
	   
	   try {
		 fileInputStream = new FileInputStream(file);
		 BitmapFactory.Options bo = new BitmapFactory.Options();
		 
		 if( controls.GetDensityAssets() > 0 )
		      bo.inDensity = controls.GetDensityAssets();
		 
		 bo.inSampleSize = 1; //original image size :: 4 --> size 1/4!
		 bo.inJustDecodeBounds = false; //If set to true, the decoder will return null (no bitmap),
		 
		 bmap = BitmapFactory.decodeStream(fileInputStream, null, bo);		 
	   } catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		 e.printStackTrace();
		 return null;
	   }
	   
	   return bmap;  	   
 }
 
 public Bitmap LoadFromFile(String _path, String _filename) { //EnvironmentDirectoryPath  !!
	 
	    BitmapFactory.Options bo = new BitmapFactory.Options();
     
	    if( bo == null ) return null;
	     
	    if( controls.GetDensityAssets() > 0 )
	      bo.inDensity = controls.GetDensityAssets();
	  
	   return BitmapFactory.decodeFile(_path + "/" + _filename, bo); 
 }
 
 public boolean SaveToFile(Bitmap _image, String _filename) {
	    if( _image == null ) return false;
	    
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
	         return false;
	    }
	    
	    return true;
 }
    
 public boolean SaveToFile(Bitmap _image,String _path, String _filename) {	   	    
	    if( _image == null ) return false;
	 
	    File filePath = new File (_path);
	    filePath.mkdirs(); // don't forget to make the directory
	    
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
	         return false;
	    }
	    
	    return true;
}
 
 public boolean SaveToGallery(Bitmap bitmap, String folderName, String fileName)
 {
     OutputStream fos;
     File imageFile = null;
     Uri  imageUri  = null;
     boolean isPng  = true;
     
     if ( fileName.toLowerCase().contains(".jpg") ) isPng = false;
     else if ( !(fileName.toLowerCase().contains(".png")) ) fileName = fileName + ".png";
     
     if (android.os.Build.VERSION.SDK_INT >= 29) {
		 //[ifdef_api29up]
         ContentResolver resolver = context.getContentResolver();
         ContentValues contentValues = new ContentValues();
         contentValues.put(MediaStore.MediaColumns.DISPLAY_NAME, fileName);
         if(isPng) contentValues.put(MediaStore.MediaColumns.MIME_TYPE, "image/png");
         else      contentValues.put(MediaStore.MediaColumns.MIME_TYPE, "image/jpg");
         contentValues.put(MediaStore.MediaColumns.RELATIVE_PATH, 
        		 Environment.DIRECTORY_PICTURES + File.separator + folderName);
         imageUri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues);
         
         try{
          fos = resolver.openOutputStream(imageUri);
         } catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			return false;
		 }
		 //[endif_api29up]
     } else {
         String imagesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).toString() 
        		            + File.separator + folderName;
         
         imageFile = new File(imagesDir);
         
         if (!imageFile.exists()) {
             imageFile.mkdir();
         }
         
         imageFile = new File(imagesDir, fileName);
         
         try{
          fos = new FileOutputStream(imageFile);
         } catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			return false;
		 }
     }

     boolean saved = false;
     
     if(isPng) saved = bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos);
     else      saved = bitmap.compress(Bitmap.CompressFormat.JPEG, 90, fos);
     
     try{
      fos.flush();
      fos.close();
     } catch (IOException e) {
		// TODO Auto-generated catch block
		return false;
	 }

     if ((imageFile != null) && saved)  // pre Q     
         MediaScannerConnection.scanFile(context, new String[]{imageFile.toString()}, null, null);                               

     return saved;
 }

 public Bitmap LoadFromUri(Uri _imageUri) {
      InputStream imageStream;
      Bitmap selectedImage= null;
      
      BitmapFactory.Options bo = new BitmapFactory.Options();
	     
	  if( bo == null ) return null;
	     
	  if( controls.GetDensityAssets() > 0 )
	      bo.inDensity = controls.GetDensityAssets();
      
	  try {
			imageStream = controls.activity.getContentResolver().openInputStream(_imageUri);
			selectedImage = BitmapFactory.decodeStream(imageStream, null, bo);
	  } catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
	  }
	  
      return selectedImage;
 }
 
 public Bitmap LoadFromUri(String _uriAsString) {
	Uri imageUri =  Uri.parse(_uriAsString);
     
    return LoadFromUri(imageUri);
 }
       
 public  Bitmap LoadFromFile(String _filename, int _scale) {
	   BitmapFactory.Options bo = new BitmapFactory.Options();
     
	   if( bo == null ) return null;
	     
	   if( controls.GetDensityAssets() > 0 )
	      bo.inDensity = controls.GetDensityAssets();
	   
	   bo.inSampleSize = _scale; // --> 1/4
	   return BitmapFactory.decodeFile(_filename, bo);
 }

 public Bitmap CreateBitmap(int _width, int _height) {
	    Bitmap newbmp = Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888 );
	    
	    if( (newbmp != null) && (controls.GetDensityAssets() > 0) )
	    	newbmp.setDensity( controls.GetDensityAssets() );
	    
	    return newbmp;
 }
 
 public int GetBitmapWidth(Bitmap _bitmap) {	 	 
	 	if ( _bitmap != null ) {
	 	   return _bitmap.getWidth();	 	  
	 	} else 
	 	   return 0;	 	 
  }

  public  int GetBitmapHeight(Bitmap _bitmap) {	 
	 	if ( _bitmap != null ) {
	 	   return _bitmap.getHeight();	  
	 	} else 
	 	   return 0;	 
  }
	 
	public byte[] GetByteArrayFromBitmap(Bitmap _bitmap, String _compressFormat) {
		if( _bitmap == null ) return null; // by tr3e
	     
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
		if( _imageArray == null ) return null; // by tr3e
		
		BitmapFactory.Options bo = new BitmapFactory.Options();
	     
		if( bo == null ) return null;
		     
		if( controls.GetDensityAssets() > 0 )
		    bo.inDensity = controls.GetDensityAssets();
		
	    return BitmapFactory.decodeByteArray(_imageArray, 0, _imageArray.length, bo);
	}

	public Bitmap ClockWise(Bitmap _bitmap){
		return GetBitmapOrientation(_bitmap, 90);
	} 

	public Bitmap AntiClockWise(Bitmap _bitmap){
		return GetBitmapOrientation(_bitmap, -90);    
	}
	
	public Bitmap GetBitmapOrientation(Bitmap _bitmap, int _orientation){
		 if(_bitmap == null) return null; // by tr3e
		 
		 Matrix matrix = new Matrix();
			
		 matrix.postRotate(_orientation);
		 
	     Bitmap bmpRotate = Bitmap.createBitmap(_bitmap , 0, 0, _bitmap.getWidth(), _bitmap.getHeight(), matrix, true);
	     
	     if(bmpRotate != null)
	    	 bmpRotate.setDensity( _bitmap.getDensity() );
	     
	     return bmpRotate;
	}
	
	public Bitmap SetScale(Bitmap _bmp, float _scaleX, float _scaleY ) {      
		
		if(_bmp == null) return null;
		// CREATE A MATRIX FOR THE MANIPULATION	 
		Matrix matrix = new Matrix();
		// RESIZE THE BIT MAP
		matrix.postScale(_scaleX, _scaleY);
		// RECREATE THE NEW BITMAP
		Bitmap bmpScale = Bitmap.createBitmap(_bmp, 0, 0, _bmp.getWidth(), _bmp.getHeight(), matrix, true);
		
		if(bmpScale != null)
		   bmpScale.setDensity( _bmp.getDensity() );
		     
		return bmpScale; 
	}

	public Bitmap GetBitmapFromDecodedFile(String _imagePath) {
	   BitmapFactory.Options bo = new BitmapFactory.Options();
	     
	   if( bo == null ) return null;
		     
	   if( controls.GetDensityAssets() > 0 )
		    bo.inDensity = controls.GetDensityAssets();
		
	   return BitmapFactory.decodeFile(_imagePath, bo);
	}
	
	
	public Bitmap GetBitmapFromIntentResult(Intent _intentData) {						
		Uri selectedImage = _intentData.getData();
		
		if( selectedImage == null ) return null; // Fix by tr3e
		
		String[] filePathColumn = { MediaStore.Images.Media.DATA };	 
	    Cursor cursor = controls.activity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
	    
	    if( cursor == null ) return null; // Fix by tr3e
	    
	    cursor.moveToFirst();
	    int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
	    String picturePath = cursor.getString(columnIndex);
	    cursor.close();
	    
	    BitmapFactory.Options bo = new BitmapFactory.Options();
	     
		if( bo == null ) return null;
			     
		if( controls.GetDensityAssets() > 0 )
		    bo.inDensity = controls.GetDensityAssets();
	    
	    return BitmapFactory.decodeFile(picturePath, bo);    
	}
	
	//https://stackoverflow.com/questions/12726860/android-how-to-detect-the-image-orientation-portrait-or-landscape-picked-fro
	
	public int GetOrientation(Uri photoUri) 
	{
	    Cursor cursor = context.getContentResolver().query(photoUri,
	            new String[]{MediaStore.Images.ImageColumns.ORIENTATION}, null, null, null);

	    if (cursor.getCount() != 1) {
	        cursor.close();
	        return -1;
	    }

	    cursor.moveToFirst();
	    int orientation = cursor.getInt(0);
	    cursor.close();
	    cursor = null;
	    return orientation;
	}
	
	public int GetOrientation(String _uriAsString) {
		Uri imageUri =  Uri.parse(_uriAsString);
	     
	    return GetOrientation(imageUri);
	}	
	
	public Bitmap GetBitmapThumbnailFromCamera(Intent _intentData) {
		Bundle extras = _intentData.getExtras();
		
		if( extras == null ) return null; // Fix by tr3e
		
	    Bitmap bmpExtra = (Bitmap) extras.get("data");
	    
	    if( (bmpExtra != null) && (controls.GetDensityAssets() > 0) )
	    	bmpExtra.setDensity(controls.GetDensityAssets());
	    
	    return bmpExtra;
	}
	
	//TODO Pascal
	public String GetImageFilePath(Intent _intentData) {		   
		Uri selectedImage = _intentData.getData();
		  
		if( selectedImage == null ) return ""; // Fix by tr3e
		  
		String[] filePathColumn = { MediaStore.Images.Media.DATA };	   
		Cursor cursor = controls.activity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
		  
		if( cursor == null ) return ""; // Fix by tr3e
		  
		cursor.moveToFirst();
		int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
		String path = cursor.getString(columnIndex);
		cursor.close();               
		return path;
	    // String path contains the path of selected Image  
	}

}

