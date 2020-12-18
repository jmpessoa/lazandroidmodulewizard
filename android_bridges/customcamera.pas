unit customcamera;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent; 

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
    FOnSurfaceChanged: TCustomCameraSurfaceChanged;
    FOnPictureTaken: TCustomCameraPictureTaken;

    FAutoFocusOnShot : boolean;
    FFlashlightMode: TFlashlightMode;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    
    procedure GenEvent_OnClick(Obj: TObject);
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
    procedure ClearLayout();
    procedure TakePicture(); overload;
    procedure TakePicture(_filename: string); overload;

    procedure AutoFocus(); // by tr3e
    procedure SetAutoFocusOnShot( _autoFocusOnShot : boolean ); // by tr3e

    procedure SetEnvironmentStorage(_environmentDir: TEnvDirectory; _folderName: string); overload;
    procedure SetEnvironmentStorage(_environmentDir: TEnvDirectory; _folderName: string; _fileName: string); overload;

    procedure SaveToMediaStore(_title: string; _description: string);
    function GetImage(_width: integer; _height: integer): jObject; overload;
    function GetImage(): jObject; overload;
    procedure SetFlashlight(_flashlightMode: boolean);
    procedure SetFlashlightMode(_flashlightMode: TFlashlightMode);

 published
    property AutoFocusOnShot: boolean read FAutoFocusOnShot write SetAutoFocusOnShot;
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property OnClick: TOnNotify read FOnClick write FOnClick;

    //property OnSurfaceCreated: TCustomCameraSurfaceCreated read FOnSurfaceCreated write FOnSurfaceCreated;
    property OnSurfaceChanged: TCustomCameraSurfaceChanged read FOnSurfaceChanged write FOnSurfaceChanged;
    property OnPictureTaken: TCustomCameraPictureTaken read FOnPictureTaken write FOnPictureTaken;
    property FlashlightMode: TFlashlightMode read FFlashlightMode write SetFlashlightMode;

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
procedure jCustomCamera_surfaceUpdate(env: PJNIEnv; _jcustomcamera: JObject);

procedure jCustomCamera_AutoFocus(env: PJNIEnv; _jcustomcamera: JObject); // by tr3e
procedure jCustomCamera_SetAutoFocusOnShot(env: PJNIEnv; _jcustomcamera: JObject; _value: boolean); // by tr3e
procedure jCustomCamera_SetFlashlight(env: PJNIEnv; _jcustomcamera: JObject; _flashlightMode: boolean);
implementation

{---------  jCustomCamera  --------------}

constructor jCustomCamera.Create(AOwner: TComponent);
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

  FAutoFocusOnShot := False; // by tr3e
  FFlashlightMode:= fmOFF;

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

procedure jCustomCamera.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if not FInitialized  then
  begin
   inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
   //your code here: set/initialize create params....
   FjObject := jCreate(); if FjObject = nil then exit;

   if FParent <> nil then
    sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

   FjPRLayoutHome:= FjPRLayout;

   jCustomCamera_SetViewParent(FjEnv, FjObject, FjPRLayout);
   jCustomCamera_SetId(FjEnv, FjObject, Self.Id);
  end;

  jCustomCamera_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));
                  
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

  jCustomCamera_SetAutoFocusOnShot(FjEnv, FjObject, FAutoFocusOnShot);

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jCustomCamera_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(FjEnv, FjObject, FVisible);

   if FFlashlightMode = fmON then
      jCustomCamera_SetFlashlight(FjEnv, FjObject, True);


  end;
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

procedure jCustomCamera.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jCustomCamera.Refresh;
begin
  if FInitialized then
  begin
    jCustomCamera_surfaceUpdate( FjEnv, FjObject );

    View_Invalidate(FjEnv, FjObject);
  end;
end;

//Event : Java -> Pascal
procedure jCustomCamera.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
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

procedure jCustomCamera.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jCustomCamera_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jCustomCamera_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jCustomCamera_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
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

// by tr3e
procedure jCustomCamera.AutoFocus();
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_AutoFocus(FjEnv, FjObject);
end;

// by tr3e
procedure jCustomCamera.SetAutoFocusOnShot( _autoFocusOnShot: boolean );
begin
  //in designing component state: set value here...
  FAutoFocusOnShot := _autoFocusOnShot;

  if FInitialized then
     jCustomCamera_SetAutoFocusOnShot(FjEnv, FjObject, _autoFocusOnShot);
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

procedure jCustomCamera.SetFlashlight(_flashlightMode: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jCustomCamera_SetFlashlight(FjEnv, FjObject, _flashlightMode);
end;

procedure jCustomCamera.SetFlashlightMode(_flashlightMode: TFlashlightMode);
begin
  //in designing component state: set value here...
  FFlashlightMode:= _flashlightMode;
  if FInitialized then
  begin
     if FFlashlightMode = fmON then
       jCustomCamera_SetFlashlight(FjEnv, FjObject, True)
     else
       jCustomCamera_SetFlashlight(FjEnv, FjObject, False);
  end;
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
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
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

// by tr3e
procedure jCustomCamera_AutoFocus(env: PJNIEnv; _jcustomcamera: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'cameraAutoFocus', '()V');
  env^.CallVoidMethod(env, _jcustomcamera, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

// by tr3e
procedure jCustomCamera_SetAutoFocusOnShot(env: PJNIEnv; _jcustomcamera: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'cameraSetAutoFocusOnShot', '(Z)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jCustomCamera_surfaceUpdate(env: PJNIEnv; _jcustomcamera: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'surfaceUpdate', '()V');
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

procedure jCustomCamera_SetFlashlight(env: PJNIEnv; _jcustomcamera: JObject; _flashlightMode: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_flashlightMode);
  jCls:= env^.GetObjectClass(env, _jcustomcamera);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFlashlight', '(Z)V');
  env^.CallVoidMethodA(env, _jcustomcamera, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;



end.
