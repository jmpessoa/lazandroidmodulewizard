{hint: Pascal files location: ...\AppImageViewRippleEffectDemo1\jni }
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
    ImageView1: jImageView;
    ImageView2: jImageView;
    TextView1: jTextView;
    TextView2: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure ImageView1Click(Sender: TObject);
    procedure ImageView2Click(Sender: TObject);
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

//thanks to Agmcz!
//https://forum.lazarus.freepascal.org/index.php/topic,59097.0.html
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

   //Set drawable xml "ripple" -> need minSdkVersion >= 21!
  ImageView1.ApplyDrawableXML('image_ripple_effect');  //from ...res/drawable
  //Set Ripple Effect need "min device" api >= 23
  ImageView1.SetRippleEffect;


  //Set drawable xml "shape" Round Corner
  ImageView2.ApplyDrawableXML('image_shape_rounded_corners_ripple_effect'); //from ...res/drawable
  // Set Ripple Effect need "min device" api >= 23
  ImageView2.SetRippleEffect;

end;

procedure TAndroidModule1.ImageView1Click(Sender: TObject);
begin
  ShowMessage('ImageView1 Clicked!');
end;


procedure TAndroidModule1.ImageView2Click(Sender: TObject);
begin
   ShowMessage('ImageView2 Clicked!');
end;

end.
