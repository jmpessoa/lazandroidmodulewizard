package org.lamw.appuploadservicedemo1;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
//import android.util.Log;

/*Draft java code by "Lazarus Android Module Wizard" [5/26/2016 20:15:41]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//http://codesfor.in/how-to-upload-a-file-to-server-in-android/
public class jUploadService extends IntentService {

    private long pascalObj = 0;      // Pascal Object
    private Controls controls = null;   // Control Class -> Java/Pascal Interface ...
    private Context context = null;

    private int result = 0; //0 = fail/canceled;  -1 = ok!
    private String mIntentAction;

    String serverResponseMessage;
    int serverResponseCode = 0;
    String mFilename = null;
    String nFilePath = null;

    /**
     * A constructor is required, and must call the super IntentService(String)
     * constructor with a name for the worker thread.
     */
    public jUploadService() {
        super("jUploadService");
    }

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jUploadService(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        super("jUploadService");
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
    }

    public void jFree() {
        //free local objects...
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    @Override
    protected void onHandleIntent(Intent intent) {   // will be called asynchronously by Android

        String urlPath = intent.getStringExtra("URL");
        String fileName = intent.getStringExtra("FILENAME");
        String filePath = intent.getStringExtra("PATH");

        if (filePath == null){
            filePath = "";
        }

        String iaction = intent.getStringExtra("ACTION");
        String form_name = intent.getStringExtra("FORMNAME");

        HttpURLConnection conn = null;
        DataOutputStream dos = null;
        String lineEnd = "\r\n";
        String twoHyphens = "--";
        String boundary = "*****";
        int bytesRead = 0;
        int bytesAvailable = 0;
        int bufferSize = 0;
        byte[] buffer;
        int maxBufferSize = 1 * 1024 * 1024;

        result = 0; //Activity.RESULT_CANCELED;
        long startTime = System.currentTimeMillis();

        FileOutputStream fos = null;
        FileInputStream fileInputStream = null;
        InputStream stream = null;

        startTime = System.currentTimeMillis();

        try {
                if (filePath.equals("")) {  //from assets
                    stream = controls.activity.getAssets().open(fileName);
                    bytesAvailable = stream.available();
                    bufferSize = Math.min(bytesAvailable, maxBufferSize);
                    buffer = new byte[bufferSize];
                    bytesRead = stream.read(buffer, 0, bufferSize);
                } else {
                    File sourceFile = new File(filePath, fileName);
                    if (sourceFile.isFile()) {
                        fileInputStream = new FileInputStream(sourceFile);
                        bytesAvailable = fileInputStream.available();
                        bufferSize = Math.min(bytesAvailable, maxBufferSize);
                        buffer = new byte[bufferSize];
                        bytesRead = fileInputStream.read(buffer, 0, bufferSize);
                    }else {
                        bytesRead = 0;
                        bufferSize = 1;
                        buffer = new byte[bufferSize]; //dummy
                    }
                }

                result = 0; //fail...
                if (bytesRead > 0) {
                    URL url = new URL(urlPath);
                    conn = (HttpURLConnection) url.openConnection();
                    conn.setDoInput(true);
                    conn.setDoOutput(true);
                    conn.setUseCaches(false);
                    conn.setRequestMethod("POST");
                    conn.setRequestProperty("Connection", "Keep-Alive");
                    conn.setRequestProperty("ENCTYPE", "multipart/form-data");
                    conn.setRequestProperty("Content-Type", "multipart/form-data;boundary=" + boundary);
                    conn.setRequestProperty(form_name, fileName);

                    dos = new DataOutputStream(conn.getOutputStream());
                    dos.writeBytes(twoHyphens + boundary + lineEnd);
                    dos.writeBytes("Content-Disposition: form-data; name=\"" + form_name + "\";filename=\"" + fileName + "\"" + lineEnd);
                    dos.writeBytes(lineEnd);

                    if (fileInputStream != null) {
                        while (bytesRead > 0) {
                            dos.write(buffer, 0, bufferSize);
                            bytesAvailable = fileInputStream.available();
                            bufferSize = Math.min(bytesAvailable, maxBufferSize);
                            bytesRead = fileInputStream.read(buffer, 0, bufferSize);
                        }
                    } else {
                        while (bytesRead > 0) {
                            dos.write(buffer, 0, bufferSize);
                            bytesAvailable = stream.available();
                            bufferSize = Math.min(bytesAvailable, maxBufferSize);
                            bytesRead = stream.read(buffer, 0, bufferSize);
                        }
                    }

                    dos.writeBytes(lineEnd);
                    dos.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);

                    serverResponseCode = conn.getResponseCode();
                    serverResponseMessage = conn.getResponseMessage();
                    // successfully finished
                    result = -1; //Activity.RESULT_OK;
                }
        } catch (Exception e) {
                e.printStackTrace();
        } finally {
                try {
                    if (fos != null) fos.close();
                    if (stream != null) stream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
        }
        publishResults(result, serverResponseCode, serverResponseMessage, iaction, (System.currentTimeMillis() - startTime));
    }

    private void publishResults(int result, int responseCode, String responseMessage, String _action, long time) {
        //Implicit intents specify the action which should be performed and optionally data which
        //provides content for the action.
        Intent intent = new Intent(_action);
        intent.putExtra("ResponseCode", responseCode);
        intent.putExtra("ResponseMessage", responseMessage);
        if (result == -1)
            intent.putExtra("Result", "RESULT_OK");
        else
            intent.putExtra("Result", "RESULT_CANCELED");
        intent.putExtra("ElapsedTimeInSeconds", (int) time / 1000); //long
        sendBroadcast(intent);
    }

    //Method to start the service
    public void Start(String _strURL, String _formName, String _intentActionNotification) {
        if (mFilename == null) return;
        mIntentAction = _intentActionNotification;
        //Explicit intents explicitly define the component which should be called by the Android system,
        //by using the Java class as identifier
        //Create an intent for a specific component.
        Intent intent = new Intent(controls.activity, jUploadService.class);
        intent.putExtra("URL", _strURL);
        intent.putExtra("FORMNAME", _formName); //
        intent.putExtra("PATH", mFilename);
        intent.putExtra("FILENAME", nFilePath); //
        intent.putExtra("ACTION", mIntentAction);
        controls.activity.startService(intent);
    }

    public void UploadFile(String _filePath, String _fileName) {
        mFilename = _fileName;
        nFilePath = _filePath;
    }

    public void UploadFileFromAssets(String _fileName) {
        mFilename = _fileName;
        nFilePath = "";
    }

}
/*
https://www.simplifiedcoding.net/android-upload-image-to-server/

http://codesfor.in/how-to-upload-a-file-to-server-in-android/

<?php
 //path of the folder which file is to be saved
 $file_path = $_SERVER['DOCUMENT_ROOT'] ."/images"/";

 $file_path = $file_path . basename( $_FILES['uploaded_file']['name']);
 if(move_uploaded_file($_FILES['uploaded_file']['tmp_name'], $file_path)) {
 echo "success";
 } else{
 echo "fail";
 }
 ?>
 */
