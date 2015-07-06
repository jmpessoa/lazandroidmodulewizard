{Hint: save all files to location: C:\adt32\eclipse\workspace\AppTryCode2\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, AndroidWidget, mediaplayer,
  textfilemanager, surfaceview;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jMediaPlayer1: jMediaPlayer;
      jSurfaceView1: jSurfaceView;
      jTextView1: jTextView;
      procedure DataModuleCreate(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
      procedure jMediaPlayer1Completion(Sender: TObject);
      procedure jMediaPlayer1Prepared(Sender: TObject; videoWidth: integer; videoHeigh: integer);
      procedure jSurfaceView1SurfaceCreated(Sender: TObject; surfaceHolder: jObject);
      procedure jSurfaceView1SurfaceDraw(Sender: TObject; canvas: jObject);
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
end;

{
   http://android-coding.blogspot.com.br/2012/10/get-video-width-and-height-of.html

   http://www.java2s.com/Code/Android/Media/GetVideosize.htm

mp.setDataSource("/sdcard/someVideo.mp4");
    mp.prepare();

    //Get the dimensions of the video
    int videoWidth = mp.getVideoWidth();
    int videoHeight = mp.getVideoHeight();

    //Get the width of the screen
    int screenWidth = getWindowManager().getDefaultDisplay().getWidth();

    //Get the SurfaceView layout parameters
    android.view.ViewGroup.LayoutParams lp = mSurfaceView.getLayoutParams();

    //Set the width of the SurfaceView to the width of the screen
    lp.width = screenWidth;

    //Set the height of the SurfaceView to match the aspect ratio of the video
    //be sure to cast these as floats otherwise the calculation will likely be 0
    lp.height = (int) (((float)videoHeight / (float)videoWidth) * (float)screenWidth);

    //Commit the layout parameters
    mSurfaceView.setLayoutParams(lp);

    //Start video
    mp.start();
}


{
String vidAddress = "https://archive.org/download/ksnn_compilation_master_the_internet/ksnn_compilation_master_the_internet_512kb.mp4";
String videoSrc = "http://bffmedia.com/bigbunny.mp4";
String videoToPlay = "rtsp://v6.cache1.c.youtube.com/CjYLENy73wIaLQkDsLHya4-Z9hMYDSANFEIJbXYtZ29vZ2xlSARSBXdhdGNoYKX4k4uBjbOiUQw=/0/0/0/video.3gp";
}
procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  {http://site.com/audio/audio.mp3}
  {file:///sdcard/localfile.mp3}
  {/sdcard/localfile.mp3}
  {bigbunny.mp4}   //default: from "assets"
  if not FIsLoaded then
  begin                         //http://bffmedia.com/bigbunny.mp4
     jMediaPlayer1.SetDataSource('bigbunny.mp4');  //from  .../assets...  or pipershut2.mp3
     FIsLoaded:= True;

     ShowMessage('Loaded "bigbunny.mp4" from Assets!');

     //or ShowMessage('Loaded "pipershut2.mp3" from Assets!');

     jMediaPlayer1.Prepare();  //Dispatch --> OnPrepared !
  end;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   jMediaPlayer1.SeekTo(0);  //play sound from beginning
   jMediaPlayer1.Start();
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
  ShowMessage('Paused ...');
end;

procedure TAndroidModule1.jMediaPlayer1Completion(Sender: TObject);
begin
   ShowMessage('The End...');
end;

procedure TAndroidModule1.jMediaPlayer1Prepared(Sender: TObject; videoWidth: integer; videoHeigh: integer);
begin
  ShowMessage('Prepared ...');

  jSurfaceView1.DispatchOnDraw(True); //true = Allows us to use Refresh() to call onDraw() event!
  jSurfaceView1.Refresh();            // <<------- "invalidate()" This must be called from a UI thread

  //NOTE: jSurfaceView1.PostInvalidate();  // << ------- "postInvalidate()" To call from a non-UI thread
end;

  //http://code.tutsplus.com/tutorials/streaming-video-in-android-apps--cms-19888
procedure TAndroidModule1.jSurfaceView1SurfaceCreated(Sender: TObject; surfaceHolder: jObject);
begin
   ShowMessage('SurfaceCreated ...');
   jMediaPlayer1.SetDisplay(surfaceHolder);
end;

procedure TAndroidModule1.jSurfaceView1SurfaceDraw(Sender: TObject; canvas: jObject);
begin
   jSurfaceView1.DrawLine(canvas, 20, 20, 300, 300);
end;

end.
