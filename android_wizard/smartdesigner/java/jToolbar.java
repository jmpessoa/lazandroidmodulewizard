package org.law.apptoolbardemo2;


import java.lang.reflect.Field;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toolbar;   //API 21+ 

/*Draft java code by "Lazarus Android Module Wizard" [10/7/2017 0:29:44]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
public class jToolbar extends Toolbar /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   //private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   private boolean IsActionBar = false;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jToolbar(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);
      /*
      onClickListener = new OnClickListener(){
      public void onClick(View view){     // *.* is a mask to future parse...;
              if (enabled) {
                 controls.pOnClickGeneric(pascalObj, Const.Click_Default); //JNI event onClick!
              }
           };
      };
      setOnClickListener(onClickListener);
      */
            
      this.setNavigationOnClickListener(new View.OnClickListener() {  //trigger only of IsActionBar = false
          @Override
          public void onClick(View v) {
        	  controls.pOnClickGeneric(pascalObj, Const.Click_Default);
          }          
      });
      
      /*
       * This is the easiest way to transition from the ActionBar to the new Toolbar,
       *  as all of your existing Action Bar menus will
       *  automatically work if you are inflating them in your OnCreateOptionsMenu method.
       *  ref. https://blog.xamarin.com/android-tips-hello-toolbar-goodbye-action-bar/
       */
      
      //http://www.vogella.com/tutorials/AndroidActionBar/article.html
      /* try as same actionbar
      this.setOnMenuItemClickListener(
              new Toolbar.OnMenuItemClickListener() {
                  @Override
                  public boolean onMenuItemClick(MenuItem item) {
                	  //Log.i("id = "+item.getItemId());
                	  //Log.i(item.getTitle());  
                	  return true;
                  }
              });      
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
   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }
   
   private int GetDrawableResourceId(String _resName) {
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     Log.e("jToolbar", "Failure to get drawable resource id...", e);
		     return 0;
		  }
	}
   
   //this.setNavigationIcon(android.R.drawable.btn_star);
   //this.setTitle("Hello World!");
   //this.setLogo(R.drawable.ic_launcher);        
   //if (IsActionBar) controls.activity.setActionBar(this);                 
   //controls.activity.getActionBar().setSubtitle("Ola!");   
   //controls.activity.getActionBar().setDisplayHomeAsUpEnabled(true);
   //controls.activity.getActionBar().setHomeButtonEnabled(true);      

   public void SetTitle(String _title) {
       this.setTitle(_title);
   }
      
   //Setting navigationIcon
   public void SetNavigationIcon(String _imageIdentifier) {
     this.setNavigationIcon(GetDrawableResourceId(_imageIdentifier)); //R.drawable.ic_launcher;
   }
   
  //Setting appIcon
   public void SetLogo(String _imageIdentifier) {
     this.setLogo(GetDrawableResourceId(_imageIdentifier)); //R.drawable.ic_launcher
   }
      
   public void SetAsActionBar(boolean _value) {
	   if (_value) {
 	     IsActionBar = true;
	     controls.activity.setActionBar(this);
	   } else {
	 	     IsActionBar = false;
		     controls.activity.setActionBar(null);		   
	   }	   
   }
      
   public void SetSubtitle(String _subtitle) {
       if (IsActionBar) controls.activity.getActionBar().setSubtitle(_subtitle);
   }

   public void SetHomeButtonEnabled(boolean _value) {
	  if (IsActionBar) { 		  
		  if (_value) {
             controls.activity.getActionBar().setHomeButtonEnabled(true);    //Enable or disable the "home" button in the corner of the action bar.
             controls.activity.getActionBar().setDisplayHomeAsUpEnabled(true);             
		  }else {
	         controls.activity.getActionBar().setHomeButtonEnabled(false);		
	         controls.activity.getActionBar().setDisplayHomeAsUpEnabled(false);
		  }
	  }		  
   }
   
   public void SetDisplayHomeAsUpEnabled(boolean _value) {
		  if (IsActionBar) { 		  
			  if (_value) {  //Set this to true if selecting "home" returns up by a single level in your UI rather than back to the top level or front page
	             controls.activity.getActionBar().setDisplayHomeAsUpEnabled(true); 
			  }else {
		         controls.activity.getActionBar().setDisplayHomeAsUpEnabled(false);			  
			  }
		  }		  
   }
     
}
