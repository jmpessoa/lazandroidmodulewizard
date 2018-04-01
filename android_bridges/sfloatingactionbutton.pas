unit sfloatingactionbutton;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TFABSize = (fabNormal, fabMini, fabAuto); //SIZE_MINI  SIZE_AUTO  SIZE_NORMAL

{Draft Component code by "Lazarus Android Module Wizard" [12/11/2017 23:35:15]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsFloatingActionButton = class(jVisualControl)
 private
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

    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);
    procedure SetVisibility(_value: TViewVisibility);
    procedure SetCompatElevation(_value: single);
    procedure SetImage(_imageIdentifier: string);
    procedure BringToFront();
    procedure SetSize(_value: TFABSize);
    procedure SetPressedRippleColor(_color: TARGBColorBridge);
    procedure SetContentDescription(_contentDescription: string);
    procedure ShowSnackbar(_message: string);
    procedure SetLGravity(_value: TLayoutGravity);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property GravityRelativeToParent: TLayoutGravity read FGravityRelativeToParent write SetLGravity;

end;

function jsFloatingActionButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsFloatingActionButton_jFree(env: PJNIEnv; _jsfloatingactionbutton: JObject);
procedure jsFloatingActionButton_SetViewParent(env: PJNIEnv; _jsfloatingactionbutton: JObject; _viewgroup: jObject);
function jsFloatingActionButton_GetParent(env: PJNIEnv; _jsfloatingactionbutton: JObject): jObject;
procedure jsFloatingActionButton_RemoveFromViewParent(env: PJNIEnv; _jsfloatingactionbutton: JObject);
function jsFloatingActionButton_GetView(env: PJNIEnv; _jsfloatingactionbutton: JObject): jObject;
procedure jsFloatingActionButton_SetLParamWidth(env: PJNIEnv; _jsfloatingactionbutton: JObject; _w: integer);
procedure jsFloatingActionButton_SetLParamHeight(env: PJNIEnv; _jsfloatingactionbutton: JObject; _h: integer);
function jsFloatingActionButton_GetLParamWidth(env: PJNIEnv; _jsfloatingactionbutton: JObject): integer;
function jsFloatingActionButton_GetLParamHeight(env: PJNIEnv; _jsfloatingactionbutton: JObject): integer;

procedure jsFloatingActionButton_SetLWeight(env: PJNIEnv; _jsfloatingactionbutton: JObject; _w: single);
procedure jsFloatingActionButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsfloatingactionbutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsFloatingActionButton_AddLParamsAnchorRule(env: PJNIEnv; _jsfloatingactionbutton: JObject; _rule: integer);
procedure jsFloatingActionButton_AddLParamsParentRule(env: PJNIEnv; _jsfloatingactionbutton: JObject; _rule: integer);
procedure jsFloatingActionButton_SetLayoutAll(env: PJNIEnv; _jsfloatingactionbutton: JObject; _idAnchor: integer);
procedure jsFloatingActionButton_ClearLayoutAll(env: PJNIEnv; _jsfloatingactionbutton: JObject);
procedure jsFloatingActionButton_SetId(env: PJNIEnv; _jsfloatingactionbutton: JObject; _id: integer);
procedure jsFloatingActionButton_SetVisibility(env: PJNIEnv; _jsfloatingactionbutton: JObject; _value: integer);
procedure jsFloatingActionButton_SetCompatElevation(env: PJNIEnv; _jsfloatingactionbutton: JObject; _value: single);
procedure jsFloatingActionButton_SetImage(env: PJNIEnv; _jsfloatingactionbutton: JObject; _imageIdentifier: string);
procedure jsFloatingActionButton_BringToFront(env: PJNIEnv; _jsfloatingactionbutton: JObject);
procedure jsFloatingActionButton_SetSize(env: PJNIEnv; _jsfloatingactionbutton: JObject; _value: integer);
procedure jsFloatingActionButton_SetBackgroundTintList(env: PJNIEnv; _jsfloatingactionbutton: JObject; _color: integer);
procedure jsFloatingActionButton_SetPressedRippleColor(env: PJNIEnv; _jsfloatingactionbutton: JObject; _color: integer);
procedure jsFloatingActionButton_SetContentDescription(env: PJNIEnv; _jsfloatingactionbutton: JObject; _contentDescription: string);
procedure jsFloatingActionButton_ShowSnackbar(env: PJNIEnv; _jsfloatingactionbutton: JObject; _message: string);
procedure jsFloatingActionButton_SetFrameGravity(env: PJNIEnv; _jsfloatingactionbutton: JObject; _value: integer);

implementation

uses
   customdialog, scoordinatorlayout, framelayout;

{---------  jsFloatingActionButton  --------------}

constructor jsFloatingActionButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 48; //??
  FWidth        := 48; //??
  FLParamWidth  := lpWrapContent;
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor jsFloatingActionButton.Destroy;
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

procedure jsFloatingActionButton.Init(refApp: jApp);
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
    if FParent is jsCoordinatorLayout then
    begin
      jsCoordinatorLayout(FParent).Init(refApp);
      FjPRLayout:= jsCoordinatorLayout(FParent).View;
    end;
    if FParent is jFrameLayout then
    begin
      jFrameLayout(FParent).Init(refApp);
      FjPRLayout:= jFrameLayout(FParent).View;
    end;
  end;

  if FGravityRelativeToParent <> lgNone then
     jsFloatingActionButton_SetFrameGravity(FjEnv, FjObject, Ord(FGravityRelativeToParent) );

  jsFloatingActionButton_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsFloatingActionButton_SetId(FjEnv, FjObject, Self.Id);
  jsFloatingActionButton_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsFloatingActionButton_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsFloatingActionButton_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsFloatingActionButton_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if FColor <> colbrDefault then
    jsFloatingActionButton_SetBackgroundTintList(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsFloatingActionButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
     jsFloatingActionButton_SetBackgroundTintList(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsFloatingActionButton.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsFloatingActionButton.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jsFloatingActionButton_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsFloatingActionButton_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsFloatingActionButton_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsFloatingActionButton.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jsFloatingActionButton_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsFloatingActionButton_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsFloatingActionButton_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsFloatingActionButton.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsFloatingActionButton_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsFloatingActionButton.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jsFloatingActionButton.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jsFloatingActionButton_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jsFloatingActionButton_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jsFloatingActionButton_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jsFloatingActionButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsFloatingActionButton.jCreate(): jObject;
begin
   Result:= jsFloatingActionButton_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsFloatingActionButton.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_jFree(FjEnv, FjObject);
end;

procedure jsFloatingActionButton.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsFloatingActionButton.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsFloatingActionButton_GetParent(FjEnv, FjObject);
end;

procedure jsFloatingActionButton.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsFloatingActionButton.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsFloatingActionButton_GetView(FjEnv, FjObject);
end;

procedure jsFloatingActionButton.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsFloatingActionButton.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsFloatingActionButton.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsFloatingActionButton_GetLParamWidth(FjEnv, FjObject);
end;

function jsFloatingActionButton.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsFloatingActionButton_GetLParamHeight(FjEnv, FjObject);
end;


procedure jsFloatingActionButton.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsFloatingActionButton.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsFloatingActionButton.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsFloatingActionButton.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsFloatingActionButton.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsFloatingActionButton.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jsFloatingActionButton.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetId(FjEnv, FjObject, _id);
end;

procedure jsFloatingActionButton.SetVisibility(_value: TViewVisibility);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetVisibility(FjEnv, FjObject, Ord(_value));
end;

procedure jsFloatingActionButton.SetCompatElevation(_value: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetCompatElevation(FjEnv, FjObject, _value);
end;

procedure jsFloatingActionButton.SetImage(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetImage(FjEnv, FjObject, _imageIdentifier);
end;

procedure jsFloatingActionButton.BringToFront();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_BringToFront(FjEnv, FjObject);
end;

procedure jsFloatingActionButton.SetSize(_value: TFABSize);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetSize(FjEnv, FjObject, Ord(_value));
end;

procedure jsFloatingActionButton.SetPressedRippleColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetPressedRippleColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsFloatingActionButton.SetContentDescription(_contentDescription: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_SetContentDescription(FjEnv, FjObject, _contentDescription);
end;

procedure jsFloatingActionButton.ShowSnackbar(_message: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsFloatingActionButton_ShowSnackbar(FjEnv, FjObject, _message);
end;

procedure jsFloatingActionButton.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityRelativeToParent:= _value;
  if FInitialized then
     jsFloatingActionButton_SetFrameGravity(FjEnv, FjObject, Ord(_value));
end;

{-------- jsFloatingActionButton_JNI_Bridge ----------}

function jsFloatingActionButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsFloatingActionButton_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jsFloatingActionButton_jCreate(long _Self) {
  return (java.lang.Object)(new jsFloatingActionButton(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jsFloatingActionButton_jFree(env: PJNIEnv; _jsfloatingactionbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsfloatingactionbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetViewParent(env: PJNIEnv; _jsfloatingactionbutton: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsFloatingActionButton_GetParent(env: PJNIEnv; _jsfloatingactionbutton: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jsfloatingactionbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_RemoveFromViewParent(env: PJNIEnv; _jsfloatingactionbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsfloatingactionbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsFloatingActionButton_GetView(env: PJNIEnv; _jsfloatingactionbutton: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsfloatingactionbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetLParamWidth(env: PJNIEnv; _jsfloatingactionbutton: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetLParamHeight(env: PJNIEnv; _jsfloatingactionbutton: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsFloatingActionButton_GetLParamWidth(env: PJNIEnv; _jsfloatingactionbutton: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jsfloatingactionbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsFloatingActionButton_GetLParamHeight(env: PJNIEnv; _jsfloatingactionbutton: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jsfloatingactionbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingActionButton_SetLWeight(env: PJNIEnv; _jsfloatingactionbutton: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsfloatingactionbutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_AddLParamsAnchorRule(env: PJNIEnv; _jsfloatingactionbutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_AddLParamsParentRule(env: PJNIEnv; _jsfloatingactionbutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetLayoutAll(env: PJNIEnv; _jsfloatingactionbutton: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_ClearLayoutAll(env: PJNIEnv; _jsfloatingactionbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsfloatingactionbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetId(env: PJNIEnv; _jsfloatingactionbutton: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetVisibility(env: PJNIEnv; _jsfloatingactionbutton: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetVisibility', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetCompatElevation(env: PJNIEnv; _jsfloatingactionbutton: JObject; _value: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _value;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCompatElevation', '(F)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetImage(env: PJNIEnv; _jsfloatingactionbutton: JObject; _imageIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetImage', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_BringToFront(env: PJNIEnv; _jsfloatingactionbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'BringToFront', '()V');
  env^.CallVoidMethod(env, _jsfloatingactionbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetSize(env: PJNIEnv; _jsfloatingactionbutton: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSize', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetBackgroundTintList(env: PJNIEnv; _jsfloatingactionbutton: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundTintList', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsFloatingActionButton_SetPressedRippleColor(env: PJNIEnv; _jsfloatingactionbutton: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPressedRippleColor', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingActionButton_SetContentDescription(env: PJNIEnv; _jsfloatingactionbutton: JObject; _contentDescription: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_contentDescription));
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetContentDescription', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingActionButton_ShowSnackbar(env: PJNIEnv; _jsfloatingactionbutton: JObject; _message: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_message));
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowSnackbar', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsFloatingActionButton_SetFrameGravity(env: PJNIEnv; _jsfloatingactionbutton: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jsfloatingactionbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jsfloatingactionbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
