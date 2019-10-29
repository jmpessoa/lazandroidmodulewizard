unit stablayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

TOnTabSelected = procedure(Sender: TObject; position: integer; title: string) of object;

TTabGravity = (tgFill, tgCenter); // GRAVITY_FILL  GRAVITY_CENTER  //MODE_FIXED  MODE_SCROLLABLE
TTabMode = (tmFixed, tmScrollable);

{Draft Component code by "Lazarus Android Module Wizard" [1/3/2018 18:49:23]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsTabLayout = class(jVisualControl)
 private
    FFitsSystemWindows: boolean;
    FOnTabSelected: TOnTabSelected;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    //procedure GenEvent_OnClick(Obj: TObject);
    procedure GenEvent_OnSTabSelected(Obj: TObject;  position: integer; title: string);

    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent();  override;
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
    procedure ClearLayout();
    procedure SetupWithViewPager(_viewPage: jObject);
    procedure SetFitsSystemWindows(_value: boolean);
    function AddTab(_title: string): integer;
    function GetTabCount(): integer;
    procedure SetTabTextColors(_normalColor: TARGBColorBridge; _selectedColor: TARGBColorBridge);
    procedure SetIcon(_position: integer; _iconIdentifier: string);
    procedure SetPosition(_position: integer);
    function GetPosition(): integer;
    function IsSelected(_position: integer): boolean;
    procedure SetCustomView(_position: integer; _view: jObject);
    procedure SetTitle(_position: integer; _title: string);
    function GetTitle(_position: integer): string;
    procedure SetTabMode(_tabMode: TTabMode);
    function GetTabAt(_position: integer): jObject;
    procedure SetSelectedTabIndicatorColor(_color: TARGBColorBridge);
    procedure SetSelectedTabIndicatorHeight(_height: integer);
    procedure SetTabGravity(_tabGravity: TTabGravity);
    procedure SetElevation(_value: integer);
    procedure SetBackgroundToPrimaryColor();

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FitsSystemWindows: boolean read FFitsSystemWindows write SetFitsSystemWindows;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnTabSelected: TOnTabSelected read FOnTabSelected write FOnTabSelected;

end;

function jsTabLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsTabLayout_jFree(env: PJNIEnv; _jstablayout: JObject);
procedure jsTabLayout_SetViewParent(env: PJNIEnv; _jstablayout: JObject; _viewgroup: jObject);
function jsTabLayout_GetParent(env: PJNIEnv; _jstablayout: JObject): jObject;
procedure jsTabLayout_RemoveFromViewParent(env: PJNIEnv; _jstablayout: JObject);
function jsTabLayout_GetView(env: PJNIEnv; _jstablayout: JObject): jObject;
procedure jsTabLayout_SetLParamWidth(env: PJNIEnv; _jstablayout: JObject; _w: integer);
procedure jsTabLayout_SetLParamHeight(env: PJNIEnv; _jstablayout: JObject; _h: integer);
function jsTabLayout_GetLParamWidth(env: PJNIEnv; _jstablayout: JObject): integer;
function jsTabLayout_GetLParamHeight(env: PJNIEnv; _jstablayout: JObject): integer;
procedure jsTabLayout_SetLGravity(env: PJNIEnv; _jstablayout: JObject; _g: integer);
procedure jsTabLayout_SetLWeight(env: PJNIEnv; _jstablayout: JObject; _w: single);
procedure jsTabLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jstablayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsTabLayout_AddLParamsAnchorRule(env: PJNIEnv; _jstablayout: JObject; _rule: integer);
procedure jsTabLayout_AddLParamsParentRule(env: PJNIEnv; _jstablayout: JObject; _rule: integer);
procedure jsTabLayout_SetLayoutAll(env: PJNIEnv; _jstablayout: JObject; _idAnchor: integer);
procedure jsTabLayout_ClearLayoutAll(env: PJNIEnv; _jstablayout: JObject);
procedure jsTabLayout_SetId(env: PJNIEnv; _jstablayout: JObject; _id: integer);
procedure jsTabLayout_SetupWithViewPager(env: PJNIEnv; _jstablayout: JObject; _viewPage: jObject);
procedure jsTabLayout_SetFitsSystemWindows(env: PJNIEnv; _jstablayout: JObject; _value: boolean);

function jsTabLayout_AddTab(env: PJNIEnv; _jstablayout: JObject; _title: string): integer;

function jsTabLayout_GetTabCount(env: PJNIEnv; _jstablayout: JObject): integer;
procedure jsTabLayout_SetTabTextColors(env: PJNIEnv; _jstablayout: JObject; _normalColor: integer; _selectedColor: integer);
procedure jsTabLayout_SetIcon(env: PJNIEnv; _jstablayout: JObject; _position: integer; _iconIdentifier: string);
procedure jsTabLayout_SetPosition(env: PJNIEnv; _jstablayout: JObject; _position: integer);
function jsTabLayout_GetPosition(env: PJNIEnv; _jstablayout: JObject): integer;
function jsTabLayout_IsSelected(env: PJNIEnv; _jstablayout: JObject; _position: integer): boolean;
procedure jsTabLayout_SetCustomView(env: PJNIEnv; _jstablayout: JObject; _position: integer; _view: jObject);
procedure jsTabLayout_SetText(env: PJNIEnv; _jstablayout: JObject; _position: integer; _title: string);
function jsTabLayout_GetText(env: PJNIEnv; _jstablayout: JObject; _position: integer): string;
procedure jsTabLayout_SetTabMode(env: PJNIEnv; _jstablayout: JObject; _tabmode: integer);
function jsTabLayout_GetTabAt(env: PJNIEnv; _jstablayout: JObject; _position: integer): jObject;
procedure jsTabLayout_SetSelectedTabIndicatorColor(env: PJNIEnv; _jstablayout: JObject; _color: integer);
procedure jsTabLayout_SetSelectedTabIndicatorHeight(env: PJNIEnv; _jstablayout: JObject; _height: integer);
procedure jsTabLayout_SetTabGravity(env: PJNIEnv; _jstablayout: JObject; _tabGravity: integer);
procedure jsTabLayout_SetElevation(env: PJNIEnv; _jstablayout: JObject; _value: integer);
procedure jsTabLayout_SetBackgroundToPrimaryColor(env: PJNIEnv; _jstablayout: JObject);


implementation

{---------  jsTabLayout  --------------}

constructor jsTabLayout.Create(AOwner: TComponent);
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
//your code here....
end;

destructor jsTabLayout.Destroy;
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

procedure jsTabLayout.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject := jCreate(); if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   jsTabLayout_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jsTabLayout_SetId(FjEnv, FjObject, Self.Id);
  end;

  jsTabLayout_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsTabLayout_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsTabLayout_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsTabLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FFitsSystemWindows  then
     jsTabLayout_SetFitsSystemWindows(FjEnv, FjObject, FFitsSystemWindows);

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jsTabLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsTabLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsTabLayout.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jsTabLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
{
procedure jsTabLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
}
procedure jsTabLayout.GenEvent_OnSTabSelected(Obj: TObject;  position: integer; title: string);
begin
  if Assigned(FOnTabSelected) then FOnTabSelected(Obj, position, title);
end;

function jsTabLayout.jCreate(): jObject;
begin
   Result:= jsTabLayout_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsTabLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_jFree(FjEnv, FjObject);
end;

procedure jsTabLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsTabLayout.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTabLayout_GetParent(FjEnv, FjObject);
end;

procedure jsTabLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsTabLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTabLayout_GetView(FjEnv, FjObject);
end;

procedure jsTabLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsTabLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsTabLayout.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTabLayout_GetLParamWidth(FjEnv, FjObject);
end;

function jsTabLayout.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTabLayout_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsTabLayout.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jsTabLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsTabLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsTabLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsTabLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsTabLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsTabLayout.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsTabLayout_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsTabLayout_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsTabLayout_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

function jsTabLayout.AddTab(_title: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTabLayout_AddTab(FjEnv, FjObject, _title);
end;

procedure jsTabLayout.SetupWithViewPager(_viewPage: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetupWithViewPager(FjEnv, FjObject, _viewPage);
end;

procedure jsTabLayout.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;
  if FInitialized then
     jsTabLayout_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

function jsTabLayout.GetTabCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTabLayout_GetTabCount(FjEnv, FjObject);
end;

procedure jsTabLayout.SetTabTextColors(_normalColor: TARGBColorBridge; _selectedColor: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetTabTextColors(FjEnv, FjObject, GetARGB(FCustomColor, _normalColor), GetARGB(FCustomColor, _selectedColor));
end;

procedure jsTabLayout.SetIcon(_position: integer; _iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetIcon(FjEnv, FjObject, _position ,_iconIdentifier);
end;

procedure jsTabLayout.SetPosition(_position: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetPosition(FjEnv, FjObject, _position);
end;

function jsTabLayout.GetPosition(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTabLayout_GetPosition(FjEnv, FjObject);
end;

function jsTabLayout.IsSelected(_position: integer): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTabLayout_IsSelected(FjEnv, FjObject, _position);
end;

procedure jsTabLayout.SetCustomView(_position: integer; _view: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetCustomView(FjEnv, FjObject, _position ,_view);
end;

procedure jsTabLayout.SetTitle(_position: integer; _title: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetText(FjEnv, FjObject, _position ,_title);
end;

function jsTabLayout.GetTitle(_position: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTabLayout_GetText(FjEnv, FjObject, _position);
end;

procedure jsTabLayout.SetTabMode(_tabMode: TTabMode);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetTabMode(FjEnv, FjObject, Ord(_tabmode) );
end;

function jsTabLayout.GetTabAt(_position: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsTabLayout_GetTabAt(FjEnv, FjObject, _position);
end;

procedure jsTabLayout.SetSelectedTabIndicatorColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetSelectedTabIndicatorColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsTabLayout.SetSelectedTabIndicatorHeight(_height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetSelectedTabIndicatorHeight(FjEnv, FjObject, _height);
end;

procedure jsTabLayout.SetTabGravity(_tabGravity: TTabGravity);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetTabGravity(FjEnv, FjObject, Ord(_tabGravity) );
end;

procedure jsTabLayout.SetElevation(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetElevation(FjEnv, FjObject, _value);
end;

procedure jsTabLayout.SetBackgroundToPrimaryColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsTabLayout_SetBackgroundToPrimaryColor(FjEnv, FjObject);
end;

{-------- jsTabLayout_JNI_Bridge ----------}

function jsTabLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsTabLayout_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsTabLayout_jFree(env: PJNIEnv; _jstablayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jstablayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetViewParent(env: PJNIEnv; _jstablayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTabLayout_GetParent(env: PJNIEnv; _jstablayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jstablayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_RemoveFromViewParent(env: PJNIEnv; _jstablayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jstablayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTabLayout_GetView(env: PJNIEnv; _jstablayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jstablayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetLParamWidth(env: PJNIEnv; _jstablayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetLParamHeight(env: PJNIEnv; _jstablayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTabLayout_GetLParamWidth(env: PJNIEnv; _jstablayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jstablayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTabLayout_GetLParamHeight(env: PJNIEnv; _jstablayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jstablayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetLGravity(env: PJNIEnv; _jstablayout: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetLWeight(env: PJNIEnv; _jstablayout: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jstablayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_AddLParamsAnchorRule(env: PJNIEnv; _jstablayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_AddLParamsParentRule(env: PJNIEnv; _jstablayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetLayoutAll(env: PJNIEnv; _jstablayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_ClearLayoutAll(env: PJNIEnv; _jstablayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jstablayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetId(env: PJNIEnv; _jstablayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jsTabLayout_AddTab(env: PJNIEnv; _jstablayout: JObject; _title: string): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddTab', '(Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetupWithViewPager(env: PJNIEnv; _jstablayout: JObject; _viewPage: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewPage;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetupWithViewPager', '(Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsTabLayout_SetFitsSystemWindows(env: PJNIEnv; _jstablayout: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jsTabLayout_GetTabCount(env: PJNIEnv; _jstablayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTabCount', '()I');
  Result:= env^.CallIntMethod(env, _jstablayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetTabTextColors(env: PJNIEnv; _jstablayout: JObject; _normalColor: integer; _selectedColor: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _normalColor;
  jParams[1].i:= _selectedColor;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTabTextColors', '(II)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetIcon(env: PJNIEnv; _jstablayout: JObject; _position: integer; _iconIdentifier: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _position;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIcon', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetPosition(env: PJNIEnv; _jstablayout: JObject; _position: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _position;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPosition', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTabLayout_GetPosition(env: PJNIEnv; _jstablayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPosition', '()I');
  Result:= env^.CallIntMethod(env, _jstablayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTabLayout_IsSelected(env: PJNIEnv; _jstablayout: JObject; _position: integer): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _position;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'IsSelected', '(I)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jstablayout, jMethod, @jParams);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetCustomView(env: PJNIEnv; _jstablayout: JObject; _position: integer; _view: jObject);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _position;
  jParams[1].l:= _view;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCustomView', '(ILandroid/view/View;)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetText(env: PJNIEnv; _jstablayout: JObject; _position: integer; _title: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _position;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_title));
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetText', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTabLayout_GetText(env: PJNIEnv; _jstablayout: JObject; _position: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _position;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetText', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jstablayout, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsTabLayout_SetTabMode(env: PJNIEnv; _jstablayout: JObject; _tabmode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _tabmode;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTabMode', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsTabLayout_GetTabAt(env: PJNIEnv; _jstablayout: JObject; _position: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _position;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTabAt', '(I)UNKNOWN');
  Result:= env^.CallObjectMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetSelectedTabIndicatorColor(env: PJNIEnv; _jstablayout: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedTabIndicatorColor', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsTabLayout_SetSelectedTabIndicatorHeight(env: PJNIEnv; _jstablayout: JObject; _height: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _height;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedTabIndicatorHeight', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsTabLayout_SetTabGravity(env: PJNIEnv; _jstablayout: JObject; _tabGravity: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _tabGravity;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTabGravity', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsTabLayout_SetElevation(env: PJNIEnv; _jstablayout: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetElevation', '(I)V');
  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsTabLayout_SetBackgroundToPrimaryColor(env: PJNIEnv; _jstablayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jstablayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundToPrimaryColor', '()V');
  env^.CallVoidMethod(env, _jstablayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


end.
