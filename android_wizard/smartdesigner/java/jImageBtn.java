package org.lamw.appjcentermikrotikrouterosdemo1;

import java.lang.reflect.Field;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PaintDrawable;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.os.Handler;
import android.os.Build;
import android.util.Log;
import android.util.DisplayMetrics;
import android.view.MotionEvent;
import android.widget.ImageView;
import android.view.View;
import android.view.ViewGroup;

//-------------------------------------------------------------------------
//jImageBtn
//Reviewed by ADiV on 2020/10/04
//-------------------------------------------------------------------------

public class jImageBtn extends ImageView {
	private Controls        controls = null;   // Control Class for Event
	private jCommons LAMWCommon;
	private long           PasObj   = 0;      // Pascal Obj
	
	private Bitmap          bmpUp    = null;
	private Bitmap          bmpDn    = null;
	
	private int             btnState = 0;      // Normal/Up = 0 , Pressed = 1
	private Boolean         enabled  = true;   //
	private int             mSleep   = 150;
	
	private ImageView       mImage = null;

	//Constructor
	public jImageBtn(android.content.Context context, Controls ctrls,long pasobj ) {
		
		super(context);

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);
		
		setScaleType(ImageView.ScaleType.CENTER);
		
		mImage = this;
	}
	
	public  boolean onTouchEvent( MotionEvent event) {
	        //by TR3E
			if (enabled == false) return false;
			
			int actType = event.getAction()&MotionEvent.ACTION_MASK;
			
			switch(actType) {
			    case MotionEvent.ACTION_UP: {				
				 controls.pOnUp(PasObj);
				 break;
			    }
				case MotionEvent.ACTION_DOWN: {  
					
					if( btnState == 1 ) return false;
										
					btnState = 1;
					
					controls.pOnDown(PasObj);
					
				    this.setImageBitmap(bmpDn);
				    
					//invalidate();
					final Handler handler = new Handler();
					handler.postDelayed(new Runnable() {
						@Override
						public void run() {
							// Do something after: 1s = 1000ms
							if(btnState != 0) {
							 btnState = 0;
							 mImage.setImageBitmap(bmpUp);
							 controls.pOnClick(LAMWCommon.getPasObj(), Const.Click_Default);
							}
						}
					}, mSleep);  //1s = 1000ms

					break;
				}				
			}
			
			return true;
	}

	public void setButton(String fileup, String filedn) {
		setButtonUp(fileup);
		setButtonDown(filedn);
	}

	public void setButtonUp( String fileup) {
		
		this.setImageResource(android.R.color.transparent);
		
		if (fileup.equals("null")) { this.setImageBitmap(null); bmpUp = null; bmpDn = null; return; }
		
		BitmapFactory.Options bo = new BitmapFactory.Options();		
		
	    if( bo == null ) { this.setImageBitmap(null); bmpUp = null; bmpDn = null; return; }
	    
	    if( controls.GetDensityAssets() > 0 )
	     bo.inDensity = controls.GetDensityAssets();
			
		bmpUp = BitmapFactory.decodeFile(fileup, bo);
		 
		this.setImageResource(android.R.color.transparent);
				
		this.setImageBitmap(bmpUp);		  			   
	}

	public void setButtonDown( String filedn ) {  
		
		if (filedn.equals("null")) return;
		
        BitmapFactory.Options bo = new BitmapFactory.Options();		
		
	    if( bo == null ) return;
	    	
	    if( controls.GetDensityAssets() > 0 )
	  	     bo.inDensity = controls.GetDensityAssets();
			
	    bmpDn = BitmapFactory.decodeFile(filedn, bo);		 
	    		
	}

	public  void setButtonUpByRes(String resup) {   // ..res/drawable
			
        Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(resup));
		
		if( d == null ) { this.setImageBitmap(null); bmpUp = null; bmpDn = null; return; }
		
		Bitmap b = ((BitmapDrawable)d).getBitmap();
		
		if( b == null ) { this.setImageBitmap(null); bmpUp = null; bmpDn = null; return; }
		
		bmpUp = Bitmap.createScaledBitmap(b, b.getWidth(), b.getHeight(), true);
				
		this.setImageResource(android.R.color.transparent);
		
		this.setImageBitmap(bmpUp);
		
		this.invalidate();
	}

	public  void setButtonDownByRes(String resdn) {   // ..res/drawable
		
        Drawable d = controls.GetDrawableResourceById(controls.GetDrawableResourceId(resdn));
		
		if( d == null ) return;
		
		Bitmap b = ((BitmapDrawable)d).getBitmap();
		
		if( b == null ) return;
		
		bmpDn = Bitmap.createScaledBitmap(b, b.getWidth(), b.getHeight(), true);
		
	}
	
	public void SetImageDownScale( float _scale ) {
		
		if(bmpUp == null) return;
		
		int newWidth = (int)(bmpUp.getWidth()*_scale);
		int newHeight = (int)(bmpUp.getHeight()*_scale);
		
		Bitmap bmpScale = Bitmap.createScaledBitmap( bmpUp, newWidth, newHeight, true );
		
		bmpScale.setDensity( bmpUp.getDensity() );
		
		if( bmpScale == null ) return;
		
		int posLeft = (bmpUp.getWidth() - bmpScale.getWidth()) / 2;
		int posTop  = (bmpUp.getHeight() - bmpScale.getHeight()) / 2;				
					
		bmpDn = Bitmap.createBitmap(bmpUp.getWidth(), bmpUp.getHeight(), Bitmap.Config.ARGB_8888);
							
		if( bmpDn != null ){
			
			bmpDn.setDensity( bmpUp.getDensity() );
						
			Canvas canvas = new Canvas(bmpDn);
			canvas.drawBitmap(bmpScale, posLeft, posTop, null);
		}
		
	}
	
	public void SetImageState(int _state) {
		if (_state == 0 ) {
			if (bmpUp != null) {
				this.setImageBitmap(bmpUp);
			}
		}
		else  { //_state ==
		  if (bmpDn != null) {
			  this.setImageBitmap(bmpDn);
		  }
		}
	}
    
    public void SetAlpha( int value ){
    	
        if( bmpUp == null ) return;
		
		if( value < 0 ) value = 0;
		if( value > 255) value = 255;
		
		//[ifdef_api16up]
		if(Build.VERSION.SDK_INT >= 16) setImageAlpha(value);
		//[endif_api16up]
    }
    
    public void SetSaturation( float value ){
     ColorMatrix matrix = new ColorMatrix();
     
     matrix.setSaturation(value); 
     
     setColorFilter(new ColorMatrixColorFilter(matrix));
    }
    
    public void SetColorScale(float _red, float _green, float _blue, float _alpha){
    	
    	ColorMatrix matrix = new ColorMatrix();
        
        matrix.setScale(_red, _green, _blue, _alpha); 
        
        setColorFilter(new ColorMatrixColorFilter(matrix));
    }

	public void SetSleepDown(int _sleepMiliSeconds) {
        mSleep = _sleepMiliSeconds;
	}

	public  void setEnabled(boolean value) {
		enabled = value;
	}
	
	public void BringToFront() {
		 this.bringToFront();

		 LAMWCommon.BringToFront();		
	}

	public  void Free() {
		if (bmpUp  != null) bmpUp.recycle();     
		if (bmpDn  != null) bmpDn.recycle();
		
		bmpUp = null;
		bmpDn = null;
		
		setImageBitmap(null);
		setImageResource(0); //android.R.color.transparent;
		setOnClickListener(null);
		
		LAMWCommon.free();
	}

	public long GetPasObj() {
		return LAMWCommon.getPasObj();
	}

	public  void SetViewParent(ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}
	
	public ViewGroup GetParent() {
		return LAMWCommon.getParent();
	}
	
	public void RemoveFromViewParent() {
		LAMWCommon.removeFromViewParent();
	}

	public void SetLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);
	}
		
	public void SetLParamWidth(int w) {
		LAMWCommon.setLParamWidth(w);
	}

	public void SetLParamHeight(int h) {
		LAMWCommon.setLParamHeight(h);
	}
    
	public int GetLParamHeight() {
		return  LAMWCommon.getLParamHeight();
	}

	public int GetLParamWidth() {				
		return LAMWCommon.getLParamWidth();					
	}  

	public void SetLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
	}

	public void SetLWeight(float _w) {
		LAMWCommon.setLWeight(_w);
	}

	public void AddLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);
	}
	
	public void AddLParamsParentRule(int rule) {
		LAMWCommon.addLParamsParentRule(rule);
	}

	public void SetLayoutAll(int idAnchor) {
		LAMWCommon.setLayoutAll(idAnchor);
	}
	
	public void ClearLayoutAll() {		
		LAMWCommon.clearLayoutAll();
	}
}

