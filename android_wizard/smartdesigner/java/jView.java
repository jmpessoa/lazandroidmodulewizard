package org.lamw.applamwprojecttt1;

import java.io.FileOutputStream;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

public class jView extends View {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	private jCommons LAMWCommon;
	
	private jCanvas         jcanvas  = null;   //

	//Constructor
	public  jView(android.content.Context context,
				  Controls ctrls,long pasobj ) {
		super(context);

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);
		
		//this.setWillNotDraw(false);  //fire onDraw ... thanks to tintinux
	}

	/* deprecated
	public Bitmap getBitmap(){
		this.setDrawingCacheEnabled(true);  //thanks to tintinux
		Bitmap b = Bitmap.createBitmap(this.getDrawingCache());
		this.setDrawingCacheEnabled(false);
		return b;
	}
	*/

	//updated by Tomash
	public Bitmap GetBitmap(){
		try {
 	    	Bitmap bitmap = Bitmap.createBitmap(this.getWidth(), this.getHeight(), Bitmap.Config.ARGB_8888);
  	    	Canvas canvas = new Canvas(bitmap);
   			Drawable background = this.getBackground();
    		if (background != null) {
				background.draw(canvas);
			}
			this.draw(canvas);
			return bitmap;
		}
		catch (Exception e) 
		{
			//Log.e("jView_getBitmap", "Exception: "+ e.toString() );
			return null;
		}			
    }	

	public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
	}

	public void SetViewParent( android.view.ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}

	//
	public void SetjCanvas(java.lang.Object _canvas) {
		jcanvas = (jCanvas)_canvas;
	}
	
	public void SetLayerType(int _value) {
		setLayerType(_value/*View.LAYER_TYPE_SOFTWARE*/, null);
	}	
	
	//
	@Override
	public  boolean onTouchEvent( MotionEvent event) {
		int act     = event.getAction() & MotionEvent.ACTION_MASK;
		switch(act) {
			case MotionEvent.ACTION_DOWN: {
				switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				}
				break;}	
			case MotionEvent.ACTION_MOVE: {
				switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchMove,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchMove,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				}
				break;}
			case MotionEvent.ACTION_UP: {
				switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				}
				break;}
			case MotionEvent.ACTION_POINTER_DOWN: {
				switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchDown,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchDown,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				}
				break;}
			case MotionEvent.ACTION_POINTER_UP  : {
				switch (event.getPointerCount()) {
					case 1 : { controls.pOnTouch (PasObj,Const.TouchUp  ,1,
							event.getX(0),event.getY(0),0,0); break; }
					default: { controls.pOnTouch (PasObj,Const.TouchUp  ,2,
							event.getX(0),event.getY(0),
							event.getX(1),event.getY(1));     break; }
				}
				break;}
		}
		return true;
	}

	//
	@Override
	public  void onDraw( Canvas canvas) {
		if (jcanvas != null) {
			jcanvas.setCanvas(canvas);
			controls.pOnDraw(PasObj); // improvement required
		}
	}

	public void saveView( String sFileName ) {
		Bitmap b = Bitmap.createBitmap( getWidth(), getHeight(), Bitmap.Config.ARGB_8888);
		Canvas c = new Canvas( b );
		draw(c);
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream( sFileName );
			if (fos != null) {
				b.compress(Bitmap.CompressFormat.PNG, 100, fos );
				fos.close();
			}
		}
		catch ( Exception e) {
			Log.e("jView_SaveView", "Exception: "+ e.toString() );
		}
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		LAMWCommon.free();
	}
	
	public void BringToFront() {
		this.bringToFront();
		
		LAMWCommon.BringToFront();
	}

	public void SetLParamWidth(int _w) {
		LAMWCommon.setLParamWidth(_w);
	}

	public void SetLParamHeight(int _h) {
		LAMWCommon.setLParamHeight(_h);
	}

	public int GetLParamHeight() {
		//return getHeight();
		return  LAMWCommon.getLParamHeight();
	}

	public int GetLParamWidth() {
		//return getWidth();
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

	public void SetLayoutAll(int _idAnchor) {
		LAMWCommon.setLayoutAll(_idAnchor);
	}

	public void ClearLayoutAll() {
		LAMWCommon.clearLayoutAll();
	}
}
