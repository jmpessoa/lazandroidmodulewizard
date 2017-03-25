package org.lamw.appvideoviewdemo1;
import java.io.File;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.graphics.Color;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnPreparedListener;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Environment;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.View;
import android.view.ViewGroup;
import android.widget.MediaController;
import android.widget.VideoView;
 
/*Draft java code by "Lazarus Android Module Wizard" [3/11/2017 15:47:09]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
  
//ref. https://examples.javacodegeeks.com/android/android-videoview-example/
//ref. http://www.oodlestechnologies.com/blogs/Working-with-MediaController,--VideoView-in-Android

public class jVideoView extends VideoView /*dummy*/ { //please, fix what GUI object will be extended!
 
    private long pasobj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;
 
    private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!
    private MediaController mMediaControls;
    private int mPosition = 0;
    private ProgressDialog mProgressDialog;
    
    VideoView mVideo;
	String mTitle = "Play Video"; 
	String mWaitingMessage = "Loading, Please Wait...";
	boolean mCancelable = false;
	
	int mVideoDuration;
 
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jVideoView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
 
       super(_ctrls.activity);
       context   = _ctrls.activity;
       pasobj = _Self;
       controls  = _ctrls;
 
       LAMWCommon = new jCommons(this,context,pasobj);
 
       onClickListener = new OnClickListener(){
       /*.*/public void onClick(View view){     // *.* is a mask to future parse...;
               if (enabled) {
                  controls.pOnClickGeneric(pasobj, Const.Click_Default); //JNI event onClick!
               }
            };
       };
       setOnClickListener(onClickListener);
       
       mMediaControls = new MediaController(controls.activity);
       this.setMediaController(mMediaControls);
                             
 	  //create a progress bar while the video file is loading
       mProgressDialog = new ProgressDialog(context);
       mProgressDialog.setTitle(mTitle); 
       mProgressDialog.setMessage(mWaitingMessage);
       mProgressDialog.setCancelable(mCancelable);
       
       mVideo = this;       
       mMediaControls.setAnchorView(mVideo);
       
    } //end constructor
    
    public void jFree() {
       //free local objects...
   	 setOnClickListener(null);   	 
     mMediaControls = null;     
     mProgressDialog = null;        	 
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
           
    public void Pause() {
       this.pause();
    }
    
    public void Resume() {
       this.resume();
    }
    
    public void SeekTo(int _position) {
      mPosition = _position;	
      this.seekTo(_position); //when we want the video to start from a certain point
    }

    public int GetCurrentPosition(){
    	mPosition =  this.getCurrentPosition();
    	return mPosition; 
    }
    
    public void SetProgressDialog(String _title, String _waitingMessage, boolean _cancelable) {   //"Loading, Please Wait..."
    	mTitle = _title; 
    	mWaitingMessage = _waitingMessage;
    	mCancelable = _cancelable;
        mProgressDialog.setTitle(_title);  //"JavaCodeGeeks Android Video View Example"
        mProgressDialog.setMessage(_waitingMessage);
        mProgressDialog.setCancelable(_cancelable);
     }
           
    public class BackgroundAsyncTask extends AsyncTask<String, Uri, Void> {
        Integer track = 0;        
        @Override
        
        protected void onPreExecute() {     
        	mProgressDialog.show();
        }        
        @Override
        protected void onProgressUpdate(final Uri... uri) {
            try {
            	mVideo.requestFocus();
                mVideo.setVideoURI(uri[0]);              
                mVideo.setOnPreparedListener(new OnPreparedListener() { 
                    public void onPrepared(MediaPlayer arg0) {                    	
                    	mVideoDuration = mVideo.getDuration();
                    	mVideo.seekTo(0);
                    	mVideo.start();
                    	mProgressDialog.dismiss();                    	                    	                      
                    }
                });            	
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            } catch (IllegalStateException e) {
                e.printStackTrace();
            } catch (SecurityException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }             
        }
 
        @Override
        protected Void doInBackground(String... params) {
            try {
                Uri uri = Uri.parse(params[0]);                
                publishProgress(uri);                
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null;
        }          
    }
    
    public void PlayFromUrl(String _url) {   
       new BackgroundAsyncTask() 
           .execute(_url);
    }
    
    public void PlayFromRawResource(String _identifierName) {  //"android.resource://" + getPackageName() + "/" + R.raw.kitkat
    	String path = "android.resource://" + controls.activity.getPackageName() +
    			"/" + getResources().getIdentifier(_identifierName, "raw", controls.activity.getPackageName());

        new BackgroundAsyncTask() 
            .execute(path);
    }
    
    public void PlayFromSdcard(String _fileName) {    	    	
    	String path = Environment.getExternalStorageDirectory() + "/" + _fileName;    	
        new BackgroundAsyncTask() 
        .execute(path);
    }
        
}
