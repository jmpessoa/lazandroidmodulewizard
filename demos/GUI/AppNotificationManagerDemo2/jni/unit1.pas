{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppNotificationManagerDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, intentmanager, And_jni,
  notificationmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jCheckBox1: jCheckBox;
    jIntentManager1: jIntentManager;
    jNotificationManager1: jNotificationManager;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
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

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jIntentManager1.SetAction(iaView);  //or jIntentManager1.SetAction('android.intent.action.VIEW');
  jIntentManager1.SetDataUriAsString('http://forum.lazarus.freepascal.org/index.php?action=forum');
  jNotificationManager1.SetContentIntent(jIntentManager1.GetIntent());
  jNotificationManager1.Notify();
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  if IsRuntimePermissionNeed() then   // that is, if target API >= 23
  begin
    ShowMessage('Requesting POST_NOTIFICATIONS Runtime Permission....');
    Self.RequestRuntimePermission(['android.permission.POST_NOTIFICATIONS'], 1117);   //handled by OnRequestPermissionResult
  end;

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

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
  1117:begin
         if grantResult = PERMISSION_GRANTED  then
         begin
            if manifestPermission = 'android.permission.POST_NOTIFICATIONS' then
               ShowMessage('"'+manifestPermission+'"  granted!');
         end
        else//PERMISSION_DENIED
        begin
            ShowMessage('Sorry... "['+manifestPermission+']" not granted... ' );
        end;
     end;
  end;
end;

end.
