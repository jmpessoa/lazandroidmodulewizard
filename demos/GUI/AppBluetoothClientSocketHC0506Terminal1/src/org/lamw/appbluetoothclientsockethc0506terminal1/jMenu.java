package org.lamw.appbluetoothclientsockethc0506terminal1;

import java.lang.reflect.Field;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SubMenu;
import android.view.View;

/*Draft java code by "Lazarus Android Module Wizard" [4-5-14 20:46:56]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jMenu /*extends ...*/ {
  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    private Menu     mMenu     = null;
    private SubMenu[] mSubMenus;
    private int mCountSubMenu = 0;
  
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jMenu (Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       mMenu     = null;
       mSubMenus = new SubMenu[19]; //max sub menus number = 20!
       mCountSubMenu = 0;
    }
  
    public void jFree() {
        //free local objects...
        if (mMenu != null){	
        	  for(int i=0; i < mCountSubMenu; i++){
        		 mSubMenus[i] = null;
        	  }    
        	  mCountSubMenu = 0;
        	  mMenu.clear();
        }
        
    }
  
    
    //http://android-developers.blogspot.com.br/2012/01/say-goodbye-to-menu-button.html 
    /*
     * ... if you do not want an action bar: set targetSdkVersi to 13 or below ....!! 
     */
    
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ... 
    
    /*
     * The overflow icon [...] only appears on phones that have no menu hardware keys. 
     * Phones with menu keys display the action overflow when the user presses the key.
     */
    
    public void Add(Menu _menu, int _itemID, String _caption){
      if (_menu != null) {
    	  mMenu = _menu;
          _menu.add(0,_itemID,0 ,(CharSequence)_caption); //return MenuItem          
      }
    }
        
    //TODO: ic_launcher.png just for test!
    public void AddDrawable(Menu _menu, int _itemID, String _caption){
       if (_menu != null) {	
    	  mMenu = _menu;
          String _resName = "ic_launcher"; //ok       
          MenuItem item = _menu.add(0,_itemID,0 ,(CharSequence)_caption);       
          item.setIcon(GetDrawableResourceId(_resName));          
       }
    }
    
    public void AddCheckable(Menu _menu, int _itemID, String _caption){
    	if (_menu != null) {
    	  mMenu = _menu;	
          _menu.add(0,_itemID,0 ,(CharSequence)_caption).setCheckable(true);          
    	}
     }
    
    public void CheckItemCommute(MenuItem _item){
    	int flag = 0;
    	if (_item.isChecked()) flag = 1;
    	switch (flag) {
    	  case 0: _item.setChecked(false); 
    	  case 1: _item.setChecked(true);
        }
  	    //Log.i("jMenu_CheckItemCommute", _item.getTitle().toString());
    }
    
    public void CheckItem(MenuItem _item){
       _item.setChecked(true);
       //Log.i("jMenu_CheckItem", _item.getTitle().toString());
    }
    
    public void UnCheckItem(MenuItem _item){
       _item.setChecked(false);       
   	   //Log.i("jMenu_UnCheckItem", _item.getTitle().toString());
    }    
    
    public void AddSubMenu(Menu _menu, int _startItemID, String[] _captions){    	
    	int size = _captions.length;
    	if (_menu != null) {      	   	
     	  if (size > 1) {
     		 mMenu = _menu;
    	     mSubMenus[mCountSubMenu] = _menu.addSubMenu((CharSequence)_captions[0]); //main title      	  
     	     mSubMenus[mCountSubMenu].setHeaderIcon(R.drawable.ic_launcher);      	       	   
    	     for(int i=1; i < size; i++) {    	
    		   MenuItem item = mSubMenus[mCountSubMenu].add(0,_startItemID+(i-1),0,(CharSequence)_captions[i]); //sub titles...    		       	    
    	     }    	   
    	     mCountSubMenu++;    	           	
    	  }   
    	}
    }

   //TODO: ic_launcher.png just for test!
    public void AddCheckableSubMenu(Menu _menu, int _startItemID, String[] _captions){
      if (_menu != null) {	    	
    	int size = _captions.length;
    	if (size > 1) {    	
    	   mMenu = _menu;	
    	   mSubMenus[mCountSubMenu] = _menu.addSubMenu((CharSequence)_captions[0]); //main title
    	   mSubMenus[mCountSubMenu].setHeaderIcon(R.drawable.ic_launcher);       	   
    	   //Log.i("jMenu_AddCheckableSubMenu", _captions[0]);
    	   for(int i=1; i < size; i++) {    	
    		  mSubMenus[mCountSubMenu].add(0,_startItemID+(i-1),0,(CharSequence)_captions[i]).setCheckable(true); //sub titles...
    	   }    	   
    	   mCountSubMenu++;    	   
    	}
      }
    }
    
    public int Size(){
    	if (mMenu != null)
    	   return mMenu.size();
    	else 
    	  return 0;   			
    }
    
    public MenuItem FindMenuItemByID(int _itemID){
    	if (mMenu != null) return mMenu.findItem(_itemID);
    	else return null;
    }

    public MenuItem GetMenuItemByIndex(int _index){
    	if (mMenu != null)
    	   return mMenu.getItem(_index);
    	else return null;
    }
    
    public void UnCheckAllMenuItem(){
      if (mMenu != null){	
    	 for(int index=0; index < mMenu.size(); index++){
    		mMenu.getItem(index).setChecked(false);
    	 }    	 
      } 	
    }
    
    public int CountSubMenus(){
       return mCountSubMenu; 	
    } 
    
    public void UnCheckAllSubMenuItemByIndex(int _subMenuIndex){
       if (mMenu != null){	
    	  if  (_subMenuIndex < mCountSubMenu) {    		      	  
      	    for(int i=0; i < mSubMenus[_subMenuIndex].size(); i++){
      		   mSubMenus[_subMenuIndex].getItem(i).setChecked(false);
      	    }
    	 }
       } 	
    }
    
    public void RegisterForContextMenu(View _view){
       controls.activity.registerForContextMenu(_view);
    }
        
    public void UnRegisterForContextMenu(View _view){ 
      controls.activity.unregisterForContextMenu(_view); 
    }  
    
//http://daniel-codes.blogspot.com.br/2009/12/dynamically-retrieving-resources-in.html
   //Just note that in case you want to retrieve Views (Buttons, TextViews, etc.) 
    //you must implement R.id.class instead of R.drawable.
    private int GetDrawableResourceId(String _resName) {
    	  try {
    	     Class<?> res = R.drawable.class;
    	     Field field = res.getField(_resName);  //"drawableName"
    	     int drawableId = field.getInt(null);
    	     return drawableId;
    	  }
    	  catch (Exception e) {
    	     Log.e("MyTag", "Failure to get drawable id.", e);
    	     return 0;
    	  }
    }
    
    private Drawable GetDrawableResourceById(int _resID) {   	    	 
    	 return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));
    }
    
    //_itemType --> 0:Default, 1:Checkable
    public void AddItem(Menu _menu, int _itemID, String _caption, String _iconIdentifier, int _itemType, int _showAsAction){
      if (_menu != null) {
    	 mMenu = _menu;
    	 MenuItem item = _menu.add(0,_itemID,0 ,(CharSequence)_caption);    			
    	 switch  (_itemType) {
    	    case 1:  item.setCheckable(true); break;    	
    	 }    	
         if (!_iconIdentifier.equals("")) {
           item.setIcon(GetDrawableResourceId(_iconIdentifier)); 
         }                     
         switch (_showAsAction) {
           case 0: item.setShowAsAction(MenuItem.SHOW_AS_ACTION_NEVER); break;
           case 1: item.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM); break;
           case 2: item.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS); break;
           case 4: item.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM|MenuItem.SHOW_AS_ACTION_WITH_TEXT); 
                  item.setTitleCondensed("."); break;                    
           case 5: item.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS|MenuItem.SHOW_AS_ACTION_WITH_TEXT);
                  item.setTitleCondensed(".");break;
         } 	                	     
      } 
     }
    
    ////Sub menus Items: Do not support item icons, or nested sub menus.    
    public void AddItem(SubMenu _subMenu, int _itemID, String _caption, int _itemType){    	     	        
        MenuItem item = _subMenu.add(0,_itemID,0 ,(CharSequence)_caption);        
    	switch  (_itemType) {
    	  case 1:  item.setCheckable(true); break;    	
    	}                            
     }
    
    public SubMenu AddSubMenu(Menu _menu, String _title, String _headerIconIdentifier){
    	SubMenu sm = null;
    	if (_menu != null) {
    	   mMenu = _menu;	
     	   sm =_menu.addSubMenu((CharSequence)_title); //main title     	        	       	  
     	   sm.setHeaderIcon(GetDrawableResourceId(_headerIconIdentifier));
    	   mSubMenus[mCountSubMenu] = sm;      	       	     	       	       	   
    	   mCountSubMenu++; 
    	}   
    	return sm;  	    	
    }  
    
    //Request a call to onPrepareOptionsMenu so we can change the items   
    public void InvalidateOptionsMenu() {
    	controls.activity.invalidateOptionsMenu(); 
    }
    
    
    public void SetItemVisible(MenuItem _item, boolean _value){
        _item.setVisible( _value);        
    }
    
    public void SetItemVisible(Menu _menu, int _index, boolean _value){
    	if (_menu != null) {
      	  if ( _index < _menu.size() ) {
      	    MenuItem item = _menu.getItem(_index);
    	    item.setVisible( _value);    
    	  }
    	}
    }
            
    public void Clear(Menu _menu){
  	    for(int i=0; i < mCountSubMenu; i++){
    		 mSubMenus[i] = null;       	 
    	}
  	    mCountSubMenu = 0;
    	if (_menu != null) {    		    		  
        	  _menu.clear();
        	  if (mMenu != null) mMenu.clear();        
    	}	    	
    }
    
    public void Clear(){                
   	    for(int i=0; i < mCountSubMenu; i++){
   		   mSubMenus[i] = null;
   	    }
   	    mCountSubMenu = 0;
    	if (mMenu != null)  {    		      	        	        	  
    	  mMenu.clear();    	  
    	}		
    }
    
    public void SetItemTitle(MenuItem _item, String _title) {
    	_item.setTitle((CharSequence)_title);
    }
     
    public void SetItemTitle(Menu _menu, int _index,  String _title){
    	if (_menu != null)  {
    	  if ( _index < _menu.size() ) {
    	    MenuItem item = _menu.getItem(_index);
    	    item.setTitle((CharSequence)_title);
    	  }
    	}
    }
     
    public void SetItemIcon(MenuItem _item, int _iconIdentifier) {
    	_item.setIcon(_iconIdentifier);
    }
     
    public void SetItemIcon(Menu _menu, int _index,  int _iconIdentifier){
    	if (_menu != null)  {
    	  if ( _index < _menu.size() ) {
      	    MenuItem item = _menu.getItem(_index);
    	    item.setIcon(_iconIdentifier);
    	  }
    	}
    }
    
    public void SetItemChecked(MenuItem _item, boolean _value) {
    	_item.setChecked(_value);
    }
    
    public void SetItemCheckable(MenuItem _item, boolean _value) {
    	_item.setCheckable(_value);
    }   
      
    
    public int GetItemIdByIndex(Menu _menu, int _index) {
    	if ( _index < _menu.size() ) {
    	  MenuItem i = _menu.getItem(_index);    	
    	  return i.getItemId();
    	} else return -1;
    	
    }
    
    public int GetItemIndexById(Menu _menu, int _id) {
    	int r = -1;
    	if (_menu != null)  {
    	  for(int i=0; i < _menu.size(); i++)  {
    		 MenuItem item = _menu.getItem(i);    		
    	     if ( item.getItemId() == _id ) {
    	    	r = i;
    	    	break;
    	     }
    	  }
    	}
    	return r;
    }
    
    public void RemoveItemById(Menu _menu, int _id){
    	int id = GetItemIndexById(_menu, _id);
    	if (id > -1) _menu.removeItem(id);
    }
    
    public void RemoveItemByIndex(Menu _menu, int _index){
    	if (_menu != null)  {	
    	  if ( _index < _menu.size() ) {
      	    MenuItem item = _menu.getItem(_index);
    	    int id = item.getItemId();  	
    	    _menu.removeItem(id);
    	  }
    	}
    }
    
    public void SetMenu(Menu _menu) {
        if (_menu != null) {	
    	   mMenu = _menu;
        }
    }
}

