package org.lamw.applibgdxsnake;

import android.util.Log;

import com.badlogic.gdx.Input;
import com.badlogic.gdx.InputAdapter;
import com.badlogic.gdx.InputProcessor;
import com.badlogic.gdx.Screen;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.GL20;

/*Draft java code by "Lazarus Android Module Wizard" [9/3/2019 18:46:13]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jGdxForm implements Screen, InputProcessor {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...

    MyGdxGame myGame;
    int[] rgba;
    boolean clearOnRender = true;

    boolean IsStarting = false;
    boolean IsResizing = false;

    int w;
    int h;

    boolean isBackKeyPessed = false;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jGdxForm(Controls _ctrls, long _Self, boolean _active) { //Add more others news "_xxx" params if needed!
        pascalObj = _Self;
        controls = _ctrls;
        Log.i("GDXForm", "Create = " + pascalObj);
        myGame = (MyGdxGame) controls.GDXGame;
        if (_active) {
            Log.i("GDXForm", "Create/Show = " + pascalObj);
            myGame.setScreen(this); //it works!!!
            isBackKeyPessed = false;
        }
    }

    public void jFree() {
        //free local objects...
        IsStarting = true;
        Log.i("GDXForm", "jFree = " + pascalObj);
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    /*
    One thing that's very important to realize when working with LibGDX,
    is that you cannot instantiate most LibGDX classes outside of the create() method.

    So the only only safe place we have to instantiate LibGDX objects is in the create method.
     */
    public void SetAsGameScreen() {
        myGame.setScreen(this);
    }

    public void Show() {
        Log.i("GDXForm", "Show = " + pascalObj);
        IsStarting = true;
        isBackKeyPessed = false;
        myGame.setScreen(this);
    }

    /*
    Creating new instances at every render will definitely leak away the memory!
     Several hours to find the issue, only a minute to fix it!
     */

    @Override
    public void show() {   //1
        //controls.pOnGDXFormShow(pascalObj);
        Gdx.input.setInputProcessor(this);
        //Gdx.input.setCatchKey(Input.Keys.BACK, true);
        IsStarting = true;
        isBackKeyPessed = false;
    }

    @Override
    public void resize(int width, int height) {  //3
        if (width != 0) {
            IsResizing = true;
            w = width;
            h = height;
        }
    }

    /*
    The delta value supplied to your render method by the game engine is the time taken
    for the last frame to draw, or the time in between
    the last frame being drawn and this frame to start drawing.
    It is measured in seconds, and typical values of delta may be around 0.008s.
This is actually an incredibly useful, simple, smart way to make things move at the speed you want them to.
     */

    @Override
    public void render(float delta) {  //3
        //Log.i("TAGREND","delta = " + delta);

        if (IsStarting) {
            IsStarting = false;
            controls.pOnGDXFormShow(pascalObj);
        }
        if (IsResizing) {
            IsResizing = false;
            controls.pOnGDXFormResize(pascalObj, w, h);
        }
        /*
        if (Gdx.input.isTouched()) {
            //touch.x = Gdx.input.getX();
            //touch.y = Gdx.input.getY();
            //viewport.unproject(touch);
        }
        */
        //if (! isBackKeyPessed)
        controls.pOnGDXFormRender(pascalObj, delta);
    }

    @Override
    public void pause() {
        Log.i("GDXForm", "pause");
        isBackKeyPessed = false;
        IsStarting = true;
        controls.pOnGDXFormPause(pascalObj);
    }

    @Override
    public void resume() {
        Log.i("GDXForm", "resume");
        controls.pOnGDXFormResume(pascalObj);
        isBackKeyPessed = false;
        IsStarting = true;
    }

    @Override
    public void hide() {
        Log.i("GDXForm", "Hide = " + pascalObj);
        IsStarting = true;
        isBackKeyPessed = false;
        controls.pOnGDXFormHide(pascalObj);
    }

    @Override
    public void dispose() {
        Log.i("GDXForm", "dispose");
        IsStarting = true;
        isBackKeyPessed = false;
    }

    public int GetWidth() {
        return Gdx.graphics.getWidth(); // width of screen
    }

    public int GetHeight() {
        return Gdx.graphics.getHeight(); // height of screen
    }

    public void ClearColor(float _red, float _green, float _blue, float _alpha) {
        Gdx.gl.glClearColor(_red, _green, _blue, _alpha);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
    }

    public long GetGamePlayingSeconds() {
        return myGame.runningTime;   //game playing
    }

    public long GetGameRenderCount() {
        return myGame.renderCount;
    }

    public long GetGameStartTimeMilliSeconds() { //millis
        return myGame.startTime;  //** time app started **//
    }

    public long GetGameEndTimeMilliSeconds() {
        return myGame.endTime; //** time app ended **//
    }

    public long GetGameCurrentTimeMilliSeconds() {
        return myGame.currentTime; //** time app playing **//
    }

    @Override
    public boolean keyDown(int keycode) {
        Log.i("GDXForm", "keyDown = " + keycode);
        if (keycode == 4) isBackKeyPessed = true;
        if(keycode == Input.Keys.BACK){ //4
            //back button clicked
            isBackKeyPessed = true;
            int action = controls.pOnGDXFormKeyPressed(pascalObj, keycode);
            return true;
        }
        return false;
    }

    @Override
    public boolean keyUp(int keycode) {
        return false;
    }

    @Override
    public boolean keyTyped(char character) {
        return false;
    }

    @Override
    public boolean touchDown(int screenX, int screenY, int pointer, int button) {
        //Log.i("GDXForm", "touchDown");
        controls.pOnGDXFormTouchDown(pascalObj, screenX, screenY, pointer, button);
        return false;
    }

    @Override
    public boolean touchUp(int screenX, int screenY, int pointer, int button) {
        Log.i("GDXForm", "touchUp");
        controls.pOnGDXFormTouchUp(pascalObj, screenX, screenY, pointer, button);
        return false;
    }

    @Override
    public boolean touchDragged(int screenX, int screenY, int pointer) {
        return false;
    }

    @Override
    public boolean mouseMoved(int screenX, int screenY) {
        return false;
    }

    @Override
    public boolean scrolled(int amount) {
        return false;
    }

}

