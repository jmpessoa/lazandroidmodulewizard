unit togglebutton;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

{Draft Component code by "Lazarus Android Module Wizard" [1/7/2015 1:26:30]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

  jToggleButton = class(jVisualControl)
  private
    FTextOff: string;
    FTextOn: string;
    FToggleState: TToggleState;
    FOnToggle: TOnClickToggleButton;
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
    procedure SetId(_id: integer);
    procedure SetChecked(_value: boolean);
    procedure DispatchOnToggleEvent(_value: boolean);
    procedure SetTextOn(_caption: string);
    procedure SetTextOff(_caption: string);
    procedure Toggle();
    procedure SetToggleState(_state: TToggleState);
    function IsChecked(): boolean;
    procedure SetBackgroundDrawable(_imageIdentifier: string);
    procedure SetLGravity(_value: TLayoutGravity);

  published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property TextOff: string read FTextOff write SetTextOff;
    property TextOn: string read FTextOn write SetTextOn;
    property State: TToggleState read FToggleState write SetToggleState;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property OnToggle: TOnClickToggleButton read FOnToggle write FOnToggle;
  end;

function jToggleButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jToggleButton_jFree(env: PJNIEnv; _jtogglebutton: JObject);
procedure jToggleButton_SetViewParent(env: PJNIEnv; _jtogglebutton: JObject; _viewgroup: jObject);
procedure jToggleButton_RemoveFromViewParent(env: PJNIEnv; _jtogglebutton: JObject);
function jToggleButton_GetView(env: PJNIEnv; _jtogglebutton: JObject): jObject;
procedure jToggleButton_SetLParamWidth(env: PJNIEnv; _jtogglebutton: JObject; _w: integer);
procedure jToggleButton_SetLParamHeight(env: PJNIEnv; _jtogglebutton: JObject; _h: integer);
procedure jToggleButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jtogglebutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jToggleButton_AddLParamsAnchorRule(env: PJNIEnv; _jtogglebutton: JObject; _rule: integer);
procedure jToggleButton_AddLParamsParentRule(env: PJNIEnv; _jtogglebutton: JObject; _rule: integer);
procedure jToggleButton_SetLayoutAll(env: PJNIEnv; _jtogglebutton: JObject; _idAnchor: integer);
procedure jToggleButton_ClearLayoutAll(env: PJNIEnv; _jtogglebutton: JObject);
procedure jToggleButton_SetId(env: PJNIEnv; _jtogglebutton: JObject; _id: integer);
procedure jToggleButton_SetChecked(env: PJNIEnv; _jtogglebutton: JObject; _value: boolean);
procedure jToggleButton_DispatchOnToggleEvent(env: PJNIEnv; _jtogglebutton: JObject; _value: boolean);
procedure jToggleButton_SetTextOn(env: PJNIEnv; _jtogglebutton: JObject; _caption: string);
procedure jToggleButton_SetTextOff(env: PJNIEnv; _jtogglebutton: JObject; _caption: string);
procedure jToggleButton_Toggle(env: PJNIEnv; _jtogglebutton: JObject);
function jToggleButton_IsChecked(env: PJNIEnv; _jtogglebutton: JObject): boolean;
procedure jToggleButton_SetBackgroundDrawable(env: PJNIEnv; _jtogglebutton: JObject; _imageIdentifier: string);
procedure jToggleButton_SetFrameGravity(env: PJNIEnv; _jtogglebutton: JObject; _value: integer);


implementation

{---------  jToggleButton  --------------}

constructor jToggleButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
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
   FjObject:= jCreate(); //jSelf !

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   if FGravityInParent <> lgNone then
     jToggleButton_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent) );

   jToggleButton_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jToggleButton_SetId(FjEnv, FjObject, Self.Id);
  end;

  jToggleButton_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jToggleButton_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jToggleButton_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jToggleButton_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FTextOff <> 'OFF' then
    jToggleButton_SetTextOff(FjEnv, FjObject, FTextOff);

   if FTextOn <> 'ON' then
    jToggleButton_SetTextOn(FjEnv, FjObject, FTextOn);

   if FToggleState <> tsOff then
     jToggleButton_SetChecked(FjEnv, FjObject, True);

   jToggleButton_DispatchOnToggleEvent(FjEnv, FjObject, True);

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
     jToggleButton_jFree(FjEnv, FjObject);
end;

procedure jToggleButton.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jToggleButton.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_RemoveFromViewParent(FjEnv, FjObject);
end;

function jToggleButton.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jToggleButton_GetView(FjEnv, FjObject);
end;

procedure jToggleButton.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jToggleButton.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jToggleButton.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jToggleButton.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jToggleButton.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jToggleButton.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jToggleButton.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jToggleButton_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jToggleButton_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jToggleButton_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jToggleButton.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_SetId(FjEnv, FjObject, _id);
end;

procedure jToggleButton.SetChecked(_value: boolean);
begin
  //in designing component state: set value here...
  if _value = True then FToggleState:= tsOn
  else FToggleState:= tsOff;

  if FInitialized then
     jToggleButton_SetChecked(FjEnv, FjObject, _value);
end;

procedure jToggleButton.DispatchOnToggleEvent(_value: boolean);
begin
  if FInitialized then
     jToggleButton_DispatchOnToggleEvent(FjEnv, FjObject, _value);
end;

procedure jToggleButton.SetTextOn(_caption: string);
begin
  //in designing component state: set value here...
  FTextOn:= _caption;
  if FInitialized then
     jToggleButton_SetTextOn(FjEnv, FjObject, _caption);
end;

procedure jToggleButton.SetTextOff(_caption: string);
begin
  //in designing component state: set value here...
  FTextOff:= _caption;
  if FInitialized then
     jToggleButton_SetTextOff(FjEnv, FjObject, _caption);
end;

procedure jToggleButton.Toggle();
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_Toggle(FjEnv, FjObject);
end;

procedure jToggleButton.SetToggleState(_state: TToggleState);
begin
  //in designing component state: set value here...
  FToggleState:= _state;
  if FInitialized then
  begin
    if _state = tsOff then
      jToggleButton_SetChecked(FjEnv, FjObject, False)
    else
      jToggleButton_SetChecked(FjEnv, FjObject, True);
  end;
end;

function jToggleButton.IsChecked(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jToggleButton_IsChecked(FjEnv, FjObject);
end;

procedure jToggleButton.SetBackgroundDrawable(_imageIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jToggleButton_SetBackgroundDrawable(FjEnv, FjObject, _imageIdentifier);
end;

procedure jToggleButton.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _value;
  if FInitialized then
     jToggleButton_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent));
end;


{-------- jToggleButton_JNI_Bridge ----------}

function jToggleButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
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


procedure jToggleButton_jFree(env: PJNIEnv; _jtogglebutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jtogglebutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_SetViewParent(env: PJNIEnv; _jtogglebutton: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_RemoveFromViewParent(env: PJNIEnv; _jtogglebutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jtogglebutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jToggleButton_GetView(env: PJNIEnv; _jtogglebutton: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jtogglebutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_SetLParamWidth(env: PJNIEnv; _jtogglebutton: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_SetLParamHeight(env: PJNIEnv; _jtogglebutton: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jtogglebutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_AddLParamsAnchorRule(env: PJNIEnv; _jtogglebutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_AddLParamsParentRule(env: PJNIEnv; _jtogglebutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_SetLayoutAll(env: PJNIEnv; _jtogglebutton: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_ClearLayoutAll(env: PJNIEnv; _jtogglebutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jtogglebutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_SetId(env: PJNIEnv; _jtogglebutton: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_SetChecked(env: PJNIEnv; _jtogglebutton: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetChecked', '(Z)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToggleButton_DispatchOnToggleEvent(env: PJNIEnv; _jtogglebutton: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'DispatchOnToggleEvent', '(Z)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToggleButton_SetTextOn(env: PJNIEnv; _jtogglebutton: JObject; _caption: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_caption));
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextOn', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_SetTextOff(env: PJNIEnv; _jtogglebutton: JObject; _caption: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_caption));
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextOff', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_Toggle(env: PJNIEnv; _jtogglebutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'Toggle', '()V');
  env^.CallVoidMethod(env, _jtogglebutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jToggleButton_IsChecked(env: PJNIEnv; _jtogglebutton: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'IsChecked', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jtogglebutton, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jToggleButton_SetBackgroundDrawable(env: PJNIEnv; _jtogglebutton: JObject; _imageIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundDrawable', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jToggleButton_SetFrameGravity(env: PJNIEnv; _jtogglebutton: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jtogglebutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jtogglebutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
