package org.lamw.appdrawinginbitmap;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.nio.ByteBuffer;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.text.TextPaint;
import android.util.Log;

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
	if( _resID == 0 ) return null; // by tr3e
	
	return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
}

//by jmpessoa
public  void loadRes(String imgResIdentifier) {
	    bmp = null;
	    
	    int id =	GetDrawableResourceId(imgResIdentifier);
	    
	    if( id == 0 ) return; // by tr3e
	    
	    BitmapFactory.Options bo = new BitmapFactory.Options();
	    bo.inScaled = false; 
	    bmp =  BitmapFactory.decodeResource(this.controls.activity.getResources(), id, bo);	
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

public Bitmap LoadFromFile(String _fullFilename) {  //pascal  "GetImageFromFile"
	 //if (bmp != null) { bmp.recycle(); }
	  BitmapFactory.Options bo = new BitmapFactory.Options();
	  bo.inScaled = false; 	   
          bmp = BitmapFactory.decodeFile(_fullFilename, bo);	  
          return bmp;
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

public Bitmap jInstance() {
    return this.bmp;
}

public Bitmap GetJInstance() {
     return this.bmp;
}

public byte[] GetByteArrayFromBitmap() {
  if(bmp == null) return null;
  
  ByteArrayOutputStream stream = new ByteArrayOutputStream();
  this.bmp.compress(CompressFormat.PNG, 0, stream); //O: PNG will ignore the quality setting...
  //Log.i("GetByteArrayFromBitmap","size="+ stream.size());
  return stream.toByteArray();
}

public void SetByteArrayToBitmap(byte[] image) {
	if(image == null) return;
	
	this.bmp = BitmapFactory.decodeByteArray(image, 0, image.length);
	//Log.i("SetByteArrayToBitmap","size="+ image.length);
}

public Bitmap ClockWise(Bitmap _bmp){
	
	  if(_bmp == null) return null;
		
	  Matrix matrix = new Matrix();
		
	  matrix.postRotate(90);
	  
	  return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), matrix, true);    
} 

public Bitmap AntiClockWise(Bitmap _bmp){
	
	  if(_bmp == null) return null;
		
	  Matrix matrix = new Matrix();
		
	  matrix.postRotate(-90);
	  
	  return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), matrix, true);    
}

public Bitmap SetScale(Bitmap _bmp, float _scaleX, float _scaleY ) {
	
	  if(_bmp == null) return null;
		
	  //CREATE A MATRIX FOR THE MANIPULATION	 
	  Matrix matrix = new Matrix();
	  // RESIZE THE BIT MAP
	  matrix.postScale(_scaleX, _scaleY);
	  // RECREATE THE NEW BITMAP 
		
	  return Bitmap.createBitmap(_bmp , 0, 0, _bmp.getWidth(), _bmp.getHeight(), matrix, true);	   
}

public Bitmap SetScale(float _scaleX, float _scaleY ) {      
		
		if(bmp == null) return null;
		// CREATE A MATRIX FOR THE MANIPULATION	 
		Matrix matrix = new Matrix();
		// RESIZE THE BIT MAP
		matrix.postScale(_scaleX, _scaleY);
		// RECREATE THE NEW BITMAP 
		return Bitmap.createBitmap(bmp, 0, 0, bmp.getWidth(), bmp.getHeight(), matrix, true);
}

public Bitmap LoadFromAssets(String strName)
{
  AssetManager assetManager = controls.activity.getAssets();
  InputStream istr = null;
  try {
      istr = assetManager.open(strName);
  } catch (IOException e) {
      e.printStackTrace();
      return null;
  }
  bmp = BitmapFactory.decodeStream(istr);    
  return bmp;
}

//ref http://sunil-android.blogspot.com.br/2013/03/resize-bitmap-bitmapcreatescaledbitmap.html
public Bitmap GetResizedBitmap(Bitmap _bmp, int _newWidth, int _newHeight){
 if( _bmp == null ) return null;
	
 float factorH = _newHeight / (float)_bmp.getHeight();
 float factorW = _newWidth / (float)_bmp.getWidth();
 float factorToUse = (factorH > factorW) ? factorW : factorH;
 Bitmap bm = Bitmap.createScaledBitmap(_bmp,
   (int) (_bmp.getWidth() * factorToUse),
   (int) (_bmp.getHeight() * factorToUse),false);     
 return bm;
}

public Bitmap GetResizedBitmap(int _newWidth, int _newHeight){
 if(bmp == null) return null;
	
 float factorH = _newHeight / (float)bmp.getHeight();
 float factorW = _newWidth / (float)bmp.getWidth();
 float factorToUse = (factorH > factorW) ? factorW : factorH;
 Bitmap bm = Bitmap.createScaledBitmap(bmp,
   (int) (bmp.getWidth() * factorToUse),
   (int) (bmp.getHeight() * factorToUse),false);     
 return bm;
}

public Bitmap GetResizedBitmap(float _factorScaleX, float _factorScaleY ){
 if(bmp == null) return null;
	
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
	if( _bmap == null ) return null;
	
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
	if( (_byteBuffer == null) || (bmp == null) ) return null;
	
	_byteBuffer.rewind();  //reset position
	bmp = Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888);					 
    bmp.copyPixelsFromBuffer(_byteBuffer); 	
    return bmp;
}

public Bitmap GetBitmapFromByteArray(byte[] _image) {
	if( _image == null ) return null;
 //this.bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length);
	bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length);
	return bmp;	
}


/*
 * Making image in circular shape
 * http://www.androiddevelopersolutions.com/2012/09/crop-image-in-circular-shape-in-android.html
 */
public Bitmap GetRoundedShape(Bitmap _bitmapImage, int _diameter) {
 if(_bitmapImage == null) return null;
 // TODO Auto-generated method stub	
 Bitmap sourceBitmap = _bitmapImage;
 Path path = new Path();
 
 int dim;
 if(_diameter == 0 ) { 
    dim = sourceBitmap.getHeight();
    if (dim > sourceBitmap.getWidth()) dim = sourceBitmap.getWidth();
 }
 else {
	 dim = _diameter;
	 int min;
	 
	 if (sourceBitmap.getWidth() <  sourceBitmap.getHeight())  
		 min = sourceBitmap.getWidth();
	 else
		 min = sourceBitmap.getHeight();
	  
	 if (dim > min) dim = min; 
 }
 
 int targetWidth = dim;
 int targetHeight = dim;

 Bitmap targetBitmap = Bitmap.createBitmap(targetWidth, 
         targetHeight,Bitmap.Config.ARGB_8888);

 Canvas canvas = new Canvas(targetBitmap);

 path.addCircle(((float) targetWidth - 1) / 2,
 ((float) targetHeight - 1) / 2,
 (Math.min(((float) targetWidth), 
               ((float) targetHeight)) / 2),
 Path.Direction.CCW);
 
 canvas.clipPath(path);
 
 canvas.drawBitmap(sourceBitmap, 
                               new Rect(0, 0, sourceBitmap.getWidth(),
                               sourceBitmap.getHeight()), 
                               new Rect(0, 0, targetWidth,
                               targetHeight), null);
 return targetBitmap;
}

//http://whats-online.info/science-and-tutorials/126/how-to-write-text-on-bitmap-image-in-android-programmatically/
public Bitmap GetRoundedShape(Bitmap _bitmapImage) {
	return GetRoundedShape(_bitmapImage, 0);
}

public Bitmap DrawText(Bitmap _bitmapImage, String _text, int _left, int _top, int _fontSize, int _color) {
    Canvas canvas = new Canvas(_bitmapImage);
    TextPaint textPaint = new TextPaint();
    textPaint.setFlags(Paint.ANTI_ALIAS_FLAG);
    textPaint.setColor(_color);
    float unit = controls.activity.getResources().getDisplayMetrics().density;
    textPaint.setTextSize(_fontSize*unit); //
    //Typeface assetsfont = Typeface.createFromAsset(controls.activity.getAssets(), _assetsFontName);
    //textPaint.setTypeface(assetsfont);
    canvas.drawText(_text, _left, _top, textPaint);
    return _bitmapImage;
}

    public Bitmap DrawText(String _text, int _left, int _top, int _fontSize, int _color) {

        if (bmp == null) return null;

        Bitmap mutableBitmap = bmp.copy(Bitmap.Config.ARGB_8888, true);
        Canvas canvas = new Canvas(mutableBitmap);
        TextPaint textPaint = new TextPaint();
        textPaint.setFlags(Paint.ANTI_ALIAS_FLAG);
        textPaint.setColor(_color);
        float unit = controls.activity.getResources().getDisplayMetrics().density;
        textPaint.setTextSize(_fontSize*unit); //
        canvas.drawText(_text, _left, _top, textPaint);

        bmp = mutableBitmap;
        return bmp;
    }

    public Bitmap DrawBitmap(Bitmap _bitmapImageIn, int _left, int _top) {

        if (bmp == null) return null;

        Bitmap mutableBitmap = bmp.copy(Bitmap.Config.ARGB_8888, true);

        Canvas canvas = new Canvas(mutableBitmap);
        Paint paint = new Paint();
        //float unit = controls.activity.getResources().getDisplayMetrics().density;
        canvas.drawBitmap(_bitmapImageIn, _left, _top, paint);

        bmp = mutableBitmap;

        return  bmp;
    }


    public void SaveToFileJPG(String _fullPathFileName) {
      if (bmp == null) return;
      File file;

      String f = _fullPathFileName.toLowerCase();
      if (f.contains(".jpg"))
        file = new File(_fullPathFileName);
      else
        file = new File(_fullPathFileName+".jpg");

      if (file.exists ()) file.delete();

      try {
            FileOutputStream out = new FileOutputStream(file);
            bmp.compress(Bitmap.CompressFormat.JPEG, 90, out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
      }

    }

    public void SetImage(Bitmap _bitmapImage) {
        bmp = _bitmapImage;
    }

    public Bitmap CreateBitmap(int _width, int _height, int _backgroundColor) {
        bmp = Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bmp);
        Paint paintBg = new Paint();
        paintBg.setColor(_backgroundColor); //Color.GRAY
        canvas.drawRect(0, 0, _width, _height, paintBg);
        return bmp;
    }

    // by Kordal
    public void LoadFromBuffer(byte[] buffer) {
        if (buffer == null) return;
        ByteArrayInputStream stream = new ByteArrayInputStream(buffer);
        this.bmp = BitmapFactory.decodeStream(stream);
    }

}
