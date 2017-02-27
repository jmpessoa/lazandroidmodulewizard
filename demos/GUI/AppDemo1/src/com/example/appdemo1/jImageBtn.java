package com.example.appdemo1;

import java.lang.reflect.Field;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

//-------------------------------------------------------------------------
//jImageBtn
//-------------------------------------------------------------------------

public class jImageBtn extends View {
	private Controls        controls = null;   // Control Class for Event
	private jCommons LAMWCommon;
	
	private Paint           mPaint   = null;
	private Bitmap          bmpUp    = null;
	private Bitmap          bmpDn    = null;
	private Rect            rect;
	private int             btnState = 0;      // Normal/Up = 0 , Pressed = 1
	private Boolean         enabled  = true;   //

	//Constructor
	public jImageBtn(android.content.Context context,
					  Controls ctrls,long pasobj ) {
		super(context);
		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);
		mPaint = new Paint();
		rect   = new Rect(0,0,200,200);
	}

	public void setButton(String fileup, String filedn) {
		setButtonUp(fileup);
		setButtonDown(filedn);
	}

	public void setButtonUp( String fileup) {
		// /data/data/com.example.appimagebtndemo1/files/btn_red.jpg
	    BitmapFactory.Options bo = new BitmapFactory.Options();
	    bo.inScaled = false; 		
		bmpUp = BitmapFactory.decodeFile(fileup,bo);
		rect = new Rect(0,0,bmpUp.getWidth(),bmpUp.getHeight());
		LAMWCommon.setLParamWidth(bmpUp.getWidth());
		LAMWCommon.setLParamHeight(bmpUp.getHeight());								
		invalidate();		
	}

	public void setButtonDown( String filedn ) {  
		// /data/data/com.example.appimagebtndemo1/files/btn_blue.jpg
	    BitmapFactory.Options bo = new BitmapFactory.Options();
	    bo.inScaled = false; 		
		bmpDn = BitmapFactory.decodeFile(filedn, bo);
		rect   = new Rect(0,0,bmpDn.getWidth(),bmpDn.getHeight());
		invalidate();		
	}

    private int GetDrawableResourceId(String _resName) {
		  try {
		     Class<?> res = R.drawable.class;
		     Field field = res.getField(_resName);  //"drawableName"
		     int drawableId = field.getInt(null);
		     return drawableId;
		  }
		  catch (Exception e) {
		     Log.e("GetDrawableResourceId", "Failure to get drawable id.", e);
		     return 0;
		  }
     }
    
    public Bitmap GetBitmapResource(String _resourceDrawableIdentifier, boolean _inScaled) {
       int id =	GetDrawableResourceId(_resourceDrawableIdentifier);	
       BitmapFactory.Options bo = new BitmapFactory.Options();
       bo.inScaled = _inScaled; //false; 
       return  BitmapFactory.decodeResource(this.controls.activity.getResources(), id, bo);
    }    

	public  void setButtonUpByRes(String resup) {   // ..res/drawable
		bmpUp = GetBitmapResource(resup, false); 
		rect   = new Rect(0,0,bmpUp.getWidth(),bmpUp.getHeight());
		LAMWCommon.setLParamWidth(bmpUp.getWidth());
		LAMWCommon.setLParamHeight(bmpUp.getHeight());										
		invalidate();
	}

	public  void setButtonDownByRes(String resdn) {   // ..res/drawable
		bmpDn = bmpUp = GetBitmapResource(resdn, false);
		rect   = new Rect(0,0,bmpDn.getWidth(),bmpDn.getHeight());		
		invalidate();
	}

	//
	@Override
	public  boolean onTouchEvent( MotionEvent event) {
      //LORDMAN 2013-08-16
		if (enabled == false) { return false; }
		int actType = event.getAction()&MotionEvent.ACTION_MASK;
		switch(actType) {
			case MotionEvent.ACTION_DOWN: {  btnState = 1;
				invalidate();
				break;
			}
			case MotionEvent.ACTION_MOVE: { break; }
			case MotionEvent.ACTION_UP  : {  btnState = 0;
				invalidate();
				controls.pOnClick(LAMWCommon.getPasObj(),Const.Click_Default);
				break;
			}
		}
		return true;
	}

	@Override
	public  void onDraw( Canvas canvas) {
		if (btnState == 0) {
			if (bmpUp != null) {
				LAMWCommon.setLParamWidth(bmpUp.getWidth());
				LAMWCommon.setLParamHeight(bmpUp.getHeight());				
				canvas.drawBitmap(bmpUp,null,rect,null);				
			}
		}
		else  {
			if (bmpDn != null) {
				LAMWCommon.setLParamWidth(bmpDn.getWidth());
				LAMWCommon.setLParamHeight(bmpDn.getHeight());
				canvas.drawBitmap(bmpDn,null,rect,null); 
			}
		}
	}

	public  void setEnabled(boolean value) {
		enabled = value;
	}

	public  void Free() {
		if (bmpUp  != null) { bmpUp.recycle();         }
		if (bmpDn  != null) { bmpDn.recycle();         }
		LAMWCommon.free();
		bmpUp   = null;
		bmpDn   = null;
		mPaint  = null;
		rect    = null;
	}

	public long GetPasObj() {
		return LAMWCommon.getPasObj();
	}

	public  void setParent(ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}
	
	public ViewGroup GetParent() {
		return LAMWCommon.getParent();
	}
	
	public void RemoveFromViewParent() {
		LAMWCommon.removeFromViewParent();
	}

	public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);
	}
		
	public void setLParamWidth(int w) {
		LAMWCommon.setLParamWidth(w);
	}

	public void setLParamHeight(int h) {
		LAMWCommon.setLParamHeight(h);
	}
    
	public int GetLParamHeight() {
		return  LAMWCommon.getLParamHeight();
	}

	public int GetLParamWidth() {				
		return LAMWCommon.getLParamWidth();					
	}  

	public void setLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
	}

	public void setLWeight(float _w) {
		LAMWCommon.setLWeight(_w);
	}

	public void addLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);
	}
	
	public void addLParamsParentRule(int rule) {
		LAMWCommon.addLParamsParentRule(rule);
	}

	public void setLayoutAll(int idAnchor) {
		LAMWCommon.setLayoutAll(idAnchor);
	}
	
	public void ClearLayoutAll() {		
		LAMWCommon.clearLayoutAll();
	}
}

