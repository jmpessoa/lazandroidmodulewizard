{Hint: save all files to location: C:\Temp\AppLAMWProject3\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, soundpool, mediaplayer, Laz_And_Controls, And_jni;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    btDrum: jButton;
    btPauseAll: jButton;
    btResumeAll: jButton;
    btPlaySong: jButton;
    btPlayLoop3: jButton;
    btVolUp: jButton;
    btVolDown: jButton;
    btRateDown: jButton;
    btRateUp: jButton;
    btStopSong: jButton;
    btPauseSong: jButton;
    btResumeSong: jButton;
    sp: jSoundPool;
    procedure AndroidModule1ActivityCreate(Sender: TObject; intentData: jObject
      );
    procedure btDrumClick(Sender: TObject);
    procedure btPlayLoop3Click(Sender: TObject);
    procedure btPauseAllClick(Sender: TObject);
    procedure btResumeAllClick(Sender: TObject);
    procedure btRateDownClick(Sender: TObject);
    procedure btRateUpClick(Sender: TObject);
    procedure btStopSongClick(Sender: TObject);
    procedure btPauseSongClick(Sender: TObject);
    procedure btResumeSongClick(Sender: TObject);
    procedure btPlaySongClick(Sender: TObject);
    procedure btVolDownClick(Sender: TObject);
    procedure btVolUpClick(Sender: TObject);
    procedure spLoadComplete(Sender: TObject; soundId: integer; status: integer
      );

  private
    {private declarations}
  public
    {public declarations}
    idSong, idDrum : integer;
    streamId : integer;
    vol, rate : single;
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1ActivityCreate(Sender: TObject;
  intentData: jObject);
begin
  idSong := sp.SoundLoad('sound.wav');
  idDrum := sp.SoundLoad('drum3.wav');

  vol  := 1;
  rate := 1;
end;

procedure TAndroidModule1.btDrumClick(Sender: TObject);
begin
  sp.SoundPlay(idDrum, 1,1,1,0,1);
end;

procedure TAndroidModule1.btPlayLoop3Click(Sender: TObject);
begin
 sp.StreamStop(streamId);
 streamId := sp.SoundPlay(idSong,vol,vol,10,3, rate);
end;

procedure TAndroidModule1.btPauseAllClick(Sender: TObject);
begin
  sp.PauseAll();
end;

procedure TAndroidModule1.btResumeAllClick(Sender: TObject);
begin
  sp.ResumeAll();
end;

procedure TAndroidModule1.btRateDownClick(Sender: TObject);
begin
  rate := rate - 0.1;
  sp.StreamSetRate(streamId, rate);
end;

procedure TAndroidModule1.btRateUpClick(Sender: TObject);
begin
  rate := rate + 0.1;
  sp.StreamSetRate(streamId, rate);
end;

procedure TAndroidModule1.btStopSongClick(Sender: TObject);
begin
  sp.StreamStop(streamId);
end;

procedure TAndroidModule1.btPauseSongClick(Sender: TObject);
begin
  sp.StreamPause(streamId);
end;

procedure TAndroidModule1.btResumeSongClick(Sender: TObject);
begin
  sp.StreamResume(streamId);
end;

procedure TAndroidModule1.btPlaySongClick(Sender: TObject);
begin
 sp.StreamStop(streamId);
 streamId := sp.SoundPlay(idSong,vol,vol,10,-1, rate);
end;

procedure TAndroidModule1.btVolDownClick(Sender: TObject);
begin
  vol := vol - 0.1;
  sp.StreamSetVolume(streamId, vol, vol);
end;

procedure TAndroidModule1.btVolUpClick(Sender: TObject);
begin
  vol := vol + 0.1;
  sp.StreamSetVolume(streamId, vol, vol);
end;

procedure TAndroidModule1.spLoadComplete(Sender: TObject; soundId: integer;
  status: integer);
begin
  if( soundId = idSong ) then // Play Loop
  begin
   streamId := sp.SoundPlay(idSong,vol,vol,10,-1, rate);

   showmessage('Song load soundId: ' + intToStr(soundId) + ' and play streamId: ' + intToStr(streamId));
  end;
end;

end.
