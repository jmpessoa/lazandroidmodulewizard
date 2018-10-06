{Hint: save all files to location: C:\adt32\eclipse\workspace\AppMediaRecorderDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, mediarecorder,
  mediaplayer;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jMediaPlayer1: jMediaPlayer;
    jMediaRecorder1: jMediaRecorder;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure AndroidModule1RequestPermissionResult(Sender: TObject;
      requestCode: integer; manifestPermission: string;
      grantResult: TManifestPermissionResult);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jMediaPlayer1Completion(Sender: TObject);
    procedure jMediaPlayer1Prepared(Sender: TObject; videoWidth: integer; videoHeight: integer);
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

procedure TAndroidModule1.jButton1Click(Sender: TObject);  //record
begin

  if not IsRuntimePermissionNeed() then     //Target API < 23
  begin
     ShowMessage('Recording started ... [start]');
     jMediaRecorder1.SetAudioSource(asrcMic);
     jMediaRecorder1.SetOutputFormat(fmtThreeGpp);
     jMediaRecorder1.SetAudioEncoder(fmtAmrNB);
     jMediaRecorder1.SetOutputFile(Self.GetEnvironmentDirectoryPath(dirMusic),  'mysound.3gp');
     jMediaRecorder1.Prepare();
     jMediaRecorder1.Start();
  end   //NEW! Target API >= 23
  else if IsRuntimePermissionGranted('android.permission.RECORD_AUDIO') and
          IsRuntimePermissionGranted('android.permission.WRITE_EXTERNAL_STORAGE')  then
      begin
         ShowMessage('Recording started ... [start]');
         jMediaRecorder1.SetAudioSource(asrcMic);
         jMediaRecorder1.SetOutputFormat(fmtThreeGpp);
         jMediaRecorder1.SetAudioEncoder(fmtAmrNB);
         jMediaRecorder1.SetOutputFile(Self.GetEnvironmentDirectoryPath(dirMusic),  'mysound.3gp');
         jMediaRecorder1.Prepare();
        jMediaRecorder1.Start();
      end
      else
      begin
        ShowMessage('Sorry.. [RECORD_AUDIO/WRITE_EXTERNAL_STORAGE] Permission NOT granted..');
      end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   ShowMessage('Audio recorded successfully ... [stop]');
   jMediaRecorder1.Stop();
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  jMediaPlayer1.SetDataSource(Self.GetEnvironmentDirectoryPath(dirMusic),  'mysound.3gp');
  jMediaPlayer1.Prepare();
end;

procedure TAndroidModule1.jMediaPlayer1Completion(Sender: TObject);
begin
   ShowMessage('Play END!');
   jMediaPlayer1.Reset();   // so you can "Play" again ...
end;

procedure TAndroidModule1.jMediaPlayer1Prepared(Sender: TObject;
  videoWidth: integer; videoHeight: integer);
begin
   jMediaPlayer1.Start();
end;

//https://www.captechconsulting.com/blogs/runtime-permissions-best-practices-and-how-to-gracefully-handle-permission-removal
//https://developer.android.com/guide/topics/security/permissions#normal-dangerous
//android.permission.RECORD_AUDIO

//ref. http://www.tutorialspoint.com/android/android_audio_capture.htm
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
var
  manifestPermissions: TDynArrayOfString;
begin
  if IsRuntimePermissionNeed() then   //NEW! support for "target API >= 23"
   begin
      ShowMessage('warning: Requesting Runtime Permission.... please,  wait!');

      SetLength(manifestPermissions, 2);

      manifestPermissions[0]:= 'android.permission.RECORD_AUDIO';  //from AndroodManifest.xml
      manifestPermissions[1]:= 'android.permission.WRITE_EXTERNAL_STORAGE'; //from AndroodManifest.xml

      Self.RequestRuntimePermission(manifestPermissions, 3001);

      SetLength(manifestPermissions, 0);
   end

end;

//handle RequestRuntimePermission ...S
procedure TAndroidModule1.AndroidModule1RequestPermissionResult(
  Sender: TObject; requestCode: integer; manifestPermission: string;
  grantResult: TManifestPermissionResult);
begin
  case requestCode of
      3001:begin
              if grantResult = PERMISSION_GRANTED  then
                  ShowMessage(manifestPermission + ' :: Success! Permission granted!!! ' )
              else  //PERMISSION_DENIED
                  ShowMessage(manifestPermission + ' :: Sorry... Permission not granted... ' );
           end;
  end;
end;

end.
