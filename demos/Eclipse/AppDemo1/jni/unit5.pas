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
      jPanel1: jPanel;
      jPanel2: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jWebView1: jWebView;
      procedure DataModuleActive(Sender: TObject);
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure DataModuleRotate(Sender: TObject; rotate: integer; var rstRotate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jEditText1Change(Sender: TObject; EventType: TChangeType);
      procedure jEditText1Enter(Sender: TObject);
      procedure jWebView1Status(Sender: TObject; Status: TWebViewStatus; URL: String; var CanNavi: Boolean);
    private
      {private declarations}
      strURL: string;
    public
      {public declarations}
  end;
  
var
  AndroidModule5: TAndroidModule5;

implementation
  
{$R *.lfm}
  

{ TAndroidModule5 }

procedure TAndroidModule5.DataModuleCreate(Sender: TObject);
begin  //this initialization code is need here to fix Laz4Andoid  *.lfm parse.... why parse fails?
  Self.ActivityMode:= actRecyclable;
  //Self.BackgroundColor:= colbrBlack;
  //mode delphi
  Self.OnJNIPrompt:= DataModuleJNIPrompt;
  Self.OnRotate:= DataModuleRotate;
  Self.OnCloseQuery:= DataModuleCloseQuery;
  Self.OnActive:= DataModuleActive;
end;

procedure TAndroidModule5.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  CanClose:= True;
end;

procedure TAndroidModule5.DataModuleActive(Sender: TObject);
begin
  //ShowMessage('form 5 active');
end;

procedure TAndroidModule5.DataModuleJNIPrompt(Sender: TObject);
begin
  Self.Show;
end;

procedure TAndroidModule5.DataModuleRotate(Sender: TObject; rotate: integer; var rstRotate: integer);
begin
  if  rotate = 1 then  //default --> device on vertical
  begin
     jEditText1.Text:= strURL;
     jPanel1.LayoutParamHeight:= lpOneThirdOfParent;
     jPanel1.LayoutParamWidth:= lpMatchParent;
     jPanel2.PosRelativeToAnchor:= [raBelow];
  end
  else  //2 --> device on horizontal
  begin
     jEditText1.Text:= '';
     jPanel1.LayoutParamHeight:= lpMatchParent;
     jPanel1.LayoutParamWidth:= lpOneFifthOfParent; //lpOneThirdOfParent;
     jPanel2.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];
  end;
  Self.UpdateLayout;
end;

procedure TAndroidModule5.jButton1Click(Sender: TObject);
begin
   if  jEditText1.Text <> '' then
   begin
     strURL:=  jEditText1.Text;
     if Pos('http://', strURL)  < 0 then strURL:=  'http://' +  Trim(strURL);
     jWebView1.Navigate(strURL);
   end
   else
   begin
     ShowMessage('Warning: URL Text is empty!');
   end;
end;

procedure TAndroidModule5.jEditText1Change(Sender: TObject; EventType: TChangeType);
begin
   case EventType of
     ctChangeBefore: ShowMessage('Before..');
     ctChange: ShowMessage('Changing...');
     ctChangeAfter: ShowMessage('After...');
   end
end;

procedure TAndroidModule5.jEditText1Enter(Sender: TObject);
begin
   ShowMessage('Enter...');
end;


procedure TAndroidModule5.jWebView1Status(Sender: TObject; Status: TWebViewStatus; URL: String; var CanNavi: Boolean);
begin
  case Status of
    wvOnBefore : ShowMessage('OnBefore: ' + URL);
    wvOnFinish : ShowMessage('OnFinish: ' + URL);
    wvOnError  : ShowMessage('OnError : ' + URL);
  end;
end;

end.
