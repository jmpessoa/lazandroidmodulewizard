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
import com.google.android.gms.ads.InterstitialAd;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdCallback;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;
import com.google.android.gms.ads.rewarded.RewardItem;
import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.LoadAdError;

//-------------------------------------------------------------------------
// jsAdMob
// Developed by ADiV for LAMW on 2021-01-13
// Updated for AdMob 19.3.0
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
	
   private static final int ADMOB_BANNER   = 0;
   private static final int ADMOB_INTER    = 1;
   private static final int ADMOB_REWARDED = 2;

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   
   private int admobBannerWidth         = 0; // Control change of width
   private int admobBannerWidthAdaptive = 0; // Adaptive width
   private boolean admobBannerIsLoading = false;
   
   private Boolean    admobInit    = false;

   //--- Banner ---//
   private AdView     admobBannerView    = null;
   private AdRequest  admobBannerRequest = null;
   private String     admobBannerId      = "ca-app-pub-3940256099942544/6300978111";
   private int        admobBannerSize    = 0;  //LMB initialize banner size to SMART_BANNER (0)
   private Boolean    admobBannerStop    = false;
   private AdSize     admobBannerAdSize  = null;
   
   //--- Interstitial ---//
   private InterstitialAd admobInter   = null;
   private String         admobInterId = "ca-app-pub-3940256099942544/1033173712";
   private Boolean		  admobInterAutoLoadOnClose = true;
   
   //--- Reward ---//
   private RewardedAd     admobRewarded   = null;
   private String         admobRewardedId = "ca-app-pub-3940256099942544/5224354917";


   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsAdMob(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      admobInit = false;
      admobBannerView = null;
      
      admobBannerIsLoading = false;

      LAMWCommon = new jCommons(this,context,pascalObj);      
   } //end constructor

   public void jFree() {
      //free local objects...
         admobBannerRequest = null;
         admobBannerView    = null;

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

   public void AdMobBannerSetId( String _admobid ) {
	   admobBannerId = _admobid;      
   }
   
   //LMB Call this BEFORE AdMobRun to set banner size
   public void AdMobBannerSetSize( int _bannerSize ) {
	   admobBannerSize = _bannerSize;
   }

   //LMB
   public int AdMobBannerGetSize(){
      return admobBannerSize;
   }
   
   public int AdMobBannerGetHeight() {
	    if (admobBannerView == null) return 0;	    	   

	   switch (admobBannerSize) {		 
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
			  if(admobBannerAdSize == null) return 0;
			  return admobBannerAdSize.getHeightInPixels(context);
			 
		 default: // screen width x 32|50|90	Smart Banner	Phones and Tablets	SMART_BANNER
			return AdSize.SMART_BANNER.getHeightInPixels(context);			
		}
	}
   
   public void AdMobInit(){	  	   
	   
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
	   admobBannerView    = null;
	   admobBannerRequest = null;
   }
   
   //--- BANNER ---//
   
   public void AdMobBannerUpdate(){
	   if( admobBannerIsLoading ) return;
	   
	   if( (admobBannerView != null) && (admobBannerWidth == this.getWidth()) ) return;
	   
	   AdMobBannerStop();
	   
	   if( !admobBannerIsLoading && !admobBannerStop )
	    AdMobBannerRun();
   }
   
   public void AdMobBannerStop(){
	   
	   if (admobBannerIsLoading) admobBannerStop = true;
	   
	   if (admobBannerView == null) return;	        
	   
	   this.removeView(admobBannerView);
	   
	   admobBannerView  = null;
	   admobBannerWidth = 0;
	   
	   admobBannerStop = false;
	   admobBannerIsLoading = false;
   }
   
   public boolean AdMobBannerIsLoading(){
	   return admobBannerIsLoading;
   }
 
   public void AdMobBannerRun(){
        
	    if( (admobBannerView != null) || admobBannerIsLoading ) return;
	    
	    admobBannerIsLoading = true;

        RelativeLayout.LayoutParams bannerLParams = (RelativeLayout.LayoutParams)this.getLayoutParams();

        admobBannerView = new AdView(controls.activity);
        
        if( admobBannerView == null ){
        	admobBannerIsLoading = false;
        	return;
        }
        
        AdListener admobListener = new AdListener() {
	        	
	            /*private void showToast(String message) {            	
	                Toast.makeText(controls.activity, message, Toast.LENGTH_SHORT).show();
	            }*/
        	        		          
	            
	            @Override
	            public void onAdLoaded() {
	            	            	
	                //showToast("Ad loaded.");
	                if (admobBannerView.getVisibility() == View.GONE) {                	
	                	admobBannerView.setVisibility(View.VISIBLE);                	
	                }
	                
	                controls.pOnAdMobLoaded(pascalObj, ADMOB_BANNER);
	                
	                admobBannerIsLoading = false;
	                
	                if (admobBannerStop)
	                	AdMobBannerStop();
	            }

	            @Override
	            public void onAdFailedToLoad(int errorCode) {
	            	                      
	            	controls.pOnAdMobFailedToLoad(pascalObj, ADMOB_BANNER, errorCode);
	                /*showToast(String.format("Ad failed to load with error code %d.", errorCode));
	                
	                switch(errorCode){
	                 	case AdRequest.ERROR_CODE_INTERNAL_ERROR: showToast("INTERNAL ERROR"); break; 
	                 	case AdRequest.ERROR_CODE_INVALID_REQUEST: showToast("INVALID REQUEST"); break;
	                 	case AdRequest.ERROR_CODE_NETWORK_ERROR: showToast("NETWORK ERROR"); break;
	                 	case AdRequest.ERROR_CODE_NO_FILL: showToast("NO FILL"); break;
	                }*/
	            	
	            	admobBannerIsLoading = false;
	                
	                if (admobBannerStop)
	                	AdMobBannerStop();
	            }
	            @Override
	            public void onAdOpened() {
	            	// Click in Ads
	                //showToast("Ad opened.");
	            	controls.pOnAdMobOpened(pascalObj, ADMOB_BANNER);
	            }
	            
	            @Override
	            public void onAdClicked() {
	                // Code to be executed when the user clicks on an ad.
	            	controls.pOnAdMobClicked(pascalObj, ADMOB_BANNER);
	            }


	            @Override
	            public void onAdClosed() {
	            	// Return to Ads
	                //showToast("Ad closed.");
	            	controls.pOnAdMobClosed(pascalObj, ADMOB_BANNER);
	            }

	            @Override
	            public void onAdLeftApplication() {
	            	// After click in Ads
	                //showToast("Ad left application.");
	            	controls.pOnAdMobLeftApplication(pascalObj, ADMOB_BANNER);
	            }
	        };
        
        if( (admobListener == null) || (bannerLParams == null) ){
        	admobBannerView  = null;
        	admobBannerIsLoading = false;
        	return;
        }
        
        admobBannerView.setAdListener(admobListener);

        admobBannerView.setLayoutParams(bannerLParams);
                
        switch (admobBannerSize) {		 
         case 1: // 320x50	Banner	Phones and Tablets	BANNER
        	  admobBannerView.setAdSize(AdSize.BANNER);
			  break;
		 case 2: // 320x100	Large Banner	Phones and Tablets	LARGE_BANNER
			  admobBannerView.setAdSize(AdSize.LARGE_BANNER);
			  break;
		 case 3: // 300x250	IAB Medium Rectangle	Phones and Tablets	MEDIUM_RECTANGLE
			  admobBannerView.setAdSize(AdSize.MEDIUM_RECTANGLE);
			  break;		 
		 case 4: // 468x60	IAB Full-Size Banner	Tablets	FULL_BANNER
			  admobBannerView.setAdSize(AdSize.FULL_BANNER);
			  break;		 
		 case 5: // 728x90	IAB Leaderboard	Tablets	LEADERBOARD
			  admobBannerView.setAdSize(AdSize.LEADERBOARD);
			  break;
		 case 6:
			    admobBannerAdSize = getBannerAdSize();		        
			    admobBannerView.setAdSize(admobBannerAdSize); 
			 break;
		 default: // screen width x 32|50|90	Smart Banner	Phones and Tablets	SMART_BANNER
			  admobBannerView.setAdSize(AdSize.SMART_BANNER);			
		}
        
        
        admobBannerView.setAdUnitId(admobBannerId);

        this.addView(admobBannerView);

        if( admobBannerRequest == null )
         admobBannerRequest = new AdRequest.Builder().build();

        // Start loading the ad in the background.
        admobBannerView.loadAd(admobBannerRequest);
        
        admobBannerWidth = this.getWidth();
   }
   
   private AdSize getBannerAdSize() {
	   
	   // Step 2 - Determine the screen width (less decorations) to use for the ad width.
       Display display = controls.activity.getWindowManager().getDefaultDisplay();
       DisplayMetrics outMetrics = new DisplayMetrics();
       display.getMetrics(outMetrics);

       float widthPixels = outMetrics.widthPixels;
       float density = outMetrics.density;
       
       int adWidth = 0;
	   
	   if( admobBannerWidthAdaptive == 0 )        
           adWidth = (int) (widthPixels / density);
       else
    	   adWidth = (int) (admobBannerWidthAdaptive / density);
	   
       // Step 3 - Get adaptive ad size and return for setting on the ad view.
       return AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(controls.activity, adWidth);
   }
   
   public void AdMobBannerSetAdativeWidth( int _aWidth ){
	   admobBannerWidthAdaptive = _aWidth;
   }
   
   //--- Interstitial ---//
   public void AdMobInterSetAutoLoadOnClose( boolean _admobInterAutoLoadOnClose ){
	   admobInterAutoLoadOnClose = _admobInterAutoLoadOnClose;
   }
   
   public void AdMobInterCreateAndLoad(){
		if(admobInter != null) return;
		
		admobInter = new InterstitialAd(controls.activity);
		admobInter.setAdUnitId(admobInterId);
		admobInter.loadAd(new AdRequest.Builder().build());

		admobInter.setAdListener(new AdListener() {	       
			
			@Override
	        public void onAdLoaded() {
	            // Code to be executed when an ad finishes loading.
				controls.pOnAdMobLoaded(pascalObj, ADMOB_INTER);
	        }

	        @Override
	        public void onAdFailedToLoad(int errorCode) {
	            // Code to be executed when an ad request fails.
	        	controls.pOnAdMobFailedToLoad(pascalObj, ADMOB_INTER, errorCode);
	        }

	        @Override
	        public void onAdOpened() {
	            // Code to be executed when the ad is displayed.
	        	controls.pOnAdMobOpened(pascalObj, ADMOB_INTER);
	        }

	        @Override
	        public void onAdClicked() {
	            // Code to be executed when the user clicks on an ad.
	        	controls.pOnAdMobClicked(pascalObj, ADMOB_INTER);
	        }

	        @Override
	        public void onAdLeftApplication() {
	            // Code to be executed when the user has left the app.
	        	controls.pOnAdMobLeftApplication(pascalObj, ADMOB_INTER);
	        }

	        @Override
	        public void onAdClosed() {
	        	controls.pOnAdMobClosed(pascalObj, ADMOB_INTER);
	        	
	            // Code to be executed when the interstitial ad is closed.
	        	if(admobInterAutoLoadOnClose)
	        	 admobInter.loadAd(new AdRequest.Builder().build());
	        }
	

	    });
   }
   
   public void AdMobInterSetId( String _admobid ) {
	   admobInterId = _admobid;      
   }      
   
   public void AdMobInterLoad(){
	   if(admobInter == null) return;
	   
	   admobInter.loadAd(new AdRequest.Builder().build());
   }
   
   public boolean AdMobInterIsLoaded(){
	   if(admobInter == null) return false;
	   
	   return admobInter.isLoaded();
   }
   
   public void AdMobInterShow(){
	   if(admobInter == null) return;
	   
	   admobInter.show();
   }
   
   //--- Rewarded ---//
   
   private RewardedAd createAndLoadRewardedAd() {
       RewardedAd rewardedAd = new RewardedAd(controls.activity, admobRewardedId);
       
       RewardedAdLoadCallback adLoadCallback = new RewardedAdLoadCallback() {
           @Override
           public void onRewardedAdLoaded() {
               // Ad successfully loaded.
        	   controls.pOnAdMobLoaded(pascalObj, ADMOB_REWARDED);
           }

           @Override
           public void onRewardedAdFailedToLoad(LoadAdError errorCode) {
           //public void onRewardedAdFailedToLoad(int errorCode) {
               // Ad failed to load.
        	   controls.pOnAdMobFailedToLoad(pascalObj, ADMOB_REWARDED, errorCode.getCode());
           }
       };
       rewardedAd.loadAd(new AdRequest.Builder().build(), adLoadCallback);
       return rewardedAd;
   }
   
   public void AdMobRewardedSetId( String _admobid ) {
	   admobRewardedId = _admobid;      
   }
   
   public void AdMobRewardedCreateAndLoad(){
	   admobRewarded = createAndLoadRewardedAd();
   }
   
   public void AdMobRewardedLoad(){
	   admobRewarded = createAndLoadRewardedAd();
   }
   
   public boolean AdMobRewardedIsLoaded(){
       if( admobRewarded == null ) return false;
	   
	   return admobRewarded.isLoaded();
   }
   
   public int AdMobRewardedGetAmount(){
	   if( admobRewarded == null ) return 0;
	   
	   if (admobRewarded.isLoaded())
		   return admobRewarded.getRewardItem().getAmount();
	   else
		   return 0;
   }
   
   public String AdMobRewardedGetType(){
	   if( admobRewarded == null ) return "";
	   
	   if (admobRewarded.isLoaded())
		   return admobRewarded.getRewardItem().getType();
	   else
		   return "";
   }
   
   public void AdMobRewardedShow(){
	   if( admobRewarded == null ) return;
	   
	   if( !(admobRewarded.isLoaded()) ) return;
	   
	   RewardedAdCallback adCallback = new RewardedAdCallback() {    	  
               @Override
               public void onRewardedAdOpened() {            	   
                   // Ad opened.
            	   controls.pOnAdMobOpened(pascalObj, ADMOB_REWARDED);
               }

               @Override
               public void onRewardedAdClosed() {            	   
                   // Ad closed.
            	   controls.pOnAdMobClosed(pascalObj, ADMOB_REWARDED);
               }

               @Override
               public void onUserEarnedReward(RewardItem _reward) {
                   // User earned reward.
            	  if(_reward == null) return;
            	  controls.pOnAdMobRewardedUserEarned(pascalObj);
               }

               @Override
               public void onRewardedAdFailedToShow(AdError errorCode) {            	   
                   // Ad failed to display.
            	   controls.pOnAdMobRewardedFailedToShow(pascalObj, errorCode.getCode());
               }
       };
           
       admobRewarded.show(controls.activity, adCallback);       
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
