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
  jBroadcastReceiver1.RegisterIntentActionFilter('android.intent.action.PHONE_STATE');
  //or jBroadcastReceiver1.IntentActionFilter:= afPhoneState;
  ShowMessage('Registering action PHONE_STATE ... Please, wait for a incomming call ... ');
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
         ShowMessage('Waiting ...');
     end;

     if phoneState = 'RINGING' then
     begin
       phoneNumber:= jIntentManager1.GetExtraString(intent, 'incoming_number');
       ShowMessage('"Incomming call from: '+phoneNumber);
     end;

     if phoneState = 'OFFHOOK' then
     begin
        ShowMessage('Call end/received...');
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
  else ShowMessage('Nothing Registered yet ... ');
end;

end.
