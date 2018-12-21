unit framelayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/13/2017 17:22:00]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jFrameLayout = class(jVisualControl)
 private
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;

    procedure ClearLayout();
    procedure UpdateLayout; override;

    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetViewParent(): jObject;  override;
    procedure RemoveFromViewParent(); override;
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
    procedure SetId(_id: integer);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jFrameLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jFrameLayout_jFree(env: PJNIEnv; _jframelayout: JObject);
procedure jFrameLayout_SetViewParent(env: PJNIEnv; _jframelayout: JObject; _viewgroup: jObject);
function jFrameLayout_GetParent(env: PJNIEnv; _jframelayout: JObject): jObject;
procedure jFrameLayout_RemoveFromViewParent(env: PJNIEnv; _jframelayout: JObject);
function jFrameLayout_GetView(env: PJNIEnv; _jframelayout: JObject): jObject;
procedure jFrameLayout_SetLParamWidth(env: PJNIEnv; _jframelayout: JObject; _w: integer);
procedure jFrameLayout_SetLParamHeight(env: PJNIEnv; _jframelayout: JObject; _h: integer);
function jFrameLayout_GetLParamWidth(env: PJNIEnv; _jframelayout: JObject): integer;
function jFrameLayout_GetLParamHeight(env: PJNIEnv; _jframelayout: JObject): integer;
procedure jFrameLayout_SetLGravity(env: PJNIEnv; _jframelayout: JObject; _g: integer);
procedure jFrameLayout_SetLWeight(env: PJNIEnv; _jframelayout: JObject; _w: single);
procedure jFrameLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jframelayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jFrameLayout_AddLParamsAnchorRule(env: PJNIEnv; _jframelayout: JObject; _rule: integer);
procedure jFrameLayout_AddLParamsParentRule(env: PJNIEnv; _jframelayout: JObject; _rule: integer);
procedure jFrameLayout_SetLayoutAll(env: PJNIEnv; _jframelayout: JObject; _idAnchor: integer);
procedure jFrameLayout_ClearLayoutAll(env: PJNIEnv; _jframelayout: JObject);
procedure jFrameLayout_SetId(env: PJNIEnv; _jframelayout: JObject; _id: integer);


implementation

{---------  jFrameLayout  --------------}

constructor jFrameLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 96; //??
  FWidth        := 192; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpMatchParent;
  FAcceptChildrenAtDesignTime:= True;
//your code here....
end;

destructor jFrameLayout.Destroy;
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

procedure jFrameLayout.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject:= jCreate(); //jSelf !

   if FParent <> nil then
   sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   jFrameLayout_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jFrameLayout_SetId(FjEnv, FjObject, Self.Id);
  end;

  jFrameLayout_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jFrameLayout_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jFrameLayout_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jFrameLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jFrameLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jFrameLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jFrameLayout.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jFrameLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jFrameLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jFrameLayout.jCreate(): jObject;
begin
   Result:= jFrameLayout_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jFrameLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_jFree(FjEnv, FjObject);
end;

procedure jFrameLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jFrameLayout.GetViewParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jFrameLayout_GetParent(FjEnv, FjObject);
end;

procedure jFrameLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_RemoveFromViewParent(FjEnv, FjObject);
end;

function jFrameLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jFrameLayout_GetView(FjEnv, FjObject);
end;

procedure jFrameLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jFrameLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jFrameLayout.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  Result:= jFrameLayout_getLParamWidth(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetWidthOfParent(FParent);
end;

function jFrameLayout.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  Result:= jFrameLayout_getLParamHeight(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetHeightOfParent(FParent);
end;

procedure jFrameLayout.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jFrameLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jFrameLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jFrameLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jFrameLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jFrameLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jFrameLayout.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jFrameLayout_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jFrameLayout_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jFrameLayout_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jFrameLayout.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jFrameLayout_SetId(FjEnv, FjObject, _id);
end;

{-------- jFrameLayout_JNI_Bridge ----------}

function jFrameLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jFrameLayout_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jFrameLayout_jCreate(long _Self) {
  return (java.lang.Object)(new jFrameLayout(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jFrameLayout_jFree(env: PJNIEnv; _jframelayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jframelayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_SetViewParent(env: PJNIEnv; _jframelayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jframelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jFrameLayout_GetParent(env: PJNIEnv; _jframelayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jframelayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_RemoveFromViewParent(env: PJNIEnv; _jframelayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jframelayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jFrameLayout_GetView(env: PJNIEnv; _jframelayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jframelayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_SetLParamWidth(env: PJNIEnv; _jframelayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jframelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_SetLParamHeight(env: PJNIEnv; _jframelayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jframelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jFrameLayout_GetLParamWidth(env: PJNIEnv; _jframelayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jframelayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jFrameLayout_GetLParamHeight(env: PJNIEnv; _jframelayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jframelayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_SetLGravity(env: PJNIEnv; _jframelayout: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jframelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_SetLWeight(env: PJNIEnv; _jframelayout: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jframelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jframelayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jframelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_AddLParamsAnchorRule(env: PJNIEnv; _jframelayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jframelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_AddLParamsParentRule(env: PJNIEnv; _jframelayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jframelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_SetLayoutAll(env: PJNIEnv; _jframelayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jframelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_ClearLayoutAll(env: PJNIEnv; _jframelayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jframelayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jFrameLayout_SetId(env: PJNIEnv; _jframelayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jframelayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jframelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;



end.
