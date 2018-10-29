{Hint: save all files to location: C:\adt32\eclipse\workspace\AppSMSDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, broadcastreceiver;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBroadcastReceiver1: jBroadcastReceiver;
    jBroadcastReceiver2: jBroadcastReceiver;
    jButton1: jButton;
    jEditText1: jEditText;
    jEditText2: jEditText;
    jEditText3: jEditText;
    jSMS1: jSMS;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    jTextView4: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
    procedure jBroadcastReceiver2Receiver(Sender: TObject; intent: jObject);
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
begin

   if IsRuntimePermissionGranted('android.permission.SEND_SMS')  then
   begin
     if jSMS1.Send(jEditText1.Text, jEditText2.Text, 'com.example.appsmsdemo1.SMS_DELIVERED') = 1 then
       ShowMessage('Message Sending .... OK!')
     else
       ShowMessage('Message Sending .... Fail!');
   end
   else  ShowMessage('Sorry... Runtime [SEND_SMS] Permission NOT Granted ...');

   jEditText2.Text:= '';
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  manifestPermissions: TDynArrayOfString;

begin
   //https://developer.android.com/guide/topics/security/permissions#normal-dangerous
   //https://www.captechconsulting.com/blogs/runtime-permissions-best-practices-and-how-to-gracefully-handle-permission-removal
   if IsRuntimePermissionNeed() then   // that is, target API >= 23
   begin
      ShowMessage('RequestRuntimePermission....');

      SetLength(manifestPermissions, 3);

      manifestPermissions[0]:= 'android.permission.RECEIVE_SMS';  //from AndroodManifest.xml
      manifestPermissions[1]:= 'android.permission.SEND_SMS'; //from AndroodManifest.xml
      // required for sms send otherwise error is occured on my device - elera
      manifestPermissions[2]:= 'android.permission.READ_PHONE_STATE';

      Self.RequestRuntimePermission(manifestPermissions, 2001);

      SetLength(manifestPermissions, 0);
   end;

   jEditText1.SetFocus;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
   case requestCode of  //android.permission.RECEIVE_SMS
      2001:begin
              if grantResult = PERMISSION_GRANTED  then
              begin
                  ShowMessage('Success! ['+manifestPermission+'] Permission granted!!! ' );

                  if manifestPermission = 'android.permission.RECEIVE_SMS' then
                      jBroadcastReceiver1.RegisterIntentActionFilter('android.provider.Telephony.SMS_RECEIVED');

                  //register custom app action to retrieve DELIVERED status
                  if manifestPermission = 'android.permission.SEND_SMS' then
                      jBroadcastReceiver2.RegisterIntentActionFilter('com.example.appsmsdemo1.SMS_DELIVERED');

              end
              else//PERMISSION_DENIED
                  ShowMessage('Sorry... ['+manifestPermission+'] permission not granted... ' )
           end;

  end;
end;

procedure TAndroidModule1.jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
var
   smsCaller, smsReceived, smsBody: string;
   auxList: TStringList;
begin
  if IsRuntimePermissionGranted('android.permission.RECEIVE_SMS')  then
  begin
     ShowMessage('New Message Receiving ....');
     smsReceived:= jSMS1.Read(intent, '#');
     if smsReceived <> '' then
     begin
        auxList:= TStringList.Create;
        auxList.Delimiter:= '#';
        auxList.StrictDelimiter:= True;
        auxList.DelimitedText:= smsReceived;
        if auxList.Count > 1 then;
        begin
          smsCaller:= auxList.Strings[0];
          smsBody:=  auxList.Strings[1];
          jEditText3.AppendLn('['+ smsCaller+']');
          jEditText3.AppendLn(smsBody);
          jEditText3.AppendLn(' ');
        end;
        auxList.Free;
     end;
  end
  else  ShowMessage('Sorry.. Runtime [RECEIVE_SMS] Permission NOT Granted ...');
end;

//DELIVERED status
procedure TAndroidModule1.jBroadcastReceiver2Receiver(Sender: TObject; intent: jObject);
begin
   if jBroadcastReceiver2.GetResultCode() = RESULT_OK then   //ok
      ShowMessage('Ok. SMS delivered !!')
   else
      ShowMessage('Sorry... SMS Not delivered...')
end;

end.
