{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppSMSWidgetProviderDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  And_jni, intentmanager, smswidgetprovider, radiogroup;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jIntentManager1: jIntentManager;
    jSMSWidgetProvider1: jSMSWidgetProvider;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject);
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


(*
HINTS:

res/layout
	smswigetlayout.xml    <<-- change [only content, NOT the file name] to configure
res/drawable-xxxx
	smswidgetbackgroundimage.jpg  <<-- change [only content, NOT the file name]  to configure
res/xml
	smswidgetinfo.xml	<<-- change [only content,  NOT the file name]  to configure
*)

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject);
var
   msg: string;
begin
   msg:= jIntentManager1.GetExtraString(intentData, 'sms_body');
   if  msg <> '' then
       ShowMessage(msg);
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jIntentManager1.SetAction('org.lamw.appsmswidgetproviderdemo1'+'.WIDGET_NOTIFY'); //gApp.AppName + '.WIDGET_NOTIFY;
  jIntentManager1.PutExtraString('notify_message','Thanks, SMS Widget helper!');
  jIntentManager1.SendBroadcast();
end;

end.
