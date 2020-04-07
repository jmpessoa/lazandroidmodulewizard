package org.lamw.applibgdxdemo1;


import android.content.Context;
import android.util.Log;

import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.TextureAtlas;
import com.badlogic.gdx.graphics.g2d.TextureRegion;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.math.Matrix4;

/*Draft java code by "Lazarus Android Module Wizard" [9/3/2019 1:07:28]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

public class jGdxSpriteBatch /*extends ..*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;

    MyGdxGame myGame;

    SpriteBatch b = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jGdxSpriteBatch(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
        myGame = (MyGdxGame) controls.GDXGame;
    }

    public void jFree() {
        //free local objects...
       // if (b != null)  b.dispose();
        Log.i("GdxSpriteBatch", "jFree");
        b = null;
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public SpriteBatch GetNew() {
        if (b != null) b.dispose();
        b = new SpriteBatch();
        return b;
    }

    public SpriteBatch GetJInstance() {
        if (b == null) b = new SpriteBatch();
        return b;
    }

    public void BeginBatch() {
        if (b == null) b = new SpriteBatch();
        b.begin();
    }

    public void DrawTexture(Texture _texture, float _x, float _y) {
        if (_texture == null) return;
        if (b != null)
            b.draw(_texture, _x, _y);
    }

    public void DrawTexture(Texture _texture, float _x, float _y, float _width, float _height) {
        if (_texture == null) return;
        if (b != null)
            b.draw(_texture, _x, _y, _width, _height);
    }

    public void DrawTexture(Texture _texture, float[] _spriteVertices, int _offset, int _count) {
        if (_texture == null) return;
        if (b != null)
            b.draw(_texture, _spriteVertices, _offset,_count);
    }

    public void DrawTextureRegion(TextureRegion _textureRegion,  float _x, float _y) {
        if (_textureRegion == null) return;
        if (b != null)
          b.draw(_textureRegion, _x, _y);
    }

    public void DrawTextureRegion(TextureAtlas _textureAtlas,String _region,  float _x, float _y) { //TODO Pascal
        if (_textureAtlas == null) return;
        if (b != null)
           b.draw(_textureAtlas.findRegion(_region), _x, _y);
    }

    public void EndBatch() {
        if (b != null) {
            b.end();
        }
    }

    //import com.badlogic.gdx.math.Matrix4;s
    public void SetProjectionMatrix(Matrix4 matrix4) {
        if (b == null) b = new SpriteBatch();
            b.setProjectionMatrix(matrix4); // Set Projection Matrix
    }

    public void Dispose() {
        Log.i("jGdxSpriteBatch", "Dispose");
        if(b != null) {
            //b.end();
            b.dispose();
            b = null;
        }
    }

}
