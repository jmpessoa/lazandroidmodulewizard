unit scontinuousscrollableimageview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget, systryparent;

type

TScrollDirection = (sdUp, sdRight, sdDown, sdLeft);

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [5/2/2019 1:35:31]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsContinuousScrollableImageView = class(jVisualControl)
 private

    FImageIdentifier: string;
    FDirection: TScrollDirection;
    FDuration: integer;
    FScaleType: TImageScaleType;
    FLayoutWeight: single;

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
    procedure SetLGravity(_layoutgravity: TLayoutGravity);
    procedure SetLWeight(_layoutweight: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    
    procedure SetImageIdentifier(_imageIdentifier: string);
    procedure SetDirection(_direction: TScrollDirection);
    procedure SetDuration(_duration: integer);
    procedure SetScaleType(_scaleType: TImageScaleType);


 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property ImageIdentifier: string read FimageIdentifier write SetimageIdentifier;
    property Direction: TScrollDirection read FDirection write SetDirection;
    property Duration: integer read FDuration write SetDuration;
    property ScaleType: TImageScaleType read FScaleType write SetScaleType;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property LayoutWeight: single read FLayoutWeight write SetLWeight;
end;

function jsContinuousScrollableImageView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsContinuousScrollableImageView_jFree(env: PJNIEnv; _jscontinuousscrollableimageview: JObject);
procedure jsContinuousScrollableImageView_SetViewParent(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _viewgroup: jObject);
function jsContinuousScrollableImageView_GetParent(env: PJNIEnv; _jscontinuousscrollableimageview: JObject): jObject;
procedure jsContinuousScrollableImageView_RemoveFromViewParent(env: PJNIEnv; _jscontinuousscrollableimageview: JObject);
function jsContinuousScrollableImageView_GetView(env: PJNIEnv; _jscontinuousscrollableimageview: JObject): jObject;
procedure jsContinuousScrollableImageView_SetLParamWidth(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _w: integer);
procedure jsContinuousScrollableImageView_SetLParamHeight(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _h: integer);
function jsContinuousScrollableImageView_GetLParamWidth(env: PJNIEnv; _jscontinuousscrollableimageview: JObject): integer;
function jsContinuousScrollableImageView_GetLParamHeight(env: PJNIEnv; _jscontinuousscrollableimageview: JObject): integer;
procedure jsContinuousScrollableImageView_SetLGravity(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _g: integer);
procedure jsContinuousScrollableImageView_SetLWeight(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _w: single);
procedure jsContinuousScrollableImageView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsContinuousScrollableImageView_AddLParamsAnchorRule(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _rule: integer);
procedure jsContinuousScrollableImageView_AddLParamsParentRule(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _rule: integer);
procedure jsContinuousScrollableImageView_SetLayoutAll(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _idAnchor: integer);
procedure jsContinuousScrollableImageView_ClearLayoutAll(env: PJNIEnv; _jscontinuousscrollableimageview: JObject);
procedure jsContinuousScrollableImageView_SetId(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _id: integer);
procedure jsContinuousScrollableImageView_SetImageIdentifier(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _imageIdentifier: string);
procedure jsContinuousScrollableImageView_SetDirection(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _direction: integer);
procedure jsContinuousScrollableImageView_SetDuration(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _duration: integer);
procedure jsContinuousScrollableImageView_SetScaleType(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _scaleType: integer);



implementation

{---------  jsContinuousScrollableImageView  --------------}

constructor jsContinuousScrollableImageView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 48; //??
  FWidth        := 96; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FimageIdentifier:= '';
  FDirection:= sdLeft;
  FDuration:= 3000;
  FScaleType:= scaleCenterInside;
  FGravityInParent:= lgNone;
  FLayoutWeight:= 1;

end;

destructor jsContinuousScrollableImageView.Destroy;
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

procedure jsContinuousScrollableImageView.Init(refApp: jApp);
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

  if FLayoutWeight <> 1 then
    jsContinuousScrollableImageView_SetLWeight(FjEnv, FjObject, FLayoutWeight);

  if FGravityInParent <> lgNone then
    jsContinuousScrollableImageView_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent));

  jsContinuousScrollableImageView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsContinuousScrollableImageView_SetId(FjEnv, FjObject, Self.Id);
 end;

  jsContinuousScrollableImageView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                        sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsContinuousScrollableImageView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsContinuousScrollableImageView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsContinuousScrollableImageView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  jsContinuousScrollableImageView_SetImageIdentifier(FjEnv, FjObject, FImageIdentifier);
  jsContinuousScrollableImageView_SetDirection(FjEnv, FjObject, Ord(FDirection));
  jsContinuousScrollableImageView_SetDuration(FjEnv, FjObject, FDuration);
  jsContinuousScrollableImageView_SetScaleType(FjEnv, FjObject, Ord(FScaleType));

 if not FInitialized then
 begin
  FInitialized := true;

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
 end;
end;

procedure jsContinuousScrollableImageView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsContinuousScrollableImageView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsContinuousScrollableImageView.UpdateLayout;
begin

  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);

end;

procedure jsContinuousScrollableImageView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jsContinuousScrollableImageView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin

   if not FInitialized then Exit;

  jsContinuousScrollableImageView_ClearLayoutAll(FjEnv, FjObject );

   for rToP := rpBottom to rpCenterVertical do
      if rToP in FPositionRelativeToParent then
        jsContinuousScrollableImageView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

   for rToA := raAbove to raAlignRight do
     if rToA in FPositionRelativeToAnchor then
       jsContinuousScrollableImageView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));

end;

//Event : Java -> Pascal
procedure jsContinuousScrollableImageView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsContinuousScrollableImageView.jCreate(): jObject;
begin
   Result:= jsContinuousScrollableImageView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsContinuousScrollableImageView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsContinuousScrollableImageView_jFree(FjEnv, FjObject);
end;

procedure jsContinuousScrollableImageView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsContinuousScrollableImageView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsContinuousScrollableImageView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsContinuousScrollableImageView_GetParent(FjEnv, FjObject);
end;

procedure jsContinuousScrollableImageView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsContinuousScrollableImageView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsContinuousScrollableImageView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsContinuousScrollableImageView_GetView(FjEnv, FjObject);
end;

procedure jsContinuousScrollableImageView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsContinuousScrollableImageView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsContinuousScrollableImageView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsContinuousScrollableImageView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsContinuousScrollableImageView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsContinuousScrollableImageView_GetLParamWidth(FjEnv, FjObject);
end;

function jsContinuousScrollableImageView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsContinuousScrollableImageView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsContinuousScrollableImageView.SetLGravity(_layoutgravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _layoutgravity;
  if FInitialized then
     jsContinuousScrollableImageView_SetLGravity(FjEnv, FjObject, Ord(_layoutgravity));
end;

procedure jsContinuousScrollableImageView.SetLWeight(_layoutweight: single);
begin
  //in designing component state: set value here...
  FLayoutWeight:=  _layoutweight;
  if FInitialized then
     jsContinuousScrollableImageView_SetLWeight(FjEnv, FjObject, _layoutweight);
end;

procedure jsContinuousScrollableImageView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsContinuousScrollableImageView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsContinuousScrollableImageView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsContinuousScrollableImageView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsContinuousScrollableImageView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsContinuousScrollableImageView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsContinuousScrollableImageView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsContinuousScrollableImageView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsContinuousScrollableImageView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsContinuousScrollableImageView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jsContinuousScrollableImageView.SetImageIdentifier(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  FImageIdentifier:= _imageIdentifier;
  if FInitialized then
     jsContinuousScrollableImageView_SetImageIdentifier(FjEnv, FjObject, _imageIdentifier);
end;

procedure jsContinuousScrollableImageView.SetDirection(_direction: TScrollDirection);
begin
  //in designing component state: set value here...
  FDirection:= _direction;
  if FInitialized then
     jsContinuousScrollableImageView_SetDirection(FjEnv, FjObject, Ord(_direction));
end;

procedure jsContinuousScrollableImageView.SetDuration(_duration: integer);
begin
  //in designing component state: set value here...
  FDuration:= _duration;
  if FInitialized then
     jsContinuousScrollableImageView_SetDuration(FjEnv, FjObject, _duration);
end;

procedure jsContinuousScrollableImageView.SetScaleType(_scaleType: TImageScaleType);
begin
  //in designing component state: set value here...
  FScaleType:= _scaleType;
  if FInitialized then
     jsContinuousScrollableImageView_SetScaleType(FjEnv, FjObject, Ord(_scaleType));
end;

{-------- jsContinuousScrollableImageView_JNI_Bridge ----------}

function jsContinuousScrollableImageView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsContinuousScrollableImageView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsContinuousScrollableImageView_jFree(env: PJNIEnv; _jscontinuousscrollableimageview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jscontinuousscrollableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetViewParent(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsContinuousScrollableImageView_GetParent(env: PJNIEnv; _jscontinuousscrollableimageview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jscontinuousscrollableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_RemoveFromViewParent(env: PJNIEnv; _jscontinuousscrollableimageview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jscontinuousscrollableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsContinuousScrollableImageView_GetView(env: PJNIEnv; _jscontinuousscrollableimageview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jscontinuousscrollableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetLParamWidth(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetLParamHeight(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsContinuousScrollableImageView_GetLParamWidth(env: PJNIEnv; _jscontinuousscrollableimageview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jscontinuousscrollableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsContinuousScrollableImageView_GetLParamHeight(env: PJNIEnv; _jscontinuousscrollableimageview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jscontinuousscrollableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetLGravity(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetLWeight(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_AddLParamsAnchorRule(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_AddLParamsParentRule(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetLayoutAll(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_ClearLayoutAll(env: PJNIEnv; _jscontinuousscrollableimageview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jscontinuousscrollableimageview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetId(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsContinuousScrollableImageView_SetImageIdentifier(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _imageIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetImageIdentifier', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetDirection(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _direction: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _direction;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDirection', '(I)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetDuration(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _duration: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _duration;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDuration', '(I)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsContinuousScrollableImageView_SetScaleType(env: PJNIEnv; _jscontinuousscrollableimageview: JObject; _scaleType: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _scaleType;
  jCls:= env^.GetObjectClass(env, _jscontinuousscrollableimageview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetScaleType', '(I)V');
  env^.CallVoidMethodA(env, _jscontinuousscrollableimageview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
