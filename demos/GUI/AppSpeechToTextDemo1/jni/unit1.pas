{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppSpeechToTextDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, speechtotext, Laz_And_Controls, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jSpeechToText1: jSpeechToText;
    jTextView1: jTextView;
    procedure AndroidModule1ActivityResult(Sender: TObject;
      requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
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
  Self.jSpeechToText1.SpeakIn();
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin
   if resultCode = RESULT_OK then
   begin
     if  requestCode = 1234 then
     begin
       ShowMessage(jSpeechToText1.SpeakOut(intentData));
     end;
   end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jButton1.SetCompoundDrawables('ic_microphone', cdsLeft);
end;

end.
