package com.example.appsdl2opengles2demo1;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.os.AsyncTask;
import android.util.Log;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGL11;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.egl.EGLSurface;

/*Draft java code by "Lazarus Android Module Wizard" [6/3/2015 0:43:27]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jSurfaceView  extends SurfaceView  /*dummy*/ { //please, fix what GUI object will be extended!

    private long       pascalObj = 0;    // Pascal Object
    private Controls   controls  = null; // Control Class for events

    private Context context = null;
    private ViewGroup parent   = null;         // parent view
    private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH
    //private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!
    private int lparamsAnchorRule[] = new int[30];
    private int countAnchorRule = 0;
    private int lparamsParentRule[] = new int[30];
    private int countParentRule = 0;

    private int lparamH = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
    private int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
    private int marginLeft = 5;
    private int marginTop = 5;
    private int marginRight = 5;
    private int marginBottom = 5;
    private int lgravity = Gravity.TOP | Gravity.START;
    private float lweight = 0;

    private boolean mRemovedFromParent = false;

    private SurfaceHolder surfaceHolder;

    Paint paint;

    boolean mRun = false;
    long mSleeptime = 10;
    float mStartProgress = 0;
    float mStepProgress = 1;
    boolean mDrawing = false;
    
	private int EGL_CONTEXT_CLIENT_VERSION = 1;
		
    private int[] attrib_list = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL10.EGL_NONE };
	
    //EGL objects
	
	private EGL10 mEGL;
	private EGLDisplay mEGLDisplay;
	private EGLContext mEGLContext;	
	private EGLSurface mEGLSurface;
	private EGLConfig mEGLConfig;
	
	// private EGLDisplay  mEGLDisplay;
    //private EGLContext  mEGLContext;
    //private EGLSurface  mEGLSurface;
    //private EGLConfig   mEGLConfig;	
    
	//private Object mEGLConfigChooser;
	
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

	/**
	 * Access to the underlying surface is provided via the SurfaceHolder interface,
	 *  which can be retrieved by calling getHolder().
	    The Surface will be created for you while the SurfaceView's window is visible; 
	    you should implement surfaceCreated(SurfaceHolder) and surfaceDestroyed(SurfaceHolder) 
	    to discover when the Surface is created and destroyed as the window is shown and hidden.        	
	 */

    public jSurfaceView(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
        super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;

        controls.activity.getWindow().setFormat(PixelFormat.UNKNOWN);
        
        
        lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
        lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B

        surfaceHolder = this.getHolder();
        surfaceHolder.addCallback(new Callback() {                        
            @Override
            public void surfaceCreated(SurfaceHolder holder) {
                controls.pOnSurfaceViewCreated(pascalObj, holder);
                //setWillNotDraw(true); //false = Allows us to use invalidate() to call onDraw()
                DoAll(holder);
            }

            @Override
            public void surfaceChanged(SurfaceHolder holder, int format, int width,  int height) {
            	
                int sdlFormat = 0x15151002; // SDL_PIXELFORMAT_RGB565 by default
                
                switch (format) {
                case PixelFormat.A_8:
                    Log.v("SDL", "pixel format A_8");
                    break;
                case PixelFormat.LA_88:
                    Log.v("SDL", "pixel format LA_88");
                    break;
                case PixelFormat.L_8:
                    Log.v("SDL", "pixel format L_8");
                    break;
                case PixelFormat.RGBA_4444:
                    Log.v("SDL", "pixel format RGBA_4444");
                    sdlFormat = 0x15421002; // SDL_PIXELFORMAT_RGBA4444
                    break;
                case PixelFormat.RGBA_5551:
                    Log.v("SDL", "pixel format RGBA_5551");
                    sdlFormat = 0x15441002; // SDL_PIXELFORMAT_RGBA5551
                    break;
                case PixelFormat.RGBA_8888:
                    Log.v("SDL", "pixel format RGBA_8888");
                    sdlFormat = 0x16462004; // SDL_PIXELFORMAT_RGBA8888
                    break;
                case PixelFormat.RGBX_8888:
                    Log.v("SDL", "pixel format RGBX_8888");
                    sdlFormat = 0x16261804; // SDL_PIXELFORMAT_RGBX8888
                    break;
                case PixelFormat.RGB_332:
                    Log.v("SDL", "pixel format RGB_332");
                    sdlFormat = 0x14110801; // SDL_PIXELFORMAT_RGB332
                    break;
                case PixelFormat.RGB_565:
                    Log.v("SDL", "pixel format RGB_565");
                    sdlFormat = 0x15151002; // SDL_PIXELFORMAT_RGB565
                    break;
                case PixelFormat.RGB_888:
                    Log.v("SDL", "pixel format RGB_888");
                    // Not sure this is right, maybe SDL_PIXELFORMAT_RGB24 instead?
                    sdlFormat = 0x16161804; // SDL_PIXELFORMAT_RGB888
                    break;
                default:
                    Log.v("SDL", "pixel format unknown " + format);
                    break;
                }
            	            	
                controls.pOnSurfaceViewChanged(pascalObj,width,height);
            }

            @Override
            public void surfaceDestroyed(SurfaceHolder holder) {
                mRun = false;                             
                mEGL.eglMakeCurrent(mEGLDisplay, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_CONTEXT);
                mEGL.eglDestroySurface(mEGLDisplay, mEGLSurface);
                mEGLSurface = EGL10.EGL_NO_SURFACE;                
            }
            
        });
     
     /*
     onClickListener = new OnClickListener(){
         public void onClick(View view){  //please, do not remove mask for parse invisibility!
                 if (enabled) {
                    controls.pOnClick(pascalObj, Const.Click_Default); //JNI event onClick!
                 }
              };
     };     
     setOnClickListener(onClickListener);     
     */

        paint = new Paint();

    } //end constructor
    
    public void jFree() {
        if (parent != null) { parent.removeView(this); }
        //free local objects...
        lparams = null;
        //setOnClickListener(null);
        surfaceHolder  = null;
        paint = null;        
        CleanupEGL();
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

    @Override
    protected void onDraw(Canvas canvas) {
        if (mDrawing)  controls.pOnSurfaceViewDraw(pascalObj, canvas);
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void DrawLine(Canvas _canvas, float _x1, float _y1, float _x2, float _y2) {
        _canvas.drawLine(_x1,_y1,_x2,_y2, paint );
    }

    public void DrawLine(Canvas _canvas, float[] _points) {
        _canvas.drawLines(_points, paint);
    }

    public  void DrawText(Canvas _canvas, String _text, float _x, float _y ) {
        _canvas.drawText(_text,_x,_y,paint);
    }

    public  void DrawBitmap(Canvas _canvas, Bitmap _bitmap, int _b, int _l, int _r, int _t) {
        Rect rect = new Rect(_b,_l,_r,_t); //bello, left, right, top
        _canvas.drawBitmap(_bitmap,null,rect,null/*paint*/);
    }

    public void DrawBitmap(Canvas _canvas, Bitmap _bitmap , float _left, float _top) {
        _canvas.drawBitmap(_bitmap, _left, _top, null/*paint*/);
    }

    public void DrawPoint(Canvas _canvas, float _x1, float _y1) {
        _canvas.drawPoint(_x1,_y1,paint);
    }

    public void DrawCircle(Canvas _canvas, float _cx, float _cy, float _radius) {
        _canvas.drawCircle(_cx, _cy, _radius, paint);
    }

    public void DrawBackground(Canvas _canvas, int _color) {
        _canvas.drawColor(_color);
    }

    public void DrawRect(Canvas _canvas, float _left, float _top, float _right, float _bottom) {
        _canvas.drawRect(_left, _top, _right, _bottom, paint);
    }

    public  void SetPaintStrokeWidth(float _width) {
        paint.setStrokeWidth(_width);
    }

    public  void SetPaintStyle(int _style) {
        switch (_style) {
            case 0  : { paint.setStyle(Paint.Style.FILL           ); break; }
            case 1  : { paint.setStyle(Paint.Style.FILL_AND_STROKE); break; }
            case 2  : { paint.setStyle(Paint.Style.STROKE);          break; }
            default : { paint.setStyle(Paint.Style.FILL           ); break; }
        }
    }

    public  void SetPaintColor(int _color) {
        paint.setColor(_color);
    }

    public  void SetPaintTextSize(float _textsize) {
        paint.setTextSize(_textsize);
    }

    public void DispatchOnDraw(boolean _value) {
        mDrawing = _value;
        setWillNotDraw(!_value); //false = Allows us to use invalidate() to call onDraw()
    }

    public void SaveToFile(String _path, String _filename) {

        Bitmap image = Bitmap.createBitmap(this.getWidth(), this.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(image);
        this.draw(c);
        File file = new File (_path +"/"+ _filename);
        if (file.exists ()) file.delete ();
        try {
            FileOutputStream out = new FileOutputStream(file);

            if ( _filename.toLowerCase().contains(".jpg") ) image.compress(Bitmap.CompressFormat.JPEG, 90, out);
            if ( _filename.toLowerCase().contains(".png") ) image.compress(Bitmap.CompressFormat.PNG, 100, out);

            out.flush();
            out.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public  boolean onTouchEvent( MotionEvent event) {
        int act     = event.getAction() & MotionEvent.ACTION_MASK;
        switch(act) {
            case MotionEvent.ACTION_DOWN: {
                switch (event.getPointerCount()) {
                    case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,1,
                            event.getX(0),event.getY(0),0,0); break; }
                    default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,2,
                            event.getX(0),event.getY(0),
                            event.getX(1),event.getY(1));     break; }
                }
                break;}
            case MotionEvent.ACTION_MOVE: {
                switch (event.getPointerCount()) {
                    case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchMove,1,
                            event.getX(0),event.getY(0),0,0); break; }
                    default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchMove,2,
                            event.getX(0),event.getY(0),
                            event.getX(1),event.getY(1));     break; }
                }
                break;}
            case MotionEvent.ACTION_UP: {
                switch (event.getPointerCount()) {
                    case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,1,
                            event.getX(0),event.getY(0),0,0); break; }
                    default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,2,
                            event.getX(0),event.getY(0),
                            event.getX(1),event.getY(1));     break; }
                }
                break;}
            case MotionEvent.ACTION_POINTER_DOWN: {
                switch (event.getPointerCount()) {
                    case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,1,
                            event.getX(0),event.getY(0),0,0); break; }
                    default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,2,
                            event.getX(0),event.getY(0),
                            event.getX(1),event.getY(1));     break; }
                }
                break;}
            case MotionEvent.ACTION_POINTER_UP  : {
                // Log.i("Java","PUp");
                switch (event.getPointerCount()) {
                    case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,1,
                            event.getX(0),event.getY(0),0,0); break; }
                    default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,2,
                            event.getX(0),event.getY(0),
                            event.getX(1),event.getY(1));     break; }
                }
                break;}
        }
        return true;
    }

    public void SetHolderFixedSize(int _width, int _height) {
        surfaceHolder.setFixedSize(_width, _height);
    }

    public Canvas GetLockedCanvas() {
        return surfaceHolder.lockCanvas();
    }

    public void UnLockCanvas(Canvas _canvas) {
        if(_canvas != null) {
            surfaceHolder.unlockCanvasAndPost(_canvas);
        }
    }

    //invalidate(): This must be called from a UI thread. 
    //To call from a non-UI thread, call  postInvalidate(). 

    //http://blog-en.openalfa.com/how-to-draw-graphics-in-android
    //http://blog.danielnadeau.io/2012/01/android-canvas-beginners-tutorial.html	  
    //http://www.edu4java.com/en/androidgame/androidgame3.html

    public void DoDrawingInBackground(boolean _value) {
        if (!mRun) {
            new DrawTask().execute();
        }
        mRun = _value;
        mDrawing = _value;
        setWillNotDraw(!_value); //false = Allows us to use invalidate() to call onDraw()
    }

    public void SetDrawingInBackgroundSleeptime(long _sleepTime) { //long mSleeptime = 20;
        mSleeptime = 20;
        if (_sleepTime > 20)
            mSleeptime = _sleepTime;
    }

    public void PostInvalidate() {
        this.postInvalidate();
    }

    public void Invalidate() {
        this.invalidate();
    }

    public void SetKeepScreenOn(boolean _value) {
        surfaceHolder.setKeepScreenOn(_value);
    }

    //Set whether this view can receive the focus.
    //Setting this to false will also ensure that this view is not focusable in touch mode.
    public void SetFocusable(boolean _value) {
        this.setFocusable(_value); // make sure we get key events
    }

    public void SetProgress(float _startValue, float _step) {
        mStartProgress = _startValue;
        mStepProgress =  _step;
    }

    class DrawTask extends AsyncTask<String, Float, String> {
        Canvas canvas;
        float count;
        @Override
        protected String doInBackground(String... message) {
            count = mStartProgress;
            while (controls.pOnSurfaceViewDrawingInBackground(pascalObj, count)) {
                canvas = null;
                try {
                    canvas = surfaceHolder.lockCanvas(null);

                    try {
                        Thread.sleep(mSleeptime);
                    } catch (InterruptedException iE) {
                        //
                    }

                    synchronized (surfaceHolder) {
                        if (canvas != null) {
                            PostInvalidate();
                        }
                    }
                    publishProgress(count);
                }
                finally {
                    if (canvas != null) {
                        surfaceHolder.unlockCanvasAndPost(canvas);
                    }
                }

            }
            mDrawing = false;
            mRun = false;
            return null;
        }

        @Override
        protected void onProgressUpdate(Float... values) {
            super.onProgressUpdate(values);
            count = count + mStepProgress;
        }

        @Override
        protected void onPostExecute(String values) {
            super.onPostExecute(values);
            controls.pOnSurfaceViewDrawingPostExecute(pascalObj, count);
        }
    }

    public Bitmap GetDrawingCache() {
        this.setDrawingCacheEnabled(true);
        Bitmap b = Bitmap.createBitmap(this.getDrawingCache());
        this.setDrawingCacheEnabled(false);
        return b;
    }
          
    
    /*** EGL functions Helpers ***/
	public boolean  InitEGL() {
		/* Get an EGL instance. */
		this.mEGL = (EGL10) EGLContext.getEGL();
		/* Get to the default display. */
		this.mEGLDisplay = this.mEGL.eglGetDisplay(EGL10.EGL_DEFAULT_DISPLAY);
		/* We can now initialize EGL for that display. */		
		final int[] version = new int[2];
		if(!this.mEGL.eglInitialize(this.mEGLDisplay, version)) {
		     //throw new RuntimeException("eglInitialize failed");
		     return false;
		}
		return true;
	}
	
	public EGLDisplay EglGetCurrentDisplay () { //DC: get a device currently associated with the given OpenGL context
    	return mEGL.eglGetCurrentDisplay();
     }
				 
	
	//Texture:
	//An OpenGL object that contains one or more images, all of which are stored in the same Image Format.
	/*
	    * setEGLContextClientVersion(2);
        //or in a custom Renderer:
        int[] attrib_list = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL10.EGL_NONE };
        EGLContext context = egl.eglCreateContext(display, eglConfig, EGL10.EGL_NO_CONTEXT, attrib_list);
	 */
	//Context: A collection of state, memory and resources. Required to do any OpenGL operation.
	//The object that represents an instance of OpenGL

    private EGLConfig GetConfig() {   
    	
        int[] eglConfigAttribList = new int[] {
                EGL10.EGL_RED_SIZE, 8,
                EGL10.EGL_GREEN_SIZE, 8,
                EGL10.EGL_BLUE_SIZE, 8,
                EGL10.EGL_ALPHA_SIZE, 8,
                EGL10.EGL_NONE
        };   

        int[] numEglConfigs = new int[1];
        EGLConfig[] eglConfigs = new EGLConfig[1];        
            if (!mEGL.eglChooseConfig(mEGLDisplay,eglConfigAttribList, eglConfigs, 1, numEglConfigs) ) {            	      
                return null;                                                
            }            
            else return  eglConfigs[0];
            
    }	
    public boolean CreateEGLRenderingContext() {  //action 1  -- Render Context         	    	
    	
    	this.mEGLConfig = GetConfig();    	
		/* Create an OpenGL ES context. This must be done only once, an OpenGL context is a somewhat heavy object. */
		this.mEGLContext = this.mEGL.eglCreateContext(this.mEGLDisplay, this.mEGLConfig, EGL10.EGL_NO_CONTEXT, attrib_list);			
		if (this.mEGLContext == null || this.mEGLContext == EGL10.EGL_NO_CONTEXT) {
			Log.e("SDL", "Couldn't create context");  
            return false;
		}						
        return true;                   
    }              
         
    //How to grab the OpenGL context created by Android's GLSurfaceView?
    public EGLContext EglGetCurrentRenderingContext () { 
   	   return mEGL.eglGetCurrentContext();
    }
    
    public boolean CreateEGLWindowSurface(SurfaceHolder _surfaceHolder) {    //action 2
		/* The window size has changed, so we need to create a new surface. */
		if (this.mEGLSurface != null && this.mEGLSurface != EGL10.EGL_NO_SURFACE) {
			/* Unbind and destroy the old EGL surface, if there is one. */
			this.mEGL.eglMakeCurrent(this.mEGLDisplay, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_CONTEXT);			
			this.mEGL.eglDestroySurface(this.mEGLDisplay, this.mEGLSurface);
		}

		/* Create an EGL surface we can render into. */
		this.mEGLSurface = this.mEGL.eglCreateWindowSurface(this.mEGLDisplay, this.mEGLConfig, _surfaceHolder, null);

		if (this.mEGLSurface == null || this.mEGLSurface == EGL10.EGL_NO_SURFACE) {
			//throw new RuntimeException("createSurface failed");
			return false;
		}

		/* Before we can issue GL commands, we need to make sure the context is current and bound to a surface. */
		if (!this.mEGL.eglMakeCurrent(this.mEGLDisplay, this.mEGLSurface, this.mEGLSurface, this.mEGLContext)) {
			//throw new RuntimeException("eglMakeCurrent failed.");
			return false;
		}		
		
		return true;
		
	}


	/**
	 * Display the current render surface.  texture (or render-buffer)
	 * @return false if the context has been lost.
	 */
	//
		/* Always check for EGL_CONTEXT_LOST, which means the context and all
		 * associated data were lost (For instance because the device went to sleep).
		 * We need to sleep until we get a new surface. */
	
    // EGL buffer flip
    public  boolean SwapEGLBuffers() {    	
        try {       
            mEGL.eglWaitNative(EGL10.EGL_CORE_NATIVE_ENGINE, null);            
            // drawing here            
            mEGL.eglWaitGL();
            mEGL.eglSwapBuffers(mEGLDisplay, mEGLSurface);                       
        } catch(Exception e) {
            Log.v("SDL", "flipEGL(): " + e);
            for (StackTraceElement s : e.getStackTrace()) {
                Log.v("SDL", s.toString());
            }
            return false;
        }        
        return this.mEGL.eglGetError() != EGL11.EGL_CONTEXT_LOST;        
    }

    /*
     * 
     *You should know what a window handle (HWND) and a device context (DC) 			
     *https://www.opengl.org/wiki/Creating_an_OpenGL_Context_(WGL)
     *
     *Each window in MS Windows has a DC:
     * "Device Context (DC)" associated with it: This object can store something called a Pixel Format. 
     *  This is a generic structure that describes the properties of the default framebuffer that the OpenGL context you want to create should have. 
     * HDC ourWindowHandleToDeviceContext = GetDC(hWnd);
     * HGLRC ourOpenGLRenderingContext = wglCreateContext(ourWindowHandleToDeviceContext);
     */
              
	public void CleanupEGL() {
		
		if (this.mEGLSurface != null && this.mEGLSurface != EGL10.EGL_NO_SURFACE) {
			this.mEGL.eglMakeCurrent(this.mEGLDisplay, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_CONTEXT);
			this.mEGL.eglDestroySurface(this.mEGLDisplay, this.mEGLSurface);
			this.mEGLSurface = null;
		}
		
		if (this.mEGLContext != null) {
			this.mEGL.eglDestroyContext(this.mEGLDisplay, this.mEGLContext);
			this.mEGLContext = null;
		}
		if (this.mEGLDisplay != null) {
			this.mEGL.eglTerminate(this.mEGLDisplay);
			this.mEGLDisplay = null;
		}
		
	}
		
    public void DoAll(SurfaceHolder holder) {
    	if ( InitEGL() == true) {
    		  if (  CreateEGLRenderingContext() == true ) {
    			  CreateEGLWindowSurface(holder);  	      	        	 
	      	    //  Cube cube = new Cube();    	 
	      	     // cube.draw( (GL10)mEGLContext.getGL() );	      	   
    	      }
      	}    	
    }
        
} //end class


class Cube {
    
    private FloatBuffer mVertexBuffer;
    private FloatBuffer mColorBuffer;
    private ByteBuffer  mIndexBuffer;
        
    private float vertices[] = {
                                -1.0f, -1.0f, -1.0f,
                                1.0f, -1.0f, -1.0f,
                                1.0f,  1.0f, -1.0f,
                                -1.0f, 1.0f, -1.0f,
                                -1.0f, -1.0f,  1.0f,
                                1.0f, -1.0f,  1.0f,
                                1.0f,  1.0f,  1.0f,
                                -1.0f,  1.0f,  1.0f
                                };
    private float colors[] = {
                               0.0f,  1.0f,  0.0f,  1.0f,
                               0.0f,  1.0f,  0.0f,  1.0f,
                               1.0f,  0.5f,  0.0f,  1.0f,
                               1.0f,  0.5f,  0.0f,  1.0f,
                               1.0f,  0.0f,  0.0f,  1.0f,
                               1.0f,  0.0f,  0.0f,  1.0f,
                               0.0f,  0.0f,  1.0f,  1.0f,
                               1.0f,  0.0f,  1.0f,  1.0f
                            };
   
    private byte indices[] = {
                              0, 4, 5, 0, 5, 1,
                              1, 5, 6, 1, 6, 2,
                              2, 6, 7, 2, 7, 3,
                              3, 7, 4, 3, 4, 0,
                              4, 7, 6, 4, 6, 5,
                              3, 0, 1, 3, 1, 2
                              };
                
    public Cube() {
            ByteBuffer byteBuf = ByteBuffer.allocateDirect(vertices.length * 4);
            byteBuf.order(ByteOrder.nativeOrder());
            mVertexBuffer = byteBuf.asFloatBuffer();
            mVertexBuffer.put(vertices);
            mVertexBuffer.position(0);
                
            byteBuf = ByteBuffer.allocateDirect(colors.length * 4);
            byteBuf.order(ByteOrder.nativeOrder());
            mColorBuffer = byteBuf.asFloatBuffer();
            mColorBuffer.put(colors);
            mColorBuffer.position(0);
                
            mIndexBuffer = ByteBuffer.allocateDirect(indices.length);
            mIndexBuffer.put(indices);
            mIndexBuffer.position(0);
    }

    public void draw(EGL10 gl) {             
    	
            
    }
    
}


