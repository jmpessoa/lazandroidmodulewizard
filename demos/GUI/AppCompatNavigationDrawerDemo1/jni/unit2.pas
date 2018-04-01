{Hint: save all files to location: \jni }
unit unit2;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jImageView1: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    procedure AndroidModule2JNIPrompt(Sender: TObject);
    procedure jImageView1Click(Sender: TObject);

  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation
  
{$R *.lfm}
  

{ TAndroidModule2 }


procedure TAndroidModule2.jImageView1Click(Sender: TObject);
begin
  ShowMessage('Scene 2');
end;

procedure TAndroidModule2.AndroidModule2JNIPrompt(Sender: TObject);
begin
   ShowMessage('OnPrompt Scene 2');
end;

end.
