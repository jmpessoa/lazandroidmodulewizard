{Hint: save all files to location: \jni }
unit unit3;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;

type

  { TAndroidModule3 }

  TAndroidModule3 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    procedure AndroidModule3JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule3: TAndroidModule3;

implementation

{$R *.lfm}

{ TAndroidModule3 }

procedure TAndroidModule3.jButton1Click(Sender: TObject);
begin
     ShowMessage('jForm 3 Hello!');
end;

procedure TAndroidModule3.AndroidModule3JNIPrompt(Sender: TObject);
begin
     ShowMessage('jForm 3 jni prompt!  FormBaseIndex = '+ IntToStr(Self.FormBaseIndex)+
                                    '  FormIndex = '+ IntToStr(Self.FormIndex));
end;

end.
