{Hint: save all files to location: C:\android\workspace\AppWifiManagerDemo1\jni }
unit unit1;

{$mode delphi}

interface

//https://medium.com/@josiassena/android-manipulating-wifi-using-the-wifimanager-9af77cb04c6a
uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, wifimanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jCheckBox1: jCheckBox;
    jListView1: jListView;
    jTextView1: jTextView;
    jWifiManager1: jWifiManager;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jListView1ClickItem(Sender: TObject; itemIndex: integer;
      itemCaption: string);
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

procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  scanResult: TDynArrayOfString;
  count, i: integer;
begin
  if Self.IsRuntimePermissionGranted('android.permission.ACCESS_COARSE_LOCATION') then
  begin
     scanResult:= jWifiManager1.Scan();
     count:= Length(scanResult);
     if count > 0 then
     begin
       for i:=0 to count-1 do
       begin
         jListView1.Add(scanResult[i]);
       end;
     end
     else
     begin
       ShowMessage('Sorry... Scan Fail...');
       if jWifiManager1.RequestLocationServicesDenied then
          ShowMessage('Request Location Services DENIED...');
     end;

     SetLength(scanResult, 0);
  end
  else
     ShowMessage('Sorry... "android.permission.ACCESS_COARSE_LOCATION" DENIED...');
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if Self.IsRuntimePermissionNeed() then  //android.permission.ACCESS_FINE_LOCATION
  begin     //
     Self.RequestRuntimePermission('android.permission.ACCESS_COARSE_LOCATION', 1456);
  end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
   if requestCode = 1456 then
  begin
     if grantResult = PERMISSION_GRANTED then
     begin
        ShowMessage('Please,  Enable Location Services...');
        jWifiManager1.RequestLocationServices(); //API >= 23 ... request user to enable location
     end
     else
        ShowMessage('Sorry... "'+manifestPermission+'" DENIED...');
  end;
end;

procedure TAndroidModule1.jListView1ClickItem(Sender: TObject;
  itemIndex: integer; itemCaption: string);
var
  ssid, capabilities: string;
begin
  ssid:= jWifiManager1.GetSSID(itemIndex);
  capabilities:= jWifiManager1.GetCapabilities(itemIndex);

  //ShowMessage(capabilities);

  if jWifiManager1.Connect(ssid, 'niconico') then
  begin
     jCheckBox1.Text:= 'Connected '+ ssid;
     jCheckBox1.Checked:= True;
  end;
end;

end.
