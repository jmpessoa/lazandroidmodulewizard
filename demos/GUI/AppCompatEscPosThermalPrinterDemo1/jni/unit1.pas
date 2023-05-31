{hint: Pascal files location: ...\AppCompatEscPosThermalPrinterDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, ujsescposthermalprinter;
  
type


  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    Button1: jButton;
    EscPosThermalPrinter1: jsEscPosThermalPrinter;
    TextView1: jTextView;
    procedure Button1Click(Sender: TObject);
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

//https://github.com/DantSu/ESCPOS-ThermalPrinter-Android
//https://forum.lazarus.freepascal.org/index.php/topic,63495.0.html
procedure TAndroidModule1.Button1Click(Sender: TObject);
var
  formattedContent: TStringList;
begin
  formattedContent:= TStringList.Create;

  //charsetName – Name of charset encoding (Ex: windows-1252)
  //escPosCharsetId – Id of charset encoding for your printer (Ex: 16)
  //https://www.epson-biz.com/modules/ref_escpos/index.php?content_id=32

  //before "InitConnection"
  //EscPosThermalPrinter1.SetCharsetEncoding('windows-1252', 16);  //optional: set only if you need it!

  if EscPosThermalPrinter1.InitConnection(connBluetooth, 203, 48, 32) then
  begin
    formattedContent.Add('[C]<img>' + EscPosThermalPrinter1.ImageToHexadecimalString('ic_logo_lamw') + '</img>');
    formattedContent.Add('[L]');
    formattedContent.Add('[C]<u><font size=''big''>ORDER N. 045</font></u>');
    formattedContent.Add('[L]"');
    formattedContent.Add('[C]================================');
    formattedContent.Add('[L]');
    formattedContent.Add('[L]<b>BEAUTIFUL SHIRT</b>[R]9.99e\');
    formattedContent.Add('[L]  + Size : S');
    formattedContent.Add('[L]');
    formattedContent.Add('[L]<b>AWESOME HAT</b>[R]24.99e');
    formattedContent.Add('[L]  +  Size : 57/58');
    formattedContent.Add('[L]');
    formattedContent.Add('[C]--------------------------------');
    formattedContent.Add('[R]TOTAL PRICE :[R]34.98e');
    formattedContent.Add('[R]TAX :[R]4.23e');
    formattedContent.Add('[L]');
    formattedContent.Add('[C]================================');
    formattedContent.Add('[L]');
    formattedContent.Add('[L]<font size=''tall''>Customer :</font>');
    formattedContent.Add('[L]Raymond DUPONT');
    formattedContent.Add('[L]5 rue des girafes');
    formattedContent.Add('[L]31547 PERPETES');
    formattedContent.Add('[L]Tel : +33801201456');
    formattedContent.Add('[L]');
    formattedContent.Add('[C]<barcode type=''ean13'' height=''10''>831254784551</barcode>');
    formattedContent.Add('[C]<qrcode size=''20''>https://dantsu.com/</qrcode>');

    EscPosThermalPrinter1.PrintFormattedText(formattedContent.Text);   //print it!!!
  end;

  formattedContent.Free;
end;

end.
