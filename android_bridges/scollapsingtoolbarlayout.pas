unit scollapsingtoolbarlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [1/3/2018 19:08:18]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsCollapsingToolbarLayout = class(jVisualControl)
 private
    FFitsSystemWindows: boolean;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent();  override;
    function GetView(): jObject; override;
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
    procedure ClearLayout();
    procedure SetId(_id: integer);
    procedure SetScrollFlag(_collapsingScrollFlag: TCollapsingScrollflag);
    procedure SetExpandedTitleColorTransparent();
    procedure SetExpandedTitleColor(_color: TARGBColorBridge);
    procedure SetExpandedTitleGravity(_gravity: TLayoutGravity);
    procedure SetCollapsedTitleTextColor(_color: TARGBColorBridge);
    procedure SetCollapsedTitleGravity(_gravity: TLayoutGravity);
    procedure SetContentScrimColor(_color: TARGBColorBridge); overload;
    procedure SetContentScrimColor(_color: integer); overload;
    procedure SetFitsSystemWindows(_value: boolean);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FitsSystemWindows: boolean read FFitsSystemWindows write SetFitsSystemWindows;
    //property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jsCollapsingToolbarLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsCollapsingToolbarLayout_jFree(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject);
procedure jsCollapsingToolbarLayout_SetViewParent(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _viewgroup: jObject);
function jsCollapsingToolbarLayout_GetParent(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject): jObject;
procedure jsCollapsingToolbarLayout_RemoveFromViewParent(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject);
function jsCollapsingToolbarLayout_GetView(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject): jObject;
procedure jsCollapsingToolbarLayout_SetLParamWidth(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _w: integer);
procedure jsCollapsingToolbarLayout_SetLParamHeight(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _h: integer);
function jsCollapsingToolbarLayout_GetLParamWidth(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject): integer;
function jsCollapsingToolbarLayout_GetLParamHeight(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject): integer;
procedure jsCollapsingToolbarLayout_SetLGravity(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _g: integer);
procedure jsCollapsingToolbarLayout_SetLWeight(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _w: single);
procedure jsCollapsingToolbarLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsCollapsingToolbarLayout_AddLParamsAnchorRule(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _rule: integer);
procedure jsCollapsingToolbarLayout_AddLParamsParentRule(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _rule: integer);
procedure jsCollapsingToolbarLayout_SetLayoutAll(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _idAnchor: integer);
procedure jsCollapsingToolbarLayout_ClearLayoutAll(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject);
procedure jsCollapsingToolbarLayout_SetId(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _id: integer);
procedure jsCollapsingToolbarLayout_SetExpandedTitleColorTransparent(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject);
procedure jsCollapsingToolbarLayout_SetExpandedTitleColor(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _color: integer);
procedure jsCollapsingToolbarLayout_SetExpandedTitleGravity(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _gravity: integer);
procedure jsCollapsingToolbarLayout_SetCollapsedTitleTextColor(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _color: integer);
procedure jsCollapsingToolbarLayout_SetCollapsedTitleGravity(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _gravity: integer);
procedure jsCollapsingToolbarLayout_SetContentScrimColor(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _color: integer);
procedure jsCollapsingToolbarLayout_SetScrollFlag(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _collapsingScrollFlag: integer);
procedure jsCollapsingToolbarLayout_SetFitsSystemWindows(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _value: boolean);


implementation

{---------  jsCollapsingToolbarLayout  --------------}

constructor jsCollapsingToolbarLayout.Create(AOwner: TComponent);
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

destructor jsCollapsingToolbarLayout.Destroy;
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

procedure jsCollapsingToolbarLayout.Init(refApp: jApp);
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
   sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

  FjPRLayoutHome:= FjPRLayout;

  jsCollapsingToolbarLayout_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsCollapsingToolbarLayout_SetId(FjEnv, FjObject, Self.Id);
  jsCollapsingToolbarLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsCollapsingToolbarLayout_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsCollapsingToolbarLayout_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsCollapsingToolbarLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FFitsSystemWindows  then
     jsCollapsingToolbarLayout_SetFitsSystemWindows(FjEnv, FjObject, FFitsSystemWindows);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsCollapsingToolbarLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsCollapsingToolbarLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsCollapsingToolbarLayout.UpdateLParamWidth;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      jsCollapsingToolbarLayout_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdw));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsCollapsingToolbarLayout_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsCollapsingToolbarLayout_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsCollapsingToolbarLayout.UpdateLParamHeight;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
       jsCollapsingToolbarLayout_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdh));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsCollapsingToolbarLayout_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsCollapsingToolbarLayout_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsCollapsingToolbarLayout.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsCollapsingToolbarLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsCollapsingToolbarLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsCollapsingToolbarLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsCollapsingToolbarLayout.jCreate(): jObject;
begin
   Result:= jsCollapsingToolbarLayout_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsCollapsingToolbarLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_jFree(FjEnv, FjObject);
end;

procedure jsCollapsingToolbarLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsCollapsingToolbarLayout.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsCollapsingToolbarLayout_GetParent(FjEnv, FjObject);
end;

procedure jsCollapsingToolbarLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsCollapsingToolbarLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsCollapsingToolbarLayout_GetView(FjEnv, FjObject);
end;

procedure jsCollapsingToolbarLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsCollapsingToolbarLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsCollapsingToolbarLayout.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  Result:= jsCollapsingToolbarLayout_getLParamWidth(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetWidthOfParent(FParent);
end;

function jsCollapsingToolbarLayout.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  Result:= jsCollapsingToolbarLayout_getLParamHeight(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetHeightOfParent(FParent);
end;

procedure jsCollapsingToolbarLayout.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jsCollapsingToolbarLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsCollapsingToolbarLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsCollapsingToolbarLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsCollapsingToolbarLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsCollapsingToolbarLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsCollapsingToolbarLayout.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsCollapsingToolbarLayout_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsCollapsingToolbarLayout_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsCollapsingToolbarLayout_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsCollapsingToolbarLayout.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetId(FjEnv, FjObject, _id);
end;

procedure jsCollapsingToolbarLayout.SetScrollFlag(_collapsingScrollFlag: TCollapsingScrollflag);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetScrollFlag(FjEnv, FjObject, Ord(_collapsingScrollFlag) );
end;

procedure jsCollapsingToolbarLayout.SetExpandedTitleColorTransparent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetExpandedTitleColorTransparent(FjEnv, FjObject);
end;

procedure jsCollapsingToolbarLayout.SetExpandedTitleColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetExpandedTitleColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsCollapsingToolbarLayout.SetExpandedTitleGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetExpandedTitleGravity(FjEnv, FjObject, Ord(_gravity));
end;

procedure jsCollapsingToolbarLayout.SetCollapsedTitleTextColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetCollapsedTitleTextColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsCollapsingToolbarLayout.SetCollapsedTitleGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetCollapsedTitleGravity(FjEnv, FjObject, Ord(_gravity));
end;

procedure jsCollapsingToolbarLayout.SetContentScrimColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetContentScrimColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsCollapsingToolbarLayout.SetContentScrimColor(_color: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetContentScrimColor(FjEnv, FjObject, _color);
end;

procedure jsCollapsingToolbarLayout.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsCollapsingToolbarLayout_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

{-------- jsCollapsingToolbarLayout_JNI_Bridge ----------}

function jsCollapsingToolbarLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsCollapsingToolbarLayout_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsCollapsingToolbarLayout_jFree(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jscollapsingtoolbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetViewParent(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCollapsingToolbarLayout_GetParent(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jscollapsingtoolbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_RemoveFromViewParent(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jscollapsingtoolbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCollapsingToolbarLayout_GetView(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jscollapsingtoolbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetLParamWidth(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetLParamHeight(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCollapsingToolbarLayout_GetLParamWidth(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jscollapsingtoolbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCollapsingToolbarLayout_GetLParamHeight(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jscollapsingtoolbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetLGravity(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetLWeight(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_AddLParamsAnchorRule(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_AddLParamsParentRule(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetLayoutAll(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_ClearLayoutAll(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jscollapsingtoolbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetId(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsCollapsingToolbarLayout_SetScrollFlag(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _collapsingScrollFlag: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _collapsingScrollFlag;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScrollFlag', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;



procedure jsCollapsingToolbarLayout_SetExpandedTitleColorTransparent(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetExpandedTitleColorTransparent', '()V');
  env^.CallVoidMethod(env, _jscollapsingtoolbarlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetExpandedTitleColor(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetExpandedTitleColor', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetExpandedTitleGravity(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _gravity: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _gravity;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetExpandedTitleGravity', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetCollapsedTitleTextColor(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCollapsedTitleTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetCollapsedTitleGravity(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _gravity: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _gravity;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCollapsedTitleGravity', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCollapsingToolbarLayout_SetContentScrimColor(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetContentScrimColor', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsCollapsingToolbarLayout_SetFitsSystemWindows(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
