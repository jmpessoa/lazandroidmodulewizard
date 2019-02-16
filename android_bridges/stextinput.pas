unit stextinput;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, systryparent;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/30/2017 4:39:55]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsTextInput = class(jVisualControl)
 private
    FHint: string;
    FHintTextColor: TARGBColorBridge;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
    Procedure SetFontColor(_color : TARGBColorBridge);
    Procedure SetFontSize (_size : DWord  );
 protected
    procedure SetText(_text: string ); override;
    function  GetText: string; override;

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
    function GetView(): jObject; override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    function GetLParamWidth(): integer;
    function GetLParamHeight(): integer;
    procedure SetLGravity(_gravity: TLayoutGravity);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
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
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property Text: string read GetText write SetText;
end;

function jsTextInput_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsTextInput_jFree(env: PJNIEnv; _jstextinput: JObject);
procedure jsTextInput_SetViewParent(env: PJNIEnv; _jstextinput: JObject; _viewgroup: jObject);
function jsTextInput_GetParent(env: PJNIEnv; _jstextinput: JObject): jObject;
procedure jsTextInput_RemoveFromViewParent(env: PJNIEnv; _jstextinput: JObject);
function jsTextInput_GetView(env: PJNIEnv; _jstextinput: JObject): jObject;
procedure jsTextInput_SetLParamWidth(env: PJNIEnv; _jstextinput: JObject; _w: integer);
procedure jsTextInput_SetLParamHeight(env: PJNIEnv; _jstextinput: JObject; _h: integer);
function jsTextInput_GetLParamWidth(env: PJNIEnv; _jstextinput: JObject): integer;
function jsTextInput_GetLParamHeight(env: PJNIEnv; _jstextinput: JObject): integer;
procedure jsTextInput_SetLGravity(env: PJNIEnv; _jstextinput: JObject; _g: integer);
procedure jsTextInput_SetLWeight(env: PJNIEnv; _jstextinput: JObject; _w: single);
procedure jsTextInput_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jstextinput: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsTextInput_AddLParamsAnchorRule(env: PJNIEnv; _jstextinput: JObject; _rule: integer);
procedure jsTextInput_AddLParamsParentRule(env: PJNIEnv; _jstextinput: JObject; _rule: integer);
procedure jsTextInput_SetLayoutAll(env: PJNIEnv; _jstextinput: JObject; _idAnchor: integer);
procedure jsTextInput_ClearLayoutAll(env: PJNIEnv; _jstextinput: JObject);
procedure jsTextInput_SetId(env: PJNIEnv; _jstextinput: JObject; _id: integer);
procedure jsTextInput_SetHint(env: PJNIEnv; _jstextinput: JObject; _hint: string);
procedure jsTextInput_SetHintTextColor(env: PJNIEnv; _jstextinput: JObject; _color: integer);
procedure jsTextInput_SetTextSize(env: PJNIEnv; _jstextinput: JObject; _size: single);
procedure jsTextInput_SetTextColor(env: PJNIEnv; _jstextinput: JObject; _color: integer);
procedure jsTextInput_CopyToClipboard(env: PJNIEnv; _jstextinput: JObject);
procedure jsTextInput_PasteFromClipboard(env: PJNIEnv; _jstextinput: JObject);
procedure jsTextInput_SetText(env: PJNIEnv; _jstextinput: JObject; _text: string);
function jsTextInput_GetText(env: PJNIEnv; _jstextinput: JObject): string;

implementation

{---------  jsTextInput  --------------}

constructor jsTextInput.Create(AOwner: TComponent);
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

destructor jsTextInput.Destroy;
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

procedure jsTextInput.Init(refApp: jApp);
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

   if FGravityInParent <> lgNone then
    jsTextInput_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent));

   jsTextInput_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jsTextInput_SetId(FjEnv, FjObject, Self.Id);
  end;

  jsTextInput_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsTextInput_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsTextInput_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsTextInput_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FHint <> '' then
     jsTextInput_SetHint(FjEnv, FjObject, FHint);

   if FHintTextColor <> colbrDefault then
     jsTextInput_SetHintTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FHintTextColor));

   if FFontColor <> colbrDefault then
     jsTextInput_SetTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));

   if FFontSize > 0 then
     jsTextInput_SetTextSize(FjEnv, FjObject, FFontSize);

   if FText <> '' then
     jsTextInput_SetText(FjEnv, FjObject, FText);

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jsTextInput.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsTextInput.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsTextInput.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jsTextInput.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsTextInput.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsTextInput.jCreate(): jObject;
begin
   Result:= jsTextInput_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsTextInput.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_jFree(FjEnv, FjObject);
end;

procedure jsTextInput.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsTextInput.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTextInput_GetParent(FjEnv, FjObject);
end;

procedure jsTextInput.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsTextInput.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTextInput_GetView(FjEnv, FjObject);
end;

procedure jsTextInput.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsTextInput.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsTextInput.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTextInput_GetLParamWidth(FjEnv, FjObject);
end;

function jsTextInput.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTextInput_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsTextInput.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FInitialized then
     jsTextInput_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent));
end;

procedure jsTextInput.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsTextInput.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsTextInput.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsTextInput.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsTextInput.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsTextInput.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsTextInput_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsTextInput_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsTextInput_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsTextInput.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_SetId(FjEnv, FjObject, _id);
end;

procedure jsTextInput.SetFontColor(_color: TARGBColorBridge);
begin
  FFontColor:= _color;
  if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jsTextInput_SetTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));
end;

procedure jsTextInput.SetFontSize(_size: DWord);
begin
  FFontSize:= _size;
  if FInitialized and  (FFontSize > 0) then
     jsTextInput_SetTextSize(FjEnv, FjObject, FFontSize);
end;

procedure jsTextInput.SetHint(_hint: string);
begin
  //in designing component state: set value here...
  FHint:= _hint;
  if FInitialized then
     jsTextInput_SetHint(FjEnv, FjObject, _hint);
end;

procedure jsTextInput.SetHintTextColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FHintTextColor:=  _color;
  if FInitialized then
     jsTextInput_SetHintTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FHintTextColor));
end;

procedure jsTextInput.CopyToClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_CopyToClipboard(FjEnv, FjObject);
end;

procedure jsTextInput.PasteFromClipboard();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTextInput_PasteFromClipboard(FjEnv, FjObject);
end;

function jsTextInput.GetText: string;
begin
  Result:= FText;
  if FInitialized then
      Result:= jsTextInput_GetText(FjEnv, FjObject);
end;

procedure jsTextInput.SetText(_text: string);
begin
  inherited SetText(_text);
  if FInitialized then
    jsTextInput_SetText(FjEnv, FjObject, _text);
end;

{-------- jsTextInput_JNI_Bridge ----------}

function jsTextInput_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsTextInput_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsTextInput_jFree(env: PJNIEnv; _jstextinput: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jstextinput, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_SetViewParent(env: PJNIEnv; _jstextinput: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTextInput_GetParent(env: PJNIEnv; _jstextinput: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jstextinput, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_RemoveFromViewParent(env: PJNIEnv; _jstextinput: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jstextinput, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTextInput_GetView(env: PJNIEnv; _jstextinput: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jstextinput, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_SetLParamWidth(env: PJNIEnv; _jstextinput: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_SetLParamHeight(env: PJNIEnv; _jstextinput: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTextInput_GetLParamWidth(env: PJNIEnv; _jstextinput: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jstextinput, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTextInput_GetLParamHeight(env: PJNIEnv; _jstextinput: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jstextinput, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_SetLGravity(env: PJNIEnv; _jstextinput: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_SetLWeight(env: PJNIEnv; _jstextinput: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jstextinput: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_AddLParamsAnchorRule(env: PJNIEnv; _jstextinput: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_AddLParamsParentRule(env: PJNIEnv; _jstextinput: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_SetLayoutAll(env: PJNIEnv; _jstextinput: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_ClearLayoutAll(env: PJNIEnv; _jstextinput: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jstextinput, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_SetId(env: PJNIEnv; _jstextinput: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsTextInput_SetHint(env: PJNIEnv; _jstextinput: JObject; _hint: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_hint));
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHint', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_SetHintTextColor(env: PJNIEnv; _jstextinput: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHintTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsTextInput_SetTextSize(env: PJNIEnv; _jstextinput: JObject; _size: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _size;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextSize', '(F)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_SetTextColor(env: PJNIEnv; _jstextinput: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_CopyToClipboard(env: PJNIEnv; _jstextinput: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'CopyToClipboard', '()V');
  env^.CallVoidMethod(env, _jstextinput, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTextInput_PasteFromClipboard(env: PJNIEnv; _jstextinput: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'PasteFromClipboard', '()V');
  env^.CallVoidMethod(env, _jstextinput, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsTextInput_SetText(env: PJNIEnv; _jstextinput: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'SetText', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jstextinput, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jsTextInput_GetText(env: PJNIEnv; _jstextinput: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstextinput);
  jMethod:= env^.GetMethodID(env, jCls, 'GetText', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jstextinput, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

end.
