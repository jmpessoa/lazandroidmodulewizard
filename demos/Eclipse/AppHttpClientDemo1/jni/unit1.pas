{Hint: save all files to location: C:\adt32\eclipse\workspace\AppHttpClientDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jDialogProgress1: jDialogProgress;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jHttpClient1: jHttpClient;
      jProgressBar1: jProgressBar;
      jTextView1: jTextView;
      jTextView2: jTextView;
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jHttpClient1CodeResult(Sender: TObject; code: integer);
      procedure jHttpClient1ContentResult(Sender: TObject; content: string);
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
  //jHttpClient1.SetAuthenticationHost('http:\\localhost', 123);    //ok!
  //jHttpClient1.SetAuthenticationUser('jmpessoa', '123456');       //ok!
  //jHttpClient1.SetAuthenticationMode(autBasic);                   //ok!
  //jHttpClient1.PostNameValueData('http:\\localhost\myphpcode.php', 'name=paul&city=bsb'); //ok
  //jHttpClient1.PostNameValueData('http:\\localhost\myphpcode.php', 'name','paul');     //ok
  jDialogProgress1.Start;
  jEditText2.Clear;
  jHttpClient1.Get(jEditText1.Text);
end;

procedure TAndroidModule1.jHttpClient1CodeResult(Sender: TObject; code: integer);
begin
  ShowMessage(IntToStr(code));
end;

procedure TAndroidModule1.jHttpClient1ContentResult(Sender: TObject; content: string);
begin
  jDialogProgress1.Stop;
  jEditText2.AppendLn(content);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jEditText2.Clear;
  jEditText1.SetFocus;
end;

end.
