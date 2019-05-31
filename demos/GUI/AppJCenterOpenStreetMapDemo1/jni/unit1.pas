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
    jcOpenMapView1: jcOpenMapView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jcOpenMapView1RoadDraw(Sender: TObject; roadCode: integer;
      roadStatus: TRoadStatus; roadDuration: double; roadLength: double; out
      outColor: TARGBColorBridge; out outWidth: integer);
  private
    {private declarations}
  public
    {public declarations}
    procedure ShowMap();
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

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
  jcOpenMapView1.SetMarker(-15.905274,-52.246095, 'Start','Aragarcas City', 'marker24');  //my house
  jcOpenMapView1.SetMarker(-15.891746,-52.261577,'Middleway','B. do Garcas City','marker_itinerary32');
  jcOpenMapView1.SetMarker(-15.876128,-52.312421, 'Target', 'UFMT Campi', 'marker24'); //Target
   //jcOpenMapView1.Invalidate(); //no need here...
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if Self.IsRuntimePermissionNeed() then
  begin
    Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE', 1234); //need by OpenMapView images/tiles cache...
  end
  else ShowMap();
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  //android.permission.WRITE_EXTERNAL_STORAGE
  if requestCode = 1234 then
  begin
     if grantResult = PERMISSION_GRANTED then
     begin
         ShowMap(); // <<----- first App launcher
     end
     else
     begin
        ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" DENIED...');
     end;
  end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin

   if Self.IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
      jcOpenMapView1.RoadClear();
      jcOpenMapView1.RoadAdd(-15.905274,-52.246095);  //Start
      jcOpenMapView1.RoadAdd(-15.905650,-52.246776);
      jcOpenMapView1.RoadAdd(-15.905635,-52.247913);
      jcOpenMapView1.RoadAdd(-15.891746,-52.261577); //Middleway
      jcOpenMapView1.RoadDraw(1); //implicit invalidate...
   end
   else
      ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" DENIED...');

end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   if Self.IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
     jcOpenMapView1.RoadClear();
     jcOpenMapView1.RoadAdd(-15.891746,-52.261577);  //Middleway
     jcOpenMapView1.RoadAdd(-15.876128,-52.312421);
     jcOpenMapView1.RoadDraw(2); //implicit invalidate...
   end
   else
      ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" DENIED...');

end;

end.
