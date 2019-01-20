package org.lamw.appxlswriterdemo1;

/*Draft java code by "Lazarus Android Module Wizard" [1/19/2019 18:40:58]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

import android.content.Context;
import java.io.File;
import java.io.IOException;
import jxl.Workbook;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
//import jxl.write.biff.RowsExceededException;

public class jXLSWriter /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context context   = null;

    private File mFile = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jXLSWriter(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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

    public boolean CreateWorkbook(String _sheet, String  _path, String _fileName) {
        boolean r = false;
        //if(mFile == null) {
        mFile = new File(_path,_fileName); // create file
        try {
            WritableWorkbook wb= Workbook.createWorkbook(new File(String.valueOf(mFile)));
            wb.createSheet(_sheet, 0); //_initialSheet, index = 0
            wb.write();
            wb.close();
            r = true;
        } catch (IOException e) {
            e.printStackTrace();
        } catch (WriteException e) {
            e.printStackTrace();
        }
        //}
        return r;
    }

    public boolean CreateWorkbook(String[] _sheets, String  _path, String _fileName) {
     boolean r = false;
     int count = _sheets.length;
        //if(mFile == null) {
            mFile = new File(_path,_fileName); // create file
            try {
                WritableWorkbook wb= Workbook.createWorkbook(new File(String.valueOf(mFile)));
                for (int i = 0; i < count; i++) {
                    wb.createSheet(_sheets[i], i); //_initialSheet, index = 0
                }
                wb.write();
                wb.close();
                r = true;
            } catch (IOException e) {
                e.printStackTrace();
            } catch (WriteException e) {
                e.printStackTrace();
            }
        //}
        return r;
    }

    /*TODO
    public int AddSheet(String _sheet) {

    }
     */

    public boolean AddCell(int _sheetIndex,  int _column, int _row, String _content) {
        boolean r = false;

        if(mFile == null) {
            return false;
        }

        if(!mFile.exists()) {
            return false;
        }

        Workbook wb = null;
        WritableWorkbook copy = null;
        try {
            wb = Workbook.getWorkbook(mFile);
            copy = Workbook.createWorkbook(mFile,wb);
            WritableSheet aCopySheet = copy.getSheet(_sheetIndex); //_sheetIndex
            Label anotherWritableCell =  new Label(_column,_row,_content);
            aCopySheet.addCell(anotherWritableCell);
            copy.write();
            copy.close();
            r = true;
                    //"Insert in file successful",
        }catch (IOException e) {
            e.printStackTrace();
                    //"Writing in file IO...",
        }
        catch (BiffException e) {
            e.printStackTrace();
                  //  "BiffException",
        }
        catch (WriteException e) {
            e.printStackTrace();
              //      "WriteException",
        }
        return r;
    }

}
