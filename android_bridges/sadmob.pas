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
   admobLeaderBoard        //5 - 728x90	IAB Leaderboard	Tablets	LEADERBOARD
  );

TOnAdMobLoaded = procedure(Sender: TObject) of Object;
TOnAdMobFailedToLoad = procedure(Sender: TObject;  errorCode: integer) of Object;
TOnAdMobOpened = procedure(Sender: TObject) of Object;
TOnAdMobClosed = procedure(Sender: TObject) of Object;
TOnAdMobLeftApplication = procedure(Sender: TObject) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [12/13/2017 17:22:00]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsAdMob = class(jVisualControl)
 private
    FOnAdMobLoaded:          TOnAdMobLoaded;
    FOnAdMobFailedToLoad:    TOnAdMobFailedToLoad;
    FOnAdMobOpened:          TOnAdMobOpened;
    FOnAdMobClosed:          TOnAdMobClosed;
    FOnAdMobLeftApplication: TOnAdMobLeftApplication;
    FAdMobBannerSize:        TAdMobBannerSize;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
    procedure GenEvent_OnAdMobLoaded(Obj: TObject);
    procedure GenEvent_OnAdMobFailedToLoad(Obj: TObject; errorCode: integer);
    procedure GenEvent_OnAdMobOpened(Obj: TObject);
    procedure GenEvent_OnAdMobClosed(Obj: TObject);
    procedure GenEvent_OnAdMobLeftApplication(Obj: TObject);

    procedure SetViewParent(_viewgroup: jObject); override;
    function GetViewParent(): jObject;  override;
    procedure RemoveFromViewParent(); override;

    //LMB
    procedure AdMobSetBannerSize(_whBannerSize: TAdMobBannerSize);
    function  AdMobGetBannerSize: TAdMobBannerSize;

    procedure AdMobSetId(_admobid: string);
    function  AdMobGetId(): string;
    procedure AdMobInit();
    procedure AdMobFree();
    procedure AdMobRun();
    procedure AdMobStop();
    procedure AdMobUpdate();
    function  AdMobIsLoading(): boolean;

    function GetView(): jObject;  override;
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    
 published

    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property AdMobBannerSize : TAdMobBannerSize read  AdMobGetBannerSize write AdMobSetBannerSize;

    property OnAdMobLoaded      :   TOnAdMobLoaded read FOnAdMobLoaded write FOnAdMobLoaded;
    property OnAdMobFailedToLoad:   TOnAdMobFailedToLoad read FOnAdMobFailedToLoad write FOnAdMobFailedToLoad;
    property OnAdMobOpened      :   TOnAdMobOpened read FOnAdMobOpened write FOnAdMobOpened;
    property OnAdMobClosed      :   TOnAdMobClosed read FOnAdMobClosed write FOnAdMobClosed;
    property OnAdMobLeftApplication  :   TOnAdMobLeftApplication read FOnAdMobLeftApplication write FOnAdMobLeftApplication;


end;

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
       jni_proc(FjEnv, FjObject, 'jFree');
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jsAdMob.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject := jni_create(FjEnv, FjThis, Self, 'jsAdMob_jCreate'); if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   SetViewParent( FjPRLayout );

   AdMobSetBannerSize( FAdMobBannerSize );
   
   jni_proc_i(FjEnv, FjObject, 'setId', FId);
  end;

  jni_proc_iiiiii(FjEnv, FjObject, 'SetLeftTopRightBottomWidthHeight',
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
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jsAdMob.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsAdMob.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsAdMob.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jsAdMob.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsAdMob.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jsAdMob.GenEvent_OnAdMobLoaded(Obj: TObject);
begin
  if Assigned(FOnAdMobLoaded) then FOnAdMobLoaded(Obj);
end;

procedure jsAdMob.GenEvent_OnAdMobFailedToLoad(Obj: TObject; errorCode: integer);
begin
  if Assigned(FOnAdMobFailedToLoad) then FOnAdMobFailedToLoad(Obj, errorCode);
end;

procedure jsAdMob.GenEvent_OnAdMobOpened(Obj: TObject);
begin
  if Assigned(FOnAdMobOpened) then FOnAdMobOpened(Obj);
end;

procedure jsAdMob.GenEvent_OnAdMobClosed(Obj: TObject);
begin
  if Assigned(FOnAdMobClosed) then FOnAdMobClosed(Obj);
end;

procedure jsAdMob.GenEvent_OnAdMobLeftApplication(Obj: TObject);
begin
  if Assigned(FOnAdMobLeftApplication) then FOnAdMobLeftApplication(Obj);
end;

procedure jsAdMob.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_vig(FjEnv, FjObject, 'SetViewParent', _viewgroup);
end;

function jsAdMob.GetViewParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_vig(FjEnv, FjObject, 'GetParent');
end;

procedure jsAdMob.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'RemoveFromViewParent');
end;

procedure jsAdMob.AdMobSetBannerSize(_whBannerSize: TAdMobBannerSize);
begin
  FAdMobBannerSize:= _whBannerSize;
  if FjObject <> nil then
   jni_proc_i(FjEnv, FjObject, 'AdMobSetBannerSize', Ord(_whBannerSize));
end;

function jsAdMob.AdMobGetBannerSize: TAdMobBannerSize;
begin
  Result := FAdMobBannerSize;
  if FInitialized then
    Result := TAdMobBannerSize(jni_func_out_i(FjEnv, FjObject, 'AdMobGetBannerSize'))
end;

procedure jsAdMob.AdMobSetId(_admobid: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'AdMobSetId', _admobid);
end;

function jsAdMob.AdMobIsLoading(): boolean;
begin
 //in designing component state: result value here...
 if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'AdMobIsLoading');
end;

function jsAdMob.AdMobGetId(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_t(FjEnv, FjObject, 'AdMobGetId');
end;

procedure jsAdMob.AdMobInit();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'AdMobInit');
end;

procedure jsAdMob.AdMobFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'AdMobFree');
end;

procedure jsAdMob.AdMobStop();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'AdMobStop');
end;

procedure jsAdMob.AdMobRun();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'AdMobRun');
end;

procedure jsAdMob.AdMobUpdate();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'AdMobUpdate');
end;

function jsAdMob.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_viw(FjEnv, FjObject, 'GetView');
end;

procedure jsAdMob.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_iiiiii(FjEnv, FjObject, 'SetLeftTopRightBottomWidthHeight', _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsAdMob.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'AddLParamsAnchorRule', _rule);
end;

procedure jsAdMob.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'AddLParamsParentRule', _rule);
end;

procedure jsAdMob.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FjObject <> nil then
     jni_proc_i(FjEnv, FjObject, 'SetLayoutAll', _idAnchor);
end;

procedure jsAdMob.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jni_proc(FjEnv, FjObject, 'ClearLayoutAll');

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
         self.AddLParamsParentRule(GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
        self.AddLParamsAnchorRule(GetPositionRelativeToAnchor(rToA));
  end;
end;


end.
