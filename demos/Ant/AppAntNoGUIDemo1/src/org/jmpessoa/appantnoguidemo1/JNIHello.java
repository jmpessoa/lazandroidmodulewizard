package org.jmpessoa.appantnoguidemo1;
 
public class JNIHello { //just for demo...
 
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
