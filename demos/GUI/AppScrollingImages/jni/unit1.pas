{Hint: save all files to location: C:\android\workspace\AppScrollingImages\jni }
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
    jBitmap1: jBitmap;
    jHorizontalScrollView1: jHorizontalScrollView;
    jImageView1: jImageView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jHorizontalScrollView1InnerItemClick(Sender: TObject;itemId: integer);
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
  bmp: jObjectRef;
  strDensity: string;
begin

  //WARNING:  jHorizontalScrollView1.InnerLayout -> ilLinear;  //MUST be seted in design time! [object inspector]
  //LinearLayout dont need anchor!!

  strDensity:= Self.GetScreenDensity();
  Self.SetDensityAssets(strDensity);

  bmp:= jBitmap1.GetThumbnailImageFromAssets('baloons.jpg', jHorizontalScrollView1.Height);
  jHorizontalScrollView1.AddImage(bmp,101, scaleFitXY);

  bmp:= jBitmap1.GetThumbnailImageFromAssets('lightning.jpg',jHorizontalScrollView1.Height);
  jHorizontalScrollView1.AddImage(bmp,102, scaleFitXY);

  bmp:= jBitmap1.GetThumbnailImageFromAssets('wall.jpg',jHorizontalScrollView1.Height);
  jHorizontalScrollView1.AddImage(bmp,103, scaleFitXY);

  bmp:= jBitmap1.GetThumbnailImageFromAssets('veneza.jpg',jHorizontalScrollView1.Height);
  jHorizontalScrollView1.AddImage(bmp,104, scaleFitXY);

end;

procedure TAndroidModule1.jHorizontalScrollView1InnerItemClick(Sender: TObject;
  itemId: integer);
begin
  //note: jImageView1.ImageScaleType --> scaleCenterInside [object inspector]
  ShowMessage(IntToStr(itemId));
  case itemId of
     101: jImageView1.SetImageFromAssets('baloons.jpg');
     102: jImageView1.SetImageFromAssets('lightning.jpg');
     103: jImageView1.SetImageFromAssets('wall.jpg');
     104: jImageView1.SetImageFromAssets('veneza.jpg');
  end;
end;

end.
