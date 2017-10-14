unit digitalclock;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/9/2015 6:09:28]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jDigitalClock = class(jVisualControl)
 private
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    Procedure SetFontColor    (Value : TARGBColorBridge);
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
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent();
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);
    procedure SetFontSize(_size: DWord);
    procedure SetFontSizeUnit(_unit: TFontSizeUnit);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FontSize: DWord  read FFontSize write SetFontSize;
    property FontColor: TARGBColorBridge read FFontColor write SetFontColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;
    property FontSizeUnit: TFontSizeUnit read FFontSizeUnit write SetFontSizeUnit;

end;

function jDigitalClock_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jDigitalClock_jFree(env: PJNIEnv; _jdigitalclock: JObject);
procedure jDigitalClock_SetViewParent(env: PJNIEnv; _jdigitalclock: JObject; _viewgroup: jObject);
procedure jDigitalClock_RemoveFromViewParent(env: PJNIEnv; _jdigitalclock: JObject);
function jDigitalClock_GetView(env: PJNIEnv; _jdigitalclock: JObject): jObject;
procedure jDigitalClock_SetLParamWidth(env: PJNIEnv; _jdigitalclock: JObject; _w: integer);
procedure jDigitalClock_SetLParamHeight(env: PJNIEnv; _jdigitalclock: JObject; _h: integer);
procedure jDigitalClock_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jdigitalclock: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jDigitalClock_AddLParamsAnchorRule(env: PJNIEnv; _jdigitalclock: JObject; _rule: integer);
procedure jDigitalClock_AddLParamsParentRule(env: PJNIEnv; _jdigitalclock: JObject; _rule: integer);
procedure jDigitalClock_SetLayoutAll(env: PJNIEnv; _jdigitalclock: JObject; _idAnchor: integer);
procedure jDigitalClock_ClearLayoutAll(env: PJNIEnv; _jdigitalclock: JObject);
procedure jDigitalClock_SetId(env: PJNIEnv; _jdigitalclock: JObject; _id: integer);
procedure jDigitalClock_SetTextSize(env: PJNIEnv; _jdigitalclock: JObject; _size: integer);
Procedure jDigitalClock_setTextColor(env:PJNIEnv; _jdigitalclock: jObject; color : DWord);
//procedure jDigitalClock_SetChangeFontSizeByComplexUnitPixel(env: PJNIEnv; _jdigitalclock: JObject; _value: boolean);
procedure jDigitalClock_SetFontSizeUnit(env: PJNIEnv; _jdigitalclock: JObject; _unit: integer);


implementation

uses
   customdialog, toolbar;

{---------  jDigitalClock  --------------}

constructor jDigitalClock.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 48; //??
  FWidth        := 96; //??
  FLParamWidth  := lpWrapContent; //lpMatchParent;  //
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor jDigitalClock.Destroy;
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

procedure jDigitalClock.Init(refApp: jApp);
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
  jDigitalClock_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jDigitalClock_SetId(FjEnv, FjObject, Self.Id);
  jDigitalClock_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jDigitalClock_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jDigitalClock_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jDigitalClock_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if FFontColor <> colbrDefault then
       jDigitalClock_setTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));

  if FFontSizeUnit <> unitDefault then
        jDigitalClock_SetFontSizeUnit(FjEnv, FjObject, Ord(FFontSizeUnit));

  if FFontSize <> 0 then
      jDigitalClock_SetTextSize(FjEnv, FjObject, FFontSize);

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jDigitalClock.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jDigitalClock.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jDigitalClock.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jDigitalClock_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
          jDigitalClock_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
       else //lpMatchParent or others
          jDigitalClock_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jDigitalClock.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jDigitalClock_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
         jDigitalClock_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
         jDigitalClock_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jDigitalClock.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jDigitalClock_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jDigitalClock.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jDigitalClock.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jDigitalClock_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jDigitalClock_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jDigitalClock_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jDigitalClock.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jDigitalClock.jCreate(): jObject;
begin
   Result:= jDigitalClock_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jDigitalClock.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_jFree(FjEnv, FjObject);
end;

procedure jDigitalClock.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jDigitalClock.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_RemoveFromViewParent(FjEnv, FjObject);
end;

function jDigitalClock.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDigitalClock_GetView(FjEnv, FjObject);
end;

procedure jDigitalClock.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jDigitalClock.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jDigitalClock.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jDigitalClock.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jDigitalClock.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jDigitalClock.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jDigitalClock.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jDigitalClock.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDigitalClock_SetId(FjEnv, FjObject, _id);
end;

procedure jDigitalClock.SetFontSize(_size: DWord);
begin
  //in designing component state: set value here...
  FFontSize:= _size;
  if FInitialized then
     jDigitalClock_SetTextSize(FjEnv, FjObject, _size);
end;

Procedure jDigitalClock.SetFontColor(Value: TARGBColorBridge);
begin
 FFontColor:= Value;
 if (FInitialized = True) and (FFontColor <> colbrDefault) then
     jDigitalClock_setTextColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));
end;

procedure jDigitalClock.SetFontSizeUnit(_unit: TFontSizeUnit);
begin
  //in designing component state: set value here...
  FFontSizeUnit:= _unit;
  if FInitialized then
     jDigitalClock_SetFontSizeUnit(FjEnv, FjObject, Ord(_unit));
end;

{-------- jDigitalClock_JNI_Bridge ----------}

function jDigitalClock_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jDigitalClock_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jDigitalClock_jCreate(long _Self) {
      return (java.lang.Object)(new jDigitalClock(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jDigitalClock_jFree(env: PJNIEnv; _jdigitalclock: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jdigitalclock, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDigitalClock_SetViewParent(env: PJNIEnv; _jdigitalclock: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jdigitalclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDigitalClock_RemoveFromViewParent(env: PJNIEnv; _jdigitalclock: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jdigitalclock, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jDigitalClock_GetView(env: PJNIEnv; _jdigitalclock: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jdigitalclock, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDigitalClock_SetLParamWidth(env: PJNIEnv; _jdigitalclock: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jdigitalclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDigitalClock_SetLParamHeight(env: PJNIEnv; _jdigitalclock: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jdigitalclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDigitalClock_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jdigitalclock: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jdigitalclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDigitalClock_AddLParamsAnchorRule(env: PJNIEnv; _jdigitalclock: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jdigitalclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDigitalClock_AddLParamsParentRule(env: PJNIEnv; _jdigitalclock: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jdigitalclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDigitalClock_SetLayoutAll(env: PJNIEnv; _jdigitalclock: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jdigitalclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDigitalClock_ClearLayoutAll(env: PJNIEnv; _jdigitalclock: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jdigitalclock, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDigitalClock_SetId(env: PJNIEnv; _jdigitalclock: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jdigitalclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDigitalClock_SetTextSize(env: PJNIEnv; _jdigitalclock: JObject; _size: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _size;
  jCls:= env^.GetObjectClass(env, _jdigitalclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextSize', '(F)V');
  env^.CallVoidMethodA(env, _jdigitalclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

Procedure jDigitalClock_setTextColor(env:PJNIEnv; _jdigitalclock: jObject; color : DWord);
var
  _jMethod : jMethodID = nil;
  _jParams : array[0..0] of jValue;
  cls: jClass;
begin
  _jParams[0].i := color;
  cls := env^.GetObjectClass(env, _jdigitalclock);
  _jMethod:= env^.GetMethodID(env, cls, 'setTextColor', '(I)V');
  env^.CallVoidMethodA(env,_jdigitalclock,_jMethod,@_jParams);
  env^.DeleteLocalRef(env, cls);
end;


procedure jDigitalClock_SetFontSizeUnit(env: PJNIEnv; _jdigitalclock: JObject; _unit: integer);
var
 jParams: array[0..0] of jValue;
 jMethod: jMethodID=nil;
 jCls: jClass=nil;
begin
 jParams[0].i:= _unit;
 jCls:= env^.GetObjectClass(env, _jdigitalclock);
 jMethod:= env^.GetMethodID(env, jCls, 'SetFontSizeUnit', '(I)V');
 env^.CallVoidMethodA(env, _jdigitalclock, jMethod, @jParams);
 env^.DeleteLocalRef(env, jCls);
end;

end.
