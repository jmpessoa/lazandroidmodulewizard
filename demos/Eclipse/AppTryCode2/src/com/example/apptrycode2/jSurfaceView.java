package com.example.apptrycode2;

import java.io.File;
import java.io.FileOutputStream;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.os.AsyncTask;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

/*Draft java code by "Lazarus Android Module Wizard" [6/3/2015 0:43:27]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/
 
public class jSurfaceView  extends SurfaceView  /*dummy*/ { //please, fix what GUI object will be extended!
  
  private long       pascalObj = 0;    // Pascal Object
  private Controls   controls  = null; // Control Class for events
  
  private Context context = null;
  private ViewGroup parent   = null;         // parent view
  private RelativeLayout.LayoutParams lparams;              // layout XYWH 
  //private OnClickListener onClickListener;   // click event
  private Boolean enabled  = true;           // click-touch enabled!
  private int lparamsAnchorRule[] = new int[30];
  private int countAnchorRule = 0;
  private int lparamsParentRule[] = new int[30];
  private int countParentRule = 0;
  private int lparamH = RelativeLayout.LayoutParams.MATCH_PARENT;
  private int lparamW = RelativeLayout.LayoutParams.MATCH_PARENT;
  private int marginLeft = 0;
  private int marginTop = 0;
  private int marginRight = 0;
  private int marginBottom = 0;
  private boolean mRemovedFromParent = false;
  
  private SurfaceHolder surfaceHolder;

  Paint paint;
  
  boolean mRun = false;
  long mSleeptime = 10;
  float mStartProgress = 0;
  float mStepProgress = 1;
  boolean mDrawing = false;
 
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
  public jSurfaceView(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
     super(_ctrls.activity);
     context   = _ctrls.activity;
     pascalObj = _Self;
     controls  = _ctrls;
           
     controls.activity.getWindow().setFormat(PixelFormat.UNKNOWN);
     lparams = new RelativeLayout.LayoutParams(lparamW, lparamH);
         
     surfaceHolder = this.getHolder();
     surfaceHolder.addCallback(new Callback() {     	           
         
         @Override  
         public void surfaceCreated(SurfaceHolder holder) {           	        	
     		controls.pOnSurfaceViewCreated(pascalObj, holder);     		     		
     		//setWillNotDraw(true); //false = Allows us to use invalidate() to call onDraw()     		      		      		     		                        
         }          
         
         @Override           
         public void surfaceChanged(SurfaceHolder holder, int format, int width,  int height) {  
        	 controls.pOnSurfaceViewChanged(pascalObj,width,height);
         }
         
         @Override  
         public void surfaceDestroyed(SurfaceHolder holder) {
        	 mRun = false;        	              
         }                          
     });
     
     /*
     onClickListener = new OnClickListener(){
         public void onClick(View view){  //please, do not remove mask for parse invisibility!
                 if (enabled) {
                    controls.pOnClick(pascalObj, Const.Click_Default); //JNI event onClick!
                 }
              };
     };     
     setOnClickListener(onClickListener);     
     */
     
     paint = new Paint();
                   
  } //end constructor
    
   public void jFree() {
     if (parent != null) { parent.removeView(this); }
     //free local objects...
     lparams = null;
     //setOnClickListener(null);     
     surfaceHolder  = null;
     paint = null;
   }
 
   public void SetViewParent(ViewGroup _viewgroup) {
     if (parent != null) { parent.removeView(this); }
     parent = _viewgroup;
     parent.addView(this,lparams);
     mRemovedFromParent = false;
   }
  
   public void RemoveFromViewParent() {
     if (!mRemovedFromParent) {
        this.setVisibility(android.view.View.INVISIBLE);
        if (parent != null)
   	        parent.removeView(this);
	    mRemovedFromParent = true;
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
	 if (_idAnchor > 0) {
	    for (int i=0; i < countAnchorRule; i++) {
		lparams.addRule(lparamsAnchorRule[i], _idAnchor);
	    }
	 }
     for (int j=0; j < countParentRule; j++) {
        lparams.addRule(lparamsParentRule[j]);
     }
     this.setLayoutParams(lparams);
   }
 
   public void ClearLayoutAll() {
	 for (int i=0; i < countAnchorRule; i++) {
 	   lparams.removeRule(lparamsAnchorRule[i]);
     }
 
	 for (int j=0; j < countParentRule; j++) {
  	   lparams.removeRule(lparamsParentRule[j]);
	 }
	 countAnchorRule = 0;
	 countParentRule = 0;
   }

   public void SetId(int _id) { //wrapper method pattern ...
     this.setId(_id);
   }
 
   @Override
   protected void onDraw(Canvas canvas) {	
	 if (mDrawing)  controls.pOnSurfaceViewDraw(pascalObj, canvas);	   
   }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...  
         
   public void DrawLine(Canvas _canvas, float _x1, float _y1, float _x2, float _y2) {	       
	  _canvas.drawLine(_x1,_y1,_x2,_y2, paint );
   }

   public void DrawLine(Canvas _canvas, float[] _points) {	 
	   _canvas.drawLines(_points, paint);        	     
   }
      
	public  void DrawText(Canvas _canvas, String _text, float _x, float _y ) {
		_canvas.drawText(_text,_x,_y,paint);
	}

	public  void DrawBitmap(Canvas _canvas, Bitmap _bitmap, int _b, int _l, int _r, int _t) {
	    Rect rect = new Rect(_b,_l,_r,_t); //bello, left, right, top
	   _canvas.drawBitmap(_bitmap,null,rect,null/*paint*/);
    }
	
	public void DrawBitmap(Canvas _canvas, Bitmap _bitmap , float _left, float _top) {
	   _canvas.drawBitmap(_bitmap, _left, _top, null/*paint*/);
	}

   public void DrawPoint(Canvas _canvas, float _x1, float _y1) {	   
	   _canvas.drawPoint(_x1,_y1,paint);		   
   }
   
   public void DrawCircle(Canvas _canvas, float _cx, float _cy, float _radius) {	   
	   _canvas.drawCircle(_cx, _cy, _radius, paint);		   
   }
      
   public void DrawBackground(Canvas _canvas, int _color) {
        _canvas.drawColor(_color);
   }
      
  public void DrawRect(Canvas _canvas, float _left, float _top, float _right, float _bottom) { 
     _canvas.drawRect(_left, _top, _right, _bottom, paint);
  }
   
  public  void SetPaintStrokeWidth(float _width) {
	 paint.setStrokeWidth(_width);
  }

   public  void SetPaintStyle(int _style) {
		switch (_style) {
		  case 0  : { paint.setStyle(Paint.Style.FILL           ); break; }
		  case 1  : { paint.setStyle(Paint.Style.FILL_AND_STROKE); break; }
		  case 2  : { paint.setStyle(Paint.Style.STROKE);          break; }
		  default : { paint.setStyle(Paint.Style.FILL           ); break; }
		}
	}

	public  void SetPaintColor(int _color) {
		paint.setColor(_color);
	}

	public  void SetPaintTextSize(float _textsize) {
		paint.setTextSize(_textsize);
	}
	
	public void DispatchOnDraw(boolean _value) {
	   mDrawing = _value;	
	   setWillNotDraw(!_value); //false = Allows us to use invalidate() to call onDraw()
	}
		
	public void SaveToFile(String _path, String _filename) {	 
		
		    Bitmap image = Bitmap.createBitmap(this.getWidth(), this.getHeight(), Bitmap.Config.ARGB_8888);
		    Canvas c = new Canvas(image);
		    this.draw(c);		  
		    File file = new File (_path +"/"+ _filename);	    
		    if (file.exists ()) file.delete (); 
		    try {
		        FileOutputStream out = new FileOutputStream(file);	  
		        
		        if ( _filename.toLowerCase().contains(".jpg") ) image.compress(Bitmap.CompressFormat.JPEG, 90, out);
		        if ( _filename.toLowerCase().contains(".png") ) image.compress(Bitmap.CompressFormat.PNG, 100, out);
		        
		         out.flush();
		         out.close();
		         
		    } catch (Exception e) {
		         e.printStackTrace();
		    }  	     	   
	}	
	
	@Override
	public  boolean onTouchEvent( MotionEvent event) {
	int act     = event.getAction() & MotionEvent.ACTION_MASK;
	switch(act) {
	  case MotionEvent.ACTION_DOWN: {
	        switch (event.getPointerCount()) {
	        	case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,1,
	        		                            event.getX(0),event.getY(0),0,0); break; }
	        	default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,2,
	        		                            event.getX(0),event.getY(0),
	        		                            event.getX(1),event.getY(1));     break; }
	        }
	       break;}
	  case MotionEvent.ACTION_MOVE: {
	        switch (event.getPointerCount()) {
	        	case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchMove,1,
	        		                            event.getX(0),event.getY(0),0,0); break; }
	        	default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchMove,2,
	        		                            event.getX(0),event.getY(0),
	        		                            event.getX(1),event.getY(1));     break; }
	        }
	       break;}
	  case MotionEvent.ACTION_UP: {
	        switch (event.getPointerCount()) {
	        	case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,1,
	        		                            event.getX(0),event.getY(0),0,0); break; }
	        	default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,2,
	        		                            event.getX(0),event.getY(0),
	        		                            event.getX(1),event.getY(1));     break; }
	        }
	       break;}
	  case MotionEvent.ACTION_POINTER_DOWN: {
	        switch (event.getPointerCount()) {
	        	case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,1,
	        		                            event.getX(0),event.getY(0),0,0); break; }
	        	default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchDown,2,
	        		                            event.getX(0),event.getY(0),
	        		                            event.getX(1),event.getY(1));     break; }
	        }
	       break;}
	  case MotionEvent.ACTION_POINTER_UP  : {
	  	   // Log.i("Java","PUp");
	        switch (event.getPointerCount()) {
	        	case 1 : { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,1,
	        		                            event.getX(0),event.getY(0),0,0); break; }
	        	default: { controls.pOnSurfaceViewTouch (pascalObj,Const.TouchUp  ,2,
	        		                            event.getX(0),event.getY(0),
	        		                            event.getX(1),event.getY(1));     break; }
	        }
	       break;}
	} 
	return true;
	}

	public void SetHolderFixedSize(int _width, int _height) {	     		 
	   surfaceHolder.setFixedSize(_width, _height);
	}
	 				
	public Canvas GetLockedCanvas() {		  		  
		return surfaceHolder.lockCanvas();  
	}
    
	public void UnLockCanvas(Canvas _canvas) {
		if(_canvas != null) {   
	          surfaceHolder.unlockCanvasAndPost(_canvas);
		}
	}
	
    //invalidate(): This must be called from a UI thread. 
    //To call from a non-UI thread, call  postInvalidate(). 
      
	//http://blog-en.openalfa.com/how-to-draw-graphics-in-android
    //http://blog.danielnadeau.io/2012/01/android-canvas-beginners-tutorial.html	  
    //http://www.edu4java.com/en/androidgame/androidgame3.html
   
    public void DoDrawingInBackground(boolean _value) {    	       
	   if (!mRun) { 	      	      
	      new DrawTask().execute();   
	   }
       mRun = _value;
       mDrawing = _value;
	   setWillNotDraw(!_value); //false = Allows us to use invalidate() to call onDraw()
    }
               
   public void SetDrawingInBackgroundSleeptime(long _sleepTime) { //long mSleeptime = 20;
	   mSleeptime = 20;
	   if (_sleepTime > 20)  
	      mSleeptime = _sleepTime;   
   }
   
   public void PostInvalidate() {
      this.postInvalidate();
   }
   
   public void Invalidate() {
	  this.invalidate();
   }
   
   public void SetKeepScreenOn(boolean _value) { 
       surfaceHolder.setKeepScreenOn(_value);
   }
  
   //Set whether this view can receive the focus. 
   //Setting this to false will also ensure that this view is not focusable in touch mode.  
   public void SetFocusable(boolean _value) { 
       this.setFocusable(_value); // make sure we get key events
   }
      
   public void SetProgress(float _startValue, float _step) {
       mStartProgress = _startValue; 
       mStepProgress =  _step;
   }
   
   class DrawTask extends AsyncTask<String, Float, String> {
	   Canvas canvas;
	   float count;	   	   
       @Override
       protected String doInBackground(String... message) {               
    	  count = mStartProgress;    	  
          while (controls.pOnSurfaceViewDrawingInBackground(pascalObj, count)) {        	  
            canvas = null;  
            try {  
              canvas = surfaceHolder.lockCanvas(null);
              
              try {
                Thread.sleep(mSleeptime);
              } catch (InterruptedException iE) {
            	  //
              } 
                     	  			              
              synchronized (surfaceHolder) {            
            	  if (canvas != null) {            	    
                	 PostInvalidate(); 
            	  }	 
              }
              publishProgress(count);
           }
           finally {        	           	   
               if (canvas != null) {                	   
                   surfaceHolder.unlockCanvasAndPost(canvas);     
               }        	                      
           }
           
          }
          mDrawing = false;
          mRun = false;
          return null;
       }

       @Override
       protected void onProgressUpdate(Float... values) {    	   
           super.onProgressUpdate(values);           
           count = count + mStepProgress;           
       }
       
       @Override
       protected void onPostExecute(String values) {    	  
         super.onPostExecute(values);   	             
         controls.pOnSurfaceViewDrawingPostExecute(pascalObj, count);
       }            
   }
   
   public Bitmap GetDrawingCache() {
		this.setDrawingCacheEnabled(true);		
		Bitmap b = Bitmap.createBitmap(this.getDrawingCache());
		this.setDrawingCacheEnabled(false);	
	    return b; 
   }
   
} //end class


