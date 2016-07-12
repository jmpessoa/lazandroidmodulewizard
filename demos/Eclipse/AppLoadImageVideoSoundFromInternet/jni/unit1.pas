{Hint: save all files to location: C:\adt32\eclipse\workspace\AppLoadImageVideoSoundFromInternet\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, imagefilemanager, mediaplayer,
  surfaceview;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jAsyncTask1: jAsyncTask;
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jCheckBox1: jCheckBox;
    jDialogProgress1: jDialogProgress;
    jImageFileManager1: jImageFileManager;
    jImageView1: jImageView;
    jMediaPlayer1: jMediaPlayer;
    jSurfaceView1: jSurfaceView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jAsyncTask1DoInBackground(Sender: TObject; progress: integer; out
      keepInBackground: boolean);
    procedure jAsyncTask1PostExecute(Sender: TObject; progress: integer);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);
    procedure jMediaPlayer1Completion(Sender: TObject);
    procedure jMediaPlayer1Prepared(Sender: TObject; videoWidth: integer;
      videoHeight: integer);
    procedure jSurfaceView1SurfaceCreated(Sender: TObject;
      surfaceHolder: jObject);
  private
    {private declarations}
    FActionType: integer;
  public
    {public declarations}

  end;

var
  AndroidModule1: TAndroidModule1;
  FImageBitmap: jObject;

implementation

{$R *.lfm}

{ TAndroidModule1 }

//try Wifi ...
procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
    if not Self.isConnected() then
  begin //try wifi
    if Self.SetWifiEnabled(True) then
      jCheckBox1.Checked:= True
    else
      ShowMessage('Please,  try enable some connection...');
  end
  else
  begin
     if Self.isConnectedWifi() then jCheckBox1.Checked:= True
  end;
end;

procedure TAndroidModule1.jAsyncTask1DoInBackground(Sender: TObject;
  progress: integer; out keepInBackground: boolean);
begin
   case FActionType of
     1: begin //sound
             jMediaPlayer1.SetDataSource('http://www.hrupin.com/wp-content/uploads/mp3/testsong_20_sec.mp3');
             jMediaPlayer1.Prepare();  ////Dispatch --> OnPrepared !
        end;

     2: begin //image
              FImageBitmap:= jImageFileManager1.LoadFromURL('http://miftyisbored.com/wp-content/uploads/2013/07/nature-sound-spa-app.png'); //'http://i.imgur.com/n2lQnkI.png
              FImageBitmap:= Get_jObjGlobalRef(FImageBitmap);
        end;

      3: begin  //video
           jMediaPlayer1.SetDataSource('http://bffmedia.com/bigbunny.mp4');
           jMediaPlayer1.Prepare();  ////Dispatch --> OnPrepared !
         end;
   end;
   keepInBackground:= False;
end;

procedure TAndroidModule1.jAsyncTask1PostExecute(Sender: TObject;
  progress: integer);
begin
  jAsyncTask1.Done;
  jDialogProgress1.Stop;
  if FImageBitmap <> nil then
  begin
     jImageView1.SetImageBitmap(FImageBitmap);
     Delete_jGlobalRef(FImageBitmap);
     FImageBitmap:= nil;
  end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  FActionType:= 1;
  if not jAsyncTask1.Running then
  begin
    jDialogProgress1.Start;
    jAsyncTask1.Execute;    //Dispatch --> DoInBackground!
  end
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  FActionType:= 2;
  if not jAsyncTask1.Running then
  begin
    jDialogProgress1.Start;
    jAsyncTask1.Execute;    //Dispatch --> DoInBackground
  end
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  FActionType:= 3;
  if not jAsyncTask1.Running then
  begin
    jDialogProgress1.Start;
    jAsyncTask1.Execute;   //Dispatch --> DoInBackground
  end
end;

//here Start/Play  the Sound/Video
procedure TAndroidModule1.jMediaPlayer1Prepared(Sender: TObject;
  videoWidth: integer; videoHeight: integer);
begin
  jMediaPlayer1.Start();
end;

//needed to Show Video
procedure TAndroidModule1.jSurfaceView1SurfaceCreated(Sender: TObject;
  surfaceHolder: jObject);
begin
   jMediaPlayer1.SetDisplay(surfaceHolder);
end;

//Sound/Video End ...!
procedure TAndroidModule1.jMediaPlayer1Completion(Sender: TObject);
begin
   ShowMessage('The End!');
end;

end.
