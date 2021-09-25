{Hint: save all files to location: C:\android\workspace\AppUSSDServiceDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls,
  broadcastreceiver, And_jni, intentmanager, ussdservice;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jBroadcastReceiver1: jBroadcastReceiver;
    jButton1: jButton;
    jButton2: jButton;
    jIntentManager1: jIntentManager;
    jIntentManager2: jIntentManager;
    jTextView1: jTextView;
    jUSSDService1: jUSSDService;
    procedure AndroidModule1Close(Sender: TObject);
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
  private
    {private declarations}
    FServiceStarted: boolean;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}


{ TAndroidModule1 }

// ref. https://stackoverflow.com/questions/22057625/prevent-ussd-dialog-and-read-ussd-response
// ref. http://habrahabr.ru/post/234425/

//IMPORTANT: Once app is installed, you have to enable the service in Accessibility Settings
//  ->Setting->Accessibility-> Service -> AppUSSDServiceDemo1   [click to get "On"]

procedure TAndroidModule1.jBroadcastReceiver1Receiver(Sender: TObject; intent: jObject);
var
  USSDResponse: string;
  action: string;
begin
   action:= jIntentManager1.GetAction(intent);
   if action = 'org.lamw.action.USSDService' then
   begin
      USSDResponse:= jIntentManager1.GetExtraString(intent, 'message');
      if Pos('USSD:', USSDResponse) > 0 then ShowMessage(USSDResponse);
   end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if not FServiceStarted then
   begin
    jUSSDService1.Start();
    FServiceStarted:= True;
    ShowMessage('Started! Now You have to enable the service in  Settings [Accessibility]! ');
   end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
var
  encodedHash: string;
  ussdCall: String;
  //uri: jObject;
begin
  //ShowMessage('Importante! You have to enable the service in Accessibility Settings!');
  if IsRuntimePermissionGranted('android.permission.CALL_PHONE')  then  //from AndroodManifest.xml
  begin
     encodedHash:= Self.UriEncode('#');
     ussdCall:= '*888' + encodedHash;  //some ussd Call ...  <<---- CHANGES here!!!


     jIntentManager2.SetAction('android.intent.action.CALL');

     //uri:= Self.ParseUri('tel:' + ussd);
     //jIntentManager2.SetDataUri(uri);

     //or
     jIntentManager2.SetDataUriAsString('tel:' + ussdCall);

     if jIntentManager2.ResolveActivity then
        jIntentManager2.StartActivity('Dial USSD Code...')
     else
        ShowMessage('Sorry, Unable to find an App to perform CALL action......');

  end
  else  ShowMessage('Sorry, Permission CALL not Granted ...');
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
    1987:begin
           if grantResult = PERMISSION_GRANTED  then
           begin
              if manifestPermission = 'android.permission.CALL_PHONE' then
              begin
                 ShowMessage(' Success [CALL] Permission GRANTED...!!S');
              end;
           end
       end;
  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin

  jBroadcastReceiver1.RegisterIntentActionFilter('org.lamw.action.USSDService');

  if IsRuntimePermissionNeed() then   // that is, if target API >= 23
   begin
     //ShowMessage('Requesting Runtime [dangerous] Permission....');
     //from AndroodManifest.xml
     Self.RequestRuntimePermission('android.permission.CALL_PHONE', 1987);   //handled by OnRequestPermissionResult
   end

end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject); //init here only "pure" pascal.... not JNI code...
begin
  FServiceStarted:= False; //init here only "pure" pascal.... not JNI code...
end;

procedure TAndroidModule1.AndroidModule1Close(Sender: TObject);
begin
  if jBroadcastReceiver1.Registered then
  begin
     jBroadcastReceiver1.Unregister();
  end;
end;

end.

