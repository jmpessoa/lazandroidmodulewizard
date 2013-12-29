{Hint: save all files to location: \jni }
unit unit8;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;
  
type

  { TAndroidModule8 }

  TAndroidModule8 = class(jForm)
      jBitmap1: jBitmap;
      jButton1: jButton;
      jImageList1: jImageList;
      jTextView1: jTextView;
      jView1: jView;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer;
        var rstRotate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jView1Draw(Sender: TObject; Canvas: jCanvas);
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

procedure TAndroidModule8.jView1Draw(Sender: TObject; Canvas: jCanvas);
var
  w1, h1: integer;
begin
  w1:= jView1.Width;
  h1:= jView1.Height;
  {
  jView1.Canvas.setStyle(cjPaint_Style_Stroke);
  jView1.Canvas.setStrokeWidth(5);
  jView1.Canvas.setColor(colbrLime); // ARGB
  jView1.Canvas.drawLine(0,0,w1,h1);
  }
  //Frame
  jView1.Canvas.setStrokeWidth(5);
  jView1.Canvas.setColor(colbrMediumSpringGreen); // ARGB
  jView1.Canvas.drawLine(0,0,0,h1);
  jView1.Canvas.drawLine(0,h1,w1,h1);
  jView1.Canvas.drawLine(w1,h1,w1,0);
  jView1.Canvas.drawLine(w1,0,0,0);
  //
  jView1.Canvas.setStyle(cjPaint_Style_Fill);
  jView1.Canvas.setColor(colbrRed); //
  jView1.Canvas.setTextSize(20);
  //jView1.Canvas.drawText('Custom View Test: Drag the cube!', 10,30);
  jView1.Canvas.drawText('P(x,y)=(' + IntToStr(P.X) + ',' + IntToStr(P.Y)+')',10,h1-30);
  jView1.Canvas.drawBitmap(jBitmap1, P.X-100,P.Y-100,P.X+100,P.Y+100);
end;

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
end;

procedure TAndroidModule8.DataModuleJNIPrompt(Sender: TObject);
begin
  P.X:= 135;
  P.Y:= 135;
  Self.Show;
end;

procedure TAndroidModule8.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule8.DataModuleCreate(Sender: TObject);
begin
  Self.BackButton:= True;
  Self.BackgroundColor:= colbrBlack;
  //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
end;

procedure TAndroidModule8.DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:= True;
end;

end.
