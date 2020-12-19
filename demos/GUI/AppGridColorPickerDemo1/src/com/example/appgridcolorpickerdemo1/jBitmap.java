package com.example.appgridcolorpickerdemo1;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
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
import android.graphics.drawable.BitmapDrawable;
import android.media.ThumbnailUtils;
import android.text.TextPaint;
import android.util.Base64;
import android.util.Log;

//-------------------------------------------------------------------------
// jBitmap
// Reviewed by TR3E on 10/10/2019
//-------------------------------------------------------------------------

public class jBitmap {
    //Java-Pascal Interface
    private long PasObj = 0;      // Pascal Obj
    private Controls controls = null;   // Control Class for Event
    public Bitmap bmp = null;

    //Constructor
    public jBitmap(Controls ctrls, long pasobj) {
//Connect Pascal I/F
        PasObj = pasobj;
        controls = ctrls;

    }

    public void loadFile(String fullFilename) {  //full file name!
    	
        if (bmp!=null)  bmp = null; // To call the garbage collector
        
        if (controls.GetDensityAssets() > 0) {
            BitmapFactory.Options bo = new BitmapFactory.Options();
            if (bo != null) {
                bo.inDensity = controls.GetDensityAssets();
                bmp = BitmapFactory.decodeFile(fullFilename, bo);
            } else
                bmp = BitmapFactory.decodeFile(fullFilename);
        } else
            bmp = BitmapFactory.decodeFile(fullFilename);

    }

    //by jmpessoa
    public void loadRes(String _imgResIdentifier) {
        Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(_imgResIdentifier));

        if (d == null) return;

        Bitmap b = ((BitmapDrawable) d).getBitmap();

        if (b == null) return;

        if (bmp!=null)  bmp = null;
        bmp = Bitmap.createScaledBitmap(b, b.getWidth(), b.getHeight(), true);
        // Drawable not need set density
    }

    //by jmpessoa
//BitmapFactory.Options options = new BitmapFactory.Options();
//options.inSampleSize = 4;
    public void loadFileEx(String fullFilename) {
        BitmapFactory.Options bo = new BitmapFactory.Options();
        if (bo != null) {

            if (controls.GetDensityAssets() > 0)
                bo.inDensity = controls.GetDensityAssets();

            bo.inSampleSize = 4; // --> 1/4
            
            if (bmp!=null)  bmp = null;
            
            bmp = BitmapFactory.decodeFile(fullFilename, bo);
        }
    }

    public void LoadFile(String _fullFilename, int _shrinkFactor) {

        BitmapFactory.Options bo = new BitmapFactory.Options();

        if (bo != null) {
            if (controls.GetDensityAssets() > 0)
                bo.inDensity = controls.GetDensityAssets();

            bo.inSampleSize = _shrinkFactor; // 4 --> 1/4
            
            if (bmp!=null)  bmp = null;
            
            bmp = BitmapFactory.decodeFile(_fullFilename, bo);
        }
    }

    public void createBitmap(int w, int h) {
        if (bmp!=null)  bmp = null;
        
        bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);

        if ((bmp != null) && (controls.GetDensityAssets() > 0))
            bmp.setDensity(controls.GetDensityAssets());
    }


	//by Tomash
	public int[] GetBitmapSizeFromFile(String _fullFilename) {
	    BitmapFactory.Options bo = new BitmapFactory.Options();
	    
	    int[] wh = new int[2];
		wh[1] = 0;
		wh[0] = 0;
		
		if( bo != null ){
	     bo.inJustDecodeBounds = true;
		 BitmapFactory.decodeFile(_fullFilename, bo);         
		 wh[1] = bo.outHeight;
		 wh[0] = bo.outWidth;
		}
		
		return wh;
	}

	//by Tomash
	private Bitmap SafeLoadFromFile(String _fullFilename) {
		Bitmap bm = null;
	    BitmapFactory.Options bo = new BitmapFactory.Options();

		int[] wh = GetBitmapSizeFromFile(_fullFilename); 
		int width = wh[0];
		int height = wh[1];
		
		// empiric...
		// TODO - depending on the capabilities of device?
		int maxWidth = 2048;
		int maxHeight = 2048;
		
		int inSampleSize = 1;

		if (height > maxHeight || width > maxWidth) {
			int halfHeight = height / 2;
			int halfWidth = width / 2;
			while ((halfHeight / inSampleSize) >= maxHeight && (halfWidth / inSampleSize) >= maxWidth) {
				inSampleSize *= 2;
			}
		}

		bo.inSampleSize = inSampleSize;
    
		try {
			bm = BitmapFactory.decodeFile(_fullFilename, bo);
		} catch (OutOfMemoryError e) {
			bm = SafeLoadFromFile2(_fullFilename);
		}
		     
		return bm;
	}
	
	//by Tomash
	private Bitmap SafeLoadFromFile2(String _fullFilename) {
		Bitmap bm = null;
	    BitmapFactory.Options bo = new BitmapFactory.Options();
		for (bo.inSampleSize = 1; bo.inSampleSize <= 32; bo.inSampleSize++) {
			try {
				bm = BitmapFactory.decodeFile(_fullFilename, bo);
				break;
			} catch (OutOfMemoryError outOfMemoryError) {
				//Log.e("BitmapSateLoadFromFile", "outOfMemoryError, sampleSize: " + bo.inSampleSize);
			}
		}
		return bm;		
	}	

    public Bitmap LoadFromFile(String _fullFilename) {  //pascal  "GetImageFromFile"
        Bitmap bm = null;
        BitmapFactory.Options bo = new BitmapFactory.Options();

        if (bo != null) {
            if (controls.GetDensityAssets() > 0)
                bo.inDensity = controls.GetDensityAssets();
			try {
				bm = BitmapFactory.decodeFile(_fullFilename, bo);
            } catch (OutOfMemoryError e2) {
            	bm = SafeLoadFromFile(_fullFilename);
            }
            
		} else {
			try {
				bm = BitmapFactory.decodeFile(_fullFilename);        
            } catch (OutOfMemoryError e) {
            	bm = SafeLoadFromFile(_fullFilename);
            }            
		}
		
		return bm;
    }


    public int[] getWH() {
        int[] wh = new int[2];

        wh[0] = 0; // width
        wh[1] = 0; // height

        if (bmp != null) {
            wh[0] = bmp.getWidth();
            wh[1] = bmp.getHeight();
        }

        return (wh);
    }

    public int GetWidth() {

        if (bmp != null) {
            return bmp.getWidth();

        } else return 0;

    }

    public int GetHeight() {

        if (bmp != null) {
            return bmp.getHeight();

        } else return 0;

    }

    public void Free() {
//bmp.recycle();
        if (bmp!=null)  bmp.recycle();
        bmp = null;
    }

    public Bitmap jInstance() {
        return this.bmp;
    }

    public Bitmap GetJInstance() {
        return this.bmp;
    }

    public  Canvas GetCanvas() {
        Canvas c = new Canvas(this.bmp);
        return c;
    }

    public byte[] GetByteArrayFromBitmap() {
        if (bmp == null) return null;

        ByteArrayOutputStream stream = new ByteArrayOutputStream();

        this.bmp.compress(CompressFormat.PNG, 0, stream); //O: PNG will ignore the quality setting...
        //Log.i("GetByteArrayFromBitmap","size="+ stream.size());
        return stream.toByteArray();
    }

    public void SetByteArrayToBitmap(byte[] image) {
        if (image == null) return;

        BitmapFactory.Options bo = new BitmapFactory.Options();

        if (bo == null) return;

        if (controls.GetDensityAssets() > 0)
            bo.inDensity = controls.GetDensityAssets();

        if (bmp!=null)  bmp = null;
        
        this.bmp = BitmapFactory.decodeByteArray(image, 0, image.length, bo);
        //Log.i("SetByteArrayToBitmap","size="+ image.length);
    }

    public Bitmap ClockWise(Bitmap _bmp) {

        if (_bmp == null) return null;

        Matrix matrix = new Matrix();

        matrix.postRotate(90);

        Bitmap bmpRotate = Bitmap.createBitmap(_bmp, 0, 0, _bmp.getWidth(), _bmp.getHeight(), matrix, true);

        if (bmpRotate != null)
            bmpRotate.setDensity(_bmp.getDensity());

        return bmpRotate;
    }

    public Bitmap AntiClockWise(Bitmap _bmp) {

        if (_bmp == null) return null;

        Matrix matrix = new Matrix();

        matrix.postRotate(-90);

        Bitmap bmpRotate = Bitmap.createBitmap(_bmp, 0, 0, _bmp.getWidth(), _bmp.getHeight(), matrix, true);

        if (bmpRotate != null)
            bmpRotate.setDensity(_bmp.getDensity());

        return bmpRotate;
    }

    public Bitmap SetScale(Bitmap _bmp, float _scaleX, float _scaleY) {

        if (_bmp == null) return null;

        //CREATE A MATRIX FOR THE MANIPULATION
        Matrix matrix = new Matrix();
        // RESIZE THE BIT MAP
        matrix.postScale(_scaleX, _scaleY);
        // RECREATE THE NEW BITMAP

        Bitmap bmpScale = Bitmap.createBitmap(_bmp, 0, 0, _bmp.getWidth(), _bmp.getHeight(), matrix, true);

        if (bmpScale != null)
            bmpScale.setDensity(_bmp.getDensity());

        return bmpScale;
    }

    public Bitmap SetScale(float _scaleX, float _scaleY) {

        if (bmp == null) return null;
        // CREATE A MATRIX FOR THE MANIPULATION
        Matrix matrix = new Matrix();
        // RESIZE THE BIT MAP
        matrix.postScale(_scaleX, _scaleY);
        // RECREATE THE NEW BITMAP
        Bitmap bmpScale = Bitmap.createBitmap(bmp, 0, 0, bmp.getWidth(), bmp.getHeight(), matrix, true);

        if ((bmpScale != null) && (controls.GetDensityAssets() > 0))
            bmpScale.setDensity(controls.GetDensityAssets());

        return bmpScale;
    }

    public Bitmap LoadFromAssets(String strName) {
        AssetManager assetManager = controls.activity.getAssets();
        InputStream istr = null;
        try {
            istr = assetManager.open(strName);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }

        if (bmp!=null)  bmp = null;
        
        if (controls.GetDensityAssets() > 0) {
            BitmapFactory.Options bo = new BitmapFactory.Options();
            if (bo != null) {
                bo.inDensity = controls.GetDensityAssets();
                bmp = BitmapFactory.decodeStream(istr, null, bo);
            } else
                bmp = BitmapFactory.decodeStream(istr);
        } else
            bmp = BitmapFactory.decodeStream(istr);

        return bmp;
    }

    //ref http://sunil-android.blogspot.com.br/2013/03/resize-bitmap-bitmapcreatescaledbitmap.html
    public Bitmap GetResizedBitmap(Bitmap _bmp, int _newWidth, int _newHeight) {
        if (_bmp == null) return null;

        float factorH = _newHeight / (float) _bmp.getHeight();
        float factorW = _newWidth / (float) _bmp.getWidth();

        float factorToUse = (factorH > factorW) ? factorW : factorH;

        Bitmap bm = Bitmap.createScaledBitmap(_bmp,
                (int) (_bmp.getWidth() * factorToUse),
                (int) (_bmp.getHeight() * factorToUse), true);

        if ((bm != null) && (controls.GetDensityAssets() > 0))
            bm.setDensity(_bmp.getDensity());

        return bm;
    }

    public Bitmap GetResizedBitmap(int _newWidth, int _newHeight) {
        if (bmp == null) return null;

        float factorH = _newHeight / (float) bmp.getHeight();
        float factorW = _newWidth / (float) bmp.getWidth();

        float factorToUse = (factorH > factorW) ? factorW : factorH;

        Bitmap bm = Bitmap.createScaledBitmap(bmp,
                (int) (bmp.getWidth() * factorToUse),
                (int) (bmp.getHeight() * factorToUse), true);

        if ((bm != null) && (controls.GetDensityAssets() > 0))
            bm.setDensity(bmp.getDensity());

        return bm;
    }

    public Bitmap GetResizedBitmap(float _factorScaleX, float _factorScaleY) {
        if (bmp == null) return null;

        float factorToUse = (_factorScaleY > _factorScaleX) ? _factorScaleX : _factorScaleY;

        Bitmap bm = Bitmap.createScaledBitmap(bmp,
                (int) (bmp.getWidth() * factorToUse),
                (int) (bmp.getHeight() * factorToUse), true);

        if ((bm != null) && (controls.GetDensityAssets() > 0))
            bm.setDensity(bmp.getDensity());

        return bm;
    }

    public ByteBuffer GetByteBuffer(int _width, int _height) {
        ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(_width * _height * 4);
        return graphicBuffer;
    }


    public ByteBuffer GetByteBufferFromBitmap(Bitmap _bmap) {
        if (_bmap == null) return null;

        int w = _bmap.getWidth();
        int h = _bmap.getHeight();
        //Log.i("w="+w, "h="+h); ok
        ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(w * h * 4);
        _bmap.copyPixelsToBuffer(graphicBuffer);
        graphicBuffer.rewind();  //reset position
        return graphicBuffer;
    }

    public ByteBuffer GetByteBufferFromBitmap() {

        if (bmp == null) return null;

        int w = bmp.getWidth();
        int h = bmp.getHeight();

        ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(w * h * 4);
        bmp.copyPixelsToBuffer(graphicBuffer);

        graphicBuffer.rewind();  //reset position

        return graphicBuffer;
    }

    public Bitmap GetBitmapFromByteBuffer(ByteBuffer _byteBuffer, int _width, int _height) {
        if ((_byteBuffer == null) || (bmp == null)) return null;

        _byteBuffer.rewind();  //reset position
        
        if (bmp!=null)  bmp = null;
        
        bmp = Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888);
        bmp.copyPixelsFromBuffer(_byteBuffer);

        if ((bmp != null) && (controls.GetDensityAssets() > 0))
            bmp.setDensity(bmp.getDensity());

        return bmp;
    }

    public Bitmap GetBitmapFromByteArray(byte[] _image) {
        if (_image == null) return null;

        if (bmp!=null)  bmp = null;
        
        if (controls.GetDensityAssets() > 0) {
            BitmapFactory.Options bo = new BitmapFactory.Options();
            if (bo != null) {
                bo.inDensity = controls.GetDensityAssets();
                bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length, bo);
            } else
                bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length);
        } else
            bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length);

        return bmp;
    }


    /*
     * Making image in circular shape
     * http://www.androiddevelopersolutions.com/2012/09/crop-image-in-circular-shape-in-android.html
     */
    public Bitmap GetRoundedShape(Bitmap _bitmapImage, int _diameter) {
        if (_bitmapImage == null) return null;
        // TODO Auto-generated method stub
        Bitmap sourceBitmap = _bitmapImage;
        Path path = new Path();

        int dim;
        if (_diameter == 0) {
            dim = sourceBitmap.getHeight();
            if (dim > sourceBitmap.getWidth()) dim = sourceBitmap.getWidth();
        } else {
            dim = _diameter;
            int min;

            if (sourceBitmap.getWidth() < sourceBitmap.getHeight())
                min = sourceBitmap.getWidth();
            else
                min = sourceBitmap.getHeight();

            if (dim > min) dim = min;
        }

        int targetWidth = dim;
        int targetHeight = dim;

        Bitmap targetBitmap = Bitmap.createBitmap(targetWidth,
                targetHeight, Bitmap.Config.ARGB_8888);

        if (targetBitmap == null) return null;

        targetBitmap.setDensity(_bitmapImage.getDensity());

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
        textPaint.setTextSize(_fontSize * unit); //
        //Typeface assetsfont = Typeface.createFromAsset(controls.activity.getAssets(), _assetsFontName);
        //textPaint.setTypeface(assetsfont);
        canvas.drawText(_text, _left, _top, textPaint);
        return _bitmapImage;
    }

    public Bitmap DrawText(String _text, int _left, int _top, int _fontSize, int _color) {

        if (bmp == null) return null;

        Bitmap mutableBitmap = bmp.copy(Bitmap.Config.ARGB_8888, true);
        mutableBitmap.setDensity(bmp.getDensity());

        Canvas canvas = new Canvas(mutableBitmap);
        TextPaint textPaint = new TextPaint();
        textPaint.setFlags(Paint.ANTI_ALIAS_FLAG);
        textPaint.setColor(_color);
        float unit = controls.activity.getResources().getDisplayMetrics().density;
        textPaint.setTextSize(_fontSize * unit); //
        canvas.drawText(_text, _left, _top, textPaint);

        if (bmp!=null)  bmp = null;
        bmp = mutableBitmap;

        return bmp;
    }

    public Bitmap DrawBitmap(Bitmap _bitmapImageIn, int _left, int _top) {

        if (bmp == null) return null;

        Bitmap mutableBitmap = bmp.copy(Bitmap.Config.ARGB_8888, true);
        mutableBitmap.setDensity(bmp.getDensity());

        Canvas canvas = new Canvas(mutableBitmap);
        Paint paint = new Paint();
        //float unit = controls.activity.getResources().getDisplayMetrics().density;
        canvas.drawBitmap(_bitmapImageIn, _left, _top, paint);

        if (bmp!=null)  bmp = null;
        bmp = mutableBitmap;

        return bmp;
    }


    public void SaveToFileJPG(String _fullPathFileName) {
        if (bmp == null) return;
        File file;

        String f = _fullPathFileName.toLowerCase();
        if (f.contains(".jpg"))
            file = new File(_fullPathFileName);
        else
            file = new File(_fullPathFileName + ".jpg");

        if (file.exists()) file.delete();

        try {
            FileOutputStream out = new FileOutputStream(file);
            bmp.compress(Bitmap.CompressFormat.JPEG, 90, out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }


    public void SaveToFileJPG(Bitmap _bitmapImage, String _Path) {
        if (_bitmapImage == null) return;
        File file;

        String f = _Path.toLowerCase();
        if (f.contains(".jpg"))
            file = new File(_Path);
        else
            file = new File(_Path + ".jpg");

        if (file.exists()) file.delete();

        try {
            FileOutputStream out = new FileOutputStream(file);
            _bitmapImage.compress(Bitmap.CompressFormat.JPEG, 90, out);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void SetImage(Bitmap _bitmapImage) {
        if (bmp!=null)  bmp = null;
        bmp = _bitmapImage;
    }

    public Bitmap CreateBitmap(int _width, int _height, int _backgroundColor) {
        if (bmp!=null)  bmp = null;
        bmp = Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888);

        if ((bmp != null) && (controls.GetDensityAssets() > 0))
            bmp.setDensity(controls.GetDensityAssets());

        Canvas canvas = new Canvas(bmp);
        Paint paintBg = new Paint();
        paintBg.setColor(_backgroundColor); //Color.GRAY
        canvas.drawRect(0, 0, _width, _height, paintBg);

        return bmp;
    }

    // by TR3E
    public void LoadFromBuffer(byte[] buffer) {
        if (buffer == null) return;

        ByteArrayInputStream stream = new ByteArrayInputStream(buffer);
        if (bmp!=null)  bmp = null;
        if (controls.GetDensityAssets() > 0) {
            BitmapFactory.Options bo = new BitmapFactory.Options();
            if (bo != null) {
                bo.inDensity = controls.GetDensityAssets();
                bmp = BitmapFactory.decodeStream(stream, null, bo);
            } else
                bmp = BitmapFactory.decodeStream(stream);
        } else {
            bmp = BitmapFactory.decodeStream(stream);
        }
    }

    public Bitmap LoadFromBuffer2(byte[] buffer) {
        if (buffer == null) return null;

        ByteArrayInputStream stream = new ByteArrayInputStream(buffer);

        if (bmp!=null)  bmp = null;
        if (controls.GetDensityAssets() > 0) {
            BitmapFactory.Options bo = new BitmapFactory.Options();
            if (bo != null) {
                bo.inDensity = controls.GetDensityAssets();
                bmp = BitmapFactory.decodeStream(stream, null, bo);
            } else
                bmp = BitmapFactory.decodeStream(stream);
        } else
            bmp = BitmapFactory.decodeStream(stream);

        return bmp;
    }

    //http://androidbridge.blogspot.com/2011/05/how-to-create-thumbnail-image-in.html
    public Bitmap GetThumbnailImage(String _fullPathFile, int thumbnailSize) {
        Bitmap thumbnailImage = null;
        try {
            FileInputStream fis = new FileInputStream(_fullPathFile);
            if (controls.GetDensityAssets() > 0) {
                BitmapFactory.Options bo = new BitmapFactory.Options();
                if (bo != null) {
                    bo.inDensity = controls.GetDensityAssets();
                    thumbnailImage = BitmapFactory.decodeStream(fis, null, bo);
                } else
                    thumbnailImage = BitmapFactory.decodeStream(fis);
            } else
                thumbnailImage = BitmapFactory.decodeStream(fis);
            
            if( thumbnailImage == null ) return null;

            int width = thumbnailImage.getWidth();
            int height = thumbnailImage.getHeight();
            float ratio = 1;
            if (width >= height)
                ratio = width / height;
            else
                ratio = height / width;
            thumbnailImage = ThumbnailUtils.extractThumbnail(thumbnailImage, (int) (thumbnailSize * ratio), thumbnailSize);
        } catch (Exception ex) {
            //
        }
        return thumbnailImage;
    }

    public Bitmap GetThumbnailImage(Bitmap _bitmap, int _thumbnailSize) {
    	if(_bitmap == null) return null;
    	
        Bitmap thumbnailImage = null;
        try {
            int width = _bitmap.getWidth();
            int height = _bitmap.getHeight();
            float ratio = width / height;

            if (width >= height)
                ratio = width / height;
            else
                ratio = height / width;

            thumbnailImage = ThumbnailUtils.extractThumbnail(_bitmap, (int) (_thumbnailSize * ratio), _thumbnailSize);
        } catch (Exception ex) {
            //
        }
        return thumbnailImage;
    }

    //https://www.rogerethomas.com/blog/generating-square-cropped-thumbnails-in-android-java
    public Bitmap GetThumbnailImage(Bitmap _bitmap, int _width, int _height) {
        return ThumbnailUtils.extractThumbnail(_bitmap, _width, _height);
    }

    public Bitmap GetThumbnailImage(String _fullFileName, int _width, int _height) {

        Bitmap thumbnailImage = null;
        Bitmap bitmap;

        if (controls.GetDensityAssets() > 0) {
            BitmapFactory.Options bo = new BitmapFactory.Options();
            if (bo != null) {
                bo.inDensity = controls.GetDensityAssets();
                bitmap = BitmapFactory.decodeFile(_fullFileName, bo);
            } else
                bitmap = BitmapFactory.decodeFile(_fullFileName);
        } else
            bitmap = BitmapFactory.decodeFile(_fullFileName);

        return ThumbnailUtils.extractThumbnail(bitmap, _width, _height);
    }

    public Bitmap GetThumbnailImageFromAssets(String _filename, int _width, int _height) {
        Bitmap bitmap = LoadFromAssets(_filename);
        return ThumbnailUtils.extractThumbnail(bitmap, _width, _height);
    }

    public Bitmap GetThumbnailImageFromAssets(String _filename, int thumbnailSize) {
        Bitmap bitmap = LoadFromAssets(_filename);
        Bitmap thumbnailImage = null;
        try {
            int width = bitmap.getWidth();
            int height = bitmap.getHeight();
            float ratio;
            if (width >= height)
                ratio = width / height;
            else
                ratio = height / width;
            thumbnailImage = ThumbnailUtils.extractThumbnail(bitmap, (int) (thumbnailSize * ratio), thumbnailSize);
        } catch (Exception ex) {
            //
        }
        return thumbnailImage;
    }

    //encode image to base64 string
    public String GetBase64StringFromImage(Bitmap _bitmap, int  _compressFormat) {
    	if(_bitmap == null) return "";
    	
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Bitmap bitmap = _bitmap;

        switch (_compressFormat) {
            case 0:
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos); break;
            case 1:
                bitmap.compress(CompressFormat.PNG, 100, baos); break;
        }

        byte[] imageBytes = baos.toByteArray();
        String imageString = Base64.encodeToString(imageBytes, Base64.DEFAULT);
        return imageString;
    }

    //encode image from file to base64 string
    public String GetBase64StringFromImageFile(String _fullPathToImageFile) {
        String encodedString = "";
        InputStream inputStream = null;//You can get an inputStream using any IO API
        try {
            inputStream = new FileInputStream(_fullPathToImageFile);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        byte[] bytes;
        byte[] buffer = new byte[8192];
        int bytesRead;
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        try {
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        bytes = output.toByteArray();
        encodedString = Base64.encodeToString(bytes, Base64.DEFAULT);
        return encodedString;
    }

    //decode base64 string to image
    public Bitmap GetImageFromBase64String(String _imageBase64String) {
        byte[] imageBytes = Base64.decode(_imageBase64String, Base64.DEFAULT);
        Bitmap decodedImage = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.length);
        return decodedImage;
    }

}
