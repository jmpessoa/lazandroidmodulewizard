package com.example.appintentdemo2;

import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;


public class jCheckBox extends CheckBox {
//Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private LayoutParams    lparams;           // layout XYWH
private OnClickListener onClickListener;   // event

private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

float mTextSize = 0; //default
int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

//by jmpessoa
public void setMarginRight(int x) {
	marginRight = x;
}

//by jmpessoa
public void setMarginBottom(int y) {
	marginBottom = y;
}
//by jmpessoa
public void setMarginLeft(int x) {
	MarginLeft = x;
}

//by jmpessoa
public void setMarginTop(int y) {
	MarginTop = y;
}

//Constructor
public  jCheckBox(android.content.Context context,
             Controls ctrls,long pasobj ) {
super(context);
//Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//Init Class
lparams = new LayoutParams(100,100);     // W,H
lparams.setMargins        (50, 50,0,0); // L,T,
//Init Event
onClickListener = new OnClickListener() {
public  void onClick(View view) {
  controls.pOnClick(PasObj,Const.Click_Default);
}
};
setOnClickListener(onClickListener);
}

//
public  void setXYWH ( int x, int y, int w, int h ) {
lparams.width  = w;
lparams.height = h;
lparams.setMargins(x,y,0,0);
//
setLayoutParams(lparams);
}

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
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
this.setText("");
lparams = null;
}

//by jmpessoa
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
			//lparams.addRule(RelativeLayout.BELOW, id); 
			//lparams.addRule(RelativeLayout.ALIGN_BASELINE, id)
		    //lparams.addRule(RelativeLayout.LEFT_OF, id); //lparams.addRule(RelativeLayout.RIGHT_OF, id)
			for (int i=0; i < countAnchorRule; i++) {  
				lparams.addRule(lparamsAnchorRule[i], idAnchor);		
		    }
			
		} 
		for (int j=0; j < countParentRule; j++) {  
			lparams.addRule(lparamsParentRule[j]);		
	    }
		//
		setLayoutParams(lparams);
}

//by jmpessoa
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

}
