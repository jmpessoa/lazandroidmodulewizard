package org.lamw.appdrawinginbitmap;

import javax.microedition.khronos.opengles.GL10;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.util.DisplayMetrics;
import android.util.TypedValue;

public class jCanvas {
	//Java-Pascal Interface
	private long             PasObj   = 0;      // Pascal Obj
	private Controls        controls = null;   // Control Class for Event
	//
	private Canvas          mCanvas = null;
	private Paint           paint  = null;
	private TextPaint mTextPaint = null;
	private Paint.Style mStyle;

	float scale = 1; // p.setTextSize(48*scale);
	Bitmap innerBitmap = null;

	//Constructor
	public  jCanvas(Controls ctrls,long pasobj ) {
		//Connect Pascal I/F
		PasObj   = pasobj;
		controls = ctrls;
		//Init Class
		paint = new Paint();
        paint.setFlags(Paint.ANTI_ALIAS_FLAG);
		mTextPaint = new TextPaint();//new Paint();
		mTextPaint.setFlags(Paint.ANTI_ALIAS_FLAG);
		float ts = mTextPaint.getTextSize();  //default 12
		scale = controls.activity.getResources().getDisplayMetrics().density; //0.75/1.0/1.5/2.0）
		mTextPaint.setTextSize(ts*scale); //ts * unit
		mStyle = mTextPaint.getStyle();
	}

	public  void setCanvas(Canvas _canvas) {
		mCanvas = _canvas;
	}

	public  void setStrokeWidth(float width) {
		paint.setStrokeWidth(width);
	}

	public void setStyle(int _style) {
		switch (_style) {
			case 0: {
				paint.setStyle(mStyle);
				break;
			}
			case 1: {
				paint.setStyle(Paint.Style.FILL);
				break;
			}
			case 2: {
				paint.setStyle(Paint.Style.FILL_AND_STROKE);
				break;
			}
			case 3: {
				paint.setStyle(Paint.Style.STROKE);
				break;
			}
		}
	}

	public  void setColor(int color) {
		paint.setColor(color);
	}

	public void drawBackground(int _color) {
		mCanvas.drawColor(_color);
	}

	public void setTextSize(float textsize) {
		paint.setTextSize(scale*textsize);
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
		mCanvas.drawText(text,x,y,mTextPaint);
	}

	public void drawPoint(float _x1, float _y1) {
		mCanvas.drawPoint(_x1,_y1,paint);
	}

	public void drawCircle(float _cx, float _cy, float _radius) {
		mCanvas.drawCircle(_cx, _cy, _radius, paint);
	}

	public void drawOval(float _left, float _top, float _right, float _bottom) {
		mCanvas.drawOval(new RectF(_left, _top, _right, _bottom), paint);
	}

	public  void drawLine(float x1, float y1, float x2, float y2) {
		mCanvas.drawLine(x1,y1,x2,y2,paint);
	}

	public void drawRect(float _left, float _top, float _right, float _bottom) {
		mCanvas.drawRect(_left, _top, _right, _bottom, paint);
	}

	public void drawRoundRect(float _left, float _top, float _right, float _bottom, float _rx, float _ry) {
		mCanvas.drawRoundRect(new RectF(_left, _top, _right, _bottom), _rx, _ry, paint);
	}

	private Bitmap GetResizedBitmap(Bitmap _bmp, int _newWidth, int _newHeight){
		if( _bmp == null ) return null;
		
		float factorH = _newHeight / (float)_bmp.getHeight();
		float factorW = _newWidth / (float)_bmp.getWidth();
		float factorToUse = (factorH > factorW) ? factorW : factorH;
		
		Bitmap bm = Bitmap.createScaledBitmap(_bmp,
				(int) (_bmp.getWidth() * factorToUse),
				(int) (_bmp.getHeight() * factorToUse),false);
		
		return bm;
	}

	public void drawBitmap(Bitmap _bitmap, int _width, int _height) {
		if( (_bitmap == null) || (_width <= 0) || (_height <= 0) ) return; // Fix by tr3e
		Bitmap b = GetResizedBitmap(_bitmap, _width, _height);
		Rect rect = new Rect(0, 0, _width, _height);
		mCanvas.drawBitmap(b,null,rect,null); //
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
		if( bitmap == null ) return;

		Rect rect = new Rect(left,top, right, bottom);
		if ( (bitmap.getHeight() > GL10.GL_MAX_TEXTURE_SIZE) || (bitmap.getWidth() > GL10.GL_MAX_TEXTURE_SIZE)) {
			int nh = (int) ( bitmap.getHeight() * (512.0 / bitmap.getWidth()) );
			Bitmap scaled = Bitmap.createScaledBitmap(bitmap,512, nh, true);
			mCanvas.drawBitmap(scaled,null,rect,paint);
		}
		else {
			mCanvas.drawBitmap(bitmap,null,rect,paint);
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
		mCanvas.drawText(text,x,y,mTextPaint);//paint
    }

	public Path GetNewPath(float[] _points) { // path.reset();
		int len = _points.length;
		Path path = new Path();
		path.moveTo(_points[0], _points[1]);
		int i = 2;
		while ((i + 1) < len) {
			path.lineTo(_points[i], _points[i + 1]); //2,3  4,5
			i = i + 2;
		}
		return path;
	}
	public void DrawPath(float[] _points) {
		//mPaint.setStyle(Paint.Style.STROKE);  //<----- important!  //seted in pascal side
		mCanvas.drawPath(GetNewPath(_points), paint);
	}

	public void DrawPath(Path _path) {
		//mPaint.setStyle(Paint.Style.STROKE);  //<----- important!  //seted in pascal side
		mCanvas.drawPath(_path, paint);
	}
    
    //https://thoughtbot.com/blog/android-canvas-drawarc-method-a-visual-guide
    public void DrawArc(float _leftRectF, float _topRectF, float _rightRectF, float _bottomRectF, float _startAngle, float _sweepAngle, boolean _useCenter) {
        RectF oval = new RectF(_leftRectF, _topRectF, _rightRectF, _bottomRectF);
		mCanvas.drawArc(oval, _startAngle, _sweepAngle, _useCenter, paint);
    }

	private int dipToPixels(int dipValue) {
		DisplayMetrics metrics = controls.activity.getResources().getDisplayMetrics();
		return (int)TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dipValue, metrics);
	}

    public Bitmap CreateBitmap(int _width, int _height, int _backgroundColor) {
		innerBitmap = Bitmap.createBitmap(_width,_height, Bitmap.Config.ARGB_8888); //Returns a mutable bitmap
		mCanvas = new Canvas(innerBitmap);
		Paint paintBg = new Paint();
		paintBg.setColor(_backgroundColor); //Color.GRAY
		mCanvas.drawRect(0, 0, innerBitmap.getWidth(), innerBitmap.getHeight(), paintBg);

		return innerBitmap;
	}

	public void SetBitmap(Bitmap _bitmap) {
		Bitmap mutableBitmap = _bitmap.copy(Bitmap.Config.ARGB_8888, true);
		innerBitmap = mutableBitmap;
		if (mCanvas == null)
			mCanvas = new Canvas(innerBitmap);
		else
			mCanvas.setBitmap(innerBitmap);
	}

	public void SetBitmap(Bitmap _bitmap, int _width, int _height) {
		Bitmap mutableBitmap = _bitmap.copy(Bitmap.Config.ARGB_8888, true);
		innerBitmap = GetResizedBitmap(mutableBitmap, _width, _height);
		if (mCanvas == null)
			mCanvas = new Canvas(innerBitmap);
		else
			mCanvas.setBitmap(innerBitmap);
	}

	public Bitmap GetBitmap() {
		return innerBitmap;
	}

	public void DrawBitmap(float _left, float _top, Bitmap _bitmap) {
		if( _bitmap == null ) return;
		mCanvas.drawBitmap(_bitmap, _left, _top, null);
	}

	public void SetDensityScale(boolean _scale) {
		if (_scale) scale = controls.activity.getResources().getDisplayMetrics().density;
		else scale = 1;
	}

	private float getTextHeight(String text, Paint paint /*textPaint*/) {
		Rect rect = new Rect();
		paint.getTextBounds(text, 0, text.length(), rect);
		return rect.height();
	}

	public void DrawText(String _text, float _x, float _y, float _angleDegree, boolean _rotateCenter) {
		Rect rect = new Rect();
		mTextPaint.getTextBounds(_text, 0, _text.length(), rect);
		mCanvas.save();
		//rotate the canvas on center of the text to draw
		if (_rotateCenter) {
			mCanvas.rotate(_angleDegree, _x + rect.exactCenterX(), _y + rect.exactCenterY());
		}
		else {
			mCanvas.rotate(_angleDegree, _x, _y);
		}
		mCanvas.drawText(_text, _x, _y, mTextPaint);
		mCanvas.restore();
	}

	public void DrawText(String _text, float _x, float _y, float _angleDegree) {
		DrawText(_text, _x, _y, _angleDegree, false);
	}

	public void DrawRect(float _P0x, float _P0y,
						 float _P1x, float _P1y,
						 float _P2x, float _P2y,
						 float _P3x, float _P3y) {
		drawLine(_P0x, _P0y, _P1x, _P1y); //top horiz
		drawLine(_P1x, _P1y, _P3x, _P3y); //rigth vert
		drawLine(_P3x, _P3y, _P2x, _P2y); //bottom horiz
		drawLine(_P2x, _P2y, _P0x, _P0y); //left vert
	}

	public void DrawRect(float[] _box) {

		if (_box.length != 8) return;

		drawLine(_box[0], _box[1], _box[2], _box[3]); //PO - P1
		drawLine(_box[2], _box[3], _box[6], _box[7]); //P1 - P3
		drawLine(_box[6], _box[7], _box[4], _box[5]); //P3 - P2
		drawLine(_box[4], _box[5], _box[0], _box[1]); //P2 - P0
	}

	public void DrawTextMultiLine(String _text, float _left, float _top, float _right, float _bottom) {
		Rect bounds = new Rect((int) _left, (int) _top, (int) _right, (int) _bottom);
		//Static layout which will be drawn on canvas
		//bounds.width - width of the layout
		//Layout.Alignment.ALIGN_CENTER - layout alignment
		//1 - text spacing multiply
		//1 - text spacing add
		//true - include padding
		StaticLayout sl = new StaticLayout(_text, mTextPaint, bounds.width(), Layout.Alignment.ALIGN_CENTER, 1, 1, true);
		mCanvas.save();
		//calculate X and Y coordinates - In this case we want to draw the text in the
		//center of canvas so we calculate
		//text height and number of lines to move Y coordinate to center.
		float textHeight = getTextHeight(_text, mTextPaint);
		int numberOfTextLines = sl.getLineCount();
		float textYCoordinate = bounds.exactCenterY() - ((numberOfTextLines * textHeight) / 2);
		//text will be drawn from left
		float textXCoordinate = bounds.left;
		mCanvas.translate(textXCoordinate, textYCoordinate);
		//draws static layout on canvas
		sl.draw(mCanvas);
		mCanvas.restore();
	}

	public void Clear(int _color) {
		if (_color != 0)
			mCanvas.drawColor(_color);
		else
			mCanvas.drawColor(Color.WHITE);
	}

	public Canvas GetInstance() {
		return mCanvas;
	}

	// by Kordal
	public void DrawBitmap(Bitmap _bitMap, int _srcLeft, int _srcTop, int _srcRight, int _srcBottom, int _dstLeft, int _dstTop, int _dstRight, int _dstBottom) {
		Rect srcRect = new Rect(_srcLeft, _srcTop, _srcRight, _srcBottom);
		Rect dstRect = new Rect(_dstLeft, _dstTop, _dstRight, _dstBottom);

		mCanvas.drawBitmap(_bitMap, srcRect, dstRect, paint);
	}

    // by Kordal
    public void DrawFrame(Bitmap _bitMap, int _srcX, int _srcY, int _srcW, int _srcH, int _X, int _Y, int _Wh, int _Ht, float _rotateDegree) {
		Rect srcRect = new Rect(_srcX, _srcY, _srcX + _srcW, _srcY + _srcH);
		Rect dstRect = new Rect(_X, _Y, _X + _Wh, _Y + _Ht);

		if (_rotateDegree != 0) {
			mCanvas.save();
			mCanvas.rotate(_rotateDegree, _X + _Wh / 2, _Y + _Ht / 2);
			mCanvas.drawBitmap(_bitMap, srcRect, dstRect, paint);
			mCanvas.restore();
		} else {
			mCanvas.drawBitmap(_bitMap, srcRect, dstRect, paint);
		}
	}

	// by Kordal
	public void DrawFrame(Bitmap _bitMap, int _X, int _Y, int _Index, int _Size, float _scaleFactor, float _rotateDegree) {
		int sf = (int) (_Size * _scaleFactor);
		DrawFrame(_bitMap, _Index % (_bitMap.getWidth() / _Size) * _Size, _Index / (_bitMap.getWidth() / _Size) * _Size, _Size, _Size, _X, _Y, sf, sf, _rotateDegree);
	}

}

