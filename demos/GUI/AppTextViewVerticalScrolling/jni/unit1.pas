{hint: Pascal files location: ...\AppTextViewVerticalScrolling\jni }
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
    TextView1: jTextView;
    TextView2: jTextView;
    TextView3: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
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
var
  i: integer;
begin
   TextView3.SetScrollingMovementMethod();
   TextView3.SetVerticalScrollBarEnabled(True);

   TextView3.AppendLn('');
   for i:= 1 to 30 do
   begin
      TextView3.AppendLn('item ' + IntToStr(i));
   end;
end;

end.
