package com.example.appspinnerdemo;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;
import android.view.Gravity;

//by jmpessoa
class CustomSpinnerArrayAdapter<T> extends ArrayAdapter<String>{

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
    
    public CustomSpinnerArrayAdapter(Context context, int simpleSpinnerItem, ArrayList<String> alist) {
        super(context, simpleSpinnerItem, alist);        
        ctx = context;
        mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
        mTextAlignment = Gravity.CENTER;        
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
    public View getDropDownView(int position, View convertView, ViewGroup parent)
    {
    	
        View view = super.getView(position, convertView, parent);

        //we know that simple_spinner_item has android.R.id.text1 TextView:
        //TextView text = (TextView)view.findViewById(android.R.id.text1);

        ((TextView) view).setPadding(20, mSelectedPadTop+15, 20, mSelectedPadBottom+15);  //padTop, padBottom
        ((TextView) view).setTextColor(mTextColor);
        ((TextView) view).setBackgroundColor(mTexBackgroundColor);
        
        if (mTextFontSize != 0) {

            if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
                ((TextView) view).setTextSize(mTextSizeTypedValue, mTextFontSize);
            else
                ((TextView) view).setTextSize(mTextFontSize);
        }
        
        ((TextView) view).setTypeface(mFontFace, mFontStyle);
        ((TextView) view).setGravity(mTextAlignment);
        //((TextView) view).setGravity(Gravity.CENTER);

        return view;
    }

    //This method is used to return the customized view at specified position in list.
    @Override
    public View getView(int pos, View cnvtView, ViewGroup prnt) {

        View view = super.getView(pos, cnvtView, prnt);

        ((TextView)view).setPadding(20, mSelectedPadTop, 20, mSelectedPadBottom+5);        
        ((TextView)view).setTextColor(mSelectedTextColor);        
        ((TextView) view).setBackgroundColor(mTexBackgroundColor);
        
        if (mTextFontSize != 0) {

            if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
                ((TextView) view).setTextSize(mTextSizeTypedValue, mTextFontSize);
            else
                ((TextView) view).setTextSize(mTextFontSize);
        }

        ((TextView)view).setTypeface(mFontFace, mFontStyle);
        ((TextView)view).setGravity(mTextAlignment);
        
        if (mLastItemAsPrompt) flag = 1;

        return view;
    }

    @Override
    public int getCount() {
        if (flag == 1)
            return super.getCount() - 1; //do not show last item
        else return super.getCount();
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

    private ArrayList<String>  mStrList;
    private ArrayList<String>  mTagList;
    
    private CustomSpinnerArrayAdapter<String> mSpAdapter;
    private boolean mLastItemAsPrompt = false;
    private int mTextAlignment;
    
    private String mSelectedText="";
    
    private int mSelectedIndex= -1;

    private int mSelectedPadTop = 15;
    private int mSelectedPadBottom = 5;
    
    private jCommons LAMWCommon;


    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jSpinner(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;
        
        LAMWCommon = new jCommons(this,context,pascalObj);

        mTextAlignment = Gravity.CENTER;
        mStrList = new ArrayList<String>();
        mTagList = new ArrayList<String>();
        mSpAdapter = new CustomSpinnerArrayAdapter<String>(context, android.R.layout.simple_spinner_item, mStrList);

        mSpAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        setAdapter(mSpAdapter);
        setOnItemSelectedListener(spinnerListener);
        
    } //end constructor

    public void jFree() {
        //free local objects...
        mStrList = null;
        mTagList = null;
        setOnItemSelectedListener(null);
        mSpAdapter = null;
        LAMWCommon.free();
    }

    //implement action listener type of OnItemSelectedListener
    private OnItemSelectedListener spinnerListener =new OnItemSelectedListener() {

        @Override   
   /*.*/public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
            ((TextView) parent.getChildAt(0)).setGravity(mTextAlignment); //Gravity.CENTER
            String caption = mStrList.get(position).toString();           
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

    public void SetId(int _id) { //wrapper method pattern ...
        this.setId(_id);
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ..

    public int GetSelectedItemPosition() {
        return this.getSelectedItemPosition();
    }

    public String GetSelectedItem() {
    	mSelectedText = this.getSelectedItem().toString();
        return mSelectedText;
    }

    //ELERA_04032015
    public void Clear() {
        mStrList.clear();
        mTagList.clear();
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
        else if (_index > (mStrList.size()-1)) { 
        	mStrList.remove(mStrList.size()-1);
        	mTagList.remove(mStrList.size()-1);
        }	
        else {
        	 mStrList.remove(_index);
        	 mTagList.remove(_index);
        }	 
        mSpAdapter.notifyDataSetChanged();
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

    
    //TTextAlignment = (alLeft, alCenter, alRight);   //Pascal
    
    public void SetTextAlignment(int _alignment) {
    	        
        switch(_alignment) {
        
        //[ifdef_api14up]
            case 0 : mTextAlignment = android.view.Gravity.START; break;
            case 1 : mTextAlignment = android.view.Gravity.END; break;
        //[endif_api14up]
            
        /* //[endif_api14up]
            case 0 : mTextAlignment = android.view.Gravity.LEFT; break;
            case 1 : mTextAlignment = android.view.Gravity.RIGHT; break;
           //[ifdef_api14up] */
                        
            case 2 : mTextAlignment = android.view.Gravity.CENTER; break;
            
         //[ifdef_api14up]
            default : mTextAlignment = android.view.Gravity.START ; break;
         //[endif_api14up]
         
         /* //[endif_api14up]
            default : mTextAlignment = android.view.Gravity.LEFT; break;
         //[ifdef_api14up] */
            
        }
                
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
    	mSelectedText = this.getSelectedItem().toString();
        return mSelectedText;
    }
    
    public void SetText(int _index) {
    	SetSelection(_index);
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
    
   
    public void SetItem(int _index, String _item) {
    	
        if (_index < 0) mStrList.set(0,_item);
        else if (_index > (mStrList.size()-1)) { 
        	    mStrList.set(mStrList.size()-1,_item);
        }
        else {
        	mStrList.set(_index,_item);
        }
        mSpAdapter.notifyDataSetChanged();
        
    }
    
    public void SetItem(int _index, String _item,  String _strTag) {
    	
        if (_index < 0) mStrList.set(0,_item);
        else if (_index > (mStrList.size()-1)) { 
        	    mStrList.set(mStrList.size()-1,_item);
        	    mTagList.set(mStrList.size()-1,_strTag);
        }
        else {
        	mStrList.set(_index,_item);
        	mStrList.set(_index,_strTag);
        }
        mSpAdapter.notifyDataSetChanged();
            
    }    

    public void Add(String _item) {
        mStrList.add(_item);
        mTagList.add("0");
        //Log.i("Spinner_Add: ",_item);
        mSpAdapter.notifyDataSetChanged();
    }
    
    public void Add(String _item,  String _strTag) {
        mStrList.add(_item);
        mTagList.add(_strTag);
        //Log.i("Spinner_Add: ",_item);
        mSpAdapter.notifyDataSetChanged();

    }
    
	public void SetItemTagString(int _index, String _strTag) {
        if (_index < 0) mTagList.set(0, _strTag);
        else if (_index > (mStrList.size()-1)) { 
        	    mTagList.set(mStrList.size()-1,_strTag);
        }
        else {        	
        	mStrList.set(_index,_strTag);
        }
   					
	}

	public String GetItemTagString(int _index){		
		String s="";
	    int i = _index;    	    	
	    if (i < 0) i = 0;    	
    	if (mTagList.size() > 0) {
    		if ( i >= mTagList.size() ) {
    			i = mStrList.size()-1;
    		}    		
    		s = mTagList.get(i);
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

