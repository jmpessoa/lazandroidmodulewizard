package org.lamw.appjcentersignaturepaddemo1;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.net.Uri;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

import com.github.gcacace.signaturepad.views.SignaturePad;

/*Draft java code by "Lazarus Android Module Wizard" [7/29/2019 16:56:25]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/

//ref.  https://github.com/gcacace/android-signaturepad

public class jcSignaturePad extends SignaturePad /*dummy*/ { //please, fix what GUI object will be extended!
 
    private long pascalObj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;
 
    private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!
 
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jcSignaturePad(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
 
       super(_ctrls.activity, null);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
 
       LAMWCommon = new jCommons(this,context,pascalObj);

       /*
       onClickListener = new OnClickListener(){
       public void onClick(View view){     // *.* is a mask to future parse...;
               if (enabled) {
                  controls.pOnClickGeneric(pascalObj); //JNI event onClick!
               }
            };
       };
       setOnClickListener(onClickListener);
       */

        this.setOnSignedListener(new SignaturePad.OnSignedListener() {
            @Override
            public void onStartSigning() {
                //Event triggered when the pad is touched
                //Log.i("SignaturePad", "pOnSignaturePadStartSigning");
                controls.pOnSignaturePadStartSigning(pascalObj);
            }

            @Override
            public void onSigned() {
                //Event triggered when the pad is signed
                //Log.i("SignaturePad", "pOnSignaturePadSigned");
                controls.pOnSignaturePadSigned(pascalObj);
            }

            @Override
            public void onClear() {
                //Event triggered when the pad is cleared
                //Log.i("SignaturePad", "pOnSignaturePadClear");
                controls.pOnSignaturePadClear(pascalObj);
            }
        });

    } //end constructor
 
    public void jFree() {
       //free local objects...
   	 setOnClickListener(null);
	 LAMWCommon.free();
    }
  
    public void SetViewParent(ViewGroup _viewgroup) {
	 LAMWCommon.setParent(_viewgroup);
    }
 
    public ViewGroup GetParent() {
       return LAMWCommon.getParent();
    }
 
    public void RemoveFromViewParent() {
   	 LAMWCommon.removeFromViewParent();
    }
 
    public View GetView() {
       return this;
    }
 
    public void SetLParamWidth(int _w) {
   	 LAMWCommon.setLParamWidth(_w);
    }
 
    public void SetLParamHeight(int _h) {
   	 LAMWCommon.setLParamHeight(_h);
    }
 
    public int GetLParamWidth() {
       return LAMWCommon.getLParamWidth();
    }
 
    public int GetLParamHeight() {
	 return  LAMWCommon.getLParamHeight();
    }
 
    public void SetLGravity(int _g) {
   	 LAMWCommon.setLGravity(_g);
    }
 
    public void SetLWeight(float _w) {
   	 LAMWCommon.setLWeight(_w);
    }
 
    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
       LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
    }
 
    public void AddLParamsAnchorRule(int _rule) {
	 LAMWCommon.addLParamsAnchorRule(_rule);
    }
 
    public void AddLParamsParentRule(int _rule) {
	 LAMWCommon.addLParamsParentRule(_rule);
    }
 
    public void SetLayoutAll(int _idAnchor) {
   	 LAMWCommon.setLayoutAll(_idAnchor);
    }
 
    public void ClearLayoutAll() {
	 LAMWCommon.clearLayoutAll();
    }
 
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    
    public File getAlbumStorageDir(String albumName) {
        // Get the directory for the user's public pictures directory.
        File file = new File(Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_PICTURES), albumName);
        if (!file.mkdirs()) {
            Log.e("SignaturePad", "Directory not created");
        }
        return file;
    }

    public void saveBitmapToJPG(Bitmap bitmap, File photo) throws IOException {
        Bitmap newBitmap = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(newBitmap);
        canvas.drawColor(Color.WHITE);
        canvas.drawBitmap(bitmap, 0, 0, null);
        OutputStream stream = new FileOutputStream(photo);
        newBitmap.compress(Bitmap.CompressFormat.JPEG, 80, stream);
        stream.close();
    }

    public boolean addJpgSignatureToGallery(Bitmap signature, String _fileName) {
        boolean result = false;
        try {
            File photo = new File(getAlbumStorageDir("SignaturePad"), _fileName+".jpg");
            saveBitmapToJPG(signature, photo);
            scanMediaFile(photo);
            result = true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean addJpgSignatureToGallery(Bitmap signature) {
        boolean result = false;
        try {
            File photo = new File(getAlbumStorageDir("SignaturePad"), String.format("Signature_%d.jpg", System.currentTimeMillis()));
            saveBitmapToJPG(signature, photo);
            scanMediaFile(photo);
            result = true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    private void scanMediaFile(File photo) {
        Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        Uri contentUri = Uri.fromFile(photo);
        mediaScanIntent.setData(contentUri);
        controls.activity.sendBroadcast(mediaScanIntent);
    }

    public boolean addSvgSignatureToGallery(String signatureSvg) {
        boolean result = false;
        try {
            File svgFile = new File(getAlbumStorageDir("SignaturePad"), String.format("Signature_%d.svg", System.currentTimeMillis()));
            OutputStream stream = new FileOutputStream(svgFile);
            OutputStreamWriter writer = new OutputStreamWriter(stream);
            writer.write(signatureSvg);
            writer.close();
            stream.flush();
            stream.close();
            scanMediaFile(svgFile);
            result = true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean addSvgSignatureToGallery(String signatureSvg,  String _fileName) {
        boolean result = false;
        try {
            File svgFile = new File(getAlbumStorageDir("SignaturePad"), _fileName + ".svg");
            OutputStream stream = new FileOutputStream(svgFile);
            OutputStreamWriter writer = new OutputStreamWriter(stream);
            writer.write(signatureSvg);
            writer.close();
            stream.flush();
            stream.close();
            scanMediaFile(svgFile);
            result = true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    public void SaveToGalleryJPG(String _fileName) {
        String extensionRemoved = _fileName.split("\\.")[0];
        Bitmap signatureBitmap = this.getSignatureBitmap();
        if (addJpgSignatureToGallery(signatureBitmap, extensionRemoved)) {
            //Toast.makeText(MainActivity.this, "Signature saved into the Gallery", Toast.LENGTH_SHORT).show();
        } else {
            //Toast.makeText(MainActivity.this, "Unable to store the signature", Toast.LENGTH_SHORT).show();
        }

        if (addSvgSignatureToGallery(this.getSignatureSvg(), extensionRemoved)) {
            //Toast.makeText(MainActivity.this, "SVG Signature saved into the Gallery", Toast.LENGTH_SHORT).show();
        } else {
            //Toast.makeText(MainActivity.this, "Unable to store the SVG signature", Toast.LENGTH_SHORT).show();
        }
    }

    public void SaveToGalleryJPG() {
        Bitmap signatureBitmap = this.getSignatureBitmap();
        if (addJpgSignatureToGallery(signatureBitmap)) {
            //Toast.makeText(MainActivity.this, "Signature saved into the Gallery", Toast.LENGTH_SHORT).show();
        } else {
            //Toast.makeText(MainActivity.this, "Unable to store the signature", Toast.LENGTH_SHORT).show();
        }
        if (addSvgSignatureToGallery(this.getSignatureSvg())) {
            //Toast.makeText(MainActivity.this, "SVG Signature saved into the Gallery", Toast.LENGTH_SHORT).show();
        } else {
            //Toast.makeText(MainActivity.this, "Unable to store the SVG signature", Toast.LENGTH_SHORT).show();
        }
    }

    public void Clear() {
        this.clear();
    }

    public void SetPenColor(int _color) {  // (default: Color.BLACK).
        this.setPenColor(_color);
    }

    public void SetMinPenStrokeWidth(float _minWidth) {  //(default: 3dp).
        this.setMinWidth(_minWidth);
    }

    public void SetMaxPenStrokeWidth(float _maxWidth) {  //(default: 7dp).
        this.setMaxWidth(_maxWidth);
    }

    public void SetVelocityFilterWeight(float _velocityFilterWeight) {  //(default: 0.9).
        this.setVelocityFilterWeight(_velocityFilterWeight);
    }

    public Bitmap GetSignatureBitmap() {
       return  this.getSignatureBitmap(); // - A signature bitmap with a white background.
    }

    public Bitmap GetTransparentSignatureBitmap() {
        return this.getTransparentSignatureBitmap(); //- A signature bitmap with a transparent background.
    }

    public String GetSignatureSVG() {
        return this.getSignatureSvg(); // - A signature Scalable Vector Graphics document.
    }

    public void SaveToFileJPG(String _path, String _fileName) throws IOException {
        String extensionRemoved = _fileName.split("\\.")[0];
        Bitmap bitmap = this.getTransparentSignatureBitmap();//this.getSignatureBitmap();
        Bitmap newBitmap = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(newBitmap);
        canvas.drawColor(Color.TRANSPARENT); //Color.WHITE
        canvas.drawBitmap(bitmap, 0, 0, null);
        File photo = new File(_path, extensionRemoved+".jpg");
        OutputStream stream = new FileOutputStream(photo);
        newBitmap.compress(Bitmap.CompressFormat.JPEG, 80, stream);
        stream.close();
    }

}
