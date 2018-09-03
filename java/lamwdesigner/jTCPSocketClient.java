package com.example.apptcpclientdemo1;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
//import java.net.InetAddress;
import java.net.Socket;
import java.net.InetSocketAddress;

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
    
    private boolean mRun    = false;
    // used to send messages
    private PrintWriter mBufferOut;
    // used to read messages from the server
    private BufferedReader mBufferIn;
    private Socket  mSocket;
    //private boolean mExecutedForMessage = false;
    private int progressStep = -1;
           	
    private int mTimeOut = 300;
    
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

        if (mSocket != null) {
      	 try {
				mSocket.close();
				mSocket = null;
			 } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			 }
        }    	
    }
        
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
         
    public boolean Connect(String _serverIP, int _serverPort) {
      return Connect( _serverIP, _serverPort, mTimeOut ); // 300 LAN TIMEOUT 5000 INTERNET TIMEOUT
    }

    public boolean Connect(String _serverIP, int _serverPort, int _timeOut) {
    	  
          SERVER_IP   = _serverIP;         //IP address
          SERVER_PORT = _serverPort;       //port number;
          Boolean connected = false;

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
                   mBufferOut = null;
                   mBufferIn  = null;
		   mSocket = new Socket();
                   mSocket.connect( new InetSocketAddress(SERVER_IP, SERVER_PORT), _timeOut );
                   controls.pOnTCPSocketClientConnected(pascalObj);
                   if( mRun ) while( mBufferOut == null ){ if(!mRun) break; }; // Wait for run
                   connected = true;
		  } catch (IOException e) {
			  // TODO Auto-generated catch block
		      e.printStackTrace();
		  }

          if( connected && !mRun ){
           mBufferOut = null;
           mBufferIn  = null;
    	   new TCPSocketClientTask().execute();
           mRun = true;

           while( mBufferOut == null ){ if(!mRun) break; }; // Wait for run
          }

          return connected;
      }

    public boolean SendMessage(String message) {

        if ( mSocket == null )    return false;
        if ( mSocket.isClosed() ) return false;

        if (mBufferOut != null && !mBufferOut.checkError()) {
            mBufferOut.println(message);
            mBufferOut.flush();
            return true;
        }else
            return false;

    }

     public boolean Connect(String _serverIP, int _serverPort, String _login) {
    	 if( Connect(_serverIP,_serverPort) )
    	  if( SendMessage(_login) )
           return true;

         return false;
      }


      public void CloseConnection(String _finalMessage) {

          mRun    = false;
          
          if (mBufferOut != null) {
              mBufferOut.flush();
          }

          if (_finalMessage.equals(""))
              SendMessage("client_closed");
          else
              SendMessage(_finalMessage);

          if (mSocket != null) {
        	  try {
				mSocket.close();
				mSocket = null;
			  } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			  }
          }
      }

      public void CloseConnection() {
      	CloseConnection("client_closed");
      }

      class TCPSocketClientTask extends AsyncTask<String, String, String> {
          @Override
          protected String doInBackground(String... message) {
              mRun = true;

              //in this while the client listens for the messages sent by the server
              while (mRun) {

                        try {
                          if ( mSocket != null && !mSocket.isClosed()) {
    			    mBufferOut = new PrintWriter(new BufferedWriter(new OutputStreamWriter(mSocket.getOutputStream())), true);
    	                    mBufferIn  = new BufferedReader(new InputStreamReader(mSocket.getInputStream()));

    	                    if (mBufferIn != null)
                                mServerMessage = mBufferIn.readLine();

    	                    if (mServerMessage != null )
    	                       	publishProgress(mServerMessage);
                          }
    			} catch (IOException e) {
    		            // TODO Auto-generated catch block
    			    Log.e("jTCPSocketClient", "Error_doInBackground", e);
    			    e.printStackTrace();
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
              if( mSocket != null ){
               mSocket.close();
               mSocket = null;
              }
     	    } catch (IOException e) {
     			// TODO Auto-generated catch block
     			e.printStackTrace();
     	    }            
          }
        }
      
      /* https://stackoverflow.com/questions/6053602/what-arguments-are-passed-into-asynctaskarg1-arg2-arg3
       * Params, the type of the parameters sent to the task upon execution.
         Progress, the type of the progress units published during the background computation.
         Result, the type of the result of the background computation.
         
         X  The type of the input variables value you want to set to the background process.
              This can be an array of objects.
         Y  The type of the objects you are going to enter in the onProgressUpdate method.
         Z  The type of the result from the operations you have done in the background process.
       */
      
      class TCPSocketClientFileTask extends AsyncTask<String, Integer, String> {
    	  
    	  String localFullPath;
    	  File file;
    	  String filename;
    	  int filesize;
    	  int sentCount = 0;
    	  
    	  TCPSocketClientFileTask(String fullPath){
    		  localFullPath = fullPath; 
    		  file = new File(fullPath);
    	  }

          @Override
          protected String doInBackground(String... values) {
        	  
              if ( mSocket != null && !mSocket.isClosed()) {
                        try {
                        	
                            //DataInputStream dis = new DataInputStream(new BufferedInputStream(mSocket.getInputStream()));                        	
                        	
                        	/*
                        	mBufferIn = new BufferedReader(new InputStreamReader(mSocket.getInputStream()));
    	                    if (mBufferIn != null) mServerMessage = mBufferIn.readLine();    	                    
   	                        if (mServerMessage != null ) 
   	                        	publishProgress(mServerMessage);                     	
                            */
                        	
   	                        DataOutputStream dos = new DataOutputStream(new BufferedOutputStream(mSocket.getOutputStream()));
   	                                	 
                            //write file size
   	                        filesize = (int)file.length();
                            //publishProgress("Sending file size...");
   	                        /*
                            int file_size = (int)file.length();                            
                            dos.writeLong(file_size);
                            dos.flush();
                            */
   	                        
   	                        filename = file.getName();
                            //write file names
   	                        /*
                            publishProgress("Sending file name...");                            
                            dos.writeUTF( file.getName() );
                            dos.flush();
                            */
   	                        
                            //file writing
                            int n = 0;
                            byte[] buf;                            
                            if (progressStep <= 0)
                                buf = new byte[(int)file.length()];
                            else
                            	buf = new byte[progressStep];
                                                        
                            FileInputStream fis = new FileInputStream(file);
                            
                            //write file to dos
                            while((n = fis.read(buf)) != -1){
                                    dos.write(buf,0,n);
                                    dos.flush();
                                    sentCount = sentCount + n;
                                    publishProgress(sentCount);
                            }
                            
                            dos.close();
                            fis.close();
                            
                            //write file names                      	
                            //publishProgress("Sucess!!");                            
                                                        
    					} catch (IOException e) {
    						// TODO Auto-generated catch block
    						Log.e("jTCPSocketClient", "Error_doInBackground", e);
    						e.printStackTrace();
    					}   
                        
              }        	        	                           
              return null; //or String...
              
          }

          @Override
          protected void onProgressUpdate(Integer... values) {
              super.onProgressUpdate(values);
              controls.pOnTCPSocketClientFileSendProgress(pascalObj, filename, values[0], filesize);  //TODO
          }
          
          @Override
          protected void onPostExecute(String value) {    	  
            super.onPostExecute(value);   	  
            controls.pOnTCPSocketClientFileSendFinished(pascalObj, filename, filesize);  
            try {                	         	   
     	      if( mSocket != null ){
               mSocket.close();
               mSocket = null;
              }
     	    } catch (IOException e) {
     			// TODO Auto-generated catch block
     			e.printStackTrace();
     	    }            
          }
          
        }
      
      public void SendFile(String fullPath) {      	
      	 new TCPSocketClientFileTask(fullPath).execute();           	    	          
      }

      public void SetSendFileProgressStep(int _bytes) {
    	  if (_bytes > 512) 
    	     progressStep = _bytes;
    	  else
    	     progressStep = 512;    		  
      }
      
      public void SetTimeOut(int _millisecondsTimeOut) {
    	  mTimeOut = _millisecondsTimeOut;
      }

    //https://stackoverflow.com/questions/2878867/how-to-send-an-array-of-bytes-over-a-tcp-connection-java-programming
      private boolean sendBytes(byte[] myByteArray, int start, int len, boolean _writeLen) throws IOException {
        boolean  res = false;
        if (len < 0)
            throw new IllegalArgumentException("Negative length not allowed");
        if (start < 0 || start >= myByteArray.length)
            throw new IndexOutOfBoundsException("Out of bounds: " + start);
        // Other checks if needed.

        // May be better to save the streams in the support class;
        // just like the socket variable.
        if ( mSocket != null && !mSocket.isClosed()) {
            OutputStream out = mSocket.getOutputStream();
            DataOutputStream dos = new DataOutputStream(out);
            if (_writeLen) dos.writeInt(len);
            if (len > 0) {
                dos.write(myByteArray, start, len);
                dos.flush();
                dos.close();
                res = true;
            }
        }
        return res;
    }

    public boolean SendBytes(byte[] _jbyteArray, boolean _writeLength) throws IOException {
        return sendBytes(_jbyteArray, 0, _jbyteArray.length, _writeLength);
    }

}


