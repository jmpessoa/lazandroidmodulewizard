package com.example.appnotificationmanagerdemo2;

import java.lang.reflect.Field;
import android.graphics.Bitmap;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.TypedValue;
import android.view.View;
import android.widget.CheckBox;
import android.view.Gravity;

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

	public void SetLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		String tag = ""+left+"|"+top+"|"+right+"|"+bottom;
		this.setTag(tag); //nedd by jsRecyclerView.java
		LAMWCommon.setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);
	}

	
	public  void SetViewParent( android.view.ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		this.setOnKeyListener(null);
		this.setText("");
		LAMWCommon.free();
	}

	public void SetLParamWidth(int w) {
		LAMWCommon.setLParamWidth(w);
	}

	public void SetLParamHeight(int h) {
		LAMWCommon.setLParamHeight(h);
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

	public void ClearLayoutAll() {		//TODO Pascal
		LAMWCommon.clearLayoutAll();
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

	//TTextSizeTyped =(tsDefault, tsUnitPixels, tsUnitDIP, tsUnitMillimeters, tsUnitPoints, tsUnitScaledPixel);
	public void SetFontSizeUnit(int _unit) {
		switch (_unit) {
			case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
			case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; 
			case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
			case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; 
			case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; 
			case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 
		}
		String t = this.getText().toString();
		this.setTextSize(mTextSizeTypedValue, mTextSize);
		this.setText(t);
	}
	
	public void SetCompoundDrawables(Bitmap _image, int _side) {		
		Drawable d = new BitmapDrawable(controls.activity.getResources(), _image);
		
		// by TR3E
		if( d == null ){
			this.setCompoundDrawables(null, null, null, null);
			return;
		}
				
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
		
		Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(_imageResIdentifier));
		
		// by TR3E
		if( d == null ){
			this.setCompoundDrawables(null, null, null, null);
			return;
		}
		
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
	
	public void SetFontFromAssets(String _fontName) {   //   "font/font.ttf"
        Typeface customfont = Typeface.createFromAsset( controls.activity.getAssets(), _fontName);    
        this.setTypeface(customfont);
    }
	
}
