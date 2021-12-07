{hint: Pascal files location: ...\AppToneGeneratorDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, tonegenerator;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    jToneGenerator1: jToneGenerator;
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

//ref. http://android-er.blogspot.com/2014/12/sound-samples-generated-by.html
procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  ShowMessage(jToneGenerator1.Play());
end;

end.
