package com.example.appratingbardemo1;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RatingBar;
import android.widget.RelativeLayout;

/*Draft java code by "Lazarus Android Module Wizard" [12/22/2015 20:35:59]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/
 
public class jRatingBar extends RatingBar { //please, fix what GUI object will be extended!
  
  private long       pascalObj = 0;    // Pascal Object
  private Controls   controls  = null; // Control Class for events
  
  private Context context = null;
  private ViewGroup parent   = null;         // parent view
  private RelativeLayout.LayoutParams lparams;              // layout XYWH 
 
  private Boolean enabled  = true;           // click-touch enabled!
  private int lparamsAnchorRule[] = new int[30];
  private int countAnchorRule = 0;
  private int lparamsParentRule[] = new int[30];
  private int countParentRule = 0;
  private int lparamH = 100;
  private int lparamW = 100;
  private int marginLeft = 0;
  private int marginTop = 0;
  private int marginRight = 0;
  private int marginBottom = 0;
  private boolean mRemovedFromParent = false;
  private OnRatingBarChangeListener onRatingBarChangeListener;
 
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
  public jRatingBar(Controls _ctrls, long _Self,  int _numStars, float _step) { //Add more others news "_xxx"p arams if needed!
     super(_ctrls.activity);
     context   = _ctrls.activity;
     pascalObj = _Self;
     controls  = _ctrls;
  
     lparams = new RelativeLayout.LayoutParams(lparamW, lparamH);
               
     onRatingBarChangeListener = new OnRatingBarChangeListener() { 
         /*.*/public void onRatingChanged(RatingBar ratingBar, float rating,  boolean fromUser) {
              controls.pOnRatingBarChanged(pascalObj, rating); //JNI event onClick!
          }
     };     
     setOnRatingBarChangeListener(onRatingBarChangeListener);
     
     this.setNumStars(_numStars);
     this.setStepSize(_step);
  } //end constructor
  
  public void jFree() {
     if (parent != null) { parent.removeView(this); }
     //free local objects...
     lparams = null;
     setOnRatingBarChangeListener(null);
  }
 
  public void SetViewParent(ViewGroup _viewgroup) {
     if (parent != null) { parent.removeView(this); }
     parent = _viewgroup;
     parent.addView(this,lparams);
     mRemovedFromParent = false;
  }
  
  public void RemoveFromViewParent() {
     if (!mRemovedFromParent) {
        this.setVisibility(android.view.View.INVISIBLE);
        if (parent != null)
   	       parent.removeView(this);
	   mRemovedFromParent = true;
	}
  }
 
  public View GetView() {
     return this;
  }
 
  public void SetLParamWidth(int _w) {
     lparamW = _w;
  }
 
  public void SetLParamHeight(int _h) {
     lparamH = _h;
  }
 
  public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
     marginLeft = _left;
     marginTop = _top;
     marginRight = _right;
     marginBottom = _bottom;
     lparamH = _h;
     lparamW = _w;
  }
 
  public void AddLParamsAnchorRule(int _rule) {
     lparamsAnchorRule[countAnchorRule] = _rule;
     countAnchorRule = countAnchorRule + 1;
  }
 
  public void AddLParamsParentRule(int _rule) {
     lparamsParentRule[countParentRule] = _rule;
     countParentRule = countParentRule + 1;
  }
 
  public void SetLayoutAll(int _idAnchor) {
 	lparams.width  = lparamW;
	lparams.height = lparamH;
	lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
	if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
		lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	}
     for (int j=0; j < countParentRule; j++) {
        lparams.addRule(lparamsParentRule[j]);
     }
     this.setLayoutParams(lparams);
  }
 
  public void ClearLayoutAll() {
	for (int i=0; i < countAnchorRule; i++) {
 	   lparams.removeRule(lparamsAnchorRule[i]);
   	}
 
	for (int j=0; j < countParentRule; j++) {
  	   lparams.removeRule(lparamsParentRule[j]);
	}
	countAnchorRule = 0;
	countParentRule = 0;
  }

  public void SetId(int _id) { //wrapper method pattern ...
     this.setId(_id);
  }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
  public float GetRating() {  //the number of stars filled..
	 return this.getRating();
  }
 
  public void SetRating(float _rating){
	  this.setRating(_rating);
  }
  
  public void SetNumStars(int _numStars) {
	  this.setNumStars(_numStars);  
  }
  
  public int GetNumStars() {
	 return this.getNumStars();
  }
  
  public float GetStepSize() { //The step size of this rating bar. if half-star granularity is wanted, this would be 0.5
	 return this.getStepSize();
  }
  
  public void SetStepSize(float _step) {
	  this.setStepSize(_step);
  }
  
  public void SetIsIndicator(boolean _isIndicator) {
    this.setIsIndicator(_isIndicator);
  }
  
  public void SetMax(int _max) {
	  this.setMax(_max);
  }
  
  public boolean IsIndicator() {
	  return this.isIndicator();
  }
  
} //end class


