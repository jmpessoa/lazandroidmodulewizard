{Hint: save all files to location: C:\adt32\eclipse\workspace\AppNotificationManagerDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, notificationmanager, intentmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jIntentManager1: jIntentManager;
      jNotificationManager1: jNotificationManager;
      jTextView1: jTextView;
      procedure AndroidModule1ActivityCreate(Sender: TObject;
        intentData: jObject);
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
    jNotificationManager1.SetContentIntent('com.example.appnotificationmanagerdemo1', 'App', 'MyCustomDataName','Hello! here is My Custom Data Value');
    jNotificationManager1.Notify();
    ShowMessage('Notification ok ... ');
end;

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject;
  intentData: jObject);
var
  strData: string;
begin
  strData:= jIntentManager1.GetExtraString(intentData, 'MyCustomDataName'); //user defined data
  if strData <> '' then ShowMessage(strData);

  strData:= jIntentManager1.GetExtraString(intentData, 'content');  //"content" = default data
  if strData <> '' then ShowMessage(strData);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if IsRuntimePermissionNeed() then   // that is, if target API >= 23
  begin
    ShowMessage('Requesting POST_NOTIFICATIONS Runtime Permission....');
    Self.RequestRuntimePermission(['android.permission.POST_NOTIFICATIONS'], 1318);   //handled by OnRequestPermissionResult
  end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
    1318:begin
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

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   ShowMessage('Set Led to "Red" ...');
   jNotificationManager1.SetLightsColor(colbrRed);
end;


end.
