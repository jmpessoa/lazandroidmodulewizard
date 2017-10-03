package org.lamw.colorpicker;

import android.graphics.Color;
import android.graphics.PorterDuff.Mode;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PaintDrawable;
import android.os.Build;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

//-----------------------------------------
//----- jPanel by jmpessoa
//-----------------------------------------
public class jPanel extends RelativeLayout {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private ViewGroup       parent   = null;

	private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH

	private int lparamsAnchorRule[] = new int[40];
	int countAnchorRule = 0;

	private int lparamsParentRule[] = new int[40];
	int countParentRule = 0;

	int lparamH = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
	int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT; //w
	int marginLeft = 0;
	int marginTop = 0;
	int marginRight  = 0;
	int marginBottom = 0;
 //[ifdef_api14up]
 private int lgravity = Gravity.TOP | Gravity.START;
 //[endif_api14up]
 /* //[endif_api14up]
 private int lgravity = Gravity.TOP | Gravity.LEFT;
 //[ifdef_api14up] */
	private float lweight = 0;

	boolean mRemovedFromParent = false;

	private GestureDetector gDetect;
	private ScaleGestureDetector scaleGestureDetector;

	private float mScaleFactor = 1.0f;
	private float MIN_ZOOM = 0.25f;
	private float MAX_ZOOM = 4.0f;

	int mRadius = 20;
	
	//Constructor
	public  jPanel(android.content.Context context, Controls ctrls,long pasobj ) {
		super(context);
		// Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;

		lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B
		//
		gDetect = new GestureDetector(controls.activity, new GestureListener());

		scaleGestureDetector = new ScaleGestureDetector(controls.activity, new simpleOnScaleGestureListener());
	}

	public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		marginLeft = _left;
		marginTop = _top;
		marginRight = _right;
		marginBottom = _bottom;
		lparamH = _h;
		lparamW = _w;
		lparams.width  = lparamW;
		lparams.height = lparamH;
	}

	public void setLParamWidth(int _w) {
		lparamW = _w;
		lparams.width  = lparamW;
	}

	public void setLParamHeight(int _h) {
		lparamH = _h;
		lparams.height = lparamH;
	}

	public void setLGravity(int _g) {
		lgravity = _g;
	}

	public void setLWeight(float _w) {
		lweight = _w;
	}

	
	public int getLParamHeight() {
		int r = lparamH;		
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			r = this.getHeight();
		}		
		return r;
	}

	public int getLParamWidth() {				
		int r = lparamW;		
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			r = this.getWidth();
		}		
		return r;		
	}
	
	public void resetLParamsRules() {   //clearLayoutAll
		
		if (lparams instanceof RelativeLayout.LayoutParams) {
			
			for (int i = 0; i < countAnchorRule; i++) {								
				  if(Build.VERSION.SDK_INT < 17)
					  ((android.widget.RelativeLayout.LayoutParams) lparams).addRule(lparamsAnchorRule[i], 0);
					
	//[ifdef_api17up]
				 if(Build.VERSION.SDK_INT >= 17)
					((android.widget.RelativeLayout.LayoutParams) lparams).removeRule(lparamsAnchorRule[i]); //need API >= 17!
	//[endif_api17up]
				 
			 }
			
			 for (int j = 0; j < countParentRule; j++) {
				  if(Build.VERSION.SDK_INT < 17) 
					  ((android.widget.RelativeLayout.LayoutParams) lparams).addRule(lparamsParentRule[j], 0);
					
	//[ifdef_api17up]
				  if(Build.VERSION.SDK_INT >= 17)
					  ((android.widget.RelativeLayout.LayoutParams) lparams).removeRule(lparamsParentRule[j]);  //need API >= 17!
	//[endif_api17up]
				
			}
			
		}
		
		countAnchorRule = 0;
		countParentRule = 0;
	}

	public void addLParamsAnchorRule(int rule) {
		lparamsAnchorRule[countAnchorRule] = rule;
		countAnchorRule = countAnchorRule + 1;
	}

	public void addLParamsParentRule(int rule) {
		lparamsParentRule[countParentRule] = rule;
		countParentRule = countParentRule + 1;
	}

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
		
		setLayoutParams(lparams);
	}

	//GetView!-android.widget.RelativeLayout
	public  RelativeLayout getView() {
		return this;
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

	public  void setParent( android.view.ViewGroup _viewgroup ) {
		if (parent != null) { parent.removeView(this); }
		parent = _viewgroup;

		parent.addView(this,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));
		lparams = null;
		lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();

		mRemovedFromParent=false;
	}

	// Free object except Self, Pascal Code Free the class.
	public  void Free() {
		if (parent != null) { parent.removeView(this); }
		lparams = null;
	}

	public void RemoveParent() {
		if (!mRemovedFromParent) {
			parent.removeView(this);
			mRemovedFromParent = true;
		}
	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		return super.onTouchEvent(event);
	}

	@Override
	public boolean dispatchTouchEvent(MotionEvent e) {
		super.dispatchTouchEvent(e);
		this.gDetect.onTouchEvent(e);
		this.scaleGestureDetector.onTouchEvent(e);
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
				controls.pOnFlingGestureDetected(PasObj, 0);                //onRightToLeft;
				return  true;
			} else if (event2.getX() - event1.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
				controls.pOnFlingGestureDetected(PasObj, 1);//onLeftToRight();
				return true;
			}
			if(event1.getY() - event2.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
				controls.pOnFlingGestureDetected(PasObj, 2);//onBottomToTop();
				return false;
			} else if (event2.getY() - event1.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
				controls.pOnFlingGestureDetected(PasObj, 3); //onTopToBottom();
				return false;
			}
			return false;
		}
	}


	//ref. http://vivin.net/2011/12/04/implementing-pinch-zoom-and-pandrag-in-an-android-view-on-the-canvas/
	private class simpleOnScaleGestureListener extends SimpleOnScaleGestureListener {

		@Override
		public boolean onScale(ScaleGestureDetector detector) {
			mScaleFactor *= detector.getScaleFactor();
			mScaleFactor = Math.max(MIN_ZOOM, Math.min(mScaleFactor, MAX_ZOOM));
			// Log.i("tag", "onScale = "+ mScaleFactor);
			controls.pOnPinchZoomGestureDetected(PasObj, mScaleFactor, 1); //scalefactor->float
			return true;
		}

		@Override
		public boolean onScaleBegin(ScaleGestureDetector detector) {
			controls.pOnPinchZoomGestureDetected(PasObj, detector.getScaleFactor(), 0); //scalefactor->float
			//Log.i("tag", "onScaleBegin");
			return true;
		}

		@Override
		public void onScaleEnd(ScaleGestureDetector detector) {
			controls.pOnPinchZoomGestureDetected(PasObj, detector.getScaleFactor(), 2); //scalefactor->float
			//Log.i("tag", "onScaleEnd");
			super.onScaleEnd(detector);
		}

	}

	public void SetMinZoomFactor(float _minZoomFactor) {
		MIN_ZOOM = _minZoomFactor;
	}

	public void SetMaxZoomFactor(float _maxZoomFactor) {
		MAX_ZOOM = _maxZoomFactor;
	}

	public void CenterInParent() {		
		//resetLParamsRules();  need ???		
		if (lparams instanceof RelativeLayout.LayoutParams) {
			((RelativeLayout.LayoutParams)lparams).addRule(android.widget.RelativeLayout.CENTER_IN_PARENT);  //android.widget.RelativeLayout.CENTER_VERTICAL = 15			
			this.setLayoutParams(lparams);  //added     ::need ??	
			countParentRule = countParentRule + 1;
		}
	}

	public void MatchParent() {
		lparamH = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
		lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT; //w
		lparams.height = lparamH;
		lparams.width = lparamW;			
		this.setLayoutParams(lparams); //added		
	}

	public void WrapParent() {
		lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
		lparamW = android.view.ViewGroup.LayoutParams.WRAP_CONTENT; //w
		lparams.height = lparamH;
		lparams.width = lparamW;		
		this.setLayoutParams(lparams); //added		
	}
	
	public void SetRoundCorner() {
	   if (this != null) {  		
		        PaintDrawable  shape =  new PaintDrawable();
		        shape.setCornerRadius(mRadius);                
		        int color = Color.TRANSPARENT;
		        Drawable background = this.getBackground();        
		        if (background instanceof ColorDrawable) {
		          color = ((ColorDrawable)this.getBackground()).getColor();
			        shape.setColorFilter(color, Mode.SRC_ATOP);        		           		        		        
			        //[ifdef_api16up]
			  	    if(Build.VERSION.SDK_INT >= 16) 
			             this.setBackground((Drawable)shape);
			        //[endif_api16up]		          
		        }                		  	  
	    }
	 }
	
	public void SetRadiusRoundCorner(int _radius) {
		mRadius =  _radius;
	}
	
	//You can basically set it from anything between 0(fully transparent) to 255 (completely opaque)
	public void SetBackgroundAlpha(int _alpha) {		
	  this.getBackground().setAlpha(_alpha); //0-255
	}
	
	public void SetMarginLeftTopRightBottom(int _left, int _top, int _right, int _bottom) {		
		marginLeft = _left;
		marginTop = _top;
		marginRight = _right;
		marginBottom = _bottom;
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
		setLayoutParams(lparams);
	}
	
}


