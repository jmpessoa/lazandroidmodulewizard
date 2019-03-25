unit analogclock;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/9/2015 3:15:55]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jAnalogClock = class(jVisualControl)
 private
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
    procedure SetViewParent(_viewgroup: jObject);  override;
    procedure RemoveFromViewParent();   override;
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetId(_id: integer);
    procedure SetLGravity(_value: TLayoutGravity);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jAnalogClock_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jAnalogClock_jFree(env: PJNIEnv; _janalogclock: JObject);
procedure jAnalogClock_SetViewParent(env: PJNIEnv; _janalogclock: JObject; _viewgroup: jObject);
procedure jAnalogClock_RemoveFromViewParent(env: PJNIEnv; _janalogclock: JObject);
function jAnalogClock_GetView(env: PJNIEnv; _janalogclock: JObject): jObject;
procedure jAnalogClock_SetLParamWidth(env: PJNIEnv; _janalogclock: JObject; _w: integer);
procedure jAnalogClock_SetLParamHeight(env: PJNIEnv; _janalogclock: JObject; _h: integer);
procedure jAnalogClock_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _janalogclock: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jAnalogClock_AddLParamsAnchorRule(env: PJNIEnv; _janalogclock: JObject; _rule: integer);
procedure jAnalogClock_AddLParamsParentRule(env: PJNIEnv; _janalogclock: JObject; _rule: integer);
procedure jAnalogClock_SetLayoutAll(env: PJNIEnv; _janalogclock: JObject; _idAnchor: integer);
procedure jAnalogClock_ClearLayoutAll(env: PJNIEnv; _janalogclock: JObject);
procedure jAnalogClock_SetId(env: PJNIEnv; _janalogclock: JObject; _id: integer);
procedure jAnalogClock_SetFrameGravity(env: PJNIEnv; _janalogclock: JObject; _value: integer);


implementation

{---------  jAnalogClock  --------------}

constructor jAnalogClock.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 96; //??
  FWidth        := 96; //??
  FLParamWidth  := lpWrapContent; //lpMatchParent;  //
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor jAnalogClock.Destroy;
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

procedure jAnalogClock.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not Initialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject:= jCreate(); //jSelf !

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   if FGravityInParent <> lgNone then
    jAnalogClock_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent));

   jAnalogClock_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jAnalogClock_SetId(FjEnv, FjObject, Self.Id);
  end;

  jAnalogClock_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jAnalogClock_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jAnalogClock_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jAnalogClock_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   
   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jAnalogClock.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jAnalogClock.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jAnalogClock.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jAnalogClock.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
procedure jAnalogClock.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jAnalogClock.jCreate(): jObject;
begin
   Result:= jAnalogClock_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jAnalogClock.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAnalogClock_jFree(FjEnv, FjObject);
end;

procedure jAnalogClock.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAnalogClock_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jAnalogClock.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jAnalogClock_RemoveFromViewParent(FjEnv, FjObject);
end;

function jAnalogClock.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jAnalogClock_GetView(FjEnv, FjObject);
end;

procedure jAnalogClock.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAnalogClock_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jAnalogClock.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAnalogClock_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jAnalogClock.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAnalogClock_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jAnalogClock.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAnalogClock_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jAnalogClock.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAnalogClock_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jAnalogClock.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAnalogClock_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jAnalogClock.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jAnalogClock_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jAnalogClock_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jAnalogClock_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jAnalogClock.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jAnalogClock_SetId(FjEnv, FjObject, _id);
end;

procedure jAnalogClock.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _value;
  if FInitialized then
     jAnalogClock_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent));
end;

{-------- jAnalogClock_JNI_Bridge ----------}

function jAnalogClock_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jAnalogClock_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jAnalogClock_jCreate(long _Self) {
      return (java.lang.Object)(new jAnalogClock(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jAnalogClock_jFree(env: PJNIEnv; _janalogclock: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _janalogclock, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAnalogClock_SetViewParent(env: PJNIEnv; _janalogclock: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _janalogclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAnalogClock_RemoveFromViewParent(env: PJNIEnv; _janalogclock: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _janalogclock, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jAnalogClock_GetView(env: PJNIEnv; _janalogclock: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _janalogclock, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAnalogClock_SetLParamWidth(env: PJNIEnv; _janalogclock: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _janalogclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAnalogClock_SetLParamHeight(env: PJNIEnv; _janalogclock: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _janalogclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAnalogClock_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _janalogclock: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _janalogclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAnalogClock_AddLParamsAnchorRule(env: PJNIEnv; _janalogclock: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _janalogclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAnalogClock_AddLParamsParentRule(env: PJNIEnv; _janalogclock: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _janalogclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAnalogClock_SetLayoutAll(env: PJNIEnv; _janalogclock: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _janalogclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAnalogClock_ClearLayoutAll(env: PJNIEnv; _janalogclock: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _janalogclock, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jAnalogClock_SetId(env: PJNIEnv; _janalogclock: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _janalogclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jAnalogClock_SetFrameGravity(env: PJNIEnv; _janalogclock: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _janalogclock);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _janalogclock, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


end.
