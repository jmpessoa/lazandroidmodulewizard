{Hint: save all files to location: \jni }
unit unit2;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, ratingbar, switchbutton;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jCheckBox1: jCheckBox;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jRatingBar1: jRatingBar;
    jSwitchButton1: jSwitchButton;
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
