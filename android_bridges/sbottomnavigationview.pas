unit sbottomnavigationview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [1/13/2018 22:17:13]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsBottomNavigationView = class(jVisualControl)
 private
    FOnClickItem: TOnClickNavigationViewItem;
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
    
    procedure GenEvent_OnClickNavigationViewItem(Sender: TObject; itemIndex: integer; itemCaption: string);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent();  override;
    function GetView(): jObject; override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    function GetLParamWidth(): integer;
    function GetLParamHeight(): integer;
    procedure SetLGravity(_gravity: TLayoutGravity);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetId(_id: integer);

    function GetMenu(): jObject;
    procedure ClearMenu();

    procedure SetItemTextColor(_menuItem: jObject; _color: TARGBColorBridge);
    procedure SetAllItemsTextColor(_color: TARGBColorBridge);
    procedure ResetAllItemsTextColor();
    procedure SetFontColor(_color: TARGBColorBridge);
    procedure SetSelectedItemTextColor(_color: TARGBColorBridge);
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetBackgroundToPrimaryColor();
    procedure BringToFront();

    function AddItem(_menu: jObject; _itemId: integer; _itemCaption: string): jObject; overload;
    procedure AddItem(_menu: jObject; _itemId: integer; _itemCaption: string; _drawableIdentifier: string); overload;
    procedure AddItemIcon(_menuItem: jObject; _drawableIdentifier: string);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property FontColor : TARGBColorBridge  read FFontColor write SetFontColor;
    property OnClickItem: TOnClickNavigationViewItem read FOnClickItem write FOnClickItem;
    //property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jsBottomNavigationView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsBottomNavigationView_jFree(env: PJNIEnv; _jsbottomnavigationview: JObject);
procedure jsBottomNavigationView_SetViewParent(env: PJNIEnv; _jsbottomnavigationview: JObject; _viewgroup: jObject);
function jsBottomNavigationView_GetParent(env: PJNIEnv; _jsbottomnavigationview: JObject): jObject;
procedure jsBottomNavigationView_RemoveFromViewParent(env: PJNIEnv; _jsbottomnavigationview: JObject);
function jsBottomNavigationView_GetView(env: PJNIEnv; _jsbottomnavigationview: JObject): jObject;
procedure jsBottomNavigationView_SetLParamWidth(env: PJNIEnv; _jsbottomnavigationview: JObject; _w: integer);
procedure jsBottomNavigationView_SetLParamHeight(env: PJNIEnv; _jsbottomnavigationview: JObject; _h: integer);
function jsBottomNavigationView_GetLParamWidth(env: PJNIEnv; _jsbottomnavigationview: JObject): integer;
function jsBottomNavigationView_GetLParamHeight(env: PJNIEnv; _jsbottomnavigationview: JObject): integer;
procedure jsBottomNavigationView_SetLGravity(env: PJNIEnv; _jsbottomnavigationview: JObject; _g: integer);
procedure jsBottomNavigationView_SetLWeight(env: PJNIEnv; _jsbottomnavigationview: JObject; _w: single);
procedure jsBottomNavigationView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsbottomnavigationview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsBottomNavigationView_AddLParamsAnchorRule(env: PJNIEnv; _jsbottomnavigationview: JObject; _rule: integer);
procedure jsBottomNavigationView_AddLParamsParentRule(env: PJNIEnv; _jsbottomnavigationview: JObject; _rule: integer);
procedure jsBottomNavigationView_SetLayoutAll(env: PJNIEnv; _jsbottomnavigationview: JObject; _idAnchor: integer);
procedure jsBottomNavigationView_ClearLayoutAll(env: PJNIEnv; _jsbottomnavigationview: JObject);
procedure jsBottomNavigationView_SetId(env: PJNIEnv; _jsbottomnavigationview: JObject; _id: integer);

function jsBottomNavigationView_GetMenu(env: PJNIEnv; _jsbottomnavigationview: JObject): jObject;
procedure jsBottomNavigationView_ClearMenu(env: PJNIEnv; _jsbottomnavigationview: JObject);

procedure jsBottomNavigationView_SetItemTextColor(env: PJNIEnv; _jsbottomnavigationview: JObject; _menuItem: jObject; _color: integer);  overload;
procedure jsBottomNavigationView_SetAllItemsTextColor(env: PJNIEnv; _jsbottomnavigationview: JObject; _color: integer);
procedure jsBottomNavigationView_ResetAllItemsTextColor(env: PJNIEnv; _jsbottomnavigationview: JObject);
procedure jsBottomNavigationView_SetItemTextColor(env: PJNIEnv; _jsbottomnavigationview: JObject; _color: integer); overload;
procedure jsBottomNavigationView_SetSelectedItemTextColor(env: PJNIEnv; _jsbottomnavigationview: JObject; _color: integer);

function jsBottomNavigationView_AddItem(env: PJNIEnv; _jsbottomnavigationview: JObject; _menu: jObject; _itemId: integer; _itemCaption: string): jObject; overload;
procedure jsBottomNavigationView_AddItem(env: PJNIEnv; _jsbottomnavigationview: JObject; _menu: jObject; _itemId: integer; _itemCaption: string; _drawableIdentifier: string); overload;
procedure jsBottomNavigationView_AddItemIcon(env: PJNIEnv; _jsbottomnavigationview: JObject; _menuItem: jObject; _drawableIdentifier: string);
procedure jsBottomNavigationView_SetFitsSystemWindows(env: PJNIEnv; _jsbottomnavigationview: JObject; _value: boolean);
procedure jsBottomNavigationView_SetBackgroundToPrimaryColor(env: PJNIEnv; _jsbottomnavigationview: JObject);
procedure jsBottomNavigationView_BringToFront(env: PJNIEnv; _jsbottomnavigationview: JObject);



implementation

uses
  customdialog, viewflipper, toolbar, scoordinatorlayout, linearlayout,
  sdrawerlayout, scollapsingtoolbarlayout, scardview, sappbarlayout,
  stoolbar, stablayout, snestedscrollview, sviewpager, framelayout;

{---------  jsBottomNavigationView  --------------}

constructor jsBottomNavigationView.Create(AOwner: TComponent);
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
  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor jsBottomNavigationView.Destroy;
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

procedure jsBottomNavigationView.TryNewParent(refApp: jApp);
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

procedure jsBottomNavigationView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;

  if FParent <> nil then
  begin
    TryNewParent(refApp);
  end;

  FjPRLayoutHome:= FjPRLayout;


  if FGravityInParent <> lgNone then
    jsBottomNavigationView_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent) );

  jsBottomNavigationView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsBottomNavigationView_SetId(FjEnv, FjObject, Self.Id);
  jsBottomNavigationView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsBottomNavigationView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsBottomNavigationView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsBottomNavigationView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if FFontColor <> colbrDefault then
     jsBottomNavigationView_SetItemTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsBottomNavigationView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsBottomNavigationView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsBottomNavigationView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jsBottomNavigationView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsBottomNavigationView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsBottomNavigationView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsBottomNavigationView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jsBottomNavigationView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsBottomNavigationView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsBottomNavigationView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsBottomNavigationView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsBottomNavigationView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsBottomNavigationView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsBottomNavigationView.GenEvent_OnClickNavigationViewItem(Sender: TObject; itemIndex: integer; itemCaption: string);
begin
  if Assigned(FOnClickItem) then FOnClickItem(Sender,  itemIndex, itemCaption);
end;

function jsBottomNavigationView.jCreate(): jObject;
begin
   Result:= jsBottomNavigationView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsBottomNavigationView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_jFree(FjEnv, FjObject);
end;

procedure jsBottomNavigationView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsBottomNavigationView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsBottomNavigationView_GetParent(FjEnv, FjObject);
end;

procedure jsBottomNavigationView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsBottomNavigationView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsBottomNavigationView_GetView(FjEnv, FjObject);
end;

procedure jsBottomNavigationView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsBottomNavigationView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsBottomNavigationView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsBottomNavigationView_GetLParamWidth(FjEnv, FjObject);
end;

function jsBottomNavigationView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsBottomNavigationView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsBottomNavigationView.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FInitialized then
     jsBottomNavigationView_SetLGravity(FjEnv, FjObject, Ord(_gravity));
end;

procedure jsBottomNavigationView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsBottomNavigationView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsBottomNavigationView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsBottomNavigationView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsBottomNavigationView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsBottomNavigationView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsBottomNavigationView_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsBottomNavigationView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsBottomNavigationView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsBottomNavigationView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetId(FjEnv, FjObject, _id);
end;

function jsBottomNavigationView.GetMenu(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsBottomNavigationView_GetMenu(FjEnv, FjObject);
end;

procedure jsBottomNavigationView.ClearMenu();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_ClearMenu(FjEnv, FjObject);
end;

procedure jsBottomNavigationView.SetItemTextColor(_menuItem: jObject; _color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetItemTextColor(FjEnv, FjObject, _menuItem ,GetARGB(FCustomColor, _color));
end;

procedure jsBottomNavigationView.SetAllItemsTextColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetAllItemsTextColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsBottomNavigationView.ResetAllItemsTextColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_ResetAllItemsTextColor(FjEnv, FjObject);
end;

procedure jsBottomNavigationView.SetFontColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FFontColor:=  _color;
  if FInitialized then
     jsBottomNavigationView_SetItemTextColor(FjEnv, FjObject,  GetARGB(FCustomColor, FFontColor));
end;

procedure jsBottomNavigationView.SetSelectedItemTextColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetSelectedItemTextColor(FjEnv, FjObject,  GetARGB(FCustomColor, _color));
end;

function jsBottomNavigationView.AddItem(_menu: jObject; _itemId: integer; _itemCaption: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsBottomNavigationView_AddItem(FjEnv, FjObject, _menu ,_itemId ,_itemCaption);
end;

procedure jsBottomNavigationView.AddItem(_menu: jObject; _itemId: integer; _itemCaption: string; _drawableIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_AddItem(FjEnv, FjObject, _menu ,_itemId ,_itemCaption ,_drawableIdentifier);
end;

procedure jsBottomNavigationView.AddItemIcon(_menuItem: jObject; _drawableIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_AddItemIcon(FjEnv, FjObject, _menuItem ,_drawableIdentifier);
end;

procedure jsBottomNavigationView.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

procedure jsBottomNavigationView.SetBackgroundToPrimaryColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_SetBackgroundToPrimaryColor(FjEnv, FjObject);
end;

procedure jsBottomNavigationView.BringToFront();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsBottomNavigationView_BringToFront(FjEnv, FjObject);
end;

{-------- jsBottomNavigationView_JNI_Bridge ----------}

function jsBottomNavigationView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsBottomNavigationView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsBottomNavigationView_jFree(env: PJNIEnv; _jsbottomnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_SetViewParent(env: PJNIEnv; _jsbottomnavigationview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsBottomNavigationView_GetParent(env: PJNIEnv; _jsbottomnavigationview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_RemoveFromViewParent(env: PJNIEnv; _jsbottomnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsBottomNavigationView_GetView(env: PJNIEnv; _jsbottomnavigationview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_SetLParamWidth(env: PJNIEnv; _jsbottomnavigationview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_SetLParamHeight(env: PJNIEnv; _jsbottomnavigationview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsBottomNavigationView_GetLParamWidth(env: PJNIEnv; _jsbottomnavigationview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsBottomNavigationView_GetLParamHeight(env: PJNIEnv; _jsbottomnavigationview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_SetLGravity(env: PJNIEnv; _jsbottomnavigationview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_SetLWeight(env: PJNIEnv; _jsbottomnavigationview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsbottomnavigationview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_AddLParamsAnchorRule(env: PJNIEnv; _jsbottomnavigationview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_AddLParamsParentRule(env: PJNIEnv; _jsbottomnavigationview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_SetLayoutAll(env: PJNIEnv; _jsbottomnavigationview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_ClearLayoutAll(env: PJNIEnv; _jsbottomnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_SetId(env: PJNIEnv; _jsbottomnavigationview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jsBottomNavigationView_GetMenu(env: PJNIEnv; _jsbottomnavigationview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMenu', '()Landroid/view/Menu;');
  Result:= env^.CallObjectMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsBottomNavigationView_ClearMenu(env: PJNIEnv; _jsbottomnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearMenu', '()V');
  env^.CallVoidMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsBottomNavigationView_SetItemTextColor(env: PJNIEnv; _jsbottomnavigationview: JObject; _menuItem: jObject; _color: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menuItem;
  jParams[1].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemTextColor', '(Landroid/view/MenuItem;I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_SetAllItemsTextColor(env: PJNIEnv; _jsbottomnavigationview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAllItemsTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_ResetAllItemsTextColor(env: PJNIEnv; _jsbottomnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'ResetAllItemsTextColor', '()V');
  env^.CallVoidMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_SetItemTextColor(env: PJNIEnv; _jsbottomnavigationview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsBottomNavigationView_SetSelectedItemTextColor(env: PJNIEnv; _jsbottomnavigationview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedItemTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsBottomNavigationView_AddItem(env: PJNIEnv; _jsbottomnavigationview: JObject; _menu: jObject; _itemId: integer; _itemCaption: string): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menu;
  jParams[1].i:= _itemId;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_itemCaption));
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddItem', '(Landroid/view/Menu;ILjava/lang/String;)Landroid/view/MenuItem;');
  Result:= env^.CallObjectMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_AddItem(env: PJNIEnv; _jsbottomnavigationview: JObject; _menu: jObject; _itemId: integer; _itemCaption: string; _drawableIdentifier: string);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menu;
  jParams[1].i:= _itemId;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_itemCaption));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_drawableIdentifier));
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddItem', '(Landroid/view/Menu;ILjava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsBottomNavigationView_AddItemIcon(env: PJNIEnv; _jsbottomnavigationview: JObject; _menuItem: jObject; _drawableIdentifier: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menuItem;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_drawableIdentifier));
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddItemIcon', '(Landroid/view/MenuItem;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsBottomNavigationView_SetFitsSystemWindows(env: PJNIEnv; _jsbottomnavigationview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jsbottomnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsBottomNavigationView_SetBackgroundToPrimaryColor(env: PJNIEnv; _jsbottomnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundToPrimaryColor', '()V');
  env^.CallVoidMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsBottomNavigationView_BringToFront(env: PJNIEnv; _jsbottomnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsbottomnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'BringToFront', '()V');
  env^.CallVoidMethod(env, _jsbottomnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
