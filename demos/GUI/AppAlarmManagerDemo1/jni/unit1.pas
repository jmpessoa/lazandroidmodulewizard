{Hint: save all files to location: C:\adt32\eclipse\workspace\AppAlarmManagerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, broadcastreceiver, timepickerdialog,
  datepickerdialog, alarmmanager, intentmanager;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jAlarmManager1: jAlarmManager;
    jBroadcastReceiver1: jBroadcastReceiver;
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jButton4: jButton;
    jDatePickerDialog1: jDatePickerDialog;
    jIntentManager1: jIntentManager;
    jTextView1: jTextView;
    jTimePickerDialog1: jTimePickerDialog;
    procedure jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jButton4Click(Sender: TObject);

    procedure jDatePickerDialog1DatePicker(Sender: TObject; year: integer;
      monthOfYear: integer; dayOfMonth: integer);
    procedure jTimePickerDialog1TimePicker(Sender: TObject; hourOfDay: integer;
      minute: integer);
  private
    {private declarations}
    FSaveAlarmId: integer;
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
   jDatePickerDialog1.Show();
end;

procedure TAndroidModule1.jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
begin
   ShowMessage('from: ' + jIntentManager1.GetAction(intent) );
   ShowMessage(jIntentManager1.GetExtraString(intent, 'Message') );
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jTimePickerDialog1.Show();
end;

//http://hmkcode.com/android-sending-receiving-custom-broadcasts/
procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
   ShowMessage('Alarm is Active !!');

   jBroadcastReceiver1.RegisterIntentActionFilter('com.example.appalarmmanagerdemo1.ALARM_RECEIVER');

   jAlarmManager1.SetIntentExtraString('Message', 'Hello! It''s time to go to ...');
   jAlarmManager1.SetRepeatInterval(1);  //repeat after 1 minute ...  ( 0 = no repeat! )
   FSaveAlarmId:= jAlarmManager1.Start('com.example.appalarmmanagerdemo1.ALARM_RECEIVER');
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
  ShowMessage('Stoped Alarme...');
  jAlarmManager1.Stop();     //cancel last alarm   //or jAlarmManager1.Stop(FSaveAlarmId)
  jBroadcastReceiver1.Unregister();  //unregister BroadcastReceiver ...
end;

procedure TAndroidModule1.jDatePickerDialog1DatePicker(Sender: TObject;
  year: integer; monthOfYear: integer; dayOfMonth: integer);
begin
    ShowMessage('year: '+ IntToStr(year) +
               ' monthOfYear: '+ IntToStr(monthOfYear)+
               ' dayOfMonth: '+ IntToStr(dayOfMonth));

    jAlarmManager1.SetYearMonthDay(year, monthOfYear, dayOfMonth);
end;

procedure TAndroidModule1.jTimePickerDialog1TimePicker(Sender: TObject;
  hourOfDay: integer; minute: integer);
begin
   ShowMessage('hourOfDay: '+ IntToStr(hourOfDay) +
                 ' minute: '+ IntToStr(minute));

   jAlarmManager1.SetHourMinute(hourOfDay, minute);
end;

end.
