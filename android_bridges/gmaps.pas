unit gmaps;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

TNavigationMode = (byDriving, byWalking, byBicycling);
TNavigationAvoid = (avoidTolls, avoidHighways, avoidFerries);
TSearchCategorical = (Restaurants, Hotels, Bowling, Parks, Entertainment, Shopping, Movie, Theaters);

{Draft Component code by "Lazarus Android Module Wizard" [2/25/2017 23:53:40]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jControl template}

jMaps = class(jControl)
 private

 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    function jCreate(): jObject;
    procedure jFree();
    procedure SetUri(_uriString: string);
    procedure Show(_uriString: string); overload;
    procedure Show(_latitude: string; _longitude: string); overload;
    procedure Show(_latitude: string; _longitude: string; _zoom: integer); overload;
    procedure Search(_latitude: string; _longitude: string; _address: string; _label: string); overload;
    procedure Search(_latitude: string; _longitude: string; _label: string); overload;
    procedure Search(_address: string; _label: string);  overload;
    procedure Navigation(_address: string; _mode: TNavigationMode); overload;
    procedure Navigation(_address: string; _avoid: TNavigationAvoid);  overload;
    procedure StreetView(_latitude: string; _longitude: string);  overload;
    procedure StreetView(_latitude: string; _longitude: string; _cameraBearingTowards: integer; _zoom: integer; _cameraTiltAngle: integer); overload;
    procedure SearchCategory(_category: string); overload;
    procedure SearchCategory(_latitude: string; _longitude: string; _category: string); overload;
    procedure SearchCategory(_latitude: string; _longitude: string; _zoom: integer; _category: string); overload;
    procedure Show(_latitude: string; _longitude: string; _zoom: integer; _label: string); overload;
    procedure Show(_latitude: string; _longitude: string; _label: string); overload;
    procedure Navigation(_latitude: string; _longitude: string); overload;
    function IsAppMapsInstalled(): boolean;
    procedure TryDownloadAppMaps();
 published

end;

function jMaps_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jMaps_jFree(env: PJNIEnv; _jmaps: JObject);
procedure jMaps_SetUri(env: PJNIEnv; _jmaps: JObject; _uriString: string);
procedure jMaps_Show(env: PJNIEnv; _jmaps: JObject; _uriString: string); overload;
procedure jMaps_Show(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string);  overload;
procedure jMaps_Show(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _zoom: integer);   overload;
procedure jMaps_Search(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _address: string; _label: string); overload;
procedure jMaps_Search(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _label: string); overload;
procedure jMaps_Search(env: PJNIEnv; _jmaps: JObject; _address: string; _label: string);  overload;
procedure jMaps_Navigation(env: PJNIEnv; _jmaps: JObject; _address: string; _mode: integer); overload;
procedure jMaps_NavigationTryAvoid(env: PJNIEnv; _jmaps: JObject; _address: string; _avoid: integer);
procedure jMaps_StreetView(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string); overload;
procedure jMaps_StreetView(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _cameraBearingTowards: integer; _zoom: integer; _cameraTiltAngle: integer); overload;

procedure jMaps_SearchCategory(env: PJNIEnv; _jmaps: JObject; _category: string); overload;
procedure jMaps_SearchCategory(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _category: string); overload;
procedure jMaps_SearchCategory(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _zoom: integer; _category: string);overload;
procedure jMaps_Show(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _zoom: integer; _label: string); overload;
procedure jMaps_Show(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _label: string); overload;
procedure jMaps_Navigation(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string); overload;
function jMaps_IsAppMapsInstalled(env: PJNIEnv; _jmaps: JObject): boolean;
procedure jMaps_TryDownloadAppMaps(env: PJNIEnv; _jmaps: JObject);

implementation


{---------  jMaps  --------------}

constructor jMaps.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//your code here....
end;

destructor jMaps.Destroy;
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

procedure jMaps.Init(refApp: jApp);
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;
end;

function jMaps.jCreate(): jObject;
begin
   Result:= jMaps_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jMaps.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_jFree(FjEnv, FjObject);
end;

procedure jMaps.SetUri(_uriString: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_SetUri(FjEnv, FjObject, _uriString);
end;

procedure jMaps.Show(_uriString: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_Show(FjEnv, FjObject, _uriString);
end;

procedure jMaps.Show(_latitude: string; _longitude: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_Show(FjEnv, FjObject, _latitude ,_longitude);
end;

procedure jMaps.Show(_latitude: string; _longitude: string; _zoom: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_Show(FjEnv, FjObject, _latitude ,_longitude ,_zoom);
end;

procedure jMaps.Search(_latitude: string; _longitude: string; _address: string; _label: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_Search(FjEnv, FjObject, _latitude ,_longitude ,_address ,_label);
end;

procedure jMaps.Search(_latitude: string; _longitude: string; _label: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_Search(FjEnv, FjObject, _latitude ,_longitude ,_label);
end;

procedure jMaps.Search(_address: string; _label: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_Search(FjEnv, FjObject, _address ,_label);
end;

procedure jMaps.Navigation(_address: string; _mode: TNavigationMode);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_Navigation(FjEnv, FjObject, _address ,Ord(_mode));
end;

procedure jMaps.Navigation(_address: string; _avoid: TNavigationAvoid);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_NavigationTryAvoid(FjEnv, FjObject, _address ,Ord(_avoid));
end;

procedure jMaps.StreetView(_latitude: string; _longitude: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_StreetView(FjEnv, FjObject, _latitude ,_longitude);
end;

procedure jMaps.StreetView(_latitude: string; _longitude: string; _cameraBearingTowards: integer; _zoom: integer; _cameraTiltAngle: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_StreetView(FjEnv, FjObject, _latitude ,_longitude ,_cameraBearingTowards ,_zoom ,_cameraTiltAngle);
end;

procedure jMaps.SearchCategory(_category: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_SearchCategory(FjEnv, FjObject, _category);
end;

procedure jMaps.SearchCategory(_latitude: string; _longitude: string; _category: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_SearchCategory(FjEnv, FjObject, _latitude ,_longitude ,_category);
end;

procedure jMaps.SearchCategory(_latitude: string; _longitude: string; _zoom: integer; _category: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_SearchCategory(FjEnv, FjObject, _latitude ,_longitude ,_zoom ,_category);
end;

procedure jMaps.Show(_latitude: string; _longitude: string; _zoom: integer; _label: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_Show(FjEnv, FjObject, _latitude ,_longitude ,_zoom ,_label);
end;

procedure jMaps.Show(_latitude: string; _longitude: string; _label: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_Show(FjEnv, FjObject, _latitude ,_longitude ,_label);
end;

procedure jMaps.Navigation(_latitude: string; _longitude: string);
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_Navigation(FjEnv, FjObject, _latitude ,_longitude);
end;

function jMaps.IsAppMapsInstalled(): boolean;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jMaps_IsAppMapsInstalled(FjEnv, FjObject);
end;

procedure jMaps.TryDownloadAppMaps();
begin
  //in designing component state: set value here...
  if FInitialized then
     jMaps_TryDownloadAppMaps(FjEnv, FjObject);
end;

{-------- jMaps_JNI_Bridge ----------}

function jMaps_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jMaps_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jMaps_jCreate(long _Self) {
  return (java.lang.Object)(new jMaps(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)

procedure jMaps_jFree(env: PJNIEnv; _jmaps: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jmaps, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_SetUri(env: PJNIEnv; _jmaps: JObject; _uriString: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_uriString));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'SetUri', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_Show(env: PJNIEnv; _jmaps: JObject; _uriString: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_uriString));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_Show(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_Show(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _zoom: integer);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jParams[2].i:= _zoom;
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_Search(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _address: string; _label: string);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_address));
  jParams[3].l:= env^.NewStringUTF(env, PChar(_label));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'Search', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_Search(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _label: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_label));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'Search', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_Search(env: PJNIEnv; _jmaps: JObject; _address: string; _label: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_address));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_label));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'Search', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_Navigation(env: PJNIEnv; _jmaps: JObject; _address: string; _mode: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_address));
  jParams[1].i:= _mode;
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'Navigation', '(Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMaps_NavigationTryAvoid(env: PJNIEnv; _jmaps: JObject; _address: string; _avoid: integer);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_address));
  jParams[1].i:= _avoid;
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'NavigationTryAvoid', '(Ljava/lang/String;I)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMaps_StreetView(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'StreetView', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMaps_StreetView(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _cameraBearingTowards: integer; _zoom: integer; _cameraTiltAngle: integer);
var
  jParams: array[0..4] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jParams[2].i:= _cameraBearingTowards;
  jParams[3].i:= _zoom;
  jParams[4].i:= _cameraTiltAngle;
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'StreetView', '(Ljava/lang/String;Ljava/lang/String;III)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMaps_SearchCategory(env: PJNIEnv; _jmaps: JObject; _category: string);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_category));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'SearchCategory', '(Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jMaps_SearchCategory(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _category: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_category));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'SearchCategory', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_SearchCategory(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _zoom: integer; _category: string);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jParams[2].i:= _zoom;
  jParams[3].l:= env^.NewStringUTF(env, PChar(_category));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'SearchCategory', '(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_Show(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _zoom: integer; _label: string);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jParams[2].i:= _zoom;
  jParams[3].l:= env^.NewStringUTF(env, PChar(_label));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[3].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_Show(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string; _label: string);
var
  jParams: array[0..2] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jParams[2].l:= env^.NewStringUTF(env, PChar(_label));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'Show', '(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env,jParams[2].l);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_Navigation(env: PJNIEnv; _jmaps: JObject; _latitude: string; _longitude: string);
var
  jParams: array[0..1] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= env^.NewStringUTF(env, PChar(_latitude));
  jParams[1].l:= env^.NewStringUTF(env, PChar(_longitude));
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'Navigation', '(Ljava/lang/String;Ljava/lang/String;)V');
  env^.CallVoidMethodA(env, _jmaps, jMethod, @jParams);
  env^.DeleteLocalRef(env,jParams[0].l);
  env^.DeleteLocalRef(env,jParams[1].l);
  env^.DeleteLocalRef(env, jCls);
end;

function jMaps_IsAppMapsInstalled(env: PJNIEnv; _jmaps: JObject): boolean;
var
  jBoo: JBoolean;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'IsAppMapsInstalled', '()Z');
  jBoo:= env^.CallBooleanMethod(env, _jmaps, jMethod);
  Result:= boolean(jBoo);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jMaps_TryDownloadAppMaps(env: PJNIEnv; _jmaps: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jmaps);
  jMethod:= env^.GetMethodID(env, jCls, 'TryDownloadAppMaps', '()V');
  env^.CallVoidMethod(env, _jmaps, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;

end.
