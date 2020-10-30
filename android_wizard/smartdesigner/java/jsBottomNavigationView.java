package org.lamw.appcompattablayoutdemo1;


import android.content.Context;
import android.graphics.Color;
import android.os.Build;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.util.Log;

/*Draft java code by "Lazarus Android Module Wizard" [1/13/2018 22:10:54]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
public class jsBottomNavigationView extends BottomNavigationView /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   //private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   private MenuItem mLastMenuItem = null;
   
   private int menuItemColor = R.color.primary_text;
   private int selectedMenuItemColor = R.color.primary;
   
   int itemId;
   String itemCaption;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsBottomNavigationView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);
      
      this.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
          @Override
          public boolean onNavigationItemSelected(MenuItem menuItem) {                   	          	 
  		    itemId = menuItem.getItemId();
  		    itemCaption = menuItem.getTitle().toString();
  		    
		    if (mLastMenuItem !=  null) {    	
 		       // mLastMenuItem.setChecked(false);    		    	
     		   if (menuItemColor == R.color.primary_text)
 		           mLastMenuItem.setChecked(false);  //highlighted item
     		   else
     		      SetItemTextColor(mLastMenuItem, menuItemColor);    		    	    		    	
 		    }
 		    
 		    if (selectedMenuItemColor == R.color.primary)
 		        menuItem.setChecked(true);  //highlighted item
 		    else
 		    	SetItemTextColor(menuItem, selectedMenuItemColor);  		      		    
  		    
  		    mLastMenuItem = menuItem;
  		    
  	 	    controls.pOnClickBottomNavigationViewItem(pascalObj, itemId, itemCaption);
  	 	    
              // return true if you want the item to be displayed as the selected item
              return true;
          }
      });


   } //end constructor

   public void jFree() {
      //free local objects...
	 LAMWCommon.free();
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
   
   public Menu GetMenu() {
	      //this.getMenu().add(Menu.NONE, 1, Menu.NONE, "Home").setIcon(R.drawable.ic_home_black_24dp);	      
	      return this.getMenu();
   }
	   
   public MenuItem AddItem(Menu _menu, int _itemId,  String _itemCaption) {	   	   	   
	   MenuItem item = _menu.add(0,_itemId,0 ,(CharSequence)_itemCaption);
	   SetItemTextColor(item, menuItemColor);
	   this.invalidate();	   
	   return  item;
   }
   
   public void AddItem(Menu _menu,  int _itemId, String _itemCaption, String _drawableIdentifier) {	   	   	   	   
	  // MenuItem item = _menu.add(_itemCaption);	  
	   MenuItem item = _menu.add(0,_itemId,0 ,(CharSequence)_itemCaption);
	   int id = context.getResources().getIdentifier(_drawableIdentifier, "drawable", context.getPackageName() );	   
	   item.setIcon(id); // add icon with drawable resource	   
	   SetItemTextColor(item, menuItemColor); 	   
	   this.invalidate();
   }

   public void AddItemIcon(MenuItem _menuItem, String _drawableIdentifier) {	   	   	   
		   int id = context.getResources().getIdentifier(_drawableIdentifier, "drawable", context.getPackageName() );		   
		   _menuItem.setIcon(id); // add icon with drawable resource	
		   //SetItemTextColor(_menuItem, menuItemColor);
		   this.invalidate();	   	 
   }
	     
	   //http://blog.xebia.com/android-design-support-navigationview/
   public void ClearMenu() {
		   this.getMenu().clear(); //clear old inflated items.   
   }


   //ref. https://hanihashemi.com/2017/05/06/change-text-color-of-menuitem-in-navigation-drawer/
   public void SetItemTextColor(MenuItem _menuItem, int _color) {
	   SpannableString spanString = new SpannableString(_menuItem.getTitle().toString());
	   spanString.setSpan(new ForegroundColorSpan(_color ), 0, spanString.length(), 0);
	   _menuItem.setTitle(spanString);
   }
   
   public void SetAllItemsTextColor(int _color) {	   	   	   
	   for (int i = 0; i < this.getMenu().size(); i++) {
		   SetItemTextColor(this.getMenu().getItem(i), _color);
	   }  	   
	   this.invalidate();
	   menuItemColor = _color;
   }

   public void ResetAllItemsTextColor() {	   	   	   
	   for (int i = 0; i < this.getMenu().size(); i++) {
		   SetItemTextColor(this.getMenu().getItem(i),  menuItemColor);
	   }  	   
	   this.invalidate();
   }
   
   public void SetItemTextColor(int _color) {	  
	   menuItemColor = _color;	  
   }
   
   public void SetSelectedItemTextColor(int _color) {
	   selectedMenuItemColor = _color;
   }
      
   public void	SetFitsSystemWindows(boolean _value) {
		LAMWCommon.setFitsSystemWindows(_value);
   }
   
   
   public void SetBackgroundToPrimaryColor() {	   
	   this.setBackgroundColor(LAMWCommon.getColorFromResources(context, R.color.primary)); 
   }
   
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
  
}
