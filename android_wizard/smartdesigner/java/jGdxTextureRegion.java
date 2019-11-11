package org.lamw.applibgdxdemo2;

import android.content.Context;
import com.badlogic.gdx.graphics.g2d.TextureAtlas;
import com.badlogic.gdx.graphics.g2d.TextureRegion;
import com.badlogic.gdx.utils.Array;
import java.util.HashMap;

/*Draft java code by "Lazarus Android Module Wizard" [10/15/2019 2:21:53]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jGdxTextureRegion /*extends ..*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    private TextureRegion r;
    private HashMap<String, TextureRegion> regions = new HashMap<String, TextureRegion>();

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jGdxTextureRegion(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }
  
    public void jFree() {
      //free local objects...
        //regions.clear();
        if (regions != null)
            regions.clear();

    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  public void SetTexture(TextureAtlas _textureAtlas, String _region) {
      if (_textureAtlas == null) return;
      r = _textureAtlas.findRegion(_region);
  }

    public TextureRegion FindRegion(TextureAtlas _textureAtlas, String _region) {

        if (_textureAtlas == null) return null;

         r = _textureAtlas.findRegion(_region);
         return r;
    }

  public TextureRegion GetJInstance() {
        return r;
  }

    public void SetTextures(TextureAtlas _textureAtlas) {

        if (_textureAtlas == null) return;

        Array<TextureAtlas.AtlasRegion> regionsArray = _textureAtlas.getRegions();
        for (TextureAtlas.AtlasRegion r : regionsArray) {
            regions.put(r.name, (TextureRegion)r);
        }
    }
    public TextureRegion GetRegion(String _region) {
        if (regions.isEmpty()) return null;
        TextureRegion r = regions.get(_region);
        return r;
    }

    public void Dispose() {
        if (regions != null)
          regions.clear();
    }

}
