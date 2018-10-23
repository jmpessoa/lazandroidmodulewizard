{Hint: save all files to location: C:\lamw\workspace\AppTelephonyManagerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, telephonymanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jCheckBox1: jCheckBox;
    jCheckBox2: jCheckBox;
    jCheckBox3: jCheckBox;
    jEditText1: jEditText;
    jTelephonyManager1: jTelephonyManager;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTextView3: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jTelephonyManager1CallStateChanged(Sender: TObject;
      state: TTelephonyCallState; phoneNumber: string);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

// https://www.mkyong.com/android/how-to-make-a-phone-call-in-android/
// http://danielthat.blogspot.com/2013/06/android-make-phone-call-with-speaker-on.html
// https://developer.android.com/guide/topics/security/permissions#normal-dangerous

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.jTelephonyManager1CallStateChanged(Sender: TObject;
  state: TTelephonyCallState; phoneNumber: string);
begin
  case state of
      csIdle: begin
         jTelephonyManager1.SetSpeakerphoneOn(False);
      end;
      csRinging: begin
         ShowMessage('Please, wait... phone is ringing...');
      end;
      csOffHook: begin
         jTelephonyManager1.SetSpeakerphoneOn(True);
      end;
  end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if IsRuntimePermissionGranted('android.permission.CALL_PHONE')  and
     IsRuntimePermissionGranted('android.permission.READ_PHONE_STATE')  and
     IsRuntimePermissionGranted('android.permission.MODIFY_AUDIO_SETTINGS') then   //from AndroodManifest.xml
  begin
     jTelephonyManager1.Call(jEditText1.Text);
  end
  else
  begin
     ShowMessage('Sorry... Some permission was DENIED !! ');
  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  manifestPermissions: TDynArrayOfString;
begin
   jCheckBox1.Checked:= False;
   jCheckBox2.Checked:= False;
   jCheckBox3.Checked:= False;

   if IsRuntimePermissionNeed() then   // that is, if target API >= 23
   begin
     ShowMessage('RequestRuntimePermission....');

     ////https://developer.android.com/guide/topics/security/permissions#normal-dangerous
     SetLength(manifestPermissions, 3);

     manifestPermissions[0]:= 'android.permission.CALL_PHONE';                //from AndroodManifest.xml
     manifestPermissions[1]:= 'android.permission.READ_PHONE_STATE';      //from AndroodManifest.xml
     manifestPermissions[2]:= 'android.permission.MODIFY_AUDIO_SETTINGS';  //from AndroodManifest.xml

     Self.RequestRuntimePermission(manifestPermissions, 1212);   //handled by OnRequestPermissionResult

     SetLength(manifestPermissions, 0);

   end
   else
   begin
     jCheckBox1.Checked:= True;
     jCheckBox2.Checked:= True;
     jCheckBox3.Checked:= True;
   end;

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
    1212:begin
           if grantResult = PERMISSION_GRANTED  then
           begin
              //ShowMessage('Success! ['+manifestPermission+'] Permission granted!!! ' );
              if manifestPermission = 'android.permission.CALL_PHONE' then jCheckBox1.Checked:= True;
              if manifestPermission = 'android.permission.READ_PHONE_STATE' then jCheckBox2.Checked:= True;
              if manifestPermission = 'android.permission.MODIFY_AUDIO_SETTINGS' then jCheckBox3.Checked:= True;
           end
          else//PERMISSION_DENIED
          begin
              jButton1.Enabled:= False;
              ShowMessage('Sorry... ['+manifestPermission+'] permission not granted... ' );
          end;
       end;
  end;
end;

end.
