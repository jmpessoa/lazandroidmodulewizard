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
