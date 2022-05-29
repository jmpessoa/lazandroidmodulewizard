unit imagebutton;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget, systryparent;

type

{Draft Component code by "LAMW: Lazarus Android Module Wizard" [5/26/2022 15:40:13]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jImageButton = class(jVisualControl)
 private
    FImageName: string;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

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
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);

    procedure SetImage(_image: jObject);
    procedure SetImageByResIdentifier(_imageResIdentifier: string);

 published
    property ImageIdentifier : string read FImageName write SetImageByResIdentifier;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jImageButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jImageButton_jFree(env: PJNIEnv; _jimagebutton: JObject);
procedure jImageButton_SetViewParent(env: PJNIEnv; _jimagebutton: JObject; _viewgroup: jObject);
function jImageButton_GetParent(env: PJNIEnv; _jimagebutton: JObject): jObject;
procedure jImageButton_RemoveFromViewParent(env: PJNIEnv; _jimagebutton: JObject);
function jImageButton_GetView(env: PJNIEnv; _jimagebutton: JObject): jObject;
procedure jImageButton_SetLParamWidth(env: PJNIEnv; _jimagebutton: JObject; _w: integer);
procedure jImageButton_SetLParamHeight(env: PJNIEnv; _jimagebutton: JObject; _h: integer);
function jImageButton_GetLParamWidth(env: PJNIEnv; _jimagebutton: JObject): integer;
function jImageButton_GetLParamHeight(env: PJNIEnv; _jimagebutton: JObject): integer;
procedure jImageButton_SetLGravity(env: PJNIEnv; _jimagebutton: JObject; _g: integer);
procedure jImageButton_SetLWeight(env: PJNIEnv; _jimagebutton: JObject; _w: single);
procedure jImageButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jimagebutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jImageButton_AddLParamsAnchorRule(env: PJNIEnv; _jimagebutton: JObject; _rule: integer);
procedure jImageButton_AddLParamsParentRule(env: PJNIEnv; _jimagebutton: JObject; _rule: integer);
procedure jImageButton_SetLayoutAll(env: PJNIEnv; _jimagebutton: JObject; _idAnchor: integer);
procedure jImageButton_ClearLayoutAll(env: PJNIEnv; _jimagebutton: JObject);
procedure jImageButton_SetId(env: PJNIEnv; _jimagebutton: JObject; _id: integer);
procedure jImageButton_SetImage(env: PJNIEnv; _jimagebutton: JObject; _image: jObject);

implementation

{---------  jImageButton  --------------}

constructor jImageButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

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

destructor jImageButton.Destroy;
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

procedure jImageButton.Init;
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin

 if not FInitialized then
 begin
  inherited Init; //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject := jCreate(); //jSelf !

  if FjObject = nil then exit;

  if FParent <> nil then
   sysTryNewParent( FjPRLayout, FParent);

  FjPRLayoutHome:= FjPRLayout;

  jImageButton_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
  jImageButton_SetId(gApp.jni.jEnv, FjObject, Self.Id);
 end;

  jImageButton_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                        sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jImageButton_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jImageButton_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jImageButton_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

 if not FInitialized then
 begin
  FInitialized := true;

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);

  if (FImageName <> '') then
     SetImageByResIdentifier(FImageName);

 end;
end;

procedure jImageButton.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jImageButton.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jImageButton.UpdateLayout;
begin

  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;

end;

procedure jImageButton.Refresh;
begin
  if FInitialized then
    View_Invalidate(gApp.jni.jEnv, FjObject);
end;

procedure jImageButton.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin

   if not FInitialized then Exit;

  jImageButton_ClearLayoutAll(gApp.jni.jEnv, FjObject );

   for rToP := rpBottom to rpCenterVertical do
      if rToP in FPositionRelativeToParent then
        jImageButton_AddLParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

   for rToA := raAbove to raAlignRight do
     if rToA in FPositionRelativeToAnchor then
       jImageButton_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));

end;

//Event : Java -> Pascal
procedure jImageButton.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jImageButton.jCreate(): jObject;
begin
   Result:= jImageButton_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jImageButton.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jImageButton.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jImageButton.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageButton_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jImageButton.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jImageButton.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageButton_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jImageButton.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jImageButton.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jImageButton.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageButton_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jImageButton.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jImageButton_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jImageButton.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure jImageButton.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jImageButton.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jImageButton.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jImageButton.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jImageButton.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jImageButton.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_ClearLayoutAll(gApp.jni.jEnv, FjObject);
end;

procedure jImageButton.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_SetId(gApp.jni.jEnv, FjObject, _id);
end;

procedure jImageButton.SetImage(_image: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jImageButton_SetImage(gApp.jni.jEnv, FjObject, _image);
end;

procedure jImageButton.SetImageByResIdentifier(_imageResIdentifier: string);
begin
  FImageName:= _imageResIdentifier;

  if FjObject = nil then exit;

  jni_proc_t(gApp.jni.jEnv, FjObject, 'SetImageByResIdentifier', _imageResIdentifier);
end;

{-------- jImageButton_JNI_Bridge ----------}

function jImageButton_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  Result := nil;

  if (env = nil) or (this = nil) then exit;
  jCls:= Get_gjClass(env);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jImageButton_jCreate', '(J)Ljava/lang/Object;');
  if jMethod = nil then goto _exceptionOcurred;

  jParams[0].j:= _Self;

  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);

  Result:= env^.NewGlobalRef(env, Result);

  _exceptionOcurred: if jni_ExceptionOccurred(env) then result := nil;
end;


procedure jImageButton_jFree(env: PJNIEnv; _jimagebutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _jimagebutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_SetViewParent(env: PJNIEnv; _jimagebutton: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _viewgroup;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jImageButton_GetParent(env: PJNIEnv; _jimagebutton: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jimagebutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_RemoveFromViewParent(env: PJNIEnv; _jimagebutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _jimagebutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jImageButton_GetView(env: PJNIEnv; _jimagebutton: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallObjectMethod(env, _jimagebutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_SetLParamWidth(env: PJNIEnv; _jimagebutton: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _w;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_SetLParamHeight(env: PJNIEnv; _jimagebutton: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _h;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jImageButton_GetLParamWidth(env: PJNIEnv; _jimagebutton: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethod(env, _jimagebutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


function jImageButton_GetLParamHeight(env: PJNIEnv; _jimagebutton: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  Result:= env^.CallIntMethod(env, _jimagebutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_SetLGravity(env: PJNIEnv; _jimagebutton: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _g;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_SetLWeight(env: PJNIEnv; _jimagebutton: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].f:= _w;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jimagebutton: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _left;
  jParams[1].i:= _top;
  jParams[2].i:= _right;
  jParams[3].i:= _bottom;
  jParams[4].i:= _w;
  jParams[5].i:= _h;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_AddLParamsAnchorRule(env: PJNIEnv; _jimagebutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _rule;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_AddLParamsParentRule(env: PJNIEnv; _jimagebutton: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _rule;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_SetLayoutAll(env: PJNIEnv; _jimagebutton: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _idAnchor;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_ClearLayoutAll(env: PJNIEnv; _jimagebutton: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  env^.CallVoidMethod(env, _jimagebutton, jMethod);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;


procedure jImageButton_SetId(env: PJNIEnv; _jimagebutton: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].i:= _id;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;

procedure jImageButton_SetImage(env: PJNIEnv; _jimagebutton: JObject; _image: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
label
  _exceptionOcurred;
begin

  if (env = nil) or (_jimagebutton = nil) then exit;
  jCls:= env^.GetObjectClass(env, _jimagebutton);
  if jCls = nil then goto _exceptionOcurred;
  jMethod:= env^.GetMethodID(env, jCls, 'SetImage', '(Landroid/graphics/Bitmap;)V');
  if jMethod = nil then begin env^.DeleteLocalRef(env, jCls); goto _exceptionOcurred; end;

  jParams[0].l:= _image;

  env^.CallVoidMethodA(env, _jimagebutton, jMethod, @jParams);

  env^.DeleteLocalRef(env, jCls);

  _exceptionOcurred: jni_ExceptionOccurred(env);
end;



end.
