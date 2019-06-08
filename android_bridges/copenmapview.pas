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
    procedure SetId(_id: integer);
    procedure SetZoom(_zoom: integer);
    //function GetZoom(): integer;
    procedure SetShowScale(_show: boolean);
    procedure SetCenter(_latitude: double; _longitude: double);
    procedure SetTileSource(_tileSource: TTileSource);

    procedure ClearOverlays();
    procedure Invalidate();
    procedure SetMarker(_latitude: double; _longitude: double; _title: string; _iconIdentifier: string); overload;
    procedure RoadClear();
    procedure RoadAdd(_latitude: double; _longitude: double);
    procedure RoadDraw(); overload;
    procedure RoadDraw(_roadCode: integer); overload;
    procedure SetMarker(_latitude: double; _longitude: double; _iconIdentifier: string); overload;
    procedure SetMarker(_latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string);overload;
    procedure SetMarker(_latitude: double; _longitude: double; _title: string; _snippetInfo: string; _markerIconIdentifier: string; _snippetImageIdentifier: string); overload;

    procedure SetCircle(_latitude: double; _longitude: double; _radiusInMetters: double; _title: string; _strokeColor: integer; _strokeWidth: single);
    procedure SetGroundImageOverlay(_latitude: double; _longitude: double; _imageIdentifier: string; _dimMetters: single);
    procedure DrawPolyline(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble);
    procedure DrawPolygon(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _title: string; _strokeColor: TARGBColorBridge; _alphaBackground: integer);

    function PolygonAdd(_latitude: double; _longitude: double): integer;
    procedure PolygonClear();
    procedure PolygonDraw(_title: string; _strokeColor: TARGBColorBridge; _alphaBackground: integer);

    procedure GenEvent_OnOpenMapViewRoadDraw(Sender:TObject; roadCode:integer;roadStatus:integer;roadDuration:double; roadDistance:double; out color: dword; out width: integer);
    procedure GenEvent_OnOpenMapViewClick(Sender:TObject;latitude:double;longitude:double);
    procedure GenEvent_OnOpenMapViewLongClick(Sender:TObject;latitude:double;longitude:double);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property ShowScale: boolean read FShowScale write SetShowScale;
    property TileSource: TTileSource read FTileSource write SetTileSource;
    property Zoom: integer read FZoom write SetZoom;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property OnClick: TOnOpenMapViewClick read FOnOpenMapViewClick write FOnOpenMapViewClick;
    property OnLongClick: TOnOpenMapViewLongClick read FOnOpenMapViewLongClick write FOnOpenMapViewLongClick;
    property OnRoadDraw: TOnOpenMapViewRoadDraw read FOnRoadDraw write FOnRoadDraw;

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
procedure jcOpenMapView_SetMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _iconIdentifier: string); overload;
procedure jcOpenMapView_RoadClear(env: PJNIEnv; _jcopenmapview: JObject);
procedure jcOpenMapView_RoadAdd(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double);
procedure jcOpenMapView_RoadDraw(env: PJNIEnv; _jcopenmapview: JObject); overload;
procedure jcOpenMapView_RoadDraw(env: PJNIEnv; _jcopenmapview: JObject; _roadCode: integer); overload;
procedure jcOpenMapView_SetMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _iconIdentifier: string); overload;
procedure jcOpenMapView_SetMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string); overload;
procedure jcOpenMapView_SetMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _snippetInfo: string; _markerIconIdentifier: string; _snippetImageIdentifier: string); overload;
procedure jcOpenMapView_SetCircle(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _radiusInMetters: double; _title: string; _strokeColor: integer; _strokeWidth: single);
procedure jcOpenMapView_SetGroundImageOverlay(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _imageIdentifier: string; _dimMetters: single);
procedure jcOpenMapView_DrawPolyline(env: PJNIEnv; _jcopenmapview: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble);
procedure jcOpenMapView_DrawPolygon(env: PJNIEnv; _jcopenmapview: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _title: string; _strokeColor: integer; _alphaBackground: integer);

function jcOpenMapView_PolygonAdd(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double): integer;
procedure jcOpenMapView_PolygonClear(env: PJNIEnv; _jcopenmapview: JObject);
procedure jcOpenMapView_PolygonDraw(env: PJNIEnv; _jcopenmapview: JObject; _title: string; _strokeColor: integer; _alphaBackground: integer);


implementation

{---------  jcOpenMapView  --------------}

constructor jcOpenMapView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
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

procedure jcOpenMapView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetId(FjEnv, FjObject, _id);
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

procedure jcOpenMapView.SetMarker(_latitude: double; _longitude: double; _title: string; _iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetMarker(FjEnv, FjObject, _latitude ,_longitude ,_title ,_iconIdentifier);
end;

procedure jcOpenMapView.RoadClear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_RoadClear(FjEnv, FjObject);
end;

procedure jcOpenMapView.RoadAdd(_latitude: double; _longitude: double);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_RoadAdd(FjEnv, FjObject, _latitude ,_longitude);
end;

procedure jcOpenMapView.RoadDraw();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_RoadDraw(FjEnv, FjObject);
end;

procedure jcOpenMapView.RoadDraw(_roadCode: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_RoadDraw(FjEnv, FjObject, _roadCode);
end;

procedure jcOpenMapView.SetMarker(_latitude: double; _longitude: double; _iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetMarker(FjEnv, FjObject, _latitude ,_longitude ,_iconIdentifier);
end;

procedure jcOpenMapView.SetMarker(_latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetMarker(FjEnv, FjObject, _latitude ,_longitude ,_title ,_snippetInfo ,_iconIdentifier);
end;

procedure jcOpenMapView.SetMarker(_latitude: double; _longitude: double; _title: string; _snippetInfo: string; _markerIconIdentifier: string; _snippetImageIdentifier: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetMarker(FjEnv, FjObject, _latitude ,_longitude ,_title ,_snippetInfo ,_markerIconIdentifier ,_snippetImageIdentifier);
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

procedure jcOpenMapView.SetCircle(_latitude: double; _longitude: double; _radiusInMetters: double; _title: string; _strokeColor: integer; _strokeWidth: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetCircle(FjEnv, FjObject, _latitude ,_longitude ,_radiusInMetters ,_title ,_strokeColor ,_strokeWidth);
end;

procedure jcOpenMapView.SetGroundImageOverlay(_latitude: double; _longitude: double; _imageIdentifier: string; _dimMetters: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_SetGroundImageOverlay(FjEnv, FjObject, _latitude ,_longitude ,_imageIdentifier ,_dimMetters);
end;

procedure jcOpenMapView.DrawPolygon(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _title: string; _strokeColor: TARGBColorBridge; _alphaBackground: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_DrawPolygon(FjEnv, FjObject, _latitude ,_longitude ,_title ,GetARGB(FCustomColor, _strokeColor) ,_alphaBackground);
end;

procedure jcOpenMapView.DrawPolyline(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_DrawPolyline(FjEnv, FjObject, _latitude ,_longitude);
end;

function jcOpenMapView.PolygonAdd(_latitude: double; _longitude: double): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jcOpenMapView_PolygonAdd(FjEnv, FjObject, _latitude ,_longitude);
end;

procedure jcOpenMapView.PolygonClear();
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_PolygonClear(FjEnv, FjObject);
end;

procedure jcOpenMapView.PolygonDraw(_title: string; _strokeColor: TARGBColorBridge; _alphaBackground: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jcOpenMapView_PolygonDraw(FjEnv, FjObject, _title ,GetARGB(FCustomColor, _strokeColor) ,_alphaBackground);
end;

procedure jcOpenMapView.GenEvent_OnOpenMapViewClick(Sender:TObject;latitude:double;longitude:double);
begin
  if Assigned(FOnOpenMapViewClick) then FOnOpenMapViewClick(Sender,latitude,longitude);
end;

procedure jcOpenMapView.GenEvent_OnOpenMapViewLongClick(Sender:TObject;latitude:double;longitude:double);
begin
  if Assigned(FOnOpenMapViewLongClick) then FOnOpenMapViewLongClick(Sender,latitude,longitude);
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
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
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

procedure jcOpenMapView_SetMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _iconIdentifier: string);
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
  jMethod:= env^.GetMethodID(env, jCls, 'SetMarker', '(DDLjava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_RoadClear(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'RoadClear', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_RoadAdd(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'RoadAdd', '(DD)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_RoadDraw(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'RoadDraw', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _iconIdentifier: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jParams[2].l:= env^.NewStringUTF(env, PChar(_iconIdentifier));
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMarker', '(DDLjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _snippetInfo: string; _markerIconIdentifier: string; _snippetImageIdentifier: string);
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
  jMethod:= env^.GetMethodID(env, jCls, 'SetMarker', '(DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env,jParams[4].l);
  env^.DeleteLocalRef(env,jParams[5].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_RoadDraw(env: PJNIEnv; _jcopenmapview: JObject; _roadCode: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _roadCode;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'RoadDraw', '(I)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetMarker(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _title: string; _snippetInfo: string; _iconIdentifier: string);
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
  jMethod:= env^.GetMethodID(env, jCls, 'SetMarker', '(DDLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env,jParams[4].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_SetCircle(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double; _radiusInMetters: double; _title: string; _strokeColor: integer; _strokeWidth: single);
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
  jMethod:= env^.GetMethodID(env, jCls, 'SetCircle', '(DDDLjava/lang/String;IF)V');
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

procedure jcOpenMapView_DrawPolygon(env: PJNIEnv; _jcopenmapview: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _title: string; _strokeColor: integer; _alphaBackground: integer);
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
  jParams[3].i:= _strokeColor;
  jParams[4].i:= _alphaBackground;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPolygon', '([D[DLjava/lang/String;II)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_DrawPolyline(env: PJNIEnv; _jcopenmapview: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble);
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
  jMethod:= env^.GetMethodID(env, jCls, 'DrawPolyline', '([D[D)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jcOpenMapView_PolygonAdd(env: PJNIEnv; _jcopenmapview: JObject; _latitude: double; _longitude: double): integer;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'PolygonAdd', '(DD)I');
  Result:= env^.CallIntMethodA(env, _jcopenmapview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_PolygonClear(env: PJNIEnv; _jcopenmapview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'PolygonClear', '()V');
  env^.CallVoidMethod(env, _jcopenmapview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jcOpenMapView_PolygonDraw(env: PJNIEnv; _jcopenmapview: JObject; _title: string; _strokeColor: integer; _alphaBackground: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_title));
  jParams[1].i:= _strokeColor;
  jParams[2].i:= _alphaBackground;
  jCls:= env^.GetObjectClass(env, _jcopenmapview);
  jMethod:= env^.GetMethodID(env, jCls, 'PolygonDraw', '(Ljava/lang/String;II)V');
  env^.CallVoidMethodA(env, _jcopenmapview, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


end.
