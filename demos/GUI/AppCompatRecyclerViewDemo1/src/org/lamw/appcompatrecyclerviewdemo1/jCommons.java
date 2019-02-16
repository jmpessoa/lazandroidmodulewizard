package org.lamw.appcompatrecyclerviewdemo1;

import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.content.Context;
//import android.content.Context;
//import android.graphics.drawable.Drawable;
import android.os.Build;
import android.view.Gravity;
import android.support.design.widget.CoordinatorLayout; //a framelayout like
import android.support.v4.content.res.ResourcesCompat;
//import android.support.v4.content.res.ResourcesCompat;
import android.support.v4.widget.DrawerLayout; //extends ViewGroup
import android.support.design.widget.AppBarLayout; //extends LinearLayout
import android.support.design.widget.CollapsingToolbarLayout; //extends framelayout
import android.support.v4.widget.NestedScrollView; //extends framelayout
import android.support.design.widget.TabLayout;  //framelayout
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
	private float lweight = 0;
	private boolean mRemovedFromParent = false;
	private int algravity;
	private int algravityAnchorId;
	
	public jCommons(View _view, android.content.Context _context, long _pasobj) {
		aOwnerView = _view;       // set owner
		PasObj   = _pasobj; 	//Connect Pascal I/F						
		
		lgravity = Gravity.NO_GRAVITY;
		algravity = Gravity.NO_GRAVITY;
		algravityAnchorId = -1;
		
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
		
		//CollapsingToolbarLayout
		
		if (aparent instanceof NestedScrollView) {
			return new NestedScrollView.LayoutParams(baseparams);
		} else if (aparent instanceof CollapsingToolbarLayout) {
			return new CollapsingToolbarLayout.LayoutParams(baseparams);
		} else if (aparent instanceof FrameLayout) {
			return new FrameLayout.LayoutParams(baseparams);
		} else if (aparent instanceof TabLayout) {
			return new TabLayout.LayoutParams(baseparams);			
		} else if (aparent instanceof CoordinatorLayout) {
			return new CoordinatorLayout.LayoutParams(baseparams);			
		} else if (aparent instanceof DrawerLayout) {
				return new DrawerLayout.LayoutParams(baseparams);		
		} else if (aparent instanceof RelativeLayout) {
			return new RelativeLayout.LayoutParams(baseparams);
		} else if (aparent instanceof ViewGroup) {
			return new  RelativeLayout.LayoutParams(baseparams);
		} else if (aparent instanceof LinearLayout) {
			return new LinearLayout.LayoutParams(baseparams);
		} else if (aparent instanceof AppBarLayout) {
			return new AppBarLayout.LayoutParams(baseparams);			
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
			parent.addView(aOwnerView, newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));
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
		
	public void setAnchorLGravity(int _g, int _anchorId) {
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
		   		 
	 	   if (lparams instanceof CoordinatorLayout.LayoutParams) { 		
				((CoordinatorLayout.LayoutParams)lparams).gravity = lgravity;				
				if (algravityAnchorId >= 0) { 
				    ((CoordinatorLayout.LayoutParams)lparams).anchorGravity = algravity;
				    ((CoordinatorLayout.LayoutParams)lparams).setAnchorId(algravityAnchorId);
				}				
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
		
		
 		if (lparams instanceof CoordinatorLayout.LayoutParams) { 		
			((CoordinatorLayout.LayoutParams)lparams).gravity = lgravity;
			
			/*
			if (algravityAnchorId >= 0) { 
			    ((CoordinatorLayout.LayoutParams)lparams).anchorGravity = algravity;
			    ((CoordinatorLayout.LayoutParams)lparams).setAnchorId(algravityAnchorId);
			}
			*/
			
		}		
 		if (lparams instanceof DrawerLayout.LayoutParams) { 	
			((DrawerLayout.LayoutParams)lparams).gravity = lgravity;
		}		
 		
 		if (lparams instanceof CollapsingToolbarLayout.LayoutParams) {
			((CollapsingToolbarLayout.LayoutParams)lparams).gravity = lgravity;						
		} 		
 		 		
 		if (lparams instanceof NestedScrollView.LayoutParams) {
			((NestedScrollView.LayoutParams)lparams).gravity = lgravity;
		}
 		
 		if (lparams instanceof FrameLayout.LayoutParams) {
			((FrameLayout.LayoutParams)lparams).gravity = lgravity;
		}
 		
 		
 		if (lparams instanceof TabLayout.LayoutParams) {
			((TabLayout.LayoutParams)lparams).gravity = lgravity;
		}
 						
		if (lparams instanceof LinearLayout.LayoutParams) {
			((LinearLayout.LayoutParams)lparams).weight = lweight;
		}		
		if (lparams instanceof AppBarLayout.LayoutParams) {
			((AppBarLayout.LayoutParams)lparams).weight = lweight;
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

	public void setCollapseMode(int _mode) {  //called on JNIPrompt
		
	      ViewGroup.LayoutParams params = aOwnerView.getLayoutParams();
	      CollapsingToolbarLayout.LayoutParams newParams;
	      	      
	      if (params instanceof CollapsingToolbarLayout.LayoutParams) {
	        newParams = (CollapsingToolbarLayout.LayoutParams)params;
	      } else {
	        newParams = new CollapsingToolbarLayout.LayoutParams(params);
	      }
	      
		  int  collapsingMode = 0;
		  switch(_mode) {
		    case 0: collapsingMode = CollapsingToolbarLayout.LayoutParams.COLLAPSE_MODE_PIN; break;
		    case 1: collapsingMode = CollapsingToolbarLayout.LayoutParams.COLLAPSE_MODE_PARALLAX; break;//deafault - imageView
		    case 2: collapsingMode = CollapsingToolbarLayout.LayoutParams.COLLAPSE_MODE_OFF;break;
		  }
		  
	      //CollapsingToolbarLayout.LayoutParams.COLLAPSE_MODE_PARALLAX
	      newParams.setCollapseMode(collapsingMode);  //COLLAPSE_MODE_OFF
	      aOwnerView.setLayoutParams(newParams);
	      aOwnerView.requestLayout();
	}
	
	
    public void	setFitsSystemWindows(boolean _value) {
    	   if (Build.VERSION.SDK_INT >= 21) {
 		      //[ifdef_api21up]
    		   aOwnerView.setFitsSystemWindows(true);
      	      //[endif_api21up]
 	       }
     }
    
    
    public void setScrollFlag(int _collapsingScrollFlag) {   //called in OnJNIPrompt
	       
	      int scrflag = -1;
	      
	      ViewGroup.LayoutParams params1 = aOwnerView.getLayoutParams(); //to clear In order to clear flags params.setScrollFlags(0)
	      AppBarLayout.LayoutParams newParams1;
	      if (params1 instanceof AppBarLayout.LayoutParams) {
	          newParams1 = (AppBarLayout.LayoutParams)params1;
	      } else {
	         newParams1 = new AppBarLayout.LayoutParams(params1);
	      }                            	      
	      switch(_collapsingScrollFlag) {
	        case 0: scrflag =  AppBarLayout.LayoutParams.SCROLL_FLAG_EXIT_UNTIL_COLLAPSED; break;
	        case 1: scrflag =  AppBarLayout.LayoutParams.SCROLL_FLAG_ENTER_ALWAYS_COLLAPSED; break;
	        case 2: scrflag =  AppBarLayout.LayoutParams.SCROLL_FLAG_ENTER_ALWAYS; break;  //default
	        case 3: scrflag =  AppBarLayout.LayoutParams.SCROLL_FLAG_SNAP;  break;
	        case 4: scrflag =  -1;	        
	      }	 
	      
	      if (scrflag >= 0) { 
	          newParams1.setScrollFlags(AppBarLayout.LayoutParams.SCROLL_FLAG_SCROLL | scrflag);  
	          aOwnerView.setLayoutParams(newParams1);
	          aOwnerView.requestLayout();
	      }
    }
    
	/*
	public Drawable GetDrawableResourceById(Context context, int _resID) {
		return ResourcesCompat.getDrawable(context.getResources(),_resID , null);
	}
     */
    
    public int getColorFromResources(Context c, int colorResId) {    	
    	return ResourcesCompat.getColor(c.getResources(), colorResId, null); //without theme
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
			ActivityCompat.requestPermissions(controls.activity, new String[]{androidPermission}, requestCode);
		} //[endif_api23up]
	}


	public static void RequestRuntimePermission(Controls controls, String[] androidPermissions, int requestCode) {  
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
			IsGranted =  ContextCompat.checkSelfPermission(controls.activity, _androidPermission);
		} //[endif_api23up]
		if (IsGranted != PackageManager.PERMISSION_GRANTED) r = false;

		return r;
	}

	public static boolean HasActionBar(Controls controls) {
		android.support.v7.app.ActionBar actionBar = ((AppCompatActivity) controls.activity).getSupportActionBar();
		if (actionBar != null) return true;
		else return false;
	}

	public static void SetActionBarSubTitle(Controls controls, String subtitle) {
		android.support.v7.app.ActionBar actionBar = ((AppCompatActivity) controls.activity).getSupportActionBar();
		if (actionBar != null)
		  ((AppCompatActivity) controls.activity).getSupportActionBar().setSubtitle(subtitle);
	}

	public static void SetActionBarTitle(Controls controls, String title) {
		android.support.v7.app.ActionBar actionBar = ((AppCompatActivity) controls.activity).getSupportActionBar();
		if (actionBar != null)
			((AppCompatActivity) controls.activity).getSupportActionBar().setTitle(title);
	}

	public static void ActionBarHide(Controls controls) {
		android.support.v7.app.ActionBar actionBar = ((AppCompatActivity) controls.activity).getSupportActionBar();
		if (actionBar != null)
			((AppCompatActivity) controls.activity).getSupportActionBar().hide();
	}

	public static void ActionBarShow(Controls controls) {
		android.support.v7.app.ActionBar actionBar = ((AppCompatActivity) controls.activity).getSupportActionBar();
		if (actionBar != null)
			((AppCompatActivity) controls.activity).getSupportActionBar().show();
	}

	public static void ActionBarShowTitle(Controls controls, boolean value) {
		android.support.v7.app.ActionBar actionBar = ((AppCompatActivity) controls.activity).getSupportActionBar();
		if (actionBar != null)
			((AppCompatActivity) controls.activity).getSupportActionBar().setDisplayShowTitleEnabled(value);
	}

	public static void ActionBarShowLogo(Controls controls, boolean value) {
		android.support.v7.app.ActionBar actionBar = ((AppCompatActivity) controls.activity).getSupportActionBar();
		if (actionBar != null)
			((AppCompatActivity) controls.activity).getSupportActionBar().setDisplayUseLogoEnabled(value);
	}

	public static void ActionBarDisplayHomeAsUpEnabled(Controls controls, boolean value) {
		android.support.v7.app.ActionBar actionBar = ((AppCompatActivity) controls.activity).getSupportActionBar();
		if (actionBar != null)
			((AppCompatActivity) controls.activity).getSupportActionBar().setDisplayHomeAsUpEnabled(value);
	}

	public static void ActionBarSetIcon(Controls controls, Drawable icon) {
		android.support.v7.app.ActionBar actionBar = ((AppCompatActivity) controls.activity).getSupportActionBar();
		if (actionBar != null)
			((AppCompatActivity) controls.activity).getSupportActionBar().setIcon(icon);;

	}

	public static void ActionBarSetTabNavigationMode(Controls controls) {
      //not AppCompat ..
	}

	public static void ActionBarRemoveAllTabs(Controls controls) {
		//not AppCompat ..
	}

	public static int ActionGetBarBarHeight(Controls controls) {
		return 0; //not AppCompat ..
	}

	public static boolean ActionBarIsShowing(Controls controls) {
		android.support.v7.app.ActionBar actionBar = ((AppCompatActivity) controls.activity).getSupportActionBar();
		if (actionBar != null)
			return actionBar.isShowing();
		else return false;
	}

	public static boolean IsAppCompatProject() {
		return true;
	}

}
