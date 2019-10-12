package org.lamw.appftpclientdemo1;

import android.content.Context;
import android.os.AsyncTask;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.SocketException;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

/*Draft java code by "Lazarus Android Module Wizard" [10/10/2019 19:44:45]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//https://raw.githubusercontent.com/theappguruz/Android--How-to-start-FTP-in-Android-Demo-Project/master/app/src/main/java/com/tagworld/ftptest/MyFTPClientFunctions.java
 
public class jFTPClient /*extends ...*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    private String host = "test.rebex.net";
    private int port = 21;
    private String username = ""; //demo
    private String password = "";  //password
    private boolean isConnected = false;

    public FTPClient mFTPClient = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jFTPClient(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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

    public boolean connect()  {
        isConnected = false;
        try {
            mFTPClient = new FTPClient();
            // connecting to the host
            mFTPClient.connect(host, port);
            // now check the reply code, if positive mean connection success
            if (FTPReply.isPositiveCompletion(mFTPClient.getReplyCode())) {
                // login using username & password
                boolean status = mFTPClient.login(username, password);
                /*
                 * Set File Transfer Mode
                 *
                 * To avoid corruption issue you must specified a correct
                 * transfer mode, such as ASCII_FILE_TYPE, BINARY_FILE_TYPE,
                 * EBCDIC_FILE_TYPE .etc. Here, I use BINARY_FILE_TYPE for
                 * transferring text, image, and compressed files.
                 */
                mFTPClient.setFileType(FTP.BINARY_FILE_TYPE);
                mFTPClient.enterLocalPassiveMode();
                isConnected =  status;
                return isConnected;
            }
        } catch (Exception e) {
           // Log.d(TAG, "Error: could not connect to host " + host);
        }
        return false;
    }

    /**
     * mFTPClient: FTP client connection object (see FTP connection example)
     * srcFilePath: source file path in sdcard desFileName: file name to be
     * stored in FTP server desDirectory: directory path where the file should
     * be upload to
     */
    public boolean upload(String srcFilePath, String desFileName) {
        boolean status = false;
        try {
            FileInputStream srcFileStream = new FileInputStream(srcFilePath);
            status = mFTPClient.storeFile(desFileName, srcFileStream);
            srcFileStream.close();
            return status;
        } catch (Exception e) {
            e.printStackTrace();
            //Log.d(TAG, "upload failed: " + e);
        }
        return status;
    }

    /**
     * mFTPClient: FTP client connection object (see FTP connection example)
     * srcFilePath: path to the source file in FTP server desFilePath: path to
     * the destination file to be saved in sdcard
     */
    public boolean download(String srcFilePath, String desFilePath) {
        boolean status = false;
        try {
            FileOutputStream desFileStream = new FileOutputStream(desFilePath);
            status = mFTPClient.retrieveFile(srcFilePath, desFileStream);
            desFileStream.close();
            return status;
        } catch (Exception e) {
            //Log.d(TAG, "download failed");
        }
        return status;
    }

    public void Disconnect() {
        try {
            mFTPClient.logout();
            mFTPClient.disconnect();
            //return true;
        } catch (Exception e) {
            //Log.d(TAG, "Error occurred while disconnecting from ftp server.");
        }

        //return false;
    }

    // Method to get current working directory:
    public String GetWorkingDirectory() {
        try {
            String workingDir = mFTPClient.printWorkingDirectory();
            return workingDir;
        } catch (Exception e) {
            //Log.d(TAG, "Error: could not get current working directory.");
        }

        return null;
    }

    // Method to change working directory:

    public boolean SetWorkingDirectory(String directory_path) {
        try {
            mFTPClient.changeWorkingDirectory(directory_path);
        } catch (Exception e) {
            //Log.d(TAG, "Error: could not change directory to " + directory_path);
        }

        return false;
    }

    public void SetHost(String _host) {
        host = _host;
    }

    public void SetPort(int _port) {
        port = _port;
    }


    public void SetPassword(String _password) {
        password = _password;
    }

    public void SetUsername(String _username) {
        username = _username;
    }

    public void Connect() {
        new ConnectTask().execute();
    }

    //Params,Progress,Result
    class ConnectTask extends AsyncTask<Void,Void,Boolean> {

        @Override
        protected Boolean doInBackground(Void... p) {

            boolean res = false;
            try {
                res = connect();
            } catch (Exception e) {
                res = false;
                e.printStackTrace();
            }
            return res;
        }
        @Override
        protected void onPostExecute(Boolean conn){
            controls.pOnFTPClientTryConnect(pascalObj, (boolean)conn);
        }
    }

    public void Download(String _url, String saveToLocal) {
        new AsyncUpOrDownTask(_url,saveToLocal).execute(0);
    }

    public void Upload(String _fromLocal, String _url) {
        new AsyncUpOrDownTask(_fromLocal,_url).execute(1);
    }

    //Parâmetros,Progresso,Resultado
    class AsyncUpOrDownTask extends AsyncTask<Integer,Integer,Boolean> {

        public String source;
        public String destination;
        public int task;

        public AsyncUpOrDownTask(String _source, String _destination) {
            source = _source;
            destination = _destination;
        }

        @Override
        protected Boolean doInBackground(Integer... p) {

            boolean success= false;

            try {
                if (p[0] == 0) {
                    task = 0;
                    success = download(source, destination);
                }
                else {
                    task = 1;
                    success = upload(source, destination);
                }

            } catch (Exception e) {
                success = false;
                e.printStackTrace();
            }

            return success;
        }

        protected void onProgressUpdate(Integer params){
            //
        }

        @Override
        protected void onPostExecute(Boolean succ){
            if (task == 0) {
                controls.pOnFTPClientDownloadFinished(pascalObj, destination, (boolean)succ);
            }
            else {
                controls.pOnFTPClientUploadFinished(pascalObj, destination, (boolean)succ);
            }
        }
    }

    public void ListFiles(String _remotePath) {
        new AsyncListTask(_remotePath, 0).execute(_remotePath);
    }

    //TODO
    public void CountFiles(String _remotePath) {
        new AsyncListTask(_remotePath, 1).execute(_remotePath);
    }

    //Parâmetros,Progresso,Resultado
    class AsyncListTask extends AsyncTask<String,String, Integer> {

        String[] fileList = null;
        public String dir_path;
        public int task;

        public AsyncListTask(String _directory, int _task) {
            dir_path = _directory;
            task = _task;
        }

        @Override
        protected Integer doInBackground(String... path) {
            int count =  0;

            try {
                FTPFile[] ftpFiles = mFTPClient.listFiles(dir_path);
                count = ftpFiles.length;
                fileList = new String[count];
                if (task == 0) {
                    for (int i = 0; i < count; i++) {
                        String name = ftpFiles[i].getName();
                        boolean isFile = ftpFiles[i].isFile();
                        if (isFile) {
                            fileList[i] = "File :: " + name;
                            //Log.i(TAG, "File : " + name);
                            publishProgress(path[0], ftpFiles[i].getName(), String.valueOf(ftpFiles[i].getSize()));
                        } else {
                            fileList[i] = "Directory :: " + name;
                            //Log.i(TAG, "Directory : " + name);
                        }
                    }
                }
                //return fileList;
            } catch (Exception e) {
                e.printStackTrace();
                //return fileList;
            }
            return count;
        }

        protected void onProgressUpdate(String... params){
            controls.pOnFTPClientListing(pascalObj, params[0], params[1], Integer.parseInt(params[2]));
        }

        @Override
        protected void onPostExecute(Integer count){
            controls.pOnFTPClientListed(pascalObj, (int)count);
        }

    }

}
