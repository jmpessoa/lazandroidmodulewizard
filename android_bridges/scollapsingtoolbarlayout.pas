unit scollapsingtoolbarlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

{Draft Component code by "Lazarus Android Module Wizard" [1/3/2018 19:08:18]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsCollapsingToolbarLayout = class(jVisualControl)
 private
    FFitsSystemWindows: boolean;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
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
    procedure SetScrollFlag(_collapsingScrollFlag: TCollapsingScrollflag);
    procedure SetCollapseMode(_collapsemode: TCollapsingMode);
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
procedure jsCollapsingToolbarLayout_SetCollapseMode(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _mode: integer);

implementation

{---------  jsCollapsingToolbarLayout  --------------}

constructor jsCollapsingToolbarLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
                                                                                
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

procedure jsCollapsingToolbarLayout.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject := jCreate(); if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent);

   FjPRLayoutHome:= FjPRLayout;

   jsCollapsingToolbarLayout_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   jsCollapsingToolbarLayout_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  jsCollapsingToolbarLayout_setLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsCollapsingToolbarLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsCollapsingToolbarLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsCollapsingToolbarLayout_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FFitsSystemWindows  then
     jsCollapsingToolbarLayout_SetFitsSystemWindows(gApp.jni.jEnv, FjObject, FFitsSystemWindows);

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jsCollapsingToolbarLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsCollapsingToolbarLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jsCollapsingToolbarLayout.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jsCollapsingToolbarLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsCollapsingToolbarLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsCollapsingToolbarLayout.jCreate(): jObject;
begin
   Result:= jsCollapsingToolbarLayout_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jsCollapsingToolbarLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jsCollapsingToolbarLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jsCollapsingToolbarLayout.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsCollapsingToolbarLayout_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jsCollapsingToolbarLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jsCollapsingToolbarLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsCollapsingToolbarLayout_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jsCollapsingToolbarLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsCollapsingToolbarLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jsCollapsingToolbarLayout.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
   Result := sysGetWidthOfParent(FParent)
  else
   Result:= jsCollapsingToolbarLayout_getLParamWidth(gApp.jni.jEnv, FjObject );
end;

function jsCollapsingToolbarLayout.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
   Result := sysGetHeightOfParent(FParent)
  else
   Result:= jsCollapsingToolbarLayout_getLParamHeight(gApp.jni.jEnv, FjObject );
end;

procedure jsCollapsingToolbarLayout.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure jsCollapsingToolbarLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsCollapsingToolbarLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsCollapsingToolbarLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsCollapsingToolbarLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsCollapsingToolbarLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jsCollapsingToolbarLayout.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsCollapsingToolbarLayout_clearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsCollapsingToolbarLayout_addlParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsCollapsingToolbarLayout_addlParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsCollapsingToolbarLayout.SetScrollFlag(_collapsingScrollFlag: TCollapsingScrollflag);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetScrollFlag(gApp.jni.jEnv, FjObject, Ord(_collapsingScrollFlag) );
end;

procedure jsCollapsingToolbarLayout.SetCollapseMode(_collapsemode: TCollapsingMode);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetCollapseMode(gApp.jni.jEnv, FjObject, Ord(_collapsemode));
end;

procedure jsCollapsingToolbarLayout.SetExpandedTitleColorTransparent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetExpandedTitleColorTransparent(gApp.jni.jEnv, FjObject);
end;

procedure jsCollapsingToolbarLayout.SetExpandedTitleColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetExpandedTitleColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsCollapsingToolbarLayout.SetExpandedTitleGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetExpandedTitleGravity(gApp.jni.jEnv, FjObject, Ord(_gravity));
end;

procedure jsCollapsingToolbarLayout.SetCollapsedTitleTextColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetCollapsedTitleTextColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsCollapsingToolbarLayout.SetCollapsedTitleGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetCollapsedTitleGravity(gApp.jni.jEnv, FjObject, Ord(_gravity));
end;

procedure jsCollapsingToolbarLayout.SetContentScrimColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetContentScrimColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsCollapsingToolbarLayout.SetContentScrimColor(_color: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCollapsingToolbarLayout_SetContentScrimColor(gApp.jni.jEnv, FjObject, _color);
end;

procedure jsCollapsingToolbarLayout.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsCollapsingToolbarLayout_SetFitsSystemWindows(gApp.jni.jEnv, FjObject, _value);
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
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
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

procedure jsCollapsingToolbarLayout_SetCollapseMode(env: PJNIEnv; _jscollapsingtoolbarlayout: JObject; _mode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _mode;
  jCls:= env^.GetObjectClass(env, _jscollapsingtoolbarlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCollapseMode', '(I)V');
  env^.CallVoidMethodA(env, _jscollapsingtoolbarlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
