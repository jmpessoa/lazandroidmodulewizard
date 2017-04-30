package org.lamw.appsqlitedemo3;

import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

//http://android-codes-examples.blogspot.com.br/2011/09/using-sqlite-to-populate-listview-in.html <<----------
//http://www.coderzheaven.com/2012/12/23/store-image-android-sqlite-retrieve-it/  <<---------------
	
//http://www.coderzheaven.com/2011/04/17/using-sqlite-in-android-a-really-simple-example/
//http://www.androidhive.info/2011/11/android-sqlite-database-tutorial/
//http://androidexample.com/SQLite_Database_Manipulation_Class_-_Android_Example/index.php?view=article_discription&aid=51
//http://javapapers.com/android/android-sqlite-database/  <<------------------- 
//http://chintankhetiya.wordpress.com/2013/06/01/sqlite-database-example/
//http://androidituts.com/android-sqlite-database-insert-example/
//http://www.codeproject.com/Articles/119293/Using-SQLite-Database-with-Android   <<---------------
//http://stackoverflow.com/questions/5742101/how-using-sqliteopenhelper-with-database-on-sd-card

/* 
 * LAMW -  LAZARUS ANDROID MODULE WIZARD
 * https://github.com/jmpessoa/lazandroidmodulewizard
 */
public class jSqliteCursor {

	private long       PasObj  = 0;      // Pascal Obj
	private Controls   controls = null;   // Control Class for Event

	public Cursor cursor = null;
	
	public Bitmap bufBmp = null;
	
	//Constructor
	public  jSqliteCursor(Controls ctrls, long pasobj ) {
	   //Connect Pascal I/F
	   PasObj   = pasobj;
	   controls = ctrls;
	}
	
	public  void SetCursor(Cursor curs) {
		this.cursor = curs;
	}
	
    public  Cursor GetCursor() {
  	    return this.cursor;
    }
	
	public int GetRowCount() {
		if (this.cursor != null) {
    		return this.cursor.getCount();    		
    	}
    	else{
    		return 0;
    	}
    }
    public void SetRowCount(int rows) {
	//this.rows = rows;
    }
    public void MoveToFirst() {
    	if (cursor != null) cursor.moveToFirst();
    }
    
    public void MoveToNext() {
    	if (cursor != null) cursor.moveToNext();
    }
    
    public void MoveToLast() {
    	if (cursor != null) cursor.moveToLast();
    }
              
    public void MoveToPosition(int position) {
    	if (cursor != null) cursor.moveToPosition(position);
    }
  
    public int GetColumnIndex(String colName) {
    	if (cursor != null) return cursor.getColumnIndex(colName);
    	else  return -1;
    }
     
    public String GetValueAsString(int columnIndex) {
    	if (cursor != null) return cursor.getString(columnIndex);
    	else return "";			
    }

    //Cursor.FIELD_TYPE_BLOB; //4
	//Cursor.FIELD_TYPE_FLOAT//2
	//Cursor.FIELD_TYPE_INTEGER//1
	//Cursor.FIELD_TYPE_STRING//3
	//Cursor.FIELD_TYPE_NULL //0
    public int GetColType(int columnIndex) {
    	if (cursor != null) return cursor.getType(columnIndex);
    	else return Cursor.FIELD_TYPE_NULL ;			
    }
    
    public byte[] GetValueAsBlod(int columnIndex) {
    	if (cursor != null) return cursor.getBlob(columnIndex);
    	else return null;			
    }
    
    public Bitmap GetValueAsBitmap(int columnIndex) {
    	bufBmp = null;
    	byte[] image = GetValueAsBlod(columnIndex);
    	if (image != null) {
    	     this.bufBmp = BitmapFactory.decodeByteArray(image, 0, image.length);
    	}     
    	return bufBmp;
    }
    
    public int GetValueAsInteger(int columnIndex) {
    	int index = 0;
    	
    	if (cursor != null){ 
    	    if	(columnIndex < 0) {index = 0;}
    	    if  (columnIndex >= cursor.getColumnCount() ) {index = cursor.getColumnCount()-1;} 
    		return cursor.getInt(index);
    	}	
    	else return -1;			
    }
    
    public short GetValueAsShort(int columnIndex) {
    	if (cursor != null) return cursor.getShort(columnIndex);
    	else return -1;			
    }

    public long GetValueAsLong(int columnIndex) {
    	if (cursor != null) return cursor.getLong(columnIndex);
    	else return -1;			
    }

    public float GetValueAsFloat(int columnIndex) {
    	if (cursor != null) return cursor.getFloat(columnIndex);
    	else return -1;			
    }
     
    public double GetValueAsDouble(int columnIndex) {
    	if (cursor != null) return cursor.getDouble(columnIndex);
    	else return -1;			
    }
       
    public int GetColumnCount() {
    	if (cursor != null) {return cursor.getColumnCount();}
    	else {return 0;}
    }
    
    public String GetColumName(int columnIndex) {
    	if (cursor != null) return cursor.getColumnName(columnIndex);
    	else return "";			
    }
         
    //Cursor.FIELD_TYPE_BLOB; //4
	//Cursor.FIELD_TYPE_FLOAT//2
	//Cursor.FIELD_TYPE_INTEGER//1
	//Cursor.FIELD_TYPE_STRING//3
	//Cursor.FIELD_TYPE_NULL //0           
    public String GetValueAsString(int position, String columnName) {
    	String colValue = "";
        if (this.cursor != null) {
        	
        	if (position == -1)  cursor.moveToLast();
        	else cursor.moveToPosition(position);
        	
            int index = this.cursor.getColumnIndex(columnName);                      
            switch (cursor.getType(index)) {                
     	      case Cursor.FIELD_TYPE_INTEGER: colValue = Integer.toString(cursor.getInt(index));           break;
     	      case Cursor.FIELD_TYPE_STRING : colValue =  cursor.getString(index);                         break;
     	      case Cursor.FIELD_TYPE_FLOAT  : colValue =  String.format("%.3f", cursor.getFloat(index));   break;
     	      case Cursor.FIELD_TYPE_BLOB   : colValue = "BLOB";                                       break;
     	      case Cursor.FIELD_TYPE_NULL   : colValue = "NULL";                                       break;
     	      default:                        colValue = "UNKNOW";                              
    	   }                                                                       
        }
        return colValue;        
    }
    
    public void Free() {
      cursor = null;	
      bufBmp = null;
    }    
}

/**
 * 
 * jSqliteDataAccess
 * 
 * by jmpessoa
 *
 */

