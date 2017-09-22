package org.lamw.appbluetoothclientsockethc0506terminal1;

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
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;

//ref. http://androidcookbook.com/Recipe.seam;jsessionid=9B476BA317AA36E2CB0D6517ABE60A5E?recipeId=1665
//ref. http://javarevisited.blogspot.com.br/2012/08/convert-inputstream-to-string-java-example-tutorial.html

/*Draft java code by "Lazarus Android Module Wizard" [4-5-14 20:46:56]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jBluetoothClientSocket {
	
  private long     pascalObj = 0;      // Pascal Object
  private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
  private Context  context   = null;

  private  BluetoothSocket mmSocket;	
  private BluetoothDevice mmDevice;
	
  boolean mmConnected;
	
  BufferedInputStream mBufferInput;
  BufferedOutputStream mBufferOutput;
	
  BluetoothAdapter mmBAdapter;
	
  int mBuffer = 1024;
  
  boolean IsFirstsByteHeader = false;
  	
	//Unique UUID for this application.....
	//private UUID mmUUID = UUID.fromString("fa87c0d0-afac-11de-8a39-0800200c9a66");
	
	//Well known SPP UUID
	private String mmUUIDString = "00001101-0000-1000-8000-00805F9B34FB";
	
	String mMimeType = "text";
		
	public jBluetoothClientSocket(Controls _ctrls, long _Self) {
	       context   = _ctrls.activity;
	       pascalObj = _Self;
	       controls  = _ctrls;
	       mmBAdapter = BluetoothAdapter.getDefaultAdapter(); // Emulator -->> null!!!
	}
	
	public void jFree() {
       //free local objects...
		mmDevice = null;
	    mBufferInput = null;
		mBufferOutput = null;
		mmSocket = null;
		mmBAdapter = null;
	}
	
	public void SetDevice(BluetoothDevice _device) {		
		mmDevice = _device;
	}
	
	public void SetUUID(String _strUUID) {
		if (!_strUUID.equals("")) {
			mmUUIDString = _strUUID;
		}   
	}
				         
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
      
	public boolean IsConnected() {
		if (mmSocket != null)
		   return mmSocket.isConnected();
		else return false; 
	}
		
	public void Disconnect() {
		mmConnected = false;
		try {
			if (mmSocket != null)
				while (mmSocket.isConnected()) {
					mmSocket.close();	
				}
			    
		} catch (IOException e2) {			

		}	
	}
		
	//talk to server
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
			
  public void Connect() {
	  
	  if (!mmBAdapter.isEnabled()) {
          controls.activity.startActivityForResult(new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), 1000);
      }  	    
	    
	  if (mmBAdapter.isDiscovering()) mmBAdapter.cancelDiscovery(); //must cancel to connect!
	    
      if (mmSocket != null) {
      	  try {        		  
				mmSocket.close();
				mmSocket = null;
			  } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			  }
      }
        
      try {
      	  mmConnected = false;
			  mmSocket = mmDevice.createRfcommSocketToServiceRecord(UUID.fromString(mmUUIDString));
			  
			  // This is a blocking call and will only return on a successful connection or an exception			  
		      mmSocket.connect();
		      
		} catch (IOException e) {
				 mmConnected = false;									
				mmSocket = null;				
		}          	
       
      if (mmSocket != null) {
  		try {
  			mBufferInput = new BufferedInputStream(mmSocket.getInputStream());
				mBufferOutput = new  BufferedOutputStream(mmSocket.getOutputStream());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				mBufferInput = null;
				mBufferOutput = null;
				e.printStackTrace();
			}  		
		    new ASocketClientTask().execute(); 
      }  
  }	

  
  public void Connect(boolean _executeOnThreadPoolExecutor) {  //thanks to Tomash
 
	  if (!mmBAdapter.isEnabled()) {
          controls.activity.startActivityForResult(new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), 1000);
      }  	    
	    
	  if (mmBAdapter.isDiscovering()) mmBAdapter.cancelDiscovery(); //must cancel to connect!
	    
      if (mmSocket != null) {
      	  try {        		  
				mmSocket.close();
				mmSocket = null;
			  } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			  }
      }
        
      try {
      	  mmConnected = false;
			  mmSocket = mmDevice.createRfcommSocketToServiceRecord(UUID.fromString(mmUUIDString));
			  
			  // This is a blocking call and will only return on a successful connection or an exception			  
		      mmSocket.connect();
		      
		} catch (IOException e) {
				 mmConnected = false;									
				mmSocket = null;				
		}          	
       
      if (mmSocket != null) {
  		try {
  			mBufferInput = new BufferedInputStream(mmSocket.getInputStream());
				mBufferOutput = new  BufferedOutputStream(mmSocket.getOutputStream());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				mBufferInput = null;
				mBufferOutput = null;
				e.printStackTrace();
			}
  		
  		    if (_executeOnThreadPoolExecutor) 
  		       new ASocketClientTask().executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);  //thanks to Tomash
  		    else
  		       new ASocketClientTask().execute();
      }	  
	  
  }
   
     
	public String ByteArrayToString(byte[] _byteArray) { 
		 return (new String(_byteArray));   
	}
	
  public Bitmap ByteArrayToBitmap(byte[] _byteArray) {
  	return BitmapFactory.decodeByteArray(_byteArray, 0, _byteArray.length);    	
  }
  
  class ASocketClientTask extends AsyncTask<String, ByteArrayOutputStream, String> {
  	
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
        while (mmConnected) {                                                                     	
          try {            	
          	bytes_read = -1;
          	bufferOutput = new ByteArrayOutputStream();
          	
          	if (mBufferInput!=null)
				    bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length);   //blocking ...
				if (bytes_read < 0) { 
					mmConnected = false;				
				}	
			} catch (IOException e) {
				mmConnected = false;
				e.printStackTrace();				
			} 

          if (IsFirstsByteHeader) {
             if(bytes_read > 6) {            	
          	  bufferOutputHeader = new ByteArrayOutputStream();   
                byte[] lenHeaderBuffer = new byte[2];  //package lenght [int]
                byte[] lenContentBuffer = new byte[4];  //package lenght [int]
                
                if (inputBuffer!=null) {
              	  System.arraycopy(inputBuffer, 0,lenHeaderBuffer, 0, 2);                	    
                    System.arraycopy(inputBuffer, 2,lenContentBuffer, 0, 4);
                                          
                    lenHeader = byteArrayToShort(lenHeaderBuffer, ByteOrder.LITTLE_ENDIAN);
                    lenContent = byteArrayToInt(lenContentBuffer, ByteOrder.LITTLE_ENDIAN);                                                                             
                    
                    //----------------------------------------------------------------------                                                                                      
                    int index = 2+4;  // [header+content len] 
                    int r = bytes_read;                    
                    while ( r < (lenHeader+index)) {
                  	if (bytes_read > 0) {  
                  	  bufferOutputHeader.write(inputBuffer,index, bytes_read-index);
                  	  if (mBufferInput!=null) {
                  	    try {                    		  
							   bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length);
							   if (bytes_read < 0) {
								   mmConnected = false;
								   //return null;
							   }
					 	    } catch (IOException e) {
							// TODO Auto-generated catch block
					 	      mmConnected = false;	
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
                  	if ( (lenHeader-r) > 0 ) {
                  	   //---System.arraycopy(inputBuffer, 2+4 ,headerBuffer, 0, lenHeader);
                  	   bufferOutputHeader.write(inputBuffer,index,lenHeader-r); //dx                    	 
                  	   headerBuffer = bufferOutputHeader.toByteArray();                    	  
                         //---bufferOutput.write(inputBuffer, 2+4+lenHeader, bytes_read-2-4-lenHeader);
                  	   if ((bytes_read-index-(lenHeader-r)) > 0 ) {
                  	      bufferOutput.write(inputBuffer, index+(lenHeader-r), bytes_read-index-(lenHeader-r));
                            //--count = count + bytes_read-2-4-lenHeader;
                  	      count = count + bytes_read-index-(lenHeader-r);
                            publishProgress(bufferOutput);
                  	   }
                  	}   
                    }                      
                }
                                  
                while ( count < lenContent) {                	  
            	    try {
            	    	bytes_read = -1;
            	    	if (mBufferInput != null)
					   	   bytes_read =  mBufferInput.read(inputBuffer, 0, inputBuffer.length); //blocking ...
						   if (bytes_read < 0) {
							   mmConnected = false;							
						   }
					} catch (IOException e) {
						// TODO Auto-generated catch block
						mmConnected = false;
						e.printStackTrace();
					} 
            	                  	    
            	    if (bufferOutput!=null) { 	
            	    	if  (bytes_read > 0) { 
            	          bufferOutput.write(inputBuffer, 0, bytes_read);     	                  	                                         
                        count = count + bytes_read;
                        publishProgress(bufferOutput);
            	    	}
            	    }                    
                }                  
                                  
             }               
             else {
                 mmConnected = false;
             }
          }   
          else{
          	if (bufferOutput!=null) {
                if  (bytes_read > 0) {            		
                   bufferOutput.write(inputBuffer, 0, bytes_read);
                   publishProgress(bufferOutput);
                }
          	}
          }
                                                 	                                								                         	                      			                                                      
        } //main loop           
        return null;
      }
      
		@Override
		protected void onPreExecute() {			
			super.onPreExecute();
			mmConnected = true;												
			controls.pOnBluetoothClientSocketConnected(pascalObj,mmSocket.getRemoteDevice().getName(),mmSocket.getRemoteDevice().getAddress());
		}
		
      @Override
      protected void onProgressUpdate(ByteArrayOutputStream... values) {
         super.onProgressUpdate(values);
         if (IsFirstsByteHeader) {
            if (values[0].toByteArray().length == lenContent ) {
               controls.pOnBluetoothClientSocketIncomingData(pascalObj, values[0].toByteArray(), headerBuffer);
               try {                	 
              	if (bufferOutput != null) 
              	   bufferOutput.close();    		
              	if (bufferOutputHeader!= null)
              	   bufferOutputHeader.close();                	
  			  } catch (IOException e) {
  					// TODO Auto-generated catch block
  					e.printStackTrace();
  			 }
               //TODO
               /*
               else controls.pOnBluetoothClientSocketProgress(pascalObj, values[0].toByteArray().length);
               */
            }  
            
         }
         else {
      	  controls.pOnBluetoothClientSocketIncomingData(pascalObj, values[0].toByteArray(), headerBuffer);
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
        controls.pOnBluetoothClientSocketDisconnected(pascalObj);
        try {
      	 mmConnected = false;
      	 mBufferOutput = null;         	 
      	 if (mmSocket != null) mmSocket.close();   	  	        	  	
 	       } catch (IOException e) {
 		    
 	       }          
      }
      
    }	
}

