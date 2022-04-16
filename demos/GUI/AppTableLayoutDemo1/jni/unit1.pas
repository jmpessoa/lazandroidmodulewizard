{hint: Pascal files location: ...\AppTableLayoutDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, tablelayout;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    TableLayout1: jTableLayout;
    TextView1: jTextView;
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
begin

   //TableLayout1.SeInnerTextContentDelimiter('&');  //default

   TableLayout1.SetRowTextColor(colbrWhite);
   TableLayout1.AddTextRow('Item|Book&Author|Location&Year', '|', colbrBlue);

   TableLayout1.SetRowTextColor(colbrBlack);
   TableLayout1.AddTextRow('1|One Hundred Years of Solitude&Gabriel Garcia Marquez|Colombia&1967', '|', colbrLightSkyBlue);
   TableLayout1.AddTextRow('2|Barren Lives&Graciliano Ramos|Brazil&1938', '|', colbrLightSeaGreen);
   TableLayout1.AddTextRow('3|Les Miserables&Victor Hugo|French&1862', '|', colbrLightSkyBlue);
   TableLayout1.AddTextRow('4|Faust&Johann Wolfgang von Goethe|Germany&1808', '|', colbrLightSeaGreen);
   TableLayout1.AddTextRow('5|Don Quixote&Miguel de Cervantes|Spanish&1605', '|', colbrLightSkyBlue);

end;

end.
