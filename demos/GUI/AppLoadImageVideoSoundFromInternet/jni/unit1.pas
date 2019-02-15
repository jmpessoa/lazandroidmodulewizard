{Hint: save all files to location: C:\adt32\eclipse\workspace\AppLoadImageVideoSoundFromInternet\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, imagefilemanager, mediaplayer,
  surfaceview;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jCheckBox1: jCheckBox;
    jDialogProgress1: jDialogProgress;
    jImageView1: jImageView;
    jMediaPlayer1: jMediaPlayer;
    jSurfaceView1: jSurfaceView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jImageView1Click(Sender: TObject);
    procedure jMediaPlayer1Completion(Sender: TObject);
    procedure jMediaPlayer1Prepared(Sender: TObject; videoWidth: integer;
      videoHeight: integer);
    procedure jSurfaceView1SurfaceCreated(Sender: TObject;
      surfaceHolder: jObject);
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

//try Wifi ...
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
      Self.RequestRuntimePermission(['android.permission.WRITE_EXTERNAL_STORAGE'], 6006);  // some/any value...
  end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
     6006:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
   end;
end;

//jMediaPlayer1.LoadFromAssets('testsong_20_sec.mp3');
procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jMediaPlayer1.LoadFromURL('http://www.hrupin.com/wp-content/uploads/mp3/testsong_20_sec.mp3');  //async
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jMediaPlayer1.LoadFromURL('http://docs.evostream.com/sample_content/assets/bun33s.mp4'); //async
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  ShowMessage('Click the image to save it!');
  jImageView1.LoadFromURL('http://miftyisbored.com/wp-content/uploads/2013/07/nature-sound-spa-app.png'); //asyncr
end;

procedure TAndroidModule1.jImageView1Click(Sender: TObject);
begin
  if IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then  //if we can write then we can read!
  begin
    jImageView1.SaveToFile(Self.GetEnvironmentDirectoryPath(dirDownloads)+ '/nature-spa.png');
    ShowMessage('Image Saved to folder Download...');
  end
  else  ShowMessage('Sorry... [android.permission.WRITE_EXTERNAL_STORAGE] denied... ' );
end;

//here Start/Play  the Sound/Video
procedure TAndroidModule1.jMediaPlayer1Prepared(Sender: TObject;
  videoWidth: integer; videoHeight: integer);
begin
  jMediaPlayer1.Start();
end;

//needed to Show Video
procedure TAndroidModule1.jSurfaceView1SurfaceCreated(Sender: TObject; surfaceHolder: jObject);
begin
   jMediaPlayer1.SetDisplay(surfaceHolder);
end;

//Sound/Video End ...!
procedure TAndroidModule1.jMediaPlayer1Completion(Sender: TObject);
begin
   ShowMessage('The End!');
end;

end.
