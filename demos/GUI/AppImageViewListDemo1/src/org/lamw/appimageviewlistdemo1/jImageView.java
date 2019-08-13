package org.lamw.appimageviewlistdemo1;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.ByteBuffer;
import java.lang.reflect.Field;
import javax.microedition.khronos.opengles.GL10;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Path;
import android.graphics.PorterDuff.Mode;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PaintDrawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
//import android.support.design.widget.CollapsingToolbarLayout;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.view.Gravity;
import android.view.MotionEvent;
import android.widget.PopupMenu;


import java.io.FileOutputStream;
import java.io.File;

public class jImageView extends ImageView {
	//Pascal Interface
	private long           PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Cass for Event
	private jCommons LAMWCommon;
	//
	private OnClickListener onClickListener;   //
	public  Bitmap          bmp      = null;   //
	public  int             mAngle   = 0;
	
	Matrix mMatrix;
	int mRadius = 20;

	boolean mRounded = false;

	private int animationDurationIn = 1500;
	private int animationDurationOut = 1500;
	private int animationMode = 0; //none, fade, LeftToRight, RightToLeft


	//Constructor
	public  jImageView(android.content.Context context, Controls ctrls, long pasobj ) {
		super(context);

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);
		
		if (Build.VERSION.SDK_INT >= 21) {
			//[ifdef_api21up]
	     //this.setFitsSystemWindows(true);
	     	//[endif_api21up]
		}
		
		setScaleType(ImageView.ScaleType.CENTER);
		mMatrix = new Matrix();

		//Init Event
		/*onClickListener = new OnClickListener() {
			public  void onClick(View view) {
				controls.pOnClick(PasObj,Const.Click_Default);
			}
		};

		setOnClickListener(onClickListener);*/
		//this.setWillNotDraw(false); //false = fire OnDraw after Invalited ... true = not fire onDraw... thanks to tintinux			
	}
	
	public  boolean onTouchEvent( MotionEvent event) {
	      			
		int act     = event.getAction() & MotionEvent.ACTION_MASK;
		switch(act) {
			case MotionEvent.ACTION_DOWN: {
				switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				}
				break;}	
			case MotionEvent.ACTION_MOVE: {
				switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchMove,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchMove,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				}
				break;}
			case MotionEvent.ACTION_UP: {
				
				controls.pOnClick(PasObj,Const.Click_Default);
				
				switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				}
				break;}
			case MotionEvent.ACTION_POINTER_DOWN: {
				switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				}
				break;}
			case MotionEvent.ACTION_POINTER_UP  : {
				
				controls.pOnClick(PasObj,Const.Click_Default);
				
				switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				}
				break;}
		}
		return true;
	}

	public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		 String tag = ""+_left+"|"+_top+"|"+_right+"|"+_bottom;
	         this.setTag(tag);  //nedd by jsRecyclerView.java
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
	}


	public  void setParent( android.view.ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		if (bmp    != null) { bmp.recycle(); }
		bmp     = null;
		setImageBitmap(null);
		setImageResource(0); //android.R.color.transparent;
		onClickListener = null;
		setOnClickListener(null);
		mMatrix = null;
		LAMWCommon.free();		
	}
	
	// Bitmap scaling with smoothing
	private Bitmap GetResizedBitmap(Bitmap _bmp, int _newWidth, int _newHeight){		
		
		 // Get current dimensions
		 int width  = _bmp.getWidth();
		 int height = _bmp.getHeight();

		 // Determine how much to scale
		 float xScale = ((float) _newWidth) / width;
		 float yScale = ((float) _newHeight) / height;
		 
		// Create a matrix for the scaling and add the scaling data
		 Matrix matrix = new Matrix();
		 matrix.postScale(xScale, yScale);

		 // Create a new bitmap and convert it to a format understood by the ImageView
		 Bitmap scaledBitmap = Bitmap.createBitmap(_bmp, 0, 0, width, height, matrix, true);
		 BitmapDrawable result = new BitmapDrawable(scaledBitmap);
		 width  = scaledBitmap.getWidth();
		 height = scaledBitmap.getHeight();

		 // Apply the scaled bitmap
		 this.setImageDrawable(result);
		 this.invalidate();
		 
		 Drawable drawing = this.getDrawable();
		 Bitmap bitmap = ((BitmapDrawable)drawing).getBitmap();
		 return bitmap;
		}

	/*private Bitmap GetResizedBitmap(Bitmap _bmp, int _newWidth, int _newHeight){
		float factorH = _newHeight / (float)_bmp.getHeight();
		float factorW = _newWidth / (float)_bmp.getWidth();
		float factorToUse = (factorH > factorW) ? factorW : factorH;
		Bitmap bm = Bitmap.createScaledBitmap(_bmp,
				(int) (_bmp.getWidth() * factorToUse),
				(int) (_bmp.getHeight() * factorToUse),false);
		return bm;
	}*/

	public void SetBitmapImage(Bitmap _bitmap, int _width, int _height) {
		this.setImageResource(android.R.color.transparent);
		bmp = GetResizedBitmap(_bitmap, _width, _height);

		if (!mRounded)
		    this.setImageBitmap(bmp);
		else
			this.setImageBitmap(GetRoundedShape(bmp, 0));

		this.invalidate();
	}

	//http://stackoverflow.com/questions/10271020/bitmap-too-large-to-be-uploaded-into-a-texture
	public void SetBitmapImage(Bitmap bm) {

		this.setImageResource(android.R.color.transparent);  //erase image ??....

		if ( (bm.getHeight() > GL10.GL_MAX_TEXTURE_SIZE) || (bm.getWidth() > GL10.GL_MAX_TEXTURE_SIZE)) {
			//is is the case when the bitmap fails to load
			int nh = (int) ( bm.getHeight() * (1024.0 / bm.getWidth()) );
			Bitmap scaled = Bitmap.createScaledBitmap(bm,1024, nh, true);

			if (!mRounded)
				this.setImageBitmap(scaled);
			else
				this.setImageBitmap(GetRoundedShape(scaled, 0));

			bmp = scaled;
		}
		else{
			// for bitmaps with dimensions that lie within the limits, load the image normally
			if (Build.VERSION.SDK_INT >= 16) {  // why??
				BitmapDrawable ob = new BitmapDrawable(this.getResources(), bm);
//[ifdef_api16up]
				this.setBackground(ob);
//[endif_api16up]
				//this.setImageBitmap(bm);
				bmp = bm;

			} else {

				if (!mRounded)
					this.setImageBitmap(bm);
				else
					this.setImageBitmap(GetRoundedShape(bm, 0));

				bmp = bm;
			}
		}
		this.invalidate();
	}

	public  void setImage(String fullPath) {
		//if (bmp != null)        { bmp.recycle(); }
		this.setImageResource(android.R.color.transparent);
		if (fullPath.equals("null")) { this.setImageBitmap(null); return; };
		bmp = BitmapFactory.decodeFile(fullPath);

		if (!mRounded)
			this.setImageBitmap(bmp);
		else
			this.setImageBitmap(GetRoundedShape(bmp, 0));

		this.invalidate();
	}

	public int GetDrawableResourceId(String _resName) {
		try {
			Class<?> res = R.drawable.class;
			Field field = res.getField(_resName);  //"drawableName"
			int drawableId = field.getInt(null);
			return drawableId;
		}
		catch (Exception e) {
			//Log.e("jImageView", "Failure to get drawable id.", e);
			return 0;
		}
	}

	public Drawable GetDrawableResourceById(int _resID) {
		if( _resID == 0 ) return null; // by tr3e
		
		Drawable res = null;
		
		if (Build.VERSION.SDK_INT < 21 ) {
			res = this.controls.activity.getResources().getDrawable(_resID);
		}
		
		//[ifdef_api21up]
		if(Build.VERSION.SDK_INT >= 21)
			res = this.controls.activity.getResources().getDrawable(_resID, null);
        //[endif_api21up]
						
		return res;
	}

	public void SetImageByResIdentifier(String _imageResIdentifier) {
		Drawable d = GetDrawableResourceById(GetDrawableResourceId(_imageResIdentifier));
		
		if( d == null ) return;
		
		Bitmap b = ((BitmapDrawable)d).getBitmap();
		
		if( b == null ) return;
		
		bmp = GetResizedBitmap(b, b.getWidth(), b.getHeight());
		this.setImageResource(android.R.color.transparent);
		if (!mRounded)
			this.setImageBitmap(bmp);
		else
			this.setImageBitmap(GetRoundedShape(bmp, 0));
		//this.setImageDrawable(d);
		this.invalidate();
	}

	public void setLParamWidth(int _w) {
		LAMWCommon.setLParamWidth(_w);
	}

	public void setLParamHeight(int _h) {		
		LAMWCommon.setLParamHeight(_h);
	}

	public void SetLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
	}

	public void setLWeight(float _w) {
		LAMWCommon.setLWeight(_w);
	}

	public int getLParamHeight() {
		return  LAMWCommon.getLParamHeight();
	}

	public int getLParamWidth() {				
		return LAMWCommon.getLParamWidth();
	}

	public int GetBitmapHeight() {
		if (bmp != null) {
			return this.bmp.getHeight();
		} else return 0;
	}

	public int GetBitmapWidth() {
		if (bmp != null) {
			return this.bmp.getWidth();
		} else return 0;
	}

	public void addLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);
	}

	public void addLParamsParentRule(int rule) {
		LAMWCommon.addLParamsParentRule(rule);
	}

	public void setLayoutAll(int idAnchor) {
		LAMWCommon.setLayoutAll(idAnchor);
	}

	public void ClearLayoutAll() {
		LAMWCommon.clearLayoutAll();
	}

	/*
    * TScaleType = (scaleCenter, scaleCenterCrop, scaleCenterInside, scaleFitCenter,
                  scaleFitEnd, scaleFitStart, scaleFitXY, scaleMatrix);
    ref. http://www.peachpit.com/articles/article.aspx?p=1846580&seqNum=2
         hint: If you are creating a photo-viewing application,
               you will probably want to use the center or fitCenter scale types.
    */
	public void SetScaleType(int _scaleType) { //TODO!
		switch(_scaleType) {
			case 0: setScaleType(ImageView.ScaleType.CENTER); break;
			case 1: setScaleType(ImageView.ScaleType.CENTER_CROP); break;
			case 2: setScaleType(ImageView.ScaleType.CENTER_INSIDE); break;
			case 3: setScaleType(ImageView.ScaleType.FIT_CENTER); break;
			case 4: setScaleType(ImageView.ScaleType.FIT_END); break;
			case 5: setScaleType(ImageView.ScaleType.FIT_START); break;
			case 6: setScaleType(ImageView.ScaleType.FIT_XY); break;
			case 7: setScaleType(ImageView.ScaleType.MATRIX); break;
		}
	}	
	
	public void SetImageMatrixScale(float _scaleX, float _scaleY, float _centerX, float _centerY ) {
		
		if ( this.getScaleType() != ImageView.ScaleType.MATRIX)  
			this.setScaleType(ImageView.ScaleType.MATRIX);
		
		mMatrix.setScale(_scaleX, _scaleY, _centerX, _centerY);
		
		this.setImageMatrix(mMatrix);		
		this.invalidate();
	}

	public void SetImageMatrixScale(float _scaleX, float _scaleY ) {
		
		SetImageMatrixScale( _scaleX, _scaleY, 0, 0 );
	}

	public Bitmap GetBitmapImage() {
		return bmp;
	}


	public void SetImageFromIntentResult(Intent _intentData) {
		Uri selectedImage = _intentData.getData();
		String[] filePathColumn = { MediaStore.Images.Media.DATA };
		Cursor cursor = controls.activity.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
		cursor.moveToFirst();
		int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
		String picturePath = cursor.getString(columnIndex);
		cursor.close();
		bmp = BitmapFactory.decodeFile(picturePath);

		if (!mRounded)
			this.setImageBitmap(bmp);
		else
			this.setImageBitmap(GetRoundedShape(bmp, 0));

		this.invalidate();
	}

	public void SetImageThumbnailFromCamera(Intent _intentData) {
		Bundle extras = _intentData.getExtras();
		bmp = (Bitmap) extras.get("data");

		if (!mRounded)
			this.setImageBitmap(bmp);
		else
			this.setImageBitmap(GetRoundedShape(bmp, 0));

		this.invalidate();
	}

	//TODO Pascal
	public void SetImageFromURI(Uri _uri) {
		InputStream imageStream = null;
		try {
			imageStream = controls.activity.getContentResolver().openInputStream(_uri);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		bmp = BitmapFactory.decodeStream(imageStream);

		if (!mRounded)
			this.setImageBitmap(bmp);
		else
			this.setImageBitmap(GetRoundedShape(bmp, 0));

		this.invalidate();
	}

	public void SetImageFromByteArray(byte[] _image) {
		bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length);

		if (!mRounded)
			this.setImageBitmap(bmp);
		else
			this.setImageBitmap(GetRoundedShape(bmp, 0));

		this.invalidate();
	}

	public Bitmap GetDrawingCache() {
		this.setDrawingCacheEnabled(true);
		Bitmap b = Bitmap.createBitmap(this.getDrawingCache());
		this.setDrawingCacheEnabled(false);
		return b;
	}
	
	public void SetRoundCorner() {
		   if (this != null) {  		
			        PaintDrawable  shape =  new PaintDrawable();
			        shape.setCornerRadius(mRadius);                
			        int color = Color.TRANSPARENT;
			        Drawable background = this.getBackground();        
			        if (background instanceof ColorDrawable) {
			          color = ((ColorDrawable)this.getBackground()).getColor();
				        shape.setColorFilter(color, Mode.SRC_ATOP);        		           		        		        
				        //[ifdef_api16up]
				  	    if(Build.VERSION.SDK_INT >= 16) 
				             this.setBackground((Drawable)shape);
				        //[endif_api16up]			          
			        }                		  	  
		    }
	}
	
	public void SetRotation( int angle ){
		mAngle = angle;
		this.setRotation(mAngle);
	}
	
	public boolean SaveToJPG( String filePath, int cuality, int angle ){
		
		if( bmp == null ) return false;		

		File file = new File(filePath);
				
		//Overwrite file
		if( file.exists() ) if( !file.delete() ) return false;
		
		Matrix matrix = new Matrix();
	    matrix.postRotate(angle);
	    Bitmap bmpRot = Bitmap.createBitmap(bmp, 0, 0, bmp.getWidth(), bmp.getHeight(), matrix, true);			
		
		try {
			FileOutputStream fOut = new FileOutputStream(file);
			bmpRot.compress(Bitmap.CompressFormat.JPEG, cuality, fOut);
		    fOut.flush();
		    fOut.close();
		    
		    return true;
		} catch (Exception e) {
			return false;
		}
	}
	
    public boolean SaveToPNG( String filePath, int cuality, int angle ){
		
		if( bmp == null ) return false;		

		File file = new File(filePath);
		
		//Overwrite file
		if( file.exists() ) if( !file.delete() ) return false;
		
		Matrix matrix = new Matrix();
	    matrix.postRotate(angle);
	    Bitmap bmpRot = Bitmap.createBitmap(bmp, 0, 0, bmp.getWidth(), bmp.getHeight(), matrix, true);			
		
		try {
			FileOutputStream fOut = new FileOutputStream(file);
			bmpRot.compress(Bitmap.CompressFormat.PNG, cuality, fOut);
		    fOut.flush();
		    fOut.close();
		    
		    return true;
		} catch (Exception e) {
			return false;
		}
	}

	public void SetRadiusRoundCorner(int _radius) {
		mRadius =  _radius;
	}
		
	public void SetCollapseMode(int _collapsemode) {  //called on JNIPrompt
		LAMWCommon.setCollapseMode(_collapsemode);
	}
	
    public void	SetFitsSystemWindows(boolean _value) {
		LAMWCommon.setFitsSystemWindows(_value);
    }

    public void	SetScrollFlag(int _collapsingScrollFlag) {
 		LAMWCommon.setScrollFlag(_collapsingScrollFlag);
    }
    
    /*
    Change the view's z order in the tree, so it's on top of other sibling views.
    Prior to KITKAT/4.4/Api 19 this method should be followed by calls to requestLayout() and invalidate()
    on the view's parent to force the parent to redraw with the new child ordering.
  */
    
	public void BringToFront() {
		 ViewGroup parent = LAMWCommon.getParent();

		 this.bringToFront();

		 if (Build.VERSION.SDK_INT < 19 ) {

	       	if (parent!= null) {
	       		parent.requestLayout();
	       		parent.invalidate();	
	       	}
	     }

		if ( (animationDurationIn > 0)  && (animationMode != 0) ) {
			switch (animationMode) {
				case 1: {
					fadeInAnimation(this, animationDurationIn);
					break;
				}
				case 2: {  //RightToLeft
					slidefromRightToLeft(this, animationDurationIn);
					break;
				}
				case 3: {  //RightToLeft
					slidefromLeftToRight3(this, animationDurationIn);
					break;
				}

			}
		}

		if (animationMode == 0)
			this.setVisibility(android.view.View.VISIBLE);
	}

	public void SetVisibilityGone() {
		LAMWCommon.setVisibilityGone();
	}

        public ByteBuffer GetByteBuffer(int _width, int _height) {	  
	    ByteBuffer graphicBuffer = ByteBuffer.allocateDirect(_width*_height*4);    
            return graphicBuffer;    
        }

        public Bitmap GetBitmapFromByteBuffer(ByteBuffer _byteBuffer, int _width, int _height) {	 
	       _byteBuffer.rewind();  //reset position
	       bmp = Bitmap.createBitmap(_width, _height, Bitmap.Config.ARGB_8888);
          bmp.copyPixelsFromBuffer(_byteBuffer); 	
          return bmp;
        }

	public void SetImageFromByteBuffer(ByteBuffer _jbyteBuffer, int _width, int _height) {
		bmp = GetBitmapFromByteBuffer(_jbyteBuffer,_width,_height);

		if (!mRounded)
			this.setImageBitmap(bmp);
		else
			this.setImageBitmap(GetRoundedShape(bmp, 0));

		this.invalidate();

	}

	/*
	 * Making image in circular shape
	 * http://www.androiddevelopersolutions.com/2012/09/crop-image-in-circular-shape-in-android.html
	 */
	private Bitmap GetRoundedShape(Bitmap _bitmapImage, int _diameter) {
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

	private Bitmap GetRoundedShape(Bitmap _bitmapImage) {
		return GetRoundedShape(_bitmapImage, 0);
	}

	public void SetRoundedShape(boolean _value) {
		mRounded = _value;
	}

	//https://www.androidhive.info/2012/07/android-loading-image-from-url-http/
//http://www.viralandroid.com/2015/11/load-image-from-url-internet-in-android.html
	   /*
    Params : The type of the parameters sent to the task upon execution  //ex. "https://s3.amazonaws.com/TranscodeAppVideos/ocean.mp4"
    Progress : The type of the progress units published during the background computation
    Result : The type of the result of the background computation
     */

	public void LoadFromURL(String _url) {
		new LoadImageTask(this).execute(_url);
	}

	class LoadImageTask extends AsyncTask<String, Void, Bitmap> {
		ImageView imgView;
		public LoadImageTask(ImageView iv) {
			imgView = iv;
		}

		@Override
		protected Bitmap doInBackground(String... args) {
			try {
				return BitmapFactory.decodeStream((InputStream)new URL(args[0]).getContent());
			} catch (IOException e) {
				e.printStackTrace();
			}
			return null;
		}

		@Override
		protected void onPostExecute(Bitmap bitmap) {
			if (bitmap != null) {
				bmp = bitmap;
				imgView.setImageResource(android.R.color.transparent);
				if (!mRounded)
					imgView.setImageBitmap(bmp);
				else
					imgView.setImageBitmap(GetRoundedShape(bmp, 0));
				imgView.invalidate();
			} else {
				//
			}
		}
	}

	public void SaveToFile(String _filename) {
		if (bmp == null) return;
		Bitmap image = bmp.copy(Bitmap.Config.ARGB_8888, true);
		Canvas c = new Canvas(image);
		draw(c);
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream(_filename);
			if (fos != null) {
				if (_filename.toLowerCase().contains(".jpg"))
					image.compress(Bitmap.CompressFormat.JPEG, 90, fos);
				if (_filename.toLowerCase().contains(".png"))
					image.compress(Bitmap.CompressFormat.PNG, 100, fos);

				fos.close();
			}
		} catch (Exception e) {
			Log.e("SaveToFile", "Exception: " + e.toString());
		}
	}

	public View GetView() {
		return this;
	}

	public void ShowPopupMenu(String[] _items) {
		PopupMenu dropDownMenu = new PopupMenu(controls.activity, this);
		dropDownMenu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
			@Override
			public boolean onMenuItemClick(MenuItem menuItem) {
				//.makeText(getApplicationContext(), "You have clicked " + menuItem.getTitle(), Toast.LENGTH_LONG).show();
				controls.pOnImageViewPopupItemSelected(PasObj, menuItem.getTitle().toString());
				return true;
			}
		});
		//dropDownMenu.getMenu().add(caption);
		for (int i = 0; i < _items.length; i++) {
			dropDownMenu.getMenu().add(_items[i]);
		}
		dropDownMenu.show();
	}


	public void SetAnimationDurationIn(int _animationDurationIn) {
		animationDurationIn = _animationDurationIn;
	}

	public void SetAnimationDurationOut(int _animationDurationOut) {
		animationDurationOut = _animationDurationOut;
	}

	public void SetAnimationMode(int _animationMode) {
		animationMode = _animationMode;
	}

	/// https://www.codexpedia.com/android/android-fade-in-and-fade-out-animation-programatically/
	private void fadeInAnimation(final View view, int duration) {
		Animation fadeIn = new AlphaAnimation(0, 1);
		fadeIn.setInterpolator(new DecelerateInterpolator());
		fadeIn.setDuration(duration);
		fadeIn.setAnimationListener(new Animation.AnimationListener() {
			@Override
			public void onAnimationStart(Animation animation) {
			}
			@Override
			public void onAnimationEnd(Animation animation) {
				view.setVisibility(View.VISIBLE);
			}
			@Override
			public void onAnimationRepeat(Animation animation) {
			}
		});

		view.startAnimation(fadeIn);
	}

	private void fadeOutAnimation(final View view, int duration) {
		Animation fadeOut = new AlphaAnimation(1, 0);
		fadeOut.setInterpolator(new AccelerateInterpolator());
		fadeOut.setStartOffset(duration);
		fadeOut.setDuration(duration);
		fadeOut.setAnimationListener(new Animation.AnimationListener() {
			@Override
			public void onAnimationStart(Animation animation) {
			}
			@Override
			public void onAnimationEnd(Animation animation) {
				view.setVisibility(View.INVISIBLE);
			}
			@Override
			public void onAnimationRepeat(Animation animation) {
			}
		});
		view.startAnimation(fadeOut);
	}

	//https://stackoverflow.com/questions/20696801/how-to-make-a-right-to-left-animation-in-a-layout/20696822
	private void slidefromRightToLeft(View view, long duration) {
		TranslateAnimation animate;
		if (view.getHeight() == 0) {
			//controls.appLayout.getHeight(); // parent layout
			animate = new TranslateAnimation(controls.appLayout.getWidth(),
					0, 0, 0); //(xFrom,xTo, yFrom,yTo)
		} else {
			animate = new TranslateAnimation(view.getWidth(),0, 0, 0); // View for animation
		}
		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}

	private void slidefromLeftToRight(View view, long duration) {  //try

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		if (view.getHeight() == 0) {
			//controls.appLayout.getHeight(); // parent layout
			animate = new TranslateAnimation(0,
					controls.appLayout.getWidth(), 0, 0); //(xFrom,xTo, yFrom,yTo)
		} else {
			animate = new TranslateAnimation(0,view.getWidth(), 0, 0); // View for animation
		}

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}


	private void slidefromRightToLeft3(View view, long duration) {
		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		if (view.getHeight() == 0) {
			//controls.appLayout.getHeight(); // parent layout
			animate = new TranslateAnimation(0, -controls.appLayout.getWidth(),
					0, 0); //(xFrom,xTo, yFrom,yTo)
		} else {
			animate = new TranslateAnimation(0,-controls.appLayout.getWidth(),
					0, 0); // View for animation
		}

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}

	private void slidefromLeftToRight3(View view, long duration) {  //try

		TranslateAnimation animate;  //(0.0f, 0.0f, 1500.0f, 0.0f);
		if (view.getHeight() == 0) {
			//controls.appLayout.getHeight(); // parent layout
			animate = new TranslateAnimation(-controls.appLayout.getWidth(),
					0, 0, 0); //(xFrom,xTo, yFrom,yTo)
		} else {
			animate = new TranslateAnimation(-controls.appLayout.getWidth(),0, 0, 0); // View for animation
		}

		animate.setDuration(duration);
		animate.setFillAfter(true);
		view.startAnimation(animate);
		view.setVisibility(View.VISIBLE); // Change visibility VISIBLE or GONE
	}


}


