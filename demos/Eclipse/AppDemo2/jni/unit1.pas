{Hint: save all files to location: C:\adt32\eclipse\workspace\AppDemo2\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jBitmap1: jBitmap;
      jButton1: jButton;
      jCamera1: jCamera;
      jCanvas1: jCanvas;
      jImageView1: jImageView;
      jPanel1: jPanel;
      jPanel2: jPanel;
      jPanel3: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      jTextView4: jTextView;
      jTextView5: jTextView;
      jTextView6: jTextView;
      jView1: jView;
      procedure DataModuleActive(Sender: TObject);
      procedure DataModuleActivityRst(Sender: TObject; requestCode,
        resultCode: Integer; jData: jObject);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer;
        var rstRotate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jView1Draw(Sender: TObject; Canvas: jCanvas);
    private
      {private declarations}
      FPhotoExist: boolean;
      FSaveRotate: integer;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.DataModuleCreate(Sender: TObject);
begin
  FPhotoExist:= False;
  FSaveRotate:= 1;  //default: Vertical

  //just to fix *.lfm parse fail. Why fail ?
  OnJNIPrompt:= DataModuleJNIPrompt;     {<-- delphi mode: do not use '@' !}
  OnRotate:= DataModuleRotate;
  OnActivityRst:= DataModuleActivityRst;
  OnActive:= DataModuleActive;
end;

procedure TAndroidModule1.DataModuleActivityRst(Sender: TObject; requestCode, resultCode: Integer; jData: jObject);
begin
   if  resultCode = 0 then ShowMessage('Photo Canceled!')
   else if resultCode = -1 then //ok...
        begin
           FPhotoExist:= True;
           jView1.Refresh;
           jImageView1.Refresh;
        end
        else ShowMessage('Photo Fail!');
end;

procedure TAndroidModule1.DataModuleActive(Sender: TObject);
begin
   if Self.Orientation = 2 then   // device is on horizontal...
   begin               //reconfigure....
      FSaveRotate:= 2;
      jPanel1.LayoutParamHeight:=lpMatchParent;
      jPanel1.LayoutParamWidth:= lpOneThirdOfParent;

      jPanel2.LayoutParamHeight:= lpMatchParent;
      jPanel2.LayoutParamWidth:= lpOneThirdOfParent;
      jPanel2.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];

      jPanel3.LayoutParamHeight:= lpMatchParent;
      jPanel3.LayoutParamWidth:= lpMatchParent;
      jPanel3.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];;
      Self.UpdateLayout;
    end
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
  jTextView3.Text:= jCamera1.Filename;
  jTextView5.Text:= jCamera1.Filename;
  Self.Show;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jCamera1.TakePhoto;
end;

procedure TAndroidModule1.jView1Draw(Sender: TObject; Canvas: jCanvas);
var
  ratio: integer;
begin
    if FPhotoExist then
    begin
       //jTextView3.Text:= jCamera1.FullPathToBitmapFile;
       jBitmap1.LoadFromFile(jCamera1.FullPathToBitmapFile);
       if FSaveRotate = 2 then
       begin
          Ratio:= Round(jBitmap1.Width/jBitmap1.Height);
          jView1.Canvas.drawBitmap(jBitmap1, 0, 0,
                                             jView1.Width,
                                             Round((jView1.Width)*(1/Ratio)));

       end
       else
       begin
         Ratio:= Round(jBitmap1.Height/jBitmap1.Width);
         jView1.Canvas.drawBitmap(jBitmap1, 0, 0,
                                            jView1.Height,
                                            Round((jView1.Height)*(1/Ratio)));
       end;

       { //or you can do simply this...  NO RATIO!
       jView1.Canvas.drawBitmap(jBitmap1, 0, 0,
                                jView1.Width,
                                jView1.Height);
       }

       //just to ilustration.... you can draw or write over draw....
       jView1.Canvas.PaintColor:= colbrRed;

       jView1.Canvas.drawLine(0, 0, jView1.Width, jView1.Height);

       jView1.Canvas.drawText('Hello People!', 30,30);

       //or simply show on other control: jImageView1
       jImageView1.SetImageBitmap(jBitmap1.GetJavaBitmap);
    end;
end;

{rotate=1 --> device is on  vertical/default position; rotate=2 device is on horizontal position}
procedure TAndroidModule1.DataModuleRotate(Sender: TObject; rotate: integer; var rstRotate: integer);
begin
   FSaveRotate:=  rotate;
   if rotate = 2 then   //after rotation device is on horizontal
   begin
      jPanel1.LayoutParamHeight:=lpMatchParent;
      jPanel1.LayoutParamWidth:= lpOneThirdOfParent;

      jPanel2.LayoutParamHeight:= lpMatchParent;
      jPanel2.LayoutParamWidth:= lpOneThirdOfParent;
      jPanel2.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];

      jPanel3.LayoutParamHeight:= lpMatchParent;
      jPanel3.LayoutParamWidth:= lpMatchParent;
      jPanel3.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];;
    end
    else {1} //after rotation device is on vertical :: default
    begin
      jPanel1.LayoutParamHeight:= lpOneFifthOfParent;
      jPanel1.LayoutParamWidth:= lpMatchParent;

      jPanel2.LayoutParamHeight:= lpOneThirdOfParent;
      jPanel2.LayoutParamWidth:= lpMatchParent;
      jPanel2.PosRelativeToAnchor:= [raBelow];

      jPanel3.LayoutParamHeight:= lpMatchParent;
      jPanel3.PosRelativeToAnchor:= [raBelow];
    end;
    Self.UpdateLayout;
end;

end.
