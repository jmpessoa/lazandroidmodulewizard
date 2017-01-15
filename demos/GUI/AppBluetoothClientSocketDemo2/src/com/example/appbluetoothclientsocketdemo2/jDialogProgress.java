package com.example.appbluetoothclientsocketdemo2;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.view.Window;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

public class jDialogProgress {
	  // Java-Pascal Interface
	  private long  PasObj = 0;      // Pascal Obj
	  private Controls controls = null;   // Control Class for Event
	  
	  String mTitle = "";
	  String mMsg = "";
	  int mFlag = 0;  
	  private ProgressDialog  dialog = null;  
	  private AlertDialog  customDialog = null;  
	  
	  private boolean mCancelable; //thanks to Mladen
	  
	  public jDialogProgress(android.content.Context context,
	                     Controls ctrls, long pasobj, String title, String msg) {
	    //Connect Pascal I/F
	    PasObj = pasobj;
	    controls = ctrls;
	    mTitle= title;
	    mMsg = msg; 
	    mFlag = 0;
	    mCancelable= true;    
	  }

	  public  void Free() {
		if (dialog != null) dialog.dismiss();
		if (customDialog != null) customDialog.dismiss();		
	    dialog = null;
	    customDialog = null;
	  }
	  
	  
	  public void Show() {
		if (dialog != null) dialog.dismiss();
		dialog = null;	  
		dialog = new ProgressDialog(controls.activity);
		
		if (!mMsg.equals("")) dialog.setMessage(mMsg);		 
		if (!mTitle.equals("")) 
			dialog.setTitle(mTitle);	
		 else 
			dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		
		if (mCancelable)
	       dialog.setCancelable(true);
	    else   
	    	dialog.setCancelable(false);
		
	    dialog.show();
	  }
		  
	  public void Show(String _title, String _msg) {
		  if (dialog != null) dialog.dismiss();
		  dialog = null;	 
		  mMsg = _msg;
		  mTitle= _title;
		  dialog = new ProgressDialog(controls.activity);
		  	  
		  if (!mMsg.equals("")) dialog.setMessage(mMsg);		 
		  if (!mTitle.equals("")) 
			 dialog.setTitle(mTitle);	
		  else 
			 dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		  
		  
			if (mCancelable)  //thanks to Mladen
			  dialog.setCancelable(true);  //back key
			else   
			 dialog.setCancelable(false);
			
	      dialog.show();
	  }
	  
	  public void Show(RelativeLayout _layout) {	
		if (dialog != null) dialog.dismiss();
		dialog = null;		
	    if(_layout.getVisibility()==0) { //visible   
		  _layout.setVisibility(android.view.View.INVISIBLE); //4
	    }                  
	    if ( _layout.getParent().getClass().getName().equals("android.widget.RelativeLayout") ) {    	
	    	RelativeLayout par = (RelativeLayout)_layout.getParent();
	    	if (par != null) par.removeView(_layout);
	    } 			
	    else {
	    	FrameLayout par = (FrameLayout)_layout.getParent();
	    	if (par != null) par.removeView(_layout);
	    }
	    
		_layout.setVisibility(0);	
	    AlertDialog.Builder builder = new AlertDialog.Builder(controls.activity);    
	    builder.setView(_layout);
	    builder.setCancelable(true); //back key    
	    customDialog = builder.create();   
	    		 
		if (!mTitle.equals("")) 
		  customDialog.setTitle(mTitle);	
		else 
		  customDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
	    
		if (mCancelable) //thanks to Mladen
			customDialog.setCancelable(true);  //back key
		else   
			customDialog.setCancelable(false);
		
	    customDialog.show();    
	  }
	  
	  public void SetMessage(String _msg) {
	    mMsg = _msg;
	    if (dialog != null) {
	    	if (dialog.isShowing()) {dialog.setMessage(_msg);}
	    }	
	  }
	 
	  public void SetTitle(String _title) {
		mTitle = _title;
		if (dialog != null) dialog.setTitle(_title);
		if (customDialog != null) customDialog.setTitle(_title);
	  }
	  
	  public void SetCancelable(boolean _value) {	  
		mCancelable = _value; //thanks to Mladen
		if (dialog != null) dialog.setCancelable(mCancelable);
		if (customDialog != null) customDialog.setCancelable(mCancelable);		
	  }
	      
	  public void Stop() {
		  if (customDialog != null) {
			  customDialog.dismiss();		  
		  }
		  if (dialog != null) {
			  dialog.dismiss();		  
		  }
	  }
	  
	  //TODO
	  public void ShowAsync() {  //Async
		  new ATask().execute(null, null, null); 
	  }
	  
	  //TODO                        //params, progress, result
	  class ATask extends AsyncTask<String, Integer, Integer>{
	       int count;
	       
	    // Step #1. 
	       @Override
	       protected void onPreExecute(){ 
	         super.onPreExecute();
	         
	         count = 1;         
	  		 if (dialog != null) dialog.dismiss();
	  		 dialog = null;
	  		 
	  		 dialog = new ProgressDialog(controls.activity);
	  		
	  		 if (!mMsg.equals("")) dialog.setMessage(mMsg);
	  		 
	  		 if (!mTitle.equals("")) 
	  			dialog.setTitle(mTitle);	
	  		 else 
	  			dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);

	  		if (mCancelable)
	  			dialog.setCancelable(true);  //back key
	  		else   
	  			dialog.setCancelable(false);
	  		
	  	     dialog.show();
	  	     
	       }
	       
	    // Step #2. 
		   @Override
		   protected Integer doInBackground(String... params) {
			   int result = 0;		   
		       while( count > 0 ) {	 //controls.pOnShowDialogProgressAsync(PasObj, count)
		    	  result = count;
		    	  publishProgress(count);
		       }	       
		       return result;	      
		    }

		    // Step #3. Progress
		    @Override
		    protected void onProgressUpdate(Integer... params) {
		       super.onProgressUpdate(params);	       
		       count = count + 1;	       
		       if ( count == 1000) { //just test !
		    	   count = -1;
		       }
		    }

		    //Step #4. After Process
		    @Override
		    protected void onPostExecute(Integer result) {
		      super.onPostExecute(result);
		      if (dialog != null) dialog.dismiss();
		      //Log.i("onPostExecute = ", "result = "+ result.intValue());	      
		    }        	    
		  }
}

