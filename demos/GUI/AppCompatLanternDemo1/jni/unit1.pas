{Hint: save all files to location: C:\android\workspace\AppCompatLanternDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, slantern;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jsLantern1: jsLantern;
    jTextView1: jTextView;
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
  if Self.IsRuntimePermissionGranted('android.permission.CAMERA') then
     jsLantern1.LightOn()
  else
     ShowMessage('Sorry... "android.permission.CAMERA" DENIED...');
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   if Self.IsRuntimePermissionNeed() then
   begin
      Self.RequestRuntimePermission(['android.permission.CAMERA'], 1678);
   end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  if requestCode = 1678 then
  begin
     if grantResult = PERMISSION_GRANTED then
     begin
        ShowMessage('Success! "android.permission.CAMERA" GRANTED!')
     end
     else
     begin
        ShowMessage('Sorry... "android.permission.CAMERA" DENIED...');
     end;
  end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jsLantern1.LightOff();
end;

end.
