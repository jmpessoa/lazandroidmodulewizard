package org.lamw.applibgdxsnake;

import android.content.Context;
import android.util.Log;

import com.badlogic.gdx.graphics.OrthographicCamera;
import com.badlogic.gdx.math.Vector2;
import com.badlogic.gdx.utils.viewport.FitViewport;
import com.badlogic.gdx.utils.viewport.Viewport;

/*Draft java code by "Lazarus Android Module Wizard" [9/22/2019 18:49:13]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jGdxViewport /*extends ..*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    MyGdxGame myGame;
    Viewport viewport = null;
  
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jGdxViewport(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
       myGame = (MyGdxGame) controls.GDXGame;
    }
  
    public void jFree() {
      //free local objects..
        viewport = null;
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    //GetFitViewport
    public FitViewport FitViewport(int _width, int _height, OrthographicCamera _camera) {
       if (viewport == null) {
           if (_camera != null) {
               viewport = new FitViewport(_width, _height, (OrthographicCamera) _camera);
           }
       }
       return (FitViewport)viewport;
    }

    public void Apply() {  //set camera.viewportWidth and  camera.viewportHeigth
        if (viewport != null)
            viewport.apply();
    }

    public void Update(int _width, int _height) {
        if (viewport != null) viewport.update(_width, _height);
    }

    public void Unproject(float _x, float _y) {
        Vector2 touch = new Vector2();
        touch.x = _x;
        touch.y = _y;
        if (viewport != null)
          viewport.unproject(touch);
    }

}
