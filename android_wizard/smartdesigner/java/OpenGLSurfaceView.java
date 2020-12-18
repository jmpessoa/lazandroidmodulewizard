package com.example.appopenglsurfaceviewdemo1;

/*from  www.java2s.com*/
//http://www.java2s.com/Open-Source/Android_Free_Code/OpenGL/Example/com_androidbook_openglSimpleLitGLCube_java.htm

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.egl.EGLSurface;
import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import android.opengl.GLDebugHelper;
import android.opengl.GLU;

import android.util.Log;
import android.view.Gravity;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;


public class OpenGLSurfaceView extends SurfaceView implements SurfaceHolder.Callback {
    			                 
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
        
     //private int lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
     //private int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
     private int lparamH = 100;
     private int lparamW = 100;
     private int marginLeft = 5;
     private int marginTop = 5;
     private int marginRight = 5;
     private int marginBottom = 5;
     private int lgravity = Gravity.TOP | Gravity.START;
     private float lweight = 0;
        
     private boolean mRemovedFromParent = false;
        
     SurfaceHolder mAndroidHolder;
     BasicGLThread mGLThread;
     public static final float PI = 3.14159265358979323846f;     
                
        //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
               
     public OpenGLSurfaceView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
           super(_ctrls.activity);
           
           mAndroidHolder = getHolder();
           mAndroidHolder.addCallback(this);
           
           context   = _ctrls.activity;
           pascalObj = _Self;
           controls  = _ctrls;
        
           lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
           lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B
        
           /*
           onClickListener = new OnClickListener(){
           public void onClick(View view){  
                   if (enabled) {
                      controls.pOnClickGeneric(pascalObj); //JNI event onClick!
                   }
                };
           };
           setOnClickListener(onClickListener);           
           */
           
     } //end constructor
        
     public void jFree() {
           if (parent != null) { parent.removeView(this); }
           //free local objects...
           lparams = null;
           //setOnClickListener(null);
     }
        
     private static MarginLayoutParams newLayoutParams(ViewGroup _aparent, ViewGroup.MarginLayoutParams _baseparams) {
        	if (_aparent instanceof FrameLayout) {
        		return new FrameLayout.LayoutParams(_baseparams);
        	} else if (_aparent instanceof RelativeLayout) {
        		return new RelativeLayout.LayoutParams(_baseparams);
        	} else if (_aparent instanceof LinearLayout) {
        		return new LinearLayout.LayoutParams(_baseparams);
        	} else if (_aparent == null) {
        		throw new NullPointerException("Parent is null");
        	} else {
        		throw new IllegalArgumentException("Parent is neither FrameLayout or RelativeLayout or LinearLayout: "
        				+ _aparent.getClass().getName());
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

     
 	public int GetLParamWidth() { 
		int r =  lparamW;
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			r = this.getWidth();
		}		
		return r;
	}
	
	public int GetLParamHeight() {
		int r = lparamH;
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			r = this.getHeight();
		}
		return r;
	}

	
     public void SetLGravity(int _g) {
        	lgravity = _g;
     }
        
     public void SetLWeight(float _w) {
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
     	          for (int i=0; i < countAnchorRule; i++) {
     		         ((RelativeLayout.LayoutParams)lparams).addRule(lparamsAnchorRule[i], _idAnchor);
     	          }
     	       }
              for (int j=0; j < countParentRule; j++) {
                 ((RelativeLayout.LayoutParams)lparams).addRule(lparamsParentRule[j]);
              }
     	    }
           if (lparams instanceof FrameLayout.LayoutParams) {
           	((FrameLayout.LayoutParams)lparams).gravity = lgravity;
           }
           if (lparams instanceof LinearLayout.LayoutParams) {
           	((LinearLayout.LayoutParams)lparams).weight = lweight;
           }
           this.setLayoutParams(lparams);
     }
       
     public void ClearLayoutAll() {
           if (lparams instanceof RelativeLayout.LayoutParams) {
              for (int i=0; i < countAnchorRule; i++) {
                  ((RelativeLayout.LayoutParams)lparams).removeRule(lparamsAnchorRule[i]);
              }
              for (int j=0; j < countParentRule; j++) {
                  ((RelativeLayout.LayoutParams)lparams).removeRule(lparamsParentRule[j]);
              }
           }
           countAnchorRule = 0;
           countParentRule = 0;
     }
       
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
        
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        	
    }
        
    public void surfaceCreated(SurfaceHolder holder) {
            mGLThread = new BasicGLThread(this /*OpenGLSurfaceView*/ );            
            mGLThread.start();
    }

    public void surfaceDestroyed(SurfaceHolder holder) {
            if (mGLThread != null) {
                mGLThread.requestStop();
            }
    }
           
    
    public ByteBuffer getByteBufferFromByteArray(byte array[]) {
        ByteBuffer buffer = ByteBuffer.allocateDirect(array.length);
        buffer.put(array);
        buffer.position(0);
        return buffer;
     }
     
     public FloatBuffer getFloatBufferFromFloatArray(float array[]) {
         ByteBuffer tempBuffer = ByteBuffer.allocateDirect(array.length * 4);
         tempBuffer.order(ByteOrder.nativeOrder());
         FloatBuffer buffer = tempBuffer.asFloatBuffer();
         buffer.put(array);
         buffer.position(0);
         return buffer;
     }
     
     public IntBuffer getIntBufferFromIntArray( int array[]) {
        ByteBuffer tempBuffer = ByteBuffer.allocateDirect(array.length * 4);
        tempBuffer.order(ByteOrder.nativeOrder());
        IntBuffer buffer = tempBuffer.asIntBuffer();
        buffer.put(array);
        buffer.position(0);
        return buffer;
     }
     
    private class BasicGLThread extends Thread {
    	
        //main OpenGL variables
        GL10 mGL;
        EGL10 mEGL;
        
        EGLDisplay mGLDisplay;
        EGLConfig mGLConfig;
        EGLSurface mGLSurface;
        EGLContext mGLContext;
        
        int[] mConfigSpec = { EGL10.EGL_RED_SIZE, 5, 
                EGL10.EGL_GREEN_SIZE, 6, EGL10.EGL_BLUE_SIZE, 5, 
                EGL10.EGL_DEPTH_SIZE, 16, EGL10.EGL_NONE };
            	    	
        /*SurfaceView*/ OpenGLSurfaceView mysurface;  
        
        BasicGLThread(/*SurfaceView*/OpenGLSurfaceView  view) {
        	mysurface = view;  //OpenGLSurfaceView
        }
        
        private boolean mDone = false;
        
        public void run() {
        	
            initEGL();
            initGL();            
            
            //CubeSmallGLUT cube = new CubeSmallGLUT(3);   // <<<<< -------
            
            mGL.glMatrixMode(GL10.GL_MODELVIEW);
            mGL.glLoadIdentity();
            GLU.gluLookAt(mGL, 0, 0, 8f, 0, 0, 0, 0, 1, 0f);
            
            //while (!mDone) {
            	
                mGL.glClear(GL10.GL_COLOR_BUFFER_BIT| GL10.GL_DEPTH_BUFFER_BIT);
                mGL.glRotatef(1f, 1f, 1f, 1f);
                mGL.glColor4f(1f, 0f, 0f, 1f);
                
                //cube.draw(mGL);
                
                mGL.glFlush();                
                mEGL.eglSwapBuffers(mGLDisplay, mGLSurface);
                
            //}
            
        }
        
        public void requestStop() {
            mDone = true;
            try {
                join();
            } catch (InterruptedException e) {
                Log.e("GL", "failed to stop gl thread", e);
            }
            
            cleanupGL();
        }
        
        private void cleanupGL() {
            mEGL.eglMakeCurrent(mGLDisplay, EGL10.EGL_NO_SURFACE,
                    EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_CONTEXT);
            mEGL.eglDestroySurface(mGLDisplay, mGLSurface);
            mEGL.eglDestroyContext(mGLDisplay, mGLContext);
            mEGL.eglTerminate(mGLDisplay);

            Log.i("GL", "GL Cleaned up");
        }
        
        private void initGL( ) {
        
            int width = mysurface.GetLParamWidth();                      //getWidth();
            int height = mysurface.GetLParamHeight();                    //getHeight();
            
            mGL.glViewport(0, 0, width, height);
            mGL.glMatrixMode(GL10.GL_PROJECTION);
            mGL.glLoadIdentity();
            
            float aspect = (float) width/height;
            GLU.gluPerspective(mGL, 45.0f, aspect, 1.0f, 30.0f);
            mGL.glClearColor(0.5f,0.5f,0.5f,1);
            mGL.glClearDepthf(1.0f);
                          
             // light
            mGL.glEnable(GL10.GL_LIGHTING);
            
            // the first light
            mGL.glEnable(GL10.GL_LIGHT0);
            
            // ambient values
            mGL.glLightfv(GL10.GL_LIGHT0, GL10.GL_AMBIENT, new float[] {0.1f, 0.1f, 0.1f, 1f}, 0);
            
            // light that reflects in all directions
            mGL.glLightfv(GL10.GL_LIGHT0, GL10.GL_DIFFUSE, new float[] {1f, 1f, 1f, 1f}, 0);
            
            // place it in projection space
            mGL.glLightfv(GL10.GL_LIGHT0, GL10.GL_POSITION, new float[] {10f, 0f, 10f, 1}, 0);
            
            // allow our object colors to create the diffuse/ambient material setting
            mGL.glEnable(GL10.GL_COLOR_MATERIAL);
             
             // some rendering options
             mGL.glShadeModel(GL10.GL_SMOOTH);
             
             mGL.glEnable(GL10.GL_DEPTH_TEST);
             //mGL.glDepthFunc(GL10.GL_LEQUAL);
             mGL.glEnable(GL10.GL_CULL_FACE);
             
             mGL.glHint(GL10.GL_PERSPECTIVE_CORRECTION_HINT,GL10.GL_NICEST);
             
             // the only way to draw primitives with OpenGL ES
             mGL.glEnableClientState(GL10.GL_VERTEX_ARRAY);

            Log.i("GL", "GL initialized");
        }
        
        private void initEGL() {
            mEGL = (EGL10) GLDebugHelper.wrap(EGLContext.getEGL(),
                    GLDebugHelper.CONFIG_CHECK_GL_ERROR
                            | GLDebugHelper.CONFIG_CHECK_THREAD,  null);
            
            mGLDisplay = mEGL.eglGetDisplay(EGL10.EGL_DEFAULT_DISPLAY);

            int[] curGLVersion = new int[2];
            mEGL.eglInitialize(mGLDisplay, curGLVersion);

            Log.i("GL", "GL version = " + curGLVersion[0] + "."
                    + curGLVersion[1]);

            EGLConfig[] configs = new EGLConfig[1];
            int[] num_config = new int[1];
            mEGL.eglChooseConfig(mGLDisplay, mConfigSpec, configs, 1,num_config);
            mGLConfig = configs[0];

            mGLSurface = mEGL.eglCreateWindowSurface(mGLDisplay, mGLConfig, mysurface.getHolder(), null);

            mGLContext = mEGL.eglCreateContext(mGLDisplay, mGLConfig,EGL10.EGL_NO_CONTEXT, null);

            mEGL.eglMakeCurrent(mGLDisplay, mGLSurface, mGLSurface, mGLContext);
            mGL = (GL10) GLDebugHelper.wrap(mGLContext.getGL(),
                    GLDebugHelper.CONFIG_CHECK_GL_ERROR
                            | GLDebugHelper.CONFIG_CHECK_THREAD
                            | GLDebugHelper.CONFIG_LOG_ARGUMENT_NAMES, null);
            
        }
        
    }
    
}