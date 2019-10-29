unit searchview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

TOnFocusChange = procedure(Sender: TObject; hasFocus: boolean) of object;
TOnQueryTextSubmit = procedure(Sender: TObject; query: string) of object;
TOnQueryTextChange = procedure(Sender: TObject; newQuery: string) of object;

{Draft Component code by "Lazarus Android Module Wizard" [9/23/2018 23:32:36]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jSearchView = class(jVisualControl)
 private
    FHint: string;
    FIconified: boolean;
    FOnFocusChange: TOnFocusChange;
    FOnQueryTextSubmit: TOnQueryTextSubmit;
    FOnQueryTextChange: TOnQueryTextChange;
    FOnXClick: TOnNotify;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate( _iconified: boolean): jObject;
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
    function GetQuery(): string;
    function GetQueryHint(): string;
    function IsIconfiedByDefault(): boolean;
    procedure SetIconifiedByDefault(_value: boolean);
    procedure SetQueryHint(_hint: string);

    procedure SelectAll(); overload;
    procedure SelectAll(_highlightColor: TARGBColorBridge);  overload;
    procedure SetFocus();
    procedure ClearFocus();
    procedure SetIconified(_value: boolean);

    procedure GenEvent_OnSearchViewFocusChange(Sender: TObject; hasFocus: boolean);
    procedure GenEvent_OnSearchViewQueryTextSubmit(Sender: TObject; query: string);
    procedure GenEvent_OnSearchViewQueryTextChange(Sender: TObject; newText: string);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
   // property FontColor : TARGBColorBridge  read FFontColor write SetFontColor;
    property Hint: string read FHint write SetQueryHint;
    property Iconified: boolean read FIconified write SetIconified;
    property OnXClick: TOnNotify read FOnXClick write FOnXClick;
    property OnFocusChange: TOnFocusChange read FOnFocusChange write FOnFocusChange;
    property OnQueryTextSubmit: TOnQueryTextSubmit read FOnQueryTextSubmit write FOnQueryTextSubmit;
    property OnQueryTextChange: TOnQueryTextChange read FOnQueryTextChange write FOnQueryTextChange;

end;

function jSearchView_jCreate(env: PJNIEnv;_Self: int64; _iconified: boolean; this: jObject): jObject;
procedure jSearchView_jFree(env: PJNIEnv; _jsearchview: JObject);
procedure jSearchView_SetViewParent(env: PJNIEnv; _jsearchview: JObject; _viewgroup: jObject);
function jSearchView_GetParent(env: PJNIEnv; _jsearchview: JObject): jObject;
procedure jSearchView_RemoveFromViewParent(env: PJNIEnv; _jsearchview: JObject);
function jSearchView_GetView(env: PJNIEnv; _jsearchview: JObject): jObject;
procedure jSearchView_SetLParamWidth(env: PJNIEnv; _jsearchview: JObject; _w: integer);
procedure jSearchView_SetLParamHeight(env: PJNIEnv; _jsearchview: JObject; _h: integer);
function jSearchView_GetLParamWidth(env: PJNIEnv; _jsearchview: JObject): integer;
function jSearchView_GetLParamHeight(env: PJNIEnv; _jsearchview: JObject): integer;
procedure jSearchView_SetLGravity(env: PJNIEnv; _jsearchview: JObject; _g: integer);
procedure jSearchView_SetLWeight(env: PJNIEnv; _jsearchview: JObject; _w: single);
procedure jSearchView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsearchview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jSearchView_AddLParamsAnchorRule(env: PJNIEnv; _jsearchview: JObject; _rule: integer);
procedure jSearchView_AddLParamsParentRule(env: PJNIEnv; _jsearchview: JObject; _rule: integer);
procedure jSearchView_SetLayoutAll(env: PJNIEnv; _jsearchview: JObject; _idAnchor: integer);
procedure jSearchView_ClearLayoutAll(env: PJNIEnv; _jsearchview: JObject);
procedure jSearchView_SetId(env: PJNIEnv; _jsearchview: JObject; _id: integer);
function jSearchView_GetQuery(env: PJNIEnv; _jsearchview: JObject): string;
function jSearchView_GetQueryHint(env: PJNIEnv; _jsearchview: JObject): string;
function jSearchView_IsIconfiedByDefault(env: PJNIEnv; _jsearchview: JObject): boolean;
procedure jSearchView_SetIconifiedByDefault(env: PJNIEnv; _jsearchview: JObject; _value: boolean);
procedure jSearchView_SetQueryHint(env: PJNIEnv; _jsearchview: JObject; _hint: string);

procedure jSearchView_SelectAll(env: PJNIEnv; _jsearchview: JObject); overload;
procedure jSearchView_SelectAll(env: PJNIEnv; _jsearchview: JObject; _color: integer);overload;
procedure jSearchView_SetFocus(env: PJNIEnv; _jsearchview: JObject);
procedure jSearchView_ClearFocus(env: PJNIEnv; _jsearchview: JObject);
procedure jSearchView_SetIconified(env: PJNIEnv; _jsearchview: JObject; _value: boolean);



implementation

{---------  jSearchView  --------------}

constructor jSearchView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 48; //??
  FWidth        := 192; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
  FIconified:= True;
//your code here....
end;

destructor jSearchView.Destroy;
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

procedure jSearchView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject:= jCreate(FIconified); //jSelf !

   if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   jSearchView_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jSearchView_SetId(FjEnv, FjObject, Self.Id);
  end;

  jSearchView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jSearchView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jSearchView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jSearchView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FHint <> '' then
     jSearchView_SetQueryHint(FjEnv, FjObject, FHint);

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jSearchView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jSearchView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jSearchView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jSearchView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jSearchView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnXClick) then FOnXClick(Obj);
end;

function jSearchView.jCreate( _iconified: boolean): jObject;
begin
   Result:= jSearchView_jCreate(FjEnv, int64(Self), _iconified, FjThis);
end;

procedure jSearchView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_jFree(FjEnv, FjObject);
end;

procedure jSearchView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jSearchView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSearchView_GetParent(FjEnv, FjObject);
end;

procedure jSearchView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jSearchView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSearchView_GetView(FjEnv, FjObject);
end;

procedure jSearchView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jSearchView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jSearchView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSearchView_GetLParamWidth(FjEnv, FjObject);
end;

function jSearchView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSearchView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jSearchView.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jSearchView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jSearchView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jSearchView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jSearchView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jSearchView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jSearchView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jSearchView_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jSearchView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jSearchView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

function jSearchView.GetQuery(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSearchView_GetQuery(FjEnv, FjObject);
end;

function jSearchView.GetQueryHint(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSearchView_GetQueryHint(FjEnv, FjObject);
end;

function jSearchView.IsIconfiedByDefault(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSearchView_IsIconfiedByDefault(FjEnv, FjObject);
end;

procedure jSearchView.SetIconifiedByDefault(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SetIconifiedByDefault(FjEnv, FjObject, _value);
end;

procedure jSearchView.SetQueryHint(_hint: string);
begin
  //in designing component state: set value here...
  FHint:= _hint;
  if FInitialized then
     jSearchView_SetQueryHint(FjEnv, FjObject, _hint);
end;

procedure jSearchView.SelectAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SelectAll(FjEnv, FjObject);
end;

procedure jSearchView.SelectAll(_highlightColor: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SelectAll(FjEnv, FjObject, GetARGB(FCustomColor, _highlightColor));
end;

procedure jSearchView.SetFocus();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_SetFocus(FjEnv, FjObject);
end;

procedure jSearchView.ClearFocus();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSearchView_ClearFocus(FjEnv, FjObject);
end;

procedure jSearchView.SetIconified(_value: boolean);
begin
  //in designing component state: set value here...
  FIconified:= _value;
  if FInitialized then
     jSearchView_SetIconified(FjEnv, FjObject, _value);
end;

procedure jSearchView.GenEvent_OnSearchViewFocusChange(Sender: TObject; hasFocus: boolean);
begin
   if Assigned(FOnFocusChange) then FOnFocusChange(Sender, hasFocus);
end;

procedure jSearchView.GenEvent_OnSearchViewQueryTextSubmit(Sender: TObject; query: string);
begin
  if Assigned(FOnQueryTextSubmit) then FOnQueryTextSubmit(Sender, query);
end;

procedure jSearchView.GenEvent_OnSearchViewQueryTextChange(Sender: TObject; newText: string);
begin
 if Assigned(FOnQueryTextChange) then FOnQueryTextChange(Sender, newText);
end;


{-------- jSearchView_JNI_Bridge ----------}

function jSearchView_jCreate(env: PJNIEnv;_Self: int64; _iconified: boolean; this: jObject): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].z:= JBool(_iconified);
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSearchView_jCreate', '(JZ)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jSearchView_jFree(env: PJNIEnv; _jsearchview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsearchview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_SetViewParent(env: PJNIEnv; _jsearchview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSearchView_GetParent(env: PJNIEnv; _jsearchview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jsearchview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_RemoveFromViewParent(env: PJNIEnv; _jsearchview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsearchview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSearchView_GetView(env: PJNIEnv; _jsearchview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsearchview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_SetLParamWidth(env: PJNIEnv; _jsearchview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_SetLParamHeight(env: PJNIEnv; _jsearchview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSearchView_GetLParamWidth(env: PJNIEnv; _jsearchview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jsearchview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSearchView_GetLParamHeight(env: PJNIEnv; _jsearchview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jsearchview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_SetLGravity(env: PJNIEnv; _jsearchview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_SetLWeight(env: PJNIEnv; _jsearchview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsearchview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_AddLParamsAnchorRule(env: PJNIEnv; _jsearchview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_AddLParamsParentRule(env: PJNIEnv; _jsearchview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_SetLayoutAll(env: PJNIEnv; _jsearchview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_ClearLayoutAll(env: PJNIEnv; _jsearchview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsearchview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_SetId(env: PJNIEnv; _jsearchview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSearchView_GetQuery(env: PJNIEnv; _jsearchview: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetQuery', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jsearchview, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jSearchView_GetQueryHint(env: PJNIEnv; _jsearchview: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetQueryHint', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jsearchview, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jSearchView_IsIconfiedByDefault(env: PJNIEnv; _jsearchview: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'IsIconfiedByDefault', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jsearchview, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_SetIconifiedByDefault(env: PJNIEnv; _jsearchview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIconifiedByDefault', '(Z)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSearchView_SetQueryHint(env: PJNIEnv; _jsearchview: JObject; _hint: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_hint));
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetQueryHint', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSearchView_SelectAll(env: PJNIEnv; _jsearchview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SelectAll', '()V');
  env^.CallVoidMethod(env, _jsearchview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSearchView_SetFocus(env: PJNIEnv; _jsearchview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFocus', '()V');
  env^.CallVoidMethod(env, _jsearchview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSearchView_SetIconified(env: PJNIEnv; _jsearchview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIconified', '(Z)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSearchView_SelectAll(env: PJNIEnv; _jsearchview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'SelectAll', '(I)V');
  env^.CallVoidMethodA(env, _jsearchview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSearchView_ClearFocus(env: PJNIEnv; _jsearchview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsearchview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearFocus', '()V');
  env^.CallVoidMethod(env, _jsearchview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
