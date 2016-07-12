{Hint: save all files to location: C:\adt32\eclipse\workspace\AppAsyncTaskDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils,{ And_jni, And_jni_Bridge,} Laz_And_Controls, 
    {Laz_And_Controls_Events,} AndroidWidget;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jAsyncTask1: jAsyncTask;
      jButton1: jButton;
      jButton2: jButton;
      jDialogProgress1: jDialogProgress;
      jProgressBar1: jProgressBar;
      jTextView1: jTextView;
      procedure jAsyncTask1DoInBackground(Sender: TObject; progress: Integer;
        out keepInBackground: boolean);
      procedure jAsyncTask1PostExecute(Sender: TObject; progress: integer);
      procedure jAsyncTask1PreExecute(Sender: TObject; out
        startProgress: integer);
      procedure jAsyncTask1ProgressUpdate(Sender: TObject; progress: integer;
        out progressUpdate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
    private
      {private declarations}
    public
      {public declarations}
      function  DoTask(Progress: integer): boolean;
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

function  TAndroidModule1.DoTask(Progress: integer): boolean;
begin
  Result:= True; //doing task ...
  if Progress < 100 then
  begin
    Sleep(100 - Progress); //processing task...
  end
  else
    Result:= False; //done !!
end;


procedure TAndroidModule1.jAsyncTask1DoInBackground(Sender: TObject; progress: Integer; out keepInBackground: boolean);
begin  //do not put update GUI here!!!
  keepInBackground:= DoTask(progress); //doing taks:  False --> Done !
end;

procedure TAndroidModule1.jAsyncTask1PostExecute(Sender: TObject; progress: integer);
begin
  jButton1.Text:= 'Start Async Task ...';
  jProgressBar1.Stop;

  //jDialogProgress1.Stop;  //or Close

  jAsyncTask1.Done;
end;

procedure TAndroidModule1.jAsyncTask1PreExecute(Sender: TObject; out startProgress: integer);
begin
   startProgress:= 0;  //out param !
   jButton1.Text:= 'Running ...';
   jProgressBar1.Progress:= 0;
   jProgressBar1.Start;
  // jDialogProgress1.Start; //or Show
end;

procedure TAndroidModule1.jAsyncTask1ProgressUpdate(Sender: TObject; progress: integer; out progressUpdate: integer);
begin

   if progress <= jProgressBar1.Max then
   begin
      jProgressBar1.Progress:= progress;
     // jDialogProgress1.Msg:= 'Lamw: Please, wait... ['+IntToStr(progress)+']';
      progressUpdate:= progress + 1; //out param !
   end
   else
   begin
     jProgressBar1.Progress:= 0;
     //jDialogProgress1.Msg:= 'Lamw: Please, wait...';
     progressUpdate:= 0;  //out param !
   end;

end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin

   if not jAsyncTask1.Running then
   begin
     //ShowMessage('Execute ... ');
     jAsyncTask1.Execute
   end
  else
     ShowMessage('Running...');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   ShowMessage('Hello!');
end;

end.
