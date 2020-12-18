package com.example.appopenglsurfaceviewdemo3;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.egl.EGLSurface;
import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.PixelFormat;
import android.graphics.PointF;
import android.opengl.GLDebugHelper;
import android.opengl.GLU;
import android.opengl.GLUtils;
import android.os.Build;
import android.util.Log;
import android.util.SparseArray;
import android.view.GestureDetector;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import java.lang.reflect.Field;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import java.nio.ShortBuffer; 

class ConstRenderer {            
	public static final int kOnSurfaceCreated   =  0;
	public static final int kOnSurfaceChanged   =  1;
	public static final int kOnDrawFrame        =  2;
	public static final int kOnSurfaceDestroyed =  3;
	public static final int kOnSurfaceThread    =  4;	
}

// ref.
//http://www.java2s.com/Open-Source/Android_Free_Code/OpenGL/Example/com_androidbook_openglSimpleLitGLCube_java.htm

public class jOpenGLSurfaceView extends SurfaceView implements SurfaceHolder.Callback {
    			                 
     private long       pascalObj = 0;    // Pascal Object
     private Controls   controls  = null; // Control Class for events
        
     private jCommons LAMWCommon;
     
     private Context context = null;
        
     //private OnClickListener onClickListener;   // click event
     private Boolean enabled  = true;           // click-touch enabled!
                        
     SurfaceHolder mAndroidHolder;
     
     BasicGLThread mGLThread;
     public static final float PI = 3.14159265358979323846f;
     
     //main OpenGL variables
     GL10 mGL;
     EGL10 mEGL;
     
     EGLDisplay mGLDisplay;
     EGLConfig mGLConfig;
     EGLSurface mGLSurface;
     EGLContext mGLContext;
     
     int mWidth; 
     int mHeight; 
          
     int[] mConfigSpec = { EGL10.EGL_RED_SIZE, 5, 
             EGL10.EGL_GREEN_SIZE, 6, EGL10.EGL_BLUE_SIZE, 5, 
             EGL10.EGL_DEPTH_SIZE, 16, EGL10.EGL_NONE };
     
     boolean mInitialized = false;
     
     private byte[] mIndices;
     
     private int[] mGenTextureIDs;
     
     Bitmap mBitmap;
     
     float mRotateAngle = 0;
     
     GestureDetector gDetect;
     ScaleGestureDetector scaleGestureDetector;
     
 	private float mScaleFactor = 1.0f;
 	private float MIN_ZOOM = 0.25f;
 	private float MAX_ZOOM = 4.0f;
 	private int mPinchZoomGestureState = 3; //pzNone 	    
     int mFling = 0;    	
     
 	float mPointX[];  //five fingers
 	float mPointY[];  //five fingers 			
 	int mCountPoint = 0; 	
 	private SparseArray<PointF> mActivePointers;
 	
 	float mCameraX = 0;
 	float mCameraY = 0; 
 	float mCameraZ = 8; 	
 	float mCenterX = 0;
 	float mCenterY = 0; 
 	float mCenterZ = 0; 	
 	float mUpX = 0; 
 	float mUpY = 1;
 	float mUpZ = 0;
 	
 	//-ratio, ratio, -1, 1, 3, 7
 	float mFrustumLeft; // -ratio
 	float mFrustumRight; //ratio 	
 	float mFrustumBottom = -1;
 	float mFrustumTop = 1; 
 	float mFrustumZNear = 3; 
 	float mFrustumZFar = 7; 	
 	
 	float mAspectRatio;
	
     //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...              
     public jOpenGLSurfaceView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
           super(_ctrls.activity);
           
           mAndroidHolder = getHolder();
           mAndroidHolder.addCallback(this);
                      
           context   = _ctrls.activity;
           pascalObj = _Self;
           controls  = _ctrls;
        
           LAMWCommon = new jCommons(this,context,pascalObj);
                   
     	   mCountPoint = 0;		 
   		   mActivePointers = new SparseArray<PointF>();
           
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
           getHolder().setFormat(PixelFormat.RGBA_8888); 
           //getHolder().setFormat(PixelFormat.TRANSLUCENT);            
           gDetect = new GestureDetector(controls.activity, new GestureListener());
   		   scaleGestureDetector = new ScaleGestureDetector(controls.activity, new simpleOnScaleGestureListener());           
           
     } //end constructor
        
     public void jFree() {
        //free local objects...
    	//setOnClickListener(null);    	 
 		gDetect = null; 			
 		scaleGestureDetector = null;
 		LAMWCommon.free();    	 
     }
                       
     public void SetViewParent(ViewGroup _viewgroup) {
 		LAMWCommon.setParent(_viewgroup);
     }
        
 	 public ViewGroup GetParent() {   //TODO Pascal
		return LAMWCommon.getParent();
	 }
 	
     public void RemoveFromViewParent() {
    	 LAMWCommon.removeFromViewParent();
     }
       
     public View GetView() {
        return this;
     }
       
     public void SetLParamWidth(int _w) {
    	 LAMWCommon.setLParamWidth(_w);
     }
       
     public void SetLParamHeight(int _h) {
    	 LAMWCommon.setLParamHeight(_h);
     }
     
 	 public int GetLParamWidth() { 
 		return LAMWCommon.getLParamWidth();					
	 }
	
	 public int GetLParamHeight() {
	   return  LAMWCommon.getLParamHeight();
	 }
	
     public void SetLGravity(int _g) {
    	LAMWCommon.setLGravity(_g);
     }
        
     public void SetLWeight(float _w) {
    	LAMWCommon.setLWeight(_w);
     }
        
     public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
 		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
     }
       
     public void AddLParamsAnchorRule(int _rule) {
 		LAMWCommon.addLParamsAnchorRule(_rule);
     }
       
     public void AddLParamsParentRule(int _rule) {
 		LAMWCommon.addLParamsParentRule(_rule);
     }
       
     public void SetLayoutAll(int _idAnchor) {
    	LAMWCommon.setLayoutAll(_idAnchor);
     }
          
 	 public void clearLayoutAll() {
 		LAMWCommon.clearLayoutAll();
	 }      
 	
      
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...   
     
     private void CleanupEGL() {
         mEGL.eglMakeCurrent(mGLDisplay, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_SURFACE, EGL10.EGL_NO_CONTEXT);
         mEGL.eglDestroySurface(mGLDisplay, mGLSurface);
         mEGL.eglDestroyContext(mGLDisplay, mGLContext);
         mEGL.eglTerminate(mGLDisplay);
         Log.i("EGL", "EGL Cleaned up");
         mInitialized = false;
     }          
     
     private void initEGL(SurfaceHolder myHolder) {
    	 
         mEGL = (EGL10) GLDebugHelper.wrap(EGLContext.getEGL(),
                 GLDebugHelper.CONFIG_CHECK_GL_ERROR
                         | GLDebugHelper.CONFIG_CHECK_THREAD,  null);
         
         mGLDisplay = mEGL.eglGetDisplay(EGL10.EGL_DEFAULT_DISPLAY);

         int[] curGLVersion = new int[2];
         mEGL.eglInitialize(mGLDisplay, curGLVersion);

         Log.i("1. EGL", "EGL version = " + curGLVersion[0] + "." + curGLVersion[1]);

         EGLConfig[] configs = new EGLConfig[1];
         int[] num_config = new int[1];
         mEGL.eglChooseConfig(mGLDisplay, mConfigSpec, configs, 1, num_config);
                       
         mGLConfig = configs[0];

         mGLSurface = mEGL.eglCreateWindowSurface(mGLDisplay, mGLConfig, myHolder, null);

         mGLContext = mEGL.eglCreateContext(mGLDisplay, mGLConfig,EGL10.EGL_NO_CONTEXT, null);

         mEGL.eglMakeCurrent(mGLDisplay, mGLSurface, mGLSurface, mGLContext);
         
         mGL = (GL10) GLDebugHelper.wrap(mGLContext.getGL(),
                 GLDebugHelper.CONFIG_CHECK_GL_ERROR
                         | GLDebugHelper.CONFIG_CHECK_THREAD
                         | GLDebugHelper.CONFIG_LOG_ARGUMENT_NAMES, null);                  
     }
          
     private void initGL(int width, int height) {
           
         mGL.glViewport(0, 0, width, height);
         mGL.glMatrixMode(GL10.GL_PROJECTION);  //GL_PROJECTION GL_MODELVIEW
         
         mGL.glLoadIdentity();
                  
         mWidth = width;
         mHeight = height;
         
         mAspectRatio = (float) width/height;
      	 mFrustumLeft = -mAspectRatio; // -ratio
     	 mFrustumRight = mAspectRatio ; //ratio
                  
         GLU.gluPerspective(mGL, 45.0f, mAspectRatio, 1.0f, 30.0f);
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
         
         //allow our object colors to create the diffuse/ambient material setting
         mGL.glEnable(GL10.GL_COLOR_MATERIAL);          
          //some rendering options
          mGL.glShadeModel(GL10.GL_SMOOTH);
          
          mGL.glEnable(GL10.GL_DEPTH_TEST);                   
          //mGL.glDepthFunc(GL10.GL_LEQUAL);
          
          //Counter-clockwise winding.
          mGL.glFrontFace(GL10.GL_CCW);    //Front face in counter-clockwise orientation
          mGL.glEnable(GL10.GL_CULL_FACE);                    
          //What faces to remove with the face culling.
  		 //mGL.glCullFace(GL10.GL_BACK); //***
          
          mGL.glHint(GL10.GL_PERSPECTIVE_CORRECTION_HINT,GL10.GL_NICEST);
                            
          // the only way to draw primitives with OpenGL ES
          //mGL.glEnableClientState(GL10.GL_VERTEX_ARRAY);                          	
         Log.i("2. GL", "GL initialized");                  
    }
     
    public void surfaceCreated(SurfaceHolder holder) {
    	setWillNotDraw(false); //now we can call "invalidate" to dispatch "onDraw"              	
    	//initEGL(holder);
    }
        
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
    	
        int sdlPixelFormat = 0x15151002; // SDL_PIXELFORMAT_RGB565 by default
        int androidPixelFormat = format;
        
        switch (format) {
        case PixelFormat.RGBA_8888:
            sdlPixelFormat = 0x16462004; // SDL_PIXELFORMAT_RGBA8888
        }
        
        mWidth = width; 
        mHeight = height;
	    mAspectRatio = (float) mWidth / mHeight;	    
     	mFrustumLeft = -mAspectRatio; // -ratio
    	mFrustumRight = mAspectRatio ; //ratio	    
                                
        initEGL(holder); 
    	initGL(width, height);
    	mInitialized = true;
    	
        controls.pOpenGLSurfaceViewInitialized(pascalObj, mGL, mEGL, mGLDisplay, mGLSurface, mGLContext, mWidth, mHeight);
    	    	
    	controls.pOpenGLSurfaceViewChanged(pascalObj,holder,width,height, androidPixelFormat);
    	   	
    	//StartGLThread();
    	Log.i("3. EGL/GL", "Surface Changed...");
    	
    }
    
    public void StartGLThread() {  
    	if (mInitialized) { 
           mGLThread = new BasicGLThread();              
           mGLThread.start();
    	}   
    }
    
    public void surfaceDestroyed(SurfaceHolder holder) {    	
    	controls.pOpenGLSurfaceViewDestroyed(pascalObj);
    	
    	if (mGLThread != null)
    	   mGLThread.requestStop();    	
    	CleanupEGL();
    	
    }
    
    /*
     * gluLookAt(GL10 gl, float eyeX, float eyeY, float eyeZ, 
     *                    float centerX, float centerY, float centerZ, 
     *                    float upX, float upY, float upZ)
       Define a viewing transformation in terms of an eye point, a center of view, and an up vector.
     */
    
    public void GluLookAt(GL10 _gl, float _cameraX, float _cameraY, float _cameraZ, 
    		float _centerX, float _centerY, float _centerZ, float _upX, float _upY, float _upZ) {
      if (mInitialized) {
    	 	mCameraX = _cameraX;
    	 	mCameraY = _cameraY; 
    	 	mCameraZ = _cameraZ; 	
    	 	mCenterX = _centerX;
    	 	mCenterY = _centerY; 
    	 	mCenterZ = _centerZ; 	
    	 	mUpX = _upX; 
    	 	mUpY = _upY;
    	 	mUpZ = _upZ;
            GLU.gluLookAt(_gl, _cameraX, _cameraY, _cameraZ, _centerX, _centerY, _centerZ, _upX, _upY, _upZ);  //set position ... TODO
      }
    } 	
    
    public void GluLookAtCenter(GL10 _gl, float _centerX, float _centerY, float _centerZ) {
      if (mInitialized) {
  	 	 mCenterX = _centerX;
  	 	 mCenterY = _centerY; 
  	 	 mCenterZ = _centerZ;    	  
         GLU.gluLookAt(_gl, mCameraX, mCameraY, mCameraZ, _centerX, _centerY, _centerZ, mUpX, mUpY, mUpZ);  //set position ... TODO
      }
    }
    
    public void GluLookAtCamera(GL10 _gl, float _cameraX, float _cameraY, float _cameraZ) {
       if (mInitialized) { 
   	 	 mCameraX = _cameraX;
   	 	 mCameraY = _cameraY; 
   	 	 mCameraZ = _cameraZ; 	    	   
         GLU.gluLookAt(_gl, _cameraX, _cameraY, _cameraZ, mCenterX, mCenterY, mCenterZ, mUpX, mUpY, mUpZ);  //set position ... TODO
       }          
    }    
    
    @Override
    protected void onDraw(Canvas canvas) {
      //Log.i("onDraw", "Angel = " + mRotateAngle);
        //http://www.lucazanini.eu/en/2013/android/drawing-a-triangle-with-opengl-es-in-android/
      if (mInitialized) {  //http://www3.ntu.edu.sg/home/ehchua/programming/android/Android_3D.html - OTIMO!!!!
    	  
          mGL.glMatrixMode(GL10.GL_MODELVIEW); // When using GL_MODELVIEW, you must set the camera : gluLookAt
          mGL.glLoadIdentity();
          mGL.glClear(GL10.GL_COLOR_BUFFER_BIT| GL10.GL_DEPTH_BUFFER_BIT);          
          GLU.gluLookAt(mGL, mCameraX, mCameraY, mCameraZ, mCenterX, mCenterY, mCenterZ, mUpX, mUpY, mUpZ);  
          
          //mGL.glRotatef(1f, 1f, 1f, 1f);          
          //mGL.glColor4f(1f, 0f, 0f, 1f);          
          //drawSimpleCube (mGL);         
          
          //TODO! need return (x,y,z) position to draw the object!!!
          //http://stackoverflow.com/questions/5107016/glu-glulookat-in-java-opengl-bindings-seems-to-do-nothing
          //http://www.glprogramming.com/red/chapter03.html
          //https://learnopengl.com/
          controls.pOpenGLSurfaceViewDraw(pascalObj, mGL, mEGL, mGLDisplay, mGLSurface, mGLContext, mWidth, mHeight);
          
          mGL.glFlush();          
          mEGL.eglSwapBuffers(mGLDisplay, mGLSurface);          
       }      
      
    }
        
    public void  Invalidate() { 
       this.invalidate();  //try force "OnDraw" [no threaded!]      
    }
    
    public void StopGLThread() {    	       
        if (mGLThread != null) {
            mGLThread.requestStop();
        }        	
    }
    
    public ByteBuffer GetByteBufferFromByteArray(byte[] _values) {
        ByteBuffer buffer = ByteBuffer.allocateDirect(_values.length);
        buffer.order(ByteOrder.nativeOrder());
        buffer.put(_values);
        buffer.position(0);
        return buffer;
     }
     
     public FloatBuffer GetFloatBufferFromFloatArray(float[] _values) {
         ByteBuffer tempBuffer = ByteBuffer.allocateDirect(_values.length * 4);
         tempBuffer.order(ByteOrder.nativeOrder());
         FloatBuffer buffer = tempBuffer.asFloatBuffer();
         buffer.put(_values);
         buffer.position(0);
         return buffer;
     }
     
     public IntBuffer GetIntBufferFromIntArray(int[] _values) {
        ByteBuffer tempBuffer = ByteBuffer.allocateDirect(_values.length * 4);
        tempBuffer.order(ByteOrder.nativeOrder());
        IntBuffer buffer = tempBuffer.asIntBuffer();
        buffer.put(_values);
        buffer.position(0);
        return buffer;
     }
          
     public ShortBuffer GetShortBufferFromShortArray(short[] _values) {
         ByteBuffer tempBuffer = ByteBuffer.allocateDirect(_values.length * 2);
         tempBuffer.order(ByteOrder.nativeOrder());
         ShortBuffer buffer = tempBuffer.asShortBuffer();
         buffer.put(_values);
         buffer.position(0);
         return buffer;
     }
               
     //ref. https://www.jayway.com/2009/12/04/opengl-es-tutorial-for-android-part-ii-building-a-polygon/
     //ref. https://www.jayway.com/2010/01/01/opengl-es-tutorial-for-android-part-iii-transformations/     
     /*
      * // save the current matrix state
           glPushMatrix() 
          // Transform
          glTranslate(...)
          glRotate(...)
         //draw
          glDrawArrays(...)
         // Restore the transformation matrix to when it was saved.
           glPopMatrix()
      */          
     //ModelView is the matrix that represents your camera (position, pointing, and up vector).
     //Projection view is the matrix that represents your camera's lens (aperture, far-field, near-field, etc).
     
     ////This should go immediately before any manipulation of rotation, vertexes, etc. 
     //Any model related call. You pop the matrix when you're done. It's like opening a new editing space and closing it to seal in the changes.
     
     //ref. http://stackoverflow.com/questions/7724840/is-it-possible-to-rotate-an-object-around-its-own-axis-and-not-around-the-base-c     
     public void GLFrustum(GL10 _gl, float _left, float _right,float _bottom,float _top, float _zNear,float _zFar) {  //used with matrix mode projection TODO
    	 if (mInitialized) {
    		  
    		mFrustumLeft = _left;
    		mFrustumRight =_right; 
    		mFrustumBottom = _bottom;
    		mFrustumTop = _top; 
    		mFrustumZNear = _zNear; 
    		mFrustumZFar = _zFar;
    		
    	    _gl.glMatrixMode(GL10.GL_PROJECTION);        // set matrix to projection mode
    	    _gl.glLoadIdentity();                        // reset the matrix to its default state
    	    _gl.glFrustumf(mFrustumLeft, mFrustumRight, mFrustumBottom, mFrustumTop, mFrustumZNear, mFrustumZNear);  // apply the projection matrix -ratio, ratio, -1, 1, 3, 7    	      
    	 }    
     }
      
     public void GLFrustumNearFar(GL10 _gl, float _zNear, float _zFar) {  //used with matrix mode projection
    	 if (mInitialized) {
     		  mFrustumZNear = _zNear; 
     		  mFrustumZFar = _zFar;
     		  
    	      // make adjustments for screen ratio
    	      //float ratio = (float) mWidth / mHeight; //-ratio, ratio, -1, 1, 3, 7
     		  
    	      _gl.glMatrixMode(GL10.GL_PROJECTION);        // set matrix to projection mode
    	      _gl.glLoadIdentity();                        // reset the matrix to its default state
    	      _gl.glFrustumf(mFrustumLeft , mFrustumRight, mFrustumBottom, mFrustumTop,_zNear,_zFar);  // apply the projection matrix     	      
    	 }    
     }     
     
     public void GLMatrixMode(GL10 _gl, int  _matrixMode) {
    	 if (mInitialized) {    		 
    		switch(_matrixMode) {
    		  case 0: { _gl.glMatrixMode(GL10.GL_MODELVIEW); _gl.glLoadIdentity();
    		            GLU.gluLookAt(mGL, mCameraX, mCameraY, mCameraZ, mCenterX, mCenterY, mCenterZ, mUpX, mUpY, mUpZ);
    		            break;
    		          }  //for glTranslated or glRotated
    		  case 1: { _gl.glMatrixMode(GL10.GL_PROJECTION); _gl.glLoadIdentity(); 
    		            _gl.glFrustumf(mFrustumLeft, mFrustumRight, mFrustumBottom, mFrustumTop, mFrustumZNear, mFrustumZNear); 
    		            break; 
    		          } //for glFrustum,
    		}
    	 }  
     }
          
     public void  GLPushMatrix(GL10 _gl) { //makes a copy of the current matrix and put it on the stack
    	 if (mInitialized)
    	  _gl.glPushMatrix();
     }
     
     public void  GLPopMatrix(GL10 _gl) { //get back to the previous "Pushed "matrix
    	 if (mInitialized)
    	   _gl.glPopMatrix();
     }
     
     public void GLLoadIdentity(GL10 _gl){
    	 if (mInitialized)
    	   _gl.glLoadIdentity(); //replaces the current matrix with the identity matrix.
     }
         
     public void GLScalef(GL10 _gl, float _x, float _y, float _z) {
    	 if (mInitialized) 
          _gl.glScalef(_x, _y, _z);   //0.5f, 0.5f, 0.5f  :: scale to "1/2"
     }
 
     //   _gl.glTexEnvf(GL10.GL_TEXTURE_ENV, GL10.GL_TEXTURE_ENV_MODE,GL10.GL_REPLACE); 
     public void GLTexEnvf(GL10 _gl, int _textureActMode) {
       if (mInitialized) { 
    	  switch (_textureActMode) {
    	  case 0:  _gl.glTexEnvf(GL10.GL_TEXTURE_ENV, GL10.GL_TEXTURE_ENV_MODE,GL10.GL_REPLACE); break;//drop _gl.glColor4f(...)
    	  case 1:  _gl.glTexEnvf(GL10.GL_TEXTURE_ENV, GL10.GL_TEXTURE_ENV_MODE,GL10.GL_MODULATE); break; 
    	  case 2:  _gl.glTexEnvf(GL10.GL_TEXTURE_ENV, GL10.GL_TEXTURE_ENV_MODE,GL10.GL_DECAL); break; 
    	  }
       }   
     }
     
     public void GLTranslatef(GL10 _gl, float _x, float _y, float _z) {  //matrix mode_view
    	 if (mInitialized)
            _gl.glTranslatef(_x, _y, _z); //(2, 0, 0) // Translates 2 units [-->x] in the screen.
     }
     
     //glRotatef(float angle, float x, float y, float z)
     public void GLRotatef(GL10 _gl, float _angleDegrees , float _x, float _y, float _z) {   //matrix mode_view
    	 if (mInitialized) {    		
           _gl.glRotatef(_angleDegrees, _x, _y, _z);  //1f, 1f, 1f, 1f
    	 }   
     }	 
              
     public void GLClearColor(GL10 _gl, float _red, float _green, float _blue) {
    	 if (mInitialized)
           _gl.glClearColor(_red, _green, _blue,1);
     }
     
    //glColor4f(float red, float green, float blue, float alpha) 
    public void GLColor4f(GL10 _gl, float _red, float _green, float _blue, float _alpha) {
       if (mInitialized)
          _gl.glColor4f( _red, _green, _blue, _alpha);  //1f, 0f, 0f, 1f
    }  
            
    /*
     * gl.glVertexPointer to refer to the buffer for vertices contained in an array with X, Y, Z values. 
     * For lines, they are formed by connecting the indices from the vertex array. 
     * For areas, they are constructed by connecting oriented triangles.
     *  
     * You can specify the vertex order used for the triangles 
     * with gl.glFrontFace(GL10.GL_CCW) for counter clockwise orientation or gl.glFrontFace(GL10.GL_CW) for clockwise.
     * 
     * Rendering primitives include GL_POINTS for points 
     * and GL_LINES, GL_LINE_STRIP, and GL_LINE_LOOP are available for lines.
     *  
     * For triangles, the options are GL_TRIANGLES, GL_TRIANGLE_STRIP, and GL_TRIANGLE_FAN. 
     * These can be rendered through gl.glDrawElements with their byte buffers provided.
     */        
        
    public void GLTexCoordPointer(GL10 _gl,  FloatBuffer _textureBuffer) {    	
    	if (mInitialized)  {
    	  _gl.glEnableClientState(GL10.GL_TEXTURE_COORD_ARRAY);  // Enable texture-coords-array    		
          _gl.glTexCoordPointer(2, GL10.GL_FLOAT, 0, _textureBuffer); // Define texture-coords buffer    	     	 
    	}  
    }
    
    public void GLColorPointer(GL10 _gl,  FloatBuffer _colorBuffer) {    	
        if (mInitialized) {
        	_gl.glEnableClientState(GL10.GL_COLOR_ARRAY);
            _gl.glColorPointer(4, GL10.GL_FLOAT, 0, _colorBuffer);           
        }    
    }
    
    //gl.glVertexPointer(3, GL10.GL_FLOAT, 0, vertexBuffer);
    //define vertex  buffer     
    public void GLVertexPointer(GL10 _gl,  FloatBuffer _vertexBuffer) {    	
       if (mInitialized) {     	
    	   _gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);    	   
           _gl.glVertexPointer(3, GL10.GL_FLOAT, 0, _vertexBuffer);           
       }    
    }
         
    /*
     * Rendering primitives include GL_POINTS for points
     *  
     * and GL_LINES, GL_LINE_STRIP, and GL_LINE_LOOP are available for lines.
     *  
     * For triangles, the options are GL_TRIANGLES, GL_TRIANGLE_STRIP, and GL_TRIANGLE_FAN. 
     * These can be rendered through gl.glDrawElements with their byte buffers provided.
     */
        
    //drawing....
    // Draw the primitives from the vertex-array directly  //Vertices().length / 3
    public void GLDrawArrays(GL10 _gl, int _primitiveType,  int _startingIndex, int _elementsCount) {
    	if (mInitialized) {    		
    	   switch (_primitiveType) {   //0: the starting index in the enabled arrays
    	      case 0: _gl.glDrawArrays(GL10.GL_POINTS, _startingIndex, _elementsCount); //the number of indices/vertices to be rendered.
    	      case 1: _gl.glDrawArrays(GL10.GL_LINES, _startingIndex,  _elementsCount);
    	      case 2: _gl.glDrawArrays(GL10.GL_LINE_LOOP, _startingIndex, _elementsCount);
    	      case 3: _gl.glDrawArrays(GL10.GL_LINE_STRIP, _startingIndex, _elementsCount);
    	      case 4: _gl.glDrawArrays(GL10.GL_TRIANGLES, _startingIndex, _elementsCount);
    	      case 5: _gl.glDrawArrays(GL10.GL_TRIANGLE_STRIP, _startingIndex, _elementsCount);
    	      case 6: _gl.glDrawArrays(GL10.GL_TRIANGLE_FAN, _startingIndex, _elementsCount);
    	   }    	       	 
    	}   
    }
      
    //drawing....
    public void GLDrawElements(GL10 _gl, int _primitiveType, int _indicesLength,   ByteBuffer _indexBuffer) {
      if (mInitialized) {    	  
    	 switch (_primitiveType) {
    	    case 0: _gl.glDrawElements(GL10.GL_POINTS, _indicesLength,  GL10.GL_UNSIGNED_BYTE, _indexBuffer);
    	    case 1: _gl.glDrawElements(GL10.GL_LINES, _indicesLength,  GL10.GL_UNSIGNED_BYTE, _indexBuffer);
    	    case 2: _gl.glDrawElements(GL10.GL_LINE_LOOP, _indicesLength,  GL10.GL_UNSIGNED_BYTE, _indexBuffer);
    	    case 3: _gl.glDrawElements(GL10.GL_LINE_STRIP, _indicesLength,  GL10.GL_UNSIGNED_BYTE, _indexBuffer);
    	    case 4: _gl.glDrawElements(GL10.GL_TRIANGLES, _indicesLength,  GL10.GL_UNSIGNED_BYTE, _indexBuffer);
    	    case 5: _gl.glDrawElements(GL10.GL_TRIANGLE_STRIP, _indicesLength,  GL10.GL_UNSIGNED_BYTE, _indexBuffer);
    	    case 6: _gl.glDrawElements(GL10.GL_TRIANGLE_FAN, _indicesLength,  GL10.GL_UNSIGNED_BYTE, _indexBuffer);
    	 }    	     
      }	 
    }
    
    public void GLDrawElements(GL10 _gl, int _primitiveType, int _indicesLength,   ShortBuffer _indexBuffer) {
        if (mInitialized) {    	  
      	 switch (_primitiveType) {
      	    case 0: _gl.glDrawElements(GL10.GL_POINTS, _indicesLength,  GL10.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 1: _gl.glDrawElements(GL10.GL_LINES, _indicesLength,  GL10.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 2: _gl.glDrawElements(GL10.GL_LINE_LOOP, _indicesLength,  GL10.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 3: _gl.glDrawElements(GL10.GL_LINE_STRIP, _indicesLength,  GL10.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 4: _gl.glDrawElements(GL10.GL_TRIANGLES, _indicesLength,  GL10.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 5: _gl.glDrawElements(GL10.GL_TRIANGLE_STRIP, _indicesLength,  GL10.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 6: _gl.glDrawElements(GL10.GL_TRIANGLE_FAN, _indicesLength,  GL10.GL_UNSIGNED_SHORT, _indexBuffer);
      	 }    	     
        }	 
      }    
        //http://www.saturn.dti.ne.jp/~npaka/android/Graphics2DEx/index.html                      
    private class BasicGLThread extends Thread {    	                    	    	                 
    	
        BasicGLThread() { 
           //
        }   
        
        private boolean mDone = false;
        
        public void run() {        	
            controls.pOpenGLSurfaceViewThreadPrompt(pascalObj,mGL, mEGL, mGLDisplay, mGLSurface, mGLContext, mWidth, mHeight);
            //CubeSmallGLUT cube = new CubeSmallGLUT(3);   // <<<<< -------            
            mGL.glMatrixMode(GL10.GL_MODELVIEW);
            mGL.glLoadIdentity();
            GLU.gluLookAt(mGL, 0, 0, 8f, 0, 0, 0, 0, 1, 0f);
            //mGL.glColor4f(1f, 0f, 0f, 1f);                
            while (!mDone) {            	
                //mGL.glClear(GL10.GL_COLOR_BUFFER_BIT| GL10.GL_DEPTH_BUFFER_BIT);
                //mGL.glRotatef(1f, 1f, 1f, 1f);
                
                //cube.draw(mGL);
                mDone = controls.pOpenGLSurfaceViewThreadLooping(pascalObj,mGL, mEGL, mGLDisplay, mGLSurface, mGLContext, mWidth, mHeight);
                
                mGL.glFlush();                
                mEGL.eglSwapBuffers(mGLDisplay, mGLSurface);                
            }            
        }
        
        public void requestStop() {
            mDone = true;
            try {
                join();
            } catch (InterruptedException e) {
                Log.e("GL", "failed to stop gl thread", e);
            }                      
        }
    }
                   

    
    public void GLTexture2D(GL10 _gl, boolean _enable) {
    	if (!_enable)
          _gl.glDisable(GL10.GL_TEXTURE_2D);
    	else
    	  _gl.glEnable(GL10.GL_TEXTURE_2D);  //Enable texture
    }    
    
    public void GLBlendFunc (GL10 _gl, int _glValue1, int _glValue2) {
    	
    	int v1 = GL10.GL_ONE; // 1
    	int v2 = GL10.GL_ONE_MINUS_SRC_ALPHA; //771
    	
    	switch(_glValue1) {
    	   case 0: v1 = GL10.GL_ONE;
    	}
    	
    	switch(_glValue2) {
 	       case 1: v2 = GL10.GL_ONE_MINUS_SRC_ALPHA;
 	    }
    	
    	_gl.glBlendFunc(v1,v2);     	 
    }
    
    //glTexture2D, glCullFace, glBlend, glDither, glLighting, glLight0, glColorMaterial
    public void GLEnable(GL10 _gl, int _glValue) {
    	switch(_glValue) {
    	case 0: _gl.glEnable(GL10.GL_TEXTURE_2D); break;  
    	case 1: _gl.glEnable(GL10.GL_CULL_FACE);  break; 
    	case 2: _gl.glEnable(GL10.GL_BLEND);  break; 
    	case 3: _gl.glEnable(GL10.GL_DITHER);  break; 
    	case 4: _gl.glEnable(GL10.GL_LIGHTING);  break; 
    	case 5: _gl.glEnable(GL10.GL_LIGHT0);  break; 
    	case 6: _gl.glEnable(GL10.GL_COLOR_MATERIAL); break;  
    	}
    }
    
    public void GLDisable(GL10 _gl, int _glValue) {
    	switch(_glValue) {
       	case 0: _gl.glDisable(GL10.GL_TEXTURE_2D);  break;
    	case 1: _gl.glDisable(GL10.GL_CULL_FACE);  break; 
    	case 2: _gl.glDisable(GL10.GL_BLEND);  break; 
    	case 3: _gl.glDisable(GL10.GL_DITHER);   break;
    	case 4: _gl.glDisable(GL10.GL_LIGHTING);   break;
    	case 5: _gl.glDisable(GL10.GL_LIGHT0);   break;
    	case 6: _gl.glDisable(GL10.GL_COLOR_MATERIAL);  break;     	
    	}
    }
    
    public void GLNormalPointer(GL10 _gl,  FloatBuffer _normalBuffer) {    	
        if (mInitialized) {          
            _gl.glEnableClientState(GL10.GL_NORMAL_ARRAY);                  
            _gl.glNormalPointer(GL10.GL_FLOAT,0, _normalBuffer);
        }    
    }
    
    public void GLEnableClientState(GL10 _gl, int _state) {
       switch(_state) {	
         case 0: _gl.glEnableClientState(GL10.GL_VERTEX_ARRAY); break;                
         case 1: _gl.glEnableClientState(GL10.GL_COLOR_ARRAY); break;
         case 2: _gl.glEnableClientState(GL10.GL_TEXTURE_COORD_ARRAY); break;
         case 3: _gl.glEnableClientState(GL10.GL_NORMAL_ARRAY); break;
       }
    }
    
    public int[] GLGenTexturesIDs(GL10 _gl, int _count) {
    	int[] r = null;
    	if (mInitialized)  {       	    	
    	  _gl.glEnable(GL10.GL_TEXTURE_2D);  //Enable texture
          //Set up texture filters
          _gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_MIN_FILTER, GL10.GL_NEAREST);
          _gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_MAG_FILTER, GL10.GL_LINEAR);    	  
          r = new int[_count];           
          _gl.glGenTextures(_count, r , 0); //Generate texture-ID array for "count" textures
    	}
		return r;  
    }
    
    public void GLBindTexture(GL10 _gl, Bitmap _bitmap, int _textureID) {    	
      if (mInitialized) {       	  
    	  _gl.glEnable(GL10.GL_TEXTURE_2D);  //Enable texture
          _gl.glBindTexture(GL10.GL_TEXTURE_2D, _textureID);    	
      	// Set up texture filters
          _gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_MIN_FILTER, GL10.GL_NEAREST);
          _gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_MAG_FILTER, GL10.GL_LINEAR);        
          GLUtils.texImage2D(GL10.GL_TEXTURE_2D, 0, _bitmap, 0);              	                   
      }     
    } 
                
    private int GetDrawableResourceId(String _resName) {
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     Log.e("GetDrawableResourceId", "Failure to get drawable id.", e);
		     return 0;
		  }
     }
    
    public Bitmap GetBitmapResource(String _resourceDrawableIdentifier, boolean _inScaled) {
       int id =	GetDrawableResourceId(_resourceDrawableIdentifier);	
       BitmapFactory.Options bo = new BitmapFactory.Options();
       bo.inScaled = _inScaled; //false; 
       return  BitmapFactory.decodeResource(context.getResources(), id, bo);
    }
    
    
    /*
	@Override
	public boolean dispatchTouchEvent(MotionEvent e) {
		this.gDetect.onTouchEvent(e);		
		super.dispatchTouchEvent(e);			
		return true;
	}
	*/
	
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
            	
                controls.pOpenGLSurfaceViewTouch(pascalObj,Const.TouchDown,mActivePointers.size(),
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
            	
                controls.pOpenGLSurfaceViewTouch(pascalObj, Const.TouchMove, mActivePointers.size(), 
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
            	
               controls.pOpenGLSurfaceViewTouch(pascalObj,Const.TouchUp, mActivePointers.size(),
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
            	
                controls.pOpenGLSurfaceViewTouch(pascalObj,Const.TouchDown, mActivePointers.size(),
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
            	
                controls.pOpenGLSurfaceViewTouch(pascalObj,Const.TouchUp, mActivePointers.size(),
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
    
    public void SetRotateAngle(float _rotateAngleDegrees) {
       mRotateAngle = _rotateAngleDegrees;
    }
        
    public float GetRotateAngle() {
        return mRotateAngle;
    }
    
    public void MoveRotateAngle(float _angleVariationDegrees) {
       mRotateAngle = mRotateAngle + _angleVariationDegrees;
    }
	
    //http://www.saturn.dti.ne.jp/~npaka/android/Graphics2DEx/index.html  REF!!!
    public void Clear(GL10 _gl) {   //TODO Pascal
    	_gl.glClear(GL10.GL_COLOR_BUFFER_BIT| GL10.GL_DEPTH_BUFFER_BIT);	
    }
    
    public void setLineWidth(GL10 _gl, float _lineWidth) {
        _gl.glLineWidth(_lineWidth);
        _gl.glPointSize(_lineWidth*0.6f);
    }

    
    public void drawLine(GL10 _gl, float x0,float y0,float x1,float y1) {
    	int[] color={0,0,0,255};    	    
    	float[] vertexs=new float[256*3];    
    	float[] colors =new float[256*4];    
    	    
        vertexs[0]= x0;vertexs[1]=-y0;vertexs[2]=0;
        vertexs[3]= x1;vertexs[4]=-y1;vertexs[5]=0;     
        
        for (int i=0;i<2;i++) {
            colors[i*4  ]=color[0];
            colors[i*4+1]=color[1];
            colors[i*4+2]=color[2];
            colors[i*4+3]=color[3];
        }

       _gl.glBindTexture(GL10.GL_TEXTURE_2D,0);
       _gl.glEnableClientState(GL10.GL_COLOR_ARRAY);
       _gl.glVertexPointer(3,GL10.GL_FLOAT,0,GetFloatBufferFromFloatArray(vertexs));
       _gl.glColorPointer(4,GL10.GL_FLOAT,0,GetFloatBufferFromFloatArray(colors));
       _gl.glPushMatrix();
       _gl.glDrawArrays(GL10.GL_LINE_STRIP,0,2);
       _gl.glPopMatrix();
   }

   
   public void drawPolyline(GL10 _gl, float[] x,float y[],int length) {
   
 	    int[] color={0,0,0,255};
	    float[] vertexs=new float[256*3];    
	    float[] colors =new float[256*4];    
	    
       for (int i=0;i<length;i++) {
           vertexs[i*3+0]= x[i];
           vertexs[i*3+1]=-y[i];
           vertexs[i*3+2]=0;
       }
        
      
       for (int i=0;i<length;i++) {
           colors[i*4  ]=color[0];
           colors[i*4+1]=color[1];
           colors[i*4+2]=color[2];
           colors[i*4+3]=color[3];
       }

      
       _gl.glBindTexture(GL10.GL_TEXTURE_2D,0);
       _gl.glEnableClientState(GL10.GL_COLOR_ARRAY);
       _gl.glVertexPointer(3,GL10.GL_FLOAT,0,GetFloatBufferFromFloatArray(vertexs));
       _gl.glColorPointer(4,GL10.GL_FLOAT,0,GetFloatBufferFromFloatArray(colors));
       _gl.glPushMatrix();
       _gl.glDrawArrays(GL10.GL_LINE_STRIP,0,length);
       _gl.glDrawArrays(GL10.GL_POINTS,0,length);
       _gl.glPopMatrix();
   }
   
   public void drawRect(GL10 _gl, float x,float y,float w,float h) {
	   
	    int[] color={0,0,0,255};
	    float[] vertexs=new float[256*3];    
	    float[] colors =new float[256*4];    
	    
        vertexs[0]= x;  vertexs[1] =-y;  vertexs[2] =0;
        vertexs[3]= x;  vertexs[4] =-y-h;vertexs[5] =0;  
        vertexs[6]= x+w;vertexs[7] =-y-h;vertexs[8] =0;
        vertexs[9]= x+w;vertexs[10]=-y;  vertexs[11]=0;  
        
        for (int i=0;i<4;i++) {
            colors[i*4  ]=color[0];
            colors[i*4+1]=color[1];
            colors[i*4+2]=color[2];
            colors[i*4+3]=color[3];
        }

       _gl.glBindTexture(GL10.GL_TEXTURE_2D,0);
       _gl.glEnableClientState(GL10.GL_COLOR_ARRAY);
       _gl.glVertexPointer(3,GL10.GL_FLOAT,0,GetFloatBufferFromFloatArray(vertexs));
       _gl.glColorPointer(4,GL10.GL_FLOAT,0,GetFloatBufferFromFloatArray(colors));
       _gl.glPushMatrix();
       _gl.glDrawArrays(GL10.GL_LINE_LOOP,0,4);
       _gl.glDrawArrays(GL10.GL_POINTS,0,4);
       _gl.glPopMatrix();
   }
    
   public void drawCircle(GL10 _gl, float x,float y,float r) {
	   
	   int[] color={0,0,0,255};
	   float[] vertexs=new float[256*3];    
	   float[] colors =new float[256*4];
	    
       int length=100;
       
       for (int i=0;i<length;i++) {
           float angle=(float)(2*Math.PI*i/length);
           vertexs[i*3+0]=(float)( x+Math.cos(angle)*r);
           vertexs[i*3+1]=(float)(-y+Math.sin(angle)*r);
           vertexs[i*3+2]=0;
       }
        
    
       for (int i=0;i<length;i++) {
           colors[i*4  ]=color[0];
           colors[i*4+1]=color[1];
           colors[i*4+2]=color[2];
           colors[i*4+3]=color[3];
       }

    
       _gl.glBindTexture(GL10.GL_TEXTURE_2D,0);
       _gl.glEnableClientState(GL10.GL_COLOR_ARRAY);
       _gl.glVertexPointer(3,GL10.GL_FLOAT,0,GetFloatBufferFromFloatArray(vertexs));
       _gl.glColorPointer(4,GL10.GL_FLOAT,0,GetFloatBufferFromFloatArray(colors));
       _gl.glPushMatrix();
       _gl.glDrawArrays(GL10.GL_LINE_LOOP,0,length);
       _gl.glDrawArrays(GL10.GL_POINTS,0,length);
       _gl.glPopMatrix();
   }
   
   public void drawTriangle(GL10 _gl, float[] x,float[] y) {
	   int[] color={0,0,0,255};
	   float[] vertexs=new float[256*3];    
	   float[] colors =new float[256*4];
	   
        int length=3;
        for (int i=0;i<length;i++) {
            vertexs[i*3+0]= x[i];
            vertexs[i*3+1]=-y[i];
            vertexs[i*3+2]=0;
        }
       
        for (int i=0;i<length;i++) {
            colors[i*4  ]=color[0];
            colors[i*4+1]=color[1];
            colors[i*4+2]=color[2];
            colors[i*4+3]=color[3];
        }

       
       _gl.glBindTexture(GL10.GL_TEXTURE_2D,0);
       _gl.glEnableClientState(GL10.GL_COLOR_ARRAY);
       _gl.glVertexPointer(3,GL10.GL_FLOAT,0,GetFloatBufferFromFloatArray(vertexs));
       _gl.glColorPointer(4,GL10.GL_FLOAT,0,GetFloatBufferFromFloatArray(colors));
       _gl.glPushMatrix();
       _gl.glDrawArrays(GL10.GL_LINE_LOOP,0,length);
       _gl.glDrawArrays(GL10.GL_POINTS,0,length);
       _gl.glPopMatrix();
   }
   
    public void SetTranslate2(GL10 _gl, float x,float y) {
        _gl.glTranslatef(x,-y,0);
    }

    public void SetRotate2(GL10 _gl, float rotate) {
        _gl.glRotatef((float)(rotate*(-180)/Math.PI),0,0,1);
    }

    public void SetScale2(GL10 _gl, float w,float h) {
        _gl.glScalef(w,h,1);
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
			//controls.pOnPinchZoomGestureDetected(pascalObj, mScaleFactor, 1); //scalefactor->float
			return true;
		}

		@Override
		public boolean onScaleBegin(ScaleGestureDetector detector) {
			mScaleFactor = detector.getScaleFactor();
			mPinchZoomGestureState = 0;
			//controls.pOnPinchZoomGestureDetected(pascalObj, detector.getScaleFactor(), 0); //scalefactor->float
			//Log.i("tag", "onScaleBegin");
			return true;
		}

		@Override
		public void onScaleEnd(ScaleGestureDetector detector) {
			mScaleFactor = detector.getScaleFactor();
			mPinchZoomGestureState = 2;
			//controls.pOnPinchZoomGestureDetected(pascalObj, detector.getScaleFactor(), 2); //scalefactor->float
			//Log.i("tag", "onScaleEnd");
			super.onScaleEnd(detector);
		}

	}	
		
}
