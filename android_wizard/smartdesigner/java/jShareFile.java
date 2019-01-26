package com.example.appchronometerdemo1;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Environment;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

/*Draft java code by "Lazarus Android Module Wizard" [5/10/2014 14:32:21]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jShareFile /*extends ...*/ {

  private long     pascalObj = 0;      // Pascal Object
  private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
  private Context  context   = null;
  private String mTransitoryEnvironmentDirectoryPath;
  
  private Intent intent = null;
      	        
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  public jShareFile(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
     //super(_ctrls.activity);
     context   = _ctrls.activity;
     pascalObj = _Self;
     controls  = _ctrls;
     
     mTransitoryEnvironmentDirectoryPath = GetEnvironmentDirectoryPath(1); //download!
     
     intent = new Intent();
	   intent.setAction(Intent.ACTION_SEND);
     //intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	   intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

  }

  public void jFree() {
    //free local objects...
    intent = null;      
  }

  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  private static void copyFileUsingFileStreams(File source, File dest)
  		throws IOException {
  	InputStream input = null;
  	OutputStream output = null;
  	try {
  		input = new FileInputStream(source);
  		output = new FileOutputStream(dest);
  		byte[] buf = new byte[1024];
  		int bytesRead;
  		while ((bytesRead = input.read(buf)) > 0) {
  			output.write(buf, 0, bytesRead);
  		}
  	} finally {
  		input.close();
  		output.close();
  	}
  }

  private boolean CopyFile(String _scrFullFileName, String _destFullFileName) {
  	File src= new File(_scrFullFileName);
  	File dest= new File(_destFullFileName);
  	try {
  		copyFileUsingFileStreams(src, dest);
  		return true;
  	} catch (IOException e) {
  		// TODO Auto-generated catch block
  		e.printStackTrace();
  		return false;
  	}
  }
  
	public void ShareFromSdCard(String _filename, String _mimetype){			 		 
		intent.setType(_mimetype);		
	    File file = new File(Environment.getExternalStorageDirectory().getPath() +"/"+ _filename);
	    intent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(file)); /* "/sdcard/test.txt" result : "file:///sdcard/test.txt" */			 	         		 		 			 				
		controls.activity.startActivity(Intent.createChooser(intent, "Share ["+_filename+"] by:"));
	}
	
	//https://xjaphx.wordpress.com/2011/10/02/store-and-use-files-in-assets/
	public void ShareFromAssets(String _filename, String _mimetype){				    		   
			InputStream is = null;
			FileOutputStream fos = null;			
			String PathDat = controls.activity.getFilesDir().getAbsolutePath();			 			
			try {		   		     			
				File outfile = new File(PathDat+"/"+_filename);								
				// if file doesnt exists, then create it
				if (!outfile.exists()) {
					outfile.createNewFile();				
				}												
				fos = new FileOutputStream(outfile);  //save to data/data/your_package/files/your_file_name														
				is = controls.activity.getAssets().open(_filename);																				
				int size = is.available();	     
				byte[] buffer = new byte[size];												
				for (int c = is.read(buffer); c != -1; c = is.read(buffer)){
			      fos.write(buffer, 0, c);
				}																
				is.close();								
				fos.close();								
				ShareFromInternalAppStorage(_filename,_mimetype);				
			}catch (IOException e) {
				// Log.i("ShareFromAssets","fail!!");
			     e.printStackTrace();			     
			}									
	}	
	
	public void ShareFromInternalAppStorage(String _filename, String _mimetype) {	 
	  String srcPath = controls.activity.getFilesDir().getAbsolutePath()+"/"+ _filename;       //Result : /data/data/com/MyApp/files	 
	  String destPath = mTransitoryEnvironmentDirectoryPath + "/" + _filename;	  
	  CopyFile(srcPath, destPath);	  
	  ShareFrom(destPath, _mimetype);	  	   
	}
		
	public void ShareFrom(String _fullFilename, String _mimetype) {
		   int p1 = _fullFilename.lastIndexOf("/");
		   String filename = _fullFilename.substring(p1+1, _fullFilename.length());		   		   
		   File file = new File(_fullFilename);	        	 
		   intent.setType(_mimetype);
		   intent.putExtra(Intent.EXTRA_STREAM,Uri.fromFile(file));    		       		 	     
		   controls.activity.startActivity(Intent.createChooser(intent, "Share ["+filename+"] by:")); 		   
	}	
		
	private String GetEnvironmentDirectoryPath(int _directory) {
		
		File filePath= null;
		String absPath="";   //fail!
		  
		//Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);break; //API 19!
		if (_directory != 8) {		  	   	 
		  switch(_directory) {	                       
		    
		    case 0:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS); break; //hack		    
		    case 1:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM); break;
		    case 2:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC); break;
		    case 3:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES); break;
		    case 4:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_NOTIFICATIONS); break;
		    case 5:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES); break;
		    case 6:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PODCASTS); break;
		    case 7:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RINGTONES); break;
		    
		    case 9: absPath  = this.controls.activity.getFilesDir().getAbsolutePath(); break;      //Result : /data/data/com/MyApp/files	    	    
		    case 10: absPath = this.controls.activity.getFilesDir().getPath();
		             absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/databases"; break;
		    case 11: absPath = this.controls.activity.getFilesDir().getPath();
	                 absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/shared_prefs"; break;	             		           
		  }
		  	  
		  //Make sure the directory exists.
	      if (_directory < 8) { 
	    	 filePath.mkdirs();
	    	 absPath= filePath.getPath(); 
	      }	        
	      
		}else {  //== 8
		    if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) == true) {
		    	filePath = Environment.getExternalStorageDirectory();  //sdcard!
		    	// Make sure the directory exists.
		    	filePath.mkdirs();
		   	    absPath= filePath.getPath();
		    }
		}    			    		 
		return absPath;
	}	
	
  public void SetTransitoryEnvironmentDirectory(int _index) {   
  	mTransitoryEnvironmentDirectoryPath = GetEnvironmentDirectoryPath(_index);
  }
	
}

//by jmpessoa
class CustomSpinnerArrayAdapter<T> extends ArrayAdapter<String>{
	
	Context ctx; 
	private int mTextColor = Color.BLACK;
	private int mTexBackgroundtColor = Color.TRANSPARENT; 
	private int mSelectedTextColor = Color.LTGRAY; 
	private int flag = 0;
	private boolean mLastItemAsPrompt = false;
	private int mTextFontSize = 0;
	int mTextSizeTypedValue;
	
public CustomSpinnerArrayAdapter(Context context, int simpleSpinnerItem, ArrayList<String> alist) {
   super(context, simpleSpinnerItem, alist);
   ctx = context;
   mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;
}


public void SetFontSizeUnit(int _unit) {	
	   switch (_unit) {
	      case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
	      case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; 
	      case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break;
	      case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; 
	      case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; 
	      case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; 
	      case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; 	      
     }   
}
//This method is used to display the dropdown popup that contains data.
	@Override
public View getDropDownView(int position, View convertView, ViewGroup parent)
{
    View view = super.getView(position, convertView, parent);        
    //we know that simple_spinner_item has android.R.id.text1 TextView:         
    TextView text = (TextView)view.findViewById(android.R.id.text1);
    
    text.setPadding(10, 15, 10, 15);      
    text.setTextColor(mTextColor);
               
    if (mTextFontSize != 0) {
  	  
  	  if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
          text.setTextSize(mTextSizeTypedValue, mTextFontSize);
  	  else
  		 text.setTextSize(mTextFontSize);  
    }    
    
    text.setBackgroundColor(mTexBackgroundtColor);
    return view;        
}
		
	//This method is used to return the customized view at specified position in list.
	@Override
	public View getView(int pos, View cnvtView, ViewGroup prnt) {
		
	  View view = super.getView(pos, cnvtView, prnt);	    
	  TextView text = (TextView)view.findViewById(android.R.id.text1);
	       
	  text.setPadding(10, 15, 10, 15); //improve here.... 17-jan-2015	  
    text.setTextColor(mSelectedTextColor);      
    
    if (mTextFontSize != 0) {
  	  
  	  if (mTextSizeTypedValue != TypedValue.COMPLEX_UNIT_SP)
           text.setTextSize(mTextSizeTypedValue, mTextFontSize);
  	  else
   		 text.setTextSize(mTextFontSize);
    }    
    
    if (mLastItemAsPrompt) flag = 1;
    return view; 
  }
	
  @Override
  public int getCount() {
	  if (flag == 1) 
      return super.getCount() - 1; //do not show last item
	   else return super.getCount();
  }
				
	public void SetTextColor(int txtColor){
		mTextColor = txtColor;
	}
	
	public void SetBackgroundColor(int txtColor){
		mTexBackgroundtColor = txtColor;
	}
	
	public void SetSelectedTextColor(int txtColor){
		mSelectedTextColor = txtColor;
	}
	
	 public void SetLastItemAsPrompt(boolean _hasPrompt) {
	    mLastItemAsPrompt = _hasPrompt;	   
	 }
	 
	    public void SetTextFontSize(int txtFontSize) {
	    	mTextFontSize = txtFontSize;	
	    }
	
}


