unit calendarview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TOnCalendarSelectedDayChange = procedure(Sender: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [9/17/2018 16:06:35]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jCalendarView = class(jVisualControl)
 private

    FFocusedMonthDateColor: TARGBColorBridge;
    FSelectedWeekBackgroundColor: TARGBColorBridge;
    FWeekSeparatorLineColor: TARGBColorBridge;
    FWeekNumberColor: TARGBColorBridge;

    FFirstDayOfWeek: integer;

    FOnSelectedDayChange: TOnCalendarSelectedDayChange;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent(); override;
    function GetView(): jObject; override;
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
    procedure SetId(_id: integer);
    procedure SetFirstDayOfWeek(_firstDayOfWeek: integer);
    function GetFirstDayOfWeek(): integer;

    procedure SetFocusedMonthDateColor(_color: TARGBColorBridge);
    procedure SetUnfocusedMonthDateColor(_color: TARGBColorBridge);
    procedure SetSelectedWeekBackgroundColor(_color: TARGBColorBridge);
    procedure SetWeekSeparatorLineColor(_color: TARGBColorBridge);
    procedure SetWeekNumberColor(_color: TARGBColorBridge);

    function GetDate(): string;
    function GetMaxDate(): string;
    function GetMinDate(): string;
    procedure SetShowWeekNumber(_value: boolean);

    procedure SetDate(_year: integer; _month: integer; _day: integer);
    procedure SetMaxDate(_year: integer; _month: integer; _day: integer);
    procedure SetMinDate(_year: integer; _month: integer; _day: integer);

    procedure GenEvent_OnSelectedDayChange(Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property FocusedMonthDateColor: TARGBColorBridge read FFocusedMonthDateColor write SetFocusedMonthDateColor;
    property SelectedWeekBackgroundColor: TARGBColorBridge read FSelectedWeekBackgroundColor write SetSelectedWeekBackgroundColor;
    property WeekSeparatorLineColor: TARGBColorBridge read FWeekSeparatorLineColor write SetWeekSeparatorLineColor;
    property WeekNumberColor: TARGBColorBridge read FWeekNumberColor write setWeekNumberColor;
    property FirstDayOfWeek: integer read FFirstDayOfWeek write SetFirstDayOfWeek;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnSelectedDayChange: TOnCalendarSelectedDayChange read FOnSelectedDayChange write FOnSelectedDayChange;

end;

function jCalendarView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jCalendarView_jFree(env: PJNIEnv; _jcalendarview: JObject);
procedure jCalendarView_SetViewParent(env: PJNIEnv; _jcalendarview: JObject; _viewgroup: jObject);
function jCalendarView_GetParent(env: PJNIEnv; _jcalendarview: JObject): jObject;
procedure jCalendarView_RemoveFromViewParent(env: PJNIEnv; _jcalendarview: JObject);
function jCalendarView_GetView(env: PJNIEnv; _jcalendarview: JObject): jObject;
procedure jCalendarView_SetLParamWidth(env: PJNIEnv; _jcalendarview: JObject; _w: integer);
procedure jCalendarView_SetLParamHeight(env: PJNIEnv; _jcalendarview: JObject; _h: integer);
function jCalendarView_GetLParamWidth(env: PJNIEnv; _jcalendarview: JObject): integer;
function jCalendarView_GetLParamHeight(env: PJNIEnv; _jcalendarview: JObject): integer;
procedure jCalendarView_SetLGravity(env: PJNIEnv; _jcalendarview: JObject; _g: integer);
procedure jCalendarView_SetLWeight(env: PJNIEnv; _jcalendarview: JObject; _w: single);
procedure jCalendarView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcalendarview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jCalendarView_AddLParamsAnchorRule(env: PJNIEnv; _jcalendarview: JObject; _rule: integer);
procedure jCalendarView_AddLParamsParentRule(env: PJNIEnv; _jcalendarview: JObject; _rule: integer);
procedure jCalendarView_SetLayoutAll(env: PJNIEnv; _jcalendarview: JObject; _idAnchor: integer);
procedure jCalendarView_ClearLayoutAll(env: PJNIEnv; _jcalendarview: JObject);
procedure jCalendarView_SetId(env: PJNIEnv; _jcalendarview: JObject; _id: integer);
procedure jCalendarView_SetFirstDayOfWeek(env: PJNIEnv; _jcalendarview: JObject; _firstDayOfWeek: integer);
function jCalendarView_GetFirstDayOfWeek(env: PJNIEnv; _jcalendarview: JObject): integer;
procedure jCalendarView_SetFocusedMonthDateColor(env: PJNIEnv; _jcalendarview: JObject; _color: integer);
procedure jCalendarView_SetUnfocusedMonthDateColor(env: PJNIEnv; _jcalendarview: JObject; _color: integer);
procedure jCalendarView_SetSelectedWeekBackgroundColor(env: PJNIEnv; _jcalendarview: JObject; _color: integer);
procedure jCalendarView_SetWeekSeparatorLineColor(env: PJNIEnv; _jcalendarview: JObject; _color: integer);
procedure jCalendarView_SetWeekNumberColor(env: PJNIEnv; _jcalendarview: JObject; _color: integer);
function jCalendarView_GetDate(env: PJNIEnv; _jcalendarview: JObject): string;
function jCalendarView_GetMaxDate(env: PJNIEnv; _jcalendarview: JObject): string;
function jCalendarView_GetMinDate(env: PJNIEnv; _jcalendarview: JObject): string;
procedure jCalendarView_SetShowWeekNumber(env: PJNIEnv; _jcalendarview: JObject; _value: boolean);

procedure jCalendarView_SetDate(env: PJNIEnv; _jcalendarview: JObject; _year: integer; _month: integer; _day: integer);
procedure jCalendarView_SetMaxDate(env: PJNIEnv; _jcalendarview: JObject; _year: integer; _month: integer; _day: integer);
procedure jCalendarView_SetMinDate(env: PJNIEnv; _jcalendarview: JObject; _year: integer; _month: integer; _day: integer);


implementation

{---------  jCalendarView  --------------}

constructor jCalendarView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 200; //??
  FWidth        := 192; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;

//your code here....
  FFirstDayOfWeek:= 2;

  FFocusedMonthDateColor:= colbrDefault;
  FSelectedWeekBackgroundColor:= colbrDefault;
  FWeekSeparatorLineColor:= colbrDefault;
  FWeekNumberColor:= colbrDefault;

end;

destructor jCalendarView.Destroy;
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

procedure jCalendarView.Init(refApp: jApp);
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

   jCalendarView_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jCalendarView_SetId(FjEnv, FjObject, Self.Id);
  end;

  jCalendarView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH ));
                  
  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jCalendarView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jCalendarView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jCalendarView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   jCalendarView_SetFirstDayOfWeek(FjEnv, FjObject, FFirstDayOfWeek);

   if FFocusedMonthDateColor <> colbrDefault then
    jCalendarView_SetFocusedMonthDateColor(FjEnv, FjObject, GetARGB(FCustomColor, FFocusedMonthDateColor));

   if FSelectedWeekBackgroundColor <> colbrDefault then
    jCalendarView_SetSelectedWeekBackgroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FSelectedWeekBackgroundColor));

   if FWeekSeparatorLineColor <> colbrDefault then
    jCalendarView_SetWeekSeparatorLineColor(FjEnv, FjObject, GetARGB(FCustomColor, FWeekSeparatorLineColor));

   if FWeekNumberColor <> colbrDefault then
    jCalendarView_SetWeekNumberColor(FjEnv, FjObject, GetARGB(FCustomColor, FWeekNumberColor));

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jCalendarView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jCalendarView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jCalendarView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jCalendarView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jCalendarView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jCalendarView.jCreate(): jObject;
begin
   Result:= jCalendarView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jCalendarView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_jFree(FjEnv, FjObject);
end;

procedure jCalendarView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jCalendarView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCalendarView_GetParent(FjEnv, FjObject);
end;

procedure jCalendarView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jCalendarView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCalendarView_GetView(FjEnv, FjObject);
end;

procedure jCalendarView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jCalendarView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jCalendarView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCalendarView_GetLParamWidth(FjEnv, FjObject);
end;

function jCalendarView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCalendarView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jCalendarView.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jCalendarView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jCalendarView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jCalendarView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jCalendarView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jCalendarView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jCalendarView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jCalendarView_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jCalendarView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jCalendarView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jCalendarView.SetId(_id: integer);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jCalendarView_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jCalendarView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jCalendarView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jCalendarView.SetFirstDayOfWeek(_firstDayOfWeek: integer);
begin
  //in designing component state: set value here...
  FFirstDayOfWeek:= _firstDayOfWeek;

  if FFirstDayOfWeek < 1 then  FFirstDayOfWeek:= 1;
  if FFirstDayOfWeek > 7 then  FFirstDayOfWeek:= 7;

  if FInitialized then
     jCalendarView_SetFirstDayOfWeek(FjEnv, FjObject, _firstDayOfWeek);
end;

function jCalendarView.GetFirstDayOfWeek(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCalendarView_GetFirstDayOfWeek(FjEnv, FjObject);
end;

procedure jCalendarView.SetFocusedMonthDateColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FFocusedMonthDateColor:= _color;
  if FInitialized then
     jCalendarView_SetFocusedMonthDateColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jCalendarView.SetUnfocusedMonthDateColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  //FUnFocusedMonthDateColor:= _color;
  if FInitialized then
     jCalendarView_SetUnfocusedMonthDateColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jCalendarView.SetSelectedWeekBackgroundColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FSelectedWeekBackgroundColor:= _color;
  if FInitialized then
     jCalendarView_SetSelectedWeekBackgroundColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jCalendarView.SetWeekSeparatorLineColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FWeekSeparatorLineColor:= _color;
  if FInitialized then
     jCalendarView_SetWeekSeparatorLineColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jCalendarView.SetWeekNumberColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FWeekNumberColor:= _color;
  if FInitialized then
     jCalendarView_SetWeekNumberColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

function jCalendarView.GetDate(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCalendarView_GetDate(FjEnv, FjObject);
end;

function jCalendarView.GetMaxDate(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCalendarView_GetMaxDate(FjEnv, FjObject);
end;

function jCalendarView.GetMinDate(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCalendarView_GetMinDate(FjEnv, FjObject);
end;

procedure jCalendarView.SetShowWeekNumber(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetShowWeekNumber(FjEnv, FjObject, _value);
end;

procedure jCalendarView.SetDate(_year: integer; _month: integer; _day: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetDate(FjEnv, FjObject, _year ,_month ,_day);
end;

procedure jCalendarView.SetMaxDate(_year: integer; _month: integer; _day: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetMaxDate(FjEnv, FjObject, _year ,_month ,_day);
end;

procedure jCalendarView.SetMinDate(_year: integer; _month: integer; _day: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCalendarView_SetMinDate(FjEnv, FjObject, _year ,_month ,_day);
end;


procedure jCalendarView.GenEvent_OnSelectedDayChange(Obj: TObject; year: integer; monthOfYear: integer; dayOfMonth: integer);
begin
  if Assigned(FOnSelectedDayChange) then FOnSelectedDayChange(Obj, year, monthOfYear, dayOfMonth);
end;

{-------- jCalendarView_JNI_Bridge ----------}

function jCalendarView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jCalendarView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jCalendarView_jFree(env: PJNIEnv; _jcalendarview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcalendarview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetViewParent(env: PJNIEnv; _jcalendarview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jCalendarView_GetParent(env: PJNIEnv; _jcalendarview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jcalendarview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_RemoveFromViewParent(env: PJNIEnv; _jcalendarview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jcalendarview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jCalendarView_GetView(env: PJNIEnv; _jcalendarview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jcalendarview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetLParamWidth(env: PJNIEnv; _jcalendarview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetLParamHeight(env: PJNIEnv; _jcalendarview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jCalendarView_GetLParamWidth(env: PJNIEnv; _jcalendarview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jcalendarview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jCalendarView_GetLParamHeight(env: PJNIEnv; _jcalendarview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jcalendarview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetLGravity(env: PJNIEnv; _jcalendarview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetLWeight(env: PJNIEnv; _jcalendarview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcalendarview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_AddLParamsAnchorRule(env: PJNIEnv; _jcalendarview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_AddLParamsParentRule(env: PJNIEnv; _jcalendarview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetLayoutAll(env: PJNIEnv; _jcalendarview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_ClearLayoutAll(env: PJNIEnv; _jcalendarview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jcalendarview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetId(env: PJNIEnv; _jcalendarview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetFirstDayOfWeek(env: PJNIEnv; _jcalendarview: JObject; _firstDayOfWeek: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _firstDayOfWeek;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFirstDayOfWeek', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jCalendarView_GetFirstDayOfWeek(env: PJNIEnv; _jcalendarview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFirstDayOfWeek', '()I');
  Result:= env^.CallIntMethod(env, _jcalendarview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetFocusedMonthDateColor(env: PJNIEnv; _jcalendarview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFocusedMonthDateColor', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetUnfocusedMonthDateColor(env: PJNIEnv; _jcalendarview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUnfocusedMonthDateColor', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetSelectedWeekBackgroundColor(env: PJNIEnv; _jcalendarview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetSelectedWeekBackgroundColor', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetWeekSeparatorLineColor(env: PJNIEnv; _jcalendarview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetWeekSeparatorLineColor', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetWeekNumberColor(env: PJNIEnv; _jcalendarview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetWeekNumberColor', '(I)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jCalendarView_GetDate(env: PJNIEnv; _jcalendarview: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDate', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jcalendarview, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jCalendarView_GetMaxDate(env: PJNIEnv; _jcalendarview: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMaxDate', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jcalendarview, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jCalendarView_GetMinDate(env: PJNIEnv; _jcalendarview: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMinDate', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jcalendarview, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetShowWeekNumber(env: PJNIEnv; _jcalendarview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetShowWeekNumber', '(Z)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCalendarView_SetDate(env: PJNIEnv; _jcalendarview: JObject; _year: integer; _month: integer; _day: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _year;
  jParams[1].i:= _month;
  jParams[2].i:= _day;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDate', '(III)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetMaxDate(env: PJNIEnv; _jcalendarview: JObject; _year: integer; _month: integer; _day: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _year;
  jParams[1].i:= _month;
  jParams[2].i:= _day;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMaxDate', '(III)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCalendarView_SetMinDate(env: PJNIEnv; _jcalendarview: JObject; _year: integer; _month: integer; _day: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _year;
  jParams[1].i:= _month;
  jParams[2].i:= _day;
  jCls:= env^.GetObjectClass(env, _jcalendarview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMinDate', '(III)V');
  env^.CallVoidMethodA(env, _jcalendarview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
