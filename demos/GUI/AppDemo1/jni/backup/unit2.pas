{Hint: save all files to location: \jni }
unit unit2;
  
{$mode delphi}

interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, unit3, unit4, unit5,
  unit6, unit7, unit8, unit9, unit10, unit11, unit12, unit13, unit14;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
      jButton1: jButton;
      jButton10: jButton;
      jButton11: jButton;
      jButton12: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jButton5: jButton;
      jButton6: jButton;
      jButton7: jButton;
      jButton8: jButton;
      jButton9: jButton;
      jImageList1: jImageList;
      jImageView1: jImageView;
      jTextView1: jTextView;
      jTextView2: jTextView;

      procedure AndroidModule2ActivityCreate(Sender: TObject;
        intentData: jObject);
      procedure AndroidModule2BackButton(Sender: TObject);
      procedure AndroidModule2Close(Sender: TObject);
      procedure AndroidModule2CloseQuery(Sender: TObject; var CanClose: boolean);
      procedure AndroidModule2Create(Sender: TObject);
      procedure AndroidModule2Init(Sender: TObject);

      procedure jButton10Click(Sender: TObject);
      procedure jButton11Click(Sender: TObject);
      procedure jButton12Click(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
      procedure jButton5Click(Sender: TObject);
      procedure jButton6Click(Sender: TObject);
      procedure jButton7Click(Sender: TObject);
      procedure jButton8Click(Sender: TObject);
      procedure jButton9Click(Sender: TObject);

    private
      {private declarations}
    public
      {public declarations}
  end;
  
var
  AndroidModule2: TAndroidModule2;

implementation

{$R *.lfm}
  
{ TAndroidModule2 }

procedure TAndroidModule2.AndroidModule2BackButton(Sender: TObject);
begin
  ShowMessage('back pressed!');
end;

procedure TAndroidModule2.AndroidModule2ActivityCreate(Sender: TObject;
  intentData: jObject);
begin
  AndroidModule3.Init;
  AndroidModule4.Init;
  AndroidModule5.Init;
  AndroidModule6.Init;
  AndroidModule7.Init;
  AndroidModule8.Init;
  AndroidModule9.Init;
  AndroidModule10.Init;
  AndroidModule11.Init;
  AndroidModule12.Init;
  AndroidModule13.Init;
  AndroidModule14.Init;
end;

procedure TAndroidModule2.AndroidModule2Close(Sender: TObject);
begin
   ShowMessage('Close....');
end;

procedure TAndroidModule2.AndroidModule2CloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  CanClose:= True;
  ShowMessage('try close form 2...');

end;

procedure TAndroidModule2.AndroidModule2Create(Sender: TObject);
begin
  //
end;

procedure TAndroidModule2.AndroidModule2Init(Sender: TObject);
begin

end;

procedure TAndroidModule2.jButton1Click(Sender: TObject);  //DEMO: Base Controls
begin
  AndroidModule3.Show; //actRecyclable
end;

procedure TAndroidModule2.jButton2Click(Sender: TObject); //Demo: Memo and ScrollView
begin
  AndroidModule4.Show;   //actRecyclable
end;

procedure TAndroidModule2.jButton3Click(Sender: TObject); //Demo: jWebView1
begin
  AndroidModule5.Show; //actRecyclable
end;

procedure TAndroidModule2.jButton4Click(Sender: TObject);  //Demo: List View
begin
  AndroidModule6.Show;  //actRecyclable
end;

procedure TAndroidModule2.jButton5Click(Sender: TObject);
begin
  AndroidModule7.Show; //DEMO: jImageView , jScrollView , jImageBtn1
end;

procedure TAndroidModule2.jButton6Click(Sender: TObject);
begin
  AndroidModule8.Show; //DEMO: jView1, jCanvas, jBitmap1
end;

procedure TAndroidModule2.jButton7Click(Sender: TObject);
begin
  AndroidModule9.Show; //DEMO: jBitmap1  - pixels access...
end;

procedure TAndroidModule2.jButton8Click(Sender: TObject);  //gl_1 2D
begin
  AndroidModule10.Show;
end;

procedure TAndroidModule2.jButton9Click(Sender: TObject); //gl_2 2D
begin
  AndroidModule11.Show;
end;

procedure TAndroidModule2.jButton10Click(Sender: TObject);  //gl_1 3D
begin
  AndroidModule12.Show;
end;

procedure TAndroidModule2.jButton11Click(Sender: TObject); //gl_2 3D
begin
  AndroidModule13.Show;
end;

procedure TAndroidModule2.jButton12Click(Sender: TObject);
begin
  AndroidModule14.Show; //jAsyncTask1 / jHttpClient1
end;

end.
