package org.jmpessoa.appantnoguidemo1;
 
import android.os.Bundle;
import android.app.Activity;
import android.widget.Toast;
 
public class App extends Activity {
  
   JNIHello myHello;  //just for demo...
  
   @Override
   protected void onCreate(Bundle savedInstanceState) {
       super.onCreate(savedInstanceState);
       setContentView(R.layout.activity_app);
 
       myHello = new JNIHello(); //just for demo...
 
       int sum = myHello.getSum(2,3); //just for demo...
 
       String mens = myHello.getString(1); //just for demo...
 
       Toast.makeText(getApplicationContext(), mens, Toast.LENGTH_SHORT).show();
       Toast.makeText(getApplicationContext(), "Total = " + sum, Toast.LENGTH_SHORT).show();
   }
}
