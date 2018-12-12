unit customcamera;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TCustomCameraSurfaceCreated = Procedure(Sender: TObject) of object;
TCustomCameraSurfaceChanged = Procedure(Sender: TObject; width: integer; height: integer) of object;
TCustomCameraPictureTaken = Procedure(Sender: TObject; bitmapPicture: jObject; fullPath: string) of object;

{Draft Component code by "Lazarus Android Module Wizard" [4/18/2018 16:53:34]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

{ jCustomCamera }

jCustomCamera = class(jVisualControl)
 private
    FColor: TARGBColorBridge;
    FOnClick: TOnNotify;

    //FOnSurfaceCreated: TCustomCameraSurfaceCreated;
    FOnSurfaceChanged: TCustomCameraSurfaceChanged;
    FOnPictureTaken: TCustomCameraPictureTaken;

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
    procedure GenEvent_OnCustomCameraSurfaceCreated(Obj: TObject);
    procedure GenEvent_OnCustomCameraSurfaceChanged(Obj: TObject; width: integer; height: integer);
    procedure GenEvent_OnCustomCameraPictureTaken(Obj: TObject; picture: jObject; fullPath: string);

    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject);  override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent();  override;
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
    procedure TakePicture(); overload;
    procedure TakePicture(_filename: string); overload;

    procedure SetEnvironmentStorage(_environmentDir: TEnvDirectory; _folderName: string); overload;
    procedure SetEnvironmentStorage(_environmentDir: TEnvDirectory; _folderName: string; _fileName: string); overload;

    procedure SaveToMediaStore(_title: string; _description: string);
    function GetImage(_width: integer; _height: integer): jObject; overload;
    function GetImage(): jObject; overload;


 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;
    //property OnSurfaceCreated: TCustomCameraSurfaceCreated read FOnSurfaceCreated write FOnSurfaceCreated;
    property OnSurfaceChanged: TCustomCameraSurfaceChanged read FOnSurfaceChanged write FOnSurfaceChanged;
    property OnPictureTaken: TCustomCameraPictureTaken read FOnPictureTaken write FOnPictureTaken;

end;

function jCustomCamera_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jCustomCamera_jFree(env: PJNIEnv; _jcustomcamera: JObject);
procedure jCustomCamera_SetViewParent(env: PJNIEnv; _jcustomcamera: JObject; _viewgroup: jObject);
function jCustomCamera_GetParent(env: PJNIEnv; _jcustomcamera: JObject): jObject;
procedure jCustomCamera_RemoveFromViewParent(env: PJNIEnv; _jcustomcamera: JObject);
function jCustomCamera_GetView(env: PJNIEnv; _jcustomcamera: JObject): jObject;
procedure jCustomCamera_SetLParamWidth(env: PJNIEnv; _jcustomcamera: JObject; _w: integer);
procedure jCustomCamera_SetLParamHeight(env: PJNIEnv; _jcustomcamera: JObject; _h: integer);
function jCustomCamera_GetLParamWidth(env: PJNIEnv; _jcustomcamera: JObject): integer;
function jCustomCamera_GetLParamHeight(env: PJNIEnv; _jcustomcamera: JObject): integer;
procedure jCustomCamera_SetLGravity(env: PJNIEnv; _jcustomcamera: JObject; _g: integer);
procedure jCustomCamera_SetLWeight(env: PJNIEnv; _jcustomcamera: JObject; _w: single);
procedure jCustomCamera_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcustomcamera: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jCustomCamera_AddLParamsAnchorRule(env: PJNIEnv; _jcustomcamera: JObject; _rule: integer);
procedure jCustomCamera_AddLParamsParentRule(env: PJNIEnv; _jcustomcamera: JObject; _rule: integer);
procedure jCustomCamera_SetLayoutAll(env: PJNIEnv; _jcustomcamera: JObject; _idAnchor: integer);
procedure jCustomCamera_ClearLayoutAll(env: PJNIEnv; _jcustomcamera: JObject);
procedure jCustomCamera_SetId(env: PJNIEnv; _jcustomcamera: JObject; _id: integer);
procedure jCustomCamera_TakePicture(env: PJNIEnv; _jcustomcamera: JObject); overload;
procedure jCustomCamera_TakePicture(env: PJNIEnv; _jcustomcamera: JObject; _filename: string); overload;
procedure jCustomCamera_SetEnvironmentStorage(env: PJNIEnv; _jcustomcamera: JObject; _environmentDir: integer; _folderName: string); overload;
procedure jCustomCamera_SetEnvironmentStorage(env: PJNIEnv; _jcustomcamera: JObject; _environmentDir: integer; _folderName: string; _fileName: string); overload;
procedure jCustomCamera_SaveToMediaStore(env: PJNIEnv; _jcustomcamera: JObject; _title: string; _description: string);
function jCustomCamera_GetImage(env: PJNIEnv; _jcustomcamera: JObject; _width: integer; _height: integer): jObject; overload;
function jCustomCamera_GetImage(env: PJNIEnv; _jcustomcamera: JObject): jObject; overload;

implementation

uses
   customdialog, viewflipper, toolbar, scoordinatorlayout, linearlayout,
   sdrawerlayout, scollapsingtoolbarlayout, scardview, sappbarlayout,
   stoolbar, stablayout, snestedscrollview, sviewpager, framelayout;

{---------  jCustomCamera  --------------}

constructor jCustomCamera.Create(AOwner: TComponent);
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

destructor jCustomCamera.Destroy;
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

procedure jCustomCamera.TryNewParent(refApp: jApp);
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
  end else
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
  end else
  if FParent is jsToolbar then
  begin
    jsToolbar(FParent).Init(refApp);
    FjPRLayout:= jsToolbar(FParent).View;
  end else
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
  end else
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

procedure jCustomCamera.Init(refApp: jApp);
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

  jCustomCamera_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jCustomCamera_SetId(FjEnv, FjObject, Self.Id);
  jCustomCamera_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jCustomCamera_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jCustomCamera_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jCustomCamera_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jCustomCamera.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jCustomCamera.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jCustomCamera.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jCustomCamera_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jCustomCamera_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jCustomCamera_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jCustomCamera.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jCustomCamera_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jCustomCamera_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jCustomCamera_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jCustomCamera.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jCustomCamera_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jCustomCamera.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jCustomCamera.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jCustomCamera_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jCustomCamera_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jCustomCamera_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
procedure jCustomCamera.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

procedure jCustomCamera.GenEvent_OnCustomCameraSurfaceCreated(Obj: TObject);
begin
  //if Assigned(FOnSurfaceCreated) then FOnSurfaceCreated(Obj);
end;

procedure jCustomCamera.GenEvent_OnCustomCameraSurfaceChanged(Obj: TObject;
  width: integer; height: integer);
begin
   if Assigned(FOnSurfaceChanged) then FOnSurfaceChanged(Obj, width, height);
end;

procedure jCustomCamera.GenEvent_OnCustomCameraPictureTaken(Obj: TObject; picture: jObject; fullPath: string);
begin
   if Assigned(FOnPictureTaken) then FOnPictureTaken(Obj, picture, fullPath);
end;

function jCustomCamera.jCreate(): jObject;
begin
   Result:= jCustomCamera_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jCustomCamera.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_jFree(FjEnv, FjObject);
end;

procedure jCustomCamera.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jCustomCamera.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCustomCamera_GetParent(FjEnv, FjObject);
end;

procedure jCustomCamera.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_RemoveFromViewParent(FjEnv, FjObject);
end;

function jCustomCamera.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCustomCamera_GetView(FjEnv, FjObject);
end;

procedure jCustomCamera.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jCustomCamera.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jCustomCamera.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCustomCamera_GetLParamWidth(FjEnv, FjObject);
end;

function jCustomCamera.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCustomCamera_GetLParamHeight(FjEnv, FjObject);
end;

procedure jCustomCamera.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jCustomCamera.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jCustomCamera.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jCustomCamera.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jCustomCamera.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jCustomCamera.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jCustomCamera.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jCustomCamera.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetId(FjEnv, FjObject, _id);
end;

procedure jCustomCamera.TakePicture();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_TakePicture(FjEnv, FjObject);
end;

procedure jCustomCamera.TakePicture(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_TakePicture(FjEnv, FjObject, _filename);
end;

procedure jCustomCamera.SetEnvironmentStorage(_environmentDir: TEnvDirectory; _folderName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetEnvironmentStorage(FjEnv, FjObject, Ord(_environmentDir) ,_folderName);
end;

procedure jCustomCamera.SetEnvironmentStorage(_environmentDir: TEnvDirectory; _folderName: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetEnvironmentStorage(FjEnv, FjObject, Ord(_environmentDir) ,_folderName ,_fileName);
end;

procedure jCustomCamera.SaveToMediaStore(_title: string; _description: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SaveToMediaStore(FjEnv, FjObject, _title ,_description);
end;

function jCustomCamera.GetImage(_width: integer; _height: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCustomCamera_GetImage(FjEnv, FjObject, _width ,_height);
end;

function jCustomCamera.GetImage(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jCustomCamera_GetImage(FjEnv, FjObject);
end;

{-------- jCustomCamera_JNI_Bridge ----------}

function jCustomCamera_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jCustomCamera_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jCustomCamera_jFree(env: PJNIEnv; _jcustomcamera: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcustomcamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_SetViewParent(env: PJNIEnv; _jcustomcamera: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jCustomCamera_GetParent(env: PJNIEnv; _jcustomcamera: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jcustomcamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_RemoveFromViewParent(env: PJNIEnv; _jcustomcamera: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jcustomcamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jCustomCamera_GetView(env: PJNIEnv; _jcustomcamera: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jcustomcamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_SetLParamWidth(env: PJNIEnv; _jcustomcamera: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_SetLParamHeight(env: PJNIEnv; _jcustomcamera: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jCustomCamera_GetLParamWidth(env: PJNIEnv; _jcustomcamera: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jcustomcamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jCustomCamera_GetLParamHeight(env: PJNIEnv; _jcustomcamera: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jcustomcamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_SetLGravity(env: PJNIEnv; _jcustomcamera: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_SetLWeight(env: PJNIEnv; _jcustomcamera: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcustomcamera: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_AddLParamsAnchorRule(env: PJNIEnv; _jcustomcamera: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_AddLParamsParentRule(env: PJNIEnv; _jcustomcamera: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_SetLayoutAll(env: PJNIEnv; _jcustomcamera: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_ClearLayoutAll(env: PJNIEnv; _jcustomcamera: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jcustomcamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jCustomCamera_SetId(env: PJNIEnv; _jcustomcamera: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomCamera_TakePicture(env: PJNIEnv; _jcustomcamera: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'TakePicture', '()V');
  env^.CallVoidMethod(env, _jcustomcamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomCamera_SetEnvironmentStorage(env: PJNIEnv; _jcustomcamera: JObject; _environmentDir: integer; _folderName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _environmentDir;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_folderName));
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetEnvironmentStorage', '(ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomCamera_TakePicture(env: PJNIEnv; _jcustomcamera: JObject; _filename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'TakePicture', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomCamera_SetEnvironmentStorage(env: PJNIEnv; _jcustomcamera: JObject; _environmentDir: integer; _folderName: string; _fileName: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _environmentDir;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_folderName));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetEnvironmentStorage', '(ILjava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomCamera_SaveToMediaStore(env: PJNIEnv; _jcustomcamera: JObject; _title: string; _description: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_description));
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToMediaStore', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jCustomCamera_GetImage(env: PJNIEnv; _jcustomcamera: JObject; _width: integer; _height: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _width;
  jParams[1].i:= _height;
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'GetImage', '(II)Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jCustomCamera_GetImage(env: PJNIEnv; _jcustomcamera: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'GetImage', '()Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethod(env, _jcustomcamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
