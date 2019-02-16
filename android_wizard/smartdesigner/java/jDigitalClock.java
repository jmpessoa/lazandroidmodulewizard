package com.example.appgooglemapsdemo1;

import android.content.Context;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.DigitalClock;
import android.view.Gravity;

/*Draft java code by "Lazarus Android Module Wizard" [5/9/2015]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jDigitalClock extends DigitalClock /*TextClock*/ { //please, fix what GUI object will be extended!

	private long       pascalObj = 0;    // Pascal Object
	private Controls   controls  = null; // Control Class for events
    private jCommons LAMWCommon;

	private Context context = null;
	
	private OnClickListener onClickListener;   // click event
	private Boolean enabled  = true;           // click-touch enabled!

	float mTextSize = 0; //default
	int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

	//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

	public jDigitalClock(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
		super(_ctrls.activity);
		context   = _ctrls.activity;
		pascalObj = _Self;
		controls  = _ctrls;
		LAMWCommon = new jCommons(this,context,pascalObj);

		onClickListener = new OnClickListener(){
			/*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!
				if (enabled) {
					controls.pOnClick(pascalObj, Const.Click_Default); //JNI event onClick!
				}
			};
		};
		setOnClickListener(onClickListener);
	} //end constructor

	public void jFree() {
		//free local objects...
		setOnClickListener(null);
		LAMWCommon.free();
	}

	public void SetViewParent(ViewGroup _viewgroup) {
		LAMWCommon.setParent(_viewgroup);
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

	public void SetLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
	}

	public void setLWeight(float _w) {
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

	public void SetId(int _id) { //wrapper method pattern ...
		this.setId(_id);
	}

	//write others [public] methods code here......
	//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

	public void SetTextSize(float size) {
		mTextSize = size;
		CharSequence t = this.getText();
		this.setTextSize(mTextSizeTypedValue, mTextSize);
		this.setText(t);
	}

	//TTextSizeTypedValue =(tsDefault, tsPixels, tsDIP, tsInches, tsMillimeters, tsPoints, tsScaledPixel);
	public void SetFontSizeUnit(int _unit) {
		switch (_unit) {
			case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
			case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; //default
			case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break; //default
			case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; //default
			case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; //default
			case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; //default
			case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
		}
		String t = this.getText().toString();
		this.setTextSize(mTextSizeTypedValue, mTextSize);
		this.setText(t);
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

} //end class

