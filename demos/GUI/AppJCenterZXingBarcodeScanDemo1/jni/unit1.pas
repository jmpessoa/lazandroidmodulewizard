{hint: Pascal files location: ...\AppJCenterZXingBarcodeScanDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, ujczxingbarcodescan, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    Button1: jButton;
    TextView1: jTextView;
    ZXingBarcodeScan1: jcZXingBarcodeScan;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
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

procedure TAndroidModule1.Button1Click(Sender: TObject);
begin
  ZXingBarcodeScan1.ScanForResult();  //default: zxfQR_CODE
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
var
  dataResult: string;
begin
   if resultCode = RESULT_OK then
   begin
      if requestCode = ZXingBarcodeScan1.RequestCodeForResult then //default: 49374
      begin
         dataResult:= ZXingBarcodeScan1.GetContentFromResult(intentData);
         ShowMessage(dataResult); // Success !!!
      end;
   end
   else //RESULT_CANCELED
   begin
      ShowMessage('Cancelled ...');
   end;
end;

end.
