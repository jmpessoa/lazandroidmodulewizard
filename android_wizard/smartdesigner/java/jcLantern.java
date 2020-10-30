package org.lamw.appcompatlanterndemo1;

import androidx.lifecycle.Lifecycle.Event;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.OnLifecycleEvent;
import androidx.annotation.RequiresPermission;

import android.content.Context;

import android.Manifest;
import android.app.Activity;

import android.os.Handler;
import android.Manifest;
import android.content.pm.PackageManager;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.view.Window;
import android.view.WindowManager;

import android.annotation.TargetApi;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraManager;
import android.os.Build.VERSION_CODES;

import android.hardware.Camera;
import android.hardware.Camera.CameraInfo;

import java.lang.ref.WeakReference;
import java.util.concurrent.TimeUnit;

interface DisplayLightController {

    boolean checkSystemWritePermission();

    void cleanup();

    void disableAlwaysOnMode();

    void disableAutoBrightMode();

    void disableFullBrightMode();

    void enableAlwaysOnMode();

    void enableAutoBrightMode();

    void enableFullBrightMode();

    void requestSystemWritePermission();
}

interface FlashController {

    void off();

    void on();

}

class Utils {

    /**
     * Check for camera permission boolean.
     *
     * @param context the context
     * @return the boolean
     */
    boolean checkForCameraPermission(Context context) {
        return context.checkCallingOrSelfPermission(Manifest.permission.CAMERA)
                == PackageManager.PERMISSION_GRANTED;
    }

    /**
     * Check if the device has a Flash as hardware or not
     *
     * @param context the context
     * @return the boolean
     */
    boolean checkIfCameraFeatureExists(Context context) {
        return context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH);
    }

    /**
     * Is marshmallow and above boolean.
     *
     * @return the boolean
     */
    static boolean isMarshmallowAndAbove() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M;
    }
}

/**
 * The type Pre marshmallow.
 */
@SuppressWarnings("deprecation")
class PreMarshmallow implements FlashController {

    private Camera camera;

    @Override
    public void off() {
        try {
            if (camera != null) {
                Camera.Parameters p = camera.getParameters();
                p.setFlashMode(Camera.Parameters.FLASH_MODE_OFF);
                camera.setParameters(p);
                camera.stopPreview();
                camera.release();
                camera = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public void on() {
        try {
            off();
            if (camera == null) {
                try {
                    camera = Camera.open(getCameraId());
                } catch (RuntimeException ex) {
                    System.out.println("Runtime error while opening camera!");
                }
            }
            if (camera != null) {
                Camera.Parameters params = camera.getParameters();
                params.setFlashMode(Camera.Parameters.FLASH_MODE_TORCH);
                camera.setParameters(params);
                camera.startPreview();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private int getCameraId() {
        int numberOfCameras = Camera.getNumberOfCameras();
        for (int i = 0; i < numberOfCameras; i++) {
            CameraInfo info = new CameraInfo();
            Camera.getCameraInfo(i, info);
            if (info.facing == CameraInfo.CAMERA_FACING_BACK) {
                return i;
            }
        }
        return 0;
    }
}

class PostMarshmallow implements FlashController {

    private String cameraId;

    private final CameraManager cameraManager;

    @TargetApi(VERSION_CODES.LOLLIPOP)
    PostMarshmallow(Context context) {
        cameraManager = (CameraManager) context.getSystemService(Context.CAMERA_SERVICE);
        try {

            if (cameraManager != null) {
                cameraId = cameraManager.getCameraIdList()[0];
            }

        } catch (CameraAccessException e) {
            e.printStackTrace();
        }
    }

    @TargetApi(VERSION_CODES.M)
    @Override
    public void off() {
        try {
            if (cameraManager != null) {
                cameraManager.setTorchMode(cameraId, false);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @TargetApi(VERSION_CODES.M)
    @Override
    public void on() {
        try {
            if (cameraManager != null) {
                cameraManager.setTorchMode(cameraId, true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}

class DisplayLightControllerImpl implements DisplayLightController {

    private WeakReference<Activity> activityWeakRef;

    public DisplayLightControllerImpl(final Activity activity) {
        this.activityWeakRef = new WeakReference<>(activity);
    }

    @Override
    public boolean checkSystemWritePermission() {
        boolean retVal = true;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            retVal = Settings.System.canWrite(activityWeakRef.get().getApplicationContext());
        }
        return retVal;
    }

    @Override
    public void cleanup() {
        this.activityWeakRef = null;
    }

    @Override
    public void disableAlwaysOnMode() {
        activityWeakRef.get().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }

    @Override
    public void disableAutoBrightMode() {
        disableFullBrightMode();
    }

    @Override
    public void disableFullBrightMode() {
        if (checkSystemWritePermission()) {
            Settings.System.putInt(activityWeakRef.get().getContentResolver(), Settings.System.SCREEN_BRIGHTNESS_MODE,
                    Settings.System.SCREEN_BRIGHTNESS_MODE_MANUAL);

            Window window = activityWeakRef.get().getWindow();
            WindowManager.LayoutParams layoutParams = window.getAttributes();
            layoutParams.screenBrightness = 10 / 100.0f;
            window.setAttributes(layoutParams);
        }
    }

    @Override
    public void enableAlwaysOnMode() {
        activityWeakRef.get().getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }

    @Override
    public void enableAutoBrightMode() {
        if (checkSystemWritePermission()) {
            Settings.System.putInt(activityWeakRef.get().getContentResolver(), Settings.System.SCREEN_BRIGHTNESS_MODE,
                    Settings.System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC);
        }

    }

    @Override
    public void enableFullBrightMode() {
        if (checkSystemWritePermission()) {
            Settings.System.putInt(activityWeakRef.get().getContentResolver(), Settings.System.SCREEN_BRIGHTNESS_MODE,
                    Settings.System.SCREEN_BRIGHTNESS_MODE_MANUAL);

            Window window = activityWeakRef.get().getWindow();
            WindowManager.LayoutParams layoutParams = window.getAttributes();
            layoutParams.screenBrightness = 100 / 100.0f;
            window.setAttributes(layoutParams);
        }

    }

    @Override
    public void requestSystemWritePermission() {
        // Request for permission if not yet granted
        if (!checkSystemWritePermission()) {
            if (Utils.isMarshmallowAndAbove()) {
                Intent intent = new Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS);
                intent.setData(Uri.parse("package:" + activityWeakRef.get().getPackageName()));
                activityWeakRef.get().startActivity(intent);
            }
        }
    }
}

class Lantern implements LifecycleObserver {

    private WeakReference<Activity> activityWeakRef;

    private final DisplayLightController displayLightController;

    private FlashController flashController;

    private final Handler handler;

    private boolean isFlashOn = false;

    private long pulseTime = 1000;

    private final Utils utils;

    private final Runnable pulseRunnable = new Runnable() {
        @Override
        public void run() {
            enableTorchMode(!isFlashOn);
            handler.postDelayed(pulseRunnable, pulseTime);
        }
    };


    public Lantern(Activity activity) {
        this.activityWeakRef = new WeakReference<>(activity);
        utils = new Utils();
        handler = new Handler();
        displayLightController = new DisplayLightControllerImpl(activity);
    }

    public Lantern alwaysOnDisplay(boolean enabled) {
        if (enabled) {
            displayLightController.enableAlwaysOnMode();
        } else {
            displayLightController.disableAlwaysOnMode();
        }
        return this;
    }

    public Lantern autoBright(boolean enabled) {
        if (enabled) {
            displayLightController.enableAutoBrightMode();
        } else {
            displayLightController.disableAutoBrightMode();
        }
        return this;
    }

    public Lantern checkAndRequestSystemPermission() {
        displayLightController.requestSystemWritePermission();
        return this;
    }

    @OnLifecycleEvent(Event.ON_DESTROY)
    public void cleanup() {
        handler.removeCallbacks(pulseRunnable);
        displayLightController.cleanup();
        this.activityWeakRef = null;
    }

    public Lantern enableTorchMode(boolean enabled) {
        if (activityWeakRef != null) {
            if (enabled) {
                if (!isFlashOn && utils.checkForCameraPermission(activityWeakRef.get().getApplicationContext())) {
                    flashController.on();
                    isFlashOn = true;
                }
            } else {
                if (isFlashOn && utils.checkForCameraPermission(activityWeakRef.get().getApplicationContext())) {
                    flashController.off();
                    isFlashOn = false;
                }
            }
        } else {
            flashController.off();
            isFlashOn = false;
        }
        return this;
    }

    public Lantern fullBrightDisplay(boolean enabled) {
        if (enabled) {
            displayLightController.enableFullBrightMode();
        } else {
            displayLightController.disableFullBrightMode();
        }
        return this;
    }

    @RequiresPermission(Manifest.permission.CAMERA)
    public boolean initTorch() {
        if (activityWeakRef != null) {
            if (utils.checkIfCameraFeatureExists(activityWeakRef.get()) && utils
                    .checkForCameraPermission(activityWeakRef.get())) {
                if (Utils.isMarshmallowAndAbove()) {
                    flashController = new PostMarshmallow(activityWeakRef.get());
                } else {
                    flashController = new PreMarshmallow();
                }
                return true;
            }
        }
        return false;
    }

    public Lantern observeLifecycle(LifecycleOwner lifecycleOwner) {
        // Subscribe to listening lifecycle
        lifecycleOwner.getLifecycle().addObserver(this);

        return this;
    }

    public Lantern pulse(boolean enabled) {
        if (enabled) {
            handler.postDelayed(pulseRunnable, pulseTime);
        } else {
            handler.removeCallbacks(pulseRunnable);
        }
        return this;
    }

    public Lantern withDelay(long time, final TimeUnit timeUnit) {
        this.pulseTime = TimeUnit.MILLISECONDS.convert(time, timeUnit);
        return this;
    }
}

/*Draft java code by "Lazarus Android Module Wizard" [4/13/2019 1:32:12]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref https://github.com/nisrulz/lantern

public class jcLantern extends Lantern {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    private boolean isLightOn = false;

    //private Lantern lantern;
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jcLantern(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       //this.observeLifecycle(_ctrls.activity); //(LifecycleOwner) //appcompat:1.1.0-alpha03
    }

    public void jFree() {
      //free local objects...
        this.cleanup();
    }

  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void LightOn() {
        if (InitTorch()) {
            this.alwaysOnDisplay(true)
                    .fullBrightDisplay(true)
                    .enableTorchMode(true)
                    .pulse(false);

            isLightOn = true;
        }
    }

    public void LightOn(boolean _pulse) {
        if (InitTorch()) {
            if (_pulse) {
                this.alwaysOnDisplay(true)
                        .fullBrightDisplay(true)
                        .enableTorchMode(true)
                        .pulse(true).withDelay(1, TimeUnit.SECONDS);
            } else {
                this.alwaysOnDisplay(true)
                        .fullBrightDisplay(true)
                        .enableTorchMode(true)
                        .pulse(false);
            }
            isLightOn = true;
        }
    }
    public void LightOff() {
        if (isLightOn) {
            this.alwaysOnDisplay(false)
                    .fullBrightDisplay(false)
                    .enableTorchMode(false).pulse(false);

            isLightOn = false;
        }
    }

    public boolean InitTorch() {
        boolean res;
        try {
           res = this.initTorch();
        }catch (SecurityException e) {
            res = false;
        }
        return res;
    }
}


