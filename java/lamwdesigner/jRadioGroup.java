package com.example.appradiogroupdemo1;

import android.content.Context;
import android.graphics.Color;
import android.graphics.PorterDuff.Mode;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PaintDrawable;
import android.os.Build;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.RadioButton;
import android.widget.RadioGroup;

/*Draft java code by "Lazarus Android Module Wizard" [12/25/2015 21:29:17]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jRadioGroup extends RadioGroup /*dummy*/ { //please, fix what GUI object will be extended!

    private long       pascalObj = 0;    // Pascal Object
    private Controls   controls  = null; // Control Class for events
    private jCommons LAMWCommon;
    
    private Context context = null;
    private Boolean enabled  = true;           // click-touch enabled!
  
    public int checkedIndex = -1;   
    int mRadius = 20; 

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jRadioGroup(Controls _ctrls, long _Self, int _orientation) { //Add more others news "_xxx" params if needed!
        super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;
		LAMWCommon = new jCommons(this,context,pascalObj);
		
        checkedIndex =  -1;

        this.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            /*.*/
            public void onCheckedChanged(RadioGroup group, int checkedId) {
            	 	
            	 checkedIndex = -1;
                 if (checkedId >= 0) {
                	 	
	                RadioButton rb = (RadioButton) findViewById(checkedId);
	                
	                if (rb != null) {
		                String checkedCaption = (String) rb.getText();
		
		                for (int i = 0; i < GetChildCount(); i++) {
		                    rb = (RadioButton) GetChildAt(i);
		                    
		                    if (rb !=null) {
		                      if (checkedId == rb.getId()) {
		                    	  checkedIndex = i;
		                        break;
		                      }
		                    }
		                }	
		                
		                if (checkedIndex > -1) 
		                  controls.pRadioGroupCheckedChanged(pascalObj, checkedIndex, checkedCaption); //JNI event onClick!
	                }
	                else {
	                	Log.i("jRadioGroup","rb = null");
	                }
                 }
                
            }
        });///

        if (_orientation == 1)
            this.setOrientation(RadioGroup.VERTICAL);
        else
            this.setOrientation(RadioGroup.HORIZONTAL); //0


    } //end constructor

    public void jFree() {
        setOnCheckedChangeListener(null);
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

    public RadioGroup GetView() {
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

    public void ClearLayoutAll() {   //TODO Pascal
    	LAMWCommon.clearLayoutAll();
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
    
	public void SetRoundCorner() {
		   if (this != null) {  		
			        PaintDrawable  shape =  new PaintDrawable();
			        shape.setCornerRadius(mRadius);                
			        int color = Color.TRANSPARENT;
			        Drawable background = this.getBackground();        
			        if (background instanceof ColorDrawable) {
			          color = ((ColorDrawable)this.getBackground()).getColor();
				        shape.setColorFilter(color, Mode.SRC_ATOP);        		           		        		        
				        //[ifdef_api16up]
				  	    if(Build.VERSION.SDK_INT >= 16) 
				             this.setBackground((Drawable)shape);
				        //[endif_api16up]			          
			        }                		  	  
		    }
	}		
	
	public void SetRadiusRoundCorner(int _radius) {
		mRadius =  _radius;
	}    

} //end class

