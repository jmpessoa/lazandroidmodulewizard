unit chronometer;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TOnChronometerTick = procedure(Sender: TObject; elapsedTimeMillis: int64) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [6/18/2016 19:17:11]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jChronometer = class(jVisualControl)
 private

    FOnChronometerTick: TOnChronometerTick;
    procedure SetVisible(Value: Boolean);
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

    procedure GenEvent_OnClick(Obj: TObject);
    procedure GenEvent_OnChronometerTick(Obj: TObject; elapsedTimeMillis: int64);

    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject);  override;
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
    procedure SetBaseElapsedRealtime();  overload;
    procedure SetBaseElapsedRealtime(_elapsedMillis: int64); overload;
    function GetElapsedTimeMillis(): int64;
    function Start(): int64;
    function Stop(): int64;
    function Reset(): int64;
    procedure SetThresholdTick(_thresholdTickMillis: integer);
    function GetSystemElapsedRealtime(): int64;

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;

    //property FontSize: DWord  read FFontSize write SetFontSize;
    //property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    //property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;

    property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnChronometerTick: TOnChronometerTick read FOnChronometerTick write FOnChronometerTick;

end;

function jChronometer_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jChronometer_jFree(env: PJNIEnv; _jchronometer: JObject);
procedure jChronometer_SetViewParent(env: PJNIEnv; _jchronometer: JObject; _viewgroup: jObject);
procedure jChronometer_RemoveFromViewParent(env: PJNIEnv; _jchronometer: JObject);
function jChronometer_GetView(env: PJNIEnv; _jchronometer: JObject): jObject;
procedure jChronometer_SetLParamWidth(env: PJNIEnv; _jchronometer: JObject; _w: integer);
procedure jChronometer_SetLParamHeight(env: PJNIEnv; _jchronometer: JObject; _h: integer);
procedure jChronometer_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jchronometer: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jChronometer_AddLParamsAnchorRule(env: PJNIEnv; _jchronometer: JObject; _rule: integer);
procedure jChronometer_AddLParamsParentRule(env: PJNIEnv; _jchronometer: JObject; _rule: integer);
procedure jChronometer_SetLayoutAll(env: PJNIEnv; _jchronometer: JObject; _idAnchor: integer);
procedure jChronometer_ClearLayoutAll(env: PJNIEnv; _jchronometer: JObject);
procedure jChronometer_SetId(env: PJNIEnv; _jchronometer: JObject; _id: integer);
procedure jChronometer_SetBaseElapsedRealtime(env: PJNIEnv; _jchronometer: JObject); overload;
procedure jChronometer_SetBaseElapsedRealtime(env: PJNIEnv; _jchronometer: JObject; _elapsedMillis: int64);overload;
function jChronometer_GetElapsedTimeMillis(env: PJNIEnv; _jchronometer: JObject): int64;
function jChronometer_Start(env: PJNIEnv; _jchronometer: JObject): int64;
function jChronometer_Stop(env: PJNIEnv; _jchronometer: JObject): int64;
function jChronometer_Reset(env: PJNIEnv; _jchronometer: JObject): int64;
procedure jChronometer_SetThresholdTick(env: PJNIEnv; _jchronometer: JObject; _thresholdTickMillis: integer);
function jChronometer_GetSystemElapsedRealtime(env: PJNIEnv; _jchronometer: JObject): int64;



implementation

uses
   customdialog, toolbar;

{---------  jChronometer  --------------}

constructor jChronometer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 48; //??
  FWidth        := 96; //??
  FLParamWidth  := lpWrapContent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor jChronometer.Destroy;
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

procedure jChronometer.Init(refApp: jApp);
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
      FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
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
  jChronometer_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jChronometer_SetId(FjEnv, FjObject, Self.Id);
  jChronometer_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jChronometer_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jChronometer_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jChronometer_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jChronometer.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jChronometer.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jChronometer.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jChronometer_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jChronometer_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jChronometer_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jChronometer.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jChronometer_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jChronometer_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jChronometer_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jChronometer.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jChronometer_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jChronometer.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jChronometer.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jChronometer_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jChronometer_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jChronometer_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jChronometer.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jChronometer.GenEvent_OnChronometerTick(Obj: TObject; elapsedTimeMillis: int64);
begin
  if Assigned(FOnChronometerTick) then FOnChronometerTick(Obj, elapsedTimeMillis);
end;

function jChronometer.jCreate(): jObject;
begin
  Result:= jChronometer_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jChronometer.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_jFree(FjEnv, FjObject);
end;

procedure jChronometer.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jChronometer.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_RemoveFromViewParent(FjEnv, FjObject);
end;

function jChronometer.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jChronometer_GetView(FjEnv, FjObject);
end;

procedure jChronometer.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jChronometer.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jChronometer.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jChronometer.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jChronometer.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jChronometer.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jChronometer.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jChronometer.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_SetId(FjEnv, FjObject, _id);
end;

procedure jChronometer.SetBaseElapsedRealtime();
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_SetBaseElapsedRealtime(FjEnv, FjObject);
end;

function jChronometer.GetElapsedTimeMillis(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jChronometer_GetElapsedTimeMillis(FjEnv, FjObject);
end;

function jChronometer.Start(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jChronometer_Start(FjEnv, FjObject);
end;

function jChronometer.Stop(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jChronometer_Stop(FjEnv, FjObject);
end;

function jChronometer.Reset(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jChronometer_Reset(FjEnv, FjObject);
end;

procedure jChronometer.SetThresholdTick(_thresholdTickMillis: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_SetThresholdTick(FjEnv, FjObject, _thresholdTickMillis);
end;

procedure jChronometer.SetBaseElapsedRealtime(_elapsedMillis: int64);
begin
  //in designing component state: set value here...
  if FInitialized then
     jChronometer_SetBaseElapsedRealtime(FjEnv, FjObject, _elapsedMillis);
end;

function jChronometer.GetSystemElapsedRealtime(): int64;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jChronometer_GetSystemElapsedRealtime(FjEnv, FjObject);
end;

{-------- jChronometer_JNI_Bridge ----------}

function jChronometer_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jChronometer_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jChronometer_jCreate(long _Self) {
      return (java.lang.Object)(new jChronometer(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jChronometer_jFree(env: PJNIEnv; _jchronometer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jchronometer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_SetViewParent(env: PJNIEnv; _jchronometer: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jchronometer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_RemoveFromViewParent(env: PJNIEnv; _jchronometer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jchronometer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jChronometer_GetView(env: PJNIEnv; _jchronometer: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jchronometer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_SetLParamWidth(env: PJNIEnv; _jchronometer: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jchronometer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_SetLParamHeight(env: PJNIEnv; _jchronometer: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jchronometer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jchronometer: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jchronometer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_AddLParamsAnchorRule(env: PJNIEnv; _jchronometer: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jchronometer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_AddLParamsParentRule(env: PJNIEnv; _jchronometer: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jchronometer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_SetLayoutAll(env: PJNIEnv; _jchronometer: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jchronometer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_ClearLayoutAll(env: PJNIEnv; _jchronometer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jchronometer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_SetId(env: PJNIEnv; _jchronometer: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jchronometer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_SetBaseElapsedRealtime(env: PJNIEnv; _jchronometer: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBaseElapsedRealtime', '()V');
  env^.CallVoidMethod(env, _jchronometer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jChronometer_GetElapsedTimeMillis(env: PJNIEnv; _jchronometer: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'GetElapsedTimeMillis', '()J');
  Result:= env^.CallLongMethod(env, _jchronometer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jChronometer_Start(env: PJNIEnv; _jchronometer: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'Start', '()J');
  Result:= env^.CallLongMethod(env, _jchronometer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jChronometer_Stop(env: PJNIEnv; _jchronometer: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'Stop', '()J');
  Result:= env^.CallLongMethod(env, _jchronometer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jChronometer_Reset(env: PJNIEnv; _jchronometer: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'Reset', '()J');
  Result:= env^.CallLongMethod(env, _jchronometer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jChronometer_SetThresholdTick(env: PJNIEnv; _jchronometer: JObject; _thresholdTickMillis: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _thresholdTickMillis;
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetThresholdTick', '(I)V');
  env^.CallVoidMethodA(env, _jchronometer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jChronometer_SetBaseElapsedRealtime(env: PJNIEnv; _jchronometer: JObject; _elapsedMillis: int64);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _elapsedMillis;
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBaseElapsedRealtime', '(J)V');
  env^.CallVoidMethodA(env, _jchronometer, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jChronometer_GetSystemElapsedRealtime(env: PJNIEnv; _jchronometer: JObject): int64;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jchronometer);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSystemElapsedRealtime', '()J');
  Result:= env^.CallLongMethod(env, _jchronometer, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


end.
