package com.example.appdemo1;

import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ScrollView;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;

//-------------------------------------------------------------------------
//ScrollView
//    Event pOnClick
//-------------------------------------------------------------------------

public class jScrollView extends ScrollView {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private jCommons LAMWCommon;
	//
	private RelativeLayout  scrollview;        // Scroll View
	private LayoutParams    scrollxywh;        // Scroll Area

	int onPosition;
	boolean mDispacthScrollChanged = true;
	
	//Constructor
	public  jScrollView(android.content.Context context,
						Controls ctrls,long pasobj ) {
		super(context);

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);
		
		//this.setBackgroundColor (0xFF0000FF);
		//Scroll Size
		scrollview = new RelativeLayout(context);
		//scrollview.setBackgroundColor (0xFFFF0000);
		scrollxywh = new FrameLayout.LayoutParams(100,100);
		scrollxywh.setMargins(0,0,0,0);
		scrollview.setLayoutParams(scrollxywh);
		this.addView(scrollview);
		
	}
	    
	public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
	}

	public  void setParent( android.view.ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}

	public  void setScrollSize(int _size) {
		scrollxywh.height = _size;
		scrollxywh.width  = LAMWCommon.getLParamWidth(); //lparams.width;
		scrollview.setLayoutParams(scrollxywh);
	}

	public  RelativeLayout getView() {
		return (scrollview);
	}

	public  void setEnabled(boolean enabled) {
		//setEnabled(enabled);
		scrollview.setEnabled  (enabled);
		scrollview.setFocusable(enabled);
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		scrollxywh = null;
		this.removeView(scrollview);
		scrollview = null;
		LAMWCommon.free();
	}

	@Override
	public  boolean onInterceptTouchEvent(MotionEvent event) {
		if (!isEnabled()) { return(false); }
		else return super.onInterceptTouchEvent(event);
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

	public void addLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);		
	}

	public void addLParamsParentRule(int rule) {
		LAMWCommon.addLParamsParentRule(rule);		
	}

	public void setLayoutAll(int idAnchor) {		
		LAMWCommon.setLayoutAll(idAnchor);		
		scrollxywh.width = LAMWCommon.getLParamWidth(); //lparamW;
		scrollview.setLayoutParams(scrollxywh);
	}

	public void clearLayoutAll() {
		LAMWCommon.clearLayoutAll();
	}

	//thanks to DonAlfredo
	public  void setFillViewport(boolean _fillenabled) {
		//seee: https://developer.android.com/reference/android/widget/ScrollView.html#setFillViewport(boolean)
		super.setFillViewport(_fillenabled);
	}
	
	/*
	 * l int: Current horizontal scroll origin. 
       t int: Current vertical scroll origin. 
       oldl int: Previous horizontal scroll origin. 
       oldt int: Previous vertical scroll origin.  

	 */
	//http://stackoverflow.com/questions/4263053/android-scrollview-onscrollchanged
	@Override
	protected void onScrollChanged(int l, int t, int oldl, int oldt) {
	        //Log.i("TAG", "scroll changed: " + this.getTop() + " "+t);		    
		    onPosition = 0; //unknow/intermediry
		    int diff=0;		    
	        if(t <= 0){
	        	onPosition = 1;  //top
	            //Log.i("TAG", "scroll top/begin: " + t);	            	            	            	            	           	            
	            //reaches the top end  - begin
	        }	        
	        else {
	            View view = (View) getChildAt(getChildCount()-1);
	            diff = (view.getBottom()-(getHeight()+getScrollY()+view.getTop()));// Calculate the scrolldiff
	            if(diff <= 0 ){
	              // if diff is zero, then the bottom has been reached
	        	  //Log.i("TAG", "scroll bottom/end: " + diff);
	            	onPosition = 2;  //bottom end
	            }
	            else {
	            	//Log.i("TAG", "scroll intermediry: " + diff);
	            	onPosition = 0;
	            }	            	
	        }                       	        
	        super.onScrollChanged(l, t, oldl, oldt);
	        
	        if (mDispacthScrollChanged)   
	          controls.pOnScrollViewChanged(PasObj, l, t, oldl, oldt, onPosition, diff);
	}	
	
    public void ScrollTo(int _x, int _y) {   //pixels 	
	   this.scrollTo(_x, _y);
    }
    
    public void SmoothScrollTo(int _x, int _y) {
	  this.smoothScrollTo(_x, _y);
    }
    
    public void SmoothScrollBy(int _x, int _y) {
	    this.smoothScrollBy(_x,_y);
    }
    
    public int GetScrollX() {
      return this.getScrollX();
    }
    
    public int GetScrollY() {
        return this.getScrollY();
    }
    
    public int GetBottom() {
       return this.getBottom();
    }   
    
    public int GetTop() {
        return this.getTop();
     }   
  
    public int GetLeft() {
      return this.getLeft();
    }
    
    public int GetRight() {
        return this.getRight();
    }    
    
    public void DispatchOnScrollChangedEvent(boolean _value) {
    	mDispacthScrollChanged = _value;
    }       
}


