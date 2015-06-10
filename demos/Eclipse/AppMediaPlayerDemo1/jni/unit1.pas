{Hint: save all files to location: C:\adt32\eclipse\workspace\AppMediaPlayerDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget, surfaceview, mediaplayer;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jMediaPlayer1: jMediaPlayer;
    jPanel1: jPanel;
    jRadioButton1: jRadioButton;
    jRadioButton2: jRadioButton;
    jSurfaceView1: jSurfaceView;
    jTextView1: jTextView;
    procedure AndroidModule1Create(Sender: TObject);
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jMediaPlayer1Completion(Sender: TObject);
    procedure jMediaPlayer1Prepared(Sender: TObject; videoWidth: integer; videoHeigh: integer);
    procedure jMediaPlayer1TimedText(Sender: TObject; timedText: string);

    procedure jRadioButton1Click(Sender: TObject);
    procedure jRadioButton2Click(Sender: TObject);
    procedure jSurfaceView1SurfaceChanged(Sender: TObject; width: integer;
      height: integer);

    procedure jSurfaceView1SurfaceCreated(Sender: TObject; surfaceHolder: jObject);

  private
    {private declarations}
    FIsPrepared: boolean;
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

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
   FIsPrepared:= False;
   FVolumeR:= 0.6;  //[0.0 --> 1.0]
   FVolumeL:= 0.6;  //[0.0 --> 1.0]
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
 // FSaveBackColor:= jSurfaceView1.BackgroundColor;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if FIsPrepared then
  begin
    if jButton1.Text = 'Play' then
    begin
      jButton1.Text:= 'Pause';
      //jMediaPlayer1.SeekTo(0);  //play from beginning ...
      jMediaPlayer1.Start();
    end
    else
    begin
       jButton1.Text:= 'Play';
       jMediaPlayer1.Pause();
    end;
  end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  ShowMessage('Volume ++');

  FVolumeL:= FVolumeL + 0.1;
  if FVolumeL > 1.0 then FVolumeL:= 1.0;

  FVolumeR:= FVolumeR + 0.1;
  if FVolumeR > 1.0 then FVolumeR:= 1.0;

  jMediaPlayer1.SetVolume(FVolumeL, FVolumeR);
end;

procedure TAndroidModule1.jMediaPlayer1Completion(Sender: TObject);
begin
   ShowMessage('The End');
   jButton1.Text:= 'Play';
end;


//NOTE:  here is a good place to put "Start()"
procedure TAndroidModule1.jMediaPlayer1Prepared(Sender: TObject; videoWidth: integer; videoHeigh: integer);
begin
   FIsPrepared:= True;
   ShowMessage('Prepared ...');
   jButton1.Text:= 'Play';
end;

procedure TAndroidModule1.jMediaPlayer1TimedText(Sender: TObject;
  timedText: string);
begin
    ShowMessage('TimedText ...'+ timedText);
end;

procedure TAndroidModule1.jRadioButton1Click(Sender: TObject);
begin
  {http://site.com/audio/audio.mp3}
  {file:///sdcard/localfile.mp3  or /sdcard/localfile.mp3}
   if jRadioButton1.Checked then //music
   begin
      if jMediaPlayer1.IsPlaying() then jMediaPlayer1.Stop();
      jRadioButton2.Checked:= False;
      jMediaPlayer1.SetDataSource('pipershut2.mp3');  //from  .../assets
      ShowMessage('Music "pipershut2.mp3" Loaded ...  Preparing.. ');
      FIsPrepared:= False;
      jMediaPlayer1.Prepare();  //Dispatch --> OnPrepared !
   end;
end;

procedure TAndroidModule1.jRadioButton2Click(Sender: TObject);
begin
   {http://site.com/audio/audio.mp3}
   {file:///sdcard/localfile.mp3  or /sdcard/localfile.mp3}
   {bigbunny.mp4}   //default: from "assets"
    if jRadioButton2.Checked then //music
    begin
       if jMediaPlayer1.IsPlaying() then jMediaPlayer1.Stop();
       jRadioButton1.Checked:= False;
       jMediaPlayer1.SetDataSource('bigbunny.mp4');  //from  .../assets or 'http://bffmedia.com/bigbunny.mp4'
       ShowMessage('Video "bigbunny.mp4" Loaded ... Preparing.. ');
       FIsPrepared:= False;
       jMediaPlayer1.Prepare();  //Dispatch --> OnPrepared !
    end;
end;

procedure TAndroidModule1.jSurfaceView1SurfaceChanged(Sender: TObject;
  width: integer; height: integer);
begin
   ShowMessage('Surface Changed ...');
end;

//NOTE [to play video]:
//You can NOT do: jSurfaceView1.BackgroundColor:= colbrLightCyan
//you MUST leave it as colbrDefault !

procedure TAndroidModule1.jSurfaceView1SurfaceCreated(Sender: TObject; surfaceHolder: jObject);
var
   canv: jObject;
begin
    ShowMessage('Surface Created ...');

    canv:= jSurfaceView1.GetLockedCanvas();
    jSurfaceView1.DrawBackground(canv, colbrLightCyan);
    jSurfaceView1.SetPaintTextSize(30);                 //
    jSurfaceView1.DrawText(canv, 'Hello World!', 200,200);
    jSurfaceView1.UnLockCanvas(canv);

    jMediaPlayer1.SetDisplay(surfaceHolder); //need to play video !
end;

end.
