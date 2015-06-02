{Hint: save all files to location: \jni }
unit unit14;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule14 }

  TAndroidModule14 = class(jForm)
      jAsyncTask1: jAsyncTask;
      jButton1: jButton;
      jCheckBox1: jCheckBox;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jHttpClient1: jHttpClient;
      jProgressBar1: jProgressBar;
      jScrollView1: jScrollView;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;

      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer;
        var rstRotate: integer);
      procedure jAsyncTask1DoInBackground(Sender: TObject; Progress: Integer;
        out keepInBackground: boolean);
      procedure jAsyncTask1PostExecute(Sender: TObject; progress: integer);
      procedure jAsyncTask1PreExecute(Sender: TObject; out
        startProgress: integer);
      procedure jAsyncTask1ProgressUpdate(Sender: TObject; progress: integer;
        out progressUpdate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jCheckBox1Click(Sender: TObject);
      procedure jHttpClient1CodeResult(Sender: TObject; code: integer);
      procedure jHttpClient1ContentResult(Sender: TObject; content: string);
    private
       {private declarations}
    public
       {public declarations}
       FTaskDone: boolean;
       function DoTask(done: boolean): boolean;
  end;

var
  AndroidModule14: TAndroidModule14;

implementation
  
{$R *.lfm}
  

{ TAndroidModule14 }


procedure TAndroidModule14.DataModuleJNIPrompt(Sender: TObject);
begin
  if Self.IsWifiEnabled() then jCheckBox1.Checked:= True;
end;

procedure TAndroidModule14.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

function TAndroidModule14.DoTask(done: boolean): boolean;
begin
   if  not done then Result:= True //continue doing ...
   else  Result:= False; //done!
end;

procedure TAndroidModule14.jAsyncTask1DoInBackground(Sender: TObject; Progress: Integer; out keepInBackground: boolean);
begin
   keepInBackground:= DoTask(FTaskDone);
end;

procedure TAndroidModule14.jAsyncTask1PostExecute(Sender: TObject; progress: integer);
begin
  jButton1.Text:= 'Get/Start';
  jProgressBar1.Stop;
  jAsyncTask1.Done;
end;

procedure TAndroidModule14.jAsyncTask1PreExecute(Sender: TObject; out startProgress: integer);
begin
  startProgress:= 0; //out param
  jButton1.Text:= 'Running...';
  jProgressBar1.Progress:= 0;
  jProgressBar1.Start;
  jHttpClient1.Get;
end;

procedure TAndroidModule14.jAsyncTask1ProgressUpdate(Sender: TObject; progress: integer; out progressUpdate: integer);
begin
   if Progress <= jProgressBar1.Max then
   begin
      jProgressBar1.Progress:= Progress;
      progressUpdate:=  Progress + 1; //out param
   end
   else
   begin
      jProgressBar1.Progress:= 0;
      progressUpdate:= 0;  //out param
   end;
end;

procedure TAndroidModule14.jButton1Click(Sender: TObject);
begin
  if not jAsyncTask1.Running then
  begin
    FTaskDone:= False;
    jAsyncTask1.Execute;
  end;
end;

procedure TAndroidModule14.jCheckBox1Click(Sender: TObject);
begin
   if jCheckBox1.Checked then
   begin
     if not Self.IsWifiEnabled() then Self.SetWifiEnabled(True);
   end else Self.SetWifiEnabled(True);
end;

procedure TAndroidModule14.jHttpClient1CodeResult(Sender: TObject; code: integer);
begin
  ShowMessage('Http Code = '+ IntToStr(code));
end;

procedure TAndroidModule14.jHttpClient1ContentResult(Sender: TObject; content: string);
begin
   FTaskDone:= True;
   jAsyncTask1.Done;
   jEditText1.Text:= content;
   jEditText2.Text:= content;
end;

end.
