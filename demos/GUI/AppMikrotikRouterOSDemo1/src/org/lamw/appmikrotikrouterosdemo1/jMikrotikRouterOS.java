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
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public void SetUsername(String _Username) {
        USERNAME = _Username;
    }

    public void SetPassword(String _password) {
        PASSWORD = _password;
    }

    public void Connect(String _host) throws Exception {
        HOST = _host;
        con = ApiConnection.connect(SocketFactory.getDefault(), HOST, ApiConnection.DEFAULT_PORT, 2000);
        con.login(USERNAME, PASSWORD);
    }

    public void Disconnect() throws Exception {
        con.close();
    }

    public void Execute(String _cmd) throws MikrotikApiException {
        con.execute(_cmd); //"/system/reboot"
    }

    public String[] ExecuteForResult(String _cmd) throws MikrotikApiException {
        ArrayList<String> list = new ArrayList<String>();
        List<Map<String, String>> results =  con.execute(_cmd); //"/interface/print"
        for (Map<String, String> result : results) {
            //Getting the Set of entries
            Set<Map.Entry<String, String>> entrySet = result.entrySet();
            //Creating an ArrayList Of Entry objects
            ArrayList<Map.Entry<String, String>> listOfEntry = new ArrayList<Map.Entry<String,String>>(entrySet);
            for (Map.Entry<String, String> entry : listOfEntry) {
                //System.out.println(entry.getKey()+" : "+entry.getValue());
                list.add(entry.getKey()+":"+entry.getValue());
            }
        }
        if (list.size() > 0)
           return (String[])list.toArray();
        else {
            list.add("0:0");
            return (String[])list.toArray();
        }
    }
}
