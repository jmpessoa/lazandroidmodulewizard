unit stoolbar;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/15/2017 20:00:41]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsToolbar = class(jVisualControl)
 private

    FNavigationIconIdentifier: string;
    FLogoIcon:string;
    FAsActionBar: boolean;
    FFitsSystemWindows: boolean;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
    procedure TryNewParent(refApp: jApp);
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(_asActionBar: boolean): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent(); override;
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    function GetWidth(): integer; override;
    function GetHeight(): integer; override;

    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);
    procedure SetTitle(_title: string);
    procedure SetNavigationIcon(_imageIdentifier: string);
    procedure SetLogoIcon(_imageIdentifier: string);
    //procedure SetAsActionBar(_value: boolean);
    procedure SetSubtitle(_subtitle: string);
    procedure SetHomeButtonEnabled(_value: boolean);
    procedure SetDisplayHomeAsUpEnabled(_value: boolean);
    procedure SetDisplayUseLogoEnabled(_value: boolean);
    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetTitleTextColor(_color: TARGBColorBridge);
    //procedure SetHeightDP(_heightDP: integer);

    procedure SetScrollFlag(_collapsingScrollFlag: TCollapsingScrollflag);
    procedure SetCollapseMode(_collapseMode: TCollapsingMode);
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetTheme(_theme: TAppTheme);
    procedure SetSubtitleTextColor(_color: TARGBColorBridge);
    procedure SetBackgroundToPrimaryColor();
    function GetPrimaryColor(): integer;
    function GetSuggestedMinimumHeight(): integer;
    procedure SetSuggestedMinimumHeight();
    procedure SetMinimumHeight(_value: integer);
    procedure SetHeightByDisplayMetricsDensity(_value: integer);

 published
    //property Title: string read FTitle write SetTitle;
    property Text: string read FText write SetTitle;
    property FontColor : TARGBColorBridge  read FFontColor write SetTitleTextColor;
    property NavigationIconIdentifier: string read FNavigationIconIdentifier write SetNavigationIcon;
    property LogoIconIdentifier:string read FLogoIcon write SetLogoIcon;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property AsActionBar: boolean read FAsActionBar write FAsActionBar;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FitsSystemWindows: boolean read FFitsSystemWindows write SetFitsSystemWindows;
    property OnClickNavigationIcon: TOnNotify read FOnClick write FOnClick;

end;

function jsToolbar_jCreate(env: PJNIEnv;_Self: int64; _asActionBar: boolean;  this: jObject): jObject;
procedure jsToolbar_jFree(env: PJNIEnv; _jstoolbar: JObject);
procedure jsToolbar_SetViewParent(env: PJNIEnv; _jstoolbar: JObject; _viewgroup: jObject);
function jsToolbar_GetParent(env: PJNIEnv; _jstoolbar: JObject): jObject;
procedure jsToolbar_RemoveFromViewParent(env: PJNIEnv; _jstoolbar: JObject);
function jsToolbar_GetView(env: PJNIEnv; _jstoolbar: JObject): jObject;
procedure jsToolbar_SetLParamWidth(env: PJNIEnv; _jstoolbar: JObject; _w: integer);
procedure jsToolbar_SetLParamHeight(env: PJNIEnv; _jstoolbar: JObject; _h: integer);
function jsToolbar_GetLParamWidth(env: PJNIEnv; _jstoolbar: JObject): integer;
function jsToolbar_GetLParamHeight(env: PJNIEnv; _jstoolbar: JObject): integer;
procedure jsToolbar_SetLWeight(env: PJNIEnv; _jstoolbar: JObject; _w: single);
procedure jsToolbar_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jstoolbar: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsToolbar_AddLParamsAnchorRule(env: PJNIEnv; _jstoolbar: JObject; _rule: integer);
procedure jsToolbar_AddLParamsParentRule(env: PJNIEnv; _jstoolbar: JObject; _rule: integer);
procedure jsToolbar_SetLayoutAll(env: PJNIEnv; _jstoolbar: JObject; _idAnchor: integer);
procedure jsToolbar_ClearLayoutAll(env: PJNIEnv; _jstoolbar: JObject);
procedure jsToolbar_SetId(env: PJNIEnv; _jstoolbar: JObject; _id: integer);
procedure jsToolbar_SetTitle(env: PJNIEnv; _jstoolbar: JObject; _title: string);
procedure jsToolbar_SetNavigationIcon(env: PJNIEnv; _jstoolbar: JObject; _imageIdentifier: string);
procedure jsToolbar_SetLogo(env: PJNIEnv; _jstoolbar: JObject; _imageIdentifier: string);
//procedure jsToolbar_SetAsActionBar(env: PJNIEnv; _jstoolbar: JObject; _value: boolean);
procedure jsToolbar_SetSubtitle(env: PJNIEnv; _jstoolbar: JObject; _subtitle: string);
procedure jsToolbar_SetHomeButtonEnabled(env: PJNIEnv; _jstoolbar: JObject; _value: boolean);
procedure jsToolbar_SetDisplayHomeAsUpEnabled(env: PJNIEnv; _jstoolbar: JObject; _value: boolean);
procedure jsToolbar_SetDisplayUseLogoEnabled(env: PJNIEnv; _jstoolbar: JObject; _value: boolean);
procedure jsToolbar_SetGravityInParent(env: PJNIEnv; _jstoolbar: JObject; _value: integer);
procedure jsToolbar_SetTitleTextColor(env: PJNIEnv; _jstoolbar: JObject; _color: integer);
//procedure jsToolbar_SetHeightDP(env: PJNIEnv; _jstoolbar: JObject; _heightDP: integer);

procedure jsToolbar_SetScrollFlag(env: PJNIEnv; _jstoolbar: JObject; _collapsingScrollFlag: integer);
procedure jsToolbar_SetCollapseMode(env: PJNIEnv; _jstoolbar: JObject; _collapseMode: integer);
procedure jsToolbar_SetFitsSystemWindows(env: PJNIEnv; _jstoolbar: JObject; _value: boolean);
procedure jsToolbar_SetTheme(env: PJNIEnv; _jstoolbar: JObject; _theme: integer);
procedure jsToolbar_SetSubtitleTextColor(env: PJNIEnv; _jstoolbar: JObject; _color: integer);
procedure jsToolbar_SetBackgroundToPrimaryColor(env: PJNIEnv; _jstoolbar: JObject);
function jsToolbar_GetPrimaryColor(env: PJNIEnv; _jstoolbar: JObject): integer;
function jsToolbar_GetSuggestedMinimumHeight(env: PJNIEnv; _jstoolbar: JObject): integer;
procedure jsToolbar_SetSuggestedMinimumHeight(env: PJNIEnv; _jstoolbar: JObject);
procedure jsToolbar_SetMinimumHeight(env: PJNIEnv; _jstoolbar: JObject; _value: integer);
procedure jsToolbar_SetHeightByDisplayMetricsDensity(env: PJNIEnv; _jstoolbar: JObject; _value: integer);


implementation

uses
  customdialog, viewflipper, toolbar, scoordinatorlayout, linearlayout,
  sdrawerlayout, scollapsingtoolbarlayout, scardview, sappbarlayout,
  stablayout, snestedscrollview, sviewpager, framelayout;

{---------  jsToolbar  --------------}

constructor jsToolbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 0;
  FMarginTop    := 0;
  FMarginBottom := 0;
  FMarginRight  := 0;
  FHeight       := 40; //??
  FWidth        := 100; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;

  FText:= '';
  FNavigationIconIdentifier:= '';
  FLogoIcon:= '';
  FColor:= colbrDefault;  //default background color compatible with "color.xml" primary
  FAsActionBar:= True;

//your code here....
end;

destructor jsToolbar.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jFree();
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jsToolbar.TryNewParent(refApp: jApp);
begin
  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end else
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
  end else
  if FParent is jHorizontalScrollView then
  begin
    jHorizontalScrollView(FParent).Init(refApp);
    FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
  end  else
  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end else
  if FParent is jViewFlipper then
  begin
    jViewFlipper(FParent).Init(refApp);
    FjPRLayout:= jViewFlipper(FParent).View;
  end else
  if FParent is jToolbar then
  begin
    jToolbar(FParent).Init(refApp);
    FjPRLayout:= jToolbar(FParent).View;
  end  else
  if FParent is jsToolbar then
  begin
    jsToolbar(FParent).Init(refApp);
    FjPRLayout:= jsToolbar(FParent).View;
  end  else
  if FParent is jsCoordinatorLayout then
  begin
    jsCoordinatorLayout(FParent).Init(refApp);
    FjPRLayout:= jsCoordinatorLayout(FParent).View;
  end else
  if FParent is jFrameLayout then
  begin
    jFrameLayout(FParent).Init(refApp);
    FjPRLayout:= jFrameLayout(FParent).View;
  end else
  if FParent is jLinearLayout then
  begin
    jLinearLayout(FParent).Init(refApp);
    FjPRLayout:= jLinearLayout(FParent).View;
  end else
  if FParent is jsDrawerLayout then
  begin
    jsDrawerLayout(FParent).Init(refApp);
    FjPRLayout:= jsDrawerLayout(FParent).View;
  end  else
  if FParent is jsCardView then
  begin
      jsCardView(FParent).Init(refApp);
      FjPRLayout:= jsCardView(FParent).View;
  end else
  if FParent is jsAppBarLayout then
  begin
      jsAppBarLayout(FParent).Init(refApp);
      FjPRLayout:= jsAppBarLayout(FParent).View;
  end else
  if FParent is jsTabLayout then
  begin
      jsTabLayout(FParent).Init(refApp);
      FjPRLayout:= jsTabLayout(FParent).View;
  end else
  if FParent is jsCollapsingToolbarLayout then
  begin
      jsCollapsingToolbarLayout(FParent).Init(refApp);
      FjPRLayout:= jsCollapsingToolbarLayout(FParent).View;
  end else
  if FParent is jsNestedScrollView then
  begin
      jsNestedScrollView(FParent).Init(refApp);
      FjPRLayout:= jsNestedScrollView(FParent).View;
  end else
  if FParent is jsViewPager then
  begin
      jsViewPager(FParent).Init(refApp);
      FjPRLayout:= jsViewPager(FParent).View;
  end;
end;

procedure jsToolbar.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(FAsActionBar); //jSelf !
  FInitialized:= True;

  if FParent <> nil then
  begin
    TryNewParent(refApp);
  end;

  FjPRLayoutHome:= FjPRLayout;

  if FGravityInParent <> lgNone then
    jsToolbar_SetGravityInParent(FjEnv, FjObject, Ord(FGravityInParent) );

  jsToolbar_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsToolbar_SetId(FjEnv, FjObject, Self.Id);
  jsToolbar_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        GetLayoutParams(gApp, FLParamWidth, sdW),
                        GetLayoutParams(gApp, FLParamHeight, sdH));

  if FParent is jPanel then
  begin
    Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsToolbar_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsToolbar_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsToolbar_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FNavigationIconIdentifier <> '' then
     jsToolbar_SetNavigationIcon(FjEnv, FjObject, FNavigationIconIdentifier);

  if  FText <> '' then
    jsToolbar_SetTitle(FjEnv, FjObject, FText);

  if FLogoIcon <> '' then
    jsToolbar_SetLogo(FjEnv, FjObject, FLogoIcon);

  if FFontColor <> colbrDefault then
       jsToolbar_SetTitleTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));

  if FFitsSystemWindows  then
     jsToolbar_SetFitsSystemWindows(FjEnv, FjObject, FFitsSystemWindows);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsToolbar.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsToolbar.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsToolbar.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jsToolbar_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsToolbar_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsToolbar_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsToolbar.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jsToolbar_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsToolbar_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsToolbar_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsToolbar.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsToolbar_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsToolbar.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jsToolbar.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jsToolbar_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jsToolbar_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jsToolbar_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jsToolbar.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsToolbar.jCreate(_asActionBar: boolean): jObject;
begin
   Result:= jsToolbar_jCreate(FjEnv,int64(Self),_asActionBar,FjThis);
end;

procedure jsToolbar.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_jFree(FjEnv, FjObject);
end;

procedure jsToolbar.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsToolbar.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsToolbar_GetParent(FjEnv, FjObject);
end;

procedure jsToolbar.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsToolbar.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsToolbar_GetView(FjEnv, FjObject);
end;

procedure jsToolbar.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsToolbar.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsToolbar.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  Result:= jsToolbar_getLParamWidth(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetWidthOfParent(FParent);
end;

function jsToolbar.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  Result:= jsToolbar_getLParamHeight(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetHeightOfParent(FParent);
end;

procedure jsToolbar.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsToolbar.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsToolbar.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsToolbar.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsToolbar.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsToolbar.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jsToolbar.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetId(FjEnv, FjObject, _id);
end;

procedure jsToolbar.SetTitle(_title: string);
begin
  //in designing component state: set value here...
  FText:= _title;
  if FInitialized then
     jsToolbar_SetTitle(FjEnv, FjObject, _title);
end;

procedure jsToolbar.SetNavigationIcon(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  FNavigationIconIdentifier:= _imageIdentifier;
  if FInitialized then
     jsToolbar_SetNavigationIcon(FjEnv, FjObject, _imageIdentifier);
end;

procedure jsToolbar.SetLogoIcon(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  FLogoIcon:= _imageIdentifier;
  if FInitialized then
     jsToolbar_SetLogo(FjEnv, FjObject, _imageIdentifier);
end;

{
procedure jsToolbar.SetAsActionBar(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetAsActionBar(FjEnv, FjObject, _value);
end;
}

procedure jsToolbar.SetSubtitle(_subtitle: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetSubtitle(FjEnv, FjObject, _subtitle);
end;

procedure jsToolbar.SetHomeButtonEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetHomeButtonEnabled(FjEnv, FjObject, _value);
end;

procedure jsToolbar.SetDisplayHomeAsUpEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetDisplayHomeAsUpEnabled(FjEnv, FjObject, _value);
end;

procedure jsToolbar.SetDisplayUseLogoEnabled(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetDisplayUseLogoEnabled(FjEnv, FjObject, _value);
end;

procedure jsToolbar.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _value;
  if FInitialized then
     jsToolbar_SetGravityInParent(FjEnv, FjObject, Ord(_value));
end;

procedure jsToolbar.SetTitleTextColor(_color: TARGBColorBridge);
begin
   FFontColor:= _color;
   if FInitialized then
       jsToolbar_SetTitleTextColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsToolbar.SetScrollFlag(_collapsingScrollFlag: TCollapsingScrollflag);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetScrollFlag(FjEnv, FjObject, Ord(_collapsingScrollFlag));
end;

procedure jsToolbar.SetCollapseMode(_collapseMode: TCollapsingMode);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetCollapseMode(FjEnv, FjObject, Ord(_collapseMode) );
end;

{
procedure jsToolbar.SetHeightDP(_heightDP: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetHeightDP(FjEnv, FjObject, _heightDP);
end;
}

procedure jsToolbar.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsToolbar_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

procedure jsToolbar.SetTheme(_theme: TAppTheme);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetTheme(FjEnv, FjObject, Ord(_theme));
end;

procedure jsToolbar.SetSubtitleTextColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetSubtitleTextColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsToolbar.SetBackgroundToPrimaryColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetBackgroundToPrimaryColor(FjEnv, FjObject);
end;


function jsToolbar.GetPrimaryColor(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsToolbar_GetPrimaryColor(FjEnv, FjObject);
end;

function jsToolbar.GetSuggestedMinimumHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsToolbar_GetSuggestedMinimumHeight(FjEnv, FjObject);
end;

procedure jsToolbar.SetSuggestedMinimumHeight();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetSuggestedMinimumHeight(FjEnv, FjObject);
end;

procedure jsToolbar.SetMinimumHeight(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetMinimumHeight(FjEnv, FjObject, _value);
end;

procedure jsToolbar.SetHeightByDisplayMetricsDensity(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsToolbar_SetHeightByDisplayMetricsDensity(FjEnv, FjObject, _value);
end;

{-------- jsToolbar_JNI_Bridge ----------}

function jsToolbar_jCreate(env: PJNIEnv;_Self: int64; _asActionBar: boolean;  this: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].z:= JBool(_asActionBar);
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsToolbar_jCreate', '(JZ)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jsToolbar_jCreate(long _Self) {
  return (java.lang.Object)(new jsToolbar(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jsToolbar_jFree(env: PJNIEnv; _jstoolbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetViewParent(env: PJNIEnv; _jstoolbar: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsToolbar_GetParent(env: PJNIEnv; _jstoolbar: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_RemoveFromViewParent(env: PJNIEnv; _jstoolbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsToolbar_GetView(env: PJNIEnv; _jstoolbar: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetLParamWidth(env: PJNIEnv; _jstoolbar: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetLParamHeight(env: PJNIEnv; _jstoolbar: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsToolbar_GetLParamWidth(env: PJNIEnv; _jstoolbar: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsToolbar_GetLParamHeight(env: PJNIEnv; _jstoolbar: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsToolbar_SetLWeight(env: PJNIEnv; _jstoolbar: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jstoolbar: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _left;
  jParams[1].i:= _top;
  jParams[2].i:= _right;
  jParams[3].i:= _bottom;
  jParams[4].i:= _w;
  jParams[5].i:= _h;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_AddLParamsAnchorRule(env: PJNIEnv; _jstoolbar: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_AddLParamsParentRule(env: PJNIEnv; _jstoolbar: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetLayoutAll(env: PJNIEnv; _jstoolbar: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_ClearLayoutAll(env: PJNIEnv; _jstoolbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetId(env: PJNIEnv; _jstoolbar: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetTitle(env: PJNIEnv; _jstoolbar: JObject; _title: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitle', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetNavigationIcon(env: PJNIEnv; _jstoolbar: JObject; _imageIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetNavigationIcon', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetLogo(env: PJNIEnv; _jstoolbar: JObject; _imageIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLogo', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

{
procedure jsToolbar_SetAsActionBar(env: PJNIEnv; _jstoolbar: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAsActionBar', '(Z)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;
}

procedure jsToolbar_SetSubtitle(env: PJNIEnv; _jstoolbar: JObject; _subtitle: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_subtitle));
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSubtitle', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetHomeButtonEnabled(env: PJNIEnv; _jstoolbar: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHomeButtonEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetDisplayHomeAsUpEnabled(env: PJNIEnv; _jstoolbar: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDisplayHomeAsUpEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetDisplayUseLogoEnabled(env: PJNIEnv; _jstoolbar: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDisplayUseLogoEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsToolbar_SetGravityInParent(env: PJNIEnv; _jstoolbar: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsToolbar_SetTitleTextColor(env: PJNIEnv; _jstoolbar: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitleTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsToolbar_SetScrollFlag(env: PJNIEnv; _jstoolbar: JObject; _collapsingScrollFlag: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _collapsingScrollFlag;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScrollFlag', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsToolbar_SetCollapseMode(env: PJNIEnv; _jstoolbar: JObject; _collapseMode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _collapseMode;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCollapseMode', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

{
procedure jsToolbar_SetHeightDP(env: PJNIEnv; _jstoolbar: JObject; _heightDP: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _heightDP;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHeightDP', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;
}

procedure jsToolbar_SetFitsSystemWindows(env: PJNIEnv; _jstoolbar: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsToolbar_SetTheme(env: PJNIEnv; _jstoolbar: JObject; _theme: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _theme;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTheme', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsToolbar_SetSubtitleTextColor(env: PJNIEnv; _jstoolbar: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSubtitleTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsToolbar_SetBackgroundToPrimaryColor(env: PJNIEnv; _jstoolbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundToPrimaryColor', '()V');
  env^.CallVoidMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jsToolbar_GetPrimaryColor(env: PJNIEnv; _jstoolbar: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPrimaryColor', '()I');
  Result:= env^.CallIntMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jsToolbar_GetSuggestedMinimumHeight(env: PJNIEnv; _jstoolbar: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSuggestedMinimumHeight', '()I');
  Result:= env^.CallIntMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsToolbar_SetSuggestedMinimumHeight(env: PJNIEnv; _jstoolbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSuggestedMinimumHeight', '()V');
  env^.CallVoidMethod(env, _jstoolbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsToolbar_SetMinimumHeight(env: PJNIEnv; _jstoolbar: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMinimumHeight', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsToolbar_SetHeightByDisplayMetricsDensity(env: PJNIEnv; _jstoolbar: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jstoolbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHeightByDisplayMetricsDensity', '(I)V');
  env^.CallVoidMethodA(env, _jstoolbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
