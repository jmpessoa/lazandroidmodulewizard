package com.example.appnotificationmanagerdemo1;

import android.app.ActionBar;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
//import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.view.View.MeasureSpec;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.content.Context;
import android.os.Build;
import android.view.Gravity;

import java.io.File;
//import android.util.Log;

public class jCommons {

    //owner of this instance
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
	private float lweight = 1.0f;
	private boolean mRemovedFromParent = false;
	private int algravity;
	private int algravityAnchorId;
	
	private android.content.Context context;

	public jCommons(View _view, android.content.Context _context, long _pasobj) {
		aOwnerView = _view;       // set owner
		PasObj   = _pasobj; 	//Connect Pascal I/F						
		lgravity = Gravity.NO_GRAVITY;
		algravity = Gravity.NO_GRAVITY;
        algravityAnchorId = -1;
                
        context = _context;

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

	public static  MarginLayoutParams newLayoutParams(ViewGroup aparent, ViewGroup.MarginLayoutParams baseparams) {
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

			if (parent instanceof LinearLayout) {
				parent.addView(aOwnerView, 0, newLayoutParams(parent, (ViewGroup.MarginLayoutParams) lparams));
			}
			else {
				parent.addView(aOwnerView, newLayoutParams(parent, (ViewGroup.MarginLayoutParams) lparams));
			}

			lparams = null;
			lparams = (ViewGroup.MarginLayoutParams)aOwnerView.getLayoutParams();
			aOwnerView.setVisibility(android.view.View.VISIBLE);			
		}
		mRemovedFromParent = false;		
	}
	
	public void AddView(View _view) {			
		  ViewGroup parent = (ViewGroup) _view.getParent();
		  ViewGroup.MarginLayoutParams vParam = null; // layout XYWH
		  vParam = new ViewGroup.MarginLayoutParams(android.view.ViewGroup.LayoutParams.MATCH_PARENT, android.view.ViewGroup.LayoutParams.MATCH_PARENT);     // W,H 
		  if (parent != null) parent.removeView(_view);	 		  
		  ((ViewGroup) aOwnerView).addView(_view, newLayoutParams((ViewGroup) _view,(ViewGroup.MarginLayoutParams)vParam));
	}
	
	public ViewGroup getParent() {
		return parent;
	}
	
	public void BringToFront() {
		 if (Build.VERSION.SDK_INT < 19 ) {
	       	if (parent!= null) {
	       		parent.requestLayout();
	       		parent.invalidate();	
	       	}
	     }		
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


	public void setVisibilityGone() {
			if (aOwnerView != null)  {
				aOwnerView.setVisibility(android.view.View.GONE);
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
			int widthPixels = context.getResources().getDisplayMetrics().widthPixels;				
			
			int widthMeasureSpec  = View.MeasureSpec.makeMeasureSpec(widthPixels, View.MeasureSpec.AT_MOST);
		    int heightMeasureSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		    aOwnerView.measure(widthMeasureSpec, heightMeasureSpec);
		    			
			r = aOwnerView.getMeasuredHeight();
		}
		
		//Fix the "match_parent" error with an "anchor" and 
		// within the component a "half_parent" is set
		if (r == android.view.ViewGroup.LayoutParams.MATCH_PARENT) {
			if( aOwnerView.getHeight() > 0 ) r = aOwnerView.getHeight();			
		}
		
		return r;
	}

	public int getLParamWidth() {				
		int r = lparamW;
		
		if (r == android.view.ViewGroup.LayoutParams.WRAP_CONTENT) {
			int widthPixels = context.getResources().getDisplayMetrics().widthPixels;
			
			int widthMeasureSpec  = View.MeasureSpec.makeMeasureSpec(widthPixels, View.MeasureSpec.AT_MOST);
		    int heightMeasureSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
		    aOwnerView.measure(widthMeasureSpec, heightMeasureSpec);
		   			
			r = aOwnerView.getMeasuredWidth();		
		}
		
		//Fix the "match_parent" error with an "anchor" and 
		// within the component a "half_parent" is set
		if (r == android.view.ViewGroup.LayoutParams.MATCH_PARENT) {  
			if( aOwnerView.getWidth() > 0 ) r = aOwnerView.getWidth(); 
		}
		
		return r;		
	}	
	
	public void setLGravity(int _g) {
	      int LEFT;
	      int RIGHT;   
	      //[ifdef_api14up]
	      LEFT = Gravity.START;             
	      RIGHT = Gravity.END;               
	      //[endif_api14up]
	       /* //[endif_api14up]
	       LEFT =  Gravity.LEFT;          
	       RIGHT =  Gravity.RIGHT;
	       //[ifdef_api14up] */	   	   
		   switch(_g) {	   
		   case 0: lgravity = Gravity.NO_GRAVITY; break;
		   case 1: lgravity = LEFT | Gravity.TOP; break;
		   case 2: lgravity = Gravity.CENTER_HORIZONTAL | Gravity.TOP; break;
		   case 3: lgravity = RIGHT | Gravity.TOP; break;
		   
		   case 4: lgravity = LEFT | Gravity.BOTTOM; break;
		   case 5: lgravity = Gravity.CENTER_HORIZONTAL | Gravity.BOTTOM; break;
		   case 6: lgravity = RIGHT | Gravity.BOTTOM; break;
		   
		   case 7: lgravity = Gravity.CENTER; break;
		   	   
		   case 8: lgravity = LEFT | Gravity.CENTER_VERTICAL; break;	   	  	   
		   case 9: lgravity = RIGHT | Gravity.CENTER_VERTICAL; break;
		   	   
		   case 10: lgravity = LEFT; break;	   	  	   
		   case 11: lgravity = RIGHT;break;
		   
		   case 12: lgravity = Gravity.TOP; break;	   	  	   
		   case 13: lgravity = Gravity.BOTTOM;break;

		   }						
	}

	public void setAnchorLGravity(int _g,  int _anchorId) {
	      int LEFT;
	      int RIGHT;   
	      //[ifdef_api14up]
	      LEFT = Gravity.START;             
	      RIGHT = Gravity.END;               
	      //[endif_api14up]
	       /* //[endif_api14up]
	       LEFT =  Gravity.LEFT;          
	       RIGHT =  Gravity.RIGHT;
	       //[ifdef_api14up] */	   	 
  
                   algravityAnchorId = _anchorId;
		   switch(_g) {	   
		   case 0: algravity = Gravity.NO_GRAVITY; break;
		   case 1: algravity = LEFT | Gravity.TOP; break;
		   case 2: algravity = Gravity.CENTER_HORIZONTAL | Gravity.TOP; break;
		   case 3: algravity = RIGHT | Gravity.TOP; break;
		   
		   case 4: algravity = LEFT | Gravity.BOTTOM; break;
		   case 5: algravity = Gravity.CENTER_HORIZONTAL | Gravity.BOTTOM; break;
		   case 6: algravity = RIGHT | Gravity.BOTTOM; break;
		   
		   case 7: algravity = Gravity.CENTER; break;
		   	   
		   case 8: algravity = LEFT | Gravity.CENTER_VERTICAL; break;	   	  	   
		   case 9: algravity = RIGHT | Gravity.CENTER_VERTICAL; break;
		   	   
		   case 10: algravity = LEFT; break;	   	  	   
		   case 11: algravity = RIGHT;break;
		   
		   case 12: algravity = Gravity.TOP; break;	   	  	   
		   case 13: algravity = Gravity.BOTTOM;break;

		   }						
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
 		
		if (lparams instanceof LinearLayout.LayoutParams) { //.weight
                        ((LinearLayout.LayoutParams)lparams).weight = lweight; //lweight = 1 <-- the trick!!
			((LinearLayout.LayoutParams)lparams).gravity = lgravity; //lweight;
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
		
		if (aOwnerView != null)  
			aOwnerView.setLayoutParams(lparams);		
	}
	
	public void WrapParent() {
		lparamW = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
		lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
		lparams.width = lparamW;
		lparams.height = lparamH;
		
		if (aOwnerView != null) 
			aOwnerView.setLayoutParams(lparams);		
	}
	
	public void CenterInParent() {		
		//resetLParamsRules();  need ???		
		if (lparams instanceof RelativeLayout.LayoutParams) {
			((RelativeLayout.LayoutParams)lparams).addRule(android.widget.RelativeLayout.CENTER_IN_PARENT);  //android.widget.RelativeLayout.CENTER_VERTICAL = 15			
			aOwnerView.setLayoutParams(lparams);  //added     ::need ??	
			countParentRule = countParentRule + 1;
		}
	}

	public void setCollapseMode(int _mode) {  
		//AppCompat theme
	}
		
        public void setFitsSystemWindows(boolean _value) {
    	     //AppCompat theme
        }

    public void setScrollFlag(int _collapsingScrollFlag) {  
        //AppCompat theme
    }

    public int getColorFromResources(Context c, int colorResId) {    	
    	return 0;
    }

    public int getColorPrimaryId() {
    	return  R.color.primary;
    }
    
    public int getColorPrimaryDarkId() {
    	return  R.color.primary_dark;
    }
    
    public int getColorPrimaryLightId() {
    	return  R.color.primary_light;
    }

    public int getColorAccentId() {
    	return  R.color.accent;
    }

	public static void RequestRuntimePermission(Controls controls, String androidPermission, int requestCode) {  //"android.permission.CAMERA"
		//[ifdef_api23up]
		if (Build.VERSION.SDK_INT >= 23) {
			controls.activity.requestPermissions(new String[]{androidPermission}, requestCode);
		} //[endif_api23up]
	}

	public static void RequestRuntimePermission(Controls controls, String[] androidPermissions, int requestCode) {  //"android.permission.CAMERA"
		//[ifdef_api23up]
		if (Build.VERSION.SDK_INT >= 23) {
			controls.activity.requestPermissions(androidPermissions, requestCode);
		} //[endif_api23up]
	}

	public static boolean IsRuntimePermissionGranted(Controls controls, String _androidPermission) {  //"android.permission.CAMERA"
		boolean r = true;
		int IsGranted = PackageManager.PERMISSION_GRANTED; //0    PERMISSION_DENIED = -1
		//[ifdef_api23up]
		if (Build.VERSION.SDK_INT >= 23) {
			IsGranted =  controls.activity.checkSelfPermission(_androidPermission);
		} //[endif_api23up]
		if (IsGranted != PackageManager.PERMISSION_GRANTED) r = false;

		return r;
	}

	public static boolean HasActionBar(Controls controls) {
		ActionBar actionBar = (controls.activity).getActionBar();
		if (actionBar != null) return true;
		else return false;
	}

	public static void SetActionBarSubTitle(Controls controls, String subtitle) {
		ActionBar actionBar = (controls.activity).getActionBar();
		if (actionBar != null)
			(controls.activity).getActionBar().setSubtitle(subtitle);
	}

	public static void SetActionBarTitle(Controls controls, String title) {
		ActionBar actionBar = (controls.activity).getActionBar();
		if (actionBar != null)
			(controls.activity).getActionBar().setTitle(title);
	}

	public static void ActionBarHide(Controls controls) {
		ActionBar actionBar = (controls.activity).getActionBar();
		if (actionBar != null)
			(controls.activity).getActionBar().hide();
	}

	public static void ActionBarShow(Controls controls) {
		ActionBar actionBar = ( controls.activity).getActionBar();
		if (actionBar != null)
			(controls.activity).getActionBar().show();
	}

	public static void ActionBarShowTitle(Controls controls, boolean value) {
		ActionBar actionBar = (controls.activity).getActionBar();
		if (actionBar != null)
			(controls.activity).getActionBar().setDisplayShowTitleEnabled(value);
	}

	public static void ActionBarShowLogo(Controls controls, boolean value) {
		ActionBar actionBar = (controls.activity).getActionBar();
		if (actionBar != null)
			( controls.activity).getActionBar().setDisplayUseLogoEnabled(value);
	}

	public static void ActionBarDisplayHomeAsUpEnabled(Controls controls, boolean value) {
		ActionBar actionBar = (controls.activity).getActionBar();
		if (actionBar != null)
			( controls.activity).getActionBar().setDisplayHomeAsUpEnabled(value);
	}

	public static void ActionBarSetIcon(Controls controls, Drawable icon) {
        ActionBar actionBar = (controls.activity).getActionBar();
		
		if (actionBar != null){		
			if( icon != null ){
				actionBar.setDisplayShowHomeEnabled(true);	       
				actionBar.setIcon(icon);
			} else {
				actionBar.setDisplayShowHomeEnabled(false);
				actionBar.setIcon(null);
			}
		}
	}
	
	public static void ActionBarShowHome(Controls controls, boolean showHome){
		ActionBar actionBar = (controls.activity).getActionBar();
		
		if (actionBar != null){
			actionBar.setDisplayHomeAsUpEnabled(showHome);
			actionBar.setDisplayShowHomeEnabled(showHome);	        						
		}
	}
	
	public static void ActionBarSetColor(Controls controls, int color){
		ActionBar actionBar = (controls.activity).getActionBar();
		
		if (actionBar != null){									
				 actionBar.setBackgroundDrawable(new ColorDrawable(color));						
		}
	}
	
	public static void NavigationSetColor(Controls controls, int color){
			
			if (Build.VERSION.SDK_INT >= 21) {								
					controls.activity.getWindow().setNavigationBarColor(color);								
		    }
			
	}
	
	public static void StatusSetColor(Controls controls, int color){
			
			if (Build.VERSION.SDK_INT >= 21) {								
					controls.activity.getWindow().setStatusBarColor(color);								
		    }
					
	}

	public static void ActionBarSetTabNavigationMode(Controls controls) {
		ActionBar actionBar = (controls.activity).getActionBar();
		if (actionBar != null) {
			actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);    //API 11
			actionBar.setSelectedNavigationItem(0);
		}
	}

	public static void ActionBarRemoveAllTabs(Controls controls) {
		ActionBar actionBar = (controls.activity).getActionBar();
		if (actionBar != null) {
			actionBar.removeAllTabs();
			controls.activity.invalidateOptionsMenu(); // by renabor
			actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_STANDARD); //API 11 renabor
		}
	}

	public static int ActionGetBarBarHeight(Controls controls) {
		ActionBar actionBar = (controls.activity).getActionBar();
		int actionBarHeight = 0;
		TypedValue tv = new TypedValue();
		if (actionBar != null) {
				if (actionBar.isShowing()) {
					if (controls.activity.getTheme().resolveAttribute(android.R.attr.actionBarSize, tv, true)) {
						actionBarHeight = TypedValue.complexToDimensionPixelSize(tv.data, controls.activity.getResources().getDisplayMetrics());
					}
				}
		}
		return actionBarHeight;
	}

	public static boolean ActionBarIsShowing(Controls controls) {
		 ActionBar actionBar = (controls.activity).getActionBar();
		if (actionBar != null)
			return actionBar.isShowing();
		else return false;
	}

	public static boolean IsAppCompatProject() {
		return false;
	}


        public static boolean IsAppCompatProject(Controls controls) {
                //if (controls.activity instanceof AppCompatActivity) return true;
		  //else return false;
                return false;
	}


	public static Uri FileProviderGetUriForFile(Controls controls, File file) {
			return jSupported.FileProviderGetUriForFile(controls, file);
	}

}
