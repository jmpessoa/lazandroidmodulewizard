package org.lamw.applamwproject2;

import java.lang.reflect.Field;
import android.content.Context;
import android.graphics.Color;
import android.os.Build;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import com.google.android.material.appbar.AppBarLayout;
import com.google.android.material.appbar.CollapsingToolbarLayout;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar; 

/*Draft java code by "Lazarus Android Module Wizard" [10/7/2017 0:29:44]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
public class jsToolbar extends Toolbar /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   //private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   private boolean IsActionBar = false;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsToolbar(Controls _ctrls, long _Self, boolean _asActionBar) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      LAMWCommon = new jCommons(this,context,pascalObj);

     //https://www.101apps.co.za/index.php/articles/using-toolbars-in-your-apps.html
     //you should call this first if you are going to be adding logos and navigation icons
     //else they won't show.
     if (_asActionBar == true)  {  
    	 IsActionBar = true;
         this.SetAsActionBar(true);    
     }          
     //this.setNavigationIcon(android.R.drawable.ic_menu_gallery);
	 this.setNavigationOnClickListener(new View.OnClickListener() {  //trigger only of IsActionBar = false
	       @Override
	       public void onClick(View v) {	    	   
	     	  controls.pOnClickGeneric(pascalObj);        	 
	       }          
	  });            
      /*
       * This is the easiest way to transition from the ActionBar to the new Toolbar,
       *  as all of your existing Action Bar menus will
       *  automatically work if you are inflating them in your OnCreateOptionsMenu method.
       *  ref. https://blog.xamarin.com/android-tips-hello-toolbar-goodbye-action-bar/
       */      
      //http://www.vogella.com/tutorials/AndroidActionBar/article.html
      //try as same actionbar      
      this.setOnMenuItemClickListener(new Toolbar.OnMenuItemClickListener() {             
				@Override
				public boolean onMenuItemClick(MenuItem item) {
					// TODO Auto-generated method stub
					//PASCAL  ..........
					return false;
				}
              });                              
   } //end constructor
   
   public void jFree() {
      //free local objects...
  	 //setOnClickListener(null);
	 LAMWCommon.free();
   }
   
   @Override
   protected void onSizeChanged(int w, int h, int oldw, int oldh) {
   	super.onSizeChanged(w, h, oldw, oldh);
   	
   	// Change the size and update the layout               
    controls.formNeedLayout = true;
    controls.appLayout.requestLayout();
   }
 
   public void SetViewParent(ViewGroup _viewgroup) {
	 LAMWCommon.setParent(_viewgroup);
   }

   public ViewGroup GetParent() {
      return LAMWCommon.getParent();
   }

   public void RemoveFromViewParent() {
  	 LAMWCommon.removeFromViewParent();
   }

   public View GetView() {
      return this;
   }

   public void SetLParamWidth(int _w) {
  	 LAMWCommon.setLParamWidth(_w);
   }

   public void SetLParamHeight(int _h) {
  	 LAMWCommon.setLParamHeight(_h);
   }

   public int GetLParamWidth() {
      return LAMWCommon.getLParamWidth();
   }

   public int GetLParamHeight() {
	 return  LAMWCommon.getLParamHeight();
   }

   public void SetLGravity(int _g) {
  	 LAMWCommon.setLGravity(_g);
   }

   public void SetLWeight(float _w) {
  	 LAMWCommon.setLWeight(_w);
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
      LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
   }

   public void AddLParamsAnchorRule(int _rule) {
	 LAMWCommon.addLParamsAnchorRule(_rule);
   }

   public void AddLParamsParentRule(int _rule) {
	 LAMWCommon.addLParamsParentRule(_rule);
   }

   public void SetLayoutAll(int _idAnchor) {
  	 LAMWCommon.setLayoutAll(_idAnchor);
   }

   public void ClearLayoutAll() {
	 LAMWCommon.clearLayoutAll();
   }

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   
   public void SetTitle(String _title) {
	  if (IsActionBar)
	       ((AppCompatActivity) controls.activity).getSupportActionBar().setTitle(_title);
	  else
		 this.setTitle(_title);  
   }
      
   //Setting navigationIcon
   public void SetNavigationIcon(String _imageIdentifier) {
     this.setNavigationIcon(controls.GetDrawableResourceId(_imageIdentifier)); 
   }
   
  //Setting appIcon
   public void SetLogo(String _imageIdentifier) {
     this.setLogo(controls.GetDrawableResourceId(_imageIdentifier)); 
   }
      
   public void SetAsActionBar(boolean _value) {
	   if (_value) {
 	     IsActionBar = true;
	     ((AppCompatActivity) controls.activity).setSupportActionBar(this);
	   } else {
	 	     IsActionBar = false;
		     ((AppCompatActivity) controls.activity).setSupportActionBar(null);		   
	   }	   
   }
      
   public void SetSubtitle(String _subtitle) {
      if (IsActionBar) ((AppCompatActivity) controls.activity).getSupportActionBar().setSubtitle(_subtitle);
   }

   public void SetHomeButtonEnabled(boolean _value) {
	  if (IsActionBar) { 		  
		  if (_value) {
             ((AppCompatActivity) controls.activity).getSupportActionBar().setHomeButtonEnabled(true);    //Enable or disable the "home" button in the corner of the action bar.
             ((AppCompatActivity) controls.activity).getSupportActionBar().setDisplayHomeAsUpEnabled(true);             
		  }else {
	         ((AppCompatActivity) controls.activity).getSupportActionBar().setHomeButtonEnabled(false);		
	         ((AppCompatActivity) controls.activity).getSupportActionBar().setDisplayHomeAsUpEnabled(false);
		  }
	  }		  
   }
   
   public void SetDisplayHomeAsUpEnabled(boolean _value) {
		  if (IsActionBar) { 		  
			  if (_value) {  //Set this to true if selecting "home" returns up by a single level in your UI rather than back to the top level or front page
	             ((AppCompatActivity) controls.activity).getSupportActionBar().setDisplayHomeAsUpEnabled(true); 
			  }else {
		         ((AppCompatActivity) controls.activity).getSupportActionBar().setDisplayHomeAsUpEnabled(false);			  
			  }
		  }		  
   }   
   
   public void SetDisplayUseLogoEnabled(boolean _value) {
	   if (IsActionBar) 
         ((AppCompatActivity) controls.activity).getSupportActionBar().setDisplayUseLogoEnabled(_value);
   }
   
   public void SetTitleTextColor(int _color) {
	  this.setTitleTextColor(_color);
   }
   
   /*   
   public void SetElevation(int _value) { 
	   ((AppCompatActivity) controls.activity).getSupportActionBar().setElevation(_value);
   }
   */
   
   public void SetScrollFlag(int _collapsingScrollFlag) {   //called in OnJNIPrompt
	   LAMWCommon.setScrollFlag(_collapsingScrollFlag);  
   }
   
   //https://github.com/codepath/android_guides/wiki/Handling-Scrolls-with-CoordinatorLayout
   public void SetCollapseMode(int _collapseMode) {   //called: Pascal "OnJNIPrompt" event
       LAMWCommon.setCollapseMode(_collapseMode);
   }

   /*
   public void SetHeightDP(int  _heightDP) {
	      ViewGroup.LayoutParams params1 = this.getLayoutParams();
	      Toolbar.LayoutParams newParams1;
	      if (params1 instanceof AppBarLayout.LayoutParams) {
	          newParams1 = (Toolbar.LayoutParams)params1;
	      } else {
	         newParams1 = new Toolbar.LayoutParams(params1);
	      }          
	      
	 	// int h =  (int) (_heightDP * getResources().getDisplayMetrics().density);  //_height = 192
	      
	      int h = _heightDP;
	      newParams1.height = h;
	      //this.setMinimumHeight(42);
          this.setLayoutParams(newParams1);
          this.requestLayout();                              
   }
   */
   
   public void	SetFitsSystemWindows(boolean _value) {
		LAMWCommon.setFitsSystemWindows(_value);
   }

   public void SetTheme(int _theme) {
       context.setTheme(_theme);
       //context.setTheme(R.style.AppTheme);  //example in file "style.xml"
       this.invalidate();
   }

   public void SetSubtitleTextColor(int _color) {
      if (IsActionBar == true)  {    	 
       this.setSubtitleTextColor(_color);      
      }   
   }
 
   public void SetBackgroundToPrimaryColor() {	   
	   this.setBackgroundColor(LAMWCommon.getColorFromResources(context, R.color.primary)); 
   }
      
   public int GetPrimaryColor() {	   
	   return LAMWCommon.getColorFromResources(context, R.color.primary); 	   
   }
   
   public int GetSuggestedMinimumHeight() {    
       return this.getSuggestedMinimumHeight();
   }
   
   public void SetSuggestedMinimumHeight() {
       this.setMinimumHeight(this.getSuggestedMinimumHeight());
   }
   
   public void SetMinimumHeight(int _value) {
       this.setMinimumHeight(_value);
   }

   public void SetHeightByDisplayMetricsDensity(int  _value) {
	      ViewGroup.LayoutParams params1 = this.getLayoutParams();
	      Toolbar.LayoutParams newParams1;
	      if (params1 instanceof AppBarLayout.LayoutParams) {
	          newParams1 = (Toolbar.LayoutParams)params1;
	      } else {
	         newParams1 = new Toolbar.LayoutParams(params1);
	      }          	      
	 	 int h =  (int) (_value * getResources().getDisplayMetrics().density);  //_height = 192	      	     
	     newParams1.height = h;
	      //this.setMinimumHeight(42);
         this.setLayoutParams(newParams1);
         this.requestLayout();                              
   }


}

