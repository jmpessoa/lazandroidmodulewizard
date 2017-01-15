package com.example.appgridviewdemo1;

import java.lang.reflect.Field;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
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


	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		setOnKeyListener(null);
		setText("");
		LAMWCommon.free();
	}

	public long GetPasObj() {
		return LAMWCommon.getPasObj();
	}

	public  void SetViewParent(ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}
	
	public ViewGroup GetParent() {
		return LAMWCommon.getParent();
	}
	
	public void RemoveFromViewParent() {
		LAMWCommon.removeFromViewParent();
	}

	public void SetLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);
	}
		
	public void SetLParamWidth(int w) {
		LAMWCommon.setLParamWidth(w);
	}

	public void SetLParamHeight(int h) {
		LAMWCommon.setLParamHeight(h);
	}
    
	public int GetLParamHeight() {
		return  LAMWCommon.getLParamHeight();
	}

	public int GetLParamWidth() {				
		return LAMWCommon.getLParamWidth();					
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
		LAMWCommon.clearLayoutAll();
	}

	public View GetView() {
	   return this;
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
		if(Build.VERSION.SDK_INT >= 16) this.setBackground(d);
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
