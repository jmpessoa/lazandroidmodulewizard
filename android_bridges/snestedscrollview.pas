unit snestedscrollview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [1/22/2018 0:26:12]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsNestedScrollView = class(jVisualControl)
 private
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
    
    //procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent();  override;
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    function GetWidth(): integer; override;
    function GetHeight(): integer; override;
    procedure SetLGravity(_gravity: integer);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetId(_id: integer);
    procedure SetAppBarLayoutScrollingViewBehavior();
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetNestedScrollingEnabled(_view: jObject);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FitsSystemWindows: boolean read FFitsSystemWindows write SetFitsSystemWindows;
     //property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jsNestedScrollView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsNestedScrollView_jFree(env: PJNIEnv; _jsnestedscrollview: JObject);
procedure jsNestedScrollView_SetViewParent(env: PJNIEnv; _jsnestedscrollview: JObject; _viewgroup: jObject);
function jsNestedScrollView_GetParent(env: PJNIEnv; _jsnestedscrollview: JObject): jObject;
procedure jsNestedScrollView_RemoveFromViewParent(env: PJNIEnv; _jsnestedscrollview: JObject);
function jsNestedScrollView_GetView(env: PJNIEnv; _jsnestedscrollview: JObject): jObject;
procedure jsNestedScrollView_SetLParamWidth(env: PJNIEnv; _jsnestedscrollview: JObject; _w: integer);
procedure jsNestedScrollView_SetLParamHeight(env: PJNIEnv; _jsnestedscrollview: JObject; _h: integer);
function jsNestedScrollView_GetLParamWidth(env: PJNIEnv; _jsnestedscrollview: JObject): integer;
function jsNestedScrollView_GetLParamHeight(env: PJNIEnv; _jsnestedscrollview: JObject): integer;
procedure jsNestedScrollView_SetLGravity(env: PJNIEnv; _jsnestedscrollview: JObject; _gravity: integer);
procedure jsNestedScrollView_SetLWeight(env: PJNIEnv; _jsnestedscrollview: JObject; _w: single);
procedure jsNestedScrollView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsnestedscrollview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsNestedScrollView_AddLParamsAnchorRule(env: PJNIEnv; _jsnestedscrollview: JObject; _rule: integer);
procedure jsNestedScrollView_AddLParamsParentRule(env: PJNIEnv; _jsnestedscrollview: JObject; _rule: integer);
procedure jsNestedScrollView_SetLayoutAll(env: PJNIEnv; _jsnestedscrollview: JObject; _idAnchor: integer);
procedure jsNestedScrollView_ClearLayoutAll(env: PJNIEnv; _jsnestedscrollview: JObject);
procedure jsNestedScrollView_SetId(env: PJNIEnv; _jsnestedscrollview: JObject; _id: integer);
procedure jsNestedScrollView_SetAppBarLayoutScrollingViewBehavior(env: PJNIEnv; _jsnestedscrollview: JObject);
procedure jsNestedScrollView_SetFitsSystemWindows(env: PJNIEnv; _jsnestedscrollview: JObject; _value: boolean);
procedure jsNestedScrollView_SetNestedScrollingEnabled(env: PJNIEnv; _jsnestedscrollview: JObject; _view: jObject);

implementation

uses
  customdialog, viewflipper, toolbar, scoordinatorlayout, linearlayout,
  sdrawerlayout, scollapsingtoolbarlayout, scardview, sappbarlayout,
  stoolbar, stablayout, sviewpager, framelayout;

{---------  jsNestedScrollView  --------------}

constructor jsNestedScrollView.Create(AOwner: TComponent);
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
//your code here....
end;

destructor jsNestedScrollView.Destroy;
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

procedure jsNestedScrollView.TryNewParent(refApp: jApp);
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

procedure jsNestedScrollView.Init(refApp: jApp);
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

  jsNestedScrollView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsNestedScrollView_SetId(FjEnv, FjObject, Self.Id);
  jsNestedScrollView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsNestedScrollView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsNestedScrollView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsNestedScrollView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FFitsSystemWindows  then
     jsNestedScrollView_SetFitsSystemWindows(FjEnv, FjObject, FFitsSystemWindows);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsNestedScrollView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsNestedScrollView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsNestedScrollView.UpdateLParamWidth;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      jsNestedScrollView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdw));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsNestedScrollView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsNestedScrollView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsNestedScrollView.UpdateLParamHeight;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      jsNestedScrollView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdh));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsNestedScrollView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsNestedScrollView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsNestedScrollView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsNestedScrollView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsNestedScrollView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
(*
procedure jsNestedScrollView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jsNestedScrollView.jCreate(): jObject;
begin
   Result:= jsNestedScrollView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsNestedScrollView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_jFree(FjEnv, FjObject);
end;

procedure jsNestedScrollView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsNestedScrollView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsNestedScrollView_GetParent(FjEnv, FjObject);
end;

procedure jsNestedScrollView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsNestedScrollView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsNestedScrollView_GetView(FjEnv, FjObject);
end;

procedure jsNestedScrollView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsNestedScrollView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsNestedScrollView.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  Result:= jsNestedScrollView_getLParamWidth(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetWidthOfParent(FParent);
end;

function jsNestedScrollView.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  Result:= jsNestedScrollView_getLParamHeight(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetHeightOfParent(FParent);
end;

procedure jsNestedScrollView.SetLGravity(_gravity: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_SetLGravity(FjEnv, FjObject, _gravity);
end;

procedure jsNestedScrollView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsNestedScrollView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsNestedScrollView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsNestedScrollView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsNestedScrollView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsNestedScrollView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsNestedScrollView_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsNestedScrollView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsNestedScrollView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsNestedScrollView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_SetId(FjEnv, FjObject, _id);
end;

procedure jsNestedScrollView.SetAppBarLayoutScrollingViewBehavior();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_SetAppBarLayoutScrollingViewBehavior(FjEnv, FjObject);
end;

procedure jsNestedScrollView.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsNestedScrollView_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

procedure jsNestedScrollView.SetNestedScrollingEnabled(_view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNestedScrollView_SetNestedScrollingEnabled(FjEnv, FjObject, _view);
end;

{-------- jsNestedScrollView_JNI_Bridge ----------}

function jsNestedScrollView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsNestedScrollView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsNestedScrollView_jFree(env: PJNIEnv; _jsnestedscrollview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsnestedscrollview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_SetViewParent(env: PJNIEnv; _jsnestedscrollview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNestedScrollView_GetParent(env: PJNIEnv; _jsnestedscrollview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jsnestedscrollview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_RemoveFromViewParent(env: PJNIEnv; _jsnestedscrollview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsnestedscrollview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNestedScrollView_GetView(env: PJNIEnv; _jsnestedscrollview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsnestedscrollview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_SetLParamWidth(env: PJNIEnv; _jsnestedscrollview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_SetLParamHeight(env: PJNIEnv; _jsnestedscrollview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNestedScrollView_GetLParamWidth(env: PJNIEnv; _jsnestedscrollview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jsnestedscrollview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNestedScrollView_GetLParamHeight(env: PJNIEnv; _jsnestedscrollview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jsnestedscrollview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_SetLGravity(env: PJNIEnv; _jsnestedscrollview: JObject; _gravity: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _gravity;
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_SetLWeight(env: PJNIEnv; _jsnestedscrollview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsnestedscrollview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_AddLParamsAnchorRule(env: PJNIEnv; _jsnestedscrollview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_AddLParamsParentRule(env: PJNIEnv; _jsnestedscrollview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_SetLayoutAll(env: PJNIEnv; _jsnestedscrollview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_ClearLayoutAll(env: PJNIEnv; _jsnestedscrollview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsnestedscrollview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_SetId(env: PJNIEnv; _jsnestedscrollview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNestedScrollView_SetAppBarLayoutScrollingViewBehavior(env: PJNIEnv; _jsnestedscrollview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAppBarLayoutScrollingViewBehavior', '()V');
  env^.CallVoidMethod(env, _jsnestedscrollview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNestedScrollView_SetFitsSystemWindows(env: PJNIEnv; _jsnestedscrollview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNestedScrollView_SetNestedScrollingEnabled(env: PJNIEnv; _jsnestedscrollview: JObject; _view: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _view;
  jCls:= env^.GetObjectClass(env, _jsnestedscrollview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetNestedScrollingEnabled', '(Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jsnestedscrollview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
