{hint: Pascal files location: ...\AppLocationForGpsDemo\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, linearlayout, Laz_And_Controls, location;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jEditText1: jEditText;
    jEditText2: jEditText;
    jEditText3: jEditText;
    jEditText4: jEditText;
    jLinearLayout1: jLinearLayout;
    jLocation1: jLocation;
    procedure AndroidModule1ActivityResume(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jLocation1LocationChanged(Sender: TObject; latitude: double;
      longitude: double; altitude: double; address: string);

  private
    procedure P_gps_opener;
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;
  RRPermissionGps:Boolean=false;

implementation
  
{$R *.lfm}

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
    if Self.IsRuntimePermissionNeed() then
  begin
    Self.RequestRuntimePermission('android.permission.ACCESS_FINE_LOCATION', 7777);
  end
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
      if requestCode = 7777 then
  begin
     if grantResult = PERMISSION_GRANTED then
     begin
        RRPermissionGps:=true;
        P_gps_opener;
     end
     else
        ShowMessage('Sorry... "android.permission.ACCESS_FINE_LOCATION" DENIED...');
  end;
end;

procedure TAndroidModule1.jLocation1LocationChanged(Sender: TObject;
  latitude: double; longitude: double; altitude: double; address: string);
begin
    jEditText1.Text:=floattostr(latitude);
    jEditText2.Text:=floattostr(longitude);
    jEditText3.Text:=floattostr(altitude);
    jEditText4.Text:=address;

end;



procedure TAndroidModule1.AndroidModule1ActivityResume(Sender: TObject);
begin
    if RRPermissionGps then P_gps_opener;

end;

procedure TAndroidModule1.P_gps_opener;
begin
  if not jLocation1.IsGPSProvider then
  begin
    ShowMessage('GPS OFF');
    jLocation1.ShowLocationSouceSettings();
  end
  else
  begin
    ShowMessage('GPS ON');
    jLocation1.StartTracker();
  end;
end;



end.
