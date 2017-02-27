package com.example.appgooglemapsdemo1;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.SeekBar;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

/*Draft java code by "Lazarus Android Module Wizard" [7/8/2015 22:55:27]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jSeekBar extends SeekBar /*dummy*/ { //please, fix what GUI object will be extended!

    private long       pascalObj = 0;    // Pascal Object
    private Controls   controls  = null; // Control Class for events
    
    private jCommons LAMWCommon;

    private Context context = null;
    private ViewGroup parent   = null;         // parent view
    private OnClickListener onClickListener;   // click event

    private OnSeekBarChangeListener onSeekBarChangeListener;

    private Boolean enabled  = true;           // click-touch enabled!
    
    //private int lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
    //private int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
    
    int mProgress = 0;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jSeekBar(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
        super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;
        LAMWCommon = new jCommons(this,context,pascalObj);
        
            onClickListener = new OnClickListener(){
            /*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!
                if (enabled) {
                    //controls.pOnClick(pascalObj, Const.Click_Default); //JNI event onClick!
                }
            };
        };

        setOnClickListener(onClickListener);

        onSeekBarChangeListener = new OnSeekBarChangeListener() {
            @Override
         /*.*/public void onProgressChanged(SeekBar seekBar, int progresValue, boolean fromUser) {
                mProgress = progresValue;
                controls.pOnSeekBarProgressChanged(pascalObj, mProgress, fromUser);
            }

            @Override
         /*.*/public void onStartTrackingTouch(SeekBar seekBar) {
                controls.pOnSeekBarStartTrackingTouch(pascalObj, seekBar.getProgress());
            }

            @Override
         /*.*/public void onStopTrackingTouch(SeekBar seekBar) {
                controls.pOnSeekBarStopTrackingTouch(pascalObj, seekBar.getProgress());
            }
        };

        setOnSeekBarChangeListener(onSeekBarChangeListener);
    } //end constructor

    public void jFree() {
        //free local objects...
        setOnClickListener(null);
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
	
    public void setLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
    }

    public void setLWeight(float _w) {
    	LAMWCommon.setLWeight(_w);
    }

    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
    	LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
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

    public void SetId(int _id) { //wrapper method pattern ...
        this.setId(_id);
    }

    public void SetMax(int _maxProgress) {
        this.setMax(_maxProgress);
    }

    public void SetProgress(int _progress) {
        if (_progress <  this.getMax())
            this.setProgress(_progress);
    }

    public int GetProgress() {
        return this.getProgress();
    }

    public void SetRotation(float _rotation) {  //  API level 11 270 = vertical
        this.setRotation(_rotation);
    }

} //end class

