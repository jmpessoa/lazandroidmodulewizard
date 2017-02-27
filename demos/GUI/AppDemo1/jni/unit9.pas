{Hint: save all files to location: \jni }
unit unit9;
  
{$mode delphi}
  
interface
  
uses
  Classes,  SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, And_bitmap_h, Laz_And_Controls_Events, AndroidWidget, FPimage;
  
type

  { TAndroidModule9 }

  TAndroidModule9 = class(jForm)
      jBitmap1: jBitmap;
      jButton1: jButton;
      jCanvas1: jCanvas;
      jImageList1: jImageList;
      jTextView1: jTextView;
      jView1: jView;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer; var rstRotate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jView1Draw(Sender: TObject);
      procedure jView1TouchMove(Sender: TObject; Touch: TMouch);
    private
      {private declarations}

    public
      {public declarations}
      P: TPoint;
      Ratio : Single;
      SwapCanMode: integer;
  end;
  
var
  AndroidModule9: TAndroidModule9;
  FImgMem: TFPMemoryImage;

implementation
  
{$R *.lfm}

{ TAndroidModule9 }

procedure TAndroidModule9.jView1TouchMove(Sender: TObject; Touch: TMouch);
begin
   P:= Point( Round(Touch.Pt.X), Round(Touch.Pt.Y) );
   jView1.refresh;
end;


procedure TAndroidModule9.DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:= True;
end;

procedure TAndroidModule9.DataModuleCreate(Sender: TObject);
begin
  P.X:= 30;
  P.Y:= 30;
  SwapCanMode:= 0;
end;

procedure TAndroidModule9.DataModuleJNIPrompt(Sender: TObject);
begin
  Ratio:= jBitmap1.GetRatio;
end;

procedure TAndroidModule9.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule9.jButton1Click(Sender: TObject);
var
   byteBuffer: TArrayOfByte;
   size: integer;
   PBytePixel: PScanByte;
   PDWordPixel: PScanLine;
begin

  size:= jBitmap1.GetByteArrayFromBitmap({var}byteBuffer);  //just test!
  jBitmap1.SetByteArrayToBitmap(byteBuffer, size);          //just test!
  Setlength(byteBuffer, 0); //free byte buffer              //just test!

  if SwapCanMode = 0 then
  begin
    jBitmap1.ScanPixel(PDWordPixel);
    SwapCanMode:= 1;
  end
  else
  begin
    jBitmap1.ScanPixel(PBytePixel, 4);
    SwapCanMode:= 0;
  end;

  jView1.Refresh;

end;

procedure TAndroidModule9.jView1Draw(Sender: TObject);
begin
       //jView1.Canvas.PaintColor:= colbrGreen;
     //jView1.Canvas.PaintStyle:= psFillAndStroke;
     //jView1.Canvas.PaintTextSize:= 20;
     //jView1.Canvas.drawBitmap(jBitmap1,10,10, jView1.Width-20,Round( (jView1.Width-20)*(1/Ratio) ) );
     //jView1.Canvas.drawBitmap(jBitmap1,10,10, jView1.Width, Ratio);

     jView1.Canvas.drawBitmap(jBitmap1.GetImage,jView1.Width, jView1.Height);

     jView1.Canvas.drawText('P(x,y)= (' + IntToStr(P.X) + ',' + IntToStr(P.Y)+')',60,60);

end;

end.
