unit cbillingclient;

{$mode delphi}

{

THINGS YET TO DO:

* Handle subscription price changes notifications and messages. See here:
  https://developer.android.com/google/play/billing/billing_subscriptions#change-price-sub

* Subscription switch testing
  (If everything else works, this should work too, just supply the right SKUs,
  but I haven't actually tested it.)


USAGE


Initialization

1.  Assign OnBillingEvent handler, to be notified of
    any TBillingEvent

2.  InappSkus = comma-separated string of the SKUs of all
    INAPP products of this app. (blank if none)

3.  SubsSkus = comma-separated string of the SKUs of all
    SUBS products available for this app. (blank if none)

4.  Base64PublicKey = Public key of this app, base-64 encoded

5.  Assign OnDeveloperPayload event handler, if you want to include a
    developerPayload string during Acknowledge and Consume operations.
    (This string can be used to track sales, user products, etc.)


Connect with PlayStore

1.  Call Connect(AutoQuery: boolean), which is async, and wait for events

2.  If AutoQuery=True, as soon as the connection is successful,
    the component will call QueryPurchases(), QueryInapps() and
    QuerySubs() to get the updated lists of all users purchases
    and products (inapps and subscription) available for sale

3.  If AutoQuery=False, you must call QueryPurchases, etc. manually
    at some point after the Connect operation was successful
    (i.e. after receiving event beConnect )



If Connect is successful:

1.  Internally, after a successful Connect, callback connect/ok is returned,
    and the client automatically  ask the PlayStore for 3 lists:
    purchases, inapp products, subs products, by calling
    QueryPurchases, QuerySubs, QueryInapp.

2.  The above query is async, these events should follow:

    bePurchaseListUpdated  -->  List of products owned by user has been filled
    beInappListUpdated    -->  List of INAPP products available for sale has been filled
    beSubsListUpdated    -->  List of SUBS products available for subscription has been filled

3.  After the above 3 events are received, the client should be
    up to date regarding previous user purchases, subs, and inapp products:

    OnwedCount    = how many items owned by user (both inapp and subs)
    Purchase[index]  = TBillingItem object with purchase detail
    InappCount
    Inapp[index]  = details of INAPP product, useful for showing price to user
    SubsCount
    Subs[index]   = details of SUBS product, useful for showing price to user


Errors and disconnects

1.  Error? If events beError or beDisconnect are received, the
    user is responsible to try again the failed operation
    (Connect or something else)

2.  Note: When the PlayStore app is updating itself on the device,
    Connect will fail.


Starting a purchase flow:

1.  Call Buy(sku) or Subscribe(sku, oldSku) where:

        sku = productId  (as entered in Google Play Console by admin)

        oldSku (optional) = current subscription productId, when e.g.
        there are multiple subscription alternatives and the user
        wants to change from one (oldSku) to another (sku)


2.  One of these events tells you what happens next in the purchase flow:

        beInappFlowComplete,   // Buying flow completed
        beSubsFlowComplete,   // Subscription flow completed

        beInappFlowCancel,     // User started buy flow, then canceled
        beSubsFlowCancel,     // User started sub flow, then canceled

        beInappFlowError,      // User started buy flow, error happened
        beSubsFlowError ,     // User started sub flow, error happened

    NOTE: Even after successful flow, the purchase may or may not
    be completed, it may still be pending, e.g. if the customer
    chose a payment method that needs to be finalized afterwards.


3.  In any case, in order to know what the user has actually bought,
    you must use QueryPurchases() and go through the list of items
    (Purchase


IMPLEMENTATION NOTES: DATA TYPES

1.  The TBillingItem object is used to store both items already
    purchased by the user (the "Purchase" list) and also items
    available for sale (the "Inapp" and "Subs" lists).

2.  TBillingItem gets its data from a JSON string received
    to the PlayStore app. Fields like "productId", "price",
    "title" etc. are extracted from that JSON string.

3.  The component attempts to connect the Purchase items with
    the corresponding Inapp or Subs products, by matching
    the "productId" fields, but if products change in the
    console afterwards, this match may not always be guaranteed.

4.  In any case, remember that these 3 lists of TBillingItem
    objects (i.e. Purchase items, Inapp for sale, Subs for sale)
    only contains what was returned by queries to the Google
    PlayStore app.

5.  Also remember that if a purchase is consumed, it disappears
    from the PlayStore list, and therefore it also disappears
    from the Purchase list! You are therefore responsible for
    properly saving the items you are about to consume.

6.  In many cases, and definitely if you consume purchases,
    you should save the purchase data separately somewhere,
    either on the device itself (e.g. a local file, or in
    a database) or on a backend web service.

7.  If you save an instance of a TBillingItem for later use,
    beware that the object may be freed if the list that
    contains it is cleared and rebuilt. In that case, trying to
    use that object will case a fatal exception.

    To solve this problem, monitor the following events:

    1. Just before a list is cleared, one of these events will be fired:

         beConsumedListCleared
         bePurchaseListCleared
         beInappListCleared
         beSubsListCleared

       Therefore, upon receiving that notification in the OnBillingEvent handler,
       if you have any cached TBillingItem references from the corresponding list,
       you can still do something with them right then (the list isn't cleared yet),
       but afterwards you cannot not do anything else.

       In fact it may be a good idea to set any local TBillingItem variables you
       used to NIL (and obviously check <> NIL before using them)

       After that, the following events will be triggered:

    2. When a list has been rebuilt, one of these events will be fired:

          beConsumedListUpdated
          bePurchaseListUpdated
          beInappListUpdated
          beSubsListUpdated

       At that point, it is safe to check for the number of objects
       (e.g. PurchaseCount) and use the objects themselves
       (e.g. if Purchase[x].IsPending then... etc.)


IMPLEMENTATION NOTES: CALLBACK XML STRINGS

1.  The Java class uses a string-based callback method to pass
    information back to this client.

    The information in the string is stored with XML tags, which
    contains data like <op>operation</op>, <res>result, e.g. ok</res>,
    <error>error message</error>, and so on.

    Check the method GenEvent_OnBillingClientEvent to see how the
    XML data is extracted, processed, and used to trigger events
    of type TBillingEvent that can be received by the client by
    assigning an OnBillingEvent event handler.


TRACKING PURCHASES

1.  Google allows developers to associate a custom string named
    "developerPayload" with the purchases, at the time of performing
    Acknowledge or Consume operations. (Previously google allowed
    a similar payload at the time of starting a purchase flow, but
    not anymore. Right now it can only be done with Acknowledge or Consume)

2.  You can write a payload generator method like this:

        procedure MyPayload(Sender: TObject; Item: TBillingItem; out Payload: string);

    And assign it to the OnDeveloperPayload event, e.g.:

        BillingClient1.OnDeveloperPayload := @MyPayload;

    Before performing Acknowledge or Consume operation, the above
    method will be called, and the payload string provided by it will
    be used in the call.

3.  Alternatively, you can also call Acknowledge() or Consume() by
    specifying both purchaseToken and payload directly.



SECURITY NOTES

    https://developer.android.com/google/play/billing/billing_best_practices

1.  Google recommends to perform purchase validation, preferably
    using an online web service, before releasing the purchased
    goods to the user.

2   Without such validations, it is possible for a hacker to
    reverse-engineer the Java code, shortcut the purchase process,
    re-compile the app, and thereby grant oneself the products
    without paying.

3   A good time for performing your own product validation may
    be just after a successful Acknowledge, i.e. when the event
    beAcknowledgeOK is fired.  At that point, presumably, your
    sale (INAPP or SUBS) has just been finalized, but before
    you actually release the goods to the user, you can connect
    with your own server and double-check whether the order is
    legit. Your server must use the Google Billing API
    to validate the order directly from Google. And when that
    happens, your server can give the green light to your app.

    See the above "best practices" web page for more info.

}

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  DateUtils,
  And_jni,
  {$ifdef test_billing}
  Laz_And_Controls,
  {$endif test_billing}
  AndroidWidget;

const
  // https://developer.android.com/reference/com/android/billingclient/api/BillingClient.BillingResponseCode
  BillingResultCode_OK = 0;  // Returned when the current request is successful
  ERROR_BILLING_UNAVAILABLE = 3;  // Returned when the version for the Billing API is not supported for the requested type
  ERROR_DEVELOPER_ERROR = 5;  // Returned when incorrect arguments have been sent to the Billing API
  ERROR_ERROR = 6;  // General error response returned when an error occurs during the API action being executed
  ERROR_FEATURE_NOT_SUPPORTED = -2;  // Returned when the requested action is not supported by play services on the current device
  ERROR_ITEM_ALREADY_OWNED = 7;  // Returned when the user attempts to purchases an item that they already own
  ERROR_ITEM_NOT_OWNED = 8;  // Returned when the user attempts to consume an item that they do not currently own
  ERROR_ITEM_UNAVAILABLE = 4;  // Returned when the user attempts to purchases a product that is not available for purchase
  ERROR_SERVICE_DISCONNECTED = -1;  // Play Store service is not connected now - potentially transient state. Returned when the play service is not connected at the point of the request
  ERROR_SERVICE_TIMEOUT = -3;  // Returned when an error occurs in relation to the devices network connectivity
  ERROR_SERVICE_UNAVAILABLE = 2;  // Returned when an error occurs in relation to the devices network connectivity
  ERROR_USER_CANCELED = 1;  // Returned when the user cancels the request that is currently taking place
  // Local errors:
  ERROR_NO_OP         = 11;
  // Java jcBillingClient
  ERROR_KEY_MISSING   = 21;
  ERROR_SKU_NOT_FOUND = 22;

type
  TBillingEvent = (beNone,
    beError,         // get error details in LastError
    beOperation,     // A billing operation was invoked (Connect, Query, Verify, etc.)
    beConnect,       // Connection established
    beDisconnect,    // Connection with Play Store failed, retry
    beAlreadyConn,   // asked for connection, it was already connected
    beConsumedLoad,  // a good time to load consumed items
    beConsumedSave,  // a good time to save consumed items
    beConsumedListCleared,
    beConsumedListUpdated,
    bePurchaseListCleared,    // Local list of Purchase products was cleared, don't use cached objects!
    bePurchaseListUpdated,   // Received list of Purchase products
    beInappListCleared,       // Local list of INAPP products details cleared, don't use cached objects!
    beInappListUpdated,       // Updated list of INAPP products details
    beSubsListCleared,       // Local list of SUBS products details cleared, don't use cached objects any more!
    beSubsListUpdated,       // Updated list of SUBS products details
    beInappFlowComplete,   // Buying flow completed
    beSubsFlowComplete,   // Subscription flow completed
    beInappFlowCancel,     // User started buy flow, then canceled
    beSubsFlowCancel,     // User started sub flow, then canceled
    beInappFlowError,      // User started buy flow, error happened
    beSubsFlowError ,     // User started sub flow, error happened
    beAcknowledge,        // Acknowledge operation starting
    beAcknowledgeOK,
    beAcknowledgeError,
    beConsume,            // Consume operation starting
    beConsumedOK,     // Consume flow completed successfully
    beConsumedError,  // Error in Consume() flow
    beLog,           // Called by LogC in jcBillingClient.java
    beDebug,         // Available for debugging purposes
    beInfo,
    beTest);         // Test event

const // useful for debugging, monitoring
  EventDesc: array[TBillingEvent] of string = ('beNone',
    'beError',
    'beOperation',
    'beConnect',
    'beDisconnect',
    'beAlreadyConn',
    'beConsumedLoad',
    'beConsumedSave',       
    'beConsumedListCleared',
    'beConsumedListUpdated',
    'bePurchaseListCleared',
    'bePurchaseListUpdated',
    'beInappListCleared',
    'beInappListUpdated',
    'beSubsListCleared',
    'beSubsListUpdated',
    'beInappFlowComplete',
    'beSubsFlowComplete',
    'beInappFlowCancel',
    'beSubsFlowCancel',
    'beInappFlowError',
    'beSubsFlowError',
    'beAcknowledge',
    'beAcknowledgeOK',
    'beAcknowledgeError',
    'beConsume',
    'beConsumedOK',
    'beConsumedError',
    'beLog',
    'beDebug',
    'beInfo',
    'beTest');

type
  TBillingItem = class;
  TPurchaseItem = class;
  TConsumedItem = class;

  TBillingItemKind = (bkUndefined, bkInapp, bkSubs, bkRewarded); // rewarded not implemented yet
  TConsumedStatus  = (csUndefined, csPending, csConsumed);
  TConsumedDataAction = (cdaLoad, cdaSave);

  TOnDeveloperPayload = procedure(Sender: TObject; Item: TPurchaseItem; out Payload: string) of object;
  TOnBillingEvent = procedure(Sender: TObject; Event: TBillingEvent) of object;
  TOnConsumedData = procedure(Sender: TObject; Action: TConsumedDataAction) of object;

  { TBillingItem }

  // items bought by user and products for sale
  TBillingItem = class (TObject)
  private
    //fInUserList: boolean; // is it a purchase, as opposed to item for sale
    fProduct: TBillingItem; // if I'm an owned purchase, this points to the original product, and vice-versa
    fKind: TBillingItemKind;  // INAPP or SUB
    fJson: string;  // original json with all info, loaded during skuDetails callback
  public
    // for testing and debugging
    function  TypeName: string;
    procedure DumpProp(AName, AValue: string; SL: TStringList; HTML: boolean); overload;
    procedure DumpProp(AName: string; SL: TStringList; HTML: boolean); overload;
    function  TestBuyLink: string;
  public
    property Json: string read fJson;
    property Kind: TBillingItemKind read fKind;
    function GetString(const AName: string): string;
    function GetInt64(const AName: string; def: int64 = 0): Int64;
    procedure Dump(SL: TStringList; HTML: boolean); virtual;
  public
    function Price: string;
    function Title: string;
    function productId: string;
    function Description: string;
  end;

  { TPurchaseItem }

  TPurchaseItem = class (TBillingItem)
  public
    procedure Dump(SL: TStringList; HTML: boolean); override;
    function IsNotYetAcknowledged: boolean;
    function IsConsumable: boolean;
    function IsAcknowledgedTrue: boolean;
    function IsAcknowledgedFalse: boolean;
    function IsPurchased: boolean;
    function IsPending: boolean;
    // if this is a purchased item, these will return non-blank values
    function developerPayload: string; // GetDeveloperPayload;
    function orderId: string;
    function packageName: string;
    function purchaseState: string;
    function purchaseTime: int64; // msec since Jan 1 1970
    function purchaseToken: string;
    // for our convenience
    function OrderDateTime: TDateTime;
    function OrderDateStr: string;
    function CreateConsumed(AStatus: TConsumedStatus): TConsumedItem;
    function IsSameOrder(AnotherItem: TPurchaseItem): boolean;
  end;

  // NOTE: Purchase state may be PENDING (i.e. user ordered but didn't pay yet)
  // and can become PURCHASED later on, even days later.
  // Google requires that apps handle this situation correctly.
  // E.g show the user order is pending, and update it accordinly
  // when PurchaseState becomes PURCHASES (IsPurchased = True)

  { TConsumedItem }

  TConsumedItem = class (TPurchaseItem)
  private
    fConsumedStatus: TConsumedStatus;
    function GetConsumedData: string;
    procedure SetConsumedData(const s: string);
  public
    property Status: TConsumedStatus read fConsumedStatus;
  end;

  { jcBillingClient }

  jcBillingClient = class(jControl)
  private
    fAutoAcknowledge: boolean;
    fInappHash,
    fSubsHash,
    fPurchaseHash,
    fConsumedHash: string; // to avoid triggering events if nothing changed
    fAutoQuery: boolean; // if true, query purchases & products automatically after connect
    fPublicKey: string;
    fLastError: string;
    fInappSkus: string; // comma-separated list of INAPP managed products sku for sale (created in Google Play Console)
    fSubsSkus:  string; // comma-separated list of SUBS products sku for sale (created in Google Play Console)
    fInFlow: string; // keep track of what's in buy/sub/consume flow
    fInappList: TList; // inapp items available for sale
    fSubsList:  TList; // subs items available for subscription
    fPurchaseList: TList; // list of purchased items owned by user (some purchases may still be pending!)
    fConsumedList: TList;
    fConnectState: integer;
    fSubsNotSupported: boolean;
    fOnBillingEvent: TOnBillingEvent;
    fOnDeveloperPayload: TOnDeveloperPayload;
    fOnConsumedData: TOnConsumedData;
    function GetConsumed(i: integer): TConsumedItem;
    function GetConsumedData: string;
    function GetInappCount: integer;
    function GetSubsCount: integer;
    function GetPurchaseCount: integer;
    function GetConsumedCount: integer;
    function GetInapp(index: integer): TBillingItem;
    function GetSubs(index: integer): TBillingItem;
    function GetPurchase(index: integer): TPurchaseItem;
    function GetInappSkus: string;
    function GetSubsSkus: string;
    procedure ProcessProductList(const xml: string; List: TList;
      EventClear, EventDone: TBillingEvent; var Hash: string);
    procedure ClearList(L: TList; AndFree: boolean = false);
    procedure SetAutoAcknowledge(AValue: boolean);
    procedure SetConsumedData(const AValue: string);
    procedure SetInappSkus(AValue: string);
    procedure SetSubsSkus(AValue: string);
    procedure AddConsumed(APurchase: TPurchaseItem; CStatus: TConsumedStatus);
    procedure ConfirmConsumed(const OrderId: string);
  protected
    procedure Notify(BillingEvent: TBillingEvent; msg: string = ''); virtual;
    function DeveloperPayload(Item: TPurchaseItem): string; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure jFree();
    procedure Retry;
    procedure GenEvent_OnBillingClientEvent(const xml: string); // called by Java side Callback
    procedure ShowMessage(msg: string);
  public
    function  GetStatus: string;
    procedure Connect(AutoQuery: boolean);
    // Consumed products
    property ConsumedCount: integer read GetConsumedCount;
    property Consumed[i: integer]: TConsumedItem read GetConsumed;
    property ConsumedData: string read GetConsumedData write SetConsumedData;
    procedure DeleteConsumed(Item: TConsumedItem);
    // Products (both INAPP and SUBS) already owned by user:
    property PurchaseCount: integer read GetPurchaseCount;
    property Purchase[index: integer]: TPurchaseItem read GetPurchase;
    function FindPurchase(PurchaseToken: string): TPurchaseItem;
    // INAPP products available for sale
    property  InappCount: integer read GetInappCount;
    property  Inapp[index: integer]: TBillingItem read GetInapp;
    function  IsInapp(const sku: string): boolean;
    function  FindInapp(const sku: string): TBillingItem;
    // SUBS products available for subscription
    property  SubsCount: integer read GetSubsCount;
    property  Subs[index: integer]: TBillingItem read GetSubs;
    function  FindSubs(const sku: string): TBillingItem;
    function  IsSubs(const sku: string): boolean;
    property  SubsNotSupported: boolean read fSubsNotSupported;
    // Billing-specific operations. All are ASYNC operations!
    procedure QueryPurchases(); // request purchases owned by user
    procedure QueryInappList(); // request details of INAPP products for sale
    procedure QuerySubsList(); // request details of SUBS products for sale
    procedure Buy(const sku: string); // Start purchase flow of INAPP product
    procedure Subscribe(const sku: string; const OldSubsSKU: string = '');// Start purchase flow of SUBS product
    procedure AcknowledgeAll; // relies on OnDeveloperPayload for setting payload
    procedure Acknowledge(Item: TPurchaseItem); overload;
    procedure Acknowledge(const PurchaseToken: string); overload;
    procedure Acknowledge(const PurchaseToken, Payload: string); overload;
    procedure Consume(Item: TPurchaseItem); overload;
    procedure Consume(const PurchaseToken: string); overload;
    procedure Consume(Item: TPurchaseItem; const Payload: string); overload;
    procedure LoadConsumed(); virtual;
    procedure SaveConsumed(); virtual;
    procedure ClearError;
    function  DoCmd(cmd, Param1, Param2: string): boolean; overload;
    function  DoCmd(cmd: string): boolean; overload;
    procedure FireEvent(op, res, data: string);
    function  ActiveInapp: string; // sku of INAPP product being bought
    function  ActiveSubs: string;  // sku of SUBS product being subscribed
    function  ActiveConsume: string; // sku of product being consumed

    // Misc
    property  LastError: string read fLastError;
    property  PurchaseHash: string read fPurchaseHash;
    property  InappHash: string read fInappHash;
    property  SubsHash: string read fSubsHash;

    property PurchaseList: TList read fPurchaseList; // list of purchased items owned by user (some purchases may still be pending!)
    property ConsumedList: TList read fConsumedList;
    property InappList: TList read fInappList; // inapp items available for sale
    property SubsList:  TList read fSubsList; // subs items available for subscription

  public
    Logs: TStringList;
    KeepLogs: boolean;
    procedure LogEvent(E: TBillingEvent; msg: string = ''); overload;
    procedure LogEvent(msg: string); overload;
    procedure LogDump(SL: TStringList; HTML, RecentOnTop: boolean);
  public
    // for debugging
    {$ifdef test_billing}
    WV: jWebView;
    Laz_And_Controls,
    DBG: string;
    procedure ListDump(SL: TStringList; HTML: boolean);
    procedure TestUpdateUI;
    function  TestHtml: string;
    function  TestConsumedFilename: string;
    procedure TestOnBillingEvent(Sender: TObject; BE: TBillingEvent);
    procedure OnWvStatus(Sender: TObject; AStatus : TWebViewStatus;
      URL : String; Var CanNavi : Boolean);
    procedure TestOnPayload(Sender: TObject; Item: TPurchaseItem; out
      payload: string);
    procedure TestMode(DebugWebView: jWebView; AppKey: string = 'DUMMY');
    procedure TestConsumedData(Sender: TObject; Action: TConsumedDataAction);
    {$endif test_billing}
  published
    // comma-separated lists of products for sale (buy) and subscription (sub)
    property AutoAcknowledge: boolean read fAutoAcknowledge write SetAutoAcknowledge;
    property Base64PublicKey: string read fPublicKey write fPublicKey;
    property InappSkus: string read GetInappSkus write SetInappSkus;
    property SubsSkus: string read GetSubsSkus write SetSubsSkus;
    property OnBillingEvent: TOnBillingEvent read fOnBillingEvent write fOnBillingEvent;
    property OnConsumedData: TOnConsumedData read fOnConsumedData write fOnConsumedData;
    property OnDeveloperPayload: TOnDeveloperPayload read fOnDeveloperPayload write fOnDeveloperPayload;
  end;

{$ifdef test_billing}
function Test(F: jForm; WV: jWebView; InApps, Subs: string): jcBillingClient;
{$endif}

implementation

const
  // TBillingItem.PurchaseState has one of these values
  //PURCHASE_STATE_UNSPECIFIED  = '0';
  PURCHASE_STATE_PURCHASED    = '1';
  PURCHASE_STATE_PENDING      = '2';

function IsInCommaSeparatedString(const token, css: string): boolean;
begin
  result := pos(','+token+',', ',' + css + ',') > 0
end;

function CalcHash(const s: string): string;
begin
  result := s; // I'm lazy, but this works for now ...
end;

function GetXmlVal(const xml, field: string): string;
var t1, t2: string; x1, x2: integer;
begin
  result := '';
  t1 := '<' + field + '>';
  t2 := '</' + field + '>';
  x1 := pos(t1, xml);
  if x1 = 0 then exit;
  x1 := x1 + length(t1);
  x2 := pos(t2, xml);
  if x2 = 0 then exit;
  if x2 <= x1 then exit;
  result := copy(xml, x1, x2 - x1);
end;

{-------- jcBillingClient_JNI_Bridge ----------}

{

Add the following in Controls.Java:

public java.lang.Object jcBillingClient_Create(long _Self) {
   return (java.lang.Object)(new jcBillingClient(this,_Self));

}

Function jcBillingClient_Create(env:PJNIEnv; this:jobject; SelfObj: TObject): jObject;
var
  jMethod: jMethodID = nil;
  jParams: array[0..0] of jValue;
  jCls: jClass;
begin
  jCls:= Get_gjClass(env);
  jParams[0].j := Int64(SelfObj);
  jMethod:= env^.GetMethodID(env, jCls, 'jcBillingClient_Create', '(J)Ljava/lang/Object;');
  Result := env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result := env^.NewGlobalRef(env, Result);
end;

{ TConsumedItem }

function TConsumedItem.GetConsumedData: string;
var SL: TStringList;
begin
  SL := TStringList.Create;

  SL.Add('<ConsumedItem>');
  SL.Add('<ci_json>' + fJson +'</ci_json>');

  case Kind of
    bkSubs:  SL.Add('<ci_kind>subs</ci_kind>');
    bkInapp: SL.Add('<ci_kind>inapp</ci_kind>');
  end;

  case Status of
    csPending:  SL.Add('<ci_status>pending</ci_status>');
    csConsumed: SL.Add('<ci_status>consumed</ci_status>');
  end;

  SL.Add('</ConsumedItem>');
  result := SL.text;
  SL.Free;
end;

procedure TConsumedItem.SetConsumedData(const s: string);
  function Extract(ATag: string): string;
  var x1, x2: integer; t: string;
  begin
    result := '';
    t := '<' + ATag + '>';
    x1 := pos(t, s);
    if x1 = 0 then exit;
    x1 := x1 + length(t); // beginning of content
    insert('/', t, 2);
    x2 := pos(t, s);
    if x2 < x2 then exit;
    result := copy(s, x1, x2-x1);
  end;

var t: string;
begin
  t := extract('ci_status');

  if t = 'pending' then
    fConsumedStatus := csPending;

  if t = 'consumed' then
    fConsumedStatus := csConsumed;

  t := extract('ci_kind');

  if t = 'subs' then
    fKind := bkSubs;

  if t = 'inapp' then
    fKind := bkInapp;

  fJson := extract('ci_json');
end;

{ TBillingItem; }

function TBillingItem.Price: string;
begin
  result := GetString('price');
end;

function TBillingItem.Title: string;
begin
  result := GetString('title');
end;

function TBillingItem.Description: string;
begin
  if (Self is TPurchaseItem) and (fProduct<>nil) then
    result := fProduct.Description
  else
    result := GetString('description');
end;

function TPurchaseItem.IsPending: boolean;
begin
  result := PurchaseState = PURCHASE_STATE_PENDING
end;

procedure TPurchaseItem.Dump(SL: TStringList; HTML: boolean);
begin
  inherited Dump(SL, HTML);
  if HTML and not (Self is TConsumedItem) then begin
    // Acknowledge and Consume links, only
    if IsNotYetAcknowledged then
      SL.Add('<br><a href="billing:acknowledge='+
        GetString('purchaseToken') + '">ACKNOWLEDGE THIS PURCHASE</a><br>&nbsp;');

    if IsConsumable then
      SL.Add('<br><a href="billing:consume='+
        GetString('purchaseToken') + '">CONSUME THIS PURCHASE</a>');
  end;
end;

function TPurchaseItem.IsAcknowledgedTrue: boolean;
begin
  result := GetString('acknowledged') = 'true'
end;

function TPurchaseItem.IsAcknowledgedFalse: boolean;
begin
  result := GetString('acknowledged') = 'false'
end;

function TPurchaseItem.IsNotYetAcknowledged: boolean;
begin
  result := IsAcknowledgedFalse and not (Self is TConsumedItem);
end;

function TPurchaseItem.IsConsumable: boolean;
begin
  result := IsAcknowledgedTrue and not (Self is TConsumedItem);
end;

function TPurchaseItem.IsPurchased: boolean;
begin
  result := PurchaseState = PURCHASE_STATE_PURCHASED
end;

function TPurchaseItem.developerPayload: string;
begin
  result := GetString('developerPayload');
end;

function TPurchaseItem.orderId: string;
begin
  result := GetString('orderId');
end;

function TBillingItem.productId: string;
begin
  result := GetString('productId');
end;

function TPurchaseItem.packageName: string;
begin
  result := GetString('packageName');
end;

function TPurchaseItem.purchaseState: string;
begin
  result := GetString('purchaseState');
end;

function TPurchaseItem.purchaseTime: int64;
var s: string;
begin
  result := 0;

  s := GetString('purchaseTime');

  if s <> '' then
    try
      result := StrToInt64(s)
    except
      result := 0
    end;
end;

function TPurchaseItem.purchaseToken: string;
begin
  result := GetString('purchaseToken');
end;

function TPurchaseItem.OrderDateTime: TDateTime;
begin
  Result := UnixToDateTime(purchaseTime div 1000);
end;

function TPurchaseItem.OrderDateStr: string;
var DT: TDateTime;
begin
  DT := OrderDateTime;
  if DT < 45000 then
    result := ''
  else
    result := FormatDateTime('yyyy-mm-dd', DT);
end;

function TPurchaseItem.CreateConsumed(AStatus: TConsumedStatus): TConsumedItem;
begin
  result := TConsumedItem.Create();
  result.fConsumedStatus := AStatus;
  result.fKind := fKind;
  result.fJson := fJson;
end;

function TPurchaseItem.IsSameOrder(AnotherItem: TPurchaseItem): boolean;
begin
  result := orderId = AnotherItem.OrderId;
  {$ifdef test_billing}
  // in static test mode, all orderId are the same,
  // so compare developerPayload as well
  result := result and (developerPayload = AnotherItem.developerPayload);
  {$endif}
end;

function TBillingItem.TypeName: string;
begin
  if Self is TConsumedItem then
    result := 'Consumed'
  else if Self is TPurchaseItem then
    result := 'Purchase'
  else
    result := GetString('type')
end;

procedure TBillingItem.DumpProp(AName, AValue: string; SL: TStringList;
  HTML: boolean);
begin
  if AValue = '' then exit;

  if HTML then
    AName := '<br><b>' + AName + '</b>';

  SL.Add(AName + ' = ' + AValue);
end;

procedure TBillingItem.DumpProp(AName: string; SL: TStringList; HTML: boolean);
begin
  DumpProp(AName, GetString(AName), SL, HTML);
end;

function TBillingItem.TestBuyLink: string;
var s, p: string;
begin
  p := productId;
  //p := GetString('skuDetailsToken');
  if Kind=bkSubs then s := 'sub' else s := 'buy';

  result := '<p><b>' + title + '</b>' +
    '<br>' + Description + // ; GetString('desc') +
    '<br>sku = ' + p +
    '<br><a href="billing:' +
    s+'='+ p + '">'+s+' now - ' +
    Price + '</a>';
end;

function GetJsonValue(const Json, AName: string): string;
var k: string; x, x1, a, i: integer; Quotes: boolean;
begin
  result := '';
  k := '"' + AName + '":';
  x := pos(k, Json);
  if x < 2 then exit; // not found
  x1 := x + length(k); // starting point of value, could be space
  a := 0;
  Quotes := False;
  for i := x1 to length(Json) do begin
    if Json[i] <= #32 then continue;
    if Json[i] = '"' then begin
      if Json[i-1] = '\' then continue; // quotes are escaped
      if a > 0 then begin
        result := trim(copy(Json, a, i-a));
        exit;
      end else begin
        a := i + 1; // starting point of string value
        Quotes := True;
        continue;
      end;
    end;
    if Quotes then continue; // we're still inside quotes, so everything goes
    if (Json[i] = ',') or (Json[i]='}') then begin
      if a=0 then exit; // no data
      result := trim(copy(Json, a, i-a));
      exit;
    end;
    if a = 0 then a := i;
  end;
  {
  AI Banks, capital market JPMorkan Merryl Lynch
  Shareholder, no longer CEO
  research clean tech
  }
end;

function TBillingItem.GetString(const AName: string): string;
begin
  result := GetJsonValue(fJson, AName);
end;

function TBillingItem.GetInt64(const AName: string; def: int64): Int64;
var s: string;
begin
  result := def;

  s := GetString(AName);

  if (s<>'') then
    try
      result := StrToInt64(s);
    except
      result := def;
    end;

end;

procedure TBillingItem.Dump(SL: TStringList; HTML: boolean);
  procedure DumpID(AName: string);
  begin
    DumpProp(AName, SL, HTML);
  end;
begin
  DumpProp('json', fJson, SL, HTML);

  if Self is TPurchaseItem then begin
    DumpID('packageName');
    DumpID('acknowledged');
    DumpID('orderId');
    DumpID('productId');
    DumpID('developerPayload');
    DumpID('purchaseTime');
    DumpID('purchaseState');
    DumpID('purchaseToken');
    DumpID('autoRenewing'); // subscriptions
  end else begin
    // items for sale
    DumpID('skuDetailsToken');
    DumpID('productId');
    DumpID('type');
    DumpID('title');
    DumpID('description');
    DumpID('price');
    DumpID('price_amount_micros');
    DumpID('price_currency_code');
    DumpID('subscriptionPeriod');
    DumpID('freeTrialPeriod');
    DumpID('introductoryPrice');
    DumpID('introductoryPriceAmountMicros');
    DumpID('introductoryPriceCycles');
    DumpID('introductoryPricePeriod');
  end;
end;

{---------  jcBillingClient  --------------}

constructor jcBillingClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fPurchaseList := TList.Create;
  fConsumedList := TList.Create;
  fInappList := TList.Create;
  fSubsList  := TList.Create;
  fAutoAcknowledge := True;
  Logs := TStringList.Create;
end;

destructor jcBillingClient.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jFree();
       FjObject:= nil;
     end;
  end;
  ClearList(fConsumedList, True);
  ClearList(fPurchaseList, True);
  ClearList(fInappList, True);
  ClearList(fSubsList, True);
  Logs.Free;
  inherited Destroy;
end;

procedure jcBillingClient.Notify(BillingEvent: TBillingEvent; msg: string);
begin
  if KeepLogs then
    LogEvent(BillingEvent, msg);

  if Assigned(fOnBillingEvent) then
    fOnBillingEvent(Self, BillingEvent);
end;

function jcBillingClient.DeveloperPayload(Item: TPurchaseItem): string;
begin
  result := Item.developerPayload;

  if Assigned(fOnDeveloperPayload) then
    fOnDeveloperPayload(Self, Item, result);
end;

function jcBillingClient.GetInappCount: integer;
begin
  result := fInappList.Count
end;

function jcBillingClient.GetConsumed(i: integer): TConsumedItem;
begin
  result := TConsumedItem(fConsumedList[i])
end;

procedure jcBillingClient.SetConsumedData(const AValue: string);
var
  hash: string;
  x1, x2: integer;
  CI: TConsumedItem;
begin
  x2 := pos('<BillingClientConsumedData>', AValue);

  if x2 = 0 then exit; // bad data, ignore it

  hash := CalcHash(AValue);

  if hash = fConsumedHash then begin
    LogEvent(beLog, 'NO CHANGES IN CONSUMED LIST');
    exit;
  end;

  fConsumedHash := Hash;
  Notify(beConsumedListCleared);
  ClearList(fConsumedList);

  while x2 > 0 do begin
    x1 := PosEx('<ConsumedItem>', AValue, x2);
    if x1 < x2 then break;
    x2 := PosEx('</ConsumedItem>', AValue, x1);
    if x2 < x1 then break;
    CI := TConsumedItem.Create;
    fConsumedList.Add(CI);
    CI.SetConsumedData(copy(AValue, x1, x2-x1));
  end;

  Notify(beConsumedListUpdated);
end;

function jcBillingClient.GetConsumedData: string;
var SL: TStringList; i: integer;
begin
  SL := TStringList.Create;

  SL.Add('<!-- Do not modify this file, manually or otherwise! -->');
  SL.Add('<BillingClientConsumedData>');

  for i := 0 to ConsumedCount-1 do
    SL.Add(Consumed[i].GetConsumedData);

  SL.Add('</BillingClientConsumedData>');
  result := SL.Text;
  SL.Free;
end;

function jcBillingClient.GetSubsCount: integer;
begin
  result := fSubsList.Count
end;

procedure jcBillingClient.ProcessProductList(const xml: string; List: TList;
  EventClear, EventDone: TBillingEvent; var Hash: string);

  procedure FixProductLinks;
  var i, j: integer;
  begin
    for i := 0 to PurchaseCount-1 do
      Purchase[i].fProduct := nil;

    for j := 0 to InappCount-1 do begin
      for i := 0 to PurchaseCount-1 do
        if Purchase[i].productId = Inapp[j].productId then begin
          Purchase[i].fProduct := Inapp[j];
          Purchase[i].fKind    := Inapp[j].fKind; // inapp or subs?
          Inapp[j].fProduct := Purchase[i];
          break;
        end;
    end;

    for j := 0 to SubsCount-1 do begin
      for i := 0 to PurchaseCount-1 do
        if Purchase[i].productId = Subs[j].productId then begin
          Purchase[i].fProduct := Subs[j];
          Subs[j].fProduct := Purchase[i];
          break;
        end;
    end;
  end;

var s, XmlHash: string; px: integer; P: TBillingItem;
begin
  // xml contains <sku1>...</sku1> ... <skuN>..</skuN>
  if not FInitialized  then Exit;

  XmlHash := CalcHash(xml);

  if XmlHash = Hash then begin
    LogEvent(EventDone, 'NO CHANGE'); //
    exit; // nothing changed, don't rebuild and trigger events unnecessarily
  end;

  Hash := XmlHash;
  Notify(EventClear);
  ClearList(List);

  px := 0;

  repeat
    inc(px);

    s := GetXmlVal(xml, 'sku' + IntToStr(px));

    if s = '' then break;

    if List = fPurchaseList then
      P := TPurchaseItem.Create()
    else
      P := TBillingItem.Create();

    List.Add(P);
    P.fJson := s;

    if List = fInappList then
      P.fKind := bkInapp;
    if List = fSubsList then
      P.fKind := bkSubs;
  until s='';

  FixProductLinks;
  Notify(EventDone);
end;

procedure jcBillingClient.ClearList(L: TList; AndFree: boolean);
var i: integer;
begin
  for i := 0 to L.Count-1 do
    TObject(L[i]).Free;

  L.Clear;

  if AndFree then L.Free;
end;

procedure jcBillingClient.SetAutoAcknowledge(AValue: boolean);
begin
  if fAutoAcknowledge=AValue then Exit;

  fAutoAcknowledge:=AValue;

  if AValue then // AutoAcknowledge was just turned on, if there's anything not yet acknowledged, do it now
    AcknowledgeAll;
end;

procedure jcBillingClient.SetInappSkus(AValue: string);
begin
  if fInappSkus=AValue then Exit;

  fInappSkus:=AValue;
end;

procedure jcBillingClient.SetSubsSkus(AValue: string);
begin
  if fSubsSkus=AValue then Exit;

  fSubsSkus:=AValue;
end;

procedure jcBillingClient.AddConsumed(APurchase: TPurchaseItem;
  CStatus: TConsumedStatus);
var i: integer;
begin
  // make sure we don't add duplicates.
  for i := 0 to ConsumedCount-1 do
    if Consumed[i].IsSameOrder(APurchase) then
      // This can happen if some callback messages get lost, as google warns
      // (find URL of google documentation about lost Consumed messages)
      exit;
  // didn't find consumed object, add it and save the change
  fConsumedList.Add(APurchase.CreateConsumed(CStatus));
  SaveConsumed();
end;

procedure jcBillingClient.ConfirmConsumed(const OrderId: string);
var i: integer;
begin
  // We added a PENDING Consumed object before requested PlayStore to consume it.
  // Now that we got confirmation, we must change the status from PENDING to CONSUMED.
  for i := 0 to ConsumedCount-1 do
    if orderId = Consumed[i].orderId then begin
      if Consumed[i].Status <> csConsumed then begin
        Consumed[i].fConsumedStatus := csConsumed;
        SaveConsumed(); // always save ConsumedData immediately after changes!
      end;
    end;
end;

function jcBillingClient.GetInapp(index: integer): TBillingItem;
begin
  result := TBillingItem(fInappList[index]);
end;

function jcBillingClient.GetSubs(index: integer): TBillingItem;
begin
  result := TBillingItem(fSubsList[index]);
end;

function jcBillingClient.GetPurchaseCount: integer;
begin
  result := fPurchaseList.Count
end;

function jcBillingClient.GetConsumedCount: integer;
begin
  result := fConsumedList.Count;
end;

function jcBillingClient.GetPurchase(index: integer): TPurchaseItem;
begin
  result := TPurchaseItem(fPurchaseList[index]);
end;

function jcBillingClient.GetInappSkus: string;
begin
  result := fInappSkus;
end;

function jcBillingClient.GetSubsSkus: string;
begin
  result := fSubsSkus;
end;

procedure jcBillingClient.ShowMessage(msg: string);
begin
  jForm(Owner).ShowMessage(msg)
end;

procedure jcBillingClient.GenEvent_OnBillingClientEvent(const xml: string); // something happened
var op, res: string;

  function error: string;
  begin
    result := GetXmlVal(xml, 'error')
  end;

  function msg: string;
  begin
    result := GetXmlVal(xml, 'msg')
  end;

  procedure ProcessList;
  begin
    if (op = 'list_inapp') then  // rebuild list of INAPP
      ProcessProductList(xml, fInappList,
        beInappListCleared, beInappListUpdated, fInappHash);
    if (op = 'list_subs') then   // rebuild list of SUBS
      ProcessProductList(xml, fSubsList,
        beSubsListCleared, beSubsListUpdated, fSubsHash);
    if (op = 'list_purchase') then // rebuild list of user purchase
      ProcessProductList(xml, fPurchaseList,
        bePurchaseListCleared, bePurchaseListUpdated, fPurchaseHash);
  end;

  function ProcessPurchase: boolean;
  var BE: TBillingEvent;
  begin
    BE := beNone;
    if res = 'ok' then begin
      // successful purchase
      if pos('buy=', fInFlow) = 1 then
        BE := beInappFlowComplete;
      if pos('sub=', fInFlow) = 1 then
        BE := beSubsFlowComplete;
      if AutoAcknowledge then
        AcknowledgeAll;
    end;
    if res = 'error' then begin
      if pos('buy=', fInFlow) = 1 then
        BE := beInappFlowError;
      if pos('sub=', fInFlow) = 1 then
        BE := beSubsFlowError;
    end;
    if res = 'cancel' then begin
      if pos('buy=', fInFlow) = 1 then
        BE := beInappFlowCancel;
      if pos('sub=', fInFlow) = 1 then
        BE := beSubsFlowCancel;
    end;
    result := BE <> beNone;
    if Result then
      Notify(BE);
    fInFlow := '';
  end;

begin
  op := GetXmlVal(xml, 'op');
  res := GetXmlVal(xml, 'result');
  fLastError := error;

  if (op='info') then begin
    if res = 'subs=0' then
      fSubsNotSupported := True;
    Notify(beInfo, msg);
    exit;
  end;

  if (op='') then begin
    fLastError := IntToStr(ERROR_NO_OP);
    Notify(beError, 'op missing');
    exit;
  end;

  if pos('list_', op) = 1 then begin
    ProcessList();
    exit;
  end;

  if op = 'connect' then begin
    if res = 'ok' then begin
      // connected, request info:
      fConnectState := 1;
      Notify(beConnect);
      if fAutoQuery then begin
        // connection was successful, ask for all info now:
        QueryPurchases();  // list of owned products
        QueryInappList();  // list of INAPP details
        QuerySubsList();   // list of SUBS details
      end;
      exit;
    end;
    if res = 'already_connected' then begin
      Notify(beAlreadyConn);
      fConnectState := 1;
      exit;
    end;
    if (res = 'disconnected')
      or (res = 'error')
    then begin
      if fConnectState >= 0 then begin
        Notify(beDisconnect);
        // returned error during mBilling.startConnection
        fConnectState := -1;
      end;
      // RETRY?
      exit;
    end;
  end;

  if (op = 'purchase') then begin
    if ProcessPurchase then
      exit; // Notify done above
  end;

  if op = 'acknowledge' then begin
    if res = 'ok' then begin
      Notify(beAcknowledgeOK);
      QueryPurchases(); // get updated list
    end;
    if res='error' then
      Notify(beAcknowledgeError, msg);
    exit;
  end;

  if op = 'consume' then begin
    if res = 'ok' then begin
      //LogEvent(beConsumeOK, 'XML = ' + xml);
      ConfirmConsumed(GetXmlVal(xml, 'token'));
      Notify(beConsumedOK, GetXmlVal(xml, 'token'));
      QueryPurchases(); // refresh list
      exit;
    end;
    if res='error' then begin
      Notify(beConsumedError, msg);
      // maybe I should try again... right now consumed is PENDING
      exit;
    end;
  end;

  if (op = 'test') then begin
    Notify(beTest, msg);
    exit;
  end;

  if (op = 'log') then begin
    Notify(beLog, msg);
    exit;
  end;

  if op = 'ShowMessage' then begin
    ShowMessage(msg);
    exit;
  end;

  if res = 'error' then begin
    Notify(beError, msg);
    exit;
  end;

  Notify(beDebug, 'Unhandled callback: ' + xml);
end;

function jcBillingClient.GetStatus: string;
begin
  if FInitialized then
    result := jni_func_out_t(FjEnv, FjObject, 'GetStatus')
  else
    result := 'Object not initialized';
end;

procedure jcBillingClient.ClearError;
begin
  fLastError := '';
end;

// process, e.g.  billing:test=connect or billing:sub=newsub2,oldsub1
function jcBillingClient.DoCmd(cmd: string): boolean;
var x: integer; Param1, Param2: string;
begin
  //showMessage(cmd);
  result := pos('billing:', cmd) = 1;

  if not result then exit;

  Cmd := copy(cmd, pos(':',cmd)+1, 1000);

  x := pos(',', cmd);

  if x = 0 then
    Param2 := ''
  else begin
    Param2 := copy(cmd, x+1, 1000);
    SetLength(cmd, x-1);
  end;

  x := pos('=', cmd);

  if x = 0 then
    Param1 := ''
  else begin
    Param1 := copy(cmd, x+1, 1000);
    SetLength(cmd, x-1);
  end;

  result := DoCmd(Cmd, Param1, Param2);
  {$ifdef test_billing}
  if result then
    TestUpdateUI;
  {$endif}
end;

procedure jcBillingClient.FireEvent(op, res, data: string);
begin
  GenEvent_OnBillingClientEvent('<billing><op>'+op+
    '</op><result>'+res+'</result>'+data+'</billing>');
end;

function jcBillingClient.FindInapp(const sku: string): TBillingItem;
var i: integer;
begin
  for i := 0 to fInappList.Count-1 do begin
    result := TBillingItem(fInappList[i]);
    if result.productId = sku then exit;
  end;

  result := nil;
end;

function jcBillingClient.FindSubs(const sku: string): TBillingItem;
var i: integer;
begin
  for i := 0 to fSubsList.Count-1 do begin
    result := TBillingItem(fSubsList[i]);
    if result.productId = sku then exit;
  end;

  result := nil;
end;

function jcBillingClient.DoCmd(cmd, Param1, Param2: string): boolean;
begin
  result := True;

  if cmd = 'clear_log' then begin
    Logs.Clear;
    exit;
  end;

  {$ifdef test_billing}
  if cmd = 'test' then begin
    //ShowMessage('BC Test [' + Param1 + ']');

    // simulate events:
    if Param1 = 'log' then
      FireEvent('log', 'ok', '<msg>Test log</msg>');
    if Param1 = 'event' then
      FireEvent('test', 'ok', '<msg>Test event</msg>');
    if Param1 = 'error' then
      FireEvent('test', 'error', '<error>404</error><msg>not found</msg>');

    //if Param1 = 'init' then
    //  Init(gApp);  // list of owned products
    if Param1 = 'query_purchases' then
      QueryPurchases();  // list of owned products
    if Param1 = 'query_inapp' then
      QueryInappList();  // list of INAPP details
    if Param1 = 'query_subs' then
      QuerySubsList();   // list of SUBS details
    if Param1 = 'delete_consumed' then begin
      DeleteConsumed(Consumed[StrToInt(Param2)]);
      Tag := 12;
    end;

    if Param1 = 'aa1' then
      AutoAcknowledge:=True;
    if Param1 = 'aa0' then
      AutoAcknowledge:=False;

    if Param1 = 'load_consumed' then
      LoadConsumed();   // list of Consumed details

    if Param1 = 'clear' then
      Logs.Clear;
    if pos('connect_aq', Param1) = 1 then begin
      Connect(pos('aq1', Param1) > 0);
    end;
    if Param1 = 'refresh' then begin
      Tag := 0;
      TestUpdateUI();
    end;
    exit;
  end;
  {$endif}

  if (cmd = 'buy') then begin
    Buy(Param1);
    exit;
  end;

  if (cmd = 'sub') then begin
    Subscribe(Param1, Param2);
    exit;
  end;

  if cmd = 'acknowledge' then begin
    Acknowledge(Param1);
    exit;
  end;

  if (cmd = 'consume') then begin
    Consume(Param1);
    exit;
  end;

  ShowMessage('UNHANDLED: ' + cmd + '/' + Param1 + '/' + Param2);
  result := False;
end;

procedure jcBillingClient.LogEvent(E: TBillingEvent; msg: string);
var s: string;
begin
  if not KeepLogs then exit;

  s := EventDesc[E] + '  ';

  case E of
  beError:
    s := s + 'LastError = ' + LastError;
  bePurchaseListUpdated:
    s := s + IntToStr(PurchaseCount) + ' PURCHASE items listed';
  beInappListUpdated:
    s := s + IntToStr(InappCount) + ' INAPP products listed';
  beSubsListUpdated:
    s := s + IntToStr(SubsCount) + ' SUBS products listed';
  beInappFlowComplete:
    s := s + '"' + ActiveInapp + '" purchased';
  beSubsFlowComplete:
    s := s + '"' + ActiveSubs + '" subscribed';
  //beConsumeOK:
  //  s := s + '"' + ActiveConsume + '" consumed';
  end;

  if msg <> '' then
    s := s + ' ' + msg;

  LogEvent(s);
end;

procedure jcBillingClient.LogEvent(msg: string);
begin
  if KeepLogs then
    Logs.Add(FormatDateTime('hh:nn:ss - ', Now) + msg);
end;

{$ifdef test_billing}

var
  TestBC: jcBillingClient = nil;

function Test(F: jForm; WV: jWebView; InApps, Subs: string): jcBillingClient;
begin
  if TestBC = nil then begin
    TestBC := jcBillingClient.Create(F);
    TestBC.Init(gApp);
  end;
  TestBC.InappSkus := InApps;
  TestBC.SubsSkus  := Subs;
  TestBC.TestMode(WV);
  TestBC.TestUpdateUI;
  Result := TestBC;
end;

procedure jcBillingClient.TestMode(DebugWebView: jWebView; AppKey: string);
begin
  KeepLogs := True;
  fPublicKey := AppKey;
  fAutoAcknowledge := False; // in order to visualize Acknowledge process more easily
  WV := DebugWebView;

  WV.OnStatus := OnWvStatus;
  OnBillingEvent := TestOnBillingEvent;
  OnDeveloperPayload := TestOnPayload;
  OnConsumedData := TestConsumedData;

end;

procedure jcBillingClient.TestConsumedData(Sender: TObject;
  Action: TConsumedDataAction);
var SL: TStringList;
begin
  // for testing purposes we save Consumed objects in a pseudo-XML file
  // in the internal app folder. If instead, for example, you want
  // to use a database, simply read or write the ConsumedData string.
  SL := TStringList.Create;
  case Action of
  cdaLoad:
    if FileExists(TestConsumedFilename) then begin
      SL.LoadFromFile(TestConsumedFilename);
      ConsumedData := SL.Text;
    end;
  cdaSave:
    begin
      SL.Text := ConsumedData;
      SL.SaveToFile(TestConsumedFilename);
    end;
  end;
  SL.Free;
end;

procedure jcBillingClient.TestUpdateUI;
begin
  WV.LoadFromHtmlString(TestHtml);
end;

function jcBillingClient.TestHtml: string;

  function BgColor: string;
  var i: integer;
  begin
    result := '';
    for i := 0 to PurchaseCount-1 do begin
      if Purchase[i].IsAcknowledgedFalse then begin
        // if there's any purchase that has NOT been
        // acknowledged yet, show yellow background
        result := ' bgcolor="yellow"';
        exit;
      end;
      if Purchase[i].IsAcknowledgedTrue then
        // found an acknowledged purchase, unless there are
        // other unacknowledged ones, show green background
        result := ' bgcolor="lime"';
    end;
  end;

  function ModalPage: string;
  begin
    result := '';
    case Tag of
    11: result := 'PRODUCT CONSUMED';
    12: result := 'CONSUMED PRODUCT DELETED';
    end;
    result :=
      '<html><body bgcolor="#40B0FF"><center><h2>&nbsp;<p>' + result +
      '<p><a href="billing:test=refresh">Continue</a></h2></center></body></html>';
  end;

  var SL: TStringList;

  procedure TableTop(ATItle: string);
  begin
    SL.Add('<p><table cellpadding=10 cellspacing=0 border=1><tr><td>');
    SL.Add('<h3>' + ATitle + '</h3>');
  end;

  procedure TableBtm;
  begin
    SL.Add('</td></tr></table>');
  end;

var i: integer;
begin
  if Tag>10 then begin
    result := ModalPage;
    exit;
  end;

  SL := TStringList.Create;
  SL.Add('<html>');

  SL.Add('<body'+BgColor+'>');

  SL.Add(FormatDateTime('hh:nn:ss', Now));
  SL.Add('Billing Client tester');
  SL.Add('<p>After trying the operations, check the various lists ' +
    'and the logs at the bottom of the page to see what happened.');

  SL.Add('<p><b>Color codes</b>');
  SL.Add('<br>WHITE: No purchases');
  SL.Add('<br>YELLOW: One or more purchases, not yet acknowledged');
  SL.Add('<br>GREEN: One or more acknowledged purchases.');


  SL.Add('<p><a href="billing:test=refresh">Refresh this page</a>');


  SL.Add('<p><b>InappSkus:</b><br> ' + ReplaceStr(InappSkus, ',', '<br>'));
  SL.Add('<p><b>SubsSkus:</b><br> ' + ReplaceStr(SubsSkus, ',', '<br>'));
  SL.Add('<p><b>Consumed:</b> ' + IntToStr(ConsumedCount));

  SL.Add('<br><b>Purchases:</b> ');
  if (fPurchaseHash='') then
    SL.Add('Not yet queried')
  else
    SL.Add(IntToStr(PurchaseCount));

  SL.Add('<br><b>INAPP products:</b> ');
  if (fInappHash='') then begin
    if InappSkus = '' then
      SL.Add('No InappSkus to query')
    else
      SL.Add('Not yet queried')
  end
  else
    SL.Add(IntToStr(InappCount));

  SL.Add('<br><b>SUBS products:</b> ');
  if (fSubsHash='') then begin
    if SubsSkus = '' then
      SL.Add('No SubsSkus to query')
    else
      SL.Add('Not yet queried')
  end else
    SL.Add(IntToStr(SubsCount));

  TableTop('Connect');
  SL.Add('<p><a href="billing:test=connect_aq1">Connect(True)</a>');
  SL.Add('<p>Normally you will call Connect(True) when the app starts, ' +
    'to get all the data initialized, but here, for testing purposes, ' +
    'we let you do it manually by clicking above.');
  TableBtm;

  TableTop('Step-by-step Connect and Query operations.');
  SL.Add('<p>For testing and analysis purposes:');
  SL.Add('<p><a href="billing:test=connect_aq0">Connect(False) no auto-query after connect)</a>');
  SL.Add('<p><a href="billing:test=query_purchases">QueryPurchases</a>');
  SL.Add('<p><a href="billing:test=query_inapp">QueryInappList</a>');
  SL.Add('<p><a href="billing:test=query_subs">QuerySubsList</a>');
  SL.Add('</td></tr></table>');
  TableBtm;

  TableTop('Products overview');

  SL.Add('<b>AutoAcknowledge:</b> ');
  if AutoAcknowledge then begin
    SL.Add('ON [<a href="billing:test=aa0">Turn OFF</a>]');
  end else begin
    SL.Add('OFF [<a href="billing:test=aa1">Turn ON</a>]');
  end;
  SL.Add('<br>Normally AutoAcknowledge should be turned ON, ' +
    'so that all successful Purchases are immediately acknowledged. '+
    'In special cases, and for testing purposes, it can ' +
    'be OFF. Here you must click on "ACKNOWLEDGE THIS" on purchases ' +
    'that still have acknowledged=false');

  SL.Add('<p>ConsumedData file:<br>' + TestConsumedFilename);
  if FileExists(TestConsumedFilename) then
    SL.Add('<br>File exists')
  else
    SL.Add('<br>File not found');

  for i := 0 to InappCount-1 do
    SL.Add(Inapp[i].TestBuyLink);
  for i := 0 to SubsCount-1 do
    SL.Add(Subs[i].TestBuyLink);

  TableBtm;

  ListDump(SL, True);

  {
  SL.Add('<p><a href="billing:test=log">Test log</a>');
  SL.Add('<p><a href="billing:test=event">Test event</a>');
  SL.Add('<p><a href="billing:test=error">Test error</a>');
  }
  SL.Add('<p><a href="billing:test=clear">Clear log</a>');

  LogDump(SL, True, False);

  SL.Add('</body></html>');
  result := SL.text;
  SL.Free;
end;

function jcBillingClient.TestConsumedFilename: string;
begin
  result := gApp.Path.dat;
  if not DirectoryExists(result) then
    ForceDirectories(result);
  result := result + '/consumed.xml';
end;

procedure jcBillingClient.TestOnBillingEvent(Sender: TObject; BE: TBillingEvent);
begin
  TestUpdateUI;
  case BE of
  beConsumedOK:
    begin
      Tag := 11; // trigger "Consumed" message page
      TestUpdateUI;
    end;
  end;
end;

procedure jcBillingClient.OnWvStatus(Sender: TObject; AStatus: TWebViewStatus;
  URL: String; Var CanNavi: Boolean);
begin
  CanNavi := False;
  case AStatus of
  wvOnBefore:
    begin
      DoCmd(URL);
    end;
  wvOnFinish:
    begin
    end;
  wvOnUnknown:
    begin
    end;
  end;
end;

procedure jcBillingClient.TestOnPayload(Sender: TObject;
  Item: TPurchaseItem; out payload: string);
// Event may be beAcknowledge or beConsume
begin
  if payload <> '' then exit;
  // If this is for a Consume, developerPayload was already set
  // during the prior Acknowledge, in which case we choose not to change it.

  if Item=nil then
    payload := 'NIL object'
  else
    payload := Item.Description;
  payload := 'Test payload for ' + payload +
    ' generated at ' +
    FormatDateTime('YYYY-MM-DD hh:nn:ss', Now);
end;

{$endif test_billing}

procedure jcBillingClient.LogDump(SL: TStringList; HTML, RecentOnTop: boolean);
var C, i, j, x1, x2, z: integer; s: string;
begin
  if HTML then
    SL.Add('<p><b>Billing events log</b>')
  else
    SL.Add('BILLING EVENTS');

  C := Logs.Count-1;

  for i := 0 to C do begin
    if RecentOnTop then
      j := C-i
    else
      j := i;
    s := Logs[j];
    if HTML and (s<>'') then begin
      // format and color it a little:
      x1 := pos(' - ',s);
      x2 := length(s)+1;
      for z := x1 + 3 to length(s) do
        if s[z]=' ' then begin
          x2 := z;
          break;
        end;
      insert('</font>', s, x2);
      insert('<font color=red>', s, x1+3);
      insert('</font>', s, x1);
      s := '<br><font color=green>' + s;
    end;
    SL.Add(s);
  end;
  if HTML then
    SL.Add('</p>');
end;

{$ifdef test_billing}
procedure jcBillingClient.ListDump(SL: TStringList; HTML: boolean);
  procedure Dump(L: TList; cap, comment: string);
  var i: integer; s: string; BI: TBillingItem;
  begin
    s := IntToStr(L.Count) + ' ' + Cap;
    if HTML then
      s := '<p><table cellspacing=0 cellpadding=10 border=1><tr><td><h3>' + s + '</h3>';
    SL.Add(s);
    SL.Add(comment);
    for i := 0 to L.Count-1 do begin
      BI := TBillingItem(L[i]);
      s := UpperCase(BI.TypeName)+ ' #' + IntToStr(i+1);
      if HTML then s := '<p><b>' + s + '</b>';
      SL.Add(s);
      BI.Dump(SL, HTML);
      if BI is TConsumedItem then
        SL.Add('<p><a href="billing:test=delete_consumed,'+IntToStr(i)+
          '">DELETE THIS CONSUMED ITEM</a>');
    end;
    if HTML then
      SL.Add('</td></tr></table>');
  end;

begin
  Dump(fConsumedList, 'CONSUMED purchases',
    'When a Purchase is consumed it disappears from GooglePlay, '+
    'but the component maintains an independent list, '+
    'saved to a local file between sessions. ' +
    'Google states that the callback of a successful Consume '+
    'may occasionally fail. Therefore, in order not to depend ' +
    'exclusively on those callbacks, '+
    'the component adds a CONSUMED/PENDING object here' +
    'at the beginning of the Consume operation, and later '+
    'changes the status from PENDING to CONSUMED when the callback arrives. '+
    'This way you have the whole picture, and can decide what to do even in ' +
    'corner cases, e.g. when you have a CONSUMED/PENDING object here, ' +
    'but no longer the corresponding Purchase object in the Purchase list. ' +
    '(The purchase item disappeared after calling Consume, '+
    'which indicates a successful Consume, but we never got the ' +
    'actual callback confirmation that would have changed PENDING to CONSUMED.'+
    'In any case, do a lot of tests, make sure your users get what they pay for! '+
    'And remember, THIS CODE IS PROVIDED "AS IS", FOR FREE, WITH NO GUARANTEES!'+
    '');
  Dump(fPurchaseList, 'PURCHASES ',
    'This is the detailed list of purchased products, supplied by the ' +
    'GooglePlay app. If AutoAcknowledge is OFF, you can click on ' +
    '"ACKNOWLEDGE THIS" to perform the required acknowledgement. ' +
    '(Google automatically refunds purchases that are not acknowledged ' +
    'within a certain time (normally 3 days, but only a few minutes when using the Test products)' +
    '');
  Dump(fInappList, 'INAPP products',
    'This is the detailed list of INAPP products available ' +
    'for sale in this app. This list is generated from the ' +
    'comma-separated list of SKUs that you assign to InappSkus property. ' +
    'After purchase, these products can be consumed, after which the user can buy it again');
  Dump(fSubsList, 'SUBS products',
    'This is the detailed list of Subscription products available ' +
    'for sale in this app. This list is generated from the ' +
    'comma-separated list of SKUs that you assign to SubsSkus property. ' +
    'Subscription products are not consumable.');
end;
{$endif test_billing}

procedure jcBillingClient.Buy(const sku: string);
begin
  if not FInitialized then exit;

  LogEvent(beOperation, 'Buy');

  fInFlow  := 'buy=' + sku;

  jni_proc_t(FjEnv, FjObject, 'Buy', sku);
end;

procedure jcBillingClient.Subscribe(const sku: string; const OldSubsSKU: string);
begin
  if not FInitialized then exit;

  LogEvent(beOperation, 'Subscribe');

  fInFlow  := 'sub=' + sku;

  jni_proc_tt(FjEnv, FjObject, 'Sub', sku, OldSubsSKU);
end;

procedure jcBillingClient.AcknowledgeAll;
var i: integer;
begin
  for i := 0 to PurchaseCount-1 do
    if Purchase[i].IsAcknowledgedFalse then
      Acknowledge(Purchase[i]);
end;

procedure jcBillingClient.Acknowledge(Item: TPurchaseItem);
begin
  Acknowledge(Item.purchaseToken, DeveloperPayload(Item))
end;

procedure jcBillingClient.Acknowledge(const PurchaseToken: string);
begin
  Acknowledge(PurchaseToken, DeveloperPayload(FindPurchase(PurchaseToken)));
end;

procedure jcBillingClient.Acknowledge(const PurchaseToken, Payload: string);
begin
  //ShowMessage('Acknowledge: ' + PurchaseToken + #13#13#10#10 + Payload);
  if not FInitialized then exit;

  LogEvent(beOperation, 'Acknowledge');

  jni_proc_tt(FjEnv, FjObject, 'Acknowledge', PurchaseToken, Payload);
end;

procedure jcBillingClient.Consume(Item: TPurchaseItem; const Payload: string);
begin
  if FInitialized and (Item<>nil) then begin
    AddConsumed(Item, csPending);
    jni_proc_tt(FjEnv, FjObject, 'Consume', Item.PurchaseToken, Payload);
  end;
end;

procedure jcBillingClient.Consume(Item: TPurchaseItem);
begin
  Consume(Item, DeveloperPayload(Item))
end;

procedure jcBillingClient.Consume(const PurchaseToken: string);
begin
  Consume(FindPurchase(PurchaseToken));
end;

function jcBillingClient.ActiveInapp: string;
begin
  if pos('buy=', fInFlow) = 1 then
    result := copy(fInFlow, pos('=', fInFlow) + 1, 100)
  else
    result := '';
end;

function jcBillingClient.ActiveSubs: string;
begin
  if pos('sub=', fInFlow) = 1 then
    result := copy(fInFlow, pos('=', fInFlow) + 1, 100)
  else
    result := '';
end;

function jcBillingClient.ActiveConsume: string;
begin
  if pos('consume=', fInFlow) = 1 then
    result := copy(fInFlow, pos('=', fInFlow) + 1, 100)
  else
    result := '';
end;

procedure jcBillingClient.LoadConsumed();
begin
  if Assigned(fOnConsumedData) then
    fOnConsumedData(Self, cdaLoad);
  Notify(beConsumedLoad);
end;

procedure jcBillingClient.SaveConsumed();
begin
  if Assigned(fOnConsumedData) then
    fOnConsumedData(Self, cdaSave);
  Notify(beConsumedSave);
end;

procedure jcBillingClient.Connect(AutoQuery: boolean);
begin
  if not FInitialized then exit;

  if fConsumedHash = '' then
    LoadConsumed();

  fInFlow  := '';
  fAutoQuery := AutoQuery;

  if AutoQuery then
    LogEvent(beOperation, 'Connect+AutoQuery')
  else
    LogEvent(beOperation, 'Connect');

  jni_proc_t(FjEnv, FjObject,'Connect', Base64PublicKey);
end;

procedure jcBillingClient.DeleteConsumed(Item: TConsumedItem);
begin
  if fConsumedList.IndexOf(Item) >= 0 then
    fConsumedList.Remove(Item);

  Item.Free;
  SaveConsumed();
end;

function jcBillingClient.FindPurchase(PurchaseToken: string): TPurchaseItem;
var i: integer;
begin
  for i := 0 to PurchaseCount-1 do begin
    result := Purchase[i];
    if result.purchaseToken = PurchaseToken then exit;
  end;

  result := nil;
end;

procedure jcBillingClient.QueryPurchases();
begin
  if not FInitialized then exit;

  LogEvent(beOperation, 'QueryPurchases');

  jni_proc(FjEnv, FjObject, 'QueryPurchases');
end;

procedure jcBillingClient.QueryInappList();
begin
  if not FInitialized then exit;

  LogEvent(beOperation, 'QueryInappList');

  if InappSkus='' then begin
    LogEvent(beError, 'InappSkus (comma-separated string of SKUs) is blank.');
    exit;
  end;

  jni_proc_t(FjEnv, FjObject, 'QueryInappList', InappSkus);
end;

procedure jcBillingClient.QuerySubsList();
begin
  if not FInitialized then exit;

  LogEvent(beOperation, 'QuerySubsList');

  if SubsSkus='' then begin
    LogEvent(beError, 'SubsSkus (comma-separated string of SKUs) is blank.');
    exit;
  end;

  jni_proc_t(FjEnv, FjObject, 'QuerySubsList', SubsSkus);
end;

function jcBillingClient.IsSubs(const sku: string): boolean;
begin
  result := FindSubs(sku) <> nil
end;

function jcBillingClient.IsInapp(const sku: string): boolean;
begin
  result := FindInapp(sku) <> nil
end;

procedure jcBillingClient.Init(refApp: jApp);
begin
  if FInitialized  then Exit;

  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!

  FjObject := jcBillingClient_Create(FjEnv, FjThis, Self);
  //DBG := 'Dbg1';
  if FjObject = nil then exit;
  //DBG := 'Dbg2';
  FInitialized:= True;
end;

procedure jcBillingClient.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'jFree');
end;

procedure jcBillingClient.Retry;
begin

end;


end.
