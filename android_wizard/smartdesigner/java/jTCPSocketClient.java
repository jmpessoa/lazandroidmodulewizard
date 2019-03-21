package com.example.apptcpclientdemo1;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
//import java.net.InetAddress;
import java.io.UnsupportedEncodingException;
import java.net.Socket;
import java.net.InetSocketAddress;
import java.io.DataInputStream;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import android.widget.Toast;

import android.os.Handler;

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
    private Context  context = null;
    
    private String mServerIP      = "" ;//"192.168.1.100"   
    private int    mServerPort;
    private int    mServerTimeOut = 5000; // 300 LAN TIMEOUT 5000 INTERNET TIMEOUT
       
    // message to send to the server
    private String mServerMessage;
    private byte[] mServerBytes;

    private boolean mRun        = false;    
    private boolean mRunClose   = false;    
        
    private OutputStream     mStreamBufferOut;
    
    // used to send messages
    private PrintWriter mTextBufferOut; //Prints formatted representations of objects to a text-output stream
     
    // used to send bytes
    private DataOutputStream    mByteBufferOut;
    
    // used to get bytes
    private BufferedInputStream mByteBufferInput;
    
    // used to get file
    private String              mFileGetPath 		  = "";
    private int                 mFileGetSize 		  = 0;
    private int                 mFileGetSizeRemaining = 0;
    private FileOutputStream    mFileGetFOS  		  = null;
   
    // used to send file
    private DataOutputStream mFileSendDOS = null;  	    
    private FileInputStream  mFileSendFIS = null;    

    private Socket mSocket;
    private int progressStep = -1;
   
    private int mDataType = 0;   //0=dtmText,  1=dtmByte, 2=dtmGetFile, 3=dtmSendFile
    
    public jTCPSocketClient(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
 	       context   = _ctrls.activity;
    	   pascalObj = _Self;
    	   controls  = _ctrls; 	
    }

    public void jFree() {
       //free local objects...
       CloseConnection();    	
    }
        
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
         
    public boolean Connect(String _serverIP, int _serverPort) {
      return Connect( _serverIP, _serverPort, mServerTimeOut ); // 300 LAN TIMEOUT 5000 INTERNET TIMEOUT
    }

    public boolean Connect(String _serverIP, int _serverPort, int _timeOut) {
    	  
          mServerIP         = _serverIP;    //IP address
          mServerPort       = _serverPort;  //port number;
          mServerTimeOut    = _timeOut;     //timeout
          Boolean connected = false;

          if (mSocket != null)
        	  CloseConnection();
          
          try {                  
                   mSocket = new Socket();
                   mSocket.connect( new InetSocketAddress(mServerIP, mServerPort), mServerTimeOut );
                                      
                   connected = true;
		  } catch (IOException e) {
			  // TODO Auto-generated catch block
		      e.printStackTrace();
		      CloseConnection();
		      return false;
		  }

          if( connected && !mRun )                                                              
              if( mDataType < 3 ){
               mStreamBufferOut = null; 
            	  
               new TCPSocketClientGetAllTask().execute();
               
               while (mStreamBufferOut == null) {
                      if (!mRun) break;
               }// Wait for run*/
              }                                    
          
          if( connected ) controls.pOnTCPSocketClientConnected(pascalObj);

          return connected;
    }
    
    public boolean isConnected(){
    	
    	    if ( mSocket == null ) return false;
    	
            if ( !mSocket.isClosed() ){            	            
            	return mSocket.isConnected();
            }else
            	return false;    	
            
    }

    public boolean SendMessage(String message) {
        
    	if ( mSocket == null || mSocket.isClosed() ) return false;
    	
    	if ( mSocket.isClosed() || !mSocket.isConnected() ){
    		CloseConnection();
    		return false;
    	}
        
        try{
        	
         if( mTextBufferOut == null )
          mTextBufferOut = new PrintWriter(new BufferedWriter(new OutputStreamWriter(mSocket.getOutputStream())), true);                 
            
         if ( (mTextBufferOut != null) && !mTextBufferOut.checkError()) {
             mTextBufferOut.println(message);
             mTextBufferOut.flush();
             return true;
         } else{ 
        	 CloseConnection();        	
        	 return false;
         }
         
    	} catch (IOException e) {
    		// TODO Auto-generated catch block
    		CloseConnection();
    		return false;
    	}
        
    }    

    public void CloseConnection( ) {
    	  mRunClose   = true;
    	  
    	  if (mSocket != null) {
          	      			  
          	  try{ 
    				mSocket.close();				
    			  } catch (IOException e) {				
    			  }
          	  
          	  mSocket = null;
            }
                              
          if ( mStreamBufferOut != null ){
        	  try{
        		  mStreamBufferOut.close();					
  			  } catch (IOException e) {
  			  }
        	  
        	  mStreamBufferOut = null;
          }
           
          // for send text
          if ( mTextBufferOut != null ){        	  
        	  mTextBufferOut.close();					  			         	
        	  mTextBufferOut = null;
          }
          
          // for get bytes
          if ( mByteBufferInput   != null ){
        	  try{
        		  mByteBufferInput.close();					
  			  } catch (IOException e) {
  			  }
        	  
        	  mByteBufferInput = null;
          }
          
          // for send bytes
          if ( mByteBufferOut   != null ){
        	  try{
        		  mByteBufferOut.close();					
  			  } catch (IOException e) {
  			  }
        	  
        	  mByteBufferOut = null;
          }
           
          // for get files
          if (mFileGetFOS != null)	{                	
            try{
            	mFileGetFOS.close();					
    		} catch (IOException e) {
    		}
              
          	mFileGetFOS = null;
          }
          
          // for send files
          if (mFileSendFIS != null)	{                	
          	try{
				mFileSendFIS.close();					
			} catch (IOException e) {
			}
          
           mFileSendFIS = null;
          }
				
      	  if (mFileSendDOS != null){
			try{				
				mFileSendDOS.close();
			} catch (IOException e) {
			}
					
		   mFileSendDOS = null;
      	  }      	        	
          
          while (mRun){}; // Wait for run
          
      	  mRun      = false;      	 
          mRunClose = false;          
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
                
    class TCPSocketClientGetAllTask extends AsyncTask<String, ByteArrayOutputStream, String> {
    	
    	int fileSize    = 0;
        String fileName = "";
               
        @Override
        protected String doInBackground(String... message) {
            mRun = true;
            
            //mServerMessage = null;
            mServerBytes   = new byte[1024];
            
            mByteBufferInput  = null;
            ByteArrayOutputStream mBufferOutput = null;
            
            //in this while the client listens for the messages sent by the server
            while (!mRunClose) {

                try {
                	if ( mSocket == null ){
                		mRun = false;
                		break;
                	}
                	
                	if ( mSocket.isClosed() || !mSocket.isConnected() ){
                		mRun = false;
                		CloseConnection();
                		break;
                	}
                	                    
                    if( mStreamBufferOut == null )
                       mStreamBufferOut = mSocket.getOutputStream();
                                                                                                              
                    int bytes_read = -1;
                    
                    if( mByteBufferInput == null )
                    	mByteBufferInput = new BufferedInputStream(mSocket.getInputStream());
                                                                                                           
                    if ( mByteBufferInput == null) {
                    	mRun = false;
                    	CloseConnection();
                    	break;                    	
                    }
                    
                    if( mDataType == 2 ) // dtmFile
                     if( fileSize == 0 )
                        if( mFileGetSize > 0 ){
                         //mFileGetSizeRemaining = mFileGetSize;	
                       	 fileSize              = mFileGetSize;
                       	 fileName              = mFileGetPath;
                        }   
                                                            	                       
                    bytes_read =  mByteBufferInput.read(mServerBytes, 0, mServerBytes.length);   //blocking ...
                    
                    if (bytes_read > 0)                                       
                     switch (mDataType)
                     {                     
                      case 0: //dtmText
                      case 1: //dtmByte                                                               	      
                    	      mBufferOutput = new ByteArrayOutputStream();
                              mBufferOutput.write(mServerBytes, 0, bytes_read);
                              publishProgress(mBufferOutput);                      
                      break;
                      case 2: // dmtFileGet
                       do
                       {                            	
                            	if(mFileGetFOS == null )
                            	   mFileGetFOS = new FileOutputStream(mFileGetPath);
                                                                                             	 
                            	mFileGetFOS.write(mServerBytes, 0, bytes_read);
                            	mFileGetFOS.flush();
                              	
                            	mFileGetSizeRemaining = mFileGetSizeRemaining - bytes_read;
                            	
                            	if( mFileGetSizeRemaining < 0 ) mFileGetSizeRemaining = 0;
                            	mServerMessage = "" + mFileGetSizeRemaining;
                            	
                            	mBufferOutput = new ByteArrayOutputStream();
                            	mBufferOutput.write(mServerMessage.getBytes(), 0, mServerMessage.length());
                            	
                              	publishProgress(mBufferOutput);                              	
                       }
                       while ( (mFileGetSizeRemaining > 0) && ((bytes_read = mByteBufferInput.read(mServerBytes, 0, mServerBytes.length)) > 0) );   //blocking ...
                        
                                                
                       if( mFileGetFOS != null ){ 
                        	mFileGetFOS.close();
                        	mFileGetFOS = null;
                        	 
                        	if( mFileGetSizeRemaining <= 0 ) fileSize = 0;
                       }
                      break;
                     }    	                                                                                                                 
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    //Log.e("jTCPSocketClient", "Error_doInBackground_ClientByte", e);
                    e.printStackTrace();
                    
                    mRun = false;
                    CloseConnection();                                                            
                    break;
                }

            }
            
            // dtmGetFile
            if( mDataType == 2 ){
                File file = new File(fileName);
               
                if( file.exists() ) file.delete();
               
                fileSize              = -1;
                mFileGetSizeRemaining = 0;
                
                mServerMessage = "" + fileSize;
            	
            	mBufferOutput = new ByteArrayOutputStream();
            	mBufferOutput.write(mServerMessage.getBytes(), 0, mServerMessage.length());
            	
              	publishProgress(mBufferOutput);                                
            }
            
            mRun = false;
            return null;
        }

        @Override
        protected void onProgressUpdate( ByteArrayOutputStream... values) {
            super.onProgressUpdate(values);
            
            switch (mDataType)
            {
             case 0:
            	 if (values[0].toByteArray().length > 0 ) {
                     controls.pOnTCPSocketClientMessageReceived(pascalObj, values[0].toString() /*not delete end of string*/ );
                  }	  
             break;
            
             case 1:
              if (values[0].toByteArray().length > 0 ) {
                 controls.pOnTCPSocketClientBytesReceived(pascalObj, values[0].toByteArray());
            	 
              }
             break;
             case 2:
            	 
            	 int fileGetSize = Integer.parseInt(values[0].toString());
            	 
            	 controls.pOnTCPSocketClientFileGetProgress(pascalObj, fileName, fileGetSize, mFileGetSize);  //TODO
                 
                 if( fileGetSize == 0) 
                 	controls.pOnTCPSocketClientFileGetFinished(pascalObj, fileName, mFileGetSize);
                 
                 if( fileGetSize == -1) 
                  	controls.pOnTCPSocketClientFileGetFinished(pascalObj, fileName, fileGetSize);
                	 
             break;
            }
        }

        @Override
        protected void onPostExecute(String values) {
            super.onPostExecute(values);                                    
        }
    }
                   
 class TCPSocketClientFileSend extends AsyncTask<Void, Integer, Void> {
    	
    	String  mFileSendName    = "";  	
      	int     mFileSendSize    = 0;
        int     mFileSendSizeOut = 0;
        boolean mIsCreated       = false;
    	  
      	TCPSocketClientFileSend(String fullPath){
      		
      		mIsCreated    = false;
         	mRun          = false;
      		        		  
      		File file     = new File(fullPath);
         	mFileSendName = file.getName();
         	mFileSendSize = (int)file.length();         	         	
         	         	
        	if ( mSocket == null ) {
    			mFileSendSize = -1;
    			return;
    		}
    	
    		if ( mSocket.isClosed() || !mSocket.isConnected() ){
    			mFileSendSize = -1;
    			CloseConnection();
    			return;
    		}
    		
    	   try{
    		   
    		if( mFileSendDOS == null )
        		mFileSendDOS = new DataOutputStream(new BufferedOutputStream(mSocket.getOutputStream()));
    		
    		if( mFileSendDOS == null ){
    			mFileSendSize = -1;
    			CloseConnection();
    			return;
    		}
        	   	 
         	progressStep = 1024;            
                    	
            mFileSendFIS     = new FileInputStream(file);
            
            if( mFileSendFIS == null ){
                mFileSendSize = -1;
                CloseConnection();
       		 	return;
            }
                
            mFileSendSizeOut = 0;                               
                          
            mIsCreated       = true;
    	    
    	   } catch (IOException e) {
    			    		   		  		
    		   mFileSendSize = -1;
    	  	   CloseConnection();
    	  	   return;    		      		 	      		 
           }
      	}
    	
        @Override
        protected Void doInBackground(Void... params) {
        	
        	if( !mIsCreated ) return null;
        	
        	mRun = true;
        	
        	int  n = 0;
        	byte[] buf;
        	                
        	if (progressStep <= 0)
                buf = new byte[mFileSendSize];
            else
            	buf = new byte[progressStep];        	        	       	          	
       	   	        	        
        	try {        		          	         	    	        		 	         		     
	                 //write file to dos
	                 while( (n = mFileSendFIS.read(buf)) > 0 ){
	                	 
	                	 if( mRunClose ){
                	    	 mFileSendSize = -1;
                	    	 break; 
                	     }
	                	 	                	     
	                	 mFileSendDOS.write(buf,0,n);
	                	 mFileSendDOS.flush();
	                        
	                     mFileSendSizeOut = mFileSendSizeOut + n;
	                         
	                     publishProgress(mFileSendSizeOut);	                         	                         
	                 }
	                 
	                 if( mFileSendFIS != null){
	                	 mFileSendFIS.close();
	                	 mFileSendFIS = null;
	                 }
	                 	                 	                 	                 	               	    	    	    	    	    	   
			} catch (IOException e) {
						// TODO Auto-generated catch block
					e.printStackTrace();
					
					mFileSendSize = -1;
					mRun      = false;
					CloseConnection();
					return null;
			}
        	
        					        
        	mRun = false;
        	
            // your async action
            return null;
        }
        
        @Override
        protected void onProgressUpdate(Integer... values) {
            super.onProgressUpdate(values);
                        
            controls.pOnTCPSocketClientFileSendProgress(pascalObj, mFileSendName, values[0], mFileSendSize);  //TODO                                    
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            // update the UI (this is executed on UI thread)
            super.onPostExecute(aVoid);
                        
            controls.pOnTCPSocketClientFileSendFinished(pascalObj, mFileSendName, mFileSendSize);
        }
    }
        
    public boolean SendFile(String fullPath) {
      // dtmFileSend	
      if( SetDataTransferMode(3) ){
          if( mRun ) return false;
    		 
       	  new TCPSocketClientFileSend(fullPath).execute();
      
          return true;
      } else
    	  return false;    	
      
    }
      
      public boolean SetGetFile( String fullPath, int fileSize ){
    	  mFileGetPath          = fullPath;
    	  mFileGetSize          = fileSize;
    	  mFileGetSizeRemaining = fileSize;
    	  
    	  //dtmFileGet
    	  return SetDataTransferMode(2);
      }
              
      public void SetFileSendProgressStep(int _bytes) {
    	  if (_bytes > 512) 
    	     progressStep = _bytes;
    	  else
    	     progressStep = 512;    		  
      }
      
      public void SetTimeOut(int _millisecondsTimeOut) {
    	  mServerTimeOut = _millisecondsTimeOut;
      }

    //https://stackoverflow.com/questions/2878867/how-to-send-an-array-of-bytes-over-a-tcp-connection-java-programming
    private boolean sendBytes(byte[] myByteArray, int start, int len, boolean _writeLen) {
        
    	if ( mSocket == null || mSocket.isClosed() ) return false;
    	
    	if ( mSocket.isClosed() || !mSocket.isConnected() ){
    		CloseConnection();
    		return false;
    	}
        
    	try{    	
    	
         if ( mByteBufferOut == null )
             mByteBufferOut = new DataOutputStream(mSocket.getOutputStream());
        
         if (mByteBufferOut == null){
        	 CloseConnection();
        	 return false;
         }
        
         if (_writeLen) 
                try {
                    mByteBufferOut.writeInt(len);
                } catch (IOException e) {
                	CloseConnection();
                    return false;
                }        

         if (len > 0) 
                try {
                    mByteBufferOut.write(myByteArray, start, len);
                    mByteBufferOut.flush();
                } catch (IOException e) {
                	CloseConnection();
                    return false;
                }        
        
         return true;
    	} catch (IOException e) {
    		// TODO Auto-generated catch block
    		CloseConnection();
    		return false;
    	}

    }

    public boolean SendBytes(byte[] _jbyteArray, boolean _writeLength) throws IOException {
    	
        return sendBytes(_jbyteArray, 0, _jbyteArray.length, _writeLength);
        
    }

    public boolean SetDataTransferMode(int _dataType) {
    	int oldMode = mDataType;
    	mDataType   = _dataType;
    	
    	// If dtmFileSend need CloseConnection for load AsyncTask
    	if( (oldMode == 3) || (mDataType == 3) )
    	 if( oldMode != mDataType )    		    	
    	   if(isConnected()){
    		   CloseConnection();
    		   return Connect(mServerIP, mServerPort);
    	   }    	       	 
    		
    	return true;
    	    	
    }
    
}


