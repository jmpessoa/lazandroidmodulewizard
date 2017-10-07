{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppSMSWidgetProviderDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  And_jni, intentmanager, smswidgetprovider;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jIntentManager1: jIntentManager;
    jListView1: jListView;
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
HINT 1: How to install widget:

	a)Run/Install the App
	b) Use BackButton to leave the App
	c) long press the home screen and select "widgets"
	d) loook for "AppSMSWidgetProviderDemo1 4x1"
	f) long press "AppSMSWidgetProviderDemo1 4x1" to install
	g) keep waiting for a "sms"
	h) has sms arrived? click the widget to re-open and hanlde the message from your App!

HINTS 2: How to configure/change widget

res/layout
	jsmswigetprovider_layout.xml    <<-- change [only content, NOT the file name] to configure
res/drawable-xxxx
	jsmswigetprovider_image.jpg  <<-- change [only content, NOT the file name]  to configure
res/xml
	jsmswigetprovider_info.xml	<<-- change [only content,  NOT the file name]  to configure
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
  jIntentManager1.SetAction(gApp.AppName+'.LAMW_SMS_WIDGET_NOTIFY');
  jIntentManager1.PutExtraString('notify_message','Thanks, SMS Widget helper!');
  jIntentManager1.SendBroadcast();
end;

end.
