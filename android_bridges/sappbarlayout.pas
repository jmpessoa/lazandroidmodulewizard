unit sappbarlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [1/3/2018 18:07:27]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsAppBarLayout = class(jVisualControl)
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
    procedure ClearLayout;

//    procedure GenEvent_OnClick(Obj: TObject);
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
    procedure SetLGravity(_g: integer);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetBackgroundToPrimaryColor();

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FitsSystemWindows: boolean read FFitsSystemWindows write SetFitsSystemWindows;
    //property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jsAppBarLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsAppBarLayout_jFree(env: PJNIEnv; _jsappbarlayout: JObject);
procedure jsAppBarLayout_SetViewParent(env: PJNIEnv; _jsappbarlayout: JObject; _viewgroup: jObject);
function jsAppBarLayout_GetParent(env: PJNIEnv; _jsappbarlayout: JObject): jObject;
procedure jsAppBarLayout_RemoveFromViewParent(env: PJNIEnv; _jsappbarlayout: JObject);
function jsAppBarLayout_GetView(env: PJNIEnv; _jsappbarlayout: JObject): jObject;
procedure jsAppBarLayout_SetLParamWidth(env: PJNIEnv; _jsappbarlayout: JObject; _w: integer);
procedure jsAppBarLayout_SetLParamHeight(env: PJNIEnv; _jsappbarlayout: JObject; _h: integer);
function jsAppBarLayout_GetLParamWidth(env: PJNIEnv; _jsappbarlayout: JObject): integer;
function jsAppBarLayout_GetLParamHeight(env: PJNIEnv; _jsappbarlayout: JObject): integer;
procedure jsAppBarLayout_SetLGravity(env: PJNIEnv; _jsappbarlayout: JObject; _g: integer);
procedure jsAppBarLayout_SetLWeight(env: PJNIEnv; _jsappbarlayout: JObject; _w: single);
procedure jsAppBarLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsappbarlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsAppBarLayout_AddLParamsAnchorRule(env: PJNIEnv; _jsappbarlayout: JObject; _rule: integer);
procedure jsAppBarLayout_AddLParamsParentRule(env: PJNIEnv; _jsappbarlayout: JObject; _rule: integer);
procedure jsAppBarLayout_SetLayoutAll(env: PJNIEnv; _jsappbarlayout: JObject; _idAnchor: integer);
procedure jsAppBarLayout_ClearLayoutAll(env: PJNIEnv; _jsappbarlayout: JObject);
procedure jsAppBarLayout_SetId(env: PJNIEnv; _jsappbarlayout: JObject; _id: integer);
procedure jsAppBarLayout_SetFitsSystemWindows(env: PJNIEnv; _jsappbarlayout: JObject; _value: boolean);
procedure jsAppBarLayout_SetBackgroundToPrimaryColor(env: PJNIEnv; _jsappbarlayout: JObject);


implementation

uses
  customdialog, viewflipper, toolbar, scoordinatorlayout, linearlayout,
  sdrawerlayout, scollapsingtoolbarlayout, scardview,
  stoolbar, stablayout, snestedscrollview, sviewpager, framelayout;

{---------  jsAppBarLayout  --------------}

constructor jsAppBarLayout.Create(AOwner: TComponent);
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

destructor jsAppBarLayout.Destroy;
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

procedure jsAppBarLayout.TryNewParent(refApp: jApp);
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

procedure jsAppBarLayout.Init(refApp: jApp);
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

  jsAppBarLayout_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsAppBarLayout_SetId(FjEnv, FjObject, Self.Id);
  jsAppBarLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsAppBarLayout_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsAppBarLayout_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsAppBarLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FFitsSystemWindows  then
     jsAppBarLayout_SetFitsSystemWindows(FjEnv, FjObject, FFitsSystemWindows);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsAppBarLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsAppBarLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsAppBarLayout.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jsAppBarLayout_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsAppBarLayout_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsAppBarLayout_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsAppBarLayout.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jsAppBarLayout_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsAppBarLayout_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsAppBarLayout_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsAppBarLayout.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsAppBarLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsAppBarLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jsAppBarLayout.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jsAppBarLayout_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jsAppBarLayout_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jsAppBarLayout_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
(*
procedure jsAppBarLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jsAppBarLayout.jCreate(): jObject;
begin
   Result:= jsAppBarLayout_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsAppBarLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_jFree(FjEnv, FjObject);
end;

procedure jsAppBarLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsAppBarLayout.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsAppBarLayout_GetParent(FjEnv, FjObject);
end;

procedure jsAppBarLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsAppBarLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsAppBarLayout_GetView(FjEnv, FjObject);
end;

procedure jsAppBarLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsAppBarLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsAppBarLayout.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  Result:= jsAppBarLayout_getLParamWidth(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetWidthOfParent(FParent);
end;

function jsAppBarLayout.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  Result:= jsAppBarLayout_getLParamHeight(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetHeightOfParent(FParent);
end;

procedure jsAppBarLayout.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jsAppBarLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsAppBarLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsAppBarLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsAppBarLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsAppBarLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsAppBarLayout.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jsAppBarLayout.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetId(FjEnv, FjObject, _id);
end;

procedure jsAppBarLayout.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsAppBarLayout_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

procedure jsAppBarLayout.SetBackgroundToPrimaryColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetBackgroundToPrimaryColor(FjEnv, FjObject);
end;

{-------- jsAppBarLayout_JNI_Bridge ----------}

function jsAppBarLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsAppBarLayout_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsAppBarLayout_jFree(env: PJNIEnv; _jsappbarlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsappbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_SetViewParent(env: PJNIEnv; _jsappbarlayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsAppBarLayout_GetParent(env: PJNIEnv; _jsappbarlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jsappbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_RemoveFromViewParent(env: PJNIEnv; _jsappbarlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsappbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsAppBarLayout_GetView(env: PJNIEnv; _jsappbarlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsappbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_SetLParamWidth(env: PJNIEnv; _jsappbarlayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_SetLParamHeight(env: PJNIEnv; _jsappbarlayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsAppBarLayout_GetLParamWidth(env: PJNIEnv; _jsappbarlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jsappbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsAppBarLayout_GetLParamHeight(env: PJNIEnv; _jsappbarlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jsappbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_SetLGravity(env: PJNIEnv; _jsappbarlayout: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_SetLWeight(env: PJNIEnv; _jsappbarlayout: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsappbarlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_AddLParamsAnchorRule(env: PJNIEnv; _jsappbarlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_AddLParamsParentRule(env: PJNIEnv; _jsappbarlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_SetLayoutAll(env: PJNIEnv; _jsappbarlayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_ClearLayoutAll(env: PJNIEnv; _jsappbarlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsappbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAppBarLayout_SetId(env: PJNIEnv; _jsappbarlayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsAppBarLayout_SetFitsSystemWindows(env: PJNIEnv; _jsappbarlayout: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsAppBarLayout_SetBackgroundToPrimaryColor(env: PJNIEnv; _jsappbarlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroudToPrimaryColor', '()V');
  env^.CallVoidMethod(env, _jsappbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
