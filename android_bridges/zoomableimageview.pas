unit zoomableimageview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget, systryparent;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [11/12/2019 21:55:59]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jZoomableImageView = class(jVisualControl)
 private
    FimageIdentifier: string;
    FMaxZoom: single;

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

    procedure SetImageByResIdentifier(_imageResIdentifier: string);    // ../res/drawable
    procedure SetImage(_bitmap: jObject);
    procedure SetMaxZoom(_maxZoom: single);
    function GetMaxZoom(): single;

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property ImageIdentifier : string read FimageIdentifier write SetImageByResIdentifier;
    property MaxZoom: single read GetMaxZoom write SetMaxZoom;
   //property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jZoomableImageView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jZoomableImageView_jFree(env: PJNIEnv; _jzoomableimageview: JObject);
procedure jZoomableImageView_SetViewParent(env: PJNIEnv; _jzoomableimageview: JObject; _viewgroup: jObject);
procedure jZoomableImageView_SetId(env:PJNIEnv; _jzoomableimageview : jObject; id: DWord);
function jZoomableImageView_GetParent(env: PJNIEnv; _jzoomableimageview: JObject): jObject;
procedure jZoomableImageView_RemoveFromViewParent(env: PJNIEnv; _jzoomableimageview: JObject);
function jZoomableImageView_GetView(env: PJNIEnv; _jzoomableimageview: JObject): jObject;
procedure jZoomableImageView_SetLParamWidth(env: PJNIEnv; _jzoomableimageview: JObject; _w: integer);
procedure jZoomableImageView_SetLParamHeight(env: PJNIEnv; _jzoomableimageview: JObject; _h: integer);
function jZoomableImageView_GetLParamWidth(env: PJNIEnv; _jzoomableimageview: JObject): integer;
function jZoomableImageView_GetLParamHeight(env: PJNIEnv; _jzoomableimageview: JObject): integer;
procedure jZoomableImageView_SetLGravity(env: PJNIEnv; _jzoomableimageview: JObject; _g: integer);
procedure jZoomableImageView_SetLWeight(env: PJNIEnv; _jzoomableimageview: JObject; _w: single);
procedure jZoomableImageView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jzoomableimageview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jZoomableImageView_AddLParamsAnchorRule(env: PJNIEnv; _jzoomableimageview: JObject; _rule: integer);
procedure jZoomableImageView_AddLParamsParentRule(env: PJNIEnv; _jzoomableimageview: JObject; _rule: integer);
procedure jZoomableImageView_SetLayoutAll(env: PJNIEnv; _jzoomableimageview: JObject; _idAnchor: integer);
procedure jZoomableImageView_ClearLayoutAll(env: PJNIEnv; _jzoomableimageview: JObject);

procedure jZoomableImageView_SetImage(env: PJNIEnv; _jzoomableimageview: JObject; _bitmap: jObject);
procedure jZoomableImageView_SetMaxZoom(env: PJNIEnv; _jzoomableimageview: JObject; _maxZoom: single);
function jZoomableImageView_GetMaxZoom(env: PJNIEnv; _jzoomableimageview: JObject): single;
Procedure jZoomableImageView_SetImageByResIdentifier(env:PJNIEnv; _jzoomableimageview : jObject; _imageResIdentifier: string);

implementation

{---------  jZoomableImageView  --------------}

constructor jZoomableImageView.Create(AOwner: TComponent);
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
  FMaxZoom:= 4;
end;

destructor jZoomableImageView.Destroy;
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

procedure jZoomableImageView.Init;
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


  jZoomableImageView_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
  jZoomableImageView_SetId(gApp.jni.jEnv, FjObject, Self.Id);

  jZoomableImageView_SetMaxZoom(gApp.jni.jEnv, FjObject, FMaxZoom);
 end;

  jZoomableImageView_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                        sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jZoomableImageView_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jZoomableImageView_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jZoomableImageView_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

 if not FInitialized then
 begin
  FInitialized := true;

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
 end;
end;

procedure jZoomableImageView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jZoomableImageView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jZoomableImageView.UpdateLayout;
begin

  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;

end;

procedure jZoomableImageView.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

procedure jZoomableImageView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin

   if not FInitialized then Exit;

  jZoomableImageView_ClearLayoutAll(gApp.jni.jEnv, FjObject );

   for rToP := rpBottom to rpCenterVertical do
      if rToP in FPositionRelativeToParent then
        jZoomableImageView_AddLParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

   for rToA := raAbove to raAlignRight do
     if rToA in FPositionRelativeToAnchor then
       jZoomableImageView_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));

end;

//Event : Java -> Pascal
procedure jZoomableImageView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jZoomableImageView.jCreate(): jObject;
begin
   Result:= jZoomableImageView_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jZoomableImageView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jZoomableImageView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jZoomableImageView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZoomableImageView_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jZoomableImageView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jZoomableImageView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZoomableImageView_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jZoomableImageView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jZoomableImageView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jZoomableImageView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZoomableImageView_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jZoomableImageView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jZoomableImageView_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jZoomableImageView.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure jZoomableImageView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jZoomableImageView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jZoomableImageView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jZoomableImageView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jZoomableImageView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jZoomableImageView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_ClearLayoutAll(gApp.jni.jEnv, FjObject);
end;

procedure jZoomableImageView.SetImage(_bitmap: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jZoomableImageView_SetImage(gApp.jni.jEnv, FjObject, _bitmap);
end;

procedure jZoomableImageView.SetMaxZoom(_maxZoom: single);
begin
  //in designing component state: set value here...
  if _maxZoom <= 0 then Exit;

  FMaxZoom:= _maxZoom;
  if FInitialized then
     jZoomableImageView_SetMaxZoom(gApp.jni.jEnv, FjObject, _maxZoom);
end;

function jZoomableImageView.GetMaxZoom(): single;
begin
  //in designing component state: result value here...
  Result:= FMaxZoom;
  if FInitialized then
   Result:= jZoomableImageView_GetMaxZoom(gApp.jni.jEnv, FjObject);
end;

procedure jZoomableImageView.SetImageByResIdentifier(_imageResIdentifier: string);
begin
  FimageIdentifier:= _imageResIdentifier;
  if FInitialized then
     jZoomableImageView_SetImageByResIdentifier(gApp.jni.jEnv, FjObject , _imageResIdentifier);
end;

{-------- jZoomableImageView_JNI_Bridge ----------}

function jZoomableImageView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jZoomableImageView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jZoomableImageView_jFree(env: PJNIEnv; _jzoomableimageview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jzoomableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZoomableImageView_SetViewParent(env: PJNIEnv; _jzoomableimageview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZoomableImageView_SetId(env:PJNIEnv; _jzoomableimageview : jObject; id: DWord);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].i:= id;
   cls := env^.GetObjectClass(env, _jzoomableimageview);
 _jMethod:= env^.GetMethodID(env, cls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env,_jzoomableimageview,_jMethod,@_jParams);
  env^.DeleteLocalRef(env, cls);
 end;

function jZoomableImageView_GetParent(env: PJNIEnv; _jzoomableimageview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jzoomableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZoomableImageView_RemoveFromViewParent(env: PJNIEnv; _jzoomableimageview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jzoomableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jZoomableImageView_GetView(env: PJNIEnv; _jzoomableimageview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jzoomableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZoomableImageView_SetLParamWidth(env: PJNIEnv; _jzoomableimageview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZoomableImageView_SetLParamHeight(env: PJNIEnv; _jzoomableimageview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jZoomableImageView_GetLParamWidth(env: PJNIEnv; _jzoomableimageview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jzoomableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jZoomableImageView_GetLParamHeight(env: PJNIEnv; _jzoomableimageview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jzoomableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZoomableImageView_SetLGravity(env: PJNIEnv; _jzoomableimageview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZoomableImageView_SetLWeight(env: PJNIEnv; _jzoomableimageview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZoomableImageView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jzoomableimageview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZoomableImageView_AddLParamsAnchorRule(env: PJNIEnv; _jzoomableimageview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZoomableImageView_AddLParamsParentRule(env: PJNIEnv; _jzoomableimageview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZoomableImageView_SetLayoutAll(env: PJNIEnv; _jzoomableimageview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jZoomableImageView_ClearLayoutAll(env: PJNIEnv; _jzoomableimageview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jzoomableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZoomableImageView_SetImage(env: PJNIEnv; _jzoomableimageview: JObject; _bitmap: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetImage', '(Landroid/graphics/Bitmap;)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jZoomableImageView_SetMaxZoom(env: PJNIEnv; _jzoomableimageview: JObject; _maxZoom: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _maxZoom;
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMaxZoom', '(F)V');
  env^.CallVoidMethodA(env, _jzoomableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jZoomableImageView_GetMaxZoom(env: PJNIEnv; _jzoomableimageview: JObject): single;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jzoomableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMaxZoom', '()F');
  Result:= env^.CallFloatMethod(env, _jzoomableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

Procedure jZoomableImageView_SetImageByResIdentifier(env:PJNIEnv; _jzoomableimageview : jObject; _imageResIdentifier: string);
 var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
 begin
  _jParams[0].l := env^.NewStringUTF(env, PChar(_imageResIdentifier) );
  cls := env^.GetObjectClass(env, _jzoomableimageview);
 _jMethod:= env^.GetMethodID(env, cls, 'SetImageByResIdentifier', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env,_jzoomableimageview,_jMethod,@_jParams);
  env^.DeleteLocalRef(env,_jParams[0].l);
  env^.DeleteLocalRef(env, cls);
 end;

end.
