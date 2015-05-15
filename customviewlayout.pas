unit customviewlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [5/10/2015 22:35:02]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jCustomViewLayout = class(jVisualControl)
 private
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

 protected
    //procedure SetParentComponent(Value: TComponent); override;

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
    procedure SetViewParent(_viewgroup: jObject);
    procedure RemoveFromViewParent();
    function GetView(): jObject;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);
    procedure Show();
    procedure Hide();

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jCustomViewLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jCustomViewLayout_jFree(env: PJNIEnv; _jcustomviewlayout: JObject);
procedure jCustomViewLayout_SetViewParent(env: PJNIEnv; _jcustomviewlayout: JObject; _viewgroup: jObject);
procedure jCustomViewLayout_RemoveFromViewParent(env: PJNIEnv; _jcustomviewlayout: JObject);
function jCustomViewLayout_GetView(env: PJNIEnv; _jcustomviewlayout: JObject): jObject;
procedure jCustomViewLayout_SetLParamWidth(env: PJNIEnv; _jcustomviewlayout: JObject; _w: integer);
procedure jCustomViewLayout_SetLParamHeight(env: PJNIEnv; _jcustomviewlayout: JObject; _h: integer);
procedure jCustomViewLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcustomviewlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jCustomViewLayout_AddLParamsAnchorRule(env: PJNIEnv; _jcustomviewlayout: JObject; _rule: integer);
procedure jCustomViewLayout_AddLParamsParentRule(env: PJNIEnv; _jcustomviewlayout: JObject; _rule: integer);
procedure jCustomViewLayout_SetLayoutAll(env: PJNIEnv; _jcustomviewlayout: JObject; _idAnchor: integer);
procedure jCustomViewLayout_ClearLayoutAll(env: PJNIEnv; _jcustomviewlayout: JObject);
procedure jCustomViewLayout_SetId(env: PJNIEnv; _jcustomviewlayout: JObject; _id: integer);
procedure jCustomViewLayout_Show(env: PJNIEnv; _jcustomviewlayout: JObject);
procedure jCustomViewLayout_Hide(env: PJNIEnv; _jcustomviewlayout: JObject);


implementation

{---------  jCustomViewLayout  --------------}

constructor jCustomViewLayout.Create(AOwner: TComponent);
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
  FAcceptChildrenAtDesignTime:= True;
//your code here....
  FVisible:= False;
end;

{
procedure jCustomViewLayout.SetParentComponent(Value: TComponent);
begin
  inherited SetParentComponent(Value);
  Self.Height:= 48; //??
  Self.Width:= 96; //??
  if Value <> nil then
  begin
    Parent:= TAndroidWidget(Value);
    Self.Width:= Trunc(TAndroidWidget(Parent).Width) - 13; //??
  end;
end;
 }

destructor jCustomViewLayout.Destroy;
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

procedure jCustomViewLayout.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;

 // FjRLayout{View}:= jCustomViewLayout_GetView(FjEnv, FjObject ); //Java Self Layout


  jCustomViewLayout_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jCustomViewLayout_SetId(FjEnv, FjObject, Self.Id);
  jCustomViewLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        GetLayoutParams(gApp, FLParamWidth, sdW),
                        GetLayoutParams(gApp, FLParamHeight, sdH));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jCustomViewLayout_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;

  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jCustomViewLayout_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jCustomViewLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jCustomViewLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jCustomViewLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jCustomViewLayout.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdW else side:= sdH;
      jCustomViewLayout_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpMatchParent then
        jCustomViewLayout_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdW))
      else if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jCustomViewLayout_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, sdW))
      else
        jCustomViewLayout_SetLParamWidth(FjEnv, FjObject, GetLayoutParamsByParent(Self.Parent, FLParamWidth, sdW))
    end;
  end;
end;

procedure jCustomViewLayout.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).Orientation = gApp.Orientation then side:= sdH else side:= sdW;
      jCustomViewLayout_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpMatchParent then
        jCustomViewLayout_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdH))
      else if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jCustomViewLayout_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, sdH))
      else
        jCustomViewLayout_SetLParamHeight(FjEnv, FjObject, GetLayoutParamsByParent(Self.Parent, FLParamHeight, sdH))
    end;
  end;
end;

procedure jCustomViewLayout.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jCustomViewLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jCustomViewLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jCustomViewLayout.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jCustomViewLayout_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jCustomViewLayout_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jCustomViewLayout_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jCustomViewLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jCustomViewLayout.jCreate(): jObject;
begin
   Result:= jCustomViewLayout_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jCustomViewLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_jFree(FjEnv, FjObject);
end;

procedure jCustomViewLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jCustomViewLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_RemoveFromViewParent(FjEnv, FjObject);
end;

function jCustomViewLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCustomViewLayout_GetView(FjEnv, FjObject);
end;

procedure jCustomViewLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jCustomViewLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jCustomViewLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jCustomViewLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jCustomViewLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jCustomViewLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jCustomViewLayout.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jCustomViewLayout.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_SetId(FjEnv, FjObject, _id);
end;

procedure jCustomViewLayout.Show();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_Show(FjEnv, FjObject);
end;

procedure jCustomViewLayout.Hide();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomViewLayout_Hide(FjEnv, FjObject);
end;

{-------- jCustomViewLayout_JNI_Bridge ----------}

function jCustomViewLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jCustomViewLayout_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jCustomViewLayout_jCreate(long _Self) {
      return (java.lang.Object)(new jCustomViewLayout(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jCustomViewLayout_jFree(env: PJNIEnv; _jcustomviewlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcustomviewlayout, jMethod);
end;


procedure jCustomViewLayout_SetViewParent(env: PJNIEnv; _jcustomviewlayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jcustomviewlayout, jMethod, @jParams);
end;


procedure jCustomViewLayout_RemoveFromViewParent(env: PJNIEnv; _jcustomviewlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jcustomviewlayout, jMethod);
end;


function jCustomViewLayout_GetView(env: PJNIEnv; _jcustomviewlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jcustomviewlayout, jMethod);
end;


procedure jCustomViewLayout_SetLParamWidth(env: PJNIEnv; _jcustomviewlayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jcustomviewlayout, jMethod, @jParams);
end;


procedure jCustomViewLayout_SetLParamHeight(env: PJNIEnv; _jcustomviewlayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jcustomviewlayout, jMethod, @jParams);
end;


procedure jCustomViewLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcustomviewlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jcustomviewlayout, jMethod, @jParams);
end;


procedure jCustomViewLayout_AddLParamsAnchorRule(env: PJNIEnv; _jcustomviewlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jcustomviewlayout, jMethod, @jParams);
end;


procedure jCustomViewLayout_AddLParamsParentRule(env: PJNIEnv; _jcustomviewlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jcustomviewlayout, jMethod, @jParams);
end;


procedure jCustomViewLayout_SetLayoutAll(env: PJNIEnv; _jcustomviewlayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jcustomviewlayout, jMethod, @jParams);
end;


procedure jCustomViewLayout_ClearLayoutAll(env: PJNIEnv; _jcustomviewlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jcustomviewlayout, jMethod);
end;


procedure jCustomViewLayout_SetId(env: PJNIEnv; _jcustomviewlayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jcustomviewlayout, jMethod, @jParams);
end;


procedure jCustomViewLayout_Show(env: PJNIEnv; _jcustomviewlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '()V');
  env^.CallVoidMethod(env, _jcustomviewlayout, jMethod);
end;


procedure jCustomViewLayout_Hide(env: PJNIEnv; _jcustomviewlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomviewlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'Hide', '()V');
  env^.CallVoidMethod(env, _jcustomviewlayout, jMethod);
end;



end.
