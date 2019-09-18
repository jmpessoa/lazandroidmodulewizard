{Hint: save all files to location: C:\Temp\AppBrightness\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, seekbar, And_jni,
  brightness;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    bright: jBrightness;
    jCheckBox1: jCheckBox;
    jSeekBar1: jSeekBar;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTimer1: jTimer;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject
      );
    procedure jCheckBox1Click(Sender: TObject);
    procedure jSeekBar1ProgressChanged(Sender: TObject; progress: integer;
      fromUser: boolean);
    procedure jTimer1Timer(Sender: TObject);
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

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject;
  intentData: jObject);
begin
  bright.setBrightness(0.5);

  jSeekBar1.Progress := trunc(bright.getBrightness() * 100); // Float 0..1
  jCheckBox1.Checked := not bright.isBrightnessManual();

  jTimer1.Enabled:= true;
end;

procedure TAndroidModule1.jCheckBox1Click(Sender: TObject);
begin
  // If not change Mode
  jCheckBox1.Checked := not bright.isBrightnessManual();
end;

procedure TAndroidModule1.jSeekBar1ProgressChanged(Sender: TObject;
  progress: integer; fromUser: boolean);
begin
  bright.setBrightness( jSeekBar1.Progress / 100 );
end;

procedure TAndroidModule1.jTimer1Timer(Sender: TObject);
begin
  jTextView1.Text:= '[Brightness example] ' + intTostr(trunc(bright.getBrightness() * 100)) + '%';
end;

end.
