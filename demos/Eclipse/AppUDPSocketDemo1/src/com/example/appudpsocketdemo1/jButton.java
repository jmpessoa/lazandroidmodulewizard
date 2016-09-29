package com.example.appudpsocketdemo1;

import java.lang.reflect.Field;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.TypedValue;
import android.view.View;
import android.widget.Button;

public class jButton extends Button {

	private Controls controls = null;   // Control Class for Event
	private jCommons LAMWCommon;
	
	private OnClickListener onClickListener;   // event
	
	int textColor;
	boolean mChangeFontSizeByComplexUnitPixel = false;
	float mTextSize = 0; 
	int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;

	//Constructor
	public  jButton(android.content.Context context, Controls ctrls,long pasobj ) {
		super(context);
		controls  = ctrls;        
		LAMWCommon = new jCommons(this,context,pasobj);
		onClickListener = new OnClickListener() {
			public  void onClick(View view) {
				controls.pOnClick(LAMWCommon.getPasObj(),Const.Click_Default);
			}
		};		
		setOnClickListener(onClickListener);
	}

	public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);
	}
	
	public  void setParent( android.view.ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		setOnKeyListener(null);
		setText("");
		LAMWCommon.Free();
	}

	public void setLParamWidth(int w) {
		LAMWCommon.setLParamWidth(w);
	}

	public void setLParamHeight(int h) {
		LAMWCommon.setLParamHeight(h);
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

	/*
    * If i set android:focusable="true" then button is highlighted and focused,
    * but then at the same time,
    * i need to click twice on the button to perform the actual click event.
    */
	public  void SetFocusable(boolean enabled ) {
		this.setClickable            (enabled);
		this.setEnabled              (enabled);
		this.setFocusable            (enabled);
		this.setFocusableInTouchMode (enabled); 
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

	public void SetFontSizeUnit(int _unit) {
		switch (_unit) {
			case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 
			case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; 
			case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
			case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; 
			case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; 
			case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; 
			case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 
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
		return  LAMWCommon.getLParamHeight();
	}

	public int getLParamWidth() {				
		return LAMWCommon.getLParamWidth();					
	}  
	
	@Override
	protected void dispatchDraw(Canvas canvas) {	 	
	    //DO YOUR DRAWING ON UNDER THIS VIEWS CHILDREN
		controls.pOnBeforeDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);  //event handle by pascal side		
	    super.dispatchDraw(canvas);	    
	    //DO YOUR DRAWING ON TOP OF THIS VIEWS CHILDREN
	    controls.pOnAfterDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);	 //event handle by pascal side    
	}
}
