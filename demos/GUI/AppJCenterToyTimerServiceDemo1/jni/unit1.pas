{Hint: save all files to location: C:\android\workspace\AppJCenterToyTimerServiceDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, ctoytimerservice;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jcToyTimerService1: jcToyTimerService;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1ActivityStart(Sender: TObject);
    procedure AndroidModule1ActivityStop(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jcToyTimerService1PullElapsedTime(Sender: TObject;
      elapsedTime: int64);
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

procedure TAndroidModule1.AndroidModule1ActivityStart(Sender: TObject);
begin
  ShowMessage('Starting / Binding Service...');
  jcToyTimerService1.Start();
  jcToyTimerService1.Bind();
end;

procedure TAndroidModule1.AndroidModule1ActivityStop(Sender: TObject);
begin
  jcToyTimerService1.RunForeground(); //here is the "magic" !
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin

   if jcToyTimerService1.IsTimerRunning() then
  begin
     ShowMessage('Timer Stoped... no more service elapsed time update...');
     jcToyTimerService1.TimerOff();
     jButton1.Text:= 'Timer On';
  end
  else
  begin;
     ShowMessage('Timer Running...');
     jcToyTimerService1.TimerOn();
     jButton1.Text:= 'Timer Off';
  end;
end;

procedure TAndroidModule1.jcToyTimerService1PullElapsedTime(Sender: TObject;
  elapsedTime: int64);
begin
  jTextView2.Text:= 'Elapsed time: ' + IntToStr(elapsedTime);
end;

end.
