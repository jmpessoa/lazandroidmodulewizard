package org.lamw.appmodaldialogdemo1;

import android.content.Context;
import android.content.Intent;
import android.app.Activity;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;


/*Draft java code by "Lazarus Android Module Wizard" [5/15/2017 22:57:41]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

public class jModalDialog extends Activity {
	
    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;
    
    Intent mI;
		
	private android.widget.RelativeLayout mLayout;	
		
	int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
	int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w
		
	public String mTitle;	
	public int mDlgTheme = android.R.style.Theme_Holo_Light_Dialog;
	
	int mHasWindowTitle = 0; 
	int mDlgType = 0;
	
	String[] mRequestInfo;	
	EditText[] mEditInput;  
	
	int mRequestInfoCount = 0;
	
	int mRequestCode = 1122;
	String mDialogTitle = "LAMW Modal Dialog Title";
	
	int mIndexAnchor;
	
	String mBtnOK = "Ok";
	String mBtnCancel = "Cancel";
	int mTitleFontSize = 0;
	String mHint = "Enter data";
    
    public jModalDialog() {    	
        super();  	 	      
    }
           
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jModalDialog(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;             
    }
  
    public void jFree() {
      //free local objects...
      mI = null;
    }

    
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	
        super.onCreate(savedInstanceState);
        
        Intent intent = this.getIntent();
        
        mDlgTheme = intent.getIntExtra("dlg_theme", 0);        
        setTheme(mDlgTheme);
        
        mHasWindowTitle = intent.getIntExtra("dlg_has_window_title", 0);        
        mTitle = intent.getStringExtra("dlg_title");  //_dialogTitle
        mBtnOK =  intent.getStringExtra("dlg_btn_ok"); 
        mBtnCancel = intent.getStringExtra("dlg_btn_cancel"); 
        mTitleFontSize = intent.getIntExtra("dlg_font_title_size", 0);        
        mHint = intent.getStringExtra("dlg_inptu_hint");        
        mDlgType = intent.getIntExtra("dlg_type", 0); 
                        
        if (mHasWindowTitle == 1)            	
        	  requestWindowFeature(Window.FEATURE_NO_TITLE);  
           	    	        
        mRequestInfoCount = intent.getIntExtra("dlg_request_info_count", 0); 
       
        if (mRequestInfoCount > 0) { 
           mRequestInfo = new String[mRequestInfoCount];        
           for (int i = 0; i < mRequestInfoCount;  i++) {        	           	  
        	  mRequestInfo[i] = intent.getStringExtra(String.valueOf(i));  //get "0", "1", "2", ...
           }                                        
        }
        
        mLayout = new android.widget.RelativeLayout(this);
        
        this.setContentView(mLayout);
                
        getWindow().setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
       
        /*
        WindowManager.LayoutParams lp = getWindow().getAttributes();        
        //When FLAG_DIM_BEHIND is set, this is the amount of dimming to apply. 
        //Range is from 1.0 for completely opaque to 0.0 for no dim. 
        lp.dimAmount = 0.5f;
       // lp.screenBrightness = 0.5F;
        getWindow().setAttributes(lp);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);         
        */
        
        this.setFinishOnTouchOutside(false);  // modal dialog
        
    }
       
    @Override
    public void onContentChanged() {    	
        
    	int screenWidth;
    	
        TextView title = new TextView(this);
        
        title.setId(1111);
        title.setPadding(20, 20, 20, 20);
        title.setText(mTitle);
        
        if (mTitleFontSize > 0)
           title.setTextSize(mTitleFontSize);
        
        android.widget.RelativeLayout.LayoutParams lparamstxt = new android.widget.RelativeLayout.LayoutParams(
        		RelativeLayout.LayoutParams.WRAP_CONTENT,RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H
        
        lparamstxt.addRule(RelativeLayout.CENTER_HORIZONTAL);
        lparamstxt.addRule(RelativeLayout.ALIGN_TOP);        
        title.setLayoutParams(lparamstxt);
            	    	   
        mLayout.addView(title, lparamstxt);
     
        if (mDlgType == 0) {  //inputBox
     	   
     	   mEditInput = new EditText[mRequestInfoCount]; //all edit inputs ...
     	   
     	   //Log.i("mRequestInfoCount", "count = "+ mRequestInfoCount);
     	  
     	   if (mRequestInfoCount > 0) {
     		   
     	     mEditInput[0] = new EditText(this);        	  
     	     mEditInput[0].setId(2222);
     	     mEditInput[0].setPadding(20, 30, 20, 30);      
     	     //mEditInput[0].setText();     	     
     	     mEditInput[0].setHint(mHint +" "+ mRequestInfo[0].toLowerCase());
     	     
     	   
             android.widget.RelativeLayout.LayoutParams lparams0 = new android.widget.RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,
     		                                                        RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H                
             lparams0.addRule(RelativeLayout.CENTER_HORIZONTAL);      //parent       
             lparams0.addRule(RelativeLayout.BELOW, title.getId());   //anchor        
             mEditInput[0].setLayoutParams(lparams0);                
             mLayout.addView(mEditInput[0]);
             
             mIndexAnchor = 0;
             
     	   }
     	   
           for (int j = 1;  j < mRequestInfoCount; j++) { //others inputs...
        	           	  
        	  mEditInput[j] = new EditText(this);        	  
        	  mEditInput[j].setId(2222+j);
        	  mEditInput[j].setPadding(20, 30, 20, 30);      
        	  //mEditInput[j].setText(mRequestInfo[j]);
        	  mEditInput[j].setHint(mHint +" "+ mRequestInfo[j].toLowerCase());
        	  
              android.widget.RelativeLayout.LayoutParams lparamsEdit = new android.widget.RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,
        		                                                        RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H                
              lparamsEdit.addRule(RelativeLayout.CENTER_HORIZONTAL);      //parent       
              lparamsEdit.addRule(RelativeLayout.BELOW, mEditInput[j-1].getId());   //anchor        
              mEditInput[j].setLayoutParams(lparamsEdit);                
              mLayout.addView(mEditInput[j]);
              
              mIndexAnchor  = j;
           }
           
        }
        
        DisplayMetrics metrics = getResources().getDisplayMetrics();        
        screenWidth = (int) (metrics.widthPixels * 0.45);
                 
        Button buttonOk = new Button(this);
        
        buttonOk.setId(3333);
        buttonOk.setPadding(20, 30, 20, 30);
        buttonOk.setText(mBtnOK);
        
        android.widget.RelativeLayout.LayoutParams lparamsOk = new android.widget.RelativeLayout.LayoutParams(screenWidth,
        		                                                  RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H                                               
        if  (mDlgType == 0) {   //inputBox
        	lparamsOk.addRule(RelativeLayout.ALIGN_PARENT_LEFT);              //parent
        	lparamsOk.addRule(RelativeLayout.BELOW, mEditInput[mIndexAnchor].getId());   //anchor
        }	

        if  (mDlgType > 0) {  //showmessage
        	
        	lparamsOk.addRule(RelativeLayout.BELOW, title.getId());   //anchor
        	
        	if (mDlgType == 1) 
        	  lparamsOk.addRule(RelativeLayout.CENTER_HORIZONTAL); //parent
        	
        	if (mDlgType == 2) 
          	  lparamsOk.addRule(RelativeLayout.ALIGN_PARENT_LEFT); //parent
        	        	
        }
        
        buttonOk.setLayoutParams(lparamsOk);                
        mLayout.addView(buttonOk);      
        
        buttonOk.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {                              
               Intent intent= new Intent();                
               
               //put the message to return as result in Intent                              
               if  (mDlgType == 0) {   //inputBox
                 intent.putExtra("REQUESTED_INFO_COUNT",  mRequestInfoCount);            	   
            	 for (int k=0; k < mRequestInfoCount; k++) {            		             		             				 
                     intent.putExtra(mRequestInfo[k], mEditInput[k].getText().toString());
            	 }            	             	 
               }
                 
               if  (mDlgType == 2) {   //Question
                   intent.putExtra("REQUESTED_INFO_COUNT",  1);
                   intent.putExtra("BUTTON", "OK");
               }
                              
               // Set The Result in Intent
               setResult(Activity.RESULT_OK, intent);
               // finish The activity 
               finish();    	
            }
        });
        
        
        if ( (mDlgType == 0)  || ((mDlgType == 2)) ){  //  == dlgInputBox,  dlgShowQuestion
        	
          Button buttonCancel = new Button(this);
          buttonCancel.setId(3334);
          buttonCancel.setPadding(20, 20, 20, 20);
          buttonCancel.setText(mBtnCancel);
        
          android.widget.RelativeLayout.LayoutParams lparamsCancel = new android.widget.RelativeLayout.LayoutParams(screenWidth,
        		                                                  RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H
        
          if (mDlgType == 0)
             lparamsCancel.addRule(RelativeLayout.BELOW, mEditInput[mIndexAnchor].getId());      //anchor
          
          if (mDlgType == 2)  //dlgQuestion
        	  lparamsCancel.addRule(RelativeLayout.BELOW, title.getId());   //anchor
          
          lparamsCancel.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);                //parent       
        
          buttonCancel.setLayoutParams(lparamsCancel);        
        
          mLayout.addView(buttonCancel);      
        
          buttonCancel.setOnClickListener( new View.OnClickListener() {
            @Override
            public void onClick(View v) {                              
               Intent intent= new Intent();                
               // put the message to return as result in Intent  request_info_count                              
               intent.putExtra("REQUESTED_INFO_COUNT",  1);
               intent.putExtra("BUTTON", "CANCEL");
               // Set The Result in Intent                             
               setResult(Activity.RESULT_CANCELED,intent);
               // finish The activity 
               finish();    	
            }
           });
        }
    }
    
    private Class<?> GetClass(String _fullJavaclassName) {    	
 	    Class<?> cls = null;
 	    //String className = 'com.almondmendoza.library.openActivity';
 	    try {
 			cls = Class.forName(_fullJavaclassName);
 		} catch (ClassNotFoundException e) {
 			// TODO Auto-generated catch block
 			e.printStackTrace();
 		}
 	    return cls; 		    	        	    
    }
            
    
    public String GetStringValue(Intent _intentData, String _fieldName) {
       return _intentData.getStringExtra(_fieldName);
    }
      
    public int GetIntValue(Intent _intentData, String _fieldName) {
       return _intentData.getIntExtra(_fieldName, 0);
    }
    
    
    public void SetRequestInfo(String[] _requestInfo) {
    	int count = _requestInfo.length;
    	
    	mRequestInfo = new String[count];    	
    	for(int i = 0; i < count; i++) {
    		 mRequestInfo[i] = _requestInfo[i];    		
    	}
    	
    }
    
    public void SetTheme(int _dialogTheme) {    	
    	switch(_dialogTheme) {
    	  case 0: mDlgTheme = android.R.style.Theme_Holo_Light_Dialog; break;
    	  case 1: mDlgTheme = android.R.style.Theme_Holo_Dialog; break;
    	  case 2: mDlgTheme = android.R.style.Theme_Dialog; break;
    	}      
    }
    
    public void SetHasWindowTitle(boolean _hasWindowTitle) {  
    	if (!_hasWindowTitle)
       	    mHasWindowTitle = 1;         	
    }
    
    public void SetDialogType(int _dialogType) {  //Pascal: TDialogType = (0=dlgInputBox, 1=dlgShowMessage);
  	    mDlgType = _dialogType;    	 
    }
        
    public void SetRequestCode(int _requestCode) {    	
    	mRequestCode = _requestCode;
    }
        
    public void SetDialogTitle(String _dialogTitle) {
    	 mDialogTitle = _dialogTitle;
    }
    
    //dlgShowMessage
    public void ShowMessage(String _packageName) {
     	Class<?> cls = GetClass(_packageName+"."+"jModalDialog");  //_javaClassName    	
     	if  (cls != null) {
     	   mI = new Intent();		
           mI.setClass(controls.activity, cls);
           
           mDlgType = 1; // force dlgShowMessage
           mI.putExtra("dlg_title", mDialogTitle);
           mI.putExtra("dlg_type", mDlgType);
           mI.putExtra("dlg_theme", mDlgTheme);
           mI.putExtra("dlg_has_window_title", mHasWindowTitle);
           mI.putExtra("dlg_btn_ok", mBtnOK);  //_dialogTitle
           mI.putExtra("dlg_btn_cancel", mBtnCancel);  //_dialogTitle
           mI.putExtra("dlg_font_title_size", mTitleFontSize);  
           
           mI.putExtra("dlg_request_info_count", 0);
           
           controls.activity.startActivity(mI);
     	}    	 
    }    
    
    public void InputForActivityResult(String _packageName, String[] _requestInfo) {
    	    	
    	int count;
    	
     	Class<?> cls = GetClass(_packageName+"."+"jModalDialog");  //_javaClassName
     	
     	if  (cls != null) {
     		
     	   mI = new Intent();
           mI.setClass(controls.activity, cls);
           
           mDlgType = 0; // force dlgInputBox
           
           mI.putExtra("dlg_title", mDialogTitle);           
           mI.putExtra("dlg_type", mDlgType);
           mI.putExtra("dlg_theme", mDlgTheme);
           mI.putExtra("dlg_has_window_title", mHasWindowTitle);

           mI.putExtra("dlg_btn_ok", mBtnOK);  //_dialogTitle
           mI.putExtra("dlg_btn_cancel", mBtnCancel);  //_dialogTitle
           mI.putExtra("dlg_font_title_size", mTitleFontSize);
           mI.putExtra("dlg_inptu_hint", mHint);
           
           count = _requestInfo.length;
                      
           mI.putExtra("dlg_request_info_count", count);           
           
       	   for(int i = 0; i < count; i++) {    		
   		      mI.putExtra(String.valueOf(i), _requestInfo[i]);   		      
   	       }
       	   
           controls.activity.startActivityForResult(mI, mRequestCode);
           
     	}
     	
    }

    //dlgShowQuestion
    public void QuestionForActivityResult(String _packageName) {
     	Class<?> cls = GetClass(_packageName+"."+"jModalDialog");  //_javaClassName    	
     	if  (cls != null) {
     	   mI = new Intent();		
           mI.setClass(controls.activity, cls);
           
           mDlgType = 2; // force dlgShowQuestion
           mI.putExtra("dlg_title", mDialogTitle);
           mI.putExtra("dlg_type", mDlgType);
           mI.putExtra("dlg_theme", mDlgTheme);
           mI.putExtra("dlg_has_window_title", mHasWindowTitle);
           
           mI.putExtra("dlg_btn_ok", mBtnOK);  
           mI.putExtra("dlg_btn_cancel", mBtnCancel);  
           mI.putExtra("dlg_font_title_size", mTitleFontSize);  

           mI.putExtra("dlg_request_info_count", 0);                     
           controls.activity.startActivityForResult(mI, mRequestCode);           
     	}    	 
    }    

    public void SetCaptionButtonOK(String _captionOk) {    	
    	mBtnOK = _captionOk;
    }

    public void SetCaptionButtonCancel(String _captionCancel) {    	
    	mBtnCancel = _captionCancel;
    }
    
    public void SetTitleFontSize (int _fontSize) {
    	mTitleFontSize = _fontSize; 
    }
    
    public void SetInputHint(String _hint) {
    	mHint = _hint;
    }

}

