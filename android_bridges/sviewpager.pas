unit sviewpager;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

 TPagerStrip = (psNone, psTabTop, psTabBottom, psTitleTop, psTitleBottom);

{Draft Component code by "Lazarus Android Module Wizard" [1/6/2018 23:22:38]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsViewPager = class(jVisualControl)
 private
    FPagerStrip: TPagerStrip;
    FFitsSystemWindows: boolean;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate( _pageStrip: integer): jObject;
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
    procedure AddPage(_view: jObject; _title: string);
    function GetPageTitle(_position: integer): string;
    function GetPosition(): integer;
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetPosition(_position: integer);
    procedure SetAppBarLayoutScrollingViewBehavior();
    procedure SetClipToPadding(_value: boolean);
    procedure SetBackgroundToPrimaryColor();
    procedure SetPageMargin(_value: integer);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property PagerStrip: TPagerStrip read FPagerStrip write FPagerStrip;
    property FitsSystemWindows: boolean read FFitsSystemWindows write SetFitsSystemWindows;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
   // property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jsViewPager_jCreate(env: PJNIEnv;_Self: int64; _pageStrip: integer; this: jObject): jObject;
procedure jsViewPager_jFree(env: PJNIEnv; _jsviewpager: JObject);
procedure jsViewPager_SetViewParent(env: PJNIEnv; _jsviewpager: JObject; _viewgroup: jObject);
function jsViewPager_GetParent(env: PJNIEnv; _jsviewpager: JObject): jObject;
procedure jsViewPager_RemoveFromViewParent(env: PJNIEnv; _jsviewpager: JObject);
function jsViewPager_GetView(env: PJNIEnv; _jsviewpager: JObject): jObject;
procedure jsViewPager_SetLParamWidth(env: PJNIEnv; _jsviewpager: JObject; _w: integer);
procedure jsViewPager_SetLParamHeight(env: PJNIEnv; _jsviewpager: JObject; _h: integer);
function jsViewPager_GetLParamWidth(env: PJNIEnv; _jsviewpager: JObject): integer;
function jsViewPager_GetLParamHeight(env: PJNIEnv; _jsviewpager: JObject): integer;
procedure jsViewPager_SetLGravity(env: PJNIEnv; _jsviewpager: JObject; _g: integer);
procedure jsViewPager_SetLWeight(env: PJNIEnv; _jsviewpager: JObject; _w: single);
procedure jsViewPager_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsviewpager: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsViewPager_AddLParamsAnchorRule(env: PJNIEnv; _jsviewpager: JObject; _rule: integer);
procedure jsViewPager_AddLParamsParentRule(env: PJNIEnv; _jsviewpager: JObject; _rule: integer);
procedure jsViewPager_SetLayoutAll(env: PJNIEnv; _jsviewpager: JObject; _idAnchor: integer);
procedure jsViewPager_ClearLayoutAll(env: PJNIEnv; _jsviewpager: JObject);
procedure jsViewPager_SetId(env: PJNIEnv; _jsviewpager: JObject; _id: integer);
procedure jsViewPager_AddPage(env: PJNIEnv; _jsviewpager: JObject; _view: jObject; _title: string);
function jsViewPager_GetPageTitle(env: PJNIEnv; _jsviewpager: JObject; _position: integer): string;
function jsViewPager_GetPosition(env: PJNIEnv; _jsviewpager: JObject): integer;
procedure jsViewPager_SetFitsSystemWindows(env: PJNIEnv; _jsviewpager: JObject; _value: boolean);
procedure jsViewPager_SetPosition(env: PJNIEnv; _jsviewpager: JObject; _position: integer);
procedure jsViewPager_SetAppBarLayoutScrollingViewBehavior(env: PJNIEnv; _jsviewpager: JObject);
procedure jsViewPager_SetClipToPadding(env: PJNIEnv; _jsviewpager: JObject; _value: boolean);
procedure jsViewPager_SetBackgroundToPrimaryColor(env: PJNIEnv; _jsviewpager: JObject);
procedure jsViewPager_SetPageMargin(env: PJNIEnv; _jsviewpager: JObject; _value: integer);

implementation

{---------  jsViewPager  --------------}

constructor jsViewPager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 0;
  FMarginTop    := 0;
  FMarginBottom := 0;
  FMarginRight  := 0;
  FHeight       := 40; //??
  FWidth        := 100; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
  FPagerStrip:= psNone;
//your code here....
end;

destructor jsViewPager.Destroy;
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

procedure jsViewPager.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject:= jCreate(Ord(FPagerStrip)); //jSelf !

   if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   if FGravityInParent <> lgNone then
     jsViewPager_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent));


   jsViewPager_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jsViewPager_SetId(FjEnv, FjObject, Self.Id);
  end;

  jsViewPager_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsViewPager_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsViewPager_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsViewPager_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FFitsSystemWindows  then
     jsViewPager_SetFitsSystemWindows(FjEnv, FjObject, FFitsSystemWindows);

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jsViewPager.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsViewPager.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsViewPager.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jsViewPager.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsViewPager.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsViewPager.jCreate(_pageStrip: integer): jObject;
begin
  Result:= jsViewPager_jCreate(FjEnv, int64(Self) ,_pageStrip, FjThis);
end;

procedure jsViewPager.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_jFree(FjEnv, FjObject);
end;

procedure jsViewPager.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsViewPager.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsViewPager_GetParent(FjEnv, FjObject);
end;

procedure jsViewPager.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsViewPager.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsViewPager_GetView(FjEnv, FjObject);
end;

procedure jsViewPager.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsViewPager.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsViewPager.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsViewPager_GetLParamWidth(FjEnv, FjObject);
end;

function jsViewPager.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsViewPager_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsViewPager.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FInitialized then
     jsViewPager_SetLGravity(FjEnv, FjObject, Ord(_gravity));
end;

procedure jsViewPager.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsViewPager.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsViewPager.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsViewPager.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsViewPager.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsViewPager.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsViewPager_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsViewPager_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsViewPager_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsViewPager.AddPage(_view: jObject; _title: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_AddPage(FjEnv, FjObject, _view ,_title);
end;

function jsViewPager.GetPageTitle(_position: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsViewPager_GetPageTitle(FjEnv, FjObject, _position);
end;

function jsViewPager.GetPosition(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsViewPager_GetPosition(FjEnv, FjObject);
end;

procedure jsViewPager.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsViewPager_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

procedure jsViewPager.SetPosition(_position: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetPosition(FjEnv, FjObject, _position);
end;

procedure jsViewPager.SetAppBarLayoutScrollingViewBehavior();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetAppBarLayoutScrollingViewBehavior(FjEnv, FjObject);
end;

procedure jsViewPager.SetClipToPadding(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetClipToPadding(FjEnv, FjObject, _value);
end;

procedure jsViewPager.SetBackgroundToPrimaryColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetBackgroundToPrimaryColor(FjEnv, FjObject);
end;

procedure jsViewPager.SetPageMargin(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsViewPager_SetPageMargin(FjEnv, FjObject, _value);
end;

{-------- jsViewPager_JNI_Bridge ----------}

function jsViewPager_jCreate(env: PJNIEnv;_Self: int64; _pageStrip: integer; this: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].i:= _pageStrip;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsViewPager_jCreate', '(JI)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jsViewPager_jFree(env: PJNIEnv; _jsviewpager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsviewpager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_SetViewParent(env: PJNIEnv; _jsviewpager: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsViewPager_GetParent(env: PJNIEnv; _jsviewpager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jsviewpager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_RemoveFromViewParent(env: PJNIEnv; _jsviewpager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsviewpager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsViewPager_GetView(env: PJNIEnv; _jsviewpager: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsviewpager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_SetLParamWidth(env: PJNIEnv; _jsviewpager: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_SetLParamHeight(env: PJNIEnv; _jsviewpager: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsViewPager_GetLParamWidth(env: PJNIEnv; _jsviewpager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jsviewpager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsViewPager_GetLParamHeight(env: PJNIEnv; _jsviewpager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jsviewpager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_SetLGravity(env: PJNIEnv; _jsviewpager: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_SetLWeight(env: PJNIEnv; _jsviewpager: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsviewpager: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_AddLParamsAnchorRule(env: PJNIEnv; _jsviewpager: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_AddLParamsParentRule(env: PJNIEnv; _jsviewpager: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_SetLayoutAll(env: PJNIEnv; _jsviewpager: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_ClearLayoutAll(env: PJNIEnv; _jsviewpager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsviewpager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsViewPager_SetId(env: PJNIEnv; _jsviewpager: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsViewPager_AddPage(env: PJNIEnv; _jsviewpager: JObject; _view: jObject; _title: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _view;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'AddPage', '(Landroid/view/View;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jsViewPager_GetPageTitle(env: PJNIEnv; _jsviewpager: JObject; _position: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _position;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPageTitle', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jsviewpager, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jsViewPager_GetPosition(env: PJNIEnv; _jsviewpager: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPosition', '()I');
  Result:= env^.CallIntMethod(env, _jsviewpager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsViewPager_SetFitsSystemWindows(env: PJNIEnv; _jsviewpager: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsViewPager_SetPosition(env: PJNIEnv; _jsviewpager: JObject; _position: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _position;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPosition', '(I)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsViewPager_SetAppBarLayoutScrollingViewBehavior(env: PJNIEnv; _jsviewpager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAppBarLayoutScrollingViewBehavior', '()V');
  env^.CallVoidMethod(env, _jsviewpager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsViewPager_SetClipToPadding(env: PJNIEnv; _jsviewpager: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetClipToPadding', '(Z)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsViewPager_SetBackgroundToPrimaryColor(env: PJNIEnv; _jsviewpager: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundToPrimaryColor', '()V');
  env^.CallVoidMethod(env, _jsviewpager, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsViewPager_SetPageMargin(env: PJNIEnv; _jsviewpager: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jsviewpager);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPageMargin', '(I)V');
  env^.CallVoidMethodA(env, _jsviewpager, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
