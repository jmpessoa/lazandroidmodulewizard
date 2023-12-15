package org.monyet.wedus;
 
import java.util.ArrayList;
 
import android.content.Context;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.Typeface;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;
import android.view.Gravity;
 
//-------------------------------------------------------------------------
// jSpinner
// Reviewed by ADiV on 2022/03/28
//-------------------------------------------------------------------------
 
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
 
    public void SetFont(Typeface fontFace) {
        mFontFace = fontFace;
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
 
public class jSpinner extends  Spinner { //androidx.appcompat.widget.AppCompatSpinner
 
    private long       pascalObj = 0;    // Pascal Object
    private Controls   controls  = null; // Control Class for events
 
    private Context context = null;
    private Boolean enabled  = true;           // click-touch enabled!
 
    private ArrayList<String>  mStrList;
    private ArrayList<String>  mTagList;
   
    private CustomSpinnerArrayAdapter<String> mSpAdapter;
    private boolean mLastItemAsPrompt = false;
    private int mTextAlignment;
   
    private String mSelectedText  = "";    
    private int    mSelectedIndex = -1;
 
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
            mSelectedText  = caption;
           
            controls.pOnSpinnerItemSelected(pascalObj,position,caption);
        }
 
        @Override
   /*.*/public void onNothingSelected(AdapterView<?> parent) { }
 
    };
 
    public void SetViewParent(ViewGroup _viewgroup) {
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
 
    public void SetLGravity(int _g) {
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
 
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ..
 
    public int GetSelectedItemPosition() {
        if(mStrList.size() <= 0) return -1;
       
        return mSelectedIndex;    
    }
 
    public String GetSelectedItem() {
        if(mStrList.size() <= 0) return "";
       
        return mSelectedText;
    }
 
    //ELERA_04032015
    public void Clear() {
        mStrList.clear();
        mTagList.clear();
        mSpAdapter.notifyDataSetChanged();
       
        mSelectedText  = "";    
        mSelectedIndex = -1;
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
        if (mStrList.size() <= 0) return;
        if ((_index < 0) || (_index >= mStrList.size())) return;
               
        mStrList.remove(_index);
        mTagList.remove(_index);
                 
        mSpAdapter.notifyDataSetChanged();
    }
   
    public void SetSelection(int _index) {
        if (mStrList.size() <= 0) return;
        if ((_index < 0) || (_index >= mStrList.size())) return;
       
        mSelectedIndex = _index;
        setSelection(_index);                                    
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
 
 
    public void SetFont(String _fontName) {   //   "font/font.ttf"
        Typeface customfont = Typeface.createFromAsset( controls.activity.getAssets(), _fontName);
        mSpAdapter.SetFont(customfont);
    }
 
    public String GetText() {
        if (mStrList.size() <= 0) return "";
       
        return mSelectedText;
    }
   
    public void SetText(int _index) {
        if (mStrList.size() <= 0) return;
       
        SetSelection(_index);
    }
       
    public void SetSelectedIndex(int _index) {
        if (mStrList.size() <= 0) return;
        if ((_index < 0) || (_index >= mStrList.size())) return;
       
        mSelectedIndex = _index;
        setSelection(_index);          
    }
 
    public int GetSelectedIndex() {
        if (mStrList.size() <= 0) return -1;
       
        return mSelectedIndex;      //or -1  
    }
   
   
    public void SetItem(int _index, String _item) {
        if (mStrList.size() <= 0) return;
        if ((_index < 0) || (_index >= mStrList.size())) return;
               
        mStrList.set(_index,_item);
       
        mSpAdapter.notifyDataSetChanged();      
    }
   
    public void SetItem(int _index, String _item,  String _strTag) {
        if (mStrList.size() <= 0) return;
        if ((_index < 0) || (_index >= mStrList.size())) return;
               
        mStrList.set(_index,_item);
        mStrList.set(_index,_strTag);
       
        mSpAdapter.notifyDataSetChanged();          
    }    
   
    public void Add(String _item, String _strTag, boolean runEvent) {
        mStrList.add(_item);
        mTagList.add(_strTag);
        //Log.i("Spinner_Add: ",_item);
        mSpAdapter.notifyDataSetChanged();
       
        if(mSelectedIndex == -1){
                mSelectedIndex = mStrList.size() - 1;
                mSelectedText  = _item;
               
                if( runEvent )
                 controls.pOnSpinnerItemSelected(pascalObj, mSelectedIndex, mSelectedText);
        }
    }    
   
        public void SetItemTagString(int _index, String _strTag) {
                if (mStrList.size() <= 0) return;
        if ((_index < 0) || (_index >= mStrList.size())) return;
                       
        mStrList.set(_index,_strTag);                                                  
        }
 
        public String GetItemTagString(int _index){
                if (mStrList.size() <= 0) return "";
                if ((_index < 0) || (_index >= mStrList.size())) return "";
                                       
        return mTagList.get(_index);
        }    
   
        public void SetSelectedPaddingTop(int _paddingTop) {       
            mSpAdapter.SetSelectedPadTop(_paddingTop);
        }
       
        public void SetSelectedPaddingBottom(int _paddingBottom) {
            mSpAdapter.SetSelectedPadBottom(_paddingBottom);
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
 
   public void SetColorFilter(int _color) {
       this.getBackground().setColorFilter(_color, PorterDuff.Mode.SRC_ATOP);
   }
 
}  //end class
