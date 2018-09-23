package com.example.apptcpclientdemo1;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
//import java.net.InetAddress;
import java.io.UnsupportedEncodingException;
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
    private byte[] mServerBytes;

    private boolean mRun    = false;

    // used to send messages
    private PrintWriter mTextBufferOut; //Prints formatted representations of objects to a text-output stream
    // used to read messages from the server
    private BufferedReader mBufferIn;
    // used to send bytes
    private DataOutputStream mByteBufferOut;
    private OutputStream mStreamBufferOut;

    private Socket mSocket;
    private int progressStep = -1;
    private int mTimeOut = 5000;// 300 LAN TIMEOUT 5000 INTERNET TIMEOUT
    private int mDataType = 0; //0=text,  1=bytes, 3=file,
    private byte mCloseByte = -1;

    public jTCPSocketClient(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
 	       context   = _ctrls.activity;
    	   pascalObj = _Self;
    	   controls  = _ctrls; 	
    }

    public void jFree() {
       //free local objects...
        mTextBufferOut= null;;
        mBufferIn= null;
        mByteBufferOut = null;
        mStreamBufferOut = null;

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
                   mBufferIn  = null;
                   mStreamBufferOut = null;

		           mSocket = new Socket();
                   mSocket.connect( new InetSocketAddress(SERVER_IP, SERVER_PORT), _timeOut );
                   controls.pOnTCPSocketClientConnected(pascalObj);
                   if( mRun ) {
                           while (mStreamBufferOut == null) {
                               if (!mRun) break;
                           } // Wait for run
                   }
                   connected = true;
		  } catch (IOException e) {
			  // TODO Auto-generated catch block
		      e.printStackTrace();
		  }

          if( connected && !mRun ) {
              mBufferIn = null;
              mStreamBufferOut = null;

              if (mDataType == 0)   //string
                 new TCPSocketClientMessageTask().execute();
              else if (mDataType == 1)   //byte
                  new TCPSocketClientByteTask().execute();

              mRun = true;

              while (mStreamBufferOut == null) {
                      if (!mRun) break;
              }// Wait for run
          }

          return connected;
    }

    public boolean SendMessage(String message) {
        mDataType = 0;
        if ( mSocket == null )    return false;
        if ( mSocket.isClosed() ) return false;

        if (mStreamBufferOut != null ) { //&& !mBufferOut.checkError()
            mTextBufferOut = new PrintWriter(new BufferedWriter(new OutputStreamWriter(mStreamBufferOut)), true);
            if ( (mTextBufferOut != null)   && !mTextBufferOut.checkError()) {
                mTextBufferOut.println(message);
                mTextBufferOut.flush();
                return true;
            }
            else return false;
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
          
          if (mTextBufferOut != null) {
              mTextBufferOut.flush();
          }

          if (mByteBufferOut != null) {
              try {
                  mByteBufferOut.flush();
              } catch (IOException e) {
                  e.printStackTrace();
              }
          }

          if (mDataType == 0) {
                if (_finalMessage.equals(""))
                    SendMessage("client_closed");
               else
                   SendMessage(_finalMessage);
          } else if (mDataType == 1) {

              byte[] byteArray = new byte[1];
              byteArray[0] = mCloseByte;
              try {
                  SendBytes(byteArray, false);
              } catch (IOException e) {
                  e.printStackTrace();
              }

          }

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

      class TCPSocketClientMessageTask extends AsyncTask<String, String, String> {
          @Override
          protected String doInBackground(String... message) {
              mRun = true;

              //in this while the client listens for the messages sent by the server
              while (mRun) {

                        try {
                          if ( mSocket != null && !mSocket.isClosed()) {
                              mStreamBufferOut = mSocket.getOutputStream();
                              mBufferIn  = new BufferedReader(new InputStreamReader(mSocket.getInputStream()));

    	                      if (mBufferIn != null)
                                mServerMessage = mBufferIn.readLine();

    	                      if (mServerMessage != null )
    	                       	publishProgress(mServerMessage);
                          }
    			} catch (IOException e) {
    		            // TODO Auto-generated catch block
    			    Log.e("jTCPSocketClient", "Error_doInBackground_ClientMessage", e);
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


    class TCPSocketClientByteTask extends AsyncTask<String, /*byte[]*/ ByteArrayOutputStream, String> {

        byte[] headerBuffer;

        @Override
        protected String doInBackground(String... message) {
            mRun = true;
            //in this while the client listens for the messages sent by the server
            while (mRun) {

                try {
                    if ( mSocket != null && !mSocket.isClosed()) {

                        mStreamBufferOut = mSocket.getOutputStream();
                        //mBufferIn  = new BufferedReader(new InputStreamReader(mSocket.getInputStream()));
                        mServerMessage = null;
                        mServerBytes = new byte[1024];
                        BufferedInputStream mBufferInput = new BufferedInputStream(mSocket.getInputStream());
                        int bytes_read = -1;
                        ByteArrayOutputStream bufferOutput = new ByteArrayOutputStream();

                        if (mBufferInput!=null) {
                            bytes_read =  mBufferInput.read(mServerBytes, 0, mServerBytes.length);   //blocking ...
                            if (bytes_read > 0) {
                                bufferOutput.write(mServerBytes, 0, bytes_read);
                                publishProgress(bufferOutput);
                            }
                        }

                    }
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    Log.e("jTCPSocketClient", "Error_doInBackground_ClientByte", e);
                    e.printStackTrace();
                }

            }

            return null;
        }

        @Override
        protected void onProgressUpdate(/*byte[]*/ ByteArrayOutputStream... values) {
            super.onProgressUpdate(values);
            if (values[0].toByteArray().length > 0 ) {
                controls.pOnTCPSocketClientBytesReceived(pascalObj, /*values[0]*/values[0].toByteArray());
            }
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

   	                        DataOutputStream dos = new DataOutputStream(new BufferedOutputStream(mSocket.getOutputStream()));
   	                                	 
                            //write file size
   	                        filesize = (int)file.length();
                            filename = file.getName();

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

    					} catch (IOException e) {
    						// TODO Auto-generated catch block
    						Log.e("jTCPSocketClient", "Error_doInBackground_ClientFileTask", e);
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
    private boolean sendBytes(byte[] myByteArray, int start, int len, boolean _writeLen) {
        if ( mSocket == null )    return false;
        if ( mSocket.isClosed() ) return false;

        if (mStreamBufferOut != null ) {
            mByteBufferOut = new DataOutputStream(mStreamBufferOut);
            if (_writeLen) {
                try {
                    mByteBufferOut.writeInt(len);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (len > 0) {
                try {
                    mByteBufferOut.write(myByteArray, start, len);
                    mByteBufferOut.flush();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return true;
        }else
            return false;

    }

    public boolean SendBytes(byte[] _jbyteArray, boolean _writeLength) throws IOException {
        return sendBytes(_jbyteArray, 0, _jbyteArray.length, _writeLength);
    }

    public void SetDataType(int _dataType) {
        mDataType = _dataType;
    }

    public void CloseConnection(byte _jbtyte) {
        mCloseByte = _jbtyte;
        CloseConnection();
    }
}


