package com.example.appactionbartabdemo1;

import java.lang.reflect.Field;

import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.TypedValue;
import android.view.View;
import android.widget.CheckBox;

public class jCheckBox extends CheckBox {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private jCommons LAMWCommon;
	//
	private OnClickListener onClickListener;   // event

	float mTextSize = 0; //default
	int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

	//Constructor
	public  jCheckBox(android.content.Context context,
					  Controls ctrls,long pasobj ) {
		super(context);
		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);
		
		//Init Event
		onClickListener = new OnClickListener() {
			public  void onClick(View view) {
				controls.pOnClick(PasObj,Const.Click_Default);
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
		this.setOnKeyListener(null);
		this.setText("");
		LAMWCommon.free();
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

	public void ClearLayoutAll() {		//TODO Pascal
		LAMWCommon.clearLayoutAll();
	}
	
	public void setIdEx(int id) {
		setId(id);
	}

	public void setTextColor2(int value) {
		this.setTextColor(value);
	}

	public  boolean isChecked2() {
		return this.isChecked();
	}

	public  void setChecked2(boolean value) {
		this.setChecked(value);
	}


	public void SetText(String txt) {
		this.setText(txt);
	}

	public String GetText() {
		return this.getText().toString();
	}

	public void SetTextSize(float size) {
		mTextSize = size;
		String t = this.getText().toString();
		this.setTextSize(mTextSizeTypedValue, mTextSize);
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
	
	private Drawable GetDrawableResourceById(int _resID) {
		return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));
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
	
	public void SetCompoundDrawables(Bitmap _image, int _side) {		
		Drawable d = new BitmapDrawable(controls.activity.getResources(), _image);
		int h = d.getIntrinsicHeight(); 
		int w = d.getIntrinsicWidth();   
		d.setBounds( 0, 0, w, h );
		
		switch(_side) {
		  case 0: this.setCompoundDrawables(d, null, null, null); break; //left
		  case 1: this.setCompoundDrawables(null, null, d, null);   break;  //right
		  case 2: this.setCompoundDrawables(null, d, null, null);  break; //above
		  case 3: this.setCompoundDrawables(null, null, null, d); 		
		}		
	}
		
	public void SetCompoundDrawables(String _imageResIdentifier,int _side) {
		int id = GetDrawableResourceId(_imageResIdentifier);
		Drawable d = GetDrawableResourceById(id);  		
		int h = d.getIntrinsicHeight(); 
		int w = d.getIntrinsicWidth();   
		d.setBounds( 0, 0, w, h );		
		
		switch(_side) {
		  case 0: this.setCompoundDrawables(d, null, null, null); break; //left
		  case 1: this.setCompoundDrawables(null, null, d, null);   break;  //right
		  case 2: this.setCompoundDrawables(null, d, null, null);  break; //above
		  case 3: this.setCompoundDrawables(null, null, null, d); 		
		}				
	}
	
}
