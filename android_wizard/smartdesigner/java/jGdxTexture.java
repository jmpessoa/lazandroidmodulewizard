package org.lamw.applibgdxdemo1;

import android.util.Log;

import com.badlogic.gdx.graphics.Texture;

/*Draft java code by "Lazarus Android Module Wizard" [9/3/2019 1:37:55]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jGdxTexture {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...

    MyGdxGame myGame;

    Texture t = null;
  
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jGdxTexture(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       pascalObj = _Self;
       controls  = _ctrls;
       myGame = (MyGdxGame)controls.GDXGame;
    }
  
    public void jFree() {
      //free local objects...
        Log.i("GdxTexture", "jFree");
        if (t != null)  t.dispose();

        t = null;
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  public Texture GetNew(String _internalPath) {
      if (t != null) t.dispose();
      t = new Texture(_internalPath);
      return  t;//"badlogic.jpg"
  }

    public Texture GetJInstance(String _internalPath) {
        if (t == null) t = new Texture(_internalPath);
        return  t;//"badlogic.jpg"
    }

    public Texture GetJInstance() {
        return  t;//"badlogic.jpg"
    }

    public Texture LoadFromAssets(String _assetsPath) {
        //if (t != null) t.dispose();

        if (t == null)
          t = new Texture(_assetsPath);

        return  t;//"badlogic.jpg"
    }

    public void Dispose() {
        Log.i("jGdxTexture", "Dispose");
        if (t != null) t.dispose();
        t = null;
    }

}
