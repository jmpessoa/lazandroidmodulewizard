unit zcamview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget, systryparent;

type

TBarcodeFormat = (
            cfNONE=0,
            cfPARTIAL=1,
            cfEAN8=8,
            cfUPCE=9,
            cfISBN10=10,
            cfUPCA=12,
            cfEAN13=13,
            cfISBN13=14,
            cfI25=25,
            cfDATABAR=34,
            cfDATABAREXP=35,
            cfCODABAR=38,
            cfCODE39=39,
            cfPDF417=57,
            cfQRCODE=64,
            cfCODE93=93,
            cfCODE128=128);

TOnScannerResult = procedure(Sender: TObject; codedata: string; codeformat: TBarcodeFormat) of object;

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [3/27/2019 1:10:10]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jZCamView = class(jVisualControl)
 private
    FOnScannerResult: TOnScannerResult;
    FFlashlightMode: TFlashlightMode;

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
    procedure Scan(); overload;
    procedure TakePicture(_filename: string); overload;
    procedure StopScan();
    procedure SetFlashlight(_flashlightMode: boolean);
    procedure SetFlashlightMode(_flashlightMode: TFlashlightMode);

    procedure GenEvent_OnZCamViewResult(Obj: TObject; pascodedata: string; codetype: integer);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FlashlightMode: TFlashlightMode read FFlashlightMode write SetFlashlightMode;

    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnScannerResult: TOnScannerResult read FOnScannerResult write FOnScannerResult;

end;

function jZCamView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jZCamView_jFree(env: PJNIEnv; _jcamview: JObject);
procedure jZCamView_SetViewParent(env: PJNIEnv; _jcamview: JObject; _viewgroup: jObject);
function jZCamView_GetParent(env: PJNIEnv; _jcamview: JObject): jObject;
procedure jZCamView_RemoveFromViewParent(env: PJNIEnv; _jcamview: JObject);
function jZCamView_GetView(env: PJNIEnv; _jcamview: JObject): jObject;
procedure jZCamView_SetLParamWidth(env: PJNIEnv; _jcamview: JObject; _w: integer);
procedure jZCamView_SetLParamHeight(env: PJNIEnv; _jcamview: JObject; _h: integer);
function jZCamView_GetLParamWidth(env: PJNIEnv; _jcamview: JObject): integer;
function jZCamView_GetLParamHeight(env: PJNIEnv; _jcamview: JObject): integer;
procedure jZCamView_SetLGravity(env: PJNIEnv; _jcamview: JObject; _g: integer);
procedure jZCamView_SetLWeight(env: PJNIEnv; _jcamview: JObject; _w: single);
procedure jZCamView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcamview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jZCamView_AddLParamsAnchorRule(env: PJNIEnv; _jcamview: JObject; _rule: integer);
procedure jZCamView_AddLParamsParentRule(env: PJNIEnv; _jcamview: JObject; _rule: integer);
procedure jZCamView_SetLayoutAll(env: PJNIEnv; _jcamview: JObject; _idAnchor: integer);
procedure jZCamView_ClearLayoutAll(env: PJNIEnv; _jcamview: JObject);
procedure jZCamView_SetId(env: PJNIEnv; _jcamview: JObject; _id: integer);
procedure jZCamView_Scan(env: PJNIEnv; _jcamview: JObject); overload;
procedure jZCamView_TakePicture(env: PJNIEnv; __jcamview: JObject; _filename: string); overload;
procedure jZCamView_StopScan(env: PJNIEnv; _jcamview: JObject);
procedure jZCamView_SetFlashlight(env: PJNIEnv; _jzcamview: JObject; _flashlightMode: boolean);


implementation

{---------  jZCamView  --------------}

constructor jZCamView.Create(AOwner: TComponent);
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
  FFlashlightMode:= fmOFF;
end;

destructor jZCamView.Destroy;
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

procedure jZCamView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin

 if not FInitialized then
 begin
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); if FjObject = nil then exit;
  if FParent <> nil then
   sysTryNewParent( FjPRLayout, FParent);

  FjPRLayoutHome:= FjPRLayout;

  jZCamView_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
  jZCamView_SetId(gApp.jni.jEnv, FjObject, Self.Id);

 end;

  jZCamView_setLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject ,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                        sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jZCamView_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jZCamView_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jZCamView_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

 if not FInitialized then
 begin
  FInitialized := true;

  if  FColor <> colbrDefault then
      View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);

  if FFlashlightMode = fmON then
       jZCamView_SetFlashlight(gApp.jni.jEnv, FjObject, True);

 end;
end;

procedure jZCamView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
     View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jZCamView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jZCamView.UpdateLayout;
begin

  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;

end;

procedure jZCamView.Refresh;
begin
  if FInitialized then
      View_Invalidate(gApp.jni.jEnv, FjObject);
end;

procedure jZCamView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin

   if not FInitialized then Exit;
    jZCamView_ClearLayoutAll(gApp.jni.jEnv, FjObject ); //gApp.jni.jEnv

   for rToP := rpBottom to rpCenterVertical do
      if rToP in FPositionRelativeToParent then
        jZCamView_AddLParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));//gApp.jni.jEnv

   for rToA := raAbove to raAlignRight do
     if rToA in FPositionRelativeToAnchor then
       jZCamView_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA)); //gApp.jni.jEnv

end;

//Event : Java -> Pascal
procedure jZCamView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jZCamView.jCreate(): jObject;
begin
   Result:= jZCamView_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis); //gApp.jni.jEnv  ,  FjThis
end;

procedure jZCamView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_jFree(gApp.jni.jEnv, FjObject);  //gApp.jni.jEnv
end;

procedure jZCamView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);  //gApp.jni.jEnv
end;

function jZCamView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZCamView_GetParent(gApp.jni.jEnv, FjObject);//gApp.jni.jEnv
end;

procedure jZCamView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_RemoveFromViewParent(gApp.jni.jEnv, FjObject); //gApp.jni.jEnv
end;

function jZCamView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZCamView_GetView(gApp.jni.jEnv, FjObject); //gApp.jni.jEnv
end;

procedure jZCamView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_SetLParamWidth(gApp.jni.jEnv, FjObject, _w); //gApp.jni.jEnv
end;

procedure jZCamView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);  //gApp.jni.jEnv
end;

function jZCamView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZCamView_GetLParamWidth(gApp.jni.jEnv, FjObject); //gApp.jni.jEnv
end;

function jZCamView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZCamView_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jZCamView.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure jZCamView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jZCamView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jZCamView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jZCamView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jZCamView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jZCamView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_ClearLayoutAll(gApp.jni.jEnv, FjObject);
end;

procedure jZCamView.Scan();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_Scan(gApp.jni.jEnv, FjObject);
end;


procedure jZCamView.TakePicture(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_TakePicture(gApp.jni.jEnv, FjObject, _filename);
end;

procedure jZCamView.StopScan();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZCamView_StopScan(gApp.jni.jEnv, FjObject);
end;

procedure jZCamView.SetFlashlight(_flashlightMode: boolean);
begin
  //in designing component state: set value here...  if FInitialized then
     jZCamView_SetFlashlight(gApp.jni.jEnv, FjObject, _flashlightMode);
end;

procedure jZCamView.SetFlashlightMode(_flashlightMode: TFlashlightMode);
begin
  //in designing component state: set value here...
  FFlashlightMode:= _flashlightMode;
  if FInitialized then
  begin
     if FFlashlightMode = fmOFF then
       jZCamView_SetFlashlight(gApp.jni.jEnv, FjObject, False)
     else
       jZCamView_SetFlashlight(gApp.jni.jEnv, FjObject, True);
  end;
end;

procedure jZCamView.GenEvent_OnZCamViewResult(Obj: TObject; pascodedata: string; codetype: integer);
begin
  if Assigned(FOnScannerResult) then FOnScannerResult(Obj, pascodedata, TBarcodeFormat(codetype));
end;

{-------- jZCamView_JNI_Bridge ----------}

function jZCamView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jZCamView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jZCamView_jFree(env: PJNIEnv; _jcamview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcamview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_SetViewParent(env: PJNIEnv; _jcamview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jZCamView_GetParent(env: PJNIEnv; _jcamview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jcamview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_RemoveFromViewParent(env: PJNIEnv; _jcamview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jcamview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jZCamView_GetView(env: PJNIEnv; _jcamview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jcamview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_SetLParamWidth(env: PJNIEnv; _jcamview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_SetLParamHeight(env: PJNIEnv; _jcamview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jZCamView_GetLParamWidth(env: PJNIEnv; _jcamview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jcamview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jZCamView_GetLParamHeight(env: PJNIEnv; _jcamview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jcamview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_SetLGravity(env: PJNIEnv; _jcamview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_SetLWeight(env: PJNIEnv; _jcamview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcamview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_AddLParamsAnchorRule(env: PJNIEnv; _jcamview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_AddLParamsParentRule(env: PJNIEnv; _jcamview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_SetLayoutAll(env: PJNIEnv; _jcamview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_ClearLayoutAll(env: PJNIEnv; _jcamview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jcamview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_SetId(env: PJNIEnv; _jcamview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZCamView_Scan(env: PJNIEnv; _jcamview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'Scan', '()V');
  env^.CallVoidMethod(env, _jcamview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZCamView_TakePicture(env: PJNIEnv; __jcamview: JObject; _filename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, __jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'TakePicture', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, __jcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZCamView_StopScan(env: PJNIEnv; _jcamview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'StopScan', '()V');
  env^.CallVoidMethod(env, _jcamview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZCamView_SetFlashlight(env: PJNIEnv; _jzcamview: JObject; _flashlightMode: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_flashlightMode);
  jCls:= env^.GetObjectClass(env, _jzcamview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFlashlight', '(Z)V');
  env^.CallVoidMethodA(env, _jzcamview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
