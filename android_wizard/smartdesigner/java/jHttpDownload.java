package com.example.appchronometerdemo1;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;

import android.os.AsyncTask;

//------------------------------------------------------------------------------
//jHttp_Down
//
//jHttp_DownLoad http_down = new jHttp_DownLoad(context,ctrls);
//http_down.execute("http://app.pixo.kr/maxpaper/test.jpg");
//
//ref. http://developer.android.com/reference/android/os/AsyncTask.html
//http://blog.naver.com/giyoung_it?Redirect=Log&logNo=100177415835
//http://blog.daum.net/yohocosama/274
//http://jangjeonghun.tistory.com/303
//------------------------------------------------------------------------------

//Params , Progress , Result
public class jHttpDownload extends AsyncTask<String, Integer, File>{
//Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private String          urlfile   = "";    // url File
private String          localfile = "";    // Local File

//Constructor
public  jHttpDownload(Controls ctrls,long pasobj, String url, String local ) {
//Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//
urlfile   = url;
localfile = local;
}

//
public  void run() {
execute(urlfile);
}

//Step #1. Before Process
@Override
protected void onPreExecute() {
super.onPreExecute();
//Log.i("Java","Before Download");
//progress.show();
}

//Step #3. Progress
@Override
protected void onProgressUpdate(Integer... progress) {
super.onProgressUpdate();
//setProgressPercent(progress[0]);
//Log.i("Java","onProgressUpdate");
}

//Step #4. After Process
@Override
protected void onPostExecute(File result) {
super.onPostExecute(result);
//Log.i("Java","Finish");
}

//Step #2. Downloading
@Override
protected File doInBackground(String... urls) {
try {
   //
   URL url                 = new URL(urls[0]);
   URLConnection ucon      = url.openConnection();
   //
   String fileName         = localfile;

   // Create Folder
   //File dir                = new File ( System.IO.Path.GetDirectoryName(localfile) );
   //if(!dir.exists()) { dir.mkdirs(); }
   //File file               = new File(dir,System.IO.Path.GetFileName(localfile) );
   File file               = new File(localfile);

   //long startTime          = System.currentTimeMillis();
   InputStream is          = ucon.getInputStream();
   BufferedInputStream bis = new BufferedInputStream(is);

	 int size = bis.available();     
   byte[] buffer = new byte[size];
   FileOutputStream fos = new FileOutputStream(file);
   
	 for (int c = is.read(buffer); c != -1; c = is.read(buffer)){
	     fos.write(buffer, 0, c);
	 }
	 
   fos.flush();
   fos.close();
   //
   //Log.d("Java", "Downloaded " + ((System.currentTimeMillis() - startTime) / 1000) + "s");
   // return -> onPostExecute
   return file;  }
catch (IOException e) {
   e.printStackTrace(); }
return null;
}

}
