unit myguicontrol;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;

type

jMyGuiControl = class(jVisualControl)
 private
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge);

 protected
    procedure GenEvent_OnClick(Obj: TObject);

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure SetParamHeight(Value: TLayoutParams);
    procedure SetParamWidth(Value: TLayoutParams);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetParent(viewgroup: jObject);
    procedure SetLParamWidth(w: integer);
    procedure SetLParamHeight(h: integer);
    procedure SetLeftTopRightBottomWidthHeight(left: integer; top: integer; right: integer; bottom: integer; w: integer; h: integer);
    procedure AddLParamsAnchorRule(rule: integer);
    procedure AddLParamsParentRule(rule: integer);
    procedure SetLayoutAll(idAnchor: integer);
    procedure SetId(id: integer);

 published
    property Visible: boolean read FVisible write SetVisible;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jMyGuiControl_jCreate(env: PJNIEnv; this: JObject;Self: int64): jObject;
procedure jMyGuiControl_jFree(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject);
procedure jMyGuiControl_SetParent(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; viewgroup: jObject);
procedure jMyGuiControl_SetLParamWidth(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; w: integer);
procedure jMyGuiControl_SetLParamHeight(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; h: integer);
procedure jMyGuiControl_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; left: integer; top: integer; right: integer; bottom: integer; w: integer; h: integer);
procedure jMyGuiControl_AddLParamsAnchorRule(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; rule: integer);
procedure jMyGuiControl_AddLParamsParentRule(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; rule: integer);
procedure jMyGuiControl_SetLayoutAll(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; idAnchor: integer);
procedure jMyGuiControl_SetId(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; id: integer);

implementation

{---------  jMyGuiControl  --------------}

constructor jMyGuiControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight  := lpWrapContent; //lpMatchParent
  //your code here....
end;

destructor jMyGuiControl.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if jForm(Owner).App <> nil then
    begin
      if jForm(Owner).App.Initialized then
      begin
        if FjObject <> nil then
        begin
           jFree();
           FjObject:= nil;
        end;
      end;
    end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jMyGuiControl.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init;
  FjObject:= jCreate();
  FInitialized:= True;
  if FParentPanel <> nil then
  begin
    FParentPanel.Init;
    FjPRLayout:= FParentPanel.View;
  end;
  jMyGuiControl_setParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FjPRLayout);
  jMyGuiControl_setId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.Id);
  jMyGuiControl_setLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        GetLayoutParams(gApp, FLParamWidth, sdW),
                        GetLayoutParams(gApp, FLParamHeight, sdH));
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jMyGuiControl_addlParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jMyGuiControl_addlParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;
  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1;
  jMyGuiControl_setLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
  if  FColor <> colbrDefault then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
  //your code here
end;

procedure jMyGuiControl.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    jView_SetBackGroundColor(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetARGB(FColor));
end;
procedure jMyGuiControl.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
  jView_SetVisible(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, FVisible);
end;
procedure jMyGuiControl.SetParamWidth(Value: TLayoutParams);
var
  side: TSide;
begin
  if jForm(Owner).Orientation = jForm(Owner).App.Orientation then
    side:= sdW
  else
    side:= sdH;
  jMyGuiControl_SetLParamWidth(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
end;

procedure jMyGuiControl.SetParamHeight(Value: TLayoutParams);
var
  side: TSide;
begin
  if jForm(Owner).Orientation = gApp.Orientation then
    side:= sdH
  else
    side:= sdW;
  jMyGuiControl_SetLParamHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
end;

procedure jMyGuiControl.UpdateLayout;
begin
  inherited UpdateLayout;
  SetParamWidth(FLParamWidth);
  SetParamHeight(FLParamHeight);
  jMyGuiControl_SetLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, Self.AnchorId);
end;

procedure jMyGuiControl.Refresh;
begin
  if FInitialized then
    jView_Invalidate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

//Event : Java -> Pascal
procedure jMyGuiControl.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jMyGuiControl.jCreate(): jObject;
begin
   Result:= jMyGuiControl_jCreate(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis , int64(Self));
end;

procedure jMyGuiControl.jFree();
begin
  if FInitialized then
     jMyGuiControl_jFree(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject);
end;

procedure jMyGuiControl.SetParent(viewgroup: jObject);
begin
  if FInitialized then
     jMyGuiControl_SetParent(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, viewgroup);
end;

procedure jMyGuiControl.SetLParamWidth(w: integer);
begin
  if FInitialized then
     jMyGuiControl_SetLParamWidth(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, w);
end;

procedure jMyGuiControl.SetLParamHeight(h: integer);
begin
  if FInitialized then
     jMyGuiControl_SetLParamHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, h);
end;

procedure jMyGuiControl.SetLeftTopRightBottomWidthHeight(left: integer; top: integer; right: integer; bottom: integer; w: integer; h: integer);
begin
  if FInitialized then
     jMyGuiControl_SetLeftTopRightBottomWidthHeight(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, left ,top ,right ,bottom ,w ,h);
end;

procedure jMyGuiControl.AddLParamsAnchorRule(rule: integer);
begin
  if FInitialized then
     jMyGuiControl_AddLParamsAnchorRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, rule);
end;

procedure jMyGuiControl.AddLParamsParentRule(rule: integer);
begin
  if FInitialized then
     jMyGuiControl_AddLParamsParentRule(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, rule);
end;

procedure jMyGuiControl.SetLayoutAll(idAnchor: integer);
begin
  if FInitialized then
     jMyGuiControl_SetLayoutAll(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, idAnchor);
end;

procedure jMyGuiControl.SetId(id: integer);
begin
  if FInitialized then
     jMyGuiControl_SetId(jForm(Owner).App.Jni.jEnv, jForm(Owner).App.Jni.jThis, FjObject, id);
end;

{-------- jMyGuiControl_JNI_Bridge ----------}

function jMyGuiControl_jCreate(env: PJNIEnv; this: JObject;Self: int64): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMyGuiControl_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jMyGuiControl_jFree(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmyguicontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmyguicontrol, jMethod);
end;


procedure jMyGuiControl_SetParent(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= viewgroup;
  jCls:= env^.GetObjectClass(env, _jmyguicontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'SetParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jmyguicontrol, jMethod, @jParams);
end;


procedure jMyGuiControl_SetLParamWidth(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= w;
  jCls:= env^.GetObjectClass(env, _jmyguicontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jmyguicontrol, jMethod, @jParams);
end;


procedure jMyGuiControl_SetLParamHeight(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= h;
  jCls:= env^.GetObjectClass(env, _jmyguicontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jmyguicontrol, jMethod, @jParams);
end;


procedure jMyGuiControl_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; left: integer; top: integer; right: integer; bottom: integer; w: integer; h: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= left;
  jParams[1].i:= top;
  jParams[2].i:= right;
  jParams[3].i:= bottom;
  jParams[4].i:= w;
  jParams[5].i:= h;
  jCls:= env^.GetObjectClass(env, _jmyguicontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jmyguicontrol, jMethod, @jParams);
end;


procedure jMyGuiControl_AddLParamsAnchorRule(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= rule;
  jCls:= env^.GetObjectClass(env, _jmyguicontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jmyguicontrol, jMethod, @jParams);
end;


procedure jMyGuiControl_AddLParamsParentRule(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= rule;
  jCls:= env^.GetObjectClass(env, _jmyguicontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jmyguicontrol, jMethod, @jParams);
end;


procedure jMyGuiControl_SetLayoutAll(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= idAnchor;
  jCls:= env^.GetObjectClass(env, _jmyguicontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jmyguicontrol, jMethod, @jParams);
end;


procedure jMyGuiControl_SetId(env: PJNIEnv; this: JObject; _jmyguicontrol: JObject; id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= id;
  jCls:= env^.GetObjectClass(env, _jmyguicontrol);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jmyguicontrol, jMethod, @jParams);
end;



end.
