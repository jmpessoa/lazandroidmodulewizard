package org.lamw.appbarcodegendemo1;

import android.content.Context;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.util.Log;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;

import java.util.Arrays;

/*Draft java code by "Lazarus Android Module Wizard" [7/25/2020 0:50:10]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref. https://stackoverflow.com/questions/22371626/android-generate-qr-code-and-barcode-using-zxing
public class jBarcodeGen /*extends ...*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;
  
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jBarcodeGen(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }
  
    public void jFree() {
      //free local objects...
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    /*

    CODABAR,
    CODE_39,
    CODE_93,
    CODE_128,
    EAN_8, EAN_13,
    ITF,
    RSS_14,
    RSS_EXPANDED,
    UPC_A,
    UPC_E,
    UPC_EAN_EXTENSION;

    AZTEC,
    MAXICODE,
    PDF_417,
    DATA_MATRIX,
    QR_CODE,

     */
    //note: QRCode, Data Matrix, Aztec, PDF 417 and MaxiCode all are 2D barcodes
    //UCC-128, EAN-128 or SSCC-18	shipping cartons
    //https://www.morovia.com/kb/Identify-Barcode-Format-10623.html

    //https://www.scandit.com/blog/types-of-barcodes-choosing-the-right-barcode-type-ean-upc-code128-itf-14-or-code39/

    public Bitmap Get128Bar(String _data, int _width, int _height) throws WriterException {
        MultiFormatWriter writer = new MultiFormatWriter();
        String finalData = Uri.encode(_data);

        // Use 1 as the height of the matrix as this is a 1D Barcode.
        BitMatrix bm = writer.encode(finalData, BarcodeFormat.CODE_128, _width, 1);
        int bmWidth = bm.getWidth();

        Bitmap imageBitmap = Bitmap.createBitmap(bmWidth, _height, Bitmap.Config.ARGB_8888);

        for (int i = 0; i < bmWidth; i++) {
            // Paint columns of width 1
            int[] column = new int[_height];
            Arrays.fill(column, bm.get(i, 0) ? Color.BLACK : Color.WHITE);
            imageBitmap.setPixels(column, 0, 1, i, 0, 1, _height);
        }
        return imageBitmap;
    }

    /*
    CODE_128,
    EAN_8,
    EAN_13,
    ITF,
    UPC_A,
    UPC_E,
    CODE_39,

    AZTEC,
    MAXICODE,
    PDF_417,
    DATA_MATRIX,
    QR_CODE,
     */

    //ref. https://stackoverflow.com/questions/1136642/ean-8-how-to-calculate-checksum-digit

    public String GetEAN13Checksum(String _data12digits) {
        int first = 0;
        int second = 0;
        int roundedNum = 0;
        int total = 0;

        if( _data12digits.length() != 12) return "?";

        for (int counter = 0; counter < _data12digits.length() - 1; counter++) {
                first = (first + Integer.valueOf(_data12digits.substring(counter, counter + 1)));
                counter++;
                second = (second + Integer.valueOf(_data12digits.substring(counter, counter + 1)));
        }

        second = second * 3;
        total = second + first;
        roundedNum = Math.round((total + 9) / 10 * 10);

        return String.valueOf(roundedNum - total);
    }

    //ref. https://stackoverflow.com/questions/1136642/ean-8-how-to-calculate-checksum-digit
    public String GetEAN8Checksum(String _data7digits) {

        String code= _data7digits; //"55123457";

        if(code.length() != 7) return "?";

        char[] acode = code.toCharArray();
        int sum1 = acode[1] + acode[3] + acode[5];
        int sum2 = 3 * (acode[0] + acode[2] + acode[4] + acode[6]);
        int checksum_value = sum1 + sum2;

        int checksum_digit = 10 - (checksum_value % 10);
        if (checksum_digit == 10)
            checksum_digit = 0;

        return String.valueOf(checksum_digit);
    }

    public Bitmap GetBar1D(int _format, String _data, int _width, int _height) throws WriterException {
        MultiFormatWriter writer = new MultiFormatWriter();
        String finalData = Uri.encode(_data);
        BitMatrix bm;
        switch (_format) {
            case 0: bm = writer.encode(finalData, BarcodeFormat.CODE_128, _width, 1);
            case 1: bm = writer.encode(finalData, BarcodeFormat.EAN_8, _width, 1); break;
            case 2: bm = writer.encode(finalData, BarcodeFormat.EAN_13, _width, 1); break;
            case 3: bm = writer.encode(finalData, BarcodeFormat.ITF, _width, 1); break;
            case 4: bm = writer.encode(finalData, BarcodeFormat.UPC_A, _width, 1); break;
            case 5: bm = writer.encode(finalData, BarcodeFormat.UPC_E, _width, 1); break;
            case 6: bm = writer.encode(finalData, BarcodeFormat.CODE_39, _width, 1); break;
            default:
                bm = writer.encode(finalData, BarcodeFormat.CODE_128, _width, 1);
        }
        // Use 1 as the height of the matrix as this is a 1D Barcode.
        int bmWidth = bm.getWidth();
        Bitmap imageBitmap = Bitmap.createBitmap(bmWidth, _height, Bitmap.Config.ARGB_8888);

        for (int i = 0; i < bmWidth; i++) {
            // Paint columns of width 1
            int[] column = new int[_height];
            Arrays.fill(column, bm.get(i, 0) ? Color.BLACK : Color.WHITE);
            imageBitmap.setPixels(column, 0, 1, i, 0, 1, _height);
        }
        return imageBitmap;
    }

    //TODO
    public Bitmap GetBar2D(String _data, int _width, int _height, int _format) throws WriterException {
        MultiFormatWriter writer = new MultiFormatWriter();
        String finalData = Uri.encode(_data);
        BitMatrix bm;
        switch (_format) {
            case 0: bm = writer.encode(finalData, BarcodeFormat.QR_CODE, _width, 1);
            case 1: bm = writer.encode(finalData, BarcodeFormat.DATA_MATRIX, _width, 1); break;
            case 2: bm = writer.encode(finalData, BarcodeFormat.AZTEC, _width, 1); break;
            default:
                bm = writer.encode(finalData, BarcodeFormat.QR_CODE, _width, 1);
        }
        // Use 1 as the height of the matrix as this is a 1D Barcode.
        int bmWidth = bm.getWidth();
        Bitmap imageBitmap = Bitmap.createBitmap(bmWidth, _height, Bitmap.Config.ARGB_8888);

        for (int i = 0; i < bmWidth; i++) {
            // Paint columns of width 1
            //int[] column = new int[_height];
            //Arrays.fill(column, bm.get(i, 0) ? Color.BLACK : Color.WHITE);
            //imageBitmap.setPixels(column, 0, 1, i, 0, 1, _height);
        }
        return imageBitmap;
    }

}
