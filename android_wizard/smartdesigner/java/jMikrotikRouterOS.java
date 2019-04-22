package org.lamw.appmikrotikrouterosdemo1;

import android.content.Context;
import javax.net.SocketFactory;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import me.legrange.mikrotik.ApiConnection;
import me.legrange.mikrotik.MikrotikApiException;

/*Draft java code by "Lazarus Android Module Wizard" [4/16/2019 19:35:37]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref https://github.com/GideonLeGrange/mikrotik-java
public class jMikrotikRouterOS /*extends ...*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    private String HOST = "192.168.1.1";
    private String USERNAME = "admin";
    private String PASSWORD = "";
    private int DEFAULT_PORT = ApiConnection.DEFAULT_PORT;  //8728

    private int CONNECTION_TIMEOUT = ApiConnection.DEFAULT_CONNECTION_TIMEOUT;  //60000

    protected ApiConnection con;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jMikrotikRouterOS(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
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

    public boolean Connect(String _host) throws Exception {
        boolean r = false;
        HOST = _host;
        con = ApiConnection.connect(SocketFactory.getDefault(), HOST, DEFAULT_PORT, CONNECTION_TIMEOUT);
        con.login(USERNAME, PASSWORD);
        r = true;
        return r;
    }

    public boolean IsConnected() {
        return con.isConnected();
    }

    public boolean Connect(String _host, int _port, int _timeout) throws Exception {
        boolean r = false;
        HOST = _host;
        con = ApiConnection.connect(SocketFactory.getDefault(), _host, _port, _timeout);
        con.login(USERNAME, PASSWORD);
        r = true;
        return r;
    }

    public void Disconnect() throws Exception {
        if (con != null)  con.close();
    }

    public boolean Execute(String _cmd) throws MikrotikApiException {
        boolean r = false;
        if (con != null) {
            con.execute(_cmd); //"/system/reboot"
            r = true;
        }
        return r;
    }

    public String[] ExecuteForResult(String _cmd) throws MikrotikApiException {
        ArrayList<String> list = new ArrayList<String>();
        list.add("0:0");
        if (con != null) {
            List<Map<String, String>> results = con.execute(_cmd); //"/interface/print"
            for (Map<String, String> result : results) {
                //Getting the Set of entries
                Set<Map.Entry<String, String>> entrySet = result.entrySet();
                //Creating an ArrayList Of Entry objects
                ArrayList<Map.Entry<String, String>> listOfEntry = new ArrayList<Map.Entry<String, String>>(entrySet);
                list.clear();
                for (Map.Entry<String, String> entry : listOfEntry) {
                    //System.out.println(entry.getKey()+" : "+entry.getValue());
                    list.add(entry.getKey() + ":" + entry.getValue());
                }
            }
        }
        return (String[])list.toArray();
    }

}
