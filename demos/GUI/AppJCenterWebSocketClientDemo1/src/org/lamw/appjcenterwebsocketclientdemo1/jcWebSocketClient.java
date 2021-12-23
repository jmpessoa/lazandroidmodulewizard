package org.lamw.appjcenterwebsocketclientdemo1;
import android.content.Context;

import java.net.URI;
import java.net.URISyntaxException;

import tech.gusavila92.websocketclient.WebSocketClient;
import java.util.HashMap;
import java.util.Map;

/*Draft java code by "Lazarus Android Module Wizard" [12/22/2021 12:44:42]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//https://github.com/gusavila92/java-android-websocket-client
public class jcWebSocketClient /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    private WebSocketClient webSocketClient = null;

    int mConnectTimeout = 10000;
    int mReadTimeout = 60000;
    int mEnableAutomaticReconnection = -1; //5000;

    Map<String,String> mHeaders = new HashMap<String,String>();


    int wsPort = 80;
    int wssPort = 443;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jcWebSocketClient(Controls _ctrls, long _Self, String _strUri) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
        tryInit(_strUri);
    }

    public void jFree() {
      //free local objects...
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    private boolean tryInit(String _strUri) {

        if (webSocketClient != null) {
            webSocketClient.close();
        }

        URI uri;
        if (_strUri != null) {
            if(!_strUri.equals("")) {
                try {
                    uri = new URI(_strUri); //"ws://localhost:8080/test"
                } catch (URISyntaxException e) {
                    e.printStackTrace();
                    return false;
                }
                webSocketClient = new WebSocketClient(uri) {
                    @Override
                    public void onOpen() {
                        System.out.println("onOpen");
                        controls.pWebSocketClientOnOpen(pascalObj);
                    }

                    @Override
                    public void onTextReceived(String message) {
                        System.out.println("onTextReceived");
                        controls.pWebSocketClientOnTextReceived(pascalObj, message);
                    }

                    @Override
                    public void onBinaryReceived(byte[] data) {
                        System.out.println("onBinaryReceived");
                        controls.pWebSocketClientOnBinaryReceived(pascalObj, data);
                    }

                    @Override
                    public void onPingReceived(byte[] data) {
                        System.out.println("onPingReceived");
                        controls.pWebSocketClientOnPingReceived(pascalObj, data);
                    }

                    @Override
                    public void onPongReceived(byte[] data) {
                        System.out.println("onPongReceived");
                        controls.pWebSocketClientOnPongReceived(pascalObj, data);

                    }

                    @Override
                    public void onException(Exception e) {
                        System.out.println(e.getMessage());
                        controls.pWebSocketClientOnException(pascalObj, e.getMessage());
                    }

                    @Override
                    public void onCloseReceived() {
                        System.out.println("onCloseReceived");
                        controls.pWebSocketClientOnCloseReceived(pascalObj);
                    }
                };
            }
        }
        return true;
    }

    public void SetUri(String _strUri) {
        tryInit(_strUri);
    }

    public void SetConnectTimeout(int _millisecTimeout) {
        mConnectTimeout = _millisecTimeout;
    }

    public void SetReadTimeout(int _millisecTimeout) {
        mReadTimeout = _millisecTimeout;
    }

    public void EnableAutomaticReconnection(int _millisecWaitTime) {
        mEnableAutomaticReconnection = _millisecWaitTime;
    }

    public void AddHeader(String _name, String _value) {
        mHeaders.put( _name, _value);
    }

    public void Close() {
        if (webSocketClient != null) {
            webSocketClient.close();
        }
    }

    public void Connect() {
        if (webSocketClient != null) {
            webSocketClient.setConnectTimeout(mConnectTimeout); //10000
            webSocketClient.setReadTimeout(mReadTimeout); //60000

            if (mEnableAutomaticReconnection >= 0) {
                webSocketClient.enableAutomaticReconnection(mEnableAutomaticReconnection); //5000
            }

            if (!mHeaders.isEmpty()) {
                for (String key : mHeaders.keySet()) {
                    webSocketClient.addHeader(key, mHeaders.get(key));
                }
            }
            webSocketClient.connect();
        }
    }

    public void Send(String _message) {
        if (webSocketClient != null) {
            webSocketClient.send(_message);
        }
    }

    public void SendPing(byte[] _data) {
        if (webSocketClient != null) {
            webSocketClient.sendPing(_data);
        }
    }

    public void SendPong(byte[] _data) {
        if (webSocketClient != null) {
            webSocketClient.sendPong(_data);
        }
    }

}
