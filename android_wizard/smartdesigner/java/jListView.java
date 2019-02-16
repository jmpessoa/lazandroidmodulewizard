package org.lamw.appvideoviewdemo1;

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
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Environment;
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
	String widgetText;
	int widgetTextColor;
	
	int savePosition = -1;
	
	String delimiter;	
	String leftDelimiter;
	String rightDelimiter;
	
	boolean checked;
	int textSize;
	int textColor;
	int highLightColor = Color.TRANSPARENT;
	int textDecorated;
	int textSizeDecorated;
	int itemLayout;
	int textAlign;
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
	private boolean mDrawAllItemPartsTextColor;
	private boolean mDispatchOnDrawItemBitmap;
	private boolean mDispatchOnDrawItemWidgetTextColor;
	private boolean mDispatchOnDrawItemWidgetImage;

	boolean mChangeFontSizeByComplexUnitPixel;
	int mTextSizeTypedValue;
	
    int mItemPaddingTop = 40;
    int mItemPaddingBottom = 40;
    Typeface mWidgetCustomFont = null;

	public ValueFilter customFilter = null;
	public int mFilterMode = 0;

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
						if (p.label.toUpperCase().startsWith(constraint.toString().toUpperCase())) {
							filteredList.add(p);
						}
					} else {
						if (p.label.toUpperCase().contains(constraint.toString().toUpperCase())) {
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
		mDrawAllItemPartsTextColor = true;
		mDispatchOnDrawItemWidgetTextColor = true;
		mDispatchOnDrawItemWidgetImage = true;
				
		mDrawAllItemPartsTextColor = true;
		mDispatchOnDrawItemBitmap = true;
		mChangeFontSizeByComplexUnitPixel = true;
		mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
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
	
	public void SetDispatchOnDrawItemWidgetTextColor(boolean _value) { //+++
		mDispatchOnDrawItemWidgetTextColor = _value;
	}
	
	public void SetDispatchOnDrawItemWidgetImage(boolean _value) { //+++
	   mDispatchOnDrawItemWidgetImage = _value;
	}
	
	public void SetAllPartsOnDrawItemTextColor(boolean _value) {
		mDrawAllItemPartsTextColor = _value;
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

	
	private Drawable GetDrawableResourceById(int _resID) {
		return (Drawable)( ctx.getResources().getDrawable(_resID));
	}
	
	private int GetDrawableResourceId(String _resName) {
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName" ex. "ic_launcher"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     return 0;
		  }
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

	@Override
	public  View getView(int position, View v, ViewGroup parent) {

		if ( (position >= 0)   && ( position < items.size() ) ) {
            //&& ( !items.get(position).label.equals("") )
			LinearLayout listLayout = new LinearLayout(ctx);

			listLayout.setOrientation(LinearLayout.HORIZONTAL);
			AbsListView.LayoutParams lparam =new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT,
					                                                      AbsListView.LayoutParams.WRAP_CONTENT); //w, h
			listLayout.setLayoutParams(lparam);
			
			RelativeLayout.LayoutParams imgParam = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
			imgParam.rightMargin = 10;
			imgParam.leftMargin = 10;
			
			RelativeLayout.LayoutParams widgetParam = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
			widgetParam.rightMargin = 10;
			widgetParam.leftMargin = 10;					

			ImageView itemImage = null;
			
			TextView itemTextLeft = null; 
			TextView itemTextRight = null; 
					
			RelativeLayout.LayoutParams leftParam = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
			RelativeLayout.LayoutParams rightParam = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
			
			leftParam.rightMargin = 10;
			leftParam.leftMargin = 10;			
			rightParam.rightMargin = 10;
			rightParam.leftMargin = 10;											
			
			String txt1 = "";
			String txt2 = "";
			String line1 = "";
			String line2 = "";
			
			String line = items.get(position).label;
			
			int faceTitle;
			int faceBody;
			switch (items.get(position).textDecorated) {
				case 0:  faceTitle = Typeface.NORMAL; faceBody = Typeface.NORMAL; break;
				case 1:  faceTitle = Typeface.NORMAL; faceBody = Typeface.ITALIC; break;
				case 2:  faceTitle = Typeface.NORMAL; faceBody = Typeface.BOLD; break;

				case 3:  faceTitle = Typeface.BOLD; faceBody = Typeface.BOLD; break;
				case 4:  faceTitle = Typeface.BOLD;   faceBody = Typeface.NORMAL; break;
				case 5:  faceTitle = Typeface.BOLD;   faceBody = Typeface.ITALIC; break;

				case 6:  faceTitle = Typeface.ITALIC; faceBody = Typeface.ITALIC; break;
				case 7:  faceTitle = Typeface.ITALIC;   faceBody = Typeface.NORMAL; break;
				case 8:  faceTitle = Typeface.ITALIC;   faceBody = Typeface.ITALIC; break;

				default: faceTitle = Typeface.NORMAL; faceBody = Typeface.NORMAL; break;
			}
			
			int pos1 = -1;
			pos1 = line.indexOf(items.get(position).leftDelimiter);  //")"			
			if (pos1 >= 0) {							   											    
			   if ( pos1  !=  0) { 
			     txt1 = line.substring(0, pos1);	
			     line1 =  line.substring(pos1+1, line.length());
			     line = line1;
			     if ( txt1.length() > 0) {
			       itemTextLeft = new TextView(ctx);  
			       itemTextLeft.setId(position + 1111);
			       //itemTextLeft.setPadding(20, 40, 20, 40);
			       itemTextLeft.setPadding(20, mItemPaddingTop, 20, mItemPaddingBottom);
			       itemTextLeft.setText(txt1);
				   if (items.get(position).textColor != 0) {
					 itemTextLeft.setTextColor(items.get(position).textColor);
				   }				 
				   itemTextLeft.setTypeface(items.get(position).typeFace, faceTitle);
			     }
			   }			 
			   else {
				 line =  line.substring(1, line.length());	
			   }
			}
			                                   
			int pos2 = -1;
			
			pos2 = line.lastIndexOf(items.get(position).rightDelimiter);  //searches right-to-left instead  //rightDelimiter ")"
			
			if (pos2 > 0 ) {				
				if ( pos2 < line.length() ) { 
			   	   txt2 = line.substring(pos2+1, line.length());
				   line2 = line.substring(0, pos2);				
				   line = line2;			
				   if (txt2.length() > 0) { 
				     itemTextRight = new TextView(ctx);
				     itemTextRight.setId(position + 2222);
				     //itemTextRight.setPadding(20, 40, 20, 40);
				     itemTextRight.setPadding(20, mItemPaddingTop, 20, mItemPaddingBottom);
				     itemTextRight.setText(txt2);
				     if (items.get(position).textColor != 0) {
					   itemTextRight.setTextColor(items.get(position).textColor);				
				     }
				     itemTextRight.setTypeface(items.get(position).typeFace, faceTitle);
				   }
				}
			}
									
			String[] lines = line.split(Pattern.quote(items.get(position).delimiter));								
			
			if (items.get(position).bmp !=  null) {
				itemImage = new ImageView(ctx);
				itemImage.setId(position+3333);
				itemImage.setPadding(10, 10, 10, 10);
				itemImage.setImageBitmap(items.get(position).bmp);
				itemImage.setFocusable(false);
				itemImage.setFocusableInTouchMode(false);				
				itemImage.setOnClickListener(getOnCheckItem(itemImage, position));
			}
			
			if (mDispatchOnDrawItemBitmap)  {
				Bitmap  imageBmp = (Bitmap)controls.pOnListViewDrawItemBitmap(PasObj, (int)position , items.get(position).label);
				if (imageBmp != null) {
					itemImage = new ImageView(ctx);
					itemImage.setId(position+4444);
					itemImage.setPadding(10, 10, 10, 10);
					itemImage.setImageBitmap(imageBmp);
					itemImage.setFocusable(false);
					itemImage.setFocusableInTouchMode(false);					
					itemImage.setOnClickListener(getOnCheckItem(itemImage, position));
				}
				else {
					if (items.get(position).bmp !=  null) {
						itemImage = new ImageView(ctx);
						itemImage.setId(position+4444);
						itemImage.setPadding(10, 10, 10, 10);
						itemImage.setImageBitmap(items.get(position).bmp);
						itemImage.setFocusable(false);
						itemImage.setFocusableInTouchMode(false);						
						itemImage.setOnClickListener(getOnCheckItem(itemImage, position));
					}
				}
			}
			else {
				if (items.get(position).bmp !=  null) {
					itemImage = new ImageView(ctx);
					itemImage.setId(position+5555);
					itemImage.setPadding(10, 10, 10, 10);
					itemImage.setImageBitmap(items.get(position).bmp);
					itemImage.setFocusable(false);
					itemImage.setFocusableInTouchMode(false);
					itemImage.setOnClickListener(getOnCheckItem(itemImage, position));
				}
			}

			RelativeLayout itemLayout = new RelativeLayout(ctx);	
			
			TextView[] itemText = new TextView[lines.length];				    	
            			
		    LinearLayout txtLayout = new LinearLayout(ctx);
    		txtLayout.setOrientation(LinearLayout.VERTICAL);
    		    		    		
			for (int i=0; i < lines.length; i++) {

				TextView textViewnew = new TextView(ctx);
				
				float auxCustomPixel;
				
				float defaultInPixel = textViewnew.getTextSize();  //default in pixel!!!				
				float auxf =  pixelsToSP(defaultInPixel);  //just initialize ... pixel to TypedValue.COMPLEX_UNIT_SP
				
				if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_SP) {
				   auxf =  pixelsToSP(defaultInPixel);   //default in TypedValue.COMPLEX_UNIT_SP!									
				   if (items.get(position).textSize != 0) {
					  textViewnew.setTextSize(items.get(position).textSize);					
					  auxCustomPixel = textViewnew.getTextSize();
					  auxf =  pixelsToSP(auxCustomPixel);  //custom in default in TypedValue.COMPLEX_UNIT_SP!
				   }
				}
								
				if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_PX) {  //in pixel
					   if (items.get(position).textSize != 0) {
						  textViewnew.setTextSize(items.get(position).textSize);					
						  auxCustomPixel = textViewnew.getTextSize();
						  auxf = auxCustomPixel;  //already in pixel										
					   }
				}
								
				if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_DIP) {
					   auxf =  pixelsToDIP(defaultInPixel);   //convert pixel to TypedValue.COMPLEX_UNIT_DIP								
					   if (items.get(position).textSize != 0) {
						  textViewnew.setTextSize(items.get(position).textSize);					
						  auxCustomPixel = textViewnew.getTextSize();
						  auxf =  pixelsToDIP(auxCustomPixel);  //custom in TypedValue.COMPLEX_UNIT_DIP
					   }
				}
												
				if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_MM) {
					   auxf =  pixelsToMM(defaultInPixel);   //convert pixel to TypedValue.COMPLEX_UNIT_DIP								
					   if (items.get(position).textSize != 0) {
						  textViewnew.setTextSize(items.get(position).textSize);					
						  auxCustomPixel = textViewnew.getTextSize();
						  auxf =  pixelsToMM(auxCustomPixel);   //custom in TypedValue.COMPLEX_UNIT_DIP
					   }					  					   
				}
				
				if (mTextSizeTypedValue == TypedValue.COMPLEX_UNIT_PT) {
					   auxf =  pixelsToPT(defaultInPixel);   //convert pixel to TypedValue.COMPLEX_UNIT_DIP								
					   if (items.get(position).textSize != 0) {
						  textViewnew.setTextSize(items.get(position).textSize);					
						  auxCustomPixel = textViewnew.getTextSize();
						  auxf =  pixelsToPT(auxCustomPixel);   //custom in TypedValue.COMPLEX_UNIT_DIP
					   }
				}
				
				itemText[i] = textViewnew;
				//itemText[i].setPadding(20, 40, 20, 40);  
				itemText[i].setPadding(20, mItemPaddingTop, 20, mItemPaddingBottom);
				
				if (lines.length > 1) {				   	
					if (i == 0) {
						//itemText[i].setPadding(20, 40, 20, 3);  ////left, top, right, bottom
						itemText[i].setPadding(20, mItemPaddingTop, 20, 2);						
					}
					else if (i== lines.length-1) { 
						//itemText[i].setPadding(20, 3, 20, 40);
						itemText[i].setPadding(20, 2, 20, mItemPaddingBottom);
					}	
					else {
						itemText[i].setPadding(20, 2, 20, 2);                           
					}
				}   
				   				
				if (i == 0) {										
					itemText[i].setTypeface(items.get(position).typeFace, faceTitle); 
				}  				
				else{
					itemText[i].setTypeface(items.get(position).typeFace, faceBody); 
				}	
				
				if (items.get(position).textSizeDecorated == 1) {
							itemText[i].setTextSize(mTextSizeTypedValue, auxf - 3*i);  // sdDeCecreasing
				}

				if (items.get(position).textSizeDecorated == 2) {
						   itemText[i].setTextSize(mTextSizeTypedValue, auxf + 3*i);  // sdInCecreasing
				}			
				
				itemText[i].setText(lines[i]);

				if (items.get(position).textColor != 0) {
					itemText[i].setTextColor(items.get(position).textColor);
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

				if (items.get(position).textAlign == 2) {  //center  ***
				   itemText[i].setGravity(Gravity.CENTER_HORIZONTAL);
				}
															
				txtLayout.addView(itemText[i]);				
			}
			
			View itemWidget = null;

			switch(items.get(position).widget) {   //0 == there is not a widget!
				case 1:  itemWidget = new CheckBox(ctx);
					((CheckBox)itemWidget).setId(position+6666); //dummy

					((CheckBox)itemWidget).setTextColor(controls.activity.getResources().getColor(R.color.primary_text));

					if (items.get(position).widgetTextColor != 0) {
						((CheckBox)itemWidget).setTextColor(items.get(position).widgetTextColor);
					}

					if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
						int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
						if (drawWidgetTxtColor != 0)
						  ((CheckBox)itemWidget).setTextColor(drawWidgetTxtColor); //drawWidgetTxtColor
					}											

					if (mDispatchOnDrawItemWidgetImage)  {  // +++
						  Bitmap image = controls.pOnListViewDrawItemWidgetImage(PasObj, (int)position, items.get(position).widgetText);						 																
						  Drawable d = new BitmapDrawable(controls.activity.getResources(), image);
						  int h = d.getIntrinsicHeight(); 
						  int w = d.getIntrinsicWidth();   
						  d.setBounds( 0, 0, w, h );
						  int _side = 0;
						  switch(_side) {
						    case 0: ((TextView)itemWidget).setCompoundDrawables(d, null, null, null); break; //left
						    case 1: ((TextView)itemWidget).setCompoundDrawables(null, null, d, null);   break;  //right
						    case 2: ((TextView)itemWidget).setCompoundDrawables(null, d, null, null);  break; //above
						    case 3: ((TextView)itemWidget).setCompoundDrawables(null, null, null, d); 		
						  }					
					}					
					
					if (mWidgetCustomFont != null)  
					  	   ((CheckBox)itemWidget).setTypeface(mWidgetCustomFont);
					
					if (items.get(position).textSize != 0) {
					   ((CheckBox)itemWidget).setTextSize(items.get(position).textSize);
					}

					((CheckBox)itemWidget).setText(items.get(position).widgetText);
					((CheckBox)itemWidget).setChecked(items.get(position).checked);

					items.get(position).jWidget = (CheckBox)itemWidget;

					break;
					
				case 2:  itemWidget = new RadioButton(ctx);
					((RadioButton)itemWidget).setId(position+6666);
					((RadioButton)itemWidget).setTextColor(controls.activity.getResources().getColor(R.color.primary_text));

					if (items.get(position).widgetTextColor != 0) {
						((RadioButton)itemWidget).setTextColor(items.get(position).widgetTextColor);
					}

					if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
						int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
						if (drawWidgetTxtColor != 0)
						  ((RadioButton)itemWidget).setTextColor(drawWidgetTxtColor);
					}

					if (mDispatchOnDrawItemWidgetImage)  {  // +++
						  Bitmap image = controls.pOnListViewDrawItemWidgetImage(PasObj, (int)position, items.get(position).widgetText);						 																
						  Drawable d = new BitmapDrawable(controls.activity.getResources(), image);
						  int h = d.getIntrinsicHeight(); 
						  int w = d.getIntrinsicWidth();   
						  d.setBounds( 0, 0, w, h );
						  int _side = 0;
						  switch(_side) {
						    case 0: ((TextView)itemWidget).setCompoundDrawables(d, null, null, null); break; //left
						    case 1: ((TextView)itemWidget).setCompoundDrawables(null, null, d, null);   break;  //right
						    case 2: ((TextView)itemWidget).setCompoundDrawables(null, d, null, null);  break; //above
						    case 3: ((TextView)itemWidget).setCompoundDrawables(null, null, null, d); 		
						  }					
					}
					
					if (items.get(position).textSize != 0) {
					   ((RadioButton)itemWidget).setTextSize(items.get(position).textSize);
					}
					
					if (mWidgetCustomFont != null)  
					  	   ((RadioButton)itemWidget).setTypeface(mWidgetCustomFont);
					
					((RadioButton)itemWidget).setText(items.get(position).widgetText);
					((RadioButton)itemWidget).setChecked(items.get(position).checked);

					items.get(position).jWidget = (RadioButton)itemWidget;

					break;
					
				case 3:  itemWidget = new Button(ctx);
					((Button)itemWidget).setId(position+6666);
					((Button)itemWidget).setTextColor(controls.activity.getResources().getColor(R.color.primary_text));

					if (items.get(position).widgetTextColor != 0) {
						((Button)itemWidget).setTextColor(items.get(position).widgetTextColor);
					}

					if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
						int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
						if (drawWidgetTxtColor != 0)
						    ((Button)itemWidget).setTextColor(drawWidgetTxtColor);
					}											

					if (mDispatchOnDrawItemWidgetImage)  {  // +++
						  Bitmap image = controls.pOnListViewDrawItemWidgetImage(PasObj, (int)position, items.get(position).widgetText);						 																
						  Drawable d = new BitmapDrawable(controls.activity.getResources(), image);
						  int h = d.getIntrinsicHeight(); 
						  int w = d.getIntrinsicWidth();   
						  d.setBounds( 0, 0, w, h );
						  int _side = 0;
						  switch(_side) {
						    case 0: ((TextView)itemWidget).setCompoundDrawables(d, null, null, null); break; //left
						    case 1: ((TextView)itemWidget).setCompoundDrawables(null, null, d, null);   break;  //right
						    case 2: ((TextView)itemWidget).setCompoundDrawables(null, d, null, null);  break; //above
						    case 3: ((TextView)itemWidget).setCompoundDrawables(null, null, null, d); 		
						  }					
					}
					
					if (items.get(position).textSize != 0) {
					   ((Button)itemWidget).setTextSize(items.get(position).textSize);
					}
					
					if (mWidgetCustomFont != null)  
					  	   ((Button)itemWidget).setTypeface(mWidgetCustomFont);
					
					((Button)itemWidget).setText(items.get(position).widgetText);
					
					items.get(position).jWidget = (Button)itemWidget;
					break;
					
				case 4:  itemWidget = new TextView(ctx);
					((TextView)itemWidget).setId(position+6666);
					((TextView)itemWidget).setTextColor(controls.activity.getResources().getColor(R.color.primary_text));

					if (items.get(position).widgetTextColor != 0) {
						((TextView)itemWidget).setTextColor(items.get(position).widgetTextColor);
					}

					if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
						int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
						if (drawWidgetTxtColor != 0)
						  ((TextView)itemWidget).setTextColor(drawWidgetTxtColor);
					}											

					if (mDispatchOnDrawItemWidgetImage)  {  // +++
						  Bitmap image = controls.pOnListViewDrawItemWidgetImage(PasObj, (int)position, items.get(position).widgetText);						 																
						  Drawable d = new BitmapDrawable(controls.activity.getResources(), image);
						  int h = d.getIntrinsicHeight(); 
						  int w = d.getIntrinsicWidth();   
						  d.setBounds( 0, 0, w, h );
						  int _side = 0;
						  switch(_side) {
						    case 0: ((TextView)itemWidget).setCompoundDrawables(d, null, null, null); break; //left
						    case 1: ((TextView)itemWidget).setCompoundDrawables(null, null, d, null);   break;  //right
						    case 2: ((TextView)itemWidget).setCompoundDrawables(null, d, null, null);  break; //above
						    case 3: ((TextView)itemWidget).setCompoundDrawables(null, null, null, d); 		
						  }					
					}					
					
					if (items.get(position).textSize != 0) {
					   ((TextView)itemWidget).setTextSize(items.get(position).textSize);
					}
					
					if (mWidgetCustomFont != null)  
					  	   ((TextView)itemWidget).setTypeface(mWidgetCustomFont);
					
					((TextView)itemWidget).setText(items.get(position).widgetText);					
                      
					/*
					int id = GetDrawableResourceId("ic_launcher");
					Drawable d = GetDrawableResourceById(id);  		
					int h = d.getIntrinsicHeight(); 
					int w = d.getIntrinsicWidth();   
					d.setBounds( 0, 0, w, h );	
					int _side = 0;
					
					switch(_side) {
					  case 0: ((TextView)itemWidget).setCompoundDrawables(d, null, null, null); break; //left
					  case 1: ((TextView)itemWidget).setCompoundDrawables(null, null, d, null);   break;  //right
					  case 2: ((TextView)itemWidget).setCompoundDrawables(null, d, null, null);  break; //above
					  case 3: ((TextView)itemWidget).setCompoundDrawables(null, null, null, d); 		
					}					
					*/
					
					items.get(position).jWidget = (TextView)itemWidget;
					break;

				case 5:  itemWidget = new EditText(ctx);
					((EditText)itemWidget).setId(position+6666);
					((EditText)itemWidget).setTextColor(controls.activity.getResources().getColor(R.color.primary_text));

					if (items.get(position).widgetTextColor != 0) {
						((EditText)itemWidget).setTextColor(items.get(position).widgetTextColor);
					}

					((EditText)itemWidget).setLines(1);
					((EditText)itemWidget).setMaxLines(1);
					((EditText)itemWidget).setMinLines(1);
										
					if (mDispatchOnDrawItemWidgetTextColor)  {  // +++
						int drawWidgetTxtColor = controls.pOnListViewDrawItemWidgetTextColor(PasObj, (int)position, items.get(position).widgetText);
						if (drawWidgetTxtColor != 0)
						   ((EditText)itemWidget).setTextColor(drawWidgetTxtColor);
					}

					if (mDispatchOnDrawItemWidgetImage)  {  // +++
						  Bitmap image = controls.pOnListViewDrawItemWidgetImage(PasObj, (int)position, items.get(position).widgetText);						 																
						  Drawable d = new BitmapDrawable(controls.activity.getResources(), image);
						  int h = d.getIntrinsicHeight(); 
						  int w = d.getIntrinsicWidth();   
						  d.setBounds( 0, 0, w, h );
						  int _side = 0;
						  switch(_side) {
						    case 0: ((TextView)itemWidget).setCompoundDrawables(d, null, null, null); break; //left
						    case 1: ((TextView)itemWidget).setCompoundDrawables(null, null, d, null);   break;  //right
						    case 2: ((TextView)itemWidget).setCompoundDrawables(null, d, null, null);  break; //above
						    case 3: ((TextView)itemWidget).setCompoundDrawables(null, null, null, d); 		
						  }					
					}
					
					if (items.get(position).textSize != 0) {
					   ((EditText)itemWidget).setTextSize(items.get(position).textSize);
					}
					
					if (mWidgetCustomFont != null)  
					  	   ((EditText)itemWidget).setTypeface(mWidgetCustomFont);
					
					((EditText)itemWidget).setText(items.get(position).widgetText);					
					
					items.get(position).jWidget = (EditText)itemWidget;

					((EditText)itemWidget).setOnFocusChangeListener(new OnFocusChangeListener() {
						public void onFocusChange(View v, boolean hasFocus) {
							final int index = v.getId() - 6666; //dummy
							final EditText caption = (EditText)v;
							if (!hasFocus){
								if (index >= 0) {
									items.get(index).widgetText = caption.getText().toString();
									items.get(index).jWidget.setFocusable(false);
									items.get(index).jWidget.setFocusableInTouchMode(false);
									controls.pOnWidgeItemLostFocus(PasObj, index, caption.getText().toString());
								}
							}
						}
					});
										
					break;
															
			}
				
			if (itemWidget != null) {
				itemWidget.setFocusable(false);
				itemWidget.setFocusableInTouchMode(false);
				itemWidget.setOnClickListener(getOnCheckItem(itemWidget, position));
			}
			
		    LayoutParams txtParam;			 			
			txtParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h  //layText					
			txtParam.leftMargin = 10;
			txtParam.rightMargin = 10;
			
			if (items.get(position).itemLayout == 0) { // Pascal layImageTextWidget
				
				int flagItemLeft = 2;
				int flagItemRight = 2;									
				
				if (itemImage != null) {												 
					flagItemLeft = 0;
					imgParam.addRule(RelativeLayout.CENTER_VERTICAL);		
					imgParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);					
					itemLayout.addView(itemImage, imgParam);					
				}
				else {
					if (itemTextLeft != null) {
						flagItemLeft = 1;
						leftParam.addRule(RelativeLayout.CENTER_VERTICAL);							
						leftParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);																
						itemLayout.addView(itemTextLeft, leftParam);					
					}	
				}
													
				if (itemWidget != null) {
					flagItemRight = 0;
					widgetParam.addRule(RelativeLayout.CENTER_VERTICAL);							
					widgetParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);					
					itemLayout.addView(itemWidget, widgetParam);
				}
				else {
					if (itemTextRight != null) {
						flagItemRight = 1;
						rightParam.addRule(RelativeLayout.CENTER_VERTICAL);							
						rightParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);					
						itemLayout.addView(itemTextRight, rightParam);
					}	
				}
				
				switch(items.get(position).textAlign) {  //alLeft, alRight, alCenter    --layImageTextWidget				
				  case 0: {					  
					  switch(flagItemLeft) {  
					     case 0: txtParam.addRule(RelativeLayout.RIGHT_OF, itemImage.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId()); break;
					     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT); break;	  
					  }					    	
					  
					  break;
				  }						  
				  case 1: {
					  switch(flagItemRight) {
					     case 0: txtParam.addRule(RelativeLayout.LEFT_OF, itemWidget.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId()); break;
					     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT); break;	  
					  }					    	
					  break;  	
				  }				  
				  case 2: {
					  if ( (itemTextLeft == null) || (itemTextRight == null) ) {
					    	txtParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); //w,h  //layText					
						    txtParam.leftMargin = 10;
						    txtParam.rightMargin = 10;					    				
					  }
					  txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);				  
				  }
			    }
				
				
				itemLayout.addView(txtLayout, txtParam);				
				
			} else if (items.get(position).itemLayout == 1) {   //Pascal layWidgetTextImage

				int flagItemLeft = 2;
				int flagItemRight = 2;				   
				
				if (itemWidget != null) {
					flagItemLeft = 0;
					widgetParam.addRule(RelativeLayout.CENTER_VERTICAL);
					leftParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
					itemLayout.addView(itemWidget, widgetParam);
				}
				else {
					if (itemTextLeft != null) {
						flagItemLeft = 1;
						leftParam.addRule(RelativeLayout.CENTER_VERTICAL);							
						leftParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);																
						itemLayout.addView(itemTextLeft, leftParam);					
					}					
				}
								
				if (itemImage != null) {    //layWidgetTextImage
					flagItemRight = 0;					
					imgParam.addRule(RelativeLayout.CENTER_VERTICAL);					
					imgParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
					itemLayout.addView(itemImage, imgParam);				
				}
				else {
					if (itemTextRight != null) {
						flagItemRight = 1;						
						rightParam.addRule(RelativeLayout.CENTER_VERTICAL);							
						rightParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);					
						itemLayout.addView(itemTextRight, rightParam);						
					}
				}
								
				switch(items.get(position).textAlign) {  //alLeft, alRight, alCenter    --layWidgetTextImage				
				  case 0: {					  
					  switch(flagItemLeft) {
					     case 0: txtParam.addRule(RelativeLayout.RIGHT_OF, itemWidget.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId()); break;
					     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT); break;	  
					  }
					  
					  break;
				  }						  
				  case 1: {					  					  
					  switch(flagItemRight) {
					     case 0: txtParam.addRule(RelativeLayout.LEFT_OF, itemImage.getId()); break;
					     case 1: txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId()); break;
					     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT); break;	  
					  }					    						  
					  break;  	
				  }
				  
				  case 2: { 
					  if ( (itemTextLeft == null) || (itemTextRight == null) ) {
					    	txtParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); //w,h  //layText					
						    txtParam.leftMargin = 10;
						    txtParam.rightMargin = 10;					    				
					  }  
					  txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);
				  }
			    }
				
				itemLayout.addView(txtLayout, txtParam);
				
			} else if (items.get(position).itemLayout == 2) {  //(2)   Pascal layText	  ---- default				    				
				
				
				if (itemTextLeft != null) {
					leftParam.addRule(RelativeLayout.CENTER_VERTICAL);							
					leftParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);																
					itemLayout.addView(itemTextLeft, leftParam);															
				}
					    						
				if (itemTextRight != null) {
					rightParam.addRule(RelativeLayout.CENTER_VERTICAL);							
					rightParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);					
					itemLayout.addView(itemTextRight, rightParam);
				}
																								
				switch(items.get(position).textAlign) {  //alLeft, alRight, alCenter    --layText
				
				  case 0: {
					  
					  if (itemTextLeft != null) {
						 txtParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); //w,h  //layText					
						 txtParam.leftMargin = 10;
						 txtParam.rightMargin = 10;  
					     txtParam.addRule(RelativeLayout.RIGHT_OF, itemTextLeft.getId());
					  }   
					  else {
					     txtParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); //w,h  //layText
					     txtParam.leftMargin = 10;
						 txtParam.rightMargin = 10;
						 txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
					  }	 
					   					  	 					  
					  break;
				  }
				  
				  case 1: {
					  
					  if (itemTextRight != null) {												 
					     txtParam.addRule(RelativeLayout.LEFT_OF, itemTextRight.getId());
					  }     
					  else {   					  
					     txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);  //***					     
					  }	
					  break;
				  }
				  
				  case 2: {	 //center				  
					  if ( (itemTextLeft == null) || (itemTextRight == null) ) {
					    	txtParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); //w,h  //layText					
						    txtParam.leftMargin = 10;
						    txtParam.rightMargin = 10;					    				
					  }					  
				      txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);				  
			      }
				  
			    }
				
			   itemLayout.addView(txtLayout, txtParam);								
			} 

            			
			if (items.get(position).highLightColor != Color.TRANSPARENT)
				itemLayout.setBackgroundColor(items.get(position).highLightColor); 
						
			listLayout.addView(itemLayout);
			
			return listLayout;
			
		} else return v;

	}

	View.OnClickListener getOnCheckItem(final View cb, final int position) {
		return new View.OnClickListener() {
			public void onClick(View v) {
				if (cb.getClass().getName().equals("android.widget.ImageView")) {
					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
				}
				else if (cb.getClass().getName().equals("android.widget.CheckBox")) {
					items.get(position).checked = ((CheckBox)cb).isChecked();
					controls.pOnClickWidgetItem(PasObj, position, ((CheckBox)cb).isChecked());
				}
				else if (cb.getClass().getName().equals("android.widget.RadioButton")) {
					//new code: fix to RadioButton Group  default behavior: thanks to Leledumbo.
					boolean doCheck = ((RadioButton)cb).isChecked(); //new code
					for (int i=0; i < items.size(); i++) {
						((RadioButton)items.get(i).jWidget).setChecked(false);
						items.get(i).checked = false;
						thisAdapter.notifyDataSetChanged(); //fix 16-febr-2015
					}

					items.get(position).checked = doCheck;
					((RadioButton)items.get(position).jWidget).setChecked(doCheck);
					controls.pOnClickWidgetItem(PasObj, position, doCheck);

				}
				else if (cb.getClass().getName().equals("android.widget.Button")) { //button
					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
				}
				else if (cb.getClass().getName().equals("android.widget.TextView")) { //textview
					controls.pOnClickWidgetItem(PasObj, position, items.get(position).checked);
				}
				else if (cb.getClass().getName().equals("android.widget.EditText")) { //edittext

					if (!cb.isFocusable()) {
						cb.setFocusable(true);
						cb.setFocusableInTouchMode(true);
					}

					cb.requestFocus();
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
	int textAlign;

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

	//Constructor
	public  jListView(android.content.Context context,
					  Controls ctrls,long pasobj, int widget, String widgetTxt,  Bitmap bmp,
					  int txtDecorated,
					  int itemLay,
					  int txtSizeDecorated,  int txtAlign) {
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
		textAlign = txtAlign;
		typeFace = Typeface.DEFAULT;
		
		setBackgroundColor(0x00000000);
		setCacheColorHint(0);

		alist = new ArrayList<jListItemRow>();
		orig_alist = new ArrayList<jListItemRow>();
		//simple_list_item_1
		aadapter = new jArrayAdapter(context, controls, PasObj, android.R.layout.simple_list_item_1, alist);

		setAdapter(aadapter);

		setChoiceMode(ListView.CHOICE_MODE_SINGLE);

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

	//thanks to @renabor
	public static boolean isEmpty(ArrayList<?> coll) {
		return (coll == null || coll.isEmpty());
	}

	public boolean isItemChecked(int index) {
		return alist.get(index).checked;
	}


	public String GetWidgetText(int index) {
		return alist.get(index).widgetText;
	}


	public  void setTextColor( int textcolor) {
		this.textColor =textcolor;
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
		aadapter.notifyDataSetChanged();
	}

	//
	public  void delete( int index ) {
		alist.remove(index);
		aadapter.notifyDataSetChanged();
	}

	public  String  getItemText(int index) {
		return alist.get(index).label;        
	}

	public int GetSize() {
		return alist.size();
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		alist.clear();
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
		info.textColor= textColor;		
		info.widgetTextColor= widgetTextColor;		
		info.bmp = genericBmp;

		info.textDecorated = textDecorated;
		info.itemLayout = itemLayout;
		info.textSizeDecorated = textSizeDecorated;
		info.textAlign = textAlign;

		info.typeFace = this.typeFace;
		info.tagString = "";

		alist.add(info);
		
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
		info.textColor= textColor;
		info.widgetTextColor= widgetTextColor;
		info.bmp = bm;

		info.textDecorated = textDecorated;
		info.itemLayout =itemLayout;
		info.textSizeDecorated = textSizeDecorated;
		info.textAlign = textAlign;

		info.typeFace = this.typeFace;
		info.tagString = "";

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
		info.textColor= fontColor;
		info.bmp = img;

		info.textDecorated = textDecorated;
		info.itemLayout =itemLayout;
		info.textSizeDecorated = textSizeDecorated;
		info.textAlign = textAlign;

		info.typeFace = this.typeFace;
		//info.fontTextStyle = Typeface.NORMAL;
		info.tagString = "";

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
		info.textColor= fontColor;
		info.bmp = null;

		info.textDecorated = textDecorated;
		info.itemLayout =itemLayout;
		info.textSizeDecorated = textSizeDecorated;
		info.textAlign = textAlign;

		info.typeFace = this.typeFace;
		// info.fontTextStyle = Typeface.NORMAL;
		info.tagString = "";

		alist.add(info);
		aadapter.notifyDataSetChanged();
	}

	public void setTextColor2(int value, int index) {
		if (value != 0) {
			alist.get(index).textColor = value;
			aadapter.notifyDataSetChanged();
		}
	}

	public  void setTextSize2(int textsize, int index) {
		if (textsize != 0) {
			alist.get(index).textSize = textsize;
			aadapter.notifyDataSetChanged();
		}
	}

	public  void setImageItem(Bitmap bm, int index) {
		alist.get(index).bmp = bm;
		aadapter.notifyDataSetChanged();
	}

	private int GetDrawableResourceId(String _resName) {
		try {
			Class<?> res = R.drawable.class;
			Field field = res.getField(_resName);  //"drawableName"
			int drawableId = field.getInt(null);
			return drawableId;
		}
		catch (Exception e) {
			Log.e("ListView", "Failure to get drawable id.", e);
			return 0;
		}
	}
	
	private Drawable GetDrawableResourceById(int _resID) {
		return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));
	}

	public  void setImageItem(String imgResIdentifier, int index) {	   // ..res/drawable
		Drawable d = GetDrawableResourceById(GetDrawableResourceId(imgResIdentifier));
		alist.get(index).bmp = ((BitmapDrawable)d).getBitmap();
		aadapter.notifyDataSetChanged();
	}

	public void SetImageByResIdentifier(String _imageResIdentifier) {
		Drawable d = GetDrawableResourceById(GetDrawableResourceId(_imageResIdentifier));
		genericBmp = ((BitmapDrawable)d).getBitmap();	
	}
		
	public void setTextDecorated(int value, int index){
		alist.get(index).textDecorated = value;
		aadapter.notifyDataSetChanged();
	}

	public void setTextSizeDecorated(int value, int index) {
		alist.get(index).textSizeDecorated = value;
		aadapter.notifyDataSetChanged();
	}

	public void setItemLayout(int value, int index){
		alist.get(index).itemLayout = value; //0: image-text-widget; 1 = widget-text-image; 2: just text
		aadapter.notifyDataSetChanged();
	}

	public void setWidgetItem(int value, int index){
		alist.get(index).widget = value;
		aadapter.notifyDataSetChanged();
	}

	public void setTextAlign(int value, int index){
		alist.get(index).textAlign = value;
		aadapter.notifyDataSetChanged();
	}

	public void setWidgetItem(int value, String txt, int index){
		alist.get(index).widget = value;
		alist.get(index).widgetText = txt;
		aadapter.notifyDataSetChanged();
	}

	public void setWidgetText(String value, int index){
		alist.get(index).widgetText = value;
		aadapter.notifyDataSetChanged();
	}

	public void setWidgetCheck(boolean _value, int _index){
		alist.get(_index).checked = _value;
		aadapter.notifyDataSetChanged();
	}

	public void setItemTagString(String _tagString, int _index){
		alist.get(_index).tagString = _tagString;
		aadapter.notifyDataSetChanged();
	}


	public String getItemTagString(int _index){
		return alist.get(_index).tagString;
	}


	private void DoHighlight(int position, int _color) {	
		alist.get(position).highLightColor = _color;
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
		     String line1 =  line.substring(pos1+1, line.length());
		     line = line1;
		   }			 
		   else {
			 line =  line.substring(1, line.length());	
		   }
		}
		                                   
		int pos2 = line.lastIndexOf(rightDelimiter);  //searches right-to-left instead  //rightDelimiter ")"
		if (pos2 > 0 ) {				
			if (pos2 < line.length()) { 
		   	   txt2 = line.substring(pos2+1, line.length());
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
		     String line1 =  line.substring(pos1+1, line.length());
		     line = line1;
		   }			 
		   else {
			 line =  line.substring(1, line.length());	
		   }
		}
		                                   
		int pos2 = line.lastIndexOf(rightDelimiter);  //searches right-to-left instead  //rightDelimiter ")"
		if (pos2 > 0 ) {				
			if (pos2 < line.length()) { 
		   	   txt2 = line.substring(pos2+1, line.length());
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
		     String line1 =  line.substring(pos1+1, line.length());
		     line = line1;
		   }			 
		   else {
			 line =  line.substring(1, line.length());	
		   }
		}
		                                   
		int pos2 = line.lastIndexOf(rightDelimiter);  //searches right-to-left instead  //rightDelimiter ")"
		if (pos2 > 0 ) {				
			if (pos2 < line.length()) { 
		   	   txt2 = line.substring(pos2+1, line.length());
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

	public void SetItemPaddingTop(int _ItemPaddingTop) { 
		aadapter.SetItemPaddingTop( _ItemPaddingTop);
	}
	
	public void SetItemPaddingBottom(int _itemPaddingBottom) { 
		aadapter.SetItemPaddingBottom(_itemPaddingBottom);
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
	
	public void DispatchOnDrawItemWidgetImage(boolean _value) {
		aadapter.SetDispatchOnDrawItemWidgetImage(_value);
	}
	
	public void SetSelection(int _index) {
		this.setSelection(_index);		
		if (highLightSelectedItem) {	
			 if (lastSelectedItem != -1) {
			    DoHighlight(lastSelectedItem, Color.TRANSPARENT); //textcolor
			 }			
			 DoHighlight(_index,  highLightColor);
			 lastSelectedItem = (int) _index;		
		}			
	}

        public void SmoothScrollToPosition(int _index) {
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
	    this.setItemChecked(_index, _value);		  
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
		return this.getCheckedItemPosition();
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
		if (Build.VERSION.SDK_INT < 19 ) {			
			ViewGroup parent = LAMWCommon.getParent();
	       	if (parent!= null) {
	       		parent.requestLayout();
	       		parent.invalidate();	
	       	}
		}	
		this.setVisibility(android.view.View.VISIBLE);
	}
	
	public void SetVisibilityGone() {
		LAMWCommon.setVisibilityGone();
	}

	
	//TODO
	public String GetEnvironmentDirectoryPath(int _directory) {
		
		File filePath= null;
		String absPath="";   //fail!
		  
		//Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);break; //only Api 19!
		if (_directory != 8) {		  	   	 
		  switch(_directory) {	                       
		    case 0:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS); break;	   
		    case 1:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM); break;
		    case 2:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC); break;
		    case 3:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES); break;
		    case 4:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_NOTIFICATIONS); break;
		    case 5:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES); break;
		    case 6:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PODCASTS); break;
		    case 7:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RINGTONES); break;
		    
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

}
