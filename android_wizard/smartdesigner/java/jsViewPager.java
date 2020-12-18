package org.lamw.appcompatviewpagerdemo1;


import java.util.ArrayList;
import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import com.google.android.material.appbar.AppBarLayout;
import androidx.coordinatorlayout.widget.CoordinatorLayout;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.PagerTabStrip;
import androidx.viewpager.widget.PagerTitleStrip;
import androidx.viewpager.widget.ViewPager;

class CustomPagerAdapter extends PagerAdapter {

    private Context mContext;
    
    public ArrayList<View> Layouts = new ArrayList<View>();
    public ArrayList<String> Titles = new ArrayList<String>();
    
    public CustomPagerAdapter(Context context) {
        mContext = context;
    }

    /*
     * 
     The object being returned by this method is also used later on, 
     as the second parameter in the isViewFromObject method. 
     */
    @Override
    public Object instantiateItem(ViewGroup collection, int position) {
    	    	
    	View viewChild = Layouts.get(position); 
    	
    	if( viewChild == null ) return null;
    	
    	RelativeLayout layout = new RelativeLayout(collection.getContext());
    	ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(ViewPager.LayoutParams.MATCH_PARENT, 
    			                                                   ViewPager.LayoutParams.MATCH_PARENT);
        layout.setLayoutParams(params);        
        collection.addView(layout);
        
        layout.addView(viewChild, params);
    	
    	return layout;    	    
    }

    @Override
    public void destroyItem(ViewGroup collection, int position, Object view) {
    	
        View viewChild = Layouts.get(position); 
    	
    	if( viewChild == null ) return;
    	
    	((RelativeLayout) view).removeView(viewChild);
    	
    	((ViewPager)collection).removeView((RelativeLayout) view);
    }

    @Override
    public int getCount() {
        return Layouts.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return (view == object);
    }

    /*
     * This method checks whether a particular object belongs to a given position, which is made simple 
     * in this examplejust check whether the View equals the object (i.e., points to the same reference)
     */
    
    @Override
    public CharSequence getPageTitle(int position) {
        return Titles.get(position); 
    }
                
    public void addPage(View _view, String _title) {
       Layouts.add(_view);
       Titles.add(_title);
       this.notifyDataSetChanged();
    }

}

/*Draft java code by "Lazarus Android Module Wizard" [1/6/2018 23:08:48]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
public class jsViewPager extends ViewPager /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   //private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   
   CustomPagerAdapter adapter; 
   private int CountPage = 0;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsViewPager(Controls _ctrls, long _Self, int _pageStrip) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);
                  
      if (_pageStrip == 1) {            
         PagerTabStrip strip = new PagerTabStrip(context);
         ViewPager.LayoutParams layoutParams = new ViewPager.LayoutParams();      
         layoutParams.width = ViewPager.LayoutParams.MATCH_PARENT;
         layoutParams.height = ViewPager.LayoutParams.WRAP_CONTENT;
         layoutParams.gravity = Gravity.TOP;
         this.addView(strip, layoutParams);      
      }
      else if (_pageStrip == 2) {            
          PagerTabStrip strip = new PagerTabStrip(context);
          ViewPager.LayoutParams layoutParams = new ViewPager.LayoutParams();      
          layoutParams.width = ViewPager.LayoutParams.MATCH_PARENT;
          layoutParams.height = ViewPager.LayoutParams.WRAP_CONTENT;
          layoutParams.gravity = Gravity.BOTTOM;
          this.addView(strip, layoutParams);      
      }      //PagerTitleStrip is a non-interactive indicator of the current, next, and previous pages of a ViewPager.
      else if (_pageStrip == 3) {
          PagerTitleStrip strip = new PagerTitleStrip(context);
          ViewPager.LayoutParams layoutParams = new ViewPager.LayoutParams();      
          layoutParams.width = ViewPager.LayoutParams.MATCH_PARENT;
          layoutParams.height = ViewPager.LayoutParams.WRAP_CONTENT;
          layoutParams.gravity = Gravity.TOP;
          this.addView(strip, layoutParams);
      }           
      else if (_pageStrip == 4) {
          PagerTitleStrip strip = new PagerTitleStrip(context);
          ViewPager.LayoutParams layoutParams = new ViewPager.LayoutParams();      
          layoutParams.width = ViewPager.LayoutParams.MATCH_PARENT;
          layoutParams.height = ViewPager.LayoutParams.WRAP_CONTENT;
          layoutParams.gravity = Gravity.BOTTOM;
          this.addView(strip, layoutParams);
      }
      
      adapter = new CustomPagerAdapter(context);
      this.setAdapter(adapter);
      
      /*
      onClickListener = new OnClickListener(){
      public void onClick(View view){     // *.* is a mask to future parse...;
              if (enabled) {
                 controls.pOnClickGeneric(pascalObj); //JNI event onClick!
              }
           };
      };
      setOnClickListener(onClickListener);
      */           
   } //end constructor

   public void jFree() {
      //free local objects...
  	 //setOnClickListener(null);
	 LAMWCommon.free();
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
     
   public void AddPage(View _view, String _title) {
	  if( _view == null ) return;
	  
	  ViewGroup parent = (ViewGroup) _view.getParent();
	  
	  if (parent != null) parent.removeView(_view);
	 
	  adapter.addPage(_view, _title);
   }
   
   
   public String GetPageTitle(int _position) {	   
       return (String) adapter.getPageTitle(_position); 
   }
   
   public void SetFitsSystemWindows(boolean _value) {
		LAMWCommon.setFitsSystemWindows(_value);
   }
   
   public int GetPosition() {                  	   
   	  return this.getCurrentItem();   	  
   }
      
   public void SetPosition(int _position) {
	  this.setCurrentItem(_position); 	  
   }
   
   public void SetAppBarLayoutScrollingViewBehavior() { //This attribute will trigger event in the Toolbar.
	     CoordinatorLayout.LayoutParams params = (CoordinatorLayout.LayoutParams)this.getLayoutParams();
	     params.setBehavior(new AppBarLayout.ScrollingViewBehavior(context, null));
	     this.requestLayout();
   }
   
   public void SetClipToPadding(boolean _value) {
	   this.setClipToPadding(_value);
   }
   
   public void SetBackgroundToPrimaryColor() {	   
	   this.setBackgroundColor(LAMWCommon.getColorFromResources(context, R.color.primary)); 
   }

   public void SetPageMargin(int _value) {
       this.setPageMargin(_value);
   }
}
