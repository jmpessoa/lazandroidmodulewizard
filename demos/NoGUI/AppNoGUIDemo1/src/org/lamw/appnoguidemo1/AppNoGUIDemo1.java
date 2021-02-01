package org.lamw.appnoguidemo1;

//HINT: You can change/edit "App.java" and "AppNoGUIDemo1.java"
//to accomplish/fill  yours requirements...

public class AppNoGUIDemo1 {

  public native String getString(int flag);  //just for demo...
  public native int getSum(int x, int y);    //just for demo...

  static {
	  try {
	      System.loadLibrary("appnoguidemo1");
	  } catch(UnsatisfiedLinkError ule) {
	      ule.printStackTrace();
	  }
  }

}
