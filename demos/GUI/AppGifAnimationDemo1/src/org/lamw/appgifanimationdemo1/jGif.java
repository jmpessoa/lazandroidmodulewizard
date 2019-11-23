package org.lamw.appgifanimationdemo1;

import android.content.Context;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import android.content.res.Resources;
import android.graphics.drawable.AnimationDrawable;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;

/**
 * Copyright (C) 2013 Orthogonal Labs, Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Creates an AnimationDrawable from a GIF image.
 *
 * @author Femi Omojola <femi@hipmob.com>
 *
 * Ref.
 * https://android-arsenal.com/details/1/1604
 */

class GifAnimationDrawable extends AnimationDrawable {
    private boolean decoded;

    private GifDecoder mGifDecoder;

    private Bitmap mTmpBitmap;

    private int height, width;

    public GifAnimationDrawable(File f) throws IOException
    {
        this(f, false);
    }

    public GifAnimationDrawable(InputStream is) throws IOException
    {
        this(is, false);
    }

    public GifAnimationDrawable(File f, boolean inline) throws IOException
    {
        this(new BufferedInputStream(new FileInputStream(f), 32768), inline);
    }

    public GifAnimationDrawable(InputStream is, boolean inline) throws IOException
    {
        super();
        InputStream bis = is;
        if(!BufferedInputStream.class.isInstance(bis)) bis = new BufferedInputStream(is, 32768);
        decoded = false;
        mGifDecoder = new GifDecoder();
        mGifDecoder.read(bis);
        mTmpBitmap = mGifDecoder.getFrame(0);
        height = mTmpBitmap.getHeight();
        width = mTmpBitmap.getWidth();
        android.util.Log.v("GifAnimationDrawable", "===>Lead frame: ["+width+"x"+height+"; "+mGifDecoder.getDelay(0)+";"+mGifDecoder.getLoopCount()+"]");
        addFrame(new BitmapDrawable(mTmpBitmap), mGifDecoder.getDelay(0));
        setOneShot(mGifDecoder.getLoopCount() != 0);
        setVisible(true, true);
        if(inline){
            loader.run();
        }else{
            new Thread(loader).start();
        }
    }

    public boolean isDecoded(){ return decoded; }

    private Runnable loader = new Runnable(){
        public void run()
        {
            mGifDecoder.complete();
            int i, n = mGifDecoder.getFrameCount(), t;
            for(i=1;i<n;i++){
                mTmpBitmap = mGifDecoder.getFrame(i);
                t = mGifDecoder.getDelay(i);
                android.util.Log.v("GifAnimationDrawable", "===>Frame "+i+": "+t+"]");
                addFrame(new BitmapDrawable(mTmpBitmap), t);
            }
            decoded = true;
            mGifDecoder = null;
        }
    };

    public int getMinimumHeight(){ return height; }
    public int getMinimumWidth(){ return width; }
    public int getIntrinsicHeight(){ return height; }
    public int getIntrinsicWidth(){ return width; }
}

/*Draft java code by "Lazarus Android Module Wizard" [11/19/2019 21:11:35]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

public class jGif {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    private boolean inline = false;
    private boolean oneShot = true;

    GifAnimationDrawable gif = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jGif(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }

    public void jFree() {
        //free local objects...
        gif = null;
    }


    public AnimationDrawable LoadFromRawResource(String _gifImageIdentifier) { //TODO Pascal
        //get the application's resources
        Resources resources = controls.activity.getResources();
        String packName = controls.activity.getPackageName();
        //http://www.41post.com/3985/programming/android-loading-files-from-the-assets-and-raw-folders
        int id = resources.getIdentifier(packName+":raw/"+_gifImageIdentifier, null, null);
        InputStream bis = resources.openRawResource(id);
        try {
            gif = new GifAnimationDrawable(bis, inline);
        } catch (IOException e) {
            e.printStackTrace();
        }
        gif.setOneShot(oneShot);
        return gif;
    }

    public AnimationDrawable LoadFromAssets(String _gifFilename) { //new GifAnimationDrawable(getResources().openRawResource(R.raw.anim1));
        //get the application's resources
        Resources resources = controls.activity.getResources();
        InputStream bis = null;
        try {
            bis = resources.getAssets().open(_gifFilename);
        } catch (IOException e) {
            e.printStackTrace();
        }

        try {
            gif = new GifAnimationDrawable(bis, inline);
        } catch (IOException e) {
            e.printStackTrace();
        }
        gif.setOneShot(false); //oneShot
        gif.setVisible(true, true);
        return gif;
    }

    public AnimationDrawable LoadFromFile(String _path, String _gifFilename) {
        try {
            File f = new File(_path+ "/" + _gifFilename);
            gif = new GifAnimationDrawable(f, inline);
        } catch (IOException e) {
            e.printStackTrace();
        }
        gif.setOneShot(oneShot);
        return gif;
    }

    public void Start() {
        if (gif == null) return;
        gif.stop();
        gif.setOneShot(false);
        gif.setVisible(true, true);
        gif.start();
    }

    public void Stop() {
        if (gif == null) return;
        //gif.setVisible(false, false);
        //gif.setOneShot(true);
        gif.stop();
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
}

