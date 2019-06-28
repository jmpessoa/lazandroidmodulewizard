{Hint: save all files to location: C:\android\workspace\AppJCenterOpenStreetMapDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, copenmapview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jButton4: jButton;
    jButton5: jButton;
    jCheckBox1: jCheckBox;
    jCheckBox2: jCheckBox;
    jcOpenMapView1: jcOpenMapView;
    jTextView1: jTextView;
    procedure AndroidModule1Destroy(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jButton4Click(Sender: TObject);
    procedure jButton5Click(Sender: TObject);
    procedure jCheckBox2Click(Sender: TObject);
    procedure jcOpenMapView1Click(Sender: TObject; latitude: double;
      longitude: double);
    procedure jcOpenMapView1RoadDraw(Sender: TObject; roadCode: integer;
      roadStatus: TRoadStatus; roadDuration: double; roadLength: double; out
      outColor: TARGBColorBridge; out outWidth: integer);
  private
    {private declarations}
    IsPickingPoints: boolean;
    MyPolygon1: TDynArrayOfDouble;
  public
    {public declarations}
    procedure ShowMap();

  end;

var
  AndroidModule1: TAndroidModule1;
  globalMarker: jObjectRef;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
   if globalMarker <> nil then
    jcOpenMapView1.ClearMarker(globalMarker); //remove not bufferized marker....
end;

procedure TAndroidModule1.jButton5Click(Sender: TObject);
begin
  if jcOpenMapView1.GetMarkersCount() > 0 then
      jcOpenMapView1.ClearMarker(0);  //clear bufferized marker
end;

procedure TAndroidModule1.jcOpenMapView1RoadDraw(Sender: TObject;
  roadCode: integer; roadStatus: TRoadStatus; roadDuration: double;
  roadLength: double; out outColor: TARGBColorBridge; out outWidth: integer);
begin

  if roadStatus = rsOK then
  begin
    ShowMessage('length = ' + FloatToStr(roadLength) + ' km');
    if roadCode = 1 then outColor:= colbrBlue;  //default
    if roadCode = 2 then outColor:= colbrRed;
  end
  else ShowMessage('Sorry... fail...');

end;

procedure TAndroidModule1.ShowMap();
begin
  jcOpenMapView1.SetCenter(-15.884559,-52.272295);  //center map

  //"Draw"  is not bufferized....
  jcOpenMapView1.DrawMarker(-15.905274,-52.246095, 'Start','Aragarcas City', 'marker24');  //my house

  //save a not bufferized marker...
  globalMarker:= jcOpenMapView1.DrawMarker(-15.891746,-52.261577,'Middleway','B. do Garcas City','marker_itinerary32');
  globalMarker:= Get_jObjGlobalRef(globalMarker); //JNI api...

  jcOpenMapView1.DrawMarker(-15.876128,-52.312421, 'Target', 'UFMT Campi', 'marker24'); //Target
  //jcOpenMapView1.StopPanning(); //dont working... why?
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  IsPickingPoints:= False;
  if Self.IsRuntimePermissionNeed() then
  begin
    Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE', 1234); //need by OpenMapView images/tiles cache...
  end
  else ShowMap();
end;

procedure TAndroidModule1.AndroidModule1Destroy(Sender: TObject);
begin
  SetLength(MyPolygon1, 0); //free ...
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  if requestCode = 1234 then
  begin
     if grantResult = PERMISSION_GRANTED then
        ShowMap() // <<----- first App launcher
     else
        ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" DENIED...');
  end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin

   if Self.IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
      jcOpenMapView1.ClearGeoPoints();
      jcOpenMapView1.AddGeoPoint(-15.905274,-52.246095);  //Start
      jcOpenMapView1.AddGeoPoint(-15.905650,-52.246776);
      jcOpenMapView1.AddGeoPoint(-15.905635,-52.247913);
      jcOpenMapView1.AddGeoPoint(-15.891746,-52.261577); //Middleway
      jcOpenMapView1.DrawRoad(1); //implicit invalidate...
   end
   else
      ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" DENIED...');

end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if Self.IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
  begin
    jcOpenMapView1.ClearGeoPoints();
    jcOpenMapView1.AddGeoPoint(-15.891746,-52.261577);  //Middleway
    jcOpenMapView1.AddGeoPoint(-15.876128,-52.312421);
    jcOpenMapView1.DrawRoad(2); //implicit invalidate...
  end
  else
    ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" DENIED...');
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  jCheckBox2.Checked:= False;
  IsPickingPoints:= False;
  MyPolygon1:= jcOpenMapView1.GetMarkersPositions();  //get markers points...
  if MyPolygon1 <> nil then
  begin

     if jcOpenMapView1.GetPolygonsCount() > 0 then
       jcOpenMapView1.ClearPolygons;

     jcOpenMapView1.AddPolygon(MyPolygon1, 'Polygon1', colbrBlue, 5);
  end
  else ShowMessage('Sorry... MyPolygon1 = nil');
end;

procedure TAndroidModule1.jCheckBox2Click(Sender: TObject);
begin
  if jCheckBox2.Checked then
  begin
     jcOpenMapView1.ClearMarkers();
     IsPickingPoints:= True
  end
  else
     IsPickingPoints:= False;
end;

procedure TAndroidModule1.jcOpenMapView1Click(Sender: TObject;
  latitude: double; longitude: double);
begin
  if IsPickingPoints then    //"Add"  is bufferized
    jcOpenMapView1.AddMarker(latitude,  longitude, 'location_pin'); //from "...res/drawable"
end;


end.
