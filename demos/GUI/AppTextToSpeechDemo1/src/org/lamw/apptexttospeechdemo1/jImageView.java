package org.lamw.apptexttospeechdemo1;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.lang.reflect.Field;
import javax.microedition.khronos.opengles.GL10;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.PorterDuff.Mode;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PaintDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.ImageView;

public class jImageView extends ImageView {
	//Pascal Interface
	private long           PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Cass for Event
	private jCommons LAMWCommon;
	//
	private OnClickListener onClickListener;   //
	public  Bitmap          bmp      = null;   //
	
	Matrix mMatrix;
	int mRadius = 20;

	//Constructor
	public  jImageView(android.content.Context context,
					   Controls ctrls,long pasobj ) {
		super(context);

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);

		//setAdjustViewBounds(false);
		setScaleType(ImageView.ScaleType.CENTER);
		mMatrix = new Matrix();

		//Init Event
		onClickListener = new OnClickListener() {
			public  void onClick(View view) {
				controls.pOnClick(PasObj,Const.Click_Default);
			}
		};

		setOnClickListener(onClickListener);
		//this.setWillNotDraw(false); //false = fire OnDraw after Invalited ... true = not fire onDraw... thanks to tintinux
	}

	public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
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

	private Bitmap GetResizedBitmap(Bitmap _bmp, int _newWidth, int _newHeight){
		float factorH = _newHeight / (float)_bmp.getHeight();
		float factorW = _newWidth / (float)_bmp.getWidth();
		float factorToUse = (factorH > factorW) ? factorW : factorH;
		Bitmap bm = Bitmap.createScaledBitmap(_bmp,
				(int) (_bmp.getWidth() * factorToUse),
				(int) (_bmp.getHeight() * factorToUse),false);
		return bm;
	}

	public void SetBitmapImage(Bitmap _bitmap, int _width, int _height) {
		this.setImageResource(android.R.color.transparent);
		bmp = GetResizedBitmap(_bitmap, _width, _height);
		this.setImageBitmap(bmp);
		this.invalidate();
	}

	//http://stackoverflow.com/questions/10271020/bitmap-too-large-to-be-uploaded-into-a-texture
	public void SetBitmapImage(Bitmap bm) {

		this.setImageResource(android.R.color.transparent);  //erase image ??....

		if ( (bm.getHeight() > GL10.GL_MAX_TEXTURE_SIZE) || (bm.getWidth() > GL10.GL_MAX_TEXTURE_SIZE)) {
			//is is the case when the bitmap fails to load
			int nh = (int) ( bm.getHeight() * (1024.0 / bm.getWidth()) );
			Bitmap scaled = Bitmap.createScaledBitmap(bm,1024, nh, true);
			this.setImageBitmap(scaled);
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
				this.setImageBitmap(bm);
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
		this.setImageBitmap(bmp);
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
		return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));
	}

	public void SetImageByResIdentifier(String _imageResIdentifier) {
		Drawable d = GetDrawableResourceById(GetDrawableResourceId(_imageResIdentifier));
		bmp = ((BitmapDrawable)d).getBitmap();
		this.setImageDrawable(d);
		this.invalidate();
	}

	public void setLParamWidth(int _w) {
		LAMWCommon.setLParamWidth(_w);
	}

	public void setLParamHeight(int _h) {		
		LAMWCommon.setLParamHeight(_h);
	}

	public void setLGravity(int _g) {
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

	public void SetImageMatrixScale(float _scaleX, float _scaleY ) {
		if ( this.getScaleType() != ImageView.ScaleType.MATRIX)  this.setScaleType(ImageView.ScaleType.MATRIX);	
		mMatrix.setScale(_scaleX, _scaleY);
		this.setImageMatrix(mMatrix);
		this.invalidate();
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
		this.setImageBitmap(bmp);
		this.invalidate();
	}

	public void SetImageThumbnailFromCamera(Intent _intentData) {
		Bundle extras = _intentData.getExtras();
		bmp = (Bitmap) extras.get("data");
		this.setImageBitmap(bmp);
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
		this.setImageBitmap(bmp);
		this.invalidate();
	}

	public void SetImageFromByteArray(byte[] _image) {
		bmp = BitmapFactory.decodeByteArray(_image, 0, _image.length);
		this.setImageBitmap(bmp);
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

	public void SetRadiusRoundCorner(int _radius) {
		mRadius =  _radius;
	}
}

