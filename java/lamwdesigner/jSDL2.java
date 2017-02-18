package com.example.appsdl2demo1;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.egl.EGLSurface;

import android.app.*;
import android.content.*;
import android.view.SurfaceView;
import android.view.*;
import android.view.inputmethod.InputMethodManager;
import android.os.*;
import android.util.Log;
import android.media.*;
import android.hardware.*;

/**
    SDL Activity
*/
public class jSDL2 {
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

    // C functions we call
    
     //-------------------
   
    // Java functions called from C
    public static boolean createGLContext(int majorVersion, int minorVersion, int[] attribs) {
        return initEGL(majorVersion, minorVersion, attribs);
    }
    
    public static void deleteGLContext() {
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

    public static void flipBuffers() {
        flipEGL();
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

    // EGL functions
    public static boolean initEGL(int majorVersion, int minorVersion, int[] attribs) {
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

    public static boolean createEGLContext() {
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

    public static boolean createEGLSurface() {
    	
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

    // EGL buffer flip
    public static void flipEGL() {
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
public SDLMain(Controls contls, long pasObj) {
	controls = contls;
	pascalObj = pasObj; 
}

@Override
public void run() {
    // Runs SDL_main()
	Log.v("SDL", "thread Runs SDL_main()");
    controls.pOnSDL2NativeInit(pascalObj);
    //Log.v("SDL", "SDL thread terminated");
}
}


