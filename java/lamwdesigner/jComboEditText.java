package org.lamw.appcomboedittextdemo1;

import java.util.ArrayList;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.text.InputType;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnFocusChangeListener;
import android.view.View.OnKeyListener;
import android.view.View.OnLongClickListener;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Filter;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.view.Gravity;
import android.view.KeyEvent;


class ItemRowAuto {
	String label = "";
	String tag= "";	
	Context ctx;

	public  ItemRowAuto(Context c, String lab, String tg) {
		label = lab;
		tag= tg;
		ctx = c;
	}	
}

class CustomSpinnerArrayAdapterAuto<T> extends ArrayAdapter<ItemRowAuto> {

  Context ctx;
  private int mTextColor = Color.BLACK;
  private int mTexBackgroundColor = Color.TRANSPARENT;
  private int mSelectedTextColor = Color.BLACK;  
  private int mTextFontSize = 0;
  private int mTextSizeTypedValue;

  private int mTextAlignment;
  private Typeface mFontFace;
  private int mFontStyle;
  
  private int mSelectedPadTop = 25;
  private int mSelectedPadBottom = 25;
  
  private ArrayList<ItemRowAuto> items;
  
  private ArrayList<ItemRowAuto> suggestions;
  private ArrayList<ItemRowAuto> itemsAll;
    
  public CustomSpinnerArrayAdapterAuto(Context context, int simpleSpinnerItem, ArrayList<ItemRowAuto> list) {
      super(context, simpleSpinnerItem, list);        
      ctx = context;
      mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
      mTextAlignment = Gravity.CENTER;      
      items = list;
      suggestions = new ArrayList<ItemRowAuto>();      
      itemsAll = new ArrayList<ItemRowAuto>(items); 
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
  
  //This method is used to return the customized view at specified position in list.
  @Override
  public View getView(int position, View convertView, ViewGroup parent) {
     return getLayoutView(position, convertView, parent, mSelectedPadTop, mSelectedPadBottom);    	
  }
  
  private View getLayoutView(int position, View convertView, ViewGroup parent, int padTop, int padBottom) {
  	    	
      if ( position >= 0) {
  		        	
        LinearLayout listLayout = new LinearLayout(ctx);
          
  	    listLayout.setOrientation(LinearLayout.HORIZONTAL);
  		     	    
  		AbsListView.LayoutParams lparam =new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT,
                                                                     AbsListView.LayoutParams.WRAP_CONTENT); //w, h
  		  	    
  		listLayout.setLayoutParams(lparam);
  		
  		RelativeLayout itemLayout = new RelativeLayout(ctx);
  		
  		LinearLayout txtLayout = new LinearLayout(ctx);    		
  		txtLayout.setOrientation(LinearLayout.VERTICAL);	
  		    	    		                                                          		
  		TextView txtview = new TextView(ctx);
  		
  		txtview.setText(items.get(position).label);
  		//txtview.setPadding(20, 40, 20, 40);  		
  		txtview.setPadding(20, padTop, 20, padBottom);  //padTop, padBottom
  		
  		txtview.setTextColor(mTextColor);  		
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
		       case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);					
   	    }
                                        		
	    txtLayout.addView(txtview);
          
        itemLayout.addView(txtLayout, txtParam);
          
        listLayout.addView(itemLayout);                      
          
  		return listLayout;
  		
  	} else return convertView;
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

  public void SetTextFontSize(int txtFontSize) {
      mTextFontSize = txtFontSize;
  }

  public void SetItemPaddingTop(int _top) {
     mSelectedPadTop = _top;
  }
  
  public void SetItemPaddingBottom(int  _bottom) {
     mSelectedPadBottom = _bottom; 
  }
  
  @Override
  public int getCount() { 
     return super.getCount();
  }
  
  @Override
  public Filter getFilter() {
     return mFilter;
  }

  private Filter mFilter = new Filter() {
	  
	    @Override
        public String convertResultToString(Object resultValue) {	    	
	    	ItemRowAuto customer = (ItemRowAuto) resultValue;
	    	return customer.label;	    	
        }
	    
	    //https://akshaymukadam.wordpress.com/2015/02/01/how-to-create-autocompletetextview-using-custom-filter-implementation/
        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            if(constraint != null) {
                suggestions.clear();
                for (ItemRowAuto customer : itemsAll) {   // items
                     //if(customer.label.toLowerCase().startsWith(constraint.toString().toLowerCase())){  //no filter!!! 
                        suggestions.add(customer);              
                     //}
                }
                FilterResults filterResults = new FilterResults();
                filterResults.values = suggestions;
                filterResults.count = suggestions.size();
                return filterResults;
            }
            else {
                return new FilterResults();
            }
        }
        
        //http://www.apnatutorials.com/android/autocompletetextview-custom-array-adapter-with-custom-filter.php?categoryId=2&subCategoryId=53&myPath=android/autocompletetextview-custom-array-adapter-with-custom-filter.php
        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            ArrayList<ItemRowAuto> filteredList = (ArrayList<ItemRowAuto>) results.values;                        
            if(results != null && results.count > 0) {
                clear();
                for (ItemRowAuto c : filteredList) {
                    add(c);
                }
                notifyDataSetChanged();
            }
        }
        
    };
     
}


/*Draft java code by "Lazarus Android Module Wizard" [6/11/2017 23:40:02]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jComboEditText extends AutoCompleteTextView /*dummy*/ { //please, fix what GUI object will be extended!

   private Controls   controls  = null; // Control Class for events
   private jCommons LAMWCommon;

   private Context context = null;
   private ViewGroup parent   = null;         // parent view
 
   private OnClickListener onClickListener;   // click event

   private boolean enabled  = true;           // click-touch enabled!

   private ArrayList<ItemRowAuto> mStrList;
   private CustomSpinnerArrayAdapterAuto<ItemRowAuto> mAdapter; // mSpAdapter;

   private float mTextSize = 0; //default
   private int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

   private ClipboardManager mClipBoard = null;
   private ClipData mClipData = null;
   private int mMaxLines = 1;

   private boolean mCloseSoftInputOnEnter = true;
	
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public jComboEditText(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;
      controls  = _ctrls;
      
      LAMWCommon = new jCommons(this,context,_Self);

      mStrList = new ArrayList<ItemRowAuto>();      
      //simple_dropdown_item_1line   simple_spinner_item
      mAdapter = new CustomSpinnerArrayAdapterAuto<ItemRowAuto> (context, android.R.layout.simple_list_item_1, mStrList);      
      this.setThreshold(1);
      this.setAdapter(mAdapter);

      mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);

      onClickListener = new OnClickListener(){
         /*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!
            if (enabled) {
               controls.pOnClickGeneric(LAMWCommon.getPasObj(), Const.Click_Default); //JNI event onClick!
            }
         };
      };
      
      this.setOnClickListener(onClickListener);

      // when the user clicks an item of the drop-down list
      this.setOnItemClickListener(new OnItemClickListener() {
         @Override
         public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        	 if (!isEmpty(mStrList)) {  
                controls.pOnClickComboDropDownItem(LAMWCommon.getPasObj(), (int)id, mStrList.get((int)id).label);
        	 }
         }
      });

	 setOnFocusChangeListener(new OnFocusChangeListener() {
			public void onFocusChange(View v, boolean hasFocus) {
				final int p = v.getId();
				final AutoCompleteTextView caption = (AutoCompleteTextView)v;
				if (!hasFocus){
					if (p >= 0) {
						controls.pOnLostFocus(LAMWCommon.getPasObj(), caption.getText().toString());
					}
				}
			}
	  });
	 
      this.setOnKeyListener(new OnKeyListener() {
         @Override
         public boolean onKey(View v, int keyCode, KeyEvent event) {
        	// if (event.getAction() == KeyEvent.ACTION_UP) {
               if (keyCode == KeyEvent.KEYCODE_ENTER) {            	 
				 if (mCloseSoftInputOnEnter) {
						InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
						imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
				 }            	 
				 controls.pOnEnter(LAMWCommon.getPasObj());
                 return true;
               }
        	 //}
             return false;
         }
      });
     
      this.setMaxLines(mMaxLines);      
      this.setSingleLine();
            
   } //end constructor

	private boolean isEmpty(ArrayList<?> coll) {
		return (coll == null || coll.isEmpty());
	}
   
   public void jFree() {
      if (parent != null) { parent.removeView(this); }
      //free local objects...
      setOnClickListener(null);
      LAMWCommon.free();
   }

	public long GetPasObj() {
		return LAMWCommon.getPasObj();
	}

	public  void SetViewParent(ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}
	
	public ViewGroup GetParent() {
		return LAMWCommon.getParent();
	}
	
	public void RemoveFromViewParent() {
		LAMWCommon.removeFromViewParent();
	}

	public void SetLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);
	}
		
	public void SetLParamWidth(int w) {
		LAMWCommon.setLParamWidth(w);
	}

	public void SetLParamHeight(int h) {
		LAMWCommon.setLParamHeight(h);
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

	public void SetLWeight(float _w) {
		LAMWCommon.setLWeight(_w);
	}

	public void AddLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);
	}
	
	public void AddLParamsParentRule(int rule) {
		LAMWCommon.addLParamsParentRule(rule);
	}

	public void SetLayoutAll(int idAnchor) {
		LAMWCommon.setLayoutAll(idAnchor);
	}
	
	public void ClearLayoutAll() {		
		LAMWCommon.clearLayoutAll();
	}
	
   public View GetView() {
      return this;
   }
   
   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }

   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   //This method returns the position of the dropdown view selection, if there is one
   public int GetItemIndex() {
      return this.getListSelection();
   }

   public void SetText(String _text) {
      this.setText(_text);
   }

   public String GetText() {
      return this.getText().toString();
   }

   public void Clear() {
      this.setText("");
   }

   //This method displays the drop down on screen.
   public void	ShowDropDown(){
      this.showDropDown();
   }

   public void SetThreshold(int _threshold) {
      this.setThreshold(_threshold);
   }

   public void Add(String _text) {	  	  
	  ItemRowAuto info = new ItemRowAuto(controls.activity, _text, "0");
      mStrList.add(info);               
      mAdapter.notifyDataSetChanged();
   }
   
   public int CountDropDown() {
      return mStrList.size();
   }

   public void ClearAll() {
      this.setText("");
      mStrList.clear();
      mAdapter.notifyDataSetChanged();
   }

   public void ClearDropDown() {
      mStrList.clear();
      mAdapter.notifyDataSetChanged();
   }

   public  void SetTextAlignment( int align ) {
      switch ( align ) {
         case 0 : { setGravity( Gravity.START              ); }; break;
         case 1 : { setGravity( Gravity.END             ); }; break;
         case 2 : { setGravity( Gravity.TOP               ); }; break;
         case 3 : { setGravity( Gravity.BOTTOM            ); }; break;
         case 4 : { setGravity( Gravity.CENTER            ); }; break;
         case 5 : { setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
         case 6 : { setGravity( Gravity.CENTER_VERTICAL   ); }; break;
         default : { setGravity( Gravity.START              ); }; break;
      };
   }

   public void CopyToClipboard() {
      mClipData = ClipData.newPlainText("text", this.getText().toString());
      mClipBoard.setPrimaryClip(mClipData);
   }

   public void PasteFromClipboard() {
      ClipData cdata = mClipBoard.getPrimaryClip();
      ClipData.Item item = cdata.getItemAt(0);
      this.setText(item.getText().toString());
   }

   public void Append(String _text) {
      this.append( _text);
   }

   public void AppendLn(String _text) {
      this.append( _text+ "\n");
   }

   public void AppendTab() {
      this.append("\t");
   }

   public void SetFontAndTextTypeFace(int _fontFace, int _fontStyle) {
      Typeface t = null;
      switch (_fontFace) {
         case 0: t = Typeface.DEFAULT; break;
         case 1: t = Typeface.SANS_SERIF; break;
         case 2: t = Typeface.SERIF; break;
         case 3: t = Typeface.MONOSPACE; break;
      }
      this.setTypeface(t, _fontStyle);
   }

   public void SetTextSize(float _size) {
      mTextSize = _size;
      String t = this.getText().toString();
      this.setTextSize(mTextSizeTypedValue, mTextSize);
      this.setText(t);
   }

   //TTextSizeTypedValue =(tsDefault, tsPixels, tsDIP,tsMillimeters, tsPoints, tsScaledPixel);
   public void SetFontSizeUnit(int _unit) {
      switch (_unit) {
         case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
         case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; 
         case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
         case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; 
         case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; 
         case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 
      }
      String t = this.getText().toString();
      this.setTextSize(mTextSizeTypedValue, mTextSize);
      this.setText(t);
   }
   
	@Override
	protected void dispatchDraw(Canvas canvas) {	 	
	    //DO YOUR DRAWING ON UNDER THIS VIEWS CHILDREN
		//controls.pOnBeforeDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);  //event handle by pascal side		
	    super.dispatchDraw(canvas);	    
	    //DO YOUR DRAWING ON TOP OF THIS VIEWS CHILDREN
	    //controls.pOnAfterDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);	 //event handle by pascal side    
	}   
	
	/*
	public void SetMaxLines(int _maxLines) {
	   mMaxLines = _maxLines;
	   this.setMaxLines(_maxLines);
	}
	*/

    public void Add(String _item,  String _strTag) {
    	ItemRowAuto info = new ItemRowAuto(controls.activity, _item, _strTag);
        mStrList.add(info);        
        mAdapter.notifyDataSetChanged();
    }
    
    public void SetItem(int _index, String _item,  String _strTag) {
    	int i = _index;    	
    	if (i < 0) i = 0;     	    	      	    	
    	if (mStrList.size() > 0) {    		
    		if ( i >= mStrList.size() ) i = mStrList.size()-1;    		    		    	
    		mStrList.set(i, new ItemRowAuto(controls.activity, _item,  _strTag));
    		mAdapter.notifyDataSetChanged();
    	}             
    }    
   
	public void SetItemTagString(int _index, String _strTag) {
		
	    int i = _index;    	    	
	    if (i < 0) i = 0;    	
    	if (mStrList.size() > 0) {
    		if ( i >= mStrList.size() ) i = mStrList.size()-1;
    		mStrList.get(i).tag = _strTag;
    		mAdapter.notifyDataSetChanged();
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
	
    public void Delete(int _index) {
        if (_index < 0) mStrList.remove(0);
        else if (_index > (mStrList.size()-1)) mStrList.remove(mStrList.size()-1);
        else mStrList.remove(_index);
        mAdapter.notifyDataSetChanged();
    }
    
    public void SetDropListTextColor(int _color) {
    	mAdapter.SetTextColor(_color);
    	//mAdapter.notifyDataSetChanged();
    }

    public void SetDropListBackgroundColor(int _color) {
    	mAdapter.SetBackgroundColor(_color);
    	//mAdapter.notifyDataSetChanged();
    }
    
	public void SetItemPaddingTop(int _paddingTop) {	    
		mAdapter.SetItemPaddingTop(_paddingTop);
		//mAdapter.notifyDataSetChanged();
	}
	
	public void SetItemPaddingBottom(int _paddingBottom) {
		mAdapter.SetItemPaddingBottom(_paddingBottom);
		//mAdapter.notifyDataSetChanged();
	}

	public  void ShowSoftInput() {  
		InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.toggleSoftInput(0, InputMethodManager.SHOW_IMPLICIT);
	}


	public  void HideSoftInput() {
		InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(this.getWindowToken(), 0);
	}
	
	public void SetSoftInputOptions(int _imeOption) {
		switch(_imeOption ) {
			case 0: this.setImeOptions(EditorInfo.IME_FLAG_NO_FULLSCREEN); break;
			case 1: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_NONE); break;
			case 2: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_GO); break;
			case 3: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_SEARCH); break;
			case 4: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_SEND); break;
			case 5: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_NEXT); break;
			case 6: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_DONE); break;
			case 7: this.setImeOptions(EditorInfo.IME_MASK_ACTION|EditorInfo.IME_ACTION_PREVIOUS ); break;
			//case 8: this.setImeOptions(EditorInfo.IME_FLAG_FORCE_ASCII); break;  //api >= 16
		}
	}
		
	public void SetFocus() {
		this.requestFocus();
	}

	public void RequestFocus() {
		this.requestFocus();
	}
	
	public void SetCloseSoftInputOnEnter(boolean _closeSoftInput) {
		mCloseSoftInputOnEnter = _closeSoftInput;
	}
	
	public void SetHint(String _hint) {
		this.setHint(_hint);
	}
	

} //end class



