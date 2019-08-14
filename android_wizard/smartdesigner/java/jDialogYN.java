package org.lamw.appwidgetproviderdemo1;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.widget.TextView;
import android.widget.Button;
import android.view.Gravity;

class YNConst {
  public static final int Click_Yes = -1;
  public static final int Click_No  = -2;
}

//Revised 08/14/2019 [by TR3E]

public class jDialogYN {
 //Java-Pascal Interface
 private long             PasObj  = 0;      // Pascal Obj
 private Controls        controls = null;   // Control Class for Event
 //
 private String          dlgTitle;
 private String          dlgMsg;
 private String          dlgY;
 private String          dlgN;
 
 private int 			 mFontSize; 
 //
 private DialogInterface.OnClickListener onClickListener = null;
 private AlertDialog dialog = null;

 //Constructor
 public  jDialogYN(android.content.Context context,
              Controls ctrls, long pasobj,
              String title, String msg, String y, String n ) {
  //Connect Pascal I/F
  PasObj   = pasobj;
  controls = ctrls;
  
  //
  dlgTitle = title;
  dlgMsg   = msg;
  dlgY     = y;
  dlgN     = n;
  
  mFontSize = 0;

  //Init Event
  onClickListener = new DialogInterface.OnClickListener() {
   public  void onClick(DialogInterface dialog, int id) {
    if  ( id == YNConst.Click_Yes) { controls.pOnClick(PasObj,YNConst.Click_Yes);}
                          else { controls.pOnClick(PasObj,YNConst.Click_No );}
   };
  };
}

public  void show(String titleText, String msgText, String yesText, String noText) {
	   //Log.i("java","DlgYN_Show");
	dlgTitle = titleText;
	dlgMsg   = msgText;
	dlgY     = yesText;
	dlgN     = noText;

	if (dlgY.equals("")) dlgY ="Yes";
	if (dlgN.equals("")) dlgN ="No";
	
	AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
	
	
	TextView title = new TextView(controls.activity);
    title.setText(dlgTitle);
    title.setPadding(5, 5, 5, 5);
    //title.setBackgroundResource(R.drawable.gradient);
    //title.setGravity(Gravity.CENTER);
    //title.setTextColor(0xFF0000FF);
    if( mFontSize != 0)
    	  title.setTextSize(mFontSize);
    
    builder.setCustomTitle(title);
	
	builder.setMessage       (dlgMsg  )
	       .setCancelable    (false)
	       .setPositiveButton(dlgY,onClickListener)
	       .setNegativeButton(dlgN,onClickListener);
	dialog = builder.create();	

	dialog.show();
	
	if( mFontSize != 0){
		  dialog.getWindow().getAttributes();
			 
		  TextView tvMessage = (TextView) dialog.findViewById(android.R.id.message);
		  tvMessage.setTextSize(mFontSize);
		 
		  Button btNegative = dialog.getButton(DialogInterface.BUTTON_NEGATIVE);
		  btNegative.setTextSize(mFontSize);
		 
		  Button btPositive = dialog.getButton(DialogInterface.BUTTON_POSITIVE);
		  btPositive.setTextSize(mFontSize);
		 }
}


public void ShowOK(String titleText, String msgText, String _OkText) {
	   //Log.i("java","DlgYN_Show");
	dlgTitle = titleText;
	dlgMsg   = msgText;	
	AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
	
	TextView title = new TextView(controls.activity);
    title.setText(dlgTitle);
    title.setPadding(5, 5, 5, 5);
    
    if( mFontSize != 0)
    	  title.setTextSize(mFontSize);
    
    builder.setCustomTitle(title);
	
	builder.setMessage       (dlgMsg  )
	       .setCancelable    (false)	       
	       .setPositiveButton(_OkText, onClickListener);
	       	      
	dialog = builder.create();
	
	dialog.show();
	
	if( mFontSize != 0){
		  dialog.getWindow().getAttributes();
			 
		  TextView tvMessage = (TextView) dialog.findViewById(android.R.id.message);
		  tvMessage.setTextSize(mFontSize);
		 
		  Button btPositive = dialog.getButton(DialogInterface.BUTTON_POSITIVE);
		  btPositive.setTextSize(mFontSize);		 		 
		 }
}

// by tr3e
public void SetFontSize( int _fontSize ){
	mFontSize = _fontSize;
}

public  void Free() {
 onClickListener = null;
 
 dialog.setTitle("");
 dialog.setIcon(null);
 
 dialog = null;
}

}

