unit gl2surfaceview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent;

type

TPrimitiveMode = (glPoints=0,
                    glLines=1,
                    glLineLoop=2,
                    glLineStrip=3,
                    glTriangles=4,
                    glTriangleStrip=5,
                    glTriangleFan=6);

TOnSurfaceChanged = procedure(Sender: TObject; width: integer; height: integer) of object;

{Draft Component code by "Lazarus Android Module Wizard" [11/19/2017 21:48:25]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jGL2SurfaceView = class(jVisualControl)
 private
    FOnTouchDown : TOnTouchExtended;
    FOnTouchMove : TOnTouchExtended;
    FOnTouchUp   : TOnTouchExtended;

    FOnSurfaceCreate: TOnNotify;
    FOnSurfaceChanged:  TOnSurfaceChanged;
    FOnSurfaceDrawFrame: TOnNotify;
    FOnSurfaceDestroyed: TOnNotify;

    //FMinZoomFactor: single;
    //FMaxZoomFactor: single;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init; override;
    procedure Refresh;

    procedure ClearLayout();
    procedure UpdateLayout; override;

    //procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetParent(): jObject;
    procedure RemoveFromViewParent();  override;
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
    procedure Pause();
    procedure Resume();
    function GetByteBufferFromByteArray(var _values: TDynArrayOfJByte): jObject;
    function GetFloatBufferFromFloatArray(var _values: TDynArrayOfSingle): jObject;
    function GetIntBufferFromIntArray(var _values: TDynArrayOfInteger): jObject;
    function GetShortBufferFromShortArray(var _values: TDynArrayOfSmallint): jObject;
    procedure ClearColor(red: single; green: single; blue: single; alpha: single);
    function LoadVertexShader(_vShaderCode: string): integer;
    function LoadFragmentShader(_fShaderCode: string): integer;
    procedure SetViewPort(_width: integer; _height: integer);
    procedure Clear();
    function CreateProgramShader(_handleVertexShader: integer; _handleFragmentShader: integer; _bindAttribDelimitedList: string): integer;
    procedure SetProjectionMatrix(var _matrix: TDynArrayOfSingle);
    procedure SetViewMatrix(var _matrix: TDynArrayOfSingle);
    procedure SetMVPMatrix(var _matrix: TDynArrayOfSingle);

    procedure SetOrthoM_Projection(_left: single; _right: single; _bottom: single; _top: single; _near: single; _far: single);
    procedure SetLookAtM_View(_eyeX: single; _eyeY: single; _eyeZ: single; _centerX: single; _centerY: single; _centerZ: single; _upX: single; _upY: single; _upZ: single);
    procedure MultiplyMM_MVP_Project_View();

    procedure DrawElements(_primitiveMode: TPrimitiveMode; indicesLength: integer; _drawListBuffer: jObject; _bindDataCount: integer; _bindTextureHandle: integer); overload;
    function PrepareTexture(_programShader: integer; _uvBuffer: jObject; _vec2TextureCoord: string; _sampler2DTexture: string; _bitmap: jObject; _textureID: integer; _textureIndex: integer): integer;
    function PrepareVertex(_programShader: integer; _vertexBuffer: jObject; _uMVP: string; var _attribArrayDataSize: TDynArrayOfInteger): integer;
    function GenTexturesIDs(_count: integer): TDynArrayOfInteger;
    function GetMaxTextureUnits(): integer;
    procedure RequestRender();

    procedure GenEvent_OnGL2SurfaceCreate(Obj: TObject);
    procedure GenEvent_OnGL2SurfaceDestroyed(Obj: TObject);

    procedure GenEvent_OnGL2SurfaceChanged(Obj: TObject;  width: integer; height: integer);
    procedure GenEvent_OnGL2SurfaceDrawFrame(Obj: TObject);
    Procedure GenEvent_OnGL2SurfaceTouch(Obj: TObject; Act, Cnt: integer; X,Y: array of Single;
                                 fligGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnSurfaceCreate: TOnNotify  read FOnSurfaceCreate write FOnSurfaceCreate;
    property OnSurfaceDestroyed: TOnNotify  read FOnSurfaceDestroyed write FOnSurfaceDestroyed;
    property OnSurfaceChanged:  TOnSurfaceChanged  read FOnSurfaceChanged write FOnSurfaceChanged;
    property OnSurfaceDrawFrame: TOnNotify  read FOnSurfaceDrawFrame write FOnSurfaceDrawFrame;
    property OnTouchDown: TOnTouchExtended read FOnTouchDown write FOnTouchDown;
    property OnTouchMove: TOnTouchExtended read FOnTouchMove write FOnTouchMove;
    property OnTouchUp: TOnTouchExtended read FOnTouchUp write FOnTouchUp;
end;

function jGL2SurfaceView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jGL2SurfaceView_jFree(env: PJNIEnv; _jgl2surfaceview: JObject);
procedure jGL2SurfaceView_SetViewParent(env: PJNIEnv; _jgl2surfaceview: JObject; _viewgroup: jObject);
function jGL2SurfaceView_GetParent(env: PJNIEnv; _jgl2surfaceview: JObject): jObject;
procedure jGL2SurfaceView_RemoveFromViewParent(env: PJNIEnv; _jgl2surfaceview: JObject);
function jGL2SurfaceView_GetView(env: PJNIEnv; _jgl2surfaceview: JObject): jObject;
procedure jGL2SurfaceView_SetLParamWidth(env: PJNIEnv; _jgl2surfaceview: JObject; _w: integer);
procedure jGL2SurfaceView_SetLParamHeight(env: PJNIEnv; _jgl2surfaceview: JObject; _h: integer);
function jGL2SurfaceView_GetLParamWidth(env: PJNIEnv; _jgl2surfaceview: JObject): integer;
function jGL2SurfaceView_GetLParamHeight(env: PJNIEnv; _jgl2surfaceview: JObject): integer;
procedure jGL2SurfaceView_SetLGravity(env: PJNIEnv; _jgl2surfaceview: JObject; _g: integer);
procedure jGL2SurfaceView_SetLWeight(env: PJNIEnv; _jgl2surfaceview: JObject; _w: single);
procedure jGL2SurfaceView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jgl2surfaceview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jGL2SurfaceView_AddLParamsAnchorRule(env: PJNIEnv; _jgl2surfaceview: JObject; _rule: integer);
procedure jGL2SurfaceView_AddLParamsParentRule(env: PJNIEnv; _jgl2surfaceview: JObject; _rule: integer);
procedure jGL2SurfaceView_SetLayoutAll(env: PJNIEnv; _jgl2surfaceview: JObject; _idAnchor: integer);
procedure jGL2SurfaceView_ClearLayoutAll(env: PJNIEnv; _jgl2surfaceview: JObject);
procedure jGL2SurfaceView_SetId(env: PJNIEnv; _jgl2surfaceview: JObject; _id: integer);
procedure jGL2SurfaceView_Pause(env: PJNIEnv; _jgl2surfaceview: JObject);
procedure jGL2SurfaceView_Resume(env: PJNIEnv; _jgl2surfaceview: JObject);

function jGL2SurfaceView_GetByteBufferFromByteArray(env: PJNIEnv; _jgl2surfaceview: JObject; var _values: TDynArrayOfJByte): jObject;
function jGL2SurfaceView_GetFloatBufferFromFloatArray(env: PJNIEnv; _jgl2surfaceview: JObject; var _values: TDynArrayOfSingle): jObject;
function jGL2SurfaceView_GetIntBufferFromIntArray(env: PJNIEnv; _jgl2surfaceview: JObject; var _values: TDynArrayOfInteger): jObject;
function jGL2SurfaceView_GetShortBufferFromShortArray(env: PJNIEnv; _jgl2surfaceview: JObject; var _values: TDynArrayOfSmallint): jObject;
procedure jGL2SurfaceView_ClearColor(env: PJNIEnv; _jgl2surfaceview: JObject; red: single; green: single; blue: single; alpha: single);
function jGL2SurfaceView_LoadVertexShader(env: PJNIEnv; _jgl2surfaceview: JObject; _vShaderCode: string): integer;
function jGL2SurfaceView_LoadFragmentShader(env: PJNIEnv; _jgl2surfaceview: JObject; _fShaderCode: string): integer;

function jGL2SurfaceView_CreateProgramShader(env: PJNIEnv; _jgl2surfaceview: JObject; _handleVertexShader: integer; _handleFragmentShader: integer; _bindAttribDelimitedList: string): integer;

procedure jGL2SurfaceView_SetViewPort(env: PJNIEnv; _jgl2surfaceview: JObject; _width: integer; _height: integer);
procedure jGL2SurfaceView_Clear(env: PJNIEnv; _jgl2surfaceview: JObject);

procedure jGL2SurfaceView_SetProjectionMatrix(env: PJNIEnv; _jgl2surfaceview: JObject; var _matrix: TDynArrayOfSingle);
procedure jGL2SurfaceView_SetViewMatrix(env: PJNIEnv; _jgl2surfaceview: JObject; var _matrix: TDynArrayOfSingle);
procedure jGL2SurfaceView_SetMVPMatrix(env: PJNIEnv; _jgl2surfaceview: JObject; var _matrix: TDynArrayOfSingle);

procedure jGL2SurfaceView_SetOrthoM_Projection(env: PJNIEnv; _jgl2surfaceview: JObject; _left: single; _right: single; _bottom: single; _top: single; _near: single; _far: single);
procedure jGL2SurfaceView_SetLookAtM_View(env: PJNIEnv; _jgl2surfaceview: JObject; _eyeX: single; _eyeY: single; _eyeZ: single; _centerX: single; _centerY: single; _centerZ: single; _upX: single; _upY: single; _upZ: single);
procedure jGL2SurfaceView_MultiplyMM_MVP_Project_View(env: PJNIEnv; _jgl2surfaceview: JObject);

procedure jGL2SurfaceView_DrawElements(env: PJNIEnv; _jgl2surfaceview: JObject; _mode: integer; indicesLength: integer; _drawListBuffer: jObject; _bindDataCount: integer; _bindTextureHandle: integer);
function jGL2SurfaceView_PrepareTexture(env: PJNIEnv; _jgl2surfaceview: JObject; _programShader: integer; _uvBuffer: jObject; _vec2TextureCoord: string; _sampler2DTexture: string; _bitmap: jObject; _textureID: integer; _textureIndex: integer): integer;
function jGL2SurfaceView_PrepareVertex(env: PJNIEnv; _jgl2surfaceview: JObject; _program: integer; _vertexBuffer: jObject; _uMVP: string; var _attribArrayDataSize: TDynArrayOfInteger): integer;
function jGL2SurfaceView_GenTexturesIDs(env: PJNIEnv; _jgl2surfaceview: JObject; _count: integer): TDynArrayOfInteger;

function jGL2SurfaceView_GetMaxTextureUnits(env: PJNIEnv; _jgl2surfaceview: JObject): integer;
procedure jGL2SurfaceView_RequestRender(env: PJNIEnv; _jgl2surfaceview: JObject);



implementation

{---------  jGL2SurfaceView  --------------}

constructor jGL2SurfaceView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FHeight       := 96; //??
  FWidth        := 100; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
end;

destructor jGL2SurfaceView.Destroy;
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

procedure jGL2SurfaceView.Init;
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

   jGL2SurfaceView_SetViewParent(gApp.jni.jEnv, FjObject, FjPRLayout);
   jGL2SurfaceView_SetId(gApp.jni.jEnv, FjObject, Self.Id);
  end;

  jGL2SurfaceView_setLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jGL2SurfaceView_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jGL2SurfaceView_AddLParamsParentRule(gApp.jni.jEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jGL2SurfaceView_SetLayoutAll(gApp.jni.jEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
   FInitialized:= True;

   if  FColor <> colbrDefault then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));

   View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
  end;
end;

procedure jGL2SurfaceView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(gApp.jni.jEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jGL2SurfaceView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(gApp.jni.jEnv, FjObject, FVisible);
end;

procedure jGL2SurfaceView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init;
end;

procedure jGL2SurfaceView.Refresh;
begin
  if FInitialized then
  begin
     jGL2SurfaceView_RequestRender(gApp.jni.jEnv, FjObject);
     //View_Invalidate(gApp.jni.jEnv, FjObject);  not for openGL
  end
end;

//Event : Java -> Pascal
{
procedure jGL2SurfaceView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
}
function jGL2SurfaceView.jCreate(): jObject;
begin
   Result:= jGL2SurfaceView_jCreate(gApp.jni.jEnv, int64(Self), gApp.jni.jThis);
end;

procedure jGL2SurfaceView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_jFree(gApp.jni.jEnv, FjObject);
end;

procedure jGL2SurfaceView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetViewParent(gApp.jni.jEnv, FjObject, _viewgroup);
end;

function jGL2SurfaceView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_GetParent(gApp.jni.jEnv, FjObject);
end;

procedure jGL2SurfaceView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_RemoveFromViewParent(gApp.jni.jEnv, FjObject);
end;

function jGL2SurfaceView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_GetView(gApp.jni.jEnv, FjObject);
end;

procedure jGL2SurfaceView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetLParamWidth(gApp.jni.jEnv, FjObject, _w);
end;

procedure jGL2SurfaceView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetLParamHeight(gApp.jni.jEnv, FjObject, _h);
end;

function jGL2SurfaceView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_GetLParamWidth(gApp.jni.jEnv, FjObject);
end;

function jGL2SurfaceView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_GetLParamHeight(gApp.jni.jEnv, FjObject);
end;

procedure jGL2SurfaceView.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetLGravity(gApp.jni.jEnv, FjObject, _g);
end;

procedure jGL2SurfaceView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetLWeight(gApp.jni.jEnv, FjObject, _w);
end;

procedure jGL2SurfaceView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetLeftTopRightBottomWidthHeight(gApp.jni.jEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jGL2SurfaceView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_AddLParamsAnchorRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jGL2SurfaceView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_AddLParamsParentRule(gApp.jni.jEnv, FjObject, _rule);
end;

procedure jGL2SurfaceView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetLayoutAll(gApp.jni.jEnv, FjObject, _idAnchor);
end;

procedure jGL2SurfaceView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jGL2SurfaceView_clearLayoutAll(gApp.jni.jEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jGL2SurfaceView_addlParamsParentRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jGL2SurfaceView_addlParamsAnchorRule(gApp.jni.jEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

procedure jGL2SurfaceView.Pause();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_Pause(gApp.jni.jEnv, FjObject);
end;

procedure jGL2SurfaceView.Resume();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_Resume(gApp.jni.jEnv, FjObject);
end;


function jGL2SurfaceView.GetByteBufferFromByteArray(var _values: TDynArrayOfJByte): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_GetByteBufferFromByteArray(gApp.jni.jEnv, FjObject, _values);
end;

function jGL2SurfaceView.GetFloatBufferFromFloatArray(var _values: TDynArrayOfSingle): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_GetFloatBufferFromFloatArray(gApp.jni.jEnv, FjObject, _values);
end;

function jGL2SurfaceView.GetIntBufferFromIntArray(var _values: TDynArrayOfInteger): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_GetIntBufferFromIntArray(gApp.jni.jEnv, FjObject, _values);
end;

function jGL2SurfaceView.GetShortBufferFromShortArray(var _values: TDynArrayOfSmallint): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_GetShortBufferFromShortArray(gApp.jni.jEnv, FjObject, _values);
end;

procedure jGL2SurfaceView.ClearColor(red: single; green: single; blue: single; alpha: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_ClearColor(gApp.jni.jEnv, FjObject, red ,green ,blue ,alpha);
end;

function jGL2SurfaceView.LoadVertexShader(_vShaderCode: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_LoadVertexShader(gApp.jni.jEnv, FjObject, _vShaderCode);
end;

function jGL2SurfaceView.LoadFragmentShader(_fShaderCode: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_LoadFragmentShader(gApp.jni.jEnv, FjObject, _fShaderCode);
end;

function jGL2SurfaceView.CreateProgramShader(_handleVertexShader: integer; _handleFragmentShader: integer; _bindAttribDelimitedList: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_CreateProgramShader(gApp.jni.jEnv, FjObject, _handleVertexShader ,_handleFragmentShader ,_bindAttribDelimitedList);
end;

procedure jGL2SurfaceView.SetViewPort(_width: integer; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetViewPort(gApp.jni.jEnv, FjObject, _width ,_height);
end;

procedure jGL2SurfaceView.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_Clear(gApp.jni.jEnv, FjObject);
end;


procedure jGL2SurfaceView.SetProjectionMatrix(var _matrix: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetProjectionMatrix(gApp.jni.jEnv, FjObject, _matrix);
end;

procedure jGL2SurfaceView.SetViewMatrix(var _matrix: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetViewMatrix(gApp.jni.jEnv, FjObject, _matrix);
end;

procedure jGL2SurfaceView.SetMVPMatrix(var _matrix: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetMVPMatrix(gApp.jni.jEnv, FjObject, _matrix);
end;

procedure jGL2SurfaceView.SetOrthoM_Projection(_left: single; _right: single; _bottom: single; _top: single; _near: single; _far: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetOrthoM_Projection(gApp.jni.jEnv, FjObject, _left ,_right ,_bottom ,_top ,_near ,_far);
end;

procedure jGL2SurfaceView.SetLookAtM_View(_eyeX: single; _eyeY: single; _eyeZ: single; _centerX: single; _centerY: single; _centerZ: single; _upX: single; _upY: single; _upZ: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_SetLookAtM_View(gApp.jni.jEnv, FjObject, _eyeX ,_eyeY ,_eyeZ ,_centerX ,_centerY ,_centerZ ,_upX ,_upY ,_upZ);
end;

procedure jGL2SurfaceView.MultiplyMM_MVP_Project_View();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_MultiplyMM_MVP_Project_View(gApp.jni.jEnv, FjObject);
end;

function jGL2SurfaceView.GenTexturesIDs(_count: integer): TDynArrayOfInteger;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_GenTexturesIDs(gApp.jni.jEnv, FjObject, _count);
end;

function jGL2SurfaceView.GetMaxTextureUnits(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_GetMaxTextureUnits(gApp.jni.jEnv, FjObject);
end;

procedure jGL2SurfaceView.RequestRender();
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_RequestRender(gApp.jni.jEnv, FjObject);
end;

procedure jGL2SurfaceView.GenEvent_OnGL2SurfaceCreate(Obj: TObject);
begin
  if Assigned(FOnSurfaceCreate) then FOnSurfaceCreate(Obj);
end;

procedure jGL2SurfaceView.GenEvent_OnGL2SurfaceDestroyed(Obj: TObject);
begin
  if Assigned(FOnSurfaceDestroyed) then FOnSurfaceDestroyed(Obj);
end;

procedure jGL2SurfaceView.GenEvent_OnGL2SurfaceChanged(Obj: TObject;  width: integer; height: integer);
begin
  if Assigned(FOnSurfaceChanged) then FOnSurfaceChanged(Obj, width, height);
end;

procedure jGL2SurfaceView.GenEvent_OnGL2SurfaceDrawFrame(Obj: TObject);
begin
  if Assigned(FOnSurfaceDrawFrame) then FOnSurfaceDrawFrame(Obj);
end;

Procedure jGL2SurfaceView.GenEvent_OnGL2SurfaceTouch(Obj: TObject; Act, Cnt: integer; X,Y: array of single;
                             fligGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);
begin
  case Act of
   cTouchDown : begin
                   if Assigned(FOnTouchDown) then
                      FOnTouchDown(Obj,Cnt,X,Y,TFlingGesture(fligGesture),TPinchZoomScaleState(pinchZoomGestureState),zoomScaleFactor)
                end;
   cTouchMove : begin
                   if Assigned(FOnTouchMove) then
                      FOnTouchMove(Obj,Cnt,X,Y,TFlingGesture(fligGesture), TPinchZoomScaleState(pinchZoomGestureState),zoomScaleFactor)
                end;
   cTouchUp   : begin
                   if Assigned(FOnTouchUp) then
                      FOnTouchUp(Obj,Cnt,X,Y,TFlingGesture(fligGesture), TPinchZoomScaleState(pinchZoomGestureState),zoomScaleFactor)
                end;
  end;
end;


procedure jGL2SurfaceView.DrawElements(_primitiveMode: TPrimitiveMode; indicesLength: integer; _drawListBuffer: jObject; _bindDataCount: integer; _bindTextureHandle: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jGL2SurfaceView_DrawElements(gApp.jni.jEnv, FjObject, Ord(_primitiveMode) ,indicesLength ,_drawListBuffer ,_bindDataCount ,_bindTextureHandle);
end;

function jGL2SurfaceView.PrepareTexture(_programShader: integer; _uvBuffer: jObject; _vec2TextureCoord: string; _sampler2DTexture: string; _bitmap: jObject; _textureID: integer; _textureIndex: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_PrepareTexture(gApp.jni.jEnv, FjObject, _programShader ,_uvBuffer ,_vec2TextureCoord ,_sampler2DTexture ,_bitmap ,_textureID ,_textureIndex);
end;

function jGL2SurfaceView.PrepareVertex(_programShader: integer; _vertexBuffer: jObject; _uMVP: string; var _attribArrayDataSize: TDynArrayOfInteger): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jGL2SurfaceView_PrepareVertex(gApp.jni.jEnv, FjObject, _programShader ,_vertexBuffer ,_uMVP ,_attribArrayDataSize);
end;

{-------- jGL2SurfaceView_JNI_Bridge ----------}

function jGL2SurfaceView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jGL2SurfaceView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jGL2SurfaceView_jCreate(long _Self) {
  return (java.lang.Object)(new jGL2SurfaceView(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jGL2SurfaceView_jFree(env: PJNIEnv; _jgl2surfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_SetViewParent(env: PJNIEnv; _jgl2surfaceview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_GetParent(env: PJNIEnv; _jgl2surfaceview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_RemoveFromViewParent(env: PJNIEnv; _jgl2surfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_GetView(env: PJNIEnv; _jgl2surfaceview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_SetLParamWidth(env: PJNIEnv; _jgl2surfaceview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_SetLParamHeight(env: PJNIEnv; _jgl2surfaceview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_GetLParamWidth(env: PJNIEnv; _jgl2surfaceview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_GetLParamHeight(env: PJNIEnv; _jgl2surfaceview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_SetLGravity(env: PJNIEnv; _jgl2surfaceview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_SetLWeight(env: PJNIEnv; _jgl2surfaceview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jgl2surfaceview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_AddLParamsAnchorRule(env: PJNIEnv; _jgl2surfaceview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_AddLParamsParentRule(env: PJNIEnv; _jgl2surfaceview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_SetLayoutAll(env: PJNIEnv; _jgl2surfaceview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_ClearLayoutAll(env: PJNIEnv; _jgl2surfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_SetId(env: PJNIEnv; _jgl2surfaceview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_Pause(env: PJNIEnv; _jgl2surfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'Pause', '()V');
  env^.CallVoidMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_Resume(env: PJNIEnv; _jgl2surfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'Resume', '()V');
  env^.CallVoidMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jGL2SurfaceView_GetByteBufferFromByteArray(env: PJNIEnv; _jgl2surfaceview: JObject; var _values: TDynArrayOfJByte): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_values);
  jNewArray0:= env^.NewByteArray(env, newSize0);  // allocate
  env^.SetByteArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetByteBufferFromByteArray', '([B)Ljava/nio/ByteBuffer;');
  Result:= env^.CallObjectMethodA(env, _jgl2surfaceview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_GetFloatBufferFromFloatArray(env: PJNIEnv; _jgl2surfaceview: JObject; var _values: TDynArrayOfSingle): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_values);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetFloatBufferFromFloatArray', '([F)Ljava/nio/FloatBuffer;');
  Result:= env^.CallObjectMethodA(env, _jgl2surfaceview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_GetIntBufferFromIntArray(env: PJNIEnv; _jgl2surfaceview: JObject; var _values: TDynArrayOfInteger): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_values);
  jNewArray0:= env^.NewIntArray(env, newSize0);  // allocate
  env^.SetIntArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetIntBufferFromIntArray', '([I)Ljava/nio/IntBuffer;');
  Result:= env^.CallObjectMethodA(env, _jgl2surfaceview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_GetShortBufferFromShortArray(env: PJNIEnv; _jgl2surfaceview: JObject; var _values: TDynArrayOfSmallint): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_values);
  jNewArray0:= env^.NewShortArray(env, newSize0);  // allocate
  env^.SetShortArrayRegion(env, jNewArray0, 0 , newSize0, @_values[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetShortBufferFromShortArray', '([S)Ljava/nio/ShortBuffer;');
  Result:= env^.CallObjectMethodA(env, _jgl2surfaceview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_ClearColor(env: PJNIEnv; _jgl2surfaceview: JObject; red: single; green: single; blue: single; alpha: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= red;
  jParams[1].f:= green;
  jParams[2].f:= blue;
  jParams[3].f:= alpha;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearColor', '(FFFF)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_LoadVertexShader(env: PJNIEnv; _jgl2surfaceview: JObject; _vShaderCode: string): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_vShaderCode));
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadVertexShader', '(Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jgl2surfaceview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_LoadFragmentShader(env: PJNIEnv; _jgl2surfaceview: JObject; _fShaderCode: string): integer;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fShaderCode));
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'LoadFragmentShader', '(Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jgl2surfaceview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jGL2SurfaceView_CreateProgramShader(env: PJNIEnv; _jgl2surfaceview: JObject; _handleVertexShader: integer; _handleFragmentShader: integer; _bindAttribDelimitedList: string): integer;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _handleVertexShader;
  jParams[1].i:= _handleFragmentShader;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_bindAttribDelimitedList));
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'CreateProgramShader', '(IILjava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGL2SurfaceView_SetViewPort(env: PJNIEnv; _jgl2surfaceview: JObject; _width: integer; _height: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _width;
  jParams[1].i:= _height;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewPort', '(II)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGL2SurfaceView_Clear(env: PJNIEnv; _jgl2surfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '()V');
  env^.CallVoidMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGL2SurfaceView_SetProjectionMatrix(env: PJNIEnv; _jgl2surfaceview: JObject; var _matrix: TDynArrayOfSingle);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_matrix);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_matrix[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetProjectionMatrix', '([F)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGL2SurfaceView_SetViewMatrix(env: PJNIEnv; _jgl2surfaceview: JObject; var _matrix: TDynArrayOfSingle);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_matrix);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_matrix[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewMatrix', '([F)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGL2SurfaceView_SetMVPMatrix(env: PJNIEnv; _jgl2surfaceview: JObject; var _matrix: TDynArrayOfSingle);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_matrix);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_matrix[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMVPMatrix', '([F)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGL2SurfaceView_SetOrthoM_Projection(env: PJNIEnv; _jgl2surfaceview: JObject; _left: single; _right: single; _bottom: single; _top: single; _near: single; _far: single);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _left;
  jParams[1].f:= _right;
  jParams[2].f:= _bottom;
  jParams[3].f:= _top;
  jParams[4].f:= _near;
  jParams[5].f:= _far;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetOrthoM_Projection', '(FFFFFF)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_SetLookAtM_View(env: PJNIEnv; _jgl2surfaceview: JObject; _eyeX: single; _eyeY: single; _eyeZ: single; _centerX: single; _centerY: single; _centerZ: single; _upX: single; _upY: single; _upZ: single);
var
  jParams: array[0..8] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _eyeX;
  jParams[1].f:= _eyeY;
  jParams[2].f:= _eyeZ;
  jParams[3].f:= _centerX;
  jParams[4].f:= _centerY;
  jParams[5].f:= _centerZ;
  jParams[6].f:= _upX;
  jParams[7].f:= _upY;
  jParams[8].f:= _upZ;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLookAtM_View', '(FFFFFFFFF)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jGL2SurfaceView_MultiplyMM_MVP_Project_View(env: PJNIEnv; _jgl2surfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'MultiplyMM_MVP_Project_View', '()V');
  env^.CallVoidMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGL2SurfaceView_DrawElements(env: PJNIEnv; _jgl2surfaceview: JObject; _mode: integer; indicesLength: integer; _drawListBuffer: jObject; _bindDataCount: integer; _bindTextureHandle: integer);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _mode;
  jParams[1].i:= indicesLength;
  jParams[2].l:= _drawListBuffer;
  jParams[3].i:= _bindDataCount;
  jParams[4].i:= _bindTextureHandle;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawElements', '(IILjava/nio/ShortBuffer;II)V');
  env^.CallVoidMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_PrepareTexture(env: PJNIEnv; _jgl2surfaceview: JObject; _programShader: integer; _uvBuffer: jObject; _vec2TextureCoord: string; _sampler2DTexture: string; _bitmap: jObject; _textureID: integer; _textureIndex: integer): integer;
var
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _programShader;
  jParams[1].l:= _uvBuffer;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_vec2TextureCoord));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_sampler2DTexture));
  jParams[4].l:= _bitmap;
  jParams[5].i:= _textureID;
  jParams[6].i:= _textureIndex;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'PrepareTexture', '(ILjava/nio/FloatBuffer;Ljava/lang/String;Ljava/lang/String;Landroid/graphics/Bitmap;II)I');
  Result:= env^.CallIntMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jGL2SurfaceView_PrepareVertex(env: PJNIEnv; _jgl2surfaceview: JObject; _program: integer; _vertexBuffer: jObject; _uMVP: string; var _attribArrayDataSize: TDynArrayOfInteger): integer;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].i:= _program;
  jParams[1].l:= _vertexBuffer;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_uMVP));
  newSize0:= Length(_attribArrayDataSize);
  jNewArray0:= env^.NewIntArray(env, newSize0);  // allocate
  env^.SetIntArrayRegion(env, jNewArray0, 0 , newSize0, @_attribArrayDataSize[0] {source});
  jParams[3].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'PrepareVertex', '(ILjava/nio/FloatBuffer;Ljava/lang/String;[I)I');
  Result:= env^.CallIntMethodA(env, _jgl2surfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jGL2SurfaceView_GenTexturesIDs(env: PJNIEnv; _jgl2surfaceview: JObject; _count: integer): TDynArrayOfInteger;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  Result := nil;
  jParams[0].i:= _count;
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GenTexturesIDs', '(I)[I');
  jResultArray:= env^.CallObjectMethodA(env, _jgl2surfaceview, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetIntArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jGL2SurfaceView_GetMaxTextureUnits(env: PJNIEnv; _jgl2surfaceview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMaxTextureUnits', '()I');
  Result:= env^.CallIntMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jGL2SurfaceView_RequestRender(env: PJNIEnv; _jgl2surfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jgl2surfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestRender', '()V');
  env^.CallVoidMethod(env, _jgl2surfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
