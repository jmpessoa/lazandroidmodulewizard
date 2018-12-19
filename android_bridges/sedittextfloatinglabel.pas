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
    procedure SetId(_id: integer);

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

uses
   customdialog;

{---------  jsEditTextFloatingLabel  --------------}

constructor jsEditTextFloatingLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
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

procedure jsEditTextFloatingLabel.Init(refApp: jApp);
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
  end;
  jsEditTextFloatingLabel_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsEditTextFloatingLabel_SetId(FjEnv, FjObject, Self.Id);
  jsEditTextFloatingLabel_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsEditTextFloatingLabel_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsEditTextFloatingLabel_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsEditTextFloatingLabel_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsEditTextFloatingLabel.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsEditTextFloatingLabel.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsEditTextFloatingLabel.UpdateLParamWidth;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      jsEditTextFloatingLabel_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdw));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsEditTextFloatingLabel_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsEditTextFloatingLabel_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsEditTextFloatingLabel.UpdateLParamHeight;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      jsEditTextFloatingLabel_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdh));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsEditTextFloatingLabel_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsEditTextFloatingLabel_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsEditTextFloatingLabel.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsEditTextFloatingLabel_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsEditTextFloatingLabel.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsEditTextFloatingLabel.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsEditTextFloatingLabel.jCreate(): jObject;
begin
   Result:= jsEditTextFloatingLabel_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsEditTextFloatingLabel.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_jFree(FjEnv, FjObject);
end;

procedure jsEditTextFloatingLabel.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsEditTextFloatingLabel.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsEditTextFloatingLabel_GetParent(FjEnv, FjObject);
end;

procedure jsEditTextFloatingLabel.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsEditTextFloatingLabel.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsEditTextFloatingLabel_GetView(FjEnv, FjObject);
end;

procedure jsEditTextFloatingLabel.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsEditTextFloatingLabel.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsEditTextFloatingLabel.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsEditTextFloatingLabel_GetLParamWidth(FjEnv, FjObject);
end;

function jsEditTextFloatingLabel.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsEditTextFloatingLabel_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsEditTextFloatingLabel.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jsEditTextFloatingLabel.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsEditTextFloatingLabel.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsEditTextFloatingLabel.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsEditTextFloatingLabel.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsEditTextFloatingLabel.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsEditTextFloatingLabel.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsEditTextFloatingLabel_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsEditTextFloatingLabel_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsEditTextFloatingLabel_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsEditTextFloatingLabel.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsEditTextFloatingLabel_SetId(FjEnv, FjObject, _id);
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
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jsedittextfloatinglabel, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;



end.
