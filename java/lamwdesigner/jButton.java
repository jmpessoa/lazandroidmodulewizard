package com.example.applistviewdemo;

import java.lang.reflect.Field;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
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

	private OnClickListener onClickListener;   // event

    private Controls controls = null;   // Control Class for Event

	int textColor;

	boolean mChangeFontSizeByComplexUnitPixel = false;
	float mTextSize = 0; //default
	int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

    jCommons jLAMWcommon;

	public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
        jLAMWcommon.setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);
	}

	//Constructor
	public  jButton(android.content.Context context,
					Controls ctrls,long pasobj ) {
		super(context);

        controls  = ctrls;
        
        jLAMWcommon = new jCommons(this,context,pasobj);
        
		//Init Event
		onClickListener = new OnClickListener() {
			public  void onClick(View view) {
				//Log.i("TAG_CLICK", "jButton_Clicked!"); //just demo for LATE logcat filter!
				controls.pOnClick(jLAMWcommon.getPasObj(),Const.Click_Default);
			}
		};
		
		setOnClickListener(onClickListener);
		//Log.i("jButton","created!");
	}

	public  void setParent( android.view.ViewGroup _viewgroup ) {
       jLAMWcommon.setParent(_viewgroup);
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		setOnKeyListener(null);
		setText("");
        jLAMWcommon.Free();
	}

	public void setLParamWidth(int w) {
		jLAMWcommon.setLParamWidth(w);
	}

	public void setLParamHeight(int h) {
        jLAMWcommon.setLParamHeight(h);
	}

	public void setLGravity(int _g) {
        jLAMWcommon.setLGravity(_g);
	}

	public void setLWeight(float _w) {
        jLAMWcommon.setLWeight(_w);
	}

	//by jmpessoa
	public void addLParamsAnchorRule(int rule) {
        jLAMWcommon.addLParamsAnchorRule(rule);
	}
	
	//by jmpessoa
	public void addLParamsParentRule(int rule) {
        jLAMWcommon.addLParamsParentRule(rule);
	}

	//by jmpessoa
	public void setLayoutAll(int idAnchor) {
       jLAMWcommon.setLayoutAll(idAnchor);
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

	private int GetDrawableResourceId(String _resName) {
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName" ex. "ic_launcher"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     return 0;
		  }
	}

	public  void SetBackgroundByResIdentifier(String _imgResIdentifier) {	   // ..res/drawable  ex. "ic_launcher"
		this.setBackgroundResource(GetDrawableResourceId(_imgResIdentifier));			
	}	
	
	public  void SetBackgroundByImage(Bitmap _image) {	
		Drawable d = new BitmapDrawable(controls.activity.getResources(), _image);
		this.setBackground(d);
	}
	
	public int getLParamHeight() {
		int r = jLAMWcommon.getLParamHeight();
		
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			r = this.getHeight();
		}		
		return r;
	}

	public int getLParamWidth() {				
		int r = jLAMWcommon.getLParamWidth();		
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			r = this.getWidth();
		}		
		return r;		
	}  
	
	@Override
	protected void dispatchDraw(Canvas canvas) {
	 	
	    //DO YOUR DRAWING ON UNDER THIS VIEWS CHILDREN
		controls.pOnBeforeDispatchDraw(jLAMWcommon.getPasObj(), canvas, 1);  //handle by pascal side
		
	    super.dispatchDraw(canvas);
	    
	    //DO YOUR DRAWING ON TOP OF THIS VIEWS CHILDREN
	    controls.pOnAfterDispatchDraw(jLAMWcommon.getPasObj(), canvas, 1);	 //handle by pascal side    
	}

}
