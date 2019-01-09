unit linearlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

 TLinearLayoutOrientation = (loHorizontal, loVertical);
{Draft Component code by "Lazarus Android Module Wizard" [12/17/2017 1:52:22]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jLinearLayout = class(jVisualControl)
 private
    FOrientation: TLinearLayoutOrientation;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;

    procedure ClearLayout();
    procedure UpdateLayout; override;

    //procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetViewParent(): jObject; override;
    procedure RemoveFromViewParent();  override;
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    function GetWidth(): integer; override;
    function GetHeight(): integer; override;
    procedure SetLGravity(_gravity: TLayoutGravity);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);

    procedure SetId(_id: integer);
    procedure SetOrientation(_orientation: TLinearLayoutOrientation);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Orientation: TLinearLayoutOrientation read FOrientation write SetOrientation;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    //property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jLinearLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jLinearLayout_jFree(env: PJNIEnv; _jlinearlayout: JObject);
procedure jLinearLayout_SetViewParent(env: PJNIEnv; _jlinearlayout: JObject; _viewgroup: jObject);
function jLinearLayout_GetParent(env: PJNIEnv; _jlinearlayout: JObject): jObject;
procedure jLinearLayout_RemoveFromViewParent(env: PJNIEnv; _jlinearlayout: JObject);
function jLinearLayout_GetView(env: PJNIEnv; _jlinearlayout: JObject): jObject;
procedure jLinearLayout_SetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject; _w: integer);
procedure jLinearLayout_SetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject; _h: integer);
function jLinearLayout_GetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject): integer;
function jLinearLayout_GetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject): integer;
procedure jLinearLayout_SetLGravity(env: PJNIEnv; _jlinearlayout: JObject; _g: integer);
procedure jLinearLayout_SetLWeight(env: PJNIEnv; _jlinearlayout: JObject; _w: single);
procedure jLinearLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jlinearlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jLinearLayout_AddLParamsAnchorRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
procedure jLinearLayout_AddLParamsParentRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
procedure jLinearLayout_SetLayoutAll(env: PJNIEnv; _jlinearlayout: JObject; _idAnchor: integer);
procedure jLinearLayout_ClearLayoutAll(env: PJNIEnv; _jlinearlayout: JObject);
procedure jLinearLayout_SetId(env: PJNIEnv; _jlinearlayout: JObject; _id: integer);
procedure jLinearLayout_SetOrientation(env: PJNIEnv; _jlinearlayout: JObject; _orientation: integer);


implementation

{---------  jLinearLayout  --------------}

constructor jLinearLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 0;
  FMarginTop    := 0;
  FMarginBottom := 0;
  FMarginRight  := 0;
  FHeight       := 96; //??
  FWidth        := 192; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;
//your code here....
 //FOrientation:= loHorizontal;
end;

destructor jLinearLayout.Destroy;
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

procedure jLinearLayout.Init(refApp: jApp);
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

   if FOrientation <> loHorizontal then
       jLinearLayout_SetOrientation(FjEnv, FjObject, Ord(FOrientation));

   if FGravityInParent <> lgNone then
     jLinearLayout_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent) );

   jLinearLayout_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jLinearLayout_SetId(FjEnv, FjObject, Self.Id);
  end;

  jLinearLayout_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jLinearLayout_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jLinearLayout_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jLinearLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   
   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(FjEnv, FjObject, FVisible);
  end;
end;

procedure jLinearLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jLinearLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jLinearLayout.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jLinearLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

(*
//Event : Java -> Pascal
procedure jLinearLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jLinearLayout.jCreate(): jObject;
begin
   Result:= jLinearLayout_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jLinearLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_jFree(FjEnv, FjObject);
end;

procedure jLinearLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jLinearLayout.GetViewParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLinearLayout_GetParent(FjEnv, FjObject);
end;

procedure jLinearLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_RemoveFromViewParent(FjEnv, FjObject);
end;

function jLinearLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLinearLayout_GetView(FjEnv, FjObject);
end;

procedure jLinearLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jLinearLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jLinearLayout.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  Result:= jLinearLayout_getLParamWidth(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetWidthOfParent(FParent); 
end;

function jLinearLayout.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  Result:= jLinearLayout_getLParamHeight(FjEnv, FjObject );

  if Result = -1 then //lpMatchParent
    Result := sysGetHeightOfParent(FParent);
end;

procedure jLinearLayout.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FInitialized then
     jLinearLayout_SetLGravity(FjEnv, FjObject, Ord(_gravity) );
end;

procedure jLinearLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jLinearLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jLinearLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jLinearLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jLinearLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jLinearLayout.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jLinearLayout_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jLinearLayout_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jLinearLayout_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jLinearLayout.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetId(FjEnv, FjObject, _id);
end;

procedure jLinearLayout.SetOrientation(_orientation: TLinearLayoutOrientation);
begin
  //in designing component state: set value here...
  FOrientation:= _orientation;
  if FInitialized then
     jLinearLayout_SetOrientation(FjEnv, FjObject, Ord(FOrientation));
end;

{-------- jLinearLayout_JNI_Bridge ----------}

function jLinearLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jLinearLayout_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jLinearLayout_jCreate(long _Self) {
  return (java.lang.Object)(new jLinearLayout(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jLinearLayout_jFree(env: PJNIEnv; _jlinearlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetViewParent(env: PJNIEnv; _jlinearlayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetParent(env: PJNIEnv; _jlinearlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_RemoveFromViewParent(env: PJNIEnv; _jlinearlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetView(env: PJNIEnv; _jlinearlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLGravity(env: PJNIEnv; _jlinearlayout: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLWeight(env: PJNIEnv; _jlinearlayout: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jlinearlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_AddLParamsAnchorRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_AddLParamsParentRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLayoutAll(env: PJNIEnv; _jlinearlayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_ClearLayoutAll(env: PJNIEnv; _jlinearlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetId(env: PJNIEnv; _jlinearlayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetOrientation(env: PJNIEnv; _jlinearlayout: JObject; _orientation: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _orientation;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetOrientation', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;



end.
