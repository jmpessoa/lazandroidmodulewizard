package org.lamw.applibgdxdemo1;
import android.content.Context;
import android.util.Log;

import com.badlogic.gdx.graphics.OrthographicCamera;
import com.badlogic.gdx.math.Matrix4;

/*Draft java code by "Lazarus Android Module Wizard" [9/5/2019 12:21:17]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//http://libdgxtutorials.blogspot.com/2013/09/libgdx-tutorial-1-hello-world-hellogame.html
public class jGdxOrthographicCamera /*extends ..*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;

    MyGdxGame myGame;

    /*
    "OrthographicCamera is to be used in 2D environments only as it implements a parallel (orthographic)
    projection and there will be no scale factor for the final image regardless where
    the objects are placed in the world.
     */
    OrthographicCamera camera = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jGdxOrthographicCamera(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
        myGame = (MyGdxGame) controls.GDXGame;
        //camera = new OrthographicCamera(); // 2D camera
    }

    public void jFree() {
        //free local objects..
        Log.i("GdxOrthographicCamera", "jFree");

    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void SetToOrtho(boolean _yDown, float _viewportWidth, float _viewportHeight) {
        if (camera == null) camera = new OrthographicCamera(); // 2D camera
         camera.setToOrtho(_yDown,_viewportWidth,_viewportHeight); // y increases upwards, viewport = window
    }

    //import com.badlogic.gdx.math.Matrix4;
    public Matrix4 GetMatrix4Combined() {
        if (camera == null) camera = new OrthographicCamera(); // 2D camera
        return camera.combined; // Set Projection Matrix
    }

    public void Rotate (float _angle) {
        if (camera == null) camera = new OrthographicCamera(); // 2D camera
        camera.rotate(_angle);
    }

    public void Translate (float _x, float _y) {
        if (camera == null) camera = new OrthographicCamera(); // 2D camera
        camera.translate(_x, _y, 0);
    }

    public void Update() {
        if (camera == null) camera = new OrthographicCamera(); // 2D camera
        camera.update();
        //Log.i("TAG_CAMUPD","w = " + camera.viewportWidth);
        //Log.i("TAG_CAMUPD","h = " + camera.viewportHeight);
    }

    public OrthographicCamera GetJInstance() {
        if (camera == null) camera = new OrthographicCamera();
        return camera;
    }

    //https://www.gamefromscratch.com/post/2014/12/09/LibGDX-Tutorial-Part-17-Viewports.aspx
    public void SePosition(float _x, float _y) {
        //camera.position.set(camera.viewportWidth/2,camera.viewportHeight/2,0);
        camera.position.set(_x,_y,0);
    }

}
