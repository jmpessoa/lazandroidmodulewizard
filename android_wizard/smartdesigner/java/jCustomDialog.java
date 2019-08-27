package com.example.appcustomdialogdemo1;

import java.lang.reflect.Field;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

import android.graphics.Point;

/*Draft java code by "Lazarus Android Module Wizard" [12/4/2014 23:21:31]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

// Reviewed by TR3E on 08/27/2019

public class jCustomDialog extends RelativeLayout {

 private long       pascalObj = 0;    // Pascal Object
	private Controls   controls  = null; // Control Class for events

	private Context context = null;
	private ViewGroup parent   = null;         // parent view
	private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH

	private int lparamsAnchorRule[] = new int[30];
	private int countAnchorRule = 0;
	private int lparamsParentRule[] = new int[30];
	private int countParentRule = 0;

	private int lparamH = 100;
	private int lparamW = 100;
	private int marginLeft   = 10;
	private int marginTop    = 10;
	private int marginRight  = 10;
	private int marginBottom = 10;
	private float lweight = 0;
 //[ifdef_api14up]
 private int lgravity = Gravity.TOP | Gravity.START;
 //[endif_api14up]
 /* //[endif_api14up]
 private int lgravity = Gravity.TOP | Gravity.LEFT;
 //[ifdef_api14up] */
 
    private boolean mShowTitle; 
 
	Dialog mDialog = null;
	private String mIconIdentifier = "ic_launcher";   //default icon  ../res/drawable
	private String mTitle = "Information";
	boolean mRemovedFromParent = false; //no parent!
	
	//boolean mCloseOnBackKeyPressed = true;
	//boolean mCanceledOnTouchOutside = true;
	
	boolean FCancelable = true;

	//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
	public jCustomDialog(Controls _ctrls, long _Self, boolean _showTitle) { //Add more others news "_xxx"p arams if needed!
		super(_ctrls.activity);
		context   = _ctrls.activity;
		pascalObj = _Self;
		controls  = _ctrls;
		
		mShowTitle = _showTitle;

		lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B

	} //end constructor

	public void jFree() {
		if (parent != null) { parent.removeView(this); }
		//free local objects...
		if (mDialog != null) mDialog.dismiss();
		mDialog = null;
		lparams = null;
	}

	private static MarginLayoutParams newLayoutParams(ViewGroup _aparent, ViewGroup.MarginLayoutParams _baseparams) {
		if (_aparent instanceof FrameLayout) {
			return new FrameLayout.LayoutParams(_baseparams);
		} else if (_aparent instanceof RelativeLayout) {
			return new RelativeLayout.LayoutParams(_baseparams);
		} else if (_aparent instanceof LinearLayout) {
			return new LinearLayout.LayoutParams(_baseparams);
		} else if (_aparent == null) {
			throw new NullPointerException("Parent is null");
		} else {
			throw new IllegalArgumentException("Parent is neither FrameLayout or RelativeLayout or LinearLayout: "
					+ _aparent.getClass().getName());
		}
	}

	public void SetViewParent(ViewGroup _viewgroup) {
		if (parent != null) { parent.removeView(this); }
		parent = _viewgroup;
		parent.addView(this,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));		
		lparams = null;
		lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();
		mRemovedFromParent = false; 
	}

	public void RemoveFromViewParent() {
		if (!mRemovedFromParent) {
			this.setVisibility(android.view.View.INVISIBLE);
			if (parent != null) {
				parent.removeView(this);
				mRemovedFromParent = true; //no more parent!		
			}
		}
	}

	public View GetView() {
		return this;
	}

	public void SetLParamWidth(int _w) {
		lparamW = _w;
	}

	public void SetLParamHeight(int _h) {
		lparamH = _h;
	}

	public void setLGravity(int _g) {
		lgravity = _g;
	}

	public void setLWeight(float _w) {
		lweight = _w;
	}

	public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		marginLeft = _left;
		marginTop = _top;
		marginRight = _right;
		marginBottom = _bottom;
		lparamH = _h;
		lparamW = _w;
	}

	public void AddLParamsAnchorRule(int _rule) {
		lparamsAnchorRule[countAnchorRule] = _rule;
		countAnchorRule = countAnchorRule + 1;
	}

	public void AddLParamsParentRule(int _rule) {
		lparamsParentRule[countParentRule] = _rule;
		countParentRule = countParentRule + 1;
	}

	public void SetLayoutAll(int _idAnchor) {
		lparams.width  = lparamW;
		lparams.height = lparamH;
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);

		if (lparams instanceof RelativeLayout.LayoutParams) {
			if (_idAnchor > 0) {
				for (int i = 0; i < countAnchorRule; i++) {
					((RelativeLayout.LayoutParams)lparams).addRule(lparamsAnchorRule[i], _idAnchor);
				}
			}
			for (int j = 0; j < countParentRule; j++) {
				((RelativeLayout.LayoutParams) lparams).addRule(lparamsParentRule[j]);
			}
		}
		if (lparams instanceof FrameLayout.LayoutParams) {
			((FrameLayout.LayoutParams)lparams).gravity = lgravity;
		}
		if (lparams instanceof LinearLayout.LayoutParams) {
			((LinearLayout.LayoutParams)lparams).weight = lweight;
		}
		//
		this.setLayoutParams(lparams);
	}

	public void ClearLayoutAll() {
		if (lparams instanceof RelativeLayout.LayoutParams) {
			for (int i = 0; i < countAnchorRule; i++) {   
 //[ifdef_api17up]
				((RelativeLayout.LayoutParams)lparams).removeRule(lparamsAnchorRule[i]);
 //[endif_api17up]
	/* //[endif_api17up]
 			((RelativeLayout.LayoutParams)lparams).addRule(lparamsAnchorRule[i], 0);
 //[ifdef_api17up] */
			}

			for (int j = 0; j < countParentRule; j++) {
 //[ifdef_api17up]
				((RelativeLayout.LayoutParams)lparams).removeRule(lparamsParentRule[j]);
 //[endif_api17up]
 /* //[endif_api17up]
 			((RelativeLayout.LayoutParams)lparams).addRule(lparamsAnchorRule[j], 0);
	//[ifdef_api17up] */
			}
		}
		countAnchorRule = 0;
		countParentRule = 0;
	}

	public void SetId(int _id) { //wrapper method pattern ...
		this.setId(_id);
	}

	//write others [public] methods code here......
	//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
	private int GetDrawableResourceId(String _resName) {   //    ../res/drawable
		try {
			Class<?> res = R.drawable.class;
			Field field = res.getField(_resName);  //"drawableName"
			int drawableId = field.getInt(null);
			return drawableId;
		}
		catch (Exception e) {
			Log.e("jCustomDialog", "Failure to get drawable id.", e);
			return 0;
		}
	}

	public void Show() {			
	    Show(mTitle, mIconIdentifier);
	}

	public void Show(String _title) {	
	    Show(_title, mIconIdentifier);
	}

	public void Show(String _title, String _iconIdentifier) {	
									
		mTitle = _title;
		mIconIdentifier = _iconIdentifier;
		
		if (mDialog != null) {
			
			// Update icon if I change [to TR3E]
			if( mShowTitle ){			
			 mDialog.setFeatureDrawableResource(Window.FEATURE_LEFT_ICON, GetDrawableResourceId(mIconIdentifier));
			
			 mDialog.setTitle(mTitle);
			}
			
			mDialog.show();						
		}
		else {
			if (this.getVisibility()==0) { //visible
				this.setVisibility(android.view.View.INVISIBLE); //4
			}
			
			if (!mRemovedFromParent) {				
				parent.removeView(this);
				mRemovedFromParent = true;
			}
						
			mDialog = new Dialog(this.controls.activity);
						
			if( !mShowTitle ){
				mDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
			 
				mDialog.setContentView(this);
			}else{
				mDialog.requestWindowFeature(Window.FEATURE_LEFT_ICON);
				mDialog.setContentView(this);			
				
				mDialog.setFeatureDrawableResource(Window.FEATURE_LEFT_ICON, GetDrawableResourceId(mIconIdentifier));
				
				mDialog.setTitle(mTitle);
			 //mDialog.getWindow().setTitleColor(0xFF0000FF); 
			}
		
			//mDialog.setCanceledOnTouchOutside(mCanceledOnTouchOutside);
			mDialog.setCancelable(FCancelable);
			
			//fix by @renabor
			mDialog.setOnKeyListener(new Dialog.OnKeyListener() {
				@Override
				public  boolean onKey(DialogInterface arg0, int keyCode, KeyEvent event) {
					if (event.getAction() == KeyEvent.ACTION_UP) {
						if (keyCode == KeyEvent.KEYCODE_BACK) {
							controls.pOnCustomDialogBackKeyPressed(pascalObj, mTitle);							
							return false;
						} else if (keyCode == KeyEvent.KEYCODE_ENTER) {
							InputMethodManager imm = (InputMethodManager) controls.activity.getSystemService(Context.INPUT_METHOD_SERVICE);
							imm.hideSoftInputFromWindow(getWindowToken(), 0);
							controls.pOnEnter(pascalObj);
							return true;
						}
					}
					return false;
				}
			});
			this.setVisibility(android.view.View.VISIBLE);  // //0: vis; 4: inv; 8: gone
			
			// To really run after displaying the Dialog [by TR3E]
			mDialog.setOnShowListener(new DialogInterface.OnShowListener() {
		        @Override
		        public void onShow(DialogInterface d) {
		        			            
		        	controls.pOnCustomDialogShow(pascalObj, mDialog, mTitle);
		        }
		    });
						
			mDialog.show();					
						
			
		}
	}
	
	public int GetDialogWidth(){
		if (mDialog == null) return 0;
	 
		return this.getWidth() + marginLeft + marginRight;
	}
	
	public int GetDialogHeight(){
		if (mDialog == null) return 0;
		
		return this.getHeight() + marginTop + marginBottom;
	}

	public void SetTitle(String _title) {
				
		mTitle = _title;
		
		if ((mDialog != null) && mShowTitle)		
		 mDialog.setTitle(mTitle);
	}

	public void SetIconIdentifier(String _iconIdentifier) {   // ../res/drawable
		mIconIdentifier = _iconIdentifier;
		
		if ((mDialog != null) && mShowTitle)		
		 mDialog.setFeatureDrawableResource(Window.FEATURE_LEFT_ICON, GetDrawableResourceId(mIconIdentifier));
	}

	public void Close() {
		if (mDialog != null) mDialog.dismiss();
	}	
	
	/*
	public void SetCloseOnBackKeyPressed(boolean _value) {
		mCloseOnBackKeyPressed = _value;
	}
	
	public void SetCanceledOnTouchOutside(boolean _value) {
		mCanceledOnTouchOutside = _value;
	}
	*/
	
	public void SetCancelable(boolean _value) {
	   FCancelable = _value;
	}
	
} //end class


