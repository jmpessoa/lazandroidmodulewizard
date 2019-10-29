unit copenmapview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, {And_jni_Bridge,} AndroidWidget, systryparent;

type

TRoadStatus = (rsOk, rsInvalid, rsTechnicalIssue, rdNoPossible);
TTileSource = (tsMapNik, tsHikeBikeMap, tsOpenTopo);

TOnOpenMapViewClick=procedure(Sender:TObject;latitude:double;longitude:double) of object;
TOnOpenMapViewLongClick=procedure(Sender:TObject;latitude:double;longitude:double) of object;
TOnOpenMapViewRoadDraw=procedure(Sender: TObject; roadCode: integer; roadStatus: TRoadStatus; roadDuration: double; roadLength: double; out outColor: TARGBColorBridge; out outWidth: integer) of object;
TOnOpenMapViewMarkerClick=procedure(Sender:TObject;title:string;latitude:double;longitude:double) of object;


{Draft Component code by "LAMW: Lazarus Android Module Wizard" [5/25/2019 22:51:21]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jcOpenMapView = class(jVisualControl)
 private
    FShowScale: boolean;
    FTileSource: TTileSource;
    FZoom: integer;
    FOnRoadDraw: TOnOpenMapViewRoadDraw;
    FOnOpenMapViewClick: TOnOpenMapViewClick;
    FOnOpenMapViewLongClick: TOnOpenMapViewLongClick;
    FOnOpenMapViewMarkerClick: TOnOpenMapViewMarkerClick;

    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

    procedure GenEvent_OnClick(Obj: TObject);
    function jCreate( _showScale: boolean; _tileSource: integer; _zoom: integer): jObject;
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
    procedure SetZoom(_zoom: integer);
    //function GetZoom(): integer;
    procedure SetShowScale(_show: boolean);
    procedure SetCenter(_latitude: double; _longitude: double);
    procedure SetTileSource(_tileSource: TTileSource);
    procedure ClearOverlays();
    procedure Invalidate();
    procedure DrawCircle(_latitude: double; _longitude: double; _radiusInMetters: double; _title: string; _strokeColor: TARGBColorBridge; _strokeWidth: single);
    procedure SetGroundImageOverlay(_latitude: double; _longitude: double; _imageIdentifier: string; _dimMetters: single);

    procedure DrawRoad(_roadCode: integer); overload;
    procedure DrawRoad();  overload;
    procedure DrawRoad(_roadCode: integer; _geoPointStartIndex: integer; _count: integer); overload;
    procedure DrawRoad(_roadCode: integer; var _latitudeLongitude: TDynArrayOfDouble); overload;

    function GetGeoPoints(): TDynArrayOfDouble;
    function AddGeoPoint(_latitude: double; _longitude: double): integer; overload;
    function AddGeoPoint(_index: integer; _latitude: double; _longitude: double): integer; overload;
    procedure ClearGeoPoints();
    procedure ClearGeoPoint(_index: integer);
    function GetGeoPoint(_index: integer): TDynArrayOfDouble;

    function AddMarker(_latitude: double; _longitude: double; _iconIdentifier: string): integer; overload;
    function AddMarker(_latitude: double; _longitude: double; _title: string; _iconIdentifier: string): integer; overload;
    function AddMarker(_latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string): integer; overload;
    function AddMarker(_latitude: double; _longitude: double; _title: string; _snippetInfo: string; _markerIconIdentifier: string; _snippetImageIdentifier: string): integer; overload;
    function AddMarkers(var _latitudeLongitude: TDynArrayOfDouble; _title: string; _snippetInfo: string; _iconIdentifier: string): integer;overload;
    function AddMarkers(var _latitudeLongitude: TDynArrayOfDouble; _iconIdentifier: string): integer; overload;

    procedure ClearMarker(_index: integer); overload;
    procedure ClearMarkers();
    function GetMarker(_index: integer): jObject;
    function GetMarkersPositions(): TDynArrayOfDouble;
    function GetMarkersCount(): integer;
    function GetMarkerPosition(_index: integer): TDynArrayOfDouble; overload;
    function GetGeoPointsCount(): integer;

    function GetMarkerPosition(_marker: jObject): TDynArrayOfDouble; overload;

    function AddPolygon(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _title: string; _color: TARGBColorBridge; _alphaTransparency: integer): integer; overload;
    function AddPolygon(_geoPointStartIndex: integer; _count: integer; _title: string; _color: TARGBColorBridge; _alphaTransparency: integer): integer; overload;
    function AddPolygon(var _latitudeLongitude: TDynArrayOfDouble; _title: string; _color: TARGBColorBridge; _alphaTransparency: integer): integer; overload;

    function GetPolygonsCount(): integer;
    procedure ClearPolygon(_index: integer);
    procedure ClearPolygons();

    procedure StopPanning();

    procedure SetIsMarkerDraggable(_value: boolean);
    procedure SetMarkerDraggable(_marker: jObject; _draggable: boolean);
    function DrawMarker(_latitude: double; _longitude: double; _title: string; _iconIdentifier: string): jObject; overload;
    function DrawMarker(_latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string): jObject; overload;
    procedure ClearMarker(_marker: jObject); overload;
    procedure MoveMarker(_marker: jObject; _latitude: double; _longitude: double);


    function DrawPolyline(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): jObject; overload;
    function DrawPolyline(_geoPointStartIndex: integer; _count: integer): jObject; overload;
    function DrawLine(_latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double; _strokeColor: integer; _strokeWidth: integer): jObject;
    procedure ClearPolyline(_polyline: jObject);
    function AddLine(_latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double): integer;overload;
    function AddLine(_latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double; _strokeColor: integer; _strokeWidth: integer): integer;overload;
    procedure ClearLine(_line: jObject); overload;
    procedure ClearLine(_index: integer); overload;
    procedure ClearLines();
    function GetLinesCount(): integer;
    procedure SetStrokeColor(_strokeColor: integer);
    procedure SetStrokeWidth(_strokeWidth: single);
    procedure SetFillColor(_fillColor: integer);

    procedure SetMarkerRotation(_marker: jObject; _angleDeg: integer);
    function AddMarker(_latitude: double; _longitude: double; _iconIdentifier: string; _rotationAngleDeg: integer): integer; overload;
    function AddMarker(_latitude: double; _longitude: double; _title: string; _iconIdentifier: string; _rotationAngleDeg: integer): integer; overload;
    procedure SetMarkerXY(_x: single; _y: single);

    procedure GenEvent_OnOpenMapViewRoadDraw(Sender:TObject; roadCode:integer;roadStatus:integer;roadDuration:double; roadDistance:double; out color: dword; out width: integer);
    procedure GenEvent_OnOpenMapViewClick(Sender:TObject;latitude:double;longitude:double);
    procedure GenEvent_OnOpenMapViewLongClick(Sender:TObject;latitude:double;longitude:double);
    procedure GenEvent_OnOpenMapViewMarkerClick(Sender:TObject;title:string;latitude:double;longitude:double);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property ShowScale: boolean read FShowScale write SetShowScale;
    property TileSource: TTileSource read FTileSource write SetTileSource;
    property Zoom: integer read FZoom write SetZoom;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnClick: TOnOpenMapViewClick read FOnOpenMapViewClick write FOnOpenMapViewClick;
    property OnLongClick: TOnOpenMapViewLongClick read FOnOpenMapViewLongClick write FOnOpenMapViewLongClick;
    property OnRoadDraw: TOnOpenMapViewRoadDraw read FOnRoadDraw write FOnRoadDraw;
    property OnMarkerClick: TOnOpenMapViewMarkerClick read FOnOpenMapViewMarkerClick write FOnOpenMapViewMarkerClick;

end;

function jcOpenMapView_jCreate(env: PJNIEnv;_Self: int64; _showScale: boolean; _tileSource: integer; _zoom: integer; this: jObject): jObject;
procedure jcOpenMapView_jFree(env: PJNIEnv; _jcopenmapview: JObject);
procedure jcOpenMapView_SetViewParent(env: PJNIEnv; _jcopenmapview: JObject; _viewgroup: jObject);
function jcOpenMapView_GetParent(env: PJNIEnv; _jcopenmapview: JObject): jObject;
procedure jcOpenMapView_RemoveFromViewParent(env: PJNIEnv; _jcopenmapview: JObject);
function jcOpenMapView_GetView(env: PJNIEnv; _jcopenmapview: JObject): jObject;
procedure jcOpenMapView_SetLParamWidth(env: PJNIEnv; _jcopenmapview: JObject; _w: integer);
procedure jcOpenMapView_SetLParamHeight(env: PJNIEnv; _jcopenmapview: JObject; _h: integer);
function jcOpenMapView_GetLParamWidth(env: PJNIEnv; _jcopenmapview: JObject): integer;
function jcOpenMapView_GetLParamHeight(env: PJNIEnv; _jcopenmapview: JObject): integer;
procedure jcOpenMapView_SetLGravity(env: PJNIEnv; _jcopenmapview: JObject; _g: integer);
procedure jcOpenMapView_SetLWeight(env: PJNIEnv; _jcopenmapview: JObject; _w: single);
procedure jcOpenMapView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcopenmapview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jcOpenMapView_AddLParamsAnchorRule(env: PJNIEnv; _jcopenmapview: JObject; _rule: integer);
procedure jcOpenMapView_AddLParamsParentRule(env: PJNIEnv; _jcopenmapview: JObject; _rule: integer);
procedure jcOpenMapView_SetLayoutAll(env: PJNIEnv; _jcopenmapview: JObject; _idAnchor: integer);
procedure jcOpenMapView_ClearLayoutAll(env: PJNIEnv; _jcopenmapview: JObject);
procedure jcOpenMapView_SetId(env: PJNIEnv; _jcopenmapview: JObject; _id: integer);
procedure jcOpenMapView_SetZoom(env: PJNIEnv; _jcopenmapview: JObject; _zoom: integer);
procedure jcOpenMapView_SetShowScale(env: PJNIEnv; _jcopenmapview: JObject; _show: boolean);
procedure jcOpenMapView_SetCenter(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double);
procedure jcOpenMapView_SetTileSource(env: PJNIEnv; _jcopenmapview: JObject; _tileSource: integer);
procedure jcOpenMapView_ClearOverlays(env: PJNIEnv; _jcopenmapview: JObject);
procedure jcOpenMapView_Invalidate(env: PJNIEnv; _jcopenmapview: JObject);
procedure jcOpenMapView_DrawCircle(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _radiusInMetters: double; _title: string; _strokeColor: integer; _strokeWidth: single);
procedure jcOpenMapView_SetGroundImageOverlay(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _imageIdentifier: string; _dimMetters: single);
procedure jcOpenMapView_DrawRoad(env: PJNIEnv; _jcopenmapview: JObject; _roadCode: integer); overload;
procedure jcOpenMapView_DrawRoad(env: PJNIEnv; _jcopenmapview: JObject); overload;
procedure jcOpenMapView_DrawRoad(env: PJNIEnv; _jcopenmapview: JObject; _roadCode: integer; _geoPointStartIndex: integer; _count: integer); overload;
procedure jcOpenMapView_DrawRoad(env: PJNIEnv; _jcopenmapview: JObject; _roadCode: integer; var _latitudeLongitude: TDynArrayOfDouble); overload;

function jcOpenMapView_GetGeoPoints(env: PJNIEnv; _jcopenmapview: JObject): TDynArrayOfDouble;
function jcOpenMapView_AddGeoPoint(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double): integer; overload;
function jcOpenMapView_AddGeoPoint(env: PJNIEnv; _jcopenmapview: JObject; _index: integer; _latitude: double; _longitude: double): integer; overload;
procedure jcOpenMapView_ClearGeoPoints(env: PJNIEnv; _jcopenmapview: JObject);
procedure jcOpenMapView_ClearGeoPoint(env: PJNIEnv; _jcopenmapview: JObject; _index: integer);
function jcOpenMapView_GetGeoPoint(env: PJNIEnv; _jcopenmapview: JObject; _index: integer): TDynArrayOfDouble;

function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _iconIdentifier: string): integer; overload;
function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _iconIdentifier: string): integer; overload;
function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string): integer; overload;
function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _snippetInfo: string; _markerIconIdentifier: string; _snippetImageIdentifier: string): integer; overload;

procedure jcOpenMapView_ClearMarker(env: PJNIEnv; _jcopenmapview: JObject; _index: integer); overload;
procedure jcOpenMapView_ClearMarkers(env: PJNIEnv; _jcopenmapview: JObject);
function jcOpenMapView_GetMarker(env: PJNIEnv; _jcopenmapview: JObject; _index: integer): jObject;
function jcOpenMapView_GetMarkerPosition(env: PJNIEnv; _jcopenmapview: JObject; _marker: jObject): TDynArrayOfDouble; overload;

function jcOpenMapView_AddPolygon(env: PJNIEnv; _jcopenmapview: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _title: string; _color: integer; _alphaTransparency: integer): integer;overload;

function jcOpenMapView_AddPolygon(env: PJNIEnv; _jcopenmapview: JObject; _geoPointStartIndex: integer; _count: integer;_title: string; _color: integer; _alphaTransparency: integer): integer;overload;
procedure jcOpenMapView_ClearPolygon(env: PJNIEnv; _jcopenmapview: JObject; _index: integer);
procedure jcOpenMapView_ClearPolygons(env: PJNIEnv; _jcopenmapview: JObject);

procedure jcOpenMapView_StopPanning(env: PJNIEnv; _jcopenmapview: JObject);
procedure jcOPenMapView_SetIsMarkerDraggable(env: PJNIEnv; _jcopenmapview: JObject; _value: boolean);
procedure jcOpenMapView_SetMarkerDraggable(env: PJNIEnv; _jcopenmapview: JObject; _marker: jObject; _draggable: boolean);

function jcOpenMapView_DrawMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _iconIdentifier: string): jObject; overload;
function jcOpenMapView_DrawMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string): jObject; overload;
procedure jcOpenMapView_ClearMarker(env: PJNIEnv; _jcopenmapview: JObject; _marker: jObject);overload;
procedure jcOpenMapView_MoveMarker(env: PJNIEnv; _jcopenmapview: JObject; _marker: jObject; _latitude: double; _longitude: double);

function jcOpenMapView_GetMarkersPositions(env: PJNIEnv; _jcopenmapview: JObject): TDynArrayOfDouble;
function jcOpenMapView_GetMarkersCount(env: PJNIEnv; _jcopenmapview: JObject): integer;
function jcOpenMapView_GetMarkerPosition(env: PJNIEnv; _jcopenmapview: JObject; _index: integer): TDynArrayOfDouble; overload;

function jcOpenMapView_GetGeoPointsCount(env: PJNIEnv; _jcopenmapview: JObject): integer;
function jcOpenMapView_AddPolygon(env: PJNIEnv; _jcopenmapview: JObject; var _latitudeLongitude: TDynArrayOfDouble; _title: string; _color: integer; _alphaTransparency: integer): integer; overload;
function jcOpenMapView_GetPolygonsCount(env: PJNIEnv; _jcopenmapview: JObject): integer;

function jcOpenMapView_AddMarkers(env: PJNIEnv; _jcopenmapview: JObject; var _latitudeLongitude: TDynArrayOfDouble; _title: string; _snippetInfo: string; _iconIdentifier: string): integer;overload;
function jcOpenMapView_AddMarkers(env: PJNIEnv; _jcopenmapview: JObject; var _latitudeLongitude: TDynArrayOfDouble; _iconIdentifier: string): integer;overload;

function jcOpenMapView_DrawPolyline(env: PJNIEnv; _jcopenmapview: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): jObject;overload;
function jcOpenMapView_DrawPolyline(env: PJNIEnv; _jcopenmapview: JObject; _geoPointStartIndex: integer; _count: integer): jObject;overload;
function jcOpenMapView_DrawLine(env: PJNIEnv; _jcopenmapview: JObject; _latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double; _strokeColor: integer; _strokeWidth: integer): jObject;
procedure jcOpenMapView_ClearPolyline(env: PJNIEnv; _jcopenmapview: JObject; _polyline: jObject);
function jcOpenMapView_AddLine(env: PJNIEnv; _jcopenmapview: JObject; _latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double): integer;overload;
function jcOpenMapView_AddLine(env: PJNIEnv; _jcopenmapview: JObject; _latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double; _strokeColor: integer; _strokeWidth: integer): integer;overload;
procedure jcOpenMapView_ClearLine(env: PJNIEnv; _jcopenmapview: JObject; _line: jObject);overload;
procedure jcOpenMapView_ClearLine(env: PJNIEnv; _jcopenmapview: JObject; _index: integer);overload;
procedure jcOpenMapView_ClearLines(env: PJNIEnv; _jcopenmapview: JObject);
function jcOpenMapView_GetLinesCount(env: PJNIEnv; _jcopenmapview: JObject): integer;
procedure jcOpenMapView_SetStrokeColor(env: PJNIEnv; _jcopenmapview: JObject; _strokeColor: integer);
procedure jcOpenMapView_SetStrokeWidth(env: PJNIEnv; _jcopenmapview: JObject; _strokeWidth: single);
procedure jcOpenMapView_SetFillColor(env: PJNIEnv; _jcopenmapview: JObject; _fillColor: integer);

procedure jcOpenMapView_SetMarkerRotation(env: PJNIEnv; _jcopenmapview: JObject; _marker: jObject; _angleDeg: integer);
function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _iconIdentifier: string; _rotationAngleDeg: integer): integer;overload;
function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _iconIdentifier: string; _rotationAngleDeg: integer): integer;overload;
procedure jcOpenMapView_SetMarkerXY(env: PJNIEnv; _jcopenmapview: JObject; _x: single; _y: single);

implementation

{---------  jcOpenMapView  --------------}

constructor jcOpenMapView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if gapp <> nil then FId := gapp.GetNewId();
  
  FMarginLeft   := 5;
  FMarginTop    := 5;
  FMarginBottom := 5;
  FMarginRight  := 5;
  FHeight       := 100; //??
  FWidth        := 300; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpOneThirdOfParent; //lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= False;
//your code here....
  FShowScale:=  False;
  FTileSource:= tsMapNik;
  FZoom:= 14;
end;

destructor jcOpenMapView.Destroy;
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

procedure jcOpenMapView.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin

 if not FInitialized then
 begin
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(FShowScale, Ord(FTileSource), FZoom); //jSelf !

  if FjObject = nil then exit;

  if FParent <> nil then
   sysTryNewParent( FjPRLayout, FParent, FjEnv, refApp);

  FjPRLayoutHome:= FjPRLayout;

  jcOpenMapView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jcOpenMapView_SetId(FjEnv, FjObject, Self.Id);
 end;

  jcOpenMapView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        sysGetLayoutParams( FWidth, FLParamWidth, Self.Parent, sdW, fmarginLeft + fmarginRight ),
                        sysGetLayoutParams( FHeight, FLParamHeight, Self.Parent, sdH, fMargintop + fMarginbottom ));

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jcOpenMapView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jcOpenMapView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jcOpenMapView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

 if not FInitialized then
 begin
  FInitialized := true;

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
 end;
end;

procedure jcOpenMapView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jcOpenMapView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jcOpenMapView.UpdateLayout;
begin

  if not FInitialized then exit;

  ClearLayout();

  inherited UpdateLayout;

  init(gApp);

end;

procedure jcOpenMapView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jcOpenMapView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin

   if not FInitialized then Exit;

  jcOpenMapView_ClearLayoutAll(FjEnv, FjObject );

   for rToP := rpBottom to rpCenterVertical do
      if rToP in FPositionRelativeToParent then
        jcOpenMapView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));

   for rToA := raAbove to raAlignRight do
     if rToA in FPositionRelativeToAnchor then
       jcOpenMapView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));

end;

//Event : Java -> Pascal
procedure jcOpenMapView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;

function jcOpenMapView.jCreate( _showScale: boolean; _tileSource: integer; _zoom: integer): jObject;
begin
   Result:= jcOpenMapView_jCreate(FjEnv, int64(Self),_showScale, _tileSource,_zoom,FjThis);
end;

procedure jcOpenMapView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_jFree(FjEnv, FjObject);
end;

procedure jcOpenMapView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jcOpenMapView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetParent(FjEnv, FjObject);
end;

procedure jcOpenMapView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jcOpenMapView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetView(FjEnv, FjObject);
end;

procedure jcOpenMapView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jcOpenMapView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jcOpenMapView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetLParamWidth(FjEnv, FjObject);
end;

function jcOpenMapView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jcOpenMapView.SetLGravity(_g: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetLGravity(FjEnv, FjObject, _g);
end;

procedure jcOpenMapView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jcOpenMapView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jcOpenMapView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jcOpenMapView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jcOpenMapView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jcOpenMapView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jcOpenMapView.SetZoom(_zoom: integer);
begin
  //in designing component state: set value here...
  FZoom:= _zoom;
  if FInitialized then
     jcOpenMapView_SetZoom(FjEnv, FjObject, _zoom);
end;

procedure jcOpenMapView.SetShowScale(_show: boolean);
begin
  //in designing component state: set value here...
  FShowScale:= _show;
  if FInitialized then
     jcOpenMapView_SetShowScale(FjEnv, FjObject, _show);
end;

procedure jcOpenMapView.SetCenter(_latitude: double; _longitude: double);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetCenter(FjEnv, FjObject, _latitude ,_longitude);
end;

procedure jcOpenMapView.SetTileSource(_tileSource: TTileSource);
begin
  //in designing component state: set value here...
  FTileSource:= _tileSource;
  if FInitialized then
     jcOpenMapView_SetTileSource(FjEnv, FjObject, Ord(_tileSource));
end;

procedure jcOpenMapView.ClearOverlays();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearOverlays(FjEnv, FjObject);
end;

procedure jcOpenMapView.Invalidate();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_Invalidate(FjEnv, FjObject);
end;

procedure jcOpenMapView.DrawCircle(_latitude: double; _longitude: double; _radiusInMetters: double; _title: string; _strokeColor: TARGBColorBridge; _strokeWidth: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_DrawCircle(FjEnv, FjObject, _latitude ,_longitude ,_radiusInMetters ,_title ,GetARGB(FCustomColor, _strokeColor ),_strokeWidth);
end;

procedure jcOpenMapView.SetGroundImageOverlay(_latitude: double; _longitude: double; _imageIdentifier: string; _dimMetters: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetGroundImageOverlay(FjEnv, FjObject, _latitude ,_longitude ,_imageIdentifier ,_dimMetters);
end;

procedure jcOpenMapView.DrawRoad(_roadCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_DrawRoad(FjEnv, FjObject, _roadCode);
end;

procedure jcOpenMapView.DrawRoad();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_DrawRoad(FjEnv, FjObject);
end;

procedure jcOpenMapView.DrawRoad(_roadCode: integer; _geoPointStartIndex: integer; _count: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_DrawRoad(FjEnv, FjObject, _roadCode ,_geoPointStartIndex ,_count);
end;

procedure jcOpenMapView.DrawRoad(_roadCode: integer; var _latitudeLongitude: TDynArrayOfDouble);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_DrawRoad(FjEnv, FjObject, _roadCode ,_latitudeLongitude);
end;

function jcOpenMapView.GetGeoPoints(): TDynArrayOfDouble;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetGeoPoints(FjEnv, FjObject);
end;

function jcOpenMapView.AddGeoPoint(_latitude: double; _longitude: double): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddGeoPoint(FjEnv, FjObject, _latitude ,_longitude);
end;

function jcOpenMapView.AddGeoPoint(_index: integer; _latitude: double; _longitude: double): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddGeoPoint(FjEnv, FjObject, _index ,_latitude ,_longitude);
end;

procedure jcOpenMapView.ClearGeoPoints();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearGeoPoints(FjEnv, FjObject);
end;

procedure jcOpenMapView.ClearGeoPoint(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearGeoPoint(FjEnv, FjObject, _index);
end;

function jcOpenMapView.GetGeoPoint(_index: integer): TDynArrayOfDouble;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetGeoPoint(FjEnv, FjObject, _index);
end;

function jcOpenMapView.AddMarker(_latitude: double; _longitude: double; _iconIdentifier: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddMarker(FjEnv, FjObject, _latitude ,_longitude ,_iconIdentifier);
end;

function jcOpenMapView.AddMarker(_latitude: double; _longitude: double; _title: string; _iconIdentifier: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddMarker(FjEnv, FjObject, _latitude ,_longitude ,_title ,_iconIdentifier);
end;

function jcOpenMapView.AddMarker(_latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddMarker(FjEnv, FjObject, _latitude ,_longitude ,_title ,_snippetInfo ,_iconIdentifier);
end;

function jcOpenMapView.AddMarker(_latitude: double; _longitude: double; _title: string; _snippetInfo: string; _markerIconIdentifier: string; _snippetImageIdentifier: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddMarker(FjEnv, FjObject, _latitude ,_longitude ,_title ,_snippetInfo ,_markerIconIdentifier ,_snippetImageIdentifier);
end;

procedure jcOpenMapView.ClearMarker(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearMarker(FjEnv, FjObject, _index);
end;

procedure jcOpenMapView.ClearMarkers();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearMarkers(FjEnv, FjObject);
end;

function jcOpenMapView.GetMarker(_index: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetMarker(FjEnv, FjObject, _index);
end;

function jcOpenMapView.GetMarkerPosition(_marker: jObject): TDynArrayOfDouble;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetMarkerPosition(FjEnv, FjObject, _marker);
end;

function jcOpenMapView.AddPolygon(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _title: string; _color: TARGBColorBridge; _alphaTransparency: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddPolygon(FjEnv, FjObject, _latitude ,_longitude ,_title ,GetARGB(FCustomColor, _color) ,_alphaTransparency);
end;

function jcOpenMapView.AddPolygon( _geoPointStartIndex: integer; _count: integer;_title: string; _color: TARGBColorBridge; _alphaTransparency: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddPolygon(FjEnv, FjObject, _geoPointStartIndex ,_count, _title ,GetARGB(FCustomColor, _color) ,_alphaTransparency);
end;

procedure jcOpenMapView.ClearPolygon(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearPolygon(FjEnv, FjObject, _index);
end;

procedure jcOpenMapView.ClearPolygons();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearPolygons(FjEnv, FjObject);
end;

procedure jcOpenMapView.StopPanning();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_StopPanning(FjEnv, FjObject);
end;

procedure jcOPenMapView.SetIsMarkerDraggable(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOPenMapView_SetIsMarkerDraggable(FjEnv, FjObject, _value);
end;

procedure jcOpenMapView.SetMarkerDraggable(_marker: jObject; _draggable: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetMarkerDraggable(FjEnv, FjObject, _marker ,_draggable);
end;

function jcOpenMapView.DrawMarker(_latitude: double; _longitude: double; _title: string; _iconIdentifier: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_DrawMarker(FjEnv, FjObject, _latitude ,_longitude ,_title ,_iconIdentifier);
end;

function jcOpenMapView.DrawMarker(_latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_DrawMarker(FjEnv, FjObject, _latitude ,_longitude ,_title ,_snippetInfo ,_iconIdentifier);
end;

procedure jcOpenMapView.ClearMarker(_marker: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearMarker(FjEnv, FjObject, _marker);
end;

procedure jcOpenMapView.MoveMarker(_marker: jObject; _latitude: double; _longitude: double);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_MoveMarker(FjEnv, FjObject, _marker ,_latitude ,_longitude);
end;

function jcOpenMapView.GetMarkersPositions(): TDynArrayOfDouble;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetMarkersPositions(FjEnv, FjObject);
end;

function jcOpenMapView.GetMarkersCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetMarkersCount(FjEnv, FjObject);
end;

function jcOpenMapView.GetMarkerPosition(_index: integer): TDynArrayOfDouble;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetMarkerPosition(FjEnv, FjObject, _index);
end;

function jcOpenMapView.GetGeoPointsCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetGeoPointsCount(FjEnv, FjObject);
end;

function jcOpenMapView.GetPolygonsCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetPolygonsCount(FjEnv, FjObject);
end;

function jcOpenMapView.AddPolygon(var _latitudeLongitude: TDynArrayOfDouble; _title: string; _color: TARGBColorBridge; _alphaTransparency: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddPolygon(FjEnv, FjObject, _latitudeLongitude ,_title ,GetARGB(FCustomColor, _color) ,_alphaTransparency);
end;

function jcOpenMapView.AddMarkers(var _latitudeLongitude: TDynArrayOfDouble; _title: string; _snippetInfo: string; _iconIdentifier: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddMarkers(FjEnv, FjObject, _latitudeLongitude ,_title ,_snippetInfo ,_iconIdentifier);
end;

function jcOpenMapView.AddMarkers(var _latitudeLongitude: TDynArrayOfDouble; _iconIdentifier: string): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddMarkers(FjEnv, FjObject, _latitudeLongitude ,_iconIdentifier);
end;

function jcOpenMapView.DrawPolyline(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_DrawPolyline(FjEnv, FjObject, _latitude ,_longitude);
end;

function jcOpenMapView.DrawPolyline(_geoPointStartIndex: integer; _count: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_DrawPolyline(FjEnv, FjObject, _geoPointStartIndex ,_count);
end;

function jcOpenMapView.DrawLine(_latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double; _strokeColor: integer; _strokeWidth: integer): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_DrawLine(FjEnv, FjObject, _latitude1 ,_longitude1 ,_latitude2 ,_longitude2 ,_strokeColor ,_strokeWidth);
end;

procedure jcOpenMapView.ClearPolyline(_polyline: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearPolyline(FjEnv, FjObject, _polyline);
end;

function jcOpenMapView.AddLine(_latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddLine(FjEnv, FjObject, _latitude1 ,_longitude1 ,_latitude2 ,_longitude2);
end;

function jcOpenMapView.AddLine(_latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double; _strokeColor: integer; _strokeWidth: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddLine(FjEnv, FjObject, _latitude1 ,_longitude1 ,_latitude2 ,_longitude2 ,_strokeColor ,_strokeWidth);
end;

procedure jcOpenMapView.ClearLine(_line: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearLine(FjEnv, FjObject, _line);
end;

procedure jcOpenMapView.ClearLine(_index: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearLine(FjEnv, FjObject, _index);
end;

procedure jcOpenMapView.ClearLines();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_ClearLines(FjEnv, FjObject);
end;

function jcOpenMapView.GetLinesCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_GetLinesCount(FjEnv, FjObject);
end;

procedure jcOpenMapView.SetStrokeColor(_strokeColor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetStrokeColor(FjEnv, FjObject, _strokeColor);
end;

procedure jcOpenMapView.SetStrokeWidth(_strokeWidth: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetStrokeWidth(FjEnv, FjObject, _strokeWidth);
end;

procedure jcOpenMapView.SetFillColor(_fillColor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetFillColor(FjEnv, FjObject, _fillColor);
end;

procedure jcOpenMapView.SetMarkerRotation(_marker: jObject; _angleDeg: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetMarkerRotation(FjEnv, FjObject, _marker ,_angleDeg);
end;

function jcOpenMapView.AddMarker(_latitude: double; _longitude: double; _iconIdentifier: string; _rotationAngleDeg: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddMarker(FjEnv, FjObject, _latitude ,_longitude ,_iconIdentifier ,_rotationAngleDeg);
end;

function jcOpenMapView.AddMarker(_latitude: double; _longitude: double; _title: string; _iconIdentifier: string; _rotationAngleDeg: integer): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_AddMarker(FjEnv, FjObject, _latitude ,_longitude ,_title ,_iconIdentifier ,_rotationAngleDeg);
end;

procedure jcOpenMapView.SetMarkerXY(_x: single; _y: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetMarkerXY(FjEnv, FjObject, _x ,_y);
end;

procedure jcOpenMapView.GenEvent_OnOpenMapViewClick(Sender:TObject;latitude:double;longitude:double);
begin
  if Assigned(FOnOpenMapViewClick) then FOnOpenMapViewClick(Sender,latitude,longitude);
end;

procedure jcOpenMapView.GenEvent_OnOpenMapViewLongClick(Sender:TObject;latitude:double;longitude:double);
begin
  if Assigned(FOnOpenMapViewLongClick) then FOnOpenMapViewLongClick(Sender,latitude,longitude);
end;

procedure jcOpenMapView.GenEvent_OnOpenMapViewRoadDraw(Sender:TObject; roadCode:integer; roadStatus: integer; roadDuration:double; roadDistance:double; out color:dword; out width: integer);
var
  outColor: TARGBColorBridge;
  outWidth: integer;
begin
  outColor:= colbrDefault;
  outWidth:= 0;
  width:= 0;               //keep
  color:= 0;               //keep
  if Assigned(FOnRoadDraw) then
  begin
    FOnRoadDraw(Sender,roadCode,TRoadStatus(roadStatus),roadDuration,roadDistance,outColor,outWidth);
    if (outColor <> colbrDefault) and (outColor <> colbrNone) then  // (outColor <> colbrNone) and (outColor <> colbrDefault)
       color:= GetARGB(FCustomColor, outColor);
    if outWidth > 0 then
       width:= outWidth;
  end;
end;

procedure jcOpenMapView.GenEvent_OnOpenMapViewMarkerClick(Sender:TObject;title:string;latitude:double;longitude:double);
begin
  if Assigned(FOnOpenMapViewMarkerClick) then FOnOpenMapViewMarkerClick(Sender,title,latitude,longitude);
end;

{-------- jcOpenMapView_JNI_Bridge ----------}

function jcOpenMapView_jCreate(env: PJNIEnv;_Self: int64; _showScale: boolean;  _tileSource: integer; _zoom: integer; this: jObject): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].z:= JBool(_showScale);
  jParams[2].i:= _tileSource;
  jParams[3].i:= _zoom;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jcOpenMapView_jCreate', '(JZII)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

procedure jcOpenMapView_jFree(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetViewParent(env: PJNIEnv; _jcopenmapview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_GetParent(env: PJNIEnv; _jcopenmapview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_RemoveFromViewParent(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_GetView(env: PJNIEnv; _jcopenmapview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetLParamWidth(env: PJNIEnv; _jcopenmapview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetLParamHeight(env: PJNIEnv; _jcopenmapview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_GetLParamWidth(env: PJNIEnv; _jcopenmapview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_GetLParamHeight(env: PJNIEnv; _jcopenmapview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetLGravity(env: PJNIEnv; _jcopenmapview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetLWeight(env: PJNIEnv; _jcopenmapview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jcopenmapview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_AddLParamsAnchorRule(env: PJNIEnv; _jcopenmapview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_AddLParamsParentRule(env: PJNIEnv; _jcopenmapview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetLayoutAll(env: PJNIEnv; _jcopenmapview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearLayoutAll(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetId(env: PJNIEnv; _jcopenmapview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'setId', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetZoom(env: PJNIEnv; _jcopenmapview: JObject; _zoom: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _zoom;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetZoom', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetShowScale(env: PJNIEnv; _jcopenmapview: JObject; _show: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_show);
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetShowScale', '(Z)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetCenter(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCenter', '(DD)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetTileSource(env: PJNIEnv; _jcopenmapview: JObject; _tileSource: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _tileSource;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTileSource', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearOverlays(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearOverlays', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_Invalidate(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'Invalidate', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_DrawCircle(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _radiusInMetters: double; _title: string; _strokeColor: integer; _strokeWidth: single);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].d:= _radiusInMetters;
  jParams[3].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[4].i:= _strokeColor;
  jParams[5].f:= _strokeWidth;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawCircle', '(DDDLjava/lang/String;IF)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetGroundImageOverlay(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _imageIdentifier: string; _dimMetters: single);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_imageIdentifier));
  jParams[3].f:= _dimMetters;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetGroundImageOverlay', '(DDLjava/lang/String;F)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_DrawRoad(env: PJNIEnv; _jcopenmapview: JObject; _roadCode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _roadCode;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRoad', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_DrawRoad(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRoad', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_DrawRoad(env: PJNIEnv; _jcopenmapview: JObject; _roadCode: integer; _geoPointStartIndex: integer; _count: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _roadCode;
  jParams[1].i:= _geoPointStartIndex;
  jParams[2].i:= _count;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRoad', '(III)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_GetGeoPoints(env: PJNIEnv; _jcopenmapview: JObject): TDynArrayOfDouble;
var
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGeoPoints', '()[D');
  jresultArray:= env^.CallObjectMethod(env, _jcopenmapview, jMethod);
  if jResultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    env^.GetDoubleArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_AddGeoPoint(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddGeoPoint', '(DD)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_AddGeoPoint(env: PJNIEnv; _jcopenmapview: JObject; _index: integer; _latitude: double; _longitude: double): integer;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jParams[1].d:= _latitude;
  jParams[2].d:= _longitude;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddGeoPoint', '(IDD)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearGeoPoints(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearGeoPoints', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearGeoPoint(env: PJNIEnv; _jcopenmapview: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearGeoPoint', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_GetGeoPoint(env: PJNIEnv; _jcopenmapview: JObject; _index: integer): TDynArrayOfDouble;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGeoPoint', '(I)[D');
  jResultArray:= env^.CallObjectMethodA(env, _jcopenmapview, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetDoubleArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _iconIdentifier: string): integer;
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddMarker', '(DDLjava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _iconIdentifier: string): integer;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddMarker', '(DDLjava/lang/String;Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string): integer;
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_snippetInfo));
  jParams[4].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddMarker', '(DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env,jParams[4].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _snippetInfo: string; _markerIconIdentifier: string; _snippetImageIdentifier: string): integer;
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_snippetInfo));
  jParams[4].l:= env^.NewStringUTF(env, PChar(_markerIconIdentifier));
  jParams[5].l:= env^.NewStringUTF(env, PChar(_snippetImageIdentifier));
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddMarker', '(DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env,jParams[4].l);
  env^.DeleteLocalRef(env,jParams[5].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearMarker(env: PJNIEnv; _jcopenmapview: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearMarker', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearMarkers(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearMarkers', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_GetMarker(env: PJNIEnv; _jcopenmapview: JObject; _index: integer): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMarker', '(I)Lorg/osmdroid/views/overlay/Marker;');
  Result:= env^.CallObjectMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_GetMarkerPosition(env: PJNIEnv; _jcopenmapview: JObject; _marker: jObject): TDynArrayOfDouble;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _marker;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMarkerPosition', '(Lorg/osmdroid/views/overlay/Marker;)[D');
  jResultArray:= env^.CallObjectMethodA(env, _jcopenmapview, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetDoubleArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_AddPolygon(env: PJNIEnv; _jcopenmapview: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _title: string; _color: integer; _alphaTransparency: integer): integer;
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
begin
  newSize0:= Length(_latitude);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_latitude[0] {source});
  jParams[0].l:= jNewArray0;
  newSize1:= Length(_longitude);
  jNewArray1:= env^.NewDoubleArray(env, newSize1);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray1, 0 , newSize1, @_longitude[0] {source});
  jParams[1].l:= jNewArray1;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[3].i:= _color;
  jParams[4].i:= _alphaTransparency;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddPolygon', '([D[DLjava/lang/String;II)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_AddPolygon(env: PJNIEnv; _jcopenmapview: JObject;_geoPointStartIndex: integer; _count: integer; _title: string; _color: integer; _alphaTransparency: integer): integer;
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _geoPointStartIndex;
  jParams[1].i:= _count;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[3].i:= _color;
  jParams[4].i:= _alphaTransparency;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddPolygon', '(IILjava/lang/String;II)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearPolygon(env: PJNIEnv; _jcopenmapview: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearPolygon', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearPolygons(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearPolygons', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_StopPanning(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'StopPanning', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOPenMapView_SetIsMarkerDraggable(env: PJNIEnv; _jcopenmapview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetIsMarkerDraggable', '(Z)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetMarkerDraggable(env: PJNIEnv; _jcopenmapview: JObject; _marker: jObject; _draggable: boolean);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _marker;
  jParams[1].z:= JBool(_draggable);
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMarkerDraggable', '(Lorg/osmdroid/views/overlay/Marker;Z)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_DrawMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _iconIdentifier: string): jObject;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawMarker', '(DDLjava/lang/String;Ljava/lang/String;)Lorg/osmdroid/views/overlay/Marker;');
  Result:= env^.CallObjectMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_DrawMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string): jObject;
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_snippetInfo));
  jParams[4].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawMarker', '(DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lorg/osmdroid/views/overlay/Marker;');
  Result:= env^.CallObjectMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env,jParams[4].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearMarker(env: PJNIEnv; _jcopenmapview: JObject; _marker: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _marker;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearMarker', '(Lorg/osmdroid/views/overlay/Marker;)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcOpenMapView_MoveMarker(env: PJNIEnv; _jcopenmapview: JObject; _marker: jObject; _latitude: double; _longitude: double);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _marker;
  jParams[1].d:= _latitude;
  jParams[2].d:= _longitude;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'MoveMarker', '(Lorg/osmdroid/views/overlay/Marker;DD)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_GetMarkersPositions(env: PJNIEnv; _jcopenmapview: JObject): TDynArrayOfDouble;
var
  resultSize: integer;
  jResultArray: jObject;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMarkersPositions', '()[D');
  jresultArray:= env^.CallObjectMethod(env, _jcopenmapview, jMethod);
  if jResultArray <> nil then
  begin
    resultsize:= env^.GetArrayLength(env, jresultArray);
    SetLength(Result, resultsize);
    env^.GetDoubleArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_GetMarkersCount(env: PJNIEnv; _jcopenmapview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMarkersCount', '()I');
  Result:= env^.CallIntMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_GetMarkerPosition(env: PJNIEnv; _jcopenmapview: JObject; _index: integer): TDynArrayOfDouble;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetMarkerPosition', '(I)[D');
  jResultArray:= env^.CallObjectMethodA(env, _jcopenmapview, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetDoubleArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_GetGeoPointsCount(env: PJNIEnv; _jcopenmapview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGeoPointsCount', '()I');
  Result:= env^.CallIntMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_GetPolygonsCount(env: PJNIEnv; _jcopenmapview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetPolygonsCount', '()I');
  Result:= env^.CallIntMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_AddPolygon(env: PJNIEnv; _jcopenmapview: JObject; var _latitudeLongitude: TDynArrayOfDouble; _title: string; _color: integer; _alphaTransparency: integer): integer;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_latitudeLongitude);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_latitudeLongitude[0] {source});
  jParams[0].l:= jNewArray0;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[2].i:= _color;
  jParams[3].i:= _alphaTransparency;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddPolygon', '([DLjava/lang/String;II)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_AddMarkers(env: PJNIEnv; _jcopenmapview: JObject; var _latitudeLongitude: TDynArrayOfDouble; _title: string; _snippetInfo: string; _iconIdentifier: string): integer;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_latitudeLongitude);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_latitudeLongitude[0] {source});
  jParams[0].l:= jNewArray0;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_snippetInfo));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddMarkers', '([DLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_AddMarkers(env: PJNIEnv; _jcopenmapview: JObject; var _latitudeLongitude: TDynArrayOfDouble; _iconIdentifier: string): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  newSize0:= Length(_latitudeLongitude);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_latitudeLongitude[0] {source});
  jParams[0].l:= jNewArray0;
  jParams[1].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddMarkers', '([DLjava/lang/String;)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_DrawRoad(env: PJNIEnv; _jcopenmapview: JObject; _roadCode: integer; var _latitudeLongitude: TDynArrayOfDouble);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
begin
  jParams[0].i:= _roadCode;
  newSize0:= Length(_latitudeLongitude);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_latitudeLongitude[0] {source});
  jParams[1].l:= jNewArray0;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawRoad', '(I[D)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_AddLine(env: PJNIEnv; _jcopenmapview: JObject; _latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double): integer;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude1;
  jParams[1].d:= _longitude1;
  jParams[2].d:= _latitude2;
  jParams[3].d:= _longitude2;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLine', '(DDDD)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_AddLine(env: PJNIEnv; _jcopenmapview: JObject; _latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double; _strokeColor: integer; _strokeWidth: integer): integer;
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude1;
  jParams[1].d:= _longitude1;
  jParams[2].d:= _latitude2;
  jParams[3].d:= _longitude2;
  jParams[4].i:= _strokeColor;
  jParams[5].i:= _strokeWidth;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLine', '(DDDDII)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearLine(env: PJNIEnv; _jcopenmapview: JObject; _index: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLine', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_ClearLines(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLines', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_GetLinesCount(env: PJNIEnv; _jcopenmapview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLinesCount', '()I');
  Result:= env^.CallIntMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcOpenMapView_SetStrokeColor(env: PJNIEnv; _jcopenmapview: JObject; _strokeColor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _strokeColor;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetStrokeColor', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcOpenMapView_SetStrokeWidth(env: PJNIEnv; _jcopenmapview: JObject; _strokeWidth: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _strokeWidth;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetStrokeWidth', '(F)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetFillColor(env: PJNIEnv; _jcopenmapview: JObject; _fillColor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _fillColor;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFillColor', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_DrawPolyline(env: PJNIEnv; _jcopenmapview: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
  newSize0: integer;
  jNewArray0: jObject=nil;
  newSize1: integer;
  jNewArray1: jObject=nil;
begin
  newSize0:= Length(_latitude);
  jNewArray0:= env^.NewDoubleArray(env, newSize0);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray0, 0 , newSize0, @_latitude[0] {source});
  jParams[0].l:= jNewArray0;
  newSize1:= Length(_longitude);
  jNewArray1:= env^.NewDoubleArray(env, newSize1);  // allocate
  env^.SetDoubleArrayRegion(env, jNewArray1, 0 , newSize1, @_longitude[0] {source});
  jParams[1].l:= jNewArray1;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPolyline', '([D[D)Lorg/osmdroid/views/overlay/Polyline;');
  Result:= env^.CallObjectMethodA(env, _jcopenmapview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_DrawPolyline(env: PJNIEnv; _jcopenmapview: JObject; _geoPointStartIndex: integer; _count: integer): jObject;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _geoPointStartIndex;
  jParams[1].i:= _count;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPolyline', '(II)Lorg/osmdroid/views/overlay/Polyline;');
  Result:= env^.CallObjectMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_DrawLine(env: PJNIEnv; _jcopenmapview: JObject; _latitude1: double; _longitude1: double; _latitude2: double; _longitude2: double; _strokeColor: integer; _strokeWidth: integer): jObject;
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude1;
  jParams[1].d:= _longitude1;
  jParams[2].d:= _latitude2;
  jParams[3].d:= _longitude2;
  jParams[4].i:= _strokeColor;
  jParams[5].i:= _strokeWidth;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawLine', '(DDDDII)Lorg/osmdroid/views/overlay/Polyline;');
  Result:= env^.CallObjectMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcOpenMapView_ClearPolyline(env: PJNIEnv; _jcopenmapview: JObject; _polyline: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _polyline;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearPolyline', '(Lorg/osmdroid/views/overlay/Polyline;)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jcOpenMapView_ClearLine(env: PJNIEnv; _jcopenmapview: JObject; _line: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _line;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLine', '(Lorg/osmdroid/views/overlay/Polyline;)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetMarkerRotation(env: PJNIEnv; _jcopenmapview: JObject; _marker: jObject; _angleDeg: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _marker;
  jParams[1].i:= _angleDeg;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMarkerRotation', '(Lorg/osmdroid/views/overlay/Marker;I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _iconIdentifier: string; _rotationAngleDeg: integer): integer;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jParams[3].i:= _rotationAngleDeg;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddMarker', '(DDLjava/lang/String;I)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;


function jcOpenMapView_AddMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _iconIdentifier: string; _rotationAngleDeg: integer): integer;
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jParams[4].i:= _rotationAngleDeg;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddMarker', '(DDLjava/lang/String;Ljava/lang/String;I)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetMarkerXY(env: PJNIEnv; _jcopenmapview: JObject; _x: single; _y: single);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _x;
  jParams[1].f:= _y;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMarkerXY', '(FF)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
