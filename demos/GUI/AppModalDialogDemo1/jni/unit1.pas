{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppModalDialogDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, modaldialog, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jModalDialog1: jModalDialog;
    jTextView1: jTextView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
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
   jModalDialog1.SetDialogTitle('Nice Title');
   jModalDialog1.SetDialogMessage('Hello World!');
   jModalDialog1.TitleFontSize:= 20;
   jModalDialog1.CaptionOK:= 'Close';
   jModalDialog1.ShowMessage(Self.PackageName);   //OR gApp.AppName OR 'org.lamw.appmodaldialogdemo1'
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  requestInfoList: TDynArrayOfString;
begin

   SetLength(requestInfoList, 3);
   requestInfoList[0]:= 'DATA_0|hint 0';  //DATA_NAME|Input Hint
   requestInfoList[1]:= 'DATA_1|hint 1';
   requestInfoList[2]:= 'DATA_2|hint 2';

   jModalDialog1.SetRequestCode(1001);
   jModalDialog1.TitleFontSize:= 20;
   jModalDialog1.CaptionOK:= 'OK';
   jModalDialog1.CaptionCancel:= 'Cancel';

   jModalDialog1.SetDialogTitle('Input Data');
   jModalDialog1.SetDialogMessage('Please, enter some data...');

   jModalDialog1.InputForActivityResult(Self.PackageName, requestInfoList);

   SetLength(requestInfoList, 0);
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
   jModalDialog1.SetRequestCode(1002);
   jModalDialog1.SetDialogTitle('Question');
   jModalDialog1.SetDialogMessage('Do you like LAMW ?');
   jModalDialog1.TitleFontSize:= 20;
   jModalDialog1.CaptionOK:= 'Yes';
   jModalDialog1.CaptionCancel:= 'No';
   jModalDialog1.QuestionForActivityResult(Self.PackageName);   //force "dlgShowMessage"
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin

   if requestCode = 1001 then  //user def code.... dlgInput
   begin
     if resultCode  = RESULT_OK then
     begin
         ShowMessage(jModalDialog1.GetStringValue(intentData, 'DATA_0'));
         ShowMessage(jModalDialog1.GetStringValue(intentData, 'DATA_1'));
         ShowMessage(jModalDialog1.GetStringValue(intentData, 'DATA_2'));
     end
     else
     begin
         ShowMessage('Canceled...');
     end;
   end;

   if requestCode = 1002 then  //user def code... for dlgQuestion
   begin
       if resultCode = RESULT_OK then
           ShowMessage('Yes, I like LAMW!');

       if resultCode = RESULT_CANCELED then
           ShowMessage('Sorry, I do not try LAMW, yet.');
   end;

end;

end.
