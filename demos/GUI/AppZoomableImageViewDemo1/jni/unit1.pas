{Hint: save all files to location: C:\android\workspace\AppZoomableImageViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, zoomableimageview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBitmap1: jBitmap;
    jButton1: jButton;
    jButton2: jButton;
    jTextView1: jTextView;
    jZoomableImageView1: jZoomableImageView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
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

// https://stackoverflow.com/questions/6650398/android-imageview-zoom-in-and-zoom-out
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   jZoomableImageView1.SetImage(jBitmap1.LoadFromAssets('bilbao.jpg'));
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
    jZoomableImageView1.MaxZoom:= jZoomableImageView1.MaxZoom + 1;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jZoomableImageView1.MaxZoom:= jZoomableImageView1.MaxZoom - 1;
   if jZoomableImageView1.MaxZoom <= 0  then jZoomableImageView1.MaxZoom:= 1;
end;

end.
