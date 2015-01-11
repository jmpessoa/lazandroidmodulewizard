{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTryCode2\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, AndroidWidget, mediaplayer,
  textfilemanager;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jMediaPlayer1: jMediaPlayer;
      jTextView1: jTextView;
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
    private
      {private declarations}
      FIsLoaded: boolean;
      FVolumeR: real;
      FVolumeL: real;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.DataModuleCreate(Sender: TObject);
begin
   FVolumeR:= 0.6;
   FVolumeL:= 0.6;
   FIsLoaded:= False;
   Self.OnJNIPrompt:= DataModuleJNIPrompt;
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
   Self.Show;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  {http://site.com/audio/audio.mp3}
  {file:///sdcard/localfile.mp3}
  {/sdcard/localfile.mp3}
  if not FIsLoaded then
  begin
     jMediaPlayer1.SetDataSource('pipershut2.mp3');  //from Assets...
     jMediaPlayer1.Prepare();
     FIsLoaded:= True;
  end;
  ShowMessage('Loaded "pipershut2.mp3" from Assets!');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   //jMediaPlayer1.SeekTo(0);  //    // play sound from beginning
   jMediaPlayer1.Start();
   ShowMessage('Playing...');
end;

// 0.0 is silent and 1.0 is maximum volume
procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  ShowMessage('Volume ++');

  FVolumeL:= FVolumeL + 0.1;
  if FVolumeL > 1.0 then FVolumeL:= 1.0;

  FVolumeR:= FVolumeR + 0.1;
  if FVolumeR > 1.0 then FVolumeR:= 1.0;

  jMediaPlayer1.SetVolume(FVolumeL, FVolumeR);
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
begin
  if jMediaPlayer1.IsPlaying() then jMediaPlayer1.Pause();
   ShowMessage('Paused...');
end;

end.
