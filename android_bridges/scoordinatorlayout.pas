unit scoordinatorlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/12/2017 2:07:04]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsCoordinatorLayout = class(jVisualControl)
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
    procedure SetLGravity(_gravity: TLayoutGravity);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetId(_id: integer);
    procedure SetFitsSystemWindows(_value: boolean);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property FitsSystemWindows: boolean read FFitsSystemWindows write SetFitsSystemWindows;
   // property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jsCoordinatorLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsCoordinatorLayout_jFree(env: PJNIEnv; _jscoordinatorlayout: JObject);
procedure jsCoordinatorLayout_SetViewParent(env: PJNIEnv; _jscoordinatorlayout: JObject; _viewgroup: jObject);
function jsCoordinatorLayout_GetParent(env: PJNIEnv; _jscoordinatorlayout: JObject): jObject;
procedure jsCoordinatorLayout_RemoveFromViewParent(env: PJNIEnv; _jscoordinatorlayout: JObject);
function jsCoordinatorLayout_GetView(env: PJNIEnv; _jscoordinatorlayout: JObject): jObject;
procedure jsCoordinatorLayout_SetLParamWidth(env: PJNIEnv; _jscoordinatorlayout: JObject; _w: integer);
procedure jsCoordinatorLayout_SetLParamHeight(env: PJNIEnv; _jscoordinatorlayout: JObject; _h: integer);
function jsCoordinatorLayout_GetLParamWidth(env: PJNIEnv; _jscoordinatorlayout: JObject): integer;
function jsCoordinatorLayout_GetLParamHeight(env: PJNIEnv; _jscoordinatorlayout: JObject): integer;
procedure jsCoordinatorLayout_SetLGravity(env: PJNIEnv; _jscoordinatorlayout: JObject; _g: integer);
procedure jsCoordinatorLayout_SetLWeight(env: PJNIEnv; _jscoordinatorlayout: JObject; _w: single);
procedure jsCoordinatorLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jscoordinatorlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsCoordinatorLayout_AddLParamsAnchorRule(env: PJNIEnv; _jscoordinatorlayout: JObject; _rule: integer);
procedure jsCoordinatorLayout_AddLParamsParentRule(env: PJNIEnv; _jscoordinatorlayout: JObject; _rule: integer);
procedure jsCoordinatorLayout_SetLayoutAll(env: PJNIEnv; _jscoordinatorlayout: JObject; _idAnchor: integer);
procedure jsCoordinatorLayout_ClearLayoutAll(env: PJNIEnv; _jscoordinatorlayout: JObject);
procedure jsCoordinatorLayout_SetId(env: PJNIEnv; _jscoordinatorlayout: JObject; _id: integer);
procedure jsCoordinatorLayout_SetFitsSystemWindows(env: PJNIEnv; _jscoordinatorlayout: JObject; _value: boolean);


implementation

uses
  customdialog, viewflipper, toolbar, linearlayout,
  sdrawerlayout, scollapsingtoolbarlayout, scardview, sappbarlayout,
  stoolbar, stablayout, snestedscrollview, sviewpager, framelayout;

{---------  jsCoordinatorLayout  --------------}

constructor jsCoordinatorLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 0;
  FMarginTop    := 0;
  FMarginBottom := 0;
  FMarginRight  := 0;
  FHeight       := 96; //??
  FWidth        := 192; //96; //??

  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;
//your code here....
end;

destructor jsCoordinatorLayout.Destroy;
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

procedure jsCoordinatorLayout.TryNewParent(refApp: jApp);
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

procedure jsCoordinatorLayout.Init(refApp: jApp);
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
    jsCoordinatorLayout_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent) );

  jsCoordinatorLayout_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsCoordinatorLayout_SetId(FjEnv, FjObject, Self.Id);
  jsCoordinatorLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsCoordinatorLayout_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsCoordinatorLayout_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsCoordinatorLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FFitsSystemWindows  then
     jsCoordinatorLayout_SetFitsSystemWindows(FjEnv, FjObject, FFitsSystemWindows);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsCoordinatorLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsCoordinatorLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsCoordinatorLayout.UpdateLParamWidth;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      jsCoordinatorLayout_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdw));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsCoordinatorLayout_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsCoordinatorLayout_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsCoordinatorLayout.UpdateLParamHeight;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      jsCoordinatorLayout_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdh));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsCoordinatorLayout_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsCoordinatorLayout_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsCoordinatorLayout.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsCoordinatorLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsCoordinatorLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
(*
procedure jsCoordinatorLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jsCoordinatorLayout.jCreate(): jObject;
begin
   Result:= jsCoordinatorLayout_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsCoordinatorLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_jFree(FjEnv, FjObject);
end;

procedure jsCoordinatorLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsCoordinatorLayout.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsCoordinatorLayout_GetParent(FjEnv, FjObject);
end;

procedure jsCoordinatorLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsCoordinatorLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsCoordinatorLayout_GetView(FjEnv, FjObject);
end;

procedure jsCoordinatorLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsCoordinatorLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsCoordinatorLayout.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  Result:= jsCoordinatorLayout_getLParamWidth(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetWidthOfParent(FParent);
end;

function jsCoordinatorLayout.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  Result:= jsCoordinatorLayout_getLParamHeight(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetHeightOfParent(FParent);
end;

procedure jsCoordinatorLayout.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FInitialized then
     jsCoordinatorLayout_SetLGravity(FjEnv, FjObject, Ord(_gravity) );
end;

procedure jsCoordinatorLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsCoordinatorLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsCoordinatorLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsCoordinatorLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsCoordinatorLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsCoordinatorLayout.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsCoordinatorLayout_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsCoordinatorLayout_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsCoordinatorLayout_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsCoordinatorLayout.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCoordinatorLayout_SetId(FjEnv, FjObject, _id);
end;

procedure jsCoordinatorLayout.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsCoordinatorLayout_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

{-------- jsCoordinatorLayout_JNI_Bridge ----------}

function jsCoordinatorLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsCoordinatorLayout_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jsCoordinatorLayout_jCreate(long _Self) {
  return (java.lang.Object)(new jsCoordinatorLayout(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jsCoordinatorLayout_jFree(env: PJNIEnv; _jscoordinatorlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jscoordinatorlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_SetViewParent(env: PJNIEnv; _jscoordinatorlayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCoordinatorLayout_GetParent(env: PJNIEnv; _jscoordinatorlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jscoordinatorlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_RemoveFromViewParent(env: PJNIEnv; _jscoordinatorlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jscoordinatorlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCoordinatorLayout_GetView(env: PJNIEnv; _jscoordinatorlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jscoordinatorlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_SetLParamWidth(env: PJNIEnv; _jscoordinatorlayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_SetLParamHeight(env: PJNIEnv; _jscoordinatorlayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCoordinatorLayout_GetLParamWidth(env: PJNIEnv; _jscoordinatorlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jscoordinatorlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCoordinatorLayout_GetLParamHeight(env: PJNIEnv; _jscoordinatorlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jscoordinatorlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_SetLGravity(env: PJNIEnv; _jscoordinatorlayout: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_SetLWeight(env: PJNIEnv; _jscoordinatorlayout: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jscoordinatorlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_AddLParamsAnchorRule(env: PJNIEnv; _jscoordinatorlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_AddLParamsParentRule(env: PJNIEnv; _jscoordinatorlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_SetLayoutAll(env: PJNIEnv; _jscoordinatorlayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_ClearLayoutAll(env: PJNIEnv; _jscoordinatorlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jscoordinatorlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCoordinatorLayout_SetId(env: PJNIEnv; _jscoordinatorlayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsCoordinatorLayout_SetFitsSystemWindows(env: PJNIEnv; _jscoordinatorlayout: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jscoordinatorlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jscoordinatorlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
