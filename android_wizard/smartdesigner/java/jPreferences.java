package com.example.appchronometerdemo1;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

/*Draft java code by "Lazarus Android Module Wizard" [8/13/2014 1:43:12]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//-------------------------------------------------------------------------
// jPreferences
// Developed by ADiV for LAMW on 2021-03-03
//-------------------------------------------------------------------------

public class jPreferences /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    
    private SharedPreferences mPreferences;
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jPreferences(Controls _ctrls, long _Self, boolean _IsShared) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       
       if (_IsShared) 
          mPreferences = PreferenceManager.getDefaultSharedPreferences(context);       
       else
          mPreferences = _ctrls.activity.getPreferences(Context.MODE_PRIVATE);             
    }

    public void jFree() {
      //free local objects...
    	mPreferences = null;
    }

  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
   public int GetIntData(String _key, int _defaultValue) {
	   
	   if( mPreferences != null )
		   return mPreferences.getInt(_key, _defaultValue);
	   else
		   return _defaultValue;
	   
	}

	public void SetIntData(String _key, int _value) {
		if( mPreferences == null ) return;
		
		SharedPreferences.Editor edt = mPreferences.edit();
		
		if( edt == null ) return;
		
		edt.putInt(_key, _value);
		edt.commit();		
	}
	
	public long GetLongData(String _key, long _defaultValue) {
		   
		   if( mPreferences != null )
			   return mPreferences.getLong(_key, _defaultValue);
		   else
			   return _defaultValue;
		   
	}

	public void SetLongData(String _key, long _value) {
			if( mPreferences == null ) return;
			
			SharedPreferences.Editor edt = mPreferences.edit();
			
			if( edt == null ) return;
			
			edt.putLong(_key, _value);
			edt.commit();			
	}
	
	public float GetFloatData(String _key, float _defaultValue) {
		   
		   if( mPreferences != null )
			   return mPreferences.getFloat(_key, _defaultValue);
		   else
			   return _defaultValue;
		   
	}

	public void SetFloatData(String _key, float _value) {
			if( mPreferences == null ) return;
			
			SharedPreferences.Editor edt = mPreferences.edit();
			
			if( edt == null ) return;
			
			edt.putFloat(_key, _value);
			edt.commit();			
	}

	public String GetStringData(String _key, String _defaultValue) {
		
		if( mPreferences != null )
				return mPreferences.getString(_key, _defaultValue);
		else
			    return _defaultValue;
		
	}

	public void SetStringData(String _key, String _value) {
		
		if( mPreferences == null ) return;
		
		SharedPreferences.Editor edt = mPreferences.edit();
		
		if( edt == null ) return;
		
		edt.putString(_key, _value);
		edt.commit();		
	}

	public boolean GetBoolData(String _key, boolean _defaultValue) {
		
		if( mPreferences != null )
				return mPreferences.getBoolean(_key, _defaultValue);
		else
			   	return _defaultValue;
	}

	public void SetBoolData(String _key, boolean _value) {
		
		if( mPreferences == null ) return;
		
		SharedPreferences.Editor edt = mPreferences.edit();
		
		if( edt == null ) return;
		
		edt.putBoolean(_key, _value);
		edt.commit();		
	}
	
    public void Clear() {
		
		if( mPreferences == null ) return;
		
		SharedPreferences.Editor edt = mPreferences.edit();
		
		if( edt == null ) return;
		
		edt.clear();
		edt.commit();
	}
    
    public void Remove(String _key) {
		
		if( mPreferences == null ) return;
		
		SharedPreferences.Editor edt = mPreferences.edit();
		
		if( edt == null ) return;
		
		edt.remove(_key);
		edt.commit();		
	}
}

