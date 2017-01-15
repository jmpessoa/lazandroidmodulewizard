package com.example.appnoguidemo1;

public class JNIHello {
	
	  public native String getString(int flag);
	  public native int getSum(int x, int y);
	 
	  static {
		  try {
		      System.loadLibrary("jnihello");
		  } catch(UnsatisfiedLinkError ule) {
		      ule.printStackTrace();
		  }
	  }

}
