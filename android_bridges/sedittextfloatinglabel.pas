unit sedittextfloatinglabel;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/30/2017 0:18:06]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsEditTextFloatingLabel = class(jVisualControl)
 private
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
    procedure SetViewParent(_viewgroup: jObject);
    function GetParent(): jObject;
    procedure RemoveFromViewParent();
    function GetView(): jObject;
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
    procedure ClearLayout();
    
 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jsEditTextFloatingLabel_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsEditTextFloatingLabel_jFree(env: PJNIEnv; _jsedittextfloatinglabel: JObject);
procedure jsEditTextFloatingLabel_SetViewParent(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _viewgroup: jObject);
function jsEditTextFloatingLabel_GetParent(env: PJNIEnv; _jsedittextfloatinglabel: JObject): jObject;
procedure jsEditTextFloatingLabel_RemoveFromViewParent(env: PJNIEnv; _jsedittextfloatinglabel: JObject);
function jsEditTextFloatingLabel_GetView(env: PJNIEnv; _jsedittextfloatinglabel: JObject): jObject;
procedure jsEditTextFloatingLabel_SetLParamWidth(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _w: integer);
procedure jsEditTextFloatingLabel_SetLParamHeight(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _h: integer);
function jsEditTextFloatingLabel_GetLParamWidth(env: PJNIEnv; _jsedittextfloatinglabel: JObject): integer;
function jsEditTextFloatingLabel_GetLParamHeight(env: PJNIEnv; _jsedittextfloatinglabel: JObject): integer;
procedure jsEditTextFloatingLabel_SetLGravity(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _g: integer);
procedure jsEditTextFloatingLabel_SetLWeight(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _w: single);
procedure jsEditTextFloatingLabel_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsEditTextFloatingLabel_AddLParamsAnchorRule(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _rule: integer);
procedure jsEditTextFloatingLabel_AddLParamsParentRule(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _rule: integer);
procedure jsEditTextFloatingLabel_SetLayoutAll(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _idAnchor: integer);
procedure jsEditTextFloatingLabel_ClearLayoutAll(env: PJNIEnv; _jsedittextfloatinglabel: JObject);
procedure jsEditTextFloatingLabel_SetId(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _id: integer);


implementation

{---------  jsEditTextFloatingLabel  --------------}

constructor jsEditTextFloatingLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 96; //??
  FWidth        := 96; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor jsEditTextFloatingLabel.Destroy;
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

procedure jsEditTextFloatingLabel.Init;
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

   jsEditTextFloatingLabel_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   jsEditTextFloatingLabel_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  jsEditTextFloatingLabel_setLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsEditTextFloatingLabel_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsEditTextFloatingLabel_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsEditTextFloatingLabel_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jsEditTextFloatingLabel.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsEditTextFloatingLabel.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jsEditTextFloatingLabel.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jsEditTextFloatingLabel.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsEditTextFloatingLabel.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsEditTextFloatingLabel.jCreate(): jObject;
begin
   Result:= jsEditTextFloatingLabel_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jsEditTextFloatingLabel.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jsEditTextFloatingLabel.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jsEditTextFloatingLabel.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsEditTextFloatingLabel_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jsEditTextFloatingLabel.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jsEditTextFloatingLabel.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsEditTextFloatingLabel_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jsEditTextFloatingLabel.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsEditTextFloatingLabel.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jsEditTextFloatingLabel.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsEditTextFloatingLabel_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jsEditTextFloatingLabel.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsEditTextFloatingLabel_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jsEditTextFloatingLabel.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure jsEditTextFloatingLabel.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsEditTextFloatingLabel.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsEditTextFloatingLabel.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsEditTextFloatingLabel.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsEditTextFloatingLabel.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jsEditTextFloatingLabel.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsEditTextFloatingLabel_clearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsEditTextFloatingLabel_addlParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsEditTextFloatingLabel_addlParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

{-------- jsEditTextFloatingLabel_JNI_Bridge ----------}

function jsEditTextFloatingLabel_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsEditTextFloatingLabel_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsEditTextFloatingLabel_jFree(env: PJNIEnv; _jsedittextfloatinglabel: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsedittextfloatinglabel, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_SetViewParent(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsEditTextFloatingLabel_GetParent(env: PJNIEnv; _jsedittextfloatinglabel: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jsedittextfloatinglabel, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_RemoveFromViewParent(env: PJNIEnv; _jsedittextfloatinglabel: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsedittextfloatinglabel, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsEditTextFloatingLabel_GetView(env: PJNIEnv; _jsedittextfloatinglabel: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsedittextfloatinglabel, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_SetLParamWidth(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_SetLParamHeight(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsEditTextFloatingLabel_GetLParamWidth(env: PJNIEnv; _jsedittextfloatinglabel: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jsedittextfloatinglabel, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsEditTextFloatingLabel_GetLParamHeight(env: PJNIEnv; _jsedittextfloatinglabel: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jsedittextfloatinglabel, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_SetLGravity(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_SetLWeight(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_AddLParamsAnchorRule(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_AddLParamsParentRule(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_SetLayoutAll(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_ClearLayoutAll(env: PJNIEnv; _jsedittextfloatinglabel: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsedittextfloatinglabel, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsEditTextFloatingLabel_SetId(env: PJNIEnv; _jsedittextfloatinglabel: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsedittextfloatinglabel);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;



end.
