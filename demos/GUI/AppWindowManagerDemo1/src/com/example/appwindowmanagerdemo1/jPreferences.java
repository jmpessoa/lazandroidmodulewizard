package com.example.appwindowmanagerdemo1;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

/*Draft java code by "Lazarus Android Module Wizard" [8/13/2014 1:43:12]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

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
       
       if (_IsShared) { 
          mPreferences = PreferenceManager.getDefaultSharedPreferences(context);
       }
       else {
          mPreferences = _ctrls.activity.getPreferences(Context.MODE_PRIVATE);
       }
       
    }

    public void jFree() {
      //free local objects...
    	mPreferences = null;
    }

  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
   public int GetIntData(String _key, int _defaultValue) {
		return mPreferences.getInt(_key, _defaultValue);
	}

	public void SetIntData(String _key, int _value) {
		SharedPreferences.Editor edt = mPreferences.edit();
		edt.putInt(_key, _value);
		edt.commit();
	}

	public String GetStringData(String _key, String _defaultValue) {
		return mPreferences.getString(_key, _defaultValue);
	}

	public void SetStringData(String _key, String _value) {
		SharedPreferences.Editor edt = mPreferences.edit();
		edt.putString(_key, _value);
		edt.commit();
	}

	public boolean GetBoolData(String _key, boolean _defaultValue) {
		return mPreferences.getBoolean(_key, _defaultValue);
	}

	public void SetBoolData(String _key, boolean _value) {
		SharedPreferences.Editor edt = mPreferences.edit();
		edt.putBoolean(_key, _value);
		edt.commit();
	}
}

