package org.lamw.applibgdxdemo2;

import android.content.Context;
import android.util.Log;

import com.badlogic.gdx.graphics.g2d.TextureAtlas;
import com.badlogic.gdx.graphics.g2d.TextureRegion;
import com.badlogic.gdx.graphics.g2d.Sprite;
import com.badlogic.gdx.utils.Array;
import java.util.HashMap;

/*Draft java code by "Lazarus Android Module Wizard" [10/15/2019 2:21:53]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jGdxTextureAtlas /*extends ..*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    private TextureAtlas a;
    //private  HashMap<String, Sprite> sprites = new HashMap<String, Sprite>();

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jGdxTextureAtlas(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }
  
    public void jFree() {
      //free local objects...
        if(a != null) a.dispose();
        a = null;
        Log.i("jGdxTextureAtlas", "jFree");
       // if(a != null) a.dispose();
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    /*
    private void addSprites() {
        Array<TextureAtlas.AtlasRegion> regions = a.getRegions();
        for (TextureAtlas.AtlasRegion region : regions) {
            Sprite sprite = a.createSprite(region.name);
            sprites.put(region.name, sprite);
        }
    }
    */

    public void LoadPackFromAssets(String _packFilename) {
        Log.i("GDXATLAS", "before LoadPackFromAssets");
        if (a == null)
           a = new TextureAtlas(_packFilename); //circles.pack
  }

  public TextureRegion GetTextureRegion(String _region) {
      if (a == null) return null;
      else return a.findRegion(_region);
  }

  public TextureAtlas GetJInstance() {
        return a;
  }

  public Sprite CreateSprite(String _region) {
      if (a == null) return null;
      else  return a.createSprite(_region);
  }

  /*
    public Sprite GetSprite(String _region) {
        Sprite sprite = sprites.get(_region);
        //sprite.setPosition(_x, _y);
        sprite.setOrigin(0,0);
        return sprite;
        //sprite.draw(batch);
    }
    */

    /*
    public Sprite GetSprite(String _region, float _posX, float _posY, float _degrees) {
        Sprite sprite = sprites.get(_region);
        sprite.setPosition(_posX, _posY);
        sprite.setRotation(_degrees);
        //sprite.setOrigin(0,0);
        return sprite;
        //sprite.draw(batch);
    }
    */

    public void Dispose() {
        Log.i("GDXATLAS", "Dispose");
      if(a != null) a.dispose();

      a = null;
    }

}
