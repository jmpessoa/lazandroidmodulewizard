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
begin
  jEditText1.Clear;

  jHttpClient1.ClearCookieStore();
  jEditText1.AppendLn(jHttpClient1.GetStateful('http://www.google.com/'));

  if jHttpClient1.GetCookiesCount() > 0 then
  begin
    cookies:= jHttpClient1.GetCookies('#'); // '$' --> cookie nameValueSepartor
    count:= Length(cookies);
    for i:=0 to count-1 do
    begin

      ShowMessage(cookies[i]);

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

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  i, count: integer;
  cookie: JObject;
begin

  jEditText1.Clear;
  jHttpClient1.ClearCookieStore();

  //httppost.AddClientHeader("Content-Type", "application/x-www-form-urlencoded");  //etc..
  //jHttpClient1.AddClientHeader('Cookie','LAMW_SESSION_ID=1');                     //etc..

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
  jEditText1.AppendLn(jHttpClient1.PostStateful('http://ave.bolyartech.com/params.php'));

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
begin

   jEditText1.Clear;
   jHttpClient1.ClearCookieStore();

   jEditText1.AppendLn(jHttpClient1.GetStateful('http://www.arenakampf.de'));
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
