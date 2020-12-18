package org.lamw.appcompattablayoutdemo1;

import android.content.Context;
import android.content.res.ColorStateList;
import android.os.Build;
import android.view.View;
import android.view.ViewGroup;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;
import androidx.coordinatorlayout.widget.CoordinatorLayout;

/*Draft java code by "Lazarus Android Module Wizard" [12/2/2017 16:23:10]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
public class jsFloatingButton extends FloatingActionButton /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsFloatingButton(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);

      onClickListener = new OnClickListener(){
      /*.*/public void onClick(View view){     // *.* is a mask to future parse...;
              if (enabled) {
                 controls.pOnClickGeneric(pascalObj); //JNI event onClick!
              }
           };
      };
      setOnClickListener(onClickListener);      
      this.setCompatElevation(20);            
   } //end constructor

   public void jFree() {
      //free local objects...
  	 setOnClickListener(null);
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
	 return LAMWCommon.getLParamHeight();
   }

   public void SetLGravity(int _g) {
  	  LAMWCommon.setLGravity(_g);  //Gravity.TOP | Gravity.START
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
   
   public void SetVisibility(int _value) {  //	   
	  this.setVisibility(_value);   //View.GONE=8   View.VISIBLE=0  View.INVISIBLE=4
   }
   
   public void SetCompatElevation(float _value){
	   this.setCompatElevation(_value);
   }
   
   public void SetImage(String _imageIdentifier) { 
	   int imageId =  controls.activity.getResources().getIdentifier(_imageIdentifier, "drawable", controls.activity.getPackageName());
       this.setImageResource(imageId);  //this.SetImageResource("ic_launcher");            
   }
   
   
   public void SetSize(int _value) {	   
	   this.setSize(_value);  //SIZE_MINI  SIZE_AUTO  SIZE_NORMAL
   }
   
   /*
    fab.setColor(Color.RED);
    // NOTE invoke this method after setting new values!
    fab.initBackground();
    */
   
   /*
    * As described in the documentation, 
    * by default it takes the color set in styles.xml attribute colorAccent.
    */
   //this.setSupportButtonTintList(ContextCompat.getColorStateList(Activity.this, R.color.colorPrimary));
   public void SetBackgroundTintList(int _color) {   //Pascal: SetColor/Background
      this.setBackgroundTintList(ColorStateList.valueOf(_color));   //Color.YELLOW     
      //this.setRippleColor(Color.YELLOW);
   }
   
   //pressed ...
   public void SetPressedRippleColor(int _color) {
     this.setRippleColor(_color);
   //this.setRippleColor(Color.YELLOW);
   }
   
   public void SetContentDescription(String _contentDescription) {
	   this.setContentDescription(_contentDescription);	   
   }
   
   /*
   public void ShowSnackbar(CoordinatorLayout _coordinatorLayout, String _mensage) {	   
	   Snackbar.make(_coordinatorLayout,
			   _mensage, Snackbar.LENGTH_LONG)
               .setAction("CLOSE", new View.OnClickListener() {
                   @Override
                   public void onClick(View v) {
                       // Custom action
                   }
               }).show();	   
   }
   */
   
   public void ShowSnackbar(String _message) {
	   ViewGroup _coordinatorLayout = GetParent();	   
	   if (_coordinatorLayout instanceof CoordinatorLayout) {		   
	      Snackbar.make(_coordinatorLayout,
	    		  _message, Snackbar.LENGTH_LONG)
               .setAction("CLOSE", new View.OnClickListener() {
                   @Override
                   public void onClick(View v) {
                       // Custom action
                   }
               }).show();	   
	   }
   }
   
   public void SetFitsSystemWindows(boolean _value) {
		LAMWCommon.setFitsSystemWindows(_value);
   }
   
   public void SetAnchorGravity(int _gravity, int _anchorId) {
	   LAMWCommon.setAnchorLGravity(_gravity, _anchorId);
   }
   
   public void SetBackgroundToPrimaryColor() {	   
	   this.setBackgroundColor(LAMWCommon.getColorFromResources(context, R.color.primary)); 
   }
   
   public void BringToFront() {
		this.bringToFront();	
		if (Build.VERSION.SDK_INT < 19 ) {			
			ViewGroup parent = LAMWCommon.getParent();
	       	if (parent!= null) {
	       		parent.requestLayout();
	       		parent.invalidate();	
	       	}
		}		
		this.setVisibility(android.view.View.VISIBLE);
   }
}
