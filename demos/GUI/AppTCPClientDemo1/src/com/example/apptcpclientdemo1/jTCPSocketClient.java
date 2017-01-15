package com.example.apptcpclientdemo1;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.Socket;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

/**
 *         ref. http://www.myandroidsolutions.com/2013/03/31/android-tcp-connection-enhanced/
 *         ref. http://www.darksleep.com/player/SocketExample/
 */

/*Draft java code by "Lazarus Android Module Wizard" */
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jTCPSocketClient {

    private long  pascalObj = 0;      // Pascal Object
    Controls controls;    
    private Context  context   = null;
    
    private String SERVER_IP = "" ;//"192.168.0.100"   
    private int SERVER_PORT;
       
    // message to send to the server
    private String mServerMessage;
    
    private boolean mRun = false;
    // used to send messages
    private PrintWriter mBufferOut;
    // used to read messages from the server
    private BufferedReader mBufferIn;
    private Socket mSocket;
    
    //TCPSocketClientTask task;
           	
    public jTCPSocketClient(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
    	   //super(_ctrls.activity);
 	       context   = _ctrls.activity;
    	   pascalObj = _Self;
    	   controls  = _ctrls; 	
    }

    public void jFree() {
       //free local objects...
        mBufferOut= null;;
        mBufferIn= null;
        mSocket= null;    	
    }
   
    /**
     * Sends the message entered by client to the server
     */
    
    public void SendMessage(String message) {
    	
        if (mBufferOut != null && !mBufferOut.checkError()) {
            mBufferOut.println(message);
            mBufferOut.flush();
        }
    }
     
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
         
    public void Connect(String _serverIP, int _serverPort) {
    	  
          SERVER_IP = _serverIP;          //IP address
          SERVER_PORT = _serverPort;       //port number;
          if (mSocket != null) {
        	  try {
				mSocket.close();
				mSocket = null;
			  } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			  }
          }
          
          try {
              InetAddress serverAddr = InetAddress.getByName(SERVER_IP);
			  mSocket = new Socket(serverAddr, SERVER_PORT);
		  } catch (IOException e) {
			  // TODO Auto-generated catch block
		      e.printStackTrace();
		  }
          
          controls.pOnTCPSocketClientConnected(pascalObj);         
          new TCPSocketClientTask().execute();                                    	  
      }
            
     public void Connect(String _serverIP, int _serverPort, String _login) {    	  
    	 Connect(_serverIP,_serverPort);
    	 SendMessage(_login);       	  
      }
     
      public void CloseConnection(String _finalMessage) {                
          mRun = false;        
                        
          if (mBufferOut != null) {
               mBufferOut.flush();
          }
          if (_finalMessage.equals("")) 
              SendMessage("client_closed");
          else SendMessage(_finalMessage);
      }
      
      public void CloseConnection() {
      	CloseConnection("client_closed");
      }
                  
      class TCPSocketClientTask extends AsyncTask<String, String, String> {
      	
          @Override
          protected String doInBackground(String... message) {               
              mRun = true;
              while (mRun) {
                    if ( mSocket!= null && !mSocket.isClosed()) {             		
                        try {                    	
    						mBufferOut = new PrintWriter(new BufferedWriter(new OutputStreamWriter(mSocket.getOutputStream())), true);
    	                    mBufferIn = new BufferedReader(new InputStreamReader(mSocket.getInputStream()));              
    	                    //in this while the client listens for the messages sent by the server
    	                    if (mBufferIn != null)
    	                           mServerMessage = mBufferIn.readLine();
    	                    if (mServerMessage != null )                     	
    	                       	 publishProgress(mServerMessage);
    					} catch (IOException e) {
    						// TODO Auto-generated catch block
    						Log.e("jTCPSocketClient", "Error_doInBackground", e);
    						e.printStackTrace();
    					}                                 	                                         
               	    }        	        	             
              }
              return null;
          }

          @Override
          protected void onProgressUpdate(String... values) {
              super.onProgressUpdate(values);
              controls.pOnTCPSocketClientMessageReceived(pascalObj ,values);
          }
          
          @Override
          protected void onPostExecute(String values) {    	  
            super.onPostExecute(values);   	  
            try {                	         	   
     			mSocket.close();
     	    } catch (IOException e) {
     			// TODO Auto-generated catch block
     			e.printStackTrace();
     	    }            
          }
        }            
}


