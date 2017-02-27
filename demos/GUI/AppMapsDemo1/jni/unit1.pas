{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppMapsDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, gmaps;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jCheckBox1: jCheckBox;
    jMaps1: jMaps;
    jTextView1: jTextView;
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

{
current_lat:=    40.737102; //
current_longi:= -73.990318; //
}

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if  jMaps1.IsAppMapsInstalled() then
   begin
      jMaps1.Show('-15.8739405', '-52.3134635', 'UFMT');
      //jMaps1.Navigation(...);
      //jMaps1.StreetView(...);
      //jMaps1.Search(...);
      //jMaps1.SearchCategory('restaurant');

   end
   else
   begin
     ShowMessage('Please, Install google Maps app....');
   end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
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

end.
