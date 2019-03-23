{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppBroadcastReceiverDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, broadcastreceiver,
  And_jni, intentmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBroadcastReceiver1: jBroadcastReceiver;
    jButton1: jButton;
    jButton2: jButton;
    jIntentManager1: jIntentManager;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
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

//http://www.feelzdroid.com/2015/04/detect-incoming-call-android-programmatically.html
//http://www.theappguruz.com/blog/detecting-incoming-phone-calls-in-android

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if IsRuntimePermissionGranted('android.permission.READ_PHONE_STATE')  then  //from AndroodManifest.xml
   begin
     jBroadcastReceiver1.RegisterIntentActionFilter('android.intent.action.PHONE_STATE');
     //or jBroadcastReceiver1.IntentActionFilter:= afPhoneState;
     ShowMessage('Registering action PHONE_STATE ... Please, wait for a incomming call ... ');
   end;
end;

procedure TAndroidModule1.jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
var
 action, phoneState, phoneNumber: string;
begin
   action:= jIntentManager1.GetAction(intent);
   ShowMessage(action);
   if action = 'android.intent.action.PHONE_STATE' then
   begin
     //reference:   https://developer.android.com/reference/android/telephony/TelephonyManager.html
     phoneState:= jIntentManager1.GetExtraString(intent, 'state');

     ShowMessage(phoneState);

     if phoneState = 'IDLE' then
     begin
         ShowMessage('Waiting ...[IDLE]');
     end;

     if phoneState = 'RINGING' then
     begin
       phoneNumber:= jIntentManager1.GetExtraString(intent, 'incoming_number');
       ShowMessage('"Incomming call from [RINGING]: '+phoneNumber);
     end;

     if phoneState = 'OFFHOOK' then
     begin
        ShowMessage('Call end/received... [OFFHOOK]');
     end;

   end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   if IsRuntimePermissionNeed() then   // that is, if target API >= 23
   begin
     ShowMessage('RequestRuntimePermission....');
     ////https://developer.android.com/guide/topics/security/permissions#normal-dangerous
     //from AndroodManifest.xml
     Self.RequestRuntimePermission('android.permission.READ_PHONE_STATE', 1213);   //handled by OnRequestPermissionResult
   end
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
   case requestCode of
    1213:begin
           if grantResult = PERMISSION_GRANTED  then
           begin
              //ShowMessage('Success! ['+manifestPermission+'] Permission granted!!! ' );
              if manifestPermission = 'android.permission.READ_PHONE_STATE' then
              begin
                jButton1.Enabled:= True;
                jButton2.Enabled:= True;
              end;
           end
          else//PERMISSION_DENIED
          begin
              jButton1.Enabled:= False;
              jButton2.Enabled:= False;
              ShowMessage('Sorry... ['+manifestPermission+'] permission not granted... ' );
          end;
       end;
  end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   if  jBroadcastReceiver1.Registered then
  begin
    jBroadcastReceiver1.Unregister();
    ShowMessage('BroadcastReceiver UnRegistering ... [PHONE_STATE]');
  end
  else
  begin
    ShowMessage('Nothing Registered yet ... ');
  end;
end;

end.
