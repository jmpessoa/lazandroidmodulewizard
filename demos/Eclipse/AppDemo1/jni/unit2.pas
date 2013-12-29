{Hint: save all files to location: \jni }
unit unit2;
  
{$mode delphi}

interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  unit3, unit4, unit5, unit6, unit7, unit8, unit9, unit10,
  unit11, unit12, unit13, unit14;
  
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
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer;
        var rstRotate: integer);
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

procedure TAndroidModule2.DataModuleCreate(Sender: TObject);
begin       //this initialization code are needed here to fix *.lfm parse.... why parse fail?
  Self.BackButton:= False;
  Self.BackgroundColor:= colbrBlack;
  //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
end;

procedure TAndroidModule2.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  CanClose := True;
end;

procedure TAndroidModule2.DataModuleJNIPrompt(Sender: TObject);
begin
  { Self.Animation:= getAnimation(cjEft_FadeIn  or cjEft_iR2L,
                                 cjEft_FadeOut or cjEft_oL2R); }
   Self.Show;
end;

procedure TAndroidModule2.DataModuleRotate(Sender: TObject; rotate: integer; var rstRotate: integer);
begin
   Self.UpdateLayout;
end;


procedure TAndroidModule2.jButton1Click(Sender: TObject);
begin
  if AndroidModule3 = nil then
  begin
    AndroidModule3:= TAndroidModule3.Create(Self);
    AndroidModule3.Init(App);
  end else AndroidModule3.Show;
end;

procedure TAndroidModule2.jButton2Click(Sender: TObject);
begin
  if AndroidModule4 = nil then
  begin
    AndroidModule4:= TAndroidModule4.Create(Self);
    AndroidModule4.Init(App);
  end  else AndroidModule4.Show;
end;

procedure TAndroidModule2.jButton3Click(Sender: TObject);
begin
  if AndroidModule5 = nil then
  begin
    AndroidModule5:= TAndroidModule5.Create(Self);
    AndroidModule5.Init(App);
  end  else AndroidModule5.Show;
end;

procedure TAndroidModule2.jButton4Click(Sender: TObject);
begin
  if AndroidModule6 = nil then
  begin
    AndroidModule6:= TAndroidModule6.Create(Self);
    AndroidModule6.Init(App);
  end  else AndroidModule6.Show;
end;

procedure TAndroidModule2.jButton5Click(Sender: TObject);
begin
  if AndroidModule7 = nil then
  begin
    AndroidModule7:= TAndroidModule7.Create(Self);
    AndroidModule7.Init(App);
  end  else AndroidModule7.Show;
end;

procedure TAndroidModule2.jButton6Click(Sender: TObject);
begin
  if AndroidModule8 = nil then
  begin
    AndroidModule8:= TAndroidModule8.Create(Self);
    AndroidModule8.Init(App);
  end  else AndroidModule8.Show;
end;

procedure TAndroidModule2.jButton7Click(Sender: TObject);
begin
  if AndroidModule9 = nil then
  begin
    AndroidModule9:= TAndroidModule9.Create(Self);
    AndroidModule9.Init(App);
  end else AndroidModule9.Show;
end;

procedure TAndroidModule2.jButton8Click(Sender: TObject);  //gl_1 2D
begin
  if AndroidModule10 = nil then
  begin
    AndroidModule10:= TAndroidModule10.Create(Self);
    AndroidModule10.Init(App);
  end else AndroidModule10.Show;
end;

procedure TAndroidModule2.jButton9Click(Sender: TObject); //gl_2 2D
begin
  if AndroidModule11 = nil then
  begin
    AndroidModule11:= TAndroidModule11.Create(Self);
    AndroidModule11.Init(App);
  end else AndroidModule11.Show;
end;

procedure TAndroidModule2.jButton10Click(Sender: TObject);  //gl_1 3D
begin
  if AndroidModule12 = nil then
  begin
    AndroidModule12:= TAndroidModule12.Create(Self);
    AndroidModule12.Init(App);
  end else AndroidModule12.Show;
end;

procedure TAndroidModule2.jButton11Click(Sender: TObject); //gl_2 3D
begin
  if AndroidModule13 = nil then
  begin
    AndroidModule13:= TAndroidModule13.Create(Self);
    AndroidModule13.Init(App);
  end else AndroidModule13.Show;
end;

procedure TAndroidModule2.jButton12Click(Sender: TObject);
begin
  if AndroidModule14 = nil then
  begin
    AndroidModule14:= TAndroidModule14.Create(Self);
    AndroidModule14.Init(App);
  end else AndroidModule14.Show;
end;

end.
