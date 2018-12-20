unit sfloatingbutton;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TFABSize = (fabNormal, fabMini, fabAuto); //SIZE_MINI  SIZE_AUTO  SIZE_NORMAL

{Draft Component code by "Lazarus Android Module Wizard" [12/11/2017 23:35:15]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsFloatingButton = class(jVisualControl)
 private
    FImageIdentifier: string;
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
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    function GetLParamWidth(): integer;
    function GetLParamHeight(): integer;

    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetId(_id: integer);
    procedure SetVisibility(_value: TViewVisibility);
    procedure SetCompatElevation(_value: single);
    procedure SetImageIdentifier(_imageIdentifier: string);
    procedure BringToFront();
    procedure SetSize(_value: TFABSize);
    procedure SetPressedRippleColor(_color: TARGBColorBridge);
    procedure SetContentDescription(_contentDescription: string);
    procedure ShowSnackbar(_message: string);
    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetAnchorGravity(_value: TLayoutGravity; _anchorId: integer);
    procedure SetBackgroundToPrimaryColor();

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property ImageIdentifier: string read FImageIdentifier write SetImageIdentifier;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property OnClick: TOnNotify read FOnClick write FOnClick;
end;

function jsFloatingButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsFloatingButton_jFree(env: PJNIEnv; _jsfloatingbutton: JObject);
procedure jsFloatingButton_SetViewParent(env: PJNIEnv; _jsfloatingbutton: JObject; _viewgroup: jObject);
function jsFloatingButton_GetParent(env: PJNIEnv; _jsfloatingbutton: JObject): jObject;
procedure jsFloatingButton_RemoveFromViewParent(env: PJNIEnv; _jsfloatingbutton: JObject);
function jsFloatingButton_GetView(env: PJNIEnv; _jsfloatingbutton: JObject): jObject;
procedure jsFloatingButton_SetLParamWidth(env: PJNIEnv; _jsfloatingbutton: JObject; _w: integer);
procedure jsFloatingButton_SetLParamHeight(env: PJNIEnv; _jsfloatingbutton: JObject; _h: integer);
function jsFloatingButton_GetLParamWidth(env: PJNIEnv; _jsfloatingbutton: JObject): integer;
function jsFloatingButton_GetLParamHeight(env: PJNIEnv; _jsfloatingbutton: JObject): integer;

procedure jsFloatingButton_SetLWeight(env: PJNIEnv; _jsfloatingbutton: JObject; _w: single);
procedure jsFloatingButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsfloatingbutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsFloatingButton_AddLParamsAnchorRule(env: PJNIEnv; _jsfloatingbutton: JObject; _rule: integer);
procedure jsFloatingButton_AddLParamsParentRule(env: PJNIEnv; _jsfloatingbutton: JObject; _rule: integer);
procedure jsFloatingButton_SetLayoutAll(env: PJNIEnv; _jsfloatingbutton: JObject; _idAnchor: integer);
procedure jsFloatingButton_ClearLayoutAll(env: PJNIEnv; _jsfloatingbutton: JObject);
procedure jsFloatingButton_SetId(env: PJNIEnv; _jsfloatingbutton: JObject; _id: integer);
procedure jsFloatingButton_SetVisibility(env: PJNIEnv; _jsfloatingbutton: JObject; _value: integer);
procedure jsFloatingButton_SetCompatElevation(env: PJNIEnv; _jsfloatingbutton: JObject; _value: single);
procedure jsFloatingButton_SetImage(env: PJNIEnv; _jsfloatingbutton: JObject; _imageIdentifier: string);
procedure jsFloatingButton_BringToFront(env: PJNIEnv; _jsfloatingbutton: JObject);
procedure jsFloatingButton_SetSize(env: PJNIEnv; _jsfloatingbutton: JObject; _value: integer);
procedure jsFloatingButton_SetBackgroundTintList(env: PJNIEnv; _jsfloatingbutton: JObject; _color: integer);
procedure jsFloatingButton_SetPressedRippleColor(env: PJNIEnv; _jsfloatingbutton: JObject; _color: integer);
procedure jsFloatingButton_SetContentDescription(env: PJNIEnv; _jsfloatingbutton: JObject; _contentDescription: string);
procedure jsFloatingButton_ShowSnackbar(env: PJNIEnv; _jsfloatingbutton: JObject; _message: string);
procedure jsFloatingButton_SetFrameGravity(env: PJNIEnv; _jsfloatingbutton: JObject; _value: integer);
procedure jsFloatingButton_SetFitsSystemWindows(env: PJNIEnv; _jsfloatingbutton: JObject; _value: boolean);
procedure jsFloatingButton_SetAnchorGravity(env: PJNIEnv; _jsfloatingbutton: JObject; _gravity: integer; _anchorId: integer);
procedure jsFloatingButton_SetBackgroundToPrimaryColor(env: PJNIEnv; _jsfloatingbutton: JObject);

implementation

{---------  jsFloatingButton  --------------}

constructor jsFloatingButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 56;
  FWidth        := 56;
  FLParamWidth  := lpWrapContent;
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor jsFloatingButton.Destroy;
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

procedure jsFloatingButton.Init(refApp: jApp);
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

  if FGravityInParent <> lgNone then
    jsFloatingButton_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent) );

  jsFloatingButton_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsFloatingButton_SetId(FjEnv, FjObject, Self.Id);
  jsFloatingButton_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsFloatingButton_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsFloatingButton_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsFloatingButton_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if FImageIdentifier<> '' then
      jsFloatingButton_SetImage(FjEnv, FjObject, FImageIdentifier);

  if FColor <> colbrDefault then
    jsFloatingButton_SetBackgroundTintList(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsFloatingButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
     jsFloatingButton_SetBackgroundTintList(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsFloatingButton.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsFloatingButton.UpdateLParamWidth;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      jsFloatingButton_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdw));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsFloatingButton_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsFloatingButton_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsFloatingButton.UpdateLParamHeight;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
       jsFloatingButton_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdh));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsFloatingButton_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsFloatingButton_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsFloatingButton.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsFloatingButton_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsFloatingButton.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsFloatingButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsFloatingButton.jCreate(): jObject;
begin
   Result:= jsFloatingButton_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsFloatingButton.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_jFree(FjEnv, FjObject);
end;

procedure jsFloatingButton.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsFloatingButton.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsFloatingButton_GetParent(FjEnv, FjObject);
end;

procedure jsFloatingButton.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsFloatingButton.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsFloatingButton_GetView(FjEnv, FjObject);
end;

procedure jsFloatingButton.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsFloatingButton.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsFloatingButton.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsFloatingButton_GetLParamWidth(FjEnv, FjObject);
end;

function jsFloatingButton.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsFloatingButton_GetLParamHeight(FjEnv, FjObject);
end;


procedure jsFloatingButton.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsFloatingButton.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsFloatingButton.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsFloatingButton.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsFloatingButton.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsFloatingButton.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsFloatingButton_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsFloatingButton_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsFloatingButton_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsFloatingButton.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetId(FjEnv, FjObject, _id);
end;

procedure jsFloatingButton.SetVisibility(_value: TViewVisibility);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetVisibility(FjEnv, FjObject, Ord(_value));
end;

procedure jsFloatingButton.SetCompatElevation(_value: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetCompatElevation(FjEnv, FjObject, _value);
end;

procedure jsFloatingButton.SetImageIdentifier(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  FImageIdentifier:= _imageIdentifier;
  if FInitialized then
     jsFloatingButton_SetImage(FjEnv, FjObject, _imageIdentifier);
end;

procedure jsFloatingButton.BringToFront();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_BringToFront(FjEnv, FjObject);
end;

procedure jsFloatingButton.SetSize(_value: TFABSize);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetSize(FjEnv, FjObject, Ord(_value));
end;

procedure jsFloatingButton.SetPressedRippleColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetPressedRippleColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsFloatingButton.SetContentDescription(_contentDescription: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetContentDescription(FjEnv, FjObject, _contentDescription);
end;

procedure jsFloatingButton.ShowSnackbar(_message: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_ShowSnackbar(FjEnv, FjObject, _message);
end;

procedure jsFloatingButton.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _value;
  if FInitialized then
     jsFloatingButton_SetFrameGravity(FjEnv, FjObject, Ord(_value));
end;


procedure jsFloatingButton.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

procedure jsFloatingButton.SetAnchorGravity(_value: TLayoutGravity; _anchorId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetAnchorGravity(FjEnv, FjObject, ord(_value) ,_anchorId);
end;

procedure jsFloatingButton.SetBackgroundToPrimaryColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingButton_SetBackgroundToPrimaryColor(FjEnv, FjObject);
end;

{-------- jsFloatingButton_JNI_Bridge ----------}

function jsFloatingButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsFloatingButton_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jsFloatingButton_jCreate(long _Self) {
  return (java.lang.Object)(new jsFloatingButton(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jsFloatingButton_jFree(env: PJNIEnv; _jsfloatingbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsfloatingbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetViewParent(env: PJNIEnv; _jsfloatingbutton: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsFloatingButton_GetParent(env: PJNIEnv; _jsfloatingbutton: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jsfloatingbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_RemoveFromViewParent(env: PJNIEnv; _jsfloatingbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsfloatingbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsFloatingButton_GetView(env: PJNIEnv; _jsfloatingbutton: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsfloatingbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetLParamWidth(env: PJNIEnv; _jsfloatingbutton: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetLParamHeight(env: PJNIEnv; _jsfloatingbutton: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsFloatingButton_GetLParamWidth(env: PJNIEnv; _jsfloatingbutton: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jsfloatingbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsFloatingButton_GetLParamHeight(env: PJNIEnv; _jsfloatingbutton: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jsfloatingbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingButton_SetLWeight(env: PJNIEnv; _jsfloatingbutton: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsfloatingbutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_AddLParamsAnchorRule(env: PJNIEnv; _jsfloatingbutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_AddLParamsParentRule(env: PJNIEnv; _jsfloatingbutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetLayoutAll(env: PJNIEnv; _jsfloatingbutton: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_ClearLayoutAll(env: PJNIEnv; _jsfloatingbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsfloatingbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetId(env: PJNIEnv; _jsfloatingbutton: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetVisibility(env: PJNIEnv; _jsfloatingbutton: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetVisibility', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetCompatElevation(env: PJNIEnv; _jsfloatingbutton: JObject; _value: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _value;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCompatElevation', '(F)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetImage(env: PJNIEnv; _jsfloatingbutton: JObject; _imageIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetImage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_BringToFront(env: PJNIEnv; _jsfloatingbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'BringToFront', '()V');
  env^.CallVoidMethod(env, _jsfloatingbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetSize(env: PJNIEnv; _jsfloatingbutton: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSize', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetBackgroundTintList(env: PJNIEnv; _jsfloatingbutton: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundTintList', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingButton_SetPressedRippleColor(env: PJNIEnv; _jsfloatingbutton: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPressedRippleColor', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingButton_SetContentDescription(env: PJNIEnv; _jsfloatingbutton: JObject; _contentDescription: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_contentDescription));
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetContentDescription', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingButton_ShowSnackbar(env: PJNIEnv; _jsfloatingbutton: JObject; _message: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_message));
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowSnackbar', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingButton_SetFrameGravity(env: PJNIEnv; _jsfloatingbutton: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingButton_SetFitsSystemWindows(env: PJNIEnv; _jsfloatingbutton: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingButton_SetAnchorGravity(env: PJNIEnv; _jsfloatingbutton: JObject; _gravity: integer; _anchorId: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _gravity;
  jParams[1].i:= _anchorId;
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAnchorGravity', '(II)V');
  env^.CallVoidMethodA(env, _jsfloatingbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingButton_SetBackgroundToPrimaryColor(env: PJNIEnv; _jsfloatingbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundToPrimaryColor', '()V');
  env^.CallVoidMethod(env, _jsfloatingbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


end.
