package com.example.appdemo1;

import java.lang.reflect.Field;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;

//-------------------------------------------------------------------------
//jImageBtn
//-------------------------------------------------------------------------

public class jImageBtn extends View {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	//
	private ViewGroup       parent   = null;   // parent view
	private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH
	//
	private Paint           mPaint   = null;
	private Bitmap          bmpUp    = null;
	private Bitmap          bmpDn    = null;
	private Rect            rect;
	private int             btnState = 0;      // Normal/Up = 0 , Pressed = 1
	private Boolean         enabled  = true;   //

	//by jmpessoa
	private int lparamsAnchorRule[] = new int[30];
	int countAnchorRule = 0;

	private int lparamsParentRule[] = new int[30];
	int countParentRule = 0;

	int lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
	int lparamW = android.view.ViewGroup.LayoutParams.WRAP_CONTENT; //w
	int marginLeft = 0;
	int marginTop = 0;
	int marginRight = 0;
	int marginBottom = 0;
	private int lgravity = Gravity.TOP | Gravity.START;
	private float lweight = 0;


	//Constructor
	public  jImageBtn(android.content.Context context,
					  Controls ctrls,long pasobj ) {
		super(context);

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;

		//Init Class
		lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
		lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B
		//BackGroundColor
		//setBackgroundColor(0xFF0000FF);
		//
		mPaint = new Paint();
		rect   = new Rect(0,0,200,200);
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

	public  void setParent( android.view.ViewGroup _viewgroup ) {
		if (parent != null) { parent.removeView(this); }
		parent = _viewgroup;

		parent.addView(this,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));
		lparams = null;
		lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();
	}

	public  void setButton( String fileup , String filedn ) {
		if (bmpUp  != null) { bmpUp.recycle();         }
		bmpUp = BitmapFactory.decodeFile(fileup);
		rect   = new Rect(0,0,bmpUp.getWidth(),bmpUp.getHeight());

		if (bmpDn  != null) { bmpDn.recycle();         }
		bmpDn = BitmapFactory.decodeFile(filedn);
		rect   = new Rect(0,0,bmpDn.getWidth(),bmpDn.getHeight());
		invalidate();
	}

	public  void setButtonUp( String fileup) {
		if (bmpUp  != null) { bmpUp.recycle(); }
		bmpUp = BitmapFactory.decodeFile(fileup);
		rect   = new Rect(0,0,bmpUp.getWidth(),bmpUp.getHeight());
		invalidate();
	}

	public  void setButtonDown( String filedn ) {
		if (bmpDn  != null) { bmpDn.recycle();         }
		bmpDn = BitmapFactory.decodeFile(filedn);
		rect   = new Rect(0,0,bmpDn.getWidth(),bmpDn.getHeight());
		invalidate();
	}


	//by jmpessoa
	private int GetDrawableResourceId(String _resName) {
		try {
			Class<?> res = R.drawable.class;
			Field field = res.getField(_resName);  //"drawableName"
			int drawableId = field.getInt(null);
			return drawableId;
		}
		catch (Exception e) {
			Log.e("jImageBtn", "Failure to get drawable id.", e);
			return 0;
		}
	}

	//by jmpessoa
	private Drawable GetDrawableResourceById(int _resID) {
		return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));
	}

	public  void setButtonUpByRes(String resup) {   // ..res/drawable
		if (bmpUp  != null) { bmpUp.recycle(); }
		Drawable d = GetDrawableResourceById(GetDrawableResourceId(resup));
		bmpUp = ((BitmapDrawable)d).getBitmap();
		rect   = new Rect(0,0,bmpUp.getWidth(),bmpUp.getHeight());
		invalidate();
	}

	public  void setButtonDownByRes(String resdn) {   // ..res/drawable
		if (bmpDn  != null) { bmpDn.recycle(); }
		Drawable d = GetDrawableResourceById(GetDrawableResourceId(resdn));
		bmpDn = ((BitmapDrawable)d).getBitmap();
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
				//Log.i("Java","jImageBtn Here");
				break;
			}
			case MotionEvent.ACTION_MOVE: { break; }
			case MotionEvent.ACTION_UP  : {  btnState = 0;
				invalidate();
				controls.pOnClick(PasObj,Const.Click_Default);
				break;
			}
		}

		return true;

	}

	//
	@Override
	public  void onDraw( Canvas canvas) {
//
		if (btnState == 0) {
			if (bmpUp != null) {
				//Log.i("onDraw","UP");
				canvas.drawBitmap(bmpUp,null,rect,null); //mPaint
			}
		}
		else  {
			if (bmpDn != null) {
				//Log.i("onDraw","Dow");
				canvas.drawBitmap(bmpDn,null,rect,null); //mPaint
			}
		}

	}



	public  void setEnabled(boolean value) {
		enabled = value;
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		if (parent != null) { parent.removeView(this); }
		if (bmpUp  != null) { bmpUp.recycle();         }
		if (bmpDn  != null) { bmpDn.recycle();         }
		bmpUp   = null;
		bmpDn   = null;
		lparams = null;
		mPaint  = null;
		rect    = null;
	}

	//by jmpessoa
	public void setLParamWidth(int _w) {
		lparamW = _w;
	}

	public void setLParamHeight(int _h) {
		lparamH = _h;
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
	public void setLayoutAll(int idAnchor) {
		lparams.width  = lparamW; //wrapContent;
		lparams.height = lparamH; //wrapContent;
		lparams.setMargins(marginLeft, marginTop,marginRight,marginBottom);

		if (lparams instanceof RelativeLayout.LayoutParams) {
			if (idAnchor > 0) {
				for (int i = 0; i < countAnchorRule; i++) {
					((RelativeLayout.LayoutParams)lparams).addRule(lparamsAnchorRule[i], idAnchor);
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
		rect.right     = lparamW;
		rect.bottom    = lparamH;
		setLayoutParams(lparams);
	}

	public void ClearLayoutAll() {
		if (lparams instanceof RelativeLayout.LayoutParams) {
			for (int i = 0; i < countAnchorRule; i++) {
				((RelativeLayout.LayoutParams)lparams).removeRule(lparamsAnchorRule[i]);
			}

			for (int j = 0; j < countParentRule; j++) {
				((RelativeLayout.LayoutParams)lparams).removeRule(lparamsParentRule[j]);
			}
		}
		countAnchorRule = 0;
		countParentRule = 0;
	}

}

