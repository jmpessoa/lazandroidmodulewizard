package org.lamw.appadmoddemo1;


import android.content.Context;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdListener;

/*Draft java code by "Lazarus Android Module Wizard" [12/13/2017 17:18:12]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/

// by TR3E
public class jsAdMob extends FrameLayout /*dummy*/ { //please, fix what GUI object will be extended!

   private long pascalObj = 0;        // Pascal Object
   private Controls controls  = null; //Java/Pascal [events] Interface ...
   private jCommons LAMWCommon;
   private Context context = null;

   private OnClickListener onClickListener;   // click event
   private Boolean enabled  = true;           // click-touch enabled!
   
   private int admobWidth = 0; // Control change of width

   private AdView    admobView    = null;
   private AdRequest admobRequest = null;
   private Boolean   admobInit    = false;
   private String    admobId      = "ca-app-pub-3940256099942544/6300978111";

   //private String banner_id = "ca-app-pub-3940256099942544/6300978111";


   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
   public jsAdMob(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

      super(_ctrls.activity);
      context   = _ctrls.activity;
      pascalObj = _Self;
      controls  = _ctrls;

      admobInit = false;
      admobView = null;

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

   public void AdMobInit(){	  
       
    if( !admobInit ) {
       MobileAds.initialize(controls.activity, admobId);
       admobInit = true;
    }
    
   }
   
   public void AdMobFree(){
	   admobView    = null;
	   admobRequest = null;
   }
   
   public void AdMobUpdate(){
	   if( (admobView == null) || (admobWidth == this.getWidth()) ) return;
	   
	   AdMobStop();	   	     
	   AdMobRun();
	   
	   admobWidth = this.getWidth();
   }
   
   public void AdMobStop(){
       if(admobView == null) return;
	   
	   this.removeView(admobView);
	   admobView.destroy();
	   admobView = null;
   }

   public void AdMobRun(){
        
	    if( admobView != null ) return;              

        RelativeLayout.LayoutParams bannerLParams = (RelativeLayout.LayoutParams)this.getLayoutParams();

        admobView = new AdView(controls.activity);
        
        if( admobView == null ) return;
        
        admobView.setAdListener(new AdListener() {
        	
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
            }
            @Override
            public void onAdOpened() {
            	// Click in Ads
                //showToast("Ad opened.");
            	controls.pOnAdMobOpened(pascalObj);
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
        });

        admobView.setLayoutParams(bannerLParams);
        admobView.setAdSize(AdSize.SMART_BANNER);
        admobView.setAdUnitId(admobId);

        this.addView(admobView);

        //admobRequest = new AdRequest.Builder().addTestDevice(AdRequest.DEVICE_ID_EMULATOR).build();
        admobRequest = new AdRequest.Builder().build();

        // Start loading the ad in the background.
        admobView.loadAd(admobRequest);
        
        admobWidth = this.getWidth();
   }

   public View GetView() {
      return this;
   }

   public void SetLParamWidth(int _w) {
  	 LAMWCommon.setLParamWidth(_w);
   }

   public void SetLParamHeight(int _h) {
  	 LAMWCommon.setLParamHeight(_h);
   }

   public int GetLParamWidth() {
      return LAMWCommon.getLParamWidth();
   }

   public int GetLParamHeight() {
	 return  LAMWCommon.getLParamHeight();
   }

   public void SetLGravity(int _g) {
  	 LAMWCommon.setLGravity(_g);
   }

   public void SetLWeight(float _w) {
  	 LAMWCommon.setLWeight(_w);
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
