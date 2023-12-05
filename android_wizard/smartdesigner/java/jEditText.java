package org.lamw.appedittextdemo1;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
//import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.lang.reflect.Field;
import java.util.Locale;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.PaintDrawable;
import android.os.Build;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextWatcher;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.util.TypedValue;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Scroller;
import android.view.Gravity;
import android.widget.TextView;

//Reviewed by ADiV on 08/20/2019

public class jEditText extends EditText { //androidx.appcompat.widget.AppCompatEditText 
 
	//Pascal Interface
	//private long           pascalObj   = 0;      // Pascal Obj

	private Controls      controls = null;   // Control Class for Event
	private jCommons LAMWCommon;
	//
	private OnKeyListener onKeyListener;     //  thanks to @renabor
	private TextWatcher   textwatcher;       // OnChange

	private OnClickListener onClickListener;   // event
	
	private EditText mEdit = null;

	String bufStr;
	private boolean canDispatchChangeEvent = false;
	private boolean canDispatchChangedEvent = false;
	private boolean mFlagSuggestion = false;
	private boolean mFlagCapSentence = false;
	private boolean mFlagCaptureBackPressed = false; // by tr3e

	private ClipboardManager mClipBoard = null;
	private ClipData mClipData = null;

	private float mTextSize = 0; //default
	private int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

	private boolean mCloseSoftInputOnEnter = true;

	boolean mIsRounded = false;
	int mBackgroundColor = Color.TRANSPARENT;

	int mRoundRadius = 8;
	int mRoundBorderColor = Color.CYAN;
	int mRoundBorderWidth = 3;
	int mRoundBackgroundColor= Color.TRANSPARENT;
	
	boolean mAllUpperCase = false;
	boolean mAllLowerCase = false;

	Drawable mActionIcon = null;
	boolean mActionIconActived = false;

	//Constructor
	public  jEditText(android.content.Context context,
					  Controls ctrls,long pasobj ) {
		super(context);

		canDispatchChangeEvent = false;
		canDispatchChangedEvent = false;

		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);
		
		mEdit = this;

		mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);

		setOnFocusChangeListener(new OnFocusChangeListener() {
			public void onFocusChange(View v, boolean hasFocus) {
				final int p = v.getId();
				final EditText Caption = (EditText)v;
				
				if (p >= 0){
				 if (!hasFocus)
					controls.pOnLostFocus(LAMWCommon.getPasObj(), Caption.getText().toString());
				 else
					controls.pOnFocus(LAMWCommon.getPasObj(), Caption.getText().toString());					
				}
			}
		});

		//Event
		onClickListener = new OnClickListener() {
			public  void onClick(View view) {
				controls.pOnClick(LAMWCommon.getPasObj(), Const.Click_Default);
			};
		};
		
		setOnClickListener(onClickListener);
		
		// Fixed "Go / Next / Done / Ok" command capture [by TR3E]
		setOnEditorActionListener(new TextView.OnEditorActionListener() {
			        @Override
			        public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
//						IME_ACTION_DONE = 6;
//						IME_ACTION_GO = 2;
//						IME_ACTION_NEXT = 5;
//						IME_ACTION_NONE = 1;
//						IME_ACTION_PREVIOUS = 7;
//						IME_ACTION_SEARCH = 3;
//						IME_ACTION_SEND = 4;

						//--DONE
						if(actionId==6){
							InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
							imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
							controls.pOnDone(LAMWCommon.getPasObj());
							return true;
						}
						//---Go
						if(actionId==2){
							InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
							imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
							controls.pOnGo(LAMWCommon.getPasObj());
							return true;
						}
						//--SEARCH
						if(actionId==3){
							InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
							imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
							controls.pOnSearch(LAMWCommon.getPasObj());
							return true;
						}
						//---NEXT
						if(actionId==5){
							InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
							imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
							controls.pOnNext(LAMWCommon.getPasObj());
							return true;
						}

						if (actionId != 0) {
			            	final EditText caption = (EditText)v;
						    
			            	if (mCloseSoftInputOnEnter) {
								InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
								imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
							}
						    
							if (!caption.getText().toString().equals("")){  //try fix program logic...
								controls.pOnEnter(LAMWCommon.getPasObj());							
							}
											    
			                return true;
			            } else {
			                return false;
			            }
			        }
	     });
		
		onKeyListener = new OnKeyListener() {
			public  boolean onKey(View v, int keyCode, KeyEvent event) { //Called when a hardware key is dispatched to a view
				
				    final EditText caption = (EditText)v;
				    
				    // by tr3e fix back_key close app
				    if( mFlagCaptureBackPressed && (event.getAction() == KeyEvent.ACTION_UP) &&
					   	(KeyEvent.KEYCODE_BACK == keyCode) )
				    {			            
				    	InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
						imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
						controls.pOnBackPressed(LAMWCommon.getPasObj());
						return true;
			        }
				    					
				    if( (event.getAction() == KeyEvent.ACTION_UP) && (keyCode == KeyEvent.KEYCODE_ENTER)){
						if (mCloseSoftInputOnEnter) {
							InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
							imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
						}
						if (! caption.getText().toString().equals("")){  //try fix program logic...
						 controls.pOnEnter(LAMWCommon.getPasObj());
						}
						return mCloseSoftInputOnEnter;
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
			public  void afterTextChanged(Editable et) {
				  String s=et.toString();
				  
				  if(mAllUpperCase)
			       if(!s.equals(s.toUpperCase(Locale.getDefault())))
			       {
			         s=s.toUpperCase(Locale.getDefault());
			         mEdit.setText(s);
			         mEdit.setSelection(mEdit.length()); //fix reverse texting
			       }
				  
				  if(mAllLowerCase)
				       if(!s.equals(s.toLowerCase(Locale.getDefault())))
				       {
				         s=s.toLowerCase(Locale.getDefault());
				         mEdit.setText(s);
				         mEdit.setSelection(mEdit.length()); //fix reverse texting
				       }
			}
		};

		addTextChangedListener(textwatcher);

		//https://google-developer-training.github.io/android-developer-advanced-course-practicals/unit-5-advanced-graphics-and-views/lesson-10-custom-views/10-1a-p-using-custom-views/10-1a-p-using-custom-views.html
		setOnTouchListener(new OnTouchListener() {   //to handle ActionIcon
			@Override
			public boolean onTouch(View v, MotionEvent event) {

				float actionIconStart; // Used for LTR languages
				float actionIconEnd;  // Used for RTL languages
				boolean isActionIconClicked = false;

				// Use the getCompoundDrawables()[2] expression to check
				// if the drawable is on the "end" of text [2].

				if (GetCompoundDrawablesRelative() != null) {

					// Detect the touch in RTL or LTR layout direction.
					if (IsLayoutDirectionRTL()) {
						// If RTL, get the end of the button on the left side.
						actionIconEnd = mActionIcon.getIntrinsicWidth() + GetPaddingStart();
						// If the touch occurred before the end of the button,
						// set isClearButtonClicked to true.
						if (event.getX() < actionIconEnd) {
							isActionIconClicked = true;
						}
					} else {
						// Layout is LTR.
						// Get the start of the button on the right side.
						actionIconStart = (GetWidth() - GetPaddingEnd() - mActionIcon.getIntrinsicWidth());
						// If the touch occurred after the start of the button,
						// set isClearButtonClicked to true.
						if (event.getX() > actionIconStart) {
							isActionIconClicked = true;
						}
					}

					// Check for actions if the button is tapped.
					if (isActionIconClicked) {

						if (event.getAction() == MotionEvent.ACTION_DOWN) {
							controls.pEditTextOnActionIconTouchDown(LAMWCommon.getPasObj(), mEdit.getText().toString());
		}
						if (event.getAction() == MotionEvent.ACTION_UP) {
							controls.pEditTextOnActionIconTouchUp(LAMWCommon.getPasObj(), mEdit.getText().toString());
							performClick();
							return true;
						}
					} else {
						return false;
					}

				}
				return false;
			}
		});

	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		removeTextChangedListener(textwatcher);
		textwatcher = null;
		setOnKeyListener(null);	
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
	
	public void SetAllLowerCase( boolean _lowercase ){
		mAllLowerCase = _lowercase;
	}
	
	public void SetAllUpperCase( boolean _uppercase ){
		mAllUpperCase = _uppercase;
	}
	
	//CURRENCY   
	public  void SetInputTypeEx(String str) {  
		bufStr = new String(str.toString());
		if(str.equals("NUMBER")) {
			this.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
		}
		else if(str.equals("NUMBERFLOAT")) {
			this.setInputType(InputType.TYPE_CLASS_NUMBER|InputType.TYPE_NUMBER_FLAG_DECIMAL|InputType.TYPE_NUMBER_FLAG_SIGNED);
		}
		else if(str.equals("NUMBERFLOATPOSITIVE")) {
			this.setInputType(InputType.TYPE_CLASS_NUMBER|InputType.TYPE_NUMBER_FLAG_DECIMAL);
		}
		else if(str.equals("CURRENCY")) {  		    //thanks to @renabor
			this.setInputType(InputType.TYPE_CLASS_NUMBER|InputType.TYPE_NUMBER_FLAG_DECIMAL|InputType.TYPE_NUMBER_FLAG_SIGNED);
		}
		else if (str.equals("CAPCHARACTERS")) {
				this.setInputType(android.text.InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
		}
		else if (str.equals("TEXT")) {
				this.setInputType(android.text.InputType.TYPE_CLASS_TEXT);
		}
		else if (str.equals("PHONE"))       {this.setInputType(android.text.InputType.TYPE_CLASS_PHONE); }
		else if (str.equals("PASSNUMBER"))  {this.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
			this.setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }
		else if (str.equals("PASSTEXT"))    {this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|android.text.InputType.TYPE_TEXT_VARIATION_PASSWORD);
			this.setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }

		else if (str.equals("TEXTMULTILINE")){
				this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|android.text.InputType.TYPE_TEXT_FLAG_MULTI_LINE);
		}
		else if (str.equals("NULL")){
			this.setInputType(InputType.TYPE_NULL);
		}
		else {this.setInputType(android.text.InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);};

		if (!mFlagSuggestion) {
		  this.setInputType(this.getInputType() | InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
                }
		if (mFlagCapSentence) {
		  this.setInputType(this.getInputType() | InputType.TYPE_TEXT_FLAG_CAP_SENTENCES);
                }

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
            
            case 2 : { setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
            
 //[ifdef_api14up]
            default : { setGravity( Gravity.START            ); }; break;
 //[endif_api14up]
            
 /* //[endif_api14up]
            default : { setGravity( Gravity.LEFT             ); }; break;
 //[ifdef_api14up] */
            
        }
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
		//Repaired forever show the "softInput" by TR3E
		this.requestFocus();
		imm.showSoftInput(this, InputMethodManager.SHOW_IMPLICIT);
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

	public void SetCapSentence(boolean _value) {
		mFlagCapSentence = _value;
	}
	
	// by tr3e
	public void SetCaptureBackPressed(boolean _value) {
		mFlagCaptureBackPressed = _value;
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

	public long GetTextLength() {
		return this.getText().length();
	}

	public boolean IsEmpty() {
		if (this.getText().length() == 0) return true;
		else return false;
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
	
	//by TR3E
	public void SetSelection(int _value){
		this.setSelection(_value);
	}

	public void SetSelectAllOnFocus(boolean _value){
		this.setSelectAllOnFocus(_value);
	}

	public void SelectAll() {
		this.selectAll();
	}	
	
	public void SetBackgroundByResIdentifier(String _imgResIdentifier) {	   // ..res/drawable  ex. "ic_launcher"		
		this.setBackgroundResource(controls.GetDrawableResourceId(_imgResIdentifier));
	}		

	public void SetBackgroundByImage(Bitmap _image) {
		if( _image == null ) return;
		
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
		controls.pOnBeforeDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);  //handle by pascal side
	    super.dispatchDraw(canvas);
	    //DO YOUR DRAWING ON TOP OF THIS VIEWS CHILDREN
	    controls.pOnAfterDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);	 //handle by pascal side    
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
		
	public void SetCompoundDrawables(String _imageResIdentifier, int _side) {
		
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
				//Log.i("SetTextDirection", "SetTextDirection");
		 }	
       //[endif_api17up]				
	}
	
	public void SetFontFromAssets(String _fontName) {   //   "font/font.ttf"
        Typeface customfont = Typeface.createFromAsset( controls.activity.getAssets(), _fontName);    
        this.setTypeface(customfont);
    }
	
	public void RequestFocus() {
		this.requestFocus();
	}

	public void SetCloseSoftInputOnEnter(boolean _closeSoftInput) {
		mCloseSoftInputOnEnter = _closeSoftInput;
	}
	
	public void LoadFromFile(String _path, String _filename) {
		
		File file = new File(_path, _filename);
		StringBuilder content = new StringBuilder();
		
		try {
		    BufferedReader br = new BufferedReader(new FileReader(file));
		    String line;

		    while ((line = br.readLine()) != null) {
		    	content.append(line);
		    	content.append('\n');
		    }
		    br.close();
		}
		catch (IOException e) {
			//
		}
		this.setText(content.toString());
	}
	
	
	public void LoadFromFile(String _filename) {
		     String retStr = "";
		     try {
		         FileInputStream inputStream = new FileInputStream(new File(_filename));
		         if ( inputStream != null ) {
		             InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
		             BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
		             String receiveString = "";
		             StringBuilder stringBuilder = new StringBuilder();
		             while ( (receiveString = bufferedReader.readLine()) != null ) {
		                 stringBuilder.append(receiveString);
		             }
		             inputStream.close();
		             retStr = stringBuilder.toString();
		         }
		     }
		     catch (IOException e) {
		        Log.i("LAMW", "LoadFromFile error: " + e.toString());
		     }
		     this.setText(retStr);
    }
	
	public void SaveToFile(String _path, String _filename){
		     FileWriter fWriter;     
		     try{ // Environment.getExternalStorageDirectory().getPath()
		          fWriter = new FileWriter(_path +"/"+ _filename);
		          fWriter.write(this.getText().toString());
		          fWriter.flush();
		          fWriter.close();
		      }catch(Exception e){
		          e.printStackTrace();
		      }
	}
	
	public void SaveToFile(String _filename) {	  	 
		     try {
		         OutputStreamWriter outputStreamWriter = new OutputStreamWriter(controls.activity.openFileOutput(_filename, Context.MODE_PRIVATE));
		         //outputStreamWriter.write("_header");
		         outputStreamWriter.write(this.getText().toString());
		         //outputStreamWriter.write("_footer");
		         outputStreamWriter.close();
		     }
		     catch (IOException e) {
		        // Log.i("jTextFileManager", "SaveToFile failed: " + e.toString());
		     }
    }

    public void SetSoftInputShownOnFocus(boolean _show) {
		//[ifdef_api21up]
		if (Build.VERSION.SDK_INT >= 21) {
			this.setShowSoftInputOnFocus(_show);
		} //[endif_api21up]
	}

	//https://stackoverflow.com/questions/44071755/android-how-to-set-corner-radius-programmatically
	public void SetRoundCorner() {
		if (this != null) {
			GradientDrawable shape =  new GradientDrawable();
			shape.setCornerRadius(mRoundRadius);
			shape.setStroke(mRoundBorderWidth, mRoundBorderColor);
			shape.setColor(mRoundBackgroundColor); //

			int color;
			Drawable background = this.getBackground();
			if (background instanceof ColorDrawable) {
				color = ((ColorDrawable)this.getBackground()).getColor();
				shape.setColorFilter(color, PorterDuff.Mode.SRC_ATOP);
				shape.setAlpha(((ColorDrawable)this.getBackground()).getAlpha()); // By ADiV
			}

			if(Build.VERSION.SDK_INT >= 16) {
				//[ifdef_api16up]
				this.setBackground(shape); //(Drawable)
				//[endif_api16up]
			}
			else {
				this.setBackgroundDrawable(shape);
			}
		}
	}

	public void SetRoundRadiusCorner(int _radius) {
		mRoundRadius =  _radius;  //8
	}

	public void SetRoundBorderColor(int _color) {
		mRoundBorderColor =  _color; //Color.CYAN
	}

	public void SetRoundBorderWidth(int _strokeWidth) {
		mRoundBorderWidth =  _strokeWidth;  //3
	}

	public void SetRoundBackgroundColor(int _color) {
		mRoundBackgroundColor =  _color;
	}


	public float GetPaddingStart() {
		if (Build.VERSION.SDK_INT >= 17) {
			return  this.getPaddingStart();
		} else return 0;
	}

	public float GetPaddingEnd() {
		if (Build.VERSION.SDK_INT >= 17) {
			return  this.getPaddingEnd();
		} else return 0;
	}

	public float GetWidth() {
		return  this.getWidth();
	}

	public boolean IsLayoutDirectionRTL() {
        boolean isRTL = false;
		if (Build.VERSION.SDK_INT >= 17) {
			//[ifdef_api17up]
			if ( this.getLayoutDirection() == LAYOUT_DIRECTION_RTL ) {
				isRTL =  true;
			}
			//[endif_api17up]
		}
		return isRTL;
	}

	// Use the getCompoundDrawables()[2] expression to check
	// if the drawable is on the "end" of text [2].
	private Drawable GetCompoundDrawablesRelative() {
		Drawable drawable = null;
		if (android.os.Build.VERSION.SDK_INT >= 17) {
			//[ifdef_api17up]
			drawable = this.getCompoundDrawablesRelative()[2];
			//[endif_api17up]
		}
		return drawable;
	}

	//https://google-developer-training.github.io/android-developer-advanced-course-practicals/unit-5-advanced-graphics-and-views/lesson-10-custom-views/10-1a-p-using-custom-views/10-1a-p-using-custom-views.html
	public void SetActionIconIdentifier(String _actionIconIdentifier) {		
		mActionIcon = controls.GetDrawableResourceById(controls.GetDrawableResourceId(_actionIconIdentifier));
	}

	public void ShowActionIcon() {
		if (mActionIcon == null) return;
		if (Build.VERSION.SDK_INT >= 17) {
			//[ifdef_api17up]
			this.setCompoundDrawablesRelativeWithIntrinsicBounds
					(null,                      // Start of text.
							null,               // Above text.
							mActionIcon,  // End of text.
							null);              // Below text.
			//[endif_api17up]
		}
		mActionIconActived = true;
	}

	public void HideActionIcon() {
		if (Build.VERSION.SDK_INT >= 17) {
			//[ifdef_api17up]
			this.setCompoundDrawablesRelativeWithIntrinsicBounds
					(null,                      // Start of text.
							null,                // Above text.
							null,                // End of text.
							null);             // Below text.
			//[endif_api17up]
		}
		mActionIconActived = false;
	}

	public boolean IsActionIconShowing() {
		return mActionIconActived;
	}
	
	public void ApplyDrawableXML(String _xmlIdentifier) {
		this.setBackgroundResource(controls.GetDrawableResourceId(_xmlIdentifier));		
    }

}
