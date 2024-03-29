unit linearlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

 TLinearLayoutOrientation = (loHorizontal, loVertical);
{Draft Component code by "Lazarus Android Module Wizard" [12/17/2017 1:52:22]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jLinearLayout = class(jVisualControl)
 private
    FOrientation: TLinearLayoutOrientation;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;

    procedure ClearLayout();
    procedure UpdateLayout; override;

    //procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetViewParent(): jObject; override;
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

    procedure SetOrientation(_orientation: TLinearLayoutOrientation);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Orientation: TLinearLayoutOrientation read FOrientation write SetOrientation;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    //property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jLinearLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jLinearLayout_jFree(env: PJNIEnv; _jlinearlayout: JObject);
procedure jLinearLayout_SetViewParent(env: PJNIEnv; _jlinearlayout: JObject; _viewgroup: jObject);
function jLinearLayout_GetParent(env: PJNIEnv; _jlinearlayout: JObject): jObject;
procedure jLinearLayout_RemoveFromViewParent(env: PJNIEnv; _jlinearlayout: JObject);
function jLinearLayout_GetView(env: PJNIEnv; _jlinearlayout: JObject): jObject;
procedure jLinearLayout_SetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject; _w: integer);
procedure jLinearLayout_SetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject; _h: integer);
function jLinearLayout_GetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject): integer;
function jLinearLayout_GetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject): integer;
procedure jLinearLayout_SetLGravity(env: PJNIEnv; _jlinearlayout: JObject; _g: integer);
procedure jLinearLayout_SetLWeight(env: PJNIEnv; _jlinearlayout: JObject; _w: single);
procedure jLinearLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jlinearlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jLinearLayout_AddLParamsAnchorRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
procedure jLinearLayout_AddLParamsParentRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
procedure jLinearLayout_SetLayoutAll(env: PJNIEnv; _jlinearlayout: JObject; _idAnchor: integer);
procedure jLinearLayout_ClearLayoutAll(env: PJNIEnv; _jlinearlayout: JObject);
procedure jLinearLayout_SetId(env: PJNIEnv; _jlinearlayout: JObject; _id: integer);
procedure jLinearLayout_SetOrientation(env: PJNIEnv; _jlinearlayout: JObject; _orientation: integer);


implementation

{---------  jLinearLayout  --------------}

constructor jLinearLayout.Create(AOwner: TComponent);
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
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;
//your code here....
 //FOrientation:= loHorizontal;
end;

destructor jLinearLayout.Destroy;
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

procedure jLinearLayout.Init;
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

   if FOrientation <> loHorizontal then
       jLinearLayout_SetOrientation(gApp.jni.jEnv, FjObject, Ord(FOrientation));

   if FGravityInParent <> lgNone then
     jLinearLayout_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent) );

   jLinearLayout_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   jLinearLayout_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  jLinearLayout_setLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jLinearLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jLinearLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jLinearLayout_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   
   if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jLinearLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jLinearLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jLinearLayout.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jLinearLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

(*
//Event : Java -> Pascal
procedure jLinearLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jLinearLayout.jCreate(): jObject;
begin
   Result:= jLinearLayout_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jLinearLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jLinearLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jLinearLayout.GetViewParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLinearLayout_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jLinearLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jLinearLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLinearLayout_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jLinearLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jLinearLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jLinearLayout.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
   Result := sysGetWidthOfParent(FParent)
  else
   Result:= jLinearLayout_getLParamWidth(gApp.jni.jEnv, FjObject );
end;

function jLinearLayout.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
   Result := sysGetHeightOfParent(FParent)
  else
   Result:= jLinearLayout_getLParamHeight(gApp.jni.jEnv, FjObject );
end;

procedure jLinearLayout.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FInitialized then
     jLinearLayout_SetLGravity(gApp.jni.jEnv, FjObject, Ord(_gravity) );
end;

procedure jLinearLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jLinearLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jLinearLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jLinearLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jLinearLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jLinearLayout.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jLinearLayout_clearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jLinearLayout_addlParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jLinearLayout_addlParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jLinearLayout.SetOrientation(_orientation: TLinearLayoutOrientation);
begin
  //in designing component state: set value here...
  FOrientation:= _orientation;
  if FInitialized then
     jLinearLayout_SetOrientation(gApp.jni.jEnv, FjObject, Ord(FOrientation));
end;

{-------- jLinearLayout_JNI_Bridge ----------}

function jLinearLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jLinearLayout_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jLinearLayout_jCreate(long _Self) {
  return (java.lang.Object)(new jLinearLayout(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jLinearLayout_jFree(env: PJNIEnv; _jlinearlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetViewParent(env: PJNIEnv; _jlinearlayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetParent(env: PJNIEnv; _jlinearlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_RemoveFromViewParent(env: PJNIEnv; _jlinearlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetView(env: PJNIEnv; _jlinearlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLGravity(env: PJNIEnv; _jlinearlayout: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLWeight(env: PJNIEnv; _jlinearlayout: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jlinearlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_AddLParamsAnchorRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_AddLParamsParentRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLayoutAll(env: PJNIEnv; _jlinearlayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_ClearLayoutAll(env: PJNIEnv; _jlinearlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetId(env: PJNIEnv; _jlinearlayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetOrientation(env: PJNIEnv; _jlinearlayout: JObject; _orientation: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _orientation;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetOrientation', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;



end.
