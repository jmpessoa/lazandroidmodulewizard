package org.lamw.appjcentermikrotikrouterosdemo1;

import android.content.Context;
import android.util.Log;
import javax.net.SocketFactory;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import me.legrange.mikrotik.ApiConnection;
import me.legrange.mikrotik.MikrotikApiException;
import me.legrange.mikrotik.ResultListener;
import me.legrange.mikrotik.impl.ApiConnectionImpl;

/*Draft java code by "Lazarus Android Module Wizard" [4/16/2019 19:35:37]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref https://github.com/GideonLeGrange/mikrotik-java
public class jcMikrotikRouterOS /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    private String HOST;
    private String USERNAME = "admin";
    private String PASSWORD = "password";
    private int DEFAULT_PORT = ApiConnection.DEFAULT_PORT;  //8728

    private int CONNECTION_TIMEOUT = ApiConnection.DEFAULT_CONNECTION_TIMEOUT;  //60000

    private boolean logged = false;

    protected ApiConnectionImpl con;
    private static Locale locale = Locale.ENGLISH;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jcMikrotikRouterOS(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;
        Locale.setDefault(locale);
    }

    public void jFree() {
        //free local objects...
        try {
            Disconnect();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void SetUsername(String _Username) {
        USERNAME = _Username;
    }

    public void SetPassword(String _password) {
        PASSWORD = _password;
    }

    public boolean Connect(String _host) {
        boolean r = false;
        HOST = _host;
        try {
            con = (ApiConnectionImpl)ApiConnection.connect(SocketFactory.getDefault(), HOST, DEFAULT_PORT, CONNECTION_TIMEOUT);
            r = true;
        } catch (MikrotikApiException e) {
            r = false;
            e.printStackTrace();
        }
        return r;
    }

    public boolean IsConnected() {
        if (con == null)
            return false;
        else
            return con.isConnected();
    }

    public boolean Connect(String _host, int _port, int _timeout){
        boolean r = false;
        HOST = _host;
        try {
            con = (ApiConnectionImpl)ApiConnection.connect(SocketFactory.getDefault(), _host, _port, _timeout);
            r = true;
        } catch (MikrotikApiException e) {
            r = false;
            e.printStackTrace();
        }
        return r;
    }

    public boolean Login() {
        boolean r = false;
        if (con != null) {
            if (!IsConnected()) return r;
            try {
                con.login(USERNAME, PASSWORD);
                r = true;
            } catch (MikrotikApiException e) {
                r = false;
                e.printStackTrace();
            }
        }
        if (r) logged = true;
        return r;
    }

    public boolean Login(String _username, String _password) {
        boolean r = false;
        USERNAME = _username;
        PASSWORD = _password;
        if (con != null) {
            if (!IsConnected()) return r;
            try {
                con.login(USERNAME, PASSWORD);
                r = true;
            } catch (MikrotikApiException e) {
                r = false;
                e.printStackTrace();
            }
        }
        if (r) logged = true;
        return r;
    }

    public boolean IsLogged() {
        return logged;
    }

    public void Disconnect() throws Exception {
        logged = false;
        if (con != null)  con.close();
    }

    public boolean Execute(String _cmd) {
        boolean r = false;
        if (!IsConnected()) return r;
        if (!logged) return r;

        if (con != null) {
            try {
                con.execute(_cmd); //"/system/reboot"
                r = true;
            } catch (MikrotikApiException e) {
                r = false;
                e.printStackTrace();
            }
        }
        return r;
    }

    public String[] ExecuteForResult(String _cmd)  {
        ArrayList<String> list = new ArrayList<String>();
        List<Map<String, String>> results;

        list.add("ExecuteForResult:no such command...");

        if (!IsConnected()) return (String[])list.toArray();
        if (!logged) return (String[])list.toArray();

        if (con != null) {
            try {
                results = con.execute(_cmd); //"/interface/print"
                list.clear();
                for (Map<String, String> result : results) {
                    //Getting the Set of entries
                    Set<Map.Entry<String, String>> entrySet = result.entrySet();
                    //Creating an ArrayList Of Entry objects
                    ArrayList<Map.Entry<String, String>> listOfEntry = new ArrayList<Map.Entry<String, String>>(entrySet);
                    for (Map.Entry<String, String> entry : listOfEntry) {
                        //System.out.println(entry.getKey()+" : "+entry.getValue());
                        //Log.i(entry.getKey(), entry.getValue());
                        list.add(entry.getKey() + ":" + entry.getValue());
                    }
                    list.add("-*-*-*-*-*-*-*-*-*-");
                }
            } catch (MikrotikApiException e) {
                e.printStackTrace();
            }
        }
        String[] stringArray = list.toArray(new String[0]);
        return stringArray;
    }

    //"/interface/wireless/monitor .id=wlan1 .proplist=signal-strength"
    public boolean ExecuteAsync(String _cmd) throws MikrotikApiException, InterruptedException {

        if (!IsConnected()) return false;
        if (!logged) return false;

        String id = con.execute(_cmd, new ResultListener() {

            private int prev = 0;

            @Override
            public void receive(Map<String, String> results) {
                ArrayList<String> list = new ArrayList<String>();
                Set<Map.Entry<String, String>> entrySet = results.entrySet();
                ArrayList<Map.Entry<String, String>> listOfEntry = new ArrayList<Map.Entry<String, String>>(entrySet);
                for (Map.Entry<String, String> entry : listOfEntry) {
                    list.add(entry.getKey() + ":" + entry.getValue());
                }
                String[] stringArray = list.toArray(new String[0]);

                String SEPARATOR = "";
                StringBuilder strcat = new StringBuilder();
                for(int i1=0;i1<stringArray.length;i1++)
                {
                    strcat.append(SEPARATOR);
                    strcat.append(stringArray[i1]);
                    SEPARATOR = ";";
                    //Remove last comma
                    //csv = strcat.substring(0, strcat.length() - SEPARATOR.length());

                }
                controls.pOnMikrotikAsyncReceive(pascalObj, strcat.toString(), SEPARATOR);
            }

            @Override
            public void error(MikrotikApiException ex) {
                //System.out.printf("An error ocurred: %s\n", ex.getMessage());
                ex.printStackTrace();
            }

            @Override
            public void completed() {
                // System.out.printf("The request has been completed\n");
            }
        });
        // let it run for 60 seconds
        Thread.sleep(60000);
        con.cancel(id);
        return true;
    }
}


