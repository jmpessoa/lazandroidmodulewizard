unit tablelayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget, systryparent;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [4/15/2022 17:53:02]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jTableLayout = class(jVisualControl)
 private
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent(); override;
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

    procedure AddTextRow(_delimitedTextRow: string; _columnDelimiter: string; _color: TARGBColorBridge);
    procedure SetRowTextColor(_textColor: TARGBColorBridge);

    procedure SeInnerTextContentDelimiter(_delimiter: string);
    procedure SetStretchAllColumns(_value: boolean);
    procedure SetColumnStretchable(_index: integer);
    procedure SetShrinkAllColumns(_value: boolean);
    procedure SetColumnShrinkable(_index: integer);


 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jTableLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jTableLayout_jFree(env: PJNIEnv; _jtablelayout: JObject);
procedure jTableLayout_SetViewParent(env: PJNIEnv; _jtablelayout: JObject; _viewgroup: jObject);
function jTableLayout_GetParent(env: PJNIEnv; _jtablelayout: JObject): jObject;
procedure jTableLayout_RemoveFromViewParent(env: PJNIEnv; _jtablelayout: JObject);
function jTableLayout_GetView(env: PJNIEnv; _jtablelayout: JObject): jObject;
procedure jTableLayout_SetLParamWidth(env: PJNIEnv; _jtablelayout: JObject; _w: integer);
procedure jTableLayout_SetLParamHeight(env: PJNIEnv; _jtablelayout: JObject; _h: integer);
function jTableLayout_GetLParamWidth(env: PJNIEnv; _jtablelayout: JObject): integer;
function jTableLayout_GetLParamHeight(env: PJNIEnv; _jtablelayout: JObject): integer;
procedure jTableLayout_SetLGravity(env: PJNIEnv; _jtablelayout: JObject; _g: integer);
procedure jTableLayout_SetLWeight(env: PJNIEnv; _jtablelayout: JObject; _w: single);
procedure jTableLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jtablelayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jTableLayout_AddLParamsAnchorRule(env: PJNIEnv; _jtablelayout: JObject; _rule: integer);
procedure jTableLayout_AddLParamsParentRule(env: PJNIEnv; _jtablelayout: JObject; _rule: integer);
procedure jTableLayout_SetLayoutAll(env: PJNIEnv; _jtablelayout: JObject; _idAnchor: integer);
procedure jTableLayout_ClearLayoutAll(env: PJNIEnv; _jtablelayout: JObject);
procedure jTableLayout_SetId(env: PJNIEnv; _jtablelayout: JObject; _id: integer);

procedure jTableLayout_AddTextRow(env: PJNIEnv; _jtablelayout: JObject; _delimitedTextRow: string; _delimiter: string; _color: integer);
procedure jTableLayout_SetRowTextColor(env: PJNIEnv; _jtablelayout: JObject; _textColor: integer);

procedure jTableLayout_SeInnerTextContentDelimiter(env: PJNIEnv; _jtablelayout: JObject; _delimiter: string);
procedure jTableLayout_SetStretchAllColumns(env: PJNIEnv; _jtablelayout: JObject; _value: boolean);
procedure jTableLayout_SetColumnStretchable(env: PJNIEnv; _jtablelayout: JObject; _index: integer);
procedure jTableLayout_SetShrinkAllColumns(env: PJNIEnv; _jtablelayout: JObject; _value: boolean);
procedure jTableLayout_SetColumnShrinkable(env: PJNIEnv; _jtablelayout: JObject; _index: integer);


implementation

{---------  jTableLayout  --------------}

constructor jTableLayout.Create(AOwner: TComponent);
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

destructor jTableLayout.Destroy;
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

procedure jTableLayout.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin

 if not FInitialized then
 begin
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  if FParent <> nil then
   sysTryNewParent( FjPRLayout, FParent);

  FjPRLayoutHome:= FjPRLayout;

  jTableLayout_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
  jTableLayout_SetId(gApp.jni.jEnv, FjObject, Self.Id);
 end;

  jTableLayout_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                        sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jTableLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jTableLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jTableLayout_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

 if not FInitialized then
 begin
  FInitialized := true;

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
 end;
end;

procedure jTableLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jTableLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jTableLayout.UpdateLayout;
begin

  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;

end;

procedure jTableLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

procedure jTableLayout.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin

   if not FInitialized then Exit;

  jTableLayout_ClearLayoutAll(gApp.jni.jEnv, FjObject );

   for rToP := rpBottom to rpCenterVertical do
      if rToP in FPositionRelativeToParent then
        jTableLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

   for rToA := raAbove to raAlignRight do
     if rToA in FPositionRelativeToAnchor then
       jTableLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));

end;

//Event : Java -> Pascal
procedure jTableLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jTableLayout.jCreate(): jObject;
begin
   Result:= jTableLayout_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jTableLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jTableLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jTableLayout.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTableLayout_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jTableLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jTableLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTableLayout_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jTableLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jTableLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jTableLayout.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTableLayout_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jTableLayout.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jTableLayout_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jTableLayout.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure jTableLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jTableLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jTableLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jTableLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jTableLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jTableLayout.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_ClearLayoutAll(gApp.jni.jEnv, FjObject);
end;

procedure jTableLayout.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetId(gApp.jni.jEnv, FjObject, _id);
end;

procedure jTableLayout.AddTextRow(_delimitedTextRow: string; _columnDelimiter: string; _color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_AddTextRow(gApp.jni.jEnv, FjObject, _delimitedTextRow ,_columnDelimiter , GetARGB(FCustomColor, _color));
end;

procedure jTableLayout.SetRowTextColor(_textColor: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetRowTextColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, _textColor));
end;

procedure jTableLayout.SeInnerTextContentDelimiter(_delimiter: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SeInnerTextContentDelimiter(gApp.jni.jEnv, FjObject, _delimiter);
end;

procedure jTableLayout.SetStretchAllColumns(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetStretchAllColumns(gApp.jni.jEnv, FjObject, _value);
end;

procedure jTableLayout.SetColumnStretchable(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetColumnStretchable(gApp.jni.jEnv, FjObject, _index);
end;

procedure jTableLayout.SetShrinkAllColumns(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetShrinkAllColumns(gApp.jni.jEnv, FjObject, _value);
end;

procedure jTableLayout.SetColumnShrinkable(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jTableLayout_SetColumnShrinkable(gApp.jni.jEnv, FjObject, _index);
end;

{-------- jTableLayout_JNI_Bridge ----------}

function jTableLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  Result := nil;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jTableLayout_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure jTableLayout_jFree(env: PJNIEnv; _jtablelayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jtablelayout, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetViewParent(env: PJNIEnv; _jtablelayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= _viewgroup;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jTableLayout_GetParent(env: PJNIEnv; _jtablelayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  if jMethod = nil then goto _exceptionOcurred;

  Result:= env^.CallObjectMethod(env, _jtablelayout, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_RemoveFromViewParent(env: PJNIEnv; _jtablelayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jtablelayout, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jTableLayout_GetView(env: PJNIEnv; _jtablelayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  if jMethod = nil then goto _exceptionOcurred;

  Result:= env^.CallObjectMethod(env, _jtablelayout, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetLParamWidth(env: PJNIEnv; _jtablelayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _w;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetLParamHeight(env: PJNIEnv; _jtablelayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _h;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jTableLayout_GetLParamWidth(env: PJNIEnv; _jtablelayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  if jMethod = nil then goto _exceptionOcurred;

  Result:= env^.CallIntMethod(env, _jtablelayout, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jTableLayout_GetLParamHeight(env: PJNIEnv; _jtablelayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  if jMethod = nil then goto _exceptionOcurred;

  Result:= env^.CallIntMethod(env, _jtablelayout, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetLGravity(env: PJNIEnv; _jtablelayout: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _g;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetLWeight(env: PJNIEnv; _jtablelayout: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].f:= _w;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jtablelayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _left;
  jParams[1].i:= _top;
  jParams[2].i:= _right;
  jParams[3].i:= _bottom;
  jParams[4].i:= _w;
  jParams[5].i:= _h;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_AddLParamsAnchorRule(env: PJNIEnv; _jtablelayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _rule;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_AddLParamsParentRule(env: PJNIEnv; _jtablelayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _rule;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetLayoutAll(env: PJNIEnv; _jtablelayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _idAnchor;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_ClearLayoutAll(env: PJNIEnv; _jtablelayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  if jMethod = nil then goto _exceptionOcurred;

  env^.CallVoidMethod(env, _jtablelayout, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetId(env: PJNIEnv; _jtablelayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _id;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jTableLayout_AddTextRow(env: PJNIEnv; _jtablelayout: JObject; _delimitedTextRow: string; _delimiter: string; _color: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddTextRow', '(Ljava/lang/String;Ljava/lang/String;I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_delimitedTextRow));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_delimiter));
  jParams[2].i:= _color;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetRowTextColor(env: PJNIEnv; _jtablelayout: JObject; _textColor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetRowTextColor', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _textColor;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jTableLayout_SeInnerTextContentDelimiter(env: PJNIEnv; _jtablelayout: JObject; _delimiter: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SeInnerTextContentDelimiter', '(Ljava/lang/String;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_delimiter));

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetStretchAllColumns(env: PJNIEnv; _jtablelayout: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetStretchAllColumns', '(Z)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].z:= JBool(_value);

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetColumnStretchable(env: PJNIEnv; _jtablelayout: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetColumnStretchable', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _index;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetShrinkAllColumns(env: PJNIEnv; _jtablelayout: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetShrinkAllColumns', '(Z)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].z:= JBool(_value);

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jTableLayout_SetColumnShrinkable(env: PJNIEnv; _jtablelayout: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jtablelayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetColumnShrinkable', '(I)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _index;

  env^.CallVoidMethodA(env, _jtablelayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


end.
