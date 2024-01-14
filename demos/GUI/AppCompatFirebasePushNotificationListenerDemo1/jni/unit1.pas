{hint: Pascal files location: ...\AppCompatFirebasePushNotificationListenerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  sfirebasepushnotificationlistener, And_jni, intentmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jIntentManager1: jIntentManager;
    jsFirebasePushNotificationListener1: jsFirebasePushNotificationListener;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1NewIntent(Sender: TObject; intentData: jObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jsFirebasePushNotificationListener1GetTokenComplete(
      Sender: TObject; token: string; isSuccessful: boolean;
      statusMessage: string);
  private
    {private declarations}
    FPOSTNOTIFICATIONS: boolean;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jsFirebasePushNotificationListener1GetTokenComplete(
  Sender: TObject; token: string; isSuccessful: boolean; statusMessage: string);
begin
  if isSuccessful then
  begin
    ShowMessage('statusMessage= ' + statusMessage);
    ShowMessage('Token= ' + token);
  end
  else
  begin
    ShowMessage('statusMessage= ' + statusMessage);
  end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if FPOSTNOTIFICATIONS then
    jsFirebasePushNotificationListener1.GetFirebaseMessagingTokenAsync()
  else
    ShowMessage('Sorry... "android.permission.POST_NOTIFICATIONS" not granted... ' );
end;

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject);
var
  data: TDynArrayOfString;
  i, count: integer;
begin
  data:= jIntentManager1.GetBundleContent(intentData, '=');  //key=value
  count:= Length(data);
  for i:= 0 to count-1 do
  begin
     ShowMessage(data[i]);  //key=value
  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if IsRuntimePermissionNeed() then   // that is, if target API >= 23
  begin
    //ShowMessage('Requesting Runtime Permission....');
    Self.RequestRuntimePermission(['android.permission.POST_NOTIFICATIONS'], 1110);   //handled by OnRequestPermissionResult
  end;
end;

procedure TAndroidModule1.AndroidModule1NewIntent(Sender: TObject; intentData: jObject);
var
  data: TDynArrayOfString;
  i, count: integer;
begin
  data:= jIntentManager1.GetBundleContent(intentData, '=');  //key=value
  count:= Length(data);
  for i:= 0 to count-1 do
  begin
     ShowMessage(data[i]);  //key=value
  end;
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
    case requestCode of
    1110:begin
           if grantResult = PERMISSION_GRANTED  then
           begin
             FPOSTNOTIFICATIONS:= True;
             if manifestPermission = 'android.permission.POST_NOTIFICATIONS' then ShowMessage('"'+manifestPermission+'"  granted!');
           end
          else//PERMISSION_DENIED
          begin
              FPOSTNOTIFICATIONS:= False;
              ShowMessage('Sorry... "['+manifestPermission+']" not granted... ' );
          end;
       end;
  end;
end;

end.

(*

doc: "how_to_handling_firebase_push_notification.txt"

How to: Handling Firebase Push Notification in LAMW  [warning: "beta" version ::  23-July-2021]
	(by jmpessoa)


0) Create your "AppCompat" [[theme]] project
	0.1)Put a "jsFirebasePushNotificationListener" component on form
        0.2)Go to lazarus menu and simply  "Run" --> "Build"

1) Login in your google acount [email or any....]

2) Go to "https://console.firebase.google.com/"

3) Create/Add a new Project   [ex: "MyOrg"]

4) Go to your "MyOrg" project and click "+Add app"

5) Click on Android Icon

6) In [page] "Add Firebase to your Android app":
	6.1) "Register App"
		6.1.1 ""Android package name"
			ex: org.lamw.appcompatfirebasepushnotificationlistenerdemo1

		6.1.2 CLICK the button "Register app"

	6.2) "Download config file"
                 get the "google-services.json" and put it in your LAMW project folder

        Done!

	[don't do anything more, LAMW takes care of it all for you!]

7) Active your Internet phone/device connection

8) Go to Lazarus menu "Run" --> "[LAMW] Build Android Apk and Run"

9) Go to "https://console.firebase.google.com/"

	9.1 Click the "MyOrg" project
	9.2 In the left panel/menu page go to "Engage" --> "Cloud Messaging"
	9.3 Click "New notification" Button
	9.4 Fill the form and click "Next"
	9.5 In the "Target" --> "selectan app"   [select your app package...] and "Next"
        9.6 In the "Scheduling" --> "Now"  and "Next"
        9.7 In the bottom page click the button "Review"
	9.8 "Publish"  !!!!


Congratulations!!!


10) Notes about your/custom Payload expected by LAMW component:
   [https://firebase.google.com/docs/cloud-messaging/concept-options?hl=en]

10.1 Notification Payload


{
"message":{
-    ...
     ...
    "notification":{
      "title" : "my message title",     // ---> "title" expected by LAMW
      "body" : "my message body"        // ---> "body"  expected by LAMW
    }
    ...
    ...
  }
}

Note: Notification messages are delivered to the notification tray when the app is in the background.
For apps in the foreground, messages are handled/delivery by a LAMW callback function for you !!!


10.2 Data Payload

{
  "message":{
    ...
    ...
    "data":{
      "title":"my message title",// ---> "title" expected by LAMW
      "body":"my message body",  // ---> "body" expected by LAMW
      "myKey1":"myValue1"        //free/custom
      "myKey2":"myValue2"        //free/custom
       ......                    //free/custom
    }
    ...
    ...
  }
}

Where myKey1, myKey2, .... are your free/custom key=value pairs ....

warning: from "data" messages only "title" and "body" are handled/delivery by the LAMW callback function for you
         but you can read all "data" when App is "waking up" by clicking in notification....

//by code:
procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject);
var
  data: TDynArrayOfString;
  i, count: integer;
begin
  data:= jIntentManager1.GetBundleContent(intentData, '=');  //key=value
  count:= Length(data);
  for i:= 0 to count-1 do
  begin
     ShowMessage(data[i]);  //key=value
  end;
end;s

//and/or maybe:
procedure TAndroidModule1.AndroidModule1NewIntent(Sender: TObject; intentData: jObject);
var
  data: TDynArrayOfString;
  i, count: integer;
begin
  data:= jIntentManager1.GetBundleContent(intentData, '=');  //key=value
  count:= Length(data);
  for i:= 0 to count-1 do
  begin
     ShowMessage(data[i]);  //key=value
  end;
end;


10.3 Mixing Notification and Data Payload

{
  "message":{
    ...
    "notification":{
      "title" : "my message title",     // ---> "title" expected by LAMW
      "body" : "my message body"        // ---> "body"  expected by LAMW
    }
    "data":{
      "myKey1":"myValue1"        //free/custom
      "myKey2":"myValue2"        //free/custom
       ......
    }
    ...
    ...
  }
}


10.4  WARNING: "beta" version ::  23-July-2021

10.5 References

https://firebase.google.com/docs/cloud-messaging/concept-options?hl=en
https://medium.com/android-news/firebase-push-notification-fe1e03119b77
https://www.alura.com.br/artigos/push-notifications-com-firebase
https://medium.com/nybles/sending-push-notifications-by-using-firebase-cloud-messaging-249aa34f4f4c
https://stackoverflow.com/questions/37711082/how-to-handle-notification-when-app-in-background-in-firebase
https://sagar-r-kothari.github.io/android/kotlin/2020/07/14/FCM-ForeBack.html

*)
