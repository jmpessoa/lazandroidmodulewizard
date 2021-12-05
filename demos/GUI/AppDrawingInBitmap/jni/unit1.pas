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
    jEditText1: jEditText;
    jScrollView1: jScrollView;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
  private
    {private declarations}
    FCount: integer;
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
  x, y: integer;
  w, h: integer;
  textTag: string;
  textContent: string;
begin

   //Initialize canvas..
   w:= jScrollView1.Width; //jImageView1.Width;
   h:= 300; //variable

   jCanvas1.CreateBitmap(w , h, colbrLinen);
   //or
   //jCanvas.SetBitmap(....);

   jCanvas1.PaintTextSize:= 14;   //need here!


   //draw off screen
   x:= Trunc(w/2);
   y:= Trunc(h/2);

   Inc(FCount);

   jCanvas1.DrawBitmap(30 + 30*FCount, 30, jBitmap1.GetImage()); //only demo... "smiley64" .... put your perfect image in folder ' "...../res/drawable"


   textTag:= ' All theory is gray... But forever green is the tree of life. ';

   textContent:= jEditText1.Text;

   //jCanvas1.DrawText(textContent + ' (' + IntToStr(FCount) + ')', x, y);
   jCanvas1.DrawTextMultiLine( '(' + IntToStr(FCount) + ')' +  textTag + ' :: ' + textContent,
                                   50, y,                             //p1 = (left,  top)
                                   jScrollView1.Width-50, y+100       //p2 = (right, bottom)
                                   );

   jCanvas1.DrawCircle(30, y, 20 + 10*FCount);   //only demo...

   //show on screen
   jScrollView1.AddImage(jCanvas1.GetBitmap());  //need set jScrollView property "InnerLayout = ilLinear"
end;

end.
