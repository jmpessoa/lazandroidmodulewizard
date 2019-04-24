package org.lamw.appcompatscreenshotdemo1;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.View;
import java.io.File;
import github.nisrulz.screenshott.ScreenShott;

/*Draft java code by "Lazarus Android Module Wizard" [4/14/2019 17:17:23]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref.  https://github.com/nisrulz
public class jcScreenShot  {

    private long pasobj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    Bitmap bitmap = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jcScreenShot(Controls _ctrls, long _Self) {
        //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity); //
       context   = _ctrls.activity;
       pasobj = _Self;
       controls  = _ctrls;
    }

    public void jFree() {
      //free local objects...
    }

  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   //(scRoot, scView, scPadding);
    /*.*/public Bitmap TakeView(View _view) {   //TODO
            bitmap = ScreenShott.getInstance().takeScreenShotOfJustView(_view);  //fail to ImageView!
            //bitmap = ScreenShott.getInstance().takeScreenShotOfView(_view); break;     //fail to ImageView!
        return bitmap;
    }

    public Bitmap TakeScene(View _referenceView) {
        bitmap = ScreenShott.getInstance().takeScreenShotOfRootView(_referenceView);
        return bitmap;
    }

    public String SaveToFile(String _fileName) {
        // Save the screenshot
        String path = "";
        if (bitmap == null) return "";
        try {
            File file = ScreenShott.getInstance().saveScreenshotToPicturesFolder(controls.activity, bitmap, _fileName);//"my_screenshot"
            path = file.getAbsolutePath();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return path;
    }

}



