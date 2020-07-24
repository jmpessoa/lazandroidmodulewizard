{Hint: save all files to location: C:\android\workspace\AppQRGenDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, cqrgen;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jButton1: jButton;
    jButton2: jButton;
    jcQRGen1: jcQRGen;
    jImageView1: jImageView;
    jImageView2: jImageView;
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
  jImageView1.SetImage(jcQRGen1.GetTextQRCode('Hello World!'));
  //Save
  jImageView1.SaveToFile(Self.GetEnvironmentDirectoryPath(dirDownloads)+ '/' + 'qrcodehello1.png');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  qrcode: jObjectRef;
  //str64: string;
begin

  qrcode:= jcQRGen1.GetTextQRCode('Hello World  250x250!', 250,250);
  jImageView2.SetImage(qrcode);

  //Save
  jImageView2.SaveToFile(Self.GetEnvironmentDirectoryPath(dirDownloads)+ '/' + 'qrcodehello250.png');

  //str64:= jBitmap1.GetBase64StringFromImage(qrcode, cfPNG); //for print ???
  //ShowMessage(str64);

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
    2713:begin
            if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! "'+ manifestPermission + '" granted!')
            else//PERMISSION_DENIED
                ShowMessage('Sorry... "android.permission.WRITE_EXTERNAL_STORAGE" permission not granted... ' );
         end;
  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   if IsRuntimePermissionNeed() then   // that is, if target API >= 23
   begin
     ShowMessage('Requesting Runtime Permission....');
     Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE', 2713);   //handled by OnRequestPermissionResult
   end
end;

end.
