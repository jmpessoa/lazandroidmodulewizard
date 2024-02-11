package com.example.appnotificationmanagerdemo2;

import java.lang.reflect.Field;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Point;
import android.graphics.Typeface;
import android.graphics.PorterDuff.Mode;
import android.graphics.RadialGradient;
import android.graphics.Shader;
import android.graphics.SweepGradient;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PaintDrawable;
import android.os.Build;
import android.text.TextUtils;
import android.text.method.LinkMovementMethod;
import android.text.Html;
import android.text.TextUtils.TruncateAt;
//import android.text.util.Linkify;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.Gravity;
import android.widget.TextView;

public class jTextView extends  TextView { //androidx.appcompat.widget.AppCompatTextView
    //Java-Pascal Interface
    private Controls        controls = null;   // Control Class for Event
    private jCommons LAMWCommon;
        
    private OnClickListener onClickListener;
    private OnLongClickListener onLongClickListener;
    
    private Boolean  mEnabled  = true;  

    float mTextSize = 0; 
    int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; 

    private ClipboardManager mClipBoard = null;
    private ClipData mClipData = null;
    private int mRadius = 20;
    
    private int mAngle = 0;
    
    private int mFontFace     = 0; // Normal
    private int mFontTypeFace = 0; // Normal
    
    int mTextAlignment;
        	    
    public  jTextView(android.content.Context context,
                      Controls ctrls,long pasobj ) {
        super(context);
        controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);
        
        mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);

        onClickListener = new OnClickListener() {
            public  void onClick(View view) {
                if (mEnabled) {
                    controls.pOnClick(LAMWCommon.getPasObj(), Const.Click_Default);
                }
            };
        };                     
        
        setOnClickListener(onClickListener);
                
        onLongClickListener = new OnLongClickListener() {

			@Override
			public boolean onLongClick(View arg0) {
				// TODO Auto-generated method stub				
				   if (mEnabled) {
	                    controls.pOnLongClick(LAMWCommon.getPasObj());
	               }								
				   return false;  //true if the callback consumed the long click, false otherwise. 
 			}
        
        };                     
        setOnLongClickListener(onLongClickListener);
                
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
		String tag = ""+left+"|"+top+"|"+right+"|"+bottom;
	    this.setTag(tag); ////nedd by jsRecyclerView.java
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
	
	public void ClearLayoutAll() {		 //TODO Pascal
		LAMWCommon.clearLayoutAll();
	}

	public View GetView() {
	   return this;
    }

	/*
	 	//TTextAlignment = (alLeft, alCenter, alRight);   //Pascal
	public void SetTextAlignment(int _alignment) {
		mTextAlignment = _alignment;	
	    switch(mTextAlignment) {	     
		  case 0: this.setGravity(Gravity.LEFT);  break;
		  case 1: this.setGravity(Gravity.CENTER_HORIZONTAL);  break;
		  case 2: this.setGravity(Gravity.RIGHT); break;					
	    }					
	}

	 */
		
	//LORDMAN 2013-08-13
    public  void SetTextAlignment( int align ) {
        switch ( align ) {
 //[ifdef_api14up]
            case 0 : { setGravity( Gravity.START             ); }; break;
            case 1 : { setGravity( Gravity.END               ); }; break;
 //[endif_api14up]

 /* //[endif_api14up]
            case 0 : { setGravity( Gravity.LEFT              ); }; break;
            case 1 : { setGravity( Gravity.RIGHT             ); }; break;
 //[ifdef_api14up] */
            
            case 2 : { setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
            
 //[ifdef_api14up]
            default : { setGravity( Gravity.START            ); }; break;
 //[endif_api14up]
            
 /* //[endif_api14up]
            default : { setGravity( Gravity.LEFT             ); }; break;
 //[ifdef_api14up] */
            
        }
    }
    public void CopyToClipboard() {
        mClipData = ClipData.newPlainText("text", this.getText().toString());
        if( mClipData == null) return;
        mClipBoard.setPrimaryClip(mClipData);
    }

    public void PasteFromClipboard() {
        ClipData cdata = mClipBoard.getPrimaryClip();
        if(cdata == null) return;
        ClipData.Item item = cdata.getItemAt(0);
        if(item == null) return;
        this.setText(item.getText().toString());
    }

    public  void SetEnabled( boolean value ) {    	
    	mEnabled = value;
        this.setEnabled(value);
    }
    
    public void SetUnderline(boolean _on){
        if( _on )
      	  this.setPaintFlags(this.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG | Paint.ANTI_ALIAS_FLAG);
        else
      	  this.setPaintFlags(Paint.ANTI_ALIAS_FLAG);
      }

    public void Append(String _txt) {
        this.append( _txt);
    }

    public void AppendLn(String _txt) {
        this.append( _txt+ "\n");
    }

    public void AppendTab() {
        this.append("\t");
    }
    
    private void SetFontAndTypeFace(){
    	Typeface t = null;
        switch (mFontFace) {
            case 0: t = Typeface.DEFAULT; break;
            case 1: t = Typeface.SANS_SERIF; break;
            case 2: t = Typeface.SERIF; break;
            case 3: t = Typeface.MONOSPACE; break;
        }
        this.setTypeface(t, mFontTypeFace);
    }
    
    public void SetFontFace( int _fontFace ){
    	
    	mFontFace = _fontFace;
    	
    	SetFontAndTypeFace();        
    }
    
    public void SetTextTypeFace(int _typeface) {
    	
    	mFontTypeFace = _typeface;
    	
    	SetFontAndTypeFace();    
    }

    public void SetTextSize(float size) {
        mTextSize = size;
        String t = this.getText().toString();
        this.setTextSize(mTextSizeTypedValue, mTextSize);
        this.setText(t);
    }

    //TTextSizeTypedValue =(tsDefault, tsPixels, tsDIP, tsMillimeters, tsPoints, tsScaledPixel);
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
	
	@Override
	protected void dispatchDraw(Canvas canvas) {	 	
	    //DO YOUR DRAWING ON UNDER THIS VIEWS CHILDREN
		controls.pOnBeforeDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);  //event handle by pascal side		
	    super.dispatchDraw(canvas);	    
	    //DO YOUR DRAWING ON TOP OF THIS VIEWS CHILDREN
	    controls.pOnAfterDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);	 //event handle by pascal side
	    
	    if (!mEnabled) this.setEnabled(false); 
	}
	
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
		
		switch(_side) {
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
			        if(shape == null) return;
			        shape.setCornerRadius(mRadius);                
			        int color = Color.TRANSPARENT;
			        Drawable background = this.getBackground();
			        if(background == null) return;
			        if (background instanceof ColorDrawable) {
			          color = ((ColorDrawable)this.getBackground()).getColor();
				        shape.setColorFilter(color, Mode.SRC_ATOP);
				        shape.setAlpha(((ColorDrawable)this.getBackground()).getAlpha()); // By ADiV
				        //[ifdef_api16up]
				  	    if(Build.VERSION.SDK_INT >= 16) 
				             this.setBackground((Drawable)shape);
				        //[endif_api16up]			          
			        }                		  	  
		    }
	}		
	
	public void SetRadiusRoundCorner(int _radius) {
		mRadius =  _radius;
	}
	
	public void SetRotation( int angle ){
		mAngle = angle;
		this.setRotation(mAngle);		
	}
		
	// https://blog.stylingandroid.com/gradient-text/
	@Override
    protected void onLayout( boolean changed, int left, int top, int right, int bottom ) {
        super.onLayout( changed, left, top, right, bottom );          
        controls.pOnLayouting(LAMWCommon.getPasObj(), changed);	 //event handle by pascal side                                            
    }
	
	//https://blog.stylingandroid.com/text-shadows/	
	/*	
	  Glowing Text
      this.setShadowLayer(3f, 0, 0, Color.LTGRAY);

      Outline Glow Text
      this.setShadowLayer(2f, 0, 0, Color.WRITE);

      Soft Shadow Text
      this.setShadowLayer(1.5f, 3, 3, Color.LTGRAY);
      
      Soft Shadow Text (below)
      this.setShadowLayer(1.5f, 3, -3, Color.LTGRAY);      

      Engraved Shadow Text
      this.setShadowLayer(0.6f, 1, 1, Color.WHITE);            
	*/
	
	public void SetShadowLayer(float _radius, float _dx, float _dy, int _color)  {		    		  
		this.setShadowLayer(_radius, _dx, _dy, _color);			
	}	
		
	public void SetShaderLinearGradient(int _startColor, int _endColor) {
		
		float min =  this.getHeight();
		if ( min > this.getWidth() ) min = this.getWidth();
		
		Shader  myShader= new LinearGradient( 0, 0, 0, min,  _startColor, _endColor, Shader.TileMode.CLAMP );	         	
        this.getPaint().setShader(myShader);    
    }
	
	//RadialGradient (float centerX, float centerY, float radius, int centerColor, int edgeColor, Shader.TileMode tileMode)
	public void SetShaderRadialGradient(int _centerColor, int _edgeColor) {
		
		float r = this.getWidth()/3;
		if (r < this.getHeight()/3) r = this.getHeight()/3;
		
		Shader  myShader = new RadialGradient(this.getWidth()/2, this.getHeight()/2, r, _centerColor, _edgeColor, Shader.TileMode.CLAMP );	         	
        this.getPaint().setShader(myShader);    
    }	
           
	//SweepGradient (float cx, float cy,  int color0,  int color1) 			
	public void SetShaderSweepGradient(int _color1, int _color2) {	

		float min = this.getHeight();
		if (min > this.getWidth() ) min = this.getWidth();
		
		Shader  myShader = new SweepGradient(0, min/2, _color1, _color2);	         	
        this.getPaint().setShader(myShader);    
    }	
	
	/* https://mobikul.com/just-few-steps-to-make-your-app-rtl-supportable/
	 * add android:supportsRtl="true" to the <application>element in manifest file.
	 */	
	public void SetTextDirection(int _textDirection) {		
		//[ifdef_api17up]
		 if(Build.VERSION.SDK_INT >= 17) {  //need target = 17 !!!
				switch  (_textDirection) {
				case 0: this.setTextDirection(View.TEXT_DIRECTION_INHERIT);	 break; 
				case 1: this.setTextDirection(View.TEXT_DIRECTION_FIRST_STRONG); break; 	 
				case 2: this.setTextDirection(View.TEXT_DIRECTION_ANY_RTL);	  break; 
				case 3: this.setTextDirection(View.TEXT_DIRECTION_LTR); break;  
				case 4: this.setTextDirection(View.TEXT_DIRECTION_RTL); 
					 		  		  		   
				}			
		 }	
       //[endif_api17up]
	}
	
	
	public void SetFontFromAssets(String _fontName) {   //   "fonts/font1.ttf"  or  "font1.ttf" 
        Typeface customfont = Typeface.createFromAsset( controls.activity.getAssets(), _fontName);    
        this.setTypeface(customfont);
    }

	public void SetTextIsSelectable(boolean _value) {   //Sets whether the content of this view is selectable by the user.
	     this.setTextIsSelectable(_value);	    
    }	 
		
	/*
	 * if text is small then add space before and after text
       txtEventName.setText("\t \t \t \t \t \t"+eventName+"\t \t \t \t \t \t");       
       or       
       String summary = "<html><FONT color='#fdb728' FACE='courier'><marquee behavior='scroll' direction='left' scrollamount=10>"
                + "Hello Droid" + "</marquee></FONT></html>";
       webView.loadData(summary, "text/html", "utf-8");     
	 */
	public void  SetScrollingText() { // marquee .... Changes the selection state of this view
		this.setSingleLine(true);
		this.setEllipsize(TruncateAt.MARQUEE);      
		this.setHorizontallyScrolling(true);
		this.setLines(1);
		this.setMarqueeRepeatLimit(-1);
		this.setSelected(true);  	
		//this.invalidate()
	}

	//http://rajeshandroiddeveloper.blogspot.com.br/2013/07/how-to-implement-custom-font-to-text.html
	public void SetTextAsLink(String _linkText) {

               //[ifdef_api24up]
	       if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N)
	        this.setText(Html.fromHtml(_linkText, Html.FROM_HTML_MODE_LEGACY));
           else //[endif_api24up]
		    this.setText(Html.fromHtml(_linkText));

               this.setMovementMethod(LinkMovementMethod.getInstance());
	}

	public void SetTextAsLink(String _linkText, int _color) {  //by ADiV
		//[ifdef_api24up]
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N){
			this.setText(Html.fromHtml(_linkText, Html.FROM_HTML_MODE_LEGACY));
		}else //[endif_api24up]
			this.setText(Html.fromHtml(_linkText));

		this.setMovementMethod(LinkMovementMethod.getInstance());
		this.setLinkTextColor(_color);
	}
	//You can basically set it from anything between 0(fully transparent) to 255 (completely opaque)
	public void SetBackgroundAlpha(int _alpha) {
		this.getBackground().setAlpha(_alpha); //0-255
	}
	
	public void MatchParent() {		
		LAMWCommon.MatchParent();
		
	}

	public void WrapParent() {
		LAMWCommon.WrapParent();		
	}		
	
	public void SetContentDescription(String _description) {
	    this.setContentDescription(_description);
	}

	public void SetScrollingMovement() {  //TODO Pascal
		this.setMovementMethod(new ScrollingMovementMethod());
	}

	public void SetAllCaps(boolean _value) {
		this.setAllCaps(_value);
	}

	public void SetTextAsHtml(String _htmlText) {
		//[ifdef_api24up]
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N){
			this.setText(Html.fromHtml(_htmlText, Html.FROM_HTML_MODE_LEGACY));
		}else //[endif_api24up]
			this.setText(Html.fromHtml(_htmlText)); //Html.fromHtml("5x<sup>2</sup>")
	}
	
	public void ApplyDrawableXML(String _xmlIdentifier) {	    
		this.setBackgroundResource(controls.GetDrawableResourceId(_xmlIdentifier));		
    }

    //https://stackoverflow.com/questions/8087555/programmatically-create-textview-with-ellipsis

	public void SetSingleLine(boolean _value) {
		this.setSingleLine(_value);
	}

	public void SetHorizontallyScrolling(boolean _value) {
		this.setHorizontallyScrolling(_value);
	}

    public void SetEllipsize(int _mode) {
		switch (_mode) {
			case 0: 	{this.setEllipsize(TextUtils.TruncateAt.END); this.setHorizontallyScrolling(false); this.setSingleLine();  break;}
			case 1: 	{this.setEllipsize(TextUtils.TruncateAt.MIDDLE); this.setHorizontallyScrolling(false); this.setSingleLine();  break;}
			case 2: 	{this.setEllipsize(TextUtils.TruncateAt.MARQUEE); this.setHorizontallyScrolling(true);  this.setSingleLine();  break;}
			case 3: 	{this.setEllipsize(TextUtils.TruncateAt.START); this.setHorizontallyScrolling(false); this.setSingleLine(); break;}
		}
		this.setHorizontallyScrolling(false);
		this.setSingleLine();
	}

	public void SetTextAllCaps(String _text) {
		this.setAllCaps(true);
		this.setText(_text);
	}

	public void SetScrollingMovementMethod() {
		this.setMovementMethod(new ScrollingMovementMethod());
	}
	public void SetVerticalScrollBarEnabled(boolean _value) {
		this.setVerticalScrollBarEnabled(_value);
	}
	public void SetHorizontalScrollBarEnabled(boolean _value) {
		this.setHorizontalScrollBarEnabled(_value);
	}
	public void SetVerticalScrollbarPosition(int _value) {
		this.setVerticalScrollbarPosition(_value);
	}

}
