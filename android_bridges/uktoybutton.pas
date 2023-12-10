unit uktoybutton;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget, systryparent;

type

TKToyShapeType = (kstRectangle, kstCircle);
{Draft Component code by "LAMW: Lazarus Android Module Wizard" [9/10/2022 20:30:29]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

KToyButton = class(jVisualControl)  //conceptual
 private
    FShapeType: TKToyShapeType;
    FPressedColor: TARGBColorBridge;
    FRoundRadiusCorner: integer;
    FAllCaps: Boolean;
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
    procedure kFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent(); override;
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

    procedure SetPressedColor(_color: TARGBColorBridge);
    procedure SetUnPressedColor(_color: TARGBColorBridge);
    procedure SetRoundRadiusCorner(_roundRadiusCorner: integer);
    procedure SetShapeType(_shapeType: TKToyShapeType);
    procedure SetText(Value: string); override;
    function GetText(): string;  override;
    procedure SetEnable(_value: boolean);

 published
    property Text: string read GetText write SetText;
    property ShapeType: TKToyShapeType read FShapeType write SetShapeType;
    property FontSize: DWord     read FFontSize  write FFontSize;
    property FontColor : TARGBColorBridge read FFontColor write FFontColor;
    property AllCaps: Boolean read FAllCaps write FAllCaps default False;
    property PressedColor: TARGBColorBridge read FPressedColor write SetPressedColor;
    property RoundRadiusCorner: integer read FRoundRadiusCorner write SetRoundRadiusCorner;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function KToyButton_jCreate(env: PJNIEnv;_self: int64; this: jObject): jObject;
procedure KToyButton_kFree(env: PJNIEnv; _ktoybutton: JObject);
procedure KToyButton_SetViewParent(env: PJNIEnv; _ktoybutton: JObject; _viewgroup: jObject);
function KToyButton_GetParent(env: PJNIEnv; _ktoybutton: JObject): jObject;
procedure KToyButton_RemoveFromViewParent(env: PJNIEnv; _ktoybutton: JObject);
function KToyButton_GetView(env: PJNIEnv; _ktoybutton: JObject): jObject;
procedure KToyButton_SetLParamWidth(env: PJNIEnv; _ktoybutton: JObject; _w: integer);
procedure KToyButton_SetLParamHeight(env: PJNIEnv; _ktoybutton: JObject; _h: integer);
function KToyButton_GetLParamWidth(env: PJNIEnv; _ktoybutton: JObject): integer;
function KToyButton_GetLParamHeight(env: PJNIEnv; _ktoybutton: JObject): integer;
procedure KToyButton_SetLGravity(env: PJNIEnv; _ktoybutton: JObject; _g: integer);
procedure KToyButton_SetLWeight(env: PJNIEnv; _ktoybutton: JObject; _w: single);
procedure KToyButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _ktoybutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure KToyButton_AddLParamsAnchorRule(env: PJNIEnv; _ktoybutton: JObject; _rule: integer);
procedure KToyButton_AddLParamsParentRule(env: PJNIEnv; _ktoybutton: JObject; _rule: integer);
procedure KToyButton_SetLayoutAll(env: PJNIEnv; _ktoybutton: JObject; _idAnchor: integer);
procedure KToyButton_ClearLayoutAll(env: PJNIEnv; _ktoybutton: JObject);
procedure KToyButton_SetId(env: PJNIEnv; _ktoybutton: JObject; _id: integer);

procedure KToyButton_SetPressedColor(env: PJNIEnv; _ktoybutton: JObject; _color: integer);
procedure KToyButton_SetUnPressedColor(env: PJNIEnv; _ktoybutton: JObject; _color: integer);
procedure KToyButton_SetRoundRadiusCorner(env: PJNIEnv; _ktoybutton: JObject; _roundRadiusCorner: integer);
procedure KToyButton_SetShapeType(env: PJNIEnv; _ktoybutton: JObject; _shapeType: integer);
procedure KToyButton_SetText(env: PJNIEnv; _ktoybutton: JObject; _text: string);
function KToyButton_GetText(env: PJNIEnv; _ktoybutton: JObject): string;
procedure KToyButton_SetEnable(env: PJNIEnv; _ktoybutton: JObject; _value: boolean);


implementation

{---------  KToyButton  --------------}

constructor KToyButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 40;
  FWidth        := 100;

  FLParamWidth  := lpHalfOfParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent

  FText:= '';
  //FFontSize:= 0;
  FPressedColor:= colbrDefault;
  FShapeType:= kstRectangle;
  FRoundRadiusCorner:= 32;


  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor KToyButton.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       kFree();
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure KToyButton.Init;
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

  KToyButton_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
  KToyButton_SetId(gApp.jni.jEnv, FjObject, Self.Id);
 end;

  KToyButton_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                        sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      KToyButton_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      KToyButton_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  KToyButton_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

 if not FInitialized then
 begin
  FInitialized := true;

  if FPressedColor <> colbrDefault then
    KToyButton_SetPressedColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FPressedColor));

  if FText <> '' then
    SetText(FText);

  if FShapeType <> kstRectangle then
    KToyButton_SetShapeType(gApp.jni.jEnv, FjObject, Ord(FShapeType));

  if FRoundRadiusCorner <> 32 then
    KToyButton_SetRoundRadiusCorner(gApp.jni.jEnv, FjObject, FRoundRadiusCorner);

  if FColor <> colbrDefault then //un-pressed
  begin
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
    KToyButton_SetUnPressedColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
  end;

  View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);

 end;
end;

procedure KToyButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure KToyButton.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure KToyButton.UpdateLayout;
begin

  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;

end;

procedure KToyButton.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

procedure KToyButton.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin

   if not FInitialized then Exit;

  KToyButton_ClearLayoutAll(gApp.jni.jEnv, FjObject );

   for rToP := rpBottom to rpCenterVertical do
      if rToP in FPositionRelativeToParent then
        KToyButton_AddLParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

   for rToA := raAbove to raAlignRight do
     if rToA in FPositionRelativeToAnchor then
       KToyButton_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));

end;

//Event : Java -> Pascal
procedure KToyButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function KToyButton.jCreate(): jObject;
begin
   Result:= KToyButton_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure KToyButton.kFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_kFree(gApp.jni.jEnv, FjObject);
end;

procedure KToyButton.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function KToyButton.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= KToyButton_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure KToyButton.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function KToyButton.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= KToyButton_GetView(gApp.jni.jEnv, FjObject);
end;

procedure KToyButton.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure KToyButton.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function KToyButton.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= KToyButton_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function KToyButton.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= KToyButton_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure KToyButton.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure KToyButton.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure KToyButton.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure KToyButton.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure KToyButton.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure KToyButton.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure KToyButton.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_ClearLayoutAll(gApp.jni.jEnv, FjObject);
end;

procedure KToyButton.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_SetId(gApp.jni.jEnv, FjObject, _id);
end;

procedure KToyButton.SetPressedColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FPressedColor:=_color;
  if FInitialized then
     KToyButton_SetPressedColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure KToyButton.SetUnPressedColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  //UnPressedColor:=_color;
  if FInitialized then
     KToyButton_SetUnPressedColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, _color));
end;


procedure KToyButton.SetRoundRadiusCorner(_roundRadiusCorner: integer);
begin
  //in designing component state: set value here...
  FRoundRadiusCorner:= _roundRadiusCorner;
  if FInitialized then
     KToyButton_SetRoundRadiusCorner(gApp.jni.jEnv, FjObject, _roundRadiusCorner);
end;

procedure KToyButton.SetShapeType(_shapeType: TKToyShapeType);
begin
  //in designing component state: set value here...
  FShapeType:= _shapeType;
  if FInitialized then
     KToyButton_SetShapeType(gApp.jni.jEnv, FjObject, Ord(_shapeType));
end;

procedure KToyButton.SetText(Value: string);
begin
  inherited SetText(Value);
  //in designing component state: set value here..
  if FInitialized then
     KToyButton_SetText(gApp.jni.jEnv, FjObject, Value);
end;

function KToyButton.GetText(): string;
begin
  //in designing component state: result value here...
  Result:= FText;
  if FInitialized then
    Result:= KToyButton_GetText(gApp.jni.jEnv, FjObject);
end;

procedure KToyButton.SetEnable(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     KToyButton_SetEnable(gApp.jni.jEnv, FjObject, _value);
end;

{-------- KToyButton_JNI_Bridge ----------}

function KToyButton_jCreate(env: PJNIEnv;_self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  Result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'KToyButton_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure KToyButton_kFree(env: PJNIEnv; _ktoybutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'kFree', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _ktoybutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetViewParent(env: PJNIEnv; _ktoybutton: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _viewgroup;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function KToyButton_GetParent(env: PJNIEnv; _ktoybutton: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _ktoybutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_RemoveFromViewParent(env: PJNIEnv; _ktoybutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _ktoybutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function KToyButton_GetView(env: PJNIEnv; _ktoybutton: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _ktoybutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetLParamWidth(env: PJNIEnv; _ktoybutton: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _w;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetLParamHeight(env: PJNIEnv; _ktoybutton: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _h;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function KToyButton_GetLParamWidth(env: PJNIEnv; _ktoybutton: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethod(env, _ktoybutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function KToyButton_GetLParamHeight(env: PJNIEnv; _ktoybutton: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethod(env, _ktoybutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetLGravity(env: PJNIEnv; _ktoybutton: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _g;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetLWeight(env: PJNIEnv; _ktoybutton: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _w;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _ktoybutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _left;
  jParams[1].i:= _top;
  jParams[2].i:= _right;
  jParams[3].i:= _bottom;
  jParams[4].i:= _w;
  jParams[5].i:= _h;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_AddLParamsAnchorRule(env: PJNIEnv; _ktoybutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _rule;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_AddLParamsParentRule(env: PJNIEnv; _ktoybutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _rule;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetLayoutAll(env: PJNIEnv; _ktoybutton: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _idAnchor;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_ClearLayoutAll(env: PJNIEnv; _ktoybutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _ktoybutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetId(env: PJNIEnv; _ktoybutton: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _id;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure KToyButton_SetPressedColor(env: PJNIEnv; _ktoybutton: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetPressedColor', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _color;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetUnPressedColor(env: PJNIEnv; _ktoybutton: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetUnPressedColor', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _color;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetRoundRadiusCorner(env: PJNIEnv; _ktoybutton: JObject; _roundRadiusCorner: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetRoundRadiusCorner', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _roundRadiusCorner;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetShapeType(env: PJNIEnv; _ktoybutton: JObject; _shapeType: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetShapeType', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _shapeType;

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetText(env: PJNIEnv; _ktoybutton: JObject; _text: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetText', '(Ljava/lang/String;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function KToyButton_GetText(env: PJNIEnv; _ktoybutton: JObject): string;
var
  jStr: JString;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetText', '()Ljava/lang/String;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jStr:= env^.CallObjectMethod(env, _ktoybutton, jMethod);

  Result := GetPStringAndDeleteLocalRef(env, jStr);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure KToyButton_SetEnable(env: PJNIEnv; _ktoybutton: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_ktoybutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _ktoybutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetEnable', '(Z)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].z:= JBool(_value);

  env^.CallVoidMethodA(env, _ktoybutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


end.
