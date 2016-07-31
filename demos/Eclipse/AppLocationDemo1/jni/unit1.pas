{Hint: save all files to location: C:\adt32\eclipse\workspace\AppLocationDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
  Laz_And_Controls_Events, AndroidWidget, location;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jCheckBox1: jCheckBox;
      jLocation1: jLocation;
      jTextView1: jTextView;
      jWebView1: jWebView;
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jCheckBox1Click(Sender: TObject);
      procedure jLocation1LocationChanged(Sender: TObject; latitude: double;
        longitude: double; altitude: double; address: string);
      procedure jLocation1LocationProviderDisabled(Sender: TObject;
        provider: string);
      procedure jLocation1LocationProviderEnabled(Sender: TObject;
        provider: string);
      procedure jLocation1LocationStatusChanged(Sender: TObject;
        status: integer; provider: string; msgStatus: string);
    private
      {private declarations}
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
  if not Self.isConnected() then
  begin //try wifi
    if Self.SetWifiEnabled(True) then
      jCheckBox1.Checked:= True
    else
      ShowMessage('Please,  try enable some connection...');
  end
  else
  begin
     if Self.isConnectedWifi() then jCheckBox1.Checked:= True
  end;
end;

procedure TAndroidModule1.jCheckBox1Click(Sender: TObject);
begin
   if jCheckBox1.Checked then
   begin
      if not jLocation1.IsWifiEnabled() then
       jLocation1.SetWifiEnabled(True)
     else
       ShowMessage('Wifi is Enabled!');
   end
   else
   begin
      jLocation1.SetWifiEnabled(False);
      ShowMessage('Wifi was Disabled!');
   end;
end;

procedure TAndroidModule1.jLocation1LocationChanged(Sender: TObject;
  latitude: double; longitude: double; altitude: double; address: string);
var
  urlLocation: string;
begin
  urlLocation:= jLocation1.GetGoogleMapsUrl(latitude, longitude);
  jWebView1.Navigate(urlLocation);
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if not jLocation1.IsGPSProvider then
  begin
     ShowMessage('Sorry, GPS is Off. Please, active it and try again.');
     jLocation1.ShowLocationSouceSettings()
  end
  else
  begin
     ShowMessage('GPS is On! Starting Tracker...');
     jLocation1.MapType:= mtHybrid;  // default/mtRoadmap, mtSatellite, mtTerrain, mtHybrid
     jLocation1.StartTracker();  //handled by "OnLocationChanged"
  end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jLocation1.StopTracker();
   jLocation1.ShowLocationSouceSettings()
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject); //no GPS is need! only wifi...
var
  al: TDynArrayOfDouble;
  urlLocation: string;
begin                               // 'UFMT,  Barra do Garças, Mato Grosso, Brasil'
  al:= jLocation1.GetLatitudeLongitude('Super Center Mendonça, AV. Minstro João Alberto, centro, Barra do Garças, Mato Grosso, Brasil');
  jLocation1.MapType:= mtHybrid;     // default/mtRoadmap, mtSatellite, mtTerrain, mtHybrid
  urlLocation:= jLocation1.GetGoogleMapsUrl(al[0], al[1]);
  jWebView1.Navigate(urlLocation);
end;

procedure TAndroidModule1.jLocation1LocationProviderDisabled(Sender: TObject; //GPS OFF
  provider: string);
begin
   ShowMessage('provider= '+provider +' : Disabled!');
end;

procedure TAndroidModule1.jLocation1LocationProviderEnabled(Sender: TObject; //GPS ON
  provider: string);
begin
  ShowMessage('New provider= '+provider +' : Enabled!');
end;

procedure TAndroidModule1.jLocation1LocationStatusChanged(Sender: TObject;
  status: integer; provider: string; msgStatus: string);
begin
  ShowMessage('provider= '+provider+' ::: msgStatus= '+ msgStatus);
end;

end.
