{Hint: save all files to location: \jni }
unit unit5;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls;
  
type

  { TAndroidModule5 }

  TAndroidModule5 = class(jForm)
      jButton1: jButton;
      jEditText1: jEditText;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jWebView1: jWebView;
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer;
        var rstRotate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jWebView1Status(Sender: TObject; Status: TWebViewStatus;
        URL: String; var CanNavi: Boolean);
    private
      {private declarations}
    public
      {public declarations}
  end;
  
var
  AndroidModule5: TAndroidModule5;

implementation
  
{$R *.lfm}
  

{ TAndroidModule5 }

procedure TAndroidModule5.DataModuleCreate(Sender: TObject);
begin
  Self.BackButton:= True;
  Self.BackgroundColor:= colbrBlack;
  //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
end;

procedure TAndroidModule5.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
    CanClose:= True;
end;

procedure TAndroidModule5.DataModuleJNIPrompt(Sender: TObject);
begin
  Self.Show;
end;

procedure TAndroidModule5.DataModuleRotate(Sender: TObject; rotate: integer;
  var rstRotate: integer);
begin
  Self.UpdateLayout;
end;

procedure TAndroidModule5.jButton1Click(Sender: TObject);
begin
   jWebView1.Navigate(jEditText1.Text);
end;

procedure TAndroidModule5.jWebView1Status(Sender: TObject;
  Status: TWebViewStatus; URL: String; var CanNavi: Boolean);
begin
   case Status of
    wvOnBefore : ShowMessage('OnBefore: ' + URL);
    wvOnFinish : ShowMessage('OnFinish: ' + URL);
    wvOnError  : ShowMessage('OnError : ' + URL);
  end;
end;

end.
