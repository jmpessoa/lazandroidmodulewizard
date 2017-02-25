unit location;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, AndroidWidget;

type

TGeoPoint2D = record
  latitude: double;
  longitude: double;
end;

TGpsStatusEvent = (gpsNone, gpsStarted, gpsStopped, gpsFirstFix, gpsSatelliteStatus);

TLocationChanged = procedure(Sender: TObject; latitude: double; longitude: double; altitude: double; address: string) of object;
TLocationStatusChanged = procedure(Sender: TObject; status: integer; provider: string; msgStatus: string) of object;
TLocationProviderEnabled = procedure(Sender: TObject; provider: string) of object;
TLocationProviderDisabled = procedure(Sender: TObject; provider: string) of object;
TOnGpsStatusChanged = procedure(Sender: TObject; countSatellites: integer; gpsStatusEvent: TGpsStatusEvent) of object;

TCriteriaAccuracy = (crCoarse {default Network-based/wi-fi}, crFine);

TMapType = (mtRoadmap, mtSatellite, mtTerrain, mtHybrid);

TProvider = (pvNetwork, pvGPS);

TPictureStyle = (pfDefault, pfMarkers, pfPath);

TMarkerHighlightColor = (markBlack, markBrown, markGreen, markPurple,
                         markYellow, markBlue, markGray, markOrange, markRed, markWhite);

{Draft Component code by "Lazarus Android Module Wizard" [8/11/2014 19:15:07]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jLocation = class(jControl)
 private
    FCriteriaAccuracy: TCriteriaAccuracy;
    FTimeForUpdates: int64;    // millsecs
    FDistanceForUpdates: int64;  //meters

    FMapType: TMapType;
    FMapZoom: integer;
    FMapWidth: integer;
    FMapHeight: integer;

    FOnLocationChanged: TLocationChanged;
    FOnLocationStatusChanged: TLocationStatusChanged;
    FOnLocationProviderEnabled: TLocationProviderEnabled;  //called when Gps is turned ON!!
    FOnLocationProviderDisabled: TLocationProviderDisabled; //called when Gps is turned OFF!!

    FOnGpsStatusChanged: TOnGpsStatusChanged;
 protected

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;

    function jCreate( _TimeForUpdates: int64; _DistanceForUpdates: int64; _CriteriaAccuracy: integer; _MapType: integer): jObject;
    procedure jFree();
    function StartTracker(): boolean;  overload;
    procedure ShowLocationSouceSettings();
    procedure RequestLocationUpdates(); overload;
    procedure StopTracker();

    procedure SetCriteriaAccuracy(_accuracy: TCriteriaAccuracy);

    function IsGPSProvider(): boolean;
    function IsNetProvider(): boolean;
    procedure SetTimeForUpdates(_time: int64);
    procedure SetDistanceForUpdates(_distance: int64);
    function GetLatitude(): double;
    function GetLongitude(): double;
    function GetAltitude(): double;
    function IsWifiEnabled(): boolean;
    procedure SetWifiEnabled(_status: boolean);
    function GetGoogleMapsUrl(_latitude: double; _longitude: double): string; overload;
    procedure SetMapWidth(_mapwidth: integer);
    procedure SetMapHeight(_mapheight: integer);
    procedure SetMapZoom(_mapzoom: integer);
    procedure SetMapType(_maptype: TMapType);
    function GetAddress(): string; overload;
    function GetAddress(_latitude: double; _longitude: double): string; overload;
    function StartTracker(_locationName: string): boolean; overload;
    procedure RequestLocationUpdates(_provider: TProvider); overload;

    function GetLatitudeLongitude(_fullAddress: string): TDynArrayOfDouble;
    function GetGeoPoint2D(_fullAddress: string): TGeoPoint2D;

    function GetGoogleMapsUrl(_fullAddress: string): string; overload;
    function GetDistanceBetween(_startLatitude: double; _startLongitude: double; _endLatitude: double; _endLongitude: double): single;
    function GetDistanceTo(_latitude: double; _longitude: double): single;

    function GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): string; overload;

    function GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D): string; overload;
    function GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D; pictureStyle: TPictureStyle): string; overload;
    function GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D; pictureStyle: TPictureStyle; markerHighlightIndex: integer): string; overload;

    function GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; pictureStyle: TPictureStyle): string; overload;
    function GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; pictureStyle: TPictureStyle; _markerHighlightIndex: integer): string; overload;

    procedure SetMarkerHighlightColor(_color: TMarkerHighlightColor);
    function GetSatelliteCount(): integer;
    function GetSatelliteInfo(_index: integer): string;
    function GetTimeToFirstFix(): single;

    procedure GenEvent_OnLocationChanged(Obj: TObject; latitude: double; longitude: double; altitude: double; address: string);
    procedure GenEvent_OnLocationStatusChanged(Obj: TObject; status: integer; provider: string; msgStatus: string);
    procedure GenEvent_OnLocationProviderEnabled(Obj: TObject; provider: string);
    procedure GenEvent_OnLocationProviderDisabled(Obj: TObject; provider: string);
    procedure GenEvent_OnGpsStatusChanged(Obj: TObject; countSatellites: integer; gpsStatusEvent: integer);

    property MapZoom: integer read FMapZoom write SetMapZoom;
    property MapWidth: integer read FMapWidth write SetMapWidth;
    property MapHeight: integer read FMapHeight write SetMapHeight;

 published

    property MapType: TMapType read FMapType write SetMapType;
    property CriteriaAccuracy: TCriteriaAccuracy read FCriteriaAccuracy write SetCriteriaAccuracy;

    property TimeForUpdates: int64 read FTimeForUpdates write SetTimeForUpdates;    // millsecs
    property DistanceForUpdates: int64 read FDistanceForUpdates write SetDistanceForUpdates;  //meters

    property OnLocationChanged: TLocationChanged read FOnLocationChanged write FOnLocationChanged;
    property OnLocationStatusChanged: TLocationStatusChanged read FOnLocationStatusChanged write FOnLocationStatusChanged;
    property OnLocationProviderEnabled: TLocationProviderEnabled read FOnLocationProviderEnabled write FOnLocationProviderEnabled;
    property OnLocationProviderDisabled: TLocationProviderDisabled read FOnLocationProviderDisabled write FOnLocationProviderDisabled;
    property OnGpsStatusChanged: TOnGpsStatusChanged read FOnGpsStatusChanged write FOnGpsStatusChanged;

end;

function jLocation_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _TimeForUpdates: int64; _DistanceForUpdates: int64; _CriteriaAccuracy: integer; _MapType: integer): jObject;
procedure jLocation_jFree(env: PJNIEnv; _jlocation: JObject);
function jLocation_StartTracker(env: PJNIEnv; _jlocation: JObject): boolean; overload;
procedure jLocation_ShowLocationSouceSettings(env: PJNIEnv; _jlocation: JObject);
procedure jLocation_RequestLocationUpdates(env: PJNIEnv; _jlocation: JObject); overload;
procedure jLocation_StopTracker(env: PJNIEnv; _jlocation: JObject);
procedure jLocation_SetCriteriaAccuracy(env: PJNIEnv; _jlocation: JObject; _accuracy: integer);
function jLocation_IsGPSProvider(env: PJNIEnv; _jlocation: JObject): boolean;
function jLocation_IsNetProvider(env: PJNIEnv; _jlocation: JObject): boolean;
procedure jLocation_SetTimeForUpdates(env: PJNIEnv; _jlocation: JObject; _time: int64);
procedure jLocation_SetDistanceForUpdades(env: PJNIEnv; _jlocation: JObject; _distance: int64);
function jLocation_GetLatitude(env: PJNIEnv; _jlocation: JObject): double;
function jLocation_GetLongitude(env: PJNIEnv; _jlocation: JObject): double;
function jLocation_GetAltitude(env: PJNIEnv; _jlocation: JObject): double;
function jLocation_IsWifiEnabled(env: PJNIEnv; _jlocation: JObject): boolean;
procedure jLocation_SetWifiEnabled(env: PJNIEnv; _jlocation: JObject; _status: boolean);
function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; _latitude: double; _longitude: double): string; overload;
procedure jLocation_SetMapWidth(env: PJNIEnv; _jlocation: JObject; _mapwidth: integer);
procedure jLocation_SetMapHeight(env: PJNIEnv; _jlocation: JObject; _mapheight: integer);
procedure jLocation_SetMapZoom(env: PJNIEnv; _jlocation: JObject; _mapzoom: integer);
procedure jLocation_SetMapType(env: PJNIEnv; _jlocation: JObject; _maptype: integer);
function jLocation_GetAddress(env: PJNIEnv; _jlocation: JObject): string; overload;
function jLocation_GetAddress(env: PJNIEnv; _jlocation: JObject; _latitude: double; _longitude: double): string; overload;
function jLocation_StartTracker(env: PJNIEnv; _jlocation: JObject; _locationName: string): boolean; overload;
procedure jLocation_RequestLocationUpdates(env: PJNIEnv; _jlocation: JObject; _provider: integer); overload;
function jLocation_GetLatitudeLongitude(env: PJNIEnv; _jlocation: JObject; _locationAddress: string): TDynArrayOfDouble;
function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; _fullAddress: string): string; overload;
function jLocation_GetDistanceBetween(env: PJNIEnv; _jlocation: JObject; _startLatitude: double; _startLongitude: double; _endLatitude: double; _endLongitude: double): single;
function jLocation_GetDistanceTo(env: PJNIEnv; _jlocation: JObject; _latitude: double; _longitude: double): single;

function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): string; overload;
function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _pathFlag: integer): string; overload;
function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _pathFlag: integer; _markerHighlightIndex: integer): string; overload;
procedure jLocation_SetMarkerHighlightColor(env: PJNIEnv; _jlocation: JObject; _color: integer);
function jLocation_GetSatelliteCount(env: PJNIEnv; _jlocation: JObject): integer;
function jLocation_GetSatelliteInfo(env: PJNIEnv; _jlocation: JObject; _index: integer): string;
function jLocation_GetTimeToFirstFix(env: PJNIEnv; _jlocation: JObject): single;


function GeoPoint2D(latitute: double; longitude: double): TGeoPoint2D;

implementation

function GeoPoint2D(latitute: double; longitude: double): TGeoPoint2D;
begin
  Result.latitude:= latitute;
  Result.longitude:= longitude;
end;

{---------  jLocation  --------------}

constructor jLocation.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //your code here....
  FCriteriaAccuracy:= crCoarse;  //{default Network-based/wi-fi}
  FMapType:= mtRoadmap;
  FTimeForUpdates:= Trunc((1000 * 60 * 1)/4); // millsecs   {default = 1/4 minute};
  FDistanceForUpdates:= 1;  //meters
end;

destructor jLocation.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
        if FjObject  <> nil then
        begin
           jFree();
           FjObject := nil;
        end;
  end;
  //you others free code here...
  inherited Destroy;
end;

procedure jLocation.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp);
  //your code here: set/initialize create params....
  FjObject := jCreate(FTimeForUpdates ,FDistanceForUpdates ,Ord(FCriteriaAccuracy) ,Ord(FMapType));

  FInitialized:= True;
end;

function jLocation.jCreate( _TimeForUpdates: int64; _DistanceForUpdates: int64; _CriteriaAccuracy: integer; _MapType: integer): jObject;
begin
   Result:= jLocation_jCreate(FjEnv, FjThis , int64(Self) ,_TimeForUpdates ,_DistanceForUpdates ,_CriteriaAccuracy ,_MapType);
end;


procedure jLocation.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLocation_jFree(FjEnv, FjObject );
end;

function jLocation.StartTracker(): boolean;
begin
  //in designing component state: result value here...
  Result:= False;
  if FInitialized then
   Result:= jLocation_StartTracker(FjEnv, FjObject );
end;

procedure jLocation.ShowLocationSouceSettings();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLocation_ShowLocationSouceSettings(FjEnv, FjObject );
end;

procedure jLocation.RequestLocationUpdates();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLocation_RequestLocationUpdates(FjEnv, FjObject );
end;

procedure jLocation.StopTracker();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLocation_StopTracker(FjEnv, FjObject );
end;

procedure jLocation.SetCriteriaAccuracy(_accuracy: TCriteriaAccuracy);
begin
  //in designing component state: set value here...
  FCriteriaAccuracy:= _accuracy;
  if FInitialized then
     jLocation_SetCriteriaAccuracy(FjEnv, FjObject , Ord(_accuracy));
end;

function jLocation.IsGPSProvider(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_IsGPSProvider(FjEnv, FjObject );
end;

function jLocation.IsNetProvider(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_IsNetProvider(FjEnv, FjObject );
end;

procedure jLocation.SetTimeForUpdates(_time: int64);
begin
  //in designing component state: set value here...
  FTimeForUpdates:= _time;
  if FInitialized then
     jLocation_SetTimeForUpdates(FjEnv, FjObject , _time);
end;

procedure jLocation.SetDistanceForUpdates(_distance: int64);
begin
  //in designing component state: set value here...
  FDistanceForUpdates:= _distance;
  if FInitialized then
     jLocation_SetDistanceForUpdades(FjEnv, FjObject , _distance);
end;

function jLocation.GetLatitude(): double;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetLatitude(FjEnv, FjObject );
end;

function jLocation.GetLongitude(): double;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetLongitude(FjEnv, FjObject );
end;

function jLocation.GetAltitude(): double;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetAltitude(FjEnv, FjObject );
end;

function jLocation.IsWifiEnabled(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_IsWifiEnabled(FjEnv, FjObject );
end;

procedure jLocation.SetWifiEnabled(_status: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLocation_SetWifiEnabled(FjEnv, FjObject , _status);
end;

function jLocation.GetGoogleMapsUrl(_latitude: double; _longitude: double): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject , _latitude ,_longitude);
end;

procedure jLocation.SetMapWidth(_mapwidth: integer);
begin
  //in designing component state: set value here...
  FMapWidth:= _mapwidth;
  if FInitialized then
     jLocation_SetMapWidth(FjEnv, FjObject , _mapwidth);
end;

procedure jLocation.SetMapHeight(_mapheight: integer);
begin
  //in designing component state: set value here...
  FMapHeight:=_mapheight;
  if FInitialized then
     jLocation_SetMapHeight(FjEnv, FjObject , _mapheight);
end;

procedure jLocation.SetMapZoom(_mapzoom: integer);
begin
  //in designing component state: set value here...
  FMapZoom:= _mapzoom;
  if FInitialized then
     jLocation_SetMapZoom(FjEnv, FjObject , _mapzoom);
end;

procedure jLocation.SetMapType(_maptype: TMapType);
begin
  //in designing component state: set value here...
  FMapType:= _maptype;
  if FInitialized then
     jLocation_SetMapType(FjEnv, FjObject , Ord(_maptype));
end;

function jLocation.GetAddress(): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetAddress(FjEnv, FjObject );
end;

function jLocation.GetAddress(_latitude: double; _longitude: double): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetAddress(FjEnv, FjObject , _latitude ,_longitude);
end;

function jLocation.StartTracker(_locationName: string): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_StartTracker(FjEnv, FjObject, _locationName);
end;

procedure jLocation.RequestLocationUpdates(_provider: TProvider);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLocation_RequestLocationUpdates(FjEnv, FjObject, Ord(_provider));
end;

function jLocation.GetLatitudeLongitude(_fullAddress: string): TDynArrayOfDouble;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetLatitudeLongitude(FjEnv, FjObject, _fullAddress);
end;

function jLocation.GetGeoPoint2D(_fullAddress: string): TGeoPoint2D;
var
  ll: TDynArrayOfDouble;
begin
  //in designing component state: result value here...
  if FInitialized then
  begin
   ll:= jLocation_GetLatitudeLongitude(FjEnv, FjObject, _fullAddress);
   Result.latitude:= ll[0];
   Result.longitude:= ll[1];
  end;
  SetLength(ll, 0);
end;

function jLocation.GetGoogleMapsUrl(_fullAddress: string): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, _fullAddress);
end;

function jLocation.GetDistanceBetween(_startLatitude: double; _startLongitude: double; _endLatitude: double; _endLongitude: double): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetDistanceBetween(FjEnv, FjObject, _startLatitude ,_startLongitude ,_endLatitude ,_endLongitude);
end;

function jLocation.GetDistanceTo(_latitude: double; _longitude: double): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetDistanceTo(FjEnv, FjObject, _latitude ,_longitude);
end;

function jLocation.GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, _latitude ,_longitude);
end;

function jLocation.GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D): string;
var
  count, i: integer;
  latitude: TDynArrayOfDouble;
  longitude: TDynArrayOfDouble;
  p: TGeoPoint2D;
begin
  if FInitialized then
  begin
    count:= Length(geoPoints);
    SetLength(latitude,  count);
    SetLength(longitude,  count);
    for i:= 0 to count-1 do
    begin
      p:= geoPoints[i];
      latitude[i]:= p.latitude;
      longitude[i]:= p.longitude;
    end;
    Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, latitude ,longitude);
    SetLength(latitude,  0);
    SetLength(longitude, 0);
  end;
end;

function jLocation.GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D; pictureStyle: TPictureStyle): string;
var
  count, i: integer;
  latitude: TDynArrayOfDouble;
  longitude: TDynArrayOfDouble;
  p: TGeoPoint2D;
begin
  if FInitialized then
  begin
    count:= Length(geoPoints);
    SetLength(latitude,  count);
    SetLength(longitude,  count);
    for i:= 0 to count-1 do
    begin
      p:= geoPoints[i];
      latitude[i]:= p.latitude;
      longitude[i]:= p.longitude;
    end;
    Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, latitude ,longitude, Ord(pictureStyle));
    SetLength(latitude,  0);
    SetLength(longitude, 0);
  end;
end;

function jLocation.GetGoogleMapsUrl(geoPoints: array of TGeoPoint2D; pictureStyle: TPictureStyle; markerHighlightIndex: integer): string;
var
  count, i: integer;
  latitude: TDynArrayOfDouble;
  longitude: TDynArrayOfDouble;
  p: TGeoPoint2D;
begin
  if FInitialized then
  begin
    count:= Length(geoPoints);
    SetLength(latitude,  count);
    SetLength(longitude,  count);
    for i:= 0 to count-1 do
    begin
      p:= geoPoints[i];
      latitude[i]:= p.latitude;
      longitude[i]:= p.longitude;
    end;
    Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, latitude ,longitude, Ord(pictureStyle), markerHighlightIndex);
    SetLength(latitude,  0);
    SetLength(longitude, 0);
  end;
end;

function jLocation.GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; pictureStyle: TPictureStyle): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, _latitude ,_longitude, Ord(pictureStyle));
end;

function jLocation.GetGoogleMapsUrl(var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; pictureStyle: TPictureStyle; _markerHighlightIndex: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetGoogleMapsUrl(FjEnv, FjObject, _latitude ,_longitude ,Ord(pictureStyle) ,_markerHighlightIndex);
end;

procedure jLocation.SetMarkerHighlightColor(_color: TMarkerHighlightColor);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLocation_SetMarkerHighlightColor(FjEnv, FjObject, Ord(_color) );
end;

function jLocation.GetSatelliteCount(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetSatelliteCount(FjEnv, FjObject);
end;

function jLocation.GetSatelliteInfo(_index: integer): string;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetSatelliteInfo(FjEnv, FjObject, _index);
end;

function jLocation.GetTimeToFirstFix(): single;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLocation_GetTimeToFirstFix(FjEnv, FjObject);
end;

procedure jLocation.GenEvent_OnLocationChanged(Obj: TObject; latitude: double; longitude: double; altitude: double; address: string);
begin
   if Assigned(FOnLocationChanged) then FOnLocationChanged(Obj, latitude, longitude, altitude, address);
end;

procedure jLocation.GenEvent_OnLocationStatusChanged(Obj: TObject; status: integer; provider: string; msgStatus: string);
begin
   if Assigned(FOnLocationStatusChanged) then FOnLocationStatusChanged(Obj, status, provider, msgStatus);
end;

procedure jLocation.GenEvent_OnLocationProviderEnabled(Obj: TObject; provider: string);
begin
   if Assigned(FOnLocationProviderEnabled) then FOnLocationProviderEnabled(Obj, provider);
end;

procedure jLocation.GenEvent_OnLocationProviderDisabled(Obj: TObject; provider: string);
begin
   if Assigned(FOnLocationProviderDisabled) then FOnLocationProviderDisabled(Obj, provider);
end;

procedure jLocation.GenEvent_OnGpsStatusChanged(Obj: TObject; countSatellites: integer; gpsStatusEvent: integer);
begin
   if Assigned(FOnGpsStatusChanged) then FOnGpsStatusChanged(Obj, countSatellites, TGpsStatusEvent(gpsStatusEvent));
end;


{-------- jLocation_JNI_Bridge ----------}

function jLocation_jCreate(env: PJNIEnv; this: JObject;_Self: int64; _TimeForUpdates: int64; _DistanceForUpdates: int64; _CriteriaAccuracy: integer; _MapType: integer): jObject;
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jParams[1].j:= _TimeForUpdates;
  jParams[2].j:= _DistanceForUpdates;
  jParams[3].i:= _CriteriaAccuracy;
  jParams[4].i:= _MapType;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jLocation_jCreate', '(JJJII)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

   public java.lang.Object jLocation_jCreate(long _Self, long _TimeForUpdates, long _DistanceForUpdates, int _CriteriaAccuracy, int _MapType) {
      return (java.lang.Object)(new jLocation(this,_Self,_TimeForUpdates,_DistanceForUpdates,_CriteriaAccuracy,_MapType));
   }

//to end of "public class Controls" in "Controls.java"
*)

procedure jLocation_jFree(env: PJNIEnv; _jlocation: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jlocation, jMethod);
  env^.DeleteLocalRef(env, jCls);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_StartTracker(env: PJNIEnv; _jlocation: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'StartTracker', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jlocation, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jLocation_ShowLocationSouceSettings(env: PJNIEnv; _jlocation: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'ShowLocationSouceSettings', '()V');
  env^.CallVoidMethod(env, _jlocation, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLocation_RequestLocationUpdates(env: PJNIEnv; _jlocation: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestLocationUpdates', '()V');
  env^.CallVoidMethod(env, _jlocation, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLocation_StopTracker(env: PJNIEnv; _jlocation: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'StopTracker', '()V');
  env^.CallVoidMethod(env, _jlocation, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLocation_SetCriteriaAccuracy(env: PJNIEnv; _jlocation: JObject; _accuracy: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _accuracy;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCriteriaAccuracy', '(I)V');
  env^.CallVoidMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_IsGPSProvider(env: PJNIEnv; _jlocation: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'IsGPSProvider', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jlocation, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_IsNetProvider(env: PJNIEnv; _jlocation: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'IsNetProvider', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jlocation, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLocation_SetTimeForUpdates(env: PJNIEnv; _jlocation: JObject; _time: int64);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _time;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'SetTimeForUpdates', '(J)V');
  env^.CallVoidMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jLocation_SetDistanceForUpdades(env: PJNIEnv; _jlocation: JObject; _distance: int64);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _distance;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'SetDistanceForUpdates', '(J)V');
  env^.CallVoidMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetLatitude(env: PJNIEnv; _jlocation: JObject): double;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLatitude', '()D');
  Result:= env^.CallDoubleMethod(env, _jlocation, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetLongitude(env: PJNIEnv; _jlocation: JObject): double;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLongitude', '()D');
  Result:= env^.CallDoubleMethod(env, _jlocation, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetAltitude(env: PJNIEnv; _jlocation: JObject): double;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetAltitude', '()D');
  Result:= env^.CallDoubleMethod(env, _jlocation, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_IsWifiEnabled(env: PJNIEnv; _jlocation: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'IsWifiEnabled', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jlocation, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jLocation_SetWifiEnabled(env: PJNIEnv; _jlocation: JObject; _status: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_status);
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'SetWifiEnabled', '(Z)V');
  env^.CallVoidMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; _latitude: double; _longitude: double): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGoogleMapsUrl', '(DD)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jlocation, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

procedure jLocation_SetMapWidth(env: PJNIEnv; _jlocation: JObject; _mapwidth: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _mapwidth;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMapWidth', '(I)V');
  env^.CallVoidMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLocation_SetMapHeight(env: PJNIEnv; _jlocation: JObject; _mapheight: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _mapheight;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMapHeight', '(I)V');
  env^.CallVoidMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLocation_SetMapZoom(env: PJNIEnv; _jlocation: JObject; _mapzoom: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _mapzoom;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMapZoom', '(I)V');
  env^.CallVoidMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLocation_SetMapType(env: PJNIEnv; _jlocation: JObject; _maptype: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _maptype;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMapType', '(I)V');
  env^.CallVoidMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetAddress(env: PJNIEnv; _jlocation: JObject): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetAddress', '()Ljava/lang/String;');
  jStr:= env^.CallObjectMethod(env, _jlocation, jMethod);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;


function jLocation_GetAddress(env: PJNIEnv; _jlocation: JObject; _latitude: double; _longitude: double): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetAddress', '(DD)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jlocation, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_StartTracker(env: PJNIEnv; _jlocation: JObject; _locationName: string): boolean;
var
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_locationName));
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'StartTracker', '(Ljava/lang/String;)Z');
  jBoo:= env^.CallBooleanMethodA(env, _jlocation, jMethod, @jParams);
  Result:= boolean(jBoo);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jLocation_RequestLocationUpdates(env: PJNIEnv; _jlocation: JObject; _provider: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _provider;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'RequestLocationUpdates', '(I)V');
  env^.CallVoidMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetLatitudeLongitude(env: PJNIEnv; _jlocation: JObject; _locationAddress: string): TDynArrayOfDouble;
var
  resultSize: integer;
  jResultArray: jObject;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_locationAddress));
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLatitudeLongitude', '(Ljava/lang/String;)[D');
  jResultArray:= env^.CallObjectMethodA(env, _jlocation, jMethod,  @jParams);
  if jResultArray <> nil then
  begin
    resultSize:= env^.GetArrayLength(env, jResultArray);
    SetLength(Result, resultSize);
    env^.GetDoubleArrayRegion(env, jResultArray, 0, resultSize, @Result[0] {target});
  end;
   env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; _fullAddress: string): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_fullAddress));
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGoogleMapsUrl', '(Ljava/lang/String;)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jlocation, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetDistanceBetween(env: PJNIEnv; _jlocation: JObject; _startLatitude: double; _startLongitude: double; _endLatitude: double; _endLongitude: double): single;
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _startLatitude;
  jParams[1].d:= _startLongitude;
  jParams[2].d:= _endLatitude;
  jParams[3].d:= _endLongitude;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDistanceBetween', '(DDDD)F');
  Result:= env^.CallFloatMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jLocation_GetDistanceTo(env: PJNIEnv; _jlocation: JObject; _latitude: double; _longitude: double): single;
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].d:= _latitude;
  jParams[1].d:= _longitude;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetDistanceTo', '(DD)F');
  Result:= env^.CallFloatMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble): string;
var
  jStr: JString;
  jBoo: JBoolean;
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
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGoogleMapsUrl', '([D[D)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jlocation, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _pathFlag: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..2] of jValue;
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
  jParams[2].i:= _pathFlag;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGoogleMapsUrl', '([D[DI)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jlocation, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetGoogleMapsUrl(env: PJNIEnv; _jlocation: JObject; var _latitude: TDynArrayOfDouble; var _longitude: TDynArrayOfDouble; _pathFlag: integer; _markerHighlightIndex: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..3] of jValue;
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
  jParams[2].i:= _pathFlag;
  jParams[3].i:= _markerHighlightIndex;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetGoogleMapsUrl', '([D[DII)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jlocation, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jLocation_SetMarkerHighlightColor(env: PJNIEnv; _jlocation: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'SetMarkerHighlightColor', '(I)V');
  env^.CallVoidMethodA(env, _jlocation, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetSatelliteCount(env: PJNIEnv; _jlocation: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSatelliteCount', '()I');
  Result:= env^.CallIntMethod(env, _jlocation, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jLocation_GetSatelliteInfo(env: PJNIEnv; _jlocation: JObject; _index: integer): string;
var
  jStr: JString;
  jBoo: JBoolean;
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _index;
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetSatelliteInfo', '(I)Ljava/lang/String;');
  jStr:= env^.CallObjectMethodA(env, _jlocation, jMethod, @jParams);
  case jStr = nil of
     True : Result:= '';
     False: begin
              jBoo:= JNI_False;
              Result:= string( env^.GetStringUTFChars(env, jStr, @jBoo));
            end;
  end;
  env^.DeleteLocalRef(env, jCls);
end;

function jLocation_GetTimeToFirstFix(env: PJNIEnv; _jlocation: JObject): single;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlocation);
  jMethod:= env^.GetMethodID(env, jCls, 'GetTimeToFirstFix', '()F');
  Result:= env^.CallFloatMethod(env, _jlocation, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
