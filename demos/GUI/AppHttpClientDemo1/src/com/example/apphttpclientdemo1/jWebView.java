package com.example.apphttpclientdemo1;

import android.view.ViewGroup;
import android.webkit.HttpAuthHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.RelativeLayout;


//-------------------------------------------------------------------------
//WebView
//-------------------------------------------------------------------------


class WVConst {	
	public static final int WebView_Act_Continue        =  0;
	public static final int WebView_Act_Break           =  1;
	public static final int WebView_OnUnknown           =  0;
	public static final int WebView_OnBefore            =  1;
	public static final int WebView_OnFinish            =  2;
	public static final int WebView_OnError             =  3;
}

//http://developer.android.com/reference/android/webkit/WebViewClient.html
class jWebClient extends WebViewClient {
//Java-Pascal Interface
public  long            PasObj   = 0;      // Pascal Obj
public  Controls        controls = null;   // Control Class for Event

public String mUsername = ""; 
public String mPassword = "";

public jWebClient(){
	//
}


@Override
public void onReceivedHttpAuthRequest(WebView view, HttpAuthHandler handler, String host, String realm) {
	handler.proceed(mUsername, mPassword);
}

@Override
public  boolean shouldOverrideUrlLoading(WebView view, String url) {
int rtn = controls.pOnWebViewStatus(PasObj,WVConst.WebView_OnBefore,url);
if (rtn == WVConst.WebView_Act_Continue)
   { view.loadUrl(url);
     return true; }
else { return true; }
}

@Override
public  void onLoadResource(WebView view, String url) {
	//
}

@Override
public  void onPageFinished(WebView view, String url) {
 controls.pOnWebViewStatus(PasObj,WVConst.WebView_OnFinish,url);
}

@Override
public  void onReceivedError(WebView view, int errorCode, String description, String failingUrl)  {
super.onReceivedError(view, errorCode, description, failingUrl);      
 if (errorCode == 401) {
     // alert to username and password
     // set it through the setHttpAuthUsernamePassword(...) 
	   controls.pOnWebViewStatus(PasObj, 401 , "login/password");
 }
 else{
     controls.pOnWebViewStatus(PasObj,WVConst.WebView_OnError, description);
 }
 
}

}

public class jWebView extends WebView {
//Java-Pascal Interface
private long             PasObj   = 0;      // Pascal Obj
private Controls        controls = null;   // Control Class for Event
//
private ViewGroup       parent   = null;   // parent view
private RelativeLayout.LayoutParams lparams;
private jWebClient      webclient;

//by jmpessoa
private int lparamsAnchorRule[] = new int[20]; 
int countAnchorRule = 0;

private int lparamsParentRule[] = new int[20]; 
int countParentRule = 0;

int lpH = RelativeLayout.LayoutParams.WRAP_CONTENT;
int lpW = RelativeLayout.LayoutParams.MATCH_PARENT; //w
int MarginLeft = 5;
int MarginTop = 5;
int marginRight = 5;
int marginBottom = 5;

//Constructor
public  jWebView(android.content.Context context,
            Controls ctrls,long pasobj ) {
super(context);
//Connect Pascal I/F
PasObj   = pasobj;
controls = ctrls;
//Init Class
webclient = new jWebClient();

webclient.PasObj   = pasobj;
webclient.controls = ctrls;
//
setWebViewClient(webclient); // Prevent to run External Browser
//
this.getSettings().setJavaScriptEnabled(true);
//
lparams = new RelativeLayout.LayoutParams  (300,300);
lparams.setMargins( 50, 50,0,0);

//
}


public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
	MarginLeft = left;
	MarginTop = top;
	marginRight = right;
	marginBottom = bottom;
	lpH = h;
	lpW = w;
}	

//
public  void setParent( android.view.ViewGroup viewgroup ) {
if (parent != null) { parent.removeView(this); }
parent = viewgroup;
viewgroup.addView(this,lparams);
}

//Free object except Self, Pascal Code Free the class.
public  void Free() {
if (parent != null) { parent.removeView(this); }
setWebViewClient(null);
webclient = null;
lparams = null;
}

//by jmpessoa
public void setLParamWidth(int w) {
lpW = w;
}

public void setLParamHeight(int h) {
lpH = h;
}

public void addLParamsAnchorRule(int rule) {
lparamsAnchorRule[countAnchorRule] = rule;
countAnchorRule = countAnchorRule + 1;
}

public void addLParamsParentRule(int rule) {
	lparamsParentRule[countParentRule] = rule;
	countParentRule = countParentRule + 1;
}

//by jmpessoa
public void setLayoutAll(int idAnchor) {
	lparams.width  = lpW; //matchParent; 
	lparams.height = lpH; //wrapContent;
	lparams.setMargins(MarginLeft,MarginTop,marginRight,marginBottom);

	if (idAnchor > 0) {    	
		for (int i=0; i < countAnchorRule; i++) {  
			lparams.addRule(lparamsAnchorRule[i], idAnchor);		
	    }
		
	} 
	for (int j=0; j < countParentRule; j++) {  
		lparams.addRule(lparamsParentRule[j]);		
}
	//
	setLayoutParams(lparams);
}

public  void setJavaScript(boolean javascript) {
	  this.getSettings().setJavaScriptEnabled(javascript);
}

	// Fatih - ZoomControl
	public  void setZoomControl(boolean zoomControl) {		
		this.getSettings().setBuiltInZoomControls(zoomControl);
	}

	//TODO: http://www.learn2crack.com/2014/01/android-oauth2-webview.html
	//Stores HTTP authentication credentials for a given host and realm. This method is intended to be used with
	public void SetHttpAuthUsernamePassword(String _hostName, String  _hostDomain, String _username, String _password) {
	   this.setHttpAuthUsernamePassword(_hostName, _hostDomain, _username, _password);
	   webclient.mUsername = _username; 
	   webclient.mPassword = _password;
	}
}
