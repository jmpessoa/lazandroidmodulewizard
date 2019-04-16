unit zbarcodescannerview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget, systryparent;

type

TBarcodeFormat = (
            cfNONE=0,
            cfPARTIAL=1,
            cfmEAN8=8,
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

jZBarcodeScannerView = class(jVisualControl)
 private
    FOnScannerResult: TOnScannerResult;
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
    procedure Scan(); overload;
    procedure Scan(_barcodeBmp: jObject); overload;

    procedure GenEvent_OnZBarcodeScannerViewResult(Obj: TObject; pascodedata: string; codetype: integer);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnScannerResult: TOnScannerResult read FOnScannerResult write FOnScannerResult;

end;

function jZBarcodeScannerView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jZBarcodeScannerView_jFree(env: PJNIEnv; _jbarcodescannerview: JObject);
procedure jZBarcodeScannerView_SetViewParent(env: PJNIEnv; _jbarcodescannerview: JObject; _viewgroup: jObject);
function jZBarcodeScannerView_GetParent(env: PJNIEnv; _jbarcodescannerview: JObject): jObject;
procedure jZBarcodeScannerView_RemoveFromViewParent(env: PJNIEnv; _jbarcodescannerview: JObject);
function jZBarcodeScannerView_GetView(env: PJNIEnv; _jbarcodescannerview: JObject): jObject;
procedure jZBarcodeScannerView_SetLParamWidth(env: PJNIEnv; _jbarcodescannerview: JObject; _w: integer);
procedure jZBarcodeScannerView_SetLParamHeight(env: PJNIEnv; _jbarcodescannerview: JObject; _h: integer);
function jZBarcodeScannerView_GetLParamWidth(env: PJNIEnv; _jbarcodescannerview: JObject): integer;
function jZBarcodeScannerView_GetLParamHeight(env: PJNIEnv; _jbarcodescannerview: JObject): integer;
procedure jZBarcodeScannerView_SetLGravity(env: PJNIEnv; _jbarcodescannerview: JObject; _g: integer);
procedure jZBarcodeScannerView_SetLWeight(env: PJNIEnv; _jbarcodescannerview: JObject; _w: single);
procedure jZBarcodeScannerView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jbarcodescannerview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jZBarcodeScannerView_AddLParamsAnchorRule(env: PJNIEnv; _jbarcodescannerview: JObject; _rule: integer);
procedure jZBarcodeScannerView_AddLParamsParentRule(env: PJNIEnv; _jbarcodescannerview: JObject; _rule: integer);
procedure jZBarcodeScannerView_SetLayoutAll(env: PJNIEnv; _jbarcodescannerview: JObject; _idAnchor: integer);
procedure jZBarcodeScannerView_ClearLayoutAll(env: PJNIEnv; _jbarcodescannerview: JObject);
procedure jZBarcodeScannerView_SetId(env: PJNIEnv; _jbarcodescannerview: JObject; _id: integer);
procedure jZBarcodeScannerView_Scan(env: PJNIEnv; _jbarcodescannerview: JObject); overload;
procedure jZBarcodeScannerView_Scan(env: PJNIEnv; _jzbarcodescannerview: JObject; _barcodeBmp: jObject); overload;


implementation

{---------  jZBarcodeScannerView  --------------}

constructor jZBarcodeScannerView.Create(AOwner: TComponent);
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

destructor jZBarcodeScannerView.Destroy;
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

procedure jZBarcodeScannerView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin

 if not FInitialized then
 begin
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  if FParent <> nil then
   sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

  FjPRLayoutHome:= FjPRLayout;

  jZBarcodeScannerView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jZBarcodeScannerView_SetId(FjEnv, FjObject, Self.Id);
 end;

  jZBarcodeScannerView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                        sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jZBarcodeScannerView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jZBarcodeScannerView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jZBarcodeScannerView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

 if not FInitialized then
 begin
  FInitialized := true;

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
 end;
end;

procedure jZBarcodeScannerView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jZBarcodeScannerView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jZBarcodeScannerView.UpdateLayout;
begin

  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);

end;

procedure jZBarcodeScannerView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jZBarcodeScannerView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin

   if not FInitialized then Exit;

  jZBarcodeScannerView_ClearLayoutAll(FjEnv, FjObject );

   for rToP := rpBottom to rpCenterVertical do
      if rToP in FPositionRelativeToParent then
        jZBarcodeScannerView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

   for rToA := raAbove to raAlignRight do
     if rToA in FPositionRelativeToAnchor then
       jZBarcodeScannerView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));

end;

//Event : Java -> Pascal
procedure jZBarcodeScannerView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jZBarcodeScannerView.jCreate(): jObject;
begin
   Result:= jZBarcodeScannerView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jZBarcodeScannerView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_jFree(FjEnv, FjObject);
end;

procedure jZBarcodeScannerView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jZBarcodeScannerView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZBarcodeScannerView_GetParent(FjEnv, FjObject);
end;

procedure jZBarcodeScannerView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jZBarcodeScannerView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZBarcodeScannerView_GetView(FjEnv, FjObject);
end;

procedure jZBarcodeScannerView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jZBarcodeScannerView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jZBarcodeScannerView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZBarcodeScannerView_GetLParamWidth(FjEnv, FjObject);
end;

function jZBarcodeScannerView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZBarcodeScannerView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jZBarcodeScannerView.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jZBarcodeScannerView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jZBarcodeScannerView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jZBarcodeScannerView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jZBarcodeScannerView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jZBarcodeScannerView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jZBarcodeScannerView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jZBarcodeScannerView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_SetId(FjEnv, FjObject, _id);
end;

procedure jZBarcodeScannerView.Scan();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_Scan(FjEnv, FjObject);
end;


procedure jZBarcodeScannerView.Scan(_barcodeBmp: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZBarcodeScannerView_Scan(FjEnv, FjObject, _barcodeBmp);
end;

procedure jZBarcodeScannerView.GenEvent_OnZBarcodeScannerViewResult(Obj: TObject; pascodedata: string; codetype: integer);
begin
  if Assigned(FOnScannerResult) then FOnScannerResult(Obj, pascodedata, TBarcodeFormat(codetype));
end;

{-------- jZBarcodeScannerView_JNI_Bridge ----------}

function jZBarcodeScannerView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jZBarcodeScannerView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jZBarcodeScannerView_jFree(env: PJNIEnv; _jbarcodescannerview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jbarcodescannerview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_SetViewParent(env: PJNIEnv; _jbarcodescannerview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jZBarcodeScannerView_GetParent(env: PJNIEnv; _jbarcodescannerview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jbarcodescannerview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_RemoveFromViewParent(env: PJNIEnv; _jbarcodescannerview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jbarcodescannerview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jZBarcodeScannerView_GetView(env: PJNIEnv; _jbarcodescannerview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jbarcodescannerview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_SetLParamWidth(env: PJNIEnv; _jbarcodescannerview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_SetLParamHeight(env: PJNIEnv; _jbarcodescannerview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jZBarcodeScannerView_GetLParamWidth(env: PJNIEnv; _jbarcodescannerview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jbarcodescannerview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jZBarcodeScannerView_GetLParamHeight(env: PJNIEnv; _jbarcodescannerview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jbarcodescannerview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_SetLGravity(env: PJNIEnv; _jbarcodescannerview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_SetLWeight(env: PJNIEnv; _jbarcodescannerview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jbarcodescannerview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_AddLParamsAnchorRule(env: PJNIEnv; _jbarcodescannerview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_AddLParamsParentRule(env: PJNIEnv; _jbarcodescannerview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_SetLayoutAll(env: PJNIEnv; _jbarcodescannerview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_ClearLayoutAll(env: PJNIEnv; _jbarcodescannerview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jbarcodescannerview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_SetId(env: PJNIEnv; _jbarcodescannerview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZBarcodeScannerView_Scan(env: PJNIEnv; _jbarcodescannerview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'Scan', '()V');
  env^.CallVoidMethod(env, _jbarcodescannerview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZBarcodeScannerView_Scan(env: PJNIEnv; _jzbarcodescannerview: JObject; _barcodeBmp: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _barcodeBmp;
  jCls:= env^.GetObjectClass(env, _jzbarcodescannerview);
  jMethod:= env^.GetMethodID(env, jCls, 'Scan', '(Landroid/graphics/Bitmap;)V');
  env^.CallVoidMethodA(env, _jzbarcodescannerview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
