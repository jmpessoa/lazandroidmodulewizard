{Hint: save all files to location: C:\adt32\eclipse\workspace\AppHttpClientDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, helloadder, myhello;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jAsyncTask1: jAsyncTask;
      jButton1: jButton;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jHttpClient1: jHttpClient;
      jMyHello1: jMyHello;
      jProgressBar1: jProgressBar;
      jTextView1: jTextView;
      jTextView2: jTextView;
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jAsyncTask1AsyncEvent(Sender: TObject; EventType,
        Progress: Integer);
      procedure jButton1Click(Sender: TObject);
    private
      {private declarations}
      FStrContent: string;
      FStrURL: string;
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

  //jHttpClient1.SetAuthenticationHost('http:\\localhost', 123);    //ok!
   //jHttpClient1.SetAuthenticationUser('jmpessoa', '123456');       //ok!
   //jHttpClient1.SetAuthenticationMode(autBasic);                   //ok!
   //jHttpClient1.PostNameValueData('http:\\localhost\myphpcode.php', 'name=paul&city=bsb'); //ok
   //jHttpClient1.PostNameValueData('http:\\localhost\myphpcode.php', 'name','paul');     //ok

  FStrContent:= '';
  FStrURL:= jEditText1.Text;

  if not jAsyncTask1.Running then
     jAsyncTask1.Execute
  else
     ShowMessage('Running...');

end;

procedure TAndroidModule1.jAsyncTask1AsyncEvent(Sender: TObject; EventType, Progress: Integer);
begin
  case EventType of
     cjTask_Before: begin
                       jButton1.Text:= 'Running...';
                       jProgressBar1.Progress:= 0;
                       jProgressBar1.Start;
                       FStrContent:='';
                     end;

     cjTask_Progress: begin
                        if Progress <= jProgressBar1.Max then
                           jProgressBar1.Progress:= Progress
                        else
                           jProgressBar1.Progress:= 0;
                      end;

     cjTask_BackGround: begin //No UI Thread::write here the code to background task.

                          jHttpClient1.AttachCurrentThread();
                          FStrContent:= jHttpClient1.Get(FStrURL);

                          //jMyHello1.AttachCurrentThread();
                          //FStr:=jMyHello1.Hello;           //OK!

                          //jEditText2.AttachCurrentThread();
                          //jEditText2.Text:= FStr;           //OK!

                          //Self.AttachCurrentThread();
                          //FStr:= Self.GetDateTime;    //OK !

                          //Self.AttachCurrentThread();
                          //Self.ShowMessage('Hello AttachCurrentThread!'); //FAIL  !

                        end;

     cjTask_Post: begin
                    jButton1.Text:= 'Get Url Content';
                    jEditText2.Text:= FStrContent;
                    jProgressBar1.Stop;
                    jAsyncTask1.Done;
                  end;

  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jEditText2.Clear;
  jEditText1.SetFocus;
end;

end.
