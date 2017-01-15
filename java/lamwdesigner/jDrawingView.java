package com.example.appdrawingviewdemo1;

import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;

import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.util.SparseArray;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.View;
import android.view.ViewGroup;

/*Draft java code by "Lazarus Android Module Wizard" [5/20/2016 3:18:58]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jDrawingView extends View /*dummy*/ { //please, fix what GUI object will be extended!

	private long       pascalObj = 0;    // Pascal Object
	private Controls   controls  = null; // Control Class for events
	
	private jCommons LAMWCommon;

	private Context context = null;

	private Boolean enabled  = true;           // click-touch enabled!

	private Canvas          mCanvas = null;
	private Paint           mPaint  = null;
	
	private OnClickListener onClickListener;   // click event
	private GestureDetector gDetect;
	private ScaleGestureDetector scaleGestureDetector;

	private float mScaleFactor = 1.0f;
	private float MIN_ZOOM = 0.25f;
	private float MAX_ZOOM = 4.0f;
	
	int mPinchZoomGestureState = 3;//pzNone	
	int mFling = 0 ;
	
	float mPointX[];  //five fingers
	float mPointY[];  //five fingers
			
	int mCountPoint = 0;
	
	private SparseArray<PointF> mActivePointers;
	 
	//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
	public jDrawingView(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
		super(_ctrls.activity);
		context   = _ctrls.activity;
		pascalObj = _Self;
		controls  = _ctrls;

		LAMWCommon = new jCommons(this,context,pascalObj);
		
		mPaint   = new Paint();
		//this.setWillNotDraw(false); //fire OnDraw
		
		mCountPoint = 0;		 
		mActivePointers = new SparseArray<PointF>();
		
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
		//free local objects...
		mPaint = null;
		mCanvas = null;
		gDetect = null;
		setOnClickListener(null);		
		scaleGestureDetector = null;
		LAMWCommon.free();
	}

	public long GetPasObj() {
		return LAMWCommon.getPasObj();
	}

	public  void SetViewParent(ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}
	
	public ViewGroup GetParent() {
		return LAMWCommon.getParent();
	}
	
	public void RemoveFromViewParent() {
		LAMWCommon.removeFromViewParent();
	}

	public void SetLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);
	}
		
	public void SetLParamWidth(int w) {
		LAMWCommon.setLParamWidth(w);
	}

	public void SetLParamHeight(int h) {
		LAMWCommon.setLParamHeight(h);
	}
    
	public int GetLParamHeight() {
		return  LAMWCommon.getLParamHeight();
	}

	public int GetLParamWidth() {				
		return LAMWCommon.getLParamWidth();					
	}  

	public void SetLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
	}

	public void SetLWeight(float _w) {
		LAMWCommon.setLWeight(_w);
	}

	public void AddLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);
	}
	
	public void AddLParamsParentRule(int rule) {
		LAMWCommon.addLParamsParentRule(rule);
	}

	public void SetLayoutAll(int idAnchor) {
		LAMWCommon.setLayoutAll(idAnchor);
	}
	
	public void ClearLayoutAll() {		
		LAMWCommon.clearLayoutAll();
	}
	
	public View GetView() {
		return this;
	}


	public void SetId(int _id) { //wrapper method pattern ...
		this.setId(_id);
	}

	//write others [public] methods code here......
	//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
	
	@Override
	/*.*/public boolean dispatchTouchEvent(MotionEvent e) {
		super.dispatchTouchEvent(e);
		this.gDetect.onTouchEvent(e);
		this.scaleGestureDetector.onTouchEvent(e);
		return true;
	}

	//http://android-er.blogspot.com.br/2014/05/cannot-detect-motioneventactionmove-and.html
	//http://www.vogella.com/tutorials/AndroidTouch/article.html
    @Override
    public  boolean onTouchEvent( MotionEvent event) {    	
        int act = event.getAction() & MotionEvent.ACTION_MASK;      
        
        //get pointer index from the event object
        int pointerIndex = event.getActionIndex();
        // get pointer ID
        int pointerId = event.getPointerId(pointerIndex);
        
        switch(act) {
                           
            case MotionEvent.ACTION_DOWN: {
            	
            	PointF f = new PointF();            	
                f.x = event.getX(pointerIndex);
                f.y = event.getY(pointerIndex);
                mActivePointers.put(pointerId, f);
                
                
        		mPointX = new float[mActivePointers.size()];  //fingers
        		mPointY = new float[mActivePointers.size()];  //fingers

            	for (int size = mActivePointers.size(), i = 0; i < size; i++) {
                    PointF point = mActivePointers.valueAt(i);
                    if (point != null) {                        
                    	mPointX[i] = point.x;                     		
                        mPointY[i] = point.y;
                    }    
                }
            	
                controls.pOnDrawingViewTouch (pascalObj,Const.TouchDown,mActivePointers.size(),
                		mPointX, mPointY, mFling, mPinchZoomGestureState, mScaleFactor);                         
                
                break;
            } 
            
        
            case MotionEvent.ACTION_MOVE: {            	
            	
            	for (int size = event.getPointerCount(), i = 0; i < size; i++) {
                    PointF point = mActivePointers.get(event.getPointerId(i));
                    if (point != null) {                          	
                    	point.x = event.getX(i);
                        point.y = event.getY(i);
                    }
                }
            	            	
        		mPointX = new float[mActivePointers.size()];  //fingers
        		mPointY = new float[mActivePointers.size()];  //fingers
            	
            	for (int size = mActivePointers.size(), i = 0; i < size; i++) {
                    PointF point = mActivePointers.valueAt(i);
                    if (point != null) {                        
                    	mPointX[i] = point.x;                     		
                        mPointY[i] = point.y;
                    }    
                }
            	
                controls.pOnDrawingViewTouch (pascalObj, Const.TouchMove, mActivePointers.size(), 
                		mPointX, mPointY, mFling, mPinchZoomGestureState, mScaleFactor);                                                                                                          
                break;
            }
            
            
            case MotionEvent.ACTION_UP: {
            	
            	for (int size = event.getPointerCount(), i = 0; i < size; i++) {
                    PointF point = mActivePointers.get(event.getPointerId(i));
                    if (point != null) {                          	
                    	point.x = event.getX(i);
                        point.y = event.getY(i);
                    }
                }
            	
        		mPointX = new float[mActivePointers.size()];  //fingers
        		mPointY = new float[mActivePointers.size()];  //fingers
            	            	
            	for (int size = mActivePointers.size(), i = 0; i < size; i++) {
                    PointF point = mActivePointers.valueAt(i);
                    if (point != null) {                        
                    	mPointX[i] = point.x;                     		
                        mPointY[i] = point.y;
                    }    
                }
            	
               controls.pOnDrawingViewTouch (pascalObj,Const.TouchUp, mActivePointers.size(),
            		   mPointX, mPointY, mFling, mPinchZoomGestureState, mScaleFactor);              
               break;
             }  
            
            
            case MotionEvent.ACTION_POINTER_DOWN: {
            	
            	PointF f = new PointF();            	
                f.x = event.getX(pointerIndex);
                f.y = event.getY(pointerIndex);
                mActivePointers.put(pointerId, f);
                
        		mPointX = new float[mActivePointers.size()];  //fingers
        		mPointY = new float[mActivePointers.size()];  //fingers
                
            	for (int size = mActivePointers.size(), i = 0; i < size; i++) {
                    PointF point = mActivePointers.valueAt(i);
                    if (point != null) {                        
                    	mPointX[i] = point.x;                     		
                        mPointY[i] = point.y;
                    }    
                }
            	
                controls.pOnDrawingViewTouch (pascalObj,Const.TouchDown, mActivePointers.size(),
                		mPointX, mPointY, mFling, mPinchZoomGestureState, mScaleFactor);
                
                break;
            }
    
            case MotionEvent.ACTION_POINTER_UP: {
            	
            	for (int size = event.getPointerCount(), i = 0; i < size; i++) {
                    PointF point = mActivePointers.get(event.getPointerId(i));
                    if (point != null) {                          	
                    	point.x = event.getX(i);
                        point.y = event.getY(i);
                    }
                }
            	
        		mPointX = new float[mActivePointers.size()];  //fingers
        		mPointY = new float[mActivePointers.size()];  //fingers
            	
            	for (int size = mActivePointers.size(), i = 0; i < size; i++) {
                    PointF point = mActivePointers.valueAt(i);
                    if (point != null) {                        
                    	mPointX[i] = point.x;                     		
                        mPointX[i] = point.y;
                    }    
                }
            	
                controls.pOnDrawingViewTouch (pascalObj,Const.TouchUp, mActivePointers.size(),
                		mPointX, mPointY, mFling, mPinchZoomGestureState, mScaleFactor);
                
                break;
            }
            
            case MotionEvent.ACTION_CANCEL: {
                mActivePointers.remove(pointerId);
                break;
            }

            
            
        }

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
				 mFling = 0; //onRightToLeft;
				return  true;
			} else if (event2.getX() - event1.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
				 mFling = 1; //onLeftToRight();
				return true;
			}
			
			if(event1.getY() - event2.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
				 mFling = 2; //onBottomToTop();
				return false;
			} else if (event2.getY() - event1.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
				 mFling = 3; //onTopToBottom();
				return false;
			}
			
			return false;
		}
	}
        
	//ref. http://vivin.net/2011/12/04/implementing-pinch-zoom-and-pandrag-in-an-android-view-on-the-canvas/
	private class simpleOnScaleGestureListener extends SimpleOnScaleGestureListener {
        //TPinchZoomScaleState = (pzScaleBegin, pzScaling, pzScaleEnd, pxNone);
		@Override
		public boolean onScale(ScaleGestureDetector detector) {
			mScaleFactor *= detector.getScaleFactor();
			mScaleFactor = Math.max(MIN_ZOOM, Math.min(mScaleFactor, MAX_ZOOM));
			// Log.i("tag", "onScale = "+ mScaleFactor);
	        mPinchZoomGestureState = 1;	
			return true;
		}

		@Override
		public boolean onScaleBegin(ScaleGestureDetector detector) {
			mScaleFactor = detector.getScaleFactor();
			mPinchZoomGestureState = 0;
			//Log.i("tag", "onScaleBegin");
			return true;
		}

		@Override
		public void onScaleEnd(ScaleGestureDetector detector) {
			mScaleFactor = detector.getScaleFactor();
			mPinchZoomGestureState = 2;
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
	/*.*/public void onDraw(Canvas canvas) {
		mCanvas = canvas;		
        controls.pOnDrawingViewDraw(pascalObj,Const.TouchUp, mActivePointers.size(),
        		mPointX, mPointY, mFling, mPinchZoomGestureState, mScaleFactor);
		
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

