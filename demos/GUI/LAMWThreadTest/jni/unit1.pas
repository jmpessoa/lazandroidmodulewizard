{hint: Pascal files location: ...\LAMWThreadTest\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget,
  Laz_And_Controls,
  uThreadTest,
  And_jni;//*invoke0*
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jEditText1:jEditText;
    StartBtn:jButton;
    StopBtn:jButton;
    jTextView1:jTextView;
    procedure AndroidModule1RunOnUiThread(Sender:TObject;tag:integer);
    procedure AndroidModule1Show(Sender:TObject);
    procedure StartBtnClick(Sender:TObject);
    procedure StopBtnClick(Sender:TObject);
  private
    procedure LetsUpdate;
  public
    WorkerThread:TWorkerThread;
    procedure RunOnUiThread_corrected(correct_env:PJNIEnv;_tag:integer);
  end;

procedure invoke0(PEnv: PJNIEnv; this: JObject);cdecl;//*invoke0*

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

procedure invoke0(PEnv: PJNIEnv; this: JObject);cdecl;//*invoke0*
begin
  //*invoke0*
end;

procedure TAndroidModule1.RunOnUiThread_corrected(correct_env:PJNIEnv;_tag: integer);
begin
  if Initialized then
     jni_proc_i(correct_env, jSelf, 'RunOnUiThread', _tag);
end;

procedure TAndroidModule1.LetsUpdate;
begin
  jTextView1.Text:=WorkerThread.x.ToString;
end;

procedure TAndroidModule1.StartBtnClick(Sender:TObject);
begin
  if WorkerThread=nil then
  begin
    WorkerThread:=TWorkerThread.Create(True);
    WorkerThread.MainForm:=Self;
    WorkerThread.OnUpdate:=LetsUpdate;
    WorkerThread.Start;
  end;
end;

procedure TAndroidModule1.AndroidModule1RunOnUiThread(Sender:TObject;tag:integer
  );
begin
  CheckSynchronize();
end;

procedure TAndroidModule1.AndroidModule1Show(Sender:TObject);
begin

end;

procedure TAndroidModule1.StopBtnClick(Sender:TObject);
begin
  WorkerThread.Terminate;
end;

end.
