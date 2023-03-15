package org.lamw.appjcenterzxingbarcodescandemo1;
 
import android.content.Context;
import android.content.Intent;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

/*Draft java code by "Lazarus Android Module Wizard" [3/12/2023 20:22:45]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
public class jcZXingBarcodeScan /*extends ...*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    // public static final int REQUEST_CODE = 49374; // IntentIntegrator.REQUEST_CODE

    String mPrompt = "Scanning...";
    int mCameraId = 0;
    boolean mBeepEnabled = false;
    //boolean mImageEnabled = true;
    boolean mOrientationLocked = false;
    int mRequestCode = IntentIntegrator.REQUEST_CODE;
    int mBarcodeFormat =  10; //QR_CODE

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jcZXingBarcodeScan(Controls _ctrls, long _self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _self;
       controls  = _ctrls;
    }
  
    public void jFree() {
      //free local objects...
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    private String GetCodeAsString(int barcodeFormat) {
        String code = IntentIntegrator.QR_CODE;
        switch (barcodeFormat) {
            case 0: code = IntentIntegrator.UPC_A; break;
            case 1: code = IntentIntegrator.UPC_E; break;
            case 2: code = IntentIntegrator.EAN_8; break;
            case 3: code = IntentIntegrator.EAN_13; break;
            case 4: code = IntentIntegrator.RSS_14; break;
            case 5: code = IntentIntegrator.CODE_39; break;
            case 6: code = IntentIntegrator.CODE_93; break;
            case 7: code = IntentIntegrator.CODE_128; break;
            case 8: code = IntentIntegrator.ITF; break;
            case 9: code = IntentIntegrator.RSS_EXPANDED; break;
            case 10: code = IntentIntegrator.QR_CODE; break;
            case 11: code = IntentIntegrator.DATA_MATRIX; break;
            case 12: code = IntentIntegrator.PDF_417; break;
        }
        return code;
    }

    public void ScanForResult(int _barcodeFormat, int _requestCodeForResult) {
        mRequestCode = _requestCodeForResult;
        mBarcodeFormat = _barcodeFormat;
        String code = IntentIntegrator.QR_CODE;
        IntentIntegrator scanner = new IntentIntegrator(controls.activity); //the current Activity
        scanner.setPrompt(mPrompt);
        scanner.setOrientationLocked(mOrientationLocked);
        scanner.setDesiredBarcodeFormats(GetCodeAsString(mBarcodeFormat));
        scanner.setBeepEnabled(mBeepEnabled);
        scanner.setCameraId(mCameraId);
        scanner.setRequestCode(mRequestCode);
        scanner.initiateScan();
    }

    public String GetContentFromResult(int _requestCode, int _resultCode, Intent _intentData) {
        String res = "Cancelled";
        IntentResult intentResult = IntentIntegrator.parseActivityResult(_requestCode, _resultCode, _intentData);
        // if the intentResult is null then
        // toast a message as "cancelled"
        if (intentResult != null) {
            if (intentResult.getContents() == null) {
                //Toast.makeText(getBaseContext(), "Cancelled", Toast.LENGTH_SHORT).show();
                res = "Cancelled";
            } else {
                // if the intentResult is not null we'll set
                // the content and format of scan message
                res =  intentResult.getContents(); //intentResult.getFormatName() + ":" +
                //messageFormat.setText(intentResult.getFormatName());
            }
        }
        return res;
    }

    public void SetPrompt(String _msg) {
        mPrompt = _msg;
    }

    public void SetCameraId(int _id) {
        mCameraId = _id;
    }

    public void SetBeepEnabled(boolean  _value) {
        mBeepEnabled = _value;
    }

    /*
    public void SetImageEnabled(boolean  _value) {
        ImageEnabled = _value;
    }*/

    public void SetOrientationLocked(boolean  _value) {
        mOrientationLocked = _value;
    }

    public void SetBarcodeFormat(int _barcodeFormat) {
        mBarcodeFormat = _barcodeFormat;
    }

    public void SetRequestCodeForResult(int _requestCode) {
        mRequestCode = _requestCode;
    }

}
