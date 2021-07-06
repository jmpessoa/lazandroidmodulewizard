{hint: Pascal files location: ...\\jni }
unit unit3;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, And_jni;
  
type

  { TAndroidModule3 }

  TAndroidModule3 = class(jForm)
    jImageView1: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule3: TAndroidModule3;

implementation
  
{$R *.lfm}


end.
