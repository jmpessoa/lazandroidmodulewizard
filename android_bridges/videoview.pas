unit videoview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [3/11/2017 15:51:37]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jVideoView = class(jVisualControl)
 private
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
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent();
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
    procedure Pause();
    procedure Resume();
    procedure SeekTo(_position: integer);
    function GetCurrentPosition(): integer;
    procedure SetProgressDialog(_title: string; _waitingMessage: string; _cancelable: boolean);
    procedure PlayFromURL(_url: string);
    procedure PlayFromRawResource(_fileName: string);
    procedure PlayFromSdcard(_fileName: string);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jVideoView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jVideoView_jFree(env: PJNIEnv; _jvideoview: JObject);
procedure jVideoView_SetViewParent(env: PJNIEnv; _jvideoview: JObject; _viewgroup: jObject);
function jVideoView_GetParent(env: PJNIEnv; _jvideoview: JObject): jObject;
procedure jVideoView_RemoveFromViewParent(env: PJNIEnv; _jvideoview: JObject);
function jVideoView_GetView(env: PJNIEnv; _jvideoview: JObject): jObject;
procedure jVideoView_SetLParamWidth(env: PJNIEnv; _jvideoview: JObject; _w: integer);
procedure jVideoView_SetLParamHeight(env: PJNIEnv; _jvideoview: JObject; _h: integer);
function jVideoView_GetLParamWidth(env: PJNIEnv; _jvideoview: JObject): integer;
function jVideoView_GetLParamHeight(env: PJNIEnv; _jvideoview: JObject): integer;
procedure jVideoView_SetLGravity(env: PJNIEnv; _jvideoview: JObject; _g: integer);
procedure jVideoView_SetLWeight(env: PJNIEnv; _jvideoview: JObject; _w: single);
procedure jVideoView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jvideoview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jVideoView_AddLParamsAnchorRule(env: PJNIEnv; _jvideoview: JObject; _rule: integer);
procedure jVideoView_AddLParamsParentRule(env: PJNIEnv; _jvideoview: JObject; _rule: integer);
procedure jVideoView_SetLayoutAll(env: PJNIEnv; _jvideoview: JObject; _idAnchor: integer);
procedure jVideoView_ClearLayoutAll(env: PJNIEnv; _jvideoview: JObject);
procedure jVideoView_SetId(env: PJNIEnv; _jvideoview: JObject; _id: integer);
procedure jVideoView_Pause(env: PJNIEnv; _jvideoview: JObject);
procedure jVideoView_Resume(env: PJNIEnv; _jvideoview: JObject);
procedure jVideoView_SeekTo(env: PJNIEnv; _jvideoview: JObject; _position: integer);
function jVideoView_GetCurrentPosition(env: PJNIEnv; _jvideoview: JObject): integer;
procedure jVideoView_SetProgressDialog(env: PJNIEnv; _jvideoview: JObject; _title: string; _waitingMessage: string; _cancelable: boolean);
procedure jVideoView_PlayFromUrl(env: PJNIEnv; _jvideoview: JObject; _url: string);
procedure jVideoView_PlayFromRawResource(env: PJNIEnv; _jvideoview: JObject; _fileName: string);
procedure jVideoView_PlayFromSdcard(env: PJNIEnv; _jvideoview: JObject; _fileName: string);

implementation

uses
   customdialog, toolbar;

{---------  jVideoView  --------------}

constructor jVideoView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 96; //??
  FWidth        := 96; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor jVideoView.Destroy;
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

procedure jVideoView.Init(refApp: jApp);
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
  jVideoView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jVideoView_SetId(FjEnv, FjObject, Self.Id);
  jVideoView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jVideoView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jVideoView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jVideoView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jVideoView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jVideoView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jVideoView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jVideoView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jVideoView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jVideoView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jVideoView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jVideoView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jVideoView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jVideoView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jVideoView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jVideoView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jVideoView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jVideoView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jVideoView_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jVideoView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jVideoView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jVideoView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jVideoView.jCreate(): jObject;
begin
   Result:= jVideoView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jVideoView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_jFree(FjEnv, FjObject);
end;

procedure jVideoView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jVideoView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jVideoView_GetParent(FjEnv, FjObject);
end;

procedure jVideoView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jVideoView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jVideoView_GetView(FjEnv, FjObject);
end;

procedure jVideoView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jVideoView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jVideoView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jVideoView_GetLParamWidth(FjEnv, FjObject);
end;

function jVideoView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jVideoView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jVideoView.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jVideoView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jVideoView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jVideoView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jVideoView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jVideoView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jVideoView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jVideoView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_SetId(FjEnv, FjObject, _id);
end;

procedure jVideoView.Pause();
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_Pause(FjEnv, FjObject);
end;

procedure jVideoView.Resume();
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_Resume(FjEnv, FjObject);
end;

procedure jVideoView.SeekTo(_position: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_SeekTo(FjEnv, FjObject, _position);
end;

function jVideoView.GetCurrentPosition(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jVideoView_GetCurrentPosition(FjEnv, FjObject);
end;

procedure jVideoView.SetProgressDialog(_title: string; _waitingMessage: string; _cancelable: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_SetProgressDialog(FjEnv, FjObject, _title ,_waitingMessage ,_cancelable);
end;

procedure jVideoView.PlayFromURL(_url: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_PlayFromUrl(FjEnv, FjObject, _url);
end;

procedure jVideoView.PlayFromRawResource(_fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_PlayFromRawResource(FjEnv, FjObject, _fileName);
end;

procedure jVideoView.PlayFromSdcard(_fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jVideoView_PlayFromSdcard(FjEnv, FjObject, _fileName);
end;

{-------- jVideoView_JNI_Bridge ----------}

function jVideoView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jVideoView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jVideoView_jCreate(long _Self) {
  return (java.lang.Object)(new jVideoView(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)

procedure jVideoView_jFree(env: PJNIEnv; _jvideoview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jvideoview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_SetViewParent(env: PJNIEnv; _jvideoview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jVideoView_GetParent(env: PJNIEnv; _jvideoview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jvideoview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_RemoveFromViewParent(env: PJNIEnv; _jvideoview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jvideoview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jVideoView_GetView(env: PJNIEnv; _jvideoview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jvideoview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_SetLParamWidth(env: PJNIEnv; _jvideoview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_SetLParamHeight(env: PJNIEnv; _jvideoview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jVideoView_GetLParamWidth(env: PJNIEnv; _jvideoview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jvideoview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jVideoView_GetLParamHeight(env: PJNIEnv; _jvideoview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jvideoview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_SetLGravity(env: PJNIEnv; _jvideoview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_SetLWeight(env: PJNIEnv; _jvideoview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jvideoview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_AddLParamsAnchorRule(env: PJNIEnv; _jvideoview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_AddLParamsParentRule(env: PJNIEnv; _jvideoview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_SetLayoutAll(env: PJNIEnv; _jvideoview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_ClearLayoutAll(env: PJNIEnv; _jvideoview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jvideoview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_SetId(env: PJNIEnv; _jvideoview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_Pause(env: PJNIEnv; _jvideoview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'Pause', '()V');
  env^.CallVoidMethod(env, _jvideoview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_Resume(env: PJNIEnv; _jvideoview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'Resume', '()V');
  env^.CallVoidMethod(env, _jvideoview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_SeekTo(env: PJNIEnv; _jvideoview: JObject; _position: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _position;
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'SeekTo', '(I)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jVideoView_GetCurrentPosition(env: PJNIEnv; _jvideoview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetCurrentPosition', '()I');
  Result:= env^.CallIntMethod(env, _jvideoview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_SetProgressDialog(env: PJNIEnv; _jvideoview: JObject; _title: string; _waitingMessage: string; _cancelable: boolean);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_waitingMessage));
  jParams[2].z:= JBool(_cancelable);
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetProgressDialog', '(Ljava/lang/String;Ljava/lang/String;Z)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_PlayFromUrl(env: PJNIEnv; _jvideoview: JObject; _url: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_url));
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'PlayFromUrl', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_PlayFromRawResource(env: PJNIEnv; _jvideoview: JObject; _fileName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'PlayFromRawResource', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jVideoView_PlayFromSdcard(env: PJNIEnv; _jvideoview: JObject; _fileName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jvideoview);
  jMethod:= env^.GetMethodID(env, jCls, 'PlayFromSdcard', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jvideoview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

end.
