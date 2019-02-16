{Hint: save all files to location: C:\adt32\eclipse\workspace\AppDownloadServiceDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, downloadservice,
  broadcastreceiver, intentmanager;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBroadcastReceiver1: jBroadcastReceiver;
    jButton1: jButton;
    jCheckBox1: jCheckBox;
    jDownloadService1: jDownloadService;
    jImageView1: jImageView;
    jIntentManager1: jIntentManager;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
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

    //hint: if you  get "write" permission then you have "read", too!
    if not IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
    begin
      ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');
      Exit;
    end;

    if not Self.isConnected() then
    begin
       ShowMessage('Sorry, Device is not connected...');
       Exit;
    end;

    ShowMessage('Downloading...');
    jBroadcastReceiver1.RegisterIntentActionFilter('com.example.appdownloadservicedemo1.DOWNLOAD_RECEIVER');

    jDownloadService1.SaveToFile(Self.GetEnvironmentDirectoryPath(dirDownloads), 'ship2.jpg');
    jDownloadService1.Start('http://clipart-library.com/images/8c65qk6ei.jpg',
                                 'com.example.appdownloadservicedemo1.DOWNLOAD_RECEIVER');

end;

procedure TAndroidModule1.jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
var
  res: string;
  elapsedTime: integer;
begin

  //ShowMessage('from: ' + jIntentManager1.GetAction(intent) );
  ShowMessage(jIntentManager1.GetExtraString(intent, 'FilePath') );

  res:= jIntentManager1.GetExtraString(intent, 'Result');
  ShowMessage('Result = ' + res);

  elapsedTime:= jIntentManager1.GetExtraInt(intent, 'ElapsedTimeInSeconds');
  ShowMessage('Elapsed Time = '+ IntToStr(elapsedTime) +' sec');

  jBroadcastReceiver1.Unregister();  //unregister BroadcastReceiver ...

  jImageView1.SetImage(Self.GetEnvironmentDirectoryPath(dirDownloads)+'/'+'ship2.jpg');

end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  manifestPermissions: array of string;
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

       SetLength(manifestPermissions, 1);

       //hint: if you  get "write" permission then you have "read", too!
       manifestPermissions[0]:= 'android.permission.WRITE_EXTERNAL_STORAGE'; //from AndroodManifest.xml
       Self.RequestRuntimePermission(manifestPermissions, 802);

       SetLength(manifestPermissions, 0);
    end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
     802:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
   end;
end;

end.
