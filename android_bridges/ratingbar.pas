unit ratingbar;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/22/2015 21:11:14]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

TOnRatingChanged = procedure(Sender: TObject; rating: single) of Object;

{jVisualControl template}

jRatingBar = class(jVisualControl)
 private
    FNumStars: integer;
    FRating: single; // number of stars filled..
    FStep: single;  //The step size of this rating bar. For example, if half-star granularity is wanted, this would be 0.5

    FOnRatingChanged: TOnRatingChanged;
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

    procedure GenEvent_OnRatingBarChanged(Obj: TObject; rating: single);

    function jCreate( _numStars: integer; _step: single): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject);  override;
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
    function GetRating(): single;
    procedure SetRating(_rating: single);
    procedure SetNumStars(_numStars: integer);
    function GetNumStars(): integer;
    function GetStepSize(): single;
    procedure SetStepSize(_step: single);
    procedure SetIsIndicator(_isIndicator: boolean);
    procedure SetMax(_max: integer);
    function IsIndicator(): boolean;

 published
    property NumStars: integer read FNumStars write SetNumStars;
    property Step: single read FStep write SetStepSize;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnRatingChanged: TOnRatingChanged read FOnRatingChanged write FOnRatingChanged;

end;

function jRatingBar_jCreate(env: PJNIEnv;_Self: int64; _numStars: integer; _step: single; this: jObject): jObject;
procedure jRatingBar_jFree(env: PJNIEnv; _jratingbar: JObject);
procedure jRatingBar_SetViewParent(env: PJNIEnv; _jratingbar: JObject; _viewgroup: jObject);
procedure jRatingBar_RemoveFromViewParent(env: PJNIEnv; _jratingbar: JObject);
function jRatingBar_GetView(env: PJNIEnv; _jratingbar: JObject): jObject;
procedure jRatingBar_SetLParamWidth(env: PJNIEnv; _jratingbar: JObject; _w: integer);
procedure jRatingBar_SetLParamHeight(env: PJNIEnv; _jratingbar: JObject; _h: integer);
procedure jRatingBar_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jratingbar: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jRatingBar_AddLParamsAnchorRule(env: PJNIEnv; _jratingbar: JObject; _rule: integer);
procedure jRatingBar_AddLParamsParentRule(env: PJNIEnv; _jratingbar: JObject; _rule: integer);
procedure jRatingBar_SetLayoutAll(env: PJNIEnv; _jratingbar: JObject; _idAnchor: integer);
procedure jRatingBar_ClearLayoutAll(env: PJNIEnv; _jratingbar: JObject);
procedure jRatingBar_SetId(env: PJNIEnv; _jratingbar: JObject; _id: integer);
function jRatingBar_GetRating(env: PJNIEnv; _jratingbar: JObject): single;
procedure jRatingBar_SetRating(env: PJNIEnv; _jratingbar: JObject; _rating: single);
procedure jRatingBar_SetNumStars(env: PJNIEnv; _jratingbar: JObject; _numStars: integer);
function jRatingBar_GetNumStars(env: PJNIEnv; _jratingbar: JObject): integer;
function jRatingBar_GetStepSize(env: PJNIEnv; _jratingbar: JObject): single;
procedure jRatingBar_SetStepSize(env: PJNIEnv; _jratingbar: JObject; _step: single);
procedure jRatingBar_SetIsIndicator(env: PJNIEnv; _jratingbar: JObject; _isIndicator: boolean);
procedure jRatingBar_SetMax(env: PJNIEnv; _jratingbar: JObject; _max: integer);
function jRatingBar_IsIndicator(env: PJNIEnv; _jratingbar: JObject): boolean;



implementation

uses
   customdialog, toolbar;

{---------  jRatingBar  --------------}

constructor jRatingBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FHeight       := 48; //??
  FWidth        := 96; //??
  FLParamWidth  := lpOneThirdOfParent;  //lpWrapContent
  FLParamHeight := lpWrapContent;
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FNumStars:= 5;
  FRating:= 0; // number of stars filled..
  FStep:= 0.5;  //The step size of this rating bar. For example, if half-star granularity is wanted, this would be 0.5

end;

destructor jRatingBar.Destroy;
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

procedure jRatingBar.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(FnumStars, FStep); //jSelf !
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
  jRatingBar_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jRatingBar_SetId(FjEnv, FjObject, Self.Id);
  jRatingBar_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jRatingBar_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jRatingBar_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jRatingBar_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jRatingBar.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jRatingBar.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jRatingBar.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jRatingBar_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
          jRatingBar_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
       else //lpMatchParent or others
          jRatingBar_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jRatingBar.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jRatingBar_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
         jRatingBar_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
         jRatingBar_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jRatingBar.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jRatingBar_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jRatingBar.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jRatingBar.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jRatingBar_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jRatingBar_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jRatingBar_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal

procedure jRatingBar.GenEvent_OnRatingBarChanged(Obj: TObject; rating: single);
begin
  if Assigned(FOnRatingChanged) then FOnRatingChanged(Obj, rating);
end;

function jRatingBar.jCreate( _numStars: integer; _step: single): jObject;
begin
   Result:= jRatingBar_jCreate(FjEnv, int64(Self) ,_numStars, _step,  FjThis);
end;

procedure jRatingBar.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_jFree(FjEnv, FjObject);
end;

procedure jRatingBar.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jRatingBar.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_RemoveFromViewParent(FjEnv, FjObject);
end;

function jRatingBar.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRatingBar_GetView(FjEnv, FjObject);
end;

procedure jRatingBar.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jRatingBar.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jRatingBar.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jRatingBar.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jRatingBar.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jRatingBar.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jRatingBar.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jRatingBar.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_SetId(FjEnv, FjObject, _id);
end;

function jRatingBar.GetRating(): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRatingBar_GetRating(FjEnv, FjObject);
end;

procedure jRatingBar.SetRating(_rating: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_SetRating(FjEnv, FjObject, _rating);
end;

procedure jRatingBar.SetNumStars(_numStars: integer);
begin
  //in designing component state: set value here...
  FNumStars:= _numStars;
  if FInitialized then
     jRatingBar_SetNumStars(FjEnv, FjObject, _numStars);
end;

function jRatingBar.GetNumStars(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRatingBar_GetNumStars(FjEnv, FjObject);
end;

function jRatingBar.GetStepSize(): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRatingBar_GetStepSize(FjEnv, FjObject);
end;

procedure jRatingBar.SetStepSize(_step: single);
begin
  //in designing component state: set value here...
  FStep:= _step;
  if FInitialized then
     jRatingBar_SetStepSize(FjEnv, FjObject, _step);
end;

procedure jRatingBar.SetIsIndicator(_isIndicator: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_SetIsIndicator(FjEnv, FjObject, _isIndicator);
end;

procedure jRatingBar.SetMax(_max: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jRatingBar_SetMax(FjEnv, FjObject, _max);
end;

function jRatingBar.IsIndicator(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jRatingBar_IsIndicator(FjEnv, FjObject);
end;

{-------- jRatingBar_JNI_Bridge ----------}
function jRatingBar_jCreate(env: PJNIEnv;_Self: int64; _numStars: integer; _step: single; this: jObject): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].i:= _numStars;
  jParams[2].f:= _step;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jRatingBar_jCreate', '(JIF)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;
(*
//Please, you need insert:

    public java.lang.Object jRatingBar_jCreate(long _Self,  int _numStars, float _step) {
	      return (java.lang.Object)(new jRatingBar(this,_Self,_numStars,_step));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jRatingBar_jFree(env: PJNIEnv; _jratingbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jratingbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetViewParent(env: PJNIEnv; _jratingbar: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_RemoveFromViewParent(env: PJNIEnv; _jratingbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jratingbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jRatingBar_GetView(env: PJNIEnv; _jratingbar: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jratingbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetLParamWidth(env: PJNIEnv; _jratingbar: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetLParamHeight(env: PJNIEnv; _jratingbar: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jratingbar: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_AddLParamsAnchorRule(env: PJNIEnv; _jratingbar: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_AddLParamsParentRule(env: PJNIEnv; _jratingbar: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetLayoutAll(env: PJNIEnv; _jratingbar: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_ClearLayoutAll(env: PJNIEnv; _jratingbar: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jratingbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetId(env: PJNIEnv; _jratingbar: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jRatingBar_GetRating(env: PJNIEnv; _jratingbar: JObject): single;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetRating', '()F');
  Result:= env^.CallFloatMethod(env, _jratingbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetRating(env: PJNIEnv; _jratingbar: JObject; _rating: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _rating;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRating', '(F)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetNumStars(env: PJNIEnv; _jratingbar: JObject; _numStars: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _numStars;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetNumStars', '(I)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jRatingBar_GetNumStars(env: PJNIEnv; _jratingbar: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNumStars', '()I');
  Result:= env^.CallIntMethod(env, _jratingbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jRatingBar_GetStepSize(env: PJNIEnv; _jratingbar: JObject): single;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'GetStepSize', '()F');
  Result:= env^.CallFloatMethod(env, _jratingbar, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetStepSize(env: PJNIEnv; _jratingbar: JObject; _step: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _step;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetStepSize', '(F)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetIsIndicator(env: PJNIEnv; _jratingbar: JObject; _isIndicator: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_isIndicator);
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIsIndicator', '(Z)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jRatingBar_SetMax(env: PJNIEnv; _jratingbar: JObject; _max: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _max;
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMax', '(I)V');
  env^.CallVoidMethodA(env, _jratingbar, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jRatingBar_IsIndicator(env: PJNIEnv; _jratingbar: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jratingbar);
  jMethod:= env^.GetMethodID(env, jCls, 'IsIndicator', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jratingbar, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


end.
