{Hint: save all files to location: C:\android\workspace\AppCustomSpeechToTextDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, customspeechtotext;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jCustomSpeechToText1: jCustomSpeechToText;
    jImageBtn1: jImageBtn;
    jImageBtn2: jImageBtn;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jCustomSpeechToText1SpeechResults(Sender: TObject;
      speechText: string);
    procedure jImageBtn2Down(Sender: TObject);
    procedure jImageBtn2Up(Sender: TObject);
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

procedure TAndroidModule1.jCustomSpeechToText1SpeechResults(Sender: TObject; speechText: string);
begin
  ShowMessage(speechText);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
   if IsRuntimePermissionNeed() then   //support for "target API >= 23"
   begin
      ShowMessage('warning: Requesting Runtime Permission.... please,  wait!');

      //from AndroodManifest.xml
      Self.RequestRuntimePermission('android.permission.RECORD_AUDIO', 3111);
   end
end;

procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
      3111:begin

              if grantResult = PERMISSION_GRANTED  then
                  ShowMessage(manifestPermission + ' :: Success! Permission granted!!! ' )
              else  //PERMISSION_DENIED
                  ShowMessage(manifestPermission + ' :: Sorry... Permission not granted... ' );
           end;
  end;
end;

procedure TAndroidModule1.jImageBtn2Down(Sender: TObject);
begin
  jImageBtn1.SetImageState(imDown);
  jCustomSpeechToText1.StartListening();
end;

procedure TAndroidModule1.jImageBtn2Up(Sender: TObject);
begin
  jCustomSpeechToText1.StopListening();
  jImageBtn1.SetImageState(imUp);
end;

end.
