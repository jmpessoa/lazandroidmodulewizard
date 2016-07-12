package com.example.apploadimagevideosoundfrominternet;

import android.os.AsyncTask;

//------------------------------------------------------------------------------
//jAsyncTask
//
//------------------------------------------------------------------------------

//                           Params , Progress , Result
public class jAsyncTask {
	
 //Java-Pascal Interface
 private long             PasObj   = 0;      // Pascal Obj
 private Controls        controls = null;   // Control Class for Event
 boolean autoPublishProgress = false;  

//Constructor
 public  jAsyncTask(Controls ctrls,long pasobj) {
 //Connect Pascal I/F
  PasObj   = pasobj;
  controls = ctrls;
 }

 public void setProgress(int progress ) {  //update UI
	   //Log.i("jAsyncTask","setProgress "+progress );
	   //publishProgress(progress);
	   //count = count + progress;
 }

	//by jmpessoa
	public void SetAutoPublishProgress(boolean value){		
	   //autoPublishProgress = value;
	}

  public void Execute(){
    //Log.i("Execute","Execute...");	
	  new ATask().execute();
  }

	//Free object except Self, Pascal Code Free the class.
  public  void Free() {
	  	//
  }

class ATask extends AsyncTask<String, Integer, Integer>{
  int count = 0;
  int progressUpdate = 0;
  //Step #1. Before Process    
 @Override
 protected void onPreExecute() {	   
   super.onPreExecute();
   progressUpdate = controls.pOnAsyncEventPreExecute(PasObj); // Pascal Event
   if ( progressUpdate != 0) count = progressUpdate;
 }

 //Step #2. Task/Process
 @Override
 protected Integer doInBackground(String... params) {	   
     while(controls.pOnAsyncEventDoInBackground(PasObj, count) ) {    	  
  	   publishProgress(count);
     }     	    
     return null; //count;      
  }

  //Step #3. Progress
  @Override
  protected void onProgressUpdate(Integer... params) {
     super.onProgressUpdate(params);
     progressUpdate = controls.pOnAsyncEventProgressUpdate(PasObj, count); // Pascal Event
     if (progressUpdate != count)  count = progressUpdate;       
  }

  //Step #4. After Process
  @Override
  protected void onPostExecute(Integer result) {  
    super.onPostExecute(result);
    controls.pOnAsyncEventPostExecute(PasObj, count); //result.intValue()      
  }        
  
}

}
