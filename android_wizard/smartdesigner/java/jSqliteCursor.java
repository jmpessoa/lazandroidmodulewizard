package com.example.appsqlitedemo1;

import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.util.Locale;

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
 * Review by TR3E 2019/08/23
 */
public class jSqliteCursor {

	private long       	PasObj    = 0;      // Pascal Obj
	private Controls   	controls  = null;   // Control Class for Event
	
	private int mCursorPos        = -1;
	private int mCursorColumnCount = 0;
	private int mCursorRowCount    = 0;
	public Cursor mCursor = null;	
	public Bitmap bufBmp = null;	
	
	//Constructor
	public  jSqliteCursor(Controls ctrls, long pasobj ) {
	   //Connect Pascal I/F
	   PasObj   = pasobj;
	   controls = ctrls;
	   	   
	   mCursorColumnCount = 0;
	   mCursorRowCount    = 0;
	   mCursorPos        = -1;
	}
	
	public  void SetCursor(Cursor curs) {
		mCursor = curs;
		
		if( mCursor != null ){
			mCursorColumnCount = mCursor.getColumnCount();
			mCursorRowCount    = mCursor.getCount();
			mCursorPos         = mCursor.getPosition();					
		}else{
			mCursorColumnCount = 0;
			mCursorRowCount    = 0;
			mCursorPos         = -1;
		}
	}
	
    public  Cursor GetCursor() {
  	    return mCursor;
    }
	
	public int GetRowCount() {
		return mCursorRowCount;    		    	
    }
	
    public void MoveToFirst() {
    	if (mCursor != null){
    		mCursor.moveToFirst();
    		mCursorPos = mCursor.getPosition();
    	}
    }
    
    public void MoveToNext() {
    	if (mCursor != null){
    		mCursor.moveToNext();
    		mCursorPos = mCursor.getPosition();
    	}
    }
    
    public void MoveToPrev() {
    	if (mCursor != null){
    		mCursor.moveToPrevious();
    		mCursorPos = mCursor.getPosition();
    	}
    }
    
    public void MoveToLast() {
    	if (mCursor != null){
    		mCursor.moveToLast();
    		mCursorPos = mCursor.getPosition();
    	}
    }
              
    public void MoveToPosition(int position) {
    	if ((mCursor == null) || (position < 0) || (position >= mCursorRowCount)) return;
    		
    	mCursor.moveToPosition(position);
    	mCursorPos = mCursor.getPosition();
    }
  
    public int GetPosition() {
    	if (mCursor == null) return -1;
    		     	
    	return mCursor.getPosition();
    }
    
    public int GetColumnIndex(String colName) {
    	if (mCursor == null) return -1;
    	
    	return mCursor.getColumnIndex(colName);    	
    }
     
    public String GetValueAsString(int columnIndex) {    	
    	if ((mCursor == null) || 
        	(columnIndex < 0) || (columnIndex >= mCursorColumnCount) ||
        	(mCursorPos  < 0) || (mCursorPos >= mCursorRowCount)) return "";
    	
    	return mCursor.getString(columnIndex);    			
    }

    //Cursor.FIELD_TYPE_BLOB; //4
	//Cursor.FIELD_TYPE_FLOAT//2
	//Cursor.FIELD_TYPE_INTEGER//1
	//Cursor.FIELD_TYPE_STRING//3
	//Cursor.FIELD_TYPE_NULL //0
    public int GetColType(int columnIndex) {
    	
    	if ((mCursor == null) || (columnIndex < 0) || (columnIndex >= mCursorColumnCount)) 
    		return Cursor.FIELD_TYPE_NULL;
    		
    	return mCursor.getType(columnIndex);    			
    }
    
    public byte[] GetValueAsBlod(int columnIndex) {
    	if ((mCursor == null) || 
    		(columnIndex < 0) || (columnIndex >= mCursorColumnCount) ||
    		(mCursorPos  < 0) || (mCursorPos >= mCursorRowCount)) return null;
    	
    	return mCursor.getBlob(columnIndex);    			
    }
    
    public Bitmap GetValueAsBitmap(int columnIndex) {
    	if ((mCursor == null) || 
        	(columnIndex < 0) || (columnIndex >= mCursorColumnCount) ||
        	(mCursorPos  < 0) || (mCursorPos >= mCursorRowCount)) return null;
    	
    	byte[] image = mCursor.getBlob(columnIndex);
    	
    	if( image == null ) return null;
    	
    	return BitmapFactory.decodeByteArray(image, 0, image.length);    	
    }
    
    public int GetValueAsInteger(int columnIndex) {
    	if ((mCursor == null) || 
        	(columnIndex < 0) || (columnIndex >= mCursorColumnCount) ||
        	(mCursorPos  < 0) || (mCursorPos >= mCursorRowCount)) return -1;
    	
    	return mCursor.getInt(columnIndex);    	
    }
    
    public short GetValueAsShort(int columnIndex) {
    	if ((mCursor == null) || 
           	(columnIndex < 0) || (columnIndex >= mCursorColumnCount) ||
           	(mCursorPos  < 0) || (mCursorPos >= mCursorRowCount)) return -1;
    	
    	return mCursor.getShort(columnIndex);    			
    }
    
    public long GetValueAsLong(int columnIndex) {
    	if ((mCursor == null) || 
            (columnIndex < 0) || (columnIndex >= mCursorColumnCount) ||
            (mCursorPos  < 0) || (mCursorPos >= mCursorRowCount)) return -1;
    		
    	return mCursor.getLong(columnIndex);    			
    }

    public float GetValueAsFloat(int columnIndex) {
    	if ((mCursor == null) || 
           	(columnIndex < 0) || (columnIndex >= mCursorColumnCount) ||
           	(mCursorPos  < 0) || (mCursorPos >= mCursorRowCount)) return -1;
    	
    	return mCursor.getFloat(columnIndex);    			
    }
     
    public double GetValueAsDouble(int columnIndex) {
    	if ((mCursor == null) || 
            (columnIndex < 0) || (columnIndex >= mCursorColumnCount) ||
            (mCursorPos  < 0) || (mCursorPos >= mCursorRowCount)) return -1;
    	
    	return mCursor.getDouble(columnIndex);    			
    }
       
    public int GetColumnCount() {
    	return mCursorColumnCount;    	
    }
    
    public String GetColumName(int columnIndex) {
    	if ((mCursor == null) || (columnIndex < 0) || (columnIndex >= mCursorColumnCount)) return "";
    	
    	return mCursor.getColumnName(columnIndex);    			
    }
         
    //Cursor.FIELD_TYPE_BLOB; //4
	//Cursor.FIELD_TYPE_FLOAT//2
	//Cursor.FIELD_TYPE_INTEGER//1
	//Cursor.FIELD_TYPE_STRING//3
	//Cursor.FIELD_TYPE_NULL //0
    public String GetValueToString(int columnIndex) {
    	if ((mCursor == null) || 
            (columnIndex < 0) || (columnIndex >= mCursorColumnCount) ||
            (mCursorPos  < 0) || (mCursorPos >= mCursorRowCount)) return "";    	                            
        
        String colValue = "";
            
        switch (mCursor.getType(columnIndex)) {                
     	      case Cursor.FIELD_TYPE_INTEGER: colValue = Integer.toString(mCursor.getInt(columnIndex));        break;
     	      case Cursor.FIELD_TYPE_STRING : colValue = mCursor.getString(columnIndex);                       break;
     	      case Cursor.FIELD_TYPE_FLOAT  : colValue = String.format(Locale.US, "%.2f", mCursor.getFloat(columnIndex)); break;
     	      case Cursor.FIELD_TYPE_BLOB   : colValue = "BLOB";                                       break;
     	      case Cursor.FIELD_TYPE_NULL   : colValue = "NULL";                                       break;
     	      default:                        colValue = "UNKNOW";                              
    	}                                                                       
        
        return colValue;        
    }
    
    public void Free() {
      mCursor = null;	
      bufBmp  = null;
    }    
}