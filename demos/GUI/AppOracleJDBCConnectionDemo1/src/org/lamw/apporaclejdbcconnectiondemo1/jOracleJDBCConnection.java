package org.lamw.apporaclejdbcconnectiondemo1;

/**
 * MainActivity.java
 * Created by Abhijeet Singh
 * www.absingh.com
 * https://hasanjawaid.blogspot.com/2018/01/how-to-connect-android-app-with-oracle.html
 * https://github.com/cseas/android-ojdbc
 */
import android.content.Context;
//import android.content.res.AssetManager;
//import java.io.IOException;
//import java.io.InputStream;
//import java.util.Properties;
import android.os.StrictMode;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Locale;
//import static oracle.net.aso.C12.e;

/*
class Util {
    public static String getProperty(String key,Context context) throws IOException {
        Properties properties = new Properties();;
        AssetManager assetManager = context.getAssets();
        InputStream inputStream = assetManager.open("config.properties");
        properties.load(inputStream);
        return properties.getProperty(key);
    }
}
*/

/*Draft java code by "Lazarus Android Module Wizard" [3/29/2019 23:15:43]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

public class jOracleJDBCConnection /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context context   = null;

    String DEFAULT_DRIVER = "oracle.jdbc.driver.OracleDriver";
    String DEFAULT_URL =    "jdbc:oracle:thin:@192.168.43.47:1521:XE";
    String DEFAULT_USERNAME;
    String DEFAULT_PASSWORD;

    //java.sql.Connection
    private Connection connection = null;
    private Locale locale = Locale.ENGLISH;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jOracleJDBCConnection(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;

        if (android.os.Build.VERSION.SDK_INT > 9) {
            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
            StrictMode.setThreadPolicy(policy);
        }
    }

    public void jFree() {
        //free local objects...
        Close();
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public Connection createConnection(String driver, String url, String username, String password) throws ClassNotFoundException, SQLException {
        Class.forName(driver);
        Locale.setDefault(locale);
        return DriverManager.getConnection(url, username, password);
    }

    public Connection createConnection() throws ClassNotFoundException, SQLException {
        //try {
            //DEFAULT_USERNAME = Util.getProperty("username",controls.activity.getApplicationContext());
            //DEFAULT_PASSWORD = Util.getProperty("password",controls.activity.getApplicationContext());
        //} catch (IOException e) {
          //  e.printStackTrace();
        //}
        return createConnection(DEFAULT_DRIVER, DEFAULT_URL, DEFAULT_USERNAME, DEFAULT_PASSWORD);
    }

    //java.sql.Connection
    public boolean Open() {
        boolean res = false;
        try {
            res = true;
            this.connection = createConnection();
        }
        catch (Exception e) {
            res = false;
            //Toast.makeText(MainActivity.this, ""+e, Toast.LENGTH_SHORT).show();
            e.printStackTrace();
        }
        return res;
    }

    public String ExecuteQuery(String _sqlQuery) {

        String res = "";
        Statement stmt = null;

        if (connection != null) {

          try {
              //Toast.makeText(MainActivity.this, "Connected", Toast.LENGTH_SHORT).show();
              stmt = connection.createStatement();
              StringBuffer stringBuffer = new StringBuffer();

              ResultSet rs = stmt.executeQuery(_sqlQuery); //"select * from student"

              ResultSetMetaData rsmd = rs.getMetaData();
              int columnsNumber = rsmd.getColumnCount();
              // print column names
              for(int i=1; i<=columnsNumber; i++) {
                  stringBuffer.append(rsmd.getColumnName(i) + "\t\t\t\t");
              }
              stringBuffer.append("\n");

              while (rs.next()) {
                 for (int i = 1; i <= columnsNumber; i++) {
                    if (i > 1)
                        stringBuffer.append(",\t\t\t");
                    String columnValue = rs.getString(i);
                    stringBuffer.append(columnValue);
                 }
                 stringBuffer.append("\n");
              }
              res =  stringBuffer.toString();
            //tv.setText(stringBuffer.toString());
          }
          catch (Exception e) {
              res = "";
            //Toast.makeText(MainActivity.this, ""+e, Toast.LENGTH_SHORT).show();
            e.printStackTrace();
          } finally {
              if (stmt != null) {
                  try {
                      stmt.close();
                  } catch (SQLException e) {
                      e.printStackTrace();
                  }
              }
          }

        }
        return res;
    }

    //https://www.mkyong.com/jdbc/jdbc-statement-example-insert-a-record/
    public boolean ExecuteUpdate(String _sqlExecute) {
      boolean res = false;
      if (connection != null) {
         Statement stmt = null;
         try {
             stmt = connection.createStatement();
             stmt.executeUpdate(_sqlExecute);  //String.format "UPDATE %s SET userid = '%s' WHERE tkey = 1000", TABLE_NAME, adminUserId)
             res = true;
         } catch (SQLException e) {
             res = false;
             e.printStackTrace();
         } finally {

            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
      }
      return res;
    }

    public void Close() {
       if (connection != null) {
           try {
               connection.close();
           } catch (SQLException e) {
               e.printStackTrace();
           }
       }
    }

    public  void SetDriver(String _driver) {
        DEFAULT_DRIVER = _driver; //"oracle.jdbc.driver.OracleDriver";
    }
    public  void SetUrl(String _url) {
        DEFAULT_URL = _url; //"jdbc:oracle:thin:@192.168.43.47:1521:XE";
    }

    public  void SetUserName(String _username) {
        DEFAULT_USERNAME = _username;
    }

    public  void SetPassword(String _password) {
        DEFAULT_PASSWORD = _password;
    }

    public void SetLanguage(int _language) {

        switch (_language) {
            case 0:
                locale = Locale.getDefault();
                break;
            case 1:
                locale = Locale.CANADA;
                break;
            case 2:
                locale = Locale.CANADA_FRENCH;
                break;
            case 3:
                locale = Locale.CHINESE;
                break;
            case 4:
                locale = Locale.ENGLISH;
                break;
            case 5:
                locale = Locale.FRENCH;
                break;
            case 6:
                locale = Locale.GERMAN;
                break;
            case 7:
                locale = Locale.ITALIAN;
                break;
            case 8:
                locale = Locale.JAPANESE;
                break;
            case 9:
                locale = Locale.KOREAN;
                break;
            case 10:
                locale = Locale.SIMPLIFIED_CHINESE;
                break;
            case 11:
                locale = Locale.TAIWAN;
                break;
            case 12:
                locale = Locale.TRADITIONAL_CHINESE;
                break;
            case 13:
                locale = Locale.UK;
                break;
            case 14:
                locale = Locale.US;
                break;
        }
    }

}
