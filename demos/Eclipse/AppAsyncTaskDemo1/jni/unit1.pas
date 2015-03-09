{Hint: save all files to location: C:\adt32\eclipse\workspace\AppAsyncTaskDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jAsyncTask1: jAsyncTask;
      jButton1: jButton;
      jProgressBar1: jProgressBar;
      jTextView1: jTextView;
      procedure jAsyncTask1AsyncEvent(Sender: TObject; EventType,
        Progress: Integer);
      procedure jButton1Click(Sender: TObject);
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
   if not jAsyncTask1.Running then
     jAsyncTask1.Execute
  else
     ShowMessage('Running...');
end;

procedure TAndroidModule1.jAsyncTask1AsyncEvent(Sender: TObject; EventType,
  Progress: Integer);
var
  i: integer;
begin
  case EventType of
     cjTask_Before: begin
                       jButton1.Text:= 'Running...';
                       jProgressBar1.Progress:= 0;
                       jProgressBar1.Start;
                     end;

     cjTask_Progress: begin
                        if Progress <= jProgressBar1.Max then
                           jProgressBar1.Progress:= Progress
                        else
                           jProgressBar1.Progress:= 0;
                      end;

     cjTask_BackGround:begin
                          for i := 1 to 100 do
                          begin
                             Sleep(150);
                             jAsyncTask1.AttachCurrentThread();
                             jAsyncTask1.UpdateUI(i);
                          end;
                       end;

     cjTask_Post: begin
                    jButton1.Text:= 'Start Async Task';
                    jProgressBar1.Stop;
                    jAsyncTask1.Done;
                  end;

  end;
end;

end.
