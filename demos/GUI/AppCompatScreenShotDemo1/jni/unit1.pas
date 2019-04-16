{Hint: save all files to location: C:\android\workspace\AppCompatScreenShotDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, sscreenshot;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jEditText1: jEditText;
    jListView1: jListView;
    jsScreenShot1: jsScreenShot;
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

  jsScreenShot1.TakeScene(jTextView1.View);  // reference view

  if Self.IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
     jsScreenShot1.SaveToFile('ScreenShotDemo1')   //Save to Picture Folder....
  else
     ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" DENIED ...');

end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if Self.IsRuntimePermissionNeed() then
  begin
     Self.RequestRuntimePermission(['android.permission.WRITE_EXTERNAL_STORAGE'], 3456);
  end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  if requestCode = 3456 then
  begin
     if grantResult = PERMISSION_GRANTED then
       ShowMessage('Success! "android.permission.WRITE_EXTERNAL_STORAGE" GRANTED !!')
     else
       ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" DENIED ...');
  end;
end;

end.
