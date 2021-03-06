package com.example.appdemo1;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGL10;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.opengl.GLSurfaceView;
import android.util.Log;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

class ConstES1 {
	public static final int Renderer_onSurfaceCreated   =  0;
	public static final int Renderer_onSurfaceChanged   =  1;
	public static final int Renderer_onDrawFrame        =  2;
	public static final int Renderer_onSurfaceDestroyed =  3;
	public static final int Renderer_onSurfaceThread    =  4;

}
//-------------------------------------------------------------------------
//GLView
//    Event : pOnTouch
//-------------------------------------------------------------------------
//http://developer.android.com/reference/android/opengl/GLSurfaceView.EGLContextFactory.html
//http://stackoverflow.com/questions/8932732/android-ndk-opengl-gldeletetextures-causes-error-call-to-opengl-es-api-with-no
//http://stackoverflow.com/questions/2034272/do-i-have-to-use-gldeletetextures-in-the-end-of-the-program
//http://stackoverflow.com/questions/8168014/opengl-screenshot-android
//http://cafe.naver.com/mcbugi/250562
//http://cafe.naver.com/cocos2dxusers/405
public class jCanvasES1 extends GLSurfaceView {
	//Java-Pascal Interface
	private long            PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	//
	private ViewGroup       parent   = null;   // parent view
	private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH

	private GLRenderer       renderer;
	private GL10            savGL;
	
	private jCommons LAMWCommon;

	private boolean mflag = false;
	
	private boolean mDispatchTouchDown = true;
	private boolean mDispatchTouchMove = true;
	private boolean mDispatchTouchUp = true;

	//
	class GLRenderer implements GLSurfaceView.Renderer {
		//public  void onSurfaceCreated(GL10 arg0, javax.microedition.khronos.egl.EGLConfig arg1) {controls.pOnGLRenderer(PasObj,Const.Renderer_onSurfaceCreated,0,0); }
		public  void onSurfaceCreated(GL10 gl, EGLConfig config) { 
			 mflag = true;
			 controls.pOnGLRenderer1(PasObj,ConstES1.Renderer_onSurfaceCreated,0,0); 
	    }
		public  void onSurfaceChanged(GL10 gl, int w, int h) { 
			controls.pOnGLRenderer1(PasObj,ConstES1.Renderer_onSurfaceChanged,w,h); 
		}
		public  void onDrawFrame     (GL10 gl) {
			controls.pOnGLRenderer1(PasObj,ConstES1.Renderer_onDrawFrame,0,0); 
		}
	}

	public  jCanvasES1(android.content.Context context,
					   Controls ctrls,long pasobj, int version ) {
		super(context);
		// Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;
		
		LAMWCommon = new jCommons(this,context,pasobj);
		
		// OpenGL ES Version
		if (version != 1) {setEGLContextClientVersion(2); };

		renderer = new GLRenderer();

		setEGLConfigChooser(8,8,8,8,16,8);       // RGBA,Depath,Stencil

		setRenderer  ( renderer );

		setRenderMode( GLSurfaceView.RENDERMODE_WHEN_DIRTY );
	}

	public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {		
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
	}

	public  void SetParent( android.view.ViewGroup _viewgroup ) {		
		LAMWCommon.setParent(_viewgroup);
	}

	//
	@Override
	public  boolean onTouchEvent( MotionEvent event) {
		int act     = event.getAction() & MotionEvent.ACTION_MASK;
		switch(act) {
			case MotionEvent.ACTION_DOWN: {
			   if (mDispatchTouchDown)	{
				  switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
							event.getX(0),event.getY(0),0,0);
						// Log.i("touch down1:","x="+event.getX(0)+"  y="+event.getY(0));
						break;
					}
					default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));
						//Log.i("touch down2:","x="+event.getX(0)+"  y="+event.getY(0));
						break;
					}
				  }
			    }	  
				break;
			}
			
			case MotionEvent.ACTION_MOVE: {
				if (mDispatchTouchMove)	{
			  	  switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchMove,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchMove,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				  }
				}	  
				break;
			}
			case MotionEvent.ACTION_UP: {
				if (mDispatchTouchUp)	{	
				  switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
							event.getX(0),event.getY(0),0,0);
						//Log.i("touch up1:","x="+event.getX(0)+"  y="+event.getY(0));
						break; }
					default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));
						//Log.i("touch up2:","x="+event.getX(0)+"  y="+event.getY(0));
						break; }
				  }
				}  
				break;
			}
			case MotionEvent.ACTION_POINTER_DOWN: {
				if (mDispatchTouchDown)	{					
				  switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				   }
				}
				break;
			}
			case MotionEvent.ACTION_POINTER_UP  : {
				if (mDispatchTouchUp)	{
				  switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				  }
				}
				break;
		    }
		}
		return true;
	}
	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		//Log.i("Java","surfaceDestroyed");
		queueEvent(new Runnable() {
			@Override
			public void run() {
				controls.pOnGLRenderer1(PasObj, ConstES1.Renderer_onSurfaceDestroyed,0,0);
			}
		});
		super.surfaceDestroyed(holder);
	}

	//
	public  void genRender() {
		queueEvent(new Runnable() {
			@Override
			public void run() {
				try{
					requestRender();
				}
				catch ( Exception e) {
					Log.e("requestRender", "Exception: "+ e.toString() ); }
			}
		});
	}

	//
	public  void deleteTexture( int id ) {
		final int idx = id;
		queueEvent(new Runnable() {
			@Override
			public void run() {
				try {
					int[] ids = new int[1];
					ids[0] = idx;
					EGL10 egl = (EGL10) EGLContext.getEGL();
					GL10 gl = (GL10) egl.eglGetCurrentContext().getGL();
					//gl.glBindTexture(GL10.GL_TEXTURE_2D, idx);
					gl.glDeleteTextures(1, ids, 0);
				} catch (Exception e) {
					Log.e("deleteTexture", "Exception: " + e.toString());
				}
			}
		});
	}
	
	public void SetOnPause(){
		this.onPause();
	}
	
	public void SetOnResume(){
		this.onResume();
	}

	//
	public  void glThread() {
		queueEvent(new Runnable() {
			@Override
			public void run() {
				controls.pOnGLRenderer1(PasObj,ConstES1.Renderer_onSurfaceThread,0,0); }
		});
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		if (parent != null) { parent.removeView(this); }
		renderer = null;
		lparams  = null;
	}

	//by jmpessoa
	public void SetLParamWidth(int _w) {
		LAMWCommon.setLParamWidth(_w);
	}

	//by jmpessoa
	public void SetLParamHeight(int _h) {
		LAMWCommon.setLParamHeight(_h);
	}

	public void SetLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
	}

	public void SetLWeight(float _w) {
		LAMWCommon.setLWeight(_w);
	}
	
	public void ClearLayoutAll() {
		  LAMWCommon.clearLayoutAll();
	}

	//by jmpessoa
	public int GetLParamHeight() {
		return getHeight();
	}

	//by jmpessoa
	public int GetLParamWidth() {
		return getWidth();
	}

	//by jmpessoa
	public void AddLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);
	}
	//by jmpessoa
	public void AddLParamsParentRule(int rule) {		
		 LAMWCommon.addLParamsParentRule(rule);
	}
	//by jmpessoa
	public void SetLayoutAll(int idAnchor) {		
		LAMWCommon.setLayoutAll(idAnchor);
	}

	//by jmpessoa
	public void Refresh() {
		this.requestRender();
	}

	//by jmpessoa
	public  void SetAutoRefresh(boolean active ) {
		if (active) {setRenderMode( GLSurfaceView.RENDERMODE_CONTINUOUSLY ); }
		else  {setRenderMode( GLSurfaceView.RENDERMODE_WHEN_DIRTY   ); }
	}
	
	public  int[] GetBmpIntArray(String _fullFilename) {
		 String file = _fullFilename;
		 int[] pixels;					              			              
		 Bitmap bmp = BitmapFactory.decodeFile(file);
		 int   length = bmp.getWidth()*bmp.getHeight();
	     pixels = new int[length+2];
		 bmp.getPixels(pixels, 0, bmp.getWidth(), 0, 0, bmp.getWidth(), bmp.getHeight());
		 pixels[length+0] = bmp.getWidth ();
		 pixels[length+1] = bmp.getHeight();
		 //Log.i("getBmpArray", file);																          
	     return (pixels);			              
	}	
	
	
	public void DispatchTouchDown(boolean _value) {
		   mDispatchTouchDown = _value;
	}
		
	public void DispatchTouchMove(boolean _value) {
		  mDispatchTouchMove = _value;
	}
		
	public void DispatchTouchUp(boolean _value) {
		    mDispatchTouchUp = _value;
	}
	
}
