package com.example.appchronometerdemo1;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.UUID;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;


//ref. http://stackoverflow.com/questions/19395970/android-bluetooth-background-listner?rq=1
//ref. http://androidcookbook.com/Recipe.seam;jsessionid=6C1411AB8CCAFBA9384A5EC295B44525?recipeId=1991

/*Draft java code by "Lazarus Android Module Wizard" [4-5-14 20:46:56]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jBluetoothServerSocket {

  private long     pascalObj = 0;      // Pascal Object
  private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
  private Context  context   = null;

  private BluetoothAdapter mBAdapter;
  private String mServerName = "LamwBluetoothServer";
  private BluetoothServerSocket mServerSocket;
  private BluetoothSocket mConnectedSocket;
  
  private boolean mConnected;
  private boolean mIsListing = false;
  
  BufferedInputStream mBufferInput;
  BufferedOutputStream mBufferOutput;

  String mStrUUID = "00001101-0000-1000-8000-00805F9B34FB";   //Well known SPP UUID - Serial Port Profile
  int mTimeout = -1; //infinity
      
  int mBuffer = 1024;
  
  boolean IsFirstsByteHeader = false;
               
  public jBluetoothServerSocket(Controls _ctrls, long _Self) {
      context   = _ctrls.activity;
	    pascalObj = _Self;
	    controls  = _ctrls;	    
	    mConnected= false;	   	    
	    mBAdapter = BluetoothAdapter.getDefaultAdapter(); // Emulator -->> null!!!
  }
  
	public void jFree() {
      //free local objects...
		mConnectedSocket = null;
	    mBufferInput = null;		
		mBufferOutput = null;						
		mServerSocket = null;
		mBAdapter = null;		
	}

	public void SetUUID(String _strUUID) {
		if (!_strUUID.equals("")) {
			mStrUUID = _strUUID;	
		}   
	}
		
	   public void CancelListening() {
		    DisconnectClient();
	        try {
	        	if (mServerSocket != null) 
	        		mServerSocket.close();        
	        }
	        catch (IOException ex) {
	            //Log.e(TAG+":cancel", "error while closing server socket");
	        }
	    }
		 
	public void DisconnectClient() {
		   mConnected = false;
		   try {
		      if (mConnectedSocket != null && mConnectedSocket.isConnected()) 	    	   
		    	  mConnectedSocket.close();
		   } catch (IOException e) {
	          //
		   }	   
  }
		   

	public boolean IsClientConnected() {	
		if (mConnectedSocket != null)
	    	return mConnectedSocket.isConnected();
		else return false;
  }
			
	/* System.arraycopy
	 * src  the source array to copy the content. 
     srcPos  the starting index of the content in src. 
     dst  the destination array to copy the data into. 
     dstPos  the starting index for the copied content in dst. 
     length  the number of elements to be copied.  
	 */	
	
	//talk to client	
	public void Write(byte[] _dataContent, byte[] _dataHeader) {		 		
	       try {    	   
	           if (mBufferOutput != null) {	        	           	   	        	    
	        	    int sizeContent = _dataContent.length;	        	    
	        	    int tempsizeHeader = _dataHeader.length;
	        	    
	        	    if (tempsizeHeader > 32767) tempsizeHeader = 32767; 
	        	    
	        	    short sizeHeader = (short)tempsizeHeader;
	        	    
	        	    byte[] extendedArray = new byte[sizeContent+4+sizeHeader+2];	        	     	   
	        	    byte[] sizeContentBuff = intToByteArray(sizeContent, ByteOrder.LITTLE_ENDIAN);
	        	    byte[] sizeHeaderBuff = shortToByteArray(sizeHeader, ByteOrder.LITTLE_ENDIAN);
	        	    
	        	    System.arraycopy(sizeHeaderBuff, 0,  extendedArray, 0, 2);
	        	    System.arraycopy(sizeContentBuff, 0,  extendedArray, 2, 4);	        	    
	        	    System.arraycopy(_dataHeader, 0,  extendedArray, 2+4, _dataHeader.length);	        	    	        	           	   		           	   
	       	        System.arraycopy(_dataContent, 0,  extendedArray, 2+4+_dataHeader.length, _dataContent.length);		
	       	        mBufferOutput.write(extendedArray, 0, extendedArray.length);              
	       	        mBufferOutput.flush();          
	           }
	           
	        } catch (IOException e) { }       	       
	}	

	public void WriteMessage(String _message, byte[] _dataHeader) {		 		
		Write(_message.getBytes(), _dataHeader);       	      
	}
			
	public void WriteMessage(String _message) {						
	    try {	    	   
	       if (mBufferOutput != null) {
	       	    byte[] _byteArray = _message.getBytes();	        	   	       	        	       	        		
	       	    mBufferOutput.write(_byteArray, 0, _byteArray.length);              
	       	    mBufferOutput.flush();          
	        }	           
	    } catch (IOException e) { }       	       
	}
			
  //talk to client	
	public void Write(byte[] _dataContent) {	
		
   try {
      if (mBufferOutput != null) {	        	 
   	   mBufferOutput.write(_dataContent, 0, _dataContent.length);              
   	   mBufferOutput.flush();
       }    
    }  catch (IOException e) { }    
   
}
	
	
public void SendFile(String _filePath, String _fileName, byte[] _dataHeader) throws IOException {
		
		  if (mBufferOutput != null) {	
		    File F = new File( _filePath + "/" + _fileName);		    	    	    	    	    
		    int sizeContent = (int)F.length();	    
		        	    	        	    
  	    int tempsizeHeader = _dataHeader.length;	        	    	        	    
  	    if (tempsizeHeader > 32767) tempsizeHeader = 32767; 	        	    	        	   	        	    	        	    
  	    short sizeHeader = (short)tempsizeHeader; 		        	    	        	      	       	        	    
  	    byte[] extendedArray = new byte[sizeContent+4+sizeHeader+2];	        	     	   
  	    byte[] sizeContentBuff = intToByteArray(sizeContent, ByteOrder.LITTLE_ENDIAN);
  	    byte[] sizeHeaderBuff = shortToByteArray(sizeHeader, ByteOrder.LITTLE_ENDIAN);	        	    	        	    	        	    
  	    
  	    System.arraycopy(sizeHeaderBuff, 0,  extendedArray, 0, 2);
  	    System.arraycopy(sizeContentBuff, 0,  extendedArray, 2, 4);	        	    
  	    System.arraycopy(_dataHeader, 0,  extendedArray, 2+4, _dataHeader.length);	 
  	    
		    BufferedInputStream bis = new BufferedInputStream(new FileInputStream(F));			    
		    if (bis.read(extendedArray, 2+4+_dataHeader.length, sizeContent) > 0) {  
	          try {	        	  
	        	mBufferOutput.write(extendedArray, 0, extendedArray.length);
	            mBufferOutput.flush();
	          }  
	          finally {
	            bis.close();   
	          }        
		    }
		  }   
	}
		
	public void SendFile(String _filePath, String _fileName) throws IOException {
		
	 if ( mBufferOutput != null) {			 
		    File F = new File( _filePath + "/" + _fileName);		    	    	    	    	    
		    int size = (int)F.length();	    
		    byte[] buffer = new byte[size];  	    	  	  	    	    	    	    
		    BufferedInputStream bis = new BufferedInputStream(new FileInputStream(F));	    	  	    
		    if (bis.read(buffer, 0, size) > 0) {		    
		      try {             		    	  
		    	mBufferOutput.write(buffer, 0, buffer.length);
		        mBufferOutput.flush();
		      }  
		      finally {
		        bis.close();   
		      }        
		    }
	   }  		 
   }
	
	public void WriteMessage(String _message, String _dataHeader) {		 	
		WriteMessage(_message, _dataHeader.getBytes());
	}
	
	public void Write(byte[] _dataContent,  String _dataHeader) {			 
		Write(_dataContent,_dataHeader.getBytes());		   
	}
	
	public void SendFile(String _filePath, String _fileName, String _dataHeader) throws IOException {
		SendFile(_filePath,_fileName, _dataHeader.getBytes());		
	}
	
	public void SaveByteArrayToFile(byte[] _byteArray, String _filePath,  String _fileName) {
		
		File F = new File( _filePath + "/" + _fileName);
	    FileOutputStream fos;
		try {
			fos = new FileOutputStream(F);						
		    try {
				fos.write(_byteArray, 0, _byteArray.length);
				fos.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
		    try {
				fos.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		        
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
  	
private byte[] intToByteArray(int value, ByteOrder order) {
      ByteBuffer buffer = ByteBuffer.allocate(4); // in java, int takes 4 bytes.
      buffer.order(order);	        	       	        
      return buffer.putInt(value).array();
}
	  
private int byteArrayToInt(byte[] byteArray, ByteOrder order) {
      ByteBuffer buffer = ByteBuffer.wrap(byteArray);
      buffer.order(order);
      return buffer.getInt();
}

private byte[] shortToByteArray(short value, ByteOrder order) {
  ByteBuffer buffer = ByteBuffer.allocate(2); // in java, shortint takes 2 bytes.
  buffer.order(order);	        	       	        
  return buffer.putShort(value).array();
}
	  
private int byteArrayToShort(byte[] byteArray, ByteOrder order) {
  ByteBuffer buffer = ByteBuffer.wrap(byteArray);
  buffer.order(order);
  return buffer.getShort();
}
	
public void SetTimeout(int _milliseconds) {
	   mTimeout= _milliseconds;			
}	
	
	public String ByteArrayToString(byte[] _byteArray) {  
		   return (new String(_byteArray));   
	}
	
  public Bitmap ByteArrayToBitmap(byte[] _byteArray) {
  	return BitmapFactory.decodeByteArray(_byteArray, 0, _byteArray.length);    	
  }
      
  public boolean GetDataHeaderReceiveEnabled() {
      return IsFirstsByteHeader;
  }
  
    
  public void SetDataHeaderReceiveEnabled(boolean _value)  {
  	IsFirstsByteHeader = _value;
  }
  
         
  public void SetReceiverBufferLength(int _value)  {
  	mBuffer = _value;
  }
  
  public int GetReceiverBufferLength()  {
  	return mBuffer; 
  }
  
  public void SetServerName() { //TODO Pascal 
     mServerName = "LamwBluetoothServer";
  }
  
	public void Listen() {
				  		  		 
		  DisconnectClient();
		  
		  mConnected = false; 	
	      if ( !mStrUUID.equals("") && mBAdapter != null) {		    	  
	        try {        	        	        	               		
	        	  if (!mBAdapter.isEnabled()) {
	                  controls.activity.startActivityForResult(new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), 1001);
	              }         	                  	    
				  mServerSocket = mBAdapter.listenUsingRfcommWithServiceRecord(mServerName, UUID.fromString(mStrUUID));		
				  				  
				  if (mServerSocket != null) {	
					  controls.pOnBluetoothServerSocketListen(pascalObj, mServerName, mStrUUID);
	                  new ASocketServerTask().execute();							  	 								
				  }        	  
			 } catch (IOException e1) {
				//	
			 }                 
		  }              
	}
	
  class ASocketServerTask extends AsyncTask<String,ByteArrayOutputStream,String> {
    	boolean flagAceept = false;
  	    	
  	int bytes_read = 0;
  	int count = 0;
  	
  	int lenContent = 0;
  	int lenHeader = 0;
  	
  	byte[] inputBuffer = new byte[mBuffer];    
  	
  	ByteArrayOutputStream bufferOutput;
  	ByteArrayOutputStream bufferOutputHeader;
  	
  	byte[] headerBuffer;
  	    	    	
      @Override
      protected String doInBackground(String... message) {    
        mConnected = false;          	
        try {            	            	            
          	if (mTimeout > 0) { 
          	  mIsListing = true;
   			  mConnectedSocket = mServerSocket.accept(mTimeout); //locking...
   			  mIsListing = false;
          	}  
          	else {           		
          	  mIsListing = true;
          	  mConnectedSocket = mServerSocket.accept();
          	  mIsListing = false;
          	}  
          	            	            	        	    
				if (mConnectedSocket != null) { 			        					
					mConnected = true;
	        	    mBufferInput = new BufferedInputStream(mConnectedSocket.getInputStream());
	        		mBufferOutput = new  BufferedOutputStream(mConnectedSocket.getOutputStream());	
	        		try {
	            	   mServerSocket.close();
	            	   mServerSocket = null;
	        		}
	        		catch (IOException e3) {		
	        			mServerSocket = null;	
	    		    }
				}				
		  } 
          catch (IOException e2) {		
				//e2.printStackTrace();		
		  }
        while (mConnected) {                          	
           try {
             bufferOutput = new ByteArrayOutputStream();
             bytes_read =  -1;
             if (mBufferInput != null)
  		       bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length); //blocking ...
  		   if (bytes_read == -1) { 
  			  mConnected = false;    			 
  		   }	    				
  		 } catch (IOException e) {
  			//
  			 mConnected = false;
  		 } 
              
           if (IsFirstsByteHeader) {
              if(bytes_read > 6) {
            	   bufferOutputHeader = new ByteArrayOutputStream();   
                 byte[] lenHeaderBuffer = new byte[2];  //header lenght [short]
                 byte[] lenContentBuffer = new byte[4];  //content lenght [int]
                                   
                 if (inputBuffer!=null) {
              	 System.arraycopy(inputBuffer, 0,lenHeaderBuffer, 0, 2); //copy first 2 bytes -->header lenght
                   System.arraycopy(inputBuffer, 2,lenContentBuffer, 0, 4); //copy more 4 bytes --> content lenght
                   
                   lenContent = byteArrayToInt(lenContentBuffer, ByteOrder.LITTLE_ENDIAN); //get number
                   lenHeader = byteArrayToShort(lenHeaderBuffer, ByteOrder.LITTLE_ENDIAN); //get number
                          
                   //---headerBuffer = new byte[lenHeader]; //get header info ...
                   
                   //----------------------------------------------------------------------                                                                                      
                   int index = 2+4;  
                   int r = bytes_read;                    
                   while ( r < (lenHeader+index)) {
                    if (bytes_read > 0) { 
                 	    bufferOutputHeader.write(inputBuffer,index, bytes_read-index);
                 	    if (mBufferInput!=null) {
                 	       try {                    		  
							   bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length);
							   if (bytes_read < 0) {
	                   	        	mConnected = false;	                  			    
	                   	       }
					 	    } catch (IOException e) {
							// TODO Auto-generated catch block
					 	      mConnected = false;	
							  e.printStackTrace();
						    }                    	  
                 	        index = 0;
                 	        if (bytes_read > 0)
                 	           r = r + bytes_read;                   	       
                 	    }
                    } 
                   }                        
                   if (bytes_read > 0)
             	       r = r - bytes_read;  //backtraking..
             	  
                   //-----------------------------------------------------------------------------                      
                   if (bufferOutput!=null) {       
                  	if ( (lenHeader-r) > 0) {
                 	      bufferOutputHeader.write(inputBuffer,index,lenHeader-r); //dx                    	 
                 	      headerBuffer = bufferOutputHeader.toByteArray();  
                 	      if ((bytes_read-index-(lenHeader-r)) > 0) {
                 	        bufferOutput.write(inputBuffer, index+(lenHeader-r), bytes_read-index-(lenHeader-r));                     
                 	        count = count + bytes_read-index-(lenHeader-r);
                          publishProgress(bufferOutput);
                 	      }
                  	}
                   }                                                               
                   
                   //---------------------------------------------------------------------
                   
                   /*                                                          
                   if (inputBuffer!=null &&  bufferOutput!=null) {                       
                  	  System.arraycopy(inputBuffer, 2+4 ,headerBuffer, 0, lenHeader); //get header info ..                       
                        bufferOutput.write(inputBuffer, 2+4+lenHeader, bytes_read-2-4-lenHeader);  //get content info                
                        count = count + bytes_read-2-4-lenHeader;                   
                        publishProgress(bufferOutput);
                   }
                   */ 
                   
                 }
                 
                 while ( count < lenContent) {                	  
               	    try {
               	    	bytes_read = -1;
               	    	if (mBufferInput!=null) {
 						       bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length);                 	    	
               	    	   if (bytes_read < 0) {
                 	        	 mConnected = false;
                			     //return null;
               	    	   }  
                 	        }
               	    	
 					    } catch (IOException e) {
 						// TODO Auto-generated catch block
 					    	mConnected = false;	
 						    e.printStackTrace();
 				 	    } 
               	    if(bytes_read > 0) {
               	       if (bufferOutput!=null) {
               	    	 if (bytes_read > 0)  { 
               	           bufferOutput.write(inputBuffer, 0, bytes_read);     	                  	                                         
                             count = count + bytes_read;
                             publishProgress(bufferOutput);
               	    	 }  
               	       }
                      }
                 }    
              } 
              else {
                mConnected = false;                 
              }
          }  
          else{
          	if (bufferOutput!=null) {	
          	  if (bytes_read > 0) {	
                  bufferOutput.write(inputBuffer, 0, bytes_read);
                  publishProgress(bufferOutput);
          	  }
          	}
          }
                                  	                         
        }// main loop            
        return null;
      }
      
		@Override
		protected void onPreExecute() {			
		   super.onPreExecute();		   				   
		}
				
		//http://examples.javacodegeeks.com/core-java/nio/bytebuffer/convert-between-bytebuffer-and-byte-array/
      @Override
      protected void onProgressUpdate(ByteArrayOutputStream...buffers) {
         super.onProgressUpdate(buffers[0]);            
		   if (!flagAceept) {
			   flagAceept = true;
		       boolean keep = controls.pOnBluetoothServerSocketConnected(pascalObj,mConnectedSocket.getRemoteDevice().getName(),mConnectedSocket.getRemoteDevice().getAddress());
		       if (!keep) {
		    	    mConnected = false;
		    	    
		    	    mBufferInput = null;
					mBufferOutput = null;
		  			mConnectedSocket = null;
		  			
		    		while (mConnectedSocket.isConnected()) {
		    			try {
						  mConnectedSocket.close();
					     } catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					    }   
		    		}		    																	              		
		       }	
		   }  	
		   
		   if (IsFirstsByteHeader) { 			   
		      if (buffers[0].toByteArray().length == lenContent) { 		    	  
               mConnected = controls.pOnBluetoothServerSocketIncomingData(pascalObj, buffers[0].toByteArray(), headerBuffer);
               try {
              	 if (bufferOutput != null) 
              	   bufferOutput.close();                	   
				 } catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				 }                 
		      }  
            //TODO
            /*
            else controls.pOnBluetoothServerSocketProgress(pascalObj, values[0].toByteArray().length);
            */
		   }        
         else {
      	  mConnected = controls.pOnBluetoothServerSocketIncomingData(pascalObj, buffers[0].toByteArray(), headerBuffer);
            try {
          	  if (bufferOutput != null)
          	      bufferOutput.close();	
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
			  }              
         } 		    		   
      }
      
      @Override
      protected void onPostExecute(String values) {    	  
        super.onPostExecute(values);
      	controls.pOnBluetoothServerSocketAcceptTimeout(pascalObj);
		    mBufferInput = null;
			mBufferOutput = null;

      }        
    }	
}

