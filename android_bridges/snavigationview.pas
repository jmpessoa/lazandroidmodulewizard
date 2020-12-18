unit snavigationview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/16/2017 3:45:23]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsNavigationView = class(jVisualControl)
 private
    FOnClickItem: TOnClickNavigationViewItem;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClickNavigationViewItem(Sender: TObject; itemIndex: integer; itemCaption: string);
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
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetItemBackground(_imageIdentifier: string);
    procedure SetItemBackgroundResource(_imageIdentifier: string);
    function GetMenu(): jObject;
    procedure ClearMenu();
    procedure SetLGravity(_value: TLayoutGravity);

    procedure AddHeaderView(_headerView: jObject);  overload;
    procedure AddHeaderView(_drawableBackgroundIdentifier: string; _drawableLogoIdentifier: string; _text: string; _height: integer); overload;

    function AddMenu(_headerTitle: string): jObject; overload;
    procedure AddItemIcon(_menuItem: jObject; _drawableIdentifier: string);

    procedure SetItemTextColor(_menuItem: jObject; _color: TARGBColorBridge);
    procedure SetAllItemsTextColor(_color: TARGBColorBridge);
    procedure ResetAllItemsTextColor();
    procedure SetFontColor(_color: TARGBColorBridge);
    procedure SetSelectedItemTextColor(_color: TARGBColorBridge);
    procedure AddHeaderView(_color: TARGBColorBridge; _drawableLogoIdentifier: string; _text: string; _height: integer);overload;
    function AddItem(_menu: jObject; _itemId: integer; _itemCaption: string): jObject;  overload;
    procedure AddItem(_menu: jObject; _itemId: integer; _itemCaption: string; _drawableIdentifier: string); overload;
    procedure SetSubtitleTextColor(_color: integer);
    procedure SetTitleTextColor(_color: integer);

    procedure SetTitleTextSize(_textSize: integer);
    procedure SetTitleSizeDecorated(_sizeDecorated: TTextSizeDecorated);
    procedure SetTitleSizeDecoratedGap(_textSizeGap: single);  //default = 3
    procedure AddHeaderView(_color: integer; _bitmapLogo: jObject; _text: string; _height: integer);overload;
    procedure AddHeaderView(_drawableBackgroundIdentifier: string; _bitmapLogo: jObject; _text: string; _height: integer);overload;
    procedure SetLogoPosition(_logoPosition: TPositionRelativeToParent); //default = rpCenterInParent


 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property FontColor : TARGBColorBridge  read FFontColor write SetFontColor;
    property OnClickItem: TOnClickNavigationViewItem read FOnClickItem write FOnClickItem;

end;

function jsNavigationView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsNavigationView_jFree(env: PJNIEnv; _jsnavigationview: JObject);
procedure jsNavigationView_SetViewParent(env: PJNIEnv; _jsnavigationview: JObject; _viewgroup: jObject);
function jsNavigationView_GetParent(env: PJNIEnv; _jsnavigationview: JObject): jObject;
procedure jsNavigationView_RemoveFromViewParent(env: PJNIEnv; _jsnavigationview: JObject);
function jsNavigationView_GetView(env: PJNIEnv; _jsnavigationview: JObject): jObject;
procedure jsNavigationView_SetLParamWidth(env: PJNIEnv; _jsnavigationview: JObject; _w: integer);
procedure jsNavigationView_SetLParamHeight(env: PJNIEnv; _jsnavigationview: JObject; _h: integer);
function jsNavigationView_GetLParamWidth(env: PJNIEnv; _jsnavigationview: JObject): integer;
function jsNavigationView_GetLParamHeight(env: PJNIEnv; _jsnavigationview: JObject): integer;
procedure jsNavigationView_SetLWeight(env: PJNIEnv; _jsnavigationview: JObject; _w: single);
procedure jsNavigationView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsnavigationview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsNavigationView_AddLParamsAnchorRule(env: PJNIEnv; _jsnavigationview: JObject; _rule: integer);
procedure jsNavigationView_AddLParamsParentRule(env: PJNIEnv; _jsnavigationview: JObject; _rule: integer);
procedure jsNavigationView_SetLayoutAll(env: PJNIEnv; _jsnavigationview: JObject; _idAnchor: integer);
procedure jsNavigationView_ClearLayoutAll(env: PJNIEnv; _jsnavigationview: JObject);
procedure jsNavigationView_SetId(env: PJNIEnv; _jsnavigationview: JObject; _id: integer);
procedure jsNavigationView_SetItemBackground(env: PJNIEnv; _jsnavigationview: JObject; _imageIdentifier: string);
procedure jsNavigationView_SetItemBackgroundResource(env: PJNIEnv; _jsnavigationview: JObject; _imageIdentifier: string);
function jsNavigationView_GetMenu(env: PJNIEnv; _jsnavigationview: JObject): jObject;
procedure jsNavigationView_ClearMenu(env: PJNIEnv; _jsnavigationview: JObject);
procedure jsNavigationView_SetFrameGravity(env: PJNIEnv; _jsnavigationview: JObject; _value: integer);
procedure jsNavigationView_AddHeaderView(env: PJNIEnv; _jsnavigationview: JObject; _headerView: jObject); overload;
function jsNavigationView_AddMenu(env: PJNIEnv; _jsnavigationview: JObject; _headerTitle: string): jObject; overload;
procedure jsNavigationView_AddItemIcon(env: PJNIEnv; _jsnavigationview: JObject; _menuItem: jObject; _drawableIdentifier: string);
procedure jsNavigationView_SetItemTextColor(env: PJNIEnv; _jsnavigationview: JObject; _menuItem: jObject; _color: integer); overload;
procedure jsNavigationView_SetAllItemsTextColor(env: PJNIEnv; _jsnavigationview: JObject; _color: integer);
procedure jsNavigationView_ResetAllItemsTextColor(env: PJNIEnv; _jsnavigationview: JObject);
procedure jsNavigationView_SetItemTextColor(env: PJNIEnv; _jsnavigationview: JObject; _color: integer); overload;
procedure jsNavigationView_SetSelectedItemTextColor(env: PJNIEnv; _jsnavigationview: JObject; _color: integer);
procedure jsNavigationView_AddHeaderView(env: PJNIEnv; _jsnavigationview: JObject; _color: integer; _drawableIdentifier: string; _text: string; _height: integer); overload;
function jsNavigationView_AddItem(env: PJNIEnv; _jsnavigationview: JObject; _menu: jObject; _itemId: integer; _itemCaption: string): jObject; overload;
procedure jsNavigationView_AddItem(env: PJNIEnv; _jsnavigationview: JObject; _menu: jObject; _itemId: integer; _itemCaption: string; _drawableIdentifier: string); overload;
procedure jsNavigationView_SetSubtitleTextColor(env: PJNIEnv; _jsnavigationview: JObject; _color: integer);
procedure jsNavigationView_SetTitleTextColor(env: PJNIEnv; _jsnavigationview: JObject; _color: integer);
procedure jsNavigationView_AddHeaderView(env: PJNIEnv; _jsnavigationview: JObject; _drawableBackgroundIdentifier: string; _drawableLogoIdentifier: string; _text: string; _height: integer); overload;

procedure jsNavigationView_SetTitleTextSize(env: PJNIEnv; _jsnavigationview: JObject; _textSize: integer);
procedure jsNavigationView_SetTitleSizeDecorated(env: PJNIEnv; _jsnavigationview: JObject; _sizeDecorated: integer);
procedure jsNavigationView_SetTitleSizeDecoratedGap(env: PJNIEnv; _jsnavigationview: JObject; _textSizeGap: single);
procedure jsNavigationView_AddHeaderView(env: PJNIEnv; _jsnavigationview: JObject; _color: integer; _bitmapLogo: jObject; _text: string; _height: integer);overload;
procedure jsNavigationView_AddHeaderView(env: PJNIEnv; _jsnavigationview: JObject; _drawableBackgroundIdentifier: string; _bitmapLogo: jObject; _text: string; _height: integer);overload;
procedure jsNavigationView_SetLogoPosition(env: PJNIEnv; _jsnavigationview: JObject; _logoPosition: integer);

implementation

{---------  jsNavigationView  --------------}

constructor jsNavigationView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 0;
  FMarginTop    := 0;
  FMarginBottom := 0;
  FMarginRight  := 0;
  FHeight       := 96; //??
  FWidth        := 192; //??
  FLParamWidth  := lpWrapContent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
  FGravityInParent:= lgLeft;
//your code here....
end;

destructor jsNavigationView.Destroy;
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

procedure jsNavigationView.Init(refApp: jApp);
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

       //http://androidahead.com/2017/01/12/navigation-drawer
   if FGravityInParent <> lgNone then
     jsNavigationView_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent) );

   jsNavigationView_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jsNavigationView_SetId(FjEnv, FjObject, Self.Id);
  end;

  jsNavigationView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsNavigationView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsNavigationView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsNavigationView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if FFontColor <> colbrDefault then
     jsNavigationView_SetItemTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jsNavigationView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsNavigationView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsNavigationView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jsNavigationView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsNavigationView.GenEvent_OnClickNavigationViewItem(Sender: TObject; itemIndex: integer; itemCaption: string);
begin
  if Assigned(FOnClickItem) then FOnClickItem(Sender, itemIndex, itemCaption);
end;

function jsNavigationView.jCreate(): jObject;
begin
   Result:= jsNavigationView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsNavigationView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_jFree(FjEnv, FjObject);
end;

procedure jsNavigationView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsNavigationView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsNavigationView_GetParent(FjEnv, FjObject);
end;

procedure jsNavigationView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsNavigationView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsNavigationView_GetView(FjEnv, FjObject);
end;

procedure jsNavigationView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsNavigationView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsNavigationView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsNavigationView_GetLParamWidth(FjEnv, FjObject);
end;

function jsNavigationView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsNavigationView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsNavigationView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsNavigationView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsNavigationView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsNavigationView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsNavigationView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsNavigationView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jsNavigationView_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jsNavigationView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jsNavigationView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsNavigationView.SetItemBackground(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetItemBackground(FjEnv, FjObject, _imageIdentifier);
end;

procedure jsNavigationView.SetItemBackgroundResource(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetItemBackgroundResource(FjEnv, FjObject, _imageIdentifier);
end;

function jsNavigationView.GetMenu(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsNavigationView_GetMenu(FjEnv, FjObject);
end;

(*
procedure jsNavigationView.AddMenuItemInNavMenuDrawer();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_AddMenuItemInNavMenuDrawer(FjEnv, FjObject);
end;
*)

procedure jsNavigationView.ClearMenu();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_ClearMenu(FjEnv, FjObject);
end;

procedure jsNavigationView.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:=  _value;
  if FInitialized then
     jsNavigationView_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent) );
end;

procedure jsNavigationView.AddHeaderView(_headerView: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_AddHeaderView(FjEnv, FjObject, _headerView);
end;

function jsNavigationView.AddMenu(_headerTitle: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsNavigationView_AddMenu(FjEnv, FjObject, _headerTitle);
end;

procedure jsNavigationView.AddItemIcon(_menuItem: jObject; _drawableIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_AddItemIcon(FjEnv, FjObject, _menuItem ,_drawableIdentifier);
end;

procedure jsNavigationView.SetItemTextColor(_menuItem: jObject; _color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetItemTextColor(FjEnv, FjObject, _menuItem ,  GetARGB(FCustomColor, _color));
end;

procedure jsNavigationView.SetAllItemsTextColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetAllItemsTextColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsNavigationView.ResetAllItemsTextColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_ResetAllItemsTextColor(FjEnv, FjObject);
end;

procedure jsNavigationView.SetFontColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FFontColor:=  _color;
  if FInitialized then
     jsNavigationView_SetItemTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));
end;

procedure jsNavigationView.SetSelectedItemTextColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetSelectedItemTextColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jsNavigationView.AddHeaderView(_color: TARGBColorBridge; _drawableLogoIdentifier: string; _text: string; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_AddHeaderView(FjEnv, FjObject, GetARGB(FCustomColor, _color) ,_drawableLogoIdentifier ,_text ,_height);
end;

function jsNavigationView.AddItem(_menu: jObject; _itemId: integer; _itemCaption: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsNavigationView_AddItem(FjEnv, FjObject, _menu ,_itemId ,_itemCaption);
end;

procedure jsNavigationView.AddItem(_menu: jObject; _itemId: integer; _itemCaption: string; _drawableIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_AddItem(FjEnv, FjObject, _menu ,_itemId ,_itemCaption ,_drawableIdentifier);
end;

procedure jsNavigationView.SetSubtitleTextColor(_color: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetSubtitleTextColor(FjEnv, FjObject, _color);
end;

procedure jsNavigationView.SetTitleTextColor(_color: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetTitleTextColor(FjEnv, FjObject, _color);
end;

procedure jsNavigationView.AddHeaderView(_drawableBackgroundIdentifier: string; _drawableLogoIdentifier: string; _text: string; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_AddHeaderView(FjEnv, FjObject, _drawableBackgroundIdentifier ,_drawableLogoIdentifier ,_text ,_height);
end;

procedure jsNavigationView.SetTitleTextSize(_textSize: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetTitleTextSize(FjEnv, FjObject, _textSize);
end;

procedure jsNavigationView.SetTitleSizeDecorated(_sizeDecorated: TTextSizeDecorated);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetTitleSizeDecorated(FjEnv, FjObject, Ord(_sizeDecorated) );
end;

procedure jsNavigationView.SetTitleSizeDecoratedGap(_textSizeGap: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetTitleSizeDecoratedGap(FjEnv, FjObject, _textSizeGap);
end;

procedure jsNavigationView.AddHeaderView(_color: integer; _bitmapLogo: jObject; _text: string; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_AddHeaderView(FjEnv, FjObject, _color ,_bitmapLogo ,_text ,_height);
end;

procedure jsNavigationView.AddHeaderView(_drawableBackgroundIdentifier: string; _bitmapLogo: jObject; _text: string; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_AddHeaderView(FjEnv, FjObject, _drawableBackgroundIdentifier ,_bitmapLogo ,_text ,_height);
end;

procedure jsNavigationView.SetLogoPosition(_logoPosition: TPositionRelativeToParent);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsNavigationView_SetLogoPosition(FjEnv, FjObject, GetPositionRelativeToParent(_logoPosition) );
end;

{-------- jsNavigationView_JNI_Bridge ----------}

function jsNavigationView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsNavigationView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jsNavigationView_jCreate(long _Self) {
  return (java.lang.Object)(new jsNavigationView(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jsNavigationView_jFree(env: PJNIEnv; _jsnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetViewParent(env: PJNIEnv; _jsnavigationview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNavigationView_GetParent(env: PJNIEnv; _jsnavigationview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_RemoveFromViewParent(env: PJNIEnv; _jsnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNavigationView_GetView(env: PJNIEnv; _jsnavigationview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetLParamWidth(env: PJNIEnv; _jsnavigationview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetLParamHeight(env: PJNIEnv; _jsnavigationview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNavigationView_GetLParamWidth(env: PJNIEnv; _jsnavigationview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNavigationView_GetLParamHeight(env: PJNIEnv; _jsnavigationview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_SetLWeight(env: PJNIEnv; _jsnavigationview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsnavigationview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_AddLParamsAnchorRule(env: PJNIEnv; _jsnavigationview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_AddLParamsParentRule(env: PJNIEnv; _jsnavigationview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetLayoutAll(env: PJNIEnv; _jsnavigationview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_ClearLayoutAll(env: PJNIEnv; _jsnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetId(env: PJNIEnv; _jsnavigationview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetItemBackground(env: PJNIEnv; _jsnavigationview: JObject; _imageIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemBackground', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetItemBackgroundResource(env: PJNIEnv; _jsnavigationview: JObject; _imageIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemBackgroundResource', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNavigationView_GetMenu(env: PJNIEnv; _jsnavigationview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMenu', '()Landroid/view/Menu;');
  Result:= env^.CallObjectMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


(*
procedure jsNavigationView_AddMenuItemInNavMenuDrawer(env: PJNIEnv; _jsnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddMenuItemInNavMenuDrawer', '()V');
  env^.CallVoidMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;
*)

procedure jsNavigationView_ClearMenu(env: PJNIEnv; _jsnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearMenu', '()V');
  env^.CallVoidMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_SetFrameGravity(env: PJNIEnv; _jsnavigationview: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_AddHeaderView(env: PJNIEnv; _jsnavigationview: JObject; _headerView: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _headerView;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddHeaderView', '(Landroid/view/View;)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNavigationView_AddMenu(env: PJNIEnv; _jsnavigationview: JObject; _headerTitle: string): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_headerTitle));
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddMenu', '(Ljava/lang/String;)Landroid/view/Menu;');
  Result:= env^.CallObjectMethodA(env, _jsnavigationview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_SetItemTextColor(env: PJNIEnv; _jsnavigationview: JObject; _menuItem: jObject; _color: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menuItem;
  jParams[1].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemTextColor', '(Landroid/view/MenuItem;I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetAllItemsTextColor(env: PJNIEnv; _jsnavigationview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetAllItemsTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_ResetAllItemsTextColor(env: PJNIEnv; _jsnavigationview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'ResetAllItemsTextColor', '()V');
  env^.CallVoidMethod(env, _jsnavigationview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetItemTextColor(env: PJNIEnv; _jsnavigationview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetItemTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_SetSelectedItemTextColor(env: PJNIEnv; _jsnavigationview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedItemTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_AddHeaderView(env: PJNIEnv; _jsnavigationview: JObject; _color: integer; _drawableIdentifier: string; _text: string; _height: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_drawableIdentifier));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[3].i:= _height;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddHeaderView', '(ILjava/lang/String;Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jsNavigationView_AddItem(env: PJNIEnv; _jsnavigationview: JObject; _menu: jObject; _itemId: integer; _itemCaption: string): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menu;
  jParams[1].i:= _itemId;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_itemCaption));
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddItem', '(Landroid/view/Menu;ILjava/lang/String;)Landroid/view/MenuItem;');
  Result:= env^.CallObjectMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_AddItem(env: PJNIEnv; _jsnavigationview: JObject; _menu: jObject; _itemId: integer; _itemCaption: string; _drawableIdentifier: string);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menu;
  jParams[1].i:= _itemId;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_itemCaption));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_drawableIdentifier));
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddItem', '(Landroid/view/Menu;ILjava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_AddItemIcon(env: PJNIEnv; _jsnavigationview: JObject; _menuItem: jObject; _drawableIdentifier: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _menuItem;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_drawableIdentifier));
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddItemIcon', '(Landroid/view/MenuItem;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_SetSubtitleTextColor(env: PJNIEnv; _jsnavigationview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSubtitleTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_SetTitleTextColor(env: PJNIEnv; _jsnavigationview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitleTextColor', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_AddHeaderView(env: PJNIEnv; _jsnavigationview: JObject; _drawableBackgroundIdentifier: string; _drawableLogoIdentifier: string; _text: string; _height: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_drawableBackgroundIdentifier));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_drawableLogoIdentifier));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[3].i:= _height;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddHeaderView', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_SetTitleTextSize(env: PJNIEnv; _jsnavigationview: JObject; _textSize: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _textSize;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitleTextSize', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_SetTitleSizeDecorated(env: PJNIEnv; _jsnavigationview: JObject; _sizeDecorated: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _sizeDecorated;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitleSizeDecorated', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_SetTitleSizeDecoratedGap(env: PJNIEnv; _jsnavigationview: JObject; _textSizeGap: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _textSizeGap;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTitleSizeDecoratedGap', '(F)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_AddHeaderView(env: PJNIEnv; _jsnavigationview: JObject; _color: integer; _bitmapLogo: jObject; _text: string; _height: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jParams[1].l:= _bitmapLogo;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[3].i:= _height;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddHeaderView', '(ILandroid/graphics/Bitmap;Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsNavigationView_AddHeaderView(env: PJNIEnv; _jsnavigationview: JObject; _drawableBackgroundIdentifier: string; _bitmapLogo: jObject; _text: string; _height: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_drawableBackgroundIdentifier));
  jParams[1].l:= _bitmapLogo;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[3].i:= _height;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddHeaderView', '(Ljava/lang/String;Landroid/graphics/Bitmap;Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsNavigationView_SetLogoPosition(env: PJNIEnv; _jsnavigationview: JObject; _logoPosition: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _logoPosition;
  jCls:= env^.GetObjectClass(env, _jsnavigationview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLogoPosition', '(I)V');
  env^.CallVoidMethodA(env, _jsnavigationview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
