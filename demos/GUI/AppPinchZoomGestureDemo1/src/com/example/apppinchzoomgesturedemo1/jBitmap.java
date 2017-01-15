package com.example.apppinchzoomgesturedemo1;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.nio.ByteBuffer;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.widget.ImageView;

//------------------------------------------------------------------------------
//Graphic API
//------------------------------------------------------------------------------
//http://forum.lazarus.freepascal.org/index.php?topic=21568.0
//https://github.com/alrieckert/lazarus/blob/master/lcl/interfaces/customdrawn/android/bitmap.pas

public class jBitmap {
//Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
public  Bitmap bmp    = null;

//Constructor
public  jBitmap(Controls ctrls, long pasobj ) {
//Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;

}

public  void loadFile(String fullFilename) {  //full file name!
//if (bmp != null) { bmp.recycle(); }
//Log.i("loadFile", filename);	
bmp = BitmapFactory.decodeFile(fullFilename);
}


//by jmpessoa
private int GetDrawableResourceId(String _resName) {
	  try {
	     Class<?> res = R.drawable.class;
	     Field field = res.getField(_resName);  //"drawableName"
	     int drawableId = field.getInt(null);
	     return drawableId;
	  }
	  catch (Exception e) {
	     Log.e("jBitmap", "Failure to get drawable id.", e);
	     return 0;
	  }
}

//by jmpessoa
private Drawable GetDrawableResourceById(int _resID) {
	return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
}

//by jmpessoa
public  void loadRes(String imgResIdentifier) {  //full file name!
	  //if (bmp != null) { bmp.recycle(); }
	  Drawable d = GetDrawableResourceById(GetDrawableResourceId(imgResIdentifier)); 
	  bmp =	  (( BitmapDrawable )d).getBitmap();
}

//by jmpessoa
//BitmapFactory.Options options = new BitmapFactory.Options();
//options.inSampleSize = 4;

public  void loadFileEx(String fullFilename) {
//if (bmp != null) { bmp.recycle(); }
BitmapFactory.Options options = new BitmapFactory.Options();
options.inSampleSize = 4; // --> 1/4
bmp = BitmapFactory.decodeFile(fullFilename, options);
}


public  void LoadFile(String _fullFilename, int _shrinkFactor) {
	 //if (bmp != null) { bmp.recycle(); }
	  BitmapFactory.Options options = new BitmapFactory.Options();
	  options.inSampleSize = _shrinkFactor; // 4 --> 1/4
	  bmp = BitmapFactory.decodeFile(_fullFilename, options);	  
}

public  void createBitmap(int w, int h) {
 //if (bmp != null) { bmp.recycle(); }
 bmp = Bitmap.createBitmap( w,h, Bitmap.Config.ARGB_8888 );
}

public  int[] getWH() {
int[] wh = new int[2];
wh[0] = 0; // width
wh[1] = 0; // height
if ( bmp != null ) {
wh[0] = bmp.getWidth();
wh[1] = bmp.getHeight();
}
return ( wh );
}

public  int GetWidth() {
	 
	if ( bmp != null ) {
	   return bmp.getWidth();
	  
	} else return 0;
	 
}

public  int GetHeight() {
	 
	if ( bmp != null ) {
	   return bmp.getHeight();
	  
	} else return 0;
	 
}

public  void Free() {
//bmp.recycle();
bmp = null;
}

//by jmpessoa
public  Bitmap jInstance() {
	  return this.bmp;
}

//by jmpessoa
public byte[] GetByteArrayFromBitmap() {
  ByteArrayOutputStream stream = new ByteArrayOutputStream();
  this.bmp.compress(CompressFormat.PNG, 0, stream); //O: PNG will ignore the quality setting...
  //Log.i("GetByteArrayFromBitmap","size="+ stream.size());
  return stream.toByteArray();
}

//by jmpessoa
public void SetByteArrayToBitmap(byte[] image) {
	this.bmp = BitmapFactory.decodeByteArray(image, 0, image.length);
	//Log.i("SetByteArrayToBitmap","size="+ image.length);
}

//http://androidtrainningcenter.blogspot.com.br/2012/05/bitmap-operations-like-re-sizing.html
public Bitmap ClockWise(Bitmap _bmp, ImageView _imageView){
  Matrix mMatrix = new Matrix();
  Matrix mat= _imageView.getImageMatrix();    
  mMatrix.set(mat);
  mMatrix.setRotate(90);
  return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), mMatrix, false);    
} 

public Bitmap AntiClockWise(Bitmap _bmp, ImageView _imageView){
  Matrix mMatrix = new Matrix();
  Matrix mat= _imageView.getImageMatrix();    
  mMatrix.set(mat);
  mMatrix.setRotate(-90);
  return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), mMatrix, false);    
}

public Bitmap SetScale(Bitmap _bmp, ImageView _imageView, float _scaleX, float _scaleY ) {  
  Matrix mMatrix = new Matrix();
  Matrix mat= _imageView.getImageMatrix();    
  mMatrix.set(mat);        
	mMatrix.setScale(_scaleX, _scaleY);
	return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), mMatrix, false);	   
}

public Bitmap SetScale(ImageView _imageView, float _scaleX, float _scaleY ) {      
	/*Matrix mMatrix = new Matrix();
  Matrix mat= _imageView.getImageMatrix();    
  mMatrix.set(mat);        
	mMatrix.setScale(_scaleX, _scaleY);		
	bmp = Bitmap.createBitmap(bmp , 0, 0, bmp.getWidth(), bmp.getHeight(), mMatrix, false);
	return bmp;*/
	// CREATE A MATRIX FOR THE MANIPULATION	 
	Matrix matrix = new Matrix();
	// RESIZE THE BIT MAP
	matrix.postScale(_scaleX, _scaleY);
	// RECREATE THE NEW BITMAP
	Bitmap resizedBitmap = Bitmap.createBitmap(bmp, 0, 0, bmp.getWidth(), bmp.getHeight(), matrix, false);
	return resizedBitmap;
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
  bmp = BitmapFactory.decodeStream(istr);    
  return bmp;
}

//ref http://sunil-android.blogspot.com.br/2013/03/resize-bitmap-bitmapcreatescaledbitmap.html
public Bitmap GetResizedBitmap(Bitmap _bmp, int _newWidth, int _newHeight){
 float factorH = _newHeight / (float)_bmp.getHeight();
 float factorW = _newWidth / (float)_bmp.getWidth();
 float factorToUse = (factorH > factorW) ? factorW : factorH;
 Bitmap bm = Bitmap.createScaledBitmap(_bmp,
   (int) (_bmp.getWidth() * factorToUse),
   (int) (_bmp.getHeight() * factorToUse),false);     
 return bm;
}

public Bitmap GetResizedBitmap(int _newWidth, int _newHeight){
 float factorH = _newHeight / (float)bmp.getHeight();
 float factorW = _newWidth / (float)bmp.getWidth();
 float factorToUse = (factorH > factorW) ? factorW : factorH;
 Bitmap bm = Bitmap.createScaledBitmap(bmp,
   (int) (bmp.getWidth() * factorToUse),
   (int) (bmp.getHeight() * factorToUse),false);     
 return bm;
}

public Bitmap GetResizedBitmap(float _factorScaleX, float _factorScaleY ){
 float factorToUse = (_factorScaleY > _factorScaleX) ? _factorScaleX : _factorScaleY;
 Bitmap bm = Bitmap.createScaledBitmap(bmp,
   (int) (bmp.getWidth() * factorToUse),
   (int) (bmp.getHeight() * factorToUse),false);     
 return bm;
}

public ByteBuffer GetByteBuffer(int _width, int _height) {	  
	ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(_width*_height*4);    
  return graphicBuffer;    
}


public ByteBuffer GetByteBufferFromBitmap(Bitmap _bmap) {	  
	int w =  _bmap.getWidth();
	int h =_bmap.getHeight();
	//Log.i("w="+w, "h="+h); ok
	ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(w*h*4);  	
	_bmap.copyPixelsToBuffer(graphicBuffer);
	graphicBuffer.rewind();  //reset position
  return graphicBuffer;    
}

public ByteBuffer GetByteBufferFromBitmap() {
	
	if (bmp == null) return null;
	
	int w =  bmp.getWidth();
	int h =bmp.getHeight();
	
	ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(w*h*4);  	
	bmp.copyPixelsToBuffer(graphicBuffer);
	
	graphicBuffer.rewind();  //reset position
	
  return graphicBuffer;    
}

public Bitmap GetBitmapFromByteBuffer(ByteBuffer _byteBuffer, int _width, int _height) {	 
	  _byteBuffer.rewind();  //reset position
	  bmp = Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888);					 
    bmp.copyPixelsFromBuffer(_byteBuffer); 	
    return bmp;
}

//by jmpessoa
public Bitmap GetBitmapFromByteArray(byte[] _image) {
 //this.bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length);
	bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length);
	return bmp;	
}

}



