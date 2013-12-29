{Hint: save all files to location: \jni }
unit unit14;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;
  
type

  { TAndroidModule14 }

  TAndroidModule14 = class(jForm)
      jAsyncTask1: jAsyncTask;
      jButton1: jButton;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jHttpClient1: jHttpClient;
      jProgressBar1: jProgressBar;
      jScrollView1: jScrollView;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer;
        var rstRotate: integer);
      procedure jAsyncTask1AsyncEvent(Sender: TObject; EventType,
        Progress: Integer);
      procedure jButton1Click(Sender: TObject);
    private
       {private declarations}
    public
       {public declarations}
       rst: string;
       countProgress: integer;
       function DoBackGroundTask: string;
  end;

var
  AndroidModule14: TAndroidModule14;

implementation
  
{$R *.lfm}
  

{ TAndroidModule14 }

function TAndroidModule14.DoBackGroundTask: string;
var
  i: integer;
begin
  Result:= jHttpClient1.Get;
  for i:= 0 to 100 do
  begin
     inc(countProgress);
     jAsyncTask1.UpdateUI(countProgress);
     sleep(20);
  end;
end;

procedure TAndroidModule14.DataModuleCreate(Sender: TObject);
begin
  Self.BackButton:= True;
  Self.BackgroundColor:= colbrBlack;
    //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
end;

procedure TAndroidModule14.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  CanClose:= True;
end;

procedure TAndroidModule14.DataModuleJNIPrompt(Sender: TObject);
begin
  jEditText2.Parent:= jScrollView1.View;
  Self.Show;
end;

procedure TAndroidModule14.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule14.jAsyncTask1AsyncEvent(Sender: TObject; EventType, Progress: Integer);
begin
  case EventType of
     cjTask_Before     : begin
                          { Dialog.show();}
                           countProgress:= 0;
                           jButton1.Text:= 'Running...';
                           //jTextView2.Text:= 'UI_Task_Progress: 0';
                           jProgressBar1.Progress:= 0;
                           jProgressBar1.Start;
                         end;

     cjTask_Progress   : begin
                           //jTextView2.Text := 'UI_Task_Progress: ' + IntToStr(Progress);
                           if Progress <= jProgressBar1.Max then
                              jProgressBar1.Progress:= Progress
                           else
                              jProgressBar1.Progress:= 0;
                         end;
     cjTask_BackGround : // Thread Routine Here - write here the code to any background task.
                         begin
                           rst:= DoBackGroundTask;  {Http Get...}
                         end;
     cjTask_Post       : begin
                           {Dialog.dismiss();}
                           //jTextView2.Text:= 'The game is over!!';
                           jButton1.Text:= 'Get/Start';
                           jProgressBar1.Stop;
                           jAsyncTask1.Done;
                           //ShowMessage(rst);
                           jEditText1.Text:= rst;
                           jEditText2.Text:= rst;
                         end;
  end;
end;

procedure TAndroidModule14.jButton1Click(Sender: TObject);
begin
  if not jAsyncTask1.Running then
  begin
     jAsyncTask1.Execute;
  end
  else ShowMessage('Running...');
end;

end.
