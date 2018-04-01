unit stextinputfloatinghint;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/30/2017 4:39:55]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsTextInputFloatingHint = class(jVisualControl)
 private
    FHint: string;
    FHintTextColor: TARGBColorBridge;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

    Procedure SetFontColor(_color : TARGBColorBridge);
    Procedure SetFontSize (_size : DWord  );


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
    function GetView(): jObject; override;
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
    procedure SetHint(_hint: string);
    procedure SetHintTextColor(_color: TARGBColorBridge);
    procedure CopyToClipboard();
    procedure PasteFromClipboard();


 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property FontColor : TARGBColorBridge      read FFontColor    write SetFontColor;
    property FontSize  : DWord      read FFontSize     write SetFontSize;
    property Hint: string read FHint write SetHint;
    property HintTextColor: TARGBColorBridge read FHintTextColor write SetHintTextColor;
end;

function jsTextInputFloatingHint_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsTextInputFloatingHint_jFree(env: PJNIEnv; _jstextinputfloatinghint: JObject);
procedure jsTextInputFloatingHint_SetViewParent(env: PJNIEnv; _jstextinputfloatinghint: JObject; _viewgroup: jObject);
function jsTextInputFloatingHint_GetParent(env: PJNIEnv; _jstextinputfloatinghint: JObject): jObject;
procedure jsTextInputFloatingHint_RemoveFromViewParent(env: PJNIEnv; _jstextinputfloatinghint: JObject);
function jsTextInputFloatingHint_GetView(env: PJNIEnv; _jstextinputfloatinghint: JObject): jObject;
procedure jsTextInputFloatingHint_SetLParamWidth(env: PJNIEnv; _jstextinputfloatinghint: JObject; _w: integer);
procedure jsTextInputFloatingHint_SetLParamHeight(env: PJNIEnv; _jstextinputfloatinghint: JObject; _h: integer);
function jsTextInputFloatingHint_GetLParamWidth(env: PJNIEnv; _jstextinputfloatinghint: JObject): integer;
function jsTextInputFloatingHint_GetLParamHeight(env: PJNIEnv; _jstextinputfloatinghint: JObject): integer;
procedure jsTextInputFloatingHint_SetLGravity(env: PJNIEnv; _jstextinputfloatinghint: JObject; _g: integer);
procedure jsTextInputFloatingHint_SetLWeight(env: PJNIEnv; _jstextinputfloatinghint: JObject; _w: single);
procedure jsTextInputFloatingHint_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jstextinputfloatinghint: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsTextInputFloatingHint_AddLParamsAnchorRule(env: PJNIEnv; _jstextinputfloatinghint: JObject; _rule: integer);
procedure jsTextInputFloatingHint_AddLParamsParentRule(env: PJNIEnv; _jstextinputfloatinghint: JObject; _rule: integer);
procedure jsTextInputFloatingHint_SetLayoutAll(env: PJNIEnv; _jstextinputfloatinghint: JObject; _idAnchor: integer);
procedure jsTextInputFloatingHint_ClearLayoutAll(env: PJNIEnv; _jstextinputfloatinghint: JObject);
procedure jsTextInputFloatingHint_SetId(env: PJNIEnv; _jstextinputfloatinghint: JObject; _id: integer);
procedure jsTextInputFloatingHint_SetHint(env: PJNIEnv; _jstextinputfloatinghint: JObject; _hint: string);
procedure jsTextInputFloatingHint_SetHintTextColor(env: PJNIEnv; _jstextinputfloatinghint: JObject; _color: integer);
procedure jsTextInputFloatingHint_SetTextSize(env: PJNIEnv; _jstextinputfloatinghint: JObject; _size: single);
procedure jsTextInputFloatingHint_SetTextColor(env: PJNIEnv; _jstextinputfloatinghint: JObject; _color: integer);
procedure jsTextInputFloatingHint_CopyToClipboard(env: PJNIEnv; _jstextinputfloatinghint: JObject);
procedure jsTextInputFloatingHint_PasteFromClipboard(env: PJNIEnv; _jstextinputfloatinghint: JObject);


implementation

uses
   customdialog;

{---------  jsTextInputFloatingHint  --------------}

constructor jsTextInputFloatingHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 40; //??
  FWidth        := 100; //??
  FLParamWidth  := lpHalfOfParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FHintTextColor:= colbrDefault;
end;

destructor jsTextInputFloatingHint.Destroy;
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

procedure jsTextInputFloatingHint.Init(refApp: jApp);
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

  jsTextInputFloatingHint_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsTextInputFloatingHint_SetId(FjEnv, FjObject, Self.Id);
  jsTextInputFloatingHint_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsTextInputFloatingHint_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsTextInputFloatingHint_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsTextInputFloatingHint_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FHint <> '' then
     jsTextInputFloatingHint_SetHint(FjEnv, FjObject, FHint);

  if FHintTextColor <> colbrDefault then
     jsTextInputFloatingHint_SetHintTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FHintTextColor));

  if FFontColor <> colbrDefault then
     jsTextInputFloatingHint_SetTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));

  if FFontSize > 0 then
     jsTextInputFloatingHint_SetTextSize(FjEnv, FjObject, FFontSize);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsTextInputFloatingHint.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsTextInputFloatingHint.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsTextInputFloatingHint.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jsTextInputFloatingHint_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsTextInputFloatingHint_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsTextInputFloatingHint_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsTextInputFloatingHint.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jsTextInputFloatingHint_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsTextInputFloatingHint_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsTextInputFloatingHint_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsTextInputFloatingHint.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsTextInputFloatingHint_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsTextInputFloatingHint.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jsTextInputFloatingHint.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jsTextInputFloatingHint_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jsTextInputFloatingHint_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jsTextInputFloatingHint_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jsTextInputFloatingHint.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsTextInputFloatingHint.jCreate(): jObject;
begin
   Result:= jsTextInputFloatingHint_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsTextInputFloatingHint.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_jFree(FjEnv, FjObject);
end;

procedure jsTextInputFloatingHint.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsTextInputFloatingHint.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTextInputFloatingHint_GetParent(FjEnv, FjObject);
end;

procedure jsTextInputFloatingHint.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsTextInputFloatingHint.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTextInputFloatingHint_GetView(FjEnv, FjObject);
end;

procedure jsTextInputFloatingHint.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsTextInputFloatingHint.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsTextInputFloatingHint.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTextInputFloatingHint_GetLParamWidth(FjEnv, FjObject);
end;

function jsTextInputFloatingHint.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTextInputFloatingHint_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsTextInputFloatingHint.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jsTextInputFloatingHint.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsTextInputFloatingHint.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsTextInputFloatingHint.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsTextInputFloatingHint.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsTextInputFloatingHint.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsTextInputFloatingHint.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jsTextInputFloatingHint.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_SetId(FjEnv, FjObject, _id);
end;

procedure jsTextInputFloatingHint.SetFontColor(_color: TARGBColorBridge);
begin
  FFontColor:= _color;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jsTextInputFloatingHint_SetTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));
end;

procedure jsTextInputFloatingHint.SetFontSize(_size: DWord);
begin
  FFontSize:= _size;
  if FInitialized and  (FFontSize > 0) then
     jsTextInputFloatingHint_SetTextSize(FjEnv, FjObject, FFontSize);
end;

procedure jsTextInputFloatingHint.SetHint(_hint: string);
begin
  //in designing component state: set value here...
  FHint:= _hint;
  if FInitialized then
     jsTextInputFloatingHint_SetHint(FjEnv, FjObject, _hint);
end;

procedure jsTextInputFloatingHint.SetHintTextColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FHintTextColor:=  _color;
  if FInitialized then
     jsTextInputFloatingHint_SetHintTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FHintTextColor));
end;

procedure jsTextInputFloatingHint.CopyToClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_CopyToClipboard(FjEnv, FjObject);
end;

procedure jsTextInputFloatingHint.PasteFromClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInputFloatingHint_PasteFromClipboard(FjEnv, FjObject);
end;

{-------- jsTextInputFloatingHint_JNI_Bridge ----------}

function jsTextInputFloatingHint_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsTextInputFloatingHint_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsTextInputFloatingHint_jFree(env: PJNIEnv; _jstextinputfloatinghint: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jstextinputfloatinghint, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_SetViewParent(env: PJNIEnv; _jstextinputfloatinghint: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTextInputFloatingHint_GetParent(env: PJNIEnv; _jstextinputfloatinghint: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jstextinputfloatinghint, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_RemoveFromViewParent(env: PJNIEnv; _jstextinputfloatinghint: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jstextinputfloatinghint, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTextInputFloatingHint_GetView(env: PJNIEnv; _jstextinputfloatinghint: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jstextinputfloatinghint, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_SetLParamWidth(env: PJNIEnv; _jstextinputfloatinghint: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_SetLParamHeight(env: PJNIEnv; _jstextinputfloatinghint: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTextInputFloatingHint_GetLParamWidth(env: PJNIEnv; _jstextinputfloatinghint: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jstextinputfloatinghint, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTextInputFloatingHint_GetLParamHeight(env: PJNIEnv; _jstextinputfloatinghint: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jstextinputfloatinghint, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_SetLGravity(env: PJNIEnv; _jstextinputfloatinghint: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_SetLWeight(env: PJNIEnv; _jstextinputfloatinghint: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jstextinputfloatinghint: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_AddLParamsAnchorRule(env: PJNIEnv; _jstextinputfloatinghint: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_AddLParamsParentRule(env: PJNIEnv; _jstextinputfloatinghint: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_SetLayoutAll(env: PJNIEnv; _jstextinputfloatinghint: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_ClearLayoutAll(env: PJNIEnv; _jstextinputfloatinghint: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jstextinputfloatinghint, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_SetId(env: PJNIEnv; _jstextinputfloatinghint: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsTextInputFloatingHint_SetHint(env: PJNIEnv; _jstextinputfloatinghint: JObject; _hint: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_hint));
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHint', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_SetHintTextColor(env: PJNIEnv; _jstextinputfloatinghint: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHintTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsTextInputFloatingHint_SetTextSize(env: PJNIEnv; _jstextinputfloatinghint: JObject; _size: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _size;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextSize', '(F)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_SetTextColor(env: PJNIEnv; _jstextinputfloatinghint: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jstextinputfloatinghint, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_CopyToClipboard(env: PJNIEnv; _jstextinputfloatinghint: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'CopyToClipboard', '()V');
  env^.CallVoidMethod(env, _jstextinputfloatinghint, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInputFloatingHint_PasteFromClipboard(env: PJNIEnv; _jstextinputfloatinghint: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinputfloatinghint);
  jMethod:= env^.GetMethodID(env, jCls, 'PasteFromClipboard', '()V');
  env^.CallVoidMethod(env, _jstextinputfloatinghint, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


end.
