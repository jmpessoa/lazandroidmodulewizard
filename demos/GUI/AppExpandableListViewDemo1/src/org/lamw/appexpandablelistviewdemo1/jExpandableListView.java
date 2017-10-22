package org.lamw.appexpandablelistviewdemo1;


import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListView;
import android.widget.ImageView;

import java.util.HashMap;
import java.util.List;
import java.util.regex.Pattern;

import android.graphics.Color;
import android.graphics.Typeface;
import android.util.TypedValue;
import android.widget.AbsListView;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;
import android.widget.RelativeLayout.LayoutParams;

import java.lang.reflect.Field;
import java.util.ArrayList;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

class HeaderInfo {
	String title;
	int color;
	int fontSize;
	int fontSizeUnit;
	int alignment;
	int fontFace;
	int textTypeface;
	int iconResId;
	int lastSelectedItem;	
	int highLightColor;
}

class ChildInfo {
	String title;
	int color;
	int fontSize;
	int fontSizeUnit;
	int alignment;
	int fontFace;
	int textTypeface;
	int backgroundColor;
	int iconResId;	 	
}

//ref.
//https://www.androidhive.info/2013/07/android-expandable-list-view-tutorial/
//https://acadgild.com/blog/expandable-listview-example-android/
//http://techlovejump.com/android-expandable-listview-tutorial/

class ExpandableListAdapter extends BaseExpandableListAdapter {
	 
    private Context _context;
    
    private List<HeaderInfo> _listDataHeader; // header titles
            
    // child data in format of header info, child info
    private HashMap<HeaderInfo, List<ChildInfo>> _listDataChild;
 
    public ExpandableListAdapter(Context context, List<HeaderInfo> listDataHeader,
            HashMap<HeaderInfo, List<ChildInfo>> listChildData) {
        this._context = context;
        this._listDataHeader = listDataHeader;
        this._listDataChild = listChildData;
    }
 
    @Override
    public Object getChild(int groupPosition, int childPosititon) {
        return this._listDataChild.get(this._listDataHeader.get(groupPosition))
                .get(childPosititon);
    }
 
    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }
 
    @Override
    public View getChildView(int groupPosition, final int childPosition, boolean isLastChild, 
    		                 View convertView,  ViewGroup parent) {
     	
        final ChildInfo child = (ChildInfo) getChild(groupPosition, childPosition);
        final String childText = child.title;
        int color = child.color;		       
        int fontSize = child.fontSize;
        int fontSizeUnit = child.fontSizeUnit;;
        int alignment = child.alignment;
        int fontFace = child.fontFace;
        int textTypeface = child.textTypeface;
        int backgroundColor = child.backgroundColor;
        int iconResId = child.iconResId;
        
        HeaderInfo header = (HeaderInfo)getGroup(groupPosition);
        int selectedItem = header.lastSelectedItem;
        int highLightColor = header.highLightColor;
              
        
		LinearLayout listLayout = new LinearLayout(_context);		
		listLayout.setOrientation(LinearLayout.HORIZONTAL);
		
		AbsListView.LayoutParams lparam = new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT,
				                                                      AbsListView.LayoutParams.WRAP_CONTENT); //w, h		
		listLayout.setLayoutParams(lparam);
		
		LayoutParams txtParam;					
		txtParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h					
		
		RelativeLayout itemLayout = new RelativeLayout(_context);
		LayoutParams itemParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); //w,h
		itemLayout.setLayoutParams(itemParam);
							
		TextView textView = new TextView(_context); 
		
		textView.setText(childText);
		textView.setId(groupPosition+childPosition+46742);
	
		ImageView itemImage = null;
		RelativeLayout.LayoutParams imgParam = null; 
		if (iconResId != 0) {
		  imgParam = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h		  
		  itemImage = new ImageView(_context);
		  itemImage.setId(groupPosition+childPosition+16742);
		  itemImage.setImageResource(iconResId);
		  itemImage.setFocusable(false);
		  itemImage.setFocusableInTouchMode(false);		
		  imgParam.addRule(RelativeLayout.CENTER_VERTICAL);
		}
		
		Typeface tf = Typeface.DEFAULT;
		switch (fontFace) {
			case 0: tf = Typeface.DEFAULT; break;
			case 1: tf = Typeface.SANS_SERIF; break;
			case 2: tf = Typeface.SERIF; break;
			case 3: tf = Typeface.MONOSPACE; break;
		}		
		textView.setTypeface(tf, textTypeface);  		 
		
		if (color != 0)
		   textView.setTextColor(color);
				
		if (fontSize != 0)  {				         
	         String t = textView.getText().toString();
	         textView.setTextSize(fontSizeUnit, fontSize);
	         textView.setText(t);			
			 textView.setTextSize(color);
		}
						
		int textAlignment;  
	    switch (alignment) {         
	     //[ifdef_api14up]
	                case 0 : { textAlignment = Gravity.START             ; }; break;
	                case 1 : { textAlignment = Gravity.END               ; }; break;
	     //[endif_api14up]
	                
	     /* //[endif_api14up]
	                case 0 : { textAlignment = Gravity.LEFT              ; }; break;
	                case 1 : { textAlignment = Gravity.RIGHT             ; }; break;
	     //[ifdef_api14up] */
	                
	                case 2 : { textAlignment = Gravity.CENTER_HORIZONTAL ; }; break;
	                
	     //[ifdef_api14up]
	                default : { textAlignment = Gravity.START            ; }; break;
	     //[endif_api14up]
	                
	     /* //[endif_api14up]
	                default : { textAlignment = Gravity.LEFT             ; }; break;
	     //[ifdef_api14up] */	                
	    }
			       	     
		if ( alignment == 0 )  {  //child
			if (imgParam == null) { 
    		  textView.setPadding(100, 40 /*padTop*/, 20, 40 /*padBottom*/);
    		  txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
			} else {
				itemImage.setPadding(100, 10, 20, 10);
				imgParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);				
				textView.setPadding(10, 40 /*padTop*/, 20, 40 /*padBottom*/);				
				txtParam.addRule(RelativeLayout.RIGHT_OF,  itemImage.getId());				
			}				
		}		
		else if ( alignment == 1 )  {    		
			if (imgParam == null) { 
	    		textView.setPadding(10, 40 /*padTop*/, 100, 40 /*padBottom*/);
	    		txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
			} else {
	    		textView.setPadding(10, 40 /*padTop*/, 100, 40 /*padBottom*/);
	    		txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);												
				itemImage.setPadding(10, 10, 10, 10);				
				imgParam.addRule(RelativeLayout.LEFT_OF,  textView.getId());				
		   }
    		    		
		}		
		else if (alignment == 2) {
			if (imgParam == null) { 
    		   textView.setPadding(10, 40 /*padTop*/, 20, 40 /*padBottom*/);
    		   txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);
			}
			else {
				textView.setPadding(10, 40 /*padTop*/, 20, 40 /*padBottom*/);
	    		txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);								
				itemImage.setPadding(10, 10, 10, 10);
				imgParam.addRule(RelativeLayout.LEFT_OF,  textView.getId());				
			}
		}    
	    				
		if (itemImage != null) {
		    itemLayout.addView(itemImage, imgParam);
		}    		
		
		itemLayout.addView(textView, txtParam);		
									
		if (backgroundColor != Color.TRANSPARENT) {
			  itemLayout.setBackgroundColor(backgroundColor);
			  itemLayout.setAlpha(0.75f);
		}
				
		if (selectedItem == childPosition) {			
			if (highLightColor != Color.TRANSPARENT) {
		       itemLayout.setBackgroundColor(highLightColor); 
			}
		}
		
		listLayout.addView(itemLayout);   //child
		              
        return listLayout;
    }
 
    @Override
    public int getChildrenCount(int groupPosition) {
        return this._listDataChild.get(this._listDataHeader.get(groupPosition)).size();
    }
 
    @Override
    public Object getGroup(int groupPosition) {
        return this._listDataHeader.get(groupPosition);
    }
 
    @Override
    public int getGroupCount() {
        return this._listDataHeader.size();
    }
 
    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }
 
    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
    	
        HeaderInfo header = (HeaderInfo)getGroup(groupPosition);       
        String headerTitle = header.title;        
        int color =  header.color;
        int fontSize = header.fontSize;
        int fontSizeUnit = header.fontSizeUnit;
        int alignment =  header.alignment;
        int fontFace = header.fontFace;
        int textTypeface = header.textTypeface;
        int iconResId = header.iconResId;
        
		LinearLayout listLayout = new LinearLayout(_context);		
		listLayout.setOrientation(LinearLayout.HORIZONTAL);
		
		AbsListView.LayoutParams lparam = new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT,
				                                                      AbsListView.LayoutParams.WRAP_CONTENT); //w, h
		
		listLayout.setLayoutParams(lparam);
				
		RelativeLayout itemLayout = new RelativeLayout(_context);
		LayoutParams itemParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); //w,h
		itemLayout.setLayoutParams(itemParam);
				
		LayoutParams txtParam = new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h  //layText							
		TextView textView = new TextView(_context); 		
		textView.setText(headerTitle);
		textView.setId(groupPosition+36742);		
		
		ImageView itemImage = null;
		RelativeLayout.LayoutParams imgParam = null;
		if (iconResId != 0) {
		  imgParam = new RelativeLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT); //w,h		
		  itemImage = new ImageView(_context);
		  itemImage.setId(groupPosition+26742);		  
		  itemImage.setImageResource(iconResId);
		  itemImage.setFocusable(false);
		  itemImage.setFocusableInTouchMode(false);
		  imgParam.addRule(RelativeLayout.CENTER_VERTICAL);
		}							
		
		Typeface tf = Typeface.DEFAULT;
		switch (fontFace) {
			case 0: tf = Typeface.DEFAULT; break;
			case 1: tf = Typeface.SANS_SERIF; break;
			case 2: tf = Typeface.SERIF; break;
			case 3: tf = Typeface.MONOSPACE; break;
		}		
		textView.setTypeface(tf, textTypeface);
		
		
		if (color != 0)
		   textView.setTextColor(color);
		
		if (fontSize != 0)  {				         
	         String t = textView.getText().toString();
	         textView.setTextSize(fontSizeUnit, fontSize);
	         textView.setText(t);			
			 textView.setTextSize(color);
		}	   
		
		int textAlignment;	  //header	
	    switch (alignment) {         
	     //[ifdef_api14up]
	                case 0 : { textAlignment = Gravity.START             ; }; break;
	                case 1 : { textAlignment = Gravity.END               ; }; break;
	     //[endif_api14up]
	                
	     /* //[endif_api14up]
	                case 0 : { textAlignment = Gravity.LEFT              ; }; break;
	                case 1 : { textAlignment = Gravity.RIGHT             ; }; break;
	     //[ifdef_api14up] */
	                
	                case 2 : { textAlignment = Gravity.CENTER_HORIZONTAL ; }; break;
	                
	     //[ifdef_api14up]
	                default : { textAlignment = Gravity.START            ; }; break;
	     //[endif_api14up]
	                
	     /* //[endif_api14up]
	                default : { textAlignment = Gravity.LEFT             ; }; break;
	     //[ifdef_api14up] */
	                
	    }
		        		
		if ( alignment == 0 )  {  //header
			if (imgParam == null) { 
    		  textView.setPadding(100, 40 /*padTop*/, 20, 40 /*padBottom*/);
    		  txtParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
			} else {
				itemImage.setPadding(100, 10, 20, 10);
				imgParam.addRule(RelativeLayout.ALIGN_PARENT_LEFT);				
				textView.setPadding(10, 40 /*padTop*/, 20, 40 /*padBottom*/);				
				txtParam.addRule(RelativeLayout.RIGHT_OF,  itemImage.getId());				
			}				
		}		
		else if ( alignment == 1 )  {    		
			if (imgParam == null) { 
	    		textView.setPadding(10, 40 /*padTop*/, 100, 40 /*padBottom*/);
	    		txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
			} else {
	    		textView.setPadding(10, 40 /*padTop*/, 100, 40 /*padBottom*/);
	    		txtParam.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);												
				itemImage.setPadding(10, 10, 10, 10);				
				imgParam.addRule(RelativeLayout.LEFT_OF,  textView.getId());				
		   }
    		    		
		}		
		else if (alignment == 2) {
			if (imgParam == null) { 
    		   textView.setPadding(10, 40 /*padTop*/, 20, 40 /*padBottom*/);
    		   txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);
			}
			else {
				textView.setPadding(10, 40 /*padTop*/, 20, 40 /*padBottom*/);
	    		txtParam.addRule(RelativeLayout.CENTER_HORIZONTAL);								
				itemImage.setPadding(10, 10, 10, 10);
				imgParam.addRule(RelativeLayout.LEFT_OF,  textView.getId());				
			}
		}    
	    				
		if (itemImage != null) {
		    itemLayout.addView(itemImage, imgParam);
		}    		
		itemLayout.addView(textView, txtParam);		
						
		listLayout.addView(itemLayout);		
		
        return listLayout;
    }
 
    @Override
    public boolean hasStableIds() {
        return false;
    }
 
    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }        	
}

/*Draft java code by "Lazarus Android Module Wizard" [10/16/2017 22:40:47]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
public class jExpandableListView extends ExpandableListView /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   //private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
      
   ExpandableListAdapter listAdapter;
   
   List<HeaderInfo> listDataHeader;
   HashMap<HeaderInfo, List<ChildInfo>> listDataChild;
   
   String headerDelimiter = "$"; 
   String childInnerDelimiter = ";";
   
   int headerTextColor = 0;
   int childTextColor = 0;
   boolean hasData = false;
   
   int headerFontSize = 0;
   int childFontSize = 0; 
   
   int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
   int textAlignment;
   int textAlignmentChild;
   int fontFace;
   int textTypeface;
   int textTypefaceChild;
   int backgroundColorChild = Color.TRANSPARENT;
   int iconResId = 0;
   int iconResIdChild = 0;
      
   boolean highLightSelectedItem = false;
   int highLightColor = Color.TRANSPARENT; 
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jExpandableListView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      LAMWCommon = new jCommons(this,context,pascalObj);
      
      // preparing list data
      listDataHeader = new ArrayList<HeaderInfo>();
      listDataChild = new HashMap<HeaderInfo, List<ChildInfo>>();
      listAdapter = new ExpandableListAdapter(controls.activity, listDataHeader, listDataChild);
      
      // setting list adapter      
      this.setAdapter(listAdapter);
      
      /*
      onClickListener = new OnClickListener(){
      public void onClick(View view){     // *.* is a mask to future parse...;
              if (enabled) {
                 controls.pOnClickGeneric(pascalObj, Const.Click_Default); //JNI event onClick!
              }
           };
      };
      setOnClickListener(onClickListener);
      */           
      
      
     // Listview on child click listener
      this.setOnChildClickListener(new OnChildClickListener() {

          @Override
          public boolean onChildClick(ExpandableListView parent, View v,
                                                  int groupPosition, int childPosition, long id) {
        	          	          	  
				if (highLightSelectedItem) {
					
					 if (  ((HeaderInfo)listDataHeader.get(groupPosition)).lastSelectedItem != -1) {    	
					    DoHighlight(groupPosition, ((HeaderInfo)listDataHeader.get(groupPosition)).lastSelectedItem, Color.TRANSPARENT); 
					 }
					 
					 DoHighlight(groupPosition, childPosition,   highLightColor); //							 											
				}
				
				((HeaderInfo)listDataHeader.get(groupPosition)).lastSelectedItem = (int) childPosition;
        	  
        	    controls.pOnExpandableListViewChildClick(pascalObj,        			  
        			    groupPosition, ((HeaderInfo)listDataHeader.get(groupPosition)).title,        	  
        			    childPosition, ((ChildInfo)listDataChild.get(listDataHeader.get(groupPosition)).get(childPosition)).title
        			  );
        	  
              return false;
          }
      });
      
   // Listview Group expanded listener
      this.setOnGroupExpandListener(new OnGroupExpandListener() {
       
          @Override
          public void onGroupExpand(int groupPosition) {
        	  controls.pOnExpandableListViewGroupExpand(pascalObj, groupPosition, ((HeaderInfo)listDataHeader.get(groupPosition)).title );
          }
      });      
      
   // Listview Group collasped listener
      this.setOnGroupCollapseListener(new OnGroupCollapseListener() {       
          @Override
          public void onGroupCollapse(int groupPosition) {
        	  controls.pOnExpandableListViewGroupCollapse(pascalObj, groupPosition, ((HeaderInfo)listDataHeader.get(groupPosition)).title );
          }                 
      });
            
   } //end constructor
   
   public void jFree() {
      //free local objects...
  	 setOnClickListener(null);
	 LAMWCommon.free();
   }
 
	private void DoHighlight(int groupPosition, int position, int _color) {			
		//((ChildInfo)listDataChild.get(listDataHeader.get(groupPosition)).get(position)).highLightColor = _color;				 
		 ((HeaderInfo)listDataHeader.get(groupPosition)).highLightColor = _color;
		 listAdapter.notifyDataSetChanged();
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

   public View GetView() {
      return this;
   }

   public void SetLParamWidth(int _w) {
  	 LAMWCommon.setLParamWidth(_w);
   }

   public void SetLParamHeight(int _h) {
  	 LAMWCommon.setLParamHeight(_h);
   }

   public int GetLParamWidth() {
      return LAMWCommon.getLParamWidth();
   }

   public int GetLParamHeight() {
	 return  LAMWCommon.getLParamHeight();
   }

   public void SetLGravity(int _g) {
  	 LAMWCommon.setLGravity(_g);
   }

   public void SetLWeight(float _w) {
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

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }

   public void SetItemHeaderDelimiter(String _itemHeaderDelimiter) {
	   headerDelimiter = _itemHeaderDelimiter;
   }
   
   public void SetItemChildInnerDelimiter(String _itemChildInnerDelimiter) {
	   childInnerDelimiter =  _itemChildInnerDelimiter;
   }
   
   public void Add(String _header, String _delimitedChildItems) {
	   
	   HeaderInfo header = new HeaderInfo();
	   	   
	   List<ChildInfo> itemList = new ArrayList<ChildInfo>();
	 
	   String[] items = _delimitedChildItems.split(Pattern.quote(childInnerDelimiter));			
	   
	   for (int i = 0; i < items.length; i++) {
		   ChildInfo child = new ChildInfo();
		   child.title = items[i];
		   child.color = childTextColor;
		   child.fontSize = childFontSize;
		   child.fontSizeUnit =  mTextSizeTypedValue;
		   child.alignment = textAlignmentChild;
		   child.fontFace = fontFace;
		   child.textTypeface = textTypefaceChild;
		   child.backgroundColor = backgroundColorChild;
		   child.iconResId =  iconResIdChild;
		   //child.highLightColor = highLightColor;
		   itemList.add(child); 		   		
	   }	   
	   
	   header.title = _header;
	   header.color =  headerTextColor;
	   header.fontSize = headerFontSize;
	   header.fontSizeUnit =  mTextSizeTypedValue;
	   header.alignment = textAlignment;
	   header.fontFace = fontFace;
	   header.textTypeface = textTypeface;
	   header.iconResId =  iconResId;
	   header.lastSelectedItem = -1;
	   header.highLightColor = highLightColor;
	   listDataHeader.add(header);	
	   
	   int index = listDataHeader.size()-1;	   
	   
       listDataChild.put( listDataHeader.get(index),  itemList ); // Header, Child data       
       listAdapter.notifyDataSetChanged();             
   }
   
   public void Add(String _delimitedItem, String _headerDelimiter, String _childInnerDelimiter) {
	   	   	   	   
	   List<ChildInfo> itemList = new ArrayList<ChildInfo>();
	   
	   String[] data = _delimitedItem.split(Pattern.quote(_headerDelimiter));
	   String _header = data[0]; 
	   String[] items = data[1].split(Pattern.quote(_childInnerDelimiter));			
	   
	   for (int i = 0; i < items.length; i++) {
		   ChildInfo child = new ChildInfo();
		   child.title = items[i];
		   child.color = childTextColor;
		   child.fontSize = childFontSize; 
		   child.fontSizeUnit =  mTextSizeTypedValue;
		   child.alignment = textAlignmentChild;
		   child.fontFace = fontFace;
		   child.textTypeface = textTypefaceChild;
		   child.backgroundColor = backgroundColorChild;
		   child.iconResId =   iconResIdChild; //GetDrawableResourceId("ic_bullet_blue");
		   //child.highLightColor = highLightColor;
		   itemList.add(child); 		   
	   }	   
	   
	   HeaderInfo header = new HeaderInfo();
	   header.title = _header;
	   header.color = headerTextColor; 
	   header.fontSize = headerFontSize;	   
	   header.fontSizeUnit =  mTextSizeTypedValue;
	   header.alignment = textAlignment;
	   header.fontFace = fontFace;
	   header.textTypeface = textTypeface;
	   header.iconResId =  iconResId;
	   header.lastSelectedItem = -1;
	   header.highLightColor = highLightColor;
	   
	   listDataHeader.add(header);
	   
	   int index = listDataHeader.size()-1;	   
       listDataChild.put( listDataHeader.get(index), itemList ); // Header, Child data
       
       listAdapter.notifyDataSetChanged();             
   }
   
   public void SetFontColor (int _color) {	  
     headerTextColor = _color;          
   }
   
   
   public void SetFontChildColor(int _color) {	   
      childTextColor = _color;      
   }

   public void SetFontColorAll (int _color) {	  
	     headerTextColor = _color;
	     
	     if (listDataHeader.size() == 0) return;
	     
	     for (int i=0; i < listDataHeader.size(); i++) {
	    	listDataHeader.get(i).color = headerTextColor;
	     }
	     
	     listAdapter.notifyDataSetChanged();      
   }
	   	   
   public void SetFontChildColorAll(int _color) {	   
	      childTextColor = _color;
	      
	      if (listDataChild.size() == 0) return;
	            
	      for (int i=0; i < listDataHeader.size(); i++) {
	   	     
	    	  int count = listDataChild.get( listDataHeader.get(i) ).size();
	    	  
	    	  for (int j = 0; j < count; j++) {
	    		  ((ChildInfo)listDataChild.get(listDataHeader.get(i)).get(j)).color = childTextColor; 
	    	  }
	    	  
	      }            
	      listAdapter.notifyDataSetChanged();      
   }
   	
   //TTextSizeTypedValue =(tsDefault, tsPixels, tsDIP, tsMillimeters, tsPoints, tsScaledPixel);   
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
   
   public void SetFontSize(int _fontSize) {
      headerFontSize = _fontSize;
   }
   
   public void SetFontChildSize(int _fontSize) {
	  childFontSize = _fontSize;
   }
   
   public  void SetTextAlign(int _align) {
	   textAlignment = _align;
   }

   public  void SetTextChildAlign(int _align) {
	   textAlignmentChild = _align;
   }
   
   public void SetFontFace(int _fontFace) {		
		fontFace = _fontFace;		 
   }
	
   public void SetTextTypeFace(int _typeface) {
        textTypeface = _typeface;
   }
   
   public void SetTextChildTypeFace(int _typeface) {
       textTypefaceChild = _typeface;
   }
   
   public void SetBackgroundChild(int _color) {
	   backgroundColorChild = _color;	   
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
	
	public void SetImageItemIdentifier(String  _imageResIdentifier) {
		iconResId = GetDrawableResourceId(_imageResIdentifier);		   
	}
	
	public void SetImageChildItemIdentifier(String  _imageResIdentifier) {
		iconResIdChild = GetDrawableResourceId(_imageResIdentifier);		   
	}
   	
	public void SetHighLightSelectedChildItemColor(int _color)  {
		highLightColor = _color;
		if (_color != Color.TRANSPARENT) {		   
		   highLightSelectedItem = true;
		}
		else {
			highLightSelectedItem = false;
		}
	}

} 

