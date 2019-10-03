package org.lamw.appcompatrecyclerviewdemo1;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RatingBar;
import android.view.Gravity;

import java.lang.reflect.Field;

/*Draft java code by "Lazarus Android Module Wizard" [12/22/2015 20:35:59]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jRatingBar extends RatingBar { //please, fix what GUI object will be extended!

    private long       pascalObj = 0;    // Pascal Object
    private Controls   controls  = null; // Control Class for events

    private Context context = null;
    private Boolean enabled  = true;           // click-touch enabled!

    private OnRatingBarChangeListener onRatingBarChangeListener;
    
    private jCommons LAMWCommon;

    private String smallStyle = "0";

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jRatingBar(Controls _ctrls, long _Self,  int _numStars, int _style, boolean _isIndicator) { //Add more others news "_xxx"p arams if needed!
        super(_ctrls.activity,null, _style);
        if (_style == android.R.attr.ratingBarStyleSmall ) smallStyle = "1";

       // super(_ctrls.activity);
        //android.R.attr.ratingBarStyleSmall  =  16843280;
        //android.R.attr.ratingBarStyle = 16842876;
        //android.R.attr.ratingBarStyleIndicator = 16843280;

        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;
        LAMWCommon = new jCommons(this,context,pascalObj);
        
        onRatingBarChangeListener = new OnRatingBarChangeListener() {
            /*.*/public void onRatingChanged(RatingBar ratingBar, float rating,  boolean fromUser) {
                if (fromUser) {
                    controls.pOnRatingBarChanged(pascalObj, rating);
                }
            }
        };
        setOnRatingBarChangeListener(onRatingBarChangeListener);
        this.setIsIndicator(_isIndicator);
        this.setNumStars(_numStars);
    } //end constructor

    public void jFree() {
        //free local objects...
        setOnRatingBarChangeListener(null);
        LAMWCommon.free();
    }

	public long GetPasObj() {
		return LAMWCommon.getPasObj();
	}
	
    public void SetViewParent(ViewGroup _viewgroup) {
    	LAMWCommon.setParent(_viewgroup);
    }

	public ViewGroup GetParent() {
		return LAMWCommon.getParent();
	}
	
    public void RemoveFromViewParent() {
    	LAMWCommon.removeFromViewParent();
    }


    public View GetView() {
        return this;
    }

    public void SetLParamWidth(int _w) {
    	LAMWCommon.setLParamWidth(_w);
    }

    public void SetLParamHeight(int _h) {
    	LAMWCommon.setLParamHeight(_h);
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

    public void setLWeight(float _w) {
    	LAMWCommon.setLWeight(_w);
    }

    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
        String tag = ""+_left+"|"+_top+"|"+_right+"|"+_bottom + "|" + smallStyle;
        this.setTag(tag);  //nedd by jsRecyclerView.java
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
        //this.setPadding(_left,_top,_right, _bottom);//TODO nedd by jsRecyclerView.java
    }

    public void AddLParamsAnchorRule(int _rule) {
    	LAMWCommon.addLParamsAnchorRule(_rule);
    }

    public void AddLParamsParentRule(int _rule) {
    	LAMWCommon.addLParamsParentRule(_rule);
     }

    public void SetLayoutAll(int _idAnchor) {
    	LAMWCommon.setLayoutAll(_idAnchor);
    }

    public void ClearLayoutAll() {
    	LAMWCommon.clearLayoutAll();
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

  /* Pascal:
     TFrameGravity = (fgNone,
                   fgTopLeft, fgTopCenter, fgTopRight,
                   fgBottomLeft, fgBottomCenter, fgBottomRight,
                   fgCenter,
                   fgCenterVerticalLeft, fgCenterVerticalRight
                   );     
   */
   public void SetFrameGravity(int _value) {	   
      LAMWCommon.setLGravity(_value);
   }

} //end class


