package org.lamw.appadmoddemo1;

import android.os.AsyncTask;
import android.content.Context;
import android.util.Log;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.Display;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;

//-------------------------------------------------------------------------
// jsAdMob
// Developed by ADiV for LAMW on 2020-09-30
// Updated for AdMob 17.2.1
//-------------------------------------------------------------------------

/* Banner sizes:
  https://developers.google.com/admob/android/banner#banner_sizes
  Size in dp (WxH)	Description	Availability	AdSize constant
   320x50	Banner	Phones and Tablets	BANNER
   320x100	Large Banner	Phones and Tablets	LARGE_BANNER
   300x250	IAB Medium Rectangle	Phones and Tablets	MEDIUM_RECTANGLE
   468x60	IAB Full-Size Banner	Tablets	FULL_BANNER
   728x90	IAB Leaderboard	Tablets	LEADERBOARD
   screen width x 32|50|90	Smart Banner	Phones and Tablets	SMART_BANNER
   To set banner size, use the above banner W and H:
   0 (default) = SMART_BANNER
   32050 (or 320050) = BANNER
   320100 = LARGE_BANNER
   etc.
*/

public class jsAdMob extends FrameLayout { 

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   
   private int admobWidth         = 0; // Control change of width
   private int admobWidthAdaptive = 0; // Adaptive width
   private boolean mIsLoading = false;

   private AdView     admobView    = null;
   private AdRequest  admobRequest = null;
   private Boolean    admobInit    = false;
   private String     admobId      = "ca-app-pub-3940256099942544/6300978111";
   private int        admobBannerSize = 0;  //LMB initialize banner size to SMART_BANNER (0)
   private Boolean    admobBStop      = false;
   private AdSize     admobAdSize  = null;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsAdMob(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      admobInit = false;
      admobView = null;
      
      mIsLoading = false;

      LAMWCommon = new jCommons(this,context,pascalObj);      
   } //end constructor

   public void jFree() {
      //free local objects...
         admobRequest = null;
         admobView    = null;

	 LAMWCommon.free();
   }
 
   public void SetViewParent(ViewGroup _viewgroup) {
	 LAMWCommon.setParent(_viewgroup);
   }

   public ViewGroup GetParent() {
      return LAMWCommon.getParent();
   }

   public void RemoveFromViewParent() {
  	 LAMWCommon.removeFromViewParent();
   }

   public void AdMobSetId( String _admobid ) {
      admobId = _admobid;      
   }

   public String AdMobGetId(){
      return admobId;
   }
   
   //LMB Call this BEFORE AdMobRun to set banner size
   public void AdMobSetBannerSize( int _bannerSize ) {
	   admobBannerSize = _bannerSize;
   }

   //LMB
   public int AdMobGetBannerSize(){
      return admobBannerSize;
   }
   
   public int AdMobGetHeight() {
	    if (admobView == null) return 0;
	    
	    // Step 2 - Determine the screen width (less decorations) to use for the ad width.
	       Display display = controls.activity.getWindowManager().getDefaultDisplay();
	       DisplayMetrics outMetrics = new DisplayMetrics();
	       display.getMetrics(outMetrics);

	       float widthPixels = outMetrics.widthPixels;
	       float density = outMetrics.density;
	       
	       if( admobWidthAdaptive == 0 )        
	           return (int) (widthPixels / density);
	       else
	    	   return (int) (admobWidthAdaptive / density);

	   /* switch (admobBannerSize) {		 
        case 1: // 320x50	Banner	Phones and Tablets	BANNER
		 	  return AdSize.BANNER.getHeightInPixels(context);
			 
		 case 2: // 320x100	Large Banner	Phones and Tablets	LARGE_BANNER
			  return AdSize.LARGE_BANNER.getHeightInPixels(context);
			  
		 case 3: // 300x250	IAB Medium Rectangle	Phones and Tablets	MEDIUM_RECTANGLE
			  return AdSize.MEDIUM_RECTANGLE.getHeightInPixels(context);
			  		 
		 case 4: // 468x60	IAB Full-Size Banner	Tablets	FULL_BANNER
			  return AdSize.FULL_BANNER.getHeightInPixels(context);
			  		 
		 case 5: // 728x90	IAB Leaderboard	Tablets	LEADERBOARD
			  return AdSize.LEADERBOARD.getHeightInPixels(context);
			  
		 case 6: // Adaptive size
			  if(admobAdSize == null) return 0;
			  return admobAdSize.getHeightInPixels(context);
			 
		 default: // screen width x 32|50|90	Smart Banner	Phones and Tablets	SMART_BANNER
			return AdSize.SMART_BANNER.getHeightInPixels(context);			
		}*/
	}
   
   public void AdMobInit(){
	  
	   /*if( !admobInit ) { 
	    MobileAds.initialize(controls.activity);
	    admobInit = true;
	   }*/
	   
	   if( admobInit ) return; 
	   
	   // Initialize the Mobile Ads SDK.
       MobileAds.initialize(controls.activity, 
    	   new OnInitializationCompleteListener() {    	           
           @Override
           public void onInitializationComplete(InitializationStatus initializationStatus) {
        	   controls.pOnAdMobInitializationComplete(pascalObj);
           }
       });
   }
   
   public void AdMobFree(){
	   admobView    = null;
	   admobRequest = null;
   }
   
   public void AdMobUpdate(){
	   if( mIsLoading ) return;
	   
	   if( (admobView != null) && (admobWidth == this.getWidth()) ) return;
	   
	   AdMobStop();
	   
	   if( !mIsLoading && !admobBStop )
	    AdMobRun();
   }
   
   public void AdMobStop(){
	   
	   if (mIsLoading) admobBStop = true;
	   
	   if (admobView == null) return;	        
	   
	   this.removeView(admobView);
	   
	   admobView  = null;
	   admobWidth = 0;
	   
	   admobBStop = false;
	   mIsLoading = false;
   }
   
   public boolean AdMobIsLoading(){
	   return mIsLoading;
   }
  

   public void AdMobRun(){
        
	    if( (admobView != null) || mIsLoading ) return;
	    
	    mIsLoading = true;

        RelativeLayout.LayoutParams bannerLParams = (RelativeLayout.LayoutParams)this.getLayoutParams();

        admobView = new AdView(controls.activity);
        
        if( admobView == null ){
        	mIsLoading = false;
        	return;
        }
        
        AdListener admobListener = new AdListener() {
	        	
	            /*private void showToast(String message) {            	
	                Toast.makeText(controls.activity, message, Toast.LENGTH_SHORT).show();
	            }*/
        	        		          
	            
	            @Override
	            public void onAdLoaded() {
	            	            	
	                //showToast("Ad loaded.");
	                if (admobView.getVisibility() == View.GONE) {                	
	                	admobView.setVisibility(View.VISIBLE);                	
	                }
	                
	                controls.pOnAdMobLoaded(pascalObj);
	                
	                mIsLoading = false;
	                
	                if (admobBStop)
	                	AdMobStop();
	            }

	            @Override
	            public void onAdFailedToLoad(int errorCode) {
	            	                      
	            	controls.pOnAdMobFailedToLoad(pascalObj, errorCode);
	                /*showToast(String.format("Ad failed to load with error code %d.", errorCode));
	                
	                switch(errorCode){
	                 	case AdRequest.ERROR_CODE_INTERNAL_ERROR: showToast("INTERNAL ERROR"); break; 
	                 	case AdRequest.ERROR_CODE_INVALID_REQUEST: showToast("INVALID REQUEST"); break;
	                 	case AdRequest.ERROR_CODE_NETWORK_ERROR: showToast("NETWORK ERROR"); break;
	                 	case AdRequest.ERROR_CODE_NO_FILL: showToast("NO FILL"); break;
	                }*/
	            	
	            	mIsLoading = false;
	                
	                if (admobBStop)
	                	AdMobStop();
	            }
	            @Override
	            public void onAdOpened() {
	            	// Click in Ads
	                //showToast("Ad opened.");
	            	controls.pOnAdMobOpened(pascalObj);
	            }
	            
	            @Override
	            public void onAdClicked() {
	                // Code to be executed when the user clicks on an ad.
	            	controls.pOnAdMobClicked(pascalObj);
	            }


	            @Override
	            public void onAdClosed() {
	            	// Return to Ads
	                //showToast("Ad closed.");
	            	controls.pOnAdMobClosed(pascalObj);
	            }

	            @Override
	            public void onAdLeftApplication() {
	            	// After click in Ads
	                //showToast("Ad left application.");
	            	controls.pOnAdMobLeftApplication(pascalObj);
	            }
	        };
        
        if( (admobListener == null) || (bannerLParams == null) ){
        	admobView  = null;
        	mIsLoading = false;
        	return;
        }
        
        admobView.setAdListener(admobListener);

        admobView.setLayoutParams(bannerLParams);
                
        switch (admobBannerSize) {		 
         case 1: // 320x50	Banner	Phones and Tablets	BANNER
		 	  admobView.setAdSize(AdSize.BANNER);
			  break;
		 case 2: // 320x100	Large Banner	Phones and Tablets	LARGE_BANNER
			   admobView.setAdSize(AdSize.LARGE_BANNER);
			  break;
		 case 3: // 300x250	IAB Medium Rectangle	Phones and Tablets	MEDIUM_RECTANGLE
			   admobView.setAdSize(AdSize.MEDIUM_RECTANGLE);
			  break;		 
		 case 4: // 468x60	IAB Full-Size Banner	Tablets	FULL_BANNER
			   admobView.setAdSize(AdSize.FULL_BANNER);
			  break;		 
		 case 5: // 728x90	IAB Leaderboard	Tablets	LEADERBOARD
			   admobView.setAdSize(AdSize.LEADERBOARD);
			  break;
		 case 6:
			    admobAdSize = getAdSize();		        
				admobView.setAdSize(admobAdSize); 
			 break;
		 default: // screen width x 32|50|90	Smart Banner	Phones and Tablets	SMART_BANNER
			  admobView.setAdSize(AdSize.SMART_BANNER);			
		}
        
        
        admobView.setAdUnitId(admobId);

        this.addView(admobView);

        if( admobRequest == null )
         admobRequest = new AdRequest.Builder().build();

        // Start loading the ad in the background.
        admobView.loadAd(admobRequest);
        
        admobWidth = this.getWidth();
   }
   
   private AdSize getAdSize() {
	   
	   // Step 2 - Determine the screen width (less decorations) to use for the ad width.
       Display display = controls.activity.getWindowManager().getDefaultDisplay();
       DisplayMetrics outMetrics = new DisplayMetrics();
       display.getMetrics(outMetrics);

       float widthPixels = outMetrics.widthPixels;
       float density = outMetrics.density;
       
       int adWidth = 0;
	   
	   if( admobWidthAdaptive == 0 )        
           adWidth = (int) (widthPixels / density);
       else
    	   adWidth = (int) (admobWidthAdaptive / density);
	   
       // Step 3 - Get adaptive ad size and return for setting on the ad view.
       return AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(controls.activity, adWidth);
   }
   
   public void SetAdativeWidth( int _aWidth ){
	   admobWidthAdaptive = _aWidth;
   }


   public View GetView() {
      return this;
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
      LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
   }

   public void AddLParamsAnchorRule(int _rule) {
	 LAMWCommon.addLParamsAnchorRule(_rule);
   }

   public void AddLParamsParentRule(int _rule) {
	 LAMWCommon.addLParamsParentRule(_rule);
   }

   public void SetLayoutAll(int _idAnchor) {
  	 LAMWCommon.setLayoutAll(_idAnchor);
   }

   public void ClearLayoutAll() {
	 LAMWCommon.clearLayoutAll();
   }

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...   

}
