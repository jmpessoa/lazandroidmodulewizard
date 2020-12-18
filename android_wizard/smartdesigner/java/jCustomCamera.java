package lamw.org.appcustomcamerademo1;

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

//  https://github.com/alessandrofrancesconi/NiceCameraExample by Alessandro Francesconi
//  https://github.com/josnidhin/Android-Camera-Example/blob/master/src/com/example/cam/CamTestActivity.java
public class jCustomCamera  extends SurfaceView implements SurfaceHolder.Callback {

    private long pascalObj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;

    private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!

    //private SurfaceHolder mHolder;
    private Camera camera = null;
    private int cameraID  = -1;

    // private int seconds = 10; //THIS WILL RUN FOR 10 SECONDS
    private boolean stopTimer = false;
    private String mPath;
    private String mFileName = "Picture1.jpg";
    private String mFolder = "CustomCam";    
    private String mEnvDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getPath();

    //The "holder" is the underlying surface.
    private SurfaceHolder surfaceHolder = null;
    private Bitmap mPicture = null;
    private boolean mAutoInit = true;
    private boolean mFlashModeOn = false;
    private boolean mAutoFocusOnShot = false;
    private boolean mOnlyAutoFocus = false;

    //flag to detect flash is on or off
    private boolean isLighOn = false;

    public jCustomCamera(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
        
        setCameraInstance();
        
        surfaceHolder = this.getHolder();
        surfaceHolder.addCallback(this);       
    }

    /**
     * Called when the surface is created for the first time. It sets all the
     * required {camera}'s parameters and starts the preview stream.
     */
    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        setupCamera();
        if (mAutoInit) startCameraPreview(holder);
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int w, int h) {
        if (this.surfaceHolder.getSurface() == null) {
            //surfaceHolder is null, nothing to do...
            return;
        }
                 
        controls.pOnCustomCameraSurfaceChanged(pascalObj,w,h);
        // stop preview before making changes!
        stopCameraPreview();
        // set preview size and make any resize, rotate or
        // reformatting changes here
        updateCameraDisplayOrientation();
        // restart preview with new settings
        startCameraPreview(holder);
    }
    
    public void surfaceUpdate() {
        if (this.surfaceHolder.getSurface() == null) {
            //surfaceHolder is null, nothing to do...
            return;
        }
        
        // stop preview before making changes!
        stopCameraPreview();
        // set preview size and make any resize, rotate or
        // reformatting changes here
        updateCameraDisplayOrientation();
        // restart preview with new settings
        startCameraPreview(surfaceHolder);
    }

    /**
     * surfaceDestroyed does nothing, because Camera release is
     * performed in the parent Activity
     * @param holder
     */
    @Override
    public void surfaceDestroyed(SurfaceHolder holder) { }

    private boolean setCameraInstance() {
        boolean result = false;
        if (this.camera != null) {
            // do the job only if the camera is not already set
            return true;
        }
    // warning here! starting from API 9, we can retrieve one from the multiple
        // hardware cameras (ex. front/back)
        if (Build.VERSION.SDK_INT >= 9) {
            if (this.cameraID < 0) {
                // at this point, it's the first time we request for a camera
                Camera.CameraInfo camInfo = new Camera.CameraInfo();
                for (int i = 0; i < Camera.getNumberOfCameras(); i++) {
                    Camera.getCameraInfo(i, camInfo);
                    if (camInfo.facing == Camera.CameraInfo.CAMERA_FACING_BACK) {
                        // in this example we'll request specifically the back camera
                        try {
                            this.camera = Camera.open(i);
                            this.cameraID = i; // assign to cameraID this camera's ID (O RLY?)
                            result = true;
                        }
                        catch (RuntimeException e){
                            // something bad happened! this camera could be locked by other apps
                            result = false;
                        }
                    }
                }
            }
            else {
                // at this point, a previous camera was set, we try to re-instantiate it
                try {
                    this.camera = Camera.open(this.cameraID);
                }
                catch (RuntimeException e){
                    result = false;
                }
            }
        }

        return result;
    }

    private void releaseCameraInstance() {
        if (this.camera != null) {
            try {
                this.camera.stopPreview();
            }
            catch (Exception e) {
            }
            this.camera.setPreviewCallback(null);
            this.camera.release();
            this.camera = null;
            this.cameraID = -1;
        }
    }

    public Camera getCamera() {
        return this.camera;
    }

    public int getCameraID() {
        return this.cameraID;
    }

    private void setupCamera() {
       
        if (camera == null) return;
            
        Camera.Parameters parameters = camera.getParameters();
        parameters.setPictureFormat(ImageFormat.JPEG); // JPEG for full resolution images
        
        //mFlashModeOn = true;

        try {
            if (! mFlashModeOn)
               parameters.setFlashMode(Camera.Parameters.FLASH_MODE_OFF);
             else
                parameters.setFlashMode(Camera.Parameters.FLASH_MODE_ON);
        }
        catch (NoSuchMethodError e) {
            // remember that not all the devices support a given feature
        }

        if (parameters.getSupportedFocusModes().contains(Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE)) {
            parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE);
        }

        if(this.getResources().getConfiguration().orientation != Configuration.ORIENTATION_LANDSCAPE){
            parameters.set("orientation", "portrait");
            camera.setDisplayOrientation(90);
            parameters.setRotation(90);
        }else{
            parameters.set("orientation", "landscape");
            camera.setDisplayOrientation(0);
            parameters.setRotation(0);
        }
        camera.setParameters(parameters); // save everything

    }

    /**
     * In addition to calling {@link Camera#startPreview()}, it also
     * updates the preview display that could be changed in some situations
     * @param holder the current {@link SurfaceHolder}
     */
    private synchronized void startCameraPreview(SurfaceHolder holder) {
        //MainActivity parent = (MainActivity)this.getContext();
    	
    	if (camera == null) setCameraInstance();
    	
    	if (camera == null) return;
        
        try {
            camera.setPreviewDisplay(holder);
            camera.startPreview();
        } catch (Exception e){
        }
    }

    /**
     * It "simply" calls {@link Camera#stopPreview()} and checks
     * for errors
     */
    private synchronized void stopCameraPreview() {
        //MainActivity parent = (MainActivity)this.getContext();
    	if (camera == null) return;
    	        
        try {
            camera.stopPreview();
        } catch (Exception e){
            // ignored: tried to stop a non-existent preview
        }
    }

    /**
     * Gets the current screen rotation in order to understand how much
     * the surface needs to be rotated
     */
    private void updateCameraDisplayOrientation() {
    	
    	if (camera == null) setCameraInstance();
    	
    	if (camera == null) return;
    	
        int cameraID = this.getCameraID();
        
        int result = 0;
        int rotation = controls.activity.getWindowManager().getDefaultDisplay().getRotation();
        int degrees = 0;
        switch (rotation) {
            case Surface.ROTATION_0: degrees = 0; break;
            case Surface.ROTATION_90: degrees = 90; break;
            case Surface.ROTATION_180: degrees = 180; break;
            case Surface.ROTATION_270: degrees = 270; break;
        }

        if (Build.VERSION.SDK_INT >= 9) {
            // on >= API 9 we can proceed with the CameraInfo method
            // and also we have to keep in mind that the camera could be the front one
            Camera.CameraInfo info = new Camera.CameraInfo();
            Camera.getCameraInfo(cameraID, info);
            if (info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
                result = (info.orientation + degrees) % 360;
                result = (360 - result) % 360;  // compensate the mirror
            }
            else {
                // back-facing
                result = (info.orientation - degrees + 360) % 360;
            }
        }
        else {
            // TODO: on the majority of API 8 devices, this trick works good
            // and doesn't produce an upside-down preview.
            // ... but there is a small amount of devices that don't like it!
            result = Math.abs(degrees - 90);
        }
        camera.setDisplayOrientation(result); // save settings
    }

    public void jFree() {
        //free local objects...
        releaseCameraInstance();
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
        if (! mediaStorageDir.exists()){
            if (! mediaStorageDir.mkdirs()){
                return null;
            }
        }
        mPath = mediaStorageDir.getPath() + File.separator + mFileName;
        //Log.i("0. getOutputMediaFile", mPath);
        return mPath;
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

    /** Handles data for jpeg picture */
    // AsyncTask: ref https://github.com/josnidhin/Android-Camera-Example/blob/master/src/com/example/cam/CamTestActivity.java
    PictureCallback mJPEGPictureCallback = new PictureCallback() {

        @Override
        public void onPictureTaken(byte[] data, Camera camera) {
            
        	stopCameraPreview(); // better do that because we don't need a preview right now
        	
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
            
            saveBitmapToJpg(mPicture, bmpPath);
            	            
            startCameraPreview(surfaceHolder);
                        
            controls.pOnCustomCameraPictureTaken(pascalObj,  mPicture, bmpPath);
        }
    };
    
    Camera.AutoFocusCallback mAutoFocusCallBack = new Camera.AutoFocusCallback(){
        @Override
        public void onAutoFocus(boolean success, Camera arg1) {
            //camera.takePicture(shutterCallback, rawCallback, jpegCallback);
        	if( !mOnlyAutoFocus ){
             if ((camera != null) && success)
               camera.takePicture(null, null, mJPEGPictureCallback);             
        	}
        	
        }
     };
    
    // by tr3e
    @SuppressLint("WrongThread")
    private void saveBitmapToJpg(Bitmap bitmap, String bmpPath) {
        
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
    
    // by tr3e
    public void cameraAutoFocus(){
    	if(camera == null) return;
    	
        if( mAutoFocusCallBack == null ) return;
    	
    	mOnlyAutoFocus = true;
    	
    	camera.cancelAutoFocus(); // Fix autoFocus
    	camera.autoFocus(mAutoFocusCallBack);
    }
    
    // by tr3e
    public void cameraSetAutoFocusOnShot( boolean _autoFocusOnShot ){
    	mAutoFocusOnShot = _autoFocusOnShot;
    }

    public void TakePicture() {    
    	
    	if( (camera == null) || (mJPEGPictureCallback == null) || (mAutoFocusCallBack == null) ) return;
    	    	
    	mOnlyAutoFocus = false;
    	
    	if( mAutoFocusOnShot ){
    		camera.cancelAutoFocus(); // Fix autoFocus
            camera.autoFocus(mAutoFocusCallBack);
    	}else
        	camera.takePicture(null, null, mJPEGPictureCallback);
    }

    //ABOUT: https://stackoverflow.com/questions/19804233/android-autofocuscallback-is-not-being-called-or-not-returning
    // https://stackoverflow.com/questions/25321968/trouble-with-focus-mode-continuous-picture-on-galaxy-s5
    public void TakePicture(String _filename) {
    	    	
    	if(camera == null) return;
    	
        mFileName = _filename;
        
        TakePicture();        
    }

    public void SetEnvironmentStorage(int _environmentDir,  String _folderName) {
        mEnvDir = GetEnvironmentDirectoryPath(_environmentDir); /// storage/emulated/0/Download
        mFolder = _folderName;
    }

    public void SetEnvironmentStorage(int _environmentDir,  String _folderName,  String _fileName) {
        mEnvDir = GetEnvironmentDirectoryPath(_environmentDir);
        mFolder = _folderName;
        mFileName = _fileName;
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

        if (this.camera != null) {

                Camera.Parameters p = camera.getParameters();

                if (_flashlightMode) {
                    if (!isLighOn) {
                        p.setFlashMode(Camera.Parameters.FLASH_MODE_TORCH);
                        camera.setParameters(p);
                        camera.startPreview();
                        isLighOn = true;
                    }
                }
                else  {
                    if (isLighOn) {
                        p.setFlashMode(Camera.Parameters.FLASH_MODE_OFF);
                        camera.setParameters(p);
                        camera.startPreview();
                        isLighOn = false;
                    }
            }
        }
    }

}
