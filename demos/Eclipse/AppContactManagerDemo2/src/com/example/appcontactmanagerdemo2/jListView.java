package com.example.appcontactmanagerdemo2;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.util.TypedValue;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnTouchListener;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.RelativeLayout.LayoutParams;

class jListItemRow{
	String label = "";
	int    id; 
	int widget = 0;
	View jWidget; //needed to fix  the RadioButton Group default behavior: thanks to Leledumbo.
	String widgetText;
	String delimiter;
	boolean checked;
	int textSize;
	int textColor;
	int textDecorated;
	int textSizeDecorated;
	int itemLayout;
	int textAlign;
	Context ctx;
	Bitmap bmp;	
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
private List <jListItemRow> items ;
private ArrayAdapter thisAdapter;
private boolean mDispatchOnDrawItemTextColor;
private boolean mDispatchOnDrawItemBitmap;

boolean mChangeFontSizeByComplexUnitPixel;
int mTextSizeTypedValue;

public  jArrayAdapter(Context context, Controls ctrls,long pasobj, int textViewResourceId, 
		               List<jListItemRow> list) {
 super(context, textViewResourceId, list);
 PasObj = pasobj;
 controls = ctrls;
 ctx   = context;
 id    = textViewResourceId;
 items = list;
 thisAdapter = this;
 mDispatchOnDrawItemTextColor = true;
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
	      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; 
	      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
	      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; 
	      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; 
	      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; 
	      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 	      
      }   
		//String t = this.getText().toString();
		//this.setTextSize(mTextSizeTypedValue, mTextSize);
		//this.setText(t);
}

public void SetDispatchOnDrawItemTextColor(boolean _value) {
	mDispatchOnDrawItemTextColor = _value;
}

public void SetDispatchOnDrawItemBitmap(boolean _value) {
	mDispatchOnDrawItemBitmap = _value;
}

@Override
public  View getView(int position, View v, ViewGroup parent) {
		
if (position >= 0 && ( !items.get(position).label.equals("") ) ) {
		  
 LinearLayout listLayout = new LinearLayout(ctx);
 
 listLayout.setOrientation(LinearLayout.HORIZONTAL);  
 AbsListView.LayoutParams lparam =new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT, 
		                                                         AbsListView.LayoutParams.WRAP_CONTENT); //w, h
 listLayout.setLayoutParams(lparam);
 
 LayoutParams imgParam = null;      
 ImageView itemImage = null;
 	
 if (items.get(position).bmp !=  null) {  
	   imgParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
	   itemImage = new ImageView(ctx); 
	   itemImage.setId(position);
	   itemImage.setImageBitmap(items.get(position).bmp);  
	   itemImage.setFocusable(false);
	   itemImage.setFocusableInTouchMode(false);
	   itemImage.setPadding(6, 6, 0, 0);
	   itemImage.setOnClickListener(getOnCheckItem(itemImage, position));       
 }
 
 
 if (mDispatchOnDrawItemBitmap)  {        	
     Bitmap  imageBmp = (Bitmap)controls.pOnListViewDrawItemBitmap(PasObj, (int)position , items.get(position).label);
 	   if (imageBmp != null) {        		      	        	      
		  imgParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
		  itemImage = new ImageView(ctx); 
		  itemImage.setId(position);
		  itemImage.setImageBitmap(imageBmp);  
		  itemImage.setFocusable(false);
		  itemImage.setFocusableInTouchMode(false);
		  itemImage.setPadding(6, 6, 0, 0);
		  itemImage.setOnClickListener(getOnCheckItem(itemImage, position));   	      
   	}
 	    else {
 		   if (items.get(position).bmp !=  null) {       			
 		  	   imgParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
 		  	   itemImage = new ImageView(ctx); 
 		  	   itemImage.setId(position);
 		  	   itemImage.setImageBitmap(items.get(position).bmp);  
 		  	   itemImage.setFocusable(false);
 		  	   itemImage.setFocusableInTouchMode(false);
 		  	   itemImage.setPadding(6, 6, 0, 0);
 		  	   itemImage.setOnClickListener(getOnCheckItem(itemImage, position));
 		    }  
      }	        	
 } 
 else {
 	 if (items.get(position).bmp !=  null) {	
	   imgParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h
	   itemImage = new ImageView(ctx); 
	   itemImage.setId(position);
	   itemImage.setImageBitmap(items.get(position).bmp);  
	   itemImage.setFocusable(false);
	   itemImage.setFocusableInTouchMode(false);
	   itemImage.setPadding(6, 6, 0, 0);
	   itemImage.setOnClickListener(getOnCheckItem(itemImage, position));
 	  }   
  }   
    
 RelativeLayout itemLayout = new RelativeLayout(ctx);
     
 String line = items.get(position).label;   
 String[] lines = line.split(Pattern.quote(items.get(position).delimiter));
 
 TextView[] itemText = new TextView[lines.length];
 
 LinearLayout txtLayout = new LinearLayout(ctx);
 txtLayout.setOrientation(LinearLayout.VERTICAL);
   
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

 LayoutParams txtParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h

 //txtParam.alignWithParent = true;
      
 for (int i=0; i < lines.length; i++) {
	   
	   TextView textViewnew = new TextView(ctx);	   
	   float auxf = textViewnew.getTextSize();	   	  	  
	   itemText[i] = textViewnew;	   	   
	   if (i == 0) {
		    if (items.get(position).textSize != 0){
		    	auxf = items.get(position).textSize;
		    	
		    	if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP) 
			       itemText[i].setTextSize(mTextSizeTypedValue, auxf);
		    	else
		    		itemText[i].setTextSize(auxf);		    	
		    }
		    itemText[i].setPadding(10, 15, 10, 15); //Typeface.MONOSPACE
		    itemText[i].setTypeface(items.get(position).typeFace, faceTitle); //items.get(position).typeFace		    
		}
		else{
		   itemText[i].setPadding(10, 0, 10, 15);  //Typeface.SERIF
		   itemText[i].setTypeface(items.get(position).typeFace, faceBody); //		   
		   if (items.get(position).textSizeDecorated == 1) {
			   
		       if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP) 				    
			       itemText[i].setTextSize(mTextSizeTypedValue, auxf - 5*i);  // sdDeCecreasing
			   else 
				   itemText[i].setTextSize(auxf - 5*i);  // sdDeCecreasing
		   }
		   
		   if (items.get(position).textSizeDecorated == 2) {
			   
			   if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
			     itemText[i].setTextSize(mTextSizeTypedValue, auxf + 5*i);  // sdInCecreasing
			   else
				   itemText[i].setTextSize(auxf + 5*i);  // sdInCecreasing  
			     
		   }
		}
	   
	    itemText[i].setText(lines[i]);
	    	    	    
      if (mDispatchOnDrawItemTextColor)  {            	             	
        	 int drawItemTxtColor = controls.pOnListViewDrawItemCaptionColor(PasObj, (int)position, lines[i]);
        	 if (drawItemTxtColor != 0) {
        		itemText[i].setTextColor(drawItemTxtColor); 
        	 }
        	 else {
        		 if (items.get(position).textColor != 0) {	
        			itemText[i].setTextColor(items.get(position).textColor);
               }	 
        	 }
        } 
        else {
        	if (items.get(position).textColor != 0) {	
        		itemText[i].setTextColor(items.get(position).textColor);
        	}   
        }
	    
	      txtLayout.addView(itemText[i]);   
 }
 
 View itemWidget = null;
 
 switch(items.get(position).widget) {
   case 1:  itemWidget = new CheckBox(ctx);  ((CheckBox)itemWidget).setText(items.get(position).widgetText);                                                    
                         ((CheckBox)itemWidget).setText(items.get(position).widgetText);                           
                         items.get(position).jWidget = itemWidget; //                           
                         ((CheckBox)itemWidget).setChecked(items.get(position).checked);                                                      
   break;
   case 2:  itemWidget = new RadioButton(ctx); 
                         ((RadioButton)itemWidget).setText(items.get(position).widgetText);                           
                         items.get(position).jWidget = itemWidget; //                           
                         ((RadioButton)itemWidget).setChecked(items.get(position).checked);                          
   break;
   case 3:  itemWidget = new Button(ctx);  ((Button)itemWidget).setText(items.get(position).widgetText);
                         items.get(position).jWidget = itemWidget;
   break;
   case 4:  itemWidget = new TextView(ctx); 
                         ((TextView)itemWidget).setText(" "+items.get(position).widgetText+" ");
                         items.get(position).jWidget = itemWidget;
   break;
   //default: ;
 }
         
 LayoutParams widgetParam = null;

 if (itemWidget != null) {
	  widgetParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h	   
	  itemWidget.setFocusable(false);
    itemWidget.setFocusableInTouchMode(false);
    itemWidget.setOnClickListener(getOnCheckItem(itemWidget, position));       
 }
                        
 if (items.get(position).itemLayout == 0) {	//default...   
	   if (itemImage != null) {
		  listLayout.addView(itemImage, imgParam);
	   }
	   
	   txtParam.leftMargin = 10;
	   txtParam.rightMargin = 10;
	   
	   switch(items.get(position).textAlign) {
	     case 0: txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);  break;
	     case 1: txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);  break;
	     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT); break;
	     default: ;
	   }
	   
	   itemLayout.addView(txtLayout, txtParam);
	   
	   if (itemWidget != null) {
		  widgetParam.rightMargin = 10;
		  if (items.get(position).textAlign != 2) {
		    widgetParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
		  }else {widgetParam.addRule(RelativeLayout.CENTER_HORIZONTAL);}
		  itemLayout.addView(itemWidget, widgetParam);			  			  			  		  
	   }	   
	   
 } else {
	   
	   if (itemWidget != null) {
		  listLayout.addView(itemWidget, widgetParam);
	   }   
	   
	   txtParam.leftMargin = 10;
	   txtParam.rightMargin = 10;
	   switch(items.get(position).textAlign) {
	     case 0: txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);break;
	     case 1: txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL); break;
	     case 2: txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT); break;
	     default: ;
	   }
	   
	   itemLayout.addView(txtLayout, txtParam);
	   
	   if (itemImage != null) {
		  imgParam.rightMargin = 10;
		  
		  if (items.get(position).textAlign != 2) {
		  imgParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);}
		  else{imgParam.addRule(RelativeLayout.CENTER_HORIZONTAL);}
		  
		  itemLayout.addView(itemImage, imgParam);
	   }	   	   	   
 }
 
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

private Bitmap          genericBmp;
private int             widgetItem;
private String          widgetText;
private int             textColor; 
private int             textSize;
//private int             fontTextStyle;
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

String delimiter;

private ViewGroup       parent    = null;       // parent view
private RelativeLayout.LayoutParams lparams;  // Control xywh

private ArrayList<jListItemRow>    alist;

private jArrayAdapter        aadapter;

private OnItemClickListener  onItemClickListener;
private OnTouchListener onTouchListener;

private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

boolean highLightSelectedItem = false;
int highLightColor = Color.RED;

int lastSelectedItem = -1;
String selectedItemCaption = "";

//Constructor
public  jListView(android.content.Context context,
            Controls ctrls,long pasobj, int widget, String widgetTxt,  Bitmap bmp,
            int txtDecorated,
            int itemLay,
            int txtSizeDecorated,  int txtAlign) {
super(context);
//Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;

textColor = 0; //dummy: default
textSize  = 0; //dummy: default

//fontFace =  Typeface.BOLD;
//fontFace =  Typeface.BOLD_ITALIC;
//fontFace =  Typeface.ITALIC;
//fontTextStyle=  Typeface.NORMAL;
//fontFace =  Typeface.MONOSPACE;
//fontFace =  Typeface.DEFAULT;
//fontFace =  Typeface.DEFAULT_BOLD;
//fontFace =  Typeface.SANS_SERIF;
//fontFace =  Typeface.SERIF;

widgetItem = widget;
widgetText = widgetTxt; 
genericBmp = bmp;
textDecorated = txtDecorated;
itemLayout =itemLay;
textSizeDecorated = txtSizeDecorated;
textAlign = txtAlign;
typeFace = Typeface.DEFAULT;

//Init Class
lparams = new RelativeLayout.LayoutParams (100,100);
lparams.setMargins (50,50,0,0);
setBackgroundColor (0x00000000);
setCacheColorHint  (0);

alist = new ArrayList<jListItemRow>();
//simple_list_item_1
aadapter = new jArrayAdapter(context, controls, PasObj, android.R.layout.simple_list_item_1, alist);

setAdapter(aadapter);

setChoiceMode(ListView.CHOICE_MODE_SINGLE);

//Init Event

//renabor gesture
onTouchListener = new OnTouchListener() {	
	@Override
	public boolean onTouch(View v, MotionEvent event) {
		int action = event.getAction() & MotionEvent.ACTION_MASK;
		switch (action) {
			case MotionEvent.ACTION_DOWN:
				canClick = false;
				// Log.i("ACTION", "DOWN");
				mDownX = event.getX();
				mDownY = event.getY();
				isOnClick = true; // blocco la propagazione
				break;
			case MotionEvent.ACTION_CANCEL:
			case MotionEvent.ACTION_UP:
				if (isOnClick) {
					// Log.i("ACTION", "UP");
					canClick = true;
				} else { Log.i("ACTION","UP NOT PROCESSED"); }
				//return false; // passa oltre, ma potrebbe diventare true
				//mDownX = -1;
				return false;
				    
			case MotionEvent.ACTION_MOVE:
				if (isOnClick && (Math.abs(mDownX - event.getX()) > SCROLL_THRESHOLD || Math.abs(mDownY - event.getY()) > SCROLL_THRESHOLD)) {
					// Log.i("ACTION", "MOVE");
					isOnClick = false;
				};			
				return false;					
		};
	return false;
	};
};

setOnTouchListener(onTouchListener);


//fixed! thanks to @renabor
onItemClickListener = new OnItemClickListener() {@Override
	public void onItemClick(AdapterView <? > parent, View v, int position, long id) {
	  if (canClick) { 
	    	lastSelectedItem = (int) position;
			if (!isEmpty(alist)) { // this test is necessary !  //  <----- thanks to @renabor
				if (highLightSelectedItem) {
					if (lastSelectedItem > -1) {
						DoHighlight(lastSelectedItem, textColor);
					}
					DoHighlight((int) id, highLightColor);
				}
				if (alist.get((int) id).widget == 2  ) { //radio fix 16-febr-2015
					for (int i = 0; i < alist.size(); i++) {
						alist.get(i).checked = false;
					}
					alist.get((int) id).checked = true;
					aadapter.notifyDataSetChanged();
				}
				controls.pOnClickCaptionItem(PasObj, (int) id, alist.get((int) id).label);
			} else {
				controls.pOnClickCaptionItem(PasObj, lastSelectedItem, ""); // avoid passing possibly undefined Caption
			}
		}
	} 
};
setOnItemClickListener(onItemClickListener);

this.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {@Override
	public boolean onItemLongClick(AdapterView <?> parent, View view, int position, long id) {
		lastSelectedItem = (int)position;
		if (canClick) {
			if (!isEmpty(alist)) {  //  <----- thanks to @renabor
				selectedItemCaption = alist.get((int) id).label;
				controls.pOnListViewLongClickCaptionItem(PasObj, (int)id, alist.get((int)id).label);
				return false;
				};
		};
		return false;
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

public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
 parent = viewgroup;
 viewgroup.addView(this,lparams);
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
alist.clear();
aadapter.notifyDataSetChanged();
}

//
public  void delete( int index ) {
alist.remove( index );
aadapter.notifyDataSetChanged();
}

public  String  getItemText(int index) {
return alist.get(index).label;
//aadapter.notifyDataSetChanged();
}


public int GetSize() {
return alist.size();
//aadapter.notifyDataSetChanged();
}

//Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
alist.clear();
genericBmp = null;
alist    = null;
setAdapter(null);

aadapter = null;
lparams  = null;
setOnItemClickListener(null);
setOnItemLongClickListener(null); //thanks @renabor
}

public void setLParamWidth(int w) {
lpW = w;
}

public void setLParamHeight(int h) {
lpH = h;
}

public void addLParamsAnchorRule(int rule) {
lparamsAnchorRule[countAnchorRule] = rule;
countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
lparamsParentRule[countParentRule] = rule;
countParentRule = countParentRule + 1;
}

public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		//lparams.addRule(RelativeLayout.BELOW, id); 
		//lparams.addRule(RelativeLayout.ALIGN_BASELINE, id)
	    //lparams.addRule(RelativeLayout.LEFT_OF, id); //lparams.addRule(RelativeLayout.RIGHT_OF, id)
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }
		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
  }
  setLayoutParams(lparams);
}

public  void add2(String item, String delimiter) {
jListItemRow info = new jListItemRow(controls.activity);
info.label = item;
info.delimiter=  delimiter;
info.id = alist.size();
info.checked = false;
info.widget = widgetItem;
info.widgetText= widgetText;
info.checked = false;
info.textSize= textSize;
info.textColor= textColor;
info.bmp = genericBmp;

info.textDecorated = textDecorated;
info.itemLayout =itemLayout;
info.textSizeDecorated = textSizeDecorated;
info.textAlign = textAlign;

info.typeFace = this.typeFace;    

alist.add(info);
aadapter.notifyDataSetChanged();
}

public  void add22(String item, String delimiter, Bitmap bm) {
jListItemRow info = new jListItemRow(controls.activity);
info.label = item;
info.delimiter=  delimiter;
info.id = alist.size();
info.checked = false;
info.widget = widgetItem;
info.widgetText= widgetText;
info.checked = false;
info.textSize= textSize;
info.textColor= textColor;
info.bmp = bm;

info.textDecorated = textDecorated;
info.itemLayout =itemLayout;
info.textSizeDecorated = textSizeDecorated;
info.textAlign = textAlign;

info.typeFace = this.typeFace;

//Log.i("typeFace", item);
//info.fontTextStyle = Typeface.NORMAL;

alist.add(info);
aadapter.notifyDataSetChanged();
}

public  void add3(String item, String delimiter, int fontColor, int fontSize, int widgetItem, String wgtText, Bitmap img) {
	  jListItemRow info = new jListItemRow(controls.activity);
	  info.label = item;
	  info.id = alist.size();
	  info.checked = false;
	  info.widget = widgetItem;
	  info.widgetText= wgtText;
	  info.checked = false;
	  info.delimiter=  delimiter;
	  info.textSize= fontSize;
	  info.textColor= fontColor;	
	  info.bmp = img;

	  info.textDecorated = textDecorated;
	  info.itemLayout =itemLayout;
	  info.textSizeDecorated = textSizeDecorated;
	  info.textAlign = textAlign;

	  info.typeFace = this.typeFace;    
	  //info.fontTextStyle = Typeface.NORMAL;	  

	  alist.add(info);
	  aadapter.notifyDataSetChanged();
}

public  void add4(String item, String delimiter, int fontColor, int fontSize, int widgetItem, String wgtText) {
	  jListItemRow info = new jListItemRow(controls.activity);
	  info.label = item;
	  info.id = alist.size();
	  info.checked = false;
	  info.widget = widgetItem;
	  info.widgetText= wgtText;
	  info.checked = false;
	  info.delimiter=  delimiter;
	  info.textSize= fontSize;
	  info.textColor= fontColor;	
	  info.bmp = null;

	  info.textDecorated = textDecorated;
	  info.itemLayout =itemLayout;
	  info.textSizeDecorated = textSizeDecorated;
	  info.textAlign = textAlign;
	  
	  info.typeFace = this.typeFace;    
	 // info.fontTextStyle = Typeface.NORMAL;	  
	  
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

public void setTextDecorated(int value, int index){
	alist.get(index).textDecorated = value;
	aadapter.notifyDataSetChanged();
}

public void setTextSizeDecorated(int value, int index) {
	alist.get(index).textSizeDecorated = value;
	aadapter.notifyDataSetChanged();
}

public void setItemLayout(int value, int index){
	alist.get(index).itemLayout = value; //0: image-text-widget; 1 = widget-text-image
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

public void setWidgetCheck(boolean value, int index){
	alist.get(index).checked = value;	
	aadapter.notifyDataSetChanged();
}

private void DoHighlight(int position, int _color) {
 	alist.get(position).textColor = _color;
  aadapter.notifyDataSetChanged();		
}

public void SetHighLightSelectedItem(boolean _value)  {
	highLightSelectedItem = _value;
}

public void SetHighLightSelectedItemColor(int _color)  {
	highLightColor = _color;
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

}
