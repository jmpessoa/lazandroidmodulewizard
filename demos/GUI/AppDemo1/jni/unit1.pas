{Hint: save all files to location: C:\adt32\eclipse\workspace\AppDemo1\jni }
unit unit1;
  
{$mode delphi}

interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget, unit2;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jImageList1: jImageList;
      jImageView1: jImageView;
      jImageView2: jImageView;
      jTextView1: jTextView;
      jTimer1: jTimer;
      procedure AndroidModule1CloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleClose(Sender: TObject);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
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
end;

procedure TAndroidModule1.DataModuleClose(Sender: TObject);
begin
  jTimer1.Enabled:= False;
  gApp.CreateForm(TAndroidModule2, AndroidModule2);
  AndroidModule2.Init(gApp);
end;

procedure TAndroidModule1.AndroidModule1CloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  ShowMessage('form 1 can close....')
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
  jTimer1.Enabled:= True
end;

procedure TAndroidModule1.jTimer1Timer(Sender: TObject);
begin
  jTextView1.Text:= IntToStr(Cnt_Timer) + '%';
  Inc(cnt_Timer, 5);
  Inc(cnt_Image);
  if cnt_Image = jImageView1.Count-1 then cnt_Image:= 0;
  jImageView1.ImageIndex:= cnt_Image;
  if cnt_timer < 200 then Exit;
  jTimer1.Enabled:= False;   //Stop Timer
  Self.Close;
end;

end.
