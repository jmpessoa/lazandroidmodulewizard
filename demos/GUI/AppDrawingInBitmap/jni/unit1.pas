{Hint: save all files to location: C:\android\workspace\AppDrawingInBitmap\jni }
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
    jButton1: jButton;
    jCanvas1: jCanvas;
    jImageView1: jImageView;
    jTextView1: jTextView;
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

   //Initialize canvas..
   w:= jImageView1.Width;
   h:=  jImageView1.Height;
   jCanvas1.CreateBitmap(w,h,colbrLinen);   //or some "generic" w, h ....
   //or
   //jCanvas.SetBitmap(....);


   x:= Trunc(jImageView1.Width/2);
   y:= Trunc(jImageView1.Height/2);

   //draw off screen
   jCanvas1.DrawBitmap(x,y, jBitmap1.GetImage());
   jCanvas1.DrawText('Hello',x,y);
   jCanvas1.DrawCircle(x,y,100);

   //show on screen
   jImageView1.SetImage(jCanvas1.GetBitmap());
end;

end.
