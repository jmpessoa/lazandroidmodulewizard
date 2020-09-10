package org.lamw.appwidgetproviderdemo1;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.widget.TextView;
import android.widget.Button;
import android.view.Gravity;
import android.graphics.Typeface;
import android.graphics.Color;

//--- Revised 2020/09/09 [by ADiV] ---//

public class jDialogYN {
 //Java-Pascal Interface
 private long             PasObj  = 0;      // Pascal Obj
 private Controls        controls = null;   // Control Class for Event
 //
 private String          dlgTitle;
 private String          dlgMsg;
 private String          dlgYes;
 private String          dlgNo;
 private String          dlgNeutral;
 
 private int 			 mFontSize;   // by tr3e
 private int			 mTitleAlign; // by tr3e
 //
 private DialogInterface.OnClickListener onClickListener = null;
 private AlertDialog dialog = null;

 //Constructor
 public  jDialogYN(android.content.Context context,
              Controls ctrls, long pasobj,
              String title, String msg, String _strYes, String _strNo ) {
  //Connect Pascal I/F
  PasObj   = pasobj;
  controls = ctrls;
  
  //
  dlgTitle = title;
  dlgMsg   = msg;
  dlgYes   = _strYes;
  dlgNo    = _strNo;
  dlgNeutral = "Cancel";
  
  mFontSize = 0;

  //Init Event
  onClickListener = new DialogInterface.OnClickListener() {
   public  void onClick(DialogInterface dialog, int id) {
    controls.pOnClick(PasObj, id );
   };
  };
}

public  void show(String titleText, String msgText, String yesText, String noText) {
	   //Log.i("java","DlgYN_Show");
	dlgTitle = titleText;
	dlgMsg   = msgText;
	dlgYes   = yesText;
	dlgNo    = noText;

	if (dlgYes.equals("")) dlgYes ="Yes";
	if (dlgNo.equals("")) dlgNo ="No";
	
	AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
		
	TextView title = new TextView(controls.activity);
	
	if( title != null ){
     title.setText(dlgTitle);
     title.setPadding(30, 10, 30, 10);
     title.setTextColor(Color.BLACK);
     title.setTypeface(null, Typeface.BOLD);
    
     //title.setBackgroundResource(R.drawable.gradient);
     //title.setTextColor(0xFF0000FF);
    
     switch( mTitleAlign ){ 
      case 0 : title.setGravity(Gravity.LEFT); break;
      case 1 : title.setGravity(Gravity.RIGHT); break;
      case 2 : title.setGravity(Gravity.CENTER); break;
     }
    
     if( mFontSize != 0)
      title.setTextSize(mFontSize);
     
     builder.setCustomTitle(title);
	} else
     builder.setTitle(dlgTitle);
    	
	builder.setMessage       (dlgMsg  )
	       .setCancelable    (false)
	       .setPositiveButton(dlgYes,onClickListener)
	       .setNegativeButton(dlgNo,onClickListener);
	dialog = builder.create();	

	dialog.show();
	
	if( mFontSize != 0){
		  dialog.getWindow().getAttributes();		  
			 
		  TextView tvMessage = (TextView) dialog.findViewById(android.R.id.message);
		  
		  if( tvMessage != null ){
		   tvMessage.setPadding(30, 10, 30, 10);
		   tvMessage.setTextSize(mFontSize);
		  }
		 
		  Button btNegative = dialog.getButton(DialogInterface.BUTTON_NEGATIVE);
		  
		  if( btNegative != null )
		   btNegative.setTextSize(mFontSize);
		 
		  Button btPositive = dialog.getButton(DialogInterface.BUTTON_POSITIVE);
		  
		  if( btPositive != null )
		   btPositive.setTextSize(mFontSize);
		 }
}

public  void show(String titleText, String msgText, String yesText, String noText, String neutralText) {
	   //Log.i("java","DlgYN_Show");
	dlgTitle = titleText;
	dlgMsg   = msgText;
	dlgYes     = yesText;
	dlgNo      = noText;
	dlgNeutral = neutralText;

	if (dlgYes.equals("")) dlgYes ="Yes";
	if (dlgNo.equals("")) dlgNo ="No";
	if (dlgNeutral.equals("")) dlgNeutral ="Cancel";
	
	AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
		
	TextView title = new TextView(controls.activity);
	
	if( title != null ){
     title.setText(dlgTitle);
     title.setPadding(30, 10, 30, 10);
     title.setTextColor(Color.BLACK);
     title.setTypeface(null, Typeface.BOLD);
 
     //title.setBackgroundResource(R.drawable.gradient);
     //title.setTextColor(0xFF0000FF);
 
     switch( mTitleAlign ){ 
      case 0 : title.setGravity(Gravity.LEFT); break;
      case 1 : title.setGravity(Gravity.RIGHT); break;
      case 2 : title.setGravity(Gravity.CENTER); break;
     }
 
     if( mFontSize != 0)
      title.setTextSize(mFontSize);
  
     builder.setCustomTitle(title);
	} else
     builder.setTitle(dlgTitle);
 	
	builder.setMessage       (dlgMsg  )
	       .setCancelable    (false)
	       .setPositiveButton(dlgYes,onClickListener)	       
	       .setNegativeButton(dlgNo,onClickListener)
	       .setNeutralButton(dlgNeutral,onClickListener);
	
	dialog = builder.create();	

	dialog.show();
	
	if( mFontSize != 0){
		  dialog.getWindow().getAttributes();		  
			 
		  TextView tvMessage = (TextView) dialog.findViewById(android.R.id.message);
		  
		  if( tvMessage != null ){
		   tvMessage.setPadding(30, 10, 30, 10);
		   tvMessage.setTextSize(mFontSize);
		  }
		 
		  Button btNegative = dialog.getButton(DialogInterface.BUTTON_NEGATIVE);
		  
		  if( btNegative != null )
		   btNegative.setTextSize(mFontSize);
		 
		  Button btPositive = dialog.getButton(DialogInterface.BUTTON_POSITIVE);
		  
		  if( btPositive != null )
		   btPositive.setTextSize(mFontSize);
		  
          Button btNeutral = dialog.getButton(DialogInterface.BUTTON_NEUTRAL);
		  
		  if( btNeutral != null )
			  btNeutral.setTextSize(mFontSize);
		 }
}


public void ShowOK(String titleText, String msgText, String _OkText) {
	   //Log.i("java","DlgYN_Show");
	dlgTitle = titleText;
	dlgMsg   = msgText;	
	AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
	
	TextView title = new TextView(controls.activity);
	
	if( title != null ){
     title.setText(dlgTitle);
     title.setPadding(30, 10, 30, 10);
     title.setTextColor(Color.BLACK);
     title.setTypeface(null, Typeface.BOLD);
    
     switch( mTitleAlign ){ 
      case 0 : title.setGravity(Gravity.LEFT); break;
      case 1 : title.setGravity(Gravity.RIGHT); break;
      case 2 : title.setGravity(Gravity.CENTER); break;
     }
    
     if( mFontSize != 0)
    	  title.setTextSize(mFontSize);
     
     builder.setCustomTitle(title);
	} else
     builder.setTitle(dlgTitle);
	
	builder.setMessage       (dlgMsg  )
	       .setCancelable    (false)	       
	       .setPositiveButton(_OkText, onClickListener);
	       	      
	dialog = builder.create();
	
	dialog.show();
	
	if( mFontSize != 0){
		  dialog.getWindow().getAttributes();
		    		  			
		  TextView tvMessage = (TextView) dialog.findViewById(android.R.id.message);
		  
		  if( tvMessage != null ){
		   tvMessage.setPadding(30, 10, 30, 10);
		   tvMessage.setTextSize(mFontSize);
		  }
		 
		  Button btPositive = dialog.getButton(DialogInterface.BUTTON_POSITIVE);
		  
		  if( btPositive != null)
		   btPositive.setTextSize(mFontSize);		 		 
		 }
}

// by tr3e
public void SetFontSize( int _fontSize ){
	mFontSize = _fontSize;
}

// by tr3e
public void SetTitleAlign( int _titleAlign ){
	mTitleAlign = _titleAlign;
}

public  void Free() {
 onClickListener = null;
 
 dialog.setTitle("");
 dialog.setIcon(null);
 
 dialog = null;
}

}

