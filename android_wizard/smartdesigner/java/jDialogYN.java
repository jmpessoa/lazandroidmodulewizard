package org.lamw.appwidgetproviderdemo1;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.widget.TextView;
import android.widget.Button;
import android.view.Gravity;
import android.graphics.Typeface;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;

//-------------------------------------------------------------------------
// jDialogYN
// Developed by ADiV for LAMW on 2021-03-05
//-------------------------------------------------------------------------

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
 
 private int 			 mFontSize;   // by ADiV
 private int			 mTitleAlign; // by ADiV
 
 private int			 mColorBackground      = Color.WHITE;
 private int			 mColorBackgroundTitle = 0;
 private int			 mColorTitle      = Color.BLACK;
 private int			 mColorText       = Color.BLACK;
 private int			 mColorPositive   = 0;
 private int			 mColorNegative   = 0;
 private int			 mColorNeutral    = 0;
 
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
     title.setTextColor(mColorTitle);
     title.setTypeface(null, Typeface.BOLD);
     
     if(android.os.Build.VERSION.SDK_INT < 21)
      if(mColorBackgroundTitle != 0)
    	  title.setBackgroundColor(mColorBackgroundTitle);
      else
    	  title.setBackgroundColor(mColorBackground);
    
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
	
	if(android.os.Build.VERSION.SDK_INT >= 21)	    
	    dialog.getWindow().setBackgroundDrawable(new ColorDrawable(mColorBackground));	  
	 
	if( mFontSize != 0){
		  dialog.getWindow().getAttributes();		  
			 
		  TextView tvMessage = (TextView) dialog.findViewById(android.R.id.message);		 		 
		  
		  if( tvMessage != null ){
		   tvMessage.setTextColor(mColorText);   
		   tvMessage.setPadding(30, 10, 30, 10);
		   tvMessage.setTextSize(mFontSize);
		   
		   if(android.os.Build.VERSION.SDK_INT < 21)
			   tvMessage.setBackgroundColor(mColorBackground);
		  }
		 
		  Button btNegative = dialog.getButton(DialogInterface.BUTTON_NEGATIVE);		  
		  
		  if( btNegative != null ){
		   if(mColorNegative != 0) btNegative.setTextColor(mColorNegative);
		   btNegative.setTextSize(mFontSize);
		   
		   if(android.os.Build.VERSION.SDK_INT < 21)
		    btNegative.setBackgroundColor(mColorBackground);
		  }
		 
		  Button btPositive = dialog.getButton(DialogInterface.BUTTON_POSITIVE);
		  
		  if( btPositive != null )
		   if(mColorPositive != 0) btPositive.setTextColor(mColorPositive);
		   btPositive.setTextSize(mFontSize);
		   
		   if(android.os.Build.VERSION.SDK_INT < 21)
		    btPositive.setBackgroundColor(mColorBackground);
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
     title.setTextColor(mColorTitle);
     title.setTypeface(null, Typeface.BOLD);
     
     if(android.os.Build.VERSION.SDK_INT < 21)
         if(mColorBackgroundTitle != 0)
       	  title.setBackgroundColor(mColorBackgroundTitle);
         else
       	  title.setBackgroundColor(mColorBackground);
 
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
	
	if(android.os.Build.VERSION.SDK_INT >= 21)
		 dialog.getWindow().setBackgroundDrawable(new ColorDrawable(mColorBackground));
	
	if( mFontSize != 0){
		  dialog.getWindow().getAttributes();		  
			 
		  TextView tvMessage = (TextView) dialog.findViewById(android.R.id.message);
		  
		  if( tvMessage != null ){
		   tvMessage.setTextColor(mColorText);
		   tvMessage.setPadding(30, 10, 30, 10);
		   tvMessage.setTextSize(mFontSize);
		   
		   if(android.os.Build.VERSION.SDK_INT < 21)
			   tvMessage.setBackgroundColor(mColorBackground);
		  }
		 
		  Button btNegative = dialog.getButton(DialogInterface.BUTTON_NEGATIVE);
		  
		  if( btNegative != null ){
			  if(mColorNegative != 0) btNegative.setTextColor(mColorNegative);
			  btNegative.setTextSize(mFontSize);
			  
			  if(android.os.Build.VERSION.SDK_INT < 21)
				  btNegative.setBackgroundColor(mColorBackground);
		  }
		 
		  Button btPositive = dialog.getButton(DialogInterface.BUTTON_POSITIVE);
		  
		  if( btPositive != null ){
			  if(mColorPositive != 0) btPositive.setTextColor(mColorPositive);
			  btPositive.setTextSize(mFontSize);
			  
			  if(android.os.Build.VERSION.SDK_INT < 21)
				  btPositive.setBackgroundColor(mColorBackground);
		  }
		  
          Button btNeutral = dialog.getButton(DialogInterface.BUTTON_NEUTRAL);
		  
		  if( btNeutral != null )
			  if(mColorNeutral != 0) btNeutral.setTextColor(mColorNeutral);
			  btNeutral.setTextSize(mFontSize);
			  
			  if(android.os.Build.VERSION.SDK_INT < 21)
				  btNeutral.setBackgroundColor(mColorBackground);
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
     title.setTextColor(mColorTitle);
     title.setTypeface(null, Typeface.BOLD);
     
     if(android.os.Build.VERSION.SDK_INT < 21)
         if(mColorBackgroundTitle != 0)
       	  title.setBackgroundColor(mColorBackgroundTitle);
         else
       	  title.setBackgroundColor(mColorBackground);
    
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
	
	if(android.os.Build.VERSION.SDK_INT >= 21)   	 
		 dialog.getWindow().setBackgroundDrawable(new ColorDrawable(mColorBackground));
	
	if( mFontSize != 0){
		  dialog.getWindow().getAttributes();
		    		  			
		  TextView tvMessage = (TextView) dialog.findViewById(android.R.id.message);
		  
		  if( tvMessage != null ){
		   tvMessage.setTextColor(mColorText);
		   tvMessage.setPadding(30, 10, 30, 10);
		   tvMessage.setTextSize(mFontSize);
		   
		   if(android.os.Build.VERSION.SDK_INT < 21)
			   tvMessage.setBackgroundColor(mColorBackground);
		  }
		 
		  Button btPositive = dialog.getButton(DialogInterface.BUTTON_POSITIVE);
		  
		  if( btPositive != null)
			  if(mColorPositive != 0) btPositive.setTextColor(mColorPositive);
		   	  btPositive.setTextSize(mFontSize);
		   	  
		   	  if(android.os.Build.VERSION.SDK_INT < 21)
		   		btPositive.setBackgroundColor(mColorBackground);
		 }
}

// by ADiV
public void SetFontSize( int _fontSize ){
	mFontSize = _fontSize;
}

// by ADiV
public void SetTitleAlign( int _titleAlign ){
	mTitleAlign = _titleAlign;
}

// by ADiV
public void SetColorBackground( int _color ){	
	mColorBackground      = _color;
}

//by ADiV
public void SetColorBackgroundTitle( int _color ){
	mColorBackgroundTitle = _color;
}

//by ADiV
public void SetColorTitle( int _color ){
	mColorTitle = _color;
}

//by ADiV
public void SetColorText( int _color ){
	mColorText = _color;
}

//by ADiV
public void SetColorNegative( int _color ){
	mColorNegative = _color;
}

//by ADiV
public void SetColorPositive( int _color ){
	mColorPositive = _color;
}

//by ADiV
public void SetColorNeutral( int _color ){
	mColorNeutral = _color;
}


public  void Free() {
 onClickListener = null;
 
 dialog.setTitle("");
 dialog.setIcon(null);
 
 dialog = null;
}

}

