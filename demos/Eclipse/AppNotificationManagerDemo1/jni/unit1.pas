{Hint: save all files to location: C:\adt32\eclipse\workspace\AppNotificationManagerDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, notificationmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jNotificationManager1: jNotificationManager;
      jTextView1: jTextView;
      procedure AndroidModule1JNIPrompt(Sender: TObject);
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

    jNotificationManager1.Id:= 1001;  //user def ...
    jNotificationManager1.Title:= 'Lamw';
    jNotificationManager1.Subject:= 'Hello!';
    jNotificationManager1.Body:= 'Lamw: Hello System Notification ...';
    jNotificationManager1.IConIdentifier:='lamw_logo';
    //jNotificationManager1.LightsColor:= colbrCoral;
    jNotificationManager1.Notify();

    //or
    //jNotificationManager1.Notify(1001,'Lamw','Hello','Lamw: App Hello World Notification Demo1!', 'lamw_logo');
     ShowMessage('Notification ok ... ');

end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
      ShowMessage('Set Led to "Red" ...');
     jNotificationManager1.SetLightsColor(colbrRed);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  //Self.SetKeepScreenOn();
end;

end.
