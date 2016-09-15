package com.example.appdemo1;

import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;

import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

/*Draft java code by "Lazarus Android Module Wizard" [5/20/2016 3:18:58]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jDrawingView extends View /*dummy*/ { //please, fix what GUI object will be extended!

	private long       PasObj = 0;    // Pascal Object
	private Controls   controls  = null; // Control Class for events

	private Context context = null;
	private ViewGroup parent   = null;         // parent view
	private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH
	private OnClickListener onClickListener;   // click event

	private Boolean enabled  = true;           // click-touch enabled!

	private int lparamsAnchorRule[] = new int[30];
	private int countAnchorRule = 0;
	private int lparamsParentRule[] = new int[30];
	private int countParentRule = 0;

	//private int lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
	//private int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
	private int lparamH = 100;
	private int lparamW = 100;
	private int marginLeft = 0;
	private int marginTop = 0;
	private int marginRight = 0;
	private int marginBottom = 0;
	private int lgravity = Gravity.TOP | Gravity.START;
	private float lweight = 0;

	private boolean mRemovedFromParent = false;

	private Canvas          mCanvas = null;
	private Paint           mPaint  = null;

	private GestureDetector gDetect;
	private ScaleGestureDetector scaleGestureDetector;

	private float mScaleFactor = 1.0f;
	private float MIN_ZOOM = 0.25f;
	private float MAX_ZOOM = 4.0f;

	//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
	public jDrawingView(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
		super(_ctrls.activity);
		context   = _ctrls.activity;
		PasObj = _Self;
		controls  = _ctrls;

		lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B

		mPaint   = new Paint();

		//this.setWillNotDraw(false); //fire OnDraw

		onClickListener = new OnClickListener(){
			/*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!
				if (enabled) {
					//controls.pOnClick(PasObj, Const.Click_Default); //JNI event onClick!
				}
			};
		};
		setOnClickListener(onClickListener);

		gDetect = new GestureDetector(controls.activity, new GestureListener());
		scaleGestureDetector = new ScaleGestureDetector(controls.activity, new simpleOnScaleGestureListener());

	} //end constructor

	public void jFree() {
		if (parent != null) { parent.removeView(this); }
		//free local objects...
		lparams = null;
		setOnClickListener(null);
		mPaint = null;
		mCanvas = null;
		gDetect = null;
		scaleGestureDetector = null;
	}

	private static MarginLayoutParams newLayoutParams(ViewGroup aparent, ViewGroup.MarginLayoutParams baseparams) {
		if (aparent instanceof FrameLayout) {
			return new FrameLayout.LayoutParams(baseparams);
		} else if (aparent instanceof RelativeLayout) {
			return new RelativeLayout.LayoutParams(baseparams);
		} else if (aparent instanceof LinearLayout) {
			return new LinearLayout.LayoutParams(baseparams);
		} else if (aparent == null) {
			throw new NullPointerException("Parent is null");
		} else {
			throw new IllegalArgumentException("Parent is neither FrameLayout or RelativeLayout or LinearLayout: "
					+ aparent.getClass().getName());
		}
	}

	public void SetViewParent(ViewGroup _viewgroup) {
		if (parent != null) { parent.removeView(this); }
		parent = _viewgroup;

		parent.addView(this,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));
		lparams = null;
		lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();

		mRemovedFromParent = false;
	}

	public void RemoveFromViewParent() {
		if (!mRemovedFromParent) {
			this.setVisibility(android.view.View.INVISIBLE);
			if (parent != null)
				parent.removeView(this);
			mRemovedFromParent = true;
		}
	}

	public View GetView() {
		return this;
	}

	public void SetLParamWidth(int _w) {
		lparamW = _w;
	}

	public void SetLParamHeight(int _h) {
		lparamH = _h;
	}

	public void setLGravity(int _g) {
		lgravity = _g;
	}

	public void setLWeight(float _w) {
		lweight = _w;
	}

	public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		marginLeft = _left;
		marginTop = _top;
		marginRight = _right;
		marginBottom = _bottom;
		lparamH = _h;
		lparamW = _w;
	}

	public void AddLParamsAnchorRule(int _rule) {
		lparamsAnchorRule[countAnchorRule] = _rule;
		countAnchorRule = countAnchorRule + 1;
	}

	public void AddLParamsParentRule(int _rule) {
		lparamsParentRule[countParentRule] = _rule;
		countParentRule = countParentRule + 1;
	}

	public void SetLayoutAll(int _idAnchor) {
		lparams.width  = lparamW;
		lparams.height = lparamH;
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);

		if (lparams instanceof RelativeLayout.LayoutParams) {
			if (_idAnchor > 0) {
				for (int i = 0; i < countAnchorRule; i++) {
					((RelativeLayout.LayoutParams)lparams).addRule(lparamsAnchorRule[i], _idAnchor);
				}
			}
			for (int j = 0; j < countParentRule; j++) {
				((RelativeLayout.LayoutParams)lparams).addRule(lparamsParentRule[j]);
			}
		}
		if (lparams instanceof FrameLayout.LayoutParams) {
			((FrameLayout.LayoutParams)lparams).gravity = lgravity;
		}
		if (lparams instanceof LinearLayout.LayoutParams) {
			((LinearLayout.LayoutParams)lparams).weight = lweight;
		}
		//
		this.setLayoutParams(lparams);
	}

	public void ClearLayoutAll() {
		if (lparams instanceof RelativeLayout.LayoutParams) {
			for (int i = 0; i < countAnchorRule; i++) {
				((RelativeLayout.LayoutParams)lparams).removeRule(lparamsAnchorRule[i]);
			}

			for (int j = 0; j < countParentRule; j++) {
				((RelativeLayout.LayoutParams)lparams).removeRule(lparamsParentRule[j]);
			}
		}
		countAnchorRule = 0;
		countParentRule = 0;
	}

	public void SetId(int _id) { //wrapper method pattern ...
		this.setId(_id);
	}

	//write others [public] methods code here......
	//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

	@Override
	/*.*/public  boolean onTouchEvent( MotionEvent event) {
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

	@Override
	/*.*/public boolean dispatchTouchEvent(MotionEvent e) {
		super.dispatchTouchEvent(e);
		this.gDetect.onTouchEvent(e);
		this.scaleGestureDetector.onTouchEvent(e);
		return true;
	}

	//ref1. http://code.tutsplus.com/tutorials/android-sdk-detecting-gestures--mobile-21161
	//ref2. http://stackoverflow.com/questions/9313607/simpleongesturelistener-never-goes-in-to-the-onfling-method
	//ref3. http://x-tutorials.blogspot.com.br/2011/11/detect-pinch-zoom-using.html
	private class GestureListener extends GestureDetector.SimpleOnGestureListener {

		private static final int SWIPE_MIN_DISTANCE = 60;
		private static final int SWIPE_THRESHOLD_VELOCITY = 100;

		@Override
		public boolean onDown(MotionEvent event) {
			//Log.i("Down", "------------");
			return true;
		}

		@Override
		public boolean onFling(MotionEvent event1, MotionEvent event2, float velocityX, float velocityY) {

			if(event1.getX() - event2.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
				controls.pOnFlingGestureDetected(PasObj, 0);                //onRightToLeft;
				return  true;
			} else if (event2.getX() - event1.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
				controls.pOnFlingGestureDetected(PasObj, 1);//onLeftToRight();
				return true;
			}
			if(event1.getY() - event2.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
				controls.pOnFlingGestureDetected(PasObj, 2);//onBottomToTop();
				return false;
			} else if (event2.getY() - event1.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
				controls.pOnFlingGestureDetected(PasObj, 3); //onTopToBottom();
				return false;
			}
			return false;
		}
	}

	//ref. http://vivin.net/2011/12/04/implementing-pinch-zoom-and-pandrag-in-an-android-view-on-the-canvas/
	private class simpleOnScaleGestureListener extends SimpleOnScaleGestureListener {

		@Override
		public boolean onScale(ScaleGestureDetector detector) {
			mScaleFactor *= detector.getScaleFactor();
			mScaleFactor = Math.max(MIN_ZOOM, Math.min(mScaleFactor, MAX_ZOOM));
			// Log.i("tag", "onScale = "+ mScaleFactor);
			controls.pOnPinchZoomGestureDetected(PasObj, mScaleFactor, 1); //scalefactor->float
			return true;
		}

		@Override
		public boolean onScaleBegin(ScaleGestureDetector detector) {
			controls.pOnPinchZoomGestureDetected(PasObj, detector.getScaleFactor(), 0); //scalefactor->float
			//Log.i("tag", "onScaleBegin");
			return true;
		}

		@Override
		public void onScaleEnd(ScaleGestureDetector detector) {
			controls.pOnPinchZoomGestureDetected(PasObj, detector.getScaleFactor(), 2); //scalefactor->float
			//Log.i("tag", "onScaleEnd");
			super.onScaleEnd(detector);
		}

	}

	public Bitmap GetDrawingCache(){
		this.setDrawingCacheEnabled(true);
		Bitmap b = Bitmap.createBitmap(this.getDrawingCache());
		this.setDrawingCacheEnabled(false);
		return b;
	}

	//
	@Override
	/*.*/public  void onDraw(Canvas canvas) {
		mCanvas = canvas;
		controls.pOnDraw(PasObj, canvas);
	}

	public void SaveToFile(String _filename ) {
		Bitmap image = Bitmap.createBitmap( getWidth(), getHeight(), Bitmap.Config.ARGB_8888);
		Canvas c = new Canvas( image );
		draw( c );
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream( _filename );
			if (fos != null) {

				if ( _filename.toLowerCase().contains(".jpg") ) image.compress(Bitmap.CompressFormat.JPEG, 90, fos);
				if ( _filename.toLowerCase().contains(".png") ) image.compress(Bitmap.CompressFormat.PNG, 100, fos);

				fos.close();
			}
		}
		catch ( Exception e) {
			Log.e("jDrawingView_SaveImage1", "Exception: "+ e.toString() );
		}
	}

	public void SaveToFile(String _path, String _filename) {

		Bitmap image = Bitmap.createBitmap( getWidth(), getHeight(), Bitmap.Config.ARGB_8888);
		Canvas c = new Canvas( image );
		draw( c );

		File file = new File (_path +"/"+ _filename);
		if (file.exists ()) file.delete ();
		try {
			FileOutputStream out = new FileOutputStream(file);

			if ( _filename.toLowerCase().contains(".jpg") ) image.compress(Bitmap.CompressFormat.JPEG, 90, out);
			if ( _filename.toLowerCase().contains(".png") ) image.compress(Bitmap.CompressFormat.PNG, 100, out);

			out.flush();
			out.close();
		} catch (Exception e) {
			Log.e("jDrawingView_SaveToFile2", "Exception: "+ e.toString() );
		}
	}

	public int GetHeight() {
		return getHeight();
	}

	public int GetWidth() {
		return getWidth();
	}

	private Bitmap GetResizedBitmap(Bitmap _bitmap, int _newWidth, int _newHeight){
		float factorH = _newHeight / (float)_bitmap.getHeight();
		float factorW = _newWidth / (float)_bitmap.getWidth();
		float factorToUse = (factorH > factorW) ? factorW : factorH;
		Bitmap bm = Bitmap.createScaledBitmap(_bitmap,
				(int) (_bitmap.getWidth() * factorToUse),
				(int) (_bitmap.getHeight() * factorToUse),false);
		return bm;
	}

	public void DrawBitmap(Bitmap _bitmap, int _width, int _height) {
		Bitmap bmp = GetResizedBitmap(_bitmap, _width, _height);
		Rect rect = new Rect(0, 0, _width, _height);
		mCanvas.drawBitmap(bmp,null,rect,mPaint);
	}

	//0 , 0, w, h //int left/b, int top/l, int right/r, int bottom/t)
	public  void DrawBitmap(Bitmap _bitmap, int _left, int _top, int _right, int _bottom) {  //int b, int l, int r, int t 	
		    /* Figure out which way needs to be reduced less */
			/*
		    int scaleFactor = 1;
		    if ((right > 0) && (bottom > 0)) {
		        scaleFactor = Math.min(bitmap.getWidth()/(right-left), bitmap.getHeight()/(bottom-top));
		    }	
			*/
		Rect rect = new Rect(_left,_top, _right, _bottom);
		if ( (_bitmap.getHeight() > GL10.GL_MAX_TEXTURE_SIZE) || (_bitmap.getWidth() > GL10.GL_MAX_TEXTURE_SIZE)) {
			int nh = (int) ( _bitmap.getHeight() * (512.0 / _bitmap.getWidth()) );
			Bitmap scaled = Bitmap.createScaledBitmap(_bitmap,512, nh, true);
			mCanvas.drawBitmap(scaled,null,rect,mPaint);
		}
		else {
			mCanvas.drawBitmap(_bitmap,null,rect,mPaint);
		}
	}

	public  void SetPaintWidth(float _width) {
		mPaint.setStrokeWidth(_width);
	}

	public  void SetPaintStyle(int _style) {
		switch (_style) {
			case 0  : { mPaint.setStyle(Paint.Style.FILL           ); break; }
			case 1  : { mPaint.setStyle(Paint.Style.FILL_AND_STROKE); break; }
			case 2  : { mPaint.setStyle(Paint.Style.STROKE);          break; }
			default : { mPaint.setStyle(Paint.Style.FILL           ); break; }
		};
	}

	public  void SetPaintColor(int _color) {
		mPaint.setColor(_color);
	}

	public  void SetTextSize(float _textSize) {
		mPaint.setTextSize(_textSize);
	}

	public  void SetTypeface(int _typeface) {
		Typeface t = null;
		switch (_typeface) {
			case 0: t = Typeface.DEFAULT; break;
			case 1: t = Typeface.SANS_SERIF; break;
			case 2: t = Typeface.SERIF; break;
			case 3: t = Typeface.MONOSPACE; break;
		}
		mPaint.setTypeface(t);
	}

	public  void DrawLine(float _x1, float _y1, float _x2, float _y2) {
		mCanvas.drawLine(_x1,_y1,_x2,_y2,mPaint);
	}

	public  void DrawText(String _text, float _x, float _y ) {
		mCanvas.drawText(_text,_x,_y,mPaint);
	}

	public void DrawLine(float[] _points) {
		mCanvas.drawLines(_points, mPaint);
	}

	public void DrawPoint(float _x1, float _y1) {
		mCanvas.drawPoint(_x1,_y1,mPaint);
	}

	public void DrawCircle(float _cx, float _cy, float _radius) {
		mCanvas.drawCircle(_cx, _cy, _radius, mPaint);
	}

	public void DrawBackground(int _color) {
		mCanvas.drawColor(_color);
	}

	public void DrawRect(float _left, float _top, float _right, float _bottom) {
		mCanvas.drawRect(_left, _top, _right, _bottom, mPaint);
	}

	private int GetDrawableResourceId(String _resName) {
		try {
			Class<?> res = R.drawable.class;
			Field field = res.getField(_resName);  //"drawableName"
			int drawableId = field.getInt(null);
			return drawableId;
		}
		catch (Exception e) {
			//Log.e("jDrawingView", "Failure to get drawable id.", e);
			return 0;
		}
	}

	private Drawable GetDrawableResourceById(int _resID) {
		return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));
	}

	public void SetImageByResourceIdentifier(String _imageResIdentifier) {
		Drawable d = GetDrawableResourceById(GetDrawableResourceId(_imageResIdentifier));
		Bitmap bmp = ((BitmapDrawable)d).getBitmap();
		this.DrawBitmap(bmp);
		this.invalidate();
	}

	public void DrawBitmap(Bitmap _bitmap){
		int w = _bitmap.getWidth();
		int h = _bitmap.getHeight();
		Rect rect = new Rect(0, 0, w, h);
		Bitmap bmp = GetResizedBitmap(_bitmap, w, h);
		mCanvas.drawBitmap(bmp,null,rect,mPaint);	    		
		/*					  
	    if ( (_bitmap.getHeight() > GL10.GL_MAX_TEXTURE_SIZE) || (_bitmap.getWidth() > GL10.GL_MAX_TEXTURE_SIZE)) {								                   	   
			int nh = (int) ( _bitmap.getHeight() * (512.0 / _bitmap.getWidth()) );	
			Bitmap scaled = Bitmap.createScaledBitmap(_bitmap,512, nh, true);
			mCanvas.drawBitmap(scaled,null,rect,mPaint);			
		}
		else {
			mCanvas.drawBitmap(_bitmap,null,rect,mPaint);
		}
	    */
	}

	public void SetMinZoomFactor(float _minZoomFactor) {
		MIN_ZOOM = _minZoomFactor;
	}

	public void SetMaxZoomFactor(float _maxZoomFactor) {
		MAX_ZOOM = _maxZoomFactor;
	}

	public Canvas GetCanvas() {
		return mCanvas;
	}

} //end class

