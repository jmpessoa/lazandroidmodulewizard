package com.example.appspinnerdemo;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.Color;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.TextView;


//by jmpessoa
class CustomSpinnerArrayAdapter<T> extends ArrayAdapter<String>{
	
	Context ctx; 
	private int mTextColor = Color.BLACK;
	private int mTexBackgroundtColor = Color.TRANSPARENT; 
	private int mSelectedTextColor = Color.LTGRAY; 
	private int flag = 0;
	private boolean mLastItemAsPrompt = false;
	private int mTextFontSize = 0;
	int mTextSizeTypedValue;
	
public CustomSpinnerArrayAdapter(Context context, int simpleSpinnerItem, ArrayList<String> alist) {
   super(context, simpleSpinnerItem, alist);
   ctx = context;
   mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
}


public void SetFontSizeUnit(int _unit) {	
	   switch (_unit) {
	      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; 
	      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
	      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; 
	      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; 
	      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; 
	      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 	      
     }   
}
//This method is used to display the dropdown popup that contains data.
	@Override
public View getDropDownView(int position, View convertView, ViewGroup parent)
{
    View view = super.getView(position, convertView, parent);        
    //we know that simple_spinner_item has android.R.id.text1 TextView:         
    TextView text = (TextView)view.findViewById(android.R.id.text1);
    
    text.setPadding(10, 15, 10, 15);      
    text.setTextColor(mTextColor);
               
    if (mTextFontSize != 0) {
  	  
  	  if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
          text.setTextSize(mTextSizeTypedValue, mTextFontSize);
  	  else
  		 text.setTextSize(mTextFontSize);  
    }    
    
    text.setBackgroundColor(mTexBackgroundtColor);
    return view;        
}
		
	//This method is used to return the customized view at specified position in list.
	@Override
	public View getView(int pos, View cnvtView, ViewGroup prnt) {
		
	  View view = super.getView(pos, cnvtView, prnt);	    
	  TextView text = (TextView)view.findViewById(android.R.id.text1);
	       
	  text.setPadding(10, 15, 10, 15); //improve here.... 17-jan-2015	  
    text.setTextColor(mSelectedTextColor);      
    
    if (mTextFontSize != 0) {
  	  
  	  if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
           text.setTextSize(mTextSizeTypedValue, mTextFontSize);
  	  else
   		 text.setTextSize(mTextFontSize);
    }    
    
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
		mTexBackgroundtColor = txtColor;
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
	
}

/*Draft java code by "Lazarus Android Module Wizard" [6/11/2014 22:00:44]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jSpinner extends Spinner /*dummy*/ { //please, fix what GUI object will be extended!

   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events

   private Context context = null;
   private ViewGroup parent  = null;         // parent view
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

   private ArrayList<String>  mStrList;
   private CustomSpinnerArrayAdapter<String> mSpAdapter;
   private boolean mLastItemAsPrompt = false;
   
   //implement action listener type of OnItemSelectedListener
   private OnItemSelectedListener spinnerListener =new OnItemSelectedListener() {
	   
        @Override   
   /*.*/public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {        	
    	     String caption = mStrList.get(position).toString();
	         setSelection(position);	          		            		          		            
    	     controls.pOnSpinnerItemSeleceted(pascalObj,position,caption);              
        }
        
        @Override
   /*.*/public void onNothingSelected(AdapterView<?> parent) {}    
        
   };
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jSpinner(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      
      lparams = new RelativeLayout.LayoutParams(100,100); //lparamW, lparamH
     
      mStrList = new ArrayList<String>();
                  
      mSpAdapter = new CustomSpinnerArrayAdapter<String>(context, android.R.layout.simple_spinner_item,mStrList);
      mSpAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
      setAdapter(mSpAdapter);                  
      setOnItemSelectedListener(spinnerListener);      
   } //end constructor
   
   public void jFree() {
      if (parent != null) { parent.removeView(this); }
      //free local objects...
      mStrList = null; 
      mSpAdapter = null;    
      lparams = null;
      setOnClickListener(null);
   }

   public void SetjParent(ViewGroup _viewgroup) {
      if (parent != null) { parent.removeView(this); }
      parent = _viewgroup;
      _viewgroup.addView(this,lparams);
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

   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }
   
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ..
   
   public int GetSelectedItemPosition() {
      return this.getSelectedItemPosition();
   }
   
   public String GetSelectedItem() {	   
 	 return this.getSelectedItem().toString();	  
   }
  
   public void Add(String _item) {	  	 
	 mStrList.add(_item);    
	 //Log.i("Spinner_Add: ",_item);
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
   
   public void SetSelection(int _index) {
	   if (_index < 0) setSelection(0);
	   else if (_index > (mStrList.size()-1)) setSelection(mStrList.size()-1);
	   else setSelection(_index);	   
   }
   
   public void SetItem(int _index, String _item) {	   
	   if (_index < 0) mStrList.set(0,_item);
	   else if (_index > (mStrList.size()-1)) mStrList.set(mStrList.size()-1,_item);
	   else mStrList.set(_index,_item);	 
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
   
}  //end class

