unit switchbutton;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type


{Draft Component code by "Lazarus Android Module Wizard" [1/8/2015 23:17:31]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

  jSwitchButton = class(jVisualControl)
  private
    FTextOff: string;
    FTextOn: string;
    FSwitchState: TToggleState;
    FOnToggle: TOnClickToggleButton;
    //FShowText: boolean;     //Api 21

    procedure SetColor(Value: TARGBColorBridge); //background
    
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnChangeSwitchButton(Obj: TObject; state: boolean);

    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent();  override;
    function GetView(): jObject; override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetTextOff(_caption: string);
    procedure SetTextOn(_caption: string);
    procedure SetChecked(_state: boolean);
    procedure DispatchOnToggleEvent(_value: boolean);
    procedure Toggle();
    procedure SetThumbIcon(_thumbIconIdentifier: string);
    //procedure SetShowText(_state: boolean);   //Api 21
    procedure SetSwitchState(_state: TToggleState);
    function IsChecked(): boolean;
    procedure SetLGravity(_value: TLayoutGravity);

  published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property TextOff: string read FTextOff write SetTextOff;
    property TextOn: string read FTextOn write SetTextOn;
    property State: TToggleState read FSwitchState write SetSwitchState;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property OnToggle: TOnClickToggleButton read FOnToggle write FOnToggle;
  end;

function jSwitchButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;


implementation

{---------  jSwitchButton  --------------}

constructor jSwitchButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 7;
  FMarginTop    := 7;
  FMarginBottom := 7;
  FMarginRight  := 7;
  FHeight       := 30; //??
  FWidth        := 75; //??
  FLParamWidth  := lpWrapContent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FTextOff:= 'OFF';
  FTextOn:= 'ON';
  FSwitchState:= tsOff;
end;

destructor jSwitchButton.Destroy;
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

procedure jSwitchButton.Init;
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
    View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));

   View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_setLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
    if rToA in FPositionRelativeToAnchor then
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));


  for rToP := rpBottom to rpCenterVertical do
   if rToP in FPositionRelativeToParent then
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));


  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FTextOff <> 'OFF' then
    SetTextOff(FTextOff);

   if FTextOn <> 'ON' then
    SetTextOn(FTextOn);

   if FSwitchState <> tsOff then
     SetChecked(True);

   DispatchOnToggleEvent(True);

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jSwitchButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jSwitchButton.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jSwitchButton.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jSwitchButton.GenEvent_OnChangeSwitchButton(Obj: TObject; state: boolean);
begin

  //fixed! thanks to @Sait
  if state then
    FSwitchState:= tsOn
  else
    FSwitchState:= tsOff;

  if Assigned(FOnToggle) then FOnToggle(Obj, state);
end;

function jSwitchButton.jCreate(): jObject;
begin
   Result:= jSwitchButton_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jSwitchButton.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'jFree');
end;

procedure jSwitchButton.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

procedure jSwitchButton.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jSwitchButton.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jSwitchButton.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jSwitchButton.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

procedure jSwitchButton.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jSwitchButton.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jSwitchButton.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jSwitchButton.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jSwitchButton.ClearLayout();
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
          View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jSwitchButton.SetTextOff(_caption: string);
begin
  //in designing component state: set value here...
  FTextOff:= _caption;
  if FjObject = nil then exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'SetTextOff', _caption);
end;

procedure jSwitchButton.SetTextOn(_caption: string);
begin
  //in designing component state: set value here...
  FTextOn:= _caption;
  if FjObject = nil then exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'SetTextOn', _caption);
end;

procedure jSwitchButton.SetChecked(_state: boolean);
begin
  //in designing component state: set value here...
  if _state = True then
   FSwitchState:= tsOn
  else
   FSwitchState:= tsOff;

  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'SetChecked', _state);
end;

procedure jSwitchButton.DispatchOnToggleEvent(_value: boolean);
begin
  if FjObject = nil then exit;

  jni_proc_z(gApp.jni.jEnv, FjObject, 'DispatchOnToggleEvent', _value);
end;

procedure jSwitchButton.Toggle();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'Toggle');
end;

procedure jSwitchButton.SetSwitchState(_state: TToggleState);
begin
  //in designing component state: set value here...
  FSwitchState:= _state;
  if FInitialized then
  begin
    if _state = tsOff then
      SetChecked(False)
    else
      SetChecked(True);
  end;
end;

procedure jSwitchButton.SetThumbIcon(_thumbIconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_t(gApp.jni.jEnv, FjObject, 'SetThumbIcon', _thumbIconIdentifier);
end;

(*  Api 21
procedure jSwitchButton.SetShowText(_state: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_SetShowText(gApp.jni.jEnv, FjObject, _state);
end;
*)

function jSwitchButton.IsChecked(): boolean;
begin
  Result := false;

  //in designing component state: result value here...
  if FInitialized then
   Result:= jni_func_out_z(gApp.jni.jEnv, FjObject, 'IsChecked');
end;

procedure jSwitchButton.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _value;
  if FInitialized then
     View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));
end;


{-------- jSwitchButton_JNI_Bridge ----------}

function jSwitchButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSwitchButton_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jSwitchButton_jCreate(long _Self) {
      return (java.lang.Object)(new jSwitchButton(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


end.
