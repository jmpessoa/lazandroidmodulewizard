{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppCustomCameraDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, customcamera, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jCustomCamera1: jCustomCamera;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jCustomCamera1Click(Sender: TObject);
    procedure jCustomCamera1PictureTaken(Sender: TObject;
      bitmapPicture: jObject; fullPath: string);
    procedure jCustomCamera1SurfaceChanged(Sender: TObject; width: integer;
      height: integer);
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
  showmessage('Take Picture, wait...');
  jCustomCamera1.SetEnvironmentStorage(dirDownloads,'folderTest');

  jCustomCamera1.TakePicture('MyPicture5.jpg');
end;

procedure TAndroidModule1.jCustomCamera1Click(Sender: TObject);
begin
  showmessage('Auto Focus');
  jCustomCamera1.AutoFocus();
end;

procedure TAndroidModule1.jCustomCamera1PictureTaken(Sender: TObject;
  bitmapPicture: jObject; fullPath: string);
begin
   ShowMessage('Picture Take to = '+ fullPath);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  manifestPermissions: TDynArrayOfString;
begin

  //https://www.captechconsulting.com/blogs/runtime-permissions-best-practices-and-how-to-gracefully-handle-permission-removal
  //https://developer.android.com/guide/topics/security/permissions#normal-dangerous
  if  IsRuntimePermissionNeed() then   // that is, target API >= 23
  begin

      ShowMessage('warning: Requesting Runtime Permission.... please, wait..');

      SetLength(manifestPermissions, 2);

      manifestPermissions[0]:= 'android.permission.CAMERA';  //from AndroodManifest.xml
      manifestPermissions[1]:= 'android.permission.WRITE_EXTERNAL_STORAGE'; //from AndroodManifest.xml

      Self.RequestRuntimePermission(manifestPermissions, 1001);

      SetLength(manifestPermissions, 0);

  end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
     1001:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
  end;

  if  IsRuntimePermissionNeed() then
   jCustomCamera1.Refresh;
end;

procedure TAndroidModule1.jCustomCamera1SurfaceChanged(Sender: TObject;
  width: integer; height: integer);
begin
  ShowMessage('width = ' + intToStr(width) + '   height = ' + intToStr(height))
end;

end.
