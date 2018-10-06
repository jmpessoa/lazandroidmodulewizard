package com.example.appcamerademo;

/*Draft java code by "Lazarus Android Module Wizard" [8/20/2018 18:16:30]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;

import java.io.File;

public class jCamera /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context context   = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jCamera(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;
    }

    public void jFree() {
        //free local objects...
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void takePhoto(String filename) {  //HINT: filename = App.Path.DCIM + '/test.jpg
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        Uri mImageCaptureUri = Uri.fromFile(new File("", filename));
        intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, mImageCaptureUri);
        intent.putExtra("return-data", true);
        controls.activity.startActivityForResult(intent, 12345);
    }
    /*
     * NOTE: The DCIM folder on the microSD card in your Android device is where Android stores the photos and videos
     * you take with the device's built-in camera. When you open the Android Gallery app,
     * you are browsing the files saved in the DCIM folder....
     */
    public String jCamera_takePhoto(String path, String filename) {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        Uri mImageCaptureUri = Uri.fromFile(new File(path, '/'+filename)); // get Android.Uri from file
        intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, mImageCaptureUri);
        intent.putExtra("return-data", true);
        controls.activity.startActivityForResult(intent, 12345); //12345 = requestCode
        return (path+'/'+filename);
    }

    public String jCamera_takePhoto(String path, String filename, int requestCode) {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        Uri mImageCaptureUri = Uri.fromFile(new File(path, '/'+filename)); // get Android.Uri from file
        intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT, mImageCaptureUri);
        intent.putExtra("return-data", true);
        controls.activity.startActivityForResult(intent, requestCode); //12345 = requestCode
        return (path+'/'+filename);
    }

}