package com.example.appsqlitedemo2;

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
import android.os.Build;
import android.util.Log;

import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.Resources;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.zip.ZipInputStream;
import java.util.Comparator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**[by renabor]
 * A helper class to manage database creation and version management using 
 * an application's raw asset files.
 *
 * This class provides developers with a simple way to ship their Android app 
 * with an existing SQLite database (which may be pre-populated with data) and 
 * to manage its initial creation and any upgrades required with subsequent 
 * version releases.
 *
 * <p>This class makes it easy for {@link android.content.ContentProvider}
 * implementations to defer opening and upgrading the database until first use,
 * to avoid blocking application startup with long-running database upgrades.
 *
 * <p>For examples see <a href="https://github.com/jgilfelt/android-sqlite-asset-helper">
 * https://github.com/jgilfelt/android-sqlite-asset-helper</a>
 *
 * <p class="note"><strong>Note:</strong> this class assumes
 * monotonically increasing version numbers for upgrades.  Also, there
 * is no concept of a database downgrade; installing a new version of
 * your app which uses a lower version number than a
 * previously-installed version will result in undefined behavior.</p>
 */
class SQLiteAssetHelper extends SQLiteOpenHelper {

    private static SQLiteAssetHelper instance;

    private static final String TAG = SQLiteAssetHelper.class.getSimpleName();
    public static String ASSET_DB_PATH = "databases";

    private final Context mContext;
    private String mName;
    private final CursorFactory mFactory;
    private final int mNewVersion;
    private String DATABASE_NAME;
    private int DATABASE_VERSION;

    private SQLiteDatabase mDatabase = null;
    private boolean mIsInitializing = false;

    private String mDatabasePath;

    private String mAssetPath;

    private String mUpgradePathFormat;

    private int mForcedUpgradeVersion = 0;

    /**
     * Create a helper object to create, open, and/or manage a database in 
     * a specified location.
     * This method always returns very quickly.  The database is not actually
     * created or opened until one of {@link #getWritableDatabase} or
     * {@link #getReadableDatabase} is called.
     *
     * @param context to use to open or create the database
     * @param name of the database file
     * @param storageDirectory to store the database file upon creation; caller must
     *     ensure that the specified absolute path is available and can be written to  
     * @param factory to use for creating cursor objects, or null for the default
     * @param version number of the database (starting at 1); if the database is older,
     *     SQL file(s) contained within the application assets folder will be used to 
     *     upgrade the database
     */

/*
* NEVER HARDCODE PATHS. Use getDatabasePath() to find the proper place for a database.
*
*/
    
    public SQLiteAssetHelper(Context context, String name, String storageDirectory, CursorFactory factory, int version) {
        super(context, name, factory, version);
        
	    DATABASE_NAME = name;
	    DATABASE_VERSION = version;

        if (version < 1) throw new IllegalArgumentException("Version must be >= 1, was " + version);
        if (name == null) throw new IllegalArgumentException("Database name cannot be null");

        mContext = context;
        mName = name;
        mFactory = factory;
        mNewVersion = version;
        
        if (IsFileInRootAssets(mName)) {
        	ASSET_DB_PATH = "";
        }
             	
        if ( !ASSET_DB_PATH.equals("") )
            mAssetPath = ASSET_DB_PATH + "/" + name;
        else
        	mAssetPath =  name;
                     	        
        if (storageDirectory != null) {
            mDatabasePath = storageDirectory;
        } else {
            mDatabasePath = context.getApplicationInfo().dataDir + "/databases";  //internal app database path
        }
                
        if ( !ASSET_DB_PATH.equals("") )
           mUpgradePathFormat = ASSET_DB_PATH + "/" + name + "_upgrade_%s-%s.sql";
        else
           mUpgradePathFormat =  name + "_upgrade_%s-%s.sql";
    }
   
   public synchronized static SQLiteAssetHelper getInstance(Context context) {
	return instance;
    }

    /**
     * Create a helper object to create, open, and/or manage a database in 
     * the application's default private data directory.
     * This method always returns very quickly.  The database is not actually
     * created or opened until one of {@link #getWritableDatabase} or
     * {@link #getReadableDatabase} is called.
     *
     * @param context to use to open or create the database
     * @param name of the database file
     * @param factory to use for creating cursor objects, or null for the default
     * @param version number of the database (starting at 1); if the database is older,
     *     SQL file(s) contained within the application assets folder will be used to 
     *     upgrade the database
     */
    public SQLiteAssetHelper(Context context, String name, CursorFactory factory, int version) {
        this(context, name, null, factory, version);
    }

    /**
     * Create and/or open a database that will be used for reading and writing.
     * The first time this is called, the database will be extracted and copied
     * from the application's assets folder.
     *
     * <p>Once opened successfully, the database is cached, so you can
     * call this method every time you need to write to the database.
     * (Make sure to call {@link #close} when you no longer need the database.)
     * Errors such as bad permissions or a full disk may cause this method
     * to fail, but future attempts may succeed if the problem is fixed.</p>
     *
     * <p class="caution">Database upgrade may take a long time, you
     * should not call this method from the application main thread, including
     * from {@link android.content.ContentProvider#onCreate ContentProvider.onCreate()}.
     *
     * @throws SQLiteException if the database cannot be opened for writing
     * @return a read/write database object valid until {@link #close} is called
     */
    @Override
    public synchronized SQLiteDatabase getWritableDatabase() {
        
        if (mDatabase != null && mDatabase.isOpen() && !mDatabase.isReadOnly()) {
            return mDatabase;  // The database is already open for business
        }

        if (mIsInitializing) {
            throw new IllegalStateException("getWritableDatabase called recursively");
        }

        // If we have a read-only database open, someone could be using it
        // (though they shouldn't), which would cause a lock to be held on
        // the file, and our attempts to open the database read-write would
        // fail waiting for the file lock.  To prevent that, we acquire the
        // lock on the read-only database, which shuts out other users.

        boolean success = false;
        SQLiteDatabase db = null;
        //if (mDatabase != null) mDatabase.lock();
        try {
            mIsInitializing = true;
            //if (mName == null) {
            //    db = SQLiteDatabase.create(null);
            //} else {
            //    db = mContext.openOrCreateDatabase(mName, 0, mFactory);
            //}
            db = createOrOpenDatabase(false);

            int version = db.getVersion();

            // do force upgrade
            if (version != 0 && version < mForcedUpgradeVersion) {
                db = createOrOpenDatabase(true);
                db.setVersion(mNewVersion);
                version = db.getVersion();
            }

            if (version != mNewVersion) {
                db.beginTransaction();
                try {
                    if (version == 0) {
                        onCreate(db);
                    } else {
                        if (version > mNewVersion) {
                            Log.w(TAG, "downgrade database from version " +
                                    version + " to " + mNewVersion + ": " + db.getPath());
				db.setVersion(mNewVersion);
				
                        }
                        onUpgrade(db, version, mNewVersion);
                    }
                    db.setVersion(mNewVersion);
                    db.setTransactionSuccessful();
                } finally {
                    db.endTransaction();
                }
            }

            onOpen(db);
            success = true;
            return db;
        } finally {
            mIsInitializing = false;
            if (success) {
                if (mDatabase != null) {
                    try { mDatabase.close(); } catch (Exception e) { }
                    //mDatabase.unlock();
                }
                mDatabase = db;
            } else {
                //if (mDatabase != null) mDatabase.unlock();
                if (db != null) db.close();
            }
        }

    }

    /**
     * Create and/or open a database.  This will be the same object returned by
     * {@link #getWritableDatabase} unless some problem, such as a full disk,
     * requires the database to be opened read-only.  In that case, a read-only
     * database object will be returned.  If the problem is fixed, a future call
     * to {@link #getWritableDatabase} may succeed, in which case the read-only
     * database object will be closed and the read/write object will be returned
     * in the future.
     *
     * <p class="caution">Like {@link #getWritableDatabase}, this method may
     * take a long time to return, so you should not call it from the
     * application main thread, including from
     * {@link android.content.ContentProvider#onCreate ContentProvider.onCreate()}.
     *
     * @throws SQLiteException if the database cannot be opened
     * @return a database object valid until {@link #getWritableDatabase}
     *     or {@link #close} is called.
     */
    @Override
    public synchronized SQLiteDatabase getReadableDatabase() {
        if (mDatabase != null && mDatabase.isOpen()) {        	
            return mDatabase;  // The database is already open for business
        }

        if (mIsInitializing) {
            throw new IllegalStateException("getReadableDatabase called recursively");
        }

        try {
            return getWritableDatabase();
        } catch (SQLiteException e) {
            if (mName == null) throw e;  // Can't open a temp database read-only!
            Log.e(TAG, "Couldn't open " + mName + " for writing (will try read-only):", e);
        }

        SQLiteDatabase db = null;
        try {
            mIsInitializing = true;
            String path = mContext.getDatabasePath(mName).getPath();
            db = SQLiteDatabase.openDatabase(path, mFactory, (SQLiteDatabase.OPEN_READONLY | SQLiteDatabase.NO_LOCALIZED_COLLATORS));
            if (db.getVersion() != mNewVersion) {
                throw new SQLiteException("Can't upgrade read-only database from version " +
                        db.getVersion() + " to " + mNewVersion + ": " + path);
            }

            onOpen(db);// borsa.db_upgrade_1-2.sql
            Log.w(TAG, "Opened " + mName + " in read-only mode");
            mDatabase = db;
            return mDatabase;
        } finally {
            mIsInitializing = false;
            if (db != null && db != mDatabase) db.close();
        }
        
    }

    /**
     * Close any open database object.
     */
    @Override
    public synchronized void close() {
        if (mIsInitializing) throw new IllegalStateException("Closed during initialization");

        if (mDatabase != null && mDatabase.isOpen()) {
            mDatabase.close();
            mDatabase = null;
        }
    }

    @Override
    public final void onConfigure(SQLiteDatabase db) {
        // not supported!
    }

    @Override
    public final void onCreate(SQLiteDatabase db) {
	Log.w(TAG, "onCreate");
        // do nothing - createOrOpenDatabase() is called in
        // getWritableDatabase() to handle database creation.
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

        Log.w(TAG, "Upgrading database " + mName + " from version " + oldVersion + " to " + newVersion + "...");

        ArrayList<String> paths = new ArrayList<String>();
        getUpgradeFilePaths(oldVersion, newVersion-1, newVersion, paths);

        if (paths.isEmpty()) {
            Log.e(TAG, "no upgrade script path from " + oldVersion + " to " + newVersion);
		
            throw new SQLiteAssetException("no upgrade script path from " + oldVersion + " to " + newVersion);
        }

        Collections.sort(paths, new VersionComparator());
        for (String path : paths) {
            try {
                Log.w(TAG, "processing upgrade: " + path);
                InputStream is = mContext.getAssets().open(path);
                String sql = Utils.convertStreamToString(is);
                if (sql != null && sql.indexOf("#") == -1) { // escludo le righe coi commenti
                    List<String> cmds = Utils.splitSqlScript(sql, ';');
                    for (String cmd : cmds) {
                        Log.d(TAG, "cmd=" + cmd);
                        if (cmd.trim().length() > 0) {
                            db.execSQL(cmd);
                        }
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
		db.setVersion(newVersion);
	    }	
        }
        Log.w(TAG, "Successfully upgraded database " + mName + " from version " + oldVersion + " to " + db.getVersion());

    }

    @Override
    public final void onDowngrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // not supported!
    }

    /**
     * Bypass the upgrade process (for each increment up to a given version) and simply
     * overwrite the existing database with the supplied asset file.
     *
     * @param version bypass upgrade up to this version number - should never be greater than the
     *                latest database version.
     *
     * @deprecated use {@link #setForcedUpgrade} instead.
     */
    @Deprecated
    public void setForcedUpgradeVersion(int version) {
        setForcedUpgrade(version);
    }

    /**
     * Bypass the upgrade process (for each increment up to a given version) and simply
     * overwrite the existing database with the supplied asset file.
     *
     * @param version bypass upgrade up to this version number - should never be greater than the
     *                latest database version.
     */
    public void setForcedUpgrade(int version) {

        mForcedUpgradeVersion = version;
    }

    /**
     * Bypass the upgrade process for every version increment and simply overwrite the existing
     * database with the supplied asset file.
     */
    public void setForcedUpgrade() {
        setForcedUpgrade(mNewVersion);
    }
   
    private SQLiteDatabase createOrOpenDatabase(boolean force) throws SQLiteAssetException {

        // test for the existence of the db file first and don't attempt open
        // to prevent the error trace in log on API 14+
//	Log.w(TAG, "createOrOpenDatabase");
        SQLiteDatabase db = null;
        File file = new File (mDatabasePath + "/" + mName);  //internal app database path
        if (file.exists()) {
//	    Log.w(TAG, "createOrOpenDatabase file.exist "+mDatabasePath+"/"+mName);
            db = returnDatabase();
        }
        //SQLiteDatabase db = returnDatabase();

        if (db != null) {
            // database already exists
            if (force) {
//                Log.w(TAG, "forcing database upgrade!");
                copyDatabaseFromAssets();
                db = returnDatabase();
            }
            return db;
        } else {
//		Log.w(TAG, "createOrOpenDatabase db == null)");
            // database does not exist, copy it from assets and return it
            copyDatabaseFromAssets();
            db = returnDatabase();
            return db;
        }
    }
    
    public SQLiteDatabase returnDatabase(String dbPath,  String dbName) throws IOException { //by jmpessoa    	
    	mDatabasePath = dbPath;   //app internal database path 	    
    	mName = dbName;
    	DATABASE_NAME = mName;    	
        try {
        	File file1 = new File(mDatabasePath);
        	if(!file1.exists()){
        		file1.mkdir();
        	}
        	
        	File file = new File(mDatabasePath + "/" + mName);
        	if (!file.exists()) { 
        		file.createNewFile();
                                            	  
            }
        	
        	if(file.exists()){
        	  	mDatabase = SQLiteDatabase.openOrCreateDatabase(mDatabasePath + "/" + mName, mFactory);        	        	
                Log.i(TAG, "successfully opened database " + mName);  
        	}
        	else {
            	 Log.i(TAG, "fail to open database, file not exists! " + mName);
            }
        	
        } catch (SQLiteException e) {
            Log.w(TAG, "could not open database " + mName + " - " + e.getMessage());
            return null;
        }
		return mDatabase;
    }
  
    private SQLiteDatabase returnDatabase(){
        try {
            SQLiteDatabase db = SQLiteDatabase.openDatabase(mDatabasePath + "/" + mName, mFactory, (SQLiteDatabase.OPEN_READWRITE | SQLiteDatabase.NO_LOCALIZED_COLLATORS));
//            Log.i(TAG, "successfully opened database " + mName);
            return db;
        } catch (SQLiteException e) {
//            Log.w(TAG, "could not open database " + mName + " - " + e.getMessage());
            return null;
        }
    }

    private void copyDatabaseFromAssets() throws SQLiteAssetException {
        Log.w(TAG, "copying database from assets...");

        String path = mAssetPath;
        String dest = mDatabasePath + "/" + mName;
        InputStream is;
        boolean isZip = false;

        try {
            // try uncompressed
            is = mContext.getAssets().open(path);
        } catch (IOException e) {
            // try zip
            try {
                is = mContext.getAssets().open(path + ".zip");
                isZip = true;
            } catch (IOException e2) {
                // try gzip
                try {
                    is = mContext.getAssets().open(path + ".gz");
                } catch (IOException e3) {
                    SQLiteAssetException se = new SQLiteAssetException("Missing " + mAssetPath + " file (or .zip, .gz archive) in assets, or target folder not writable");
                    se.setStackTrace(e3.getStackTrace());
                    throw se;
                }
            }
        }

        try {
            File f = new File(mDatabasePath + "/");
            if (!f.exists()) { f.mkdir(); }
            if (isZip) {
                ZipInputStream zis = Utils.getFileFromZip(is);
                if (zis == null) {
                    throw new SQLiteAssetException("Archive is missing a SQLite database file");
                }
                Utils.writeExtractedFileToDisk(zis, new FileOutputStream(dest));
            } else {
                Utils.writeExtractedFileToDisk(is, new FileOutputStream(dest));
            }

            Log.w(TAG, "database copy complete");

        } catch (IOException e) {
            SQLiteAssetException se = new SQLiteAssetException("Unable to write " + dest + " to data directory");
            se.setStackTrace(e.getStackTrace());
            throw se;
        }
    }

    private InputStream getUpgradeSQLStream(int oldVersion, int newVersion) {
        String path = String.format(mUpgradePathFormat, oldVersion, newVersion);
        try {
            return mContext.getAssets().open(path);
        } catch (IOException e) {
            Log.w(TAG, "missing database upgrade script: " + path);
            return null;
        }
    }

    private void getUpgradeFilePaths(int baseVersion, int start, int end, ArrayList<String> paths) {

        int a;
        int b;

        InputStream is = getUpgradeSQLStream(start, end);
        if (is != null) {
            String path = String.format(mUpgradePathFormat, start, end);
            paths.add(path);
            //Log.d(TAG, "found script: " + path);
            a = start - 1;
            b = start;
            is = null;
        } else {
            a = start - 1;
            b = end;
        }

        if (a < baseVersion) {
            return;
        } else {
            getUpgradeFilePaths(baseVersion, a, b, paths); // recursive call
        }

    }

    /**
     * An exception that indicates there was an error with SQLite asset retrieval or parsing.
     */
    @SuppressWarnings("serial")
    public static class SQLiteAssetException extends SQLiteException {

        public SQLiteAssetException() {}

        public SQLiteAssetException(String error) {
            super(error);
        }
    }
    
    
    private boolean IsFileInRootAssets(String _fileName) {
        try {
  		   return Arrays.asList(mContext.getResources().getAssets().list("")).contains(_fileName);
  	    } catch (IOException e) {
  		   // TODO Auto-generated catch block		  
  		   e.printStackTrace();
  		   return  false;
  	    }
      }
    
}

/* 
 * LAMW -  LAZARUS ANDROID MODULE WIZARD
 * https://github.com/jmpessoa/lazandroidmodulewizard
 */

public class jSqliteDataAccess extends SQLiteAssetHelper {
//public class jSqliteDataAccess {

//	private static String DATABASE_NAME = "borsa.db";

 private long PasObj = 0; // Pascal Obj
 private Controls controls = null; // Control Class for Event

 private String[] storeTableCreateQuery = new String[30]; //max (30) create tables scripts
 private String[] storeTableName = new String[30]; //max (30)  tables name

 private int countTableName = 0;
 private int countTableQuery = 0;
 private int rowCount = 0;

 private SQLiteDatabase mydb = null;

 public Cursor cursor = null;

 public Bitmap bufBmp = null;

 private static String DATABASE_NAME;
 private static String DB_PATH;
 private static final int DATABASE_VERSION = 1;

 char selectColDelimiter;
 char selectRowDelimiter;

 public void SetSelectDelimiters(char coldelim, char rowdelim) {
  selectColDelimiter = coldelim;
  selectRowDelimiter = rowdelim;
 }

 public void AddTableName(String tabName) {
  storeTableName[countTableName] = tabName;
  countTableName++;
 }

 public void AddCreateTableQuery(String queryCreateTable) {
  storeTableCreateQuery[countTableQuery] = queryCreateTable;
//storeTableCreateQuery[countTableQuery] = getWritableDatabase; // renabor
  countTableQuery++;
 }

 public void CreateAllTables() {
  SQLiteDatabase mydb = getWritableDatabase();
  for (int i = 0; i < countTableQuery - 1; i++) {
   mydb.execSQL(storeTableCreateQuery[i]);
  }
 }

 public void DropAllTables(boolean recreate) {
  SQLiteDatabase mydb = getWritableDatabase();
  //drop All tables
  for (int i = 0; i < countTableName - 1; i++) {
   mydb.execSQL("DROP TABLE IF EXISTS " + storeTableName[i]);
  }

  if (recreate = true) {
   CreateAllTables();
  }
  if (mydb != null) mydb.close();
 }

 //constructor ...
 public jSqliteDataAccess(Controls ctrls, long pasobj, String dbName, char colDelim, char rowDelim) {
// io chiamo super
  super(ctrls.activity, dbName, null, DATABASE_VERSION); // DATABASE_VERSION dovrebbe arrivare dalla chiamata init !!!

  PasObj = pasobj;
  controls = ctrls;
  selectColDelimiter = colDelim;
  selectRowDelimiter = rowDelim;
  DATABASE_NAME = dbName;
  DB_PATH = controls.activity.getDatabasePath(dbName).getPath();
 }

 //by jmpessoa
 public void OpenOrCreate(String dataBaseName) throws IOException { 
   String DATABASE_NAME = dataBaseName;  
   DB_PATH = controls.activity.getApplicationInfo().dataDir + "/databases"; 
   mydb = returnDatabase(DB_PATH, DATABASE_NAME);  
 }

 public void SetVersion(int version) {
  SQLiteDatabase mydb = getWritableDatabase();
  if (mydb != null) {
   mydb.setVersion(version);
  }
 }
 
 public int GetVersion() {
  SQLiteDatabase mydb = getWritableDatabase();
  if (mydb != null) {
   return mydb.getVersion();
  }
  return 0;
 }
 
 public int GetRowCount() {
  return rowCount;
 }
 
 public void ExecSQL(String execQuery) {
   SQLiteDatabase mydb = getWritableDatabase();
   //Log.i("Showmessage execsql", execQuery);
  try {
   mydb.beginTransaction();
   try {
    mydb.execSQL(execQuery); //Execute a single SQL statement that is NOT a SELECT or any other SQL statement that returns data.
    //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
   } catch (Exception e) {
    e.printStackTrace();
   } finally {
    // transaction over
    mydb.setTransactionSuccessful();
    mydb.endTransaction();
    mydb.close();
   }
  } catch (SQLiteException e) {
   Log.e(getClass().getSimpleName(), "Could not execute: " + execQuery);

  }
 }

 //by jmpessoa
 private int GetDrawableResourceId(String _resName) {
  try {
   Class < ? > res = R.drawable.class;
   Field field = res.getField(_resName); //"drawableName"
   int drawableId = field.getInt(null);
   return drawableId;
  } catch (Exception e) {
   Log.e("jSqliteDataAccess", "Failure to get drawable id.", e);
   return 0;
  }
 }

 //by jmpessoa
 private Drawable GetDrawableResourceById(int _resID) {
  return this.controls.activity.getResources().getDrawable(_resID);
 }

 public void UpdateImage(String tabName, String imageFieldName, String keyFieldName, Bitmap imageValue, int keyValue) {
  SQLiteDatabase mydb = getWritableDatabase();
  ByteArrayOutputStream stream = new ByteArrayOutputStream();
  bufBmp = imageValue;
  bufBmp.compress(CompressFormat.PNG, 0, stream);
  byte[] image_byte = stream.toByteArray();
  //Log.i("UpdateImage","UPDATE " + tabName + " SET "+imageFieldName+" = ? WHERE "+keyFieldName+" = ?");

  mydb.beginTransaction();
  try {
   mydb.execSQL("UPDATE " + tabName + " SET " + imageFieldName + " = ? WHERE " + keyFieldName + " = ?", new Object[] {
    image_byte,
    keyValue
   });
   //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
   mydb.setTransactionSuccessful();
  } catch (Exception e) {
   e.printStackTrace();
  } finally {
   // transaction over
   mydb.endTransaction();
   if (mydb != null) mydb.close();
  }
  bufBmp = null;
 }

 public void UpdateImage(String tabName, String imageFieldName, String keyFieldName, byte[] imageValue, int keyValue) {
  SQLiteDatabase mydb = getWritableDatabase();
  mydb.beginTransaction();
  try {
   mydb.execSQL("UPDATE " + tabName + " SET " + imageFieldName + " = ? WHERE " + keyFieldName + " = ?", new Object[] {
    imageValue,
    keyValue
   });
   //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
   mydb.setTransactionSuccessful();
  } catch (Exception e) {
   e.printStackTrace();
  } finally {
   // transaction over
   mydb.endTransaction();
   if (mydb != null) mydb.close();
  }
 }

 public String Select(String selectQuery) { //return String
  //Log.i("0. sqlitehelper banche", "FUNCTION " + selectQuery);
  SQLiteDatabase mydb = getReadableDatabase();
  String row = "";
  String rows = "";
  String colValue;
  String headerRow;
  int colCount;
  int i;
  String allRows = "";
  try {
   cursor = mydb.rawQuery(selectQuery, null);
   rowCount = cursor.getCount();
   colCount = cursor.getColumnCount();
   headerRow = "";
   
   for (i = 0; i < colCount; i++) {
      headerRow = headerRow + cursor.getColumnName(i) + selectColDelimiter;
   }
   
   headerRow = headerRow.substring(0, headerRow.length() - 1);
   
   if (cursor.moveToFirst()) {
	   
    do {
    	
     row = "";
     colValue = "";
     
     for (i = 0; i < colCount; i++) {
        switch (cursor.getType(i)) {
        
        case Cursor.FIELD_TYPE_INTEGER:
              colValue = Integer.toString(cursor.getInt(i));
        break;
        case Cursor.FIELD_TYPE_STRING:
              colValue = cursor.getString(i);
        break;
        case Cursor.FIELD_TYPE_FLOAT:
              colValue = String.format("%.3f", cursor.getFloat(i));
        break;
        case Cursor.FIELD_TYPE_BLOB:
              colValue = "BLOB";
        break;
        case Cursor.FIELD_TYPE_NULL:
              colValue = "NULL";
        break;
        default:
              colValue = "UNKNOW";
              
      }
         
      row = row + colValue + selectColDelimiter;
      
     }
     
     row = row.substring(0, row.length() - 1);
     rows = rows + row + selectRowDelimiter;

    } while ( cursor.moveToNext() );
    
   }
   
   rows = rows.substring(0, rows.length() - 1);  //drop the last row delimiter
   allRows = headerRow + selectRowDelimiter + rows;
   
  } catch (SQLiteException se) {
	   if (mydb != null) mydb.close();
	   allRows = "";
       Log.e(getClass().getSimpleName(), "Could not select:" + selectQuery);
  }
  
  cursor.moveToFirst();  //reset cursor ...
  if (mydb != null) mydb.close();

  return allRows;
 }

 public boolean Select(String selectQuery, boolean moveToLast) { //just set the cursor! return void..
  SQLiteDatabase mydb = getReadableDatabase();
  boolean result = true;
  try {
   this.cursor = mydb.rawQuery(selectQuery, null);
   rowCount = this.cursor.getCount();
   //Log.i("sqlite banche rowcount", Integer.toString(rowCount));
   this.cursor.moveToFirst();
   if (mydb != null) mydb.close();
  } catch (SQLiteException se) {
   result = false;
   Log.e(getClass().getSimpleName(), "Could not select:" + selectQuery);
  }
  return result;
 }


 public Cursor GetCursor() {
  if (this.cursor != null) return this.cursor;
  return null;
 }

 public void CreateTable(String execQuery) {
  SQLiteDatabase mydb = getWritableDatabase();
  try {
   mydb.beginTransaction();
   try {
    mydb.execSQL(execQuery); //Execute a single SQL statement that is NOT a SELECT or any other SQL statement that returns data.
    //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
   } catch (Exception e) {
    e.printStackTrace();
   } finally {
    // transaction over
    mydb.setTransactionSuccessful();
    mydb.endTransaction();
   }
  } catch (SQLiteException se) {
   Log.e(getClass().getSimpleName(), "Could not execute: " + execQuery);

  }	      
 }

 //ex: "INSERT INTO TABLE1 (NAME, PLACE) VALUES('CODERZHEAVEN','GREAT INDIA')"
 public void InsertIntoTable(String query) {
  SQLiteDatabase mydb = getWritableDatabase();
  mydb.execSQL(query);
  if (mydb != null) mydb.close();
 }

 //ex: "UPDATE TABLE1 SET NAME = 'MAX' WHERE PLACE = 'USA'"
 public void UpdateTable(String query) {
  SQLiteDatabase mydb = getWritableDatabase();
  mydb.execSQL(query);
  if (mydb != null) mydb.close();
 }

 //ex: "DELETE FROM TABLE1  WHERE PLACE = 'USA'";
 public void DeleteFromTable(String query) {
  SQLiteDatabase mydb = getWritableDatabase();
  mydb.execSQL(query);
  if (mydb != null) mydb.close();
 }

 //ex:  "TABLE1" 
 public void DropTable(String tbName) {
  SQLiteDatabase mydb = getWritableDatabase();
  mydb.execSQL("DROP TABLE " + tbName);
  if (mydb != null) mydb.close();
 }

 //Check if the database exist... 
 public boolean CheckDataBaseExists(String dbPath) {
  SQLiteDatabase checkDB = null;
  try {
   String myPath = dbPath; //"data/data/com.example.appsqlitedemo1/databases/" + dbName;
   checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
  } catch (SQLiteException e) {
   Log.e("SQLiteDatabase", "database does't exist yet.");
  }
  if (checkDB != null) {
   checkDB.close();
  }
  return checkDB != null;
 }

 public void Close() {
  SQLiteDatabase mydb = getWritableDatabase();
  if (mydb != null) {
   if (mydb.isOpen()) {
    mydb.close();
   }
  }
 }

 public void Free() {
  SQLiteDatabase mydb = getWritableDatabase();
  if (mydb != null) {
   if (mydb.isOpen()) {
    mydb.close();
   }
   mydb = null;
  }
  if (this.cursor != null) {
   this.cursor.close(); // = null;
  }
 }

 //news! version 06 rev. 08 15 december 2014.........................
 public void SetForeignKeyConstraintsEnabled(boolean _value) {
  SQLiteDatabase mydb = getWritableDatabase();
  if (mydb != null) {	  
	  //[ifdef_api16up]
	   if(Build.VERSION.SDK_INT >= 16) 
	        mydb.setForeignKeyConstraintsEnabled(_value);
	 //[endif_api16up]	  
  }      
  if (mydb != null) mydb.close();
 }
 
 public void SetDefaultLocale() {
  SQLiteDatabase mydb = getWritableDatabase();
  if (mydb != null)
   mydb.setLocale(Locale.getDefault());
  if (mydb != null) mydb.close();
 }

 public void DeleteDatabase(String _dbName) {
  SQLiteDatabase mydb = getWritableDatabase();
  this.cursor.close();
  mydb.close();
  //Log.i("sqlitehelper DeleteDb", "delete " + _dbName);
  controls.activity.deleteDatabase(_dbName);
  if (mydb != null) mydb.close();
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
  byte[] image_byte = stream.toByteArray();
  SQLiteDatabase mydb = getWritableDatabase();
  mydb.beginTransaction();
  try {
   mydb.execSQL("UPDATE " + _tabName + " SET " + _imageFieldName + " = ? WHERE " + _keyFieldName + " = ?", new Object[] {
    image_byte,
    _keyValue
   });
   //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
   mydb.setTransactionSuccessful();
  } catch (Exception e) {
   e.printStackTrace();
  } finally {
   // transaction over
   mydb.endTransaction();
   if (mydb != null) mydb.close();
  }
  //Log.i("UpdateImage", "Ok. Image Updated!");
  bufBmp = null;
 }

 public void InsertIntoTableBatch(String[] _insertQueries) {
  SQLiteDatabase mydb = getWritableDatabase();
  int i;
  int len = _insertQueries.length;
  for (i = 0; i < len; i++) {
   mydb.execSQL(_insertQueries[i]);
  }
  if (mydb != null) mydb.close();
 }

 public void UpdateTableBatch(String[] _updateQueries) {
  SQLiteDatabase mydb = getWritableDatabase();
  int i;
  int len = _updateQueries.length;
  for (i = 0; i < len; i++) {
   mydb.execSQL(_updateQueries[i]);
  }
  if (mydb != null) mydb.close();
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
        
    // ASSET_DB_PATH = "databases";   //default
    public void SetAssetsSearchFolder(String _folderName) {
    	this.ASSET_DB_PATH = _folderName;
    }
      
}

/**[by renabor]
 * Compare paths by their upgrade version numbers, instead of using
 * alphanumeric comparison on plain file names. This prevents the upgrade
 * scripts from being applied out of order when they first move to double-,
 * triple-, etc. digits.
 * <p>
 * For example, this fixes an upgrade that would apply 2 different upgrade
 * files from version 9 to 11 (<code>..._updated_9_10</code> and
 * <code>..._updated_10_11</code>) from using the <em>incorrect</em>
 * alphanumeric order of <code>10_11</code> before <code>9_10</code>.
 * </p>
 */
class VersionComparator implements Comparator<String> {

    private static final String TAG = SQLiteAssetHelper.class.getSimpleName();

    private Pattern pattern = Pattern
            .compile(".*_upgrade_([0-9]+)-([0-9]+).*");

    /**
     * Compares the two specified upgrade script strings to determine their
     * relative ordering considering their two version numbers. Assumes all
     * database names used are the same, as this function only compares the
     * two version numbers.
     *
     * @param file0
     *            an upgrade script file name
     * @param file1
     *            a second upgrade script file name to compare with file0
     * @return an integer < 0 if file0 should be applied before file1, 0 if
     *         they are equal (though that shouldn't happen), and > 0 if
     *         file0 should be applied after file1.
     *
     * @exception SQLiteAssetException
     *                thrown if the strings are not in the correct upgrade
     *                script format of:
     *                <code>databasename_fromVersionInteger_toVersionInteger</code>
     */
    @Override
    public int compare(String file0, String file1) {
        Matcher m0 = pattern.matcher(file0);
        Matcher m1 = pattern.matcher(file1);

        if (!m0.matches()) {
            Log.w(TAG, "could not parse upgrade script file: " + file0);
           // throw new SQLiteAssetException("Invalid upgrade script file");   //TODO
            throw new SQLException("Invalid upgrade script file");   
            
        }

        if (!m1.matches()) {
            Log.w(TAG, "could not parse upgrade script file: " + file1);
           // throw new SQLiteAssetException("Invalid upgrade script file");   //TODO
            throw new SQLException("Invalid upgrade script file");   
        }

        int v0_from = Integer.valueOf(m0.group(1));
        int v1_from = Integer.valueOf(m1.group(1));
        int v0_to = Integer.valueOf(m0.group(2));
        int v1_to = Integer.valueOf(m1.group(2));

        if (v0_from == v1_from) {
            // 'from' versions match for both; check 'to' version next

            if (v0_to == v1_to) {
                return 0;
            }

            return v0_to < v1_to ? -1 : 1;
        }

        return v0_from < v1_from ? -1 : 1;
    }
}

//[by renabor]
class Utils {

    private static final String TAG = SQLiteAssetHelper.class.getSimpleName();

    public static List<String> splitSqlScript(String script, char delim) {
        List<String> statements = new ArrayList<String>();
        StringBuilder sb = new StringBuilder();
        boolean inLiteral = false;
        char[] content = script.toCharArray();
        for (int i = 0; i < script.length(); i++) {
            if (content[i] == '"') {
                inLiteral = !inLiteral;
            }
            if (content[i] == delim && !inLiteral) {
                if (sb.length() > 0) {
                    statements.add(sb.toString().trim());
                    sb = new StringBuilder();
                }
            } else {
                sb.append(content[i]);
            }
        }
        if (sb.length() > 0) {
            statements.add(sb.toString().trim());
        }
        return statements;
    }

    public static void writeExtractedFileToDisk(InputStream in, OutputStream outs) throws IOException {
        byte[] buffer = new byte[1024];
        int length;
        while ((length = in.read(buffer))>0){
            outs.write(buffer, 0, length);
        }
        outs.flush();
        outs.close();
        in.close();
    }

    public static ZipInputStream getFileFromZip(InputStream zipFileStream) throws IOException {
        ZipInputStream zis = new ZipInputStream(zipFileStream);
        ZipEntry ze;
        while ((ze = zis.getNextEntry()) != null) {
            Log.w(TAG, "extracting file: '" + ze.getName() + "'...");
            return zis;
        }
        return null;
    }

    public static String convertStreamToString(InputStream is) {
        return new Scanner(is).useDelimiter("\\A").next();
    }

}
