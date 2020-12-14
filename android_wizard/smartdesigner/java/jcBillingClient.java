import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.android.billingclient.api.AcknowledgePurchaseParams;
import com.android.billingclient.api.AcknowledgePurchaseResponseListener;
import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingClient.BillingResponseCode;
import com.android.billingclient.api.BillingClient.FeatureType;
import com.android.billingclient.api.BillingClient.SkuType;
import com.android.billingclient.api.BillingClientStateListener;
import com.android.billingclient.api.BillingFlowParams;
import com.android.billingclient.api.BillingResult; 
import com.android.billingclient.api.ConsumeParams;
import com.android.billingclient.api.ConsumeResponseListener;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.Purchase.PurchasesResult;
import com.android.billingclient.api.Purchase.PurchaseState;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.android.billingclient.api.SkuDetails;
import com.android.billingclient.api.SkuDetailsParams;
import com.android.billingclient.api.SkuDetailsResponseListener;
import org.json.JSONException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set; 
import java.util.Arrays;

// Billing Library version 3.0.1
// https://developer.android.com/google/play/billing/billing_library_overview

// https://medium.com/exploring-android/exploring-the-play-billing-library-for-android-55321f282929
// https://developer.android.com/reference/com/android/billingclient/api/Purchase?hl=en

// BillingResultCode values:
//   OK — Returned when the current request is successful
//   BILLING_UNAVAILABLE — Returned when the version for the Billing API is not supported for the requested type
//   DEVELOPER_ERROR — Returned when incorrect arguments have been sent to the Billing API
//   ERROR — General error response returned when an error occurs during the API action being executed
//   FEATURE_NOT_SUPPORTED — Returned when the requested action is not supported by play services on the current device
//   ITEM_ALREADY_OWNED — Returned when the user attempts to purchases an item that they already own
//   ITEM_NOT_OWNED — Returned when the user attempts to consume an item that they do not currently own
//   ITEM_UNAVAILABLE — Returned when the user attempts to purchases a product that is not available for purchase
//   SERVICE_DISCONNECTED — Returned when the play service is not connected at the point of the request
//   SERVICE_UNAVAILABLE — Returned when an error occurs in relation to the devices network connectivity
//   USER_CANCELED — Returned when the user cancels the request that is currently taking place

// Sample code:
// https://github.com/android/play-billing-samples/blob/master/TrivialDrive_v2/shared-module/src/main/java/com/example/billingmodule/billing/BillingManager.java

public class jcBillingClient implements PurchasesUpdatedListener {

    // prefix for debug logs (search for this string in logcat)
    private static final String TAG = "jBillingClient.Log";

    private static final int ERROR_KEY_MISSING   = 21;
    private static final int ERROR_SKU_NOT_FOUND = 22;

    // LAMW stuff

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    // Billing stuff, copied from google's sample code:

    private BillingClient mBillingClient = null;
    private List<Purchase> mPurchases = new ArrayList<>();
    private List<SkuDetails> mSkuDetails = new ArrayList<>();

    private boolean mIsServiceConnected = false;
    private Set<String> mTokensToBeConsumed;

    // this should be YOUR APPLICATION'S PUBLIC KEY
    // Not your developer public key, but *app-specific* public key.
    // Supplied by jBillingClient.Update(Key)
    private String BASE_64_ENCODED_PUBLIC_KEY = "";


    public jcBillingClient(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        controls  = _ctrls;
        pascalObj = _Self;
        context   = _ctrls.activity;
        mBillingClient = BillingClient.newBuilder(context)
          .enablePendingPurchases()
          .setListener(this).build();
        dbg("create");
    }

    public void jFree() {
        if (mBillingClient != null && mBillingClient.isReady()) {
            mBillingClient.endConnection();
            mBillingClient = null;
        }
    }

    // goes to: jBillingClient.GetStatus()
    public String GetStatus() {
        String s = "[Status]";
        if (mBillingClient != null) {
            s += "[BC]";
            if (mBillingClient.isReady()) {
                s += "[BC.isReady]";
            }
        }
        s += "[Key="+BASE_64_ENCODED_PUBLIC_KEY+"]";
        return s;
    }

    private void dbg(String _s) {
      Log.w(TAG, "BC-DEBUG " + _s);
    }

    public void Connect(String _key) {
        if (_key != "") {
            BASE_64_ENCODED_PUBLIC_KEY = _key;
            dbg("K+");
        };
        if (_key == "") {
            dbg("K-");
            CallbackError("connect", ERROR_KEY_MISSING, "app key missing");
            return;
        };
        if (mIsServiceConnected) {
            dbg("Conn.Already");
            Callback("connect", "already_connected", "");
            return; // already connected
        };
                
        startServiceConnection(new Runnable() {
            @Override
            public void run() {
                dbg("Conn.OK");
                CallbackOK("connect");
            };
        });
    }

    // procedure jBillingClient.QueryInappList(SKUS: string);
    public void QueryInappList(String _skus) {
        CallbackLog("InappList for " + _skus);
        querySkuDetailsAsync(SkuType.INAPP, _skus);
    }

    // procedure jBillingClient.QuerySubsList(SKUS: string);
    public void QuerySubsList(String _skus) {
        querySkuDetailsAsync(SkuType.SUBS, _skus);
    }

    // goes to: jBillingClient.GetEvent_OnBillingClientEvent(xml)
    private void Callback(String _op, String _result, String _xml) {
        String xml = "<billing><op>" + _op + "</op><result>" + _result + "</result>" + _xml + "</billing>";
        controls.pOnBillingClientEvent(pascalObj, xml);
    }

    // Convenient way of reporting success to jBillingClient via callback
    private void CallbackOK(String _op) {
        Callback(_op, "ok", "");
    }

    // Convenient way of triggering ShowMessage in app
    private void ShowMessage(String _msg) {
        Callback("ShowMessage", "ok", "<msg>" + _msg + "</msg>");
    }

    // Convenient way of reporting errors to jBillingClient via callback
    private void CallbackError(String _op, int code, String _msg) {
        Callback(_op, "error", "<error>" + Integer.toString(code) +
          "</error><msg>" + _msg + "</msg>");
    }

    // Convenient way of reporting miscellaneous log events to jBillingClient via callback
    private void CallbackLog(String _log) {
        Callback("log", "ok", "<msg>" + _log + "</msg>");
    }

    // Convenient way of sending parameters to jBillingClient via callback
    private void CallbackInfo(String _res, String _msg) {
        Callback("info", _res, "<msg>" + _msg + "</msg>");
    }

    // jBillingClient.Buy(SKU: string)
    public void Buy(String sku) {
        initiatePurchaseFlow(sku, "", BillingClient.SkuType.INAPP);
    }

    // jBillingClient.Sub(SKU, oldSKUs: string)  SKU = SKU + "/" + oldSKUs;
    public void Sub(String sku, String oldSku) {
        initiatePurchaseFlow(sku, oldSku, BillingClient.SkuType.SUBS);
    }

    // Verifies that the purchase was signed correctly for this developer's public key.
    // Note: It's strongly recommended to perform such check on your backend since hackers can
    // replace this method with "constant true" if they decompile/rebuild your app.
    // Good info:
    //    https://stackoverflow.com/questions/33850864/how-to-verify-purchase-for-android-app-in-server-side-google-play-in-app-billin
    //    https://stackoverflow.com/questions/35127086/android-inapp-purchase-receipt-validation-google-play
    private boolean verifyValidSignature(String signedData, String signature) {
        // for now, accept everything
        return (BASE_64_ENCODED_PUBLIC_KEY != "");
        // Some sanity checks to see if the developer (that's you!) really followed the
        // instructions to run this sample (don't put these checks on your app!)
        //if (BASE_64_ENCODED_PUBLIC_KEY.contains("CONSTRUCT_YOUR")) {
        //    throw new RuntimeException("Please update your app's public key at: "
        //            + "BASE_64_ENCODED_PUBLIC_KEY");
        //}
        /*
        try {
            return Security.verifyPurchase(BASE_64_ENCODED_PUBLIC_KEY, signedData, signature);
        } catch (IOException e) {
            if (logs >= LOG_E) {
                Log.e(TAG, "Got an exception trying to validate a purchase: " + e);
            };
            CallbackError("verify", "exception");
            return false;
        }
        */
    }

    // jBillingClient.Acknowledge(PurchaseToke, DeveloperPayload: string);
    public void Acknowledge(final String token, final String payload) {

        AcknowledgePurchaseResponseListener listener =
                new AcknowledgePurchaseResponseListener () {
            @Override
            public void onAcknowledgePurchaseResponse (BillingResult billingResult) {
                int code = billingResult.getResponseCode();
                if (code == BillingResponseCode.OK) {
                    Callback("acknowledge", "ok", // notify successful ack
                    "<token>" + token + "</token>" +
                    "<payload>" + payload + "</payload>");
                    // not really necessary to return token and payload, the client
                    // should already know it, but it's easy and convenient, so we do it...
                } else {
                    CallbackError("acknowledge", code, billingResult.getDebugMessage());
                }
            }
        };

        AcknowledgePurchaseParams params =
            AcknowledgePurchaseParams.newBuilder()
                .setPurchaseToken(token)
                //.setDeveloperPayload(payload)
                .build();
        mBillingClient.acknowledgePurchase(params, listener);
    }

    // check purchase validity, add to list, acknowledge
    private void handlePurchase(Purchase purchase) {
        if (!verifyValidSignature(purchase.getOriginalJson(), purchase.getSignature())) {
            CallbackInfo("verify", "Bad signature");
            return;
        }
        mPurchases.add(purchase);
    }

    private void listPurchases(List<Purchase> purchases) {
        for (Purchase purchase : purchases) {
            handlePurchase(purchase);
        }
        // prepare XML string with details of all purchases
        String xml = "";
        int count = 0;
        for (Purchase purchase : mPurchases) {
            count += 1;
            xml += "<sku" + Integer.toString(count) + ">";
            xml += purchase.getOriginalJson();
            xml += "</sku" + Integer.toString(count) + ">";
        }
        xml = "<count>" + Integer.toString(count) + "</count>" + xml;
        // send list via Callback
        Callback("list_purchase", "ok", xml);
    }

    // This should happen at the end of purchase flow
    @Override
    public void onPurchasesUpdated(BillingResult billingResult, List<Purchase> purchases) {
        int resultCode = billingResult.getResponseCode();
        if (resultCode == BillingResponseCode.OK) {
            listPurchases(purchases);
            CallbackOK("purchase");
        } else if (resultCode == BillingResponseCode.USER_CANCELED) {
            Callback("purchase", "cancel", "");
        } else {
            CallbackError("purchase", resultCode, billingResult.getDebugMessage());
        }
    }

    // Called by Connect() to open connection
    private void startServiceConnection(final Runnable executeOnSuccess) {
        CallbackLog("startServiceConnection.START");
        mBillingClient.startConnection(new BillingClientStateListener() {
            @Override
            public void onBillingSetupFinished(BillingResult billingResult) {
                int code = billingResult.getResponseCode();
                if (code == BillingResponseCode.OK) {
                    CallbackLog("startServiceConnection.OK");
                    mIsServiceConnected = true;
                    if (executeOnSuccess != null) {
                        executeOnSuccess.run();
                        // if caller is Connect(), callbackOK with connect
                    }
                } else {
                    // Should I RETRY here???
                    mIsServiceConnected = false; // probably not needed, but to be sure
                    CallbackError("connect", code, billingResult.getDebugMessage());
                    Callback("connect", "disconnected", ""); // trigger RETRY
                }
            }

            @Override
            public void onBillingServiceDisconnected() {
                mIsServiceConnected = false;
                Callback("connect", "disconnected", ""); // trigger RETRY
            }
        });
    }

    // Checks if subscriptions are supported for current client
    // Note: This method does not automatically retry for RESULT_SERVICE_DISCONNECTED.
    // It is only used in unit tests and after QueryPurchases execution, which already has
    // a retry-mechanism implemented.
    public boolean areSubscriptionsSupported() {
        BillingResult billingResult = mBillingClient.isFeatureSupported(FeatureType.SUBSCRIPTIONS);
        int responseCode = billingResult.getResponseCode();
        if (responseCode != BillingResponseCode.OK) {
            CallbackError("areSubsSupported", responseCode, billingResult.getDebugMessage());
        }
        return responseCode == BillingResponseCode.OK;
    }

    // Query INAPP and SUBS purchases and send list to onQueryPurchasesResult
    // https://youtu.be/9chvh1WYCvw?t=275
    // jBillingClient.QueryPurchases();
    public void QueryPurchases() {
        if (!mIsServiceConnected) {
            CallbackLog("WARNING: Connection needed for QueryPurchases. Call Connect(True)");
            Connect(""); // start a connection request instead
            return;
        }
        CallbackLog("QueryPurchases");
        Runnable queryToExecute = new Runnable() {
            @Override
            public void run() {
                // load list with INAPP stuff
                PurchasesResult purchasesResult = mBillingClient.queryPurchases(SkuType.INAPP);
                
                if (purchasesResult.getResponseCode() != BillingResponseCode.OK) {
                    CallbackError("QueryPurchases.INAPP",
                      purchasesResult.getResponseCode(),
                      purchasesResult.getBillingResult().getDebugMessage());
                    return;
                }
                
                if (areSubscriptionsSupported()) {
                    PurchasesResult subscriptionResult = mBillingClient.queryPurchases(SkuType.SUBS);
                    
                    CallbackInfo("subs=1", "subscriptions supported");
                    if (subscriptionResult.getResponseCode() == BillingResponseCode.OK) {
                        // Add SUBS stuff to list, subscriptionResult.getPurchasesList().size());
                        purchasesResult.getPurchasesList().addAll(
                                subscriptionResult.getPurchasesList());
                    } else {
                        CallbackError("QueryPurchases.SUBS",
                            subscriptionResult.getResponseCode(),
                            subscriptionResult.getBillingResult().getDebugMessage());
                    }
                } else {
                    CallbackInfo("subs=0", "subscriptions not supported");
                }
                mPurchases.clear();
                listPurchases(purchasesResult.getPurchasesList());
            }
        };
        executeServiceRequest(queryToExecute);
    }


    // Called by initiatePurchaseFlow, queryPurchases, etc.
    private void executeServiceRequest(Runnable runnable) {
        if (mIsServiceConnected) {
            runnable.run();
        } else {
            // If billing service was disconnected, we try to reconnect 1 time.
            // (feel free to introduce your retry policy here).
            startServiceConnection(runnable);
        }
    }


    public void initiatePurchaseFlow(final String sku,
            final String oldSku,
            final @SkuType String billingType) {

        Runnable queryRequest = new Runnable() {
            @Override
            public void run() {
                final List<String> skusList = Arrays.asList(sku); // I need this as list

                SkuDetailsParams params = SkuDetailsParams.newBuilder()
                    .setSkusList(skusList)
                    .setType(billingType)
                    .build();

                mBillingClient.querySkuDetailsAsync(params,
                    new SkuDetailsResponseListener() {
                        @Override
                        public void onSkuDetailsResponse(BillingResult billingResult, List<SkuDetails> skuDetailsList) {
                            int resultCode = billingResult.getResponseCode();
                            
                            if (skuDetailsList == null) {
                                CallbackError("buy", ERROR_SKU_NOT_FOUND, "Bad SKU, cannot find product");
                                return;
                            }
                            
                            if (skuDetailsList.size() != 1) {
                                CallbackError("buy", ERROR_SKU_NOT_FOUND, "Bad SKU, cannot find product");
                                return;
                            }
                            
                            if (resultCode != BillingResponseCode.OK) {
                                CallbackError("buy", resultCode, billingResult.getDebugMessage());
                                return;
                            }

                            SkuDetails skuDetails = skuDetailsList.get(0);
                            
                            BillingFlowParams flowParams = BillingFlowParams.newBuilder()
                              .setSkuDetails(skuDetails)
                              //.setOldSku(oldSku)
                              .build();
                            
                            mBillingClient.launchBillingFlow(controls.activity, flowParams);
                        }
                    }
                );
            }
        };
        executeServiceRequest(queryRequest);
    }

    // https://youtu.be/9chvh1WYCvw?t=170
    // send product type (INAPP, SUBS) + a list of product Ids (SKU) + listener
    public void querySkuDetailsAsync(@SkuType final String _itemType, final String _skus) {
        if (!mIsServiceConnected) {
            CallbackLog("WARNING: Connection needed for SkuDetails");
            //Connect(""); // start a connection request instead
            return;
        }
        
        final List<String> skusList = Arrays.asList(_skus.split(","));
        
        // Creating a runnable from the request to use it inside our connection retry policy below
        int count = skusList.size();
        
        CallbackLog("querySkuDetailsAsync.# " + Integer.toString(count) + " skus " + _skus);
        
        Runnable queryRequest = new Runnable() {
            @Override
            public void run() {
                // Query the purchase async
                SkuDetailsParams params = SkuDetailsParams.newBuilder()
                  .setSkusList(skusList)
                  .setType(_itemType)
                  .build();
                
                CallbackLog("querySkuDetailsAsync.Type " + _itemType);
                
                mBillingClient.querySkuDetailsAsync(params,
                    new SkuDetailsResponseListener() {
                        @Override
                        public void onSkuDetailsResponse(BillingResult billingResult,
                                List<SkuDetails> skuDetailsList) {
                            int resultCode = billingResult.getResponseCode();
                            if (resultCode == BillingResponseCode.OK) {
                                CallbackLog("querySkuDetailsAsync.RESULT OK ");

                                String xml = "";
                                int count = 0;
                                for (SkuDetails skuDetails: skuDetailsList) {
                                    count += 1;
                                    xml += "<sku" + Integer.toString(count) + ">";
                                    xml += skuDetails.getOriginalJson();
                                    xml += "</sku" + Integer.toString(count) + ">";
                                }
                                xml = "<count>" + Integer.toString(count) + "</count>" + xml;

                                // send list via Callback
                                Callback("list_" + _itemType, "ok", xml);

                            } else {
                              CallbackLog("querySkuDetailsAsync.ERROR " +
                                Integer.toString(resultCode) + " " + billingResult.getDebugMessage());
                            }
                        }
                    }
                );
            }
        };
        executeServiceRequest(queryRequest);
    }


    /*

    // (Copied from Google sample code without understanding how it works)
    public interface BillingUpdatedListener {
        void onBillingClientSetupFinished();
        void onConsumeFinished(String token, @BillingResponseCode int result);
        void onPurchasesUpdated(List<Purchase> purchases);
    }


    // (Copied from Google sample code without understanding how it works)
    public interface ServiceConnectedListener {
        void onServiceConnected(@BillingResponseCode int resultCode);
    }

    */


    public void Consume(final String token, final String payload) {

        /*
        // Did we already schedule to consume this token?
        if (mTokensToBeConsumed == null) {
            mTokensToBeConsumed = new HashSet<>();
        } else if (mTokensToBeConsumed.contains(token)) {
            // Token was already scheduled to be consumed
            Callback("consume", "skip", "<msg>Already scheduled to be consumed</msg>");
            return;
        }
        mTokensToBeConsumed.add(token);
        */

        final ConsumeResponseListener listener = new ConsumeResponseListener() {
            @Override
            public void onConsumeResponse(BillingResult billingResult, String purchaseToken) {
                if (billingResult.getResponseCode() == BillingResponseCode.OK) {
                   Callback("consume", "ok",
                       "<token>" + purchaseToken + "</token>");
                   //if (mTokensToBeConsumed.contains(purchaseToken)) {
                   //    mTokensToBeConsumed.remove(purchaseToken);
                   //}
                } else {
                   CallbackError("consume",
                       billingResult.getResponseCode(),
                       billingResult.getDebugMessage());
                }
            }
        };

        // Creating a runnable from the request to use it inside our connection retry policy below
        Runnable consumeRequest = new Runnable() {
            @Override
            public void run() {
                ConsumeParams params = ConsumeParams.newBuilder()
                    .setPurchaseToken(token)
                    //.setDeveloperPayload(payload)
                    .build();
                // Consume the purchase async
                mBillingClient.consumeAsync(params, listener);
            }
        };
        executeServiceRequest(consumeRequest);
    }

}
