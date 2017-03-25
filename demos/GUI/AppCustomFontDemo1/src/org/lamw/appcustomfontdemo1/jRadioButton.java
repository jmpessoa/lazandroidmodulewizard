package org.lamw.appcustomfontdemo1;

import java.lang.reflect.Field;

import android.graphics.Bitmap;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RadioButton;

public class jRadioButton extends RadioButton {
	//Java-Pascal Interface
	private long           PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	
	private jCommons LAMWCommon;
	private OnClickListener onClickListener;   // event

	float mTextSize = 0; //default
	int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

	//Constructor
	public  jRadioButton(android.content.Context context,
						 Controls ctrls,long pasobj ) {
		super(context);
		//Connect Pascal I/F
		controls   = ctrls;
		PasObj = pasobj;
		LAMWCommon = new jCommons(this,context,pasobj);

		//Init Event
		onClickListener = new OnClickListener() {
			public  void onClick(View view) {
				controls.pOnClick(PasObj,Const.Click_Default);
			}
		};
		setOnClickListener(onClickListener);
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		this.setOnKeyListener(null);
		this.setText("");
		LAMWCommon.free();
	}

	public long GetPasObj() {
		return LAMWCommon.getPasObj();
	}
	
	public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
	}

	public ViewGroup GetParent() {
		return LAMWCommon.getParent();
	}
	
	public  void setParent( android.view.ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}

	public  void setParent2( android.view.ViewGroup _viewgroup ) { //need by RadioGroup [LinearLayout!]
		ViewGroup parent = LAMWCommon.getParent();
		if (parent != null) { parent.removeView(this); }
		parent = _viewgroup;
		parent.addView(this, 0); //LinearLayout [no lparams], insert at index O ...
		// ?? better !!?? not sure
		// parent.addView(this,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));
		// lparams = null;
		// lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();
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

	public void ClearLayoutAll() { //TODO Pascal
		LAMWCommon.clearLayoutAll();
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
		
	public void SetCompoundDrawables(String _imageResIdentifier, int _side) {
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
	
	public void SetFontFromAssets(String _fontName) {   //   "font/font.ttf"
        Typeface customfont = Typeface.createFromAsset( controls.activity.getAssets(), _fontName);    
        this.setTypeface(customfont);
    }

}
