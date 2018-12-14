unit sdrawerlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/16/2017 3:31:21]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsDrawerLayout = class(jVisualControl)
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

    //procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent(); override;
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    function GetLParamWidth(): integer;
    function GetLParamHeight(): integer;
    procedure SetLGravity(_g: integer);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);

   // procedure CloseDrawer();
    procedure CloseDrawers();
    procedure OpenDrawer();
    procedure SetupDrawerToggle(_toolbar: jObject);
    procedure SetFitsSystemWindows(_value: boolean);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FitsSystemWindows: boolean read FFitsSystemWindows write SetFitsSystemWindows;
    //property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jsDrawerLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsDrawerLayout_jFree(env: PJNIEnv; _jsdrawerlayout: JObject);
procedure jsDrawerLayout_SetViewParent(env: PJNIEnv; _jsdrawerlayout: JObject; _viewgroup: jObject);
function jsDrawerLayout_GetParent(env: PJNIEnv; _jsdrawerlayout: JObject): jObject;
procedure jsDrawerLayout_RemoveFromViewParent(env: PJNIEnv; _jsdrawerlayout: JObject);
function jsDrawerLayout_GetView(env: PJNIEnv; _jsdrawerlayout: JObject): jObject;
procedure jsDrawerLayout_SetLParamWidth(env: PJNIEnv; _jsdrawerlayout: JObject; _w: integer);
procedure jsDrawerLayout_SetLParamHeight(env: PJNIEnv; _jsdrawerlayout: JObject; _h: integer);
function jsDrawerLayout_GetLParamWidth(env: PJNIEnv; _jsdrawerlayout: JObject): integer;
function jsDrawerLayout_GetLParamHeight(env: PJNIEnv; _jsdrawerlayout: JObject): integer;
procedure jsDrawerLayout_SetLGravity(env: PJNIEnv; _jsdrawerlayout: JObject; _g: integer);
procedure jsDrawerLayout_SetLWeight(env: PJNIEnv; _jsdrawerlayout: JObject; _w: single);
procedure jsDrawerLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsdrawerlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsDrawerLayout_AddLParamsAnchorRule(env: PJNIEnv; _jsdrawerlayout: JObject; _rule: integer);
procedure jsDrawerLayout_AddLParamsParentRule(env: PJNIEnv; _jsdrawerlayout: JObject; _rule: integer);
procedure jsDrawerLayout_SetLayoutAll(env: PJNIEnv; _jsdrawerlayout: JObject; _idAnchor: integer);
procedure jsDrawerLayout_ClearLayoutAll(env: PJNIEnv; _jsdrawerlayout: JObject);
procedure jsDrawerLayout_SetId(env: PJNIEnv; _jsdrawerlayout: JObject; _id: integer);

procedure jsDrawerLayout_CloseDrawer(env: PJNIEnv; _jsdrawerlayout: JObject);
procedure jsDrawerLayout_CloseDrawers(env: PJNIEnv; _jsdrawerlayout: JObject);
procedure jsDrawerLayout_OpenDrawer(env: PJNIEnv; _jsdrawerlayout: JObject);
procedure jsDrawerLayout_SetupDrawerToggle(env: PJNIEnv; _jsdrawerlayout: JObject; _toolbar: jObject);
procedure jsDrawerLayout_SetFitsSystemWindows(env: PJNIEnv; _jsdrawerlayout: JObject; _value: boolean);


implementation

uses
  customdialog, viewflipper, toolbar, scoordinatorlayout, linearlayout,
  scollapsingtoolbarlayout, scardview, sappbarlayout,
  stoolbar, stablayout, snestedscrollview, sviewpager, framelayout;


{---------  jsDrawerLayout  --------------}

constructor jsDrawerLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 0;
  FMarginTop    := 0;
  FMarginBottom := 0;
  FMarginRight  := 0;
  FHeight       := 96; //??
  FWidth        := 192; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpMatchParent; //lpMatchParent
  FPositionRelativeToParent:= [rpTop];
  FAcceptChildrenAtDesignTime:= True;
//your code here....
end;

destructor jsDrawerLayout.Destroy;
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

procedure jsDrawerLayout.TryNewParent(refApp: jApp);
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
procedure jsDrawerLayout.Init(refApp: jApp);
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

  jsDrawerLayout_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsDrawerLayout_SetId(FjEnv, FjObject, Self.Id);
  jsDrawerLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsDrawerLayout_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsDrawerLayout_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsDrawerLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FFitsSystemWindows  then
     jsDrawerLayout_SetFitsSystemWindows(FjEnv, FjObject, FFitsSystemWindows);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsDrawerLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsDrawerLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsDrawerLayout.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jsDrawerLayout_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsDrawerLayout_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsDrawerLayout_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsDrawerLayout.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jsDrawerLayout_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsDrawerLayout_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsDrawerLayout_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsDrawerLayout.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsDrawerLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsDrawerLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jsDrawerLayout.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jsDrawerLayout_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jsDrawerLayout_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jsDrawerLayout_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
(*
procedure jsDrawerLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jsDrawerLayout.jCreate(): jObject;
begin
   Result:= jsDrawerLayout_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsDrawerLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_jFree(FjEnv, FjObject);
end;

procedure jsDrawerLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsDrawerLayout.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsDrawerLayout_GetParent(FjEnv, FjObject);
end;

procedure jsDrawerLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsDrawerLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsDrawerLayout_GetView(FjEnv, FjObject);
end;

procedure jsDrawerLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsDrawerLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsDrawerLayout.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsDrawerLayout_GetLParamWidth(FjEnv, FjObject);
end;

function jsDrawerLayout.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsDrawerLayout_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsDrawerLayout.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jsDrawerLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsDrawerLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsDrawerLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsDrawerLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsDrawerLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsDrawerLayout.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jsDrawerLayout.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetId(FjEnv, FjObject, _id);
end;

{
procedure jsDrawerLayout.CloseDrawer();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_CloseDrawer(FjEnv, FjObject);
end;
}

procedure jsDrawerLayout.CloseDrawers();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_CloseDrawers(FjEnv, FjObject);
end;

procedure jsDrawerLayout.OpenDrawer();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_OpenDrawer(FjEnv, FjObject);
end;

procedure jsDrawerLayout.SetupDrawerToggle(_toolbar: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetupDrawerToggle(FjEnv, FjObject, _toolbar);
end;

procedure jsDrawerLayout.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsDrawerLayout_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

{-------- jsDrawerLayout_JNI_Bridge ----------}

function jsDrawerLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsDrawerLayout_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jsDrawerLayout_jCreate(long _Self) {
  return (java.lang.Object)(new jsDrawerLayout(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)

procedure jsDrawerLayout_jFree(env: PJNIEnv; _jsdrawerlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsdrawerlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsDrawerLayout_SetViewParent(env: PJNIEnv; _jsdrawerlayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jsDrawerLayout_GetParent(env: PJNIEnv; _jsdrawerlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jsdrawerlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsDrawerLayout_RemoveFromViewParent(env: PJNIEnv; _jsdrawerlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsdrawerlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jsDrawerLayout_GetView(env: PJNIEnv; _jsdrawerlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsdrawerlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsDrawerLayout_SetLParamWidth(env: PJNIEnv; _jsdrawerlayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_SetLParamHeight(env: PJNIEnv; _jsdrawerlayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsDrawerLayout_GetLParamWidth(env: PJNIEnv; _jsdrawerlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jsdrawerlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsDrawerLayout_GetLParamHeight(env: PJNIEnv; _jsdrawerlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jsdrawerlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_SetLGravity(env: PJNIEnv; _jsdrawerlayout: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_SetLWeight(env: PJNIEnv; _jsdrawerlayout: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsdrawerlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_AddLParamsAnchorRule(env: PJNIEnv; _jsdrawerlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_AddLParamsParentRule(env: PJNIEnv; _jsdrawerlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_SetLayoutAll(env: PJNIEnv; _jsdrawerlayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_ClearLayoutAll(env: PJNIEnv; _jsdrawerlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsdrawerlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_SetId(env: PJNIEnv; _jsdrawerlayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsDrawerLayout_CloseDrawer(env: PJNIEnv; _jsdrawerlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'CloseDrawer', '()V');
  env^.CallVoidMethod(env, _jsdrawerlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_CloseDrawers(env: PJNIEnv; _jsdrawerlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'CloseDrawers', '()V');
  env^.CallVoidMethod(env, _jsdrawerlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_OpenDrawer(env: PJNIEnv; _jsdrawerlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'OpenDrawer', '()V');
  env^.CallVoidMethod(env, _jsdrawerlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsDrawerLayout_SetupDrawerToggle(env: PJNIEnv; _jsdrawerlayout: JObject; _toolbar: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _toolbar;
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetupDrawerToggle', '(Landroid/support/v7/widget/Toolbar;)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsDrawerLayout_SetFitsSystemWindows(env: PJNIEnv; _jsdrawerlayout: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsdrawerlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jsdrawerlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
