package com.example.appdemo1;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGL10;

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

class ConstES2 {
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

public class jCanvasES2 extends GLSurfaceView {
	//Java-Pascal Interface
	private long            PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	//
	private ViewGroup       parent   = null;   // parent view
	private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH
	private jRenderer       renderer;
	private GL10            savGL;

	//by jmpessoa
	private int lparamsAnchorRule[] = new int[30];
	int countAnchorRule = 0;

	private int lparamsParentRule[] = new int[30];
	int countParentRule = 0;

	int lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
	int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT; //w
	int marginLeft = 5;
	int marginTop = 5;
	int marginRight = 5;
	int marginBottom = 5;
	private int lgravity = Gravity.TOP | Gravity.START;
	private float lweight = 0;
	
	//
	//http://altdevblog.com/2013/08/18/the-main-loop-in-devils-attorney-on-android/
	class jRenderer implements GLSurfaceView.Renderer {		
		//public  void onSurfaceCreated(GL10 arg0, javax.microedition.khronos.egl.EGLConfig arg1) {controls.pOnGLRenderer(PasObj,Const.Renderer_onSurfaceCreated,0,0); }
		public  void onSurfaceCreated(GL10 gl, EGLConfig config) {
			//Log.i("Java","onSurfaceCreated");
			controls.pOnGLRenderer2(PasObj,ConstES2.Renderer_onSurfaceCreated,0,0); 
		}		
		public  void onSurfaceChanged(GL10 gl, int w, int h) {
			//Log.i("Java","onSurfaceCreated");
			controls.pOnGLRenderer2(PasObj,ConstES2.Renderer_onSurfaceChanged,w,h); 
		}
		
		public  void onDrawFrame     (GL10 gl) {
			//Log.i("Java","onDrawFrame");
			controls.pOnGLRenderer2(PasObj,ConstES2.Renderer_onDrawFrame,0,0); 
		}		
	}

	//Constructor
	public jCanvasES2(android.content.Context context,
					   Controls ctrls,long pasobj, int version ) {
		super(context);
		
		PasObj   = pasobj;
		controls = ctrls;
		
		lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B
		
		if (version != 1) {setEGLContextClientVersion(2); };
		renderer = new jRenderer();
		setEGLConfigChooser(8,8,8,8,16,8);       // RGBA,Depath,Stencil
		setRenderer(renderer);
		setRenderMode( GLSurfaceView.RENDERMODE_WHEN_DIRTY);
	}
	
	public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		marginLeft = left;
		marginTop = top;
		marginRight = right;
		marginBottom = bottom;
		lparamH = h;
		lparamW = w;
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

	public  void setParent( android.view.ViewGroup _viewgroup ) {
		if (parent != null) { parent.removeView(this); }
		parent = _viewgroup;

		parent.addView(this,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));
		lparams = null;
		lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();
	}

	//
	@Override
	public  boolean onTouchEvent( MotionEvent event) {
		int act     = event.getAction() & MotionEvent.ACTION_MASK;
		switch(act) {
			case MotionEvent.ACTION_DOWN: {
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
							event.getX(0),event.getY(0),0,0);
						//Log.i("touch up1:","x="+event.getX(0)+"  y="+event.getY(0));
						break; }
					default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));
						//Log.i("touch up2:","x="+event.getX(0)+"  y="+event.getY(0));
						break; }
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
				//Log.i("Java","PUp");
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
	public void surfaceDestroyed(SurfaceHolder holder) {
		//Log.i("Java","surfaceDestroyed");
		queueEvent(new Runnable() {
			@Override
			public void run() {
				controls.pOnGLRenderer2(PasObj, ConstES2.Renderer_onSurfaceDestroyed,0,0);
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
					Log.e("deleteTexture", "Exception: "+ e.toString() ); }
			}
		});
	}

	//
	public void deleteTexture( int id ) {
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

	//
	public  void glThread() {
		queueEvent(new Runnable() {
			@Override
			public void run() {
				controls.pOnGLRenderer2(PasObj,ConstES2.Renderer_onSurfaceThread,0,0); }
		});
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		if (parent != null) { parent.removeView(this); }
		renderer = null;
		lparams  = null;
	}

	//by jmpessoa
	public void setLParamWidth(int w) {
		lparamW = w;
	}

	//by jmpessoa
	public void setLParamHeight(int h) {
		lparamH = h;
	}

	public void setLGravity(int _g) {
		lgravity = _g;
	}

	public void setLWeight(float _w) {
		lweight = _w;
	}

	//by jmpessoa
	public int getLParamHeight() {
		return getHeight();
	}

	//by jmpessoa
	public int getLParamWidth() {
		return getWidth();
	}

	//by jmpessoa
	public void addLParamsAnchorRule(int rule) {
		lparamsAnchorRule[countAnchorRule] = rule;
		countAnchorRule = countAnchorRule + 1;
	}
	//by jmpessoa
	public void addLParamsParentRule(int rule) {
		lparamsParentRule[countParentRule] = rule;
		countParentRule = countParentRule + 1;
	}
	//by jmpessoa
	public void setLayoutAll(int idAnchor) {
		lparams.width  = lparamW;
		lparams.height = lparamH;
		lparams.setMargins(marginLeft, marginTop,marginRight,marginBottom);

		if (lparams instanceof RelativeLayout.LayoutParams) {
			if (idAnchor > 0) {
				for (int i = 0; i < countAnchorRule; i++) {
					((RelativeLayout.LayoutParams)lparams).addRule(lparamsAnchorRule[i], idAnchor);
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
		setLayoutParams(lparams);
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

}
