package com.example.appmenudemo;

import java.lang.reflect.Field;
import java.util.ArrayList;

import android.content.Context;
import android.util.Log;
import android.view.ContextMenu;
import android.view.MenuItem;
import android.view.View;

/*Draft java code by "Lazarus Android Module Wizard" [4-5-14 20:46:56]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/
public class jContextMenu /*extends ...*/ {
  
    private long pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    private ContextMenu  mMenu = null;
    private ArrayList<String>    mItemList;
    
    private String mHeaderTitle;
    private String mHeaderIconIdentifier;
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jContextMenu(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       mMenu     = null;
       mItemList = new ArrayList<String>();
    }
  
    public void jFree() {
        //free local objects...
    	mMenu = null;
    	mItemList.clear();
    	mItemList = null;    	    	
    }
      
    public int CheckItemCommute(MenuItem _item){
    	int flag = 0;
    	
    	int id = _item.getItemId();
    	if (_item.isChecked()) flag = 1;
    	switch (flag) {
    	  case 0: _item.setChecked(false);
    	           mItemList.remove(Integer.toString(id));                   
    	  break; 
    	  case 1: _item.setChecked(true);
    	          mItemList.remove(Integer.toString(id));
    	          mItemList.add(Integer.toString(id)); 
    	  break;
        }
  	   return id;
    }
    
    public int CheckItem(MenuItem _item){
       _item.setChecked(true);
       int id = _item.getItemId();
       mItemList.remove(Integer.toString(id));
       mItemList.add(Integer.toString(id));
       return  id;
    }
    
    public int UnCheckItem(MenuItem _item){
      _item.setChecked(false);       
      int id =_item.getItemId();
      mItemList.remove(Integer.toString(id));
      return id;
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
    	 mItemList.clear();
      } 	
    }
        
    public void RegisterForContextMenu(View _view){
       controls.activity.registerForContextMenu(_view);
    }   
    
    public void UnRegisterForContextMenu(View _view){ 
      controls.activity.unregisterForContextMenu(_view); 
   }        
 
    //_itemType --> 0:Default, 1:Checkable
    public MenuItem AddItem(ContextMenu _menu, int _itemID, String _caption, int _itemType){    	     	
    	MenuItem item = _menu.add(0,_itemID,0 ,(CharSequence)_caption);

    	switch  (_itemType) {
    	case 1:  item.setCheckable(true); break;    	
    	}
    	                      
  	    if (mMenu == null) mMenu = _menu;
  	   
  	    return item;
    }
    
    private int GetDrawableResourceId(String _resName) {
  	  try {
  	     Class<?> res = R.drawable.class;
  	     Field field = res.getField(_resName);  //"drawableName"
  	     int drawableId = field.getInt(null);
  	     return drawableId;
  	  }
  	  catch (Exception e) {
  	     Log.e("jContextMenu_error", "Failure to get drawable id.", e);
  	     return 0;
  	  }
    }
    
    public void SetHeader(ContextMenu _menu, String _title, String _iconIdentifier){
    	mHeaderTitle = _title;
    	mHeaderIconIdentifier = _iconIdentifier;
  	   _menu.setHeaderTitle((CharSequence)_title);
  	   _menu.setHeaderIcon(GetDrawableResourceId(_iconIdentifier));
  	   if (mMenu == null) mMenu = _menu;
    }
    
    public void SetHeaderTitle(String _title){    	     	  
   	   mHeaderTitle = _title;
   	   if (mMenu != null) {
   		   mMenu.setHeaderTitle((CharSequence)_title);
   	   }   	   
     }
    
    public void SetHeaderIconByIdentifier(String _iconIdentifier){    	     	  
   	   mHeaderIconIdentifier = _iconIdentifier;
   	   if (mMenu != null) {
   		  mMenu.setHeaderIcon(GetDrawableResourceId(_iconIdentifier));
   	   }
     }    
    
    public boolean IsItemChecked(int _itemID) {
    	boolean res = false; 
    	if (mItemList.size() > 0)  {
    		if ( mItemList.indexOf( Integer.toString(_itemID)) >= 0  ) res = true; 	
    	}    	
    	return res;
    }           
}

