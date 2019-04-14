package org.lamw.appcompatlanterndemo1;

//import android.arch.lifecycle.LifecycleOwner;
import android.content.Context;
import java.util.concurrent.TimeUnit;
import github.nisrulz.lantern.Lantern;

/*Draft java code by "Lazarus Android Module Wizard" [4/13/2019 1:32:12]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref https://github.com/nisrulz/lantern
public class jsLantern extends Lantern {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    private boolean isLightOn = false;

    //private Lantern lantern;
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jsLantern(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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

