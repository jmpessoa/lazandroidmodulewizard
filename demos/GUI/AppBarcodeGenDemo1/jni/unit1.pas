{Hint: save all files to location: C:\android\workspace\AppBarcodeGenDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, barcodegen;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBarcodeGen1: jBarcodeGen;
    jButton1: jButton;
    jButton2: jButton;
    jImageView1: jImageView;
    jImageView2: jImageView;
    jImageView3: jImageView;
    jTextView1: jTextView;
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
var
  bar128: jObjectRef;
  //str64: string;
begin

  bar128:= jBarcodeGen1.GetCode128Bar('Hello World  150x150!', 150,150);
  jImageView1.SetImage(bar128);

  //Save
 // jImageView2.SaveToFile(Self.GetEnvironmentDirectoryPath(dirDownloads)+ '/' + 'qrcodehello250.png');

  //str64:= jBitmap1.GetBase64StringFromImage(qrcode, cfPNG); //for print ???
  //ShowMessage(str64);

end;

//ref http://www.barcodeisland.com/ean13.phtml
procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  data_12Digits: string; //EAN_13
  data_7Digits: string;  //EAN_8
  checksum_1digit: string;
begin
  data_12Digits:= '007567816412';  //12 digits [data] ref. http://www.barcodeisland.com/ean13.phtml
  checksum_1digit:= jBarcodeGen1.GetEAN13Checksum(data_12Digits);
  jImageView2.SetImage(jBarcodeGen1.GetBar1D(fmEAN_13, data_12Digits + checksum_1digit, 150,150));

  data_7Digits:= '5512345';  //7 digits [data] ref. http://www.barcodeisland.com/ean8.phtml
  checksum_1digit:= jBarcodeGen1.GetEAN8Checksum(data_7Digits);
  jImageView3.SetImage(jBarcodeGen1.GetBar1D(fmEAN_8, data_7Digits + checksum_1digit, 150,150));
end;

end.
