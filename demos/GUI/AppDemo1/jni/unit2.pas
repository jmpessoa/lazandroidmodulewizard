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
  gApp.CreateForm(TAndroidModule3, AndroidModule3);
  AndroidModule3.Init(gApp);  //fire OnJNIPrompt but dont Show the form ...

  gApp.CreateForm(TAndroidModule4, AndroidModule4);
  AndroidModule4.Init(gApp);

  gApp.CreateForm(TAndroidModule5, AndroidModule5);
  AndroidModule5.Init(gApp);

  gApp.CreateForm(TAndroidModule6, AndroidModule6);
  AndroidModule6.Init(gApp);

  gApp.CreateForm(TAndroidModule7, AndroidModule7);
  AndroidModule7.Init(gApp);

  gApp.CreateForm(TAndroidModule8, AndroidModule8);
  AndroidModule8.Init(gApp);

  gApp.CreateForm(TAndroidModule9, AndroidModule9);
  AndroidModule9.Init(gApp);

  gApp.CreateForm(TAndroidModule10, AndroidModule10);
  AndroidModule10.Init(gApp);

  gApp.CreateForm(TAndroidModule11, AndroidModule11);
  AndroidModule11.Init(gApp);

  gApp.CreateForm(TAndroidModule12, AndroidModule12);
  AndroidModule12.Init(gApp);

  gApp.CreateForm(TAndroidModule13, AndroidModule13);
  AndroidModule13.Init(gApp);

  gApp.CreateForm(TAndroidModule14, AndroidModule14);
  AndroidModule14.Init(gApp);
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
  AndroidModule2.Show(gApp); //special Show need to re-init OpenGL engine  ... //combo: ReInit(gApp) + Show(False)
  //or
  //ReInitShowing(gApp);  //call OnJNIPrompt
end;

procedure TAndroidModule2.jButton9Click(Sender: TObject); //gl_2 2D
begin
  AndroidModule2.Show(gApp); //special Show need to re-init OpenGL engine  ... //combo: ReInit(gApp) + Show(False)
  //or
  //ReInitShowing(gApp);  //call OnJNIPrompt  
end;

procedure TAndroidModule2.jButton10Click(Sender: TObject);  //gl_1 3D
begin
  AndroidModule2.Show(gApp); //special Show need to re-init OpenGL engine  ... //combo: ReInit(gApp) + Show(False)
  //or
  //ReInitShowing(gApp);  //call OnJNIPrompt  
end;

procedure TAndroidModule2.jButton11Click(Sender: TObject); //gl_2 3D
begin
  AndroidModule2.Show(gApp); //special Show need to re-init OpenGL engine  ... //combo: ReInit(gApp) + Show(False)
  //or
  //ReInitShowing(gApp);  //call OnJNIPrompt  
end;

procedure TAndroidModule2.jButton12Click(Sender: TObject);
begin
  AndroidModule14.Show; //jAsyncTask1 / jHttpClient1
end;

end.
