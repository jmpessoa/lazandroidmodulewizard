package com.example.appdemo1;

import javax.microedition.khronos.opengles.GL10;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;

public class jCanvas {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	//
	private Canvas          canvas = null;
	private Paint           paint  = null;

	//Constructor
	public  jCanvas(Controls ctrls,long pasobj ) {

		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;

		//Init Class
		paint   = new Paint();

    paint.setFlags(Paint.ANTI_ALIAS_FLAG);
	}

	public  void setCanvas(Canvas _canvas) {
		canvas = _canvas;
	}

	public  void setStrokeWidth(float width) {
		paint.setStrokeWidth(width);
	}

	public  void setStyle(int style) {
		switch (style) {
			case 0  : { paint.setStyle(Paint.Style.FILL           ); break; }
			case 1  : { paint.setStyle(Paint.Style.FILL_AND_STROKE); break; }
			case 2  : { paint.setStyle(Paint.Style.STROKE);          break; }
			default : { paint.setStyle(Paint.Style.FILL           ); break; }
		};
	}

	public  void setColor(int color) {
		paint.setColor(color);
	}

	public void drawBackground(int _color) {
		canvas.drawColor(_color);
	}

	public  void setTextSize(float textsize) {
		paint.setTextSize(textsize);
	}

	public  void setTypeface(int _typeface) {
		Typeface t = null;
		switch (_typeface) {
			case 0: t = Typeface.DEFAULT; break;
			case 1: t = Typeface.SANS_SERIF; break;
			case 2: t = Typeface.SERIF; break;
			case 3: t = Typeface.MONOSPACE; break;
		}
		paint.setTypeface(t);
	}

	public  void drawText(String text, float x, float y ) {
		canvas.drawText(text,x,y,paint);
	}

	public void drawPoint(float _x1, float _y1) {
		canvas.drawPoint(_x1,_y1,paint);
	}

	public void drawCircle(float _cx, float _cy, float _radius) {
		canvas.drawCircle(_cx, _cy, _radius, paint);
	}

	public void drawOval(float _left, float _top, float _right, float _bottom) {
		canvas.drawOval(new RectF(_left, _top, _right, _bottom), paint);
	}

	public  void drawLine(float x1, float y1, float x2, float y2) {
		canvas.drawLine(x1,y1,x2,y2,paint);
	}

	public void drawRect(float _left, float _top, float _right, float _bottom) {
		canvas.drawRect(_left, _top, _right, _bottom, paint);
	}

	public void drawRoundRect(float _left, float _top, float _right, float _bottom, float _rx, float _ry) {
		canvas.drawRoundRect(new RectF(_left, _top, _right, _bottom), _rx, _ry, paint);
	}

	private Bitmap GetResizedBitmap(Bitmap _bmp, int _newWidth, int _newHeight){
		float factorH = _newHeight / (float)_bmp.getHeight();
		float factorW = _newWidth / (float)_bmp.getWidth();
		float factorToUse = (factorH > factorW) ? factorW : factorH;
		Bitmap bm = Bitmap.createScaledBitmap(_bmp,
				(int) (_bmp.getWidth() * factorToUse),
				(int) (_bmp.getHeight() * factorToUse),false);
		return bm;
	}

	public void drawBitmap(Bitmap _bitmap, int _width, int _height) {
		Bitmap bmp = GetResizedBitmap(_bitmap, _width, _height);
		Rect rect = new Rect(0, 0, _width, _height);
		canvas.drawBitmap(bmp,null,rect,paint);
	}

	//0 , 0, w, h //int left/b, int top/l, int right/r, int bottom/t)
	public  void drawBitmap(Bitmap bitmap, int left, int top, int right, int bottom) {  //int b, int l, int r, int t
		/* Figure out which way needs to be reduced less */
		/*
			int scaleFactor = 1;
			if ((right > 0) && (bottom > 0)) {
    		scaleFactor = Math.min(bitmap.getWidth()/(right-left), bitmap.getHeight()/(bottom-top));
}	
		*/
		Rect rect = new Rect(left,top, right, bottom);
		if ( (bitmap.getHeight() > GL10.GL_MAX_TEXTURE_SIZE) || (bitmap.getWidth() > GL10.GL_MAX_TEXTURE_SIZE)) {
			int nh = (int) ( bitmap.getHeight() * (512.0 / bitmap.getWidth()) );
			Bitmap scaled = Bitmap.createScaledBitmap(bitmap,512, nh, true);
			canvas.drawBitmap(scaled,null,rect,paint);
		}
		else {
			canvas.drawBitmap(bitmap,null,rect,paint);
		}

	}
	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		paint = null;
	}
	
	//by CC
	public  void drawTextAligned(String text, float _left, float _top, float _right, float _bottom, float _alignhorizontal , float _alignvertical ) {
        Rect bounds = new Rect();
        paint.getTextBounds(text, 0, text.length(), bounds);
        float x = _left + (_right - _left  - bounds.width()) * _alignhorizontal;
        float y = _top + (_bottom - _top  - bounds.height()) * _alignvertical + bounds.height();
        canvas.drawText(text,x,y,paint);                 
    }

}

