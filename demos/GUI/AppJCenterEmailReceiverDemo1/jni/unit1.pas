{Hint: save all files to location: C:\android\workspace\AppJCenterEmailReceiverDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, cmail;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jcMail1: jcMail;
    jListView1: jListView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jcMail1MessageRead(Sender: TObject; position: integer;
      Header: string; Date: string; Subject: string; ContentType: string;
      ContentText: string; Attachments: string);
    procedure jcMail1MessagesCount(Sender: TObject; count: integer);
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
Gmail:
       //for POP3
       //protocol = "pop3";
       //host = "pop.gmail.com";
       //port = "995";

       //for IMAP
       protocol = "imap";
       host = "imap.gmail.com";
       port = "993";

https://appuals.com/fix-your-imap-server-wants-to-alert-you-invalid-credentials/
   Method 2: Allowing less secure apps     <<------------ Fix here!
   Method 3: Enabling IMAP access in your Gmail Account  <<------------ Fix here!

}

procedure TAndroidModule1.jButton1Click(Sender: TObject);
//var
  //count: integer;
  //msg: String;
begin

  //note 1: jcMail component force "minSdkVersion 19" in "AndroidManifest.xml"
  if not Self.IsConnectedWifi() then
  begin
     ShowMessage('Please,  connect to Internet....');
     Exit;
  end;

  jcMail1.Protocol:= mpImap;
  jcMail1.HostName:= 'imap.googlemail.com';
  jcMail1.HostPort:= 993;
  jcMail1.UserName:= 'myuser@gmail.com';
  jcMail1.Password:='pwd123';

  //blocking mode
  //count:= jcMail1.GetInBoxCount();
  //ShowMessage('count = ' + IntToStr(count))
  //msg:= jcMail1.GetInBoxMessage(3, '|');
  //jListView1.Add(msg);

  jcMail1.GetInBoxCountAsync(); //handle by "OnMessagesCount"
  ShowMessage('Getting InBox Count Async.... ');

end;

procedure TAndroidModule1.jcMail1MessageRead(Sender: TObject;
  position: integer; Header: string; Date: string; Subject: string;
  ContentType: string; ContentText: string; Attachments: string);
begin

  jListView1.Add('Position: ' + IntToStr(position));
  jListView1.Add(Header);
  jListView1.Add('Date: '+ Date);
  jListView1.Add('Subject: '+ Subject);
  jListView1.Add('ContentType: '+ContentType);
  jListView1.Add(ContentText);
  jListView1.Add('Attachments Files:' +Attachments);

end;

procedure TAndroidModule1.jcMail1MessagesCount(Sender: TObject; count: integer);
begin
  ShowMessage('InBoxCount = ' + IntToStr(count));
  jcMail1.GetInBoxMessageAsync(3, '|'); //handle by "OnMessageRead"

  //jcMail1.GetInBoxMessagesAsync(3, 2, '|'); //handle by "OnMessageRead"

end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  if IsRuntimePermissionNeed() then   // that is, device/target API >= 23
      Self.RequestRuntimePermission('android.permission.WRITE_EXTERNAL_STORAGE', 1177)
  else //not need run time permission... [old devices...]
     jcMail1.AttachmentsDir:= Self.GetEnvironmentDirectoryPath(DirDownloads);

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
     case requestCode of
     1177:begin
            if manifestPermission = 'android.permission.WRITE_EXTERNAL_STORAGE' then
            begin
                if grantResult = PERMISSION_GRANTED  then
                    jcMail1.AttachmentsDir:= Self.GetEnvironmentDirectoryPath(DirDownloads)
                else
                   ShowMessage('Warning... Attachments Files will not saved....');
            end;
          end;
     end;
end;

end.
