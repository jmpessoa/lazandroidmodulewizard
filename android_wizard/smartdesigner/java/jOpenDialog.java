package org.lamw.appmodaldialogdemo1;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager.LayoutParams;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.util.Arrays;


/*Draft java code by "Lazarus Android Module Wizard" [1/27/2017 22:07:42]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

// https://rogerkeays.com/simple-android-file-chooser
public class jOpenDialog /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
      
   private String PARENT_DIR = "..";
   private ListView list;
   private Dialog dialog;
   private File currentPath;

   // filter on file extension
   private String extension = null;
   
   private File initDir = null;
   private boolean IsShowing = false;
           
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   
   public jOpenDialog(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
      
      dialog = new Dialog(controls.activity);      
      list = new ListView(controls.activity);
      
      initDir = Environment.getExternalStorageDirectory();
      
      list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
          @Override 
          public void onItemClick(AdapterView<?> parent, View view, int which, long id) {
        	  
        	if (IsShowing) {
              String fileChosen = (String) list.getItemAtPosition(which);             
              File chosenFile = getChosenFile(fileChosen);              
              if ( chosenFile.isDirectory() ) {
                 refresh(chosenFile);
              } else {             	  
                controls.pOnFileSelected(pascalObj, currentPath.getPath() /*initDir.getPath()*/, chosenFile.getName());                          
                dialog.dismiss();
              }              
        	}
        	
          }
      });
            
   }
 
   public void jFree() {
     //free local objects...
	   dialog = null;
	   list = null;	   
   }
 
 //write others [public] methods code here......
 //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   
   private File GetEnvironmentDirectoryPath(int _directory) {		
		File filePath= null;		  
		//Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS);break; //only Api 19!
		if (_directory != 8) {		  	   	 
		  switch(_directory) {	                       
		    case 0:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS); break;	   
		    case 1:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM); break;
		    case 2:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC); break;
		    case 3:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES); break;
		    case 4:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_NOTIFICATIONS); break;
		    case 5:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES); break;
		    case 6:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PODCASTS); break;
		    case 7:  filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RINGTONES); break;
		    
		    case 9: filePath  = this.controls.activity.getFilesDir(); break;      //Result : /data/data/com/MyApp/files	    	    
		    case 10: filePath  = this.controls.activity.getFilesDir(); break;      //TODO		    
		    case 11: filePath  = this.controls.activity.getFilesDir(); break;      //TODO	             
		           
		  }		  	  	     
		}else {  //== 8 
		    if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED) == true) {
		    	filePath = Environment.getExternalStorageDirectory();  //sdcard!				   	 
		    }
		}    			    		 
		return filePath;
	}
   
   public void SetInitialDirectory (int _initialEnvDirectory) {
	   initDir = GetEnvironmentDirectoryPath(_initialEnvDirectory);
   }
   
   public void SetFileExtension(String _fileExtension) {
	   extension = _fileExtension;
	   if (extension != null) {   
	     if ( extension.equals("") )          
		   extension = null;	   		 
       }
   }
   
   public void Show(int _initialEnvDirectory, String _fileExtension) {			  
	  SetFileExtension( _fileExtension);  
	  SetInitialDirectory(_initialEnvDirectory);	  
	  refresh(initDir);  
      dialog.setContentView(list);
      //dialog.getWindow().setLayout(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
      IsShowing = true;
      dialog.show();      
   }
   
   public void Show(String _fileExtension) {			  
	  SetFileExtension( _fileExtension); 
	  refresh(initDir); 	  	   
      dialog.setContentView(list);
      //dialog.getWindow().setLayout(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);      
      IsShowing = true;	  
      dialog.show();
   }
   
   public void Show() {	   
	   refresh(initDir);  //new File( startDir );	   
	   dialog.setContentView(list);
	   //dialog.getWindow().setLayout(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
	   IsShowing = true;
       dialog.show();
   }   
   

   /**
    * Sort, filter and display the files for the given path.
    */
   private void refresh(File path) {
       this.currentPath = path;
       Log.i("currentPath", currentPath.getPath());
       if (path.exists()) {
           File[] dirs = path.listFiles(new FileFilter() {
               @Override public boolean accept(File file) {
                   return (file.isDirectory() && file.canRead());
               }
           });
           File[] files = path.listFiles(new FileFilter() {
               @Override public boolean accept(File file) {
                   if (!file.isDirectory()) {
                       if (!file.canRead()) {
                           return false;
                       } else if (extension == null) {
                           return true;
                       } else {
                           return file.getName().toLowerCase().endsWith(extension);
                       }
                   } else {
                       return false;
                   }
               }
           });

           //convert to an array
           int i = 0;
           String[] fileList;
           if (path.getParentFile() == null) {
               fileList = new String[dirs.length + files.length];
           } else {
               fileList = new String[dirs.length + files.length + 1];
               fileList[i++] = PARENT_DIR;
           }
           Arrays.sort(dirs);
           Arrays.sort(files);
           for (File dir : dirs) { fileList[i++] = dir.getName(); }
           for (File file : files ) { fileList[i++] = file.getName(); }

           // refresh the user interface
           dialog.setTitle(currentPath.getPath());
           
           list.setAdapter(new ArrayAdapter<String>(controls.activity, android.R.layout.simple_list_item_1, fileList) {
                      @Override public View getView(int pos, View view, ViewGroup parent) {
                          view = super.getView(pos, view, parent);
                          ((TextView) view).setSingleLine(true);
                          return view;
                      }
                  });
       }   
       
   }
      
   /**
    * Convert a relative filename into an actual File object.
    */
   private File getChosenFile(String fileChosen) {
       if (fileChosen.equals(PARENT_DIR)) {
           return currentPath.getParentFile();
       } else {
           return new File(currentPath, fileChosen);
       }
   }
   
}
