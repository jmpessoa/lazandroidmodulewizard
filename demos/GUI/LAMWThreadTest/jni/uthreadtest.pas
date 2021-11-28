unit uThreadTest;

{$mode delphi}

interface

uses
  Classes, SysUtils,
  AndroidWidget,And_jni;

type

  { TWorkerThread }

  TWorkerThread=class(TThread)
  private
    procedure UpdateValue;
  protected
    procedure Execute; override;
  public
    MainForm:jForm;
    x:integer;
    OnUpdate:Procedure of object;

    procedure LetsWakeMainThread(Sender: TObject);
  end;


implementation
uses
  unit1;

{ TWorkerThread }

procedure TWorkerThread.UpdateValue;
begin
  if Assigned(OnUpdate) then
    OnUpdate;
end;

threadvar
  env:PJNIEnv;//<--- has to be a threadvar

procedure TWorkerThread.Execute;
begin
  gVM^.AttachCurrentThread(gVM,@env,nil);//<--- needed for every thread
  WakeMainThread:=LetsWakeMainThread;//<--- needed once
  x:=0;
  repeat
    inc(x);
    Synchronize(UpdateValue);
    Sleep(1000);
  until Terminated;
  gVM^.DetachCurrentThread(gVM);//<--- when you are done with the thread (Free/Destroy)
end;

procedure TWorkerThread.LetsWakeMainThread(Sender:TObject);
begin
  //MainForm.RunOnUiThread(Integer(Self));//<--- Wrong env variable, not for this thread
  TAndroidModule1(MainForm).RunOnUiThread_corrected(env,0);
end;

end.

