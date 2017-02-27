package com.example.appdemo1;

import android.view.ViewGroup;
import android.widget.ProgressBar;

//Ref.
//Style : http://developer.android.com/reference/android/R.attr.html
//          android.R.attr
//          ------------------------------------------------
//          progressBarStyle              0x01010077 Default
//          progressBarStyleHorizontal    0x01010078
//          progressBarStyleInverse       0x01010287
//          progressBarStyleLarge         0x0101007a
//          progressBarStyleLargeInverse  0x01010289
//          progressBarStyleSmall         0x01010079
//          progressBarStyleSmallTitle    0x0101020f
//          progressDrawable              0x0101013c
//
//-------------------------------------------------------------------------

public class jProgressBar extends ProgressBar {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private jCommons LAMWCommon;

	//Constructor
	public  jProgressBar(android.content.Context context,
						 Controls ctrls,long pasobj,int style ) {
		super(context,null,style);

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);

		setMax(100);
	}

	public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
	}

	public  void setParent( android.view.ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}

	public ViewGroup GetParent() {   //TODO Pascal
		return LAMWCommon.getParent();
	}
	
	public void RemoveFromViewParent() { //TODO Pascal
		LAMWCommon.removeFromViewParent();
	}
	
	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		LAMWCommon.free();
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
	}

	public void ClearLayoutAll() {
		LAMWCommon.clearLayoutAll(); //TODO Pascal
	}
	
}
