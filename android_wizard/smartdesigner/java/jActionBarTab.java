package com.example.appactionbartabdemo1;

import java.lang.reflect.Field;
import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.FragmentTransaction;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

/*Draft java code by "Lazarus Android Module Wizard"*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jActionBarTab {
		
  private long     pascalObj = 0;      // Pascal Object
  private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
  private Context  context   = null;
  private int mCountTab = 0;
  
  //Warning: please, preferentially init your news params names with "_", ex: int _flag, String _hello ...
  public jActionBarTab(Controls _ctrls, long _Self) { //Add more here new "_xxx" params if needed!
     //super(contrls.activity);
     context   = _ctrls.activity;
     pascalObj = _Self;
     controls  = _ctrls;                   
  }

  public void jFree() {
    //free local objects...        	
  }

	public ActionBar GetActionBar() { 
	    return this.controls.activity.getActionBar();
	}

	/*
	 * To disableAction-bar Icon and Title, you must do two things:
	 setDisplayShowHomeEnabled(false);  // hides action bar icon
	 setDisplayShowTitleEnabled(false); // hides action bar title
	 */

	private class TabListener implements ActionBar.TabListener {
		
		TabContentFragment mFragment;
		
		/*.*/public TabListener(TabContentFragment v) {
			mFragment = v;
		}
		//http://www.grokkingandroid.com/adding-action-items-from-within-fragments/
		//http://www.j2eebrain.com/java-J2ee-android-menus-and-action-bar.html
		//http://www.thesparkmen.com/2013/2/15/dynamic-action-bar-buttons.aspx
		//https://github.com/codepath/android_guides/wiki/Creating-and-Using-Fragments  otimo!
		//http://www.lucazanini.eu/2012/android/tab-layout-in-android-with-actionbar-and-fragment/?lang=en
	    @Override
	    /*.*/public void onTabSelected(ActionBar.Tab tab, FragmentTransaction ft) {    	  
	    	mFragment.getView().setVisibility(View.VISIBLE);	    	
	    	controls.pOnActionBarTabSelected(pascalObj, mFragment.getView(), mFragment.getText());    	    	
	    	if(mFragment.isAdded()){
	    	    ft.show(mFragment);
	    	}  
	    	else {
	    		ft.add(0, mFragment, mFragment.getText()); //0=null container!
	    	}     	   	
	    }
	 
	    @Override
	    /*.*/public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction ft) {	    	
	    	//mFragment.getView().setVisibility(View.GONE);	    	
	    	controls.pOnActionBarTabUnSelected(pascalObj, mFragment.getView(), mFragment.getText());	    		    
	    	if (mFragment != null) {
	             ft.hide(mFragment);
	         }	    	
	    }
	 
	    @Override
	    /*.*/public void onTabReselected(ActionBar.Tab tab, FragmentTransaction ft) {
	    }
	}

	private ActionBar.Tab CreateTab(String title, View v) {	  	
	  ActionBar actionBar = this.controls.activity.getActionBar();
	  ActionBar.Tab tab = actionBar.newTab();           
	  tab.setText(title);

	  if (mCountTab != 0) {
	     v.setVisibility(View.INVISIBLE);
	  }

	  TabContentFragment content = new TabContentFragment();
	  content.setTabContentFragment(v, title);

	  tab.setTabListener(new TabListener(content)); // All tabs must have a TabListener set before being added to the ActionBar.
	  mCountTab= mCountTab + 1;
	  return tab; 
	}

	//This method adds a tab for use in tabbed navigation mode
	public void Add(String _title, View _panel, String _iconIdentifier){
		  ActionBar.Tab tab = CreateTab(_title, _panel);  
		  if (!_iconIdentifier.equals("")) {
			  tab.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_iconIdentifier))); //_iconIdentifier
		  }
		  ActionBar actionBar = this.controls.activity.getActionBar();
		  actionBar.addTab(tab, false);		  
	}

	public void Add(String _title, View _panel){
		  ActionBar.Tab tab = CreateTab(_title, _panel);  	 
		  ActionBar actionBar = this.controls.activity.getActionBar();	
	  	  actionBar.addTab(tab, false);  	    	 
	}

	public void Add(String _title, View _panel, View _customTabView){ //BUG!!!
		 ActionBar.Tab tab = CreateTab(_title, _panel);

		  _customTabView.setVisibility(View.VISIBLE);
		//ViewGroup parent = (ViewGroup)_customTabView.getParent();
		//if (parent != null) parent.removeView(_customTabView);
		//tab.setIcon(controls.GetDrawableResourceById(controls.GetDrawableResourceId("ic_launcher"))); //dummy
		tab.setCustomView(_customTabView);	//This overrides values set by setText(CharSequence) and setIcon(Drawable).

		ActionBar actionBar = this.controls.activity.getActionBar();
		actionBar.addTab(tab, false);
	}

	public void SetTabNavigationMode(){
		ActionBar actionBar = this.controls.activity.getActionBar();
		actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);	//API 11
		actionBar.setSelectedNavigationItem(0);
	}

	//This method remove all tabs from the action bar and deselect the current tab
	public void RemoveAllTabs() {
		ActionBar actionBar = this.controls.activity.getActionBar();
		actionBar.removeAllTabs();
	}
	
	//This method returns the currently selected tab if in tabbed navigation mode and there is at least one tab present
	public Tab GetSelectedTab() {
		ActionBar actionBar = this.controls.activity.getActionBar();
		ActionBar.Tab tab = actionBar.getSelectedTab();
		return tab;
	}

	//This method select the specified tab
	public void SelectTab(ActionBar.Tab tab){
		ActionBar actionBar = this.controls.activity.getActionBar();
		actionBar.selectTab(tab);
	}	
	
	public Tab GetTabAtIndex(int _index){
		ActionBar actionBar = this.controls.activity.getActionBar();
		if (_index < actionBar.getTabCount()) {
			actionBar.setSelectedNavigationItem(_index);
			return actionBar.getTabAt(_index);
		}
		else return null;
	}
		
	public void SelectTabByIndex(int _index){
		ActionBar actionBar = this.controls.activity.getActionBar();
		if (_index < actionBar.getTabCount())
	    	actionBar.setSelectedNavigationItem(_index);
	}
	
}
