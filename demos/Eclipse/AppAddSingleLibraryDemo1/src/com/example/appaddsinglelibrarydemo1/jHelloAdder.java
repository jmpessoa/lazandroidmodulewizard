package com.example.appaddsinglelibrarydemo1;

/*Draft java code by "Lazarus Android Module Wizard" [2/22/2015 0:34:05]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/
 
public class jHelloAdder /*extends ...*/ {
  
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    //private Context  context   = null;
  
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jHelloAdder(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       //context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }
  
    public void jFree() {
      //free local objects...
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
   public native int Add(int _a, int _b);
                       
   public native String StringUpperCase(String _str);
	 
   static {
	    System.loadLibrary("jhelloadder");
   }  
   
}

