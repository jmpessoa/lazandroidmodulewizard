{Hint: save all files to location: C:\lamw\workspace\AppTelephonyManagerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, telephonymanager, And_jni,
  broadcastreceiver, intentmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBroadcastReceiver1: jBroadcastReceiver;
    jButton1: jButton;
    jButton2: jButton;
    jCheckBox1: jCheckBox;
    jCheckBox2: jCheckBox;
    jCheckBox3: jCheckBox;
    jCheckBox4: jCheckBox;
    jEditText1: jEditText;
    jIntentManager1: jIntentManager;
    jTelephonyManager1: jTelephonyManager;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure AndroidModule1Close(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jTelephonyManager1CallStateChanged(Sender: TObject;
      state: TTelephonyCallState; phoneNumber: string);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

// https://www.mkyong.com/android/how-to-make-a-phone-call-in-android/
// http://danielthat.blogspot.com/2013/06/android-make-phone-call-with-speaker-on.html
// https://developer.android.com/guide/topics/security/permissions#normal-dangerous

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

//warning: this event  fire/dispatch/work ONLY when the app is in foreground !!!!
procedure TAndroidModule1.jTelephonyManager1CallStateChanged(Sender: TObject;
  state: TTelephonyCallState; phoneNumber: string);
begin
  case state of
      csIdle: begin
         jTelephonyManager1.SetSpeakerphoneOn(False);
      end;
      csRinging: begin
         ShowMessage('Please, wait... phone is ringing...');
      end;
      csOffHook: begin
         jTelephonyManager1.SetSpeakerphoneOn(True);
      end;
  end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if IsRuntimePermissionGranted('android.permission.CALL_PHONE')  and
     IsRuntimePermissionGranted('android.permission.READ_PHONE_STATE')  and
     IsRuntimePermissionGranted('android.permission.MODIFY_AUDIO_SETTINGS') then   //from AndroodManifest.xml
  begin
     jTelephonyManager1.Call(jEditText1.Text);
  end
  else
  begin
     ShowMessage('Sorry... Some permission was DENIED !! ');
  end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if {IsRuntimePermissionGranted('android.permission.CALL_PHONE')  and }
     IsRuntimePermissionGranted('android.permission.READ_PHONE_STATE')  {and
     IsRuntimePermissionGranted('android.permission.MODIFY_AUDIO_SETTINGS')} then   //from AndroodManifest.xml
  begin
    ShowMessage(jTelephonyManager1.GetIMEI());
    ShowMessage(jTelephonyManager1.GetLine1Number())
  end
  else
  begin
     ShowMessage('Sorry... Some permission was DENIED !! ');
  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  manifestPermissions: TDynArrayOfString;
begin
   jCheckBox1.Checked:= False;
   jCheckBox2.Checked:= False;
   jCheckBox3.Checked:= False;
   jCheckBox4.Checked:= False;

   //warning: need  when the app is in background!!!
   jBroadcastReceiver1.RegisterIntentActionFilter('android.intent.action.PHONE_STATE'); //android.intent.action.NEW_OUTGOING_CALL

   if IsRuntimePermissionNeed() then   // that is, if target API >= 23
   begin
     ShowMessage('RequestRuntimePermission....');

     ////https://developer.android.com/guide/topics/security/permissions#normal-dangerous
     SetLength(manifestPermissions, 4);

     manifestPermissions[0]:= 'android.permission.CALL_PHONE';                //from AndroodManifest.xml
     manifestPermissions[1]:= 'android.permission.READ_PHONE_STATE';      //from AndroodManifest.xml
     manifestPermissions[2]:= 'android.permission.MODIFY_AUDIO_SETTINGS';  //from AndroodManifest.xml
     manifestPermissions[3]:= 'android.permission.PROCESS_OUTGOING_CALLS';
     Self.RequestRuntimePermission(manifestPermissions, 1212);   //handled by OnRequestPermissionResult

     SetLength(manifestPermissions, 0);

   end
   else
   begin
     jCheckBox1.Checked:= True;
     jCheckBox2.Checked:= True;
     jCheckBox3.Checked:= True;
     jCheckBox4.Checked:= True;
   end;

end;

procedure TAndroidModule1.AndroidModule1Close(Sender: TObject);
begin
  if jBroadcastReceiver1.Registered then
  begin
    jBroadcastReceiver1.Unregister();
  end
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
    1212:begin
           if grantResult = PERMISSION_GRANTED  then
           begin
              //ShowMessage('Success! ['+manifestPermission+'] Permission granted!!! ' );
              if manifestPermission = 'android.permission.CALL_PHONE' then jCheckBox1.Checked:= True;
              if manifestPermission = 'android.permission.READ_PHONE_STATE' then jCheckBox2.Checked:= True;
              if manifestPermission = 'android.permission.MODIFY_AUDIO_SETTINGS' then jCheckBox3.Checked:= True;
              if manifestPermission = 'android.permission.PROCESS_OUTGOING_CALLS' then jCheckBox4.Checked:= True;
           end
          else//PERMISSION_DENIED
          begin
              jButton1.Enabled:= False;
              ShowMessage('Sorry... ['+manifestPermission+'] permission not granted... ' );
          end;
       end;
  end;
end;

//warning: this event  is need  when the app is in background !!!!
procedure TAndroidModule1.jBroadcastReceiver1Receiver(Sender: TObject;
  intent: jObject);
var
 action, phoneState, phoneNumber: string;
begin
   action:= jIntentManager1.GetAction(intent);
   //ShowMessage(action);
   if action = 'android.intent.action.PHONE_STATE' then
   begin

     //https://developer.android.com/reference/android/telephony/TelephonyManager.html
     phoneState:= jIntentManager1.GetExtraString(intent, 'state');

     ShowMessage(phoneState);

     if phoneState = 'IDLE' then
     begin
         ShowMessage('Waiting... [IDLE]');
     end;

     if phoneState = 'RINGING' then
     begin
       phoneNumber:= jIntentManager1.GetExtraString(intent, 'incoming_number');
       ShowMessage('"Incomming call from [RINGING]: '+phoneNumber);
     end;

     if phoneState = 'OFFHOOK' then
     begin
        ShowMessage('Call and/received... [OFFHOOK]');
     end;

   end;

end;

end.
