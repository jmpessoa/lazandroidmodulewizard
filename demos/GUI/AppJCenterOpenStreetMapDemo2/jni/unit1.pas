{Hint: save all files to location: C:\android\workspace\AppJCenterOpenStreetMapDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, unit2;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
    HasPermission: boolean;
    Procedure CloseCallBackNotify(Sender: TObject);
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if AndroidModule2 = nil then
   begin
      gApp.CreateForm(TAndroidModule2, AndroidModule2);
      AndroidModule2.HasPermission:= HasPermission;
      AndroidModule2.SetCloseCallBack(CloseCallBackNotify, Self);
      AndroidModule2.Init(gApp); //call OnJNIPrompt in form2
      AndroidModule2.Show;
   end
   else
   begin
      AndroidModule2.HasPermission:= HasPermission;
      AndroidModule2.ReInit(gApp);  //not AndroidModule2.Show();
      AndroidModule2.Show;
   end;
end;

procedure TAndroidModule1.CloseCallBackNotify(Sender: TObject);
begin
  ShowMessage('Form 2 closed...')
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if Self.IsRuntimePermissionNeed() then
  begin
    Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE', 1235); //need by OpenMapView images/tiles cache...
  end
  else HasPermission:= True;
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  HasPermission:= False;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  if requestCode = 1235 then
  begin
     if grantResult = PERMISSION_GRANTED then
     begin
       ShowMessage('Success!!  "android.permission.WRITE_EXTERNAL_STORAGE" GRANTED!!');
       HasPermission:= True;
     end
     else
     begin
        ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" DENIED...');
        HasPermission:= False;
     end;
  end;
end;

end.
