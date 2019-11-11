package org.lamw.applibgdxdemo2;

import android.content.Context;
import com.badlogic.gdx.graphics.g2d.Sprite;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.graphics.g2d.TextureAtlas;
import com.badlogic.gdx.utils.Array;
import java.util.HashMap;

/*Draft java code by "Lazarus Android Module Wizard" [10/16/2019 0:37:57]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jGdxSprite /*extends ..*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;

    private Sprite s;
    private HashMap<String, Sprite> sprites = new HashMap<String, Sprite>();

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jGdxSprite(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
    }

    public void jFree() {
        //free local objects...
        //sprites.clear();
        if (sprites != null)
            sprites.clear();
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public void SetSprite(Sprite _sprite) {
            s = _sprite;
    }

    public void SetSprite(Sprite _sprite,  float _scale) {
            s = _sprite;
            float width = s.getWidth() * _scale;
            float height = s.getHeight() * _scale;
            s.setSize(width, height);
    }

    public void Draw(SpriteBatch _batch, float _x, float _y) {
        if (_batch == null) return;
        if (s != null) {
            s.setPosition(_x, _y);
            s.draw(_batch);
        }
    }

    public void SetSprites(TextureAtlas _textureAtlas) {
        if (_textureAtlas == null) return;
        Array<TextureAtlas.AtlasRegion> regions = _textureAtlas.getRegions();
        if (sprites != null) sprites.clear();
        for( TextureAtlas.AtlasRegion region :regions) {
        Sprite sprite = _textureAtlas.createSprite(region.name);
          sprites.put(region.name, sprite);
       }
    }

    public void SetSprites(TextureAtlas _textureAtlas, float _scale) {
        Array<TextureAtlas.AtlasRegion> regions = _textureAtlas.getRegions();
        if (sprites != null) sprites.clear();
        for( TextureAtlas.AtlasRegion region :regions) {
            Sprite sprite = _textureAtlas.createSprite(region.name);
            float width = sprite.getWidth() * _scale;
            float height = sprite.getHeight() * _scale;
            sprite.setSize(width, height);
            sprites.put(region.name, sprite);
        }
    }

    public void Draw(SpriteBatch _batch, String _sprite, float _x, float _y) {
        if (_batch == null) return;
        if (sprites.isEmpty()) return;
        s  = sprites.get(_sprite);
        if ( s != null) {
            s.setPosition(_x, _y);
            s.draw(_batch);
        }
    }

    public void SetPosition(String _sprite, float _x, float _y) {
        if (sprites.isEmpty()) return;
        s = sprites.get(_sprite);
        if (s != null) {
            s.setPosition(_x, _y);
        }
    }

    public void SetPosition(float _x, float _y) {
        if (s != null)
            s.setPosition(_x, _y);
    }

    public void SetRotation(float _degrees) {
        if (s != null)
            s.setRotation(_degrees);
    }

    public void SetRotation(String _sprite, float _degrees) {
        if (sprites.isEmpty()) return;
        s = sprites.get(_sprite);
        if (s != null) {
            s.setRotation(_degrees);
        }
    }

    public void Translate(float _offsetX, float _offsetY) {
        if (s != null)
            s.translate(_offsetX, _offsetY);
    }

    public void Translate(String _sprite, float _offsetX, float _offsetY) {
        if (sprites.isEmpty()) return;
        s = sprites.get(_sprite);
        if (s != null) {
            s.translate(_offsetX, _offsetY);
        }
    }

    public void Rotate90(boolean _clockwise) {
        if (s != null)
            s.rotate90(_clockwise);
    }

    public void Rotate90(String _sprite, boolean _clockwise) {
        if (sprites.isEmpty()) return;
        s = sprites.get(_sprite);
        if (s != null) {
            s.rotate90(_clockwise);
        }
    }

    public void Rotate(float _degrees) {
        if (s != null)
            s.rotate(_degrees);
    }

    public void Rotate(String _sprite, float _degrees) {
        if (sprites.isEmpty()) return;
        s = sprites.get(_sprite);
        if (s != null) {
            s.rotate(_degrees);
        }
    }

    public void Dispose() {
        if (sprites != null)
           sprites.clear();
    }
}
