unit csignaturepad;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget, systryparent;

type

TOnSignaturePadStartSigning=procedure(Sender:TObject) of object;
TOnSignaturePadSigned=procedure(Sender:TObject) of object;
TOnSignaturePadClear=procedure(Sender:TObject) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [7/29/2019 17:01:25]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jcSignaturePad = class(jVisualControl)
 private
    FPenColor: TARGBColorBridge;
    FMinPenStrokeWidth: single;
    FMaxPenStrokeWidth: single;
    FVelocityFilterWeight: single;
    FOnSignaturePadStartSigning: TOnSignaturePadStartSigning;
    FOnSignaturePadSigned: TOnSignaturePadSigned;
    FOnSignaturePadClear: TOnSignaturePadClear;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background

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
    
    procedure SaveToGalleryJPG(_fileName: string); overload;
    procedure SaveToGalleryJPG(); overload;
    procedure Clear();
    procedure SetPenColor(_color: TARGBColorBridge);
    procedure SetMinPenStrokeWidth(_minWidth: single);
    procedure SetMaxPenStrokeWidth(_maxWidth: single);
    procedure SetVelocityFilterWeight(_velocityFilterWeight: single);
    function GetSignatureBitmap(): jObject;
    function GetTransparentSignatureBitmap(): jObject;
    function GetSignatureSVG(): string;
    procedure SaveToFileJPG(_path: string; _fileName: string);

    procedure GenEvent_OnSignaturePadStartSigning(Sender:TObject);
    procedure GenEvent_OnSignaturePadSigned(Sender:TObject);
    procedure GenEvent_OnSignaturePadClear(Sender:TObject);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property PenColor: TARGBColorBridge read FPenColor write SetPenColor;
    property MinPenStrokeWidth: single read FMinPenStrokeWidth write SetMinPenStrokeWidth;
    property MaxPenStrokeWidth: single read FMaxPenStrokeWidth write SetMaxPenStrokeWidth;
    property VelocityFilterWeight: single read FVelocityFilterWeight write SetVelocityFilterWeight;
    property OnStartSigning: TOnSignaturePadStartSigning read FOnSignaturePadStartSigning write FOnSignaturePadStartSigning;
    property OnSigned: TOnSignaturePadSigned read FOnSignaturePadSigned write FOnSignaturePadSigned;
    property OnClear: TOnSignaturePadClear read FOnSignaturePadClear write FOnSignaturePadClear;

end;

function jcSignaturePad_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jcSignaturePad_jFree(env: PJNIEnv; _jcsignaturepad: JObject);
procedure jcSignaturePad_SetViewParent(env: PJNIEnv; _jcsignaturepad: JObject; _viewgroup: jObject);
function jcSignaturePad_GetParent(env: PJNIEnv; _jcsignaturepad: JObject): jObject;
procedure jcSignaturePad_RemoveFromViewParent(env: PJNIEnv; _jcsignaturepad: JObject);
function jcSignaturePad_GetView(env: PJNIEnv; _jcsignaturepad: JObject): jObject;
procedure jcSignaturePad_SetLParamWidth(env: PJNIEnv; _jcsignaturepad: JObject; _w: integer);
procedure jcSignaturePad_SetLParamHeight(env: PJNIEnv; _jcsignaturepad: JObject; _h: integer);
function jcSignaturePad_GetLParamWidth(env: PJNIEnv; _jcsignaturepad: JObject): integer;
function jcSignaturePad_GetLParamHeight(env: PJNIEnv; _jcsignaturepad: JObject): integer;
procedure jcSignaturePad_SetLGravity(env: PJNIEnv; _jcsignaturepad: JObject; _g: integer);
procedure jcSignaturePad_SetLWeight(env: PJNIEnv; _jcsignaturepad: JObject; _w: single);
procedure jcSignaturePad_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcsignaturepad: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jcSignaturePad_AddLParamsAnchorRule(env: PJNIEnv; _jcsignaturepad: JObject; _rule: integer);
procedure jcSignaturePad_AddLParamsParentRule(env: PJNIEnv; _jcsignaturepad: JObject; _rule: integer);
procedure jcSignaturePad_SetLayoutAll(env: PJNIEnv; _jcsignaturepad: JObject; _idAnchor: integer);
procedure jcSignaturePad_ClearLayoutAll(env: PJNIEnv; _jcsignaturepad: JObject);
procedure jcSignaturePad_SetId(env: PJNIEnv; _jcsignaturepad: JObject; _id: integer);

procedure jcSignaturePad_SaveToGalleryJPG(env: PJNIEnv; _jcsignaturepad: JObject; _fileName: string); overload;
procedure jcSignaturePad_SaveToGalleryJPG(env: PJNIEnv; _jcsignaturepad: JObject); overload;
procedure jcSignaturePad_Clear(env: PJNIEnv; _jcsignaturepad: JObject);
procedure jcSignaturePad_SetPenColor(env: PJNIEnv; _jcsignaturepad: JObject; _color: integer);
procedure jcSignaturePad_SetMinPenStrokeWidth(env: PJNIEnv; _jcsignaturepad: JObject; _minWidth: single);
procedure jcSignaturePad_SetMaxPenStrokeWidth(env: PJNIEnv; _jcsignaturepad: JObject; _maxWidth: single);
procedure jcSignaturePad_SetVelocityFilterWeight(env: PJNIEnv; _jcsignaturepad: JObject; _velocityFilterWeight: single);
function jcSignaturePad_GetSignatureBitmap(env: PJNIEnv; _jcsignaturepad: JObject): jObject;
function jcSignaturePad_GetTransparentSignatureBitmap(env: PJNIEnv; _jcsignaturepad: JObject): jObject;
function jcSignaturePad_GetSignatureSVG(env: PJNIEnv; _jcsignaturepad: JObject): string;
procedure jcSignaturePad_SaveToFileJPG(env: PJNIEnv; _jcsignaturepad: JObject; _path: string; _fileName: string);

implementation

{---------  jcSignaturePad  --------------}

constructor jcSignaturePad.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 100; //??
  FWidth        := 300; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FPenColor:= colbrBlack;
  FMinPenStrokeWidth:= 3;
  FMaxPenStrokeWidth:= 7;
  FVelocityFilterWeight:= 0.9;

end;

destructor jcSignaturePad.Destroy;
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

procedure jcSignaturePad.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin

 if not FInitialized then
 begin
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  if FParent <> nil then
   sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

  FjPRLayoutHome:= FjPRLayout;

  jcSignaturePad_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jcSignaturePad_SetId(FjEnv, FjObject, Self.Id);
 end;

  jcSignaturePad_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                        sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jcSignaturePad_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jcSignaturePad_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jcSignaturePad_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

 if not FInitialized then
 begin
  FInitialized := true;

  if FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FPenColor <> colbrBlack then
     jcSignaturePad_SetPenColor(FjEnv, FjObject, GetARGB(FCustomColor, FPenColor));

  if FMinPenStrokeWidth <> 3 then;
    jcSignaturePad_SetMinPenStrokeWidth(FjEnv, FjObject, FMinPenStrokeWidth);

  if FMaxPenStrokeWidth <> 7 then
    jcSignaturePad_SetMaxPenStrokeWidth(FjEnv, FjObject, FMaxPenStrokeWidth);

  if FVelocityFilterWeight <>  0.9 then
    jcSignaturePad_SetVelocityFilterWeight(FjEnv, FjObject, FVelocityFilterWeight);

  View_SetVisible(FjEnv, FjObject, FVisible);
 end;


end;

procedure jcSignaturePad.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jcSignaturePad.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jcSignaturePad.UpdateLayout;
begin

  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);

end;

procedure jcSignaturePad.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jcSignaturePad.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin

   if not FInitialized then Exit;

  jcSignaturePad_ClearLayoutAll(FjEnv, FjObject );

   for rToP := rpBottom to rpCenterVertical do
      if rToP in FPositionRelativeToParent then
        jcSignaturePad_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

   for rToA := raAbove to raAlignRight do
     if rToA in FPositionRelativeToAnchor then
       jcSignaturePad_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));

end;

//Event : Java -> Pascal
procedure jcSignaturePad.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jcSignaturePad.jCreate(): jObject;
begin
   Result:= jcSignaturePad_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jcSignaturePad.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_jFree(FjEnv, FjObject);
end;

procedure jcSignaturePad.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jcSignaturePad.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcSignaturePad_GetParent(FjEnv, FjObject);
end;

procedure jcSignaturePad.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_RemoveFromViewParent(FjEnv, FjObject);
end;

function jcSignaturePad.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcSignaturePad_GetView(FjEnv, FjObject);
end;

procedure jcSignaturePad.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jcSignaturePad.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jcSignaturePad.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcSignaturePad_GetLParamWidth(FjEnv, FjObject);
end;

function jcSignaturePad.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcSignaturePad_GetLParamHeight(FjEnv, FjObject);
end;

procedure jcSignaturePad.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jcSignaturePad.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jcSignaturePad.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jcSignaturePad.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jcSignaturePad.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jcSignaturePad.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jcSignaturePad.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jcSignaturePad.SaveToGalleryJPG(_fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_SaveToGalleryJPG(FjEnv, FjObject, _fileName);
end;

procedure jcSignaturePad.SaveToGalleryJPG();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_SaveToGalleryJPG(FjEnv, FjObject);
end;

procedure jcSignaturePad.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_Clear(FjEnv, FjObject);
end;

procedure jcSignaturePad.SetPenColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FPenColor:= _color;
  if FInitialized then
     jcSignaturePad_SetPenColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jcSignaturePad.SetMinPenStrokeWidth(_minWidth: single);
begin
  //in designing component state: set value here...
  FMinPenStrokeWidth:= _minWidth;
  if FInitialized then
     jcSignaturePad_SetMinPenStrokeWidth(FjEnv, FjObject, _minWidth);
end;

procedure jcSignaturePad.SetMaxPenStrokeWidth(_maxWidth: single);
begin
  //in designing component state: set value here...
  FMaxPenStrokeWidth:= _maxWidth;
  if FInitialized then
     jcSignaturePad_SetMaxPenStrokeWidth(FjEnv, FjObject, _maxWidth);
end;

procedure jcSignaturePad.SetVelocityFilterWeight(_velocityFilterWeight: single);
begin
  //in designing component state: set value here...
  FVelocityFilterWeight:= _velocityFilterWeight;
  if FInitialized then
     jcSignaturePad_SetVelocityFilterWeight(FjEnv, FjObject, _velocityFilterWeight);
end;

function jcSignaturePad.GetSignatureBitmap(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcSignaturePad_GetSignatureBitmap(FjEnv, FjObject);
end;

function jcSignaturePad.GetTransparentSignatureBitmap(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcSignaturePad_GetTransparentSignatureBitmap(FjEnv, FjObject);
end;

function jcSignaturePad.GetSignatureSVG(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcSignaturePad_GetSignatureSVG(FjEnv, FjObject);
end;

procedure jcSignaturePad.SaveToFileJPG(_path: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcSignaturePad_SaveToFileJPG(FjEnv, FjObject, _path ,_fileName);
end;

procedure jcSignaturePad.GenEvent_OnSignaturePadStartSigning(Sender:TObject);
begin
  if Assigned(FOnSignaturePadStartSigning) then FOnSignaturePadStartSigning(Sender);
end;

procedure jcSignaturePad.GenEvent_OnSignaturePadSigned(Sender:TObject);
begin
  if Assigned(FOnSignaturePadSigned) then FOnSignaturePadSigned(Sender);
end;

procedure jcSignaturePad.GenEvent_OnSignaturePadClear(Sender:TObject);
begin
  if Assigned(FOnSignaturePadClear) then FOnSignaturePadClear(Sender);
end;

{-------- jcSignaturePad_JNI_Bridge ----------}

function jcSignaturePad_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jcSignaturePad_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jcSignaturePad_jFree(env: PJNIEnv; _jcsignaturepad: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetViewParent(env: PJNIEnv; _jcsignaturepad: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcSignaturePad_GetParent(env: PJNIEnv; _jcsignaturepad: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_RemoveFromViewParent(env: PJNIEnv; _jcsignaturepad: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcSignaturePad_GetView(env: PJNIEnv; _jcsignaturepad: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetLParamWidth(env: PJNIEnv; _jcsignaturepad: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetLParamHeight(env: PJNIEnv; _jcsignaturepad: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcSignaturePad_GetLParamWidth(env: PJNIEnv; _jcsignaturepad: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcSignaturePad_GetLParamHeight(env: PJNIEnv; _jcsignaturepad: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetLGravity(env: PJNIEnv; _jcsignaturepad: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetLWeight(env: PJNIEnv; _jcsignaturepad: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcsignaturepad: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_AddLParamsAnchorRule(env: PJNIEnv; _jcsignaturepad: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_AddLParamsParentRule(env: PJNIEnv; _jcsignaturepad: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetLayoutAll(env: PJNIEnv; _jcsignaturepad: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_ClearLayoutAll(env: PJNIEnv; _jcsignaturepad: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetId(env: PJNIEnv; _jcsignaturepad: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SaveToGalleryJPG(env: PJNIEnv; _jcsignaturepad: JObject; _fileName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToGalleryJPG', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SaveToGalleryJPG(env: PJNIEnv; _jcsignaturepad: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToGalleryJPG', '()V');
  env^.CallVoidMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_Clear(env: PJNIEnv; _jcsignaturepad: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '()V');
  env^.CallVoidMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetPenColor(env: PJNIEnv; _jcsignaturepad: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPenColor', '(I)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetMinPenStrokeWidth(env: PJNIEnv; _jcsignaturepad: JObject; _minWidth: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _minWidth;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMinPenStrokeWidth', '(F)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetMaxPenStrokeWidth(env: PJNIEnv; _jcsignaturepad: JObject; _maxWidth: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _maxWidth;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMaxPenStrokeWidth', '(F)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SetVelocityFilterWeight(env: PJNIEnv; _jcsignaturepad: JObject; _velocityFilterWeight: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _velocityFilterWeight;
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SetVelocityFilterWeight', '(F)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcSignaturePad_GetSignatureBitmap(env: PJNIEnv; _jcsignaturepad: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSignatureBitmap', '()Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcSignaturePad_GetTransparentSignatureBitmap(env: PJNIEnv; _jcsignaturepad: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTransparentSignatureBitmap', '()Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethod(env, _jcsignaturepad, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcSignaturePad_GetSignatureSVG(env: PJNIEnv; _jcsignaturepad: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSignatureSVG', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jcsignaturepad, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcSignaturePad_SaveToFileJPG(env: PJNIEnv; _jcsignaturepad: JObject; _path: string; _fileName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jcsignaturepad);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFileJPG', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcsignaturepad, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
