{hint: Pascal files location: ...\AppCompatKToyButtonDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, uktoybutton;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    TextView1: jTextView;
    ToyButton1: KToyButton;
    procedure ToyButton1Click(Sender: TObject);
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

//the "KToyButton" (AppCompat) is an unfinished component ...
//but a milistone as "proof of concept!"
procedure TAndroidModule1.ToyButton1Click(Sender: TObject);
begin
  ShowMessage('Hello, World! Welcome to LAMW + Kotlin!');
end;

end.
