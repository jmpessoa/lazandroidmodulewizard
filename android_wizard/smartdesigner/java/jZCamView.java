package org.lamw.camerabar;

import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.ImageFormat;
import android.graphics.Matrix;
import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.annotation.TargetApi;
import android.hardware.Camera.PreviewCallback;
import android.hardware.Camera.AutoFocusCallback;
import android.hardware.Camera.Parameters;
import android.hardware.Camera.Size;
import android.view.Display;
import android.view.Window;
import android.view.WindowManager;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
/*Draft java code by "Lazarus Android Module Wizard" [3/26/2019 23:36:46]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/

 
/** A basic Camera preview class */
class ZCamPreview extends SurfaceView implements SurfaceHolder.Callback {
    private SurfaceHolder mHolder;
    private Camera mCamera;
    private int cameraID  = -1; 
	private int rotation  ;
    private AutoFocusCallback autoFocusCallback;
private Controls controls ;
    public ZCamPreview(Context context, Camera camera,
                         
                         AutoFocusCallback autoFocusCb) {
        super(context);
        mCamera = camera;
         
        autoFocusCallback = autoFocusCb;

   

        Camera.Parameters parameters = camera.getParameters();
        for (String f : parameters.getSupportedFocusModes()) {
            if (f == Parameters.FOCUS_MODE_CONTINUOUS_PICTURE) {
                parameters.setFocusMode(Parameters.FOCUS_MODE_CONTINUOUS_PICTURE);
                autoFocusCallback = null;
                break;
            }
        }


        // Install a SurfaceHolder.Callback so we get notified when the
        // underlying surface is created and destroyed.
        mHolder = getHolder();
        mHolder.addCallback(this);
        // deprecated setting, but required on Android versions prior to 3.0
        mHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        // The Surface has been created, now tell the camera where to draw the preview.
        try {
            mCamera.setPreviewDisplay(holder);
        } catch (IOException e) {
            Log.d("DBG", "Error setting camera preview: " + e.getMessage());
        }
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        // This is necessary to prevent buffer errors: the camera must stop before the view is being destroyed.
        try {
            mCamera.setPreviewCallback(null);
            mCamera.stopPreview();
            mCamera.release();
            mCamera = null;
        } catch (Exception e){
            mCamera = null;
        }
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        /*
         * If your preview can change or rotate, take care of those events here.
         * Make sure to stop the preview before resizing or reformatting it.
         */
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

        Camera.Parameters parameters = mCamera.getParameters();
        parameters.setPictureFormat(ImageFormat.JPEG); // JPEG for full resolution images
     

        if(this.getResources().getConfiguration().orientation != Configuration.ORIENTATION_LANDSCAPE){
            parameters.set("orientation", "portrait");
            mCamera.setDisplayOrientation(90);
            parameters.setRotation(90);
        }else{
            parameters.set("orientation", "landscape");
            mCamera.setDisplayOrientation(0);
            parameters.setRotation(0);
        }
        mCamera.setParameters(parameters); // save everything
     
	 try {	
			//mCamera.setDisplayOrientation(90);
            mCamera.setPreviewDisplay(mHolder);
            
            mCamera.startPreview();
            mCamera.autoFocus(autoFocusCallback);
        } catch (Exception e){
            Log.d("DBG", "Error starting camera preview: " + e.getMessage());
        }
     }
	
	 
	
	
    }

public class jZCamView extends FrameLayout {

    private long pascalObj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;

    private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!

    private Camera mCamera;
    private ZCamPreview mPreview;
    private Handler autoFocusHandler;

    private boolean previewing = true;

    boolean initialized = false;

    boolean isLighOn = false;

    private boolean stopTimer = false;
    private String mPath;
    private String mFileName = "Picture1.jpg";
    private String mFolder = "";    
    private String mEnvDir; 

    //The "holder" is the underlying surface.
    private SurfaceHolder surfaceHolder = null;
    private Bitmap mPicture = null;
    private boolean mAutoInit = true;
    private boolean mFlashModeOn = false;
    private boolean mAutoFocusOnShot = false;
    private boolean mOnlyAutoFocus = false;
    private String currentDate = new SimpleDateFormat("dd-MM-yyyy", Locale.getDefault()).format(new Date());
    private String currentTime = new SimpleDateFormat("HH:mm:ss", Locale.getDefault()).format(new Date());
 		 
      
      
      private File getMyEnvDir(String environmentDir) {
       if (Build.VERSION.SDK_INT <=  29) {
           return Environment.getExternalStoragePublicDirectory(environmentDir);
       }
       else {
           return controls.activity.getExternalFilesDir(environmentDir);
       }
   }


       PreviewCallback previewCb = new PreviewCallback() {
        public void onPreviewFrame(byte[] data, Camera camera) {
 
        }
    };  

   
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jZCamView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

        super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;

        this.setClickable(true);
 
        LAMWCommon = new jCommons(this,context,pascalObj);

        onClickListener = new OnClickListener(){
            /*.*/public void onClick(View view){     // *.* is a mask to future parse...;
                if (enabled) {
                    if (initialized) {
                        //Log.i("onClickListener","onClickListener");
                        controls.pOnClickGeneric(pascalObj); //JNI event onClick!
                    }
                }
            };
        };
        setOnClickListener(onClickListener);

        autoFocusHandler = new Handler();
    

  
    }
   
    /** A safe way to get an instance of the Camera object. */
    public static Camera getCameraInstance(){
        Camera c = null;
        try {
            c = Camera.open();
        } catch (Exception e){
        }
        return c;
    }

    private void releaseCamera() {
        if (mCamera != null) {
            // This is necessary to prevent errors: the camea might already be releasing in SurfaceDestroy
            try {
            previewing = false;
            mCamera.setPreviewCallback(null);
            mCamera.stopPreview();
            mCamera.release();
            mCamera = null;
            } catch (Exception e){
                mCamera = null;
            }
        }
    }

    private Runnable doAutoFocus = new Runnable() {
        public void run() {
            if (previewing && (mCamera != null) )
                mCamera.autoFocus(autoFocusCB);
        }
    };

 

    // Mimic continuous auto-focusing
    AutoFocusCallback autoFocusCB = new AutoFocusCallback() {
        public void onAutoFocus(boolean success, Camera camera) {
            autoFocusHandler.postDelayed(doAutoFocus, 1000);
        }
    };

    public void jFree() {
        //free local objects...
        releaseCamera();
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
    
  

    public void TakePicture(String _filename) {
		 
    mFileName = _filename+currentDate+currentTime+".jpg";
    mEnvDir = GetEnvironmentDirectoryPath(1);
    mCamera.takePicture(null, null, mJPEGPictureCallback);
    }

    public void Scan() {
        if (!initialized) {
            initialized =  true;

            if (mCamera == null)
                mCamera = getCameraInstance();

            mPreview = new ZCamPreview(controls.activity, mCamera, autoFocusCB);
            mPreview.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
            this.addView(mPreview);
        }
     
    }

    public void StopScan() {
        if (initialized) {
           releaseCamera();
           this.removeView(mPreview);
           mPreview = null;
           initialized = false;
           previewing = true;
           
        }
    }
	
	
	
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
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

    private String getOutputMediaFile(){
        File mediaStorageDir = new File(mEnvDir, mFolder);
		 Log.d("DBG","getOutputMediaFile()"+ mEnvDir+ mFolder);
        if (! mediaStorageDir.exists()){
            if (! mediaStorageDir.mkdirs()){
                return null;
            }
        }
        mPath = mediaStorageDir.getPath() + File.separator + mFileName;
        // Log.i("0. getOutputMediaFile", mPath);
        return mPath;
    }

    public String GetEnvironmentDirectoryPath(int _directory) {

        File filePath= null;
        String absPath="";   //fail!

        //getMyEnvDir(Environment.DIRECTORY_DOCUMENTS);break; //only Api 19!
        if (_directory != 8) {
            switch(_directory) {
                case 0:  filePath = getMyEnvDir(Environment.DIRECTORY_DOWNLOADS); break;
                case 1:  filePath = getMyEnvDir(Environment.DIRECTORY_DCIM); break;
                case 2:  filePath = getMyEnvDir(Environment.DIRECTORY_MUSIC); break;
                case 3:  filePath = getMyEnvDir(Environment.DIRECTORY_PICTURES); break;
                case 4:  filePath = getMyEnvDir(Environment.DIRECTORY_NOTIFICATIONS); break;
                case 5:  filePath = getMyEnvDir(Environment.DIRECTORY_MOVIES); break;
                case 6:  filePath = getMyEnvDir(Environment.DIRECTORY_PODCASTS); break;
                case 7:  filePath = getMyEnvDir(Environment.DIRECTORY_RINGTONES); break;

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

    /** Handles data for jpeg picture */
    // AsyncTask: ref https://github.com/josnidhin/Android-Camera-Example/blob/master/src/com/example/cam/CamTestActivity.java
    PictureCallback mJPEGPictureCallback = new PictureCallback() {
 
        @Override
        public void onPictureTaken(byte[] data, Camera camera) {
           Log.d("DBG", "onPictureTaken"); 
        	 try {
            camera.stopPreview();
        } catch (Exception e){
            // ignore: tried to stop a non-existent preview
        } // better do that because we don't need a preview right now
        	
            // create a Bitmap from the raw data
            mPicture = BitmapFactory.decodeByteArray(data, 0, data.length);
            
            // [IMPORTANT!] the image contained in the raw array is ALWAYS landscape-oriented.
            // We detect if the user took the picture in portrait mode and rotate it accordingly.
            int rotation = controls.activity.getWindowManager().getDefaultDisplay().getRotation();
           
            if (rotation == Surface.ROTATION_0 || rotation == Surface.ROTATION_180) {            	
                Matrix matrix = new Matrix();
                matrix.postRotate(90);
                // create a rotated version and replace the original bitmap
                Bitmap bmpRotate = Bitmap.createBitmap(mPicture, 0, 0, mPicture.getWidth(), mPicture.getHeight(), matrix, true);
                matrix.reset();
                
                mPicture = bmpRotate;
            }
            
            String bmpPath = getOutputMediaFile();
             Log.d("DBG","bmpath getOutputMediaFile()"+ bmpPath);
            saveBitmapToJpg(mPicture, bmpPath);
 
            try {
         
            mCamera.startPreview();
            previewing = true;
            mCamera.autoFocus(autoFocusCB);
         } catch (Exception e){
             Log.d("DBG", "Error starting camera preview: " + e.getMessage());
         }            
           controls.pOnZCamViewResult(pascalObj,bmpPath, 0);
		   
        }
    };
	
	
	
	 
    // by tr3e
    @SuppressLint("WrongThread")
    private void saveBitmapToJpg(Bitmap bitmap, String bmpPath) {
             Log.d("DBG", "saveBitmapToJpg"+bmpPath);  
           OutputStream outStream = null;
           
           final File file = new File(bmpPath);
           
           try {
            outStream = new FileOutputStream(file);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 90, outStream);
            outStream.flush();
            outStream.close();
            bitmap.recycle(); //thanks to Guser979


            //Toast.makeText(context, "Saved", Toast.LENGTH_LONG).show();

           } catch (final FileNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            //Toast.makeText(context, e.toString(), Toast.LENGTH_LONG).show();
           } catch (final IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            //Toast.makeText(context, e.toString(), Toast.LENGTH_LONG).show();
           }

          }
	


    public void SetEnvironmentStorage(int _environmentDir,  String _folderName) {
        mEnvDir = GetEnvironmentDirectoryPath(1); ///  mEnvDir = GetEnvironmentDirectoryPath(_environmentDir); 
        mFolder = ""; //mFolder = _folderName;
    }

    public void SetEnvironmentStorage(int _environmentDir,  String _folderName,  String _fileName) {
        mEnvDir = GetEnvironmentDirectoryPath(1); ///  mEnvDir = GetEnvironmentDirectoryPath(_environmentDir); 
        mFolder = ""; //mFolder = _folderName;
      mFileName = currentDate+currentTime ; //mFileName = _fileName;
    }

    public void SaveToMediaStore(String _title, String _description) {
        // save to media library
        if (mPicture != null) {
            MediaStore.Images.Media.insertImage(controls.activity.getContentResolver(), mPicture, _title, _description);
        }
    }

    public Bitmap GetImage(int _width, int _height) {
    	File fileBmp = new File(getOutputMediaFile());
    	
        return decodeSampleImage(fileBmp, _width, _height);
    }


    public Bitmap GetImage() {
        return mPicture;
    }
	
 
    //https://mkyong.com/android/how-to-turn-onoff-camera-ledflashlight-in-android/
    public void SetFlashlight(boolean _flashlightMode){

        if (mCamera == null)
            mCamera = getCameraInstance();

        if (this.mCamera != null) {

            Camera.Parameters p = mCamera.getParameters();

            if (_flashlightMode) {
                if (!isLighOn) {
                    p.setFlashMode(Camera.Parameters.FLASH_MODE_TORCH);
                    mCamera.setParameters(p);
                    mCamera.startPreview();
                    isLighOn = true;
                }
            }
            else  {
                if (isLighOn) {
                    p.setFlashMode(Camera.Parameters.FLASH_MODE_OFF);
                    mCamera.setParameters(p);
                    mCamera.startPreview();
                    isLighOn = false;
                }
            }
        }
    }

}



