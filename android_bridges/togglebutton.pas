unit togglebutton;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

TOnLongClickToggleButton=procedure(Sender:TObject; isStateOn:boolean) of object;

{Draft Component code by "Lazarus Android Module Wizard" [1/7/2015 1:26:30]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

  jToggleButton = class(jVisualControl)
  private
    FTextOff: string;
    FTextOn: string;
    FToggleState: TToggleState;
    FOnToggle: TOnClickToggleButton;

    FEnabledLongClick: boolean;
    FOnLongClick: TOnLongClickToggleButton;

    procedure SetColor(Value: TARGBColorBridge); //background
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure GenEvent_OnClickToggleButton(Obj: TObject; state: boolean);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject);  override;
    procedure RemoveFromViewParent(); override;
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetChecked(_value: boolean);
    procedure DispatchOnToggleEvent(_value: boolean);
    procedure SetTextOn(_caption: string);
    procedure SetTextOff(_caption: string);
    procedure Toggle();
    procedure SetToggleState(_state: TToggleState);
    function IsChecked(): boolean;
    procedure SetBackgroundDrawable(_imageIdentifier: string);
    procedure SetLGravity(_value: TLayoutGravity);
    procedure SetEnabledLongClick(_enableLongClick: boolean);
    procedure GenEvent_OnLongClickToggleButton(Sender:TObject;state:boolean);

  published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property TextOff: string read FTextOff write SetTextOff;
    property TextOn: string read FTextOn write SetTextOn;
    property State: TToggleState read FToggleState write SetToggleState;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property EnabledLongClick: boolean read FEnabledLongClick write SetEnabledLongClick;
    property OnToggle: TOnClickToggleButton read FOnToggle write FOnToggle;
    property OnLongClick: TOnLongClickToggleButton read FOnLongClick write FOnLongClick;
  end;

function jToggleButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;


implementation

{---------  jToggleButton  --------------}

constructor jToggleButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 40; //??
  FWidth        := 75; //??
  FLParamWidth  := lpWrapContent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FTextOff:= 'OFF';
  FTextOn:= 'ON';
  FToggleState:= tsOff;
  FEnabledLongClick:= False;
end;

destructor jToggleButton.Destroy;
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

procedure jToggleButton.Init(refApp: jApp);
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

   if FGravityInParent <> lgNone then
     View_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent) );

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

   if FTextOff <> 'OFF' then
    SetTextOff(FTextOff);

   if FTextOn <> 'ON' then
    SetTextOn(FTextOn);

   if FToggleState <> tsOff then
     SetChecked(True);

   DispatchOnToggleEvent(True);

   if FEnabledLongClick then
      SetEnabledLongClick(True);

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jToggleButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jToggleButton.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jToggleButton.Refresh;
begin
  if FInitialized then
     View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jToggleButton.GenEvent_OnClickToggleButton(Obj: TObject; state: boolean);
begin

   //fixed! thanks to @Sait
  if state then
    FToggleState:= tsOn
  else
    FToggleState:= tsOff;

  if Assigned(FOnToggle) then FOnToggle(Obj, state);
end;

function jToggleButton.jCreate(): jObject;
begin
   Result:= jToggleButton_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jToggleButton.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'jFree');
end;

procedure jToggleButton.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jToggleButton.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     View_RemoveFromViewParent(FjEnv, FjObject);
end;

function jToggleButton.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetView(FjEnv, FjObject);
end;

procedure jToggleButton.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jToggleButton.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jToggleButton.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jToggleButton.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jToggleButton.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jToggleButton.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jToggleButton.ClearLayout();
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

procedure jToggleButton.SetChecked(_value: boolean);
begin
  //in designing component state: set value here...
  if _value = True then
   FToggleState := tsOn
  else
   FToggleState := tsOff;

  if FjObject = nil then exit;

  jni_proc_z(FjEnv, FjObject, 'SetChecked', _value);
end;

procedure jToggleButton.DispatchOnToggleEvent(_value: boolean);
begin
  if FjObject = nil then exit;

  jni_proc_z(FjEnv, FjObject, 'DispatchOnToggleEvent', _value);
end;

procedure jToggleButton.SetTextOn(_caption: string);
begin
  //in designing component state: set value here...
  FTextOn:= _caption;
  if FjObject = nil then exit;

  jni_proc_t(FjEnv, FjObject, 'SetTextOn', _caption);
end;

procedure jToggleButton.SetTextOff(_caption: string);
begin
  //in designing component state: set value here...
  FTextOff:= _caption;
  if FjObject = nil then exit;

  jni_proc_t(FjEnv, FjObject, 'SetTextOff', _caption);
end;

procedure jToggleButton.Toggle();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(FjEnv, FjObject, 'Toggle');
end;

procedure jToggleButton.SetToggleState(_state: TToggleState);
begin
  //in designing component state: set value here...
  FToggleState:= _state;
  if FInitialized then
  begin
    if _state = tsOff then
      SetChecked(False)
    else
      SetChecked(True);
  end;
end;

function jToggleButton.IsChecked(): boolean;
begin
  Result := false;
  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(FjEnv, FjObject, 'IsChecked');
end;

procedure jToggleButton.SetBackgroundDrawable(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(FjEnv, FjObject, 'SetBackgroundDrawable', _imageIdentifier);
end;

procedure jToggleButton.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _value;
  if FInitialized then
     View_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent));
end;

procedure jToggleButton.SetEnabledLongClick(_enableLongClick: boolean);
begin
  //in designing component state: set value here...
  FEnabledLongClick:= _enableLongClick;
  if FjObject = nil then exit;

  jni_proc_z(FjEnv, FjObject, 'SetEnabledLongClick', _enableLongClick);
end;

procedure jToggleButton.GenEvent_OnLongClickToggleButton(Sender:TObject;state:boolean);
begin

  if state then
    FToggleState:= tsOn
  else
    FToggleState:= tsOff;

  if Assigned(FOnLongClick) then FOnLongClick(Sender,state);
end;

{-------- jToggleButton_JNI_Bridge ----------}

function jToggleButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jToggleButton_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jToggleButton_jCreate(long _Self) {
      return (java.lang.Object)(new jToggleButton(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)

end.
