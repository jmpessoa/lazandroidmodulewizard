{Hint: save all files to location: \jni }
unit main;

{$mode delphi}

interface

uses
  Classes, SysUtils, Laz_And_Controls, AndroidWidget;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jImageList1: jImageList;
    jImageView1: jImageView;
    jImageView2: jImageView;
    jImageView3: jImageView;
    jImageView4: jImageView;
    jImageView5: jImageView;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTimer1: jTimer;
    procedure AndroidModule1Close(Sender: TObject);
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1Rotate(Sender: TObject; {%H-}rotate: integer;
      var {%H-}rstRotate: integer);
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

uses
  unit1;

{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1Close(Sender: TObject);
begin
  jTimer1.Enabled:= False;
  if AndroidModule2 = nil then
  begin
    gApp.CreateForm(TAndroidModule2, AndroidModule2);
    AndroidModule2.Init(gApp);
  end
  else
  begin
    AndroidModule2.Show;
  end;
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
  cnt_Timer:= 0;
  cnt_Image:= -1;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jTimer1.Enabled:= True;
end;

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject;
  rotate: integer; var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule1.jTimer1Timer(Sender: TObject);
begin
  Inc(cnt_Timer, 5);
  Inc(cnt_Image);
  if cnt_Image = 8 then cnt_Image:= 0;
  jImageView1.ImageIndex:= cnt_Image;
  //jImageView4.MarginTop:=jImageView4.MarginTop+5;
  if cnt_timer < 300 then Exit;
  jTimer1.Enabled:= False;   //Stop Timer
  Self.Close;
end;

end.
