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
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer; var rstRotate: integer);
      procedure jTimer1Timer(Sender: TObject);
    private
      {private declarations}
      cnt_Timer: integer;
      i: integer;
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
  Self.BackButton:= False;
  Self.BackgroundColor:= colbrWhite;
  //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
end;

procedure TAndroidModule1.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
   CanClose:= True;
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
  cnt_Timer:= 0;
  i:= 0;
  {if need set controls behavior/property jni dependent  here....}
  Self.Show;
  jTimer1.Enabled:= True;   //start Timer
end;

procedure TAndroidModule1.DataModuleRotate(Sender: TObject; rotate: integer;
var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule1.jTimer1Timer(Sender: TObject);
begin
 // jTextView1.Text:= IntToStr(Cnt_Timer) + '%';
  Inc(cnt_Timer, 5);

  Inc(i);
  if i = jImageView1.Count then i:= 1;
  jImageView1.ImageIndex:= i;

  if cnt_timer < 100 then Exit;
  jTimer1.Enabled:= False;   //Stop Timer
  if AndroidModule2 = nil then
  begin
    Close;
    AndroidModule2:= TAndroidModule2.Create(Self);
    AndroidModule2.Init(App);
  end else  AndroidModule2.Show;
end;

end.
