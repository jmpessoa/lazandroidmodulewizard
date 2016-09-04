package com.example.appactivitylauncherdemo1;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class MyActivity1 extends Activity {
	
	private android.widget.RelativeLayout mLayout;	
		
	int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
	int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w
		
	public int dataNumber;
    
    public MyActivity1() {    	
       super();  	 	      
    }
        
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        Intent i = this.getIntent();        
        dataNumber = i.getIntExtra("DATA_NUMBER", 0);        
        mLayout = new android.widget.RelativeLayout(this);        
        this.setContentView(mLayout);
    }
       
    @Override
    public void onContentChanged() {    	
        
        TextView text = new TextView(this);
        text.setId(1);
        text.setText("Hello from MyActivity1! Number Received" + ": "+ dataNumber);
        
        android.widget.RelativeLayout.LayoutParams lparams1 = new android.widget.RelativeLayout.LayoutParams(
        		RelativeLayout.LayoutParams.WRAP_CONTENT,RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H
        
        lparams1.addRule(RelativeLayout.CENTER_HORIZONTAL);
        lparams1.addRule(RelativeLayout.ALIGN_TOP);        
        text.setLayoutParams(lparams1);
        
        mLayout.addView(text);        
        
        Button button = new Button(this);  
        button.setText("Send Double Of [ "+ dataNumber +" ]");
        
        android.widget.RelativeLayout.LayoutParams lparams2 = new android.widget.RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT,
        		                                                                      RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H        
        lparams2.addRule(RelativeLayout.CENTER_HORIZONTAL); //parent       
        lparams2.addRule(RelativeLayout.BELOW, text.getId());   //anchor
        
        button.setLayoutParams(lparams2);        
        
        mLayout.addView(button);      
        
        button.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {                              
               Intent intent= new Intent();                
               // put the message to return as result in Intent
               intent.putExtra("DATA_MESSAGE", "Hello Pascal!");
               intent.putExtra("DOUBLE_DATA_NUMBER", 2*dataNumber);               
               // Set The Result in Intent
               setResult(Activity.RESULT_OK,intent);
               // finish The activity 
               finish();    	
            }
        });
                
    }
                
}
