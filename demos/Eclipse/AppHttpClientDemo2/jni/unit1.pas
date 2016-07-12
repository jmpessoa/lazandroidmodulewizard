{Hint: save all files to location: C:\adt32\eclipse\workspace\AppHttpClientDemo2\jni }
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
    jCheckBox1: jCheckBox;
    jEditText1: jEditText;
    jHttpClient1: jHttpClient;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
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

{

// get the cookie if need, for login
String cookies = conn.getHeaderField("Set-Cookie");

// open the new connnection again
conn = (HttpURLConnection) new URL(newUrl).openConnection();
conn.setRequestProperty("Cookie", cookies);

}
procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  clientConn: jObject;
  headerByName: string;
  listAllHeaders: TDynArrayOfString;
  i, count: integer;
  response: string;                                                      //http://ave.bolyartech.com/params.php
  responseCode: integer;
begin
                                                                         //http://www.arenakampf.de
   clientConn:= jHttpClient1.OpenConnection('http://cartoonforyou.forumvi.com/h1-page');   //http://www.google.com/

   {//before connect !!
   jHttpClient1.SetRequestProperty(clientConn, 'Content-Type', 'text/plain; charset=utf-8');
   jHttpClient1.SetRequestProperty(clientConn, 'Cookie', 'Lamw_Session_Id=1');
   jHttpClient1.AddRequestProperty(clientConn, 'User-Agent', 'Lamw (Android)');
   jHttpClient1.AddRequestProperty(clientConn, 'Custom', 'Lamw_ID=1');
   }

  listAllHeaders:=  jHttpClient1.GetHeaderFields(clientConn);
  count:= Length(listAllHeaders);
  for i:= 0 to count-1 do
  begin
     jEditText1.AppendLn(listAllHeaders[i]);
  end;
  SetLength(listAllHeaders, 0); //free ...

  ShowMessage(jHttpClient1.GetHeaderField(clientConn, 'Server'));
  ShowMessage(jHttpClient1.GetHeaderField(clientConn, 'Content-Type'));
  ShowMessage(jHttpClient1.GetHeaderField(clientConn, 'Set-Cookie'));
  ShowMessage(jHttpClient1.GetHeaderField(clientConn, 'Keep-Alive'));

  response:= jHttpClient1.Get(clientConn);  //Connect!
  ShowMessage(response);

  responseCode:= jHttpClient1.GetResponseCode();
  ShowMessage(IntToStr(responseCode));

  jHttpClient1.Disconnect(clientConn);

end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  clientConn: jObject;
  headerByName: string;
  listAllHeaders: TDynArrayOfString;
  i, count: integer;
  response: string;
  responseCode: integer;
begin
   clientConn:= jHttpClient1.OpenConnection('http://ave.bolyartech.com/params.php');

   {//before connect !!
   jHttpClient1.SetRequestProperty(clientConn, 'Content-Type', 'text/plain; charset=utf-8');
   jHttpClient1.SetRequestProperty(clientConn, 'Cookie', 'Lamw_Session_Id=1');
   jHttpClient1.AddRequestProperty(clientConn, 'User-Agent', 'Lamw (Android)');
   jHttpClient1.AddRequestProperty(clientConn, 'Custom', 'Lamw_ID=1');
   }

  jHttpClient1.ClearNameValueData;
  jHttpClient1.AddNameValueData('param1', '4');
  jHttpClient1.AddNameValueData('param2', '10');
  response:= jHttpClient1.Post(clientConn);  //Connect !!

  responseCode:= jHttpClient1.GetResponseCode();

  if  responseCode = 200 then
    ShowMessage('SUM = ' + response)
  else
    ShowMessage('Error! Response Code = ' + IntToStr(responseCode));

  listAllHeaders:=  jHttpClient1.GetHeaderFields(clientConn);
  count:= Length(listAllHeaders);
  for i:= 0 to count-1 do
  begin
     jEditText1.AppendLn(listAllHeaders[i]);
  end;
  SetLength(listAllHeaders, 0); //free ...

  {
  //after connect
  ShowMessage(jHttpClient1.GetHeaderField(clientConn, 'Server'));
  ShowMessage(jHttpClient1.GetHeaderField(clientConn, 'Content-Type'));
  ShowMessage(jHttpClient1.GetHeaderField(clientConn, 'Set-Cookie'));
  ShowMessage(jHttpClient1.GetHeaderField(clientConn, 'Keep-Alive'));
  }

  jHttpClient1.Disconnect(clientConn);

end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  // jEditText1.HintTextColor:= colbrYellow;
  jEditText1.Clear;

  if not Self.isConnected() then
  begin //try wifi
    if Self.SetWifiEnabled(True) then
      jCheckBox1.Checked:= True
    else
      ShowMessage('Please,  try enable some connection...');
  end
  else
  begin
     if Self.isConnectedWifi() then jCheckBox1.Checked:= True
  end;

end;

end.
