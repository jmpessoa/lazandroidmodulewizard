package org.lamw.appcustomdialogdemo2;

import java.lang.reflect.Field;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

/*Draft java code by "Lazarus Android Module Wizard" [12/4/2014 23:21:31]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jCustomDialog extends RelativeLayout {

 private long       pascalObj = 0;    // Pascal Object
	private Controls   controls  = null; // Control Class for events

	private Context context = null;
	private ViewGroup parent   = null;         // parent view
	private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH

	//private OnClickListener onClickListener;   // click event
	//private Boolean enabled  = true;           // click-touch enabled!

	private int lparamsAnchorRule[] = new int[30];
	private int countAnchorRule = 0;
	private int lparamsParentRule[] = new int[30];
	private int countParentRule = 0;

	//private int lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
	//private int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
	private int lparamH = 100;
	private int lparamW = 100;
	private int marginLeft = 0;
	private int marginTop = 0;
	private int marginRight = 0;
	private int marginBottom = 0;
	private float lweight = 0;
 //[ifdef_api14up]
 private int lgravity = Gravity.TOP | Gravity.START;
 //[endif_api14up]
 /* //[endif_api14up]
 private int lgravity = Gravity.TOP | Gravity.LEFT;
 //[ifdef_api14up] */
 
	Dialog mDialog = null;
	private String mIconIdentifier = "ic_launcher";   //default icon  ../res/drawable
	private String mTitle = "Information";
	boolean mRemovedFromParent = false; //no parent!

	//GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

	public jCustomDialog(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
		super(_ctrls.activity);
		context   = _ctrls.activity;
		pascalObj = _Self;
		controls  = _ctrls;

	    //lparams = new LayoutParams(lparamW, lparamH);  
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

	    //parent.addView(this,lparams);
	    
		parent.addView(this,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));		
		lparams = null;
		lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();

		mRemovedFromParent = false; //now there is a parent!
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

	public void Show() {	//0: vis; 4: inv; 8: gone
		Show(mTitle, mIconIdentifier);
	}

	public void Show(String _title) {	//0: vis; 4: inv; 8: gone
		Show(_title, mIconIdentifier);
	}

	public void Show(String _title, String _iconIdentifier) {	//0: vis; 4: inv; 8: gone
		mTitle = _title;
		mIconIdentifier = _iconIdentifier;
		if (mDialog != null) {
			mDialog.setTitle(mTitle);
			controls.pOnCustomDialogShow(pascalObj, mDialog, _title);
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
			mDialog.requestWindowFeature(Window.FEATURE_LEFT_ICON);
			mDialog.setContentView(this);
			mDialog.setFeatureDrawableResource(Window.FEATURE_LEFT_ICON, GetDrawableResourceId(mIconIdentifier));
			mDialog.setTitle(mTitle);

			//fix by @renabor
			mDialog.setOnKeyListener(new Dialog.OnKeyListener() {
				@Override
				public  boolean onKey(DialogInterface arg0, int keyCode, KeyEvent event) {
					if (event.getAction() == KeyEvent.ACTION_UP) {
						if (keyCode == KeyEvent.KEYCODE_BACK) {
							controls.pOnCustomDialogBackKeyPressed(pascalObj, mTitle);
							if (mDialog != null) mDialog.dismiss();
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

			this.setVisibility(android.view.View.VISIBLE);
			controls.pOnCustomDialogShow(pascalObj, mDialog, mTitle);
			mDialog.show();
		}
	}

	public void SetTitle(String _title) {
		mTitle = _title;
		mDialog.setTitle(mTitle);
	}

	public void SetIconIdentifier(String _iconIdentifier) {   // ../res/drawable
		mIconIdentifier = _iconIdentifier;
		mDialog.requestWindowFeature(Window.FEATURE_LEFT_ICON);
		mDialog.setFeatureDrawableResource(Window.FEATURE_LEFT_ICON, GetDrawableResourceId(mIconIdentifier));
	}

	public void Close() {
		if (mDialog != null) mDialog.dismiss();
	}
} //end class


