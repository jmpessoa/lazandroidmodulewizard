unit surfaceview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TOnSurfaceViewCreated = procedure(Sender: TObject; surfaceHolder: jObject) of object;
TOnSurfaceViewDraw  = procedure(Sender: TObject; canvas: jObject) of object;
TOnSurfaceViewChanged = procedure(Sender: TObject; width: integer; height: integer) of object;

TOnDrawingInBackgroundRunning = procedure(Sender: TObject; progress: single; out running: boolean) of object;
TOnDrawingInBackgroundExecuted = procedure(Sender: TObject; progress: single) of object;

{Draft Component code by "Lazarus Android Module Wizard" [6/3/2015 2:25:12]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jSurfaceView = class(jVisualControl)
 private
    FPaintColor: TARGBColorBridge;

    FOnSurfaceCreated:  TOnSurfaceViewCreated;
    FOnSurfaceDraw:  TOnSurfaceViewDraw;
    FOnSurfaceChanged: TOnSurfaceViewChanged;
    FOnDrawingInBackgroundRunning:  TOnDrawingInBackgroundRunning;
    FOnDrawingInBackgroundExecuted: TOnDrawingInBackgroundExecuted;

    FOnTouchDown : TOnTouchEvent;
    FOnTouchMove : TOnTouchEvent;
    FOnTouchUp   : TOnTouchEvent;
    FMouches     : TMouches;

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
    //procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    procedure RemoveFromViewParent();
    function GetView(): jObject; override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);

    procedure SetHolderFixedSize(_width: integer; _height: integer);
    procedure DrawLine(_canvas: jObject; _x1: single; _y1: single; _x2: single; _y2: single);  overload;
    procedure DrawPoint(_canvas: jObject; _x1: single; _y1: single);

    procedure SetPaintStrokeWidth(_width: single);
    procedure SetPaintStyle(_style: TPaintStyle);  //TPaintStyle
    procedure SetPaintColor( _color: TARGBColorBridge); //
    procedure SetPaintTextSize(_textsize: single);

    procedure DrawText(_canvas: jObject; _text: string; _x: single; _y: single);
    procedure DrawBitmap(_canvas: jObject; _bitmap: jObject; _b: integer; _l: integer; _r: integer; _t: integer);  overload;

    procedure DispatchOnDraw(_value: boolean);
    procedure SaveToFile(_path: string; _fileName: string);

    function GetLockedCanvas(): jObject;
    procedure UnLockCanvas(_canvas: jObject);
    procedure DoDrawingInBackground(_value: boolean);
    procedure DrawBitmap(_canvas: jObject; _bitmap: jObject; _left: single; _top: single); overload;
    procedure DrawCircle(_canvas: jObject; _cx: single; _cy: single; _radius: single);
    procedure DrawBackground(_canvas: jObject; _color: TARGBColorBridge);
    procedure DrawRect(_canvas: jObject; _left: single; _top: single; _right: single; _bottom: single);

    procedure PostInvalidate();
    procedure Invalidate();

    procedure SetDrawingInBackgroundSleeptime(_sleepTime: int64);
    procedure SetKeepScreenOn(_value: boolean);

    procedure SetFocusable(_value: boolean);
    procedure SetProgress(_startValue: single; _step: single);
    procedure DrawLine(_canvas: jObject; var _points: TDynArrayOfSingle); overload;

    function GetDrawingCache(): jObject;
    function GetImage(): jObject;

    procedure GenEvent_OnSurfaceViewCreated(Obj: TObject; surfaceHolder: jObject);
    procedure GenEvent_OnSurfaceViewDraw(Obj: TObject; canvas: jObject);
    procedure GenEvent_OnSurfaceViewTouch(Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: Single);
    procedure GenEvent_OnSurfaceViewChanged(Obj: TObject;  width: integer; height: integer);
    procedure GenEvent_OnSurfaceViewDrawingInBackground(Obj: TObject; progress: single; out running: boolean);
    procedure GenEvent_OnSurfaceViewDrawingPostExecute(Obj: TObject; progress: single);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property PaintColor: TARGBColorBridge read FPaintColor write SetPaintColor;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnSurfaceCreated:  TOnSurfaceViewCreated read FOnSurfaceCreated write FOnSurfaceCreated;
    property OnSurfaceDraw:  TOnSurfaceViewDraw  read FOnSurfaceDraw write FOnSurfaceDraw;
    property OnSurfaceChanged: TOnSurfaceViewChanged  read FOnSurfaceChanged write FOnSurfaceChanged;

    property OnDrawInBackground: TOnDrawingInBackgroundRunning read FOnDrawingInBackgroundRunning write FOnDrawingInBackgroundRunning;
    property OnDrawOutBackground: TOnDrawingInBackgroundExecuted read FOnDrawingInBackgroundExecuted write FOnDrawingInBackgroundExecuted;

        // Event - Touch
    property OnTouchDown : TOnTouchEvent read FOnTouchDown write FOnTouchDown;
    property OnTouchMove : TOnTouchEvent read FOnTouchMove write FOnTouchMove;
    property OnTouchUp   : TOnTouchEvent read FOnTouchUp   write FOnTouchUp;
end;

function jSurfaceView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jSurfaceView_jFree(env: PJNIEnv; _jsurfaceview: JObject);
procedure jSurfaceView_SetViewParent(env: PJNIEnv; _jsurfaceview: JObject; _viewgroup: jObject);
procedure jSurfaceView_RemoveFromViewParent(env: PJNIEnv; _jsurfaceview: JObject);
function jSurfaceView_GetView(env: PJNIEnv; _jsurfaceview: JObject): jObject;
procedure jSurfaceView_SetLParamWidth(env: PJNIEnv; _jsurfaceview: JObject; _w: integer);
procedure jSurfaceView_SetLParamHeight(env: PJNIEnv; _jsurfaceview: JObject; _h: integer);
procedure jSurfaceView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsurfaceview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jSurfaceView_AddLParamsAnchorRule(env: PJNIEnv; _jsurfaceview: JObject; _rule: integer);
procedure jSurfaceView_AddLParamsParentRule(env: PJNIEnv; _jsurfaceview: JObject; _rule: integer);
procedure jSurfaceView_SetLayoutAll(env: PJNIEnv; _jsurfaceview: JObject; _idAnchor: integer);
procedure jSurfaceView_ClearLayoutAll(env: PJNIEnv; _jsurfaceview: JObject);
procedure jSurfaceView_SetId(env: PJNIEnv; _jsurfaceview: JObject; _id: integer);
procedure jSurfaceView_SetHolderFixedSize(env: PJNIEnv; _jsurfaceview: JObject; _width: integer; _height: integer);

procedure jSurfaceView_DrawLine(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _x1: single; _y1: single; _x2: single; _y2: single); overload;
procedure jSurfaceView_DrawPoint(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _x1: single; _y1: single);
procedure jSurfaceView_SetPaintStrokeWidth(env: PJNIEnv; _jsurfaceview: JObject; _width: single);
procedure jSurfaceView_SetPaintStyle(env: PJNIEnv; _jsurfaceview: JObject; _style: integer);
procedure jSurfaceView_SetPaintColor(env: PJNIEnv; _jsurfaceview: JObject; _color: integer);
procedure jSurfaceView_SetPaintTextSize(env: PJNIEnv; _jsurfaceview: JObject; _textsize: single);
procedure jSurfaceView_DrawText(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _text: string; _x: single; _y: single);
procedure jSurfaceView_DrawBitmap(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _bitmap: jObject; _b: integer; _l: integer; _r: integer; _t: integer);  overload;
procedure jSurfaceView_DispatchOnDraw(env: PJNIEnv; _jsurfaceview: JObject; _value: boolean);
procedure jSurfaceView_SaveToFile(env: PJNIEnv; _jsurfaceview: JObject; _path: string; _fileName: string);

function jSurfaceView_GetLockedCanvas(env: PJNIEnv; _jsurfaceview: JObject): jObject;
procedure jSurfaceView_UnLockCanvas(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject);
procedure jSurfaceView_DoDrawingInBackground(env: PJNIEnv; _jsurfaceview: JObject; _value: boolean);
procedure jSurfaceView_DrawBitmap(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _bitmap: jObject; _left: single; _top: single); overload;
procedure jSurfaceView_DrawCircle(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _cx: single; _cy: single; _radius: single);
procedure jSurfaceView_DrawBackground(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _color: integer);
procedure jSurfaceView_DrawRect(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _left: single; _top: single; _right: single; _bottom: single);

procedure jSurfaceView_PostInvalidate(env: PJNIEnv; _jsurfaceview: JObject);
procedure jSurfaceView_Invalidate(env: PJNIEnv; _jsurfaceview: JObject);
procedure jSurfaceView_SetDrawingInBackgroundSleeptime(env: PJNIEnv; _jsurfaceview: JObject; _sleepTime: int64);
procedure jSurfaceView_SetKeepScreenOn(env: PJNIEnv; _jsurfaceview: JObject; _value: boolean);

procedure jSurfaceView_SetFocusable(env: PJNIEnv; _jsurfaceview: JObject; _value: boolean);
procedure jSurfaceView_SetProgress(env: PJNIEnv; _jsurfaceview: JObject; _startValue: single; _step: single);
procedure jSurfaceView_DrawLine(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; var _points: TDynArrayOfSingle); overload;

function jSurfaceView_GetDrawingCache(env: PJNIEnv; _jsurfaceview: JObject): jObject;



implementation

uses
   customdialog, toolbar;

{---------  jSurfaceView  --------------}

constructor jSurfaceView.Create(AOwner: TComponent);
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
  FPaintColor:= colbrRed;
  FMouches.Mouch.Active := False;
  FMouches.Mouch.Start  := False;
  FMouches.Mouch.Zoom   := 1.0;
  FMouches.Mouch.Angle  := 0.0;
end;

destructor jSurfaceView.Destroy;
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

procedure jSurfaceView.Init(refApp: jApp);
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
  jSurfaceView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jSurfaceView_SetId(FjEnv, FjObject, Self.Id);
  jSurfaceView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jSurfaceView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jSurfaceView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jSurfaceView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  if  FPaintColor <> colbrDefault  then
    jSurfaceView_SetPaintColor(FjEnv, FjObject, GetARGB(FCustomColor, FPaintColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jSurfaceView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jSurfaceView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jSurfaceView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdW else side:= sdH;
      jSurfaceView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
          jSurfaceView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
       else //lpMatchParent or others
          jSurfaceView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jSurfaceView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = gApp.Orientation then side:= sdH else side:= sdW;
      jSurfaceView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
         jSurfaceView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
         jSurfaceView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jSurfaceView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jSurfaceView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jSurfaceView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jSurfaceView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jSurfaceView_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jSurfaceView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jSurfaceView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
(*
procedure jSurfaceView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jSurfaceView.jCreate(): jObject;
begin
   Result:= jSurfaceView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jSurfaceView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_jFree(FjEnv, FjObject);
end;

procedure jSurfaceView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jSurfaceView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jSurfaceView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSurfaceView_GetView(FjEnv, FjObject);
end;

procedure jSurfaceView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jSurfaceView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jSurfaceView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jSurfaceView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jSurfaceView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jSurfaceView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jSurfaceView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jSurfaceView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetId(FjEnv, FjObject, _id);
end;


procedure jSurfaceView.SetHolderFixedSize(_width: integer; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetHolderFixedSize(FjEnv, FjObject, _width ,_height);
end;

procedure jSurfaceView.DrawLine(_canvas: jObject; _x1: single; _y1: single; _x2: single; _y2: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DrawLine(FjEnv, FjObject, _canvas ,_x1 ,_y1 ,_x2 ,_y2);
end;

procedure jSurfaceView.DrawPoint(_canvas: jObject; _x1: single; _y1: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DrawPoint(FjEnv, FjObject, _canvas ,_x1 ,_y1);
end;

procedure jSurfaceView.SetPaintStrokeWidth(_width: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetPaintStrokeWidth(FjEnv, FjObject, _width);
end;

procedure jSurfaceView.SetPaintStyle(_style: TPaintStyle);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetPaintStyle(FjEnv, FjObject, Ord(_style));
end;

procedure jSurfaceView.SetPaintColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FPaintColor:= _color;
  if FInitialized then
     jSurfaceView_SetPaintColor(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jSurfaceView.SetPaintTextSize(_textsize: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetPaintTextSize(FjEnv, FjObject, _textsize);
end;

procedure jSurfaceView.DrawText(_canvas: jObject; _text: string; _x: single; _y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DrawText(FjEnv, FjObject, _canvas ,_text ,_x ,_y);
end;

procedure jSurfaceView.DrawBitmap(_canvas: jObject; _bitmap: jObject; _b: integer; _l: integer; _r: integer; _t: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DrawBitmap(FjEnv, FjObject, _canvas ,_bitmap ,_b ,_l ,_r ,_t);
end;

procedure jSurfaceView.DispatchOnDraw(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DispatchOnDraw(FjEnv, FjObject, _value);
end;

procedure jSurfaceView.SaveToFile(_path: string; _fileName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SaveToFile(FjEnv, FjObject, _path, _fileName);
end;

procedure jSurfaceView.GenEvent_OnSurfaceViewCreated(Obj: TObject; surfaceHolder: jObject);
begin
   if Assigned(FOnSurfaceCreated) then FOnSurfaceCreated(Obj, surfaceHolder);
end;

procedure jSurfaceView.GenEvent_OnSurfaceViewDraw(Obj: TObject; canvas: jObject);
begin
   if Assigned(FOnSurfaceDraw) then FOnSurfaceDraw(Obj, canvas);
end;

Procedure jSurfaceView.GenEvent_OnSurfaceViewTouch(Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: Single);
begin
  case Act of
   cTouchDown : VHandler_touchesBegan_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchDown,FMouches);
   cTouchMove : VHandler_touchesMoved_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchMove,FMouches);
   cTouchUp   : VHandler_touchesEnded_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchUp  ,FMouches);
  end;
end;

procedure jSurfaceView.GenEvent_OnSurfaceViewChanged(Obj: TObject;  width: integer; height: integer);
begin
   if Assigned(FOnSurfaceChanged) then FOnSurfaceChanged(Obj, width, height);
end;

procedure jSurfaceView.GenEvent_OnSurfaceViewDrawingInBackground(Obj: TObject; progress: single; out running: boolean);
begin
   running:= True;
   if Assigned(FOnDrawingInBackgroundRunning) then FOnDrawingInBackgroundRunning(Obj, progress, running);
end;

procedure jSurfaceView.GenEvent_OnSurfaceViewDrawingPostExecute(Obj: TObject; progress: single);
begin
   if Assigned(FOnDrawingInBackgroundExecuted) then FOnDrawingInBackgroundExecuted(Obj, progress);
end;

function jSurfaceView.GetLockedCanvas(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSurfaceView_GetLockedCanvas(FjEnv, FjObject);
end;

procedure jSurfaceView.UnLockCanvas(_canvas: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_UnLockCanvas(FjEnv, FjObject, _canvas);
end;

procedure jSurfaceView.DoDrawingInBackground(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DoDrawingInBackground(FjEnv, FjObject, _value);
end;

procedure jSurfaceView.DrawBitmap(_canvas: jObject; _bitmap: jObject; _left: single; _top: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DrawBitmap(FjEnv, FjObject, _canvas ,_bitmap ,_left ,_top);
end;

procedure jSurfaceView.DrawCircle(_canvas: jObject; _cx: single; _cy: single; _radius: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DrawCircle(FjEnv, FjObject, _canvas ,_cx ,_cy ,_radius);
end;

procedure jSurfaceView.DrawBackground(_canvas: jObject; _color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DrawBackground(FjEnv, FjObject, _canvas , GetARGB(FCustomColor, _color));
end;

procedure jSurfaceView.DrawRect(_canvas: jObject; _left: single; _top: single; _right: single; _bottom: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DrawRect(FjEnv, FjObject, _canvas ,_left ,_top ,_right ,_bottom);
end;

procedure jSurfaceView.PostInvalidate();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_PostInvalidate(FjEnv, FjObject);
end;

procedure jSurfaceView.Invalidate();
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_Invalidate(FjEnv, FjObject);
end;

procedure jSurfaceView.SetDrawingInBackgroundSleeptime(_sleepTime: int64);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetDrawingInBackgroundSleeptime(FjEnv, FjObject, _sleepTime);
end;

procedure jSurfaceView.SetKeepScreenOn(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetKeepScreenOn(FjEnv, FjObject, _value);
end;

procedure jSurfaceView.SetFocusable(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetFocusable(FjEnv, FjObject, _value);
end;

procedure jSurfaceView.SetProgress(_startValue: single; _step: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_SetProgress(FjEnv, FjObject, _startValue ,_step);
end;

procedure jSurfaceView.DrawLine(_canvas: jObject; var _points: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
     jSurfaceView_DrawLine(FjEnv, FjObject, _canvas ,_points);
end;

function jSurfaceView.GetDrawingCache(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSurfaceView_GetDrawingCache(FjEnv, FjObject);
end;

function jSurfaceView.GetImage(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jSurfaceView_GetDrawingCache(FjEnv, FjObject);
end;


{-------- jSurfaceView_JNI_Bridge ----------}

function jSurfaceView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jSurfaceView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jSurfaceView_jCreate(long _Self) {
      return (java.lang.Object)(new jSurfaceView(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


procedure jSurfaceView_jFree(env: PJNIEnv; _jsurfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jsurfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetViewParent(env: PJNIEnv; _jsurfaceview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_RemoveFromViewParent(env: PJNIEnv; _jsurfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jsurfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jSurfaceView_GetView(env: PJNIEnv; _jsurfaceview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jsurfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetLParamWidth(env: PJNIEnv; _jsurfaceview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetLParamHeight(env: PJNIEnv; _jsurfaceview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jsurfaceview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_AddLParamsAnchorRule(env: PJNIEnv; _jsurfaceview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_AddLParamsParentRule(env: PJNIEnv; _jsurfaceview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetLayoutAll(env: PJNIEnv; _jsurfaceview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_ClearLayoutAll(env: PJNIEnv; _jsurfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jsurfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetId(env: PJNIEnv; _jsurfaceview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSurfaceView_SetHolderFixedSize(env: PJNIEnv; _jsurfaceview: JObject; _width: integer; _height: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _width;
  jParams[1].i:= _height;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetHolderFixedSize', '(II)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSurfaceView_DrawLine(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _x1: single; _y1: single; _x2: single; _y2: single);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _canvas;
  jParams[1].f:= _x1;
  jParams[2].f:= _y1;
  jParams[3].f:= _x2;
  jParams[4].f:= _y2;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawLine', '(Landroid/graphics/Canvas;FFFF)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_DrawPoint(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _x1: single; _y1: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _canvas;
  jParams[1].f:= _x1;
  jParams[2].f:= _y1;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPoint', '(Landroid/graphics/Canvas;FF)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetPaintStrokeWidth(env: PJNIEnv; _jsurfaceview: JObject; _width: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _width;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintStrokeWidth', '(F)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetPaintStyle(env: PJNIEnv; _jsurfaceview: JObject; _style: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _style;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintStyle', '(I)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetPaintColor(env: PJNIEnv; _jsurfaceview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintColor', '(I)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetPaintTextSize(env: PJNIEnv; _jsurfaceview: JObject; _textsize: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _textsize;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintTextSize', '(F)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_DrawText(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _text: string; _x: single; _y: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _canvas;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[2].f:= _x;
  jParams[3].f:= _y;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '(Landroid/graphics/Canvas;Ljava/lang/String;FF)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_DrawBitmap(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _bitmap: jObject; _b: integer; _l: integer; _r: integer; _t: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _canvas;
  jParams[1].l:= _bitmap;
  jParams[2].i:= _b;
  jParams[3].i:= _l;
  jParams[4].i:= _r;
  jParams[5].i:= _t;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBitmap', '(Landroid/graphics/Canvas;Landroid/graphics/Bitmap;IIII)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSurfaceView_DispatchOnDraw(env: PJNIEnv; _jsurfaceview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DispatchOnDraw', '(Z)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSurfaceView_SaveToFile(env: PJNIEnv; _jsurfaceview: JObject; _path: string; _fileName: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_fileName));
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jSurfaceView_GetLockedCanvas(env: PJNIEnv; _jsurfaceview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLockedCanvas', '()Landroid/graphics/Canvas;');
  Result:= env^.CallObjectMethod(env, _jsurfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_UnLockCanvas(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _canvas;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'UnLockCanvas', '(Landroid/graphics/Canvas;)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_DoDrawingInBackground(env: PJNIEnv; _jsurfaceview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DoDrawingInBackground', '(Z)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_DrawBitmap(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _bitmap: jObject; _left: single; _top: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _canvas;
  jParams[1].l:= _bitmap;
  jParams[2].f:= _left;
  jParams[3].f:= _top;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBitmap', '(Landroid/graphics/Canvas;Landroid/graphics/Bitmap;FF)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSurfaceView_DrawCircle(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _cx: single; _cy: single; _radius: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _canvas;
  jParams[1].f:= _cx;
  jParams[2].f:= _cy;
  jParams[3].f:= _radius;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawCircle', '(Landroid/graphics/Canvas;FFF)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_DrawBackground(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _color: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _canvas;
  jParams[1].i:= _color;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBackground', '(Landroid/graphics/Canvas;I)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_DrawRect(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; _left: single; _top: single; _right: single; _bottom: single);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _canvas;
  jParams[1].f:= _left;
  jParams[2].f:= _top;
  jParams[3].f:= _right;
  jParams[4].f:= _bottom;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRect', '(Landroid/graphics/Canvas;FFFF)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSurfaceView_PostInvalidate(env: PJNIEnv; _jsurfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'PostInvalidate', '()V');
  env^.CallVoidMethod(env, _jsurfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_Invalidate(env: PJNIEnv; _jsurfaceview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'Invalidate', '()V');
  env^.CallVoidMethod(env, _jsurfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSurfaceView_SetDrawingInBackgroundSleeptime(env: PJNIEnv; _jsurfaceview: JObject; _sleepTime: int64);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _sleepTime;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDrawingInBackgroundSleeptime', '(J)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSurfaceView_SetKeepScreenOn(env: PJNIEnv; _jsurfaceview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetKeepScreenOn', '(Z)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSurfaceView_SetFocusable(env: PJNIEnv; _jsurfaceview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFocusable', '(Z)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jSurfaceView_SetProgress(env: PJNIEnv; _jsurfaceview: JObject; _startValue: single; _step: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _startValue;
  jParams[1].f:= _step;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetProgress', '(FF)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jSurfaceView_DrawLine(env: PJNIEnv; _jsurfaceview: JObject; _canvas: jObject; var _points: TDynArrayOfSingle);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].l:= _canvas;
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawLine', '(Landroid/graphics/Canvas;[F)V');
  env^.CallVoidMethodA(env, _jsurfaceview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jSurfaceView_GetDrawingCache(env: PJNIEnv; _jsurfaceview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jsurfaceview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDrawingCache', '()Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethod(env, _jsurfaceview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;



end.
