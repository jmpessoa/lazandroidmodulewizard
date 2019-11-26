{Hint: save all files to location: C:\Temp\AppChronometerDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    timerCh: jTimer;
    lbTime: jTextView;
    procedure jButton1Click(Sender: TObject);
    procedure timerChTimer(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
    chStart : longint;
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if timerCh.Enabled then
  begin
    timerCh.Enabled := false;
    jButton1.Text   := 'Start';
  end else
  begin
    chStart := self.GetTimeInMilliseconds;
    timerCh.Enabled := true;
    jButton1.Text   := 'Stop';
  end;
end;

procedure TAndroidModule1.timerChTimer(Sender: TObject);
begin
  lbTime.Text := self.GetTimeHHssSS(self.GetTimeInMilliseconds - chStart);
end;

end.
