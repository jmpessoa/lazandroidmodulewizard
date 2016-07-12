package com.example.apptrycode1;

import android.content.Context;
import android.widget.Toast;

/*Draft java code by "Lazarus Android Module Wizard"*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jMyHello /*extends ...*/ {         

        private long     pascalObj = 0;      // Pascal Object
        private Controls controls  = null;   // Control Class for events
        private Context  context   = null;

        private int    mFlag = 0;          // <<----- custom property
        private String mMsgHello = ""; // <<----- custom property 
        private int[]  mBufArray;      // <<----- custom property

        public jMyHello(Controls _ctrls, long _Self, int _flag, String _hello) { //Add more '_xxx' params if needed!

          //super(_ctrls.activity);
          context   = _ctrls.activity;
          pascalObj = _Self;
          controls  = _ctrls;

          mFlag = _flag;
          mMsgHello = _hello;
          mBufArray = null;
          //Log.i("jMyHello", "Create!");          
        }

        public void jFree() {
          //free local objects...
           mBufArray = null;
        }

       //write others [public] methods code here......  <<----- customs methods

        public void SetFlag(int _flag) {  
           mFlag =  _flag;   
        }

        public int GetFlag() {
           return mFlag;   
        }

        public void SetHello(String _hello) {
        	mMsgHello =  _hello;   
        }

        public String GetHello() {
           return mMsgHello;   
        }
        
        public String[] GetStringArray() { 
        	String[] strArray = {"Helo", "Pascal", "World"};
            return strArray;   
        }
        
        
        public String[] ToUpperStringArray(String[] _msgArray) { 
        	int size = _msgArray.length;
        	String[] resStr = new String[size];
        	for (int i = 0; i < size; i++) {
        		resStr[i]= _msgArray[i].toUpperCase();
        	}
            return resStr;   
        }
      
        public String[] ConcatStringArray(String[]  _strArrayA, String[]  _strArrayB) {
        	
        	int size1 = _strArrayA.length;
        	int size2 = _strArrayB.length;
        	
        	String[] resStr = new String[size1+size2];
        	
        	for (int i = 0; i < size1; i++) {
        	  resStr[i]= _strArrayA[i];
        	}
        	
        	int j = size1;
        	for (int i = 0; i < size2; i++) {
        	  resStr[j]= _strArrayB[i];
        	  j++;
        	}
        	
            return resStr;
        }
        
        public int[] GetIntArray() {
        	int[] mIntArray = {1, 2, 3};
            return mIntArray;
        }

        public int[] GetSumIntArray(int[] _vA, int[] _vB, int _size) {

           mBufArray = new int[_size];

           for (int i=0; i < _size; i++) {
              mBufArray[i] = _vA[i] + _vB[i];
           }
           return mBufArray;
        }
                
        public void ShowHello() {
           Toast.makeText(controls.activity, mMsgHello, Toast.LENGTH_SHORT).show();  	      
        }        
}

