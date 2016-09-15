package com.example.appdemo1;

import android.view.MotionEvent;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.ScrollView;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

//-------------------------------------------------------------------------
//ScrollView
//    Event pOnClick
//-------------------------------------------------------------------------

public class jScrollView extends ScrollView {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	//
	private ViewGroup       parent   = null;   // parent view
	private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH

	private RelativeLayout  scrollview;        // Scroll View
	private LayoutParams    scrollxywh;        // Scroll Area

	//by jmpessoa
	private int lparamsAnchorRule[] = new int[30];
	int countAnchorRule = 0;

	private int lparamsParentRule[] = new int[30];
	int countParentRule = 0;

	int lparamH = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
	int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
	int marginLeft = 5;
	int marginTop = 5;
	int marginRight = 5;
	int marginBottom = 5;
	private int lgravity = Gravity.TOP | Gravity.START;
	private float lweight = 0;

	//Constructor
	public  jScrollView(android.content.Context context,
						Controls ctrls,long pasobj ) {
		super(context);

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;

		//Init Class
		lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B
		//
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
		marginLeft = _left;
		marginTop = _top;
		marginRight = _right;
		marginBottom = _bottom;
		lparamH = _h;
		lparamW = _w;
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
	}

	public  void setScrollSize(int _size) {
		scrollxywh.height = _size;
		scrollxywh.width  = lparams.width;
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
		if (parent != null) { parent.removeView(this); }
		scrollxywh = null;
		this.removeView(scrollview);
		scrollview = null;
		lparams = null;
	}

	@Override
	public  boolean onInterceptTouchEvent(MotionEvent event) {
		if (!isEnabled()) { return(false); }
		else return super.onInterceptTouchEvent(event);
	}

	//by jmpessoa
	public void setLParamWidth(int _w) {
		lparamW = _w;
	}

	public void setLParamHeight(int _h) {
		lparamH = _h;
	}

	public void setLGravity(int _g) {
		lgravity = _g;
	}

	public void setLWeight(float _w) {
		lweight = _w;
	}

	public void addLParamsAnchorRule(int rule) {
		lparamsAnchorRule[countAnchorRule] = rule;
		countAnchorRule = countAnchorRule + 1;
	}

	public void addLParamsParentRule(int rule) {
		lparamsParentRule[countParentRule] = rule;
		countParentRule = countParentRule + 1;
	}

	//by jmpessoa
	public void setLayoutAll(int idAnchor) {
		lparams.width  = lparamW; //matchParent;
		lparams.height = lparamH; //wrapContent;
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
		//
		scrollxywh.width = lparamW;
		scrollview.setLayoutParams(scrollxywh);

	}

	public void clearLayoutAll() {
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

	//thanks to DonAlfredo
	public  void setFillViewport(boolean _fillenabled) {
		//seee: https://developer.android.com/reference/android/widget/ScrollView.html#setFillViewport(boolean)
		super.setFillViewport(_fillenabled);
	}

}


