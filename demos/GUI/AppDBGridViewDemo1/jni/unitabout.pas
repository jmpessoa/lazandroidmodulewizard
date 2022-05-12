{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppDBGridViewDemo1\jni }
unit unitAbout;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, unitMain;
  
type

  { TAndroidModuleAbout }

  TAndroidModuleAbout = class(jForm)
    jButton1: jButton;
    jImageList1: jImageList;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    jTimer1: jTimer;
    procedure jButton1Click(Sender: TObject);
    procedure jTimer1Timer(Sender: TObject);
    procedure Mod_AboutClose(Sender: TObject);
    procedure Mod_AboutCreate(Sender: TObject);
    procedure Mod_AboutJNIPrompt(Sender: TObject);
  private
    {private declarations}
      cnt_Timer: integer;
  public
    {public declarations}
  end;


var
  AndroidModuleAbout: TAndroidModuleAbout;

implementation

  
{$R *.lfm}
  
procedure TAndroidModuleAbout.Mod_AboutJNIPrompt(Sender: TObject);
begin
  jTimer1.Enabled:=True;
end;

procedure TAndroidModuleAbout.jTimer1Timer(Sender: TObject);
begin
  Inc(cnt_Timer, 5);
  if cnt_timer < 200 then Exit;
  jTimer1.Enabled:= False;   //Stop Timer
  Self.Close;
end;

procedure TAndroidModuleAbout.jButton1Click(Sender: TObject);
begin
  cnt_Timer:= 200;
end;

procedure TAndroidModuleAbout.Mod_AboutClose(Sender: TObject);
begin
  gApp.CreateForm(TAndroidModuleMain, AndroidModuleMain);
  AndroidModuleMain.InitShowing; //fire OnJNIPrompt
end;

procedure TAndroidModuleAbout.Mod_AboutCreate(Sender: TObject);
begin
  cnt_Timer:= 0;
end;

end.
