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
procedure jsTabLayout_SetCustomView(env: PJNIEnv; _jstablayout: JObject; _position: integer; _view: jObject);
function jsTabLayout_GetTabAt(env: PJNIEnv; _jstablayout: JObject; _position: integer): jObject;


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
       jni_proc(FjEnv, FjObject, 'jFree');
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

   View_SetViewParent(FjEnv, FjObject, FjPRLayout);
   View_SetId(FjEnv, FjObject, Self.Id);
  end;

  View_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
    if rToA in FPositionRelativeToAnchor then
      View_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));

  for rToP := rpBottom to rpCenterVertical do
    if rToP in FPositionRelativeToParent then
      View_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  View_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FFitsSystemWindows  then
     SetFitsSystemWindows(FFitsSystemWindows);

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

procedure jsTabLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsTabLayout.GetParent(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetParent(FjEnv, FjObject);
end;

procedure jsTabLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     View_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsTabLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetView(FjEnv, FjObject);
end;

procedure jsTabLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsTabLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsTabLayout.GetLParamWidth(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetLParamWidth(FjEnv, FjObject);
end;

function jsTabLayout.GetLParamHeight(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsTabLayout.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jsTabLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsTabLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsTabLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsTabLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsTabLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsTabLayout.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     View_ClearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          View_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         View_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

function jsTabLayout.AddTab(_title: string): integer;
begin
  Result := -1;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_t_out_i(FjEnv, FjObject, 'AddTab', _title);
end;

procedure jsTabLayout.SetupWithViewPager(_viewPage: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_viw(FjEnv, FjObject, 'SetupWithViewPager', _viewPage);
end;

procedure jsTabLayout.SetFitsSystemWindows(_value: boolean);
begin
  if FjObject = nil then exit;
  //in designing component state: set value here...
  FFitsSystemWindows:= _value;

  jni_proc_z(FjEnv, FjObject, 'SetFitsSystemWindows', _value);
end;

function jsTabLayout.GetTabCount(): integer;
begin
  Result := 0;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetTabCount');
end;

procedure jsTabLayout.SetTabTextColors(_normalColor: TARGBColorBridge; _selectedColor: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ii(FjEnv, FjObject, 'SetTabTextColors', GetARGB(FCustomColor, _normalColor), GetARGB(FCustomColor, _selectedColor));
end;

procedure jsTabLayout.SetIcon(_position: integer; _iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_it(FjEnv, FjObject, 'SetIcon', _position ,_iconIdentifier);
end;

procedure jsTabLayout.SetPosition(_position: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetPosition', _position);
end;

function jsTabLayout.GetPosition(): integer;
begin
  Result := -1;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_i(FjEnv, FjObject, 'GetPosition');
end;

function jsTabLayout.IsSelected(_position: integer): boolean;
begin
  Result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_i_out_z(FjEnv, FjObject, 'IsSelected', _position);
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
     jni_proc_it(FjEnv, FjObject, 'SetTitle', _position ,_title);
end;

function jsTabLayout.GetTitle(_position: integer): string;
begin
  Result := '';
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_i_out_t(FjEnv, FjObject, 'GetTitle', _position);
end;

procedure jsTabLayout.SetTabMode(_tabMode: TTabMode);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetTabMode', Ord(_tabmode) );
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
     jni_proc_i(FjEnv, FjObject, 'SetSelectedTabIndicatorColor', GetARGB(FCustomColor, _color));
end;

procedure jsTabLayout.SetSelectedTabIndicatorHeight(_height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetSelectedTabIndicatorHeight', _height);
end;

procedure jsTabLayout.SetTabGravity(_tabGravity: TTabGravity);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetTabGravity', Ord(_tabGravity) );
end;

procedure jsTabLayout.SetElevation(_value: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(FjEnv, FjObject, 'SetElevation', _value);
end;

procedure jsTabLayout.SetBackgroundToPrimaryColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'SetBackgroundToPrimaryColor');
end;

{-------- jsTabLayout_JNI_Bridge ----------}

function jsTabLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin
  result := nil;

  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jsTabLayout_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure jsTabLayout_SetCustomView(env: PJNIEnv; _jstablayout: JObject; _position: integer; _view: jObject);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jstablayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetCustomView', '(ILandroid/view/View;)V');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _position;
  jParams[1].l:= _view;

  env^.CallVoidMethodA(env, _jstablayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jsTabLayout_GetTabAt(env: PJNIEnv; _jstablayout: JObject; _position: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  jCls:= env^.GetObjectClass(env, _jstablayout);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetTabAt', '(I)UNKNOWN');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].i:= _position;

  Result:= env^.CallObjectMethodA(env, _jstablayout, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;



end.
