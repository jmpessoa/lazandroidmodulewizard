package org.lamw.appgl2surfaceviewdemo2;


import java.lang.reflect.Field;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import java.nio.ShortBuffer;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.PointF;
import android.opengl.GLES20;
import android.opengl.GLSurfaceView;
import android.opengl.GLSurfaceView.Renderer;
import android.opengl.GLUtils;
import android.opengl.Matrix;
import android.util.Log;
import android.util.SparseArray;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.SurfaceHolder;
import android.view.View;
import android.view.ViewGroup;

//ref.  http://androidblog.reindustries.com/a-real-open-gl-es-2-0-2d-tutorial-part-1/

class GLRenderer implements Renderer {
	 
    //Our matrices
    private float[] mtrxProjection = new float[16];
    private float[] mtrxView = new float[16];
    private float[] mtrxMVP = new float[16];  //mtrxModelViewProjection
    
    //public FloatBuffer uvBuffer;
        
    /**
    * Store the model matrix. This matrix is used to move models from object space 
    * (where each model can be thought of being located at the center of the universe) to world space.
    */
   //private float[] mtrxModel = new float[16];
     
    //Geometric variables
    public static float vertices[];
    public static short indices[];
    public FloatBuffer vertexBuffer;
    public ShortBuffer drawListBuffer;
 
    //Our screenresolution
    float   mScreenWidth;
    float   mScreenHeight;
 
    // Misc
    Context mContext;
    //long mLastTime;
    
    int mProgram;
    int mHandleVShader;
    int mHandleFShader;    
    
    
    private long pascalObj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
         
    public GLRenderer(Controls c, long pasOb) {
    	controls = c;
        mContext = c.activity;
        pascalObj = pasOb;        
        //mLastTime = System.currentTimeMillis() + 100;
    }
         
    public void onPause() {
        /* Do stuff to pause the renderer */
    }
 
    public void onResume() {    	
        /* Do stuff to resume the renderer */
    }
		
    @Override
    public void onSurfaceCreated(GL10 gl, EGLConfig config) { 
        Log.i("onSurfaceCreated", "01");               
        controls.pOnGL2SurfaceCreate(pascalObj);
        Log.i("onSurfaceCreated", "02");
    }
     
    @Override
    public void onSurfaceChanged(GL10 gl, int width, int height) { 
    	Log.i("onSurfaceChanged", "11");    	
        mScreenWidth = width;
        mScreenHeight = height;
        controls.pOnGL2SurfaceChanged(pascalObj, width,  height);
        
     // Create a new perspective projection matrix. The height will stay the same
        // while the width will vary as per aspect ratio.
        /*
        final float ratio = (float) width / height;
        final float left = -ratio;
        final float right = ratio;
        final float bottom = -1.0f;
        final float top = 1.0f;
        final float near = 1.0f;
        final float far = 10.0f;
     
        Matrix.frustumM(mtrxProjection, 0, left, right, bottom, top, near, far);
        */
        Log.i("onSurfaceChanged", "12");    
    }
 
   
    @Override
    public void onDrawFrame(GL10 unused) {     
        Log.i("onDrawFrame", "21");
        controls.pOnGL2SurfaceDrawFrame(pascalObj);
        Log.i("onDrawFrame", "22");
    }
            
    //------onSurfaceCreated-------------------------
        
    //-----------onSurfaceChanged------
    public void SetViewPort(int _width, int _height) {    	
        mScreenWidth = _width;
        mScreenHeight = _height;    	
        GLES20.glViewport(0, 0, _width, _height);
        InitMatrices(_width, _height);
    }

    private void InitMatrices(int _width, int _height) {    	
        // Clear our matrices
        for(int i=0;i<16;i++) {
            mtrxProjection[i] = 0.0f;
            mtrxView[i] = 0.0f;
            mtrxMVP[i] = 0.0f;
        }    	
        //Setup our screen width and height for normal sprite translation.
        Matrix.orthoM(mtrxProjection, 0, 0f, _width, 0.0f, _height, 0, 50);
                
        /*   
        // Set the background clear color to gray.
           GLES20.glClearColor(0.5f, 0.5f, 0.5f, 0.5f);             
           // Position the eye behind the origin.
           final float eyeX = 0.0f;
           final float eyeY = 0.0f;
           final float eyeZ = 1.5f;     
           // We are looking toward the distance
           final float lookX = 0.0f;
           final float lookY = 0.0f;
           final float lookZ = -5.0f;        
           // Set our up vector. This is where our head would be pointing were we holding the camera.
           final float upX = 0.0f;
           final float upY = 1.0f;
           final float upZ = 0.0f;     
           // Set the view matrix. This matrix can be said to represent the camera position.
           // NOTE: In OpenGL 1, a ModelView matrix is used, which is a combination of a model and
           // view matrix. In OpenGL 2, we can keep track of these matrices separately if we choose.
           Matrix.setLookAtM(mtrxView, 0, eyeX, eyeY, eyeZ, lookX, lookY, lookZ, upX, upY, upZ);
           */        
        
        //Set the camera position (View matrix)
        Matrix.setLookAtM(mtrxView, 0, 0f, 0f, 1f, 0f, 0f, 0f, 0f, 1.0f, 0.0f);
        //Calculate the projection and view transformation
        Matrix.multiplyMM(mtrxMVP, 0, mtrxProjection, 0, mtrxView, 0);
    }
    
    
    public void SetProjectionMatrix(float[]  _matrix) {
       for(int i=0;i<16;i++) {
         mtrxProjection[i] = _matrix[i];
       }
    }
    
    public void SetViewMatrix(float[] _matrix) {
         for(int i=0;i<16;i++) {
           mtrxView[i] = _matrix[i];
         }
    }
        
    public void SetMVPMatrix(float[] _matrix) {
         for(int i=0;i<16;i++) {
        	 mtrxMVP[i] = _matrix[i];;
         }
    }
    
    public void SetOrthoM_Projection(float _left, float _right, float _bottom, float _top, float _near, float _far) {    	
       Matrix.orthoM(mtrxProjection, 0, 
    		           _left,    // 0
    		          _right,    //_width, 
    		          _bottom,   //0.0f, 
    		          _top,      //_height, 
    		          _near,     //0, 
    		          _far       //50
    		          );
    }
    
    public void SetLookAtM_View(
            float _eyeX, 
            float _eyeY, 
            float _eyeZ, 
            float _centerX, 
            float _centerY, 
            float _centerZ, 
            float _upX, 
            float _upY, 
            float _upZ) {
       //Set the camera position (View matrix)
       Matrix.setLookAtM(mtrxView, 0, 
    		            _eyeX,     //0
    		            _eyeY,     //0f
    		            _eyeZ,     //1 
    		            _centerX,  //0
    		            _centerY,  //0
    		            _centerZ,  //0
    		            _upX,      //0f
    		            _upY,      //1.0f 
    		            _upZ       //0.0f  
    		            );
    }
    
    public void MultiplyMM_MVP_P_V() {
      //Calculate the projection and view transformation
       Matrix.multiplyMM(mtrxMVP, 0, mtrxProjection, 0, mtrxView, 0);
    }
    
    //--------------onDrawFrame-------------
        
    /*
    public void DrawElements(int _program,  FloatBuffer _vertexBuffer, ShortBuffer _drawListBuffer, int indicesLength,String _uMVP, int[] _attribArrayDataSize) {
   	 // Set our shader programm
        GLES20.glUseProgram(_program);
                        
        int[] attribArrayDataOffset =  new int[_attribArrayDataSize.length];
        int  vertexStride = 0;
        
        for (int i=0; i < _attribArrayDataSize.length; i++) {
        	vertexStride = vertexStride + _attribArrayDataSize[i];   //3  **** 7  **** 9
        	attribArrayDataOffset[i] = vertexStride - _attribArrayDataSize[i]; //3-3 = 0  **** 7-4 = 3 *** 9-2=7 
        }
        
        //get handle to vertex shader's vPosition member
        //int mPositionHandle = GLES20.glGetAttribLocation(_program, _vPosition);        
        //Enable generic vertex attribute array
        //GLES20.glEnableVertexAttribArray(mPositionHandle); 
        //Prepare the triangle coordinate data    
        //GLES20.glVertexAttribPointer(mPositionHandle, 3,
        //                            GLES20.GL_FLOAT, false,
        //                          0, _vertexBuffer);
        
        //stride: how many elements there are between each vertex 
        //How many elements per vertex (3 or 7). 
        
        //Stride is in Bytes!  
        //vertexStride = 3 * mBytesPerFloat;  ( mBytesPerFloat = 4) [xyz]
               
        //mStrideBytes = 7 * mBytesPerFloat;  [xyz + color]
                             
        //_vertexBuffer.position(0)/xyz    or  _vertexBuffer.position(3)/color 
        for(int i = 0; i < _attribArrayDataSize.length; i++) {
        	
            // Prepare the triangle position [and color] data            
            //tell OpenGL to use this data and feed it into the vertex shader 
            //and apply it to our position [color] attribute.             
            _vertexBuffer.position(attribArrayDataOffset[i]); //  offeset = 0/color or offset=
            
            GLES20.glVertexAttribPointer(i, _attribArrayDataSize[i],   //xyz = 3 or  color= 4
                                         GLES20.GL_FLOAT, false,
                                         vertexStride*4, _vertexBuffer);            
            GLES20.glEnableVertexAttribArray(i);            
        } 
                                
        int mtrxhandle = GLES20.glGetUniformLocation(_program, _uMVP);                             
        GLES20.glUniformMatrix4fv(mtrxhandle, 1, false, mtrxMVP, 0);
        
        //Get handle to shape's transformation matrix                
        //int mtrxhandle = GLES20.glGetUniformLocation(_program, _uMVPMatrix);
        // Apply the projection and view transformation
        //This multiplies the view matrix by the model matrix, and stores the result in the MVP matrix
        //(which currently contains model * view).
        // Matrix.multiplyMM(mtrxMVP, 0, mtrxView, 0, mtrxModel, 0);     
        //This multiplies the modelview matrix by the projection matrix, and stores the result in the MVP matrix
        //(which now contains model * view * projection).
         //Matrix.multiplyMM(mtrxMVP, 0,mtrxProjection, 0, mtrxMVP, 0);
        //GLES20.glUniformMatrix4fv(mtrxhandle, 1, false, mtrxMVP, 0);
        
        //Draw the triangle        
        GLES20.glDrawElements(GLES20.GL_TRIANGLES, indicesLength, GLES20.GL_UNSIGNED_SHORT, _drawListBuffer);
        
        // Disable vertex array                
        for(int i = 0; i < _attribArrayDataSize.length; i++) {            
            GLES20.glDisableVertexAttribArray(i);               	
        }         
    }   
    */
    
    public int PrepareVertex(int _program, FloatBuffer _vertexBuffer, String _uMVP, int[] _attribArrayDataSize) {
     	  //Set our shader programm
          GLES20.glUseProgram(_program);
                          
          int[] attribArrayDataOffset =  new int[_attribArrayDataSize.length];
          int  vertexStride = 0;
          
          for (int i=0; i < _attribArrayDataSize.length; i++) {
          	vertexStride = vertexStride + _attribArrayDataSize[i];   //3  **** 7  **** 9
          	attribArrayDataOffset[i] = vertexStride - _attribArrayDataSize[i]; //3-3 = 0  **** 7-4 = 3 *** 9-2=7 
          }
          
          for(int i = 0; i < _attribArrayDataSize.length; i++) {
              _vertexBuffer.position(attribArrayDataOffset[i]); //  offeset = 0/color or offset=
              
              GLES20.glVertexAttribPointer(i, _attribArrayDataSize[i],   //xyz = 3 or  color= 4
                                           GLES20.GL_FLOAT, false,
                                           vertexStride*4, _vertexBuffer);            
              GLES20.glEnableVertexAttribArray(i);            
          } 
                                  
          int mtrxhandle = GLES20.glGetUniformLocation(_program, _uMVP);                             
          GLES20.glUniformMatrix4fv(mtrxhandle, 1, false, mtrxMVP, 0);
                    
          return _attribArrayDataSize.length;           
   }     
                                        
    public int PrepareTexture(int _programShader, FloatBuffer _uvBuffer,  String _vec2TextureCoord, String _sampler2DTexture, Bitmap _bitmap, int _textureID, int _textureIndex) {
	   
 	  //Set our shader programm   
	   GLES20.glUseProgram(_programShader);
	   
	    //http://www.learnopengles.com/android-lesson-four-introducing-basic-texturing/texture-coordinates/
	   
	   /*
		// Create our UV coordinates.
		float[] uvs = new float[] {
				0.0f, 0.0f,
				0.0f, 1.0f,
				1.0f, 1.0f,			
				1.0f, 0.0f			
	    };
		
		//The texture buffer
		ByteBuffer bb = ByteBuffer.allocateDirect(uvs.length * 4);
		bb.order(ByteOrder.nativeOrder());
		uvBuffer = bb.asFloatBuffer();
		uvBuffer.put(uvs);
		uvBuffer.position(0);
	     */
	   
   	//GLES20.glEnable(GLES20.GL_TEXTURE_2D);  //Enable texture
		
	//Set the active texture unit to texture unit 0.
	
	//https://www.opengl.org/discussion_boards/showthread.php/163092-Passing-Multiple-Textures-from-OpenGL-to-GLSL-shader	
	//https://stackoverflow.com/questions/8866904/differences-and-relationship-between-glactivetexture-and-glbindtexture	
	GLES20.glActiveTexture(GLES20.GL_TEXTURE0 + _textureIndex);
		
   	GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, _textureID);
   	
    // Set up texture filters
   	//GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_NEAREST);
   	GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_LINEAR);   	
   	GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MAG_FILTER, GLES20.GL_LINEAR);
   	   	
   	//Set wrapping mode: support to NPOT (non power of 2) texture 
    GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_S, 
    		GLES20.GL_CLAMP_TO_EDGE);
    GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_T, 
    		GLES20.GL_CLAMP_TO_EDGE);   	
   	   	   	
    GLUtils.texImage2D(GLES20.GL_TEXTURE_2D, 0, _bitmap, 0);
              
   	// Get handle to texture coordinates location
     int handleTexCoordLoc = GLES20.glGetAttribLocation(_programShader, _vec2TextureCoord); // "a_texCoord"
               
   	//Enable generic vertex attribute array
   	GLES20.glEnableVertexAttribArray (handleTexCoordLoc);
   	
   	// Prepare the texturecoordinates
   	GLES20.glVertexAttribPointer (handleTexCoordLoc, 2, GLES20.GL_FLOAT,false, 0, _uvBuffer);
   	
   	//Get handle to textures locations
   	int mSamplerLoc = GLES20.glGetUniformLocation (_programShader, _sampler2DTexture); //"s_texture" 
   	
   	//Tell the texture uniform sampler to use this texture in the shader by binding to texture unit _textureIndex.    
   	//Set the sampler texture unit to _textureIndex, where we have saved/ the texture.
   	GLES20.glUniform1i(mSamplerLoc, _textureIndex);  //That represents the number you used with glActiveTexture 
   	    	
   	return handleTexCoordLoc;

   } 

   public void DrawElements(int _mode, int indicesLength, ShortBuffer _drawListBuffer, int _bindDataCount, int _bindTextureHandle) {	   
   	 //GLES20.glDrawElements(GLES20.GL_TRIANGLES, indicesLength, GLES20.GL_UNSIGNED_SHORT, _drawListBuffer);
   	 switch (_mode) {
	    case 0: GLES20.glDrawElements(GLES20.GL_POINTS, indicesLength,  GLES20.GL_UNSIGNED_SHORT, _drawListBuffer);
	    case 1: GLES20.glDrawElements(GL10.GL_LINES, indicesLength,  GLES20.GL_UNSIGNED_SHORT, _drawListBuffer);
	    case 2: GLES20.glDrawElements(GL10.GL_LINE_LOOP, indicesLength,  GLES20.GL_UNSIGNED_SHORT, _drawListBuffer);
	    case 3: GLES20.glDrawElements(GL10.GL_LINE_STRIP, indicesLength,  GLES20.GL_UNSIGNED_SHORT, _drawListBuffer);
	    case 4: GLES20.glDrawElements(GL10.GL_TRIANGLES, indicesLength,  GLES20.GL_UNSIGNED_SHORT, _drawListBuffer);
	    case 5: GLES20.glDrawElements(GL10.GL_TRIANGLE_STRIP, indicesLength,  GLES20.GL_UNSIGNED_SHORT, _drawListBuffer);
	    case 6: GLES20.glDrawElements(GL10.GL_TRIANGLE_FAN, indicesLength,  GLES20.GL_UNSIGNED_SHORT, _drawListBuffer);
	 }
   	 
   	 for(int i = 0; i < _bindDataCount; i++) {             
   		  GLES20.glDisableVertexAttribArray(i);   //cleanup
     }
   	
   	 if (_bindTextureHandle >= 0) {
   	      GLES20.glDisableVertexAttribArray(_bindTextureHandle);  //cleanup
   	 }
   	  
   }
   	      
}


/*Draft java code by "Lazarus Android Module Wizard" [11/19/2017 21:00:07]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/

public class jGL2SurfaceView extends GLSurfaceView  { //please, fix what GUI object will be extended!

private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   private Boolean enabled  = true;           // click-touch enabled!
   
   private final GLRenderer mRenderer;
   
   
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
	

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jGL2SurfaceView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);

	  mCountPoint = 0;		 
      mActivePointers = new SparseArray<PointF>();

	  gDetect = new GestureDetector(controls.activity, new GestureListener());
	  scaleGestureDetector = new ScaleGestureDetector(controls.activity, new simpleOnScaleGestureListener());
      
      // Create an OpenGL ES 2.0 context.
      setEGLContextClientVersion(2);

      // Set the Renderer for drawing on the GLSurfaceView
      mRenderer = new GLRenderer(controls, pascalObj);
      setRenderer(mRenderer);

      // Render the view only when there is a change in the drawing data
      //setRenderMode(GLSurfaceView.RENDERMODE_CONTINUOUSLY);
      
      setRenderMode(GLSurfaceView.RENDERMODE_WHEN_DIRTY);
      
      
   } //end constructor

   public void jFree() {
      //free local objects...
	 LAMWCommon.free();
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

   public void ClearLayoutAll() {
	 LAMWCommon.clearLayoutAll();
   }    

    @Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		//Log.i("Java","surfaceDestroyed");
		queueEvent(new Runnable() {
			@Override
			public void run() {
				controls.pOnGL2SurfaceDestroyed(pascalObj);				
			}
		});
		super.surfaceDestroyed(holder);		
	}

   @Override
   public boolean onTouchEvent(MotionEvent event) {
     //mRenderer.ProcessTouchEvent(e);
	   
	   
   	mActivePointers.clear();
	
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
        	
            controls.pOnGL2SurfaceTouch(pascalObj,Const.TouchDown,mActivePointers.size(),
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
        	
            controls.pOnGL2SurfaceTouch(pascalObj, Const.TouchMove, mActivePointers.size(), 
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
        	
           controls.pOnGL2SurfaceTouch(pascalObj,Const.TouchUp, mActivePointers.size(),
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
        	
            controls.pOnGL2SurfaceTouch(pascalObj,Const.TouchDown, mActivePointers.size(),
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
        	
            controls.pOnGL2SurfaceTouch(pascalObj,Const.TouchUp, mActivePointers.size(),
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
   
   @Override
   public void onPause() {
       // TODO Auto-generated method stub
       super.onPause();
      // mRenderer.onPause(LAMWCommon.getLParamWidth(), LAMWCommon.getLParamHeight());
   }

   @Override
   public void onResume() {
       // TODO Auto-generated method stub
       super.onResume();
       //mRenderer.onResume(LAMWCommon.getLParamWidth(), LAMWCommon.getLParamHeight());
   }
   
   public void Pause() {
       onPause();
   }

   public void Resume() {
       onResume();
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
    
    
    //------onSurfaceCreated-------------------------
    
    public void ClearColor(float red, float green, float blue, float alpha) {
   	    GLES20.glClearColor(red,  green, blue, alpha); 	
    }
    
    //SetupTriangle();  //data  ...        
    
    //Create the shaders
    public int LoadVertexShader(String _vShaderCode) {
    	int vshader = GLES20.glCreateShader(GLES20.GL_VERTEX_SHADER);
        // add the source code to the shader and compile it
        GLES20.glShaderSource(vshader, _vShaderCode);
        GLES20.glCompileShader(vshader);
        
        // Get compilation status.
        int[] status = new int[] { GLES20.GL_FALSE };
        GLES20.glGetShaderiv(vshader, GLES20.GL_COMPILE_STATUS, status, 0);
        if (status[0] == GLES20.GL_FALSE) {
          GLES20.glGetShaderiv(vshader, GLES20.GL_INFO_LOG_LENGTH, status, 0);
          Log.i("LoadVertexShader", "Error compiling shader: " + GLES20.glGetShaderInfoLog(vshader));
          //GLES20.glDeleteShader(vshader);         
        }
        
        return vshader;
    } 

    public int LoadFragmentShader(String _fShaderCode) {
    	//riGraphicTools.fs_SolidColor
        int fshader = GLES20.glCreateShader(GLES20.GL_FRAGMENT_SHADER);
        // add the source code to the shader and compile it
        GLES20.glShaderSource(fshader, _fShaderCode);
        GLES20.glCompileShader(fshader);
        
     // Get compilation status.
        int[] status = new int[] { GLES20.GL_FALSE };
        GLES20.glGetShaderiv(fshader, GLES20.GL_COMPILE_STATUS, status, 0);
        if (status[0] == GLES20.GL_FALSE) {
          GLES20.glGetShaderiv(fshader, GLES20.GL_INFO_LOG_LENGTH, status, 0);
          Log.i("LoadFragmentShader", "Error compiling shader: " + GLES20.glGetShaderInfoLog(fshader));
          //GLES20.glDeleteShader(fshader);         
        }        
        return fshader;                
    }
    
    public int CreateProgramShader(int _handleVertexShader,  int _handleFragmentShader, String[] _bindAttribLocation) {    	
    	int prog = GLES20.glCreateProgram();             // create empty OpenGL ES Program
    	GLES20.glAttachShader(prog, _handleVertexShader);   // add the vertex shader to program
    	GLES20.glAttachShader(prog, _handleFragmentShader);   // add the vertex shader to program

    	// Bind attributes need be before link and after  Attach!
    	
    	//glGetAttribLocation() returns the correct index. So yes, 
    	//it is safe to use those values in glVertexAttribPointer() and glEnableVertexAttribArray().
    	//But calling glGetAttribLocation for each shader might be expensive if you don't cache it.
    	// so, bind its!
        //GLES20.glBindAttribLocation(prog, 0, "aPosition"); //bind specific identify to each attribute
        //GLES20.glBindAttribLocation(prog, 1, "aColor");    	
    	
    	for (int i = 0; i < _bindAttribLocation.length; i ++) {     //or String bindAttribList[] = vertex.split(" "); // Split by space    		
    		GLES20.glBindAttribLocation(prog, i, _bindAttribLocation[i]);    		
    	}    	    	    	
    	
    	GLES20.glLinkProgram(prog);                  // creates OpenGL ES program executables
    	    	
    	IntBuffer linkStatus = IntBuffer.allocate(1);
    	GLES20.glGetProgramiv(prog, GLES20.GL_LINK_STATUS, linkStatus);

    	if (linkStatus.get() == GLES20.GL_FALSE) {
    		GLES20.glDeleteProgram(prog);
    		Log.i("glLinkProgram", "linkStatus is not true");    		
    	}
    	
        return prog;        
    }

    
    public int CreateProgramShader(int _handleVertexShader,  int _handleFragmentShader, String _bindAttribDelimitedList) {    	
    	int prog = GLES20.glCreateProgram();             // create empty OpenGL ES Program
    	GLES20.glAttachShader(prog, _handleVertexShader);   // add the vertex shader to program
    	GLES20.glAttachShader(prog, _handleFragmentShader);   // add the vertex shader to program

    	// Bind attributes need be before link and after  Attach!
    	
    	//glGetAttribLocation() returns the correct index. So yes, 
    	//it is safe to use those values in glVertexAttribPointer() and glEnableVertexAttribArray().
    	//But calling glGetAttribLocation for each shader might be expensive if you don't cache it.
    	// so, bind its!
        //GLES20.glBindAttribLocation(prog, 0, "aPosition"); //bind specific identify to each attribute
        //GLES20.glBindAttribLocation(prog, 1, "aColor");    	
    	
    	String[] _bindAttribLocation = _bindAttribDelimitedList.split(" "); // Split by space
    	
    	for (int i = 0; i < _bindAttribLocation.length; i ++) {         		
    		GLES20.glBindAttribLocation(prog, i, _bindAttribLocation[i]);    		
    	}    	    	    	
    	
    	GLES20.glLinkProgram(prog);                  // creates OpenGL ES program executables
    	    	
    	IntBuffer linkStatus = IntBuffer.allocate(1);
    	GLES20.glGetProgramiv(prog, GLES20.GL_LINK_STATUS, linkStatus);

    	if (linkStatus.get() == GLES20.GL_FALSE) {
    		GLES20.glDeleteProgram(prog);
    		Log.i("glLinkProgram", "linkStatus is not true");    		
    	}
    	
        return prog;        
    }
    
    //-----------onSurfaceChanged------
    public void SetViewPort(int _width, int _height) {    	
    	mRenderer.SetViewPort(_width,_height);
    }       
    //--------------onDrawFrame-------------    
    // clear Screen and Depth Buffer, we have set the clear color as black.
    public void Clear () {
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT | GLES20.GL_DEPTH_BUFFER_BIT);
    }
           
    public void SetProjectionMatrix(float[]  _matrix) {
    	mRenderer.SetProjectionMatrix(_matrix);
    }
     
    public void SetViewMatrix(float[] _matrix) {
    	 mRenderer.SetViewMatrix(_matrix);;
    }     
     
    public void SetMVPMatrix(float[] _matrix) {
    	 mRenderer.SetMVPMatrix(_matrix);
    }

    public void SetOrthoM_Projection(float _left, float _right, float _bottom, float _top, float _near, float _far) {    	
    	mRenderer.SetOrthoM_Projection(_left, _right, _bottom, _top, _near, _far);
    }

    //Set the camera position (View matrix)
     public void SetLookAtM_View(float _eyeX, float _eyeY, float _eyeZ, float _centerX, float _centerY, float _centerZ, float _upX, float _upY, float _upZ) {    	 
    	 mRenderer.SetLookAtM_View(_eyeX, _eyeY, _eyeZ, _centerX, _centerY, _centerZ, _upX, _upY, _upZ);
     }
     
     public void MultiplyMM_MVP_Project_View() {
       //Calculate the projection and view transformation
    	 mRenderer.MultiplyMM_MVP_P_V();
     }
 	
    public int[] GenTexturesIDs(int _count) {
    	int[] r = null;
    	//GLES20.glEnable(GLES20.GL_TEXTURE_2D);  //Enable texture
        //Set up texture filters    	
    	//GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_LINEAR);
    	//GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_NEAREST);
    	//GLES20.glTexParameterf(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MAG_FILTER, GLES20.GL_LINEAR);    	
        r = new int[_count];           
        GLES20.glGenTextures(_count, r , 0); //Generate texture-ID array for "count" textures
		return r;  
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
       
       if( id == 0 ) return null; // by tr3e
       
       BitmapFactory.Options bo = new BitmapFactory.Options();
       bo.inScaled = _inScaled; //false; 
       return  BitmapFactory.decodeResource(context.getResources(), id, bo);
    }
    
    public void DrawElements(int _primitiveType, int _indicesLength,   ShortBuffer _indexBuffer) {
      	 switch (_primitiveType) {
      	    case 0: GLES20.glDrawElements(GLES20.GL_POINTS, _indicesLength,  GLES20.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 1: GLES20.glDrawElements(GL10.GL_LINES, _indicesLength,  GLES20.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 2: GLES20.glDrawElements(GL10.GL_LINE_LOOP, _indicesLength,  GLES20.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 3: GLES20.glDrawElements(GL10.GL_LINE_STRIP, _indicesLength,  GLES20.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 4: GLES20.glDrawElements(GL10.GL_TRIANGLES, _indicesLength,  GLES20.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 5: GLES20.glDrawElements(GL10.GL_TRIANGLE_STRIP, _indicesLength,  GLES20.GL_UNSIGNED_SHORT, _indexBuffer);
      	    case 6: GLES20.glDrawElements(GL10.GL_TRIANGLE_FAN, _indicesLength,  GLES20.GL_UNSIGNED_SHORT, _indexBuffer);
      	 }    	     	 
      }    


   // Draw the primitives from the vertex-array directly  //Vertices().length / 3
    public void DrawArrays(int _primitiveType,  int _startingIndex, int _elementsCount) {
    	   switch (_primitiveType) {   //0: the starting index in the enabled arrays
    	      case 0: GLES20.glDrawArrays(GL10.GL_POINTS, _startingIndex, _elementsCount); //the number of indices/vertices to be rendered.
    	      case 1: GLES20.glDrawArrays(GL10.GL_LINES, _startingIndex,  _elementsCount);
    	      case 2: GLES20.glDrawArrays(GL10.GL_LINE_LOOP, _startingIndex, _elementsCount);
    	      case 3: GLES20.glDrawArrays(GL10.GL_LINE_STRIP, _startingIndex, _elementsCount);
    	      case 4: GLES20.glDrawArrays(GL10.GL_TRIANGLES, _startingIndex, _elementsCount);
    	      case 5: GLES20.glDrawArrays(GL10.GL_TRIANGLE_STRIP, _startingIndex, _elementsCount);
    	      case 6: GLES20.glDrawArrays(GL10.GL_TRIANGLE_FAN, _startingIndex, _elementsCount);
    	   }    	       	    
    }   
        
    public void DrawElements(int _mode, int indicesLength, ShortBuffer _drawListBuffer, int _bindDataCount, int _bindTextureHandle) {
    	mRenderer.DrawElements(_mode, indicesLength, _drawListBuffer, _bindDataCount, _bindTextureHandle);
    }
        
    public int PrepareTexture(int _programShader, FloatBuffer _uvBuffer,  String _vec2TextureCoord, String _sampler2DTexture, Bitmap _bitmap, int _textureID, int _textureIndex) {
    	return mRenderer.PrepareTexture(_programShader,_uvBuffer,  _vec2TextureCoord, _sampler2DTexture, _bitmap, _textureID, _textureIndex);
    }	
    
    public int PrepareVertex(int _programShader, FloatBuffer _vertexBuffer, String _uMVP, int[] _attribArrayDataSize) {
    	return mRenderer.PrepareVertex(_programShader, _vertexBuffer, _uMVP, _attribArrayDataSize);    	
    }       
    
    //Get the maximum of texture units we can use.
    public int GetMaxTextureUnits() {
        IntBuffer i = IntBuffer.allocate(1);
        GLES20.glGetIntegerv(GLES20.GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, i);        
        return i.get(0);
    }
    
    public void RequestRender() {
    	this.requestRender();
    }
    
    
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
}
