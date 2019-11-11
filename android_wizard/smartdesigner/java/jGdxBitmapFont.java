package org.lamw.applibgdxdemo1;

import android.content.Context;
import android.util.Log;

import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;

/*Draft java code by "Lazarus Android Module Wizard" [9/5/2019 12:37:10]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jGdxBitmapFont /*extends ..*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;
    MyGdxGame myGame;
    private BitmapFont font = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jGdxBitmapFont(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
        myGame = (MyGdxGame) controls.GDXGame;
        //font = new BitmapFont(); // no parameters - thus default 15-pt Arial
    }

    public void jFree() {
        //free local objects...
        Log.i("GdxBitmapFont", "jFree");
        if (font != null) font.dispose();
        font = null;
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public void SetColor(float _red, float _green, float _blue, float _alpha) {
        if (font == null) font = new BitmapFont();
          font.setColor(_red, _green, _blue, _alpha); //0.0f, 0.0f, 1.0f, 1.0f blue font
    }

    /*
    public void SetColor(int _color) {
        font.setColor(_color);
    }
    */

    public void SetScaleXY(float _scaleXY) {
        if (font == null) font = new BitmapFont();
        font.getData().setScale(_scaleXY);
    }

    public void Scale(float _amount) {
        if (font == null) font = new BitmapFont();
        font.getData().scale(_amount);
    }

    //import com.badlogic.gdx.graphics.g2d.SpriteBatch;
    public void DrawText(SpriteBatch _batch, String _text, float _x, float _y) {
        if (font == null) font = new BitmapFont();
          font.draw(_batch, (CharSequence) _text,_x, _y); //w/2-180, h/2+50 Draw the Hello World text
    }

    public void Dispose() {
        Log.i("jGdxBitmapFont", "Dispose");
        if (font != null)
           font.dispose();

        font = null;
    }
  
}
