package lamw.org.appcustomcamerademo1;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import android.content.Context;
import android.hardware.Camera;
import android.os.Environment;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.util.List;

/*Draft java code by "Lazarus Android Module Wizard" [4/18/2018 16:32:11]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
 
//https://developer.android.com/training/camera/cameradirect.html
//http://www.blog.nathanhaze.com/creating-camera-application-android/

public class jCustomCamera extends SurfaceView  implements SurfaceHolder.Callback  {

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   
   private SurfaceHolder mHolder;
   private Camera mCamera;
   
   private int seconds = 10; //THIS WILL RUN FOR 10 SECONDS
   private boolean stopTimer = false;
   private String mPath;
   private String mFileName = "Picture_1.jpg";
   
   private String mFolder = "Pictures";
   private File mMediaFile;
   
   private String mEnvDir = Environment.DIRECTORY_DOWNLOADS;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jCustomCamera(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

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
      mCamera = getCameraInstance();      
      mHolder = getHolder();
      mHolder.addCallback(this);
      // deprecated setting, but required on Android versions prior to 3.0
      mHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);

   } //end constructor

   public void jFree() {
      //free local objects...	  
	   if (mCamera != null){
		   mHolder.removeCallback(this);
           mCamera.release();
           mCamera = null;
       }	   	   	   
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

   @Override
   public void surfaceCreated(SurfaceHolder holder) {	   
	   if (mCamera == null) mCamera = getCameraInstance();	   
       Camera.Parameters params = mCamera.getParameters();
       List<Camera.Size> sizes = params.getSupportedPictureSizes();
       Camera.Size mSize = null;
       for(Camera.Size size : sizes){
           mSize = size;
       }       
       int minWidth = Integer.MAX_VALUE, minHeight = Integer.MAX_VALUE;    
       for (int i = 0; i < sizes.size(); i++) {
           if (sizes.get(i).width < minWidth) {
               minWidth = sizes.get(i).width;
               minHeight = sizes.get(i).height;
           }
       }

       if (params.getSupportedFocusModes().contains(Camera.Parameters.FOCUS_MODE_AUTO)) {
           params.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
       }

       if(this.getResources().getConfiguration().orientation != Configuration.ORIENTATION_LANDSCAPE){
           params.set("orientation", "portrait");
           mCamera.setDisplayOrientation(90);
           params.setRotation(90);
       }else{
           params.set("orientation", "landscape");
           mCamera.setDisplayOrientation(0);
           params.setRotation(0);
       }

       mCamera.setParameters(params);
       
       // The Surface has been created, now tell the camera where to draw the preview.
       try {
           mCamera.setPreviewDisplay(holder);
           mCamera.startPreview();
       } catch (IOException e) {
           e.printStackTrace();
       }	   	
   }
   
@Override
public void surfaceChanged(SurfaceHolder arg0, int arg1, int arg2, int arg3) {
    // If your preview can change or rotate, take care of those events here.
    // Make sure to stop the preview before resizing or reformatting it.
    if (mHolder.getSurface() == null){
        // preview surface does not exist
        return;
    }
    // stop preview before making changes
    try {
        mCamera.stopPreview();
    } catch (Exception e){
        // ignore: tried to stop a non-existent preview
    }
    // set preview size and make any resize, rotate or
    // reformatting changes here
    // start preview with new settings
    try {
        mCamera.setPreviewDisplay(mHolder);
        mCamera.startPreview();

    } catch (Exception e){
        e.printStackTrace();
    }	
}


@Override
public void surfaceDestroyed(SurfaceHolder arg0) {
    // empty. Take care of releasing the Camera preview in your activity.	
}

private  Camera getCameraInstance(){
    Camera c = null;
    try {
        c = Camera.open(); // attempt to get a Camera instance
    }
    catch (Exception e){
        // Camera is not available (in use or does not exist)
    }
    return c; // returns null if camera is unavailable
}

private Camera.PictureCallback mPicture = new Camera.PictureCallback() {
	
    @Override
    public void onPictureTaken(byte[] data, Camera camera) {
        File pictureFile = getOutputMediaFile();        
        if (pictureFile == null){
            return;
        }
        try {
            FileOutputStream fos = new FileOutputStream(pictureFile);
            BufferedOutputStream bos = new BufferedOutputStream(fos);
            bos.write(data, 0, data.length);
            bos.close();
            fos.close();
            camera.startPreview();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
};

private Bitmap decodeSampleImage(File f, int width, int height) { 	    
    try { 	        
          System.gc(); // First of all free some memory //Decode image size 	        
          BitmapFactory.Options o = new BitmapFactory.Options(); 	        
          o.inJustDecodeBounds = true; 	        
          BitmapFactory.decodeStream(new FileInputStream(f), null, o); // The new size we want to scale to 	                            final int requiredWidth = width; 	        
          int requiredHeight = height; 	        // Find the scale value (as a power of 2) 	   
          int requiredWidth = width;          
          int sampleScaleSize = 1; 	        
          while (o.outWidth / sampleScaleSize / 2 >= requiredWidth && o.outHeight / sampleScaleSize / 2 >= requiredHeight)
            sampleScaleSize *= 2;
           //Decode with inSampleSize
          BitmapFactory.Options o2 = new BitmapFactory.Options();
          o2.inSampleSize = sampleScaleSize;
          return BitmapFactory.decodeStream(new FileInputStream(f), null, o2);
    } catch (Exception e) {
      //  Log.d(TAG, e.getMessage()); // We don't want the application to just throw an exception
    }
    return null;
}

private File getOutputMediaFile(){	
    File mediaStorageDir = new File(Environment.getExternalStoragePublicDirectory(mEnvDir), mFolder);
    if (! mediaStorageDir.exists()){
          if (! mediaStorageDir.mkdirs()){
            return null;
          }
          mPath = mediaStorageDir.getPath() + File.separator + mFileName;
    }      
    mMediaFile = new File(mPath);        
    return mMediaFile;
}

public String GetEnvironmentDirectoryPath(int _directory) {
	
	File filePath= null;
	String absPath="";   //fail!
	  
	//Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);break; //only Api 19!
	if (_directory != 8) {		  	   	 
	  switch(_directory) {	                       
	    case 0:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS); break;	   
	    case 1:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM); break;
	    case 2:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC); break;
	    case 3:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES); break;
	    case 4:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_NOTIFICATIONS); break;
	    case 5:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES); break;
	    case 6:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PODCASTS); break;
	    case 7:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RINGTONES); break;
	    
	    case 9: absPath  = this.controls.activity.getFilesDir().getAbsolutePath(); break;      //Result : /data/data/com/MyApp/files	    	    
	    case 10: absPath = this.controls.activity.getFilesDir().getPath();
	             absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/databases"; break;
	    case 11: absPath = this.controls.activity.getFilesDir().getPath();
                 absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/shared_prefs"; break;	             
	           
	  }
	  	  
	  //Make sure the directory exists.
      if (_directory < 8) { 
    	 filePath.mkdirs();
    	 absPath= filePath.getPath(); 
      }	        
      
	}else {  //== 8 
	    if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) == true) {
	    	filePath = Environment.getExternalStorageDirectory();  //sdcard!
	    	// Make sure the directory exists.
	    	filePath.mkdirs();
	   	    absPath= filePath.getPath();
	    }
	}    	
	    		  
	return absPath;
}

public void TakePicture() {
   mCamera.takePicture(null, null, mPicture);
}

public void TakePicture(String _filename) {
   mFileName = _filename; 
   mCamera.takePicture(null, null, mPicture);
}

public Bitmap GetBitmap(int _width, int _height) {
   return decodeSampleImage(mMediaFile,_width, _height); // prevents memory out of memory exception	
}

public void SetEnvironmentStorage(int _environmentDir,  String _folderName) {	
	mEnvDir = GetEnvironmentDirectoryPath(_environmentDir);
	mFolder = _folderName;
}


}
