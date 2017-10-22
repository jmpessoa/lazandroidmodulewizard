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
    jButton2: jButton;
    jEditText1: jEditText;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jTextToSpeech1: jTextToSpeech;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    jTextView5: jTextView;
    jTextView6: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
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
  jTextToSpeech1.SpeechLanguage:= slEnglish;   //not default ....
  jTextToSpeech1.SpeakOn(jEditText1.Text); //used for the first call ..
  jTextToSpeech1.SpeakAdd('Hello World!');  // add more ...
  jTextToSpeech1.SpeakAdd('Hello Android!');   // add more ....
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   ShowMessage('Please, you need enable the WiFi !!!');
   if Self.isConnectedWifi() then
      jTextToSpeech1.SpeakOnline('Bom dia Pessoal!', 'pt');   // pt = portuguese
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  ////You can basically set it from anything between 0(fully transparent) to 255 (completely opaque)
  jTextView2.SetBackgroundAlpha(45);
  jPanel1.SetBackgroundAlpha(45);
end;

end.
