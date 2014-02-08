{Hint: save all files to location: C:\adt32\eclipse\workspace\AppDemo1\jni }
unit unit1;
  
{$mode delphi}

interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, unit2;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jImageList1: jImageList;
      jImageView1: jImageView;
      jTextView1: jTextView;
      jTimer1: jTimer;
      procedure DataModuleActive(Sender: TObject);
      procedure DataModuleClose(Sender: TObject);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer; var rstRotate: integer);
      procedure jTimer1Timer(Sender: TObject);
    private
      {private declarations}
      cnt_Timer: integer;
      cnt_Image: integer;
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
  cnt_Timer:= 0;
  cnt_Image:= -1;

  //this initialization code is need here to fix Laz4Andoid  *.lfm parse.... why parse fails?
  Self.ActivityMode:= actSplash;

  Self.BackgroundColor:= colbrWhite;
  Self.OnJNIPrompt:= DataModuleJNIPrompt;   //mode delphi
  Self.OnRotate:= DataModuleRotate;
  Self.OnClose:= DataModuleClose;
  Self.OnActive:= DataModuleActive;
end;

procedure TAndroidModule1.DataModuleClose(Sender: TObject);
begin
  jTimer1.Enabled:= False;
  gApp.CreateForm(TAndroidModule2, AndroidModule2);
  AndroidModule2.Init(gApp);
end;

procedure TAndroidModule1.DataModuleActive(Sender: TObject);
begin
  //ShowMessage('form 1 active');
  jTimer1.Enabled:= True;   //start Timer
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
  Self.Show;
end;

procedure TAndroidModule1.DataModuleRotate(Sender: TObject; rotate: integer;
var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule1.jTimer1Timer(Sender: TObject);
begin
  //jTextView1.Text:= IntToStr(Cnt_Timer) + '%';
  Inc(cnt_Timer, 5);

  Inc(cnt_Image);
  if cnt_Image = jImageView1.Count then cnt_Image:= 0;
  jImageView1.ImageIndex:= cnt_Image;

  if cnt_timer < 200 then Exit;

  jTimer1.Enabled:= False;   //Stop Timer

  Self.Close;

end;

end.
