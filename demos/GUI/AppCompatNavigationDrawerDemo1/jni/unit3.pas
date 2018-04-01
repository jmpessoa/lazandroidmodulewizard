{Hint: save all files to location: \jni }
unit unit3;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule3 }

  TAndroidModule3 = class(jForm)
    jImageView1: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    procedure AndroidModule3JNIPrompt(Sender: TObject);
    procedure jImageView1Click(Sender: TObject);
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

procedure TAndroidModule3.jImageView1Click(Sender: TObject);
begin
    ShowMessage('Scene 3');
end;

procedure TAndroidModule3.AndroidModule3JNIPrompt(Sender: TObject);
begin
  ShowMessage('OnPrompt Scene 3');
end;

end.
