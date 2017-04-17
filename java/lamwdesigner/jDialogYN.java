package org.lamw.appwidgetproviderdemo1;

import android.app.AlertDialog;
import android.content.DialogInterface;


class YNConst {
  public static final int Click_Yes = -1;
  public static final int Click_No  = -2;
}

public class jDialogYN {
//Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private String          dlgTitle;
private String          dlgMsg;
private String          dlgY;
private String          dlgN;
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

//Init Event
onClickListener = new DialogInterface.OnClickListener() {
public  void onClick(DialogInterface dialog, int id) {
  if  ( id == YNConst.Click_Yes) { controls.pOnClick(PasObj,YNConst.Click_Yes);}
                          else { controls.pOnClick(PasObj,YNConst.Click_No );}
};
};
//Init Class
if (dlgY.equals("")) dlgY ="Yes";
if (dlgN.equals("")) dlgN ="No";

AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
builder.setMessage       (dlgMsg  )
     .setCancelable    (false)
     .setPositiveButton(dlgY,onClickListener)
     .setNegativeButton(dlgN,onClickListener);
dialog = builder.create();
//
dialog.setTitle(dlgTitle);
//dialog.setIcon(R.drawable.icon);  //my comment here!!

}

public  void show() {
 //Log.i("java","DlgYN_Show");
 dialog.show();
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
	builder.setMessage       (dlgMsg  )
	       .setCancelable    (false)
	       .setPositiveButton(dlgY,onClickListener)
	       .setNegativeButton(dlgN,onClickListener);
	dialog = builder.create();
	//
	dialog.setTitle(dlgTitle);

	dialog.show();
}

public void show(String titleText, String msgText) {
	   //Log.i("java","DlgYN_Show");
	dlgTitle = titleText;
	dlgMsg   = msgText;

	if (dlgY.equals("")) dlgY ="Yes";
	if (dlgN.equals("")) dlgN ="No";
	
	AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
	builder.setMessage       (dlgMsg  )
	       .setCancelable    (false)
	       .setPositiveButton(dlgY,onClickListener)
	       .setNegativeButton(dlgN,onClickListener);
	dialog = builder.create();
	//
	dialog.setTitle(dlgTitle);
	dialog.show();
}


public void ShowOK(String titleText, String msgText, String _OkText) {
	   //Log.i("java","DlgYN_Show");
	dlgTitle = titleText;
	dlgMsg   = msgText;	
	AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);
	builder.setMessage       (dlgMsg  )
	       .setCancelable    (false)	       
	       .setPositiveButton(_OkText, onClickListener);
	       	      
	dialog = builder.create();
	dialog.setTitle(dlgTitle);
	dialog.show();
}


public  void Free() {
onClickListener = null;
dialog.setTitle("");
dialog.setIcon(null);
dialog = null;
}

}

