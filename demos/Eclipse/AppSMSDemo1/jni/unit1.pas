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
   if jSMS1.Send(jEditText1.Text, jEditText2.Text, 'com.example.appsmsdemo1.SMS_DELIVERED') = 1 then
     ShowMessage('Message Sending .... OK!')
   else
     ShowMessage('Message Sending .... Fail!');
   jEditText2.Text:= '';
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

   jBroadcastReceiver1.RegisterIntentActionFilter('android.provider.Telephony.SMS_RECEIVED');
     //or jBroadcastReceiver1.IntentActionFilter:= afSMSReceived;

   //register custom app action to retrieve DELIVERED status
   jBroadcastReceiver2.RegisterIntentActionFilter('com.example.appsmsdemo1.SMS_DELIVERED');

   jEditText1.SetFocus;
end;

procedure TAndroidModule1.jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
var
   smsCaller, smsReceived, smsBody: string;
   auxList: TStringList;
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
end;

//DELIVERED status
procedure TAndroidModule1.jBroadcastReceiver2Receiver(Sender: TObject; intent: jObject);
begin
   if jBroadcastReceiver2.GetResultCode() = 1 then   //ok
      ShowMessage('Ok. SMS delivered !!')
   else
      ShowMessage('Sorry... SMS Not delivered...')
end;

end.
