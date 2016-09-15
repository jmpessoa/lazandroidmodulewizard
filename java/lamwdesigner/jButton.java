package com.example.appdemo1;

import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

public class jButton extends Button {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	//
	private ViewGroup       parent   = null;   // parent view
	private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH

	private OnClickListener onClickListener;   // event

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

	int textColor;

	boolean mChangeFontSizeByComplexUnitPixel = false;
	float mTextSize = 0; //default
	int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

	public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		marginLeft = left;
		marginTop = top;
		marginRight = right;
		marginBottom = bottom;
		lparamH = h;
		lparamW = w;
	}

	//Constructor
	public  jButton(android.content.Context context,
					Controls ctrls,long pasobj ) {
		super(context);

		//Connect Pascal I/F
		controls   = ctrls;
		PasObj = pasobj;

		//Init Class
		lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B

		//Init Event
		onClickListener = new OnClickListener() {
			public  void onClick(View view) {
				//Log.i("TAG_CLICK", "jButton_Clicked!"); //just demo for LATE logcat filter!
				controls.pOnClick(PasObj,Const.Click_Default);
			}
		};
		setOnClickListener(onClickListener);
		//Log.i("jButton","created!");
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

		parent.addView(this, newLayoutParams(parent, (ViewGroup.MarginLayoutParams) lparams));
		lparams = null;
		lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		if (parent != null) { parent.removeView(this); }
		setOnKeyListener(null);
		setText("");
		lparams = null;
	}

	public void setLParamWidth(int w) {
		lparamW = w;
	}

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
		lparams.width  = lparamW; //matchParent;
		lparams.height = lparamH; //wrapContent;
		lparams.setMargins(marginLeft, marginTop,marginRight,marginBottom);

		if (lparams instanceof RelativeLayout.LayoutParams) {
			if (idAnchor > 0) {
				//lparams.addRule(RelativeLayout.BELOW, id);
				//lparams.addRule(RelativeLayout.ALIGN_BASELINE, id)
				//lparams.addRule(RelativeLayout.LEFT_OF, id); //lparams.addRule(RelativeLayout.RIGHT_OF, id)
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
		this.setLayoutParams(lparams);
	}

	/*
    * If i set android:focusable="true" then button is highlighted and focused,
    * but then at the same time,
    * i need to click twice on the button to perform the actual click event.
    */
//by jmpessoa
	public  void SetFocusable(boolean enabled ) {
		this.setClickable            (enabled);
		this.setEnabled              (enabled);
		this.setFocusable            (enabled);//*
		this.setFocusableInTouchMode (enabled);//*
//obj.requestFocus(); 
	}

	public void SetTextSize(float size) {
		mTextSize = size;
		String t = this.getText().toString();
		this.setTextSize(mTextSizeTypedValue, mTextSize);
		this.setText(t);
	}

	public void SetChangeFontSizeByComplexUnitPixel(boolean _value) {
		mChangeFontSizeByComplexUnitPixel = _value;
		mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
		if (_value) {
			mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX;
		}
		String t = this.getText().toString();
		setTextSize(mTextSizeTypedValue, mTextSize);
		this.setText(t);
	}

	//TTextSizeTyped =(tsDefault, tsUnitPixels, tsUnitDIP, tsUnitInches, tsUnitMillimeters, tsUnitPoints, tsUnitScaledPixel);
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

	public void PerformClick() {
		this.performClick();
	}

	public void PerformLongClick() {
		this.performLongClick();
	}

}
