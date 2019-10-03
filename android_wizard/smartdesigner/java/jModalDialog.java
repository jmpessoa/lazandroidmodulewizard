package org.lamw.appmodaldialogdemo1;

import android.content.Context;
import android.content.Intent;
import android.app.Activity;
import android.content.res.Configuration;
import android.graphics.PixelFormat;
import android.os.Build;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
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
    public String mMessage;
	public int mDlgTheme = android.R.style.Theme_DeviceDefault_Light_Dialog;
    //Theme_Material_Dialog;
    //Theme_Dialog;
    //Theme_DeviceDefault_Light_Dialog;
    //Theme_DeviceDefault_Dialog;
    //Theme_Holo_Light_Dialog;
	
	int mHasWindowTitle = 0; 
	int mDlgType = 0;
	
	String[] mRequestInfo;
    String[] mRequestHint;
	EditText[] mEditInput;
	
	int mRequestInfoCount = 0;
	
	int mRequestCode = 1122;
	String mDialogTitle = "LAMW Modal Dialog Title";
    String mDialogMessage = "Hello World!";
	
	int mIndexAnchor;
	
	String mBtnOK = "Ok";
	String mBtnCancel = "Cancel";
	int mTitleFontSize = 0;
	String mHint = "Enter data...";
    
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
        mTitle = intent.getStringExtra("dlg_title");
        mMessage = intent.getStringExtra("dlg_message");
        mBtnOK =  intent.getStringExtra("dlg_btn_ok"); 
        mBtnCancel = intent.getStringExtra("dlg_btn_cancel"); 
        mTitleFontSize = intent.getIntExtra("dlg_font_title_size", 0);        
        mHint = intent.getStringExtra("dlg_inptu_hint");        
        mDlgType = intent.getIntExtra("dlg_type", 0); 
                        
        if (mHasWindowTitle == 1)            	
        	  requestWindowFeature(Window.FEATURE_NO_TITLE);  
        else {
            setTitle(mTitle);
        }

        mRequestInfoCount = intent.getIntExtra("dlg_request_info_count", 0); 

        String infoHint;
        if (mRequestInfoCount > 0) { 
           mRequestInfo = new String[mRequestInfoCount];
           mRequestHint = new String[mRequestInfoCount];

           for (int i = 0; i < mRequestInfoCount;  i++) {
               infoHint =  intent.getStringExtra(String.valueOf(i)); //DATA_NAME|Input Hint
        	  mRequestInfo[i] = infoHint.split("\\|")[0];  //get "DATA_0", "DATA_1", "DATA_2", ...
               mRequestHint[i] = infoHint.split("\\|")[1];  //get "Input Hint 0", "Input Hint 1", "Input Hint 2", ...
           }                                        
        }
        
        mLayout = new android.widget.RelativeLayout(this);

        /*
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams( ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT);
       */
        android.widget.RelativeLayout.LayoutParams params = new android.widget.RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,RelativeLayout.LayoutParams.MATCH_PARENT);     // W,H

        this.setContentView(mLayout, params);

        this.setFinishOnTouchOutside(false);  // modal dialog
    }
       
    @Override
    public void onContentChanged() {    	
        
    	int screenWidth;
    	
        TextView title = new TextView(this);
        int id1111 = 1111;
        title.setId(id1111); // Being a new activity you don't need "getJavaNewId ()"
        title.setPadding(20, 40, 20, 40);
        title.setText(mMessage);
        
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
            int id2222 = 2222;

            if (mRequestInfoCount > 0) {
     		   
     	     mEditInput[0] = new EditText(this);
     	     mEditInput[0].setId(id2222); // Being a new activity you don't need "getJavaNewId ()"
     	     mEditInput[0].setPadding(20, 30, 20, 30);
     	     mEditInput[0].setHint(mRequestHint[0]);

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
        	  mEditInput[j].setId(id2222+j); // Being a new activity you don't need "getJavaNewId ()"
        	  mEditInput[j].setPadding(20, 30, 20, 30);      
        	  //mEditInput[j].setText(mRequestInfo[j]);
        	  mEditInput[j].setHint(mRequestHint[j]);// +" "+ mRequestInfo[j].toLowerCase());
        	  
              android.widget.RelativeLayout.LayoutParams lparamsEdit = new android.widget.RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,
        		                                                        RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H                
             // lparamsEdit.addRule(RelativeLayout.CENTER_HORIZONTAL);      //parent
              lparamsEdit.addRule(RelativeLayout.BELOW, mEditInput[j-1].getId());   //anchor        
              mEditInput[j].setLayoutParams(lparamsEdit);                
              mLayout.addView(mEditInput[j]);
              
              mIndexAnchor  = j;
           }
           
        }

        Display display = getWindowManager().getDefaultDisplay();

        int width = display.getWidth();
        int height = display.getHeight();

        DisplayMetrics metrics = getResources().getDisplayMetrics();

        if (width > height)  //"LandScape",
            screenWidth = (int) (metrics.widthPixels * 0.30);
        else
           screenWidth = (int) (metrics.widthPixels * 0.42);

        Button buttonOk = new Button(this);

        int id3333 = 3333;
        buttonOk.setId(id3333); // Being a new activity you don't need "getJavaNewId ()"
        buttonOk.setPadding(20, 40, 20, 40);
        buttonOk.setText(mBtnOK);

        android.widget.RelativeLayout.LayoutParams lparamsOk;

        if (mDlgType != 1)
            lparamsOk = new android.widget.RelativeLayout.LayoutParams(screenWidth,
        		                                                  RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H
        else  //showmessage
            lparamsOk = new android.widget.RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,
                    RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H

        if  (mDlgType == 0) {   //inputBox
        	lparamsOk.addRule(RelativeLayout.ALIGN_PARENT_LEFT);              //parent
        	lparamsOk.addRule(RelativeLayout.BELOW, mEditInput[mIndexAnchor].getId());   //anchor
        }	

        if  (mDlgType > 0) {
        	
        	lparamsOk.addRule(RelativeLayout.BELOW, title.getId());   //anchor

            /*
        	if (mDlgType == 1) { //showmessage
                lparamsOk.addRule(RelativeLayout.CENTER_HORIZONTAL); //parent
            }
            */

        	if (mDlgType == 2) //yes or no
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
        
        int id3334 = 3334;

        if ( (mDlgType == 0)  || ((mDlgType == 2)) ){  //  == dlgInputBox,  dlgShowQuestion
        	
          Button buttonCancel = new Button(this);
          buttonCancel.setId(id3334); // Being a new activity you don't need "getJavaNewId ()"
          buttonCancel.setPadding(20, 40, 20, 40);
          buttonCancel.setText(mBtnCancel);
        
          android.widget.RelativeLayout.LayoutParams lparamsCancel = new android.widget.RelativeLayout.LayoutParams(screenWidth,
        		                                                  RelativeLayout.LayoutParams.WRAP_CONTENT);     // W,H
        
          if (mDlgType == 0) //input
             lparamsCancel.addRule(RelativeLayout.BELOW, mEditInput[mIndexAnchor].getId());      //anchor
          
          if (mDlgType == 2)  //dlgQuestion - yes or no
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
            String dataInfo = _requestInfo[i].split("\\|")[0];
            String dataHint = _requestInfo[i].split("\\|")[1];

            mRequestInfo[i] = dataInfo;
            mRequestHint[i] = dataHint;
    	}
    }
    
    public void SetTheme(int _dialogTheme) {    	
    	switch(_dialogTheme) {
    	    case 0: mDlgTheme = android.R.style.Theme_DeviceDefault_Light_Dialog; break;
    	    case 1: mDlgTheme = android.R.style.Theme_DeviceDefault_Dialog; break;
    	    case 2: mDlgTheme = android.R.style.Theme_Dialog; break;
            case 3: mDlgTheme = android.R.style.Theme_DeviceDefault_Light_Dialog_NoActionBar;
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

    public void SetDialogMessage(String _dialogMessage) {
        mDialogMessage = _dialogMessage;
    }
    
    //dlgShowMessage
    public void ShowMessage(String _packageName) {
     	Class<?> cls = GetClass(_packageName+"."+"jModalDialog");  //_javaClassName    	
     	if  (cls != null) {
     	   mI = new Intent();		
           mI.setClass(controls.activity, cls);
           
           mDlgType = 1; // force dlgShowMessage
           mI.putExtra("dlg_title", mDialogTitle);
           mI.putExtra("dlg_message", mDialogMessage);
           mI.putExtra("dlg_type", mDlgType);
           mI.putExtra("dlg_theme", mDlgTheme);
           mI.putExtra("dlg_has_window_title", mHasWindowTitle);
           mI.putExtra("dlg_btn_ok", mBtnOK);
           mI.putExtra("dlg_btn_cancel", mBtnCancel);
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
            mI.putExtra("dlg_message", mDialogMessage);

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
           mI.putExtra("dlg_message", mDialogMessage);
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

