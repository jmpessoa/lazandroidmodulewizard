package com.example.apphttpclientdemo2;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.CookieHandler;
import java.net.CookieManager;
import java.net.CookiePolicy;
import java.net.CookieStore;
import java.net.HttpCookie;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
import java.util.StringTokenizer;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Base64;
import android.util.Log;

/*Draft java code by "Lazarus Android Module Wizard" [2/16/2015 20:17:59]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl template*/

//ref. http://www.javacodegeeks.com/2013/06/android-http-client-get-post-download-upload-multipart-request.html
//ref http://lethargicpanda.tumblr.com/post/14784695735/oauth-login-on-your-android-app-the-github
public class jHttpClient /*extends ...*/ {
 
   private long     pascalObj = 0;      // Pascal Object
   private Controls controls  = null;   // Control Class -> Java/Pascal Interface ...
   private Context  context   = null;
   
   private String mUSERNAME = "USERNAME";
   private String mPASSWORD = "PASSWORD";
   private int mAuthenticationMode = 0; //0: none. 1: basic; 2= OAuth
   
   private String mHOSTNAME = null;   
   private int mPORT = -1;
     
   String httpCharSet = "UTF-8";	// default UTF-8
   
   private HashMap<String, String> ValuesForPost;   
   private CookieManager cookieManager;
   
   private HttpURLConnection client3 = null; // renabor
   
   private CookieStore cookieStore;
   
   private String mUrlString= "";
   private int mResponseCode = HttpURLConnection.HTTP_NOT_FOUND;
        
    ArrayList<String> listHeaderName = new ArrayList<String>();
    ArrayList<String> listHeaderValue = new ArrayList<String>();
    
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jHttpClient(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
      //super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;
       
      cookieManager = new CookieManager(null, CookiePolicy.ACCEPT_ALL );
                  
      CookieHandler.setDefault(cookieManager);   // <<------- CookieManager work automatically       
      
      ValuesForPost = new HashMap<String, String>();      
      
   }
      
   //https://www.nczonline.net/blog/2009/05/05/http-cookies-explained/
   
   public void jFree() {
       //free local objects...
	   if (client3 != null) client3.disconnect();
   }
 
   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
      
   public void GetAsync(String _stringUrl) {
	   mUrlString = _stringUrl;
	   new AsyncHttpClientGet().execute(_stringUrl);	   
   }
   
   public void SetCharSet(String _charSet) {	   
	   httpCharSet = _charSet;
	   //Log.i("CharSet", _charSet);
   }  
      
   ////Pascal: Get  
   public String Get(String _urlString) { //throws Exception {      
      StringBuffer sb = new StringBuffer();      
      mResponseCode = HttpURLConnection.HTTP_CREATED;
      mUrlString = _urlString;
      try {
             URL url = new URL(_urlString);
              client3 = (HttpURLConnection)url.openConnection();
              client3.setRequestMethod("GET");              
              if (mAuthenticationMode == 1) {
                 String _credentials = mUSERNAME + ":" + mPASSWORD;
                 String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
                 client3.setRequestProperty("Authorization", "Basic "+ _base64EncodedCredentials);
              }                                               
              
              int statusCode = client3.getResponseCode();
              mResponseCode = statusCode;
              
              if (statusCode == HttpURLConnection.HTTP_OK) {    //OK            	
                  InputStream inputStream = client3.getInputStream();
                  BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
                  String inputLine;
                  while ((inputLine = reader.readLine()) != null) {
                       sb.append(inputLine);
                  }
                  inputStream.close();
              } else {
                  sb.append(String.valueOf(statusCode));
               
              }                                                        
              client3.disconnect();
      } catch (Exception e) {
              return "";
      }        
      return sb.toString();
   }
     
   //by renabor
   public void AddValueForPost2(String Name, String Value) {  //Pascal: AddPostNameValueData
	   ValuesForPost.put(Name, Value);
   }
      
   //by renabor 
    public void ClearPost2Values() { // Pascal: ClearPostNameValueData
         ValuesForPost.clear();   
    }      
    
   //http://stackoverflow.com/questions/9767952/how-to-add-parameters-to-httpurlconnection-using-post 
    private String getPostDataString(HashMap<String, String> params) throws UnsupportedEncodingException{
        StringBuilder result = new StringBuilder();
        boolean first = true;
        for(Map.Entry<String, String> entry : params.entrySet()){
            if (first)
                first = false;
            else
                result.append("&");

            result.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
            result.append("=");
            result.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
        }

        return result.toString();
    }
    
    //http://www.xyzws.com/javafaq/how-to-use-httpurlconnection-post-data-to-web-server/139
    //http://stackoverflow.com/questions/9767952/how-to-add-parameters-to-httpurlconnection-using-post    
    //http://www.mkyong.com/java/how-to-send-http-request-getpost-in-java/
    //http://javatechig.com/android/android-networking-tutorial
    //http://www.rapidvaluesolutions.com/tech_blog/introduction-to-httpurlconnection-http-client-for-performing-efficient-network-operations/
    public String Post(String _urlString) { // Pascal: Post

        URL url;
        String response = "";
        String Params;
        mResponseCode = HttpURLConnection.HTTP_CREATED;
        
        mUrlString = _urlString;
        
        try {
            url = new URL(_urlString);

            client3 = (HttpURLConnection) url.openConnection();
            client3.setReadTimeout(15000);
            client3.setConnectTimeout(15000);
            client3.setRequestMethod("POST");                        
                        
            client3.setDoInput(true);
            client3.setDoOutput(true);
          
            Params = getPostDataString(ValuesForPost);            
            client3.setFixedLengthStreamingMode(Params.getBytes().length);
            //client3.setFixedLengthStreamingMode(Params.length());
            
            if (mAuthenticationMode == 1) {
                String _credentials = mUSERNAME + ":" + mPASSWORD;
                String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
                client3.setRequestProperty("Authorization", "Basic "+ _base64EncodedCredentials);
            }
            
            client3.setRequestProperty("Charset", "UTF-8");
            client3.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");            
                                   
            OutputStream os = client3.getOutputStream();
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
                      
            writer.write(Params);
            writer.flush();
            writer.close();
            os.close();
            
            int responseCode=client3.getResponseCode();            
            mResponseCode = responseCode;
            
            if (responseCode == HttpURLConnection.HTTP_OK /*HttpsURLConnection.HTTP_OK*/ ) {
                String line;
                BufferedReader br=new BufferedReader(new InputStreamReader(client3.getInputStream()));
                while ((line=br.readLine()) != null) {
                    response+=line;
                }
            }
            else {
                response= String.valueOf(responseCode);
            }
            
        } catch (Exception e) {
        	//Log.i("test", e.printStackTrace());
        	Log.e("http", "POST", e);            
        	return "Error...";
        }

        return response;
    }
    
   public void SetAuthenticationUser(String _userName, String _password) {       	 
	  mUSERNAME = _userName;
	  mPASSWORD =_password;
   }
     
   public void SetAuthenticationHost(String _hostName, int _port) {
   	 if ( _hostName.equals("") ) {
    		 mHOSTNAME = null;
   	 } 
   	 else {
    		 mHOSTNAME = _hostName;
   	 }
   	 mPORT = _port;	 
   }
               
   public void SetAuthenticationMode(int _authenticationMode) {    	 
      mAuthenticationMode = _authenticationMode; //0: none. 1: basic; 2= OAuth	 	                
   }
     
	/*
	 * AsyncTask has three generic types:
      Params: An array of parameters you want to pass in to the class you create when you subclass AsyncTask.
      Progress: If you override onProgressUpdate, this is the type that method returns.
      Result: This is the type that doInBackground returns.
	 */
   
     //ref. http://mobiledevtuts.com/android/android-http-with-asynctask-example/
   
   public void PostNameValueDataAsync(String _stringUrl, String _name, String _value) {
	  mUrlString = _stringUrl; 
 	  ValuesForPost.clear();
	  ValuesForPost.put(_name, _value);
	  new AsyncHttpClientPostNameValueData().execute(_stringUrl, "", "");	  
   }
  	
	public void PostNameValueDataAsync(String _stringUrl, String _listNameValue) {
	    StringTokenizer st = new StringTokenizer(_listNameValue, "=&"); //name1=value1&name2=value2&name3=value3 ...						
		
	    ValuesForPost.clear();
		
	    mUrlString = _stringUrl;
		
		while(st.hasMoreTokens()) { 
		  String key = st.nextToken(); 
		  String val = st.nextToken(); 
		  //Log.i("name ->", key);
		  //Log.i("value ->", val);
		  ValuesForPost.put(key, val);
		}	
		new AsyncHttpClientPostNameValueData().execute(_stringUrl, "", "");	
	   //new AsyncHttpClientPostListNameValueData().execute(_stringUrl, _listNameValue);     
    }
	
	public void PostNameValueDataAsync(String _stringUrl) {
	   mUrlString = _stringUrl;
	   new AsyncHttpClientPostNameValueData().execute(_stringUrl, "", "");
	}
	
	//-----------------------
	//Cookies
	//-----------------------		   
		   /*http://stackoverflow.com/questions/16150089/how-to-handle-cookies-in-httpurlconnection-using-cookiemanager
		    *  
		    *http://www.concretepage.com/java/example_cookiemanager_java 
		    *https://czheng035.wordpress.com/2012/06/18/cookie-management-in-android-webview-development/ OTIMO!
		    *
		    *http://stackoverflow.com/questions/14860087/should-httpurlconnection-with-cookiemanager-automatically-handle-session-cookies
		    *  
		   HttpCookie cookie = new HttpCookie("lang", "fr");
		   cookie.setDomain("twitter.com");
		   cookie.setPath("/");
		   cookie.setVersion(0);
		   cookieManager.getCookieStore().add(new URI("http://twitter.com/"), cookie)   
		   */
	
    public HttpCookie AddCookie(String _name, String _value)  {        
    	HttpCookie cookie = new HttpCookie(_name, _value);
    	//cookie.setDomain("your domain");cookie.setPath("/");    	
    	cookieStore = cookieManager.getCookieStore();
     	//cookieStore.add(Uri, cookie);
		cookieStore.add(null, cookie); //All URIs		
		return cookie;
    }

    public HttpCookie AddCookie(String _url, String _name, String _value)  {        
       HttpCookie cookie = new HttpCookie(_name, _value);
       //cookie.setDomain("your domain");cookie.setPath("/");    	
       cookieStore = cookieManager.getCookieStore();    	
       URI Uri;
   	   try {
   		Uri = new URI(_url);
   	     cookieStore.add(Uri, cookie);
 		 //cookieStore.add(null, cookie); //All URIs   		
   	   } catch (Exception e) {
   		// TODO Auto-generated catch block
   		   e.printStackTrace();
   	   }   	        			
	   return cookie;
    }
    
    public String GetCookieValue(HttpCookie _cookie) {    
        return _cookie.getValue();        
    }
    
	public String[] GetCookies(String _nameValueSeparator) {
				
		 ArrayList<String> list = new ArrayList<String>();
		 try {
			 cookieStore = cookieManager.getCookieStore();			
		    List<HttpCookie> cookies = cookieStore.getCookies(); //all URIs
		    if (!cookies.isEmpty()) {
			      for (HttpCookie cookie : cookies){
			    	  list.add(cookie.getName() + _nameValueSeparator + cookie.getValue());	         
			      }		  
		    }
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 		 	  
	    return list.toArray(new String[list.size()]);
	}
		
	public String[] GetCookies(String _urlString, String _nameValueSeparator) {  //Cookies		  
		
	   ArrayList<String> list = new ArrayList<String>();   
	   cookieStore = cookieManager.getCookieStore();		   
	   URI uri;
	   try {
		 uri = new URI(_urlString);
		 List<HttpCookie> cookies = cookieStore.get(uri);
		 //List<HttpCookie> cookies = cookieStore.getCookies();  //All URIs		 
  	     if( !cookies.isEmpty() ){
			    for (HttpCookie cookie : cookies){
			   	  list.add(cookie.getName() + _nameValueSeparator + cookie.getValue());	         
			    }
		 }
		 
	   } catch (Exception e) {
		// TODO Auto-generated catch block
		   e.printStackTrace();
	   }	   	   	 	   			   
		return list.toArray(new String[list.size()]);			
    }
		   	
	public int GetCookiesCount() {	  
	  cookieStore = cookieManager.getCookieStore();	
	  return cookieStore.getCookies().size();
	}	 		  
		
	public HttpCookie GetCookieByIndex(int _index) {
		cookieStore = cookieManager.getCookieStore();					
		if (_index <  cookieStore.getCookies().size()) 
	       return cookieStore.getCookies().get(_index);
		else return  null;
	}
		      
    public String GetCookieAttributeValue(HttpCookie _cookie, String _attribute) {
			  String r = ""; 
			  if (_attribute.equals("name"))  r = _cookie.getName();
			  else if (_attribute.equals("value")) r = _cookie.getValue();
			  else if (_attribute.equals("domain")) r = _cookie.getDomain();
			  else if (_attribute.equals("version")) r = String.valueOf(_cookie.getVersion()); //getExpiryDate().toString()
			  else if (_attribute.equals("expirydate")) r = ""+_cookie.getMaxAge();//DateFormat.format("yyyyMMdd  kk:mm",  _cookie.getExpiryDate()).toString();
			  else if (_attribute.equals("path")) r = _cookie.getPath();
			  else if (_attribute.equals("comment")) r = _cookie.getComment();			  
			  else if (_attribute.equals("ports")) r = String.valueOf(_cookie.getPortlist()); //.getPorts()
			  return r;
    }
		   		   
    public void ClearCookieStore() {
    	cookieStore = cookieManager.getCookieStore();
	    cookieStore.removeAll(); 			  
    }
	
    //http://stackoverflow.com/questions/14860087/should-httpurlconnection-with-cookiemanager-automatically-handle-session-cookies   
    
    //http://www.mkyong.com/java/how-to-automate-login-a-website-java-example/
    //
    
    public HttpURLConnection OpenConnection(String _urlString) {
  	   //ArrayList<String> list = new ArrayList<String>();
  	   //Values must be set prior to calling the connect method:
      client3 = null;	
  	  try {
  		 mUrlString = _urlString;
  		 URL url = new URL(_urlString);                   	       
          client3 = (HttpURLConnection)url.openConnection();          		 
  	  } catch (IOException e) {
  		//TODO Auto-generated catch block
  		e.printStackTrace();
  	  }
  	  return  client3;
  	  
     }
    
    
    //Sets the general request property. If a property with the key already exists, overwrite its value with the new value.
    public HttpURLConnection SetRequestProperty(HttpURLConnection _httpConnection, String _headerName,  String _headerValue) {
  	   //ArrayList<String> list = new ArrayList<String>();
  	   //Values must be set prior to calling the connect method:
  	 	 // _HeaderValue = "userId=igbrown; sessionId=SID77689211949; isAuthenticated=true";
    	if (_httpConnection != null)
    		_httpConnection.setRequestProperty(_headerName, _headerValue); 		 
  		//Send the cookie to the server:
  		//To send the cookie, simply call connect() on the URLConnection for which we have added the cookie property:	  	    		 
    	//httpClient.connect();		 
  	   return  _httpConnection;
     }
    
    
    //Adds a general request property specified by a key-value pair. 
    //This method will not overwrite existing values associated with the same key.
    
    public HttpURLConnection AddRequestProperty(HttpURLConnection _httpConnection, String _headerName,  String _headerValue) {
   	   //ArrayList<String> list = new ArrayList<String>();
   	   //Values must be set prior to calling the connect method:
   	 	 // _HeaderValue = "userId=igbrown; sessionId=SID77689211949; isAuthenticated=true";
     	if (_httpConnection != null)
     		_httpConnection.addRequestProperty(_headerName, _headerValue); 		 
   		//Send the cookie to the server:
   		//To send the cookie, simply call connect() on the URLConnection for which we have added the cookie property:	  	    		 
     	//httpClient.connect();		 
   	   return  _httpConnection;
      }
    
    /*
    public HttpURLConnection Connect(HttpURLConnection _httpConnection) {
    	try {
    		if (_httpConnection != null)
    			_httpConnection.connect();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			_httpConnection = null;
			Log.e("HttpURLConnection", "Connect", e);
			//e.printStackTrace();
		}		 
   	   return  _httpConnection;
   }
   */ 
    
    public HttpURLConnection GetDefaultConnection() {
    	return client3;
    }
    //http://www.hccp.org/java-net-cookie-how-to.html
         
    public String GetHeaderField(HttpURLConnection _httpConnection, String _headerName) {    	
    	   //ArrayList<String> list = new ArrayList<String>();    	   
 		   String headerName=null;
 		   String _field ="";
 		  
 		   if (_httpConnection == null) return "";
 		  
 		   for (int i=1; (headerName = _httpConnection.getHeaderFieldKey(i))!=null; i++) {
 			    //Log.i("headers..", headerName);  //Keep-Alive ... Server ... Set-Cookie ... etc.. 
 		    	if (headerName.equals(_headerName)) {   		    		
 		    		_field = _httpConnection.getHeaderField(i); 		   	        
 		   	 	   //Loop through response headers looking for cookies:
 		   	 	   //Since a server may set multiple cookies in a single request, we will need to loop through the response headers, looking for all headers named "Set-Cookie". 		   	                                                      
 		   	 	   //Extract cookie name and value from cookie string:
 		   	 	   //The string returned by the getHeaderField(int index) method is a series of name=value separated by semi-colons (;). The first name/value pairing is actual data string we are interested in (i.e. "sessionId=0949eeee22222rtg" or "userId=igbrown"), the subsequent name/value pairings are meta-information that we would use to manage the storage of the cookie (when it expires, etc.).	   					
 		   	 	   //This is basically it. We now have the cookie name (cookieName) and the cookie value (cookieValue).
 		   	        
 		    	}     		  
 		   }
 		   
 	       return _field;
     }
               
    //ref. http://blog.leocad.io/basic-http-authentication-on-android/
    //ref. http://simpleprogrammer.com/2011/05/25/oauth-and-rest-in-android-part-1/
    //ref. http://jan.horneck.info/blog/androidhttpclientwithbasicauthentication
    
    public String[] GetHeaderFields(HttpURLConnection _httpConnection) {   
 	    ArrayList<String> list = new ArrayList<String>();
 	    
 	    if (_httpConnection == null) return null;
 	   
 		try {
 		     Map<String, List<String>> hdrs = _httpConnection.getHeaderFields();
 		     Set<String> hdrKeys = hdrs.keySet();
 		     for (String k : hdrKeys) {
 		    	 if (k != null) 
 		    	    list.add(k + "=" + hdrs.get(k)); 		    
 		     }   		     
 		} catch (Exception e) {
 			// TODO Auto-generated catch block
 			e.printStackTrace();
 		}
 		
 		return list.toArray(new String[list.size()]);  	   
   }
    
    public void Disconnect(HttpURLConnection _httpConnection) {
         _httpConnection.disconnect();
    }
    
    public String Get(HttpURLConnection _httpConnection) {          
      StringBuffer sb = new StringBuffer();      
      try {
    	      _httpConnection.setRequestMethod("GET");
    	          	      
              if (mAuthenticationMode == 1) {
                  String _credentials = mUSERNAME + ":" + mPASSWORD;
                  String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
                  _httpConnection.setRequestProperty("Authorization", "Basic "+ _base64EncodedCredentials);
               }
    	      
     	 	  for (int i = 0; i < listHeaderName.size(); i++ ) { 	      	 	      	 		         	 		  
     	 		  _httpConnection.setRequestProperty(listHeaderName.get(i), listHeaderValue.get(i));
  	 	      }
     	 	  
              /* optional request header */
              //client3.setRequestProperty("Content-Type", "application/json");
              /* optional request header */
              //client3.setRequestProperty("Accept", "application/json");    	          	 	                  
              int status = _httpConnection.getResponseCode(); 
              mResponseCode = status;
              
              if (status == HttpURLConnection.HTTP_OK) {              
                 InputStream inputStream = _httpConnection.getInputStream();
                 BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
                 String inputLine;
                 while ((inputLine = reader.readLine()) != null) {
                    sb.append(inputLine);
                 }
                 inputStream.close();
              }
              else {
            	 sb.append(String.valueOf(status));  
              }
            	  
                            
      } catch (Exception e) {
    	      Log.e("HttpURLConnection", "Get", e);
              return "Error";
      }       
      return sb.toString();
   }
   
    public String Post(HttpURLConnection _httpConnection) {      
        
    	String response = "";
        String Params= "";
        mResponseCode = HttpURLConnection.HTTP_CREATED;
        
        try {     
        	_httpConnection.setRequestMethod("POST");                                     
        	_httpConnection.setDoInput(true);
        	_httpConnection.setDoOutput(true);
        	
            Params = getPostDataString(ValuesForPost);            
            _httpConnection.setFixedLengthStreamingMode(Params.getBytes().length);
            
            if (mAuthenticationMode == 1) {
                String _credentials = mUSERNAME + ":" + mPASSWORD;
                String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
                _httpConnection.setRequestProperty("Authorization", "Basic "+ _base64EncodedCredentials);
            }
            
            _httpConnection.setRequestProperty("Charset", "UTF-8");
            _httpConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        	
   	 	    for (int i = 0; i < listHeaderName.size(); i++ ) { 	      	 	      	 		         	 		  
 	 		  _httpConnection.setRequestProperty(listHeaderName.get(i), listHeaderValue.get(i));
	 	    }        	           
   	 	    
            OutputStream os = _httpConnection.getOutputStream();
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
                        
            writer.write(Params);
            writer.flush();
            writer.close();
            
            os.close();
            
            int responseCode=_httpConnection.getResponseCode();
            mResponseCode = responseCode;
            
            if (responseCode == HttpURLConnection.HTTP_OK /*HttpsURLConnection.HTTP_OK*/ ) {
                String line;
                BufferedReader br = new BufferedReader(new InputStreamReader(_httpConnection.getInputStream()));
                while ((line=br.readLine()) != null) {
                    response+=line;
                }
            }
            else {
                response= String.valueOf(responseCode);
            }
            
            
        } catch (Exception e) {
        	Log.e("HttpURLConnection", "Post", e);
            //e.printStackTrace();
            return "Error";
            
        }
        
        return response;
    } 
          
    public int GetResponseCode() {    	
      return mResponseCode;      
    }
            
    //thanks to Renabor
    public boolean UrlExist(String _urlString) {
          HttpURLConnection client;          
 	      int status = HttpURLConnection.HTTP_NOT_FOUND; 	 
 	      try { 	         
 	         URL url = new URL(_urlString); 	         
 	         mUrlString = _urlString;	         
 	         client = (HttpURLConnection)url.openConnection(); 	          	         
 	         client.setRequestMethod("HEAD");
 	         client.setConnectTimeout(30000);
 	         client.setReadTimeout(30000);
 	         
             if (mAuthenticationMode == 1) {
                 String _credentials = mUSERNAME + ":" + mPASSWORD;
                 String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
                 client.setRequestProperty("Authorization", "Basic "+ _base64EncodedCredentials);
              }
             
 	         status = client.getResponseCode();
 	         mResponseCode = status;
 	         
 	      } catch (IOException e) {
 	         //Log.e("Error. Url not found","try 1",e);
 	      } finally {
 	         if (status == HttpURLConnection.HTTP_OK ) { return true; }
 	      }
 	      return false;          
    }
    
    /*
    private Date StringToDate(String dateString) {
      //String dateString = "03/26/2012 11:49:00 AM";
      SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss aa");
      Date convertedDate = new Date();
      try {
         convertedDate = dateFormat.parse(dateString);
      } catch (ParseException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }      
      return convertedDate;
    }
    */
    
    public void SetCookieAttributeValue(HttpCookie _cookie, String _attribute,  String _value) {
		   
    	  HttpCookie stdCookie = (HttpCookie)_cookie;	
    	  
		  if (_attribute.equals("value")) stdCookie.setValue(_value);
		  else if (_attribute.equals("domain")) stdCookie.setDomain(_value);
		  else if (_attribute.equals("version")) stdCookie.setVersion(Integer.parseInt(_value));
		  
		  else if (_attribute.equals("expirydate")) {  
			  stdCookie.setMaxAge(Long.parseLong(_value));  //setExpiryDate(StringToDate(_value));
		  }	  
		  
		  else if (_attribute.equals("path")) stdCookie.setPath(_value);
		  else if (_attribute.equals("comment"))  stdCookie.setComment(_value);
		  else if (_attribute.equals("ports"))  stdCookie.setSecure(false);	
		  
		  //stdCookie.setPorts(new int[] {80,8080});
    }    
    
    public String GetCookieName(HttpCookie _cookie) {    
        return _cookie.getName();        
    }
    
    public void SetCookieValue(HttpCookie _cookie, String _value) {    
       ((HttpCookie)_cookie).setValue(_value);
       cookieStore = cookieManager.getCookieStore();
       cookieStore.add(null, _cookie);     
    }
    
    
    public HttpCookie GetCookieByName(String _cookieName) {
    	HttpCookie ret = null;
    	cookieStore = cookieManager.getCookieStore();
    	
        List<HttpCookie> l = cookieStore.getCookies();
        for (HttpCookie c : l) {
            if (c.getName().equals(_cookieName)) {
                ret = c;
                break;
            }
        }
        return ret;
    }
    
    
    public boolean IsExpired(HttpCookie _cookie) { 
	  return _cookie.hasExpired();  //isExpired(new Date()); //true if the cookie has expired. 
	}
	    
    public boolean IsCookiePersistent(HttpCookie _cookie) { 
 	  return _cookie.getDiscard();    //isPersistent(); //true if the cookie is Discard 
 	}

    //-----------------------------------    
    
    /*Overwrites the first header with the same name. 
     * The new header will be appended to the end of the list, 
     * if no header with the given name can be found.
     * httpget.setHeader("Cookie",  "JSESSIONID=1"); //Here i am sending the Cookie session ID
    */
    
    public void AddClientHeader (String _name, String _value ) {    	
    	listHeaderName.add(_name);
    	listHeaderValue.add(_value);    	    	
    }
    
    public void ClearClientHeader (String _name, String _value ) {    	
    	listHeaderName.clear();
    	listHeaderValue.clear();    	    	
    }
    
   /*
    *Set cookies in requests
    CookieManager cookieManager = CookieManager.getInstance();
    String cookie = cookieManager.getCookie(urlConnection.getURL().toString());
    if (cookie != null) {
        urlConnection.setRequestProperty("Cookie", cookie);
    }
    */
    
    public String GetStateful(String _url) {
    	int status = HttpURLConnection.HTTP_NOT_FOUND;
        StringBuffer sb = new StringBuffer();     	
 		String strResult = "";
 		mResponseCode = HttpURLConnection.HTTP_CREATED;
 		 	    
 	    try {
 	              URL url = new URL(_url);
 	              client3 = (HttpURLConnection)url.openConnection();
 	              client3.setRequestMethod("GET");
 	            
 	              if (mAuthenticationMode == 1) {
  	                 String _credentials = mUSERNAME + ":" + mPASSWORD;
  	                 String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
  	                 client3.setRequestProperty("Authorization", "Basic "+ _base64EncodedCredentials);
  	              }      
 	              
 	     	 	  for (int i = 0; i < listHeaderName.size(); i++ ) { 	      	 	      	 		         	 		  
 	     	 		client3.setRequestProperty(listHeaderName.get(i), listHeaderValue.get(i));
 	  	 	      }
 	     	 	  
 	              /* optional request header */
 	              //client3.setRequestProperty("Content-Type", "application/json");
 	              /* optional request header */
 	              //client3.setRequestProperty("Accept", "application/json");
 	               	     	 	  
 	              status = client3.getResponseCode();
 	              mResponseCode = status;
 	             
 	              if (status == HttpURLConnection.HTTP_OK) {
 	                InputStream inputStream = client3.getInputStream();
 	                BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
 	                String inputLine;
 	                while ((inputLine = reader.readLine()) != null) {
 	                   sb.append(inputLine);
 	                }
 	                inputStream.close(); 	               	             
 	              }
 	              else {
 	            	 sb.append(String.valueOf(status)); 
 	              }
 	              
 	              client3.disconnect();
 	              
 	      } catch (Exception e) {
 	              return "";
 	      } 
 	      return sb.toString();		 		
    }     
   
                
    public String PostStateful(String urlString) throws Exception {
        StringBuffer sb = new StringBuffer();
        StringBuilder _postData = new StringBuilder();
        mResponseCode = HttpURLConnection.HTTP_CREATED;
        
        for (Map.Entry<String,String> param : ValuesForPost.entrySet()) {
               if (_postData.length() != 0) _postData.append('&');
               try {
                  _postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
                  _postData.append('=');
                  _postData.append(URLEncoder.encode(param.getValue(), "UTF-8"));
               } catch(UnsupportedEncodingException e) {
                   //Log.e("showmessage","PostStateful UnsupportedEncodingException",e);
               }
        }
        
        String postData = _postData.toString();
        try {
            URL url = new URL(urlString);
            client3 = (HttpURLConnection)url.openConnection();
            client3.setRequestMethod("POST");            
            client3.setDoOutput(true);
            
            client3.setFixedLengthStreamingMode(postData.getBytes().length);  // !!!!!
            //client3.setFixedLengthStreamingMode(postData.length());
            
            if (mAuthenticationMode == 1) {
                String _credentials = mUSERNAME + ":" + mPASSWORD;
                String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
                client3.setRequestProperty("Authorization", "Basic "+ _base64EncodedCredentials);
             }
            
            client3.setRequestProperty("Charset", "UTF-8");
            client3.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            
    	 	for (int i = 0; i < listHeaderName.size(); i++ ) { 	      	 	      	 		         	 		  
    	 		client3.setRequestProperty(listHeaderName.get(i), listHeaderValue.get(i));
 	 	    }
                                    
                                 
            PrintWriter out = new PrintWriter(client3.getOutputStream());
            out.print(postData);
            out.close();
            
            int statusCode = client3.getResponseCode(); 
            mResponseCode = statusCode;
            
            if (statusCode == HttpURLConnection.HTTP_OK) {    //OK
            	
            	//String statusLine = client3.getResponseMessage();            	
                Scanner inStream = new Scanner(client3.getInputStream());
                //process the stream and store it in StringBuilder
                while(   inStream.hasNextLine()) sb.append(inStream.nextLine()); // response+=(inStream.nextLine());
                
                inStream.close();
                
            } else {
                sb.append(String.valueOf(statusCode));
            }                        
            client3.disconnect();
            
        } catch (Exception e) {
            //Log.e("showmessage","PostStateful Error",e);
        	return "";
        }         
        ValuesForPost.clear();        
        return sb.toString();
     }
        
    //thanks to @renabor    
    public String DeleteStateful(String _stringUrl, String _value) throws Exception {          
        int statusCode = 0;
        StringBuilder sb = new StringBuilder();
        String statusLine;
        mResponseCode = HttpURLConnection.HTTP_CREATED;
        try {
           URL url = new URL(_stringUrl + "/" + _value);
           client3 = (HttpURLConnection)url.openConnection();
           // renabor
           if (mAuthenticationMode == 1) {
              String _credentials = mUSERNAME + ":" + mPASSWORD;
              String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
              client3.setRequestProperty("Authorization", "Basic "+ _base64EncodedCredentials);            
           }   
           client3.setRequestMethod("DELETE");
           statusCode = client3.getResponseCode();
           mResponseCode = statusCode;
           // statusLine = client3.getResponseMessage();
           if (statusCode == HttpURLConnection.HTTP_OK) {    //OK
        	   
              Scanner inStream = new Scanner(client3.getInputStream());
              //process the stream and store it in StringBuilder
              while(   inStream.hasNextLine()) sb.append(inStream.nextLine()); // response+=(inStream.nextLine());
              
              inStream.close();
              
           } else {
              sb.append(String.valueOf(statusCode));
              // Log.i("showmessage http delete error ",String.valueOf(statusCode) +" "+ statusLine); 
           }
           client3.disconnect();
        } catch (Exception e) {
           //Log.e("showmessage","DeleteStateful Error",e);
           return "";
        }
        return sb.toString(); 
     }  
    
	/*
	 * AsyncTask has three generic types:
       Params: An array of parameters you want to pass in to the class you create when you subclass AsyncTask.
       Progress: If you override onProgressUpdate, this is the type that method returns.
       Result: This is the type that doInBackground returns.
	 */
	
	class AsyncHttpClientPostNameValueData extends AsyncTask<String, Integer, String> {	
		  
	    @Override
	    protected String doInBackground(String... stringUrl) {
	        URL url;
	        String response = "";
	        String Params;
			// Create a new HttpClient and Post Header
			int statusCode = 0;						
		    //AuthScope:
		    //host  the host the credentials apply to. May be set to null if credenticals are applicable to any host. 
		    //port  the port the credentials apply to. May be set to negative value if credenticals are applicable to any port.
	        try {
	            url = new URL(stringUrl[0]);

	            client3 = (HttpURLConnection) url.openConnection();
	            mResponseCode = HttpURLConnection.HTTP_CREATED;
	            
	            if (mAuthenticationMode == 1) {
	                String _credentials = mUSERNAME + ":" + mPASSWORD;
	                String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
	                client3.setRequestProperty("Authorization", "Basic "+ _base64EncodedCredentials);
	            }
	            
	            client3.setReadTimeout(15000);
	            client3.setConnectTimeout(15000);
	            client3.setRequestMethod("POST");
	              	    	 	
	            client3.setDoInput(true);
	            client3.setDoOutput(true);
	            
	            Params = getPostDataString(ValuesForPost);            
	            client3.setFixedLengthStreamingMode(Params.getBytes().length); //Params.length
	            
	            client3.setRequestProperty("Charset", "UTF-8");
	            client3.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
	            
	    	 	for (int i = 0; i < listHeaderName.size(); i++ ) { 	      	 	      	 		         	 		  
	    	 		client3.setRequestProperty(listHeaderName.get(i), listHeaderValue.get(i));
	 	 	    }
	         	            	            
	            OutputStream os = client3.getOutputStream();
	            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, "UTF-8"));
	            	    	            
	            writer.write(Params);
	            
	            writer.flush();
	            writer.close();
	            os.close();
	            
	            int responseCode = client3.getResponseCode();   
	            mResponseCode = responseCode;
	            
	            this.publishProgress(responseCode);	  
	            
	            if (responseCode == HttpURLConnection.HTTP_OK /*HttpsURLConnection.HTTP_OK*/ ) {
	                String line;
	                BufferedReader br=new BufferedReader(new InputStreamReader(client3.getInputStream()));
	                while ((line=br.readLine()) != null) {
	                    response+=line;
	                }
	            }
	            else {
	                response= String.valueOf(responseCode);
	            }
	            	            
	        } catch (Exception e) {
	            //e.printStackTrace();
	            return "";
	        }
	        
	        return response;
	    }	    	
	           	    
	    @Override
	    protected void onPostExecute(String content) {
	      controls.pOnHttpClientContentResult(pascalObj, content);
	    }
	    	    
	    @Override
	    protected void onProgressUpdate(Integer... params) {
	       super.onProgressUpdate(params);	       
	       controls.pOnHttpClientCodeResult(pascalObj, params[0].intValue());	  	     
	    }
	}
				
	class AsyncHttpClientGet extends AsyncTask<String,Integer,String> {	
		  	    
	    @Override
	    protected String doInBackground(String... stringUrl) {	    	
	        int status = HttpURLConnection.HTTP_NOT_FOUND;
	        StringBuffer sb = new StringBuffer();	        	        
	        try {
	                URL url = new URL(stringUrl[0]);
	                mResponseCode = HttpURLConnection.HTTP_CREATED;	                
	                 client3 = (HttpURLConnection)url.openConnection();
	                 client3.setRequestMethod("GET");
	                 
	                 if (mAuthenticationMode == 1) {
		                    String _credentials = mUSERNAME + ":" + mPASSWORD;
		                    String _base64EncodedCredentials = Base64.encodeToString(_credentials.getBytes(), Base64.NO_WRAP);
		                    client3.setRequestProperty("Authorization", "Basic "+ _base64EncodedCredentials);
		             }
	                 
	         	 	 for (int i = 0; i < listHeaderName.size(); i++ ) { 	      	 	      	 		         	 		  
	        	 		client3.setRequestProperty(listHeaderName.get(i), listHeaderValue.get(i));
	     	 	     } 
	         	 		                
	                 status = client3.getResponseCode();
	                 mResponseCode = status;
	                 
	 	             this.publishProgress(status);
	 	             
	 	             if (status == HttpURLConnection.HTTP_OK) {    //OK            	
	                   InputStream inputStream = client3.getInputStream();
	                   BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));	                 
	                   String inputLine;	                 	                	                 
	                   while ((inputLine = reader.readLine()) != null) {
	                     sb.append(inputLine);
	                   } 	                 
	                   inputStream.close();
	 	             }
	 	             else {
	 	               sb.append(String.valueOf(status));	
	 	             }	 	            		                	 	             
	                 client3.disconnect();
	                 
	        } catch (Exception e) {
	            return "";	           
	        }
	            
	        return sb.toString(); 
	    }	    	
	           	            
	    @Override
	    protected void onPostExecute(String content) {
	      controls.pOnHttpClientContentResult(pascalObj, content);
	    }
	    	    
	    @Override
	    protected void onProgressUpdate(Integer... params) {
	       super.onProgressUpdate(params);	       
	       controls.pOnHttpClientCodeResult(pascalObj, params[0].intValue());	  	     
	    }	    	    	    
	}
}

