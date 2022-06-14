unit sadmob;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

TAdMobBannerSize = (
   admobSmartBanner,       //0 - screen width x 32|50|90	Smart Banner	Phones and Tablets	SMART_BANNER
   admobBanner,            //1 - 320x50	Banner	Phones and Tablets	BANNER
   admobLargeBanner,       //2 - 320x100	Large Banner	Phones and Tablets	LARGE_BANNER
   admobMediumRectangle,   //3 - 300x250	IAB Medium Rectangle	Phones and Tablets	MEDIUM_RECTANGLE
   admobFullBanner,        //4 - 468x60	IAB Full-Size Banner	Tablets	FULL_BANNER
   admobLeaderBoard,       //5 - 728x90	IAB Leaderboard	Tablets	LEADERBOARD
   admobAdaptive           //6 - Adaptive ad size on the ad view
  );

TAdMobType = (
  adsBanner,
  adsInterstitial,
  adsRewarded
);

TOnAdMobLoaded = procedure(Sender: TObject; admobType: TAdMobType) of Object;
TOnAdMobFailedToLoad = procedure(Sender: TObject; admobType : TAdMobType; errorCode: integer) of Object;
TOnAdMobOpened = procedure(Sender: TObject; admobType: TAdMobType) of Object;
TOnAdMobClosed = procedure(Sender: TObject; admobType: TAdMobType) of Object;
TOnAdMobClicked = procedure(Sender: TObject; admobType: TAdMobType) of Object;
TOnAdMobInitializationComplete = procedure(Sender: TObject) of Object;
TOnAdMobFailedToShow = procedure(Sender: TObject; admobType: TAdMobType; errorCode: integer) of Object;
TOnAdMobRewardedUserEarned = procedure(Sender: TObject) of Object;


{Developed by ADiV for LAMW}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsAdMob = class(jVisualControl)
 private
    FOnAdMobLoaded:          TOnAdMobLoaded;
    FOnAdMobFailedToLoad:    TOnAdMobFailedToLoad;
    FOnAdMobOpened:          TOnAdMobOpened;
    FOnAdMobClosed:          TOnAdMobClosed;
    FOnAdMobClicked:         TOnAdMobClicked;
    FOnAdMobInitializationComplete:  TOnAdMobInitializationComplete;
    FOnAdMobFailedToShow:    TOnAdMobFailedToShow;
    FOnAdMobRewardedUserEarned:      TOnAdMobRewardedUserEarned;

    FAdMobBannerSize:        TAdMobBannerSize;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
    procedure GenEvent_OnAdMobLoaded(Obj: TObject; admobType: integer);
    procedure GenEvent_OnAdMobFailedToLoad(Obj: TObject; admobType : integer; errorCode: integer);
    procedure GenEvent_OnAdMobOpened(Obj: TObject; admobType: integer);
    procedure GenEvent_OnAdMobClosed(Obj: TObject; admobType: integer);
    procedure GenEvent_OnAdMobClicked(Obj: TObject; admobType: integer);
    procedure GenEvent_OnAdMobInitializationComplete(Obj: TObject);
    procedure GenEvent_OnAdMobFailedToShow(Obj: TObject; admobType, errorCode: integer);
    procedure GenEvent_OnAdMobRewardedUserEarned(Obj: TObject);

    procedure SetViewParent(_viewgroup: jObject); override;
    function  GetViewParent(): jObject;  override;
    procedure RemoveFromViewParent(); override;

    function  GetView(): jObject;  override;
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();

    procedure BringToFront();

    //--- AdMob ---//

    procedure AdMobInit();
    procedure AdMobFree();

    function  AdMobGetUUID() : string;

    //--- Banner ---//
    procedure AdMobBannerSetSize(_whBannerSize: TAdMobBannerSize);
    function  AdMobBannerGetSize: TAdMobBannerSize;

    procedure AdMobBannerSetId(_admobid: string);

    procedure AdMobBannerRun();
    procedure AdMobBannerStop();
    procedure AdMobBannerPause();
    procedure AdMobBannerResume();
    procedure AdMobBannerUpdate();
    function  AdMobBannerIsLoading(): boolean;
    function  AdMobBannerGetHeight(): integer;
    procedure AdMobBannerSetAdativeWidth( _aWidth : integer );

    //--- Inter ---//
    procedure AdMobInterSetId( _admobid : string );
    procedure AdMobInterCreateAndLoad();
    function  AdMobInterIsLoading(): boolean;
    function  AdMobInterIsLoaded() : boolean;
    procedure AdMobInterShow();

    //--- Rewarded ---//
    procedure AdMobRewardedSetId( _admobid : string );
    procedure AdMobRewardedCreateAndLoad();
    function  AdMobRewardedIsLoading(): boolean;
    function  AdMobRewardedIsLoaded() : boolean;
    function  AdMobRewardedGetAmount() : integer;
    function  AdMobRewardedGetType() : string;
    procedure AdMobRewardedShow();
    
 published

    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property AdMobBannerSize : TAdMobBannerSize read  AdMobBannerGetSize write AdMobBannerSetSize;

    property OnAdMobLoaded      :   TOnAdMobLoaded read FOnAdMobLoaded write FOnAdMobLoaded;
    property OnAdMobFailedToLoad:   TOnAdMobFailedToLoad read FOnAdMobFailedToLoad write FOnAdMobFailedToLoad;
    property OnAdMobOpened      :   TOnAdMobOpened read FOnAdMobOpened write FOnAdMobOpened;
    property OnAdMobClosed      :   TOnAdMobClosed read FOnAdMobClosed write FOnAdMobClosed;
    property OnAdMobClicked      :   TOnAdMobClicked read FOnAdMobClicked write FOnAdMobClicked;
    property OnAdMobInitializationComplete :   TOnAdMobInitializationComplete read FOnAdMobInitializationComplete write FOnAdMobInitializationComplete;
    property OnAdMobFailedToShow   :   TOnAdMobFailedToShow read FOnAdMobFailedToShow write FOnAdMobFailedToShow;
    property OnAdMobRewardedUserEarned     :   TOnAdMobRewardedUserEarned read FOnAdMobRewardedUserEarned write FOnAdMobRewardedUserEarned;

end;

function jsAdMob_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;

implementation

{---------  jFrameLayout  --------------}

constructor jsAdMob.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 0;
  FMarginTop    := 0;
  FMarginBottom := 0;
  FMarginRight  := 0;
  FHeight       := 96; //??
  FWidth        := 192; //??
  FLParamWidth  := lpWrapContent;  //lpWrapContent
  FLParamHeight := lpWrapContent;
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FAdMobBannerSize:= admobSmartBanner;
end;

destructor jsAdMob.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jni_free(gApp.jni.jEnv, FjObject);
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jsAdMob.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject := jsAdMob_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);

   if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent);

   FjPRLayoutHome:= FjPRLayout;

   SetViewParent( FjPRLayout );

   AdMobBannerSetSize( FAdMobBannerSize );
   
   View_SetId(gApp.jni.jEnv, FjObject, FId);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
                    FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                    sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, FMarginLeft + FMarginRight ),
                    sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, FMarginTop + FMarginBottom ));

  for rToA := raAbove to raAlignRight do
    if rToA in FPositionRelativeToAnchor then
      AddLParamsAnchorRule( GetPositionRelativeToAnchor(rToA) );

  for rToP := rpBottom to rpCenterVertical do
    if rToP in FPositionRelativeToParent then
      AddLParamsParentRule( GetPositionRelativeToParent(rToP) );

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  SetLayoutAll( Self.AnchorId );

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jsAdMob.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsAdMob.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jsAdMob.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jsAdMob.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsAdMob.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jsAdMob.GenEvent_OnAdMobLoaded(Obj: TObject; admobType: integer);
begin
  if Assigned(FOnAdMobLoaded) then FOnAdMobLoaded(Obj, TAdMobType(admobType));
end;

procedure jsAdMob.GenEvent_OnAdMobInitializationComplete(Obj: TObject);
begin
  if Assigned(FOnAdMobInitializationComplete) then FOnAdMobInitializationComplete(Obj);
end;

procedure jsAdMob.GenEvent_OnAdMobClicked(Obj: TObject; admobType: integer);
begin
  if Assigned(FOnAdMobClicked) then FOnAdMobClicked(Obj, TAdMobType(admobType));
end;

procedure jsAdMob.GenEvent_OnAdMobFailedToLoad(Obj: TObject; admobType: integer; errorCode: integer);
begin
  if Assigned(FOnAdMobFailedToLoad) then FOnAdMobFailedToLoad(Obj, TAdMobType(admobType), errorCode);
end;

procedure jsAdMob.GenEvent_OnAdMobOpened(Obj: TObject; admobType: integer);
begin
  if Assigned(FOnAdMobOpened) then FOnAdMobOpened(Obj, TAdMobType(admobType));
end;

procedure jsAdMob.GenEvent_OnAdMobClosed(Obj: TObject; admobType: integer);
begin
  if Assigned(FOnAdMobClosed) then FOnAdMobClosed(Obj, TAdMobType(admobType));
end;

procedure jsAdMob.GenEvent_OnAdMobFailedToShow(Obj: TObject; admobType, errorCode: integer);
begin
  if Assigned(FOnAdMobFailedToShow) then FOnAdMobFailedToShow(Obj, TAdMobType(admobType), errorCode);
end;

procedure jsAdMob.GenEvent_OnAdMobRewardedUserEarned(Obj: TObject);
begin
  if Assigned(FOnAdMobRewardedUserEarned) then OnAdMobRewardedUserEarned(Obj);
end;

procedure jsAdMob.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jsAdMob.GetViewParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jsAdMob.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

procedure jsAdMob.AdMobBannerSetSize(_whBannerSize: TAdMobBannerSize);
begin
  FAdMobBannerSize:= _whBannerSize;
  if FjObject <> nil then
   jni_proc_i(gApp.jni.jEnv, FjObject, 'AdMobBannerSetSize', Ord(_whBannerSize));
end;

function jsAdMob.AdMobBannerGetSize: TAdMobBannerSize;
begin
  Result := FAdMobBannerSize;
  if FInitialized then
    Result := TAdMobBannerSize(jni_func_out_i(gApp.jni.jEnv, FjObject, 'AdMobBannerGetSize'))
end;

procedure jsAdMob.AdMobBannerSetId(_admobid: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(gApp.jni.jEnv, FjObject, 'AdMobBannerSetId', _admobid);
end;

procedure jsAdMob.AdMobBannerSetAdativeWidth( _aWidth : integer );
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'AdMobBannerSetAdativeWidth', _aWidth);
end;

function jsAdMob.AdMobBannerIsLoading(): boolean;
begin
 result := false;

 //in designing component state: result value here...
 if FInitialized then
   Result:= jni_func_out_z(gApp.jni.jEnv, FjObject, 'AdMobBannerIsLoading');
end;

function jsAdMob.AdMobBannerGetHeight(): integer;
begin
 Result := 0;

 //in designing component state: result value here...
 if FInitialized then
   Result:= jni_func_out_i(gApp.jni.jEnv, FjObject, 'AdMobBannerGetHeight');
end;

procedure jsAdMob.AdMobInit();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'AdMobInit');
end;

function jsAdMob.AdMobGetUUID() : string;
begin
 result := '';

 //in designing component state: set value here...
 if FInitialized then
  result := jni_func_out_t(gApp.jni.jEnv, FjObject, 'AdMobGetUUID');
end;

procedure jsAdMob.AdMobFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'AdMobFree');
end;

procedure jsAdMob.AdMobBannerStop();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'AdMobBannerStop');
end;

procedure jsAdMob.AdMobBannerPause();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'AdMobBannerPause');
end;

procedure jsAdMob.AdMobBannerResume();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'AdMobBannerResume');
end;

procedure jsAdMob.AdMobBannerRun();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'AdMobBannerRun');
end;

procedure jsAdMob.AdMobBannerUpdate();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'AdMobBannerUpdate');
end;

function jsAdMob.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jsAdMob.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsAdMob.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsAdMob.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsAdMob.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jsAdMob.BringToFront;
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     View_BringToFront(gApp.jni.jEnv, FjObject);
end;

procedure jsAdMob.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
         AddLParamsParentRule(GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
        AddLParamsAnchorRule(GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsAdMob.AdMobInterCreateAndLoad();
begin
 //in designing component state: set value here...
 if FjObject <> nil then
  jni_proc(gApp.jni.jEnv, FjObject, 'AdMobInterCreateAndLoad');
end;

procedure jsAdMob.AdMobInterSetId( _admobid : string );
begin
 //in designing component state: set value here...
 if FjObject <> nil then
  jni_proc_t(gApp.jni.jEnv, FjObject, 'AdMobInterSetId', _admobid);
end;

function  jsAdMob.AdMobInterIsLoading() : boolean;
begin
 result := false;
 //in designing component state: set value here...
 if FjObject <> nil then
  result := jni_func_out_z(gApp.jni.jEnv, FjObject, 'AdMobInterIsLoading');
end;

function jsAdMob.AdMobInterIsLoaded( ) : boolean;
begin
 result := false;
 //in designing component state: set value here...
 if FjObject <> nil then
  result := jni_func_out_z(gApp.jni.jEnv, FjObject, 'AdMobInterIsLoaded');
end;

procedure jsAdMob.AdMobInterShow( );
begin
 //in designing component state: set value here...
 if FjObject <> nil then
  jni_proc(gApp.jni.jEnv, FjObject, 'AdMobInterShow');
end;

procedure jsAdMob.AdMobRewardedSetId( _admobid : string );
begin
 //in designing component state: set value here...
 if FjObject <> nil then
  jni_proc_t(gApp.jni.jEnv, FjObject, 'AdMobRewardedSetId', _admobid);
end;

procedure jsAdMob.AdMobRewardedCreateAndLoad();
begin
 //in designing component state: set value here...
 if FjObject <> nil then
  jni_proc(gApp.jni.jEnv, FjObject, 'AdMobRewardedLoad');
end;

function  jsAdMob.AdMobRewardedIsLoaded() : boolean;
begin
 result := false;
 //in designing component state: set value here...
 if FjObject <> nil then
  result := jni_func_out_z(gApp.jni.jEnv, FjObject, 'AdMobRewardedIsLoaded');
end;

function  jsAdMob.AdMobRewardedIsLoading() : boolean;
begin
 result := false;
 //in designing component state: set value here...
 if FjObject <> nil then
  result := jni_func_out_z(gApp.jni.jEnv, FjObject, 'AdMobRewardedIsLoading');
end;

function  jsAdMob.AdMobRewardedGetAmount() : integer;
begin
 result := -1;
 //in designing component state: set value here...
 if FjObject <> nil then
  result := jni_func_out_i(gApp.jni.jEnv, FjObject, 'AdMobRewardedGetAmount');
end;


function  jsAdMob.AdMobRewardedGetType() : string;
begin
 result := '';
 //in designing component state: set value here...
 if FjObject <> nil then
  result := jni_func_out_t(gApp.jni.jEnv, FjObject, 'AdMobRewardedGetType');
end;

procedure jsAdMob.AdMobRewardedShow();
begin
 //in designing component state: set value here...
 if FjObject <> nil then
  jni_proc(gApp.jni.jEnv, FjObject, 'AdMobRewardedShow');
end;

{-------- jsAdMob_JNI_Bridge ----------}

function jsAdMob_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;  
label
  _exceptionOcurred;
begin
  Result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jsAdMob_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);   

  _exceptionOcurred: if jni_ExceptionOccurred(env) then Result := nil;
end;

end.
