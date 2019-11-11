package org.lamw.applibgdxdemo2;

//relational: jGdxScreen.java
import android.util.Log;

import com.badlogic.gdx.Game;
import com.badlogic.gdx.Screen;
import com.badlogic.gdx.utils.TimeUtils;
/*
 "extend Game" so we can support multiple screens.
 */
public class MyGdxGame extends Game {

	private Controls controls  = null; //Java/Pascal [events] Interface ...

	public long renderCount; //** render count **//
	public long startTime = 0; //** time app started **//
	public long currentTime = 0; //** time app started **//
	public long runningTime = 0;
	public long endTime = 0; //** time app ended **//

	public MyGdxGame(Controls _ctrls/*, long _Self*/) { //Add more others news "_xxx" params if needed!
		controls  = _ctrls;
	}

	public void jFree() {
		//free local objects...
	}

	/*
One thing that's very important to realize when working with LibGDX,
is that you cannot instantiate most LibGDX classes outside of the create() method.

So the only only safe place we have to instantiate LibGDX objects is in the create method.
 */
	@Override
	public void create () {
		Log.i("MYGAME", "create");
		startTime = TimeUtils.millis();
	}

	/*
	We next need to add super.render() in the Main render() method,
	which needs to be done now we're extending Game,
	not ApplicationAdapter. Make it the first thing in the render() method.
    Next, we don't actually need to draw anything in the Main class, since this will all happen in the GameScreen class. Because of this, delete everything in the Main render() method except super.render():
	 */

	@Override
	public void render () {
		super.render();
		renderCount++; //** another render - inc count **//
		currentTime = TimeUtils.millis();
		runningTime = (currentTime-startTime)/1000;
	}

	@Override
	public void resize(int width, int height) {
       super.resize(width, height);
	}

	@Override
	public void setScreen(Screen screen) {
		super.setScreen(screen);
	}

	public MyGdxGame() {
		super();
		Log.i("MYGAME", "MyGdxGame");
	}

	@Override
	public void dispose () {
		super.dispose();
		Log.i("MYGAME", "dispose");
		endTime = TimeUtils.millis();
		runningTime = (endTime-startTime)/1000;
	}

    @Override
    public void pause() {
		Log.i("MYGAME", "pause");
        super.pause();
    }

    @Override
	public void resume() {
		Log.i("MYGAME", "resume");
		super.resume();
	}

}
