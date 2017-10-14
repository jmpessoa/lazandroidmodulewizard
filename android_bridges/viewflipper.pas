unit viewflipper;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [2/5/2017 17:18:46]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jViewFlipper = class(jVisualControl)
 private
    FOnFling: TOnFling;
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
    procedure ClearLayout;

    procedure GenEvent_OnClick(Obj: TObject);
    procedure GenEvent_OnFlingGestureDetected(Obj: TObject; direction: integer);

    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent();
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
    procedure SetAutoStart(_value: boolean);
    procedure SetFlipInterval(_milliseconds: integer);
    procedure StartFlipping();
    procedure StopFlipping();
    procedure AddView(_layout: jObject);
    procedure Next();
    procedure Previous();
 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnFlingGesture: TOnFling read FOnFling write FOnFling;
end;

function jViewFlipper_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jViewFlipper_jFree(env: PJNIEnv; _jviewflipper: JObject);
procedure jViewFlipper_SetViewParent(env: PJNIEnv; _jviewflipper: JObject; _viewgroup: jObject);
function jViewFlipper_GetParent(env: PJNIEnv; _jviewflipper: JObject): jObject;
procedure jViewFlipper_RemoveFromViewParent(env: PJNIEnv; _jviewflipper: JObject);
function jViewFlipper_GetView(env: PJNIEnv; _jviewflipper: JObject): jObject;
procedure jViewFlipper_SetLParamWidth(env: PJNIEnv; _jviewflipper: JObject; _w: integer);
procedure jViewFlipper_SetLParamHeight(env: PJNIEnv; _jviewflipper: JObject; _h: integer);
function jViewFlipper_GetLParamWidth(env: PJNIEnv; _jviewflipper: JObject): integer;
function jViewFlipper_GetLParamHeight(env: PJNIEnv; _jviewflipper: JObject): integer;
procedure jViewFlipper_SetLGravity(env: PJNIEnv; _jviewflipper: JObject; _g: integer);
procedure jViewFlipper_SetLWeight(env: PJNIEnv; _jviewflipper: JObject; _w: single);
procedure jViewFlipper_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jviewflipper: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jViewFlipper_AddLParamsAnchorRule(env: PJNIEnv; _jviewflipper: JObject; _rule: integer);
procedure jViewFlipper_AddLParamsParentRule(env: PJNIEnv; _jviewflipper: JObject; _rule: integer);
procedure jViewFlipper_SetLayoutAll(env: PJNIEnv; _jviewflipper: JObject; _idAnchor: integer);
procedure jViewFlipper_ClearLayoutAll(env: PJNIEnv; _jviewflipper: JObject);
procedure jViewFlipper_SetId(env: PJNIEnv; _jviewflipper: JObject; _id: integer);
procedure jViewFlipper_SetAutoStart(env: PJNIEnv; _jviewflipper: JObject; _value: boolean);
procedure jViewFlipper_SetFlipInterval(env: PJNIEnv; _jviewflipper: JObject; _milliseconds: integer);
procedure jViewFlipper_StartFlipping(env: PJNIEnv; _jviewflipper: JObject);
procedure jViewFlipper_StopFlipping(env: PJNIEnv; _jviewflipper: JObject);
procedure jViewFlipper_AddView(env: PJNIEnv; _jviewflipper: JObject; _layout: jObject);
procedure jViewFlipper_Next(env: PJNIEnv; _jviewflipper: JObject);
procedure jViewFlipper_Previous(env: PJNIEnv; _jviewflipper: JObject);

implementation

uses
   customdialog, toolbar;

{---------  jViewFlipper  --------------}

constructor jViewFlipper.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 96; //??
  FWidth        := 96; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpOneThirdOfParent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;
//your code here....
end;

destructor jViewFlipper.Destroy;
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

procedure jViewFlipper.Init(refApp: jApp);
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
    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;
    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
    end;
    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;
    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;
  end;

  jViewFlipper_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jViewFlipper_SetId(FjEnv, FjObject, Self.Id);
  jViewFlipper_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jViewFlipper_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jViewFlipper_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jViewFlipper_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jViewFlipper.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jViewFlipper.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jViewFlipper.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jViewFlipper_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jViewFlipper_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jViewFlipper_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jViewFlipper.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jViewFlipper_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jViewFlipper_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jViewFlipper_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jViewFlipper.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jViewFlipper_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jViewFlipper.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jViewFlipper.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jViewFlipper_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jViewFlipper_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jViewFlipper_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jViewFlipper.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jViewFlipper.jCreate(): jObject;
begin
   Result:= jViewFlipper_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jViewFlipper.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_jFree(FjEnv, FjObject);
end;

procedure jViewFlipper.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jViewFlipper.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jViewFlipper_GetParent(FjEnv, FjObject);
end;

procedure jViewFlipper.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_RemoveFromViewParent(FjEnv, FjObject);
end;

function jViewFlipper.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jViewFlipper_GetView(FjEnv, FjObject);
end;

procedure jViewFlipper.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jViewFlipper.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jViewFlipper.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jViewFlipper_GetLParamWidth(FjEnv, FjObject);
end;

function jViewFlipper.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jViewFlipper_GetLParamHeight(FjEnv, FjObject);
end;

procedure jViewFlipper.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jViewFlipper.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jViewFlipper.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jViewFlipper.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jViewFlipper.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jViewFlipper.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jViewFlipper.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jViewFlipper.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_SetId(FjEnv, FjObject, _id);
end;

procedure jViewFlipper.SetAutoStart(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_SetAutoStart(FjEnv, FjObject, _value);
end;

procedure jViewFlipper.SetFlipInterval(_milliseconds: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_SetFlipInterval(FjEnv, FjObject, _milliseconds);
end;

procedure jViewFlipper.StartFlipping();
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_StartFlipping(FjEnv, FjObject);
end;

procedure jViewFlipper.StopFlipping();
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_StopFlipping(FjEnv, FjObject);
end;

procedure jViewFlipper.AddView(_layout: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_AddView(FjEnv, FjObject, _layout);
end;

procedure jViewFlipper.Next();
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_Next(FjEnv, FjObject);
end;

procedure jViewFlipper.Previous();
begin
  //in designing component state: set value here...
  if FInitialized then
     jViewFlipper_Previous(FjEnv, FjObject);
end;

procedure jViewFlipper.GenEvent_OnFlingGestureDetected(Obj: TObject; direction: integer);
begin
  if Assigned(FOnFling) then  FOnFling(Obj, TFlingGesture(direction));
end;

{-------- jViewFlipper_JNI_Bridge ----------}

function jViewFlipper_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jViewFlipper_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jViewFlipper_jCreate(long _Self) {
  return (java.lang.Object)(new jViewFlipper(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jViewFlipper_jFree(env: PJNIEnv; _jviewflipper: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_SetViewParent(env: PJNIEnv; _jviewflipper: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jViewFlipper_GetParent(env: PJNIEnv; _jviewflipper: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_RemoveFromViewParent(env: PJNIEnv; _jviewflipper: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jViewFlipper_GetView(env: PJNIEnv; _jviewflipper: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_SetLParamWidth(env: PJNIEnv; _jviewflipper: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_SetLParamHeight(env: PJNIEnv; _jviewflipper: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jViewFlipper_GetLParamWidth(env: PJNIEnv; _jviewflipper: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jViewFlipper_GetLParamHeight(env: PJNIEnv; _jviewflipper: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_SetLGravity(env: PJNIEnv; _jviewflipper: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_SetLWeight(env: PJNIEnv; _jviewflipper: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jviewflipper: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_AddLParamsAnchorRule(env: PJNIEnv; _jviewflipper: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_AddLParamsParentRule(env: PJNIEnv; _jviewflipper: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_SetLayoutAll(env: PJNIEnv; _jviewflipper: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_ClearLayoutAll(env: PJNIEnv; _jviewflipper: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_SetId(env: PJNIEnv; _jviewflipper: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_SetAutoStart(env: PJNIEnv; _jviewflipper: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAutoStart', '(Z)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_SetFlipInterval(env: PJNIEnv; _jviewflipper: JObject; _milliseconds: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _milliseconds;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFlipInterval', '(I)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_StartFlipping(env: PJNIEnv; _jviewflipper: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'StartFlipping', '()V');
  env^.CallVoidMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_StopFlipping(env: PJNIEnv; _jviewflipper: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'StopFlipping', '()V');
  env^.CallVoidMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jViewFlipper_AddView(env: PJNIEnv; _jviewflipper: JObject; _layout: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _layout;
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'AddView', '(Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jviewflipper, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jViewFlipper_Next(env: PJNIEnv; _jviewflipper: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'Next', '()V');
  env^.CallVoidMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jViewFlipper_Previous(env: PJNIEnv; _jviewflipper: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jviewflipper);
  jMethod:= env^.GetMethodID(env, jCls, 'Previous', '()V');
  env^.CallVoidMethod(env, _jviewflipper, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
