{Hint: save all files to location: C:\android\workspace\AppJCenterOpenStreetMapDemo2\jni }
unit unit2;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, copenmapview;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jCheckBox1: jCheckBox;
    jcOpenMapView1: jcOpenMapView;
    jTextView1: jTextView;
    procedure AndroidModule2Create(Sender: TObject);
    procedure AndroidModule2Destroy(Sender: TObject);
    procedure AndroidModule2JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jCheckBox1Click(Sender: TObject);
    procedure jcOpenMapView1Click(Sender: TObject; latitude: double;
      longitude: double);
    procedure jcOpenMapView1RoadDraw(Sender: TObject; roadCode: integer;
      roadStatus: TRoadStatus; roadDuration: double; roadLength: double; out
      outColor: TARGBColorBridge; out outWidth: integer);
  private
    {private declarations}
  public
    {public declarations}
    HasPermission: boolean;
    IsPickingPoints: boolean;
    MyPolygon1: TDynArrayOfDouble;
  end;

var
  AndroidModule2: TAndroidModule2;

implementation
  
{$R *.lfm}

{ TAndroidModule2 }


procedure TAndroidModule2.AndroidModule2Destroy(Sender: TObject);
begin
  SetLength(MyPolygon1, 0); //free ...
end;

procedure TAndroidModule2.AndroidModule2JNIPrompt(Sender: TObject);
begin
  IsPickingPoints:= False;
  jCheckBox1.Checked:= False;
  if HasPermission then
  begin
    jcOpenMapView1.SetCenter(-15.884559,-52.272295);  //center map
    jcOpenMapView1.DrawMarker(-15.905274,-52.246095, 'Start','Aragarcas City', 'marker24');  //my house
    jcOpenMapView1.DrawMarker(-15.891746,-52.261577,'Middleway','B. do Garcas City','marker_itinerary32');
    jcOpenMapView1.DrawMarker(-15.876128,-52.312421, 'Target', 'UFMT Campi', 'marker24'); //Target
    if MyPolygon1 <> nil then
    begin

      if jcOpenMapView1.GetMarkersCount() > 0 then
           jcOpenMapView1.ClearMarkers();
       jcOpenMapView1.AddMarkers(MyPolygon1,'location_pin');

       if jcOpenMapView1.GetPolygonsCount() > 0 then
         jcOpenMapView1.ClearPolygons;
       jcOpenMapView1.AddPolygon(MyPolygon1, 'Polygon1', colbrBlue, 5);

    end;
  end;
end;

procedure TAndroidModule2.jButton1Click(Sender: TObject);
begin
  if HasPermission then
  begin
    jcOpenMapView1.ClearGeoPoints();
    jcOpenMapView1.AddGeoPoint(-15.905274,-52.246095);  //Start
    jcOpenMapView1.AddGeoPoint(-15.905650,-52.246776);
    jcOpenMapView1.AddGeoPoint(-15.905635,-52.247913);
    jcOpenMapView1.AddGeoPoint(-15.891746,-52.261577); //Middleway
    jcOpenMapView1.DrawRoad(1); //implicit invalidate...
  end
  else
   ShowMessage('Sorry... Some Permissions DENIED...');
end;

procedure TAndroidModule2.jButton2Click(Sender: TObject);
begin
   if HasPermission then
   begin
     jcOpenMapView1.ClearGeoPoints();
     jcOpenMapView1.AddGeoPoint(-15.891746,-52.261577);  //Middleway
     jcOpenMapView1.AddGeoPoint(-15.876128,-52.312421);
     jcOpenMapView1.DrawRoad(2); //implicit invalidate...
   end
   else
      ShowMessage('Sorry... Some Permissions DENIED...');
end;

procedure TAndroidModule2.jButton3Click(Sender: TObject); //draw..
begin
  if HasPermission then
  begin
    jCheckBox1.Checked:= False;
    IsPickingPoints:= False;
    MyPolygon1:= jcOpenMapView1.GetMarkersPositions();  //get markers points...
    if MyPolygon1 <> nil then
    begin

       if jcOpenMapView1.GetPolygonsCount() > 0 then
         jcOpenMapView1.ClearPolygons;

       jcOpenMapView1.AddPolygon(MyPolygon1, 'Polygon1', colbrBlue, 5);

    end;
  end;
end;

procedure TAndroidModule2.jCheckBox1Click(Sender: TObject);
begin
  if jCheckBox1.Checked then
  begin
     jcOpenMapView1.ClearMarkers();
     IsPickingPoints:= True
  end
  else
     IsPickingPoints:= False;
end;

procedure TAndroidModule2.jcOpenMapView1Click(Sender: TObject;
  latitude: double; longitude: double);
begin
   if IsPickingPoints then
     jcOpenMapView1.AddMarker(latitude,  longitude, 'location_pin'); //from "...res/drawable"
end;

procedure TAndroidModule2.jcOpenMapView1RoadDraw(Sender: TObject;
  roadCode: integer; roadStatus: TRoadStatus; roadDuration: double;
  roadLength: double; out outColor: TARGBColorBridge; out outWidth: integer);
begin
  if roadStatus = rsOK then
  begin
    ShowMessage('length = ' + FloatToStr(roadLength) + ' km');
    if roadCode = 1 then outColor:= colbrBlue;  //default
    if roadCode = 2 then outColor:= colbrRed;
  end
  else ShowMessage('Sorry... fail... [hint: check Internet connection]');
end;

procedure TAndroidModule2.AndroidModule2Create(Sender: TObject);
begin
  HasPermission:= False;
end;

end.
