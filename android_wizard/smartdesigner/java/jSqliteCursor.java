package com.example.appsqlitedemo1;

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
 * Review by TR3E 2019/03/28
 */
public class jSqliteCursor {

	private long       	PasObj  = 0;      // Pascal Obj
	private Controls   	controls = null;   // Control Class for Event
	private int 		cursorColumnCount = 0;
	private int 		cursorRowCount = 0;
	public Cursor cursor = null;	
	public Bitmap bufBmp = null;	
	
	//Constructor
	public  jSqliteCursor(Controls ctrls, long pasobj ) {
	   //Connect Pascal I/F
	   PasObj   = pasobj;
	   controls = ctrls;
	   
	   cursorColumnCount = 0;
	   cursorRowCount = 0;
	}
	
	public  void SetCursor(Cursor curs) {
		this.cursor = curs;
		
		if( this.cursor != null ){
			cursorColumnCount = cursor.getColumnCount();
			cursorRowCount    = cursor.getCount();
		}else{
			cursorColumnCount = 0;
			cursorRowCount = 0;	
		}
	}
	
    public  Cursor GetCursor() {
  	    return this.cursor;
    }
	
	public int GetRowCount() {
		return cursorRowCount;    		    	
    }
	
    public void MoveToFirst() {
    	if (cursor != null) cursor.moveToFirst();
    }
    
    public void MoveToNext() {
    	if (cursor != null) cursor.moveToNext();
    }
    
    public void MoveToPrev() {
    	if (cursor != null) cursor.moveToPrevious();
    }
    
    public void MoveToLast() {
    	if (cursor != null) cursor.moveToLast();
    }
              
    public void MoveToPosition(int position) {
    	if ((cursor == null) || (position < 0) || (position >= cursorRowCount)) return;
    		
    	cursor.moveToPosition(position);
    }
  
    public int GetPosition() {
    	if (cursor == null) return -1;
    		     	
    	return cursor.getPosition();
    }
    
    public int GetColumnIndex(String colName) {
    	if (cursor == null) return -1;
    	
    	return cursor.getColumnIndex(colName);    	
    }
     
    public String GetValueAsString(int columnIndex) {    	
    	if ((cursor == null) || (columnIndex < 0) || (columnIndex >= cursorColumnCount)) return "";
    	
    	//Checking the position of the cursor avoid blocking errors
    	int cursorPos = cursor.getPosition();
    	
    	if ((cursorPos < 0) || (cursorPos >= cursorRowCount)) return "";
    	
    	return cursor.getString(columnIndex);    			
    }
    
    public String GetValueAsString( String colName ){    	
    	return GetValueAsString(GetColumnIndex(colName));    	
    }

    //Cursor.FIELD_TYPE_BLOB; //4
	//Cursor.FIELD_TYPE_FLOAT//2
	//Cursor.FIELD_TYPE_INTEGER//1
	//Cursor.FIELD_TYPE_STRING//3
	//Cursor.FIELD_TYPE_NULL //0
    public int GetColType(int columnIndex) {
    	if (cursor == null) return 0;
    	if ((columnIndex < 0) || (columnIndex >= cursorColumnCount)) return Cursor.FIELD_TYPE_NULL;
    		
    	return cursor.getType(columnIndex);    			
    }
    
    public byte[] GetValueAsBlod(int columnIndex) {
    	if ((cursor == null) || (columnIndex < 0) || (columnIndex >= cursorColumnCount)) return null;
    	
    	//Checking the position of the cursor avoid blocking errors
    	int cursorPos = cursor.getPosition();
    	
    	if ((cursorPos < 0) || (cursorPos >= cursorRowCount)) return null;
    	
    	return cursor.getBlob(columnIndex);    			
    }
    
    public byte[] GetValueAsBlod( String colName ){    	    
    	return GetValueAsBlod(GetColumnIndex(colName));    	
    }
    
    public Bitmap GetValueAsBitmap(int columnIndex) {
    	if ((columnIndex < 0) || (columnIndex >= cursorColumnCount)) return null;
    	
    	byte[] image = GetValueAsBlod(columnIndex);
    	
    	if( image == null ) return null;
    	
    	return BitmapFactory.decodeByteArray(image, 0, image.length);    	
    }
    
    public Bitmap GetValueAsBitmap( String colName ){    	    
    	return GetValueAsBitmap(GetColumnIndex(colName));    	
    }
    
    public int GetValueAsInteger(int columnIndex) {
    	if ((cursor == null) || (columnIndex < 0) || (columnIndex >= cursorColumnCount)) return -1;
    	
    	//Checking the position of the cursor avoid blocking errors
    	int cursorPos = cursor.getPosition();
    	
    	if ((cursorPos < 0) || (cursorPos >= cursorRowCount)) return -1;
    	
    	return cursor.getInt(columnIndex);    	
    }
    
    public int GetValueAsInteger( String colName ){    	    
    	return GetValueAsInteger(GetColumnIndex(colName));    	
    }
    
    public short GetValueAsShort(int columnIndex) {
    	if ((cursor == null) || (columnIndex < 0) || (columnIndex >= cursorColumnCount)) return -1;
    	
    	//Checking the position of the cursor avoid blocking errors
    	int cursorPos = cursor.getPosition();
    	
    	if ((cursorPos < 0) || (cursorPos >= cursorRowCount)) return -1;
    	
    	return cursor.getShort(columnIndex);    			
    }
    
    public short GetValueAsShort( String colName ){    	    
    	return GetValueAsShort(GetColumnIndex(colName));    	
    }

    public long GetValueAsLong(int columnIndex) {
    	if ((cursor == null) || (columnIndex < 0) || (columnIndex >= cursorColumnCount)) return -1;
    	
    	//Checking the position of the cursor avoid blocking errors
    	int cursorPos = cursor.getPosition();
    	
    	if ((cursorPos < 0) || (cursorPos >= cursorRowCount)) return -1;
    		
    	return cursor.getLong(columnIndex);    			
    }
    
    public long GetValueAsLong( String colName ){    	    
    	return GetValueAsLong(GetColumnIndex(colName));    	
    }

    public float GetValueAsFloat(int columnIndex) {
    	if ((cursor == null) || (columnIndex < 0) || (columnIndex >= cursorColumnCount)) return -1;
    	
    	//Checking the position of the cursor avoid blocking errors
    	int cursorPos = cursor.getPosition();
    	
    	if ((cursorPos < 0) || (cursorPos >= cursorRowCount)) return -1;
    	
    	return cursor.getFloat(columnIndex);    			
    }
    
    public float GetValueAsFloat( String colName ){    	    
    	return GetValueAsFloat(GetColumnIndex(colName));    	
    }
     
    public double GetValueAsDouble(int columnIndex) {
    	if ((cursor == null) || (columnIndex < 0) || (columnIndex >= cursorColumnCount)) return -1;
    	
    	//Checking the position of the cursor avoid blocking errors
    	int cursorPos = cursor.getPosition();
    	
    	if ((cursorPos < 0) || (cursorPos >= cursorRowCount)) return -1;
    	
    	return cursor.getDouble(columnIndex);    			
    }
    
    public double GetValueAsDouble( String colName ){    	    
    	return GetValueAsDouble(GetColumnIndex(colName));    	
    }
       
    public int GetColumnCount() {
    	return cursorColumnCount;    	
    }
    
    public String GetColumName(int columnIndex) {
    	if ((cursor == null) || (columnIndex < 0) || (columnIndex >= cursorColumnCount)) return "";
    	
    	return cursor.getColumnName(columnIndex);    			
    }
         
    //Cursor.FIELD_TYPE_BLOB; //4
	//Cursor.FIELD_TYPE_FLOAT//2
	//Cursor.FIELD_TYPE_INTEGER//1
	//Cursor.FIELD_TYPE_STRING//3
	//Cursor.FIELD_TYPE_NULL //0           
    public String GetValueAsString(int position, String columnName) {
    	if ((this.cursor == null) || (position < 0) || (position >= cursorRowCount)) return "";
    	                            
        cursor.moveToPosition(position);
        	
        int columnIndex = this.cursor.getColumnIndex(columnName);
        
        if ((columnIndex < 0) || (columnIndex >= cursorColumnCount)) return "";
        
        String colValue = "";
            
        switch (cursor.getType(columnIndex)) {                
     	      case Cursor.FIELD_TYPE_INTEGER: colValue = Integer.toString(cursor.getInt(columnIndex));        break;
     	      case Cursor.FIELD_TYPE_STRING : colValue = cursor.getString(columnIndex);                       break;
     	      case Cursor.FIELD_TYPE_FLOAT  : colValue = String.format("%.3f", cursor.getFloat(columnIndex)); break;
     	      case Cursor.FIELD_TYPE_BLOB   : colValue = "BLOB";                                       break;
     	      case Cursor.FIELD_TYPE_NULL   : colValue = "NULL";                                       break;
     	      default:                        colValue = "UNKNOW";                              
    	}                                                                       
        
        return colValue;        
    }
    
    public void Free() {
      cursor = null;	
      bufBmp = null;
    }    
}