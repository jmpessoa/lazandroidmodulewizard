{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppTextToSpeechDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, texttospeech;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jEditText1: jEditText;
    jTextToSpeech1: jTextToSpeech;
    jTextView1: jTextView;
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
  jTextToSpeech1.SpeechLanguage:= slEnglish;   //not default ....
  jTextToSpeech1.SpeakOn(jEditText1.Text); //used for the first call ..
  jTextToSpeech1.SpeakAdd('Hello World!');  // add more ...
  jTextToSpeech1.SpeakAdd('Hello Android!');   // add more ....
end;

end.
