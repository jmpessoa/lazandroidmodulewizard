package org.lamw.appscrollingimages;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.TextView;

import java.io.IOException;
import java.io.InputStream;
import java.util.Random;

//-------------------------------------------------------------------------
//ScrollView
//    Event pOnClick
//-------------------------------------------------------------------------

public class jScrollView extends ScrollView {
    //Java-Pascal Interface
    private long PasObj = 0;      // Pascal Obj
    private Controls controls = null;   // Control Class for Event
    private jCommons LAMWCommon;
    //
    private ViewGroup scrollview;        // Scroll View
    private LayoutParams scrollxywh;        // Scroll Area

    int onPosition;
    boolean mDispacthScrollChanged = true;
    private int activeInnerLayout;
    private int magicNumber = 99001;

    //Constructor
    public jScrollView(Controls ctrls, long pasobj, int innerLayout) {
        super(ctrls.activity);

        //Connect Pascal I/F
        PasObj = pasobj;
        controls = ctrls;
        LAMWCommon = new jCommons(this, ctrls.activity, pasobj);

        if (innerLayout == 0) {
            scrollview = new RelativeLayout(ctrls.activity);
            activeInnerLayout = 0;
        }
        else {
            scrollview = new LinearLayout(ctrls.activity);
            ((LinearLayout) scrollview).setOrientation(LinearLayout.VERTICAL);
            activeInnerLayout = 0;
        }
        //scrollview.setBackgroundColor (0xFFFF0000);
        scrollxywh = new FrameLayout.LayoutParams(100, 100);
        scrollxywh.setMargins(0, 0, 0, 0);
        scrollview.setLayoutParams(scrollxywh);
        this.addView(scrollview);

    }
    
    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
    	super.onSizeChanged(w, h, oldw, oldh);
    	
    	// Change the size and update the layout               
     controls.formNeedLayout = true;
     controls.appLayout.requestLayout();
    }

    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
        LAMWCommon.setLeftTopRightBottomWidthHeight(_left, _top, _right, _bottom, _w, _h);
    }

    public void SetViewParent(android.view.ViewGroup _viewgroup) {
        LAMWCommon.setParent(_viewgroup);
    }
    
    public void BringToFront() {
		this.bringToFront();
		
		LAMWCommon.BringToFront();
    }

    public void setScrollSize(int _size) {
        scrollxywh.height = _size;
        scrollxywh.width = LAMWCommon.getLParamWidth(); //lparams.width;
        scrollview.setLayoutParams(scrollxywh);
    }

    public ViewGroup getView() {
        return (scrollview);
    }

    public void setEnabled(boolean enabled) {
        //setEnabled(enabled);
        scrollview.setEnabled(enabled);
        scrollview.setFocusable(enabled);
    }

    //Free object except Self, Pascal Code Free the class.
    public void Free() {
        scrollxywh = null;
        this.removeView(scrollview);
        scrollview = null;
        LAMWCommon.free();
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent event) {
        if (!isEnabled()) {
            return (false);
        } else return super.onInterceptTouchEvent(event);
    }

    public void SetLParamWidth(int _w) {
        LAMWCommon.setLParamWidth(_w);
    }

    public void SetLParamHeight(int _h) {
        LAMWCommon.setLParamHeight(_h);
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
        scrollxywh.width = LAMWCommon.getLParamWidth(); //lparamW;
        scrollview.setLayoutParams(scrollxywh);
    }

    public void ClearLayoutAll() {
        LAMWCommon.clearLayoutAll();
    }

    //thanks to DonAlfredo
    public void setFillViewport(boolean _fillenabled) {
        //seee: https://developer.android.com/reference/android/widget/ScrollView.html#setFillViewport(boolean)
        super.setFillViewport(_fillenabled);
    }

    /*
	 * l int: Current horizontal scroll origin. 
       t int: Current vertical scroll origin. 
       oldl int: Previous horizontal scroll origin. 
       oldt int: Previous vertical scroll origin.  

	 */
    //http://stackoverflow.com/questions/4263053/android-scrollview-onscrollchanged
    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
        //Log.i("TAG", "scroll changed: " + this.getTop() + " "+t);
        onPosition = 0; //unknow/intermediry
        int diff = 0;
        if (t <= 0) {
            onPosition = 1;  //top
            //Log.i("TAG", "scroll top/begin: " + t);
            //reaches the top end  - begin
        } else {
            View view = (View) getChildAt(getChildCount() - 1);
            diff = (view.getBottom() - (getHeight() + getScrollY() + view.getTop()));// Calculate the scrolldiff
            if (diff <= 0) {
                // if diff is zero, then the bottom has been reached
                //Log.i("TAG", "scroll bottom/end: " + diff);
                onPosition = 2;  //bottom end
            } else {
                //Log.i("TAG", "scroll intermediry: " + diff);
                onPosition = 0;
            }
        }
        super.onScrollChanged(l, t, oldl, oldt);

        if (mDispacthScrollChanged)
            controls.pOnScrollViewChanged(PasObj, l, t, oldl, oldt, onPosition, diff);
    }

    public void ScrollTo(int _x, int _y) {   //pixels 	
        this.scrollTo(_x, _y);
    }

    public void SmoothScrollTo(int _x, int _y) {
        this.smoothScrollTo(_x, _y);
    }

    public void SmoothScrollBy(int _x, int _y) {
        this.smoothScrollBy(_x, _y);
    }

    public int GetScrollX() {
        return this.getScrollX();
    }

    public int GetScrollY() {
        return this.getScrollY();
    }

    public int GetBottom() {
        return this.getBottom();
    }

    public int GetTop() {
        return this.getTop();
    }

    public int GetLeft() {
        return this.getLeft();
    }

    public int GetRight() {
        return this.getRight();
    }

    public int GetLParamHeight() {
        return LAMWCommon.getLParamHeight();
    }

    public int GetLParamWidth() {
        return LAMWCommon.getLParamWidth();
    }

    public void DispatchOnScrollChangedEvent(boolean _value) {
        mDispacthScrollChanged = _value;
    }

    public void AddView(View _view) {

        if (_view.getParent() != null) {
            ViewGroup parent = (ViewGroup) _view.getParent();
            parent.removeView(_view);
        }
        scrollview.addView(_view);
    }

    private Bitmap LoadFromAssets(String strName)
    {
        Bitmap bmp;
        AssetManager assetManager = controls.activity.getAssets();
        InputStream stream = null;
        try {
            stream = assetManager.open(strName);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }

        if( controls.GetDensityAssets() > 0 ) {
            BitmapFactory.Options bo = new BitmapFactory.Options();
            if (bo != null) {
                bo.inDensity = controls.GetDensityAssets();
                bmp = BitmapFactory.decodeStream(stream, null, bo);
            }
            else
                bmp = BitmapFactory.decodeStream(stream);
        }
        else
            bmp = BitmapFactory.decodeStream(stream);

        return bmp;
    }

    private Bitmap LoadFromFile(String _path, String _filename) { //EnvironmentDirectoryPath  !!

        Bitmap bmp = null;

        if( controls.GetDensityAssets() > 0 ) {
            BitmapFactory.Options bo = new BitmapFactory.Options();
            if (bo != null) {
                bo.inDensity = controls.GetDensityAssets();
                bmp = BitmapFactory.decodeFile(_path + "/" + _filename, bo);
            }
            else
                bmp = BitmapFactory.decodeFile(_path + "/" + _filename);
        }
        else
            bmp = BitmapFactory.decodeFile(_path + "/" + _filename);

        return bmp;
    }


    private int getRandomNumberInRange(int min, int max) {
        if (min >= max) {
            throw new IllegalArgumentException("max must be greater than min");
        }
        Random r = new Random();
        return r.nextInt((max - min) + 1) + min;
    }

    private ImageView.ScaleType GetScaleType(int _scaleType) { //TODO!

        ImageView.ScaleType r = ImageView.ScaleType.FIT_XY;

        switch(_scaleType) {
            case 0: r = ImageView.ScaleType.CENTER; break;
            case 1: r = ImageView.ScaleType.CENTER_CROP; break;
            case 2: r = ImageView.ScaleType.CENTER_INSIDE; break;
            case 3: r = ImageView.ScaleType.FIT_CENTER; break;
            case 4: r = ImageView.ScaleType.FIT_END; break;
            case 5: r = ImageView.ScaleType.FIT_START; break;
            case 6: r = ImageView.ScaleType.FIT_XY; break;
            case 7: r = ImageView.ScaleType.MATRIX; break;
        }
        return r;
    }

    public void AddImage(Bitmap _bitmap, int _itemId) {
        AddImage( _bitmap, _itemId, 1);
    }

    public void AddImage(Bitmap _bitmap) {
        AddImage( _bitmap, 0, 1);
    }

    public void AddImage(Bitmap _bitmap, int _itemId, int _scaleType) {
        final int imgId;
        if (_itemId == 0)
            imgId = magicNumber + scrollview.getChildCount(); //getRandomNumberInRange(1, 10000);
        else
            imgId = magicNumber + _itemId;
        ImageView imageView = new ImageView(controls.activity);
        imageView.setId(imgId);
        imageView.setPadding(10, 2, 2, 2);
        imageView.setImageBitmap(_bitmap);
        imageView.setScaleType(GetScaleType(_scaleType));
        imageView.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                controls.pOnScrollViewInnerItemClick(PasObj,  ((ImageView)v).getId() -  magicNumber);
            }
        });

        imageView.setOnLongClickListener(new OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                int id = ((ImageView)v).getId();
                int index = GetInnerItemIndexByInternalId(id); //private
                controls.pOnScrollViewInnerItemLongClick(PasObj, index, id - magicNumber);
                return true;
            }
        });

		/*
		LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(
				LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT);
		layoutParams.setMargins(10, 0, 0, 0);
		layoutParams.gravity = Gravity.CENTER;
        */

        scrollview.addView(imageView);
    }

    public void AddImageFromFile(String _path, String _filename, int _itemId) {
        AddImageFromFile(_path, _filename, _itemId, 1);
    }

    public void AddImageFromFile(String _path, String _filename) {
        AddImageFromFile(_path, _filename, 0, 1);
    }

    public void AddImageFromFile(String _path, String _filename, int _itemId, int _scaleType) {
        final int imgId;
        if (_itemId == 0)
            imgId = magicNumber + scrollview.getChildCount(); //getRandomNumberInRange(1, 10000);
        else
            imgId = magicNumber + _itemId;
        ImageView imageView = new ImageView(controls.activity);
        imageView.setId(imgId);
        imageView.setPadding(10, 2, 2, 2);
        //imageView.setImageBitmap(BitmapFactory.decodeResource(getResources(), R.drawable.ic_launcher));
        Bitmap bitmap = LoadFromFile(_path, _filename);

        imageView.setImageBitmap(bitmap);
        imageView.setScaleType(GetScaleType(_scaleType)); //ImageView.ScaleType.FIT_XY

        imageView.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                controls.pOnScrollViewInnerItemClick(PasObj, ((ImageView)v).getId() - magicNumber);
            }
        });

        imageView.setOnLongClickListener(new OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                int id = ((ImageView)v).getId();
                int index = GetInnerItemIndexByInternalId(id); //private
                controls.pOnScrollViewInnerItemLongClick(PasObj, index, id - magicNumber);
                return true;
            }
        });

        scrollview.addView(imageView);
    }

    public void AddImageFromAssets(String _filename, int _itemId) {
        AddImageFromAssets( _filename, _itemId, 1);
    }

    public void AddImageFromAssets(String _filename) {
        AddImageFromAssets( _filename, 0, 1);
    }

    public void AddImageFromAssets(String _filename, int _itemId, int _scaleType) {
        final int imgId;
        if (_itemId == 0)
            imgId = magicNumber + scrollview.getChildCount(); //getRandomNumberInRange(1, 10000);
        else
            imgId = magicNumber + _itemId;
        ImageView imageView = new ImageView(controls.activity);
        imageView.setId(imgId);
        imageView.setPadding(10, 2, 2, 2);
        //imageView.setImageBitmap(BitmapFactory.decodeResource(getResources(), R.drawable.ic_launcher));
        Bitmap bitmap = LoadFromAssets(_filename);
        imageView.setImageBitmap(bitmap);
        imageView.setScaleType(GetScaleType(_scaleType));
        imageView.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                controls.pOnScrollViewInnerItemClick(PasObj, ((ImageView)v).getId() -  magicNumber);
            }
        });

        imageView.setOnLongClickListener(new OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                int id = ((ImageView)v).getId();
                int index = GetInnerItemIndexByInternalId(id); //private
                controls.pOnScrollViewInnerItemLongClick(PasObj, index, id - magicNumber);
                return true;
            }
        });

        scrollview.addView(imageView);
    }

    public void AddText(String _text) {
        TextView textView = new TextView(controls.activity);
        textView.setId(getRandomNumberInRange(1, 10000));
        textView.setPadding(30, 2, 2, 2);
        scrollview.addView(textView);
    }

    public int GetActiveInnerLayout() { //TODO Pascal
        return activeInnerLayout;
    }

    public void Delete(int _index) {
        if (scrollview.getChildCount() == 0) return;
        if (_index < 0) return;
        if (_index >= scrollview.getChildCount() ) return;

        scrollview.removeViewAt(_index);
        scrollview.invalidate();
    }

    public void Clear() {
        scrollview.removeAllViews();
        scrollview.invalidate();
    }

    public int Count() {
        return scrollview.getChildCount();
    }

    public int GetInnerItemId(int _index) {

        int i = _index;

        if (_index < 0) i = 0;
        if ( _index > ( scrollview.getChildCount() -1) )
            i = scrollview.getChildCount() -1;

        View v = scrollview.getChildAt(i);
        if (v != null)
            return v.getId() - magicNumber;
        else
            return -1;
    }

    private int GetInnerItemIndexByInternalId(int _internalId) {
        int i;
        int index = -1;
        int id;
        View v;
        int count = scrollview.getChildCount();
        i = 0;
        boolean found = false;
        while(  (i < count) && (!found) ) {
            v = scrollview.getChildAt(i);
            id = v.getId();
            if (id == _internalId) {
                index = i;
                found = true;
            }
            i++;
        }
        return index;
    }

    public int GetInnerItemIndex(int _itemId) {
        int i;
        int index = -1;
        int id;
        View v;
        int count = scrollview.getChildCount();
        i = 0;
        boolean found = false;
        while(  (i < count) && (!found) ) {
            v = scrollview.getChildAt(i);
            id = v.getId() - magicNumber;
            if (id == _itemId) {
                index = i;
                found = true;
            }
            i++;
        }
        return index;
    }

}
