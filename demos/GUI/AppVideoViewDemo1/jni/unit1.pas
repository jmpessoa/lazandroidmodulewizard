{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppVideoViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, videoview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jCheckBox1: jCheckBox;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jVideoView1: jVideoView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
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
begin
  if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
  begin
    ShowMessage('Playing from raw resource....');
    //jVideoView1.SetProgressDialog(...);
     jVideoView1.PlayFromRawResource('bigbunny');
  end
  else  ShowMessage('Sorry... [android.permission.WRITE_EXTERNAL_STORAGE] denied... ' );
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

  if IsRuntimePermissionNeed() then   // that is, target API >= 23  - Android 6
  begin
      ShowMessage('RequestRuntimePermission....');
      //hint: if you  get "write" permission then you have "read", too!
      Self.RequestRuntimePermission(['android.permission.WRITE_EXTERNAL_STORAGE'], 2021);  // some/any value...
  end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
     2021:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
   end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if Self.isConnected() then
  begin
     //jVideoView1.SetProgressDialog(...);
     jVideoView1.PlayFromURL('http://docs.evostream.com/sample_content/assets/bun33s.mp4');    //asyncr
  end
  else
  begin
    ShowMessage('Please,  try enable some connection...');
  end;
end;

end.
