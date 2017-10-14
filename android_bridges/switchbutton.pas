unit switchbutton;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

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
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

    procedure GenEvent_OnChangeSwitchButton(Obj: TObject; state: boolean);

    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent();
    function GetView(): jObject; override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);
    procedure SetTextOff(_caption: string);
    procedure SetTextOn(_caption: string);
    procedure SetChecked(_state: boolean);
    procedure DispatchOnToggleEvent(_value: boolean);
    procedure Toggle();
    procedure SetThumbIcon(_thumbIconIdentifier: string);
    //procedure SetShowText(_state: boolean);   //Api 21
    procedure SetSwitchState(_state: TToggleState);
    function IsChecked(): boolean;

  published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property TextOff: string read FTextOff write SetTextOff;
    property TextOn: string read FTextOn write SetTextOn;
    property State: TToggleState read FSwitchState write SetSwitchState;
    property OnToggle: TOnClickToggleButton read FOnToggle write FOnToggle;
  end;

function jSwitchButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jSwitchButton_jFree(env: PJNIEnv; _jswitchbutton: JObject);
procedure jSwitchButton_SetViewParent(env: PJNIEnv; _jswitchbutton: JObject; _viewgroup: jObject);
procedure jSwitchButton_RemoveFromViewParent(env: PJNIEnv; _jswitchbutton: JObject);
function jSwitchButton_GetView(env: PJNIEnv; _jswitchbutton: JObject): jObject;
procedure jSwitchButton_SetLParamWidth(env: PJNIEnv; _jswitchbutton: JObject; _w: integer);
procedure jSwitchButton_SetLParamHeight(env: PJNIEnv; _jswitchbutton: JObject; _h: integer);
procedure jSwitchButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jswitchbutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jSwitchButton_AddLParamsAnchorRule(env: PJNIEnv; _jswitchbutton: JObject; _rule: integer);
procedure jSwitchButton_AddLParamsParentRule(env: PJNIEnv; _jswitchbutton: JObject; _rule: integer);
procedure jSwitchButton_SetLayoutAll(env: PJNIEnv; _jswitchbutton: JObject; _idAnchor: integer);
procedure jSwitchButton_ClearLayoutAll(env: PJNIEnv; _jswitchbutton: JObject);
procedure jSwitchButton_SetId(env: PJNIEnv; _jswitchbutton: JObject; _id: integer);
procedure jSwitchButton_SetTextOff(env: PJNIEnv; _jswitchbutton: JObject; _caption: string);
procedure jSwitchButton_SetTextOn(env: PJNIEnv; _jswitchbutton: JObject; _caption: string);
procedure jSwitchButton_SetChecked(env: PJNIEnv; _jswitchbutton: JObject; _state: boolean);
procedure jSwitchButton_DispatchOnToggleEvent(env: PJNIEnv; _jswitchbutton: JObject; _value: boolean);
procedure jSwitchButton_Toggle(env: PJNIEnv; _jswitchbutton: JObject);
procedure jSwitchButton_SetThumbIcon(env: PJNIEnv; _jswitchbutton: JObject; _thumbIconIdentifier: string);
procedure jSwitchButton_SetShowText(env: PJNIEnv; _jswitchbutton: JObject; _state: boolean);
function jSwitchButton_IsChecked(env: PJNIEnv; _jswitchbutton: JObject): boolean;


implementation

uses
   customdialog, toolbar;

{---------  jSwitchButton  --------------}

constructor jSwitchButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
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

procedure jSwitchButton.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
  if FParent <> nil then
  begin
    if FParent is jPanel then
    begin
      jPanel(FParent).Init(refApp);
      FjPRLayout:= jPanel(FParent).View;
    end;
    if FParent is jScrollView then
    begin
      jScrollView(FParent).Init(refApp);
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);//FjPRLayout:= jScrollView(FParent).View;
    end;
    if FParent is jHorizontalScrollView then
    begin
      jHorizontalScrollView(FParent).Init(refApp);
      FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
    end;
    if FParent is jCustomDialog then
    begin
      jCustomDialog(FParent).Init(refApp);
      FjPRLayout:= jCustomDialog(FParent).View;
    end;
    if FParent is jToolbar then
    begin
      jToolbar(FParent).Init(refApp);
      FjPRLayout:= jToolbar(FParent).View;
    end;
  end;
  jSwitchButton_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jSwitchButton_SetId(FjEnv, FjObject, Self.Id);
  jSwitchButton_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        GetLayoutParams(gApp, FLParamWidth, sdW),
                        GetLayoutParams(gApp, FLParamHeight, sdH));

  if FParent is jPanel then
  begin
    Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jSwitchButton_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jSwitchButton_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy
  jSwitchButton_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FTextOff <> 'OFF' then
    jSwitchButton_SetTextOff(FjEnv, FjObject, FTextOff);

  if FTextOn <> 'ON' then
    jSwitchButton_SetTextOn(FjEnv, FjObject, FTextOn);

  if FSwitchState <> tsOff then
     jSwitchButton_SetChecked(FjEnv, FjObject, True);

  jSwitchButton_DispatchOnToggleEvent(FjEnv, FjObject, True);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jSwitchButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jSwitchButton.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jSwitchButton_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
          jSwitchButton_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
       else //lpMatchParent or others
          jSwitchButton_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jSwitchButton.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jSwitchButton_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
         jSwitchButton_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
         jSwitchButton_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jSwitchButton.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jSwitchButton_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jSwitchButton.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jSwitchButton.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jSwitchButton_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jSwitchButton_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jSwitchButton_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
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
   Result:= jSwitchButton_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jSwitchButton.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_jFree(FjEnv, FjObject);
end;

procedure jSwitchButton.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jSwitchButton.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_RemoveFromViewParent(FjEnv, FjObject);
end;

function jSwitchButton.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSwitchButton_GetView(FjEnv, FjObject);
end;

procedure jSwitchButton.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jSwitchButton.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jSwitchButton.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jSwitchButton.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jSwitchButton.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jSwitchButton.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jSwitchButton.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jSwitchButton.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_SetId(FjEnv, FjObject, _id);
end;

procedure jSwitchButton.SetTextOff(_caption: string);
begin
  //in designing component state: set value here...
    FTextOff:= _caption;
  if FInitialized then
     jSwitchButton_SetTextOff(FjEnv, FjObject, _caption);
end;

procedure jSwitchButton.SetTextOn(_caption: string);
begin
  //in designing component state: set value here...
  FTextOn:= _caption;
  if FInitialized then
     jSwitchButton_SetTextOn(FjEnv, FjObject, _caption);
end;

procedure jSwitchButton.SetChecked(_state: boolean);
begin
  //in designing component state: set value here...
  if _state = True then FSwitchState:= tsOn
  else FSwitchState:= tsOff;

  if FInitialized then
     jSwitchButton_SetChecked(FjEnv, FjObject, _state);
end;

procedure jSwitchButton.DispatchOnToggleEvent(_value: boolean);
begin
  if FInitialized then
     jSwitchButton_DispatchOnToggleEvent(FjEnv, FjObject, _value);
end;

procedure jSwitchButton.Toggle();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_Toggle(FjEnv, FjObject);
end;

procedure jSwitchButton.SetSwitchState(_state: TToggleState);
begin
  //in designing component state: set value here...
  FSwitchState:= _state;
  if FInitialized then
  begin
    if _state = tsOff then
      jSwitchButton_SetChecked(FjEnv, FjObject, False)
    else
      jSwitchButton_SetChecked(FjEnv, FjObject, True);
  end;
end;

procedure jSwitchButton.SetThumbIcon(_thumbIconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_SetThumbIcon(FjEnv, FjObject, _thumbIconIdentifier);
end;

(*  Api 21
procedure jSwitchButton.SetShowText(_state: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSwitchButton_SetShowText(FjEnv, FjObject, _state);
end;
*)

function jSwitchButton.IsChecked(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSwitchButton_IsChecked(FjEnv, FjObject);
end;


{-------- jSwitchButton_JNI_Bridge ----------}

function jSwitchButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
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


procedure jSwitchButton_jFree(env: PJNIEnv; _jswitchbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jswitchbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetViewParent(env: PJNIEnv; _jswitchbutton: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_RemoveFromViewParent(env: PJNIEnv; _jswitchbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jswitchbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSwitchButton_GetView(env: PJNIEnv; _jswitchbutton: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jswitchbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetLParamWidth(env: PJNIEnv; _jswitchbutton: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetLParamHeight(env: PJNIEnv; _jswitchbutton: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jswitchbutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_AddLParamsAnchorRule(env: PJNIEnv; _jswitchbutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_AddLParamsParentRule(env: PJNIEnv; _jswitchbutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetLayoutAll(env: PJNIEnv; _jswitchbutton: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_ClearLayoutAll(env: PJNIEnv; _jswitchbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jswitchbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetId(env: PJNIEnv; _jswitchbutton: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetTextOff(env: PJNIEnv; _jswitchbutton: JObject; _caption: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_caption));
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextOff', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetTextOn(env: PJNIEnv; _jswitchbutton: JObject; _caption: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_caption));
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextOn', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetChecked(env: PJNIEnv; _jswitchbutton: JObject; _state: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_state);
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetChecked', '(Z)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSwitchButton_DispatchOnToggleEvent(env: PJNIEnv; _jswitchbutton: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'DispatchOnToggleEvent', '(Z)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSwitchButton_Toggle(env: PJNIEnv; _jswitchbutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'Toggle', '()V');
  env^.CallVoidMethod(env, _jswitchbutton, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetThumbIcon(env: PJNIEnv; _jswitchbutton: JObject; _thumbIconIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_thumbIconIdentifier));
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetThumbIcon', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSwitchButton_SetShowText(env: PJNIEnv; _jswitchbutton: JObject; _state: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_state);
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'SetShowText', '(Z)V');
  env^.CallVoidMethodA(env, _jswitchbutton, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jSwitchButton_IsChecked(env: PJNIEnv; _jswitchbutton: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jswitchbutton);
  jMethod:= env^.GetMethodID(env, jCls, 'IsChecked', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jswitchbutton, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

end.
