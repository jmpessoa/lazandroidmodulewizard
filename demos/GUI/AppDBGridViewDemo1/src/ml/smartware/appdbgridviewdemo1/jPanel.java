package ml.smartware.appdbgridviewdemo1;

import android.graphics.Color;
import android.graphics.PorterDuff.Mode;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PaintDrawable;
import android.os.Build;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

public class jPanel extends RelativeLayout {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	
	private jCommons LAMWCommon;
	
	private GestureDetector gDetect;
	private ScaleGestureDetector scaleGestureDetector;

	private float mScaleFactor = 1.0f;
	private float MIN_ZOOM = 0.25f;
	private float MAX_ZOOM = 4.0f;

	int mRadius = 20;
	
	//Constructor
	public  jPanel(android.content.Context context, Controls ctrls,long pasobj ) {
		super(context);
		
		PasObj   = pasobj;
		controls = ctrls;
		
		LAMWCommon = new jCommons(this,context, PasObj);
	 
		gDetect = new GestureDetector(controls.activity, new GestureListener());

		scaleGestureDetector = new ScaleGestureDetector(controls.activity, new simpleOnScaleGestureListener());
	}

	public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		 String tag = ""+_left+"|"+_top+"|"+_right+"|"+_bottom;
	     this.setTag(tag);
		 LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
	}

	public void setLParamWidth(int _w) {
		 LAMWCommon.setLParamWidth(_w);
	}

	public void setLParamHeight(int _h) {
		 LAMWCommon.setLParamHeight(_h);
	}

	public void setLGravity(int _g) {
	  	 LAMWCommon.setLGravity(_g);
	}

	public void setLWeight(float _w) {
		LAMWCommon.setLWeight(_w);
	}

	public int getLParamHeight() {
		return  LAMWCommon.getLParamHeight();
	}

	public int getLParamWidth() {		
	   return LAMWCommon.getLParamWidth();
	}
	
	public void resetLParamsRules() {   //clearLayoutAll		
		LAMWCommon.clearLayoutAll();
	}

	public void addLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);
	}

	public void addLParamsParentRule(int rule) {		
		 LAMWCommon.addLParamsParentRule(rule);
	}

	public void setLayoutAll(int idAnchor) {
		 LAMWCommon.setLayoutAll(idAnchor);
	}

	//GetView!-android.widget.RelativeLayout
	public  RelativeLayout getView() {
		return this;
	}

	public  void SetViewParent( android.view.ViewGroup _viewgroup ) {		
		 LAMWCommon.setParent(_viewgroup);
	}

	public ViewGroup GetParent() {   //TODO Pascal .. done!
	      return LAMWCommon.getParent();
	}
	
	// Free object except Self, Pascal Code Free the class.
	public  void Free() {
		 LAMWCommon.free();
	}

	public void RemoveFromViewParent() {
		LAMWCommon.removeFromViewParent();
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
			controls.pOnDown(PasObj, Const.Click_Default);
			return true;
		}
		
		@Override
		public boolean onSingleTapUp(MotionEvent e) {
			//Log.i("Click", "------------");
			controls.pOnClick(PasObj, Const.Click_Default);
			return true;
		}
		
		@Override
		public boolean onDoubleTap(MotionEvent e) {
			//Log.i("DoubleTap", "------------");
			controls.pOnDoubleClick(PasObj, Const.Click_Default);
			return true;
		}
		
		@Override
		public void onLongPress(MotionEvent e) {
			//Log.i("LongPress", "------------");			
			controls.pOnLongClick(PasObj, Const.Click_Default);
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
		LAMWCommon.CenterInParent();
	}

	public void MatchParent() {
		LAMWCommon.MatchParent();		
	}

	public void WrapParent() {
		LAMWCommon.WrapParent();		
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
		LAMWCommon.setMarginLeftTopRightBottom( _left,  _top, _right,_bottom);
	}
	
	public void AddView(View _view) {	
		LAMWCommon.AddView(_view);
	}
	
	public void	SetFitsSystemWindows(boolean _value) {
		LAMWCommon.setFitsSystemWindows(_value);
	}
	
	public void RemoveView(View _view) {
	   this.removeView(_view);
	}   
	   
	public void RemoveAllViews() {
	   this.removeAllViews(); 
	}
	
	public int GetChildCount() {
	  return  this.getChildCount();
	}
	
	public void BringChildToFront(View _view) {		
		this.bringChildToFront( _view);
		if (Build.VERSION.SDK_INT < 19 ) {			
		   	   this.requestLayout();
			   this.invalidate();		    
		}		
	}
	
	
    /*
    Change the view's z order in the tree, so it's on top of other sibling views.
    Prior to KITKAT/4.4/Api 19 this method should be followed by calls to requestLayout() and invalidate()
    on the view's parent to force the parent to redraw with the new child ordering.
  */
	public void BringToFront() {
		this.bringToFront();	
		if (Build.VERSION.SDK_INT < 19 ) {			
			ViewGroup parent = LAMWCommon.getParent();
	       	if (parent!= null) {
	       		parent.requestLayout();
	       		parent.invalidate();	
	       	}
		}		
		this.setVisibility(android.view.View.VISIBLE);
	}
	
	public void SetVisibilityGone() {
		LAMWCommon.setVisibilityGone();
	}
	
}


