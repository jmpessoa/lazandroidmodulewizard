package org.lamw.appcompatcontinuousscrollableimageviewdemo1;
import android.content.Context;
import android.app.Activity;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import java.lang.reflect.Field;

import android.animation.ValueAnimator;
import android.content.res.TypedArray;
import android.util.Log;
import android.view.animation.LinearInterpolator;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.FrameLayout;

/*Draft java code by "Lazarus Android Module Wizard" [5/2/2019 1:33:16]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/

//https://github.com/Cutta/ContinuousScrollableImageView

//------------------------------------
//  Updated by ADiV 2020/10/29
//------------------------------------

class ContinuousScrollableImageView extends LinearLayout {

    public static final int UP = 0;
    public static final int RIGHT = 1;
    public static final int DOWN = 2;
    public static final int LEFT = 3;
    
    public static final int HORIZONTAL = 0;
    public static final int VERTICAL = 1;
    
    public static final int MATRIX = 0;
    public static final int FIT_XY = 1;
    public static final int FIT_START = 2;
    public static final int FIT_CENTER = 3;
    public static final int FIT_END = 4;
    public static final int CENTER = 5;
    public static final int CENTER_CROP = 6;
    public static final int CENTER_INSIDE = 7;

    int DEFAULT_DIRECTION = LEFT;
    int DEFAULT_ASYMPTOTE = HORIZONTAL;    
    int DEFAULT_SCALE_TYPE = FIT_CENTER;
    
    private final int DEFAULT_RESOURCE_ID = -1;
    private final int DEFAULT_DURATION = 3000;
    private int DIRECTION_MULTIPLIER = -1;

    private int duration;
    private int resourceId;
    private int direction;
    private int scaleType;

    private ValueAnimator animator;
    private ImageView firstImage;
    private ImageView secondImage;

    private boolean isBuilt = false;


    public static final String TAG = ContinuousScrollableImageView.class.getSimpleName();

    public ContinuousScrollableImageView(Context context) {
        super(context);
        
        resourceId = DEFAULT_RESOURCE_ID;
        direction  = DEFAULT_DIRECTION;
        duration = DEFAULT_DURATION;
        scaleType = DEFAULT_SCALE_TYPE;
        
        init(context);
    }

    private void setDirectionFlags(int _direction) {
        switch (_direction) {

            case UP:
                DIRECTION_MULTIPLIER = 1;
                DEFAULT_ASYMPTOTE = VERTICAL;
                break;
            case RIGHT:
                DIRECTION_MULTIPLIER = -1;
                DEFAULT_ASYMPTOTE = HORIZONTAL;
                break;
            case DOWN:
                DIRECTION_MULTIPLIER = -1;
                DEFAULT_ASYMPTOTE = VERTICAL;
                break;
            case LEFT:
                DIRECTION_MULTIPLIER = 1;
                DEFAULT_ASYMPTOTE = HORIZONTAL;
                break;
        }

    }

    /**
     * @param context
     */
    private void init(Context context) {
        
    	this.setOrientation(LinearLayout.VERTICAL);
    	    	
    	FrameLayout frame = new FrameLayout(context);
    	frame.setLayoutParams(new LayoutParams( LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
        
        this.addView(frame);
    	
    	firstImage  = new ImageView(context);
    	firstImage.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
    	frame.addView(firstImage);
    	
        secondImage = new ImageView(context);                
        secondImage.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));                        
        frame.addView(secondImage);                
    	
        build();
    }


    /**
     * Set duration in ms
     *
     * @param duration
     */

    public void setDuration(int _duration) {
        this.duration = _duration;
        isBuilt = false;
        build();
    }


    /**
     * set scrolling direction
     *
     * @param direction
     */

    public void setDirection(int _direction) {
        this.direction = _direction;
        isBuilt = false;
        setDirectionFlags(direction);
        build();
    }

    /**
     * @param resourceId
     */

    public void setResourceId(int _resourceId) {
        this.resourceId = _resourceId;
        
        if (firstImage == null || secondImage == null) return;
        
        firstImage.setImageResource(this.resourceId);
        secondImage.setImageResource(this.resourceId);
    }


    /**
     * set image scale type
     *
     * @param scaleType
     */

    public void setScaleType(int _scaleType) {
        if (firstImage == null || secondImage == null) return;
        
        ImageView.ScaleType type = ImageView.ScaleType.CENTER;
        switch (scaleType) {

            case MATRIX:
                type = ImageView.ScaleType.MATRIX;
                break;

            case FIT_XY:
                type = ImageView.ScaleType.FIT_XY;
                break;

            case FIT_START:
                type = ImageView.ScaleType.FIT_START;
                break;

            case FIT_CENTER:
                type = ImageView.ScaleType.FIT_CENTER;
                break;

            case FIT_END:
                type = ImageView.ScaleType.FIT_END;
                break;

            case CENTER:
                type = ImageView.ScaleType.CENTER;
                break;

            case CENTER_CROP:
                type = ImageView.ScaleType.CENTER_CROP;
                break;

            case CENTER_INSIDE:
                type = ImageView.ScaleType.CENTER_INSIDE;
                break;

        }
        this.scaleType = _scaleType;
        firstImage.setScaleType(type);
        secondImage.setScaleType(type);
    }

    private void build() {
        if (isBuilt) return;
        if (firstImage == null || secondImage == null) return;

        isBuilt = true;
        setImages();

        if (animator != null)
            animator.removeAllUpdateListeners();

        animator = ValueAnimator.ofFloat(0.0f, DIRECTION_MULTIPLIER * (-1.0f));
        animator.setRepeatCount(ValueAnimator.INFINITE);
        animator.setInterpolator(new LinearInterpolator());
        animator.setDuration(duration);

        switch (DEFAULT_ASYMPTOTE) {
            case HORIZONTAL:
                animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                    @Override
                    public void onAnimationUpdate(ValueAnimator animation) {
                        {
                        	float progress = DIRECTION_MULTIPLIER * (-(float) animation.getAnimatedValue());
                            float width = DIRECTION_MULTIPLIER * (-firstImage.getWidth());
                            float translationX = width * progress;
                            firstImage.setTranslationX(translationX);
                            secondImage.setTranslationX(translationX - width);
                        }
                    }
                });
                break;

            case VERTICAL:

                animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                    @Override
                    public void onAnimationUpdate(ValueAnimator animation) {
                        {
                        	float progress = DIRECTION_MULTIPLIER * (-(float) animation.getAnimatedValue());                                                        
                            float height = DIRECTION_MULTIPLIER * (-firstImage.getHeight());
                            float translationY = height * progress;
                            firstImage.setTranslationY(translationY);
                            secondImage.setTranslationY(translationY - height);
                        }
                    }
                });

                break;
        }

        animator.start();


    }

    private void setImages() {
        if (resourceId == -1) return;
                
        firstImage.setImageResource(resourceId);
        secondImage.setImageResource(resourceId);
        setScaleType(scaleType);
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (animator != null)
            animator.cancel();
    }


    public static final class Builder {

        private ContinuousScrollableImageView scrollableImageView;

        public Builder(Activity activity) {
            scrollableImageView = new ContinuousScrollableImageView(activity);
        }

        public Builder setDuration(int duration) {
            scrollableImageView.setDuration(duration);
            return this;
        }

        public Builder setResourceId(int resourceId) {
            scrollableImageView.setResourceId(resourceId);
            return this;
        }

        public Builder setDirection(int direction) {
            scrollableImageView.setDirection(direction);
            return this;
        }

        public Builder setScaleType(int scaleType) {
            scrollableImageView.setScaleType(scaleType);
            return this;
        }

        public ContinuousScrollableImageView build() {

            return scrollableImageView;
        }
    }
}

public class jsContinuousScrollableImageView extends ContinuousScrollableImageView /*dummy*/ { //please, fix what GUI object will be extended!
 
    private long pascalObj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;
 
    private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!

    String mImageIdentifier;
    int mDirection;
    int mDuration;
    int mScaleType;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jsContinuousScrollableImageView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
 
       super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
 
       LAMWCommon = new jCommons(this,context,pascalObj);
 
       onClickListener = new OnClickListener(){
       /*.*/public void onClick(View view){     // *.* is a mask to future parse...;
               if (enabled) {
                  controls.pOnClickGeneric(pascalObj); //JNI event onClick!
               }
            };
       };

       setOnClickListener(onClickListener);

    } //end constructor
 
    public void jFree() {
       //free local objects...
   	 setOnClickListener(null);
	 LAMWCommon.free();
    }
  
    public void SetViewParent(ViewGroup _viewgroup) {
	 LAMWCommon.setParent(_viewgroup);
    }
 
    public ViewGroup GetParent() {
       return LAMWCommon.getParent();
    }
 
    public void RemoveFromViewParent() {
   	 LAMWCommon.removeFromViewParent();
    }
 
    public View GetView() {
       return this;
    }
 
    public void SetLParamWidth(int _w) {
   	 LAMWCommon.setLParamWidth(_w);
    }
 
    public void SetLParamHeight(int _h) {
   	 LAMWCommon.setLParamHeight(_h);
    }
 
    public int GetLParamWidth() {
       return LAMWCommon.getLParamWidth();
    }
 
    public int GetLParamHeight() {
	 return  LAMWCommon.getLParamHeight();
    }
 
    public void SetLGravity(int _g) {
   	 LAMWCommon.setLGravity(_g);
    }
 
    public void SetLWeight(float _w) {
   	 LAMWCommon.setLWeight(_w);
    }
 
    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
       LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
    }
 
    public void AddLParamsAnchorRule(int _rule) {
	 LAMWCommon.addLParamsAnchorRule(_rule);
    }
 
    public void AddLParamsParentRule(int _rule) {
	 LAMWCommon.addLParamsParentRule(_rule);
    }
 
    public void SetLayoutAll(int _idAnchor) {
   	 LAMWCommon.setLayoutAll(_idAnchor);
    }
 
    public void ClearLayoutAll() {
	 LAMWCommon.clearLayoutAll();
    }
 
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public int GetDrawableResourceId(String _resName) {
        try {
            Class<?> res = R.drawable.class;
            Field field = res.getField(_resName);  //"drawableName"
            int drawableId = field.getInt(null);
            return drawableId;
        }
        catch (Exception e) {
            //Log.e("jImageView", "Failure to get drawable id.", e);
            return 0;
        }
    }

    public void SetImageIdentifier(String _imageIdentifier) {
        mImageIdentifier = _imageIdentifier;
        int id = GetDrawableResourceId(mImageIdentifier);
        this.setResourceId(id); //R.drawable.bg_sample
    }

    public void SetDirection(int _direction) {
        mDirection = _direction;
        this.setDirection(_direction); //ContinuousScrollableImageView.UP
    }

    public void SetDuration(int _duration) {
        mDuration = _duration;
        this.setDuration(_duration);
    }

    public void SetScaleType(int _scaleType) {
        switch(_scaleType) {
            case 0: this.setScaleType(ContinuousScrollableImageView.CENTER); break;
            case 1: this.setScaleType(ContinuousScrollableImageView.CENTER_CROP); break;
            case 2: this.setScaleType(ContinuousScrollableImageView.CENTER_INSIDE); break;
            case 3: this.setScaleType(ContinuousScrollableImageView.FIT_CENTER); break;
            case 4: this.setScaleType(ContinuousScrollableImageView.FIT_END); break;
            case 5: this.setScaleType(ContinuousScrollableImageView.FIT_START); break;
            case 6: this.setScaleType(ContinuousScrollableImageView.FIT_XY); break;
            case 7: this.setScaleType(ContinuousScrollableImageView.MATRIX); break;
        }
    }

}
