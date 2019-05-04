package org.lamw.appcompatcontinuousscrollableimageviewdemo1;
import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import com.cunoraz.continuouscrollable.ContinuousScrollableImageView;
import java.lang.reflect.Field;

/*Draft java code by "Lazarus Android Module Wizard" [5/2/2019 1:33:16]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/

//https://github.com/Cutta/ContinuousScrollableImageView

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
                  controls.pOnClickGeneric(pascalObj, Const.Click_Default); //JNI event onClick!
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
    public void SetId(int _id) { //wrapper method pattern ...
       this.setId(_id);
    }

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
