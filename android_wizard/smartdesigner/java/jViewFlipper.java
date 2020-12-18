package org.lamw.appviewflipperdemo2;


import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Path;
import android.graphics.Rect;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
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
    private OnLongClickListener onLongClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
      
   float initialXPoint = 0;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jViewFlipper(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
	   
      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      LAMWCommon = new jCommons(this,context,pascalObj);

      //detector = new GestureDetector(controls.activity, new SwipeGestureDetector() );

      onClickListener = new OnClickListener(){
          /*.*/public void onClick(View view){     // *.* is a mask to future parse...;
             if (enabled) {
                controls.pOnClickGeneric(pascalObj); //JNI event onClick!
             }
           };
      };

       setOnClickListener(onClickListener);
       onLongClickListener = new OnLongClickListener(){
           /*.*/public boolean onLongClick(View view){     // *.* is a mask to future parse...;
               if (enabled) {
                   controls.pOnLongClick(pascalObj); //JNI event onClick!
               }
               return true;
           };
       };

       this.setOnLongClickListener(onLongClickListener);

       this.setAutoStart(false); // set true value for auto start the flipping between views
	  	        
   } //end constructor   
   
   public void jFree() {
      //free local objects...
  	  setOnClickListener(null);
  	  this.setOnLongClickListener(null);
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

 //https://stackoverflow.com/questions/25781003/android-simple-fade-out-and-fade-in-animation-for-viewflipper
    //http://www.learn-android-easily.com/2013/06/android-viewflipper-example.html
    public void Next() {
        // set the required Animation type to ViewFlipper
        // The Next screen will come in form Left and current Screen will go OUT from Right
        this.setInAnimation(controls.activity, R.anim.in_from_left);
        this.setOutAnimation(controls.activity, R.anim.out_to_right);
        // Show the next Screen
       this.showNext();
   }

   public void Previous() {
       // set the required Animation type to ViewFlipper
       // The Next screen will come in form Right and current Screen will go OUT from Left
       this.setInAnimation(controls.activity, R.anim.in_from_right);
       this.setOutAnimation(controls.activity, R.anim.out_to_left);
       this.showPrevious();
   }

    public  void AddView(String _fullPathToImage, int _scaleType, boolean _roundedShape) {

       if (_fullPathToImage.equals("")) { return; };

        ImageView itemImage = new ImageView(controls.activity);
        itemImage.setImageResource(android.R.color.transparent);
        Bitmap bmp = BitmapFactory.decodeFile(_fullPathToImage);
        switch(_scaleType) {
            case 0: itemImage.setScaleType(ImageView.ScaleType.CENTER); break;
            case 1: itemImage.setScaleType(ImageView.ScaleType.CENTER_CROP); break;
            case 2: itemImage.setScaleType(ImageView.ScaleType.CENTER_INSIDE); break;
            case 3: itemImage.setScaleType(ImageView.ScaleType.FIT_CENTER); break;
            case 4: itemImage.setScaleType(ImageView.ScaleType.FIT_END); break;
            case 5: itemImage.setScaleType(ImageView.ScaleType.FIT_START); break;
            case 6: itemImage.setScaleType(ImageView.ScaleType.FIT_XY); break;
            case 7: itemImage.setScaleType(ImageView.ScaleType.MATRIX); break;
        }

        if (!_roundedShape)
            itemImage.setImageBitmap(bmp);
        else
            itemImage.setImageBitmap(GetRoundedShape(bmp, 0));

        itemImage.setFocusableInTouchMode(false);
        this.addView(itemImage);
    }

    /*
     * Making image in circular shape
     * http://www.androiddevelopersolutions.com/2012/09/crop-image-in-circular-shape-in-android.html
     */
    public Bitmap GetRoundedShape(Bitmap _bitmapImage, int _diameter) {
        // TODO Auto-generated method stub
        Bitmap sourceBitmap = _bitmapImage;
        Path path = new Path();

        int dim;
        if(_diameter == 0 ) {
            dim = sourceBitmap.getHeight();
            if (dim > sourceBitmap.getWidth()) dim = sourceBitmap.getWidth();
        }
        else {
            dim = _diameter;
            int min;

            if (sourceBitmap.getWidth() <  sourceBitmap.getHeight())
                min = sourceBitmap.getWidth();
            else
                min = sourceBitmap.getHeight();

            if (dim > min) dim = min;
        }

        int targetWidth = dim;
        int targetHeight = dim;

        Bitmap targetBitmap = Bitmap.createBitmap(targetWidth,
                targetHeight,Bitmap.Config.ARGB_8888);

        Canvas canvas = new Canvas(targetBitmap);

        path.addCircle(((float) targetWidth - 1) / 2,
                ((float) targetHeight - 1) / 2,
                (Math.min(((float) targetWidth),
                        ((float) targetHeight)) / 2),
                Path.Direction.CCW);

        canvas.clipPath(path);

        canvas.drawBitmap(sourceBitmap,
                new Rect(0, 0, sourceBitmap.getWidth(),
                        sourceBitmap.getHeight()),
                new Rect(0, 0, targetWidth,
                        targetHeight), null);
        return targetBitmap;
    }

    public Bitmap GetRoundedShape(Bitmap _bitmapImage) {
        return GetRoundedShape(_bitmapImage, 0);
    }

    public void Clear() {
        this.removeAllViews();
    }

}

