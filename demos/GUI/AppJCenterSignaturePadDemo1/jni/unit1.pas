{Hint: save all files to location: C:\android\workspace\AppJCenterSignaturePadDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, csignaturepad;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jcSignaturePad1: jcSignaturePad;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure AndroidModule1Rotate(Sender: TObject; rotate: TScreenStyle);
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


//ref.  https://github.com/gcacace/android-signaturepad

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jcSignaturePad1.Clear();
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
 if Self.IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE') then
 begin
   //jcSignaturePad1.SaveToGalleryJPG(); //ramdom "Signature_xxyyzzz.jpg"
   //jcSignaturePad1.SaveToGalleryJPG('mysinature.jpg');  //save as "mysinature.jpg"
   jcSignaturePad1.SaveToFileJPG(Self.GetEnvironmentDirectoryPath(dirPictures), 'sinature11.jpg');
   ShowMessage('Signature saved....');
 end
 else
   ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" DENIED...');
end;

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject;
  rotate: TScreenStyle);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if Self.IsRuntimePermissionNeed() then
  begin     //
     Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE', 1514);
  end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  if requestCode = 1514 then
  begin
     if grantResult = PERMISSION_GRANTED then
       ShowMessage('Please,  Enable Location Services...')
     else
       ShowMessage('Sorry... "'+manifestPermission+'" DENIED...');
  end;
end;

end.
