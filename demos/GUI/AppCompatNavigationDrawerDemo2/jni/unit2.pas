{Hint: save all files to location: C:\android\workspace\AppCompatNavigationDrawerDemo2\jni }
unit unit2;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, scardview;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jPanel1: jPanel;
    jsCardView1: jsCardView;
    jTextView1: jTextView;
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation
  
{$R *.lfm}
  

end.
