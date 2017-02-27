package com.example.apphorizontalscrollviewdemo1;

import android.view.MotionEvent;
import android.widget.HorizontalScrollView;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;

//-------------------------------------------------------------------------
//LORDMAN 2013-09-03
//Horizontal ScrollView
//    Event pOnClick
//-------------------------------------------------------------------------

public class jHorizontalScrollView extends HorizontalScrollView {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private jCommons LAMWCommon;	
	//
	private RelativeLayout  scrollview;        // Scroll View
	private LayoutParams    scrollxywh;        // Scroll Area
	
	//Constructor
	public  jHorizontalScrollView(android.content.Context context,
								  Controls ctrls,long pasobj ) {
		super(context);

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);

		//this.setBackgroundColor (0xFF0000FF);
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
		scrollxywh.height = LAMWCommon.getLParamHeight(); //lparams.height;
		scrollxywh.width  = _size;
		scrollview.setLayoutParams(scrollxywh);
	}

	public  RelativeLayout getView() {
		return ( scrollview );
	}

	public  void setEnabled(boolean enabled) {
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
		//
		scrollxywh.width = LAMWCommon.getLParamHeight(); //lparamW;
		scrollview.setLayoutParams(scrollxywh);
	}

	public void clearLayoutAll() {
		LAMWCommon.clearLayoutAll();		
	}

}
