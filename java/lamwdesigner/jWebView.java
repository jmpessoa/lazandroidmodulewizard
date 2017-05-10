package org.lamw.appmapsdemo1;

import android.util.Log;
import android.view.View;
import android.webkit.HttpAuthHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;

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
    private jCommons LAMWCommon;
    //
    private jWebClient      webclient;
    
    private OnLongClickListener onClickListener;   
    private Boolean         enabled  = true;    
    
    //Constructor
    public  jWebView(android.content.Context context,
                     Controls ctrls,long pasobj ) {
        super(context);

        //Connect Pascal I/F
        PasObj   = pasobj;
        controls = ctrls;
        LAMWCommon = new jCommons(this,context,pasobj);
        
        webclient = new jWebClient();
        webclient.PasObj   = pasobj;
        webclient.controls = ctrls;

        setWebViewClient(webclient); // Prevent to run External Browser
        this.getSettings().setJavaScriptEnabled(true);
        
        onClickListener = new OnLongClickListener() {        	
		@Override
		public boolean onLongClick(View arg0) {
			// TODO Auto-generated method stub
            if (enabled) {
                controls.pOnLongClick(PasObj,Const.Click_Default);
            }			
			return false;
		};
        };                       
        setOnLongClickListener(onClickListener);
    }


    public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
    }


    public  void setParent( android.view.ViewGroup _viewgroup ) {
    	LAMWCommon.setParent(_viewgroup);
    }

    //Free object except Self, Pascal Code Free the class.
    public  void Free() {
    	this.setOnLongClickListener(null);    	
        setWebViewClient(null);
        webclient = null;
    	LAMWCommon.free();
    }

    //by jmpessoa
    public void setLParamWidth(int _w) {
    	LAMWCommon.setLParamWidth(_w); 
    }

    public void setLParamHeight(int _h) {
    	LAMWCommon.setLParamHeight(_h);
    }

    public void setLGravity(int _g) {
    	LAMWCommon.setLGravity(_g);
    }

    public void setLWeight(float _w) {
    	LAMWCommon.setLWeight(_w);
    }

    public void addLParamsAnchorRule(int rule) {
    	LAMWCommon.addLParamsAnchorRule(rule);
    }

    public void addLParamsParentRule(int rule) {
    	LAMWCommon.addLParamsParentRule(rule);
    }

    public void setLayoutAll(int idAnchor) {
    	LAMWCommon.setLayoutAll(idAnchor);
    }

    public void clearLayoutAll() {
    	LAMWCommon.clearLayoutAll();
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
               
    public void LoadFromHtmlString(String _htmlString) {  //thanks to Anton!
       loadDataWithBaseURL(null, _htmlString, null, null, null);
    }
}
