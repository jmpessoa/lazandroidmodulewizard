{Hint: save all files to location: C:\adt32\eclipse\workspace\AppChronometerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, chronometer;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jChronometer1: jChronometer;
    jTextView1: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   jChronometer1.Start();
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   ShowMessage( IntToStr(jChronometer1.Stop()) + ' Millis');
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
     ShowMessage( IntToStr(jChronometer1.Reset()) + ' Millis');
end;

end.
