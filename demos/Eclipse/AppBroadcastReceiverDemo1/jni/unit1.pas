{Hint: save all files to location: C:\adt32\eclipse\workspace\AppBroadcastReceiverDemo1\jni }
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
      jButton1: jButton;
      jButton2: jButton;
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

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jBroadcastReceiver1.IntentActionFilter:= afTimeTick;  //please, wait a minute!
  //or jBroadcastReceiver1.RegisterIntentActionFilter('android.intent.action.TIME_TICK');
  ShowMessage('Registering TIME_TICK ... Please, wait a minute !! ');
end;

procedure TAndroidModule1.jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
begin
   ShowMessage('BroadcastReceiving ... [TIME_TICK] :: ' + DateTimeToStr(Now) );
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  if  jBroadcastReceiver1.Registered then
  begin
    jBroadcastReceiver1.Unregister();
    ShowMessage('BroadcastReceiver UnRegistering ... [TIME_TICK]');
  end
  else ShowMessage('Nothing Registered yet ... ');
end;

end.
