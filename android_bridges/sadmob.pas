unit sadmob;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/13/2017 17:22:00]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsAdMob = class(jVisualControl)
 private
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
    procedure TryNewParent(refApp: jApp);
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
    function GetViewParent(): jObject;  override;
    procedure RemoveFromViewParent(); override;
    procedure SetAdMobId(_admobid: string);
    function  GetAdMobId(): string;
    //procedure InitAdMob();
    procedure Run();
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

end;

function jsAdMob_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsAdMob_jFree(env: PJNIEnv; _jadmob: JObject);
procedure jsAdMob_SetViewParent(env: PJNIEnv; _jadmob: JObject; _viewgroup: jObject);
function jsAdMob_GetParent(env: PJNIEnv; _jadmob: JObject): jObject;
procedure jsAdMob_RemoveFromViewParent(env: PJNIEnv; _jadmob: JObject);
procedure jsAdMob_AdMobSetId(env: PJNIEnv; _jadmob: JObject; _admobid: string);
function jsAdMob_AdMobGetId(env: PJNIEnv; _jadmob: JObject): string;
//procedure jsAdMob_AdMobInit(env: PJNIEnv; _jadmob: JObject);
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

procedure jsAdMob.TryNewParent(refApp: jApp);
begin
  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end else
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
  end else
  if FParent is jHorizontalScrollView then
  begin
    jHorizontalScrollView(FParent).Init(refApp);
    FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
  end  else
  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end else
  if FParent is jViewFlipper then
  begin
    jViewFlipper(FParent).Init(refApp);
    FjPRLayout:= jViewFlipper(FParent).View;
  end else
  if FParent is jToolbar then
  begin
    jToolbar(FParent).Init(refApp);
    FjPRLayout:= jToolbar(FParent).View;
  end  else
  if FParent is jsToolbar then
  begin
    jsToolbar(FParent).Init(refApp);
    FjPRLayout:= jsToolbar(FParent).View;
  end  else
  if FParent is jsCoordinatorLayout then
  begin
    jsCoordinatorLayout(FParent).Init(refApp);
    FjPRLayout:= jsCoordinatorLayout(FParent).View;
  end else
  if FParent is jFrameLayout then
  begin
    jFrameLayout(FParent).Init(refApp);
    FjPRLayout:= jFrameLayout(FParent).View;
  end else
  if FParent is jLinearLayout then
  begin
    jLinearLayout(FParent).Init(refApp);
    FjPRLayout:= jLinearLayout(FParent).View;
  end else
  if FParent is jsDrawerLayout then
  begin
    jsDrawerLayout(FParent).Init(refApp);
    FjPRLayout:= jsDrawerLayout(FParent).View;
  end  else
  if FParent is jsCardView then
  begin
      jsCardView(FParent).Init(refApp);
      FjPRLayout:= jsCardView(FParent).View;
  end else
  if FParent is jsAppBarLayout then
  begin
      jsAppBarLayout(FParent).Init(refApp);
      FjPRLayout:= jsAppBarLayout(FParent).View;
  end else
  if FParent is jsTabLayout then
  begin
      jsTabLayout(FParent).Init(refApp);
      FjPRLayout:= jsTabLayout(FParent).View;
  end else
  if FParent is jsCollapsingToolbarLayout then
  begin
      jsCollapsingToolbarLayout(FParent).Init(refApp);
      FjPRLayout:= jsCollapsingToolbarLayout(FParent).View;
  end else
  if FParent is jsNestedScrollView then
  begin
      jsNestedScrollView(FParent).Init(refApp);
      FjPRLayout:= jsNestedScrollView(FParent).View;
  end else
  if FParent is jsViewPager then
  begin
      jsViewPager(FParent).Init(refApp);
      FjPRLayout:= jsViewPager(FParent).View;
  end;
end;

procedure jsAdMob.Init(refApp: jApp);
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
    TryNewParent(refApp);
  end;

  FjPRLayoutHome:= FjPRLayout;

  jsAdMob_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsAdMob_SetId(FjEnv, FjObject, Self.Id);
  jsAdMob_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
procedure jsAdMob.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jsAdMob_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsAdMob_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsAdMob_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsAdMob.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jsAdMob_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsAdMob_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsAdMob_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsAdMob.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsAdMob_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
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

procedure jsAdMob.SetAdMobId(_admobid: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_AdMobSetId(FjEnv, FjObject, _admobid);
end;

function jsAdMob.GetAdMobId(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsAdMob_AdMobGetId(FjEnv, FjObject);
end;

{
procedure jsAdMob.AdMobInit();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsAdMob_AdMobInit(FjEnv, FjObject);
end;
}

procedure jsAdMob.Run();
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

{
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
}

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
