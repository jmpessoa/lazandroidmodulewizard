{hint: Pascal files location: ...\AppWebViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jEditText1: jEditText;
    jImageBtn1: jImageBtn;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jWebView1: jWebView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jImageBtn1Click(Sender: TObject);
    procedure jWebView1ReceivedSslError(Sender: TObject; error: string;
      primaryError: TWebViewSslError; var outProceed: boolean);
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

procedure TAndroidModule1.jImageBtn1Click(Sender: TObject);
begin


  if IsRuntimePermissionGranted('android.permission.CAMERA') and
     IsRuntimePermissionGranted('android.permission.RECORD_AUDIO') and
     IsRuntimePermissionGranted('android.permission.MODIFY_AUDIO_SETTINGS')   then
  begin
     //jWebView1.Navigate(jEditText1.Text);
     ShowMessage('Please,  wait....');
     jWebView1.Navigate('https://forum.lazarus.freepascal.org/index.php');
  end
  else
    ShowMessage('Sorry... Some Runtime Permission NOT Granted ...');

end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
     1234:begin
              if grantResult = PERMISSION_GRANTED  then
                ShowMessage('Success! ['+manifestPermission+'] Permission grant!!! ' )
              else  //PERMISSION_DENIED
                ShowMessage('Sorry... ['+manifestPermission+'] Permission not grant... ' );
          end;
  end;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if  Self.IsRuntimePermissionNeed() then   // that is, target API >= 23
  begin
      ShowMessage('warning: Requesting Runtime Permission.... please, wait..');

      //if not exists in "AndroidManifest.xml" then Add this permissions to "AndroidManifest.xml"  in your project folder ...
      Self.RequestRuntimePermission(['android.permission.RECORD_AUDIO',
                                     'android.permission.CAMERA',
                                     'android.permission.MODIFY_AUDIO_SETTINGS'], 1234); //for microphone

  end;
end;

procedure TAndroidModule1.jWebView1ReceivedSslError(Sender: TObject;
  error: string; primaryError: TWebViewSslError; var outProceed: boolean);
begin

  ShowMessage(error);

  //outProceed = False //default!

  case primaryError of
       sslNotYetValid: outProceed:= True;
       sslExpired:     outProceed:= True;
       sslIdMisMatch:  outProceed:= True;
       sslUntrusted:   outProceed:= True;
  end;

end;

end.
