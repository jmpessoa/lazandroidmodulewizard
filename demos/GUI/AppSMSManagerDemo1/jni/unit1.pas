{Hint: save all files to location: C:\lamw\workspace\AppSMSManagerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, smsmanager,
  broadcastreceiver, searchview, radiogroup;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jListView1: jListView;
    jRadioGroup1: jRadioGroup;
    jSearchView1: jSearchView;
    jSMSManager1: jSMSManager;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jRadioGroup1CheckedChanged(Sender: TObject;
      checkedIndex: integer; checkedCaption: string);
    procedure jSearchView1QueryTextSubmit(Sender: TObject; query: string);
    procedure jSearchView1XClick(Sender: TObject);
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

    jRadioGroup1.CheckedIndex:= 0;  // <<-- initialize here!!
    //jListView1.SetFilterMode(fmStartsWith);    //default

   //https://developer.android.com/guide/topics/security/permissions#normal-dangerous
   //https://www.captechconsulting.com/blogs/runtime-permissions-best-practices-and-how-to-gracefully-handle-permission-removal
   if IsRuntimePermissionNeed() then   // that is, target API >= 23
   begin
      ShowMessage('RequestRuntimePermission....');

      SetLength(manifestPermissions, 1);

      manifestPermissions[0]:= 'android.permission.READ_SMS'; //from AndroodManifest.xml
     //manifestPermissions[1]:= 'android.permission.SEND_SMS'; //from AndroodManifest.xml
     //manifestPermissions[2]:= 'android.permission.RECEIVE_SMS';  //from AndroodManifest.xml

      Self.RequestRuntimePermission(manifestPermissions, 4001);
      SetLength(manifestPermissions, 0);
   end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
   case requestCode of
      4001:begin
              if grantResult = PERMISSION_GRANTED  then
                  ShowMessage('Success! ['+manifestPermission+'] Permission granted!!! ' )
              else//PERMISSION_DENIED
                  ShowMessage('Sorry... ['+manifestPermission+'] permission not granted... ' );
           end;
  end;
end;

//https://www.mytrendin.com/read-sms-from-inbox/  how to retrieve messages from a particular sender
//https://stackoverflow.com/questions/848728/how-can-i-read-sms-messages-from-the-device-programmatically-in-android
procedure TAndroidModule1.jButton1Click(Sender: TObject);
var
  i, count: integer;
begin

   if IsRuntimePermissionGranted('android.permission.READ_SMS')  then
   begin
       jListView1.Clear;
       count:= jSMSManager1.GetInboxCount();
       ShowMessage('count = '+ IntToStr(count));
       for i:= 0 to count-1 do
       begin
         jListView1.Add(jSMSManager1.ReadInbox(i));
       end;
   end
   else  ShowMessage('Sorry... Runtime [READ_SMS] Permission NOT Granted ...');

end;

procedure TAndroidModule1.jRadioGroup1CheckedChanged(Sender: TObject;
  checkedIndex: integer; checkedCaption: string);
begin
   ShowMessage(checkedCaption + ' = ' + IntToStr(checkedIndex));
   if checkedIndex = 0 then
      jListView1.SetFilterMode(fmStartsWith)
   else
     jListView1.SetFilterMode(fmContains);
end;

procedure TAndroidModule1.jSearchView1QueryTextSubmit(Sender: TObject;
  query: string);
begin
  jListView1.SetFilterQuery(query);
end;

procedure TAndroidModule1.jSearchView1XClick(Sender: TObject);
begin
  jListView1.ClearFilterQuery();
end;

end.
