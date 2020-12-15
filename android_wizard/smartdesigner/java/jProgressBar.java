package com.example.appgooglemapsdemo1;

import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.view.Gravity;

import android.content.res.ColorStateList;
import android.graphics.PorterDuff.Mode.*;
import android.graphics.drawable.Drawable;

//Ref.
//Style : http://developer.android.com/reference/android/R.attr.html
//          android.R.attr
//          ------------------------------------------------
//          progressBarStyle              16842871 (0x01010077) Default
//          progressBarStyleHorizontal    16842872 (0x01010078)
//          progressBarStyleInverse       16843399 (0x01010287)
//          progressBarStyleLarge         16842874 (0x0101007a)
//          progressBarStyleLargeInverse  16843401 (0x01010289)
//          progressBarStyleSmall         16842873 (0x01010079)
//			progressBarStyleSmallInverse  16843400 (0x01010288)
//          progressBarStyleSmallTitle    16843279 (0x0101020f)
//          progressDrawable              16843068 (0x0101013c)
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

	public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
	}

	public  void SetViewParent( android.view.ViewGroup _viewgroup ) {
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

	public void SetLParamWidth(int _w) {
		LAMWCommon.setLParamWidth(_w);
	}

	public void SetLParamHeight(int _h) {
		LAMWCommon.setLParamHeight(_h);
	}

	public void SetLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
	}

	public void SetLWeight(float _w) {
		LAMWCommon.setLWeight(_w);
	}

	public void AddLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);
	}

	public void AddLParamsParentRule(int rule) {
		LAMWCommon.addLParamsParentRule(rule);
	}

	public void SetLayoutAll(int idAnchor) {
		LAMWCommon.setLayoutAll(idAnchor);
	}

	public void ClearLayoutAll() {
		LAMWCommon.clearLayoutAll(); //TODO Pascal
	}
	
	public void BringToFront() {
		this.bringToFront();
		
		LAMWCommon.BringToFront();		
	}
	
	public void SetColors(int _color, int _colorBack){		
		
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
			this.setProgressTintList(ColorStateList.valueOf(_color));		    
		    this.setProgressBackgroundTintList(ColorStateList.valueOf(_colorBack));
		    
		    if (this.isIndeterminate()) 
		    	this.setIndeterminateTintList(ColorStateList.valueOf(_color));
		    
		  } else {
			  android.graphics.PorterDuff.Mode mode = android.graphics.PorterDuff.Mode.SRC_IN;
		    
		    if (android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.GINGERBREAD_MR1)
		      mode = android.graphics.PorterDuff.Mode.MULTIPLY;
		    
		    if (this.isIndeterminate())
		    	this.getIndeterminateDrawable().setColorFilter(_color, mode);
		    else		    
		    	this.getProgressDrawable().setColorFilter(_color, mode);
		    
		  }
	}

  /* Pascal:
     TFrameGravity = (fgNone,
                   fgTopLeft, fgTopCenter, fgTopRight,
                   fgBottomLeft, fgBottomCenter, fgBottomRight,
                   fgCenter,
                   fgCenterVerticalLeft, fgCenterVerticalRight
                   );     
   */
   public void SetFrameGravity(int _value) {	   
      LAMWCommon.setLGravity(_value);
   }	
}
