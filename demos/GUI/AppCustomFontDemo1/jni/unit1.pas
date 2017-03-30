{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppCustomFontDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jCheckBox1: jCheckBox;
    jEditText1: jEditText;
    jRadioButton1: jRadioButton;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
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

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jTextView1.SetFontFromAssets('ARBONNIE.TTF');
  jButton1.SetFontFromAssets('ARBONNIE.TTF');
  jCheckBox1.SetFontFromAssets('ARBONNIE.TTF');
  jEditText1.SetFontFromAssets('ARBONNIE.TTF');
  jRadioButton1.SetFontFromAssets('ARBONNIE.TTF');

  //Font Awesome Icons from "/assets"
  jTextView2.SetFontFromAssets('fontawesome-webfont.ttf');
  jTextView3.SetFontFromAssets('fontawesome-webfont.ttf');
  jTextView4.SetFontFromAssets('fontawesome-webfont.ttf');

  //http://fontawesome.io/cheatsheet/
  jTextView2.Text:= Self.ParseHtmlFontAwesome('&#xf17b;');
  jTextView3.Text:= Self.ParseHtmlFontAwesome('&#xf1b0;');
  jTextView4.Text:= Self.ParseHtmlFontAwesome('&#xf118;');

end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  ShowMessage('Fonts Loaded from "\assets"');
end;

end.
