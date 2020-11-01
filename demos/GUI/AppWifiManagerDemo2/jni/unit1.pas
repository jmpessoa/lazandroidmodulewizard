{Hint: save all files to location: C:\android\workspace\AppWifiManagerDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, wifimanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    jWifiManager1: jWifiManager;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
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

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
 if jWifiManager1.NeedWriteSettingsPermission() then
    jWifiManager1.RequestWriteSettingsPermission();
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin

    {  //clean up code ...
    if jWifiManager1.IsWifiHotspotEnable() then
    begin
      jWifiManager1.SetWifiHotspotOff();
    end;
    }

    if jWifiManager1.CreateNewWifiNetwork() then
      ShowMessage('New Wifi Network Created!')
    else
      ShowMessage('Sorry.. Fail!')

end;

end.
