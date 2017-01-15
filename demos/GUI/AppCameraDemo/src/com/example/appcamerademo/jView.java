package com.example.appcamerademo;

import java.io.FileOutputStream;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

public class jView extends View {
//Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private RelativeLayout.LayoutParams    lparams; //fix by jmpessoa
private jCanvas         jcanvas  = null;   //

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.MATCH_PARENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

//Constructor
public  jView(android.content.Context context,
          Controls ctrls,long pasobj ) {
super(context);
//Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//Init Class
lparams = new LayoutParams(300,300);
lparams.setMargins( 50, 50,0,0);

//this.setWillNotDraw(false);  //fire onDraw ... thanks to tintinux
}

public Bitmap getBitmap(){ 
this.setDrawingCacheEnabled(true);  //thanks to tintinux		
Bitmap b = Bitmap.createBitmap(this.getDrawingCache());
this.setDrawingCacheEnabled(false);	
return b;   
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

//
public  void setjCanvas(java.lang.Object canvas) {   
   jcanvas = (jCanvas)canvas;  
}

//
@Override
public  boolean onTouchEvent( MotionEvent event) {
int act     = event.getAction() & MotionEvent.ACTION_MASK;
switch(act) {
case MotionEvent.ACTION_DOWN: {
      switch (event.getPointerCount()) {
      	case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
      		                            event.getX(0),event.getY(0),0,0); break; }
      	default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
      		                            event.getX(0),event.getY(0),
      		                            event.getX(1),event.getY(1));     break; }
      }
     break;}
case MotionEvent.ACTION_MOVE: {
      switch (event.getPointerCount()) {
      	case 1 : { controls.pOnTouch (PasObj,Const.TouchMove,1,
      		                            event.getX(0),event.getY(0),0,0); break; }
      	default: { controls.pOnTouch (PasObj,Const.TouchMove,2,
      		                            event.getX(0),event.getY(0),
      		                            event.getX(1),event.getY(1));     break; }
      }
     break;}
case MotionEvent.ACTION_UP: {
      switch (event.getPointerCount()) {
      	case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
      		                            event.getX(0),event.getY(0),0,0); break; }
      	default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
      		                            event.getX(0),event.getY(0),
      		                            event.getX(1),event.getY(1));     break; }
      }
     break;}
case MotionEvent.ACTION_POINTER_DOWN: {
      switch (event.getPointerCount()) {
      	case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
      		                            event.getX(0),event.getY(0),0,0); break; }
      	default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
      		                            event.getX(0),event.getY(0),
      		                            event.getX(1),event.getY(1));     break; }
      }
     break;}
case MotionEvent.ACTION_POINTER_UP  : {
      switch (event.getPointerCount()) {
      	case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
      		                            event.getX(0),event.getY(0),0,0); break; }
      	default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
      		                            event.getX(0),event.getY(0),
      		                            event.getX(1),event.getY(1));     break; }
      }
     break;}
} 
return true;
}

//
@Override
public  void onDraw( Canvas canvas) {
jcanvas.setCanvas(canvas);
controls.pOnDraw(PasObj,canvas); // improvement required
}

public void saveView( String sFileName ) {
Bitmap b = Bitmap.createBitmap( getWidth(), getHeight(), Bitmap.Config.ARGB_8888);
Canvas c = new Canvas( b );
draw( c );  
FileOutputStream fos = null;
try {
   fos = new FileOutputStream( sFileName );
   if (fos != null) {
     b.compress(Bitmap.CompressFormat.PNG, 100, fos );
     fos.close(); 
   }  
 }
 catch ( Exception e) {
  Log.e("jView_SaveView", "Exception: "+ e.toString() ); 
 }
}

//Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this);   }
lparams = null;
}

//by jmpessoa
public void setLParamWidth(int w) {
lpW = w;
}

public void setLParamHeight(int h) {
lpH = h;
}

public int getLParamHeight() {	
return getHeight();
}  

public int getLParamWidth() {
	return getWidth();
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
	lparams.width  = lpW; 
	lparams.height = lpH; 
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
 setLayoutParams(lparams);
}

}
