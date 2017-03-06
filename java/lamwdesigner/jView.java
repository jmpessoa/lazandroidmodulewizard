package com.example.appdemo1;

import java.io.FileOutputStream;

import android.graphics.Bitmap;
import android.graphics.Canvas;
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

	public Bitmap getBitmap(){
		this.setDrawingCacheEnabled(true);  //thanks to tintinux
		Bitmap b = Bitmap.createBitmap(this.getDrawingCache());
		this.setDrawingCacheEnabled(false);
		return b;
	}

	public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
	}

	public  void setParent( android.view.ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}

	//
	public  void setjCanvas(java.lang.Object canvas) {
		jcanvas = (jCanvas)canvas;
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
		jcanvas.setCanvas(canvas);
		controls.pOnDraw(PasObj); // improvement required
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

	public void setLParamWidth(int _w) {
		LAMWCommon.setLParamWidth(_w);
	}

	public void setLParamHeight(int _h) {
		LAMWCommon.setLParamHeight(_h);
	}

	public int getLParamHeight() {
		//return getHeight();
		return  LAMWCommon.getLParamHeight();
	}

	public int getLParamWidth() {
		//return getWidth();
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

	public void setLayoutAll(int _idAnchor) {
		LAMWCommon.setLayoutAll(_idAnchor);
	}

	public void clearLayoutAll() {
		LAMWCommon.clearLayoutAll();
	}
}
