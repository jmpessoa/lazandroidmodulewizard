package org.lamw.appmssqljdbcconnectiondemo1;

import android.content.Context;
import android.annotation.SuppressLint;
import android.os.AsyncTask;
import android.os.StrictMode;
import android.util.Log;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Locale;


/*Draft java code by "Lazarus Android Module Wizard" [8/18/2019 14:52:53]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref
//https://life-news.blog/2018/09/24/connect-sql-server-with-android-application-jdbc-driver-integration/
public class jMsSqlJDBCConnection /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;

    // Your IP address must be static otherwise this will not work. You //can get your Ip address
    //From Network and security in Windows.
    String ip = "000.000.000.00";

    // This is default if you are using JTDS driver.
    String classsDriver = "net.sourceforge.jtds.jdbc.Driver";

    // Name Of your database.
    String db = "MyDB";

    // Userame and password are required for security.
    //so Go to sql server and add username and password for your database.
    String un = "admin";
    String password = "password";
    private Locale locale =  Locale.ENGLISH;

    java.sql.Connection connection = null;
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jMsSqlJDBCConnection(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
    }

    public void jFree() {
        //free local objects...
        Close();
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    @SuppressLint("NewApi")
    public Connection createConnection() throws ClassNotFoundException, SQLException {

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        String ConnURL;
        Class.forName(classsDriver);
        Locale.setDefault(locale);

        ConnURL = "jdbc:jtds:sqlserver://" + ip + ";" + "databaseName=" + db + ";user=" + un + ";password=" + password + ";";
        return DriverManager.getConnection(ConnURL);
    }


    //java.sql.Connection
    public boolean Open() {
        boolean res = false;
        try {
            res = true;
            this.connection = createConnection();
        } catch (Exception e) {
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
                for (int i = 1; i <= columnsNumber; i++) {
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
                res = stringBuffer.toString();
                //tv.setText(stringBuffer.toString());
            } catch (Exception e) {
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

    /*
    public  void SetDrive(String _drive) {
        classsDriver = _drive; //"net.sourceforge.jtds.jdbc.Driver";
    }
    */

    public void SetServerIP(String _ip) {
        ip = _ip; // "jdbc:jtds:sqlserver://" + ip
    }

    public void SetUserName(String _username) {
        un = _username;
    }

    public void SetPassword(String _password) {
        password = _password;
    }

    public void SetDatabaseName(String _db) {
        db = _db;

    }


    public void OpenAsync() {
        DoLogin doLogin = new DoLogin(); // this is the Asynctask
        doLogin.execute("");
    }

    public class DoLogin extends AsyncTask<String, String, String> {

        String z = "";

        @Override
        protected void onPreExecute() {
            //
        }

        @Override
        protected void onPostExecute(String r) {
            //if (r.trim().equals("success")) {
                //controls.pOnConnection
            //}
            controls.pOnMsSqlJDBCConnectionOpenAsync(pascalObj, r.trim());
        }

        @Override
        protected String doInBackground(String... params) {

            if (un.trim().equals("") || password.trim().equals(""))
                z = "ErrorOnLogin";
            else {
                try {
                    Connection con = createConnection();
                    if (con == null) {
                        z = "ErrorOnConnection";
                    } else {
                        z = "Success";
                    }
                } catch (Exception ex) {
                    z = "Exception";
                }
            }
            return z;

        }
    }

    public void ExecuteQueryAsync(String _sqlQuery) {
        DoQuery doQuery = new DoQuery(_sqlQuery); // this is the Asynctask
        doQuery.execute("");
    }

    public class DoQuery extends AsyncTask<String, String, String> {

        String z = "";
        String query;

        public DoQuery(String q) {
           query = q;
        }

        @Override
        protected void onPreExecute() {
            //
        }

        @Override
        protected void onPostExecute(String r) {
            //if (r.trim().equals("success")) {
                //controls.pOnConnection
            //}
            controls.pOnMsSqlJDBCConnectionExecuteQueryAsync(pascalObj, r.trim());
        }

        @Override
        protected String doInBackground(String... params) {

                try {
                    if (connection != null) {
                        z = ExecuteQuery(query) ;
                    } else {
                        z = "Success";
                    }
                } catch (Exception ex) {
                    z = "Exception";
                }
            return z;

        }
    }

    /*
    Params [input], the type of the parameters sent to the task upon execution.
    Progress [], the type of the progress units published during the background computation.
    Result [output], the type of the result of the background computation.
     */

    public void ExecuteUpdateAsync(String _sqlQuery) {
        DoUpdate doUpdate = new DoUpdate(_sqlQuery); // this is the Asynctask
        doUpdate.execute("");
    }

    public class DoUpdate extends AsyncTask<String, Boolean, Boolean> {

        boolean z;
        String query;

        public DoUpdate(String q) {
            query = q;
        }

        @Override
        protected void onPreExecute() {
            //
        }

        @Override
        protected void onPostExecute(Boolean r) {
            if (r) {
                controls.pOnMsSqlJDBCConnectionExecuteUpdateAsync(pascalObj, "Success");
            }
            else {
                controls.pOnMsSqlJDBCConnectionExecuteUpdateAsync(pascalObj, "Error");
            }
        }

        @Override
        protected Boolean doInBackground(String... params) {

            try {
                if (connection != null) {
                    z = ExecuteUpdate(query) ;
                } else {
                    z = false;
                }
            } catch (Exception ex) {
                z = false;
            }
            return z;
        }
    }

    public void SetLanguage(int _language) {

        switch(_language) {
            case 0: locale = Locale.getDefault(); break;
            case 1: locale = Locale.CANADA; break;
            case 2: locale = Locale.CANADA_FRENCH; break;
            case 3: locale = Locale.CHINESE; break;
            case 4: locale = Locale.ENGLISH; break;
            case 5: locale = Locale.FRENCH; break;
            case 6: locale = Locale.GERMAN; break;
            case 7: locale = Locale.ITALIAN; break;
            case 8: locale = Locale.JAPANESE; break;
            case 9: locale = Locale.KOREAN; break;
            case 10: locale = Locale.SIMPLIFIED_CHINESE; break;
            case 11: locale = Locale.TAIWAN; break;
            case 12: locale = Locale.TRADITIONAL_CHINESE; break;
            case 13: locale = Locale.UK; break;
            case 14: locale = Locale.US; break;
        }

    }

}
