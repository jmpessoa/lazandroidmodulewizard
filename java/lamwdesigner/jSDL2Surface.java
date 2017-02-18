package com.example.appsdl2demo1;

import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.egl.EGLSurface;
import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;

import android.content.*;
import android.view.*;
import android.view.ViewGroup.MarginLayoutParams;
import android.view.inputmethod.BaseInputConnection;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.util.Log;
import android.graphics.*;
import android.hardware.*;

import android.app.*;
import android.view.inputmethod.InputMethodManager;
import android.os.*;
import android.media.*;

/**
    SDLSurface. This is what we draw on, so we need to know when it's created
    in order to do anything useful. 
    Because of this, that's where we set up the SDL thread
*/
public class jSDL2Surface extends SurfaceView implements SurfaceHolder.Callback, 
    View.OnKeyListener, View.OnTouchListener, SensorEventListener  {

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
		
    // Sensors
    protected static SensorManager mSensorManager;

    // Keep track of the surface size to normalize touch events
    protected static float mWidth, mHeight;
    
    public jSDL2 SDL2;

    // Startup    
    public jSDL2Surface(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
        super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;

        controls.activity.getWindow().setFormat(PixelFormat.UNKNOWN);

        lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
        lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B

        getHolder().addCallback(this); 
    
        setFocusable(true);
        setFocusableInTouchMode(true);
        requestFocus();
        setOnKeyListener(this); 
        setOnTouchListener(this);   

        mSensorManager = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);

        // Some arbitrary defaults to avoid a potential division by zero
        mWidth = 1.0f;
        mHeight = 1.0f;
        
        Log.i("jSDL2Surface", "construtor");
        
        SDL2 = new jSDL2(controls, pascalObj);
        
    }

	public  void jFree() {
	   if (parent != null) { parent.removeView(this); }	        
	      lparams = null;	  
	      
	      SDL2.jFree();
	}

    //Called when we have a valid drawing surface
    @Override
    public void surfaceCreated(SurfaceHolder holder) {
    	
        Log.i("jSDL2Surface", "surfaceCreated()");
                        
        //holder.setType(SurfaceHolder.SURFACE_TYPE_GPU);                
        // Set mIsSurfaceReady to 'true' *before* any call to handleResume                
        if (jSDL2.mSurface == null) { 
        	jSDL2.mSurface = this;
            jSDL2.mIsSurfaceReady = true;
            Log.v("jSDL2Surface", "jSDL2.mSurface = this");           
        }
                
    }

    // Called when we lose the surface
    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        Log.v("jSDL2Surface", "surfaceDestroyed()");
        // Call this *before* setting mIsSurfaceReady to 'false'        
        
        jSDL2.handlePause();
        jSDL2.mIsSurfaceReady = false;
                
        /* We have to clear the current context and destroy the egl surface here
         * Otherwise there's BAD_NATIVE_WINDOW errors coming from eglCreateWindowSurface on resume
         * Ref: http://stackoverflow.com/questions/8762589/eglcreatewindowsurface-on-ics-and-switching-from-2d-to-3d
         */
                
        EGL10 egl = (EGL10)EGLContext.getEGL();
        egl.eglMakeCurrent(jSDL2.mEGLDisplay, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_CONTEXT);
        egl.eglDestroySurface(jSDL2.mEGLDisplay, jSDL2.mEGLSurface);
        jSDL2.mEGLSurface = EGL10.EGL_NO_SURFACE;
        
        jSDL2.mSurface = null;                        
    }

    // Called when the surface is resized
    @Override
    public void surfaceChanged(SurfaceHolder holder,
                               int format, int width, int height) {
    	
        Log.i("jSDL2Surface", "surfaceChanged()");

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

        mWidth = width;
        mHeight = height;
        
        controls.pOnSDL2NativeResize(pascalObj, width, height, sdlFormat);
        
        Log.v("jSDL2Surface", "Window size: " + width + " x " + height);
        // Set mIsSurfaceReady to 'true' *before* making a call to handleResume
        
        //jSDL2.mIsSurfaceReady = true;
                        
        if (jSDL2.mSDLThread == null) {
            // This is the entry point to the C app.
            // Start up the C app thread and enable sensor input for the first time
            jSDL2.mSDLThread = new Thread(new SDLMain(controls, pascalObj, SDL2), "SDLThread");
            enableSensor(Sensor.TYPE_ACCELEROMETER, true);
            jSDL2.mSDLThread.start();                        
        } else {
            // The app already exists, we resume via handleResume
            // Multiple sequential calls to surfaceChanged are handled internally by handleResume
            jSDL2.handleResume();
        }
    }

    // unused
    @Override
    public void onDraw(Canvas canvas) {}


    // Key events
    @Override
    public boolean onKey(View  v, int keyCode, KeyEvent event) {
        
        if (event.getAction() == KeyEvent.ACTION_DOWN) {
            //Log.v("SDL", "key down: " + keyCode);
            controls.pOnSDL2NativeKeyDown(pascalObj, keyCode);
            return true;
        }
        else if (event.getAction() == KeyEvent.ACTION_UP) {
            //Log.v("SDL", "key up: " + keyCode);
        	controls.pOnSDL2NativeKeyUp(pascalObj, keyCode);
            return true;
        }
        
        return false;
    }

    // Touch events
    @Override
    public boolean onTouch(View v, MotionEvent event) {
             final int touchDevId = event.getDeviceId();
             final int pointerCount = event.getPointerCount();
             // touchId, pointerId, action, x, y, pressure
             int actionPointerIndex = (event.getAction() & MotionEvent.ACTION_POINTER_ID_MASK) >> MotionEvent.ACTION_POINTER_ID_SHIFT; /* API 8: event.getActionIndex(); */
             int pointerFingerId = event.getPointerId(actionPointerIndex);
             int action = (event.getAction() & MotionEvent.ACTION_MASK); /* API 8: event.getActionMasked(); */

             float x = event.getX(actionPointerIndex) / mWidth;
             float y = event.getY(actionPointerIndex) / mHeight;
             float p = event.getPressure(actionPointerIndex);

             if (action == MotionEvent.ACTION_MOVE && pointerCount > 1) {
                // TODO send motion to every pointer if its position has
                // changed since prev event.
                for (int i = 0; i < pointerCount; i++) {
                    pointerFingerId = event.getPointerId(i);
                    x = event.getX(i) / mWidth;
                    y = event.getY(i) / mHeight;
                    p = event.getPressure(i);
                    controls.pOnSDL2NativeTouch(pascalObj, touchDevId, pointerFingerId, action, x, y, p);
                }
             } else {
            	 controls.pOnSDL2NativeTouch(pascalObj, touchDevId, pointerFingerId, action, x, y, p);
             }
      return true;
   } 

    // Sensor events
    public void enableSensor(int sensortype, boolean enabled) {
        // TODO: This uses getDefaultSensor - what if we have >1 accels?
        if (enabled) {
            mSensorManager.registerListener(this, 
                            mSensorManager.getDefaultSensor(sensortype), 
                            SensorManager.SENSOR_DELAY_GAME, null);
        } else {
            mSensorManager.unregisterListener(this, 
                            mSensorManager.getDefaultSensor(sensortype));
        }
    }
    
    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // TODO
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
        /*	controls.onNativeAccel(event.values[0] / SensorManager.GRAVITY_EARTH,
                                      event.values[1] / SensorManager.GRAVITY_EARTH,
                                      event.values[2] / SensorManager.GRAVITY_EARTH);  */
        }
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

	public int getLParamWidth() { 
		int r =  lparamW;
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			r = this.getWidth();
		}		
		return r;
	}
	
	public int getLParamHeight() {
		int r = lparamH;
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			r = this.getHeight();
		}
		return r;
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
    
}

/* This is a fake invisible editor view that receives the input and defines the
 * pan&scan region
 */
class DummyEdit extends View implements View.OnKeyListener {
    InputConnection ic;  
    Controls controls; 
    long pasObj;
    public DummyEdit(Controls contls, long pascalObj) {    	          	
    	super(contls.activity);      	
    	controls = contls;
    	pasObj = pascalObj;
        setFocusableInTouchMode(true);
        setFocusable(true);
        setOnKeyListener(this);
    }

    @Override
    public boolean onCheckIsTextEditor() {
        return true;
    }

    @Override
    public boolean onKey(View v, int keyCode, KeyEvent event) {

        // This handles the hardware keyboard input
        if (event.isPrintingKey()) {
            if (event.getAction() == KeyEvent.ACTION_DOWN) {
                ic.commitText(String.valueOf((char) event.getUnicodeChar()), 1);
            }
            return true;
        }

        if (event.getAction() == KeyEvent.ACTION_DOWN) {
        	controls.pOnSDL2NativeKeyDown(pasObj, keyCode);
            return true;
        } else if (event.getAction() == KeyEvent.ACTION_UP) {
        	controls.pOnSDL2NativeKeyUp(pasObj, keyCode);
            return true;
        }

        return false;
    }
        
    //
    @Override
    public boolean onKeyPreIme (int keyCode, KeyEvent event) {
        // As seen on StackOverflow: http://stackoverflow.com/questions/7634346/keyboard-hide-event
        // FIXME: Discussion at http://bugzilla.libsdl.org/show_bug.cgi?id=1639
        // FIXME: This is not a 100% effective solution to the problem of detecting if the keyboard is showing or not
        // FIXME: A more effective solution would be to change our Layout from AbsoluteLayout to Relative or Linear
        // FIXME: And determine the keyboard presence doing this: http://stackoverflow.com/questions/2150078/how-to-check-visibility-of-software-keyboard-in-android
        // FIXME: An even more effective way would be if Android provided this out of the box, but where would the fun be in that :)
        if (event.getAction()==KeyEvent.ACTION_UP && keyCode == KeyEvent.KEYCODE_BACK) {
            if (jSDL2.mTextEdit != null && jSDL2.mTextEdit.getVisibility() == View.VISIBLE) {
               // controls.onNativeKeyboardFocusLost();
            }
        }
        return super.onKeyPreIme(keyCode, event);
    }

    @Override
    public InputConnection onCreateInputConnection(EditorInfo outAttrs) {
        ic = new SDLInputConnection(controls, pasObj,  this, true);

        outAttrs.imeOptions = EditorInfo.IME_FLAG_NO_EXTRACT_UI
                | 33554432 /* API 11: EditorInfo.IME_FLAG_NO_FULLSCREEN */;

        return ic;
    }
}

class SDLInputConnection extends BaseInputConnection {

	Controls controls;
	long pasObj;
    public SDLInputConnection(Controls contrl, long pascalObj,  View targetView, boolean fullEditor) {
        super(targetView, fullEditor);
        controls = contrl;
        pasObj = pascalObj;
    }

    @Override
    public boolean sendKeyEvent(KeyEvent event) {
        /*
         * This handles the keycodes from soft keyboard (and IME-translated
         * input from hardkeyboard)
         */
        int keyCode = event.getKeyCode();
        if (event.getAction() == KeyEvent.ACTION_DOWN) {
            if (event.isPrintingKey()) {
                commitText(String.valueOf((char) event.getUnicodeChar()), 1);
            }
            controls.pOnSDL2NativeKeyDown(pasObj, keyCode);
            return true;
        } else if (event.getAction() == KeyEvent.ACTION_UP) {

        	controls.pOnSDL2NativeKeyUp(pasObj, keyCode);
            return true;
        }
        return super.sendKeyEvent(event);
    }

    @Override
    public boolean commitText(CharSequence text, int newCursorPosition) {

       // controls.nativeCommitText(text.toString(), newCursorPosition);

        return super.commitText(text, newCursorPosition);
    }

    @Override
    public boolean setComposingText(CharSequence text, int newCursorPosition) {
    	//controls.nativeSetComposingText(text.toString(), newCursorPosition);
        return super.setComposingText(text, newCursorPosition);
    }
}

/**
SDL Activity
*/
class jSDL2 {
private static final String TAG = "SDL";

// Keep track of the paused state
public static boolean mIsPaused = false, mIsSurfaceReady = false, mHasFocus = true;

// Main components
protected static jSDL2 mSingleton;
                 
protected static jSDL2Surface mSurface;
protected static View mTextEdit;
protected static ViewGroup mLayout;

// This is what SDL runs in. It invokes SDL_main(), eventually
protected static Thread mSDLThread;

// Audio
protected static Thread mAudioThread;
protected static AudioTrack mAudioTrack;

// EGL objects
protected static EGLContext  mEGLContext;
protected static EGLSurface  mEGLSurface;
protected static EGLDisplay  mEGLDisplay;
protected static EGLConfig   mEGLConfig;
protected static int mGLMajor, mGLMinor;

private long             PasObj   = 0;      // Pascal Obj
public static Controls  controls = null;   // Control Class for Event
//
//Constructor
public  jSDL2(Controls _ctrls, long _Self) {
	//Connect Pascal I/F
	PasObj   = _Self;
	controls = _ctrls;
	//Init Class
    // So we can call stuff from static callbacks
    mSingleton = this;
    // Set up the surface
    mEGLSurface = EGL10.EGL_NO_SURFACE;
    mEGLContext = EGL10.EGL_NO_CONTEXT;                
    
    Log.v("jSDL2", "constructor");
}

public void SetSDL2Surface( android.view.SurfaceView _sdl2Surface) {		
    mSurface = (jSDL2Surface)_sdl2Surface; //new jSDLSurface(controls, PasObj);//Controls _ctrls, long _Self
    mIsSurfaceReady = true;
    Log.v("jSDL2", "SetSDL2Surface");        
}
	
// Load the .so    
// Setup
// Events
//Free object except Self, Pascal Code Free the class.
public  void jFree() {
	
	controls.pOnSDL2NativeQuit(PasObj);

    // Now wait for the SDL thread to quit
    if (mSDLThread != null) {
        try {
            mSDLThread.join();
        } catch(Exception e) {
            Log.v("SDL", "Problem stopping thread: " + e);
        }
        mSDLThread = null;
        //Log.v("SDL", "Finished waiting for SDL thread");
    }
    
    mIsSurfaceReady = false;
    mSurface = null;
}

/** Called by onPause or surfaceDestroyed. Even if surfaceDestroyed
 *  is the first to be called, mIsSurfaceReady should still be set
 *  to 'true' during the call to onPause (in a usual scenario).
 */
public static void handlePause() {
    if (!jSDL2.mIsPaused && jSDL2.mIsSurfaceReady) {
        jSDL2.mIsPaused = true;
        //jSDL2.nativePause();
        mSurface.enableSensor(Sensor.TYPE_ACCELEROMETER, false);
    }
}

/** Called by onResume or surfaceCreated. An actual resume should be done only when the surface is ready.
 * Note: Some Android variants may send multiple surfaceChanged events, so we don't need to resume
 * every time we get one of those events, only if it comes after surfaceDestroyed
 */
public static void handleResume() {
    if (jSDL2.mIsPaused && jSDL2.mIsSurfaceReady && jSDL2.mHasFocus) {
        jSDL2.mIsPaused = false;
        //jSDL2.nativeResume();
        mSurface.enableSensor(Sensor.TYPE_ACCELEROMETER, true);
    }
}

// Messages from the SDLMain thread
static final int COMMAND_CHANGE_TITLE = 1;
static final int COMMAND_UNUSED = 2;
static final int COMMAND_TEXTEDIT_HIDE = 3;

protected static final int COMMAND_USER = 0x8000;

/**
 * This method is called by SDL if SDL did not handle a message itself.
 * This happens if a received message contains an unsupported command.
 * Method can be overwritten to handle Messages in a different class.
 * @param command the command of the message.
 * @param param the parameter of the message. May be null.
 * @return if the message was handled in overridden method.
 */
public static boolean onUnhandledMessage(int command, Object param) {
    return false;
}

/**
 * A Handler class for Messages from native SDL applications.
 * It uses current Activities as target (e.g. for the title).
 * static to prevent implicit references to enclosing object.
 */
protected static class SDLCommandHandler extends Handler {
	
	Context context;
	
	public SDLCommandHandler(Controls controls) {
		context = controls.activity; //getContext();
	}
	
    @Override
    public void handleMessage(Message msg) {
    	            
        if (context == null) {
            Log.e(TAG, "error handling message, getContext() returned null");
            return;
        }
        switch (msg.arg1) {
        case COMMAND_CHANGE_TITLE:
            if (context instanceof Activity) {
                ((Activity) context).setTitle((String)msg.obj);
            } else {
                Log.e(TAG, "error handling message, getContext() returned no Activity");
            }
            break;
        case COMMAND_TEXTEDIT_HIDE:
            if (mTextEdit != null) {
                mTextEdit.setVisibility(View.GONE);
                InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(mTextEdit.getWindowToken(), 0);
            }
            break;

        default:
            if ( (context instanceof Activity) &&                 		
            		!jSDL2.onUnhandledMessage(msg.arg1, msg.obj))	 {
                Log.e(TAG, "error handling message, command is " + msg.arg1);
            }
        }
    }
}

// Handler for the messages
Handler commandHandler = new SDLCommandHandler(controls);

// Send a message from the SDLMain thread
boolean sendCommand(int command, Object data) {
    Message msg = commandHandler.obtainMessage();
    msg.arg1 = command;
    msg.obj = data;
    return commandHandler.sendMessage(msg);
}

// native C functions we call
    
 //-------------------

// Java functions called from C
public static boolean createGLContext(int majorVersion, int minorVersion, int[] attribs) {	
	Log.i("0. createGLContext", "majorVersion");	
    return initEGL(majorVersion, minorVersion, attribs);
}

//EGL functions
public static boolean initEGL(int majorVersion, int minorVersion, int[] attribs) {
	
	Log.i("1. initEGL", "minorVersion");
	
 try {
     EGL10 egl = (EGL10)EGLContext.getEGL();
     
     if (jSDL2.mEGLDisplay == null) {
         jSDL2.mEGLDisplay = egl.eglGetDisplay(EGL10.EGL_DEFAULT_DISPLAY);
         int[] version = new int[2];
         egl.eglInitialize(jSDL2.mEGLDisplay, version);
     }
     
     if (jSDL2.mEGLDisplay != null && jSDL2.mEGLContext == EGL10.EGL_NO_CONTEXT) {
         // No current GL context exists, we will create a new one.
         Log.v("SDL", "Starting up OpenGL ES " + majorVersion + "." + minorVersion);
         EGLConfig[] configs = new EGLConfig[128];
         int[] num_config = new int[1];
         if (!egl.eglChooseConfig(jSDL2.mEGLDisplay, attribs, configs, 1, num_config) || num_config[0] == 0) {
             Log.e("SDL", "No EGL config available");
             return false;
         }
         EGLConfig config = null;
         int bestdiff = -1, bitdiff;
         int[] value = new int[1];
         
         // eglChooseConfig returns a number of configurations that match or exceed the requested attribs.
         // From those, we select the one that matches our requirements more closely
         Log.v("SDL", "Got " + num_config[0] + " valid modes from egl");
         for(int i = 0; i < num_config[0]; i++) {
             bitdiff = 0;
             // Go through some of the attributes and compute the bit difference between what we want and what we get.
             for (int j = 0; ; j += 2) {
                 if (attribs[j] == EGL10.EGL_NONE)
                     break;

                 if (attribs[j+1] != EGL10.EGL_DONT_CARE && (attribs[j] == EGL10.EGL_RED_SIZE ||
                     attribs[j] == EGL10.EGL_GREEN_SIZE ||
                     attribs[j] == EGL10.EGL_BLUE_SIZE ||
                     attribs[j] == EGL10.EGL_ALPHA_SIZE ||
                     attribs[j] == EGL10.EGL_DEPTH_SIZE ||
                     attribs[j] == EGL10.EGL_STENCIL_SIZE)) {
                     egl.eglGetConfigAttrib(jSDL2.mEGLDisplay, configs[i], attribs[j], value);
                     bitdiff += value[0] - attribs[j + 1]; // value is always >= attrib
                 }
             }
             
             if (bitdiff < bestdiff || bestdiff == -1) {
                 config = configs[i];
                 bestdiff = bitdiff;
             }
             
             if (bitdiff == 0) break; // we found an exact match!
         }
         
         Log.d("SDL", "Selected mode with a total bit difference of " + bestdiff);

         jSDL2.mEGLConfig = config;
         jSDL2.mGLMajor = majorVersion;
         jSDL2.mGLMinor = minorVersion;
     }
     
     return jSDL2.createEGLSurface();

 } catch(Exception e) {
     Log.v("SDL", e + "");
     for (StackTraceElement s : e.getStackTrace()) {
         Log.v("SDL", s.toString());
     }
     return false;
 }
}

public static boolean createEGLSurface() {
	
	Log.i("2. createEGLSurface", "pppppppp");
	
	if (jSDL2.mSurface == null) return false;
	
    if (jSDL2.mEGLDisplay != null && jSDL2.mEGLConfig != null) {
        EGL10 egl = (EGL10)EGLContext.getEGL();
        if (jSDL2.mEGLContext == EGL10.EGL_NO_CONTEXT) createEGLContext();

        if (jSDL2.mEGLSurface == EGL10.EGL_NO_SURFACE) {
            Log.v("SDL", "Creating new EGL Surface");
            jSDL2.mEGLSurface = egl.eglCreateWindowSurface(jSDL2.mEGLDisplay, jSDL2.mEGLConfig, jSDL2.mSurface, null);
            if (jSDL2.mEGLSurface == EGL10.EGL_NO_SURFACE) {
                Log.e("SDL", "Couldn't create surface");
                return false;
            }
        }
        else Log.v("SDL", "EGL Surface remains valid");

        if (egl.eglGetCurrentContext() != jSDL2.mEGLContext) {
            if (!egl.eglMakeCurrent(jSDL2.mEGLDisplay, jSDL2.mEGLSurface, jSDL2.mEGLSurface, jSDL2.mEGLContext)) {
                Log.e("SDL", "Old EGL Context doesnt work, trying with a new one");
                // TODO: Notify the user via a message that the old context could not be restored, and that textures need to be manually restored.
                createEGLContext();
                if (!egl.eglMakeCurrent(jSDL2.mEGLDisplay, jSDL2.mEGLSurface, jSDL2.mEGLSurface, jSDL2.mEGLContext)) {
                    Log.e("SDL", "Failed making EGL Context current");
                    return false;
                }
            }
            else Log.v("SDL", "EGL Context made current");
        }
        else Log.v("SDL", "EGL Context remains current");

        return true;
    } else {
        Log.e("SDL", "Surface creation failed, display = " + jSDL2.mEGLDisplay + ", config = " + jSDL2.mEGLConfig);
        return false;
    }
}

public static boolean createEGLContext() {
	
	Log.i("3. createEGLContext", "mmmmmm");
	
    EGL10 egl = (EGL10)EGLContext.getEGL();
    int EGL_CONTEXT_CLIENT_VERSION=0x3098;
    int contextAttrs[] = new int[] { EGL_CONTEXT_CLIENT_VERSION, jSDL2.mGLMajor, EGL10.EGL_NONE };
    jSDL2.mEGLContext = egl.eglCreateContext(jSDL2.mEGLDisplay, jSDL2.mEGLConfig, EGL10.EGL_NO_CONTEXT, contextAttrs);
    if (jSDL2.mEGLContext == EGL10.EGL_NO_CONTEXT) {
        Log.e("SDL", "Couldn't create context");
        return false;
    }
    return true;
}

public static void flipBuffers() {
	Log.i("4. flipBuffers", "flipEGL()");
    flipEGL();
}

//EGL buffer flip
public static void flipEGL() {
	
	Log.i("5. flipEGL()", "kkkkkkkkkkk");
	
 try {
     EGL10 egl = (EGL10)EGLContext.getEGL();

     egl.eglWaitNative(EGL10.EGL_CORE_NATIVE_ENGINE, null);

     // drawing here
     egl.eglWaitGL();
     egl.eglSwapBuffers(jSDL2.mEGLDisplay, jSDL2.mEGLSurface);

 } catch(Exception e) {
     Log.v("SDL", "flipEGL(): " + e);
     for (StackTraceElement s : e.getStackTrace()) {
         Log.v("SDL", s.toString());
     }
 }
}

public static void deleteGLContext() {
	
	Log.i("6. deleteGLContext", "majorVersion");
	
    if (jSDL2.mEGLDisplay != null && jSDL2.mEGLContext != EGL10.EGL_NO_CONTEXT) {
        EGL10 egl = (EGL10)EGLContext.getEGL();
        egl.eglMakeCurrent(jSDL2.mEGLDisplay, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_CONTEXT);
        egl.eglDestroyContext(jSDL2.mEGLDisplay, jSDL2.mEGLContext);
        jSDL2.mEGLContext = EGL10.EGL_NO_CONTEXT;

        if (jSDL2.mEGLSurface != EGL10.EGL_NO_SURFACE) {
            egl.eglDestroySurface(jSDL2.mEGLDisplay, jSDL2.mEGLSurface);
            jSDL2.mEGLSurface = EGL10.EGL_NO_SURFACE;
        }
    }
}

public static boolean setActivityTitle(String title) {
    // Called from SDLMain() thread and can't directly affect the view
    return mSingleton.sendCommand(COMMAND_CHANGE_TITLE, title);
}

public static boolean sendMessage(int command, int param) {
    return mSingleton.sendCommand(command, Integer.valueOf(param));
}

public static Context getContext() {
    return (Context) controls.activity;
}
     
static class ShowTextInputTask implements Runnable {
    /*
     * This is used to regulate the pan&scan method to have some offset from
     * the bottom edge of the input region and the top edge of an input
     * method (soft keyboard)
     */
    static final int HEIGHT_PADDING = 15;

    public int x, y, w, h;

    public ShowTextInputTask(int x, int y, int w, int h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    @Override
    public void run() {
      /*  AbsoluteLayout.LayoutParams params = new AbsoluteLayout.LayoutParams(
                w, h + HEIGHT_PADDING, x, y);

        if (mTextEdit == null) {
            mTextEdit = new DummyEdit(getContext());

            mLayout.addView(mTextEdit, params);
        } else {
            mTextEdit.setLayoutParams(params);
        }

        mTextEdit.setVisibility(View.VISIBLE);
        mTextEdit.requestFocus();

        InputMethodManager imm = (InputMethodManager) getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.showSoftInput(mTextEdit, 0);
        */
    }
}

public static boolean showTextInput(int x, int y, int w, int h) {
    // Transfer the task to the main thread as a Runnable
    return mSingleton.commandHandler.post(new ShowTextInputTask(x, y, w, h));
}


// Audio
public static int audioInit(int sampleRate, boolean is16Bit, boolean isStereo, int desiredFrames) {
    int channelConfig = isStereo ? AudioFormat.CHANNEL_CONFIGURATION_STEREO : AudioFormat.CHANNEL_CONFIGURATION_MONO;
    int audioFormat = is16Bit ? AudioFormat.ENCODING_PCM_16BIT : AudioFormat.ENCODING_PCM_8BIT;
    int frameSize = (isStereo ? 2 : 1) * (is16Bit ? 2 : 1);
    
    Log.v("SDL", "SDL audio: wanted " + (isStereo ? "stereo" : "mono") + " " + (is16Bit ? "16-bit" : "8-bit") + " " + (sampleRate / 1000f) + "kHz, " + desiredFrames + " frames buffer");
    
    // Let the user pick a larger buffer if they really want -- but ye
    // gods they probably shouldn't, the minimums are horrifyingly high
    // latency already
    desiredFrames = Math.max(desiredFrames, (AudioTrack.getMinBufferSize(sampleRate, channelConfig, audioFormat) + frameSize - 1) / frameSize);
    
    if (mAudioTrack == null) {
        mAudioTrack = new AudioTrack(AudioManager.STREAM_MUSIC, sampleRate,
                channelConfig, audioFormat, desiredFrames * frameSize, AudioTrack.MODE_STREAM);
        
        // Instantiating AudioTrack can "succeed" without an exception and the track may still be invalid
        // Ref: https://android.googlesource.com/platform/frameworks/base/+/refs/heads/master/media/java/android/media/AudioTrack.java
        // Ref: http://developer.android.com/reference/android/media/AudioTrack.html#getState()
        
        if (mAudioTrack.getState() != AudioTrack.STATE_INITIALIZED) {
            Log.e("SDL", "Failed during initialization of Audio Track");
            mAudioTrack = null;
            return -1;
        }
        
        mAudioTrack.play();
    }
   
    Log.v("SDL", "SDL audio: got " + ((mAudioTrack.getChannelCount() >= 2) ? "stereo" : "mono") + " " + ((mAudioTrack.getAudioFormat() == AudioFormat.ENCODING_PCM_16BIT) ? "16-bit" : "8-bit") + " " + (mAudioTrack.getSampleRate() / 1000f) + "kHz, " + desiredFrames + " frames buffer");
    
    return 0;
}

public static void audioWriteShortBuffer(short[] buffer) {
    for (int i = 0; i < buffer.length; ) {
        int result = mAudioTrack.write(buffer, i, buffer.length - i);
        if (result > 0) {
            i += result;
        } else if (result == 0) {
            try {
                Thread.sleep(1);
            } catch(InterruptedException e) {
                // Nom nom
            }
        } else {
            Log.w("SDL", "SDL audio: error return from write(short)");
            return;
        }
    }
}

public static void audioWriteByteBuffer(byte[] buffer) {
    for (int i = 0; i < buffer.length; ) {
        int result = mAudioTrack.write(buffer, i, buffer.length - i);
        if (result > 0) {
            i += result;
        } else if (result == 0) {
            try {
                Thread.sleep(1);
            } catch(InterruptedException e) {
                // Nom nom
            }
        } else {
            Log.w("SDL", "SDL audio: error return from write(byte)");
            return;
        }
    }
}

public static void audioQuit() {
    if (mAudioTrack != null) {
        mAudioTrack.stop();
        mAudioTrack = null;
    }
}

}

/**
Simple nativeInit() runnable
*/

class SDLMain implements Runnable {
   Controls controls;
   long pascalObj;
   jSDL2 jsld;
 
   public SDLMain(Controls contls, long pasObj, jSDL2 sdl) {
     controls = contls;
     pascalObj = pasObj;
     jsld = sdl;
   }

   @Override
   public void run() {	
    // Runs SDL_main()
    Log.v("SDL", "thread Runs SDL_main(): pOnSDL2NativeInit");    
    controls.pOnSDL2NativeInit(pascalObj, jsld);    
   //Log.v("SDL", "SDL thread terminated");   
   }

}


