unit unit1;
//

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, Laz_And_Controls, AndroidWidget, location;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jButton1: jButton;
    jCamera1: jCamera;
    jImageView1: jImageView;
    jLocation1: jLocation;
    jTextView1: jTextView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jLocation1LocationChanged(Sender: TObject; latitude: double;
      longitude: double; altitude: double; address: string);
  private
    {private declarations}
    FPhotoLatitude: string;
    FPhotoLongitude: string;

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
   if IsRuntimePermissionGranted('android.permission.CAMERA') and
      IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
   begin
       jCamera1.RequestCode := 12345;
       jCamera1.TakePhoto;
   end
   else  ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');
end;

procedure TAndroidModule1.jLocation1LocationChanged(Sender: TObject;
  latitude: double; longitude: double; altitude: double; address: string);
begin
    ShowMessage('Success! Location Changed....' + address);
    FPhotoLatitude:=  FloatToStr(latitude);
    FPhotoLongitude:= FloatToStr(longitude);
end;


procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
var
  tempBitmap: jObjectRef;
  photoPath: string;
begin
  if resultCode = RESULT_CANCELED then
  begin
    ShowMessage('Photo Canceled!')
  end
  else if resultCode = RESULT_OK then //ok...
  begin
    if requestCode = jCamera1.RequestCode then
    begin
      photoPath:= jCamera1.FullPathToBitmapFile;   //DCIM

      ShowMessage(photoPath);

      jBitmap1.LoadFromFile(photoPath);

      jBitmap1.DrawText('LT: '+FPhotoLatitude +'  LG: '+ FPhotoLongitude,
                                     100,
                                     jBitmap1.Height-100, 50, colbrBlue);

      jImageView1.SetImageBitmap(jBitmap1.GetImage, jImageView1.Width, jImageView1.Height);
      jImageView1.SetRotation(90);

      //or
      //photoPath:= Self.GetEnvironmentDirectoryPath(dirDownloads)+ '/MyPicture5Hello.jpg');  //etc...
      jBitmap1.SaveToFileJPG(photoPath);

    end;
  end
  else
    ShowMessage('Photo Fail!');

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

      Self.RequestRuntimePermission(manifestPermissions, 1101);

      SetLength(manifestPermissions, 0);

  end
  else
  begin
     if not jLocation1.IsGPSProvider then
     begin
        ShowMessage('Sorry, GPS is Off. Please, active it and try again.');
        jLocation1.ShowLocationSouceSettings()
     end
     else
     begin
        ShowMessage('GPS is On! Starting Tracker...');
        jLocation1.StartTracker();  //handled by "OnLocationChanged"
     end;
  end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
   case requestCode of
     1101:begin

            if manifestPermission = 'android.permission.CAMERA' then
            begin
                {
                if grantResult = PERMISSION_GRANTED  then
                  ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
                else  //PERMISSION_DENIED
                   ShowMessage('Sorry... ['+manifestPermission+'] DENIED... ' );
                }
            end;

            if manifestPermission = 'android.permission.WRITE_EXTERNAL_STORAGE' then
            begin
                {
                if grantResult = PERMISSION_GRANTED  then
                   ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
                else  //PERMISSION_DENIED
                   ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
                }
            end;

            if manifestPermission = 'android.permission.ACCESS_FINE_LOCATION' then
            begin
              if grantResult = PERMISSION_GRANTED  then
              begin
                  if not jLocation1.IsGPSProvider then
                  begin
                     ShowMessage('Sorry, GPS is Off. Please, active it and try again.');
                     jLocation1.ShowLocationSouceSettings()
                  end
                  else
                  begin
                     ShowMessage('GPS is On! Starting Tracker...');
                     jLocation1.StartTracker();  //handled by "OnLocationChanged"
                  end;
              end;
            end;

          end;
  end;
end;


end.
