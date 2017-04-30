package com.example.appsqlitedemo2;

import java.lang.reflect.Field;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextWatcher;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.util.TypedValue;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Scroller;
import android.view.Gravity;

public class jEditText extends EditText {
	//Pascal Interface
	//private long           PasObj   = 0;      // Pascal Obj
	private Controls      controls = null;   // Control Class for Event
	private jCommons LAMWCommon;
	//
	private OnKeyListener onKeyListener;     //  thanks to @renabor
	private TextWatcher   textwatcher;       // OnChange

	private OnClickListener onClickListener;   // event

	String bufStr;
	private boolean canDispatchChangeEvent = false;
	private boolean canDispatchChangedEvent = false;
	private boolean mFlagSuggestion = false;

	private ClipboardManager mClipBoard = null;
	private ClipData mClipData = null;

	float mTextSize = 0; //default
	int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

	//Constructor
	public  jEditText(android.content.Context context,
					  Controls ctrls,long pasobj ) {
		super(context);
		canDispatchChangeEvent = false;
		canDispatchChangedEvent = false;

		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);

		mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);

		setOnFocusChangeListener(new OnFocusChangeListener() {
			public void onFocusChange(View v, boolean hasFocus) {
				final int p = v.getId();
				final EditText Caption = (EditText)v;
				if (!hasFocus){
					if (p >= 0) {
						controls.pOnLostFocus(LAMWCommon.getPasObj(), Caption.getText().toString());
					}
				}
			}
		});

		//Event
		onClickListener = new OnClickListener() {
			public  void onClick(View view) {
				//if (enabled) {
				controls.pOnClick(LAMWCommon.getPasObj(),Const.Click_Default);
				//}
			};
		};
		setOnClickListener(onClickListener);

		//Init Event : http://socome.tistory.com/15
		onKeyListener = new OnKeyListener() {
			public  boolean onKey(View v, int keyCode, KeyEvent event) { //Called when a hardware key is dispatched to a view
				if (event.getAction() == KeyEvent.ACTION_UP) {
					if (keyCode == KeyEvent.KEYCODE_ENTER) {
						InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
						imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
						//Log.i("OnKeyListener","OnEnter, Hide KeyBoard");
						// LoadMan
						controls.pOnEnter(LAMWCommon.getPasObj());  //just Enter/Done/Next/backbutton ....!
						return true;
					}
				}
				return false;
			}
		};

		setOnKeyListener(onKeyListener);
		//Event
		textwatcher = new TextWatcher() {
			@Override
			public  void beforeTextChanged(CharSequence s, int start, int count, int after) {
				if (canDispatchChangeEvent) {
					controls.pOnChange(LAMWCommon.getPasObj(), s.toString(), (s.toString()).length());
				}
			}
			@Override
			public  void onTextChanged(CharSequence s, int start, int before, int count) {
				if (canDispatchChangedEvent) {
					controls.pOnChanged(LAMWCommon.getPasObj(),s.toString(), (s.toString()).length());
				}
			}
			@Override
			public  void afterTextChanged(Editable s) {
				//
			}
		};

		addTextChangedListener(textwatcher);
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		removeTextChangedListener(textwatcher);
		textwatcher = null;
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
	//CURRENCY   
	public  void SetInputTypeEx(String str) {  
		bufStr = new String(str.toString());
		if(str.equals("NUMBER")) {
			this.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
		}
		else if(str.equals("CURRENCY")) {  		    //thanks to @renabor
			this.setInputType(InputType.TYPE_CLASS_NUMBER|InputType.TYPE_NUMBER_FLAG_DECIMAL|InputType.TYPE_NUMBER_FLAG_SIGNED);
		}
		else if (str.equals("CAPCHARACTERS")) {
			if (!mFlagSuggestion)
				this.setInputType(android.text.InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS|InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
			else
				this.setInputType(android.text.InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
		}
		else if (str.equals("TEXT")) {
			if (!mFlagSuggestion)
				this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
			else
				this.setInputType(android.text.InputType.TYPE_CLASS_TEXT);
		}
		else if (str.equals("PHONE"))       {this.setInputType(android.text.InputType.TYPE_CLASS_PHONE); }
		else if (str.equals("PASSNUMBER"))  {this.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
			this.setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }
		else if (str.equals("PASSTEXT"))    {this.setInputType(android.text.InputType.TYPE_CLASS_TEXT);
			this.setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }

		else if (str.equals("TEXTMULTILINE")){
			if (!mFlagSuggestion)
				this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|android.text.InputType.TYPE_TEXT_FLAG_MULTI_LINE|InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
			else
				this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|android.text.InputType.TYPE_TEXT_FLAG_MULTI_LINE);
		}

		else {this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);};

	}

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
            case 2 : { setGravity( Gravity.TOP               ); }; break;
            case 3 : { setGravity( Gravity.BOTTOM            ); }; break;
            case 4 : { setGravity( Gravity.CENTER            ); }; break;
            case 5 : { setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
            case 6 : { setGravity( Gravity.CENTER_VERTICAL   ); }; break;
 //[ifdef_api14up]
            default : { setGravity( Gravity.START            ); }; break;
 //[endif_api14up]
 /* //[endif_api14up]
            default : { setGravity( Gravity.LEFT             ); }; break;
 //[ifdef_api14up] */
        };
    }

	//by jmpessoa
	public void setScrollerEx() {
		this.setScroller(new Scroller(controls.activity));
	}

	public void SetFocus() {
		this.requestFocus();
	}

	public  void InputMethodShow() {
		InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.toggleSoftInput(0, InputMethodManager.SHOW_IMPLICIT);
	}


	public  void InputMethodHide() {
		InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(this.getWindowToken(), 0);
	}

	public  int[] getCursorPos() {
		int[] vals = new int[2];
		vals[0] = this.getSelectionStart();
		vals[1] = this.getSelectionEnd();
		return vals;
	}

	public  void setCursorPos(int startPos, int endPos) {
		if (endPos == 0) { endPos = startPos; };
		this.setSelection(startPos,endPos);
	}

	//LORDMAN - 2013-07-26
	public  void MaxLength(int mLength) { //not make the length of the text greater than the specified length
		if (mLength >= 0) {
			InputFilter[] FilterArray = new InputFilter[1];
			FilterArray[0] = new InputFilter.LengthFilter(mLength);
			this.setFilters(FilterArray);
		}
		else {
			this.setFilters(new InputFilter[] {});  //reset to default!!!
		}
	}

	//LORDMAN 2013-08-27
	public  void SetEnabled(boolean enabled ) {
		this.setClickable            (enabled);
		this.setEnabled              (enabled);
		this.setFocusable            (enabled);
		this.setFocusableInTouchMode (enabled);
	}

	//LORDMAN 2013-08-27
	public  void SetEditable(boolean enabled ) {
		this.setClickable(enabled);

		if (enabled) {this.setEnabled(enabled); }

		this.setFocusable(enabled);
		this.setFocusableInTouchMode (enabled);
	}

	//by jmpessoa  :: bug! why?
	public  void SetMovementMethod() {
		this.setMovementMethod(new ScrollingMovementMethod());//ScrollingMovementMethod.getInstance()
	}
	//by jmpessoa
	public String GetText() {
		return this.getText().toString();
	}

	//by jmpessoa
	public  void AllCaps() {
		InputFilter[] FilterArray = new InputFilter[1];
		FilterArray[0] = new InputFilter.AllCaps();
		this.setFilters(FilterArray);
	}

	public void DispatchOnChangeEvent(boolean value) {
		canDispatchChangeEvent = value;
	}

	public void DispatchOnChangedEvent(boolean value) {
		canDispatchChangedEvent = value;
	}


	public void SetInputType(int ipt){  
		this.setInputType(0);
	}

	public void Append(String _txt) {
		this.append(_txt);
	}

	public void AppendLn(String _txt) {
		this.append(_txt+"\n");
	}

	public void AppendTab() {
		this.append("\t");
	}

	public void SetImeOptions(int _imeOption) {
		switch(_imeOption ) {
			case 0: this.setImeOptions(EditorInfo.IME_FLAG_NO_FULLSCREEN); break;
			case 1: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_NONE); break;
			case 2: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_GO); break;
			case 3: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_SEARCH); break;
			case 4: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_SEND); break;
			case 5: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_NEXT); break;
			case 6: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_DONE); break;
			case 7: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_PREVIOUS ); break;
			//case 8: this.setImeOptions(EditorInfo.IME_FLAG_FORCE_ASCII); break;  //api >= 16
		}
	}

	public void setFontAndTextTypeFace(int fontFace, int fontStyle) {
		Typeface t = null;
		switch (fontFace) {
			case 0: t = Typeface.DEFAULT; break;
			case 1: t = Typeface.SANS_SERIF; break;
			case 2: t = Typeface.SERIF; break;
			case 3: t = Typeface.MONOSPACE; break;
		}
		this.setTypeface(t, fontStyle);
	}

	public void SetAcceptSuggestion(boolean _value) {
		mFlagSuggestion = _value;
	}

	public void CopyToClipboard() {
		mClipData = ClipData.newPlainText("text", this.getText().toString());
		mClipBoard.setPrimaryClip(mClipData);
	}

	public void PasteFromClipboard() {
		ClipData cdata = mClipBoard.getPrimaryClip();
		ClipData.Item item = cdata.getItemAt(0);
		this.setText(item.getText().toString());
	}

	public void Clear() {
		this.setText("");
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

	public void SetSelectAllOnFocus(boolean _value){
		this.setSelectAllOnFocus(_value);
	}

	public void SelectAll() {
		this.selectAll();
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
	
	public void SetBackgroundByResIdentifier(String _imgResIdentifier) {	   // ..res/drawable  ex. "ic_launcher"
		this.setBackgroundResource(GetDrawableResourceId(_imgResIdentifier));
	}		

	public void SetBackgroundByImage(Bitmap _image) {	
		Drawable d = new BitmapDrawable(controls.activity.getResources(), _image);
//[ifdef_api16up]
	if(Build.VERSION.SDK_INT >= 16) 
             this.setBackground(d);
//[endif_api16up]
	}	
		
	@Override
	protected void dispatchDraw(Canvas canvas) {
	     //DO YOUR DRAWING ON UNDER THIS VIEWS CHILDREN
		controls.pOnBeforeDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);  //handle by pascal side
	    super.dispatchDraw(canvas);
	    //DO YOUR DRAWING ON TOP OF THIS VIEWS CHILDREN
	    controls.pOnAfterDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);	 //handle by pascal side    
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
		
	// https://blog.stylingandroid.com/gradient-text/
	@Override
    protected void onLayout( boolean changed, int left, int top, int right, int bottom ) {
        super.onLayout( changed, left, top, right, bottom );        
        controls.pOnLayouting(LAMWCommon.getPasObj(), changed);	 //event handle by pascal side                                            
    }
	
	/* https://mobikul.com/just-few-steps-to-make-your-app-rtl-supportable/
	 * add android:supportsRtl="true" to the <application>element in manifest file.
	 */
	public void SetTextDirection(int _textDirection) {		
		//[ifdef_api17up]
		 if(Build.VERSION.SDK_INT >= 17) {
				switch  (_textDirection) {
				case 0: this.setTextDirection(View.TEXT_DIRECTION_INHERIT);	 break; 
				case 1: this.setTextDirection(View.TEXT_DIRECTION_FIRST_STRONG); break; 	 
				case 2: this.setTextDirection(View.TEXT_DIRECTION_ANY_RTL);	  break; 
				case 3: this.setTextDirection(View.TEXT_DIRECTION_LTR); break;  
				case 4: this.setTextDirection(View.TEXT_DIRECTION_RTL); 
					 		  		  		   
				}			
				Log.i("SetTextDirection", "SetTextDirection");
		 }	
       //[endif_api17up]				
	}
	
	public void SetFontFromAssets(String _fontName) {   //   "font/font.ttf"
        Typeface customfont = Typeface.createFromAsset( controls.activity.getAssets(), _fontName);    
        this.setTypeface(customfont);
    }
	
}

