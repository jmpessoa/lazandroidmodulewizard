package org.lamw.appzbarcodescannerviewdemo1;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.Camera;
import android.hardware.Camera.PreviewCallback;
import android.hardware.Camera.AutoFocusCallback;
import android.hardware.Camera.Parameters;
import android.hardware.Camera.Size;

import android.os.Build;
import android.os.Handler;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import java.io.IOException;
import android.graphics.ImageFormat;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

/* Import ZBar Class files */
import net.sourceforge.zbar.ImageScanner;
import net.sourceforge.zbar.Image;
import net.sourceforge.zbar.Symbol;
import net.sourceforge.zbar.SymbolSet;
import net.sourceforge.zbar.Config;

/*Draft java code by "Lazarus Android Module Wizard" [3/26/2019 23:36:46]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/

//ref https://sourceforge.net/projects/zbar/files/AndroidSDK/
//https://github.com/dm77/barcodescanner
//https://www.raviyp.com/android/181-best-bar-code-qr-code-scanner-library-for-using-in-android
/** A basic Camera preview class */
class ZBarCameraPreview extends SurfaceView implements SurfaceHolder.Callback {
    private SurfaceHolder mHolder;
    private Camera mCamera;
    private PreviewCallback previewCallback;
    private AutoFocusCallback autoFocusCallback;

    public ZBarCameraPreview(Context context, Camera camera,
                         PreviewCallback previewCb,
                         AutoFocusCallback autoFocusCb) {
        super(context);
        mCamera = camera;
        previewCallback = previewCb;
        autoFocusCallback = autoFocusCb;

        /*
         * Set camera to continuous focus if supported, otherwise use
         * software auto-focus. Only works for API level >=9.
         */

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

        try {
            // Hard code camera surface rotation 90 degs to match Activity view in portrait
            mCamera.setDisplayOrientation(90);
            mCamera.setPreviewDisplay(mHolder);
            mCamera.setPreviewCallback(previewCallback);
            mCamera.startPreview();
            mCamera.autoFocus(autoFocusCallback);
        } catch (Exception e){
            Log.d("DBG", "Error starting camera preview: " + e.getMessage());
        }
    }
}

public class jZBarcodeScannerView extends FrameLayout {

    private long pascalObj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;

    private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!

    private Camera mCamera;
    private ZBarCameraPreview mPreview;
    private Handler autoFocusHandler;

    ImageScanner scanner;

    private boolean barcodeScanned = false;
    private boolean previewing = true;

    boolean initialized = false;

    boolean isLighOn = false;

    ///
    /*
    static {
        System.loadLibrary("iconv");
    }
    */
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jZBarcodeScannerView(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

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
        /* Instance barcode scanner */
        scanner = new ImageScanner();
        scanner.setConfig(0, Config.X_DENSITY, 3);
        scanner.setConfig(0, Config.Y_DENSITY, 3);

        /*
        mCamera = getCameraInstance();
        mPreview = new ZBarCameraPreview(_ctrls.activity, mCamera, previewCb, autoFocusCB);
        mPreview.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
        this.addView(mPreview);
        */
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

    PreviewCallback previewCb = new PreviewCallback() {
        public void onPreviewFrame(byte[] data, Camera camera) {
            Camera.Parameters parameters = camera.getParameters();
            Size size = parameters.getPreviewSize();

            //Java port of Zbar's scanner accepts only Y800 and GRAY pixels format
            Image barcode = new Image(size.width, size.height, "Y800");
            barcode.setData(data);

            int result = scanner.scanImage(barcode);

            if (result != 0) {
                previewing = false;
                mCamera.setPreviewCallback(null);
                mCamera.stopPreview();

                SymbolSet syms = scanner.getResults();
                for (Symbol sym : syms) {
                    //scanText.setText("BarcodeResult " + sym.getData());
                    //Log.i("BarcodeResult", " data = "+ sym.getData());
                    //Log.i("BarcodeResult type", " type = "+ sym.getType());
                    controls.pOnZBarcodeScannerViewResult(pascalObj, sym.getData(), sym.getType());
                    barcodeScanned = true;
                }
            }
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
    
    private void ReScan() {
        if (barcodeScanned) {
            barcodeScanned = false;
            //scanText.setText("Scanning...");
            Log.i("Scanning", "Scanning...");
            mCamera.setPreviewCallback(previewCb);
            mCamera.startPreview();
            previewing = true;
            mCamera.autoFocus(autoFocusCB);
        }
    }

    public void Scan(Bitmap _barcodeBmp) {
        if (_barcodeBmp != null) {
        //Bitmap barcodeBmp = BitmapFactory.decodeResource(getResources(), R.drawable.barcode);
        int width = _barcodeBmp.getWidth();
        int height = _barcodeBmp.getHeight();
        int[] pixels = new int[width*height];
        _barcodeBmp.getPixels(pixels, 0, width, 0, 0, width, height);
        Image barcode = new Image(width, height, "RGB4");
        barcode.setData(pixels);
        int result = scanner.scanImage(barcode.convert("Y800"));
        if (result != 0) {
            SymbolSet syms = scanner.getResults();
            for (Symbol sym : syms) {
                controls.pOnZBarcodeScannerViewResult(pascalObj, sym.getData(), sym.getType());
            }
        }
    }
    }

    public void Scan() {
        if (!initialized) {
            initialized =  true;

            if (mCamera == null)
                mCamera = getCameraInstance();

            mPreview = new ZBarCameraPreview(controls.activity, mCamera, previewCb, autoFocusCB);
            mPreview.setLayoutParams(new LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
            this.addView(mPreview);
        }
        else ReScan();
    }

    public void StopScan() {
        if (initialized) {
           releaseCamera();
           this.removeView(mPreview);
           mPreview = null;
           initialized = false;
           previewing = true;
           barcodeScanned = false;
        }
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



