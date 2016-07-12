package com.example.appchronometerdemo1;

import android.view.MotionEvent;
import android.view.ViewGroup;
import android.widget.HorizontalScrollView;
import android.widget.RelativeLayout;

//-------------------------------------------------------------------------
//LORDMAN 2013-09-03
//Horizontal ScrollView
//    Event pOnClick
//-------------------------------------------------------------------------

public class jHorizontalScrollView extends HorizontalScrollView {
//Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private RelativeLayout.LayoutParams lparams;           // layout XYWH
private RelativeLayout  scrollview;        // Scroll View
private LayoutParams    scrollxywh;        // Scroll Area

//by jmpessoa
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


//Constructor
public  jHorizontalScrollView(android.content.Context context,
               Controls ctrls,long pasobj ) {
super(context);
//Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//Init Class
lparams = new RelativeLayout.LayoutParams(100,100);     // W,H
lparams.setMargins        (50,50,0,0); // L,T,
//
//this.setBackgroundColor (0xFF0000FF);
//Scroll Size
scrollview = new RelativeLayout(context);
//scrollview.setBackgroundColor (0xFFFF0000);

scrollxywh = new LayoutParams(100,100);
scrollxywh.setMargins(0,0,0,0);
scrollview.setLayoutParams(scrollxywh);
this.addView(scrollview);
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

public  void setScrollSize(int size) {
scrollxywh.height = lparams.height;
scrollxywh.width  = size;
scrollview.setLayoutParams(scrollxywh);
}

public  RelativeLayout getView() {
return ( scrollview );
}

public  void setEnabled(boolean enabled) {
//setEnabled(enabled);
scrollview.setEnabled  (enabled);
scrollview.setFocusable(enabled);
}

//Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
scrollxywh = null;
this.removeView(scrollview);
scrollview = null;
lparams = null;
}

@Override
public  boolean onInterceptTouchEvent(MotionEvent event) {
if (!isEnabled()) { return(false); }
else return super.onInterceptTouchEvent(event);
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
 //
	scrollxywh.width = lpW;
	scrollview.setLayoutParams(scrollxywh);
}

}
