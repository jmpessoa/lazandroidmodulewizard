package com.example.appviewflipperdemo1;


import android.content.Context;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ViewFlipper;

/*Draft java code by "Lazarus Android Module Wizard" [2/5/2017 16:06:56]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/


//ref. http://stacktips.com/tutorials/android/android-viewflipper-example
public class jViewFlipper extends ViewFlipper /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
      
   float initialXPoint = 0;
   Animation slide_in_left, slide_out_right;
   
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jViewFlipper(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
	   
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);

      //detector = new GestureDetector(controls.activity, new SwipeGestureDetector() );

      slide_in_left = AnimationUtils.loadAnimation(controls.activity, android.R.anim.slide_in_left);
      slide_out_right = AnimationUtils.loadAnimation(controls.activity, android.R.anim.slide_out_right);
      
      onClickListener = new OnClickListener(){
      /*.*/public void onClick(View view){     // *.* is a mask to future parse...;
             if (enabled) {
                controls.pOnClickGeneric(pascalObj, Const.Click_Default); //JNI event onClick!
             }
           };
      };
      setOnClickListener(onClickListener);
            
      this.setInAnimation(slide_in_left);
      this.setOutAnimation(slide_out_right);	  
      this.setAutoStart(false); // set true value for auto start the flipping between views
	  	        
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
   
   @Override
   public boolean onInterceptTouchEvent(MotionEvent ev) {
       onTouchEvent(ev);
       return false;   // go to childrens !!!
   }
   
   /*
   @Override
   public boolean onInterceptTouchEvent(MotionEvent ev) {       
       //This method JUST determines whether we want to intercept the motion.
       //If we return true, onTouchEvent will be called and we do the actual
       //scrolling there.
       //  
       // In general, we don't want to intercept touch events. They should be 
       // handled by the child view then should return false.  but .....
       return true;  //!!!! not go to childrens...
   }
   */
   
   @Override
   public boolean onTouchEvent(MotionEvent event) {	
	   
	 switch ( event.getAction() ) {    
       case MotionEvent.ACTION_DOWN: {
          initialXPoint = event.getX();
          break;
       }
       
       case MotionEvent.ACTION_UP: {
    	        float finalx = event.getX();    	        
    	        if (initialXPoint > finalx) {
    	           //if (this.getDisplayedChild() == this.getChildCount())
    	           controls.pOnFlingGestureDetected(pascalObj, 0); //onRightToLeft;           
    	           //this.showNext();
    	        } else {
    	           //if (this.getDisplayedChild() == 0)
    	           controls.pOnFlingGestureDetected(pascalObj, 1);//onLeftToRight();           
    	           //this.showPrevious();
    	        }       
       }
       
     }	 
	 /*
	  * onTouch() - This returns a boolean to indicate whether your listener consumes this event. 
	  * The important thing is that this event can have multiple actions that follow each other. 
	  * So, if you return false when the down action event is received, 
	  * you indicate that you have not consumed the event and are also not interested 
	  * in subsequent actions from this event. 
	  * Thus, you will not be called for any other actions within the event, 
	  * such as a finger gesture, or the eventual up action event
	  */
     return true;   
   }  
      
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public void SetId(int _id) { //wrapper method pattern ...
      this.setId(_id);
   }

   public void SetAutoStart(boolean _value) {
      this.setAutoStart(_value);  //true
   }
   
   public void SetFlipInterval(int _milliseconds) {
      this.setFlipInterval(_milliseconds); //4000
   }
      
   public void StartFlipping() { 	   
	  if(!this.isFlipping()){
         this.startFlipping();
	  }
   }
   
   public void StopFlipping() {	   
	   if(this.isFlipping()){
          this.stopFlipping();
	   }
   }
   
   public void AddView(View _layout) {
      this.addView(_layout);
   }
   
   public void Next() {
	 this.showNext();	
   }	   

   public void Previous() {
	 this.showPrevious();
   }	   
   
}
