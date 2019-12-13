package org.lamw.appselectdirectorydialogdemo1;
import android.app.Dialog;
import android.content.Context;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import java.io.File;
import java.io.FileFilter;
import java.util.Arrays;

/*Draft java code by "Lazarus Android Module Wizard" [12/12/2019 20:36:57]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

/*Draft java code by "Lazarus Android Module Wizard" [1/27/2017 22:07:42]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

// https://rogerkeays.com/simple-android-file-chooser
public class jSelectDirectoryDialog /*extends ...*/ {

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
    private Context  context   = null;

    private String PARENT_DIR = "..";
    private ListView list;
    private Dialog dialog;
    private File currentPath;

    // filter on file extension
    //private String extension = null;

    private File initDir = null;
    private boolean IsShowing = false;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jSelectDirectoryDialog(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;

        dialog = new Dialog(controls.activity);
        list = new ListView(controls.activity);

        initDir = Environment.getExternalStorageDirectory();

        list.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int index, long id) {
                if (IsShowing) {
                    String dir = (String) list.getItemAtPosition(index);
                    File chosenFile = getChosenDir(dir);
                    if ( chosenFile.isDirectory() ) {
                        refresh(chosenFile);
                    } else {
                        //controls.pOnDirectorySelected(pascalObj, currentPath.getPath() /*initDir.getPath()*/);
                        //dialog.dismiss();
                    }
                }
            }
        });

        list.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            public boolean onItemLongClick(AdapterView<?> arg0, View v,
                                           int index, long id) {
                if (IsShowing) {
                    String dir = (String) list.getItemAtPosition(index);
                    File chosenFile = getChosenDir(dir);
                    if ( chosenFile.isDirectory() ) {
                    controls.pOnDirectorySelected(pascalObj, currentPath.getPath() + "/" + dir);
                        dialog.dismiss();
                    }
                }
                return true;
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
        String absPath;
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
                //case 10: filePath  = this.controls.activity.getFilesDir(); break;      //TODO		//databases
                case 10: absPath = this.controls.activity.getFilesDir().getPath();
                    absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/databases";
                    filePath= new File(absPath);break;
                //case 11: filePath  = this.controls.activity.getFilesDir(); break;      //TODO      //shared_prefs
                case 11: absPath = this.controls.activity.getFilesDir().getPath();
                    absPath = absPath.substring(0, absPath.lastIndexOf("/")) + "/shared_prefs";
                    filePath= new File(absPath);break;
                case 12: filePath = this.controls.activity.getCacheDir();break;
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

    public void Show(int _initialEnvDirectory) {
        SetInitialDirectory(_initialEnvDirectory);
        refresh(initDir);
        dialog.setContentView(list);
        //dialog.getWindow().setLayout(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
        IsShowing = true;
        dialog.show();
    }

    public void Show() {
        refresh(initDir);
        dialog.setContentView(list);
        //dialog.getWindow().setLayout(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
        IsShowing = true;
        dialog.show();
    }

    /**
     * Sort, filter and display the files for the given path.
     */
    private void refresh(File path) {
        this.currentPath = path;
        //Log.i("currentPath", currentPath.getPath());
        if (path.exists()) {
            File[] dirs = path.listFiles(new FileFilter() {
                @Override public boolean accept(File file) {
                    return (file.isDirectory() && file.canRead());
                }
            });


            //convert to an array
            String[] dirList = new String[dirs.length+1];
            dirList[0] = PARENT_DIR;
            Arrays.sort(dirs);
            int i = 1;
            for (File dir : dirs) { dirList[i++] = dir.getName(); }

            // refresh the user interface
            dialog.setTitle(currentPath.getPath());

            list.setAdapter(new ArrayAdapter<String>(controls.activity, android.R.layout.simple_list_item_1, dirList) {
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
    private File getChosenDir(String dirChosen) {
        if (dirChosen.equals(PARENT_DIR)) {
            return currentPath.getParentFile();
        } else {
            return new File(currentPath, dirChosen);
        }
    }

}
