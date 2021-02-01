package org.lamw.appnoguidemo1;

import android.os.Bundle;
import android.app.Activity;
import android.widget.Toast;
import android.util.Log;
 
//HINT: You can change/edit "App.java" and "AppNoGUIDemo1.java" 
//to accomplish/fill  yours requirements...
 
public class App extends Activity {
  
   AppNoGUIDemo1 mAppNoGUIDemo1;  //just for demo...
  
   @Override
   protected void onCreate(Bundle savedInstanceState) {
       super.onCreate(savedInstanceState);
       setContentView(R.layout.activity_app);

       mAppNoGUIDemo1 = new AppNoGUIDemo1(); //just for demo...

       int sum = mAppNoGUIDemo1.getSum(2,3); //just for demo...
       Toast.makeText(getApplicationContext(), "mAppNoGUIDemo1.getSum(2,3) = "+ sum,Toast.LENGTH_LONG).show();
 
       String mens = mAppNoGUIDemo1.getString(1); //just for demo...
       Toast.makeText(getApplicationContext(), "mAppNoGUIDemo1.getString(1) = "+ mens,Toast.LENGTH_LONG).show();
 
   }
}
