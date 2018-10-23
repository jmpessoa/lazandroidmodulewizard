{Hint: save all files to location: C:\adt32\eclipse\workspace\AppIntentDemo3\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, intentmanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jIntentManager1: jIntentManager;
      jTextView1: jTextView;
      procedure AndroidModule1ActivityResult(Sender: TObject;
        requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure AndroidModule1RequestPermissionResult(Sender: TObject;
        requestCode: integer; manifestPermission: string;
        grantResult: TManifestPermissionResult);
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

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  manifestPermissions: TDynArrayOfString;
begin
  jButton1.Enabled:= False;
  jButton2.Enabled:= False;

   if IsRuntimePermissionNeed() then   // that is, if target API >= 23
   begin
     ShowMessage('RequestRuntimePermission....');

     ////https://developer.android.com/guide/topics/security/permissions#normal-dangerous
     SetLength(manifestPermissions, 2);

     manifestPermissions[0]:= 'android.permission.CALL_PHONE';  //from AndroodManifest.xml
     manifestPermissions[1]:= 'android.permission.READ_CONTACTS'; //from AndroodManifest.xml

     Self.RequestRuntimePermission(manifestPermissions, 3333);

     SetLength(manifestPermissions, 0);

   end
   else
   begin
     jButton1.Enabled:= True;
     jButton2.Enabled:= True;
   end;

end;

//"android.permission.CALL_PHONE"     jButton1.setEnabled(true);
procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
Sender: TObject; requestCode: integer; manifestPermission: string;
grantResult: TManifestPermissionResult);
begin
  case requestCode of
    3333:begin   //android.permission.CALL_PHONE
           if grantResult = PERMISSION_GRANTED  then
           begin
              ShowMessage('Success! ['+manifestPermission+'] Permission granted!!! ' );
              if manifestPermission = 'android.permission.CALL_PHONE'    then jButton1.Enabled:= True;
              if manifestPermission = 'android.permission.READ_CONTACTS' then jButton2.Enabled:= True;
           end
          else//PERMISSION_DENIED
          begin
              ShowMessage('Sorry... ['+manifestPermission+'] permission not granted... ' );
              jButton1.Enabled:= False;
              jButton2.Enabled:= False;
          end;
       end;
  end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   if IsRuntimePermissionGranted('android.permission.CALL_PHONE')  then   //from AndroodManifest.xml
   begin

       jIntentManager1.SetAction(jIntentManager1.GetActionDialAsString());
       //or jIntentManager1.IntentAction:= idDial;

      //Please, change de fone number!
      ShowMessage('Please, Edit de fone number .... ');
      jIntentManager1.SetDataUri(jIntentManager1.GetTelUri('06099181188'));
      //or: jIntentManager1.SetDataUri(jIntentManager1.ParseUri('tel:06699186188'));

      if jIntentManager1.ResolveActivity() then
         jIntentManager1.StartActivity('Dial ...')
      else
         ShowMessage('Unable to find an App to perform this action...');

   end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   if IsRuntimePermissionGranted('android.permission.CALL_PHONE') and
         IsRuntimePermissionGranted('android.permission.READ_CONTACTS')  then
   begin
       jIntentManager1.SetAction(jIntentManager1.GetActionGetContentUri());
       jIntentManager1.SetMimeType('vnd.android.cursor.item/phone_v2');

       if jIntentManager1.ResolveActivity() then
           jIntentManager1.StartActivityForResult(1003, 'Dial ...')
       else
           ShowMessage('Unable to find an App to perform this action...');

   end;
end;

procedure TAndroidModule1.AndroidModule1ActivityResult(Sender: TObject;
  requestCode: integer; resultCode: TAndroidResult; intentData: jObject);
var
   contactUri: jObject;
   strContactNumber: string;
begin
   strContactNumber:= '';
   contactUri:= jIntentManager1.GetDataUri(intentData);
   strContactNumber:= jIntentManager1.GetContactNumber(contactUri);
   if strContactNumber <> '' then
   begin
     //ShowMessage('result .... Contact Number: '+ contactNumber);
     jIntentManager1.SetAction(jIntentManager1.GetActionDialAsString());  //'android.intent.action.CALL'
     jIntentManager1.SetDataUri(jIntentManager1.GetTelUri(strContactNumber));

     if jIntentManager1.ResolveActivity() then
       jIntentManager1.StartActivity('Dial ...')
     else
       ShowMessage('Unable to find an App to perform this action...');

   end;
end;

end.
