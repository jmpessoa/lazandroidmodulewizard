package com.example.appdemo1;

import java.io.FileOutputStream;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

public class jView extends View {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	//
	private ViewGroup       parent   = null;   // parent view
	private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH
	private jCanvas         jcanvas  = null;   //

	//by jmpessoa
	private int lparamsAnchorRule[] = new int[30];
	int countAnchorRule = 0;

	private int lparamsParentRule[] = new int[30];
	int countParentRule = 0;

	int lparamH = RelativeLayout.LayoutParams.MATCH_PARENT;
	int lparamW = RelativeLayout.LayoutParams.MATCH_PARENT; //w

	int marginLeft = 5;
	int marginTop = 5;
	int marginRight = 5;
	int marginBottom = 5;
	private int lgravity = Gravity.TOP | Gravity.START;
	private float lweight = 0;

	//Constructor
	public  jView(android.content.Context context,
				  Controls ctrls,long pasobj ) {
		super(context);

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;

		lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B

		//this.setWillNotDraw(false);  //fire onDraw ... thanks to tintinux
	}

	public Bitmap getBitmap(){
		this.setDrawingCacheEnabled(true);  //thanks to tintinux
		Bitmap b = Bitmap.createBitmap(this.getDrawingCache());
		this.setDrawingCacheEnabled(false);
		return b;
	}

	public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		marginLeft = _left;
		marginTop = _top;
		marginRight = _right;
		marginBottom = _bottom;
		lparamH = _h;
		lparamW = _w;
	}

	private static MarginLayoutParams newLayoutParams(ViewGroup aparent, ViewGroup.MarginLayoutParams baseparams) {
		if (aparent instanceof FrameLayout) {
			return new FrameLayout.LayoutParams(baseparams);
		} else if (aparent instanceof RelativeLayout) {
			return new RelativeLayout.LayoutParams(baseparams);
		} else if (aparent instanceof LinearLayout) {
			return new LinearLayout.LayoutParams(baseparams);
		} else if (aparent == null) {
			throw new NullPointerException("Parent is null");
		} else {
			throw new IllegalArgumentException("Parent is neither FrameLayout or RelativeLayout or LinearLayout: "
					+ aparent.getClass().getName());
		}
	}

	//
	public  void setParent( android.view.ViewGroup _viewgroup ) {
		if (parent != null) { parent.removeView(this); }
		parent = _viewgroup;
		parent.addView(this,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));
		lparams = null;
		lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();
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
		controls.pOnDraw(PasObj,canvas); // improvement required
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
		if (parent != null) { parent.removeView(this);   }
		lparams = null;
	}

	//by jmpessoa
	public void setLParamWidth(int _w) {
		lparamW = _w;
	}

	public void setLParamHeight(int _h) {
		lparamH = _h;
	}

	public int getLParamHeight() {
		return getHeight();
	}

	public int getLParamWidth() {
		return getWidth();
	}

	public void setLGravity(int _g) {
		lgravity = _g;
	}

	public void setLWeight(float _w) {
		lweight = _w;
	}

	public void addLParamsAnchorRule(int rule) {
		lparamsAnchorRule[countAnchorRule] = rule;
		countAnchorRule = countAnchorRule + 1;
	}

	public void addLParamsParentRule(int rule) {
		lparamsParentRule[countParentRule] = rule;
		countParentRule = countParentRule + 1;
	}

	//by jmpessoa
	public void setLayoutAll(int _idAnchor) {
		lparams.width  = lparamW;
		lparams.height = lparamH;
		lparams.setMargins(marginLeft, marginTop,marginRight,marginBottom);

		if (lparams instanceof RelativeLayout.LayoutParams) {
			if (_idAnchor > 0) {
				for (int i = 0; i < countAnchorRule; i++) {
					((RelativeLayout.LayoutParams)lparams).addRule(lparamsAnchorRule[i], _idAnchor);
				}
			}
			for (int j = 0; j < countParentRule; j++) {
				((RelativeLayout.LayoutParams)lparams).addRule(lparamsParentRule[j]);
			}
		}
		if (lparams instanceof FrameLayout.LayoutParams) {
			((FrameLayout.LayoutParams)lparams).gravity = lgravity;
		}
		if (lparams instanceof LinearLayout.LayoutParams) {
			((LinearLayout.LayoutParams)lparams).weight = lweight;
		}
		//
		setLayoutParams(lparams);
	}

	public void clearLayoutAll() {
		if (lparams instanceof RelativeLayout.LayoutParams) {
			for (int i=0; i < countAnchorRule; i++) {
				((RelativeLayout.LayoutParams)lparams).removeRule(lparamsAnchorRule[i]);
			}
			for (int j=0; j < countParentRule; j++) {
				((RelativeLayout.LayoutParams)lparams).removeRule(lparamsParentRule[j]);
			}
		}
		countAnchorRule = 0;
		countParentRule = 0;
	}
}
