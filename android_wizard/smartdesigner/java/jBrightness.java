
import android.util.Log;
import android.view.WindowManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.provider.Settings;


/*Draft java code by "Lazarus Android Module Wizard" [30/05/2018 12:24:23]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

class jBrightness /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jBrightness(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;       
    }

    public float getBrightness(){
     return(this.controls.activity.getWindow().getAttributes().screenBrightness);
    }

    public boolean isBrightnessManual(){

     try {
                int brightnessMode = Settings.System.getInt(this.controls.activity.getContentResolver(),
                                                            Settings.System.SCREEN_BRIGHTNESS_MODE);

                return( Settings.System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC != brightnessMode);

            } catch (Settings.SettingNotFoundException e) {

            }

     return(true);
    }

    public void setBrightness( float _brightness ){

        WindowManager.LayoutParams layoutParams = this.controls.activity.getWindow().getAttributes();

        layoutParams.screenBrightness = _brightness;

        this.controls.activity.getWindow().setAttributes(layoutParams);
    }

    public void jFree() {
      //free local objects...
    }

} 