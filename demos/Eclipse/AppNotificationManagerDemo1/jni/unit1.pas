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
      jNotificationManager1: jNotificationManager;
      jTextView1: jTextView;
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

    jNotificationManager1.Id:= 1001;
    jNotificationManager1.Title:= 'Lamw';
    jNotificationManager1.Subject:= 'Hello!';
    jNotificationManager1.Body:= 'Lamw: Hello System Notification ...';
    jNotificationManager1.IConIdentifier:='lamw_logo';
    jNotificationManager1.Notify();

    //or
    //jNotificationManager1.Notify(1001,'Lamw','Hello','Lamw: App Hello World Notification Demo1!', 'lamw_logo');

end;

end.
