{Hint: save all files to location: C:\lamw\workspace\AppUploadServiceDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, broadcastreceiver,
  intentmanager, uploadservice, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBroadcastReceiver1: jBroadcastReceiver;
    jButton1: jButton;
    jCheckBox1: jCheckBox;
    jIntentManager1: jIntentManager;
    jTextView1: jTextView;
    jUploadService1: jUploadService;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
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

    if IsRuntimePermissionNeed() then   // that is, target API >= 23  - Android 6
    begin
       ShowMessage('RequestRuntimePermission....');
       //hint: if you  get "write" permission then you have "read", too!
       Self.RequestRuntimePermission(['android.permission.READ_EXTERNAL_STORAGE'], 3027);//android.permission.WRITE_EXTERNAL_STORAGE
    end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
     3027:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
   end;
end;

procedure TAndroidModule1.jBroadcastReceiver1Receiver(Sender: TObject;
  intent: jObject);
var
  res: string;
  elapsedTime: integer;
begin

  //ShowMessage('from: ' + jIntentManager1.GetAction(intent) );
  if jIntentManager1.GetAction(intent) =  'org.lamw.appuploadservicedemo1.UPLOAD_RECEIVER' then
  begin
    if jIntentManager1.GetExtraString(intent, 'Result') =  'RESULT_OK' then //or 'RESULT_CANCELED'
    begin
      ShowMessage(jIntentManager1.GetExtraString(intent, 'ResponseCode') );
      ShowMessage(jIntentManager1.GetExtraString(intent, 'ResponseMessage') );
      elapsedTime:= jIntentManager1.GetExtraInt(intent, 'ElapsedTimeInSeconds');
      ShowMessage('Elapsed Time = '+ IntToStr(elapsedTime) +' sec');
      jBroadcastReceiver1.Unregister();  //unregister BroadcastReceiver ...
    end
    else ShowMessage('Fail. RESULT_CANCELED');

  end;

end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
      //hint: if you  get "write" permission then you have "read", too!

    if not IsRuntimePermissionGranted('android.permission.READ_EXTERNAL_STORAGE') then  //android.permission.WRITE_EXTERNAL_STORAGE
    begin
      ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');
      Exit;
    end;

    if not Self.isConnected() then
    begin
       ShowMessage('Sorry, Device is not connected...');
       Exit;
    end;

    ShowMessage('Uploading...');
    jBroadcastReceiver1.RegisterIntentActionFilter('org.lamw.appuploadservicedemo1.UPLOAD_RECEIVER');

    //jUploadService1.UploadFile(Self.GetEnvironmentDirectoryPath(dirDownloads), 'ship2.jpg');  //need permission
    jUploadService1.UploadFileFromAssets('pirate_ship.png');   //not need permission...
    jUploadService1.Start('http://10.1.3.196', 'lamwFormUpload' {web form name}, 'com.example.appdownloadservicedemo1.UPLOAD_RECEIVER');

end;

(*
https://www.simplifiedcoding.net/android-upload-image-to-server/
http://codesfor.in/how-to-upload-a-file-to-server-in-android/

<?php
 //path of the folder which file is to be saved
 $file_path = $_SERVER['DOCUMENT_ROOT'] ."/images"/";

 $file_path = $file_path . basename( $_FILES['lamwFormUpload']['name']);
 if(move_uploaded_file($_FILES['lamwFormUpload']['tmp_name'], $file_path)) {
 echo "success";
 } else{
 echo "fail";
 }
 ?>

*)

end.
