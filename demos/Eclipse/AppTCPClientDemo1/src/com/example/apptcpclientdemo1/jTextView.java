package com.example.apptcpclientdemo1;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Typeface;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;


public class jTextView extends TextView {
//Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private LayoutParams    lparams;           // layout XYWH
private OnClickListener onClickListener;   // event
private Boolean         enabled  = true;   //

//by jmpessoa
int wrapContent = RelativeLayout.LayoutParams.WRAP_CONTENT; //h
int matchParent = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

float mTextSize = 0; //default
int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

private ClipboardManager mClipBoard = null;
private ClipData mClipData = null;

//Constructor
public  jTextView(android.content.Context context,
               Controls ctrls,long pasobj ) {                    
super(context);
//Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//Init Class
lparams = new LayoutParams(100,100);     // W,H
lparams.setMargins(5,5,5,5); // L,T,

mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);

//Init Event
onClickListener = new OnClickListener() {
public  void onClick(View view) {
  if (enabled) {
    controls.pOnClick(PasObj,Const.Click_Default);
  }
};
};
setOnClickListener(onClickListener);
}

//by jmpessoa
public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
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
	//
	this.setLayoutParams(lparams);
}

//by jmpessoa
public void setLParamWidth(int w) {
lpW = w;
}

//by jmpessoa
public void setLParamHeight(int h) {
lpH = h;
}

//by jmpessoa
public void addLParamsAnchorRule(int rule) {
	lparamsAnchorRule[countAnchorRule] = rule;
	countAnchorRule = countAnchorRule + 1;
}

//by jmpessoa
public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
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
    
public void CopyToClipboard() {
	mClipData = ClipData.newPlainText("text", this.getText().toString());
  mClipBoard.setPrimaryClip(mClipData);
}
 
public void PasteFromClipboard() {
  ClipData cdata = mClipBoard.getPrimaryClip();
  ClipData.Item item = cdata.getItemAt(0);
  this.setText(item.getText().toString());
}

public void setParent3( android.view.ViewGroup viewgroup ) {  //deprec...
if (parent != null) { parent.removeView(this); }
 parent = viewgroup;
 viewgroup.addView(this,lparams);
}

public void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
 parent = viewgroup;
 viewgroup.addView(this,lparams);
}

public  void setEnabled( boolean value ) {
enabled = value;
}

//Free object except Self, Pascal Code Free the class.
public  void Free() {
 if (parent != null) { parent.removeView(this); }
 setText("");
 lparams = null;
 setOnClickListener(null);
}

/*
* 	this.setTypeface(null, Typeface.BOLD_ITALIC);
	this.setTypeface(null, Typeface.BOLD);
  this.setTypeface(null, Typeface.ITALIC);
  this.setTypeface(null, Typeface.NORMAL);
*/

public void SetTextTypeFace(int _typeface) {
this.setTypeface(null, _typeface);
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

public void SetTextSize(float size) {
 mTextSize = size;	
 String t = this.getText().toString();   
 this.setTextSize(mTextSizeTypedValue, mTextSize);
 this.setText(t);
}     

//TTextSizeTypedValue =(tsDefault, tsPixels, tsDIP, tsInches, tsMillimeters, tsPoints, tsScaledPixel);
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

}
