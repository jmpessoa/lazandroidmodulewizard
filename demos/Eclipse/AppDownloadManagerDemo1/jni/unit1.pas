{Hint: save all files to location: C:\adt32\eclipse\workspace\AppDownloadManagerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, downloadmanager, broadcastreceiver;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBroadcastReceiver1: jBroadcastReceiver;
    jButton1: jButton;
    jCheckBox1: jCheckBox;
    jDownloadManager1: jDownloadManager;
    jImageView1: jImageView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
    procedure jButton1Click(Sender: TObject);
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
  res: TAndroidResult;
begin

   if not Self.isConnected() then
   begin
     ShowMessage('Sorry,  Device is not connected...');
     Exit;
   end;

  jBroadcastReceiver1.RegisterIntentActionFilter(jDownloadManager1.GetActionDownloadComplete()); //'android.intent.action.DOWNLOAD_COMPLETE'

  jDownloadManager1.SaveToFile(dirDownloads, 'plane-med.jpg');
  res:= jDownloadManager1.Start('http://www.freemediagoo.com/free-media/aviation/plane-med.jpg');

  if res = RESULT_OK then
    ShowMessage('OK!')
  else
    ShowMessage('FAIL');

end;

procedure TAndroidModule1.jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
begin

  ShowMessage(jDownloadManager1.GetExtras(intent, '|'));  //must call first!

  ShowMessage(jDownloadManager1.GetLocalFileName());
  ShowMessage('Size(bytes): ' + IntToStr(jDownloadManager1.GetFileSizeBytes()) );
  ShowMessage(jDownloadManager1.GetMediaType());
  ShowMessage(jDownloadManager1.GetLocalUriAsString());

  jBroadcastReceiver1.Unregister();  //unregister BroadcastReceiver ...

                               //or Self.ParseUri(jDownloadManager1.GetLocalUriAsString())
  jImageView1.SetImageFromURI( jDownloadManager1.GetFileUri() );

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
