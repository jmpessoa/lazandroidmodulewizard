package com.example.appdemo1;

import android.content.Context;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

/*Draft java code by "Lazarus Android Module Wizard" [12/25/2015 21:29:17]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jRadioGroup extends RadioGroup /*dummy*/ { //please, fix what GUI object will be extended!

    private long       pascalObj = 0;    // Pascal Object
    private Controls   controls  = null; // Control Class for events

    private Context context = null;
    private ViewGroup parent   = null;         // parent view
    private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH
    private Boolean enabled  = true;           // click-touch enabled!
    private int lparamsAnchorRule[] = new int[30];
    private int countAnchorRule = 0;
    private int lparamsParentRule[] = new int[30];
    private int countParentRule = 0;

    //private int lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
    //private int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
    private int lparamH = 100;
    private int lparamW = 100;
    private int marginLeft = 5;
    private int marginTop = 5;
    private int marginRight = 5;
    private int marginBottom = 5;
    private int lgravity = Gravity.TOP | Gravity.START;
    private float lweight = 0;

    private boolean mRemovedFromParent = false;
    public int checkedIndex = -1;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jRadioGroup(Controls _ctrls, long _Self, int _orientation) { //Add more others news "_xxx" params if needed!
        super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;

        lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
        lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B

        checkedIndex =  -1;

        this.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            /*.*/
            public void onCheckedChanged(RadioGroup group, int checkedId) {

                RadioButton rb = (RadioButton) findViewById(checkedId);
                String checkedCaption = (String) rb.getText();

                for (int i = 0; i < GetChildCount(); i++) {
                    rb = (RadioButton) GetChildAt(i);
                    if (checkedId == rb.getId()) {
                        checkedIndex = i;
                        break;
                    }
                }

                controls.pRadioGroupCheckedChanged(pascalObj, checkedIndex, checkedCaption); //JNI event onClick!
            }
        });

        if (_orientation == 1)
            this.setOrientation(RadioGroup.VERTICAL);
        else
            this.setOrientation(RadioGroup.HORIZONTAL); //0


    } //end constructor

    public void jFree() {
        if (parent != null) { parent.removeView(this); }
        //free local objects...
        lparams = null;
        setOnCheckedChangeListener(null);
    }

    private static MarginLayoutParams newLayoutParams(ViewGroup aparent, ViewGroup.MarginLayoutParams baseparams) {
        if (aparent instanceof FrameLayout) {
            return new FrameLayout.LayoutParams(baseparams);
        } else if (aparent instanceof RelativeLayout) {
            return new RelativeLayout.LayoutParams(baseparams);
        } else if (aparent instanceof LinearLayout) {
            return new LinearLayout.LayoutParams(baseparams);
        } else if (aparent == null) {
            throw new NullPointerException("Parent is null");
        } else {
            throw new IllegalArgumentException("Parent is neither FrameLayout or RelativeLayout or LinearLayout: "
                    + aparent.getClass().getName());
        }
    }

    public void SetViewParent(ViewGroup _viewgroup) {
        if (parent != null) { parent.removeView(this); }
        parent = _viewgroup;

        parent.addView(this,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));
        lparams = null;
        lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();

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

    public RadioGroup GetView() {
        return this;
    }

    public void SetLParamWidth(int _w) {
        lparamW = _w;
    }

    public void SetLParamHeight(int _h) {
        lparamH = _h;
    }

    public void setLGravity(int _g) {
        lgravity = _g;
    }

    public void setLWeight(float _w) {
        lweight = _w;
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

        if (lparams instanceof RelativeLayout.LayoutParams) {
            if (_idAnchor > 0) {
                for (int i = 0; i < countAnchorRule; i++) {
                    ((RelativeLayout.LayoutParams)lparams).addRule(lparamsAnchorRule[i], _idAnchor);
                }
            }
            for (int j = 0; j < countParentRule; j++) {
                ((RelativeLayout.LayoutParams)lparams).addRule(lparamsParentRule[j]);
            }
        }
        if (lparams instanceof FrameLayout.LayoutParams) {
            ((FrameLayout.LayoutParams)lparams).gravity = lgravity;
        }
        if (lparams instanceof LinearLayout.LayoutParams) {
            ((LinearLayout.LayoutParams)lparams).weight = lweight;
        }
        //
        this.setLayoutParams(lparams);
    }

    public void ClearLayoutAll() {
        if (lparams instanceof RelativeLayout.LayoutParams) {
            for (int i = 0; i < countAnchorRule; i++) {
                ((RelativeLayout.LayoutParams)lparams).removeRule(lparamsAnchorRule[i]);
            }

            for (int j = 0; j < countParentRule; j++) {
                ((RelativeLayout.LayoutParams) lparams).removeRule(lparamsParentRule[j]);
            }
        }
        countAnchorRule = 0;
        countParentRule = 0;
    }

    public void SetId(int _id) { //wrapper method pattern ...
        this.setId(_id);
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public RadioButton GetChildAt(int _index) {
        return (RadioButton)this.getChildAt(_index);
    }

    public void Check(int _id) {
        this.check(_id);
    }

    public void ClearCheck() {
        this.clearCheck();
    }

    public int GetCheckedRadioButtonId() {
        return this.getCheckedRadioButtonId();
    }

    public int GetChildCount() {
        return this.getChildCount();
    }

    public void SetOrientation(int _orientation) {
        if (_orientation == 1)
            this.setOrientation(RadioGroup.VERTICAL);
        else
            this.setOrientation(RadioGroup.HORIZONTAL);
    }

    public void CheckRadioButtonByCaption(String _caption) {
        for (int i=0; i < this.getChildCount(); i++){
            RadioButton rb = (RadioButton) this.getChildAt(i);
            String checkedCaption = (String)rb.getText();
            if (checkedCaption.equals(_caption)) {
                this.check(rb.getId());
                checkedIndex = i;
                break;
            }
        }
    }

    public void CheckRadioButtonByIndex(int _index) {
        RadioButton rb = (RadioButton) this.getChildAt(_index);
        checkedIndex = _index;
        this.check(rb.getId());
    }

    public String GetChekedRadioButtonCaption() {
        int checkedId = this.getCheckedRadioButtonId();
        RadioButton rb=(RadioButton)findViewById(checkedId);
        String checkedCaption = (String)rb.getText();
        return checkedCaption;
    }

    public int GetChekedRadioButtonIndex() {
	     /*
	      int res= -1;
		  int checkedId = this.getCheckedRadioButtonId();
		  for (int i=0; i < this.getChildCount(); i++){
			  RadioButton rb = (RadioButton) this.getChildAt(i);				     
		      if (checkedId == rb.getId()) {
		    	  res = i;
		    	  break; 
		      }
		  }
		  */
        return checkedIndex;
    }
    public boolean IsChekedRadioButtonByCaption(String _caption) {
        //this.getChildAt(_index);
        int checkedId = this.getCheckedRadioButtonId();
        RadioButton rb=(RadioButton)findViewById(checkedId);
        String checkedCaption = (String)rb.getText();
        if (checkedCaption.equals(_caption))
            return true;
        else
            return false;
    }

    public boolean IsChekedRadioButtonById(int _id) {
        int checkedId = this.getCheckedRadioButtonId();
        if (checkedId == _id)
            return true;
        else
            return false;
    }

    public boolean IsChekedRadioButtonByIndex(int _index) {
        RadioButton rb=(RadioButton)this.getChildAt(_index);
        int checkedId = this.getCheckedRadioButtonId();
        if (checkedId == rb.getId())
            return true;
        else
            return false;
    }

} //end class

