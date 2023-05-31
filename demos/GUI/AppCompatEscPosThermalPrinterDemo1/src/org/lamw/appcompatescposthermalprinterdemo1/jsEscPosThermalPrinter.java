package org.lamw.appcompatescposthermalprinterdemo1;
 
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.DisplayMetrics;

import com.dantsu.escposprinter.EscPosCharsetEncoding;
import com.dantsu.escposprinter.EscPosPrinter;
import com.dantsu.escposprinter.connection.DeviceConnection;
import com.dantsu.escposprinter.connection.bluetooth.BluetoothPrintersConnections;
import com.dantsu.escposprinter.exceptions.EscPosBarcodeException;
import com.dantsu.escposprinter.exceptions.EscPosConnectionException;
import com.dantsu.escposprinter.exceptions.EscPosEncodingException;
import com.dantsu.escposprinter.exceptions.EscPosParserException;
import com.dantsu.escposprinter.textparser.PrinterTextParserImg;

/*Draft java code by "Lazarus Android Module Wizard" [5/29/2023 16:02:18]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref
//https://github.com/DantSu/ESCPOS-ThermalPrinter-Android
public class jsEscPosThermalPrinter /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;

    EscPosPrinter mPrinter;

    EscPosCharsetEncoding mCharsetEncoding = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jsEscPosThermalPrinter(Controls _ctrls, long _self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _self;
        controls = _ctrls;
    }

    public void jFree() {
        //free local objects...
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void SetCharsetEncoding(String _charsetName, int _charsetId) {
        //Params:
        //charsetName – Name of charset encoding (Ex: windows-1252)
        //escPosCharsetId – Id of charset encoding for your printer (Ex: 16)
        //https://www.epson-biz.com/modules/ref_escpos/index.php?content_id=32
        mCharsetEncoding = new EscPosCharsetEncoding(_charsetName, _charsetId);// "windows-1252", 16
    }

    public boolean InitConnection(int _connectionType, int _printDpi, float _printWitdhMM, int _printNbrCharacterPerline) {  //+ EscPosCharsetEncoding charsetEncoding
        boolean r = true;
        EscPosPrinter printer = null;
        DeviceConnection deviceConnection = null;
        if (_connectionType == 0) {
            deviceConnection = BluetoothPrintersConnections.selectFirstPaired();
        }
        else {
            //TODO  USB, TCP, etc...
        }

        if (deviceConnection != null) {
            try {
                if (mCharsetEncoding == null)
                    mPrinter = new EscPosPrinter(deviceConnection,_printDpi,  _printWitdhMM, _printNbrCharacterPerline);//203, 48f, 32
                else
                    mPrinter = new EscPosPrinter(deviceConnection,_printDpi,  _printWitdhMM, _printNbrCharacterPerline, mCharsetEncoding);//203, 48f, 32
            } catch (EscPosConnectionException e) {
                r = false;
                e.printStackTrace();
            }
        }
        else {
            r = false;
        }
        return r;
    }

    /*
    public boolean Ini(int _connectionType) {
        return Init(_connectionType, 203, 48f, 32);
    }
    */

    public String ImageToHexadecimalString(String _imageIdentifier) {
        String s="";
        int id = controls.GetDrawableResourceId(_imageIdentifier);
        Drawable logo = controls.activity.getApplicationContext().getResources().getDrawableForDensity(id, DisplayMetrics.DENSITY_MEDIUM);
        if (mPrinter != null) {
           s = PrinterTextParserImg.bitmapToHexadecimalString(mPrinter, logo);
        }
        return s;
    }

    public void PrintFormattedText(String _formattedText) {
      if (mPrinter != null) {
          try {
              mPrinter.printFormattedText(_formattedText);
          } catch (EscPosConnectionException e) {
              e.printStackTrace();
          } catch (EscPosParserException e) {
              e.printStackTrace();
          } catch (EscPosEncodingException e) {
              e.printStackTrace();
          } catch (EscPosBarcodeException e) {
              e.printStackTrace();
          }
      }
    }

}
