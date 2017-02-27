{Hint: save all files to location: \jni }
unit unit5;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule5 }

  TAndroidModule5 = class(jForm)
      jButton1: jButton;
      jEditText1: jEditText;
      jPanel1: jPanel;
      jPanel2: jPanel;
      jPanel3: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jWebView1: jWebView;

      procedure AndroidModule5Rotate(Sender: TObject; rotate: TScreenStyle);
      procedure DataModuleCloseQuery(Sender: TObject; var CanClose: boolean);
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);

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
begin
  //
end;

procedure TAndroidModule5.DataModuleCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  CanClose:= True;
end;

{
TScreenStyle   = (ssPortrait  = 1,  //Force Portrait
                    ssLandscape = 2, //Force LandScape
                    ssUnknown   = 3,
                    ssSensor    = 4);   //by Device Status
}
procedure TAndroidModule5.AndroidModule5Rotate(Sender: TObject;
  rotate: TScreenStyle);
begin
  if  rotate = ssPortrait then  //1 default --> device on vertical
  begin
     //jEditText1.Text:= strURL;
     jPanel1.LayoutParamHeight:= lpOneQuarterOfParent; //lpOneThirdOfParent;
     jPanel1.LayoutParamWidth:= lpMatchParent;
     jPanel2.PosRelativeToAnchor:= [raBelow];
     jPanel2.ResetAllRules;
  end
  else if  rotate = ssLandscape then//2 --> device on horizontal
  begin
     //jEditText1.Text:= '';
     jPanel1.LayoutParamHeight:= lpMatchParent;
     jPanel1.LayoutParamWidth:= lpOneThirdOfParent; //lpOneFifthOfParent; //lpOneThirdOfParent;
     jPanel2.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];
     jPanel2.ResetAllRules;
  end;

  Self.UpdateLayout;
end;

procedure TAndroidModule5.DataModuleJNIPrompt(Sender: TObject);
begin
  //
end;

procedure TAndroidModule5.jButton1Click(Sender: TObject);
begin
   if  jEditText1.Text <> '' then
   begin
     strURL:=  jEditText1.Text;
     if Pos('http://', strURL) = 0 then strURL:=  'http://' +  Trim(strURL);
     jWebView1.Navigate(strURL);
   end
   else
   begin
     ShowMessage('Warning: URL Text is empty!');
   end;
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
