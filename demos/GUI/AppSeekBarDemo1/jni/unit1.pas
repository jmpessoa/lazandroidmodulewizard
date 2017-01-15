{Hint: save all files to location: C:\adt32\eclipse\workspace\AppSeekBarDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, seekbar;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jSeekBar1: jSeekBar;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jSeekBar1ProgressChanged(Sender: TObject; progress: integer;
      fromUser: boolean);
    procedure jSeekBar1StartTrackingTouch(Sender: TObject; progress: integer);
    procedure jSeekBar1StopTrackingTouch(Sender: TObject; progress: integer);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

uses Unit2, Unit3, Unit5;

{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jSeekBar1StartTrackingTouch(Sender: TObject; progress: integer);
begin
  ShowMessage('StartTrackingTouch = '+ IntToStr(progress));
end;

procedure TAndroidModule1.jSeekBar1ProgressChanged(Sender: TObject;
  progress: integer; fromUser: boolean);
begin
  //
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
    if AndroidModule2 = nil then begin
     gApp.CreateForm(TAndroidModule2, AndroidModule2);
     AndroidModule2.Init(gApp);
   end
   else
   begin
     AndroidModule2.Show;
   end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if AndroidModule3 = nil then begin
     gApp.CreateForm(TAndroidModule3, AndroidModule3);
     AndroidModule3.Init(gApp);
  end
  else
  begin
     AndroidModule3.Show;
  end;
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
   if AndroidModule5 = nil then begin
     gApp.CreateForm(TAndroidModule5, AndroidModule5);
     AndroidModule5.Init(gApp);
   end
   else
   begin
     AndroidModule5.Show;
   end;
end;

procedure TAndroidModule1.jSeekBar1StopTrackingTouch(Sender: TObject; progress: integer);
begin
   ShowMessage('StopTrackingTouch = '+ IntToStr(progress));
end;

end.
