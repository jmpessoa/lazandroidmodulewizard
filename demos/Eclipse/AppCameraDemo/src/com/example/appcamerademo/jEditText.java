package com.example.appcamerademo;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Typeface;
import android.text.Editable;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextWatcher;
import android.text.method.ScrollingMovementMethod;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Scroller;

public class jEditText extends EditText {
//Pascal Interface
private long           PasObj   = 0;      // Pascal Obj
private Controls      controls = null;   // Control Class for Event
//
private ViewGroup     parent   = null;   // parent view
private RelativeLayout.LayoutParams lparams;           // layout XYWH
private OnKeyListener onKeyListener;     //  thanks to @renabor
private TextWatcher   textwatcher;       // OnChange

private OnClickListener onClickListener;   // event 

//by jmpessoa
int wrapContent = RelativeLayout.LayoutParams.WRAP_CONTENT; //h
int matchParent = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

//by jmpessoa
int MarginLeft = 5;
int MarginTop = 5;

int marginRight = 5;
int marginBottom = 5;

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
//Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//Init Class
lparams = new RelativeLayout.LayoutParams(100,100);
lparams.setMargins(5, 5,5,5);
//this.setHintTextColor(Color.LTGRAY); //default...

mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);

//Event
onClickListener = new OnClickListener() {
 public  void onClick(View view) {
  //if (enabled) {
    controls.pOnClick(PasObj,Const.Click_Default);
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
          controls.pOnEnter(PasObj);  //just Enter/Done/Next/backbutton ....!      
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
		controls.pOnChange(PasObj, s.toString(), (s.toString()).length());
	  }	 
}
@Override
public  void onTextChanged(CharSequence s, int start, int before, int count) {
	  if (canDispatchChangedEvent) {		 
		controls.pOnChanged(PasObj,s.toString(), (s.toString()).length());
	  }   		  	  
}
@Override
public  void afterTextChanged(Editable s) {	  
  //
}
};

addTextChangedListener(textwatcher);

}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

public void setLParamWidth(int w) {
lpW = w;
}

public void setLParamHeight(int h) {
lpH = h;
}


public void addLParamsAnchorRule(int rule) {
 lparamsAnchorRule[countAnchorRule] = rule;
 countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);
	if (idAnchor > 0) {    	
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
  }
	setLayoutParams(lparams);
}
    //CURRENCY 
public  void setInputTypeEx(String str) {
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
public  void setTextAlignment( int align ) {
switch ( align ) {
case 0 : { setGravity( Gravity.LEFT              ); }; break;
case 1 : { setGravity( Gravity.RIGHT             ); }; break;
case 2 : { setGravity( Gravity.TOP               ); }; break;
case 3 : { setGravity( Gravity.BOTTOM            ); }; break;
case 4 : { setGravity( Gravity.CENTER            ); }; break;
case 5 : { setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
case 6 : { setGravity( Gravity.CENTER_VERTICAL   ); }; break;
default : { setGravity( Gravity.LEFT              ); }; break;
};
}

//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
  parent = viewgroup;
  viewgroup.addView(this,lparams);
}

//Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
removeTextChangedListener(textwatcher);
textwatcher = null;
setOnKeyListener(null);
setText("");
lparams = null;
}

//by jmpessoa
public void setScrollerEx() {
	this.setScroller(new Scroller(controls.activity)); 
}

public void setFocus2() {
	this.requestFocus();  
}

public  void immShow2() {
	  InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
	  imm.toggleSoftInput(0, InputMethodManager.SHOW_IMPLICIT);
}


public  void immHide2() {
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
public  void maxLength(int mLength) { //not make the length of the text greater than the specified length		
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


public void SetInputType(int ipt){  //TODO!
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
	 case 8: this.setImeOptions(EditorInfo.IME_FLAG_FORCE_ASCII); break;
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

}

