{Hint: save all files to location: C:\adt32\eclipse\workspace\AppHttpClientCookiesDemo1\jni }
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
    jButton2: jButton;
    jButton3: jButton;
    jEditText1: jEditText;
    jHttpClient1: jHttpClient;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);

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
var
  cookies: TDynArrayOfString;
  count, i: integer;
  content: string;
begin
  jEditText1.Clear;

  jHttpClient1.ClearCookieStore();

  //blocking ...
  content:= jHttpClient1.GetStateful('http://www.google.com/');

  jEditText1.Clear;

  if jHttpClient1.GetCookiesCount() > 0 then
  begin
    cookies:= jHttpClient1.GetCookies('#'); // '$' --> cookie nameValueSepartor
    count:= Length(cookies);
    for i:=0 to count-1 do
    begin

      jEditText1.AppendLn(cookies[i]);
      //ShowMessage(cookies[i]);

      ShowMessage(jHttpClient1.GetCookieAttributeValue(
                      jHttpClient1.GetCookieByIndex(i), 'name')
                  );
                    {
                     'name'
                     'value'
                     'domain'
                     'version'
                     'expirydate'
                     'path'
                     'comment'
                     'ports'
                     }

    end;
  end;


  //http://www.google.com/
  //http://www.arenakampf.de


  {Fail ..
  jHttpClient1.AddNameValueData('user_password', 'hanjiahu');
  jHttpClient1.AddNameValueData('user_account', '8615161508006');
  jEditText1.AppendLn(jHttpClient1.PostStateful('http://demo.wanzi.cc/users/login'));
  }

end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jEditText1.Clear;
  if  not Self.IsWifiEnabled() then Self.SetWifiEnabled(True);
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  i, count: integer;
  cookie: JObject;
  contentSum: string;
begin

  jHttpClient1.ClearCookieStore();

  //jHttpClient1.AddClientHeader("Content-Type", "application/x-www-form-urlencoded");  //etc..
  //jHttpClient1.AddClientHeader('Set-Cookie','LAMW_SESSION_ID=1');                     //etc..

  cookie:= jHttpClient1.AddCookie('LAMW_SESSION_ID', '1');
  jHttpClient1.SetCookieAttributeValue(cookie, 'domain', '.localhost');
  jHttpClient1.SetCookieAttributeValue(cookie, 'path', '/');
  jHttpClient1.SetCookieAttributeValue(cookie, 'version', '1');


  {
   'name'
   'value'
   'domain'
   'version'
   'expirydate'
   'path'
   'comment'
   'ports'
   }

  jHttpClient1.AddNameValueData('param1', '4');
  jHttpClient1.AddNameValueData('param2', '6');

  //blocking
  contentSum:= jHttpClient1.PostStateful('http://ave.bolyartech.com/params.php');

  jEditText1.Clear;
  jEditText1.AppendLn('sum(param1, param1) = '+ contentSum);

  count:= jHttpClient1.GetCookiesCount();
  ShowMessage('Count Cookie = '+ IntToStr(count));
  for i:=0 to count-1 do
  begin
      ShowMessage(jHttpClient1.GetCookieAttributeValue(
                      jHttpClient1.GetCookieByIndex(i), 'name'));
      ShowMessage(jHttpClient1.GetCookieAttributeValue(
                      jHttpClient1.GetCookieByIndex(i), 'value'));

      ShowMessage(jHttpClient1.GetCookieAttributeValue(
                      jHttpClient1.GetCookieByIndex(i), 'domain'));

                    {
                     'name'
                     'value'
                     'domain'
                     'version'
                     'expirydate'
                     'path'
                     'comment'
                     'ports'
                     }
  end;

end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
var
  i, count: integer;
  content: string;
begin

   jHttpClient1.ClearCookieStore();

   //blocking
   content:= jHttpClient1.GetStateful('http://www.arenakampf.de');
   jEditText1.Clear;
   jEditText1.AppendLn(content);


   count:= jHttpClient1.GetCookiesCount();
   ShowMessage('Count Cookie = '+ IntToStr(count));

   for i:=0 to count-1 do
   begin
       ShowMessage(jHttpClient1.GetCookieAttributeValue(
                       jHttpClient1.GetCookieByIndex(i), 'name'));

       ShowMessage(jHttpClient1.GetCookieAttributeValue(
                       jHttpClient1.GetCookieByIndex(i), 'value'));

       ShowMessage(jHttpClient1.GetCookieAttributeValue(
                       jHttpClient1.GetCookieByIndex(i), 'domain'));

                     {
                      'name'
                      'value'
                      'domain'
                      'version'
                      'expirydate'
                      'path'
                      'comment'
                      'ports'
                      }
   end;

end;

end.
