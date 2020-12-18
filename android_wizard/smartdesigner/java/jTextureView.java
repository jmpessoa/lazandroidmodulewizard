package org.lamw.apptextureviewdemo1;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.SurfaceTexture;
import android.util.Log;
import android.view.TextureView;
import android.view.View;
import android.view.ViewGroup;
 
/*Draft java code by "Lazarus Android Module Wizard" [3/6/2017 16:46:39]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
  
public class jTextureView extends TextureView /*dummy*/ { //please, fix what GUI object will be extended!
 
    private long pascalObj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;
 
    private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!
 
    SurfaceTextureListener  surfaceTextureListener;
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jTextureView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
 
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
            }
       };
       
       setOnClickListener(onClickListener);
       
       surfaceTextureListener = new SurfaceTextureListener(){
    
	      @Override
	      /*.*/public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int heigth) {
		// TODO Auto-generated method stub
		      controls.pOnSurfaceTextureAvailable(pascalObj, surface, width, heigth);
	      }

	      @Override
	      /*.*/public boolean onSurfaceTextureDestroyed(SurfaceTexture arg0) {
		// TODO Auto-generated method stub
		     return false;
	      }

	      @Override
	      /*.*/public void onSurfaceTextureSizeChanged(SurfaceTexture arg0, int arg1, int arg2) {
		// TODO Auto-generated method stub
		
	      }

	      @Override
	      /*.*/public void onSurfaceTextureUpdated(SurfaceTexture arg0) {
		// TODO Auto-generated method stub
		
	      }       
       };
       
       this.setSurfaceTextureListener(surfaceTextureListener);
       
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
    
    public void IsOpaque() {
    	this.isOpaque();
    }
    
    public void LockCanvas() {
       this.lockCanvas();
    }
    
    public Bitmap GetBitmap(int _width, int _height) {
    	return this.getBitmap(_width, _height);
    }
        
    public void SetAlpha(float _alpha) {
        this.setAlpha(_alpha);  //1.0f
     }
    	
    public void SetRotation(float _angleDegrees) {
    	this.setRotation(_angleDegrees);  //90.0f
    }	
        
    /*
     * 
     * Android's VideoView can only play videos straight and not mirrored.
      If you want your app to play a video mirrored (for instance if the video was recorded using a front camera),
       you will need to use a TextureView, which can be 
      easily mirrored by specifying android:scaleX=-1 in the XML file, or textureView.setScaleX(-1) in the code.
     */
    public void SetScaleX(int _x) {
    	this.setScaleX(_x);   // -1 to mirrored
    }
    
    public void SetScaleY(int _y) {
    	this.setScaleY(_y);  
    }
}
