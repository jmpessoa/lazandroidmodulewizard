{Hint: save all files to location: C:\adt32\eclipse\workspace\AppIntentDemo2\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, intentmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jCheckBox1: jCheckBox;
      jIntentManager1: jIntentManager;
      jTextView1: jTextView;
      procedure AndroidModule1ActivityResult(Sender: TObject;
        requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
    private
      {private declarations}
      FjUri: jObject;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

(*
image/jpeg
audio/mpeg4-generic
text/html
audio/mpeg
audio/aac
audio/wav
audio/ogg
audio/midi
audio/x-ms-wma
video/mp4
video/x-msvideo
video/x-ms-wmv
image/png
image/jpeg
image/gif
.xml ->text/xml
.txt -> text/plain
.cfg -> text/plain
.csv -> text/plain
.conf -> text/plain
.rc -> text/plain
.htm -> text/html
.html -> text/html
.pdf -> application/pdf
.apk -> application/vnd.android.package-archive
*)

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jIntentManager1.SetAction(jIntentManager1.GetActionViewAsString());  //or 'android.intent.action.VIEW'
  jIntentManager1.SetMimeType('text/html');

  jIntentManager1.SetDataUriAsString('http://forum.lazarus.freepascal.org/index.php/board,43.0.html');
  //or: jIntentManager1.SetDataUri(jIntentManager1.ParseUri('http://forum.lazarus.freepascal.org/index.php/board,43.0.html'));

   if jIntentManager1.ResolveActivity then
    jIntentManager1.StartActivity()
  else
    ShowMessage('Sorry, Not find an application that fulfills the requirement...');


end;

(* GetEnvironmentDirectoryPath();

TEnvDirectory = (dirDownloads,
                 dirDCIM,
                 dirMusic,
                 dirPictures,
                 dirNotifications,
                 dirMovies,
                 dirPodcasts,
                 dirRingtones,
                 dirSdCard,
                 dirInternalAppStorage,
                 dirDatabase,
                 dirSharedPrefs);
*)

//http://www.androiddiscuss.com/1-android-discuss/95167.html
procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  jIntentManager1.SetAction(jIntentManager1.GetActionSendtoAsString());
  //or jIntentManager1.SetAction('android.intent.action.SENDTO');

  jIntentManager1.SetMimeType('message/rfc822');

  //Please, change the test email ....
  jIntentManager1.SetDataUri(jIntentManager1.GetMailtoUri('jmpessoa@hotmail.com'));
  //or jIntentManager1.SetDataUriAsString('mailto:jmpessoa@hotmail.com');

  jIntentManager1.PutExtraMailSubject('Lamw: Testing Android Email Send....');
  jIntentManager1.PutExtraMailBody('Lamw: This is the text in email body.....');

  //try this: put some file in /Download ...
  ShowMessage('Please,  edit the file name  [/Download] ...');
  jIntentManager1.PutExtraFile(self.GetEnvironmentDirectoryPath(dirDownloads), 'lamw.png');

  if jIntentManager1.ResolveActivity then
    jIntentManager1.StartActivity('Send Email ...')
  else
    ShowMessage('Sorry, Not find an application that fulfills the requirement...');
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  jIntentManager1.SetAction('android.intent.action.PICK');
  //or: jIntentManager1.SetAction(jIntentManager1.GetActionPickAsString());

  //or: a wider choice application list ....
  //jIntentManager1.SetAction(jIntentManager1.GetActionGetContentUri()); //'android.intent.action.ACTION_GET_CONTENT'

  jIntentManager1.SetMimeType('image/*');             //or 'image/png' etc..  mime [android] must be lowercase!

  if jIntentManager1.ResolveActivity then
    jIntentManager1.StartActivityForResult(1001, 'Select an Image [Attachment]  ...')      //user-defined requestCode=1001
  else
    ShowMessage('Sorry, Not find an application that fulfills the requirement...');

end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
begin
  if  requestCode =  1001 then  //user-defined requestCode=1001
  begin
    if resultCode = RESULT_OK then  //ok
    begin
       FjUri:= nil;
       FjUri:= jIntentManager1.GetDataUri(intentData);
      if FjUri <> nil then
      begin
          jIntentManager1.SetAction(jIntentManager1.GetActionSendtoAsString());
          //or jIntentManager1.SetAction('android.intent.action.SENDTO');

          jIntentManager1.SetMimeType('message/rfc822');

          //Please, change the test email ....
          jIntentManager1.SetDataUri(jIntentManager1.GetMailtoUri('jmpessoa@hotmail.com'));
          //or jIntentManager1.SetDataUriAsString('mailto:jmpessoa@hotmail.com');

          jIntentManager1.PutExtraMailSubject('Lamw: Android Send Mail + Image....');
          jIntentManager1.PutExtraMailBody('Lamw: This is the text in email body: Android Send Mail + Image from Gallery....');

          //try this: put some file in ../Download ...
          jIntentManager1.PutExtraFile(FjUri);

          if jIntentManager1.ResolveActivity then
            jIntentManager1.StartActivity('Send Email ...')
          else
            ShowMessage('Sorry, Not find an application that fulfills the requirement...');

      end else ShowMessage('Fail! FjUri=nil....!');

    end else ShowMessage('Fail/cancel to pick a image ....');
  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
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
