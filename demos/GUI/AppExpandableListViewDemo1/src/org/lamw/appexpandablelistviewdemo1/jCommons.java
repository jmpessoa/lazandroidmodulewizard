package org.lamw.appexpandablelistviewdemo1;

import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.os.Build;
import android.view.Gravity;

public class jCommons {

  // owner of this instance
	private View aOwnerView = null;

	//Java-Pascal Interface
	private long PasObj = 0; // Pascal Obj

	private ViewGroup parent = null;                     // parent view
	
	private ViewGroup.MarginLayoutParams lparams = null; // layout XYWH
	
	private int lparamsAnchorRule[] = new int[30];
	private int countAnchorRule = 0;
	private int lparamsParentRule[] = new int[30];
	private int countParentRule = 0;
	private int lparamH = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
	private int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
	private int marginLeft = 5;
	private int marginTop = 5;
	private int marginRight = 5;
	private int marginBottom = 5;
 //[ifdef_api14up]
 private int lgravity = Gravity.TOP | Gravity.START;
 //[endif_api14up]
 /* //[endif_api14up]
 private int lgravity = Gravity.TOP | Gravity.LEFT;
 //[ifdef_api14up] */
	private float lweight = 0;
	private boolean mRemovedFromParent = false;
	
	public jCommons(View _view, android.content.Context _context, long _pasobj) {
		aOwnerView = _view;       // set owner
		PasObj   = _pasobj; 	//Connect Pascal I/F						
		
		if (aOwnerView != null) {
			ViewGroup.LayoutParams lp = aOwnerView.getLayoutParams();
			if (lp instanceof MarginLayoutParams) {
				lparams = (MarginLayoutParams)lp;
				lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B
			}
		}
		
		if (lparams == null) {
			lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
			lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B
		}
	}
	
	public static MarginLayoutParams newLayoutParams(ViewGroup aparent, ViewGroup.MarginLayoutParams baseparams) {
		if (aparent instanceof FrameLayout) {
			return new FrameLayout.LayoutParams(baseparams);
		} else if (aparent instanceof RelativeLayout) {
			return new RelativeLayout.LayoutParams(baseparams);
		} else if (aparent instanceof ViewGroup) {
			return new  RelativeLayout.LayoutParams(baseparams);			
		} else if (aparent instanceof LinearLayout) {
			return new LinearLayout.LayoutParams(baseparams);
		} else if (aparent == null) {
			throw new NullPointerException("Parent is null");
		} else {
			throw new IllegalArgumentException("LAMW/jCommons: Parent is neither FrameLayout or RelativeLayout or LinearLayout: [ "
					+ aparent.getClass().getName() + " ]");
		}
	}
	
	public long getPasObj() {
		return PasObj;
	}
	
	public void setParent( android.view.ViewGroup _viewgroup) {
		if ( (parent != null) && (aOwnerView != null) ) { parent.removeView(aOwnerView); }
		parent = _viewgroup;
		if ( (parent != null) && (aOwnerView != null) ) {
			parent.addView(aOwnerView,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));
			lparams = null;
			lparams = (ViewGroup.MarginLayoutParams)aOwnerView.getLayoutParams();
		}
		mRemovedFromParent = false;
	}
	
	public ViewGroup getParent() {
		return parent;
	}
	
	public void removeFromViewParent() {
		if (!mRemovedFromParent) {
			if (aOwnerView != null)  {
				aOwnerView.setVisibility(android.view.View.INVISIBLE);
				if (parent != null) parent.removeView(aOwnerView);
			}
			mRemovedFromParent = true;
		}
	}
	
	public void setMarginLeftTopRightBottom(int _left, int _top,int _right, int _bottom) {
		marginLeft = _left;
		marginTop = _top;
		marginRight = _right;
		marginBottom = _bottom;
	    lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom);
		if (aOwnerView != null)  
			aOwnerView.setLayoutParams(lparams);
    }
	
	public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		marginLeft = _left;
		marginTop = _top;
		marginRight = _right;
		marginBottom = _bottom;
		lparamH = _h;
		lparamW = _w;		
	}
	
	public void setLParamWidth(int _w) {
		lparamW = _w;
		lparams.width  = lparamW;
	}
	
	public void setLParamHeight(int _h) {
		lparamH = _h;
		lparams.height = lparamH;
	}
		
	public int getLParamHeight() {
		int r = lparamH;		
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			r = aOwnerView.getHeight();
		}		
		return r;
	}

	public int getLParamWidth() {				
		int r = lparamW;		
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			r = aOwnerView.getWidth();
		}		
		return r;		
	}	
	
	public void setLGravity(int _g) {
		lgravity = _g;
	}
	
	public void setLWeight(float _w) {
		lweight = _w;
	}
	
	public void addLParamsAnchorRule(int _rule) {
		lparamsAnchorRule[countAnchorRule] = _rule;
		countAnchorRule = countAnchorRule + 1;
	}
	
	public void addLParamsParentRule(int _rule) {
		lparamsParentRule[countParentRule] = _rule;
		countParentRule = countParentRule + 1;
	}
	
	public void setLayoutAll(int _idAnchor) {
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
				((RelativeLayout.LayoutParams)lparams).addRule(lparamsParentRule[j]);
			}
		}
		if (lparams instanceof FrameLayout.LayoutParams) {
			((FrameLayout.LayoutParams)lparams).gravity = lgravity;
		}
		if (lparams instanceof LinearLayout.LayoutParams) {
			((LinearLayout.LayoutParams)lparams).weight = lweight;
		}
		if (aOwnerView != null) { aOwnerView.setLayoutParams(lparams); }
	}
	
	public void clearLayoutAll() {
		if (lparams instanceof RelativeLayout.LayoutParams) {
			for (int i = 0; i < countAnchorRule; i++) {								
			  if(Build.VERSION.SDK_INT < 17)
				  ((android.widget.RelativeLayout.LayoutParams) lparams).addRule(lparamsAnchorRule[i], 0);
				
//[ifdef_api17up]
			 if(Build.VERSION.SDK_INT >= 17)
				((android.widget.RelativeLayout.LayoutParams) lparams).removeRule(lparamsAnchorRule[i]); //need API >= 17!
//[endif_api17up]
			}
			for (int j = 0; j < countParentRule; j++) {
			  if(Build.VERSION.SDK_INT < 17) 
				  ((android.widget.RelativeLayout.LayoutParams) lparams).addRule(lparamsParentRule[j], 0);
				
//[ifdef_api17up]
			if(Build.VERSION.SDK_INT >= 17)
				  ((android.widget.RelativeLayout.LayoutParams) lparams).removeRule(lparamsParentRule[j]);  //need API >= 17!
//[endif_api17up]
			}
		}
		countAnchorRule = 0;
		countParentRule = 0;
	}	
	
	public void free() {
		if ( (parent != null) && (aOwnerView != null))  { parent.removeView(aOwnerView); }
		lparams = null;
	}
	
	public void MatchParent() {		
		lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
		lparamH = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
		lparams.width = lparamW;
		lparams.height = lparamH;
		
		if (aOwnerView != null)    //addded
			aOwnerView.setLayoutParams(lparams);
		
	}
	
	public void WrapParent() {
		lparamW = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
		lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
		lparams.width = lparamW;
		lparams.height = lparamH;
		
		if (aOwnerView != null)  //addded
			aOwnerView.setLayoutParams(lparams);
		
	}

}
