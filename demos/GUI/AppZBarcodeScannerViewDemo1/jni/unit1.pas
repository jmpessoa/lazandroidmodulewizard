{Hint: save all files to location: C:\android\workspace\AppZBarcodeScannerViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, zbarcodescannerview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jButton1: jButton;
    jButton2: jButton;
    jTextView1: jTextView;
    jZBarcodeScannerView1: jZBarcodeScannerView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jZBarcodeScannerView1Click(Sender: TObject);
    procedure jZBarcodeScannerView1ScannerResult(Sender: TObject;
      codedata: string; codeformat: TBarcodeFormat);
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
  jBitmap1.LoadFromAssets('codebar1.png');  //or qrcode1.png
  jZBarcodeScannerView1.Scan(jBitmap1.GetImage());
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   if IsRuntimePermissionNeed() then   // that is, if target API >= 23
   begin
     ShowMessage('Requesting Runtime Permission....');
     Self.RequestRuntimePermission('android.permission.CAMERA', 1113);   //handled by OnRequestPermissionResult
   end
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
    1113:begin
            if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! "'+ manifestPermission + '" granted!')
            else//PERMISSION_DENIED
                ShowMessage('Sorry... "android.permission.CAMERA" permission not granted... ' );
         end;
  end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   if IsRuntimePermissionGranted('android.permission.CAMERA') then
  begin
     jZBarcodeScannerView1.Scan();
  end;
end;

procedure TAndroidModule1.jZBarcodeScannerView1Click(Sender: TObject);
begin
  if IsRuntimePermissionGranted('android.permission.CAMERA') then
  begin
     jZBarcodeScannerView1.Scan();
  end;
end;

procedure TAndroidModule1.jZBarcodeScannerView1ScannerResult(Sender: TObject;
  codedata: string; codeformat: TBarcodeFormat);
begin
  ShowMessage('codedata = '+ codedata + '    ::    codeformat = ' + IntToStr(Ord(codeformat)));
end;

end.
