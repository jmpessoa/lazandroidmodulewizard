unit seekbar;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, systryparent;

type

TOnSeekBarProgressChanged = procedure(Sender: TObject;  progress: integer; fromUser: boolean) of Object;
TOnSeekBarStartTrackingTouch= procedure(Sender: TObject;  progress: integer) of Object;
TOnSeekBarStopTrackingTouch= procedure(Sender: TObject;  progress: integer) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [7/8/2015 23:40:47]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jSeekBar = class(jVisualControl)
 private
    FMax: integer;
    FProgress: integer;
    FOnSeekBarProgressChanged:    TOnSeekBarProgressChanged;
    FOnSeekBarStartTrackingTouch: TOnSeekBarStartTrackingTouch;
    FOnSeekBarStopTrackingTouch:  TOnSeekBarStopTrackingTouch;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    //procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject);  override;
    procedure RemoveFromViewParent();  override;
    function GetView(): jObject; override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayout();
    procedure SetId(_id: integer);
    procedure SetMax(_maxProgress: integer);
    procedure SetProgress(_progress: integer);
    function GetProgress(): integer;
    procedure SetRotation(_rotation: single);
    procedure SetLGravity(_value: TLayoutGravity);

    procedure GenEvent_OnSeekBarProgressChanged(Obj: TObject; progress: integer; fromUser: boolean);
    procedure GenEvent_OnSeekBarStartTrackingTouch(Obj: TObject; progress: integer);
    procedure GenEvent_OnSeekBarStopTrackingTouch(Obj: TObject; progress: integer);
    property Progress:integer read GetProgress write SetProgress;

 published

    property Max: integer read FMax write SetMax;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    //property OnClick: TOnNotify read FOnClick write FOnClick;

    property OnProgressChanged:    TOnSeekBarProgressChanged read FOnSeekBarProgressChanged write FOnSeekBarProgressChanged;
    property OnStartTrackingTouch: TOnSeekBarStartTrackingTouch read FOnSeekBarStartTrackingTouch write FOnSeekBarStartTrackingTouch;
    property OnStopTrackingTouch:  TOnSeekBarStopTrackingTouch read FOnSeekBarStopTrackingTouch write FOnSeekBarStopTrackingTouch;

end;

function jSeekBar_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jSeekBar_jFree(env: PJNIEnv; _jseekbar: JObject);
procedure jSeekBar_SetViewParent(env: PJNIEnv; _jseekbar: JObject; _viewgroup: jObject);
procedure jSeekBar_RemoveFromViewParent(env: PJNIEnv; _jseekbar: JObject);
function jSeekBar_GetView(env: PJNIEnv; _jseekbar: JObject): jObject;
procedure jSeekBar_SetLParamWidth(env: PJNIEnv; _jseekbar: JObject; _w: integer);
procedure jSeekBar_SetLParamHeight(env: PJNIEnv; _jseekbar: JObject; _h: integer);
procedure jSeekBar_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jseekbar: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jSeekBar_AddLParamsAnchorRule(env: PJNIEnv; _jseekbar: JObject; _rule: integer);
procedure jSeekBar_AddLParamsParentRule(env: PJNIEnv; _jseekbar: JObject; _rule: integer);
procedure jSeekBar_SetLayoutAll(env: PJNIEnv; _jseekbar: JObject; _idAnchor: integer);
procedure jSeekBar_ClearLayoutAll(env: PJNIEnv; _jseekbar: JObject);
procedure jSeekBar_SetId(env: PJNIEnv; _jseekbar: JObject; _id: integer);
procedure jSeekBar_SetMax(env: PJNIEnv; _jseekbar: JObject; _maxProgress: integer);
procedure jSeekBar_SetProgress(env: PJNIEnv; _jseekbar: JObject; _progress: integer);
function jSeekBar_GetProgress(env: PJNIEnv; _jseekbar: JObject): integer;
procedure jSeekBar_SetRotation(env: PJNIEnv; _jseekbar: JObject; _rotation: single);
procedure jSeekBar_SetFrameGravity(env: PJNIEnv; _jseekbar: JObject; _value: integer);


implementation


{---------  jSeekBar  --------------}

constructor jSeekBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 30; //??
  FWidth        := 100; //??
  FLParamWidth  := lpOneThirdOfParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FMax:= 100;
  FProgress:= 50;
end;

destructor jSeekBar.Destroy;
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

procedure jSeekBar.Init(refApp: jApp);
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
    jSeekBar_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent));

   jSeekBar_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jSeekBar_SetId(FjEnv, FjObject, Self.Id);
  end;

  jSeekBar_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jSeekBar_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jSeekBar_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jSeekBar_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   if FMax <> 100  then
     jSeekBar_SetMax(FjEnv, FjObject, FMax);

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jSeekBar.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jSeekBar.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jSeekBar.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jSeekBar.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
{
procedure jSeekBar.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
}

function jSeekBar.jCreate(): jObject;
begin
   Result:= jSeekBar_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jSeekBar.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_jFree(FjEnv, FjObject);
end;

procedure jSeekBar.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jSeekBar.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_RemoveFromViewParent(FjEnv, FjObject);
end;

function jSeekBar.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSeekBar_GetView(FjEnv, FjObject);
end;

procedure jSeekBar.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jSeekBar.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jSeekBar.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jSeekBar.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jSeekBar.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jSeekBar.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jSeekBar.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jSeekBar_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jSeekBar_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jSeekBar_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jSeekBar.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_SetId(FjEnv, FjObject, _id);
end;

procedure jSeekBar.SetMax(_maxProgress: integer);
begin
  //in designing component state: set value here...
  FMax:= _maxProgress;
  if FInitialized then
     jSeekBar_SetMax(FjEnv, FjObject, _maxProgress);
end;

procedure jSeekBar.SetProgress(_progress: integer);
begin
  //in designing component state: set value here...
  FProgress:=  _progress;
  if FInitialized then
     jSeekBar_SetProgress(FjEnv, FjObject, _progress);
end;

function jSeekBar.GetProgress(): integer;
begin
  //in designing component state: result value here...
  Result:= FProgress;
  if FInitialized then
    Result:= jSeekBar_GetProgress(FjEnv, FjObject);
end;

procedure jSeekBar.SetRotation(_rotation: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSeekBar_SetRotation(FjEnv, FjObject, _rotation);
end;

procedure jSeekBar.SetLGravity(_value: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _value;
  if FInitialized then
     jSeekBar_SetFrameGravity(FjEnv, FjObject, Ord(FGravityInParent));
end;

procedure jSeekBar.GenEvent_OnSeekBarProgressChanged(Obj: TObject; progress: integer; fromUser: boolean);
begin
  if Assigned(FOnSeekBarProgressChanged) then FOnSeekBarProgressChanged(Obj, progress, fromUser);
end;

procedure jSeekBar.GenEvent_OnSeekBarStartTrackingTouch(Obj: TObject; progress: integer);
begin
  if Assigned(FOnSeekBarStartTrackingTouch) then FOnSeekBarStartTrackingTouch(Obj, progress);
end;

procedure jSeekBar.GenEvent_OnSeekBarStopTrackingTouch(Obj: TObject; progress: integer);
begin
  if Assigned(FOnSeekBarStopTrackingTouch) then FOnSeekBarStopTrackingTouch(Obj, progress);
end;

{-------- jSeekBar_JNI_Bridge ----------}

function jSeekBar_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSeekBar_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jSeekBar_jCreate(long _Self) {
      return (java.lang.Object)(new jSeekBar(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jSeekBar_jFree(env: PJNIEnv; _jseekbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jseekbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_SetViewParent(env: PJNIEnv; _jseekbar: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_RemoveFromViewParent(env: PJNIEnv; _jseekbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jseekbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSeekBar_GetView(env: PJNIEnv; _jseekbar: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jseekbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_SetLParamWidth(env: PJNIEnv; _jseekbar: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_SetLParamHeight(env: PJNIEnv; _jseekbar: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jseekbar: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_AddLParamsAnchorRule(env: PJNIEnv; _jseekbar: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_AddLParamsParentRule(env: PJNIEnv; _jseekbar: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_SetLayoutAll(env: PJNIEnv; _jseekbar: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_ClearLayoutAll(env: PJNIEnv; _jseekbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jseekbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_SetId(env: PJNIEnv; _jseekbar: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_SetMax(env: PJNIEnv; _jseekbar: JObject; _maxProgress: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _maxProgress;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMax', '(I)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSeekBar_SetProgress(env: PJNIEnv; _jseekbar: JObject; _progress: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _progress;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetProgress', '(I)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jSeekBar_GetProgress(env: PJNIEnv; _jseekbar: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetProgress', '()I');
  Result:= env^.CallIntMethod(env, _jseekbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSeekBar_SetRotation(env: PJNIEnv; _jseekbar: JObject; _rotation: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _rotation;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRotation', '(F)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSeekBar_SetFrameGravity(env: PJNIEnv; _jseekbar: JObject; _value: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _value;
  jCls:= env^.GetObjectClass(env, _jseekbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jseekbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
