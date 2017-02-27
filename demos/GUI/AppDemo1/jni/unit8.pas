{Hint: save all files to location: \jni }
unit unit8;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule8 }

  TAndroidModule8 = class(jForm)
      jBitmap1: jBitmap;
      jButton1: jButton;
      jCanvas1: jCanvas;
      jImageList1: jImageList;
      jImageView1: jImageView;
      jTextView1: jTextView;
      jView1: jView;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jView1Draw(Sender: TObject);
      procedure jView1TouchMove(Sender: TObject; Touch: TMouch);
    private
     {private declarations}
      P: TPoint;
    public
      {public declarations}
  end;
  
var
  AndroidModule8: TAndroidModule8;

implementation
  
{$R *.lfm}
  

{ TAndroidModule8 }

procedure TAndroidModule8.jView1TouchMove(Sender: TObject; Touch: TMouch);
begin
   P:= Point(Round(Touch.Pt.X), Round(Touch.Pt.Y));
   jView1.Refresh;
end;

procedure TAndroidModule8.jButton1Click(Sender: TObject);
var
  filename : String;
begin
  filename := 'custom_view_test.png';
  jView1.SaveToFile(filename);
  showMessage('Save to '+fileName);
  jImageView1.SetImage(jView1.GetImage());
end;

procedure TAndroidModule8.jView1Draw(Sender: TObject);
var
  w1, h1: integer;
begin
  w1:= jView1.Width;
  h1:= jView1.Height;

  //Frame

 //jView1.Canvas.PaintStrokeWidth:= 5 ;
 //jView1.Canvas.PaintColor:= colbrMediumSpringGreen;

  jView1.Canvas.drawLine(0,0,0,h1-1);
  jView1.Canvas.drawLine(0,h1-1,w1-1,h1-1);
  jView1.Canvas.drawLine(w1-1,h1-1,w1-1,0);
  jView1.Canvas.drawLine(w1-1,0,0,0);

  //
  //jView1.Canvas.PaintStyle:= psFillAndStroke;
  jView1.Canvas.PaintColor:= colbrRed;
  //jView1.Canvas.PaintTextSize:= 20;
  //jView1.Canvas.drawText('Custom View Test: Drag the cube!', 10,30);

  jView1.Canvas.drawText('P(x,y)=(' + IntToStr(P.X) + ',' + IntToStr(P.Y)+')',10,h1-30);
  jView1.Canvas.drawBitmap(jBitmap1.GetImage, P.X-100,P.Y-100,P.X+100,P.Y+100);
end;

procedure TAndroidModule8.DataModuleJNIPrompt(Sender: TObject);
begin
  //
end;

procedure TAndroidModule8.DataModuleCreate(Sender: TObject);
begin
  P.X:= 135;
  P.Y:= 135;
end;

procedure TAndroidModule8.DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:= True;
end;

end.
