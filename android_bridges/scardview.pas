unit scardview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/20/2017 21:49:51]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsCardView = class(jVisualControl)
 private
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    //procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
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
    procedure ClearLayout();
    procedure SetCardElevation(_elevation: single);
    procedure SetContentPadding(_left: integer; _top: integer; _right: integer; _bottom: integer);
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetRadius(_radius: single);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;

end;

function jsCardView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;

implementation

{---------  jsCardView  --------------}

constructor jsCardView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 4;
  FMarginTop    := 4;
  FMarginBottom := 4;
  FMarginRight  := 4;
  FHeight       := 96; //??
  FWidth        := 192; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;
//your code here....
end;

destructor jsCardView.Destroy;
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

procedure jsCardView.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject := jCreate(); if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent);

   FjPRLayoutHome:= FjPRLayout;

   if FGravityInParent <> lgNone then
    View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(FGravityInParent));

   View_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   View_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  View_setLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
    if rToA in FPositionRelativeToAnchor then
      View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));

  for rToP := rpBottom to rpCenterVertical do
    if rToP in FPositionRelativeToParent then
      View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  View_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;
   
   if FColor <> colbrDefault then
    SetColor(FColor);

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jsCardView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
       jni_proc_i(gApp.jni.jEnv, FjObject, 'SetCardBackgroundColor', GetARGB(FCustomColor, FColor));
end;

procedure jsCardView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jsCardView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jsCardView.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

//Event : Java -> Pascal
(*
procedure jsCardView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jsCardView.jCreate(): jObject;
begin
   Result:= jsCardView_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jsCardView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc(gApp.jni.jEnv, FjObject, 'jFree');
end;

procedure jsCardView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jsCardView.GetParent(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jsCardView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     View_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jsCardView.GetView(): jObject;
begin
  Result := nil;
  //in designing component state: result value here...
  if FInitialized then
   Result:= View_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jsCardView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsCardView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jsCardView.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
   Result := sysGetWidthOfParent(FParent)
  else
   Result:= View_getLParamWidth(gApp.jni.jEnv, FjObject );
end;

function jsCardView.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
   Result := sysGetHeightOfParent(FParent)
  else
   Result:= View_getLParamHeight(gApp.jni.jEnv, FjObject );
end;

procedure jsCardView.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FInitialized then
     View_SetLGravity(gApp.jni.jEnv, FjObject, Ord(_gravity));
end;

procedure jsCardView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jsCardView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsCardView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsCardView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jsCardView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     View_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jsCardView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     View_ClearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          View_addlParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         View_addlParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jsCardView.SetCardElevation(_elevation: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_f(gApp.jni.jEnv, FjObject, 'SetCardElevation', _elevation);
end;


procedure jsCardView.SetContentPadding(_left: integer; _top: integer; _right: integer; _bottom: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_iiii(gApp.jni.jEnv, FjObject, 'SetContentPadding', _left ,_top ,_right ,_bottom);
end;

procedure jsCardView.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_z(gApp.jni.jEnv, FjObject, 'SetFitsSystemWindows', _value);
end;

procedure jsCardView.SetRadius(_radius: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jni_proc_f(gApp.jni.jEnv, FjObject, 'SetRadius', _radius);
end;

{-------- jsCardView_JNI_Bridge ----------}

function jsCardView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsCardView_jCreate', '(J)Ljava/lang/Object;');

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);
end;

end.
