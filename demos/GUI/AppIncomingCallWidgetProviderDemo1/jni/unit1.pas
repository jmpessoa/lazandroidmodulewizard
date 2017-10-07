{Hint: save all files to location: C:\android-neon\eclipse\workspace\AppIncomingCallWidgetProviderDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  incomingcallwidgetprovider, And_jni, intentmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jIncomingCallWidgetProvider1: jIncomingCallWidgetProvider;
    jIntentManager1: jIntentManager;
    jTextView1: jTextView;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject
      );
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
	d) loook for "AppIncomingCallWidgetProviderDemo1 4x1"
	f) long press "AppIncomingCallWidgetProviderDemo1 4x1" to install
	g) keep waiting for an "incoming call"
	h) has "incoming call"? click the widget to re-open and hanlde the "caller" from your App!

HINTS 2: How to configure/change widget

res/layout
	jincomingcallwigetprovider_layout.xml    <<-- change [only content, NOT the file name] to configure
res/drawable-xxxx
	jincomingcallwigetprovider_image.jpg  <<-- change [only content, NOT the file [and extension] name]  to configure
res/xml
	jincomingcallwigetprovider_info.xml	<<-- change [only content,  NOT the file name]  to configure
*)

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject);
var
   phoneState, phoneNumber: string;
begin
   phoneState:= jIntentManager1.GetExtraString(intentData, 'state');

   if  phoneState = 'RINGING' then
   begin
      phoneNumber:= jIntentManager1.GetExtraString(intentData, 'incoming_number');
      ShowMessage('Incoming call from: '+phoneNumber);
   end;

end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jIntentManager1.SetAction(gApp.AppName +'.LAMW_IC_WIDGET_NOTIFY');
  jIntentManager1.PutExtraString('notify_message','Thanks, Incomming Call Widget helper!');
  jIntentManager1.SendBroadcast();
end;

end.
