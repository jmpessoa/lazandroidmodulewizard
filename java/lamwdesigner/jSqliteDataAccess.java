package com.example.appopenfiledialogdemo1;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.lang.reflect.Field;
import java.util.Locale;

import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Log;

/* 
 * LAMW -  LAZARUS ANDROID MODULE WIZARD
 * https://github.com/jmpessoa/lazandroidmodulewizard
 */
public class jSqliteDataAccess {

    private long PasObj   = 0;           // Pascal Obj
    private Controls controls = null;   // Control Class for Event
    
    private String[] storeTableCreateQuery = new String[30]; //max (30) create tables scripts
    private String[] storeTableName = new String[30];       //max (30)  tables name
   
    private int countTableName = 0;
    private int countTableQuery = 0;
   
    private SQLiteDatabase mydb = null;
    
    public Cursor cursor = null;
    
    public Bitmap bufBmp = null;
    
    private static String DATABASE_NAME;                         
    private static final int DATABASE_VERSION = 1;
   
    char selectColDelimiter;  
    char selectRowDelimiter;
   
    public void SetSelectDelimiters(char coldelim, char rowdelim){
	   selectColDelimiter = coldelim;
	   selectRowDelimiter = rowdelim;
    }
    
    public void AddTableName(String tabName) {
	   storeTableName[countTableName] = tabName;
	   countTableName++;
    }
   
    public void AddCreateTableQuery(String queryCreateTable) {
	   storeTableCreateQuery[countTableQuery] = queryCreateTable; 
	   countTableQuery++;
    }
          
    public void CreateAllTables() {
	   for(int i=0; i < countTableQuery-1; i++) {
		   this.ExecSQL(storeTableCreateQuery[i]);  
	   }
    }
   	   	   
    public void DropAllTables(boolean recreate) {
	   //drop All tables
	   for(int i=0; i < countTableName-1; i++) {
		  this.ExecSQL("DROP TABLE IF EXISTS "+storeTableName[i]);
	   }
	   
	   if (recreate = true) { CreateAllTables(); }
    }
   
    //constructor ...
    public jSqliteDataAccess (Controls ctrls, long pasobj, String dbName, char colDelim, char rowDelim) {	    
	   PasObj   = pasobj;
	   controls = ctrls;
	   selectColDelimiter = colDelim;  
       selectRowDelimiter = rowDelim;
       DATABASE_NAME = dbName;
    }

    // Open/Create database for insert,update,delete in syncronized manner
    private synchronized SQLiteDatabase Open() throws SQLException {
	   return controls.activity.openOrCreateDatabase(DATABASE_NAME, SQLiteDatabase.CREATE_IF_NECESSARY,  null); //Context.MODE_PRIVATE,
    }
   
    public void OpenOrCreate(String dataBaseName) {
	   DATABASE_NAME = dataBaseName;
	   mydb = this.Open();
    }
    public void SetVersion(int version) {
    	if (mydb == null) {
    		mydb = this.Open();
    	}
    	if (mydb!= null) {
    		mydb.setVersion(version);
    	}
    }
    public int GetVersion() {
    	if (mydb == null) {
    		mydb = this.Open();
    	}	    	
    	if (mydb!= null) {
    		return mydb.getVersion();
    	}
    	return 0;
    }
    public void ExecSQL(String execQuery){
        try{ 	
           if (mydb!= null) {
        	   if (!mydb.isOpen()) {
        	      mydb = this.Open();
        	   }
           }	
           else {
        	   mydb = this.Open();
           }	        	   
           mydb.beginTransaction();
           try {
            	mydb.execSQL(execQuery); //Execute a single SQL statement that is NOT a SELECT or any other SQL statement that returns data.
                //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
                mydb.setTransactionSuccessful();
           } catch (Exception e) {
                e.printStackTrace();
           } finally {
                // transaction over
            	mydb.endTransaction();
            	mydb.close();
           }	           	           	            	           
        }catch(SQLiteException se){
        	Log.e(getClass().getSimpleName(), "Could not execute: "+ execQuery);
        	
        }
    }
    
  //by jmpessoa
    private int GetDrawableResourceId(String _resName) {
    	  try {
    	     Class<?> res = R.drawable.class;
    	     Field field = res.getField(_resName);  //"drawableName"
    	     int drawableId = field.getInt(null);
    	     return drawableId;
    	  }
    	  catch (Exception e) {
    	     Log.e("jSqliteDataAccess", "Failure to get drawable id.", e);
    	     return 0;
    	  }
    }

    //by jmpessoa
    private Drawable GetDrawableResourceById(int _resID) {
      return (Drawable)( this.controls.activity.getResources().getDrawable(_resID));	
    }        
            
    public void UpdateImage(String tabName, String imageFieldName, String keyFieldName, Bitmap imageValue, int keyValue) {
    	ByteArrayOutputStream stream = new ByteArrayOutputStream();
    	bufBmp = imageValue;
    	bufBmp.compress(CompressFormat.PNG, 0, stream);            
        byte[] image_byte = stream.toByteArray();
        //Log.i("UpdateImage","UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?");
        if (mydb!= null) {
          if (!mydb.isOpen()) {
             mydb = this.Open();
          }
        }
        else {
           mydb = this.Open();
        }
        
        mydb.beginTransaction();
        try {
        	mydb.execSQL("UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?", new Object[] {image_byte, keyValue} );
            //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
            mydb.setTransactionSuccessful();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // transaction over
        	mydb.endTransaction();
        	mydb.close();
        }	                	        	
    	//mydb.close();
    	//Log.i("UpdateImage", "Ok. Image Updated!");
    	bufBmp = null;
    }
    
    public void UpdateImage(String tabName, String imageFieldName, String keyFieldName, byte[] imageValue, int keyValue) {
        if (mydb!= null) {
           if (!mydb.isOpen()) {
               mydb = this.Open();
           }
        }
        else {
           mydb = this.Open();
        }
        
        mydb.beginTransaction();
        try {
        	mydb.execSQL("UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?", new Object[] {imageValue, keyValue} );
            //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
            mydb.setTransactionSuccessful();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // transaction over
        	mydb.endTransaction();
        	mydb.close();
        }	        	        	               	
    }
            
    public String Select(String selectQuery) {	 //return String
    	
	     String row = "";
	     String rows = "";
	     String colValue;		     
	     String headerRow;
	     int colCount;	    	
	     int i;
	     String allRows = null;
	      		     		     
	     try{
	    	   this.cursor = null; //[by renabor] without this a second query will find the Cursor randomly positioned!!!
	           if (mydb!= null) {
	               if (!mydb.isOpen()) {
	                  mydb = this.Open();
	               }
	            }
	           else {
	        	   mydb = this.Open();
	           }
	            cursor  = mydb.rawQuery(selectQuery, null);		       
	        	
	            colCount = cursor.getColumnCount();
	        
	            headerRow = "";
	            for (i = 0; i < colCount; i++) {
	            	headerRow = headerRow + cursor.getColumnName(i) + selectColDelimiter;
	            } 
	            headerRow = headerRow.substring(0, headerRow.length() - 1);
	            if(cursor.moveToFirst()){
	                do{
	                	 row ="";	   
	                	 colValue = "";		                	 		                	
	                     for (i = 0; i < colCount; i++) {		                    	 	 
	                    	 switch (cursor.getType(i)) {                
	                    	   case Cursor.FIELD_TYPE_INTEGER: colValue = Integer.toString(cursor.getInt(i));           break;
	                    	   case Cursor.FIELD_TYPE_STRING : colValue =  cursor.getString(i);                         break;
	                    	   case Cursor.FIELD_TYPE_FLOAT  : colValue =  String.format("%.3f", cursor.getFloat(i));  break;
	                    	   case Cursor.FIELD_TYPE_BLOB   : colValue = "BLOB";                                       break;
	                    	   case Cursor.FIELD_TYPE_NULL   : colValue = "NULL";                                       break;
	                    	   default:                        colValue = "UNKNOW";                              
	                     	 }
	                    	 row = row + colValue + selectColDelimiter ;
	                      }
	                      row = row.substring(0, row.length() - 1); 
	                      rows = rows + row + selectRowDelimiter;
	                      
	                }
	                while(cursor.moveToNext());
	            }		            		           
	            mydb.close();
	            cursor.moveToFirst();		            
	            allRows = headerRow + selectRowDelimiter + rows;
	          		      
	     }catch(SQLiteException se){
	         Log.e(getClass().getSimpleName(), "Could not select:" + selectQuery);
	     }	    		      
	     return allRows; 
    }
    	    
    public boolean Select(String selectQuery,  boolean moveToLast) {   //just set the cursor! return void..
    	    boolean result = true;
    	    this.cursor = null;
	        try{  		        	
		        if (mydb!= null) {
		           if (!mydb.isOpen()) {
		              mydb = this.Open(); //controls.activity.openOrCreateDatabase(DATABASE_NAME, Context.MODE_PRIVATE, null); 
		           }
		        }
		        else {
		          mydb = this.Open(); 
		        }
		     	this.cursor  = mydb.rawQuery(selectQuery, null);
		     	this.cursor.moveToFirst(); 	
		        mydb.close();			       
		     }catch(SQLiteException se){
		    	 result = false;
		         Log.e(getClass().getSimpleName(), "Could not select:" + selectQuery);
		     }	     				        
	         return result;
	}

    
    public Cursor GetCursor() {
	    return this.cursor;
    }
    
    //ex. "CREATE TABLE IF NOT EXISTS TABLE1  (_ID INTEGER PRIMARY KEY, NAME TEXT, PLACE TEXT);"
    public void CreateTable(String query){
       this.ExecSQL(query);	      
    }

    //ex: "INSERT INTO TABLE1 (NAME, PLACE) VALUES('CODERZHEAVEN','GREAT INDIA')"
    public void InsertIntoTable(String query){
       this.ExecSQL(query);	            
    }
    
    //ex: "UPDATE TABLE1 SET NAME = 'MAX' WHERE PLACE = 'USA'"
    public void UpdateTable(String query){
        this.ExecSQL(query);	        
    }
    
    //ex: "DELETE FROM TABLE1  WHERE PLACE = 'USA'";
    public void DeleteFromTable(String query){
       this.ExecSQL(query);	       
    }
    
    //ex:  "TABLE1" 
    public void DropTable(String tbName){
       this.ExecSQL("DROP TABLE " + tbName);	           
    }
    
	//Check if the database exist... 
	public boolean CheckDataBaseExists(String dbPath) {   
	      SQLiteDatabase checkDB = null; 
	      try {
	          String myPath = dbPath; //"data/data/com.example.appsqlitedemo1/databases/" + dbName;
	          checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
	      } catch (SQLiteException e) {
	    	  Log.e("SQLiteDatabase","database does't exist yet.");
	      } 
	      if (checkDB != null) {
             checkDB.close();
	      }      	         
	      return checkDB != null ? true : false;
	}
     
	public void Close() {
	   if (mydb != null)  { 	
	       if (mydb.isOpen()) { mydb.close();}
	   }
	}
	   
	public void Free() {
	   if (mydb != null) {	
	      if (mydb.isOpen()) { mydb.close();}
	      mydb = null;
	   }
	}		
					
	//news! version 06 rev. 08 15 december 2014.........................
	
	public void SetForeignKeyConstraintsEnabled(boolean _value) {
    	if (mydb == null) {
    		mydb = this.Open();
    	}
		if (mydb!=null)
	  	  mydb.setForeignKeyConstraintsEnabled(_value);			
	}
	
	public void SetDefaultLocale() {
    	if (mydb == null) {
    		mydb = this.Open();
    	}			
		if (mydb!=null)
		   mydb.setLocale(Locale.getDefault());			
	}
					
	public void DeleteDatabase(String _dbName) {
	   controls.activity.deleteDatabase(_dbName);
	}
	
	/*
	 * ref, http://www.informit.com/articles/article.aspx?p=1928230
       Because SQLite is a single file, it makes little sense to try to store binary data in the database. 
       Instead store the location of data, as a file path or a URI in the database, and access it appropriately.           
	 */
    public void UpdateImage(String _tabName, String _imageFieldName, String _keyFieldName, String _imageResIdentifier, int _keyValue) {
    	ByteArrayOutputStream stream = new ByteArrayOutputStream();
    	Drawable d = GetDrawableResourceById(GetDrawableResourceId(_imageResIdentifier));        	
    	bufBmp = ((BitmapDrawable)d).getBitmap();       	        	       
    	bufBmp.compress(CompressFormat.PNG, 0, stream); 
    	//bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream);        	
        byte[] image_byte = stream.toByteArray();
        //Log.i("UpdateImage","UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?");                       
        if (mydb!= null) {
	         if (!mydb.isOpen()) {
	              mydb = this.Open();
	         }
	    }
        else {
           mydb = this.Open();
        }
        mydb.beginTransaction();
        try {
        	mydb.execSQL("UPDATE " + _tabName + " SET "+_imageFieldName+" = ? WHERE "+_keyFieldName+" = ?", new Object[] {image_byte, _keyValue} );
            //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
            mydb.setTransactionSuccessful();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // transaction over
        	mydb.endTransaction();
        	mydb.close();
        }	                	       
    	//Log.i("UpdateImage", "Ok. Image Updated!");
    	bufBmp = null;
    }	
             
    public void InsertIntoTableBatch(String[] _insertQueries) {
    	int i; 
    	int len = _insertQueries.length;               
    	for (i=0; i < len; i++) {
            	this.ExecSQL(_insertQueries[i]);
        }
    }
    
    public void UpdateTableBatch(String[] _updateQueries) {
    	int i; 
    	int len = _updateQueries.length;               
    	for (i=0; i < len; i++) {
           	this.ExecSQL(_updateQueries[i]);
        }
    }
    
	//Check if the database exist... 
	public boolean CheckDataBaseExistsByName(String _dbName) {   
	      SQLiteDatabase checkDB = null; 
	      try {
	    	  String absPath = this.controls.activity.getFilesDir().getPath();
              absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/databases/"+_dbName;		         
	          checkDB = SQLiteDatabase.openDatabase(absPath, null, SQLiteDatabase.OPEN_READONLY);
	      } catch (SQLiteException e) {
	    	  Log.e("jSqliteDataAccess","database does't exist yet!");
	      } 
	      if (checkDB != null) {
             checkDB.close();
	      }      	         
	      return checkDB != null ? true : false;
	}
	
	//ex. 'tablebook|FIGURE|_ID|ic_t1|1'
    private void SplitUpdateImageData(String _imageResIdentifierData, String _delimiter) {
    	String[] tokens = _imageResIdentifierData.split("\\"+_delimiter);  //ex. "|"        	        
    	String _tabName = tokens[0];
    	String _imageFieldName = tokens[1]; 
    	String _keyFieldName = tokens[2];
    	String _imageResIdentifier = tokens[3];         	        
    	int _keyValue = Integer.parseInt(tokens[4]);
    	UpdateImage(_tabName, _imageFieldName, _keyFieldName, _imageResIdentifier, _keyValue) ;
    }
    
    public void UpdateImageBatch(String[] _imageResIdentifierDataArray, String _delimiter) {
    	int i; 
    	int len = _imageResIdentifierDataArray.length;        	
    	for (i=0; i < len; i++) {
           	this.SplitUpdateImageData(_imageResIdentifierDataArray[i], _delimiter);
        }
    }
    
    public void SetDataBaseName(String _dbName) {
    	DATABASE_NAME = _dbName;
    }
    
    public boolean DatabaseExists(String _databaseName) {
      File database=controls.activity.getDatabasePath(_databaseName);  //"databasename.db"
      if (!database.exists()) {
          // Database does not exist so copy it from assets here
          //Log.i("Database", "Not Found");
          return false;
      } else {
          //Log.i("Database", "Found");
          return true;
      }     
    }
    
}
