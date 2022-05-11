unit sdrawerlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/16/2017 3:31:21]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsDrawerLayout = class(jVisualControl)
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
    
    //procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent(); override;
    function GetView(): jObject;  override;
    function GetWidth(): integer; override;
    function GetHeight(): integer; override;
    procedure SetLGravity(_g: integer);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    
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
procedure jsDrawerLayout_SetLGravity(env: PJNIEnv; _jsdrawerlayout: JObject; _g: integer);
procedure jsDrawerLayout_SetLWeight(env: PJNIEnv; _jsdrawerlayout: JObject; _w: single);
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


{---------  jsDrawerLayout  --------------}

constructor jsDrawerLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 0;
  FMarginTop    := 0;
  FMarginBottom := 0;
  FMarginRight  := 0;
  FHeight       := 96; //??
  FWidth        := 192; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpMatchParent;  //lpMatchParent
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

procedure jsDrawerLayout.Init;
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

   jsDrawerLayout_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   jsDrawerLayout_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
                  FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                  sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, FMarginLeft + FMarginRight ),
                  -1); // OnlyWork MATCH_PARENT

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsDrawerLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsDrawerLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsDrawerLayout_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FFitsSystemWindows  then
     jsDrawerLayout_SetFitsSystemWindows(gApp.jni.jEnv, FjObject, FFitsSystemWindows);

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jsDrawerLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsDrawerLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jsDrawerLayout.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jsDrawerLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
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
   Result:= jsDrawerLayout_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jsDrawerLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jsDrawerLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jsDrawerLayout.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsDrawerLayout_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jsDrawerLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jsDrawerLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsDrawerLayout_GetView(gApp.jni.jEnv, FjObject);
end;

function jsDrawerLayout.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
   Result := sysGetWidthOfParent(FParent)
  else
   Result:= jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetLParamWidth' );
end;

function jsDrawerLayout.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
   Result := sysGetHeightOfParent(FParent)
  else
   Result:= jni_func_out_i(gApp.jni.jEnv, FjObject, 'GetLParamHeight' );
end;

procedure jsDrawerLayout.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure jsDrawerLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsDrawerLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsDrawerLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsDrawerLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsDrawerLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jsDrawerLayout.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsDrawerLayout_clearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsDrawerLayout_addlParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsDrawerLayout_addlParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

{
procedure jsDrawerLayout.CloseDrawer();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_CloseDrawer(gApp.jni.jEnv, FjObject);
end;
}

procedure jsDrawerLayout.CloseDrawers();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_CloseDrawers(gApp.jni.jEnv, FjObject);
end;

procedure jsDrawerLayout.OpenDrawer();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_OpenDrawer(gApp.jni.jEnv, FjObject);
end;

procedure jsDrawerLayout.SetupDrawerToggle(_toolbar: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsDrawerLayout_SetupDrawerToggle(gApp.jni.jEnv, FjObject, _toolbar);
end;

procedure jsDrawerLayout.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsDrawerLayout_SetFitsSystemWindows(gApp.jni.jEnv, FjObject, _value);
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
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
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
