unit sappbarlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

{Draft Component code by "Lazarus Android Module Wizard" [1/3/2018 18:07:27]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsAppBarLayout = class(jVisualControl)
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
    procedure ClearLayout();
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetBackgroundToPrimaryColor();
    procedure SetExpanded(expanded: boolean; animation: boolean);

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
procedure jsAppBarLayout_SetExpanded(env: PJNIEnv; _jsappbarlayout: JObject; expanded: boolean; animation: boolean);

implementation

{---------  jsAppBarLayout  --------------}

constructor jsAppBarLayout.Create(AOwner: TComponent);
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

procedure jsAppBarLayout.Init;
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

   jsAppBarLayout_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   jsAppBarLayout_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  jsAppBarLayout_setLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsAppBarLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsAppBarLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsAppBarLayout_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FFitsSystemWindows  then
     jsAppBarLayout_SetFitsSystemWindows(gApp.jni.jEnv, FjObject, FFitsSystemWindows);

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jsAppBarLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsAppBarLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jsAppBarLayout.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jsAppBarLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
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
   Result:= jsAppBarLayout_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jsAppBarLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jsAppBarLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jsAppBarLayout.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsAppBarLayout_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jsAppBarLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jsAppBarLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsAppBarLayout_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jsAppBarLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsAppBarLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jsAppBarLayout.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
   Result := sysGetWidthOfParent(FParent)
  else
   Result:= jsAppBarLayout_getLParamWidth(gApp.jni.jEnv, FjObject );
end;

function jsAppBarLayout.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
   Result := sysGetHeightOfParent(FParent)
  else
   Result:= jsAppBarLayout_getLParamHeight(gApp.jni.jEnv, FjObject );
end;

procedure jsAppBarLayout.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure jsAppBarLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsAppBarLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsAppBarLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsAppBarLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsAppBarLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jsAppBarLayout.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsAppBarLayout_clearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsAppBarLayout_addlParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsAppBarLayout_addlParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsAppBarLayout.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsAppBarLayout_SetFitsSystemWindows(gApp.jni.jEnv, FjObject, _value);
end;

procedure jsAppBarLayout.SetBackgroundToPrimaryColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetBackgroundToPrimaryColor(gApp.jni.jEnv, FjObject);
end;

procedure jsAppBarLayout.SetExpanded(expanded: boolean; animation: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAppBarLayout_SetExpanded(gApp.jni.jEnv, FjObject, expanded ,animation);
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
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
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

procedure jsAppBarLayout_SetExpanded(env: PJNIEnv; _jsappbarlayout: JObject; expanded: boolean; animation: boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jsappbarlayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetExpanded', '(ZZ)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].z:= JBool(expanded);
  jParams[1].z:= JBool(animation);

  env^.CallVoidMethodA(env, _jsappbarlayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

end.
