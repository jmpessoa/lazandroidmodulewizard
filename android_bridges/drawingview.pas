unit drawingview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

 //TOnDrawing  = Procedure(Sender: TObject) of object;

{Draft Component code by "Lazarus Android Module Wizard" [5/20/2016 4:14:09]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jDrawingView = class(jVisualControl)    //jDrawingView   jGraphicsView
 private
    FOnDraw      : TOnTouchExtended;
    FOnTouchDown : TOnTouchExtended;
    FOnTouchMove : TOnTouchExtended;
    FOnTouchUp   : TOnTouchExtended;

    FPaintStrokeWidth: single;
    FPaintStyle: TPaintStyle;
    FPaintColor: TARGBColorBridge;

    FImageIdentifier: string;

    FMinZoomFactor: single;
    FMaxZoomFactor: single;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;

    function GetCanvas(): jObject;
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

   // procedure GenEvent_OnClick(Obj: TObject);
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
    function GetDrawingCache(): jObject;
    function GetImage(): jObject;

    function GetHeight(): integer; override;
    function GetWidth(): integer; override;
    procedure DrawBitmap(_bitmap: jObject; _width: integer; _height: integer); overload;
    procedure DrawBitmap(_bitmap: jObject; _left: integer; _top: integer; _right: integer; _bottom: integer); overload;

    procedure SetTypeface(_typeface: TFontFace);
    procedure SetPaintStrokeWidth(_width: single);
    procedure SetPaintStyle(_style: TPaintStyle);  //TPaintStyle
    procedure SetPaintColor( _color: TARGBColorBridge); //
    procedure SetTextSize(_textsize: DWord);

    procedure DrawLine(_x1: single; _y1: single; _x2: single; _y2: single); overload;
    procedure DrawText(_text: string; _x: single; _y: single);

    procedure DrawLine(var _points: TDynArrayOfSingle); overload;
    procedure DrawPoint(_x1: single; _y1: single);
    procedure DrawCircle(_cx: single; _cy: single; _radius: single);
    procedure DrawBackground(_color: integer);
    procedure DrawRect(_left: single; _top: single; _right: single; _bottom: single);

    procedure SetImageByResourceIdentifier(_imageResIdentifier: string);    // ../res/drawable
    procedure DrawBitmap(_bitmap: jObject);  overload;

    procedure SaveToFile(_filename: string); overload;
    procedure SaveToFile(_path: string; _filename: string);  overload;

    procedure SetMinZoomFactor(_minZoomFactor: single);
    procedure SetMaxZoomFactor(_maxZoomFactor: single);

    procedure DrawTextAligned(_text: string; _left: single; _top: single; _right: single; _bottom: single; _alignHorizontal: TTextAlignHorizontal; _alignVertical: TTextAlignVertical);

    Procedure GenEvent_OnDrawingViewTouch(Obj: TObject; Act, Cnt: integer; X,Y: array of Single;
                                 fligGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);

    Procedure GenEvent_OnDrawingViewDraw(Obj: TObject; Act, Cnt: integer; X,Y: array of Single;
                                 fligGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;

    property FontSize: DWord read FFontSize write SetTextSize;
    property FontFace: TFontFace read FFontFace write SetTypeface;
    property PaintStrokeWidth: single read FPaintStrokeWidth write SetPaintStrokeWidth;
    property PaintStyle: TPaintStyle read FPaintStyle write SetPaintStyle;
    property PaintColor: TARGBColorBridge read FPaintColor write SetPaintColor;

    property ImageIdentifier : string read FImageIdentifier write SetImageByResourceIdentifier;

    property MinPinchZoomFactor: single read FMinZoomFactor write FMinZoomFactor;
    property MaxPinchZoomFactor: single read FMaxZoomFactor write FMaxZoomFactor;
    // Event - Click
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    // Event - Drawing
    property OnDraw      : TOnTouchExtended read FOnDraw write FOnDraw;
    // Event - Touch
    property OnTouchDown : TOnTouchExtended read FOnTouchDown write FOnTouchDown;
    property OnTouchMove : TOnTouchExtended read FOnTouchMove write FOnTouchMove;
    property OnTouchUp   : TOnTouchExtended read FOnTouchUp   write FOnTouchUp;

end;

function jDrawingView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
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
procedure jDrawingView_DrawText(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single);

procedure jDrawingView_DrawLine(env: PJNIEnv; _jdrawingview: JObject; var _points: TDynArrayOfSingle); overload;
procedure jDrawingView_DrawPoint(env: PJNIEnv; _jdrawingview: JObject; _x1: single; _y1: single);
procedure jDrawingView_DrawCircle(env: PJNIEnv; _jdrawingview: JObject; _cx: single; _cy: single; _radius: single);
procedure jDrawingView_DrawBackground(env: PJNIEnv; _jdrawingview: JObject; _color: integer);
procedure jDrawingView_DrawRect(env: PJNIEnv; _jdrawingview: JObject; _left: single; _top: single; _right: single; _bottom: single);

procedure jDrawingView_SetImageByResourceIdentifier(env: PJNIEnv; _jdrawingview: JObject; _imageResIdentifier: string);
procedure jDrawingView_DrawBitmap(env: PJNIEnv; _jdrawingview: JObject; _bitmap: jObject);  overload;
procedure jDrawingView_SaveToFile(env: PJNIEnv; _jdrawingview: JObject; _filename: string); overload;
procedure jDrawingView_SaveToFile(env: PJNIEnv; _jdrawingview: JObject; _path: string; _filename: string); overload;
procedure jDrawingView_SetMinZoomFactor(env: PJNIEnv; _jdrawingview: JObject; _minZoomFactor: single);
procedure jDrawingView_SetMaxZoomFactor(env: PJNIEnv; _jdrawingview: JObject; _maxZoomFactor: single);

function jDrawingView_GetCanvas(env: PJNIEnv; _jdrawingview: JObject): jObject;
procedure jDrawingView_DrawTextAligned(env: PJNIEnv; _jdrawingview: JObject; _text: string; _left: single; _top: single; _right: single; _bottom: single; _alignHorizontal: single; _alignVertical: single);


implementation

uses
   customdialog, toolbar;

{---------  jDrawingView  --------------}

constructor jDrawingView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FMarginLeft   := 10;
  FMarginTop    := 10;
  FMarginBottom := 10;
  FMarginRight  := 10;
  FLParamWidth  := lpWrapContent; //lpMatchParent;
  FLParamHeight := lpWrapContent;
  FHeight       := 100;
  FWidth        := 100;
  FAcceptChildrenAtDesignTime:= False;

//your code here....
(*  FMouches.Mouch.Active := False;
  FMouches.Mouch.Start  := False;
  FMouches.Mouch.Zoom   := 1.0;
  FMouches.Mouch.Angle  := 0.0; *)

  FFontFace:= ffNormal;
  FFontSize:= 20;
  FPaintStrokeWidth:= 1;
  FPaintStyle:= psFillAndStroke;
  FPaintColor:= colbrRed;

  FMinZoomFactor:= 1/4;
  FMaxZoomFactor:= 8/2;

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
  aWidth,aHeight:DWORD;
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
  jDrawingView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jDrawingView_SetId(FjEnv, FjObject, Self.Id);

  aWidth  := GetLayoutParams(gApp, FLParamWidth, sdW);
  aHeight := GetLayoutParams(gApp, FLParamHeight, sdH);
  if LayoutParamWidth = lpExact then aWidth := FWidth;
  if LayoutParamHeight = lpExact then aHeight := FHeight;
  jDrawingView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        aWidth,
                        aHeight);

  if FParent is jPanel then
  begin
    Self.UpdateLayout;
  end;

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

  jDrawingView_SetPaintWidth(FjEnv, FjObject, FPaintStrokeWidth);
  jDrawingView_SetPaintStyle(FjEnv, FjObject, ord(FPaintStyle));
  jDrawingView_SetPaintColor(FjEnv, FjObject, GetARGB(FCustomColor, FPaintColor));
  jDrawingView_SetTextSize(FjEnv, FjObject, FFontSize);
  jDrawingView_SetTypeface(FjEnv, FjObject, Ord(FFontFace));

  if FImageIdentifier <> '' then
     jDrawingView_SetImageByResourceIdentifier(FjEnv, FjObject , FImageIdentifier);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jDrawingView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jDrawingView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jDrawingView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin

    if LayoutParamWidth = lpExact then jDrawingView_setLParamWidth(FjEnv, FjObject , FWidth) else
    begin

      if Self.Parent is jForm then
      begin
        if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
        jDrawingView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
      end
      else
      begin
        if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
          jDrawingView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
        else //lpMatchParent or others
          jDrawingView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
      end;

    end;
  end;
end;

procedure jDrawingView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin

    if LayoutParamHeight = lpExact then jDrawingView_setLParamHeight(FjEnv, FjObject , FHeight) else
    begin

      if Self.Parent is jForm then
      begin
        if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
        jDrawingView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
      end
      else
      begin
        if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
          jDrawingView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
        else //lpMatchParent and others
          jDrawingView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
      end;

    end;
  end;
end;

procedure jDrawingView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
    jDrawingView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jDrawingView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jDrawingView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jDrawingView_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jDrawingView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jDrawingView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
(*
procedure jDrawingView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jDrawingView.jCreate(): jObject;
begin
   Result:= jDrawingView_jCreate(FjEnv, int64(Self), FjThis);
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

procedure jDrawingView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jDrawingView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jDrawingView_SetId(FjEnv, FjObject, _id);
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

function jDrawingView.GetWidth(): integer;
var
   r: DWord;
begin
   r:= FWidth;
   if FInitialized then
   begin
      r:= jDrawingView_GetWidth(FjEnv, FjObject );
      if r = TLayoutParamsArray[altMATCHPARENT] then //lpMatchParent
      begin
          if FParent is jForm then r:= (FParent as jForm).ScreenWH.Width
          else r:= Self.Parent.Width;
      end;
   end;
   Result:= r;
end;

function jDrawingView.GetHeight(): integer;
var
  r: DWord;
begin
   r:= FHeight;
   if FInitialized then
   begin
     r:= jDrawingView_GetHeight(FjEnv, FjObject );
     if r = TLayoutParamsArray[altMATCHPARENT] then //lpMatchParent
     begin
       if FParent is jForm then r:= (FParent as jForm).ScreenWH.Height
       else r:= Self.Parent.Height;
     end;
   end;
   Result:= r;
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

procedure jDrawingView.SetTextSize(_textSize: DWord);
begin
  //in designing component state: set value here...
  FFontSize:= _textSize;
  if FInitialized then
     jDrawingView_SetTextSize(FjEnv, FjObject, _textSize);
end;

procedure jDrawingView.SetTypeface(_typeface: TFontFace);
begin
  //in designing component state: set value here...
  FFontFace:= _typeface;
  if FInitialized then
     jDrawingView_SetTypeface(FjEnv, FjObject, Ord(_typeface));
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

(*
// Event : Java Event -> Pascal
Procedure jDrawingView.GenEvent_OnTouch(Obj: TObject; Act,Cnt: integer; X1,Y1,X2,Y2: Single);
begin
  case Act of
   cTouchDown : VHandler_touchesBegan_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchDown,FMouches);
   cTouchMove : VHandler_touchesMoved_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchMove,FMouches);
   cTouchUp   : VHandler_touchesEnded_withEvent(Obj,Cnt,fXY(X1,Y1),fXY(X2,Y2),FOnTouchUp  ,FMouches);
  end;
end;
*)

Procedure jDrawingView.GenEvent_OnDrawingViewTouch(Obj: TObject; Act, Cnt: integer; X,Y: array of single;
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
// Event : Java Event -> Pascal

Procedure jDrawingView.GenEvent_OnDrawingViewDraw(Obj: TObject; Act, Cnt: integer; X,Y: array of Single;
                             fligGesture: integer; pinchZoomGestureState: integer; zoomScaleFactor: single);
begin
  if Assigned(FOnDraw) then
      FOnDraw(Obj,Cnt,X,Y,TFlingGesture(fligGesture), TPinchZoomScaleState(pinchZoomGestureState),zoomScaleFactor)
end;

procedure jDrawingView.DrawLine(var _points: TDynArrayOfSingle);
begin
  //in designing component state: set value here...
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

function jDrawingView.GetCanvas(): jObject;
begin
  //in designing component state: result value here...
  Result:= nil;
  if FInitialized then
   Result:= jDrawingView_GetCanvas(FjEnv, FjObject);
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

{-------- jDrawingView_JNI_Bridge ----------}

function jDrawingView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jDrawingView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jDrawingView_jCreate(long _Self) {
      return (java.lang.Object)(new jDrawingView(this,_Self));
   }

//to end of "public class Controls" in "Controls.java"
*)


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
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
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


procedure jDrawingView_DrawText(env: PJNIEnv; _jdrawingview: JObject; _text: string; _x: single; _y: single);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_text));
  jParams[1].f:= _x;
  jParams[2].f:= _y;
  jCls:= env^.GetObjectClass(env, _jdrawingview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawText', '(Ljava/lang/String;FF)V');
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

end.
