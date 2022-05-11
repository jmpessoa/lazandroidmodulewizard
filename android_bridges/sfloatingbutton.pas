unit sfloatingbutton;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

TFABSize = (fabNormal, fabMini, fabAuto); //SIZE_MINI SIZE_AUTO  SIZE_NORMAL

{Draft Component code by "Lazarus Android Module Wizard" [12/11/2017 23:35:15]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsFloatingButton = class(jVisualControl)
 private
    FImageIdentifier: string;
    FElevation: single;
    FABSize: TFABSize;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
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
    procedure SetVisibility(_value: TViewVisibility);
    procedure SetCompatElevation(_value: single);
    procedure SetImageIdentifier(_imageIdentifier: string);
    procedure BringToFront();
    procedure SetSize(_value: TFABSize);
    procedure SetPressedRippleColor(_color: TARGBColorBridge);
    procedure SetContentDescription(_contentDescription: string);
    procedure ShowSnackbar(_message: string);
    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetAnchorGravity(_value: TLayoutGravity; _anchorId: integer);
    procedure SetBackgroundToPrimaryColor();

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property ImageIdentifier: string read FImageIdentifier write SetImageIdentifier;
    property Elevation: single read FElevation write SetCompatElevation;
    property Size: TFABSize read FABSize write SetSize;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property OnClick: TOnNotify read FOnClick write FOnClick;
end;

function jsFloatingButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;


implementation

{---------  jsFloatingButton  --------------}

constructor jsFloatingButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 50;
  FMarginRight  := 50;
  FHeight       := 56;
  FWidth        := 56;
  FLParamWidth  := lpWrapContent;
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FElevation:= 20;
  FABSize:= fabNormal;
end;

destructor jsFloatingButton.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jni_proc(gApp.jni.jEnv, FjObject, 'jFree');
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jsFloatingButton.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject := jCreate(); if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent);

   FjPRLayoutHome:= FjPRLayout;

   if FGravityInParent <> lgNone then
    jni_proc_i(gApp.jni.jEnv, FjObject, 'SetLGravity', Ord(FGravityInParent) );

   View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_setLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if FElevation <> 20 then
     SetCompatElevation(FElevation);

  if not FInitialized then
  begin
   FInitialized:= True;

   if FImageIdentifier<> '' then
      SetImageIdentifier(FImageIdentifier);

   if FColor <> colbrDefault then
    SetColor(FColor);

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jsFloatingButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if FInitialized and (FColor <> colbrDefault)  then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'SetBackgroundTintList', GetARGB(FCustomColor, FColor));
end;
procedure jsFloatingButton.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jsFloatingButton.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jsFloatingButton.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jsFloatingButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jsFloatingButton.jCreate(): jObject;
begin
   Result:= jsFloatingButton_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jsFloatingButton.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jsFloatingButton.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jsFloatingButton.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jsFloatingButton.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jsFloatingButton.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsFloatingButton.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jsFloatingButton.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jsFloatingButton.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;


procedure jsFloatingButton.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsFloatingButton.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsFloatingButton.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsFloatingButton.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsFloatingButton.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jsFloatingButton.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          View_addlParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         View_addlParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsFloatingButton.SetVisibility(_value: TViewVisibility);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'SetVisibility', Ord(_value));
end;

procedure jsFloatingButton.SetCompatElevation(_value: single);
begin
  //in designing component state: set value here...
  FElevation:= _value;
  if FjObject <> nil then
     jni_proc_f(gApp.jni.jEnv, FjObject, 'SetCompatElevation', _value);
end;

procedure jsFloatingButton.SetImageIdentifier(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  FImageIdentifier:= _imageIdentifier;
  if FInitialized then
     jni_proc_t(gApp.jni.jEnv, FjObject, 'SetImage', _imageIdentifier);
end;

procedure jsFloatingButton.BringToFront();
begin
  //in designing component state: set value here...
  if FInitialized then
     View_BringToFront(gApp.jni.jEnv, FjObject);
end;

procedure jsFloatingButton.SetSize(_value: TFABSize);
begin
  //in designing component state: set value here...
  FABSize:= _value;
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'SetSize', Ord(_value));
end;

procedure jsFloatingButton.SetPressedRippleColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'SetPressedRippleColor', GetARGB(FCustomColor, _color));
end;

procedure jsFloatingButton.SetContentDescription(_contentDescription: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(gApp.jni.jEnv, FjObject, 'SetContentDescription', _contentDescription);
end;

procedure jsFloatingButton.ShowSnackbar(_message: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(gApp.jni.jEnv, FjObject, 'ShowSnackbar', _message);
end;

procedure jsFloatingButton.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _value;
  if FInitialized then
     jni_proc_i(gApp.jni.jEnv, FjObject, 'SetLGravity', Ord(_value));
end;


procedure jsFloatingButton.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(gApp.jni.jEnv, FjObject, 'SetFitsSystemWindows', _value);
end;

procedure jsFloatingButton.SetAnchorGravity(_value: TLayoutGravity; _anchorId: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_ii(gApp.jni.jEnv, FjObject, 'SetAnchorGravity', ord(_value) ,_anchorId);
end;

procedure jsFloatingButton.SetBackgroundToPrimaryColor();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'SetBackgroundToPrimaryColor');
end;

{-------- jsFloatingButton_JNI_Bridge ----------}

function jsFloatingButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsFloatingButton_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


end.
