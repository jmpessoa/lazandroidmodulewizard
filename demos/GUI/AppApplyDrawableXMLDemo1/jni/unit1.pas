{hint: Pascal files location: ...\AppApplyDrawableXMLDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jEditText1: jEditText;
    jImageView1: jImageView;
    jImageView2: jImageView;
    jTextView1: jTextView;
    jTextView2: jTextView;
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
  jTextView1.ApplyDrawableXML('textshape'); //from ...res/drawable
  jTextView2.ApplyDrawableXML('text2shape'); //from ...res/drawable

  jEditText1.ApplyDrawableXML('editshape'); //from ...res/drawable

  jImageView1.ApplyDrawableXML('imagelayer');  //from ...res/drawable

  jButton1.ApplyDrawableXML('buttonshape');   //from ...res/drawable
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
    jImageView2.ApplyDrawableXML('imageshape'); //from ...res/drawable
end;

end.
