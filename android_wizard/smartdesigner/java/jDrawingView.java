package org.lamw.appdrawingviewdemo2;

import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import javax.microedition.khronos.opengles.GL10;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.CornerPathEffect;
import android.graphics.DashPathEffect;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Point;
import android.graphics.PointF;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.util.Log;
import android.util.SparseArray;
import android.util.TypedValue;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.View;
import android.view.ViewGroup;
import java.nio.charset.Charset;

/*Draft java code by "Lazarus Android Module Wizard" [5/20/2016 3:18:58]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jDrawingView extends View /*dummy*/ { //please, fix what GUI object will be extended!

    private long pascalObj = 0;    // Pascal Object
    private Controls controls = null; // Control Class for events

    private jCommons LAMWCommon;

    private Context context = null;

    private Boolean enabled = true;           // click-touch enabled!

    private Bitmap mBitmap;
    private Canvas mCanvas = null; //offscreen canvas
    private Paint mDrawPaint = null;
    private TextPaint mTextPaint = null;

    private Path mPath = null;
    private OnClickListener onClickListener;   // click event
    private GestureDetector gDetect;
    private ScaleGestureDetector scaleGestureDetector;

    private float mScaleFactor = 1.0f;
    private float mMinZoom = 0.25f;
    private float mMaxZoom = 4.0f;

    int mPinchZoomGestureState = 3;//pzNone
    int mFling = 0;

    float mPointX[];  //five fingers
    float mPointY[];  //five fingers

    int mCountPoint = 0;
    private SparseArray<PointF> mActivePointers;

    private int mBackgroundColor; // = Color.WHITE;
    private boolean mBufferedDraw = false;
    private int mWidth;
    private int mHeight;
    private Paint.Style mStyle;
	
	private long mLastClickTime    = 0;
	private int  mTimeClick        = 250;
	private int  mTimeDoubleClick  = 350;
    
	private final Charset UTF8_CHARSET = Charset.forName("UTF-8");

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jDrawingView(Controls _ctrls, long _Self, boolean _bufferedDraw, int _backgroundColor) { //Add more others news "_xxx"p arams if needed!
        super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
        mBufferedDraw = _bufferedDraw;

        if (_backgroundColor != 0)
            mBackgroundColor = _backgroundColor;
        else
            mBackgroundColor = Color.TRANSPARENT;

        this.setBackgroundColor(mBackgroundColor);

        //this.setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN);
        LAMWCommon = new jCommons(this, context, pascalObj);
        mTextPaint = new TextPaint();//new Paint();
        //mPaint.setStyle(Paint.Style.STROKE);
        mTextPaint.setFlags(Paint.ANTI_ALIAS_FLAG);
        float ts = mTextPaint.getTextSize();  //default 12
        float unit = controls.activity.getResources().getDisplayMetrics().density;
        mTextPaint.setTextSize(ts*unit); //ts * unit
        mDrawPaint = new Paint(); //used to draw shapes and  lines ...

        mPath = new Path();
        mCountPoint = 0;
        mActivePointers = new SparseArray<PointF>();

        onClickListener = new OnClickListener() {
            /*.*/
            public void onClick(View view) {  //please, do not remove /*.*/ mask for parse invisibility!
                if (enabled) {
                    //controls.pOnClick(PasObj, Const.Click_Default); //JNI event onClick!
                }
            }

            ;
        };
        setOnClickListener(onClickListener);

        gDetect = new GestureDetector(controls.activity, new GestureListener());
        scaleGestureDetector = new ScaleGestureDetector(controls.activity, new simpleOnScaleGestureListener());

        mStyle = mTextPaint.getStyle();
    } //end constructor

    public void jFree() {
        //free local objects...
        mTextPaint = null;
        mCanvas = null;
        gDetect = null;
        mDrawPaint = null;
        mBitmap = null;
        mPath = null;
        setOnClickListener(null);
        scaleGestureDetector = null;
        LAMWCommon.free();
    }

    public long GetPasObj() {
        return LAMWCommon.getPasObj();
    }

    public void SetViewParent(ViewGroup _viewgroup) {
        LAMWCommon.setParent(_viewgroup);
    }

    public ViewGroup GetParent() {
        return LAMWCommon.getParent();
    }

    public void RemoveFromViewParent() {
        LAMWCommon.removeFromViewParent();
    }

    public void SetLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
        LAMWCommon.setLeftTopRightBottomWidthHeight(left, top, right, bottom, w, h);
    }

    public void SetLParamWidth(int w) {
        LAMWCommon.setLParamWidth(w);
    }

    public void SetLParamHeight(int h) {
        LAMWCommon.setLParamHeight(h);
    }

    public int GetLParamHeight() {
        return LAMWCommon.getLParamHeight();
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

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    @Override
    /*.*/ public boolean dispatchTouchEvent(MotionEvent e) {
        super.dispatchTouchEvent(e);
        this.gDetect.onTouchEvent(e);
        this.scaleGestureDetector.onTouchEvent(e);
        return true;
    }

    //http://android-er.blogspot.com.br/2014/05/cannot-detect-motioneventactionmove-and.html
    //http://www.vogella.com/tutorials/AndroidTouch/article.html
    @Override
    public boolean onTouchEvent(MotionEvent event) {
        int act = event.getAction() & MotionEvent.ACTION_MASK;
        //get pointer index from the event object
        int pointerIndex = event.getActionIndex();
        // get pointer ID
        int pointerId = event.getPointerId(pointerIndex);

        switch (act) {
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
				
				byte mAction = Const.TouchDown;
				
				// double click event
				long mClickTime = controls.getTick();
				if ((mClickTime - mLastClickTime) < mTimeDoubleClick) {
					mAction = Const.DoubleClick;
				}		
				mLastClickTime = mClickTime;                   
				
				
                controls.pOnDrawingViewTouch(pascalObj, mAction/*Const.TouchDown*/, mActivePointers.size(),
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

                controls.pOnDrawingViewTouch(pascalObj, Const.TouchMove, mActivePointers.size(),
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
				
				// click event
				if ((controls.getTick() - mLastClickTime) < mTimeClick) {
					controls.pOnDrawingViewTouch(pascalObj, Const.Click, mActivePointers.size(),
                        mPointX, mPointY, mFling, mPinchZoomGestureState, mScaleFactor);
				}	
				
                controls.pOnDrawingViewTouch(pascalObj, Const.TouchUp, mActivePointers.size(),
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

                controls.pOnDrawingViewTouch(pascalObj, Const.TouchDown, mActivePointers.size(),
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

                controls.pOnDrawingViewTouch(pascalObj, Const.TouchUp, mActivePointers.size(),
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

            if (event1.getX() - event2.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
                mFling = 0; //onRightToLeft;
                return true;
            } else if (event2.getX() - event1.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
                mFling = 1; //onLeftToRight();
                return true;
            }

            if (event1.getY() - event2.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
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
            mScaleFactor = Math.max(mMinZoom, Math.min(mScaleFactor, mMaxZoom));
            mPinchZoomGestureState = 1;
            return true;
        }

        @Override
        public boolean onScaleBegin(ScaleGestureDetector detector) {
            mScaleFactor = detector.getScaleFactor();
            mPinchZoomGestureState = 0;
            return true;
        }

        @Override
        public void onScaleEnd(ScaleGestureDetector detector) {
            mScaleFactor = detector.getScaleFactor();
            mPinchZoomGestureState = 2;
            super.onScaleEnd(detector);
        }
    }

    public Bitmap GetDrawingCache() {
        if (mBufferedDraw) {
            return mBitmap;
        } else {
            this.setDrawingCacheEnabled(true);
            Bitmap b = Bitmap.createBitmap(this.getDrawingCache());
            this.setDrawingCacheEnabled(false);
            return b;
        }
    }
	
	public Paint GetPaint() {
		return mDrawPaint;
	}	
	
    @Override
    protected void onSizeChanged(int width, int height, int oldWidth, int oldHeight) {
        super.onSizeChanged(width, height, oldWidth, oldHeight);
        mWidth = width;
        mHeight = height;
        if (mBufferedDraw) {
            // Create bitmap, create canvas with bitmap, fill canvas with color.
            mBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            mCanvas = new Canvas(mBitmap);
            // Fill the Bitmap with the background color.
            if (mBackgroundColor != 0 )
                mCanvas.drawColor(mBackgroundColor);
            else
                mCanvas.drawColor(Color.WHITE);
        }
        controls.pOnDrawingViewSizeChanged(pascalObj, width, height, oldWidth, oldHeight);
    }

    //
    @Override
    /*.*/ public void onDraw(Canvas canvas) {
        //super.onDraw(canvas);
		if (mBufferedDraw)
            canvas.drawBitmap(mBitmap,0,0,null); //mDrawPaint  draw offscreen changes
        else
            mCanvas = canvas;
        controls.pOnDrawingViewDraw(pascalObj, Const.TouchUp, mActivePointers.size(),
                mPointX, mPointY, mFling, mPinchZoomGestureState, mScaleFactor);
    }

    public void SaveToFile(String _filename) {
        Bitmap image = Bitmap.createBitmap(getWidth(), getHeight(), Bitmap.Config.ARGB_8888);
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
            Log.e("jDrawingView_SaveImage1", "Exception: " + e.toString());
        }
    }

    public void SaveToFile(String _path, String _filename) {

        Bitmap image = Bitmap.createBitmap(getWidth(), getHeight(), Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(image);
        draw(c);

        File file = new File(_path + "/" + _filename);
        if (file.exists()) file.delete();
        try {
            FileOutputStream out = new FileOutputStream(file);

            if (_filename.toLowerCase().contains(".jpg"))
                image.compress(Bitmap.CompressFormat.JPEG, 90, out);
            if (_filename.toLowerCase().contains(".png"))
                image.compress(Bitmap.CompressFormat.PNG, 100, out);

            out.flush();
            out.close();
        } catch (Exception e) {
            Log.e("jDrawingView_Save", "Exception: " + e.toString());
        }
    }

    public int GetHeight() {
        return getHeight();
    }

    public int GetWidth() {
        return getWidth();
    }

    private Bitmap GetResizedBitmap(Bitmap _bitmap, int _newWidth, int _newHeight) {
        float factorH = _newHeight / (float) _bitmap.getHeight();
        float factorW = _newWidth / (float) _bitmap.getWidth();
        float factorToUse = (factorH > factorW) ? factorW : factorH;
        Bitmap bm = Bitmap.createScaledBitmap(_bitmap,
                (int) (_bitmap.getWidth() * factorToUse),
                (int) (_bitmap.getHeight() * factorToUse), false);
        return bm;
    }

 // in drawing functions where the rotation, translation or scale matrix is ​​not used, the following function calls are not needed:
  // mCanvas.save () ;
  // mCanvas.restore ();
  // example:
    public void DrawBitmap(Bitmap _bitmap, int _width, int _height) {

        if (mCanvas == null) return;

        Bitmap bmp = GetResizedBitmap(_bitmap, _width, _height);
        Rect rect = new Rect(0, 0, _width, _height);
        //mCanvas.save(); //  not needed! fixed by Kordal
        mCanvas.drawBitmap(bmp, null, rect, mDrawPaint);
        //mCanvas.restore(); // not needed!
    }

    // new by Kordal
    private String decodeUTF8(byte[] bytes) {
		return new String(bytes, UTF8_CHARSET);
        //return new String(bytes);
    }

    // new by Kordal
    public void DrawText(byte[] _text, float _x, float _y) {
		mCanvas.drawText(decodeUTF8(_text), _x, _y, mTextPaint);
    }
 
    public void DrawBitmap(Bitmap _bitmap, float _x, float _y, float _angleDegree) {

        if (mCanvas == null) return;

        int x = (int) _x;
        int y = (int) _y;
        Bitmap bmp = GetResizedBitmap(_bitmap, _bitmap.getWidth(), _bitmap.getHeight());
        mCanvas.save(); // needed, uses rotate matrix
        mCanvas.rotate(_angleDegree, x + _bitmap.getWidth() / 2, y + _bitmap.getHeight() / 2);
        mCanvas.drawBitmap(bmp, x, y, null);
        mCanvas.restore();
    }

    public void DrawCroppedBitmap(Bitmap _bitmap, float _x, float _y, int _cropOffsetLeft, int _cropOffsetTop, int _cropWidth, int _cropHeight) {
        if (mCanvas == null) return;
        Bitmap croppedBitmap = Bitmap.createBitmap(_bitmap,_cropOffsetLeft , _cropOffsetTop, _cropWidth, _cropHeight);
        int w = croppedBitmap.getWidth();
        int h = croppedBitmap.getHeight();
        Bitmap bmp = GetResizedBitmap(croppedBitmap, w, h);
        mCanvas.save();
        mCanvas.drawBitmap(bmp, (int)_x, (int)_y, null);
        mCanvas.restore();
    }

    public void DrawBitmap(Bitmap _bitmap, int _left, int _top, int _right, int _bottom) {
        /* Figure out which way needs to be reduced less */
			/*
		    int scaleFactor = 1;
		    if ((right > 0) && (bottom > 0)) {
		        scaleFactor = Math.min(bitmap.getWidth()/(right-left), bitmap.getHeight()/(bottom-top));
		    }
			*/
        if (mCanvas == null) return;

        Rect rect = new Rect(_left, _top, _right, _bottom);
        if ((_bitmap.getHeight() > GL10.GL_MAX_TEXTURE_SIZE) || (_bitmap.getWidth() > GL10.GL_MAX_TEXTURE_SIZE)) {
            int nh = (int) (_bitmap.getHeight() * (512.0 / _bitmap.getWidth()));
            Bitmap scaled = Bitmap.createScaledBitmap(_bitmap, 512, nh, true);
            mCanvas.save();
            mCanvas.drawBitmap(scaled, null, rect, mDrawPaint);
            mCanvas.restore();   //???
        } else {
            mCanvas.save();
            mCanvas.drawBitmap(_bitmap, null, rect, mDrawPaint);
            mCanvas.restore();
        }
    }

    public void SetPaintWidth(float _width) {
        mDrawPaint.setStrokeWidth(_width);
    }

    public void SetPaintStyle(int _style) {
        switch (_style) {
            case 0: {
                mDrawPaint.setStyle(mStyle);
                break;
            }
            case 1: {
                mDrawPaint.setStyle(Paint.Style.FILL);
                break;
            }
            case 2: {
                mDrawPaint.setStyle(Paint.Style.FILL_AND_STROKE);
                break;
            }
            case 3: {
                mDrawPaint.setStyle(Paint.Style.STROKE);
                break;
            }
        }
    }

    //https://guides.codepath.com/android/Basic-Painting-with-Views :: TODO DeviceDimensionsHelper.java utility
    public void SetPaintStrokeJoin(int _strokeJoin) {
        switch (_strokeJoin) {
            case 1: {
                mDrawPaint.setStrokeJoin(Paint.Join.ROUND);
                break;
            }
        }
    }

    public void SetPaintStrokeCap(int _strokeCap) {
        switch (_strokeCap) {
            case 1: {
                mDrawPaint.setStrokeCap(Paint.Cap.ROUND);
                break;
            }
        }
    }

    public void SetPaintCornerPathEffect(float _radius) {
        mDrawPaint.setPathEffect(new CornerPathEffect(_radius));
    }

    public void SetPaintDashPathEffect(float _lineDash, float _dashSpace, float _phase) {
        mDrawPaint.setPathEffect(new DashPathEffect(new float[]{_lineDash, _dashSpace}, _phase));
    }

    public void SetPaintColor(int _color) {
        mTextPaint.setColor(_color);
        mDrawPaint.setColor(_color);
    }

    public void SetTextSize(float _textSize) {
        float unit = controls.activity.getResources().getDisplayMetrics().density;
        mTextPaint.setTextSize(_textSize*unit); //_textSize * unit
    }

    public void SetTypeface(int _typeface) {
        Typeface t = null;
        switch (_typeface) {
            case 0: {
                t = Typeface.DEFAULT;
                break;}
            case 1: {
                t = Typeface.SANS_SERIF;
                break;}
            case 2: {
                t = Typeface.SERIF;
                break;}
            case 3: {
                t = Typeface.MONOSPACE;
                break;}
        }
        mTextPaint.setTypeface(t);
    }

    public void DrawLine(float _x1, float _y1, float _x2, float _y2) {
        if (mCanvas == null) return;
        mCanvas.drawLine(_x1, _y1, _x2, _y2, mDrawPaint);
    }

    public float[] GetTextBox(String _text, float _x, float _y) {
        float[] r = new float[4];
        r[0]= _x; //left
        r[1]= _y - GetTextHeight(_text); //top
        r[2]= _x + GetTextWidth(_text); //right
        r[3]= _y; //bottom
        return r;
    }

    class Pointf{
        public float x;
        public float y;
    }

    private Pointf[] GetTextBoxEx(String _text, float _x, float _y) {

        Pointf[] box = new Pointf[4];

        for(int i = 0; i < 4 ; i++)  {
            box[i] = new Pointf();
        }

        box[0].x = _x; //left
        box[0].y = _y - GetTextHeight(_text); //top

        box[1].x = _x + GetTextWidth(_text); //right
        box[1].y = _y - GetTextHeight(_text); //top

        box[2].x = _x; //left
        box[2].y = _y; //bottom

        box[3].x = _x + GetTextWidth(_text); //right
        box[3].y = _y; //bottom
        //DrawLine(box[0].x, box[0].y, box[1].x, box[1].y);
        //DrawLine(box[2].x, box[2].y, box[3].x, box[3].y);
        //DrawLine(box[0].x, box[0].y, box[2].x, box[2].y);
        //DrawLine(box[1].x, box[1].y, box[3].x, box[3].y);
        return box;
    }

    public float[] GetTextBox(String _text, float _x, float _y, float _angleDegree, boolean _rotateCenter) {

        if (mCanvas == null) return null;

        //draw bounding rect before rotating text
        Pointf[] box = GetTextBoxEx(_text, _x, _y);
        Pointf c;  //center
        float[] r8 = new float[8]; //return
        Rect rect = new Rect();
        mTextPaint.getTextBounds(_text, 0, _text.length(), rect);
        mCanvas.save();
        //rotate the canvas on center of the text to draw
        if (_rotateCenter) {
            mCanvas.rotate(_angleDegree, _x + rect.exactCenterX(), _y + rect.exactCenterY());
        }
        else {
            mCanvas.rotate(_angleDegree, _x, _y);
        }
        //mCanvas.drawText(_text, _x, _y, mTextPaint);
        mCanvas.restore();
        if (_rotateCenter) {
            c = GetTextCenter(box[0],box[3]);
        }else {
            c =  box[2];
        }
        Pointf[] rotatedBox =  GetRotatedBoxEx(box, c, _angleDegree);
        r8[0] = rotatedBox[0].x; //left-top
        r8[1] = rotatedBox[0].y;

        r8[2] = rotatedBox[1].x; //right-top
        r8[3] = rotatedBox[1].y;

        r8[4] = rotatedBox[2].x; //left-bottom
        r8[5] = rotatedBox[2].y;

        r8[6] = rotatedBox[3].x; //right-bottom
        r8[7] = rotatedBox[3].y;

        return r8;
    }

    public void DrawText(String _text, float _x, float _y) {
        if (mCanvas == null) return;
        mCanvas.drawText(_text, _x, _y, mTextPaint);
        //float[] r = GetTextBox(_text, _x, _y);
        //DrawRect(r[0],r[1],r[2], r[3]);
    }

    public float[] DrawTextEx(String _text, float _x, float _y) {
        DrawText(_text, _x, _y);
        float[] r = GetTextBox(_text, _x, _y);
        //DrawRect(r[0],r[1],r[2], r[3]);
        return r;
    }

    public void DrawText(String _text, float _x, float _y, float _angleDegree) {
        DrawText(_text, _x, _y, _angleDegree, false);
    }

    public Pointf GetTextCenter(Pointf d1, Pointf d2) {
        Pointf c = new Pointf();
        c.x = (d1.x +d2.x)/2;
        c.y = (d1.y + d2.y)/2;
        return c;
    }
    //https://stackoverflow.com/questions/20936429/rotating-a-rectangle-shaped-polygon-around-its-center-java
    public float[] rotatePoint(float x, float y, float cx, float cy, float angle) {

        float[] r = new float[2];

        float radian=(float)angle*3.14f/180;

        //TRANSLATE TO ORIGIN
        float x1 = x - cx;
        float y1 = y - cy;

        //APPLY ROTATION
        double temp_x1 =  (x1 * Math.cos(radian) - y1 * Math.sin(radian));
        double temp_y1 =  (x1 * Math.sin(radian) + y1 * Math.cos(radian));

        //TRANSLATE BACK
        r[0] = (float) temp_x1 + cx;
        r[1] = (float) temp_y1 + cy;

        return r;
    }

    public float[] GetRotatedBox(float x1, float y1, float x2, float y2, float _angleDegree) {
        float[] r = new float[4];
        float[] p;

        r[0] = x1;
        r[1] = y1;

        p = rotatePoint(x2, y2, x1, y1, _angleDegree);

        r[2] = p[0];
        r[3] = p[1];

        return r;
    }

    private Pointf[] GetRotatedBoxEx(Pointf[] box, Pointf _rotateCenter, float _angleDegree) {
        int count = box.length;
        float[] p;
        Pointf[] r = new Pointf[count];
        for(int i = 0; i < count ; i++)  {
            r[i] = new Pointf();
        }
        for(int i = 0; i < count; i++) {
            p = rotatePoint(box[i].x, box[i].y, _rotateCenter.x, _rotateCenter.y, _angleDegree);
            r[i].x = p[0];
            r[i].y = p[1];
        }
        return r;
    }

    public void DrawText(String _text, float _x, float _y, float _angleDegree, boolean _rotateCenter) {
        if (mCanvas == null) return;
        Rect rect = new Rect();
        mTextPaint.getTextBounds(_text, 0, _text.length(), rect);
        mCanvas.save();
        //rotate the canvas on center of the text to draw
        if (_rotateCenter) {
            mCanvas.rotate(_angleDegree, _x + rect.exactCenterX(), _y + rect.exactCenterY());
        }
        else {
            mCanvas.rotate(_angleDegree, _x, _y);
        }
        mCanvas.drawText(_text, _x, _y, mTextPaint);
        mCanvas.restore();
    }

    public float[] DrawTextEx(String _text, float _x, float _y, float _angleDegree, boolean _rotateCenter) {
        if (mCanvas == null) return null;
        //draw bounding rect before rotating text
        Pointf[] box = GetTextBoxEx(_text, _x, _y);
        Pointf c;  //center
        float[] r8 = new float[8]; //return

        Rect rect = new Rect();

        mTextPaint.getTextBounds(_text, 0, _text.length(), rect);
        mCanvas.save();
        //rotate the canvas on center of the text to draw
        if (_rotateCenter) {
            mCanvas.rotate(_angleDegree, _x + rect.exactCenterX(), _y + rect.exactCenterY());
        }
        else {
            mCanvas.rotate(_angleDegree, _x, _y);
        }
        mCanvas.drawText(_text, _x, _y, mTextPaint);
        mCanvas.restore();

        if (_rotateCenter) {
            c = GetTextCenter(box[0],box[3]);
        }else {
            c =  box[2];
        }
        Pointf[] rotatedBox =  GetRotatedBoxEx(box, c, _angleDegree);
        //DrawLine(rotatedBox[0].x, rotatedBox[0].y, rotatedBox[1].x, rotatedBox[1].y);
        // DrawLine(rotatedBox2].x, rotatedBox[2].y, rotatedBox[3].x, rotatedBox[3].y);
        //DrawLine(rotatedBox[0].x, rotatedBox[0].y, rotatedBox[2].x, rotatedBox[2].y);
        //DrawLine(rotatedBox[1].x, rotatedBox[1].y, rotatedBox[3].x, rotatedBox[3].y);
        r8[0] = rotatedBox[0].x; //left-top
        r8[1] = rotatedBox[0].y;

        r8[2] = rotatedBox[1].x; //right-top
        r8[3] = rotatedBox[1].y;

        r8[4] = rotatedBox[2].x; //left-bottom
        r8[5] = rotatedBox[2].y;

        r8[6] = rotatedBox[3].x; //right-bottom
        r8[7] = rotatedBox[3].y;

        return r8;
    }

    public float[] DrawTextEx(String _text, float _x, float _y, float _angleDegree) {
        float[] r8;
        r8 = DrawTextEx(_text,_x, _y, _angleDegree, false);
        return r8;
    }

        //by CC
    public void DrawTextAligned(String _text, float _left, float _top, float _right, float _bottom, float _alignHorizontal, float _alignVertical) {
        if (mCanvas == null) return;
        Rect bounds = new Rect();
        mTextPaint.getTextBounds(_text, 0, _text.length(), bounds);
        float x = _left + (_right - _left - bounds.width()) * _alignHorizontal;
        float y = _top + (_bottom - _top - bounds.height()) * _alignVertical + bounds.height();
        mCanvas.drawText(_text, x, y, mTextPaint);
    }

    public float[] DrawTextAlignedEx(String _text, float _left, float _top, float _right, float _bottom, float _alignHorizontal, float _alignVertical) {
        if (mCanvas == null) return null;
        Rect bounds = new Rect();
        mTextPaint.getTextBounds(_text, 0, _text.length(), bounds);
        float x = _left + (_right - _left - bounds.width()) * _alignHorizontal;
        float y = _top + (_bottom - _top - bounds.height()) * _alignVertical + bounds.height();
        mCanvas.drawText(_text, x, y, mTextPaint);
        float[] r = GetTextBox(_text, x, y);
        //DrawRect(r[0],r[1],r[2], r[3]);
        return r;
    }

    public void DrawLine(float[] _points) {
        if (mCanvas == null) return;
        mCanvas.drawLines(_points, mDrawPaint);
    }

    public void DrawPoint(float _x1, float _y1) {
        if (mCanvas == null) return;
        mCanvas.drawPoint(_x1, _y1, mDrawPaint);
    }

    public void DrawCircle(float _cx, float _cy, float _radius) {
        if (mCanvas == null) return;
        mCanvas.drawCircle(_cx, _cy, _radius, mDrawPaint);
    }

    public void DrawBackground(int _color) {
        //mBackgroundColor = _color;
        if (mCanvas == null) return;
        mCanvas.drawColor(_color);
    }

    public void DrawRect(float _left, float _top, float _right, float _bottom) {
        if (mCanvas == null) return;
        mCanvas.drawRect(_left, _top, _right, _bottom, mDrawPaint);
    }

    public void DrawRect(float _P0x, float _P0y,
                         float _P1x, float _P1y,
                         float _P2x, float _P2y,
                         float _P3x, float _P3y) {
        DrawLine(_P0x, _P0y, _P1x, _P1y); //top horiz
        DrawLine(_P1x, _P1y, _P3x, _P3y); //rigth vert
        DrawLine(_P3x, _P3y, _P2x, _P2y); //bottom horiz
        DrawLine(_P2x, _P2y, _P0x, _P0y); //left vert
    }

    public void DrawRect(float[] _box) {
        if (mCanvas == null) return;
        if (_box.length != 8) return;

        DrawLine(_box[0], _box[1], _box[2], _box[3]); //PO - P1
        DrawLine(_box[2], _box[3], _box[6], _box[7]); //P1 - P3
        DrawLine(_box[6], _box[7], _box[4], _box[5]); //P3 - P2
        DrawLine(_box[4], _box[5], _box[0], _box[1]); //P2 - P0
    }

    //https://thoughtbot.com/blog/android-canvas-drawarc-method-a-visual-guide
    public void DrawArc(float _leftRectF, float _topRectF, float _rightRectF, float _bottomRectF, float _startAngle, float _sweepAngle, boolean _useCenter) {
        if (mCanvas == null) return;
        RectF oval = new RectF(_leftRectF, _topRectF, _rightRectF, _bottomRectF);
        mCanvas.drawArc(oval, _startAngle, _sweepAngle, _useCenter, mDrawPaint);
    }

    public void DrawOval(float _leftRectF, float _topRectF, float _rightRectF, float _bottomRectF) {
        if (mCanvas == null) return;
        mCanvas.drawOval(new RectF(_leftRectF, _topRectF, _rightRectF, _bottomRectF), mDrawPaint);
    }

    public void SetImageByResourceIdentifier(String _imageResIdentifier) {
        
    	Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(_imageResIdentifier));
        
        if (d == null) return;

        Bitmap bmp = ((BitmapDrawable) d).getBitmap();
        this.DrawBitmap(bmp);
        this.invalidate();
    }

    public void DrawBitmap(Bitmap _bitmap) {
        if (mCanvas == null) return;
        int w = _bitmap.getWidth();
        int h = _bitmap.getHeight();
        Rect rect = new Rect(0, 0, w, h);
        Bitmap bmp = GetResizedBitmap(_bitmap, w, h);
        mCanvas.drawBitmap(bmp, null, rect, mDrawPaint);
    }

    public void SetMinZoomFactor(float _minZoomFactor) {
        mMinZoom = _minZoomFactor;
    }

    public void SetMaxZoomFactor(float _maxZoomFactor) {
        mMaxZoom = _maxZoomFactor;
    }

    public Canvas GetCanvas() {
        return mCanvas;
    }

    public Path GetPath(float[] _points) { // path.reset();
        int len = _points.length;
        mPath.reset();
        mPath.moveTo(_points[0], _points[1]);
        int i = 2;
        while ((i + 1) < len) {
            mPath.lineTo(_points[i], _points[i + 1]); //2,3  4,5
            i = i + 2;
        }
        //mPath.close();
        return mPath;
    }

    public Path GetPath() { // path.reset();
        return mPath;
    }

    public Path ResetPath() { // path.reset();
        mPath.reset();
        return mPath;
    }

    public Path ResetPath(Path _path) { // path.reset();
        _path.reset();
        return _path;
    }

    //CCW
    //counter-clockwise
    //	CW
    //clockwise
    public void AddCircleToPath(float _x, float _y, float _r, int _pathDirection) {
        Path.Direction dir = Path.Direction.CW;
        if (_pathDirection == 1) dir = Path.Direction.CCW;
        mPath.addCircle(_x, _y, _r, dir);
    }

    public void AddCircleToPath(Path _path, float _x, float _y, float _r, int _pathDirection) {
        Path.Direction dir = Path.Direction.CW;
        if (_pathDirection == 1) dir = Path.Direction.CCW;
        mPath.addCircle(_x, _y, _r, dir);
    }

    public Path GetNewPath(float[] _points) {
        int len = _points.length;
        //Log.i("len=",""+ len);
        Path path = new Path();
        path.moveTo(_points[0], _points[1]);
        int i = 2;
        while ((i + 1) < len) {
            path.lineTo(_points[i], _points[i + 1]); //2,3  4,5
            i = i + 2;
        }
        //path.close();
        return path;
    }

    public Path GetNewPath() {
        Path path = new Path();
        return path;
    }

    public Path AddPointsToPath(Path _path, float[] _points) {
        int len = _points.length;
        _path.moveTo(_points[0], _points[1]);
        int i = 2;
        while ((i + 1) < len) {
            _path.lineTo(_points[i], _points[i + 1]); //2,3  4,5
            i = i + 2;
        }
        //path.close();
        return _path;
    }

    public Path AddPathToPath(Path _srcPath, Path _targetPath, float _dx, float _dy) {
        _targetPath.addPath(_srcPath, _dx, _dy);
        return _targetPath;
    }

    public void DrawPath(Path _path) {
        if (mCanvas == null) return;
        //mPaint.setStyle(Paint.Style.STROKE);  //<----- important!  //seted in pascal side
        mCanvas.drawPath(_path, mDrawPaint);
    }

    public void DrawPath(float[] _points) {
        if (mCanvas == null) return;
        //mPaint.setStyle(Paint.Style.STROKE);  //<----- important!  //seted in pascal side
        mCanvas.drawPath(GetPath(_points), mDrawPaint);
    }

    public void DrawTextOnPath(Path _path, String _text, float _xOffset, float _yOffset) {
        if (mCanvas == null) return;
        //setLayerType(View.LAYER_TYPE_SOFTWARE, mPaint); // Required for API level 11 or higher.
        mCanvas.drawTextOnPath(_text, _path, _xOffset, _yOffset, mTextPaint);
        //setLayerType(View.LAYER_TYPE_SOFTWARE, mPaint); // Required for API level 11 or higher.
    }

    public void DrawTextOnPath(String _text, float _xOffset, float _yOffset) {
        if (mCanvas == null) return;
        if (!mPath.isEmpty()) {
            //setLayerType(View.LAYER_TYPE_SOFTWARE, mPaint); // Required for API level 11 or higher.
            mCanvas.drawTextOnPath(_text, mPath, _xOffset, _yOffset, mTextPaint);
        }
    }

    //https://blog.danlew.net/2013/10/03/centering_single_line_text_in_a_canvas/   TODO
    //https://ivankocijan.xyz/android-drawing-multiline-text-on-canvas/
    public void DrawTextMultiLine(String _text, float _left, float _top, float _right, float _bottom) {
        if (mCanvas == null) return;
        Rect bounds = new Rect((int) _left, (int) _top, (int) _right, (int) _bottom);
        //Static layout which will be drawn on canvas
        //bounds.width - width of the layout
        //Layout.Alignment.ALIGN_CENTER - layout alignment
        //1 - text spacing multiply
        //1 - text spacing add
        //true - include padding
        StaticLayout sl = new StaticLayout(_text, mTextPaint, bounds.width(), Layout.Alignment.ALIGN_CENTER, 1, 1, true);
        mCanvas.save();
        //calculate X and Y coordinates - In this case we want to draw the text in the
        //center of canvas so we calculate
        //text height and number of lines to move Y coordinate to center.
        float textHeight = getTextHeight(_text, mTextPaint);
        int numberOfTextLines = sl.getLineCount();
        float textYCoordinate = bounds.exactCenterY() - ((numberOfTextLines * textHeight) / 2);
        //text will be drawn from left
        float textXCoordinate = bounds.left;
        mCanvas.translate(textXCoordinate, textYCoordinate);
        //draws static layout on canvas
        sl.draw(mCanvas);
        mCanvas.restore();
    }

    private float getTextHeight(String text, Paint paint /*textPaint*/) {
        Rect rect = new Rect();
        paint.getTextBounds(text, 0, text.length(), rect);
        return rect.height();
    }

    public float GetTextHeight(String _text) {
        Rect rect = new Rect();
        mTextPaint.getTextBounds(_text, 0, _text.length(), rect);
        return rect.height();
    }

    public float GetTextWidth(String _text) {
        Rect rect = new Rect();
        mTextPaint.getTextBounds(_text, 0, _text.length(), rect);
        return rect.width();
    }

    //LMB
    public float GetTextLeft(String _text) {
        Rect rect = new Rect();
        mTextPaint.getTextBounds(_text, 0, _text.length(), rect);
        return rect.left;
    }
    //LMB
    public float GetTextBottom(String _text) {
        Rect rect = new Rect();
        mTextPaint.getTextBounds(_text, 0, _text.length(), rect);
        return rect.bottom;
    }

    public int GetViewportX(float _worldX, float _minWorldX, float _maxWorldX, int _viewPortWidth) {
        float escX;
        int r;
        escX = _viewPortWidth / (_maxWorldX - _minWorldX);
        r = (int) (escX * (_worldX - _minWorldX)); //round
        return r;
    }

    public int GetViewportY(float _worldY, float _minWorldY, float _maxWorldY, int _viewPortHeight) {
        float escY;
        int r;
        escY = -(_viewPortHeight - 10) / (_maxWorldY - _minWorldY);
        r = (int) (escY * (_worldY - _maxWorldY)); //round]
        return r;
    }

    public void Invalidate() {
        this.invalidate();
    }

    public void Clear(int _color) {
        if (mCanvas == null) return;
        if (_color != 0)
            mCanvas.drawColor(_color);
        else
            mCanvas.drawColor(Color.WHITE);
    }

    public void Clear() {
        if (mCanvas == null) return;
        if (mBackgroundColor != 0)
            mCanvas.drawColor(mBackgroundColor);
        else
            mCanvas.drawColor(Color.WHITE);
    }

    public void SetBufferedDraw(boolean _value) {
        mBufferedDraw = _value;
        if (mBufferedDraw) {
            // Create bitmap, create canvas with bitmap, fill canvas with color.
            if (mBitmap == null) {
                mBitmap = Bitmap.createBitmap(mWidth, mHeight, Bitmap.Config.ARGB_8888);
                mCanvas = new Canvas(mBitmap);
                // Fill the Bitmap with the background color.
                if (mBackgroundColor != 0)
                    mCanvas.drawColor(mBackgroundColor);
                else
                    mCanvas.drawColor(Color.WHITE);
            }
        }
    }

    public void SetFontAndTextTypeFace(int fontFace, int fontStyle) {
        Typeface t = null;
        switch (fontFace) {
            case 0: {
                t = Typeface.DEFAULT;
                break;}
            case 1: {
                t = Typeface.SANS_SERIF;
                break;}
            case 2: {
                t = Typeface.SERIF;
                break;}
            case 3:{
                t = Typeface.MONOSPACE;
                break;}
        }  //fontStyle = (tfNormal/0, tfBold/1, tfItalic/2, tfBoldItalic/3); //Typeface.BOLD_ITALIC
        mTextPaint.setTypeface(Typeface.create(t, fontStyle));
    }

    public void SetFontFromAssets(String _fontName) {   //   "fonts/font1.ttf"  or  "font1.ttf"
        Typeface customfont = Typeface.createFromAsset(controls.activity.getAssets(), _fontName);
        mTextPaint.setTypeface(customfont);
    }

    public void DrawTextFromAssetsFont(String _text, float _x, float _y, String _assetsFontName, int _size, int _color) {
        if (mCanvas == null) return;
        TextPaint textPaint = new TextPaint();
        textPaint.setFlags(Paint.ANTI_ALIAS_FLAG);
        textPaint.setColor(_color);
        float unit = controls.activity.getResources().getDisplayMetrics().density;
        textPaint.setTextSize(_size*unit); //
        Typeface assetsfont = Typeface.createFromAsset(controls.activity.getAssets(), _assetsFontName);
        textPaint.setTypeface(assetsfont);
        mCanvas.drawText(_text, _x, _y, textPaint);
    }

    public void SetBackgroundColor(int _backgroundColor) {
        mBackgroundColor = _backgroundColor;
        this.setBackgroundColor(mBackgroundColor);
    }

    //by Kordal
    public void DrawBitmap(Bitmap _bitMap, int _srcLeft, int _srcTop, int _srcRight, int _srcBottom, float _dstLeft, float _dstTop, float _dstRight, float _dstBottom) {
        if (mCanvas == null) return;
        Rect srcRect = new Rect(_srcLeft, _srcTop, _srcRight, _srcBottom);
        RectF dstRect = new RectF(_dstLeft, _dstTop, _dstRight, _dstBottom);
               
        mCanvas.drawBitmap(_bitMap, srcRect, dstRect, mDrawPaint);
    }
       
    public void DrawFrame(Bitmap _bitMap, int _srcX, int _srcY, int _srcW, int _srcH, float _X, float _Y, float _Wh, float _Ht, float _rotateDegree) {
        if (mCanvas == null) return;
        Rect srcRect = new Rect(_srcX, _srcY, _srcX + _srcW, _srcY + _srcH);
        RectF dstRect = new RectF(_X, _Y, _X + _Wh, _Y + _Ht);
               
        if (_rotateDegree != 0) {
            mCanvas.save();
            mCanvas.rotate(_rotateDegree, _X + _Wh / 2, _Y + _Ht / 2);
            mCanvas.drawBitmap(_bitMap, srcRect, dstRect, mDrawPaint);
            mCanvas.restore();
         } else {
            mCanvas.drawBitmap(_bitMap, srcRect, dstRect, mDrawPaint);
         }
    }
       
    public void DrawFrame(Bitmap _bitMap, float _X, float _Y, int _Index, int _Size, float _scaleFactor, float _rotateDegree) {
          float sf = _Size * _scaleFactor;
          DrawFrame(_bitMap, _Index % (_bitMap.getWidth() / _Size) * _Size, _Index / (_bitMap.getWidth() / _Size) * _Size, _Size, _Size, _X, _Y, sf, sf, _rotateDegree);
    }

    //by Kordal
    public void DrawRoundRect(float _left, float _top, float _right, float _bottom, float _rx, float _ry) {
        if (mCanvas == null) return;
        //[ifdef_api21up]
        if (Build.VERSION.SDK_INT >= 21) {
            mCanvas.drawRoundRect(_left, _top, _right, _bottom, _rx, _ry, mDrawPaint);
        }//[endif_api21up]

    }

    //by Kordal
    public void SetTimeClicks(int _timeClick, int _timeDbClick) {
		mTimeClick       = _timeClick;
		mTimeDoubleClick = _timeDbClick;
	}	
	
	public float GetDensity() {
        return controls.activity.getResources().getDisplayMetrics().density;
    }      
 
    public void ClipRect(float _left, float _top, float _right, float _bottom) {
        if (mCanvas == null) return;
        mCanvas.clipRect(_left, _top, _right, _bottom);
    }
 
    public void DrawGrid(float _left, float _top, float _width, float _height, int _cellsX, int _cellsY) {
        if (mCanvas == null) return;

        float cw = _width / _cellsX;
        float ch = _height / _cellsY;
        for (int i = 0; i < _cellsX + 1; i++) {
            mCanvas.drawLine(_left + i * cw, _top, _left + i * cw, _top + _height, mDrawPaint); // draw Y lines
        }
        for (int i = 0; i < _cellsY + 1; i++) {
            mCanvas.drawLine(_left, _top + i * ch, _left + _width, _top + i * ch, mDrawPaint); // draw X lines
        }
    }
	
	public void SetLayerType(byte _value) {
		setLayerType(_value/*View.LAYER_TYPE_SOFTWARE*/, null);
	}	
	 
} //end class

