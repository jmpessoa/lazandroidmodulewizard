{Hint: save all files to location: C:\adt32\eclipse\workspace\AppRatingBarDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, ratingbar, seekbar, analogclock;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jRatingBar1: jRatingBar;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jRatingBar1RatingChanged(Sender: TObject; rating: single);
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

procedure TAndroidModule1.jRatingBar1RatingChanged(Sender: TObject;
  rating: single);
begin
  ShowMessage('Rating='+ FloatToStr(rating) + 'stars');
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   ShowMessage('Rating= '+ FloatToStr(jRatingBar1.GetRating()) + ' stars');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jRatingBar1.SetRating(3);
end;

end.
