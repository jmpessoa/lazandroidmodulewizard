package com.example.apptrycode3;

import java.lang.reflect.Method;
import java.util.ArrayList;

import android.content.Context;

/*Draft java code by "Lazarus Android Module Wizard"*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

public class jDumpJavaMethods /*extends ...*/ {         

    private long     pascalObj = 0;      // Pascal Object
    private Controls controls  = null;   // Control Class Java/Pascal Interface ...
    private Context  context   = null;

    private boolean mStripFullTypeName;                           
    private String  mFullJavaClassName= "";   //ex: "android.media.MediaPlayer", "java.util.List" etc..    
    private String  mMethodFullSignature= "";
    private String  mMethodImplementation= "";
    private String  mObjReferenceName= ""; //now it is not null!!!
    private String  mDelimiter= "";
    private String  mMethodHeader= "";
    
    ArrayList<String> mListMethodHeader = new ArrayList<String>();                         
    ArrayList<String> mListNoMaskedMethodImplementation = new ArrayList<String>();    
       
    String mNoMaskedMethodImplementation="";
        
    public jDumpJavaMethods(Controls _ctrls, long _Self, String _fullJavaClassName) { //Add more '_xxx' params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;      
      controls  = _ctrls;
      
      mFullJavaClassName = _fullJavaClassName;     
      mDelimiter =  "|";
      
      mObjReferenceName = "this";
      mStripFullTypeName = true;
      
      //Log.i("jDumpJavaMethods", "Created!");                
    }

    public void jFree() {
      //free local objects...
    	mListMethodHeader = null;
    	mListNoMaskedMethodImplementation = null;
    }

   //write others [public] methods code here...... 
    
   public String GetMethodFullSignatureList() {
	      return mMethodFullSignature;
   }

   public String GetMethodImplementationList() {
	   return mMethodImplementation;
   }
   
    public void SetStripFullTypeName(boolean _stripFullTypeName) {  
    	mStripFullTypeName =  _stripFullTypeName;   
    }

    public boolean GetStripFullTypeName() {
       return mStripFullTypeName;   
    }

    public void SetFullJavaClassName(String _fullJavaClassName) {
    	mFullJavaClassName =  _fullJavaClassName;   
    }

    public String GetFullJavaClassName() {
       return mFullJavaClassName;   
    }
   
    public void SetObjReferenceName(String _objReferenceName) {
       mObjReferenceName = _objReferenceName;
    }

    public String GetObjReferenceName() {
        return mObjReferenceName;
    }

    public void SetDelimiter(String _delimiter) {
        mDelimiter = _delimiter;
     }

     public String GetDelimiter() {
         return mDelimiter;
     }

     public String GetMethodHeaderList() {
        return mMethodHeader;
     }
     
     public int GetMethodHeaderListSize(){
        	return mListMethodHeader.size();
     }     
  
     public String GetMethodHeaderByIndex(int _index){
      	return mListMethodHeader.get(_index);
     }
              
     public void MaskMethodHeaderByIndex(int _index){
    	String strSave = mListMethodHeader.get(_index); 
    	mListMethodHeader.set(_index, mDelimiter+strSave);
     }

     public void UnMaskMethodHeaderByIndex(int _index){
    	String strSave = (mListMethodHeader.get(_index)).substring(1); 
    	mListMethodHeader.set(_index, strSave);
     }
                                          
     public String GetNoMaskedMethodHeaderList() {
    	 String strRet= "";
    	 for(int i=0; i < mListMethodHeader.size(); i++) {
    		 if (mListMethodHeader.get(i).charAt(i) != '|') {
    			 if (i != (mListMethodHeader.size()-1) ) {  
    		        strRet = strRet + mListMethodHeader.get(i) + mDelimiter;
    			 }else {
    				strRet = strRet + mListMethodHeader.get(i); 
    			 }
    		     //Log.i("Dump_List_Header", mListMethodHeader.get(i));
    		 }
    	 }
    	 if ( strRet.length() == 0 ) {strRet = mDelimiter;}
    	 return strRet; 
     }
                               
     public String Extract() {
     	return Extract(mFullJavaClassName, mDelimiter);
     } 
      
     public String Extract(String _fullJavaClassName, String _delimiter) {
	      String str; 
	      String newStr1;
	      String newStr2;
	      String newStr3;
	      String finalStr1;
	      String finalStr2;
	      String params;
	      String auxParams;
	      String newParams;
	      String newItem;
	      String localRef;
	      String mainParam;
	      String mainItem;
	      String simpleParams="";
	      
	      int firstPos1;
	      int lastPos1;	      
	      
	      int lastPos2;	      
	      int countParams;
         //Toast.makeText(controls.activity, mMsgHello, Toast.LENGTH_SHORT).show();	      
	  try {		  
		 //String eol = System.getProperty("line.separator");		 
		 StringBuilder sbSignature = new StringBuilder();
		 StringBuilder sbImplementation = new StringBuilder();
		 StringBuilder sbHeader = new StringBuilder();
		 
         Class cls = Class.forName(_fullJavaClassName); 
         Method mth[] = cls.getDeclaredMethods();       //c.getMethods()
         
         for (int i = 0; i < mth.length; i++) {
             str= mth[i].toString(); 
        	 if (str.indexOf("private") < 0 && str.indexOf("static") < 0 &&
        		 str.indexOf("protected") < 0 && str.indexOf("$") < 0)       {
        		
        		newStr1 = str.replace(_fullJavaClassName+".", "");
        		newStr2 = newStr1.replace("native ", "");
        		                                
        		firstPos1= newStr2.lastIndexOf("(");
        		lastPos1 = newStr2.lastIndexOf(")");
        		
        		countParams = 0;            		
        		params = "";
        		auxParams= "";            		       
        		newParams= "";
        		simpleParams = "";
        		
        		if (lastPos1 > firstPos1+2) {
        			params = newStr2.substring(firstPos1+1, lastPos1);
        			countParams = 1;        		
        			int index = params.indexOf(",");        			
        			if (index > 0) {        			   
        		        String[] items = params.split(",");
        		        countParams = items.length;
        		        newItem = items[0];        	        		        
        		        mainItem = newItem;  
        		        lastPos2 = mainItem.lastIndexOf(".");        		        
        		        if (lastPos2 > 0) {
        		           mainItem = newItem.substring(lastPos2+1);
        		        }        		     
        		        if (mStripFullTypeName) {
        		        	newItem = mainItem;        		        
        		        }
        		        auxParams = "_"+mainItem.charAt(0)+"0";
        				newParams = newItem + " _"+mainItem.charAt(0)+"0";
        				simpleParams = mainItem;
        				
        		        for (int k = 1; k < items.length; k++) {        		                    		        
        		            newItem = items[k];  
        		            lastPos2 = newItem.lastIndexOf(".");        		           
        		            mainItem = newItem;
        		            
        		            if (lastPos2 > 0) {
             		           mainItem = newItem.substring(lastPos2+1);
             		        }
        		            
            		        auxParams = auxParams + ",_"+mainItem.charAt(0)+k;
        		            if (mStripFullTypeName) {
            		        	newItem = mainItem;            		        	
        		            }     
        		            newParams = newParams + ","+newItem+" _"+mainItem.charAt(0)+k;
        		            simpleParams =  simpleParams + "," + mainItem;
        		        }        		        
        			}
        			else {                			    
        				mainParam = params;
        				lastPos2 = params.lastIndexOf(".");    		        
    		        	if (lastPos2 > 0) {
    		        		mainParam = params.substring(lastPos2+1);                                                        
    		        	}
    		        	auxParams = "_"+mainParam.charAt(0)+"0";   		        	
        				newParams = params + " " + auxParams;
        				        				        				
        				if (mStripFullTypeName) {        				        					
       		        		newParams = mainParam + " " + auxParams; 
        				}
        				simpleParams =  mainParam;
        			}
        		}
        		            		
        		newStr3 = newStr2.substring(0,lastPos1+1);        		        	
        		String[] splitedStr = newStr3.split("\\s+");
        		String input = splitedStr[splitedStr.length-1];        		
        		String output = Character.toUpperCase(input.charAt(0)) + input.substring(1);
        		
        		finalStr1 = "";
        		for (int j= 0; j < splitedStr.length-1; j++) {
        		   finalStr1 = finalStr1 + " " + splitedStr[j];        		
        		}        		        		        		                		
        		if (mObjReferenceName.equals("this")) {        		   
        		   localRef = "this.";  
        	    }else{
        	    	localRef = mObjReferenceName+".";  
        	    }        		        		        		
        		
        		String innerStr0 = splitedStr[splitedStr.length-1];
        		String innerStr1 = innerStr0;
        		if (countParams > 0) {
           			int p= innerStr0.indexOf("(");       			
           			innerStr1 = innerStr0.substring(0, p)+"(" + auxParams + ")"; 
           		}	
           		
           		String newOutput= output;
           		if ( countParams > 0 ) {        			
           			int p1 = output.indexOf("(");       			
           			newOutput = output.substring(0, p1)+"(" + newParams + ")";       			
           		}
           		           		
           		if (finalStr1.contains(" void")) {  //TODO: test! add public?         		        		   
        		   finalStr2 = "public"+finalStr1 + " " + newOutput + "{"+ localRef +innerStr1+ ";}";
           		}else{
           		   finalStr2 = "public"+finalStr1 + " " + newOutput + "{return "+ localRef +innerStr1+ ";}";
           		}
           		
        		sbSignature.append(params);               		
        		sbSignature.append(_delimiter);
        		//Log.i("Dump_Sign",params);
        		
        		sbImplementation.append(finalStr2);        		
        		sbImplementation.append(_delimiter);
        		//Log.i("Dump_Impl", finalStr2);
        		
         		//----Methods Signature Resume --------
        		
        		String head0 = splitedStr[1];        		
        		String head = head0;        		
        		if ( head0.indexOf(".") > 0) {
         			String[] listHead = head0.split("\\.");         			
         			head = listHead[listHead.length-1];         			
        		}        		      		
        		String tail0 = splitedStr[splitedStr.length-1];
        		String tail1 = tail0;
        		if (countParams > 0) {
        			int p2 = tail0.indexOf("(");
        			tail1 = tail0.substring(0,p2) + "(" + simpleParams + ")";
        					//tail0.replace(params, simpleParams);
        		}	

    		  	sbHeader.append(head+" "+tail1);            		  	
            	sbHeader.append(_delimiter);
            	//Log.i("Dump_Header::", head+" "+tail1);
            	mListMethodHeader.add(head+" "+tail1);
        	 }        	 
         }  
         
         mMethodFullSignature = sbSignature.toString();                  
         mMethodImplementation = sbImplementation.toString();        
         lastPos2 = (sbHeader.toString()).lastIndexOf(_delimiter);         
         mMethodHeader = (sbHeader.toString()).substring(0, lastPos2);          
    
         /* Test...
          MaskListMethodHeader(5);
          MaskListMethodHeader(10);
       	  Log.i("Dump_Lit_4", mListMethodHeader.get(4));
       	  Log.i("Dump_Lit_5", mListMethodHeader.get(5));
       	  Log.i("Dump_Lit_9", mListMethodHeader.get(9));
       	  Log.i("Dump_Lit_10", mListMethodHeader.get(10));
       	  Log.i("Dump_Lit_11", mListMethodHeader.get(11));
       	 */         
       	 
         GetNoMaskedMethodImplementationList();            
      }
      catch (Throwable e) {
         //System.err.println(e);
    	  //Log.i("Dump_error", e.toString());
      }
	  
	  return mMethodImplementation;
    }
    
    public String GetNoMaskedMethodImplementationByIndex(int _index){
       	return mListNoMaskedMethodImplementation.get(_index);
    }
      
    public int GetNoMaskedMethodImplementationListSize(){
        	return mListNoMaskedMethodImplementation.size();
    }     
    public String GetNoMaskedMethodImplementationList() {
	      String str; 	     
	      String newStr2;
	      String newStr3;
	      String finalStr1;
	      String finalStr2;
	      String params;
	      String auxParams;
	      String newParams;
	      String newItem;
	      String localRef;
	      
	      String mainParam;
	      String mainItem;	     
	      
	      int firstPos1;
	      int lastPos1;	      
	      	          
	      int countParams;
	      
	  try {		  
	    StringBuilder sbImplementation = new StringBuilder();	    
        String mth[] = mListMethodHeader.toArray(new String[mListMethodHeader.size()]);
        for (int i = 0; i < mth.length; i++) {
          str= mth[i].toString(); 
       	  if (str.indexOf(mDelimiter)< 0)       {       		
       		newStr2 = str;       		
       		firstPos1= newStr2.lastIndexOf("(");
       		lastPos1 = newStr2.lastIndexOf(")");
       		countParams = 0;            		
       		params = "";
       		auxParams= "";            		       
       		newParams= "";
       		
       		if (lastPos1 > firstPos1+2) {
       			params = newStr2.substring(firstPos1+1, lastPos1);
       			countParams = 1;        		
       			int index = params.indexOf(",");        			
       			if (index > 0) {        			   
       		        String[] items = params.split(",");
       		        countParams = items.length;
       		        newItem = items[0];        	        		        
       		        mainItem = newItem;  
       		        
       		        auxParams = "_"+mainItem.charAt(0)+"0";
       				newParams = newItem + " _"+mainItem.charAt(0)+"0";
       				       			
       		        for (int k = 1; k < items.length; k++) {        		                    		        
       		            newItem = items[k];  
       		            mainItem = newItem;       		                   		            
           		        auxParams = auxParams + ",_"+mainItem.charAt(0)+k;       		             
       		            newParams = newParams + ","+newItem+" _"+mainItem.charAt(0)+k;       		            
       		        }        		        
       			}
       			else {                			    
       				mainParam = params;       				
   		        	auxParams = "_"+mainParam.charAt(0)+"0";   		        	
       				newParams = params + " " + auxParams;
       			}
       		}
       		
       		newStr3 = newStr2.substring(0,lastPos1+1);        		        	
       		String[] splitedStr = newStr3.split("\\s+");
       		
       		String input = splitedStr[splitedStr.length-1];        		
       		String output = Character.toUpperCase(input.charAt(0)) + input.substring(1);
       		
       		finalStr1 = "";
       		for (int j= 0; j < splitedStr.length-1; j++) {
       		   finalStr1 = finalStr1 + " " + splitedStr[j];
       		   
       		} 
       		       	
       		if (mObjReferenceName.equals("this")) {       		  
       		  localRef = "this."; 
       	    }else{
       	      localRef = mObjReferenceName+"."; 
       	    }
       		
       		String innerStr0 = splitedStr[splitedStr.length-1];
       		
       		String innerStr1 = innerStr0;       		       		
       		if (countParams > 0) {
       			int p= innerStr0.indexOf("(");       			
       			innerStr1 = innerStr0.substring(0, p)+"(" + auxParams + ")"; 
       		}	
       		
       		String newOutput= output;
       		if ( countParams > 0 ) {        			
       			int p1 = output.indexOf("(");       			
       			newOutput = output.substring(0, p1)+"(" + newParams + ")";       			
       		}	       		
       		
       		
       		if (finalStr1.contains(" void")) {           		
       			finalStr2 = "public"+finalStr1 + " " + newOutput + "{"+ localRef +innerStr1+ ";}";
       		}else{
       			finalStr2 = "public"+finalStr1 + " " + newOutput + "{return "+ localRef +innerStr1+ ";}";
       		}
       		
       		//finalStr2 = "public"+finalStr1 + " " + newOutput + "{"+ localRef +innerStr1+ ";}";
       		
       		sbImplementation.append(finalStr2);        		
       		sbImplementation.append(mDelimiter);
       		//Log.i("Dump_Produce", finalStr2);
       		
       		mListNoMaskedMethodImplementation.add(finalStr2);
       	 }        	 
        }
        mNoMaskedMethodImplementation = sbImplementation.toString();;
     }
     catch (Throwable e) {
        //System.err.println(e);
   	  //Log.i("Dump_NoMaskedImpl_error", e.toString());
     }
	 return mNoMaskedMethodImplementation;
   }
           
}

