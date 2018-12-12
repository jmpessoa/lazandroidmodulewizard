unit sadmob;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TOnAdMobLoaded = procedure(Sender: TObject) of Object;
TOnAdMobFailedToLoad = procedure(Sender: TObject;  errorCode: integer) of Object;
TOnAdMobOpened = procedure(Sender: TObject) of Object;
TOnAdMobClosed = procedure(Sender: TObject) of Object;
TOnAdMobLeftApplication = procedure(Sender: TObject) of Object;

{Draft Component code by "Lazarus Android Module Wizard" [12/13/2017 17:22:00]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsAdMob = class(jVisualControl)
 private
    FOnAdMobLoaded:          TOnAdMobLoaded;
    FOnAdMobFailedToLoad:    TOnAdMobFailedToLoad;
    FOnAdMobOpened:          TOnAdMobOpened;
    FOnAdMobClosed:          TOnAdMobClosed;
    FOnAdMobLeftApplication: TOnAdMobLeftApplication;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

    procedure GenEvent_OnClick(Obj: TObject);
    procedure GenEvent_OnAdMobLoaded(Obj: TObject);
    procedure GenEvent_OnAdMobFailedToLoad(Obj: TObject; errorCode: integer);
    procedure GenEvent_OnAdMobOpened(Obj: TObject);
    procedure GenEvent_OnAdMobClosed(Obj: TObject);
    procedure GenEvent_OnAdMobLeftApplication(Obj: TObject);

    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetViewParent(): jObject;  override;
    procedure RemoveFromViewParent(); override;

    procedure AdMobSetId(_admobid: string);
    function  AdMobGetId(): string;
    procedure AdMobInit();
    procedure AdMobFree();
    procedure AdMobRun();

    function GetView(): jObject;  override;
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
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);

 published

    property BackgroundColor: TARGBColorBridge read FColor write SetColor;

    property OnAdMobLoaded      :   TOnAdMobLoaded read FOnAdMobLoaded write FOnAdMobLoaded;
    property OnAdMobFailedToLoad:   TOnAdMobFailedToLoad read FOnAdMobFailedToLoad write FOnAdMobFailedToLoad;
    property OnAdMobOpened      :   TOnAdMobOpened read FOnAdMobOpened write FOnAdMobOpened;
    property OnAdMobClosed      :   TOnAdMobClosed read FOnAdMobClosed write FOnAdMobClosed;
    property OnAdMobLeftApplication  :   TOnAdMobLeftApplication read FOnAdMobLeftApplication write FOnAdMobLeftApplication;


end;

function jsAdMob_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsAdMob_jFree(env: PJNIEnv; _jadmob: JObject);
procedure jsAdMob_SetViewParent(env: PJNIEnv; _jadmob: JObject; _viewgroup: jObject);
function jsAdMob_GetParent(env: PJNIEnv; _jadmob: JObject): jObject;
procedure jsAdMob_RemoveFromViewParent(env: PJNIEnv; _jadmob: JObject);

procedure jsAdMob_AdMobSetId(env: PJNIEnv; _jadmob: JObject; _admobid: string);
function jsAdMob_AdMobGetId(env: PJNIEnv; _jadmob: JObject): string;
procedure jsAdMob_AdMobInit(env: PJNIEnv; _jadmob: JObject);
procedure jsAdMob_AdMobFree(env: PJNIEnv; _jadmob: JObject);
procedure jsAdMob_AdMobRun(env: PJNIEnv; _jadmob: JObject);

function jsAdMob_GetView(env: PJNIEnv; _jadmob: JObject): jObject;
procedure jsAdMob_SetLParamWidth(env: PJNIEnv; _jadmob: JObject; _w: integer);
procedure jsAdMob_SetLParamHeight(env: PJNIEnv; _jadmob: JObject; _h: integer);
function jsAdMob_GetLParamWidth(env: PJNIEnv; _jadmob: JObject): integer;
function jsAdMob_GetLParamHeight(env: PJNIEnv; _jadmob: JObject): integer;
procedure jsAdMob_SetLGravity(env: PJNIEnv; _jadmob: JObject; _g: integer);
procedure jsAdMob_SetLWeight(env: PJNIEnv; _jadmob: JObject; _w: single);
procedure jsAdMob_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jadmob: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsAdMob_AddLParamsAnchorRule(env: PJNIEnv; _jadmob: JObject; _rule: integer);
procedure jsAdMob_AddLParamsParentRule(env: PJNIEnv; _jadmob: JObject; _rule: integer);
procedure jsAdMob_SetLayoutAll(env: PJNIEnv; _jadmob: JObject; _idAnchor: integer);
procedure jsAdMob_ClearLayoutAll(env: PJNIEnv; _jadmob: JObject);
procedure jsAdMob_SetId(env: PJNIEnv; _jadmob: JObject; _id: integer);


implementation

uses
   customdialog, viewflipper, toolbar, scoordinatorlayout,
   sdrawerlayout, scollapsingtoolbarlayout, scardview, sappbarlayout,
   stoolbar, stablayout, snestedscrollview, sviewpager, framelayout, linearlayout;

{---------  jFrameLayout  --------------}

constructor jsAdMob.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 96; //??
  FWidth        := 192; //??
  FLParamWidth  := lpWrapContent;  //lpWrapContent
  FLParamHeight := lpWrapContent;
  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor jsAdMob.Destroy;
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

procedure jsAdMob.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  aWidth, aHeight : DWORD;
begin
  if not FInitialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject:= jCreate(); //jSelf !
   FInitialized:= True;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   jsAdMob_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jsAdMob_SetId(FjEnv, FjObject, Self.Id);
  end;

  if LayoutParamWidth  = lpExact then aWidth  := FWidth  else aWidth  := GetLayoutParams(gApp, FLParamWidth, sdW);
  if LayoutParamHeight = lpExact then aHeight := FHeight else aHeight := GetLayoutParams(gApp, FLParamHeight, sdH);

  jsAdMob_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        aWidth,
                        aHeight);

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jsAdMob_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsAdMob_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsAdMob_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsAdMob.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jsAdMob.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsAdMob.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayoutAll();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jsAdMob.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jsAdMob.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jsAdMob_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jsAdMob_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jsAdMob_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jsAdMob.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jsAdMob.GenEvent_OnAdMobLoaded(Obj: TObject);
begin
  if Assigned(FOnAdMobLoaded) then FOnAdMobLoaded(Obj);
end;

procedure jsAdMob.GenEvent_OnAdMobFailedToLoad(Obj: TObject; errorCode: integer);
begin
  if Assigned(FOnAdMobFailedToLoad) then FOnAdMobFailedToLoad(Obj, errorCode);
end;

procedure jsAdMob.GenEvent_OnAdMobOpened(Obj: TObject);
begin
  if Assigned(FOnAdMobOpened) then FOnAdMobOpened(Obj);
end;

procedure jsAdMob.GenEvent_OnAdMobClosed(Obj: TObject);
begin
  if Assigned(FOnAdMobClosed) then FOnAdMobClosed(Obj);
end;

procedure jsAdMob.GenEvent_OnAdMobLeftApplication(Obj: TObject);
begin
  if Assigned(FOnAdMobLeftApplication) then FOnAdMobLeftApplication(Obj);
end;

function jsAdMob.jCreate(): jObject;
begin
   Result:= jsAdMob_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsAdMob.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_jFree(FjEnv, FjObject);
end;

procedure jsAdMob.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsAdMob.GetViewParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsAdMob_GetParent(FjEnv, FjObject);
end;

procedure jsAdMob.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_RemoveFromViewParent(FjEnv, FjObject);
end;

procedure jsAdMob.AdMobSetId(_admobid: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_AdMobSetId(FjEnv, FjObject, _admobid);
end;

function jsAdMob.AdMobGetId(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsAdMob_AdMobGetId(FjEnv, FjObject);
end;

procedure jsAdMob.AdMobInit();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_AdMobInit(FjEnv, FjObject);
end;

procedure jsAdMob.AdMobFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_AdMobFree(FjEnv, FjObject);
end;

procedure jsAdMob.AdMobRun();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_AdMobRun(FjEnv, FjObject);
end;  

function jsAdMob.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsAdMob_GetView(FjEnv, FjObject);
end;

procedure jsAdMob.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsAdMob.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsAdMob.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsAdMob_GetLParamWidth(FjEnv, FjObject);
end;

function jsAdMob.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsAdMob_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsAdMob.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jsAdMob.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsAdMob.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsAdMob.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsAdMob.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsAdMob.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsAdMob.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jsAdMob.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_SetId(FjEnv, FjObject, _id);
end;

{-------- jsAdMob_JNI_Bridge ----------}

function jsAdMob_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsAdMob_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jsAdMob_jCreate(long _Self) {
  return (java.lang.Object)(new jFrameLayout(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jsAdMob_jFree(env: PJNIEnv; _jadmob: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jadmob, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_SetViewParent(env: PJNIEnv; _jadmob: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsAdMob_GetParent(env: PJNIEnv; _jadmob: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jadmob, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_RemoveFromViewParent(env: PJNIEnv; _jadmob: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jadmob, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsAdMob_AdMobSetId(env: PJNIEnv; _jadmob: JObject; _admobid: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_admobid));
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'AdMobSetId', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jsAdMob_AdMobGetId(env: PJNIEnv; _jadmob: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'AdMobGetId', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jadmob, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsAdMob_AdMobInit(env: PJNIEnv; _jadmob: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'AdMobInit', '()V');
  env^.CallVoidMethod(env, _jadmob, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsAdMob_AdMobFree(env: PJNIEnv; _jadmob: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'AdMobFree', '()V');
  env^.CallVoidMethod(env, _jadmob, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsAdMob_AdMobRun(env: PJNIEnv; _jadmob: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'AdMobRun', '()V');
  env^.CallVoidMethod(env, _jadmob, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsAdMob_GetView(env: PJNIEnv; _jadmob: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jadmob, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_SetLParamWidth(env: PJNIEnv; _jadmob: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_SetLParamHeight(env: PJNIEnv; _jadmob: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsAdMob_GetLParamWidth(env: PJNIEnv; _jadmob: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jadmob, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsAdMob_GetLParamHeight(env: PJNIEnv; _jadmob: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jadmob, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_SetLGravity(env: PJNIEnv; _jadmob: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_SetLWeight(env: PJNIEnv; _jadmob: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jadmob: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_AddLParamsAnchorRule(env: PJNIEnv; _jadmob: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_AddLParamsParentRule(env: PJNIEnv; _jadmob: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_SetLayoutAll(env: PJNIEnv; _jadmob: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_ClearLayoutAll(env: PJNIEnv; _jadmob: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jadmob, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsAdMob_SetId(env: PJNIEnv; _jadmob: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jadmob);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jadmob, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;



end.
