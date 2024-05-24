package org.lamw.appfclmysql57connectionbridgedemo1;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import java.util.Locale;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.text.Editable;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnFocusChangeListener;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.Switch;
import android.widget.EditText;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.LinearLayout;

class jListItemRow {
	
	String label = "";
	int    id;
	int widget = 0;   //there is not a widget!
	View jWidget;     //fixed RadioButton Group default behavior: thanks to Leledumbo.
	String widgetText = "";
	int widgetTextColor;
	//int widgetInputType = -1;  //
	
	int savePosition = -1;
	
	String delimiter;	
	String leftDelimiter;
	String rightDelimiter;
	
	boolean checked;
	int textSize;
	int textColor;
	int textColorInfo;
	int highLightColor = Color.TRANSPARENT;
	int textDecorated;
	int textSizeDecorated;
	int itemLayout;
	int textAlign = 0;
	int textPosition=1; //posCenter
	boolean ellipsize = false;

	String tagString="";

	Context ctx;
	Bitmap bmp = null;
	Typeface typeFace;
	
	//TFontFace = (ffNormal, ffSans, ffSerif, ffMonospace);
	
	public  jListItemRow(Context context) {
		ctx = context;
		label = "";
	}
	
}

//http://stackoverflow.com/questions/7361135/how-to-change-color-and-font-on-listview
class jArrayAdapter extends ArrayAdapter {
	//
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private Context       ctx;
	private int           id;

	public List <jListItemRow> items;
	public  ArrayAdapter thisAdapter;

	private boolean mDispatchOnDrawItemTextColor;
	private boolean mDispatchOnDrawItemTextCustomFont;

	private boolean mDrawAllItemPartsTextColor;
	private boolean mDispatchOnDrawItemBitmap;
	private boolean mDispatchOnDrawItemWidgetTextColor;
	private boolean mDispatchOnDrawItemWidgetText;
	private boolean mWidgetInputTypeIsCurrency;
	private boolean mDispatchOnDrawItemWidgetImage;
	
	private int     mMaxLinesFirstString = 0;

	boolean mChangeFontSizeByComplexUnitPixel;
	int mTextSizeTypedValue;
	
    int mItemPaddingTop    = 10;
    int mItemPaddingBottom = 10;
    // by ADiV
    int mItemPaddingLeft   = 10; 
    int mItemPaddingRight  = 10;
    
    int mItemCenterMarginLeft   = 10;
    int mItemCenterMarginRight  = 10;
    int mItemCenterMarginInner  = 2;
    
    boolean mWordWrap;
    boolean mEnableOnClickTextLeft   = false;
    boolean mEnableOnClickTextCenter = false;
    boolean mEnableOnClickTextRight  = false;
    
    boolean mWidgetOnTouch = false;
    
    int mItemImageWidgetSide = 0; // left, right, top, bottom
    
    int mDrawAlphaBackground = 0x57000000; // Alphablending for background default 22%
    // by ADiV
    
    Typeface mWidgetCustomFont = null;

	public ValueFilter customFilter = null;
	public int mFilterMode = 0;
	
	// ADiV Code optimization
	View      itemWidget   = null;
	ImageView itemImage    = null;
	TextView textViewnew   = null;
	TextView itemTextLeft  = null; 
	TextView itemTextRight = null;
	// ADiV Code optimization

	private class ValueFilter extends Filter{

		@Override
		protected FilterResults performFiltering(CharSequence constraint) {
			FilterResults results = new FilterResults();
			// We implement here the filter logic
			if (constraint == null || constraint.length() == 0) {
				// No filter implemented we return all the list
				results.values = null; //origItems;
				results.count = 0;//origItems.size();
			}
			else {
				// We perform filtering operation
				ArrayList<jListItemRow> filteredList = new ArrayList<jListItemRow>();
				for (jListItemRow p : items) {
					if (mFilterMode == 0) {
						if (p.label.toUpperCase(Locale.US).startsWith(constraint.toString().toUpperCase(Locale.US))) {
							filteredList.add(p);
						}
					} else {
						if (p.label.toUpperCase(Locale.US).contains(constraint.toString().toUpperCase(Locale.US))) {
							filteredList.add(p);
						}
					}
				}
				results.values = filteredList;
				results.count = filteredList.size();
			}
			return results;
		}

		@SuppressWarnings("unchecked")
		@Override
		protected void publishResults(CharSequence constraint, FilterResults results) {
			// Now we have to inform the adapter about the new list filtered
			if (results.count == 0) {
				thisAdapter.notifyDataSetInvalidated();
			}
			else {
				items.clear();
				for (jListItemRow p : (ArrayList<jListItemRow>)results.values) {
						items.add(p);
				}
				thisAdapter.notifyDataSetChanged();
			}
		}
	}

	//constructor
	public  jArrayAdapter(Context context, Controls ctrls,long pasobj, int textViewResourceId,
						  List<jListItemRow> list) {
		super(context, textViewResourceId, list);
		PasObj = pasobj;
		controls = ctrls;
		ctx   = context;
		id    = textViewResourceId;
		items = list;
		//origItems = new ArrayList<jListItemRow>();
		thisAdapter = this;
		mDispatchOnDrawItemTextColor = true;
		mDispatchOnDrawItemTextCustomFont = true;

		mDrawAllItemPartsTextColor = true;
		mDispatchOnDrawItemWidgetTextColor = true;
		mDispatchOnDrawItemWidgetText = true;
		mWidgetInputTypeIsCurrency = false;
		mDispatchOnDrawItemWidgetImage = true;
				
		mDrawAllItemPartsTextColor = true;
		mDispatchOnDrawItemBitmap = true;
		mChangeFontSizeByComplexUnitPixel = true;
		mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
		
		mMaxLinesFirstString = 0;
		
		mWordWrap = false;
		
		mEnableOnClickTextLeft   = false;
	    mEnableOnClickTextCenter = false;
	    mEnableOnClickTextRight  = false;
	}

	public void SetChangeFontSizeByComplexUnitPixel(boolean _value) {
		mChangeFontSizeByComplexUnitPixel = _value;
	}

	public void SetFontSizeUnit(int _unit) {
		switch (_unit) {
			case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
			case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break;  //raw pixel :: good experience!
			case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break; //device 
			case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break;
			case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break;  //points
			case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break;  //scaled pixel -- default
		}
	}

	public void SetDispatchOnDrawItemTextColor(boolean _value) {
		mDispatchOnDrawItemTextColor = _value;
	}

	public void SetDispatchOnDrawItemTextCustomFont(boolean _value) {
		mDispatchOnDrawItemTextCustomFont = _value;
	}


	public void SetDispatchOnDrawItemWidgetTextColor(boolean _value) { //+++
		mDispatchOnDrawItemWidgetTextColor = _value;
	}

	public void SetDispatchOnDrawItemWidgetText(boolean _value) { //+++
		mDispatchOnDrawItemWidgetText = _value;
	}
	
	public void SetWidgetInputTypeIsCurrency(boolean _value) { //+++
		mWidgetInputTypeIsCurrency = _value;		
	}

	public void SetDispatchOnDrawItemWidgetImage(boolean _value) { //+++
	   mDispatchOnDrawItemWidgetImage = _value;
	}
	
	public void SetAllPartsOnDrawItemTextColor(boolean _value) {
		mDrawAllItemPartsTextColor = _value;
	}
	
	public void SetMaxLinesFirstString(int _value){
		mMaxLinesFirstString = _value;
	}
	
	public void SetDispatchOnDrawItemBitmap(boolean _value) {
		mDispatchOnDrawItemBitmap = _value;
	}
	
	public void SetItemPaddingTop(int _ItemPaddingTop) { 
	   mItemPaddingTop = _ItemPaddingTop;
	}
		
	public void SetItemPaddingBottom(int _itemPaddingBottom) { 
	   mItemPaddingBottom =  _itemPaddingBottom;
	}
	
	//by ADiV
	public void SetItemPaddingLeft(int _ItemPaddingLeft) { 
		   mItemPaddingLeft = _ItemPaddingLeft;
	}
			
	public void SetItemPaddingRight(int _itemPaddingRight) { 
		   mItemPaddingRight = _itemPaddingRight;
	}
	
	public void SetTextMarginLeft( int _left ){
		mItemCenterMarginLeft   = _left;
	}
	
	public void SetTextMarginRight( int _right ){
		mItemCenterMarginRight  = _right;
	}
	
	public void SetTextMarginInner( int _inner){			   
	    mItemCenterMarginInner  = _inner;
	}
	
	public void SetItemCenterWordWrap2( boolean _value ){ //+++
		mWordWrap = _value;
	}
	
	public void SetEnableOnClickTextLeft2( boolean _value ){ //+++
		mEnableOnClickTextLeft = _value;
	}
		
	public void SetEnableOnClickTextCenter2( boolean _value ){ //+++
		mEnableOnClickTextCenter = _value;
	}

	public void SetEnableOnClickTextRight2( boolean _value ){ //+++
		mEnableOnClickTextRight = _value;
	}
		
	public void SetWidgetImageSide( int _side ){
		mItemImageWidgetSide = _side;
	}
	
	// end by ADiV

    public void SetWidgetFontFromAssets(String _fontName) {			
         mWidgetCustomFont = Typeface.createFromAsset( controls.activity.getAssets(), _fontName);		
    }
    
	//http://stackoverflow.com/questions/11604846/changing-edittexts-text-size-from-pixel-to-scaled-pixels
	public float pixelsToDIP( float px ) {  //Density Independent Pixels
	    DisplayMetrics metrics = ctx.getResources().getDisplayMetrics();
	    float dp = px / ( metrics.densityDpi / 160f );
	    return dp;
	}
	
	//http://stackoverflow.com/questions/14569963/converting-pixel-values-to-mm-android
	public float pixelsToPT(Float px) {  //Scaled Pixels
	    DisplayMetrics metrics = ctx.getResources().getDisplayMetrics();
	    float dp = px / (metrics.xdpi * (1.0f/72) );
	    return dp;
	}

	public float pixelsToIN(Float px) {  //Scaled Pixels		
		//1 inch == 25.4 mm
		//x inch == mm
		float mm = pixelsToMM(px);		
		return (float) (mm/25.4);	  
	}
	
	public float pixelsToMM(Float px) {  //Scaled Pixels
		 final DisplayMetrics dm = ctx.getResources().getDisplayMetrics();
		 return px / TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_MM, 1, dm);		 
	}

	public float pixelsToSP(Float px) {  //Scaled Pixels
	    float scaledDensity = ctx.getResources().getDisplayMetrics().scaledDensity;
	    return px/scaledDensity;
	}
			
	//http://stackoverflow.com/questions/2069810/how-to-assign-text-size-in-sp-value-using-java-code	
	int getPixels(int unit, float size) {   // unit ex: TypedValue.COMPLEX_UNIT_SP or mTextSizeTypedValue
	    DisplayMetrics metrics = ctx.getResources().getDisplayMetrics();
	    return (int)TypedValue.applyDimension(unit, size, metrics);
	}

	public void setFilter(ArrayList<jListItemRow> list, String query) {
        items = list;
        thisAdapter.getFilter().filter((CharSequence) query);
    }

    public void setFilterMode(int mode) {
		mFilterMode = mode;
	}

	@Override
	public Filter getFilter() {
		if (customFilter == null) {
			customFilter = new ValueFilter();
		}
		return (ValueFilter)customFilter;
	}
	
	// ADiV Code optimization
		private int getFaceTitle( int textDecorated ){
			switch ( textDecorated) {
			 case 0:  return Typeface.NORMAL;
			 case 1:  return Typeface.NORMAL;
			 case 2:  return Typeface.NORMAL;

			 case 3:  return Typeface.BOLD;
			 case 4:  return Typeface.BOLD;
			 case 5:  return Typeface.BOLD;

			 case 6:  return Typeface.ITALIC;
			 case 7:  return Typeface.ITALIC;
			 case 8:  return Typeface.ITALIC;

			 default: return Typeface.NORMAL;	
			}
		}
		
		private int getFaceBody( int textDecorated ){
			switch (textDecorated) {
			case 0:  return Typeface.NORMAL; 
			case 1:  return Typeface.ITALIC; 
			case 2:  return Typeface.BOLD; 

			case 3:  return Typeface.BOLD; 
			case 4:  return Typeface.NORMAL; 
			case 5:  return Typeface.ITALIC; 

			case 6:  return Typeface.ITALIC; 
			case 7:  return Typeface.NORMAL; 
			case 8:  return Typeface.ITALIC; 

			default: return Typeface.NORMAL; 
	       }
		}
		
		private void itemDrawImage( int position, int _side ){
			
			if( itemWidget == null ) return;
			
			if (mDispatchOnDrawItemWidgetImage)  {  // +++
				  Bitmap image = controls.pOnListViewDrawItemWidgetImage(PasObj, position, items.get(position).widgetText);						 																
				  Drawable d = new BitmapDrawable(controls.activity.getResources(), image);
				  int h = d.getIntrinsicHeight(); 
				  int w = d.getIntrinsicWidth();
				  
				  d.setBounds( 0, 0, w, h );				  				  
				  
				  // by ADiV fix TextView center
				  if( itemWidget.getClass().getName().equals("android.widget.TextView") )
					  switch(_side) {
					    case 0: case 1: ((TextView)itemWidget).setGravity(Gravity.CENTER_VERTICAL); break; //left, right					    
					    case 2: case 3: ((TextView)itemWidget).setGravity(Gravity.CENTER_HORIZONTAL); //above					    	
					  }
				  				  				  
				  switch(_side) {
				    case 0: ((TextView)itemWidget).setCompoundDrawables(d, null, null, null); break; //left
				    case 1: ((TextView)itemWidget).setCompoundDrawables(null, null, d, null); break; //right
				    case 2: ((TextView)itemWidget).setCompoundDrawables(null, d, null, null); break; //above
				    case 3: ((TextView)itemWidget).setCompoundDrawables(null, null, null, d); 		
				  }
				  
				 
			}
		}
		
		private float setTextSizeAndGetAuxf( int position ){
			
			float auxCustomPixel;
			
			float defaultInPixel = textViewnew.getTextSize();  //default in pixel!!!				
			float result =  pixelsToSP(defaultInPixel);  //just initialize ... pixel to TypedValue.COMPLEX_UNIT_SP
			
			if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_SP) {
			   result =  pixelsToSP(defaultInPixel);   //default in TypedValue.COMPLEX_UNIT_SP!
			   
			   if (items.get(position).textSize != 0) {
				  textViewnew.setTextSize(items.get(position).textSize);					
				  auxCustomPixel = textViewnew.getTextSize();
				  result =  pixelsToSP(auxCustomPixel);  //custom in default in TypedValue.COMPLEX_UNIT_SP!
			   }
			}
							
			if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_PX) {  //in pixel
				   if (items.get(position).textSize != 0) {
					  textViewnew.setTextSize(items.get(position).textSize);					
					  auxCustomPixel = textViewnew.getTextSize();
					  result = auxCustomPixel;  //already in pixel										
				   }
			}
							
			if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_DIP) {
				   result =  pixelsToDIP(defaultInPixel);   //convert pixel to TypedValue.COMPLEX_UNIT_DIP								
				   if (items.get(position).textSize != 0) {
					  textViewnew.setTextSize(items.get(position).textSize);					
					  auxCustomPixel = textViewnew.getTextSize();
					  result =  pixelsToDIP(auxCustomPixel);  //custom in TypedValue.COMPLEX_UNIT_DIP
				   }
			}
											
			if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_MM) {
				   result =  pixelsToMM(defaultInPixel);   //convert pixel to TypedValue.COMPLEX_UNIT_DIP								
				   if (items.get(position).textSize != 0) {
					  textViewnew.setTextSize(items.get(position).textSize);					
					  auxCustomPixel = textViewnew.getTextSize();
					  result =  pixelsToMM(auxCustomPixel);   //custom in TypedValue.COMPLEX_UNIT_DIP
				   }					  					   
			}
			
			if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_PT) {
				   result =  pixelsToPT(defaultInPixel);   //convert pixel to TypedValue.COMPLEX_UNIT_DIP								
				   if (items.get(position).textSize != 0) {
					  textViewnew.setTextSize(items.get(position).textSize);					
					  auxCustomPixel = textViewnew.getTextSize();
					  result =  pixelsToPT(auxCustomPixel);   //custom in TypedValue.COMPLEX_UNIT_DIP
				   }
			}
			
			return result;
		}
		
		private String getItemTextLeft( String line, int position, int faceTitle ){
			
			String result = line;
			String txt1   = "";
			String line1  = "";
			
			itemTextLeft  = null;
			
			int leftSize  = items.get(position).leftDelimiter.length();
			int pos1 = -1;
			pos1     = line.indexOf(items.get(position).leftDelimiter);
			
			if (pos1 >= 0) {							   											    
				   if ( pos1  !=  0) { 
				     txt1   = line.substring(0, pos1);	
				     line1  = line.substring(pos1+leftSize, line.length());
				     result = line1;
				     
				     if ( txt1.length() > 0) {
				       itemTextLeft = new TextView(ctx);  
				       itemTextLeft.setId(controls.getJavaNewId());
				       //itemTextLeft.setPadding(20, 40, 20, 40);
				       itemTextLeft.setPadding(mItemPaddingLeft, mItemPaddingTop, 0, mItemPaddingBottom);
				       
				       itemTextLeft.setText(txt1);
				       
					   if (items.get(position).textColor != 0) 
						 itemTextLeft.setTextColor(items.get(position).textColor);
					   				 
					   itemTextLeft.setTypeface(items.get(position).typeFace, faceTitle);
					   // ADiV fix change font size
					   if (items.get(position).textSize != 0) 
						   itemTextLeft.setTextSize(items.get(position).textSize);
					   					   					  
					   if( mEnableOnClickTextLeft )
					       itemTextLeft.setOnClickListener( getOnClickText(position, 0) );					   					  
					   else
						   itemTextLeft.setClickable(false);
				     }
				   }			 
				   else {
					   result =  line.substring(leftSize, line.length());		
				   }
			}
			
			return result;
		}
		
		private String getItemTextRight( String line, int position, int faceTitle ){
			
			String result = line;
			String txt2   = "";
			String line2  = "";
			
			itemTextRight = null;
			
			int rightSize = items.get(position).rightDelimiter.length();
			int pos2 = -1;			
			pos2 = line.lastIndexOf(items.get(position).rightDelimiter);  //searches right-to-left instead  //rightDelimiter ")"
			
			if (pos2 > 0 ) {				
				if ( pos2 < line.length() ) { 
				   txt2   = line.substring(pos2+rightSize, line.length());
				   line2  = line.substring(0, pos2);				
				   result = line2;
				   
				   if (txt2.length() > 0) { 
				     itemTextRight = new TextView(ctx);
				     itemTextRight.setId(controls.getJavaNewId());
				     //itemTextRight.setPadding(20, 40, 20, 40);
				     itemTextRight.setPadding(0, mItemPaddingTop, mItemPaddingRight, mItemPaddingBottom);
				     itemTextRight.setText(txt2);
				     if (items.get(position).textColor != 0) {
					   itemTextRight.setTextColor(items.get(position).textColor);				
				     }
				     itemTextRight.setTypeface(items.get(position).typeFace, faceTitle);
				     
				     // ADiV fix change font size
					 if (items.get(position).textSize != 0)
						 itemTextRight.setTextSize(items.get(position).textSize);					 					 
					 
					 if( mEnableOnClickTextRight )
					     itemTextRight.setOnClickListener( getOnClickText(position, 2) );
					 else
						 itemTextRight.setClickable(false);
				   }
				}
			}
			
			return result;
		}
		
	private void getItemImage( int position ){
		itemImage = null;
				
		int paddingLeft   = mItemPaddingLeft;
		int paddingRight  = mItemPaddingRight; 
		int paddingTop    = mItemPaddingTop; 
		int paddingBottom = mItemPaddingBottom; 
		
		if (items.get(position).itemLayout == 0) // Pascal layImageTextWidget
			paddingRight = 0;
		else if (items.get(position).itemLayout == 1) // Pascal WidgetTextlayImage
		    paddingLeft  = 0;
		else return; // layText
				
		if (mDispatchOnDrawItemBitmap){  
			Bitmap  imageBmp = (Bitmap)controls.pOnListViewDrawItemBitmap(PasObj, (int)position , items.get(position).label);
			
			if (imageBmp != null){
				itemImage = new ImageView(ctx);
				
			    if(itemImage == null) return;
				
				itemImage.setId(controls.getJavaNewId());
				itemImage.setPadding(paddingLeft, paddingTop, paddingRight, paddingBottom);
				itemImage.setImageBitmap(imageBmp);
				itemImage.setFocusable(false);
				itemImage.setFocusableInTouchMode(false);									
				itemImage.setOnTouchListener(getOnTouchImage(position)); // by ADiV
				
				return;
			}
		}
			
	    if (items.get(position).bmp !=  null) {
					itemImage = new ImageView(ctx);
					
					if(itemImage != null){
					 itemImage.setId(controls.getJavaNewId());
					 itemImage.setPadding(paddingLeft, paddingTop, paddingRight, paddingBottom);
					 itemImage.setImageBitmap(items.get(position).bmp);
					 itemImage.setFocusable(false);
					 itemImage.setFocusableInTouchMode(false);											 
					 itemImage.setOnTouchListener(getOnTouchImage(position)); // by ADiV
					}
		}
			
		
		
	}
	
	// ADiV Code optimization

	@Override
	public  View getView(final int position, View v, ViewGroup parent) {

		if ( (position < 0) || ( position >= items.size() ) ) return v;
            //|| ( items.get(position).label.equals("") )

			final int curPosition = position;
			
			LinearLayout listLayout = new LinearLayout(ctx);

			listLayout.setOrientation(LinearLayout.HORIZONTAL);
			AbsListView.LayoutParams lparam =new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT,
					                                                      AbsListView.LayoutParams.WRAP_CONTENT); //w, h
			listLayout.setLayoutParams(lparam);
			
			RelativeLayout.LayoutParams imgParam = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
			
			RelativeLayout.LayoutParams widgetParam = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h			
					
			RelativeLayout.LayoutParams leftParam = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
			RelativeLayout.LayoutParams rightParam = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
						
			leftParam.leftMargin   = mItemPaddingLeft;			
			rightParam.rightMargin = mItemPaddingRight;
						
			String line = items.get(position).label;			
			
			// ADiV Code optimization
			int faceTitle = getFaceTitle( items.get(position).textDecorated );
			int faceBody  = getFaceBody( items.get(position).textDecorated );
					
			line = getItemTextLeft( line, position, faceTitle );
			line = getItemTextRight( line, position, faceTitle );			
			
			getItemImage( position );
			// ADiV Code optimization
									
			String[] lines = line.split(Pattern.quote(items.get(position).delimiter));
						
			RelativeLayout itemLayout = new RelativeLayout(ctx);			
			
			TextView[] itemText = new TextView[lines.length];				    	
            			
		    LinearLayout txtLayout = new LinearLayout(ctx);			
		    
    		txtLayout.setOrientation(LinearLayout.VERTICAL);
    		    		    		
			for (int i=0; i < lines.length; i++) {

				// ADiV Code optimization
				textViewnew = new TextView(ctx);
								
				float auxf = setTextSizeAndGetAuxf( position );
				// ADiV Code optimization
				
				itemText[i] = textViewnew;				
				itemText[i].setPadding(mItemCenterMarginLeft, mItemPaddingTop, mItemCenterMarginRight, mItemPaddingBottom);
				
				if (lines.length > 1) {				   	
					if (i == 0) {
						if(mMaxLinesFirstString > 0) itemText[i].setMaxLines(mMaxLinesFirstString);
						////left, top, right, bottom
						itemText[i].setPadding(mItemCenterMarginLeft, mItemPaddingTop, mItemCenterMarginRight, mItemCenterMarginInner);						
					}
					else if (i== lines.length-1) { 						
						itemText[i].setPadding(mItemCenterMarginLeft, mItemCenterMarginInner, mItemCenterMarginRight, mItemPaddingBottom);
					}	
					else {
						itemText[i].setPadding(mItemCenterMarginLeft, mItemCenterMarginInner, mItemCenterMarginRight, mItemCenterMarginInner);                           
					}
				}   
				   				
				if (i == 0)										
					itemText[i].setTypeface(items.get(position).typeFace, faceTitle); 				  			
				else
					itemText[i].setTypeface(items.get(position).typeFace, faceBody); 					
				
				if (items.get(position).textSizeDecorated == 1)
							itemText[i].setTextSize(mTextSizeTypedValue, auxf - 3*i);  // sdDeCecreasing				

				if (items.get(position).textSizeDecorated == 2)
						   itemText[i].setTextSize(mTextSizeTypedValue, auxf + 3*i);  // sdInCecreasing						
				
				itemText[i].setText(lines[i]);

				if( i == 0 ){
				 if (items.get(position).textColor != 0) {
					itemText[i].setTextColor(items.get(position).textColor);
				 }
				} else {
					if (items.get(position).textColorInfo != 0) {
						itemText[i].setTextColor(items.get(position).textColorInfo);
					 }	
				}

				if (mDispatchOnDrawItemTextColor)  {
					int drawItemTxtColor = controls.pOnListViewDrawItemCaptionColor(PasObj, (int)position, lines[i]);
					if (drawItemTxtColor != 0) {
						itemText[i].setTextColor(drawItemTxtColor);
						if (mDrawAllItemPartsTextColor) {
							if (itemTextLeft != null) {
								itemTextLeft.setTextColor(drawItemTxtColor);
							}
							if (itemTextRight != null) {
								itemTextRight.setTextColor(drawItemTxtColor);
							}
						}
					}
				}

				if (mDispatchOnDrawItemTextCustomFont)  {
					String _customFontName = controls.pOnListViewDrawItemCustomFont(PasObj, (int)position, lines[i]);
					if (!_customFontName.equals("")) {
						Typeface customfont = Typeface.createFromAsset( controls.activity.getAssets(), _customFontName);
						if (customfont != null) itemText[i].setTypeface(customfont);
					}
				}

				if (items.get(position).textAlign == 2)   //center  ***
				   itemText[i].setGravity(Gravity.CENTER_HORIZONTAL);
				
				if (items.get(position).textAlign == 1)   //right  ***
				   itemText[i].setGravity(Gravity.END);

				if (items.get(position).ellipsize == true) {
					itemText[i].setGravity(Gravity.END);
					itemText[i].setEllipsize(TextUtils.TruncateAt.END);
					itemText[i].setHorizontallyScrolling(false);
					itemText[i].setSingleLine();
				}
								
				if( mEnableOnClickTextCenter )
				    itemText[i].setOnClickListener( getOnClickText(position, 1) );
				else
					itemText[i].setClickable(false);
																							
				txtLayout.addView(itemText[i]);				
				
			}
			
			itemWidget = null;

			switch(items.get(position).widget) {   //0 == there is not a widget!
				case 1:  itemWidget = new CheckBox(ctx);
					((CheckBox)itemWidget).setId(controls.getJavaNewId());

					((CheckBox)itemWidget).setTextColor(controls.activity.getResources().getColor(android.R.color.primary_text_light)); //fixed! thanks to guaracy!
					
					((CheckBox)itemWidget).setPadding(0, mItemPaddingTop, 0, mItemPaddingBottom);

					if (items.get(position).widgetTextColor != 0)
						((CheckBox)itemWidget).setTextColor(items.get(position).widgetTextColor);					

					if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
						int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
						if (drawWidgetTxtColor != 0)
						  ((CheckBox)itemWidget).setTextColor(drawWidgetTxtColor); //drawWidgetTxtColor
					}

					itemDrawImage( position, mItemImageWidgetSide );					
					
					if (mWidgetCustomFont != null)  
					  	   ((CheckBox)itemWidget).setTypeface(mWidgetCustomFont);
					
					if (items.get(position).textSize != 0)
					   ((CheckBox)itemWidget).setTextSize(items.get(position).textSize);					

					((CheckBox)itemWidget).setText(items.get(position).widgetText);

					if (mDispatchOnDrawItemWidgetText)  {  // +++
						String drawWidgetTxt = controls.pOnListViewDrawItemWidgetText(PasObj, (int)position, items.get(position).widgetText);
						if (!drawWidgetTxt.equals("")) {
							((CheckBox) itemWidget).setText(drawWidgetTxt); //drawWidgetTxt
							items.get(position).widgetText = drawWidgetTxt;
						}
					}

					((CheckBox)itemWidget).setChecked(items.get(position).checked);

					items.get(position).jWidget = (CheckBox)itemWidget;

					break;
					
				case 2:  itemWidget = new RadioButton(ctx);
					((RadioButton)itemWidget).setId(controls.getJavaNewId());
					((RadioButton)itemWidget).setTextColor(controls.activity.getResources().getColor(android.R.color.primary_text_light));
					
					((RadioButton)itemWidget).setPadding(0, mItemPaddingTop, 0, mItemPaddingBottom);

					if (items.get(position).widgetTextColor != 0)
						((RadioButton)itemWidget).setTextColor(items.get(position).widgetTextColor);					

					if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
						int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
						if (drawWidgetTxtColor != 0)
						  ((RadioButton)itemWidget).setTextColor(drawWidgetTxtColor);
					}

					itemDrawImage( position, mItemImageWidgetSide );
					
					if (items.get(position).textSize != 0)
					   ((RadioButton)itemWidget).setTextSize(items.get(position).textSize);					
					
					if (mWidgetCustomFont != null)  
					   ((RadioButton)itemWidget).setTypeface(mWidgetCustomFont);
					
					((RadioButton)itemWidget).setText(items.get(position).widgetText);

					if (mDispatchOnDrawItemWidgetText)  {  // +++
						String drawWidgetTxt = controls.pOnListViewDrawItemWidgetText(PasObj, (int)position, items.get(position).widgetText);
						if (!drawWidgetTxt.equals("")) {
							((RadioButton) itemWidget).setText(drawWidgetTxt); //drawWidgetTxtColor
							items.get(position).widgetText = drawWidgetTxt;
						}
					}

					((RadioButton)itemWidget).setChecked(items.get(position).checked);

					items.get(position).jWidget = (RadioButton)itemWidget;

					break;
					
				case 3:  itemWidget = new Button(ctx);
					((Button)itemWidget).setId(controls.getJavaNewId());
					((Button)itemWidget).setTextColor(controls.activity.getResources().getColor(android.R.color.primary_text_light));
					
					((Button)itemWidget).setPadding(0, mItemPaddingTop, 0, mItemPaddingBottom);

					if (items.get(position).widgetTextColor != 0)
						((Button)itemWidget).setTextColor(items.get(position).widgetTextColor);					

					if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
						int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
						if (drawWidgetTxtColor != 0)
						    ((Button)itemWidget).setTextColor(drawWidgetTxtColor);
					}

					itemDrawImage( position, mItemImageWidgetSide );
					
					if (items.get(position).textSize != 0) {
					   ((Button)itemWidget).setTextSize(items.get(position).textSize);
					}
					
					if (mWidgetCustomFont != null)  
					  	   ((Button)itemWidget).setTypeface(mWidgetCustomFont);
					
					((Button)itemWidget).setText(items.get(position).widgetText);

					if (mDispatchOnDrawItemWidgetText)  {  // +++
						String drawWidgetTxt = controls.pOnListViewDrawItemWidgetText(PasObj, (int)position, items.get(position).widgetText);
						if (!drawWidgetTxt.equals("")) {
							((Button) itemWidget).setText(drawWidgetTxt); //drawWidgetTxtColor
							items.get(position).widgetText = drawWidgetTxt;
						}
					}

					items.get(position).jWidget = (Button)itemWidget;
					break;
					
				case 4:  itemWidget = new TextView(ctx);
					((TextView)itemWidget).setId(controls.getJavaNewId());
					((TextView)itemWidget).setTextColor(controls.activity.getResources().getColor(android.R.color.primary_text_light));
					
					((TextView)itemWidget).setPadding(0, mItemPaddingTop, 0, mItemPaddingBottom);
					
					if (items.get(position).widgetTextColor != 0) {
						((TextView)itemWidget).setTextColor(items.get(position).widgetTextColor);
					}

					if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
						int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
						if (drawWidgetTxtColor != 0)
						  ((TextView)itemWidget).setTextColor(drawWidgetTxtColor);
					}

					itemDrawImage( position, mItemImageWidgetSide );
										
					if (items.get(position).textSize != 0)
					   ((TextView)itemWidget).setTextSize(items.get(position).textSize);					
					
					if (mWidgetCustomFont != null)  
					   ((TextView)itemWidget).setTypeface(mWidgetCustomFont);
					
					((TextView)itemWidget).setText(items.get(position).widgetText);

					if (mDispatchOnDrawItemWidgetText)  {  // +++
						String drawWidgetTxt = controls.pOnListViewDrawItemWidgetText(PasObj, (int)position, items.get(position).widgetText);
						if (!drawWidgetTxt.equals("")) {
							((TextView) itemWidget).setText(drawWidgetTxt); //drawWidgetTxtColor
							items.get(position).widgetText = drawWidgetTxt;
						}
					}					
					
					items.get(position).jWidget = (TextView)itemWidget;
					break;

				case 5:  itemWidget = new EditText(ctx);
				 ((EditText)itemWidget).setId(controls.getJavaNewId());
				 ((EditText)itemWidget).setTextColor(controls.activity.getResources().getColor(android.R.color.primary_text_light));

				 if (items.get(position).widgetTextColor != 0) {
					((EditText)itemWidget).setTextColor(items.get(position).widgetTextColor);
				 }

				 ((EditText)itemWidget).setLines(1);
				 ((EditText)itemWidget).setMaxLines(1);
				 ((EditText)itemWidget).setMinLines(1);
				 //((EditText)itemWidget).setPadding(15,4,15,4);
				
				 ((EditText)itemWidget).setPadding(20, mItemPaddingTop, 20, mItemPaddingBottom);

				 if (mWidgetInputTypeIsCurrency) {
					((EditText) itemWidget).setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL | InputType.TYPE_NUMBER_FLAG_SIGNED);
				 }

				 if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
					int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
					if (drawWidgetTxtColor != 0)
					   ((EditText)itemWidget).setTextColor(drawWidgetTxtColor);
				 }

				 itemDrawImage( position, mItemImageWidgetSide );
				
				 if (items.get(position).textSize != 0)
				   ((EditText)itemWidget).setTextSize(items.get(position).textSize);					
				
				 if (mWidgetCustomFont != null)  
				  	   ((EditText)itemWidget).setTypeface(mWidgetCustomFont);
				
				 ((EditText)itemWidget).setText(items.get(position).widgetText);

				 if (mDispatchOnDrawItemWidgetText)  {  // +++
					String drawWidgetTxt = controls.pOnListViewDrawItemWidgetText(PasObj, (int)position, items.get(position).widgetText);
					if (!drawWidgetTxt.equals("")) {
						((EditText) itemWidget).setText(drawWidgetTxt); //drawWidgetTxtColor
						items.get(position).widgetText = drawWidgetTxt;
					}
				 }

				 items.get(position).jWidget = (EditText)itemWidget;

				 ((EditText)itemWidget).setOnFocusChangeListener(new OnFocusChangeListener() {
					public void onFocusChange(View v, boolean hasFocus) {
						int tempId = v.getId();
						int index = -1; // = temp - 6666; //dummy
						final EditText caption = (EditText)v;
						EditText temp = null;

						if (!hasFocus){
							for( int i = 0; i < items.size(); i++) {
								temp = (EditText) items.get(i).jWidget;
								if (temp != null) {
									if (temp.getId() == tempId) { //items.get(i).jWidget
										index = i;
										break;
									}
								}
							}

							if (index >= 0){
								items.get(index).widgetText = caption.getText().toString();								
								items.get(index).jWidget.setFocusable(false);
								items.get(index).jWidget.setFocusableInTouchMode(false);
							    controls.pOnWidgeItemLostFocus(PasObj, index, caption.getText().toString());
							}
						}
					}
				 });

				 ((EditText)itemWidget).addTextChangedListener(new TextWatcher() {
					@Override
					public  void beforeTextChanged(CharSequence s, int start, int count, int after) {
					}
					@Override
					public  void onTextChanged(CharSequence s, int start, int before, int count) {
					}
					@Override
					public  void afterTextChanged(Editable s) {
						items.get(curPosition).widgetText = s.toString();
					}
				 });

				 break;
					
				case 6:  itemWidget = new Switch(ctx);
				 ((Switch)itemWidget).setId(controls.getJavaNewId());

				 ((Switch)itemWidget).setTextColor(controls.activity.getResources().getColor(android.R.color.primary_text_light));
				
				 ((Switch)itemWidget).setPadding(0, mItemPaddingTop, 0, mItemPaddingBottom);

				 if (items.get(position).widgetTextColor != 0)
					((Switch)itemWidget).setTextColor(items.get(position).widgetTextColor);					

				 if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
					int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
					if (drawWidgetTxtColor != 0)
					  ((Switch)itemWidget).setTextColor(drawWidgetTxtColor); //drawWidgetTxtColor
				 }
 
				 itemDrawImage( position, mItemImageWidgetSide );					
				
				 if (mWidgetCustomFont != null)  
				  	   ((Switch)itemWidget).setTypeface(mWidgetCustomFont);
				
				 if (items.get(position).textSize != 0)
				   ((Switch)itemWidget).setTextSize(items.get(position).textSize);					

				 ((Switch)itemWidget).setText(items.get(position).widgetText);

				 if (mDispatchOnDrawItemWidgetText)  {  // +++
					String drawWidgetTxt = controls.pOnListViewDrawItemWidgetText(PasObj, (int)position, items.get(position).widgetText);
					if (!drawWidgetTxt.equals("")) {
						((Switch) itemWidget).setText(drawWidgetTxt); //drawWidgetTxt
						items.get(position).widgetText = drawWidgetTxt;
					}
				 }

				 ((Switch)itemWidget).setChecked(items.get(position).checked);

				 items.get(position).jWidget = (Switch)itemWidget;

				break;
															
			}
				
			if (itemWidget != null) {
				itemWidget.setFocusable(false);
				itemWidget.setFocusableInTouchMode(false);
				
				if( mWidgetOnTouch )
				    itemWidget.setOnTouchListener(getOnTouchWidget(position));
				else
					itemWidget.setOnClickListener(getOnClickWidget(position));
			}
			
		    LayoutParams txtParam = null;
		    
		    if( !mWordWrap && (items.get(position).textAlign != 2) )
			 txtParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h  //layText
		    else
		     txtParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); //w,h  //layText
		    
			txtParam.leftMargin  = mItemPaddingLeft;
			txtParam.rightMargin = mItemPaddingRight;
			
			int relativePosition = RelativeLayout.CENTER_VERTICAL;
			
			switch( items.get(position).textPosition ){
			 case 0: relativePosition = RelativeLayout.ALIGN_PARENT_TOP; break;    // posTop  
			 case 1: relativePosition = RelativeLayout.CENTER_VERTICAL; break;     // posCenter;
			 case 2: relativePosition = RelativeLayout.ALIGN_PARENT_BOTTOM; break; // posBottom;
			}
			
			txtParam.addRule(relativePosition);
			
			if (items.get(position).itemLayout == 0) { // Pascal layImageTextWidget
				
				widgetParam.rightMargin = mItemPaddingRight;				
				
				int flagItemLeft  = 2;
				int flagItemRight = 2;									
				
				if (itemImage != null) {												 
					flagItemLeft = 0;
					txtParam.leftMargin = mItemCenterMarginLeft;
					imgParam.addRule(relativePosition);		
					imgParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);					
					itemLayout.addView(itemImage, imgParam);					
				}
				else {
					if (itemTextLeft != null) {
						flagItemLeft = 1;
						txtParam.leftMargin = mItemCenterMarginLeft;
						leftParam.addRule(relativePosition);							
						leftParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);																
						itemLayout.addView(itemTextLeft, leftParam);					
					}	
				}
													
				if (itemWidget != null) {					
					flagItemRight = 0;
					txtParam.rightMargin = mItemCenterMarginRight;
					widgetParam.addRule(relativePosition);							
					widgetParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);					
					itemLayout.addView(itemWidget, widgetParam);
				}
				else {
					if (itemTextRight != null) {						
						flagItemRight = 1;
						txtParam.rightMargin = mItemCenterMarginRight;
						rightParam.addRule(relativePosition);							
						rightParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);					
						itemLayout.addView(itemTextRight, rightParam);
					}	
				}
				
				
				switch(items.get(position).textAlign) {  //alLeft, alRight, alCenter    --layImageTextWidget				
				  case 0: {
					  if( mWordWrap )
					   switch(flagItemRight) {
					     case 0: txtParam.addRule(RelativeLayout.LEFT_OF, itemWidget.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId()); break;					     	 
					   }
					  
					  switch(flagItemLeft) {  
					     case 0: txtParam.addRule(RelativeLayout.RIGHT_OF, itemImage.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId()); break;
					     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT); break;	  
					  }					    	
					  
					  break;
				  }						  
				  case 1: {
					  if( mWordWrap )
					   switch(flagItemLeft) {  
					     case 0: txtParam.addRule(RelativeLayout.RIGHT_OF, itemImage.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId()); break;					     
					   }
					  
					  switch(flagItemRight) {
					     case 0: txtParam.addRule(RelativeLayout.LEFT_OF, itemWidget.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId()); break;
					     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT); break;	  
					  }					    	
					  break;  	
				  }				  
				  case 2: {
					  
					  if( !mWordWrap ){						  						  
						txtParam.leftMargin = mItemPaddingLeft;
						txtParam.rightMargin = mItemPaddingRight;					    									   
					  } else {
					   switch(flagItemLeft) {
					     case 0: txtParam.addRule(RelativeLayout.RIGHT_OF, itemImage.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId()); break;				     	 
					   }
					   switch(flagItemRight) {
					     case 0: txtParam.addRule(RelativeLayout.LEFT_OF, itemWidget.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId()); break;
					   }
					  }
						
					  txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);				  
				  }
			    }
				
				
				itemLayout.addView(txtLayout, txtParam);				
				
			} else if (items.get(position).itemLayout == 1) {   //Pascal layWidgetTextImage
				
				widgetParam.leftMargin  = mItemPaddingLeft;
				
				int flagItemLeft = 2;
				int flagItemRight = 2;												
				
				if (itemWidget != null) {
					flagItemLeft = 0;					
					txtParam.leftMargin = mItemCenterMarginLeft;
					widgetParam.addRule(relativePosition);										
					leftParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);					
					itemLayout.addView(itemWidget, widgetParam);
				}
				else {
					if (itemTextLeft != null) {
						flagItemLeft = 1;
						txtParam.leftMargin = mItemCenterMarginLeft;
						leftParam.addRule(relativePosition);							
						leftParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);																
						itemLayout.addView(itemTextLeft, leftParam);					
					}					
				}
								
				if (itemImage != null) {    //layWidgetTextImage
					flagItemRight = 0;
					txtParam.rightMargin = mItemCenterMarginRight;
					imgParam.addRule(relativePosition);					
					imgParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
					itemLayout.addView(itemImage, imgParam);				
				}
				else {
					if (itemTextRight != null) {
						flagItemRight = 1;
						txtParam.rightMargin = mItemCenterMarginRight;
						rightParam.addRule(relativePosition);							
						rightParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);					
						itemLayout.addView(itemTextRight, rightParam);						
					}
				}
								
				switch(items.get(position).textAlign) {  //alLeft, alRight, alCenter    --layWidgetTextImage				
				  case 0: {					  
					  
					  if( mWordWrap ) // by ADiV
					   switch(flagItemRight) {
					     case 0: txtParam.addRule(RelativeLayout.LEFT_OF, itemImage.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId()); break;					     	 
					   }
					  
					  switch(flagItemLeft) {
					     case 0: txtParam.addRule(RelativeLayout.RIGHT_OF, itemWidget.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId()); break;
					     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT); break;	  
					  }
					  					  
					  break;
				  }						  
				  case 1: {
					  
					  if( mWordWrap ) // by ADiV 
					   switch(flagItemLeft) {
					     case 0: txtParam.addRule(RelativeLayout.RIGHT_OF, itemWidget.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId()); break;					     	 
					   }
					  
					  switch(flagItemRight) {
					     case 0: txtParam.addRule(RelativeLayout.LEFT_OF, itemImage.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId()); break;
					     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT); break;	  
					  }
					  					  
					  break;  	
				  }
				  
				  case 2: {
					  if( !mWordWrap ){						  
					   txtParam.leftMargin = mItemPaddingLeft;
					   txtParam.rightMargin = mItemPaddingRight;					   
					  } else {
					   switch(flagItemLeft) {
					     case 0: txtParam.addRule(RelativeLayout.RIGHT_OF, itemWidget.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId()); break;					     	 
					   }
					   switch(flagItemRight) {
					     case 0: txtParam.addRule(RelativeLayout.LEFT_OF, itemImage.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId()); break;
					   }
					  }
					  txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);
				  }
			    }
				
				itemLayout.addView(txtLayout, txtParam);
				
			} else if (items.get(position).itemLayout == 2) {  //(2)   Pascal layText	  ---- default				    				
				
				
				if (itemTextLeft != null) {
					txtParam.leftMargin = mItemCenterMarginLeft;
					leftParam.addRule(relativePosition);							
					leftParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);																
					itemLayout.addView(itemTextLeft, leftParam);															
				}
					    						
				if (itemTextRight != null) {
					txtParam.rightMargin = mItemCenterMarginRight;
					rightParam.addRule(relativePosition);							
					rightParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);					
					itemLayout.addView(itemTextRight, rightParam);
				}
																								
				switch(items.get(position).textAlign) {  //alLeft, alRight, alCenter    --layText
				
				  case 0: { // alLeft
					  
					 if(mWordWrap && (itemTextRight != null))
					  txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId());					 					 
					 
					 if(itemTextLeft != null) 
				      txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId());
					 else
				      txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
						  										   					  	 					
					 break;
				  }
				  
				  case 1: { // alRight
					  
					  if( mWordWrap && (itemTextLeft != null) )
					   txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId());
					  
					  if(itemTextRight != null ) 
					   txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId());
					  else
					   txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
					  					   					  	
					  break;
				  }
				  
				  case 2: {	 //alCenter				  
					  					  
					  if( !mWordWrap ){
						   txtParam.leftMargin = mItemPaddingLeft;
						   txtParam.rightMargin = mItemPaddingRight;						   						   						   
					  } else {
						   if(itemTextLeft != null)
						     txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId());
						   else
							 txtParam.leftMargin = mItemPaddingLeft;
						   
						   if(itemTextRight != null)
						     txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId());
						   else
							 txtParam.rightMargin = mItemPaddingRight;
					  }					  					
					
					  txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);
				      				  
			      }
				  
			    }
				
			   itemLayout.addView(txtLayout, txtParam);								
			}
			
			// ADiV add background color to cells
			int drawItemBackColor = controls.pOnListViewDrawItemBackgroundColor(PasObj, (int)position);

			if (drawItemBackColor != Color.TRANSPARENT){
				//itemLayout.setBackgroundColor(drawItemBackColor-mDrawAlphaBackground);
                listLayout.setBackgroundColor(drawItemBackColor-mDrawAlphaBackground);  // <<--- Fixed by jmpessoa!!!
			}
			// ADiV            
            			
			if (items.get(position).highLightColor != Color.TRANSPARENT)
				itemLayout.setBackgroundColor(items.get(position).highLightColor);
						
			listLayout.addView(itemLayout);

			return listLayout;

	}
	
	View.OnTouchListener getOnTouchImage(final int position) {
	  return new View.OnTouchListener() {
		
		boolean mRunning;
    	
    	final Handler handler = new Handler();
    	
        final Runnable runClick = new Runnable(){
            @Override
            public void run()
            {            	
                mRunning = false;
            }
        };
        
        @Override
        public boolean onTouch(View v, MotionEvent event) {
            switch (event.getAction()) {
             case MotionEvent.ACTION_DOWN:{
            	handler.postDelayed(runClick, 300);
                mRunning = true;
                
                break;
             }
             case MotionEvent.ACTION_UP:{
            	if (mRunning)
            		controls.pOnClickImageItem(PasObj, position);
            		
                handler.removeCallbacks(runClick);
                mRunning = false;
                break;
             }                       
             case MotionEvent.ACTION_CANCEL:{
                handler.removeCallbacks(runClick);
                mRunning = false;
                break;
             }
            }		                  
            return true;
        }
                
     };
	}
	
	// by ADiV
	View.OnClickListener getOnClickText(final int position, final int id) {
		return new View.OnClickListener() {
			public void onClick(View v) {
				if (v.getClass().getName().equals("android.widget.TextView")) {
				 switch (id){
				  case 0 : controls.pOnClickItemTextLeft(PasObj, position, ((TextView)v).getText().toString()); break;
				  case 1 : controls.pOnClickItemTextCenter(PasObj, position, ((TextView)v).getText().toString()); break;
				  case 2 : controls.pOnClickItemTextRight(PasObj, position, ((TextView)v).getText().toString()); break;
				 }
				}				
			}
		};
	}
	
	View.OnTouchListener getOnTouchWidget(final int position) {
		  return new View.OnTouchListener() {
			
			boolean mRunning;
	    	
	    	final Handler handler = new Handler();
	    	
	        final Runnable runClick = new Runnable(){
	            @Override
	            public void run()
	            {            	
	                mRunning = false;
	            }
	        };
	        
	        @Override
	        public boolean onTouch(View v, MotionEvent event) {
	            switch (event.getAction()) {
	             case MotionEvent.ACTION_DOWN:{
	            	handler.postDelayed(runClick, 1000);
	                mRunning = true;
	                
	                break;
	             }
	             case MotionEvent.ACTION_UP:{
	            	if (mRunning){
	            		if (v.getClass().getName().equals("android.widget.ImageView")) {
	    					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
	    				}else if (v.getClass().getName().equals("android.widget.CheckBox")) {
	    					items.get(position).checked = !((CheckBox)v).isChecked();
	    					thisAdapter.notifyDataSetChanged();
	    					controls.pOnClickWidgetItem(PasObj, position, ((CheckBox)v).isChecked());
	    				}else if (v.getClass().getName().equals("android.widget.Switch")) {
	    					items.get(position).checked = !((Switch)v).isChecked();
	    					thisAdapter.notifyDataSetChanged();
	    					controls.pOnClickWidgetItem(PasObj, position, ((Switch)v).isChecked());
	    				}else if (v.getClass().getName().equals("android.widget.RadioButton")) {
	    					//new code: fix to RadioButton Group  default behavior: thanks to Leledumbo.
	    					//boolean doCheck = ((RadioButton)v).isChecked(); //new code
	    					
	    					for (int i=0; i < items.size(); i++) {
	    						RadioButton rb = (RadioButton)items.get(i).jWidget;
	    						// by ADiV fix bug
	    						if( rb != null ){
	    						 rb.setChecked(false);
	    						 items.get(i).checked = false;
	    						}						
	    					}

	    					items.get(position).checked = true;
	    					((RadioButton)v).setChecked(true);
	    					// by ADiV, only one call is necessary
	    					thisAdapter.notifyDataSetChanged(); //fix 16-febr-2015
	    					
	    					controls.pOnClickWidgetItem(PasObj, position, true);

	    				}else if (v.getClass().getName().equals("android.widget.Button")) { //button
	    					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
	    				}else if (v.getClass().getName().equals("android.widget.TextView")) { //textview
	    					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
	    				}else if (v.getClass().getName().equals("android.widget.EditText")) { //edittext

	    					if (!v.isFocusable()) {
	    						v.setFocusable(true);
	    						v.setFocusableInTouchMode(true);
	    					}

	    					v.requestFocus();
	    					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
	    				}
	            	}	            	
	            		
	                handler.removeCallbacks(runClick);
	                mRunning = false;
	                break;
	             }                       
	             case MotionEvent.ACTION_CANCEL:{
	                handler.removeCallbacks(runClick);
	                mRunning = false;
	                break;
	             }
	            }		                  
	            return true;
	        }
	     };
		}

	View.OnClickListener getOnClickWidget(final int position) {
		return new View.OnClickListener() {
			public void onClick(View v) {
				if (v.getClass().getName().equals("android.widget.ImageView")) {
					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
				}
				else if (v.getClass().getName().equals("android.widget.CheckBox")) {
					items.get(position).checked = ((CheckBox)v).isChecked();
					controls.pOnClickWidgetItem(PasObj, position, ((CheckBox)v).isChecked());
				}
				else if (v.getClass().getName().equals("android.widget.Switch")) {
					items.get(position).checked = ((Switch)v).isChecked();
					controls.pOnClickWidgetItem(PasObj, position, ((Switch)v).isChecked());
				}
				else if (v.getClass().getName().equals("android.widget.RadioButton")) {
					//new code: fix to RadioButton Group  default behavior: thanks to Leledumbo.
					boolean doCheck = ((RadioButton)v).isChecked(); //new code
					
					for (int i=0; i < items.size(); i++) {
						RadioButton rb = (RadioButton)items.get(i).jWidget;
						// by ADiV fix bug
						if( rb != null ){
						 rb.setChecked(false);
						 items.get(i).checked = false;
						}						
					}

					items.get(position).checked = doCheck;
					((RadioButton)items.get(position).jWidget).setChecked(doCheck);
					// by ADiV, only one call is necessary
					thisAdapter.notifyDataSetChanged(); //fix 16-febr-2015
					
					controls.pOnClickWidgetItem(PasObj, position, doCheck);

				}
				else if (v.getClass().getName().equals("android.widget.Button")) { //button
					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
				}
				else if (v.getClass().getName().equals("android.widget.TextView")) { //textview
					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
				}
				else if (v.getClass().getName().equals("android.widget.EditText")) { //edittext

					if (!v.isFocusable()) {
						v.setFocusable(true);
						v.setFocusableInTouchMode(true);
					}

					v.requestFocus();
					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
				}
			}
		};
	}

}

//-------------------
//jListView
//------------------------

public class jListView extends ListView {
	
	//Java-Pascal Interface
	private long            PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private jCommons LAMWCommon;

	private Bitmap          genericBmp = null;
	private int             widgetItem;
	private String          widgetText;
	private int             widgetTextColor;	
	private int             textColor;
	private int				textColorInfo;
	private int             textSize;
	private Typeface        typeFace = Typeface.DEFAULT;

	//by Renabor
	private float mDownX = -1;
	private float mDownY = -1;
	private final float SCROLL_THRESHOLD = 10;
	private boolean isOnClick;
	private boolean canClick;

	int textDecorated;
	int itemLayout;
	int textSizeDecorated;
	int textAlign = 0;
	int textPosition = 1; //posCenter
	
	String delimiter = "|";
	String leftDelimiter = "(";
	String rightDelimiter = ")";

	private ArrayList<jListItemRow> alist;
	public  ArrayList<jListItemRow> orig_alist;

	private jArrayAdapter  aadapter;

	private OnItemClickListener  onItemClickListener;
	private OnTouchListener onTouchListener;

	boolean highLightSelectedItem = false;
	int highLightColor = Color.TRANSPARENT; //Color.RED;

	int lastSelectedItem = -1;
	int lastLongPressSelectedItem = -1;
	String selectedItemCaption = "";
	
    int mCurrentFirstVisibleItem;
    int mCurrentVisibleItemCount;
    int mTotalItem;

    boolean mDisableScroll = false;

	//Typeface mCustomfont = null;  //TODO

    final ListView mListView = this;

    boolean itemTextEllipsis = false;
	//Constructor
	public  jListView(android.content.Context context,
					  Controls ctrls,long pasobj, int widget, String widgetTxt,  Bitmap bmp,
					  int txtDecorated,
					  int itemLay,
					  int txtSizeDecorated,  int txtAlign, int txtPosition) {
		super(context);

		//Connect Pascal I/F
		
		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);
		PasObj = pasobj;

		textColor = 0; //dummy: default
		widgetTextColor = 0; //dummy: default
		textSize  = 0; //dummy: default

		widgetItem = widget;
		widgetText = widgetTxt;
		genericBmp = bmp;
		textDecorated = txtDecorated;
		itemLayout =itemLay;
		textSizeDecorated = txtSizeDecorated;
		textAlign    = txtAlign;
		textPosition = txtPosition;		
		typeFace = Typeface.DEFAULT;
		
		setBackgroundColor(0x00000000);
		setCacheColorHint(0);

		alist = new ArrayList<jListItemRow>();
		orig_alist = new ArrayList<jListItemRow>();
		//simple_list_item_1
		aadapter = new jArrayAdapter(context, controls, PasObj, android.R.layout.simple_list_item_1, alist);

		setAdapter(aadapter);

		setChoiceMode(ListView.CHOICE_MODE_SINGLE);
		
		setFastScrollEnabled(false); //by Tomash

//fixed! thanks to @renabor
		onItemClickListener = new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView <?> parent, View v, int position, long id) {
					if (!isEmpty(alist)) { // this test is necessary !  //  <----- thanks to @renabor						
						
						if (highLightSelectedItem) {	
							 if (lastSelectedItem != -1) {
							    DoHighlight(lastSelectedItem, Color.TRANSPARENT); //textcolor
							 }			
							 DoHighlight(position,  highLightColor); //							 											
						}
						
						lastSelectedItem = (int) position;						
						
						if (alist.get((int) id).widget == 2  ) { //radio fix 16-febr-2015
							for (int i = 0; i < alist.size(); i++) {
								alist.get(i).checked = false;
							}
							alist.get((int) id).checked = true;
							aadapter.notifyDataSetChanged();
						}

						if (alist.get((int)id).widget == 5  ) { //radio fix 16-febr-2015

							parent.setDescendantFocusability(ViewGroup.FOCUS_BEFORE_DESCENDANTS);
							parent.requestFocus();

							if (!alist.get((int)id).jWidget.isFocusable()) {
								parent.setDescendantFocusability(ViewGroup.FOCUS_AFTER_DESCENDANTS);
							}

						}
						controls.pOnClickCaptionItem(PasObj, (int) id, alist.get((int) id).label);
					}
			}
		};

		setOnItemClickListener(onItemClickListener);		

		this.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
			@Override
		    public boolean onItemLongClick(AdapterView <?> parent, View view, int position, long id) {
			lastLongPressSelectedItem = (int)position;		
			if (!isEmpty(alist)) {  //  <----- thanks to @renabor					
					selectedItemCaption = alist.get((int) id).label;
					controls.pOnListViewLongClickCaptionItem(PasObj, (int)id, alist.get((int)id).label);
					
					return false;
			}		
			return false;
		}
		});
				
		this.setOnScrollListener(new AbsListView.OnScrollListener() {
		    @Override
		    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount){
		    	    mCurrentFirstVisibleItem = firstVisibleItem;
	                mCurrentVisibleItemCount = visibleItemCount;
	                mTotalItem = totalItemCount;
		    }
		    
		    @Override	    
			public void onScrollStateChanged(AbsListView view, int scrollState) { 
				if (scrollState == OnScrollListener.SCROLL_STATE_IDLE) { //end scrolling --- ScrollCompleted
					boolean isLastItem = false;
			      	int lastIndexInScreen = mCurrentVisibleItemCount + mCurrentFirstVisibleItem;
			      	if (lastIndexInScreen>= mTotalItem) {
			      		isLastItem = true;
			        }					
					controls.pOnListViewScrollStateChanged(PasObj, mCurrentFirstVisibleItem,mCurrentVisibleItemCount, mTotalItem, isLastItem);										 
				} 								
			}

		});
					
	}
	
	// by ADiV
	public void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		if( mDisableScroll ){
         int heightMeasureSpec_custom = MeasureSpec.makeMeasureSpec(
                Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);
         super.onMeasure(widthMeasureSpec, heightMeasureSpec_custom);
         ViewGroup.LayoutParams params = getLayoutParams();
         params.height = getMeasuredHeight();
		}else
			super.onMeasure(widthMeasureSpec, heightMeasureSpec);
   }
	
	// by ADiV
	public void SetItemLayout( int _itemlayout ){
		itemLayout = _itemlayout;
		
		aadapter.notifyDataSetChanged();
	}
	
	// by ADiV
	public void SetTextAlign( int _textAlign ){
		textAlign = _textAlign;
		
		aadapter.notifyDataSetChanged();
	}
	
	// by ADiV
	public void DisableScroll( boolean _disable ){
		mDisableScroll = _disable;
	}
	
	// by ADiV
	public void SetFastScrollEnabled(boolean _enable){
		this.setFastScrollEnabled(_enable); 
	}
	
	public  void SetBackgroundByResIdentifier(String _imgResIdentifier) {	   // ..res/drawable  ex. "ic_launcher"		
		this.setBackgroundResource( controls.GetDrawableResourceId(_imgResIdentifier) );			
	}

	//thanks to @renabor
	public static boolean isEmpty(ArrayList<?> coll) {
		return (coll == null || coll.isEmpty());
	}

	public boolean isItemChecked(int index) {
		if( (index < 0) || (index >= alist.size()) ) return false;
		
		return alist.get(index).checked;
	}


	public String GetWidgetText(int index) {
		if( (index < 0) || (index >= alist.size()) ) return "";
		
		return alist.get(index).widgetText;
	}


	public  void setTextColor( int textcolor) {
		this.textColor =textcolor;
	}
	
	public  void SetTextColorInfo( int textcolorinfo) {
		this.textColorInfo = textcolorinfo;
	}
	
	public void setTextSize (int textsize) {
		this.textSize = textsize;
	}

	public void SetFontFace(int fontFace) {
		Typeface t = Typeface.DEFAULT;
		switch (fontFace) {
			case 0: t = Typeface.DEFAULT; break;
			case 1: t = Typeface.SANS_SERIF; break;
			case 2: t = Typeface.SERIF; break;
			case 3: t = Typeface.MONOSPACE; break;
		}
		this.typeFace = t;          //TFontFace = (ffNormal, ffSans, ffSerif, ffMonospace);
		// this.fontTextStyle = fontStyle; // TTextTypeFace = (tfNormal, tfBold, tfItalic, tfBoldItalic);
	}

	//LORDMAN - 2013-08-07
	public void setItemPosition ( int position, int y ) {
		setSelectionFromTop(position, y);
	}

	//
	public  void clear() {
		lastSelectedItem = -1;
		alist.clear();
		orig_alist.clear();  //thanks to JKannes!
		aadapter.notifyDataSetChanged();
	}
	
	// by ADiV
	public void ClearChecked(){
		for( int i = 0; i < alist.size(); i++ ){
			alist.get(i).checked = false;
			this.setItemChecked(i, false);
		}
		
		aadapter.notifyDataSetChanged();
	}
	
	// by ADiV
	public int GetItemsChecked(){
		int count = 0;
		
		for( int i = 0; i < alist.size(); i++ )
		 if( alist.get(i).checked )
			 count++;
		
		return count;			
	}

	//
	public  void delete( int index ) {
		alist.remove(index);
		aadapter.notifyDataSetChanged();
	}

	public  String  getItemText(int index) {
		if( (index < 0) || (index >= alist.size()) ) return "";
		
		return alist.get(index).label;        
	}
	
	// by ADiV
	public void setItemTextByIndex( String _fullItemCaption, int index ) {
		if( (index < 0) || (index >= alist.size()) ) return;
		
		alist.get(index).label = _fullItemCaption;        
	}
	
	public  int GetFontSizeByIndex(int index) {
		if( (index < 0) || (index >= alist.size()) ) return -1;
		
		return alist.get(index).textSize;		
	}

	public int GetSize() {
		return alist.size();
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		alist.clear();
		orig_alist.clear(); //thanks to JKannes!
		genericBmp = null;
		alist    = null;
		setAdapter(null);
		aadapter = null;		
		setOnItemClickListener(null);
		setOnItemLongClickListener(null); //thanks @renabor
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
	
	
	public  void add2(String item, String _delimiter) {
		jListItemRow info = new jListItemRow(controls.activity);
		delimiter = _delimiter;
		info.label = item;
		info.delimiter=  delimiter;
		info.leftDelimiter = leftDelimiter;
		info.rightDelimiter = rightDelimiter; 
		info.id = alist.size();
		info.checked = false;
		info.widget = widgetItem;
		info.widgetText= widgetText;
		info.checked = false;
		info.textSize= textSize;
		info.textColor     = textColor;
		info.textColorInfo = textColorInfo;
		info.widgetTextColor= widgetTextColor;		
		info.bmp = genericBmp;

		info.textDecorated = textDecorated;
		info.itemLayout = itemLayout;
		info.textSizeDecorated = textSizeDecorated;
		info.textAlign    = textAlign;
		info.textPosition = textPosition;
		
		info.typeFace = this.typeFace;
		info.tagString = "";
        info.ellipsize = itemTextEllipsis;

		alist.add(info);
		
		aadapter.notifyDataSetChanged();
	}

	public void Insert(int _index, String item, String _delimiter) {

		int pos = _index;

		if (pos < 0) {
			pos = 0;
		}

		if (pos > alist.size()) {
			pos = alist.size();
		}

		jListItemRow info = new jListItemRow(controls.activity);
		delimiter = _delimiter;
		info.label = item;
		info.delimiter=  delimiter;
		info.leftDelimiter = leftDelimiter;
		info.rightDelimiter = rightDelimiter;
		info.id = alist.size();
		info.checked = false;
		info.widget = widgetItem;
		info.widgetText= widgetText;
		info.checked = false;
		info.textSize= textSize;
		info.textColor     = textColor;
		info.textColorInfo = textColorInfo;
		info.widgetTextColor= widgetTextColor;
		info.bmp = genericBmp;

		info.textDecorated = textDecorated;
		info.itemLayout = itemLayout;
		info.textSizeDecorated = textSizeDecorated;
		info.textAlign    = textAlign;
		info.textPosition = textPosition;

		info.typeFace = this.typeFace;
		info.tagString = "";
		info.ellipsize = itemTextEllipsis;

		alist.add(pos, info);

		aadapter.notifyDataSetChanged();
	}

	public  void add22(String item, String _delimiter, Bitmap bm) {
		jListItemRow info = new jListItemRow(controls.activity);
		delimiter = _delimiter; 
		info.label = item;
		info.delimiter=  delimiter;
		info.leftDelimiter = leftDelimiter;
		info.rightDelimiter = rightDelimiter;		
		info.id = alist.size();
		info.checked = false;
		info.widget = widgetItem;
		info.widgetText= widgetText;
		info.checked = false;
		info.textSize= textSize;
		info.textColor     = textColor;
		info.textColorInfo = textColorInfo;
		info.widgetTextColor= widgetTextColor;
		info.bmp = bm;

		info.textDecorated = textDecorated;
		info.itemLayout =itemLayout;
		info.textSizeDecorated = textSizeDecorated;
		info.textAlign = textAlign;
		info.textPosition = textPosition;
		
		info.typeFace = this.typeFace;
		info.tagString = "";
		info.ellipsize = itemTextEllipsis;

		alist.add(info);
		aadapter.notifyDataSetChanged();
	}

	public  void add3(String item, String _delimiter, int fontColor, int fontSize, int widgetItem, String wgtText, Bitmap img) {
		jListItemRow info = new jListItemRow(controls.activity);
		delimiter = _delimiter;
		info.label = item;
		info.id = alist.size();
		info.checked = false;
		info.widget = widgetItem;
		info.widgetText= wgtText;
		info.checked = false;
		info.delimiter=  delimiter;
		info.leftDelimiter = leftDelimiter;
		info.rightDelimiter = rightDelimiter;		
		info.textSize= fontSize;
		info.textColor     = fontColor;
		info.textColorInfo = fontColor;
		info.bmp = img;

		info.textDecorated = textDecorated;
		info.itemLayout =itemLayout;
		info.textSizeDecorated = textSizeDecorated;
		info.textAlign = textAlign;
		info.textPosition = textPosition;
		
		info.typeFace = this.typeFace;
		//info.fontTextStyle = Typeface.NORMAL;
		info.tagString = "";
		info.ellipsize = itemTextEllipsis;

		alist.add(info);
		aadapter.notifyDataSetChanged();
	}

	
	public  void add4(String item, String _delimiter, int fontColor, int fontSize, int widgetItem, String wgtText) {
		jListItemRow info = new jListItemRow(controls.activity);
		delimiter = _delimiter;
		info.label = item;
		info.id = alist.size();
		info.checked = false;
		info.widget = widgetItem;
		info.widgetText= wgtText;
		info.checked = false;
		info.delimiter=  delimiter;
		info.leftDelimiter = leftDelimiter;
		info.rightDelimiter = rightDelimiter;		
		info.textSize= fontSize;
		info.textColor     = fontColor;
		info.textColorInfo = fontColor;
		info.bmp = null;

		info.textDecorated = textDecorated;
		info.itemLayout =itemLayout;
		info.textSizeDecorated = textSizeDecorated;
		info.textAlign = textAlign;
		info.textPosition = textPosition;
		
		info.typeFace = this.typeFace;
		// info.fontTextStyle = Typeface.NORMAL;
		info.tagString = "";
		info.ellipsize = itemTextEllipsis;

		alist.add(info);
		aadapter.notifyDataSetChanged();
	}

	public void setTextColor2(int value, int index) {
		if( (index < 0) || (index >= alist.size()) ) return;
		
		if (value != 0) {
			alist.get(index).textColor = value;
			aadapter.notifyDataSetChanged();
		}
	}

	public  void setTextSize2(int textsize, int index) {
		if( (index < 0) || (index >= alist.size()) ) return;
		
		if (textsize != 0) {
			alist.get(index).textSize = textsize;
			aadapter.notifyDataSetChanged();
		}
	}
	
	public void SetTextColorInfoByIndex(int value, int index) {
		if( (index < 0) || (index >= alist.size()) ) return;
		
		if (value != 0) {
			alist.get(index).textColorInfo = value;
			aadapter.notifyDataSetChanged();
		}
	}
	
	public void setTextSizeAll(int textsize) {
		if (textsize != 0) {
			this.textSize = textsize;
			
			for( int i = 0; i < alist.size(); i++ )
			 alist.get(i).textSize = textsize;
			
			aadapter.notifyDataSetChanged();
		}
	}

	public  void setImageItem(Bitmap bm, int index) {
		if( (index < 0) || (index >= alist.size()) ) return;
		
		alist.get(index).bmp = bm;
		aadapter.notifyDataSetChanged();
	}

	public  void setImageItem(String imgResIdentifier, int index) {	   // ..res/drawable
		if( (index < 0) || (index >= alist.size()) ) return;
		
		Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(imgResIdentifier));
		
		if( d != null ){
		 alist.get(index).bmp = ((BitmapDrawable)d).getBitmap();		
		 aadapter.notifyDataSetChanged();
		}
	}

	public void SetImageByResIdentifier(String _imageResIdentifier) {
		Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(_imageResIdentifier));
		
		if( d != null )
		 genericBmp = ((BitmapDrawable)d).getBitmap();	
	}
		
	public void setTextDecorated(int value, int index){
		if( (index < 0) || (index >= alist.size()) ) return;
		
		alist.get(index).textDecorated = value;
		aadapter.notifyDataSetChanged();
	}

	public void setTextSizeDecorated(int value, int index) {
		if( (index < 0) || (index >= alist.size()) ) return;
		
		alist.get(index).textSizeDecorated = value;
		aadapter.notifyDataSetChanged();
	}

	public void setItemLayout(int value, int index){
		if( (index < 0) || (index >= alist.size()) ) return;
		
		alist.get(index).itemLayout = value; //0: image-text-widget; 1 = widget-text-image; 2: just text
		aadapter.notifyDataSetChanged();
	}

	public void setWidgetItem(int value, int index){
		if( (index < 0) || (index >= alist.size()) ) return;
		
		alist.get(index).widget = value;
		aadapter.notifyDataSetChanged();
	}

	public void setTextAlign(int value, int index){
		if( (index < 0) || (index >= alist.size()) ) return;
		
		alist.get(index).textAlign = value;
		aadapter.notifyDataSetChanged();
	}
	//by ADiV
	public void setTextPosition(int value, int index){
		if( (index < 0) || (index >= alist.size()) ) return;
		
		alist.get(index).textPosition = value;
		aadapter.notifyDataSetChanged();
	}

	public void setWidgetItem(int value, String txt, int index){
		if( (index < 0) || (index >= alist.size()) ) return;
		
		alist.get(index).widget = value;
		alist.get(index).widgetText = txt;
		aadapter.notifyDataSetChanged();
	}

	public void setWidgetText(String value, int index){
		if( (index < 0) || (index >= alist.size()) ) return;
		
		alist.get(index).widgetText = value;
		aadapter.notifyDataSetChanged();
	}
	
	// ADiV add getChecker for widget
	public boolean getWidgetCheck( int index ){
		if( (index < 0) || (index >= alist.size()) ) return false;
		
		return alist.get(index).checked;
	}
	
	public void SetWidgetOnTouch( boolean _ontouch ){
		aadapter.mWidgetOnTouch = _ontouch;
	}

	public void setWidgetCheck(boolean _value, int _index){
		if( (_index < 0) || (_index >= alist.size()) ) return;
		
		alist.get(_index).checked = _value;
		aadapter.notifyDataSetChanged();		
	}

	public void setItemTagString(String _tagString, int _index){
		if( (_index < 0) || (_index >= alist.size()) ) return;
		
		alist.get(_index).tagString = _tagString;
		aadapter.notifyDataSetChanged();
	}


	public String getItemTagString(int _index){
		if( (_index < 0) || (_index >= alist.size()) ) return "";
		
		return alist.get(_index).tagString;
	}


	private void DoHighlight(int position, int _color) {
		if( (position < 0) || (position >= alist.size()) ) return;
		
		alist.get(position).highLightColor = _color;
		aadapter.notifyDataSetChanged();
	}
	
	// ADiV add refresh
	public void Refresh() {			
		aadapter.notifyDataSetChanged();
	}
	
	public void SetHighLightSelectedItem(boolean _value)  {  //DROPED!!!		
		
		if (highLightColor == Color.TRANSPARENT) highLightColor = Color.parseColor("#e6e6fa"); //lavander
		
		highLightSelectedItem = _value;
	}	

	public void SetHighLightSelectedItemColor(int _color)  {
		highLightColor = _color;
		if (_color != Color.TRANSPARENT) {		   
		   highLightSelectedItem = true;
		}
		else {
			highLightSelectedItem = false;
		}
	}

	public int GetItemIndex() {
		return lastSelectedItem;
	}

	public String GetItemCaption() {
		return selectedItemCaption;
	}


	public void DispatchOnDrawItemTextColor(boolean _value) {
		aadapter.SetDispatchOnDrawItemTextColor(_value);
	}

	public void DispatchOnDrawItemTextCustomFont(boolean _value) {
		aadapter.SetDispatchOnDrawItemTextCustomFont(_value);
	}

	public void DispatchOnDrawItemBitmap(boolean _value) {
		aadapter.SetDispatchOnDrawItemBitmap(_value);
	}

	public void SetChangeFontSizeByComplexUnitPixel(boolean _value) {
		aadapter.SetChangeFontSizeByComplexUnitPixel(_value);
	}

	public void SetFontSizeUnit(int _unit) {
		aadapter.SetFontSizeUnit(_unit);
	}
	
	
  public int getTotalHeight() {
	    int totalHeight = 0;
	    for (int i = 0; i < aadapter.getCount(); i++) {
	        View listItem = aadapter.getView(i, null, this);
	        listItem.measure(0, 0);
	        totalHeight += listItem.getMeasuredHeight();
	    }
		return totalHeight;
   }

   public int getItemHeight(int aItemIndex) {
	    if ( (aItemIndex < aadapter.getCount()) && (aItemIndex>=0) )  {
	      View listItem = aadapter.getView(aItemIndex, null, this);
	      listItem.measure(0, 0);
			  return (int)listItem.getMeasuredHeight();
	    } else
	    {
	      return -1;
	    }

	}
		
	@Override
	protected void dispatchDraw(Canvas canvas) {
		int scrollposition = 0;
		View c = super.getChildAt(0);
		if (c!=null) {
			scrollposition = -c.getTop() + super.getFirstVisiblePosition() * (c.getHeight()+super.getDividerHeight());
		}
		//DO YOUR DRAWING ON UNDER THIS VIEWS CHILDREN
		controls.pOnBeforeDispatchDraw(LAMWCommon.getPasObj(), canvas, scrollposition);  //handle by pascal side
		super.dispatchDraw(canvas);
		//DO YOUR DRAWING ON TOP OF THIS VIEWS CHILDREN
		controls.pOnAfterDispatchDraw(LAMWCommon.getPasObj(), canvas,scrollposition);	 //handle by pascal side
	}
     
	public void SetLeftDelimiter(String _leftDelimiter) {
	  leftDelimiter = _leftDelimiter; //"(";
	}

	public void SetRightDelimiter(String _rightDelimiter) {		  
	  rightDelimiter = _rightDelimiter; //")";
	}
	
public String GetCenterItemCaption(String _fullItemCaption) {
		
		String line = _fullItemCaption;
		String txt1 = "";
		String txt2 = "";
		int pos1 = line.indexOf(leftDelimiter);  //")"									
		if (pos1 >= 0) {							   											    
		    if ( pos1  !=  0) { 
		     txt1 = line.substring(0, pos1);	
		     String line1 =  line.substring(pos1+leftDelimiter.length(), line.length());
		     line = line1;
		   }			 
		   else {
			 line =  line.substring(leftDelimiter.length(), line.length());	
		   }
		}
		                                   
		int pos2 = line.lastIndexOf(rightDelimiter);  //searches right-to-left instead  //rightDelimiter ")"
		if (pos2 > 0 ) {				
			if (pos2 < line.length()) { 
		   	   txt2 = line.substring(pos2+rightDelimiter.length(), line.length());
			   String line2 = line.substring(0, pos2);				
			   line = line2;				
			}
		}
		//String[] lines = line.split(Pattern.quote(delimiter));
		return line;				
	}
    
	public String[] SplitCenterItemCaption(String _centerItemCaption, String _delimiter) {
		String d = _delimiter;
		String[] lines = _centerItemCaption.split(Pattern.quote(d));
		return lines;
	}
	
public String GetLeftItemCaption(String _fullItemCaption) {
		
		String line = _fullItemCaption;
		String txt1 = "";
		String txt2 = "";
		
		int pos1 = line.indexOf(leftDelimiter);  //")"									
		if (pos1 >= 0) {							   											    
		    if ( pos1  !=  0) { 
		     txt1 = line.substring(0, pos1);	
		     String line1 =  line.substring(pos1+leftDelimiter.length(), line.length());
		     line = line1;
		   }			 
		   else {
			 line =  line.substring(leftDelimiter.length(), line.length());	
		   }
		}
		                                   
		int pos2 = line.lastIndexOf(rightDelimiter);  //searches right-to-left instead  //rightDelimiter ")"
		if (pos2 > 0 ) {				
			if (pos2 < line.length()) { 
		   	   txt2 = line.substring(pos2+rightDelimiter.length(), line.length());
			   String line2 = line.substring(0, pos2);				
			   line = line2;				
			}
		}
		return txt1;				
	}
		
	public String GetRightItemCaption(String _fullItemCaption) {
		
		String line = _fullItemCaption;
		String txt1 = "";
		String txt2 = "";
		int pos1 = line.indexOf(leftDelimiter);  //")"									
		if (pos1 >= 0) {							   											    
		    if ( pos1  !=  0) { 
		     txt1 = line.substring(0, pos1);	
		     String line1 =  line.substring(pos1+leftDelimiter.length(), line.length());
		     line = line1;
		   }			 
		   else {
			 line =  line.substring(leftDelimiter.length(), line.length());	
		   }
		}
		                                   
		int pos2 = line.lastIndexOf(rightDelimiter);  //searches right-to-left instead  //rightDelimiter ")"
		if (pos2 > 0 ) {				
			if (pos2 < line.length()) { 
		   	   txt2 = line.substring(pos2+rightDelimiter.length(), line.length());
			   String line2 = line.substring(0, pos2);				
			   line = line2;				
			}
		}
		return txt2;				
	}	
	
	public int GetLongPressSelectedItem(){
		return lastLongPressSelectedItem;
	}
	
	public void SetAllPartsOnDrawItemTextColor(boolean _value) {
		aadapter.SetAllPartsOnDrawItemTextColor(_value);		
	}
	
	public void SetMaxLinesFirstString(int _value) {
		aadapter.SetMaxLinesFirstString(_value);		
	}

	public void SetItemPaddingTop(int _ItemPaddingTop) { 
		aadapter.SetItemPaddingTop( _ItemPaddingTop);
		aadapter.notifyDataSetChanged();
	}
	
	public void SetItemPaddingBottom(int _itemPaddingBottom) { 
		aadapter.SetItemPaddingBottom(_itemPaddingBottom);
		aadapter.notifyDataSetChanged();
	}
	
	// by ADiV	
	public void SetItemPaddingLeft(int _left) { 
		aadapter.SetItemPaddingLeft( _left);
		aadapter.notifyDataSetChanged();
	}
	
	public void SetItemPaddingRight(int _right) { 
		aadapter.SetItemPaddingRight(_right);
		aadapter.notifyDataSetChanged();
	}
	
	public void SetTextMarginLeft( int _left ){
		aadapter.SetTextMarginLeft(_left);
		aadapter.notifyDataSetChanged();
	}
	
	public void SetTextMarginRight( int _right ){
		aadapter.SetTextMarginRight(_right);
		aadapter.notifyDataSetChanged();
	}
	
	public void SetTextMarginInner( int _inner){			   
		aadapter.SetTextMarginInner(_inner);
		aadapter.notifyDataSetChanged();
	}
	
	public void SetWidgetImageSide( int _side ){
		aadapter.SetWidgetImageSide(_side);
		aadapter.notifyDataSetChanged();
	}
	
	public void SetDrawAlphaBackground(int _alpha){
	 int tmpAlpha = _alpha;
	 
	 if( _alpha < 0 )
		 tmpAlpha = 0;
	 else if ( _alpha > 255 )
		 tmpAlpha = 255;
		 	 
	 aadapter.mDrawAlphaBackground = 16777216*tmpAlpha;
	 aadapter.notifyDataSetChanged();
	}
	// by ADiV end

	public void SetDrawItemBackColorAlpha(int _alpha) {
		SetDrawAlphaBackground(_alpha);
	}

	public void SetWidgetTextColor(int _textcolor) {
		this.widgetTextColor = _textcolor; 
	} 
		
	public void SetWidgetFontFromAssets(String _customFontName) {   //   "fonts/font1.ttf"  or  "font1.ttf" 		
        aadapter.SetWidgetFontFromAssets(_customFontName);		
    }

	public void DispatchOnDrawWidgetItemWidgetTextColor(boolean _value) {
	   aadapter.SetDispatchOnDrawItemWidgetTextColor(_value);
	}

	public void DispatchOnDrawWidgetItemWidgetText(boolean _value) {
		aadapter.SetDispatchOnDrawItemWidgetText(_value);
	}

	public void SetWidgetInputTypeIsCurrency(boolean _value) {
		aadapter.SetWidgetInputTypeIsCurrency(_value);
	}
	
	public void DispatchOnDrawItemWidgetImage(boolean _value) {
		aadapter.SetDispatchOnDrawItemWidgetImage(_value);
	}
	
	public void SetItemCenterWordWrap(boolean _value) { // by ADiV
		aadapter.SetItemCenterWordWrap2(_value);
	}
	
	public void SetEnableOnClickTextLeft(boolean _value) { // by ADiV
		aadapter.SetEnableOnClickTextLeft2(_value);
	}
	
	public void SetEnableOnClickTextCenter(boolean _value) { // by ADiV
		aadapter.SetEnableOnClickTextCenter2(_value);
	}
	
	public void SetEnableOnClickTextRight(boolean _value) { // by ADiV
		aadapter.SetEnableOnClickTextRight2(_value);
	}
	
	public void SetSelection(int _index) {
		if( (_index < 0) || (_index >= alist.size()) ) return;
		
		this.setSelection(_index);		
		if (highLightSelectedItem) {	
			 if (lastSelectedItem != -1) {
			    DoHighlight(lastSelectedItem, Color.TRANSPARENT); //textcolor
			 }			
			 DoHighlight(_index,  highLightColor);
			 lastSelectedItem = (int) _index;		
		}			
	}

	/*
	listView.post(new Runnable() {
       @Override
       public void run() {
           listView.smoothScrollToPosition(0);
       }
     }
	 */
    public void SmoothScrollToPosition(int _index) {
        if( (_index < 0) || (_index >= alist.size()) ) return;
        
		this.smoothScrollToPosition(_index);
		if (highLightSelectedItem) {
			 if (lastSelectedItem != -1) {
			    DoHighlight(lastSelectedItem, Color.TRANSPARENT); //textcolor
			 }
			 DoHighlight(_index,  highLightColor);
			 lastSelectedItem = (int) _index;
		}			
	}

	public void SetItemChecked(int _index, boolean _value) {
		if( (_index < 0) || (_index >= alist.size()) ) return;
		
	    this.setItemChecked(_index, _value);
		alist.get(_index).checked = _value;
		
		if (highLightSelectedItem) {	
			 if (lastSelectedItem != -1) {
			    DoHighlight(lastSelectedItem, Color.TRANSPARENT); //textcolor
			 }			
			 if (_value) {
				 DoHighlight(_index,  highLightColor);
				 lastSelectedItem = (int) _index;
			 }
			 else {
				 lastSelectedItem = -1;
			 }
		}					  
	}
			
	public int GetCheckedItemPosition() {
		
		for( int i = 0; i < alist.size(); i++ )
		 if( alist.get(i).checked )
			 return i;
		
		return -1;
	}	

	public void SetFitsSystemWindows(boolean _value) {
		LAMWCommon.setFitsSystemWindows(_value);
	}
	
	   /*
    Change the view's z order in the tree, so it's on top of other sibling views.
    Prior to KITKAT/4.4/Api 19 this method should be followed by calls to requestLayout() and invalidate()
    on the view's parent to force the parent to redraw with the new child ordering.
  */	
	public void BringToFront() {
		this.bringToFront();
		
		LAMWCommon.BringToFront();
		
		this.setVisibility(android.view.View.VISIBLE);
	}
	
	public void SetVisibilityGone() {
		LAMWCommon.setVisibilityGone();
	}

   private File getMyEnvDir(String environmentDir) {
       if (Build.VERSION.SDK_INT <=  29) {
           return Environment.getExternalStoragePublicDirectory(environmentDir);
       }
       else {
           return controls.activity.getExternalFilesDir(environmentDir);
       }
   }
	//TODO
	public String GetEnvironmentDirectoryPath(int _directory) {
		
		File filePath= null;
		String absPath="";   //fail!
		  
		//getMyEnvDir(Environment.DIRECTORY_DOCUMENTS);break; //only Api 19!
		if (_directory != 8) {		  	   	 
		  switch(_directory) {	                       
		    case 0:  filePath = getMyEnvDir(Environment.DIRECTORY_DOWNLOADS); break;	   
		    case 1:  filePath = getMyEnvDir(Environment.DIRECTORY_DCIM); break;
		    case 2:  filePath = getMyEnvDir(Environment.DIRECTORY_MUSIC); break;
		    case 3:  filePath = getMyEnvDir(Environment.DIRECTORY_PICTURES); break;
		    case 4:  filePath = getMyEnvDir(Environment.DIRECTORY_NOTIFICATIONS); break;
		    case 5:  filePath = getMyEnvDir(Environment.DIRECTORY_MOVIES); break;
		    case 6:  filePath = getMyEnvDir(Environment.DIRECTORY_PODCASTS); break;
		    case 7:  filePath = getMyEnvDir(Environment.DIRECTORY_RINGTONES); break;
		    
		    case 9: absPath  = this.controls.activity.getFilesDir().getAbsolutePath(); break;      //Result : /data/data/com/MyApp/files	    	    
		    case 10: absPath = this.controls.activity.getFilesDir().getPath();
		             absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/databases"; break;
		    case 11: absPath = this.controls.activity.getFilesDir().getPath();
	                 absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/shared_prefs"; break;	             
		           
		  }
		  	  
		  //Make sure the directory exists.
	      if (_directory < 8) { 
	    	 filePath.mkdirs();
	    	 absPath= filePath.getPath(); 
	      }	        
	      
		}else {  //== 8 
		    if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) == true) {
		    	filePath = Environment.getExternalStorageDirectory();  //sdcard!
		    	// Make sure the directory exists.
		    	filePath.mkdirs();
		   	    absPath= filePath.getPath();
		    }
		}    	
		    		  
		return absPath;
	}
		
    private void SaveToFile(String _txtContent, String _filename) {	  	 
		     try {
		         OutputStreamWriter outputStreamWriter = new OutputStreamWriter(
		        		 controls.activity.openFileOutput(_filename, Context.MODE_PRIVATE));
		         
		         //outputStreamWriter.write("_header");
		         outputStreamWriter.write(_txtContent);
		         //outputStreamWriter.write("_footer");
		         outputStreamWriter.close();
		     }
		     catch (IOException e) {
		        // Log.i("jTextFileManager", "SaveToFile failed: " + e.toString());
		     }
    }
	
	public void SaveToFile(String _appInternalFileName) {	
		//create StringBuffer object
		 StringBuffer sbf = new StringBuffer();				
		 //StringBuffer contents		 
		 //new line				
		  int count = 	alist.size();
		  for(int i=0; i < count; i++) {
			  sbf.append(alist.get(i).label);
			  sbf.append("\n");
		  }	  		  
		  SaveToFile(sbf.toString(), _appInternalFileName);		  
	}
    	
	public String[] LoadFromFile(String _appInternalFileName) {
		     ArrayList<String> Items = new ArrayList<String>();		     		   
		     try {
		         InputStream inputStream = controls.activity.openFileInput(_appInternalFileName);
		         if ( inputStream != null ) {
		        	 clear();
		             InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
		             BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
		             String receiveString = "";		             
		             while ( (receiveString = bufferedReader.readLine()) != null ) {		             
		            	 Items.add(receiveString);		            	 
		                 add2(receiveString, delimiter);		                
		             }
		             inputStream.close();
		         }
		     }
		     catch (IOException e) {
		        // Log.i("jListView", "LoadFromFile error: " + e.toString());
		     }
		     String sItems[] = Items.toArray(new String[Items.size()]);    	   
		 	 return sItems; 
	}

	public void SetFilterQuery(String _query) {
		
		ClearFilterQuery();//added/fixed [thanks to vags15]!!!
		
		orig_alist.clear();
		for (jListItemRow p : alist) {
			orig_alist.add(p);
		}
		aadapter.setFilter(alist, _query);
	}

	public void SetFilterQuery(String _query, int _filterMode) {
		aadapter.setFilterMode(_filterMode);
		SetFilterQuery(_query);
	}

	public void SetFilterMode(int _filterMode) {
		aadapter.setFilterMode(_filterMode); //0=startsWith ... 1=contains
	}

    public void ClearFilterQuery() {
	    if (orig_alist.size() > 0) {
            alist.clear();
            for (jListItemRow p : orig_alist) {
                alist.add(p);
            }
            aadapter.notifyDataSetChanged();
        }
	}

	//TODO
	/*
	public void SetFontFromAssets(String _fontName) {   //   "fonts/font1.ttf"  or  "font1.ttf"
		 mCustomfont = Typeface.createFromAsset( controls.activity.getAssets(), _fontName);
		//this.setTypeface(customfont);
	}
	*/

	public void SetItemTextEllipsis(boolean _value) {
		itemTextEllipsis = _value;
	}

}
