package org.lamw.applamwprojecttest1;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.http.SslError;
import android.os.Build;
//import android.util.Log;
import android.view.View;
import android.webkit.HttpAuthHandler;
import android.webkit.SslErrorHandler;
import android.webkit.ValueCallback;
//import android.webkit.WebResourceRequest;
//import android.webkit.WebResourceResponse;
import android.webkit.WebView;
//import android.webkit.WebView.FindListener; //LMB
import android.webkit.WebViewClient;

//-------------------------------------------------------------------------
// WebView
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

    /*@Override
    public  boolean shouldOverrideUrlLoading(WebView view, String url) {
        int rtn = controls.pOnWebViewStatus(PasObj,WVConst.WebView_OnBefore,url);
        if (rtn == WVConst.WebView_Act_Continue)
        { view.loadUrl(url);
            return true; }
        else { return true; }
    }*/
    
    @Override
    public  boolean shouldOverrideUrlLoading(WebView view, String url) {
    	    	
        int rtn = controls.pOnWebViewStatus(PasObj,WVConst.WebView_OnBefore,url);
        
        if (rtn == WVConst.WebView_Act_Continue)
        { 
        	
        	if (url.startsWith("intent://")) {
                try {
                    
                    Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);

                    if (intent != null) {
                        view.stopLoading();                                                                    

                        PackageManager packageManager = controls.activity.getPackageManager();
                        ResolveInfo info = packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY);
                        
                        if (info != null) {
                        	 controls.activity.startActivity(intent);
                        	 
                        	 if(view.canGoBack())
                             	view.goBack();   
                        } else {                        	
                            String fallbackUrl = intent.getStringExtra("browser_fallback_url");
                            view.loadUrl(fallbackUrl);                            
                        }

                        return true;
                    }
                } catch (Throwable e) {
                   //if (GeneralData.DEBUG) {
                   //     Log.e(TAG, "Can't resolve intent://", e);
                    
                }
        		
            }else{
            	view.loadUrl(url);	
            }                
        	         
        }  
         
        return true; 
        
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

    //https://www.ti-enxame.com/pt/android/o-android-webview-nao-esta-carregando-um-url-https/940018636/
    @Override
    public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
        //super.onReceivedSslError(view, handler, error); //DOT CALL SUPER METHOD !!!!
        boolean proceed = false;
        String message = error.toString();

        //Log.i("LAMW", "0:  "+message);

        switch (error.getPrimaryError()) {
            case SslError.SSL_NOTYETVALID:
                message = "The certificate is not yet valid.";
                break;

            case SslError.SSL_EXPIRED:
                message = "The certificate has expired.";
                break;

            case SslError.SSL_IDMISMATCH:
                message = "The certificate Hostname mismatch.";
                break;

            case SslError.SSL_UNTRUSTED:
                message = "The certificate authority is not trusted.";
                break;
        }

        //Log.i("LAMW", "1:  "+message);

        proceed = controls.pOnWebViewReceivedSslError(PasObj, message, error.getPrimaryError());

        if (proceed) {
            //Log.i("LAMW", "2:  TRUE");
            handler.proceed();
        }
        else {
            handler.cancel();
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

	//LMB:
  	private FindListener findListener;
    private int findIndex = 0;
  	private int findCount = 0;

  	public jWebView MyWebView;
  	public String MyJSCode;
    
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

        MyWebView =  this;

        this.getSettings().setJavaScriptEnabled(true);
        this.getSettings().setDomStorageEnabled(true);
        this.getSettings().setBuiltInZoomControls(true);

        setWebViewClient(webclient); // Prevent to run External Browser

        onClickListener = new OnLongClickListener() {        	
		@Override
		public boolean onLongClick(View arg0) {
			// TODO Auto-generated method stub
            if (enabled) {
                controls.pOnLongClick(PasObj);
            }			
			return false;
		};

        };
        setOnLongClickListener(onClickListener);

        //[ifdef_api16up]
        if (Build.VERSION.SDK_INT >= 16) {
            //LMB:
            findListener = new FindListener() {
                @Override
                public void onFindResultReceived(int activeMatchOrdinal,
                                                 int numberOfMatches, boolean isDoneCounting) {
                    if (isDoneCounting) {
                        findIndex = activeMatchOrdinal;
                        findCount = numberOfMatches;
                        controls.pOnWebViewFindResultReceived(PasObj,activeMatchOrdinal,numberOfMatches);
                    }
                    return;
                };
            };
            setFindListener(findListener);
        } //[endif_api16up]

    }


    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
    }


    public  void SetViewParent( android.view.ViewGroup _viewgroup ) {
    	LAMWCommon.setParent(_viewgroup);
    }

    //Free object except Self, Pascal Code Free the class.
    public  void Free() {
        this.setOnLongClickListener(null);
        if (Build.VERSION.SDK_INT >= 16) {
            //[ifdef_api16up]
            this.setFindListener(null); //LMB
            //[endif_api16up]
        }
        setWebViewClient(null);
        webclient = null;
    	LAMWCommon.free();
    }

    //by jmpessoa
    public void SetLParamWidth(int _w) {
    	LAMWCommon.setLParamWidth(_w); 
    }

    public void SetLParamHeight(int _h) {
    	LAMWCommon.setLParamHeight(_h);
    }

    public void SetLGravity(int _g) {
    	LAMWCommon.setLGravity(_g);
    }

    public void SetLWeight(float _w) {
    	LAMWCommon.setLWeight(_w);
    }

    public void AddLParamsAnchorRule(int rule) {
    	LAMWCommon.addLParamsAnchorRule(rule);
    }

    public void AddLParamsParentRule(int rule) {
    	LAMWCommon.addLParamsParentRule(rule);
    }

    public void SetLayoutAll(int idAnchor) {
    	LAMWCommon.setLayoutAll(idAnchor);
    }

    public void ClearLayoutAll() {
    	LAMWCommon.clearLayoutAll();
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
    
    public boolean CanGoBack(){
    	return this.canGoBack();
    }
    
    public boolean CanGoBackOrForward(int _steps){
    	return this.canGoBackOrForward(_steps);
    }    

    public boolean CanGoForward(){
    	return this.canGoForward();
    }
    
    public void GoBack(){
        this.goBack();	
    }    

    public void	GoBackOrForward(int steps){
    	this.goBackOrForward(steps);
    }    

    public void	GoForward(){
    	this.goForward();
    }
    
    // By ADiV
    public void ClearHistory(){
    	this.clearHistory();
    }
    
    // By ADiV
    public void ClearCache( boolean _clearDiskFiles){
    	this.clearCache(_clearDiskFiles);
    }

	//LMB:

    public void FindAllAsync(String _s) {
            //[ifdef_api16up]
            if (Build.VERSION.SDK_INT >= 16) {
                this.findAllAsync(_s);
            } //[endif_api16up]
    }


	//LMB 
	public int getFindIndex() {
		return findIndex;
	}

	//LMB
	public int getFindCount() {
		return findCount;
	}

	//LMB
	public void FindNext(boolean _forward) {
		this.findNext(_forward);
	} // smartdesigner
	
	public void ClearMatches() {
		this.clearMatches();
		findCount = 0;
		findIndex = 0;
	}

	//LMB
	public void callLoadDataWithBaseURL(String s1, String s2, String s3, String s4, String s5) {  //thanks to Anton!
		loadDataWithBaseURL(s1,s2,s3,s4,s5); // experimental...
	}

    //Segator
   public void CallEvaluateJavascript(String _jscode){

        //https://stackoverflow.com/questions/8200945/how-to-get-html-content-from-a-webview
        //https://stackoverflow.com/questions/19788294/how-does-evaluatejavascript-work

       MyJSCode = _jscode;
       if (Build.VERSION.SDK_INT >= 19) {
           //[ifdef_api19up]
           this.post(new Runnable() {
               @Override
               public void run() {
                   MyWebView.evaluateJavascript(MyJSCode, new ValueCallback<String>() {
                       @Override
                       public void onReceiveValue(String s) {
                           if ("null".equals(s)) {
                               controls.pOnWebViewEvaluateJavascriptResult(PasObj, "null object");  // <<---- fire native method/event here!
                           }
                           else {
                               controls.pOnWebViewEvaluateJavascriptResult(PasObj, s);  // <<---- fire native method/event here!
                           }
                       }
                   });
               }
           });
           //[endif_api19up]
       }
       else {
           controls.pOnWebViewEvaluateJavascriptResult(PasObj, "Sorry... device Api ["+Build.VERSION.SDK_INT+"] but the requirement is Api >= 19");  // <<---- fire native method/event here!
       }

    }

    public  void setJavaScript(boolean javascript) {
        this.getSettings().setJavaScriptEnabled(javascript);
    }

    // Fatih - ZoomControl
    public  void setZoomControl(boolean zoomControl) {
        this.getSettings().setBuiltInZoomControls(zoomControl);
    }

    public void SetDomStorage(boolean _domStorage) {
        this.getSettings().setDomStorageEnabled(_domStorage);
    }

    public void SetLoadWithOverviewMode(boolean _overviewMode) {
        this.getSettings().setLoadWithOverviewMode(_overviewMode);
    }

    public void SetUseWideViewPort(boolean _wideViewport) {
        this.getSettings().setUseWideViewPort(_wideViewport);
    }

    //***
    public void SetAllowContentAccess(boolean _allowContentAccess) {
        this.getSettings().setAllowContentAccess(_allowContentAccess);
    }

    public void SetAllowFileAccess(boolean _allowFileAccess) {
        this.getSettings().setAllowFileAccess(_allowFileAccess);
    }

    public void SetAppCacheEnabled(boolean _cacheEnabled) {
        //this.getSettings().setAppCacheEnabled(_cacheEnabled);
        this.getSettings().setDatabaseEnabled(_cacheEnabled);
    }

    public void SetDisplayZoomControls(boolean _displayZoomControls) {
        this.getSettings().setDisplayZoomControls(_displayZoomControls);
    }

    public void SetGeolocationEnabled(boolean _geolocationEnabled) {
        this.getSettings().setGeolocationEnabled(_geolocationEnabled);
    }

    public void SetJavaScriptCanOpenWindowsAutomatically(boolean _javaScriptCanOpenWindows) {
        this.getSettings().setJavaScriptCanOpenWindowsAutomatically(_javaScriptCanOpenWindows);
    }

    public void SetLoadsImagesAutomatically(boolean _loadsImagesAutomatically) {
        this.getSettings().setLoadsImagesAutomatically(_loadsImagesAutomatically);
    }

    public void SetSupportMultipleWindows(boolean _supportMultipleWindows) {
        this.getSettings().setSupportMultipleWindows(_supportMultipleWindows);
    }

    public void SetAllowUniversalAccessFromFileURLs(boolean _allowUniversalAccessFromFileURLs) {
        if (Build.VERSION.SDK_INT >= 16) {
            //[ifdef_api16up]
            this.getSettings().setAllowUniversalAccessFromFileURLs(_allowUniversalAccessFromFileURLs);
            //[endif_api16up]
        }
    }

    public void SetMediaPlaybackRequiresUserGesture(boolean _mediaPlaybackRequiresUserGesture) {
        if (Build.VERSION.SDK_INT >= 17) {
            //[ifdef_api17up]
            this.getSettings().setMediaPlaybackRequiresUserGesture(_mediaPlaybackRequiresUserGesture);
            //[endif_api17up]
        }
    }

    public void SetSafeBrowsingEnabled(boolean _safeBrowsingEnabled) {
        if (Build.VERSION.SDK_INT >= 26) {
            //[ifdef_api26up]
            this.getSettings().setSafeBrowsingEnabled(_safeBrowsingEnabled);
            //[endif_api26up]
        }
    }

    public void SetSupportZoom(boolean _supportZoom) {
        this.getSettings().setSupportZoom(_supportZoom);
    }

    public void SetUserAgent(String _userAgent) {
        this.getSettings().setUserAgentString(_userAgent);
    }

    public void SetInitialScale(int _scaleInPercent) {
        this.setInitialScale(_scaleInPercent);
    }

}
