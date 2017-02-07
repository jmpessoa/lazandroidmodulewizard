{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppViewFlipperDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, viewflipper;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jImageList1: jImageList;
    jImageView1: jImageView;
    jImageView2: jImageView;
    jImageView3: jImageView;
    jTextView1: jTextView;
    jViewFlipper1: jViewFlipper;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jViewFlipper1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
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

procedure TAndroidModule1.jViewFlipper1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
begin
  if flingGesture = fliRightToLeft then jViewFlipper1.Next();
  if flingGesture =  fliLeftToRight then jViewFlipper1.Previous();
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  //jViewFlipper1.SetAutoStart(True);
end;

end.
