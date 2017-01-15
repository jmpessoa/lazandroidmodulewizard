package com.example.appudpsocketdemo1;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.net.UnknownHostException;
import android.content.Context;
import android.os.AsyncTask;

/*Draft java code by "Lazarus Android Module Wizard" [9/24/2016 17:11:35]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jUDPSocket /*extends ...*/ {
  
    private long pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context context   = null;
    private int mTimeout = -1; // not time out!
    private int mServerPort = 1611;   ////don't bind to ports lower than 1024!!! 
    private int mBufferLen = 2048;
    private boolean mRun = false;
    
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jUDPSocket(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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
        
    public void AsyncListen(int _port, int _bufferLen) {
        mServerPort = _port;     			
        mBufferLen  = _bufferLen;
        new UDPSocketListenTask().execute();                                    	  	
    }
    
    class UDPSocketListenTask extends AsyncTask<String, String, String> {
        @Override
        protected String doInBackground(String... message) {               
          mRun = true;          
          while(mRun) {    	
          	byte[] msg = new byte[mBufferLen]; 
          	DatagramPacket p = new DatagramPacket(msg, msg.length);    	
          	DatagramSocket s = null;
      		try {
      		   s = new DatagramSocket(mServerPort);
      		   
      		   if (mTimeout > 0) s.setSoTimeout(mTimeout);
      		   
      		   s.receive(p);      		   
      		   InetAddress address = p.getAddress();      		         		   
      		   String receivedText = new String(msg, 0, p.getLength()); 
      		   
      		   String[] params = new String[3];
      		   params[0] = receivedText;
      		   params[1] = address.getHostAddress();
      		   params[2] = String.valueOf(mServerPort); ////String.valueOf(p.getPort());  //from remote host or dhcp
      		   
      		   publishProgress(params);
      		   
      		} catch (SocketException e) {
      			e.printStackTrace();
      			mRun = false;
      		} catch (IOException e) {
      			e.printStackTrace();
      			mRun = false;
      		}finally {
      			if (s != null) s.close();
      		}
      	  }	             
          return null;
        }

        @Override
        protected void onProgressUpdate(String... values) {
            super.onProgressUpdate(values);            
            mRun = controls.pOnUDPSocketReceived(pascalObj ,values[0], values[1], Integer.valueOf( values[2]));             		    
        }
        
        @Override
        protected void onPostExecute(String values) {    	  
          super.onPostExecute(values);   	               
        }
      }
    
      public void StopAsyncListen() {
         mRun = false;
      }
            
      public void SetTimeout(int _miliTimeout) {
    	  mTimeout = _miliTimeout; 
      }
      
      public void Send(String _ip, int _port, String _message) {  
      	InetAddress serverAddr = null;		
  		DatagramSocket s = null;
  		try {
  		    s = new DatagramSocket();
  		    serverAddr = InetAddress.getByName(_ip);
  		    int msg_length=_message.length();
  		    byte[] message = _message.getBytes();
  		    DatagramPacket p = new DatagramPacket(message, msg_length, serverAddr, _port);
  		    
  		    if (mTimeout > 0) s.setSoTimeout(mTimeout);
  		    
  		    s.send(p);
  		    
  		} catch (SocketException e) {			
  			e.printStackTrace();
  		} catch (UnknownHostException e) {
  			e.printStackTrace();
  		} catch (IOException e) {
  			e.printStackTrace();
  		} finally {
  			if (s != null) {
  				s.close();
  			}
  		}
      }
                              
}
