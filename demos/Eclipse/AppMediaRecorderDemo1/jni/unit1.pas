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
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jMediaPlayer1Completion(Sender: TObject);
    procedure jMediaPlayer1Prepared(Sender: TObject; videoWidth: integer;
      videoHeight: integer);
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
   ShowMessage('Recording started ... [start]');
   jMediaRecorder1.Start();
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

//ref. http://www.tutorialspoint.com/android/android_audio_capture.htm
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jMediaRecorder1.SetAudioSource(asrcMic);
  jMediaRecorder1.SetOutputFormat(fmtThreeGpp);
  jMediaRecorder1.SetAudioEncoder(fmtAmrNB);
  jMediaRecorder1.SetOutputFile(Self.GetEnvironmentDirectoryPath(dirMusic),  'mysound.3gp');
  jMediaRecorder1.Prepare();
end;

end.
