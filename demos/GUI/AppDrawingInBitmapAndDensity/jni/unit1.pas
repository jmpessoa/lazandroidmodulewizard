{Hint: save all files to location: C:\android\workspace\AppDrawingInBitmap\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, imagefilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    canvasXHigh: jCanvas;
    canvasMedium: jCanvas;
    canvasHigh: jCanvas;
    ivXHigh: jImageView;
    ivMedium: jImageView;
    ivHigh: jImageView;
    jButton1: jButton;
    canvasLow: jCanvas;
    imgFile: jImageFileManager;
    ivLow: jImageView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    jTextView5: jTextView;
    procedure AndroidModule1Init(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
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

//https://en.proft.me/2017/08/2/how-work-bitmap-android/
//http://www.java2s.com/Code/Android/2D-Graphics/DrawBitmaponCanvaswithMatrix.htm
//http://www.informit.com/articles/article.aspx?p=2143148&seqNum=2
//http://www.informit.com/articles/article.aspx?p=2423187&seqNum=2
procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  x,y: integer;
  w, h: integer;
begin

   //LOW DENSITY
   gapp.SetDensityAssets(daLOW);
   w:= 72;
   h:= 72;

   x:= Trunc(w/2);
   y:= Trunc(h/2);

   canvasLow.PaintTextSize := 24;

   canvasLow.PaintStrokeWidth := 3;

   canvasLow.SetBitmap( imgFile.LoadFromAssets('lemur.png') );

   canvasLow.PaintColor:= colbrRed;
   canvasLow.DrawTextMultiLine('Hello 2', 0, 0, 72, 72);
   canvasLow.PaintColor:= colbrYellow;
   canvasLow.DrawCircle(x,y,30);

   //show on screen
   ivLow.SetImage(canvasLow.GetBitmap());

   //MEDIUM DENSITY
   gapp.SetDensityAssets(daMedium);

   w:= 72;
   h:= 72;

   x:= Trunc(w/2);
   y:= Trunc(h/2);

   canvasMedium.PaintTextSize := 24;

   canvasMedium.PaintStrokeWidth := 3;

   canvasMedium.SetBitmap( imgFile.LoadFromAssets('lemur.png') );

   canvasMedium.PaintColor:= colbrRed;
   canvasMedium.DrawTextMultiLine('Hello 2', 0, 0, 72, 72);
   canvasMedium.PaintColor:= colbrYellow;
   canvasMedium.DrawCircle(x,y,30);

   //show on screen
   ivMedium.SetImage(canvasMedium.GetBitmap());

   //HIGH DENSITY
   gapp.SetDensityAssets(daHIGH);

   w:= 72;
   h:= 72;

   x:= Trunc(w/2);
   y:= Trunc(h/2);

   canvasHIGH.PaintTextSize := 24;

   canvasHIGH.PaintStrokeWidth := 3;

   canvasHIGH.SetBitmap( imgFile.LoadFromAssets('lemur.png') );

   canvasHIGH.PaintColor:= colbrRed;
   canvasHIGH.DrawTextMultiLine('Hello 2', 0, 0, 72, 72);
   canvasHIGH.PaintColor:= colbrYellow;
   canvasHIGH.DrawCircle(x,y,30);

   //show on screen
   ivHigh.SetImage(canvasHIGH.GetBitmap());

   //XHIGH DENSITY
   gapp.SetDensityAssets(daXHIGH);

   w:= 72;
   h:= 72;

   x:= Trunc(w/2);
   y:= Trunc(h/2);

   canvasXHIGH.PaintTextSize := 24;

   canvasXHIGH.PaintStrokeWidth := 3;

   canvasXHIGH.SetBitmap( imgFile.LoadFromAssets('lemur.png') );

   canvasXHIGH.PaintColor:= colbrRed;
   canvasXHIGH.DrawTextMultiLine('Hello 2', 0, 0, 72, 72);
   canvasXHIGH.PaintColor:= colbrYellow;
   canvasXHIGH.DrawCircle(x,y,30);

   //show on screen
   ivXHigh.SetImage(canvasXHIGH.GetBitmap());
end;

procedure TAndroidModule1.AndroidModule1Init(Sender: TObject);
begin
  //Set the density of all Assets before they are initialized
  //in this way they will be displayed equally independently of the screen density
  gapp.SetDensityAssets(daLOW);
end;

end.
