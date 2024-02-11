package com.example.appnotificationmanagerdemo2;

import java.lang.reflect.Field;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.LightingColorFilter;
import android.graphics.Typeface;
import android.graphics.PorterDuff.Mode;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PaintDrawable;
import android.os.Build;
import android.os.Handler;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

public class jButton extends Button { //androidx.appcompat.widget.AppCompatButton

	private Controls controls = null;   // Control Class for Event
	private jCommons LAMWCommon;
	
	private OnClickListener onClickListener;   // event
		
	boolean mChangeFontSizeByComplexUnitPixel = false;
	float mTextSize = 0; 
	int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;		
	boolean mIsRounded = false;	
	
	int mBackgroundColor = Color.TRANSPARENT;
	int mSavedBackgroundColor;
	
	int mRadius = 20;
	
	boolean mEnable = true;

	//Constructor
	public  jButton(android.content.Context context, Controls ctrls,long pasobj ) {
		super(context);
		controls  = ctrls;        
		LAMWCommon = new jCommons(this,context,pasobj);		
		
		onClickListener = new OnClickListener() {
			public  void onClick(View view) {
				
			   int color = GetBackgroundColor();

			   if ( color !=  Color.TRANSPARENT) {
				   
			     mSavedBackgroundColor = color;
			     
			     if (mIsRounded == true) {				  
				    SetRoundCorner(Color.LTGRAY);				  
			     } else {
				    SetBackgroundColor(Color.LTGRAY);
			     }								
			     
		         final Handler handler = new Handler();
			     handler.postDelayed(new Runnable() {
				    @Override
				    public void run() {
				        // Do something after: 1s = 1000ms
				    	if (mIsRounded == true) { 
				    	  SetRoundCorner(mSavedBackgroundColor);				    	
				    	}  else {
				    	   SetBackgroundColor(mSavedBackgroundColor);
				    	}   
				    }
			     }, 150);
			  	 
			   }  		
			   
			   if (mEnable) {
			      controls.pOnClick(LAMWCommon.getPasObj(),Const.Click_Default);
			   }
												 				 
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
	
	public void BringToFront() {
		this.bringToFront();
		
		LAMWCommon.BringToFront();
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
	
	public void ClearLayoutAll() {   //TODO Pascal		
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
			case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; 
			case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; 
			case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 
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

	public  void SetBackgroundByResIdentifier(String _imgResIdentifier) {	   // ..res/drawable  ex. "ic_launcher"		
		this.setBackgroundResource( controls.GetDrawableResourceId(_imgResIdentifier) );			
	}	
	
	public  void SetBackgroundByImage(Bitmap _image) {
	  if(_image == null) return;
	  
	  Drawable d = new BitmapDrawable(controls.activity.getResources(), _image);
	  
	  if( d == null ) return;
	  
      //[ifdef_api16up]
	  if(Build.VERSION.SDK_INT >= 16) 
          this.setBackground(d);
      //[endif_api16up]
	}
		
	@Override
	protected void dispatchDraw(Canvas canvas) {	 	
	    //DO YOUR DRAWING ON UNDER THIS VIEWS CHILDREN
		controls.pOnBeforeDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);  //event handle by pascal side		
	    super.dispatchDraw(canvas);	    
	    //DO YOUR DRAWING ON TOP OF THIS VIEWS CHILDREN
	    controls.pOnAfterDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);	 //event handle by pascal side
	    
	    if (!mEnable) this.setEnabled(false);
	}
	
	//http://www.android--tutorials.com/2016/03/android-set-button-drawableleft.html
	public void SetCompoundDrawables(Bitmap _image, int _side) {		
		Drawable d = new BitmapDrawable(controls.activity.getResources(), _image);
		
		// by ADiV
		if( d == null ){
			this.setCompoundDrawables(null, null, null, null);
			return;
		}
		
		int h = d.getIntrinsicHeight(); 
		int w = d.getIntrinsicWidth();   
		d.setBounds( 0, 0, w, h );
		
		switch(_side) {  //(Drawable left, Drawable top, Drawable right, Drawable bottom)
		  case 0: this.setCompoundDrawables(d, null, null, null); break; //left
		  case 1: this.setCompoundDrawables(null, null, d, null);   break;  //right
		  case 2: this.setCompoundDrawables(null, d, null, null);  break; //above
		  case 3: this.setCompoundDrawables(null, null, null, d); 		
		}
	}
		
	public void SetCompoundDrawables(String _imageResIdentifier, int _side) {
		
		Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(_imageResIdentifier));
		
		// by ADiV
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
	
	public void SetRoundCorner() {
		   if (this != null) {			   
			   PaintDrawable  shape =  new PaintDrawable();
			   shape.setCornerRadius(mRadius);                
			   int color = Color.TRANSPARENT;
			   
			   Drawable background = this.getBackground();        
			   if (background instanceof ColorDrawable) {
			     color = ((ColorDrawable)this.getBackground()).getColor();
			     mBackgroundColor = color;
		         shape.setColorFilter(color, Mode.SRC_ATOP);
		         shape.setAlpha(((ColorDrawable)this.getBackground()).getAlpha()); // By ADiV
		          //[ifdef_api16up]
		  	      if(Build.VERSION.SDK_INT >= 16) { 
		             this.setBackground((Drawable)shape);
		             mIsRounded = true;
		  	      }   
		          //[endif_api16up]		  	      		  	         		  	      
			   }
			   
		   }		  
	}
	 		
	public void SetRoundCorner(int _backgroundcolor) {
		   if (this != null) {			   
			   mBackgroundColor = _backgroundcolor;				   
			   PaintDrawable  shape =  new PaintDrawable();
			   shape.setCornerRadius(mRadius);                			   		        
		       shape.setColorFilter(_backgroundcolor, Mode.SRC_ATOP);			        			        			         
		       //[ifdef_api16up]
		  	   if(Build.VERSION.SDK_INT >= 16) { 
		          this.setBackground((Drawable)shape);	
		          mIsRounded = true;
		  	   }   
		       //[endif_api16up]		  	      		  	         		  	      			  				        
		   }		  
	}

	public void SetRadiusRoundCorner(int _radius) {
	   mRadius =  _radius;
	}
	
	public int GetBackgroundColor() {
				 
	     int c = Color.TRANSPARENT;	
		 Drawable background = this.getBackground();      		 
		 if (background instanceof ColorDrawable) { 
		     c = ((ColorDrawable)this.getBackground()).getColor();
		 } else {
			 if (mIsRounded = true) c = mBackgroundColor;
		 }
			 
		 return c;
	}
	
	public void SetBackgroundColor(int _color) {
		if  (this != null) {
		   //mBackgroundColor = _color;
	  	   this.setBackgroundColor(_color);
	  	   //this.setAlpha(0.5f);
		}   
	}
	
	//ref. http://www.41post.com/5094/programming/android-change-color-of-the-standard-button-inside-activity#more-5094
	public void SetBackgroundColor(int _color,  int _mode) {  //0xFFBBAA00
	//Changing the background color of the Button using PorterDuff Mode - Multiply  
    this.getBackground().setColorFilter(_color, android.graphics.PorterDuff.Mode.MULTIPLY);  
    //Set the color of the text displayed inside the button  
    //this.setTextColor(0xFF0000FF);  
    //Render this Button again 
    //this.setAlpha(0.5f);
    this.invalidate();  
	}
	
	
	public void SetBackgroundColor(int _color,  int _lightingMultColor, int _lightingAddColor) { 
      //Changing the background color of the Button using a LightingColorFilter  
      this.getBackground().setColorFilter(new LightingColorFilter(_lightingMultColor, _lightingAddColor));   //0xFFBBAA00, 0x00000000
      //Set the color of the text displayed inside the button  
      //bt_exButton.setTextColor(0xFF0000FF);  
      //Render this Button again  
      this.invalidate();  
	}
    
	public void SetBackgroundColorByMatrixColorFilter(int _multColor) {
	   //Set the color that the button background will be multiplied with  
    int bgColor = _multColor; //0xFFBBAA00;  
    /*Separate each hexadecimal value pair from the bgColor integer and store 
     * each one of them on a separated variable.*/  
    int a = (bgColor >> 24) & 0xFF;  
    int r = (bgColor >> 16) & 0xFF;  
    int g = (bgColor >> 8) & 0xFF;  
    int b = (bgColor >> 0) & 0xFF;  
    /*Create a new ColorMatrixColorFilter passing each individual component 
    of the ColorMatrix this filter uses as a float array.*/  
    ColorMatrixColorFilter cmFilter =   
            new ColorMatrixColorFilter(  
            new float[]{r/255f,0,0,0,0,  
                        0,g/255f,0,0,0,  
                        0,0,b/255f,0,0,  
                        0,0,0,a/255f,0});  
    //Set the cmFilter as the color filter  
    this.getBackground().setColorFilter(cmFilter);  
    //Set the color of the text displayed inside the button  
    //bt_exButton.setTextColor(0xFF0000FF);  
    //Render this Button again  
      this.invalidate();  
	}
	
	public void SetFontFromAssets(String _fontName) {   //   "fonts/font1.ttf"  or "font1.ttf"
        Typeface customfont = Typeface.createFromAsset( controls.activity.getAssets(), _fontName);    
        this.setTypeface(customfont);
    }
	
	public void SetEnabled(boolean _value) {
		mEnable = _value;
		this.setEnabled(_value);		
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
   
   public void SetAllCaps(boolean allCaps)
   {
	   this.setAllCaps(allCaps);
   }

   public void SetFocus() {
   	  this.requestFocus();
   }
   
   public void ApplyDrawableXML(String _xmlIdentifier) {
	   this.setBackgroundResource(controls.GetDrawableResourceId(_xmlIdentifier));		
   }

	public void Append(String _txt) {
		this.append(_txt);
	}

}
