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
      procedure DataModuleActive(Sender: TObject);
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
       resultInfo: string;
  end;

var
  AndroidModule14: TAndroidModule14;

implementation
  
{$R *.lfm}
  

{ TAndroidModule14 }

procedure TAndroidModule14.DataModuleCreate(Sender: TObject);
begin //this initialization code is need here to fix Laz4Andoid  *.lfm parse.... why parse fails?
  Self.ActivityMode:= actRecyclable;
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

procedure TAndroidModule14.DataModuleActive(Sender: TObject);
begin
  //
end;

procedure TAndroidModule14.DataModuleJNIPrompt(Sender: TObject);
begin
  jEditText2.Parent:= jScrollView1.View;    //change the parent here!
  Self.Show;
end;

procedure TAndroidModule14.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule14.jAsyncTask1AsyncEvent(Sender: TObject; EventType, Progress: Integer);
var
  i: integer;
begin
  case EventType of
     cjTask_Before     : begin
                          { Dialog.show();}
                           jButton1.Text:= 'Running...';
                           //jTextView2.Text:= 'UI_Task_Progress: 0';
                           jProgressBar1.Progress:= 0;
                           jProgressBar1.Start;
                         end;

     cjTask_Progress   : begin
                           //jTextView2.Text := 'UI_Task_Progress: ' + IntToStr(Progress);
                           if Progress <= jProgressBar1.Max then
                           begin
                              jProgressBar1.Progress:= Progress
                           end
                           else
                              jProgressBar1.Progress:= 0;
                         end;
     cjTask_BackGround : // Thread Routine Here - write here the code to any background task.
                         begin
                           resultInfo:= jHttpClient1.Get;
                         end;
     cjTask_Post       : begin
                           {Dialog.dismiss();}
                           //jTextView2.Text:= 'The game is over!!';
                           jButton1.Text:= 'Get/Start';
                           jProgressBar1.Stop;
                           jAsyncTask1.Done;
                           //ShowMessage(resultInfo);
                           jEditText1.Text:= resultInfo;
                           jEditText2.Text:= resultInfo;
                         end;
  end;
end;

procedure TAndroidModule14.jButton1Click(Sender: TObject);
begin

  if not jAsyncTask1.Running then
     jAsyncTask1.Execute
  else
     ShowMessage('Running...');

end;


end.
