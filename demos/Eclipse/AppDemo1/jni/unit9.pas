{Hint: save all files to location: \jni }
unit unit9;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, And_bitmap_h;
  
type

  { TAndroidModule9 }

  TAndroidModule9 = class(jForm)
      jBitmap1: jBitmap;
      jImageList1: jImageList;
      jTextView1: jTextView;
      jView1: jView;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer;
        var rstRotate: integer);
      procedure jView1Draw(Sender: TObject; Canvas: jCanvas);
      procedure jView1TouchMove(Sender: TObject; Touch: TMouch);
    private
      {private declarations}
    public
      {public declarations}
      P: TPoint;
      function CalcBitmapRatio : Single;
  end;
  
var
  AndroidModule9: TAndroidModule9;
  PPixel : PScanLine;
  //PPixelBuffer: PJByte;

implementation
  
{$R *.lfm}

{ TAndroidModule9 }

procedure TAndroidModule9.jView1TouchMove(Sender: TObject; Touch: TMouch);
begin
   P := Point( Round(Touch.Pt.X), Round(Touch.Pt.Y) );
   jView1.refresh;
end;

procedure TAndroidModule9.jView1Draw(Sender: TObject; Canvas: jCanvas);
var
  Ratio : Single;
begin
  jView1.Canvas.setColor(colbrGreen);
  jView1.Canvas.setStyle(cjPaint_Style_Fill);
  jView1.Canvas.setTextSize(20);
  jView1.Canvas.drawText('P(x,y)= (' + IntToStr(P.X) + ',' + IntToStr(P.Y)+')',10,60);
  Ratio := CalcBitmapRatio;
  jView1.Canvas.drawBitmap(jBitmap1,10,10, jView1.Width-20,Round( (jView1.Width-20)*(1/Ratio) ) );
end;

procedure TAndroidModule9.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  CanClose:= True;
end;

procedure TAndroidModule9.DataModuleCreate(Sender: TObject);
begin
  Self.BackButton:= True;
  Self.BackgroundColor:= colbrBlack;
   //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
end;

procedure TAndroidModule9.DataModuleJNIPrompt(Sender: TObject);
begin
  Self.Show;
end;

procedure TAndroidModule9.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

function TAndroidModule9.CalcBitmapRatio : Single;
var
  k    : integer;
  row, col: integer;
  PPixel : PScanLine;
  PJavaPixel: PScanByte; {need by delphi mode!} //PJByte;
begin
  Result:= 1;  //dummy
  if jBitmap1.GetInfo then
  begin

     //demo API LockPixels... parameter is PScanLine
    jBitmap1.LockPixels(PPixel); //ok
    for k := 0 to jBitmap1.Width*jBitmap1.Height-1 do  PPixel^[k]:= not PPixel^[k];  //ok
    jBitmap1.UnlockPixels;

     //demo API LockPixels - overloaded - paramenter is PJavaPixel
    jBitmap1.LockPixels(PJavaPixel); //ok
    k:= 0;
    for row:= 0 to jBitmap1.Height-1 do  //ok
    begin
      for col:= 0 to jBitmap1.Width-1 do //ok
      begin
          PJavaPixel^[k*4]:=    not PJavaPixel^[k*4]; //delphi mode....
          PJavaPixel^[k*4+1]:=   PJavaPixel^[k*4+1];
          PJavaPixel^[k*4+2]:=  not PJavaPixel^[k*4+2];
          PJavaPixel^[k*4+3]:=  not PJavaPixel^[k*4+3];
          inc(k);
      end;
    end;
    jBitmap1.UnlockPixels;

    Result:= Round(jBitmap1.Width/jBitmap1.Height);
  end;
end;

end.
