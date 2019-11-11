package org.lamw.applibgdxsnake;

import android.content.Context;
import android.util.Log;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer;
import com.badlogic.gdx.math.Matrix4;

/*Draft java code by "Lazarus Android Module Wizard" [9/22/2019 18:54:42]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jGdxShapeRenderer /*extends ..*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;

    MyGdxGame myGame;
    private ShapeRenderer shapeRenderer = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jGdxShapeRenderer(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
        myGame = (MyGdxGame) controls.GDXGame;
    }

    public void jFree() {
        //free local objects...
        if (shapeRenderer != null) {
            shapeRenderer.dispose();
            shapeRenderer = null;
        }
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public ShapeRenderer Get() {
        if (shapeRenderer == null) shapeRenderer = new ShapeRenderer();
        return shapeRenderer;
    }

    public void SetProjectionMatrix(Matrix4 _matrix4) { //OrthographicCamera _camera
        if (shapeRenderer == null) shapeRenderer = new ShapeRenderer();

        shapeRenderer.setProjectionMatrix(_matrix4);  //_camera.combined
     }

    public void BeginDraw(int _shapeType) {
        if (shapeRenderer == null) shapeRenderer = new ShapeRenderer();
        switch (_shapeType) {
            case 0: {
                shapeRenderer.begin(ShapeRenderer.ShapeType.Filled);break;
            }
        }
    }

    public void EndDraw() {
        if (shapeRenderer != null) shapeRenderer.end();
    }

    public void SetColor(int _red, int _green, int _blue, int _alpha) {
        if (shapeRenderer != null) {
            shapeRenderer.setColor(_red, _green, _blue, _alpha);
        }
    }

    public void Rect(float _x, float _y, int _width, int _height) {

        if (shapeRenderer != null) {
            shapeRenderer.rect(_x, _y, _width, _height);
            //Log.i("TAGR", "_x = " + _x);
            //Log.i("TAGR", "_y = " + _y);
            //Log.i("TAGR", "_width = " + _width);
            //Log.i("TAGR", "_height = " + _height);
        }
    }

    public void Dispose() {
        if (shapeRenderer != null) {
            shapeRenderer.dispose();
            shapeRenderer = null;
        }
    }
}
