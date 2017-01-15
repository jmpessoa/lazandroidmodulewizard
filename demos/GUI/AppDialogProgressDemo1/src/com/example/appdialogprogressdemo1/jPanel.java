package com.example.appdialogprogressdemo1;

import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

//-----------------------------------------
//----- jPanel by jmpessoa
//-----------------------------------------
public class jPanel extends RelativeLayout {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private ViewGroup       parent   = null;

	private RelativeLayout.LayoutParams lparams;           // layout XYWH
		
	private int lparamsAnchorRule[] = new int[40]; 
	int countAnchorRule = 0;

	private int lparamsParentRule[] = new int[40]; 
	int countParentRule = 0;
	
	int lpH = RelativeLayout.LayoutParams.MATCH_PARENT;
	int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

	int MarginLeft   = 0;
	int MarginTop    = 0;
	int marginRight  = 0;
	int marginBottom = 0;
	
	boolean mRemovedFromParent = false;
	
  private GestureDetector gDetect;
  private ScaleGestureDetector scaleGestureDetector;
  
  private float mScaleFactor = 1.0f;
  private float MIN_ZOOM = 0.25f;	  
	private float MAX_ZOOM = 4.0f;	 	 
	    	
	//Constructor
	public  jPanel(android.content.Context context, Controls ctrls,long pasobj ) {
	   super(context);	
	   // Connect Pascal I/F
     PasObj   = pasobj;
	   controls = ctrls;
     lparams = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);		
	   //
     gDetect = new GestureDetector(controls.activity, new GestureListener());
     
     scaleGestureDetector = new ScaleGestureDetector(controls.activity, new simpleOnScaleGestureListener());
	}
		
	public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		MarginLeft = left;
		MarginTop = top;
		marginRight = right;
		marginBottom = bottom;
		lpH = h;
		lpW = w;
		lparams.width  = lpW;
		lparams.height = lpH;
	}	
	
	public void setLParamWidth(int w) {
	  lpW = w;
	  lparams.width  = lpW; 
	}

	public void setLParamHeight(int h) {
	  lpH = h;  
	  lparams.height = lpH; 
	}

	public int getLParamHeight() {	
	  return lpH; //getHeight();
	}  

	public int getLParamWidth() {
	 return lpW; //getWidth();
	}

	public void resetLParamsRules() {
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.removeRule(lparamsAnchorRule[i]);		
		}
				
		for (int j=0; j < countParentRule; j++) {  
			lparams.removeRule(lparamsParentRule[j]);		
	    }
		
		countAnchorRule = 0;
	    countParentRule = 0;
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
		setLayoutParams(lparams); 		
	}
	
	//GetView!-android.widget.RelativeLayout
	public  RelativeLayout getView() {
	   return this;
	}
	
	public  void setParent( android.view.ViewGroup viewgroup ) {
  	if (parent != null) { parent.removeView(this); }
	    parent = viewgroup;
	    parent.addView(this,lparams);
	    mRemovedFromParent=false;
	}	
	
	// Free object except Self, Pascal Code Free the class.
	public  void Free() {
		if (parent != null) { parent.removeView(this); }
		lparams = null;   
	}
	
	public void RemoveParent() {
	   if (!mRemovedFromParent) {
		  	 parent.removeView(this);
		  	mRemovedFromParent = true;
	   } 		   
	}		 
	
  @Override
	public boolean onTouchEvent(MotionEvent event) {
	    return super.onTouchEvent(event);
	}
  
  @Override
	public boolean dispatchTouchEvent(MotionEvent e) {
	        super.dispatchTouchEvent(e);
	        this.gDetect.onTouchEvent(e);
	        this.scaleGestureDetector.onTouchEvent(e);
	        return true;
	}
  
  //ref1. http://code.tutsplus.com/tutorials/android-sdk-detecting-gestures--mobile-21161
  //ref2. http://stackoverflow.com/questions/9313607/simpleongesturelistener-never-goes-in-to-the-onfling-method
  //ref3. http://x-tutorials.blogspot.com.br/2011/11/detect-pinch-zoom-using.html
  private class GestureListener extends GestureDetector.SimpleOnGestureListener {

     private static final int SWIPE_MIN_DISTANCE = 60;
     private static final int SWIPE_THRESHOLD_VELOCITY = 100;
    
	   @Override
	   public boolean onDown(MotionEvent event) {
		  //Log.i("Down", "------------");
	      return true;
	   }
	   
	   @Override
	   public boolean onFling(MotionEvent event1, MotionEvent event2, float velocityX, float velocityY) { 
		   
	      if(event1.getX() - event2.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
             controls.pOnFlingGestureDetected(PasObj, 0);                //onRightToLeft;
             return  true;
         } else if (event2.getX() - event1.getX() > SWIPE_MIN_DISTANCE && Math.abs(velocityX) > SWIPE_THRESHOLD_VELOCITY) {
      	   controls.pOnFlingGestureDetected(PasObj, 1);//onLeftToRight();
      	   return true;
         }
         if(event1.getY() - event2.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
      	   controls.pOnFlingGestureDetected(PasObj, 2);//onBottomToTop();
      	   return false;
         } else if (event2.getY() - event1.getY() > SWIPE_MIN_DISTANCE && Math.abs(velocityY) > SWIPE_THRESHOLD_VELOCITY) {
      	   controls.pOnFlingGestureDetected(PasObj, 3); //onTopToBottom();
      	   return false;
         } 		   
		   return false;
	   }
  }
  
  
 //ref. http://vivin.net/2011/12/04/implementing-pinch-zoom-and-pandrag-in-an-android-view-on-the-canvas/ 
 private class simpleOnScaleGestureListener extends SimpleOnScaleGestureListener {
	  
    @Override
    public boolean onScale(ScaleGestureDetector detector) {         
  	  mScaleFactor *= detector.getScaleFactor();    
  	  mScaleFactor = Math.max(MIN_ZOOM, Math.min(mScaleFactor, MAX_ZOOM));    	    	  
  	// Log.i("tag", "onScale = "+ mScaleFactor);    	 
  	 controls.pOnPinchZoomGestureDetected(PasObj, mScaleFactor, 1); //scalefactor->float    	
       return true;
    }

    @Override
    public boolean onScaleBegin(ScaleGestureDetector detector) {                
  	controls.pOnPinchZoomGestureDetected(PasObj, detector.getScaleFactor(), 0); //scalefactor->float
   	//Log.i("tag", "onScaleBegin");
      return true;
    }

    @Override
    public void onScaleEnd(ScaleGestureDetector detector) {
       controls.pOnPinchZoomGestureDetected(PasObj, detector.getScaleFactor(), 2); //scalefactor->float
   	//Log.i("tag", "onScaleEnd");
      super.onScaleEnd(detector);	  
    }

}
 
 public void SetMinZoomFactor(float _minZoomFactor) {
      MIN_ZOOM = _minZoomFactor;	
 }
 
 public void SetMaxZoomFactor(float _maxZoomFactor) {
	   MAX_ZOOM = _maxZoomFactor;
 }
 
 public void CenterInParent() {
		lparams.addRule(CENTER_IN_PARENT);  //android.widget.RelativeLayout.CENTER_VERTICAL = 15
		countParentRule = countParentRule+1;	 		
 }
    
 public void MatchParent() {		
		lpH = RelativeLayout.LayoutParams.MATCH_PARENT;
		lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w
		lparams.height = lpH;
		lparams.width =  lpW;			
	}
 
 public void WrapParent() {		
		lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
		lpW = RelativeLayout.LayoutParams.WRAP_CONTENT; //w
		lparams.height = lpH;
		lparams.width =  lpW;			
	}
}


