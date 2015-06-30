{Hint: save all files to location: \jni }
unit unit4;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;

type

  { TAndroidModule4 }

  TAndroidModule4 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    procedure AndroidModule4JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule4: TAndroidModule4;

implementation

{$R *.lfm}

{ TAndroidModule4 }

procedure TAndroidModule4.AndroidModule4JNIPrompt(Sender: TObject);
begin
    ShowMessage('jForm 4 jni prompt!  FormBaseIndex = '+ IntToStr(Self.FormBaseIndex)+
                                   '  FormIndex = '+ IntToStr(Self.FormIndex));
end;

procedure TAndroidModule4.jButton1Click(Sender: TObject);
begin
  ShowMessage('jForm 4 Hello!');
end;

end.
