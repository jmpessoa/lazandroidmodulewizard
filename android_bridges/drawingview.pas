unit drawingview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget, systryparent, PaintShader;

type

   //CCW - counter-clockwise
   //CW - clockwise

   TPathDirection = (pdClockwise, pdCounterClockwise);
   TOnDrawingViewSizeChanged = procedure(Sender: TObject; width: integer; height: integer; oldWidth: integer; oldHeight: integer) of object;

{Draft Component code by "Lazarus Android Module Wizard" [5/20/2016 4:14:09]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

{ jDrawingView }

jDrawingView = class(jVisualControl)    //jDrawingView
private
  FOnDraw       : TOnTouchExtended;
  FOnTouchDown  : TOnTouchExtended;
  FOnTouchMove  : TOnTouchExtended;
  FOnTouchUp    : TOnTouchExtended;
  FOnClick      : TOnTouch;
  FOnDoubleClick: TOnTouch;
  FOnSizeChanged: TOnDrawingViewSizeChanged;

  FPaintStrokeWidth: Single;
  FPaintStyle: TPaintStyle;
  FPaintColor: TARGBColorBridge;
  FPaintStrokeJoin: TStrokeJoin;
  FPaintStrokeCap: TStrokeCap;
  // new
  FPaintShader: JPaintShader; // Java : jPaintShader
  FTimeClick: Integer;
  FTimeDoubleClick: Integer;

  FImageIdentifier: string;

  FMinZoomFactor: Single;
  FMaxZoomFactor: Single;

  FMinWorldX: Single;
  FMaxWorldX: Single;
  FMinWorldY: Single;
  FMaxWorldY: Single;
  FScaleX: Single;
  FScaleY: Single;
  FBufferedDraw: Boolean;

  procedure SetVisible(Value: Boolean);
  procedure SetColor(Value: TARGBColorBridge); //background
  function  GetCanvas(): jObject;
  // new 
  procedure SetPaintShader(Value: JPaintShader); // Java : jPaintShader
  procedure SetTimeClick(Value: Integer);
  procedure SetTimeDoubleClick(Value: Integer);
protected
  procedure Notification(AComponent: TComponent; Operation: TOperation); override;
public
  constructor Create(AOwner: TComponent); override;
  destructor  Destroy; override;
  procedure Init(refApp: jApp); override;
  procedure Refresh;
  procedure UpdateLayout; override;
  function jCreate( _bufferedDraw: boolean; _backgroundColor: integer): jObject;

  procedure jFree();
  procedure SetViewParent(_viewgroup: jObject); override;
  procedure RemoveFromViewParent(); override;
  function GetView(): jObject; override;
  procedure SetLParamWidth(_w: integer);
  procedure SetLParamHeight(_h: integer);
  procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
  procedure AddLParamsAnchorRule(_rule: integer);
  procedure AddLParamsParentRule(_rule: integer);
  procedure SetLayoutAll(_idAnchor: integer);
  procedure ClearLayout();
  function GetDrawingCache(): jObject;
  function GetImage(): jObject;
  function GetPaint(): jObject;

  function GetHeight(): integer; override;
  function GetWidth(): integer; override;
  procedure DrawBitmap(_bitmap: jObject; _width: integer; _height: integer); overload;
  procedure DrawBitmap(_bitmap: jObject; _left: integer; _top: integer; _right: integer; _bottom: integer); overload;

  procedure SetPaintStrokeWidth(_width: single);
  procedure SetPaintStyle(_style: TPaintStyle);  //TPaintStyle
  procedure SetPaintColor( _color: TARGBColorBridge); overload;
  procedure SetPaintColor(Color: TAlphaColor); overload;
  procedure SetTextSize(_textsize: DWord);

  procedure DrawLine(_x1: single; _y1: single; _x2: single; _y2: single); overload;
  procedure DrawLine(var _points: TDynArrayOfSingle); overload;
  procedure DrawLine(_points: array of single); overload;

  function GetPath(var _points: TDynArrayOfSingle): jObject; overload;
  function GetPath(_points: array of single): jObject; overload;

  procedure DrawPath(_path: jObject); overload;
  procedure DrawPath(var _points: TDynArrayOfSingle); overload;
  procedure DrawPath(_points: array of single); overload;
  procedure SetPaintStrokeJoin(_strokeJoin: TStrokeJoin);
  procedure SetPaintStrokeCap(_strokeCap: TStrokeCap);
  procedure SetPaintCornerPathEffect(_radius: single);
  procedure SetPaintDashPathEffect(_lineDash: single; _dashSpace: single; _phase: single);
  function GetPath(): jObject; overload;
  function ResetPath(): jObject; overload;
  function ResetPath(_path: jObject): jObject; overload;
  procedure AddCircleToPath(_x: single; _y: single; _r: single; _pathDirection: TPathDirection); overload;
  procedure AddCircleToPath(_path: jObject; _x: single; _y: single; _r: single; _pathDirection: TPathDirection); overload;
  function GetNewPath(var _points: TDynArrayOfSingle): jObject; overload;
  function GetNewPath(_points: array of single): jObject; overload;
  function GetNewPath(): jObject; overload;
  function AddPointsToPath(_path: jObject; var _points: TDynArrayOfSingle): jObject; overload;
  function AddPointsToPath(_path: jObject; _points: array of single): jObject;  overload;
  function AddPathToPath(_srcPath: jObject; _targetPath: jObject; _dx: single; _dy: single): jObject;
  procedure DrawTextOnPath(_path: jObject; _text: string; _xOffset: single; _yOffset: single); overload;
  procedure DrawTextOnPath(_text: string; _xOffset: single; _yOffset: single); overload;

  procedure DrawText(_text: string; _x: single; _y: single);  overload;
  procedure DrawText(_text: string; _x: single; _y: single; _angleDegree: single); overload;

  procedure DrawPoint(_x1: single; _y1: single);
  procedure DrawCircle(_cx: single; _cy: single; _radius: single);
  procedure DrawBackground(_color: integer);

  procedure DrawRect(_left: single; _top: single; _right: single; _bottom: single); overload;
  //procedure DrawRect(_P0x: single; _P0y: single; _P1x: single; _P1y: single; _P2x: single; _P2y: single; _P3x: single; _P3y: single); overload;
  procedure DrawRect(var _xyArray8: TDynArrayOfSingle); overload;
  procedure DrawRect(var _xyArray8: array of single); overload;

  procedure SetImageByResourceIdentifier(_imageResIdentifier: string);    // ../res/drawable
  procedure DrawBitmap(_bitmap: jObject);  overload;

    //procedure DrawBitmap(bitMap: jObject; srcLeft, srcTop, srcRight, srcBottom, dstLeft, dstTop, dstRight, dstBottom: Integer); overload; // by Kordal
    //procedure DrawFrame(bitMap: jObject; srcX, srcY, srcW, srcH, X, Y, W, H: Integer; rotateDegree: Single=0); overload; // by Kordal
    //procedure DrawFrame(bitMap: jObject; X, Y, Index, Size: Integer; scaleFactor: Single=1; rotateDegree: Single=0); overload;

  //by Kordal
  procedure DrawBitmap(bitMap: jObject; srcLeft, srcTop, srcRight, srcBottom: Integer; dstLeft, dstTop, dstRight, dstBottom: Single); overload;
  procedure DrawFrame(bitMap: jObject; srcX, srcY, srcW, srcH: Integer; X, Y, W, H: Single; rotateDegree: Single=0); overload;
  procedure DrawFrame(bitMap: jObject; X, Y: Single; Index, Size: Integer; scaleFactor: Single=1; rotateDegree: Single=0); overload;

  procedure SaveToFile(_filename: string); overload;
  procedure SaveToFile(_path: string; _filename: string);  overload;

  procedure SetMinZoomFactor(_minZoomFactor: single);
  procedure SetMaxZoomFactor(_maxZoomFactor: single);

  procedure DrawTextAligned(_text: string; _left: single; _top: single; _right: single; _bottom: single; _alignHorizontal: TTextAlignHorizontal; _alignVertical: TTextAlignVertical);

  procedure DrawArc(_leftRectF: single; _topRectF: single; _rightRectF: single; _bottomRectF: single; _startAngle: single; _sweepAngle: single; _useCenter: boolean);
  procedure DrawOval(_leftRectF: single; _topRectF: single; _rightRectF: single; _bottomRectF: single);

  function GetViewportX(_worldX: single; _minWorldX: single; _maxWorldX: single; _viewportWidth: integer): integer; overload;
  function GetViewportY(_worldY: single; _minWorldY: single; _maxWorldY: single; _viewportHeight: integer): integer;  overload;

  procedure SetViewportScaleXY(minX: single; maxX: single; minY: single; maxY: single);
  function GetViewportY(_worldY: single): integer; overload;
  function GetViewportX(_worldX: single): integer; overload;

  function GetWorldY(_viewportY:integer): single;
  function GetWorldX(_viewportX:integer): single;

  procedure DrawBitmap(_bitmap: jObject; _x: single; _y: single; _angleDegree: single); overload;
  procedure DrawText(_text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean); overload;
  procedure DrawTextMultiLine(_text: string; _left: single; _top: single; _right: single; _bottom: single);
  procedure Invalidate();
  procedure Clear(_color: TARGBColorBridge); overload;
  procedure Clear();  overload;
  procedure SetBufferedDraw(_value: boolean);
  function GetTextHeight(_text: string): single;
  function GetTextWidth(_text: string): single;
  function GetTextLeft(_text: string): single; //LMB
  function GetTextBottom(_text: string): single; //LMB

  procedure SetFontFace(AValue: TFontFace);
  procedure SetTextTypeFace(AValue: TTextTypeFace);
  procedure SetFontFromAssets(_fontName: string);
  procedure DrawTextFromAssetsFont(_text: string; _x: single; _y: single; _assetsFontName: string; _size: integer; _color: TARGBColorBridge);

    {GetTextBox :: result len=4
     array[0] => x //left-top
     array[1] => y
     array[2] => x //right-bottom
     array[3] => y}
  function GetTextBox(_text: string; _x: single; _y: single): TDynArrayOfSingle; overload;

    {GetTextBox :: result len=8
     array[0] => x //left-top
     array[1] => y
     array[2] => x //right-top
     array[3] => y
     array[4] => x //left-bottom
     array[5] => y
     array[6] => x //right-bottom
     array[7] => y}
  function GetTextBox(_text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean): TDynArrayOfSingle;overload;

    {DrawTextEx :: result len=4
     array[0] => x //left-top
     array[1] => y
     array[2] => x //right-bottom
     array[3] => y}
  function DrawTextEx(_text: string; _x: single; _y: single): TDynArrayOfSingle; overload;

    {DrawTextEx :: result len=8
    array[0] => x //left-top
    array[1] => y
    array[2] => x //right-top
    array[3] => y
    array[4] => x //left-bottom
    array[5] => y
    array[6] => x //right-bottom
    array[7] => y}
  function DrawTextEx(_text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean): TDynArrayOfSingle; overload;

    {DrawTextEx :: result len=8
    array[0] => x //left-top
    array[1] => y
    array[2] => x //right-top
    array[3] => y
    array[4] => x //left-bottom
    array[5] => y
    array[6] => x //right-bottom
    array[7] => y}
  function DrawTextEx(_text: string; _x: single; _y: single; _angleDegree: single): TDynArrayOfSingle;  overload;

    {DrawTextAlignedEx  :: result len=4
    array[0] => x //left-top
    array[1] => y
    array[2] => x //right-bottom
    array[3] => y}
  function DrawTextAlignedEx(_text: string; _left: single; _top: single; _right: single; _bottom: single; _alignHorizontal: single; _alignVertical: single): TDynArrayOfSingle;

  procedure DrawCroppedBitmap(_bitmap: jObject; _x: single; _y: single; _cropOffsetLeft: integer; _cropOffsetTop: integer; _cropWidth: integer; _cropHeight: integer);

  //by Kordal
  procedure DrawRoundRect(Left, Top, Right, Bottom, radiusX, radiusY: Single);
  procedure DrawGrid(Left, Top, Width, Height: Single; cellsX, cellsY: Integer);
  procedure ClipRect(Left, Top, Right, Bottom: Single);
  function GetDensity(): Single;
  procedure SetLayerType(Value: TLayerType);

  procedure GenEvent_OnDrawingViewTouch(Obj: TObject; Act, Cnt: integer; X,Y: array of Single;
                                 fligGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);

  procedure GenEvent_OnDrawingViewDraw(Obj: TObject; Act, Cnt: integer; X,Y: array of Single;
                                 fligGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);

  procedure GenEvent_OnDrawingViewSizeChanged(Obj: TObject; width: integer; height: integer; oldWidth: integer; oldHeight: integer);

  property Density: Single read GetDensity; //by Kordal
published
  property BackgroundColor: TARGBColorBridge read FColor write SetColor;
  property FontSize: DWord read FFontSize write SetTextSize;
  property FontFace: TFontFace read FFontFace write SetFontface;
  property TextTypeFace: TTextTypeFace read FTextTypeFace write SetTextTypeFace;
  property PaintShader: JPaintShader read FPaintShader write SetPaintShader; // new!
  property PaintStrokeWidth: single read FPaintStrokeWidth write SetPaintStrokeWidth;
  property PaintStyle: TPaintStyle read FPaintStyle write SetPaintStyle;
  property PaintColor: TARGBColorBridge read FPaintColor write SetPaintColor;
  property PaintStrokeJoin: TStrokeJoin read FPaintStrokeJoin write SetPaintStrokeJoin;
  property PaintStrokeCap: TStrokeCap read FPaintStrokeCap write SetPaintStrokeCap;

  property ImageIdentifier : string read FImageIdentifier write SetImageByResourceIdentifier;

  property MinPinchZoomFactor: single read FMinZoomFactor write FMinZoomFactor;
  property MaxPinchZoomFactor: single read FMaxZoomFactor write FMaxZoomFactor;
  property BufferedDraw: boolean read FBufferedDraw write SetBufferedDraw;

  property TimeClick: Integer read FTimeClick write SetTimeClick; // default 250
  property TimeDoubleClick: Integer read FTimeDoubleClick write SetTimeDoubleClick; // default 350
  // Event - Drawing
  property OnDraw       : TOnTouchExtended read FOnDraw write FOnDraw;
  property OnSizeChanged: TOnDrawingViewSizeChanged read FOnSizeChanged write FOnSizeChanged;
  // Event - Touch
  property OnTouchDown  : TOnTouchExtended read FOnTouchDown write FOnTouchDown;
  property OnTouchMove  : TOnTouchExtended read FOnTouchMove write FOnTouchMove;
  property OnTouchUp    : TOnTouchExtended read FOnTouchUp   write FOnTouchUp;
  // Event - Click
  property OnClick      : TOnTouch read FOnClick write FOnClick;
  property OnDoubleClick: TOnTouch read FOnDoubleClick write FOnDoubleClick;
end;

function jDrawingView_jCreate(env: PJNIEnv;_Self: int64; _bufferedDraw: boolean;  _backgroundColor: integer; this: jObject): jObject;
procedure jDrawingView_jFree(env: PJNIEnv; _jdrawingview: JObject);
procedure jDrawingView_SetViewParent(env: PJNIEnv; _jdrawingview: JObject; _viewgroup: jObject);
procedure jDrawingView_RemoveFromViewParent(env: PJNIEnv; _jdrawingview: JObject);
function jDrawingView_GetView(env: PJNIEnv; _jdrawingview: JObject): jObject;
procedure jDrawingView_SetLParamWidth(env: PJNIEnv; _jdrawingview: JObject; _w: integer);
procedure jDrawingView_SetLParamHeight(env: PJNIEnv; _jdrawingview: JObject; _h: integer);
procedure jDrawingView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jdrawingview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jDrawingView_AddLParamsAnchorRule(env: PJNIEnv; _jdrawingview: JObject; _rule: integer);
procedure jDrawingView_AddLParamsParentRule(env: PJNIEnv; _jdrawingview: JObject; _rule: integer);
procedure jDrawingView_SetLayoutAll(env: PJNIEnv; _jdrawingview: JObject; _idAnchor: integer);
procedure jDrawingView_ClearLayoutAll(env: PJNIEnv; _jdrawingview: JObject);
procedure jDrawingView_SetId(env: PJNIEnv; _jdrawingview: JObject; _id: integer);
function jDrawingView_GetDrawingCache(env: PJNIEnv; _jdrawingview: JObject): jObject;
function jDrawingView_GetPaint(env: PJNIEnv; _jdrawingview: JObject): jObject;

function jDrawingView_GetHeight(env: PJNIEnv; _jdrawingview: JObject): integer;
function jDrawingView_GetWidth(env: PJNIEnv; _jdrawingview: JObject): integer;
procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _width: integer; _height: integer);overload;
procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _left: integer; _top: integer; _right: integer; _bottom: integer);overload;
procedure jDrawingView_SetPaintWidth(env: PJNIEnv; _jdrawingview: JObject; _width: single);
procedure jDrawingView_SetPaintStyle(env: PJNIEnv; _jdrawingview: JObject; _style: integer);
procedure jDrawingView_SetPaintColor(env: PJNIEnv; _jdrawingview: JObject; _color: integer);
procedure jDrawingView_SetTextSize(env: PJNIEnv; _jdrawingview: JObject; _textSize: DWord);
procedure jDrawingView_SetTypeface(env: PJNIEnv; _jdrawingview: JObject; _typeface: integer);
procedure jDrawingView_DrawLine(env: PJNIEnv; _jdrawingview: JObject; _x1: single; _y1: single; _x2: single; _y2: single); overload;
procedure jDrawingView_DrawText(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single); overload;
procedure jDrawingView_DrawText(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _angle: single); overload;

procedure jDrawingView_DrawLine(env: PJNIEnv; _jdrawingview: JObject; var _points: TDynArrayOfSingle); overload;
procedure jDrawingView_DrawLine(env: PJNIEnv; _jdrawingview: JObject; var _points: array of single); overload;
procedure jDrawingView_DrawPoint(env: PJNIEnv; _jdrawingview: JObject; _x1: single; _y1: single);
procedure jDrawingView_DrawCircle(env: PJNIEnv; _jdrawingview: JObject; _cx: single; _cy: single; _radius: single);
procedure jDrawingView_DrawBackground(env: PJNIEnv; _jdrawingview: JObject; _color: integer);

procedure jDrawingView_DrawRect(env: PJNIEnv; _jdrawingview: JObject; _left: single; _top: single; _right: single; _bottom: single);  overload;
//procedure jDrawingView_DrawRect(env: PJNIEnv; _jdrawingview: JObject; _P0x: single; _P0y: single; _P1x: single; _P1y: single; _P2x: single; _P2y: single; _P3x: single; _P3y: single); overload;
procedure jDrawingView_DrawRect(env: PJNIEnv; _jdrawingview: JObject; var _xyArray8: TDynArrayOfSingle); overload;
procedure jDrawingView_DrawRect(env: PJNIEnv; _jdrawingview: JObject; var _xyArray8: array of single); overload;

procedure jDrawingView_SetImageByResourceIdentifier(env: PJNIEnv; _jdrawingview: JObject; _imageResIdentifier: string);
procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject);  overload;
procedure jDrawingView_SaveToFile(env: PJNIEnv; _jdrawingview: JObject; _filename: string); overload;
procedure jDrawingView_SaveToFile(env: PJNIEnv; _jdrawingview: JObject; _path: string; _filename: string); overload;
procedure jDrawingView_SetMinZoomFactor(env: PJNIEnv; _jdrawingview: JObject; _minZoomFactor: single);
procedure jDrawingView_SetMaxZoomFactor(env: PJNIEnv; _jdrawingview: JObject; _maxZoomFactor: single);

function jDrawingView_GetCanvas(env: PJNIEnv; _jdrawingview: JObject): jObject;
procedure jDrawingView_DrawTextAligned(env: PJNIEnv; _jdrawingview: JObject; _text: string; _left: single; _top: single; _right: single; _bottom: single; _alignHorizontal: single; _alignVertical: single);
function jDrawingView_GetPath(env: PJNIEnv; _jdrawingview: JObject; var _points: TDynArrayOfSingle): jObject; overload;
function jDrawingView_GetPath(env: PJNIEnv; _jdrawingview: JObject; _points: array of single): jObject; overload;
procedure jDrawingView_DrawPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject); overload;
procedure jDrawingView_DrawPath(env: PJNIEnv; _jdrawingview: JObject; var _points: TDynArrayOfSingle);overload;
procedure jDrawingView_DrawPath(env: PJNIEnv; _jdrawingview: JObject; _points: array of single);overload;
procedure jDrawingView_SetPaintStrokeJoin(env: PJNIEnv; _jdrawingview: JObject; _strokeJoin: integer);
procedure jDrawingView_SetPaintStrokeCap(env: PJNIEnv; _jdrawingview: JObject; _strokeCap: integer);
procedure jDrawingView_SetPaintCornerPathEffect(env: PJNIEnv; _jdrawingview: JObject; _radius: single);
procedure jDrawingView_SetPaintDashPathEffect(env: PJNIEnv; _jdrawingview: JObject; _lineDash: single; _dashSpace: single; _phase: single);
function jDrawingView_GetPath(env: PJNIEnv; _jdrawingview: JObject): jObject; overload;
function jDrawingView_ResetPath(env: PJNIEnv; _jdrawingview: JObject): jObject;  overload;
function jDrawingView_ResetPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject): jObject; overload;
procedure jDrawingView_AddCircleToPath(env: PJNIEnv; _jdrawingview: JObject; _x: single; _y: single; _r: single; _pathDirection: integer); overload;
procedure jDrawingView_AddCircleToPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject; _x: single; _y: single; _r: single; _pathDirection: integer); overload;
function jDrawingView_GetNewPath(env: PJNIEnv; _jdrawingview: JObject; var _points: TDynArrayOfSingle): jObject; overload;
function jDrawingView_GetNewPath(env: PJNIEnv; _jdrawingview: JObject; _points: array of single): jObject; overload;
function jDrawingView_GetNewPath(env: PJNIEnv; _jdrawingview: JObject): jObject;  overload;
function jDrawingView_AddPointsToPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject; var _points: TDynArrayOfSingle): jObject; overload;
function jDrawingView_AddPointsToPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject; _points: array of single): jObject; overload;
function jDrawingView_AddPathToPath(env: PJNIEnv; _jdrawingview: JObject; _srcPath: jObject; _targetPath: jObject; _dx: single; _dy: single): jObject;
procedure jDrawingView_DrawArc(env: PJNIEnv; _jdrawingview: JObject; _leftRectF: single; _topRectF: single; _rightRectF: single; _bottomRectF: single; _startAngle: single; _sweepAngle: single; _useCenter: boolean);
procedure jDrawingView_DrawOval(env: PJNIEnv; _jdrawingview: JObject; _leftRectF: single; _topRectF: single; _rightRectF: single; _bottomRectF: single);
procedure jDrawingView_DrawTextOnPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject; _text: string; _xOffset: single; _yOffset: single);overload;
procedure jDrawingView_DrawTextOnPath(env: PJNIEnv; _jdrawingview: JObject; _text: string; _xOffset: single; _yOffset: single); overload;

procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _x: single; _y: single; _angleDegree: single); overload;
procedure jDrawingView_DrawText(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean); overload;
procedure jDrawingView_DrawTextMultiLine(env: PJNIEnv; _jdrawingview: JObject; _text: string; _left: single; _top: single; _right: single; _bottom: single);
procedure jDrawingView_Invalidate(env: PJNIEnv; _jdrawingview: JObject);
procedure jDrawingView_Clear(env: PJNIEnv; _jdrawingview: JObject; _color: integer); overload;
procedure jDrawingView_Clear(env: PJNIEnv; _jdrawingview: JObject); overload;
procedure jDrawingView_SetBufferedDraw(env: PJNIEnv; _jdrawingview: JObject; _value: boolean);

function jDrawingView_GetTextHeight(env: PJNIEnv; _jdrawingview: JObject; _text: string): single;
function jDrawingView_GetTextWidth(env: PJNIEnv; _jdrawingview: JObject; _text: string): single;
function jDrawingView_GetTextLeft(env: PJNIEnv; _jdrawingview: JObject; _text: string): single; //LMB
function jDrawingView_GetTextBottom(env: PJNIEnv; _jdrawingview: JObject; _text: string): single; //LMB
procedure jDrawingView_SetFontAndTextTypeFace(env: PJNIEnv; _jdrawingview: JObject; _fontFace: integer; _fontStyle: integer);

procedure jDrawingView_SetFontFromAssets(env: PJNIEnv; _jdrawingview: JObject; _fontName: string);
procedure jDrawingView_DrawTextFromAssetsFont(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _assetsFontName: string; _size: integer; _color: integer);
procedure jDrawingView_SetBackgroundColor(env: PJNIEnv; _jdrawingview: JObject; _backgroundColor: integer);
function jDrawingView_GetTextBox(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single): TDynArrayOfSingle; overload;
function jDrawingView_GetTextBox(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean): TDynArrayOfSingle; overload;

function jDrawingView_DrawTextEx(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single): TDynArrayOfSingle; overload;
function jDrawingView_DrawTextEx(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean): TDynArrayOfSingle; overload;
function jDrawingView_DrawTextEx(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _angleDegree: single): TDynArrayOfSingle;  overload;
function jDrawingView_DrawTextAlignedEx(env: PJNIEnv; _jdrawingview: JObject; _text: string; _left: single; _top: single; _right: single; _bottom: single; _alignHorizontal: single; _alignVertical: single): TDynArrayOfSingle;
procedure jDrawingView_DrawCroppedBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _x: single; _y: single; _cropOffsetLeft: integer; _cropOffsetTop: integer; _cropWidth: integer; _cropHeight: integer);

//procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _sl, _st, _sr, _sb, _dl, _dt, _dr, _db: Integer); overload; // by Kordal
//procedure jDrawingView_DrawFrame(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _srcX, _srcY, _srcW, _srcH, _X, _Y, _Wh, _Ht: Integer; _rotateDegree: Single); overload;
//procedure jDrawingView_DrawFrame(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _X, _Y, _Index, _Size: Integer; _scaleFactor, _rotateDegree: Single); overload;

//by Kordal
procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _sl, _st, _sr, _sb: Integer; _dl, _dt, _dr, _db: Single); overload;
procedure jDrawingView_DrawFrame(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _srcX, _srcY, _srcW, _srcH: Integer; _X, _Y, _Wh, _Ht, _rotateDegree: Single); overload;
procedure jDrawingView_DrawFrame(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _X, _Y: Single; _Index, _Size: Integer; _scaleFactor, _rotateDegree: Single); overload;
procedure jDrawingView_DrawRoundRect(env: PJNIEnv; _jdrawingview: JObject; _Left, _Top, _Right, _Bottom, _rX, _rY: Single);
procedure jDrawingView_DrawGrid(env: PJNIEnv; _jdrawingview: JObject; _Left, _Top, _Width, _Height: Single; _cellsX, _cellsY: Integer);
procedure jDrawingView_ClipRect(env: PJNIEnv; _jdrawingview: JObject; Left, Top, Right, Bottom: Single);
function  jDrawingView_GetDensity(env: PJNIEnv; _jdrawingview: JObject): Single;
procedure jDrawingView_SetLayerType(env: PJNIEnv; _jdrawingview: JObject; _Value: JByte);

implementation

{---------  jDrawingView  --------------}

constructor jDrawingView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();

  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FLParamWidth  := lpWrapContent; //lpMatchParent;
  FLParamHeight := lpWrapContent;
  FHeight       := 100;
  FWidth        := 200;
  FAcceptChildrenAtDesignTime:= False;
//your code here....
(*  FMouches.Mouch.Active := False;
  FMouches.Mouch.Start  := False;
  FMouches.Mouch.Zoom   := 1.0;
  FMouches.Mouch.Angle  := 0.0; *)
  FFontFace:= ffNormal;
  FTextTypeFace:= tfNormal;
  FFontSize:= 0;
  FPaintStrokeWidth:= 1;
  FPaintStyle:= psDefault;
  FPaintColor:= colbrRed;

  FMinZoomFactor:= 1/4;
  FMaxZoomFactor:= 8/2;

  FPaintStrokeJoin:= sjDefault;
  FPaintStrokeCap:= scDefault;
  FBufferedDraw:= False;
  FColor:= colbrWhite;

  FTimeClick := 250;
  FTimeDoubleClick := 350;
end;

destructor jDrawingView.Destroy;
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

procedure jDrawingView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
  obj: JObject=nil;
begin
  if not FInitialized  then
  begin
    inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
    //your code here: set/initialize create params....
    FjObject:= jCreate(FBufferedDraw, GetARGB(FCustomColor, FColor)); //jSelf !
   	
    if FParent <> nil then
      sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

    FjPRLayoutHome:= FjPRLayout;

    jDrawingView_SetViewParent(FjEnv, FjObject, FjPRLayout);
    jDrawingView_SetId(FjEnv, FjObject, Self.Id);
  end;

  jDrawingView_setLeftTopRightBottomWidthHeight(FjEnv, FjObject ,
                                           FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                                           sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                                           sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jDrawingView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jDrawingView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jDrawingView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if not FInitialized then
  begin
    FInitialized := True;

    if FPaintStrokeWidth > 1 then
      jDrawingView_SetPaintWidth(FjEnv, FjObject, FPaintStrokeWidth);

    if  FPaintStyle <> psDefault then
      jDrawingView_SetPaintStyle(FjEnv, FjObject, ord(FPaintStyle));

    if  FPaintColor <> colbrDefault then
      jDrawingView_SetPaintColor(FjEnv, FjObject, GetARGB(FCustomColor, FPaintColor));

    if FFontSize <> 0 then
      jDrawingView_SetTextSize(FjEnv, FjObject, FFontSize);

    if (FFontFace <> ffNormal) or (FTextTypeFace <> tfNormal) then //jDrawingView_SetTypeface(FjEnv, FjObject, Ord(FFontFace));
      jDrawingView_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));

    if FPaintStrokeJoin <>  sjDefault then
      jDrawingView_SetPaintStrokeJoin(FjEnv, FjObject, Ord(FPaintStrokeJoin));

    if FPaintStrokeCap <>  scDefault then
      jDrawingView_SetPaintStrokeCap(FjEnv, FjObject, Ord(FPaintStrokeCap));

    if FImageIdentifier <> '' then
      jDrawingView_SetImageByResourceIdentifier(FjEnv, FjObject , FImageIdentifier);

    // if  FColor <> colbrDefault then
    //View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

    View_SetVisible(FjEnv, FjObject, FVisible);

    // PaintShader new!
    if FPaintShader <> nil then
      FPaintShader.Init(refApp, GetPaint);
  end;
end;

procedure jDrawingView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then //View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
    jDrawingView_SetBackgroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jDrawingView.SetVisible(Value: Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jDrawingView.UpdateLayout;
begin
  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);
end;

procedure jDrawingView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

//Event : Java -> Pascal
(*
procedure jDrawingView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jDrawingView.jCreate( _bufferedDraw: boolean;  _backgroundColor: integer): jObject;
begin
   Result:= jDrawingView_jCreate(FjEnv, int64(Self) ,_bufferedDraw, _backgroundColor, FjThis);
end;


procedure jDrawingView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_jFree(FjEnv, FjObject);
end;

procedure jDrawingView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

procedure jDrawingView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jDrawingView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetView(FjEnv, FjObject);
end;

procedure jDrawingView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jDrawingView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetLParamHeight(FjEnv, FjObject, _h);
end;

procedure jDrawingView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jDrawingView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jDrawingView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jDrawingView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jDrawingView.ClearLayout();
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  //in designing component state: set value here...
  if FInitialized then
  begin
     jDrawingView_clearLayoutAll(FjEnv, FjObject);

     for rToP := rpBottom to rpCenterVertical do
        if rToP in FPositionRelativeToParent then
          jDrawingView_addlParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

     for rToA := raAbove to raAlignRight do
       if rToA in FPositionRelativeToAnchor then
         jDrawingView_addlParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
  end;
end;

function jDrawingView.GetDrawingCache(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetDrawingCache(FjEnv, FjObject);
end;

function jDrawingView.GetImage(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetDrawingCache(FjEnv, FjObject);
end;

function jDrawingView.GetPaint(): jObject;
begin
  if FInitialized then
    Result := jDrawingView_GetPaint(FjEnv, FjObject);
end;

function jDrawingView.GetWidth(): integer;
begin
  Result:= FWidth;
  if not FInitialized then exit;

  if sysIsWidthExactToParent(Self) then
   Result := sysGetWidthOfParent(FParent)
  else
   Result:= jDrawingView_GetWidth(FjEnv, FjObject );
end;

function jDrawingView.GetHeight(): integer;
begin
  Result:= FHeight;
  if not FInitialized then exit;

  if sysIsHeightExactToParent(Self) then
   Result := sysGetHeightOfParent(FParent)
  else
   Result:= jDrawingView_GetHeight(FjEnv, FjObject );
end;

(*
procedure jDrawingView.DrawBitmap(bitMap: jObject; srcLeft, srcTop, srcRight, srcBottom, dstLeft, dstTop, dstRight, dstBottom: Integer);
begin
  if FInitialized then
    jDrawingView_DrawBitmap(FjEnv, FjObject, bitMap, srcLeft, srcTop, srcRight, srcBottom, dstLeft, dstTop, dstRight, dstBottom);
end;

procedure jDrawingView.DrawFrame(bitMap: jObject; srcX, srcY, srcW, srcH, X, Y, W, H: Integer; rotateDegree: Single);
begin
  if FInitialized then
    jDrawingView_DrawFrame(FjEnv, FjObject, bitMap, srcX, srcY, srcW, srcH, X, Y, W, H, rotateDegree);
end;

procedure jDrawingView.DrawFrame(bitMap: jObject; X, Y, Index, Size: LongInt; scaleFactor: Single; rotateDegree: Single);
begin
  if FInitialized then
    jDrawingView_DrawFrame(FjEnv, FjObject, bitMap, X, Y, Index, Size, scaleFactor, rotateDegree);
end;
*)
procedure jDrawingView.DrawBitmap(bitMap: jObject; srcLeft, srcTop, srcRight, srcBottom: Integer; dstLeft, dstTop, dstRight, dstBottom: Single);
begin
  if FInitialized then
    jDrawingView_DrawBitmap(FjEnv, FjObject, bitMap, srcLeft, srcTop, srcRight, srcBottom, dstLeft, dstTop, dstRight, dstBottom);
end;

procedure jDrawingView.DrawFrame(bitMap: jObject; srcX, srcY, srcW, srcH: Integer; X, Y, W, H, rotateDegree: Single);
begin
  if FInitialized then
    jDrawingView_DrawFrame(FjEnv, FjObject, bitMap, srcX, srcY, srcW, srcH, X, Y, W, H, rotateDegree);
end;

procedure jDrawingView.DrawFrame(bitMap: jObject; X, Y: Single; Index, Size: Integer; scaleFactor: Single; rotateDegree: Single);
begin
  if FInitialized then
    jDrawingView_DrawFrame(FjEnv, FjObject, bitMap, X, Y, Index, Size, scaleFactor, rotateDegree);
end;

procedure jDrawingView.DrawBitmap(_bitmap: jObject; _width: integer; _height: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawBitmap(FjEnv, FjObject, _bitmap ,_width ,_height);
end;

procedure jDrawingView.DrawBitmap(_bitmap: jObject; _left: integer; _top: integer; _right: integer; _bottom: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawBitmap(FjEnv, FjObject, _bitmap ,_left ,_top ,_right ,_bottom);
end;

procedure jDrawingView.SetPaintStrokeWidth(_width: single);
begin
  //in designing component state: set value here...
  FPaintStrokeWidth:= _width;
  if FInitialized then
     jDrawingView_SetPaintWidth(FjEnv, FjObject, _width);
end;

procedure jDrawingView.SetPaintStyle(_style: TPaintStyle);
begin
  //in designing component state: set value here...
  FPaintStyle:=  _style;
  if FInitialized then
     jDrawingView_SetPaintStyle(FjEnv, FjObject, Ord(_style));
end;

procedure jDrawingView.SetPaintColor(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  FFontColor:= _color;
  if FInitialized then
     jDrawingView_SetPaintColor(FjEnv, FjObject, GetARGB(FCustomColor, FFontColor));
end;

procedure jDrawingView.SetTextSize(_textsize: DWord);
begin
  //in designing component state: set value here...
  FFontSize:= _textSize;
  if FInitialized then
     jDrawingView_SetTextSize(FjEnv, FjObject, _textSize);
end;

procedure jDrawingView.DrawLine(_x1: single; _y1: single; _x2: single; _y2: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawLine(FjEnv, FjObject, _x1 ,_y1 ,_x2 ,_y2);
end;

procedure jDrawingView.DrawText(_text: string; _x: single; _y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawText(FjEnv, FjObject, _text ,_x ,_y);
end;

procedure jDrawingView.DrawText(_text: string; _x: single; _y: single; _angleDegree: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawText(FjEnv, FjObject, _text ,_x ,_y ,_angleDegree);
end;

procedure jDrawingView.DrawBitmap(_bitmap: jObject; _x: single; _y: single; _angleDegree: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawBitmap(FjEnv, FjObject, _bitmap ,_x ,_y ,_angleDegree);
end;

procedure jDrawingView.DrawText(_text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawText(FjEnv, FjObject, _text ,_x ,_y ,_angleDegree ,_rotateCenter);
end;

procedure jDrawingView.GenEvent_OnDrawingViewTouch(Obj: TObject; Act,
  Cnt: Integer; X, Y: array of Single; fligGesture: Integer;
  pinchZoomGestureState: Integer; zoomScaleFactor: Single);
begin
  case Act of
    cTouchDown: if Assigned(FOnTouchDown) then
      FOnTouchDown(Obj, Cnt, X, Y, TFlingGesture(fligGesture), TPinchZoomScaleState(pinchZoomGestureState), zoomScaleFactor);

    cTouchMove: if Assigned(FOnTouchMove) then
      FOnTouchMove(Obj,Cnt, X, Y, TFlingGesture(fligGesture), TPinchZoomScaleState(pinchZoomGestureState), zoomScaleFactor);

    cTouchUp: if Assigned(FOnTouchUp) then
      FOnTouchUp(Obj, Cnt, X, Y, TFlingGesture(fligGesture), TPinchZoomScaleState(pinchZoomGestureState), zoomScaleFactor);

    cClick: if Assigned(FOnClick) then
      FOnClick(Obj, Cnt, X[0], Y[0]);

    cDoubleClick: if Assigned(FOnDoubleClick) then
      FOnDoubleClick(Obj, Cnt, X[0], Y[0]);
  end;
end;

// Event : Java Event -> Pascal
procedure jDrawingView.GenEvent_OnDrawingViewDraw(Obj: TObject; Act,
  Cnt: integer; X, Y: array of Single; fligGesture: integer;
  pinchZoomGestureState: integer; zoomScaleFactor: single);
begin
  if Assigned(FOnDraw) then
      FOnDraw(Obj,Cnt,X,Y,TFlingGesture(fligGesture), TPinchZoomScaleState(pinchZoomGestureState),zoomScaleFactor);
end;

Procedure jDrawingView.GenEvent_OnDrawingViewSizeChanged(Obj: TObject; width: integer; height: integer; oldWidth: integer; oldHeight: integer);
begin
    if Assigned(FOnSizeChanged) then
        FOnSizeChanged(Obj, width, height, oldWidth, oldHeight);
end;

procedure jDrawingView.DrawLine(var _points: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawLine(FjEnv, FjObject, _points);
end;

procedure jDrawingView.DrawLine(_points: array of single);
begin
  if FInitialized then
     jDrawingView_DrawLine(FjEnv, FjObject, _points);
end;

procedure jDrawingView.DrawPoint(_x1: single; _y1: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawPoint(FjEnv, FjObject, _x1 ,_y1);
end;

procedure jDrawingView.DrawCircle(_cx: single; _cy: single; _radius: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawCircle(FjEnv, FjObject, _cx ,_cy ,_radius);
end;

procedure jDrawingView.DrawBackground(_color: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawBackground(FjEnv, FjObject, _color);
end;

procedure jDrawingView.DrawRect(_left: single; _top: single; _right: single; _bottom: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawRect(FjEnv, FjObject, _left ,_top ,_right ,_bottom);
end;

procedure jDrawingView.DrawRect(var _xyArray8: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawRect(FjEnv, FjObject, _xyArray8);
end;

procedure jDrawingView.DrawRect(var _xyArray8: array of single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawRect(FjEnv, FjObject, _xyArray8);
end;

procedure jDrawingView.SetImageByResourceIdentifier(_imageResIdentifier: string);
begin
  //in designing component state: set value here...
  FImageIdentifier:= _imageResIdentifier;
  if FInitialized then
     jDrawingView_SetImageByResourceIdentifier(FjEnv, FjObject, _imageResIdentifier);
end;

procedure jDrawingView.DrawBitmap(_bitmap: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawBitmap(FjEnv, FjObject, _bitmap);
end;

(*
procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _sl, _st, _sr, _sb, _dl, _dt, _dr, _db: Integer);
var
  jParams: array [0..8] of jValue;
  jMethod: jMethodID=nil;
  jCls   : jClass=nil;
begin
  jParams[0].l := _bitmap;
  jParams[1].i := _sl;
  jParams[2].i := _st;
  jParams[3].i := _sr;
  jParams[4].i := _sb;
  jParams[5].i := _dl;
  jParams[6].i := _dt;
  jParams[7].i := _dr;
  jParams[8].i := _db;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBitmap', '(Landroid/graphics/Bitmap;IIIIIIII)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawFrame(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _srcX, _srcY, _srcW, _srcH, _X, _Y, _Wh, _Ht: Integer; _rotateDegree: Single);
var
  jParams: array [0..9] of jValue;
  jMethod: jMethodID = nil;
  jCls   : jClass = nil;
begin
  jParams[0].l := _bitmap;
  jParams[1].i := _srcX;
  jParams[2].i := _srcY;
  jParams[3].i := _srcW;
  jParams[4].i := _srcH;
  jParams[5].i := _X;
  jParams[6].i := _Y;
  jParams[7].i := _Wh;
  jParams[8].i := _Ht;
  jParams[9].f := _rotateDegree;
  jCls := env^.GetObjectClass(env, _jdrawingview);
  jMethod := env^.GetMethodID(env, jCls, 'DrawFrame', '(Landroid/graphics/Bitmap;IIIIIIIIF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawFrame(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _X, _Y, _Index, _Size: Integer; _scaleFactor, _rotateDegree: Single);
var
  jParams: array [0..6] of jValue;
  jMethod: jMethodID = nil;
  jCls   : jClass = nil;
begin
  jParams[0].l := _bitmap;
  jParams[1].i := _X;
  jParams[2].i := _Y;
  jParams[3].i := _Index;
  jParams[4].i := _Size;
  jParams[5].f := _scaleFactor;
  jParams[6].f := _rotateDegree;
  jCls := env^.GetObjectClass(env, _jdrawingview);
  jMethod := env^.GetMethodID(env, jCls, 'DrawFrame', '(Landroid/graphics/Bitmap;IIIIFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;
*)
procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _sl, _st, _sr, _sb: Integer; _dl, _dt, _dr, _db: Single);
var
  jParams: array [0..8] of jValue;
  jMethod: jMethodID=nil;
  jCls   : jClass=nil;
begin
  jParams[0].l := _bitmap;
  jParams[1].i := _sl;
  jParams[2].i := _st;
  jParams[3].i := _sr;
  jParams[4].i := _sb;
  jParams[5].f := _dl;
  jParams[6].f := _dt;
  jParams[7].f := _dr;
  jParams[8].f := _db;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBitmap', '(Landroid/graphics/Bitmap;IIIIFFFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,  jCls);
end;

procedure jDrawingView_DrawFrame(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _srcX, _srcY, _srcW, _srcH: Integer; _X, _Y, _Wh, _Ht, _rotateDegree: Single);
var
  jParams: array [0..9] of jValue;
  jMethod: jMethodID = nil;
  jCls   : jClass = nil;
begin
  jParams[0].l := _bitmap;
  jParams[1].i := _srcX;
  jParams[2].i := _srcY;
  jParams[3].i := _srcW;
  jParams[4].i := _srcH;
  jParams[5].f := _X;
  jParams[6].f := _Y;
  jParams[7].f := _Wh;
  jParams[8].f := _Ht;
  jParams[9].f := _rotateDegree;
  jCls := env^.GetObjectClass(env, _jdrawingview);
  jMethod := env^.GetMethodID(env, jCls, 'DrawFrame', '(Landroid/graphics/Bitmap;IIIIFFFFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawFrame(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _X, _Y: Single; _Index, _Size: Integer; _scaleFactor, _rotateDegree: Single);
var
  jParams: array [0..6] of jValue;
  jMethod: jMethodID = nil;
  jCls   : jClass = nil;
begin
  jParams[0].l := _bitmap;
  jParams[1].f := _X;
  jParams[2].f := _Y;
  jParams[3].i := _Index;
  jParams[4].i := _Size;
  jParams[5].f := _scaleFactor;
  jParams[6].f := _rotateDegree;
  jCls := env^.GetObjectClass(env, _jdrawingview);
  jMethod := env^.GetMethodID(env, jCls, 'DrawFrame', '(Landroid/graphics/Bitmap;FFIIFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView.SaveToFile(_filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SaveToFile(FjEnv, FjObject, _filename);
end;

procedure jDrawingView.SaveToFile(_path: string; _filename: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SaveToFile(FjEnv, FjObject, _path ,_filename);
end;

procedure jDrawingView.SetMinZoomFactor(_minZoomFactor: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetMinZoomFactor(FjEnv, FjObject, _minZoomFactor);
end;

procedure jDrawingView.SetMaxZoomFactor(_maxZoomFactor: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetMaxZoomFactor(FjEnv, FjObject, _maxZoomFactor);
end;

(*
procedure jDrawingView.GenEvent_OnFlingGestureDetected(Obj: TObject; direction: integer);
begin
  if Assigned(FOnFling) then  FOnFling(Obj, TFlingGesture(direction));
end;

procedure jDrawingView.GenEvent_OnPinchZoomGestureDetected(Obj: TObject; scaleFactor: single; state: integer);
begin
  if Assigned(FOnPinchGesture) then  FOnPinchGesture(Obj, scaleFactor, TPinchZoomScaleState(state));
end;
*)

procedure jDrawingView.SetTimeClick(Value: Integer);
begin
  FTimeClick := Value;
  if FInitialized then
    jni_proc_ii(FjEnv, FjObject, 'SetTimeClicks', FTimeClick, FTimeDoubleClick);
end;

procedure jDrawingView.SetTimeDoubleClick(Value: Integer);
begin
  FTimeDoubleClick := Value;
  if FInitialized then
    jni_proc_ii(FjEnv, FjObject, 'SetTimeClicks', FTimeClick, FTimeDoubleClick);
end;

function jDrawingView.GetCanvas(): jObject;
begin
  //in designing component state: result value here...
  Result := nil;
  if FInitialized then
    Result := jDrawingView_GetCanvas(FjEnv, FjObject);
end;

procedure jDrawingView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FPaintShader then
    begin
      FPaintShader := nil;
    end
  end;
end;

procedure jDrawingView.SetPaintShader(Value: JPaintShader);
begin
  if Value <> FPaintShader then
  begin
    if Assigned(FPaintShader) then
       FPaintShader.RemoveFreeNotification(Self); //remove free notification...
    FPaintShader := Value;
    if Value <> nil then  //re- add free notification...
       Value.FreeNotification(Self);
  end;
end;

procedure jDrawingView.DrawTextAligned(_text: string; _left: single; _top: single; _right: single; _bottom: single; _alignHorizontal: TTextAlignHorizontal; _alignVertical: TTextAlignVertical);
var
  alignHor, aligVer: single;
begin
  case _alignHorizontal of
    thLeft: alignHor:= 0;
    thRight: alignHor:= 1;
    thCenter:  alignHor:= 0.5;
  end;
  case _alignVertical of
     tvTop: aligVer:= 0;
     tvBottom: aligVer:= 1;
     tvCenter: aligVer:= 0.5
  end;
  if FInitialized then
  begin
    jDrawingView_DrawTextAligned(FjEnv, FjObject, _text, _left, _top, _right, _bottom, alignHor, aligVer);
  end;
end;

function jDrawingView.GetPath(var _points: TDynArrayOfSingle): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetPath(FjEnv, FjObject, _points);
end;

function jDrawingView.GetPath(_points: array of single): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetPath(FjEnv, FjObject, _points);
end;


procedure jDrawingView.DrawPath(_path: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawPath(FjEnv, FjObject, _path);
end;

procedure jDrawingView.DrawPath(var _points: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawPath(FjEnv, FjObject, _points);
end;

procedure jDrawingView.DrawPath(_points: array of single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawPath(FjEnv, FjObject, _points);
end;

procedure jDrawingView.SetPaintStrokeJoin(_strokeJoin: TStrokeJoin);
begin
  //in designing component state: set value here...
  FPaintStrokeJoin:= _strokeJoin;
  if FInitialized then
     jDrawingView_SetPaintStrokeJoin(FjEnv, FjObject, Ord(_strokeJoin));
end;

procedure jDrawingView.SetPaintStrokeCap(_strokeCap: TStrokeCap);
begin
  //in designing component state: set value here...
  FPaintStrokeCap:= _strokeCap;
  if FInitialized then
     jDrawingView_SetPaintStrokeCap(FjEnv, FjObject, Ord(_strokeCap));
end;

procedure jDrawingView.SetPaintCornerPathEffect(_radius: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetPaintCornerPathEffect(FjEnv, FjObject, _radius);
end;

procedure jDrawingView.SetPaintDashPathEffect(_lineDash: single; _dashSpace: single; _phase: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetPaintDashPathEffect(FjEnv, FjObject, _lineDash ,_dashSpace ,_phase);
end;

function jDrawingView.GetPath(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetPath(FjEnv, FjObject);
end;

function jDrawingView.ResetPath(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_ResetPath(FjEnv, FjObject);
end;

function jDrawingView.ResetPath(_path: jObject): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_ResetPath(FjEnv, FjObject, _path);
end;

procedure jDrawingView.AddCircleToPath(_x: single; _y: single; _r: single; _pathDirection: TPathDirection);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_AddCircleToPath(FjEnv, FjObject, _x ,_y ,_r , Ord(_pathDirection));
end;

procedure jDrawingView.AddCircleToPath(_path: jObject; _x: single; _y: single; _r: single; _pathDirection: TPathDirection);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_AddCircleToPath(FjEnv, FjObject, _path ,_x ,_y ,_r ,Ord(_pathDirection));
end;

function jDrawingView.GetNewPath(var _points: TDynArrayOfSingle): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetNewPath(FjEnv, FjObject, _points);
end;

function jDrawingView.GetNewPath(_points: array of single): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetNewPath(FjEnv, FjObject, _points);
end;

function jDrawingView.GetNewPath(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetNewPath(FjEnv, FjObject);
end;

function jDrawingView.AddPointsToPath(_path: jObject; var _points: TDynArrayOfSingle): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_AddPointsToPath(FjEnv, FjObject, _path ,_points);
end;

function jDrawingView.AddPointsToPath(_path: jObject; _points: array of single): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_AddPointsToPath(FjEnv, FjObject, _path ,_points);
end;

function jDrawingView.AddPathToPath(_srcPath: jObject; _targetPath: jObject; _dx: single; _dy: single): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_AddPathToPath(FjEnv, FjObject, _srcPath ,_targetPath ,_dx ,_dy);
end;

procedure jDrawingView.DrawTextOnPath(_path: jObject; _text: string; _xOffset: single; _yOffset: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawTextOnPath(FjEnv, FjObject, _path ,_text ,_xOffset ,_yOffset);
end;

procedure jDrawingView.DrawTextOnPath(_text: string; _xOffset: single; _yOffset: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawTextOnPath(FjEnv, FjObject, _text ,_xOffset ,_yOffset);
end;

procedure jDrawingView.DrawArc(_leftRectF: single; _topRectF: single; _rightRectF: single; _bottomRectF: single; _startAngle: single; _sweepAngle: single; _useCenter: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawArc(FjEnv, FjObject, _leftRectF ,_topRectF ,_rightRectF ,_bottomRectF ,_startAngle ,_sweepAngle ,_useCenter);
end;

procedure jDrawingView.DrawOval(_leftRectF: single; _topRectF: single; _rightRectF: single; _bottomRectF: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawOval(FjEnv, FjObject, _leftRectF ,_topRectF ,_rightRectF ,_bottomRectF);
end;

procedure jDrawingView.DrawTextMultiLine(_text: string; _left: single; _top: single; _right: single; _bottom: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawTextMultiLine(FjEnv, FjObject, _text ,_left ,_top ,_right ,_bottom);
end;

procedure jDrawingView.Invalidate();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_Invalidate(FjEnv, FjObject);
end;

procedure jDrawingView.Clear(_color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_Clear(FjEnv, FjObject, GetARGB(FCustomColor, _color));
end;

procedure jDrawingView.Clear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_Clear(FjEnv, FjObject);
end;

procedure jDrawingView.SetBufferedDraw(_value: boolean);
begin
  //in designing component state: set value here...
  FBufferedDraw:= _value;
  if FInitialized then
     jDrawingView_SetBufferedDraw(FjEnv, FjObject, _value);
end;

function jDrawingView.GetTextHeight(_text: string): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetTextHeight(FjEnv, FjObject, _text);
end;

function jDrawingView.GetTextWidth(_text: string): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetTextWidth(FjEnv, FjObject, _text);
end;

function jDrawingView.GetTextLeft(_text: string): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetTextLeft(FjEnv, FjObject, _text);
end;

function jDrawingView.GetTextBottom(_text: string): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetTextBottom(FjEnv, FjObject, _text);
end;



procedure jDrawingView.SetFontFace(AValue: TFontFace);
begin
 FFontFace:= AValue;
 if(FInitialized) then
   jDrawingView_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));
end;

procedure jDrawingView.SetTextTypeFace(AValue: TTextTypeFace);
begin
  FTextTypeFace:= AValue ;
  if(FInitialized) then
    jDrawingView_SetFontAndTextTypeFace(FjEnv, FjObject, Ord(FFontFace), Ord(FTextTypeFace));
end;

procedure jDrawingView.SetFontFromAssets(_fontName: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetFontFromAssets(FjEnv, FjObject, _fontName);
end;

procedure jDrawingView.DrawTextFromAssetsFont(_text: string; _x: single; _y: single; _assetsFontName: string; _size: integer; _color: TARGBColorBridge);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawTextFromAssetsFont(FjEnv, FjObject, _text ,_x ,_y ,_assetsFontName ,_size ,GetARGB(FCustomColor, _color));
end;

function jDrawingView.GetTextBox(_text: string; _x: single; _y: single): TDynArrayOfSingle;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetTextBox(FjEnv, FjObject, _text ,_x ,_y);
end;

function jDrawingView.GetTextBox(_text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean): TDynArrayOfSingle;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_GetTextBox(FjEnv, FjObject, _text ,_x ,_y ,_angleDegree ,_rotateCenter);
end;

function jDrawingView.DrawTextEx(_text: string; _x: single; _y: single): TDynArrayOfSingle;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_DrawTextEx(FjEnv, FjObject, _text ,_x ,_y);
end;

function jDrawingView.DrawTextEx(_text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean): TDynArrayOfSingle;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_DrawTextEx(FjEnv, FjObject, _text ,_x ,_y ,_angleDegree ,_rotateCenter);
end;

function jDrawingView.DrawTextEx(_text: string; _x: single; _y: single; _angleDegree: single): TDynArrayOfSingle;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_DrawTextEx(FjEnv, FjObject, _text ,_x ,_y ,_angleDegree);
end;

function jDrawingView.DrawTextAlignedEx(_text: string; _left: single; _top: single; _right: single; _bottom: single; _alignHorizontal: single; _alignVertical: single): TDynArrayOfSingle;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jDrawingView_DrawTextAlignedEx(FjEnv, FjObject, _text ,_left ,_top ,_right ,_bottom ,_alignHorizontal ,_alignVertical);
end;

procedure jDrawingView.SetViewportScaleXY(minX: single; maxX: single; minY: single; maxY: single);
begin
    FMinWorldX:= minX;
    FMaxWorldX:= maxX;
    FMinWorldY:= minY;
    FMaxWorldY:= maxY;
    FScaleX:= 0;
    if (maxX-minX) <> 0 then FScaleX:=  (Self.Width)/(maxX-minX);

    FScaleY:= 0;
    if (maxY-minY) <> 0 then FScaleY:= -(Self.Height-10)/(maxY-minY);
end;

function jDrawingView.GetViewportX(_worldX: single): integer;
begin
  //in designing component state: result value here...
  Result:=round(FScaleX*(_worldX - FMinWorldX));
end;

function jDrawingView.GetViewportY(_worldY: single): integer;
begin
  //in designing component state: result value here...
  Result:= 10+round(FScaleY*(_worldY - FMaxWorldY));
end;

function jDrawingView.GetWorldX(_viewportX:integer): single;
begin
   if FScaleX <> 0 then
     Result:=(_viewportX+FScaleX*FMinWorldX)/FScaleX
   else Result:= 0;
end;

function jDrawingView.GetWorldY(_viewportY:integer): single;
begin
   if FScaleY <> 0 then
     Result:=(_viewportY+FScaleY*FMaxWorldY)/FScaleY
   else Result:= 0;
end;


function jDrawingView.GetViewportX(_worldX: single; _minWorldX: single; _maxWorldX: single; _viewportWidth: integer): integer;
var
  escX:real;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
     escX:=(_viewportWidth/(_maxWorldX-_minWorldX));
     Result:=round(escX*(_worldX - _minWorldX));
  end;
end;

function jDrawingView.GetViewportY(_worldY: single; _minWorldY: single; _maxWorldY: single; _viewportHeight: integer): integer;
var
  escY:real;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
     escY:= -(_viewportHeight-10)/(_maxWorldY-_minWorldY);
     Result:= 10+round(escY*(_worldY - _maxWorldY));
  end;
end;

procedure jDrawingView.DrawCroppedBitmap(_bitmap: jObject; _x: single; _y: single; _cropOffsetLeft: integer; _cropOffsetTop: integer; _cropWidth: integer; _cropHeight: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_DrawCroppedBitmap(FjEnv, FjObject, _bitmap ,_x ,_y ,_cropOffsetLeft ,_cropOffsetTop ,_cropWidth ,_cropHeight);
end;

procedure jDrawingView.SetPaintColor(Color: TAlphaColor);
begin
  if FInitialized then
     jDrawingView_SetPaintColor(FjEnv, FjObject, Color);
end;

procedure jDrawingView.DrawRoundRect(Left, Top, Right, Bottom, radiusX, radiusY: Single);
begin
  if FInitialized then
     jDrawingView_DrawRoundRect(FjEnv, FjObject, Left, Top, Right, Bottom, radiusX, radiusY);
end;

function jDrawingView.GetDensity(): Single;
begin
  Result := 1;
  if not FInitialized then Exit;
  Result := jDrawingView_GetDensity(FjEnv, FjObject);
end;

procedure jDrawingView.SetLayerType(Value: TLayerType);
begin
  if FInitialized then
    jDrawingView_SetLayerType(FjEnv, FjObject, Byte(Value));
end;

procedure jDrawingView.ClipRect(Left, Top, Right, Bottom: Single);
begin
  if FInitialized then
    jDrawingView_ClipRect(FjEnv, FjObject, Left, Top, Right, Bottom);
end;

procedure jDrawingView.DrawGrid(Left, Top, Width, Height: Single; cellsX, cellsY: Integer);
begin
  if FInitialized then
    jDrawingView_DrawGrid(FjEnv, FjObject, Left, Top, Width, Height, cellsX, cellsY);
end;

{-------- jDrawingView_JNI_Bridge ----------}

function jDrawingView_jCreate(env: PJNIEnv;_Self: int64; _bufferedDraw: boolean; _backgroundColor: integer; this: jObject): jObject;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].z:= JBool(_bufferedDraw);
  jParams[2].i:= _backgroundColor;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jDrawingView_jCreate', '(JZI)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jDrawingView_jFree(env: PJNIEnv; _jdrawingview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_SetViewParent(env: PJNIEnv; _jdrawingview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_RemoveFromViewParent(env: PJNIEnv; _jdrawingview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_GetView(env: PJNIEnv; _jdrawingview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetLParamWidth(env: PJNIEnv; _jdrawingview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetLParamHeight(env: PJNIEnv; _jdrawingview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jdrawingview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_AddLParamsAnchorRule(env: PJNIEnv; _jdrawingview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_AddLParamsParentRule(env: PJNIEnv; _jdrawingview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetLayoutAll(env: PJNIEnv; _jdrawingview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_ClearLayoutAll(env: PJNIEnv; _jdrawingview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetId(env: PJNIEnv; _jdrawingview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_GetDrawingCache(env: PJNIEnv; _jdrawingview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDrawingCache', '()Landroid/graphics/Bitmap;');
  Result:= env^.CallObjectMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_GetPaint(env: PJNIEnv; _jdrawingview: JObject): jObject;
var
  jMethod: jMethodID = nil;
  jCls   : jClass = nil;
begin
  jCls := env^.GetObjectClass(env, _jdrawingview);
  jMethod := env^.GetMethodID(env, jCls, 'GetPaint', '()Landroid/graphics/Paint;');
  Result := env^.CallObjectMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_GetHeight(env: PJNIEnv; _jdrawingview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetHeight', '()I');
  Result:= env^.CallIntMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_GetWidth(env: PJNIEnv; _jdrawingview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetWidth', '()I');
  Result:= env^.CallIntMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _width: integer; _height: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].i:= _width;
  jParams[2].i:= _height;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBitmap', '(Landroid/graphics/Bitmap;II)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _left: integer; _top: integer; _right: integer; _bottom: integer);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].i:= _left;
  jParams[2].i:= _top;
  jParams[3].i:= _right;
  jParams[4].i:= _bottom;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBitmap', '(Landroid/graphics/Bitmap;IIII)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetPaintWidth(env: PJNIEnv; _jdrawingview: JObject; _width: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _width;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintWidth', '(F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetPaintStyle(env: PJNIEnv; _jdrawingview: JObject; _style: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _style;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintStyle', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetPaintColor(env: PJNIEnv; _jdrawingview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintColor', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetTextSize(env: PJNIEnv; _jdrawingview: JObject; _textSize: DWord);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _textSize;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTextSize', '(F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetTypeface(env: PJNIEnv; _jdrawingview: JObject; _typeface: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _typeface;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTypeface', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawLine(env: PJNIEnv; _jdrawingview: JObject; _x1: single; _y1: single; _x2: single; _y2: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _x1;
  jParams[1].f:= _y1;
  jParams[2].f:= _x2;
  jParams[3].f:= _y2;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawLine', '(FFFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;
(*
procedure jDrawingView_DrawText(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  //jParams[0].l:= env^.NewStringUTF(env, PChar(_text)); //problem while displaying Cyrillic
  jParams[0].l:= env^.NewString(env, PjChar(UTF8Decode(_text)), Length(_text)); // fix by Kordal!!
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '(Ljava/lang/String;FF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;
*)

//by Kordal
procedure jDrawingView_DrawText(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  byteArray: jByteArray;
  //AStr: AnsiString;
begin
  //jParams[0].l:= env^.NewStringUTF(env, PChar(_Text)); //  works well with ASCII, but with other encodings, sometimes it works with errors, the application crashes
  //jParams[0].l:= env^.NewString{UTF}(env, PJChar(UTF8Decode(_Text)), Length(_text)); // sometimes the tail appears as unnecessary text characters
  byteArray:= env^.NewByteArray(env, Length(_text));  // allocate
  env^.SetByteArrayRegion(env, byteArray, 0, Length(_text), PJByte(_text));
  jParams[0].l := byteArray;
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '([BFF)V' {'(Ljava/lang/String;FF)V'});
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawText(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _angle: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].f:= _angle;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '(Ljava/lang/String;FFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawLine(env: PJNIEnv; _jdrawingview: JObject; var _points: TDynArrayOfSingle);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawLine', '([F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawLine(env: PJNIEnv; _jdrawingview: JObject; var _points: array of single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawLine', '([F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawPoint(env: PJNIEnv; _jdrawingview: JObject; _x1: single; _y1: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _x1;
  jParams[1].f:= _y1;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPoint', '(FF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawCircle(env: PJNIEnv; _jdrawingview: JObject; _cx: single; _cy: single; _radius: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _cx;
  jParams[1].f:= _cy;
  jParams[2].f:= _radius;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawCircle', '(FFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawBackground(env: PJNIEnv; _jdrawingview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBackground', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawRect(env: PJNIEnv; _jdrawingview: JObject; _left: single; _top: single; _right: single; _bottom: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _left;
  jParams[1].f:= _top;
  jParams[2].f:= _right;
  jParams[3].f:= _bottom;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRect', '(FFFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_SetImageByResourceIdentifier(env: PJNIEnv; _jdrawingview: JObject; _imageResIdentifier: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_imageResIdentifier));
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetImageByResourceIdentifier', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBitmap', '(Landroid/graphics/Bitmap;)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_SaveToFile(env: PJNIEnv; _jdrawingview: JObject; _filename: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SaveToFile(env: PJNIEnv; _jdrawingview: JObject; _path: string; _filename: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_path));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_filename));
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SaveToFile', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_SetMinZoomFactor(env: PJNIEnv; _jdrawingview: JObject; _minZoomFactor: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _minZoomFactor;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMinZoomFactor', '(F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetMaxZoomFactor(env: PJNIEnv; _jdrawingview: JObject; _maxZoomFactor: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _maxZoomFactor;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMaxZoomFactor', '(F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_GetCanvas(env: PJNIEnv; _jdrawingview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetCanvas', '()Landroid/graphics/Canvas;');
  Result:= env^.CallObjectMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawTextAligned(env: PJNIEnv; _jdrawingview: JObject; _text: string; _left: single; _top: single; _right: single; _bottom: single; _alignHorizontal: single; _alignVertical: single);
var
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _left;
  jParams[2].f:= _top;
  jParams[3].f:= _right;
  jParams[4].f:= _bottom;
  jParams[5].f:= _alignHorizontal;
  jParams[6].f:= _alignVertical;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextAligned', '(Ljava/lang/String;FFFFFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_GetPath(env: PJNIEnv; _jdrawingview: JObject; var _points: TDynArrayOfSingle): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPath', '([F)Landroid/graphics/Path;');
  Result:= env^.CallObjectMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_GetPath(env: PJNIEnv; _jdrawingview: JObject; _points: array of single): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPath', '([F)Landroid/graphics/Path;');
  Result:= env^.CallObjectMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _path;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPath', '(Landroid/graphics/Path;)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawPath(env: PJNIEnv; _jdrawingview: JObject; var _points: TDynArrayOfSingle);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPath', '([F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawPath(env: PJNIEnv; _jdrawingview: JObject; _points: array of single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPath', '([F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_SetPaintStrokeJoin(env: PJNIEnv; _jdrawingview: JObject; _strokeJoin: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _strokeJoin;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintStrokeJoin', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetPaintStrokeCap(env: PJNIEnv; _jdrawingview: JObject; _strokeCap: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _strokeCap;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintStrokeCap', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_SetPaintCornerPathEffect(env: PJNIEnv; _jdrawingview: JObject; _radius: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _radius;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintCornerPathEffect', '(F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetPaintDashPathEffect(env: PJNIEnv; _jdrawingview: JObject; _lineDash: single; _dashSpace: single; _phase: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _lineDash;
  jParams[1].f:= _dashSpace;
  jParams[2].f:= _phase;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetPaintDashPathEffect', '(FFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_GetPath(env: PJNIEnv; _jdrawingview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPath', '()Landroid/graphics/Path;');
  Result:= env^.CallObjectMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_ResetPath(env: PJNIEnv; _jdrawingview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'ResetPath', '()Landroid/graphics/Path;');
  Result:= env^.CallObjectMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_ResetPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _path;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'ResetPath', '(Landroid/graphics/Path;)Landroid/graphics/Path;');
  Result:= env^.CallObjectMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_AddCircleToPath(env: PJNIEnv; _jdrawingview: JObject; _x: single; _y: single; _r: single; _pathDirection: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _x;
  jParams[1].f:= _y;
  jParams[2].f:= _r;
  jParams[3].i:= _pathDirection;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddCircleToPath', '(FFFI)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_AddCircleToPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject; _x: single; _y: single; _r: single; _pathDirection: integer);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _path;
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].f:= _r;
  jParams[4].i:= _pathDirection;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddCircleToPath', '(Landroid/graphics/Path;FFFI)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_GetNewPath(env: PJNIEnv; _jdrawingview: JObject; var _points: TDynArrayOfSingle): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNewPath', '([F)Landroid/graphics/Path;');
  Result:= env^.CallObjectMethodA(env, _jdrawingview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_GetNewPath(env: PJNIEnv; _jdrawingview: JObject; _points: array of single): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNewPath', '([F)Landroid/graphics/Path;');
  Result:= env^.CallObjectMethodA(env, _jdrawingview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_GetNewPath(env: PJNIEnv; _jdrawingview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetNewPath', '()Landroid/graphics/Path;');
  Result:= env^.CallObjectMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_AddPointsToPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject; var _points: TDynArrayOfSingle): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].l:= _path;
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddPointsToPath', '(Landroid/graphics/Path;[F)Landroid/graphics/Path;');
  Result:= env^.CallObjectMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_AddPointsToPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject; _points: array of single): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].l:= _path;
  newSize0:= Length(_points);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_points[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddPointsToPath', '(Landroid/graphics/Path;[F)Landroid/graphics/Path;');
  Result:= env^.CallObjectMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_AddPathToPath(env: PJNIEnv; _jdrawingview: JObject; _srcPath: jObject; _targetPath: jObject; _dx: single; _dy: single): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _srcPath;
  jParams[1].l:= _targetPath;
  jParams[2].f:= _dx;
  jParams[3].f:= _dy;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddPathToPath', '(Landroid/graphics/Path;Landroid/graphics/Path;FF)Landroid/graphics/Path;');
  Result:= env^.CallObjectMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawTextOnPath(env: PJNIEnv; _jdrawingview: JObject; _path: jObject; _text: string; _xOffset: single; _yOffset: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _path;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[2].f:= _xOffset;
  jParams[3].f:= _yOffset;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextOnPath', '(Landroid/graphics/Path;Ljava/lang/String;FF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawTextOnPath(env: PJNIEnv; _jdrawingview: JObject; _text: string; _xOffset: single; _yOffset: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _xOffset;
  jParams[2].f:= _yOffset;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextOnPath', '(Ljava/lang/String;FF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawArc(env: PJNIEnv; _jdrawingview: JObject; _leftRectF: single; _topRectF: single; _rightRectF: single; _bottomRectF: single; _startAngle: single; _sweepAngle: single; _useCenter: boolean);
var
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _leftRectF;
  jParams[1].f:= _topRectF;
  jParams[2].f:= _rightRectF;
  jParams[3].f:= _bottomRectF;
  jParams[4].f:= _startAngle;
  jParams[5].f:= _sweepAngle;
  jParams[6].z:= JBool(_useCenter);
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawArc', '(FFFFFFZ)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_DrawOval(env: PJNIEnv; _jdrawingview: JObject; _leftRectF: single; _topRectF: single; _rightRectF: single; _bottomRectF: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _leftRectF;
  jParams[1].f:= _topRectF;
  jParams[2].f:= _rightRectF;
  jParams[3].f:= _bottomRectF;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawOval', '(FFFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _x: single; _y: single; _angleDegree: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].f:= _angleDegree;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawBitmap', '(Landroid/graphics/Bitmap;FFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawText(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].f:= _angleDegree;
  jParams[4].z:= JBool(_rotateCenter);
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '(Ljava/lang/String;FFFZ)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawTextMultiLine(env: PJNIEnv; _jdrawingview: JObject; _text: string; _left: single; _top: single; _right: single; _bottom: single);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _left;
  jParams[2].f:= _top;
  jParams[3].f:= _right;
  jParams[4].f:= _bottom;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextMultiLine', '(Ljava/lang/String;FFFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_Invalidate(env: PJNIEnv; _jdrawingview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'Invalidate', '()V');
  env^.CallVoidMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_Clear(env: PJNIEnv; _jdrawingview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_Clear(env: PJNIEnv; _jdrawingview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'Clear', '()V');
  env^.CallVoidMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_SetBufferedDraw(env: PJNIEnv; _jdrawingview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBufferedDraw', '(Z)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_GetTextHeight(env: PJNIEnv; _jdrawingview: JObject; _text: string): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextHeight', '(Ljava/lang/String;)F');
  Result:= env^.CallFloatMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_GetTextWidth(env: PJNIEnv; _jdrawingview: JObject; _text: string): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextWidth', '(Ljava/lang/String;)F');
  Result:= env^.CallFloatMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

//LMB
function jDrawingView_GetTextLeft(env: PJNIEnv; _jdrawingview: JObject; _text: string): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextLeft', '(Ljava/lang/String;)F');
  Result:= env^.CallFloatMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

//LMB
function jDrawingView_GetTextBottom(env: PJNIEnv; _jdrawingview: JObject; _text: string): single;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextBottom', '(Ljava/lang/String;)F');
  Result:= env^.CallFloatMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jDrawingView_SetFontAndTextTypeFace(env: PJNIEnv; _jdrawingview: JObject; _fontFace: integer; _fontStyle: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _fontFace;
  jParams[1].i:= _fontStyle;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontAndTextTypeFace', '(II)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_SetFontFromAssets(env: PJNIEnv; _jdrawingview: JObject; _fontName: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fontName));
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFontFromAssets', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawTextFromAssetsFont(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _assetsFontName: string; _size: integer; _color: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].l:= env^.NewStringUTF(env, PChar(_assetsFontName));
  jParams[4].i:= _size;
  jParams[5].i:= _color;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextFromAssetsFont', '(Ljava/lang/String;FFLjava/lang/String;II)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_SetBackgroundColor(env: PJNIEnv; _jdrawingview: JObject; _backgroundColor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _backgroundColor;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetBackgroundColor', '(I)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_GetTextBox(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single): TDynArrayOfSingle;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextBox', '(Ljava/lang/String;FF)[F');
  jResultArray:= env^.CallObjectMethodA(env, _jdrawingview, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetFloatArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_DrawTextEx(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single): TDynArrayOfSingle;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextEx', '(Ljava/lang/String;FF)[F');
  jResultArray:= env^.CallObjectMethodA(env, _jdrawingview, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetFloatArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_DrawTextEx(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean): TDynArrayOfSingle;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].f:= _angleDegree;
  jParams[4].z:= JBool(_rotateCenter);
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextEx', '(Ljava/lang/String;FFFZ)[F');
  jResultArray:= env^.CallObjectMethodA(env, _jdrawingview, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetFloatArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_DrawTextEx(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _angleDegree: single): TDynArrayOfSingle;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].f:= _angleDegree;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextEx', '(Ljava/lang/String;FFF)[F');
  jResultArray:= env^.CallObjectMethodA(env, _jdrawingview, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetFloatArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jDrawingView_DrawTextAlignedEx(env: PJNIEnv; _jdrawingview: JObject; _text: string; _left: single; _top: single; _right: single; _bottom: single; _alignHorizontal: single; _alignVertical: single): TDynArrayOfSingle;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _left;
  jParams[2].f:= _top;
  jParams[3].f:= _right;
  jParams[4].f:= _bottom;
  jParams[5].f:= _alignHorizontal;
  jParams[6].f:= _alignVertical;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawTextAlignedEx', '(Ljava/lang/String;FFFFFF)[F');
  jResultArray:= env^.CallObjectMethodA(env, _jdrawingview, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetFloatArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_GetTextBox(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single; _angleDegree: single; _rotateCenter: boolean): TDynArrayOfSingle;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].f:= _angleDegree;
  jParams[4].z:= JBool(_rotateCenter);
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTextBox', '(Ljava/lang/String;FFFZ)[F');
  jResultArray:= env^.CallObjectMethodA(env, _jdrawingview, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetFloatArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

(*
procedure jDrawingView_DrawRect(env: PJNIEnv; _jdrawingview: JObject; _P0x: single; _P0y: single; _P1x: single; _P1y: single; _P2x: single; _P2y: single; _P3x: single; _P3y: single);
var
  jParams: array[0..7] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _P0x;
  jParams[1].f:= _P0y;
  jParams[2].f:= _P1x;
  jParams[3].f:= _P1y;
  jParams[4].f:= _P2x;
  jParams[5].f:= _P2y;
  jParams[6].f:= _P3x;
  jParams[7].f:= _P3y;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRect', '(FFFFFFFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;
*)

procedure jDrawingView_DrawRect(env: PJNIEnv; _jdrawingview: JObject; var _xyArray8: TDynArrayOfSingle);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_xyArray8);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_xyArray8[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRect', '([F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawRect(env: PJNIEnv; _jdrawingview: JObject; var _xyArray8: array of single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_xyArray8);
  jNewArray0:= env^.NewFloatArray(env, newSize0);  // allocate
  env^.SetFloatArrayRegion(env, jNewArray0, 0 , newSize0, @_xyArray8[0] {source});
  jParams[0].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRect', '([F)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawCroppedBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject; _x: single; _y: single; _cropOffsetLeft: integer; _cropOffsetTop: integer; _cropWidth: integer; _cropHeight: integer);
var
  jParams: array[0..6] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _bitmap;
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jParams[3].i:= _cropOffsetLeft;
  jParams[4].i:= _cropOffsetTop;
  jParams[5].i:= _cropWidth;
  jParams[6].i:= _cropHeight;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawCroppedBitmap', '(Landroid/graphics/Bitmap;FFIIII)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawRoundRect(env: PJNIEnv; _jdrawingview: JObject; _left, _top, _right, _bottom, _rx, _ry: Single);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID = nil;
  jCls   : jClass = nil;
begin
  jParams[0].f:= _left;
  jParams[1].f:= _top;
  jParams[2].f:= _right;
  jParams[3].f:= _bottom;
  jParams[4].f:= _rx;
  jParams[5].f:= _ry;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRoundRect', '(FFFFFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_DrawGrid(env: PJNIEnv; _jdrawingview: JObject; _left, _top, _width, _height: Single; _cellsX, _cellsY: Integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID = nil;
  jCls   : jClass = nil;
begin
  jParams[0].f:= _left;
  jParams[1].f:= _top;
  jParams[2].f:= _width;
  jParams[3].f:= _height;
  jParams[4].i:= _cellsX;
  jParams[5].i:= _cellsY;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawGrid', '(FFFFII)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jDrawingView_GetDensity(env: PJNIEnv; _jdrawingview: JObject): Single;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDensity', '()F');
  Result:= env^.CallFloatMethod(env, _jdrawingview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_ClipRect(env: PJNIEnv; _jdrawingview: JObject; Left, Top, Right, Bottom: Single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID = nil;
  jCls   : jClass = nil;
begin
  jParams[0].f:= Left;
  jParams[0].f:= Top;
  jParams[0].f:= Right;
  jParams[0].f:= Bottom;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClipRect', '(FFFF)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jDrawingView_SetLayerType(env: PJNIEnv; _jdrawingview: JObject; _Value: JByte);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID = nil;
  jCls   : jClass = nil;
begin
  jParams[0].b:= _Value;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayerType', '(B)V');
  env^.CallVoidMethodA(env, _jdrawingview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
