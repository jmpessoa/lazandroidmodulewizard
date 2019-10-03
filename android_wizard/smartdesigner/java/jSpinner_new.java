package org.lamw.appcomboedittext;

import java.util.ArrayList;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsSpinner;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.Spinner;
import android.widget.TextView;
import android.view.Gravity;


class ItemRow {
	String label = "";
	String tag= "";	
	Context ctx;

	public  ItemRow(Context c, String lab, String tg) {
		label = lab;
		tag= tg;
		ctx = c;
	}	
}


//by jmpessoa
class CustomSpinnerArrayAdapter<T> extends ArrayAdapter<ItemRow> {

    Context ctx;
    private int mTextColor = Color.BLACK;
    private int mTexBackgroundColor = Color.TRANSPARENT;
    private int mSelectedTextColor = Color.BLACK;  
    private int flag = 0;
    private boolean mLastItemAsPrompt = false;
    private int mTextFontSize = 0;
    private int mTextSizeTypedValue;

    private int mTextAlignment;
    private Typeface mFontFace;
    private int mFontStyle;
    
    private int mSelectedPadTop = 15;
    private int mSelectedPadBottom = 5;
    
    private ArrayList<ItemRow> items ;

    public CustomSpinnerArrayAdapter(Context context, int simpleSpinnerItem, ArrayList<ItemRow> list) {
        super(context, simpleSpinnerItem, list);        
        ctx = context;
        mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
        mTextAlignment = Gravity.CENTER;
        items = list;
    }

    public void SetFontSizeUnit(int _unit) {
        switch (_unit) {
            case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
            case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break;
            case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
            case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break;
            case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break;
            case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break;
        }
    }

    public void SetTextAlignment(int _alignment) {
        mTextAlignment = _alignment;
    }

    public void SetFontAndTextTypeFace(Typeface fontFace, int fontStyle) {
        mFontFace = fontFace;
        mFontStyle = fontStyle;
    }

    //This method is used to display the dropdown popup that contains data.
    @Override
    public View getDropDownView(int position, View convertView, ViewGroup parent) {    	
       return getLayoutView(position, convertView, parent, mSelectedPadTop + 15 , mSelectedPadBottom + 15);    	
    }

    //This method is used to return the customized view at specified position in list.
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
       return getLayoutView(position, convertView, parent, mSelectedPadTop, mSelectedPadBottom);    	
    }
    
    public View getLayoutView(int position, View convertView, ViewGroup parent, int padTop, int padBottom) {
    	    	
        if ( position >= 0) {
    		        	
            LinearLayout listLayout = new LinearLayout(ctx);
            
    	    listLayout.setOrientation(LinearLayout.HORIZONTAL);
    		                                                                                    
    		AbsSpinner.LayoutParams lparam = new AbsSpinner.LayoutParams(AbsSpinner.LayoutParams.MATCH_PARENT,	
    		                                                             AbsSpinner.LayoutParams.WRAP_CONTENT); //w, h    		
    		listLayout.setLayoutParams(lparam);
    		
    		RelativeLayout itemLayout = new RelativeLayout(ctx);
    		
    		LinearLayout txtLayout = new LinearLayout(ctx);    		
    		txtLayout.setOrientation(LinearLayout.VERTICAL);	
    		    	    		                                                          		
    		TextView txtview = new TextView(ctx);
    		
    		txtview.setText(items.get(position).label); 
    		//txtview.setPadding(20, 40, 20, 40);
    		txtview.setPadding(20, padTop, 20, padBottom);  //padTop, padBottom
    		txtview.setTextColor(mSelectedTextColor);        
    		txtview.setBackgroundColor(mTexBackgroundColor);
            
            if (mTextFontSize != 0) {            	
                if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
                	txtview.setTextSize(mTextSizeTypedValue, mTextFontSize);
                else
                	txtview.setTextSize(mTextFontSize);
            }

            txtview.setTypeface(mFontFace, mFontStyle);

    		//TTextAlignment = (alLeft, alCenter, alRight);   //Pascal
            
			switch(mTextAlignment) {						      			      
			 //[ifdef_api14up]
               case 0 : { txtview.setGravity( Gravity.START             ); }; break;
               case 1 : { txtview.setGravity( Gravity.END               ); }; break;
             //[endif_api14up]
            
         /* //[endif_api14up]
               case 0 : { txtview.setGravity( Gravity.LEFT              ); }; break;
               case 1 : { txtview.setGravity( Gravity.RIGHT             ); }; break;
            //[ifdef_api14up] */
            
               case 2 : { txtview.setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
            
            //[ifdef_api14up]
               default : { txtview.setGravity( Gravity.START            ); }; break;
            //[endif_api14up]
            
            /* //[endif_api14up]
               default : { txtview.setGravity( Gravity.LEFT             ); }; break;
            //[ifdef_api14up] */
            
			}					
			
			
    		LayoutParams txtParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); //w,h    		             
			txtParam.leftMargin = 10;
			txtParam.rightMargin = 10;						
			
      	    switch(mTextAlignment) {     	       
		       case 0: txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);  break;
		       case 1: txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);  break;
		       case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT); break;					
     	    }
                                          
			
			if (mLastItemAsPrompt) flag = 1;
			
            txtLayout.addView(txtview);
            
            itemLayout.addView(txtLayout, txtParam);
            
            listLayout.addView(itemLayout);
                        
            
    		return listLayout;
    		
    	} else return convertView;
    }
    
    @Override
    public int getCount() {
        if (flag == 1)
            return super.getCount() - 1; //do not show last item
        else 
        	return super.getCount();
    }

    public void SetTextColor(int txtColor){
        mTextColor = txtColor;
    }

    public void SetBackgroundColor(int txtColor){
        mTexBackgroundColor = txtColor;
    }

    public void SetSelectedTextColor(int txtColor){
        mSelectedTextColor = txtColor;
    }

    public void SetLastItemAsPrompt(boolean _hasPrompt) {
        mLastItemAsPrompt = _hasPrompt;
    }

    public void SetTextFontSize(int txtFontSize) {
        mTextFontSize = txtFontSize;
    }
 
    public void SetSelectedPadTop(int _top) {
       mSelectedPadTop = _top;
    }
    
    public void SetSelectedPadBottom(int  _bottom) {
       mSelectedPadBottom = _bottom; 
    }

}

/*Draft java code by "Lazarus Android Module Wizard" [6/11/2014 22:00:44]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jSpinner extends Spinner /*dummy*/ { //please, fix what GUI object will be extended!

    private long       pascalObj = 0;    // Pascal Object
    private Controls   controls  = null; // Control Class for events

    private Context context = null;
    private Boolean enabled  = true;           // click-touch enabled!

    private ArrayList<ItemRow>  mStrList;
    
    private CustomSpinnerArrayAdapter<ItemRow> mSpAdapter;
    
    private boolean mLastItemAsPrompt = false;
    private int mTextAlignment;
    
    private String mSelectedText="";
    
    private int mSelectedIndex= -1;
    private int mSelectedPadTop = 15;
    private int mSelectedPadBottom = 15;
    
    
    private jCommons LAMWCommon;


    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jSpinner(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        super(_ctrls.activity);
        
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;
        
        LAMWCommon = new jCommons(this,context,pascalObj);

        mTextAlignment = Gravity.CENTER;
        
        mStrList = new ArrayList<ItemRow>();
                
        mSpAdapter = new CustomSpinnerArrayAdapter<ItemRow> (context, android.R.layout.simple_spinner_item, mStrList);               
        mSpAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        setAdapter(mSpAdapter);
        setOnItemSelectedListener(spinnerListener);
        
    } //end constructor

    public void jFree() {
        //free local objects...
        mStrList = null;
        mSpAdapter = null;
        setOnItemSelectedListener(null);
        LAMWCommon.free();
    }

    //implement action listener type of OnItemSelectedListener
    private OnItemSelectedListener spinnerListener =new OnItemSelectedListener() {

        @Override   
   /*.*/public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            String caption = mStrList.get((int)id).label;
            setSelection(position);
            mSelectedIndex = position;
            mSelectedText = caption;
            controls.pOnSpinnerItemSeleceted(pascalObj,position,caption); 
        }

        @Override
   /*.*/public void onNothingSelected(AdapterView<?> parent) {}

    };

    public void SetjParent(ViewGroup _viewgroup) {
    	LAMWCommon.setParent(_viewgroup);
    }
    
	public ViewGroup GetParent() {
		return LAMWCommon.getParent();
	}

	public void RemoveFromViewParent() {   //TODO Pascal
		LAMWCommon.removeFromViewParent();
	}
	
    public void SetLParamWidth(int _w) {
    	LAMWCommon.setLParamWidth(_w);
    }

    public void SetLParamHeight(int _h) {
    	LAMWCommon.setLParamHeight(_h);
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

    public void clearLayoutAll() {
    	LAMWCommon.clearLayoutAll();
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ..

    public int GetSelectedItemPosition() {
        return this.getSelectedItemPosition();
    }

    public String GetSelectedItem() {    	
    	int i = this.getSelectedItemPosition();    	 
    	if (i >= 0) {
    	   mSelectedText = mStrList.get(i).label;
    	  
    	}   
    	else {
    		mSelectedText = "";    			
    	} 
    	return mSelectedText;
    }

    public void Add(String _item) {
    	ItemRow info = new ItemRow(controls.activity, _item, "0");
        mStrList.add(info);        
        mSpAdapter.notifyDataSetChanged();
    }

    //ELERA_04032015
    public void Clear() {
        mStrList.clear();
        mSpAdapter.notifyDataSetChanged();
    }

    public void SetSelectedTextColor(int _color) {
        mSpAdapter.SetSelectedTextColor(_color);
    }

    public void SetDropListTextColor(int _color) {
        mSpAdapter.SetTextColor(_color);
    }

    public void SetDropListBackgroundColor(int _color) {
        mSpAdapter.SetBackgroundColor(_color);
    }

    public void SetLastItemAsPrompt(boolean _hasPrompt) {
        mLastItemAsPrompt = _hasPrompt;
        mSpAdapter.SetLastItemAsPrompt(_hasPrompt);
        if (mLastItemAsPrompt) {
            if (mStrList.size() > 0) setSelection(mStrList.size()-1);
        }
    }

    public int GetSize() {
        return mStrList.size();
    }

    public void Delete(int _index) {
        if (_index < 0) mStrList.remove(0);
        else if (_index > (mStrList.size()-1)) mStrList.remove(mStrList.size()-1);
        else mStrList.remove(_index);
        mSpAdapter.notifyDataSetChanged();
    }

    public void SetItem(int _index, String _item) {
        if (_index < 0) {
        
        	mStrList.set(0, new ItemRow(controls.activity, _item,  "0"));
        }	
        else if (_index > (mStrList.size()-1)) { 
        	 mStrList.set(mStrList.size()-1, new ItemRow(controls.activity, _item,  "0"));
        }	 
        else { 
        	mStrList.set(_index, new ItemRow(controls.activity, _item,  "0"));
        }	
        mSpAdapter.notifyDataSetChanged();
    }
    
    public void SetTextFontSize(int _txtFontSize) {
        mSpAdapter.SetTextFontSize(_txtFontSize);
    }
   
   /*
   public void SetChangeFontSizeByComplexUnitPixel(boolean _value) {
	   mSpAdapter.SetChangeFontSizeByComplexUnitPixel(_value);
	}
   */

    public void SetFontSizeUnit(int _unit) {
        mSpAdapter.SetFontSizeUnit(_unit);
    }

    //TTextAlignment  = (taLeft, taRight, taTop, taBottom, taCenter, taCenterHorizontal, taCenterVertical);
    
    public void SetTextAlignment(int _alignment) {
        mTextAlignment = _alignment;
        mSpAdapter.SetTextAlignment(mTextAlignment);
    }

    public void SetFontAndTextTypeFace(int _fontFace, int _fontStyle) {
        Typeface t = null;
        switch (_fontFace) {
            case 0: t = Typeface.DEFAULT; break;
            case 1: t = Typeface.SANS_SERIF; break;
            case 2: t = Typeface.SERIF; break;
            case 3: t = Typeface.MONOSPACE; break;
        }
        mSpAdapter.SetFontAndTextTypeFace(t, _fontStyle);
    }
    
    public String GetText() {    	
    	int i = this.getSelectedItemPosition();
    	if (i >= 0) {
      	   mSelectedText = mStrList.get(i).label;
    	}
    	else {
    		mSelectedText = "";
    	}
        return mSelectedText;
    }
    
    public void SetText(int _index) {
    	
    	int i = _index;
    	
    	if (i < 0) i = 0; 		
    	if (mStrList.size() > 0) {    		
     		if ( i >= mStrList.size() ) i = mStrList.size()-1;
    		SetSelection(_index);
    	}		
    }

    public void SetSelection(int _index) {
    	
    	int i = _index;    	
    	if (i < 0) i = 0;     	    	      	    	
    	if (mStrList.size() > 0) {    		
    		if ( i >= mStrList.size() ) i = mStrList.size()-1;    		    		    	
    		setSelection(i);
    	  	mSelectedText = this.getSelectedItem().toString();    		
    	}  
    	
    }
   
    public void SetSelectedIndex(int _index) {
	    int i = _index;    	
    	if (i < 0) i = 0;     	    		
    	if (mStrList.size() > 0) {
    		if ( i >= mStrList.size() ) i = mStrList.size()-1;
    		SetSelection(_index);
    	}
    }

    public int GetSelectedIndex() {
        return this.getSelectedItemPosition();      //or -1   
    }

    public void SetItem(int _index, String _item,  String _strTag) {
    	int i = _index;    	
    	if (i < 0) i = 0;     	    	      	    	
    	if (mStrList.size() > 0) {    		
    		if ( i >= mStrList.size() ) i = mStrList.size()-1;    		    		    	
    		mStrList.set(i, new ItemRow(controls.activity, _item,  _strTag));
    		mSpAdapter.notifyDataSetChanged();
    	}             
    }    

    public void Add(String _item,  String _strTag) {
    	ItemRow info = new ItemRow(controls.activity, _item, _strTag);
        mStrList.add(info);        
        mSpAdapter.notifyDataSetChanged();
    }
      
	public void SetItemTagString(int _index, String _strTag) {
		
	    int i = _index;    	    	
	    if (i < 0) i = 0;    	
    	if (mStrList.size() > 0) {
    		if ( i >= mStrList.size() ) i = mStrList.size()-1;
    		mStrList.get(i).tag = _strTag;
    		mSpAdapter.notifyDataSetChanged();
    	}    					
	}

	public String GetItemTagString(int _index){		
		String s="";		
	    int i = _index;    	    	
	    if (i < 0) i = 0;    	
    	if (mStrList.size() > 0) {
    		if ( i >= mStrList.size() ) i = mStrList.size()-1;
    		s = mStrList.get(i).tag;
    	}		
    	return s;
	}

	public void SetSelectedPaddingTop(int _paddingTop) {	    
	    mSpAdapter.SetSelectedPadTop(_paddingTop);
	}
	
	public void SetSelectedPaddingBottom(int _paddingBottom) {
	    mSpAdapter.SetSelectedPadBottom(_paddingBottom);
	}
	
}  //end class

